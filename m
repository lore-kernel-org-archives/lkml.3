Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaAHRxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:53:24 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18834 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbaAHRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:53:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Y0LFD/3T//a+MaGZ24776
Date: Wed, 8 Jan 2014 09:53:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb
 phy
Message-ID: <20140108175314.GC31686@atomide.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heikki Krogerus <heikki.krogerus@linux.intel.com> [131209 07:10]:
> Provide a complete association for the phy and it's user
> (musb) with the new phy_lookup_table.

This seems safe to queue via the USB list:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  arch/arm/mach-omap2/twl-common.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index b0d54da..972430b 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -91,18 +91,13 @@ void __init omap_pmic_late_init(void)
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
> +static struct phy_lookup_table twl4030_usb_lookup = {
> +	.dev_id = "musb-hdrc.0",
> +	.table = PHY_LOOKUP("phy-twl4030_usb.0", NULL),
>  };
>  
>  static struct twl4030_usb_data omap3_usb_pdata = {
>  	.usb_mode	= T2_USB_MODE_ULPI,
> -	.init_data	= &init_data,
>  };
>  
>  static int omap3_batt_table[] = {
> @@ -225,8 +220,10 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
>  	}
>  
>  	/* Common platform data configurations */
> -	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
> +	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb) {
> +		phy_add_lookup_table(&twl4030_usb_lookup);
>  		pmic_data->usb = &omap3_usb_pdata;
> +	}
>  
>  	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
>  		pmic_data->bci = &omap3_bci_pdata;
> -- 
> 1.8.5.1
> 
