Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3AXJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:22:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:24037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3AXJV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:21:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="276013573"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/2] mutex: use spin_[un]lock instead of arch_spin_[un]lock
Date: Thu, 24 Jan 2013 17:22:45 +0800
Message-Id: <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
that we can collect the lock statistics of spin_lock_mutex from
/proc/lock_stat.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/mutex-debug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index 0799fd3..556c0bc 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
@@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
 							\
 		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
 		local_irq_save(flags);			\
-		arch_spin_lock(&(lock)->rlock.raw_lock);\
+		spin_lock(lock);			\
 		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
 	} while (0)
 
 #define spin_unlock_mutex(lock, flags)				\
 	do {							\
-		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
+		spin_unlock(lock);				\
 		local_irq_restore(flags);			\
 		preempt_check_resched();			\
 	} while (0)
-- 
1.7.7.6

