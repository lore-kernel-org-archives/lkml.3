Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaKEOIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:08:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:1899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbaKEOIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:08:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411820451"
Date: Wed, 5 Nov 2014 19:39:10 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ
 safe option
Message-ID: <20141105140910.GP1870@intel.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <3452823.YQ5FR2FtKz@avalon>
 <20141103162728.GB1870@intel.com>
 <2519900.LRhHM3UCtt@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2519900.LRhHM3UCtt@avalon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:59:37PM +0200, Laurent Pinchart wrote:
> > > Many other drivers suffer from the same problem. While I won't reject your
> > > proposed fix, I would prefer a more generic approach.
> > > 
> > > One option that has been discussed previously was to use a work queue to
> > > delay starting the DMA transfer to an interruptible context where
> > > pm_runtime_get_sync() could be called. However, as Russell pointed out
> > > [1],
> > > even that won't work in all cases as the DMA slave might need the transfer
> > > to be started before enabling part of its hardware (OMAP audio seem to be
> > > such a case).
> > > 
> > > I've heard a rumor of a possible DMA engine rework to forbid calling the
> > > descriptor preparation API from atomic context. This could be used as a
> > > base to implement runtime PM, as DMA slave drivers should not prepare
> > > descriptors if they don't need to use them. However that's a long term
> > > plan, and we need a solution sooner than that.
> > 
> > Well it is not a rumour :)
> 
> I didn't want to put too much pressure on you by quoting you on that :-)
> 
> > I have been contemplating that now that async_tx will be killed so we dont
> > have to worry about that usage. For the slave dma usage, we can change the
> > prepare API to be non atomic. I think the users will be okay with approach.
> > This way drivers can use runtime pm calls in prepare.
> 
> I'd certainly welcome that. There's a couple of users we will need to fix as 
> they call the prepare API from an atomic context. I'm thinking about ASoC 
> drivers in particular.
ASoC is impler to fix as we can do this is ASoC prepare which is not atomic.
So we would need to split prepare and submit on that

> Do you have any time line in mind ?
Not yet, perhpaps the one after next merge window will be good target.

-- 
~Vinod
