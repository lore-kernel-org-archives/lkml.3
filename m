Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3ETUqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:46:10 -0400
Received: from mout.gmx.net ([212.227.17.21]:58474 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab3ETUqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:46:08 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18bOGAyRRsb/Da6fVCI2GvEXN2mB15hWqI/kcFKNA
	s8Nsv4kSSzGipk
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] uwb/whci: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:51:17 +0200
Message-Id: <1369083077-9001-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/uwb/whci.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/uwb/whci.c b/drivers/uwb/whci.c
index f48093e..c9df8ba 100644
--- a/drivers/uwb/whci.c
+++ b/drivers/uwb/whci.c
@@ -253,19 +253,7 @@ static struct pci_driver whci_driver = {
 	.remove   = whci_remove,
 };
 
-static int __init whci_init(void)
-{
-	return pci_register_driver(&whci_driver);
-}
-
-static void __exit whci_exit(void)
-{
-	pci_unregister_driver(&whci_driver);
-}
-
-module_init(whci_init);
-module_exit(whci_exit);
-
+module_pci_driver(whci_driver);
 MODULE_DESCRIPTION("WHCI UWB Multi-interface Controller enumerator");
 MODULE_AUTHOR("Cambridge Silicon Radio Ltd.");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

