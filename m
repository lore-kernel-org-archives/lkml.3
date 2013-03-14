Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab3CNMnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:43:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22247 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3CNMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:43:10 -0400
X-AuditID: cbfee68d-b7f786d000005188-40-5141c5dcbe35
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org
Subject: [PATCH v2 1/2] usb: dwc3: exynos: Use of_platform API to create dwc3
 core pdev
Date: Thu, 14 Mar 2013 18:09:49 +0530
Message-id: <1363264789-4036-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iHZRfiSAXnbwhFNs4Rm7fzFx=v83pcWFJHsOo+JPya6VQ@mail.gmail.com>
References: <CAFp+6iHZRfiSAXnbwhFNs4Rm7fzFx=v83pcWFJHsOo+JPya6VQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkRvfOUcdAg5ezpC0O3q+3ODD7IavF
	2WUH2SyaF69ns+hdcJXN4vKuOWwWs5f0s1jMOL+PyWLRslZmi8MrDjBZHJuxhNGB22PB5yvs
	HrMbLrJ43Lm2h81j/9w17B7nZyxk9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGWs
	efOXpeCcfMWfBZYNjJckuxg5OSQETCROXL/OCGGLSVy4t56ti5GLQ0hgKaPEtUvPmWCKrrdu
	Y4FITGeUmHb0PVhCSGAKk8S8f3UgNpuArkTT211gk0QE0iX+3+0Hs5kFzjBKvHwRC2ILC0RK
	/D39kR3EZhFQlbjc8pEZxOYVcJeY0vIa6goFiTe3n4HFOQWCJabMm8EIsStA4uvsY8wgR0gI
	nGOX+LSgjxFikIDEt8mHgK7jAErISmw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtQr
	TswtLs1L10vOz93ECIyU0/+e9e5gvH3A+hBjMtC4icxSosn5wEjLK4k3NDYzsjA1MTU2Mrc0
	I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjqTdvLT6cWDZ571/pvQdDrsup
	HOm2VvhjcHntUU+jGcF/Kj5++KehfuK2lVjNtYXxm/k+CHTzL5faUKGpkGK36rURa2Nxw3ZV
	wYRVm63i+kr+rf+gGXDwm8tjtd0/3ezMY05uLSoxzn38Yb7py5Muav6Np/k898xk3rpRmkVo
	TiZbrf93P/u/SizFGYmGWsxFxYkAxM6tn6oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd07Rx0DDY4eEbA4eL/e4sDsh6wW
	Z5cdZLNoXryezaJ3wVU2i8u75rBZzF7Sz2Ix4/w+JotFy1qZLQ6vOMBkcWzGEkYHbo8Fn6+w
	e8xuuMjicefaHjaP/XPXsHucn7GQ0aNvyypGj+M3tjN5fN4kF8AR1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYxY82bvywF5+Qr/iywbGC8JNnFyMkhIWAicb11GwuELSZx
	4d56ti5GLg4hgemMEtOOvmcCSQgJTGGSmPevDsRmE9CVaHq7ixHEFhFIl/h/tx/MZhY4wyjx
	8kUsiC0sECnx9/RHdhCbRUBV4nLLR2YQm1fAXWJKy2tGiGUKEm9uPwOLcwoES0yZN4MRYleA
	xNfZx5gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREch8+kdjCubLA4xCjAwajE
	w3ug3yFQiDWxrLgy9xCjBAezkgivp5djoBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnA1NE
	Xkm8obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwTjs/k/nLFNVL
	247KTHhkrHqUxzf79J/sbUs2GLEw33eNZeVpnflh+9J7MSvblRY+VP6kFmK0/Pumtf8VLTa/
	jjsze/p0j/45nw84u/Dn5BY3l07nVnXb8WGmb0yEgJPZ9r8pKXO8rxj/N73NalIges/t5tqo
	ndb63t7MFm/fN/Crc5Vv8Vp1S4mlOCPRUIu5qDgRAGUmfrEHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used of_platform_populate() to create dwc3 core platform_device
from device tree data. Additionally some cleanup is also done.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
---

Changes from v1:
 - Added method to unregister dwc3 core from dwc3_exynos_remove()
   using device_for_each_child() API, which we missed to do.

 drivers/usb/dwc3/dwc3-exynos.c |   56 ++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index e12e452..f77ec75 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -22,9 +22,9 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 
 struct dwc3_exynos {
-	struct platform_device	*dwc3;
 	struct platform_device	*usb2_phy;
 	struct platform_device	*usb3_phy;
 	struct device		*dev;
@@ -86,21 +86,30 @@ err1:
 	return ret;
 }
 
+static int dwc3_exynos_remove_child(struct device *dev, void *unused)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
 static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
 
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
-	struct platform_device	*dwc3;
 	struct dwc3_exynos	*exynos;
 	struct clk		*clk;
 	struct device		*dev = &pdev->dev;
+	struct device_node	*node = dev->of_node;
 
 	int			ret = -ENOMEM;
 
 	exynos = devm_kzalloc(dev, sizeof(*exynos), GFP_KERNEL);
 	if (!exynos) {
 		dev_err(dev, "not enough memory\n");
-		return -ENOMEM;
+		goto err1;
 	}
 
 	/*
@@ -108,21 +117,15 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we move to full device tree support this will vanish off.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &dwc3_exynos_dma_mask;
+	if (!dev->dma_mask)
+		dev->dma_mask = &dwc3_exynos_dma_mask;
 
 	platform_set_drvdata(pdev, exynos);
 
 	ret = dwc3_exynos_register_phys(exynos);
 	if (ret) {
 		dev_err(dev, "couldn't register PHYs\n");
-		return ret;
-	}
-
-	dwc3 = platform_device_alloc("dwc3", PLATFORM_DEVID_AUTO);
-	if (!dwc3) {
-		dev_err(dev, "couldn't allocate dwc3 device\n");
-		return -ENOMEM;
+		goto err1;
 	}
 
 	clk = devm_clk_get(dev, "usbdrd30");
@@ -132,27 +135,20 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
-
-	dwc3->dev.parent = dev;
-	dwc3->dev.dma_mask = dev->dma_mask;
-	dwc3->dev.dma_parms = dev->dma_parms;
-	exynos->dwc3	= dwc3;
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
 	clk_enable(exynos->clk);
 
-	ret = platform_device_add_resources(dwc3, pdev->resource,
-			pdev->num_resources);
-	if (ret) {
-		dev_err(dev, "couldn't add resources to dwc3 device\n");
-		goto err2;
-	}
-
-	ret = platform_device_add(dwc3);
-	if (ret) {
-		dev_err(dev, "failed to register dwc3 device\n");
+	if (node) {
+		ret = of_platform_populate(node, NULL, NULL, dev);
+		if (ret) {
+			dev_err(dev, "failed to add dwc3 core\n");
+			goto err2;
+		}
+	} else {
+		dev_err(dev, "no device node, failed to add dwc3 core\n");
+		ret = -ENODEV;
 		goto err2;
 	}
 
@@ -161,8 +157,6 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 err2:
 	clk_disable(clk);
 err1:
-	platform_device_put(dwc3);
-
 	return ret;
 }
 
@@ -170,9 +164,9 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
-	platform_device_unregister(exynos->dwc3);
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
+	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
 
 	clk_disable(exynos->clk);
 
-- 
1.7.6.5

