Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3GWVUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:20:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129Ab3GWVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:19:59 -0400
Date: Tue, 23 Jul 2013 23:19:29 +0200 (CEST)
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
In-Reply-To: <CANqRtoRnMkUjYKp3j2agoN7ufh9DGGbha6xQS8ugibLvK3hGfA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1307232233190.26199@axis700.grange>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
 <1374576609-27748-3-git-send-email-g.liakhovetski@gmx.de>
 <CANqRtoRnMkUjYKp3j2agoN7ufh9DGGbha6xQS8ugibLvK3hGfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:z529+G29GfT9BEzHfcC/9bVSqWMNKHQ5H7GRRZ7EwSV
 s2vykyU2S8jFrlL/B+MO45nt+ZHeP6aYtKFH/v1MskqeeVEpjl
 ajWtlhK5HyGDBnGOw7X0QM184JXlRCjnzY/CZ9HUlFR+pnDeXO
 83SSqSpI24VOt9GYafd1apCn+MQx34UMXaa+jwQPUOumzYZn7W
 oFh8SWIZzGCOd5kuickJpW4Yo2F9lCYK1unjHle/PLhRtGaopQ
 YRNkh/7edgOowivO06Z/WmQ+Anvig9pOpQo65dYqEOZDJjR+Vf
 b40W5bgZkl65MygPbwIM3R4wWXmSWXRvqwGpw51jv3PqMtKgGP
 4zvRhi9gWElmAkChZokeMsdX2hV0XSHxShdysx/PdyNTdPaQmi
 otk46Fv1obr5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Magnus Damm wrote:

> Hi Guennadi,
> 
> Thanks for your efforts on this.
> 
> On Tue, Jul 23, 2013 at 7:49 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > This configuration data will be re-used, when DMAC DT support is added to
> > r8a7740, DMAC platform data in setup-r8a7740.c will be removed.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> >
> > v4: make struct sh_dmae_pdata r8a7740_dma_pdata "const"
> >
> 
> [snip]
> 
> > --- /dev/null
> > +++ b/drivers/dma/sh/shdma-r8a7740.c
> > @@ -0,0 +1,95 @@
> > +#include <linux/sh_dma.h>
> > +
> > +#include <mach/dma-register.h>
> > +#include <mach/r8a7740.h>
> 
> Including stuff from <mach/..> isn't really compatible with
> MULTIPLATFORM,

Hmm, right. I modeled this arch-specific driver code after Laurent's 
pinctrl driver revamp, which also includes <mach/*.h> headers. So, we'll 
have to think how to fix both.

> so please don't write new code like this. Actually we
> don't want any code under drivers/ to include stuff from the mach
> directory.

Sure, understood.

> I suggest that you arrange your code in a way so the C version of DMAC
> support has tables with slave ids as usual under
> arch/arm/mach-shmobile/, but the DT bits that operate independently of
> C stay in drivers/... Over time we will get rid of the C version, and
> until that happens the DT and C version can coexist in parallel.

That's already how it is. Data, that I took to drivers/dma/sh/ is needed 
for both DT and C. DMA stuff, needed only for C are only DMAC devices and 
resources. I think, I might be able to carry those DMA specific headers 
and defines over from mach/ to drivers/dma/sh. Maybe it would be easier to 
do this in several steps:

1. add my drivers/dma/sh/shdma-<arch>.c files *with* mach/ headers
2. switch arches over to those files
(the above two steps are already done in my patch series)
3. move headers to drivers/dma/sh

Ok, alternatively, I might be able to do (1) above without using mach/ 
headers at all by directly copying them to drivers/dma/sh/ and then 
removing the original mach/headers in step (2)? I'll look in more detail 
at the code tomorrow.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
