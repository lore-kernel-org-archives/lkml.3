Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaFWMH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:07:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45226 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaFWMH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:07:26 -0400
Message-ID: <53A81879.6000303@ti.com>
Date: Mon, 23 Jun 2014 15:07:21 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/video/fbdev/sis: Add missing else
References: <1403294397-18262-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1403294397-18262-1-git-send-email-linux@rasmusvillemoes.dk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GAu8huONB3Xeet53rHcwbmfgNafpiEiGj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GAu8huONB3Xeet53rHcwbmfgNafpiEiGj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20/06/14 22:59, Rasmus Villemoes wrote:
> The surrounding code and the fact that the previous two if's are
> rendered useless without this "else" (since SIS_340=3D=3D55 and XGI_20=3D=
=3D75
> are greater than SIS_661=3D=3D15) suggests that the "else" is indeed
> missing.
>=20
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/video/fbdev/sis/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/i=
nit.c
> index bd40f5e..dfe3eb7 100644
> --- a/drivers/video/fbdev/sis/init.c
> +++ b/drivers/video/fbdev/sis/init.c
> @@ -1511,7 +1511,7 @@ SiS_Get310DRAMType(struct SiS_Private *SiS_Pr)
>        } else if(SiS_Pr->ChipType >=3D SIS_340) {
>  	 /* TODO */
>  	 data =3D 0;
> -      } if(SiS_Pr->ChipType >=3D SIS_661) {
> +      } else if(SiS_Pr->ChipType >=3D SIS_661) {
>  	 if(SiS_Pr->SiS_ROMNew) {
>  	    data =3D ((SiS_GetReg(SiS_Pr->SiS_P3d4,0x78) & 0xc0) >> 6);
>  	 } else {
>=20

I agree. Queued for 3.17.

 Tomi



--GAu8huONB3Xeet53rHcwbmfgNafpiEiGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBh5AAoJEPo9qoy8lh71EHkP/3QPIScgF0K+3ccY9itYiYtc
PeRBJeKgQhKxwUjlgPdxQU3ej7GKeMbgBAZZIr2oPzOm/MQrNl23Y22RzxLXMfzu
vNbjMZKaSuexPmLtTGtJ1FbyMCYr4lJ926slVW0QnuGhPoRGN9g0kE3A0GHHYyV6
SQWn2wzwtdyHzcPRRuPdVXHD4VkVte/c8P5RjuPzrRArasb60ACKm73psarBDFLA
vjhFOpPjgLKd/MN43x7uoaHq+s53/y4AYEvdXMubP/pW+LChONAdw/Zj6XhYG40k
as8rX1wUbjzCnd8SiCcxk2cD6sNNqTJzlfzOqswGuvFzV/mlvSYbgdXjdyvUU8uB
ga6oOPg/zeBVDFCMPRKcynEdhOt/p6LeZLI3KpO2qqdYqqvc6mEQvkqChSOPvy2y
/r5yLWCAeMBx62uyyhxi7Z+S80yXODNs4vHsrz2Nej6Nf/IIfoIED3+vyxUJKxvj
lsgHnZ0UUud027/mY+vS516mHTBsy0VRYPjQAi8x4Yi5mGUdEcrR/1xQaBK2WTa2
4MVdRhBS88yvfnujtWJQWjZhCrYHKAgptNLlZH1tI9yk6zHCA97P3Z0INEIXveg5
g4P83UHUYGto+S1zFIRlbfIYUX+8jnx9fxgigjTlkLxmZjo+/rP+/t2WR69SO+gY
jZxJe9YW125ggJPa90kk
=XC1M
-----END PGP SIGNATURE-----

--GAu8huONB3Xeet53rHcwbmfgNafpiEiGj--
