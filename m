Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3EUXia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:38:30 -0400
Received: from mout.gmx.net ([212.227.15.19]:60071 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab3EUXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:38:28 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/9EjkUebn9ljWgSmCAFtkVr3vEtcN/xYx4ZEJ6G4
	y/+jD9eXfZUag5
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 17/19] net/fddi/skfp/skfddi: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 01:42:54 +0200
Message-Id: <1369179778-20115-17-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369176146-19383-1-git-send-email-peterhuewe@gmx.de>
References: <1369176146-19383-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/fddi/skfp/skfddi.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index d5bd563..f5d7305 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -2246,15 +2246,4 @@ static struct pci_driver skfddi_pci_driver = {
 	.remove		= skfp_remove_one,
 };
 
-static int __init skfd_init(void)
-{
-	return pci_register_driver(&skfddi_pci_driver);
-}
-
-static void __exit skfd_exit(void)
-{
-	pci_unregister_driver(&skfddi_pci_driver);
-}
-
-module_init(skfd_init);
-module_exit(skfd_exit);
+module_pci_driver(skfddi_pci_driver);
-- 
1.8.1.5

