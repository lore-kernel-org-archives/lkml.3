Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaFGDS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:18:56 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48449 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaFGDSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:18:54 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 1/2] rsi: Use module_usb_driver
Date: Sat,  7 Jun 2014 07:18:30 +0400
Message-Id: <1402111111-8676-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_usb_driver eliminates the boilerplate and makes the code simpler,
in addition to the fact currently rsi_module_init() ignores usb_deregister() error.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 4c46e5631e2f..3226f19989e7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -550,33 +550,7 @@ static struct usb_driver rsi_driver = {
 #endif
 };
 
-/**
- * rsi_module_init() - This function registers the client driver.
- * @void: Void.
- *
- * Return: 0 on success.
- */
-static int rsi_module_init(void)
-{
-	usb_register(&rsi_driver);
-	rsi_dbg(INIT_ZONE, "%s: Registering driver\n", __func__);
-	return 0;
-}
-
-/**
- * rsi_module_exit() - This function unregisters the client driver.
- * @void: Void.
- *
- * Return: None.
- */
-static void rsi_module_exit(void)
-{
-	usb_deregister(&rsi_driver);
-	rsi_dbg(INFO_ZONE, "%s: Unregistering driver\n", __func__);
-}
-
-module_init(rsi_module_init);
-module_exit(rsi_module_exit);
+module_usb_driver(rsi_driver);
 
 MODULE_AUTHOR("Redpine Signals Inc");
 MODULE_DESCRIPTION("Common USB layer for RSI drivers");
-- 
1.8.3.2

