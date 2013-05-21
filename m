Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3EUWjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:39:53 -0400
Received: from mout.gmx.net ([212.227.17.20]:64140 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3EUWjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:39:08 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX191RgQ5cYR1wks4lBRttULy3Px7NJASRrEFu9eIfi
	vkn1ESJsMzx04A
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jes Sorensen <jes@trained-monkey.org>,
        linux-acenic@sunsite.dk (open list:ACENIC DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/19] net/ethernet/alteon/acenic: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:42:14 +0200
Message-Id: <1369176146-19383-9-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/alteon/acenic.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index b7894f8..219be1b 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -702,19 +702,6 @@ static struct pci_driver acenic_pci_driver = {
 	.remove		= acenic_remove_one,
 };
 
-static int __init acenic_init(void)
-{
-	return pci_register_driver(&acenic_pci_driver);
-}
-
-static void __exit acenic_exit(void)
-{
-	pci_unregister_driver(&acenic_pci_driver);
-}
-
-module_init(acenic_init);
-module_exit(acenic_exit);
-
 static void ace_free_descriptors(struct net_device *dev)
 {
 	struct ace_private *ap = netdev_priv(dev);
@@ -3199,3 +3186,5 @@ static int read_eeprom_byte(struct net_device *dev, unsigned long offset)
 	       ap->name, offset);
 	goto out;
 }
+
+module_pci_driver(acenic_pci_driver);
-- 
1.8.1.5

