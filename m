Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3KZAO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:14:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39147 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab3KZAO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:14:56 -0500
Message-ID: <5293E7FB.6040300@wwwdotorg.org>
Date: Mon, 25 Nov 2013 17:14:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pinctrl: Add documentation for pinctrl-msm8x74
References: <1385249897-16453-1-git-send-email-bjorn.andersson@sonymobile.com> <1385249897-16453-2-git-send-email-bjorn.andersson@sonymobile.com> <1385249897-16453-3-git-send-email-bjorn.andersson@sonymobile.com> <1385249897-16453-4-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1385249897-16453-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 04:38 PM, Bjorn Andersson wrote:
> This adds initial documentation for the pinctrl-msm8x74 driver.

> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt

> +Qualcomm MSM8x74 TLMM block
> +
> +Required properties:
> +- compatible: "qcom,msm8x74-pinctrl"
> +- reg: Should be the base address of the TLMM block.

base address *and length*?

> +- interrupts: Should be the irq of the TLMM summary interrupt.

s/irq/IRQ/

> +- interrupt-controller: Marks the device node as an interrupt controller.
> +- #interrupt-cells: Should be two.
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells : Should be two.
> +                The first cell is the gpio pin number and the
> +                second cell is used for optional parameters.
> +
> +Please refer to ../gpio/gpio.txt for a general description of GPIO bindings.

It's probably worth linking to ../interrupt-controller/interrupts.txt too.

> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +Each subnode describes properties for the given pins.

Which subnodes? It's probably worth describing what subnodes can exist.
Perhaps try cribbing e.g. the 3 paragraphs in the Tegra binding that
appear right after the "Please refer to pinctrl-bindings.txt..." that's
there.

> +Required subnode-properties:
> +- qcom,pins: An array of strings, each matching a pin or group to be
> +             configured. Possible values are listed below.

It isn't clear from this that these properties exist in a sub-sub-node,
not just a sub-node, of the main pinctrl node.

> +Optional subnode-properties:
> +- qcom,function: A name of the function to be muxed to the specified
> +                 pins. Possible values are listed below.

Are "pins" and "functions" generic enough now that they don't need a
vendor prefix? Both those property names are certainly mentioned in
pinctrl-bindings.txt.

> +- drive-strength: Configure the drive strength of the specified pins.

What units? I assume the definition matches that in
pinctrl-bindings.txt? Perhaps it'd be simpler to say "The following
generic properties as defined in pinctrl-bindings.txt: pins, function,
bias-disable, ...".

> +Valid values for qcom,function are:
> +  blsp_i2c2, blsp_i2c6, blsp_i2c11, blsp_spi1, blsp_uart2, blsp_uart8, slimbus
> +
> +  (Note that this is not yet the complete list of functions)

It'd be best if the complete list were defined from the start. That
said, I suppose adding new values into the list would be
backwards-compatible (if not forwards-compatible i.e. new DTs usable
with old kernels).

> +Example:
> +
> +	msmgpio: pinctrl@fd510000 {
...
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&uart2_default>;
> +
> +		uart2 {

What does that node represent? Other pinctrl bindings  only have 1 or 2
levels of subnodes, not 3.

> +			uart2_default: uart2_default {
> +				mux {
> +					qcom,pins = "gpio4", "gpio5";
> +					qcom,function = "blsp_uart2";
> +				};


