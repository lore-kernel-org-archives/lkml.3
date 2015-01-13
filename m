Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbbAMTBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:01:38 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44339 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752591AbbAMTBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:01:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18tYi3Y+4DcOiue79/QCLfwa1JJtjPsI3U=
X-DKIM: OpenDKIM Filter v2.0.1 titan DA95D645680
Date: Tue, 13 Jan 2015 14:00:50 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/5] irqchip: Add DT binding doc for dumb demuxer
 chips
Message-ID: <20150113190050.GZ24989@titan.lakedaemon.net>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
 <1421174781-4340-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1421174781-4340-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On Tue, Jan 13, 2015 at 07:46:18PM +0100, Boris Brezillon wrote:
> Add documentation for the dumb demuxer.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
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

Please forgive the potentially naïve question, but what hardware is this
describing?

thx,

Jason.

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
> -- 
> 1.9.1
> 
