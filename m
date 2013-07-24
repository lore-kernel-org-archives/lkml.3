Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3GXIdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:33:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3GXIdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:33:18 -0400
Date: Wed, 24 Jul 2013 10:33:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, SH-Linux <linux-sh@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v4 02/15] DMA: shdma: add r8a7740 DMAC data to the device
 ID table
In-Reply-To: <CANqRtoSdfU=SP+MuOTLenPOHCp17CFLA+OVtjqpAgP7bxMVC=Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1307240953230.30777@axis700.grange>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
 <1374576609-27748-3-git-send-email-g.liakhovetski@gmx.de>
 <CANqRtoRnMkUjYKp3j2agoN7ufh9DGGbha6xQS8ugibLvK3hGfA@mail.gmail.com>
 <Pine.LNX.4.64.1307232233190.26199@axis700.grange>
 <CANqRtoSdfU=SP+MuOTLenPOHCp17CFLA+OVtjqpAgP7bxMVC=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:BAEVS05NO1kwYh920ITz6rQd2O7QT4LI6WdvmelepF8
 V/w2zFKbYm3N6vLDFIG974ytSvuakOQSElp/2h+nei395+3h98
 M7q4n/jNRcTjzUkHurDM35GLTsERvC2zk4jAEuAzhah5o5RbHS
 2gkyHiGQBbD29C3DVQ5cLXXgvGPQQUEKFa8OR1N45s2520y1q6
 3He8IG55rlks7vGCl/ffwK6Ewf/d2WYnCLcfVduALPYiA0pp9Z
 7nZCUtKbibEVrTDGF5iYbw3S9YwaTNcehedo5sOPrrJA+hFawG
 A9P+i464UwI/KB9UhyMvGTulY/5VSPPGTleMviN9GwgsRGNEP2
 6R2Dec2+Vv3T5XIZA9fEXHm+AMfm7W1ax8PjkKQXmiEOqX4mwH
 LpN0f/M3dE57Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Magnus Damm wrote:

