Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaESKL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:11:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45807 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaESKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:10:13 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/5] usb: gadget: net2280: Use BIT() macro
Date: Mon, 19 May 2014 12:10:03 +0200
Message-Id: <1400494205-26566-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improves readability of the code

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 572 +++++++++++++++++++++----------------------
 drivers/usb/gadget/net2280.h |  65 ++---
 2 files changed, 318 insertions(+), 319 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index ba1fdd8..5b9368d 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -144,8 +144,8 @@ static char *type_string (u8 bmAttributes)
 
 #include "net2280.h"
 
-#define valid_bit	cpu_to_le32 (1 << VALID_BIT)
-#define dma_done_ie	cpu_to_le32 (1 << DMA_DONE_INTERRUPT_ENABLE)
+#define valid_bit	cpu_to_le32(BIT(VALID_BIT))
+#define dma_done_ie	cpu_to_le32(BIT(DMA_DONE_INTERRUPT_ENABLE))
 
 /*-------------------------------------------------------------------------*/
 static inline void enable_pciirqenb(struct net2280_ep *ep)
@@ -153,9 +153,9 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
 	u32 tmp = readl(&ep->dev->regs->pciirqenb0);
 
 	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
-		tmp |= 1 << ep->num;
+		tmp |= BIT(ep->num);
 	else
-		tmp |= 1 << ep_bit[ep->num];
+		tmp |= BIT(ep_bit[ep->num]);
 	writel(tmp, &ep->dev->regs->pciirqenb0);
 
 	return;
@@ -218,14 +218,14 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	}
 
 	/* set type, direction, address; reset fifo counters */
