Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3CYIIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:08:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:52532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3CYIIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:08:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="218519410"
Message-ID: <1364198913.2465.40.camel@rzhang1-mobl4>
Subject: Re: [PATCH V2] drivers: thermal: cpu_cooling: fix checkpatch warning
From: Zhang Rui <rui.zhang@intel.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 16:08:33 +0800
In-Reply-To: <1363085270-22886-1-git-send-email-laurent.navet@gmail.com>
References: <1363085270-22886-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 11:47 +0100, Laurent Navet wrote:
> - WARNING: Avoid CamelCase: <maskPtr>
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

applied to thermal -next.

thanks,
rui
> ---
>  drivers/thermal/cpu_cooling.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 8dc44cb..be2e6b0 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -168,8 +168,8 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
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
> @@ -184,7 +184,7 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>  	cpufreq_device->cpufreq_val = clip_freq;
>  	notify_device = cpufreq_device;
>  
> -	for_each_cpu(cpuid, maskPtr) {
> +	for_each_cpu(cpuid, mask) {
>  		if (is_cpufreq_valid(cpuid))
>  			cpufreq_update_policy(cpuid);
>  	}
> @@ -235,13 +235,13 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  				 unsigned long *state)
>  {
>  	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> -	struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
> +	struct cpumask *mask = &cpufreq_device->allowed_cpus;
>  	unsigned int cpu;
>  	struct cpufreq_frequency_table *table;
>  	unsigned long count = 0;
>  	int i = 0;
>  
> -	cpu = cpumask_any(maskPtr);
> +	cpu = cpumask_any(mask);
>  	table = cpufreq_frequency_get_table(cpu);
>  	if (!table) {
>  		*state = 0;


