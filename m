Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaG1J0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:26:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57639 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaG1J0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:26:39 -0400
Message-ID: <53D616B6.3030806@ti.com>
Date: Mon, 28 Jul 2014 14:54:06 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>
CC: <nm@ti.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <galak@codeaurora.org>, <lokeshvutla@ti.com>
Subject: Re: [PATCH 1/2] ARM: dts: dra72-evm: Enable I2C1 node
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com> <1406528334-4415-2-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1406528334-4415-2-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 11:48 AM, Keerthy wrote:
> From: Keerthy J <j-keerthy@ti.com>
>
> I2C1 bus is used for the following peripherals
> 	P8 connector (MLB)
> 	TLV320AIC3106 Audio codec
> 	J15 LCD header
> 	24WC256 eeprom
> 	TMP102AIDRLT temperature sensor
> 	PCF8575 GPIO expander
> 	PCA9306 i2c voltage translator -> Goes to P9 for comm interface
> 	P2 expansion connector
> 	TPS65917 PMIC
>
> The slowest speed of all the peripherals seems to be 400KHz.

Correcting the 'to' list.

>
> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>   arch/arm/boot/dts/dra72-evm.dts |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
> index 5147023..1e12862 100644
> --- a/arch/arm/boot/dts/dra72-evm.dts
> +++ b/arch/arm/boot/dts/dra72-evm.dts
> @@ -19,6 +19,22 @@
>   	};
>   };
>   
> +&dra7_pmx_core {
> +	i2c1_pins: pinmux_i2c1_pins {
> +		pinctrl-single,pins = <
> +			0x400 (PIN_INPUT | MUX_MODE0) /* i2c1_sda.i2c1_sda */
> +			0x404 (PIN_INPUT | MUX_MODE0) /* i2c1_scl.i2c1_scl */
> +		>;
> +	};
> +};
> +
> +&i2c1 {
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2c1_pins>;
> +	clock-frequency = <400000>;
> +};
> +
>   &uart1 {
>   	status = "okay";
>   };

