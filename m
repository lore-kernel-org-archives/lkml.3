Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab3DAIZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:25:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3DAIZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:25:06 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-4e-515944610bf7
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC PATCH 2/2] cpufreq: Introduce new cpufreq governor,
 LAB(Legacy Application Boost).
Date: Mon, 01 Apr 2013 17:24:17 +0900
Message-id: <1364804657-16590-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+Znm6iS2SgwZzPshZPm36wW1z/8pzV
	ovPsE2aLs01v2C3ePNzMaHF51xw2i8+9Rxgt1h65y25xu3EFm0X/wl4mixmTX7I5cHv0bVnF
	6PFocQujx+dNcgHMUVw2Kak5mWWpRfp2CVwZS05dYynoWc5YcfrbXdYGxsWdjF2MnBwSAiYS
	kzZsYoKwxSQu3FvP1sXIxSEksIxR4s71vSwwRXcPTGKGSExnlPg18zkjhNPCJLHlXx9YO5uA
	jsT/fTfZQWwRAVWJLU/+s4MUMQvcZpI43n8abJ+wQJLEs45rrCA2C1BR78enYM28Ah4S5359
	A6rhAFqnIDFnkg1ImFPAU+L1+p/MIGEhoJLNdwxARkoIrGOXeDBpDiPEGAGJb5MPsUC0ykps
	OsAMcbSkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRES/v07GO8esD7E
	mAw0biKzlGhyPjB+8kriDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAKHE/wO/NDnvv+iUbdNcwZt9vvP3O+Pms7Tun5n/6NXvZH6lp5vXXai/4vpX+
	zvuHvzHi8UqP+zu/qgW4eObNkIlz/XL89dQlC963bKh5dYSJYTP3uQ/yv879jilb53FJk7Hk
	2Ptji487sthsO1I7+X1I53EHNYdTyys+z+P98SBhuuHqz1PyIo8psRRnJBpqMRcVJwIASzPJ
	n5UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd1El8hAg2d/RC2eNv1gt7j+5Tmr
	RefZJ8wWZ5vesFu8ebiZ0eLyrjlsFp97jzBarD1yl93iduMKNov+hb1MFjMmv2Rz4Pbo27KK
	0ePR4hZGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOALlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZiw5dY2l
	oGc5Y8Xpb3dZGxgXdzJ2MXJySAiYSNw9MIkZwhaTuHBvPVsXIxeHkMB0RolfM58zQjgtTBJb
	/vUxgVSxCehI/N93kx3EFhFQldjy5D87SBGzwG0mieP9p8HGCgskSTzruMYKYrMAFfV+fArW
	zCvgIXHu1zegGg6gdQoScybZgIQ5BTwlXq//yQwSFgIq2XzHYAIj7wJGhlWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwdH1TGoH48oGi0OMAhyMSjy8ERciAoVYE8uKK3MPMUpwMCuJ8Pp8
	AwrxpiRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjDy80riDY1NzIwsjcyMTcyNjUkTVhLnPdBq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qBUZVLxovl9Bmbi2nx2hl7VTXLphc5vKs9fnr9fobudzPm
	li8r7zaeED7Tqj1mtVeUzIXP88/9X+Yns3/Nz9sqYsbP3x/+X3BJ+erNHT2ZEYuzdH7cOrWd
	L/9sYyzPW/2rbIkyDiXu7nNStzCWzjpUnTNVXL1qF0/CqZn/e6c+5eS/d1Njpsek40osxRmJ
	hlrMRcWJAFRrKinyAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new cpufreq governor named 'LAB'.
LAB governor will use historical cpuidle state usage infomation to
determine how many cpus are in busy now. The results, the number of
idle cpus, will affect to next frequency dynamically.

For instance, we can assume that it is working on quard core processor.
When all 4 cores are busy then this governor throttles next frequency
in maximum. For 3 cores, throttling will be loosen. The less core are
busy, the more high frequency will be set. So, when only one core is in
busy, then it releases maximum frequency that system allows.

The name of 'Legacy Application Boost' came from the such above aspect
which system has the highest performance for single threaded process.

