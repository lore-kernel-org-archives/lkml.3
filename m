Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3LSKN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:13:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46431 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3LSKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:13:25 -0500
Date: Thu, 19 Dec 2013 15:43:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 6/7] drivers: usb: Mark function as static in metro-usb.c
Message-ID: <5ccfe3fcd1c0598f75e7556c9be1245c76cde0ca.1387439261.git.rashika.kheria@gmail.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function metrousb_is_unidirectional_mode() in serial/metro-usb.c
because it is not used outside this file.

This eliminates the following warning in serial/metro-usb.c:
drivers/usb/serial/metro-usb.c:57:12: warning: no previous prototype for ‘metrousb_is_unidirectional_mode’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/serial/metro-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
index 40ccf6e..2b648c4 100644
--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -54,7 +54,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 #define UNI_CMD_OPEN	0x80
 #define UNI_CMD_CLOSE	0xFF
 
-inline int metrousb_is_unidirectional_mode(struct usb_serial_port *port)
+static inline int metrousb_is_unidirectional_mode(struct usb_serial_port *port)
 {
 	__u16 product_id = le16_to_cpu(
 		port->serial->dev->descriptor.idProduct);
-- 
1.7.9.5

