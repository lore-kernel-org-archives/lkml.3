Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaJCKf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:35:59 -0400
Received: from sauhun.de ([89.238.76.85]:38298 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaJCKf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:35:57 -0400
Date: Fri, 3 Oct 2014 12:36:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Anders Berg <anders.berg@avagotech.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20141003103630.GB1349@katana>
References: <1411983159-4692-1-git-send-email-anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1411983159-4692-1-git-send-email-anders.berg@avagotech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2ac87fa..8983474 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -77,6 +77,17 @@ config I2C_AMD8111
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-amd8111.
> =20
> +config I2C_AXXIA
> +	tristate "Axxia I2C controller"
> +	depends on ARCH_AXXIA || COMPILE_TEST
> +	default ARCH_AXXIA
> +	help
> +	  Say yes if you want to support the I2C bus on Axxia platforms.
> +
> +	  Please note that this controller is limited to transfers of maximum
> +	  255 bytes in length. Any attempt to to a larger transfer will return
> +	  an error.
> +
>  config I2C_I801
>  	tristate "Intel 82801 (ICH/PCH)"
>  	depends on PCI
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 49bf07e..5899edb 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_I2C_ALI15X3)	+=3D i2c-ali15x3.o
>  obj-$(CONFIG_I2C_AMD756)	+=3D i2c-amd756.o
>  obj-$(CONFIG_I2C_AMD756_S4882)	+=3D i2c-amd756-s4882.o
>  obj-$(CONFIG_I2C_AMD8111)	+=3D i2c-amd8111.o
> +obj-$(CONFIG_I2C_AXXIA)		+=3D i2c-axxia.o
>  obj-$(CONFIG_I2C_I801)		+=3D i2c-i801.o
>  obj-$(CONFIG_I2C_ISCH)		+=3D i2c-isch.o
>  obj-$(CONFIG_I2C_ISMT)		+=3D i2c-ismt.o

Please put it to the embedded section.

=2E..

> +	idev->adapter.class =3D I2C_CLASS_HWMON;

Being a DT driver, you most probably don't need this.


--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULnwuAAoJEBQN5MwUoCm2CkwQAJ+cYBA7ZhgbaqjFDiRKauCu
+O+RBpsc1ckfgH0ThqudovAlIcuWRGvc8rbHQMs4R6DNGCZ+qxygPgR+XjotHE3n
QQl3ER3NmG30EViE7pwoNR+IBEkdk7pJ8e2LGb08hfI1QT6ROdNTtV21TjVgEY1w
eu28PEbJPJ3bbhMt/DyA9nTPYd8L3LCMR4JeuHAO5m9syMAsgLOm7RcAa2UVjbRk
DIcnCbDrUCQvxcBycQes4q4eGTfKi+F9P7KfrcNFpwPqBAXHB6t/UhxCgJHAT1jt
dk0MwqFImngWLfgGM8O3yiwETsR4AVPausjfCmvhVdgctUh85wFsY+sqnA9sVest
s2O6Z4u9oVoEhsAZwfS0zZVnNbnzx3pkZ+ZpDIY9F166qMdmVIiCKNFfSBrI9g1b
zdZxW0T8d1momDu14PzrW0HUjdKhx+ID3ZfeGUzxeMJk3XEnGrs4DdmWQIb+Jry5
pHeUhFmZKXDHcl/dSGO107KdUPCP7OuN2oSZwvNlxsB9R9/2pZhedvUn6Rg4CubM
3hvVxUrEiRrkX7xUAC78nNje780+XZ1ldUqJpJ41gPCurgyhYW0ML130mWB2GCaO
swEAvOCmIC/jQ6FmBVJe/LD1rr7qfnxboIb1YQZLKZQGIZ/vNc+3COGu25d3Phrd
Vbr9O4o7R3sTj+1c1EmK
=08YL
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
