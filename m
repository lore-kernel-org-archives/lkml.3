Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3EUWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:53:29 -0400
Received: from mout.gmx.net ([212.227.15.19]:54396 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3EUWx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:53:28 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/bQA0cfXTbaKqupeF+ZiSTx0xDFwOKYQ4sKNx1ta
	EYYAsuRwupiwMq
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org (open list:BROADCOM BNX2 GIG...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/19] net/ethernet/broadcom/bnx2: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:58:05 +0200
Message-Id: <1369177096-19674-10-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/broadcom/bnx2.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 5d20449..1a1b23e 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8764,18 +8764,4 @@ static struct pci_driver bnx2_pci_driver = {
 	.err_handler	= &bnx2_err_handler,
 };
 
-static int __init bnx2_init(void)
-{
-	return pci_register_driver(&bnx2_pci_driver);
-}
-
-static void __exit bnx2_cleanup(void)
-{
-	pci_unregister_driver(&bnx2_pci_driver);
-}
-
-module_init(bnx2_init);
-module_exit(bnx2_cleanup);
-
-
-
+module_pci_driver(bnx2_pci_driver);
-- 
1.8.1.5

