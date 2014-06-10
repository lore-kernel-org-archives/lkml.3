Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaFJPMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:12:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49445 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFJPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:12:51 -0400
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <53972070.3020608@intel.com>
Date: Tue, 10 Jun 2014 08:12:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.j.brandewie@intel.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
References: <5396208F.6070400@semaphore.gr>
In-Reply-To: <5396208F.6070400@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 02:01 PM, Stratos Karafotis wrote:
> Remove unnecessary blank lines.
> Remove unnecessary parentheses.
> Remove unnecessary braces.
> Put the code in one line where possible.
> Add blank lines after variable declarations.
> Alignment to open parenthesis.
>

I don't have an issue with this patch in general but I would rather
the cleanup be done when there is a functional change in the given
hunk of code otherwise you are setting up a fence for stable/backporters
of functional changes in the future.


> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>   drivers/cpufreq/intel_pstate.c | 96 ++++++++++++++++++++----------------------
>   1 file changed, 45 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index d4f0518..fa44f0f 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -142,7 +142,7 @@ static struct perf_limits limits = {
>   };
>
>   static inline void pid_reset(struct _pid *pid, int setpoint, int busy,
> -			int deadband, int integral) {
> +			     int deadband, int integral) {
>   	pid->setpoint = setpoint;
>   	pid->deadband  = deadband;
>   	pid->integral  = int_tofp(integral);
> @@ -161,7 +161,6 @@ static inline void pid_i_gain_set(struct _pid *pid, int percent)
>
>   static inline void pid_d_gain_set(struct _pid *pid, int percent)
>   {
> -
>   	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
>   }
>
> @@ -192,9 +191,9 @@ static signed int pid_calc(struct _pid *pid, int32_t busy)
>
>   	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
>   	if (result >= 0)
> -		result = result + (1 << (FRAC_BITS-1));
> +		result += 1 << (FRAC_BITS-1);
>   	else
> -		result = result - (1 << (FRAC_BITS-1));
> +		result -= 1 << (FRAC_BITS-1);
>   	return (signed int)fp_toint(result);
>   }
>
> @@ -204,20 +203,16 @@ static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
>   	pid_d_gain_set(&cpu->pid, pid_params.d_gain_pct);
>   	pid_i_gain_set(&cpu->pid, pid_params.i_gain_pct);
>
> -	pid_reset(&cpu->pid,
> -		pid_params.setpoint,
> -		100,
> -		pid_params.deadband,
> -		0);
> +	pid_reset(&cpu->pid, pid_params.setpoint, 100, pid_params.deadband, 0);
>   }
>
>   static inline void intel_pstate_reset_all_pid(void)
>   {
>   	unsigned int cpu;
> -	for_each_online_cpu(cpu) {
> +
> +	for_each_online_cpu(cpu)
>   		if (all_cpu_data[cpu])
>   			intel_pstate_busy_pid_reset(all_cpu_data[cpu]);
> -	}
>   }
>
>   /************************** debugfs begin ************************/
> @@ -227,13 +222,13 @@ static int pid_param_set(void *data, u64 val)
>   	intel_pstate_reset_all_pid();
>   	return 0;
>   }
> +
>   static int pid_param_get(void *data, u64 *val)
>   {
>   	*val = *(u32 *)data;
>   	return 0;
>   }
> -DEFINE_SIMPLE_ATTRIBUTE(fops_pid_param, pid_param_get,
> -			pid_param_set, "%llu\n");
> +DEFINE_SIMPLE_ATTRIBUTE(fops_pid_param, pid_param_get, pid_param_set, "%llu\n");
>
>   struct pid_param {
>   	char *name;
> @@ -310,8 +305,8 @@ static void intel_pstate_debug_expose_params(void)
>   		return;
>   	while (pid_files[i].name) {
>   		debugfs_create_file(pid_files[i].name, 0660,
> -				debugfs_parent, pid_files[i].value,
> -				&fops_pid_param);
> +				    debugfs_parent, pid_files[i].value,
> +				    &fops_pid_param);
>   		i++;
>   	}
>   	debugfs_create_file("stats", S_IRUSR | S_IRGRP, debugfs_parent, NULL,
> @@ -329,10 +324,11 @@ static void intel_pstate_debug_expose_params(void)
>   	}
>
>   static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +			      const char *buf, size_t count)
>   {
>   	unsigned int input;
>   	int ret;
> +
>   	ret = sscanf(buf, "%u", &input);
>   	if (ret != 1)
>   		return -EINVAL;
> @@ -342,10 +338,11 @@ static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
>   }
>
>   static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +				  const char *buf, size_t count)
>   {
>   	unsigned int input;
>   	int ret;
> +
>   	ret = sscanf(buf, "%u", &input);
>   	if (ret != 1)
>   		return -EINVAL;
> @@ -353,14 +350,16 @@ static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
>   	limits.max_sysfs_pct = clamp_t(int, input, 0 , 100);
>   	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
>   	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
> +
>   	return count;
>   }
>
>   static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +				  const char *buf, size_t count)
>   {
>   	unsigned int input;
>   	int ret;
> +
>   	ret = sscanf(buf, "%u", &input);
>   	if (ret != 1)
>   		return -EINVAL;
> @@ -397,8 +396,7 @@ static void intel_pstate_sysfs_expose_params(void)
>   	intel_pstate_kobject = kobject_create_and_add("intel_pstate",
>   						&cpu_subsys.dev_root->kobj);
>   	BUG_ON(!intel_pstate_kobject);
> -	rc = sysfs_create_group(intel_pstate_kobject,
> -				&intel_pstate_attr_group);
> +	rc = sysfs_create_group(intel_pstate_kobject, &intel_pstate_attr_group);
>   	BUG_ON(rc);
>   }
>
> @@ -453,7 +451,6 @@ static void byt_get_vid(struct cpudata *cpudata)
>   {
>   	u64 value;
>
> -
>   	rdmsrl(BYT_VIDS, value);
>   	cpudata->vid.min = int_tofp((value >> 8) & 0x3f);
>   	cpudata->vid.max = int_tofp((value >> 16) & 0x3f);
> @@ -466,7 +463,6 @@ static void byt_get_vid(struct cpudata *cpudata)
>   	cpudata->vid.turbo = value & 0x7f;
>   }
>
> -
>   static int core_get_min_pstate(void)
>   {
>   	u64 value;
> @@ -485,9 +481,10 @@ static int core_get_turbo_pstate(void)
>   {
>   	u64 value;
>   	int nont, ret;
> +
>   	rdmsrl(MSR_NHM_TURBO_RATIO_LIMIT, value);
>   	nont = core_get_max_pstate();
> -	ret = ((value) & 255);
> +	ret = value & 255;
>   	if (ret <= nont)
>   		ret = nont;
>   	return ret;
> @@ -539,12 +536,12 @@ static struct cpu_defaults byt_params = {
>   	},
>   };
>
> -
>   static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
>   {
>   	int max_perf = cpu->pstate.turbo_pstate;
>   	int max_perf_adj;
>   	int min_perf;
> +
>   	if (limits.no_turbo)
>   		max_perf = cpu->pstate.max_pstate;
>
> @@ -553,8 +550,7 @@ static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
>   			cpu->pstate.min_pstate, cpu->pstate.turbo_pstate);
>
>   	min_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.min_perf));
> -	*min = clamp_t(int, min_perf,
> -			cpu->pstate.min_pstate, max_perf);
> +	*min = clamp_t(int, min_perf, cpu->pstate.min_pstate, max_perf);
>   }
>
>   static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
> @@ -648,12 +644,12 @@ static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>   	current_pstate = int_tofp(cpu->pstate.current_pstate);
>   	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
>
> -	sample_time = (pid_params.sample_rate_ms  * USEC_PER_MSEC);
> +	sample_time = pid_params.sample_rate_ms * USEC_PER_MSEC;
>   	duration_us = (u32) ktime_us_delta(cpu->sample.time,
> -					cpu->last_sample_time);
> +					   cpu->last_sample_time);
>   	if (duration_us > sample_time * 3) {
>   		sample_ratio = div_fp(int_tofp(sample_time),
> -				int_tofp(duration_us));
> +				      int_tofp(duration_us));
>   		core_busy = mul_fp(core_busy, sample_ratio);
>   	}
>
> @@ -680,7 +676,7 @@ static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
>
>   static void intel_pstate_timer_func(unsigned long __data)
>   {
> -	struct cpudata *cpu = (struct cpudata *) __data;
> +	struct cpudata *cpu = (struct cpudata *)__data;
>   	struct sample *sample;
>
>   	intel_pstate_sample(cpu);
> @@ -690,11 +686,11 @@ static void intel_pstate_timer_func(unsigned long __data)
>   	intel_pstate_adjust_busy_pstate(cpu);
>
>   	trace_pstate_sample(fp_toint(sample->core_pct_busy),
> -			fp_toint(sample->busy_scaled),
> -			cpu->pstate.current_pstate,
> -			sample->mperf,
> -			sample->aperf,
> -			sample->freq);
> +			    fp_toint(sample->busy_scaled),
> +			    cpu->pstate.current_pstate,
> +			    sample->mperf,
> +			    sample->aperf,
> +			    sample->freq);
>
>   	intel_pstate_set_sample_time(cpu);
>   }
> @@ -748,15 +744,14 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
>
>   	init_timer_deferrable(&cpu->timer);
>   	cpu->timer.function = intel_pstate_timer_func;
> -	cpu->timer.data =
> -		(unsigned long)cpu;
> +	cpu->timer.data = (unsigned long)cpu;
>   	cpu->timer.expires = jiffies + HZ/100;
>   	intel_pstate_busy_pid_reset(cpu);
>   	intel_pstate_sample(cpu);
>
>   	add_timer_on(&cpu->timer, cpunum);
>
> -	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
> +	pr_info("Intel pstate controlling: CPU %d\n", cpunum);
>
>   	return 0;
>   }
> @@ -790,7 +785,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
>   		limits.no_turbo = 0;
>   		return 0;
>   	}
> -	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
> +	limits.min_perf_pct = policy->min * 100 / policy->cpuinfo.max_freq;
>   	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
>   	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
>
> @@ -806,8 +801,8 @@ static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
>   {
>   	cpufreq_verify_within_cpu_limits(policy);
>
> -	if ((policy->policy != CPUFREQ_POLICY_POWERSAVE) &&
> -		(policy->policy != CPUFREQ_POLICY_PERFORMANCE))
> +	if (policy->policy != CPUFREQ_POLICY_POWERSAVE &&
> +	    policy->policy != CPUFREQ_POLICY_PERFORMANCE)
>   		return -EINVAL;
>
>   	return 0;
> @@ -839,7 +834,7 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>   	cpu = all_cpu_data[policy->cpu];
>
>   	if (!limits.no_turbo &&
> -		limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
> +	    limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
>   		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
>   	else
>   		policy->policy = CPUFREQ_POLICY_POWERSAVE;
> @@ -877,8 +872,8 @@ static int intel_pstate_msrs_not_valid(void)
>   	rdmsrl(MSR_IA32_MPERF, mperf);
>
>   	if (!pstate_funcs.get_max() ||
> -		!pstate_funcs.get_min() ||
> -		!pstate_funcs.get_turbo())
> +	    !pstate_funcs.get_min() ||
> +	    !pstate_funcs.get_turbo())
>   		return -ENODEV;
>
>   	rdmsrl(MSR_IA32_APERF, tmp);
> @@ -960,14 +955,14 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>   	struct acpi_table_header hdr;
>   	struct hw_vendor_info *v_info;
>
> -	if (acpi_disabled
> -	    || ACPI_FAILURE(acpi_get_table_header(ACPI_SIG_FADT, 0, &hdr)))
> +	if (acpi_disabled ||
> +	    ACPI_FAILURE(acpi_get_table_header(ACPI_SIG_FADT, 0, &hdr)))
>   		return false;
>
>   	for (v_info = vendor_info; v_info->valid; v_info++) {
> -		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE)
> -		    && !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE)
> -		    && intel_pstate_no_acpi_pss())
> +		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> +		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
> +		    intel_pstate_no_acpi_pss())
>   			return true;
>   	}
>
> @@ -1021,13 +1016,12 @@ static int __init intel_pstate_init(void)
>   	return rc;
>   out:
>   	get_online_cpus();
> -	for_each_online_cpu(cpu) {
> +	for_each_online_cpu(cpu)
>   		if (all_cpu_data[cpu]) {
>   			del_timer_sync(&all_cpu_data[cpu]->timer);
>   			kfree(all_cpu_data[cpu]->stats);
>   			kfree(all_cpu_data[cpu]);
>   		}
> -	}
>
>   	put_online_cpus();
>   	vfree(all_cpu_data);
>

