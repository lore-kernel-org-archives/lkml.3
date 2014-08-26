Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaHZK4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:56:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36657 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaHZK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:56:23 -0400
Message-ID: <53FC67CD.8020901@ti.com>
Date: Tue, 26 Aug 2014 13:56:13 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>, Maik Broemme <mbroemme@plusserver.de>
CC: <joe@perches.com>, <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] video: fbdev: intelfb: delete double assignment
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr> <1408818808-18850-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1408818808-18850-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iIc1iRTTQgiHXSr1IKcp5ingP1jvcI2Ik"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iIc1iRTTQgiHXSr1IKcp5ingP1jvcI2Ik
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 23/08/14 21:33, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Delete successive assignments to the same location.
>=20
> In the second case, =3D is converted to |=3D, which looks appropriate b=
ased on
> the values involved.
>=20
> A simplified version of the semantic match that finds this problem is a=
s
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression i;
> @@
>=20
> *i =3D ...;
>  i =3D ...;
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
> The patches in this series do not depend on each other.
>=20
> This changes the behavior of the code in the second case and is not tes=
ted.

In this patch, as in the sis one, the behavior is changed. The subject
might perhaps be "fix cursor initialization"?

The patch does look like it could cause a regression, though. Anyone
able to test this?

 Tomi

>=20
>  drivers/video/fbdev/intelfb/intelfbhw.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/intelfb/intelfbhw.c b/drivers/video/fb=
dev/intelfb/intelfbhw.c
> index fbad61d..d31ed4e 100644
> --- a/drivers/video/fbdev/intelfb/intelfbhw.c
> +++ b/drivers/video/fbdev/intelfb/intelfbhw.c
> @@ -1191,7 +1191,6 @@ int intelfbhw_mode_to_hw(struct intelfb_info *din=
fo,
>  	vsync_end =3D vsync_start + var->vsync_len;
>  	vtotal =3D vsync_end + var->upper_margin;
>  	vblank_start =3D vactive;
> -	vblank_end =3D vtotal;
>  	vblank_end =3D vsync_end + 1;
> =20
>  	DBG_MSG("V: act %d, ss %d, se %d, tot %d bs %d, be %d\n",
> @@ -1859,7 +1858,7 @@ void intelfbhw_cursor_init(struct intelfb_info *d=
info)
>  		tmp =3D INREG(CURSOR_CONTROL);
>  		tmp &=3D ~(CURSOR_FORMAT_MASK | CURSOR_GAMMA_ENABLE |
>  			 CURSOR_ENABLE | CURSOR_STRIDE_MASK);
> -		tmp =3D CURSOR_FORMAT_3C;
> +		tmp |=3D CURSOR_FORMAT_3C;
>  		OUTREG(CURSOR_CONTROL, tmp);
>  		OUTREG(CURSOR_A_BASEADDR, dinfo->cursor.offset << 12);
>  		tmp =3D (64 << CURSOR_SIZE_H_SHIFT) |
>=20



--iIc1iRTTQgiHXSr1IKcp5ingP1jvcI2Ik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/GfNAAoJEPo9qoy8lh714d4QAKOcT8ic+Ac09d6nl3jtnid5
HWc7eMhRNQbsuKkScAal465EciwqsjAOaPLW3fneREKNRY7mjOR+xQEM1GuDmYd2
fyRO5XnsQfUJ9yPTDtvzG9oFckO/8y12z2ZLd/r+ikXzqCwO1ALda4QRb9FH9VMi
WYnfBxySAhJY9GgzvlnjCtSSvEOXYfKp+14tThTwnxuqooYU5O4qw5RG5Re6DYdI
VmbGmQVDj/IEGltKFKJq9XHLIvUkDZfhHEyrbRO+qi6MdzHLjt8ryQQP5TG/FPaY
f2NsJG/K55EmxtQVFZHq+k2kGNLBN17MoCx/BkMsD4ULEq/Wwz7NrGOY/5km8j5U
FoXC/ZDqBI8V46fto/YjIchw8vYw7swazTSDUptZoB+vHPvtkv0o83Sfx0z7FDHt
+YHqVN6ipaiFtWx0cXWbzM9ucibueA5X0HCt8YGyi5Ub5u3tOGQEX7oSZj3eZrrD
lwZSv09fk1wAPx12+CkUzGwHidrXgudFfHa/pNG5geXlSJQyXID+UpAdM9X0dQ+5
0CEDqnkYwMwK47zE0msaZu93sMmQsOjslh6thgOebykOhZ++dqY+DK7MG7b6Ao3+
dhfr1u+zChVdZXjCXENRVWz97DJj7O7/EijtP/tDaoeZqBBWvHhPXvv+8gW664JG
qFbcehcvqXUesnwfHzdb
=5u3c
-----END PGP SIGNATURE-----

--iIc1iRTTQgiHXSr1IKcp5ingP1jvcI2Ik--
