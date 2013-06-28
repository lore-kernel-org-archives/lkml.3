Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3F1Hsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:48:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65145 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3F1Hsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:48:33 -0400
X-AuditID: cbfee691-b7fef6d000002d62-f2-51cd3fc76a70
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
Date: Fri, 28 Jun 2013 16:48:17 +0900
Message-id: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkUPe4/dlAg3Vv1CyeNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DK+L13B0vBq07GitML7rM0MF7L6GLk5JAQMJE48W4DI4QtJnHh3nq2
	LkYuDiGBpYwS7yf8ZocpWnX1FTOILSQwnVHixItEiKL/jBKHZ+1kBUmwCWhJ7H9xgw3EFhFw
	k1h77RMjSBGzwBRGieZjm8ASwgIpEou6H4JNYhFQlZi28xlYnFfAVeLIwm4miG1yEh/2PGIH
	aZYQ+M8m8bH3IgtEg4DEt8mHgGwOoISsxKYDzBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqR
	qV5xYm5xaV66XnJ+7iZGYOCe/vds4g7G+wesDzEmA42byCwlmpwPDPy8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC61JRIJm4qN5/Ykm3wMD5T
	acWZekbtu+rpeoxCO1e7MS5tdg359PLJhI+afL5tW49WX8h6/Jnt5a4+mSvLt6+270iqcnio
	IZbyvIR/yddfK5+G5NxVOMvLFKB6+OO0M9PLbfQ6su/kBe5RSe37rPwhQGDppm0zlhyq3VHi
	fVFM//f3Ir/uZWeUWIozEg21mIuKEwF/ShYwcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQd3j9mcDDVo7pC2eNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	iWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkNJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPF77w6WgledjBWnF9xnaWC8
	ltHFyMkhIWAiserqK2YIW0ziwr31bCC2kMB0RokTLxK7GLmA7P+MEodn7WQFSbAJaEnsf3ED
	rEhEwE1i7bVPjCBFzAJTGCWaj20CSwgLpEgs6n4INpVFQFVi2s5nYHFeAVeJIwu7mSC2yUl8
	2POIfQIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwXHxTGoH48oGi0OMAhyMSjy8
	jYlnAoVYE8uKK3MPMUpwMCuJ8N5ZABTiTUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjBm80ri
	DY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBscwxqnd3/NPp18rU
	tGx4rR67TQller/U4Nu6KcnHJ9nO/Vy5b60IB2/ufKf61RJrHiz1/1Q+3UdUWU4tWC1+odM3
	y+Mn/b3e1/XcTlhrqbfklm6Cbs3eymsv4k6UdN15+VnE2u2D8NvJdtuPH2/W9fQtdelbp9a0
	+HTj9Bopt6o8FZG6HdeuKbEUZyQaajEXFScCALqPL1fPAgAA
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
Changes since v3:
- Extend a range of accumulated data (10 ~ 1000)
- Add unit information of time/freq and align 'Time' field as left for readability
- Use CONFIG_CPU_FREQ_STAT depdendency instead of CONFIG_CPU_FREQ_STAT_DETATILS
- Initialize load of Offline CPUx as zero(0)
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
- NR_CPU_LOAD_STORAGE : 50
- command : cat /sys/kernel/debug/cpufreq/cpu0/load_table

Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
175320          1400000      1400000   41   47    0   79
175420          1400000      1200000   44   26    0   59
175520          1200000      1600000   82   74    0   74
175620          1600000      1600000   79   35    0   52
175720          1600000       400000   15   17    0   10
175820           400000       400000   65    7    0   10
175920           400000      1600000    2  100    0    0
176020          1600000      1100000   51   39    0   21
176120          1100000       600000   38   11    0   19
176220           600000       500000   55   13    0   24
176320           500000       200000   13    1    0    0
176420           200000       200000   16    1    0   63
176520           200000       200000    7    5    0    4
176620           200000       200000   73   49    0   49
176720           200000      1600000   37   99    0   20
176820          1600000      1000000   46    8    0    8
176920          1000000       600000   45   16    0    5
177020           600000       500000   54   17    0    0
177120           500000       500000   73   39    0   72
177220           500000       500000   67    5    0   29
177320           500000       500000   69    3    0   13
177420           500000       400000   55   14    0   39
177520           400000       200000   22   11    0    1
177620           200000       200000   70    8    0   61
177720           200000      1600000   96   30    0   16
177820          1600000       300000   12    5    0   13
177920           300000       200000   12   11    0   25
178020           200000       200000    8    0    0   21
178120           200000       200000   27   57    0   47
178220           200000       200000   41   27    0   29
178320           200000      1600000   89    2    0   18
178420          1600000       600000   26    2    0    5
178520           600000       200000    4    3    0    8
178620           200000      1600000   50    0    0  100
178720          1600000      1300000   57   11    0   15
178820          1300000       300000   12    0    0    7
178920           300000       200000   11    0    0   10
179022           200000       200000   65    0    0    5
179120           200000       200000   37    4    0   18
179220           200000       200000   75   41    0   20
179320           200000       200000   48    9    0   11
179420           200000       200000   45    9    0    1
179520           200000       200000   74   17    0   14
179620           200000       200000   44   10    0    9
179720           200000       200000   46   23    0    6
179820           200000      1600000   47   82    0   31
179920          1600000       200000    2    3    0    3
180020           200000       200000   11    7    0   53
180120           200000       200000   17   32    0    9
180220           200000       200000    9   35    0   14

 drivers/cpufreq/Kconfig            |   6 +
 drivers/cpufreq/cpufreq.c          |   4 +
 drivers/cpufreq/cpufreq_governor.c |  15 +++
 drivers/cpufreq/cpufreq_stats.c    | 241 +++++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h            |   6 +
 5 files changed, 246 insertions(+), 26 deletions(-)

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
index 2d53f47..19596e2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -292,6 +292,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
 			policy->cur = freqs->new;
 		break;
