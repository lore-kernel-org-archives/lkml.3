Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaH0HxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:53:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62588 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaH0HxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:53:10 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c2-53fd8e630847
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc3: exynos: remove usb_phy_generic support
Date: Wed, 27 Aug 2014 09:52:59 +0200
Message-id: <2141307.zYQLjP6V6U@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd3kvr/BBl331SwO3q+3aLtykN2i
	d8FVNouzTW/YLS7vmsNmMeP8PiaLRctamS1OXf/M5sDhceVEE6tH35ZVjB7Hb2xn8vi8SS6A
	JYrLJiU1J7MstUjfLoErY83lmywF7YoVS/7/Ym5gPCXdxcjJISFgInG8qZsVwhaTuHBvPVsX
	IxeHkMAiRoknhzuZIJwWJomtTceZQarYBKwkJravYgSxRQTkJSb9WcgKUsQs8JdRornzEBtI
	QljASaLl51GgBAcHi4CqxJ7VSiBhXgFNiT39a5hAbFEBT4kd21eyQcQFJX5MvscCYjMDzdy3
	fyorhK0lsX7ncaYJjHyzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	QftMagfjygaLQ4wCHIxKPLwfF/wJFmJNLCuuzD3EKMHBrCTCa9/8N1iINyWxsiq1KD++qDQn
	tfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDY3f14eD2Zw99mRim1xzibb68/c+s
	hcvXa5q3L7UROXPDt/16j7b515up5nx8vRG+h35Xp19d0pDiNEW6+XxqY9TekA+rrW+elfNd
	FLHmYvfKt2fS2hTe2SXMO7HMY1XFt9q+lX/zPijJ7vsV5/lGTeiwyPLnZXMkIo583JFa+59v
	+++dBdu0dJVYijMSDbWYi4oTAbhR4fNWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
(PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
looking at the following commits:

  7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
  phy driver for exynos5250")

  f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
  exynos5420")

Thus remove unused usb_phy_generic support from dwc3 Exynos glue
layer.

[ The code that is being removed is harmful in the context of
  multi_v7_defconfig and enabling "EHCI support for Samsung
  S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
  Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
  support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
  "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
  attaches itself to usb_phy_generic platform devices created by
  dwc3 Exynos glue layer and later causes Exynos EHCI driver to
  fail probe and Exynos OHCI driver to hang on probe (as observed
  on Exynos5250 Arndale board). ]

Cc: Olof Johansson <olof@lixom.net>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   68 -----------------------------------------
 1 file changed, 1 insertion(+), 67 deletions(-)

Index: b/drivers/usb/dwc3/dwc3-exynos.c
===================================================================
--- a/drivers/usb/dwc3/dwc3-exynos.c	2014-08-25 14:57:04.991781925 +0200
+++ b/drivers/usb/dwc3/dwc3-exynos.c	2014-08-27 09:16:38.312617727 +0200
@@ -23,15 +23,12 @@
 #include <linux/platform_data/dwc3-exynos.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
-#include <linux/usb/otg.h>
-#include <linux/usb/usb_phy_generic.h>
+#include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/regulator/consumer.h>
 
 struct dwc3_exynos {
-	struct platform_device	*usb2_phy;
-	struct platform_device	*usb3_phy;
 	struct device		*dev;
 
 	struct clk		*clk;
@@ -39,61 +36,6 @@ struct dwc3_exynos {
 	struct regulator	*vdd10;
 };
 
-static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
-{
-	struct usb_phy_generic_platform_data pdata;
-	struct platform_device	*pdev;
-	int			ret;
-
-	memset(&pdata, 0x00, sizeof(pdata));
-
-	pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
-	if (!pdev)
-		return -ENOMEM;
-
-	exynos->usb2_phy = pdev;
-	pdata.type = USB_PHY_TYPE_USB2;
-	pdata.gpio_reset = -1;
-
-	ret = platform_device_add_data(exynos->usb2_phy, &pdata, sizeof(pdata));
-	if (ret)
-		goto err1;
-
-	pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		ret = -ENOMEM;
-		goto err1;
-	}
-
-	exynos->usb3_phy = pdev;
-	pdata.type = USB_PHY_TYPE_USB3;
-
-	ret = platform_device_add_data(exynos->usb3_phy, &pdata, sizeof(pdata));
-	if (ret)
-		goto err2;
-
-	ret = platform_device_add(exynos->usb2_phy);
-	if (ret)
-		goto err2;
-
-	ret = platform_device_add(exynos->usb3_phy);
-	if (ret)
-		goto err3;
-
-	return 0;
-
-err3:
-	platform_device_del(exynos->usb2_phy);
-
-err2:
-	platform_device_put(exynos->usb3_phy);
-
-err1:
-	platform_device_put(exynos->usb2_phy);
-
-	return ret;
-}
-
 static int dwc3_exynos_remove_child(struct device *dev, void *unused)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -127,12 +69,6 @@ static int dwc3_exynos_probe(struct plat
 
 	platform_set_drvdata(pdev, exynos);
 
-	ret = dwc3_exynos_register_phys(exynos);
-	if (ret) {
-		dev_err(dev, "couldn't register PHYs\n");
-		return ret;
-	}
-
 	clk = devm_clk_get(dev, "usbdrd30");
 	if (IS_ERR(clk)) {
 		dev_err(dev, "couldn't get clock\n");
@@ -194,8 +130,6 @@ static int dwc3_exynos_remove(struct pla
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
 	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
-	platform_device_unregister(exynos->usb2_phy);
-	platform_device_unregister(exynos->usb3_phy);
 
 	clk_disable_unprepare(exynos->clk);
 

