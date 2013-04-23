Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3DWQef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:34:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab3DWQed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:34:33 -0400
Date: Tue, 23 Apr 2013 12:34:03 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Print out additional debugging advice when we hit lockdep BUGs
Message-ID: <20130423163403.GA12839@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We occasionally get reports of these BUGs being hit, and the stack trace
doesn't necessarily always tell us what we need to know about why we are
hitting those limits.

If users start attaching /proc/lock_stats to reports we may have more of
a clue what's going on.

Signed-off-by: Dave Jones <davej@redhat.com>

-- 
This could be factored out into a separate function as a follow-up patch
if this looks ok.

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7e755e7..e4c001f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -411,6 +411,7 @@ static int save_trace(struct stack_trace *trace)
 
 		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 
 		return 0;
@@ -778,6 +779,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return NULL;
 	}
@@ -849,6 +851,7 @@ static struct lock_list *alloc_list_entry(void)
 
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return NULL;
 	}
@@ -2063,6 +2066,7 @@ cache_hit:
 
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 		dump_stack();
 		return 0;
 	}
@@ -3207,6 +3211,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
 		printk("turning off the locking correctness validator.\n");
+		printk("Attach output of /proc/lock_stat to bug report\n");
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
