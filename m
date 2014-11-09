Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKITlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:41:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50368 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaKITlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:41:53 -0500
Date: Sun, 9 Nov 2014 20:41:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@debian.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, peter.ujfalusi@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Subject: ASoC: omap: enable sound support on n900 on devicetree-based boot
Message-ID: <20141109194151.GB7852@amd>
References: <20141109120222.GA3815@amd>
 <20141109123753.GO2722@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109123753.GO2722@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device tree, it is possible (and encouraged) to build N900
kernels without CONFIG_MACH_NOKIA_RX51. Update config file to enable
the driver build in this case.

This makes sound work on my n900 under 3.18-rc1.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index d44463a..2738b19 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -25,15 +25,15 @@ config SND_OMAP_SOC_N810
 	  Say Y if you want to add support for SoC audio on Nokia N810.
 
 config SND_OMAP_SOC_RX51
-	tristate "SoC Audio support for Nokia RX-51"
-	depends on SND_OMAP_SOC && ARM && (MACH_NOKIA_RX51 || COMPILE_TEST) && I2C
+	tristate "SoC Audio support for Nokia N900 (RX-51)"
+	depends on SND_OMAP_SOC && ARM && I2C
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_TLV320AIC3X
 	select SND_SOC_TPA6130A2
 	depends on GPIOLIB
 	help
-	  Say Y if you want to add support for SoC audio on Nokia RX-51
-	  hardware. This is also known as Nokia N900 product.
+	  Say Y if you want to add support for SoC audio on Nokia N900
+	  cellphone.
 
 config SND_OMAP_SOC_AMS_DELTA
 	tristate "SoC Audio support for Amstrad E3 (Delta) videophone"



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
