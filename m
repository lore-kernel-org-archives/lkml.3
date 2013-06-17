Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3FQGs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:48:26 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53828 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3FQGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:48:21 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V6 17/30] thermal: exynos: Remove non DT based support
Date: Mon, 17 Jun 2013 12:16:26 +0530
Message-Id: <1371451599-31035-18-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently non DT support from Exynos platform is removed and hence
removing non DT support from the driver also. This will help in easy
maintainence.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index acbd295..4356118 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -403,19 +403,6 @@ static const struct of_device_id exynos_tmu_match[] = {
 MODULE_DEVICE_TABLE(of, exynos_tmu_match);
 #endif
 
-static struct platform_device_id exynos_tmu_driver_ids[] = {
-	{
-		.name		= "exynos4210-tmu",
-		.driver_data    = (kernel_ulong_t)EXYNOS4210_TMU_DRV_DATA,
-	},
-	{
-		.name		= "exynos5250-tmu",
-		.driver_data    = (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(platform, exynos_tmu_driver_ids);
-
 static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 			struct platform_device *pdev)
 {
@@ -428,8 +415,7 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 		return (struct exynos_tmu_platform_data *) match->data;
 	}
 #endif
-	return (struct exynos_tmu_platform_data *)
-			platform_get_device_id(pdev)->driver_data;
+	return NULL;
 }
 
 static int exynos_tmu_probe(struct platform_device *pdev)
@@ -586,7 +572,6 @@ static struct platform_driver exynos_tmu_driver = {
 	},
 	.probe = exynos_tmu_probe,
 	.remove	= exynos_tmu_remove,
-	.id_table = exynos_tmu_driver_ids,
 };
 
 module_platform_driver(exynos_tmu_driver);
-- 
1.7.1

