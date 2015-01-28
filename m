Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325AbbA1E0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:16 -0500
Received: from mail.kernel.org ([198.145.29.136]:41365 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934622AbbA1E0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:12 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 167/177] can: esd_usb2: fix memory leak on disconnect
Date: Wed, 28 Jan 2015 12:10:25 +0800
Message-Id: <1422418236-12852-258-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f upstream.

It seems struct esd_usb2 dev is not deallocated on disconnect. The patch adds
the missing deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/usb/esd_usb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 09b1da5..6c84234 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1094,6 +1094,7 @@ static void esd_usb2_disconnect(struct usb_interface *intf)
 			}
 		}
 		unlink_all_urbs(dev);
+		kfree(dev);
 	}
 }
 
-- 
1.9.1

