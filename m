Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaELGU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:20:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34126 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaELGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:47 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-c9-5370674dedc8
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 09/19] iommu/exynos: use managed device helper functions
Date: Mon, 12 May 2014 11:44:54 +0530
Message-id: <1399875304-19948-10-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkStc3vSDY4MBkA4s7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6Mk7vOsBQ0SVfs3r6JsYHxg2gXIyeHhICJxIY9h9ghbDGJC/fWs3UxcnEI
	CSxllFjecJEdpmh+01smiMQiRolf786wQDgTmCTON/4Cq2ITMJTYfu8KK0hCRGA1o0TfxTPs
	IA6zwGxmiSOPFjOCVAkL+Egc+HsErINFQFXic8NDsDivgIfEmQf7gOIcQPsUJOZMsgEJcwKF
	P6+ewgZiCwm4Sxx7dRVsgYTAWg6J2e9fMUPMEZD4NvkQC0SvrMSmA8wQZ0tKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIHxevrfs/4djHcPWB9iTAYaN5FZSjQ5Hxjv
	eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcfuk
	yBOTbqcmCilqT5r88N1nzagnaW5bNi4rkF4vN32DapN0f+G3PcwL5/87dbfWd87G6rg1l7T+
	7V5+dLmdiYylbP2eXUGtFyYVcsdWWa+Wb4t4aPA4wiz9cGWAWTNP3GTza/vqzpVt+nkrzoB5
	bxMLp8ixmVHXrYQ4JxU/Vjsw5f92v8vb2pRYijMSDbWYi4oTAfx4nQrtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV3f9IJgg9bnKhZ37p5jtfg76Ri7
	xfwjQNarIz+YLBbst7bonL2B3eL7ri/sFr0LrrJZbHp8jdXi8q45bBYzzu9jsriwYiO7xb/e
	g4wWUxYdZrU4/Kad1eLkn15GiyMPd7NbtFzvZbJYP+M1i8WqXX8YLWbeWsPiIOrx5OA8Jo/f
	vyYxesxuuMji8e9wP5PHzll32T3uXNvD5rF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEzTAHcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM07uOsNS0CRdsXv7JsYGxg+iXYyc
	HBICJhLzm94yQdhiEhfurWfrYuTiEBJYxCjx690ZFghnApPE+cZf7CBVbAKGEtvvXWEFSYgI
	rGaU6Lt4hh3EYRaYzSxx5NFiRpAqYQEfiQN/j4B1sAioSnxueAgW5xXwkDjzYB9QnANon4LE
	nEk2IGFOoPDn1VPYQGwhAXeJY6+usk5g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IzgZPJPawbiyweIQowAHoxIP7weGgmAh1sSy4srcQ4wSHMxKIrwf/YFCvCmJlVWpRfnxRaU5
	qcWHGJOBjprILCWanA9MVHkl8YbGJuamxqaWJhYmZpakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C
	2cLEwSnVwOgmGv/tiRlbQOW9r4YuLJ65X+vu/w+oYnXceijQJe74py9KNd8r/b/KTV49T3wy
	v4HR+zPMdaYdc14IZjNJGvnXfzJ8x+n9xFnPoPSQ1YLoa1mTz7um2T+4XP347qVlL5fcW8Lh
	2Jcn+C/MgjnzeJpTSXexlOykUL4vRbI3t99rNrx94tT9diWW4oxEQy3mouJEAHXM6ExKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch uses managed device helper functions in the probe().

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   68 ++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index be7a7b9..c86e374 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -343,8 +343,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	if (!IS_ERR(data->clk))
-		clk_disable(data->clk);
+	clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -387,8 +386,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (!IS_ERR(data->clk))
-		clk_enable(data->clk);
+	clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
@@ -499,49 +497,43 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
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
@@ -554,17 +546,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
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

