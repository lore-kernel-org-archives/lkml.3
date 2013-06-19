Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab3FSIv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:51:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63181 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSIvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:51:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: Fix minor formatting issues
Date: Wed, 19 Jun 2013 14:19:33 +0530
Message-Id: <9625ea15bf036549ac323d7d4ae3b87ada007e7a.1371631432.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were few noticeable formatting issues present in core cpufreq code. This
patch tries to fix them to make code look better. These are:
- Removing few extra blank lines
- Adding few blank lines
- replacing spaces with tabs
- removing unnecessary spaces
- rearranging code a bit
- Fixing multiline comments
- Break lines longer than 80 columns into multi-line.

At the end it also updates copyright information in cpufreq.c to include my name
for 2013.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c             | 61 +++++++++++++++--------------------
 drivers/cpufreq/cpufreq_governor.h    |  4 +--
 drivers/cpufreq/cpufreq_performance.c |  4 ---
 drivers/cpufreq/cpufreq_powersave.c   |  6 ++--
 drivers/cpufreq/cpufreq_stats.c       |  4 +--
 drivers/cpufreq/cpufreq_userspace.c   |  4 ---
 include/linux/cpufreq.h               | 41 ++++++++++++-----------
 7 files changed, 52 insertions(+), 72 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..7c38842 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2001 Russell King
  *            (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
+ *            (C) 2013 Viresh Kumar <viresh.kumar@linaro.org>
  *
  *  Oct 2005 - Ashok Raj <ashok.raj@intel.com>
  *	Added handling for CPU hotplug
@@ -12,7 +13,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -41,11 +41,12 @@
  */
 static struct cpufreq_driver *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
+static DEFINE_RWLOCK(cpufreq_driver_lock);
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
-static DEFINE_RWLOCK(cpufreq_driver_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -150,7 +151,6 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 	if (!try_module_get(cpufreq_driver->owner))
 		goto err_out_unlock;
 
-
 	/* get the CPU */
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
@@ -220,7 +220,7 @@ static void cpufreq_cpu_put_sysfs(struct cpufreq_policy *data)
  */
 #ifndef CONFIG_SMP
 static unsigned long l_p_j_ref;
-static unsigned int  l_p_j_ref_freq;
+static unsigned int l_p_j_ref_freq;
 
 static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 {
@@ -233,7 +233,7 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 		pr_debug("saving %lu as reference value for loops_per_jiffy; "
 			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
 	}
-	if ((val == CPUFREQ_POSTCHANGE  && ci->old != ci->new) ||
+	if ((val == CPUFREQ_POSTCHANGE && ci->old != ci->new) ||
 	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
 		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
 								ci->new);
@@ -248,7 +248,6 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 }
 #endif
 
-
 void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
@@ -294,6 +293,7 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		break;
 	}
 }
+
 /**
  * cpufreq_notify_transition - call notifier chain and adjust_jiffies
  * on frequency transition.
@@ -311,7 +311,6 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 
 
-
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
@@ -376,7 +375,6 @@ out:
 	return err;
 }
 
-
 /**
  * cpufreq_per_cpu_attr_read() / show_##file_name() -
  * print out cpufreq information
@@ -441,7 +439,6 @@ static ssize_t show_cpuinfo_cur_freq(struct cpufreq_policy *policy,
 	return sprintf(buf, "%u\n", cur_freq);
 }
 
-
 /**
  * show_scaling_governor - show the current policy for the specified CPU
  */
@@ -457,7 +454,6 @@ static ssize_t show_scaling_governor(struct cpufreq_policy *policy, char *buf)
 	return -EINVAL;
 }
 
-
 /**
  * store_scaling_governor - store policy for the specified CPU
  */
@@ -480,8 +476,10 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
 						&new_policy.governor))
 		return -EINVAL;
 
-	/* Do not use cpufreq_set_policy here or the user_policy.max
-	   will be wrongly overridden */
+	/*
+	 * Do not use cpufreq_set_policy here or the user_policy.max
+	 * will be wrongly overridden
+	 */
 	ret = __cpufreq_set_policy(policy, &new_policy);
 
 	policy->user_policy.policy = policy->policy;
@@ -1005,7 +1003,8 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
  * Caller should already have policy_rwsem in write mode for this CPU.
  * This routine frees the rwsem before returning.
  */
