Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3JDI0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:26:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57472 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3JDI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:26:16 -0400
Message-ID: <524E7B83.2050200@ti.com>
Date: Fri, 4 Oct 2013 13:55:39 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>
CC: Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pawel.moll@arm.com>, <devicetree@vger.kernel.org>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <balajitk@ti.com>
Subject: Re: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
References: <1377495411-21984-1-git-send-email-j-keerthy@ti.com> <522E1FB2.10809@ti.com> <522FFFE2.2000705@ti.com> <524D7397.2000200@baylibre.com>
In-Reply-To: <524D7397.2000200@baylibre.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Thanks a lot for fixing it.

On Thursday 03 October 2013 07:09 PM, Benoit Cousson wrote:
> Hi Keerthy,
>
> On 11/09/2013 07:30, Keerthy wrote:
>> On Tuesday 10 September 2013 12:51 AM, Nishanth Menon wrote:
>>> On 08/26/2013 12:36 AM, Keerthy wrote:
>>>> The Patch adds nodes for TPS659038 PMIC for DRA7 boards.
>>>>
>>>> It is based on top of:
>>>> http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.
>>>>
>>>> Documentation:    Documentation/devicetree/bindings/mfd/palmas.txt
>>>>          Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>>>
>>>> Boot Tested on DRA7 d1 Board.
>>>>
>>>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>>>> ---
>>>>    arch/arm/boot/dts/dra7-evm.dts |  118
>>>> ++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 118 insertions(+)
>>>>
>>>> Index: linux/arch/arm/boot/dts/dra7-evm.dts
>>>> ===================================================================
>>>> --- linux.orig/arch/arm/boot/dts/dra7-evm.dts    2013-08-26
>>>> 09:57:52.496173554 +0530
>>>> +++ linux/arch/arm/boot/dts/dra7-evm.dts    2013-08-26
>>>> 10:38:44.995414695 +0530
>>>> @@ -93,6 +93,119 @@
>>>>        pinctrl-names = "default";
>>>>        pinctrl-0 = <&i2c1_pins>;
>>>>        clock-frequency = <400000>;
>>>> +
>>>> +    tps659038: tps659038@58 {
>>>> +        compatible = "ti,tps659038";
>>>> +        reg = <0x58>;
>>>> +
>>>> +        tps659038_pmic {
>>>> +            compatible = "ti,tps659038-pmic";
>>>> +
>>>> +            regulators {
>>>> +                smps123_reg: smps123 {
>>>> +                    /* VDD_MPU */
>>>> +                        regulator-name = "smps123";
>>>> +                        regulator-min-microvolt = < 850000>;
>>>> +                        regulator-max-microvolt = <1250000>;
>>>> +                        regulator-always-on;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                smps45_reg: smps45 {
>>>> +                        /* VDD_DSPEVE */
>>>> +                        regulator-name = "smps45";
>>>> +                        regulator-min-microvolt = < 850000>;
>>>> +                        regulator-max-microvolt = <1150000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                smps6_reg: smps6 {
>>>> +                        /* VDD_GPU - over VDD_SMPS6 */
>>>> +                        regulator-name = "smps6";
>>>> +                        regulator-min-microvolt = <850000>;
>>>> +                        regulator-max-microvolt = <12500000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                smps7_reg: smps7 {
>>>> +                        /* CORE_VDD */
>>>> +                        regulator-name = "smps7";
>>>> +                        regulator-min-microvolt = <850000>;
>>>> +                        regulator-max-microvolt = <1030000>;
>>>> +                        regulator-always-on;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                smps8_reg: smps8 {
>>>> +                        /* VDD_IVAHD */
>>>> +                        regulator-name = "smps8";
>>>> +                        regulator-min-microvolt = < 850000>;
>>>> +                        regulator-max-microvolt = <1250000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                smps9_reg: smps9 {
>>>> +                        /* VDDS1V8 */
>>>> +                        regulator-name = "smps9";
>>>> +                        regulator-min-microvolt = <1800000>;
>>>> +                        regulator-max-microvolt = <1800000>;
>>>> +                        regulator-always-on;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldo1_reg: ldo1 {
>>>> +                        /* LDO1_OUT --> SDIO  */
>>>> +                        regulator-name = "ldo1";
>>>> +                        regulator-min-microvolt = <1800000>;
>>>> +                        regulator-max-microvolt = <3300000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldo2_reg: ldo2 {
>>>> +                        /* VDD_RTCIO */
>>>> +                        /* LDO2 -> VDDSHV5, LDO2 also goes to
>>>> CAN_PHY_3V3 */
>>>> +                        regulator-name = "ldo2";
>>>> +                        regulator-min-microvolt = <3300000>;
>>>> +                        regulator-max-microvolt = <3300000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldo3_reg: ldo3 {
>>>> +                        /* VDDA_1V8_PHY */
>>>> +                        regulator-name = "ldo3";
>>>> +                        regulator-min-microvolt = <1800000>;
>>>> +                        regulator-max-microvolt = <1800000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldo9_reg: ldo9 {
>>>> +                        /* VDD_RTC */
>>>> +                        regulator-name = "ldo9";
>>>> +                        regulator-min-microvolt = <1050000>;
>>>> +                        regulator-max-microvolt = <1050000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldoln_reg: ldoln {
>>>> +                        /* VDDA_1V8_PLL */
>>>> +                        regulator-name = "ldoln";
>>>> +                        regulator-min-microvolt = <1800000>;
>>>> +                        regulator-max-microvolt = <1800000>;
>>>> +                        regulator-always-on;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
>>>> +                ldousb_reg: ldousb {
>>>> +                        /* VDDA_3V_USB: VDDA_USBHS33 */
>>>> +                        regulator-name = "ldousb";
>>>> +                        regulator-min-microvolt = <3300000>;
>>>> +                        regulator-max-microvolt = <3300000>;
>>>> +                        regulator-boot-on;
>>>> +                    };
>>>> +
> Nit: Extra blank line not needed.
>
>>>> +                };
>>>> +            };
>>>> +        };
>>>>    };
> Nit: You have an extra level on indentation not needed.
>
>>>>    &i2c2 {
>>>>
>>> Acked-by: Nishanth Menon <nm@ti.com>
> Beside the two minors nits, the patch looks good to me.
>
> Since, you've been waiting for some time for it, I fixed it myself and pulled it.
> I even fixed the changelog... Lucky you :-)
>
> You can check the updated version below.
>
> Sorry for the delay.
>
> Thanks,
> Benoit
>
> ---
>  From 3b8f02a2df475c7a48e12eb1911c014f8060b167 Mon Sep 17 00:00:00 2001
> From: Keerthy <j-keerthy@ti.com>
> Date: Mon, 26 Aug 2013 11:06:51 +0530
> Subject: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
>
> Add DT nodes for TPS659038 PMIC on DRA7 boards.
>
> It is based on top of:
> http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.
>
> Documentation:
> - Documentation/devicetree/bindings/mfd/palmas.txt
> - Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>
> Boot Tested on DRA7 d1 Board.
>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Acked-by: Nishanth Menon <nm@ti.com>
> [bcousson@baylibre.com: Fix indentation and changelog]
> Signed-off-by: Benoit Cousson <bcousson@baylibre.com>
> ---
>   arch/arm/boot/dts/dra7-evm.dts | 112 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 112 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index ca5dab2..fbbe406 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -93,6 +93,118 @@
>   	pinctrl-names = "default";
>   	pinctrl-0 = <&i2c1_pins>;
>   	clock-frequency = <400000>;
> +
> +	tps659038: tps659038@58 {
> +		compatible = "ti,tps659038";
> +		reg = <0x58>;
> +
> +		tps659038_pmic {
> +			compatible = "ti,tps659038-pmic";
> +
> +			regulators {
> +				smps123_reg: smps123 {
> +					/* VDD_MPU */
> +					regulator-name = "smps123";
> +					regulator-min-microvolt = < 850000>;
> +					regulator-max-microvolt = <1250000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				smps45_reg: smps45 {
> +					/* VDD_DSPEVE */
> +					regulator-name = "smps45";
> +					regulator-min-microvolt = < 850000>;
> +					regulator-max-microvolt = <1150000>;
> +					regulator-boot-on;
> +				};
> +
> +				smps6_reg: smps6 {
> +					/* VDD_GPU - over VDD_SMPS6 */
> +					regulator-name = "smps6";
> +					regulator-min-microvolt = <850000>;
> +					regulator-max-microvolt = <12500000>;
> +					regulator-boot-on;
> +				};
> +
> +				smps7_reg: smps7 {
> +					/* CORE_VDD */
> +					regulator-name = "smps7";
> +					regulator-min-microvolt = <850000>;
> +					regulator-max-microvolt = <1030000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				smps8_reg: smps8 {
> +					/* VDD_IVAHD */
> +					regulator-name = "smps8";
> +					regulator-min-microvolt = < 850000>;
> +					regulator-max-microvolt = <1250000>;
> +					regulator-boot-on;
> +				};
> +
> +				smps9_reg: smps9 {
> +					/* VDDS1V8 */
> +					regulator-name = "smps9";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-always-on;
> +					regulator-boot-on;
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
> +					/* VDD_RTCIO */
> +					/* LDO2 -> VDDSHV5, LDO2 also goes to CAN_PHY_3V3 */
> +					regulator-name = "ldo2";
> +					regulator-min-microvolt = <3300000>;
> +					regulator-max-microvolt = <3300000>;
> +					regulator-boot-on;
> +				};
> +
> +				ldo3_reg: ldo3 {
> +					/* VDDA_1V8_PHY */
> +					regulator-name = "ldo3";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-boot-on;
> +				};
> +
> +				ldo9_reg: ldo9 {
> +					/* VDD_RTC */
> +					regulator-name = "ldo9";
> +					regulator-min-microvolt = <1050000>;
> +					regulator-max-microvolt = <1050000>;
> +					regulator-boot-on;
> +				};
> +
> +				ldoln_reg: ldoln {
> +					/* VDDA_1V8_PLL */
> +					regulator-name = "ldoln";
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				ldousb_reg: ldousb {
> +					/* VDDA_3V_USB: VDDA_USBHS33 */
> +					regulator-name = "ldousb";
> +					regulator-min-microvolt = <3300000>;
> +					regulator-max-microvolt = <3300000>;
> +					regulator-boot-on;
> +				};
> +			};
> +		};
> +	};
>   };
>   
>   &i2c2 {
Looks good. Thanks once again.
