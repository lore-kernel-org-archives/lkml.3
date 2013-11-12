Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3KLRFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:05:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:64812 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3KLRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:05:06 -0500
X-IronPort-AV: E=Sophos;i="4.93,686,1378857600"; 
   d="scan'208";a="71118995"
Date: Tue, 12 Nov 2013 17:03:42 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <konrad@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/2] swiotlb-xen: add missing xen_dma_map_page
 call
In-Reply-To: <20131112144500.GB9435@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1311121703340.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com> <1384265520-6833-1-git-send-email-stefano.stabellini@eu.citrix.com> <20131112144500.GB9435@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 12, 2013 at 02:11:59PM +0000, Stefano Stabellini wrote:
> > swiotlb-xen is missing a xen_dma_map_page call in
> > xen_swiotlb_map_sg_attrs, in the slow path.
> 
> s/slow/bounce buffer/ I believe?

right


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index a224bc7..1eac073 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -555,6 +555,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  				sg_dma_len(sgl) = 0;
> >  				return 0;
> >  			}
> > +			xen_dma_map_page(hwdev, pfn_to_page(map >> PAGE_SHIFT),
> > +						map & ~PAGE_MASK,
> > +						sg->length,
> > +						dir,
> > +						attrs);
> >  			sg->dma_address = xen_phys_to_bus(map);
> >  		} else {
> >  			/* we are not interested in the dma_addr returned by
> > -- 
> > 1.7.2.5
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> 
