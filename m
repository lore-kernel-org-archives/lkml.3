Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaCCUmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:42:04 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44715 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaCCUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:41:59 -0500
Message-ID: <5314E911.5090000@baylibre.com>
Date: Mon, 03 Mar 2014 21:41:53 +0100
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Jack Mitchell <ml@embed.me.uk>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jack Mitchell <jack@embed.me.uk>,
        Matt Porter <mporter@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] ARM: dts: add BeagleBone Audio Cape (Rev A) dtsi
References: <1390388785-19605-1-git-send-email-ml@embed.me.uk> <20140228221742.GJ13624@atomide.com>
In-Reply-To: <20140228221742.GJ13624@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/2014 23:17, Tony Lindgren wrote:
> * Jack Mitchell <ml@embed.me.uk> [140122 03:09]:
>> From: Jack Mitchell <jack@embed.me.uk>
>>
>> Devicetree include file for setting up the am335x mcasp bus, i2c-2
>> bus, and audio codec required for a functioning BeagleBone Audio Cape.
>>
>> Signed-off-by: Jack Mitchell <jack@embed.me.uk>
>> Signed-off-by: Matt Porter <mporter@linaro.org>
>> ---
>>   arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi | 124 +++++++++++++++++++++
>>   arch/arm/boot/dts/am335x-bone-common.dtsi          |  14 +++
>>   2 files changed, 138 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi
>>
>> diff --git a/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi b/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi
>> new file mode 100644
>> index 0000000..b8ec3dc
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi
>> @@ -0,0 +1,124 @@
>> +/*
>> + * Copyright (C) 2014 Jack Mitchell <jack@embed.me.uk>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * In order to enable the BeagleBone Audio Cape this dtsi must be
>> + * incuded in the top level dts. On BeagleBone Black hardware the
>> + * status of the HDMI dts node must also be set to "disabled".
>
> Seems like this is unsafe to merge then? This probably also needs
> comments from Peter Ujfalusi, added him to Cc.

Maybe, we'd better define a new DTS board (like 
am335x-boneblack-audio.dts) if we cannot use audio cape without losing 
the HDMI.
Since we don't have mechanism like overlay, we don't have the choice but 
defining several boards for each cape variant.

BTW, what is the conflict source with HDMI?
At some point I remember that the mcasp for audio cape was broken 
because of changes in the mcasp for the HDMI, but it is not the case 
anymore, thanks to the cleanup from Jyri.

>
>> + * --- a/arch/arm/boot/dts/am335x-bone.dts
>> + * +++ b/arch/arm/boot/dts/am335x-bone.dts
>> + * @@ -9,6 +9,7 @@
>> + *
>> + *  #include "am33xx.dtsi"
>> + *  #include "am335x-bone-common.dtsi"
>> + * +#include "am335x-bone-audio-cape-reva.dtsi"
>> + *
>> + *  &ldo3_reg {
>> + *  	regulator-min-microvolt = <1800000>;
>> + *
>> + * On BeagleBone Black hardware the status of the HDMI dts node must
>> + * also be set to "disabled"
>> + *
>> + * --- a/arch/arm/boot/dts/am335x-boneblack.dts
>> + * +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>> + * @@ -73,6 +74,6 @@
>> + *  		pinctrl-names = "default", "off";
>> + *  		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
>> + *  		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
>> + * -		status = "okay";
>> + * +		status = "disabled";
>> + *  	};
>> + *  };
>> + */
>> +
>> +/ {
>> +	sound {
>> +		compatible = "ti,da830-evm-audio";
>> +		ti,model = "AM335x BeagleBone Audio Cape Rev. A";
>> +		ti,audio-codec = <&tlv320aic3106>;
>> +		ti,mcasp-controller = <&mcasp0>;
>> +		ti,codec-clock-rate = <12000000>;
>> +		ti,audio-routing =
>> +			"Headphone Jack",       "HPLOUT",
>> +			"Headphone Jack",       "HPROUT",
>> +			"LINE1L",               "Line In",
>> +			"LINE1R",               "Line In";
>> +	};
>> +
>> +	audio-cape-gpio-leds {
>> +		compatible = "gpio-leds";
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&bone_audio_cape_led_pins>;
>> +
>> +		audio-led0 {
>> +			label = "audio:green:usr0";
>> +			gpios = <&gpio1 18 GPIO_ACTIVE_HIGH>;
>> +			linux,default-trigger = "heartbeat";
>> +			default-state = "off";
>> +		};
>> +
>> +		audio-led1 {
>> +			label = "audio:green:usr1";
>> +			gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
>> +			linux,default-trigger = "mmc0";
>> +			default-state = "off";
>> +		};
>> +	};
>> +};
>> +
>> +&am33xx_pinmux {
>> +	bone_audio_cape_led_pins: pinmux_bone_audio_cape_led_pins {
>> +		pinctrl-single,pins = <
>> +			0x48 (PIN_OUTPUT_PULLDOWN | MUX_MODE7) /* gpmc_a2.gpio1_18 */
>> +			0x4c (PIN_OUTPUT_PULLDOWN | MUX_MODE7) /* gpmc_a3.gpio1_19 */
>> +		>;
>> +	};
>> +
>> +	bone_audio_cape_pins: bone_audio_cape_pins {
>> +		pinctrl-single,pins = <
>> +			0x190 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mcasp0_aclkx.mcasp0_aclkx */
>> +			0x194 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mcasp0_fsx.mcasp0_fsx */
>> +			0x19c (PIN_INPUT_PULLUP | MUX_MODE2)	/* mcasp0_ahclkr.mcasp0_axr2 */
>> +			0x1ac (PIN_INPUT_PULLUP | MUX_MODE2)	/* mcasp0_ahclkx.mcasp0_axr3 */
>> +		>;
>> +	};
>> +};
>> +
>> +&i2c2 {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&i2c2_pins>;
>> +
>> +	status = "okay";
>> +	clock-frequency = <100000>;
>> +
>> +	tlv320aic3106: tlv320aic3106@1b {

A more generic name will be prefered here.

Regards,
Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
