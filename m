Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3GBGBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:01:36 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53299 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3GBGBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:01:35 -0400
Message-ID: <51D26BE7.3050702@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 11:27:59 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 2/5] metag: smp: enable irqs after set_cpu_online
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1372694659-30176-3-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070205-9574-0000-0000-0000088B54E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 09:34 PM, James Hogan wrote:
> In secondary_start_kernel() interrupts should be enabled with
> local_irq_enable() after the cpu is marked as online with
> set_cpu_online(). Otherwise it's possible for a timer interrupt to
> trigger a softirq, which if the cpu is marked as offline may have it's
> affinity altered.
> 
> Reported-by: Kirill Tkhai <tkhai@yandex.ru>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Kirill Tkhai <tkhai@yandex.ru>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  arch/metag/kernel/smp.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
> index b813515..09979f2 100644
> --- a/arch/metag/kernel/smp.c
> +++ b/arch/metag/kernel/smp.c
> @@ -379,12 +379,7 @@ asmlinkage void secondary_start_kernel(void)
> 
>  	setup_priv();
> 
> -	/*
> -	 * Enable local interrupts.
> -	 */
> -	tbi_startup_interrupt(TBID_SIGNUM_TRT);
>  	notify_cpu_starting(cpu);
> -	local_irq_enable();
> 
>  	pr_info("CPU%u (thread %u): Booted secondary processor\n",
>  		cpu, cpu_2_hwthread_id[cpu]);
> @@ -398,6 +393,12 @@ asmlinkage void secondary_start_kernel(void)
>  	set_cpu_online(cpu, true);
> 
>  	/*
> +	 * Enable local interrupts.
> +	 */
> +	tbi_startup_interrupt(TBID_SIGNUM_TRT);
> +	local_irq_enable();
> +
> +	/*
>  	 * OK, it's off to the idle thread for us
>  	 */
>  	cpu_startup_entry(CPUHP_ONLINE);
> 

