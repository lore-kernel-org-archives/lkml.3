Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaJJNpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:45:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaJJNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:45:43 -0400
Date: Fri, 10 Oct 2014 14:45:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [RFC 1/4] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
Message-ID: <20141010134534.GC6004@leverpostej>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1411937610-22125-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411937610-22125-2-git-send-email-suravee.suthikulpanit@amd.com>
Thread-Topic: [RFC 1/4] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On Sun, Sep 28, 2014 at 09:53:27PM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Initial revision of device tree for AMD Seattle platform

To check: how is it possible to make use of a DTB generated from this
dts? Can a user update the DTB used by the Seattle firmware?

>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
>  arch/arm64/boot/dts/Makefile                |   1 +
>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 175 ++++++++++++++++++++
>  arch/arm64/boot/dts/amd-seattle.dts         | 245 ++++++++++++++++++++++++++++
>  3 files changed, 421 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
>  create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
>
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index c52bdb0..11cb2e3 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,5 +1,6 @@
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
>
>  targets += dtbs
>  targets += $(dtb-y)
> diff --git a/arch/arm64/boot/dts/amd-seattle-periph.dtsi b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
> new file mode 100644
> index 0000000..e5bcf1c
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
> @@ -0,0 +1,175 @@
> +/*
> + * DTS file for AMD Seattle Peripheral
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +motherboard {
> +       arm,v2m-memory-map = "rs1";
> +       compatible = "arm,vexpress,v2m-p1", "simple-bus";

The v2m stuff above can go. This isn't a versatile express, and we won't
use those properties anyway.

> +       #address-cells = <2>;
> +       #size-cells = <2>;
> +       ranges;
> +
> +       adl3clk_100mhz: clk100mhz_0 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <100000000>;
> +               clock-output-names = "adl3clk_100mhz";
> +       };
> +
> +       ccpclk_375mhz: clk375mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <375000000>;
> +               clock-output-names = "ccpclk_375mhz";
> +       };
> +
> +       sataclk_333mhz: clk333mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <333000000>;
> +               clock-output-names = "sataclk_333mhz";
> +       };
> +
> +       pcieclk_500mhz: clk500mhz_0 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <500000000>;
> +               clock-output-names = "pcieclk_500mhz";
> +       };
> +
> +       dmaclk_500mhz: clk500mhz_1 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <500000000>;
> +               clock-output-names = "dmaclk_500mhz";
> +       };
> +
> +       miscclk_250mhz: clk250mhz_4 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <250000000>;
> +               clock-output-names = "miscclk_250mhz";
> +       };
> +
> +       uartspiclk_100mhz: clk100mhz_1 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <100000000>;
> +               clock-output-names = "uartspiclk_100mhz";
> +       };
> +
> +       dma0: dma@1,0500000 {
> +               compatible = "arm,pl330", "arm,primecell";
> +               reg = <0 0x0500000 0 0x1000>;
> +               interrupts =
> +                       <0 368 4>,
> +                       <0 369 4>,
> +                       <0 370 4>,
> +                       <0 371 4>,
> +                       <0 372 4>,
> +                       <0 373 4>,
> +                       <0 374 4>,
> +                       <0 375 4>;
> +               clocks = <&dmaclk_500mhz>;
> +               clock-names = "apb_pclk";
> +               #dma-cells = <1>;
> +               #stream-id-cells = <32>;

I didn't spot an SMMU, so I think this should go.

> +       };
> +
> +       sata0: sata@1,00300000 {
> +               compatible = "snps,spear-ahci";
> +               reg = <0 0x300000 0 0x800>;
> +               interrupts = <0 355 4>;
> +               clocks = <&sataclk_333mhz>;
> +               clock-names = "apb_pclk";
> +               #stream-id-cells = <32>;

Likewise.

> +               dma-coherent;
> +       };
> +
> +       i2c@1,1000000 {
> +               compatible = "snps,designware-i2c";
> +               reg = <0 0x01000000 0 0x1000>;
> +               interrupts = <0 357 4>;
> +               clocks = <&uartspiclk_100mhz>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       v2m_serial0: uart@1,1010000 {
> +               compatible = "arm,pl011", "arm,primecell";
> +               reg = <0 0x1010000 0 0x1000>;
> +               interrupts = <0 328 4>;
> +               clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
> +               clock-names = "uartclk", "apb_pclk";
> +       };
> +
> +       ssp@1,1020000 {
> +               #gpio-cells = <2>;
> +               compatible = "arm,pl022", "arm,primecell";

Please put the compatible property first in each node.

> +               reg = <0 0x1020000 0 0x1000>;
> +               spi-controller;
> +               interrupts = <0 330 4>;
> +               clocks = <&uartspiclk_100mhz>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       ssp@1,1030000 {
> +               #gpio-cells = <2>;
> +               compatible = "arm,pl022", "arm,primecell";
> +               reg = <0 0x1030000 0 0x1000>;
> +               spi-controller;
> +               interrupts = <0 329 4>;
> +               clocks = <&uartspiclk_100mhz>;
> +               clock-names = "apb_pclk";
> +               num-cs = <1>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               sdcard@1 {
> +                       compatible = "mmc-spi-slot";
> +                       reg = <0>;

The unit-address should match the first reg entry.

> +                       spi-max-frequency = <20000000>;
> +                       pl022,hierarchy = <0>;
> +                       pl022,interface = <0>;
> +                       pl022,com-mode = <0x0>;
> +                       pl022,rx-level-trig = <0>;
> +                       pl022,tx-level-trig = <0>;
> +               };
> +       };
> +
> +       gpio@1,1040000 {
> +               #gpio-cells = <2>;
> +               compatible = "arm,pl061", "arm,primecell";
> +               reg = <0 0x1040000 0 0x1000>;
> +               gpio-controller;
> +               interrupts = <0 359 4>;
> +               clocks = <&uartspiclk_100mhz>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       gpio@1,1050000 {
> +               #gpio-cells = <2>;
> +               compatible = "arm,pl061", "arm,primecell";
> +               reg = <0 0x1050000 0 0x1000>;
> +               gpio-controller;
> +               interrupts = <0 358 4>;
> +               clocks = <&uartspiclk_100mhz>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       timer@1,1060000 {
> +               compatible = "arm,standalone_a5_twd";
> +               reg = <0 0x1060000 0 0x40>;
> +               interrupts =
> +                       <0 378 4>,
> +                       <0 379 4>;
> +       };

This binding does not exist in mainline.

> +
> +       ccp: ccp@1,00100000 {
> +               compatible = "amd,ccp-seattle-v1a";
> +               reg = <0 0x00100000 0 0x10000>;
> +               interrupts = <0 3 4>;
> +               dma-coherent;
> +       };

Nor does this.

> +};
> diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
> new file mode 100644
> index 0000000..3096d1a
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle.dts
> @@ -0,0 +1,245 @@
> +/*
> + * DTS file for AMD Seattle
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +/dts-v1/;
> +
> +/ {
> +       compatible = "amd,seattle";
> +       interrupt-parent = <&gic>;
> +       #address-cells = <2>;
> +       #size-cells = <2>;
> +
> +       chosen {
> +               bootargs = "console=ttyAMA0,115200 earlycon=pl011,0xe1010000";

Please use stdout-path instead.

> +               linux,pci-probe-only;

Why is this necessary?

> +       };
> +
> +       aliases {
> +               serial0 = &v2m_serial0;
> +       };
> +
> +       /* Note: This entry is modified by UEFI */

