Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3B0AI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:08:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab3B0AIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:08:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Haggai Eran <haggaie@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 22/86] mm: mmu_notifier: make the mmu_notifier srcu static
Date: Tue, 26 Feb 2013 16:07:30 -0800
Message-Id: <20130226235915.221448184@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


