Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaAVNMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:12:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37287 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbaAVNMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:12:44 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: wm5110: Make additional DSP registers available to the user
Date: Wed, 22 Jan 2014 13:04:24 +0000
Message-Id: <1390395865-4396-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose some DSP registers which are useful for DSP users to be able to
access whilst debugging their firmware.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c           |  168 +++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/registers.h |   67 +++++++++++++
 2 files changed, 235 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 24ec464..74c71da 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -2389,6 +2389,27 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_STATUS_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_1:
+	case ARIZONA_DSP1_WDMA_BUFFER_2:
+	case ARIZONA_DSP1_WDMA_BUFFER_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_5:
+	case ARIZONA_DSP1_WDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_BUFFER_7:
+	case ARIZONA_DSP1_WDMA_BUFFER_8:
+	case ARIZONA_DSP1_RDMA_BUFFER_1:
+	case ARIZONA_DSP1_RDMA_BUFFER_2:
+	case ARIZONA_DSP1_RDMA_BUFFER_3:
+	case ARIZONA_DSP1_RDMA_BUFFER_4:
+	case ARIZONA_DSP1_RDMA_BUFFER_5:
+	case ARIZONA_DSP1_RDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_CONFIG_1:
+	case ARIZONA_DSP1_WDMA_CONFIG_2:
+	case ARIZONA_DSP1_WDMA_OFFSET_1:
+	case ARIZONA_DSP1_RDMA_CONFIG_1:
+	case ARIZONA_DSP1_RDMA_OFFSET_1:
+	case ARIZONA_DSP1_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP1_SCRATCH_0:
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
@@ -2398,6 +2419,27 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
+	case ARIZONA_DSP2_STATUS_4:
+	case ARIZONA_DSP2_WDMA_BUFFER_1:
+	case ARIZONA_DSP2_WDMA_BUFFER_2:
+	case ARIZONA_DSP2_WDMA_BUFFER_3:
+	case ARIZONA_DSP2_WDMA_BUFFER_4:
+	case ARIZONA_DSP2_WDMA_BUFFER_5:
+	case ARIZONA_DSP2_WDMA_BUFFER_6:
+	case ARIZONA_DSP2_WDMA_BUFFER_7:
+	case ARIZONA_DSP2_WDMA_BUFFER_8:
+	case ARIZONA_DSP2_RDMA_BUFFER_1:
+	case ARIZONA_DSP2_RDMA_BUFFER_2:
+	case ARIZONA_DSP2_RDMA_BUFFER_3:
+	case ARIZONA_DSP2_RDMA_BUFFER_4:
+	case ARIZONA_DSP2_RDMA_BUFFER_5:
+	case ARIZONA_DSP2_RDMA_BUFFER_6:
+	case ARIZONA_DSP2_WDMA_CONFIG_1:
+	case ARIZONA_DSP2_WDMA_CONFIG_2:
+	case ARIZONA_DSP2_WDMA_OFFSET_1:
+	case ARIZONA_DSP2_RDMA_CONFIG_1:
+	case ARIZONA_DSP2_RDMA_OFFSET_1:
+	case ARIZONA_DSP2_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP2_SCRATCH_0:
 	case ARIZONA_DSP2_SCRATCH_1:
 	case ARIZONA_DSP2_SCRATCH_2:
@@ -2407,6 +2449,27 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
+	case ARIZONA_DSP3_STATUS_4:
+	case ARIZONA_DSP3_WDMA_BUFFER_1:
+	case ARIZONA_DSP3_WDMA_BUFFER_2:
+	case ARIZONA_DSP3_WDMA_BUFFER_3:
+	case ARIZONA_DSP3_WDMA_BUFFER_4:
+	case ARIZONA_DSP3_WDMA_BUFFER_5:
+	case ARIZONA_DSP3_WDMA_BUFFER_6:
+	case ARIZONA_DSP3_WDMA_BUFFER_7:
+	case ARIZONA_DSP3_WDMA_BUFFER_8:
+	case ARIZONA_DSP3_RDMA_BUFFER_1:
+	case ARIZONA_DSP3_RDMA_BUFFER_2:
+	case ARIZONA_DSP3_RDMA_BUFFER_3:
+	case ARIZONA_DSP3_RDMA_BUFFER_4:
+	case ARIZONA_DSP3_RDMA_BUFFER_5:
+	case ARIZONA_DSP3_RDMA_BUFFER_6:
+	case ARIZONA_DSP3_WDMA_CONFIG_1:
+	case ARIZONA_DSP3_WDMA_CONFIG_2:
+	case ARIZONA_DSP3_WDMA_OFFSET_1:
+	case ARIZONA_DSP3_RDMA_CONFIG_1:
+	case ARIZONA_DSP3_RDMA_OFFSET_1:
+	case ARIZONA_DSP3_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP3_SCRATCH_0:
 	case ARIZONA_DSP3_SCRATCH_1:
 	case ARIZONA_DSP3_SCRATCH_2:
