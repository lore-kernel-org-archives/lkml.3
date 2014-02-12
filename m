Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaBLTr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:47:28 -0500
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:48153 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627AbaBLTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:47:25 -0500
X-Greylist: delayed 123796 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 14:47:24 EST
MIME-Version: 1.0
In-Reply-To: <20140212172844.GE11498@piout.net>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
	<20140212172844.GE11498@piout.net>
Date: Wed, 12 Feb 2014 20:47:16 +0100
Message-ID: <CACh+v5MgYB+L6vpektjAE1yTH=dvjnyP1CjJeA7vG_yOyxFkgg@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] at91: dt: Add at91sam9261 dt SoC support
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 15009653134712657944
X-Ovh-Remote: 209.85.192.172 (mail-pd0-f172.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

2014-02-12 18:28 GMT+01:00 Alexandre Belloni
<alexandre.belloni@free-electrons.com>:
> Hi,
>
> On 12/02/2014 at 11:06:42 +0100, Jean-Jacques Hiblot wrote :
>> This patch adds support for the Device Tree on a sam9261-based platform
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  arch/arm/boot/dts/at91sam9261.dtsi | 740 +++++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-at91/at91sam9261.c   |  17 +
>>  2 files changed, 757 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>
> [...]
>
>> +
>> +             apb {
>> +                     compatible = "simple-bus";
>> +                     #address-cells = <1>;
>> +                     #size-cells = <1>;
>> +                     ranges;
>> +
>> +                     tcb0: timer@fffa0000 {
>> +                             compatible = "atmel,at91rm9200-tcb";
>> +                             reg = <0xfffa0000 0x100>;
>> +                             interrupts = < 17 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     18 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     19 IRQ_TYPE_LEVEL_HIGH 0
>> +                                     >;
>> +                             clocks = <&tc0_clk>, <&tc1_clk>, <&tc2_clk>;
>> +                             clock-names = "t0_clk", "t1_clk", "t2_clk";
>> +                     };
>> +
>> +                     usb1: gadget@fffa4000 {
>> +                             compatible = "atmel,at91rm9200-udc";
>> +                             reg = <0xfffa4000 0x4000>;
>> +                             interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
>> +                             clocks = <&usb>, <&udc_clk>, <&udpck>;
>> +                             clock-names = "usb_clk", "udc_clk", "udpck";
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     mmc0: mmc@fffa8000 {
>> +                             compatible = "atmel,hsmci";
>> +                             reg = <0xfffa8000 0x600>;
>> +                             interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_mmc0_clk>, <&pinctrl_mmc0_slot0_cmd_dat0>, <&pinctrl_mmc0_slot0_dat1_3>;
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             clocks = <&mci0_clk>;
>> +                             clock-names = "mci_clk";
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     i2c0: i2c@fffac000 {
>> +                             compatible = "atmel,at91sam9261-i2c";
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_i2c_twi>;
>> +                             reg = <0xfffac000 0x100>;
>> +                             interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             clocks = <&twi0_clk>;
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
>> +                             clocks = <&usart0_clk>;
>> +                             clock-names = "usart";
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usart1: serial@fffb4000 {
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffb4000 0x200>;
>> +                             interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             atmel,use-dma-rx;
>> +                             atmel,use-dma-tx;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_usart1>;
>> +                             clocks = <&usart1_clk>;
>> +                             clock-names = "usart";
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     usart2: serial@fffb8000{
>> +                             compatible = "atmel,at91sam9260-usart";
>> +                             reg = <0xfffb8000 0x200>;
>> +                             interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                             atmel,use-dma-rx;
>> +                             atmel,use-dma-tx;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_usart2>;
>> +                             clocks = <&usart2_clk>;
>> +                             clock-names = "usart";
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
>> +                     spi0: spi@fffc8000 {
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +                             compatible = "atmel,at91rm9200-spi";
>> +                             reg = <0xfffc8000 0x200>;
>> +                             cs-gpios = <0>, <0>, <0>, <0>;
>> +                             interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
>> +                             pinctrl-names = "default";
>> +                             pinctrl-0 = <&pinctrl_spi0>;
>> +                             clocks = <&spi0_clk>;
>> +                             clock-names = "spi_clk";
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
>> +                             clocks = <&spi1_clk>;
>> +                             clock-names = "spi_clk";
>> +                             status = "disabled";
>> +                     };
>> +
>> +                     ramc: ramc@ffffea00 {
>> +                             compatible = "atmel,at91sam9260-sdramc";
>> +                             reg = <0xffffea00 0x200>;
>> +                     };
>> +
>
> You probably copied/pasted it but according to the block diagram, the
> sdram controller is not under the apb.
You're right I copied/pasted :o) But the addresses of the registers
look like typical APB addresses.
AFAIK all the registers of this SOC are accessed through the APB
(except for OHCI and LCDC)

So probably the real question here is what is the sense of the bus
hierarchy in cases where a controller is connected to several buses
(APB for registers, AHB/matrix for other purpose) ?
As I don't have any idea on how to handle this, I choose to copy/paste.

>
>> +                     matrix: matrix@ffffee00 {
>> +                             compatible = "atmel,at91sam9261-bus-matrix";
>> +                             reg = <0xffffee00 0x200>;
>> +                     };
>> +
>
> Same here, the apb is actually under the bus matrix.
>
> I don't know whether it can be represented another way though.
>
>
> --
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
