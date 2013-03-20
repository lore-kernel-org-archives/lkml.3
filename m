Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3CTQv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:51:58 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:35627 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757852Ab3CTQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:51:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NM8j74z0IyXGrl1QToQUd
Date: Wed, 20 Mar 2013 09:51:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130320165141.GP16413@atomide.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com>
 <1363770725-13717-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363770725-13717-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130320 02:17]:
> 
> --- a/arch/arm/mach-omap2/board-2430sdp.c
> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> @@ -265,6 +266,7 @@ static void __init omap_2430sdp_init(void)
>  
>  	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
>  	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> +	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
>  	usb_musb_init(NULL);
>  
>  	board_smc91x_init();
> --- a/arch/arm/mach-omap2/board-3430sdp.c
> +++ b/arch/arm/mach-omap2/board-3430sdp.c
> @@ -601,6 +602,7 @@ static void __init omap_3430sdp_init(void)
>  	omap_serial_init();
>  	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
>  	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> +	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
>  	usb_musb_init(NULL);
>  	board_smc91x_init();
>  	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);

Can't you call phy_bind() from usb_musb_init() with the default
values automatically when usb_musb_init() is passed NULL?

That way you don't have to patch every board-*.c file with the
same lines, and don't need to include <linux/phy/phy.h> in each
board-*.c file.

> --- a/arch/arm/mach-omap2/board-4430sdp.c
> +++ b/arch/arm/mach-omap2/board-4430sdp.c
> @@ -32,6 +32,7 @@
>  #include <linux/platform_data/omap4-keypad.h>
>  #include <linux/usb/musb.h>
>  #include <linux/usb/phy.h>
> +#include <linux/phy/phy.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -725,6 +726,7 @@ static void __init omap_4430sdp_init(void)
>  	omap4_twl6030_hsmmc_init(mmc);
>  
>  	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
> +	phy_bind("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
>  	usb_musb_init(&musb_board_data);
>  
>  	status = omap_ethernet_init();

Here usb_musb_init() gets called with musb_board_data, so
keeping the phy_bind() in the board-4430sdp.c can then override
the default in usb_musb_init().

Regards,

Tony
