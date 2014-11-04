Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaKDC3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:29:00 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47935 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaKDCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:07 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 15/27] host: ehci-mxc: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:22 +0530
Message-Id: <1415067694-9473-16-git-send-email-varkabhadram@gmail.com>
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
 drivers/usb/host/ehci-mxc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index dbe5e4e..c7a9b31 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -69,20 +69,13 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Found HC with no register addr. Check setup!\n");
-		ret = -ENODEV;
-		goto err_alloc;
-	}
-
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
 		goto err_alloc;
 	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	hcd->has_tt = 1;
 	ehci = hcd_to_ehci(hcd);
-- 
1.7.9.5

