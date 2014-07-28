Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaG1JZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:25:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56229 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbaG1JZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:25:38 -0400
Message-ID: <53D61681.9040906@ti.com>
Date: Mon, 28 Jul 2014 14:53:13 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>
CC: <nm@ti.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <galak@codeaurora.org>, <lokeshvutla@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: dra72-evm: Add tps65917 PMIC node
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com> <1406528334-4415-3-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1406528334-4415-3-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 11:48 AM, Keerthy wrote:
> From: Keerthy J <j-keerthy@ti.com>
>
> DRA72x-evm uses TPS65917 PMIC. Add the node.
>
> NOTE: LDO2 is actually unused, but the usage if any is expected to be
> between 1.8 to 3.3v IO voltage. So define the node.
>
> NOTE: Interrupt used is crossbar number based.

Correcting the 'to' list.

> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>   arch/arm/boot/dts/dra72-evm.dts |  104 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 104 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
> index 1e12862..4107428 100644
> --- a/arch/arm/boot/dts/dra72-evm.dts
> +++ b/arch/arm/boot/dts/dra72-evm.dts
> @@ -33,6 +33,110 @@
>   	pinctrl-names = "default";
>   	pinctrl-0 = <&i2c1_pins>;
>   	clock-frequency = <400000>;
> +
> +	tps65917: tps65917@58 {
> +		compatible = "ti,tps65917";
> +		reg = <0x58>;
> +
> +		interrupts = <GIC_SPI 2 IRQ_TYPE_NONE>;  /* IRQ_SYS_1N */
> +		interrupt-parent = <&gic>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +
> +		ti,system-power-controller;
> +
> +		tps65917_pmic {
> +			compatible = "ti,tps65917-pmic";
> +
> +			regulators {
> +				smps1_reg: smps1 {
> +					/* VDD_MPU */
> +					regulator-name = "smps1";
> +					regulator-min-microvolt = <850000>;
> +					regulator-max-microvolt = <1250000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				smps2_reg: smps2 {
> +					/* VDD_CORE */
> +					regulator-name = "smps2";
> +					regulator-min-microvolt = <850000>;
> +					regulator-max-microvolt = <1030000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				smps3_reg: smps3 {
> +					/* VDD_GPU IVA DSPEVE */
> +					regulator-name = "smps3";
> +					regulator-min-microvolt = <850000>;
> +					regulator-max-microvolt = <1250000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				smps4_reg: smps4 {
> +					/* VDDS1V8 */
> +					regulator-name = "smps4";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				smps5_reg: smps5 {
> +					/* VDD_DDR */
> +					regulator-name = "smps5";
> +					regulator-min-microvolt = <1350000>;
> +					regulator-max-microvolt = <1350000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				ldo1_reg: ldo1 {
> +					/* LDO1_OUT --> SDIO  */
> +					regulator-name = "ldo1";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <3300000>;
> +					regulator-boot-on;
> +				};
> +
> +				ldo2_reg: ldo2 {
> +					/* LDO2_OUT --> TP1017 (UNUSED)  */
> +					regulator-name = "ldo2";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <3300000>;
> +				};
> +
> +				ldo3_reg: ldo3 {
> +					/* VDDA_1V8_PHY */
> +					regulator-name = "ldo3";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				ldo5_reg: ldo5 {
> +					/* VDDA_1V8_PLL */
> +					regulator-name = "ldo5";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				ldo4_reg: ldo4 {
> +					/* VDDA_3V_USB: VDDA_USBHS33 */
> +					regulator-name = "ldo4";
> +					regulator-min-microvolt = <3300000>;
> +					regulator-max-microvolt = <3300000>;
> +					regulator-boot-on;
> +				};
> +			};
> +		};
> +	};
>   };
>   
>   &uart1 {

