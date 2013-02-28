Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab3B1OtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3B1OtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Haggai Eran <haggaie@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/139] mm: mmu_notifier: make the mmu_notifier srcu static
Date: Thu, 28 Feb 2013 14:43:47 +0000
Message-Id: <1362062689-2567-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmu_notifier.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 35ff447..3775c90 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 
 /* global SRCU for all MMs */
-struct srcu_struct srcu;
+static struct srcu_struct srcu;
 
 /*
  * This function can't run concurrently against mmu_notifier_register
@@ -41,7 +41,7 @@ void __mmu_notifier_release(struct mm_struct *mm)
 	int id;
 
 	/*
-	 * RCU here will block mmu_notifier_unregister until
+	 * SRCU here will block mmu_notifier_unregister until
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
@@ -302,7 +302,7 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * RCU here will force exit_mmap to wait ->release to finish
+		 * SRCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		int id;
-- 
1.8.1.2

