Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab3ETT0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:26:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:58943 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab3ETT0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:26:50 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18psxd3N88p23/vhED0sAMkNwrgtua2oR5kHsfVZu
	Ln97M218J3PnGc
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dongjin Kim <tobetter@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb/misc/usb3503: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 21:31:57 +0200
Message-Id: <1369078317-30210-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_i2c_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/usb/misc/usb3503.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index f713f6a..72d1771 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -307,19 +307,7 @@ static struct i2c_driver usb3503_driver = {
 	.id_table	= usb3503_id,
 };
 
-static int __init usb3503_init(void)
-{
-	return i2c_add_driver(&usb3503_driver);
-}
-
-static void __exit usb3503_exit(void)
-{
-	i2c_del_driver(&usb3503_driver);
-}
-
-module_init(usb3503_init);
-module_exit(usb3503_exit);
-
+module_i2c_driver(usb3503_driver);
 MODULE_AUTHOR("Dongjin Kim <tobetter@gmail.com>");
 MODULE_DESCRIPTION("USB3503 USB HUB driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

