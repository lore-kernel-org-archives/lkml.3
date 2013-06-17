Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3FQW3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:29:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49645 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3FQW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 17 Jun 2013 23:29:15 +0100
X-Google-Sender-Auth: kC5DEtUaS2Z6Q5Zdvh0_VBYpayU
Message-ID: <CACxGe6smNZofiGdO=nBM88MiWyoDvCTiPGFG5enEUwP_zCn17A@mail.gmail.com>
Subject: Re: [PATCH 0/7] genirq: add irq_get_trigger_type() to get IRQ flags
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 5:40 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Drivers that want to get the trigger edge/level type flags for a
> given interrupt have to first call irq_get_irq_data(irq) to get
> the struct irq_data and then irqd_get_trigger_type(irq_data) to
> obtain the IRQ flags.
>
> This is not only error prone but also unnecessary exposes the
> struct irq_data to callers. This patch-set adds a new function
> irq_get_trigger_type() to obtain the edge/level flags for an IRQ
> and updates the places where irq_get_irq_data(irq) was called
> just to obtain the flags from the struct irq_data.
>
> The patch-set is composed of the following patches:
>
> [PATCH 1/7] genirq: add irq_get_trigger_type() to get IRQ flags
> [PATCH 2/7] gpio: mvebu: use irq_get_trigger_type() to get IRQ flags
> [PATCH 3/7] mfd: twl4030-irq: use irq_get_trigger_type() to get IRQ flags
> [PATCH 4/7] mfd: stmpe: use irq_get_trigger_type() to get IRQ flags
> [PATCH 5/7] arm: orion: use irq_get_trigger_type() to get IRQ flags
> [PATCH 6/7] MIPS: octeon: use irq_get_trigger_type() to get IRQ flags
> [PATCH 7/7] irqdomain: use irq_get_trigger_type() to get IRQ flags

For the whole series:
Acked-by: Grant Likely <grant.likely@linaro.org>

>
>  arch/arm/plat-orion/gpio.c           |    2 +-
>  arch/mips/cavium-octeon/octeon-irq.c |    2 +-
>  drivers/gpio/gpio-mvebu.c            |    2 +-
>  drivers/mfd/stmpe.c                  |    3 +--
>  drivers/mfd/twl4030-irq.c            |    5 +----
>  include/linux/irq.h                  |    6 ++++++
>  kernel/irq/irqdomain.c               |    2 +-
>  7 files changed, 12 insertions(+), 10 deletions(-)
>
> Best regards,
> Javier
