Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3GIGE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:04:58 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64936 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab3GIGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:04:57 -0400
Date: Tue, 9 Jul 2013 08:04:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: tegra: enable gpio-keys on dalmore
Message-ID: <20130709060447.GA17499@mithrandir>
References: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 06, 2013 at 02:44:29PM +0530, Laxman Dewangan wrote:
> Dalmore have the keys mounted on board which are connected
> to different pins of Tegra.
>=20
> Add the keys entry in DTS file to enable key functionality.
> This will enable KEY_POWER, KEY_HOME, KEY_VOLUMEUP and
> KEY_VOLUMEDOWN.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Reorder the nodes.
>=20
>  arch/arm/boot/dts/tegra114-dalmore.dts |   30 ++++++++++++++++++++++++++=
++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/t=
egra114-dalmore.dts
> index cb640eb..259b517 100644
> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
> @@ -883,6 +883,35 @@
>  		};
>  	};
> =20
> +	gpio-keys {
> +		compatible =3D "gpio-keys";
> +
> +		home {
> +			label =3D "Home";
> +			gpios =3D <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_LOW>;
> +			linux,code =3D <102>; /* KEY_HOME */

I wonder if these should maybe go into a header file as well so that
symbolic names can be used. That'll make the value self-descriptive and
allow the comment to be dropped.

> +		volume_down {
> +			label =3D "VolumeDown";
> +			gpios =3D <&gpio TEGRA_GPIO(R, 1) GPIO_ACTIVE_LOW>;
> +			linux,code =3D <114>; /* KEY_VOLUMEDOWN */
> +		};
> +
> +		volume_up {
> +			label =3D "VolumeUp";
> +			gpios =3D <&gpio TEGRA_GPIO(R, 2) GPIO_ACTIVE_LOW>;
> +			linux,code =3D <115>; /* KEY_VOLUMEUP */
> +		};
> +	};

Nit: Perhaps the labels should be "Volume Down" and "Volume Up" here?

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR26f/AAoJEN0jrNd/PrOh2/wP+gLTfq2anKTC6WRi8p29BWtv
a0PpZdpIn+4HN0eDRzw2huEk+ik1Te+SlLvb4YuVJxihEfWlx27lktx8gctTNhDr
5f7k+Y0EHOIPKqW73wPLeRGdrCZ0chUFmde7wNftlKbCMVw+ozJk4K7p/hKbfhr+
GdeELuNfe7Tc0ItOb2Q0uSxouQYUcWBQJYpcEu2gGXLOMX0RaCVvY/8KFBFwTmFL
pI0Ef7WFaek+HO9Nq6A6KZfAVb/a6YdOcWrUJyrIXNpSt5k8roOPF4p1wdGd0O0G
dwmsN/k1GaOD3w9BBYwXqvx7m0/Y+soLflGKZNP18OF1CXr6r0cDRB0mUkq1sAFL
dqYeI/51+2IovxYnSnC6oxXwC/sJgbpInp+fFtc2UMsrWxsr0j5DvOMT2ju1xvhc
ror8sw5gSt4YQHH6vt1B9W+dclyV9L9plxPDJl0v7p5QHKMSqCkh3FFQiYEvy7mM
nQNdi7SYkCCrmSxl3/TVtdDE1J2kwuHFQx3mQEXiirn3V4sGGsqAIsS+WNDEH+nb
Cbr5idbNjXSGnEp0Q/1zpa/v4MhrMOPh93OEUwnd8h7BaUjnfg+G5kkcBf5KxK0P
m4FjMm8stFemp5+0X5h/2azAe2FeyW6dQqi6WJDDrZdKdJETvG4CutEW/njFf/dC
ebCbQn//H0+2q4HVGRq+
=NrhK
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
