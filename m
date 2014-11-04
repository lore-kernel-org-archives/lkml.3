Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaKDCZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:25:09 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59188 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaKDCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:03 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 14/27] host: ehci-mv: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:21 +0530
Message-Id: <1415067694-9473-15-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-mv.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index b1855c1..849806a 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -169,12 +169,6 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	}
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phyregs");
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no phy I/O memory resource defined\n");
-		retval = -ENODEV;
-		goto err_put_hcd;
-	}
-
 	ehci_mv->phy_regs = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(ehci_mv->phy_regs)) {
 		retval = PTR_ERR(ehci_mv->phy_regs);
@@ -182,12 +176,6 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	}
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "capregs");
-	if (!r) {
-		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		retval = -ENODEV;
-		goto err_put_hcd;
-	}
-
 	ehci_mv->cap_regs = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(ehci_mv->cap_regs)) {
 		retval = PTR_ERR(ehci_mv->cap_regs);
-- 
1.7.9.5

