Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaCNFGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:06:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22797 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaCNFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:06:07 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-ae-53228e2674d8
Date: Fri, 14 Mar 2014 14:05:42 +0900
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zA121PqVggz3/bCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mo4sjW8YK54xdQVFxkbGO8IdTFyckgImEhs/dfCDmGL
	SVy4t56ti5GLQ0hgGaPE484rjDBFByd1skIkFjFKHO5+wAjhTGaSWNYxixWkikVAVeL3ss8s
	IDabgJbE6rnHwYpEBNqYJL42HmIBcZgF5jJLfPw2B2gJB4ewgI/E9dteIA28Ao4SCzqaWSDW
	WUhcaOpgh4gLSvyYfA8szgw0dPO2JlYIW15i85q3zCAzJQQ6OSR6DrxihLhCQOLbZJBlHEAJ
	WYlNB5ghZkpKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNz
	NzFConfiDsb7B6wPMSYDrZzILCWanA+M/rySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYKwNmX1l2vqlPgv0rJLVHS0ibPzO3hGc/OnSFBFXUVWG
	mWXG6j8aTy2aefe3b2D+oqVyf9v3Mm2XYVO3j/o3n68tMHW54lO3Isb/1cFO5+6ouMx+JslY
	90/ojEfOM98ZElKS6TM8Nmy55TM14qdG89lMc4/Sr5bzJU+8EJ2qujV/yYmNr1P0lJRYijMS
	DbWYi4oTAcM76Hr0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV21PqVgg4PtFhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOLI1vGCueMXU
	FRcZGxjvCHUxcnJICJhIHJzUyQphi0lcuLeerYuRi0NIYBGjxOHuB4wQzmQmiWUds8CqWARU
	JX4v+8wCYrMJaEmsnnscrEhEoI1J4mvjIRYQh1lgLrPEx29zgGZxcAgL+Ehcv+0F0sAr4Cix
	oKOZBWKdhcSFpg52iLigxI/J98DizEBDN29rYoWw5SU2r3nLPIGRbxaSsllIymYhKVvAyLyK
	UTS1ILmgOCk911CvODG3uDQvXS85P3cTIzg1PJPawbiyweIQowAHoxIPr8NhxWAh1sSy4src
	Q4wSHMxKIrxVEUrBQrwpiZVVqUX58UWlOanFhxiTgd6eyCwlmpwPTFt5JfGGxiZmRpZGZhZG
	JubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYFbdII2v/8z6RsIdftNwOPwxp/ivd
	YRlj+bX76/La8y7rp8Q2HV+ccu8o31Px30YG4o08S84vfRiVrcf6+vP1+mhd7vkPSoo/buTZ
	zbKka9GS0EsBHcJ2S2Of5d8/9G6D9c5VPw7v6jUWjJ9fs/fdeZ8di7tXh3A/mvbk3rQTRotO
	1/au2vD4hxJLcUaioRZzUXEiAGUy+clRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses managed device helper functions in the probe().

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 36e6b73..33b424d 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -499,51 +499,48 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
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
-		goto err_init;
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
-		data->clk = clk_get(dev, "sysmmu");
-		if (IS_ERR(data->clk)) {
-			data->clk = NULL;
-			dev_dbg(dev, "No clock descriptor registered\n");
-		}
+	data->clk = devm_clk_get(dev, "sysmmu");
+	if (IS_ERR(data->clk)) {
+		dev_info(dev, "No gate clock found!\n");
+		data->clk = NULL;
+	}
+
+	ret = clk_prepare(data->clk);
+	if (ret) {
+		dev_err(dev, "Failed to prepare clk\n");
+		return ret;
 	}
 
 	data->sysmmu = dev;
@@ -556,17 +553,8 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
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
1.7.9.5

