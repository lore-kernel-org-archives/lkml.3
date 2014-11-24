Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbaKXXJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:09:05 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:57451 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKXXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:09:03 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:545b:3079:f9fb:e5f4]
In-Reply-To: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
Date: Mon, 24 Nov 2014 15:09:02 -0800
Message-ID: <CAOesGMik=ZxRXFp4aEf1-zK2OvrZ9duuWWpNKRQPUN_n=T39hw@mail.gmail.com>
Subject: Re: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD Seattle platform
From: Olof Johansson <olof@lixom.net>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

Some comments below.


On Mon, Nov 24, 2014 at 1:51 PM,  <suravee.suthikulpanit@amd.com> wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Initial revision of device tree for AMD Seattle platform.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
> V4 Changes:
>     * Remove unnecessary smb layer and move motherbord to top level
>     * Move include dtsi to top level
>     * Remove apb_pclk from sata0 and i2c
>     * Fix GIC Virtual Maintanance Interrupt from PPI24 (8) to PPI25 (9)
>     * Add 40-bit dma-ranges for motherboard (simple-bus)
>     * Remove dma0 (pl330) entry for now since it only supports 32-bit DMA.
>       It is basically not used at the moment. It would also need SMMU
>       to allow dma remapping to 40-bit DMA range.
>     * Add phandle spi0 and spi1
>     * Hook up gpio0 pin 7 with MMC Card Detection (CD) support.
>     * Changes in pcie0 entry:
>         - Add 40-bit dma-ranges
>         - Remove interrupts property
>         - Add interrupt-map/mask property
>         - Fix PCI I/O range
>         - Merge PCI 32-bit ranges
>         - Merge PCI 64-bit ranges
>
> NOTE: I am not add a new compatible ID for the sata0 as Rob Herring
>       suggested since there is no need at the momement, and I am trying
>       to avoid introducing ID unnecessarily.
>
>  arch/arm64/Kconfig                          |   5 +
>  arch/arm64/boot/dts/Makefile                |   1 +
>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 156 ++++++++++++++++++++++++++++
>  arch/arm64/boot/dts/amd-seattle.dts         |  89 ++++++++++++++++
>  4 files changed, 251 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
>  create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d..ddc0196 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -142,6 +142,11 @@ source "kernel/Kconfig.freezer"
>
>  menu "Platform selection"
>
> +config ARCH_SEATTLE
> +       bool "AMD Seattle SoC Family"
> +       help
> +         This enables support for AMD Seattle SOC Family
> +
>  config ARCH_THUNDER
>         bool "Cavium Inc. Thunder SoC Family"
>         help
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index f8001a6..604af09 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,3 +1,4 @@
> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb

For 3.19, we're moving all device tree files on arm64 int per-vendor
subdirectories.

Can you please prepare this patch to go on top of linux-next (or
arm-soc for-next) such that it adds this file in the same place?

