Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3EPP7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:59:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40368 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752812Ab3EPP7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:59:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+m+cQLUCdAbpjGqSDEHD5A
Date: Thu, 16 May 2013 08:58:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@iki.fi>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
Message-ID: <20130516155857.GV5600@atomide.com>
References: <1366697656-14315-1-git-send-email-kishon@ti.com>
 <51936946.3030507@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51936946.3030507@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@iki.fi> [130515 03:59]:
> On 23/04/13 09:14, Kishon Vijay Abraham I wrote:
> > After the device names are created using PLATFORM_DEVID_AUTO, the old
> > device names given in usb_bind_phy are no longer valid causing the musb
> > controller not to get the phy reference. Updated the usb_bind_phy with
> > the new device names to get MUSB functional in omap4 panda.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> > Tested in OMAP4 PANDA.
> >  arch/arm/mach-omap2/board-4430sdp.c    |    2 +-
> >  arch/arm/mach-omap2/board-omap4panda.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
> > index 00d7290..56a9a4f 100644
> > --- a/arch/arm/mach-omap2/board-4430sdp.c
> > +++ b/arch/arm/mach-omap2/board-4430sdp.c
> > @@ -730,7 +730,7 @@ static void __init omap_4430sdp_init(void)
> >  	omap4_sdp4430_wifi_init();
> >  	omap4_twl6030_hsmmc_init(mmc);
> >  
> > -	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
> > +	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
> >  	usb_musb_init(&musb_board_data);
> >  
> >  	status = omap_ethernet_init();
> 
> I'm seeing
> 
> [    2.190155] unable to find transceiver
> [    2.190155] HS USB OTG: no transceiver configured
> [    2.190155] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
> with status -517
> [    2.207458] platform musb-hdrc.0.auto: Driver musb-hdrc requests
> probe deferral
> 
> on 4430sdp with v3.10-rc1. Does that mean that the musb-hdrc.0.auto was
> indeed correct, and the new value of musb-hdrc.2.auto is not?

Just checking.. Do you have CONFIG_OMAP_OCP2SCP=y in your .config? Sounds
like the some transceivers should depend on that for omap4.
 
> The musb-hdrc id is wrong on overo also.

Hmm has there been a fix posted for that?

Regards,

Tony
