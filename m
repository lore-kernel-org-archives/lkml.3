Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaGQIb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:31:28 -0400
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:48273 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbaGQIbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:31:25 -0400
X-AuditID: 1209190d-f79c06d000002f07-00-53c789dc7659
Message-ID: <53C7894F.3030007@mit.edu>
Date: Thu, 17 Jul 2014 13:59:03 +0530
From: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: mingo@kernel.org, swarren@wwwdotorg.org, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] irq_work: Remove BUG_ON in irq_work_run()
References: <tip-busatzs2gvz4v62258agipuf@git.kernel.org>
In-Reply-To: <tip-busatzs2gvz4v62258agipuf@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsUixCmqrXun83iwwdfbYhYzX3czWUzbKG5x
	edccNovzZ1axW6z+d4rR4njvASaLy1+vM1u8OtjGYrF501Rmi0d9b9kduDx2zrrL7rF5hZbH
	plWdbB7vzp1j9zgx4zeLx4NDm1k8Pm+S89g4N9TjRMsX1gDOKC6blNSczLLUIn27BK6M/++f
	MBfckK5YvP8LUwPja7EuRk4OCQETiVXzrzBC2GISF+6tZ+ti5OIQEpjNJPFr9xJmkISQwEZG
	idbl7hCJ7UwSf259ZQNJ8AqoScy4dhesiEVAVWLVnEtAcQ4ONgFtiWUbJUHCogJxEo3HvzNC
	lAtKnJz5hAXEFhEoklh6vxdsGbPAHEaJ239mgM0UFnCXeHrhGwvIHCEBS4lzR/xAwpwCVhIf
	35wHCzMLqEusnycEEmYWkJfY/nYO8wRGwVlINsxCqJqFpGoBI/MqRtmU3Crd3MTMnOLUZN3i
	5MS8vNQiXSO93MwSvdSU0k2M4EiS5N3B+O6g0iFGAQ5GJR7ehNZjwUKsiWXFlbmHGCU5mJRE
	edvajgcL8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuG1bwTK8aYkVlalFuXDpKQ5WJTEed9aWwUL
	CaQnlqRmp6YWpBbBZGU4OJQkePd2ADUKFqWmp1akZeaUIKSZODhBhvMADb8KUsNbXJCYW5yZ
	DpE/xagoJc7bAJIQAElklObB9cIS3StGcaBXhHlPg1TxAJMkXPcroMFMQIOly8EGlyQipKQa
	GPc4mlpoTOvfmNC6Ry+hc2lygsLvCqV8tr8JakUXb66vemfcpbHwd5MpcxN7gmPj2uXKCcb5
	ads8z36VOSASLXXsS+u+izzz45ZETvy0X/4xZ2bDNamD8Z0PMkU2uTfuMM3wEzlyr3bBFt0M
	7W+f/RxaU540lMzrPfHujs0S7z0Gic1Lr1S1KLEUZyQaajEXFScCAKiFitpPAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

On 07/05/2014 04:13 PM, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  a77353e5eb56b6c6098bfce59aff1f449451b0b7
> Gitweb:     http://git.kernel.org/tip/a77353e5eb56b6c6098bfce59aff1f449451b0b7
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed, 25 Jun 2014 07:13:07 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 5 Jul 2014 11:17:26 +0200
> 
> irq_work: Remove BUG_ON in irq_work_run()
>

I believe this fix has to go into 3.16 itself, since this fixes a CPU hotplug
regression on many systems, as reported here:

https://lkml.org/lkml/2014/6/24/765
https://lkml.org/lkml/2014/7/1/473
https://lkml.org/lkml/2014/7/4/16

I didn't find this fix in mainline yet, so I thought of sending a note.

Thank you!

Regards,
Srivatsa S. Bhat
 
> Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
> pending IPI callbacks before CPU offline"), which ends up calling
> hotplug_cfd()->flush_smp_call_function_queue()->irq_work_run(), which
> is not from IRQ context.
> 
> And since that already calls irq_work_run() from the hotplug path,
> remove our entire hotplug handling.
> 
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-busatzs2gvz4v62258agipuf@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/irq_work.c | 46 ++++------------------------------------------
>  1 file changed, 4 insertions(+), 42 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 4b0a890..e6bcbe7 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -160,20 +160,14 @@ static void irq_work_run_list(struct llist_head *list)
>  	}
>  }
> 
> -static void __irq_work_run(void)
> -{
> -	irq_work_run_list(&__get_cpu_var(raised_list));
> -	irq_work_run_list(&__get_cpu_var(lazy_list));
> -}
> -
>  /*
> - * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> - * context with local IRQs disabled.
> + * hotplug calls this through:
> + *  hotplug_cfd() -> flush_smp_call_function_queue()
>   */
>  void irq_work_run(void)
>  {
> -	BUG_ON(!in_irq());
> -	__irq_work_run();
> +	irq_work_run_list(&__get_cpu_var(raised_list));
> +	irq_work_run_list(&__get_cpu_var(lazy_list));
>  }
>  EXPORT_SYMBOL_GPL(irq_work_run);
> 
> @@ -189,35 +183,3 @@ void irq_work_sync(struct irq_work *work)
>  		cpu_relax();
>  }
>  EXPORT_SYMBOL_GPL(irq_work_sync);
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -static int irq_work_cpu_notify(struct notifier_block *self,
> -			       unsigned long action, void *hcpu)
> -{
> -	long cpu = (long)hcpu;
> -
> -	switch (action) {
> -	case CPU_DYING:
> -		/* Called from stop_machine */
> -		if (WARN_ON_ONCE(cpu != smp_processor_id()))
> -			break;
> -		__irq_work_run();
> -		break;
> -	default:
> -		break;
> -	}
> -	return NOTIFY_OK;
> -}
> -
> -static struct notifier_block cpu_notify;
> -
> -static __init int irq_work_init_cpu_notifier(void)
> -{
> -	cpu_notify.notifier_call = irq_work_cpu_notify;
> -	cpu_notify.priority = 0;
> -	register_cpu_notifier(&cpu_notify);
> -	return 0;
> -}
> -device_initcall(irq_work_init_cpu_notifier);
> -
> -#endif /* CONFIG_HOTPLUG_CPU */
> 

