Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaETQbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:31:35 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41096 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaETQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:30:37 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 08/10 v2.1] usb: gadget: net2280: Code Cleanup
Date: Tue, 20 May 2014 18:30:10 +0200
Message-Id: <1400603412-19406-9-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Move logical continuations to end of line
- Improve spacing

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v2: Comments by Alan Stern
	-Use octal notation istead of S_I

 drivers/usb/gadget/net2280.c | 155 +++++++++++++++++++++----------------------
 drivers/usb/gadget/net2280.h |   4 +-
 2 files changed, 78 insertions(+), 81 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d1d4f4f..d506c83 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -100,9 +100,9 @@ static bool use_dma_chaining;
 static bool use_msi = true;
 
 /* "modprobe net2280 use_dma=n" etc */
-module_param(use_dma, bool, S_IRUGO);
-module_param(use_dma_chaining, bool, S_IRUGO);
-module_param(use_msi, bool, S_IRUGO);
+module_param(use_dma, bool, 0444);
+module_param(use_dma_chaining, bool, 0444);
+module_param(use_msi, bool, 0444);
 
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
  * mode 1 == ep-{a,b} 2K fifo each, ep-{c,d} unavailable
@@ -111,7 +111,7 @@ module_param(use_msi, bool, S_IRUGO);
 static ushort fifo_mode;
 
 /* "modprobe net2280 fifo_mode=1" etc */
-module_param (fifo_mode, ushort, 0644);
+module_param(fifo_mode, ushort, 0644);
 
 /* enable_suspend -- When enabled, the driver will respond to
  * USB suspend requests by powering down the NET2280.  Otherwise,
@@ -121,7 +121,7 @@ module_param (fifo_mode, ushort, 0644);
 static bool enable_suspend;
 
 /* "modprobe net2280 enable_suspend=1" etc */
-module_param(enable_suspend, bool, S_IRUGO);
+module_param(enable_suspend, bool, 0444);
 
 /* force full-speed operation */
 static bool full_speed;
@@ -169,8 +169,8 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	static const u32 ep_key[9] = { 1, 0, 1, 0, 1, 1, 0, 1, 0 };
 
 	ep = container_of(_ep, struct net2280_ep, ep);
-	if (!_ep || !desc || ep->desc || _ep->name == ep0name
-			|| desc->bDescriptorType != USB_DT_ENDPOINT)
+	if (!_ep || !desc || ep->desc || _ep->name == ep0name ||
+			desc->bDescriptorType != USB_DT_ENDPOINT)
 		return -EINVAL;
 	dev = ep->dev;
 	if (!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN)
@@ -220,9 +220,9 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	tmp = (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
 	if (tmp == USB_ENDPOINT_XFER_INT) {
 		/* erratum 0105 workaround prevents hs NYET */
-		if (dev->chiprev == 0100
-				&& dev->gadget.speed == USB_SPEED_HIGH
-				&& !(desc->bEndpointAddress & USB_DIR_IN))
+		if (dev->chiprev == 0100 &&
+				dev->gadget.speed == USB_SPEED_HIGH &&
+				!(desc->bEndpointAddress & USB_DIR_IN))
 			writel(BIT(CLEAR_NAK_OUT_PACKETS_MODE),
 				&ep->regs->ep_rsp);
 	} else if (tmp == USB_ENDPOINT_XFER_BULK) {
@@ -402,8 +402,8 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 		BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
 		BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
 		BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
-		BIT(DATA_IN_TOKEN_INTERRUPT)
-		, &ep->regs->ep_stat);
+		BIT(DATA_IN_TOKEN_INTERRUPT),
+		&ep->regs->ep_stat);
 
 	/* fifo size is handled separately */
 }
@@ -425,9 +425,9 @@ static void ep_reset_338x(struct net2280_regs __iomem *regs,
 		writel(BIT(DMA_ABORT_DONE_INTERRUPT) |
 		       BIT(DMA_PAUSE_DONE_INTERRUPT) |
 		       BIT(DMA_SCATTER_GATHER_DONE_INTERRUPT) |
-		       BIT(DMA_TRANSACTION_DONE_INTERRUPT)
-		       /* | BIT(DMA_ABORT) */
-		       , &ep->dma->dmastat);
+		       BIT(DMA_TRANSACTION_DONE_INTERRUPT),
+		       /* | BIT(DMA_ABORT), */
+		       &ep->dma->dmastat);
 
 		dmastat = readl(&ep->dma->dmastat);
 		if (dmastat == 0x5002) {
@@ -618,15 +618,15 @@ static void out_flush(struct net2280_ep *ep)
 
 	statp = &ep->regs->ep_stat;
 	writel(BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
-		BIT(DATA_PACKET_RECEIVED_INTERRUPT)
-		, statp);
+		BIT(DATA_PACKET_RECEIVED_INTERRUPT),
+		statp);
 	writel(BIT(FIFO_FLUSH), statp);
 	/* Make sure that stap is written */
 	mb();
 	tmp = readl(statp);
