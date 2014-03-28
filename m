Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaC1Vfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:35:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:55073 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaC1Vfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:35:40 -0400
Message-ID: <1396042027.11529.24.camel@pasglop>
Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kevin Hao <haokexin@gmail.com>
Cc: Dongsheng Wang <dongsheng.wang@freescale.com>, fweisbec@gmail.com,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@au1.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jason.jin@freescale.com, scottwood@freescale.com,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Sat, 29 Mar 2014 08:27:07 +1100
In-Reply-To: <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
	 <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 16:18 +0800, Kevin Hao wrote:

>     powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack
>    

Kevin. It looks like it was applied to 3.14 and sent to 3.12 stable but
not 3.13 ... can you fix that up ?

Cheers,
Ben.

>     Guenter Roeck has got the following call trace on a p2020 board:
>       Kernel stack overflow in process eb3e5a00, r1=eb79df90
>       CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
>       task: eb3e5a00 ti: c0616000 task.ti: ef440000
>       NIP: c003a420 LR: c003a410 CTR: c0017518
>       REGS: eb79dee0 TRAP: 0901   Not tainted (3.13.0-rc8-juniper-00146-g19eca00)
>       MSR: 00029000 <CE,EE,ME>  CR: 24008444  XER: 00000000
>       GPR00: c003a410 eb79df90 eb3e5a00 00000000 eb05d900 00000001 65d87646 00000000
>       GPR08: 00000000 020b8000 00000000 00000000 44008442
>       NIP [c003a420] __do_softirq+0x94/0x1ec
>       LR [c003a410] __do_softirq+0x84/0x1ec
>       Call Trace:
>       [eb79df90] [c003a410] __do_softirq+0x84/0x1ec (unreliable)
>       [eb79dfe0] [c003a970] irq_exit+0xbc/0xc8
>       [eb79dff0] [c000cc1c] call_do_irq+0x24/0x3c
>       [ef441f20] [c00046a8] do_IRQ+0x8c/0xf8
>       [ef441f40] [c000e7f4] ret_from_except+0x0/0x18
>       --- Exception: 501 at 0xfcda524
>           LR = 0x10024900
>       Instruction dump:
>       7c781b78 3b40000a 3a73b040 543c0024 3a800000 3b3913a0 7ef5bb78 48201bf9
>       5463103a 7d3b182e 7e89b92e 7c008146 <3ba00000> 7e7e9b78 48000014 57fff87f
>       Kernel panic - not syncing: kernel stack overflow
>       CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
>       Call Trace:
>     
>     The reason is that we have used the wrong register to calculate the
>     ksp_limit in commit cbc9565ee826 (powerpc: Remove ksp_limit on ppc64).
>     Just fix it.
>     
>     As suggested by Benjamin Herrenschmidt, also add the C prototype of the
>     function in the comment in order to avoid such kind of errors in the
>     future.
>     
>     Cc: stable@vger.kernel.org # 3.12
>     Reported-by: Guenter Roeck <linux@roeck-us.net>
>     Tested-by: Guenter Roeck <linux@roeck-us.net>
>     Signed-off-by: Kevin Hao <haokexin@gmail.com>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Thanks,
> Kevin


