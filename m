Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCJEHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:07:18 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:44379 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbaCJEHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:07:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:1:41:69:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2636:2828:2896:2910:3138:3139:3140:3141:3142:3165:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4605:5007:7652:7875:8660:9040:10004:10848:11026:11232:11233:11473:11658:11914:12043:12198:12291:12296:12438:12517:12519:12555:12683:12740:13148:13230:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: legs17_3f2edb016db40
X-Filterd-Recvd-Size: 11833
Message-ID: <1394424432.30791.11.camel@joe-AO722>
Subject: Re: [PATCH] cpufreq: Reformat printk() statement
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Sun, 09 Mar 2014 21:07:12 -0700
In-Reply-To: <CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
References: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
	 <CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 11:53 +0800, Viresh Kumar wrote:
> On 7 March 2014 01:34, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > Reformat a printk statement to:
> >  - use pr_warn
> >  - bring the whole string into a single line in favor of being able to
> >    grep for the message (ignoring the 80 char limit)
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
[]
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

A more comprehensive patch would be to:

Add missing newlines
Coalesce format fragments
Convert printks to pr_<level>
Align arguments
---
 drivers/cpufreq/cpufreq.c | 85 ++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 56b7b1b..c2d06e9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -181,8 +181,8 @@ unsigned int cpufreq_generic_get(unsigned int cpu)
 	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!policy || IS_ERR(policy->clk)) {
-		pr_err("%s: No %s associated to cpu: %d\n", __func__,
-				policy ? "clk" : "policy", cpu);
+		pr_err("%s: No %s associated to cpu: %d\n",
+		       __func__, policy ? "clk" : "policy", cpu);
 		return 0;
 	}
 
@@ -254,15 +254,15 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 	if (!l_p_j_ref_freq) {
 		l_p_j_ref = loops_per_jiffy;
 		l_p_j_ref_freq = ci->old;
-		pr_debug("saving %lu as reference value for loops_per_jiffy; "
-			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
+		pr_debug("saving %lu as reference value for loops_per_jiffy; freq is %u kHz\n",
+			 l_p_j_ref, l_p_j_ref_freq);
 	}
 	if ((val == CPUFREQ_POSTCHANGE && ci->old != ci->new) ||
 	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
 		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
 								ci->new);
-		pr_debug("scaling loops_per_jiffy to %lu "
-			"for frequency %u kHz\n", loops_per_jiffy, ci->new);
+		pr_debug("scaling loops_per_jiffy to %lu for frequency %u kHz\n",
+			 loops_per_jiffy, ci->new);
 	}
 }
 #else
@@ -282,7 +282,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 
 	freqs->flags = cpufreq_driver->flags;
 	pr_debug("notification %u of frequency transition to %u kHz\n",
-		state, freqs->new);
+		 state, freqs->new);
 
 	switch (state) {
 
@@ -294,9 +294,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
-				pr_debug("Warning: CPU frequency is"
-					" %u, cpufreq assumed %u kHz.\n",
-					freqs->old, policy->cur);
+				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
+					 freqs->old, policy->cur);
 				freqs->old = policy->cur;
 			}
 		}
@@ -307,8 +306,8 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 
 	case CPUFREQ_POSTCHANGE:
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
-		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
-			(unsigned long)freqs->cpu);
+		pr_debug("FREQ: %lu - CPU: %lu\n",
+			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
@@ -368,13 +367,13 @@ static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
 		return -EINVAL;
 
 	if (cpufreq_boost_trigger_state(enable)) {
-		pr_err("%s: Cannot %s BOOST!\n", __func__,
-		       enable ? "enable" : "disable");
+		pr_err("%s: Cannot %s BOOST!\n",
+		       __func__, enable ? "enable" : "disable");
 		return -EINVAL;
 	}
 
-	pr_debug("%s: cpufreq BOOST %s\n", __func__,
-		 enable ? "enabled" : "disabled");
+	pr_debug("%s: cpufreq BOOST %s\n",
+		 __func__, enable ? "enabled" : "disabled");
 
 	return count;
 }
@@ -1184,7 +1183,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	if (gov) {
 		policy->governor = gov;
 		pr_debug("Restoring governor %s for cpu %d\n",
-		       policy->governor->name, cpu);
+			 policy->governor->name, cpu);
 	}
 #endif
 
@@ -1263,7 +1262,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
 	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
 	if (ret) {
-		pr_err("%s: Failed to move kobj: %d", __func__, ret);
+		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
 
 		down_write(&policy->rwsem);
 		cpumask_set_cpu(old_cpu, policy->cpus);
@@ -1331,7 +1330,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 
 			if (!frozen) {
 				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
-						__func__, new_cpu, cpu);
+					 __func__, new_cpu, cpu);
 			}
 		}
 	}
@@ -1371,7 +1370,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 					CPUFREQ_GOV_POLICY_EXIT);
 			if (ret) {
 				pr_err("%s: Failed to exit governor\n",
-						__func__);
+				       __func__);
 				return ret;
 			}
 		}
