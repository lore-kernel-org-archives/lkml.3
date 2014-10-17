Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJQJhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:37:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43364 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbaJQJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:37:45 -0400
Date: Fri, 17 Oct 2014 10:37:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marek Belisko <marek@goldelico.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Message-ID: <20141017093714.GB4202@leverpostej>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com>
 <1413491183-15018-2-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413491183-15018-2-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 09:26:23PM +0100, Marek Belisko wrote:
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    | 44 ++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> 
> diff --git a/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> new file mode 100644
> index 0000000..e144441
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> @@ -0,0 +1,44 @@
> +Wi2Wi GPS module connected through UART
> +
> +Required properties:
> +- compatible: wi2wi,w2sg0004 or wi2wi,w2sg0084
> +- pinctrl: specify two states (default and monitor). One is the default (UART) mode
> +  and the other is for monitoring the RX line by an interrupt
> +- on-off-gpio: the GPIO that controls the module's on-off toggle input
> +
> +Optional properties:
> +- lna-suppy: an (optional) LNA regulator that is enabled together with the GPS receiver
> +
> +example:
> +
> +        gps_receiver: w2sg0004 {
> +                compatible = "wi2wi,w2sg0004";

I couldn't spot "wi2wi" in
Documentation/devicetree/bindings/vendor-prefixes.txt (in mainline).

Could you please add it?

> +                gpio-controller;
> +                #gpio-cells = <2>;

As far as I can see, these properties aren't necessary. This only
consumes a GPIO, it doesn't provide any.

> +
> +                pinctrl-names = "default", "monitor";
> +                pinctrl-0 = <&uart2_pins>;
> +                pinctrl-1 = <&uart2_rx_irq_pins>;
> +
> +                interrupt-parent = <&gpio5>;
> +                interrupts = <19 IRQ_TYPE_EDGE_FALLING>;  /* GPIO_147: RX - trigger on arrival of start bit */

While interrupts is a standard property, please describe above how many
you expect and what their logical function is.

The only part I'm confused about is how the link to the UART is
described. I assume I'm just ignorant of some existing pattern.

Otherwise this looks ok.

Thanks,
Mark.

> +                lna-supply = <&vsim>;	/* LNA regulator */
> +                on-off-gpio = <&gpio5 17 0>;	/* GPIO_145: trigger for turning on/off w2sg0004 */
> +
> +&pinmux {
> +
> +	uart2_pins: pinmux_uart2_pins {
> +		pinctrl-single,pins = <
> +			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_tx.uart2_rx */
> +			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
> +		>;
> +	};
> +
> +	uart2_rx_irq_pins: pinmux_uart2_rx_irq_pins {
> +		pinctrl-single,pins = <
> +			/* switch RX to GPIO so that we can get interrupts by the start bit */
> +			0x14a (PIN_INPUT | MUX_MODE4)		/* uart2_tx.uart2_rx */
> +		>;
> +	};
> +
> +}
> -- 
> 1.9.1
> 
> 
