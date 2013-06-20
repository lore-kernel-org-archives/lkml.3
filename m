Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3FTIgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:36:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21843 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3FTIgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:36:43 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-58-51c2bf1a846b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rjw@sisk.pl, viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
Date: Thu, 20 Jun 2013 17:36:38 +0900
Message-id: <1371717398-19692-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkQFdq/6FAgyP7+SyeNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DKuL14OWtBZ0LF2ucH2BsYt/l3MXJwSAiYSKy9GtfFyAlkiklcuLee
	rYuRi0NIYCmjRNONVewwNZtXckPEpzNK7Pq9mQnC+c8ose5eLwtIN5uAlsT+FzfYQGwRATeJ
	mbvmgxUxC2xllHjWdI4RJCEskCix4NI6sAYWAVWJrVe2gsV5BVwlun7PZYI4Q07iw55H7CDN
	EgLN7BKP16xihGgQkPg2+RALxEmyEpsOMEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFhnrF
	ibnFpXnpesn5uZsYgUF7+t+z3h2Mtw9YH2JMBho3kVlKNDkfGPR5JfGGxmZGFqYmpsZG5pZm
	pAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCU5XesueD2bIG2Ty23+FeVBgkr
	7mdbLWvfMTy+1DdBmOvgvAuiy7Pqev/cM3zzq2X7vf+PL1/yWbbwx5eoFM2Z+yKnPfw+aXPa
	tE+JGmm8kc5v3P4UPDpdLS3O09z1M4VJRWrlj4Cpj3wNTfZKFNxPVTGfu3Gn2itPO1FP/8WP
	dXynV7nfEHBXYinOSDTUYi4qTgQAzdB1RXACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV2p/YcCDbb9ZLJ42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8btxctZCzoTKtY+P8DewLjN
	v4uRg0NCwERi80ruLkZOIFNM4sK99WxdjFwcQgLTGSV2/d7MBOH8Z5RYd6+XBaSKTUBLYv+L
	G2wgtoiAm8TMXfPBipgFtjJKPGs6xwiSEBZIlFhwaR1YA4uAqsTWK1vB4rwCrhJdv+cyQayT
	k/iw5xH7BEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+KZ9A7GVQ0WhxgFOBiV
	eHg1Lh8MFGJNLCuuzD3EKMHBrCTCmzrnUKAQb0piZVVqUX58UWlOavEhxmSg7ROZpUST84ER
	m1cSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjNPiVVYIX5u2
	9wb7zd2/458lLzy7ZOKRbSbZkyRXMLk2vuj9qDB1s2jsywYj7x+9/X/Va5Ztf3xZv7Nk4d2g
	H+4mdfnPpO33ByktyrfX/FHnvF7Ycmuq7pZTEb4r7aPlYzaHLfB8HXBx1ZEdm+pNNrZdjc2K
	0D0xeaNAm06cs231zYQvjw0tXZVYijMSDbWYi4oTAeJsgtPOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new 'load_table' debugfs file to show previous accumulated data
of CPUs load as following path and add CPUFREQ_LOADCHECK notification to
CPUFREQ_TRANSITION_NOTIFIER notifier chain.
- /sys/kernel/debug/cpufreq/load_table

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
Changes since v1:
- Set maximum storage size to save CPUs load on Kconfig
- Use spinlock to synchronize read/write operation for CPUs load
- Use local variable instead of global variable(struct cpufreq_freqs *freqs)
- Use pointer of data structure to get correct size of data structure
  in sizeof() macro instead of structure name
  : sizeof(struct cpufreq_freqs) -> sizeof(*stat->load_table)
- Change time unit from nanosecond to microsecond
- Remove unnecessary memory copy

 drivers/cpufreq/Kconfig            |   6 ++
 drivers/cpufreq/cpufreq.c          |   4 +
 drivers/cpufreq/cpufreq_governor.c |  19 +++-
 drivers/cpufreq/cpufreq_stats.c    | 192 +++++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h            |   6 ++
 5 files changed, 206 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..8a429b3 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -45,6 +45,12 @@ config CPU_FREQ_STAT_DETAILS
 
 	  If in doubt, say N.
 
+config NR_CPU_LOAD_STORAGE
+	int "Maximum storage size to save CPU load (10-100)"
+	range 10 100
+	depends on CPU_FREQ_STAT_DETAILS
+	default "10"
+
 choice
 	prompt "Default CPUFreq governor"
 	default CPU_FREQ_DEFAULT_GOV_USERSPACE if ARM_SA1100_CPUFREQ || ARM_SA1110_CPUFREQ
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
index dc9b72e..bca341b 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -90,6 +90,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 	unsigned int max_load = 0;
 	unsigned int ignore_nice;
 	unsigned int j;
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	struct cpufreq_freqs freq;
+#endif
 
 	if (dbs_data->cdata->governor == GOV_ONDEMAND)
 		ignore_nice = od_tuners->ignore_nice;
@@ -144,11 +147,17 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
-		if (unlikely(!wall_time || wall_time < idle_time))
+		if (unlikely(!wall_time || wall_time < idle_time)) {
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+			freq.load[j] = 0;
+#endif
 			continue;
+		}
 
 		load = 100 * (wall_time - idle_time) / wall_time;
-
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+		freq.load[j] = load;
+#endif
 		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			int freq_avg = __cpufreq_driver_getavg(policy, j);
 			if (freq_avg <= 0)
@@ -161,6 +170,12 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+	freq.time = ktime_to_ms(ktime_get());
+	freq.old = freq.new = policy->cur;
+
+	cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
+#endif
 	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..289d675 100644
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
@@ -23,6 +24,7 @@
 #include <asm/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
