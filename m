Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbaCUHvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:51:53 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34689 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaCUHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:51:51 -0400
Message-ID: <532BEF82.1080700@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 13:21:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Make cpufreq_notify_transition & cpufreq_notify_post_transition
 static
References: <cover.1395379422.git.viresh.kumar@linaro.org> <827ab1ca9caaa50ed672c5e01806314c06ad8db8.1395379422.git.viresh.kumar@linaro.org>
In-Reply-To: <827ab1ca9caaa50ed672c5e01806314c06ad8db8.1395379422.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032107-7014-0000-0000-0000048BF24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:04 AM, Viresh Kumar wrote:
> cpufreq_notify_transition() and cpufreq_notify_post_transition() shouldn't be
> called directly by cpufreq drivers anymore and so these should be marked static.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c | 6 ++----
>  include/linux/cpufreq.h   | 4 ----
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index b63e7e4..7b1feff 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -331,16 +331,15 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>   * function. It is called twice on all CPU frequency changes that have
>   * external effects.
>   */
> -void cpufreq_notify_transition(struct cpufreq_policy *policy,
> +static void cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs, unsigned int state)
>  {
>  	for_each_cpu(freqs->cpu, policy->cpus)
>  		__cpufreq_notify_transition(policy, freqs, state);
>  }
> -EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
> 
>  /* Do post notifications when there are chances that transition has failed */
> -void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
> +static void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs, int transition_failed)
>  {
>  	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
> @@ -351,7 +350,6 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
>  	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
>  }
> -EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
> 
>  void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs)
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 263173d..826830b 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -338,10 +338,6 @@ static inline void cpufreq_resume(void) {}
>  int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
>  int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
> 
> -void cpufreq_notify_transition(struct cpufreq_policy *policy,
> -		struct cpufreq_freqs *freqs, unsigned int state);
> -void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
> -		struct cpufreq_freqs *freqs, int transition_failed);
>  void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs);
>  void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
> 


