Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaCUWVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:21:03 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46641 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaCUWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:21:00 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] NFC: pn533: Fix device leak
Date: Sat, 22 Mar 2014 02:20:50 +0400
Message-Id: <1395440450-21178-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pn533_probe() calls usb_get_dev(), but there is no usb_put_dev()
in pn533_disconnect(). The patch adds one.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/nfc/pn533.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index cf1a87bb74f8..fed19d5473bb 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -3301,6 +3301,7 @@ static void pn533_disconnect(struct usb_interface *interface)
 
 	usb_free_urb(dev->in_urb);
 	usb_free_urb(dev->out_urb);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
-- 
1.8.3.2

