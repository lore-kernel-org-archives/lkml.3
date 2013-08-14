Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3HNXfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:35:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41483 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963Ab3HNXfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:35:50 -0400
Message-ID: <520C1451.7080203@ti.com>
Date: Wed, 14 Aug 2013 18:35:45 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <balajitk@ti.com>
Subject: Re: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
References: <1376372556-4244-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1376372556-4244-1-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-omap, linux-arm-list should also be CCed, Benoit needs to be
addressed for allowing him to merge,

I have not done a proper schematics Vs data manual review yet
(apologies on that), but, a couple of comments:

On 08/13/2013 12:42 AM, Keerthy wrote:
> The Patch adds nodes for TPS659038 PMIC for DRA7 boards.
> 
> It is based on:
> http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.
> 
> Documentation:	Documentation/devicetree/bindings/mfd/palmas.txt
> 		Documentation/devicetree/bindings/regulator/palmas-pmic.txt		
> 
> Tested on DRA7 Board, 3.11-rc5 plus the above patch-set.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  arch/arm/boot/dts/dra7-evm.dts |  118 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index b270e24..96f409f 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -93,6 +93,124 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&i2c1_pins>;
>  	clock-frequency = <400000>;
> +
> +	tps659038: tps659038@58 {
> +		compatible = "ti,tps659038";
> +		reg = <0x58>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;

Where is the interrupt line to MPU? if it is not hooked up, why the
interrupt controller?

> +
> +		tps659038_pmic {
> +			compatible = "ti,tps659038-pmic";
> +
> +			regulators {
> +				smps123_reg: smps123 {
> +					/* VDD_MPU */
					^^ tab issue?
> +						regulator-name = "smps123";
> +						regulator-min-microvolt = < 600000>;
> +						regulator-max-microvolt = <1500000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				smps45_reg: smps45 {
> +						/* VDD_DSPEVE */
> +						regulator-name = "smps45";
> +						regulator-min-microvolt = < 600000>;
> +						regulator-max-microvolt = <1310000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				smps6_reg: smps6 {
> +						/* VDD_GPU - over VDD_SMPS6 */
> +						regulator-name = "smps6";
> +						regulator-min-microvolt = <600000>;
> +						regulator-max-microvolt = <13100000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				smps7_reg: smps7 {
> +						/* VDDS_CORE */
> +						regulator-name = "smps7";
> +						regulator-min-microvolt = <600000>;
> +						regulator-max-microvolt = <1310000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				smps8_reg: smps8 {
> +						/* VDD_IVAHD */
> +						regulator-name = "smps8";
> +						regulator-min-microvolt = < 600000>;
> +						regulator-max-microvolt = <1310000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				smps9_reg: smps9 {
> +						/* VDD_1V8 */
> +						regulator-name = "smps9";
> +						regulator-min-microvolt = <1800000>;
> +						regulator-max-microvolt = <1800000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				ldo1_reg: ldo1 {
> +						/* LDO1_OUT --> SDIO  */
> +						regulator-name = "ldo1";
> +						regulator-min-microvolt = <1800000>;
> +						regulator-max-microvolt = <3300000>;
> +					};
> +
> +				ldo2_reg: ldo2 {
> +						/* VDD_RTCIO */
> +						regulator-name = "ldo2";
> +						regulator-min-microvolt = <3300000>;
> +						regulator-max-microvolt = <3300000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				ldo3_reg: ldo3 {
> +						/* VDDA_1V8 PHYs */
> +						regulator-name = "ldo3";
> +						regulator-min-microvolt = <1800000>;
> +						regulator-max-microvolt = <1800000>;
> +					};
> +
> +				ldo9_reg: ldo9 {
> +						/* VDD_RTC */
> +						regulator-name = "ldo9";
> +						regulator-min-microvolt = <1000000>;
> +						regulator-max-microvolt = <1000000>;
> +						regulator-boot-on;
> +						regulator-always-on;
> +					};
> +
> +				ldoln_reg: ldoln {
> +						/* VDDA_1v8: PLLs */
> +						regulator-name = "ldoln";
> +						regulator-min-microvolt = <1800000>;
> +						regulator-max-microvolt = <1800000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				ldousb_reg: ldousb {
> +						/* VDDA_3V_USB: VDDA_USBHS33 */
> +						regulator-name = "ldousb";
> +						regulator-min-microvolt = <3250000>;
> +						regulator-max-microvolt = <3250000>;
> +						regulator-always-on;
> +						regulator-boot-on;
> +					};
> +
> +				};
> +			};
> +		};

Who are using these LDOs? Example SDIO LDO should be linked up with
MMC instance, no? how about the PLLs and PHYs?


>  };
>  
>  &i2c2 {
> 


-- 
Regards,
Nishanth Menon
