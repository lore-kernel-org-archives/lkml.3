Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3EMTyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:54:17 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36561 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3EMTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:54:16 -0400
Message-ID: <519144DD.1090101@elopez.com.ar>
Date: Mon, 13 May 2013 16:54:05 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130428 Thunderbird/17.0.5
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: select ARCH_REQUIRE_GPIOLIB
References: <1368435188-26965-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368435188-26965-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 13/05/13 05:53, Maxime Ripard escribió:
> CONFIG_SUNXI currently doesn't enable a gpiolib, which causes build
> problems when building a kernel with only the sunxi platform enabled.
> Select ARCH_REQUIRE_GPIOLIB to solve this.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-sunxi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> index d259c78..5b045e3 100644
> --- a/arch/arm/mach-sunxi/Kconfig
> +++ b/arch/arm/mach-sunxi/Kconfig
> @@ -1,5 +1,6 @@
>  config ARCH_SUNXI
>  	bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
> +	select ARCH_REQUIRE_GPIOLIB
>  	select CLKSRC_MMIO
>  	select CLKSRC_OF
>  	select COMMON_CLK
> 

Tested-by: Emilio López <emilio@elopez.com.ar>

This fixes the build breakage I was seeing.

Thanks!

Emilio
