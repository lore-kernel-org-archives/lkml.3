Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaG1Lc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:32:59 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48086 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaG1Lc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:32:58 -0400
Date: Mon, 28 Jul 2014 20:31:08 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] dma/sh: fix rcar-dma.c printk format warnings
Message-ID: <20140728113107.GA7254@verge.net.au>
References: <53D28DAF.9090506@infradead.org>
 <20140726154930.GX8181@intel.com>
 <127874008.l4YYrnQ0HU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <127874008.l4YYrnQ0HU@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replying again using an HTML-free mail client]

On Mon, Jul 28, 2014 at 01:20:59PM +0200, Laurent Pinchart wrote:
> On Saturday 26 July 2014 21:19:30 Vinod Koul wrote:
> > On Fri, Jul 25, 2014 at 10:02:39AM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <rdunlap@infradead.org>
> > > 
> > > Fix printk format warnings by using size_t modifiers ('z'):
> > > 
> > > ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument
> > > of type 'unsigned int', but argument 9 has type 'size_t' [-Wformat=]
> > > ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects
> > > argument of type 'unsigned int', but argument 10 has type 'size_t'
> > > [-Wformat=]
> >
> > This is not present in dmaengine trees. Simon is this in your tree?
> 
> The patch applies to a new driver under development that Simon took in his 
> tree. From what he told me he plans to send a pull request soon.
>  
> > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: dmaengine@vger.kernel.org
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Simon, should I submit a new version that incorporates this change, or do you 
> want to include it in your pull request directly (possibly squashing it in the 
> original commit) ?

Hi Laurent,

sorry for any confusion that I may have caused.
I will see about squashing this change into the original commit.

> > > ---
> > > 
> > >  drivers/dma/sh/rcar-dmac.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> > > ===================================================================
> > > --- linux-next-20140725.orig/drivers/dma/sh/rcar-dmac.c
> > > +++ linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> > > @@ -757,7 +757,7 @@ rcar_dmac_chan_prep_sg(struct rcar_dmac_
> > >  			hwdesc->size = size;
> > >  			
> > >  			dev_dbg(chan->chan.device->dev,
> > > -				"chan%u: hwdesc %p/%p sgl %u@%p, %u/%u %pad -> %pad\n",
> > > +				"chan%u: hwdesc %p/%p sgl %u@%p, %zu/%zu %pad -> %pad\n",
> > >  				chan->index, hwdesc, desc, i, sg, size, len,
> > >  				&hwdesc->src_addr, &hwdesc->dst_addr);
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
