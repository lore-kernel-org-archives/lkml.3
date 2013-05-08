Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3EHEA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:00:27 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51577 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3EHEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:00:23 -0400
Date: Wed, 8 May 2013 09:54:26 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH/RFC 0/6] DMA: shdma: add Device Tree support
Message-ID: <20130508005426.GA23419@verge.net.au>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1305020936400.17181@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1305020936400.17181@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:47:52AM +0200, Guennadi Liakhovetski wrote:
> Hi Chris, Simon, Vinod (in alphabetical order :-) )
> 
> On Thu, 11 Apr 2013, Guennadi Liakhovetski wrote:
> 
> > This patch series adds Device Tree support to the shdma dmaengine driver 
> > and illustraits its use with the kzm9g-reference board's MMCIF interface.
> 
> Formally patches in this series belong to your 3 trees: 1-3 and 7 
> (documentation, sent later separately) to DMA, 4 and 6 to ARM/shmobile, 5 
> to MMC. However, they can actually be safely applied in any order, as long 
> as per-tree patches are kept together. Even if the DMA portion is applied 
> last, the MMC driver will find DMA DT bindings in the DT, will request 
> channels, but no DMA channels will be found, then the driver will fall 
> back to PIO.
> 
> So, it's up to you to decide, whether to pull these patches separately via 
> respective trees, or have some of them acked and push all of them via one 
> tree.

Hi Guennadi, Hi all,

I apologise for not replying earlier.

I am happy to take these changes through my renesas tree and
request they be pulled into the arm-soc tree provided that there
are acks from Vinod and Chris on the relevant patches.

I am also happy for either Chris or Vinod to take the patches.

To that end, for the two smhobile patches below:

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> Thanks
> Guennadi
> 
> > Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > 
> > Guennadi Liakhovetski (6):
> >   DMA: shdma: (cosmetic) don't re-calculate a pointer
> >   DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
> >   DMA: shdma: add DT support
> >   ARM: shmobile: sh73a0: add support for the DMA0 controller in DT
> >   mmc: sh_mmcif: add support for Device Tree DMA bindings
> >   ARM: shmobile: kzm9g-reference: add DMA channels to the MMCIF DT
> > 
> >  arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |    3 ++
> >  arch/arm/boot/dts/sh73a0.dtsi                |   36 ++++++++++++++++++
> >  arch/arm/mach-shmobile/setup-sh73a0.c        |    4 ++
> >  drivers/dma/sh/shdma-base.c                  |   51 +++++++++++++++++++++++---
> >  drivers/dma/sh/shdma.c                       |   46 ++++++++++++++++++++----
> >  drivers/mmc/host/sh_mmcif.c                  |   29 +++++++++------
> >  include/linux/sh_dma.h                       |    2 -
> >  include/linux/shdma-base.h                   |    6 +++
> >  8 files changed, 151 insertions(+), 26 deletions(-)
> > 
> > -- 
> > 1.7.2.5
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
