Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHSI6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:58:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15023 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaHSI6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:58:05 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6e-53f3119bb0e5
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 05/12] usb: dwc2/gadget: hide some not really needed
 debug messages
Date: Tue, 19 Aug 2014 10:54:11 +0200
Message-id: <1408438458-3317-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3Zgp+DDVY/VLSY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHj3cymrx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVMXXZAfaCOZwV6+Y2MzUwPmDvYuTkkBAwkXi1/DYThC0m
	ceHeerYuRi4OIYHpjBKXLz5ignDamSRmTtgK1sEmoCOx5fsERhBbREBe4vrGmywgRcwChxgl
	Xt05BjZKWCBeouvObWYQm0VAVeLk0V9gzbwCLhJ/Xy9mhlgnJ3Hy2GRWEJtTwFXi7b5ZYDVC
	QDWbW8+wTWDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOMCeSe9gXNVgcYhRgINR
	iYdX4cvHYCHWxLLiylygaziYlUR4HV98ChbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBI
	ID2xJDU7NbUgtQgmy8TBKdXAaMzg7aNRobbMI917u/rZM1Z34t59nf//weW9i10Pc6a8nb9z
	6krGTTdLO3U0j9ayBx3n00+RynkS+uX8LO2bqYrda1PusxRdC5rTatpwaJv3MY2L4V/uBkbJ
	2HnKxea4LP8deD7JrPiB0LeCVhs+KaXqHypis0ocpYLWKO0MfWH35njCkfn3lViKMxINtZiL
	ihMBGjDBOSwCAAA=
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
index 8131ccd..6d20ae9 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2567,7 +2567,7 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 	u32 epctrl_reg;
 	u32 ctrl;
 
-	dev_info(hsotg->dev, "%s(ep %p)\n", __func__, ep);
+	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
 	if (ep == &hsotg->eps[0].ep) {
 		dev_err(hsotg->dev, "%s: called for ep0\n", __func__);
@@ -2625,7 +2625,7 @@ static int s3c_hsotg_ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 	struct s3c_hsotg *hs = hs_ep->parent;
 	unsigned long flags;
 
-	dev_info(hs->dev, "ep_dequeue(%p,%p)\n", ep, req);
+	dev_dbg(hs->dev, "ep_dequeue(%p,%p)\n", ep, req);
 
 	spin_lock_irqsave(&hs->lock, flags);
 
-- 
1.9.1

