Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3G3Nsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:48:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47451 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3G3Ns3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:48:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: Remove extra variables
Date: Tue, 30 Jul 2013 15:58:39 +0200
Message-ID: <1524530.dqCvbcsNq5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2095cb9de80d87867dbfa42f8433f766891c93ab.1375191318.git.viresh.kumar@linaro.org>
References: <2095cb9de80d87867dbfa42f8433f766891c93ab.1375191318.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 07:06:33 PM Viresh Kumar wrote:
> We call cpufreq_cpu_get() in cpufreq_add_dev_symlink() to increase usage
> refcount of policy and not to get policy for a cpu. So, we don't really need to
> capture the return value of this routine and call put for it later for failure
> cases. We can simply use policy passed as an argument to this routine.
> 
> Moreover debug print is rewritten to make it more clear.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Both [1-2/2] look good, but what do they apply to?  Mainline, linux-next,
my bleeding-edge branch?

Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 170d344..35e1a03 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -813,19 +813,18 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
>  	int ret = 0;
>  
>  	for_each_cpu(j, policy->cpus) {
> -		struct cpufreq_policy *managed_policy;
>  		struct device *cpu_dev;
>  
>  		if (j == cpu)
>  			continue;
>  
> -		pr_debug("CPU %u already managed, adding link\n", j);
> -		managed_policy = cpufreq_cpu_get(cpu);
> +		pr_debug("Adding link for CPU: %u\n", j);
> +		cpufreq_cpu_get(cpu);
>  		cpu_dev = get_cpu_device(j);
>  		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>  					"cpufreq");
>  		if (ret) {
> -			cpufreq_cpu_put(managed_policy);
> +			cpufreq_cpu_put(policy);
>  			return ret;
>  		}
>  	}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
