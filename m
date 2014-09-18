Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbaIRPab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:30:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47572 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaIRPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:26 -0400
X-AuditID: cbfee61a-f79e46d00000134f-cf-541afa91febc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 29/33] thermal: exynos: remove TMU_SUPPORT_MULTI_INST flag
Date: Thu, 18 Sep 2014 17:27:46 +0200
Message-id: <1411054070-25757-30-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jAd2Jv6RCDFY+ErRouBpisXHGelaL
	u88PM1rMv3KN1eJs0xt2izcPNzNaXN41h83ic+8RRosZ5/cxWTx52MfmwOWxc9Zddo/Fe14y
	efRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGiQehBXNFK/YdYWtgvCfYxcjJISFgIvFxSxMz
	hC0mceHeejYQW0hgEaPEqgV5XYxcQHYXk8TbyTNZQRJsAlYSE9tXMYLYIgJaEicubWcCKWIW
	uMUk8frGZLCEsICXxI/DJ9hBbBYBVYm2/VfB4rwCnhI/pz5mg9imKNH9bAKYzQkUb7i1iR1i
	s4dE25a7zBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA6yZ1I7GFc2WBxiFOBg
	VOLhPcArFSLEmlhWXJl7iFGCg1lJhPfPR6AQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFC
	AumJJanZqakFqUUwWSYOTqkGRls7meN573609K5I0X56+smkI+9eH3b8Hn1nzyLjP7/LDawu
	TX5ouu/DQZ3qlwalh3xEr2381LbjlNvTZVxS7fqzu8rcFIwD52gd1pw0b79D2ieRWqbmkmLP
	5rUubxb9fnO2tVXjxfZrPL6nerlm2xcrPWwX3DT19imLK3Ivji/ft+7rn89hEluVWIozEg21
	mIuKEwF3pLQZLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused TMU_SUPPORT_MULTI_INST flag, no longer
needed TMU_SUPPORTS() macro and features field from
struct exynos_tmu_platform_data.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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

