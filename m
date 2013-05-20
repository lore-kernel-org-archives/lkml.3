Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3ETUnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:43:24 -0400
Received: from mout.gmx.net ([212.227.15.18]:60862 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab3ETUnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:43:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18QB2VlnHoQK2ZJDsr/eKO39rPriQNnYB7RxbnWCi
	+pSVolhWi3znHL
From: Peter Huewe <peterhuewe@gmx.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/5] uio/uio_netx: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:47:43 +0200
Message-Id: <1369082865-8885-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
References: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/uio/uio_netx.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 6a4ba5e..28a766b 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -174,19 +174,7 @@ static struct pci_driver netx_pci_driver = {
 	.remove = netx_pci_remove,
 };
 
-static int __init netx_init_module(void)
-{
-	return pci_register_driver(&netx_pci_driver);
-}
-
-static void __exit netx_exit_module(void)
-{
-	pci_unregister_driver(&netx_pci_driver);
-}
-
-module_init(netx_init_module);
-module_exit(netx_exit_module);
-
+module_pci_driver(netx_pci_driver);
 MODULE_DEVICE_TABLE(pci, netx_pci_ids);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Hans J. Koch, Manuel Traut");
-- 
1.8.1.5