-static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
+static int __cpufreq_remove_dev(struct device *dev,
+		struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id, ret, cpus;
 	unsigned long flags;
@@ -1112,7 +1111,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	return 0;
 }
 
-
 static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id;
@@ -1125,7 +1123,6 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	return retval;
 }
 
-
 static void handle_update(struct work_struct *work)
 {
 	struct cpufreq_policy *policy =
@@ -1136,7 +1133,8 @@ static void handle_update(struct work_struct *work)
 }
 
 /**
- *	cpufreq_out_of_sync - If actual and saved CPU frequency differs, we're in deep trouble.
+ *	cpufreq_out_of_sync - If actual and saved CPU frequency differs, we're
+ *	in deep trouble.
  *	@cpu: cpu number
  *	@old_freq: CPU frequency the kernel thinks the CPU runs at
  *	@new_freq: CPU frequency the CPU actually runs at
@@ -1151,7 +1149,6 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	struct cpufreq_freqs freqs;
 	unsigned long flags;
 
-
 	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing "
 	       "core thinks of %u, is %u kHz.\n", old_freq, new_freq);
 
@@ -1166,7 +1163,6 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 }
 
-
 /**
  * cpufreq_quick_get - get the CPU frequency (in kHz) from policy->cur
  * @cpu: CPU number
@@ -1212,7 +1208,6 @@ unsigned int cpufreq_quick_get_max(unsigned int cpu)
 }
 EXPORT_SYMBOL(cpufreq_quick_get_max);
 
-
 static unsigned int __cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
@@ -1271,7 +1266,6 @@ static struct subsys_interface cpufreq_interface = {
 	.remove_dev	= cpufreq_remove_dev,
 };
 
-
 /**
  * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
  *
@@ -1408,11 +1402,10 @@ int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list)
 }
 EXPORT_SYMBOL(cpufreq_register_notifier);
 
-
 /**
  *	cpufreq_unregister_notifier - unregister a driver with cpufreq
  *	@nb: notifier block to be unregistered
- *      @list: CPUFREQ_TRANSITION_NOTIFIER or CPUFREQ_POLICY_NOTIFIER
+ *	@list: CPUFREQ_TRANSITION_NOTIFIER or CPUFREQ_POLICY_NOTIFIER
  *
  *	Remove a driver from the CPU frequency notifier list.
  *
@@ -1448,7 +1441,6 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
  *                              GOVERNORS                            *
  *********************************************************************/
 
-
 int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -1581,7 +1573,6 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	return ret;
 }
 
-
 int cpufreq_register_governor(struct cpufreq_governor *governor)
 {
 	int err;
@@ -1606,7 +1597,6 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_governor);
 
-
 void cpufreq_unregister_governor(struct cpufreq_governor *governor)
 {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1636,7 +1626,6 @@ void cpufreq_unregister_governor(struct cpufreq_governor *governor)
 EXPORT_SYMBOL_GPL(cpufreq_unregister_governor);
 
 
-
 /*********************************************************************
  *                          POLICY INTERFACE                         *
  *********************************************************************/
@@ -1665,7 +1654,6 @@ int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu)
 }
 EXPORT_SYMBOL(cpufreq_get_policy);
 
-
 /*
  * data   : current policy.
  * policy : policy to be set.
@@ -1699,8 +1687,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 			CPUFREQ_INCOMPATIBLE, policy);
 
-	/* verify the cpu speed can be set within this limit,
-	   which might be different to the first one */
+	/*
+	 * verify the cpu speed can be set within this limit, which might be
+	 * different to the first one
+	 */
 	ret = cpufreq_driver->verify(policy);
 	if (ret)
 		goto error_out;
@@ -1802,8 +1792,10 @@ int cpufreq_update_policy(unsigned int cpu)
 	policy.policy = data->user_policy.policy;
 	policy.governor = data->user_policy.governor;
 
