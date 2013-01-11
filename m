Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3AKO5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:57:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62149 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3AKO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:56:03 -0500
X-AuditID: cbfee61b-b7f616d00000319b-be-50f02802bc76
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v6 1/4] ARM: EXYNOS: Update & move usb-phy types to generic
 include layer
Date: Fri, 11 Jan 2013 20:32:27 +0530
Message-id: <1357916550-11421-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkTpdJ40OAwfL7whaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZexce4Cl4JBSxb0bN5kaGH/JdDFycEgImEhs
	eB/SxcgJZIpJXLi3nq2LkYtDSGApo8S9s5cYIRImEkc/LYNKLGKUuHrwAiuEM5lJ4tHiLWBV
	bAK6Ek1vd4HZIgKyEoev/GYGKWIWeMAkcXvjOnaQhLBAtMTKrg5WEJtFQFXi152fLCA2r4CH
	xJWPR1kh1ilIvLn9jBnE5hTwlFi/aSbYUCGgmoUTV0H1Ckh8m3yIBeIFWYlNB8B2SQg8Z5N4
	/a2NHWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRGJin/z2T3sG4
	qsHiEKMAB6MSD2+l5vsAIdbEsuLK3EOMEhzMSiK8XowfAoR4UxIrq1KL8uOLSnNSiw8x+gBd
	MpFZSjQ5Hxg1eSXxhsYm5qbGppZGRmampjiElcR5GU89CRASSE8sSc1OTS1ILYIZx8TBKdXA
	OL+nQ4k9UTrX5axXkq5inlLQnpe38/+3d/c5aVjmfFhqmfl64sdDUSuPrQjTX//hbP8iy+iQ
	SUwq7y6Ler8IT87L9nj05kn6AalDpf8e3XFu0lhlOHVPdxJT7c0D8+48utPnz1MTZvy7UXqK
	fqTKtT057DPCby3SjXZVmO/Cfm6j1d4721yblFiKMxINtZiLihMBDExv8XkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAV0mjQ8BBnt62Cwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYczYufYA
	S8EhpYp7N24yNTD+kuli5OSQEDCROPppGRuELSZx4d56IJuLQ0hgEaPE1YMXWCGcyUwSjxZv
	YQSpYhPQlWh6uwvMFhGQlTh85TczSBGzwAMmidsb17GDJIQFoiVWdnWwgtgsAqoSv+78ZAGx
	eQU8JK58PMoKsU5B4s3tZ8wgNqeAp8T6TTPBhgoB1SycuIp1AiPvAkaGVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxjBgf9MegfjqgaLQ4wCHIxKPLyVmu8DhFgTy4orcw8xSnAwK4nwejF+
	CBDiTUmsrEotyo8vKs1JLT7E6AN01URmKdHkfGBU5pXEGxqbmJsam1qaWJiYWeIQVhLnZTz1
	JEBIID2xJDU7NbUgtQhmHBMHp1QDY1FeT6bOm81TL57fn7lgxnZBNhehA/MOn/98c0ejwSrx
	TNXqT2ce/OQOrNdZ89q7vzH41/u36XKXD/cnnLoultK60kb25m+zlSnKK1XLF/2YmDklUOKy
	9U9NDcu/Gqq/7b/uX97y6Pblho9nZRkKv6eIl+f/nfGhwa+L/RCT+vbvigWJaw3XzFViKc5I
	NNRiLipOBACJPq96qQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the names of usb-phy types to more generic names:
USB_PHY_TYPE_DEIVCE & USB_PHY_TYPE_HOST; and further update
its dependencies.

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from v5:
	- None

 drivers/usb/host/ehci-s5p.c         |    9 +++++----
 drivers/usb/host/ohci-exynos.c      |    9 +++++----
 include/linux/usb/samsung_usb_phy.h |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 319dcfa..46ca5ef 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
@@ -164,7 +165,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -198,7 +199,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -229,7 +230,7 @@ static int s5p_ehci_suspend(struct device *dev)
 	rc = ehci_suspend(hcd, do_wakeup);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -246,7 +247,7 @@ static int s5p_ehci_resume(struct device *dev)
 	clk_prepare_enable(s5p_ehci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index aa3b884..804fb62 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-exynos.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 struct exynos_ohci_hcd {
@@ -153,7 +154,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -184,7 +185,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -229,7 +230,7 @@ static int exynos_ohci_suspend(struct device *dev)
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -249,7 +250,7 @@ static int exynos_ohci_resume(struct device *dev)
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci_resume(hcd, false);
 
diff --git a/include/linux/usb/samsung_usb_phy.h b/include/linux/usb/samsung_usb_phy.h
new file mode 100644
index 0000000..9167826
--- /dev/null
+++ b/include/linux/usb/samsung_usb_phy.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ *		http://www.samsung.com/
+ *
+ * Defines phy types for samsung usb phy controllers - HOST or DEIVCE.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+enum samsung_usb_phy_type {
+	USB_PHY_TYPE_DEVICE,
+	USB_PHY_TYPE_HOST,
+};
-- 
1.7.6.5

