Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3GVX3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:29:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42183 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3GVX3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:29:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 08/15] DMA: shdma: move two macros to a header
Date: Tue, 23 Jul 2013 01:30:07 +0200
Message-ID: <1823005.aq6zISvliy@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1307220834520.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de> <3091058.QWyr5HNFKK@avalon> <Pine.LNX.4.64.1307220834520.7852@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Monday 22 July 2013 08:40:42 Guennadi Liakhovetski wrote:
> On Mon, 22 Jul 2013, Laurent Pinchart wrote:
> > On Friday 19 July 2013 18:29:33 Guennadi Liakhovetski wrote:
> > > Move two generic pointer-conversion macros to a header for common shdma
> > > use.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > > 
> > >  drivers/dma/sh/shdma-base.c |    3 ---
> > >  drivers/dma/sh/shdma-of.c   |    2 --
> > >  include/linux/shdma-base.h  |    3 +++
> > >  3 files changed, 3 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
> > > index c5ea256..5b92e72 100644
> > > --- a/drivers/dma/sh/shdma-base.c
> > > +++ b/drivers/dma/sh/shdma-base.c
> > > @@ -36,9 +36,6 @@ enum shdma_desc_status {
> > > 
> > >  #define NR_DESCS_PER_CHANNEL 32
> > > 
> > > -#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > > -#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
> > > -
> > > 
> > >  /*
> > >  
> > >   * For slave DMA we assume, that there is a finite number of DMA slaves
> > >   in
> > > 
> > > the * system, and that each such slave can only use a finite number of
> > > channels. diff --git a/drivers/dma/sh/shdma-of.c
> > > b/drivers/dma/sh/shdma-of.c index 2acf7b6..80d07b5 100644
> > > --- a/drivers/dma/sh/shdma-of.c
> > > +++ b/drivers/dma/sh/shdma-of.c
> > > @@ -17,8 +17,6 @@
> > > 
> > >  #include <linux/platform_device.h>
> > >  #include <linux/shdma-base.h>
> > > 
> > > -#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > > -
> > > 
> > >  static struct dma_chan *shdma_of_xlate(struct of_phandle_args
> > >  *dma_spec,
> > >  
> > >  				       struct of_dma *ofdma)
> > >  
> > >  {
> > > 
> > > diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
> > > index 31cf89f..45191d7 100644
> > > --- a/include/linux/shdma-base.h
> > > +++ b/include/linux/shdma-base.h
> > > @@ -114,6 +114,9 @@ struct shdma_dev {
> > > 
> > >  #define shdma_for_each_chan(c, d, i) for (i = 0, c = (d)->schan[0]; \
> > >  
> > >  				i < (d)->dma_dev.chancnt; c = (d)->schan[++i])
> > > 
> > > +#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > > +#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
> > > +
> > 
> > While you're at it, it might be a good idea to turn the macros into static
> > inline functions. This would help catching type errors at compilation
> > time.
> 
> Doesn't container_of() already catch all the possible type mismatches in
> this case? E.g. to_shdma_chan() can only work for arguments of the same
> type as the .dma_chan member of struct shdma_chan. Similar for
> to_shdma_dev().

Hmmm... You're right. I recall that a static inline would bring additional 
safety compared to directly using container_of() but I can't recall why. Never 
mind then.

> > >  int shdma_request_irq(struct shdma_chan *, int,
> > >  
> > >  			   unsigned long, const char *);
> > >  
> > >  bool shdma_reset(struct shdma_dev *sdev);

-- 
Regards,

Laurent Pinchart

