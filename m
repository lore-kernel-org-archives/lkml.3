Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaCZJJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:09:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54269 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbaCZJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:09:16 -0400
Date: Wed, 26 Mar 2014 09:08:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "jon@ringle.org" <jon@ringle.org>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v2 2/2] serial: sc16is7xx: Add bindings documentation
 for the SC16IS7XX UARTs
Message-ID: <20140326090855.GP10341@e106331-lin.cambridge.arm.com>
References: <1395771564-30534-1-git-send-email-jon@ringle.org>
 <1395771564-30534-2-git-send-email-jon@ringle.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395771564-30534-2-git-send-email-jon@ringle.org>
Thread-Topic: [PATCH v2 2/2] serial: sc16is7xx: Add bindings documentation
 for the SC16IS7XX UARTs
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 06:19:24PM +0000, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> This patch adds the devicetree documentation for the NXP SC16IS7XX UARTs.
> 
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  .../devicetree/bindings/serial/nxp,sc16is7xx.txt   | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt b/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
> new file mode 100644
> index 0000000..cd9ae33
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
> @@ -0,0 +1,35 @@
> +* NXP SC16IS7xx advanced Universal Asynchronous Receiver-Transmitter (UART)
> +
> +Required properties:
> +- compatible: Should be one of the following:
> +  - "nxp,sc16is740" for NXP SC16IS740,
> +  - "nxp,sc16is741" for NXP SC16IS741,
> +  - "nxp,sc16is750" for NXP SC16IS750,
> +  - "nxp,sc16is752" for NXP SC16IS752,
> +  - "nxp,sc16is760" for NXP SC16IS760,
> +  - "nxp,sc16is762" for NXP SC16IS762.

These all look fine.

> +- reg: I2C address of the SC16IS7xx device.
> +- interrupt-parent: The phandle for the interrupt controller that
> +  services interrupts for this IC.
> +- interrupts: Specifies the interrupt source of the parent interrupt
> +  controller. The format of the interrupt specifier depends on the
> +  parent interrupt controller.

Just describe what the device-specific interrupt logically is, not what
the interrupts property means in general.

> +- clocks: phandle to the IC source clock.

Nit: clocks aren't just referred to with phandles; there's a clock
specifier too.

Either correct the type here or don't mention the type at all, given
this is a common property.

> +
> +Optional properties:
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells: Should be two. The first cell is the GPIO number and
> +  the second cell is used to specify the GPIO polarity:
> +    0 = active high,
> +    1 = active low.
> +
> +Example:
> +        sc16is750: sc16is750@51 {
> +                compatible = "nxp,sc16is750";
> +                reg = <0x51>;
> +                clocks = <&clk20m>;
> +                interrupt-parent = <&gpio3>;
> +                interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
> +                gpio-controller;
> +                #gpio-cells = <2>;
> +        };
> -- 
> 1.8.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
