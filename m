Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3HGHKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:10:16 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62193 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3HGHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:10:13 -0400
Message-ID: <5201F2CD.8060301@monstr.eu>
Date: Wed, 07 Aug 2013 09:10:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Fabian Vogt <fabian@ritter-vogt.de>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@linaro.org, pawel.moll@arm.com,
        jakob.braun96@gmx.de
Subject: Re: [PATCH] [V2] gpio: New driver for LSI ZEVIO SoCs
References: <1375818804-13053-1-git-send-email-fabian@ritter-vogt.de>
In-Reply-To: <1375818804-13053-1-git-send-email-fabian@ritter-vogt.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5Gh3VN57Gq5ioSdaiJLhff7bVKjKAqiGe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5Gh3VN57Gq5ioSdaiJLhff7bVKjKAqiGe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 08/06/2013 09:53 PM, Fabian Vogt wrote:
> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.
> ---
>  .../devicetree/bindings/gpio/gpio-zevio.txt        |  19 ++
>  drivers/gpio/Kconfig                               |   7 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-zevio.c                          | 212 +++++++++++++=
++++++++
>  4 files changed, 239 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.t=
xt
>  create mode 100644 drivers/gpio/gpio-zevio.c
>=20
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt b/Do=
cumentation/devicetree/bindings/gpio/gpio-zevio.txt
> new file mode 100644
> index 0000000..96d948b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
> @@ -0,0 +1,19 @@
> +Zevio GPIO controller
> +
> +Required properties:
> +- compatible =3D "lsi,zevio-gpio"
> +- reg =3D <BASEADDR SIZE>
> +- #gpio-cells =3D <2>
> +- gpio-controller;
> +
> +Optional:
> +- #ngpios =3D <32>: Number of GPIOs. Defaults to 32 if absent
> +
> +Example:
> +	gpio: gpio@90000000 {
> +		compatible =3D "lsi,zevio-gpio";
> +		reg =3D <0x90000000 0x1000>;
> +=09

<tab> here and I can't see the reason to have this blank line here.

> +		gpio-controller;
> +		#gpio-cells =3D <2>;
> +	};
> \ No newline at end of file

Doesn't look right.

> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b2450ba..ba8c357 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -138,6 +138,13 @@ config GPIO_EP93XX
>  	depends on ARCH_EP93XX
>  	select GPIO_GENERIC
> =20
> +config GPIO_ZEVIO
> +	bool "LSI ZEVIO SoC memory mapped GPIOs"
> +	depends on ARCH_NSPIRE
> +	select GENERIC_IRQ_CHIP
> +	help
> +	  Say yes here to support the GPIO controller in LSI ZEVIO SoCs.
> +

Not sure how subsystem maintainer handle this but I would prefer
to keep this sorted as it is done in Makefile.

>  config GPIO_MM_LANTIQ
>  	bool "Lantiq Memory mapped GPIOs"
>  	depends on LANTIQ && SOC_XWAY
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index ef3e983..1e7e926 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -87,3 +87,4 @@ obj-$(CONFIG_GPIO_WM831X)	+=3D gpio-wm831x.o
>  obj-$(CONFIG_GPIO_WM8350)	+=3D gpio-wm8350.o
>  obj-$(CONFIG_GPIO_WM8994)	+=3D gpio-wm8994.o
>  obj-$(CONFIG_GPIO_XILINX)	+=3D gpio-xilinx.o
> +obj-$(CONFIG_GPIO_ZEVIO)	+=3D gpio-zevio.o
> \ No newline at end of file

ditto.

The patch contains several trailing whitespace reported by checkpatch.pl
which should be fixed.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--5Gh3VN57Gq5ioSdaiJLhff7bVKjKAqiGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIB8tEACgkQykllyylKDCFyWQCghfLlPv7aRNZyGwjFTk0NRU8b
e94AnjRbPpFdXMp5msGsBTUNXROZGVsq
=Ow1I
-----END PGP SIGNATURE-----

--5Gh3VN57Gq5ioSdaiJLhff7bVKjKAqiGe--
