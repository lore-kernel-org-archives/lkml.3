Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaAOKNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:13:45 -0500
Received: from 18.mo6.mail-out.ovh.net ([46.105.73.110]:56983 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705AbaAOKNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <52D56D5B.5000505@atmel.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
	<1389270709-32662-2-git-send-email-jjhiblot@traphandler.com>
	<52D56D5B.5000505@atmel.com>
Date: Wed, 15 Jan 2014 11:08:02 +0100
Message-ID: <CACh+v5Nx-EkjZrN-NJ-5W9aC9HKg1P6kr2cN_4Gk4DPJn5RbWQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] at91: dt: Add at91sam9261 dt SoC support
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 6874181882224138264
X-Ovh-Remote: 209.85.160.49 (mail-pb0-f49.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/14 Nicolas Ferre <nicolas.ferre@atmel.com>:
> On 09/01/2014 13:31, Jean-Jacques Hiblot :
>> This patch adds the basics to support the Device Tree on a sam9261-based platform
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  arch/arm/boot/dts/at91sam9261.dtsi | 476 +++++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-at91/at91sam9261.c   |  15 ++
>>  2 files changed, 491 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>>
>> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
>> new file mode 100644
>> index 0000000..773c3d6
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/at91sam9261.dtsi
>> @@ -0,0 +1,476 @@
>> +/*
>> + * at91sam9261.dtsi - Device Tree Include file for AT91SAM9261 SoC
>> + *
>> + *  Copyright (C) 2013 Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> + *
>> + * Licensed under GPLv2 only.
>> + */
>> +
>> +#include "skeleton.dtsi"
>> +#include <dt-bindings/pinctrl/at91.h>
>> +#include <dt-bindings/interrupt-controller/irq.h>
>> +#include <dt-bindings/gpio/gpio.h>
>> +
>> +/ {
>> +     model = "Atmel AT91SAM9261 family SoC";
>> +     compatible = "atmel,at91sam9261";
>> +     interrupt-parent = <&aic>;
>> +
>> +     aliases {
>> +             serial0 = &dbgu;
>> +             serial1 = &usart0;
>> +             serial2 = &usart1;
>> +             serial3 = &usart2;
>> +             gpio0 = &pioA;
>> +             gpio1 = &pioB;
>> +             gpio2 = &pioC;
>> +             tcb0 = &tcb0;
>> +             i2c0 = &i2c0;
>> +             ssc0 = &ssc0;
>> +             ssc1 = &ssc1;
>> +     };
>> +     cpus {
>> +             #address-cells = <0>;
>> +             #size-cells = <0>;
>> +
>> +             cpu {
>> +                     compatible = "arm,arm926ej-s";
>> +                     device_type = "cpu";
>> +             };
>> +     };
>> +
>> +     memory {
>> +             reg = <0x20000000 0x08000000>;
>> +     };
>> +
>> +     ahb {
>> +             compatible = "simple-bus";
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +             ranges;
>> +
>> +             apb {
>> +                     compatible = "simple-bus";
>> +                     #address-cells = <1>;
>> +                     #size-cells = <1>;
>> +                     ranges;
>
> I know that it is not always done but can you please sort all nodes by
> ascending address order? It is always simple to deal with node additions
> when sorted this way.
just to clarify, ascending order means ascending address order, right ?

>
>> +
>> +                     aic: interrupt-controller@fffff000 {
>> +                             #interrupt-cells = <3>;
>> +                             compatible = "atmel,at91rm9200-aic";
>> +                             interrupt-controller;
>> +                             reg = <0xfffff000 0x200>;
>> +                             atmel,external-irqs = <29 30 31>;
>> +                     };
>> +
>> +                     pmc: pmc@fffffc00 {
>> +                             compatible = "atmel,at91rm9200-pmc";
>> +                             reg = <0xfffffc00 0x100>;
>> +                     };
>> +
>> +                     ramc: ramc@ffffea00 {
>> +                             compatible = "atmel,at91sam9260-sdramc";
>> +                             reg = <0xffffea00 0x200>;
>> +                     };
>> +
>> +                     pit: timer@fffffd30 {
>> +                             compatible = "atmel,at91sam9260-pit";
>> +                             reg = <0xfffffd30 0xf>;
>> +                             interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
>> +                     };
>> +
>> +                     tcb0: timer@fffa0000 {
>> +                             compatible = "atmel,at91rm9200-tcb";
>> +                             reg = <0xfffa0000 0x100>;
>> +                             interrupts = < 17 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     18 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     19 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     >;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     rstc@fffffd00 {
>> +                             compatible = "atmel,at91sam9260-rstc";
>> +                             reg = <0xfffffd00 0x10>;
>> +                     };
>> +
>> +                     shdwc@fffffd10 {
>> +                             compatible = "atmel,at91sam9260-shdwc";
>> +                             reg = <0xfffffd10 0x10>;
>> +                     };
>> +
>> +                     pinctrl@fffff400 {
>> +                             #address-cells = <1>;
>> +                             #size-cells = <1>;
>> +                             compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
>> +                             ranges = <0xfffff400 0xfffff400 0xa00>;
>> +
>> +                             atmel,mux-mask = <
>> +                                   /*    A         B     */
>> +                                    0xffffffff 0xfffffff7  /* pioA */
>> +                                    0xffffffff 0xfffffff4  /* pioB */
>> +                                    0xffffffff 0xffffff07  /* pioC */
>> +                                   >;
>> +
>> +                             /* shared pinctrl settings */
>> +                             dbgu {
>> +                                     pinctrl_dbgu: dbgu-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 9  AT91_PERIPH_A AT91_PINCTRL_NONE           /* PA9  periph A */
>
> You may have to remove comments for pin descriptions. It is not needed
> anymore with pre-processor macros.
That is a relief

>
>> +                                                      AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;      /* PA10 periph A with pullup */
>> +                                     };
>> +                             };
>> +
>> +                             usart0 {
>> +                                     pinctrl_usart0: usart0-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP /* PC8 periph A with pullup */
>> +                                                      AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;  /* PC9 periph A */
>> +                                     };
>> +
>> +                                     pinctrl_usart0_rts: usart0_rts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PC10 periph A */
>> +                                     };
>> +
>> +                                     pinctrl_usart0_cts: usart0_cts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PC11 periph A */
>> +                                     };
>> +                             };
>> +
>> +                             usart1 {
>> +                                     pinctrl_usart1: usart1-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_PULL_UP        /* PC12 periph A with pullup */
>> +                                                      AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE>;         /* PC13 periph A */
>> +                                     };
>> +
>> +                                     pinctrl_usart1_rts: usart1_rts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 12 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA12 periph B */
>> +                                     };
>> +
>> +                                     pinctrl_usart1_cts: usart1_cts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 13 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA13 periph B */
>> +                                     };
>> +                             };
>> +
>> +                             usart2 {
>> +                                     pinctrl_usart2: usart2-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_PULL_UP        /* PC14 periph A with pullup */
>> +                                                      AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;         /* PC15 periph A */
>> +                                     };
>> +
>> +                                     pinctrl_usart2_rts: usart2_rts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 15 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA15 periph B */
>> +                                     };
>> +
>> +                                     pinctrl_usart2_cts: usart2_cts-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 16 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA16 periph B */
>> +                                     };
>> +                             };
>> +
>> +                             nand {
>> +                                     pinctrl_nand: nand-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOC 15 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP     /* PC15 gpio RDY pin pull_up*/
>> +                                                      AT91_PIOC 14 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;   /* PC14 gpio enable pin pull_up */
>> +                                     };
>> +                             };
>> +
>> +                             mmc0 {
>> +                                     pinctrl_mmc0_clk: mmc0_clk-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 2 AT91_PERIPH_B AT91_PINCTRL_NONE>;  /* PA2 periph B */
>> +                                     };
>> +
>> +                                     pinctrl_mmc0_slot0_cmd_dat0: mmc0_slot0_cmd_dat0-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 1 AT91_PERIPH_B AT91_PINCTRL_PULL_UP         /* PA1 periph B with pullup */
>> +                                                      AT91_PIOA 0 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;       /* PA0 periph B with pullup */
>> +                                     };
>> +
>> +                                     pinctrl_mmc0_slot0_dat1_3: mmc0_slot0_dat1_3-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 4 AT91_PERIPH_B AT91_PINCTRL_PULL_UP         /* PA4 periph B with pullup */
>> +                                                      AT91_PIOA 5 AT91_PERIPH_B AT91_PINCTRL_PULL_UP         /* PA5 periph B with pullup */
>> +                                                      AT91_PIOA 6 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;       /* PA6 periph B with pullup */
>> +                                     };
>> +                                     };
>> +
>> +                             ssc0 {
>> +                                     pinctrl_ssc0_tx: ssc0_tx-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOB 21 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB21 periph A */
>> +                                                      AT91_PIOB 22 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB22 periph A */
>> +                                                      AT91_PIOB 23 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB23 periph A */
>> +                                     };
>> +
>> +                                     pinctrl_ssc0_rx: ssc0_rx-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOB 24 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB24 periph A */
>> +                                                      AT91_PIOB 25 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB25 periph A */
>> +                                                      AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB26 periph A */
>> +                                     };
>> +                             };
>> +
>> +                             ssc1 {
>> +                                     pinctrl_ssc1_tx: ssc1_tx-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 17 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PA17 periph B */
>> +                                                      AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PA18 periph B */
>> +                                                      AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA19 periph B */
>> +                                     };
>> +
>> +                                     pinctrl_ssc1_rx: ssc1_rx-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 20 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PA20 periph B */
>> +                                                      AT91_PIOA 21 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PA21 periph B */
>> +                                                      AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PA22 periph B */
>> +                                     };
>> +                             };
>> +
>> +                             spi0 {
>> +                                     pinctrl_spi0: spi0-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PA0 periph A SPI0_MISO pin */
>> +                                                      AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PA1 periph A SPI0_MOSI pin */
>> +                                                      AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;  /* PA2 periph A SPI0_SPCK pin */
>> +                                     };
>> +                                     };
>> +
>> +                             spi1 {
>> +                                     pinctrl_spi1: spi1-0 {
>> +                                             atmel,pins =
>> +                                                     <AT91_PIOB 30 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB30 periph A SPI1_MISO pin */
>> +                                                      AT91_PIOB 31 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB31 periph A SPI1_MOSI pin */
>> +                                                      AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB29 periph A SPI1_SPCK pin */
>> +                                     };
>> +                             };
>> +
>> +                             tcb0 {
>> +                                     pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
>> +                                             atmel,pins = <AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
>> +                                             atmel,pins = <AT91_PIOC 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
>> +                                             atmel,pins = <AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
>> +                                             atmel,pins = <AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
>> +                                             atmel,pins = <AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
>> +                                             atmel,pins = <AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
>> +                                             atmel,pins = <AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
>> +                                             atmel,pins = <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +
>> +                                     pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
>> +                                             atmel,pins = <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;
>> +                                     };
>> +                             };
>> +
>> +                             pioA: gpio@fffff400 {
>> +                                     compatible = "atmel,at91rm9200-gpio";
>> +                                     reg = <0xfffff400 0x200>;
>> +                                     interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
>> +                                     #gpio-cells = <2>;
>> +                                     gpio-controller;
>> +                                     interrupt-controller;
>> +                                     #interrupt-cells = <2>;
>> +                             };
>> +
>> +                             pioB: gpio@fffff600 {
>> +                                     compatible = "atmel,at91rm9200-gpio";
>> +                                     reg = <0xfffff600 0x200>;
>> +                                     interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
>> +                                     #gpio-cells = <2>;
>> +                                     gpio-controller;
>> +                                     interrupt-controller;
>> +                                     #interrupt-cells = <2>;
>> +                             };
>> +
>> +                             pioC: gpio@fffff800 {
>> +                                     compatible = "atmel,at91rm9200-gpio";
>> +                                     reg = <0xfffff800 0x200>;
>> +                                     interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
>> +                                     #gpio-cells = <2>;
>> +                                     gpio-controller;
>> +                                     interrupt-controller;
>> +                                     #interrupt-cells = <2>;
>> +                             };
>> +                     };
>> +
>> +                     dbgu: serial@fffff200 {
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffff200 0x200>;
>> +                             interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_dbgu>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usart0: serial@fffb0000 {
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffb0000 0x200>;
>> +                             interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             atmel,use-dma-rx;
>> +                             atmel,use-dma-tx;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_usart0>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usart1: serial@ffffb400 {
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffb4000 0x200>;
>> +                             interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             atmel,use-dma-rx;
>> +                             atmel,use-dma-tx;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_usart1>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usart2: serial@fff94000 {
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffb8000 0x200>;
>> +                             interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             atmel,use-dma-rx;
>> +                             atmel,use-dma-tx;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_usart2>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     ssc0: ssc@fffbc000 {
>> +                             compatible = "atmel,at91rm9200-ssc";
>> +                             reg = <0xfffbc000 0x4000>;
>> +                             interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     ssc1: ssc@fffc0000 {
>> +                             compatible = "atmel,at91rm9200-ssc";
>> +                             reg = <0xfffc0000 0x4000>;
>> +                             interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usb1: gadget@fffa4000 {
>> +                             compatible = "atmel,at91rm9200-udc";
>> +                             reg = <0xfffa4000 0x4000>;
>> +                             interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     i2c0: i2c@fffac000 {
>> +                             compatible = "atmel,at91sam9261-i2c";
>
> isn't it "atmel,at91sam9260-i2c" ?
I don't know. the i2c driver whows a difference between the 9260 and
the 9261 regarding the clk_max_div. But I forgot to add the 9261 in
the dt ids table of the twi driver.
>
>> +                             reg = <0xfffac000 0x100>;
>> +                             interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     mmc0: mmc@fffa8000 {
>> +                             compatible = "atmel,hsmci";
>> +                             reg = <0xfffa8000 0x600>;
>> +                             interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     watchdog@fffffd40 {
>> +                             compatible = "atmel,at91sam9260-wdt";
>> +                             reg = <0xfffffd40 0x10>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     spi0: spi@fffc8000 {
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             compatible = "atmel,at91rm9200-spi";
>> +                             reg = <0xfffc8000 0x200>;
>> +                             interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_spi0>;
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     spi1: spi@fffcc000 {
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             compatible = "atmel,at91rm9200-spi";
>> +                             reg = <0xfffcc000 0x200>;
>> +                             interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_spi1>;
>> +                             status = "disabled";
>> +                     };
>> +             };
>> +
>> +             nand0: nand@40000000 {
>> +                     compatible = "atmel,at91rm9200-nand";
>> +                     #address-cells = <1>;
>> +                     #size-cells = <1>;
>> +                     reg = <0x40000000 0x10000000>;
>> +                     atmel,nand-addr-offset = <22>;
>> +                     atmel,nand-cmd-offset = <21>;
>> +                     pinctrl-names = "default";
>> +                     pinctrl-0 = <&pinctrl_nand>;
>> +
>> +                     gpios = <&pioC 15 GPIO_ACTIVE_HIGH
>> +                             &pioC 14 GPIO_ACTIVE_HIGH
>> +                             0
>> +                             >;
>> +                     status = "disabled";
>> +             };
>> +
>> +             usb0: ohci@00500000 {
>> +                     compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>> +                     reg = <0x00500000 0x100000>;
>> +                     interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
>> +                     status = "disabled";
>> +             };
>> +     };
>> +
>> +     i2c@0 {
>> +             compatible = "i2c-gpio";
>> +             gpios = <&pioA 7 GPIO_ACTIVE_HIGH /* sda */
>> +                      &pioA 8 GPIO_ACTIVE_HIGH /* scl */
>> +                     >;
>> +             i2c-gpio,sda-open-drain;
>> +             i2c-gpio,scl-open-drain;
>> +             i2c-gpio,delay-us = <2>;        /* ~100 kHz */
>> +             #address-cells = <1>;
>> +             #size-cells = <0>;
>> +             status = "disabled";
>> +     };
>> +};
>> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
>> index 6276b4c..200d17a 100644
>> --- a/arch/arm/mach-at91/at91sam9261.c
>> +++ b/arch/arm/mach-at91/at91sam9261.c
>> @@ -189,6 +189,21 @@ static struct clk_lookup periph_clocks_lookups[] = {
>>       CLKDEV_CON_ID("pioA", &pioA_clk),
>>       CLKDEV_CON_ID("pioB", &pioB_clk),
>>       CLKDEV_CON_ID("pioC", &pioC_clk),
>> +     /* more usart lookup table for DT entries */
>> +     CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
>> +     CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
>> +     CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
>> +     CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
>> +     /* more tc lookup table for DT entries */
>> +     CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
>> +     CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &ohci_clk),
>> +     CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
>> +     CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
>> +     CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
>> +     CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi_clk),
>> +     CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
>> +     CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
>> +     CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
>
> Yes, this is where I would like the CCF to be implemented...
Is it okay it CCF support comes latter or must it be part of this serie?

>
>
>>  };
>>
>>  static struct clk_lookup usart_clocks_lookups[] = {
>>
>
>
> --
> Nicolas Ferre
