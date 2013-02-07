Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3BGOBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:01:10 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63330 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3BGOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-7-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<1360170133-5066-7-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 19:31:06 +0530
X-Google-Sender-Auth: Iz9bSUUD4bNk136vPt00VY20yJ0
Message-ID: <CAOh2x==pLMOVP2X3cA=qA0Xv=ToFqQbeuDZbdKChQ6ymOfe+BA@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq/x86: Add P-state driver for sandy bridge.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:32 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Add a P-state driver for the Intel Sandy bridge processor. In cpufreq
> terminology this driver implements a  scaling driver with an internal
> governor.
>
> When built into the the kernel this driver will be the preferred
> scaling driver for Sandy bridge processors.

I have got some sparse warning fixes + generic cleanup (formatting related).

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Thu, 7 Feb 2013 19:27:50 +0530
Subject: [PATCH] fixup! cpufreq/x86: Add P-state driver for sandy bridge.

---
 drivers/cpufreq/intel_pstate.c | 65 ++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 21cee6a..6c225d7 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -99,7 +99,7 @@ struct cpudata {
 	struct sample samples[SAMPLE_COUNT];
 };

-struct cpudata **all_cpu_data;
+static struct cpudata **all_cpu_data;
 struct pstate_adjust_policy {
 	int sample_rate_ms;
 	int deadband;
@@ -158,13 +158,12 @@ static inline void pid_d_gain_set(struct _pid
*pid, int percent)
 	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
 }

-static  signed int pid_calc(struct _pid *pid, int busy)
+static signed int pid_calc(struct _pid *pid, int busy)
 {
 	signed int err, result;
 	int32_t pterm, dterm, fp_error;
 	int32_t integral_limit;

-
 	err = pid->setpoint - busy;
 	fp_error = int_tofp(err);

@@ -190,7 +189,6 @@ static  signed int pid_calc(struct _pid *pid, int busy)
 	return (signed int)fp_toint(result);
 }

-
 static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
 {
 	pid_p_gain_set(&cpu->pid, cpu->pstate_policy->p_gain_pct);
@@ -202,7 +200,6 @@ static inline void
intel_pstate_busy_pid_reset(struct cpudata *cpu)
 		100,
 		cpu->pstate_policy->deadband,
 		0);
-
 }

 static inline void intel_pstate_idle_pid_reset(struct cpudata *cpu)
@@ -257,8 +254,8 @@ static struct pid_param pid_files[] = {
 	{NULL, NULL}
 };

-struct dentry *debugfs_parent;
-void intel_pstate_debug_expose_params(void)
+static struct dentry *debugfs_parent;
+static void intel_pstate_debug_expose_params(void)
 {
 	int i = 0;

@@ -271,7 +268,6 @@ void intel_pstate_debug_expose_params(void)
 				&fops_pid_param);
 		i++;
 	}
-
 }

 /************************** debugfs end ************************/
@@ -281,7 +277,7 @@ void intel_pstate_debug_expose_params(void)
 	static ssize_t show_##file_name					\
 	(struct kobject *kobj, struct attribute *attr, char *buf)	\
 	{								\
-		return sprintf(buf, "%u\n", limits.object);	\
+		return sprintf(buf, "%u\n", limits.object);		\
 	}

 static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
@@ -292,7 +288,7 @@ static ssize_t store_no_turbo(struct kobject *a,
struct attribute *b,
 	ret = sscanf(buf, "%u", &input);
 	if (ret != 1)
 		return -EINVAL;
-	limits.no_turbo =  clamp_t(int, input, 0 , 1);
+	limits.no_turbo = clamp_t(int, input, 0 , 1);

 	return count;
 }
@@ -329,12 +325,10 @@ show_one(no_turbo, no_turbo);
 show_one(max_perf_pct, max_perf_pct);
 show_one(min_perf_pct, min_perf_pct);

-
 define_one_global_rw(no_turbo);
 define_one_global_rw(max_perf_pct);
 define_one_global_rw(min_perf_pct);

-
 static struct attribute *intel_pstate_attributes[] = {
 	&no_turbo.attr,
 	&max_perf_pct.attr,
@@ -347,7 +341,7 @@ static struct attribute_group intel_pstate_attr_group = {
 };
 static struct kobject *intel_pstate_kobject;

-void intel_pstate_sysfs_expose_params(void)
+static void intel_pstate_sysfs_expose_params(void)
 {
 	int rc;

@@ -359,7 +353,6 @@ void intel_pstate_sysfs_expose_params(void)
 	BUG_ON(rc);
 }

-
 /************************** sysfs end ************************/

 static int intel_pstate_min_pstate(void)
@@ -404,7 +397,6 @@ static void intel_pstate_get_min_max(struct
cpudata *cpu, int *min, int *max)
 			cpu->pstate.min_pstate, max_perf);
 }

-
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
 	int max_perf, min_perf;
@@ -416,7 +408,6 @@ static void intel_pstate_set_pstate(struct cpudata
*cpu, int pstate)
 	if (pstate == cpu->pstate.current_pstate)
 		return;

