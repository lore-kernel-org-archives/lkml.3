Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3JDMvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:51:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63370 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3JDMvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:51:23 -0400
Message-ID: <524EB9C6.4020901@linaro.org>
Date: Fri, 04 Oct 2013 08:51:18 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sherman Yin <syin@broadcom.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] pinctrl: Add pinctrl binding for Broadcom Capri SoCs
References: <1380846199-12829-1-git-send-email-syin@broadcom.com> <1380846199-12829-3-git-send-email-syin@broadcom.com>
In-Reply-To: <1380846199-12829-3-git-send-email-syin@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 08:23 PM, Sherman Yin wrote:
> Adds pinctrl driver devicetree binding for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>   .../bindings/pinctrl/brcm,capri-pinctrl.txt        |  419 ++++++++++++++++++++
>   1 file changed, 419 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
> new file mode 100644
> index 0000000..79e0e5a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
> @@ -0,0 +1,419 @@
> +Broadcom Capri Pin Controller
> +
> +This is a pin controller for the Broadcom BCM281xx SoC family, which includes
> +BCM11130, BCM11140, BCM11351, BCM28145, and BCM28155 SoCs.
> +
> +=== Pin Controller Node ===
> +
> +Required Properties:
> +
> +- compatible:	Must be "brcm,capri-pinctrl".
> +- reg:		Base address of the PAD Controller register block and the size
> +		of the block.
> +
> +For example, the following is the bare minimum node:
> +
> +	pinctrl@35004800 {
> +		compatible = "brcm,capri-pinctrl";
> +		reg = <0x35004800 0x430>;
> +	};
> +
> +As a Pin Controller Device, in addition to the required properties, this node
> +should also contain the pin configuration nodes that client devices reference,
> +if any.
> +
> +=== Pin Configuration Node ===
> +
> +Each pin configuration node is a sub-node of the pin controller node and is a
> +container of an arbitrary number of subnodes, called group nodes.
> +
> +Please refer to the pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the definition of a
> +"pin configuration node".
> +
> +=== Group Node ===
> +
> +A group node specifies the desired pin mux and/or pin configuration for an
> +arbitrary number of pins.  The group node only affect the properties specified
> +in the node, and has no effect on any properties that are omitted.
> +
> +The names of the group nodes are optional and not used. The group nodes have
> +the following properties:
> +
> +Required Properties:
> +
> +- brcm,pins:	Multiple strings.  Specifies the name(s) of one or more pins to
> +		be configured by this node.
> +
> +Optional Properties:
> +
> +- brcm,function: Multiple strings.  Specifies the pin mux selection.  Values are:
> +		"alt1", "alt2", "alt3", "alt4"
> +- brcm,hysteresis: Multiple integers, applicable to standard pins only.  Turns
> +		on hysteresis of input.
> +		0: TTL input, 1: Schmitt Trigger input
> +- brcm,pull:	Multiple integers, applicable to standard pins only.  Specifies
> +		pull-up or pull-down.
> +		0: neither, 1: pull-up, 2: pull-down, 3: both
> +- brcm,input_dis: Multiple integers, applicable to all pins.  Input disable

I missed this before. Hyphens are preferred over underscores in property 
names.

> +		control.
> +		0: off, 1: input disabled
> +- brcm,slew:	Multiple integers.  Slew rate of output.
> +		0: fast output, 1: normal output (most pins)
> +		0: normal output, 1: fast output (IC_DM and IC_DP)
> +		0: Fast mode, 1: High speed mode (I2C)
> +- brcm,drive_str: Multiple integers.  Drive strength.
> +		0: 2 mA
> +		1: 4 mA
> +		2: 6 mA
> +		3: 8 mA
> +		4: 10 mA
> +		5: 12 mA
> +		6: 14 mA
> +		7: 16 mA
> +- brcm,pull_up_str: Multiple integers.  Pull Up strength.
> +		0: No pull-up
> +		1: 1.2 kOhm
> +		2: 1.8 kOhm
> +		3: 720 Ohm
> +		4: 2.7 kOhm
> +		5: 831 Ohm
> +		6: 1.08 kOhm
> +		7: 568 Ohm
> +- brcm,mode:	Multiple integers.  Mode select.
> +		0: Fast mode, 1: High Speed mode (I2C)

