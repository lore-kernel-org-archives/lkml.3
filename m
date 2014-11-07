Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKGKDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:03:06 -0500
Received: from lhrrgout.huawei.com ([194.213.3.17]:47993 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKGKDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:03:03 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 05:03:02 EST
From: Frediano Ziglio <frediano.ziglio@huawei.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Frediano Ziglio <freddy77@gmail.com>
CC: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
Thread-Topic: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
Thread-Index: AQHP+eQybFi0WqSOD0+2fx6E4sVCLJxT2xKAgAAaXQCAAAKpgIAA9P6w
Date: Fri, 7 Nov 2014 09:56:36 +0000
Message-ID: <B944B469BF5302468AC6EB05E56CC70D17DF04@lhreml509-mbb>
References: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
 <alpine.DEB.2.02.1411061730240.22875@kaball.uk.xensource.com>
 <CAHt6W4cDvgK=jdkMot5E4COoC=3aeZn8vPxiR5K5XS53g=+FXA@mail.gmail.com>
 <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.66.6]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA7A3C3W012120

> On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> > 2014-11-06 17:30 GMT+00:00 Stefano Stabellini
> <stefano.stabellini@eu.citrix.com>:
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
> 

lib/swiotlb.c is not affected at a physical address to io_tlb_overflow_buffer is returned in case of error.
Looks like a way to transform silently an allocation error to a more serious memory corruption.

Frediano

> >
> >       >Â  drivers/xen/swiotlb-xen.c | 2 +-
> >       >Â  1 file changed, 1 insertion(+), 1 deletion(-)
> >       >
> >       > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-
> xen.c
> >       > index ebd8f21..3b8d628 100644
> >       > --- a/drivers/xen/swiotlb-xen.c
> >       > +++ b/drivers/xen/swiotlb-xen.c
> >       > @@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct
> device *dev, struct page *page,
> >       >Â  Â  Â  Â  */
> >       >Â  Â  Â  Â if (!dma_capable(dev, dev_addr, size)) {
> >       >Â  Â  Â  Â  Â  Â  Â  Â swiotlb_tbl_unmap_single(dev, map, size, dir);
> >       > -Â  Â  Â  Â  Â  Â  Â dev_addr = 0;
> >       > +Â  Â  Â  Â  Â  Â  Â dev_addr = DMA_ERROR_CODE;
> >       >Â  Â  Â  Â }
> >       >Â  Â  Â  Â return dev_addr;
> >       >Â  }
> >       > --
> >       > 1.9.1
> >       >
> >       >
> >       > --
> >       > To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> >       > the body of a message to majordomo@vger.kernel.org
> >       > More majordomo info atÂ  http://vger.kernel.org/majordomo-
> info.html
> >       > Please read the FAQ atÂ http://secure-
> web.cisco.com/1cvjROyUxV6SnA0uBTMRubqrQWsaXGhps-
> FWjY3vly9AxaKKlt2DPY7GjL0FCHeP4rsbjKsc-P4zH2_7-kpcxwEH-udGrGCCq
> >       kCLlH1-fLOo1X6Nlui6EwEVHUpB2r7gt-
> Gsgxbep9QWPnIdypDPNf8Hf5clxCMXYcvWsOK5s3qg/http%3A%2F%2Fwww.tux.org%2Fl
> kml%2F
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
