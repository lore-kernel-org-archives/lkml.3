Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaEMMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:06:19 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34346 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbaEMMGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:06:17 -0400
Message-ID: <53720A88.3050907@st.com>
Date: Tue, 13 May 2014 14:05:28 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Cc: <lee.jones@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v4 6/6] ARM: dts: STiH407: Add B2120
 board support
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com> <1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_03:2014-05-13,2014-05-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/12/2014 09:50 AM, Maxime COQUELIN wrote:
> B2120 HDK is the reference board for STiH407 SoC.
> It has the following characteristics:
>   - 1GB DDR3
>   - 8GB eMMC / SD-Card slot
>   - 32MB NOR Flash
>   - 1 x Gbit Ethernet
>   - 1 x USB 3.0 port
>   - 1 x Mini-PCIe
>   - 1 x SATA
>   - 1 x HDMI output
>   - 1 x HDMI input
>   - 1 x SPDIF
>
> This patch only introduces basic functionnalities, such as I2C and UART.
>
> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>   arch/arm/boot/dts/Makefile          |  3 +-
>   arch/arm/boot/dts/stih407-b2120.dts | 78 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 80 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 12455cf..f760a88 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -317,7 +317,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
>   dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
>   	stih416-b2000.dtb \
>   	stih415-b2020.dtb \
> -	stih416-b2020.dtb
> +	stih416-b2020.dtb \
> +	stih407-b2120.dtb
>   dtb-$(CONFIG_ARCH_SUNXI) += \
>   	sun4i-a10-a1000.dtb \
>   	sun4i-a10-cubieboard.dtb \
> diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
> new file mode 100644
> index 0000000..9c97da4
> --- /dev/null
> +++ b/arch/arm/boot/dts/stih407-b2120.dts
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +#include "stih407.dtsi"
> +/ {
> +	model = "STiH407 B2120";
> +	compatible = "st,stih407", "st,stih407-b2120";
> +
> +	chosen {
> +		bootargs = "console=ttyAS0,115200";
> +		linux,stdout-path = &sbc_serial0;
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x40000000 0x80000000>;
> +	};
> +
> +	aliases {
> +		ttyAS0 = &sbc_serial0;
> +	};
> +
> +	soc {
> +		sbc_serial0: serial@9530000 {
> +			status = "okay";
> +		};
> +
> +		leds {
> +			compatible = "gpio-leds";
> +			red {
> +				#gpio-cells = <2>;
> +				label = "Front Panel LED";
> +				gpios = <&PIO4 1 0>;
> +				linux,default-trigger = "heartbeat";
> +			};
> +			green {
> +				#gpio-cells = <2>;
> +				gpios = <&PIO1 3 0>;
> +				default-state = "off";
> +			};
> +		};
> +
> +		i2c@9842000 {
> +			status = "okay";
> +		};
> +
> +		i2c@9843000 {
> +			status = "okay";
> +		};
> +
> +		i2c@9844000 {
> +			status = "okay";
> +		};
> +
> +		i2c@9845000 {
> +			status = "okay";
> +		};
> +
> +		i2c@9540000 {
> +			status = "okay";
> +		};
> +
> +		/* SSC11 to HDMI */
> +		i2c@9541000 {
> +			status = "okay";
> +			/* HDMI V1.3a supports Standard mode only */
> +			clock-frequency = <100000>;
> +			st,i2c-min-scl-pulse-width-us = <0>;
> +			st,i2c-min-sda-pulse-width-us = <5>;
> +		};
> +	};
> +};

Acked-by: Patrice Chotard <patrice.chotard@st.com>
