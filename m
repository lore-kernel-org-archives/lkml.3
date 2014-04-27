Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaD0Hks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41738 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaD0HjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:16 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-2f-535cb4234e5d
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 10/31] iommu/exynos: use managed device helper functions
Date: Sun, 27 Apr 2014 13:07:42 +0530
Message-id: <1398584283-22846-11-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkWld5S0ywwcqZqhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8aib2dZ
	Co5JVUx69o2pgXGXaBcjJ4eEgInEtp4dbBC2mMSFe+uBbC4OIYGljBIf/z5khyn6+vQzC0Ri
	EaPEhiV7wRJCAhOYJOb1B4LYbAKGEtvvXWEFKRIRWM0o0XfxDDuIwyxwl0lizqp3jCBVwgI+
	EgfWXQezWQRUJS6d6mAFsXkFPCTWd0wGsjmA1ilIzJlkAxLmBAo/ubOHBWKZu8TbU1/AFkgI
	zOWQWH3xKhPEHAGJb5MPsUD0ykpsOsAMcbWkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSqV5yY
	W1yal66XnJ+7iREYj6f/PZu4g/H+AetDjMlA4yYyS4km5wPjOa8k3tDYzMjC1MTU2Mjc0ow0
	YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKUeVO5g8Vr63j3k2qMoL7GfmcHt
	eQqPmi3LfHV69kud/vQvxTV7VZ/9FnZxu7XT9Bav9BEocn37Yer66u/i658bi2v/d68t+jXJ
	9l5UdVjKa3/Gma+XnHx9aY/yzb6InzxHRd5fFZt63n/uk6LMWQkNH9x+K3XLmD9zrdnUE1d8
	8NesIJkvW5RYijMSDbWYi4oTASGNDlPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3lLTHBBnuvSFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzFn07y1JwTKpi0rNvTA2Mu0S7GDk5JARMJL4+/cwCYYtJXLi3
	nq2LkYtDSGARo8SGJXvZQRJCAhOYJOb1B4LYbAKGEtvvXWEFKRIRWM0o0XfxDDuIwyxwl0li
	zqp3jCBVwgI+EgfWXQezWQRUJS6d6mAFsXkFPCTWd0wGsjmA1ilIzJlkAxLmBAo/ubOHBWKZ
	u8TbU19YJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHO3PpHYwrmywOMQowMGo
	xMO7QDImWIg1say4MvcQowQHs5IIL+d0oBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnAxNR
	Xkm8obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwhhyY/GlW9oFq
	Pt3oQ+UWr+dsnhqcfXi+Vamivsfu0w/fyaZ/TmPJOcHe+H1Wyc64hTPYxbL/Lu/f/TH03KSV
	q5cpPbjuudlO7+ve3J8zdDsU/+xa+zRZ8UuM9K8fx7s+XRKIyz3tV7LZ76FP3aEZ0xq7Dv2w
	9bmzI//O6lZDtejmU15/yzO5vyqxFGckGmoxFxUnAgAIUe9SOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch uses managed device helper functions in the probe().

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   68 ++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 1af2d23..0f1d3f0 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -342,8 +342,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	if (!IS_ERR(data->clk))
-		clk_disable(data->clk);
+	clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -386,8 +385,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (!IS_ERR(data->clk))
-		clk_enable(data->clk);
+	clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
@@ -498,49 +496,43 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
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
-	if (!res) {
-		dev_dbg(dev, "Unable to find IOMEM region\n");
-		ret = -ENOENT;
-		goto err_init;
-	}
+	data->sfrbase = devm_ioremap_resource(dev, res);
+	if (IS_ERR(data->sfrbase))
+		return PTR_ERR(data->sfrbase);
 
-	data->sfrbase = ioremap(res->start, resource_size(res));
-	if (!data->sfrbase) {
-		dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n", res->start);
-		ret = -ENOENT;
-		goto err_res;
-	}
-
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
-		data->clk = clk_get(dev, "sysmmu");
-		if (IS_ERR(data->clk))
-			dev_dbg(dev, "No clock descriptor registered\n");
+	data->clk = devm_clk_get(dev, "sysmmu");
+	if (IS_ERR(data->clk)) {
+		dev_err(dev, "Failed to get clock!\n");
+		return PTR_ERR(data->clk);
+	} else  {
+		ret = clk_prepare(data->clk);
+		if (ret) {
+			dev_err(dev, "Failed to prepare clk\n");
+			return ret;
+		}
 	}
 
 	data->sysmmu = dev;
@@ -553,17 +545,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "Initialized\n");
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
1.7.9.5

