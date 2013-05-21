Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3EUUnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:43:06 -0400
Received: from mout.gmx.net ([212.227.15.19]:61953 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3EUUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:43:04 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Gecwz+FuG5dDIFJXQgO7BB9nnkGH2RaxRuR5Vo0
	r9xx/8tu73D7lL
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] uio/uio_pci_generic: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 22:47:44 +0200
Message-Id: <1369169264-13144-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130521170952.GA6895@kroah.com>
References: <20130521170952.GA6895@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

It removes a pr_info showing some details about the driver, but
these infos can also be retrieved by using modinfo.

The name of the pci_driver struct had to be changed in order to prevent a
build failure.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Sorry for the build failure.

 drivers/uio/uio_pci_generic.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 14aa10c..077ae12 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -113,27 +113,14 @@ static void remove(struct pci_dev *pdev)
 	kfree(gdev);
 }
 
-static struct pci_driver driver = {
+static struct pci_driver uio_pci_driver = {
 	.name = "uio_pci_generic",
 	.id_table = NULL, /* only dynamic id's */
 	.probe = probe,
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
+module_pci_driver(uio_pci_driver);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.8.1.5

