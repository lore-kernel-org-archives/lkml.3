Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaCSWaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:30:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62422 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753760AbaCSWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:30:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Remove unnecessary braces
Date: Wed, 19 Mar 2014 23:45:35 +0100
Message-ID: <93042283.W9rbzHbJB2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <532A0D0C.50507@semaphore.gr>
References: <532A0D0C.50507@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2014 11:33:00 PM Stratos Karafotis wrote:
> Remove 3 sets of unnecessary braces
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1eafd8c..ca3c01f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1325,17 +1325,16 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  	cpus = cpumask_weight(policy->cpus);
>  	up_read(&policy->rwsem);
>  
> -	if (cpu != policy->cpu) {
> +	if (cpu != policy->cpu)
>  		sysfs_remove_link(&dev->kobj, "cpufreq");
> -	} else if (cpus > 1) {

These braces aren't in fact unnecessary, they are in accordance with CodingStyle.

> +	else if (cpus > 1) {
>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
>  		if (new_cpu >= 0) {
>  			update_policy_cpu(policy, new_cpu);
>  
> -			if (!cpufreq_suspended) {
> +			if (!cpufreq_suspended)
>  				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>  					 __func__, new_cpu, cpu);
> -			}
>  		}
>  	}
>  
> @@ -2158,11 +2157,9 @@ int cpufreq_update_policy(unsigned int cpu)
>  		if (!policy->cur) {
>  			pr_debug("Driver did not initialize current freq\n");
>  			policy->cur = new_policy.cur;
> -		} else {
> -			if (policy->cur != new_policy.cur && has_target())
> +		} else if (policy->cur != new_policy.cur && has_target())

And here too.

>  				cpufreq_out_of_sync(cpu, policy->cur,
>  								new_policy.cur);
> -		}
>  	}
>  
>  	ret = cpufreq_set_policy(policy, &new_policy);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
