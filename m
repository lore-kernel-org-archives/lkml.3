Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3DWRg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:36:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32496 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3DWRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:36:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lLKq4yYb1/Dia33Kv3Lsf
Date: Tue, 23 Apr 2013 10:36:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Subject: Re: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
Message-ID: <20130423173623.GG10155@atomide.com>
References: <1366697656-14315-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366697656-14315-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130422 23:19]:
> After the device names are created using PLATFORM_DEVID_AUTO, the old
> device names given in usb_bind_phy are no longer valid causing the musb
> controller not to get the phy reference. Updated the usb_bind_phy with
> the new device names to get MUSB functional in omap4 panda.

Thanks will apply this into omap-for-v3.10/fixes.

Regards,

Tony
 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Tested in OMAP4 PANDA.
>  arch/arm/mach-omap2/board-4430sdp.c    |    2 +-
>  arch/arm/mach-omap2/board-omap4panda.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
> index 00d7290..56a9a4f 100644
> --- a/arch/arm/mach-omap2/board-4430sdp.c
> +++ b/arch/arm/mach-omap2/board-4430sdp.c
> @@ -730,7 +730,7 @@ static void __init omap_4430sdp_init(void)
>  	omap4_sdp4430_wifi_init();
>  	omap4_twl6030_hsmmc_init(mmc);
>  
> -	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
> +	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
>  	usb_musb_init(&musb_board_data);
>  
>  	status = omap_ethernet_init();
> diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
> index a71ad34..1e2c75e 100644
> --- a/arch/arm/mach-omap2/board-omap4panda.c
> +++ b/arch/arm/mach-omap2/board-omap4panda.c
> @@ -435,7 +435,7 @@ static void __init omap4_panda_init(void)
>  	omap_sdrc_init(NULL, NULL);
>  	omap4_twl6030_hsmmc_init(mmc);
>  	omap4_ehci_init();
> -	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
> +	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
>  	usb_musb_init(&musb_board_data);
>  	omap4_panda_display_init();
>  }
> -- 
> 1.7.10.4
> 
