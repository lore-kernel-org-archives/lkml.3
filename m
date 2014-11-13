Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaKMPEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:04 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-85-5464c8632f4b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 13/33] thermal: exynos: replace threshold_falling check by
 Exynos SoC type one
Date: Thu, 13 Nov 2014 16:01:08 +0100
Message-id: <1415890888-8881-14-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3kEykhBr+3cVs0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBl3JjQwFawgLviy+52tgbG/ZxdjBwcEgImErP/V3UxcgKZ
	YhIX7q1n62Lk4hASmM4o8WvffxYIp4tJ4uWS7ywgVWwCVhIT21cxgtgiAloSJy5tZwIpYhZY
	xiRx6dt8JpCEsECyxKtpL8FsFgFViWlX/zKD2LwCHhIzDv5khlinKNH9bAIbiM0JFH819S/Y
	UCEBd4lrj94xT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLyeSe9gXNVgcYhR
	gINRiYf3BUtKiBBrYllxZe4hRgkOZiURXu/DQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1ut
	A4UE0hNLUrNTUwtSi2CyTBycUg2MycZL4nw503OrU+sVXteHz/jxd5ul02OPoihP7ZXT72XL
	MzQFrHcvl5nUsWGV59WP8f57Lyy4UJq/S0Ex6PL053cPZ4dXb9jjd3TOr9j61TteszjvXtc+
	Z2ejp2ZEz/1jvy+7lq53lHnN8Wtu2mVm53uvRF51PtmyO/HWpj6Ne4Ibg98HKK3VV2Ipzkg0
	1GIuKk4EAFjeLUUrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pdata->threshold_falling check for non-zero value in
exynos_tmu_initialize() by an explicit check for a SoC type
(all SoC types except Exynos5440 have pdata->threshold_falling
assigned to non-zero value in their struct exynos_tmu_registers
instances).

This is a preparation for introducing per-SoC type tmu_initialize
method.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 1c15b37..4f7cad9 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -231,7 +231,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 						pdata->trigger_levels[i]);
 			rising_threshold &= ~(0xff << 8 * i);
 			rising_threshold |= threshold_code << 8 * i;
-			if (pdata->threshold_falling) {
+			if (data->soc != SOC_ARCH_EXYNOS5440) {
 				threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i] -
 						pdata->threshold_falling);
-- 
1.8.2.3

