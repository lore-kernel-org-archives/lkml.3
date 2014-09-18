Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaIRPas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:30:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29487 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaIRPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:42 -0400
X-AuditID: cbfee61a-f79e46d00000134f-de-541afaa02197
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 32/33] thermal: exynos: remove __EXYNOS5420_TMU_DATA macro
Date: Thu, 18 Sep 2014 17:27:49 +0200
Message-id: <1411054070-25757-33-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd0Fv6RCDNq+qVo0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj4b9NrAW7hCruTHjB2MC4jr+LkZNDQsBEYnPb
	RUYIW0ziwr31bF2MXBxCAosYJa482MgE4XQxSRzqeckEUsUmYCUxsX0VWIeIgJbEiUvbwYqY
	BW4xSby+MRksISzgJbHnz29mEJtFQFXi2eVzYHFeAU+JWwv3MkOsU5TofjaBDcTmBIo33NrE
	DmILCXhItG25yzyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBQeya1g3Flg8Uh
	RgEORiUe3gO8UiFCrIllxZW5hxglOJiVRHj/fAQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Q
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYOQXMrp4P6mA2ffh8rv/ebrP3t6VxD2/M+hGMPOevd0e
	QjW793/aNoNrSojqQev0+UENjTu2v5pjzr285mVd3JfZmdr3eeZO1Z34TMvHb1vRhON6fqE3
	5uqe2XbuwSu3XyaBRSvPLq3JtRWb88h/Yu4MMXm/lKAt3A+rOPbkLDkouIdvVVJY8kwlluKM
	REMt5qLiRAACEEjwMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__EXYNOS5420_TMU_DATA macro is now identical to __EXYNOS5260_TMU_DATA
one and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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

