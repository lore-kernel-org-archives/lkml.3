Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3JJQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:09:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3JJPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 047/104] net: usb: cdc_ether: Use wwan interface for Telit modules
Date: Thu, 10 Oct 2013 08:41:35 -0700
Message-Id: <1381419752-29733-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 0092820407901a0b2c4e343e85f96bb7abfcded1 upstream.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/cdc_ether.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 299c53b..04af91a 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -696,6 +696,11 @@ static const struct usb_device_id	products [] = {
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
1.8.1.2

