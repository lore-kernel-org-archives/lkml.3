Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaCECi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:38:59 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64740 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbaCECi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:38:57 -0500
Date: Wed, 5 Mar 2014 10:38:50 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH Resend 2/2] mfd: da9055: Add DT binding documentation for
 PMIC
Message-ID: <20140305023850.GN10579@lee--X1>
References: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
 <574af9f46ca08e66f6e9bda8ef3a51e7c5c5178b.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <574af9f46ca08e66f6e9bda8ef3a51e7c5c5178b.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> Acked-by: Mark Brown <broonie@kernel.org>

As this has Mark's ack, I'd be happy to apply the patch if you correct
a couple of nits.

> ---
>  Documentation/devicetree/bindings/mfd/da9055.txt |   73 ++++++++++++++++++++++
>  1 files changed, 73 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/da9055.txt b/Documentation/devicetree/bindings/mfd/da9055.txt
> new file mode 100644
> index 0000000..f903c3f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/da9055.txt
> @@ -0,0 +1,73 @@
> +* Dialog DA9055 Power Management Integrated Circuit (PMIC)
> +
> +DA9055 consists of a large and varied group of sub-devices (I2C Only):
> +
> +Device			 Supply Names	 Description
> +------			 ------------	 -----------
> +da9055-gpio		:		: GPIOs
> +da9055-regulator	:		: Regulators
> +da9055-onkey		:		: On key
> +da9055-rtc		:		: RTC
> +da9055-hwmon		:		: ADC
> +da9055-watchdog		:		: Watchdog
> +
> +The CODEC device in DA9055 has a separate, configurable I2C address and so
> +is instantiated separately from the PMIC.
> +
> +For details on accompanying CODEC I2C device, see the following:
> +Documentation/devicetree/bindings/sound/da9055.txt
> +
> +======
> +
> +Required properties:
> +- compatible : Should be "dlg,da9055-pmic"
> +- reg: Specifies the I2C slave address (defaults to 0x5a but can be modified)
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the IRQs from da9055 are delivered to.
> +- interrupts: IRQ line info for da9055 chip.
> +- interrupt-controller: da9055 has internal IRQs (has own IRQ domain).
> +- #interrupt-cells: Should be 1, is the local IRQ number for da9055.
> +
> +Sub-nodes:
> +- regulators : Contain the regulator nodes. The DA9055 regulators are
> +  bound using their names as listed below:
> +
> +    buck1     : regulator BUCK1
> +    buck2     : regulator BUCK2
> +    ldo1      : regulator LDO1
> +    ldo2      : regulator LDO2
> +    ldo3      : regulator LDO3
> +    ldo4      : regulator LDO4
> +    ldo5      : regulator LDO5
> +    ldo6      : regulator LDO6
> +
> +  The bindings details of individual regulator device can be found in:
> +  Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +
> +Example:
> +
> +	pmic: da9055-pmic@5a {
> +		compatible = "dlg,da9055-pmic";
> +		reg = <0x5a>;
> +		interrupt-parent = <&intc>;
> +		interrupts = <5 0x8>;

I'd prefer if you used the #defines in:
    dt-bindings/interrupt-controller/irq.h

> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +
> +		regulators {
> +			buck1: BUCK1 {
> +				regulator-min-microvolt = <725000>;
> +				regulator-max-microvolt = <2075000>;
> +			};
> +
> +			buck2: BUCK2 {
> +				regulator-min-microvolt = <925000>;
> +				regulator-max-microvolt = <2500000>;
> +			};

New line here.

> +			ldo1: LDO1 {
> +				regulator-min-microvolt = <900000>;
> +				regulator-max-microvolt = <3300000>;
> +			};
> +		};
> +	};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
