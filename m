Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3EUVbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:31:18 -0400
Received: from mout.gmx.net ([212.227.15.19]:64067 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3EUVbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:31:13 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX194kUVb/2t48fwM5hN1FGSIlQApZ9wnhEUlbvtZJW
	qi0EbDddnLshAI
From: Peter Huewe <peterhuewe@gmx.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/6] scsi/hpsa: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:17 +0200
Message-Id: <1369172181-22070-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
References: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/hpsa.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..0e2d91b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5176,15 +5176,4 @@ clean_up:
  *  This is it.  Register the PCI driver information for the cards we control
  *  the OS will call our registered routines when it finds one of our cards.
  */
-static int __init hpsa_init(void)
-{
-	return pci_register_driver(&hpsa_pci_driver);
-}
-
-static void __exit hpsa_cleanup(void)
-{
-	pci_unregister_driver(&hpsa_pci_driver);
-}
-
-module_init(hpsa_init);
-module_exit(hpsa_cleanup);
+module_pci_driver(hpsa_pci_driver);
-- 
1.8.1.5

