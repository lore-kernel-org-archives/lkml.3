Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaKDCZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:25:33 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39360 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaKDCZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:28 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 20/27] host: xhci-plat: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:27 +0530
Message-Id: <1415067694-9473-21-git-send-email-varkabhadram@gmail.com>
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
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/xhci-plat.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 3d78b0c..e68b4ec 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -83,9 +83,6 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -ENODEV;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 
 	if (of_device_is_compatible(pdev->dev.of_node,
 				    "marvell,armada-375-xhci") ||
@@ -109,15 +106,16 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
 		goto put_hcd;
 	}
 
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
 	/*
 	 * Not all platforms have a clk so it is not an error if the
 	 * clock does not exists.
-- 
1.7.9.5

