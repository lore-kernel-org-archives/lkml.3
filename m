Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3JVQPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:15:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:5678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab3JVQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311163023"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        peterz@infradead.org, mingo@kernel.org
Subject: [PATCH 05/11] asmlinkage: Make lockdep_sys_exit asmlinkage
Date: Tue, 22 Oct 2013 09:12:20 -0700
Message-Id: <1382458346-24811-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

lockdep_sys_exit can be called from assembler code, so make it
asmlinkage

Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/lockdep.h | 2 +-
 kernel/lockdep.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index cfc2f11..18e19e4 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -265,7 +265,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
-extern void lockdep_sys_exit(void);
+extern asmlinkage void lockdep_sys_exit(void);
 
 extern void lockdep_off(void);
 extern void lockdep_on(void);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e16c45b..d3749fe 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4187,7 +4187,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
-void lockdep_sys_exit(void)
+asmlinkage void lockdep_sys_exit(void)
 {
 	struct task_struct *curr = current;
 
-- 
1.8.3.1

