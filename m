Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3KFKH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:07:59 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57622 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:05:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/7] ARM: ux500: Remove legacy ATAG SSP support
Date: Wed,  6 Nov 2013 10:05:42 +0000
Message-Id: <1383732348-18576-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hasn't been used since we converted the platform to DT only.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 30 ------------------------------
 arch/arm/mach-ux500/board-mop500.h |  1 -
 2 files changed, 31 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 514d40b..d552163 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -46,33 +46,3 @@ struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
 	.regulator	= &ab8500_regulator_plat_data,
 };
-
-#ifdef CONFIG_STE_DMA40
-static struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV8_SSP0,
-};
-
-static struct stedma40_chan_cfg ssp0_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV8_SSP0,
-};
-#endif
-
-struct pl022_ssp_controller ssp0_plat = {
-	.bus_id = 0,
-#ifdef CONFIG_STE_DMA40
-	.enable_dma = 1,
-	.dma_filter = stedma40_filter,
-	.dma_rx_param = &ssp0_dma_cfg_rx,
-	.dma_tx_param = &ssp0_dma_cfg_tx,
-#else
-	.enable_dma = 0,
-#endif
-	/* on this platform, gpio 31,142,144,214 &
-	 * 224 are connected as chip selects
-	 */
-	.num_chipselect = 5,
-};
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 511d6fe..d48e866 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -87,7 +87,6 @@ extern struct msp_i2s_platform_data msp0_platform_data;
 extern struct msp_i2s_platform_data msp1_platform_data;
 extern struct msp_i2s_platform_data msp2_platform_data;
 extern struct msp_i2s_platform_data msp3_platform_data;
-extern struct pl022_ssp_controller ssp0_plat;
 
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
-- 
1.8.1.2

