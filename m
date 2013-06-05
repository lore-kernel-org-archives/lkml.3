Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3FEILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:11:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26203 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3FEILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:11:31 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-f0-51aef2ac0e49
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rjw@sisk.pl, viresh.kumar@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to show
 accumulated data of CPU
Date: Wed, 05 Jun 2013 17:11:22 +0900
Message-id: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkSHftp3WBBt9kLZ42/WC3uP7lOavF
	2aY37BaXd81hs/jce4TR4nbjCjaL/oW9TBYbv3o4cHjcubaHzaNvyypGj0eLWxg9Pm+SC2CJ
	4rJJSc3JLEst0rdL4MqY3xpdcCi0Yser+4wNjLNcuhg5OSQETCROfP3NAmGLSVy4t56ti5GL
	Q0hgKaPEni/fGWGK7l96ygKRmM4osf3rWUYI5z+jxJPfE5hAqtgEtCT2v7jBBmKLCGhIXJ1+
	hBWkiFlgMaPEgXdfwEYJC6RJrG18C7aPRUBVYtaMF6wgNq+Aq8TbH5eZINbJSXzY84gdpFlC
	oJld4ubWTewQDQIS3yYfAmrmAErISmw6wAxRLylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGeoV
	J+YWl+al6yXn525iBAbt6X/Pencw3j5gfYgxGWjcRGYp0eR8YNDnlcQbGpsZWZiamBobmVua
	kSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR7KRRoZZ+QlruyhsL1BkWvlbf
	GmXEt2xXR9WZ5dcXbakU+iwiz/5vm+DBuvV8v/VFQ1wuPZI7Kht+0qhmgdrTH2/OZyVyaS9/
	e3WbYabj1yh9+62PhVadium8fV/rYlq0QDvvx31fdisItYV+9dl8oqOaL/6omZD9V495lofT
	brvHbrc9zRihxFKckWioxVxUnAgA5T7Xz3ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd01n9YFGjxeYWTxtOkHu8X1L89Z
	Lc42vWG3uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwefVtWMXo8WtzC6PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoz5rdEFh0Irdry6z9jAOMul
	i5GTQ0LAROL+pacsELaYxIV769m6GLk4hASmM0ps/3qWEcL5zyjx5PcEJpAqNgEtif0vbrCB
	2CICGhJXpx9hBSliFljMKHHg3RdGkISwQJrE2sa3YGNZBFQlZs14wQpi8wq4Srz9cZkJYp2c
	xIc9j9gnMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcFc+kdjCubLA4xCjAwajE
	w/uBYV2gEGtiWXFl7iFGCQ5mJRHe0ASgEG9KYmVValF+fFFpTmrxIcZkoO0TmaVEk/OBEZtX
	Em9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyFn01VpvF/nsUr
	sWNHm/Q2H6UT02W/vdjkdmHzVIY95u/K7VOnBP65MrNws8e+U2eUOzd8Flk08VmHf7fsQjk3
	q8wNYr3rjUN5bKLMW6WiJ37m3a4Y0jNxxbz65N9WvGUm9c4zL7bycn76Ksi5cetGrScpvRE7
	fTZqLnm0V19PRVPw0cVZn54osRRnJBpqMRcVJwIAnUvUtM4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new sysfs file to show previous accumulated data of CPU load
as following path. This sysfs file is used to judge the correct system state
or determine suitable system resource on user-space.
- /sys/devices/system/cpu/cpu0/cpufreq/stats/load_table

This sysfs file include following data:
- Measurement point of time
- CPU frequency
- Per-CPU load

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Additionally, I explain an example using 'load_table' sysfs entry.

Exynos4412 series has Quad-core and all cores share the power-line.
I cann't set diffent voltage/frequency to each CPU. To reduce power-
consumption, I certainly have to turn on/off CPU online state
according to CPU load on runtime. As a result, I peridically need to
monitor current cpu state to determine a proper amount of system
resource(necessary number of online cpu) and to delete wasted power.
So, I need 'load_table' sysfs file to monitor current cpu state.

I add a table which show power consumption of target based on
Exynos4412 SoC. This table indicate the difference power-consumption
according to a number of online core and with same number of running task.

