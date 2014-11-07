Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaKGTrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:47:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKGTrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:47:04 -0500
Date: Fri, 7 Nov 2014 09:45:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Frediano Ziglio <freddy77@gmail.com>, linux-kernel@vger.kernel.org,
        Frediano Ziglio <frediano.ziglio@huawei.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
Message-ID: <20141107144517.GA13259@laptop.dumpdata.com>
References: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
 <alpine.DEB.2.02.1411061730240.22875@kaball.uk.xensource.com>
 <CAHt6W4cDvgK=jdkMot5E4COoC=3aeZn8vPxiR5K5XS53g=+FXA@mail.gmail.com>
 <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 07:14:51PM +0000, Stefano Stabellini wrote:
> On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> > 2014-11-06 17:30 GMT+00:00 Stefano Stabellini <stefano.stabellini@eu.citrix.com>:
> >       On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> >       > On ARM error code is not 0 so avoid to return it as error.
> >       >
> >       > Signed-off-by: Frediano Ziglio <frediano.ziglio@huawei.com>
> > 
> >       Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > 
> >       Could you please fix the same error in lib/swiotlb.c too please?
> > 
> > 
> > Same patch or another ?
> > 
> 
> Another

It might break the build. Please double-check that it does not affect
ia64.
> 
> >  
> >       >  drivers/xen/swiotlb-xen.c | 2 +-
> >       >  1 file changed, 1 insertion(+), 1 deletion(-)
> >       >
> >       > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> >       > index ebd8f21..3b8d628 100644
> >       > --- a/drivers/xen/swiotlb-xen.c
> >       > +++ b/drivers/xen/swiotlb-xen.c
> >       > @@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >       >        */
> >       >       if (!dma_capable(dev, dev_addr, size)) {
> >       >               swiotlb_tbl_unmap_single(dev, map, size, dir);
> >       > -             dev_addr = 0;
> >       > +             dev_addr = DMA_ERROR_CODE;

That looks Ok to me.

> >       >       }
> >       >       return dev_addr;
> >       >  }
> >       > --
> >       > 1.9.1
> >       >
> >       >
> >       > --
> >       > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >       > the body of a message to majordomo@vger.kernel.org
> >       > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >       > Please read the FAQ at http://secure-web.cisco.com/1cvjROyUxV6SnA0uBTMRubqrQWsaXGhps-FWjY3vly9AxaKKlt2DPY7GjL0FCHeP4rsbjKsc-P4zH2_7-kpcxwEH-udGrGCCq
> >       kCLlH1-fLOo1X6Nlui6EwEVHUpB2r7gt-Gsgxbep9QWPnIdypDPNf8Hf5clxCMXYcvWsOK5s3qg/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> >       >
> > 
> >       _______________________________________________
> >       Xen-devel mailing list
> >       Xen-devel@lists.xen.org
> >       http://lists.xen.org/xen-devel
> > 
> > 
> > 
> > 

> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

