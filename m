Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaBKSFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:05:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:1464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaBKSFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:05:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="473527132"
Date: Tue, 11 Feb 2014 23:33:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andy Gross <agross@codeaurora.org>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v5 1/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140211180344.GS10628@intel.com>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org>
 <1391546556-27702-2-git-send-email-agross@codeaurora.org>
 <20140211173048.GP10628@intel.com>
 <20140211174910.GE841@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211174910.GE841@joshc.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:49:10AM -0600, Josh Cartwright wrote:
> On Tue, Feb 11, 2014 at 11:00:48PM +0530, Vinod Koul wrote:
> > On Tue, Feb 04, 2014 at 02:42:35PM -0600, Andy Gross wrote:
> > > Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> > > found in the MSM 8x74 platforms.
> > > 
> > > Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> > > channel provides a uni-directional data transfer engine that is capable of
> > > transferring data between the peripheral and system memory (System mode), or
> > > between two peripherals (BAM2BAM).
> > > 
> > > The initial release of this driver only supports slave transfers between
> > > peripherals and system memory.
> > > 
> > > Signed-off-by: Andy Gross <agross@codeaurora.org>
> >
> > > +++ b/drivers/dma/qcom_bam_dma.c
> [..]
> > > +static void bam_reset_channel(struct bam_chan *bchan)
> > > +{
> > > +	struct bam_device *bdev = bchan->bdev;
> > > +
> > > +	/* reset channel */
> > > +	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
> > > +	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
> > > +
> > > +	/* don't allow reorder of the channel reset */
> > > +	wmb();
> > Documentation/memory-barriers.txt describes wmb() as a CPU barier but based on
> > above you want it to be a compiler barrier then you should do 1st write,
> > barrier(), second write.
> 
> It could also be that the intent was to prevent these writes from being
> ordered before setting the initialized flag below, either way the
> comment could be made clearer.
yes for that case, but i am suspecting the comment is correct as it would make
sense to ensure reset is in sequence...

-- 
~Vinod
> 
> > > +
> > > +	/* make sure hw is initialized when channel is used the first time  */
> > > +	bchan->initialized = 0;
> > > +}
> 
-- 
