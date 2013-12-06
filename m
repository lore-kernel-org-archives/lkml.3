Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3LGKFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:05:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57076 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752495Ab3LGKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:05:08 -0500
Date: Fri, 6 Dec 2013 19:33:39 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver@schinagl.nl
Cc: tj@kernel.org, grant.likely@linaro.org, ob.herring@calxeda.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org, ijc@hellion.org.uk,
        hdegoede@redhat.com, oliver+list@schinagl.nl
Subject: Re: [PATCH 3/3] ARM: sunxi: dts: Add ahci support to a few A10 and
 A20 boards
Message-ID: <20131206183339.GG24519@lukather>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
 <1386159055-10264-4-git-send-email-oliver@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7uYPyRQQ5N0D02nI"
Content-Disposition: inline
In-Reply-To: <1386159055-10264-4-git-send-email-oliver@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7uYPyRQQ5N0D02nI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Wed, Dec 04, 2013 at 01:10:55PM +0100, oliver@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> This patch adds sunxi sata support to A10 and A20 boards that have such
> a connector. Some boards also feature a regulator via a GPIO and support
> for this is also added.
>=20
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

Your git setup seems to be pretty uncertain about how your first name is sp=
elled :)

> ---
>  arch/arm/boot/dts/sun4i-a10-cubieboard.dts      | 26 +++++++++++++++++++=
++++++
>  arch/arm/boot/dts/sun4i-a10.dtsi                |  9 +++++++++
>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     | 26 +++++++++++++++++++=
++++++
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts      | 26 +++++++++++++++++++=
++++++
>  arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 26 +++++++++++++++++++=
++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi                |  9 +++++++++
>  6 files changed, 122 insertions(+)

Could you split this into several patches please?

At least one per SoC.

> diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/d=
ts/sun4i-a10-cubieboard.dts
> index 425a7db..b620084 100644
> --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> @@ -42,7 +42,18 @@
>  			};
>  		};
> =20
> +		sata: ahci@01c18000 {
> +			pwr-supply =3D <&reg_ahci_5v>;
> +			status =3D "okay";
> +		};
> +
>  		pinctrl@01c20800 {
> +			ahci_pwr_pin: ahci_pwr_pin@0 {

Please prefix it with name of the board.

> +				allwinner,pins =3D "PB8";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,driver =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};

Please add a newline here.

>  			led_pins_cubieboard: led_pins@0 {
>  				allwinner,pins =3D "PH20", "PH21";
>  				allwinner,function =3D "gpio_out";
> @@ -86,4 +97,19 @@
>  			linux,default-trigger =3D "heartbeat";
>  		};
>  	};
> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +		pinctrl-names =3D "default";
> +
> +		reg_ahci_5v: ahci-5v {
> +			compatible =3D "regulator-fixed";
> +			regulator-name =3D "ahci-5v";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			pinctrl-0 =3D <&ahci_pwr_pin>;
> +			gpio =3D <&pio 1 8 0>;
> +			enable-active-high;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index 4dccdb0..53c6cdb 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -306,6 +306,15 @@
>  			#size-cells =3D <0>;
>  		};
> =20
> +		sata: ahci@01c18000 {
> +			compatible =3D "allwinner,sun4i-a10-ahci";

Please use sun4i-ahci for consistency.

> +			reg =3D <0x01c18000 0x1000>;
> +			interrupts =3D <0 56 1>;

The interrupt here doesn't seem right. Is it actually working at all?

> +			clocks =3D <&ahb_gates 25>, <&pll6 0>;
> +			clock-names =3D "ahb_sata", "pll6_sata";
> +			status =3D "disabled";
> +		};
> +
>  		intc: interrupt-controller@01c20400 {
>  			compatible =3D "allwinner,sun4i-ic";
>  			reg =3D <0x01c20400 0x400>;
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/=
dts/sun7i-a20-cubieboard2.dts
> index 5c51cb8..99c5e78 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> @@ -34,7 +34,18 @@
>  			};
>  		};
> =20
> +		sata: ahci@01c18000 {
> +			pwr-supply =3D <&reg_ahci_5v>;
> +			status =3D "okay";
> +		};
> +
>  		pinctrl@01c20800 {
> +			ahci_pwr_pin: ahci_pwr_pin@0 {
> +				allwinner,pins =3D "PB8";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};

Please add a newline here.

>  			led_pins_cubieboard2: led_pins@0 {
>  				allwinner,pins =3D "PH20", "PH21";
>  				allwinner,function =3D "gpio_out";
> @@ -77,4 +88,19 @@
>  			gpios =3D <&pio 7 20 0>;
>  		};
>  	};
> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +		pinctrl-names =3D "default";
> +
> +		reg_ahci_5v: ahci-5v {
> +			compatible =3D "regulator-fixed";
> +			regulator-name =3D "ahci-5v";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			pinctrl-0 =3D <&ahci_pwr_pin>;
> +			gpio =3D <&pio 1 8 0>;
> +			enable-active-high;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/d=
ts/sun7i-a20-cubietruck.dts
> index 8a1009d..19af23e 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> @@ -19,7 +19,18 @@
>  	compatible =3D "cubietech,cubietruck", "allwinner,sun7i-a20";
> =20
>  	soc@01c00000 {
> +		sata: ahci@01c18000 {
> +			pwr-supply =3D <&reg_ahci_5v>;
> +			status =3D "okay";
> +		};
> +
>  		pinctrl@01c20800 {
> +			ahci_pwr_pin: ahci_pwr_pin@0 {
> +				allwinner,pins =3D "PH12";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,driver =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};

Please add a newline here.

>  			led_pins_cubietruck: led_pins@0 {
>  				allwinner,pins =3D "PH7", "PH11", "PH20", "PH21";
>  				allwinner,function =3D "gpio_out";
> @@ -60,4 +71,19 @@
>  			gpios =3D <&pio 7 7 0>;
>  		};
>  	};
> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +		pinctrl-names =3D "default";
> +
> +		reg_ahci_5v: ahci-5v {
> +			compatible =3D "regulator-fixed";
> +			regulator-name =3D "ahci-5v";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			pinctrl-0 =3D <&ahci_pwr_pin>;
> +			gpio =3D <&pio 7 12 0>;
> +			enable-active-high;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/b=
oot/dts/sun7i-a20-olinuxino-micro.dts
> index ead3013..23ed708 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
> @@ -34,7 +34,19 @@
>  			};
>  		};
> =20
> +		sata: ahci@01c18000 {
> +			pwr-supply =3D <&reg_ahci_5v>;
> +			status =3D "okay";
> +		};
> +
>  		pinctrl@01c20800 {
> +			ahci_pwr_pin: ahci_pwr_pin@0 {
> +				allwinner,pins =3D "PB8";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
>  			led_pins_olinuxino: led_pins@0 {
>  				allwinner,pins =3D "PH2";
>  				allwinner,function =3D "gpio_out";
> @@ -91,4 +103,18 @@
>  			default-state =3D "on";
>  		};
>  	};
> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +
> +		reg_ahci_5v: ahci-5v {
> +			compatible =3D "regulator-fixed";
> +			regulator-name =3D "ahci-5v";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			pinctrl-0 =3D <&ahci_pwr_pin>;
> +			gpio =3D <&pio 1 8 0>;
> +			enable-active-high;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 0552a64..b72c69e 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -368,6 +368,15 @@
>  			};
>  		};
> =20
> +		sata: ahci@01c18000 {
> +			compatible =3D "allwinner,sun4i-a10-ahci";
> +			reg =3D <0x01c18000 0x1000>;
> +			interrupts =3D <0 56 1>;
> +			clocks =3D <&ahb_gates 25>, <&pll6 0>;
> +			clock-names =3D "ahb_sata", "pll6_sata";
> +			status =3D "disabled";
> +		};
> +
>  		timer@01c20c00 {
>  			compatible =3D "allwinner,sun4i-timer";
>  			reg =3D <0x01c20c00 0x90>;
> --=20
> 1.8.3.2
>=20

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7uYPyRQQ5N0D02nI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSohiDAAoJEBx+YmzsjxAgNo4P/jabdpDEmabP7drJKvr0YpVd
ePtSOlmWKqkEpFgB2uIpDtlgjgwtjcjBNrjrrJCJ6cWbiecJyrQ8/89QziIjYCiY
BgL4v/agSTE3HWYTi8vs6zMSaEWSn53EX+o8xCs23kzhdawIqM3U33A0xZ7NjaEB
mittaM+nBxSvmCnsmybqoqHv53tv4+25VTheXoKKJCasViQaZl5BxgKxvU2RvnRO
7Mr1kvSS9S9QLj2iFlGdnKsJBulvxpR/duiX6XT98qnZNXigZ+JpfCFD3YgiIKU0
o/8w90g+EIqaihxRsYBwXwrikPdjRLldd6SINChXZbmuLNF+0X+rlcexFtHCxTyU
ZPxdbcOlRJC1Bl/yG8LkQOV1Fhpr15pXY18P05GG1Ih1SubMdjVlq5R+rBM2PXNb
cJfVfhyQB9t3HexOAOTa30YxzXUA+ty0HlsCb+gkCyOXS1SfewLnigk3t2jPRRJ6
pYiHwM/E+miLtXi8rQJt41dpKRGEKp0KyaSM1CXqhj5Yvnpar10w/5K7dqiOYvKg
jKUcQ0VlcMbyyi5f5cQyUvIUlfykL2O8YVLvs5WKaN2Vo/WLftWOviBcMP3WgryE
uhsMqbUOWqRjWjUPBNNiXC8TIpAN6W02wSMa8ZAhTVrRi651X1c8jJ4Xc86p8Kbb
mDstpP9yuWXpVCWGxvva
=Rleu
-----END PGP SIGNATURE-----

--7uYPyRQQ5N0D02nI--
