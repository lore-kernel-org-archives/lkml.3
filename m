Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3ETUmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:42:42 -0400
Received: from mout.gmx.net ([212.227.15.15]:55288 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab3ETUmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:42:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/xxX8gNcjxlWr+HnRmcWjbaNG25qfi8jEzNL2ak8
	rHF64e3X2zz2ow
From: Peter Huewe <peterhuewe@gmx.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/5] uio/uio_aec: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:47:41 +0200
Message-Id: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/uio/uio_aec.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
index 1548982..f3611c2 100644
--- a/drivers/uio/uio_aec.c
+++ b/drivers/uio/uio_aec.c
@@ -160,17 +160,5 @@ static struct pci_driver pci_driver = {
 	.remove = remove,
 };
 
-static int __init aectc_init(void)
-{
-	return pci_register_driver(&pci_driver);
-}
-
-static void __exit aectc_exit(void)
-{
-	pci_unregister_driver(&pci_driver);
-}
-
+module_pci_driver(pci_driver);
 MODULE_LICENSE("GPL");
-
-module_init(aectc_init);
-module_exit(aectc_exit);
-- 
1.8.1.5

