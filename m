Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaJGMBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:01:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27958 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaJGMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:01:32 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bf-5433d61ac233
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] drm/exynos/dsi: simplify device pointer evaluation
Date: Tue, 07 Oct 2014 14:01:09 +0200
Message-id: <1412683271-15835-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xK7pS14xDDFr7jCxurTvHanHl63s2
	i0n3J7BYvLh3kcWid8FVNouzTW/YLS7vmsNmMeP8PiaLtUfuslvMmPySzYHL4373cSaPvi2r
	GD0+b5ILYI7isklJzcksSy3St0vgyujZfYGtYLpcxcLfl1gbGP9JdDFyckgImEjc+dLECGGL
	SVy4t56ti5GLQ0hgKaPEghc9rBBOH5PEuaV7WECq2AQ0Jf5uvskGYosIKEus2tfODlLELLCD
	WeLopaNMXYwcHMIC7hJT9uWD1LAIqEo0rV3OCmLzCjhLbDx+iQlim5zEyWOTweKcAi4S8za8
	ApspBFQz+fRWpgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATY1x2MS49ZHWIU
	4GBU4uFdoWUcIsSaWFZcmXuIUYKDWUmE9/RFoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG7IT5
	whITgpiUGiZdfva745bN74uLZl+OfGub/D9t5kL2fedObPu8v3A/6yI7zxWc8xcaTZj8ftn8
	rQ3f9p7VXxJ+7kiaVtR2a3OZzDu9S0IX358gFvq7fvKjTxsFZeXO1ZZOVdz3ufVx1wJO09jJ
	PvGxGovTFC4u4aubmy6fNV+EJXWx2CZpKyWW4oxEQy3mouJEAIhiMuQOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces multiple evaluation of device address
with local variable.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 40 ++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 84e3808..39ec450 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1695,9 +1695,9 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dsi->transfer_list);
 
 	dsi->dsi_host.ops = &exynos_dsi_ops;
-	dsi->dsi_host.dev = &pdev->dev;
+	dsi->dsi_host.dev = dev;
 
-	dsi->dev = &pdev->dev;
+	dsi->dev = dev;
 	dsi->driver_data = exynos_dsi_get_driver_data(pdev);
 
 	ret = exynos_dsi_parse_dt(dsi);
@@ -1706,70 +1706,70 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 
 	dsi->supplies[0].supply = "vddcore";
 	dsi->supplies[1].supply = "vddio";
-	ret = devm_regulator_bulk_get(&pdev->dev, ARRAY_SIZE(dsi->supplies),
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(dsi->supplies),
 				      dsi->supplies);
 	if (ret) {
-		dev_info(&pdev->dev, "failed to get regulators: %d\n", ret);
+		dev_info(dev, "failed to get regulators: %d\n", ret);
 		return -EPROBE_DEFER;
 	}
 
-	dsi->pll_clk = devm_clk_get(&pdev->dev, "pll_clk");
+	dsi->pll_clk = devm_clk_get(dev, "pll_clk");
 	if (IS_ERR(dsi->pll_clk)) {
-		dev_info(&pdev->dev, "failed to get dsi pll input clock\n");
+		dev_info(dev, "failed to get dsi pll input clock\n");
 		ret = PTR_ERR(dsi->pll_clk);
 		goto err_del_component;
 	}
 
-	dsi->bus_clk = devm_clk_get(&pdev->dev, "bus_clk");
+	dsi->bus_clk = devm_clk_get(dev, "bus_clk");
 	if (IS_ERR(dsi->bus_clk)) {
-		dev_info(&pdev->dev, "failed to get dsi bus clock\n");
+		dev_info(dev, "failed to get dsi bus clock\n");
 		ret = PTR_ERR(dsi->bus_clk);
 		goto err_del_component;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dsi->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	dsi->reg_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(dsi->reg_base)) {
-		dev_err(&pdev->dev, "failed to remap io region\n");
+		dev_err(dev, "failed to remap io region\n");
 		ret = PTR_ERR(dsi->reg_base);
 		goto err_del_component;
 	}
 
-	dsi->phy = devm_phy_get(&pdev->dev, "dsim");
+	dsi->phy = devm_phy_get(dev, "dsim");
 	if (IS_ERR(dsi->phy)) {
-		dev_info(&pdev->dev, "failed to get dsim phy\n");
+		dev_info(dev, "failed to get dsim phy\n");
 		ret = PTR_ERR(dsi->phy);
 		goto err_del_component;
 	}
 
 	dsi->irq = platform_get_irq(pdev, 0);
 	if (dsi->irq < 0) {
-		dev_err(&pdev->dev, "failed to request dsi irq resource\n");
+		dev_err(dev, "failed to request dsi irq resource\n");
 		ret = dsi->irq;
 		goto err_del_component;
 	}
 
 	irq_set_status_flags(dsi->irq, IRQ_NOAUTOEN);
-	ret = devm_request_threaded_irq(&pdev->dev, dsi->irq, NULL,
+	ret = devm_request_threaded_irq(dev, dsi->irq, NULL,
 					exynos_dsi_irq, IRQF_ONESHOT,
-					dev_name(&pdev->dev), dsi);
+					dev_name(dev), dsi);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to request dsi irq\n");
+		dev_err(dev, "failed to request dsi irq\n");
 		goto err_del_component;
 	}
 
-	exynos_dsi_display.ctx = dsi;
+	dsi->display.ctx = dsi;
 
-	platform_set_drvdata(pdev, &exynos_dsi_display);
+	platform_set_drvdata(pdev, &dsi->display);
 
-	ret = component_add(&pdev->dev, &exynos_dsi_component_ops);
+	ret = component_add(dev, &exynos_dsi_component_ops);
 	if (ret)
 		goto err_del_component;
 
 	return ret;
 
 err_del_component:
-	exynos_drm_component_del(&pdev->dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
+	exynos_drm_component_del(dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
 	return ret;
 }
 
-- 
1.9.1

