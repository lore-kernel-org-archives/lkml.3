Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaEKIIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:08:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47412 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbaEKIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:08:37 -0400
From: Paul Davies C <pauldaviesc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, Paul Davies C <pauldaviesc@gmail.com>
Subject: [PATCH 1/3] Add blank line after all declarations in staging/octeon-usb/octeon-hcd.c
Date: Sun, 11 May 2014 13:38:21 +0530
Message-Id: <1399795703-6681-2-git-send-email-pauldaviesc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
References: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blank lines are added after each declaration in the file.

Signed-off-by: Paul Davies C <pauldaviesc@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8b8ce72..a65d6f8 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -892,6 +892,7 @@ static int cvmx_usb_initialize(struct cvmx_usb_state *usb,
 	 */
 	{
 		union cvmx_usbcx_gusbcfg usbcx_gusbcfg;
+
 		usbcx_gusbcfg.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_GUSBCFG(usb->index));
 		usbcx_gusbcfg.s.toutcal = 0;
@@ -949,6 +950,7 @@ static int cvmx_usb_initialize(struct cvmx_usb_state *usb,
 		 */
 		{
 			union cvmx_usbcx_hcfg usbcx_hcfg;
+
 			usbcx_hcfg.u32 = __cvmx_usb_read_csr32(usb,
 					CVMX_USBCX_HCFG(usb->index));
 			usbcx_hcfg.s.fslssupp = 0;
@@ -1076,6 +1078,7 @@ static int cvmx_usb_enable(struct cvmx_usb_state *usb)
 	 */
 	{
 		union cvmx_usbcx_gnptxfsiz siz;
+
 		siz.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_GNPTXFSIZ(usb->index));
 		siz.s.nptxfdep = usbcx_ghwcfg3.s.dfifodepth / 2;
@@ -1090,6 +1093,7 @@ static int cvmx_usb_enable(struct cvmx_usb_state *usb)
 	 */
 	{
 		union cvmx_usbcx_hptxfsiz siz;
+
 		siz.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_HPTXFSIZ(usb->index));
 		siz.s.ptxfsize = usbcx_ghwcfg3.s.dfifodepth / 4;
@@ -1219,8 +1223,8 @@ static struct cvmx_usb_port_status cvmx_usb_get_status(
  * Returns: A non-NULL value is a pipe. NULL means an error.
  */
 static struct cvmx_usb_pipe *cvmx_usb_open_pipe(struct cvmx_usb_state *usb,
-						int device_addr, int
-						endpoint_num,
+						int device_addr,
+						int endpoint_num,
 						enum cvmx_usb_speed
 							device_speed,
 						int max_packet,
@@ -1423,6 +1427,7 @@ static void __cvmx_usb_poll_tx_fifo(struct cvmx_usb_state *usb)
 {
 	if (usb->periodic.head != usb->periodic.tail) {
 		union cvmx_usbcx_hptxsts tx_status;
+
 		tx_status.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_HPTXSTS(usb->index));
 		if (__cvmx_usb_fill_tx_hw(usb, &usb->periodic,
@@ -1438,6 +1443,7 @@ static void __cvmx_usb_poll_tx_fifo(struct cvmx_usb_state *usb)
 
 	if (usb->nonperiodic.head != usb->nonperiodic.tail) {
 		union cvmx_usbcx_gnptxsts tx_status;
+
 		tx_status.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_GNPTXSTS(usb->index));
 		if (__cvmx_usb_fill_tx_hw(usb, &usb->nonperiodic,
@@ -1722,6 +1728,7 @@ static void __cvmx_usb_start_channel(struct cvmx_usb_state *usb,
 	/* Setup the locations the DMA engines use  */
 	{
 		uint64_t dma_address = transaction->buffer + transaction->actual_bytes;
+
 		if (transaction->type == CVMX_USB_TRANSFER_ISOCHRONOUS)
 			dma_address = transaction->buffer + transaction->iso_packets[0].offset + transaction->actual_bytes;
 		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8, dma_address);
@@ -2038,6 +2045,7 @@ static void __cvmx_usb_schedule(struct cvmx_usb_state *usb, int is_sof)
 		 */
 		union cvmx_usbcx_hfnum hfnum = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFNUM(usb->index))};
 		union cvmx_usbcx_hfir hfir = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFIR(usb->index))};
+
 		if (hfnum.s.frrem < hfir.s.frint/4)
 			goto done;
 	}
@@ -2522,6 +2530,7 @@ static int cvmx_usb_cancel_all(struct cvmx_usb_state *usb,
 	/* Simply loop through and attempt to cancel each transaction */
 	list_for_each_entry_safe(transaction, next, &pipe->transactions, node) {
 		int result = cvmx_usb_cancel(usb, pipe, transaction);
+
 		if (unlikely(result != 0))
 			return result;
 	}
@@ -3083,6 +3092,7 @@ static int __cvmx_usb_poll_channel(struct cvmx_usb_state *usb, int channel)
 				pipe->interval;
 	} else {
 		struct cvmx_usb_port_status port;
+
 		port = cvmx_usb_get_status(usb);
 		if (port.port_enabled) {
 			/* We'll retry the exact same transaction again */
@@ -3196,6 +3206,7 @@ static int cvmx_usb_poll(struct cvmx_usb_state *usb)
 		 * to clear this bit.
 		 */
 		union cvmx_usbcx_haint usbc_haint;
+
 		usbc_haint.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HAINT(usb->index));
 		while (usbc_haint.u32) {
 			int channel;
@@ -3267,6 +3278,7 @@ static int octeon_usb_urb_enqueue(struct usb_hcd *hcd,
 		enum cvmx_usb_speed speed;
 		int split_device = 0;
 		int split_port = 0;
+
 		switch (usb_pipetype(urb->pipe)) {
 		case PIPE_ISOCHRONOUS:
 			transfer_type = CVMX_USB_TRANSFER_ISOCHRONOUS;
@@ -3303,6 +3315,7 @@ static int octeon_usb_urb_enqueue(struct usb_hcd *hcd,
 			 * tree.
 			 */
 			struct usb_device *dev = urb->dev;
+
 			while (dev->parent) {
 				/*
 				 * If our parent is high speed then he'll
@@ -3462,6 +3475,7 @@ static void octeon_usb_endpoint_disable(struct usb_hcd *hcd,
 		struct octeon_hcd *priv = hcd_to_octeon(hcd);
 		struct cvmx_usb_pipe *pipe = ep->hcpriv;
 		unsigned long flags;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		cvmx_usb_cancel_all(&priv->usb, pipe);
 		if (cvmx_usb_close_pipe(&priv->usb, pipe))
@@ -3778,6 +3792,7 @@ static int octeon_usb_probe(struct platform_device *pdev)
 	if (irq < 0) {
 		/* Defective device tree, but we know how to fix it. */
 		irq_hw_number_t hwirq = usb_num ? (1 << 6) + 17 : 56;
+
 		irq = irq_create_mapping(NULL, hwirq);
 	}
 
-- 
1.7.9.5

