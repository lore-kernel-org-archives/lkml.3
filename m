Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaKMQRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:17:53 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:65368 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaKMQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:17:50 -0500
MIME-Version: 1.0
In-Reply-To: <1415808457-4030-1-git-send-email-ibanezchen@gmail.com>
References: <1415808457-4030-1-git-send-email-ibanezchen@gmail.com>
Date: Thu, 13 Nov 2014 17:17:48 +0100
Message-ID: <CABuKBeJv0S2Q4W1fqb=8BUG6AEvFsZ6sY9QXuz=CRe+qbaYzQQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] ARM: mediatek: Add basic support for mt6592
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Howard Chen <ibanezchen@gmail.com>
Cc: arm@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-12 17:07 GMT+01:00 Howard Chen <ibanezchen@gmail.com>:
> * A dtsi for boards based on Mediatek MT6592 SoCs
> * Compatible string in arch/arm/mach-mediatek/mediatek.c
>
> Signed-off-by: Howard Chen <ibanezchen@gmail.com>
> ---
>  arch/arm/boot/dts/mt6592.dtsi     | 97 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mediatek/mediatek.c |  1 +
>  2 files changed, 98 insertions(+)
>  create mode 100644 arch/arm/boot/dts/mt6592.dtsi
>
> diff --git a/arch/arm/boot/dts/mt6592.dtsi b/arch/arm/boot/dts/mt6592.dtsi
> new file mode 100644
> index 0000000..65aa81b
> --- /dev/null
> +++ b/arch/arm/boot/dts/mt6592.dtsi
> @@ -0,0 +1,97 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Howard Chen <ibanezchen@gmail.com>
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
> +#include "skeleton.dtsi"

Regarding a discussion I had with Joe and Arnd [0], I think we should
use skeleton64.dtsi here, right?
The datasheets states that mt6592 supports up to 8 GB.

[0] https://lkml.org/lkml/2014/11/4/192

> +
> +/ {
> +       compatible = "mediatek,mt6592";
> +       interrupt-parent = <&gic>;
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x0>;
> +               };
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x1>;
> +               };
> +               cpu@2 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x2>;
> +               };
> +               cpu@3 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x3>;
> +               };
> +               cpu@4 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x4>;
> +               };
> +               cpu@5 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x5>;
> +               };
> +               cpu@6 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x6>;
> +               };
> +               cpu@7 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a7";
> +                       reg = <0x7>;
> +               };
> +       };
> +
> +       system_clk: dummy13m {
> +               compatible = "fixed-clock";
> +               clock-frequency = <13000000>;
> +               #clock-cells = <0>;
> +       };
> +
> +       rtc_clk: dummy32k {
> +               compatible = "fixed-clock";
> +               clock-frequency = <32000>;
> +               #clock-cells = <0>;
> +       };
> +
> +       timer: timer@10008000 {
> +               compatible = "mediatek,mt6577-timer";
> +               reg = <0x10008000 0x80>;
> +               interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&system_clk>, <&rtc_clk>;
> +               clock-names = "system-clk", "rtc-clk";
> +       };
> +
> +       gic: interrupt-controller@10211000 {
> +               compatible = "arm,cortex-a7-gic";
> +               interrupt-controller;
> +               #interrupt-cells = <3>;
> +               reg = <0x10211000 0x1000>,
> +                     <0x10212000 0x1000>;
> +       };
> +
> +};
> diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
> index f2acf07..88e4626 100644
> --- a/arch/arm/mach-mediatek/mediatek.c
> +++ b/arch/arm/mach-mediatek/mediatek.c
> @@ -19,6 +19,7 @@
>
>  static const char * const mediatek_board_dt_compat[] = {
>         "mediatek,mt6589",
> +       "mediatek,mt6592",
>         NULL,
>  };
>
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
