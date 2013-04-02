Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab3DBSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:01:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:11932 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3DBSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="312512549"
Date: Tue, 2 Apr 2013 23:03:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: padma.v@samsung.com, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id
Message-ID: <20130402173341.GL10326@intel.com>
References: <26789240.182151364893959039.JavaMail.weblogic@epv6ml02>
 <515AB694.7090403@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515AB694.7090403@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 12:44:36PM +0200, Lars-Peter Clausen wrote:
> On 04/02/2013 11:12 AM, PADMAVATHI VENNA wrote:
> >> Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
> >> implementation.
Hi Padma,

Can you please fix your MUA to
1) not break the message ids
2) reply inline which makes a distinction for quoted text

> >>
> >> There is one minor difference between the generic of_dma_xlate_by_chan_id
> >> function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
> >> DMA_SLAVE capability for the channel capability mask, while the pl330 driver
> >> additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
> >> have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
> >> functions will have the same result.
> >>
> >> I am not clear about the dma capabilities. Is it mentioned some where that if we set DMA_SLAVE capability
> >> will that also set DMA_CYCLIC capability?
> >>
> > 
> > Well DMA_SLAVE won't automatically set DMA_CYCLIC. But the driver sets both.
> > 
> > I tested your patches, it's woking for audio. But I need some clarification related to capabilities.
> > As per my understanding, controller driver registers the available capabilities in the probe and 
> > client drivers requests for a particular capability. In both the cases, in the dmaengine it checks
> > if the requested capability is satisfied.
> > If we don't set the DMA_CYCLIC, how __dma_device_satisfies_mask works?
> > 
> >  Please correct me if I am wrong.
> > 
> > Thanks
> > Padma
> 
> Hi,
> 
> Well, DMA_SLAVE | DMA_CYCLIC is a more restrictive mask than DMA_SLAVE. So
> any channel that matches DMA_SLAVE | DMA_CYCLIC will also match DMA_SLAVE.
DMA_SLAVE means that controllers channel can do slave transactions and should
support the slave APIs.
DMA_CYCLIC means that controller can do a cyclic transfers for the sg list sent
and will do so untill channel is aborted

Now we are talking about DMA_CYCLIC for periphrals only so DMA_SLAVE cna be
implied and is usually the normal usage though nothing prevent you from doing a
cyclic memcpy if you would wish.

Right thing would be to set mask aptly on both sides, and since you are doing
DMA_CYCLIC, i would expect both the controller and client have done this, if not
we need this to be fixed :)

--
~Vinod
