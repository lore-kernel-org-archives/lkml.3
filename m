Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaLFPUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:36 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47709 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752080AbaLFPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 42/66] can: esd_usb2: fix memory leak on disconnect
Date: Sat,  6 Dec 2014 16:07:34 +0100
Message-Id: <000245b631cbc9dde4bebb0f378ec8cac5d60c07.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f upstream.

It seems struct esd_usb2 dev is not deallocated on disconnect. The patch adds
the missing deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/usb/esd_usb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index ac6177d3befc..91654d09275f 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1142,6 +1142,7 @@ static void esd_usb2_disconnect(struct usb_interface *intf)
 			}
 		}
 		unlink_all_urbs(dev);
+		kfree(dev);
 	}
 }
 
-- 
2.1.3

