Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3FSRwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:52:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:19530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab3FSRwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="356292841"
Date: Wed, 19 Jun 2013 10:52:06 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
Message-ID: <20130619175206.GA20737@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
 <1371602813-19828-3-git-send-email-jon.mason@intel.com>
 <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 05:59:59PM -0700, Dan Williams wrote:
> On Tue, Jun 18, 2013 at 5:46 PM, Jon Mason <jon.mason@intel.com> wrote:
> > Set the DMA_PRIVATE dma_transaction_type in the capability mask.  This
> > enables the ability to get an exclusive ioatdma DMA channel for any
> > devices that requests one via the dma_request_channel function call.
> >
> > Signed-off-by: Jon Mason <jon.mason@intel.com>
> > Acked-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  drivers/dma/ioat/dma_v3.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> > index ca6ea9b..ac2aeef 100644
> > --- a/drivers/dma/ioat/dma_v3.c
> > +++ b/drivers/dma/ioat/dma_v3.c
> > @@ -1883,6 +1883,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
> >                 dma->copy_align = 6;
> >
> >         dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
> > +       dma_cap_set(DMA_PRIVATE, dma->cap_mask);
> >         dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
> 
> DMA_PRIVATE here keeps all channels private, so they couldn't be used
> elsewhere, for example raid offload.  Do you need a private allocation
> or can you get away with a dynamically assigned channel?

I would like to have a dedicated DMA engine.  async_tx could cause the
copies to complete out of order.  Do I need to add infrastructure to
allow for private channel usage, and when unused allow the channel to
be used by async_tx?

Thanks,
Jon
