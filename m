Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3IQOdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:33:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52136 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab3IQOdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:33:52 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2] mfd: arizona: Update registers for WM5110 DSP
Date: Tue, 17 Sep 2013 15:23:04 +0100
Message-Id: <1379427784-7193-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSPx_CONTROL_1 and DSPx_CLOCKING_1 are not volatile registers and are
incorrectly marked as such, fix this. Also add the DSP scratch
registers, which are frequently used to output debug info from the DSP
core.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Version 2 of the patch, improved commit message and turns
out the scratch registers were missing from the readable
callback as well.

Based on Lee Jones's for-mfd-next branch.

Thanks,
Charles

 drivers/mfd/wm5110-tables.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 2a79723..37463f3 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -2274,21 +2274,37 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_SCRATCH_0:
+	case ARIZONA_DSP1_SCRATCH_1:
+	case ARIZONA_DSP1_SCRATCH_2:
+	case ARIZONA_DSP1_SCRATCH_3:
 	case ARIZONA_DSP2_CONTROL_1:
 	case ARIZONA_DSP2_CLOCKING_1:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
+	case ARIZONA_DSP2_SCRATCH_0:
+	case ARIZONA_DSP2_SCRATCH_1:
+	case ARIZONA_DSP2_SCRATCH_2:
+	case ARIZONA_DSP2_SCRATCH_3:
 	case ARIZONA_DSP3_CONTROL_1:
 	case ARIZONA_DSP3_CLOCKING_1:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
+	case ARIZONA_DSP3_SCRATCH_0:
+	case ARIZONA_DSP3_SCRATCH_1:
+	case ARIZONA_DSP3_SCRATCH_2:
+	case ARIZONA_DSP3_SCRATCH_3:
 	case ARIZONA_DSP4_CONTROL_1:
 	case ARIZONA_DSP4_CLOCKING_1:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
+	case ARIZONA_DSP4_SCRATCH_0:
+	case ARIZONA_DSP4_SCRATCH_1:
+	case ARIZONA_DSP4_SCRATCH_2:
+	case ARIZONA_DSP4_SCRATCH_3:
 		return true;
 	default:
 		return false;
@@ -2334,20 +2350,34 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AOD_IRQ2:
 	case ARIZONA_ASRC_STATUS:
 	case ARIZONA_DSP_STATUS:
-	case ARIZONA_DSP1_CONTROL_1:
-	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_SCRATCH_0:
+	case ARIZONA_DSP1_SCRATCH_1:
+	case ARIZONA_DSP1_SCRATCH_2:
+	case ARIZONA_DSP1_SCRATCH_3:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
+	case ARIZONA_DSP2_SCRATCH_0:
+	case ARIZONA_DSP2_SCRATCH_1:
+	case ARIZONA_DSP2_SCRATCH_2:
+	case ARIZONA_DSP2_SCRATCH_3:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
+	case ARIZONA_DSP3_SCRATCH_0:
+	case ARIZONA_DSP3_SCRATCH_1:
+	case ARIZONA_DSP3_SCRATCH_2:
+	case ARIZONA_DSP3_SCRATCH_3:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
+	case ARIZONA_DSP4_SCRATCH_0:
+	case ARIZONA_DSP4_SCRATCH_1:
+	case ARIZONA_DSP4_SCRATCH_2:
+	case ARIZONA_DSP4_SCRATCH_3:
 		return true;
 	default:
 		return false;
-- 
1.7.2.5

