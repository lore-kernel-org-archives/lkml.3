Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbaKTJPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:15:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbaKTJPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:15:50 -0500
Message-ID: <546DB13C.7010301@ti.com>
Date: Thu, 20 Nov 2014 14:45:40 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <andrew.kim@intel.com>
Subject: Re: [PATCHv5 4/7] arm: omap3: twl: remove usb phy init data
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com> <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wednesday 19 November 2014 08:58 PM, Heikki Krogerus wrote:
> The driver does no use it any more.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

This version is slightly different from the one you gave your Acked-by.

So are you okay if I merge this with your Acked-by?

Thanks
Kishon
> ---
>  arch/arm/mach-omap2/twl-common.c | 12 +-----------
>  include/linux/i2c/twl.h          |  2 --
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index b0d54da..4457e73 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -91,18 +91,8 @@ void __init omap_pmic_late_init(void)
>  }
>  
>  #if defined(CONFIG_ARCH_OMAP3)
> -struct phy_consumer consumers[] = {
> -	PHY_CONSUMER("musb-hdrc.0", "usb"),
> -};
> -
> -struct phy_init_data init_data = {
> -	.consumers = consumers,
> -	.num_consumers = ARRAY_SIZE(consumers),
> -};
> -
>  static struct twl4030_usb_data omap3_usb_pdata = {
> -	.usb_mode	= T2_USB_MODE_ULPI,
> -	.init_data	= &init_data,
> +	.usb_mode = T2_USB_MODE_ULPI,
>  };
>  
>  static int omap3_batt_table[] = {
> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index 8cfb50f..0bc03f1 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -26,7 +26,6 @@
>  #define __TWL_H_
>  
>  #include <linux/types.h>
> -#include <linux/phy/phy.h>
>  #include <linux/input/matrix_keypad.h>
>  
>  /*
> @@ -634,7 +633,6 @@ enum twl4030_usb_mode {
>  struct twl4030_usb_data {
>  	enum twl4030_usb_mode	usb_mode;
>  	unsigned long		features;
> -	struct phy_init_data	*init_data;
>  
>  	int		(*phy_init)(struct device *dev);
>  	int		(*phy_exit)(struct device *dev);
> 
