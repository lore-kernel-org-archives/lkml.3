Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3EUWxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:53:44 -0400
Received: from mout.gmx.net ([212.227.17.21]:58938 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3EUWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:53:41 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+704ApY8a7b00ceHj/T20Ap6SS73EllXdBSeX646
	+4bEIZlE2icgbJ
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Jon Mason <jdmason@kudzu.us>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 14/19] net/ethernet/sun/sungem: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:58:09 +0200
Message-Id: <1369177096-19674-14-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/sun/sungem.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 5f3f9d5..e62df2b 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -3028,15 +3028,4 @@ static struct pci_driver gem_driver = {
 #endif /* CONFIG_PM */
 };
 
-static int __init gem_init(void)
-{
-	return pci_register_driver(&gem_driver);
-}
-
-static void __exit gem_cleanup(void)
-{
-	pci_unregister_driver(&gem_driver);
-}
-
-module_init(gem_init);
-module_exit(gem_cleanup);
+module_pci_driver(gem_driver);
-- 
1.8.1.5

