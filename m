Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaIRNBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:01:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59795 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaIRNBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:01:30 -0400
Message-ID: <541AD7A2.9020008@gmail.com>
Date: Thu, 18 Sep 2014 15:01:22 +0200
From: Matthias Brugger <matthias.bgg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        arm@kernel.org
CC: linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, yingjoe.chen@mediatek.com, hc.yen@mediatek.com,
        eddie.huang@mediatek.com, nathan.chung@mediatek.com,
        yh.chen@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Anders Berg <anders.berg@lsi.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] arm: mediatek: Add earlyprintk support for mt8127
 & mt8135
References: <1410963854-17154-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1410963854-17154-8-git-send-email-srv_yingjoe.chen@mediatek.com>
In-Reply-To: <1410963854-17154-8-git-send-email-srv_yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/09/14 16:24, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Enable low-level debug for Mediatek mt8127 & mt8135 SoC.
> 
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/Kconfig.debug | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index cfdd1c0..3888d17 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -842,6 +842,22 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  for Mediatek mt6589 based platforms on UART0.
>  
> +	config DEBUG_MT8127_UART0
> +		bool "Mediatek mt8127 UART0"
> +		depends on ARCH_MEDIATEK
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  for Mediatek mt8127 based platforms on UART0.
> +
> +	config DEBUG_MT8135_UART3
> +		bool "Mediatek mt8135 UART3"
> +		depends on ARCH_MEDIATEK
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  for Mediatek mt8135 based platforms on UART3.
> +
>  	config DEBUG_VEXPRESS_UART0_DETECT
>  		bool "Autodetect UART0 on Versatile Express Cortex-A core tiles"
>  		depends on ARCH_VEXPRESS && CPU_CP15_MMU
> @@ -1084,6 +1100,8 @@ config DEBUG_UART_PHYS
>  	default 0x101f1000 if ARCH_VERSATILE
>  	default 0x101fb000 if DEBUG_NOMADIK_UART
>  	default 0x11006000 if DEBUG_MT6589_UART0
> +	default 0x11002000 if DEBUG_MT8127_UART0
> +	default 0x11009000 if DEBUG_MT8135_UART3

These lines are ordered by the address.

>  	default 0x16000000 if ARCH_INTEGRATOR
>  	default 0x18000300 if DEBUG_BCM_5301X
>  	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
> @@ -1147,6 +1165,8 @@ config DEBUG_UART_VIRT
>  	default 0xf0201000 if DEBUG_BCM2835
>  	default 0xf1000300 if DEBUG_BCM_5301X
>  	default 0xf1006000 if DEBUG_MT6589_UART0
> +	default 0xf1002000 if DEBUG_MT8127_UART0
> +	default 0xf1009000 if DEBUG_MT8135_UART3

Same here.
Apart from that the patches look fine to me.

Cheers,
Matthias

>  	default 0xf11f1000 if ARCH_VERSATILE
>  	default 0xf1600000 if ARCH_INTEGRATOR
>  	default 0xf1c28000 if DEBUG_SUNXI_UART0
> 
