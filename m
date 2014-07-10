Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaGJLdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:33:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53205 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaGJLdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:33:47 -0400
Message-ID: <53BE7987.70008@linux.vnet.ibm.com>
Date: Thu, 10 Jul 2014 17:01:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com
Subject: Re: [PATCH] cpufreq: report driver's successful {un}registration
References: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
In-Reply-To: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071011-7014-0000-0000-000005415CA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 02:21 PM, Viresh Kumar wrote:
> We do report driver's successful {un}registration from cpufreq core, but is done
> with pr_debug() and so this doesn't appear in boot logs.
> 
> Convert this to pr_info() to make it visible in logs.
> 

While at it, let's also standardize those messages, since they will be
more visible now.

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62259d2..63d8f8f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2468,7 +2468,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>  	}
> 
>  	register_hotcpu_notifier(&cpufreq_cpu_notifier);
> -	pr_debug("driver %s up and running\n", driver_data->name);
> +	pr_info("driver %s up and running\n", driver_data->name);

How about "Registered cpufreq driver: %s\n"

> 
>  	return 0;
>  err_if_unreg:
> @@ -2499,7 +2499,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>  	if (!cpufreq_driver || (driver != cpufreq_driver))
>  		return -EINVAL;
> 
> -	pr_debug("unregistering driver %s\n", driver->name);
> +	pr_info("unregistering driver %s\n", driver->name);

And "Unregistered cpufreq driver: %s\n"

(Also, its probably a good idea to have 2 prints here, just like we have for
cpufreq_register_driver() - one with pr_debug() at the beginning of the
function which tells us that we are *about* to register the driver, and then
a second print with pr_info() at the end of the function that tells us that
we successfully registered the driver. We can do the same thing for
unregistration as well.)

> 
>  	subsys_interface_unregister(&cpufreq_interface);
>  	if (cpufreq_boost_supported())
> 

Regards,
Srivatsa S. Bhat