@@ -2416,6 +2479,27 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
+	case ARIZONA_DSP4_STATUS_4:
+	case ARIZONA_DSP4_WDMA_BUFFER_1:
+	case ARIZONA_DSP4_WDMA_BUFFER_2:
+	case ARIZONA_DSP4_WDMA_BUFFER_3:
+	case ARIZONA_DSP4_WDMA_BUFFER_4:
+	case ARIZONA_DSP4_WDMA_BUFFER_5:
+	case ARIZONA_DSP4_WDMA_BUFFER_6:
+	case ARIZONA_DSP4_WDMA_BUFFER_7:
+	case ARIZONA_DSP4_WDMA_BUFFER_8:
+	case ARIZONA_DSP4_RDMA_BUFFER_1:
+	case ARIZONA_DSP4_RDMA_BUFFER_2:
+	case ARIZONA_DSP4_RDMA_BUFFER_3:
+	case ARIZONA_DSP4_RDMA_BUFFER_4:
+	case ARIZONA_DSP4_RDMA_BUFFER_5:
+	case ARIZONA_DSP4_RDMA_BUFFER_6:
+	case ARIZONA_DSP4_WDMA_CONFIG_1:
+	case ARIZONA_DSP4_WDMA_CONFIG_2:
+	case ARIZONA_DSP4_WDMA_OFFSET_1:
+	case ARIZONA_DSP4_RDMA_CONFIG_1:
+	case ARIZONA_DSP4_RDMA_OFFSET_1:
+	case ARIZONA_DSP4_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP4_SCRATCH_0:
 	case ARIZONA_DSP4_SCRATCH_1:
 	case ARIZONA_DSP4_SCRATCH_2:
@@ -2471,6 +2555,27 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_STATUS_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_1:
+	case ARIZONA_DSP1_WDMA_BUFFER_2:
+	case ARIZONA_DSP1_WDMA_BUFFER_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_5:
+	case ARIZONA_DSP1_WDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_BUFFER_7:
+	case ARIZONA_DSP1_WDMA_BUFFER_8:
+	case ARIZONA_DSP1_RDMA_BUFFER_1:
+	case ARIZONA_DSP1_RDMA_BUFFER_2:
+	case ARIZONA_DSP1_RDMA_BUFFER_3:
+	case ARIZONA_DSP1_RDMA_BUFFER_4:
+	case ARIZONA_DSP1_RDMA_BUFFER_5:
+	case ARIZONA_DSP1_RDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_CONFIG_1:
+	case ARIZONA_DSP1_WDMA_CONFIG_2:
+	case ARIZONA_DSP1_WDMA_OFFSET_1:
+	case ARIZONA_DSP1_RDMA_CONFIG_1:
+	case ARIZONA_DSP1_RDMA_OFFSET_1:
+	case ARIZONA_DSP1_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP1_SCRATCH_0:
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
@@ -2478,6 +2583,27 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
+	case ARIZONA_DSP2_STATUS_4:
+	case ARIZONA_DSP2_WDMA_BUFFER_1:
+	case ARIZONA_DSP2_WDMA_BUFFER_2:
+	case ARIZONA_DSP2_WDMA_BUFFER_3:
+	case ARIZONA_DSP2_WDMA_BUFFER_4:
+	case ARIZONA_DSP2_WDMA_BUFFER_5:
+	case ARIZONA_DSP2_WDMA_BUFFER_6:
+	case ARIZONA_DSP2_WDMA_BUFFER_7:
+	case ARIZONA_DSP2_WDMA_BUFFER_8:
+	case ARIZONA_DSP2_RDMA_BUFFER_1:
+	case ARIZONA_DSP2_RDMA_BUFFER_2:
+	case ARIZONA_DSP2_RDMA_BUFFER_3:
+	case ARIZONA_DSP2_RDMA_BUFFER_4:
+	case ARIZONA_DSP2_RDMA_BUFFER_5:
+	case ARIZONA_DSP2_RDMA_BUFFER_6:
+	case ARIZONA_DSP2_WDMA_CONFIG_1:
+	case ARIZONA_DSP2_WDMA_CONFIG_2:
+	case ARIZONA_DSP2_WDMA_OFFSET_1:
+	case ARIZONA_DSP2_RDMA_CONFIG_1:
+	case ARIZONA_DSP2_RDMA_OFFSET_1:
+	case ARIZONA_DSP2_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP2_SCRATCH_0:
 	case ARIZONA_DSP2_SCRATCH_1:
 	case ARIZONA_DSP2_SCRATCH_2:
