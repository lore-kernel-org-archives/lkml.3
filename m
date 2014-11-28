Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaK1Nvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:42 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45476 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaK1Nv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:26 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] net2280: Re-enable dynamic debug messages
Date: Fri, 28 Nov 2014 14:51:02 +0100
Message-Id: <1417182662-7405-18-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debug messages were not build due to unconditional #if 0.

These messages are very useful for debugging and the user can enable
them on demand via dynamic debug.

If they are not enabled the performance is not affected.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index b1c253e..d2fabdc 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -927,10 +927,8 @@ net2280_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 			return ret;
 	}
 
-#if 0
 	ep_vdbg(dev, "%s queue req %p, len %d buf %p\n",
 			_ep->name, _req, _req->length, _req->buf);
-#endif
 
 	spin_lock_irqsave(&dev->lock, flags);
 
@@ -2287,10 +2285,10 @@ static void handle_ep_small(struct net2280_ep *ep)
 	/* ack all, and handle what we care about */
 	t = readl(&ep->regs->ep_stat);
 	ep->irqs++;
-#if 0
+
 	ep_vdbg(ep->dev, "%s ack ep_stat %08x, req %p\n",
 			ep->ep.name, t, req ? &req->req : 0);
-#endif
+
 	if (!ep->is_in || (ep->dev->quirks & PLX_2280))
 		writel(t & ~BIT(NAK_OUT_PACKETS), &ep->regs->ep_stat);
 	else
-- 
2.1.3

