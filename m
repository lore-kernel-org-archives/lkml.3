Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3H3HwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:52:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3H3Hv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:51:57 -0400
Message-ID: <52204F14.50405@ti.com>
Date: Fri, 30 Aug 2013 10:51:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/29] video: mxsfb: simplify use of devm_ioremap_resource
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr> <1376471493-22215-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376471493-22215-3-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="p9fVeKms08mSlrBPv5VntDegc3Ju9McSA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p9fVeKms08mSlrBPv5VntDegc3Ju9McSA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14/08/13 12:11, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource=
=2E
>=20
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
>=20
> A simplified version of the semantic patch that makes this change is as=

> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret !=3D 0;
> identifier l;
> @@
>=20
> - res =3D platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when !=3D res
> - if (res =3D=3D NULL) { ... \(goto l;\|return ret;\) }
>   ... when !=3D res
> + res =3D platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e =3D devm_ioremap_resource(e1, res);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/video/mxsfb.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index c2d3514..d250ed0 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -855,12 +855,6 @@ static int mxsfb_probe(struct platform_device *pde=
v)
>  	if (of_id)
>  		pdev->id_entry =3D of_id->data;
> =20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Cannot get memory IO resource\n");
> -		return -ENODEV;
> -	}
> -
>  	fb_info =3D framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);=

>  	if (!fb_info) {
>  		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
> @@ -869,6 +863,7 @@ static int mxsfb_probe(struct platform_device *pdev=
)
> =20
>  	host =3D to_imxfb_host(fb_info);
> =20
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	host->base =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(host->base)) {
>  		ret =3D PTR_ERR(host->base);
>=20

Thanks, queued for 3.12.

 Tomi



--p9fVeKms08mSlrBPv5VntDegc3Ju9McSA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSIE8UAAoJEPo9qoy8lh71L/UP+wREmIIngWcp/pGQkpQr2k2W
iLgNwW3nhVCH3CJBvWmcSCTNir+Nkz7eH8DkAtCXUuzAEJ2hFHuOz2dOqkStSM99
X9RsodwVcfFRSoCb65xVIZgKBr7booQ9IBOpyvatfEOpgsAy25bVxNzTv79dVPmL
6oAO1YKq8NN05Ys15VfjC2x/mfJ7BCnNk5ucKV+d7qd+bBWzMc7793defhloizbG
OgkvsOGMOIYNLzyoLYqmHEH24Q1AoqY9qba6LXMqB/WuBfp9AWeQw4BfbQ77gkqN
KEojPJhiAIrLS7CFXP7+pE79qIEpRJF34qsVz/eNxt26VhI90JfbXlZORaRyML34
y6RiFwNaIEbbf/6uEl/v+D8XIqkisq+LvF/GFthSdVARDVkqZWou8yvYOXLRiqVc
LptRYeFs8fe6MxAGN6NqSNUiH0j35rLJy0ryOMSp3Z7c6FVcPKymiDYW/2cNV6vd
DhxyL3VHpgOaodUltaSFxrEQc9AheBEbnOB7Ttx2cUhKaSsqLES51rvvRxp3qer/
MJnIPF/w7VGv5Hge6FiHHiIx1n2jqraAQRCQCx3/QjXnUAPOksfdzBEN3H071Sfs
iVSW9gn4hcW6E1NZg9jvYQN5is+t4m3ZVLxa3+F7JHIzoVwebXHzKe1Ox3KlLBPn
4w42sPvG8o/VkcKCKuh1
=wM5D
-----END PGP SIGNATURE-----

--p9fVeKms08mSlrBPv5VntDegc3Ju9McSA--
