Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaBFRRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:17:17 -0500
Received: from mail1.windriver.com ([147.11.146.13]:39273 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBFRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:17:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched.h: make max_threads "extern int" to fix sparse warning
Date: Thu, 6 Feb 2014 12:16:11 -0500
Message-ID: <1391706971-7362-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:

  kernel/fork.c:93:5: warning: symbol 'max_threads' was not declared. Should it be static?

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/sched.h | 1 +
 kernel/kmod.c         | 2 --
 kernel/sysctl.c       | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 69c6089944c8..af544d650617 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -163,6 +163,7 @@ extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 
 extern unsigned long total_forks;
 extern int nr_threads;
+extern int max_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 55a36537fef4..4aa49adec5dd 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -44,8 +44,6 @@
 
 #include <trace/events/module.h>
 
-extern int max_threads;
-
 static struct workqueue_struct *khelper_wq;
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7754ff16f334..c8ac136fcec1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/sysctl.h>
 #include <linux/bitmap.h>
 #include <linux/signal.h>
@@ -96,7 +97,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
 extern int core_uses_pid;
-- 
1.8.5.2

