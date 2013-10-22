Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3JVQP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:15:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:29263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3JVQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378374487"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        mingo@kernel.org
Subject: [PATCH 08/11] asmlinkage, mutex: Mark __visible
Date: Tue, 22 Oct 2013 09:12:23 -0700
Message-Id: <1382458346-24811-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Various kernel/mutex.c functions can be called from
inline assembler, so they should be all global and
__visible

Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/mutex.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 6d647ae..ffba8e9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -67,8 +67,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static __used noinline void __sched
-__mutex_lock_slowpath(atomic_t *lock_count);
+__visible void __sched __mutex_lock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_lock - acquire the mutex
@@ -225,7 +224,8 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 }
 #endif
 
-static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+__visible __used noinline
+void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_unlock - release the mutex
@@ -746,7 +746,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static __used noinline void
+__visible void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -803,7 +803,7 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static __used noinline void __sched
+__visible void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-- 
1.8.3.1

