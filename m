Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab3GaJUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:20:49 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46547 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752457Ab3GaJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:20:47 -0400
Date: Wed, 31 Jul 2013 11:20:43 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: sunxi: Rename the structure to prepare the
 addition of sun6i
Message-ID: <20130731092043.GA2911@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-2-git-send-email-maxime.ripard@free-electrons.com>
 <51F856D6.2050504@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <51F856D6.2050504@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Tue, Jul 30, 2013 at 09:14:14PM -0300, Emilio L=F3pez wrote:
> Hi Maxime,
>=20
> El 30/07/13 11:44, Maxime Ripard escribi=F3:
> > Rename all the generic-named structure to sun4i to avoid confusion when
> > we will introduce the sun6i (A31) clocks.
> >=20
> > While we're at it, avoid too long lines and wrap the DT compatibles
> > tables.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Overall the patch looks good :)
>=20
> > ---
> >  drivers/clk/sunxi/clk-sunxi.c | 108 +++++++++++++++++++++++++++++-----=
--------
> >  1 file changed, 75 insertions(+), 33 deletions(-)
> >=20
> > diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunx=
i.c
> > index fe1528e..3c91888 100644
> > --- a/drivers/clk/sunxi/clk-sunxi.c
> > +++ b/drivers/clk/sunxi/clk-sunxi.c
> > @@ -25,12 +25,12 @@
> >  static DEFINE_SPINLOCK(clk_lock);
> > =20
> >  /**
> > - * sunxi_osc_clk_setup() - Setup function for gatable oscillator
> > + * sun4i_osc_clk_setup() - Setup function for gatable oscillator
> >   */
> > =20
> >  #define SUNXI_OSC24M_GATE	0
> > =20
> > -static void __init sunxi_osc_clk_setup(struct device_node *node)
> > +static void __init sun4i_osc_clk_setup(struct device_node *node)
> >  {
> >  	struct clk *clk;
> >  	struct clk_fixed_rate *fixed;
> > @@ -73,13 +73,13 @@ static void __init sunxi_osc_clk_setup(struct devic=
e_node *node)
> > =20
> > =20
> >  /**
> > - * sunxi_get_pll1_factors() - calculates n, k, m, p factors for PLL1
> > + * sun4i_get_pll1_factors() - calculates n, k, m, p factors for PLL1
> >   * PLL1 rate is calculated as follows
> >   * rate =3D (parent_rate * n * (k + 1) >> p) / (m + 1);
> >   * parent_rate is always 24Mhz
> >   */
> > =20
> > -static void sunxi_get_pll1_factors(u32 *freq, u32 parent_rate,
> > +static void sun4i_get_pll1_factors(u32 *freq, u32 parent_rate,
> >  				   u8 *n, u8 *k, u8 *m, u8 *p)
> >  {
> >  	u8 div;
> > @@ -127,12 +127,12 @@ static void sunxi_get_pll1_factors(u32 *freq, u32=
 parent_rate,
> > =20
> > =20
> >  /**
> > - * sunxi_get_apb1_factors() - calculates m, p factors for APB1
> > + * sun4i_get_apb1_factors() - calculates m, p factors for APB1
> >   * APB1 rate is calculated as follows
> >   * rate =3D (parent_rate >> p) / (m + 1);
> >   */
> > =20
> > -static void sunxi_get_apb1_factors(u32 *freq, u32 parent_rate,
> > +static void sun4i_get_apb1_factors(u32 *freq, u32 parent_rate,
> >  				   u8 *n, u8 *k, u8 *m, u8 *p)
> >  {
> >  	u8 calcm, calcp;
> > @@ -178,7 +178,7 @@ struct factors_data {
> >  	void (*getter) (u32 *rate, u32 parent_rate, u8 *n, u8 *k, u8 *m, u8 *=
p);
> >  };
> > =20
> > -static struct clk_factors_config pll1_config =3D {
> > +static struct clk_factors_config sun4i_pll1_config =3D {
> >  	.nshift =3D 8,
> >  	.nwidth =3D 5,
> >  	.kshift =3D 4,
> > @@ -189,21 +189,21 @@ static struct clk_factors_config pll1_config =3D {
> >  	.pwidth =3D 2,
> >  };
> > =20
> > -static struct clk_factors_config apb1_config =3D {
> > +static struct clk_factors_config sun4i_apb1_config =3D {
> >  	.mshift =3D 0,
> >  	.mwidth =3D 5,
> >  	.pshift =3D 16,
> >  	.pwidth =3D 2,
> >  };
> > =20
> > -static const __initconst struct factors_data pll1_data =3D {
> > -	.table =3D &pll1_config,
> > -	.getter =3D sunxi_get_pll1_factors,
> > +static const __initconst struct factors_data sun4i_pll1_data =3D {
> > +	.table =3D &sun4i_pll1_config,
> > +	.getter =3D sun4i_get_pll1_factors,
> >  };
> > =20
> > -static const __initconst struct factors_data apb1_data =3D {
> > -	.table =3D &apb1_config,
> > -	.getter =3D sunxi_get_apb1_factors,
> > +static const __initconst struct factors_data sun4i_apb1_data =3D {
> > +	.table =3D &sun4i_apb1_config,
> > +	.getter =3D sun4i_get_apb1_factors,
> >  };
> > =20
> >  static void __init sunxi_factors_clk_setup(struct device_node *node,
> > @@ -239,11 +239,11 @@ struct mux_data {
> >  	u8 shift;
> >  };
> > =20
> > -static const __initconst struct mux_data cpu_mux_data =3D {
> > +static const __initconst struct mux_data sun4i_cpu_mux_data =3D {
> >  	.shift =3D 16,
> >  };
> > =20
> > -static const __initconst struct mux_data apb1_mux_data =3D {
> > +static const __initconst struct mux_data sun4i_apb1_mux_data =3D {
> >  	.shift =3D 24,
> >  };
> > =20
> > @@ -284,17 +284,17 @@ struct div_data {
> >  	u8 pow;
> >  };
> > =20
> > -static const __initconst struct div_data axi_data =3D {
> > +static const __initconst struct div_data sun4i_axi_data =3D {
> >  	.shift =3D 0,
> >  	.pow =3D 0,
> >  };
> > =20
> > -static const __initconst struct div_data ahb_data =3D {
> > +static const __initconst struct div_data sun4i_ahb_data =3D {
> >  	.shift =3D 4,
> >  	.pow =3D 1,
> >  };
> > =20
> > -static const __initconst struct div_data apb0_data =3D {
> > +static const __initconst struct div_data sun4i_apb0_data =3D {
> >  	.shift =3D 8,
> >  	.pow =3D 1,
> >  };
> > @@ -413,35 +413,77 @@ CLK_OF_DECLARE(sunxi_osc, "allwinner,sun4i-osc-cl=
k", sunxi_osc_clk_setup);
> > =20
> >  /* Matches for factors clocks */
> >  static const __initconst struct of_device_id clk_factors_match[] =3D {
> > -	{.compatible =3D "allwinner,sun4i-pll1-clk", .data =3D &pll1_data,},
> > -	{.compatible =3D "allwinner,sun4i-apb1-clk", .data =3D &apb1_data,},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-pll1-clk",
> > +		.data =3D &sun4i_pll1_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-apb1-clk",
> > +		.data =3D &sun4i_apb1_data,
> > +	},
> >  	{}
> >  };
> > =20
> >  /* Matches for divider clocks */
> >  static const __initconst struct of_device_id clk_div_match[] =3D {
> > -	{.compatible =3D "allwinner,sun4i-axi-clk", .data =3D &axi_data,},
> > -	{.compatible =3D "allwinner,sun4i-ahb-clk", .data =3D &ahb_data,},
> > -	{.compatible =3D "allwinner,sun4i-apb0-clk", .data =3D &apb0_data,},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-axi-clk",
> > +		.data =3D &sun4i_axi_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-ahb-clk",
> > +		.data =3D &sun4i_ahb_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-apb0-clk",
> > +		.data =3D &sun4i_apb0_data,
> > +	},
> >  	{}
> >  };
> > =20
> >  /* Matches for mux clocks */
> >  static const __initconst struct of_device_id clk_mux_match[] =3D {
> > -	{.compatible =3D "allwinner,sun4i-cpu-clk", .data =3D &cpu_mux_data,},
> > -	{.compatible =3D "allwinner,sun4i-apb1-mux-clk", .data =3D &apb1_mux_=
data,},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-cpu-clk",
> > +		.data =3D &sun4i_cpu_mux_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-apb1-mux-clk",
> > +		.data =3D &sun4i_apb1_mux_data,
> > +	},
> >  	{}
> >  };
> > =20
> >  /* Matches for gate clocks */
> >  static const __initconst struct of_device_id clk_gates_match[] =3D {
> > -	{.compatible =3D "allwinner,sun4i-axi-gates-clk", .data =3D &sun4i_ax=
i_gates_data,},
> > -	{.compatible =3D "allwinner,sun4i-ahb-gates-clk", .data =3D &sun4i_ah=
b_gates_data,},
> > -	{.compatible =3D "allwinner,sun5i-a13-ahb-gates-clk", .data =3D &sun5=
i_a13_ahb_gates_data,},
> > -	{.compatible =3D "allwinner,sun4i-apb0-gates-clk", .data =3D &sun4i_a=
pb0_gates_data,},
> > -	{.compatible =3D "allwinner,sun5i-a13-apb0-gates-clk", .data =3D &sun=
5i_a13_apb0_gates_data,},
> > -	{.compatible =3D "allwinner,sun4i-apb1-gates-clk", .data =3D &sun4i_a=
pb1_gates_data,},
> > -	{.compatible =3D "allwinner,sun5i-a13-apb1-gates-clk", .data =3D &sun=
5i_a13_apb1_gates_data,},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-axi-gates-clk",
> > +		.data =3D &sun4i_axi_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-ahb-gates-clk",
> > +		.data =3D &sun4i_ahb_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun5i-a13-ahb-gates-clk",
> > +		.data =3D &sun5i_a13_ahb_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-apb0-gates-clk",
> > +		.data =3D &sun4i_apb0_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun5i-a13-apb0-gates-clk",
> > +		.data =3D &sun5i_a13_apb0_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun4i-apb1-gates-clk",
> > +		.data =3D &sun4i_apb1_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun5i-a13-apb1-gates-clk",
> > +		.data =3D &sun5i_a13_apb1_gates_data,
> > +	},
> >  	{}
> >  };
> > =20
>=20
> I'm not particularly a fan of this though; in my opinion it hurts
> readability a bit and it uses 4x the lines. It looks like a highly
> probable source of git conflicts too if not handled appropriately :)

Yeah, I'll drop it just like for pinctrl then.

>=20
> Other than that,
>=20
> Reviewed-by: Emilio L=F3pez <emilio@elopez.com.ar>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+NbrAAoJEBx+YmzsjxAgGqIP/ihTdxjd2d5Ns9DZQDGAVVkZ
4SJoQlE8dC4CrUZb41Cp5CKMwCaLViqktSOifyXZ6dqLLrf4hLcW5kBvOzIwWoZs
u84fex7PTo6+HdftWLrNAKrAlHm360NWMUNx/hgislmlPvFUKggVgNGhljrw3zYy
FYopoJOHv3xjjvzjHSSq7l8NVKNlON7pO1lVyntBl1J/Omyl3O4oviMCMrseeLlZ
DxkGmP8Yh724L7eeqKDYLqVhYBIBluVNHD+k0EliJQJaYXCtbiXMHVLApd77IH5Q
OSLYRE8g9sVLnV8Mk8NcRl5Um1f5q6H/6YAPsWTFn7ksfpkl94Xh4kHg+xuADATb
3NSDclA3sRkbNDlv1Dnb3HNCH5P4pMGMO/GTnL2vrfOnFtCfK41bUyI1HN21t+kW
kp1CqVCixnoHyTY3hxzZRmmcMVRMRJMnh7+FgxHfGB9KGPcViOKN2LZXxDiNbNNV
5REQrVSfpM2XNHVF8tfkWK78LVDGRPYkT7UIsz5AppBVzJxz7AHJvsqKL0OYtZdI
nbbaSUM2K99RWnxaNWZ7DjJX1gyPc0eaEkZkLa8SJfph5q7roPKVB3EEwYstdqhd
HT+Toy21zgM98LCA/MNhkU+JI48aLckZwb/TKGswiaBl6DfwNDJ/LCwMSaOFnA2k
xWV+HOl9UR0TyTF3h2JO
=BE9/
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
