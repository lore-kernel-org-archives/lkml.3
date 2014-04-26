Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaDZLjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:39:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22860 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaDZLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:44 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-47-535b9afe8951
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 2/5 v2] iio: exynos_adc: rearrange clk and regulator
 enable/disable calls
Date: Sat, 26 Apr 2014 17:07:53 +0530
Message-id: <1398512276-4105-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkWvf/rOhgg+kzmC3uPj/MaPHykKbF
	2WUH2SyaF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZN3Z9Zilo
	UayY/OIWWwPjDOkuRk4OCQETiXsrFzBD2GISF+6tZ+ti5OIQEljKKNH+czsrTNHkq+ehEtMZ
	JT63XGYESQgJ9DNJ3HsYB2KzCZhJHFy0mr2LkYNDREBWYma3Hkg9M0hJw9OLYPXCAtESNzev
	BRvKIqAqcXD9MXYQm1fAReLFpdlsIL0SAgoScybZgIQ5BVwlJi66ygSxykXi7cTX7CAzJQTO
	sUu8f7eFCWKOgMS3yYdYIHplJTYdgHpGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIjI/T/55N2MF474D1IcZkoHETmaVEk/OB8ZVXEm9obGZkYWpiamxkbmlGmrCS
	OK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwFeYUbJ39Y+LzgT9DJdbdvB2fbfZu7
	lflKpuCegvdOiW956ype9S7+zBfstHxbUsy1xittkSuuZu6rXTpxJROLWdfbb4cmpiW1FR+5
	d2uSeOm/qEjbfS9NnP75zjzHvWNCn0BnW/7m2GWNUSze+r+brh0/vDunV5W7+tDkuAU++84s
	P9d3aZW9EktxRqKhFnNRcSIALh5mGKUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd1/s6KDDX70mljcfX6Y0eLlIU2L
	s8sOslk0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZtzY9ZmloEWxYvKLW2wNjDOkuxg5OSQETCQmXz3PBmGLSVy4tx7I
	5uIQEpjOKPG55TIjSEJIoJ9J4t7DOBCbTcBM4uCi1exdjBwcIgKyEjO79UDqmUFKGp5eBKsX
	FoiWuLl5LSuIzSKgKnFw/TF2EJtXwEXixaXZbCC9EgIKEnMm2YCEOQVcJSYuusoEscpF4u3E
	1+wTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOvmfSOxhXNVgcYhTgYFTi4d2R
	ExUsxJpYVlyZe4hRgoNZSYR3UUp0sBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnAxNDXkm8
	obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwbqj9LB12c+/hg93r
	N+/puq29RD/t+uyu2z638u/c+nflwZaXJXeu/PxX131o3YpX9yb/Sz7BUqf56PNejtaEm27f
	VH7/PJAfK1v2bMb3iEN8p5aWOq3lsOZy9qs4/7b8P9feeXXC+/L4TGOvmRleeNnst7NF5r79
	08kynecci5XvHNgksKiog1WJpTgj0VCLuag4EQAvWVWsAgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch maintains the following order in
probe(), remove(), resume() and suspend() calls

regulator enable, clk prepare enable
...
clk disable unprepare, regulator disable

While at it,
1. enable the regulator before the iio_device_register()
2. handle the return values for enable/disable calls

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
Changes since v1:
corrected the register/unregister and enabling/disbaling sequences

 drivers/iio/adc/exynos_adc.c |   63 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index affa93f..0df8916 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -290,32 +290,30 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	init_completion(&info->completion);
 
-	ret = request_irq(info->irq, exynos_adc_isr,
-					0, dev_name(&pdev->dev), info);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
-							info->irq);
-		return ret;
-	}
-
-	writel(1, info->enable_reg);
-
 	info->clk = devm_clk_get(&pdev->dev, "adc");
 	if (IS_ERR(info->clk)) {
 		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
 							PTR_ERR(info->clk));
-		ret = PTR_ERR(info->clk);
-		goto err_irq;
+		return PTR_ERR(info->clk);
 	}
 
 	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
 	if (IS_ERR(info->vdd)) {
 		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
 							PTR_ERR(info->vdd));
-		ret = PTR_ERR(info->vdd);
-		goto err_irq;
+		return PTR_ERR(info->vdd);
 	}
 
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		goto err_disable_reg;
+
+	writel(1, info->enable_reg);
+
 	info->version = exynos_adc_get_version(pdev);
 
 	platform_set_drvdata(pdev, indio_dev);
@@ -332,16 +330,18 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	else
 		indio_dev->num_channels = MAX_ADC_V2_CHANNELS;
 
+	ret = request_irq(info->irq, exynos_adc_isr,
+					0, dev_name(&pdev->dev), info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
+							info->irq);
+		goto err_disable_clk;
+	}
+
 	ret = iio_device_register(indio_dev);
 	if (ret)
 		goto err_irq;
 
-	ret = regulator_enable(info->vdd);
-	if (ret)
-		goto err_iio_dev;
-
-	clk_prepare_enable(info->clk);
-
 	exynos_adc_hw_init(info);
 
 	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
@@ -355,12 +355,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
 err_of_populate:
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
-	regulator_disable(info->vdd);
-	clk_disable_unprepare(info->clk);
-err_iio_dev:
 	iio_device_unregister(indio_dev);
 err_irq:
 	free_irq(info->irq, info);
+err_disable_clk:
+	writel(0, info->enable_reg);
+	clk_disable_unprepare(info->clk);
+err_disable_reg:
+	regulator_disable(info->vdd);
 	return ret;
 }
 
@@ -371,11 +373,12 @@ static int exynos_adc_remove(struct platform_device *pdev)
 
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
-	regulator_disable(info->vdd);
-	clk_disable_unprepare(info->clk);
-	writel(0, info->enable_reg);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
+	writel(0, info->enable_reg);
+	clk_disable_unprepare(info->clk);
+	regulator_disable(info->vdd);
+
 
 	return 0;
 }
@@ -397,8 +400,8 @@ static int exynos_adc_suspend(struct device *dev)
 		writel(con, ADC_V1_CON(info->regs));
 	}
 
-	clk_disable_unprepare(info->clk);
 	writel(0, info->enable_reg);
+	clk_disable_unprepare(info->clk);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -414,9 +417,11 @@ static int exynos_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	writel(1, info->enable_reg);
-	clk_prepare_enable(info->clk);
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		return ret;
 
+	writel(1, info->enable_reg);
 	exynos_adc_hw_init(info);
 
 	return 0;
-- 
1.7.9.5

