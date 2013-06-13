Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab3FMPwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:52:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40803 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3FMPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:52:42 -0400
Date: Thu, 13 Jun 2013 17:52:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613155240.GB3775@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613145724.GH8164@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Pavel Machek <pavel@ucw.cz> [130613 07:34]:
> > On Thu 2013-06-13 07:10:01, Tony Lindgren wrote:
> > > * Pavel Machek <pavel@ucw.cz> [130613 06:32]:
> > >  
> > > > If I init spi manually (and some more hacks), it works in the
> > > > qemu. But I have not tested on real hw for a while.
> > > 
> > > You should be able to initialize spi by adding the .dts entry,
> > > or is there something missing in drivers/spi/spi-omap2-mcspi.c?
> > 
> > Not sure, I guess I'll find out soon. Do you have example dts that
> > uses drivers/spi/spi-omap2-mcspi.c? Grepping spi in dts/ was not too
> > successful.
> 
> Hmm I think all we have is what's written in
> Documentation/devicetree/bindings/spi/omap-spi.txt and
> omap4-sdp.dts.

Ok, this was easier than expected.

Now, by chance, any idea what is DT equivalent of 

omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);

?

(Plus I'll still have to figure out why it works on emulator but not
on hw).

Thanks,
									Pavel


diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 10a880f..3918ae1 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -65,6 +65,14 @@
 	status = "disabled";
 };
 
+&mcspi1 {
+	mipid@2 {
+		compatible = "acx565akm";
+		spi-max-frequency = <6000000>;
+		reg = <2>;
+	};
+};
+
 /*
 &usb_otg_hs {
 	interface-type = <0>;
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 996ffc3..597ade9 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -130,9 +130,10 @@ void __init omap_generic_init(void)
 		regulator_use_dummy_regulator();
 
 		omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
-
+#if 0
 		spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+#endif
 #else
 		rx51_video_init();
 #endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
