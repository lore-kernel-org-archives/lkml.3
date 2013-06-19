Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935228Ab3FSU55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:57:57 -0400
Received: from mail.ispras.ru ([83.149.199.45]:45529 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935151Ab3FSU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:57:56 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] go7007: fix return 0 for unsupported devices in go7007_usb_probe()
Date: Thu, 20 Jun 2013 00:57:40 +0400
Message-Id: <1371675460-14850-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe() should not return 0 for unsupported devices, but go7007_usb_probe() does.
The patch fixes it to return -ENODEV.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/media/go7007/go7007-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 50066e0..46ed832 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1124,7 +1124,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	case GO7007_BOARDID_LIFEVIEW_LR192:
 		printk(KERN_ERR "go7007-usb: The Lifeview TV Walker Ultra "
 				"is not supported.  Sorry!\n");
-		return 0;
+		return -ENODEV;
 		name = "Lifeview TV Walker Ultra";
 		board = &board_lifeview_lr192;
 		break;
@@ -1140,7 +1140,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	default:
 		printk(KERN_ERR "go7007-usb: unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
-		return 0;
+		return -ENODEV;
 	}
 
 	go = go7007_alloc(&board->main_info, &intf->dev);
-- 
1.8.1.2

