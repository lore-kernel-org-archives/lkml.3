Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbaCUNdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:33:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38254 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUNc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:32:58 -0400
Message-ID: <532C3F64.2020601@ti.com>
Date: Fri, 21 Mar 2014 15:32:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jim Davis <jim.epost@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] drivers/video: fix mb862xx_i2c depends issue build failure
References: <1395328560-48497-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1395328560-48497-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bAeRug3PWEpiLFbKDTborUJ6vQsRxB4nj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bAeRug3PWEpiLFbKDTborUJ6vQsRxB4nj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 20/03/14 17:16, Paul Gortmaker wrote:
> Any randconfig that sets I2C=3Dm and FB_MB862XX_I2C=3Dy will
> encounter a final link failure that looks like this:

It compiles fine with I2C=3Dm, FB_MB862XX=3Dm and FB_MB862XX_I2C=3Dy.

> drivers/built-in.o: In function `mb862xx_i2c_init':
> drivers/video/mb862xx/mb862xx-i2c.c:165: undefined reference to `i2c_ad=
d_adapter'
> drivers/built-in.o: In function `mb862xx_i2c_exit':
> drivers/video/mb862xx/mb862xx-i2c.c:176: undefined reference to `i2c_de=
l_adapter'
>=20
> Since FB_MB862XX_I2C is a bool and not tristate, simply
> don't offer it at all if core I2C support is not built in.

FB_MB862XX_I2C is not a driver, it just adds the i2c support to
FB_MB862XX. The relevant thing is whether FB_MB862XX is m or y, so
compiling with:

I2C=3Dm, FB_MB862XX=3Dy and FB_MB862XX_I2C=3Dy

will fail.

> Reported-by: Jim Davis <jim.epost@gmail.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>=20
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index dade5b7699bc..aefd1b9a3cbd 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2338,7 +2338,7 @@ endchoice
> =20
>  config FB_MB862XX_I2C
>  	bool "Support I2C bus on MB862XX GDC"
> -	depends on FB_MB862XX && I2C
> +	depends on FB_MB862XX && I2C=3Dy
>  	default y
>  	help
>  	  Selecting this option adds Coral-P(A)/Lime GDC I2C bus adapter

This fix is not correct, as it prevents the following, valid, config:

I2C=3Dm, FB_MB862XX=3Dm and FB_MB862XX_I2C=3Dy

 Tomi



--bAeRug3PWEpiLFbKDTborUJ6vQsRxB4nj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLD9kAAoJEPo9qoy8lh71fu0P/jpkuTFRh9NIpbe8Z0r3TtdF
BCgcPYc83Bt5ovr3Npvh9tD+z05jUnR0fMp4UPEOebTPUX4m5yYeT0RCRZa/oY7H
dCyEaMPLIOphblREdLc7//0FW8kfUHMpipIxIpUWJz+DULSXElJP32FbxU71trpG
6iER+0pXSt1rKK1ucChyw5ePbbjrl/FrLmmozLzLZHD2zyLeT3v90IP+iTMnM9QD
kR3eTtplQiUOAWhtb2jDGD2RHBItaJ8bHTUZ30GOP4cuq6w4Rm5wW+jdX8sJkqDR
Ia9ku3APd27V9W3MNQtFuhvdcUNhpl+IcZokVNlJeTHpdWL/1ZBDWO3ZSvTvBtSe
Pj2YY67Rd/kljnSdJ4EYprpWgl1tRHRznAEBQSM+dKp9PQzbvEpeslqI2I9422Oy
5+tz4R2qE8DVK6mCacZ+1dYy/fi6/tV84mqORtsKorK+p9h/ZVMGd7q7SRJR7uo2
JkqPbfSc3FuaXMcptZ5PpDQ8K0YOhikI/0BU5oLcGwgGfmYebWAjd/ASpzchOeaO
ioKkk7qLirhUTP+UpeHGPhCfkE71++BsZzXXdS4FkKhvUVrlr57rKoS9kjizw+eC
IDvBLynmB6GNamxx4MvLN7ouOGNQ8ctDlQ/AzWjOfi6Zx7Dgfez1ZvrQYVUcgqgA
QkT6ZcnZ/2FLjMlDILd+
=EgOm
-----END PGP SIGNATURE-----

--bAeRug3PWEpiLFbKDTborUJ6vQsRxB4nj--
