Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaEBMsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:48:06 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43043 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEBMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:48:03 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3 2/4] usb: ehci-exynos: Use struct device instead of platform_device
Date: Fri,  2 May 2014 18:17:33 +0530
Message-Id: <1399034855-9686-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
References: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to use struct device instead of struct platform_device
for some static functions.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---

Changes from v2:
 - none

 drivers/usb/host/ehci-exynos.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 7f425ac..4d763dc 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -50,9 +50,8 @@ struct exynos_ehci_hcd {
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
 
-static void exynos_setup_vbus_gpio(struct platform_device *pdev)
+static void exynos_setup_vbus_gpio(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
 	int err;
 	int gpio;
 
@@ -88,7 +87,7 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	exynos_setup_vbus_gpio(pdev);
+	exynos_setup_vbus_gpio(&pdev->dev);
 
 	hcd = usb_create_hcd(&exynos_ehci_hc_driver,
 			     &pdev->dev, dev_name(&pdev->dev));
-- 
1.7.10.4

