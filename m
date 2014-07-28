Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaG1LUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:20:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52960 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaG1LUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:20:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Simon Horman <horms@verge.net.au>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] dma/sh: fix rcar-dma.c printk format warnings
Date: Mon, 28 Jul 2014 13:20:59 +0200
Message-ID: <127874008.l4YYrnQ0HU@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140726154930.GX8181@intel.com>
References: <53D28DAF.9090506@infradead.org> <20140726154930.GX8181@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2014 21:19:30 Vinod Koul wrote:
> On Fri, Jul 25, 2014 at 10:02:39AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Fix printk format warnings by using size_t modifiers ('z'):
> > 
> > ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument
> > of type 'unsigned int', but argument 9 has type 'size_t' [-Wformat=]
> > ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects
> > argument of type 'unsigned int', but argument 10 has type 'size_t'
> > [-Wformat=]
>
> This is not present in dmaengine trees. Simon is this in your tree?

The patch applies to a new driver under development that Simon took in his 
tree. From what he told me he plans to send a pull request soon.
 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: dmaengine@vger.kernel.org

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Simon, should I submit a new version that incorporates this change, or do you 
want to include it in your pull request directly (possibly squashing it in the 
original commit) ?

> > ---
> > 
> >  drivers/dma/sh/rcar-dmac.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> > ===================================================================
> > --- linux-next-20140725.orig/drivers/dma/sh/rcar-dmac.c
> > +++ linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> > @@ -757,7 +757,7 @@ rcar_dmac_chan_prep_sg(struct rcar_dmac_
> >  			hwdesc->size = size;
> >  			
> >  			dev_dbg(chan->chan.device->dev,
> > -				"chan%u: hwdesc %p/%p sgl %u@%p, %u/%u %pad -> %pad\n",
> > +				"chan%u: hwdesc %p/%p sgl %u@%p, %zu/%zu %pad -> %pad\n",
> >  				chan->index, hwdesc, desc, i, sg, size, len,
> >  				&hwdesc->src_addr, &hwdesc->dst_addr);

-- 
Regards,

Laurent Pinchart

