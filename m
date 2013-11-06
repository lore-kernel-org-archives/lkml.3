Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab3KFLV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:21:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3KFLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:21:23 -0500
Date: Wed, 6 Nov 2013 03:20:48 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-p9ijt8div0hwldexwfm4nlhj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the rtmutex code to kernel/
 locking/
Git-Commit-ID: 1696a8bee390929fed05c6297164816ae2ced280
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1696a8bee390929fed05c6297164816ae2ced280
Gitweb:     http://git.kernel.org/tip/1696a8bee390929fed05c6297164816ae2ced280
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:18:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 09:23:59 +0100

locking: Move the rtmutex code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-p9ijt8div0hwldexwfm4nlhj@git.kernel.org
[ Fixed build failure in kernel/rcu/tree_plugin.h. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                       | 3 ---
 kernel/futex.c                        | 2 +-
 kernel/locking/Makefile               | 3 +++
 kernel/{ => locking}/rtmutex-debug.c  | 0
 kernel/{ => locking}/rtmutex-debug.h  | 0
 kernel/{ => locking}/rtmutex-tester.c | 0
 kernel/{ => locking}/rtmutex.c        | 0
 kernel/{ => locking}/rtmutex.h        | 0
 kernel/{ => locking}/rtmutex_common.h | 0
 kernel/rcu/tree_plugin.h              | 2 +-
 10 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 45e5ae2..9c2ad18 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -35,9 +35,6 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
-obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
-obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
-obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
diff --git a/kernel/futex.c b/kernel/futex.c
index c3a1a55..80ba086 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -66,7 +66,7 @@
 
 #include <asm/futex.h>
 
-#include "rtmutex_common.h"
+#include "locking/rtmutex_common.h"
 
 int __read_mostly futex_cmpxchg_enabled;
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 5978fdd..59f66de 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -15,5 +15,8 @@ obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
+obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
+obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
diff --git a/kernel/rtmutex-debug.c b/kernel/locking/rtmutex-debug.c
similarity index 100%
rename from kernel/rtmutex-debug.c
rename to kernel/locking/rtmutex-debug.c
diff --git a/kernel/rtmutex-debug.h b/kernel/locking/rtmutex-debug.h
similarity index 100%
rename from kernel/rtmutex-debug.h
rename to kernel/locking/rtmutex-debug.h
diff --git a/kernel/rtmutex-tester.c b/kernel/locking/rtmutex-tester.c
similarity index 100%
rename from kernel/rtmutex-tester.c
rename to kernel/locking/rtmutex-tester.c
diff --git a/kernel/rtmutex.c b/kernel/locking/rtmutex.c
similarity index 100%
rename from kernel/rtmutex.c
rename to kernel/locking/rtmutex.c
diff --git a/kernel/rtmutex.h b/kernel/locking/rtmutex.h
similarity index 100%
rename from kernel/rtmutex.h
rename to kernel/locking/rtmutex.h
diff --git a/kernel/rtmutex_common.h b/kernel/locking/rtmutex_common.h
similarity index 100%
rename from kernel/rtmutex_common.h
rename to kernel/locking/rtmutex_common.h
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3822ac0..6abb03d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1133,7 +1133,7 @@ void exit_rcu(void)
 
 #ifdef CONFIG_RCU_BOOST
 
-#include "../rtmutex_common.h"
+#include "../locking/rtmutex_common.h"
 
 #ifdef CONFIG_RCU_TRACE
 
