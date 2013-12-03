Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3LCJgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:36:54 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40729 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3LCJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:36:48 -0500
Date: Tue, 3 Dec 2013 09:36:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        sameo@linux.intel.com, grant.likely@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: DT bindings for TPS65218 PMIC
Message-ID: <20131203093637.GE11828@lee--X1>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
 <1386053006-6480-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386053006-6480-2-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add DT bindings for TPS65218 PMIC.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/tps65218.txt |   27 ++++++++++++++++++++
>  .../devicetree/bindings/regulator/tps65218.txt     |   22 ++++++++++++++++
>  2 files changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
>  create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/tps65218.txt b/Documentation/devicetree/bindings/mfd/tps65218.txt
> new file mode 100644
> index 0000000..87cb7a8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/tps65218.txt
> @@ -0,0 +1,27 @@
> +The TPS65218 Integrated Power Management Chips.
> +These chips are connected to an i2c bus.

                                   I2C

> +Required properties:
> +- compatible : Must be "ti,tps65218";
> +- interrupts : This i2c device has an IRQ line connected to the main SoC

                       I2C

> +- interrupt-controller : Since the tps65218 support several interrupts

                                               support(s) (hosts?)

> +  internally, it is considered as an interrupt controller cascaded to the SoC.
> +- #interrupt-cells = <2>;
> +- interrupt-parent : The parent interrupt controller.

           Phandle to ...

> +Optional node:

            node(s):

> +- Child nodes contain in the tps65218.
> +  It supports a number of features.

Please re-phase the above two sentences to something decipherable.

> +  The children nodes will thus depend of the capability of the variant.

Please, go on ...

> +Example:
> +/*
> + * Integrated Power Management Chip
> + */
> +tps@24 {
> +    compatible = "ti,tps65218";
> +    reg = <0x24>;
> +    interrupt-controller;
> +    #interrupt-cells = <2>;
> +    interrupt-parent = <&gic>;
> +};

Perhaps it would be better to centralise the documentation inclusive
of the regulator contingent. Or at least provide a _full_ example in
each document.

> diff --git a/Documentation/devicetree/bindings/regulator/tps65218.txt b/Documentation/devicetree/bindings/regulator/tps65218.txt
> new file mode 100644
> index 0000000..1ccf170
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/tps65218.txt
> @@ -0,0 +1,22 @@
> +TPS65218 family of regulators
> +
> +Required properties:
> +For tps65218 regulators/LDOs
> +- compatible:
> +  - "ti,tps65218-dcdc1" for DCDC1
> +  - "ti,tps65218-dcdc2" for DCDC2
> +  - "ti,tps65218-dcdc3" for DCDC3
> +  - "ti,tps65218-dcdc4" for DCDC4
> +  - "ti,tps65218-dcdc5" for DCDC5
> +  - "ti,tps65218-dcdc6" for DCDC6
> +  - "ti,tps65218-ldo1" for LDO1 LDO

Why aren't you using 'regulator-compatible'?

> +Optional properties:
> +- Any optional property defined in bindings/regulator/regulator.txt
> +
> +Example:
> +	xyz: regulator@0 {

Genuine question: Is the @0 meaningful?

> +		compatible = "ti,tps65218-dcdc1";
> +		regulator-min-microvolt  = <1000000>;
> +		regulator-max-microvolt  = <3000000>;
> +	};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
