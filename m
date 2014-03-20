Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbaCTQ6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:58:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55548 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757901AbaCTQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:58:03 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: arizona: Mark DSP clocking register as volatile
Date: Thu, 20 Mar 2014 16:49:24 +0000
Message-Id: <1395334164-3012-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395334164-3012-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395334164-3012-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DSPs will often control there own clock speeds whilst running as
such we should mark the registers controlling this as volatile.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    1 +
 drivers/mfd/wm5110-tables.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 187ee86..a856ac7 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1925,6 +1925,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AOD_IRQ1:
 	case ARIZONA_AOD_IRQ2:
 	case ARIZONA_AOD_IRQ_RAW_STATUS:
+	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 178e041..1942b6f 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -2652,6 +2652,7 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
 	case ARIZONA_DSP1_SCRATCH_3:
+	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
@@ -2680,6 +2681,7 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP2_SCRATCH_1:
 	case ARIZONA_DSP2_SCRATCH_2:
 	case ARIZONA_DSP2_SCRATCH_3:
+	case ARIZONA_DSP2_CLOCKING_1:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
@@ -2708,6 +2710,7 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP3_SCRATCH_1:
 	case ARIZONA_DSP3_SCRATCH_2:
 	case ARIZONA_DSP3_SCRATCH_3:
+	case ARIZONA_DSP3_CLOCKING_1:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
@@ -2736,6 +2739,7 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP4_SCRATCH_1:
 	case ARIZONA_DSP4_SCRATCH_2:
 	case ARIZONA_DSP4_SCRATCH_3:
+	case ARIZONA_DSP4_CLOCKING_1:
 		return true;
 	default:
 		return wm5110_is_adsp_memory(dev, reg);
-- 
1.7.2.5

