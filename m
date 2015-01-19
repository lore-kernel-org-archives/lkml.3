Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbbASIPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:15:12 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34962 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbASIPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:15:09 -0500
Date: Mon, 19 Jan 2015 08:15:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, lee.jone@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH v2 3/3] Documentation: Add documentation for rt5033
 multifunction device
Message-ID: <20150119081502.GD21886@x1>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
 <1420793114-20586-4-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420793114-20586-4-git-send-email-beomho.seo@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT Ack please gents.

> This patch device tree binding documentation for rt5033 multifunction device.
> 
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes in v2
> - Fix incorrect typo.
> - Align -uamp and -uvolt names with regulator binding suffixes.
> - Drop incorrect phandle.
> - Fix incorrect example.
> ---
>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  2 files changed, 102 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
> new file mode 100644
> index 0000000..64b23e8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
> @@ -0,0 +1,101 @@
> +Richtek RT5033 Power management Integrated Circuit
> +
> +RT5033 is a Multifunction device which includes battery charger, fuel gauge,
> +flash LED current source, LDO and synchronous Buck converter for portable
> +applications. It is interfaced to host controller using i2c interface.
> +
> +Required properties:
> +- compatible : Must be "richtek,rt5033"
> +- reg : Specifies the i2c slave address of general part.
> +- interrupts : This i2c devices has an IRQ line connected to the main SoC.
> +- interrupt-parent : The parent interrupt controller.
> +
> +Optional node:
> +Regulators: The regulators of RT5033 have to be instantiated under sub-node
> +named "regulators" using the following format.
> +
> +	regulators {
> +		regulator-name {
> +			regulator-name = LDO/BUCK
> +			regulator subnodes called X, Y and Z
> +		};
> +	};
> +	refer Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +
> +Battery charger: There battery charger of RT5033 have to be instantiated under
> +sub-node named "charger" using the following format.
> +
> +Required properties:
> +- compatible : Must be "richtek,rt5033-charger".
> +- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
> +  are 350 mA to 650 mA programmed by I2C per 100 mA.
> +- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
> +  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
> +- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
> +  to 200 mA.
> +- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
> +  voltage is below pre-charge threshold voltage, the charger is in pre-charge
> +  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
> +  by I2C per 0.1 V.
> +- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
> +  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
> +
> +	charger {
> +		compatible = "richtek,rt5033-charger";
> +		richtek,pre-uamp = <350000>;
> +		richtek,fast-uamp = <2000000>;
> +		richtek,eoc-uamp = <250000>;
> +		richtek,pre-threshold-uvolt = <3400000>;
> +		richtek,const-uvolt = <4350000>;
> +
> +	};
> +
> +
> +Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
> +using the following format.
> +
> +Required properties:
> +- compatible = Must be "richtek,rt5033-battery".
> +
> +	rt5033@35 {
> +		compatible = "richtek,rt5033-battery";
> +		interrupt-parent = <&gpx2>;
> +		interrupts = <3 0>;
> +		reg = <0x35>;
> +	};
> +
> +Example:
> +
> +		rt5033@34 {
> +			compatible = "richtek,rt5033";
> +			reg = <0x34>;
> +			interrupt-parent = <&gpx1>;
> +			interrupts = <5 0>;
> +
> +			regulators {
> +				buck_reg: BUCK {
> +					regulator-name = "BUCK";
> +					regulator-min-microvolt = <1200000>;
> +					regulator-max-microvolt = <1200000>;
> +					regulator-always-on;
> +				};
> +			};
> +
> +			charger {
> +				compatible = "richtek,rt5033-charger";
> +				richtek,pre-uamp = <350000>;
> +				richtek,fast-uamp = <2000000>;
> +				richtek,eoc-uamp = <250000>;
> +				richtek,pre-threshold-uvolt = <3400000>;
> +				richtek,const-uvolt = <4350000>;
> +			};
> +
> +		};
> +
> +		rt5033@35 {
> +				compatible = "richtek,rt5033-battery";
> +				interrupt-parent = <&gpx2>;
> +				interrupts = <3 0>;
> +				reg = <0x35>;
> +		};
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..611b543 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -124,6 +124,7 @@ ralink	Mediatek/Ralink Technology Corp.
>  ramtron	Ramtron International
>  realtek Realtek Semiconductor Corp.
>  renesas	Renesas Electronics Corporation
> +richtek	Richtek Technology Corporation
>  ricoh	Ricoh Co. Ltd.
>  rockchip	Fuzhou Rockchip Electronics Co., Ltd
>  samsung	Samsung Semiconductor

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
