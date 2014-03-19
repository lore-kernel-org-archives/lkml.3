Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbaCSLFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:05:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275AbaCSLF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:05:29 -0400
Message-ID: <532979CA.6040007@ti.com>
Date: Wed, 19 Mar 2014 13:04:42 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <nicolas.ferre@atmel.com>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Video: atmel: avoid the id of fix screen info is overwritten
References: <1395215275-14345-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395215275-14345-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pPliJecwtw7NirkT5cbmE2jxd5oomswQ6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pPliJecwtw7NirkT5cbmE2jxd5oomswQ6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/03/14 09:47, Bo Shen wrote:
> Correct passing parameter sequence, which will avoid the id of
> fix screen info is overwritten.
>=20
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  drivers/video/atmel_lcdfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index cd96162..695f28a 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -1190,12 +1190,12 @@ static int __init atmel_lcdfb_probe(struct plat=
form_device *pdev)
>  	if (!sinfo->config)
>  		goto free_info;
> =20
> -	strcpy(info->fix.id, sinfo->pdev->name);
>  	info->flags =3D ATMEL_LCDFB_FBINFO_DEFAULT;
>  	info->pseudo_palette =3D sinfo->pseudo_palette;
>  	info->fbops =3D &atmel_lcdfb_ops;
> =20
>  	info->fix =3D atmel_lcdfb_fix;
> +	strcpy(info->fix.id, sinfo->pdev->name);
> =20
>  	/* Enable LCDC Clocks */
>  	sinfo->bus_clk =3D clk_get(dev, "hclk");
>=20

Thanks, queued for 3.15.

 Tomi



--pPliJecwtw7NirkT5cbmE2jxd5oomswQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTKXnKAAoJEPo9qoy8lh71uBUQAKWeO0gKPyjl8Df+6mdJy/ZP
/IXDblxlhb1zTEVsLWiLZ5xrIHcPOHzup3ykTPCMTOJmwFkpV5iZ2eIZ1k1HdM8t
YCOfGUbsnELqcZfhsVnZty1d4Xl7IlhdLNgHMuho96XicPlBvXpmOgRXwEGvyqH8
4fasnEeQ2qDyTnUqkvfKDegCAT43Wo0UghB4PVapTar/a8XNEuqBycj4ViKVEjG+
8OO2eRlyUNmcr+YvxxC9ZH604nPqy5zlNWxniP0iLHH0fkF3Ay5nWsOMldb7dVed
iSNbNcpWQPQ2BM9Xg7v+nFZep6jzbG3o0q0d0T0iQt7Qb6TV8y3pnj5GiEOko9YE
PixGG975sn5luw76fEOtqZ+EM5tzeQyxWDAMBBNHWmNzonE9o5RTKAqrXMYu+P6+
F5n2nWuFYiThCZshhWubZmDpPRZyB3FUZOyAomcCY/gbzd/1EALQqy8wWLJ1s+01
XAMyQS8eG5Nu+M0j8eCBiSdYQ1eVNRSYrTtf3NUcltvcKw+rSGDPFDD3byGhXcot
rHxTLTI9+5Bo165AIDqkcvm7B5n5Iw31xRmekmzOeQ5dnGzpyXAG+u4pigqg6e8t
rz5hEQoAqFB6tMkq3/Z6kFPxWP2GTp3kq9yoiRLw4cj3UGyGFkTV6NX9IwsxOM/t
GyMFQWa34EZU89LGWItD
=oOGN
-----END PGP SIGNATURE-----

--pPliJecwtw7NirkT5cbmE2jxd5oomswQ6--
