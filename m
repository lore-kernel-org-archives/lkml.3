Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3LSTEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:04:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60993 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3LSTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:04:01 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Bafh+kXobdIDX8NV6PPUO
Date: Thu, 19 Dec 2013 11:03:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [RFCv4 05/11] Documentation: DT: omap-ssi binding documentation
Message-ID: <20131219190344.GW27438@atomide.com>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
 <1387150085-23173-6-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387150085-23173-6-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131215 15:30]:
> Create device tree binding documentation for
> OMAP Synchronous Serial Interface (SSI) device.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  Documentation/devicetree/bindings/hsi/omap_ssi.txt | 69 ++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hsi/omap_ssi.txt
> 
> diff --git a/Documentation/devicetree/bindings/hsi/omap_ssi.txt b/Documentation/devicetree/bindings/hsi/omap_ssi.txt
> new file mode 100644
> index 0000000..0a9efd8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hsi/omap_ssi.txt
> @@ -0,0 +1,69 @@
> +OMAP SSI controller bindings
> +
> +Required properties:
> +- compatible:		Should include "ti,omap3-ssi".
> +- reg-names:		Contains the values "sys" and "gdd".

Do you need the reg-names? The order won't change so you can just
document the order in the binding?

> +- reg:			Contains a register specifier for each entry in
> +			reg-names.
> +- interrupt-names:      Contains the value "gdd_mpu".

Maybe interrupt-names are not needed either?

> +- interrupts: 		Contains interrupt information for each entry in
> +			interrupt-names.
> +- ranges		Represents the bus address mapping between the main
> +			controller node and the child nodes below.
> +- #address-cells	Should be set to <1>
> +- #size-cells		Should be set to <1>
> +
> +Each port is represented as a sub-node of the ti,omap3-ssi device.
> +
> +Required Port sub-node properties:
> +- compatible:		Should be set to the following value
> +                        ti,omap3-ssi-port (applicable to OMAP34xx devices)
> +- reg-names:		Contains the values "rx" and "tx".

Here too?

> +- reg:			Contains a register specifier for each entry in
> +			reg-names.
> +- interrupt-parent	Should be a phandle for the interrupt controller
> +- interrupt-names:	Contains the values "mpu_irq0" and "mpu_irq1".

And here?

> +- interrupts:		Contains interrupt information for each entry in
> +			interrupt-names.
> +- ti,ssi-cawake-gpio:	Defines which GPIO pin is used to signify CAWAKE
> +			events for the port. This is an optional board-specific
> +			property. If it's missing the port will not be
> +			enabled.

Hmm this might be just a wake-up GPIO? If so, you should be able to
just set it up as an interrupt and do a request_irq on the pinctrl-single
entry for it.

It might even be one of the already mapped interrupt lines that the code is
remuxing to a GPIO for idle? If so, then you can just use the new binding
for interrupts-extended to handle the wake-up events.

If you post the GPIO number for ti,ssi-cawake-gpio and the interrupt
numbers I can check if there's a need to handle it separately as a GPIO
pin or if it already can be automatically handled for the wake-up events.

Regards,

Tony
