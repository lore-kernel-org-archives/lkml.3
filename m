Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3EUXiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:38:24 -0400
Received: from mout.gmx.net ([212.227.17.21]:58224 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab3EUXiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:38:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+JXDQG8AmJFEyaVF/grHcVLNiSlYRPW9P1jq0crm
	ZRUT7PkKwzjt6i
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jes Sorensen <jes@trained-monkey.org>,
        linux-hippi@sunsite.dk (open list:HIPPI),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 16/19] net/hippi/rrunner: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 01:42:53 +0200
Message-Id: <1369179778-20115-16-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/hippi/rrunner.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 3c4d627..00ed751 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1686,15 +1686,4 @@ static struct pci_driver rr_driver = {
 	.remove		= rr_remove_one,
 };
 
-static int __init rr_init_module(void)
-{
-	return pci_register_driver(&rr_driver);
-}
-
-static void __exit rr_cleanup_module(void)
-{
-	pci_unregister_driver(&rr_driver);
-}
-
-module_init(rr_init_module);
-module_exit(rr_cleanup_module);
+module_pci_driver(rr_driver);
-- 
1.8.1.5

