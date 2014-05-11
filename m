Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaEKIJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:09:15 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33569 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbaEKIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:08:44 -0400
From: Paul Davies C <pauldaviesc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, Paul Davies C <pauldaviesc@gmail.com>
Subject: [PATCH 3/3] Fix lines with more than 80 chars in staging/octeon-usb/octeon-hcd.c
Date: Sun, 11 May 2014 13:38:23 +0530
Message-Id: <1399795703-6681-4-git-send-email-pauldaviesc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
References: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lines with more than 80 characters are converted in to multiple lines.

Signed-off-by: Paul Davies C <pauldaviesc@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c |   89 +++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index d03095a..61dd242 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -462,7 +462,8 @@ struct octeon_hcd {
 	} while (0)
 
 /* Returns the IO address to push/pop stuff data from the FIFOs */
-#define USB_FIFO_ADDRESS(channel, usb_index) (CVMX_USBCX_GOTGCTL(usb_index) + ((channel)+1)*0x1000)
+#define USB_FIFO_ADDRESS(channel, usb_index) \
+	(CVMX_USBCX_GOTGCTL(usb_index) + ((channel)+1)*0x1000)
 
 /**
  * struct octeon_temp_buffer - a bounce buffer for USB transfers
@@ -1290,7 +1291,8 @@ static struct cvmx_usb_pipe *cvmx_usb_open_pipe(struct cvmx_usb_state *usb,
 	if (__cvmx_usb_pipe_needs_split(usb, pipe)) {
 		pipe->interval = interval*8;
 		/* Force start splits to be schedule on uFrame 0 */
-		pipe->next_tx_frame = ((usb->frame_number+7)&~7) + pipe->interval;
+		pipe->next_tx_frame = ((usb->frame_number+7)&~7) +
+					pipe->interval;
 	} else {
 		pipe->interval = interval;
 		pipe->next_tx_frame = usb->frame_number + pipe->interval;
@@ -1341,9 +1343,13 @@ static void __cvmx_usb_poll_rx_fifo(struct cvmx_usb_state *usb)
 		return;
 
 	/* Get where the DMA engine would have written this data */
-	address = __cvmx_usb_read_csr64(usb, CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8);
+	address = __cvmx_usb_read_csr64(usb,
+			CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8);
+
 	ptr = cvmx_phys_to_ptr(address);
-	__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8, address + bytes);
+	__cvmx_usb_write_csr64(usb,
+			       CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8,
+			       address + bytes);
 
 	/* Loop writing the FIFO data for this packet into memory */
 	while (bytes > 0) {
@@ -1548,19 +1554,27 @@ static void __cvmx_usb_start_channel_control(struct cvmx_usb_state *usb,
 		usbc_hctsiz.s.pid = 3; /* Setup */
 		bytes_to_transfer = sizeof(*header);
 		/* All Control operations start with a setup going OUT */
-		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index), union cvmx_usbcx_hccharx, epdir, CVMX_USB_DIRECTION_OUT);
+		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index),
+				union cvmx_usbcx_hccharx, epdir,
+				CVMX_USB_DIRECTION_OUT);
 		/*
 		 * Setup send the control header instead of the buffer data. The
 		 * buffer data will be used in the next stage
 		 */
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8, transaction->control_header);
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8,
+			transaction->control_header);
 		break;
 	case CVMX_USB_STAGE_SETUP_SPLIT_COMPLETE:
 		usbc_hctsiz.s.pid = 3; /* Setup */
 		bytes_to_transfer = 0;
 		/* All Control operations start with a setup going OUT */
-		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index), union cvmx_usbcx_hccharx, epdir, CVMX_USB_DIRECTION_OUT);
-		USB_SET_FIELD32(CVMX_USBCX_HCSPLTX(channel, usb->index), union cvmx_usbcx_hcspltx, compsplt, 1);
+		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index),
+				union cvmx_usbcx_hccharx, epdir,
+				CVMX_USB_DIRECTION_OUT);
+
+		USB_SET_FIELD32(CVMX_USBCX_HCSPLTX(channel, usb->index),
+				union cvmx_usbcx_hcspltx, compsplt, 1);
 		break;
 	case CVMX_USB_STAGE_DATA:
 		usbc_hctsiz.s.pid = __cvmx_usb_get_data_pid(pipe);
