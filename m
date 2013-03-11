Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3CKOYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:24:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:19229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3CKOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="299135574"
Message-ID: <1363011868.2291.74.camel@rzhang1-mobl4>
Subject: Re: [PATCH] drivers: thermal: cpu_cooling: fix checkpatch warning
From: Zhang Rui <rui.zhang@intel.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 22:24:28 +0800
In-Reply-To: <1361886162-9387-1-git-send-email-laurent.navet@gmail.com>
References: <1361886162-9387-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 14:42 +0100, Laurent Navet wrote:
> - WARNING: Avoid CamelCase: <maskPtr>
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/thermal/cpu_cooling.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 836828e..47b7d32 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -175,8 +175,8 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>  				unsigned long cooling_state)
>  {
>  	unsigned int cpuid, clip_freq;
> -	struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
> -	unsigned int cpu = cpumask_any(maskPtr);
> +	struct cpumask *mask = &cpufreq_device->allowed_cpus;
> +	unsigned int cpu = cpumask_any(mask);
>  
> 
>  	/* Check if the old cooling action is same as new cooling action */
> @@ -191,7 +191,7 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>  	cpufreq_device->cpufreq_val = clip_freq;
>  	notify_device = cpufreq_device;
>  
> -	for_each_cpu(cpuid, maskPtr) {
> +	for_each_cpu(cpuid, mask) {
>  		if (is_cpufreq_valid(cpuid))
>  			cpufreq_update_policy(cpuid);
>  	}
why not fix the code in cpufreq_get_max_state() as well, in one patch?

thanks,
rui

