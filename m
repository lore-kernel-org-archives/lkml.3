Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbaEKMfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 08:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53048 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757245AbaEKMfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 08:35:05 -0400
Date: Sun, 11 May 2014 06:56:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/4] arm: add basic support for Mediatek MT6589 boards
Message-ID: <20140511045627.GS7047@lukather>
References: <1399772463-859-1-git-send-email-matthias.bgg@gmail.com>
 <1399772463-859-4-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="en9/O5YN3eJ0yPaf"
Content-Disposition: inline
In-Reply-To: <1399772463-859-4-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--en9/O5YN3eJ0yPaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, May 11, 2014 at 03:41:02AM +0200, Matthias Brugger wrote:
> This adds a generic devicetree board file and a dtsi for boards
> based on the MT6589 SoCs from Mediatek.
>=20
> Apart from the generic parts (gic, clocks) the only component
> currently supported are the timers.
>=20
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/arm/mediatek-mt65xx.txt    |  8 ++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  arch/arm/Kconfig                                   |  2 +
>  arch/arm/Makefile                                  |  1 +
>  arch/arm/boot/dts/mt6589.dtsi                      | 93 ++++++++++++++++=
++++++
>  arch/arm/mach-mediatek/Kconfig                     |  6 ++
>  arch/arm/mach-mediatek/Makefile                    |  1 +
>  arch/arm/mach-mediatek/mediatek.c                  | 38 +++++++++
>  8 files changed, 150 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek-mt65xx=
=2Etxt
>  create mode 100644 arch/arm/boot/dts/mt6589.dtsi
>  create mode 100644 arch/arm/mach-mediatek/Kconfig
>  create mode 100644 arch/arm/mach-mediatek/Makefile
>  create mode 100644 arch/arm/mach-mediatek/mediatek.c

This probably should belong into different patches.

Something like:
  - one to document the prefix
  - one to add mach-mediatek
  - one to add the DTSI

