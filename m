Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3HMOje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:39:34 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:34942 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3HMOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:39:33 -0400
From: Mark Rusk <Mark.Rusk@hp.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Mark Rusk <Mark.Rusk@hp.com>
Subject: [PATCH] drivers/misc/hpilo: Correct panic when an AUX iLO is detected 
Date: Tue, 13 Aug 2013 09:32:13 -0500
Message-Id: <1376404333-33815-1-git-send-email-Mark.Rusk@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Using an uninitialized variable 'devnum' after 'goto out;' was causing
 panic.  Just go ahead and return, we need to ignore AUX iLO devs.

 Oops: 0002 [#1] SMP
   .
   .
   .
 RIP  [<ffffffffa033e270>] ilo_probe+0xec/0xe7c [hpilo]
---
 drivers/misc/hpilo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 621c7a3..b83e3ca 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -759,7 +759,7 @@ static int ilo_probe(struct pci_dev *pdev,
 
 	/* Ignore subsystem_device = 0x1979 (set by BIOS)  */
 	if (pdev->subsystem_device == 0x1979)
-		goto out;
+		return 0;
 
 	if (max_ccb > MAX_CCB)
 		max_ccb = MAX_CCB;
@@ -899,7 +899,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.4");
+MODULE_VERSION("1.4.1");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
-- 
1.7.1

