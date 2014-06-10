Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaFJUZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:25:53 -0400
Received: from mail.ispras.ru ([83.149.199.45]:52742 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaFJUZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:25:50 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: line6: do not return 0 from probe if no initialization done
Date: Wed, 11 Jun 2014 00:22:50 +0400
Message-Id: <1402431770-20131-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a strange "return 0" in line6_probe() before any initialization of
the module is done. It can lead to NULL pointer dereference in other functions.
The patch proposes to return -ENODEV in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/line6/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index ef511c76a6e3..503b2d763595 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -663,7 +663,7 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_DEVID_POCKETPOD:
 		switch (interface_number) {
 		case 0:
-			return 0;	/* this interface has no endpoints */
+			return -ENODEV;	/* this interface has no endpoints */
 		case 1:
 			alternate = 0;
 			break;
-- 
1.9.1

