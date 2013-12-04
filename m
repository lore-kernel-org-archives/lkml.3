Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3LDJck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:32:40 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:60328 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3LDJcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:32:36 -0500
Date: Wed, 4 Dec 2013 10:31:36 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] regulator: tps6586x: add and use correct voltage
 table
Message-ID: <20131204093136.GN19943@ulmo.nvidia.com>
References: <cover.1386100296.git.stefan@agner.ch>
 <c70dc80179c8cfaa18c2665c342ce1bcd827d923.1386100296.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Content-Disposition: inline
In-Reply-To: <c70dc80179c8cfaa18c2665c342ce1bcd827d923.1386100296.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 08:57:28PM +0100, Stefan Agner wrote:
[...]
> Changes since v2:
>   - Removed reg_ from reg_version
>   - Moved walk through version dependent tables to find_regulator_info,
>     removed the inline definition. This reduces .o size and encapsulates
>     the logic of finding the right regulator into one function. It comes
>     with a slight code duplication, the table search now appears twice.

Well, the table was searched twice in the original patch, too, so this
variant isn't any worse, really.

> ---
>  arch/arm/boot/dts/tegra20-colibri-512.dtsi |  4 +-
>  drivers/regulator/tps6586x-regulator.c     | 91 +++++++++++++++++++++++-=
------
>  2 files changed, 74 insertions(+), 21 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/d=
ts/tegra20-colibri-512.dtsi
[...]
> -static inline struct tps6586x_regulator *find_regulator_info(int id)
> +static struct tps6586x_regulator *find_regulator_info(int id, int versio=
n)
>  {
>  	struct tps6586x_regulator *ri;
> +	struct tps6586x_regulator *table =3D NULL;
> +	int num;
>  	int i;
> =20
> +	switch (version) {
> +	case TPS658623:
> +		table =3D tps658623_regulator;
> +		num =3D ARRAY_SIZE(tps658623_regulator);
> +		break;
> +	case TPS658643:
> +		table =3D tps658643_regulator;
> +		num =3D ARRAY_SIZE(tps658643_regulator);
> +		break;
> +	}
> +

I think you still need to check for table to be valid here. Depending on
the version it might still be NULL.

> +	/* Search version specific table first */
> +	for (i =3D 0; i < num; i++) {
> +		ri =3D &table[i];
> +		if (ri->desc.id =3D=3D id)
> +			return ri;
> +	}

So this would need to be wrapped in an "if (table) { }" block.


--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnvZ3AAoJEN0jrNd/PrOhF/kP/jO0dNw7Rf6gY7qLGqHyZvND
CiZawp7NqwVvtMta5A4pWeK4jCXLe7xz1MZhL88OASMaKWqE+ixgB1qSC6e3rvEK
3THKBedtybRQUulhUtg4o9FRYKc8IMMNL9cVA1qv7PSt1uuS+Wf6oqArSF/JvSTf
UF9+xeXGdR8ux/fjEy1J28jDqaJrxoUUaoaTB7czIxbWU1E7NmNdsJ3KNBnHOHX6
PIzBN5GlAC3978wqJejSTdmxCfZXMSaqjl/NqzPzM6WHWvScC7hlsYEemJoCYbpv
ybYlKLHc/VRsJMavtSMma+AxVr3buXmzkJDr3Ulba62U3dCSJ1mWw+ICLT9r3ciR
eCTajh7hH/YL0o3v+aazeFg3WJb3pxNE9/9Cgq0mMDbj1+j2NUxJsc+n/7Lq81CC
FGJNhqCaz0CwOkYLhKlomxhJUSUNSzEflsMiwErX9EVI6fq0doRrSpRFf63EPHVw
5yYKlC/Xit7blZt+OKpenS2rrf6S9O91D9mTYnjUi4xBADywl6x4OIXDYsBKSo7b
WDgTH1AhHZojCfC4xdWFfSLgc59riYqTrrWCKVotyRJPwQll0O73U/Ltbm2qT1Kv
UpDcsC71shJwX9NZvbdSYOX+Jcwkb/Z90cPiJxaSS4XnAxPowRatLyeh5uQFZ3b5
lgg4kmeb5sUXFbKOCt+4
=YUF3
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
