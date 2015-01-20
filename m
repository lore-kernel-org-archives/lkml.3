Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbbATTDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:03:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41421 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbbATTDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:03:10 -0500
Date: Tue, 20 Jan 2015 13:02:18 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ARM: dts: dra72-evm: Add extcon nodes for USB
Message-ID: <20150120190218.GF15169@saruman>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <1421689942-10201-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <1421689942-10201-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:52:21PM +0200, Roger Quadros wrote:
> On this EVM, the USB cable state has to be determined via the
> ID pin tied to a GPIO line. We use the gpio-usb-extcon driver
> to read the ID pin and the extcon framework to forward
> the USB cable state information to the USB driver so the
> controller can be configured in the right mode (host/peripheral).
>=20
> Gets USB peripheral mode to work on this EVM.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/dra72-evm.dts | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-ev=
m.dts
> index 89085d0..d93a98f 100644
> --- a/arch/arm/boot/dts/dra72-evm.dts
> +++ b/arch/arm/boot/dts/dra72-evm.dts
> @@ -8,6 +8,7 @@
>  /dts-v1/;
> =20
>  #include "dra72x.dtsi"
> +#include <dt-bindings/gpio/gpio.h>
> =20
>  / {
>  	model =3D "TI DRA722";
> @@ -24,6 +25,16 @@
>  		regulator-min-microvolt =3D <3300000>;
>  		regulator-max-microvolt =3D <3300000>;
>  	};
> +
> +	extcon_usb1: extcon_usb1 {
> +		compatible =3D "linux,extcon-usb";
> +		id-gpio =3D <&pcf_gpio_21 1 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	extcon_usb2: extcon_usb2 {
> +		compatible =3D "linux,extcon-usb";
> +		id-gpio =3D <&pcf_gpio_21 2 GPIO_ACTIVE_HIGH>;
> +	};
>  };
> =20
>  &dra7_pmx_core {
> @@ -243,6 +254,18 @@
>  			ti,palmas-long-press-seconds =3D <6>;
>  		};
>  	};
> +
> +	pcf_gpio_21: gpio@21 {
> +		compatible =3D "ti,pcf8575";
> +		reg =3D <0x21>;
> +		lines-initial-states =3D <0x1408>;
> +		gpio-controller;
> +		#gpio-cells =3D <2>;
> +		interrupt-parent =3D <&gpio6>;
> +		interrupts =3D <11 IRQ_TYPE_EDGE_FALLING>;
> +		interrupt-controller;
> +		#interrupt-cells =3D <2>;
> +	};
>  };
> =20
>  &uart1 {
> @@ -345,6 +368,14 @@
>  	phy-supply =3D <&ldo4_reg>;
>  };
> =20
> +&omap_dwc3_1 {
> +	extcon =3D <&extcon_usb1>;
> +};
> +
> +&omap_dwc3_2 {
> +	extcon =3D <&extcon_usb2>;
> +};
> +
>  &usb1 {
>  	dr_mode =3D "peripheral";
>  	pinctrl-names =3D "default";
> --=20
> 2.1.0
>=20

--=20
balbi

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvqY6AAoJEIaOsuA1yqRE7BwP/2CnyzyAMvI7JdYzF1KTu3Qb
EreaSLktOQJ1IiySQDIHb64+KFpMRU3A87jfetXVzSGUpaoaZYLC+W+laPHZM2l9
+mTFhgynAYFPD4yD/La250wrCdAC5YnjFHFVJ2iSt4bU8oBNyy/iJa4yUIZvYF9K
FDEedLPWL+S+oXvCrm/SCeITOF4bJ/rqYdU54uBiIWoYwsiHKNxPnQIk1YuPWbER
iygSqDbUeO6xIH6/M9R/FFqsKW8ezDIYd75Km6E0MAEOCpV0kz56eDLGO0qnD17o
q3cL8uTzOlMGIcNu88PGS9bQok40LwWLty7ASHcEjYVqf/iq933rIrLegK5MDGfn
JeQkxWtruEHzSuGbWA99LAGS7MAUYV2e39NNCbTT2P8bXCWHYfKKFIpQjBbh1Y57
u9+FTaCj33/4M2dDSvoHMdZHMlWYdQTgsq6tKp6vClV67yXZvzOf3KrhZrmztJpy
h7zV8UobDtwON7BnSCmdU/kTiHsIBFEhQiovnXwN9sGy7g0YVI4B2xRSykY6XWzB
ecfa94is23drHnOtczzWA33OBtkTwwUqHwU9QJ4STksbuQP4Il5Dya4ZXoDLN8hY
SVhIpkDC/VN2GVkff9bwcaRPMz2mLeTv4Z7ayYfXDB1IQsmU35i8d9ehsC5Qso+5
iYUQ15nrqdpM3f8ORVWR
=UgoN
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
