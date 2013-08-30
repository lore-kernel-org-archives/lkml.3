Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3H3Jmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:42:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3H3Jme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:42:34 -0400
Message-ID: <52206903.5050707@ti.com>
Date: Fri, 30 Aug 2013 12:42:27 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] video: xilinxfb: replace devm_request_and_ioremap
 by devm_ioremap_resource
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr> <1376911241-27720-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376911241-27720-7-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="OvCuspnK2QPgdS5cVLBFxXjaPC4IJlRwR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OvCuspnK2QPgdS5cVLBFxXjaPC4IJlRwR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/08/13 14:20, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Use devm_ioremap_resource instead of devm_request_and_ioremap.
>=20
> This was done using the semantic patch
> scripts/coccinelle/api/devm_ioremap_resource.cocci
>=20
> The initialization of drvdata->regs_phys was manually moved lower, to t=
ake
> advantage of the NULL test on res performed by devm_ioremap_resource.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/video/xilinxfb.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index 6629b29..84c664e 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -259,12 +259,12 @@ static int xilinxfb_assign(struct platform_device=
 *pdev,
>  		struct resource *res;
> =20
>  		res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -		drvdata->regs_phys =3D res->start;
> -		drvdata->regs =3D devm_request_and_ioremap(&pdev->dev, res);
> -		if (!drvdata->regs) {
> -			rc =3D -EADDRNOTAVAIL;
> +		drvdata->regs =3D devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(drvdata->regs)) {
> +			rc =3D PTR_ERR(drvdata->regs);
>  			goto err_region;
>  		}
> +		drvdata->regs_phys =3D res->start;
>  	}
> =20
>  	/* Allocate the framebuffer memory */

Thanks, queued for 3.12.

 Tomi




--OvCuspnK2QPgdS5cVLBFxXjaPC4IJlRwR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSIGkDAAoJEPo9qoy8lh715B8QAJjsbcyn3+mZZ7Arcov8Lw2+
faIDL39Sg4d0stS5uzwePXqTfYdmAZbxmDY8CKG+tsD47ww2vi1jPdDu1D0mntTo
/UmGvS9miAcrII7fh9yohd9h9DO2iMBzpK0P4uQS1B2LL/4mue7pAZM45TKAgVVG
DlP/aQkWgPU9iUPTcGso54hnRk3HEqohz1ZzaC8psAupj79Ifmsw1R+0HAybwOrh
S8Aflj3LcjDYCnNK5+P9z6RXiP2GiwV2ToCWlub6LMaYPoQxsahPPVJ6cH81ah0f
ms53ZtSfPgV0MOW4p/dmoz4eKfdMkKJWpprzeaZijxQCOzm940viKYnTTtRK2oN8
X34krrvsemtTVl3oEntpQK+ah9q3CeCeIJhZUT4Tl3nKLRUMcfPLrgmVqDbjI6yB
T/xsAbFFnR8ehMoIWTNy8/k5NJB/NJ7pkqIVEbJNfvUanUOICbaR7684ZciSb49o
/+GzPoOXK08pR6aYEKFOFyT2fmjjpAWNX0ygY4oYoKtSWqSKsQ+zzW5XkViGwQtg
dGwgexLmZ4VSNVLBdJMdE/NS1JPS1lbHwyOqOd2m0vO2WDue9K8QDnmQasj7Mw1G
GSabd2e/rw+A54d5oHZd2CONNJP0mOHf+l1lHy2xpITScSfbo+hs++wgZvd8Aho4
Ryy42HIY7VhKYWCT0gcw
=c3EN
-----END PGP SIGNATURE-----

--OvCuspnK2QPgdS5cVLBFxXjaPC4IJlRwR--
