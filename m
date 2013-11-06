Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3KFVLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:11:07 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36281 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3KFVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:11:06 -0500
Message-ID: <527AB066.6050805@linaro.org>
Date: Wed, 06 Nov 2013 22:11:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 7/7] powernv/cpuidle: Enable idle powernv cpu to call
 into the cpuidle framework.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110201.31547.55088.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110201.31547.55088.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:02 PM, Deepthi Dharwar wrote:
> This patch enables idle cpu on the powernv platform  to hook on to the cpuidle
> framework, if available, else call on to default idle platform
> code.
>
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/powerpc/platforms/powernv/setup.c |   13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index e239dcf..42a6ba0 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -25,6 +25,7 @@
>   #include <linux/of.h>
>   #include <linux/interrupt.h>
>   #include <linux/bug.h>
> +#include <linux/cpuidle.h>
>
>   #include <asm/machdep.h>
>   #include <asm/firmware.h>
> @@ -192,6 +193,16 @@ static void __init pnv_setup_machdep_rtas(void)
>   }
>   #endif /* CONFIG_PPC_POWERNV_RTAS */
>
> +void powernv_idle(void)
> +{
> +	/* Hook to cpuidle framework if available, else
> +	 * call on default platform idle code
> +	 */
> +	if (cpuidle_idle_call()) {
> +		power7_idle();
> +	}
> +}
> +
>   static int __init pnv_probe(void)
>   {
>   	unsigned long root = of_get_flat_dt_root();
> @@ -222,7 +233,7 @@ define_machine(powernv) {
>   	.show_cpuinfo		= pnv_show_cpuinfo,
>   	.progress		= pnv_progress,
>   	.machine_shutdown	= pnv_shutdown,
> -	.power_save             = power7_idle,
> +	.power_save             = powernv_idle,
>   	.calibrate_decr		= generic_calibrate_decr,
>   #ifdef CONFIG_KEXEC
>   	.kexec_cpu_down		= pnv_kexec_cpu_down,
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

