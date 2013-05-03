Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3ECOI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:08:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10024 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762806Ab3ECOIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:08:02 -0400
X-AuditID: cbfee690-b7f136d000000fea-40-5183c4bfc777
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC v2 2/3] cpufreq:LAB: Introduce new cpufreq LAB(Legacy Application
 Boost) governor
Date: Fri, 03 May 2013 23:07:51 +0900
Message-id: <1367590072-10496-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpHvgSHOgwbydzBZPm36wW8z7LGvR
	efYJs8Wbh5sZLS7vmsNm8bn3CKPF7cYVbBb9C3uZLDqOfGO22PjVw4HL4861PWwefVtWMXo8
	WtzC6PF5k1wASxSXTUpqTmZZapG+XQJXxvsbb5kL5k9irDj6YQ9zA+P1ii5GTg4JAROJSX0t
	zBC2mMSFe+vZuhi5OIQEljJKTJuylxmmaM+lZ8wQiUWMEvcnv2CEcFqYJC7N/Q9WxSagI/F/
	3012EFtEQEFic+8zVpAiZoEHTBJrlr8BSwgLJEo8fP8brIFFQFXi2PznTCA2r4CHxPIrX1m6
	GDmA1ilIzJlkAxLmFPCU2LpnFQuILQRU0tWwEmyxhMAmdonHD14zQswRkPg2+RBUr6zEpgNQ
	V0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGhf/rfswk7GO8dsD7E
	mAw0biKzlGhyPjB28kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXA2JnFxTb/Zy0/U+8P/v9G002cFy/rfOnMmPrjwYNglt0MRp5WVbwTtO1kb8ZY
	T1d6sPDVkn7OsKp9Px/nbpk2t8flyWbLWPHpBUeP3dA6tew8T6jU+X/GrpMNOmTsNiyTW1Ma
	88ReKv6Vmfvana6eUxPc/vMmP9qS8vSfIPfmUtV/B5tPGfMZKLEUZyQaajEXFScCAKYcrkuT	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAd39R5oDDT7fNrJ42vSD3WLeZ1mL
	zrNPmC3ePNzMaHF51xw2i8+9RxgtbjeuYLPoX9jLZNFx5BuzxcavHg5cHneu7WHz6NuyitHj
	0eIWRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgO5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGa8v/GWuWD+
	JMaKox/2MDcwXq/oYuTkkBAwkdhz6RkzhC0mceHeerYuRi4OIYFFjBL3J79ghHBamCQuzf0P
	VsUmoCPxf99NdhBbREBBYnPvM1aQImaBB0wSa5a/AUsICyRKPHz/G6yBRUBV4tj850wgNq+A
	h8TyK19Zuhg5gNYpSMyZZAMS5hTwlNi6ZxULiC0EVNLVsJJxAiPvAkaGVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxjBkfVMegfjqgaLQ4wCHIxKPLwKLU2BQqyJZcWVuYcYJTiYlUR4Mxqb
	A4V4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5Hxj1eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXAyHdovnTMxP8xfdPmfZu/6LThljzrdUsEEjojXp5/sf/F
	k5sBiSoWWqdmsS5dqHrd/Vjv6oVasjHpjWIrYvdO36Pd6PCZXdx2y/KqjWIhU8RWblqlvkHm
	EufliZIb75wUPM7mdu5PTuHUJ2Lheptm1Z0491B9c97uOws3pa6U3R+wkplTZ8199m4lluKM
	REMt5qLiRAAAJj2x8AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

This patch introduces new cpufreq governor named 'LAB'.
LAB governor will use scheduler, per-CPU information to determine how many
CPUs are in busy now. As a result the number of idle CPUs is calculated
for current load (digital low pass filtering is used to provide more stable
results). It will determine next frequency.

For instance, we can assume that it is working on quad core processor.

For each number of idle CPUs, separate single polynomial function has been
calculated (with different slope). For all CPUs idle, minimal policy freq
is chosen.

With only one busy processor, the new feature (overclock) will enable CPU
frequency boost above normal operation limit. This will allow for "faster"
work finish.
With two running CPUs, overclocking is disabled and output frequency is
close to maximum.
For three running cores the frequency is further lowered (the slope of
approximation polynomial changes, when compared to two running CPUs).

When all four cores are busy, the frequency is lowered. The slope of polynomial
is decreasing, so higher load will cause lower freq.

The LAB governor rely on following kernel features:
- TMU (Thermal Management Unit) to disable overclocking when thermal trip point
is passed (notifier for cpufreq TMU generated event is registered at LAB).
- overclocking - needed to set frequency above standard levels.

