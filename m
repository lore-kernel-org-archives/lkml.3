Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaCKTOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:14:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58309 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755457AbaCKTOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:14:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Joe Perches <joe@perches.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: Reformat printk() statements
Date: Tue, 11 Mar 2014 20:29:27 +0100
Message-ID: <16243824.d7jua8nUso@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531F441C.5070107@gmail.com>
References: <1394557380-15054-1-git-send-email-soren.brinkmann@xilinx.com> <531F441C.5070107@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 10:13:00 AM Dirk Brandewie wrote:
> On 03/11/2014 10:03 AM, Soren Brinkmann wrote:
> > From: Joe Perches <joe@perches.com>
> >
> >   - Add missing newlines
> >   - Coalesce format fragments
> >   - Convert printks to pr_<level>
> >   - Align arguments
> >
> 
> This introduces a bunch of lines over 80 charaters long.

Do you mean code lines or output lines?

> 
> > Original-patch-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > I didn't send this out yesterday, did I?
> > Anyway, this is Joe's patch. I thought I just submit it as proper patch which is
> > easier to handle than assembling this from all the pieces in the original
> > thread.
> >
> > 	Thanks,
> > 	Sören
> >
> >   drivers/cpufreq/cpufreq.c | 85 ++++++++++++++++++++++-------------------------
> >   1 file changed, 40 insertions(+), 45 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 08ca8c9f41cd..9eb1bd924817 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -181,8 +181,8 @@ unsigned int cpufreq_generic_get(unsigned int cpu)
> >   	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
> >
> >   	if (!policy || IS_ERR(policy->clk)) {
> > -		pr_err("%s: No %s associated to cpu: %d\n", __func__,
> > -				policy ? "clk" : "policy", cpu);
> > +		pr_err("%s: No %s associated to cpu: %d\n",
> > +		       __func__, policy ? "clk" : "policy", cpu);
> >   		return 0;
> >   	}
> >
> > @@ -254,15 +254,15 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
> >   	if (!l_p_j_ref_freq) {
> >   		l_p_j_ref = loops_per_jiffy;
> >   		l_p_j_ref_freq = ci->old;
> > -		pr_debug("saving %lu as reference value for loops_per_jiffy; "
> > -			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
> > +		pr_debug("saving %lu as reference value for loops_per_jiffy; freq is %u kHz\n",
> > +			 l_p_j_ref, l_p_j_ref_freq);
> >   	}
> >   	if ((val == CPUFREQ_POSTCHANGE && ci->old != ci->new) ||
> >   	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
> >   		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
> >   								ci->new);
> > -		pr_debug("scaling loops_per_jiffy to %lu "
> > -			"for frequency %u kHz\n", loops_per_jiffy, ci->new);
> > +		pr_debug("scaling loops_per_jiffy to %lu for frequency %u kHz\n",
> > +			 loops_per_jiffy, ci->new);
> >   	}
> >   }
> >   #else
> > @@ -282,7 +282,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
> >
> >   	freqs->flags = cpufreq_driver->flags;
> >   	pr_debug("notification %u of frequency transition to %u kHz\n",
> > -		state, freqs->new);
> > +		 state, freqs->new);
> >
> >   	switch (state) {
> >
> > @@ -294,9 +294,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
> >   		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
> >   			if ((policy) && (policy->cpu == freqs->cpu) &&
> >   			    (policy->cur) && (policy->cur != freqs->old)) {
> > -				pr_debug("Warning: CPU frequency is"
> > -					" %u, cpufreq assumed %u kHz.\n",
> > -					freqs->old, policy->cur);
> > +				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
> > +					 freqs->old, policy->cur);
> >   				freqs->old = policy->cur;
> >   			}
> >   		}
> > @@ -307,8 +306,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
> >
> >   	case CPUFREQ_POSTCHANGE:
> >   		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
> > -		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
> > -			(unsigned long)freqs->cpu);
> > +		pr_debug("FREQ: %lu - CPU: %lu\n",
> > +			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
> >   		trace_cpu_frequency(freqs->new, freqs->cpu);
> >   		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
> >   				CPUFREQ_POSTCHANGE, freqs);
> > @@ -368,13 +367,13 @@ static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
> >   		return -EINVAL;
> >
> >   	if (cpufreq_boost_trigger_state(enable)) {
> > -		pr_err("%s: Cannot %s BOOST!\n", __func__,
> > -		       enable ? "enable" : "disable");
> > +		pr_err("%s: Cannot %s BOOST!\n",
> > +		       __func__, enable ? "enable" : "disable");
> >   		return -EINVAL;
> >   	}
> >
> > -	pr_debug("%s: cpufreq BOOST %s\n", __func__,
> > -		 enable ? "enabled" : "disabled");
> > +	pr_debug("%s: cpufreq BOOST %s\n",
> > +		 __func__, enable ? "enabled" : "disabled");
> >
> >   	return count;
> >   }
> > @@ -1184,7 +1183,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> >   	if (gov) {
> >   		policy->governor = gov;
> >   		pr_debug("Restoring governor %s for cpu %d\n",
> > -		       policy->governor->name, cpu);
> > +			 policy->governor->name, cpu);
> >   	}
> >   #endif
> >
> > @@ -1263,7 +1262,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
> >   	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
> >   	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
> >   	if (ret) {
> > -		pr_err("%s: Failed to move kobj: %d", __func__, ret);
> > +		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
> >
> >   		down_write(&policy->rwsem);
> >   		cpumask_set_cpu(old_cpu, policy->cpus);
> > @@ -1332,7 +1331,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
> >
> >   			if (!frozen) {
> >   				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
> > -						__func__, new_cpu, cpu);
> > +					 __func__, new_cpu, cpu);
> >   			}
> >   		}
> >   	}
> > @@ -1372,7 +1371,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
> >   					CPUFREQ_GOV_POLICY_EXIT);
> >   			if (ret) {
> >   				pr_err("%s: Failed to exit governor\n",
> > -						__func__);
> > +				       __func__);
> >   				return ret;
> >   			}
> >   		}
> > @@ -1400,7 +1399,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
> >   			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
> >   					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
> >   				pr_err("%s: Failed to start governor\n",
> > -						__func__);
> > +				       __func__);
> >   				return ret;
> >   			}
> >   		}
> > @@ -1457,8 +1456,8 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
> >   	struct cpufreq_freqs freqs;
> >   	unsigned long flags;
> >
> > -	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing "
> > -	       "core thinks of %u, is %u kHz.\n", old_freq, new_freq);
> > +	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing core thinks of %u, is %u kHz\n",
> > +		 old_freq, new_freq);
> >
> >   	freqs.old = old_freq;
> >   	freqs.new = new_freq;
> > @@ -1599,8 +1598,8 @@ static int cpufreq_bp_suspend(void)
> >   	if (cpufreq_driver->suspend) {
> >   		ret = cpufreq_driver->suspend(policy);
> >   		if (ret)
> > -			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
> > -					"step on CPU %u\n", policy->cpu);
> > +			pr_err("suspend failed in ->suspend step on CPU %u\n",
> > +			       policy->cpu);
> >   	}
> >
> >   	cpufreq_cpu_put(policy);
> > @@ -1637,8 +1636,8 @@ static void cpufreq_bp_resume(void)
> >   	if (cpufreq_driver->resume) {
> >   		ret = cpufreq_driver->resume(policy);
> >   		if (ret) {
> > -			printk(KERN_ERR "cpufreq: resume failed in ->resume "
> > -					"step on CPU %u\n", policy->cpu);
> > +			pr_err("resume failed in ->resume step on CPU %u\n",
> > +			       policy->cpu);
> >   			goto fail;
> >   		}
> >   	}
> > @@ -1768,7 +1767,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
> >   		target_freq = policy->min;
> >
> >   	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
> > -			policy->cpu, target_freq, relation, old_target_freq);
> > +		 policy->cpu, target_freq, relation, old_target_freq);
> >
> >   	/*
> >   	 * This might look like a redundant call as we are checking it again
> > @@ -1813,8 +1812,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
> >   			freqs.flags = 0;
> >
> >   			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
> > -					__func__, policy->cpu, freqs.old,
> > -					freqs.new);
> > +				 __func__, policy->cpu, freqs.old, freqs.new);
> >
> >   			cpufreq_notify_transition(policy, &freqs,
> >   					CPUFREQ_PRECHANGE);
> > @@ -1823,7 +1821,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
> >   		retval = cpufreq_driver->target_index(policy, index);
> >   		if (retval)
> >   			pr_err("%s: Failed to change cpu frequency: %d\n",
> > -					__func__, retval);
> > +			       __func__, retval);
> >
> >   		if (notify)
> >   			cpufreq_notify_post_transition(policy, &freqs, retval);
> > @@ -1875,11 +1873,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >   		if (!gov)
> >   			return -EINVAL;
> >   		else {
> > -			printk(KERN_WARNING "%s governor failed, too long"
> > -			       " transition latency of HW, fallback"
> > -			       " to %s governor\n",
> > -			       policy->governor->name,
> > -			       gov->name);
> > +			pr_warn("%s governor failed, too long transition latency of HW, fallback to %s governor\n",
> > +				policy->governor->name, gov->name);
> >   			policy->governor = gov;
> >   		}
> >   	}
> > @@ -1889,7 +1884,7 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >   			return -EINVAL;
> >
> >   	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
> > -						policy->cpu, event);
> > +		 policy->cpu, event);
> >
> >   	mutex_lock(&cpufreq_governor_lock);
> >   	if ((policy->governor_enabled && event == CPUFREQ_GOV_START)
> > @@ -2020,8 +2015,8 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
> >   {
> >   	int ret = 0, failed = 1;
> >
> > -	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
> > -		new_policy->min, new_policy->max);
> > +	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
> > +		 new_policy->cpu, new_policy->min, new_policy->max);
> >
> >   	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
> >
> > @@ -2059,7 +2054,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
> >   	policy->max = new_policy->max;
> >
> >   	pr_debug("new min and max freqs are %u - %u kHz\n",
> > -					policy->min, policy->max);
> > +		 policy->min, policy->max);
> >
> >   	if (cpufreq_driver->setpolicy) {
> >   		policy->policy = new_policy->policy;
> > @@ -2152,7 +2147,7 @@ int cpufreq_update_policy(unsigned int cpu)
> >   	if (cpufreq_driver->get) {
> >   		new_policy.cur = cpufreq_driver->get(cpu);
> >   		if (!policy->cur) {
> > -			pr_debug("Driver did not initialize current freq");
> > +			pr_debug("Driver did not initialize current freq\n");
> >   			policy->cur = new_policy.cur;
> >   		} else {
> >   			if (policy->cur != new_policy.cur && has_target())
> > @@ -2255,8 +2250,8 @@ int cpufreq_boost_trigger_state(int state)
> >   		cpufreq_driver->boost_enabled = !state;
> >   		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > -		pr_err("%s: Cannot %s BOOST\n", __func__,
> > -		       state ? "enable" : "disable");
> > +		pr_err("%s: Cannot %s BOOST\n",
> > +		       __func__, state ? "enable" : "disable");
> >   	}
> >
> >   	return ret;
> > @@ -2328,7 +2323,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
> >   		ret = cpufreq_sysfs_create_file(&boost.attr);
> >   		if (ret) {
> >   			pr_err("%s: cannot register global BOOST sysfs file\n",
> > -				__func__);
> > +			       __func__);
> >   			goto err_null_driver;
> >   		}
> >   	}
> > @@ -2351,7 +2346,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
> >   		/* if all ->init() calls failed, unregister */
> >   		if (ret) {
> >   			pr_debug("no CPU initialized for driver %s\n",
> > -							driver_data->name);
> > +				 driver_data->name);
> >   			goto err_if_unreg;
> >   		}
> >   	}
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
