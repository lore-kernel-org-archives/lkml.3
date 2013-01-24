Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027Ab3AXUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:16:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab3AXUOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:14:41 -0500
Date: Thu, 24 Jan 2013 12:14:26 -0800
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-5e45a7c83c6c8bd53c718caaf0fdff0ffabf8d8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20130108130547.32733.79507.stgit@srivatsabhat.in.ibm.com>
References: <20130108130547.32733.79507.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Rename print_unlock_inbalance_bug()
  to print_unlock_imbalance_bug()
Git-Commit-ID: 5e45a7c83c6c8bd53c718caaf0fdff0ffabf8d8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:14:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e45a7c83c6c8bd53c718caaf0fdff0ffabf8d8f
Gitweb:     http://git.kernel.org/tip/5e45a7c83c6c8bd53c718caaf0fdff0ffabf8d8f
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Tue, 8 Jan 2013 18:35:58 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 14:34:41 +0100

lockdep: Rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()

Fix the typo in the function name (s/inbalance/imbalance)

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/20130108130547.32733.79507.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..5cf12e7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3203,7 +3203,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 }
 
 static int
-print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
+print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
 {
 	if (!debug_locks_off())
@@ -3246,7 +3246,7 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
 		return 0;
 
 	if (curr->lockdep_depth <= 0)
-		return print_unlock_inbalance_bug(curr, lock, ip);
+		return print_unlock_imbalance_bug(curr, lock, ip);
 
 	return 1;
 }
@@ -3317,7 +3317,7 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	lockdep_init_map(lock, name, key, 0);
@@ -3384,7 +3384,7 @@ lock_release_non_nested(struct task_struct *curr,
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	if (hlock->instance == lock)