The LAB governor itself uses infrastructure (work_struct) from ondemand.
The ondemand calculates the highest load among all available CPUs. The LAB
adjusts the freq characteristics depending on the number of idle CPUs.

The LAB governor shall be used with either:
- Vincent Guittot's "packing small tasks" patch
- Alex Shi's power-aware scheduling patch

Those patches help with putting to idle as much CPUs as possible.

Tested at 3.8 linux kernel, Exynos4412 Device

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/Kconfig       |   26 +++
 drivers/cpufreq/Makefile      |    1 +
 drivers/cpufreq/cpufreq_lab.c |  450 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h       |    3 +
 4 files changed, 480 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 5a1c236..81d7ea7 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -109,6 +109,18 @@ config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 	  Be aware that not all cpufreq drivers support the conservative
 	  governor. If unsure have a look at the help section of the
 	  driver. Fallback governor will be the performance governor.
+
+config CPU_FREQ_DEFAULT_GOV_LAB
+	bool "lab"
+	select CPU_FREQ_GOV_LAB
+	select CPU_FREQ_GOV_PERFORMANCE
+	help
+	  Use the CPUFreq governor 'lab' as default. This allows
+	  you to get a full dynamic frequency capable system by simply
+	  loading your cpufreq low-level hardware driver.
+	  Be aware that not all cpufreq drivers support the lab governor.
+	  If unsure have a look at the help section of the driver.
+	  Fallback governor will be the performance governor.
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
@@ -191,6 +203,20 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_GOV_LAB
+	tristate "'lab' cpufreq policy governor"
+	select CPU_FREQ_TABLE
+	select CPU_FREQ_GOV_COMMON
+	help
+	  'lab' - This driver adds a dynamic cpufreq policy governor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_ondemand.
+
+	  For details, take a look at linux/Documentation/cpu-freq.
+
+	  If in doubt, say N.
+
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
 	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 315b923..d8252a7 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
 obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOV_LAB)		+= cpufreq_lab.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 # CPUfreq cross-arch helpers