This is tested on Pegasus Quad board.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/Kconfig            |   26 ++
 drivers/cpufreq/Makefile           |    1 +
 drivers/cpufreq/cpufreq_governor.h |   14 +
 drivers/cpufreq/cpufreq_lab.c      |  553 ++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h            |    3 +
 5 files changed, 597 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index cbcb21e..d0b22de 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -102,6 +102,18 @@ config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
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
@@ -184,6 +196,20 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
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
index 863fd18..2520fa7 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
 obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOV_LAB)		+= cpufreq_lab.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 # CPUfreq cross-arch helpers
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 46bde01..3062d60 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -103,6 +103,19 @@ struct cs_cpu_dbs_info_s {
 	unsigned int enable:1;
 };
 
+struct lb_cpu_dbs_info_s {
+	struct cpu_dbs_common_info cdbs;
+	u64 prev_cpu_iowait;
+	struct cpufreq_frequency_table *freq_table;
+	unsigned int freq_lo;
+	unsigned int freq_lo_jiffies;
+	unsigned int freq_hi_jiffies;
+	unsigned int rate_mult;
+	unsigned int sample_type:1;
+
+	unsigned int last_sampling_rate;
+};
+
 /* Governers sysfs tunables */
 struct od_dbs_tuners {
 	unsigned int ignore_nice;
@@ -128,6 +141,7 @@ struct dbs_data {
 	/* Common across governors */
 	#define GOV_ONDEMAND		0
 	#define GOV_CONSERVATIVE	1
+	#define GOV_LAB			2
 	int governor;
 	unsigned int min_sampling_rate;
 	struct attribute_group *attr_group;
diff --git a/drivers/cpufreq/cpufreq_lab.c b/drivers/cpufreq/cpufreq_lab.c
new file mode 100644
index 0000000..7841a50
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_lab.c
@@ -0,0 +1,553 @@
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
+/* On-demand governor macros */
+#define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
+#define DEF_FREQUENCY_UP_THRESHOLD		(80)
+#define DEF_SAMPLING_DOWN_FACTOR		(1)
+#define MAX_SAMPLING_DOWN_FACTOR		(100000)
+#define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
+#define MICRO_FREQUENCY_UP_THRESHOLD		(95)
+#define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
+#define MIN_FREQUENCY_UP_THRESHOLD		(11)
+#define MAX_FREQUENCY_UP_THRESHOLD		(100)
+
+#define MAX_HIST		10
+#define FREQ_STEP		50000
+#define IDLE_THRESHOLD		90
+
+static unsigned int lab_limit_rate[5] = {35, 20, 10, 0, 0};
+static unsigned long *ref_time;
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
+static struct od_dbs_tuners lb_tuners = {
+	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
+	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
+	.adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
+			    DEF_FREQUENCY_DOWN_DIFFERENTIAL,
+	.ignore_nice = 0,
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
+static inline int cpu_idle_calc_avg(unsigned int *p, int size)
+{
+	int i, sum;
+
+	for (i = 0, sum = 0; i < size; p++, i++)
+		sum += *p;
+
+	return (int) (sum / size);
+}
+
+/*
+ * Every sampling_rate, we check, if current idle time is less than 20%
+ * (default), then we try to increase frequency. Every sampling_rate, we look
+ * for the lowest frequency which can sustain the load while keeping idle time
+ * over 30%. If such a frequency exist, we try to decrease to this frequency.
+ *
+ * Any frequency increase takes it to the maximum frequency. Frequency reduction
+ * happens at minimum steps of 5% (default) of current frequency
+ */
+static void lb_check_cpu(int cpu, unsigned int load_freq)
+{
+	struct lb_cpu_dbs_info_s *dbs_info = &per_cpu(lb_cpu_dbs_info, cpu);
+	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	struct cpuidle_device *dev;
+	int i, idx, idle_cpus;
+	static int cnt;
+	unsigned int _max;
+
+	dbs_info->freq_lo = 0;
+
+	idle_cpus = 0;
+
+	idx = cnt++ % MAX_HIST;
+	/* Check for LAB limitation */
+	for_each_possible_cpu(i) {
+		ktime_t cur;
+		ktime_t last_idle_enter;
+		ktime_t last_idle_exit;
+		s64 delta_time;
+		unsigned int last_sampling_rate = dbs_info->last_sampling_rate;
+
+		dev = per_cpu(cpuidle_devices, i);
+		last_idle_enter = dev->last_idle_start;
+		last_idle_exit = dev->last_idle_end;
+
+		cur = ktime_get();
+
+		/* Check whether the i'th core is in idle */
+		if (ktime_to_us(ktime_sub(last_idle_enter,
+						last_idle_exit)) > 0) {
+			if (ktime_to_us(ktime_sub(cur, last_idle_enter))
+						> last_sampling_rate) {
+				delta_time = last_sampling_rate;
+			} else {
+				delta_time = ktime_to_us(ktime_sub(cur,
+							last_idle_enter));
+				if (ktime_to_us(ktime_sub(cur, last_idle_exit))
+						< last_sampling_rate)
+					delta_time += dev->states_usage[0].time
+							- ref_time[i];
+			}
+		} else {
+			delta_time = dev->states_usage[0].time - ref_time[i];
+		}
+
+		delta_time *= 100;
+		if (last_sampling_rate > 0)
+			delta_time = div_s64(delta_time, last_sampling_rate);
+		else
+			delta_time = 100;
+
+		if (delta_time > 100)
+			delta_time = 100;
+
+		idle_hist[i][idx] = delta_time;
+
+		ref_time[i] = dev->states_usage[0].time;
+
+		idle_avg[i] = cpu_idle_calc_avg(idle_hist[i],
+					cnt < 10 ? cnt : MAX_HIST);
+		if (idle_avg[i] > IDLE_THRESHOLD)
+			idle_cpus++;
+	}
+
+	_max = policy->max * (100 - lab_limit_rate[idle_cpus]);
+	_max /= 100;
+
+	if (!idx)
+		pr_debug("_max : %d, idle_cpus : %d, avg : %d %d %d %d\n", _max,
+		idle_cpus, idle_avg[0], idle_avg[1], idle_avg[2], idle_avg[3]);
+
+	/* Check for frequency increase */
+	if (load_freq > lb_tuners.up_threshold * policy->cur) {
+		unsigned int freq_next;
+		static unsigned int inc;
+
+		if (!idle_cpus)
+			inc += FREQ_STEP / 2;
+		else
+			inc += FREQ_STEP * idle_cpus;
+
+		freq_next = min(policy->cur + inc, _max);
+		if (freq_next == _max)
+			inc = 0;
+		/* If switching to max speed, apply sampling_down_factor */
+		if (policy->cur < _max)
+			dbs_info->rate_mult =
+				lb_tuners.sampling_down_factor;
+
+		dbs_freq_increase(policy, freq_next);
+		return;
+	}
+
+	/* Check for frequency decrease */
+	/* if we cannot reduce the frequency anymore, break out early */
+	if (policy->cur == policy->min)
+		return;
+
+	/*
+	 * The optimal frequency is the frequency that is the lowest that can
+	 * support the current CPU usage without triggering the up policy. To be
+	 * safe, we focus 10 points under the threshold.
+	 */
+	if (load_freq < lb_tuners.adj_up_threshold * policy->cur) {
+		unsigned int freq_next;
+		freq_next = load_freq / lb_tuners.adj_up_threshold;
+
+		/* No longer fully busy, reset rate_mult */
+		dbs_info->rate_mult = 1;
+
+		if (freq_next < policy->min)
+			freq_next = policy->min;
+
+		__cpufreq_driver_target(policy, freq_next,
+					CPUFREQ_RELATION_L);
+	}
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
+	bool eval_load;
+
+	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
+	eval_load = need_load_eval(&core_dbs_info->cdbs,
+			lb_tuners.sampling_rate);
+
+	/* Common NORMAL_SAMPLE setup */
+	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
+	if (sample_type == OD_SUB_SAMPLE) {
+		delay = core_dbs_info->freq_lo_jiffies;
+		if (eval_load)
+			__cpufreq_driver_target(core_dbs_info->cdbs.cur_policy,
+						core_dbs_info->freq_lo,
+						CPUFREQ_RELATION_H);
+	} else {
+		if (eval_load)
+			dbs_check_cpu(&lb_dbs_data, cpu);
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
+static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	lb_tuners.io_is_busy = !!input;
+	return count;
+}
+
+static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
+				  const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
+			input < MIN_FREQUENCY_UP_THRESHOLD) {
+		return -EINVAL;
+	}
+	/* Calculate the new adj_up_threshold */
+	lb_tuners.adj_up_threshold += input;
+	lb_tuners.adj_up_threshold -= lb_tuners.up_threshold;
+
+	lb_tuners.up_threshold = input;
+	return count;
+}
+
+static ssize_t store_sampling_down_factor(struct kobject *a,
+			struct attribute *b, const char *buf, size_t count)
+{
+	unsigned int input, j;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
+		return -EINVAL;
+	lb_tuners.sampling_down_factor = input;
+
+	/* Reset down sampling multiplier in case it was active */
+	for_each_online_cpu(j) {
+		struct lb_cpu_dbs_info_s *dbs_info = &per_cpu(lb_cpu_dbs_info,
+				j);
+		dbs_info->rate_mult = 1;
+	}
+	return count;
+}
+
+static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
+				      const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	unsigned int j;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (input > 1)
+		input = 1;
+
+	if (input == lb_tuners.ignore_nice) { /* nothing to do */
+		return count;
+	}
+	lb_tuners.ignore_nice = input;
+
+	/* we need to re-evaluate prev_cpu_idle */
+	for_each_online_cpu(j) {
+		struct lb_cpu_dbs_info_s *dbs_info;
+		dbs_info = &per_cpu(lb_cpu_dbs_info, j);
+		dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
+						&dbs_info->cdbs.prev_cpu_wall);
+		if (lb_tuners.ignore_nice)
+			dbs_info->cdbs.prev_cpu_nice =
+				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+
+	}
+	return count;
+}
+
+show_one(lb, sampling_rate, sampling_rate);
+show_one(lb, io_is_busy, io_is_busy);
+show_one(lb, up_threshold, up_threshold);
+show_one(lb, sampling_down_factor, sampling_down_factor);
+show_one(lb, ignore_nice_load, ignore_nice);
+
+define_one_global_rw(sampling_rate);
+define_one_global_rw(io_is_busy);
+define_one_global_rw(up_threshold);
+define_one_global_rw(sampling_down_factor);
+define_one_global_rw(ignore_nice_load);
+define_one_global_ro(sampling_rate_min);
+
+static struct attribute *dbs_attributes[] = {
+	&sampling_rate_min.attr,
+	&sampling_rate.attr,
+	&up_threshold.attr,
+	&sampling_down_factor.attr,
+	&ignore_nice_load.attr,
+	&io_is_busy.attr,
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
+define_get_cpu_dbs_routines(lb_cpu_dbs_info);
+
+static struct od_ops lb_ops = {
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
+	int i, cpu = get_cpu();
+
+	mutex_init(&lb_dbs_data.mutex);
+	idle_time = get_cpu_idle_time_us(cpu, NULL);
+	put_cpu();
+	if (idle_time != -1ULL) {
+		/* Idle micro accounting is supported. Use finer thresholds */
+		lb_tuners.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
+		lb_tuners.adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
+					     MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
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
+	ref_time = kzalloc(GFP_KERNEL,
+			num_possible_cpus() * sizeof(unsigned long));
+	idle_avg = kzalloc(GFP_KERNEL,
+			num_possible_cpus() * sizeof(unsigned int));
+	idle_hist = kzalloc(GFP_KERNEL,
+			num_possible_cpus() * sizeof(unsigned int *));
+	for (i = 0; i < num_possible_cpus(); i++)
+		idle_hist[i] = kzalloc(GFP_KERNEL,
+					MAX_HIST * sizeof(unsigned int));
+
+	return cpufreq_register_governor(&cpufreq_gov_lab);
+}
+
+static void __exit cpufreq_gov_dbs_exit(void)
+{
+	int i;
+
+	if (!ref_time)
+		kfree(ref_time);
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
index a22944c..050f28b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -382,6 +382,9 @@ extern struct cpufreq_governor cpufreq_gov_ondemand;
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE)
 extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_conservative)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_LAB)
+extern struct cpufreq_governor cpufreq_gov_lab;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_lab)
 #endif
 
 
-- 
1.7.9.5

