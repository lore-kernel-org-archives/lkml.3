Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaIKKY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:24:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51808 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaIKKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:24:25 -0400
X-AuditID: cbfee61a-f79e46d00000134f-dc-541178578519
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Christoph Lameter <cl@linux.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Date: Thu, 11 Sep 2014 12:24:20 +0200
Message-id: <3042750.N601vfolIq@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <alpine.LFD.2.11.1409101356270.16533@knanqh.ubzr>
References: <20140901230728.GM29327@sirena.org.uk>
 <20140910174141.GH12361@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1409101356270.16533@knanqh.ubzr>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd3wCsEQg0PT1CymPnzCZnH92xtG
	i94FV9kszja9Ybe4vGsOm8XBhW2MFrcv81r8vfOPzeLTs3/sFr+WH2V04PJYM28No0dLcw+b
	x6ZVnWwed67tYfN4cmU6k0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBl3N+3lb1gs2bFvDm3
	GRsYu+W6GDk5JARMJJYcvcwOYYtJXLi3nq2LkYtDSGARo8TK7begnBYmiT8/3jGCVLEJWElM
	bF8FZosI6EgcnfmaGaSIWeAkk0Rv2xmwUcIC6hKHZ64Bs1kEVCWaWj8BFXFw8ApoStzYIgYS
	FhXwlNixfSUbiM0pYCfxYvZEZohlMxglXkz4zgSS4BUQlPgx+R4LiM0sIC+xb/9UVghbS2Lz
	tibWCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZHxTGoH48oG
	i0OMAhyMSjy8FSyCIUKsiWXFlbmHGCU4mJVEeEsLgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7RaBwoJpCeWpGanphakFsFkmTg4pRoY67N3HZqffNNk5fNFv0pSy05+23C87ZhS5q917IVb
	dmd3zJk19YPwCa3QgPLomBxvR97+Ug+TD7IulVEmx2adbbv77c3j485nOyNYPkUuFpuvEXDP
	rWbZJz7Nc7zM6ss/vyr5e3fqrN3VzXeFL9y+ukWkiYs56+DS2R+/e/BMPPR+g4Ti2+CsFUos
	xRmJhlrMRcWJAMSAG2KIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, September 10, 2014 01:59:47 PM Nicolas Pitre wrote:
> On Wed, 10 Sep 2014, Russell King - ARM Linux wrote:
> 
> > On Fri, Sep 05, 2014 at 03:27:51PM -0400, Nicolas Pitre wrote:
> > > On Tue, 2 Sep 2014, Christoph Lameter wrote:
> > > 
> > > > On Tue, 2 Sep 2014, Christoph Lameter wrote:
> > > > 
> > > > > Oww.. This is double indirection deal there. A percpu offset pointing to
> > > > > a pointer?
> > > > >
> > > > > Generally the following is true (definition from
> > > > > include/asm-generic/percpu.h that is used for ARM for raw_cpu_read):
> > > > >
> > > > > #define raw_cpu_read_4(pcp)             (*raw_cpu_ptr(&(pcp)))
> > > > 
> > > > I think what the issue is that we dropped the fetch of the percpu offset
> > > > in the patch. Instead we are using the address of the variable that
> > > > contains the offset. Does this patch fix it?
> > > > 
> > > > 
> > > > Subject: irqchip: Properly fetch the per cpu offset
> > > > 
> > > > The raw_cpu_read() conversion dropped the fetch of the offset
> > > > from base->percpu_base in gic_get_percpu_base.
> > > > 
> > > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > > > 
> > > > Index: linux/drivers/irqchip/irq-gic.c
> > > > ===================================================================
> > > > --- linux.orig/drivers/irqchip/irq-gic.c
> > > > +++ linux/drivers/irqchip/irq-gic.c
> > > > @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> > > >  #ifdef CONFIG_GIC_NON_BANKED
> > > >  static void __iomem *gic_get_percpu_base(union gic_base *base)
> > > >  {
> > > > -	return raw_cpu_read(base->percpu_base);
> > > > +	return raw_cpu_read(*base->percpu_base);
> > > 
> > > Isn't the pointer dereference supposed to be performed _outside_ the per 
> > > CPU accessor?
> > 
> > I think this is correct.
> > 
> > Let's start from the depths of raw_cpu_read(), where the pointer is
> > verified to be the correct type:
> > 
> > #define __verify_pcpu_ptr(ptr)                                          \
> > do {                                                                    \
> >         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
> >         (void)__vpp_verify;                                             \
> > } while (0)
> > 
> > So, "ptr" should be of type "const void __percpu *" (note the __percpu
> > annotation there, which makes it sparse-checkable.)
> > 
> > The next level up is this:
> > 
> > #define __pcpu_size_call_return(stem, variable)                         \
> > ({                                                                      \
> >         typeof(variable) pscr_ret__;                                    \
> >         __verify_pcpu_ptr(&(variable));                                 \
> > 
> > So, we pass the address of the variable to the verification function.
> > That makes it a void-typed variable - "const void __percpu".
> > 
> > #define raw_cpu_read(pcp)   __pcpu_size_call_return(raw_cpu_read_, pcp)
> > 
> > So this also makes "pcp" a "const void __percpu".
> > 
> > Now, what type is base->percpu_base?
> > 
> >         void __percpu * __iomem *percpu_base;
> > 
> > The thing we want to be per-cpu is a "void __iomem *" pointer.  However,
> > we have a pointer to the per-cpu instance.  That's the "void __percpu *"
> > bit.
> > 
> > So, for this to match the requirements for raw_cpu_read(), we need to
> > do one dereference to end up with "void __percpu".
> > 
> > Hence, to me, the patch looks correct.
> 
> Good, I now agree.  If needed:
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> 
> > Whether it works or not is a /completely/ different matter.  As has been
> > pointed out, the only place this code gets used is on a very small number
> > of platforms, which I don't have, and that gives me zero way to test it.
> > If it's Exynos which is affected by this, we need to call on Samsung to
> > test this patch.
> 
> AFAICS it was tested already and confirmed working.

Yes, it was tested on ODROID U3 board (ARM Exynos4412 SoC based):

https://lkml.org/lkml/2014/9/3/552

FWIW:

Tested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> > Now, this code was introduced by Marc Zyngier in order to support Exynos,
> > probably the result of another patch on the mailing list from Samsung.
> > (I've added Marc and another Samsung guy to the Cc list.)  Whatever,
> > *someone* needs to verify this but it needs to be done with the affected
> > hardware.  Whether Marc can, or whether it has to be someone from Samsung,
> > I don't care which.
> > 
> > /Or/ we deem the code unmaintained, broken, and untestable, and we start
> > considering ripping it out of the mainline kernel on the basis that no
> > one cares about it anymore.
> 
> The problem was reported by someone who tested linux-next on the 
> affected platform, so it must still be used.

Yes, the issue was reported by me originally together with a proposed fix
(different than the final one done by Christoph):

https://lkml.org/lkml/2014/9/2/261

FWIW:

Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