@@ -2485,6 +2611,27 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
+	case ARIZONA_DSP3_STATUS_4:
+	case ARIZONA_DSP3_WDMA_BUFFER_1:
+	case ARIZONA_DSP3_WDMA_BUFFER_2:
+	case ARIZONA_DSP3_WDMA_BUFFER_3:
+	case ARIZONA_DSP3_WDMA_BUFFER_4:
+	case ARIZONA_DSP3_WDMA_BUFFER_5:
+	case ARIZONA_DSP3_WDMA_BUFFER_6:
+	case ARIZONA_DSP3_WDMA_BUFFER_7:
+	case ARIZONA_DSP3_WDMA_BUFFER_8:
+	case ARIZONA_DSP3_RDMA_BUFFER_1:
+	case ARIZONA_DSP3_RDMA_BUFFER_2:
+	case ARIZONA_DSP3_RDMA_BUFFER_3:
+	case ARIZONA_DSP3_RDMA_BUFFER_4:
+	case ARIZONA_DSP3_RDMA_BUFFER_5:
+	case ARIZONA_DSP3_RDMA_BUFFER_6:
+	case ARIZONA_DSP3_WDMA_CONFIG_1:
+	case ARIZONA_DSP3_WDMA_CONFIG_2:
+	case ARIZONA_DSP3_WDMA_OFFSET_1:
+	case ARIZONA_DSP3_RDMA_CONFIG_1:
+	case ARIZONA_DSP3_RDMA_OFFSET_1:
+	case ARIZONA_DSP3_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP3_SCRATCH_0:
 	case ARIZONA_DSP3_SCRATCH_1:
 	case ARIZONA_DSP3_SCRATCH_2:
@@ -2492,6 +2639,27 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
+	case ARIZONA_DSP4_STATUS_4:
+	case ARIZONA_DSP4_WDMA_BUFFER_1:
+	case ARIZONA_DSP4_WDMA_BUFFER_2:
+	case ARIZONA_DSP4_WDMA_BUFFER_3:
+	case ARIZONA_DSP4_WDMA_BUFFER_4:
+	case ARIZONA_DSP4_WDMA_BUFFER_5:
+	case ARIZONA_DSP4_WDMA_BUFFER_6:
+	case ARIZONA_DSP4_WDMA_BUFFER_7:
+	case ARIZONA_DSP4_WDMA_BUFFER_8:
+	case ARIZONA_DSP4_RDMA_BUFFER_1:
+	case ARIZONA_DSP4_RDMA_BUFFER_2:
+	case ARIZONA_DSP4_RDMA_BUFFER_3:
+	case ARIZONA_DSP4_RDMA_BUFFER_4:
+	case ARIZONA_DSP4_RDMA_BUFFER_5:
+	case ARIZONA_DSP4_RDMA_BUFFER_6:
+	case ARIZONA_DSP4_WDMA_CONFIG_1:
+	case ARIZONA_DSP4_WDMA_CONFIG_2:
+	case ARIZONA_DSP4_WDMA_OFFSET_1:
+	case ARIZONA_DSP4_RDMA_CONFIG_1:
+	case ARIZONA_DSP4_RDMA_OFFSET_1:
+	case ARIZONA_DSP4_EXTERNAL_START_SELECT_1:
 	case ARIZONA_DSP4_SCRATCH_0:
 	case ARIZONA_DSP4_SCRATCH_1:
 	case ARIZONA_DSP4_SCRATCH_2:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index ea45877..b3c22a8 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -999,6 +999,7 @@
 #define ARIZONA_DSP1_STATUS_1                    0x1104
 #define ARIZONA_DSP1_STATUS_2                    0x1105
 #define ARIZONA_DSP1_STATUS_3                    0x1106
