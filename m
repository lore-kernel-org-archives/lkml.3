Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIYNfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:35:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58192 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbaIYNfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:35:13 -0400
Date: Thu, 25 Sep 2014 15:33:29 +0200
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
Subject: Re: [PATCH v2 3/7] ARM: dts: sunxi: Add Allwinner A80 dtsi
Message-ID: <20140925133329.GH15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xp2nimoPFnvF0aLh"
Content-Disposition: inline
In-Reply-To: <1411570141-29960-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xp2nimoPFnvF0aLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:48:57PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A80 is a new multi-purpose SoC with 4 Cortex-A7 and
> 4 Cortex-A15 cores in a big.LITTLE architecture, and a 64-core
> PowerVR G6230 GPU.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun9i-a80.dtsi | 287 +++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 287 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun9i-a80.dtsi
>=20
> diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a=
80.dtsi
> new file mode 100644
> index 0000000..34a0068
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun9i-a80.dtsi
> @@ -0,0 +1,287 @@
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
> +/include/ "skeleton64.dtsi"
> +
> +/ {
> +	interrupt-parent =3D <&gic>;
> +
> +	aliases {
> +		serial0 =3D &uart0;
> +		serial1 =3D &uart1;
> +		serial2 =3D &uart2;
> +		serial3 =3D &uart3;
> +		serial4 =3D &uart4;
> +		serial5 =3D &uart5;
> +		serial6 =3D &r_uart;
> +	};
> +
> +	cpu-map {
> +		cluster0 {
> +			core0 {
> +				cpu =3D <&cpu0>;
> +			};
> +
> +			core1 {
> +				cpu =3D <&cpu1>;
> +			};
> +
> +			core2 {
> +				cpu =3D <&cpu2>;
> +			};
> +
> +			core3 {
> +				cpu =3D <&cpu3>;
> +			};
> +		};
> +
> +		cluster1 {
> +			core0 {
> +				cpu =3D <&cpu4>;
> +			};
> +
> +			core1 {
> +				cpu =3D <&cpu5>;
> +			};
> +
> +			core2 {
> +				cpu =3D <&cpu6>;
> +			};
> +
> +			core3 {
> +				cpu =3D <&cpu7>;
> +			};
> +		};
> +	};

Like you already found out, the topology code doesn't use the cpu-map
but only relies on the cpu compatible and max frequencies, so you can
drop this.

> +
> +	cpus {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		cpu0: cpu@0 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <0x0>;
> +		};
> +
> +		cpu1: cpu@1 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <0x1>;
> +		};
> +
> +		cpu2: cpu@2 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <0x2>;
> +		};
> +
> +		cpu3: cpu@3 {
> +			compatible =3D "arm,cortex-a7";
> +			device_type =3D "cpu";
> +			reg =3D <0x3>;
> +		};
> +
> +		cpu4: cpu@100 {
> +			compatible =3D "arm,cortex-a15";
> +			device_type =3D "cpu";
> +			reg =3D <0x100>;
> +		};
> +
> +		cpu5: cpu@101 {
> +			compatible =3D "arm,cortex-a15";
> +			device_type =3D "cpu";
> +			reg =3D <0x101>;
> +		};
> +
> +		cpu6: cpu@102 {
> +			compatible =3D "arm,cortex-a15";
> +			device_type =3D "cpu";
> +			reg =3D <0x102>;
> +		};
> +
> +		cpu7: cpu@103 {
> +			compatible =3D "arm,cortex-a15";
> +			device_type =3D "cpu";
> +			reg =3D <0x103>;
> +		};
> +	};
> +
> +	memory {
> +		/* 8GB max. with LPAE */
> +		reg =3D <0 0x20000000 0x02 0>;
> +	};
> +
> +	clocks {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges =3D <0 0 0 0x20000000>;

A comment for this ranges would be nice.

I looks fine otherwise.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Xp2nimoPFnvF0aLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJBmpAAoJEBx+YmzsjxAghMoP/2lI4eVIVdmT0VCS3N1b47U+
cIVjuLbkOdYwGnjGwAz+Ikop5pdp0v/HHxqoc8YKiOwBV62da0pI9T6nmLqaHjqR
3bHCLPjPMv0fD+F0jyll5laUd+fEGdy3GMm9peNW9bF0QxVsYEqpJVw2nrt2rEjY
gPyl8Babl+9kpEJuR3LOk0bieqG71KCu5W3eFi7Y8LhqafS7fO6NzSHNRFr7yWT/
R2zfFtCITnr9J7bRKwdDK9CU0/5IPmg8OyXdbFIeH7ytLfD7p+iY3ag/eCO2hO+h
YD+olRc809DIjCRduv/A8AlD1PIXnYiHTDfGPxNX4Fik/XMa/5T6rp45buVVVmc5
XSbqUD9NemjjQgrnvUZxhlNWOeoBp0miYYNT/wU6/fFkQ5cYaHdYYSTqYeTSQ9yV
j7GHeW6odZ7alRN86cm4FdCF4HGfssPgmlQsOBVCdZJVRrkroKGzlegOXGYS2/72
TgutPqkOkWCCd6v0g79smx5jadBPeXC42QLC7NE4ssXjaN8mUzFKReNyTrLO5oRb
d4HjTsTNd3UOB+rFnfdxqvLiS4qJntLp0Uxo/opNV+etHiffzr8GYnfaavSrDGfw
E7XKlhNcvR9ZFK75zkVGyXmukBZN52xitdInORBfMd7qEhxrj8GFGmvmEHQr+Hfr
XZHoCAdso8wCY8kRQJzU
=D8Nc
-----END PGP SIGNATURE-----

--Xp2nimoPFnvF0aLh--
