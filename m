Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaEWOsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:48:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49906 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbaEWOsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:48:16 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mfd: arizona: Rename thermal shutdown interrupt
Date: Fri, 23 May 2014 15:40:32 +0100
Message-Id: <1400856034-4509-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer versions of the IP introduce short circuit protection which will
also shutdown the speaker. Rename the interrupt and associated register
bits associated with thermal events to better fit the function and avoid
conflict with future interrupt additions.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    8 ++--
 drivers/mfd/wm5110-tables.c           |    8 ++--
 drivers/mfd/wm8997-tables.c           |    8 ++--
 include/linux/mfd/arizona/core.h      |    4 +-
 include/linux/mfd/arizona/registers.h |   80 ++++++++++++++++----------------
 sound/soc/codecs/arizona.c            |   10 ++--
 6 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 187ee86..bfe0504 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -151,11 +151,11 @@ static const struct regmap_irq wm5102_irqs[ARIZONA_NUM_IRQ] = {
 		.reg_offset = 1, .mask = ARIZONA_DSP_IRQ1_EINT1
 	},
 
-	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
 	},
-	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
 	},
 	[ARIZONA_IRQ_HPDET] = {
 		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index b92a217..4c3672c9 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -340,11 +340,11 @@ static const struct regmap_irq wm5110_irqs[ARIZONA_NUM_IRQ] = {
 		.reg_offset = 1, .mask = ARIZONA_DSP_IRQ1_EINT1
 	},
 
-	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
 	},
