Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3KFLTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:19:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3KFLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:19:49 -0500
Date: Wed, 6 Nov 2013 03:19:08 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-5q5yqvdaen0rmapwloeaotx3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] sched: Move wait.c into kernel/sched/
Git-Commit-ID: 7a6354e241d8fbc145836ac24e47630f12754536
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:19:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a6354e241d8fbc145836ac24e47630f12754536
Gitweb:     http://git.kernel.org/tip/7a6354e241d8fbc145836ac24e47630f12754536
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:07:08 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:49:16 +0100

sched: Move wait.c into kernel/sched/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-5q5yqvdaen0rmapwloeaotx3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile           | 2 +-
 kernel/sched/Makefile     | 1 +
 kernel/{ => sched}/wait.c | 0
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..b3d51e2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
-	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
+	    kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 54adcf3..f8d3f4b 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -12,6 +12,7 @@ CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
 obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += wait.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/wait.c b/kernel/sched/wait.c
similarity index 100%
rename from kernel/wait.c
rename to kernel/sched/wait.c