[Environment of power estimation]
- cpufreq governor used performance mode to estimate power-consumption on each frequency step.
- Use infinite-loop test program which execute while statement infinitely.
- Always measure the power consumption under same temperature during 1 minutes.
- Unit is mA.
------------------------------------------------------------------------------------------------------------------------------------
A number of Online core	| Core 1	| Core 2		| Core 3			| Core 4
A number of nr_running	| 0	1	| 0	1	2	| 0	1	2	3	| 0	1	2	3	4
------------------------------------------------------------------------------------------------------------------------------------
 CPU Frequency		| 
 800  MHz		| 293 	330 	| 295 	338 	379 	| 300 	339 	386 	433 	| 303 	341 	390 	412 	482 
 1000 MHz		| 312 	371 	| 316 	377 	435 	| 318 	383 	454 	522 	| 322 	391 	462 	526 	596 
 1200 MHz		| 323 	404 	| 328 	418 	504 	| 336 	423 	521 	615 	| 343 	433 	499 	639 	748 
 1600 MHz 		| 380 	525 	| 388 	556 	771 	| 399 	575 	771 	1011 	| 412 	597 	822 	1172 	1684 
------------------------------------------------------------------------------------------------------------------------------------

For example,
The case A/B/C have the same condition except for a number of online core.
- case A: Online core is 2, 1000MHz and nr_running is 1	: 377mA
- case B: Online core is 3, 1000MHz and nr_running is 1	: 383mA
- case C: Online core is 4, 1000Mz and nr_running is 1	: 391mA

If system has only one running task, cpu hotplug policy, by monitoring
cpu state through 'load_table' sysfs file on user-space,
will determine 'case A' state for reducing power-consumption.

Show the result of reading 'load_table sysfs file as following:
- cpufreq governor is ondemand_org governor.

$ cat /sys/devices/system/cpu/cpu0/cpufreq/stats/load_table
       Time  Frequency cpu0 cpu1 cpu2 cpu3
1300500043122   1600000   32    6    0   26
1300600079080    800000   63   10    2   45
1300700065288    800000   51    9    1   42
1300800228747    800000   51    9    1   43
1300900182997    800000   78   11    3   47
1301000106163    800000   96   26    6   48
1301100056247   1600000   45    7    1   27
1301200071373   1000000   55    9    1   37
1301300096082    800000   54   10    0   45
1301400132832    800000   70   11    2   46
1301500082290    800000   61   11    1   43
1301600236415    800000   61    9    2   43
1301700071498    800000   59   10    2   43
1301800159290    800000   55    9    1   42
1301900076332    800000   66   10    2   43
1302000102165    800000   47    9    0   43
1302100086623    800000   75   11    2   50
1302200101082    800000   66   10    4   46
1302300108873    800000   53   10    1   44
1302400373373    600000   63   12    1   54

Please let me know some opinion about this patch.

Best regards and Thanks,
Chanwoo Choi

---
 drivers/cpufreq/cpufreq.c          |  4 +++
 drivers/cpufreq/cpufreq_governor.c | 21 ++++++++++--
 drivers/cpufreq/cpufreq_stats.c    | 70 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h            |  6 ++++
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..cbaaff0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -292,6 +292,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
 			policy->cur = freqs->new;
 		break;
