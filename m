Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3KFIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:41:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab3KFIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:41:22 -0500
Date: Wed, 6 Nov 2013 09:41:17 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the gpio tree with the arm-soc and
 cortex trees
Message-ID: <20131106084117.GT14892@pengutronix.de>
References: <20131106191454.5f45b0b5300f03e74a6a09eb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131106191454.5f45b0b5300f03e74a6a09eb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Wed, Nov 06, 2013 at 07:14:54PM +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> arch/arm/Kconfig between commit f3372c01816e ("ARM: gemini: convert to
> GENERIC_CLOCKEVENTS") from the arm-soc tree and f5caa3b59e18 ("ARM:
> deprecate mach/timex.h for !ARCH_MULTIPLATFORM") from the cortex tree and
> commits ffde39ea61ea ("ARM: mmp: delete the custom GPIO header"),
> 88f718e3fa4d ("ARM: pxa: delete the custom GPIO header") and 85649711a895
> ("ARM: gemini: delete <mach/gpio.h>") from the gpio tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
looks correct.

BTW, "cortex" is a bit too general. My tree is only about Cortex-M. Also
you can drop -2.6 from the URL.

Best regards
Uwe
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/Kconfig
> index 568d6471dd18,c6debe07f036..000000000000
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@@ -397,10 -386,8 +397,9 @@@ config ARCH_CLPS711
>   config ARCH_GEMINI
>   	bool "Cortina Systems Gemini"
>   	select ARCH_REQUIRE_GPIOLIB
>  -	select ARCH_USES_GETTIMEOFFSET
>  +	select CLKSRC_MMIO
>   	select CPU_FA526
>  +	select GENERIC_CLOCKEVENTS
> - 	select NEED_MACH_GPIO_H
>   	help
>   	  Support for the Cortina Systems Gemini family SoCs
>   
> @@@ -593,8 -558,6 +592,7 @@@ config ARCH_MM
>   	select GPIO_PXA
>   	select IRQ_DOMAIN
>   	select MULTI_IRQ_HANDLER
> - 	select NEED_MACH_GPIO_H
>  +	select NEED_MACH_TIMEX_H
>   	select PINCTRL
>   	select PLAT_PXA
>   	select SPARSE_IRQ
> @@@ -658,8 -620,6 +656,7 @@@ config ARCH_PX
>   	select GPIO_PXA
>   	select HAVE_IDE
>   	select MULTI_IRQ_HANDLER
> - 	select NEED_MACH_GPIO_H
>  +	select NEED_MACH_TIMEX_H
>   	select PLAT_PXA
>   	select SPARSE_IRQ
>   	help



-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
