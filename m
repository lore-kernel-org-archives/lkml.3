Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbaE2JNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:13:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39689 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932814AbaE2JNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:13:13 -0400
Date: Thu, 29 May 2014 10:12:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Harini Katakam <harinik@xilinx.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
Message-ID: <20140529091255.GB24233@leverpostej>
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
 <1401185895-3677-2-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401185895-3677-2-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:18:15AM +0100, Harini Katakam wrote:
> Add cadence-wdt bindings documentation.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
> 
> v2:
> No changes
> 
> ---
>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   26 ++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> new file mode 100644
> index 0000000..1f7a732
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> @@ -0,0 +1,26 @@
> +Zynq Watchdog Device Tree Bindings
> +-------------------------------------------
> +
> +Required properties:
> +- compatible		: Should be "xlnx,zynq-wdt-r1p2" or "cdns,wdt-r1p2".

What's the difference? Can "cdns,wdt-r1p2" be a fallback for
"xlnx,zynq-wdt-r1p2"?

> +- clocks		: Clock phandles (see clock bindings for details).

Nit: Clocks aren't just phandles.

How many clocks? This implies several, the example shows one.

> +- reg			: Physical base address and size of WDT registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number.

We know this is a property with a value. Describe what it logically is
(and optionally, the type is interrupt-sepcifier, though that gets
fuzzier with the interrupts-extended property).

> +- interrupt-parent	: Must be core interrupt controller.
> +
> +Optional properties
> +- reset			: Reset interrupt.

What does this mean? What type is this?

I have no idea if this is a boolean telling the OS to reset the
interrupt initially, or an index describing which interrupt is the reset
interrupt in either the interrupts property or some HW registers.

Cheers,
Mark.

> +- timeout-sec		: Watchdog timeout value (in seconds).
> +
> +Example:
> +
> +		wdt@f8005000 {
> +			compatible = "xlnx,zynq-wdt-r1p2";
> +			clocks = <&clkc 45>;
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 9 1>;
> +			reg = <0xf8005000 0x1000>;
> +			reset = <0>;
> +			timeout-sec = <10>;
> +		} ;
> -- 
> 1.7.9.5
> 
> 