+	case CPUFREQ_LOADCHECK:
+		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
+				CPUFREQ_LOADCHECK, freqs);
+		break;
 	}
 }
 /**
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad..bc50624 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -23,12 +23,17 @@
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
 #include "cpufreq_governor.h"
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	struct cpufreq_freqs freqs;
+#endif
+
 static struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy)
 {
 	if (have_governor_per_policy())
@@ -143,11 +148,17 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
-		if (unlikely(!wall_time || wall_time < idle_time))
+		if (unlikely(!wall_time || wall_time < idle_time)) {
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+			freqs.load[j] = 0;
+#endif
 			continue;
+		}
 
 		load = 100 * (wall_time - idle_time) / wall_time;
-
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+		freqs.load[j] = load;
+#endif
 		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			int freq_avg = __cpufreq_driver_getavg(policy, j);
 			if (freq_avg <= 0)
@@ -160,6 +171,12 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	freqs.time = ktime_to_ns(ktime_get());
+	freqs.old = freqs.new = policy->cur;
+
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_LOADCHECK);
+#endif
 	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..2379b1d 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -22,6 +22,8 @@
 #include <linux/notifier.h>
 #include <asm/cputime.h>
 
+#define CPUFREQ_LOAD_TABLE_MAX		20
+
 static spinlock_t cpufreq_stats_lock;
 
 struct cpufreq_stats {
@@ -35,6 +37,10 @@ struct cpufreq_stats {
 	unsigned int *freq_table;
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	unsigned int *trans_table;
+
+	struct cpufreq_freqs *load_table;
+	unsigned int load_last_index;
+	unsigned int load_max_index;
 #endif
 };
 
@@ -131,6 +137,38 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 	return len;
 }
 cpufreq_freq_attr_ro(trans_table);
+
+static ssize_t show_load_table(struct cpufreq_policy *policy, char *buf)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	struct cpufreq_freqs *load_table = stat->load_table;
+	ssize_t len = 0;
+	int i;
+	int j;
+
+	len += sprintf(buf + len, "%11s %10s", "Time", "Frequency");
+	for (j = 0; j < NR_CPUS; j++)
+		len += sprintf(buf + len, " %3s%d", "cpu", j);
+	len += sprintf(buf + len, "\n");
+
+	i = stat->load_last_index;
+	do {
+		len += sprintf(buf + len, "%lld %9d",
+				load_table[i].time,
+				load_table[i].old);
+
+		for (j = 0; j < NR_CPUS; j++)
+			len += sprintf(buf + len, " %4d",
+					load_table[i].load[j]);
+		len += sprintf(buf + len, "\n");
+
+		if (++i == stat->load_max_index)
+			i = 0;
+	} while (i != stat->load_last_index);
+
+	return len;
+}
+cpufreq_freq_attr_ro(load_table);
 #endif
 
 cpufreq_freq_attr_ro(total_trans);
@@ -141,6 +179,7 @@ static struct attribute *default_attrs[] = {
 	&time_in_state.attr,
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	&trans_table.attr,
+	&load_table.attr,
 #endif
 	NULL
 };
@@ -167,6 +206,9 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 
 	if (stat) {
 		pr_debug("%s: Free stat table\n", __func__);
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+		kfree(stat->load_table);
+#endif
 		kfree(stat->time_in_state);
 		kfree(stat);
 		per_cpu(cpufreq_stats_table, cpu) = NULL;
@@ -244,6 +286,16 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	stat->trans_table = stat->freq_table + count;
+
+	stat->load_max_index = CPUFREQ_LOAD_TABLE_MAX;
+	stat->load_last_index = 0;
+
+	alloc_size = sizeof(struct cpufreq_freqs) * stat->load_max_index;
+	stat->load_table = kzalloc(alloc_size, GFP_KERNEL);
+	if (!stat->load_table) {
+		ret = -ENOMEM;
+		goto error_out;
+	}
 #endif
 	j = 0;
 	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
@@ -312,13 +364,31 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	struct cpufreq_stats *stat;
 	int old_index, new_index;
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	if (val != CPUFREQ_POSTCHANGE && val != CPUFREQ_LOADCHECK)
+#else
 	if (val != CPUFREQ_POSTCHANGE)
+#endif
 		return 0;
 
 	stat = per_cpu(cpufreq_stats_table, freq->cpu);
 	if (!stat)
 		return 0;
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	if (val == CPUFREQ_LOADCHECK) {
+		struct cpufreq_freqs *dest_freq;
+
+		dest_freq = &stat->load_table[stat->load_last_index];
+		memcpy(dest_freq, freq, sizeof(struct cpufreq_freqs));
+
+		if (++stat->load_last_index == stat->load_max_index)
+			stat->load_last_index = 0;
+
+		return 0;
+	}
+#endif
+
 	old_index = stat->last_index;
 	new_index = freq_table_get_index(stat, freq->new);
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..f780645 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -140,12 +140,18 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
 #define CPUFREQ_POSTCHANGE	(1)
 #define CPUFREQ_RESUMECHANGE	(8)
 #define CPUFREQ_SUSPENDCHANGE	(9)
+#define CPUFREQ_LOADCHECK	(10)
 
 struct cpufreq_freqs {
 	unsigned int cpu;	/* cpu nr */
 	unsigned int old;
 	unsigned int new;
 	u8 flags;		/* flags of cpufreq_driver, see below. */
+
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	int64_t time;
+	unsigned int load[NR_CPUS];
+#endif
 };
 
 
-- 
1.8.0

