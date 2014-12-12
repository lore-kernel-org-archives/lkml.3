Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbaLLGkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:40:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759187AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        "Matthias Fuchs" <matthias.fuchs@esd.eu>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.779201837@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 132/164] can: esd_usb2: fix memory leak on disconnect
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f upstream.

It seems struct esd_usb2 dev is not deallocated on disconnect. The patch adds
the missing deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/usb/esd_usb2.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1097,6 +1097,7 @@ static void esd_usb2_disconnect(struct u
 			}
 		}
 		unlink_all_urbs(dev);
+		kfree(dev);
 	}
 }
 

