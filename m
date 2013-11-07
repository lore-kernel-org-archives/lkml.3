Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3KGFuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:50:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25360 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab3KGFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:50:35 -0500
Date: Thu, 7 Nov 2013 13:48:02 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 8/9] ARM: add Armada 1500-mini and Chromecast device
 tree files
Message-ID: <20131107134802.2234bff1@xhacker>
In-Reply-To: <1383661723-17956-9-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_02:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 06:28:42 -0800
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> This adds very basic device tree files for the Marvell Armada
> 1500-mini SoC (Berlin BG2CD) and the Google Chromecast. Currently,
> SoC only has nodes for cpu, some clocks, l2 cache controller, local
> timer, apb timers, uart, and interrupt controllers.
> The Google Chromecast is a consumer device comprising the Armada
> 1500-mini SoC above.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v3:
> - initial patch
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Rob Landley <rob@landley.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/Makefile                        |    3 +-
>  arch/arm/boot/dts/berlin2cd-google-chromecast.dts |   29 +++
>  arch/arm/boot/dts/berlin2cd.dtsi                  |  212
> +++++++++++++++++++++ 3 files changed, 243 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/berlin2cd-google-chromecast.dts
>  create mode 100644 arch/arm/boot/dts/berlin2cd.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index c9c1a6c..dac733f 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -47,7 +47,8 @@ dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>  dtb-$(CONFIG_ARCH_BCM) += bcm11351-brt.dtb \
>         bcm28155-ap.dtb
>  dtb-$(CONFIG_ARCH_BERLIN) += \
> -       berlin2-sony-nsz-gs7.dtb
> +       berlin2-sony-nsz-gs7.dtb \
> +       berlin2cd-google-chromecast.dtb
>  dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>         da850-evm.dtb
>  dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
> diff --git a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts new file mode 100644
> index 0000000..bcd81ff
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> @@ -0,0 +1,29 @@
> +/*
> + * Device Tree file for Google Chromecast
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +/dts-v1/;
> +
> +#include "berlin2cd.dtsi"
> +
> +/ {
> +       model = "Google Chromecast";
> +       compatible = "google,chromecast", "marvell,berlin2cd",
> "marvell,berlin"; +
> +       chosen {
> +               bootargs = "console=ttyS0,115200 earlyprintk";
> +       };
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x00000000 0x20000000>; /* 512 MB */
> +       };
> +};
> +
> +&uart0 { status = "okay"; };
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi
> b/arch/arm/boot/dts/berlin2cd.dtsi new file mode 100644
> index 0000000..40d1bed
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -0,0 +1,212 @@
> +/*
> + * Device Tree Include file for Marvell Armada 1500-mini (Berlin BG2CD) SoC
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * based on GPL'ed 2.6 kernel sources
> + *  (c) Marvell International Ltd.
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +/ {
> +       model = "Marvell Armada 1500-mini (BG2CD) SoC";
> +       compatible = "marvell,berlin2cd", "marvell,berlin";
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu@0 {
> +                       compatible = "arm,cortex-a9";
> +                       device_type = "cpu";
> +                       next-level-cache = <&l2>;
> +                       reg = <0>;
> +               };
> +       };
> +
> +       clocks {
> +               smclk: sysmgr-clock {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <25000000>;
> +               };
> +
> +               cfgclk: cfg-clock {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <75000000>;
> +               };
> +
> +               sysclk: system-clock {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <300000000>;
> +               };
> +       };
> +
> +       soc {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               interrupt-parent = <&gic>;
> +
> +               ranges = <0 0xf7000000 0x1000000>;
> +
> +               l2: l2-cache-controller@ac0000 {
> +                       compatible = "arm,pl310-cache";
> +                       reg = <0xac0000 0x1000>;
> +                       cache-unified;
> +                       cache-level = <2>;
> +                       arm,prefetch-ctrl = <0x70000007>;
> +                       arm,pwr-ctrl = <0x3>;
These two setting depend on the following prefetch and power control support patch.
We have it in our internal tree for a long time.

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/209700.html
> +               };
> +
> +               gic: interrupt-controller@ad1000 {
> +                       compatible = "arm,cortex-a9-gic";
> +                       reg = <0xad1000 0x1000>, <0xad0100 0x0100>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <3>;
> +               };
> +
> +               local-timer@ad0600 {
> +                       compatible = "arm,cortex-a9-twd-timer";
> +                       reg = <0xad0600 0x20>;
> +                       interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +                       clocks = <&sysclk>;
> +               };
> +
> +               apb@e80000 {
> +                       compatible = "simple-bus";
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +
> +                       ranges = <0 0xe80000 0x10000>;
> +                       interrupt-parent = <&aic>;
> +
> +                       timer0: timer@2c00 {
> +                               compatible = "snps,dw-apb-timer";
snps,dw-apb-timer-osc?
> +                               reg = <0x2c00 0x14>;
> +                               interrupts = <8>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "okay";
> +                       };
> +
> +                       timer1: timer@2c14 {
> +                               compatible = "snps,dw-apb-timer";
ditto for the remaining
> +                               reg = <0x2c14 0x14>;
> +                               interrupts = <9>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "okay";
> +                       };
> +
> +                       timer2: timer@2c28 {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c28 0x14>;
> +                               interrupts = <10>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       timer3: timer@2c3c {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c3c 0x14>;
> +                               interrupts = <11>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       timer4: timer@2c50 {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c50 0x14>;
> +                               interrupts = <12>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       timer5: timer@2c64 {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c64 0x14>;
> +                               interrupts = <13>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       timer6: timer@2c78 {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c78 0x14>;
> +                               interrupts = <14>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       timer7: timer@2c8c {
> +                               compatible = "snps,dw-apb-timer";
> +                               reg = <0x2c8c 0x14>;
> +                               interrupts = <15>;
> +                               clocks = <&cfgclk>;
> +                               clock-names = "timer";
> +                               status = "disabled";
> +                       };
> +
> +                       aic: interrupt-controller@3000 {
> +                               compatible = "snps,dw-apb-ictl";
> +                               reg = <0x3000 0xc00>;
> +                               interrupt-controller;
> +                               #interrupt-cells = <1>;
> +                               interrupt-parent = <&gic>;
> +                               interrupts = <GIC_SPI 3
> IRQ_TYPE_LEVEL_HIGH>;
> +                       };
> +               };
> +
> +               apb@fc0000 {
> +                       compatible = "simple-bus";
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +
> +                       ranges = <0 0xfc0000 0x10000>;
> +                       interrupt-parent = <&sic>;
> +
> +                       uart0: serial@9000 {
> +                               compatible = "snps,dw-apb-uart";
> +                               reg = <0x9000 0x100>;
> +                               reg-shift = <2>;
> +                               reg-io-width = <1>;
> +                               interrupts = <8>;
> +                               clocks = <&smclk>;
> +                               status = "disabled";
> +                       };
> +
> +                       uart1: serial@a000 {
> +                               compatible = "snps,dw-apb-uart";
> +                               reg = <0xa000 0x100>;
> +                               reg-shift = <2>;
> +                               reg-io-width = <1>;
> +                               interrupts = <9>;
> +                               clocks = <&smclk>;
> +                               status = "disabled";
> +                       };
> +
> +                       sic: interrupt-controller@e000 {
> +                               compatible = "snps,dw-apb-ictl";
> +                               reg = <0xe000 0x400>;
> +                               interrupt-controller;
> +                               #interrupt-cells = <1>;
> +                               interrupt-parent = <&gic>;
> +                               interrupts = <GIC_SPI 15
> IRQ_TYPE_LEVEL_HIGH>;
> +                       };
> +               };
> +       };
> +};
> --
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

