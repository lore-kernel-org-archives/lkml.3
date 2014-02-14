Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaBNKGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:06:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61631 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbaBNKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:06:45 -0500
Date: Fri, 14 Feb 2014 10:06:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 10/10] Documentation: Add device tree bindings for TI
 LMU devices
Message-ID: <20140214100620.GD25107@e106331-lin.cambridge.arm.com>
References: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
Thread-Topic: [PATCH 10/10] Documentation: Add device tree bindings for TI
 LMU devices
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 06:32:44AM +0000, Milo Kim wrote:
> Bindings for TI LMU, backlight, LM3631 regulator and LM3633 LED are added.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  .../devicetree/bindings/leds/leds-lm3633.txt       |   39 +++++
>  Documentation/devicetree/bindings/mfd/ti-lmu.txt   |  182 ++++++++++++++++++++
>  .../bindings/regulator/lm3631-regulator.txt        |   49 ++++++
>  .../bindings/video/backlight/ti-lmu-backlight.txt  |  127 ++++++++++++++
>  4 files changed, 397 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-lm3633.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/ti-lmu.txt
>  create mode 100644 Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/leds-lm3633.txt b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
> new file mode 100644
> index 0000000..4adeb62
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
> @@ -0,0 +1,39 @@
> +TI LMU LM3633 LED device tree bindings
> +
> +Required properties:
> +  - compatible: "ti,lm3633-leds"
> +  - lvled1-used, lvled2-used, lvled3-used, lvled4-used, lvled5-used, lvled6-used
> +    : LED string configuration. Each child node should include this information
> +      about which LED string is used.

Which child nodes? They weren't mentioned until this point.

If properties need to be in a child node, mention the child node first,
and make it clear where the properties are expected to be.

> +
> +Optional properties:
> +  - chan-name: LED channel name

Any reason to abbreviate "channel" to "chan"?

What's this for?

> +  - max-current-milliamp: Max current setting. Unit is mA.

The code and examples treat this as an 8-bit value, but this fact isn't
mentioned here.

> +
> +Example:
> +
> +lm3633@36 {
> +	compatible = "ti,lm3633";

It wasn't mentioned that this had to be a sub-node of a "ti,lm3633"
node. Please describe above and refer to the document for the
"ti,lm3633" binding.

[...]

> diff --git a/Documentation/devicetree/bindings/mfd/ti-lmu.txt b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
> new file mode 100644
> index 0000000..2b3ecca
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
> @@ -0,0 +1,182 @@
> +TI LMU(Lighting Management Unit) device tree bindings
> +
> +TI LMU driver supports lighting devices belows.
> +
> +   Name        Device tree properties
> +  ------      ------------------------
> +  LM3532       Backlight
> +  LM3631       Backlight and regulator
> +  LM3633       Backlight and LED
> +  LM3695       Backlight
> +  LM3697       Backlight
> +
> +Those have shared device tree properties.
> +
> +Required properties:
> +  - compatible: "ti,lm3532", "ti,lm3631", "ti,lm3633", "ti,lm3695", "ti,lm3697"

Should be one of, rather than all at once?

> +  - reg: I2C slave address.
> +    0x38 is LM3532
> +    0x29 is LM3631
> +    0x36 is LM3633, LM3697
> +    0x63 is LM3695
> +  - ti,enable-gpio: GPIO number of hardware enable pin

We refer to GPIOs with more than a number...

> +
> +For the TI LMU backlight properties, please refer to:
> +Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
> +
> +For the LM3631 regulator properties, please refer to:
> +Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
> +
> +For the LM3633 LED properties, please refer to:
> +Documentation/devicetree/bindings/leds/leds-lm3633.txt

Are these expected as subnodes?

> +
> +Examples:
> +
> +lm3532@38 {
> +	compatible = "ti,lm3532";
> +	reg = <0x38>;
> +
> +	/* GPIO134 for HWEN pin */
> +	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
> +
> +	backlight {
> +		compatible = "ti,lmu-backlight", "ti,lm3532-backlight";

This looks backwards. The most general string should be later in the
list. This applies elsewhere too.

[...]

> diff --git a/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
> new file mode 100644
> index 0000000..554ddca
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
> @@ -0,0 +1,127 @@
> +TI LMU backlight device tree bindings
> +
> +Required properties:
> +  - compatible: One of lists below with "ti,lmu-backlight" should be set.
> +    "ti,lm3532-backlight"
> +    "ti,lm3631-backlight"
> +    "ti,lm3633-backlight"
> +    "ti,lm3695-backlight"
> +    "ti,lm3697-backlight"

Do you mean that "ti,lmu-backlight" should be a fallback entry in the
compatible list?

> +  - hvled1-used, hvled2-used, hvled3-used: Backlight string configuration.
> +    Each backlight child node should include this information about
> +    which backlight string is used.
> +
> +Optional properties
> +  - bl-name: Backlight device name

Why bother abbreviating backlight to bl?

What's this for anyway? Surely something else has to link to the
backlight node, and a meaningful name should be implied.

> +  - max-current-milliamp: Max current setting. Unit is mA.

Type?

> +  - initial-brightness: Backlight initial brightness

Type? Units?

> +  - ramp-up: Light effect for ramp up rate. Unit is msec.
> +  - ramp-down: Light effect for ramp down rate. Unit is msec.
> +  - pwm-period: PWM period. Only valid for PWM brightness control mode.

Type? Units?

> +  - pwms, pwm-names: For the PWM user nodes, please refer to

How many do you expect?

What are each of them for?

What are they named?

Thanks,
Mark.
