Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3GEIr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:47:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14120 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3GEIqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:46:52 -0400
X-AuditID: cbfee691-b7fef6d000002d62-ed-51d687fa05ea
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH v5 2/6] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
Date: Fri, 05 Jul 2013 17:46:37 +0900
Message-id: <1373014001-17746-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkWPdX+7VAgx0XjCyeNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DKaPrwkalgSlnFhEk/2BsYZyR2MXJySAiYSFzZ9ooZwhaTuHBvPVsX
	IxeHkMBSRoll89ewwRQd7jrBDpFYxChx/uwmFgjnP6PEux3LmECq2AS0JPa/uAHWISLgJrH2
	2idGkCJmgWZGicOfpjKCJIQFMiS6elrB9rEIqErcaX0NZvMKuErsW3iDEWKdnMSHPY+A1nFw
	cAIN2jKxGCQsBFTy684EsMUSAvPYJT5dPcAKMUdA4tvkQywg9RICshKbDkC9IylxcMUNlgmM
	wgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBIb56X/PJu5gvH/A+hBjMtC4icxSosn5
	wDjJK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	zusH0VdsXe1epSlZLNlh9n6qxREXC5GWzAPrp8deTO07FftqGW+KRZHSnLNVITzXk9eUFoTO
	cFNm3jlTV+NymqlG1v9XZq8m3rs46/aKD6u+fzkn9+rdxkuFNfsq21gKA7innapTeWh+2p/b
	i+WY7FVW/hSvUhYenb48k58ue4O22T5bWXpaiaU4I9FQi7moOBEAf/rF0okCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd1f7dcCDfYtUrN42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bTh49MBVPKKiZM+sHewDgj
	sYuRk0NCwETicNcJdghbTOLCvfVsXYxcHEICixglzp/dxALh/GeUeLdjGRNIFZuAlsT+FzfY
	QGwRATeJtdc+MYIUMQs0M0oc/jSVESQhLJAh0dXTygxiswioStxpfQ1m8wq4SuxbeIMRYp2c
	xIc9j4BWc3BwAg3aMrEYJCwEVPLrzgSWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIER9Ez6R2MqxosDjEKcDAq8fA+qL8aKMSaWFZcmXuIUYKDWUmE1z7hWqAQb0piZVVqUX58
	UWlOavEhxmSgoyYyS4km5wMjPK8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGIv2v9OOO1p+/s29G4dOae+c8OTq1S3LgoolN6m/iKl5myxfpfzhx4c3F4XS
	bP94umTxTW84GqLhXcHr9cu30LO056hdrd/c4Ciuzqc/GXo25yXZfunZszHy+uVnPdIiyieL
	50fMt+b5YsT78drztIdf5zWon2h8wGxvsyCxytXif6hEe2eXqxJLcUaioRZzUXEiAOPXQGnm	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new 'load_table' debugfs file to show previous accumulated data
of CPUs load as following path and add CPUFREQ_LOADCHECK notification to
CPUFREQ_TRANSITION_NOTIFIER notifier chain.
- /sys/kernel/debug/cpufreq/cpuX/load_table

When governor calculates CPUs load on dbs_check_cpu(), governor send
CPUFREQ_LOADCHECK notification with CPUs load, so that cpufreq_stats
accumulates calculated CPUs load on 'load_table' storage.

This debugfs file is used to judge the correct system state or determine
suitable system resource according to current CPUs load on user-space.

This debugfs file include following data:
- Measurement point of time
- CPU frequency
- Per-CPU load

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
Changes since v4:
- Reset the data of CPUs load when cpufreq governor is performance or powersave
- Move code about creating debugfs directory to below first patch
	: [PATCH 1/2] cpufreq: Add debugfs directory for cpufreq

Changes since v3:
- Extend a range of accumulated data (10 ~ 1000)
- Add unit information of time/freq and align 'Time' field as left for readability
- Use CONFIG_CPU_FREQ_STAT depdendency instead of CONFIG_CPU_FREQ_STAT_DETATILS
- Initialize load of offline CPUx as zero(0)
- Create/remove debugfs root directory on cpufreq_stats_init/exit() because
  debugfs root is used on all CPUs.

