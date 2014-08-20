Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaHTHcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:32:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58828 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHTHck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:32:40 -0400
Date: Wed, 20 Aug 2014 09:32:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: fix bogus request for GPIO#0 when
 instantiated from DT
Message-ID: <20140820073234.GI13793@ulmo>
References: <1408516716-28828-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IR1Y5IvQhrKgS4e6"
Content-Disposition: inline
In-Reply-To: <1408516716-28828-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IR1Y5IvQhrKgS4e6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 08:38:36AM +0200, Lothar Wa=C3=9Fmann wrote:
> commit 257462dbf3ed ("pwm-backlight: switch to gpiod interface")
> introduced a regression leading to acquiring a bogus GPIO-0 when
> configured from DT without an 'enable-gpios' property.
> The driver will happily accept the 0 initialized 'enable_gpio' member
> of the struct platform_pwm_backlight_data as valid gpio number, and
> request this GPIO as enable pin. In case of multiple driver instances,
> the second will fail to register with the error message:
> pwm-backlight backlight1.23: failed to request GPIO#0: -16
>=20
> Fix this by setting enable_gpio in the pdata struct to -EINVAL.
>=20
> Signed-off-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> ---
>  drivers/video/backlight/pwm_bl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index d7a3d13..e6ef6b4 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -172,7 +172,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
>  		data->dft_brightness =3D value;
>  		data->max_brightness--;
>  	}
> -
> +	data->enable_gpio =3D -EINVAL;

I'd prefer to keep the blank line for readability. Other than that:

Acked-by: Thierry Reding <treding@nvidia.com>

--IR1Y5IvQhrKgS4e6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9E8SAAoJEN0jrNd/PrOhqdoQAI9+wA1wsYSEbkXrg9XDblJq
YQcwDqEEeV8MhU26Jg5Yp68Dsiz2EH93O1rnwmLS0WKw75ql2jZw3lBvcM2UM5Lb
qhN3r+MpO+arnXIPGHR//IPjD5V8Ug5fAwzkLpgjp0xzDnr3ecf/8TxzpX4uPDCh
Xob5+O+RX1XQUkzwB2GEIY/UZ3gLnPHjm1hl03R8eVoK5luZjGwK355uGNJG8sfD
lWoNw610nsLnxizUE5Nd2gJ1c7n3fwUEEth1rWEgLdRgx8WErmgknbDpsPI21Ra2
RPchUB614zJ8LkNvaTYvSnDBjEkhgmxVAcNq794qWub8tKvAiDVg8sUsCZWdL0W9
fu5mcxVksIAAwDcekqEkKInI5qRUzvJSWxi9nsrPF+bGHVdqyNVjWxybvcfwAdQm
mxiya2hlgeJ8MXMTQWWggKVmpbPwRdsIUYNWrozQI3HogvMCU/bqQriR/wzL8iDg
5/4YXAm7BbpdovAl8MruhWCIWBkr0xejV5B08TcqShkIPq9GLqXOzYnpzx0W1e4e
oqSkfriZaWHqrJr1jjUbIRqplU9DIashceuLHzo2kgEiaf6jGpJE1hZHCMdmNETE
O0rjcfiZ90myvOewTsNwFqJ/lgxkkXdywrrZrBWPIV4Skwe5Bq3HXb3NgKDFya0F
RDCP4iHvx2YpA+c/w3pF
=zqaJ
-----END PGP SIGNATURE-----

--IR1Y5IvQhrKgS4e6--
