Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3EBVKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:10:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55570 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab3EBVKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:10:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-pm@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Thu, 02 May 2013 23:18:21 +0200
Message-ID: <1474315.q4folvZv3e@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com>
References: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 10:09:22 AM Jingoo Han wrote:
> Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> to be assigned without having an #define xxx NULL for the case that PM is
> not enabled.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

I've queued this up as v3.11 material.

Thanks,
Rafael


> ---
>  drivers/i2c/busses/i2c-s3c2410.c |    8 +-------
>  include/linux/pm.h               |    2 ++
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index 6e8ee92..e7b6639 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  }
>  #endif
>  
> -#ifdef CONFIG_PM
>  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #ifdef CONFIG_PM_SLEEP
>  	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
> @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #endif
>  };
>  
> -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> -#else
> -#define S3C24XX_DEV_PM_OPS NULL
> -#endif
> -
>  /* device driver for platform bus bits */
>  
>  static struct platform_driver s3c24xx_i2c_driver = {
> @@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
>  	.driver		= {
>  		.owner	= THIS_MODULE,
>  		.name	= "s3c-i2c",
> -		.pm	= S3C24XX_DEV_PM_OPS,
> +		.pm	= pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
>  		.of_match_table = of_match_ptr(s3c24xx_i2c_match),
>  	},
>  };
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index a224c7f..bd50d15 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -55,8 +55,10 @@ struct device;
>  
>  #ifdef CONFIG_PM
>  extern const char power_group_name[];		/* = "power" */
> +#define pm_ops_ptr(_ptr)	(_ptr)
>  #else
>  #define power_group_name	NULL
> +#define pm_ops_ptr(_ptr)	NULL
>  #endif
>  
>  typedef struct pm_message {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
