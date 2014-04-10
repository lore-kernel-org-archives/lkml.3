Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807AbaDJMuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:50:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38849 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030665AbaDJMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:50:07 -0400
Date: Thu, 10 Apr 2014 14:46:43 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 4/5] pinctrl: sunxi: add reset control support
Message-ID: <20140410124643.GS28585@lukather>
References: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397132747-13917-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4PJudQiuYY5+cwwi"
Content-Disposition: inline
In-Reply-To: <1397132747-13917-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4PJudQiuYY5+cwwi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 02:25:46PM +0200, Boris BREZILLON wrote:
> The A31 SoC define a reset line for the R_PIO block which needs to be
> deasserted for the pin controller to be usable.
>=20
> Try to retrieve a reset line and deassert if one was found.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/pinctrl/pinctrl-sunxi.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-su=
nxi.c
> index ee62027..b752495 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -26,6 +26,7 @@
>  #include <linux/pinctrl/pinconf-generic.h>
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/platform_device.h>
> +#include <linux/reset.h>
>  #include <linux/slab.h>
> =20
>  #include "core.h"
> @@ -792,6 +793,7 @@ static int sunxi_pinctrl_probe(struct platform_device=
 *pdev)
>  	const struct of_device_id *device;
>  	struct pinctrl_pin_desc *pins;
>  	struct sunxi_pinctrl *pctl;
> +	struct reset_control *rstc;
>  	int i, ret, last_pin;
>  	struct clk *clk;
> =20
> @@ -885,6 +887,13 @@ static int sunxi_pinctrl_probe(struct platform_devic=
e *pdev)
> =20
>  	clk_prepare_enable(clk);
> =20
> +	rstc =3D devm_reset_control_get(&pdev->dev, NULL);

You should use devm_reset_control_get_optional here.

> +	if (!IS_ERR(rstc)) {
> +		ret =3D reset_control_deassert(rstc);
> +		if (ret)
> +			goto gpiochip_error;
> +	}
> +

It would be good to put back the device in reset if probe fails later
on.

Thanks
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4PJudQiuYY5+cwwi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRpKyAAoJEBx+YmzsjxAgJhQP/jh1yPvnRZFPm9eSypopTXz3
OT5Q17whzvP/GSAwhfujT+rEm79WDD9ovBSWkNrbcb6EKd7NsTQRGFGhLyNonEDf
B9jGJHA/Uyy+S8V8trVbCxpu7DuVTgnZqpheRNmbYcvKB2DOyqY1WzbkMqgBdZk3
HoepH8K+7BZiwRELDdRn66F+E33dG82TyutEAUbRDzcJDx5wJzyEyqGJWpV1lP0d
cKntBzb0NUB40AhogU6xRuZQkSW8BHSGfDAJOlTKZHdop8JVZTyPhCQTFnrpP8Km
GyBLJGk9vXS8jNBHh+OGQ5vcbiv35qzXzMy77nH6QgbHNULEe+cQcuRFih69f95p
cGtfn52NzSAiJQf6k30Z6UvKXXTytNo51s4bo/JpLxAz5w8nUuNqG5fn0c0eBgZT
fl6RMA2LZgSX3UZOvPkmdQJK4Q9mzqewhmdlwFCVsAe+F4sB1xYmh6LxpBKA2/95
QsnjCDboZ5sGowDf2rC0QzF218x5i8hCilq6a96Og5LkMLjgP1JfEJMlgQ61RPri
gYlqBfm8FOzbOGpKUYaurRqg9KCmSl+uW2geWawpDc4l1QDQcpFKdyPHbHSW8QxY
x+ml3Z49az7PPN0EW3GH4XE1jMzgnfUMwawSEv5iMl048ecVc6I3klGuUkcX+ZBZ
78SrAbHShUYE/IM48rHs
=tDum
-----END PGP SIGNATURE-----

--4PJudQiuYY5+cwwi--
