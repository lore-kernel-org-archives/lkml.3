Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbaGYICU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:02:20 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:34774 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbaGYICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:02:13 -0400
Message-ID: <53D20F00.3040308@monstr.eu>
Date: Fri, 25 Jul 2014 10:02:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>
CC: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 03/11] ARM: dts: zynq: Add Parallella device tree
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-4-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-4-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gefeSa9ID3WiqaOt2PkNX0Q06eFgDPS9X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gefeSa9ID3WiqaOt2PkNX0Q06eFgDPS9X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 01:00 AM, Andreas F=C3=A4rber wrote:
> This allows to boot the Adapteva Parallella board to serial console.
>=20
> Cc: Andreas Olofsson <andreas@adapteva.com>
> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
> ---
>  v1 -> v2:
>  * Added board-specific compatible string (Olof Johansson).
>  * Added /chosen linux,stdout-path property (Olof Johansson).
>  * Fixed /memory reg size 0x20000000 -> 0x40000000 (0 considered).
>  * Added vendor name to root node's model property (Olof Johansson).
> =20
>  arch/arm/boot/dts/Makefile            |  4 ++-
>  arch/arm/boot/dts/zynq-parallella.dts | 64 +++++++++++++++++++++++++++=
++++++++
>  2 files changed, 67 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/zynq-parallella.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index adb5ed9..976720f 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -419,7 +419,9 @@ dtb-$(CONFIG_ARCH_VT8500) +=3D vt8500-bv07.dtb \
>  	wm8650-mid.dtb \
>  	wm8750-apc8750.dtb \
>  	wm8850-w70v2.dtb
> -dtb-$(CONFIG_ARCH_ZYNQ) +=3D zynq-zc702.dtb \
> +dtb-$(CONFIG_ARCH_ZYNQ) +=3D \
> +	zynq-parallella.dtb \
> +	zynq-zc702.dtb \
>  	zynq-zc706.dtb \
>  	zynq-zed.dtb
>  dtb-$(CONFIG_MACH_ARMADA_370) +=3D \
> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/=
zynq-parallella.dts
> new file mode 100644
> index 0000000..41afd9d
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-parallella.dts
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (c) 2014 SUSE LINUX Products GmbH
> + *
> + * Derived from zynq-zed.dts:
> + *
> + *  Copyright (C) 2011 Xilinx
> + *  Copyright (C) 2012 National Instruments Corp.
> + *  Copyright (C) 2013 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public=

> + * License version 2, as published by the Free Software Foundation, an=
d
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +/dts-v1/;
> +/include/ "zynq-7000.dtsi"
> +
> +/ {
> +	model =3D "Adapteva Parallella Board";
> +	compatible =3D "adapteva,parallella", "xlnx,zynq-7000";
> +
> +	memory {
> +		device_type =3D "memory";
> +		reg =3D <0 0x40000000>;
> +	};
> +
> +	chosen {
> +		bootargs =3D "console=3DttyPS0,115200 earlyprintk root=3D/dev/mmcblk=
0p2 rootfstype=3Dext4 rw rootwait";
> +		linux,stdout-path =3D "/amba/serial@e0001000";
> +	};
> +};
> +
> +&gem0 {
> +	status =3D "okay";
> +	phy-mode =3D "rgmii-id";
> +	phy-handle =3D <&ethernet_phy>;
> +	#address-cells =3D <1>;
> +	#size-cells =3D <0>;
> +
> +	ethernet_phy: ethernet-phy@0 {
> +		/* Marvell 88E1318 */
> +		compatible =3D "ethernet-phy-id0141.0e90",
> +		             "ethernet-phy-ieee802.3-c22";
> +		reg =3D <0>;
> +		marvell,reg-init =3D <0x3 0x10 0xff00 0x1e>,
> +		                   <0x3 0x11 0xfff0 0xa>;
> +	};
> +};
> +
> +&i2c0 {
> +	status =3D "okay";
> +};
> +
> +&sdhci1 {
> +	status =3D "okay";
> +};
> +
> +&uart1 {
> +	status =3D "okay";
> +};
>=20


Applied to zynq/dt branch.
https://github.com/Xilinx/linux-xlnx/commits/zynq/dt

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--gefeSa9ID3WiqaOt2PkNX0Q06eFgDPS9X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSDwAACgkQykllyylKDCG0rwCfflrD4cv85hftE0OSqjnEMHSA
C54An3XepXWc/MVRN2ASXIuW8vu3+UsV
=ppNV
-----END PGP SIGNATURE-----

--gefeSa9ID3WiqaOt2PkNX0Q06eFgDPS9X--