Changes since v2:
- Code clean according to Viresh Kumar's comment
- Show both old frequency and new frequency on 'load_table' debugfs file
- Change debufs file patch as below
  old: /sys/kernel/debugfs/cpufreq/load_table
  new: /sys/kernel/debugfs/cpufreq/cpuX/load_table

Changes since v1:
- Set maximum storage size to save CPUs load on Kconfig
- Use spinlock to synchronize read/write operation for CPUs load
- Use local variable instead of global variable(struct cpufreq_freqs *freqs)
- Use pointer of data structure to get correct size of data structure
  in sizeof() macro instead of structure name
  : sizeof(struct cpufreq_freqs) -> sizeof(*stat->load_table)
- Change time unit from nanosecond to microsecond
- Remove unnecessary memory copy

Following Test result :
- Cpufreq governor : ondemand governor
- Test application : MP3 play + Picture Audo-slide application
- NR_CPU_LOAD_STORAGE : 10
- command : cat /sys/kernel/debug/cpufreq/cpu0/load_table

 drivers/cpufreq/Kconfig            |   6 +
 drivers/cpufreq/cpufreq.c          |   4 +
 drivers/cpufreq/cpufreq_governor.c |  13 ++
 drivers/cpufreq/cpufreq_stats.c    | 256 +++++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h            |   6 +
 5 files changed, 261 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..5c3f406 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -36,6 +36,12 @@ config CPU_FREQ_STAT
 
 	  If in doubt, say N.
 
+config NR_CPU_LOAD_STORAGE
+	int "Maximum storage size to save CPU load (10-1000)"
+	range 10 1000
+	depends on CPU_FREQ_STAT
+	default "10"
+
 config CPU_FREQ_STAT_DETAILS
 	bool "CPU frequency translation statistics details"
 	depends on CPU_FREQ_STAT
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bc01c8e..8a2c4c2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -297,6 +297,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
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
index dc9b72e..3e73107 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -87,6 +87,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	struct cpufreq_policy *policy;
+#ifdef CONFIG_CPU_FREQ_STAT
+	struct cpufreq_freqs freq = {0};
+#endif
 	unsigned int max_load = 0;
 	unsigned int ignore_nice;
 	unsigned int j;
@@ -148,6 +151,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			continue;
 
 		load = 100 * (wall_time - idle_time) / wall_time;
+#ifdef CONFIG_CPU_FREQ_STAT
+		freq.load[j] = load;
+#endif
 
 		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			int freq_avg = __cpufreq_driver_getavg(policy, j);
@@ -161,6 +167,13 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+#ifdef CONFIG_CPU_FREQ_STAT
+	freq.time = ktime_to_ms(ktime_get());
+	freq.old = policy->cur;
+
+	cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
+#endif
+
 	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..3211f46 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/debugfs.h>
 #include <linux/sysfs.h>
 #include <linux/cpufreq.h>
 #include <linux/module.h>
@@ -36,6 +37,12 @@ struct cpufreq_stats {
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	unsigned int *trans_table;
 #endif
+
+	/* Debugfs file for load_table */
+	struct cpufreq_freqs *load_table;
+	unsigned int load_last_index;
+	unsigned int load_max_index;
+	struct dentry *debugfs_load_table;
 };
 
 static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
@@ -149,6 +156,179 @@ static struct attribute_group stats_attr_group = {
 	.name = "stats"
 };
 