-	writel ((1 << FIFO_FLUSH), &ep->regs->ep_stat);
+	writel(BIT(FIFO_FLUSH), &ep->regs->ep_stat);
 	tmp = (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
 	if (tmp == USB_ENDPOINT_XFER_INT) {
 		/* erratum 0105 workaround prevents hs NYET */
 		if (dev->chiprev == 0100
 				&& dev->gadget.speed == USB_SPEED_HIGH
 				&& !(desc->bEndpointAddress & USB_DIR_IN))
-			writel ((1 << CLEAR_NAK_OUT_PACKETS_MODE),
+			writel(BIT(CLEAR_NAK_OUT_PACKETS_MODE),
 				&ep->regs->ep_rsp);
 	} else if (tmp == USB_ENDPOINT_XFER_BULK) {
 		/* catch some particularly blatant driver bugs */
@@ -243,18 +243,18 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		tmp |= desc->bEndpointAddress;
 		/* default full fifo lines */
 		tmp |= (4 << ENDPOINT_BYTE_COUNT);
-		tmp |= 1 << ENDPOINT_ENABLE;
+		tmp |= BIT(ENDPOINT_ENABLE);
 		ep->is_in = (tmp & USB_DIR_IN) != 0;
 	} else {
 		/* In Legacy mode, only OUT endpoints are used */
 		if (dev->enhanced_mode && ep->is_in) {
 			tmp <<= IN_ENDPOINT_TYPE;
-			tmp |= (1 << IN_ENDPOINT_ENABLE);
+			tmp |= BIT(IN_ENDPOINT_ENABLE);
 			/* Not applicable to Legacy */
-			tmp |= (1 << ENDPOINT_DIRECTION);
+			tmp |= BIT(ENDPOINT_DIRECTION);
 		} else {
 			tmp <<= OUT_ENDPOINT_TYPE;
-			tmp |= (1 << OUT_ENDPOINT_ENABLE);
+			tmp |= BIT(OUT_ENDPOINT_ENABLE);
 			tmp |= (ep->is_in << ENDPOINT_DIRECTION);
 		}
 
@@ -267,13 +267,13 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 
 	/* for OUT transfers, block the rx fifo until a read is posted */
 	if (!ep->is_in)
-		writel ((1 << SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
+		writel(BIT(SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 	else if (dev->pdev->device != 0x2280) {
 		/* Added for 2282, Don't use nak packets on an in endpoint,
 		 * this was ignored on 2280
 		 */
-		writel ((1 << CLEAR_NAK_OUT_PACKETS)
-			| (1 << CLEAR_NAK_OUT_PACKETS_MODE), &ep->regs->ep_rsp);
+		writel(BIT(CLEAR_NAK_OUT_PACKETS) |
+			BIT(CLEAR_NAK_OUT_PACKETS_MODE), &ep->regs->ep_rsp);
 	}
 
 	writel(tmp, &ep->cfg->ep_cfg);
@@ -282,13 +282,13 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	if (!ep->dma) {				/* pio, per-packet */
 		enable_pciirqenb(ep);
 
-		tmp = (1 << DATA_PACKET_RECEIVED_INTERRUPT_ENABLE)
-			| (1 << DATA_PACKET_TRANSMITTED_INTERRUPT_ENABLE);
+		tmp = BIT(DATA_PACKET_RECEIVED_INTERRUPT_ENABLE) |
+			BIT(DATA_PACKET_TRANSMITTED_INTERRUPT_ENABLE);
 		if (dev->pdev->device == 0x2280)
 			tmp |= readl (&ep->regs->ep_irqenb);
 		writel (tmp, &ep->regs->ep_irqenb);
 	} else {				/* dma, per-request */
-		tmp = (1 << (8 + ep->num));	/* completion */
+		tmp = BIT((8 + ep->num));	/* completion */
 		tmp |= readl (&dev->regs->pciirqenb1);
 		writel (tmp, &dev->regs->pciirqenb1);
 
@@ -297,7 +297,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		 * NOTE erratum 0112 workaround #2
 		 */
 		if ((desc->bEndpointAddress & USB_DIR_IN) == 0) {
-			tmp = (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
+			tmp = BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
 			writel (tmp, &ep->regs->ep_irqenb);
 
 			enable_pciirqenb(ep);
@@ -348,17 +348,17 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 	/* disable the dma, irqs, endpoint... */
 	if (ep->dma) {
 		writel (0, &ep->dma->dmactl);
-		writel (  (1 << DMA_SCATTER_GATHER_DONE_INTERRUPT)
-			| (1 << DMA_TRANSACTION_DONE_INTERRUPT)
-			| (1 << DMA_ABORT)
-			, &ep->dma->dmastat);
+		writel(BIT(DMA_SCATTER_GATHER_DONE_INTERRUPT) |
+			BIT(DMA_TRANSACTION_DONE_INTERRUPT) |
+			BIT(DMA_ABORT),
+			&ep->dma->dmastat);
 
 		tmp = readl (&regs->pciirqenb0);
-		tmp &= ~(1 << ep->num);
+		tmp &= ~BIT(ep->num);
 		writel (tmp, &regs->pciirqenb0);
 	} else {
 		tmp = readl (&regs->pciirqenb1);
-		tmp &= ~(1 << (8 + ep->num));	/* completion */
+		tmp &= ~BIT((8 + ep->num));	/* completion */
 		writel (tmp, &regs->pciirqenb1);
 	}
 	writel (0, &ep->regs->ep_irqenb);
@@ -367,44 +367,44 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 	 * packets until the driver queues a read (+note erratum 0112)
 	 */
 	if (!ep->is_in || ep->dev->pdev->device == 0x2280) {
-		tmp = (1 << SET_NAK_OUT_PACKETS_MODE)
-		| (1 << SET_NAK_OUT_PACKETS)
-		| (1 << CLEAR_EP_HIDE_STATUS_PHASE)
-		| (1 << CLEAR_INTERRUPT_MODE);
+		tmp = BIT(SET_NAK_OUT_PACKETS_MODE) |
+		BIT(SET_NAK_OUT_PACKETS) |
+		BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
+		BIT(CLEAR_INTERRUPT_MODE);
 	} else {
 		/* added for 2282 */
-		tmp = (1 << CLEAR_NAK_OUT_PACKETS_MODE)
-		| (1 << CLEAR_NAK_OUT_PACKETS)
-		| (1 << CLEAR_EP_HIDE_STATUS_PHASE)
-		| (1 << CLEAR_INTERRUPT_MODE);
+		tmp = BIT(CLEAR_NAK_OUT_PACKETS_MODE) |
+		BIT(CLEAR_NAK_OUT_PACKETS) |
+		BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
+		BIT(CLEAR_INTERRUPT_MODE);
 	}
 
 	if (ep->num != 0) {
-		tmp |= (1 << CLEAR_ENDPOINT_TOGGLE)
-			| (1 << CLEAR_ENDPOINT_HALT);
+		tmp |= BIT(CLEAR_ENDPOINT_TOGGLE) |
+			BIT(CLEAR_ENDPOINT_HALT);
 	}
 	writel (tmp, &ep->regs->ep_rsp);
 
 	/* scrub most status bits, and flush any fifo state */
 	if (ep->dev->pdev->device == 0x2280)
-		tmp = (1 << FIFO_OVERFLOW)
-			| (1 << FIFO_UNDERFLOW);
+		tmp = BIT(FIFO_OVERFLOW) |
+			BIT(FIFO_UNDERFLOW);
 	else
 		tmp = 0;
 
-	writel (tmp | (1 << TIMEOUT)
-		| (1 << USB_STALL_SENT)
-		| (1 << USB_IN_NAK_SENT)
-		| (1 << USB_IN_ACK_RCVD)
-		| (1 << USB_OUT_PING_NAK_SENT)
-		| (1 << USB_OUT_ACK_SENT)
-		| (1 << FIFO_FLUSH)
-		| (1 << SHORT_PACKET_OUT_DONE_INTERRUPT)
-		| (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT)
-		| (1 << DATA_PACKET_RECEIVED_INTERRUPT)
-		| (1 << DATA_PACKET_TRANSMITTED_INTERRUPT)
-		| (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
-		| (1 << DATA_IN_TOKEN_INTERRUPT)
+	writel(tmp | BIT(TIMEOUT) |
+		BIT(USB_STALL_SENT) |
+		BIT(USB_IN_NAK_SENT) |
+		BIT(USB_IN_ACK_RCVD) |
+		BIT(USB_OUT_PING_NAK_SENT) |
+		BIT(USB_OUT_ACK_SENT) |
+		BIT(FIFO_FLUSH) |
+		BIT(SHORT_PACKET_OUT_DONE_INTERRUPT) |
+		BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT) |
+		BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
+		BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
+		BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+		BIT(DATA_IN_TOKEN_INTERRUPT)
 		, &ep->regs->ep_stat);
 
 	/* fifo size is handled separately */
@@ -424,11 +424,11 @@ static void ep_reset_338x(struct net2280_regs __iomem *regs,
 	/* disable the dma, irqs, endpoint... */
 	if (ep->dma) {
 		writel(0, &ep->dma->dmactl);
-		writel((1 << DMA_ABORT_DONE_INTERRUPT) |
-		       (1 << DMA_PAUSE_DONE_INTERRUPT) |
-		       (1 << DMA_SCATTER_GATHER_DONE_INTERRUPT) |
-		       (1 << DMA_TRANSACTION_DONE_INTERRUPT)
-		       /* | (1 << DMA_ABORT) */
+		writel(BIT(DMA_ABORT_DONE_INTERRUPT) |
+		       BIT(DMA_PAUSE_DONE_INTERRUPT) |
+		       BIT(DMA_SCATTER_GATHER_DONE_INTERRUPT) |
+		       BIT(DMA_TRANSACTION_DONE_INTERRUPT)
+		       /* | BIT(DMA_ABORT) */
 		       , &ep->dma->dmastat);
 
 		dmastat = readl(&ep->dma->dmastat);
@@ -439,24 +439,24 @@ static void ep_reset_338x(struct net2280_regs __iomem *regs,
 		}
 
 		tmp = readl(&regs->pciirqenb0);
-		tmp &= ~(1 << ep_bit[ep->num]);
+		tmp &= ~BIT(ep_bit[ep->num]);
 		writel(tmp, &regs->pciirqenb0);
 	} else {
 		if (ep->num < 5) {
 			tmp = readl(&regs->pciirqenb1);
-			tmp &= ~(1 << (8 + ep->num));	/* completion */
+			tmp &= ~BIT((8 + ep->num));	/* completion */
 			writel(tmp, &regs->pciirqenb1);
 		}
 	}
 	writel(0, &ep->regs->ep_irqenb);
 
-	writel((1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
-	       (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
-	       (1 << FIFO_OVERFLOW) |
-	       (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
-	       (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
-	       (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
-	       (1 << DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
+	writel(BIT(SHORT_PACKET_OUT_DONE_INTERRUPT) |
+	       BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT) |
+	       BIT(FIFO_OVERFLOW) |
+	       BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
+	       BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
+	       BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+	       BIT(DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
 }
 
 static void nuke (struct net2280_ep *);
@@ -621,20 +621,20 @@ static void out_flush (struct net2280_ep *ep)
 	ASSERT_OUT_NAKING (ep);
 
 	statp = &ep->regs->ep_stat;
-	writel (  (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
-		| (1 << DATA_PACKET_RECEIVED_INTERRUPT)
+	writel(BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+		BIT(DATA_PACKET_RECEIVED_INTERRUPT)
 		, statp);
-	writel ((1 << FIFO_FLUSH), statp);
+	writel(BIT(FIFO_FLUSH), statp);
 	mb ();
 	tmp = readl (statp);
-	if (tmp & (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
+	if (tmp & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)
 			/* high speed did bulk NYET; fifo isn't filling */
 			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
 		unsigned	usec;
 
 		usec = 50;		/* 64 byte bulk/interrupt */
-		handshake (statp, (1 << USB_OUT_PING_NAK_SENT),
-				(1 << USB_OUT_PING_NAK_SENT), usec);
+		handshake(statp, BIT(USB_OUT_PING_NAK_SENT),
+				BIT(USB_OUT_PING_NAK_SENT), usec);
 		/* NAK done; now CLEAR_NAK_OUT_PACKETS is safe */
 	}
 }
@@ -661,9 +661,9 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
 		udelay (1);
 		tmp = readl (&ep->regs->ep_stat);
-		if ((tmp & (1 << NAK_OUT_PACKETS)))
+		if ((tmp & BIT(NAK_OUT_PACKETS)))
 			cleanup = 1;
-		else if ((tmp & (1 << FIFO_FULL))) {
+		else if ((tmp & BIT(FIFO_FULL))) {
 			start_out_naking (ep);
 			prevent = 1;
 		}
@@ -680,7 +680,7 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 		tmp = readl (&ep->regs->ep_stat);
 		count = readl (&regs->ep_avail);
 		/* handled that data already? */
-		if (count == 0 && (tmp & (1 << NAK_OUT_PACKETS)) == 0)
+		if (count == 0 && (tmp & BIT(NAK_OUT_PACKETS)) == 0)
 			return 0;
 	}
 
@@ -726,7 +726,7 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 	if (cleanup)
 		out_flush (ep);
 	if (prevent) {
-		writel ((1 << CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
+		writel(BIT(CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 		(void) readl (&ep->regs->ep_rsp);
 	}
 
@@ -747,16 +747,16 @@ fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
 	 * stop the fifo from filling but we can flush it.
 	 */
 	if (ep->is_in)
-		dmacount |= (1 << DMA_DIRECTION);
+		dmacount |= BIT(DMA_DIRECTION);
 	if ((!ep->is_in && (dmacount % ep->ep.maxpacket) != 0)
 			|| ep->dev->pdev->device != 0x2280)
-		dmacount |= (1 << END_OF_CHAIN);
+		dmacount |= BIT(END_OF_CHAIN);
 
 	req->valid = valid;
 	if (valid)
-		dmacount |= (1 << VALID_BIT);
+		dmacount |= BIT(VALID_BIT);
 	if (likely(!req->req.no_interrupt || !use_dma_chaining))
-		dmacount |= (1 << DMA_DONE_INTERRUPT_ENABLE);
+		dmacount |= BIT(DMA_DONE_INTERRUPT_ENABLE);
 
 	/* td->dmadesc = previously set by caller */
 	td->dmaaddr = cpu_to_le32 (req->req.dma);
@@ -767,47 +767,47 @@ fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
 }
 
 static const u32 dmactl_default =
-		  (1 << DMA_SCATTER_GATHER_DONE_INTERRUPT)
-		| (1 << DMA_CLEAR_COUNT_ENABLE)
+		BIT(DMA_SCATTER_GATHER_DONE_INTERRUPT) |
+		BIT(DMA_CLEAR_COUNT_ENABLE) |
 		/* erratum 0116 workaround part 1 (use POLLING) */
-		| (POLL_100_USEC << DESCRIPTOR_POLLING_RATE)
-		| (1 << DMA_VALID_BIT_POLLING_ENABLE)
-		| (1 << DMA_VALID_BIT_ENABLE)
-		| (1 << DMA_SCATTER_GATHER_ENABLE)
+		(POLL_100_USEC << DESCRIPTOR_POLLING_RATE) |
+		BIT(DMA_VALID_BIT_POLLING_ENABLE) |
+		BIT(DMA_VALID_BIT_ENABLE) |
+		BIT(DMA_SCATTER_GATHER_ENABLE) |
 		/* erratum 0116 workaround part 2 (no AUTOSTART) */
-		| (1 << DMA_ENABLE);
+		BIT(DMA_ENABLE);
 
 static inline void spin_stop_dma (struct net2280_dma_regs __iomem *dma)
 {
-	handshake (&dma->dmactl, (1 << DMA_ENABLE), 0, 50);
+	handshake(&dma->dmactl, BIT(DMA_ENABLE), 0, 50);
 }
 
 static inline void stop_dma (struct net2280_dma_regs __iomem *dma)
 {
-	writel (readl (&dma->dmactl) & ~(1 << DMA_ENABLE), &dma->dmactl);
+	writel(readl(&dma->dmactl) & ~BIT(DMA_ENABLE), &dma->dmactl);
 	spin_stop_dma (dma);
 }
 
 static void start_queue (struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 {
 	struct net2280_dma_regs	__iomem *dma = ep->dma;
-	unsigned int tmp = (1 << VALID_BIT) | (ep->is_in << DMA_DIRECTION);
+	unsigned int tmp = BIT(VALID_BIT) | (ep->is_in << DMA_DIRECTION);
 
 	if (ep->dev->pdev->device != 0x2280)
-		tmp |= (1 << END_OF_CHAIN);
+		tmp |= BIT(END_OF_CHAIN);
 
 	writel (tmp, &dma->dmacount);
 	writel (readl (&dma->dmastat), &dma->dmastat);
 
 	writel (td_dma, &dma->dmadesc);
 	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
-		dmactl |= (0x01 << DMA_REQUEST_OUTSTANDING);
+		dmactl |= BIT(DMA_REQUEST_OUTSTANDING);
 	writel (dmactl, &dma->dmactl);
 
 	/* erratum 0116 workaround part 3:  pci arbiter away from net2280 */
 	(void) readl (&ep->dev->pci->pcimstctl);
 
-	writel ((1 << DMA_START), &dma->dmastat);
+	writel(BIT(DMA_START), &dma->dmastat);
 
 	if (!ep->is_in)
 		stop_out_naking (ep);
@@ -821,13 +821,13 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 	/* FIXME can't use DMA for ZLPs */
 
 	/* on this path we "know" there's no dma active (yet) */
-	WARN_ON (readl (&dma->dmactl) & (1 << DMA_ENABLE));
+	WARN_ON(readl(&dma->dmactl) & BIT(DMA_ENABLE));
 	writel (0, &ep->dma->dmactl);
 
 	/* previous OUT packet might have been short */
 	if (!ep->is_in && ((tmp = readl (&ep->regs->ep_stat))
-				& (1 << NAK_OUT_PACKETS)) != 0) {
-		writel ((1 << SHORT_PACKET_TRANSFERRED_INTERRUPT),
+				& BIT(NAK_OUT_PACKETS)) != 0) {
+		writel(BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT),
 			&ep->regs->ep_stat);
 
 		tmp = readl (&ep->regs->ep_avail);
@@ -840,13 +840,13 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 
 			/* dma irq, faking scatterlist status */
 			req->td->dmacount = cpu_to_le32 (req->req.length - tmp);
-			writel ((1 << DMA_DONE_INTERRUPT_ENABLE)
+			writel(BIT(DMA_DONE_INTERRUPT_ENABLE)
 				| tmp, &dma->dmacount);
 			req->td->dmadesc = 0;
 			req->valid = 1;
 
-			writel ((1 << DMA_ENABLE), &dma->dmactl);
-			writel ((1 << DMA_START), &dma->dmastat);
+			writel(BIT(DMA_ENABLE), &dma->dmactl);
+			writel(BIT(DMA_START), &dma->dmastat);
 			return;
 		}
 	}
@@ -860,7 +860,7 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 	if (ep->is_in) {
 		if (likely ((req->req.length % ep->ep.maxpacket) != 0
 				|| req->req.zero)) {
-			tmp |= (1 << DMA_FIFO_VALIDATE);
+			tmp |= BIT(DMA_FIFO_VALIDATE);
 			ep->in_fifo_validate = 1;
 		} else
 			ep->in_fifo_validate = 0;
@@ -871,21 +871,21 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 	fill_dma_desc (ep, req, 1);
 
 	if (!use_dma_chaining)
-		req->td->dmacount |= cpu_to_le32 (1 << END_OF_CHAIN);
+		req->td->dmacount |= cpu_to_le32(BIT(END_OF_CHAIN));
 
 	start_queue (ep, tmp, req->td_dma);
 }
 
 static inline void resume_dma(struct net2280_ep *ep)
 {
-	writel(readl(&ep->dma->dmactl) | (1 << DMA_ENABLE), &ep->dma->dmactl);
+	writel(readl(&ep->dma->dmactl) | BIT(DMA_ENABLE), &ep->dma->dmactl);
 
 	ep->dma_started = true;
 }
 
 static inline void ep_stop_dma(struct net2280_ep *ep)
 {
-	writel(readl(&ep->dma->dmactl) & ~(1 << DMA_ENABLE), &ep->dma->dmactl);
+	writel(readl(&ep->dma->dmactl) & ~BIT(DMA_ENABLE), &ep->dma->dmactl);
 	spin_stop_dma(ep->dma);
 
 	ep->dma_started = false;
@@ -995,7 +995,7 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 	if (list_empty (&ep->queue) && !ep->stopped) {
 		/* DMA request while EP halted */
 		if (ep->dma &&
-		    (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
+		    (readl(&ep->regs->ep_rsp) & BIT(CLEAR_ENDPOINT_HALT)) &&
 			(dev->pdev->vendor == PCI_VENDOR_ID_PLX)) {
 			int valid = 1;
 			if (ep->is_in) {
@@ -1028,7 +1028,7 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 
 				/* OUT FIFO might have packet(s) buffered */
 				s = readl (&ep->regs->ep_stat);
-				if ((s & (1 << FIFO_EMPTY)) == 0) {
+				if ((s & BIT(FIFO_EMPTY)) == 0) {
 					/* note:  _req->short_not_ok is
 					 * ignored here since PIO _always_
 					 * stops queue advance here, and
@@ -1046,8 +1046,8 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 				}
 
 				/* don't NAK, let the fifo fill */
-				if (req && (s & (1 << NAK_OUT_PACKETS)))
-					writel ((1 << CLEAR_NAK_OUT_PACKETS),
+				if (req && (s & BIT(NAK_OUT_PACKETS)))
+					writel(BIT(CLEAR_NAK_OUT_PACKETS),
 							&ep->regs->ep_rsp);
 			}
 		}
@@ -1109,7 +1109,7 @@ static void scan_dma_completions (struct net2280_ep *ep)
 			break;
 		rmb ();
 		tmp = le32_to_cpup (&req->td->dmacount);
-		if ((tmp & (1 << VALID_BIT)) != 0)
+		if ((tmp & BIT(VALID_BIT)) != 0)
 			break;
 
 		/* SHORT_PACKET_TRANSFERRED_INTERRUPT handles "usb-short"
@@ -1134,7 +1134,7 @@ static void scan_dma_completions (struct net2280_ep *ep)
 			 * your gadget driver.  That helps avoids errata 0121,
 			 * 0122, and 0124; not all cases trigger the warning.
 			 */
-			if ((tmp & (1 << NAK_OUT_PACKETS)) == 0) {
+			if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
 				WARNING (ep->dev, "%s lost packet sync!\n",
 						ep->ep.name);
 				req->req.status = -EOVERFLOW;
@@ -1179,7 +1179,7 @@ static void restart_dma (struct net2280_ep *ep)
 		ep->in_fifo_validate = likely (req->req.zero
 			|| (req->req.length % ep->ep.maxpacket) != 0);
 		if (ep->in_fifo_validate)
-			dmactl |= (1 << DMA_FIFO_VALIDATE);
+			dmactl |= BIT(DMA_FIFO_VALIDATE);
 		list_for_each_entry (entry, &ep->queue, queue) {
 			__le32		dmacount;
 
@@ -1220,7 +1220,7 @@ static void abort_dma_228x(struct net2280_ep *ep)
 	/* abort the current transfer */
 	if (likely (!list_empty (&ep->queue))) {
 		/* FIXME work around errata 0121, 0122, 0124 */
-		writel ((1 << DMA_ABORT), &ep->dma->dmastat);
+		writel(BIT(DMA_ABORT), &ep->dma->dmastat);
 		spin_stop_dma (ep->dma);
 	} else
 		stop_dma (ep->dma);
@@ -1229,7 +1229,7 @@ static void abort_dma_228x(struct net2280_ep *ep)
 
 static void abort_dma_338x(struct net2280_ep *ep)
 {
-	writel((1 << DMA_ABORT), &ep->dma->dmastat);
+	writel(BIT(DMA_ABORT), &ep->dma->dmastat);
 	spin_stop_dma(ep->dma);
 }
 
@@ -1431,7 +1431,7 @@ net2280_fifo_status (struct usb_ep *_ep)
 	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
 		return -ESHUTDOWN;
 
-	avail = readl (&ep->regs->ep_avail) & ((1 << 12) - 1);
+	avail = readl(&ep->regs->ep_avail) & (BIT(12) - 1);
 	if (avail > ep->fifo_size)
 		return -EOVERFLOW;
 	if (ep->is_in)
@@ -1450,7 +1450,7 @@ net2280_fifo_flush (struct usb_ep *_ep)
 	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
 		return;
 
-	writel ((1 << FIFO_FLUSH), &ep->regs->ep_stat);
+	writel(BIT(FIFO_FLUSH), &ep->regs->ep_stat);
 	(void) readl (&ep->regs->ep_rsp);
 }
 
@@ -1499,8 +1499,8 @@ static int net2280_wakeup (struct usb_gadget *_gadget)
 
 	spin_lock_irqsave (&dev->lock, flags);
 	tmp = readl (&dev->usb->usbctl);
-	if (tmp & (1 << DEVICE_REMOTE_WAKEUP_ENABLE))
-		writel (1 << GENERATE_RESUME, &dev->usb->usbstat);
+	if (tmp & BIT(DEVICE_REMOTE_WAKEUP_ENABLE))
+		writel(BIT(GENERATE_RESUME), &dev->usb->usbstat);
 	spin_unlock_irqrestore (&dev->lock, flags);
 
 	/* pci writes may still be posted */
@@ -1520,10 +1520,10 @@ static int net2280_set_selfpowered (struct usb_gadget *_gadget, int value)
 	spin_lock_irqsave (&dev->lock, flags);
 	tmp = readl (&dev->usb->usbctl);
 	if (value) {
-		tmp |= (1 << SELF_POWERED_STATUS);
+		tmp |= BIT(SELF_POWERED_STATUS);
 		dev->selfpowered = 1;
 	} else {
-		tmp &= ~(1 << SELF_POWERED_STATUS);
+		tmp &= ~BIT(SELF_POWERED_STATUS);
 		dev->selfpowered = 0;
 	}
 	writel (tmp, &dev->usb->usbctl);
@@ -1546,9 +1546,9 @@ static int net2280_pullup(struct usb_gadget *_gadget, int is_on)
 	tmp = readl (&dev->usb->usbctl);
 	dev->softconnect = (is_on != 0);
 	if (is_on)
-		tmp |= (1 << USB_DETECT_ENABLE);
+		tmp |= BIT(USB_DETECT_ENABLE);
 	else
-		tmp &= ~(1 << USB_DETECT_ENABLE);
+		tmp &= ~BIT(USB_DETECT_ENABLE);
 	writel (tmp, &dev->usb->usbctl);
 	spin_unlock_irqrestore (&dev->lock, flags);
 
@@ -1636,8 +1636,8 @@ static ssize_t registers_show(struct device *_dev,
 	/* USB Control Registers */
 	t1 = readl (&dev->usb->usbctl);
 	t2 = readl (&dev->usb->usbstat);
-	if (t1 & (1 << VBUS_PIN)) {
-		if (t2 & (1 << HIGH_SPEED))
+	if (t1 & BIT(VBUS_PIN)) {
+		if (t2 & BIT(HIGH_SPEED))
 			s = "high speed";
 		else if (dev->gadget.speed == USB_SPEED_UNKNOWN)
 			s = "powered";
@@ -1672,21 +1672,21 @@ static ssize_t registers_show(struct device *_dev,
 				"\n%s\tcfg %05x rsp (%02x) %s%s%s%s%s%s%s%s"
 					"irqenb %02x\n",
 				ep->ep.name, t1, t2,
-				(t2 & (1 << CLEAR_NAK_OUT_PACKETS))
+				(t2 & BIT(CLEAR_NAK_OUT_PACKETS))
 					? "NAK " : "",
-				(t2 & (1 << CLEAR_EP_HIDE_STATUS_PHASE))
+				(t2 & BIT(CLEAR_EP_HIDE_STATUS_PHASE))
 					? "hide " : "",
-				(t2 & (1 << CLEAR_EP_FORCE_CRC_ERROR))
+				(t2 & BIT(CLEAR_EP_FORCE_CRC_ERROR))
 					? "CRC " : "",
-				(t2 & (1 << CLEAR_INTERRUPT_MODE))
+				(t2 & BIT(CLEAR_INTERRUPT_MODE))
 					? "interrupt " : "",
-				(t2 & (1<<CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE))
+				(t2 & BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE))
 					? "status " : "",
-				(t2 & (1 << CLEAR_NAK_OUT_PACKETS_MODE))
+				(t2 & BIT(CLEAR_NAK_OUT_PACKETS_MODE))
 					? "NAKmode " : "",
-				(t2 & (1 << CLEAR_ENDPOINT_TOGGLE))
+				(t2 & BIT(CLEAR_ENDPOINT_TOGGLE))
 					? "DATA1 " : "DATA0 ",
-				(t2 & (1 << CLEAR_ENDPOINT_HALT))
+				(t2 & BIT(CLEAR_ENDPOINT_HALT))
 					? "HALT " : "",
 				readl (&ep->regs->ep_irqenb));
 		size -= t;
@@ -1922,10 +1922,10 @@ static void defect7374_disable_data_eps(struct net2280 *dev)
 
 		/* Change settings on some selected endpoints */
 		tmp_reg = readl(&dev->plregs->pl_ep_cfg_4);
-		tmp_reg &= ~(1 << NON_CTRL_IN_TOLERATE_BAD_DIR);
+		tmp_reg &= ~BIT(NON_CTRL_IN_TOLERATE_BAD_DIR);
 		writel(tmp_reg, &dev->plregs->pl_ep_cfg_4);
 		tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
-		tmp_reg |= (1 << EP_INITIALIZED);
+		tmp_reg |= BIT(EP_INITIALIZED);
 		writel(tmp_reg, &dev->plregs->pl_ep_ctrl);
 	}
 }
@@ -1947,17 +1947,17 @@ static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 		WARNING(dev, "It will operate on cold-reboot and SS connect");
 
 		/*GPEPs:*/
-		tmp = ((0 << ENDPOINT_NUMBER) | (1 << ENDPOINT_DIRECTION) |
+		tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_DIRECTION) |
 		       (2 << OUT_ENDPOINT_TYPE) | (2 << IN_ENDPOINT_TYPE) |
 		       ((dev->enhanced_mode) ?
-			1 << OUT_ENDPOINT_ENABLE : 1 << ENDPOINT_ENABLE) |
-		       (1 << IN_ENDPOINT_ENABLE));
+		       BIT(OUT_ENDPOINT_ENABLE) : BIT(ENDPOINT_ENABLE)) |
+		       BIT(IN_ENDPOINT_ENABLE));
 
 		for (i = 1; i < 5; i++)
 			writel(tmp, &dev->ep[i].cfg->ep_cfg);
 
 		/* CSRIN, PCIIN, STATIN, RCIN*/
-		tmp = ((0 << ENDPOINT_NUMBER) | (1 << ENDPOINT_ENABLE));
+		tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_ENABLE));
 		writel(tmp, &dev->dep[1].dep_cfg);
 		writel(tmp, &dev->dep[3].dep_cfg);
 		writel(tmp, &dev->dep[4].dep_cfg);
@@ -1974,7 +1974,7 @@ static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 			if (ep_sel == 1) {
 				tmp =
 				    (readl(&dev->plregs->pl_ep_ctrl) |
-				     (1 << CLEAR_ACK_ERROR_CODE) | 0);
+				     BIT(CLEAR_ACK_ERROR_CODE) | 0);
 				writel(tmp, &dev->plregs->pl_ep_ctrl);
 				continue;
 			}
@@ -1984,11 +1984,11 @@ static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 				continue;
 
 			tmp = (readl(&dev->plregs->pl_ep_cfg_4) |
-				 (1 << NON_CTRL_IN_TOLERATE_BAD_DIR) | 0);
+				 BIT(NON_CTRL_IN_TOLERATE_BAD_DIR) | 0);
 			writel(tmp, &dev->plregs->pl_ep_cfg_4);
 
 			tmp = readl(&dev->plregs->pl_ep_ctrl) &
-				~(1 << EP_INITIALIZED);
+				~BIT(EP_INITIALIZED);
 			writel(tmp, &dev->plregs->pl_ep_ctrl);
 
 		}
@@ -2036,14 +2036,14 @@ static void usb_reset_228x(struct net2280 *dev)
 	}
 
 	writel (~0, &dev->regs->irqstat0),
-	writel (~(1 << SUSPEND_REQUEST_INTERRUPT), &dev->regs->irqstat1),
+	writel(~(u32)BIT(SUSPEND_REQUEST_INTERRUPT), &dev->regs->irqstat1),
 
 	/* reset, and enable pci */
-	tmp = readl (&dev->regs->devinit)
-		| (1 << PCI_ENABLE)
-		| (1 << FIFO_SOFT_RESET)
-		| (1 << USB_SOFT_RESET)
-		| (1 << M8051_RESET);
+	tmp = readl(&dev->regs->devinit) |
+		BIT(PCI_ENABLE) |
+		BIT(FIFO_SOFT_RESET) |
+		BIT(USB_SOFT_RESET) |
+		BIT(M8051_RESET);
 	writel (tmp, &dev->regs->devinit);
 
 	/* standard fifo and endpoint allocations */
@@ -2087,10 +2087,10 @@ static void usb_reset_338x(struct net2280 *dev)
 	if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ) {
 		/* reset, and enable pci */
 		tmp = readl(&dev->regs->devinit) |
-		    (1 << PCI_ENABLE) |
-		    (1 << FIFO_SOFT_RESET) |
-		    (1 << USB_SOFT_RESET) |
-		    (1 << M8051_RESET);
+		    BIT(PCI_ENABLE) |
+		    BIT(FIFO_SOFT_RESET) |
+		    BIT(USB_SOFT_RESET) |
+		    BIT(M8051_RESET);
 
 		writel(tmp, &dev->regs->devinit);
 	}
@@ -2206,7 +2206,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 						__func__, fsmvalue);
 	else {
 		tmp = readl(&dev->usb_ext->usbctl2) &
-		    ~((1 << U1_ENABLE) | (1 << U2_ENABLE) | (1 << LTM_ENABLE));
+		    ~(BIT(U1_ENABLE) | BIT(U2_ENABLE) | BIT(LTM_ENABLE));
 		writel(tmp, &dev->usb_ext->usbctl2);
 	}
 
@@ -2245,7 +2245,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 	 * - Reference PLX TT-7372
 	*/
 	val = readl(&dev->ll_chicken_reg->ll_tsn_chicken_bit);
-	val |= (1 << RECOVERY_IDLE_TO_RECOVER_FMW);
+	val |= BIT(RECOVERY_IDLE_TO_RECOVER_FMW);
 	writel(val, &dev->ll_chicken_reg->ll_tsn_chicken_bit);
 
 	INIT_LIST_HEAD(&dev->gadget.ep0->ep_list);
@@ -2268,9 +2268,9 @@ static void usb_reinit(struct net2280 *dev)
 
 static void ep0_start_228x(struct net2280 *dev)
 {
-	writel (  (1 << CLEAR_EP_HIDE_STATUS_PHASE)
-		| (1 << CLEAR_NAK_OUT_PACKETS)
-		| (1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
+	writel(BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
+		BIT(CLEAR_NAK_OUT_PACKETS) |
+		BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
 		, &dev->epregs [0].ep_rsp);
 
 	/*
@@ -2279,31 +2279,31 @@ static void ep0_start_228x(struct net2280 *dev)
 	 * endpoint status/features are handled in software, to
 	 * help pass tests for some dubious behavior.
 	 */
-	writel (  (1 << SET_TEST_MODE)
-		| (1 << SET_ADDRESS)
-		| (1 << DEVICE_SET_CLEAR_DEVICE_REMOTE_WAKEUP)
-		| (1 << GET_DEVICE_STATUS)
-		| (1 << GET_INTERFACE_STATUS)
+	writel(BIT(SET_TEST_MODE) |
+		BIT(SET_ADDRESS) |
+		BIT(DEVICE_SET_CLEAR_DEVICE_REMOTE_WAKEUP) |
+		BIT(GET_DEVICE_STATUS) |
+		BIT(GET_INTERFACE_STATUS)
 		, &dev->usb->stdrsp);
-	writel (  (1 << USB_ROOT_PORT_WAKEUP_ENABLE)
-		| (1 << SELF_POWERED_USB_DEVICE)
-		| (1 << REMOTE_WAKEUP_SUPPORT)
-		| (dev->softconnect << USB_DETECT_ENABLE)
-		| (1 << SELF_POWERED_STATUS)
-		, &dev->usb->usbctl);
+	writel(BIT(USB_ROOT_PORT_WAKEUP_ENABLE) |
+		BIT(SELF_POWERED_USB_DEVICE) |
+		BIT(REMOTE_WAKEUP_SUPPORT) |
+		(dev->softconnect << USB_DETECT_ENABLE) |
+		BIT(SELF_POWERED_STATUS),
+		&dev->usb->usbctl);
 
 	/* enable irqs so we can see ep0 and general operation  */
-	writel (  (1 << SETUP_PACKET_INTERRUPT_ENABLE)
-		| (1 << ENDPOINT_0_INTERRUPT_ENABLE)
-		, &dev->regs->pciirqenb0);
-	writel (  (1 << PCI_INTERRUPT_ENABLE)
-		| (1 << PCI_MASTER_ABORT_RECEIVED_INTERRUPT_ENABLE)
-		| (1 << PCI_TARGET_ABORT_RECEIVED_INTERRUPT_ENABLE)
-		| (1 << PCI_RETRY_ABORT_INTERRUPT_ENABLE)
-		| (1 << VBUS_INTERRUPT_ENABLE)
-		| (1 << ROOT_PORT_RESET_INTERRUPT_ENABLE)
-		| (1 << SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE)
-		, &dev->regs->pciirqenb1);
+	writel(BIT(SETUP_PACKET_INTERRUPT_ENABLE) |
+		BIT(ENDPOINT_0_INTERRUPT_ENABLE),
+		&dev->regs->pciirqenb0);
+	writel(BIT(PCI_INTERRUPT_ENABLE) |
+		BIT(PCI_MASTER_ABORT_RECEIVED_INTERRUPT_ENABLE) |
+		BIT(PCI_TARGET_ABORT_RECEIVED_INTERRUPT_ENABLE) |
+		BIT(PCI_RETRY_ABORT_INTERRUPT_ENABLE) |
+		BIT(VBUS_INTERRUPT_ENABLE) |
+		BIT(ROOT_PORT_RESET_INTERRUPT_ENABLE) |
+		BIT(SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE),
+		&dev->regs->pciirqenb1);
 
 	/* don't leave any writes posted */
 	(void) readl (&dev->usb->usbctl);
@@ -2320,8 +2320,8 @@ static void ep0_start_338x(struct net2280 *dev)
 		INFO(dev, "%s: Defect 7374 FsmValue %08x\n", __func__,
 		     fsmvalue);
 	else
-		writel((1 << CLEAR_NAK_OUT_PACKETS_MODE) |
-		       (1 << SET_EP_HIDE_STATUS_PHASE),
+		writel(BIT(CLEAR_NAK_OUT_PACKETS_MODE) |
+		       BIT(SET_EP_HIDE_STATUS_PHASE),
 		       &dev->epregs[0].ep_rsp);
 
 	/*
@@ -2330,27 +2330,27 @@ static void ep0_start_338x(struct net2280 *dev)
 	 * endpoint status/features are handled in software, to
 	 * help pass tests for some dubious behavior.
 	 */
-	writel((1 << SET_ISOCHRONOUS_DELAY) |
-	       (1 << SET_SEL) |
-	       (1 << SET_TEST_MODE) |
-	       (1 << SET_ADDRESS) |
-	       (1 << GET_INTERFACE_STATUS) |
-	       (1 << GET_DEVICE_STATUS),
+	writel(BIT(SET_ISOCHRONOUS_DELAY) |
+	       BIT(SET_SEL) |
+	       BIT(SET_TEST_MODE) |
+	       BIT(SET_ADDRESS) |
+	       BIT(GET_INTERFACE_STATUS) |
+	       BIT(GET_DEVICE_STATUS),
 		&dev->usb->stdrsp);
 	dev->wakeup_enable = 1;
-	writel((1 << USB_ROOT_PORT_WAKEUP_ENABLE) |
+	writel(BIT(USB_ROOT_PORT_WAKEUP_ENABLE) |
 	       (dev->softconnect << USB_DETECT_ENABLE) |
-	       (1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+	       BIT(DEVICE_REMOTE_WAKEUP_ENABLE),
 	       &dev->usb->usbctl);
 
 	/* enable irqs so we can see ep0 and general operation  */
-	writel((1 << SETUP_PACKET_INTERRUPT_ENABLE) |
-	       (1 << ENDPOINT_0_INTERRUPT_ENABLE)
+	writel(BIT(SETUP_PACKET_INTERRUPT_ENABLE) |
+	       BIT(ENDPOINT_0_INTERRUPT_ENABLE)
 	       , &dev->regs->pciirqenb0);
-	writel((1 << PCI_INTERRUPT_ENABLE) |
-	       (1 << ROOT_PORT_RESET_INTERRUPT_ENABLE) |
-	       (1 << SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE) |
-	       (1 << VBUS_INTERRUPT_ENABLE),
+	writel(BIT(PCI_INTERRUPT_ENABLE) |
+	       BIT(ROOT_PORT_RESET_INTERRUPT_ENABLE) |
+	       BIT(SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE) |
+	       BIT(VBUS_INTERRUPT_ENABLE),
 	       &dev->regs->pciirqenb1);
 
 	/* don't leave any writes posted */
@@ -2402,7 +2402,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 
 	/* Enable force-full-speed testing mode, if desired */
 	if (full_speed && dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
-		writel(1 << FORCE_FULL_SPEED_MODE, &dev->usb->xcvrdiag);
+		writel(BIT(FORCE_FULL_SPEED_MODE), &dev->usb->xcvrdiag);
 
 	/* ... then enable host detection and ep0; and we're ready
 	 * for set_configuration as well as eventual disconnect.
@@ -2511,7 +2511,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 			ep->ep.name, t, req ? &req->req : 0);
 #endif
 	if (!ep->is_in || ep->dev->pdev->device == 0x2280)
-		writel (t & ~(1 << NAK_OUT_PACKETS), &ep->regs->ep_stat);
+		writel(t & ~BIT(NAK_OUT_PACKETS), &ep->regs->ep_stat);
 	else
 		/* Added for 2282 */
 		writel (t, &ep->regs->ep_stat);
@@ -2529,7 +2529,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 	if (unlikely (ep->num == 0)) {
 		if (ep->is_in) {
 			/* status; stop NAKing */
-			if (t & (1 << DATA_OUT_PING_TOKEN_INTERRUPT)) {
+			if (t & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
 					set_halt (ep);
@@ -2538,7 +2538,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 					allow_status (ep);
 				mode = 2;
 			/* reply to extra IN data tokens with a zlp */
-			} else if (t & (1 << DATA_IN_TOKEN_INTERRUPT)) {
+			} else if (t & BIT(DATA_IN_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
 					set_halt (ep);
@@ -2549,14 +2549,14 @@ static void handle_ep_small (struct net2280_ep *ep)
 			}
 		} else {
 			/* status; stop NAKing */
-			if (t & (1 << DATA_IN_TOKEN_INTERRUPT)) {
+			if (t & BIT(DATA_IN_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
 					set_halt (ep);
 				}
 				mode = 2;
 			/* an extra OUT token is an error */
-			} else if (((t & (1 << DATA_OUT_PING_TOKEN_INTERRUPT))
+			} else if (((t & BIT(DATA_OUT_PING_TOKEN_INTERRUPT))
 					&& req
 					&& req->req.actual == req->req.length)
 					|| (ep->responded && !req)) {
@@ -2575,7 +2575,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 
 	/* manual DMA queue advance after short OUT */
 	if (likely (ep->dma)) {
-		if (t & (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT)) {
+		if (t & BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT)) {
 			u32	count;
 			int	stopped = ep->stopped;
 
@@ -2601,7 +2601,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 				/* here either (M < N), a "real" short rx;
 				 * or (M == N) and the queue didn't empty
 				 */
-				if (likely (t & (1 << FIFO_EMPTY))) {
+				if (likely(t & BIT(FIFO_EMPTY))) {
 					count = readl (&ep->dma->dmacount);
 					count &= DMA_BYTE_COUNT_MASK;
 					if (readl (&ep->dma->dmadesc)
@@ -2613,7 +2613,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 			}
 
 			/* stop DMA, leave ep NAKing */
-			writel ((1 << DMA_ABORT), &ep->dma->dmastat);
+			writel(BIT(DMA_ABORT), &ep->dma->dmastat);
 			spin_stop_dma (ep->dma);
 
 			if (likely (req)) {
@@ -2643,12 +2643,12 @@ static void handle_ep_small (struct net2280_ep *ep)
 		return;
 
 	/* data packet(s) received (in the fifo, OUT) */
-	} else if (t & (1 << DATA_PACKET_RECEIVED_INTERRUPT)) {
+	} else if (t & BIT(DATA_PACKET_RECEIVED_INTERRUPT)) {
 		if (read_fifo (ep, req) && ep->num != 0)
 			mode = 2;
 
 	/* data packet(s) transmitted (IN) */
-	} else if (t & (1 << DATA_PACKET_TRANSMITTED_INTERRUPT)) {
+	} else if (t & BIT(DATA_PACKET_TRANSMITTED_INTERRUPT)) {
 		unsigned	len;
 
 		len = req->req.length - req->req.actual;
@@ -2699,7 +2699,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 	if (req && !ep->stopped) {
 
 		/* load IN fifo with next packet (may be zlp) */
-		if (t & (1 << DATA_PACKET_TRANSMITTED_INTERRUPT))
+		if (t & BIT(DATA_PACKET_TRANSMITTED_INTERRUPT))
 			write_fifo (ep, &req->req);
 	}
 }
@@ -2740,7 +2740,7 @@ static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
 		return;
 
 	/* This is the first Control Read for this connection: */
-	if (!(readl(&dev->usb->usbstat) & (1 << SUPER_SPEED_MODE))) {
+	if (!(readl(&dev->usb->usbstat) & BIT(SUPER_SPEED_MODE))) {
 		/*
 		 * Connection is NOT SS:
 		 * - Connection must be FS or HS.
@@ -2804,9 +2804,9 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 	static const u32 ep_pl[9] = { 0, 3, 4, 7, 8, 2, 5, 6, 9 };
 
 	if (stall) {
-		writel((1 << SET_ENDPOINT_HALT) |
-		       /* (1 << SET_NAK_PACKETS) | */
-		       (1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
+		writel(BIT(SET_ENDPOINT_HALT) |
+		       /* BIT(SET_NAK_PACKETS) | */
+		       BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
 		       &ep->regs->ep_rsp);
 		ep->is_halt = 1;
 	} else {
@@ -2819,14 +2819,14 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 			val = (val & ~0x1f) | ep_pl[ep->num];
 			writel(val, &dev->plregs->pl_ep_ctrl);
 
-			val |= (1 << SEQUENCE_NUMBER_RESET);
+			val |= BIT(SEQUENCE_NUMBER_RESET);
 			writel(val, &dev->plregs->pl_ep_ctrl);
 		}
 		val = readl(&ep->regs->ep_rsp);
-		val |= (1 << CLEAR_ENDPOINT_HALT) |
-			(1 << CLEAR_ENDPOINT_TOGGLE);
+		val |= BIT(CLEAR_ENDPOINT_HALT) |
+			BIT(CLEAR_ENDPOINT_TOGGLE);
 		writel(val
-		       /* | (1 << CLEAR_NAK_PACKETS)*/
+		       /* | BIT(CLEAR_NAK_PACKETS)*/
 		       , &ep->regs->ep_rsp);
 		ep->is_halt = 0;
 		val = readl(&ep->regs->ep_rsp);
@@ -2895,7 +2895,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 		case (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE):
 			status = dev->wakeup_enable ? 0x02 : 0x00;
 			if (dev->selfpowered)
-				status |= 1 << 0;
+				status |= BIT(0);
 			status |= (dev->u1_enable << 2 | dev->u2_enable << 3 |
 							dev->ltm_enable << 4);
 			writel(0, &dev->epregs[0].ep_irqenb);
@@ -2909,7 +2909,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			if (!e)
 				goto do_stall3;
 			status = readl(&e->regs->ep_rsp) &
-						(1 << CLEAR_ENDPOINT_HALT);
+						BIT(CLEAR_ENDPOINT_HALT);
 			writel(0, &dev->epregs[0].ep_irqenb);
 			set_fifo_bytecount(ep, sizeof(status));
 			writel((__force u32) status, &dev->epregs[0].ep_data);
@@ -2929,7 +2929,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_U1_ENABLE:
 					dev->u1_enable = 0;
 					writel(readl(&dev->usb_ext->usbctl2) &
-						~(1 << U1_ENABLE),
+						~BIT(U1_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -2937,7 +2937,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_U2_ENABLE:
 					dev->u2_enable = 0;
 					writel(readl(&dev->usb_ext->usbctl2) &
-						~(1 << U2_ENABLE),
+						~BIT(U2_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -2945,7 +2945,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_LTM_ENABLE:
 					dev->ltm_enable = 0;
 					writel(readl(&dev->usb_ext->usbctl2) &
-						~(1 << LTM_ENABLE),
+						~BIT(LTM_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -2957,7 +2957,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			if (w_value == USB_DEVICE_REMOTE_WAKEUP) {
 				dev->wakeup_enable = 0;
 				writel(readl(&dev->usb->usbctl) &
-					~(1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+					~BIT(DEVICE_REMOTE_WAKEUP_ENABLE),
 					&dev->usb->usbctl);
 				allow_status_338x(ep);
 				break;
@@ -2990,7 +2990,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_U1_ENABLE:
 					dev->u1_enable = 1;
 					writel(readl(&dev->usb_ext->usbctl2) |
-						(1 << U1_ENABLE),
+						BIT(U1_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -2998,7 +2998,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_U2_ENABLE:
 					dev->u2_enable = 1;
 					writel(readl(&dev->usb_ext->usbctl2) |
-						(1 << U2_ENABLE),
+						BIT(U2_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -3006,7 +3006,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				case USB_DEVICE_LTM_ENABLE:
 					dev->ltm_enable = 1;
 					writel(readl(&dev->usb_ext->usbctl2) |
-						(1 << LTM_ENABLE),
+						BIT(LTM_ENABLE),
 						&dev->usb_ext->usbctl2);
 					allow_status_338x(ep);
 					goto next_endpoints3;
@@ -3018,7 +3018,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			if (w_value == USB_DEVICE_REMOTE_WAKEUP) {
 				dev->wakeup_enable = 1;
 				writel(readl(&dev->usb->usbctl) |
-					(1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+					BIT(DEVICE_REMOTE_WAKEUP_ENABLE),
 					&dev->usb->usbctl);
 				allow_status_338x(ep);
 				break;
@@ -3075,13 +3075,13 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 	u32			num, scratch;
 
 	/* most of these don't need individual acks */
-	stat &= ~(1 << INTA_ASSERTED);
+	stat &= ~BIT(INTA_ASSERTED);
 	if (!stat)
 		return;
 	// DEBUG (dev, "irqstat0 %04x\n", stat);
 
 	/* starting a control request? */
-	if (unlikely (stat & (1 << SETUP_PACKET_INTERRUPT))) {
+	if (unlikely(stat & BIT(SETUP_PACKET_INTERRUPT))) {
 		union {
 			u32			raw [2];
 			struct usb_ctrlrequest	r;
@@ -3091,11 +3091,11 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 
 		if (dev->gadget.speed == USB_SPEED_UNKNOWN) {
 			u32 val = readl(&dev->usb->usbstat);
-			if (val & (1 << SUPER_SPEED)) {
+			if (val & BIT(SUPER_SPEED)) {
 				dev->gadget.speed = USB_SPEED_SUPER;
 				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
 						EP0_SS_MAX_PACKET_SIZE);
-			} else if (val & (1 << HIGH_SPEED)) {
+			} else if (val & BIT(HIGH_SPEED)) {
 				dev->gadget.speed = USB_SPEED_HIGH;
 				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
 						EP0_HS_MAX_PACKET_SIZE);
@@ -3112,7 +3112,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		ep->irqs++;
 
 		/* make sure any leftover request state is cleared */
-		stat &= ~(1 << ENDPOINT_0_INTERRUPT);
+		stat &= ~BIT(ENDPOINT_0_INTERRUPT);
 		while (!list_empty (&ep->queue)) {
 			req = list_entry (ep->queue.next,
 					struct net2280_request, queue);
@@ -3125,23 +3125,23 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			ep->is_halt = 0;
 		else{
 			if (ep->dev->pdev->device == 0x2280)
-				tmp = (1 << FIFO_OVERFLOW) |
-				    (1 << FIFO_UNDERFLOW);
+				tmp = BIT(FIFO_OVERFLOW) |
+				    BIT(FIFO_UNDERFLOW);
 			else
 				tmp = 0;
 
-			writel(tmp | (1 << TIMEOUT) |
-				   (1 << USB_STALL_SENT) |
-				   (1 << USB_IN_NAK_SENT) |
-				   (1 << USB_IN_ACK_RCVD) |
-				   (1 << USB_OUT_PING_NAK_SENT) |
-				   (1 << USB_OUT_ACK_SENT) |
-				   (1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
-				   (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
-				   (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
-				   (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
-				   (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
-				   (1 << DATA_IN_TOKEN_INTERRUPT)
+			writel(tmp | BIT(TIMEOUT) |
+				   BIT(USB_STALL_SENT) |
+				   BIT(USB_IN_NAK_SENT) |
+				   BIT(USB_IN_ACK_RCVD) |
+				   BIT(USB_OUT_PING_NAK_SENT) |
+				   BIT(USB_OUT_ACK_SENT) |
+				   BIT(SHORT_PACKET_OUT_DONE_INTERRUPT) |
+				   BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT) |
+				   BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
+				   BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
+				   BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+				   BIT(DATA_IN_TOKEN_INTERRUPT)
 				   , &ep->regs->ep_stat);
 		}
 		u.raw[0] = readl(&dev->usb->setup0123);
@@ -3160,8 +3160,8 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 #define	w_length	le16_to_cpu(u.r.wLength)
 
 		/* ack the irq */
-		writel (1 << SETUP_PACKET_INTERRUPT, &dev->regs->irqstat0);
-		stat ^= (1 << SETUP_PACKET_INTERRUPT);
+		writel(BIT(SETUP_PACKET_INTERRUPT), &dev->regs->irqstat0);
+		stat ^= BIT(SETUP_PACKET_INTERRUPT);
 
 		/* watch control traffic at the token level, and force
 		 * synchronization before letting the status stage happen.
@@ -3170,14 +3170,14 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		 */
 		ep->is_in = (u.r.bRequestType & USB_DIR_IN) != 0;
 		if (ep->is_in) {
-			scratch = (1 << DATA_PACKET_TRANSMITTED_INTERRUPT)
-				| (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
-				| (1 << DATA_IN_TOKEN_INTERRUPT);
+			scratch = BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
+				BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+				BIT(DATA_IN_TOKEN_INTERRUPT);
 			stop_out_naking (ep);
 		} else
-			scratch = (1 << DATA_PACKET_RECEIVED_INTERRUPT)
-				| (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
-				| (1 << DATA_IN_TOKEN_INTERRUPT);
+			scratch = BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
+				BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
+				BIT(DATA_IN_TOKEN_INTERRUPT);
 		writel (scratch, &dev->epregs [0].ep_irqenb);
 
 		/* we made the hardware handle most lowlevel requests;
@@ -3202,8 +3202,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 					|| w_length > 2)
 				goto do_stall;
 
-			if (readl (&e->regs->ep_rsp)
-					& (1 << SET_ENDPOINT_HALT))
+			if (readl(&e->regs->ep_rsp) & BIT(SET_ENDPOINT_HALT))
 				status = cpu_to_le32 (1);
 			else
 				status = cpu_to_le32 (0);
@@ -3303,7 +3302,7 @@ next_endpoints:
 		u32		t;
 
 		/* do this endpoint's FIFO and queue need tending? */
-		t = 1 << num;
+		t = BIT(num);
 		if ((scratch & t) == 0)
 			continue;
 		scratch ^= t;
@@ -3316,15 +3315,14 @@ next_endpoints:
 		DEBUG (dev, "unhandled irqstat0 %08x\n", stat);
 }
 
-#define DMA_INTERRUPTS ( \
-		  (1 << DMA_D_INTERRUPT) \
-		| (1 << DMA_C_INTERRUPT) \
-		| (1 << DMA_B_INTERRUPT) \
-		| (1 << DMA_A_INTERRUPT))
+#define DMA_INTERRUPTS (BIT(DMA_D_INTERRUPT) | \
+		BIT(DMA_C_INTERRUPT) | \
+		BIT(DMA_B_INTERRUPT) | \
+		BIT(DMA_A_INTERRUPT))
 #define	PCI_ERROR_INTERRUPTS ( \
-		  (1 << PCI_MASTER_ABORT_RECEIVED_INTERRUPT) \
-		| (1 << PCI_TARGET_ABORT_RECEIVED_INTERRUPT) \
-		| (1 << PCI_RETRY_ABORT_INTERRUPT))
+		BIT(PCI_MASTER_ABORT_RECEIVED_INTERRUPT) | \
+		BIT(PCI_TARGET_ABORT_RECEIVED_INTERRUPT) | \
+		BIT(PCI_RETRY_ABORT_INTERRUPT))
 
 static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 {
@@ -3332,8 +3330,8 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	u32			tmp, num, mask, scratch;
 
 	/* after disconnect there's nothing else to do! */
-	tmp = (1 << VBUS_INTERRUPT) | (1 << ROOT_PORT_RESET_INTERRUPT);
-	mask = (1 << SUPER_SPEED) | (1 << HIGH_SPEED) | (1 << FULL_SPEED);
+	tmp = BIT(VBUS_INTERRUPT) | BIT(ROOT_PORT_RESET_INTERRUPT);
+	mask = BIT(SUPER_SPEED) | BIT(HIGH_SPEED) | BIT(FULL_SPEED);
 
 	/* VBUS disconnect is indicated by VBUS_PIN and VBUS_INTERRUPT set.
 	 * Root Port Reset is indicated by ROOT_PORT_RESET_INTERRUPT set and
@@ -3342,11 +3340,11 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	 */
 	if (stat & tmp) {
 		writel (tmp, &dev->regs->irqstat1);
-		if ((((stat & (1 << ROOT_PORT_RESET_INTERRUPT))
+		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT))
 					&& ((readl (&dev->usb->usbstat) & mask)
 							== 0))
 				|| ((readl (&dev->usb->usbctl)
-					& (1 << VBUS_PIN)) == 0)
+					& BIT(VBUS_PIN)) == 0)
 			    ) && ( dev->gadget.speed != USB_SPEED_UNKNOWN)) {
 			DEBUG (dev, "disconnect %s\n",
 					dev->driver->driver.name);
@@ -3366,14 +3364,14 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	/* NOTE: chip stays in PCI D0 state for now, but it could
 	 * enter D1 to save more power
 	 */
-	tmp = (1 << SUSPEND_REQUEST_CHANGE_INTERRUPT);
+	tmp = BIT(SUSPEND_REQUEST_CHANGE_INTERRUPT);
 	if (stat & tmp) {
 		writel (tmp, &dev->regs->irqstat1);
-		if (stat & (1 << SUSPEND_REQUEST_INTERRUPT)) {
+		if (stat & BIT(SUSPEND_REQUEST_INTERRUPT)) {
 			if (dev->driver->suspend)
 				dev->driver->suspend (&dev->gadget);
 			if (!enable_suspend)
-				stat &= ~(1 << SUSPEND_REQUEST_INTERRUPT);
+				stat &= ~BIT(SUSPEND_REQUEST_INTERRUPT);
 		} else {
 			if (dev->driver->resume)
 				dev->driver->resume (&dev->gadget);
@@ -3388,15 +3386,15 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 
 	/* some status we can just ignore */
 	if (dev->pdev->device == 0x2280)
-		stat &= ~((1 << CONTROL_STATUS_INTERRUPT)
-			  | (1 << SUSPEND_REQUEST_INTERRUPT)
-			  | (1 << RESUME_INTERRUPT)
-			  | (1 << SOF_INTERRUPT));
+		stat &= ~(BIT(CONTROL_STATUS_INTERRUPT) |
+			  BIT(SUSPEND_REQUEST_INTERRUPT) |
+			  BIT(RESUME_INTERRUPT) |
+			  BIT(SOF_INTERRUPT));
 	else
-		stat &= ~((1 << CONTROL_STATUS_INTERRUPT)
-			  | (1 << RESUME_INTERRUPT)
-			  | (1 << SOF_DOWN_INTERRUPT)
-			  | (1 << SOF_INTERRUPT));
+		stat &= ~(BIT(CONTROL_STATUS_INTERRUPT) |
+			  BIT(RESUME_INTERRUPT) |
+			  BIT(SOF_DOWN_INTERRUPT) |
+			  BIT(SOF_INTERRUPT));
 
 	if (!stat)
 		return;
@@ -3409,7 +3407,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	for (num = 0; scratch; num++) {
 		struct net2280_dma_regs	__iomem *dma;
 
-		tmp = 1 << num;
+		tmp = BIT(num);
 		if ((tmp & scratch) == 0)
 			continue;
 		scratch ^= tmp;
@@ -3428,7 +3426,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 			u32 r_dmacount = readl(&dma->dmacount);
 			if (!ep->is_in &&  (r_dmacount & 0x00FFFFFF) &&
-			    (tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT)))
+			    (tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT)))
 				continue;
 		}
 
@@ -3436,7 +3434,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		 * or (stat0 codepath) short OUT transfer.
 		 */
 		if (!use_dma_chaining) {
-			if (!(tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT))) {
+			if (!(tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT))) {
 				DEBUG (ep->dev, "%s no xact done? %08x\n",
 					ep->ep.name, tmp);
 				continue;
@@ -3462,8 +3460,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 				stop_dma (ep->dma);
 		} else {
 			tmp = readl (&dma->dmactl);
-			if (!use_dma_chaining
-					|| (tmp & (1 << DMA_ENABLE)) == 0)
+			if (!use_dma_chaining || (tmp & BIT(DMA_ENABLE)) == 0)
 				restart_dma (ep);
 			else if (ep->is_in && use_dma_chaining) {
 				struct net2280_request	*req;
@@ -3477,9 +3474,8 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 				req = list_entry (ep->queue.next,
 						struct net2280_request, queue);
 				dmacount = req->td->dmacount;
-				dmacount &= cpu_to_le32 (
-						(1 << VALID_BIT)
-						| DMA_BYTE_COUNT_MASK);
+				dmacount &= cpu_to_le32(BIT(VALID_BIT) |
+						DMA_BYTE_COUNT_MASK);
 				if (dmacount && (dmacount & valid_bit) == 0)
 					restart_dma (ep);
 			}
@@ -3511,7 +3507,7 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 
 	/* shared interrupt, not ours */
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY &&
-		(!(readl(&dev->regs->irqstat0) & (1 << INTA_ASSERTED))))
+		(!(readl(&dev->regs->irqstat0) & BIT(INTA_ASSERTED))))
 		return IRQ_NONE;
 
 	spin_lock (&dev->lock);
@@ -3664,7 +3660,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		dev->plregs = (struct usb338x_pl_regs __iomem *)
 							(base + 0x0800);
 		usbstat = readl(&dev->usb->usbstat);
-		dev->enhanced_mode = (usbstat & (1 << 11)) ? 1 : 0;
+		dev->enhanced_mode = (usbstat & BIT(11)) ? 1 : 0;
 		dev->n_ep = (dev->enhanced_mode) ? 9 : 5;
 		/* put into initial config, link up all endpoints */
 		fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
@@ -3729,12 +3725,14 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* enable lower-overhead pci memory bursts during DMA */
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
-		writel((1 << DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE)
-			// 256 write retries may not be enough...
-			// | (1 << PCI_RETRY_ABORT_ENABLE)
-			| (1 << DMA_READ_MULTIPLE_ENABLE)
-			| (1 << DMA_READ_LINE_ENABLE)
-			, &dev->pci->pcimstctl);
+		writel(BIT(DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE) |
+			/*
+			 * 256 write retries may not be enough...
+			   BIT(PCI_RETRY_ABORT_ENABLE) |
+			*/
+			BIT(DMA_READ_MULTIPLE_ENABLE) |
+			BIT(DMA_READ_LINE_ENABLE),
+			&dev->pci->pcimstctl);
 	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
 	pci_set_master (pdev);
 	pci_try_set_mwi (pdev);
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index 30478c8..e1c5d1a 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -116,9 +116,9 @@ struct net2280_ep {
 static inline void allow_status (struct net2280_ep *ep)
 {
 	/* ep0 only */
-	writel (  (1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
-		| (1 << CLEAR_NAK_OUT_PACKETS)
-		| (1 << CLEAR_NAK_OUT_PACKETS_MODE)
+	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE) |
+		BIT(CLEAR_NAK_OUT_PACKETS) |
+		BIT(CLEAR_NAK_OUT_PACKETS_MODE)
 		, &ep->regs->ep_rsp);
 	ep->stopped = 1;
 }
@@ -130,7 +130,7 @@ static void allow_status_338x(struct net2280_ep *ep)
 	 * packet arrived. While set, the chip automatically NAKs the host's
 	 * Status Phase tokens.
 	 */
-	writel(1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE, &ep->regs->ep_rsp);
+	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE), &ep->regs->ep_rsp);
 
 	ep->stopped = 1;
 
@@ -191,23 +191,24 @@ struct net2280 {
 static inline void set_halt (struct net2280_ep *ep)
 {
 	/* ep0 and bulk/intr endpoints */
-	writel (  (1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
-		    /* set NAK_OUT for erratum 0114 */
-		| ((ep->dev->chiprev == CHIPREV_1) << SET_NAK_OUT_PACKETS)
-		| (1 << SET_ENDPOINT_HALT)
-		, &ep->regs->ep_rsp);
+	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE) |
+		/* set NAK_OUT for erratum 0114 */
+		((ep->dev->chiprev == CHIPREV_1) << SET_NAK_OUT_PACKETS) |
+		BIT(SET_ENDPOINT_HALT),
+		&ep->regs->ep_rsp);
 }
 
 static inline void clear_halt (struct net2280_ep *ep)
 {
 	/* ep0 and bulk/intr endpoints */
-	writel (  (1 << CLEAR_ENDPOINT_HALT)
-		| (1 << CLEAR_ENDPOINT_TOGGLE)
-		    /* unless the gadget driver left a short packet in the
+	writel(BIT(CLEAR_ENDPOINT_HALT) |
+		BIT(CLEAR_ENDPOINT_TOGGLE) |
+		    /*
+		     * unless the gadget driver left a short packet in the
 		     * fifo, this reverses the erratum 0114 workaround.
 		     */
-		| ((ep->dev->chiprev == CHIPREV_1) << CLEAR_NAK_OUT_PACKETS)
-		, &ep->regs->ep_rsp);
+		((ep->dev->chiprev == CHIPREV_1) << CLEAR_NAK_OUT_PACKETS),
+		&ep->regs->ep_rsp);
 }
 
 /*
@@ -225,7 +226,7 @@ static inline void clear_halt (struct net2280_ep *ep)
  *  - Tip: Upon the first SS Control Read the FSM never
  *    returns to this state.
  */
-#define DEFECT7374_FSM_WAITING_FOR_CONTROL_READ (1 << DEFECT7374_FSM_FIELD)
+#define DEFECT7374_FSM_WAITING_FOR_CONTROL_READ BIT(DEFECT7374_FSM_FIELD)
 
 /* Non-SS Control Read:
  *  - A transition to this state indicates detection of the first HS
@@ -252,12 +253,12 @@ static inline void clear_halt (struct net2280_ep *ep)
 static inline void net2280_led_init (struct net2280 *dev)
 {
 	/* LED3 (green) is on during USB activity. note erratum 0113. */
-	writel ((1 << GPIO3_LED_SELECT)
-		| (1 << GPIO3_OUTPUT_ENABLE)
-		| (1 << GPIO2_OUTPUT_ENABLE)
-		| (1 << GPIO1_OUTPUT_ENABLE)
-		| (1 << GPIO0_OUTPUT_ENABLE)
-		, &dev->regs->gpioctl);
+	writel(BIT(GPIO3_LED_SELECT) |
+		BIT(GPIO3_OUTPUT_ENABLE) |
+		BIT(GPIO2_OUTPUT_ENABLE) |
+		BIT(GPIO1_OUTPUT_ENABLE) |
+		BIT(GPIO0_OUTPUT_ENABLE),
+		&dev->regs->gpioctl);
 }
 
 /* indicate speed with bi-color LED 0/1 */
@@ -267,18 +268,18 @@ void net2280_led_speed (struct net2280 *dev, enum usb_device_speed speed)
 	u32	val = readl (&dev->regs->gpioctl);
 	switch (speed) {
 	case USB_SPEED_SUPER:		/* green + red */
-		val |= (1 << GPIO0_DATA) | (1 << GPIO1_DATA);
+		val |= BIT(GPIO0_DATA) | BIT(GPIO1_DATA);
 		break;
 	case USB_SPEED_HIGH:		/* green */
-		val &= ~(1 << GPIO0_DATA);
-		val |= (1 << GPIO1_DATA);
+		val &= ~BIT(GPIO0_DATA);
+		val |= BIT(GPIO1_DATA);
 		break;
 	case USB_SPEED_FULL:		/* red */
-		val &= ~(1 << GPIO1_DATA);
-		val |= (1 << GPIO0_DATA);
+		val &= ~BIT(GPIO1_DATA);
+		val |= BIT(GPIO0_DATA);
 		break;
 	default:			/* (off/black) */
-		val &= ~((1 << GPIO1_DATA) | (1 << GPIO0_DATA));
+		val &= ~(BIT(GPIO1_DATA) | BIT(GPIO0_DATA));
 		break;
 	}
 	writel (val, &dev->regs->gpioctl);
@@ -356,7 +357,7 @@ static inline void set_fifo_bytecount(struct net2280_ep *ep, unsigned count)
 static inline void start_out_naking (struct net2280_ep *ep)
 {
 	/* NOTE:  hardware races lurk here, and PING protocol issues */
-	writel ((1 << SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
+	writel(BIT(SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 	/* synch with device */
 	readl (&ep->regs->ep_rsp);
 }
@@ -366,10 +367,10 @@ static inline void assert_out_naking (struct net2280_ep *ep, const char *where)
 {
 	u32	tmp = readl (&ep->regs->ep_stat);
 
-	if ((tmp & (1 << NAK_OUT_PACKETS)) == 0) {
+	if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
 		DEBUG (ep->dev, "%s %s %08x !NAK\n",
 				ep->ep.name, where, tmp);
-		writel ((1 << SET_NAK_OUT_PACKETS),
+		writel(BIT(SET_NAK_OUT_PACKETS),
 			&ep->regs->ep_rsp);
 	}
 }
@@ -383,8 +384,8 @@ static inline void stop_out_naking (struct net2280_ep *ep)
 	u32	tmp;
 
 	tmp = readl (&ep->regs->ep_stat);
-	if ((tmp & (1 << NAK_OUT_PACKETS)) != 0)
-		writel ((1 << CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
+	if ((tmp & BIT(NAK_OUT_PACKETS)) != 0)
+		writel(BIT(CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 }
 
 
-- 
2.0.0.rc0

