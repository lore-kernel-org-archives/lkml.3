Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3JWH2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:28:31 -0400
Received: from [213.199.154.252] ([213.199.154.252]:4032 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab3JWH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:28:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 23 Oct 2013 15:27:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rostislav Lisovy <lisovy@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH 3/4] ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
Message-ID: <20131023072738.GI2839@S2101-09.ap.freescale.net>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
 <1382461643-16790-4-git-send-email-lisovy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382461643-16790-4-git-send-email-lisovy@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 07:07:22PM +0200, Rostislav Lisovy wrote:
> Enable UART1 and FEC

You have more than these two enabled.

> 
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> 
>  create mode 100644 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
> 
> diff --git a/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
> new file mode 100644
> index 0000000..04695c9
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
> @@ -0,0 +1,195 @@
> +/*
> + * Copyright 2013 Rostislav Lisovy <lisovy@gmail.com>, PiKRON s.r.o.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include "imx53.dtsi"
> +
> +/ {
> +	model = "Voipac i.MX53 X53-DMM-668";
> +	compatible = "vp,imx53-dmm-668", "fsl,imx53";
> +
> +	memory@0 {
> +		device_type = "memory";
> +		reg = <0x70000000 0x20000000>;
> +	};
> +
> +	memory@1 {
> +		device_type = "memory";
> +		reg = <0xb0000000 0x20000000>;
> +	};

The 'num' in memory@num should match the first number in 'reg' property,
so they should looks like:

	memory@70000000 {
		device_type = "memory";
		reg = <0x70000000 0x20000000>;
	}

	memory@b0000000 {
		device_type = "memory";
		reg = <0xb0000000 0x20000000>;
	}

> +
> +	regulators {
> +		compatible = "simple-bus";
> +
> +		reg_3p3v: 3p3v {
> +			compatible = "regulator-fixed";
> +			regulator-name = "3P3V";
> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +			regulator-always-on;
> +		};
> +	};
> +};
> +
> +&iomuxc {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_hog>;
> +
> +	hog {
> +		pinctrl_hog: hoggrp {
> +			fsl,pins = <
> +				/* Make DA9053 regulator functional */
> +				MX53_PAD_GPIO_16__GPIO7_11	0x80000000
> +

Drop these blank lines.  We generally only have blank lines between
nodes.

> +				/* FEC Power enable */
> +				MX53_PAD_GPIO_11__GPIO4_1	0x80000000
> +
> +				/* FEC RST */
> +				MX53_PAD_GPIO_12__GPIO4_2	0x80000000
> +			>;
> +		};
> +	};
> +};
> +
> +&uart1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_uart1_2>;
> +	status = "okay";
> +};
> +
> +&i2c1 {

Please sort these nodes alphabetically in label name, so that new node
can find they slots easily.

Shawn

> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_i2c1_2>;
> +	status = "okay";
> +
> +	pmic: dialog@48 {
> +		compatible = "dlg,da9053-aa", "dlg,da9052";
> +		reg = <0x48>;
> +		interrupt-parent = <&gpio7>;
> +		interrupts = <11 0x8>; /* low-level active IRQ at GPIO7_11 */
> +
> +		regulators {
> +			buck1_reg: buck1 {
> +				regulator-name = "BUCKCORE";
> +				regulator-min-microvolt = <1200000>;
> +				regulator-max-microvolt = <1400000>;
> +				regulator-always-on;
> +			};
> +
> +			buck2_reg: buck2 {
> +				regulator-name = "BUCKPRO";
> +				regulator-min-microvolt = <900000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +
> +			buck3_reg: buck3 {
> +				regulator-name = "BUCKMEM";
> +				regulator-min-microvolt = <1420000>;
> +				regulator-max-microvolt = <1580000>;
> +				regulator-always-on;
> +			};
> +
> +			buck4_reg: buck4 {
> +				regulator-name = "BUCKPERI";
> +				regulator-min-microvolt = <2370000>;
> +				regulator-max-microvolt = <2630000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo1_reg: ldo1 {
> +				regulator-name = "ldo1_1v3";
> +				regulator-min-microvolt = <1250000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			ldo2_reg: ldo2 {
> +				regulator-name = "ldo2_1v3";
> +				regulator-min-microvolt = <1250000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo3_reg: ldo3 {
> +				regulator-name = "ldo3_3v3";
> +				regulator-min-microvolt = <3250000>;
> +				regulator-max-microvolt = <3350000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo4_reg: ldo4 {
> +				regulator-name = "ldo4_2v775";
> +				regulator-min-microvolt = <2770000>;
> +				regulator-max-microvolt = <2780000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo5_reg: ldo5 {
> +				regulator-name = "ldo5_3v3";
> +				regulator-min-microvolt = <3250000>;
> +				regulator-max-microvolt = <3350000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo6_reg: ldo6 {
> +				regulator-name = "ldo6_1v3";
> +				regulator-min-microvolt = <1250000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo7_reg: ldo7 {
> +				regulator-name = "ldo7_2v75";
> +				regulator-min-microvolt = <2700000>;
> +				regulator-max-microvolt = <2800000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo8_reg: ldo8 {
> +				regulator-name = "ldo8_1v8";
> +				regulator-min-microvolt = <1750000>;
> +				regulator-max-microvolt = <1850000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo9_reg: ldo9 {
> +				regulator-name = "ldo9_1v5";
> +				regulator-min-microvolt = <1450000>;
> +				regulator-max-microvolt = <1550000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo10_reg: ldo10 {
> +				regulator-name = "ldo10_1v3";
> +				regulator-min-microvolt = <1250000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +		};
> +	};
> +};
> +
> +&ecspi1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_ecspi1_1>;
> +	fsl,spi-num-chipselects = <4>;
> +	cs-gpios = <&gpio2 30 0>, <&gpio3 19 0>, <&gpio2 16 0>, <&gpio2 17 0>;
> +	status = "okay";
> +};
> +
> +&fec {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_fec_1>;
> +	phy-mode = "rmii";
> +	phy-reset-gpios = <&gpio4 2 0>;
> +	status = "okay";
> +};
> -- 
> 1.7.10.4
> 

