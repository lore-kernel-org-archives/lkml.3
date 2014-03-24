Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCXOyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:54:54 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49047 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCXOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:54:52 -0400
Message-ID: <53304725.3000900@linux.vnet.ibm.com>
Date: Mon, 24 Mar 2014 20:24:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: [PATCH] intel_pstate:  Use del_timer_sync in intel_pstate_cpu_stop
References: <1395672089-19336-1-git-send-email-dirk.j.brandewie@intel.com>
In-Reply-To: <1395672089-19336-1-git-send-email-dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032414-5564-0000-0000-00000CA686C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 08:11 PM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Ensure that no timer callback is running since we are about to free
> the timer structure.  We cannot guarantee that the call back is called
> on the CPU where the timer is running.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: cpufreq <cpufreq@vger.kernel.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/intel_pstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index e9092fd..a4a9ba5 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -780,7 +780,7 @@ static int intel_pstate_cpu_stop(struct cpufreq_policy *policy)
> 
>  	pr_info("intel_pstate CPU %d exiting\n", cpu_num);
> 
> -	del_timer(&all_cpu_data[cpu_num]->timer);
> +	del_timer_sync(&all_cpu_data[cpu_num]->timer);
>  	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
>  	kfree(all_cpu_data[cpu_num]);
>  	all_cpu_data[cpu_num] = NULL;
> 

