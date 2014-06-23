Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaFWNkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:40:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40041 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaFWNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:40:27 -0400
From: Raphael Poggi <poggi.raph@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Raphael Poggi <poggi.raph@gmail.com>
Subject: [PATCH] staging: lirc: fix coding style problems
Date: Mon, 23 Jun 2014 15:40:59 +0200
Message-Id: <1403530859-3341-1-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix some coding style problems.

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index a5b62ee..31d5c6b 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -189,6 +189,7 @@ MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
 static void free_imon_context(struct imon_context *context)
 {
 	struct device *dev = context->driver->dev;
+
 	usb_free_urb(context->tx_urb);
 	usb_free_urb(context->rx_urb);
 	lirc_buffer_free(context->driver->rbuf);
@@ -481,8 +482,6 @@ static void usb_tx_callback(struct urb *urb)
 	/* notify waiters that write has finished */
 	atomic_set(&context->tx.busy, 0);
 	complete(&context->tx.finished);
-
-	return;
 }
 
 /**
@@ -547,7 +546,6 @@ static void ir_close(void *data)
 	}
 
 	mutex_unlock(&context->ctx_lock);
-	return;
 }
 
 /**
@@ -572,7 +570,6 @@ static void submit_data(struct imon_context *context)
 
 	lirc_buffer_write(context->driver->rbuf, buf);
 	wake_up(&context->driver->rbuf->wait_poll);
-	return;
 }
 
 static inline int tv2int(const struct timeval *a, const struct timeval *b)
@@ -626,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
 	if (debug) {
 		dev_info(dev, "raw packet: ");
 		for (i = 0; i < len; ++i)
-			printk("%02x ", buf[i]);
-		printk("\n");
+			dev_dbg(dev, "%02x ", buf[i]);
+		dev_dbg(dev, "\n");
 	}
 
 	/*
@@ -656,6 +653,7 @@ static void imon_incoming_packet(struct imon_context *context,
 		mask = 0x80;
 		for (bit = 0; bit < 8; ++bit) {
 			int curr_bit = !(buf[octet] & mask);
+
 			if (curr_bit != context->rx.prev_bit) {
 				if (context->rx.count) {
 					submit_data(context);
@@ -707,8 +705,6 @@ static void usb_rx_callback(struct urb *urb)
 	}
 
 	usb_submit_urb(context->rx_urb, GFP_ATOMIC);
-
-	return;
 }
 
 /**
@@ -775,6 +771,7 @@ static int imon_probe(struct usb_interface *interface,
 		struct usb_endpoint_descriptor *ep;
 		int ep_dir;
 		int ep_type;
+
 		ep = &iface_desc->endpoint[i].desc;
 		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
 		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
-- 
1.7.9.5

