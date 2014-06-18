Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbaFRKaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:30:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52385 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965463AbaFRKaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:30:04 -0400
Date: Wed, 18 Jun 2014 12:26:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 12/20] clk: sunxi: Add A23 APB0 support to
 sun6i-a31-apb0-clk
Message-ID: <20140618102623.GQ19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-13-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R4+lwT0Y15rLnKR0"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-13-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R4+lwT0Y15rLnKR0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:49PM +0800, Chen-Yu Tsai wrote:
> The A23 has an almost identical PRCM clock tree. The difference in
> the APB0 clock is the smallest divisor is 1, instead of 2.
>=20
> This patch extends the sun6i-a31-apb0-clk driver to take divider
> tables associated to compatibles, and adds a compatible for the A23
> variant.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>  drivers/clk/sunxi/clk-sun6i-apb0.c                | 28 +++++++++++++++++=
+-----
>  2 files changed, 23 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index af9e47d..e3a47ec 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -28,6 +28,7 @@ Required properties:
>  	"allwinner,sun8i-a23-ahb1-gates-clk" - for the AHB1 gates on A23
>  	"allwinner,sun4i-a10-apb0-clk" - for the APB0 clock
>  	"allwinner,sun6i-a31-apb0-clk" - for the APB0 clock on A31
> +	"allwinner,sun8i-a23-apb0-clk" - for the APB0 clock on A23
>  	"allwinner,sun4i-a10-apb0-gates-clk" - for the APB0 gates on A10
>  	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
>  	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
> diff --git a/drivers/clk/sunxi/clk-sun6i-apb0.c b/drivers/clk/sunxi/clk-s=
un6i-apb0.c
> index 11f17c3..2197ac7 100644
> --- a/drivers/clk/sunxi/clk-sun6i-apb0.c
> +++ b/drivers/clk/sunxi/clk-sun6i-apb0.c
> @@ -11,6 +11,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
> =20
>  /*
> @@ -28,6 +29,21 @@ static const struct clk_div_table sun6i_a31_apb0_divs[=
] =3D {
>  	{ /* sentinel */ },
>  };
> =20
> +/* The A23 APB0 clock has a standard power of 2 divisor */

Why not just pass CLK_DIVIDER_POWER_OF_TWO then, instead of a table?

> +static const struct clk_div_table sun8i_a23_apb0_divs[] =3D {
> +	{ .val =3D 0, .div =3D 1, },
> +	{ .val =3D 1, .div =3D 2, },
> +	{ .val =3D 2, .div =3D 4, },
> +	{ .val =3D 3, .div =3D 8, },
> +	{ /* sentinel */ },
> +};
> +
> +const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] =3D {
> +	{ .compatible =3D "allwinner,sun6i-a31-apb0-clk", .data =3D &sun6i_a31_=
apb0_divs },
> +	{ .compatible =3D "allwinner,sun8i-a23-apb0-clk", .data =3D &sun8i_a23_=
apb0_divs },
> +	{ /* sentinel */ }
> +};
> +
>  static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np =3D pdev->dev.of_node;
> @@ -36,12 +52,17 @@ static int sun6i_a31_apb0_clk_probe(struct platform_d=
evice *pdev)
>  	struct resource *r;
>  	void __iomem *reg;
>  	struct clk *clk;
> +	const struct of_device_id *device;
> =20
>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	reg =3D devm_ioremap_resource(&pdev->dev, r);
>  	if (IS_ERR(reg))
>  		return PTR_ERR(reg);
> =20
> +	device =3D of_match_device(sun6i_a31_apb0_clk_dt_ids, &pdev->dev);
> +	if (!device)
> +		return -EINVAL;
> +
>  	clk_parent =3D of_clk_get_parent_name(np, 0);
>  	if (!clk_parent)
>  		return -EINVAL;
> @@ -49,7 +70,7 @@ static int sun6i_a31_apb0_clk_probe(struct platform_dev=
ice *pdev)
>  	of_property_read_string(np, "clock-output-names", &clk_name);
> =20
>  	clk =3D clk_register_divider_table(&pdev->dev, clk_name, clk_parent,
> -					 0, reg, 0, 2, 0, sun6i_a31_apb0_divs,
> +					 0, reg, 0, 2, 0, device->data,

I'm not sure that it will actually work for the A31, since it does
define some dividers anyway, and the divider table is !NULL, even
though there's actually no dividers defined.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--R4+lwT0Y15rLnKR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToWlPAAoJEBx+YmzsjxAgwVEP/3tdU3z7xESNhDgdVFZHoQJ6
wGutWyCvHqGT7mM1crhr9aIskJV22hUM5sNjNMfq5+VMXpmaL0mKy74ASsLC1aAN
Eh+OvQz7NSJMp8je+aCHWfBuqshRD5hzQFcrXDkli3xOJ7tqOtXbSZd4xCB6anBd
N56OEYbtYUGjvu05BSauXJWx8x9hjuGChs9Zxmjyz1AkUOpsNROwH9y9B2KMQKlc
IM/9z+Yn/rz6eF64/SKPbxyF+VG26KZZeg1m4lA2kZrDxBoC4iPGbRUXBZTfFFfX
yA4UzweZQfYj3T+dSFE6ud6V3T7brKTCK/T9y8EP/YNADR6bdLTIjspwpnPQEhdh
cE/khIh7+PnLmSDvN7njtLcYxREEK/V/+UYLyGtkvl4pxU7YyZFuG7XNEtBOad4O
2KYsqh0/cpMv3UurbpmSObmui9JdL4JKmswYAVuUpxbjWWD/uAJiBqH3mhvQhKN/
sF32AxCRhSyW5cL9v2E51UtWO9evGC4uOWRc1oBtia4a0TfOHxcYJE/sDlBaKSdO
DIbDbE78BuwPuZ1Dp0pTD5DcfI0S58dXQ89lRbv/9vbX7BHJ+Ac4ZLCoqaKz3AZE
gGGxf+QpqO3ihFBzMQhfnZJaYtETjtwiHBtadVeqtYGoEC2qqoUJvgmwmxi9hxWb
1uzDMJ90rG8BWfIT39sM
=15ZY
-----END PGP SIGNATURE-----

--R4+lwT0Y15rLnKR0--
