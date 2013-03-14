Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3CNKrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:47:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab3CNKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:47:30 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-92-5141aac06316
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org
Subject: [PATCH 1/2] usb: dwc3: exynos: Use of_platform API to create dwc3 core
 pdev
Date: Thu, 14 Mar 2013 16:14:57 +0530
Message-id: <1363257898-17504-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWyRsSkTvfAKsdAg/4pahYH79dbHJj9kNXi
	7LKDbBbNi9ezWfQuuMpmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxeEVB5gsjs1YwujA7bHg8xV2
	j9kNF1k87lzbw+axf+4ado/zMxYyevRtWcXocfzGdiaPz5vkAjiiuGxSUnMyy1KL9O0SuDKe
	XulkL3grXfH99gKWBsZTYl2MnBwSAiYS66f8ZoKwxSQu3FvP1sXIxSEksJRR4sDEjSwwRW1H
	T7FDJKYDJc5+ZoFwpjBJbPm/nA2kik1AV6Lp7S5GEFtEIF3i/91+MJtZ4AyjxMsXsSC2sECY
	RMfla8wgNouAqkRz7yGwDbwCHhIP2q4xQmxTkHhz+xlQDQcHp4CnxOXtuSBhIaCSU+s3MYLs
	lRC4xC7x5VQrI8QcAYlvk0HmcAAlZCU2HWCGGCMpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnr
	FSfmFpfmpesl5+duYgTGyul/z/p3MN49YH2IMRlo3ERmKdHkfGCs5ZXEGxqbGVmYmpgaG5lb
	mpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUdD3fs2Tv6/8uze9k7/pvPqR
	vqjtD4kjp0681m/3f8Pww/joSZVuZZu1W/vv/5uupuhW3y7+9HTgydIfNeIBCmXJaQt9wksW
	nAy6+O5s1natxRXtTs81THe+uL9PUP7h28Q9MVtrkp6F8LH2+n6o2XNV5q3dCy3P/MmvGxpX
	Jodvkni86ObmX0osxRmJhlrMRcWJAExlDumrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd0DqxwDDZouylocvF9vcWD2Q1aL
	s8sOslk0L17PZtG74CqbxeVdc9gsZi/pZ7GYcX4fk8WiZa3MFodXHGCyODZjCaMDt8eCz1fY
	PWY3XGTxuHNtD5vH/rlr2D3Oz1jI6NG3ZRWjx/Eb25k8Pm+SC+CIamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOY8fRKJ3vBW+mK77cXsDQwnhLrYuTkkBAwkWg7eoodwhaT
	uHBvPVsXIxeHkMB0RokDZz+zQDhTmCS2/F/OBlLFJqAr0fR2FyOILSKQLvH/bj+YzSxwhlHi
	5YtYEFtYIEyi4/I1ZhCbRUBVorn3EAuIzSvgIfGg7RojxDYFiTe3nwHVcHBwCnhKXN6eCxIW
	Aio5tX4T4wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiPxmfQOxlUNFocYBTgY
	lXh4I0QdA4VYE8uKK3MPMUpwMCuJ8Hp6AYV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5H5gk
	8kriDY1NzE2NTS1NLEzMLEkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0WrKFg1fxyYl
	XXXV/4vXB3jbGHMUle75UVibcSj7ML/+F8O/L/ees1zJIn95QcKZvWeao6blvZGun7RtYUvp
	ErZjG9Mj+GSypPbeNbp9b9v6p3N7Z27RlbjDJTjBdv3KDa58lTsvbVE98ThSeM2spfEv7iWs
	jb5dfNtPzfvxhwsfKhcdClvrUaTEUpyRaKjFXFScCADQ8AeNCAMAAA==
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
 drivers/usb/dwc3/dwc3-exynos.c |   46 +++++++++++++---------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index e12e452..66ca9ac 100644
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
@@ -90,17 +90,17 @@ static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
 
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
@@ -108,21 +108,15 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
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
@@ -132,27 +126,20 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
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
 
@@ -161,8 +148,6 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 err2:
 	clk_disable(clk);
 err1:
-	platform_device_put(dwc3);
-
 	return ret;
 }
 
@@ -170,7 +155,6 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
-	platform_device_unregister(exynos->dwc3);
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
-- 
1.7.6.5

