Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3DWPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:38:01 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48529 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3DWPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:37:59 -0400
Date: Tue, 23 Apr 2013 08:37:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Ulf Hofemeier <ulf.hofemeier@intel.com>,
        Hui Wang <jason77.wang@gmail.com>
Subject: Re: [PATCH] input: egalax_ts: remove bogus OF dependency
Message-ID: <20130423153754.GA4104@core.coreip.homeip.net>
References: <1366708088.9823.16.camel@sauron.fi.intel.com>
 <1366715357-9392-1-git-send-email-artem.bityutskiy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366715357-9392-1-git-send-email-artem.bityutskiy@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 02:09:17PM +0300, Artem Bityutskiy wrote:
> There are platforms using this driver which do not have OF. However, commit
> ae495e844a77344fdaedbb2ad97d925d096e9f0d added a Kconfig dependency on OF and
> broke OF-less setups.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: stable@vger.kernel.org [v3.7+]
> ---
>  drivers/input/touchscreen/Kconfig     |    2 +-
>  drivers/input/touchscreen/egalax_ts.c |    2 ++
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 515cfe7..d53b0d6 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -227,7 +227,7 @@ config TOUCHSCREEN_EETI
>  
>  config TOUCHSCREEN_EGALAX
>  	tristate "EETI eGalax multi-touch panel support"
> -	depends on I2C && OF
> +	depends on I2C

No, because egalax_wake_up_device() needs OF data and with !CONFIG_OF
you'll end up using stubs, the wakeup will fail and the touchscreen will
fail probe.

It wasn't tested, was it?

Thanks.

>  	help
>  	  Say Y here to enable support for I2C connected EETI
>  	  eGalax multi-touch panels.
> diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
> index 17c9097..b984cfc 100644
> --- a/drivers/input/touchscreen/egalax_ts.c
> +++ b/drivers/input/touchscreen/egalax_ts.c
> @@ -287,10 +287,12 @@ static int egalax_ts_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(egalax_ts_pm_ops, egalax_ts_suspend, egalax_ts_resume);
>  
> +#ifdef CONFIG_OF
>  static struct of_device_id egalax_ts_dt_ids[] = {
>  	{ .compatible = "eeti,egalax_ts" },
>  	{ /* sentinel */ }
>  };
> +#endif
>  
>  static struct i2c_driver egalax_ts_driver = {
>  	.driver = {
> -- 
> 1.7.7
> 

-- 
Dmitry
