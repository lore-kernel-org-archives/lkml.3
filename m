Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3JGB4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:56:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59760 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3JGB4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:56:38 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-de-525214d5031d
Date: Mon, 07 Oct 2013 10:56:36 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 09/20] iommu/exynos: use managed device helper functions
Message-id: <20131007105636.d3eabb5be87899116cca4a99@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY92rIkFBBlNXiFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+NG7xaWggfiFctfHWZtYJwm3MXIwSEhYCIx
	9a1mFyMnkCkmceHeerYuRi4OIYFljBIznz1jg0iYSPzqfcUKkVjEKHHjfTc7hDOJSaLv7jp2
	kCoWAVWJ3q8zwDrYBLQkVs89zghSJCLQxiTxtfEQC4jDLHCaWWLV7hXMIFXCAj4SB7ougdm8
	Ao4SHxu2MEPss5C40NTBDhEXlPgx+R4LiM0MNHXztiZWCFteYvOat8wgQyUEJnJIXHxzkQ3i
	DAGJb5NBtoE8Jyux6QDUTEmJgytusExgFJmFZOwsJGNnIRm7gJF5FaNoakFyQXFSepGhXnFi
	bnFpXrpecn7uJkZIJPfuYLx9wPoQYzLQyonMUqLJ+cBEkFcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRp3ZL+Yu82FbVB0T9YBp+ZQta64sedWy
	Ov/p7J2/HypI6py5vPTczsawHb3NZ/zec9S8eKUWVFrG+3/xsUYVt79ubRU/pttMEdknKv/f
	/Lj3crNKHaUFFoyJlatunw6/uENWf2mI26Mfrxeseuz/sF6I47Xl2aW3JZmOJ5dGRGo995zg
	dmbW0VglluKMREMt5qLiRADWayqA+gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd2rIkFBBh0HBSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjRu8W
	loIH4hXLXx1mbWCcJtzFyMkhIWAi8av3FSuELSZx4d56ti5GLg4hgUWMEjfed7NDOJOYJPru
	rmMHqWIRUJXo/TqDDcRmE9CSWD33OCNIkYhAG5PE18ZDLCAOs8BpZolVu1cwg1QJC/hIHOi6
	BGbzCjhKfGzYwgyxz0LiQlMHO0RcUOLH5HssIDYz0NTN25pYIWx5ic1r3jJPYOSbhaRsFpKy
	WUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIThTPpHcwrmqwOMQowMGoxMO7435g
	kBBrYllxZe4hRgkOZiUR3kt1QCHelMTKqtSi/Pii0pzU4kOMyUB/T2SWEk3OByaxvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnBLzT9Fz1mMe3Q3NWrMe
	vU71ePtkztHp4k/fBhssjdbesuL6Ttbe3JuCqRekBPwNRAQ9TfXfpi57fPVd1tHiyttP5Q9V
	PdO6WpS2+M27NXpvWJ8eLzXkLd63J+SSQnfR0+LAK2aGrz5WtTz9f121olPmvsBMKRYDm5dV
	kkIusQsT9/ZuCa/iUWIpzkg01GIuKk4EANcSwe9YAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses managed device helper functions in the probe().

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   64 ++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 735d75e..6fdb3836 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -510,53 +510,48 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
 {
-	int ret;
+	int irq, ret;
 	struct device *dev = &pdev->dev;
 	struct sysmmu_drvdata *data;
 	struct resource *res;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_alloc;
-	}
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		dev_dbg(dev, "Unable to find IOMEM region\n");
-		ret = -ENOENT;
-		goto err_res;
+		dev_err(dev, "Unable to find IOMEM region\n");
+		return -ENOENT;
 	}
 
-	data->sfrbase = ioremap(res->start, resource_size(res));
-	if (!data->sfrbase) {
-		dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n", res->start);
-		ret = -ENOENT;
-		goto err_res;
-	}
+	data->sfrbase = devm_ioremap_resource(dev, res);
+	if (IS_ERR(data->sfrbase))
+		return PTR_ERR(data->sfrbase);
 
-	ret = platform_get_irq(pdev, 0);
-	if (ret <= 0) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
 		dev_dbg(dev, "Unable to find IRQ resource\n");
-		goto err_irq;
+		return irq;
 	}
 
-	ret = request_irq(ret, exynos_sysmmu_irq, 0,
+	ret = devm_request_irq(dev, irq, exynos_sysmmu_irq, 0,
 				dev_name(dev), data);
 	if (ret) {
-		dev_dbg(dev, "Unabled to register interrupt handler\n");
-		goto err_irq;
+		dev_err(dev, "Unabled to register handler of irq %d\n", irq);
+		return ret;
 	}
 
-	if (dev_get_platdata(dev)) {
-		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
+	data->clk = devm_clk_get(dev, "sysmmu");
+	if (IS_ERR(data->clk)) {
+		dev_info(dev, "No gate clock found!\n");
+		data->clk = NULL;
+	}
 
-		data->clk = clk_get(dev, "sysmmu");
-		if (IS_ERR(data->clk)) {
-			data->clk = NULL;
-			dev_dbg(dev, "No clock descriptor registered\n");
-		}
+	ret = clk_prepare(data->clk);
+	if (ret) {
+		dev_err(dev, "Failed to prepare clk\n");
+		return ret;
 	}
 
 	data->sysmmu = dev;
@@ -569,17 +564,8 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "Initialized\n");
+	dev_dbg(dev, "Probed and initialized\n");
 	return 0;
-err_irq:
-	free_irq(platform_get_irq(pdev, 0), data);
-err_res:
-	iounmap(data->sfrbase);
-err_init:
-	kfree(data);
-err_alloc:
-	dev_err(dev, "Failed to initialize\n");
-	return ret;
 }
 
 static struct platform_driver exynos_sysmmu_driver = {
-- 
1.7.2.5

