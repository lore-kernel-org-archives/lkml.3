Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3EUWxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:53:47 -0400
Received: from mout.gmx.net ([212.227.15.18]:59559 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3EUWxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:53:45 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX180cbB+gvw08eGXv4IEgHRXdSKYG6k7HxPaoaUrxy
	PPNzsui1AUU+wK
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Patrick McHardy <kaber@trash.net>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 15/19] net/ethernet/amd/amd8111e: Use module_pci_driver to register driver
Date: Wed, 22 May 2013 00:58:10 +0200
Message-Id: <1369177096-19674-15-git-send-email-peterhuewe@gmx.de>
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
 drivers/net/ethernet/amd/amd8111e.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 8e6b665..bc71aec 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1981,15 +1981,4 @@ static struct pci_driver amd8111e_driver = {
 	.resume		= amd8111e_resume
 };
 
-static int __init amd8111e_init(void)
-{
-	return pci_register_driver(&amd8111e_driver);
-}
-
-static void __exit amd8111e_cleanup(void)
-{
-	pci_unregister_driver(&amd8111e_driver);
-}
-
-module_init(amd8111e_init);
-module_exit(amd8111e_cleanup);
+module_pci_driver(amd8111e_driver);
-- 
1.8.1.5