+static spinlock_t cpufreq_stats_lock_load_table;
 
 struct cpufreq_stats {
 	unsigned int cpu;
@@ -35,6 +37,12 @@ struct cpufreq_stats {
 	unsigned int *freq_table;
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	unsigned int *trans_table;
+
+	/* debugfs file for load_table */
+	struct cpufreq_freqs *load_table;
+	unsigned int load_last_index;
+	unsigned int load_max_index;
+	struct dentry *debugfs_cpufreq;
 #endif
 };
 
@@ -149,6 +157,134 @@ static struct attribute_group stats_attr_group = {
 	.name = "stats"
 };
 
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+#define MAX_LINE_SIZE		255
+static ssize_t load_table_read(struct file *file, char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct cpufreq_policy *policy = file->private_data;
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	struct cpufreq_freqs *load_table = stat->load_table;
+	unsigned int alloc_size_buf;
+	ssize_t len = 0;
+	char *buf;
+	int i, j, ret;
+
+	alloc_size_buf = MAX_LINE_SIZE * stat->load_max_index;
+	buf = kzalloc(alloc_size_buf, GFP_KERNEL);
+	if (!buf)
+		return 0;
+
+	spin_lock(&cpufreq_stats_lock_load_table);
+	len += sprintf(buf + len, "%10s %10s", "Time", "Frequency");
+	for (j = 0; j < NR_CPUS; j++)
+		len += sprintf(buf + len, " %3s%d", "cpu", j);
+	len += sprintf(buf + len, "\n");
+
+	i = stat->load_last_index;
+	do {
+		len += sprintf(buf + len, "%10lld %10d",
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
+	spin_unlock(&cpufreq_stats_lock_load_table);
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
+static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq)
+{
+	struct cpufreq_stats *stat;
+	int i, last_index;
+
+	stat = per_cpu(cpufreq_stats_table, freq->cpu);
+	if (!stat)
+		return;
+
+	spin_lock(&cpufreq_stats_lock_load_table);
+	last_index = stat->load_last_index;
+	stat->load_table[last_index].old = freq->old;
+	stat->load_table[last_index].time = freq->time;
+	for (i = 0; i < NR_CPUS; i++)
+		stat->load_table[last_index].load[i] = freq->load[i];
+
+	if (++stat->load_last_index == stat->load_max_index)
+		stat->load_last_index = 0;
+	spin_unlock(&cpufreq_stats_lock_load_table);
+}
+
+static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	unsigned int alloc_size_load;
+	int ret = 0;
+
+	stat->load_last_index = 0;
+	stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
+	alloc_size_load = sizeof(*stat->load_table) * stat->load_max_index;
+	stat->load_table = kzalloc(alloc_size_load, GFP_KERNEL);
+	if (!stat->load_table) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	stat->debugfs_cpufreq = debugfs_create_dir("cpufreq", NULL);
+	if (!stat->debugfs_cpufreq) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpufreq,
+				(void *)policy, &load_table_fops);
+err:
+	return ret;
+}
+
+static void cpufreq_stats_free_debugfs(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+
+	if (!policy)
+		return;
+
+	if (!policy_is_shared(policy)) {
+		pr_debug("%s: Free debugfs stat\n", __func__);
+		debugfs_remove(stat->debugfs_cpufreq);
+	}
+}
+#else
+static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq)
+{
+	return 0;
+}
+static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
+{
+	return 0;
+}
+static void cpufreq_stats_free_debugfs(unsigned int cpu)
+{
+	return;
+}
+#endif
+
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
@@ -167,6 +303,9 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 
 	if (stat) {
 		pr_debug("%s: Free stat table\n", __func__);
+#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
+		kfree(stat->load_table);
+#endif
 		kfree(stat->time_in_state);
 		kfree(stat);
 		per_cpu(cpufreq_stats_table, cpu) = NULL;
@@ -257,6 +396,13 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
+
+	ret = cpufreq_stats_create_debugfs(data);
+	if (ret) {
+		ret = -EINVAL;
+		goto error_out;
+	}
+
 	spin_unlock(&cpufreq_stats_lock);
 	cpufreq_cpu_put(data);
 	return 0;
@@ -312,32 +458,38 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	struct cpufreq_stats *stat;
 	int old_index, new_index;
 
-	if (val != CPUFREQ_POSTCHANGE)
-		return 0;
-
-	stat = per_cpu(cpufreq_stats_table, freq->cpu);
-	if (!stat)
-		return 0;
+	switch (val) {
+	case CPUFREQ_POSTCHANGE:
+		stat = per_cpu(cpufreq_stats_table, freq->cpu);
+		if (!stat)
+			return 0;
 
-	old_index = stat->last_index;
-	new_index = freq_table_get_index(stat, freq->new);
+		old_index = stat->last_index;
+		new_index = freq_table_get_index(stat, freq->new);
 
-	/* We can't do stat->time_in_state[-1]= .. */
-	if (old_index == -1 || new_index == -1)
-		return 0;
+		/* We can't do stat->time_in_state[-1]= .. */
+		if (old_index == -1 || new_index == -1)
+			return 0;
 
-	cpufreq_stats_update(freq->cpu);
+		cpufreq_stats_update(freq->cpu);
 
-	if (old_index == new_index)
-		return 0;
+		if (old_index == new_index)
+			return 0;
 
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
+		break;
+	case CPUFREQ_LOADCHECK:
+		cpufreq_stats_store_load_table(freq);
+		break;
+	}
+
 	return 0;
 }
 
@@ -352,12 +504,14 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+		cpufreq_stats_free_debugfs(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
 		cpufreq_stats_free_table(cpu);
 		break;
 	case CPU_UP_CANCELED_FROZEN:
+		cpufreq_stats_free_debugfs(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 		cpufreq_stats_free_table(cpu);
 		break;
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

