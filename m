Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966AbaDIVuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:50:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33216 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113AbaDIVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
	<1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
Date: Wed, 9 Apr 2014 16:50:33 -0500
Message-ID: <CAL_JsqJowqV2bsxE2VeYXQQSj4_L_KcH+C_dD=ZUvC=1crN4dA@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
From: Rob Herring <robherring2@gmail.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Jonathan Cameron <jic23@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Silvio F <silvio.fricke@gmail.com>, heiko.stuebner@bq.com,
        Olof Johansson <olof@lixom.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 2:45 PM, Matthias Brugger <matthias.bgg@gmail.com> wrote:
> This adds a generic devicetree board file and a dtsi for boards
> based on the MT6589 SoCs from Mediatek.
>
> Apart from the generic parts (gic, clocks) the only component
> currently supported are the timers.
>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  arch/arm/Kconfig                                   |    2 +
>  arch/arm/Makefile                                  |    1 +
>  arch/arm/boot/dts/mtk6589.dtsi                     |  105 ++++++++++++++++++++

Please add an actual board so your dts file can actually be built.

>  arch/arm/mach-mediatek/Kconfig                     |   14 +++
>  arch/arm/mach-mediatek/Makefile                    |    1 +
>  arch/arm/mach-mediatek/mediatek.c                  |   40 ++++++++
>  7 files changed, 164 insertions(+)
>  create mode 100644 arch/arm/boot/dts/mtk6589.dtsi
>  create mode 100644 arch/arm/mach-mediatek/Kconfig
>  create mode 100644 arch/arm/mach-mediatek/Makefile
>  create mode 100644 arch/arm/mach-mediatek/mediatek.c
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 0f01c9b..af48801 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -67,6 +67,7 @@ linux Linux-specific binding
>  lsi    LSI Corp. (LSI Logic)
>  marvell        Marvell Technology Group Ltd.
>  maxim  Maxim Integrated Products
> +mediatek       MediaTek Inc.
>  microchip      Microchip Technology Inc.
>  mosaixtech     Mosaix Technologies, Inc.
>  moxa   Moxa
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 5db05f6a..04d46ec 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -995,6 +995,8 @@ source "arch/arm/mach-mv78xx0/Kconfig"
>
>  source "arch/arm/mach-imx/Kconfig"
>
> +source "arch/arm/mach-mediatek/Kconfig"
> +
>  source "arch/arm/mach-mxs/Kconfig"
>
>  source "arch/arm/mach-netx/Kconfig"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 41c1931..8ce9774 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -170,6 +170,7 @@ machine-$(CONFIG_ARCH_MSM)          += msm
>  machine-$(CONFIG_ARCH_MV78XX0)         += mv78xx0
>  machine-$(CONFIG_ARCH_MVEBU)           += mvebu
>  machine-$(CONFIG_ARCH_MXC)             += imx
> +machine-$(CONFIG_ARCH_MEDIATEK)                += mediatek
>  machine-$(CONFIG_ARCH_MXS)             += mxs
>  machine-$(CONFIG_ARCH_NETX)            += netx
>  machine-$(CONFIG_ARCH_NOMADIK)         += nomadik
> diff --git a/arch/arm/boot/dts/mtk6589.dtsi b/arch/arm/boot/dts/mtk6589.dtsi
> new file mode 100644
> index 0000000..6dbb74f
> --- /dev/null
> +++ b/arch/arm/boot/dts/mtk6589.dtsi
> @@ -0,0 +1,105 @@
> +/*
> + * Copyright (c) 2014 MundoReader S.L.
> + * Author: Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include "skeleton.dtsi"
> +
> +/ {
> +       compatible = "mediatek,mt6589";

Please document this compatible property.

> +       interrupt-parent = <&gic>;
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       next-level-cache = <&L2>;
> +                       reg = <0x0>;
> +               };
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       next-level-cache = <&L2>;
> +                       reg = <0x1>;
> +               };
> +               cpu@2 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       next-level-cache = <&L2>;
> +                       reg = <0x2>;
> +               };
> +               cpu@3 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       next-level-cache = <&L2>;
> +                       reg = <0x3>;
> +               };
> +
> +       };
> +
> +       clocks {
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +
> +               system_clk: system_clk {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +                       clock-output-names = "system_clk";
> +               };
> +
> +               rtc_clk: rtc_clk {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <32000>;
> +                       #clock-cells = <0>;
> +                       clock-output-names = "rtc_clk";
> +               };
> +       };
> +
> +       soc {
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               compatible = "simple-bus";
> +               clock-ranges;
> +               ranges;
> +
> +               gic: interrupt-controller@10212000 {
> +                       compatible = "arm,cortex-a9-gic";

A7 is GICv2. You are missing the various virtualization extension properties.

> +                       interrupt-controller;
> +                       #interrupt-cells = <3>;
> +                       reg = <0x10211000 0x1000>,
> +                             <0x10212000 0x1000>;
> +               };
> +
> +               L2: l2-cache-controller@1020e000 {
> +                       compatible = "arm,pl310-cache";

Really? An A7 normally has a built-in L2, not a PL310.

> +                       reg = <0x1020e000 0x1000>;
> +                       cache-unified;
> +                       cache-level = <2>;
> +               };
> +
> +               timer: timer@10008000 {
> +                       compatible = "mediatek,mtk6589-timer";
> +                       reg = <0x10008000 0x80>;
> +                       interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&system_clk>, <&rtc_clk>;
> +                       clock-names = "sys_clk", "rtc_clk";
> +               };
> +       };
> +};
> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
> new file mode 100644
> index 0000000..c0139ca
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/Kconfig
> @@ -0,0 +1,14 @@
> +config ARCH_MEDIATEK
> +       bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
> +       select ARCH_REQUIRE_GPIOLIB

Then where is your GPIO driver?

> +       select ARM_GIC
> +       select CACHE_L2X0
> +       select HAVE_ARM_TWD if LOCAL_TIMERS
> +       select HAVE_SMP

Not needed now (going into 3.15).

> +       select LOCAL_TIMERS if SMP
> +       select COMMON_CLK

ditto

> +       select GENERIC_CLOCKEVENTS

ditto

> +       select MTK_TIMER
> +       select CLKSRC_MMIO

This belongs with your timer kconfig
