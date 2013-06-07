Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3FGM1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:27:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52618 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3FGM1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:27:45 -0400
Message-ID: <51B1D1A9.40702@ti.com>
Date: Fri, 7 Jun 2013 14:27:21 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldewangan@nvidia.com>,
        <grant.likely@secretlab.ca>, <swarren@wwwdotorg.org>,
        <swarren@nvidia.com>, <sameo@linux.intel.com>, <gg@slimlogic.co.uk>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH] ARM: dts: add dtsi for palmas
References: <1370604504-32310-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1370604504-32310-1-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keerthy,

On 06/07/2013 01:28 PM, J Keerthy wrote:
> Adds palmas mfd and palmas regulator nodes. This is
> based on the patch series:
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg89957.html
> 
> The device tree nodes are based on:
> https://lkml.org/lkml/2013/6/6/25

It looks like the board node to use palmas is missing? I cannot find it
in the previous series as well?

> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  arch/arm/boot/dts/palmas.dtsi |  171 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 171 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/palmas.dtsi
> 
> diff --git a/arch/arm/boot/dts/palmas.dtsi b/arch/arm/boot/dts/palmas.dtsi
> new file mode 100644
> index 0000000..be631b5
> --- /dev/null
> +++ b/arch/arm/boot/dts/palmas.dtsi
> @@ -0,0 +1,171 @@
> +/*
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +&palmas {
> +	compatible = "ti,palmas";
> +	interrupt-controller;
> +	#interrupt-cells = <2>;

The I2C address should be there as well. We used to put it in the board
file, but this is really an I2C device specific information and not
board specific in that case.

Regards,
Benoit


> +
> +	palmas_pmic {
> +		compatible = "ti,palmas-pmic";
> +		interrupt-parent = <&palmas>;
> +		interrupts = <14 IRQ_TYPE_NONE>;
> +		interrupt-name = "short-irq";
> +
> +		ti,ldo6-vibrator;
> +
> +		regulators {
> +			smps123_reg: smps123 {
> +				regulator-name = "smps123";
> +				regulator-min-microvolt = < 600000>;
> +				regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			smps45_reg: smps45 {
> +				regulator-name = "smps45";
> +				regulator-min-microvolt = < 600000>;
> +				regulator-max-microvolt = <1310000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			smps6_reg: smps6 {
> +				regulator-name = "smps6";
> +				regulator-min-microvolt = <1200000>;
> +				regulator-max-microvolt = <1200000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			smps7_reg: smps7 {
> +				regulator-name = "smps7";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			smps8_reg: smps8 {
> +				regulator-name = "smps8";
> +				regulator-min-microvolt = < 600000>;
> +				regulator-max-microvolt = <1310000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			smps9_reg: smps9 {
> +				regulator-name = "smps9";
> +				regulator-min-microvolt = <2100000>;
> +				regulator-max-microvolt = <2100000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +				ti,smps-range = <0x80>;
> +			};
> +
> +			smps10_reg: smps10 {
> +				regulator-name = "smps10";
> +				regulator-min-microvolt = <5000000>;
> +				regulator-max-microvolt = <5000000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo1_reg: ldo1 {
> +				regulator-name = "ldo1";
> +				regulator-min-microvolt = <2800000>;
> +				regulator-max-microvolt = <2800000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo2_reg: ldo2 {
> +				regulator-name = "ldo2";
> +				regulator-min-microvolt = <2900000>;
> +				regulator-max-microvolt = <2900000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo3_reg: ldo3 {
> +				regulator-name = "ldo3";
> +				regulator-min-microvolt = <3000000>;
> +				regulator-max-microvolt = <3000000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo4_reg: ldo4 {
> +				regulator-name = "ldo4";
> +				regulator-min-microvolt = <2200000>;
> +				regulator-max-microvolt = <2200000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo5_reg: ldo5 {
> +				regulator-name = "ldo5";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo6_reg: ldo6 {
> +				regulator-name = "ldo6";
> +				regulator-min-microvolt = <1500000>;
> +				regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo7_reg: ldo7 {
> +				regulator-name = "ldo7";
> +				regulator-min-microvolt = <1500000>;
> +				regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo8_reg: ldo8 {
> +				regulator-name = "ldo8";
> +				regulator-min-microvolt = <1500000>;
> +				regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldo9_reg: ldo9 {
> +				regulator-name = "ldo9";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldoln_reg: ldoln {
> +				regulator-name = "ldoln";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			ldousb_reg: ldousb {
> +				regulator-name = "ldousb";
> +				regulator-min-microvolt = <3250000>;
> +				regulator-max-microvolt = <3250000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +		};
> +	};
> +};
> 

