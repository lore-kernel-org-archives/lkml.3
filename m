Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3KFLUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:41 -0500
Date: Wed, 6 Nov 2013 03:20:11 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-vmw5sf6vzmua1z6nx1cg69h2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the semaphore core to kernel/
 locking/
Git-Commit-ID: e25a64c4017e3a3cda17454b040737e410a12991
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e25a64c4017e3a3cda17454b040737e410a12991
Gitweb:     http://git.kernel.org/tip/e25a64c4017e3a3cda17454b040737e410a12991
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:16:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:55:22 +0100

locking: Move the semaphore core to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-vmw5sf6vzmua1z6nx1cg69h2@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                  | 2 +-
 kernel/locking/Makefile          | 2 +-
 kernel/{ => locking}/semaphore.c | 0
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4bce165..45e5ae2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    extable.o params.o posix-timers.o \
 	    kthread.o sys_ni.o posix-cpu-timers.o \
-	    hrtimer.o rwsem.o nsproxy.o semaphore.o \
+	    hrtimer.o rwsem.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 674d215..5978fdd 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o
+obj-y += mutex.o semaphore.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
diff --git a/kernel/semaphore.c b/kernel/locking/semaphore.c
similarity index 100%
rename from kernel/semaphore.c
rename to kernel/locking/semaphore.c
