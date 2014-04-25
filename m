Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaDYQSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:18:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33089 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaDYQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:18:37 -0400
Date: Fri, 25 Apr 2014 11:18:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 3/5] ARM: dts: AM4372: Add USB nodes
Message-ID: <20140425161818.GV29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <1395223803-4714-4-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SvF6CGw9fzJC4Rcx"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-4-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SvF6CGw9fzJC4Rcx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:40:01PM +0530, George Cherian wrote:
> Add nodes for 2 instances each of
> 	- ocp2scp
> 	- USB PHY control module
> 	- USB PHY
> 	- dwc3_omap
> 	- USB
>=20
> for AM43xx.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am4372.dtsi | 94 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 94 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 36d523a..cedb9d4 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -735,6 +735,100 @@
>  			#size-cells =3D <1>;
>  			status =3D "disabled";
>  		};
> +
> +		am43xx_control_usb2phy1: control-phy@44e10620 {
> +			compatible =3D "ti,control-phy-usb2-am437";
> +			reg =3D <0x44e10620 0x4>;
> +			reg-names =3D "power";
> +		};
> +
> +		am43xx_control_usb2phy2: control-phy@0x44e10628 {
> +			compatible =3D "ti,control-phy-usb2-am437";
> +			reg =3D <0x44e10628 0x4>;
> +			reg-names =3D "power";
> +		};
> +
> +		ocp2scp0: ocp2scp@483a8000 {
> +			compatible =3D "ti,omap-ocp2scp";
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			ranges;
> +			ti,hwmods =3D "ocp2scp0";
> +
> +			usb2_phy1: phy@483a8000 {
> +				compatible =3D "ti,am437x-usb2";
> +				reg =3D <0x483a8000 0x8000>;
> +				ctrl-module =3D <&am43xx_control_usb2phy1>;
> +				clocks =3D <&usb_phy0_always_on_clk32k>,
> +					 <&usb_otg_ss0_refclk960m>;
> +				clock-names =3D "wkupclk", "refclk";
> +				#phy-cells =3D <0>;
> +				status =3D "disabled";
> +			};
> +		};
> +
> +		ocp2scp1: ocp2scp@483e8000 {
> +			compatible =3D "ti,omap-ocp2scp";
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			ranges;
> +			ti,hwmods =3D "ocp2scp1";
> +
> +			usb2_phy2: phy@483e8000 {
> +				compatible =3D "ti,am437x-usb2";
> +				reg =3D <0x483e8000 0x8000>;
> +				ctrl-module =3D <&am43xx_control_usb2phy2>;
> +				clocks =3D <&usb_phy1_always_on_clk32k>,
> +					 <&usb_otg_ss1_refclk960m>;
> +				clock-names =3D "wkupclk", "refclk";
> +				#phy-cells =3D <0>;
> +				status =3D "disabled";
> +			};
> +		};
> +
> +		dwc3_1: omap_dwc3@48380000 {
> +			compatible =3D "ti,am437x-dwc3";
> +			ti,hwmods =3D "usb_otg_ss0";
> +			reg =3D <0x48380000 0x10000>;
> +			interrupts =3D <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			utmi-mode =3D <1>;
> +			ranges;
> +
> +			usb1: usb@48390000 {
> +				compatible =3D "synopsys,dwc3";
> +				reg =3D <0x48390000 0x17000>;
> +				interrupts =3D <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
> +				phys =3D <&usb2_phy1>;
> +				phy-names =3D "usb2-phy";
> +				maximum-speed =3D "high-speed";
> +				dr_mode =3D "otg";
> +				status =3D "disabled";
> +			};
> +		};
> +
> +		dwc3_2: omap_dwc3@483c0000 {
> +			compatible =3D "ti,am437x-dwc3";
> +			ti,hwmods =3D "usb_otg_ss1";
> +			reg =3D <0x483c0000 0x10000>;
> +			interrupts =3D <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			utmi-mode =3D <1>;
> +			ranges;
> +
> +			usb2: usb@483d0000 {
> +				compatible =3D "synopsys,dwc3";
> +				reg =3D <0x483d0000 0x17000>;
> +				interrupts =3D <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
> +				phys =3D <&usb2_phy2>;
> +				phy-names =3D "usb2-phy";
> +				maximum-speed =3D "high-speed";
> +				dr_mode =3D "otg";
> +				status =3D "disabled";
> +			};
> +		};
>  	};
>  };
> =20
> --=20
> 1.8.3.1
>=20

--=20
balbi

--SvF6CGw9fzJC4Rcx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWorKAAoJEIaOsuA1yqREefwP/jCRGXhNcnRUzKRAHyhKoJn2
4lF5Er8Ax+L8Euv1tSIFZuvICiqyNdMgfYzasTOI769stavNRs/BjciKhnthceTr
ubLAHmgOvq2x8q9GtlqZC4HU68Rm5HsdJTWnTVke2VD+ZTCfQu8YC4y2nEFjR012
RnCKYdAjVJ5DTWSwwK+db4YlZ0oLLPeR5PoY2eg1Oo/S9vu0AX0u3qhhDaWVQhxZ
5AWMn6O5+BdqxKreXxbJI7qsOch8D5oBMGEDTmJ2lxezFDatCqjFPUxfBqeGrucN
ymkZvglwrhV0FV3KOCTvv9r881q2azUIT+zto4ZMahZvuo6syZ0h0yen1I3qxfha
syqvhyY4s7oG4NlkkqZz0jj4LXf3zZd9rVuqJYBW4oO+ZwGjPdqaRAj8ZpBJySTq
ryDesvTiOMkaOTwgq4Zsv9sU3tquXyDBoioaTYw5+9K0j/5i/UOUKd0x8Gvykzk0
WkYcMlz6nyg6daPdVIIxrH5+h5t2c4mB7aolV5SKsU8Vi1lfMceGIJyNOgO1DtkL
43mWDKO7SSpeNCbG6+WhvbQzZXporYQ7eeg7rczInJGIwssamRRsgBaan93Ce00D
xOS8rY+32fASXCg+6v3kIIxv1o39bj74BO+iX+fbl90Px0uCA8xm1Gl4U0q+e4oo
gXtp7+1IGaPK7R6GCulq
=hJNp
-----END PGP SIGNATURE-----

--SvF6CGw9fzJC4Rcx--