@@ -1690,6 +1704,7 @@ static void __cvmx_usb_start_channel(struct cvmx_usb_state *usb,
 		/* Clear all channel status bits */
 		usbc_hcint.u32 = __cvmx_usb_read_csr32(usb,
 				CVMX_USBCX_HCINTX(channel, usb->index));
+
 		__cvmx_usb_write_csr32(usb,
 				       CVMX_USBCX_HCINTX(channel, usb->index),
 				       usbc_hcint.u32);
@@ -1720,19 +1735,31 @@ static void __cvmx_usb_start_channel(struct cvmx_usb_state *usb,
 		__cvmx_usb_write_csr32(usb, CVMX_USBCX_HCINTMSKX(channel, usb->index), usbc_hcintmsk.u32);
 
 		/* Enable the channel interrupt to propagate */
-		usbc_haintmsk.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HAINTMSK(usb->index));
+		usbc_haintmsk.u32 = __cvmx_usb_read_csr32(usb,
+					CVMX_USBCX_HAINTMSK(usb->index));
 		usbc_haintmsk.s.haintmsk |= 1<<channel;
-		__cvmx_usb_write_csr32(usb, CVMX_USBCX_HAINTMSK(usb->index), usbc_haintmsk.u32);
+		__cvmx_usb_write_csr32(usb,
+					CVMX_USBCX_HAINTMSK(usb->index),
+					usbc_haintmsk.u32);
 	}
 
 	/* Setup the locations the DMA engines use  */
 	{
-		uint64_t dma_address = transaction->buffer + transaction->actual_bytes;
+		uint64_t dma_address = transaction->buffer +
+					transaction->actual_bytes;
 
 		if (transaction->type == CVMX_USB_TRANSFER_ISOCHRONOUS)
-			dma_address = transaction->buffer + transaction->iso_packets[0].offset + transaction->actual_bytes;
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8, dma_address);
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8, dma_address);
+			dma_address = transaction->buffer +
+					transaction->iso_packets[0].offset +
+					transaction->actual_bytes;
+
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8,
+			dma_address);
+
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8,
+			dma_address);
 	}
 
 	/* Setup both the size of the transfer and the SPLIT characteristics */
@@ -2043,8 +2070,15 @@ static void __cvmx_usb_schedule(struct cvmx_usb_state *usb, int is_sof)
 		 * Without DMA we need to be careful to not schedule something
 		 * at the end of a frame and cause an overrun.
 		 */
-		union cvmx_usbcx_hfnum hfnum = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFNUM(usb->index))};
-		union cvmx_usbcx_hfir hfir = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFIR(usb->index))};
+		union cvmx_usbcx_hfnum hfnum = {
+			.u32 = __cvmx_usb_read_csr32(usb,
+						CVMX_USBCX_HFNUM(usb->index))
+		};
+
+		union cvmx_usbcx_hfir hfir = {
+			.u32 = __cvmx_usb_read_csr32(usb,
+						CVMX_USBCX_HFIR(usb->index))
+		};
 
 		if (hfnum.s.frrem < hfir.s.frint/4)
 			goto done;
@@ -2663,7 +2697,9 @@ static int __cvmx_usb_poll_channel(struct cvmx_usb_state *usb, int channel)
 	}
 
 	/* Disable the channel interrupts now that it is done */
-	__cvmx_usb_write_csr32(usb, CVMX_USBCX_HCINTMSKX(channel, usb->index), 0);
+	__cvmx_usb_write_csr32(usb,
+				CVMX_USBCX_HCINTMSKX(channel, usb->index),
+				0);
 	usb->idle_hardware_channels |= (1<<channel);
 
 	/* Make sure this channel is tied to a valid pipe */
@@ -3030,7 +3066,8 @@ static int __cvmx_usb_poll_channel(struct cvmx_usb_state *usb, int channel)
 					 */
 					if (!buffer_space_left ||
 						(bytes_this_transfer < 188)) {
-						pipe->next_tx_frame += pipe->interval;
+						pipe->next_tx_frame +=
+							pipe->interval;
 						__cvmx_usb_perform_complete(
 							usb,
 							pipe,
@@ -3140,17 +3177,21 @@ static int cvmx_usb_poll(struct cvmx_usb_state *usb)
 	CVMX_PREFETCH(usb, 4*128);
 
 	/* Update the frame counter */
-	usbc_hfnum.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFNUM(usb->index));
+	usbc_hfnum.u32 = __cvmx_usb_read_csr32(usb,
+						CVMX_USBCX_HFNUM(usb->index));
 	if ((usb->frame_number&0x3fff) > usbc_hfnum.s.frnum)
 		usb->frame_number += 0x4000;
 	usb->frame_number &= ~0x3fffull;
 	usb->frame_number |= usbc_hfnum.s.frnum;
 
 	/* Read the pending interrupts */
-	usbc_gintsts.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_GINTSTS(usb->index));
+	usbc_gintsts.u32 = __cvmx_usb_read_csr32(usb,
+						CVMX_USBCX_GINTSTS(usb->index));
 
 	/* Clear the interrupts now that we know about them */
-	__cvmx_usb_write_csr32(usb, CVMX_USBCX_GINTSTS(usb->index), usbc_gintsts.u32);
+	__cvmx_usb_write_csr32(usb,
+				CVMX_USBCX_GINTSTS(usb->index),
+				usbc_gintsts.u32);
 
 	if (usbc_gintsts.s.rxflvl) {
 		/*
@@ -3207,7 +3248,8 @@ static int cvmx_usb_poll(struct cvmx_usb_state *usb)
 		 */
 		union cvmx_usbcx_haint usbc_haint;
 
-		usbc_haint.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HAINT(usb->index));
+		usbc_haint.u32 = __cvmx_usb_read_csr32(usb,
+					CVMX_USBCX_HAINT(usb->index));
 		while (usbc_haint.u32) {
 			int channel;
 
@@ -3500,7 +3542,8 @@ static int octeon_usb_hub_status_data(struct usb_hcd *hcd, char *buf)
 	return (buf[0] != 0);
 }
 
-static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex, char *buf, u16 wLength)
+static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+				u16 wIndex, char *buf, u16 wLength)
 {
 	struct octeon_hcd *priv = hcd_to_octeon(hcd);
 	struct device *dev = hcd->self.controller;
-- 
1.7.9.5

