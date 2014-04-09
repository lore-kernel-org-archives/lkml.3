Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbaDIPfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:35:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33493 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932786AbaDIPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:35:16 -0400
Date: Wed, 9 Apr 2014 17:33:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] pinctrl: sunxi: retrieve and enable PL clk gate
 for A31 SoC
Message-ID: <20140409153334.GI28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-13-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKDEsImF70pdVIl+"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-13-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TKDEsImF70pdVIl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 03:51:15PM +0200, Boris BREZILLON wrote:
> Retrieve and enable the clock gate related to PL pins.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/pinctrl/pinctrl-sunxi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-su=
nxi.c
> index 64dffc8..da76ceb 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -898,6 +898,13 @@ static int sunxi_pinctrl_probe(struct platform_devic=
e *pdev)
>  			return -ENOMEM;
> =20
>  		pctl->get_membase =3D sun6i_a31_pinctrl_get_membase;
> +		clk =3D devm_clk_get(&pdev->dev, "pioL_clk");
> +		if (IS_ERR(clk))
> +			return PTR_ERR(clk);
> +
> +		ret =3D clk_prepare_enable(clk);
> +		if (ret)
> +			return ret;

Since the pioL_clk isn't declared in the DT yet, the pinctrl driver
won't ever probe here.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TKDEsImF70pdVIl+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWhOAAoJEBx+YmzsjxAgE94P/j0AxJAwe9YADFtNH34oLC9A
MY0GSImrQZyjAHdN7G340ytJkiFi29DLmtcjxdkiyPbOqLpfw6I4Kk6C8hTDuKrH
ed7Jcky3PS/MtCCxO4WoqRWR1fd4Nk8TSkm3rsP6VLMT8pTcZku8BA/uPOM9Ocqf
ktqF/ZVxds13ZyME2BQPrlLDBgWkB4UQje9PUBqJy35cwSzn3SzjqgVuImBSt57W
mUgBslT0EWvgDuZC8v8f1pJsIfic3+vzwWaQ9qhvSdiPSeZWa2RiwU2iRxiaqrfU
4VAERDvUOOx+aIAD+MOUr49jXfOV0fOrBehUkIJcjFPIILlzhDhihxwVf7dxqx1S
uNeb15XmKgnaREzxniVbopYC0qBMoTDjwEzLMznYYSI4IXKXfkjobk6knv14W4TE
AL2Gy8TtfIZaAyNNYVm4lm716gj3TTJCXBLByGWYd4Cg1dRmTG2rtT5kKx0s/ars
eLbkCXIZ466xVVOpDLt0GrKVlf4sSGhLzvms8uHfHxeLakMNjUzQA91Hj9X5/um7
nBQkP2043zCqvybdFUWWxiTwZfqW6vaZ85CqoFr9oDzCvz67Im0Clyd/7W8yb+e0
fHQece1zO+XaZVNBhuVfaWbBKca8i6BgcJ1u0S1W/uk1W7P9C2mITm5/kRtpJMpz
mR/YG6GZ7AJmpxr7rtpw
=9Qjq
-----END PGP SIGNATURE-----

--TKDEsImF70pdVIl+--
