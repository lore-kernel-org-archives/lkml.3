Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3CTJNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:13:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59809 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab3CTJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:13:08 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>
CC: <davem@davemloft.net>, <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <kishon@ti.com>, <mchehab@redhat.com>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 4/6] ARM: OMAP: USB: Add phy binding information
Date: Wed, 20 Mar 2013 14:42:03 +0530
Message-ID: <1363770725-13717-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363770725-13717-1-git-send-email-kishon@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for controllers to get PHY in case of non dt boot, the phy
binding information should be added in the platform specific
initialization code using phy_bind. The previously added usb_bind_phy
can't be removed yet because the musb controller continues to use the
old PHY library which has OTG in it (struct usb_phy has struct usb_otg
as member). Until we have a separate OTG state machine to handle all of
that, the new generic PHY framework and the old phy library will co-exist.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/board-2430sdp.c          |    2 ++
 arch/arm/mach-omap2/board-3430sdp.c          |    2 ++
 arch/arm/mach-omap2/board-4430sdp.c          |    2 ++
 arch/arm/mach-omap2/board-cm-t35.c           |    2 ++
 arch/arm/mach-omap2/board-devkit8000.c       |    2 ++
 arch/arm/mach-omap2/board-igep0020.c         |    2 ++
 arch/arm/mach-omap2/board-ldp.c              |    2 ++
 arch/arm/mach-omap2/board-omap3beagle.c      |    2 ++
 arch/arm/mach-omap2/board-omap3evm.c         |    2 ++
 arch/arm/mach-omap2/board-omap3logic.c       |    2 ++
 arch/arm/mach-omap2/board-omap3pandora.c     |    2 ++
 arch/arm/mach-omap2/board-omap3stalker.c     |    2 ++
 arch/arm/mach-omap2/board-omap3touchbook.c   |    2 ++
 arch/arm/mach-omap2/board-omap4panda.c       |    2 ++
 arch/arm/mach-omap2/board-overo.c            |    2 ++
 arch/arm/mach-omap2/board-rm680.c            |    2 ++
 arch/arm/mach-omap2/board-rx51.c             |    2 ++
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 ++
 18 files changed, 36 insertions(+)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index a3e0aaa..271458b 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -28,6 +28,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -265,6 +266,7 @@ static void __init omap_2430sdp_init(void)
 
 	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	board_smc91x_init();
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index ce812de..bf6ce1d 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -27,6 +27,7 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/omap-twl4030.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -601,6 +602,7 @@ static void __init omap_3430sdp_init(void)
 	omap_serial_init();
 	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_smc91x_init();
 	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 35f3ad0..1a236cb 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -32,6 +32,7 @@
 #include <linux/platform_data/omap4-keypad.h>
 #include <linux/usb/musb.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -725,6 +726,7 @@ static void __init omap_4430sdp_init(void)
 	omap4_twl6030_hsmmc_init(mmc);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
+	phy_bind("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
 	usb_musb_init(&musb_board_data);
 
 	status = omap_ethernet_init();
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index af2bb21..6a2615a 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/tdo24m.h>
@@ -726,6 +727,7 @@ static void __init cm_t3x_common_init(void)
 	omap_twl4030_audio_init("cm-t3x", NULL);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	cm_t35_init_usbh();
 	cm_t35_init_camera();
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 53056c3..4ca7d23 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -30,6 +30,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
@@ -624,6 +625,7 @@ static void __init devkit8000_init(void)
 	omap_ads7846_init(2, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(devkit8000_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index bf92678..f0c28bc 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
@@ -627,6 +628,7 @@ static void __init igep_init(void)
 	omap_sdrc_init(m65kxxxxam_sdrc_params,
 				  m65kxxxxam_sdrc_params);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	igep_flash_init();
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index b12fe96..3f43626 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -29,6 +29,7 @@
 #include <linux/smsc911x.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
 #include <asm/mach-types.h>
@@ -420,6 +421,7 @@ static void __init omap_ldp_init(void)
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	board_nand_init(ldp_nand_partitions, ARRAY_SIZE(ldp_nand_partitions),
 			ZOOM_NAND_CS, 0, nand_default_timings);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index c3558f9..5dc0f81 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -33,6 +33,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
@@ -542,6 +543,7 @@ static void __init omap3_beagle_init(void)
 				  mt46h32m32lf6_sdrc_params);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3beagle_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 48789e0..47e68cd 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -42,6 +42,7 @@
 #include <linux/mmc/host.h>
 #include <linux/export.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -736,6 +737,7 @@ static void __init omap3_evm_init(void)
 		usbhs_bdata.reset_gpio_port[1] = 135;
 	}
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3evm_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index bab51e6..2c35ae2 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -30,6 +30,7 @@
 #include <linux/i2c/twl.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -217,6 +218,7 @@ static void __init omap3logic_init(void)
 	board_smsc911x_init();
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 2bba362..07cede4 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -36,6 +36,7 @@
 #include <linux/mmc/card.h>
 #include <linux/regulator/fixed.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
 #include <asm/mach-types.h>
@@ -603,6 +604,7 @@ static void __init omap3pandora_init(void)
 	omap_ads7846_init(1, OMAP3_PANDORA_TS_GPIO, 0, NULL);
 	usbhs_init(&usbhs_bdata);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	gpmc_nand_init(&pandora_nand_data, NULL);
 
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 95c10b3..bf2575b 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -34,6 +34,7 @@
 #include <linux/smsc911x.h>
 #include <linux/i2c/at24.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -406,6 +407,7 @@ static void __init omap3_stalker_init(void)
 	omap_serial_init();
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	omap_ads7846_init(1, OMAP3_STALKER_TS_GPIO, 310, NULL);
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index bcd44fb..2665d47 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -29,6 +29,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/spi/spi.h>
@@ -367,6 +368,7 @@ static void __init omap3_touchbook_init(void)
 	/* Touchscreen and accelerometer */
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3touchbook_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index b02c2f0..d977c11 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -31,6 +31,7 @@
 #include <linux/ti_wilink_st.h>
 #include <linux/usb/musb.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/wl12xx.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/omap-abe-twl6040.h>
@@ -449,6 +450,7 @@ static void __init omap4_panda_init(void)
 	omap4_twl6030_hsmmc_init(mmc);
 	omap4_ehci_init();
 	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
+	phy_bind("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
 	usb_musb_init(&musb_board_data);
 	omap4_panda_display_init();
 }
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 86bab51..f75cb33 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -37,6 +37,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <linux/platform_data/mtd-nand-omap2.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
@@ -501,6 +502,7 @@ static void __init overo_init(void)
 	board_nand_init(overo_nand_partitions,
 			ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	overo_spi_init();
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 345e8c4..2895fe8 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -19,6 +19,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -136,6 +137,7 @@ static void __init rm680_init(void)
 	omap_sdrc_init(sdrc_params, sdrc_params);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	rm680_peripherals_init();
 }
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index d2ea68e..508f8d9 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -18,6 +18,7 @@
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/usb/musb.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
@@ -100,6 +101,7 @@ static void __init rx51_init(void)
 	omap_sdrc_init(sdrc_params, sdrc_params);
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
 	rx51_peripherals_init();
 
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index cdc0c10..b58d7cd 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -22,6 +22,7 @@
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/platform_data/omap-twl4030.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -303,6 +304,7 @@ void __init zoom_peripherals_init(void)
 	omap_i2c_init();
 	platform_device_register(&omap_vwlan_device);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	enable_board_wakeup_source();
 	omap_serial_init();
-- 
1.7.10.4

