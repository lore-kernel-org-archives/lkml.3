Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab3DDHBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:01:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62953 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763858Ab3DDHBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:01:33 -0400
From: Hong Zhiguo <honkiko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH] lockdep: remove unneccesary assignment in loop and the viarable
Date: Thu,  4 Apr 2013 15:01:21 +0800
Message-Id: <1365058881-4044-1-git-send-email-honkiko@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
---
 kernel/lockdep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 259db20..0f26597 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2000,7 +2000,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct lock_class *class = hlock_class(hlock);
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
-	struct held_lock *hlock_curr, *hlock_next;
+	struct held_lock *hlock_curr;
 	int i, j;
 
 	/*
@@ -2057,12 +2057,10 @@ cache_hit:
 	chain->chain_key = chain_key;
 	chain->irq_context = hlock->irq_context;
 	/* Find the first held_lock of current chain */
-	hlock_next = hlock;
 	for (i = curr->lockdep_depth - 1; i >= 0; i--) {
 		hlock_curr = curr->held_locks + i;
-		if (hlock_curr->irq_context != hlock_next->irq_context)
+		if (hlock_curr->irq_context != hlock->irq_context)
 			break;
-		hlock_next = hlock;
 	}
 	i++;
 	chain->depth = curr->lockdep_depth + 1 - i;
-- 
1.7.10.4

