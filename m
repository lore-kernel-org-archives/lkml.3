Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaKDCWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:22:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61390 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaKDCWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:22:02 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 01/27] host: ehci-atmel: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:08 +0530
Message-Id: <1415067694-9473-2-git-send-email-varkabhadram@gmail.com>
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
 drivers/usb/host/ehci-atmel.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index ec9f7b7..56a8850 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -107,22 +107,15 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		retval = -ENODEV;
-		goto fail_request_resource;
-	}
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		retval = PTR_ERR(hcd->regs);
 		goto fail_request_resource;
 	}
 
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
 	iclk = devm_clk_get(&pdev->dev, "ehci_clk");
 	if (IS_ERR(iclk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
-- 
1.7.9.5

