Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3KUIiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:38:55 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:36432 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KUIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:38:53 -0500
Date: Thu, 21 Nov 2013 17:38:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: Add pinctrl_register_mappings() for
 Koelsch
Message-ID: <20131121083849.GA2732@verge.net.au>
References: <20131120074148.22744.70608.sendpatchset@w520>
 <20131121040555.GI31130@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121040555.GI31130@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 01:05:57PM +0900, Simon Horman wrote:
> On Wed, Nov 20, 2013 at 04:41:48PM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Add code to setup the r8a7791 PFC for the Koelsch board.
> > 
> > At this point serial consoles are added, and in the near
> > future other platform-device-only devices will be added
> > here like for instance the r8a7791 DU.
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> > ---
> > 
> >  arch/arm/mach-shmobile/board-koelsch.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> 
> Thanks, I will queue this up.
> Assuming all goes will I plan to push this and other updates
> today or tomorrow.

Unfortunately with this patch applied I am no longer
able to boot my Koelsch board using the koelsch defconfig.
Am I missing something?

I am dropping this patch for now.

> 
> > 
> > --- 0014/arch/arm/mach-shmobile/board-koelsch.c
> > +++ work/arch/arm/mach-shmobile/board-koelsch.c	2013-11-20 16:18:28.000000000 +0900
> > @@ -24,6 +24,7 @@
> >  #include <linux/input.h>
> >  #include <linux/kernel.h>
> >  #include <linux/leds.h>
> > +#include <linux/pinctrl/machine.h>
> >  #include <linux/platform_data/gpio-rcar.h>
> >  #include <linux/platform_device.h>
> >  #include <mach/common.h>
> > @@ -78,9 +79,20 @@ static const struct gpio_keys_platform_d
> >  	.nbuttons	= ARRAY_SIZE(gpio_buttons),
> >  };
> >  
> > +static const struct pinctrl_map koelsch_pinctrl_map[] = {
> > +	/* SCIF0 (CN19: DEBUG SERIAL0) */
> > +	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.6", "pfc-r8a7791",
> > +				  "scif0_data_d", "scif0"),
> > +	/* SCIF1 (CN20: DEBUG SERIAL1) */
> > +	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.7", "pfc-r8a7791",
> > +				  "scif1_data_d", "scif1"),
> > +};
> > +
> >  static void __init koelsch_add_standard_devices(void)
> >  {
> >  	r8a7791_clock_init();
> > +	pinctrl_register_mappings(koelsch_pinctrl_map,
> > +				  ARRAY_SIZE(koelsch_pinctrl_map));
> >  	r8a7791_pinmux_init();
> >  	r8a7791_add_standard_devices();
> >  	platform_device_register_data(&platform_bus, "leds-gpio", -1,
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
