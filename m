Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaB1SMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:12:30 -0500
Received: from chaos.tigron.net ([82.146.116.170]:45379 "EHLO chaos.tigron.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaB1SM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:12:28 -0500
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2014 13:12:28 EST
From: Gerry Demaret <gerry@tigron.be>
To: davem@davemloft.net, freddy@asix.com.tw, edumazet@google.com,
        ming.lei@canonical.com, dchang@suse.com, emilgoode@gmail.com
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gerry Demaret <gerry@tigron.be>
Subject: [PATCH] USB AX88179/178A: Support D-Link DUB-1312
Date: Fri, 28 Feb 2014 18:50:46 +0100
Message-Id: <1393609846-9986-1-git-send-email-gerry@tigron.be>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the USB device ID for the D-Link DUB-1312 USB 3.0 to Gigabit Ethernet
Adapter to the AX88179/178A driver.

Signed-off-by: Gerry Demaret <gerry@tigron.be>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 955df81..be5bfad 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1395,6 +1395,19 @@ static const struct driver_info ax88178a_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info dlink_dub1312_info = {
+	.description = "D-Link DUB-1312 USB 3.0 to Gigabit Ethernet Adapter",
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
 static const struct driver_info sitecom_info = {
 	.description = "Sitecom USB 3.0 to Gigabit Adapter",
 	.bind = ax88179_bind,
@@ -1431,6 +1444,10 @@ static const struct usb_device_id products[] = {
 	USB_DEVICE(0x0b95, 0x178a),
 	.driver_info = (unsigned long)&ax88178a_info,
 }, {
+	/* D-Link DUB-1312 USB 3.0 to Gigabit Ethernet Adapter */
+	USB_DEVICE(0x2001, 0x4a00),
+	.driver_info = (unsigned long)&dlink_dub1312_info,
+}, {
 	/* Sitecom USB 3.0 to Gigabit Adapter */
 	USB_DEVICE(0x0df6, 0x0072),
 	.driver_info = (unsigned long)&sitecom_info,
-- 
1.9.0

