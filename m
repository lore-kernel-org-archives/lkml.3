Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIYNf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:35:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58202 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbaIYNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:35:23 -0400
Date: Thu, 25 Sep 2014 15:34:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>, ctl@merrii.com,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 4/7] ARM: dts: sun9i: Add A80 Optimus Board support
Message-ID: <20140925133427.GI15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwX5Nmi7feudBrEr"
Content-Disposition: inline
In-Reply-To: <1411570141-29960-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwX5Nmi7feudBrEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:48:58PM +0800, Chen-Yu Tsai wrote:
> The A80 Optimus Board is was launched with the Allwinner A80 SoC.
> It was jointly developed by Allwinner and Merrii.
>=20
> This board has a UART port, a JTAG connector, USB host ports, a USB
> 3.0 OTG connector, an HDMI output, a micro SD slot, 8G NAND flash,
> 4G DRAM, a camera sensor interface, a WiFi/BT combo chip, a headphone
> jack, IR receiver, and additional GPIO headers.
>=20
> This patch adds only basic support.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/Makefile              |  2 +
>  arch/arm/boot/dts/sun9i-a80-optimus.dts | 66 +++++++++++++++++++++++++++=
++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 2f42b18..098f319 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -424,6 +424,8 @@ dtb-$(CONFIG_MACH_SUN7I) +=3D \
>  	sun7i-a20-pcduino3.dtb
>  dtb-$(CONFIG_MACH_SUN8I) +=3D \
>  	sun8i-a23-ippo-q8h-v5.dtb
> +dtb-$(CONFIG_MACH_SUN9I) +=3D \
> +	sun9i-a80-optimus.dtb
>  dtb-$(CONFIG_ARCH_TEGRA) +=3D tegra20-harmony.dtb \
>  	tegra20-iris-512.dtb \
>  	tegra20-medcom-wide.dtb \
> diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/=
sun9i-a80-optimus.dts
> new file mode 100644
> index 0000000..f83abab
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
> @@ -0,0 +1,66 @@
> +/*
> + * Copyright 2014 Chen-Yu Tsai
> + *
> + * Chen-Yu Tsai <wens@csie.org>
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This library is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This library is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + *     You should have received a copy of the GNU General Public
> + *     License along with this library; if not, write to the Free
> + *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
> + *     MA 02110-1301 USA
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +/dts-v1/;
> +/include/ "sun9i-a80.dtsi"
> +
> +/ {
> +	model =3D "Merrii A80 Optimus Board";
> +	compatible =3D "merrii,a80-optimus", "allwinner,sun9i-a80";
> +
> +	chosen {
> +		bootargs =3D "earlyprintk console=3DttyS0,115200";
> +	};

Since you changed the memory node in the DTSI, you should probably add
one here too, don't you?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wwX5Nmi7feudBrEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJBnjAAoJEBx+YmzsjxAgwNYP/0PUMuhCxiB8HZ3HnqxkRPBS
KKYkWX29zkWBXHutmNuFodyJKGdXjUEvg4zMTcE3nwjYhgHNqMfzks4LJ7/Vdp8H
JLPVix+ZrIQbS517YqHbSnCQyyg6WkMjUXWBAufvk6bk5+leuBM7Fe6gBqJfj4es
8pPY0fe8AlOzELDL5UCdW/3FpsDS+t1G9r3a13Yq8ll2VBSvT9CDoN+9k56uYH7O
9NCJnASXu9yOi6GLPBje7/vBR4NV/D58FvYNOFSbkb6F5YTXByAQYCnxbKZ+o/Eq
fKSy7ZqNE7lUIuVZxnjNmW6by+FbiQ1t8v5tHCBIxTXaI8TZ35GKFp+15EnLJAuK
a/GdGK+8R44HeHjMJqrNMIp62PqtDcJYX5ZnZehRwR5Mk/nrRcCoXW76N+oU4Pjm
Mw1OdKUMI5md/UHaXS2bFvuKQW9YTq9sj4+kzEfycm8YcnOoaNvIPdNfVHT4x7Ha
GE+mzizlVnB4/dDwwNvy2oqIRq9FIRLoqfsSsgA1vxEjGsEXop0zRXufVLDu93wT
TuuHRo/If6ISO/Vvrz47X2SdIdIqbPx3aG86Z5Z8hgbT9/xXmQo0R+ik/gYFvmu/
RoLpdDdVJ2UJfx/FkIVxDx+0tNWkZUQCcs/lt2ivHrjneJ8HtuegorGHv6AS/0XA
iknPG1uUW3J1ekdXKAm+
=FEMt
-----END PGP SIGNATURE-----

--wwX5Nmi7feudBrEr--
