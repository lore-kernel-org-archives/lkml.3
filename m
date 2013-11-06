Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3KFLUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:13 -0500
Date: Wed, 6 Nov 2013 03:19:44 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1ditvncg30dgbpvrz2bxfmke@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the mutex code to kernel/locking
 /
Git-Commit-ID: 01768b42dc97a67b4fb33a2535c49fc1969880df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:19:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01768b42dc97a67b4fb33a2535c49fc1969880df
Gitweb:     http://git.kernel.org/tip/01768b42dc97a67b4fb33a2535c49fc1969880df
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:11:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:55:07 +0100

locking: Move the mutex code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-1ditvncg30dgbpvrz2bxfmke@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                    | 6 ++----
 kernel/locking/Makefile            | 9 +++++++++
 kernel/{ => locking}/mutex-debug.c | 0
 kernel/{ => locking}/mutex-debug.h | 0
 kernel/{ => locking}/mutex.c       | 0
 kernel/{ => locking}/mutex.h       | 0
 6 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index a4d1aa8..330b146 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    extable.o params.o posix-timers.o \
-	    kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
+	    kthread.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o rwsem.o nsproxy.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
@@ -16,13 +16,12 @@ ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
-CFLAGS_REMOVE_mutex-debug.o = -pg
-CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
 obj-y += sched/
+obj-y += locking/
 obj-y += power/
 obj-y += printk/
 obj-y += cpu/
@@ -34,7 +33,6 @@ obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
-obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
 obj-$(CONFIG_LOCKDEP) += lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
new file mode 100644
index 0000000..fe8bd58
--- /dev/null
+++ b/kernel/locking/Makefile
@@ -0,0 +1,9 @@
+
+obj-y += mutex.o
+
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_mutex-debug.o = -pg
+CFLAGS_REMOVE_rtmutex-debug.o = -pg
+endif
+
+obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
diff --git a/kernel/mutex-debug.c b/kernel/locking/mutex-debug.c
similarity index 100%
rename from kernel/mutex-debug.c
rename to kernel/locking/mutex-debug.c
diff --git a/kernel/mutex-debug.h b/kernel/locking/mutex-debug.h
similarity index 100%
rename from kernel/mutex-debug.h
rename to kernel/locking/mutex-debug.h
diff --git a/kernel/mutex.c b/kernel/locking/mutex.c
similarity index 100%
rename from kernel/mutex.c
rename to kernel/locking/mutex.c
diff --git a/kernel/mutex.h b/kernel/locking/mutex.h
similarity index 100%
rename from kernel/mutex.h
rename to kernel/locking/mutex.h
