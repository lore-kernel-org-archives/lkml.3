Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaJAP7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:59:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36112 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbaJAP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:59:46 -0400
Date: Wed, 1 Oct 2014 17:59:17 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: at91: remove at91sam9g45/9m10 legacy board
 support
Message-ID: <20141001155917.GE3907@piout.net>
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412093987-30241-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412093987-30241-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/2014 at 18:19:42 +0200, Boris Brezillon wrote :
> Remove legacy support for at91sam9g45/9m10 boards.
> This include board files removal plus all legacy code for non DT boards
> support (i.e. at91sam9g45.c and at91sam9g45_devices.c).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

A tiny nitpick, else
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


> ---
>  arch/arm/mach-at91/Kconfig.non_dt        |   21 -
>  arch/arm/mach-at91/Makefile              |    4 -
>  arch/arm/mach-at91/at91sam9g45.c         |  403 -------
>  arch/arm/mach-at91/at91sam9g45_devices.c | 1915 ------------------------------
>  arch/arm/mach-at91/board-sam9m10g45ek.c  |  526 --------
>  5 files changed, 2869 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/at91sam9g45_devices.c
>  delete mode 100644 arch/arm/mach-at91/board-sam9m10g45ek.c
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index 9d45496..f658b69 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -10,355 +10,13 @@
>   *
>   */
>  
> -#include <linux/module.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/clk/at91_pmc.h>
> -
> -#include <asm/irq.h>
> -#include <asm/mach/arch.h>
>  #include <asm/mach/map.h>

That include is not needed.

>  #include <asm/system_misc.h>
> -#include <mach/at91sam9g45.h>
>  #include <mach/cpu.h>
>  #include <mach/hardware.h>
>  

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
