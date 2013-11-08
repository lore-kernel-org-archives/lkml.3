Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3KHV5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:57:19 -0500
Received: from mail.ispras.ru ([83.149.199.45]:60996 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706Ab3KHV5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:57:16 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] libertas_usb: fix leak at failure path in if_usb_probe()
Date: Sat,  9 Nov 2013 01:57:03 +0400
Message-Id: <1383947823-8670-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code in if_usb_probe() misses usb_put_dev(udev).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/libertas/if_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 2798077..7aec7b2 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -285,6 +285,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	return 0;
 
 err_get_fw:
+	usb_put_dev(udev);
 	lbs_remove_card(priv);
 err_add_card:
 	if_usb_reset_device(cardp);
-- 
1.8.1.2

