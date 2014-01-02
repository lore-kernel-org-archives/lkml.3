Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbaABFlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 00:41:14 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41496 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaABFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 00:41:12 -0500
Message-ID: <52C4FBF3.1060605@linux.vnet.ibm.com>
Date: Thu, 02 Jan 2014 11:11:07 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: rjw@rjwysocki.net, linux-samsung-soc@vger.kernel.org,
        linux-pm@vger.kernel.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linuxppc-dev@lists.ozlabs.org, lenb@kernel.org
Subject: Re: [PATCH v2 2/9] POWERPC: pseries: cpuidle: remove superfluous
 dev->state_count initialization
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com> <1387565251-7051-3-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1387565251-7051-3-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010205-1396-0000-0000-00000416CC71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2013 12:17 AM, Bartlomiej Zolnierkiewicz wrote:
> pseries cpuidle driver sets dev->state_count to drv->state_count so
> the default dev->state_count initialization in cpuidle_enable_device()
> (called from cpuidle_register_device()) can be used instead.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

> Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/processor_idle.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
> index a166e38..8aa8c40 100644
> --- a/arch/powerpc/platforms/pseries/processor_idle.c
> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
> @@ -271,7 +271,6 @@ static void pseries_idle_devices_uninit(void)
>  static int pseries_idle_devices_init(void)
>  {
>  	int i;
> -	struct cpuidle_driver *drv = &pseries_idle_driver;
>  	struct cpuidle_device *dev;
> 
>  	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> @@ -280,7 +279,6 @@ static int pseries_idle_devices_init(void)
> 
>  	for_each_possible_cpu(i) {
>  		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
> -		dev->state_count = drv->state_count;
>  		dev->cpu = i;
>  		if (cpuidle_register_device(dev)) {
>  			printk(KERN_DEBUG \
> 