>=20
> diff --git a/Documentation/devicetree/bindings/arm/mediatek-mt65xx.txt b/=
Documentation/devicetree/bindings/arm/mediatek-mt65xx.txt
> new file mode 100644
> index 0000000..d6ac71f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek-mt65xx.txt
> @@ -0,0 +1,8 @@
> +Mediatek MT6589 Platforms Device Tree Bindings
> +
> +Boards with a SoC of the Mediatek MT6589 shall have the following proper=
ty:
> +
> +Required root node property:
> +
> +compatible: must contain "mediatek,mt6589"
> +
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Docu=
mentation/devicetree/bindings/vendor-prefixes.txt
> index abc3080..73f9e4c 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -75,6 +75,7 @@ linux	Linux-specific binding
>  lsi	LSI Corp. (LSI Logic)
>  marvell	Marvell Technology Group Ltd.
>  maxim	Maxim Integrated Products
> +mediatek	MediaTek Inc.
>  microchip	Microchip Technology Inc.
>  mosaixtech	Mosaix Technologies, Inc.
>  moxa	Moxa
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index db3c541..0fc8acd 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -997,6 +997,8 @@ source "arch/arm/mach-mv78xx0/Kconfig"
> =20
>  source "arch/arm/mach-imx/Kconfig"
> =20
> +source "arch/arm/mach-mediatek/Kconfig"
> +
>  source "arch/arm/mach-mxs/Kconfig"
> =20
>  source "arch/arm/mach-netx/Kconfig"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 41c1931..8ce9774 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -170,6 +170,7 @@ machine-$(CONFIG_ARCH_MSM)		+=3D msm
>  machine-$(CONFIG_ARCH_MV78XX0)		+=3D mv78xx0
>  machine-$(CONFIG_ARCH_MVEBU)		+=3D mvebu
>  machine-$(CONFIG_ARCH_MXC)		+=3D imx
> +machine-$(CONFIG_ARCH_MEDIATEK)		+=3D mediatek
>  machine-$(CONFIG_ARCH_MXS)		+=3D mxs
>  machine-$(CONFIG_ARCH_NETX)		+=3D netx
>  machine-$(CONFIG_ARCH_NOMADIK)		+=3D nomadik
> diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
> new file mode 100644
> index 0000000..2af140d
> --- /dev/null
> +++ b/arch/arm/boot/dts/mt6589.dtsi
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (c) 2014 MundoReader S.L.
> + * Author: Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include "skeleton.dtsi"
> +
> +/ {
> +	compatible =3D "mediatek,mt6589";
> +	interrupt-parent =3D <&gic>;
> +
> +	cpus {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		cpu@0 {
> +			device_type =3D "cpu";
> +			compatible =3D "arm,cortex-a7";
> +			reg =3D <0x0>;
> +		};
> +		cpu@1 {
> +			device_type =3D "cpu";
> +			compatible =3D "arm,cortex-a7";
> +			reg =3D <0x1>;
> +		};
> +		cpu@2 {
> +			device_type =3D "cpu";
> +			compatible =3D "arm,cortex-a7";
> +			reg =3D <0x2>;
> +		};
> +		cpu@3 {
> +			device_type =3D "cpu";
> +			compatible =3D "arm,cortex-a7";
> +			reg =3D <0x3>;
> +		};
> +
> +	};
> +
> +	clocks {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		dummy13m: dummy13m {
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <13000000>;
> +			#clock-cells =3D <0>;
> +		};
> +
> +		dummy32k: dummy32k {
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <32000>;
> +			#clock-cells =3D <0>;
> +		};
> +	};
> +
> +	soc {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		compatible =3D "simple-bus";
> +		clock-ranges;
> +		ranges;
> +
> +		gic: interrupt-controller@10212000 {
> +			compatible =3D "arm,cortex-a9-gic";

cortex-a15-gic would probably be more appropriate?

> +			interrupt-controller;
> +			#interrupt-cells =3D <3>;
> +			reg =3D <0x10211000 0x1000>,
> +			      <0x10212000 0x1000>,
> +			      <0x10214000 0x2000>,
> +			      <0x10216000 0x2000>;
> +		};
> +
> +		timer: timer@10008000 {
> +			compatible =3D "mediatek,mtk6589-timer";
> +			reg =3D <0x10008000 0x80>;
> +			interrupts =3D <GIC_SPI 113 IRQ_TYPE_EDGE_RISING>;
> +			clocks =3D <&dummy13m>, <&dummy32k>;
> +		};

Usually, we try to order the nodes by physical addresses in the DT.

> +	};
> +};
> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kcon=
fig
> new file mode 100644
> index 0000000..2c043a2
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/Kconfig
> @@ -0,0 +1,6 @@
> +config ARCH_MEDIATEK
> +	bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
> +	select ARM_GIC
> +	select MTK_TIMER
> +	help
> +	  Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
> diff --git a/arch/arm/mach-mediatek/Makefile b/arch/arm/mach-mediatek/Mak=
efile
> new file mode 100644
> index 0000000..43e619f
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_ARCH_MEDIATEK) +=3D mediatek.o
> diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/m=
ediatek.c
> new file mode 100644
> index 0000000..0487fc7
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/mediatek.c
> @@ -0,0 +1,38 @@
> +/*
> + * Device Tree support for Mediatek SoCs
> + *
> + * Copyright (c) 2014 MundoReader S.L.
> + * Author: Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/of_platform.h>
> +#include <linux/irqchip.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +
> +static void __init mediatek_dt_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}

This is the default, you can remove it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--en9/O5YN3eJ0yPaf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbwL6AAoJEBx+YmzsjxAgew0P+wSE3vEvUBfltm1vF+3NPyXK
QEKk4YcNFkrO/xSI1nJdynDZaotAfAOj3oEyLXT7ODT/04Dvn7ANanomxiwWy+2T
Av8n588oeq/hxOBYJiS9wACn0aK3uMScK2eoUVEgw6R6ssGxl8o05jzyH1djQJ+f
a1M0WcjlGMIbJ13R1RQgXl6L95HmcZDd7FJoAr2k3QjPgkYnEW7W233rnXfo2h8j
9NrlyQdmt7MjML2F/l3wEQntk9mHAz5wLLws12TJ0Xo/DbAZZTKlJqdKWKr+30GW
65eL0VVtuF78jSVktC3XtwviZ+SQuz4S2xuIdNz0lKGesXSazhxE3JGc4+aiDDvn
5gK5m4avU7lMXDgIgJhcI1ulZadWc1nyZhPqoQ18Zhinuly1JNVTsqpJyTMHNhtZ
alJdPS5uUdG4glPdFJVbL6Gq1ZIj3YWKUgW8+vUuYncarWy+sr/bXc7F1AzPprKS
Bg5uI2RgU2w6Q389QHoTWFme/qIViu4WGp3BOSalEZrmM5zhgwUSJqA1klwL8JfJ
epwxbx/5FaN+rl97rQqKm2ErHS6V7gCzyUcSyk/QTG2C/4Jc99ksBvYpN2ic7pU2
GrYkwgTMTNOQskboFtbjpqcUyHPBG6GV3RuY5V3xkeMux8Kw1/0ILJdSL4mz+/RT
llwb8b6dwbbWTxm9n1Wq
=RvCv
-----END PGP SIGNATURE-----

--en9/O5YN3eJ0yPaf--
