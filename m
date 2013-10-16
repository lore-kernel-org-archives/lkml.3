Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab3JPPaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:30:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20618 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3JPPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:30:01 -0400
Message-ID: <525EB0F3.6050707@atmel.com>
Date: Wed, 16 Oct 2013 17:29:55 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mike Turquette" <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 01/17] ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com> <1381477081-6041-2-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1381477081-6041-2-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 09:37, Boris BREZILLON :
> This patch moves at91_pmc.h header from machine specific directory
> (arch/arm/mach-at91/include/mach/at91_pmc.h) to clk include directory
> (include/linux/clk/at91_pmc.h).
> We need this to avoid reference to machine specific headers in clk
> drivers.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/mach-at91/at91rm9200.c                    |    2 +-
>   arch/arm/mach-at91/at91sam9260.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9261.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9263.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
>   arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
>   arch/arm/mach-at91/clock.c                         |    2 +-
>   arch/arm/mach-at91/pm.c                            |    2 +-
>   arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>   arch/arm/mach-at91/sama5d3.c                       |    2 +-
>   arch/arm/mach-at91/setup.c                         |    2 +-
>   drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>   .../include/mach => include/linux/clk}/at91_pmc.h  |    2 +-
>   15 files changed, 15 insertions(+), 15 deletions(-)
>   rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (99%)
>
> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> index 4aad93d..102dac6 100644
> --- a/arch/arm/mach-at91/at91rm9200.c
> +++ b/arch/arm/mach-at91/at91rm9200.c
> @@ -12,13 +12,13 @@
>
>   #include <linux/module.h>
>   #include <linux/reboot.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>
>   #include <asm/system_misc.h>
>   #include <mach/at91rm9200.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/at91_st.h>
>   #include <mach/cpu.h>
>
> diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
> index 5de6074..16d7817 100644
> --- a/arch/arm/mach-at91/at91sam9260.c
> +++ b/arch/arm/mach-at91/at91sam9260.c
> @@ -11,6 +11,7 @@
>    */
>
>   #include <linux/module.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/proc-fns.h>
>   #include <asm/irq.h>
> @@ -20,7 +21,6 @@
>   #include <mach/cpu.h>
>   #include <mach/at91_dbgu.h>
>   #include <mach/at91sam9260.h>
> -#include <mach/at91_pmc.h>
>
>   #include "at91_aic.h"
>   #include "at91_rstc.h"
> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
> index 0e07932..c8f5958 100644
> --- a/arch/arm/mach-at91/at91sam9261.c
> +++ b/arch/arm/mach-at91/at91sam9261.c
> @@ -11,6 +11,7 @@
>    */
>
>   #include <linux/module.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/proc-fns.h>
>   #include <asm/irq.h>
> @@ -19,7 +20,6 @@
>   #include <asm/system_misc.h>
>   #include <mach/cpu.h>
>   #include <mach/at91sam9261.h>
> -#include <mach/at91_pmc.h>
>
>   #include "at91_aic.h"
>   #include "at91_rstc.h"
> diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
> index 6ce7d18..cd8ad95 100644
> --- a/arch/arm/mach-at91/at91sam9263.c
> +++ b/arch/arm/mach-at91/at91sam9263.c
> @@ -11,6 +11,7 @@
>    */
>
>   #include <linux/module.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/proc-fns.h>
>   #include <asm/irq.h>
> @@ -18,7 +19,6 @@
>   #include <asm/mach/map.h>
>   #include <asm/system_misc.h>
>   #include <mach/at91sam9263.h>
> -#include <mach/at91_pmc.h>
>
>   #include "at91_aic.h"
>   #include "at91_rstc.h"
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index 474ee04..9794b20 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -12,13 +12,13 @@
>
>   #include <linux/module.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>
>   #include <asm/system_misc.h>
>   #include <mach/at91sam9g45.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include "at91_aic.h"
> diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
> index c7d670d..5b83c66 100644
> --- a/arch/arm/mach-at91/at91sam9n12.c
> +++ b/arch/arm/mach-at91/at91sam9n12.c
> @@ -8,12 +8,12 @@
>
>   #include <linux/module.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>
>   #include <mach/at91sam9n12.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include "board.h"
> diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
> index d4ec0d9..947da95 100644
> --- a/arch/arm/mach-at91/at91sam9rl.c
> +++ b/arch/arm/mach-at91/at91sam9rl.c
> @@ -10,6 +10,7 @@
>    */
>
>   #include <linux/module.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/proc-fns.h>
>   #include <asm/irq.h>
> @@ -19,7 +20,6 @@
>   #include <mach/cpu.h>
>   #include <mach/at91_dbgu.h>
>   #include <mach/at91sam9rl.h>
> -#include <mach/at91_pmc.h>
>
>   #include "at91_aic.h"
>   #include "at91_rstc.h"
> diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
> index 916e5a1..a930d73 100644
> --- a/arch/arm/mach-at91/at91sam9x5.c
> +++ b/arch/arm/mach-at91/at91sam9x5.c
> @@ -8,12 +8,12 @@
>
>   #include <linux/module.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>
>   #include <mach/at91sam9x5.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include "board.h"
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 6b2630a..5f02aea 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -24,9 +24,9 @@
>   #include <linux/clk.h>
>   #include <linux/io.h>
>   #include <linux/of_address.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <mach/hardware.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include <asm/proc-fns.h>
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 15afb5d..692cacd 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -19,13 +19,13 @@
>   #include <linux/module.h>
>   #include <linux/platform_device.h>
>   #include <linux/io.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <linux/atomic.h>
>   #include <asm/mach/time.h>
>   #include <asm/mach/irq.h>
>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include "at91_aic.h"
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index 098c28d..2001877 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -13,8 +13,8 @@
>    */
>
>   #include <linux/linkage.h>
> +#include <linux/clk/at91_pmc.h>
>   #include <mach/hardware.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/at91_ramc.h>
>
>
> diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
> index 4012797..0003949 100644
> --- a/arch/arm/mach-at91/sama5d3.c
> +++ b/arch/arm/mach-at91/sama5d3.c
> @@ -9,12 +9,12 @@
>
>   #include <linux/module.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/irq.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>
>   #include <mach/sama5d3.h>
> -#include <mach/at91_pmc.h>
>   #include <mach/cpu.h>
>
>   #include "soc.h"
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index b17fbcf..41aa68b 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -11,6 +11,7 @@
>   #include <linux/pm.h>
>   #include <linux/of_address.h>
>   #include <linux/pinctrl/machine.h>
> +#include <linux/clk/at91_pmc.h>
>
>   #include <asm/system_misc.h>
>   #include <asm/mach/map.h>
> @@ -18,7 +19,6 @@
>   #include <mach/hardware.h>
>   #include <mach/cpu.h>
>   #include <mach/at91_dbgu.h>
> -#include <mach/at91_pmc.h>
>
>   #include "at91_shdwc.h"
>   #include "soc.h"
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 2cb52e0..9f71d9f 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -326,7 +326,7 @@ static int vbus_is_present(struct usba_udc *udc)
>
>   #if defined(CONFIG_ARCH_AT91SAM9RL)
>
> -#include <mach/at91_pmc.h>
> +#include <linux/clk/at91_pmc.h>
>
>   static void toggle_bias(int is_on)
>   {
> diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/include/linux/clk/at91_pmc.h
> similarity index 99%
> rename from arch/arm/mach-at91/include/mach/at91_pmc.h
> rename to include/linux/clk/at91_pmc.h
> index c604cc6..00c45b3 100644
> --- a/arch/arm/mach-at91/include/mach/at91_pmc.h
> +++ b/include/linux/clk/at91_pmc.h
> @@ -1,5 +1,5 @@
>   /*
> - * arch/arm/mach-at91/include/mach/at91_pmc.h
> + * include/linux/clk/at91_pmc.h
>    *
>    * Copyright (C) 2005 Ivan Kokshaysky
>    * Copyright (C) SAN People
>


-- 
Nicolas Ferre
