Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaKTKt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:49:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26575 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTKt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:49:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,423,1413244800"; 
   d="scan'208";a="193220032"
Date: Thu, 20 Nov 2014 10:33:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>
Subject: Re: [PATCH v9 12/13] swiotlb-xen: pass dev_addr to xen_dma_unmap_page
 and xen_dma_sync_single_for_cpu
In-Reply-To: <20141119210703.GE20440@laptop.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1411201033460.12596@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com> <1415792454-23161-12-git-send-email-stefano.stabellini@eu.citrix.com> <20141119210703.GE20440@laptop.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Konrad Rzeszutek Wilk wrote:
> On Wed, Nov 12, 2014 at 11:40:53AM +0000, Stefano Stabellini wrote:
> > xen_dma_unmap_page and xen_dma_sync_single_for_cpu take a dma_addr_t
> > handle as argument, not a physical address.
> 
> Ouch. Should this also go on stable tree?

Good idea


> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 3725ee4..498b654 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -449,7 +449,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
> >  
> >  	BUG_ON(dir == DMA_NONE);
> >  
> > -	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
> > +	xen_dma_unmap_page(hwdev, dev_addr, size, dir, attrs);
> >  
> >  	/* NOTE: We use dev_addr here, not paddr! */
> >  	if (is_xen_swiotlb_buffer(dev_addr)) {
> > @@ -497,14 +497,14 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
> >  	BUG_ON(dir == DMA_NONE);
> >  
> >  	if (target == SYNC_FOR_CPU)
> > -		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > +		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
> >  
> >  	/* NOTE: We use dev_addr here, not paddr! */
> >  	if (is_xen_swiotlb_buffer(dev_addr))
> >  		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
> >  
> >  	if (target == SYNC_FOR_DEVICE)
> > -		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > +		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
> >  
> >  	if (dir != DMA_FROM_DEVICE)
> >  		return;
> > -- 
> > 1.7.10.4
> > 
> 
