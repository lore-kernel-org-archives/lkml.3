Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3IKWpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 18:45:04 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46826 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab3IKWpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 18:45:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tianyu.lan@intel.com
Cc: viresh.kumar@linaro.org, srivatsa.bhat@linux.vnet.ibm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cpufreq: Acquire read lock in the cpufreq_policy_restore() rather than write lock
Date: Thu, 12 Sep 2013 00:56:03 +0200
Message-ID: <2039668.8La2a0cgXT@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
References: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 11, 2013 03:05:05 PM tianyu.lan@intel.com wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> In the cpufreq_policy_restore(), policy before system suspend is read from
> from percpu's cpufreq_cpu_data_fallback. It's read operation rather than
> write operation. So convert write lock to read lock
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Applied, thanks Tianyu!

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
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