In what way is this modified?

> +       cpus {
> +               #address-cells = <2>;
> +               #size-cells = <0>;
> +
> +               cpu-map {
> +                       cluster0 {
> +                               core0 {
> +                                       cpu = <&CPU0>;
> +                               };
> +                               core1 {
> +                                       cpu = <&CPU1>;
> +                               };
> +                       };
> +                       cluster1 {
> +                               core0 {
> +                                       cpu = <&CPU2>;
> +                               };
> +                               core1 {
> +                                       cpu = <&CPU3>;
> +                               };
> +                       };
> +                       cluster2 {
> +                               core0 {
> +                                       cpu = <&CPU4>;
> +                               };
> +                               core1 {
> +                                       cpu = <&CPU5>;
> +                               };
> +                       };
> +                       cluster3 {
> +                               core0 {
> +                                       cpu = <&CPU6>;
> +                               };
> +                               core1 {
> +                                       cpu = <&CPU7>;
> +                               };
> +                       };
> +               };
> +               /* Cluster 0 Core 0 */
> +               CPU0: cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,armv8";

Can we have the actual CPU name, please?

> +                       reg = <0x0 0x0000>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0x80 0x30000050>;

Not PSCI?

> +               };
> +
> +               /* Cluster 0 Core 1 */
> +               CPU1: cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,armv8";
> +                       reg = <0x0 0x0001>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0x80 0x30000058>;

