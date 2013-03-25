Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3CYLVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:21:46 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45294 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3CYLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:21:44 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: davinci: use is IS_ENABLED macro
Date: Mon, 25 Mar 2013 16:51:35 +0530
Message-Id: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patches replaces #if defined() by IS_ENABLED macro, which provides
better readability.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 Note: This patch is compile tested only for davinci_all_defconfig
       and da8xx_omapl_defconfig.

 arch/arm/mach-davinci/board-da830-evm.c   |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c   |    3 +--
 arch/arm/mach-davinci/board-dm644x-evm.c  |    9 +++------
 arch/arm/mach-davinci/board-dm646x-evm.c  |    3 +--
 arch/arm/mach-davinci/board-neuros-osd2.c |    6 ++----
 arch/arm/mach-davinci/devices.c           |    2 +-
 arch/arm/mach-davinci/usb.c               |    2 +-
 7 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 6da25ee..68ade71 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -298,7 +298,7 @@ static const short da830_evm_emif25_pins[] = {
 	-1
 };
 
-#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
+#if IS_ENABLED(CONFIG_MMC_DAVINCI)
 #define HAS_MMC	1
 #else
 #define HAS_MMC	0
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index c2dfe06..3475769 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -335,8 +335,7 @@ static const short da850_evm_nor_pins[] = {
 	-1
 };
 
-#if defined(CONFIG_MMC_DAVINCI) || \
-    defined(CONFIG_MMC_DAVINCI_MODULE)
+#if IS_ENABLED(CONFIG_MMC_DAVINCI)
 #define HAS_MMC 1
 #else
 #define HAS_MMC 0
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 71735e7..d0f6365 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -750,22 +750,19 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 	return 0;
 }
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
+#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
 #define HAS_ATA 1
 #else
 #define HAS_ATA 0
 #endif
 
-#if defined(CONFIG_MTD_PHYSMAP) || \
-    defined(CONFIG_MTD_PHYSMAP_MODULE)
+#if IS_ENABLED(CONFIG_MTD_PHYSMAP)
 #define HAS_NOR 1
 #else
 #define HAS_NOR 0
 #endif
 
-#if defined(CONFIG_MTD_NAND_DAVINCI) || \
-    defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
+#if IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
 #define HAS_NAND 1
 #else
 #define HAS_NAND 0
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index de7adff..c84fdd5 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -117,8 +117,7 @@ static struct platform_device davinci_nand_device = {
 	},
 };
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
+#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
 #define HAS_ATA 1
 #else
 #define HAS_ATA 0
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 1c98107..8bd0a43 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -168,15 +168,13 @@ static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 };
 
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-	defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
+#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
 #define HAS_ATA 1
 #else
 #define HAS_ATA 0
 #endif
 
-#if defined(CONFIG_MTD_NAND_DAVINCI) || \
-	defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
+#if IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
 #define HAS_NAND 1
 #else
 #define HAS_NAND 0
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 4c48a36..df135de 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -119,7 +119,7 @@ void __init davinci_init_ide(void)
 	platform_device_register(&ide_device);
 }
 
-#if	defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
+#if IS_ENABLED(CONFIG_MMC_DAVINCI)
 
 static u64 mmcsd0_dma_mask = DMA_BIT_MASK(32);
 
diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index 34509ff..5764d65 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -17,7 +17,7 @@
 #define DA8XX_USB0_BASE 	0x01e00000
 #define DA8XX_USB1_BASE 	0x01e25000
 
-#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
+#if IS_ENABLED(CONFIG_USB_MUSB_HDRC)
 static struct musb_hdrc_eps_bits musb_eps[] = {
 	{ "ep1_tx", 8, },
 	{ "ep1_rx", 8, },
-- 
1.7.4.1

