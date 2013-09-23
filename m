Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3IWUfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:35:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44054 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3IWUfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:35:41 -0400
Message-ID: <5240A617.1010208@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:35:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>
CC: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?ISO-8859-1?Q?=27Beno=EEt_Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
References: <1379277856-24571-1-git-send-email-sre@debian.org> <1379277856-24571-4-git-send-email-sre@debian.org>
In-Reply-To: <1379277856-24571-4-git-send-email-sre@debian.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 02:44 PM, Sebastian Reichel wrote:
> Add SSI device tree data for OMAP34xx and Nokia N900.

What is an "SSI" device, ...

> diff --git a/Documentation/devicetree/bindings/hsi/omap_ssi.txt b/Documentation/devicetree/bindings/hsi/omap_ssi.txt

... and what is the "HSI" subsystem?

> +OMAP SSI controller bindings
> +
> +Required properties:
> +- compatible:		Should be set to the following value
> +                        ti,omap3-ssi (applicable to OMAP34xx devices)

I think that'd be better phrased as:

	Should include "ti,omap3-ssi".

The binding should not preclude other compatibel values being present
(e.g. a SoC-specific compatible value, to allow SoC-specific quirks to
be enabled later).

> +- ti,hwmods:		Name of the hwmod associated to the controller, which
> +			is "ssi".

I don't think we should add any more of that, for new bindings.

> +- reg:			Contains SSI register address range (base address and
> +			length).
> +- reg-names:		Contains the names of the address ranges. It's
> +                        expected, that "sys" and "gdd" address ranges are
> +			provided.

Why two entries in reg-names but only one in reg?

I think it'd be better to write:

reg-names:	Contains the values "sys" and "gdd".
reg:		Contains a register specifier for each entry in
		reg-names.

A similar re-ordering/-wording would apply to interrupts/interrupt-names.

> +- ranges		Required as an empty node

s/node/property/

Why must ranges be empty? As long as the content correctly represents
the bus setup, why does the content matter at all. How about:

ranges		Represents the bus address mapping between the main
		controller node and the child nodes below.

> +Each port is represented as a sub-node of the ti,omap3-ssi device.
> +
> +Required Port sub-node properties:
> +- compatible:		Should be set to the following value
> +                        ti,omap3-ssi-port (applicable to OMAP34xx devices)

Hmm. Is it really the case that there is 1 controller with n ports? Are
the ports really dependent upon some shared resource? Couldn't the ports
be represented as separate top-level SSI controllers?

> +- interrupts:		Contains the interrupt information for the port.
> +- interrupt-names:	Contains the names of the interrupts. It's expected,
> +			that "mpu_irq0" and "mpu_irq1" are provided.

What exactly are those interrupts? "MPU" sounds like an external
micro-controller/processor...

> +- ti,ssi-cawake-gpio:	Defines which GPIO pin is used to signify CAWAKE
> +			events for the port. This is an optional board-specific
> +			property. If it's missing the port will not be
> +			enabled.

That also sounds like something that's a higher-level protocol, rather
than whatever low-level transport "SSI" implements. Should this be part
of a child node that represents the device attached to the SSI controller?

Does the SSI controller (or its ports) not need any clocks, resets,
regulators, ...?

