Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784AbaFRJpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:45:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965657AbaFRJpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:45:33 -0400
Date: Wed, 18 Jun 2014 11:42:51 +0200
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
Subject: Re: [PATCH v2 05/20] clk: sunxi: Support factor clocks with N
 multiplier factor starting from 1
Message-ID: <20140618094251.GK19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-6-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8kI7hWEHMS8Z+7/0"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-6-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8kI7hWEHMS8Z+7/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:42PM +0800, Chen-Yu Tsai wrote:
> The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
> N multiplier factor that starts from 1, not 0.
>=20
> This patch adds an option to the clock driver's config data structures
> to define the difference.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-factors.c | 5 ++++-
>  drivers/clk/sunxi/clk-factors.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-fact=
ors.c
> index 3806d97..399cf4d 100644
> --- a/drivers/clk/sunxi/clk-factors.c
> +++ b/drivers/clk/sunxi/clk-factors.c
> @@ -62,7 +62,10 @@ static unsigned long clk_factors_recalc_rate(struct cl=
k_hw *hw,
>  		p =3D FACTOR_GET(config->pshift, config->pwidth, reg);
> =20
>  	/* Calculate the rate */
> -	rate =3D (parent_rate * n * (k + 1) >> p) / (m + 1);
> +	if (config->n_from_one)
> +		rate =3D (parent_rate * (n + 1) * (k + 1) >> p) / (m + 1);
> +	else
> +		rate =3D (parent_rate * n * (k + 1) >> p) / (m + 1);

Thinking a bit more about this, I wonder wether it wouldn't be better
to just have a n_start variable or something, and just use (n +
n_start) instead.

That would avoid having to declare twice the same function.

Maxime

> =20
>  	return rate;
>  }
> diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-fact=
ors.h
> index 02e1a43..0484a48 100644
> --- a/drivers/clk/sunxi/clk-factors.h
> +++ b/drivers/clk/sunxi/clk-factors.h
> @@ -15,6 +15,7 @@ struct clk_factors_config {
>  	u8 mwidth;
>  	u8 pshift;
>  	u8 pwidth;
> +	u8 n_from_one;

Especially when you declare it as an u8, and not a bool.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--8kI7hWEHMS8Z+7/0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToV8bAAoJEBx+YmzsjxAgbYgP/29N2qaoTZgDspG2y/ONavEK
J2+gHRXZj3kfAWPv7yKhieB/E10O/1k/ww0r8iFPsOoarIlRkBM+G2Hm3ntosN50
IxzjbJz9vuBQgMhIobF4NAmo7IVJ0BoGiJ1kN6a5SFLGlg7RbmNVhpX57dM+VsUB
nOXIyAMWLnsuOSGyS1Jn22AeUXEZ/hnentjkGPNEryvqKvU/0CuDefXvuBTyIHyR
rhKefTQOrIl25YUUMgy/nHt51kQD16CrDJ2mFcyL6LaUy7RgXmjVZzGbXn1ysmot
z6y/2cx+LUnvYjx0AhMeIZ8cdt+X6/8DsIiQCOVkg1DsBvLNILA463FnwIXAl7V9
kmlnq8VRSnusG65cP4CgOln/RX+XpHKSnRFR4q5CVVMtdl4QClxQIDRJ6zwBxwJp
+3pyGhML6BtMuw0x/Gu/cD9nxLt3wep2yHOtXvDncMDeAUVvPdB51yusHYvIPoAn
KMZ5nQ4yPUrEtK5yzZgdhiLXpPwtkuRcqCSgxGVT+cxYCD9QVZ8AxlFMcQ/Cl4YP
++WuhCwhNWjf3ISxDAUYb5V+u5UFuR86ri1t/6sUiX9mYD7xE951IOttgCqUfFx0
IDjyiD9g6W4muuAFdCDFkVPA8BkMo4Pi42F/d8KYcjafbvnfR0ZvAmlYs4rCkx9h
qnTNudYVOA9BesBmREwj
=7aXV
-----END PGP SIGNATURE-----

--8kI7hWEHMS8Z+7/0--
