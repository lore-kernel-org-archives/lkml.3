Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaKFTPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:15:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6803 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaKFTPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:15:03 -0500
X-IronPort-AV: E=Sophos;i="5.07,327,1413244800"; 
   d="scan'208";a="190310907"
Date: Thu, 6 Nov 2014 19:14:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Frediano Ziglio <freddy77@gmail.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Frediano Ziglio <frediano.ziglio@huawei.com>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
In-Reply-To: <CAHt6W4cDvgK=jdkMot5E4COoC=3aeZn8vPxiR5K5XS53g=+FXA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1411061914440.22875@kaball.uk.xensource.com>
References: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com> <alpine.DEB.2.02.1411061730240.22875@kaball.uk.xensource.com> <CAHt6W4cDvgK=jdkMot5E4COoC=3aeZn8vPxiR5K5XS53g=+FXA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-387728907-1415301291=:22875"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-387728907-1415301291=:22875
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> 2014-11-06 17:30 GMT+00:00 Stefano Stabellini <stefano.stabellini@eu.citr=
ix.com>:
>       On Thu, 6 Nov 2014, Frediano Ziglio wrote:
>       > On ARM error code is not 0 so avoid to return it as error.
>       >
>       > Signed-off-by: Frediano Ziglio <frediano.ziglio@huawei.com>
>=20
>       Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>=20
>=20
>       Could you please fix the same error in lib/swiotlb.c too please?
>=20
>=20
> Same patch or another ?
>=20

Another

> =C2=A0
>       >=C2=A0 drivers/xen/swiotlb-xen.c | 2 +-
>       >=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>       >
>       > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.=
c
>       > index ebd8f21..3b8d628 100644
>       > --- a/drivers/xen/swiotlb-xen.c
>       > +++ b/drivers/xen/swiotlb-xen.c
>       > @@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct device=
 *dev, struct page *page,
>       >=C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>       >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dma_capable(dev, dev_addr, size)) =
{
>       >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0swiotlb_tbl=
_unmap_single(dev, map, size, dir);
>       > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_addr =3D 0;
>       > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_addr =3D DMA=
_ERROR_CODE;
>       >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>       >=C2=A0 =C2=A0 =C2=A0 =C2=A0return dev_addr;
>       >=C2=A0 }
>       > --
>       > 1.9.1
>       >
>       >
>       > --
>       > To unsubscribe from this list: send the line "unsubscribe linux-k=
ernel" in
>       > the body of a message to majordomo@vger.kernel.org
>       > More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-inf=
o.html
>       > Please read the FAQ at=C2=A0http://secure-web.cisco.com/1cvjROyUx=
V6SnA0uBTMRubqrQWsaXGhps-FWjY3vly9AxaKKlt2DPY7GjL0FCHeP4rsbjKsc-P4zH2_7-kpc=
xwEH-udGrGCCq
>       kCLlH1-fLOo1X6Nlui6EwEVHUpB2r7gt-Gsgxbep9QWPnIdypDPNf8Hf5clxCMXYcvW=
sOK5s3qg/http%3A%2F%2Fwww.tux.org%2Flkml%2F
>       >
>=20
>       _______________________________________________
>       Xen-devel mailing list
>       Xen-devel@lists.xen.org
>       http://lists.xen.org/xen-devel
>=20
>=20
>=20
>=20
--1342847746-387728907-1415301291=:22875--
