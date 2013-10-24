Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JXJdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:33:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34929 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3JXJde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:33:34 -0400
Subject: Re: [RFC PATCH 2/6] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1380549564-31045-3-git-send-email-r.sricharan@ti.com>
Date: Thu, 24 Oct 2013 04:33:37 -0500
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tglx@linutronix.de>,
        <linus.walleij@linaro.org>, <santosh.shilimkar@ti.com>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2FD881B8-1A59-418E-AF9C-EF5B9C5D0623@codeaurora.org>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-3-git-send-email-r.sricharan@ti.com>
To: Sricharan R <r.sricharan@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 30, 2013, at 8:59 AM, Sricharan R wrote:

> Some socs have a large number of interrupts requests to service
> the needs of its many peripherals and subsystems. All of the
> interrupt lines from the subsystems are not needed at the same
> time, so they have to be muxed to the irq-controller appropriately.
> In such places a interrupt controllers are preceded by an CROSSBAR
> that provides flexibility in muxing the device requests to the controller
> inputs.
> 
> This driver takes care a allocating a free irq and then configuring the
> crossbar IP as a part of the mpu's irqchip callbacks. crossbar_init should
> be called right before the irqchip_init, so that it is setup to handle the
> irqchip callbacks.
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
> .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
> drivers/irqchip/Kconfig                            |    8 +
> drivers/irqchip/Makefile                           |    1 +
> drivers/irqchip/irq-crossbar.c                     |  195 ++++++++++++++++++++
> include/linux/irqchip/irq-crossbar.h               |   11 ++
> 5 files changed, 242 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
> create mode 100644 drivers/irqchip/irq-crossbar.c
> create mode 100644 include/linux/irqchip/irq-crossbar.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> new file mode 100644
> index 0000000..cdec2cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> @@ -0,0 +1,27 @@
> +Some socs have a large number of interrupts requests to service
> +the needs of its many peripherals and subsystems. All of the
> +interrupt lines from the subsystems are not needed at the same
> +time, so they have to be muxed to the irq-controller appropriately.
> +In such places a interrupt controllers are preceded by an CROSSBAR
> +that provides flexibility in muxing the device requests to the controller
> +inputs.
> +
> +Required properties:
> +- compatible : Should be "ti,irq-crossbar"
> +- reg: Base address and the size of the crossbar registers.
> +- max-irqs: Total number of irqs available at the interrupt controller.

Should be 'ti,max-irqs

> +- reg-size: Size of a individual register in bytes. Every individual
> +	    register is assumed to be of same size. Valid sizes are 1, 2, 4.

Is this something that really needs to be encoded in the dts?

If we keep it should be ti,reg-size

> +- irqs-reserved: List of the reserved irq lines that are not muxed using
> +		 crossbar. These interrupt lines are reserved in the soc,
> +		 so crossbar bar driver should not consider them as free
> +		 lines.
> +

ti,irqs-reserved

> +Examples:
> +		crossbar_mpu: @4a020000 {

Did you mean for there to be a label and no node name?

> +			compatible = "ti,irq-crossbar";
> +			reg = <0x4a002a48 0x130>;
> +			max-irqs = <160>;
> +			reg-size = <2>;
> +			irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
> +		};

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

