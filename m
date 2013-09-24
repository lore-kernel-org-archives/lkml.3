Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3IXIJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:09:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64496 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3IXII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:08:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7f-52414896bcf2
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 4/6] thermal: exynos: Replace SOC_ARCH_EXYNOS with
 SOC_ARCH_EXYNOS5250
Date: Tue, 24 Sep 2013 10:08:20 +0200
Message-id: <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jAd1pHo5BBv8n6Fk0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BZvHm5mtLi8aw6bxefeI4wWM87vY7K43biCzaJ/YS+TxZOH
	fWwW62e8ZnHg81i85yWTx7ppb5k9+rasYvR4tLiF0eP4je1MHp83yQWwRXHZpKTmZJalFunb
	JXBlbFj/hrHgM3/Fm+sv2RsYV/N2MXJySAiYSHxt7GOEsMUkLtxbz9bFyMUhJLCIUeJe/wom
	kISQQBeTxJmLsSA2m4CexOe7T5lAikQEmhglfhz5xgySYBY4xizxZZUIiC0sECHx48RzoCIO
	DhYBVYnLb6O7GNk5eAXcJP76Q6ySl3h6v48NxOYUcJdofzqFEWKTm8TbR1tZJjDyLmBkWMUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJzPpHcwrmqwOMQowMGoxMN7IcEhSIg1say4MvcQ
	owQHs5II7w1bxyAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwc
	nFINjCr+J67VlK2tfbJmgaCkgs5jk+3flyQmRE0Q51/WZrpYesPkORnp25z2rHhs9ufa/Wvr
	FVf897vGb+Qpdjjxn+QdX/dTvjbnS+5IbXq1Qu33s8/587UKT2gY7q3L5Hh+dZb3D9aEdddr
	pr/v8L08ueHbg+DX3geKgi98q3xfPj0/+vHqMwLq83WUWIozEg21mIuKEwGnumodSgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMU data definition is now separated to Exynos4412 and Exynos5250.

Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
 drivers/thermal/samsung/exynos_tmu.h      |    2 +-
 drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 21b89e4..037cd46 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (pdata->type == SOC_ARCH_EXYNOS ||
-	    pdata->type == SOC_ARCH_EXYNOS4210 ||
+	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
+	    pdata->type == SOC_ARCH_EXYNOS5250 ||
 	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
 	else {
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index db37df0..b42ece4 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -42,7 +42,7 @@ enum calibration_mode {
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS4412,
-	SOC_ARCH_EXYNOS,
+	SOC_ARCH_EXYNOS5250,
 	SOC_ARCH_EXYNOS5440,
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index bd08093..188223f 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -183,7 +183,7 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
 struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 	.tmu_data = {
 		{ EXYNOS4412_TMU_DATA,
-		.type = SOC_ARCH_EXYNOS,
+		.type = SOC_ARCH_EXYNOS5250,
 		},
 	},
 	.tmu_count = 1,
-- 
1.7.10.4

