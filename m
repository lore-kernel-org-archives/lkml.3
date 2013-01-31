Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3AaMOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:14:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:56136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3AaMLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:41 -0500
Message-Id: <20130131120743.787438421@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 34/40] cpuhotplug: Remove CPU_DYING notifier
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpuhotplug-remove-cpu-dying.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users gone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    6 ------
 include/linux/cpuhotplug.h |    1 -
 kernel/cpu.c               |   11 -----------
 3 files changed, 18 deletions(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -60,11 +60,6 @@ extern ssize_t arch_print_cpu_modalias(s
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
-					* not handling interrupts, soon dead.
-					* Called on the dying cpu, interrupts
-					* are already disabled. Must not
-					* sleep, must not fail */
 #define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
 					* lock is dropped */
 
@@ -79,7 +74,6 @@ extern ssize_t arch_print_cpu_modalias(s
 #define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
-#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
 
 #ifdef CONFIG_SMP
 extern bool cpuhp_tasks_frozen;
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -29,7 +29,6 @@ enum cpuhp_states {
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
-	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_CLOCKEVENTS_DYING,
 	CPUHP_AP_RCUTREE_DYING,
 	CPUHP_AP_X86_TBOOT_DYING,
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -303,12 +303,6 @@ static int notify_down_prepare(unsigned 
 	return err;
 }
 
-static int notify_dying(unsigned int cpu)
-{
-	cpu_notify(CPU_DYING, cpu);
-	return 0;
-}
-
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
@@ -366,7 +360,6 @@ static int notify_dead(unsigned int cpu)
 #define notify_down_prepare	NULL
 #define takedown_cpu		NULL
 #define notify_dead		NULL
-#define notify_dying		NULL
 #endif
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -825,10 +818,6 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup = sched_starting_cpu,
 		.teardown = NULL,
 	},
-	[CPUHP_AP_NOTIFY_DYING] = {
-		.startup = NULL,
-		.teardown = notify_dying,
-	},
 	[CPUHP_AP_CLOCKEVENTS_DYING] = {
 		.startup = NULL,
 		.teardown = clockevents_dying_cpu,


