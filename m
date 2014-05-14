Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaENWZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:25:20 -0400
Received: from bues.ch ([80.190.117.144]:48010 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaENWZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:25:18 -0400
X-Greylist: delayed 1916 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 18:25:18 EDT
Date: Wed, 14 May 2014 23:52:32 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: gpio-bt8xx: fix compilation warning
Message-ID: <20140514235232.57bbc9df@wiggum>
In-Reply-To: <1400103816-26086-1-git-send-email-berthe.ab@gmail.com>
References: <1400103816-26086-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dbxZopuKGEUS0hZT/xS+r2K"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dbxZopuKGEUS0hZT/xS+r2K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 May 2014 23:43:36 +0200
abdoulaye berthe <berthe.ab@gmail.com> wrote:

> this fixes a compilation warning by checking
> the retun value of gpiochip_remove()


Really, I would rather change the gpiochip_remove return type to void.

What is the point of printing a useless error message in case
of a failure and then continuing as always.
This is not fixing a compiler warning, it is a workaround. And a bad one, i=
ndeed.

How are we supposed to handle a gpiochip_remove failure correctly
in a pcidev remove handler?


> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
> ---
>  drivers/gpio/gpio-bt8xx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
> index ecb3ca2d..5480229 100644
> --- a/drivers/gpio/gpio-bt8xx.c
> +++ b/drivers/gpio/gpio-bt8xx.c
> @@ -240,7 +240,8 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
>  {
>  	struct bt8xxgpio *bg =3D pci_get_drvdata(pdev);
> =20
> -	gpiochip_remove(&bg->gpio);
> +	if (gpiochip_remove(&bg->gpio))
> +		dev_info(&pdev->dev, "gpiochip_remove() failed.\n");
> =20
>  	bgwrite(0, BT848_INT_MASK);
>  	bgwrite(~0x0, BT848_INT_STAT);




--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/dbxZopuKGEUS0hZT/xS+r2K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc+WgAAoJEPUyvh2QjYsO7BcP/1Idu6uoFHp6QZwNxDo9BLPR
wcvPjcdLg3LvEO0CeeEPYUjS8WUXHi8kIZTyINOdmVXuN6Umhhk9cUGHliS0LDXF
zrQZfNNqI4ZB10KoOevV9zoKVP0j+zRO+2tyC9bMQKrAvBQIIJ5Lh9MpsSb3T6Uu
fjz0mKmIbaHQKKZWWoRcbyw3aoGSwjIPWPhaKKlWMhPlN1cFCcnmvHzTD44FaKj7
QOeqD06O59XKa3Mwc4+Q3x8cv/24H7D5VPbiI5Ea95ln5KefSpGTl75fCmoS5l5d
UQYOiQkGVvSHC13GNqo8pN8GEmdurnfmmI6EKnhYFNVaDPVlQTgs+YN6LK7qqGpQ
wa354YLpYxv66rwfMwUKZEsfJFxmSz45dsVOjwlr7V8Bs2Vlv50mRgIDAfyt9+aZ
p91wnRMhbPKJm6I/MtczCLIpYqe+seUgLh9Kc+3D5YRpXYUlA0bSCZQK7J+joc1K
mpI5IOoAhssRRClBCOuZMY6B0SDO9ppaQBqkKI7QBbERH4WpIcDiBI0o0NDln/91
13vUUfRvKhI+MaGGBqkrztAVOO6Y7GoXmW9wyZGZ4Jh5W7fMabsuC/VN0XdZityg
DkwpTH2vlqVl/yKpAUtvYFsoiG8Xx1723qgGMSXlN97p+856egK9q3bv1NQZgali
mRMmHCzlpAf4LZDP7VKK
=kBTw
-----END PGP SIGNATURE-----

--Sig_/dbxZopuKGEUS0hZT/xS+r2K--
