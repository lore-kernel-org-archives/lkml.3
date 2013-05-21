Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3EUVbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:31:34 -0400
Received: from mout.gmx.net ([212.227.17.20]:58846 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3EUVbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:31:16 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/xMnUwHqLxcog5lTZJv+H+G6JJ7xd7Zb8D+G9ouT
	OUqm2bVYyK4iVZ
From: Peter Huewe <peterhuewe@gmx.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 6/6] scsi/dmx3191d: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:21 +0200
Message-Id: <1369172181-22070-6-git-send-email-peterhuewe@gmx.de>
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
 drivers/scsi/dmx3191d.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 4b0dd8c..2e4456d 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -153,19 +153,7 @@ static struct pci_driver dmx3191d_pci_driver = {
 	.remove		= dmx3191d_remove_one,
 };
 
-static int __init dmx3191d_init(void)
-{
-	return pci_register_driver(&dmx3191d_pci_driver);
-}
-
-static void __exit dmx3191d_exit(void)
-{
-	pci_unregister_driver(&dmx3191d_pci_driver);
-}
-
-module_init(dmx3191d_init);
-module_exit(dmx3191d_exit);
-
+module_pci_driver(dmx3191d_pci_driver);
 MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
 MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

