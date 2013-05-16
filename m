Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3EPQUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:20:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38144 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752927Ab3EPQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:20:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18KDNori70xeMDm8wcBC5RG
Date: Thu, 16 May 2013 09:20:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@iki.fi>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
Message-ID: <20130516162034.GX5600@atomide.com>
References: <1366697656-14315-1-git-send-email-kishon@ti.com>
 <51936946.3030507@iki.fi>
 <20130516155857.GV5600@atomide.com>
 <519503DA.5070303@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519503DA.5070303@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@iki.fi> [130516 09:11]:
> On 16/05/13 18:58, Tony Lindgren wrote:
> > * Tomi Valkeinen <tomi.valkeinen@iki.fi> [130515 03:59]:
> > 
> > Just checking.. Do you have CONFIG_OMAP_OCP2SCP=y in your .config? Sounds
> > like the some transceivers should depend on that for omap4.
> 
> Yes, I have OCP2SCP=y.

Hmm well no idea beyond that then. Sounds like Kishon should check it.
 
> >> The musb-hdrc id is wrong on overo also.
> > 
> > Hmm has there been a fix posted for that?
> 
> I couldn't find with a quick look. We debugged and discussed this on an irc
> channel with Kishon, who said he'll send a patch. Changing the musb-hdrc ID
> on overo fixed the issue, and it looks very similar to the error on 4430sdp.
> The overo fix was just:
> 
> diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
> index 4ca6b68..a496774 100644
> --- a/arch/arm/mach-omap2/board-overo.c
> +++ b/arch/arm/mach-omap2/board-overo.c
> @@ -472,7 +472,7 @@ static void __init overo_init(void)
>                                   mt46h32m32lf6_sdrc_params);
>         board_nand_init(overo_nand_partitions,
>                         ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
> -       usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> +       usb_bind_phy("musb-hdrc.1.auto", 0, "twl4030_usb");
>         usb_musb_init(NULL);
>  
>         usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
> 
> 
> Is that ID "randomly" chosen? Doesn't that mean that it'll just get broken
> every now and then?

Yes if so it's not a good solution. For omap4 we'll be flipping over to
be device tree only for v3.11, but that still leaves earlier omaps to
worry about.

I'll wait for a proper patch for the above for the -rc series after we
hear from Kishon.

Regards,

Tony
