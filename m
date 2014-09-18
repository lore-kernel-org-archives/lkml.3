Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaIRP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaIRP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:26 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7f-541afa1878cc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 03/33] thermal: exynos: remove needless threshold_temp
 abstraction
Date: Thu, 18 Sep 2014 17:27:20 +0200
Message-id: <1411054070-25757-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAV3JX1IhBtsOslo0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSujv+8MU8EeiYq1UzcxNzD+Feli5OSQEDCRmPVl
	DwuELSZx4d56ti5GLg4hgUWMEh0/zrKCJIQEupgkJrYqgNhsAlYSE9tXMYLYIgJaEicubWcC
	aWAWuMUk8frGZKAEB4ewQIjE64lmIDUsAqoSu2c+AZvDK+AhMaW3jxFimaJE97MJbCA2p4Cn
	RMOtTewQuzwk2rbcZZ7AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCYPZPewbiq
	weIQowAHoxIP7wFeqRAh1sSy4srcQ4wSHMxKIrx/PgKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
	8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MIbkyl7XWOIh7zpV9NH6mSuUmPOeBzn+ZU5bGCh9
	lNWv3PUXY4XsG7kTD+fEqWqUu7vMCFgQZuJcI7i14tfi11xcMpm7ey7Fh3dcrj16s0riS71G
	jX1zYukDo4kciv6yt+fL3duz6EFA9QWxwPU6i2XEz95etO6T0MlI1qklVVI3WJd/4b3ppcRS
	nJFoqMVcVJwIAEKyVd8vAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->threshold_temp is used only in exynos_tmu_initialize() and
is accessed only on Exynos4210 (other SoC types don't even have
threshold_temp entry assigned in their struct exynos_tmu_registers
instances) so the register abstraction is not needed and can be
removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 2 +-
 drivers/thermal/samsung/exynos_tmu.h      | 3 ---
 drivers/thermal/samsung/exynos_tmu_data.c | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 8bc475c..8a45b4b 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -202,7 +202,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
 		writeb(threshold_code,
-			data->base + reg->threshold_temp);
+			data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
 		for (i = 0; i < pdata->non_hw_trigger_levels; i++)
 			writeb(pdata->trigger_levels[i], data->base +
 			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 30f5f41..531c01c 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -84,7 +84,6 @@ enum soc_type {
  * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
- * @threshold_temp: register containing the base threshold level.
  * @threshold_th0: Register containing first set of rising levels.
  * @threshold_th1: Register containing second set of rising levels.
  * @threshold_th2: Register containing third set of rising levels.
@@ -120,8 +119,6 @@ struct exynos_tmu_registers {
 
 	u32	tmu_cur_temp;
 
-	u32	threshold_temp;
-
 	u32	threshold_th0;
 	u32	threshold_th1;
 	u32	threshold_th2;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 4e95bbb..89c072a 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -28,7 +28,6 @@
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
 	.threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-- 
1.8.2.3

