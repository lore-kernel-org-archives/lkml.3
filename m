Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaBHHw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:52:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaBHHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471774447"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, mingo@kernel.org
Subject: [PATCH 07/14] asmlinkage, mutex: Mark __visible
Date: Sat,  8 Feb 2014 08:52:03 +0100
Message-Id: <1391845930-28580-7-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various kernel/mutex.c functions can be called from
inline assembler, so they should be all global and
__visible

Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/locking/mutex.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..adbc0d0 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
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
1.8.5.2

