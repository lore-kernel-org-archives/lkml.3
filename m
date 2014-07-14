Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaGNPIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:08:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40344 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbaGNPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:08:01 -0400
Date: Mon, 14 Jul 2014 16:07:49 +0100
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>
Subject: Re: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
Message-ID: <20140714150749.GH26465@leverpostej>
References: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
 <1405340169-2820-2-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405340169-2820-2-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:16:09PM +0100, Harini Katakam wrote:
> Add cadence-wdt bindings documentation.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
> 
> v3 changes:
> - Change reset property type and improve description.
> - Improve description of clocks and interrupts.
> - Use watchdog@ in the example.
> - Use only cdns compatible string for now.
> 
> v2:
> No changes
> 
> ---
>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   27 ++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> new file mode 100644
> index 0000000..ab23e38
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> @@ -0,0 +1,27 @@
> +Zynq Watchdog Device Tree Bindings
> +-------------------------------------------
> +
> +Required properties:
> +- compatible		: Should be "cdns,wdt-r1p2".
> +- clocks		: Input clock specifier. This should be the ref clk.

This wording makes it sound like the watchdog block has more than one
clock input. Does it?

> +- reg			: Physical base address and size of WDT registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number. This interrupt is used for indication
> +			  when the watchdog times out.

Just say "the watchdog timeout interrupt", or (better) use the name of
the interrupt from the documentation.

> +- interrupt-parent	: Must be core interrupt controller.
> +
> +Optional properties
> +- reset			: If this property exists, then a reset is done
> +			  when watchdog times out.

That's a bit of an ambiguous name (too easy to misconstrue as a reset
device reference). Do any other watchdogs have similar properties?

Thanks,
Mark.

> +- timeout-sec		: Watchdog timeout value (in seconds).
> +
> +Example:
> +	watchdog@f8005000 {
> +		compatible = "xlnx,zynq-wdt-r1p2";
> +		clocks = <&clkc 45>;
> +		interrupt-parent = <&intc>;
> +		interrupts = <0 9 1>;
> +		reg = <0xf8005000 0x1000>;
> +		reset;
> +		timeout-sec = <10>;
> +	};
> -- 
> 1.7.9.5
> 
> 
