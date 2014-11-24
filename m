Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaKXNNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:13:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35705 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaKXNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:13:29 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ff-54732ef7e69c
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 03/12] soc: samsung: exynos-pmu: Register exynos pd
 driver as a mfd client
Date: Mon, 24 Nov 2014 18:34:07 +0530
Message-id: <1416834256-11225-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSq/tdrzjE4MpsUYuGqyEW84+cY7V4
	dmsvk0XvgqtsFk83P2ay2PT4GqvF5V1z2Cw+9x5htJhxfh+TxaKtX9gtzpy+xGpx+E07q8Xx
	teEOvB6bVnWyedy5tofN49DhDkaPzUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsE
	roxPp56wFPQIVFyf2cPYwDiDt4uRk0NCwETi9bfbrBC2mMSFe+vZuhi5OIQEljJKPFmwgQmm
	6Hr/cWaIxHRGiZOPNzFBOBOYJG52bGABqWITMJb4uXM/excjB4eIgLfE8muKIDXMAquZJLa2
	fwCbJCyQLLFuzmawehYBVYm9k/rYQGxeAXeJc2dXMYP0SggoSMyZZAMS5hTwkHhxsAVqcQuj
	xKXHc1lBHAmBa+wSEyYcZoYYJCDxbfIhFohmWYlNB5ghrpaUOLjiBssERuEFjAyrGEVTC5IL
	ipPSi4z0ihNzi0vz0vWS83M3MQJj5vS/Z307GG8esD7EKMDBqMTD+2FjUYgQa2JZcWXuIUZT
	oA0TmaVEk/OBkZlXEm9obGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAPj0rVvvnp9u1PBudgocUu0s88v58/vW7XWNbrMfNHe8ON6e2C20g8+9r8Gpy9Pm2Nm
	7hT1/m20UFmWtAFTR17Ev86m8xuanNln2pmemCvvqukqGfY27eS78zvMZNnC/xV/3cUs/j9R
	dcGNO7vLc/9kH6g5VMOc2d33pkXhpI/bWu1NUQabG2OUWIozEg21mIuKEwHn0N6UlAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd3vesUhBv+m81g0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+HTqCUtBj0DF9Zk9jA2MM3i7GDk5JARMJK73H2eG
	sMUkLtxbz9bFyMUhJDCdUeLk401MEM4EJombHRtYQKrYBIwlfu7cz97FyMEhIuAtsfyaIkgN
	s8BqJomt7R+YQGqEBZIl1s3ZDFbPIqAqsXdSHxuIzSvgLnHu7CpmkF4JAQWJOZNsQMKcAh4S
	Lw62MEPsamGUuPR4LusERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj8pn0DsZV
	DRaHGAU4GJV4eGesLwoRYk0sK67MPcQowcGsJMIrJlYcIsSbklhZlVqUH19UmpNafIjRFOiq
	icxSosn5wGSRVxJvaGxibmpsamliYWJmqSTOe+NmboiQQHpiSWp2ampBahFMHxMHp1QDo5ip
	lP1VAa7gtUvXejOUsXSv2OpybZ3SLrmZeyx8jj2wmFD39UMsi38pj3p4U+PS+YzvHtnsje5a
	/u1Ql/jaJaXutRcWSPB9nGoklivzJ//D/lv/3Q4JWerdDD+/Ti7EQe6kePetVn/jXab7VTq5
	50jwtWiHa3M2TlpsFxz6b3FQ2Rcv4WPCSizFGYmGWsxFxYkATaaT494CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used to probe exynos power domain. This method can be also used
for probing other PMU client drivers like pm sleep etc. Currently no
platform data is supplied but can be easily extended when required.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index cb9e356..da77c7e 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/mfd/core.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
@@ -21,6 +22,10 @@
 
 #define PMU_TABLE_END	(-1U)
 
+enum pmu_mfd_list {
+	MFD_PD,
+	MFD_MAX,
+};
 struct exynos_pmu_conf {
 	unsigned int offset;
 	unsigned int val[NUM_SYS_POWERDOWN];
@@ -38,6 +43,7 @@ struct exynos_pmu_data {
 struct exynos_pmu_context {
 	struct device *dev;
 	const struct exynos_pmu_data *pmu_data;
+	struct mfd_cell cells[MFD_MAX];
 };
 
 static void __iomem *pmu_base_addr;
@@ -1220,6 +1226,7 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	struct mfd_cell *cell;
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1249,6 +1256,17 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 	if (ret)
 		dev_warn(dev, "can't register restart handler err=%d\n", ret);
 
+	/* Initialize and invoke mfd clients */
+	cell = &pmu_context->cells[MFD_PD];
+	cell->name = "exynos-pmu-pd";
+
+	ret = mfd_add_devices(&pdev->dev, pdev->id, pmu_context->cells, MFD_MAX,
+				NULL, 0, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "fail to register client devices\n");
+		return ret;
+	}
+
 	dev_dbg(dev, "Exynos PMU Driver probe done\n");
 	return 0;
 }
-- 
1.7.9.5

