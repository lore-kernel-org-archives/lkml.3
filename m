Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3JaOcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:32:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3JaOcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:32:52 -0400
Subject: Re: [PATCH V2 1/7] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1383145040-15852-2-git-send-email-r.sricharan@ti.com>
Date: Thu, 31 Oct 2013 09:32:51 -0500
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, Rob Herring <rob.herring@calxeda.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7A94EADA-645A-4287-9D68-AB5163DC1782@codeaurora.org>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com> <1383145040-15852-2-git-send-email-r.sricharan@ti.com>
To: Sricharan R <r.sricharan@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30, 2013, at 9:57 AM, Sricharan R wrote:

> In some socs the gic can be preceded by a crossbar IP which
> routes the peripheral interrupts to the gic inputs. The peripheral
> interrupts are associated with a fixed crossbar input line and the
> crossbar routes that to one of the free gic input line.
> 
> The DT entries for peripherals provides the fixed crossbar input line
> as its interrupt number and the mapping code should associate this with
> a free gic input line. This patch adds the support inside the gic irqchip
> to handle such routable irqs. The routable irqs are registered in a linear
> domain. The registered routable domain's callback should be implemented
> to get a free irq and to configure the IP to route it.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
> [V2] Added default routable-irqs functions to avoid
>      unnessecary if checks as per Thomas Gleixner comments
>      and renamed routable-irq binding as per
>      Kumar Gala <galak@codeaurora.org> comments.
> 
> Documentation/devicetree/bindings/arm/gic.txt |    6 ++
> drivers/irqchip/irq-gic.c                     |   83 ++++++++++++++++++++++---
> include/linux/irqchip/arm-gic.h               |    8 ++-
> 3 files changed, 87 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 3dfb0c0..5357745 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -49,6 +49,11 @@ Optional
>   regions, used when the GIC doesn't have banked registers. The offset is
>   cpu-offset * cpu-nr.
> 
> +- arm,routable-irqs : Total number of gic irq inputs which are not directly
> +		  connected from the peripherals, but are routed dynamically
> +		  by a crossbar/multiplexer preceding the GIC. The GIC irq
> +		  input line is assigned dynamically when the corresponding
> +		  peripheral's crossbar line is mapped.
> Example:
> 
> 	intc: interrupt-controller@fff11000 {
> @@ -56,6 +61,7 @@ Example:
> 		#interrupt-cells = <3>;
> 		#address-cells = <1>;
> 		interrupt-controller;
> +		arm,routable-irqs = <160>;
> 		reg = <0xfff11000 0x1000>,
> 		      <0xfff10100 0x100>;
> 	};

DT Binding portion:

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

