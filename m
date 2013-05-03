Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab3ECOfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:35:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60620 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab3ECOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 54/63] ARM: ux500: Replace ST-E's home-brew DMA direction definition with the generic one
Date: Fri,  3 May 2013 15:32:40 +0100
Message-Id: <1367591569-32197-55-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STEDMA40_*_TO_* direction definitions are identical in all but name to
the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
duplicating such things.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-audio.c |   12 ++++++------
 arch/arm/mach-ux500/board-mop500-sdi.c   |   16 ++++++++--------
 arch/arm/mach-ux500/board-mop500.c       |   22 +++++++++++-----------
 arch/arm/mach-ux500/usb.c                |    4 ++--
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index 972bec0..4bd4d0f 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -22,13 +22,13 @@
 
 static struct stedma40_chan_cfg msp0_dma_rx = {
 	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
 };
 
 static struct stedma40_chan_cfg msp0_dma_tx = {
 	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
 };
 
@@ -40,13 +40,13 @@ struct msp_i2s_platform_data msp0_platform_data = {
 
 static struct stedma40_chan_cfg msp1_dma_rx = {
 	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV30_MSP3,
 };
 
 static struct stedma40_chan_cfg msp1_dma_tx = {
 	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV30_MSP1,
 };
 
@@ -58,13 +58,13 @@ struct msp_i2s_platform_data msp1_platform_data = {
 
 static struct stedma40_chan_cfg msp2_dma_rx = {
 	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV14_MSP2,
 };
 
 static struct stedma40_chan_cfg msp2_dma_tx = {
 	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV14_MSP2,
 	.use_fixed_channel = true,
 	.phy_channel = 1,
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 553ace6..381acd0 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -63,13 +63,13 @@ static int mop500_sdi0_ios_handler(struct device *dev, struct mmc_ios *ios)
 #ifdef CONFIG_STE_DMA40
 struct stedma40_chan_cfg mop500_sdi0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV29_SD_MM0,
 };
 
 static struct stedma40_chan_cfg mop500_sdi0_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV29_SD_MM0,
 };
 #endif
@@ -128,13 +128,13 @@ void mop500_sdi_tc35892_init(struct device *parent)
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg sdi1_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV32_SD_MM1,
 };
 
 static struct stedma40_chan_cfg sdi1_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV32_SD_MM1,
 };
 #endif
@@ -159,13 +159,13 @@ struct mmci_platform_data mop500_sdi1_data = {
 #ifdef CONFIG_STE_DMA40
 struct stedma40_chan_cfg mop500_sdi2_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type =  DB8500_DMA_DEV28_SD_MM2,
 };
 
 static struct stedma40_chan_cfg mop500_sdi2_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV28_SD_MM2,
 };
 #endif
@@ -191,13 +191,13 @@ struct mmci_platform_data mop500_sdi2_data = {
 #ifdef CONFIG_STE_DMA40
 struct stedma40_chan_cfg mop500_sdi4_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type =  DB8500_DMA_DEV42_SD_MM4,
 };
 
 static struct stedma40_chan_cfg mop500_sdi4_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV42_SD_MM4,
 };
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 3866fa8..65abf8d 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -451,19 +451,19 @@ void mop500_snowball_ethernet_clock_enable(void)
 
 static struct cryp_platform_data u8500_cryp1_platform_data = {
 		.mem_to_engine = {
-				.dir = STEDMA40_MEM_TO_PERIPH,
+				.dir = DMA_MEM_TO_DEV,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
 				.mode = STEDMA40_MODE_LOGICAL,
 		},
 		.engine_to_mem = {
-				.dir = STEDMA40_PERIPH_TO_MEM,
+				.dir = DMA_DEV_TO_MEM,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
 				.mode = STEDMA40_MODE_LOGICAL,
 		}
 };
 
 static struct stedma40_chan_cfg u8500_hash_dma_cfg_tx = {
-		.dir = STEDMA40_MEM_TO_PERIPH,
+		.dir = DMA_MEM_TO_DEV,
 		.dev_type = DB8500_DMA_DEV50_HAC1_TX,
 		.mode = STEDMA40_MODE_LOGICAL,
 };
@@ -481,13 +481,13 @@ static struct platform_device *mop500_platform_devs[] __initdata = {
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV8_SSP0,
 };
 
 static struct stedma40_chan_cfg ssp0_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV8_SSP0,
 };
 #endif
@@ -516,37 +516,37 @@ static void __init mop500_spi_init(struct device *parent)
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV13_UART0,
 };
 
 static struct stedma40_chan_cfg uart0_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV13_UART0,
 };
 
 static struct stedma40_chan_cfg uart1_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV12_UART1,
 };
 
 static struct stedma40_chan_cfg uart1_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV12_UART1,
 };
 
 static struct stedma40_chan_cfg uart2_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_PERIPH_TO_MEM,
+	.dir = DMA_DEV_TO_MEM,
 	.dev_type = DB8500_DMA_DEV11_UART2,
 };
 
 static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_PERIPH,
+	.dir = DMA_MEM_TO_DEV,
 	.dev_type = DB8500_DMA_DEV11_UART2,
 };
 #endif
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index e6c4a05..88e0a77 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -14,12 +14,12 @@
 
 #define MUSB_DMA40_RX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
-		.dir = STEDMA40_PERIPH_TO_MEM, \
+		.dir = DMA_DEV_TO_MEM, \
 	}
 
 #define MUSB_DMA40_TX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
-		.dir = STEDMA40_MEM_TO_PERIPH, \
+		.dir = DMA_MEM_TO_DEV, \
 	}
 
 static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS]
-- 
1.7.10.4

