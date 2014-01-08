Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaAHJs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:48:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59638 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaAHJsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:48:24 -0500
Message-ID: <52CD1EE0.9000309@ti.com>
Date: Wed, 8 Jan 2014 11:48:16 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: <plagnioj@jcrosoft.com>, <airlied@redhat.com>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <kamal@whence.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbcon: trivial optimization for fbcon_exit
References: <20131227023917.GA3908@udknight>
In-Reply-To: <20131227023917.GA3908@udknight>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RI8SJQ5MHFLwVUdDcVK9XNsvsVfcmJHt0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RI8SJQ5MHFLwVUdDcVK9XNsvsVfcmJHt0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-27 04:39, Wang YanQing wrote:
> Break out as soon as we find a mapped entry con2fb_map.
>=20
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/video/console/fbcon.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbco=
n.c
> index cd8a802..f39931f 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -3547,8 +3547,10 @@ static void fbcon_exit(void)
>  			"no"));
> =20
>  		for (j =3D first_fb_vc; j <=3D last_fb_vc; j++) {
> -			if (con2fb_map[j] =3D=3D i)
> +			if (con2fb_map[j] =3D=3D i) {
>  				mapped =3D 1;
> +				break;
> +			}
>  		}
> =20
>  		if (mapped) {
>=20

Thanks, queued for 3.14.

 Tomi



--RI8SJQ5MHFLwVUdDcVK9XNsvsVfcmJHt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzR7gAAoJEPo9qoy8lh71lbAP/AsMdZIennrcPHhw5rV+puby
SRxItG9kpWuU907q8AY5eFFMliqlztdgVQh6d0j7Jqy2rKHA158VxKXmQguQGgrM
3zddGA8RBWvBdjqVTURrGDY7gbFy4252uVPWxN3xmBhXifLj29oRyEW9UkZr3m9o
C7NEUZLC4FBOKJATYAxLXWkrxjMYO31YNo+fBXnGxitCjjAQQ69OUMsn2oA6Jsgf
FIEQAD1hN26i4+AlnVxNSfiFL3xsCQUOsgWD4CqD/jTmkd4pdML7Tl7qK3MTNY3R
9En2ZuiaHiFW6Axbyt8OXPubdfjPWBDwwsSgxd+CmmaJw+xXOA6yoY1XAEp8c5B9
+tUzp/fvG9KKevKrzrUpD2dG/ONMUi+oGNCVvGf/3uVHEbRZFYIP5yuQ2iPEtrQR
7hrHyy9bBMsU6cmhSTYecn7olPu2wD/urmMvHuqgaNr16nEdhwokv1zJ6t9RkrVr
KNefnmtHha5qfG26tW+f4Htxo/hi45eFZ0Ht8lkvGWinhDjHF+Eshg9N74//VbH6
aezo3AA3DSJqJVt0SqF5B6pYyjbFlYqOjmcip/63lrAHuMkP7PazyHF4rd9trFrX
2nAoLaiTUsSQiFkopbmQPTFOD0npbnMwLHsdEjFcjhcj6cXQei86KR4GqBgT9Ub0
WqISp5Dc6M/7gSbw3pTh
=8BzD
-----END PGP SIGNATURE-----

--RI8SJQ5MHFLwVUdDcVK9XNsvsVfcmJHt0--
