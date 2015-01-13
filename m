Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbbAMJzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:55:06 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:42624 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbbAMJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:55:03 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] usb/gadget/net2280: Dont use 0 as NULL pointer
Date: Tue, 13 Jan 2015 10:54:58 +0100
Message-Id: <1421142898-24463-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning

Fixes: cb442ee1592d2681 (usb: gadget: udc: net2280: Re-enable dynamic debug messages)
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index d2fabdc..6411ed8 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2287,7 +2287,7 @@ static void handle_ep_small(struct net2280_ep *ep)
 	ep->irqs++;
 
 	ep_vdbg(ep->dev, "%s ack ep_stat %08x, req %p\n",
-			ep->ep.name, t, req ? &req->req : 0);
+			ep->ep.name, t, req ? &req->req : NULL);
 
 	if (!ep->is_in || (ep->dev->quirks & PLX_2280))
 		writel(t & ~BIT(NAK_OUT_PACKETS), &ep->regs->ep_stat);
-- 
2.1.4

