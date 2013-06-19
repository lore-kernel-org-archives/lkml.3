Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3FSULC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:11:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:63699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805Ab3FSULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="319618512"
Date: Wed, 19 Jun 2013 13:10:54 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
Message-ID: <20130619201054.GA20996@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
 <1371602813-19828-3-git-send-email-jon.mason@intel.com>
 <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
 <20130619175206.GA20737@jonmason-lab>
 <CAA9_cmdVfFmD5Li4b8WEtAiqCiSCKYuva_86MLV3ysAhyLXtig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmdVfFmD5Li4b8WEtAiqCiSCKYuva_86MLV3ysAhyLXtig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:56:38AM -0700, Dan Williams wrote:
> On Wed, Jun 19, 2013 at 10:52 AM, Jon Mason <jon.mason@intel.com> wrote:
> >> DMA_PRIVATE here keeps all channels private, so they couldn't be used
> >> elsewhere, for example raid offload.  Do you need a private allocation
> >> or can you get away with a dynamically assigned channel?
> >
> > I would like to have a dedicated DMA engine.  async_tx could cause the
> > copies to complete out of order.  Do I need to add infrastructure to
> > allow for private channel usage, and when unused allow the channel to
> > be used by async_tx?
> 
> Can NTB just call dma_find_channel() once and be done?  Also, async_tx
> will only get things out of order if you allow it to pick a new
> channel for every operation, but as long as you specify a dependency
> chain it will keep things in order (same as remembering the result of
> dma_find_channel).

Neither of these allow a device exclusive access to a channel.  Is
this not something that is desired by other users of DMA Engines, or
do I have a unique usage model?

Thanks,
Jon

> 
> --
> Dan
