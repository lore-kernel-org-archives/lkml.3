Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaK1NvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:21 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:44970 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaK1NvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:16 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] net2280: Remove field is_halt
Date: Fri, 28 Nov 2014 14:50:53 +0100
Message-Id: <1417182662-7405-9-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Field is_halt is never used by any function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 6 +-----
 drivers/usb/gadget/udc/net2280.h | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 653a8a2..48e8d82 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2643,7 +2643,6 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 		       /* BIT(SET_NAK_PACKETS) | */
 		       BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
 		       &ep->regs->ep_rsp);
-		ep->is_halt = 1;
 	} else {
 		if (dev->gadget.speed == USB_SPEED_SUPER) {
 			/*
@@ -2663,7 +2662,6 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 		writel(val,
 		       /* | BIT(CLEAR_NAK_PACKETS),*/
 		       &ep->regs->ep_rsp);
-		ep->is_halt = 0;
 		val = readl(&ep->regs->ep_rsp);
 	}
 }
@@ -2924,9 +2922,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 		}
 		ep->stopped = 0;
 		dev->protocol_stall = 0;
-		if (dev->quirks & PLX_SUPERSPEED)
-			ep->is_halt = 0;
-		else{
+		if (!(dev->quirks & PLX_SUPERSPEED)) {
 			if (ep->dev->quirks & PLX_2280)
 				tmp = BIT(FIFO_OVERFLOW) |
 				    BIT(FIFO_UNDERFLOW);
diff --git a/drivers/usb/gadget/udc/net2280.h b/drivers/usb/gadget/udc/net2280.h
index 4c53b83..a16494a 100644
--- a/drivers/usb/gadget/udc/net2280.h
+++ b/drivers/usb/gadget/udc/net2280.h
@@ -100,7 +100,6 @@ struct net2280_ep {
 	dma_addr_t				td_dma;	/* of dummy */
 	struct net2280				*dev;
 	unsigned long				irqs;
-	unsigned is_halt:1;
 
 	/* analogous to a host-side qh */
 	struct list_head			queue;
-- 
2.1.3

