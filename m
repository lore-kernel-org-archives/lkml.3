Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3EUWhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:37:43 -0400
Received: from mout.gmx.net ([212.227.17.21]:55652 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab3EUWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:37:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX188s1R2OaY8l+ZEwFTcKn699wmp81PFiC9sZktaYU
	CnmLydUHOYKL/a
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>, Joe Perches <joe@perches.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org (open list:ATLX ETHERNET DRI...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/19] net/ethernet/atheros/atl1e/atl1e_main: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:42:08 +0200
Message-Id: <1369176146-19383-3-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 0688bb8..895f537 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2489,27 +2489,4 @@ static struct pci_driver atl1e_driver = {
 	.err_handler = &atl1e_err_handler
 };
 
-/**
- * atl1e_init_module - Driver Registration Routine
- *
- * atl1e_init_module is the first routine called when the driver is
- * loaded. All it does is register with the PCI subsystem.
- */
-static int __init atl1e_init_module(void)
-{
-	return pci_register_driver(&atl1e_driver);
-}
-
-/**
- * atl1e_exit_module - Driver Exit Cleanup Routine
- *
- * atl1e_exit_module is called just before the driver is removed
- * from memory.
- */
-static void __exit atl1e_exit_module(void)
-{
-	pci_unregister_driver(&atl1e_driver);
-}
-
-module_init(atl1e_init_module);
-module_exit(atl1e_exit_module);
+module_pci_driver(atl1e_driver);
-- 
1.8.1.5

