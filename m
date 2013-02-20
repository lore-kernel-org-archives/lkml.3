Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3BTF6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:58:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:54485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897Ab3BTF6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="288051309"
Date: Wed, 20 Feb 2013 11:27:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_dma: Use GFP_ATOMIC because called from interrupt
 context
Message-ID: <20130220055754.GA23302@intel.com>
References: <1360635933-5818-1-git-send-email-tomoya.rohm@gmail.com>
 <CANKRQnhp_+mKnezqWZ2OZxecpac-N0EpmKuV8p285LC3jSEw2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnhp_+mKnezqWZ2OZxecpac-N0EpmKuV8p285LC3jSEw2w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:26:54AM +0900, Tomoya MORINAGA wrote:
> Hi
> 
> Could you review this patch ?
> 8 days have passed...
Sorry looks like I missed it. I have queued it up and will apply after -rc1

--
~Vinod
> 
> thanks,
> tomoya
> 
> On Tue, Feb 12, 2013 at 11:25 AM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> > pdc_desc_get() is called from pd_prep_slave_sg, and the function is
> > called from interrupt context(e.g. Uart driver "pch_uart.c").
> > In fact, I saw kernel error message.
> > So, GFP_ATOMIC must be used not GFP_NOIO.
> >
> > Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> > ---
> >  drivers/dma/pch_dma.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> > index 987ab5c..d5cbd44 100644
> > --- a/drivers/dma/pch_dma.c
> > +++ b/drivers/dma/pch_dma.c
> > @@ -476,7 +476,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
> >         dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
> >
> >         if (!ret) {
> > -               ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
> > +               ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
> >                 if (ret) {
> >                         spin_lock(&pd_chan->lock);
> >                         pd_chan->descs_allocated++;
> > --
> > 1.7.4.4
> 
> -- 
> ROHM Co., Ltd.
> tomoya
