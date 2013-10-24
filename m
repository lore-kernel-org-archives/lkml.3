Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3JXV3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 17:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3JXV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 17:29:12 -0400
Date: Thu, 24 Oct 2013 23:28:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
In-Reply-To: <20131017134846.GG14013@intel.com>
Message-ID: <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com> <20131017142755.GA4477@breakpoint.cc>
 <20131017134846.GG14013@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:fXWRVJx1xoNAQ+TR8yvP128gJZQGIKygi8AZFj4VdnB
 wnaPQRPGcIkddTioe30l55r9awYUc1pP3HR1tTOEgFl+ritOy/
 dsLMno+3KKCE5ppgE+oVodqNlut3FqHv4C5hwYMEMyndUGjwkV
 8XNKnXd4IpM/OR4eu9qZ2q5ftus5t+1eO5c4TOxS21odbTrPY7
 T2qMKpEp3JgS6SVDcHH3tkibyrDUXVXtOf9YqtLjgclD0WgQw0
 9jzg4Hn4DrZytLPcEeJuMA2mYNAm7p6jucw2Wj9JDxaPBcgD7F
 vc2Ea9VwKQxu9YO5qS3WdRjWi8thaLO+XuYGhCuT7i4+avXqKr
 rjtoVYWubUPG7/oezNtKtzqPSgM8tpRwx/BJFug7Oie/snn/Wi
 ISS/So5f26ATw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Thu, 17 Oct 2013, Vinod Koul wrote:

> On Thu, Oct 17, 2013 at 04:27:55PM +0200, Sebastian Andrzej Siewior wrote:
> > On Thu, Oct 17, 2013 at 07:37:45AM +0530, Vinod Koul wrote:
> > > index 0bc7275..683c380 100644
> > > --- a/include/linux/dmaengine.h
> > > +++ b/include/linux/dmaengine.h
> > > @@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
> > >  
> > >  /**
> > >   * enum dma_status - DMA transaction status
> > > - * @DMA_SUCCESS: transaction completed successfully
> > > + * @DMA_COMPLETE: transaction completed
> > >   * @DMA_IN_PROGRESS: transaction not yet processed
> > >   * @DMA_PAUSED: transaction is paused
> > >   * @DMA_ERROR: transaction failed
> > >   */
> > >  enum dma_status {
> > > -	DMA_SUCCESS,
> > > +	DMA_COMPLETE,
> > >  	DMA_IN_PROGRESS,
> > >  	DMA_PAUSED,
> > >  	DMA_ERROR,
> > > +	DMA_SUCCESS,
> > >  };
> > 
> > There are some drivers which compare against == or != DMA_SUCCESS. Shouldn't this
> > become
> >   enum dma_status {
> >  -	DMA_SUCCESS,
> >  +	DMA_COMPLETE = 0, DMA_SUCCESS = 0,
> >   	DMA_IN_PROGRESS,
> >   	DMA_PAUSED,
> >   	DMA_ERROR,
> >   };
> > 
> > so nothing breaks during the transition?
> Yes i missed it in first place update the patch to fix that

Are you planning to post a fixed version of this patch or you just fix it 
internally? Would be good to have it posted to be able to ack it and other 
relevant patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
