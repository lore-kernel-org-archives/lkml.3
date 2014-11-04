Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaKDPcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:32:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37630 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbaKDPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:32:22 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: arizona: Document HP_CTRL_1L and HP_CTRL_1R registers
Date: Tue,  4 Nov 2014 15:24:36 +0000
Message-Id: <1415114676-32614-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These registers are documented in the datasheet and used as part of the
extcon driver. Expose them properly through regmap as the datasheet
notes they should be treated as volatile do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    6 +++-
 drivers/mfd/wm5110-tables.c           |    4 +++
 drivers/mfd/wm8997-tables.c           |    4 +++
 include/linux/mfd/arizona/registers.h |   42 +++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index d6f35bb..b326a82 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -336,8 +336,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000218, 0x01A6 },   /* R536   - Mic Bias Ctrl 1 */ 
 	{ 0x00000219, 0x01A6 },   /* R537   - Mic Bias Ctrl 2 */ 
 	{ 0x0000021A, 0x01A6 },   /* R538   - Mic Bias Ctrl 3 */ 
-	{ 0x00000225, 0x0400 },   /* R549   - HP Ctrl 1L */
-	{ 0x00000226, 0x0400 },   /* R550   - HP Ctrl 1R */
 	{ 0x00000293, 0x0000 },   /* R659   - Accessory Detect Mode 1 */ 
 	{ 0x0000029B, 0x0020 },   /* R667   - Headphone Detect 1 */ 
 	{ 0x0000029C, 0x0000 },   /* R668   - Headphone Detect 2 */
@@ -1112,6 +1110,8 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_BIAS_CTRL_1:
 	case ARIZONA_MIC_BIAS_CTRL_2:
 	case ARIZONA_MIC_BIAS_CTRL_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_ACCESSORY_DETECT_MODE_1:
 	case ARIZONA_HEADPHONE_DETECT_1:
 	case ARIZONA_HEADPHONE_DETECT_2:
@@ -1949,6 +1949,8 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
 	case ARIZONA_DSP1_SCRATCH_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_HP_DACVAL:
 	case ARIZONA_MIC_DETECT_3:
diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 64eab95..12cad94 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -1798,6 +1798,8 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_BIAS_CTRL_1:
 	case ARIZONA_MIC_BIAS_CTRL_2:
 	case ARIZONA_MIC_BIAS_CTRL_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_ACCESSORY_DETECT_MODE_1:
 	case ARIZONA_HEADPHONE_DETECT_1:
 	case ARIZONA_HEADPHONE_DETECT_2:
@@ -2841,6 +2843,8 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
 	case ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS:
 	case ARIZONA_MIC_DETECT_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_INPUT_ENABLES_STATUS:
 	case ARIZONA_OUTPUT_STATUS_1:
diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
index 510da3b..06c3093 100644
--- a/drivers/mfd/wm8997-tables.c
+++ b/drivers/mfd/wm8997-tables.c
@@ -886,6 +886,8 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_BIAS_CTRL_1:
 	case ARIZONA_MIC_BIAS_CTRL_2:
 	case ARIZONA_MIC_BIAS_CTRL_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_ACCESSORY_DETECT_MODE_1:
 	case ARIZONA_HEADPHONE_DETECT_1:
 	case ARIZONA_HEADPHONE_DETECT_2:
@@ -1477,6 +1479,8 @@ static bool wm8997_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_SAMPLE_RATE_3_STATUS:
 	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
 	case ARIZONA_MIC_DETECT_3:
+	case ARIZONA_HP_CTRL_1L:
+	case ARIZONA_HP_CTRL_1R:
 	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_INPUT_ENABLES_STATUS:
 	case ARIZONA_OUTPUT_STATUS_1:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index fbf6489..aacc10d 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -125,6 +125,8 @@
 #define ARIZONA_MIC_BIAS_CTRL_1                  0x218
 #define ARIZONA_MIC_BIAS_CTRL_2                  0x219
 #define ARIZONA_MIC_BIAS_CTRL_3                  0x21A
+#define ARIZONA_HP_CTRL_1L                       0x225
+#define ARIZONA_HP_CTRL_1R                       0x226
 #define ARIZONA_ACCESSORY_DETECT_MODE_1          0x293
 #define ARIZONA_HEADPHONE_DETECT_1               0x29B
 #define ARIZONA_HEADPHONE_DETECT_2               0x29C