(Alternatively, we can move it when applying, it's not a huge deal).


>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> diff --git a/arch/arm64/boot/dts/amd-seattle-periph.dtsi b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
> new file mode 100644
> index 0000000..77f565b
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
> @@ -0,0 +1,156 @@
> +/*
> + * DTS file for AMD Seattle Peripheral
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +/ {
> +       motherboard {
> +               compatible = "simple-bus";

I'm not sure I understand this abstraction. You have a motherboard
device node, under which you have things like the pl011 UART and SATA
-- while those blocks really are part of SoC, aren't they? After all,
you have the pci-e controller as part of the dts file and not the
dtsi.

Unless you have some underlying motive, it would make more sense to
keep these at the same toplevel since the "motherboard" doesn't seem
to be part of the hardware topology as described.


> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               ranges = <0 0 0 0xe0000000 0 0x01300000>;
> +
> +               /* DDR range is 40-bit addressing */
> +               dma-ranges = <0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
> +
> +               adl3clk_100mhz: clk100mhz_0 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <100000000>;
> +                       clock-output-names = "adl3clk_100mhz";
> +               };
> +
> +               ccpclk_375mhz: clk375mhz {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <375000000>;
> +                       clock-output-names = "ccpclk_375mhz";
> +               };
> +
> +               sataclk_333mhz: clk333mhz {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <333000000>;
> +                       clock-output-names = "sataclk_333mhz";
> +               };
> +
> +               pcieclk_500mhz: clk500mhz_0 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <500000000>;
> +                       clock-output-names = "pcieclk_500mhz";
> +               };
> +
> +               dmaclk_500mhz: clk500mhz_1 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <500000000>;
> +                       clock-output-names = "dmaclk_500mhz";
> +               };
> +
> +               miscclk_250mhz: clk250mhz_4 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <250000000>;
> +                       clock-output-names = "miscclk_250mhz";
> +               };
> +
> +               uartspiclk_100mhz: clk100mhz_1 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <100000000>;
> +                       clock-output-names = "uartspiclk_100mhz";
> +               };
> +
> +               sata0: sata@00300000 {
> +                       compatible = "snps,dwc-ahci";
> +                       reg = <0 0x300000 0 0x800>;
> +                       interrupts = <0 355 4>;
> +                       clocks = <&sataclk_333mhz>;
> +                       dma-coherent;
> +               };
> +
> +               i2c@1000000 {
> +                       compatible = "snps,designware-i2c";
> +                       reg = <0 0x01000000 0 0x1000>;
> +                       interrupts = <0 357 4>;
> +                       clocks = <&uartspiclk_100mhz>;
> +               };
> +
> +               serial0: serial@1010000 {
> +                       compatible = "arm,pl011", "arm,primecell";
> +                       reg = <0 0x1010000 0 0x1000>;
> +                       interrupts = <0 328 4>;
> +                       clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
> +                       clock-names = "uartclk", "apb_pclk";
> +               };
> +
> +               spi0: ssp@1020000 {
> +                       compatible = "arm,pl022", "arm,primecell";
> +                       #gpio-cells = <2>;
> +                       reg = <0 0x1020000 0 0x1000>;
> +                       spi-controller;
> +                       interrupts = <0 330 4>;
> +                       clocks = <&uartspiclk_100mhz>;
> +                       clock-names = "apb_pclk";
> +               };
> +
> +               spi1: ssp@1030000 {
> +                       compatible = "arm,pl022", "arm,primecell";
> +                       #gpio-cells = <2>;
> +                       reg = <0 0x1030000 0 0x1000>;
> +                       spi-controller;
> +                       interrupts = <0 329 4>;
> +                       clocks = <&uartspiclk_100mhz>;
> +                       clock-names = "apb_pclk";
> +                       num-cs = <1>;
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       sdcard@0 {
> +                               compatible = "mmc-spi-slot";
> +                               reg = <0>;
> +                               spi-max-frequency = <20000000>;
> +                               voltage-ranges = <3200 3400>;
> +                               gpios = <&gpio0 7 0>;
> +                               interrupt-parent = <&gpio0>;
> +                               interrupts = <7 3>;
> +                               pl022,hierarchy = <0>;
> +                               pl022,interface = <0>;
> +                               pl022,com-mode = <0x0>;
> +                               pl022,rx-level-trig = <0>;
> +                               pl022,tx-level-trig = <0>;
> +                       };
> +               };
> +
> +               gpio0: gpio@1040000 {
> +                       compatible = "arm,pl061", "arm,primecell";
> +                       #gpio-cells = <2>;
> +                       reg = <0 0x1040000 0 0x1000>;
> +                       gpio-controller;
> +                       interrupts = <0 359 4>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
> +                       clocks = <&uartspiclk_100mhz>;
> +                       clock-names = "apb_pclk";
> +               };
> +
> +               gpio1: gpio@1050000 {
> +                       compatible = "arm,pl061", "arm,primecell";
> +                       #gpio-cells = <2>;
> +                       reg = <0 0x1050000 0 0x1000>;
> +                       gpio-controller;
> +                       interrupts = <0 358 4>;
> +                       clocks = <&uartspiclk_100mhz>;
> +                       clock-names = "apb_pclk";
> +               };
> +
> +               ccp: ccp@00100000 {
> +                       compatible = "amd,ccp-seattle-v1a";
> +                       reg = <0 0x00100000 0 0x10000>;
> +                       interrupts = <0 3 4>;
> +                       dma-coherent;
> +               };
> +       };
> +};
> diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
> new file mode 100644
> index 0000000..d5fc482
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle.dts
> @@ -0,0 +1,89 @@
> +/*
> + * DTS file for AMD Seattle
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +/dts-v1/;
> +
> +/include/ "amd-seattle-periph.dtsi"
> +
> +/ {
> +       compatible = "amd,seattle";
> +       interrupt-parent = <&gic>;
> +       #address-cells = <2>;
> +       #size-cells = <2>;

So is this the dts for a specific board? Isn't Seattle the SoC? You
might want to have a different topmost compatible here to identify the
board. You should also have a "model" property here to describe what
the hardware is.

(I'm guessing it's really the development board for Seattle, correct?)

> +
> +       chosen {
> +               stdout-path = &serial0;
> +               linux,pci-probe-only;
> +       };
> +
> +       gic: interrupt-controller@e1101000 {
> +               compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +               interrupt-controller;
> +               #interrupt-cells = <3>;
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               reg = <0x0 0xe1110000 0 0x1000>,
> +                     <0x0 0xe112f000 0 0x2000>,
> +                     <0x0 0xe1140000 0 0x10000>,
> +                     <0x0 0xe1160000 0 0x10000>;
> +               interrupts = <1 9 0xf04>;
> +               ranges;
> +               v2m0: v2m@e1180000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       arm,msi-base-spi = <64>;
> +                       arm,msi-num-spis = <256>;
> +                       reg = <0x0 0xe1180000 0 0x1000>;
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
> +       pcie0: pcie-controller {
> +               compatible = "pci-host-ecam-generic";

The controller itself should likely go in the SoC dtsi, and only
per-board additional attributes should go here.

It's also common to add a status = "disabled" in the dtsi, and
overriding in the per-system dts with status = "okay" for those IP
blocks that are actually useful on a particular platform.

So, for example, if the SoC has SATA, but a particular board does not,
then you wouldn't enable it in the dts.

Also, if you use labels for the nodes in the dts, then you can do a
flat-format dts where you don't have to exactly duplicate the same
hierarchy of nodes to override a property (you're already using
labels). I.e. in this case you could then do (for a board that does
use sata):

&sata0 {
        status = "okay";
};

in the dts (this would go at the top level of the file, not nested
under other nodes).


> +               #address-cells = <3>;
> +               #size-cells = <2>;
> +               #interrupt-cells = <1>;
> +               device_type = "pci";
> +               bus-range = <0 0xff>;
> +               reg = <0 0xf0000000 0 0x10000000>;
> +               msi-parent = <&v2m0>;
> +
> +               interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
> +               interrupt-map = <0x1000 0x0 0x0 0x1 &gic 0x0 0x0 0x0 0x120 0x1>,
> +                               <0x1000 0x0 0x0 0x2 &gic 0x0 0x0 0x0 0x121 0x1>,
> +                               <0x1000 0x0 0x0 0x3 &gic 0x0 0x0 0x0 0x122 0x1>,
> +                               <0x1000 0x0 0x0 0x4 &gic 0x0 0x0 0x0 0x123 0x1>;
> +
> +               dma-coherent;
> +               dma-ranges = <0x43000000 0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
> +               ranges =
> +                       /* I/O Memory (size=64K) */
> +                       <0x01000000 0x00 0x00000000 0x00 0xefff0000 0x00 0x00010000>,
> +                       /* 32-bit MMIO (size=2G) */
> +                       <0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x80000000>,
> +                       /* 64-bit MMIO (size= 124G) */
> +                       <0x03000000 0x01 0x00000000 0x01 0x00000000 0x7f 0x00000000>;
> +       };
> +};


-Olof
