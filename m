Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161059AbaGROLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:11:54 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52571 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030681AbaGROLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:11:52 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: orjan.eide@arm.com, Punit Agrawal <punit.agrawal@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 2/2] PM / devfreq: exynos: Enable building exynos PPMU as module
Date: Fri, 18 Jul 2014 15:09:54 +0100
Message-Id: <1405692594-19352-3-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
References: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export symbols from the PPMU driver needed to build the exynos bus
driver as a module.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 drivers/devfreq/Kconfig              |    2 +-
 drivers/devfreq/exynos/exynos_ppmu.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 49e74c1..77bf126 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -79,7 +79,7 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	  This does not yet operate with optimal voltages.
 
 config ARM_EXYNOS5_BUS_DEVFREQ
-	bool "ARM Exynos5250 Bus DEVFREQ Driver"
+	tristate "ARM Exynos5250 Bus DEVFREQ Driver"
 	depends on SOC_EXYNOS5250
 	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
diff --git a/drivers/devfreq/exynos/exynos_ppmu.c b/drivers/devfreq/exynos/exynos_ppmu.c
index 75fcc51..97b75e5 100644
--- a/drivers/devfreq/exynos/exynos_ppmu.c
+++ b/drivers/devfreq/exynos/exynos_ppmu.c
@@ -73,6 +73,7 @@ void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
 		exynos_ppmu_start(ppmu_base);
 	}
 }
+EXPORT_SYMBOL(busfreq_mon_reset);
 
 void exynos_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
 {
@@ -97,6 +98,7 @@ void exynos_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
 
 	busfreq_mon_reset(ppmu_data);
 }
+EXPORT_SYMBOL(exynos_read_ppmu);
 
 int exynos_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data)
 {
@@ -114,3 +116,4 @@ int exynos_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data)
 
 	return busy;
 }
+EXPORT_SYMBOL(exynos_get_busier_ppmu);
-- 
1.7.10.4

