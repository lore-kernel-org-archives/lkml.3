Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3GQVUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:20:53 -0400
Received: from mail.ispras.ru ([83.149.199.45]:54098 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab3GQVUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:20:50 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Bernd Krumboeck <krumboeck@universalnet.at>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] can: usb_8dev: fix urb leak on failure path in usb_8dev_start()
Date: Thu, 18 Jul 2013 01:20:33 +0400
Message-Id: <1374096033-28981-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If usb_8dev_start() fails to submit urb,
it unanchors the urb but forgets to free it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/can/usb/usb_8dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index cbd388e..8becd3d 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -779,6 +779,7 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
 			usb_unanchor_urb(urb);
 			usb_free_coherent(priv->udev, RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
+			usb_free_urb(urb);
 			break;
 		}
 
-- 
1.8.1.2

