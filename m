Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3KFB1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:27:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60093 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab3KFB1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:27:52 -0500
Date: Wed, 06 Nov 2013 10:27:49 +0900
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] usb: ohci-exynos: Change to use phy provided by the generic
 phy framework
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: "'Kamil Debski'" <k.debski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Kamil Debski'" <k.debski@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <001401ceda8f$67f1ee50$37d5caf0$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac7aj1XjuAwmVu70RKaqqxDTG9Gb3A==
DLP-Filter: Pass
X-AuditID: cbfee690-b7f3d6d000001c4a-2b-52799b16ba7e
x-cr-hashedpuzzle: AOYY FEf+ M7u+ XK2A 5PeZ 5tuX 77Gn AEG1og== AGwc7g==
 AQkEWA== AU3PHA== AYiAGA== Aajlvw== AgGKow== AhMAOA==
 Aiiw4A==;18;YQB2AC4AdABpAGsAaABvAG0AaQByAG8AdgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGQAZQB2AGkAYwBlAHQAcgBlAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGcAYQBsAGEAawBAAGMAbwBkAGUAYQB1AHIAbwByAGEALgBvAHIAZwA7AGcAYQB1AHQAYQBtAC4AdgBpAHYAZQBrAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsALgBkAGUAYgBzAGsAaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAaQBzAGgAbwBuAEAAdABpAC4AYwBvAG0AOwBrAHkAdQBuAGcAbQBpAG4ALgBwAGEAcgBrAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AYQByAG0AQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBzAGEAbQBzAHUAbgBnAC0AcwBvAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHUAcwBiAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAC4AcwB6AHkAcAByAG8AdwBzAGsAaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AG0AYQB0AC4AawByAGEAdwBjAHoAd
	QBrAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBwAC4AcABhAG4AZQByAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBzAC4AbgBhAHcAcgBvAGMAawBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAdAAuAGYAaQBnAGEAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwB5AHUAbABnAG8AbgAuAGsAaQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{DF14907C-B18F-41BC-866B-84EC94F4E261};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 06 Nov 2013 01:27:19
 GMT;WwBQAEEAVABDAEgAXQAgAHUAcwBiADoAIABvAGgAYwBpAC0AZQB4AHkAbgBvAHMAOgAgAEMAaABhAG4AZwBlACAAdABvACAAdQBzAGUAIABwAGgAeQAgAHAAcgBvAHYAaQBkAGUAZAAgAGIAeQAgAHQAaABlACAAZwBlAG4AZQByAGkAYwAgAHAAaAB5ACAAZgByAGEAbQBlAHcAbwByAGsA
