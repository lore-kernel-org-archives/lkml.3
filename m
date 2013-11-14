Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3KNO03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:26:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38828 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab3KNO0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:26:19 -0500
Message-ID: <5284DD61.3000706@ti.com>
Date: Thu, 14 Nov 2013 09:25:37 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <galak@codeaurora.org>, <rob.herring@calxeda.com>, <nm@ti.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH V4 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 November 2013 07:18 AM, Sricharan R wrote:
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
> gic line for that gets allocated and configured when the peripheral interrupts
> are mapped.
> 
> The minimal crossbar driver to track and allocate free GIC lines and configure the
> crossbar is added here, along with the DT bindings.
> 
> V4:
>    Addressed a couple of comments and split the DTS file updates in to
>    a separate series.
> 
Thanks for the split.
For entire series,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

