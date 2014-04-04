Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaDDKuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:50:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50706 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaDDKuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:50:09 -0400
Message-ID: <533E8E49.1030307@ti.com>
Date: Fri, 4 Apr 2014 13:49:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <jon@ringle.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
CC: <plagnioj@jcrosoft.com>, Jon Ringle <jringle@gridpoint.com>,
        "Etheridge, Darren" <detheridge@ti.com>
Subject: Re: [PATCH v3 2/2] video: da8xx-fb: Fix casting of info->pseudo_palette
References: <1396355974-2257-1-git-send-email-jon@ringle.org> <1396355974-2257-2-git-send-email-jon@ringle.org>
In-Reply-To: <1396355974-2257-2-git-send-email-jon@ringle.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pcHDp7ncisTbA3J8plWgjfQEPBq2g0IOl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pcHDp7ncisTbA3J8plWgjfQEPBq2g0IOl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/04/14 15:39, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>=20
> The casting to (u16 *) on info->pseudo_palette is wrong and causes the
> display to show a blue (garbage) vertical line on every other pixel col=
umn
>=20
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/video/da8xx-fb.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>=20
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index 233f65f..c17f901 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -678,15 +678,7 @@ static int fb_setcolreg(unsigned regno, unsigned r=
ed, unsigned green,
>  			(green << info->var.green.offset) |
>  			(blue << info->var.blue.offset);
> =20
> -		switch (info->var.bits_per_pixel) {
> -		case 16:
> -			((u16 *) (info->pseudo_palette))[regno] =3D v;
> -			break;
> -		case 24:
> -		case 32:
> -			((u32 *) (info->pseudo_palette))[regno] =3D v;
> -			break;
> -		}
> +		((u32 *) (info->pseudo_palette))[regno] =3D v;
>  		if (palette[0] !=3D 0x4000) {
>  			update_hw =3D 1;
>  			palette[0] =3D 0x4000;
>=20

Thanks.

I wonder why the pseudo_palette in fb.h is 'void *' in the first place.
It seems to be cast to 'u32 *' everywhere...

 Tomi



--pcHDp7ncisTbA3J8plWgjfQEPBq2g0IOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTPo5JAAoJEPo9qoy8lh713AoP/iEgPGgq930ut+FRaiNVATOv
rWeq4b2gkERB8+UsdJQCISp3z9HtOW8KhJTIOA3d9D7YMijZfccQP4Rdyux+zUQr
nxXRyWYQOTK+HLiiwfkGKlK56QfjeEl4KU/32qUclcyj4uJAYwCgDAdS4gXtB2zy
QXzjyiMs6XhUoRW7iRhzsIqeLTYYoYwf4A2N1vaMg/aK9ukNy/R/Q7GpEl632hzB
eZ9awhla9VzAvaH6c5VtKA2bC1GqSAnCUBydW225hlxKTY0/bmotfqrOUOIZg7et
BR+/F3zT2cZPQO8m6poCf/9DYZt085u2FR3QoH4NdDN7nuez/0wXZhdHjh40/Tbj
CZCaUx/JMbxn7i8pryp2dbyy+8lBRsbDhYkMRkkMMEnsvPwzZ+9LJRKQDRPF6Yp1
rgGSK5L8/LwP1vcXfLRsIXHViJ8vnRVXTmonFCkG9n6iGwmW8+kE1F24957K2QW6
G6244SkQxOfhhqbuwKocwcq/0DWtxQQ9EOdMlTYQzWDJPzzctsbqW21eQkqoxctC
TJ/IeX44ukI7pMxXDPuOBM4MUPew+UQt11IycsIrS6sIxe6kAw2m4PM1Lqkn+OWN
hO/PRMuW+kvyYLQpxiFfvFeHZD6Qm0hmfN6/SNub0nDf3q62s1f+hRcvAD57c3RB
Z0Qj2VKNdISeQN9nlWiu
=OIj/
-----END PGP SIGNATURE-----

--pcHDp7ncisTbA3J8plWgjfQEPBq2g0IOl--