+#define ARIZONA_DSP1_STATUS_4                    0x1107
 #define ARIZONA_DSP1_WDMA_BUFFER_1               0x1110
 #define ARIZONA_DSP1_WDMA_BUFFER_2               0x1111
 #define ARIZONA_DSP1_WDMA_BUFFER_3               0x1112
@@ -1015,7 +1016,10 @@
 #define ARIZONA_DSP1_RDMA_BUFFER_6               0x1125
 #define ARIZONA_DSP1_WDMA_CONFIG_1               0x1130
 #define ARIZONA_DSP1_WDMA_CONFIG_2               0x1131
+#define ARIZONA_DSP1_WDMA_OFFSET_1               0x1132
 #define ARIZONA_DSP1_RDMA_CONFIG_1               0x1134
+#define ARIZONA_DSP1_RDMA_OFFSET_1               0x1135
+#define ARIZONA_DSP1_EXTERNAL_START_SELECT_1     0x1138
 #define ARIZONA_DSP1_SCRATCH_0                   0x1140
 #define ARIZONA_DSP1_SCRATCH_1                   0x1141
 #define ARIZONA_DSP1_SCRATCH_2                   0x1142
@@ -1025,6 +1029,27 @@
 #define ARIZONA_DSP2_STATUS_1                    0x1204
 #define ARIZONA_DSP2_STATUS_2                    0x1205
 #define ARIZONA_DSP2_STATUS_3                    0x1206
+#define ARIZONA_DSP2_STATUS_4                    0x1207
+#define ARIZONA_DSP2_WDMA_BUFFER_1               0x1210
+#define ARIZONA_DSP2_WDMA_BUFFER_2               0x1211
+#define ARIZONA_DSP2_WDMA_BUFFER_3               0x1212
+#define ARIZONA_DSP2_WDMA_BUFFER_4               0x1213
+#define ARIZONA_DSP2_WDMA_BUFFER_5               0x1214
+#define ARIZONA_DSP2_WDMA_BUFFER_6               0x1215
+#define ARIZONA_DSP2_WDMA_BUFFER_7               0x1216
+#define ARIZONA_DSP2_WDMA_BUFFER_8               0x1217
+#define ARIZONA_DSP2_RDMA_BUFFER_1               0x1220
+#define ARIZONA_DSP2_RDMA_BUFFER_2               0x1221
+#define ARIZONA_DSP2_RDMA_BUFFER_3               0x1222
+#define ARIZONA_DSP2_RDMA_BUFFER_4               0x1223
+#define ARIZONA_DSP2_RDMA_BUFFER_5               0x1224
+#define ARIZONA_DSP2_RDMA_BUFFER_6               0x1225
+#define ARIZONA_DSP2_WDMA_CONFIG_1               0x1230
+#define ARIZONA_DSP2_WDMA_CONFIG_2               0x1231
+#define ARIZONA_DSP2_WDMA_OFFSET_1               0x1232
+#define ARIZONA_DSP2_RDMA_CONFIG_1               0x1234
+#define ARIZONA_DSP2_RDMA_OFFSET_1               0x1235
+#define ARIZONA_DSP2_EXTERNAL_START_SELECT_1     0x1238
 #define ARIZONA_DSP2_SCRATCH_0                   0x1240
 #define ARIZONA_DSP2_SCRATCH_1                   0x1241
 #define ARIZONA_DSP2_SCRATCH_2                   0x1242
@@ -1034,6 +1059,27 @@
 #define ARIZONA_DSP3_STATUS_1                    0x1304
 #define ARIZONA_DSP3_STATUS_2                    0x1305
 #define ARIZONA_DSP3_STATUS_3                    0x1306