@@ -2253,6 +2255,46 @@
 #define ARIZONA_MICB3_ENA_WIDTH                       1  /* MICB3_ENA */
 
 /*
+ * R549 (0x225) - HP Ctrl 1L
+ */
+#define ARIZONA_RMV_SHRT_HP1L                    0x4000  /* RMV_SHRT_HP1L */
+#define ARIZONA_RMV_SHRT_HP1L_MASK               0x4000  /* RMV_SHRT_HP1L */
+#define ARIZONA_RMV_SHRT_HP1L_SHIFT                  14  /* RMV_SHRT_HP1L */
+#define ARIZONA_RMV_SHRT_HP1L_WIDTH                   1  /* RMV_SHRT_HP1L */
+#define ARIZONA_HP1L_FLWR                        0x0004  /* HP1L_FLWR */
+#define ARIZONA_HP1L_FLWR_MASK                   0x0004  /* HP1L_FLWR */
+#define ARIZONA_HP1L_FLWR_SHIFT                       2  /* HP1L_FLWR */
+#define ARIZONA_HP1L_FLWR_WIDTH                       1  /* HP1L_FLWR */
+#define ARIZONA_HP1L_SHRTI                       0x0002  /* HP1L_SHRTI */
+#define ARIZONA_HP1L_SHRTI_MASK                  0x0002  /* HP1L_SHRTI */
+#define ARIZONA_HP1L_SHRTI_SHIFT                      1  /* HP1L_SHRTI */
+#define ARIZONA_HP1L_SHRTI_WIDTH                      1  /* HP1L_SHRTI */
+#define ARIZONA_HP1L_SHRTO                       0x0001  /* HP1L_SHRTO */
+#define ARIZONA_HP1L_SHRTO_MASK                  0x0001  /* HP1L_SHRTO */
+#define ARIZONA_HP1L_SHRTO_SHIFT                      0  /* HP1L_SHRTO */
+#define ARIZONA_HP1L_SHRTO_WIDTH                      1  /* HP1L_SHRTO */
+
+/*
+ * R550 (0x226) - HP Ctrl 1R
+ */
+#define ARIZONA_RMV_SHRT_HP1R                    0x4000  /* RMV_SHRT_HP1R */
+#define ARIZONA_RMV_SHRT_HP1R_MASK               0x4000  /* RMV_SHRT_HP1R */
+#define ARIZONA_RMV_SHRT_HP1R_SHIFT                  14  /* RMV_SHRT_HP1R */
+#define ARIZONA_RMV_SHRT_HP1R_WIDTH                   1  /* RMV_SHRT_HP1R */
+#define ARIZONA_HP1R_FLWR                        0x0004  /* HP1R_FLWR */
+#define ARIZONA_HP1R_FLWR_MASK                   0x0004  /* HP1R_FLWR */
+#define ARIZONA_HP1R_FLWR_SHIFT                       2  /* HP1R_FLWR */
+#define ARIZONA_HP1R_FLWR_WIDTH                       1  /* HP1R_FLWR */
+#define ARIZONA_HP1R_SHRTI                       0x0002  /* HP1R_SHRTI */
+#define ARIZONA_HP1R_SHRTI_MASK                  0x0002  /* HP1R_SHRTI */
+#define ARIZONA_HP1R_SHRTI_SHIFT                      1  /* HP1R_SHRTI */
+#define ARIZONA_HP1R_SHRTI_WIDTH                      1  /* HP1R_SHRTI */
+#define ARIZONA_HP1R_SHRTO                       0x0001  /* HP1R_SHRTO */
+#define ARIZONA_HP1R_SHRTO_MASK                  0x0001  /* HP1R_SHRTO */
+#define ARIZONA_HP1R_SHRTO_SHIFT                      0  /* HP1R_SHRTO */
+#define ARIZONA_HP1R_SHRTO_WIDTH                      1  /* HP1R_SHRTO */
+
+/*
  * R659 (0x293) - Accessory Detect Mode 1
  */
 #define ARIZONA_ACCDET_SRC                       0x2000  /* ACCDET_SRC */
-- 
1.7.2.5