diff --git a/drivers/cpufreq/cpufreq_lab.c b/drivers/cpufreq/cpufreq_lab.c
new file mode 100644
index 0000000..e992810
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_lab.c
@@ -0,0 +1,450 @@
+/*
+ *  drivers/cpufreq/cpufreq_lab.c
+ *
+ *  LAB(Legacy Application Boost) cpufreq governor
+ *
+ *  Copyright (C) SAMSUNG Electronics. CO.
+ *		Jonghwa Lee <jonghw3.lee@samusng.com>
+ *		Lukasz Majewski <l.majewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cpufreq.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu-defs.h>
+#include <linux/sysfs.h>
+#include <linux/tick.h>
+#include <linux/types.h>
+#include <linux/cpuidle.h>
+#include <linux/slab.h>
+
+#include "cpufreq_governor.h"
+
+#define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
+#define DEF_FREQUENCY_UP_THRESHOLD		(80)
+#define DEF_SAMPLING_DOWN_FACTOR		(1)
+#define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
+#define MICRO_FREQUENCY_UP_THRESHOLD		(95)
+#define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
+
+#define MAX_HIST		5
+#define FREQ_STEP		50000
+#define IDLE_THRESHOLD		90
+#define OVERCLK_THRESHOLD       90
+
+/* Pre-calculated summation of weight, 0.5
+ * 1
+ * 1 + 0.5^1 = 1.5
+ * 1 + 0.5^1 + 0.5^2 = 1.75
+ * 1 + 0.5^1 + 0.5^2 + 0.5^3 = 1.87
+ * 1 + 0.5^1 + 0.5^2 + 0.5^3 + 0.5^4 = 1.93
+ */
+static int history_weight_sum[] = { 100, 150, 175, 187, 193 };
+
+static unsigned int *idle_avg;
+static unsigned int **idle_hist;
+
+static struct dbs_data lb_dbs_data;
+static DEFINE_PER_CPU(struct lb_cpu_dbs_info_s, lb_cpu_dbs_info);
+
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_LAB
+static struct cpufreq_governor cpufreq_gov_lab;
+#endif
+
+/* Single polynomial approx -> all CPUs busy */
+static int a_all = -6, b_all = 1331;
+/* Single polynomial approx -> one CPUs busy */
+static int a_one = 10, b_one = 205;
+/* Single polynomial approx -> 2,3... CPUs busy */
+static int a_rest = 4, b_rest1 = 100, b_rest2 = 300;
+/* Polynomial divider */
+static int poly_div = 1024;
+
+static struct od_dbs_tuners lb_tuners = {
+	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
+	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
+	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
+	.ignore_nice = 0,
+};
+
+/**
+ * cpufreq_overclock_notifier - notifier callback for cpufreq policy change.
+ * @nb:	struct notifier_block * with callback info.
+ * @event: value showing cpufreq event for which this function invoked.
+ * @data: callback-specific data
+ */
+static int cpufreq_overclk_notifier(struct notifier_block *nb,
+				    unsigned long event, void *data)
+{
+	struct cpufreq_policy *policy = data;
+
+	if (event == CPUFREQ_INCOMPATIBLE &&
+	    cpufreq_overclk_max() == policy->cur) {
+		pr_info("NOTIFIER OVERCLOCK: MAX: %d e:%lu cpu: %d\n",
+			policy->max, event, policy->cpu);
+		cpufreq_overclk_dis(policy);
+	}
+
+	return 0;
+}
+
+/* Notifier for cpufreq policy change */
+static struct notifier_block cpufreq_overclk_notifier_block = {
+	.notifier_call = cpufreq_overclk_notifier,
+};
+
+static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
+{
+	if (p->cur == freq)
+		return;
+
+	__cpufreq_driver_target(p, freq, CPUFREQ_RELATION_L);
+}
+
+/* Calculate average of idle time with weighting 50% less to older one.
+ * With weight, average can be affected by current phase more rapidly than
+ * normal average. And it also has tolerance for temporary fluctuation of
+ * idle time as normal average has.
+ *
+ * Weigted average = sum(ai * wi) / sum(wi)
+ */
+static inline int cpu_idle_calc_avg(unsigned int *p, int size)
+{
+	int i, sum;
+
+	for (i = 0, sum = 0; i < size; p++, i++) {
+		sum += *p;
+		*p >>= 1;
+	}
+	sum *= 100;
+
+	return (int) (sum / history_weight_sum[size]);
+}
+
+/*
+ * LAB governor policy adjustement
+ */
+static void lb_check_cpu(int cpu, unsigned int load_freq)
+{
+	struct lb_cpu_dbs_info_s *dbs_info = &per_cpu(lb_cpu_dbs_info, cpu);
+	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	int i, idx, idle_cpus = 0, b = 0;
+	static int cnt = 0;
+	unsigned int freq = 0;
+
+	idx = cnt++ % MAX_HIST;
+
+	for_each_possible_cpu(i) {
+		struct lb_cpu_dbs_info_s *dbs_cpu_info =
+			&per_cpu(lb_cpu_dbs_info, i);
+
+		idle_hist[i][idx] = dbs_cpu_info->idle_time;
+		idle_avg[i] = cpu_idle_calc_avg(idle_hist[i],
+					cnt < MAX_HIST ? cnt : MAX_HIST);
+
+		if (idle_avg[i] > IDLE_THRESHOLD)
+			idle_cpus++;
+	}
+#if 0
+	pr_info("load_freq: %d idle: %d\n", load_freq, idle_cpus);
+#endif
+	if (idle_cpus < 0 || idle_cpus > NR_CPUS) {
+		pr_warn("idle_cpus: %d out of range\n", idle_cpus);
+		return;
+	}
+
+	if (idle_cpus == 0) { /* Full load -> reduce freq */
+		freq = policy->max * (a_all * load_freq + b_all) / poly_div;
+
+	} else if (idle_cpus == NR_CPUS) { /* Idle cpus */
+		cpufreq_overclk_dis(policy);
+		freq = policy->min;
+
+	} else if (idle_cpus == (NR_CPUS - 1)) {
+		/* Enable overclocking */
+		if(load_freq > OVERCLK_THRESHOLD)
+			cpufreq_overclk_en(policy);
+
+		freq = policy->max * (a_one * load_freq + b_one) / poly_div;
+
+	} else {
+		/* Adjust frequency with number of available CPUS */
+		/* smaller idle_cpus -> smaller frequency */
+		b = ((idle_cpus - 1) * b_rest1) + b_rest2;
+		freq = policy->max * (a_rest * load_freq + b) / poly_div;
+	}
+#if 1
+	if (!idx)
+		pr_info("p->max:%d,freq: %d,idle_cpus: %d,avg : %d %d %d %d load_f: %d\n",
+		       policy->max, freq, idle_cpus, idle_avg[0], idle_avg[1],
+			idle_avg[2], idle_avg[3], load_freq);
+#endif
+
+	dbs_freq_increase(policy, freq);
+}
+
+static void lb_dbs_timer(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct lb_cpu_dbs_info_s *dbs_info =
+		container_of(work, struct lb_cpu_dbs_info_s, cdbs.work.work);
+	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
+	struct lb_cpu_dbs_info_s *core_dbs_info = &per_cpu(lb_cpu_dbs_info,
+			cpu);
+	int delay, sample_type = core_dbs_info->sample_type;
+
+	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
+
+	/* Common NORMAL_SAMPLE setup */
+	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+	if (sample_type == OD_SUB_SAMPLE) {
+		delay = core_dbs_info->freq_lo_jiffies;
+		__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
+			core_dbs_info->freq_lo, CPUFREQ_RELATION_H);
+	} else {
+		dbs_check_cpu(&lb_dbs_data, cpu);
+		if (core_dbs_info->freq_lo) {
+			/* Setup timer for SUB_SAMPLE */
+			core_dbs_info->sample_type = OD_SUB_SAMPLE;
+			delay = core_dbs_info->freq_hi_jiffies;
+		} else {
+			delay = delay_for_sampling_rate(lb_tuners.sampling_rate
+						* core_dbs_info->rate_mult);
+		}
+	}
+
+	dbs_info->last_sampling_rate = jiffies_to_usecs(delay);
+
+	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
+}
+
+/************************** sysfs interface ************************/
+
+static ssize_t show_sampling_rate_min(struct kobject *kobj,
+				      struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lb_dbs_data.min_sampling_rate);
+}
+
+/**
+ * update_sampling_rate - update sampling rate effective immediately if needed.
+ * @new_rate: new sampling rate
+ *
+ * If new rate is smaller than the old, simply updating
+ * dbs_tuners_int.sampling_rate might not be appropriate. For example, if the
+ * original sampling_rate was 1 second and the requested new sampling rate is 10
+ * ms because the user needs immediate reaction from lab governor, but not
+ * sure if higher frequency will be required or not, then, the governor may
+ * change the sampling rate too late; up to 1 second later. Thus, if we are
+ * reducing the sampling rate, we need to make the new value effective
+ * immediately.
+ */
+static void update_sampling_rate(unsigned int new_rate)
+{
+	int cpu;
+
+	lb_tuners.sampling_rate = new_rate = max(new_rate,
+			lb_dbs_data.min_sampling_rate);
+
+	for_each_online_cpu(cpu) {
+		struct cpufreq_policy *policy;
+		struct lb_cpu_dbs_info_s *dbs_info;
+		unsigned long next_sampling, appointed_at;
+
+		policy = cpufreq_cpu_get(cpu);
+		if (!policy)
+			continue;
+		if (policy->governor != &cpufreq_gov_lab) {
+			cpufreq_cpu_put(policy);
+			continue;
+		}
+		dbs_info = &per_cpu(lb_cpu_dbs_info, cpu);
+		cpufreq_cpu_put(policy);
+
+		mutex_lock(&dbs_info->cdbs.timer_mutex);
+
+		if (!delayed_work_pending(&dbs_info->cdbs.work)) {
+			mutex_unlock(&dbs_info->cdbs.timer_mutex);
+			continue;
+		}
+
+		next_sampling = jiffies + usecs_to_jiffies(new_rate);
+		appointed_at = dbs_info->cdbs.work.timer.expires;
+
+		if (time_before(next_sampling, appointed_at)) {
+
+			mutex_unlock(&dbs_info->cdbs.timer_mutex);
+			cancel_delayed_work_sync(&dbs_info->cdbs.work);
+			mutex_lock(&dbs_info->cdbs.timer_mutex);
+
+			schedule_delayed_work_on(cpu, &dbs_info->cdbs.work,
+					usecs_to_jiffies(new_rate));
+
+		}
+		mutex_unlock(&dbs_info->cdbs.timer_mutex);
+	}
+}
+
+static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	update_sampling_rate(input);
+	return count;
+}
+
+show_one(lb, sampling_rate, sampling_rate);
+define_one_global_rw(sampling_rate);
+define_one_global_ro(sampling_rate_min);
+
+static struct attribute *dbs_attributes[] = {
+	&sampling_rate_min.attr,
+	&sampling_rate.attr,
+	NULL
+};
+
+static struct attribute_group lb_attr_group = {
+	.attrs = dbs_attributes,
+	.name = "lab",
+};
+
+/************************** sysfs end ************************/
+
+static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
+		unsigned int freq_next, unsigned int relation)
+{
+	return 0;
+}
+
+static void powersave_bias_init_cpu(int cpu)
+{
+}
+
+static int should_io_be_busy(void)
+{
+	return 0;
+}
+
+define_get_cpu_dbs_routines(lb_cpu_dbs_info);
+
+static struct od_ops lb_ops = {
+	.io_busy = should_io_be_busy,
+	.powersave_bias_init_cpu = powersave_bias_init_cpu,
+	.powersave_bias_target = powersave_bias_target,
+	.freq_increase = dbs_freq_increase,
+};
+
+static struct dbs_data lb_dbs_data = {
+	.governor = GOV_LAB,
+	.attr_group = &lb_attr_group,
+	.tuners = &lb_tuners,
+	.get_cpu_cdbs = get_cpu_cdbs,
+	.get_cpu_dbs_info_s = get_cpu_dbs_info_s,
+	.gov_dbs_timer = lb_dbs_timer,
+	.gov_check_cpu = lb_check_cpu,
+	.gov_ops = &lb_ops,
+};
+
+static int lb_cpufreq_governor_dbs(struct cpufreq_policy *policy,
+		unsigned int event)
+{
+	return cpufreq_governor_dbs(&lb_dbs_data, policy, event);
+}
+
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_LAB
+static
+#endif
+struct cpufreq_governor cpufreq_gov_lab = {
+	.name			= "lab",
+	.governor		= lb_cpufreq_governor_dbs,
+	.max_transition_latency	= TRANSITION_LATENCY_LIMIT,
+	.owner			= THIS_MODULE,
+};
+
+static int __init cpufreq_gov_dbs_init(void)
+{
+	u64 idle_time;
+	int i, cpu = get_cpu(), ret;
+
+	mutex_init(&lb_dbs_data.mutex);
+	idle_time = get_cpu_idle_time_us(cpu, NULL);
+	put_cpu();
+	if (idle_time != -1ULL) {
+		/* Idle micro accounting is supported. Use finer thresholds */
+		lb_tuners.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
+		lb_tuners.down_differential = MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
+		/*
+		 * In nohz/micro accounting case we set the minimum frequency
+		 * not depending on HZ, but fixed (very low). The deferred
+		 * timer might skip some samples if idle/sleeping as needed.
+		*/
+		lb_dbs_data.min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
+	} else {
+		/* For correct statistics, we need 10 ticks for each measure */
+		lb_dbs_data.min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
+			jiffies_to_usecs(10);
+	}
+
+	/* Initialize arrays */
+	idle_avg = kzalloc(GFP_KERNEL,
+			num_possible_cpus() * sizeof(unsigned int));
+	idle_hist = kzalloc(GFP_KERNEL,
+			num_possible_cpus() * sizeof(unsigned int *));
+	for (i = 0; i < num_possible_cpus(); i++)
+		idle_hist[i] = kzalloc(GFP_KERNEL,
+					MAX_HIST * sizeof(unsigned int));
+
+	ret = cpufreq_register_notifier(&cpufreq_overclk_notifier_block,
+					CPUFREQ_POLICY_NOTIFIER);
+	if (ret) {
+		pr_err("CPUFREQ notifier not registered.\n");
+		return ret;
+	}
+
+	return cpufreq_register_governor(&cpufreq_gov_lab);
+}
+
+static void __exit cpufreq_gov_dbs_exit(void)
+{
+	int i;
+
+	if (!idle_avg)
+		kfree(idle_avg);
+	if (!idle_hist) {
+		for (i = 0; i < num_possible_cpus(); i++) {
+			if (!idle_hist[i])
+				kfree(idle_hist[i]);
+		}
+		kfree(idle_hist);
+	}
+
+	cpufreq_unregister_governor(&cpufreq_gov_lab);
+}
+
+MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
+MODULE_AUTHOR("Lukasz Majewski <l.majewski@samsung.com>");
+MODULE_DESCRIPTION("'cpufreq_lab' - A dynamic cpufreq governor for "
+		"Legacy Application Boosting");
+MODULE_LICENSE("GPL");
+
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_LAB
+fs_initcall(cpufreq_gov_dbs_init);
+#else
+module_init(cpufreq_gov_dbs_init);
+#endif
+module_exit(cpufreq_gov_dbs_exit);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 8c185d6..513f44f 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -411,6 +411,9 @@ extern struct cpufreq_governor cpufreq_gov_ondemand;
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE)
 extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_conservative)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_LAB)
+extern struct cpufreq_governor cpufreq_gov_lab;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_lab)
 #endif
 
 
-- 
1.7.9.5

