Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKDCWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:22:44 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51803 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaKDCWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:22:39 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 10/27] host: ohci-pxa27x: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:17 +0530
Message-Id: <1415067694-9473-11-git-send-email-varkabhadram@gmail.com>
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
 drivers/usb/host/ohci-pxa27x.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index e68f3d0..1339981 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -447,20 +447,13 @@ int usb_hcd_pxa27x_probe (const struct hc_driver *driver, struct platform_device
 		return -ENOMEM;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		pr_err("no resource of IORESOURCE_MEM");
-		retval = -ENXIO;
-		goto err;
-	}
-
-	hcd->rsrc_start = r->start;
-	hcd->rsrc_len = resource_size(r);
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(hcd->regs)) {
 		retval = PTR_ERR(hcd->regs);
 		goto err;
 	}
+	hcd->rsrc_start = r->start;
+	hcd->rsrc_len = resource_size(r);
 
 	/* initialize "struct pxa27x_ohci" */
 	pxa_ohci = to_pxa27x_ohci(hcd);
-- 
1.7.9.5

