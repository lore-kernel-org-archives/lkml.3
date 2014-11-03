Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaKCR6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:58:14 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:54924 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaKCR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <1413973797-17619-4-git-send-email-yingjoe.chen@mediatek.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	<1413973797-17619-4-git-send-email-yingjoe.chen@mediatek.com>
Date: Mon, 3 Nov 2014 18:58:09 +0100
Message-ID: <CABuKBeKx3hKiCRwM0jGwjpbF929BZC313DY6KQR8hUsi3jwLcA@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] ARM: mediatek: Add basic support for mt8135
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 12:29 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
>
> This adds a basic dtsi for MT8135 based SoC.
>
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi     | 115 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mediatek/mediatek.c |   1 +
>  2 files changed, 116 insertions(+)
>  create mode 100644 arch/arm/boot/dts/mt8135.dtsi
>
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> new file mode 100644
> index 0000000..90a56ad
> --- /dev/null
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -0,0 +1,115 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Joe.C <yingjoe.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include "skeleton64.dtsi"

Same here A15 is 32 bits.

> +
> +/ {
> +       compatible = "mediatek,mt8135";
> +       interrupt-parent = <&gic>;
> +
> +       cpu-map {
> +               cluster0 {
> +                       core0 {
> +                               cpu = <&cpu0>;
> +                       };
> +                       core1 {
> +                               cpu = <&cpu1>;
> +                       };
> +               };
> +
> +               cluster1 {
> +                       core0 {
> +                               cpu = <&cpu2>;
> +                       };
> +                       core1 {
> +                               cpu = <&cpu3>;
> +                       };
> +               };
> +       };
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu0: cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x000>;
> +               };
> +
> +               cpu1: cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x001>;
> +               };
> +
> +               cpu2: cpu@100 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x100>;
> +               };
> +
> +               cpu3: cpu@101 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x101>;
> +               };
> +       };
> +
> +       clocks {
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               compatible = "simple-bus";
> +               ranges;
> +
> +               system_clk: dummy13m {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               rtc_clk: dummy32k {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <32000>;
> +                       #clock-cells = <0>;
> +               };
> +       };
> +
> +       soc {
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               compatible = "simple-bus";
> +               ranges;
> +
> +               timer: timer@10008000 {
> +                       compatible = "mediatek,mt8135-timer", "mediatek,mt6577-timer";
> +                       reg = <0 0x10008000 0 0x80>;
> +                       interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
> +                       clocks = <&system_clk>, <&rtc_clk>;
> +                       clock-names = "system-clk", "rtc-clk";
> +               };
> +
> +               gic: interrupt-controller@10211000 {
> +                       compatible = "arm,cortex-a15-gic";
> +                       interrupt-controller;
> +                       #interrupt-cells = <3>;
> +                       reg = <0 0x10211000 0 0x1000>,
> +                             <0 0x10212000 0 0x1000>,
> +                             <0 0x10214000 0 0x2000>,
> +                             <0 0x10216000 0 0x2000>;
> +               };
> +       };
> +};
> diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
> index 7f478ce..48051a2 100644
> --- a/arch/arm/mach-mediatek/mediatek.c
> +++ b/arch/arm/mach-mediatek/mediatek.c
> @@ -20,6 +20,7 @@
>  static const char * const mediatek_board_dt_compat[] = {
>         "mediatek,mt6589",
>         "mediatek,mt8127",
> +       "mediatek,mt8135",
>         NULL,
>  };
>
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
