Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3EUWxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:53:40 -0400
Received: from mout.gmx.net ([212.227.15.19]:59691 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab3EUWxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:53:37 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/EqfY3j9PEbXbGGXsQV4JnHopWNUdTGJI37b1MPd
	BzeikcBQ47ed9r
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        linux-driver@qlogic.com (supporter:QLOGIC QLGE 10Gb...),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 13/19] net/ethernet/qlogic/qlge/qlge_main: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:58:08 +0200
Message-Id: <1369177096-19674-13-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 50235d2..e04d471 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -4945,15 +4945,4 @@ static struct pci_driver qlge_driver = {
 	.err_handler = &qlge_err_handler
 };
 
-static int __init qlge_init_module(void)
-{
-	return pci_register_driver(&qlge_driver);
-}
-
-static void __exit qlge_exit(void)
-{
-	pci_unregister_driver(&qlge_driver);
-}
-
-module_init(qlge_init_module);
-module_exit(qlge_exit);
+module_pci_driver(qlge_driver);
-- 
1.8.1.5

