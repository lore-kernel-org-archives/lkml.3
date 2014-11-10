Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaKJJ2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:28:33 -0500
Received: from lhrrgout.huawei.com ([194.213.3.17]:11649 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaKJJ2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:28:32 -0500
From: Frediano Ziglio <frediano.ziglio@huawei.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Frediano Ziglio <freddy77@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Subject: RE: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
Thread-Topic: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
Thread-Index: AQHP+eQybFi0WqSOD0+2fx6E4sVCLJxT2xKAgAAaXQCAAAKpgIABRwSAgARd4YA=
Date: Mon, 10 Nov 2014 09:27:49 +0000
Message-ID: <B944B469BF5302468AC6EB05E56CC70D17E083@lhreml509-mbb>
References: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
 <alpine.DEB.2.02.1411061730240.22875@kaball.uk.xensource.com>
 <CAHt6W4cDvgK=jdkMot5E4COoC=3aeZn8vPxiR5K5XS53g=+FXA@mail.gmail.com>
 <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
 <20141107144517.GA13259@laptop.dumpdata.com>
In-Reply-To: <20141107144517.GA13259@laptop.dumpdata.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.68.131]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 06, 2014 at 07:14:51PM +0000, Stefano Stabellini wrote:
> > On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> > > 2014-11-06 17:30 GMT+00:00 Stefano Stabellini
> <stefano.stabellini@eu.citrix.com>:
> > >       On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> > >       > On ARM error code is not 0 so avoid to return it as error.
> > >       >
> > >       > Signed-off-by: Frediano Ziglio <frediano.ziglio@huawei.com>
> > >
> > >       Acked-by: Stefano Stabellini
> > > <stefano.stabellini@eu.citrix.com>
> > >
> > >
> > >       Could you please fix the same error in lib/swiotlb.c too
> please?
> > >
> > >
> > > Same patch or another ?
> > >
> >
> > Another
> 
> It might break the build. Please double-check that it does not affect
> ia64.
> >

Code in lin/swiotlb.c does not require any changes as the error value is completely different here (is the pa address of a static allocated buffer). On ia64 the constant I used in my previous patch is 0 so it produce the same assembly code.

Frediano

> > >
> > >       >  drivers/xen/swiotlb-xen.c | 2 +-
> > >       >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >       >
> > >       > diff --git a/drivers/xen/swiotlb-xen.c
> b/drivers/xen/swiotlb-xen.c
> > >       > index ebd8f21..3b8d628 100644
> > >       > --- a/drivers/xen/swiotlb-xen.c
> > >       > +++ b/drivers/xen/swiotlb-xen.c
> > >       > @@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct
> device *dev, struct page *page,
> > >       >        */
> > >       >       if (!dma_capable(dev, dev_addr, size)) {
> > >       >               swiotlb_tbl_unmap_single(dev, map, size, dir);
> > >       > -             dev_addr = 0;
> > >       > +             dev_addr = DMA_ERROR_CODE;
> 
> That looks Ok to me.
> 
> > >       >       }
> > >       >       return dev_addr;
> > >       >  }
> > >       > --
> > >       > 1.9.1
> > >       >
> > >       >
> > >       > --
> > >       > To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> > >       > the body of a message to majordomo@vger.kernel.org
> > >       > More majordomo info at  http://vger.kernel.org/majordomo-
> info.html
> > >       > Please read the FAQ at http://secure-
> web.cisco.com/1cvjROyUxV6SnA0uBTMRubqrQWsaXGhps-
> FWjY3vly9AxaKKlt2DPY7GjL0FCHeP4rsbjKsc-P4zH2_7-kpcxwEH-udGrGCCq
> > >       kCLlH1-fLOo1X6Nlui6EwEVHUpB2r7gt-
> Gsgxbep9QWPnIdypDPNf8Hf5clxCMXYcvWsOK5s3qg/http%3A%2F%2Fwww.tux.org%2Fl
> kml%2F
> > >       >
> > >
> > >       _______________________________________________
> > >       Xen-devel mailing list
> > >       Xen-devel@lists.xen.org
> > >       http://lists.xen.org/xen-devel
> > >
> > >
> > >
> > >
> 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel

