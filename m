Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaADUIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:08:23 -0500
Received: from mail.ispras.ru ([83.149.199.45]:37098 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaADUIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:08:22 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Thierry Escande <thierry.escande@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] NFC: port100: fix leak of usb_device
Date: Sun,  5 Jan 2014 00:08:05 +0400
Message-Id: <1388866085-11007-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

port100_probe() calls usb_get_dev(), but there is no usb_put_dev()
in port100_disconnect(). The patch adds one.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/nfc/port100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 8a0571eb2627..a8555f81cbba 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1509,6 +1509,7 @@ static void port100_disconnect(struct usb_interface *interface)
 
 	usb_free_urb(dev->in_urb);
 	usb_free_urb(dev->out_urb);
+	usb_put_dev(dev->udev);
 
 	kfree(dev->cmd);
 
-- 
1.8.3.2

