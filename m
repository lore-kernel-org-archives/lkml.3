Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaKDCWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:22:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49165 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaKDCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:22:17 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 02/27] host: ohci-da8xx: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:09 +0530
Message-Id: <1415067694-9473-3-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-da8xx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
index df06be6..1c76999 100644
--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -313,16 +313,13 @@ static int usb_hcd_da8xx_probe(const struct hc_driver *driver,
 		return -ENOMEM;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem)
-		return -ENODEV;
-	hcd->rsrc_start = mem->start;
-	hcd->rsrc_len = resource_size(mem);
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(hcd->regs)) {
 		error = PTR_ERR(hcd->regs);
 		goto err;
 	}
+	hcd->rsrc_start = mem->start;
+	hcd->rsrc_len = resource_size(mem);
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-- 
1.7.9.5