+	case CPUFREQ_LOADCHECK:
+		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
+					 CPUFREQ_LOADCHECK, freqs);
+		break;
 	}
 }
 /**
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index dc9b72e..a13bdf9 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -87,6 +87,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	struct cpufreq_policy *policy;
+#ifdef CONFIG_CPU_FREQ_STAT
+	struct cpufreq_freqs freq;
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
@@ -161,6 +167,15 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+#ifdef CONFIG_CPU_FREQ_STAT
+	for_each_cpu_not(j, policy->cpus)
+		freq.load[j] = 0;
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
index fb65dec..545bce1 100644
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
+static struct dentry *debugfs_cpufreq;
 
 struct cpufreq_stats {
 	unsigned int cpu;
@@ -36,6 +38,12 @@ struct cpufreq_stats {
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	unsigned int *trans_table;
 #endif
+
+	/* Debugfs file for load_table */
+	struct dentry *debugfs_cpu;
+	struct cpufreq_freqs *load_table;
+	unsigned int load_last_index;
+	unsigned int load_max_index;
 };
 
 static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
@@ -149,6 +157,154 @@ static struct attribute_group stats_attr_group = {
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
+	len += sprintf(buf + len, "%-10s %12s %12s ", "Time(ms)",
+						    "Old Freq(Hz)",
+						    "New Freq(Hz)");
+	for_each_present_cpu(cpu)
+		len += sprintf(buf + len, "%3s%d ", "CPU", cpu);
+	len += sprintf(buf + len, "\n");
+
+	i = stat->load_last_index;
+	do {
+		len += sprintf(buf + len, "%-10lld %12d %12d ",
+				load_table[i].time,
+				load_table[i].old,
+				load_table[i].new);
+
+		for_each_present_cpu(cpu)
+			len += sprintf(buf + len, "%4d ",
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
+static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
+	char buf[10];
+	int size, ret = 0;
+
+	if (!stat)
+		return -EINVAL;
+
+	if (!debugfs_cpufreq)
+		return -ENOMEM;
+
+	stat->load_last_index = 0;
+	stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
+
+	/* Allocate memory for storage of CPUs load */
+	size = sizeof(*stat->load_table) * stat->load_max_index;
+	stat->load_table = kzalloc(size, GFP_KERNEL);
+	if (!stat->load_table) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Create debugfs directory and file for cpufreq */
+	sprintf(buf, "cpu%d", policy->cpu);
+	stat->debugfs_cpu = debugfs_create_dir(buf, debugfs_cpufreq);
+	if (!stat->debugfs_cpu) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	if (!debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpu,
+				policy, &load_table_fops)) {
+		ret = -ENOMEM;
+		goto err_debugfs;
+	}
+
+	return 0;
+
+err_debugfs:
+	debugfs_remove_recursive(stat->debugfs_cpu);
+err_alloc:
+	kfree(stat->load_table);
+err:
+	return ret;
+}
+
+static void cpufreq_stats_free_debugfs(unsigned int cpu)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+
+	if (!stat)
+		return;
+
+	pr_debug("%s: Free debugfs stat\n", __func__);
+	debugfs_remove_recursive(stat->debugfs_cpu);
+}
+
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
@@ -167,6 +323,7 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 
 	if (stat) {
 		pr_debug("%s: Free stat table\n", __func__);
+		kfree(stat->load_table);
 		kfree(stat->time_in_state);
 		kfree(stat);
 		per_cpu(cpufreq_stats_table, cpu) = NULL;
@@ -257,6 +414,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
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
@@ -312,32 +477,40 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
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
 
@@ -352,12 +525,14 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
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
@@ -396,16 +571,28 @@ static int __init cpufreq_stats_init(void)
 
 	ret = cpufreq_register_notifier(&notifier_trans_block,
 				CPUFREQ_TRANSITION_NOTIFIER);
-	if (ret) {
-		cpufreq_unregister_notifier(&notifier_policy_block,
-				CPUFREQ_POLICY_NOTIFIER);
-		unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-		for_each_online_cpu(cpu)
-			cpufreq_stats_free_table(cpu);
-		return ret;
+	if (ret)
+		goto err;
+
+	debugfs_cpufreq = debugfs_create_dir("cpufreq", NULL);
+	if (!debugfs_cpufreq) {
+		ret = -ENOMEM;
+		goto err_debugfs;
 	}
 
 	return 0;
+
+err_debugfs:
+	cpufreq_unregister_notifier(&notifier_trans_block,
+			CPUFREQ_TRANSITION_NOTIFIER);
+err:
+	cpufreq_unregister_notifier(&notifier_policy_block,
+			CPUFREQ_POLICY_NOTIFIER);
+	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
+	for_each_online_cpu(cpu)
+		cpufreq_stats_free_table(cpu);
+
+	return ret;
 }
 static void __exit cpufreq_stats_exit(void)
 {
@@ -418,8 +605,10 @@ static void __exit cpufreq_stats_exit(void)
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_debugfs(cpu);
 		cpufreq_stats_free_sysfs(cpu);
 	}
+	debugfs_remove(debugfs_cpufreq);
 }
 
 MODULE_AUTHOR("Zou Nan hai <nanhai.zou@intel.com>");
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..7cf71d4 100644
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
+#ifdef CONFIG_CPU_FREQ_STAT
+	int64_t time;
+	unsigned int load[NR_CPUS];
+#endif
 };
 
 
-- 
1.8.0

