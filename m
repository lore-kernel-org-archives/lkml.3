Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3IQFqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:46:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:10488 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3IQFqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:46:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="361531767"
Date: Tue, 17 Sep 2013 10:26:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Matt Porter <matt.porter@linaro.org>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma/Kconfig: Make TI_EDMA select TI_PRIV_EDMA
Message-ID: <20130917045653.GO17188@intel.com>
References: <20130904133203.GB12834@hansolo.jdub.homelinux.org>
 <20130904161045.GG12834@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904161045.GG12834@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:10:45PM -0400, Josh Boyer wrote:
> On Wed, Sep 04, 2013 at 09:32:03AM -0400, Josh Boyer wrote:
> > The TI_EDMA driver unconditionally calls functions provided by the
> > TI_PRIV_EDMA code, but it doesn't force that to be built-in.  If that isn't
> > otherwise enabled somewhere, you can get build errors like:
> > 
> > linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:593: undefined reference to `edma_free_slot'
> > drivers/built-in.o: In function `edma_terminate_all':
> > linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:169: undefined reference to `edma_stop'
> > drivers/built-in.o: In function `edma_execute':
> > linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:122: undefined reference to `edma_write_slot'
> > linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:149: undefined reference to `edma_link'
> > linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:152: undefined reference to `edma_start'
> > 
> > Make TI_EDMA select TI_PRIV_EDMA to avoid this.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Applied, thanks

~Vinod
> 
> Just replying to Matt's new email address as the TI one bounced when I
> originally sent this.
> 
> > ---
> >  drivers/dma/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > index daa4da2..825374b 100644
> > --- a/drivers/dma/Kconfig
> > +++ b/drivers/dma/Kconfig
> > @@ -198,6 +198,7 @@ config TI_EDMA
> >  	depends on ARCH_DAVINCI || ARCH_OMAP
> >  	select DMA_ENGINE
> >  	select DMA_VIRTUAL_CHANNELS
> > +	select TI_PRIV_EDMA
> >  	default n
> >  	help
> >  	  Enable support for the TI EDMA controller. This DMA
> > -- 
> > 1.8.3.1
> > 

-- 
