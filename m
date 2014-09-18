Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaIRP32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:29:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14598 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaIRP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:14 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c4-541afa4811fe
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 13/33] thermal: exynos: replace threshold_falling check by
 Exynos SoC type one
Date: Thu, 18 Sep 2014 17:27:30 +0200
Message-id: <1411054070-25757-14-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAV3PX1IhBve62CwaroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXR+e0yc8E17orHz3exNDC+5+xi5OSQEDCROHNo
	CTOELSZx4d56NhBbSGARo8T2m+ldjFxAdheTxOreRywgCTYBK4mJ7asYQWwRAS2JE5e2M4EU
	MQvcYpJ4fWMyUIKDQ1ggQeL3EQuQGhYBVYnHKz8ygdi8Ap4S/zrOskEsU5TofjYBzOYEijfc
	2sQOsdhDom3LXeYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH2TPpHYyrGiwO
	MQpwMCrx8B7glQoRYk0sK67MPcQowcGsJML75yNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/B
	VutAIYH0xJLU7NTUgtQimCwTB6dUA6NT2LeLHa5yutvKDxnOsbacwBxoKqNx5s/1f2G8fMe0
	exb087w3e7Fh72P7pHVlNxTc39zZyxPftpTFV3ny6cqIpOMFMx7fbw1WFN+z1Gfnb59t0u+c
	LUx+zi0pnuq//MCc/5J7D1txqQjeu13tmDLnipu6UIXipjKt9P3smXEhb14XCWjJHFNiKc5I
	NNRiLipOBADpkZLBLwIAAA==
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

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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
index f02e65d..641a77a 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -214,7 +214,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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

