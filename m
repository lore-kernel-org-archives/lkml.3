Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaEWRDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:03:03 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:38424 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <1400841343-6016-4-git-send-email-t.dakhran@samsung.com>
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
	<1400841343-6016-4-git-send-email-t.dakhran@samsung.com>
Date: Fri, 23 May 2014 19:02:59 +0200
Message-ID: <CABuKBeKgva6gbN1GkVeZNPuagewrw09uz8Fqb8-qKOgaSg4oZw@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] ARM: dts: Add initial device tree support for EXYNOS5410
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Heiko Stuebner <heiko@sntech.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Romain Naour <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-23 12:35 GMT+02:00 Tarek Dakhran <t.dakhran@samsung.com>:
> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
>
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/boot/dts/Makefile                |    1 +
>  arch/arm/boot/dts/exynos5410-smdk5410.dts |   82 ++++++++++++
>  arch/arm/boot/dts/exynos5410.dtsi         |  206 +++++++++++++++++++++++++++++
>  3 files changed, 289 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index cd399a2..709f862 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -73,6 +73,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>         exynos5250-smdk5250.dtb \
>         exynos5250-snow.dtb \
>         exynos5260-xyref5260.dtb \
> +       exynos5410-smdk5410.dtb \
>         exynos5420-arndale-octa.dtb \
>         exynos5420-peach-pit.dtb \
>         exynos5420-smdk5420.dtb \
> diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
> new file mode 100644
> index 0000000..7275bbd
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
> @@ -0,0 +1,82 @@
> +/*
> + * SAMSUNG SMDK5410 board device tree source
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/dts-v1/;
> +#include "exynos5410.dtsi"
> +/ {
> +       model = "Samsung SMDK5410 board based on EXYNOS5410";
> +       compatible = "samsung,smdk5410", "samsung,exynos5410", "samsung,exynos5";
> +
> +       memory {
> +               reg = <0x40000000 0x80000000>;
> +       };
> +
> +       chosen {
> +               bootargs = "console=ttySAC2,115200";
> +       };
> +
> +       fin_pll: xxti {
> +               compatible = "fixed-clock";
> +               clock-frequency = <24000000>;
> +               clock-output-names = "fin_pll";
> +               #clock-cells = <0>;
> +       };
> +
> +       firmware@02037000 {
> +               compatible = "samsung,secure-firmware";
> +               reg = <0x02037000 0x1000>;
> +       };
> +
> +};
> +
> +&mmc_0 {
> +       status = "okay";
> +       num-slots = <1>;
> +       supports-highspeed;
> +       broken-cd;
> +       card-detect-delay = <200>;
> +       samsung,dw-mshc-ciu-div = <3>;
> +       samsung,dw-mshc-sdr-timing = <2 3>;
> +       samsung,dw-mshc-ddr-timing = <1 2>;
> +
> +       slot@0 {
> +               reg = <0>;
> +               bus-width = <8>;
> +       };
> +};
> +
> +&mmc_2 {
> +       status = "okay";
> +       num-slots = <1>;
> +       supports-highspeed;
> +       card-detect-delay = <200>;
> +       samsung,dw-mshc-ciu-div = <3>;
> +       samsung,dw-mshc-sdr-timing = <2 3>;
> +       samsung,dw-mshc-ddr-timing = <1 2>;
> +
> +       slot@0 {
> +               reg = <0>;
> +               bus-width = <4>;
> +               disable-wp;
> +       };
> +};
> +
> +&uart0 {
> +               status = "okay";
> +};
> +
> +&uart1 {
> +               status = "okay";
> +};
> +
> +&uart2 {
> +               status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
> new file mode 100644
> index 0000000..3839c26
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410.dtsi
> @@ -0,0 +1,206 @@
> +/*
> + * SAMSUNG EXYNOS5410 SoC device tree source
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
> + * EXYNOS5410 based board files can include this file and provide
> + * values for board specfic bindings.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/clock/exynos5410.h>
> +
> +/ {
> +       compatible = "samsung,exynos5410", "samsung,exynos5";
> +       interrupt-parent = <&gic>;
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               CPU0: cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x0>;
> +               };
> +
> +               CPU1: cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x1>;
> +               };
> +
> +               CPU2: cpu@2 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x2>;
> +               };
> +
> +               CPU3: cpu@3 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a15";
> +                       reg = <0x3>;
> +               };
> +       };
> +
> +       soc: soc {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +
> +               combiner: interrupt-controller@10440000 {
> +                       compatible = "samsung,exynos4210-combiner";
> +                       #interrupt-cells = <2>;
> +                       interrupt-controller;
> +                       samsung,combiner-nr = <32>;
> +                       reg = <0x10440000 0x1000>;
> +                       interrupts =    <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
> +                                       <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
> +                                       <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
> +                                       <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
> +                                       <0 16 0>, <0 17 0>, <0 18 0>, <0 19 0>,
> +                                       <0 20 0>, <0 21 0>, <0 22 0>, <0 23 0>,
> +                                       <0 24 0>, <0 25 0>, <0 26 0>, <0 27 0>,
> +                                       <0 28 0>, <0 29 0>, <0 30 0>, <0 31 0>;
> +               };
> +
> +               gic: interrupt-controller@10481000 {
> +                       compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";

shouldn't it be just "arm,cortex-a15-gic", as this is your SoC architecture?

Cheers,
Matthias
