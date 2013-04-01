Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab3DAHN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:13:58 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50884 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3DAHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:13:57 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] ARM: davinci: use is IS_ENABLED macro
Date: Mon,  1 Apr 2013 12:43:44 +0530
Message-Id: <1364800424-4239-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patches replaces #if defined() by IS_ENABLED macro, which provides
better readability.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 Changes for V2:
 1: Fixed review comments pointed by Stephen
    (https://patchwork.kernel.org/patch/2330531/)

 arch/arm/mach-davinci/board-da830-evm.c   |    6 +-----
 arch/arm/mach-davinci/board-da850-evm.c   |    7 +------
 arch/arm/mach-davinci/board-dm644x-evm.c  |   25 +++++--------------------
 arch/arm/mach-davinci/board-dm646x-evm.c  |    7 +------
 arch/arm/mach-davinci/board-neuros-osd2.c |   15 ++-------------
 arch/arm/mach-davinci/devices.c           |    2 +-
 arch/arm/mach-davinci/usb.c               |    2 +-
 7 files changed, 12 insertions(+), 52 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 6da25ee..b348e44 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -298,11 +298,7 @@ static const short da830_evm_emif25_pins[] = {
 	-1
 };
 
-#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
-#define HAS_MMC	1
-#else
-#define HAS_MMC	0
-#endif
+#define HAS_MMC		IS_ENABLED(CONFIG_MMC_DAVINCI)
 
 #ifdef CONFIG_DA830_UI_NAND
 static struct mtd_partition da830_evm_nand_partitions[] = {
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index c2dfe06..a74dec7 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -335,12 +335,7 @@ static const short da850_evm_nor_pins[] = {
 	-1
 };
 
-#if defined(CONFIG_MMC_DAVINCI) || \
-    defined(CONFIG_MMC_DAVINCI_MODULE)
-#define HAS_MMC 1
-#else
-#define HAS_MMC 0
-#endif
+#define HAS_MMC		IS_ENABLED(CONFIG_MMC_DAVINCI)
 
 static inline void da850_evm_setup_nor_nand(void)
 {
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 71735e7..a042f27 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -750,26 +750,11 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 	return 0;
 }
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
-#define HAS_ATA 1
-#else
-#define HAS_ATA 0
-#endif
-
-#if defined(CONFIG_MTD_PHYSMAP) || \
-    defined(CONFIG_MTD_PHYSMAP_MODULE)
-#define HAS_NOR 1
-#else
-#define HAS_NOR 0
-#endif
-
-#if defined(CONFIG_MTD_NAND_DAVINCI) || \
-    defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
-#define HAS_NAND 1
-#else
-#define HAS_NAND 0
-#endif
+#define HAS_ATA		IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
+
+#define HAS_NOR		IS_ENABLED(CONFIG_MTD_PHYSMAP)
+
+#define HAS_NAND	IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
 
 static __init void davinci_evm_init(void)
 {
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index de7adff..03785e0 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -117,12 +117,7 @@ static struct platform_device davinci_nand_device = {
 	},
 };
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
-#define HAS_ATA 1
-#else
-#define HAS_ATA 0
-#endif
+#define HAS_ATA		IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
 
 /* CPLD Register 0 bits to control ATA */
 #define DM646X_EVM_ATA_RST		BIT(0)
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 1c98107..ea6728b 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -167,20 +167,9 @@ static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 	.version	= MMC_CTLR_VERSION_1
 };
 
+#define HAS_ATA		IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
 
-#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
-	defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
-#define HAS_ATA 1
-#else
-#define HAS_ATA 0
-#endif
-
-#if defined(CONFIG_MTD_NAND_DAVINCI) || \
-	defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
-#define HAS_NAND 1
-#else
-#define HAS_NAND 0
-#endif
+#define HAS_NAND	IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
 
 static __init void davinci_ntosd2_init(void)
 {
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

