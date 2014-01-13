Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaAMJKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:10:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:17309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaAMJKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:10:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,651,1384329600"; 
   d="scan'208";a="464190744"
Date: Mon, 13 Jan 2014 13:39:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
Subject: Re: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
Message-ID: <20140113080907.GB25466@intel.com>
References: <52D188DA.6020904@pengutronix.de>
 <52D18DE4.2020008@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D18DE4.2020008@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 10:31:00AM -0800, Randy Dunlap wrote:
> On 01/11/2014 10:09 AM, Marc Kleine-Budde wrote:
> > Hello,
> > 
> > in current linux-next (and net-next) the compilation of the CAN
> > drivers[1] with ARCH=blackfin fails with:
> > 
> >>   CC [M]  drivers/net/can/c_can/c_can.o
> >> In file included from linux/include/linux/netdevice.h:38:0,
> >>                  from linux/drivers/net/can/c_can/c_can.c:32:
> >> linux/include/linux/dmaengine.h:55:2: error: expected identifier before numeric constant
> >> linux/include/linux/dmaengine.h: In function 'dma_async_is_complete':
> >> linux/include/linux/dmaengine.h:1023:9: error: 'DMA_IN_PROGRESS' undeclared (first use in this function)
> >> linux/include/linux/dmaengine.h:1023:9: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > There are two locations where DMA_COMPLETE is defined:
> > 
> >> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define              DMA_COMPLETE  0x8        /* DMA Complete */
> >> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define              DMA_COMPLETE  0x8        /* DMA Complete */
> > 
> > and
> > 
> >> include/linux/dmaengine.h-enum dma_status {
> >> include/linux/dmaengine.h:      DMA_COMPLETE,
> >> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
> >> include/linux/dmaengine.h-      DMA_PAUSED,
> >> include/linux/dmaengine.h-      DMA_ERROR,
> >> include/linux/dmaengine.h-};
> > 
> > What's the appropriate fix for the problem?
> 
> arch/blackfin/mach-bf548/ needs a less generic name for its macro.
Not just these, but looking at the whole file, it needs fix. Names are very
generic here :( and bound to keep colliding with core stuff

--
~Vinod

> 
> > Marc
> > 
> > [1] Yes, c_can isn't a blackfin driver, but it's the first one in my
> >     compile tests and it fails.
> > 
> 
> 
> -- 
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