> Hi Guennadi,
> 
> On Wed, Jul 24, 2013 at 6:19 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Wed, 24 Jul 2013, Magnus Damm wrote:
> >
> >> Hi Guennadi,
> >>
> >> Thanks for your efforts on this.
> >>
> >> On Tue, Jul 23, 2013 at 7:49 PM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > This configuration data will be re-used, when DMAC DT support is added to
> >> > r8a7740, DMAC platform data in setup-r8a7740.c will be removed.
> >> >
> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> >> > ---
> >> >
> >> > v4: make struct sh_dmae_pdata r8a7740_dma_pdata "const"
> >> >
> >>
> >> [snip]
> >>
> >> > --- /dev/null
> >> > +++ b/drivers/dma/sh/shdma-r8a7740.c
> >> > @@ -0,0 +1,95 @@
> >> > +#include <linux/sh_dma.h>
> >> > +
> >> > +#include <mach/dma-register.h>
> >> > +#include <mach/r8a7740.h>
> >>
> >> Including stuff from <mach/..> isn't really compatible with
> >> MULTIPLATFORM,
> >
> > Hmm, right. I modeled this arch-specific driver code after Laurent's
> > pinctrl driver revamp, which also includes <mach/*.h> headers. So, we'll
> > have to think how to fix both.
> 
> I mentioned this to Laurent when he started converting to PINCTRL, and
> I believe the only remaining bits are the static GPIO-to-IRQ tables.
> 
> >> so please don't write new code like this. Actually we
> >> don't want any code under drivers/ to include stuff from the mach
> >> directory.
> >
> > Sure, understood.
> 
> Good.
> 
> >> I suggest that you arrange your code in a way so the C version of DMAC
> >> support has tables with slave ids as usual under
> >> arch/arm/mach-shmobile/, but the DT bits that operate independently of
> >> C stay in drivers/... Over time we will get rid of the C version, and
> >> until that happens the DT and C version can coexist in parallel.
> >
> > That's already how it is. Data, that I took to drivers/dma/sh/ is needed
> > for both DT and C. DMA stuff, needed only for C are only DMAC devices and
> > resources. I think, I might be able to carry those DMA specific headers
> > and defines over from mach/ to drivers/dma/sh. Maybe it would be easier to
> > do this in several steps:
> >
> > 1. add my drivers/dma/sh/shdma-<arch>.c files *with* mach/ headers
> > 2. switch arches over to those files
> > (the above two steps are already done in my patch series)
> > 3. move headers to drivers/dma/sh
> >
> > Ok, alternatively, I might be able to do (1) above without using mach/
> > headers at all by directly copying them to drivers/dma/sh/ and then
> > removing the original mach/headers in step (2)? I'll look in more detail
> > at the code tomorrow.
> 
> Thanks. My apologies for reviewing your code late in the cycle, but
> I've now looked through this series and the following questions popped
> up:
> 
> 1) How will it look like in DT when a DMA Engine slave device will use DMA?

You have already seen them by now, since you replied to that thread too, 
but just for reference, e.g. for an MMCIF controller here 
http://thread.gmane.org/gmane.linux.ports.sh.devel/25445/focus=25442

+	dmas = <&dmac 0xd1
+		&dmac 0xd2>;
+	dma-names = "tx", "rx";

> 2) Isn't it possible to leave the SHDMA_SLAVE_xx bits to only be used
> by legacy C SoC and board code in arch/arm/mach-shmobile? I don't
> understand why you have to move them over to drivers/... I just assume
> these SHDMA_SLAVE bits won't be used by 1) above.

That's right, those macros aren't used by (1) above, i.e. they aren't used 
in DT. But they are used pretty intensively internally by the driver. The 
C code might be "legacy," but as far as I understand, SuperH will never go 
to DT, so, as long as it has to be supported, we need to support that 
mode. Same for ARM - IIUC, board-*.c (not -reference) files are also still 
quite intensively developed and supported. So, it doesn't look like the C 
version will go any time soon, right?

Based on that I tried to keep the difference between the C and the DT 
versions as small as possible. And that includes keeping slave IDs at 
least internally without changes.

Of course, we can think about changing the driver more extensively and 
leaving those IDs only for the C case, but in fact they don't seem so 
horrifying to me. We have 2 options to keep them while eliminating the use 
of the <mach/<soc>.h> header:
(a) redefine them in the driver
(b) define a single list of slave IDs for all SoCs, AFAICS they don't have 
to be contiguous

> 3) How difficult would it be to describe the information in "struct
> sh_dmae_slave_config" using DT?

Just as difficult as anything else in DT, I presume. Technically it's not 
very difficult, but we'll have to go through all the rounds to define 
proper bindings and once defined, they'll have to be kept, as you know. 
And if in the future we need to change that information we'll have a 
problem. E.g., we could define that array as an array of tuples like

	slaves = <chcr0 midrid0>,
		<chcr1 midrid1>,
		...;

but that would mean we'll never be able to add a third element to them. 
Whereas if kept in C as now, the full flexibility is preserved. So, I 
would really prefer to only push into DT things, for which standard 
bindings are defined, or those, which we absolutely need there. 
Information, that is SoC specific and not standard I'd rather keep in C.

> 4) It seems that some patches in this series are unrelated. Can you
> submit 4/15 and 9/15 from v4 independently somehow?

4/15 is required to avoid a compiler warning. 9/15 can be submitted 
separately, but it depends on this patch-series, so, it would be easier to 
keep them all together.

> 5) Reducing and extending (reducing is optional of course)
> 
> At this point you cover r8a7740, r8a73a0 and r8a73a4. I'm not sure why
> your picked those 3 SoCs,

That's simple: because I can test them.

> but perhaps it would be a good idea to
> select a single SoC to begin with but extend the support to also
> provide DT code that makes use of DMA Engine in slave devices like for
> instance MMCIF (this would cover question 1) above).

I did, as you know by now.

> When we have
> agreed on the big picture then additional SoCs can easily be added
> later.
> 
> 6) Remove untested bits
> 
> And while doing this conversion, perhaps this is a good opportunity to
> only move over DMA Engine slaves that can be tested? Having tons of
> unused DMA configuration seems overly heavy to me. If it's not tested
> then it's broken.

Tested in general or tested by me? I am sure other developers, that added 
support for various interfaces like audio would be better able to test 
them than me. And since I'm actually migrating platforms to this in-driver 
code, dropping any slaves would actually be a regression. If really 
wanted, that would have to go via the standard deprecation process, right? 
E.g., I can well imagine that noone is actually using DMA on SCIF* serial 
interfaces on sh73a0, but removing them should probably be done as a 
separate patch-set.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
