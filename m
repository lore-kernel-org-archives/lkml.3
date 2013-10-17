Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3JQOmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:42:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:59341 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab3JQOmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:42:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="309109716"
Date: Thu, 17 Oct 2013 19:18:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131017134846.GG14013@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
 <20131017142755.GA4477@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017142755.GA4477@breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:27:55PM +0200, Sebastian Andrzej Siewior wrote:
> On Thu, Oct 17, 2013 at 07:37:45AM +0530, Vinod Koul wrote:
> > index 0bc7275..683c380 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
> >  
> >  /**
> >   * enum dma_status - DMA transaction status
> > - * @DMA_SUCCESS: transaction completed successfully
> > + * @DMA_COMPLETE: transaction completed
> >   * @DMA_IN_PROGRESS: transaction not yet processed
> >   * @DMA_PAUSED: transaction is paused
> >   * @DMA_ERROR: transaction failed
> >   */
> >  enum dma_status {
> > -	DMA_SUCCESS,
> > +	DMA_COMPLETE,
> >  	DMA_IN_PROGRESS,
> >  	DMA_PAUSED,
> >  	DMA_ERROR,
> > +	DMA_SUCCESS,
> >  };
> 
> There are some drivers which compare against == or != DMA_SUCCESS. Shouldn't this
> become
>   enum dma_status {
>  -	DMA_SUCCESS,
>  +	DMA_COMPLETE = 0, DMA_SUCCESS = 0,
>   	DMA_IN_PROGRESS,
>   	DMA_PAUSED,
>   	DMA_ERROR,
>   };
> 
> so nothing breaks during the transition?
Yes i missed it in first place update the patch to fix that

~Vinod
