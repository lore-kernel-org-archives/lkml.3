Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3KEXMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:12:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3KEXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:12:43 -0500
Date: Wed, 6 Nov 2013 00:12:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de
Cc: Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: gitorious v3.12-rc1-n900 tree
Message-ID: <20131105231241.GA5065@amd.pavel.ucw.cz>
References: <201310240806.49340@pali>
 <20131026002500.GA16970@earth.universe>
 <20131105120016.GA30670@amd.pavel.ucw.cz>
 <201311051336.00159@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311051336.00159@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I tried pulling current linux-n900 tree from gitorious.
> 
> Hi, use branch v3.12-rc5-n900 (not -rc1) and consider using 
> rx51_defconfig.

rx51_defconfig works for me, thanks.

And here are fixes for the problems I hit... please apply,

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/gpu/pvr/deviceclass.c b/drivers/gpu/pvr/deviceclass.c
index 7d64376..4a3c60c 100644
--- a/drivers/gpu/pvr/deviceclass.c
+++ b/drivers/gpu/pvr/deviceclass.c
@@ -1209,7 +1209,7 @@ void PVRSRVSetDCState(u32 ui32State)
 	}
 }
 
-static IMG_BOOL PVRGetDisplayClassJTable(
+IMG_BOOL PVRGetDisplayClassJTable(
 				struct PVRSRV_DC_DISP2SRV_KMJTABLE *psJTable)
 {
 	psJTable->ui32TableSize = sizeof(struct PVRSRV_DC_DISP2SRV_KMJTABLE);
diff --git a/drivers/media/i2c/smia/Kconfig b/drivers/media/i2c/smia/Kconfig
index 7e136e1..ed089e4 100644
--- a/drivers/media/i2c/smia/Kconfig
+++ b/drivers/media/i2c/smia/Kconfig
@@ -1,5 +1,6 @@
 config VIDEO_SMIAREGS
 	tristate "Generic SMIA I2C register access and register list helper"
+	depends on I2C
 	---help---
 	  This allows writing and reading SMIA image sensors' I2C registers
 	  easily.
diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index f7c67d8..dcaf0c9 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -26,7 +26,7 @@ config SND_OMAP_SOC_N810
 
 config SND_OMAP_SOC_RX51
 	tristate "SoC Audio support for Nokia RX-51"
-	depends on SND_OMAP_SOC && (MACH_NOKIA_RX51 || COMPILE_TEST)
+	depends on SND_OMAP_SOC && I2C && (MACH_NOKIA_RX51 || COMPILE_TEST)
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_TLV320AIC3X
 	select SND_SOC_TPA6130A2

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
