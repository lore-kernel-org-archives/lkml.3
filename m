Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172Ab3LIKwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:52:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42524 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761135Ab3LIKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:52:04 -0500
Date: Mon, 9 Dec 2013 10:51:55 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] pinctrl: tegra: Add devicetree binding document
 for Tegra124
Message-ID: <20131209105155.GC29303@e106331-lin.cambridge.arm.com>
References: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:32:19AM +0000, Laxman Dewangan wrote:
> This device tree binding document describes the Tegra124 pincontrol
> DT bindings. This document lists all valid properties, names, mux
> options of Tegra124 pins.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Referred the dt-binding header file on describing the nodes.
> 
>  .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |  147 ++++++++++++++++++++
>  1 files changed, 147 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
> new file mode 100644
> index 0000000..12ef772
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
> @@ -0,0 +1,147 @@
> +NVIDIA Tegra124 pinmux controller
> +
> +The Tegra124 pinctrl binding is very similar to the Tegra20 and Tegra30
> +pinctrl binding, as described in nvidia,tegra20-pinmux.txt and
> +nvidia,tegra30-pinmux.txt. In fact, this document assumes that binding as
> +a baseline, and only documents the differences between the two bindings.
> +
> +Required properties:
> +- compatible: "nvidia,tegra124-pinmux"
> +- reg: Should contain the register physical address and length for each of
> +  the pad control and mux registers. The first bank of address must be the
> +  driver strength pad control register address and second bank address must
> +  be pinmux register address.

The wording here could be improved. The first sentence implies an entry
for each individual register but I assume these are actually banks of
registers (the sizes in the exanple imply this). The second sentence is
more sepcific.

How about something like:

reg: Should contain a list of base address and size pairs for:
 * first entry - the driver strength and pad control registers
 * second entry - the pinmux registers

Are these banks well defined? Where do they end?

Is there likely to be anything built as an extension of this? Does it
possibly make sense to use reg-names?

> +
> +Tegra124 adds the following optional properties for pin configuration subnodes.
> +The macros for options are defined in the
> +	include/dt-binding/pinctrl/pinctrl-tegra.h.
> +- nvidia,enable-input: Integer. Enable the pin's input path.
> +		enable :TEGRA_PIN_ENABLE0 and
> +		disable or output only: TEGRA_PIN_DISABLE.
> +- nvidia,open-drain: Integer.
> +		enable: TEGRA_PIN_ENABLE.
> +		disable: TEGRA_PIN_DISABLE.
> +- nvidia,lock: Integer. Lock the pin configuration against further changes
> +    until reset.
> +		enable: TEGRA_PIN_ENABLE.
> +		disable: TEGRA_PIN_DISABLE.
> +- nvidia,io-reset: Integer. Reset the IO path.
> +		enable: TEGRA_PIN_ENABLE.
> +		disable: TEGRA_PIN_DISABLE.
> +- nvidia,rcv-sel: Integer. Select VIL/VIH receivers.
> +		normal: TEGRA_PIN_DISABLE
> +		high: TEGRA_PIN_ENABLE
> +- nvidia,drive-type: Integer. Valid range 0...3.

What do the values in this range mean?

[...]

> +Example:
> +
> +	pinmux: pinmux {
> +		compatible = "nvidia,tegra124-pinmux";
> +		reg = <0x70000868 0x164		/* Pad control registers */
> +		       0x70003000 0x434>;	/* PinMux registers */

Nit: please bracket these individually.

Thanks,
Mark.
