Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaHKWdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:33:25 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:42836 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaHKWdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:33:24 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
References: <5bf77c903d6df6cfe656a3585c314df1@mail.gmail.com> <53E94382.1010203@caviumnetworks.com>
In-Reply-To: <53E94382.1010203@caviumnetworks.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIwUxAAXDA+CKhynaeDnWuLA4wPqwGi+1HXmv2qXVA=
Date: Mon, 11 Aug 2014 15:33:17 -0700
Message-ID: <eedac437fcb12ece914ccb716c3d4cb9@mail.gmail.com>
Subject: RE: [PATCH] delaying interrupts in mips [ 2.6.32]
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, david.daney@cavium.com,
        shaiju_sada@yahoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Sorry  ,  I  didn't  check  that  .  I  am late  in submitting  it .

Regards,
Shaiju.

-----Original Message-----
From: David Daney [mailto:ddaney@caviumnetworks.com]
Sent: Monday, August 11, 2014 3:28 PM
To: Sadasivan Shaiju
Cc: linux-kernel@vger.kernel.org; ralf@linux-mips.org;
david.daney@cavium.com; shaiju_sada@yahoo.com
Subject: Re: [PATCH] delaying interrupts in mips [ 2.6.32]

On 08/11/2014 03:13 PM, Sadasivan Shaiju wrote:
> Hi ,
>
> I  work for Montavista (Cavium Inc) as  a  Technical  Lead .  I want
> to push some  of the kernel  patches to  rt community (2.6.32 kernel
> 2.6.33 rt patch)  , so  that  It  will  go  to  the  main line These
> patches  are reviewed  and approved  by  our system Architect.  I
> request  you to include  in the main line .

It is already in the "main line":

commit 1bcfecc028686ea32e49b0f4f6e8a665917cb49a
Author: Yong Zhang <yong.zhang@windriver.com>
Date:   Thu Jul 19 09:13:53 2012 +0200

     MIPS: Octeon: delay enable irq to ->smp_finish()

     To prepare for smoothing set_cpu_[active|online]() mess up

     Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
     Cc: Sergei Shtylyov <sshtylyov@mvista.com>
     Cc: David Daney <david.daney@cavium.com>
     Acked-by: David Daney <david.daney@cavium.com>
     Patchwork: https://patchwork.linux-mips.org/patch/3845/
     Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Why are you sending it again?

David Daney



   These  issues  were  reported  by our
> customer CISCO .
>
> Problem Description:
> When CONFIG_DEBUG_PREEMPT is enabled the following stack trace occurs.
>
> [ 170.814470] BUG: using smp_processor_id() in preemptible [00000000]
> code: sirq-timer/4/62
> [ 170.814482] caller is hrtimer_run_pending+0x10/0x20 [ 170.814488]
> Call Trace:
> [ 170.814496] [<ffffffff8010d844>] dump_stack+0x8/0x34 [ 170.814507]
> [<ffffffff803c2598>] debug_smp_processor_id+0xe0/0xf0 [ 170.814517]
> [<ffffffff80254158>] hrtimer_run_pending+0x10/0x20 [ 170.814528]
> [<ffffffff80242400>] run_timer_softirq+0x60/0x348 [ 170.814539]
> [<ffffffff8023ae80>] run_ksoftirqd+0x1c8/0x348 [ 170.814550]
> [<ffffffff802503f8>] kthread+0x88/0x90 [ 170.814561]
> [<ffffffff80206c80>] kernel_thread_helper+0x10/0x18
>
> Root Cause:
> Interrupt was occurring before the processor was completely up, and
> the softirq threads were unable to schedule on the processor and then
> ran on the wrong CPU.
>
> How Solved:
> Enabling of interrupt has been delayed till smp_finish so that
> kthread_bind can safely bind threads to any possible CPU.
>
> I request you  to merge  the above patch  to the  main line .  If  any
> questions please contact me atsshaiju@mvista.com
> (shaiju_sada@yahoo.com)
>
> Regards,
> Shaiju.
>
>
> 0001-Interrupt-delaying-enabling-of-interrupt.patch
>
>
>  From 58512475cba93003c23f2b380b573e64eebcabd5 Mon Sep 17 00:00:00
> 2001
> From: Sadasivan Shaiju<sshaiju@mvista.com>
> Date: Mon, 20 Feb 2012 13:25:50 -0800
> Subject: [PATCH] Interrupt : delaying enabling of interrupt
>
> Source: MontaVista Software, LLC
> MR: 47157
> Type: Defect Fix
> Disposition: Local
> ChangeID: 48c837329556b161f3111e6fded1c9857fa3a149
> Description:
>
> This patch is to delay the enabling of interrupt till smp_finish . So
> that kthread_bind can safely bind threads to any possible cpu. Without
> this change interrupt should occur beofre  the  processor was
> completely up, and  the softirq threads were unable to schedule on the
> processor and  then  ran on the wrong CPU.
>
> Signed-off-by: Sadasivan Shaiju<sshaiju@mvista.com>
> ---
>   arch/mips/cavium-octeon/smp.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c
> b/arch/mips/cavium-octeon/smp.c index ff21542..c7de7ac 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -308,7 +308,6 @@ static void octeon_init_secondary(void)
>   	octeon_init_cvmcount();
>
>   	octeon_irq_setup_secondary();
> -	raw_local_irq_enable();
>   }
>
>   /**
> @@ -365,6 +364,8 @@ static void octeon_smp_finish(void)
>
>   	/* to generate the first CPU timer interrupt */
>   	write_c0_compare(read_c0_count() + mips_hpt_frequency / HZ);
> +	/* enable local interrupts */
> +	raw_local_irq_enable();
>   }
>
>   /**
> -- 1.7.0.1
