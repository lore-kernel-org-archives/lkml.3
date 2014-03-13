Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaCMKIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:08:44 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:55195 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaCMKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:08:40 -0400
Message-ID: <532183A4.5020600@gmail.com>
Date: Thu, 13 Mar 2014 10:08:36 +0000
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP device
 tree
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 11:06 AM, Antoine Ténart wrote:
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/Makefile         |  3 ++-
>   arch/arm/boot/dts/berlin2q-dmp.dts | 32 ++++++++++++++++++++++++++++++++
>   2 files changed, 34 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/berlin2q-dmp.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 032030361bef..1a2adadfb962 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -52,7 +52,8 @@ dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
>   dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>   dtb-$(CONFIG_ARCH_BERLIN) += \
>   	berlin2-sony-nsz-gs7.dtb	\
> -	berlin2cd-google-chromecast.dtb
> +	berlin2cd-google-chromecast.dtb	\
> +	berlin2q-dmp.dtb

If it is "the" Marvell reference board, the file should be named
berlin2q-marvell-dmp.dtb.

>   dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>   	da850-evm.dtb
>   dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
> diff --git a/arch/arm/boot/dts/berlin2q-dmp.dts b/arch/arm/boot/dts/berlin2q-dmp.dts
> new file mode 100644
> index 000000000000..6a98860e0251
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2q-dmp.dts
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +/dts-v1/;
> +#include "berlin2q.dtsi"
> +
> +/ {
> +	model = "Marvell BG2-Q DMP";
> +	compatible = "marvell,berlin2q-dmp", "marvell,berlin2q", "marvell,berlin";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x00000000 0x40000000>;

Please double-check Jisheng's comment about memory size.

> +	};
> +
> +	choosen {
> +		bootargs = "console=ttyS0,115200 earlyprintk";
> +	};
> +
> +	soc {
> +		apb@fc0000 {
> +			uart0: uart@9000 {
> +				status = "okay";
> +			};
> +		};
> +	};

And Arnd's comment about using &uart0 instead.

Beside the comments made, this all looks fine.

Sebastian

> +};
>

