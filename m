Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCKKuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:50:04 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:55062 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbaCKKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:50:02 -0400
Message-ID: <531EEA39.50504@st.com>
Date: Tue, 11 Mar 2014 11:49:29 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/3] ARM: DT: STi: Add support to B2020 revision E board.
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 03/11/2014 11:22 AM, Lee Jones wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch adds support to rev E board of B2020 which has few minor
> changes :
> 	PHY reset PIO (Change from PIO30 to PIO07)
> 	Power LED(Green) Control(Change from PIO47 to PIO13)

I thought we decided last October to support only one revision of the 
b2020 board.

The idea was to create an external git to provide DTS for all our 
boards, and only have a minimal subset in in the kernel.

Regards,
Maxime

>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>   arch/arm/boot/dts/Makefile               |  3 ++-
>   arch/arm/boot/dts/stih416-b2020-revE.dts | 36 ++++++++++++++++++++++++++++++++
>   2 files changed, 38 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 0320303..325218a 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -278,7 +278,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
>   dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
>   	stih416-b2000.dtb \
>   	stih415-b2020.dtb \
> -	stih416-b2020.dtb
> +	stih416-b2020.dtb \
> +	stih416-b2020-revE.dtb
>   dtb-$(CONFIG_ARCH_SUNXI) += \
>   	sun4i-a10-a1000.dtb \
>   	sun4i-a10-cubieboard.dtb \
> diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> new file mode 100644
> index 0000000..bcb9d00
> --- /dev/null
> +++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> @@ -0,0 +1,36 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
> + * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * publishhed by the Free Software Foundation.
> + */
> +/dts-v1/;
> +#include "stih416.dtsi"
> +#include "stih41x-b2020.dtsi"
> +/ {
> +        model = "STih416 B2020 REV. E";
> +	compatible = "st,stih416", "st,stih416-b2020";
> +
> +	soc {
> +
> +		leds {
> +			compatible	= "gpio-leds";
> +			red {
> +				#gpio-cells = <1>;
> +				label	= "Front Panel LED";
> +				gpios	= <&PIO4 1>;
> +				linux,default-trigger	= "heartbeat";
> +			};
> +			green {
> +				gpios	= <&PIO1 3>;
> +				default-state = "off";
> +			};
> +		};
> +
> +		ethernet1: ethernet@fef08000 {
> +			snps,reset-gpio 	= <&PIO0 7>;
> +		};
> +	};
> +};
>
