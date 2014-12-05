Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaLEXlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:41:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaLEWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Matthias Fuchs <matthias.fuchs@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.17 063/122] can: esd_usb2: fix memory leak on disconnect
Date: Fri,  5 Dec 2014 14:43:57 -0800
Message-Id: <20141205223315.115036113@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f upstream.

It seems struct esd_usb2 dev is not deallocated on disconnect. The patch adds
the missing deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/esd_usb2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1143,6 +1143,7 @@ static void esd_usb2_disconnect(struct u
 			}
 		}
 		unlink_all_urbs(dev);
+		kfree(dev);
 	}
 }
 


