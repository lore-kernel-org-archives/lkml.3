Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3JIRcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:32:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43028 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3JIRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:32:08 -0400
X-IronPort-AV: E=Sophos;i="4.90,1064,1371081600"; 
   d="scan'208";a="59345711"
Date: Wed, 9 Oct 2013 18:31:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v6 14/19] swiotlb: print a warning when the swiotlb is
 full
In-Reply-To: <20130930155808.GT3106@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1310091830350.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com> <1380298207-29151-14-git-send-email-stefano.stabellini@eu.citrix.com> <20130930155808.GT3106@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 27, 2013 at 05:10:02PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |    1 +
> >  lib/swiotlb.c             |    1 +
> >  2 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 96ad316..790c2eb 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -674,6 +674,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  								 sg->length,
> >  								 dir);
> >  			if (map == SWIOTLB_MAP_ERROR) {
> > +				pr_warn("swiotlb buffer is full\n");
> 
> It would be beneficial to use dev_warn instead.

OK

> And perhaps even call debug_dma_dump_mappings to help in diagnosing
> a problem?

I don't think that would be very beneficial because this is an internal
swiotlb issue: we just run out of buffer space.


> >  				/* Don't panic here, we expect map_sg users
> >  				   to do proper error handling. */
> >  				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index eb45d17..f06da0d 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -502,6 +502,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
> >  
> >  not_found:
> >  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> > +	pr_warn("swiotlb buffer is full\n");
> >  	return SWIOTLB_MAP_ERROR;
> >  found:
> >  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> > -- 
> > 1.7.2.5
> > 
> 
