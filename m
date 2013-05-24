Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3EXO6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:58:52 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56032 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab3EXO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:58:50 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 24 May 2013 07:59:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/5] watchdog: da9055: use platform_{get,set}_drvdata()
Message-ID: <20130524145907.GD6085@roeck-us.net>
References: <003601ce57a2$7d2617d0$77724770$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003601ce57a2$7d2617d0$77724770$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 07:44:23PM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/da9055_wdt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
> index f5ad105..575f37a 100644
> --- a/drivers/watchdog/da9055_wdt.c
> +++ b/drivers/watchdog/da9055_wdt.c
> @@ -174,7 +174,7 @@ static int da9055_wdt_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	dev_set_drvdata(&pdev->dev, driver_data);
> +	platform_set_drvdata(pdev, driver_data);
>  
>  	ret = watchdog_register_device(&driver_data->wdt);
>  	if (ret != 0)
> @@ -187,7 +187,7 @@ err:
>  
>  static int da9055_wdt_remove(struct platform_device *pdev)
>  {
> -	struct da9055_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
> +	struct da9055_wdt_data *driver_data = platform_get_drvdata(pdev);
>  
>  	watchdog_unregister_device(&driver_data->wdt);
>  	kref_put(&driver_data->kref, da9055_wdt_release_resources);
> -- 
> 1.7.10.4
> 
> 
> 
