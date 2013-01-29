Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3A2KqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:46:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab3A2KqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:46:01 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-fa-5107a858ad2b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        jg1.han@samsung.com, Doug Anderson <dianders@chromium.org>
Subject: [PATCH] usb: ehci: s5p: Power-off VBUS during suspend.
Date: Tue, 29 Jan 2013 16:22:45 +0530
Message-id: <1359456765-7335-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkVjdiBXugwZI+PovLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4MjYcfsZUcEasYtXvb0wNjJeEuhg5OSQETCQO
	XT/MDGGLSVy4t56ti5GLQ0hgKaPEnukrWboYOcCKjr5Ph4gvYpQ49no+E4QzmUli2rGr7CDd
	bAK6Ek1vdzGC2CICshKHr/xmBiliFtjFKPHr91GwhLCAvcSDqa1g61gEVCV+tE5gA9nAK+Au
	cbTVC+IKBYk3t5+B9UoInGGTeNm+CapeQOLb5ENQF8lKbDoAdbWkxMEVN1gmMAouYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREYZqf/PZPewbiqweIQowAHoxIPr8Y8tkAh1sSy4src
	Q4wSHMxKIryuteyBQrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HxkBeSbyhsYm5qbGppZGR
	makpacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamA0tv3fWXkhM2VPwN7/zqxzhJMtWhdL
	ifZpfjvMee2i0clDx0tdjPRyF7G25Ge29taaHHJQPSroz7OG/X7lVMmrkgsnOXdeubz2e6Df
	heeyj5vUA70ljC2EjKbHB3xNvc15500ndzeDjfLUYK4Pf7W4uvgv7ZFV4q788UrKcc3+A4b3
	+O3zjyixFGckGmoxFxUnAgCqf/4/dwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd2IFeyBBq+YLC7vmsNmMeP8PiaL
	RctamR2YPT5vkgtgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzNhw+BlT
	wRmxilW/vzE1MF4S6mLk4JAQMJE4+j69i5ETyBSTuHBvPVsXIxeHkMAiRoljr+czQTiTmSSm
	HbvKDlLFJqAr0fR2FyOILSIgK3H4ym9mkCJmgV2MEr9+HwVLCAvYSzyY2soMYrMIqEr8aJ3A
	BrKNV8Bd4mirF8Q2BYk3t58xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOISf
	Se9gXNVgcYhRgINRiYdXYx5boBBrYllxZe4hRgkOZiURXtda9kAh3pTEyqrUovz4otKc1OJD
	jMlAyycyS4km5wPjK68k3tDYxNzU2NTSxMLEzJI0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBx
	cEo1MMpYPLg+/+HdLacmWjnL/r7xSHNf64J1F1PWlf/5+bW/o39qzV6dWT3TJXgMlbb4/M7e
	aSjklL3TM6NnnsnD183J/yaKfFhRn6wcZpoacka68+jqXy0lOUa1z7j09+p/VYoXEvL32Ptc
	ZcsO7c88By69u3M1cq6vvVZENNeNi/tyKzgTHJ8zf1ZiKc5INNRiLipOBAA/VlTcpQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change de-asserts vbus_gpio on suspend and
re-asserts on resume in order to save power.
NOTE, this change means no USB charging in suspend
mode.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Doug Anderson <dianders@chromium.org>
---

Based on 'usb-next'.

 drivers/usb/host/ehci-s5p.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..297f6f2 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -37,6 +37,7 @@ struct s5p_ehci_hcd {
 	struct usb_phy *phy;
 	struct usb_otg *otg;
 	struct s5p_ehci_platdata *pdata;
+	int vbus_gpio;
 };
 
 static const struct hc_driver s5p_ehci_hc_driver = {
@@ -90,22 +91,28 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
 		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 }
 
-static void s5p_setup_vbus_gpio(struct platform_device *pdev)
+static int s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
 	int err;
 	int gpio;
 
-	if (!pdev->dev.of_node)
-		return;
+	if (!pdev->dev.of_node) {
+		dev_err(&pdev->dev, "No device node present\n");
+		return -ENODEV;
+	}
 
 	gpio = of_get_named_gpio(pdev->dev.of_node,
 			"samsung,vbus-gpio", 0);
 	if (!gpio_is_valid(gpio))
-		return;
+		return -EINVAL;
 
 	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
-	if (err)
+	if (err) {
 		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+		return err;
+	}
+
+	return gpio;
 }
 
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
@@ -131,8 +138,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
-	s5p_setup_vbus_gpio(pdev);
-
 	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
 				GFP_KERNEL);
 	if (!s5p_ehci)
@@ -154,6 +159,10 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 
 	s5p_ehci->dev = &pdev->dev;
 
+	s5p_ehci->vbus_gpio = s5p_setup_vbus_gpio(pdev);
+	if (!gpio_is_valid(s5p_ehci->vbus_gpio))
+		dev_warn(&pdev->dev, "Failed to setup vbus gpio\n");
+
 	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
 					dev_name(&pdev->dev));
 	if (!hcd) {
@@ -270,6 +279,9 @@ static int s5p_ehci_suspend(struct device *dev)
 
 	s5p_ehci_phy_disable(s5p_ehci);
 
+	if (gpio_is_valid(s5p_ehci->vbus_gpio))
+		gpio_set_value(s5p_ehci->vbus_gpio, 0);
+
 	clk_disable_unprepare(s5p_ehci->clk);
 
 	return rc;
@@ -282,6 +294,9 @@ static int s5p_ehci_resume(struct device *dev)
 
 	clk_prepare_enable(s5p_ehci->clk);
 
+	if (gpio_is_valid(s5p_ehci->vbus_gpio))
+		gpio_set_value(s5p_ehci->vbus_gpio, 1);
+
 	if (s5p_ehci->otg)
 		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
 
-- 
1.7.6.5

