Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3KFLU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:23 -0500
Date: Wed, 6 Nov 2013 03:19:52 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wl7s3tta5isufzfguc23et06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the lockdep code to kernel/
 locking/
Git-Commit-ID: 8eddac3f103736163f49255bcb109edadea167f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:19:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eddac3f103736163f49255bcb109edadea167f6
Gitweb:     http://git.kernel.org/tip/8eddac3f103736163f49255bcb109edadea167f6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:14:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:55:08 +0100

locking: Move the lockdep code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-wl7s3tta5isufzfguc23et06@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                          | 6 ------
 kernel/locking/Makefile                  | 6 ++++++
 kernel/{ => locking}/lockdep.c           | 0
 kernel/{ => locking}/lockdep_internals.h | 0
 kernel/{ => locking}/lockdep_proc.c      | 0
 kernel/{ => locking}/lockdep_states.h    | 0
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 330b146..4fffd6ee 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -14,8 +14,6 @@ obj-y     = fork.o exec_domain.o panic.o \
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
-CFLAGS_REMOVE_lockdep.o = -pg
-CFLAGS_REMOVE_lockdep_proc.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
@@ -33,10 +31,6 @@ obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
-obj-$(CONFIG_LOCKDEP) += lockdep.o
-ifeq ($(CONFIG_PROC_FS),y)
-obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
-endif
 obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index fe8bd58..c103599 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -2,8 +2,14 @@
 obj-y += mutex.o
 
 ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_lockdep.o = -pg
+CFLAGS_REMOVE_lockdep_proc.o = -pg
 CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 endif
 
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
+obj-$(CONFIG_LOCKDEP) += lockdep.o
+ifeq ($(CONFIG_PROC_FS),y)
+obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
+endif
diff --git a/kernel/lockdep.c b/kernel/locking/lockdep.c
similarity index 100%
rename from kernel/lockdep.c
rename to kernel/locking/lockdep.c
diff --git a/kernel/lockdep_internals.h b/kernel/locking/lockdep_internals.h
similarity index 100%
rename from kernel/lockdep_internals.h
rename to kernel/locking/lockdep_internals.h
diff --git a/kernel/lockdep_proc.c b/kernel/locking/lockdep_proc.c
similarity index 100%
rename from kernel/lockdep_proc.c
rename to kernel/locking/lockdep_proc.c
diff --git a/kernel/lockdep_states.h b/kernel/locking/lockdep_states.h
similarity index 100%
rename from kernel/lockdep_states.h
rename to kernel/locking/lockdep_states.h
