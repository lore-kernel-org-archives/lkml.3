Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbaKTUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:31:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44151 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaKTUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:30:59 -0500
Date: Thu, 20 Nov 2014 15:30:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com
Subject: Re: [PATCH v9 12/13] swiotlb-xen: pass dev_addr to
 xen_dma_unmap_page and xen_dma_sync_single_for_cpu
Message-ID: <20141120203020.GJ31889@laptop.dumpdata.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
 <1415792454-23161-12-git-send-email-stefano.stabellini@eu.citrix.com>
 <20141119210703.GE20440@laptop.dumpdata.com>
 <alpine.DEB.2.02.1411201033460.12596@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1411201046110.12596@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411201046110.12596@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:47:51AM +0000, Stefano Stabellini wrote:
> On Thu, 20 Nov 2014, Stefano Stabellini wrote:
> > On Wed, 19 Nov 2014, Konrad Rzeszutek Wilk wrote:
> > > On Wed, Nov 12, 2014 at 11:40:53AM +0000, Stefano Stabellini wrote:
> > > > xen_dma_unmap_page and xen_dma_sync_single_for_cpu take a dma_addr_t
> > > > handle as argument, not a physical address.
> > > 
> > > Ouch. Should this also go on stable tree?
> > 
> > Good idea
> 
> Also can I take that as an Acked-by for this patch?

Yes.
> 
> 
> There is one last bit of common and x86 changes in this series:
> patch #7 adds a paramter to xen_dma_map_page, even though the x86
> implementation is empty:
> 
> http://marc.info/?l=xen-devel&m=141579253829808&w=2
> 
> is that OK for you?

Yes.
>  
>  
> > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > ---
> > > >  drivers/xen/swiotlb-xen.c |    6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > > > index 3725ee4..498b654 100644
> > > > --- a/drivers/xen/swiotlb-xen.c
> > > > +++ b/drivers/xen/swiotlb-xen.c
> > > > @@ -449,7 +449,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
> > > >  
> > > >  	BUG_ON(dir == DMA_NONE);
> > > >  
> > > > -	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
> > > > +	xen_dma_unmap_page(hwdev, dev_addr, size, dir, attrs);
> > > >  
> > > >  	/* NOTE: We use dev_addr here, not paddr! */
> > > >  	if (is_xen_swiotlb_buffer(dev_addr)) {
> > > > @@ -497,14 +497,14 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
> > > >  	BUG_ON(dir == DMA_NONE);
> > > >  
> > > >  	if (target == SYNC_FOR_CPU)
> > > > -		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > > > +		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
> > > >  
> > > >  	/* NOTE: We use dev_addr here, not paddr! */
> > > >  	if (is_xen_swiotlb_buffer(dev_addr))
> > > >  		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
> > > >  
> > > >  	if (target == SYNC_FOR_DEVICE)
> > > > -		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > > > +		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
> > > >  
> > > >  	if (dir != DMA_FROM_DEVICE)
> > > >  		return;
> > > > -- 
> > > > 1.7.10.4
> > > > 
> > > 
> > 
