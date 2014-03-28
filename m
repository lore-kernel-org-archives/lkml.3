Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaC1JAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:00:21 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:6463
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750829AbaC1JAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:00:17 -0400
From: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
To: Kevin Hao <haokexin@gmail.com>
CC: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Subject: RE: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
Thread-Topic: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
Thread-Index: AQHPSlkrdAlZt6JjkUqU8iAxPpaIVZr2J+SAgAAIdLA=
Date: Fri, 28 Mar 2014 09:00:13 +0000
Message-ID: <98283b6c8da549479d924d99d2b6d300@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
 <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
In-Reply-To: <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(164054003)(51704005)(24454002)(13464003)(377454003)(95666003)(79102001)(4396001)(54316002)(85306002)(83072002)(98676001)(80976001)(77096001)(56776001)(85852003)(93516002)(46102001)(47736001)(59766001)(77982001)(2656002)(19580405001)(49866001)(19580395003)(76786001)(94946001)(76576001)(20776003)(74502001)(92566001)(74316001)(50986001)(47976001)(87936001)(81816001)(53806001)(97336001)(51856001)(66066001)(97186001)(90146001)(33646001)(87266001)(74706001)(83322001)(47446002)(74876001)(81686001)(76796001)(74366001)(31966008)(81542001)(95416001)(74662001)(56816005)(94316002)(86362001)(65816001)(63696002)(80022001)(81342001)(93136001)(76482001)(54356001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB376;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:F81EFCB5.9A289105.D9D329C3.41246999.2058D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Kevin. Your patch works normal. :)

I still have some confused. I think when __do_softirq always get a interrupt, the hard stack will be run out, isn't it?

Regards,
-Dongsheng

> -----Original Message-----
> From: Kevin Hao [mailto:haokexin@gmail.com]
> Sent: Friday, March 28, 2014 4:18 PM
> To: Wang Dongsheng-B40534
> Cc: fweisbec@gmail.com; James Hogan; Andrew Morton; David S. Miller; Peter
> Zijlstra; Helge Deller; H. Peter Anvin; Heiko Carstens; linux-
> kernel@vger.kernel.org; Paul Mackerras; James E.J. Bottomley; Linus Torvalds;
> Jin Zhengxiong-R64188; Wood Scott-B07421; Thomas Gleixner; linuxppc-
> dev@lists.ozlabs.org; Ingo Molnar; Martin Schwidefsky
> Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature at
> powerpc platform
> 
> On Fri, Mar 28, 2014 at 03:38:32PM +0800, Dongsheng Wang wrote:
> > From: Wang Dongsheng <dongsheng.wang@freescale.com>
> >
> > If softirq use hardirq stack, we will get kernel painc when a hard irq
> > coming again during __do_softirq enable local irq to deal with softirq
> > action. So we need to switch satck into softirq stack when invoke soft irq.
> >
> >  Task--->
> > 	| Task stack
> > 	|
> > 	Interrput->EXCEPTION->do_IRQ->
> > 	^			     | Hard irq stack
> > 	|			     |
> > 	|			     irq_exit->__do_softirq->local_irq_enable--   --
> >local_irq_disable
> > 	|									| Hard irq
> stack
> > 	|									|
> > 	|									Interrupt
> coming again
> > 	|		There will get a Interrupt nesting			|
> >
> > ----------------------------------------------------------------------
> > --
> >
> > Trace 1: Trap 900
> >
> > Kernel stack overflow in process e8152f40, r1=e8e05ec0
> > CPU: 0 PID: 2399 Comm: image_compress/ Not tainted
> > 3.13.0-rc3-03475-g2e3f85b #432
> > task: e8152f40 ti: c080a000 task.ti: ef176000
> > NIP: c05bec04 LR: c0305590 CTR: 00000010
> > REGS: e8e05e10 TRAP: 0901   Not tainted  (3.13.0-rc3-03475-g2e3f85b)
> 
> Could you double check if you got the following patch applied?
> 
> commit 1a18a66446f3f289b05b634f18012424d82aa63a
> Author: Kevin Hao <haokexin@gmail.com>
> Date:   Fri Jan 17 12:25:28 2014 +0800
> 
>     powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack
> 
>     Guenter Roeck has got the following call trace on a p2020 board:
>       Kernel stack overflow in process eb3e5a00, r1=eb79df90
>       CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00
> #4
>       task: eb3e5a00 ti: c0616000 task.ti: ef440000
>       NIP: c003a420 LR: c003a410 CTR: c0017518
>       REGS: eb79dee0 TRAP: 0901   Not tainted (3.13.0-rc8-juniper-00146-g19eca00)
>       MSR: 00029000 <CE,EE,ME>  CR: 24008444  XER: 00000000
>       GPR00: c003a410 eb79df90 eb3e5a00 00000000 eb05d900 00000001 65d87646
> 00000000
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
>       CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00
> #4
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
