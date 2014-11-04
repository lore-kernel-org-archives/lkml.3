Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaKDCZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:25:22 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45553 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKDCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:15 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 17/27] host: ehci-orion: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:24 +0530
Message-Id: <1415067694-9473-18-git-send-email-varkabhadram@gmail.com>
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
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/ehci-orion.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 22e15ca..36b4657 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -175,15 +175,6 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		err = -ENODEV;
-		goto err;
-	}
-
 	/*
 	 * Right now device-tree probed devices don't get dma_mask
 	 * set. Since shared usb code relies on it, set it here for
@@ -193,6 +184,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	if (err)
 		goto err;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs)) {
 		err = PTR_ERR(regs);
-- 
1.7.9.5

