Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3CDEOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:14:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab3CDDmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:53 -0500
Message-Id: <20130304033717.321103124@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Haggai Eran <haggaie@mellanox.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 098/153] mm: mmu_notifier: make the mmu_notifier srcu static
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 70400303ce0c4ced3139499c676d5c79636b0c72 upstream.

The variable must be static especially given the variable name.

s/RCU/SRCU/ over a few comments.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mmu_notifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 
 /* global SRCU for all MMs */
-struct srcu_struct srcu;
+static struct srcu_struct srcu;
 
 /*
  * This function can't run concurrently against mmu_notifier_register
@@ -41,7 +41,7 @@ void __mmu_notifier_release(struct mm_st
 	int id;
 
 	/*
-	 * RCU here will block mmu_notifier_unregister until
+	 * SRCU here will block mmu_notifier_unregister until
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
@@ -302,7 +302,7 @@ void mmu_notifier_unregister(struct mmu_
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * RCU here will force exit_mmap to wait ->release to finish
+		 * SRCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		int id;


