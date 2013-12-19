Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3LSJSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:18:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab3LSJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:18:08 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 1/2] mfd: wm5110: Expose DRE control registers
Date: Thu, 19 Dec 2013 09:11:01 +0000
Message-Id: <1387444262-26456-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain use-cases require the DRE to be disabled so expose registers
necessary to control the DRE enables.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c           |    2 ++
 include/linux/mfd/arizona/registers.h |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 338cfbe..abd6713 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -601,6 +601,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x0000043D, 0x0180 },    /* R1085  - DAC Digital Volume 6R */
 	{ 0x0000043E, 0x0080 },    /* R1086  - DAC Volume Limit 6R */
 	{ 0x0000043F, 0x0800 },    /* R1087  - Noise Gate Select 6R */
+	{ 0x00000440, 0x8FFF },    /* R1088  - DRE Enable */
 	{ 0x00000450, 0x0000 },    /* R1104  - DAC AEC Control 1 */
 	{ 0x00000458, 0x0000 },    /* R1112  - Noise Gate Control */
 	{ 0x00000480, 0x0040 },    /* R1152  - Class W ANC Threshold 1 */
@@ -1631,6 +1632,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DAC_DIGITAL_VOLUME_6R:
 	case ARIZONA_DAC_VOLUME_LIMIT_6R:
 	case ARIZONA_NOISE_GATE_SELECT_6R:
+	case ARIZONA_DRE_ENABLE:
 	case ARIZONA_DAC_AEC_CONTROL_1:
 	case ARIZONA_NOISE_GATE_CONTROL:
 	case ARIZONA_PDM_SPK1_CTRL_1:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 8987814..22916c0 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -3207,6 +3207,10 @@
 /*
  * R1088 (0x440) - DRE Enable
  */
+#define ARIZONA_DRE3R_ENA                        0x0020  /* DRE3R_ENA */
+#define ARIZONA_DRE3R_ENA_MASK                   0x0020  /* DRE3R_ENA */
+#define ARIZONA_DRE3R_ENA_SHIFT                       5  /* DRE3R_ENA */
+#define ARIZONA_DRE3R_ENA_WIDTH                       1  /* DRE3R_ENA */
 #define ARIZONA_DRE3L_ENA                        0x0010  /* DRE3L_ENA */
 #define ARIZONA_DRE3L_ENA_MASK                   0x0010  /* DRE3L_ENA */
 #define ARIZONA_DRE3L_ENA_SHIFT                       4  /* DRE3L_ENA */
-- 
1.7.2.5