+#define MAX_LINE_SIZE		255
+static ssize_t load_table_read(struct file *file, char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct cpufreq_policy *policy = file->private_data;
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	struct cpufreq_freqs *load_table = stat->load_table;
+	ssize_t len = 0;
+	char *buf;
+	int i, cpu, ret;
+
+	buf = kzalloc(MAX_LINE_SIZE * stat->load_max_index, GFP_KERNEL);
+	if (!buf)
+		return 0;
+
+	spin_lock(&cpufreq_stats_lock);
+	len += sprintf(buf + len, "%-10s %-12s %-12s ", "Time(ms)",
+						    "Old Freq(Hz)",
+						    "New Freq(Hz)");
+	for_each_cpu(cpu, policy->cpus)
+		len += sprintf(buf + len, "%3s%d ", "CPU", cpu);
+	len += sprintf(buf + len, "\n");
+
+	i = stat->load_last_index;
+	do {
+		len += sprintf(buf + len, "%-10lld %-12d %-12d ",
+				load_table[i].time,
+				load_table[i].old,
+				load_table[i].new);
+
+		for_each_cpu(cpu, policy->cpus)
+			len += sprintf(buf + len, "%-4d ",
+					load_table[i].load[cpu]);
+		len += sprintf(buf + len, "\n");
+
+		if (++i == stat->load_max_index)
+			i = 0;
+	} while (i != stat->load_last_index);
+	spin_unlock(&cpufreq_stats_lock);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations load_table_fops = {
+	.read		= load_table_read,
+	.open		= simple_open,
+	.llseek		= no_llseek,
+};
+
+static int cpufreq_stats_reset_debugfs(struct cpufreq_policy *policy)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	int size;
+
+	if (!stat)
+		return -EINVAL;
+
+	if (stat->load_table)
+		kfree(stat->load_table);
+	stat->load_last_index = 0;
+
+	size = sizeof(*stat->load_table) * stat->load_max_index;
+	stat->load_table = kzalloc(size, GFP_KERNEL);
+	if (!stat->load_table)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	int size, ret = 0;
+
+	if (!stat)
+		return -EINVAL;
+
+	if (!policy->cpu_debugfs)
+		return -EINVAL;
+
+	stat->load_last_index = 0;
+	stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
+
+	/* Allocate memory for storage of CPUs load */
+	size = sizeof(*stat->load_table) * stat->load_max_index;
+	stat->load_table = kzalloc(size, GFP_KERNEL);
+	if (!stat->load_table)
+		return -ENOMEM;
+
+	/* Create debugfs directory and file for cpufreq */
+	stat->debugfs_load_table = debugfs_create_file("load_table", S_IWUSR,
+					policy->cpu_debugfs[policy->cpu],
+					policy, &load_table_fops);
+	if (!stat->debugfs_load_table) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	pr_debug("Creating debugfs file for CPU%d \n", policy->cpu);
+
+	return 0;
+err:
+	kfree(stat->load_table);
+	return ret;
+}
+
+/* should be called late in the CPU removal sequence so that the stats
+ * memory is still available in case someone tries to use it.
+ */
+static void cpufreq_stats_free_load_table(unsigned int cpu)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+
+	if (stat) {
+		pr_debug("Free memory of load_table\n");
+		kfree(stat->load_table);
+	}
+}
+
+/* must be called early in the CPU removal sequence (before
+ * cpufreq_remove_dev) so that policy is still valid.
+ */
+static void cpufreq_stats_free_debugfs(unsigned int cpu)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+
+	if (stat) {
+		pr_debug("Remove load_table debugfs file\n");
+		debugfs_remove(stat->debugfs_load_table);
+	}
+}
+
+static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
+					   unsigned long val)
+{
+	struct cpufreq_stats *stat;
+	int cpu, last_idx;
+
+	stat = per_cpu(cpufreq_stats_table, freq->cpu);
+	if (!stat)
+		return;
+
+	spin_lock(&cpufreq_stats_lock);
+
+	switch (val) {
+	case CPUFREQ_POSTCHANGE:
+		if (!stat->load_last_index)
+			last_idx = stat->load_max_index;
+		else
+			last_idx = stat->load_last_index - 1;
+
+		stat->load_table[last_idx].new = freq->new;
+		break;
+	case CPUFREQ_LOADCHECK:
+		last_idx = stat->load_last_index;
+
+		stat->load_table[last_idx].time = freq->time;
+		stat->load_table[last_idx].old = freq->old;
+		stat->load_table[last_idx].new = freq->old;
+		for_each_present_cpu(cpu)
+			stat->load_table[last_idx].load[cpu] = freq->load[cpu];
+
+		if (++stat->load_last_index == stat->load_max_index)
+			stat->load_last_index = 0;
+		break;
+	}
+
+	spin_unlock(&cpufreq_stats_lock);
+}
+
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
@@ -204,7 +384,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
 	if (per_cpu(cpufreq_stats_table, cpu))