-	/* BIOS might change freq behind our back
-	  -> ask driver for current freq and notify governors about a change */
+	/*
+	 * BIOS might change freq behind our back
+	 * -> ask driver for current freq and notify governors about a change
+	 */
 	if (cpufreq_driver->get) {
 		policy.cur = cpufreq_driver->get(cpu);
 		if (!data->cur) {
@@ -1852,7 +1844,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 }
 
 static struct notifier_block __refdata cpufreq_cpu_notifier = {
-    .notifier_call = cpufreq_cpu_callback,
+	.notifier_call = cpufreq_cpu_callback,
 };
 
 /*********************************************************************
@@ -1864,7 +1856,7 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
  * @driver_data: A struct cpufreq_driver containing the values#
  * submitted by the CPU Frequency driver.
  *
- *   Registers a CPU Frequency driver to this core code. This code
+ * Registers a CPU Frequency driver to this core code. This code
  * returns zero on success, -EBUSY when another driver got here first
  * (and isn't unregistered in the meantime).
  *
@@ -1931,11 +1923,10 @@ err_null_driver:
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
 
-
 /**
  * cpufreq_unregister_driver - unregister the current CPUFreq driver
  *
- *    Unregister the current CPUFreq driver. Only call this if you have
+ * Unregister the current CPUFreq driver. Only call this if you have
  * the right to do so, i.e. if you have succeeded in initialising before!
  * Returns zero if successful, and -EINVAL if the cpufreq_driver is
  * currently not initialised.
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..72e7994 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -81,7 +81,7 @@ static ssize_t show_##file_name##_gov_sys				\
 	return sprintf(buf, "%u\n", tuners->file_name);			\
 }									\
 									\
-static ssize_t show_##file_name##_gov_pol					\
+static ssize_t show_##file_name##_gov_pol				\
 (struct cpufreq_policy *policy, char *buf)				\
 {									\
 	struct dbs_data *dbs_data = policy->governor_data;		\
@@ -91,7 +91,7 @@ static ssize_t show_##file_name##_gov_pol					\
 
 #define store_one(_gov, file_name)					\
 static ssize_t store_##file_name##_gov_sys				\
-(struct kobject *kobj, struct attribute *attr, const char *buf, size_t count)	\
+(struct kobject *kobj, struct attribute *attr, const char *buf, size_t count) \
 {									\
 	struct dbs_data *dbs_data = _gov##_dbs_cdata.gdbs_data;		\
 	return store_##file_name(dbs_data, buf, count);			\
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index ceee068..9fef7d6 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -17,7 +17,6 @@
 #include <linux/cpufreq.h>
 #include <linux/init.h>
 
-
 static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 					unsigned int event)
 {
@@ -44,19 +43,16 @@ struct cpufreq_governor cpufreq_gov_performance = {
 	.owner		= THIS_MODULE,
 };
 
-
 static int __init cpufreq_gov_performance_init(void)
 {
 	return cpufreq_register_governor(&cpufreq_gov_performance);
 }
 
-
 static void __exit cpufreq_gov_performance_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_performance);
 }
 
-
 MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>");
 MODULE_DESCRIPTION("CPUfreq policy governor 'performance'");
 MODULE_LICENSE("GPL");
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 2d948a1..32109a1 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -1,7 +1,7 @@
 /*
- *  linux/drivers/cpufreq/cpufreq_powersave.c
+ * linux/drivers/cpufreq/cpufreq_powersave.c
  *
- *  Copyright (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
+ * Copyright (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -48,13 +48,11 @@ static int __init cpufreq_gov_powersave_init(void)
 	return cpufreq_register_governor(&cpufreq_gov_powersave);
 }
 
-
 static void __exit cpufreq_gov_powersave_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_powersave);
 }
 
-
 MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>");
 MODULE_DESCRIPTION("CPUfreq policy governor 'powersave'");
 MODULE_LICENSE("GPL");
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..6d35caa 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -27,7 +27,7 @@ static spinlock_t cpufreq_stats_lock;
 struct cpufreq_stats {
 	unsigned int cpu;
 	unsigned int total_trans;
-	unsigned long long  last_time;
+	unsigned long long last_time;
 	unsigned int max_state;
 	unsigned int state_num;
 	unsigned int last_index;
@@ -116,7 +116,7 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 		len += snprintf(buf + len, PAGE_SIZE - len, "%9u: ",
 				stat->freq_table[i]);
 
-		for (j = 0; j < stat->state_num; j++)   {
+		for (j = 0; j < stat->state_num; j++) {
 			if (len >= PAGE_SIZE)
 				break;
 			len += snprintf(buf + len, PAGE_SIZE - len, "%9u ",
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index bbeb9c0..c4f2dc3 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -104,7 +104,6 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
 	return ret;
 }
 
-
 static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
 {
 	return sprintf(buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
@@ -185,7 +184,6 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 	return rc;
 }
 
-
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
 static
 #endif
@@ -202,13 +200,11 @@ static int __init cpufreq_gov_userspace_init(void)
 	return cpufreq_register_governor(&cpufreq_gov_userspace);
 }
 
-
 static void __exit cpufreq_gov_userspace_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_userspace);
 }
 
-
 MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>, "
 		"Russell King <rmk@arm.linux.org.uk>");
 MODULE_DESCRIPTION("CPUfreq policy governor 'userspace'");
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..dc204c3 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1,8 +1,8 @@
 /*
- *  linux/include/linux/cpufreq.h
+ * linux/include/linux/cpufreq.h
  *
- *  Copyright (C) 2001 Russell King
- *            (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
+ * Copyright (C) 2001 Russell King
+ *           (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -26,7 +26,6 @@
 /* Print length for names. Extra 1 space for accomodating '\n' in prints */
 #define CPUFREQ_NAME_PLEN (CPUFREQ_NAME_LEN + 1)
 
-
 /*********************************************************************
  *                     CPUFREQ NOTIFIER INTERFACE                    *
  *********************************************************************/
@@ -148,17 +147,18 @@ struct cpufreq_freqs {
 	u8 flags;		/* flags of cpufreq_driver, see below. */
 };
 
-
 /**
- * cpufreq_scale - "old * mult / div" calculation for large values (32-bit-arch safe)
+ * cpufreq_scale - "old * mult / div" calculation for large values (32-bit-arch
+ * safe)
  * @old:   old value
  * @div:   divisor
  * @mult:  multiplier
  *
  *
- *    new = old * mult / div
+ * new = old * mult / div
  */
-static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mult)
+static inline unsigned long cpufreq_scale(unsigned long old, u_int div,
+		u_int mult)
 {
 #if BITS_PER_LONG == 32
 
@@ -211,14 +211,12 @@ extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation);
 
