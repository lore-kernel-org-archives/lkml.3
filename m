Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3EILER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:04:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:28716 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab3EILEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:04:16 -0400
Message-ID: <518B8292.3030700@imgtec.com>
Date: Thu, 9 May 2013 12:03:46 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Denis Efremov <yefremov.denis@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <trivial@kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH 12/21] metag: delay: remove inline marking of EXPORT_SYMBOL
 functions
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com> <1368095819-11011-1-git-send-email-yefremov.denis@gmail.com>
In-Reply-To: <1368095819-11011-1-git-send-email-yefremov.denis@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE3F177B1CD4974B0A3BC6725"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_09_12_04_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigE3F177B1CD4974B0A3BC6725
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/05/13 11:36, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/metag/lib/delay.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/metag/lib/delay.c b/arch/metag/lib/delay.c
> index 0b308f4..7ff0ca7 100644
> --- a/arch/metag/lib/delay.c
> +++ b/arch/metag/lib/delay.c
> @@ -36,7 +36,7 @@ void __delay(unsigned long loops)
>  }
>  EXPORT_SYMBOL(__delay);
> =20
> -inline void __const_udelay(unsigned long xloops)
> +void __const_udelay(unsigned long xloops)
>  {
>  	u64 loops =3D (u64)xloops * (u64)loops_per_jiffy * HZ;
>  	__delay(loops >> 32);
>=20

The inline still has an effect on code generation if other functions in
the same compilation unit use it, so this isn't really a trivial change.

I.e. before this patch __udelay and __ndelay inlined __const_udelay, but
after it they are changed to just multiply & branch.

Therefore I'd like to hear some more justification for these changes.

Cheers
James


--------------enigE3F177B1CD4974B0A3BC6725
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRi4KkAAoJEKHZs+irPybf/WkP/jxm8zApLton5/viisJ+p079
eLJUui3dPkAIHFlzDT47DvPYYIYERFH/CJZM2NVvzOVPqfJhtRcAx4rZjHtSRA5w
r6/OzEZFM0emYtgjKhj4aFfb4sEJHv29iferxHkqI0XQRd0pADct2+FpqSDLbbXy
XgPCqhP4r9ImRUw8gSkz9P1cDCgAjIWOzukGxcYy1xfOMdHBg+gfSWgi5KL2ny8D
SMFT8aX5ByRtJxrWs8c+OnpgQmWta1G+nliyBcDF0o1vfh0Xyau1HezdsMptfTjE
WhLo4wViHYMk4SfiWfsDCGWouZXsd/A5X1YQSz/ylxkP5T0yV2TcZglyjmmyilgf
FE6YPBnez1l9p/3vuzIjv+VWzRjN8tXZ36eoVOMHHJGW/w+BrdOOu26xiTWTE3Al
pyT0++GRV5xsQv8gKxFrqdLAsmbnhmFmG1xTCxfyJZmEffUNqswe1dDYtWhjC8v9
ZYIzChRq610Ccs5Fxhbcz6B6OUyZmKN5cjSjylOuwPACJ3JF42nZPmE+9nsDHnMn
HG26hWYQMyFzL8jpvFxGYtbj7WmvygZAh+Gn0ZiyQ0GbdLYDmmYgIPGlF1KSQsOd
QrW9xwR7fV4T1ZReum5asboQL3maioO5Jtw9HROlZmoVys+7vbuXryLO4+3V/X1M
ro0alIMemdOPtOmR2+76
=hhlS
-----END PGP SIGNATURE-----

--------------enigE3F177B1CD4974B0A3BC6725--

