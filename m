Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaB0LvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:51:14 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34546 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaB0LvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:51:13 -0500
Date: Thu, 27 Feb 2014 17:18:57 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 17/46] kernel: Move prototype declaration to appropriate
 header file from kernel/stop_machine.c
Message-ID: <56e9a86ca83957a7090d6c3bdb8a7fb2a7b6dd68.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to header file include/linux/sched.h from
kernel/stop_machine.c because they are used by more than one file.

This eliminates the following warning in kernel/sched/core.c:
kernel/sched/core.c:851:6: warning: no previous prototype for ‘sched_set_stop_task’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/sched.h |    2 +-
 kernel/stop_machine.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..fac6f9d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -170,7 +170,6 @@ extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
-
 extern void calc_global_load(unsigned long ticks);
 extern void update_cpu_load_nohz(void);
 
@@ -187,6 +186,7 @@ extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
 #endif
+void sched_set_stop_task(int cpu, struct task_struct *stop);
 
 /*
  * Task state bitmask. NOTE! These bits are also
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e0..d9a5c80 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -485,8 +485,6 @@ repeat:
 	}
 }
 
-extern void sched_set_stop_task(int cpu, struct task_struct *stop);
-
 static void cpu_stop_create(unsigned int cpu)
 {
 	sched_set_stop_task(cpu, per_cpu(cpu_stopper_task, cpu));
-- 
1.7.9.5

