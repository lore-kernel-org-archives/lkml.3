Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaKDBsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:48:24 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56528 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaKDBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:47:49 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 2/2] host: ehci-sead3: fix NULL pointer dereference on resource
Date: Tue,  4 Nov 2014 07:17:11 +0530
Message-Id: <1415065631-6010-3-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415065631-6010-1-git-send-email-varkabhadram@gmail.com>
References: <N>
 <1415065631-6010-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Fix on accessing NULL pointer dereference on get resource failed.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-sead3.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-sead3.c b/drivers/usb/host/ehci-sead3.c
index cf12676..9b6e8d0 100644
--- a/drivers/usb/host/ehci-sead3.c
+++ b/drivers/usb/host/ehci-sead3.c
@@ -110,14 +110,13 @@ static int ehci_hcd_sead3_drv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
 		goto err1;
 	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	/* Root hub has integrated TT. */
 	hcd->has_tt = 1;
-- 
1.7.9.5

