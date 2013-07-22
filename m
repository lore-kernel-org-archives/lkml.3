Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab3GVQRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:17:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab3GVQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:17:42 -0400
Date: Mon, 22 Jul 2013 08:40:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 08/15] DMA: shdma: move two macros to a header
In-Reply-To: <3091058.QWyr5HNFKK@avalon>
Message-ID: <Pine.LNX.4.64.1307220834520.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
 <1374251374-30186-9-git-send-email-g.liakhovetski@gmx.de> <3091058.QWyr5HNFKK@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:/exYYVLvXaKreNreof2Qegyky3oVBfOa63HXpNDpC/s
 Q2FdYLRYmrh3O5UN6vrPNYACN4pj5UYzj4HaFVtuJFUv3CFZdR
 qWc6iprmP4vZHPawxYQfQpSsjjbvkVQ7OENM00RPXVbo5xsmTj
 e4iGafxAGMftVLMP7BElncRDlqeQbLwBlcT0gcWT/r6ST1Wjf5
 wBQgNYy5S8qOe8bqPvE4T0rP1h8Ra5cUO2qqPcnznZm+zdS2RV
 3NSe7kLQ09lMzwVm/GcctTmwdSQN3gGC/osznUmjtI7vmdVH7z
 4rnyg+Qa8lzybc3mWHu/DM/5SoO64BXvnM5J3QId+aU9JT4cHn
 o/CzuCJeNO39JvEDKXD5limoboSFiZ383AR3402JFnPbOQhOLx
 dO1yL3QzzSU2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent

On Mon, 22 Jul 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Friday 19 July 2013 18:29:33 Guennadi Liakhovetski wrote:
> > Move two generic pointer-conversion macros to a header for common shdma use.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> >  drivers/dma/sh/shdma-base.c |    3 ---
> >  drivers/dma/sh/shdma-of.c   |    2 --
> >  include/linux/shdma-base.h  |    3 +++
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
> > index c5ea256..5b92e72 100644
> > --- a/drivers/dma/sh/shdma-base.c
> > +++ b/drivers/dma/sh/shdma-base.c
> > @@ -36,9 +36,6 @@ enum shdma_desc_status {
> > 
> >  #define NR_DESCS_PER_CHANNEL 32
> > 
> > -#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > -#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
> > -
> >  /*
> >   * For slave DMA we assume, that there is a finite number of DMA slaves in
> > the * system, and that each such slave can only use a finite number of
> > channels. diff --git a/drivers/dma/sh/shdma-of.c
> > b/drivers/dma/sh/shdma-of.c index 2acf7b6..80d07b5 100644
> > --- a/drivers/dma/sh/shdma-of.c
> > +++ b/drivers/dma/sh/shdma-of.c
> > @@ -17,8 +17,6 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/shdma-base.h>
> > 
> > -#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > -
> >  static struct dma_chan *shdma_of_xlate(struct of_phandle_args *dma_spec,
> >  				       struct of_dma *ofdma)
> >  {
> > diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
> > index 31cf89f..45191d7 100644
> > --- a/include/linux/shdma-base.h
> > +++ b/include/linux/shdma-base.h
> > @@ -114,6 +114,9 @@ struct shdma_dev {
> >  #define shdma_for_each_chan(c, d, i) for (i = 0, c = (d)->schan[0]; \
> >  				i < (d)->dma_dev.chancnt; c = (d)->schan[++i])
> > 
> > +#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
> > +#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
> > +
> 
> While you're at it, it might be a good idea to turn the macros into static 
> inline functions. This would help catching type errors at compilation time.

Doesn't container_of() already catch all the possible type mismatches in 
this case? E.g. to_shdma_chan() can only work for arguments of the same 
type as the .dma_chan member of struct shdma_chan. Similar for 
to_shdma_dev().

Thanks
Guennadi

> >  int shdma_request_irq(struct shdma_chan *, int,
> >  			   unsigned long, const char *);
> >  bool shdma_reset(struct shdma_dev *sdev);
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
