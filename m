Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaCJQfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:35:31 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:48911
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbaCJQf0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:35:26 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Mon, 10 Mar 2014 09:35:20 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Joe Perches <joe@perches.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Reformat printk() statement
References: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
 <CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
 <1394424432.30791.11.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1394424432.30791.11.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f29b7db5-e5a2-48d8-ae42-8ec562c4c4f6@CO9EHSMHS025.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, 2014-03-09 at 09:07PM -0700, Joe Perches wrote:
> On Mon, 2014-03-10 at 11:53 +0800, Viresh Kumar wrote:
> > On 7 March 2014 01:34, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > > Reformat a printk statement to:
> > >  - use pr_warn
> > >  - bring the whole string into a single line in favor of being able to
> > >    grep for the message (ignoring the 80 char limit)
> > >
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> []
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> A more comprehensive patch would be to:
> 
> Add missing newlines
> Coalesce format fragments
> Convert printks to pr_<level>
> Align arguments

I agree. But I didn't want to spend time on "fixing" formatting without
knowing it will be accepted. Also, I was grepping for the message I
ended up changing because on an issue I actually needed to fix.

Do you want me to squash your changes into the patch I submitted? Or do
you wanna pick up mine and submit your patch?

	Thanks,
	Sören

> ---
>  drivers/cpufreq/cpufreq.c | 85 ++++++++++++++++++++++-------------------------
>  1 file changed, 40 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 56b7b1b..c2d06e9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -181,8 +181,8 @@ unsigned int cpufreq_generic_get(unsigned int cpu)
>  	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
>  
>  	if (!policy || IS_ERR(policy->clk)) {
> -		pr_err("%s: No %s associated to cpu: %d\n", __func__,
> -				policy ? "clk" : "policy", cpu);
> +		pr_err("%s: No %s associated to cpu: %d\n",
> +		       __func__, policy ? "clk" : "policy", cpu);
>  		return 0;
>  	}
>  
> @@ -254,15 +254,15 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>  	if (!l_p_j_ref_freq) {
>  		l_p_j_ref = loops_per_jiffy;
>  		l_p_j_ref_freq = ci->old;
> -		pr_debug("saving %lu as reference value for loops_per_jiffy; "
> -			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
> +		pr_debug("saving %lu as reference value for loops_per_jiffy; freq is %u kHz\n",
> +			 l_p_j_ref, l_p_j_ref_freq);
>  	}
>  	if ((val == CPUFREQ_POSTCHANGE && ci->old != ci->new) ||
>  	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
>  		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
>  								ci->new);
> -		pr_debug("scaling loops_per_jiffy to %lu "
> -			"for frequency %u kHz\n", loops_per_jiffy, ci->new);
> +		pr_debug("scaling loops_per_jiffy to %lu for frequency %u kHz\n",
> +			 loops_per_jiffy, ci->new);
>  	}
>  }
>  #else
> @@ -282,7 +282,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  
>  	freqs->flags = cpufreq_driver->flags;
>  	pr_debug("notification %u of frequency transition to %u kHz\n",
> -		state, freqs->new);
> +		 state, freqs->new);
>  
>  	switch (state) {
>  
> @@ -294,9 +294,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
>  			if ((policy) && (policy->cpu == freqs->cpu) &&
>  			    (policy->cur) && (policy->cur != freqs->old)) {
> -				pr_debug("Warning: CPU frequency is"
> -					" %u, cpufreq assumed %u kHz.\n",
> -					freqs->old, policy->cur);
> +				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
> +					 freqs->old, policy->cur);
>  				freqs->old = policy->cur;
>  			}
>  		}
> @@ -307,8 +306,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  
>  	case CPUFREQ_POSTCHANGE:
>  		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
> -		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
> -			(unsigned long)freqs->cpu);
> +		pr_debug("FREQ: %lu - CPU: %lu\n",
> +			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
>  		trace_cpu_frequency(freqs->new, freqs->cpu);
>  		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
>  				CPUFREQ_POSTCHANGE, freqs);
> @@ -368,13 +367,13 @@ static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
>  		return -EINVAL;
>  
>  	if (cpufreq_boost_trigger_state(enable)) {
> -		pr_err("%s: Cannot %s BOOST!\n", __func__,
> -		       enable ? "enable" : "disable");
> +		pr_err("%s: Cannot %s BOOST!\n",
> +		       __func__, enable ? "enable" : "disable");
>  		return -EINVAL;
>  	}
>  
> -	pr_debug("%s: cpufreq BOOST %s\n", __func__,
> -		 enable ? "enabled" : "disabled");
> +	pr_debug("%s: cpufreq BOOST %s\n",
> +		 __func__, enable ? "enabled" : "disabled");
>  
>  	return count;
>  }
> @@ -1184,7 +1183,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	if (gov) {
>  		policy->governor = gov;
>  		pr_debug("Restoring governor %s for cpu %d\n",
> -		       policy->governor->name, cpu);
> +			 policy->governor->name, cpu);
>  	}
>  #endif
>  
> @@ -1263,7 +1262,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>  	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
>  	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
>  	if (ret) {
> -		pr_err("%s: Failed to move kobj: %d", __func__, ret);
> +		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
>  
>  		down_write(&policy->rwsem);
>  		cpumask_set_cpu(old_cpu, policy->cpus);
> @@ -1331,7 +1330,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  
>  			if (!frozen) {
>  				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
> -						__func__, new_cpu, cpu);
> +					 __func__, new_cpu, cpu);
>  			}
>  		}
>  	}
> @@ -1371,7 +1370,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  					CPUFREQ_GOV_POLICY_EXIT);
>  			if (ret) {
>  				pr_err("%s: Failed to exit governor\n",
> -						__func__);
> +				       __func__);
>  				return ret;
>  			}
>  		}
> @@ -1399,7 +1398,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
>  					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
>  				pr_err("%s: Failed to start governor\n",
> -						__func__);
> +				       __func__);
>  				return ret;
>  			}
>  		}
> @@ -1456,8 +1455,8 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
>  	struct cpufreq_freqs freqs;
>  	unsigned long flags;
>  
> -	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing "
> -	       "core thinks of %u, is %u kHz.\n", old_freq, new_freq);
> +	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing core thinks of %u, is %u kHz\n",
> +		 old_freq, new_freq);
>  
>  	freqs.old = old_freq;
>  	freqs.new = new_freq;
> @@ -1598,8 +1597,8 @@ static int cpufreq_bp_suspend(void)
>  	if (cpufreq_driver->suspend) {
>  		ret = cpufreq_driver->suspend(policy);
>  		if (ret)
> -			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
> -					"step on CPU %u\n", policy->cpu);
> +			pr_err("suspend failed in ->suspend step on CPU %u\n",
> +			       policy->cpu);
>  	}
>  
>  	cpufreq_cpu_put(policy);
> @@ -1636,8 +1635,8 @@ static void cpufreq_bp_resume(void)
>  	if (cpufreq_driver->resume) {
>  		ret = cpufreq_driver->resume(policy);
>  		if (ret) {
> -			printk(KERN_ERR "cpufreq: resume failed in ->resume "
> -					"step on CPU %u\n", policy->cpu);
> +			pr_err("resume failed in ->resume step on CPU %u\n",
> +			       policy->cpu);
>  			goto fail;
>  		}
>  	}
> @@ -1767,7 +1766,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  		target_freq = policy->min;
>  
>  	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
> -			policy->cpu, target_freq, relation, old_target_freq);
> +		 policy->cpu, target_freq, relation, old_target_freq);
>  
>  	/*
>  	 * This might look like a redundant call as we are checking it again
> @@ -1812,8 +1811,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  			freqs.flags = 0;
>  
>  			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
> -					__func__, policy->cpu, freqs.old,
> -					freqs.new);
> +				 __func__, policy->cpu, freqs.old, freqs.new);
>  
>  			cpufreq_notify_transition(policy, &freqs,
>  					CPUFREQ_PRECHANGE);
> @@ -1822,7 +1820,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  		retval = cpufreq_driver->target_index(policy, index);
>  		if (retval)
>  			pr_err("%s: Failed to change cpu frequency: %d\n",
> -					__func__, retval);
> +			       __func__, retval);
>  
>  		if (notify)
>  			cpufreq_notify_post_transition(policy, &freqs, retval);
> @@ -1874,11 +1872,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  		if (!gov)
>  			return -EINVAL;
>  		else {
> -			printk(KERN_WARNING "%s governor failed, too long"
> -			       " transition latency of HW, fallback"
> -			       " to %s governor\n",
> -			       policy->governor->name,
> -			       gov->name);
> +			pr_warn("%s governor failed, too long transition latency of HW, fallback to %s governor\n",
> +				policy->governor->name, gov->name);
>  			policy->governor = gov;
>  		}
>  	}
> @@ -1888,7 +1883,7 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  			return -EINVAL;
>  
>  	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
> -						policy->cpu, event);
> +		 policy->cpu, event);
>  
>  	mutex_lock(&cpufreq_governor_lock);
>  	if ((policy->governor_enabled && event == CPUFREQ_GOV_START)
> @@ -2020,8 +2015,8 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  	struct cpufreq_governor *old_gov;
>  	int ret;
>  
> -	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
> -		new_policy->min, new_policy->max);
> +	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
> +		 new_policy->cpu, new_policy->min, new_policy->max);
>  
>  	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
>  
> @@ -2057,7 +2052,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  	policy->max = new_policy->max;
>  
>  	pr_debug("new min and max freqs are %u - %u kHz\n",
> -					policy->min, policy->max);
> +		 policy->min, policy->max);
>  
>  	if (cpufreq_driver->setpolicy) {
>  		policy->policy = new_policy->policy;
> @@ -2145,7 +2140,7 @@ int cpufreq_update_policy(unsigned int cpu)
>  		}
>  
>  		if (!policy->cur) {
> -			pr_debug("Driver did not initialize current freq");
> +			pr_debug("Driver did not initialize current freq\n");
>  			policy->cur = new_policy.cur;
>  		} else {
>  			if (policy->cur != new_policy.cur && has_target())
> @@ -2247,8 +2242,8 @@ int cpufreq_boost_trigger_state(int state)
>  		cpufreq_driver->boost_enabled = !state;
>  		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  
> -		pr_err("%s: Cannot %s BOOST\n", __func__,
> -		       state ? "enable" : "disable");
> +		pr_err("%s: Cannot %s BOOST\n",
> +		       __func__, state ? "enable" : "disable");
>  	}
>  
>  	return ret;
> @@ -2320,7 +2315,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>  		ret = cpufreq_sysfs_create_file(&boost.attr);
>  		if (ret) {
>  			pr_err("%s: cannot register global BOOST sysfs file\n",
> -				__func__);
> +			       __func__);
>  			goto err_null_driver;
>  		}
>  	}
> @@ -2343,7 +2338,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>  		/* if all ->init() calls failed, unregister */
>  		if (ret) {
>  			pr_debug("no CPU initialized for driver %s\n",
> -							driver_data->name);
> +				 driver_data->name);
>  			goto err_if_unreg;
>  		}
>  	}
> 
> 
> 

