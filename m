Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3AVM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:57:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22223 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AVM5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:57:42 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-cb-50fe8cc45e47
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v8 3/4] USB: ehci-s5p: Add phy driver support
Date: Tue, 22 Jan 2013 18:30:42 +0530
Message-id: <1358859643-5030-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
References: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWvdIz78Agz3/9S0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyrh04AdTwQrdiiWrzrI1MF5X7WLk5JAQMJFY
	+XQ3G4QtJnHh3nogm4tDSGApo8S2Z5PZYIq2LF/DCJGYzijxf0cDVNVkJokrGzsYQarYBHQl
	mt7uArNFBGQlDl/5zQxSxCzwl0ni8ap+dpCEsICtxMRlTUDdHBwsAqoS767mgIR5Bdwlrh66
	wwSxTUHize1nzCA2p4CHxIcDp8FahYBqWr+9B1ssIfCYTeLk1Ktg57EICEh8m3yIBWSmBNDi
	TQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxiBgXn63zPpHYyr
	GiwOMQpwMCrx8D64/zdAiDWxrLgy9xCjBAezkgivbv2/ACHelMTKqtSi/Pii0pzU4kOMyUDL
	JzJLiSbnA6MmryTe0NjE3NTY1NLIyMzUlDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUw
	Mmm8rlnP1BxUL+D79Mjp8mstjTvqI3du2f3j5fEDvrlZdppT7YXvd5tf0ow0c323Or6aiTUp
	wVg7194wUsza6Wr34Z372sv4npUFvfrlFLzE9tCsexEmX6xjDl1Rde4sn35wy7es7Mkvl+wo
	7H7h921mT4/KCuWpb4rtVZiOi8Yp9z7ZqP5UiaU4I9FQi7moOBEAuOJh5ZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd0jPf8CDO40iltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx6cAP
	poIVuhVLVp1la2C8rtrFyMkhIWAisWX5GkYIW0ziwr31bF2MXBxCAtMZJf7vaIByJjNJXNnY
	AVbFJqAr0fR2F5gtIiArcfjKb2aQImaBv0wSj1f1s4MkhAVsJSYuawLq5uBgEVCVeHc1ByTM
	K+AucfXQHSaIbQoSb24/YwaxOQU8JD4cOA3WKgRU0/rtPdsERt4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYLD/pn0DsZVDRaHGAU4GJV4eB/c/xsgxJpYVlyZe4hRgoNZSYRXt/5f
	gBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA2MyryTe0NjE3NTY1NLEwsTMkjRhJXFexlNP
	AoQE0hNLUrNTUwtSi2C2MHFwSjUwujQtNuyMcfwvcvav3u1z9yK3zynMf331+6lJSh8equoy
	SPS6xgjzz9iwRX/zVAftq/9vtf++8m/Ovdb767tKe44WZLRItid8d/Z7wx7p+a/QSSGgZdn0
	jH1HQuMa5AtVQ2SmPanZHnZ4U1LZpDVmq6taXnTEp1z9uMTQyNvg9fSQaT1fVHM+KLEUZyQa
	ajEXFScCABQd1Pu/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the phy driver to ehci-s5p. Keeping the platform data
for continuing the smooth operation for boards which still uses it

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/usb/host/ehci-s5p.c |   80 +++++++++++++++++++++++++++++++-----------
 1 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 46ca5ef..d603e6e 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
@@ -33,6 +34,9 @@ struct s5p_ehci_hcd {
 	struct device *dev;
 	struct usb_hcd *hcd;
 	struct clk *clk;
+	struct usb_phy *phy;
+	struct usb_otg *otg;
+	struct s5p_ehci_platdata *pdata;
 };
 
 static const struct hc_driver s5p_ehci_hc_driver = {
@@ -66,6 +70,26 @@ static const struct hc_driver s5p_ehci_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+static void s5p_ehci_phy_enable(struct s5p_ehci_hcd *s5p_ehci)
+{
+	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
+
+	if (s5p_ehci->phy)
+		usb_phy_init(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_init)
+		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+}
+
+static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
+{
+	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
+
+	if (s5p_ehci->phy)
+		usb_phy_shutdown(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_exit)
+		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+}
+
 static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
 	int err;
@@ -88,20 +112,15 @@ static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
 
 static int s5p_ehci_probe(struct platform_device *pdev)
 {
-	struct s5p_ehci_platdata *pdata;
+	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	struct s5p_ehci_hcd *s5p_ehci;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
+	struct usb_phy *phy;
 	int irq;
 	int err;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "No platform data defined\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Right now device-tree probed devices don't get dma_mask set.
 	 * Since shared usb code relies on it, set it here for now.
@@ -119,6 +138,20 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	if (!s5p_ehci)
 		return -ENOMEM;
 
+	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR_OR_NULL(phy)) {
+		/* Fallback to pdata */
+		if (!pdata) {
+			dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
+			return -EPROBE_DEFER;
+		} else {
+			s5p_ehci->pdata = pdata;
+		}
+	} else {
+		s5p_ehci->phy = phy;
+		s5p_ehci->otg = phy->otg;
+	}
+
 	s5p_ehci->dev = &pdev->dev;
 
 	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
@@ -164,8 +197,10 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	if (pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	if (s5p_ehci->otg)
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+
+	s5p_ehci_phy_enable(s5p_ehci);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -176,13 +211,15 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto fail_io;
+		goto fail_add_hcd;
 	}
 
 	platform_set_drvdata(pdev, s5p_ehci);
 
 	return 0;
 
+fail_add_hcd:
+	s5p_ehci_phy_disable(s5p_ehci);
 fail_io:
 	clk_disable_unprepare(s5p_ehci->clk);
 fail_clk:
@@ -192,14 +229,15 @@ fail_clk:
 
 static int s5p_ehci_remove(struct platform_device *pdev)
 {
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	struct s5p_ehci_hcd *s5p_ehci = platform_get_drvdata(pdev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
 
 	usb_remove_hcd(hcd);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	if (s5p_ehci->otg)
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+
+	s5p_ehci_phy_disable(s5p_ehci);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -223,14 +261,14 @@ static int s5p_ehci_suspend(struct device *dev)
 	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
 	bool do_wakeup = device_may_wakeup(dev);
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	int rc;
 
 	rc = ehci_suspend(hcd, do_wakeup);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	if (s5p_ehci->otg)
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+
+	s5p_ehci_phy_disable(s5p_ehci);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -241,13 +279,13 @@ static int s5p_ehci_resume(struct device *dev)
 {
 	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 
 	clk_prepare_enable(s5p_ehci->clk);
 
-	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	if (s5p_ehci->otg)
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+
+	s5p_ehci_phy_enable(s5p_ehci);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
-- 
1.7.6.5

