Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaBFQAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:00:32 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41096 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaBFQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:00:30 -0500
Message-ID: <52F3B0BB.50401@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 21:26:43 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020616-5140-0000-0000-000004851587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 07:46 PM, Nicolas Pitre wrote:
> The core idle loop now takes care of it.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/powerpc/platforms/powernv/setup.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 21166f65c9..a932feb290 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -26,7 +26,6 @@
>  #include <linux/of_fdt.h>
>  #include <linux/interrupt.h>
>  #include <linux/bug.h>
> -#include <linux/cpuidle.h>
> 
>  #include <asm/machdep.h>
>  #include <asm/firmware.h>
> @@ -217,16 +216,6 @@ static int __init pnv_probe(void)
>  	return 1;
>  }
> 
> -void powernv_idle(void)
> -{
> -	/* Hook to cpuidle framework if available, else
> -	 * call on default platform idle code
> -	 */
> -	if (cpuidle_idle_call()) {
> -		power7_idle();
> -	}
> -}
> -
>  define_machine(powernv) {
>  	.name			= "PowerNV",
>  	.probe			= pnv_probe,
> @@ -236,7 +225,7 @@ define_machine(powernv) {
>  	.show_cpuinfo		= pnv_show_cpuinfo,
>  	.progress		= pnv_progress,
>  	.machine_shutdown	= pnv_shutdown,
> -	.power_save             = powernv_idle,
> +	.power_save             = power7_idle,
>  	.calibrate_decr		= generic_calibrate_decr,
>  #ifdef CONFIG_KEXEC
>  	.kexec_cpu_down		= pnv_kexec_cpu_down,
> 

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

