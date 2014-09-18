Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaIRJ2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:28:10 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51234 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbaIRJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <1410926353-15674-3-git-send-email-caesar.wang@rock-chips.com>
References: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com> <1410926353-15674-3-git-send-email-caesar.wang@rock-chips.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Thu, 18 Sep 2014 11:27:45 +0200
X-Google-Sender-Auth: dovIMzMonrJiYCI9PQZnDdbbNNE
Message-ID: <CAAObsKA61Ano85P6PehOY7WqR0FgTz_Rfur8UAt56ZXoNyoyqQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] dt-bindings: document Rockchip thermal
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, dmitry.torokhov@gmail.com,
        addy.ke@rock-chips.com, zyf@rock-chips.com, cjf@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2014 05:59, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> This add the necessary binding documentation for the thermal
> found on Rockchip SoCs

Hi Caesar,

is there any reason to not use the existing thermal bindings? You can
find a description in
Documentation/devicetree/bindings/thermal/thermal.txt and example code
in omap, or in the patches for Tegra recently posted by Mikko
Perttunen.

Regards,

Tomeu

> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  .../bindings/thermal/rockchip-thermal.txt          | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>
> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> new file mode 100644
> index 0000000..6fc8bc3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> @@ -0,0 +1,41 @@
> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
> +
> +Required properties:
> +- compatible: "rockchip,rk3288-tsadc"
> +- reg: physical base address of the controller and length of memory mapped
> +       region.
> +- interrupts: The interrupt number to the cpu. The interrupt specifier format
> +             depends on the interrupt controller.
> +- clocks: Must contain an entry for each entry in clock-names.
> +- clock-names: Shall be "tsadc" for the converter-clock, and "apb_pclk" for
> +              the peripheral clock.
> +- num-trips:  number of total trip points, this is required, set it 0 if none,
> +             if greater than 0, the following properties must be defined;
> +- tripN-temp: temperature of trip point N, should be in ascending order;
> +- tripN-type: type of trip point N, should be one of "active" "passive" "hot"
> +             "critical";
> +- tripN-cdev-num: number of the cooling devices which can be bound to trip
> +                 point N, this is required if trip point N is defined, set it 0 if none,
> +                 otherwise the following cooling device names must be defined;
> +- tripN-cdev-nameM: name of the No. M cooling device of trip point N;
> +
> +Example:
> +tsadc: tsadc@ff280000 {
> +       compatible = "rockchip,rk3288-tsadc";
> +       reg = <0xff280000 0x100>;
> +       interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +       clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +       clock-names = "tsadc", "apb_pclk";
> +
> +       num-trips = <2>;
> +
> +       trip0-temp = <80>;
> +       trip0-type = "passive";
> +       trip0-cdev-num = <1>;
> +       trip0-cdev-name0 = "thermal-cpufreq-0";
> +
> +       trip1-temp = <100>;
> +       trip1-type = "critical";
> +       trip1-cdev-num = <1>;
> +       trip1-cdev-name0 = "thermal-cpufreq-0";
> +};
> --
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
