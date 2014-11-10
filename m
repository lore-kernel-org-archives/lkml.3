Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaKJRnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:43:10 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41953 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaKJRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:43:08 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8979:aa8b:9dc7:1343]
In-Reply-To: <1415618875-8469-3-git-send-email-Liviu.Dudau@arm.com>
References: <1415618875-8469-1-git-send-email-Liviu.Dudau@arm.com>
	<1415618875-8469-3-git-send-email-Liviu.Dudau@arm.com>
Date: Mon, 10 Nov 2014 09:42:59 -0800
Message-ID: <CAOesGMhNcT4xoKaMgvihk3Lc6XWWiaKeRNt_C04dV4ZSAwjZQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: Add Juno SoC device tree.
From: Olof Johansson <olof@lixom.net>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nice to see this posted! Thanks for doing so.

On Mon, Nov 10, 2014 at 3:27 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Care to give a brief patch description?

> ---
>  arch/arm64/boot/dts/Makefile |   2 +-
>  arch/arm64/boot/dts/juno.dts | 374 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 375 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/juno.dts
>
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index f8001a6..0100eca 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,5 +1,5 @@
>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
> -dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
> +dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb juno.dtb

We've applied the series that creates subdirectories per vendor, so
this won't apply. Care to respin on top of our next/cleanup branch?

