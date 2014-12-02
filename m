Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaLBT0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbaLBT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 109/121] can: esd_usb2: fix memory leak on disconnect
Date: Tue,  2 Dec 2014 11:19:48 -0800
Message-Id: <1417548000-1794-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f upstream.

It seems struct esd_usb2 dev is not deallocated on disconnect. The patch adds
the missing deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/usb/esd_usb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index ac6177d..91654d0 100644
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
1.9.1

