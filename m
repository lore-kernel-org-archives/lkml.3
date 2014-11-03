Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaKCV1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:27:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60767 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaKCV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:27:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Mfam6MvoYy7wFv+x8G8I/
Date: Mon, 3 Nov 2014 13:26:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: Re: [PATCHv4 3/6] arm: omap3: twl: use the new lookup method with
 usb phy
Message-ID: <20141103212609.GL31454@atomide.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1413556756-5050-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413556756-5050-4-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heikki Krogerus <heikki.krogerus@linux.intel.com> [141017 07:43]:
> Provide complete association for the phy and it's user
> (musb) with the new phy lookup method.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Kishon, this looks OK for you to queue with other PHY patches:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/twl-common.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index b0d54da..0e4f3e3 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -91,18 +91,11 @@ void __init omap_pmic_late_init(void)
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
> +static struct phy_lookup twl4030_usb_lookup = PHY_LOOKUP("twl4030_usb",
> +							 "musb-hdrc.0", "usb");
>  
>  static struct twl4030_usb_data omap3_usb_pdata = {
> -	.usb_mode	= T2_USB_MODE_ULPI,
> -	.init_data	= &init_data,
> +	.usb_mode = T2_USB_MODE_ULPI,
>  };
>  
>  static int omap3_batt_table[] = {
> @@ -225,8 +218,10 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
>  	}
>  
>  	/* Common platform data configurations */
> -	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
> +	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb) {
> +		phy_register_lookup(&twl4030_usb_lookup);
>  		pmic_data->usb = &omap3_usb_pdata;
> +	}
>  
>  	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
>  		pmic_data->bci = &omap3_bci_pdata;
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
