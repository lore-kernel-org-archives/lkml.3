Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423053AbaDKQ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:57:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:16171 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbaDKQ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,842,1389772800"; 
   d="scan'208";a="519029246"
Date: Fri, 11 Apr 2014 22:17:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        nsekhar@ti.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, mporter@linaro.org
Subject: Re: [PATCH v2 08/14] DMA: edma: Use different eventq for cyclic
 channels
Message-ID: <20140411164755.GE32284@intel.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
 <1396357575-30585-9-git-send-email-peter.ujfalusi@ti.com>
 <5346C88E.8010504@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5346C88E.8010504@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 11:36:30AM -0500, Joel Fernandes wrote:
> On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
> > To improve latency with cyclic DMA operation it is preferred to
> > use different eventq/tc than the default which is used by all
> > other drivers (mmc, spi, i2c, etc).
> > When preparing the cyclic dma ask for non default queue for the
> > channel which is going to be used with cyclic mode.
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > ---
> >  drivers/dma/edma.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> > index 1dd9e8806975..10048b40fac8 100644
> > --- a/drivers/dma/edma.c
> > +++ b/drivers/dma/edma.c
> > @@ -628,6 +628,9 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
> >  		edesc->pset[i].opt |= TCINTEN;
> >  	}
> >  
> > +	/* Use different eventq/tc for cyclic DMA to reduce latency */
> > +	edma_request_non_default_queue(echan->ch_num);
> > +
> >  	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
> >  }
> >  
> > 
> 
> Is there any way to guarantee that the non-default queue is of the
> highest priority, or in other words default queue is of lowest priority.
well as we are discussing in other thread, it would make sense to pass the
required priority (i am using audio so pls give me highest one)

-- 
~Vinod
> I know you set queue 1 as default because by default 0 is higher
> priority. And then assigning non-default queue.
> 
> When assigning default to Queue 1, it would be good to also call
> assign_priority_to_queue and set QUEPRI to 7 for Queue 1. Since 0, 2 and
> 4 are all non-defaults.
> 
> Thanks,
> -Joel

-- 
