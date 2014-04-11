Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaDKJFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:05:49 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40375 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaDKJFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:05:46 -0400
Message-ID: <5347B065.8060001@gmail.com>
Date: Fri, 11 Apr 2014 11:05:41 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/5] ARM: berlin: add the pinctrl dependency for
 the Marvell Berlin SoCs
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com> <1397135274-10764-4-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1397135274-10764-4-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 03:07 PM, Antoine Ténart wrote:
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/mach-berlin/Kconfig | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> index d3c5f14dc142..291f1cac6c3d 100644
> --- a/arch/arm/mach-berlin/Kconfig
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -4,6 +4,8 @@ config ARCH_BERLIN
>   	select GENERIC_IRQ_CHIP
>   	select DW_APB_ICTL
>   	select DW_APB_TIMER_OF
> +	select PINCTRL
> +	select PINCTRL_BERLIN

As said in the review of the previous patch, drop PINCTRL here
and select it in the PINCTRL_BERLIN Kconfig. Also, you'll need
PINCTRL_BERLIN_BG2 and PINCTRL_BERLIN_BG2Q as we don't want to
bloat each Berlin kernel with both drivers.

Sebastian

>
>   if ARCH_BERLIN
>
>

