Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaDVQ0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:26:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:11272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbaDVQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,904,1389772800"; 
   d="scan'208";a="525510288"
Date: Tue, 22 Apr 2014 21:44:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [FIX] dmaengine: virt-dma: Free descriptor after
 callback
Message-ID: <20140422161424.GZ32284@intel.com>
References: <1397782610-7370-1-git-send-email-joelf@ti.com>
 <20140418085019.GN27282@n2100.arm.linux.org.uk>
 <5351542A.5080307@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5351542A.5080307@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 11:34:50AM -0500, Joel Fernandes wrote:
> On 04/18/2014 03:50 AM, Russell King - ARM Linux wrote:
> > On Thu, Apr 17, 2014 at 07:56:50PM -0500, Joel Fernandes wrote:
> >> Free the vd (virt descriptor) after the callback is called.  In EDMA driver
> >> atleast which uses virt-dma, we make use of the desc during the callback and if
> >> its dangerously freed before the callback is called. I also noticed this in
> >> omap-dma dmaengine driver.
> > 
> > You've missed the vital bit of information: why do you make use of the
> > descriptor afterwards?  You shouldn't.  omap-dma doesn't either.
> > 
> > Once clients submit their request to DMA engine, they must not hold any
> > kind of reference to the descriptor other than the cookie.
> > 
> 
> Sorry, I confused edma/omap-dma callbacks for virt dma callbacks.
> 
> Anyway, I think there is still a chance in edma that we refer to the
> echan->edesc pointer later on after virt-dma calls the free (in
> edma_execute), so I'll just NULL that out to be safe and submit a patch.

Yes, that would be the right way :)

While looking at this, I see it is not called out specfically in documentation, will update
that as well

-- 
~Vinod
