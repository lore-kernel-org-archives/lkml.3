Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbbAFQy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:54:28 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61964 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbbAFQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:54:24 -0500
MIME-Version: 1.0
In-Reply-To: <1420523117-6814-4-git-send-email-beomho.seo@samsung.com>
References: <1420523117-6814-1-git-send-email-beomho.seo@samsung.com> <1420523117-6814-4-git-send-email-beomho.seo@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 6 Jan 2015 10:54:01 -0600
Message-ID: <CAL_Jsq+Sz_iCkaDWzssA6DFeLX8fQ2hqKut0Gv6i5P706bmvpA@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/3] Documentation: Add documentation for rt5033
 multifunction device
To: Beomho Seo <beomho.seo@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lee.jone@linaro.org, Mark Brown <broonie@kernel.org>,
        Sebastian Reichel <sre@kernel.org>, dbaryshkov@gmail.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, InKi Dae <inki.dae@samsung.com>,
        sw0312.kim@samsung.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 11:45 PM, Beomho Seo <beomho.seo@samsung.com> wrote:
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
>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 ++++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  2 files changed, 109 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
> new file mode 100644
> index 0000000..52a6d33
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
> @@ -0,0 +1,108 @@
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
> +named "regulators" usinge the following format.

s/usinge/using/

> +
> +       regulators {
> +               regulator-name {
> +                       regulator-name = LDO/BUCK
> +                       regulator subnodes called X, Y and Z
> +               };
> +       };
> +       refer Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +
> +Battery charger: There battery charger of RT5033 have to be instantiated under
> +sub-node named "charger" using the following format.
> +
> +Required properties:
> +- compatible : Must be "richtek,rt5033-charger".
> +- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
> +  are 350 mA to 650 mA programmed by I2C per 100 mA.
> +- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
> +  voltage is below pre-charge threshold voltage, the charger is in pre-charge
> +  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
> +  by I2C per 0.1 V.
> +- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
> +  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
> +- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
> +  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
> +- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
> +  to 200 mA.

Please align -uamp and -uvolt names with regulator binding suffixes.

> +       charger {
> +               compatible = "richtek,rt5033-charger";
> +               richtek,pre-uamp = <350000>;
> +               richtek,pre-threshold-uvolt = <3400000>;
> +               richtek,fast-uamp = <2000000>;
> +               richtek,const-uvolt = <4350000>;
> +               richtek,eoc-uamp = <250000>;
> +       };
> +
> +
> +Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
> +using the following format.
> +
> +Required properties:
> +- compatible = Must be "richtek,rt5033-battery".
> +
> +       i2c_fuel: i2c@1 {

Drop the @1.

> +               compatible = "i2c-gpio";
> +               standard i2c-gpio constraints...
> +               fuelgauge {
> +                       compatible = "richtek,rt5033-battery".
> +               };
> +       };

I'm a bit confused by this. The fuelgauge is an i2c device hanging off
the rt5033 or a 2nd i2c slave on the rt5033?

> +
> +
> +Example:
> +
> +               rt5033@34 {
> +                       compatible = "richtek,rt5033";
> +                       reg = <0x34>;
> +                       interrupt-parent = <&gpx1>;
> +                       interrupts = <5 0>;
> +
> +                       regulators {
> +                               buck_reg: BUCK {
> +                                       regulator-name = "BUCK";
> +                                       regulator-min-microvolt = <1200000>;
> +                                       regulator-max-microvolt = <1200000>;
> +                                       regulator-always-on;
> +                               };
> +                       };
> +
> +                       charger {
> +                               compatible = "richtek,rt5033-charger";
> +                               richtek,pre-uamp = <350000>;
> +                               richtek,pre-threshold-uvolt = <3400000>;
> +                               richtek,fast-uamp = <2000000>;
> +                               richtek,const-uvolt = <4350000>;
> +                               richtek,eoc-uamp = <250000>;
> +                       };
> +
> +               };
> +
> +               i2c_fuel: i2c@10 {
> +                       compatible = "i2c-gpio";
> +                       gpios = <&gpm3 1 0
> +                               &gpm3 0 0>;
> +
> +                       fuel: rt5033-battery@35 {
> +                               compatible = "richtek,rt5033-battery";
> +                               interrupt-parent = <&gpx2>;
> +                               interrupts = <3 0>;
> +                               reg = <0x35>;
> +                       };
> +               };
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..611b543 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -124,6 +124,7 @@ ralink      Mediatek/Ralink Technology Corp.
>  ramtron        Ramtron International
>  realtek Realtek Semiconductor Corp.
>  renesas        Renesas Electronics Corporation
> +richtek        Richtek Technology Corporation
>  ricoh  Ricoh Co. Ltd.
>  rockchip       Fuzhou Rockchip Electronics Co., Ltd
>  samsung        Samsung Semiconductor
> --
> 1.7.9.5
>