-	if (tmp & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)
+	if (tmp & BIT(DATA_OUT_PING_TOKEN_INTERRUPT) &&
 			/* high speed did bulk NYET; fifo isn't filling */
-			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
+			ep->dev->gadget.speed == USB_SPEED_FULL) {
 		unsigned	usec;
 
 		usec = 50;		/* 64 byte bulk/interrupt */
@@ -653,8 +653,8 @@ static int read_fifo(struct net2280_ep *ep, struct net2280_request *req)
 	/* erratum 0106 ... packets coming in during fifo reads might
 	 * be incompletely rejected.  not all cases have workarounds.
 	 */
-	if (ep->dev->chiprev == 0x0100
-			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
+	if (ep->dev->chiprev == 0x0100 &&
+			ep->dev->gadget.speed == USB_SPEED_FULL) {
 		udelay(1);
 		tmp = readl(&ep->regs->ep_stat);
 		if ((tmp & BIT(NAK_OUT_PACKETS)))
@@ -726,8 +726,8 @@ static int read_fifo(struct net2280_ep *ep, struct net2280_request *req)
 		(void) readl(&ep->regs->ep_rsp);
 	}
 
-	return is_short || ((req->req.actual == req->req.length)
-				&& !req->req.zero);
+	return is_short || ((req->req.actual == req->req.length) &&
+			!req->req.zero);
 }
 
 /* fill out dma descriptor to match a given request */
@@ -744,8 +744,8 @@ static void fill_dma_desc(struct net2280_ep *ep,
 	 */
 	if (ep->is_in)
 		dmacount |= BIT(DMA_DIRECTION);
-	if ((!ep->is_in && (dmacount % ep->ep.maxpacket) != 0)
-			|| ep->dev->pdev->device != 0x2280)
+	if ((!ep->is_in && (dmacount % ep->ep.maxpacket) != 0) ||
+					ep->dev->pdev->device != 0x2280)
 		dmacount |= BIT(END_OF_CHAIN);
 
 	req->valid = valid;
@@ -836,8 +836,8 @@ static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 
 			/* dma irq, faking scatterlist status */
 			req->td->dmacount = cpu_to_le32(req->req.length - tmp);
-			writel(BIT(DMA_DONE_INTERRUPT_ENABLE)
-				| tmp, &dma->dmacount);
+			writel(BIT(DMA_DONE_INTERRUPT_ENABLE) | tmp,
+					&dma->dmacount);
 			req->td->dmadesc = 0;
 			req->valid = 1;
 
@@ -1120,8 +1120,8 @@ static void scan_dma_completions(struct net2280_ep *ep)
 			/* single transfer mode */
 			dma_done(ep, req, tmp, 0);
 			break;
-		} else if (!ep->is_in
-				&& (req->req.length % ep->ep.maxpacket) != 0) {
+		} else if (!ep->is_in &&
+				(req->req.length % ep->ep.maxpacket) != 0) {
 			tmp = readl(&ep->regs->ep_stat);
 			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 				return dma_done(ep, req, tmp, 0);
@@ -1317,8 +1317,8 @@ static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			writel(le32_to_cpu(req->td->dmadesc),
 				&ep->dma->dmadesc);
 			if (req->td->dmacount & dma_done_ie)
-				writel(readl(&ep->dma->dmacount)
-						| le32_to_cpu(dma_done_ie),
+				writel(readl(&ep->dma->dmacount) |
+						le32_to_cpu(dma_done_ie),
 					&ep->dma->dmacount);
 		} else {
 			struct net2280_request	*prev;
@@ -2255,8 +2255,8 @@ static void ep0_start_228x(struct net2280 *dev)
 {
 	writel(BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
 		BIT(CLEAR_NAK_OUT_PACKETS) |
-		BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
-		, &dev->epregs[0].ep_rsp);
+		BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
+		&dev->epregs[0].ep_rsp);
 
 	/*
 	 * hardware optionally handles a bunch of standard requests
@@ -2268,8 +2268,8 @@ static void ep0_start_228x(struct net2280 *dev)
 		BIT(SET_ADDRESS) |
 		BIT(DEVICE_SET_CLEAR_DEVICE_REMOTE_WAKEUP) |
 		BIT(GET_DEVICE_STATUS) |
-		BIT(GET_INTERFACE_STATUS)
-		, &dev->usb->stdrsp);
+		BIT(GET_INTERFACE_STATUS),
+		&dev->usb->stdrsp);
 	writel(BIT(USB_ROOT_PORT_WAKEUP_ENABLE) |
 		BIT(SELF_POWERED_USB_DEVICE) |
 		BIT(REMOTE_WAKEUP_SUPPORT) |
@@ -2330,8 +2330,8 @@ static void ep0_start_338x(struct net2280 *dev)
 
 	/* enable irqs so we can see ep0 and general operation  */
 	writel(BIT(SETUP_PACKET_INTERRUPT_ENABLE) |
-	       BIT(ENDPOINT_0_INTERRUPT_ENABLE)
-	       , &dev->regs->pciirqenb0);
+	       BIT(ENDPOINT_0_INTERRUPT_ENABLE),
+	       &dev->regs->pciirqenb0);
 	writel(BIT(PCI_INTERRUPT_ENABLE) |
 	       BIT(ROOT_PORT_RESET_INTERRUPT_ENABLE) |
 	       BIT(SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE) |
@@ -2366,8 +2366,8 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 * (dev->usb->xcvrdiag & FORCE_FULL_SPEED_MODE)
 	 * "must not be used in normal operation"
 	 */
-	if (!driver || driver->max_speed < USB_SPEED_HIGH
-			|| !driver->setup)
+	if (!driver || driver->max_speed < USB_SPEED_HIGH ||
+			!driver->setup)
 		return -EINVAL;
 
 	dev = container_of(_gadget, struct net2280, gadget);
@@ -2542,10 +2542,10 @@ static void handle_ep_small(struct net2280_ep *ep)
 				}
 				mode = 2;
 			/* an extra OUT token is an error */
-			} else if (((t & BIT(DATA_OUT_PING_TOKEN_INTERRUPT))
-					&& req
-					&& req->req.actual == req->req.length)
-					|| (ep->responded && !req)) {
+			} else if (((t & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)) &&
+					req &&
+					req->req.actual == req->req.length) ||
+					(ep->responded && !req)) {
 				ep->dev->protocol_stall = 1;
 				set_halt(ep);
 				ep->stopped = 1;
@@ -2576,8 +2576,8 @@ static void handle_ep_small(struct net2280_ep *ep)
 				 * dma handles (M >= N), may empty the queue
 				 */
 				scan_dma_completions(ep);
-				if (unlikely(list_empty(&ep->queue)
-						|| ep->out_overflow)) {
+				if (unlikely(list_empty(&ep->queue) ||
+						ep->out_overflow)) {
 					req = NULL;
 					break;
 				}
@@ -2611,10 +2611,10 @@ static void handle_ep_small(struct net2280_ep *ep)
 			}
 
 			/* also flush to prevent erratum 0106 trouble */
-			if (unlikely(ep->out_overflow
-					|| (ep->dev->chiprev == 0x0100
-						&& ep->dev->gadget.speed
-							== USB_SPEED_FULL))) {
+			if (unlikely(ep->out_overflow ||
+					(ep->dev->chiprev == 0x0100 &&
+					ep->dev->gadget.speed
+					== USB_SPEED_FULL))) {
 				out_flush(ep);
 				ep->out_overflow = 0;
 			}
@@ -2808,9 +2808,9 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 		val = readl(&ep->regs->ep_rsp);
 		val |= BIT(CLEAR_ENDPOINT_HALT) |
 			BIT(CLEAR_ENDPOINT_TOGGLE);
-		writel(val
-		       /* | BIT(CLEAR_NAK_PACKETS)*/
-		       , &ep->regs->ep_rsp);
+		writel(val,
+		       /* | BIT(CLEAR_NAK_PACKETS),*/
+		       &ep->regs->ep_rsp);
 		ep->is_halt = 0;
 		val = readl(&ep->regs->ep_rsp);
 	}
@@ -3125,8 +3125,8 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 				   BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
 				   BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
 				   BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
-				   BIT(DATA_IN_TOKEN_INTERRUPT)
-				   , &ep->regs->ep_stat);
+				   BIT(DATA_IN_TOKEN_INTERRUPT),
+				   &ep->regs->ep_stat);
 		}
 		u.raw[0] = readl(&dev->usb->setup0123);
 		u.raw[1] = readl(&dev->usb->setup4567);
