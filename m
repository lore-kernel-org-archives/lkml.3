Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaI0Kgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:36:36 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36176 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaI0Kge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:36:34 -0400
Message-ID: <5426932E.7060609@kernel.org>
Date: Sat, 27 Sep 2014 11:36:30 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 2/8] mfd: da9150: Add DT binding documentation for core
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <b71815ff49a1cabe2c7907a96cc1be34f924648e.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <b71815ff49a1cabe2c7907a96cc1be34f924648e.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Obviously this really wants a review from one of the device tree guys, but I
have a few
bits based on what Mark has recently said in other reviews ;)
> ---
>  Documentation/devicetree/bindings/mfd/da9150.txt | 41 ++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt b/Documentation/devicetree/bindings/mfd/da9150.txt
> new file mode 100644
> index 0000000..d7de150
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/da9150.txt
> @@ -0,0 +1,41 @@
> +Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
> +
> +DA9150 consists of a group of sub-devices (I2C Only):
What does I2C only add to the description?
> +
> +Device			 Description
> +------			 -----------
> +da9150-gpadc		: IIO - GPADC
Given usual aversion to anything driver specific in the device tree description
you probably
just want to describe what they do rather than what subsystem provides the driver.

> +da9150-charger		: Power Supply (Charger)
> +
> +======
> +
> +Required properties:
> +- compatible : Should be "dlg,da9150"
> +- reg: Specifies the I2C slave address
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the IRQs from da9150 are delivered to.
> +- interrupts: IRQ line info for da9150 chip.
Cross refer to the standard interrupts doc for these...

> +- interrupt-controller: da9150 has internal IRQs (own IRQ domain).
> +
> +Sub-devices:
> +- da9150-gpadc: See Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> +- da9150-charger: See Documentation/devicetree/bindings/power/da9150-charger.txt
> +
> +
> +Example:
> +
> +	charger_fg: da9150@58 {
> +		compatible = "dlg,da9150";
> +		reg = <0x58>;
> +		interrupt-parent = <&gpio6>;
> +		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
> +		interrupt-controller;
> +
> +		gpadc: da9150-gpadc {
> +			...
> +		};
> +
> +		da9150-charger {
> +			...
> +		};
> +	};
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
