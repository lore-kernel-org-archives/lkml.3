Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaEWUrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:47:19 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55421 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaEWUrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:47:18 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>, Lubomir Rintel <lkundrak@v3.sk>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] usbtv: fix leak at failure path in usbtv_probe()
Date: Sat, 24 May 2014 00:47:07 +0400
Message-Id: <1400878027-22954-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code in usbtv_probe() misses usb_put_dev().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/usbtv/usbtv-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 2f87ddfa469f..473fab81b602 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -91,6 +91,8 @@ static int usbtv_probe(struct usb_interface *intf,
 	return 0;
 
 usbtv_video_fail:
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(usbtv->udev);
 	kfree(usbtv);
 
 	return ret;
-- 
1.8.3.2

