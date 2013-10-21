Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3JUIvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39564 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab3JUIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Neukum" <oliver@neukum.org>,
        "Fabio Porcedda" <fabio.porcedda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.762515576@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/149] net: usb: cdc_ether: Use wwan interface for
 Telit modules
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 0092820407901a0b2c4e343e85f96bb7abfcded1 upstream.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/cdc_ether.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -615,6 +615,11 @@ static const struct usb_device_id	produc
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
 	.driver_info = (unsigned long)&wwan_info,
 }, {
+	/* Telit modules */
+	USB_VENDOR_AND_INTERFACE_INFO(0x1bc7, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = (kernel_ulong_t) &wwan_info,
+}, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long) &cdc_info,

