Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3CJNw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:52:28 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35357 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3CJNw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:52:26 -0400
From: Paul Vlase <vlase.paul@gmail.com>
To: stern@rowland.harvard.edu
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Vlase <vlase.paul@gmail.com>
Subject: [PATCH] usb: Use resource_size function
Date: Sun, 10 Mar 2013 15:52:02 +0200
Message-Id: <1362923522-20842-1-git-send-email-vlase.paul@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Vlase <vlase.paul@gmail.com>
---
 drivers/usb/host/ehci-mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 3065809..5cd9f96 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -225,7 +225,7 @@ static int mv_ehci_probe(struct platform_device *pdev)
 		(void __iomem *) ((unsigned long) ehci_mv->cap_regs + offset);
 
 	hcd->rsrc_start = r->start;
-	hcd->rsrc_len = r->end - r->start + 1;
+	hcd->rsrc_len = resource_size(r);
 	hcd->regs = ehci_mv->op_regs;
 
 	hcd->irq = platform_get_irq(pdev, 0);
-- 
1.7.10.4

