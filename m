Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3LFMHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:07:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54227 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab3LFMGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:06:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>
CC: <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH v2 2/2] arm: omap: remove *.auto* from device names given in usb_bind_phy
Date: Fri, 6 Dec 2013 17:36:11 +0530
Message-ID: <1386331571-30903-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386331571-30903-1-git-send-email-kishon@ti.com>
References: <1386331571-30903-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while creating
MUSB core device. So in usb_bind_phy (binds the controller with the PHY), the
device name of the controller had *.auto* in it. Since with using
PLATFORM_DEVID_AUTO, there is no way to know the exact device name in advance,
the data given in usb_bind_phy became obsolete and usb_get_phy was failing.
So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Corresponding
change is done in board file here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-ldp.c            |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-rx51.c           |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index c711ad6..cc679c6 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -246,7 +246,7 @@ static void __init omap_2430sdp_init(void)
 	omap_hsmmc_init(mmc);
 
 	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	board_smc91x_init();
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index d95d0ef..873e463 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -607,7 +607,7 @@ static void __init omap_3430sdp_init(void)
 	omap_ads7846_init(1, gpio_pendown, 310, NULL);
 	omap_serial_init();
 	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_smc91x_init();
 	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 8dd0ec8..ddcadfa 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -725,7 +725,7 @@ static void __init cm_t3x_common_init(void)
 	cm_t35_init_display();
 	omap_twl4030_audio_init("cm-t3x", NULL);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	cm_t35_init_usbh();
 	cm_t35_init_camera();
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index cdc4fb9..bb589f1 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -628,7 +628,7 @@ static void __init devkit8000_init(void)
 
 	omap_ads7846_init(2, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(devkit8000_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 4ec8d82..ec9b349 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -402,7 +402,7 @@ static void __init omap_ldp_init(void)
 	omap_ads7846_init(1, 54, 310, NULL);
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_nand_init(ldp_nand_partitions, ARRAY_SIZE(ldp_nand_partitions),
 			0, 0, nand_default_timings);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index d6ed819..0cba5eb 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -561,7 +561,7 @@ static void __init omap3_beagle_init(void)
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params,
 				  mt46h32m32lf6_sdrc_params);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init(&usbhs_bdata);
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index bab51e6..d9a6c38 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -216,7 +216,7 @@ static void __init omap3logic_init(void)
 	board_mmc_init();
 	board_smsc911x_init();
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index de1bc6b..3826af6 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -607,7 +607,7 @@ static void __init omap3pandora_init(void)
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	gpmc_nand_init(&pandora_nand_data, NULL);
 
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 119efaf..9421987 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -407,7 +407,7 @@ static void __init omap3_stalker_init(void)
 
 	omap_serial_init();
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 7da48bc..e8e053d 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -367,7 +367,7 @@ static void __init omap3_touchbook_init(void)
 
 	/* Touchscreen and accelerometer */
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index f6d3841..c69e049 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -511,7 +511,7 @@ static void __init overo_init(void)
 				  mt46h32m32lf6_sdrc_params);
 	board_nand_init(overo_nand_partitions,
 			ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index db168c9..31d218f 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -103,7 +103,7 @@ static void __init rx51_init(void)
 	sdrc_params = nokia_get_sdram_timings();
 	omap_sdrc_init(sdrc_params, sdrc_params);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
 	rx51_peripherals_init();
 
-- 
1.7.10.4

