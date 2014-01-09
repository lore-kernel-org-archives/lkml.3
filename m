Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaAIOh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:37:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34083 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbaAIOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:37:35 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH v2 1/2] mfd: wm5110: Add registers for headphone short circuit control
Date: Thu,  9 Jan 2014 14:29:24 +0000
Message-Id: <1389277765-23914-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the registers necessary to enable/disable the headphone short
circuit protection.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c           |    6 ++++++
 include/linux/mfd/arizona/registers.h |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

Changes since v1:
  - Add switch to the control names in the second patch in the series.

Thanks,
Charles

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 24ec464..30f8163 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -637,6 +637,9 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000491, 0x0000 },    /* R1169  - PDM SPK1 CTRL 2 */
 	{ 0x00000492, 0x0069 },    /* R1170  - PDM SPK2 CTRL 1 */
 	{ 0x00000493, 0x0000 },    /* R1171  - PDM SPK2 CTRL 2 */
+	{ 0x000004A0, 0x3480 },    /* R1184  - HP1 Short Circuit Ctrl */
+	{ 0x000004A1, 0x3480 },    /* R1185  - HP2 Short Circuit Ctrl */
+	{ 0x000004A2, 0x3480 },    /* R1186  - HP3 Short Circuit Ctrl */
 	{ 0x00000500, 0x000C },    /* R1280  - AIF1 BCLK Ctrl */
 	{ 0x00000501, 0x0008 },    /* R1281  - AIF1 Tx Pin Ctrl */
 	{ 0x00000502, 0x0000 },    /* R1282  - AIF1 Rx Pin Ctrl */
@@ -1633,6 +1636,9 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_PDM_SPK1_CTRL_2:
 	case ARIZONA_PDM_SPK2_CTRL_1:
 	case ARIZONA_PDM_SPK2_CTRL_2:
+	case ARIZONA_HP1_SHORT_CIRCUIT_CTRL:
+	case ARIZONA_HP2_SHORT_CIRCUIT_CTRL:
+	case ARIZONA_HP3_SHORT_CIRCUIT_CTRL:
 	case ARIZONA_AIF1_BCLK_CTRL:
 	case ARIZONA_AIF1_TX_PIN_CTRL:
 	case ARIZONA_AIF1_RX_PIN_CTRL:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index b40960d..2d3ac50 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -226,6 +226,9 @@
 #define ARIZONA_PDM_SPK1_CTRL_2                  0x491
 #define ARIZONA_PDM_SPK2_CTRL_1                  0x492
 #define ARIZONA_PDM_SPK2_CTRL_2                  0x493
+#define ARIZONA_HP1_SHORT_CIRCUIT_CTRL           0x4A0
+#define ARIZONA_HP2_SHORT_CIRCUIT_CTRL           0x4A1
+#define ARIZONA_HP3_SHORT_CIRCUIT_CTRL           0x4A2
 #define ARIZONA_SPK_CTRL_2                       0x4B5
 #define ARIZONA_SPK_CTRL_3                       0x4B6
 #define ARIZONA_DAC_COMP_1                       0x4DC
@@ -3297,6 +3300,30 @@
 #define ARIZONA_SPK2_FMT_WIDTH                        1  /* SPK2_FMT */
 
 /*
+ * R1184 (0x4A0) - HP1 Short Circuit Ctrl
+ */
+#define ARIZONA_HP1_SC_ENA                       0x1000  /* HP1_SC_ENA */
+#define ARIZONA_HP1_SC_ENA_MASK                  0x1000  /* HP1_SC_ENA */
+#define ARIZONA_HP1_SC_ENA_SHIFT                     12  /* HP1_SC_ENA */
+#define ARIZONA_HP1_SC_ENA_WIDTH                      1  /* HP1_SC_ENA */
+
+/*
+ * R1185 (0x4A1) - HP2 Short Circuit Ctrl
+ */
+#define ARIZONA_HP2_SC_ENA                       0x1000  /* HP2_SC_ENA */
+#define ARIZONA_HP2_SC_ENA_MASK                  0x1000  /* HP2_SC_ENA */
+#define ARIZONA_HP2_SC_ENA_SHIFT                     12  /* HP2_SC_ENA */
+#define ARIZONA_HP2_SC_ENA_WIDTH                      1  /* HP2_SC_ENA */
+
+/*
+ * R1186 (0x4A2) - HP3 Short Circuit Ctrl
+ */
+#define ARIZONA_HP3_SC_ENA                       0x1000  /* HP3_SC_ENA */
+#define ARIZONA_HP3_SC_ENA_MASK                  0x1000  /* HP3_SC_ENA */
+#define ARIZONA_HP3_SC_ENA_SHIFT                     12  /* HP3_SC_ENA */
+#define ARIZONA_HP3_SC_ENA_WIDTH                      1  /* HP3_SC_ENA */
+
+/*
  * R1244 (0x4DC) - DAC comp 1
  */
 #define ARIZONA_OUT_COMP_COEFF_MASK              0xFFFF  /* OUT_COMP_COEFF - [15:0] */
-- 
1.7.2.5

