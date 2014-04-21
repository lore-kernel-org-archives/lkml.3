Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaDUQnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:43:52 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:37102 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <1396053110-21639-10-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
	<1396053110-21639-10-git-send-email-sre@kernel.org>
Date: Mon, 21 Apr 2014 11:43:47 -0500
Message-ID: <CAL_Jsq+jGeuM+Vmb8uzz3-ZUvKQu=kDv3RqVY0Dudmc9XTm-BA@mail.gmail.com>
Subject: Re: [PATCHv3 09/14] Documentation: DT: omap-ssi binding documentation
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 7:31 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Create device tree binding documentation for
> OMAP Synchronous Serial Interface (SSI) device.
>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> ---
>  Documentation/devicetree/bindings/hsi/omap-ssi.txt | 85 ++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
>
> diff --git a/Documentation/devicetree/bindings/hsi/omap-ssi.txt b/Documentation/devicetree/bindings/hsi/omap-ssi.txt
> new file mode 100644
> index 0000000..709419b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hsi/omap-ssi.txt
> @@ -0,0 +1,85 @@
> +OMAP SSI controller bindings
> +
> +OMAP Synchronous Serial Interface (SSI) controller implements a legacy
> +variant of MIPI's High Speed Synchronous Serial Interface (HSI).
> +
> +Required properties:
> +- compatible:          Should include "ti,omap3-ssi".
> +- reg-names:           Contains the values "sys" and "gdd".
> +- reg:                 Contains a register specifier for each entry in
> +                       reg-names.

You need to define the order here unless you have a strong argument
why you can't.

> +- interrupt-names:      Contains the value "gdd_mpu".
> +- interrupts:          Contains interrupt information for each entry in
> +                       interrupt-names.
> +- ranges:              Represents the bus address mapping between the main
> +                       controller node and the child nodes below.
> +- clocks:              Contains clock specifiers for each entry in
> +                        clock-names.
> +- clock-names:         Must include the following entries:
> +  "ssi_ssr_fck": The OMAP clock of that name
> +  "ssi_sst_fck": The OMAP clock of that name
> +  "ssi_ick": The OMAP clock of that name
> +- #address-cells:      Should be set to <1>
> +- #size-cells:         Should be set to <1>
> +
> +Each port is represented as a sub-node of the ti,omap3-ssi device.
> +
> +Required Port sub-node properties:
> +- compatible:          Should be set to the following value
> +                        ti,omap3-ssi-port (applicable to OMAP34xx devices)
> +- reg-names:           Contains the values "rx" and "tx".
> +- reg:                 Contains a register specifier for each entry in
> +                       reg-names.

You need to define the order here unless you have a strong argument
why you can't.

> +- interrupt-parent     Should be a phandle for the interrupt controller
> +- interrupt-names:     Contains the values "mpu_irq0" and "mpu_irq1".

Those names aren't exactly useful.

> +- interrupts:          Contains interrupt information for each entry in
> +                       interrupt-names.

You need to define the order here unless you have a strong argument
why you can't.

> +- ti,ssi-cawake-gpio:  Defines which GPIO pin is used to signify CAWAKE
> +                       events for the port. This is an optional board-specific
> +                       property. If it's missing the port will not be
> +                       enabled.
> +
> +Example for Nokia N900:
> +
> +ssi-controller@48058000 {
> +       compatible = "ti,omap3-ssi";
> +
> +       /* needed until hwmod is updated to use the compatible string */
> +       ti,hwmods = "ssi";
> +
> +       reg = <0x48058000 0x1000>,
> +             <0x48059000 0x1000>;
> +       reg-names = "sys",
> +                   "gdd";
> +
> +       interrupts = <55>;
> +       interrupt-names = "gdd_mpu";
> +
> +       clocks = <&ssi_ssr_fck>,
> +                <&ssi_sst_fck>,
> +                <&ssi_ick>;
> +       clock-names = "ssi_ssr_fck",
> +                     "ssi_sst_fck",
> +                     "ssi_ick";
> +
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       ranges;
> +
> +       ssi-port@0 {

Does this h/w really have more than 1 port?

This should really be "ssi-port@4805a800" Or you need to fill in
ranges to have a local offset.

> +               compatible = "ti,omap3-ssi-port";
> +
> +               reg = <0x4805a000 0x800>,
> +                     <0x4805a800 0x800>;
> +               reg-names = "tx",
> +                           "rx";
> +
> +               interrupt-parent = <&intc>;
> +               interrupts = <51>,
> +                            <52>;
> +               interrupt-names = "mpu_irq0",
> +                                 "mpu_irq1";
> +
> +               ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
> +       }
> +}
> --
> 1.9.0
>
