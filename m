Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3EUVbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:31:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:58650 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3EUVbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:31:13 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/6BOs+Sq/6cFUbkt1y3phtDujIfgw/euQhWAPLB8
	1T+yulIlo1e3UV
From: Peter Huewe <peterhuewe@gmx.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/6] scsi/a100u2w: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:16 +0200
Message-Id: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/a100u2w.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 0163457..b8fd207 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1227,19 +1227,7 @@ static struct pci_driver inia100_pci_driver = {
 	.remove		= inia100_remove_one,
 };
 
-static int __init inia100_init(void)
-{
-	return pci_register_driver(&inia100_pci_driver);
-}
-
-static void __exit inia100_exit(void)
-{
-	pci_unregister_driver(&inia100_pci_driver);
-}
-
+module_pci_driver(inia100_pci_driver);
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-
-module_init(inia100_init);
-module_exit(inia100_exit);
-- 
1.8.1.5

