Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LQX3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:29:24 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37650 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3LQX3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <1387294714-12872-3-git-send-email-jonas.jensen@gmail.com>
References: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
	<1387294714-12872-3-git-send-email-jonas.jensen@gmail.com>
Date: Wed, 18 Dec 2013 09:29:18 +1000
X-Google-Sender-Auth: 64zFxywC769YcXSpTOtEAtJel4Q
Message-ID: <CAEgOgz7kqU-Z6cQk8kiMBiNs=9coOVq-6it1eKEiN62wKXcsZg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] ARM: mach-moxart: add MOXA ART SoC device tree files
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>, linux@roeck-us.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 1:38 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> Add a generic (dtsi) include file for MOXA ART SoCs.
>
> Also add a file for UC-7112-LX.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/moxart.txt |  12 ++
>  arch/arm/boot/dts/Makefile                       |   1 +
>  arch/arm/boot/dts/moxart-uc7112lx.dts            |  93 +++++++++++++
>  arch/arm/boot/dts/moxart.dtsi                    | 167 +++++++++++++++++++++++
>  4 files changed, 273 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
>  create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
>  create mode 100644 arch/arm/boot/dts/moxart.dtsi
>
> diff --git a/Documentation/devicetree/bindings/arm/moxart.txt b/Documentation/devicetree/bindings/arm/moxart.txt
> new file mode 100644
> index 0000000..11087ed
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/moxart.txt
> @@ -0,0 +1,12 @@
> +MOXA ART device tree bindings
> +
> +Boards with the MOXA ART SoC shall have the following properties:
> +
> +Required root node property:
> +
> +compatible = "moxa,moxart";
> +
> +Boards:
> +
> +- UC-7112-LX: embedded computer
> +  compatible = "moxa,moxart-uc-7112-lx", "moxa,moxart"
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index c55a22d..ae3d7db 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -319,6 +319,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
>         zynq-zc706.dtb \
>         zynq-zed.dtb
> +dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
>
>  targets += dtbs
>  targets += $(dtb-y)
> diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
> new file mode 100644
> index 0000000..0e037c1
> --- /dev/null
> +++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
> @@ -0,0 +1,93 @@
> +/* moxart-uc7112lx.dts - Device Tree file for MOXA UC-7112-LX
> + *
> + * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +/dts-v1/;
> +/include/ "moxart.dtsi"
> +
> +/ {
> +       model = "MOXA UC-7112-LX";
> +       compatible = "moxa,moxart-uc-7112-lx", "moxa,moxart";
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x0 0x2000000>;
> +       };
> +
> +       flash@80000000,0 {
> +               compatible = "numonyx,js28f128", "cfi-flash";
> +               reg = <0x80000000 0x1000000>;
> +               bank-width = <2>;
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               partition@0 {
> +                       label = "bootloader";
> +                       reg = <0x0 0x40000>;
> +               };
> +               partition@40000 {
> +                       label = "linux kernel";
> +                       reg = <0x40000 0x1C0000>;
> +               };
> +               partition@200000 {
> +                       label = "root filesystem";
> +                       reg = <0x200000 0x800000>;
> +               };
> +               partition@a00000 {
> +                       label = "user filesystem";
> +                       reg = <0xa00000 0x600000>;
> +               };
> +       };
> +
> +       leds {
> +               compatible = "gpio-leds";
> +               user-led {
> +                       label = "ready-led";
> +                       gpios = <&gpio 27 0x1>;
> +                       default-state = "on";
> +                       linux,default-trigger = "default-on";
> +               };
> +       };
> +
> +       gpio_keys_polled {
> +               compatible = "gpio-keys-polled";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               poll-interval = <500>;
> +               button@25 {
> +                       label = "GPIO Reset";
> +                       linux,code = <116>;
> +                       gpios = <&gpio 25 1>;
> +               };
> +       };
> +
> +       chosen {
> +               bootargs = "console=ttyS0,115200n8 earlyprintk root=/dev/mmcblk0p1 rw rootwait";
> +       };
> +};
> +
> +&sdhci {
> +       status = "okay";
> +};
> +
> +&mdio0 {
> +       status = "okay";
> +};
> +
> +&mdio1 {
> +       status = "okay";
> +};
> +
> +&mac0 {
> +       status = "okay";
> +};
> +
> +&mac1 {
> +       status = "okay";
> +};
> +
> +&uart0 {
> +       status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
> new file mode 100644
> index 0000000..76114e0
> --- /dev/null
> +++ b/arch/arm/boot/dts/moxart.dtsi
> @@ -0,0 +1,167 @@
> +/* moxart.dtsi - Device Tree Include file for MOXA ART family SoC
> + *
> + * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +       compatible = "moxa,moxart";
> +       model = "MOXART";
> +       interrupt-parent = <&intc>;
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "faraday,fa526";
> +                       reg = <0>;
> +               };
> +       };
> +
> +       clocks {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               ref12: ref12M {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <12000000>;

Crystal board level?

> +               };
> +       };
> +
> +       soc {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               reg = <0x90000000 0x10000000>;
> +               ranges;
> +
> +               intc: interrupt-controller@98800000 {
> +                       compatible = "moxa,moxart-ic";
> +                       reg = <0x98800000 0x38>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
> +                       interrupt-mask = <0x00080000>;
> +               };
> +
> +               clk_pll: clk_pll@98100000 {
> +                       compatible = "moxa,moxart-pll-clock";
> +                       #clock-cells = <0>;
> +                       reg = <0x98100000 0x34>;
> +                       clocks = <&ref12>;
> +               };
> +
> +               clk_apb: clk_apb@98100000 {
> +                       compatible = "moxa,moxart-apb-clock";
> +                       #clock-cells = <0>;
> +                       reg = <0x98100000 0x34>;
> +                       clocks = <&clk_pll>;
> +               };
> +
> +               timer: timer@98400000 {
> +                       compatible = "moxa,moxart-timer";
> +                       reg = <0x98400000 0x42>;
> +                       interrupts = <19 1>;
> +                       clocks = <&clk_apb>;
> +               };
> +
> +               gpio: gpio@98700000 {
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +                       compatible = "moxa,moxart-gpio";
> +                       reg = <0x98700000 0xC>;
> +               };
> +
> +               rtc: rtc {
> +                       compatible = "moxa,moxart-rtc";
> +                       gpio-rtc-sclk = <&gpio 5 0>;
> +                       gpio-rtc-data = <&gpio 6 0>;
> +                       gpio-rtc-reset = <&gpio 7 0>;
> +               };
> +
> +               dma: dma@90500000 {
> +                       compatible = "moxa,moxart-dma";
> +                       reg = <0x90500080 0x40>;
> +                       interrupts = <24 0>;
> +                       #dma-cells = <1>;
> +               };
> +
> +               watchdog: watchdog@98500000 {
> +                       compatible = "moxa,moxart-watchdog";
> +                       reg = <0x98500000 0x10>;
> +                       clocks = <&clk_apb>;
> +               };
> +
> +               sdhci: sdhci@98e00000 {
> +                       compatible = "moxa,moxart-sdhci";
> +                       reg = <0x98e00000 0x5C>;
> +                       interrupts = <5 0>;
> +                       clocks = <&clk_apb>;
> +                       dmas =  <&dma 5>,
> +                               <&dma 5>;
> +                       dma-names = "tx", "rx";
> +                       status = "disabled";
> +               };
> +
> +               mdio0: mdio@90900090 {
> +                       compatible = "moxa,moxart-mdio";
> +                       reg = <0x90900090 0x8>;
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       status = "disabled";
> +
> +                       ethphy0: ethernet-phy@1 {
> +                               device_type = "ethernet-phy";
> +                               compatible = "moxa,moxart-rtl8201cp", "ethernet-phy-ieee802.3-c22";
> +                               reg = <1>;
> +                       };
> +               };
> +
> +               mdio1: mdio@92000090 {
> +                       compatible = "moxa,moxart-mdio";
> +                       reg = <0x92000090 0x8>;
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       status = "disabled";
> +
> +                       ethphy1: ethernet-phy@1 {
> +                               device_type = "ethernet-phy";
> +                               compatible = "moxa,moxart-rtl8201cp", "ethernet-phy-ieee802.3-c22";
> +                               reg = <1>;
> +                       };

Are the phys board or SoC level?

> +               };
> +
> +               mac0: mac@90900000 {
> +                       compatible = "moxa,moxart-mac";
> +                       reg = <0x90900000 0x90>;
> +                       interrupts = <25 0>;
> +                       phy-handle = <&ethphy0>;
> +                       phy-mode = "mii";

If the IP supports multiple PHYs of different external connection
schemes then the phy connectivity should got back to board level. If
not:

Reviewed-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

I don't know much about arm/mach- and Kconfig, so I'll sit out the
review of  P1.

Regards,
Peter

> +                       status = "disabled";
> +               };
> +
> +               mac1: mac@92000000 {
> +                       compatible = "moxa,moxart-mac";
> +                       reg = <0x92000000 0x90>;
> +                       interrupts = <27 0>;
> +                       phy-handle = <&ethphy1>;
> +                       phy-mode = "mii";
> +                       status = "disabled";
> +               };
> +
> +               uart0: uart@98200000 {
> +                       compatible = "ns16550a";
> +                       reg = <0x98200000 0x20>;
> +                       interrupts = <31 8>;
> +                       reg-shift = <2>;
> +                       reg-io-width = <4>;
> +                       clock-frequency = <14745600>;
> +                       status = "disabled";
> +               };
> +       };
> +};
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
