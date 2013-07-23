Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab3GWVa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:30:59 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48494 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3GWVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:30:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v4 02/15] DMA: shdma: add r8a7740 DMAC data to the device ID table
Date: Tue, 23 Jul 2013 23:31:43 +0200
Message-ID: <2470310.L1mrPZv1o6@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1307232233190.26199@axis700.grange>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de> <CANqRtoRnMkUjYKp3j2agoN7ufh9DGGbha6xQS8ugibLvK3hGfA@mail.gmail.com> <Pine.LNX.4.64.1307232233190.26199@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Tuesday 23 July 2013 23:19:29 Guennadi Liakhovetski wrote:
> On Wed, 24 Jul 2013, Magnus Damm wrote:
> > On Tue, Jul 23, 2013 at 7:49 PM, Guennadi Liakhovetski wrote:
> > > This configuration data will be re-used, when DMAC DT support is added
> > > to
> > > r8a7740, DMAC platform data in setup-r8a7740.c will be removed.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > > 
> > > v4: make struct sh_dmae_pdata r8a7740_dma_pdata "const"
> > 
> > [snip]
> > 
> > > --- /dev/null
> > > +++ b/drivers/dma/sh/shdma-r8a7740.c
> > > @@ -0,0 +1,95 @@
> > > +#include <linux/sh_dma.h>
> > > +
> > > +#include <mach/dma-register.h>
> > > +#include <mach/r8a7740.h>
> > 
> > Including stuff from <mach/..> isn't really compatible with
> > MULTIPLATFORM,
> 
> Hmm, right. I modeled this arch-specific driver code after Laurent's
> pinctrl driver revamp, which also includes <mach/*.h> headers. So, we'll
> have to think how to fix both.

Just for the record, I've already fixed some of those issues in my tree, and 
I'll work on the remaining ones (three instances of <mach/irqs.h> for the 
irq_pin() macro).

> > so please don't write new code like this. Actually we
> > don't want any code under drivers/ to include stuff from the mach
> > directory.
> 
> Sure, understood.
> 
> > I suggest that you arrange your code in a way so the C version of DMAC
> > support has tables with slave ids as usual under
> > arch/arm/mach-shmobile/, but the DT bits that operate independently of
> > C stay in drivers/... Over time we will get rid of the C version, and
> > until that happens the DT and C version can coexist in parallel.
> 
> That's already how it is. Data, that I took to drivers/dma/sh/ is needed
> for both DT and C. DMA stuff, needed only for C are only DMAC devices and
> resources. I think, I might be able to carry those DMA specific headers
> and defines over from mach/ to drivers/dma/sh. Maybe it would be easier to
> do this in several steps:
> 
> 1. add my drivers/dma/sh/shdma-<arch>.c files *with* mach/ headers
> 2. switch arches over to those files
> (the above two steps are already done in my patch series)
> 3. move headers to drivers/dma/sh
> 
> Ok, alternatively, I might be able to do (1) above without using mach/
> headers at all by directly copying them to drivers/dma/sh/ and then
> removing the original mach/headers in step (2)? I'll look in more detail
> at the code tomorrow.

-- 
Regards,

Laurent Pinchart

