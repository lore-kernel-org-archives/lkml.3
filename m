Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3FEV1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:27:31 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48329 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab3FEV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:27:30 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] USB: fix PTR_ERR translation in init_usb_class()
Date: Thu,  6 Jun 2013 01:27:15 +0400
Message-Id: <1370467635-4414-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a misprint in init_usb_class():
IS_ERR is used to get error code instead of PTR_ERR.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/core/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index e5387a4..6a4c407 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -94,7 +94,7 @@ static int init_usb_class(void)
 	kref_init(&usb_class->kref);
 	usb_class->class = class_create(THIS_MODULE, "usbmisc");
 	if (IS_ERR(usb_class->class)) {
-		result = IS_ERR(usb_class->class);
+		result = PTR_ERR(usb_class->class);
 		printk(KERN_ERR "class_create failed for usb devices\n");
 		kfree(usb_class);
 		usb_class = NULL;
-- 
1.8.1.2

