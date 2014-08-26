Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbaHZKeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:34:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57332 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934324AbaHZKeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:34:16 -0400
Message-ID: <53FC629A.2050101@ti.com>
Date: Tue, 26 Aug 2014 13:34:02 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>, <plagnioj@jcrosoft.com>,
        Antonino Daplas <adaplas@gmail.com>
CC: <jg1.han@samsung.com>, <laurent.pinchart@ideasonboard.com>,
        <robdclark@gmail.com>, <daniel.vetter@ffwll.ch>,
        <Julia.Lawall@lip6.fr>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] video : remove redundant error check
References: <20140516093123.GA17245@devel.8.8.4.4>
In-Reply-To: <20140516093123.GA17245@devel.8.8.4.4>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jcac2m5J2GXAW87hsuD8axsqafEnEldkg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jcac2m5J2GXAW87hsuD8axsqafEnEldkg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 16/05/14 12:31, Daeseok Youn wrote:
> It doesn't need to check "err" for printing info.
> And also use pr_info instead of printk.
>=20
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: removes unneeded lines for sending a patch
>=20
>  drivers/video/fbdev/i810/i810_main.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/i810/i810_main.c b/drivers/video/fbdev=
/i810/i810_main.c
> index bb674e4..15cb397 100644
> --- a/drivers/video/fbdev/i810/i810_main.c
> +++ b/drivers/video/fbdev/i810/i810_main.c
> @@ -1910,13 +1910,12 @@ static void i810fb_find_init_mode(struct fb_inf=
o *info)
> =20
>  	for (i =3D 0; i < par->ddc_num + 1; i++) {
>  		err =3D i810_probe_i2c_connector(info, &par->edid, i);
> -		if (!err)
> +		if (!err) {
> +			pr_info("i810fb_init_pci: DDC probe successful\n");
>  			break;
> +		}
>  	}
> =20
> -	if (!err)
> -		printk("i810fb_init_pci: DDC probe successful\n");
> -
>  	fb_edid_to_monspecs(par->edid, specs);
> =20
>  	if (specs->modedb =3D=3D NULL)
>=20

I don't know... I think I personally like more the original version. In
fact, the whole print looks quite useless to me, or at least it should
be a debug print.

 Tomi



--jcac2m5J2GXAW87hsuD8axsqafEnEldkg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/GKaAAoJEPo9qoy8lh71hB8P/RmRNDhH7SiXHpWaIwfDhSf4
krOsifo9MkHzR0Pnrd63UUbXV1hujsP0VMd3tKb67o8XUQ/3AUL2ccH/GM5BGEyY
ymEP8U+OiUcqH6Da6IVfw04cDjKIOJE05ia2ds4no7FH4rW03/oSd6tFPeP4euZT
Mx/WRC8RsjUIUIk0pbP/b9rGZnr9JaDNK4+merTvDOWo5w0yJH3UGea8JqyZ+nUe
TcaT2fHuP4mDYb1D4AfcT5OrALXgjuBmZNIf2cF6+tULZWda9/m8WgBrqI7GdprM
9o/L1Pt2BCWtvddFaLSFdmn5uGsdhk0vVoJn5QtsMh5jnU46JC21idqxrWEDprYd
9/G0+ttKt0CEc2kEIKnAWBK5IFPR3YnWQfLVtapbmcT3bTnZjeFo+XEjEqpKyEDW
pfDUv8vWOUfiEZFFZGQsQbEVQ6WH9rmC2oXnRzOW7Q2aMA6u86W7jQGjX0Hih6cr
pDNPFYDqXZvgPsatpnhJJoc9z19lM03Z9wsS55EYu1Ahgyv9u4EQixgscO7OsSqd
GjeQALtZZ9C8Kgvt4abwMvJ5dqdQEmy4TiL24UFtgBH8elI1wYBnoriXJnJFqj47
GUpVQpx/nyH+ga2N1glO7d/5lDwgVvQbmcjO/OfIzcTemmxjugW9GXl4G2v9NkHi
O/UqzBFh/MqdoN+18I2G
=4Hqj
-----END PGP SIGNATURE-----

--jcac2m5J2GXAW87hsuD8axsqafEnEldkg--
