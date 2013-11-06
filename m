Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3KFKQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:16:55 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46871 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3KFKQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/13] ARM: ux500: Don't use enums for MSP IDs - for easy DT conversion
Date: Wed,  6 Nov 2013 10:16:15 +0000
Message-Id: <1383732985-18928-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-audio.c     | 8 ++++----
 include/linux/platform_data/asoc-ux500-msp.h | 9 +--------
 sound/soc/ux500/ux500_msp_i2s.h              | 2 +-
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index d528059..c5eeee3 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -29,7 +29,7 @@ static struct stedma40_chan_cfg msp0_dma_tx = {
 };
 
 struct msp_i2s_platform_data msp0_platform_data = {
-	.id = MSP_I2S_0,
+	.id = 0,
 	.msp_i2s_dma_rx = &msp0_dma_rx,
 	.msp_i2s_dma_tx = &msp0_dma_tx,
 };
@@ -47,7 +47,7 @@ static struct stedma40_chan_cfg msp1_dma_tx = {
 };
 
 struct msp_i2s_platform_data msp1_platform_data = {
-	.id = MSP_I2S_1,
+	.id = 1,
 	.msp_i2s_dma_rx = NULL,
 	.msp_i2s_dma_tx = &msp1_dma_tx,
 };
@@ -67,13 +67,13 @@ static struct stedma40_chan_cfg msp2_dma_tx = {
 };
 
 struct msp_i2s_platform_data msp2_platform_data = {
-	.id = MSP_I2S_2,
+	.id = 2,
 	.msp_i2s_dma_rx = &msp2_dma_rx,
 	.msp_i2s_dma_tx = &msp2_dma_tx,
 };
 
 struct msp_i2s_platform_data msp3_platform_data = {
-	.id		= MSP_I2S_3,
+	.id		= 3,
 	.msp_i2s_dma_rx	= &msp1_dma_rx,
 	.msp_i2s_dma_tx	= NULL,
 };
diff --git a/include/linux/platform_data/asoc-ux500-msp.h b/include/linux/platform_data/asoc-ux500-msp.h
index 9991aea..2f34bb9 100644
--- a/include/linux/platform_data/asoc-ux500-msp.h
+++ b/include/linux/platform_data/asoc-ux500-msp.h
@@ -10,16 +10,9 @@
 
 #include <linux/platform_data/dma-ste-dma40.h>
 
-enum msp_i2s_id {
-	MSP_I2S_0 = 0,
-	MSP_I2S_1,
-	MSP_I2S_2,
-	MSP_I2S_3,
-};
-
 /* Platform data structure for a MSP I2S-device */
 struct msp_i2s_platform_data {
-	enum msp_i2s_id id;
+	int id;
 	struct stedma40_chan_cfg *msp_i2s_dma_rx;
 	struct stedma40_chan_cfg *msp_i2s_dma_tx;
 };
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 258d0bc..875de0f 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -475,7 +475,7 @@ struct ux500_msp_dma_params {
 };
 
 struct ux500_msp {
-	enum msp_i2s_id id;
+	int id;
 	void __iomem *registers;
 	struct device *dev;
 	struct ux500_msp_dma_params playback_dma_data;
-- 
1.8.1.2

