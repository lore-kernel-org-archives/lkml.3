Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3IKINg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:13:36 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52722 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3IKINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:13:33 -0400
Message-ID: <5230253D.6040308@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 13:39:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: tianyu.lan@intel.com
CC: rjw@sisk.pl, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cpufreq: Acquire read lock in the cpufreq_policy_restore()
 rather than write lock
References: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
In-Reply-To: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091108-4790-0000-0000-00000A413F1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 12:35 PM, tianyu.lan@intel.com wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> In the cpufreq_policy_restore(), policy before system suspend is read from
> from percpu's cpufreq_cpu_data_fallback. It's read operation rather than
> write operation. So convert write lock to read lock
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

I noticed it too yesterday, while looking at something else. Thanks for
fixing this!

> ---
>  drivers/cpufreq/cpufreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 81ceea6..b762f9b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -912,11 +912,11 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
>  	struct cpufreq_policy *policy;
>  	unsigned long flags;
> 
> -	write_lock_irqsave(&cpufreq_driver_lock, flags);
> +	read_lock_irqsave(&cpufreq_driver_lock, flags);
> 
>  	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
> 
> -	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
>  	return policy;
>  }
> 
 
Regards,
Srivatsa S. Bhat

