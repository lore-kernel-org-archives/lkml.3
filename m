Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3K1SRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:17:55 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60936 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3K1SRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:17:50 -0500
MIME-Version: 1.0
Date: Thu, 28 Nov 2013 12:17:49 -0600
Message-ID: <CAA_L7Z76=97VL5jnjW_1=9vLiKVOYDzs4W0XUw0tW9UDVeKm0A@mail.gmail.com>
Subject: vboxhost fails to build on 3.13
From: Souvik Banerjee <souvik1997@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I run `dkms install vboxhost/4.3.2` it fails to build with the
following error:
-----------------------------------------------------------------------------------------

DKMS make.log for vboxhost-4.3.2 for kernel
3.13.0-1git-00096-g711197a-dirty (x86_64)
Thu Nov 28 11:54:10 CST 2013
make: Entering directory '/usr/src/linux-3.13.0-1git-00096-g711197a-dirty'
  LD      /var/lib/dkms/vboxhost/4.3.2/build/built-in.o
  LD      /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/built-in.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/linux/SUPDrv-linux.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrvSem.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrvTracer.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/alloc-r0drv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/initterm-r0drv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/memobj-r0drv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/mpnotification-r0drv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/powernotification-r0drv.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/assert-r0drv-linux.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/alloc-r0drv-linux.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/initterm-r0drv-linux.o
  CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o
/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.c:
In function ‘rtR0MemObjNativeMapUser’:
/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.c:1539:26:
error: ‘struct mm_struct’ has no member named ‘numa_next_reset’
                 pTask->mm->numa_next_reset = jiffies + 0x7fffffffffffffffUL;
                          ^
scripts/Makefile.build:308: recipe for target
'/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o'
failed
make[2]: *** [/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o]
Error 1
scripts/Makefile.build:455: recipe for target
'/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv' failed
make[1]: *** [/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv] Error 2
Makefile:1253: recipe for target
'_module_/var/lib/dkms/vboxhost/4.3.2/build' failed
make: *** [_module_/var/lib/dkms/vboxhost/4.3.2/build] Error 2
make: Leaving directory '/usr/src/linux-3.13.0-1git-00096-g711197a-dirty'
-----------------------------------------------------------------------------------------

It seems that numa_next_reset was removed. Using `git log -p` I think
the offending commit is this:

-----------------------------------------------------------------------------------------

commit 930aa174fcc8b0efaad102fd80f677b92f35eaa2
Author: Mel Gorman <mgorman@suse.de>
Date:   Mon Oct 7 11:29:37 2013 +0100

    sched/numa: Remove the numa_balancing_scan_period_reset sysctl

    With scan rate adaptions based on whether the workload has properly
    converged or not there should be no need for the scan period reset
    hammer. Get rid of it.

    Signed-off-by: Mel Gorman <mgorman@suse.de>
    Reviewed-by: Rik van Riel <riel@redhat.com>
    Cc: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1381141781-10992-60-git-send-email-mgorman@suse.de
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index d48bca4..84f1780 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -374,15 +374,13 @@ guarantee. If the target workload is already
bound to NUMA nodes then this
 feature should be disabled. Otherwise, if the system overhead from the
 feature is too high then the rate the kernel samples for NUMA hinting
 faults may be controlled by the numa_balancing_scan_period_min_ms,
-numa_balancing_scan_delay_ms, numa_balancing_scan_period_reset,
-numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb and
-numa_balancing_settle_count sysctls.
+numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
+numa_balancing_scan_size_mb and numa_balancing_settle_count sysctls.

 ==============================================================

 numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms,
-numa_balancing_scan_period_max_ms, numa_balancing_scan_period_reset,
-numa_balancing_scan_size_mb
+numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb

 Automatic NUMA balancing scans tasks address space and unmaps pages to
 detect if pages are properly placed or if the data should be migrated to a
@@ -418,9 +416,6 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.

-numa_balancing_scan_period_reset is a blunt instrument that controls how
-often a tasks scan delay is reset to detect sudden changes in task behaviour.
-
 numa_balancing_settle_count is how many scan periods must complete before
 the schedule balancer stops pushing the task towards a preferred node. This
 gives the scheduler a chance to place the task on an alternative node if the
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a30f9ca..a3198e5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -420,9 +420,6 @@ struct mm_struct {
 	 */
 	unsigned long numa_next_scan;

-	/* numa_next_reset is when the PTE scanner period will be reset */
-	unsigned long numa_next_reset;
-
 	/* Restart point for scanning and setting pte_numa */
 	unsigned long numa_scan_offset;

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..10d16c4f 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -47,7 +47,6 @@ extern enum sched_tunable_scaling
sysctl_sched_tunable_scaling;
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
-extern unsigned int sysctl_numa_balancing_scan_period_reset;
 extern unsigned int sysctl_numa_balancing_scan_size;
 extern unsigned int sysctl_numa_balancing_settle_count;

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8cfd51f..89c5ae8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1721,7 +1721,6 @@ static void __sched_fork(unsigned long
clone_flags, struct task_struct *p)
 #ifdef CONFIG_NUMA_BALANCING
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
 		p->mm->numa_next_scan = jiffies +
msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
-		p->mm->numa_next_reset = jiffies +
msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
 		p->mm->numa_scan_seq = 0;
 	}

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 66237ff..da6fa22 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -826,7 +826,6 @@ update_stats_curr_start(struct cfs_rq *cfs_rq,
struct sched_entity *se)
  */
 unsigned int sysctl_numa_balancing_scan_period_min = 1000;
 unsigned int sysctl_numa_balancing_scan_period_max = 60000;
-unsigned int sysctl_numa_balancing_scan_period_reset = 60000;

 /* Portion of address space to scan in MB */
 unsigned int sysctl_numa_balancing_scan_size = 256;
@@ -1685,24 +1684,9 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;

-	if (!mm->numa_next_reset || !mm->numa_next_scan) {
+	if (!mm->numa_next_scan) {
 		mm->numa_next_scan = now +
 			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
-		mm->numa_next_reset = now +
-			msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
-	}
-
-	/*
-	 * Reset the scan period if enough time has gone by. Objective is that
-	 * scanning will be reduced if pages are properly placed. As tasks
-	 * can enter different phases this needs to be re-examined. Lacking
-	 * proper tracking of reference behaviour, this blunt hammer is used.
-	 */
-	migrate = mm->numa_next_reset;
-	if (time_after(now, migrate)) {
-		p->numa_scan_period = task_scan_min(p);
-		next_scan = now + msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
-		xchg(&mm->numa_next_reset, next_scan);
 	}

 	/*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 42f616a..e509b90 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -371,13 +371,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "numa_balancing_scan_period_reset",
-		.data		= &sysctl_numa_balancing_scan_period_reset,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
 		.procname	= "numa_balancing_scan_period_max_ms",
 		.data		= &sysctl_numa_balancing_scan_period_max,
 		.maxlen		= sizeof(unsigned int),