+#define ARIZONA_DSP3_STATUS_4                    0x1307
+#define ARIZONA_DSP3_WDMA_BUFFER_1               0x1310
+#define ARIZONA_DSP3_WDMA_BUFFER_2               0x1311
+#define ARIZONA_DSP3_WDMA_BUFFER_3               0x1312
+#define ARIZONA_DSP3_WDMA_BUFFER_4               0x1313
+#define ARIZONA_DSP3_WDMA_BUFFER_5               0x1314
+#define ARIZONA_DSP3_WDMA_BUFFER_6               0x1315
+#define ARIZONA_DSP3_WDMA_BUFFER_7               0x1316
+#define ARIZONA_DSP3_WDMA_BUFFER_8               0x1317
+#define ARIZONA_DSP3_RDMA_BUFFER_1               0x1320
+#define ARIZONA_DSP3_RDMA_BUFFER_2               0x1321
+#define ARIZONA_DSP3_RDMA_BUFFER_3               0x1322
+#define ARIZONA_DSP3_RDMA_BUFFER_4               0x1323
+#define ARIZONA_DSP3_RDMA_BUFFER_5               0x1324
+#define ARIZONA_DSP3_RDMA_BUFFER_6               0x1325
+#define ARIZONA_DSP3_WDMA_CONFIG_1               0x1330
+#define ARIZONA_DSP3_WDMA_CONFIG_2               0x1331
+#define ARIZONA_DSP3_WDMA_OFFSET_1               0x1332
+#define ARIZONA_DSP3_RDMA_CONFIG_1               0x1334
+#define ARIZONA_DSP3_RDMA_OFFSET_1               0x1335
+#define ARIZONA_DSP3_EXTERNAL_START_SELECT_1     0x1338
 #define ARIZONA_DSP3_SCRATCH_0                   0x1340
 #define ARIZONA_DSP3_SCRATCH_1                   0x1341
 #define ARIZONA_DSP3_SCRATCH_2                   0x1342
@@ -1043,6 +1089,27 @@
 #define ARIZONA_DSP4_STATUS_1                    0x1404
 #define ARIZONA_DSP4_STATUS_2                    0x1405
 #define ARIZONA_DSP4_STATUS_3                    0x1406
+#define ARIZONA_DSP4_STATUS_4                    0x1407
+#define ARIZONA_DSP4_WDMA_BUFFER_1               0x1410
+#define ARIZONA_DSP4_WDMA_BUFFER_2               0x1411
+#define ARIZONA_DSP4_WDMA_BUFFER_3               0x1412
+#define ARIZONA_DSP4_WDMA_BUFFER_4               0x1413
+#define ARIZONA_DSP4_WDMA_BUFFER_5               0x1414
+#define ARIZONA_DSP4_WDMA_BUFFER_6               0x1415
+#define ARIZONA_DSP4_WDMA_BUFFER_7               0x1416
+#define ARIZONA_DSP4_WDMA_BUFFER_8               0x1417
+#define ARIZONA_DSP4_RDMA_BUFFER_1               0x1420
+#define ARIZONA_DSP4_RDMA_BUFFER_2               0x1421
+#define ARIZONA_DSP4_RDMA_BUFFER_3               0x1422
+#define ARIZONA_DSP4_RDMA_BUFFER_4               0x1423
+#define ARIZONA_DSP4_RDMA_BUFFER_5               0x1424
+#define ARIZONA_DSP4_RDMA_BUFFER_6               0x1425
+#define ARIZONA_DSP4_WDMA_CONFIG_1               0x1430
+#define ARIZONA_DSP4_WDMA_CONFIG_2               0x1431
+#define ARIZONA_DSP4_WDMA_OFFSET_1               0x1432
+#define ARIZONA_DSP4_RDMA_CONFIG_1               0x1434
+#define ARIZONA_DSP4_RDMA_OFFSET_1               0x1435
+#define ARIZONA_DSP4_EXTERNAL_START_SELECT_1     0x1438
 #define ARIZONA_DSP4_SCRATCH_0                   0x1440
 #define ARIZONA_DSP4_SCRATCH_1                   0x1441
 #define ARIZONA_DSP4_SCRATCH_2                   0x1442
-- 
1.7.2.5

