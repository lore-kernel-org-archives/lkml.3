Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3I2Tl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:41:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3I2T3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 03/71] net: usb: cdc_ether: Use wwan interface for Telit modules
Date: Sun, 29 Sep 2013 12:27:15 -0700
Message-Id: <20130929192643.778423659@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 0092820407901a0b2c4e343e85f96bb7abfcded1 upstream.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -726,6 +726,11 @@ static const struct usb_device_id	produc
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


