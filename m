Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3EUWxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:53:34 -0400
Received: from mout.gmx.net ([212.227.17.21]:60839 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3EUWxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:53:32 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/SapcNUWfSagN4XaqY1nm9aJqMwaocQ5msK2bwPd
	dbbdguh1fBDUAc
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org (open list:BROADCOM TG3 GIGA...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/19] net/ethernet/broadcom/tg3: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:58:06 +0200
Message-Id: <1369177096-19674-11-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/broadcom/tg3.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index fb06aa1..4f0e3fe 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17804,15 +17804,4 @@ static struct pci_driver tg3_driver = {
 	.driver.pm	= &tg3_pm_ops,
 };
 
-static int __init tg3_init(void)
-{
-	return pci_register_driver(&tg3_driver);
-}
-
-static void __exit tg3_cleanup(void)
-{
-	pci_unregister_driver(&tg3_driver);
-}
-
-module_init(tg3_init);
-module_exit(tg3_cleanup);
+module_pci_driver(tg3_driver);
-- 
1.8.1.5

