Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3K2Omo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:42:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49283 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab3K2Omm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:42:42 -0500
Date: Fri, 29 Nov 2013 14:41:57 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: ensure DMA descriptors are zero-initialised
Message-ID: <20131129144157.GD31000@mudshark.cambridge.arm.com>
References: <1385725828-836-1-git-send-email-will.deacon@arm.com>
 <1385729844.1871.24.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385729844.1871.24.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:57:50PM +0000, Shevchenko, Andriy wrote:
> On Fri, 2013-11-29 at 11:50 +0000, Will Deacon wrote:
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index 98641eaca080..79e52a94f054 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -2492,14 +2492,8 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
> >  
> >  static inline void _init_desc(struct dma_pl330_desc *desc)
> >  {
> > -	desc->pchan = NULL;
> >  	desc->req.x = &desc->px;
> >  	desc->req.token = desc;
> > -	desc->rqcfg.swap = SWAP_NO;
> > -	desc->rqcfg.privileged = 0;
> > -	desc->rqcfg.insnaccess = 0;
> > -	desc->rqcfg.scctl = SCCTRL0;
> > -	desc->rqcfg.dcctl = DCCTRL0;
> >  	desc->req.cfg = &desc->rqcfg;
> >  	desc->req.xfer_cb = dma_pl330_rqcb;
> >  	desc->txd.tx_submit = pl330_tx_submit;
> > @@ -2517,7 +2511,7 @@ static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
> >  	if (!pdmac)
> >  		return 0;
> >  
> > -	desc = kmalloc(count * sizeof(*desc), flg);
> > +	desc = kzalloc(count * sizeof(*desc), flg);
> 
> Maybe kcalloc() ?

Yup, that could work. I'll include that in v2 pending any other comments.

Cheers,

Will
