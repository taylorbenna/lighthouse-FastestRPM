//
//  ViewController.m
//  FastestRPM
//
//  Created by Taylor Benna on 2016-05-12.
//  Copyright © 2016 Taylor Benna. All rights reserved.
//

#import "ViewController.h"

#define RADIANS(degrees) ((M_PI * degrees) / 180.0)
#define MIN_DEGREES -135
#define MAX_DEGREES 135
#define RANGE_DEGREES (MAX_DEGREES - MIN_DEGREES)

#define LIMIT_VELOCITY 7500.0
#define LIMIT_VELOCITY_DELTA 10.0

#define RESET_DELAY 0.1
#define VELOCITY_DELAY 0.1


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *needle;
@property (nonatomic) CGFloat currentVelocity;
@property (nonatomic) CGFloat maxVelocity;

@property (weak, nonatomic) IBOutlet UILabel *velocityLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.needle.transform = CGAffineTransformMakeRotation(RADIANS(MIN_DEGREES));
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)panGestureStart:(UIPanGestureRecognizer *)sender {
    CGPoint velo = [sender velocityInView:self.view];
    CGFloat velocity = sqrt(pow(velo.x,2) + pow(velo.y,2));
    [self moveNeedleWithVelocity:velocity];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1.0 delay:RESET_DELAY options:UIViewAnimationCurveLinear animations:^{
            self.needle.transform = CGAffineTransformMakeRotation(RADIANS(0));
        } completion:^(BOOL finished) {}];
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.needle.transform = CGAffineTransformMakeRotation(RADIANS(MIN_DEGREES));
        } completion:^(BOOL finished) {}];
    }
}

- (void)moveNeedleWithVelocity:(CGFloat)velocity {
    
    self.currentVelocity = velocity;
    if (self.currentVelocity >= LIMIT_VELOCITY) {
        self.currentVelocity = LIMIT_VELOCITY;
    }
    
    // Calculate velocity of pan motion
    self.maxVelocity = MAX(self.maxVelocity, velocity);
    self.velocityLabel.text = [NSString stringWithFormat:@"Fastest: %.4f",self.maxVelocity];

    
    // Calculate proportion of current velocity to velocity limit
    CGFloat velocityProportion = velocity / LIMIT_VELOCITY;
    
    // Calculate proportion of RPM needle degree range
    CGFloat degrees = MIN(RANGE_DEGREES * velocityProportion, RANGE_DEGREES);
    degrees = degrees - MAX_DEGREES;
    
    // Move needle in degree range proportionate to velocity
    [UIView animateWithDuration:VELOCITY_DELAY animations:^{
        self.needle.transform = CGAffineTransformMakeRotation(RADIANS(degrees));

    }];
}


@end