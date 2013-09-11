Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3IKQ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:27:26 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39310 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab3IKQ1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:27:25 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: =?utf-8?q?Jos=C3=A9_Miguel_Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
Date: Wed, 11 Sep 2013 18:27:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
In-Reply-To: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201309111827.39981.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 11. September 2013, 10:46:13 schrieb José Miguel Gonçalves:
> Some GPIO line limits are incorrectly set which, for instance,
> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
> 
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>

I thumbed thru the SoC manuals of s3c2410, s3c2416, s3c2440 and s3c2443 and 
these number look correct.

It would be interesting to know where the old number 16 for GPIOB did come 
from, as _all_ S3C SoCs only have the 11 pins in this bank.


Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----
>  drivers/gpio/gpio-samsung.c               |    6 +++---
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/include/mach/gpio.h
> b/arch/arm/mach-s3c24xx/include/mach/gpio.h index 1459156..a1435bc 100644
> --- a/arch/arm/mach-s3c24xx/include/mach/gpio.h
> +++ b/arch/arm/mach-s3c24xx/include/mach/gpio.h
> @@ -31,17 +31,17 @@
>   *   2410 2412 2440 2443 2416
>   *             2442
>   *   ---- ---- ---- ---- ----
> - * A  23   22   25   16   25
> - * B  11   11   11   11   9
> - * C  16   15   16   16   16
> + * A  23   22   25   16   27
> + * B  11   11   11   11   11
> + * C  16   16   16   16   16
>   * D  16   16   16   16   16
>   * E  16   16   16   16   16
>   * F  8    8    8    8    8
>   * G  16   16   16   16   8
> - * H  11   11   9    15   15
> + * H  11   11   11   15   15
>   * J  --   --   13   16   --
>   * K  --   --   --   --   16
> - * L  --   --   --   15   7
> + * L  --   --   --   15   14
>   * M  --   --   --   2    2
>   */
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 358a21c..29c428b 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -1053,7 +1053,7 @@ struct samsung_gpio_chip s3c24xx_gpios[] = {
>  			.base			= S3C2410_GPA(0),
>  			.owner			= THIS_MODULE,
>  			.label			= "GPIOA",
> -			.ngpio			= 24,
> +			.ngpio			= 27,
>  			.direction_input	= s3c24xx_gpiolib_banka_input,
>  			.direction_output	= s3c24xx_gpiolib_banka_output,
>  		},
> @@ -1062,7 +1062,7 @@ struct samsung_gpio_chip s3c24xx_gpios[] = {
>  			.base	= S3C2410_GPB(0),
>  			.owner	= THIS_MODULE,
>  			.label	= "GPIOB",
> -			.ngpio	= 16,
> +			.ngpio	= 11,
>  		},
>  	}, {
>  		.chip	= {
> @@ -1107,7 +1107,7 @@ struct samsung_gpio_chip s3c24xx_gpios[] = {
>  			.base	= S3C2410_GPH(0),
>  			.owner	= THIS_MODULE,
>  			.label	= "GPIOH",
> -			.ngpio	= 11,
> +			.ngpio	= 15,
>  		},
>  	},
>  		/* GPIOS for the S3C2443 and later devices. */

