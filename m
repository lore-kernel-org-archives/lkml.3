Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3EUWjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:39:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:54647 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3EUWjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:39:03 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18AkB8r6NQAQICnnYuCKgQb5UgSoWvD0ZxSbMbMsQ
	P6tGMPMzGQer2w
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Francois Romieu <romieu@fr.zoreil.com>,
        Sorbica Shieh <sorbica@icplus.com.tw>,
        netdev@vger.kernel.org (open list:IP1000A 10/100/10...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/19] net/ethernet/icplus/ipg: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:42:13 +0200
Message-Id: <1369176146-19383-8-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/icplus/ipg.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/icplus/ipg.c b/drivers/net/ethernet/icplus/ipg.c
index 068d781..1fde90b 100644
--- a/drivers/net/ethernet/icplus/ipg.c
+++ b/drivers/net/ethernet/icplus/ipg.c
@@ -2298,15 +2298,4 @@ static struct pci_driver ipg_pci_driver = {
 	.remove		= ipg_remove,
 };
 
-static int __init ipg_init_module(void)
-{
-	return pci_register_driver(&ipg_pci_driver);
-}
-
-static void __exit ipg_exit_module(void)
-{
-	pci_unregister_driver(&ipg_pci_driver);
-}
-
-module_init(ipg_init_module);
-module_exit(ipg_exit_module);
+module_pci_driver(ipg_pci_driver);
-- 
1.8.1.5

