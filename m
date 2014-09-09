Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaIIIs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:48:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51236 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaIIIpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:19 -0400
X-AuditID: cbfee61a-f79e46d00000134f-16-540ebe1dc883
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3/6] usb: dwc2/gadget: hide some not really needed debug
 messages
Date: Tue, 09 Sep 2014 10:44:54 +0200
Message-id: <1410252297-13738-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQV3ZfXwhBhdPmVocvF9v0bx4PZvF
	5V1z2CwWLWtltlh75C67xaOHW1ktHhzeye7A7rF/7hp2j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4MvY828FSMIezou+4fQPjA/YuRk4OCQETiZ1tF9kgbDGJC/fWA9lc
	HEIC0xklTpx9wg7htDNJrHp0mRmkik1AR2LL9wmMILaIgLzE9Y03WUCKmAX2MUpM/7QNbKyw
	QLDE9I2NLCA2i4CqRMv002BxXgFXiUtL1rNArJOTOHlsMiuIzSngJvHn2BewGiGgmn9zprFM
	YORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4qJ5J7WBc2WBxiFGAg1GJhzcjmC9E
	iDWxrLgy9xCjBAezkgjvld1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NT
	C1KLYLJMHJxSDYyB2tKLK8Pi9iRJmzy4k6Zr++L9OyF5JYcJtTF7/u9a+CJ64k9N38rrAk/k
	rh36mfLlxY1MyW3RbbncRy18/eN0Y1e+Nit89PpsjEzR/zV395w8EF292o1F6lE/t9G/VMtf
	/27MN9lrtrfp4Gn2AM2TOxRfTz241f/jvL9Vk9Mqp7+br7un9Z6GEktxRqKhFnNRcSIAbxDj
	gSYCAAA=
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
index 186a3a8..f63858a 100644
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

