Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAMKtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:49:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59934 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbbAMKtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:49:51 -0500
Message-ID: <54B4F82D.6040905@ti.com>
Date: Tue, 13 Jan 2015 12:49:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Qiang Chen <qiang2.chen@sonymobile.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qiang Chen <qcwj.lk@gmail.com>
Subject: Re: [PATCH] video: ocfb: Fix data type warning
References: <1417767510-31462-1-git-send-email-qiang2.chen@sonymobile.com>
In-Reply-To: <1417767510-31462-1-git-send-email-qiang2.chen@sonymobile.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="PR2USXRS78Fcnb85D4bHB6PaCi78qGcTq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PR2USXRS78Fcnb85D4bHB6PaCi78qGcTq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/12/14 10:18, Qiang Chen wrote:
> When allocate framebuffer memory using dma_alloc_coherent(),
> we'd better use dma_addr_t instead of phys_addr_t. Because the
> address we got in fact is DMA or bus address for the platform.
>=20
> This patch also fixes below build warning:
> drivers/video/fbdev/ocfb.c:335:2:
> 	warning: passing argument 3 of =E2=80=98dma_alloc_attrs=E2=80=99
> 	from incompatible pointer type [enabled by default]
>=20
> Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>
> ---
>  drivers/video/fbdev/ocfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
> index 7f9dc9b..de98196 100644
> --- a/drivers/video/fbdev/ocfb.c
> +++ b/drivers/video/fbdev/ocfb.c
> @@ -61,7 +61,7 @@ struct ocfb_dev {
>  	/* flag indicating whether the regs are little endian accessed */
>  	int little_endian;
>  	/* Physical and virtual addresses of framebuffer */
> -	phys_addr_t fb_phys;
> +	dma_addr_t fb_phys;
>  	void __iomem *fb_virt;
>  	u32 pseudo_palette[PALETTE_SIZE];
>  };
>=20

Thanks, queued for 3.20.

 Tomi



--PR2USXRS78Fcnb85D4bHB6PaCi78qGcTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtPg1AAoJEPo9qoy8lh71FnQP/0MYvke7PTHgwySdJGMyXfv3
CRY7/RfEmOEGZqinWvTfrT1S8G8vUPrf8OzGIRy/btYBHlq/A95odLMkKeWBIQkj
tw+7LwQEbQqUjK+qgXTTnR6gHpvfKXVTizvKuxPthv6biCPXba91J5/m32nE67Q2
6ngNj8evZAm2WhRY15ytMpzCB3L+EMb4HGscDVqG+DoSUyIsf5+VLVTYsDHF6udF
1JiQmZOie+89W9Kd+hMjVKh1W3aUJsmOMgHdboEdzUnaI1YE+ltKFkEbncQpaq9X
WqYCdIeZObjgtSIQI3LyJT/ZJhD0665pSizjuU+0bFuUTEGiK/vCQwCa01cZsXpx
tBn9ycNSTLrATebyGoiPrzGiwosPh8flk2E6CICR4h1UThETYC7tQ+ClJYWZjCr4
nbj3augG5qFxPEGIIiIgZQlB/t3iBZClA/s9yaISWJZuOD2deuKdSPo0Xwa6Yuxg
bPFDSB8T3mv8jHbb2ynVLrPr3Qga//jgrtT75RCx5zrfh/jHnPKCAjtM1XZF6SAh
4lEIoxj8EjZF5hbZXRPN6Z1lmnCqLCiBcr2CT3hBqeo9TQrGNz384GBpVyRDWCpX
QMeJYTC2EZHq2WeHAeBnE0qxadM6x7jpVyrheyKs64FvhrKn3AFgBwnCjLf86Q/g
+QVjN0WdE8T9i0XquB9i
=Z/EI
-----END PGP SIGNATURE-----

--PR2USXRS78Fcnb85D4bHB6PaCi78qGcTq--
