Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3FJUBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:01:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:41625 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3FJUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:01:04 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] ttusb-budget: fix memory leak in ttusb_probe()
Date: Tue, 11 Jun 2013 00:00:54 +0400
Message-Id: <1370894454-15824-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If something goes wrong starting from i2c_add_adapter(),
ttusb->iso_urb[] and ttusb itself are not deallocated.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 21b9049..f8a60c1 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1768,6 +1768,8 @@ err_i2c_del_adapter:
 	i2c_del_adapter(&ttusb->i2c_adap);
 err_unregister_adapter:
 	dvb_unregister_adapter (&ttusb->adapter);
+	ttusb_free_iso_urbs(ttusb);
+	kfree(ttusb);
 	return result;
 }
 
-- 
1.8.1.2

