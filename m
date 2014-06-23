Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaFWLxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:53:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53665 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaFWLxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:53:51 -0400
Message-ID: <53A81549.40206@ti.com>
Date: Mon, 23 Jun 2014 14:53:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH -next 25/26] fbdev: Use dma_zalloc_coherent
References: <cover.1402863904.git.joe@perches.com> <881b8f8d85c96b6e9d8735aa10bbf18468688b9d.1402863905.git.joe@perches.com>
In-Reply-To: <881b8f8d85c96b6e9d8735aa10bbf18468688b9d.1402863905.git.joe@perches.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mcm19T86hjbK20gI4evSEE5B6A8I3XHKV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mcm19T86hjbK20gI4evSEE5B6A8I3XHKV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15/06/14 23:37, Joe Perches wrote:
> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/fbdev/da8xx-fb.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx=
-fb.c
> index a8484f7..788f6b3 100644
> --- a/drivers/video/fbdev/da8xx-fb.c
> +++ b/drivers/video/fbdev/da8xx-fb.c
> @@ -1447,18 +1447,15 @@ static int fb_probe(struct platform_device *dev=
ice)
>  		da8xx_fb_fix.line_length - 1;
> =20
>  	/* allocate palette buffer */
> -	par->v_palette_base =3D dma_alloc_coherent(NULL,
> -					       PALETTE_SIZE,
> -					       (resource_size_t *)
> -					       &par->p_palette_base,
> -					       GFP_KERNEL | GFP_DMA);
> +	par->v_palette_base =3D dma_zalloc_coherent(NULL, PALETTE_SIZE,
> +						  (resource_size_t *)&par->p_palette_base,
> +						  GFP_KERNEL | GFP_DMA);
>  	if (!par->v_palette_base) {
>  		dev_err(&device->dev,
>  			"GLCD: kmalloc for palette buffer failed\n");
>  		ret =3D -EINVAL;
>  		goto err_release_fb_mem;
>  	}
> -	memset(par->v_palette_base, 0, PALETTE_SIZE);
> =20
>  	par->irq =3D platform_get_irq(device, 0);
>  	if (par->irq < 0) {
>=20

Thanks, queued for 3.17.

 Tomi



--mcm19T86hjbK20gI4evSEE5B6A8I3XHKV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBVJAAoJEPo9qoy8lh71QtEQAK4m/4TbjC+UMhGljhMYnpfO
JuFi0ASPziQLDFrrhs4L/h3fqUA8mTPr29NwAbzm9rS4SA16LW0QeohMs/ArHnaG
SpoR1SA29YMV4OOqBQxWTOo1VJwS2J+w8lBdPpP4clg4hbyIhqKJuTR2b7Wtd/z1
hdABfKAa1EtCC2Crc2Io6K1zQcTUuczkrO1iS1IJBaY0ekAZGD+o+ABDf7sMOo3Y
yk3v4Kvxnyu0WBRBveK4jWIk2wuNiCzQ3hCGl5PI7W7U8s5HYPgWTEdvwcTTOnPO
VL/27kHWpscqF1ABTtIE7pqlYRHxrkZF7VOFm4RAewumD9KEp/VClpiqZXpnwPoC
sAoJCw9k7N9tluvC1oNNG789Eji7QNXdrImCzfbYG5TLfKxV7a2YMivxJ1K5ebYl
rZPOq0vnQSorUZP+BzlJkjDFZ98/FmrtYls+1GwRytCl/zG+Bbz1ws33FH0z0SZG
B7ZW/byd7CIPfyalI7kxSL0qwm5l1xioiOEyZPHthN9OsykJTVNwxchLyRXXlFmg
4WTgBdwsOETUd96Xvg+LrcjsJN9sj9y1K0lPaiN/2G11fhKhPiinDHt1YM114A+H
u3Uc1bfHvll1ckRSn5f9eOfKVG3Gvhf9kXA4bAsLmGH9NKrXOW8/yWEPNfovtB0S
SITDmrBmKJvTCDRKJ/Gx
=KTxf
-----END PGP SIGNATURE-----

--mcm19T86hjbK20gI4evSEE5B6A8I3XHKV--
