Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbaGYWem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:34:42 -0400
Received: from mail.ispras.ru ([83.149.199.45]:42083 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaGYWel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:34:41 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] isdn/bas_gigaset: fix a leak on failure path in gigaset_probe()
Date: Sat, 26 Jul 2014 02:34:31 +0400
Message-Id: <1406327671-28271-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a lack of usb_put_dev(udev) on failure path in gigaset_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/isdn/gigaset/bas-gigaset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index c44950d3eb7b..b7ae0a0dd5b6 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2400,6 +2400,7 @@ allocerr:
 error:
 	freeurbs(cs);
 	usb_set_intfdata(interface, NULL);
+	usb_put_dev(udev);
 	gigaset_freecs(cs);
 	return rc;
 }
-- 
1.9.1

