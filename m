Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3DZOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:19:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3DZOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:18:50 -0400
Date: Fri, 26 Apr 2013 07:18:21 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-199e371f59d31c828345b0d959d27d752827b517@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20130423163403.GA12839@redhat.com>
References: <20130423163403.GA12839@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep:
  Print out additional debugging advice when we hit lockdep BUGs
Git-Commit-ID: 199e371f59d31c828345b0d959d27d752827b517
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  199e371f59d31c828345b0d959d27d752827b517
Gitweb:     http://git.kernel.org/tip/199e371f59d31c828345b0d959d27d752827b517
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 23 Apr 2013 12:34:03 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Apr 2013 08:36:33 +0200

lockdep: Print out additional debugging advice when we hit lockdep BUGs

We occasionally get reports of these BUGs being hit, and the
stack trace doesn't necessarily always tell us what we need to
know about why we are hitting those limits.

If users start attaching /proc/lock_stats to reports we may have
more of a clue what's going on.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130423163403.GA12839@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e5dedda..c5d1e6b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -411,6 +411,7 @@ static int save_trace(struct stack_trace *trace)
 
 		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 
 		return 0;
@@ -765,6 +766,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return NULL;
 	}
@@ -836,6 +838,7 @@ static struct lock_list *alloc_list_entry(void)
 
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return NULL;
 	}
@@ -2050,6 +2053,7 @@ cache_hit:
 
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return 0;
 	}
@@ -3191,6 +3195,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
