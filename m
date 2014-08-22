Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaHVDYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 23:24:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43211 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaHVDYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 23:24:49 -0400
Date: Fri, 22 Aug 2014 12:24:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: shmobile: Move legacy INTC definitions from
 irqs.h to intc.h
Message-ID: <20140822032445.GJ9099@verge.net.au>
References: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
 <1408541963-20736-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408541963-20736-3-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 03:39:23PM +0200, Geert Uytterhoeven wrote:
> Move all definitions for legacy INTC from the common "irqs.h" to the
> INTC-specific "intc.h".
> Include "intc.h" in sh7372/sh73a0 CPU and board files where needed.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, I have queued this up with Magnus's Ack after removing
the whitespace change noted below.

> ---
>  arch/arm/mach-shmobile/board-kzm9g.c    | 1 +
>  arch/arm/mach-shmobile/board-mackerel.c | 1 +
>  arch/arm/mach-shmobile/intc.h           | 6 ++++++
>  arch/arm/mach-shmobile/irqs.h           | 6 ------
>  arch/arm/mach-shmobile/setup-sh7372.c   | 1 +
>  arch/arm/mach-shmobile/setup-sh73a0.c   | 1 +
>  6 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
> index 36593cb20e57..77e36fa0b142 100644
> --- a/arch/arm/mach-shmobile/board-kzm9g.c
> +++ b/arch/arm/mach-shmobile/board-kzm9g.c
> @@ -50,6 +50,7 @@
>  #include <video/sh_mobile_lcdc.h>
>  
>  #include "common.h"
> +#include "intc.h"
>  #include "irqs.h"
>  #include "sh73a0.h"
>  
> diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
> index 79f448e93abb..b7c4261492b0 100644
> --- a/arch/arm/mach-shmobile/board-mackerel.c
> +++ b/arch/arm/mach-shmobile/board-mackerel.c
> @@ -63,6 +63,7 @@
>  #include <asm/mach-types.h>
>  
>  #include "common.h"
> +#include "intc.h"
>  #include "irqs.h"
>  #include "pm-rmobile.h"
>  #include "sh-gpio.h"
> diff --git a/arch/arm/mach-shmobile/intc.h b/arch/arm/mach-shmobile/intc.h
> index a5603c76cfe0..0313cf798c32 100644
> --- a/arch/arm/mach-shmobile/intc.h
> +++ b/arch/arm/mach-shmobile/intc.h
> @@ -1,5 +1,6 @@
>  #ifndef __ASM_MACH_INTC_H
>  #define __ASM_MACH_INTC_H
> +
>  #include <linux/sh_intc.h>
>  
>  #define INTC_IRQ_PINS_ENUM_16L(p)				\

I have removed the above hunk as it seems unrelated to the rest of the patch.

> @@ -287,4 +288,9 @@ static struct intc_desc p ## _desc __initdata = {			\
>  			     p ## _sense_registers, NULL),		\
>  }
>  
> +/* INTCS */
> +#define INTCS_VECT_BASE		0x3400
> +#define INTCS_VECT(n, vect)	INTC_VECT((n), INTCS_VECT_BASE + (vect))
> +#define intcs_evt2irq(evt)	evt2irq(INTCS_VECT_BASE + (evt))
> +
>  #endif  /* __ASM_MACH_INTC_H */
> diff --git a/arch/arm/mach-shmobile/irqs.h b/arch/arm/mach-shmobile/irqs.h
> index 8e28223f1b3c..3070f6d887eb 100644
> --- a/arch/arm/mach-shmobile/irqs.h
> +++ b/arch/arm/mach-shmobile/irqs.h
> @@ -1,18 +1,12 @@
>  #ifndef __SHMOBILE_IRQS_H
>  #define __SHMOBILE_IRQS_H
>  
> -#include <linux/sh_intc.h>
>  #include "include/mach/irqs.h"
>  
>  /* GIC */
>  #define gic_spi(nr)		((nr) + 32)
>  #define gic_iid(nr)		(nr) /* ICCIAR / interrupt ID */
>  
> -/* INTCS */
> -#define INTCS_VECT_BASE		0x3400
> -#define INTCS_VECT(n, vect)	INTC_VECT((n), INTCS_VECT_BASE + (vect))
> -#define intcs_evt2irq(evt)	evt2irq(INTCS_VECT_BASE + (evt))
> -
>  /* GPIO IRQ */
>  #define _GPIO_IRQ_BASE		2500
>  #define GPIO_IRQ_BASE(x)	(_GPIO_IRQ_BASE + (32 * x))
> diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
> index 3731eccccef4..eaf5d1332c4b 100644
> --- a/arch/arm/mach-shmobile/setup-sh7372.c
> +++ b/arch/arm/mach-shmobile/setup-sh7372.c
> @@ -41,6 +41,7 @@
>  
>  #include "common.h"
>  #include "dma-register.h"
> +#include "intc.h"
>  #include "irqs.h"
>  #include "pm-rmobile.h"
>  #include "sh7372.h"
> diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
> index e7a0296b81b1..4c7022830e30 100644
> --- a/arch/arm/mach-shmobile/setup-sh73a0.c
> +++ b/arch/arm/mach-shmobile/setup-sh73a0.c
> @@ -40,6 +40,7 @@
>  
>  #include "common.h"
>  #include "dma-register.h"
> +#include "intc.h"
>  #include "irqs.h"
>  #include "sh73a0.h"
>  
> -- 
> 1.9.1
> 
