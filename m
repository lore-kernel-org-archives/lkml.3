Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3EUWhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:37:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:52749 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab3EUWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:37:49 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+oj+N1lkioG00LTplrGsiCQcFProaOaiA6HN5xpU
	qeSJ8Sc+4INjZD
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org (open list:ATLX ETHERNET DRI...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 04/19] net/ethernet/atheros/atlx/atl1: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:42:09 +0200
Message-Id: <1369176146-19383-4-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/atheros/atlx/atl1.c | 27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index fa0915f..538211d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3145,31 +3145,6 @@ static struct pci_driver atl1_driver = {
 	.driver.pm = &atl1_pm_ops,
 };
 
-/**
- * atl1_exit_module - Driver Exit Cleanup Routine
- *
- * atl1_exit_module is called just before the driver is removed
- * from memory.
- */
-static void __exit atl1_exit_module(void)
-{
-	pci_unregister_driver(&atl1_driver);
-}
-
-/**
- * atl1_init_module - Driver Registration Routine
- *
- * atl1_init_module is the first routine called when the driver is
- * loaded. All it does is register with the PCI subsystem.
- */
-static int __init atl1_init_module(void)
-{
-	return pci_register_driver(&atl1_driver);
-}
-
-module_init(atl1_init_module);
-module_exit(atl1_exit_module);
-
 struct atl1_stats {
 	char stat_string[ETH_GSTRING_LEN];
 	int sizeof_stat;
@@ -3705,3 +3680,5 @@ static const struct ethtool_ops atl1_ethtool_ops = {
 	.get_ethtool_stats	= atl1_get_ethtool_stats,
 	.get_sset_count		= atl1_get_sset_count,
 };
+
+module_pci_driver(atl1_driver);
-- 
1.8.1.5

