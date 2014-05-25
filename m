Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaEYTm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33568 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbaEYTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:53 -0400
Date: Sun, 25 May 2014 21:05:37 +0200
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
Subject: Re: [PATCH 13/22] clk: sunxi: Add A23 clocks support
Message-ID: <20140525190537.GU10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-14-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+k4Drb7WGefOwc9B"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-14-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+k4Drb7WGefOwc9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:16PM +0800, Chen-Yu Tsai wrote:
> The clock control unit on the A23 is similar to the one found on the A31.
>=20
> The AHB1, APB1, APB2 gates on the A23 are almost identical to the ones
> on the A31, but some outputs are missing.
>=20
> The main CPU PLL (PLL1) however is like that on older Allwinner SoCs, such
> as the A10 or A20, but the N factor starts from 1 instead of 0.
>=20
> This patch adds support for PLL1 and all the basic clock gates.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |  4 ++
>  drivers/clk/sunxi/clk-sunxi.c                     | 83 +++++++++++++++++=
++++++
>  2 files changed, 87 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index ae18ec1..fa927ba 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -9,6 +9,7 @@ Required properties:
>  	"allwinner,sun4i-a10-osc-clk" - for a gatable oscillator
>  	"allwinner,sun4i-a10-pll1-clk" - for the main PLL clock and PLL4
>  	"allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
> +	"allwinner,sun8i-a23-pll1-clk" - for the main PLL clock on A23
>  	"allwinner,sun4i-a10-pll5-clk" - for the PLL5 clock
>  	"allwinner,sun4i-a10-pll6-clk" - for the PLL6 clock
>  	"allwinner,sun6i-a31-pll6-clk" - for the PLL6 clock on A31
> @@ -25,6 +26,7 @@ Required properties:
>  					      AHB1 on A31
>  	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
>  	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
> +	"allwinner,sun8i-a23-ahb1-gates-clk" - for the AHB1 gates on A23
>  	"allwinner,sun4i-a10-apb0-clk" - for the APB0 clock
>  	"allwinner,sun6i-a31-apb0-clk" - for the APB0 clock on A31
>  	"allwinner,sun4i-a10-apb0-gates-clk" - for the APB0 gates on A10
> @@ -39,8 +41,10 @@ Required properties:
>  	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
>  	"allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
>  	"allwinner,sun7i-a20-apb1-gates-clk" - for the APB1 gates on A20
> +	"allwinner,sun8i-a23-apb1-gates-clk" - for the APB1 gates on A23
>  	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
>  	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
> +	"allwinner,sun8i-a23-apb2-gates-clk" - for the APB2 gates on A23
>  	"allwinner,sun4i-a10-mod0-clk" - for the module 0 family of clocks
>  	"allwinner,sun7i-a20-out-clk" - for the external output clocks
>  	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 89eadbc..1d16c0c 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -164,6 +164,54 @@ static void sun6i_a31_get_pll1_factors(u32 *freq, u3=
2 parent_rate,
>  }
> =20
>  /**
> + * sun8i_a23_get_pll1_factors() - calculates n, k, m, p factors for PLL1
> + * PLL1 rate is calculated as follows
> + * rate =3D (parent_rate * (n + 1) * (k + 1) >> p) / (m + 1);
> + * parent_rate is always 24Mhz
> + */
> +
> +static void sun8i_a23_get_pll1_factors(u32 *freq, u32 parent_rate,
> +				   u8 *n, u8 *k, u8 *m, u8 *p)
> +{
> +	u8 div;
> +
> +	/* Normalize value to a 6M multiple */
> +	div =3D *freq / 6000000;
> +	*freq =3D 6000000 * div;
> +
> +	/* we were called to round the frequency, we can now return */
> +	if (n =3D=3D NULL)
> +		return;
> +
> +	/* m is always zero for pll1 */
> +	*m =3D 0;
> +
> +	/* k is 1 only on these cases */
> +	if (*freq >=3D 768000000 || *freq =3D=3D 42000000 || *freq =3D=3D 54000=
000)
> +		*k =3D 1;
> +	else
> +		*k =3D 0;
> +
> +	/* p will be 2 for divs under 20 and odd divs under 32 */
> +	if (div < 20 || (div < 32 && (div & 1)))
> +		*p =3D 2;
> +
> +	/* p will be 1 for even divs under 32, divs under 40 and odd pairs
> +	 * of divs between 40-62 */
> +	else if (div < 40 || (div < 64 && (div & 2)))
> +		*p =3D 1;
> +
> +	/* any other entries have p =3D 0 */
> +	else
> +		*p =3D 0;
> +
> +	/* calculate a suitable n based on k and p */
> +	div <<=3D *p;
> +	div /=3D (*k + 1);
> +	*n =3D div / 4 - 1;
> +}
> +
> +/**
>   * sun4i_get_pll5_factors() - calculates n, k factors for PLL5
>   * PLL5 rate is calculated as follows
>   * rate =3D parent_rate * n * (k + 1)
> @@ -422,6 +470,18 @@ static struct clk_factors_config sun6i_a31_pll1_conf=
ig =3D {
>  	.mwidth =3D 2,
>  };
> =20
> +static struct clk_factors_config sun8i_a23_pll1_config =3D {
> +	.nshift =3D 8,
> +	.nwidth =3D 5,
> +	.kshift =3D 4,
> +	.kwidth =3D 2,
> +	.mshift =3D 0,
> +	.mwidth =3D 2,
> +	.pshift =3D 16,
> +	.pwidth =3D 2,
> +	.n_from_one =3D 1,
> +};
> +
>  static struct clk_factors_config sun4i_pll5_config =3D {
>  	.nshift =3D 8,
>  	.nwidth =3D 5,
> @@ -472,6 +532,12 @@ static const struct factors_data sun6i_a31_pll1_data=
 __initconst =3D {
>  	.getter =3D sun6i_a31_get_pll1_factors,
>  };
> =20
> +static const struct factors_data sun8i_a23_pll1_data __initconst =3D {
> +	.enable =3D 31,
> +	.table =3D &sun8i_a23_pll1_config,
> +	.getter =3D sun8i_a23_get_pll1_factors,
> +};
> +
>  static const struct factors_data sun7i_a20_pll4_data __initconst =3D {
>  	.enable =3D 31,
>  	.table =3D &sun4i_pll5_config,
> @@ -812,6 +878,10 @@ static const struct gates_data sun7i_a20_ahb_gates_d=
ata __initconst =3D {
>  	.mask =3D { 0x12f77fff, 0x16ff3f },
>  };
> =20
> +static const struct gates_data sun8i_a23_ahb1_gates_data __initconst =3D=
 {
> +	.mask =3D {0x25386742, 0x2505111},
> +};
> +
>  static const struct gates_data sun4i_apb0_gates_data __initconst =3D {
>  	.mask =3D {0x4EF},
>  };
> @@ -844,6 +914,10 @@ static const struct gates_data sun6i_a31_apb1_gates_=
data __initconst =3D {
>  	.mask =3D {0x3031},
>  };
> =20
> +static const struct gates_data sun8i_a23_apb1_gates_data __initconst =3D=
 {
> +	.mask =3D {0x3021},
> +};
> +
>  static const struct gates_data sun6i_a31_apb2_gates_data __initconst =3D=
 {
>  	.mask =3D {0x3F000F},
>  };
> @@ -852,6 +926,10 @@ static const struct gates_data sun7i_a20_apb1_gates_=
data __initconst =3D {
>  	.mask =3D { 0xff80ff },
>  };
> =20
> +static const struct gates_data sun8i_a23_apb2_gates_data __initconst =3D=
 {
> +	.mask =3D {0x1F0007},
> +};
> +
>  static const struct gates_data sun4i_a10_usb_gates_data __initconst =3D {
>  	.mask =3D {0x1C0},
>  	.reset_mask =3D 0x07,
> @@ -1122,6 +1200,7 @@ free_clkdata:
>  static const struct of_device_id clk_factors_match[] __initconst =3D {
>  	{.compatible =3D "allwinner,sun4i-a10-pll1-clk", .data =3D &sun4i_pll1_=
data,},
>  	{.compatible =3D "allwinner,sun6i-a31-pll1-clk", .data =3D &sun6i_a31_p=
ll1_data,},
> +	{.compatible =3D "allwinner,sun8i-a23-pll1-clk", .data =3D &sun8i_a23_p=
ll1_data,},
>  	{.compatible =3D "allwinner,sun7i-a20-pll4-clk", .data =3D &sun7i_a20_p=
ll4_data,},
>  	{.compatible =3D "allwinner,sun4i-a10-apb1-clk", .data =3D &sun4i_apb1_=
data,},
>  	{.compatible =3D "allwinner,sun4i-a10-mod0-clk", .data =3D &sun4i_mod0_=
data,},
> @@ -1163,6 +1242,7 @@ static const struct of_device_id clk_gates_match[] =
__initconst =3D {
>  	{.compatible =3D "allwinner,sun5i-a13-ahb-gates-clk", .data =3D &sun5i_=
a13_ahb_gates_data,},
>  	{.compatible =3D "allwinner,sun6i-a31-ahb1-gates-clk", .data =3D &sun6i=
_a31_ahb1_gates_data,},
>  	{.compatible =3D "allwinner,sun7i-a20-ahb-gates-clk", .data =3D &sun7i_=
a20_ahb_gates_data,},
> +	{.compatible =3D "allwinner,sun8i-a23-ahb1-gates-clk", .data =3D &sun8i=
_a23_ahb1_gates_data,},
>  	{.compatible =3D "allwinner,sun4i-a10-apb0-gates-clk", .data =3D &sun4i=
_apb0_gates_data,},
>  	{.compatible =3D "allwinner,sun5i-a10s-apb0-gates-clk", .data =3D &sun5=
i_a10s_apb0_gates_data,},
>  	{.compatible =3D "allwinner,sun5i-a13-apb0-gates-clk", .data =3D &sun5i=
_a13_apb0_gates_data,},
> @@ -1172,7 +1252,9 @@ static const struct of_device_id clk_gates_match[] =
__initconst =3D {
>  	{.compatible =3D "allwinner,sun5i-a13-apb1-gates-clk", .data =3D &sun5i=
_a13_apb1_gates_data,},
>  	{.compatible =3D "allwinner,sun6i-a31-apb1-gates-clk", .data =3D &sun6i=
_a31_apb1_gates_data,},
>  	{.compatible =3D "allwinner,sun7i-a20-apb1-gates-clk", .data =3D &sun7i=
_a20_apb1_gates_data,},
> +	{.compatible =3D "allwinner,sun8i-a23-apb1-gates-clk", .data =3D &sun8i=
_a23_apb1_gates_data,},
>  	{.compatible =3D "allwinner,sun6i-a31-apb2-gates-clk", .data =3D &sun6i=
_a31_apb2_gates_data,},
> +	{.compatible =3D "allwinner,sun8i-a23-apb2-gates-clk", .data =3D &sun8i=
_a23_apb2_gates_data,},
>  	{.compatible =3D "allwinner,sun4i-a10-usb-clk", .data =3D &sun4i_a10_us=
b_gates_data,},
>  	{.compatible =3D "allwinner,sun5i-a13-usb-clk", .data =3D &sun5i_a13_us=
b_gates_data,},
>  	{.compatible =3D "allwinner,sun6i-a31-usb-clk", .data =3D &sun6i_a31_us=
b_gates_data,},
> @@ -1261,3 +1343,4 @@ static void __init sun6i_init_clocks(void)
>  			  ARRAY_SIZE(sun6i_critical_clocks));
>  }
>  CLK_OF_DECLARE(sun6i_a31_clk_init, "allwinner,sun6i-a31", sun6i_init_clo=
cks);
> +CLK_OF_DECLARE(sun8i_a23_clk_init, "allwinner,sun8i-a23", sun6i_init_clo=
cks);

Ah, this is why you needed pll6 in the A31 array.

Why don't you just create a new array and init function for the A23?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+k4Drb7WGefOwc9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgj8BAAoJEBx+YmzsjxAg0BoP/2rTVt96Qp0Qt7V4EpXWDHfH
Yv7uL1Q5fhZmzbNhaTnUFXWiI24d9KWKIalW+5Fpq34Dut59MyC0F2tJQQ9fOkGw
IL76LZT2XUzpVsm3D/b2nJPW/bQQiSEfUTHWXkA5afbkuf/KAfyQCtyGVsgBhACm
vxei7vcfiQ15sYNehaZ5j7Uit77lYd2138LSkUBFQVTNy4JE+gOE5zISUTflWxVE
N009wyA0SQhS7OEkIcxcJqykDbEfv+o4nSxojXLJviseoS+mrs/ImWSDOS82MPco
cg1qd5L9pEIPoq3Io1+KkdeELX54VD8GRP+ZXNZv169H2FEa4ZqHOY8AMZ6rAUF4
JoJSJNc4/cnWMHdLMtl+Eu7KfMWm9cdxrx2OLTm5+a2YxF5PGPovecEFLwzj2Zdy
lbThXrk1DhgONOoQnOrgdx0WbBhuKti9UWOvyGKBLfxivLbcrpxcuNx6UFCIBmb9
fWoomyKVqmFKS/LU54oS5VaFPWSKC6bD0L9VTjsBlQRnvKUJN1CBhaetVW48fw/K
Bk+chdcgK4dABd2lbU0+RcOAwF3eOTmpRMJR1bKjbwCrNvRSDK10hTMueiMbZPdr
5l1SQG6t21TfwbrOutcm5O0VALP/IMfznmQac3/bjsRQtt15i+3DpRxl5JpDpdkD
Sx0cDmm/Dwrb2j/b7WOm
=vBOY
-----END PGP SIGNATURE-----

--+k4Drb7WGefOwc9B--
