Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3BSKbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:31:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40784 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab3BSKbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:31:35 -0500
Message-ID: <512354C7.1000409@ti.com>
Date: Tue, 19 Feb 2013 16:02:39 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 6/8] ARM: OMAP2+: am43: basic dt support
References: <cover.1361186097.git.afzal@ti.com> <64d18c5a07bf7680b8299f3ef98303e60522e738.1361186097.git.afzal@ti.com>
In-Reply-To: <64d18c5a07bf7680b8299f3ef98303e60522e738.1361186097.git.afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:
> Describe minimal DT boot machine details for AM43 based SoC's. AM43
> family of SoC's are ARM Cortex-A9 based with one core in SMP
> configuration. Low level debug could be achieved by selecting
> DEBUG_AM33XXUART1. To boot AM43 SoC, this change is sufficient w.r.t
> Kernel (considering the fact that strictly speaking DT sources does
> not classify as a part of Kernel). Here private timer of the one and
> only core is being used as clock event (as well as, as time source).
>
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
As discussed already, lets just call this as Cortex-A9 single core
machine to avoid confusion.

>   arch/arm/mach-omap2/board-generic.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 0274ff7..e083f08 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -15,7 +15,10 @@
>   #include <linux/of_irq.h>
>   #include <linux/of_platform.h>
>   #include <linux/irqdomain.h>
> +#include <linux/irqchip.h>
>
> +#include <asm/mach/map.h>
> +#include <asm/smp_twd.h>
>   #include <asm/mach/arch.h>
>
>   #include "common.h"
> @@ -182,3 +185,18 @@ DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
>   	.restart	= omap44xx_restart,
>   MACHINE_END
>   #endif
> +
> +#ifdef CONFIG_SOC_AM43
> +static const char *am43_boards_compat[] __initdata = {
> +	"ti,am43",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
> +	.map_io		= debug_ll_io_init,
> +	.init_irq	= irqchip_init,
With Arnds patch [1], the above can be dropped..

> +	.init_machine	= omap_generic_init,
> +	.init_time	= twd_local_timer_of_register,
This one needs to take care of other timers as well from start. So
better to take that approach from start.

Regards,
Santosh

[1] https://patchwork.kernel.org/patch/2074871/
