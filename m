Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3EOJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:56:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49161 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3EOJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/39] ARM: ux500: Replace ST-E's home-brew DMA direction definition with the generic one
Date: Wed, 15 May 2013 10:51:53 +0100
Message-Id: <1368611522-9984-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
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
index ec87262..bfe443d 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -21,13 +21,13 @@
 
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
 
@@ -39,13 +39,13 @@ struct msp_i2s_platform_data msp0_platform_data = {
 
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
 
@@ -57,13 +57,13 @@ struct msp_i2s_platform_data msp1_platform_data = {
 
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
index 29be714..e6891d1 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -34,13 +34,13 @@
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
@@ -81,13 +81,13 @@ void mop500_sdi_tc35892_init(struct device *parent)
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
@@ -112,13 +112,13 @@ struct mmci_platform_data mop500_sdi1_data = {
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
@@ -144,13 +144,13 @@ struct mmci_platform_data mop500_sdi2_data = {
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
index ba26ae3..0b018c4 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -424,19 +424,19 @@ void mop500_snowball_ethernet_clock_enable(void)
 
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
@@ -455,13 +455,13 @@ static struct platform_device *mop500_platform_devs[] __initdata = {
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
@@ -490,37 +490,37 @@ static void __init mop500_spi_init(struct device *parent)
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
index 2f9abe9..b7bd8d3 100644
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

