Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab3KFLVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:21:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:21:35 -0500
Date: Wed, 6 Nov 2013 03:21:06 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-amd6pg1mif6tikbyktfvby3y@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the lglocks code to kernel/
 locking/
Git-Commit-ID: cd4d241d57c99c6b00ef1799ad797d90f75a1da9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:21:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd4d241d57c99c6b00ef1799ad797d90f75a1da9
Gitweb:     http://git.kernel.org/tip/cd4d241d57c99c6b00ef1799ad797d90f75a1da9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 4 Nov 2013 11:51:33 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 09:24:20 +0100

locking: Move the lglocks code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-amd6pg1mif6tikbyktfvby3y@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile               | 2 +-
 kernel/locking/Makefile       | 2 +-
 kernel/{ => locking}/lglock.c | 0
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 1aef002..09a9c94 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    kthread.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index b0e0d73..bdd313a 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o
+obj-y += mutex.o semaphore.o rwsem.o lglock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
diff --git a/kernel/lglock.c b/kernel/locking/lglock.c
similarity index 100%
rename from kernel/lglock.c
rename to kernel/locking/lglock.c
