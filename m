Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaBND7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBND7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:05 -0500
Date: Thu, 13 Feb 2014 19:58:55 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-22d9fd3411c693ccae5f5c2280fb1f9bb106ad4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-7-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-7-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage, mutex: Mark __visible
Git-Commit-ID: 22d9fd3411c693ccae5f5c2280fb1f9bb106ad4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22d9fd3411c693ccae5f5c2280fb1f9bb106ad4f
Gitweb:     http://git.kernel.org/tip/22d9fd3411c693ccae5f5c2280fb1f9bb106ad4f
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:03 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:13:19 -0800

asmlinkage, mutex: Mark __visible

Various kernel/mutex.c functions can be called from
inline assembler, so they should be all global and
__visible.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-7-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