-
 extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
 				   unsigned int cpu);
 
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
-
 /*********************************************************************
  *                      CPUFREQ DRIVER INTERFACE                     *
  *********************************************************************/
@@ -229,7 +227,7 @@ void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 struct freq_attr;
 
 struct cpufreq_driver {
-	struct module           *owner;
+	struct module		*owner;
 	char			name[CPUFREQ_NAME_LEN];
 	u8			flags;
 	/*
@@ -277,11 +275,11 @@ struct cpufreq_driver {
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state);
 
-static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy, unsigned int min, unsigned int max)
+static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
+		unsigned int min, unsigned int max)
 {
 	if (policy->min < min)
 		policy->min = min;
@@ -342,7 +340,9 @@ int cpufreq_update_policy(unsigned int cpu);
 bool have_governor_per_policy(void);
 
 #ifdef CONFIG_CPU_FREQ
-/* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
+/*
+ * query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it
+ */
 unsigned int cpufreq_get(unsigned int cpu);
 #else
 static inline unsigned int cpufreq_get(unsigned int cpu)
@@ -351,7 +351,9 @@ static inline unsigned int cpufreq_get(unsigned int cpu)
 }
 #endif
 
-/* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
+/*
+ * query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it
+ */
 #ifdef CONFIG_CPU_FREQ
 unsigned int cpufreq_quick_get(unsigned int cpu);
 unsigned int cpufreq_quick_get_max(unsigned int cpu);
@@ -366,16 +368,14 @@ static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
 }
 #endif
 
-
 /*********************************************************************
  *                       CPUFREQ DEFAULT GOVERNOR                    *
  *********************************************************************/
 
-
 /*
-  Performance governor is fallback governor if any other gov failed to
-  auto load due latency restrictions
-*/
+ * Performance governor is fallback governor if any other gov failed to auto
+ * load due latency restrictions
+ */
 #ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE
 extern struct cpufreq_governor cpufreq_gov_performance;
 #endif
@@ -395,7 +395,6 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_conservative)
 #endif
 
-
 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
-- 
1.7.12.rc2.18.g61b472e

