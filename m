Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIVTyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:54:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44821 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaIVTya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:54:30 -0400
Date: Mon, 22 Sep 2014 12:54:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: wim@iguana.be, groeck7@gmail.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: imx2_wdt: Add power management support.
Message-ID: <20140922195425.GA2071@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:00:52PM +0800, Xiubo Li wrote:
> Add power management operations(suspend and resume) as part of
> dev_pm_ops for IMX2 watchdog driver.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/watchdog/imx2_wdt.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 68c3d37..941c36f 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -295,6 +295,52 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
>  	}
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +/* Disable watchdog if it is active during suspend */
> +static int imx2_wdt_suspend(struct device *dev)
> +{
> +	struct watchdog_device *wdog = dev_get_drvdata(dev);
> +	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
> +
> +	imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
> +	imx2_wdt_ping(wdog);
> +
> +	/* Watchdog has been stopped but IP block is still running */
> +	if (!watchdog_active(&wdog) && imx2_wdt_is_running(wdev))

Turns out this has a bug.

s/&wdog/wdog/

Please resubmit.

Thanks,
Guenter
