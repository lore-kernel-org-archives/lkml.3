Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3EQVrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:47:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:53671 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591Ab3EQVrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:03 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/0CcVnQ7z0sfsFz20aRXqlpjkpvahkqhrD9YIQq2
	xuQ6h3PGay/YDZ
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Cho Yu-Chen <acho@suse.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging/btmtk_usb: use module_usb_driver to register driver
Date: Fri, 17 May 2013 23:51:57 +0200
Message-Id: <1368827518-13364-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_usb_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/btmtk_usb/btmtk_usb.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
index 6b01f61..772c49e 100644
--- a/drivers/staging/btmtk_usb/btmtk_usb.c
+++ b/drivers/staging/btmtk_usb/btmtk_usb.c
@@ -1771,20 +1771,7 @@ static struct usb_driver btmtk_usb_driver = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-static int __init btmtk_usb_init(void)
-{
-	BT_INFO("btmtk usb driver ver %s", VERSION);
-
-	return usb_register(&btmtk_usb_driver);
-}
-
-static void __exit btmtk_usb_exit(void)
-{
-	usb_deregister(&btmtk_usb_driver);
-}
-
-module_init(btmtk_usb_init);
-module_exit(btmtk_usb_exit);
+module_usb_driver(btmtk_usb_driver);
 
 MODULE_DESCRIPTION("Mediatek Bluetooth USB driver ver " VERSION);
 MODULE_VERSION(VERSION);
-- 
1.8.1.5

