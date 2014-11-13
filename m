Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaKMPHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:07:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61868 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbaKMPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:07:03 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-3f-5464c916afb1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 29/33] thermal: exynos: remove TMU_SUPPORT_MULTI_INST flag
Date: Thu, 13 Nov 2014 16:01:24 +0100
Message-id: <1415890888-8881-30-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2xkykhBh8vils0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlXFm0nL3guUjF18cTWRoY1wl2MXJySAiYSGxevYMFwhaT
	uHBvPVsXIxeHkMB0RomDj+4zQThdTBLTDtxnBqliE7CSmNi+ihHEFhHQkjhxaTtYEbPAMiaJ
	S9/mAzkcHMICvhL/ZyqB1LAIqEo8f9cJtoFXwENiyc7HzBDbFCW6n01gA7E5geKvpv4Fmykk
	4C5x7dE75gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfXM+kdjKsaLA4xCnAw
	KvHwvmBJCRFiTSwrrsw9xCjBwawkwut9GCjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQ
	QHpiSWp2ampBahFMlomDU6qBcVHSQz2jhvn6U28ukxN+88YuLfYNN2/+DvVJT0Xmr72anHh5
	xiurCw0+W/J7hTjfqzIwma2/xF6665zo7CkBl6f7FjSbyh+YV8l5P8xCYDZj56dsyfZOvqMO
	84pfSv7b1+OiPPVD7F8hxXORrdc15soI7F/c8rfbSCdFdFn4lZ1pKw7ypt+TVmIpzkg01GIu
	Kk4EAMgvCmUrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused TMU_SUPPORT_MULTI_INST flag, no longer
needed TMU_SUPPORTS() macro and features field from
struct exynos_tmu_platform_data.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.h      | 13 -------------
 drivers/thermal/samsung/exynos_tmu_data.c |  3 +--
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 54f018d..2eb4cb9 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -46,16 +46,6 @@ enum soc_type {
 };
 
 /**
- * EXYNOS TMU supported features.
- * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
- *			has many instances of TMU.
- * TMU_SUPPORT - macro to compare the above features with the supplied.
- */
-#define TMU_SUPPORT_MULTI_INST			BIT(0)
-
-#define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
-
-/**
  * struct exynos_tmu_platform_data
  * @threshold: basic temperature for generating interrupt
  *	       25 <= threshold <= 125 [unit: degree Celsius]
@@ -104,8 +94,6 @@ enum soc_type {
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
- * @features: a bitfield value indicating the features supported in SOC like
- *	emulation, multi instance etc
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -133,7 +121,6 @@ struct exynos_tmu_platform_data {
 	enum soc_type type;
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
-	unsigned int features;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 13ac00b..d90b050 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -308,8 +308,7 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.first_point_trim = 25, \
 	.second_point_trim = 70, \
 	.default_temp_offset = 25, \
-	.type = SOC_ARCH_EXYNOS5440, \
-	.features = TMU_SUPPORT_MULTI_INST,
+	.type = SOC_ARCH_EXYNOS5440
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3