@@ -1399,7 +1398,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 				pr_err("%s: Failed to start governor\n",
-						__func__);
+				       __func__);
 				return ret;
 			}
 		}
@@ -1456,8 +1455,8 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	struct cpufreq_freqs freqs;
 	unsigned long flags;
 
-	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing "
-	       "core thinks of %u, is %u kHz.\n", old_freq, new_freq);
+	pr_debug("Warning: CPU frequency out of sync: cpufreq and timing core thinks of %u, is %u kHz\n",
+		 old_freq, new_freq);
 
 	freqs.old = old_freq;
 	freqs.new = new_freq;
@@ -1598,8 +1597,8 @@ static int cpufreq_bp_suspend(void)
 	if (cpufreq_driver->suspend) {
 		ret = cpufreq_driver->suspend(policy);
 		if (ret)
-			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
-					"step on CPU %u\n", policy->cpu);
+			pr_err("suspend failed in ->suspend step on CPU %u\n",
+			       policy->cpu);
 	}
 
 	cpufreq_cpu_put(policy);
@@ -1636,8 +1635,8 @@ static void cpufreq_bp_resume(void)
 	if (cpufreq_driver->resume) {
 		ret = cpufreq_driver->resume(policy);
 		if (ret) {
-			printk(KERN_ERR "cpufreq: resume failed in ->resume "
-					"step on CPU %u\n", policy->cpu);
+			pr_err("resume failed in ->resume step on CPU %u\n",
+			       policy->cpu);
 			goto fail;
 		}
 	}
@@ -1767,7 +1766,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		target_freq = policy->min;
 
 	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
-			policy->cpu, target_freq, relation, old_target_freq);
+		 policy->cpu, target_freq, relation, old_target_freq);
 
 	/*
 	 * This might look like a redundant call as we are checking it again
@@ -1812,8 +1811,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			freqs.flags = 0;
 
 			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
-					__func__, policy->cpu, freqs.old,
-					freqs.new);
+				 __func__, policy->cpu, freqs.old, freqs.new);
 
 			cpufreq_notify_transition(policy, &freqs,
 					CPUFREQ_PRECHANGE);
@@ -1822,7 +1820,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		retval = cpufreq_driver->target_index(policy, index);
 		if (retval)
 			pr_err("%s: Failed to change cpu frequency: %d\n",
-					__func__, retval);
+			       __func__, retval);
 
 		if (notify)
 			cpufreq_notify_post_transition(policy, &freqs, retval);
@@ -1874,11 +1872,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 		if (!gov)
 			return -EINVAL;
 		else {
-			printk(KERN_WARNING "%s governor failed, too long"
-			       " transition latency of HW, fallback"
-			       " to %s governor\n",
-			       policy->governor->name,
-			       gov->name);
+			pr_warn("%s governor failed, too long transition latency of HW, fallback to %s governor\n",
+				policy->governor->name, gov->name);
 			policy->governor = gov;
 		}
 	}
@@ -1888,7 +1883,7 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 			return -EINVAL;
 
 	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
-						policy->cpu, event);
+		 policy->cpu, event);
 
 	mutex_lock(&cpufreq_governor_lock);
 	if ((policy->governor_enabled && event == CPUFREQ_GOV_START)
@@ -2020,8 +2015,8 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	struct cpufreq_governor *old_gov;
 	int ret;
 
-	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
-		new_policy->min, new_policy->max);
+	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
+		 new_policy->cpu, new_policy->min, new_policy->max);
 
 	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
 
@@ -2057,7 +2052,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	policy->max = new_policy->max;
 
 	pr_debug("new min and max freqs are %u - %u kHz\n",
-					policy->min, policy->max);
+		 policy->min, policy->max);
 
 	if (cpufreq_driver->setpolicy) {
 		policy->policy = new_policy->policy;
@@ -2145,7 +2140,7 @@ int cpufreq_update_policy(unsigned int cpu)
 		}
 
 		if (!policy->cur) {
-			pr_debug("Driver did not initialize current freq");
+			pr_debug("Driver did not initialize current freq\n");
 			policy->cur = new_policy.cur;
 		} else {
 			if (policy->cur != new_policy.cur && has_target())
@@ -2247,8 +2242,8 @@ int cpufreq_boost_trigger_state(int state)
 		cpufreq_driver->boost_enabled = !state;
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-		pr_err("%s: Cannot %s BOOST\n", __func__,
-		       state ? "enable" : "disable");
+		pr_err("%s: Cannot %s BOOST\n",
+		       __func__, state ? "enable" : "disable");
 	}
 
 	return ret;
@@ -2320,7 +2315,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		ret = cpufreq_sysfs_create_file(&boost.attr);
 		if (ret) {
 			pr_err("%s: cannot register global BOOST sysfs file\n",
-				__func__);
+			       __func__);
 			goto err_null_driver;
 		}
 	}
@@ -2343,7 +2338,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		/* if all ->init() calls failed, unregister */
 		if (ret) {
 			pr_debug("no CPU initialized for driver %s\n",
-							driver_data->name);
+				 driver_data->name);
 			goto err_if_unreg;
 		}
 	}


