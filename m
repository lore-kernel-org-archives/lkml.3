Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaAaM6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:58:10 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:50345 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121AbaAaM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:58:08 -0500
Message-ID: <52EB9C4A.7040105@st.com>
Date: Fri, 31 Jan 2014 12:51:22 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Patrice CHOTARD <patrice.chotard@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Cc: <maxime.coquelin@st.com>, <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 4/4] ARM: dts: add B2112 board support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-5-git-send-email-patrice.chotard@st.com>
In-Reply-To: <1391093744-19905-5-git-send-email-patrice.chotard@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/14 14:55, Patrice CHOTARD wrote:
> From: Alexandre TORGUE <alexandre.torgue@st.com>
> 
> Add support for B2112  board based on STiD127 SoC.
> 
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  arch/arm/boot/dts/Makefile          |    3 ++-
>  arch/arm/boot/dts/stid127-b2112.dts |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/stid127-b2112.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index d57c1a6..7173dca 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -247,7 +247,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
>  dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
>  	stih416-b2000.dtb \
>  	stih415-b2020.dtb \
> -	stih416-b2020.dtb
> +	stih416-b2020.dtb \
> +	stid127-b2112.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += \
>  	sun4i-a10-a1000.dtb \
>  	sun4i-a10-cubieboard.dtb \
> diff --git a/arch/arm/boot/dts/stid127-b2112.dts b/arch/arm/boot/dts/stid127-b2112.dts
> new file mode 100644
> index 0000000..b4507e3
> --- /dev/null
> +++ b/arch/arm/boot/dts/stid127-b2112.dts
> @@ -0,0 +1,35 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics Limited.

2014

> + * Author: Alexandre Torgue <alexandre.torgue@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * publishhed by the Free Software Foundation.

s/publishhed/published/

> + */
> +/dts-v1/;
> +#include "stid127.dtsi"
> +
> +/ {
> +	model = "STiD127 B2112 Board";
> +	compatible = "st,stid127", "st,stid127-b2112";
> +
> +	memory{
> +		device_type = "memory";
> +		reg = <0x40000000 0x10000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyAS0,115200";
> +		linux,stdout-path = &uart2;
> +	};
> +
> +	aliases {
> +		ttyAS0 = &uart2;
> +	};
> +
> +	soc {
> +		uart2: serial@fe532000{
> +			status = "okay";
> +		};
> +	};
> +};
> 

