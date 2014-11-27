Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaK0LSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:18:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39391 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbaK0LSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:18:37 -0500
Date: Thu, 27 Nov 2014 11:18:34 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        marc.zyngier@arm.com
Subject: Re: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Message-ID: <20141127111834.GB857@leverpostej>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
Thread-Topic: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:35:13AM +0000, Chanwoo Choi wrote:
> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC
> based on Octal core CPUs (quad Cortex-A57 and quad Cortex-A53).
>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 523 +++++++++++++++
>  2 files changed, 1221 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi

[...]

> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> new file mode 100644
> index 0000000..3d8b576
> --- /dev/null
> +++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> @@ -0,0 +1,523 @@
> +/*
> + * Samsung's Exynos5433 SoC device tree source
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * Samsung's Exynos5433 SoC device nodes are listed in this file. Exynos5433
> + * based board files can include this file and provide values for board specfic
> + * bindings.
> + *
> + * Note: This file does not include device nodes for all the controllers in
> + * Exynos5433 SoC. As device tree coverage for Exynos5433 increases, additional
> + * nodes can be added to this file.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/clock/exynos5433.h>
> +

Just to check: no memory reservations required for any reason?

There also don't appear to be any memory nodes. Typically if that's
filled in by the bootloader/FW we'd have an empty node (or one with a
zero size entry) and a comment regarding the FW.

> +/ {
> +       compatible = "samsung,exynos5433";
> +       #address-cells = <1>;
> +       #size-cells = <1>;

Not two, on both counts? The CPUs can address more than 32 bits.

Is there nothing in the physical address space above 0xffffffff?

[...]

> +       cpus {
> +               #address-cells = <2>;
> +               #size-cells = <0>;
> +
> +               cpu0: cpu@100 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a53", "arm,armv8";
> +                       enable-method = "psci";

While the CPU nodes have enable-methods, I didn't spot a PSCI node
anywhere, so this dts cannot possibly have been used to bring up an SMP
system.

How has this dts been tested?

What PSCI revision have you implemented? Have have you tested it?

I take it from the presence of GICH/GICV in the gic node that CPUs enter
the kernel at EL2?

> +                       reg = <0x0 0x100>;
> +                       clock-frequency = <1050000000>;

What uses this?

> +               };

[...]

> +       soc: soc {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +
> +               fixed-rate-clocks {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       xusbxti: clock@0 {
> +                               compatible = "fixed-clock";
> +                               clock-output-names = "xusbxti";
> +                               #clock-cells = <0>;
> +                       };
> +               };

Get rid of the fixed-rate-clocks container node. It's pointless and
messy. Given you only have one there's no need for the bogus
unit-address either.

> +
> +               cmu_top: clock-controller@0x10030000{

s/@0x/@/ -- a unit-address should not have the leading '0x'. Please
apply that to the rest of the file.

> +                       compatible = "samsung,exynos5433-cmu-top";
> +                       reg = <0x10030000 0x0c04>;
> +                       #clock-cells = <1>;
> +               };

[...]

> +               mct@101c0000 {
> +                       compatible = "samsung,exynos4210-mct";
> +                       reg = <0x101c0000 0x800>;
> +                       interrupts = <0 102 0>, <0 103 0>, <0 104 0>, <0 105 0>,
> +                               <0 106 0>, <0 107 0>, <0 108 0>, <0 109>,
> +                               <0 110 0>, <0 111 0>, <0 112 0>, <0 113 0>;
> +                       clocks = <&cmu_top CLK_FIN_PLL>, <&cmu_peris CLK_PCLK_MCT>;
> +                       clock-names = "fin_pll", "mct";
> +               };

Hase this block had no changes whatsoever since its use in Exynos4210?
Do we not need a "samsung,exynos5433-mct" comaptible string too?

> +
> +               gic:interrupt-controller@11001000 {
> +                       compatible = "arm,cortex-a15-gic";

Given this is multi-cluster, surely this is an external GIC-400, for
which we have a supported compatible string?

So this should at least be:

	compatible = "arm,gic-400", "arm,cortex-a15-gic";

> +                       #interrupt-cells = <3>;
> +                       interrupt-controller;
> +                       reg =   <0x11001000 0x1000>,
> +                               <0x11002000 0x1000>,
> +                               <0x11004000 0x2000>,
> +                               <0x11006000 0x2000>;

As far as I am aware, the GICC size is 8KiB. Regardless of whether we
currently use the second page of registers, they should be described.

> +                       interrupts = <1 9 0xf04>;
> +               };
> +
> +               serial_0: serial@14C10000 {

Nit: Please be consistent with capitalisation of hex. IMO it's better
to leave it all lower-case.

[...]

> +               timer {
> +                       compatible = "arm,armv8-timer";
> +                       interrupts = <1 13 0xff01>,
> +                                    <1 14 0xff01>,
> +                                    <1 11 0xff01>,
> +                                    <1 10 0xff01>;
> +                       clock-frequency = <24000000>;
> +                       use-clocksource-only;
> +                       use-physical-timer;

As Marc said, NAK for these last three properties.

There is no excuse for not setting CNTFRQ_EL0, especially given a PSCI
implementation. The last two properties have never been supported in
mainline, and shouldn't be necessary regardless.

Thanks,
Mark.
