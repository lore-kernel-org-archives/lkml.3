Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIXOsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:48:36 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61684 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIXOse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:48:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de,
        gerg@uclinux.org, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
Date: Wed, 24 Sep 2014 16:47:47 +0200
Message-ID: <3700375.DRR5iB2NGi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AmKTi+JY9vpRA3gSZ7yOOwXPejgxK6KQlCcVqR7D9eP
 3YcJoMDlEa5iarONw6xQ7q+YYq4LKlYhcBvTYFP4186zJe69tV
 rUBnq5bfiNvShMIisctb1D+rvDUFo7UxbYM8S4M3HxV3Gy2nj5
 SwXtbP51OoC7XEic4sNdzbFlayHIlwJyyj9R6th9xxABMJMRPu
 id7EBen/ErxvKBwzSPafmWoMyM/yjCHuAhbIKnE6QGHkuFL3kY
 rRUBEx9+sZt/Fa3dAEyP3EdGoBs8J+weZ9POW+klU31inWyn2t
 wvLVAjJYNKobX5sE0YiFO0UVNjzrZZIKXtQ0vaEzXn5FleRYfY
 d9G/jpAeQUtrT31d/usc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 16:18:01 Nicolas Ferre wrote:
> As there is currently no-one to take care of this old !MMU target and as its
> support in recent kernels is a bit rotten, remove this at91x40 support and the
> board file associated with it (at91eb01).
> There are modern ARM !MMU in Mainline now so this target is not interesting for
> building tests anymore. It would be better to start from these modern ARM !MMU
> platforms to reintroduce at91x40 support if needed.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 807b22dadcb6..f3bd8abd25c0 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -18,26 +18,22 @@ config HAVE_AT91_DBGU2
>  config AT91_USE_OLD_CLK
>  	bool
>  
> -config AT91_PMC_UNIT
> -	bool
> -	default !ARCH_AT91X40
> -
>  config COMMON_CLK_AT91
>  	bool
> -	default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
> +	default USE_OF && !AT91_USE_OLD_CLK
>  	select COMMON_CLK
>  
>  config OLD_CLK_AT91
>  	bool
> -	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
> +	default AT91_USE_OLD_CLK
>  
>  config AT91_SAM9_ALT_RESET
>  	bool
> -	default !ARCH_AT91X40
> +	default y
>  
>  config AT91_SAM9G45_RESET
>  	bool
> -	default !ARCH_AT91X40
> +	default y
>  
>  config AT91_SAM9_TIME
>  	bool

I think these can be simplified further: AT91_SAM9G45_RESET and
AT91_SAM9_ALT_RESET can just go away and the files put into
obj-y.

OLD_CLK_AT91 is the same as AT91_USE_OLD_CLK, so you could
just use that instead. I suspect the 'USE_OF' dependency for
COMMON_CLK_AT91 can also go away, since all platforms are
either board file based and select AT91_USE_OLD_CLK, or they
are DT based and don't.

	Arnd
