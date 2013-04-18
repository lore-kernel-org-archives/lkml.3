Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325Ab3DRKT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:19:27 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60976 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967812Ab3DRKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/32] ARM: ux500: Remove superfluous 'psize' attribute from Audio platform data
Date: Thu, 18 Apr 2013 11:11:54 +0100
Message-Id: <1366279934-30761-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'psize' is used to calculate the maximum DMA burst size. However it
is only taken into consideration when editing the DMA channel's
configuration. The Audio DMA platform data is only used to allocate
a channel, not configure it. That will be done at a later date within
the MSP driver.

We're also removing comments which are no longer required, as
'data_width' is no longer set in any device's platform data period.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-audio.c |   38 ------------------------------
 1 file changed, 38 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index f012cfa..972bec0 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -23,25 +23,13 @@
 static struct stedma40_chan_cfg msp0_dma_rx = {
 	.high_priority = true,
 	.dir = STEDMA40_PERIPH_TO_MEM,
-
 	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
 };
 
 static struct stedma40_chan_cfg msp0_dma_tx = {
 	.high_priority = true,
 	.dir = STEDMA40_MEM_TO_PERIPH,
-
 	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
 };
 
 struct msp_i2s_platform_data msp0_platform_data = {
@@ -53,25 +41,13 @@ struct msp_i2s_platform_data msp0_platform_data = {
 static struct stedma40_chan_cfg msp1_dma_rx = {
 	.high_priority = true,
 	.dir = STEDMA40_PERIPH_TO_MEM,
-
 	.dev_type = DB8500_DMA_DEV30_MSP3,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
 };
 
 static struct stedma40_chan_cfg msp1_dma_tx = {
 	.high_priority = true,
 	.dir = STEDMA40_MEM_TO_PERIPH,
-
 	.dev_type = DB8500_DMA_DEV30_MSP1,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
 };
 
 struct msp_i2s_platform_data msp1_platform_data = {
@@ -83,29 +59,15 @@ struct msp_i2s_platform_data msp1_platform_data = {
 static struct stedma40_chan_cfg msp2_dma_rx = {
 	.high_priority = true,
 	.dir = STEDMA40_PERIPH_TO_MEM,
-
 	.dev_type = DB8500_DMA_DEV14_MSP2,
-
-	/* MSP2 DMA doesn't work with PSIZE == 4 on DB8500v2 */
-	.src_info.psize = STEDMA40_PSIZE_LOG_1,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
-
-	/* data_width is set during configuration */
 };
 
 static struct stedma40_chan_cfg msp2_dma_tx = {
 	.high_priority = true,
 	.dir = STEDMA40_MEM_TO_PERIPH,
-
 	.dev_type = DB8500_DMA_DEV14_MSP2,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
 	.use_fixed_channel = true,
 	.phy_channel = 1,
-
-	/* data_width is set during configuration */
 };
 
 static struct platform_device *db8500_add_msp_i2s(struct device *parent,
-- 
1.7.10.4

