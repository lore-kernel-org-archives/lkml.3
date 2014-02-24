Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaBXXON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:14:13 -0500
Received: from home.keithp.com ([63.227.221.253]:55000 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaBXXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:14:12 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Subject: [PATCH] net/usb: Add Lenovo ThinkPad OneLink GigaLAN USB ID to ax88179 driver
Date: Mon, 24 Feb 2014 15:13:49 -0800
Message-Id: <1393283629-25396-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lenovo OneLink dock includes a USB ethernet adapter using the
AX88179 chip, but with a different USB ID. Add this new USB id to the
driver so that it will autodetect the adapter correctly.

Signed-off-by: Keith Packard <keithp@keithp.com>
Tested-by: Carl Worth <cworth@cworth.org>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 8e8d0fc..dcf974f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1418,6 +1418,19 @@ static const struct driver_info samsung_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info lenovo_info = {
+	.description = "ThinkPad OneLink Dock USB GigaLAN",
+	.bind = ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset = ax88179_reset,
+	.stop = ax88179_stop,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1435,6 +1448,10 @@ static const struct usb_device_id products[] = {
 	/* Samsung USB Ethernet Adapter */
 	USB_DEVICE(0x04e8, 0xa100),
 	.driver_info = (unsigned long)&samsung_info,
+}, {
+	/* Lenovo ThinkPad OneLink GigaLAN */
+	USB_DEVICE(0x17ef, 0x304b),
+	.driver_info = (unsigned long)&samsung_info,
 },
 	{ },
 };
-- 
1.9.0

