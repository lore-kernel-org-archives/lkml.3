Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaCWPJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:09:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:58007 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaCWPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:19 -0400
Message-Id: <20140323150753.545727307@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chirag Kantharia <chirag.kantharia@hp.com>,
        hpiss <iss_storagedev@hp.com>
Subject: [patch 09/16] block: cpqarray: Use del_timer_sync() in teardown
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline; filename=block-cpqarray-use-del_timer_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure which contains the timer is about to be freed. Make
sure the timer is completely stopped and no callback running anymore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: hpiss <iss_storagedev@hp.com>
---
 drivers/block/cpqarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/block/cpqarray.c
===================================================================
--- tip.orig/drivers/block/cpqarray.c
+++ tip/drivers/block/cpqarray.c
@@ -336,7 +336,7 @@ static void cpqarray_remove_one(int i)
 	free_irq(hba[i]->intr, hba[i]);
 	iounmap(hba[i]->vaddr);
 	unregister_blkdev(COMPAQ_SMART2_MAJOR+i, hba[i]->devname);
-	del_timer(&hba[i]->timer);
+	del_timer_sync(&hba[i]->timer);
 	remove_proc_entry(hba[i]->devname, proc_array);
 	pci_free_consistent(hba[i]->pci_dev,
 			NR_CMDS * sizeof(cmdlist_t), (hba[i]->cmd_pool),


