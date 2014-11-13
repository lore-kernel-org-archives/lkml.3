Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbaKMPHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:07:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43121 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbaKMPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:07:39 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-60-5464c9390cc2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 32/33] thermal: exynos: remove __EXYNOS5420_TMU_DATA macro
Date: Thu, 13 Nov 2014 16:01:27 +0100
Message-id: <1415890888-8881-33-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQV3LkykhBtNvKlk0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlrHjwgqmgRaji4N5HzA2M//i6GDk5JARMJD7vfcMGYYtJ
	XLi3Hsjm4hASmM4osWz2SSini0ni2Oxp7CBVbAJWEhPbVzGC2CICWhInLm1nAiliFljGJHHp
	23wgh4NDWMBXYssacxCTRUBVYts3sGW8Ah4SC3vPQi1TlOh+NgHM5gSKv5r6F2ykkIC7xLVH
	75gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcXM+kdzCuarA4xCjAwajEw/uC
	JSVEiDWxrLgy9xCjBAezkgiv92GgEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp
	2ampBalFMFkmDk6pBkYD75/zzTNfebQG+2vyJhX4GgRfK9ucPrGqL/fD2crVbPp7rbf3H/2X
	xXd/56eUibXTLjS43/v4SOm92aqq71tbfzc1tU2bfXazq9BFvYcB6SbV9We0+KxOndmRy+Sv
	s8f5acKc+iMOuStXrCvOFlefe3XK0QlLE5ZeXPVweu2+Pd9rvHccXc2oxFKckWioxVxUnAgA
	UDnVhCoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__EXYNOS5420_TMU_DATA macro is now identical to __EXYNOS5260_TMU_DATA
one and can be removed.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c | 40 ++-----------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 02a1c34..592c470 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -216,48 +216,12 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_count = 5,
 };
 
-#define __EXYNOS5420_TMU_DATA	\
-	.threshold_falling = 10, \
-	.trigger_levels[0] = 85, \
-	.trigger_levels[1] = 103, \
-	.trigger_levels[2] = 110, \
-	.trigger_levels[3] = 120, \
-	.trigger_enable[0] = true, \
-	.trigger_enable[1] = true, \
-	.trigger_enable[2] = true, \
-	.trigger_enable[3] = false, \
-	.trigger_type[0] = THROTTLE_ACTIVE, \
-	.trigger_type[1] = THROTTLE_ACTIVE, \
-	.trigger_type[2] = SW_TRIP, \
-	.trigger_type[3] = HW_TRIP, \
-	.max_trigger_level = 4, \
-	.non_hw_trigger_levels = 3, \
-	.gain = 8, \
-	.reference_voltage = 16, \
-	.noise_cancel_mode = 4, \
-	.cal_type = TYPE_ONE_POINT_TRIMMING, \
-	.efuse_value = 55, \
-	.min_efuse_value = 40, \
-	.max_efuse_value = 100, \
-	.first_point_trim = 25, \
-	.second_point_trim = 85, \
-	.default_temp_offset = 50, \
-	.freq_tab[0] = { \
-		.freq_clip_max = 800 * 1000, \
-		.temp_level = 85, \
-	}, \
-	.freq_tab[1] = { \
-		.freq_clip_max = 200 * 1000, \
-		.temp_level = 103, \
-	}, \
-	.freq_tab_count = 2, \
-
 #define EXYNOS5420_TMU_DATA \
-	__EXYNOS5420_TMU_DATA \
+	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420
 
 #define EXYNOS5420_TMU_DATA_SHARED \
-	__EXYNOS5420_TMU_DATA \
+	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
-- 
1.8.2.3

