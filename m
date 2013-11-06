Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3KFVBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:01:11 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47240 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3KFVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:01:10 -0500
Message-ID: <527AAE13.2090400@linaro.org>
Date: Wed, 06 Nov 2013 22:01:07 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 3/7] pseries/cpuidle: Make pseries_idle backend driver
 a non-module.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110134.31547.86550.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110134.31547.86550.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:01 PM, Deepthi Dharwar wrote:
> Currently pseries_idle cpuidle backend driver cannot be
> built as a module due to dependencies. Therefore the driver has
> to be built in. The dependency is around update_snooze_delay() defined
> in cpuidle driver and called from kernel/sysfs.c.
> This patch is removes all the module related code.
>
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/cpuidle-ibm-power.c |   15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
> index faf8cc1..8c9e42c 100644
> --- a/drivers/cpuidle/cpuidle-ibm-power.c
> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
> @@ -292,17 +292,4 @@ static int __init pseries_processor_idle_init(void)
>   	return 0;
>   }
>
> -static void __exit pseries_processor_idle_exit(void)
> -{
> -
> -	unregister_cpu_notifier(&setup_hotplug_notifier);
> -	cpuidle_unregister(&pseries_idle_driver);
> -	return;
> -}
> -
> -module_init(pseries_processor_idle_init);
> -module_exit(pseries_processor_idle_exit);
> -
> -MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
> -MODULE_DESCRIPTION("Cpuidle driver for POWER");
> -MODULE_LICENSE("GPL");
> +device_initcall(pseries_processor_idle_init);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

