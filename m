Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911Ab3DJJYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:24:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936077Ab3DJJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:24:17 -0400
Date: Wed, 10 Apr 2013 02:24:06 -0700
From: tip-bot for Hong Zhiguo <tipbot@zytor.com>
Message-ID: <tip-bfaf4af8abf92b883c04d137a0c18245cc9d51a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        honkiko@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        honkiko@gmail.com, tglx@linutronix.de
In-Reply-To: <1365058881-4044-1-git-send-email-honkiko@gmail.com>
References: <1365058881-4044-1-git-send-email-honkiko@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Remove unnecessary 'hlock_next'
  variable
Git-Commit-ID: bfaf4af8abf92b883c04d137a0c18245cc9d51a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 02:24:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfaf4af8abf92b883c04d137a0c18245cc9d51a2
Gitweb:     http://git.kernel.org/tip/bfaf4af8abf92b883c04d137a0c18245cc9d51a2
Author:     Hong Zhiguo <honkiko@gmail.com>
AuthorDate: Thu, 4 Apr 2013 15:01:21 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 17:39:34 +0200

lockdep: Remove unnecessary 'hlock_next' variable

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1365058881-4044-1-git-send-email-honkiko@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8a0efac..e5dedda 100644
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