>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>
>  targets += dtbs
> diff --git a/arch/arm64/boot/dts/juno.dts b/arch/arm64/boot/dts/juno.dts
> new file mode 100644
> index 0000000..7f998de
> --- /dev/null
> +++ b/arch/arm64/boot/dts/juno.dts
> @@ -0,0 +1,374 @@
> +/*
> + * ARM Ltd. Juno Plaform
> + *
> + */
> +
> +/dts-v1/;
> +
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +/ {
> +       model = "Juno";

This could probably be a bit more descriptive.

> +       compatible = "arm,juno", "arm,vexpress";
> +       interrupt-parent = <&gic>;
> +       #address-cells = <2>;
> +       #size-cells = <2>;
> +
> +       aliases {
> +               serial0 = &soc_uart0;
> +       };
> +
> +       cpus {
> +               #address-cells = <2>;
> +               #size-cells = <0>;
> +
> +               A53_0:cpu@100 {
> +                       compatible = "arm,cortex-a53","arm,armv8";
> +                       reg = <0x0 0x100>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };
> +
> +               A53_1:cpu@101 {
> +                       compatible = "arm,cortex-a53","arm,armv8";
> +                       reg = <0x0 0x101>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };
> +
> +               A53_2:cpu@102 {
> +                       compatible = "arm,cortex-a53","arm,armv8";
> +                       reg = <0x0 0x102>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };
> +
> +               A53_3:cpu@103 {
> +                       compatible = "arm,cortex-a53","arm,armv8";
> +                       reg = <0x0 0x103>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };
> +
> +               A57_0:cpu@0 {
> +                       compatible = "arm,cortex-a57","arm,armv8";
> +                       reg = <0x0 0x0>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };
> +
> +               A57_1:cpu@1 {
> +                       compatible = "arm,cortex-a57","arm,armv8";
> +                       reg = <0x0 0x1>;
> +                       device_type = "cpu";
> +                       enable-method = "psci";
> +               };

These cpus are not ordered by reg, they probably should be (i.e. 57s
before 53s).

> +       };
> +
> +       memory@80000000 {
> +               device_type = "memory";
> +               /* last 16MB of the first memory area is reserved for secure world use by firmware */
> +               reg = <0x00000000 0x80000000 0x0 0x7f000000>,
> +                     <0x00000008 0x80000000 0x1 0x80000000>;
> +       };
> +
> +       gic: interrupt-controller@2c001000 {
> +               compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +               reg = <0x0 0x2c010000 0 0x1000>,
> +                     <0x0 0x2c02f000 0 0x2000>,
> +                     <0x0 0x2c04f000 0 0x2000>,
> +                     <0x0 0x2c06f000 0 0x2000>;
> +               #address-cells = <0>;
> +               #interrupt-cells = <3>;
> +               interrupt-controller;
> +               interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>;
> +       };
> +
> +       timer {
> +               compatible = "arm,armv8-timer";
> +               interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
> +       };
> +
> +       pmu {
> +               compatible = "arm,armv8-pmuv3";
> +               interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 02 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 06 IRQ_TYPE_LEVEL_HIGH>;
> +       };
> +
> +       psci {
> +               compatible = "arm,psci-0.2";
> +               method = "smc";
> +       };

This dt is just a pile of nodes in a flat directory today. You're not
the first to add psci at toplevel, but it'd be nice to do some sort of
structure for this at some point.

Same for the timer and pmu nodes, they should probably go somewhere
else than the top.

> +
> +       /* SoC fixed clocks */
> +       soc_uartclk: refclk72738khz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <7273800>;
> +               clock-output-names = "juno:uartclk";
> +       };
> +
> +       soc_usb48mhz: clk48mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <48000000>;
> +               clock-output-names = "clk48mhz";
> +       };
> +
> +       soc_smc50mhz: clk50mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <50000000>;
> +               clock-output-names = "smc_clk";
> +       };
> +
> +       soc_refclk100mhz: refclk100mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <100000000>;
> +               clock-output-names = "apb_pclk";
> +       };
> +
> +       soc_faxiclk: refclk533mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <533000000>;
> +               clock-output-names = "faxi_clk";
> +       };
> +
> +       mb_eth25mhz: clk25mhz {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <25000000>;
> +               clock-output-names = "ethclk25mhz";
> +       };
> +
> +       memory-controller@7ffd0000 {
> +               compatible = "arm,pl354", "arm,primecell";
> +               reg = <0 0x7ffd0000 0 0x1000>;
> +               interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&soc_smc50mhz>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       dma0: dma@7ff00000 {

We're trying to encourate DT contents to be sorted per unit address /
reg, to cause fewer conflicts when new stuff is added. Care to reorder
the devices based on that?


> +               compatible = "arm,pl330", "arm,primecell";
> +               reg = <0x0 0x7ff00000 0 0x1000>;
> +               #dma-cells = <1>;
> +               #dma-channels = <8>;
> +               #dma-requests = <32>;
> +               interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&soc_faxiclk>;
> +               clock-names = "apb_pclk";
> +       };
> +
> +       soc_uart0: uart@7ff80000 {
> +               compatible = "arm,pl011", "arm,primecell";
> +               reg = <0x0 0x7ff80000 0x0 0x1000>;
> +               interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&soc_uartclk>, <&soc_refclk100mhz>;
> +               clock-names = "uartclk", "apb_pclk";
> +       };
> +
> +       ulpi_phy: phy@0 {
> +               compatible = "phy-ulpi-generic";
> +               reg = <0x0 0x94 0x0 0x4>;
> +               phy-id = <0>;
> +       };

phy@0? Hmm. Doesn't seem to belong in the same address space as
everything else here.


> +
> +       ehci@7ffc0000 {
> +               compatible = "generic-ehci";
> +               reg = <0x0 0x7ffc0000 0x0 0x10000>;
> +               interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&soc_usb48mhz>;
> +               phys = <&ulpi_phy>;
> +               phy-names = "usb_ulpi";
> +       };
> +
> +       ohci@7ffb0000 {
> +               compatible = "generic-ohci";
> +               reg = <0x0 0x7ffb0000 0x0 0x10000>;
> +               interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&soc_usb48mhz>;
> +               phys = <&ulpi_phy>;
> +               phy-names = "usb_ulpi";
> +       };
> +
> +       i2c@7ffa0000 {
> +               compatible = "snps,designware-i2c";
> +               reg = <0x0 0x7ffa0000 0x0 0x1000>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
> +               clock-frequency = <400000>;
> +               i2c-sda-hold-time-ns = <500>;
> +               clocks = <&soc_smc50mhz>;
> +
> +               dvi0: dvi-transmitter@70 {
> +                       compatible = "nxp,tda998x";
> +                       reg = <0x70>;
> +               };
> +
> +               dvi1: dvi-transmitter@71 {
> +                       compatible = "nxp,tda998x";
> +                       reg = <0x71>;
> +               };
> +       };
> +
> +       smb {
> +               compatible = "simple-bus";
> +               #address-cells = <2>;
> +               #size-cells = <1>;
> +               ranges = <0 0 0 0x08000000 0x04000000>,
> +                        <1 0 0 0x14000000 0x04000000>,
> +                        <2 0 0 0x18000000 0x04000000>,
> +                        <3 0 0 0x1c000000 0x04000000>,
> +                        <4 0 0 0x0c000000 0x04000000>,
> +                        <5 0 0 0x10000000 0x04000000>;
> +
> +               #interrupt-cells = <1>;
> +               interrupt-map-mask = <0 0 15>;
> +               interrupt-map = <0 0  0 &gic 0  68 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  1 &gic 0  69 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  2 &gic 0  70 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  3 &gic 0 160 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  4 &gic 0 161 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  5 &gic 0 162 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  6 &gic 0 163 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  7 &gic 0 164 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  8 &gic 0 165 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0  9 &gic 0 166 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0 10 &gic 0 167 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0 11 &gic 0 168 IRQ_TYPE_LEVEL_HIGH>,
> +                               <0 0 12 &gic 0 169 IRQ_TYPE_LEVEL_HIGH>;
> +
> +               mb_clk24mhz: clk24mhz {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <24000000>;
> +                       clock-output-names = "juno_mb:clk24mhz";
> +               };
> +
> +               motherboard {
> +                       compatible = "arm,vexpress,v2p-p1", "simple-bus";
> +                       #address-cells = <2>;  /* SMB chipselect number and offset */
> +                       #size-cells = <1>;
> +                       #interrupt-cells = <1>;
> +                       ranges;
> +                       model = "V2M-Juno";
> +                       arm,hbi = <0x252>;
> +                       arm,vexpress,site = <0>;
> +                       arm,v2m-memory-map = "rs1";
> +
> +                       mb_fixed_3v3: fixedregulator@0 {
> +                               compatible = "regulator-fixed";
> +                               regulator-name = "MCC_SB_3V3";
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ethernet@2,00000000 {
> +                               compatible = "smsc,lan9118", "smsc,lan9115";
> +                               reg = <2 0x00000000 0x10000>;
> +                               interrupts = <3>;
> +                               phy-mode = "mii";
> +                               reg-io-width = <4>;
> +                               smsc,irq-active-high;
> +                               smsc,irq-push-pull;
> +                               clocks = <&mb_eth25mhz>;
> +                               vdd33a-supply = <&mb_fixed_3v3>;
> +                               vddvario-supply = <&mb_fixed_3v3>;
> +                       };
> +
> +                       usb@5,00000000 {
> +                               compatible = "nxp,usb-isp1763";
> +                               reg = <5 0x00000000 0x20000>;
> +                               bus-width = <16>;
> +                               interrupts = <4>;
> +                       };
> +
> +                       iofpga@3,00000000 {
> +                               compatible = "arm,amba-bus", "simple-bus";
> +                               #address-cells = <1>;
> +                               #size-cells = <1>;
> +                               ranges = <0 3 0 0x200000>;
> +
> +                               mmci@050000 {
> +                                       compatible = "arm,pl180", "arm,primecell";
> +                                       reg = <0x050000 0x1000>;
> +                                       interrupts = <5>;
> +                                       /* cd-gpios = <&v2m_mmc_gpios 0 0>;
> +                                       wp-gpios = <&v2m_mmc_gpios 1 0>; */
> +                                       max-frequency = <12000000>;
> +                                       vmmc-supply = <&mb_fixed_3v3>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "mclk", "apb_pclk";
> +                               };
> +
> +                               kmi@060000 {
> +                                       compatible = "arm,pl050", "arm,primecell";
> +                                       reg = <0x060000 0x1000>;
> +                                       interrupts = <8>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "KMIREFCLK", "apb_pclk";
> +                               };
> +
> +                               kmi@070000 {
> +                                       compatible = "arm,pl050", "arm,primecell";
> +                                       reg = <0x070000 0x1000>;
> +                                       interrupts = <8>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "KMIREFCLK", "apb_pclk";
> +                               };
> +
> +                               wdt@0f0000 {
> +                                       compatible = "arm,sp805", "arm,primecell";
> +                                       reg = <0x0f0000 0x10000>;
> +                                       interrupts = <7>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "wdogclk", "apb_pclk";
> +                               };
> +
> +                               v2m_timer01: timer@110000 {
> +                                       compatible = "arm,sp804", "arm,primecell";
> +                                       reg = <0x110000 0x10000>;
> +                                       interrupts = <9>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "timclken1", "apb_pclk";
> +                               };
> +
> +                               v2m_timer23: timer@120000 {
> +                                       compatible = "arm,sp804", "arm,primecell";
> +                                       reg = <0x120000 0x10000>;
> +                                       interrupts = <9>;
> +                                       clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
> +                                       clock-names = "timclken1", "apb_pclk";
> +                               };
> +
> +                               rtc@170000 {
> +                                       compatible = "arm,pl031", "arm,primecell";
> +                                       reg = <0x170000 0x10000>;
> +                                       interrupts = <0>;
> +                                       clocks = <&soc_smc50mhz>;
> +                                       clock-names = "apb_pclk";
> +                               };
> +                       };
> +               };
> +       };
> +};
> --
> 2.1.3
>
