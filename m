Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3AYSZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:25:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932179Ab3AYSZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:25:52 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Make DSP scratch registers readable
Date: Fri, 25 Jan 2013 17:09:23 +0800
Message-Id: <1359104964-27041-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    8 ++++++++
 include/linux/mfd/arizona/registers.h |   16 ++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index ea3e40a..1ee3a81 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1815,6 +1815,10 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_SCRATCH_0:
+	case ARIZONA_DSP1_SCRATCH_1:
+	case ARIZONA_DSP1_SCRATCH_2:
+	case ARIZONA_DSP1_SCRATCH_3:
 		return true;
 	default:
 		if ((reg >= 0x100000 && reg < 0x106000) ||
@@ -1869,6 +1873,10 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_SCRATCH_0:
+	case ARIZONA_DSP1_SCRATCH_1:
+	case ARIZONA_DSP1_SCRATCH_2:
+	case ARIZONA_DSP1_SCRATCH_3:
 	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_HP_DACVAL:
 	case ARIZONA_MIC_DETECT_3:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 88cc9b0..df555fd 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -990,18 +990,34 @@
 #define ARIZONA_DSP1_STATUS_1                    0x1104
 #define ARIZONA_DSP1_STATUS_2                    0x1105
 #define ARIZONA_DSP1_STATUS_3                    0x1106
+#define ARIZONA_DSP1_SCRATCH_0                   0x1140
+#define ARIZONA_DSP1_SCRATCH_1                   0x1141
+#define ARIZONA_DSP1_SCRATCH_2                   0x1142
+#define ARIZONA_DSP1_SCRATCH_3                   0x1143
 #define ARIZONA_DSP2_CONTROL_1                   0x1200
 #define ARIZONA_DSP2_CLOCKING_1                  0x1201
 #define ARIZONA_DSP2_STATUS_1                    0x1204
 #define ARIZONA_DSP2_STATUS_2                    0x1205
+#define ARIZONA_DSP2_SCRATCH_0                   0x1240
+#define ARIZONA_DSP2_SCRATCH_1                   0x1241
+#define ARIZONA_DSP2_SCRATCH_2                   0x1242
+#define ARIZONA_DSP2_SCRATCH_3                   0x1243
 #define ARIZONA_DSP3_CONTROL_1                   0x1300
 #define ARIZONA_DSP3_CLOCKING_1                  0x1301
 #define ARIZONA_DSP3_STATUS_1                    0x1304
 #define ARIZONA_DSP3_STATUS_2                    0x1305
+#define ARIZONA_DSP3_SCRATCH_0                   0x1340
+#define ARIZONA_DSP3_SCRATCH_1                   0x1341
+#define ARIZONA_DSP3_SCRATCH_2                   0x1342
+#define ARIZONA_DSP3_SCRATCH_3                   0x1343
 #define ARIZONA_DSP4_CONTROL_1                   0x1400
 #define ARIZONA_DSP4_CLOCKING_1                  0x1401
 #define ARIZONA_DSP4_STATUS_1                    0x1404
 #define ARIZONA_DSP4_STATUS_2                    0x1405
+#define ARIZONA_DSP4_SCRATCH_0                   0x1440
+#define ARIZONA_DSP4_SCRATCH_1                   0x1441
+#define ARIZONA_DSP4_SCRATCH_2                   0x1442
+#define ARIZONA_DSP4_SCRATCH_3                   0x1443
 
 /*
  * Field Definitions.
-- 
1.7.10.4

