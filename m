Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3EUWiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:38:51 -0400
Received: from mout.gmx.net ([212.227.17.21]:53395 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab3EUWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:38:49 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+eifY5tz+euQ9uXDj6bB8MZJmlB1WTus4mGiXC7m
	itSc1E+KwHerlk
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Grant Grundler <grundler@parisc-linux.org>,
        netdev@vger.kernel.org (open list:TULIP NETWORK DRI...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/19] net/ethernet/dec/tulip/xircom_cb: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:42:11 +0200
Message-Id: <1369176146-19383-6-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/dec/tulip/xircom_cb.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/ethernet/dec/tulip/xircom_cb.c
index cdbcd16..9b84cb0 100644
--- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
+++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
@@ -1171,16 +1171,4 @@ investigate_write_descriptor(struct net_device *dev,
 	}
 }
 
-static int __init xircom_init(void)
-{
-	return pci_register_driver(&xircom_ops);
-}
-
-static void __exit xircom_exit(void)
-{
-	pci_unregister_driver(&xircom_ops);
-}
-
-module_init(xircom_init)
-module_exit(xircom_exit)
-
+module_pci_driver(xircom_ops);
-- 
1.8.1.5

