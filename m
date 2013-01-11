Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3AKO41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:56:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54994 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab3AKO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:56:23 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f0-50f0281510c4
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v6 3/4] USB: ehci-s5p: Add phy driver support
Date: Fri, 11 Jan 2013 20:32:29 +0530
Message-id: <1357916550-11421-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkTldU40OAwfsWQ4vLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mu5+nMNYcEKn4u315YwNjI2qXYwcHBICJhIb
	1iV0MXICmWISF+6tZ+ti5OIQEljKKLF65zEWiISJxI6zc9khEosYJTbPfMsM4UxmkvjSuo0Z
	pIpNQFei6e0uRhBbREBW4vCV32BFzAIPmCRub1zHDpIQFrCVeLS3nw3EZhFQlZg0bzVYnFfA
	Q2LXiSfsEOsUJN7cfgY2lFPAU2L9pplgQ4WAahZOXMUK0Ssg8W3yIRaIF2QlNh0A2yUhcJ9N
	YkFjLzPEHEmJgytusExgFF7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzAwT/97Jr2D
	cVWDxSFGAQ5GJR7eSs33AUKsiWXFlbmHGCU4mJVEeL0YPwQI8aYkVlalFuXHF5XmpBYfYvQB
	umQis5Rocj4wavJK4g2NTcxNjU0tjYzMTE1xCCuJ8zKeehIgJJCeWJKanZpakFoEM46Jg1Oq
	gZHPseTWv5AVnB7lbJ8vOW64Kvnpp9AU9rSwc82qKnqCPJyf31l86rDXuqLdbvXP+tCDwocM
	krXPy40+Mu9j7n+ZYBdv83bL+W0NudsLN71weWXqlP8j/rPeqYrHW7imrl6w5MIVvbTrnsm7
	LjAYnrBe6Msyx7uv+e3XrHe1WzwmCBZeFgq/tk+JpTgj0VCLuag4EQBzKEyLeQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAV1RjQ8BBnOuylhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx9+Mc
	xoITOhVvry9nbGBsVO1i5OSQEDCR2HF2LjuELSZx4d56ti5GLg4hgUWMEptnvmWGcCYzSXxp
	3cYMUsUmoCvR9HYXI4gtIiArcfjKb7AiZoEHTBK3N64DGyUsYCvxaG8/G4jNIqAqMWnearA4
	r4CHxK4TT6DWKUi8uf0MbCingKfE+k0zwYYKAdUsnLiKdQIj7wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwYH/THoH46oGi0OMAhyMSjy8lZrvA4RYE8uKK3MPMUpwMCuJ8HoxfggQ
	4k1JrKxKLcqPLyrNSS0+xOgDdNVEZinR5HxgVOaVxBsam5ibGptamliYmFniEFYS52U89SRA
	SCA9sSQ1OzW1ILUIZhwTB6dUA6NOLadc+z75lXILH/fp1zh2RB2029/VHPKSkalva/jS1pTg
	vedsjjcdPy+4Odan25P7xpyec10CFTPuLvn+Oe70BCm3hC0lXgtOLqoTcY79V5yy+vGsc1lJ
	wgKZMenWikc79Xmtel/bMHK/nzNB8PvD8/Fpokcc1C5+e+DRtuXu19sGEeHsukosxRmJhlrM
	RcWJAHgvhs2pAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the phy driver to ehci-s5p. Keeping the platform data
for continuing the smooth operation for boards which still uses it

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
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

