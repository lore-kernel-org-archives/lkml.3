Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaBOPD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:03:59 -0500
Received: from sauhun.de ([89.238.76.85]:52745 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaBOPD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:03:57 -0500
Date: Sat, 15 Feb 2014 16:03:45 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH V2 11/17] i2c: nomadik: Convert to devm functions
Message-ID: <20140215150345.GD2579@katana>
References: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 03:09:02PM +0100, Ulf Hansson wrote:
> Use devm_* functions to simplify code and error handling.
>=20
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>=20
> Changes in v2:
> 	Rebased on top of latest i2c-nomadik branch.

Since this depends on Linus' patch already, I think it would be cleaner
if I pick this kinda unrelated (but wanted) devm patch, and ack the
PM stuff. If this for some reason makes things more complicated, I can
also simply ack this one.

> -	dev->virtbase =3D ioremap(adev->res.start, resource_size(&adev->res));
> +	dev->virtbase =3D devm_ioremap(&adev->dev, adev->res.start,
> +				resource_size(&adev->res));
>  	if (!dev->virtbase) {
>  		ret =3D -ENOMEM;

IS_ERR()!


--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS/4HRAAoJEBQN5MwUoCm2hX0P/1ygDFrGGiJ9tcvMf+SOs7L5
UcIYvKRC3pl4MRXiYiPaMnO7fCltAd4RRcyfwWL1qSptFhQJ261nSWjPyx/md2mI
0KG8F/zDaDd1DTRkWRf/CrI4Te6mjUklG48sBab/c+lqMu2uQLqHtWsAMtUGg/C4
O+FqbSv8jakTXOmo3+y6siJCfyf/3GdjzibcDKCRAcZ1X3hnUYjqJEhSLyF60u3M
ZOrhCjDRyrX5xG2YOYEa8wQ1noiymwRFf2QGvLUPWEbFI0HS7ubNfgaRm9boiBRO
uf6xGrfuLWW06247l6pkaBiAB0rEpKZCDgtWeiMHmnYXv8h5IdK6ZsFowPOFscK9
5aKrVxvHZrwxeXD9jd68k55r4GX8RlTooL5NWcGswsAw/bKoG8aEVkxr581OTxVo
CJA4ewILDlolS+WPUHB+OpWMXLJP2Vkswq7RINLWOeo+k1RvcaXoR7rMWFZH/Zd4
lkMtx6co/qBfC9wv45iOwRxgk7E/RYW6e8CKhvy7qjwPsHD0+09gL0VMJGuGfaKP
i7c82YPf0SN3WKy8IrpUb5VyVwcwYkj5vQFB0AJJ8vn553MTONPxB8jauSAAEwWT
Q50DzHsKvnYZWdJPrmp4ODEEDX7yy4LluUu60l88xzr0eJ4Zziey61LiHh/lH0MT
MA3CUAAsiL1MXGLZ0lCj
=6Yuc
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
