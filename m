Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaDIPhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:37:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33497 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933504AbaDIPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:35:22 -0400
Date: Wed, 9 Apr 2014 17:34:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] pinctrl: sunxi: retrieve and enable PL reset line
 for A31 SoC
Message-ID: <20140409153412.GJ28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-14-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAmVnWIZ6lqEAvSf"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-14-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tAmVnWIZ6lqEAvSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 03:51:16PM +0200, Boris BREZILLON wrote:
> Retrieve and deassert the reset line related to PL pins.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/pinctrl/pinctrl-sunxi.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-su=
nxi.c
> index da76ceb..09eea79 100644
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
> @@ -878,6 +879,7 @@ static int sunxi_pinctrl_probe(struct platform_device=
 *pdev)
>  	const struct of_device_id *device;
>  	struct pinctrl_pin_desc *pins;
>  	struct sunxi_pinctrl *pctl;
> +	struct reset_control *rstc;
>  	int i, ret, last_pin;
>  	struct clk *clk;
> =20
> @@ -905,6 +907,14 @@ static int sunxi_pinctrl_probe(struct platform_devic=
e *pdev)
>  		ret =3D clk_prepare_enable(clk);
>  		if (ret)
>  			return ret;
> +
> +		rstc =3D devm_reset_control_get(&pdev->dev, NULL);
> +		if (IS_ERR(rstc))
> +			return PTR_ERR(rstc);
> +
> +		ret =3D reset_control_deassert(rstc);
> +		if (ret)
> +			return ret;

Same thing than in patch 12 :)

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tAmVnWIZ6lqEAvSf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWh0AAoJEBx+YmzsjxAgTIAP/R76HlrnrJU+0ObM08Ks4Vv3
+Pes2DjV0DvghqncJb+REm4qkbHr10o3yZuBx4AH0gJvL6vGKMOomnt0WUsVjbOr
XGQ01E6oEOm3cHRUpCc9y1NU9rQH5efqYAQuDGcaxVdfpLTQSPVDY1j/CQkcZT4d
G7W/Kf9zwXq0pZVBdKkmnRKv5bEh94ySExY7jkWUibVb0MsaNp8NVTT8+0kbjJwv
7DeqCkff2h0RiU+5M6YigxUROIu6OoJPYnBtqXdJt5BddEOCwIDkaZVgqRhnvb3B
B9Fp92cuGW5Yefu+U7iMPc0TpvAF6rA5B+LjrdxHirJsu9HJNiI57b0Rv7nOQRLb
q0eVZZbQuZXBFExteJny1nVrYnTliba1lyVWVNv+NR8dovU8qmzxYL0h7aSebinr
Vl/sH5kmFmWN/mlUMmr59veUElw9dZ27LbeZvF0pOQC+hbRiMTgJpvkAteiRznUy
qqKD9iCuGOl7YWdEyHdw3npHqEip5pOOXTf4fNNxFTriYtnI7TG9LEzU19drdMYm
PA21OVL4V/KhRJb3TysaxotL2JYWzpYblMvbCHgN+ajI13eyKDPEiFuRDGEzUj+1
j5B4PF79/WPV74SERtCEu0hMBviOvF+PelwnvfdPd1ADyVnW1016W4uXSWgGn5aO
sXQ9gEGhJ/rpIUh3XcfQ
=ozaJ
-----END PGP SIGNATURE-----

--tAmVnWIZ6lqEAvSf--
