Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaIBO6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:58:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27288 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaIBO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:58:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GCeKPj8dwm8u/TGCkF0nukmU3YrOmF3A=
X-DKIM: OpenDKIM Filter v2.0.1 titan 77FC95D5B1C
Date: Tue, 2 Sep 2014 10:58:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140902145831.GB30467@titan.lakedaemon.net>
References: <20140901230728.GM29327@sirena.org.uk>
 <1627064.QhxvejlWdk@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627064.QhxvejlWdk@amdc1032>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher,

On Tue, Sep 02, 2014 at 03:19:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> [ this time with the patch and right cc: list, sorry for the noise ]
> 
> Hi,
> 
> On Tuesday, September 02, 2014 12:07:28 AM Mark Brown wrote:
> > Changes since 20140829:
> > 
> > The akpm-current gained a conflict against Linus' tree.
> > 
> > Non-merge commits (relative to Linus' tree): 2553
> >  2686 files changed, 98625 insertions(+), 79475 deletions(-)
> > 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git .
> > If you are tracking the linux-next tree using git, you should not use
> > "git pull" to do so as that will try to merge the new linux-next release
> > with the old one.  You should use "git fetch" and checkout or reset to
> > the new master.
> > 
> > You can see which trees have been included by looking in the Next/Trees
> > file in the source.  There are also quilt-import.log and merge.log files
> > in the Next directory.  Between each merge, the tree was built with an
> > allmodconfig for x86_64 and a multi_v7_defconfig for arm.
> > 
> > Below is a summary of the state of the merge.
> > 
> > I am currently merging 214 trees (counting Linus' and 30 trees of patches
> > pending for Linus' tree).
> > 
> > Stats about the size of the tree over time can be seen at
> > http://neuling.org/linux-next-size.html .
> > 
> > Status of Stephen's local build tests will be at
> > http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> I need following patch to make it boot on ODROID U3 board
> (ARM Exynos4412 SoC based).  next-20140825 was good, next-20140828
> is bad (I haven't tried next-20140826 and next-20140827).
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [RFC PATCH] irqchips: gic_get_percpu_base() fix
> 
> Commit 532d0d0690d1 ("irqchips: Replace __this_cpu_ptr uses")
> incorrectly converted *__this_cpu_ptr() to raw_cpu_read() instead
> of *raw_cpu_ptr().  Fix it.

Why were Thomas and I not Cc'd on a patch affecting irq-gic.c?

thx,


Jason.

> 
> Fixes following panic on ODROID U3 board (using ARM Exynos4412 SoC):
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000004
> pgd = c0004000
> [00000004] *pgd=00000000
> Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc2-next-20140828-dirty #837
> task: c05ece28 ti: c05e2000 task.ti: c05e2000
> PC is at gic_init_bases+0x170/0x380
> LR is at gic_init_bases+0x170/0x380
> pc : [<c05b12bc>]    lr : [<c05b12bc>]    psr: 600001d3
> sp : c05e3f18  ip : 00000004  fp : c05edd7c
> r10: c05ea560  r9 : c05ea488  r8 : 00000010
> r7 : 00004000  r6 : c05ea93c  r5 : c05ea93c  r4 : c05ea93c
> r3 : 2a1a0000  r2 : ffffffff  r1 : 00000008  r0 : 00000000
> Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 4000404a  DAC: 00000015
> Process swapper/0 (pid: 0, stack limit = 0xc05e2240)
> Stack: (0xc05e3f18 to 0xc05e4000)
> 3f00:                                                       c05e3f88 c040b2bc
> 3f20: c061c3b8 ffffffff 00000004 c05e3f64 00000000 ea7a3b20 c05c5ff0 00000000
> 3f40: f8820000 f8810000 c05de880 00200200 c05e3f88 c05b157c 00004000 ea7a3b20
> 3f60: c061c3b8 00004000 ea0027c0 ea002800 c05e3f80 00000000 00100100 c05b89c8
> 3f80: ea002800 ea002800 c05e3f88 c05e3f88 413fc090 c05c3f50 ffffffff c0626600
> 3fa0: c05c3f60 eb7ff780 413fc090 00000000 00000000 c05a2e80 c05c3f50 c059e1c4
> 3fc0: 00000001 c059ba24 ffffffff ffffffff c059b600 00000000 00000000 c05c3f60
> 3fe0: c06269d4 c05ea47c c05c3f5c c05edeac 4000406a 40008074 00000000 00000000
> [<c05b12bc>] (gic_init_bases) from [<c05b157c>] (gic_of_init+0xb0/0x118)
> [<c05b157c>] (gic_of_init) from [<c05b89c8>] (of_irq_init+0x164/0x29c)
> [<c05b89c8>] (of_irq_init) from [<c05a2e80>] (exynos_init_irq+0x8/0x50)
> [<c05a2e80>] (exynos_init_irq) from [<c059e1c4>] (init_IRQ+0x24/0x74)
> [<c059e1c4>] (init_IRQ) from [<c059ba24>] (start_kernel+0x200/0x384)
> [<c059ba24>] (start_kernel) from [<40008074>] (0x40008074)
> Code: e59f61d8 e5953594 e1a00006 e12fff33 (e5907004) 
> ---[ end trace cb88537fdc8fa200 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: nicolas.pitre@linaro.org
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
> I'm not sure that it is a correct fix but some other *__this_cpu_ptr()
> usages were not converted to raw_cpu_read() but also to *raw_cpu_ptr()
> (like arch_local_irqs_enabled() in arch/tile/include/asm/irqflags.h).
> 
>  drivers/irqchip/irq-gic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/irqchip/irq-gic.c
> ===================================================================
> --- a/drivers/irqchip/irq-gic.c	2014-09-02 14:03:41.026758653 +0200
> +++ b/drivers/irqchip/irq-gic.c	2014-09-02 14:37:04.466811546 +0200
> @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
>  #ifdef CONFIG_GIC_NON_BANKED
>  static void __iomem *gic_get_percpu_base(union gic_base *base)
>  {
> -	return raw_cpu_read(base->percpu_base);
> +	return *raw_cpu_ptr(base->percpu_base);
>  }
>  
>  static void __iomem *gic_get_common_base(union gic_base *base)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
