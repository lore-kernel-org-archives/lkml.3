Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3LBJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:37:22 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61132 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3LBJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:37:18 -0500
Date: Mon, 2 Dec 2013 10:36:23 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] regulator: tps6586x: add and use correct voltage
 table
Message-ID: <20131202093622.GF17834@ulmo.nvidia.com>
References: <cover.1385913227.git.stefan@agner.ch>
 <77c960e6e3a91cf39bc866ccb9cd578ccc5acc95.1385913228.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27ZtN5FSuKKSZcBU"
Content-Disposition: inline
In-Reply-To: <77c960e6e3a91cf39bc866ccb9cd578ccc5acc95.1385913228.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--27ZtN5FSuKKSZcBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 01, 2013 at 04:59:14PM +0100, Stefan Agner wrote:
[...]

This looks pretty good generally. A few minor nits below...

> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/t=
ps6586x-regulator.c
[...]
> +#define tps658623_sm2_voltages tps6586x_ldo4_voltages
>  static const unsigned int tps6586x_ldo4_voltages[] =3D {
>  	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
>  	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,

I'd put the #define below the ldo4 table. This doesn't actually matter
for the preprocessor, but it makes it easier to read the code. Also an
additional blank line would help with readability.

> +	TPS6586X_LDO(LDO_0, "vinldo01", tps6586x_ldo0, SUPPLYV1, 5, 3, ENC, 0,
> +					END, 0),

Perhaps reduce the indentation here so there's more room in case this
ever needs to be extended?

> @@ -351,6 +380,7 @@ static int tps6586x_regulator_probe(struct platform_d=
evice *pdev)
>  	struct regulator_init_data *reg_data;
>  	struct tps6586x_platform_data *pdata;
>  	struct of_regulator_match *tps6586x_reg_matches =3D NULL;
> +	int reg_version;

Why the prefix "reg_"?

> @@ -373,10 +403,27 @@ static int tps6586x_regulator_probe(struct platform=
_device *pdev)
>  		return -ENOMEM;
>  	}
> =20
> +	reg_version =3D tps6586x_get_version(pdev->dev.parent);
> +
>  	for (id =3D 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
>  		reg_data =3D pdata->reg_init_data[id];
> =20
> -		ri =3D find_regulator_info(id);
> +		switch(reg_version) {
> +		case TPS658623:
> +			ri =3D find_regulator_info(id, tps658623_regulator,
> +					ARRAY_SIZE(tps658623_regulator));
> +			break;
> +		case TPS658643:
> +			ri =3D find_regulator_info(id, tps658643_regulator,
> +					ARRAY_SIZE(tps658643_regulator));
> +			break;
> +		}

Perhaps instead of repeating the function calls this could be:

		switch (version) {
		case TPS6586XYZ:
			num =3D ARRAY_SIZE(tps6586xyz_regulator);
			table =3D tps6586xys_regulator;
			break;

		...
		}

		if (table)
			ri =3D find_regulator_info(id, table, num);

That's slightly longer, but I find that to be more intuitive. Perhaps
a bit more future-proof since you only have a single call. But that's
perhaps subjective, so I'm fine with your alternative, too.

Thierry

--27ZtN5FSuKKSZcBU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnFSWAAoJEN0jrNd/PrOhrEQP/3uNWtcMpj9OCU/q1L8dm+fX
KWnlPOobRJ3HQ32D3dtBaMi2WDoKFvobEy2PkkPImuAPccqA1cYQcBucyicwjq0f
QjEtLw1Pyp4rHhCSUVhNIftAdDCS9Uouxg69TdBwl4JlW3XDIQ0AUkppbSjZJ8Xd
gLx2b7tW9K1Cy2jniiLnNh2lg6+Hg4L8PMqqCGUSv5wXYCkpj+EE1CjKrgcHFI0J
AMoVwxFV0sJXw65m69Qrre1gM9s8O6C3lP3aZ3U7FXG2jn1iXJE1978MBT6Jpv+S
0tAv57QSFlXCuPJJdPVHjQkYjWYrP3QPSctOew+d5Hal4dJvbSZPNKiPoCVze3oB
nP+BI+5oyZDG0s8nvFKXr/Awnb9tPTQR0PDJTey0Q1vaD6rgH6mmW1b6fHrQGANe
28Gr/FIjxKWUnY3f943JGIGp3metbn1OlDppnX6QlPaif6rIEf/f1qbFFE/ZkhnV
p79ve8ufOT2Us3HpJ1bD56KZWTcwXyPao295a/SuwU+sQXmq4Hfibg72GV/L+DWI
GmiVOPoINfxzysqt7S1gEKuMOg4Q3Z+nmbagEagpwZdnirsiLeMkCygpGpm150wA
oOHDTVu5qBWktjfUmy7+AbCSTZQWtAJqAtQgmCEpNuzxezg14Blarv69VdZM/2lB
nI/fXMQyUaPfSD6JOhpp
=zza/
-----END PGP SIGNATURE-----

--27ZtN5FSuKKSZcBU--
