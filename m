Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLCFla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:41:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47237 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaLCFl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:41:28 -0500
Message-ID: <547EA275.8050208@ti.com>
Date: Wed, 3 Dec 2014 11:11:09 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>, <sfr@canb.auug.org.au>
CC: <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <andrew.kim@intel.com>
Subject: Re: [PATCH] arm: omap3: twl: remove usb phy init data
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com> <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Monday 01 December 2014 02:14 PM, Kishon Vijay Abraham I wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> The driver does no use it any more.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

This patch is required to get rid of the error that Stephen Rothwell reported.

Thanks
Kishon
> ---
> While this patch was part of the original series sent by Heikki, I couldn't
> get Ack from Tony to be merged this in my tree and I failed to catch the
> build error during my testing :-(
> 
> This patch should fix the error pointed out by Stephen Rothwell.
> arch/arm/mach-omap2/twl-common.c:94:21: error: array type has incomplete element type
>  struct phy_consumer consumers[] = {
>                      ^
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
