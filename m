Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaHMHhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:37:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49252 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMHhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:37:41 -0400
Date: Wed, 13 Aug 2014 09:37:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: tegra: Add PMC thermtrip programming to Jetson
 TK1 device tree
Message-ID: <20140813073736.GB17466@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <1407226380-747-3-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <1407226380-747-3-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 11:12:59AM +0300, Mikko Perttunen wrote:
> This adds the required information to reset the board during an overheati=
ng
> situation to the Jetson TK1 device tree. The thermal reset is handled by =
the
> PMC by sending an I2C message to the PMIC. The entries specify the I2C
> message to be sent.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dt=
s/tegra124-jetson-tk1.dts
> index 624b0fb..ee178c4 100644
> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> @@ -1617,6 +1617,11 @@
>  		nvidia,core-pwr-off-time =3D <61036>;
>  		nvidia,core-power-req-active-high;
>  		nvidia,sys-clock-req-active-high;
> +
> +		nvidia,thermtrip-pmu-i2c-addr =3D <0x40>;
> +		nvidia,thermtrip-i2c-controller =3D <4>;
> +		nvidia,thermtrip-reg-addr =3D <0x36>;
> +		nvidia,thermtrip-reg-data =3D <0x2>;

Given the number of properties that this can potentially have, I wonder
if perhaps it would be a good idea to put this into a subnode, like
this:

		thermtrip {
			pmu-i2c-addr =3D <0x40>;
			i2c-controller =3D <4>;
			...
		};

Thierry

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xXAAAoJEN0jrNd/PrOhVuEQAJGtXyrXJ6S1mOGT9sl7wXlk
kjIxXS3ECkEVnJoaWrTtRsOOmIhbkQNBX4/j9b310HP6iwiZa7xWOrrxkf5XQM8i
MD95BQERIak/LihVZ2NRvPTkESHSQyx0Aig4OAqQvcD99cztqZwEZTbGJ1Yoiy+z
So5D+1Ye5MKO54SRPWILzHg14HkpiP456eg1BAq/J0RWZW8fNwmApyHoYF68Jtnz
noJzfMAlRuFxLrw/fSaWolHegseVQ/V6oPAABobNWfeyhRxWTH+YMM5zi1PnxWlq
H65z9DW1hGBjfVwhrsahiv9qoJ263uMem3nJOuyz7E15ehamTTk0yelLMYjutqjZ
3UHipfKQSVTchqfxG6RonhN9vYrroHgIaeg2IdDB5R1D2XqzwMlweVz63ehsX9/w
+PNYrX2M01cuvGrkurxg++R0ldsH+WpdKndiOmpC1L9/TQcBdUIqIlmXe7XeJ4GO
cyutFSG5oMZVJOkWckwOZboS9M/YgtJgO05CsiDpTbWZjCzARJceVBJ6WKLfgJRH
iocbAK2C/cjMUGKi5kbRP07baMcsWXMfuyfLg7uzY5kwg3jSJ5Pyi/5nAHoVr0qG
Suv3bpFVMLHuo3/zC+J37K9SPyT+2GKcce5ZyeMB5DjduK/lQx9EjLESrsGHP7Dk
L/IZ9joKTdYlwfVCgTIk
=PmKx
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
