Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3JKKme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3JKKmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 012/100] net: usb: cdc_ether: Use wwan interface for Telit modules
Date: Fri, 11 Oct 2013 11:40:42 +0100
Message-Id: <1381488130-30235-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 0092820407901a0b2c4e343e85f96bb7abfcded1 upstream.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/cdc_ether.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index e7d4238..81182fb 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -707,6 +707,11 @@ static const struct usb_device_id	products [] = {
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
-- 
1.8.3.2

