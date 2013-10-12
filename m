Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3JLEPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:15:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715Ab3JLEPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:15:33 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: chirag.kantharia@hp.com
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:15:29 +0200
Message-Id: <1381551329-6098-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/block/cpqarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 2b94403..370721e 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -406,7 +406,7 @@ static int cpqarray_register_ctlr(int i, struct pci_dev *pdev)
 	}
 	hba[i]->access.set_intr_mask(hba[i], 0);
 	if (request_irq(hba[i]->intr, do_ida_intr,
-		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
+		IRQF_SHARED, hba[i]->devname, hba[i]))
 	{
 		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
 				hba[i]->intr, hba[i]->devname);
-- 
1.8.1.2

