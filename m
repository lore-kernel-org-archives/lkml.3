Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3HRC0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:26:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33014 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab3HRCZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:25:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/5] rcu: Sort rcutorture module parameters
Date: Sat, 17 Aug 2013 19:25:15 -0700
Message-Id: <1376792717-3755-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081802-0320-0000-0000-000000B66630
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There are getting to be too many module parameters to permit the current
semi-random order, so this patch orders them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c | 68 ++++++++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index be38d4e..be50ebe 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -52,81 +52,81 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
-static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
-static int nfakewriters = 4;	/* # fake writer threads */
-static int stat_interval = 60;	/* Interval between stats, in seconds. */
-				/*  Zero means "only at end of test". */
-static bool verbose;		/* Print more debug info. */
-static bool test_no_idle_hz = true;
-				/* Test RCU support for tickless idle CPUs. */
-static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
-static int stutter = 5;		/* Start/stop testing interval (in sec) */
-static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static bool gp_exp;		/* Use expedited GP wait primitives. */
 static bool gp_normal;		/* Use normal GP wait primitives. */
+static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
+static int nfakewriters = 4;	/* # fake writer threads */
+static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int object_debug;	/* Test object-debug double call_rcu()?. */
-static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
 static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
+static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
+static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
 static int stall_cpu;		/* CPU-stall duration (s).  0 for no stall. */
 static int stall_cpu_holdoff = 10; /* Time to wait until stall (s).  */
+static int stat_interval = 60;	/* Interval between stats, in seconds. */
+				/*  Zero means "only at end of test". */
+static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
-static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
 static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
+static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
+static bool test_no_idle_hz = true;
+				/* Test RCU support for tickless idle CPUs. */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
+static bool verbose;		/* Print more debug info. */
 
-module_param(nreaders, int, 0444);
-MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-module_param(nfakewriters, int, 0444);
-MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0644);
-MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
-module_param(verbose, bool, 0444);
-MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-module_param(test_no_idle_hz, bool, 0444);
-MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
-module_param(shuffle_interval, int, 0444);
-MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
-module_param(stutter, int, 0444);
-MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
-module_param(irqreader, int, 0444);
-MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
 module_param(fqs_duration, int, 0444);
 MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us)");
 module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
-module_param(gp_normal, bool, 0444);
-MODULE_PARM_DESC(gp_normal, "Use normal (non-expedited) GP wait primitives");
 module_param(gp_exp, bool, 0444);
 MODULE_PARM_DESC(gp_exp, "Use expedited GP wait primitives");
+module_param(gp_normal, bool, 0444);
+MODULE_PARM_DESC(gp_normal, "Use normal (non-expedited) GP wait primitives");
+module_param(irqreader, int, 0444);
+MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
 module_param(n_barrier_cbs, int, 0444);
 MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
+module_param(nfakewriters, int, 0444);
+MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
+module_param(nreaders, int, 0444);
+MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
 module_param(object_debug, int, 0444);
 MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
-module_param(onoff_interval, int, 0444);
-MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
 module_param(onoff_holdoff, int, 0444);
 MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
+module_param(onoff_interval, int, 0444);
+MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+module_param(shuffle_interval, int, 0444);
+MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
 module_param(shutdown_secs, int, 0444);
 MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
 module_param(stall_cpu, int, 0444);
 MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
 module_param(stall_cpu_holdoff, int, 0444);
 MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
+module_param(stat_interval, int, 0644);
+MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
+module_param(stutter, int, 0444);
+MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
-module_param(test_boost_interval, int, 0444);
-MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
 module_param(test_boost_duration, int, 0444);
 MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
+module_param(test_boost_interval, int, 0444);
+MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
+module_param(test_no_idle_hz, bool, 0444);
+MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
+module_param(verbose, bool, 0444);
+MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 
 #define TORTURE_FLAG "-torture:"
 #define PRINTK_STRING(s) \
-- 
1.8.1.5

