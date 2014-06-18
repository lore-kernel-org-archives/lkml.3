Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966396AbaFRMaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:30:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52936 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966264AbaFRMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:30:04 -0400
Date: Wed, 18 Jun 2014 14:26:46 +0200
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
Subject: Re: [PATCH v2 17/20] ARM: sunxi: Introduce Allwinner A23 support
Message-ID: <20140618122646.GS19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-18-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y51z1SGMnxVzkhDv"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-18-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y51z1SGMnxVzkhDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:54PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
> the IPs found in previous SoCs, notably the A31.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/mach-sunxi/Kconfig |  8 ++++++++
>  arch/arm/mach-sunxi/sunxi.c | 10 ++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> index 0fbd4f1..6434e3b 100644
> --- a/arch/arm/mach-sunxi/Kconfig
> +++ b/arch/arm/mach-sunxi/Kconfig
> @@ -35,4 +35,12 @@ config MACH_SUN7I
>  	select HAVE_ARM_ARCH_TIMER
>  	select SUN5I_HSTIMER
> =20
> +config MACH_SUN8I
> +	bool "Allwinner A23 (sun8i) SoCs support"
> +	default ARCH_SUNXI
> +	select ARCH_HAS_RESET_CONTROLLER
> +	select ARM_GIC
> +	select MFD_SUN6I_PRCM
> +	select RESET_CONTROLLER
> +
>  endif
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index 3f9587b..962ff30 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -53,3 +53,13 @@ static const char * const sun7i_board_dt_compat[] =3D {
>  DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
>  	.dt_compat	=3D sun7i_board_dt_compat,
>  MACHINE_END
> +
> +static const char * const sun8i_board_dt_compat[] =3D {
> +	"allwinner,sun8i-a23",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
> +	.init_time	=3D sun6i_timer_init,

I haven't seen anything in your code that needed to use this
function. Am I missing something?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Y51z1SGMnxVzkhDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToYWGAAoJEBx+YmzsjxAgobgQAKMw+nCDAaYxh7n3MOhPBq8X
0+G5Tmb4zRRiUogrc9qha8UMUHc+8GfSV0+HgHJvUqdDtz2c9PdDASLuVIHh0eDZ
wyf1XUQABEOPNuyEAJHexHAOuvT1UQ6VvOZA3s9fF24NkM8XIuIiwZ1UhxoYjKYi
vdkNlMjUo8oxEcaxQ13Cu7ZMuNz6f70XbgZ6ak5rkQdhnI4PTeVvT59KFJfZg9Id
VcK9hBwzv/pfrkOd1C3aLVR9LiPiibkedXgbuQ+gg+pUy5paQfwJjpCV+sVvqzd0
Dfy9I8VY0OMgGHyHw2AI4aU8M6tNZgAta5EWdXS7qIyVhEZuob3+iXxRFOe/1VkY
p6lRkPMgKX4OgG8+UbFQghtmMbJUbDfc9u09rtA3FmdZe5cPo4M6iBvUqa3+BvRg
99JS6mCbSYorUqMqFleUrvdPYLXjmfrQEKvsGRRcAmfH253qJVWk/rDt3+RuevVd
x7YxtbYgrh+06bLyNWsFN58/oSoJeiVd1WxNF8o8+Mv4UJkjN0Fb8fxiNR2SOQm1
xV7+Im9l650z7sRPceIGn4FkCjlGdLgF94HInusMBKMOUTOWEjzHK3dvif06tP//
a98OuTUd+Q/HGPo0ttTwk94j4asAsRY/WAru13ffnBa1/wzHH6GyLEs/tGR+zjZ+
VVxTQaaWwwWYFv8BR09d
=i25f
-----END PGP SIGNATURE-----

--Y51z1SGMnxVzkhDv--
