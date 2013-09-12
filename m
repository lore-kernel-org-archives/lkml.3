Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3ILINe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:13:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46244 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3ILIN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:13:29 -0400
Message-ID: <523176BA.3050906@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 13:39:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@wwwdotorg.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cpufreq: remove __cpufreq_remove_dev()
References: <cover.1378963070.git.viresh.kumar@linaro.org> <e88d0a9d0a4b0d8296a938d4875d2d2ea2a33e49.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <e88d0a9d0a4b0d8296a938d4875d2d2ea2a33e49.1378963070.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091208-4790-0000-0000-00000A46AA6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:55 AM, Viresh Kumar wrote:
> Nobody except cpufreq_remove_dev() is calling __cpufreq_remove_dev() and so we
> don't need separate routines here. Lets merge code from __cpufreq_remove_dev()
> to cpufreq_remove_dev() and get rid of __cpufreq_remove_dev().
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c | 26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 31f7845..5e0a82e 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1285,36 +1285,26 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  }
> 
>  /**
> - * __cpufreq_remove_dev - remove a CPU device
> + * cpufreq_remove_dev - remove a CPU device
>   *
>   * Removes the cpufreq interface for a CPU device.
>   * Caller should already have policy_rwsem in write mode for this CPU.
>   * This routine frees the rwsem before returning.
>   */
> -static inline int __cpufreq_remove_dev(struct device *dev,
> -				       struct subsys_interface *sif,
> -				       bool frozen)
> -{
> -	int ret;
> -
> -	ret = __cpufreq_remove_dev_prepare(dev, sif, frozen);
> -
> -	if (!ret)
> -		ret = __cpufreq_remove_dev_finish(dev, sif, frozen);
> -
> -	return ret;
> -}
> -
>  static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>  {
>  	unsigned int cpu = dev->id;
> -	int retval;
> +	int ret;
> 
>  	if (cpu_is_offline(cpu))
>  		return 0;
> 
> -	retval = __cpufreq_remove_dev(dev, sif, false);
> -	return retval;
> +	ret = __cpufreq_remove_dev_prepare(dev, sif, false);
> +
> +	if (!ret)
> +		ret = __cpufreq_remove_dev_finish(dev, sif, false);
> +
> +	return ret;
>  }
> 
>  static void handle_update(struct work_struct *work)
> 


