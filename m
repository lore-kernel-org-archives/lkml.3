Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaHZULb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:11:31 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55516 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHZUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:11:28 -0400
Message-ID: <53FCE9ED.1040505@kernel.org>
Date: Tue, 26 Aug 2014 21:11:25 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>, kgene.kim@samsung.com
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] iio: remove .owner field for driver using module_platform_driver
References: <1408527157-9318-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1408527157-9318-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/14 10:32, Sanjeev Sharma wrote:
> This patch removes the .owner field for drivers which use the
> platform_driver_register api because this is overriden in
> _platform_driver_register.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Thanks for cleaning these up.

Applied to the togreg branch of iio.git - initially pushed out
as testing for the autobuilders to do their stuff.

Jonathan
> ---
>  drivers/iio/accel/hid-sensor-accel-3d.c       | 1 -
>  drivers/iio/adc/exynos_adc.c                  | 1 -
>  drivers/iio/adc/lp8788_adc.c                  | 1 -
>  drivers/iio/adc/ti_am335x_adc.c               | 1 -
>  drivers/iio/adc/twl4030-madc.c                | 1 -
>  drivers/iio/adc/twl6030-gpadc.c               | 1 -
>  drivers/iio/adc/vf610_adc.c                   | 1 -
>  drivers/iio/adc/viperboard_adc.c              | 1 -
>  drivers/iio/gyro/hid-sensor-gyro-3d.c         | 1 -
>  drivers/iio/humidity/dht11.c                  | 1 -
>  drivers/iio/light/hid-sensor-als.c            | 1 -
>  drivers/iio/light/hid-sensor-prox.c           | 1 -
>  drivers/iio/light/lm3533-als.c                | 1 -
>  drivers/iio/magnetometer/hid-sensor-magn-3d.c | 1 -
>  drivers/iio/orientation/hid-sensor-incl-3d.c  | 1 -
>  drivers/iio/orientation/hid-sensor-rotation.c | 1 -
>  drivers/iio/pressure/hid-sensor-press.c       | 1 -
>  drivers/iio/trigger/iio-trig-interrupt.c      | 1 -
>  18 files changed, 18 deletions(-)
> 
> diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
> index 54e464e..d5d9531 100644
> --- a/drivers/iio/accel/hid-sensor-accel-3d.c
> +++ b/drivers/iio/accel/hid-sensor-accel-3d.c
> @@ -419,7 +419,6 @@ static struct platform_driver hid_accel_3d_platform_driver = {
>  	.id_table = hid_accel_3d_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_accel_3d_probe,
>  	.remove		= hid_accel_3d_remove,
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index fc9dfc2..b4373f7 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -606,7 +606,6 @@ static struct platform_driver exynos_adc_driver = {
>  	.remove		= exynos_adc_remove,
>  	.driver		= {
>  		.name	= "exynos-adc",
> -		.owner	= THIS_MODULE,
>  		.of_match_table = exynos_adc_match,
>  		.pm	= &exynos_adc_pm_ops,
>  	},
> diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
> index 5c8c915..152cfc8 100644
> --- a/drivers/iio/adc/lp8788_adc.c
> +++ b/drivers/iio/adc/lp8788_adc.c
> @@ -244,7 +244,6 @@ static struct platform_driver lp8788_adc_driver = {
>  	.remove = lp8788_adc_remove,
>  	.driver = {
>  		.name = LP8788_DEV_ADC,
> -		.owner = THIS_MODULE,
>  	},
>  };
>  module_platform_driver(lp8788_adc_driver);
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index d5dc4c6..b730864 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -545,7 +545,6 @@ MODULE_DEVICE_TABLE(of, ti_adc_dt_ids);
>  static struct platform_driver tiadc_driver = {
>  	.driver = {
>  		.name   = "TI-am335x-adc",
> -		.owner	= THIS_MODULE,
>  		.pm	= TIADC_PM_OPS,
>  		.of_match_table = ti_adc_dt_ids,
>  	},
> diff --git a/drivers/iio/adc/twl4030-madc.c b/drivers/iio/adc/twl4030-madc.c
> index eb86786..94c5f05 100644
> --- a/drivers/iio/adc/twl4030-madc.c
> +++ b/drivers/iio/adc/twl4030-madc.c
> @@ -883,7 +883,6 @@ static struct platform_driver twl4030_madc_driver = {
>  	.remove = twl4030_madc_remove,
>  	.driver = {
>  		   .name = "twl4030_madc",
> -		   .owner = THIS_MODULE,
>  		   .of_match_table = of_match_ptr(twl_madc_of_match),
>  	},
>  };
> diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
> index 15282f1..89d8aa1 100644
> --- a/drivers/iio/adc/twl6030-gpadc.c
> +++ b/drivers/iio/adc/twl6030-gpadc.c
> @@ -994,7 +994,6 @@ static struct platform_driver twl6030_gpadc_driver = {
>  	.remove		= twl6030_gpadc_remove,
>  	.driver		= {
>  		.name	= DRIVER_NAME,
> -		.owner	= THIS_MODULE,
>  		.pm	= &twl6030_gpadc_pm_ops,
>  		.of_match_table = of_twl6030_match_tbl,
>  	},
> diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
> index 44799eb5..4a10ae9 100644
> --- a/drivers/iio/adc/vf610_adc.c
> +++ b/drivers/iio/adc/vf610_adc.c
> @@ -698,7 +698,6 @@ static struct platform_driver vf610_adc_driver = {
>  	.remove         = vf610_adc_remove,
>  	.driver         = {
>  		.name   = DRIVER_NAME,
> -		.owner  = THIS_MODULE,
>  		.of_match_table = vf610_adc_match,
>  		.pm     = &vf610_adc_pm_ops,
>  	},
> diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
> index 9acf6b6..3be2e35 100644
> --- a/drivers/iio/adc/viperboard_adc.c
> +++ b/drivers/iio/adc/viperboard_adc.c
> @@ -145,7 +145,6 @@ static int vprbrd_adc_probe(struct platform_device *pdev)
>  static struct platform_driver vprbrd_adc_driver = {
>  	.driver = {
>  		.name	= "viperboard-adc",
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= vprbrd_adc_probe,
>  };
> diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
> index fa034a3..a3ea1e8 100644
> --- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
> +++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
> @@ -416,7 +416,6 @@ static struct platform_driver hid_gyro_3d_platform_driver = {
>  	.id_table = hid_gyro_3d_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_gyro_3d_probe,
>  	.remove		= hid_gyro_3d_remove,
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index d8771f5..623c145 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c
> @@ -281,7 +281,6 @@ static int dht11_probe(struct platform_device *pdev)
>  static struct platform_driver dht11_driver = {
>  	.driver = {
>  		.name	= DRIVER_NAME,
> -		.owner	= THIS_MODULE,
>  		.of_match_table = dht11_dt_ids,
>  	},
>  	.probe  = dht11_probe,
> diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
> index 96e71e1..a5283d7 100644
> --- a/drivers/iio/light/hid-sensor-als.c
> +++ b/drivers/iio/light/hid-sensor-als.c
> @@ -381,7 +381,6 @@ static struct platform_driver hid_als_platform_driver = {
>  	.id_table = hid_als_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_als_probe,
>  	.remove		= hid_als_remove,
> diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
> index 412bae8..f5a5146 100644
> --- a/drivers/iio/light/hid-sensor-prox.c
> +++ b/drivers/iio/light/hid-sensor-prox.c
> @@ -373,7 +373,6 @@ static struct platform_driver hid_prox_platform_driver = {
>  	.id_table = hid_prox_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_prox_probe,
>  	.remove		= hid_prox_remove,
> diff --git a/drivers/iio/light/lm3533-als.c b/drivers/iio/light/lm3533-als.c
> index c1aadc6..ae3c71b 100644
> --- a/drivers/iio/light/lm3533-als.c
> +++ b/drivers/iio/light/lm3533-als.c
> @@ -915,7 +915,6 @@ static int lm3533_als_remove(struct platform_device *pdev)
>  static struct platform_driver lm3533_als_driver = {
>  	.driver	= {
>  		.name	= "lm3533-als",
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= lm3533_als_probe,
>  	.remove		= lm3533_als_remove,
> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> index 3ec777a..03a13d4 100644
> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> @@ -533,7 +533,6 @@ static struct platform_driver hid_magn_3d_platform_driver = {
>  	.id_table = hid_magn_3d_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_magn_3d_probe,
>  	.remove		= hid_magn_3d_remove,
> diff --git a/drivers/iio/orientation/hid-sensor-incl-3d.c b/drivers/iio/orientation/hid-sensor-incl-3d.c
> index 2478f6c..1ff181b 100644
> --- a/drivers/iio/orientation/hid-sensor-incl-3d.c
> +++ b/drivers/iio/orientation/hid-sensor-incl-3d.c
> @@ -437,7 +437,6 @@ static struct platform_driver hid_incl_3d_platform_driver = {
>  	.id_table = hid_incl_3d_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_incl_3d_probe,
>  	.remove		= hid_incl_3d_remove,
> diff --git a/drivers/iio/orientation/hid-sensor-rotation.c b/drivers/iio/orientation/hid-sensor-rotation.c
> index dccf848..4afb6c7 100644
> --- a/drivers/iio/orientation/hid-sensor-rotation.c
> +++ b/drivers/iio/orientation/hid-sensor-rotation.c
> @@ -334,7 +334,6 @@ static struct platform_driver hid_dev_rot_platform_driver = {
>  	.id_table = hid_dev_rot_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_dev_rot_probe,
>  	.remove		= hid_dev_rot_remove,
> diff --git a/drivers/iio/pressure/hid-sensor-press.c b/drivers/iio/pressure/hid-sensor-press.c
> index 2c0d2a4..7649286 100644
> --- a/drivers/iio/pressure/hid-sensor-press.c
> +++ b/drivers/iio/pressure/hid-sensor-press.c
> @@ -382,7 +382,6 @@ static struct platform_driver hid_press_platform_driver = {
>  	.id_table = hid_press_ids,
>  	.driver = {
>  		.name	= KBUILD_MODNAME,
> -		.owner	= THIS_MODULE,
>  	},
>  	.probe		= hid_press_probe,
>  	.remove		= hid_press_remove,
> diff --git a/drivers/iio/trigger/iio-trig-interrupt.c b/drivers/iio/trigger/iio-trig-interrupt.c
> index 7a149a7..572bc6f 100644
> --- a/drivers/iio/trigger/iio-trig-interrupt.c
> +++ b/drivers/iio/trigger/iio-trig-interrupt.c
> @@ -109,7 +109,6 @@ static struct platform_driver iio_interrupt_trigger_driver = {
>  	.remove = iio_interrupt_trigger_remove,
>  	.driver = {
>  		.name = "iio_interrupt_trigger",
> -		.owner = THIS_MODULE,
>  	},
>  };
>  
> 