@@ -3206,8 +3206,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			/* hw handles device features */
 			if (u.r.bRequestType != USB_RECIP_ENDPOINT)
 				goto delegate;
-			if (w_value != USB_ENDPOINT_HALT
-					|| w_length != 0)
+			if (w_value != USB_ENDPOINT_HALT || w_length != 0)
 				goto do_stall;
 			e = get_ep_by_addr(dev, w_index);
 			if (!e)
@@ -3233,8 +3232,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			/* hw handles device features */
 			if (u.r.bRequestType != USB_RECIP_ENDPOINT)
 				goto delegate;
-			if (w_value != USB_ENDPOINT_HALT
-					|| w_length != 0)
+			if (w_value != USB_ENDPOINT_HALT || w_length != 0)
 				goto do_stall;
 			e = get_ep_by_addr(dev, w_index);
 			if (!e)
@@ -3326,12 +3324,11 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 	 */
 	if (stat & tmp) {
 		writel(tmp, &dev->regs->irqstat1);
-		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT))
-					&& ((readl(&dev->usb->usbstat) & mask)
-							== 0))
-				|| ((readl(&dev->usb->usbctl)
-					& BIT(VBUS_PIN)) == 0)
-			    ) && (dev->gadget.speed != USB_SPEED_UNKNOWN)) {
+		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT)) &&
+				(readl(&dev->usb->usbstat) & mask)) ||
+				((readl(&dev->usb->usbctl) &
+					BIT(VBUS_PIN)) == 0)) &&
+				(dev->gadget.speed != USB_SPEED_UNKNOWN)) {
 			DEBUG(dev, "disconnect %s\n",
 					dev->driver->driver.name);
 			stop_activity(dev, dev->driver);
@@ -3560,7 +3557,7 @@ static void net2280_remove(struct pci_dev *pdev)
 		pci_disable_device(pdev);
 	device_remove_file(&pdev->dev, &dev_attr_registers);
 
-	INFO (dev, "unbind\n");
+	INFO(dev, "unbind\n");
 }
 
 /* wrap this driver around the specified device, but
@@ -3783,29 +3780,29 @@ static const struct pci_device_id pci_ids[] = { {
 	.device =	0x2280,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
-}, {
+	}, {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
 	.vendor =	PCI_VENDOR_ID_PLX_LEGACY,
 	.device =	0x2282,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
-},
+	},
 	{
-	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
-	 .class_mask = ~0,
-	 .vendor = PCI_VENDOR_ID_PLX,
-	 .device = 0x3380,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
+	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
+	.class_mask =	~0,
+	.vendor =	PCI_VENDOR_ID_PLX,
+	.device =	0x3380,
+	.subvendor =	PCI_ANY_ID,
+	.subdevice =	PCI_ANY_ID,
 	 },
 	{
-	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
-	 .class_mask = ~0,
-	 .vendor = PCI_VENDOR_ID_PLX,
-	 .device = 0x3382,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
+	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
+	.class_mask =	~0,
+	.vendor =	PCI_VENDOR_ID_PLX,
+	.device =	0x3382,
+	.subvendor =	PCI_ANY_ID,
+	.subdevice =	PCI_ANY_ID,
 	 },
 { /* end: all zeroes */ }
 };
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index f019d6c..77c39d9 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -117,8 +117,8 @@ static inline void allow_status(struct net2280_ep *ep)
 	/* ep0 only */
 	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE) |
 		BIT(CLEAR_NAK_OUT_PACKETS) |
-		BIT(CLEAR_NAK_OUT_PACKETS_MODE)
-		, &ep->regs->ep_rsp);
+		BIT(CLEAR_NAK_OUT_PACKETS_MODE),
+		&ep->regs->ep_rsp);
 	ep->stopped = 1;
 }
 
-- 
2.0.0.rc2

