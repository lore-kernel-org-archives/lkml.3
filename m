Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3GDLsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:48:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51914 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3GDLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:48:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/g/d4QfeVOQ2kpkCLmwLcz
Date: Thu, 4 Jul 2013 04:47:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] N900: enable N900-specific drivers even if device tree
 is enabled
Message-ID: <20130704114755.GE5523@atomide.com>
References: <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
 <20130701211504.GB15318@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701211504.GB15318@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130701 14:21]:
> 
> We still need video & sound drivers with device tree enabled.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Thanks, applying this into omap-for-v3.11/fixes. Benoit should
queue the .dts related changes.

Tony

> 
> ---
> 
> Patch against 3.10.
> 
> --- linux-delme-clean//arch/arm/mach-omap2/board-rx51-video.c	2013-07-01 21:51:07.000000000 +0200
> +++ linux-delme/arch/arm/mach-omap2/board-rx51-video.c	2013-07-01 22:50:27.000000000 +0200
> @@ -61,7 +61,7 @@
>  
>  static int __init rx51_video_init(void)
>  {
> -	if (!machine_is_nokia_rx51())
> +	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
>  		return 0;
>  
>  	if (omap_mux_init_gpio(RX51_LCD_RESET_GPIO, OMAP_PIN_OUTPUT)) {
> diff -urN linux-delme-clean//sound/soc/omap/rx51.c linux-delme/sound/soc/omap/rx51.c
> --- linux-delme-clean//sound/soc/omap/rx51.c	2013-07-01 21:54:49.000000000 +0200
> +++ linux-delme/sound/soc/omap/rx51.c	2013-07-01 22:50:27.000000000 +0200
> @@ -396,7 +396,7 @@
>  {
>  	int err;
>  
> -	if (!machine_is_nokia_rx51())
> +	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
>  		return -ENODEV;
>  
>  	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
