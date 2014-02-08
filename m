Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaBHHzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:55:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:27308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaBHHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:53:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480008626"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, peterz@infradead.org,
        mingo@kernel.org
Subject: [PATCH 05/14] asmlinkage: Make lockdep_sys_exit asmlinkage
Date: Sat,  8 Feb 2014 08:52:01 +0100
Message-Id: <1391845930-28580-5-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep_sys_exit can be called from assembler code, so make it
asmlinkage

Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/lockdep.h  | 2 +-
 kernel/locking/lockdep.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..7df9aa6 100644
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
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..c8b6753c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4191,7 +4191,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
-void lockdep_sys_exit(void)
+asmlinkage void lockdep_sys_exit(void)
 {
 	struct task_struct *curr = current;
 
-- 
1.8.5.2

