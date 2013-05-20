Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3ETUn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:43:26 -0400
Received: from mout.gmx.net ([212.227.17.20]:60478 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab3ETUnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:43:24 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Oj88BUTeOq4x/m3fYrv2+DTFbEO7p0HoJ9aq+4p
	xZUEEW7TDuOTVw
From: Peter Huewe <peterhuewe@gmx.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 5/5] uio/uio_pci_generic: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:47:45 +0200
Message-Id: <1369082865-8885-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
References: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

It removes a pr_info showing some details about the driver, but
these infos can also be retrieved by using modinfo.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/uio/uio_pci_generic.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 14aa10c..a11b51a 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -120,20 +120,7 @@ static struct pci_driver driver = {
 	.remove = remove,
 };
 
-static int __init init(void)
-{
-	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
-	return pci_register_driver(&driver);
-}
-
-static void __exit cleanup(void)
-{
-	pci_unregister_driver(&driver);
-}
-
-module_init(init);
-module_exit(cleanup);
-
+module_pci_driver(driver);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.8.1.5

