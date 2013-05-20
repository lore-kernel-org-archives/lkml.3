Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3ETUnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:43:49 -0400
Received: from mout.gmx.net ([212.227.15.15]:64398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3ETUnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:43:23 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Oj88BUTeOq4x/m3fYrv2+DTFbEO7p0HoJ9aq+4p
	xZUEEW7TDuOTVw
From: Peter Huewe <peterhuewe@gmx.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/5] uio/uio_sercos3: Use module_pci_driver to register driver
Date: Mon, 20 May 2013 22:47:44 +0200
Message-Id: <1369082865-8885-4-git-send-email-peterhuewe@gmx.de>
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
 drivers/uio/uio_sercos3.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 81a10a5..5419832 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -226,19 +226,7 @@ static struct pci_driver sercos3_pci_driver = {
 	.remove = sercos3_pci_remove,
 };
 
-static int __init sercos3_init_module(void)
-{
-	return pci_register_driver(&sercos3_pci_driver);
-}
-
-static void __exit sercos3_exit_module(void)
-{
-	pci_unregister_driver(&sercos3_pci_driver);
-}
-
-module_init(sercos3_init_module);
-module_exit(sercos3_exit_module);
-
+module_pci_driver(sercos3_pci_driver);
 MODULE_DESCRIPTION("UIO driver for the Automata Sercos III PCI card");
 MODULE_AUTHOR("John Ogness <john.ogness@linutronix.de>");
 MODULE_LICENSE("GPL v2");
-- 
1.8.1.5