x-cr-puzzleid: {DF14907C-B18F-41BC-866B-84EC94F4E261}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zQ12x2ZVBBn37hC2W7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0ht1i2s7/rBaXd81hs5hxfh+TxaJlrcwW
	a4/cZbc423+bzeL8lk4mi8Nv2lkt1s94zWLRcfYgu4OQx+W+XiaPnbPusnv0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgydl7aylywSq7iyfte1gbG1ZJdjJwcEgImEmtfn2CGsMUk
	Ltxbz9bFyMUhJLCMUeLNixesMEV3+qcxgdhCAtMZJeatVIAo+sUocbV9DSNIQljAT6JpziSw
	SWwCahJfvhxmB7FFBGYySmxebApiMwtsY5FYfUMWoj5G4nDTEqB6Dg4WAVWJN1tDQcK8ArYS
	U/+sY4OwBSV+TL7HAtGqJbF+53EmCFteYvOat2CtEgLqEo/+6kJs0pPo+7GBGaJERGLfi3eM
	IGdKCLzhkbjy9TnUk6YSJz5Ogkqc4JDY83QK2P0sAgIS3yYfYoEYKiux6QBUvaTEwRU3WCYw
	Ss5CctIsJCfNQnLSLCS7FzCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQISSETdjDeO2B9
	iDEZaP1EZinR5HxgCsoriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsaFO1xdD/mbT92sq7nZaXH3v6mfryl/T2t0XKcvtC1v0/1Lk2cdf9gpe6fk
	/lWxDYvFA3setV+Qf5qh81XX5b+SScGeGcdctfrWcXMvTbAynWXYunPPMoe1ZTn7JU4YVby2
	lErfuIZ5wvbH27jf1UXYBO5TPyFxqGVDkPbewvjak5UsU5SMH0xQYinOSDTUYi4qTgQAB4ay
	RTcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoK7Y7Mogg7/dvBZLdt9gtZh/5Byr
	Rf+bhawWbVcOsltcXniJ1eLH6wtsFhee9rBZnG16w24xbed/VovLu+awWcw4v4/JYtGyVmaL
	tUfusluc7b/NZnF+SyeTxeE37awW62e8ZrHoOHuQ3UHI43JfL5PHzll32T36tqxi9Dh+YzuT
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlA5ysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM3Ze2spcsEqu4sn7
	XtYGxtWSXYycHBICJhJ3+qcxQdhiEhfurWcDsYUEpjNKzFup0MXIBWT/YpS42r6GESQhLOAn
	0TRnEjOIzSagJvHly2F2EFtEYCajxObFpiA2s8A2FonVN2Qh6mMkDjctAarn4GARUJV4szUU
	JMwrYCsx9c86NghbUOLH5HssEK1aEut3HmeCsOUlNq95C9YqIaAu8eivLsQmPYm+HxuYIUpE
	JPa9eMcIcqaEwBseiStfnzND/GIqceLjJMYJjMKzkKyYhWTFLCQrZiGZtYCRZRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcIJ6JrWDcWWDxSFGAQ5GJR7eBPnKICHWxLLiytxDjBIczEoi
	vEpxQCHelMTKqtSi/Pii0pzU4kOMycAAmMgsJZqcD0yeeSXxhsYmZkaWRmYWRibm5qQJK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeEb2h4rEDpsd9zYpfOjP35q78a7WNDbf75r76nj/
	ib/W+1Qzjan9Yn3xZW2jqa7sEW18vhO+cqq8Pu+g82lvwPbJv9zWOd/yDIg4lNvN4BBawLH4
	/YxfPLpP3ny289c0/FBz3K7PJJy9fNYmlax4tZrqCfK/JbZ+3dZj7XjszRLDj4bPDVL3K7EU
	ZyQaajEXFScCACjEP+eUAwAA
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the phy provider used from the old usb phy specific to a new one
using the generic phy framework.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
Exynos OHCI driver also uses Exynos USB2.0 PHY. Thus, I make this
patch based-on Kamil Debski's patchset for adding Exynos USB 2.0 PHY
driver.
(http://www.spinics.net/lists/linux-samsung-soc/msg24104.html)

 drivers/usb/host/ohci-exynos.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index a87baed..76eb4d3 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -17,12 +17,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <linux/usb/otg.h>
 
 #include "ohci.h"
 
@@ -35,8 +35,7 @@ static struct hc_driver __read_mostly exynos_ohci_hc_driver;
 
 struct exynos_ohci_hcd {
 	struct clk *clk;
-	struct usb_phy *phy;
-	struct usb_otg *otg;
+	struct phy *phy;
 };
 
 static void exynos_ohci_phy_enable(struct platform_device *pdev)
@@ -45,7 +44,7 @@ static void exynos_ohci_phy_enable(struct platform_device *pdev)
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 
 	if (exynos_ohci->phy)
-		usb_phy_init(exynos_ohci->phy);
+		phy_power_on(exynos_ohci->phy);
 }
 
 static void exynos_ohci_phy_disable(struct platform_device *pdev)
@@ -54,7 +53,7 @@ static void exynos_ohci_phy_disable(struct platform_device *pdev)
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 
 	if (exynos_ohci->phy)
-		usb_phy_shutdown(exynos_ohci->phy);
+		phy_power_off(exynos_ohci->phy);
 }
 
 static int exynos_ohci_probe(struct platform_device *pdev)
@@ -62,7 +61,8 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct resource *res;
-	struct usb_phy *phy;
+	struct phy *phy;
+	const char *phy_name;
 	int irq;
 	int err;
 
@@ -89,14 +89,14 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 					"samsung,exynos5440-ohci"))
 		goto skip_phy;
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
+	phy =  devm_phy_get(&pdev->dev, phy_name);
 	if (IS_ERR(phy)) {
 		usb_put_hcd(hcd);
 		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
 		return -EPROBE_DEFER;
 	} else {
 		exynos_ohci->phy = phy;
-		exynos_ohci->otg = phy->otg;
 	}
 
 skip_phy:
@@ -135,9 +135,6 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	platform_set_drvdata(pdev, hcd);
 
 	exynos_ohci_phy_enable(pdev);
@@ -165,9 +162,6 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(pdev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -210,9 +204,6 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(pdev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -231,9 +222,6 @@ static int exynos_ohci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_enable(pdev);
 
 	ohci_resume(hcd, false);
-- 
1.7.10.4


