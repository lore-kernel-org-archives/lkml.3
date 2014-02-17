Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaBQWXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45003 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaBQWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/55] rcutorture: Rename PRINTK to TOROUT
Date: Mon, 17 Feb 2014 14:12:22 -0800
Message-Id: <1392675179-11560-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-6688-0000-0000-000006AEB015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Since it doesn't do printk()s anymore anyway, this commit renames these
macros from PRINTK to TOROUT (short for torture output).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 134 ++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index d09183d55817..04813bdf5e53 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -97,11 +97,11 @@ module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
 
 #define TORTURE_FLAG "-torture:"
-#define PRINTK_STRING(s) \
+#define TOROUT_STRING(s) \
 	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_PRINTK_STRING(s) \
+#define VERBOSE_TOROUT_STRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_PRINTK_ERRSTRING(s) \
+#define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
 static int nrealreaders;
@@ -618,12 +618,12 @@ static int rcu_torture_boost(void *arg)
 	struct rcu_boost_inflight rbi = { .inflight = 0 };
 	struct sched_param sp;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_boost started");
+	VERBOSE_TOROUT_STRING("rcu_torture_boost started");
 
 	/* Set real-time priority. */
 	sp.sched_priority = 1;
 	if (sched_setscheduler(current, SCHED_FIFO, &sp) < 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_boost RT prio failed!");
+		VERBOSE_TOROUT_STRING("rcu_torture_boost RT prio failed!");
 		n_rcu_torture_boost_rterror++;
 	}
 
@@ -651,7 +651,7 @@ static int rcu_torture_boost(void *arg)
 				call_rcu(&rbi.rcu, rcu_torture_boost_cb);
 				if (jiffies - call_rcu_time >
 					 test_boost_duration * HZ - HZ / 2) {
-					VERBOSE_PRINTK_STRING("rcu_torture_boost boosting failed");
+					VERBOSE_TOROUT_STRING("rcu_torture_boost boosting failed");
 					n_rcu_torture_boost_failure++;
 				}
 				call_rcu_time = jiffies;
@@ -687,7 +687,7 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 	} while (!kthread_should_stop() && fullstop  == FULLSTOP_DONTSTOP);
 
 	/* Clean up and exit. */
