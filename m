Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaAWAXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:23:14 -0500
Received: from ozlabs.org ([203.10.76.45]:36092 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaAWAXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:23:12 -0500
Date: Thu, 23 Jan 2014 11:23:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sherman Yin <syin@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20140123112305.56edc8c80ce536c40221b544@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Jan_2014_11_23_05_+1100_UITibO22A56igAQn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jan_2014_11_23_05_+1100_UITibO22A56igAQn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/bcm11351.dtsi between commit 67a57be85e68 ("ARM:
bcm11351: Enable pinctrl for Broadcom Capri SoCs") from Linus' tree and
commit 0bd898b872ac ("ARM: dts: Declare clocks as fixed on bcm11351") and
several following commits from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/bcm11351.dtsi
index dd8e878741c0,375a2f8eb878..000000000000
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@@ -142,8 -146,159 +146,164 @@@
  		status =3D "disabled";
  	};
 =20
 +	pinctrl@35004800 {
 +		compatible =3D "brcm,capri-pinctrl";
 +		reg =3D <0x35004800 0x430>;
 +	};
++
+ 	i2c@3e016000 {
+ 		compatible =3D "brcm,bcm11351-i2c", "brcm,kona-i2c";
+ 		reg =3D <0x3e016000 0x80>;
+ 		interrupts =3D <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+ 		#address-cells =3D <1>;
+ 		#size-cells =3D <0>;
+ 		clocks =3D <&bsc1_clk>;
+ 		status =3D "disabled";
+ 	};
+=20
+ 	i2c@3e017000 {
+ 		compatible =3D "brcm,bcm11351-i2c", "brcm,kona-i2c";
+ 		reg =3D <0x3e017000 0x80>;
+ 		interrupts =3D <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+ 		#address-cells =3D <1>;
+ 		#size-cells =3D <0>;
+ 		clocks =3D <&bsc2_clk>;
+ 		status =3D "disabled";
+ 	};
+=20
+ 	i2c@3e018000 {
+ 		compatible =3D "brcm,bcm11351-i2c", "brcm,kona-i2c";
+ 		reg =3D <0x3e018000 0x80>;
+ 		interrupts =3D <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+ 		#address-cells =3D <1>;
+ 		#size-cells =3D <0>;
+ 		clocks =3D <&bsc3_clk>;
+ 		status =3D "disabled";
+ 	};
+=20
+ 	i2c@3500d000 {
+ 		compatible =3D "brcm,bcm11351-i2c", "brcm,kona-i2c";
+ 		reg =3D <0x3500d000 0x80>;
+ 		interrupts =3D <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+ 		#address-cells =3D <1>;
+ 		#size-cells =3D <0>;
+ 		clocks =3D <&pmu_bsc_clk>;
+ 		status =3D "disabled";
+ 	};
+=20
+ 	clocks {
+ 		bsc1_clk: bsc1 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		bsc2_clk: bsc2 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		bsc3_clk: bsc3 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		pmu_bsc_clk: pmu_bsc {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		hub_timer_clk: hub_timer {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <32768>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		pwm_clk: pwm {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <26000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		sdio1_clk: sdio1 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <48000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		sdio2_clk: sdio2 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <48000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		sdio3_clk: sdio3 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <48000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		sdio4_clk: sdio4 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <48000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		tmon_1m_clk: tmon_1m {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <1000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		uartb_clk: uartb {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		uartb2_clk: uartb2 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		uartb3_clk: uartb3 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		uartb4_clk: uartb4 {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <13000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+=20
+ 		usb_otg_ahb_clk: usb_otg_ahb {
+ 			compatible =3D "fixed-clock";
+ 			clock-frequency =3D <52000000>;
+ 			#clock-cells =3D <0>;
+ 		};
+ 	};
+=20
+ 	usbotg: usb@3f120000 {
+ 		compatible =3D "snps,dwc2";
+ 		reg =3D <0x3f120000 0x10000>;
+ 		interrupts =3D <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+ 		clocks =3D <&usb_otg_ahb_clk>;
+ 		clock-names =3D "otg";
+ 		phys =3D <&usbphy>;
+ 		phy-names =3D "usb2-phy";
+ 		status =3D "disabled";
+ 	};
+=20
+ 	usbphy: usb-phy@3f130000 {
+ 		compatible =3D "brcm,kona-usb2-phy";
+ 		reg =3D <0x3f130000 0x28>;
+ 		#phy-cells =3D <0>;
+ 		status =3D "disabled";
+ 	};
  };

--Signature=_Thu__23_Jan_2014_11_23_05_+1100_UITibO22A56igAQn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS4GDuAAoJEMDTa8Ir7ZwVMooP/jaUiupQjDZTVdgO0kDQS9Wv
iuCWQ+nPeLWpa14uPOwAeZWcgCYe0YvrDMKm88nUoxLKl+UM1/ldpQH0B0xU/O6v
pFezjQbL5Cu4XxjuTebI+oQ+Navfrw/tpgWMu5HLqbF7pbDhKBg8kX3UmQGYT0Rf
D0/xB+RSH1n+H0uxaBw2PRGHmNqdygTNPl8FnHN0XsL/iYv7Ly+7V86N1M+UXgbB
H9++1+4Z+cJy/x9DUKwDubfT6+IGWBQxprlr/DkcSjl0VCFtsXsuPpFIs9NcZHqk
icqrhHcU2qRXwt8od2Z80qz/3klklaaRkF+8x3CKuZ9R/tbPR9MIZliQzifoJR3q
WWO5r4nqoJbvFU9P9Op1SP+mdoskZ+Dkcov1YECz84a2RbM3si2L+vxkA0wqKJwN
OxGa3W3Tx6RPriFyyS9D6Tjmvsl/uyUpBDLjezW6s9G5u9QUzp8iswkTn29BeB3H
Fs6/8+uLUQR8REy23t/LpyHAu46ZcX1PMmIGEuyBGBrr18R9VdiCnlU+HJPOUBka
kXaP9SAav6IEmbAI0PKIhwrZoYRB1sVMs4K+GFv9KT+MAgjcwE6OBLZYy6pG+xmN
BoPvuoN/qRxJaaEBeY2PCMcb7aje6y2o1xnJiBLgnBXkWcXTX6w3Kps485ofdUKH
OTI+lDARRTZxll2ApYTH
=5+tf
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jan_2014_11_23_05_+1100_UITibO22A56igAQn--
