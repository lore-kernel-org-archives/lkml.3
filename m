Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3LTVsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:48:36 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:33001 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3LTVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:48:34 -0500
Message-ID: <52B4BB34.70804@linaro.org>
Date: Fri, 20 Dec 2013 22:48:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, rjw@rjwysocki.net
CC: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2 7/9] intel_idle: remove superfluous dev->state_count
 initialization
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com> <1387565251-7051-8-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1387565251-7051-8-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:47 PM, Bartlomiej Zolnierkiewicz wrote:
> intel_idle driver sets dev->state_count to drv->state_count so
> the default dev->state_count initialization in cpuidle_enable_device()
> (called from cpuidle_register_device()) can be used instead.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/idle/intel_idle.c | 29 -----------------------------
>   1 file changed, 29 deletions(-)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 38da3fb..524d07b 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -639,39 +639,10 @@ static int __init intel_idle_cpuidle_driver_init(void)
>    */
>   static int intel_idle_cpu_init(int cpu)
>   {
> -	int cstate;
>   	struct cpuidle_device *dev;
>
>   	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
>
> -	dev->state_count = 1;
> -
> -	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
> -		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
> -
> -		if (cpuidle_state_table[cstate].enter == NULL)
> -			break;
> -
> -		if (cstate + 1 > max_cstate) {
> -			printk(PREFIX "max_cstate %d reached\n", max_cstate);
> -			break;
> -		}
> -
> -		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
> -		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
> -		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
> -
> -		/* does the state exist in CPUID.MWAIT? */
> -		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
> -					& MWAIT_SUBSTATE_MASK;
> -
> -		/* if sub-state in table is not enumerated by CPUID */
> -		if ((mwait_substate + 1) > num_substates)
> -			continue;
> -
> -		dev->state_count += 1;
> -	}
> -
>   	dev->cpu = cpu;
>
>   	if (cpuidle_register_device(dev)) {
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

