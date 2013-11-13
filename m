Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab3KMSb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:31:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55133 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab3KMSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:31:51 -0500
Message-ID: <5283C58D.10800@ti.com>
Date: Wed, 13 Nov 2013 14:31:41 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] thermal: fix cpu_cooling max_level behavior
References: <1384366269-1655-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384366269-1655-1-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="2a3JPWQUGGub2K7uiSn7NnIEjTLHHvmfc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2a3JPWQUGGub2K7uiSn7NnIEjTLHHvmfc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 13-11-2013 14:11, Eduardo Valentin wrote:
> As per Documentation/thermal/sysfs-api.txt, max_level
> is an index, not a counter. Thus, in case a CPU has
> 3 valid frequencies, max_level is expected to be 2, for instance.
>=20
> The current code makes max_level =3D=3D number of valid frequencies,
> which is bogus. This patch fix the cpu_cooling device by
> ranging max_level properly.
>=20
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Rui,

This fix is applicable even on 3.12.

> ---
>  drivers/thermal/cpu_cooling.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_coolin=
g.c
> index d179028..d0f8f8b5 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -173,6 +173,8 @@ static int get_property(unsigned int cpu, unsigned =
long input,
>  		freq =3D table[i].frequency;
>  		max_level++;
>  	}
> +	/* max_level is an index, not a counter */
> +	max_level--;
> =20
>  	/* get max level */
>  	if (property =3D=3D GET_MAXL) {
> @@ -181,7 +183,7 @@ static int get_property(unsigned int cpu, unsigned =
long input,
>  	}
> =20
>  	if (property =3D=3D GET_FREQ)
> -		level =3D descend ? input : (max_level - input - 1);
> +		level =3D descend ? input : (max_level - input);
> =20
>  	for (i =3D 0, j =3D 0; table[i].frequency !=3D CPUFREQ_TABLE_END; i++=
) {
>  		/* ignore invalid entry */
> @@ -197,7 +199,7 @@ static int get_property(unsigned int cpu, unsigned =
long input,
> =20
>  		if (property =3D=3D GET_LEVEL && (unsigned int)input =3D=3D freq) {
>  			/* get level by frequency */
> -			*output =3D descend ? j : (max_level - j - 1);
> +			*output =3D descend ? j : (max_level - j);
>  			return 0;
>  		}
>  		if (property =3D=3D GET_FREQ && level =3D=3D j) {
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--2a3JPWQUGGub2K7uiSn7NnIEjTLHHvmfc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKDxY0ACgkQCXcVR3XQvP31sgEAxz/Mu4ds8UnVZWKo1vo1prFV
y3vCPtn2OIZVz7+TVVcBAM/92EIC37bWwmEiu4cPxIiU+wANH9mo3cU5vE8m3Wzl
=sQhi
-----END PGP SIGNATURE-----

--2a3JPWQUGGub2K7uiSn7NnIEjTLHHvmfc--
