Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaKIGNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 01:13:13 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:3522 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaKIGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 01:13:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,345,1413270000"; 
   d="scan'208";a="50444645"
Message-ID: <545F05F0.3000702@broadcom.com>
Date: Sat, 8 Nov 2014 22:13:04 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/8] ARM: dts: Enable Broadcom Cygnus SoC
References: <sbranden@broadcom.com>	<1414525992-3678-1-git-send-email-sbranden@broadcom.com>	<1414525992-3678-5-git-send-email-sbranden@broadcom.com> <CAOesGMjUE-Z3L=FU1nspv5M52UhhJ9-dBLr40RTCz2WEhEPHLA@mail.gmail.com>
In-Reply-To: <CAOesGMjUE-Z3L=FU1nspv5M52UhhJ9-dBLr40RTCz2WEhEPHLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-08 04:22 PM, Olof Johansson wrote:
> Hi,
>
> A bunch of small comments below, should be quick to fix.
>
> On Tue, Oct 28, 2014 at 12:53 PM, Scott Branden <sbranden@broadcom.com> wrote:
>> DT files to enable cygnus consisting on reference designs
>> and cygnus core configuration.
>>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Arun Parameswaran <aparames@broadcom.com>
>> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
>> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   arch/arm/boot/dts/Makefile              |    4 ++
>>   arch/arm/boot/dts/bcm-cygnus-clock.dtsi |   73 ++++++++++++++++++++++
>>   arch/arm/boot/dts/bcm-cygnus.dtsi       |  100 +++++++++++++++++++++++++++++++
>>   arch/arm/boot/dts/bcm911360_entphn.dts  |   32 ++++++++++
>>   arch/arm/boot/dts/bcm911360k.dts        |   32 ++++++++++
>>   arch/arm/boot/dts/bcm958300k.dts        |   32 ++++++++++
>>   6 files changed, 273 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
>>   create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
>>   create mode 100644 arch/arm/boot/dts/bcm911360k.dts
>>   create mode 100644 arch/arm/boot/dts/bcm958300k.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 38c89ca..4b3a590 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -54,6 +54,10 @@ dtb-$(CONFIG_ARCH_AT91)      += at91-sama5d4ek.dtb
>>   dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
>>   dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
>>   dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>> +dtb-$(CONFIG_ARCH_BCM_CYGNUS) += \
>> +       bcm911360_entphn.dtb \
>> +       bcm911360k.dtb \
>> +       bcm958300k.dtb
>>   dtb-$(CONFIG_ARCH_BCM_5301X) += bcm4708-netgear-r6250.dtb
>>   dtb-$(CONFIG_ARCH_BCM_63XX) += bcm963138dvt.dtb
>>   dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb \
>
> Please add new entries in alphabetical/alphanumerical order. Also,
> first entry is commonly added on the first line
>
>
>> diff --git a/arch/arm/boot/dts/bcm-cygnus-clock.dtsi b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>> new file mode 100644
>> index 0000000..d06172b
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>> @@ -0,0 +1,73 @@
>> +/*
>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>> + *
>> + * Unless you and Broadcom execute a separate written software license
>> + * agreement governing use of this software, this software is licensed to you
>> + * under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>
> We ask for new DT contents to be added with dual BSD/GPL license, to
> allow for reuse of the DT data structures in other projects as well.
> There's currently a lot of activity going on relicensing the current
> files so I recommend sorting it out before they are added if you can.

This may take more time than you think.  I am going to have to go 
through legal to get such a license created.  Also, why would you need 
dual license?  If it is BSD that should serve both purposes?
>
>> + */
>> +
>> +clocks {
>> +       #address-cells = <1>;
>> +       #size-cells = <1>;
>> +       ranges;
>> +
>> +       osc: oscillator {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <1>;
>> +               clock-frequency = <25000000>;
>> +       };
>> +
>> +       apb_clk: apb_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <1000000000>;
>> +       };
>> +
>> +       periph_clk: periph_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <500000000>;
>> +       };
>> +
>> +       sdio_clk: lcpll_ch2 {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <200000000>;
>> +       };
>> +
>> +       axi81_clk: axi81_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <100000000>;
>> +       };
>> +
>> +       keypad_clk: keypad_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <31806>;
>> +       };
>> +
>> +       adc_clk: adc_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <1562500>;
>> +       };
>> +
>> +       pwm_clk: pwm_clk {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <1000000>;
>> +       };
>> +
>> +       lcd_clk: mipipll_ch1 {
>> +               compatible = "fixed-clock";
>> +               #clock-cells = <0>;
>> +               clock-frequency = <100000000>;
>> +       };
>> +};
>> diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
>> new file mode 100644
>> index 0000000..9c650ab
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
>> @@ -0,0 +1,100 @@
>> +/*
>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>> + *
>> + * Unless you and Broadcom execute a separate written software license
>> + * agreement governing use of this software, this software is licensed to you
>> + * under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> +#include <dt-bindings/interrupt-controller/irq.h>
>> +
>> +#include "skeleton.dtsi"
>> +
>> +/ {
>> +       compatible = "brcm,cygnus";
>> +       model = "Broadcom Cygnus SoC";
>> +       interrupt-parent = <&gic>;
>> +
>> +       cpus {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +
>> +               cpu@0 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a9";
>> +                       next-level-cache = <&L2>;
>> +                       reg = <0x0>;
>> +               };
>> +       };
>> +
>> +       /include/ "bcm-cygnus-clock.dtsi"
>> +
>> +       amba {
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               compatible = "arm,amba-bus", "simple-bus";
>> +               interrupt-parent = <&gic>;
>> +               ranges;
>> +
>> +               wdt@18009000 {
>> +                        compatible = "arm,sp805" , "arm,primecell";
>> +                        reg = <0x18009000 0x1000>;
>> +                        interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
>> +                        clocks = <&axi81_clk>;
>> +                        clock-names = "apb_pclk";
>> +               };
>> +       };
>> +
>> +       uart3: serial@18023000 {
>> +               compatible = "snps,dw-apb-uart";
>> +               reg = <0x18023000 0x100>;
>> +               reg-shift = <2>;
>> +               reg-io-width = <4>;
>> +               interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
>> +               clock-frequency = <100000000>;
>> +               clocks = <&axi81_clk>;
>> +               status = "okay";
>
> It is common to leave these disabled in the SoC/common dtsi, and
> enable them in the per-board dts files, since different boards might
> not use all peripherals, etc.
>
> It seems like all your boards currently use both uarts, but if it
> changes in the future please consider switching over. It might be
> worth doing so now to avoid churn later on. That also allows you to
> define all the uards (I'm going to guess that there's a total of at
> least 4 on this system :).
>
>> +       };
>> +
>> +       uart0: serial@18020000 {
>
> These are also out of order, uart3 is before uart0 (and the registers
> are in reverse order).
>
> We normally recommend that you add entries sorted by reg/unit address
> -- that way there's less risk of conflict due to add/add compared to
> if people just append new entries at the end of the file.
>
>> +               compatible = "snps,dw-apb-uart";
>> +               reg = <0x18020000 0x100>;
>> +               reg-shift = <2>;
>> +               reg-io-width = <4>;
>> +               interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
>> +               clocks = <&axi81_clk>;
>> +               clock-frequency = <100000000>;
>> +               status = "okay";
>> +       };
>> +
>> +       gic: interrupt-controller@19021000 {
>> +               compatible = "arm,cortex-a9-gic";
>> +               #interrupt-cells = <3>;
>> +               #address-cells = <0>;
>> +               interrupt-controller;
>> +               reg = <0x19021000 0x1000>,
>> +                     <0x19020100 0x100>;
>> +       };
>> +
>> +       L2: l2-cache {
>
> l2-cache@19022000
>
>> +               compatible = "arm,pl310-cache";
>> +               reg = <0x19022000 0x1000>;
>> +               cache-unified;
>> +               cache-level = <2>;
>> +       };
>> +
>> +       timer@19020200 {
>> +               compatible = "arm,cortex-a9-global-timer";
>> +               reg = <0x19020200 0x100>;
>> +               interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
>> +               clocks = <&periph_clk>;
>> +       };
>> +
>> +};
>> diff --git a/arch/arm/boot/dts/bcm911360_entphn.dts b/arch/arm/boot/dts/bcm911360_entphn.dts
>> new file mode 100644
>> index 0000000..9de5e87
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm911360_entphn.dts
>> @@ -0,0 +1,32 @@
>> +/*
>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>> + *
>> + * Unless you and Broadcom execute a separate written software license
>> + * agreement governing use of this software, this software is licensed to you
>> + * under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include "bcm-cygnus.dtsi"
>> +
>> +/ {
>> +       model = "Cygnus Enterprise Phone (BCM911360_ENTPHN)";
>> +       compatible = "brcm,bcm11360", "brcm,cygnus";
>> +
>> +       aliases {
>> +               serial0 = &uart3;
>> +               serial1 = &uart0;
>> +       };
>> +
>> +       chosen {
>> +               stdout-path = &uart3;
>> +               bootargs = "console=ttyS0,115200";
>> +       };
>> +};
>> diff --git a/arch/arm/boot/dts/bcm911360k.dts b/arch/arm/boot/dts/bcm911360k.dts
>> new file mode 100644
>> index 0000000..dd4f102
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm911360k.dts
>> @@ -0,0 +1,32 @@
>> +/*
>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>> + *
>> + * Unless you and Broadcom execute a separate written software license
>> + * agreement governing use of this software, this software is licensed to you
>> + * under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include "bcm-cygnus.dtsi"
>> +
>> +/ {
>> +       model = "Cygnus SVK (BCM911360K)";
>> +       compatible = "brcm,bcm11360", "brcm,cygnus";
>> +
>> +       aliases {
>> +               serial0 = &uart3;
>> +               serial1 = &uart0;
>> +       };
>> +
>> +       chosen {
>> +               stdout-path = &uart3;
>> +               bootargs = "console=ttyS0,115200";
>> +       };
>> +};
>> diff --git a/arch/arm/boot/dts/bcm958300k.dts b/arch/arm/boot/dts/bcm958300k.dts
>> new file mode 100644
>> index 0000000..f8b9625
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm958300k.dts
>> @@ -0,0 +1,32 @@
>> +/*
>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>> + *
>> + * Unless you and Broadcom execute a separate written software license
>> + * agreement governing use of this software, this software is licensed to you
>> + * under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include "bcm-cygnus.dtsi"
>> +
>> +/ {
>> +       model = "Cygnus SVK (BCM958300K)";
>> +       compatible = "brcm,bcm58300", "brcm,cygnus";
>> +
>> +       aliases {
>> +               serial0 = &uart3;
>> +               serial1 = &uart0;
>> +       };
>> +
>> +       chosen {
>> +               stdout-path = &uart3;
>> +               bootargs = "console=ttyS0,115200";
>> +       };
>> +};
>> --
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

