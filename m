Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaGAHMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:12:40 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52786 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaGAHMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:12:38 -0400
From: Raphael Poggi <poggi.raph@gmail.com>
To: m.chehab@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Raphael Poggi <poggi.raph@gmail.com>
Subject: [PATCH 1/2 RESEND] staging: lirc: fix checkpath errors: blank lines
Date: Tue,  1 Jul 2014 09:12:33 +0200
Message-Id: <1404198754-5029-1-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpath "WARNING: Missing a blank line after declarations"

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index a5b62ee..f8c3375 100644
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
@@ -656,6 +657,7 @@ static void imon_incoming_packet(struct imon_context *context,
 		mask = 0x80;
 		for (bit = 0; bit < 8; ++bit) {
 			int curr_bit = !(buf[octet] & mask);
+
 			if (curr_bit != context->rx.prev_bit) {
 				if (context->rx.count) {
 					submit_data(context);
@@ -775,6 +777,7 @@ static int imon_probe(struct usb_interface *interface,
 		struct usb_endpoint_descriptor *ep;
 		int ep_dir;
 		int ep_type;
+
 		ep = &iface_desc->endpoint[i].desc;
 		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
 		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
-- 
1.7.9.5

