Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3GRLSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:18:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53651 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab3GRLSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:18:06 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-df-51e7ceed093b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/3 v6] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
Date: Thu, 18 Jul 2013 20:17:54 +0900
Message-id: <1374146275-5758-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkWPftueeBBncvc1o8bfrBbnH9y3NW
	i7NNb9gtLu+aw2bxufcIo8XtxhVsFv0Le5ksNn71cODwuHNtD5tH35ZVjB6PFrcwenzeJBfA
	EsVlk5Kak1mWWqRvl8CV8feEbMHzsor+tfsZGxhvJnYxcnJICJhItDy5xwxhi0lcuLeerYuR
	i0NIYCmjxNMJp9hgijY++8AKkVjEKNG4ejkjSEJIoJFJYuapIBCbTUBLYv+LG2ANIgJuEmuv
	fWIEaWAWmMIo0XxsE1CCg0NYIENi8g8/kBoWAVWJg/ebWUFsXgEXic/7XzBBLJOT+LDnETuI
	zSngKrHpywE2iF0uEhdO9YNdJyEwj12if9NyZohBAhLfJh9iAZkvISArsekA1DeSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgiJ/+92zCDsZ7B6wPMSYDjZvILCWa
	nA+MkbySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MC4RX8e/5pPCsejkozkcTxnmzzy31PSqQ/Sykker2M5av/OKapvH02fdc+W6o2HHodyFvZ+e
	7/8UaveqP1En7plLRcO3GZMNfsgz7YtOcJ7v1bZT8tL7aWeY12y4VyveZtR+guGzpdAbyxnN
	TPPeLH4dKybhvOPeQfE37w6lLjjyRCDyzrKZ+yOUWIozEg21mIuKEwGDu5ojhwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd03554HGnQetrZ42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bfE7IFz8sq+tfuZ2xgvJnY
	xcjJISFgIrHx2QdWCFtM4sK99WxdjFwcQgKLGCUaVy9nBEkICTQyScw8FQRiswloSex/cYMN
	xBYRcJNYe+0TI0gDs8AURonmY5uAEhwcwgIZEpN/+IHUsAioShy83wy2gFfAReLz/hdMEMvk
	JD7secQOYnMKuEps+nKADWKXi8SFU/1sExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjqBnUjsYVzZYHGIU4GBU4uG9wfM8UIg1say4MvcQowQHs5II77d9QCHelMTKqtSi/Pii
	0pzU4kOMyUBXTWSWEk3OB0Z3Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwbnnMKdzr7r9ibcmervJN3qt/c99bYPhG6vcnxuerF/je9dnrbZn6V3SqbSa3
	4P/f5fMKJk5kv3ifxfxE5T37ibpmX9fs/Txd+EJZwXafDzPLPsn+Pp/DJ/X+1qm7gZOYBU3k
	O/66uHxuitv6bvuf17kKdXEMPsaL0p9Z7HZ5mnxmntcz/VjFYiWW4oxEQy3mouJEALSpfYXk	AgAA
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
Changes since v5:
- Determine index value of policy->cpu_debugfs[] according to
  cpumask_weight(policy->cpus) value
- Bug fix, store 'policy->cpu' to 'freq->cpu' before notify
  CPUFREQ_LOADCHECK notification

Changes since v4:
- Reset the data of CPUs load when cpufreq governor is changed
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

 drivers/cpufreq/Kconfig            |   6 +
 drivers/cpufreq/cpufreq.c          |   4 +
 drivers/cpufreq/cpufreq_governor.c |  14 ++
 drivers/cpufreq/cpufreq_stats.c    | 258 +++++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h            |   6 +
 5 files changed, 264 insertions(+), 24 deletions(-)

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
index 924d654..cb68873 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -293,6 +293,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
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
index dc9b72e..decabcb 100644
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
@@ -161,6 +167,14 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+#ifdef CONFIG_CPU_FREQ_STAT
+	freq.time = ktime_to_ms(ktime_get());
+	freq.old = policy->cur;
+	freq.cpu = policy->cpu;
+
+	cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
+#endif
+
 	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..fd171ba 100644
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
@@ -149,6 +156,181 @@ static struct attribute_group stats_attr_group = {
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
+	unsigned int idx, size;
+	int ret = 0;
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
+	idx = cpumask_weight(policy->cpus) > 1 ? policy->cpu : 0;
+	stat->debugfs_load_table = debugfs_create_file("load_table", S_IWUSR,
+					policy->cpu_debugfs[idx],
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
@@ -204,7 +386,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
 	if (per_cpu(cpufreq_stats_table, cpu))
-		return -EBUSY;
+		return 0;
 	stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL);
 	if ((stat) == NULL)
 		return -ENOMEM;
@@ -257,6 +439,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
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
@@ -297,11 +487,18 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
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
 
@@ -312,32 +509,40 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
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
 
@@ -352,12 +557,16 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
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
@@ -418,6 +627,7 @@ static void __exit cpufreq_stats_exit(void)
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

