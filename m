Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbbAWLRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:17:53 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41619 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbbAWLRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:17:50 -0500
Date: Fri, 23 Jan 2015 11:17:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "Joel.Schopp@amd.com" <Joel.Schopp@amd.com>,
        "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>
Subject: Re: [PATCH v6 1/2] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20150123111723.GE23493@leverpostej>
References: <1422008491-16452-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422008491-16452-2-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150123103636.GA23493@leverpostej>
 <CAAfSe-vQL8gXzNui1wD9_=vp6yGHrEUGQgJOtdNxvt2=AH1Xsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfSe-vQL8gXzNui1wD9_=vp6yGHrEUGQgJOtdNxvt2=AH1Xsg@mail.gmail.com>
Thread-Topic: [PATCH v6 1/2] arm64: dts: Add support for Spreadtrum SC9836
 SoC in dts and Makefile
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:13:29AM +0000, Lyra Zhang wrote:
> On Fri, Jan 23, 2015 at 6:36 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Jan 23, 2015 at 10:21:30AM +0000, Chunyan Zhang wrote:
> >> From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> >>
> >> Adds the device tree support for Spreadtrum SC9836 SoC which is based on
> >> Sharkl64 platform.
> >>
> >> Sharkl64 platform contains the common nodes of Spreadtrum's arm64-based SoCs.
> >>
> >> Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> >> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> >> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> >> ---
> >>  arch/arm64/boot/dts/Makefile                  |    1 +
> >>  arch/arm64/boot/dts/sprd/Makefile             |    5 ++
> >>  arch/arm64/boot/dts/sprd/sc9836-openphone.dts |   49 ++++++++++++++++
> >>  arch/arm64/boot/dts/sprd/sc9836.dtsi          |   74 +++++++++++++++++++++++++
> >>  arch/arm64/boot/dts/sprd/sharkl64.dtsi        |   65 ++++++++++++++++++++++
> >>  5 files changed, 194 insertions(+)
> >>  create mode 100644 arch/arm64/boot/dts/sprd/Makefile
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >>
> >> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> >> index 3b8d427..806a717 100644
> >> --- a/arch/arm64/boot/dts/Makefile
> >> +++ b/arch/arm64/boot/dts/Makefile
> >> @@ -2,6 +2,7 @@ dts-dirs += amd
> >>  dts-dirs += apm
> >>  dts-dirs += arm
> >>  dts-dirs += cavium
> >> +dts-dirs += sprd
> >>
> >>  always               := $(dtb-y)
> >>  subdir-y     := $(dts-dirs)
> >> diff --git a/arch/arm64/boot/dts/sprd/Makefile b/arch/arm64/boot/dts/sprd/Makefile
> >> new file mode 100644
> >> index 0000000..b658c5e
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/sprd/Makefile
> >> @@ -0,0 +1,5 @@
> >> +dtb-$(CONFIG_ARCH_SPRD) += sc9836-openphone.dtb
> >> +
> >> +always               := $(dtb-y)
> >> +subdir-y     := $(dts-dirs)
> >> +clean-files  := *.dtb
> >> diff --git a/arch/arm64/boot/dts/sprd/sc9836-openphone.dts b/arch/arm64/boot/dts/sprd/sc9836-openphone.dts
> >> new file mode 100644
> >> index 0000000..b8a69b2
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/sprd/sc9836-openphone.dts
> >> @@ -0,0 +1,49 @@
> >> +/*
> >> + * Spreadtrum SC9836 openphone board DTS file
> >> + *
> >> + * Copyright (C) 2014, Spreadtrum Communications Inc.
> >> + *
> >> + * This file is licensed under a dual GPLv2 or X11 license.
> >> + */
> >> +
> >> +/dts-v1/;
> >> +
> >> +#include "sc9836.dtsi"
> >> +
> >> +/ {
> >> +     model = "Spreadtrum SC9836 Openphone Board";
> >> +
> >> +     compatible = "sprd,sc9836-openphone", "sprd,sc9836";
> >> +
> >> +     aliases {
> >> +             serial0 = &uart0;
> >> +             serial1 = &uart1;
> >> +             serial2 = &uart2;
> >> +             serial3 = &uart3;
> >> +     };
> >> +
> >> +     memory@80000000 {
> >> +             device_type = "memory";
> >> +             reg = <0 0x80000000 0 0x20000000>;
> >> +     };
> >> +
> >> +     chosen {
> >> +             stdout-path = &uart0;
> >> +     };
> >
> > It would be good to use an explicit configuration here. e.g. have:
> >
> >         chosen {
> >                 stdout-path = "serial0:115200n8";
> >         };
> >
> > Where '115200n8' is replaced by whatever the bootloader leaves the UART
> > configured as on this board.
> >
> > That means you won't need a 'console=' to get nice consistent serial
> > output at boot, and won't be relying on implicit defaults all over the
> > place.
> >
> 
> ok, I've changed and tested pass.
> 
> >> +};
> >> +
> >> +&uart0 {
> >> +     status = "okay";
> >> +};
> >> +
> >> +&uart1 {
> >> +     status = "okay";
> >> +};
> >> +
> >> +&uart2 {
> >> +     status = "okay";
> >> +};
> >> +
> >> +&uart3 {
> >> +     status = "okay";
> >> +};
> >> diff --git a/arch/arm64/boot/dts/sprd/sc9836.dtsi b/arch/arm64/boot/dts/sprd/sc9836.dtsi
> >> new file mode 100644
> >> index 0000000..c646123
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/sprd/sc9836.dtsi
> >> @@ -0,0 +1,74 @@
> >> +/*
> >> + * Spreadtrum SC9836 SoC DTS file
> >> + *
> >> + * Copyright (C) 2014, Spreadtrum Communications Inc.
> >> + *
> >> + * This file is licensed under a dual GPLv2 or X11 license.
> >> + */
> >> +
> >> +#include "sharkl64.dtsi"
> >> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> >> +
> >> +/ {
> >> +     compatible = "sprd,sc9836";
> >> +
> >> +     cpus {
> >> +             #address-cells = <2>;
> >> +             #size-cells = <0>;
> >> +
> >> +             cpu@0 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x0>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@1 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x1>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@2 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x2>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@3 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x3>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +     };
> >> +
> >> +     gic: interrupt-controller@12001000 {
> >> +             compatible = "arm,gic-400";
> >> +             reg = <0 0x12001000 0 0x1000>,
> >> +                   <0 0x12002000 0 0x2000>,
> >> +                   <0 0x12004000 0 0x2000>,
> >> +                   <0 0x12006000 0 0x2000>;
> >> +             #interrupt-cells = <3>;
> >> +             interrupt-controller;
> >> +             interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
> >> +     };
> >> +
> >> +     psci {
> >> +             compatible      = "arm,psci";
> >> +             method          = "smc";
> >> +             cpu_on          = <0xc4000003>;
> >> +             cpu_off         = <0x84000002>;
> >> +             cpu_suspend     = <0xc4000001>;
> >> +     };
> >
> > Given that there are no suspend states in this dts, the cpu_suspend
> > property here could be omitted for now (though I guess it doesn't matter
> > either way).
> >
> >> +
> >> +     timer {
> >> +             compatible = "arm,armv8-timer";
> >> +             interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
> >> +                          <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
> >> +                          <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
> >> +                          <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
> >> +     };
> >> +};
> >> diff --git a/arch/arm64/boot/dts/sprd/sharkl64.dtsi b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >> new file mode 100644
> >> index 0000000..6b4bdc5
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >> @@ -0,0 +1,65 @@
> >> +/*
> >> + * Spreadtrum Sharkl64 platform DTS file
> >> + *
> >> + * Copyright (C) 2014, Spreadtrum Communications Inc.
> >> + *
> >> + * This file is licensed under a dual GPLv2 or X11 license.
> >> + */
> >> +
> >> +/ {
> >> +     interrupt-parent = <&gic>;
> >> +     #address-cells = <2>;
> >> +     #size-cells = <2>;
> >> +
> >> +     soc {
> >> +             compatible = "simple-bus";
> >> +             #address-cells = <2>;
> >> +             #size-cells = <2>;
> >> +             ranges;
> >> +
> >> +             ap-apb {
> >> +                     compatible = "simple-bus";
> >> +                     #address-cells = <2>;
> >> +                     #size-cells = <2>;
> >> +                     ranges;
> >> +
> >> +                     uart0: serial@70000000 {
> >> +                             compatible = "sprd,sc9836-uart";
> >> +                             reg = <0 0x70000000 0 0x100>;
> >> +                             interrupts = <0 2 0xf04>;
> >> +                             clocks = <&clk26mhz>;
> >> +                             status = "disabled";
> >> +                     };
> >> +
> >> +                     uart1: serial@70100000 {
> >> +                             compatible = "sprd,sc9836-uart";
> >> +                             reg = <0 0x70100000 0 0x100>;
> >> +                             interrupts = <0 3 0xf04>;
> >> +                             clocks = <&clk26mhz>;
> >> +                             status = "disabled";
> >> +                     };
> >> +
> >> +                     uart2: serial@70200000 {
> >> +                             compatible = "sprd,sc9836-uart";
> >> +                             reg = <0 0x70200000 0 0x100>;
> >> +                             interrupts = <0 2 0xf04>;
> >> +                             clocks = <&clk26mhz>;
> >> +                             status = "disabled";
> >> +                     };
> >> +
> >> +                     uart3: serial@70300000 {
> >> +                             compatible = "sprd,sc9836-uart";
> >> +                             reg = <0 0x70300000 0 0x100>;
> >> +                             interrupts = <0 3 0xf04>;
> >> +                             clocks = <&clk26mhz>;
> >> +                             status = "disabled";
> >> +                     };
> >> +             };
> >> +     };
> >> +
> >> +     clk26mhz: clk26mhz {
> >> +             compatible = "fixed-clock";
> >> +             #clock-cells = <0>;
> >> +             clock-frequency = <26000000>;
> >> +     };
> >> +};
> >
> > Other than my comments above, this looks fine to me. I assume the UART
> > binding and driver are already queued somewhere else?
> >
> 
> Since the last version patch series must be split for applying.
> I'll send the UART bindings with UART driver soon.
> 
> For this case, can I still add your Acked-by and send these two patch
> to Greg right now?

If the UART patches aren't queued yet then I'd like to take a look at
their next posting first.

Surely these 2 patches (with parts under arch/arm64) should go via
arm-soc?

Thanks,
Mark.
