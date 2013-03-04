Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3CDE5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:57:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:33521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3CDE5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="scan'208";a="263892933"
Date: Mon, 4 Mar 2013 10:27:39 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_dma: Use GFP_ATOMIC because called from interrupt
 context
Message-ID: <20130304045739.GE22513@intel.com>
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

> On Tue, Feb 12, 2013 at 11:25 AM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> > pdc_desc_get() is called from pd_prep_slave_sg, and the function is
> > called from interrupt context(e.g. Uart driver "pch_uart.c").
> > In fact, I saw kernel error message.
> > So, GFP_ATOMIC must be used not GFP_NOIO.
> >
> > Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Applied, thanks

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
