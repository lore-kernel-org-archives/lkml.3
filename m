Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3EWAKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:10:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47723 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3EWAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:10:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 22 May 2013 19:10:38 -0500
Message-Id: <1369267838-12280-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm5110: Make DSPn_STATUS_3 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These registers have been documented since the driver was originally
submitted so expose them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I'll add this to the pull request I sent yesterday.

 drivers/mfd/wm5110-tables.c           |    8 ++++++++
 include/linux/mfd/arizona/registers.h |    3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index c415998..2a79723 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -2273,18 +2273,22 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
+	case ARIZONA_DSP1_STATUS_3:
 	case ARIZONA_DSP2_CONTROL_1:
 	case ARIZONA_DSP2_CLOCKING_1:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
+	case ARIZONA_DSP2_STATUS_3:
 	case ARIZONA_DSP3_CONTROL_1:
 	case ARIZONA_DSP3_CLOCKING_1:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
+	case ARIZONA_DSP3_STATUS_3:
 	case ARIZONA_DSP4_CONTROL_1:
 	case ARIZONA_DSP4_CLOCKING_1:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
+	case ARIZONA_DSP4_STATUS_3:
 		return true;
 	default:
 		return false;
@@ -2334,12 +2338,16 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
+	case ARIZONA_DSP1_STATUS_3:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
+	case ARIZONA_DSP2_STATUS_3:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
+	case ARIZONA_DSP3_STATUS_3:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
+	case ARIZONA_DSP4_STATUS_3:
 		return true;
 	default:
 		return false;
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 715b6ba..4730b5c 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -1002,6 +1002,7 @@
 #define ARIZONA_DSP2_CLOCKING_1                  0x1201
 #define ARIZONA_DSP2_STATUS_1                    0x1204
 #define ARIZONA_DSP2_STATUS_2                    0x1205
+#define ARIZONA_DSP2_STATUS_3                    0x1206
 #define ARIZONA_DSP2_SCRATCH_0                   0x1240
 #define ARIZONA_DSP2_SCRATCH_1                   0x1241
 #define ARIZONA_DSP2_SCRATCH_2                   0x1242
@@ -1010,6 +1011,7 @@
 #define ARIZONA_DSP3_CLOCKING_1                  0x1301
 #define ARIZONA_DSP3_STATUS_1                    0x1304
 #define ARIZONA_DSP3_STATUS_2                    0x1305
+#define ARIZONA_DSP3_STATUS_3                    0x1306
 #define ARIZONA_DSP3_SCRATCH_0                   0x1340
 #define ARIZONA_DSP3_SCRATCH_1                   0x1341
 #define ARIZONA_DSP3_SCRATCH_2                   0x1342
@@ -1018,6 +1020,7 @@
 #define ARIZONA_DSP4_CLOCKING_1                  0x1401
 #define ARIZONA_DSP4_STATUS_1                    0x1404
 #define ARIZONA_DSP4_STATUS_2                    0x1405
+#define ARIZONA_DSP4_STATUS_3                    0x1406
 #define ARIZONA_DSP4_SCRATCH_0                   0x1440
 #define ARIZONA_DSP4_SCRATCH_1                   0x1441
 #define ARIZONA_DSP4_SCRATCH_2                   0x1442
-- 
1.7.10.4

