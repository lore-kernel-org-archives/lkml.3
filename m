Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3G0F3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 01:29:46 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:60655 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3G0F3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 01:29:45 -0400
Message-ID: <51F35AC7.8060909@linaro.org>
Date: Sat, 27 Jul 2013 07:29:43 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpuidle/powernv: Enable idle powernv cpu to call
 into the cpuidle framework.
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090150.7291.89879.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130723090150.7291.89879.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
> This patch enables idle powernv cpu to hook on to the cpuidle
> framework, if available, else call on to default idle platform
> code.

Why do you need to do that ?


> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/powernv/setup.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 84438af..97d0951 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -25,6 +25,7 @@
>  #include <linux/of.h>
>  #include <linux/interrupt.h>
>  #include <linux/bug.h>
> +#include <linux/cpuidle.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/firmware.h>
> @@ -196,6 +197,15 @@ static int __init pnv_probe(void)
>  	return 1;
>  }
>  
> +void powernv_idle(void)
> +{
> +	/* Hook to cpuidle framework if available, else
> +	 * call on default platform idle code
> +	 */
> +	if (cpuidle_idle_call())
> +		power7_idle();
> +}
> +
>  define_machine(powernv) {
>  	.name			= "PowerNV",
>  	.probe			= pnv_probe,
> @@ -205,7 +215,7 @@ define_machine(powernv) {
>  	.show_cpuinfo		= pnv_show_cpuinfo,
>  	.progress		= pnv_progress,
>  	.machine_shutdown	= pnv_shutdown,
> -	.power_save             = power7_idle,
> +	.power_save             = powernv_idle,
>  	.calibrate_decr		= generic_calibrate_decr,
>  #ifdef CONFIG_KEXEC
>  	.kexec_cpu_down		= pnv_kexec_cpu_down,
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

