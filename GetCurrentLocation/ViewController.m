//
//  ViewController.m
//  GetCurrentLocation
//
//  Created by Tue Hoang Trong on 3/11/14.
//  Copyright (c) 2014 demo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFaileWithError: %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail to get you location!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"didUpdateLocations: %@", locations);
    
    CLLocation *location = [locations lastObject];
    if (location != nil)
    {
        _longitude.text = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
        _latitude.text = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
    }
    
    NSLog(@"Resolving address...");
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
       
        NSLog(@"found placemarks %@, error %@", placemarks, error);
        
        if (error == nil && [placemarks count] >  0){
            placemark = [placemarks lastObject];
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                  placemark.subThoroughfare, placemark.thoroughfare,
                                  placemark.postalCode, placemark.locality,
                                  placemark.administrativeArea,
                                  placemark.country];
        }else{
            NSLog(@"%@", error.debugDescription);
        }
        
    }];
    
}

@end
