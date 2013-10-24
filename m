Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3JXJiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:38:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3JXJiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:38:20 -0400
Subject: Re: [RFC PATCH 1/6] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1380549564-31045-2-git-send-email-r.sricharan@ti.com>
Date: Thu, 24 Oct 2013 04:38:23 -0500
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tglx@linutronix.de>,
        <linus.walleij@linaro.org>, <santosh.shilimkar@ti.com>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D170CC15-C746-412F-A683-E8A73EFB8133@codeaurora.org>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-2-git-send-email-r.sricharan@ti.com>
To: Sricharan R <r.sricharan@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 30, 2013, at 8:59 AM, Sricharan R wrote:

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
> Documentation/devicetree/bindings/arm/gic.txt |    5 +++
> arch/arm/boot/dts/dra7.dtsi                   |    1 +
> drivers/irqchip/irq-gic.c                     |   57 +++++++++++++++++++++----
> include/linux/irqchip/arm-gic.h               |    8 +++-
> 4 files changed, 61 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 3dfb0c0..2d8c680 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -49,6 +49,11 @@ Optional
>   regions, used when the GIC doesn't have banked registers. The offset is
>   cpu-offset * cpu-nr.
> 
> +- routable-irqs	: Total number of gic irq inputs which are not directly
> +		  connected from the peripherals, but are routed dynamically
> +		  by a crossbar/multiplexer preceding the GIC. The GIC irq
> +		  input line is assigned dynamically when the corresponding
> +		  peripheral's crossbar line is mapped.

arm,routable-irqs

> Example:
> 
> 	intc: interrupt-controller@fff11000 {

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

