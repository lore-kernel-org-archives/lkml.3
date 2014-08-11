Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaHKW23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:28:29 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:20378
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753056AbaHKW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:28:28 -0400
Message-ID: <53E94382.1010203@caviumnetworks.com>
Date: Mon, 11 Aug 2014 15:28:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sadasivan Shaiju <sshaiju@mvista.com>
CC: <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <david.daney@cavium.com>, <shaiju_sada@yahoo.com>
Subject: Re: [PATCH] delaying interrupts in mips [ 2.6.32]
References: <5bf77c903d6df6cfe656a3585c314df1@mail.gmail.com>
In-Reply-To: <5bf77c903d6df6cfe656a3585c314df1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BN1PR07CA0037.namprd07.prod.outlook.com (10.255.193.12) To
 CO2PR07MB587.namprd07.prod.outlook.com (10.141.229.150)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(377454003)(288314003)(479174003)(189002)(5423002)(199002)(50944004)(51704005)(31966008)(69596002)(85306004)(83322001)(50466002)(102836001)(20776003)(575784001)(76482001)(64126003)(81156004)(46102001)(74502001)(47776003)(64706001)(19580395003)(66066001)(99396002)(42186005)(87976001)(81542001)(65806001)(80316001)(92566001)(87266999)(74662001)(80022001)(19580405001)(65956001)(65816999)(105586002)(76176999)(101416001)(110136001)(50986999)(54356999)(106356001)(23676002)(33656002)(92726001)(107046002)(81342001)(21056001)(4396001)(53416004)(59896001)(77982001)(95666004)(77096002)(83506001)(15975445006)(36756003)(83072002)(85852003)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:CO2PR07MB587;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 03:13 PM, Sadasivan Shaiju wrote:
> Hi ,
>
> I  work for Montavista (Cavium Inc) as  a  Technical  Lead .  I want to
> push some  of the kernel  patches to  rt community (2.6.32 kernel 2.6.33
> rt patch)  , so  that  It  will  go  to  the  main line These patches  are
> reviewed  and approved  by  our system Architect.  I request  you to
> include  in the main line .

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
> [ 170.814482] caller is hrtimer_run_pending+0x10/0x20
> [ 170.814488] Call Trace:
> [ 170.814496] [<ffffffff8010d844>] dump_stack+0x8/0x34
> [ 170.814507] [<ffffffff803c2598>] debug_smp_processor_id+0xe0/0xf0
> [ 170.814517] [<ffffffff80254158>] hrtimer_run_pending+0x10/0x20
> [ 170.814528] [<ffffffff80242400>] run_timer_softirq+0x60/0x348
> [ 170.814539] [<ffffffff8023ae80>] run_ksoftirqd+0x1c8/0x348
> [ 170.814550] [<ffffffff802503f8>] kthread+0x88/0x90
> [ 170.814561] [<ffffffff80206c80>] kernel_thread_helper+0x10/0x18
>
> Root Cause:
> Interrupt was occurring before the processor was completely up, and the
> softirq
> threads were unable to schedule on the processor and then ran on the wrong
> CPU.
>
> How Solved:
> Enabling of interrupt has been delayed till smp_finish so that
> kthread_bind
> can safely bind threads to any possible CPU.
>
> I request you  to merge  the above patch  to the  main line .  If  any
> questions please contact me atsshaiju@mvista.com  (shaiju_sada@yahoo.com)
>
> Regards,
> Shaiju.
>
>
> 0001-Interrupt-delaying-enabling-of-interrupt.patch
>
>
>  From 58512475cba93003c23f2b380b573e64eebcabd5 Mon Sep 17 00:00:00 2001
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
> This patch is to delay the enabling of interrupt till
> smp_finish . So that kthread_bind can safely bind
> threads to any possible cpu. Without this change
> interrupt should occur beofre  the  processor was
> completely up, and  the softirq threads were unable
> to schedule on the processor and  then  ran on the
> wrong CPU.
>
> Signed-off-by: Sadasivan Shaiju<sshaiju@mvista.com>
> ---
>   arch/mips/cavium-octeon/smp.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index ff21542..c7de7ac 100644
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

