Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3ETUXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:23:11 -0400
Received: from mout.gmx.net ([212.227.17.22]:49922 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab3ETUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:23:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Loug+RpjL1iibgf2+d3f/ZpsDVyfXvGVj7qSxp5
	Dz3Lr2ikzKQda2
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] net/usb/r8152: Use module_usb_driver to register driver
Date: Mon, 20 May 2013 22:28:16 +0200
Message-Id: <1369081696-8149-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_usb_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/usb/r8152.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 14e5198..c7f2168 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1749,19 +1749,7 @@ static struct usb_driver rtl8152_driver = {
 	.resume =	rtl8152_resume
 };
 
-static int __init usb_rtl8152_init(void)
-{
-	return usb_register(&rtl8152_driver);
-}
-
-static void __exit usb_rtl8152_exit(void)
-{
-	usb_deregister(&rtl8152_driver);
-}
-
-module_init(usb_rtl8152_init);
-module_exit(usb_rtl8152_exit);
-
+module_usb_driver(rtl8152_driver);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

