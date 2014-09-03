Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaICIFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:05:22 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58305 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaICIFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:05:14 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: rui.zhang@intel.com, edubezval@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com, zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v4 2/4] dt-bindings: document Rockchip thermal
Date: Wed, 03 Sep 2014 10:07:15 +0200
Message-ID: <11280986.L6lv82O8Qv@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409710239-19941-3-git-send-email-caesar.wang@rock-chips.com>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1409710239-19941-3-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. September 2014, 10:10:37 schrieb Caesar Wang:
> This add the necessary binding documentation for the thermal
> found on Rockchip SoCs
> 
> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  .../devicetree/bindings/thermal/rockchip-thermal.txt | 20
> ++++++++++++++++++++ 1 file changed, 20 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> 
> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new file
> mode 100644
> index 0000000..1ed4d4c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> @@ -0,0 +1,20 @@
> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
> +
> +Required properties:
> +- compatible: "rockchip,rk3288-tsadc"
> +- reg: physical base address of the controller and length of memory mapped
> +       region.
> +- interrupts: The interrupt number to the cpu. The interrupt specifier
> format +	      depends on the interrupt controller.
> +- clocks: Must contain an entry for each entry in clock-names.
> +- clock-names: Shall be "tsadc" for the converter-clock, and "apb_pclk" for
> +	       the peripheral clock.

You're using the passive-temp, critical-temp and force-shut-temp properties in 
your driver without declaring them here.

But more importantly, please use the generic trip-points for this. I guess it 
shouldn't be a problem to introduce a "forced-shutdown" trippoint [0] for the 
additional trip-point you have - thermal maintainers, please shout if I'm 
wrong :-)


Heiko


[0] in a separate patch, changing
- thermal_trip_type enum in include/linux/thermal.h
- trip_types mapping in drivers/thermal/of-thermal.c
- Documentation/devicetree/bindings/thermal/thermal.txt

> +
> +Example:
> +tsadc: tsadc@ff280000 {
> +	compatible = "rockchip,rk3288-tsadc";
> +	reg = <0xff280000 0x100>;
> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +	clock-names = "tsadc", "apb_pclk";
> +};

