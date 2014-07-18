Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbaGRLkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25725 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaGRLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:06 -0400
X-AuditID: cbfee61a-f79e46d00000134f-e1-53c90795c805
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 05/12] usb: dwc2/gadget: hide some not really needed debug
 messages
Date: Fri, 18 Jul 2014 13:39:30 +0200
Message-id: <1405683577-11226-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd2p7CeDDR6f57KY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CV8XPlLcaCOZwVe2ZfZ2tgfMDexcjJISFgIjFh6QFGCFtM
	4sK99WxdjFwcQgKLGCXuX53MApIQEmhnkpi5HcxmE9CR2PJ9AliDiICAxPoXl9hBGpgFTjBK
	dPy/wAaSEBaIkOjtngJWxCKgKnHxzEqwbbwCrhIPjxxggdgmJ3Hy2GRWEJtTwE2i7dF/oDgH
	0DJXiWlf+Scw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxcz6R2MK5ssDjEKMDB
	qMTDa3HzeLAQa2JZcWXuIUYJDmYlEd7s+0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjFUXPPe47E2ddCNhg7D6fxWVlp1lFtHMVz1VGVvrHDu9s9Zl
	G1ywumQZntT5NvWa5vkZhzdnP7gxr/WzyIGlOSnfXW6vP/75LbfK4Y+/VRxfHJd55y8uq/V6
	igKb0jzWpsQg7VCPwNuZ106dVd43seSxu8sDprzF4evYvNamFIol/PdYmNuZosRSnJFoqMVc
	VJwIABa0MOoqAgAA
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

