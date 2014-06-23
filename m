Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaFWHx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:53:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19275 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaFWHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:53:26 -0400
X-AuditID: cbfee61b-f79f86d00000144c-4c-53a7dcf4fa2d
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 05/11] usb: dwc2/gadget: hide some not really needed debug
 messages
Date: Mon, 23 Jun 2014 09:51:24 +0200
Message-id: <1403509890-14103-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0vd5YHGzz5KGUx62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbbJ8yncniweGd7A4cHvvnrmH36NuyitFjy/7PjB7Hb2xn
	8vi8SS6ANYrLJiU1J7MstUjfLoEr4+fKW4wFczgr9sy+ztbA+IC9i5GTQ0LARGLbml+MELaY
	xIV769m6GLk4hASmM0pcW/6QFcJpZ5JYeOgnWAebgI7Elu8TwDpEBAQk1r+4xA5SxCxwglGi
	4/8FNpCEsECoRPPhJcwgNouAqsTkid/A4rwCrhIfz3xkhVgnJ3Hy2GQwm1PATWL9zYVgC4SA
	ahadnsY+gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgAHsmvYNxVYPFIUYBDkYl
	Hl4Nt+XBQqyJZcWVuYcYJTiYlUR4GxuAQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmk
	J5akZqemFqQWwWSZODilGhjLhW/7VwZHcTcfXOZ9VEr/t/6pR9UMM/NbVZ9I/HwYe+2TZ+S0
	BbYNnR2a8R3mv5Y6F9XxOFpx7z+cpWbZ/zhvYu83C4ENHy8u5/0Z8126wqz0QFCI4vWmMvet
	b9rnXRdzus3f65Ww/KBMRrntREYpjrjUCRNr5B9s49sq/2VW3s3/Ba+PXlNiKc5INNRiLipO
	BAAg6VoaLAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

Some DWC2/s3c-hsotg debug messages are really useless for typical user,
so hide them behind dev_dbg().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 35b4890..95b6dcb 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2568,7 +2568,7 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 	u32 epctrl_reg;
 	u32 ctrl;
 
-	dev_info(hsotg->dev, "%s(ep %p)\n", __func__, ep);
+	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
 	if (ep == &hsotg->eps[0].ep) {
 		dev_err(hsotg->dev, "%s: called for ep0\n", __func__);
@@ -2626,7 +2626,7 @@ static int s3c_hsotg_ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 	struct s3c_hsotg *hs = hs_ep->parent;
 	unsigned long flags;
 
-	dev_info(hs->dev, "ep_dequeue(%p,%p)\n", ep, req);
+	dev_dbg(hs->dev, "ep_dequeue(%p,%p)\n", ep, req);
 
 	spin_lock_irqsave(&hs->lock, flags);
 
-- 
1.9.1