-	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
 	},
 	[ARIZONA_IRQ_HPDET] = {
 		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
index c9c6519..529adc1 100644
--- a/drivers/mfd/wm8997-tables.c
+++ b/drivers/mfd/wm8997-tables.c
@@ -65,11 +65,11 @@ static const struct regmap_irq wm8997_irqs[ARIZONA_NUM_IRQ] = {
 	[ARIZONA_IRQ_GP2] = { .reg_offset = 0, .mask = ARIZONA_GP2_EINT1 },
 	[ARIZONA_IRQ_GP1] = { .reg_offset = 0, .mask = ARIZONA_GP1_EINT1 },
 
-	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
 	},
-	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
-		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
+	[ARIZONA_IRQ_SPK_OVERHEAT] = {
+		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
 	},
 	[ARIZONA_IRQ_HPDET] = {
 		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 03803d9..8ee74f0 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -46,8 +46,8 @@ enum arizona_type {
 #define ARIZONA_IRQ_DSP_IRQ6              17
 #define ARIZONA_IRQ_DSP_IRQ7              18
 #define ARIZONA_IRQ_DSP_IRQ8              19
-#define ARIZONA_IRQ_SPK_SHUTDOWN_WARN     20
-#define ARIZONA_IRQ_SPK_SHUTDOWN          21
+#define ARIZONA_IRQ_SPK_OVERHEAT_WARN     20
+#define ARIZONA_IRQ_SPK_OVERHEAT          21
 #define ARIZONA_IRQ_MICDET                22
 #define ARIZONA_IRQ_HPDET                 23
 #define ARIZONA_IRQ_WSEQ_DONE             24
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 441f99f..7774087 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -4689,14 +4689,14 @@
 /*
  * R3330 (0xD02) - Interrupt Status 3
  */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1          0x8000  /* SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_MASK     0x8000  /* SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_SHIFT        15  /* SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_WIDTH         1  /* SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_EINT1               0x4000  /* SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_EINT1_MASK          0x4000  /* SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_EINT1_SHIFT             14  /* SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_SPK_SHUTDOWN_EINT1_WIDTH              1  /* SPK_SHUTDOWN_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT1          0x8000  /* SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_MASK     0x8000  /* SPK_OVERHEAD_WARN_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_SHIFT        15  /* SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_WIDTH         1  /* SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_EINT1               0x4000  /* SPK_OVERHEAT_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_EINT1_MASK          0x4000  /* SPK_OVERHEAT_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_EINT1_SHIFT             14  /* SPK_OVERHEAT_EINT1 */
+#define ARIZONA_SPK_OVERHEAT_EINT1_WIDTH              1  /* SPK_OVERHEAT_EINT1 */
 #define ARIZONA_HPDET_EINT1                      0x2000  /* HPDET_EINT1 */
 #define ARIZONA_HPDET_EINT1_MASK                 0x2000  /* HPDET_EINT1 */
 #define ARIZONA_HPDET_EINT1_SHIFT                    13  /* HPDET_EINT1 */
@@ -4881,14 +4881,14 @@
 /*
  * R3338 (0xD0A) - Interrupt Status 3 Mask
  */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1       0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_MASK  0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_SHIFT     15  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_WIDTH      1  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT1            0x4000  /* IM_SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_MASK       0x4000  /* IM_SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_SHIFT          14  /* IM_SPK_SHUTDOWN_EINT1 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_WIDTH           1  /* IM_SPK_SHUTDOWN_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1       0x8000  /* IM_SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_MASK  0x8000  /* IM_SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_SHIFT     15  /* IM_SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_WIDTH      1  /* IM_SPK_OVERHEAT_WARN_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT1            0x4000  /* IM_SPK_OVERHEAT_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT1_MASK       0x4000  /* IM_SPK_OVERHEAT_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT1_SHIFT          14  /* IM_SPK_OVERHEAT_EINT1 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT1_WIDTH           1  /* IM_SPK_OVERHEAT_EINT1 */
 #define ARIZONA_IM_HPDET_EINT1                   0x2000  /* IM_HPDET_EINT1 */
 #define ARIZONA_IM_HPDET_EINT1_MASK              0x2000  /* IM_HPDET_EINT1 */
 #define ARIZONA_IM_HPDET_EINT1_SHIFT                 13  /* IM_HPDET_EINT1 */
@@ -5081,14 +5081,14 @@
 /*
  * R3346 (0xD12) - IRQ2 Status 3
  */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2          0x8000  /* SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_MASK     0x8000  /* SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_SHIFT        15  /* SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_WIDTH         1  /* SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_EINT2               0x4000  /* SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_EINT2_MASK          0x4000  /* SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_EINT2_SHIFT             14  /* SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_SPK_SHUTDOWN_EINT2_WIDTH              1  /* SPK_SHUTDOWN_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT2          0x8000  /* SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_MASK     0x8000  /* SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_SHIFT        15  /* SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_WIDTH         1  /* SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_EINT2               0x4000  /* SPK_OVERHEAT_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_EINT2_MASK          0x4000  /* SPK_OVERHEAT_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_EINT2_SHIFT             14  /* SPK_OVERHEAT_EINT2 */
+#define ARIZONA_SPK_OVERHEAT_EINT2_WIDTH              1  /* SPK_OVERHEAT_EINT2 */
 #define ARIZONA_HPDET_EINT2                      0x2000  /* HPDET_EINT2 */
 #define ARIZONA_HPDET_EINT2_MASK                 0x2000  /* HPDET_EINT2 */
 #define ARIZONA_HPDET_EINT2_SHIFT                    13  /* HPDET_EINT2 */
@@ -5273,14 +5273,14 @@
 /*
  * R3354 (0xD1A) - IRQ2 Status 3 Mask
  */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2       0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_MASK  0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_SHIFT     15  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_WIDTH      1  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT2            0x4000  /* IM_SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_MASK       0x4000  /* IM_SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_SHIFT          14  /* IM_SPK_SHUTDOWN_EINT2 */
-#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_WIDTH           1  /* IM_SPK_SHUTDOWN_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2       0x8000  /* IM_SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_MASK  0x8000  /* IM_SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_SHIFT     15  /* IM_SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_WIDTH      1  /* IM_SPK_OVERHEAT_WARN_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT2            0x4000  /* IM_SPK_OVERHEAT_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT2_MASK       0x4000  /* IM_SPK_OVERHEAT_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT2_SHIFT          14  /* IM_SPK_OVERHEAT_EINT2 */
+#define ARIZONA_IM_SPK_OVERHEAT_EINT2_WIDTH           1  /* IM_SPK_OVERHEAT_EINT2 */
 #define ARIZONA_IM_HPDET_EINT2                   0x2000  /* IM_HPDET_EINT2 */
 #define ARIZONA_IM_HPDET_EINT2_MASK              0x2000  /* IM_HPDET_EINT2 */
 #define ARIZONA_IM_HPDET_EINT2_SHIFT                 13  /* IM_HPDET_EINT2 */
@@ -5454,14 +5454,14 @@
 /*
  * R3361 (0xD21) - Interrupt Raw Status 3
  */
-#define ARIZONA_SPK_SHUTDOWN_WARN_STS            0x8000  /* SPK_SHUTDOWN_WARN_STS */
-#define ARIZONA_SPK_SHUTDOWN_WARN_STS_MASK       0x8000  /* SPK_SHUTDOWN_WARN_STS */
-#define ARIZONA_SPK_SHUTDOWN_WARN_STS_SHIFT          15  /* SPK_SHUTDOWN_WARN_STS */
-#define ARIZONA_SPK_SHUTDOWN_WARN_STS_WIDTH           1  /* SPK_SHUTDOWN_WARN_STS */
-#define ARIZONA_SPK_SHUTDOWN_STS                 0x4000  /* SPK_SHUTDOWN_STS */
-#define ARIZONA_SPK_SHUTDOWN_STS_MASK            0x4000  /* SPK_SHUTDOWN_STS */
-#define ARIZONA_SPK_SHUTDOWN_STS_SHIFT               14  /* SPK_SHUTDOWN_STS */
-#define ARIZONA_SPK_SHUTDOWN_STS_WIDTH                1  /* SPK_SHUTDOWN_STS */
+#define ARIZONA_SPK_OVERHEAT_WARN_STS            0x8000  /* SPK_OVERHEAT_WARN_STS */
+#define ARIZONA_SPK_OVERHEAT_WARN_STS_MASK       0x8000  /* SPK_OVERHEAT_WARN_STS */
+#define ARIZONA_SPK_OVERHEAT_WARN_STS_SHIFT          15  /* SPK_OVERHEAT_WARN_STS */
+#define ARIZONA_SPK_OVERHEAT_WARN_STS_WIDTH           1  /* SPK_OVERHEAT_WARN_STS */
+#define ARIZONA_SPK_OVERHEAT_STS                 0x4000  /* SPK_OVERHEAT_STS */
+#define ARIZONA_SPK_OVERHEAT_STS_MASK            0x4000  /* SPK_OVERHEAT_STS */
+#define ARIZONA_SPK_OVERHEAT_STS_SHIFT               14  /* SPK_OVERHEAT_STS */
+#define ARIZONA_SPK_OVERHEAT_STS_WIDTH                1  /* SPK_OVERHEAT_STS */
 #define ARIZONA_HPDET_STS                        0x2000  /* HPDET_STS */
 #define ARIZONA_HPDET_STS_MASK                   0x2000  /* HPDET_STS */
 #define ARIZONA_HPDET_STS_SHIFT                      13  /* HPDET_STS */
diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index e4295fe..666d516 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -99,7 +99,7 @@ static int arizona_spk_ev(struct snd_soc_dapm_widget *w,
 		break;
 	case SND_SOC_DAPM_POST_PMU:
 		val = snd_soc_read(codec, ARIZONA_INTERRUPT_RAW_STATUS_3);
-		if (val & ARIZONA_SPK_SHUTDOWN_STS) {
+		if (val & ARIZONA_SPK_OVERHEAT_STS) {
 			dev_crit(arizona->dev,
 				 "Speaker not enabled due to temperature\n");
 			return -EBUSY;
@@ -151,7 +151,7 @@ static irqreturn_t arizona_thermal_warn(int irq, void *data)
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read thermal status: %d\n",
 			ret);
-	} else if (val & ARIZONA_SPK_SHUTDOWN_WARN_STS) {
+	} else if (val & ARIZONA_SPK_OVERHEAT_WARN_STS) {
 		dev_crit(arizona->dev, "Thermal warning\n");
 	}
 
@@ -169,7 +169,7 @@ static irqreturn_t arizona_thermal_shutdown(int irq, void *data)
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read thermal status: %d\n",
 			ret);
-	} else if (val & ARIZONA_SPK_SHUTDOWN_STS) {
+	} else if (val & ARIZONA_SPK_OVERHEAT_STS) {
 		dev_crit(arizona->dev, "Thermal shutdown\n");
 		ret = regmap_update_bits(arizona->regmap,
 					 ARIZONA_OUTPUT_ENABLES_1,
@@ -215,7 +215,7 @@ int arizona_init_spk(struct snd_soc_codec *codec)
 		break;
 	}
 
-	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_SHUTDOWN_WARN,
+	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_OVERHEAT_WARN,
 				  "Thermal warning", arizona_thermal_warn,
 				  arizona);
 	if (ret != 0)
@@ -223,7 +223,7 @@ int arizona_init_spk(struct snd_soc_codec *codec)
 			"Failed to get thermal warning IRQ: %d\n",
 			ret);
 
-	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_SHUTDOWN,
+	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_OVERHEAT,
 				  "Thermal shutdown", arizona_thermal_shutdown,
 				  arizona);
 	if (ret != 0)
-- 
1.7.2.5

