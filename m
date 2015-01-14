Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbbANNmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:42:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:32536 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbANNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:42:22 -0500
Message-ID: <54B6723D.4050009@atmel.com>
Date: Wed, 14 Jan 2015 14:42:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] irqchip: Add DT binding doc for dumb demuxer chips
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com> <1421174781-4340-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1421174781-4340-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 19:46, Boris Brezillon a écrit :
> Add documentation for the dumb demuxer.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  .../bindings/interrupt-controller/dumb-demux.txt   | 34 ++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> new file mode 100644
> index 0000000..1c777ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> @@ -0,0 +1,34 @@
> +* Generic Dumb Interrupt Demultiplexer
> +
> +This Dumb demultiplixer simply forward all incoming interrupts to its
> +enabled/unmasked children.
> +
> +Required properties:
> +- compatible: Should be "irqchip-dumb-demux".
> +- interrupt-controller: Identifies the node as an interrupt controller.
> +- interrupts-extended or interrupt-parent and interrupts: Reference the source
> +  interrupt connected to this dumb demuxer.
> +- #interrupt-cells: The number of cells to define the interrupts (should be 1).
> +  The only cell is the IRQ number.
> +- irqs: u32 bitfield specifying the interrupts provided by the demuxer.
> +
> +Examples:
> +	/*
> +	 * Dumb demuxer controller
> +	 */
> +	dumb_irq1_demux: dumb-irq-demux@1 {
> +		compatible = "irqchip-dumb-demux";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		interrupts-extended = <&aic 1 IRQ_TYPE_LEVEL_HIGH 7>;
> +		irqs = <0x3f>;
> +	};
> +
> +	/*
> +	 * Device connected on this dumb demuxer
> +	 */
> +	dma: dma-controller@ffffec00 {
> +		compatible = "atmel,at91sam9g45-dma";
> +		reg = <0xffffec00 0x200>;
> +		interrupts-extended = <&dumb_irq1_demux 0>;
> +	};
> 


-- 
Nicolas Ferre