At least the release addresses are unique...

> +               };

[...]

> +
> +       /* Note: This entry is modified by UEFI */
> +       memory@8000000000 {
> +               device_type = "memory";
> +               reg = <0x00000080 0x00000000 0x1 0x00000000>; /* 4GB */
> +       };

Why does UEFI modify this? When booted via UEFI we use the UEFI memory
map.

How exactly does UEFI modify this?

> +
> +       gic: interrupt-controller@e1101000 {
> +               compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +               #interrupt-cells = <3>;
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               interrupt-controller;
> +               ranges = <0 0 0 0xe1100000 0 0x100000>;

Please keep this together with #address-cells and #size-cells.

> +               reg = <0x0 0xe1110000 0 0x1000>,  /* gic dist */
> +                     <0x0 0xe112f000 0 0x2000>,  /* gic cpu */
> +                     <0x0 0xe1140000 0 0x10000>, /* gic virtual ic*/
> +                     <0x0 0xe1160000 0 0x10000>; /* gic virtual cpu*/

The comments are confusing, because they don't match the architected
names. I would drop them.

> +               interrupts = <1 8 0xf04>;
> +               v2m0: v2m@0x8000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       arm,msi-base-spi = <64>;
> +                       arm,msi-num-spis = <256>;
> +                       reg = <0x0 0x80000 0 0x1000>;
> +               };
> +       };
> +
> +       timer {
> +               compatible = "arm,armv8-timer";
> +               interrupts = <1 13 0xff01>,
> +                            <1 14 0xff01>,
> +                            <1 11 0xff01>,
> +                            <1 10 0xff01>;
> +       };
> +
> +       pmu {
> +               compatible = "arm,armv8-pmuv3";
> +               interrupts = <0 7 4>,
> +                            <0 8 4>,
> +                            <0 9 4>,
> +                            <0 10 4>,
> +                            <0 11 4>,
> +                            <0 12 4>,
> +                            <0 13 4>,
> +                            <0 14 4>;
> +       };
> +
> +       /* This entry is modified by UEFI */
> +       pcie0: pcie-controller{
> +               compatible = "pci-host-ecam-generic";

I unfortunately don't know enough about this binding to comment. I'll
leave that up to someone familiar with PCIe.

> +               #address-cells = <3>;
> +               #size-cells = <2>;
> +               device_type = "pci";
> +               bus-range = <0 0xff>;
> +               reg = <0 0xf0000000 0 0x10000000>;
> +               dma-coherent;
> +               msi-parent = <&v2m0>;
> +
> +               interrupts =
> +                       <0 320 4>, /* ioc_soc_serr */
> +                       <0 321 4>; /* ioc_soc_sci */
> +
> +               ranges = <
> +                       /* I/O Memory (size=64K) */
> +                       0x01000000 0x00 0xefff0000 0x00 0xefff0000 0x00 0x00010000

However, please bracket list entries individually.

Thanks,
Mark.