-
 #ifndef MODULE
 	trace_cpu_frequency(pstate * 100000, cpu->cpu);
 #endif
@@ -448,14 +439,13 @@ static void intel_pstate_get_cpu_pstates(struct
cpudata *cpu)
 	cpu->pstate.max_pstate = intel_pstate_max_pstate();
 	cpu->pstate.turbo_pstate = intel_pstate_turbo_pstate();

-	/* goto max pstate so we don't slow up boot if we are built-in
-	   if we are a module we will take care of it during normal
-	   operation
-	*/
+	/*
+	 * goto max pstate so we don't slow up boot if we are built-in if we are
+	 * a module we will take care of it during normal operation
+	 */
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 }

-
 static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
@@ -508,8 +498,7 @@ static inline int intel_pstate_sample(struct cpudata *cpu)

 static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 {
-	int sample_time;
-	int delay;
+	int sample_time, delay;

 	sample_time = cpu->pstate_policy->sample_rate_ms;
 	delay = msecs_to_jiffies(sample_time);
@@ -532,12 +521,11 @@ static inline int
intel_pstate_get_scaled_busy(struct cpudata *cpu)
 	int32_t busy_scaled;
 	int32_t core_busy, turbo_pstate, current_pstate;

-	core_busy    = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
-	turbo_pstate   = int_tofp(cpu->pstate.turbo_pstate);
+	core_busy = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
+	turbo_pstate = int_tofp(cpu->pstate.turbo_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
 	busy_scaled = mul_fp(core_busy, div_fp(turbo_pstate, current_pstate));

-
 	return fp_toint(busy_scaled);
 }

@@ -549,7 +537,7 @@ static inline void
intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 	int steps;

 	pid = &cpu->pid;
-	busy_scaled =  intel_pstate_get_scaled_busy(cpu);
+	busy_scaled = intel_pstate_get_scaled_busy(cpu);

 	ctl = pid_calc(pid, busy_scaled);

@@ -569,7 +557,7 @@ static inline void
intel_pstate_adjust_idle_pstate(struct cpudata *cpu)

 	pid = &cpu->idle_pid;

-	busy_scaled =  intel_pstate_get_scaled_busy(cpu);
+	busy_scaled = intel_pstate_get_scaled_busy(cpu);

 	ctl = pid_calc(pid, 100 - busy_scaled);

@@ -586,11 +574,7 @@ static inline void
intel_pstate_adjust_idle_pstate(struct cpudata *cpu)
 static void intel_pstate_timer_func(unsigned long __data)
 {
 	struct cpudata *cpu = (struct cpudata *) __data;
-	int idx;
-
-
-	idx = intel_pstate_sample(cpu);
-
+	int idx = intel_pstate_sample(cpu);

 	if (!cpu->idle_mode)
 		intel_pstate_adjust_busy_pstate(cpu);
@@ -653,12 +637,12 @@ static int intel_pstate_init_cpu(unsigned int cpunum)

 	add_timer_on(&cpu->timer, cpunum);

-	pr_info("Intel pstate controlling:  cpu %d\n", cpunum);
+	pr_info("Intel pstate controlling: cpu %d\n", cpunum);

 	return 0;
 }

-unsigned int intel_pstate_get(unsigned int cpu_num)
+static unsigned int intel_pstate_get(unsigned int cpu_num)
 {
 	struct sample *sample;
 	struct cpudata *cpu;
@@ -683,13 +667,10 @@ static int intel_pstate_set_policy(struct
cpufreq_policy *policy)
 	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
 	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));

-
 	limits.max_perf_pct = policy->max * 100 / policy->cpuinfo.max_freq;
 	limits.max_perf_pct = clamp_t(int, limits.max_perf_pct, 0 , 100);
 	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));

-
-
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		limits.min_perf_pct = 100;
 		limits.min_perf = int_tofp(1);
@@ -765,12 +746,10 @@ static struct cpufreq_driver intel_pstate_driver = {
 	.owner		= THIS_MODULE,
 };

-
 static void intel_pstate_exit(void)
 {
 	int cpu;

-
 	sysfs_remove_group(intel_pstate_kobject,
 				&intel_pstate_attr_group);
 	debugfs_remove_recursive(debugfs_parent);
@@ -791,11 +770,11 @@ static void intel_pstate_exit(void)
 	put_online_cpus();
 	vfree(all_cpu_data);
 }
+module_exit(intel_pstate_exit);

 static int __init intel_pstate_init(void)
 {
 	int rc = 0;
-
 	const struct x86_cpu_id *id;

 	id = x86_match_cpu(intel_pstate_cpu_ids);
@@ -820,10 +799,8 @@ out:
 	intel_pstate_exit();
 	return -ENODEV;
 }
+device_initcall(intel_pstate_init);

 MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
 MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
 MODULE_LICENSE("GPL");
-
-device_initcall(intel_pstate_init);
-module_exit(intel_pstate_exit);
