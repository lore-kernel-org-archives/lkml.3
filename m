Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3ETUvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:51:38 -0400
Received: from mout.gmx.net ([212.227.17.20]:54661 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3ETUvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:51:37 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+yHRww4p+yHUeLZZ7m1qo2IoKJU2EZ5DU/7obrPk
	QXzowTe6TLGiam
From: Peter Huewe <peterhuewe@gmx.de>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] parisc/superio: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:56:45 +0200
Message-Id: <1369083405-30157-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/parisc/superio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index ac6e8e7..a042d06 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -494,15 +494,4 @@ static struct pci_driver superio_driver = {
 	.probe =        superio_probe,
 };
 
-static int __init superio_modinit(void)
-{
-	return pci_register_driver(&superio_driver);
-}
-
-static void __exit superio_exit(void)
-{
-	pci_unregister_driver(&superio_driver);
-}
-
-module_init(superio_modinit);
-module_exit(superio_exit);
+module_pci_driver(superio_driver);
-- 
1.8.1.5

