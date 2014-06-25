Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaFYUZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:25:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39019 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833AbaFYUZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:25:10 -0400
Date: Wed, 25 Jun 2014 22:20:29 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 5/6] clk: sunxi: Add A23 clocks support
Message-ID: <20140625202029.GJ19569@lukather>
References: <1403603980-31101-1-git-send-email-wens@csie.org>
 <1403603980-31101-6-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJFRpmOek+ZRSQoz"
Content-Disposition: inline
In-Reply-To: <1403603980-31101-6-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJFRpmOek+ZRSQoz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 05:59:39PM +0800, Chen-Yu Tsai wrote:
> The clock control unit on the A23 is similar to the one found on the A31.
>=20
> The AHB1, APB1, APB2 gates on the A23 are almost identical to the ones
> on the A31, but some outputs are missing.
>=20
> The main CPU PLL (PLL1) however is like that on older Allwinner SoCs,
> such as the A10 or A20, but the N factor starts from 1 instead of 0.
>=20
> This patch adds support for PLL1 and all the basic clock muxes and gates.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |   5 ++
>  drivers/clk/sunxi/clk-sunxi.c                     | 103 ++++++++++++++++=
++++++
>  2 files changed, 108 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index b9ec668..18030ce 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -9,11 +9,13 @@ Required properties:
>  	"allwinner,sun4i-a10-osc-clk" - for a gatable oscillator
>  	"allwinner,sun4i-a10-pll1-clk" - for the main PLL clock and PLL4
>  	"allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
> +	"allwinner,sun8i-a23-pll1-clk" - for the main PLL clock on A23
>  	"allwinner,sun4i-a10-pll5-clk" - for the PLL5 clock
>  	"allwinner,sun4i-a10-pll6-clk" - for the PLL6 clock
>  	"allwinner,sun6i-a31-pll6-clk" - for the PLL6 clock on A31
>  	"allwinner,sun4i-a10-cpu-clk" - for the CPU multiplexer clock
>  	"allwinner,sun4i-a10-axi-clk" - for the AXI clock
> +	"allwinner,sun8i-a23-axi-clk" - for the AXI clock on A23
>  	"allwinner,sun4i-a10-axi-gates-clk" - for the AXI gates
>  	"allwinner,sun4i-a10-ahb-clk" - for the AHB clock
>  	"allwinner,sun4i-a10-ahb-gates-clk" - for the AHB gates on A10
> @@ -23,6 +25,7 @@ Required properties:
>  	"allwinner,sun6i-a31-ar100-clk" - for the AR100 on A31
>  	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
>  	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
> +	"allwinner,sun8i-a23-ahb1-gates-clk" - for the AHB1 gates on A23
>  	"allwinner,sun4i-a10-apb0-clk" - for the APB0 clock
>  	"allwinner,sun6i-a31-apb0-clk" - for the APB0 clock on A31
>  	"allwinner,sun4i-a10-apb0-gates-clk" - for the APB0 gates on A10
> @@ -37,8 +40,10 @@ Required properties:
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
> index 6fe9492..d4832a7 100644
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
> +	.n_start =3D 1,
> +};
> +
>  static struct clk_factors_config sun4i_pll5_config =3D {
>  	.nshift =3D 8,
>  	.nwidth =3D 5,
> @@ -471,6 +531,12 @@ static const struct factors_data sun6i_a31_pll1_data=
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
> @@ -673,6 +739,25 @@ static const struct div_data sun4i_axi_data __initco=
nst =3D {
>  	.width	=3D 2,
>  };
> =20
> +static const struct clk_div_table sun8i_a23_axi_table[] __initconst =3D {
> +	{ .val =3D 0, .div =3D 1 },
> +	{ .val =3D 1, .div =3D 2 },
> +	{ .val =3D 2, .div =3D 3 },
> +	{ .val =3D 3, .div =3D 4 },
> +	{ .val =3D 4, .div =3D 4 },
> +	{ .val =3D 5, .div =3D 4 },
> +	{ .val =3D 6, .div =3D 4 },
> +	{ .val =3D 7, .div =3D 4 },
> +	{ } /* sentinel */
> +};
> +
> +static const struct div_data sun8i_a23_axi_data __initconst =3D {
> +	.shift	=3D 0,
> +	.pow	=3D 0,

These are the default value.

> +	.width	=3D 3,
> +	.table	=3D sun8i_a23_axi_table,
> +};
> +
>  static const struct div_data sun4i_ahb_data __initconst =3D {
>  	.shift	=3D 4,
>  	.pow	=3D 1,
> @@ -805,6 +890,10 @@ static const struct gates_data sun7i_a20_ahb_gates_d=
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
> @@ -837,6 +926,10 @@ static const struct gates_data sun6i_a31_apb1_gates_=
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
> @@ -845,6 +938,10 @@ static const struct gates_data sun7i_a20_apb1_gates_=
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
> @@ -1100,6 +1197,7 @@ free_clkdata:
>  static const struct of_device_id clk_factors_match[] __initconst =3D {
>  	{.compatible =3D "allwinner,sun4i-a10-pll1-clk", .data =3D &sun4i_pll1_=
data,},
>  	{.compatible =3D "allwinner,sun6i-a31-pll1-clk", .data =3D &sun6i_a31_p=
ll1_data,},
> +	{.compatible =3D "allwinner,sun8i-a23-pll1-clk", .data =3D &sun8i_a23_p=
ll1_data,},
>  	{.compatible =3D "allwinner,sun7i-a20-pll4-clk", .data =3D &sun7i_a20_p=
ll4_data,},
>  	{.compatible =3D "allwinner,sun6i-a31-pll6-clk", .data =3D &sun6i_a31_p=
ll6_data,},
>  	{.compatible =3D "allwinner,sun4i-a10-apb1-clk", .data =3D &sun4i_apb1_=
data,},
> @@ -1111,6 +1209,7 @@ static const struct of_device_id clk_factors_match[=
] __initconst =3D {
>  /* Matches for divider clocks */
>  static const struct of_device_id clk_div_match[] __initconst =3D {
>  	{.compatible =3D "allwinner,sun4i-a10-axi-clk", .data =3D &sun4i_axi_da=
ta,},
> +	{.compatible =3D "allwinner,sun8i-a23-axi-clk", .data =3D &sun8i_a23_ax=
i_data,},
>  	{.compatible =3D "allwinner,sun4i-a10-ahb-clk", .data =3D &sun4i_ahb_da=
ta,},
>  	{.compatible =3D "allwinner,sun4i-a10-apb0-clk", .data =3D &sun4i_apb0_=
data,},
>  	{.compatible =3D "allwinner,sun6i-a31-apb2-div-clk", .data =3D &sun6i_a=
31_apb2_div_data,},
> @@ -1140,6 +1239,7 @@ static const struct of_device_id clk_gates_match[] =
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
> @@ -1149,7 +1249,9 @@ static const struct of_device_id clk_gates_match[] =
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
> @@ -1236,3 +1338,4 @@ static void __init sun6i_init_clocks(struct device_=
node *node)
>  			  ARRAY_SIZE(sun6i_critical_clocks));
>  }
>  CLK_OF_DECLARE(sun6i_a31_clk_init, "allwinner,sun6i-a31", sun6i_init_clo=
cks);
> +CLK_OF_DECLARE(sun8i_a23_clk_init, "allwinner,sun8i-a23", sun6i_init_clo=
cks);
> --=20
> 2.0.0
>=20

Looks fine otherwise,

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--IJFRpmOek+ZRSQoz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqy8NAAoJEBx+YmzsjxAgy1EP/j9YZC4Wm/x3U6RPhLNCOJwM
6clLmal2O3J+1dkr125RD6ltzXQpnL89buUW/DiO4kRmyoZ08SuFDLqumiNTNyo1
faVoS1zCqwDmLTlpjSfGwxB1Oj5r5H3k2DPe0MtxAyzHh44fi27qJkjpY8zpixlu
mH4zherNTRfr9yPasaz+zpS5ONo3fZIqyAWa+KU5e+eKO/tAD7iJDMNnnCRuj1xG
btN2VD2HDnrcVj5jUO+RWeRibHexatwyAusMpr2VwRuL8yYNjCISkRABOeK8fBzp
kiFP8QwVNYrqXFErxkuC5X5OILgxuVofpZPxfrkToNF8vHhOuAXGWVv5ooEXAbl1
ZnPzX+WbfbW7JDF8Keu9TsQnYy3zPUbhId7SFaPjU1dOlk4jVS1N/Vk7TBeGGmCD
P1dKq9gByBSV8mZLYkYk1LYNu+jPUKZEYMADiNMPu+8JJ6oDQUVR9a7NQXTNG5A/
12S8U6KBHABU01afRONlYEdS4XJ3RXzHVW0Jiabx1emer62yHEpoYIaDHbxQ0fks
bVimq334PFTAxsRbjknKHHWVQUjiG0rxhx8uyIjwipJTipJf+eWFYTdmCXlxaMYA
DUyxJxtB5W3ZdyeNYDM+gNkzTP2JwYAh63TsW/TouQ0hQ6KjmeLWqOIVlYoXadaL
nS3UzMOt8hEl11iLO9mb
=r/8g
-----END PGP SIGNATURE-----

--IJFRpmOek+ZRSQoz--