-	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_boost task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
@@ -707,7 +707,7 @@ rcu_torture_fqs(void *arg)
 	unsigned long fqs_resume_time;
 	int fqs_burst_remaining;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_fqs task started");
 	do {
 		fqs_resume_time = jiffies + fqs_stutter * HZ;
 		while (ULONG_CMP_LT(jiffies, fqs_resume_time) &&
@@ -723,7 +723,7 @@ rcu_torture_fqs(void *arg)
 		}
 		rcu_stutter_wait("rcu_torture_fqs");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_fqs task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_fqs task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_fqs");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
@@ -745,7 +745,7 @@ rcu_torture_writer(void *arg)
 	struct rcu_torture *old_rp;
 	static DEFINE_TORTURE_RANDOM(rand);
 
-	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
 
 	do {
@@ -795,7 +795,7 @@ rcu_torture_writer(void *arg)
 		rcutorture_record_progress(++rcu_torture_current_version);
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_writer task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_writer");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
@@ -811,7 +811,7 @@ rcu_torture_fakewriter(void *arg)
 {
 	DEFINE_TORTURE_RANDOM(rand);
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
 
 	do {
@@ -833,7 +833,7 @@ rcu_torture_fakewriter(void *arg)
 		rcu_stutter_wait("rcu_torture_fakewriter");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
@@ -927,7 +927,7 @@ rcu_torture_reader(void *arg)
 	struct timer_list t;
 	unsigned long long ts;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
 	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
@@ -977,7 +977,7 @@ rcu_torture_reader(void *arg)
 		schedule();
 		rcu_stutter_wait("rcu_torture_reader");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_reader task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
@@ -1098,13 +1098,13 @@ rcu_torture_stats_print(void)
 static int
 rcu_torture_stats(void *arg)
 {
-	VERBOSE_PRINTK_STRING("rcu_torture_stats task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_stats task started");
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
 		rcutorture_shutdown_absorb("rcu_torture_stats");
 	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_stats task stopping");
 	return 0;
 }
 
@@ -1182,13 +1182,13 @@ static void rcu_torture_shuffle_tasks(void)
 static int
 rcu_torture_shuffle(void *arg)
 {
-	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_shuffle task started");
 	do {
 		schedule_timeout_interruptible(shuffle_interval * HZ);
 		rcu_torture_shuffle_tasks();
 		rcutorture_shutdown_absorb("rcu_torture_shuffle");
 	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_shuffle task stopping");
 	return 0;
 }
 
@@ -1198,7 +1198,7 @@ rcu_torture_shuffle(void *arg)
 static int
 rcu_torture_stutter(void *arg)
 {
-	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_stutter task started");
 	do {
 		schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 1;
@@ -1207,7 +1207,7 @@ rcu_torture_stutter(void *arg)
 		stutter_pause_test = 0;
 		rcutorture_shutdown_absorb("rcu_torture_stutter");
 	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_stutter task stopping");
 	return 0;
 }
 
@@ -1245,7 +1245,7 @@ static void rcutorture_booster_cleanup(int cpu)
 	if (boost_tasks[cpu] == NULL)
 		return;
 	mutex_lock(&boost_mutex);
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_boost task");
+	VERBOSE_TOROUT_STRING("Stopping rcu_torture_boost task");
 	t = boost_tasks[cpu];
 	boost_tasks[cpu] = NULL;
 	mutex_unlock(&boost_mutex);
@@ -1264,13 +1264,13 @@ static int rcutorture_booster_init(int cpu)
 
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
-	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
+	VERBOSE_TOROUT_STRING("Creating rcu_torture_boost task");
 	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
 						  cpu_to_node(cpu),
 						  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
-		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
+		VERBOSE_TOROUT_STRING("rcu_torture_boost task create failed");
 		n_rcu_torture_boost_ktrerror++;
 		boost_tasks[cpu] = NULL;
 		mutex_unlock(&boost_mutex);
@@ -1292,7 +1292,7 @@ rcu_torture_shutdown(void *arg)
 	long delta;
 	unsigned long jiffies_snap;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_shutdown task started");
 	jiffies_snap = ACCESS_ONCE(jiffies);
 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
 	       !kthread_should_stop()) {
@@ -1305,13 +1305,13 @@ rcu_torture_shutdown(void *arg)
 		jiffies_snap = ACCESS_ONCE(jiffies);
 	}
 	if (kthread_should_stop()) {
-		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
+		VERBOSE_TOROUT_STRING("rcu_torture_shutdown task stopping");
 		return 0;
 	}
 
 	/* OK, shut down the system. */
 
-	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
+	VERBOSE_TOROUT_STRING("rcu_torture_shutdown task shutting down system");
 	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
 	rcu_torture_cleanup();	/* Get the success/failure message. */
 	kernel_power_off();	/* Shut down the system. */
@@ -1334,14 +1334,14 @@ rcu_torture_onoff(void *arg)
 	int ret;
 	unsigned long starttime;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_onoff task started");
 	for_each_online_cpu(cpu)
 		maxcpu = cpu;
 	WARN_ON(maxcpu < 0);
 	if (onoff_holdoff > 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_onoff begin holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_onoff begin holdoff");
 		schedule_timeout_interruptible(onoff_holdoff * HZ);
-		VERBOSE_PRINTK_STRING("rcu_torture_onoff end holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_onoff end holdoff");
 	}
 	while (!kthread_should_stop()) {
 		cpu = (torture_random(&rand) >> 4) % (maxcpu + 1);
@@ -1408,7 +1408,7 @@ rcu_torture_onoff(void *arg)
 		}
 		schedule_timeout_interruptible(onoff_interval * HZ);
 	}
-	VERBOSE_PRINTK_STRING("rcu_torture_onoff task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_onoff task stopping");
 	return 0;
 }
 
@@ -1432,7 +1432,7 @@ static void rcu_torture_onoff_cleanup(void)
 {
 	if (onoff_task == NULL)
 		return;
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
+	VERBOSE_TOROUT_STRING("Stopping rcu_torture_onoff task");
 	kthread_stop(onoff_task);
 	onoff_task = NULL;
 }
@@ -1459,11 +1459,11 @@ static int rcu_torture_stall(void *args)
 {
 	unsigned long stop_at;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_stall task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_stall task started");
 	if (stall_cpu_holdoff > 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_stall begin holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_stall begin holdoff");
 		schedule_timeout_interruptible(stall_cpu_holdoff * HZ);
-		VERBOSE_PRINTK_STRING("rcu_torture_stall end holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_stall end holdoff");
 	}
 	if (!kthread_should_stop()) {
 		stop_at = get_seconds() + stall_cpu;
@@ -1504,7 +1504,7 @@ static void rcu_torture_stall_cleanup(void)
 {
 	if (stall_task == NULL)
 		return;
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
+	VERBOSE_TOROUT_STRING("Stopping rcu_torture_stall_task.");
 	kthread_stop(stall_task);
 	stall_task = NULL;
 }
@@ -1524,7 +1524,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 	struct rcu_head rcu;
 
 	init_rcu_head_on_stack(&rcu);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task started");
 	set_user_nice(current, 19);
 	do {
 		wait_event(barrier_cbs_wq[myid],
@@ -1540,7 +1540,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(1);
@@ -1554,7 +1554,7 @@ static int rcu_torture_barrier(void *arg)
 {
 	int i;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier task starting");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier task starting");
 	do {
 		atomic_set(&barrier_cbs_invoked, 0);
 		atomic_set(&barrier_cbs_count, n_barrier_cbs);
@@ -1577,7 +1577,7 @@ static int rcu_torture_barrier(void *arg)
 		n_barrier_successes++;
 		schedule_timeout_interruptible(HZ / 10);
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier task stopping");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_barrier");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(1);
@@ -1618,7 +1618,7 @@ static int rcu_torture_barrier_init(void)
 						   "rcu_torture_barrier_cbs");
 		if (IS_ERR(barrier_cbs_tasks[i])) {
 			ret = PTR_ERR(barrier_cbs_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier_cbs");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create rcu_torture_barrier_cbs");
 			barrier_cbs_tasks[i] = NULL;
 			return ret;
 		}
@@ -1627,7 +1627,7 @@ static int rcu_torture_barrier_init(void)
 				   "rcu_torture_barrier");
 	if (IS_ERR(barrier_task)) {
 		ret = PTR_ERR(barrier_task);
-		VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier");
+		VERBOSE_TOROUT_ERRSTRING("Failed to create rcu_torture_barrier");
 		barrier_task = NULL;
 	}
 	return 0;
@@ -1639,14 +1639,14 @@ static void rcu_torture_barrier_cleanup(void)
 	int i;
 
 	if (barrier_task != NULL) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_barrier task");
 		kthread_stop(barrier_task);
 		barrier_task = NULL;
 	}
 	if (barrier_cbs_tasks != NULL) {
 		for (i = 0; i < n_barrier_cbs; i++) {
 			if (barrier_cbs_tasks[i] != NULL) {
-				VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier_cbs task");
+				VERBOSE_TOROUT_STRING("Stopping rcu_torture_barrier_cbs task");
 				kthread_stop(barrier_cbs_tasks[i]);
 				barrier_cbs_tasks[i] = NULL;
 			}
@@ -1705,19 +1705,19 @@ rcu_torture_cleanup(void)
 	rcu_torture_barrier_cleanup();
 	rcu_torture_stall_cleanup();
 	if (stutter_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
 	}
 	stutter_task = NULL;
 	if (shuffler_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
 		free_cpumask_var(shuffle_tmp_mask);
 	}
 	shuffler_task = NULL;
 
 	if (writer_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_writer task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_writer task");
 		kthread_stop(writer_task);
 	}
 	writer_task = NULL;
@@ -1725,7 +1725,7 @@ rcu_torture_cleanup(void)
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++) {
 			if (reader_tasks[i]) {
-				VERBOSE_PRINTK_STRING(
+				VERBOSE_TOROUT_STRING(
 					"Stopping rcu_torture_reader task");
 				kthread_stop(reader_tasks[i]);
 			}
@@ -1739,7 +1739,7 @@ rcu_torture_cleanup(void)
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++) {
 			if (fakewriter_tasks[i]) {
-				VERBOSE_PRINTK_STRING(
+				VERBOSE_TOROUT_STRING(
 					"Stopping rcu_torture_fakewriter task");
 				kthread_stop(fakewriter_tasks[i]);
 			}
@@ -1750,13 +1750,13 @@ rcu_torture_cleanup(void)
 	}
 
 	if (stats_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stats task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_stats task");
 		kthread_stop(stats_task);
 	}
 	stats_task = NULL;
 
 	if (fqs_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_fqs task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_fqs task");
 		kthread_stop(fqs_task);
 	}
 	fqs_task = NULL;
@@ -1767,7 +1767,7 @@ rcu_torture_cleanup(void)
 			rcutorture_booster_cleanup(i);
 	}
 	if (shutdown_task != NULL) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
+		VERBOSE_TOROUT_STRING("Stopping rcu_torture_shutdown task");
 		kthread_stop(shutdown_task);
 	}
 	shutdown_task = NULL;
@@ -1923,12 +1923,12 @@ rcu_torture_init(void)
 
 	/* Start up the kthreads. */
 
-	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
+	VERBOSE_TOROUT_STRING("Creating rcu_torture_writer task");
 	writer_task = kthread_create(rcu_torture_writer, NULL,
 				     "rcu_torture_writer");
 	if (IS_ERR(writer_task)) {
 		firsterr = PTR_ERR(writer_task);
-		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
+		VERBOSE_TOROUT_ERRSTRING("Failed to create writer");
 		writer_task = NULL;
 		goto unwind;
 	}
@@ -1936,17 +1936,17 @@ rcu_torture_init(void)
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
 				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
-		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		VERBOSE_TOROUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
 	for (i = 0; i < nfakewriters; i++) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
+		VERBOSE_TOROUT_STRING("Creating rcu_torture_fakewriter task");
 		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
 						  "rcu_torture_fakewriter");
 		if (IS_ERR(fakewriter_tasks[i])) {
 			firsterr = PTR_ERR(fakewriter_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create fakewriter");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create fakewriter");
 			fakewriter_tasks[i] = NULL;
 			goto unwind;
 		}
@@ -1954,28 +1954,28 @@ rcu_torture_init(void)
 	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
-		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		VERBOSE_TOROUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
 	for (i = 0; i < nrealreaders; i++) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_reader task");
+		VERBOSE_TOROUT_STRING("Creating rcu_torture_reader task");
 		reader_tasks[i] = kthread_run(rcu_torture_reader, NULL,
 					      "rcu_torture_reader");
 		if (IS_ERR(reader_tasks[i])) {
 			firsterr = PTR_ERR(reader_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create reader");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create reader");
 			reader_tasks[i] = NULL;
 			goto unwind;
 		}
 	}
 	if (stat_interval > 0) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_stats task");
+		VERBOSE_TOROUT_STRING("Creating rcu_torture_stats task");
 		stats_task = kthread_run(rcu_torture_stats, NULL,
 					"rcu_torture_stats");
 		if (IS_ERR(stats_task)) {
 			firsterr = PTR_ERR(stats_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create stats");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create stats");
 			stats_task = NULL;
 			goto unwind;
 		}
@@ -1985,7 +1985,7 @@ rcu_torture_init(void)
 
 		if (!alloc_cpumask_var(&shuffle_tmp_mask, GFP_KERNEL)) {
 			firsterr = -ENOMEM;
-			VERBOSE_PRINTK_ERRSTRING("Failed to alloc mask");
+			VERBOSE_TOROUT_ERRSTRING("Failed to alloc mask");
 			goto unwind;
 		}
 
@@ -1995,7 +1995,7 @@ rcu_torture_init(void)
 		if (IS_ERR(shuffler_task)) {
 			free_cpumask_var(shuffle_tmp_mask);
 			firsterr = PTR_ERR(shuffler_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create shuffler");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create shuffler");
 			shuffler_task = NULL;
 			goto unwind;
 		}
@@ -2008,7 +2008,7 @@ rcu_torture_init(void)
 					  "rcu_torture_stutter");
 		if (IS_ERR(stutter_task)) {
 			firsterr = PTR_ERR(stutter_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create stutter");
 			stutter_task = NULL;
 			goto unwind;
 		}
@@ -2021,7 +2021,7 @@ rcu_torture_init(void)
 				       "rcu_torture_fqs");
 		if (IS_ERR(fqs_task)) {
 			firsterr = PTR_ERR(fqs_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create fqs");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create fqs");
 			fqs_task = NULL;
 			goto unwind;
 		}
@@ -2051,7 +2051,7 @@ rcu_torture_init(void)
 					       "rcu_torture_shutdown");
 		if (IS_ERR(shutdown_task)) {
 			firsterr = PTR_ERR(shutdown_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
+			VERBOSE_TOROUT_ERRSTRING("Failed to create shutdown");
 			shutdown_task = NULL;
 			goto unwind;
 		}
-- 
1.8.1.5

