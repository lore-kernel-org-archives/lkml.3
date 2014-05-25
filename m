Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaEYTnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33602 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaEYTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:12 -0400
Date: Sun, 25 May 2014 21:14:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 17/22] mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
Message-ID: <20140525191434.GX10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-18-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Weqbz6OltVu8XOAh"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-18-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:20PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
> The differences are the AR100 clock can no longer be modified,
> and the APB0 clock has different divisors.
>=20
> This patch adds a compatible with a modified subdevice list for
> the A23.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
>  drivers/mfd/sun6i-prcm.c                           | 30 ++++++++++++++++=
++++++
>  2 files changed, 31 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Docum=
entation/devicetree/bindings/mfd/sun6i-prcm.txt
> index 1f5a31f..03c5a55 100644
> --- a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> +++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> @@ -4,7 +4,7 @@ PRCM is an MFD device exposing several Power Management r=
elated devices
>  (like clks and reset controllers).
> =20
>  Required properties:
> - - compatible: "allwinner,sun6i-a31-prcm"
> + - compatible: "allwinner,sun6i-a31-prcm" or "allwinner,sun8i-a23-prcm"
>   - reg: The PRCM registers range
> =20
>  The prcm node may contain several subdevices definitions:
> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
> index 718fc4d..c96bb6c 100644
> --- a/drivers/mfd/sun6i-prcm.c
> +++ b/drivers/mfd/sun6i-prcm.c
> @@ -76,16 +76,46 @@ static const struct mfd_cell sun6i_a31_prcm_subdevs[]=
 =3D {
>  	},
>  };
> =20
> +static const struct mfd_cell sun8i_a23_prcm_subdevs[] =3D {
> +	{
> +		.name =3D "sun6i-a31-apb0-clk",
> +		.of_compatible =3D "allwinner,sun8i-a23-apb0-clk",
> +		.num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_clk_res),
> +		.resources =3D sun6i_a31_apb0_clk_res,
> +	},
> +	{
> +		.name =3D "sun6i-a31-apb0-gates-clk",
> +		.of_compatible =3D "allwinner,sun6i-a31-apb0-gates-clk",
> +		.num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_gates_clk_res),
> +		.resources =3D sun6i_a31_apb0_gates_clk_res,
> +	},

Did I just have a brainfart, or didn't you just introduced an
sun8i-a23-apb0-gates-clk driver?

And there's no ar100 and ahb0 clocks ?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Weqbz6OltVu8XOAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkEaAAoJEBx+YmzsjxAgDjAP/14ADdfM3OEQ89R98ZQhSDup
cekxfCSN2yBy2dHqP8jOQXpHQu4ve7W8ut0/73/slMK0+n9uS6aDYYxUPUjxAPBX
i2lenu/LfxomF7XbE54WPtk5DajboVaGIR8md4KkxIM35cj7ZRAZm2oZp0+fMVgb
fqZzWkoRytpneKcE3ARIT7LN/zqqiwHYfoxyY4tHv77cKF/kfrpQuSa7hz9OIHj8
mlNUy9/iMaFrCjELTiitJyRbzSKXRP97tRUJtoZXBgTBXd7OlZu6SJlvxkGOKLgI
oQb22Etu/+CJQ8lRz9gIr29wx71H3zRAA+4813niilVBJHdxJUOmeLnPSrWoZbAr
PtWEkv/dDs5jIwt8hJXBNzN3Y/ZBMqOf0GE2KKn6ma7PlMkI2CRP3guCt9ZpWy8U
ZawT9OK2XjazgLQFcr0xhs2yccN0h/yTSCtoMkzRTyuXjHb8JlVdFkXXDdenGj2a
0LBpzFjBW97XfBfQKlVAObBSLAIQy8Zh/7R5g5edG9LfF2uWFmHsNBXVUUHO+J/d
LMGmastCgCNvUFQCmjysVkoPt/h8uwPwARqbPa5yFiRDNmix3dsLL/aHp/Til1cv
Gi/cglirUfSj9t1LUiGotJ+y+6UpEvUYSLKGPUUA7OuWOa7djbUVP9ZA6P9Ww+i2
Ijk/nyY73rBEtUum9rU1
=BfFL
-----END PGP SIGNATURE-----

--Weqbz6OltVu8XOAh--
