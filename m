Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaEYTnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaEYTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:20 -0400
Date: Sun, 25 May 2014 21:22:50 +0200
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
Subject: Re: [PATCH 18/22] ARM: sunxi: Introduce Allwinner A23 support
Message-ID: <20140525192250.GY10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-19-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B7FF+pnjRCrp0ISR"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-19-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B7FF+pnjRCrp0ISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:21PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
> the IPs found in previous SoCs, notably the A31.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/mach-sunxi/Kconfig |  8 ++++++++
>  arch/arm/mach-sunxi/sunxi.c | 12 ++++++++++++
>  2 files changed, 20 insertions(+)
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
> index df906e3..a43b295 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -159,3 +159,15 @@ DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Fa=
mily")
>  	.dt_compat	=3D sun7i_board_dt_compat,
>  	.restart	=3D sun4i_restart,
>  MACHINE_END
> +
> +static const char * const sun8i_board_dt_compat[] =3D {
> +	"allwinner,sun8i-a23",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
> +	.init_machine	=3D sunxi_dt_init,
> +	.init_time	=3D sun6i_timer_init,
> +	.dt_compat	=3D sun8i_board_dt_compat,
> +	.restart	=3D sun6i_restart,
> +MACHINE_END

You should rebase on top of the latest changes that got merged into
arm-soc, or sunxi-next, most of these functions are gone now.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--B7FF+pnjRCrp0ISR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkMKAAoJEBx+YmzsjxAgEckQAL4GqQbGTuJKjwaeFGOdedNE
kjUodvUxbDJxKQB+tteF1mFTeI77e8RZy/4kAdk7Sfu7xJ/83QaFDle5NKLonx88
DoHo8h+wUkgCLlvApqIs1iGrJDtocrra/aTNU/yZLNvP/IXw6zPxuPJ+HuI839yQ
xEIvJrEDtCd5YYQ1Um+I3ANVw7UIHrJhTrpY8ok0+KashmweQ3Y1YSarrCUM1eqD
Hin6QldeLmqwuNRO9pPGJn3Yw0q6FMFV8FUi9ixNpib4EcABolak/2dlcp3aNqbh
xE0j4ryZjVanImnFRHzo3SJ6iJ9jUCPlDCH6HuG8IWNt3ImvZuPuQ0W7p1UgeovS
N1dyXLIq2sym4LCiKHn5pEU6Kss4kzmEuJhcd5h4g5isQTxlmIRzQ2N3DkPjaeKt
V4akx/PLWdZuGLAAkdbnWZqTzIh6Fk3MPDcXuiEqjbS1FehrOWaogPN5c2L4Srr3
pNxHFc+a633xTwfMfwKxPPC077kRI0GQrLoppPPcHBwO3L46cKF6dSTSa43bQGnY
xDu8mX+i+Nu4AyuvzbtjjegpD3DAbVl6jhAUlrIUP97bjF/z1QjEAlb+whSZHcn4
2ItU3lmr9Lfb+O9G5VdJqM/xAUogREssFQlxGLCLdhFA6omKBHQgU4/7WrUYSD+I
CrFWQ588oNaoOh2t0L9q
=aCbO
-----END PGP SIGNATURE-----

--B7FF+pnjRCrp0ISR--