-		return -EBUSY;
+		return 0;
 	stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL);
 	if ((stat) == NULL)
 		return -ENOMEM;
@@ -257,6 +437,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
+
+	ret = cpufreq_stats_create_debugfs(data);
+	if (ret < 0) {
+		spin_unlock(&cpufreq_stats_lock);
+		ret = -EINVAL;
+		goto error_out;
+	}
+
 	spin_unlock(&cpufreq_stats_lock);
 	cpufreq_cpu_put(data);
 	return 0;
@@ -297,11 +485,18 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 	if (val != CPUFREQ_NOTIFY)
 		return 0;
 	table = cpufreq_frequency_get_table(cpu);
-	if (!table)
-		return 0;
-	ret = cpufreq_stats_create_table(policy, table);
-	if (ret)
+	if (table) {
+		ret = cpufreq_stats_create_table(policy, table);
+		if (ret)
+			return ret;
+	}
+
+	ret = cpufreq_stats_reset_debugfs(policy);
+	if (ret < 0) {
+		pr_debug("Failed to reset CPUs data of debugfs\n");
 		return ret;
+	}
+
 	return 0;
 }
 
@@ -312,32 +507,40 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	struct cpufreq_stats *stat;
 	int old_index, new_index;
 
-	if (val != CPUFREQ_POSTCHANGE)
-		return 0;
+	switch (val) {
+	case CPUFREQ_POSTCHANGE:
+		stat = per_cpu(cpufreq_stats_table, freq->cpu);
+		if (!stat)
+			return 0;
 
-	stat = per_cpu(cpufreq_stats_table, freq->cpu);
-	if (!stat)
-		return 0;
+		old_index = stat->last_index;
+		new_index = freq_table_get_index(stat, freq->new);
 
-	old_index = stat->last_index;
-	new_index = freq_table_get_index(stat, freq->new);
+		/* We can't do stat->time_in_state[-1]= .. */
+		if (old_index == -1 || new_index == -1)
+			return 0;
 
-	/* We can't do stat->time_in_state[-1]= .. */
-	if (old_index == -1 || new_index == -1)
-		return 0;
+		cpufreq_stats_update(freq->cpu);
 
-	cpufreq_stats_update(freq->cpu);
+		if (old_index == new_index)
+			return 0;
 
-	if (old_index == new_index)
-		return 0;
-
-	spin_lock(&cpufreq_stats_lock);
-	stat->last_index = new_index;
+		spin_lock(&cpufreq_stats_lock);
+		stat->last_index = new_index;
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
-	stat->trans_table[old_index * stat->max_state + new_index]++;
+		stat->trans_table[old_index * stat->max_state + new_index]++;
 #endif
-	stat->total_trans++;
-	spin_unlock(&cpufreq_stats_lock);
+		stat->total_trans++;
+		spin_unlock(&cpufreq_stats_lock);
+
+		cpufreq_stats_store_load_table(freq, CPUFREQ_POSTCHANGE);
+
+		break;
+	case CPUFREQ_LOADCHECK:
+		cpufreq_stats_store_load_table(freq, CPUFREQ_LOADCHECK);
+		break;
+	}
+
 	return 0;
 }
 
@@ -352,12 +555,16 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+		cpufreq_stats_free_debugfs(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
+		cpufreq_stats_free_load_table(cpu);
 		cpufreq_stats_free_table(cpu);
 		break;
 	case CPU_UP_CANCELED_FROZEN:
+		cpufreq_stats_free_debugfs(cpu);
+		cpufreq_stats_free_load_table(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 		cpufreq_stats_free_table(cpu);
 		break;
@@ -418,6 +625,7 @@ static void __exit cpufreq_stats_exit(void)
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_debugfs(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 	}
 }
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 825f379..4d0a4fd 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -141,12 +141,18 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
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
+#ifdef CONFIG_CPU_FREQ_STAT
+	int64_t time;
+	unsigned int load[NR_CPUS];
+#endif
 };
 
 
-- 
1.8.0

