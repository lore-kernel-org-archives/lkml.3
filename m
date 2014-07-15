Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaGORMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39869 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaGORCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:15 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>, Tony Lindgren <tony@atomide.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 53/94] ARM: OMAP2+: Remove non working OMAP HDMI audio initialization
Date: Tue, 15 Jul 2014 20:01:08 +0300
Message-Id: <1405443709-15288-53-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jyri Sarha <jsarha@ti.com>

This code is not working currently and it can be removed. There is a
conflict in sharing resources with the actual HDMI driver and with
the ASoC HDMI audio DAI driver.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/devices.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 592ba0a..b6f8f34 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -297,33 +297,6 @@ static void omap_init_audio(void)
 static inline void omap_init_audio(void) {}
 #endif
 
-#if defined(CONFIG_SND_OMAP_SOC_OMAP_HDMI) || \
-		defined(CONFIG_SND_OMAP_SOC_OMAP_HDMI_MODULE)
-
-static struct platform_device omap_hdmi_audio = {
-	.name	= "omap-hdmi-audio",
-	.id	= -1,
-};
-
-static void __init omap_init_hdmi_audio(void)
-{
-	struct omap_hwmod *oh;
-	struct platform_device *pdev;
-
-	oh = omap_hwmod_lookup("dss_hdmi");
-	if (!oh)
-		return;
-
-	pdev = omap_device_build("omap-hdmi-audio-dai", -1, oh, NULL, 0);
-	WARN(IS_ERR(pdev),
-	     "Can't build omap_device for omap-hdmi-audio-dai.\n");
-
-	platform_device_register(&omap_hdmi_audio);
-}
-#else
-static inline void omap_init_hdmi_audio(void) {}
-#endif
-
 #if defined(CONFIG_SPI_OMAP24XX) || defined(CONFIG_SPI_OMAP24XX_MODULE)
 
 #include <linux/platform_data/spi-omap2-mcspi.h>
@@ -459,7 +432,6 @@ static int __init omap2_init_devices(void)
 	 */
 	omap_init_audio();
 	omap_init_camera();
-	omap_init_hdmi_audio();
 	omap_init_mbox();
 	/* If dtb is there, the devices will be created dynamically */
 	if (!of_have_populated_dt()) {
-- 
1.7.10.4

