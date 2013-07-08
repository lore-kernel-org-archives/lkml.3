Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3GHLPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:15:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37039 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab3GHLPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:15:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 4/4] arm: omap: remove using usb_bind_phy for binding musb and phy
Date: Mon, 8 Jul 2013 16:44:17 +0530
Message-ID: <1373282057-20181-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373282057-20181-1-git-send-email-kishon@ti.com>
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that MUSB for OMAP started using devm_usb_get_phy_by_name
which does not require PHY library to already have the binding
information, removed usb_bind_phy calls that binds the MUSB controller
with the PHY from the board files.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 arch/arm/mach-omap2/board-2430sdp.c          |    1 -
 arch/arm/mach-omap2/board-3430sdp.c          |    1 -
 arch/arm/mach-omap2/board-cm-t35.c           |    1 -
 arch/arm/mach-omap2/board-devkit8000.c       |    1 -
 arch/arm/mach-omap2/board-igep0020.c         |    1 -
 arch/arm/mach-omap2/board-ldp.c              |    1 -
 arch/arm/mach-omap2/board-omap3beagle.c      |    1 -
 arch/arm/mach-omap2/board-omap3evm.c         |    1 -
 arch/arm/mach-omap2/board-omap3logic.c       |    1 -
 arch/arm/mach-omap2/board-omap3pandora.c     |    1 -
 arch/arm/mach-omap2/board-omap3stalker.c     |    1 -
 arch/arm/mach-omap2/board-omap3touchbook.c   |    1 -
 arch/arm/mach-omap2/board-overo.c            |    1 -
 arch/arm/mach-omap2/board-rm680.c            |    1 -
 arch/arm/mach-omap2/board-rx51.c             |    1 -
 arch/arm/mach-omap2/board-zoom-peripherals.c |    1 -
 16 files changed, 16 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 244d8a5..30d81f2 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -233,7 +233,6 @@ static void __init omap_2430sdp_init(void)
 	omap_hsmmc_init(mmc);
 
 	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	board_smc91x_init();
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 23b004a..7f431b4 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -590,7 +590,6 @@ static void __init omap_3430sdp_init(void)
 	omap_ads7846_init(1, gpio_pendown, 310, NULL);
 	omap_serial_init();
 	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_smc91x_init();
 	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index d4622ed..c776c66 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -691,7 +691,6 @@ static void __init cm_t3x_common_init(void)
 	cm_t35_init_display();
 	omap_twl4030_audio_init("cm-t3x", NULL);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	cm_t35_init_usbh();
 	cm_t35_init_camera();
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index f1d91ba..2da5fd9 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -594,7 +594,6 @@ static void __init devkit8000_init(void)
 
 	omap_ads7846_init(2, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(devkit8000_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index b54562d..5451c9c 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -628,7 +628,6 @@ static void __init igep_init(void)
 	omap_serial_init();
 	omap_sdrc_init(m65kxxxxam_sdrc_params,
 				  m65kxxxxam_sdrc_params);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	igep_flash_init();
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 62e4f70..ff2892d 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -377,7 +377,6 @@ static void __init omap_ldp_init(void)
 	omap_ads7846_init(1, 54, 310, NULL);
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_nand_init(ldp_nand_partitions, ARRAY_SIZE(ldp_nand_partitions),
 			ZOOM_NAND_CS, 0, nand_default_timings);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 04c1165..47d7dd7 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -551,7 +551,6 @@ static void __init omap3_beagle_init(void)
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params,
 				  mt46h32m32lf6_sdrc_params);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init(&usbhs_bdata);
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 8c02626..9bfc99f 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -706,7 +706,6 @@ static void __init omap3_evm_init(void)
 		omap_mux_init_gpio(135, OMAP_PIN_OUTPUT);
 		phy_data[0].reset_gpio = 135;
 	}
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index bab51e6..16e4e2a 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -216,7 +216,6 @@ static void __init omap3logic_init(void)
 	board_mmc_init();
 	board_smsc911x_init();
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index b1547a0..f058f43 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -611,7 +611,6 @@ static void __init omap3pandora_init(void)
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	gpmc_nand_init(&pandora_nand_data, NULL);
 
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index d37e6b1..6f6fc92 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -394,7 +394,6 @@ static void __init omap3_stalker_init(void)
 
 	omap_serial_init();
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 7da48bc..bbff6de 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -367,7 +367,6 @@ static void __init omap3_touchbook_init(void)
 
 	/* Touchscreen and accelerometer */
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 5748b5d..6c2bb5a 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -473,7 +473,6 @@ static void __init overo_init(void)
 				  mt46h32m32lf6_sdrc_params);
 	board_nand_init(overo_nand_partitions,
 			ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 345e8c4..cadeb5c 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -135,7 +135,6 @@ static void __init rm680_init(void)
 	sdrc_params = nokia_get_sdram_timings();
 	omap_sdrc_init(sdrc_params, sdrc_params);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	rm680_peripherals_init();
 }
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index d2ea68e..0d16d37 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -99,7 +99,6 @@ static void __init rx51_init(void)
 	sdrc_params = nokia_get_sdram_timings();
 	omap_sdrc_init(sdrc_params, sdrc_params);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
 	rx51_peripherals_init();
 
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index a90375d..d05db2d 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -353,7 +353,6 @@ void __init zoom_peripherals_init(void)
 	omap_i2c_init();
 	pwm_add_table(zoom_pwm_lookup, ARRAY_SIZE(zoom_pwm_lookup));
 	platform_add_devices(zoom_devices, ARRAY_SIZE(zoom_devices));
-	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	enable_board_wakeup_source();
 	omap_serial_init();
-- 
1.7.10.4

