Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3I3PJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:09:59 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51192 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3I3PJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:09:57 -0400
Message-ID: <52499441.1030403@gmail.com>
Date: Mon, 30 Sep 2013 10:09:53 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/6] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 08:59 AM, Sricharan R wrote:
> Some socs have a large number of interrupts requests to service
> the needs of its many peripherals and subsystems. All of the interrupt
> requests lines from the subsystems are not needed at the same
> time, so they have to be muxed to the controllers appropriately.
> In such places a interrupt controllers are preceded by an
> IRQ CROSSBAR that provides flexibility in muxing the device interrupt
> requests to the controller inputs.
> 
> This series models the peripheral interrupts that can be routed through
> the crossbar to the GIC as 'routable-irqs'. The routable irqs are added
> in a separate linear domain inside the GIC. The registered routable domain's
> callback are invoked as a part of the GIC's callback, which in turn should
> allocate a free irq line and configure the IP accordingly. So every peripheral
> in the dts files mentions the fixed crossbar number as its interrupt. A free
> gic line for that gets allocated and configured when the peripheral's interrupt
> is mapped.
> 
> The minimal crossbar driver to track and allocate free GIC lines and configure the
> crossbar is added here, along with the DT bindings.

Seems like interrupt-map property is what you need here.

http://devicetree.org/Device_Tree_Usage#Advanced_Interrupt_Mapping

Versatile Express also has an example.

Rob

> 
> Sricharan R (6):
>   DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
>   DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
>   ARM: DTS: DRA: Add crossbar device binding
>   ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar
>     inputs.
>   ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
>   ARM: DRA: Enable Crossbar IP support for DRA7XX
> 
>  Documentation/devicetree/bindings/arm/gic.txt      |    5 +
>  .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
>  arch/arm/boot/dts/dra7.dtsi                        |   98 +++++-----
>  arch/arm/mach-omap2/Kconfig                        |    1 +
>  arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
>  arch/arm/mach-omap2/omap4-common.c                 |    4 +
>  drivers/irqchip/Kconfig                            |    8 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-crossbar.c                     |  195 ++++++++++++++++++++
>  drivers/irqchip/irq-gic.c                          |   57 +++++-
>  include/linux/irqchip/arm-gic.h                    |    8 +-
>  include/linux/irqchip/irq-crossbar.h               |   11 ++
>  12 files changed, 363 insertions(+), 56 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
>  create mode 100644 drivers/irqchip/irq-crossbar.c
>  create mode 100644 include/linux/irqchip/irq-crossbar.h
> 

