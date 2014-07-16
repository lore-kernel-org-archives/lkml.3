Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbaGPKZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:25:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbaGPKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:06 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7d-53c6528557f6
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 05/12] usb: dwc2/gadget: hide some not really needed debug
 messages
Date: Wed, 16 Jul 2014 12:22:23 +0200
Message-id: <1405506150-16185-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3WoGPBBi/2mVjMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK+LnyFmPBHM6KPbOvszUwPmDvYuTgkBAwkZj2hquLkRPI
	FJO4cG89WxcjF4eQwHRGiZ/7+tkhnHYmiSsLPrCAVLEJ6Ehs+T6BEcQWERCQWP/iElgRs8AJ
	RomO/xfYQBLCAhESV7fcB2tgEVCVOHyplxnE5hVwlTi36yQjxDo5iZPHJrOC2JwCbhJrXjez
	g9hCQDXH1y1jmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHg9k9rBuLLB4hCj
	AAejEg/vhpCjwUKsiWXFlbmHGCU4mJVEeB38jwUL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Q
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYEy68vip4dKiC669W0XqZ188q+BZXbDmcldco/ibjli7
	PXFF1yucSnOSGD+9b/Zj2Tdlo8Gb5q+Cu0WOr1uxxf+2ZlvttNmlR7cz/VDbe+CA9vIbjyrY
	Fxy8YTZj1pcA9zdCtzXqvfobCo81/5gXzdiUE73to3iIzI369RfC13eJfY+f9VztVKgSS3FG
	oqEWc1FxIgARaXpNKwIAAA==
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

