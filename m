Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3LTVwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:52:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54489 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3LTVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:52:33 -0500
Message-ID: <52B4BC23.4080102@linaro.org>
Date: Fri, 20 Dec 2013 22:52:35 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, rjw@rjwysocki.net
CC: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2 6/9] intel_idle: do C1E promotion disable quirk for
 hotplugged CPUs
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com> <1387565251-7051-7-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1387565251-7051-7-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:47 PM, Bartlomiej Zolnierkiewicz wrote:
> If the system is booted with some CPUs offline C1E promotion disable quirk
> won't be applied because on_each_cpu() in intel_idle_cpuidle_driver_init()
> operates only on online CPUs. Fix it by adding the C1E promotion disable
> handling to intel_idle_cpu_init() (which is also called during CPU_ONLINE
> operation).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/idle/intel_idle.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 92d1206..38da3fb 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -683,6 +683,9 @@ static int intel_idle_cpu_init(int cpu)
>   	if (icpu->auto_demotion_disable_flags)
>   		smp_call_function_single(cpu, auto_demotion_disable, NULL, 1);
>
> +	if (icpu->disable_promotion_to_c1e)
> +		smp_call_function_single(cpu, c1e_promotion_disable, NULL, 1);
> +
>   	return 0;
>   }

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

