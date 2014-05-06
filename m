Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaEFOlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:41:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34114 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbaEFOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:41:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lom9a4K9awhcsb9kaIhS8
Date: Tue, 6 May 2014 07:41:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, rnayak@ti.com, marc.zyngier@arm.com,
        grant.likely@linaro.org, mark.rutland@arm.com, tglx@linutronix.de,
        galak@codeaurora.org, santosh.shilimkar@ti.com, nm@ti.com,
        bcousson@baylibre.com, robherring2@gmail.com
Subject: Re: [PATCH V5 2/3] arm: dts: dra7: Replace peripheral interrupt
 numbers with crossbar inputs
Message-ID: <20140506144128.GB18474@atomide.com>
References: <1399384579-25620-1-git-send-email-r.sricharan@ti.com>
 <1399384579-25620-3-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399384579-25620-3-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [140506 06:58]:
> Now with the crossbar IP in picture, the peripherals do not have the
> fixed interrupt lines. Instead they rely on the crossbar irqchip to
> allocate and map a free interrupt line to its crossbar input. So replacing
> all the peripheral interrupt numbers with its fixed crossbar input lines.

Presumably this depends on the crossbar fixes?

Are you guys sure this is OK to apply now? Has it really been tested
for the devices to work with the mainline kernel?

I do not want to see constant patching of things over and over again
with this stuff, so I'd like to see at least two Tested-by's for this
series before applying.

Regards,

Tony
 
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> [V5] Rebased on 3.15-rc4 and replaced irqs numbers with crossbar
>      numbers for new peripherals.
> 
>  arch/arm/boot/dts/dra7.dtsi |  100 +++++++++++++++++++++++--------------------
>  1 file changed, 54 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 0274a86..52e4bd0 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -106,8 +106,8 @@
>  		ti,hwmods = "l3_main_1", "l3_main_2";
>  		reg = <0x44000000 0x2000>,
>  		      <0x44800000 0x3000>;
> -		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
>  
>  		prm: prm@4ae06000 {
>  			compatible = "ti,dra7-prm";
> @@ -182,10 +182,10 @@
>  		sdma: dma-controller@4a056000 {
>  			compatible = "ti,omap4430-sdma";
>  			reg = <0x4a056000 0x1000>;
> -			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> -				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> -				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> -				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
>  			#dma-cells = <1>;
>  			#dma-channels = <32>;
>  			#dma-requests = <127>;
> @@ -194,7 +194,7 @@
>  		gpio1: gpio@4ae10000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x4ae10000 0x200>;
> -			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio1";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -205,7 +205,7 @@
>  		gpio2: gpio@48055000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x48055000 0x200>;
> -			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio2";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -216,7 +216,7 @@
>  		gpio3: gpio@48057000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x48057000 0x200>;
> -			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio3";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -227,7 +227,7 @@
>  		gpio4: gpio@48059000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x48059000 0x200>;
> -			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio4";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -238,7 +238,7 @@
>  		gpio5: gpio@4805b000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x4805b000 0x200>;
> -			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio5";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -249,7 +249,7 @@
>  		gpio6: gpio@4805d000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x4805d000 0x200>;
> -			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio6";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -260,7 +260,7 @@
>  		gpio7: gpio@48051000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x48051000 0x200>;
> -			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio7";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -271,7 +271,7 @@
>  		gpio8: gpio@48053000 {
>  			compatible = "ti,omap4-gpio";
>  			reg = <0x48053000 0x200>;
> -			interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "gpio8";
>  			gpio-controller;
>  			#gpio-cells = <2>;
> @@ -282,7 +282,7 @@
>  		uart1: serial@4806a000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x4806a000 0x100>;
> -			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart1";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -291,7 +291,7 @@
>  		uart2: serial@4806c000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x4806c000 0x100>;
> -			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart2";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -300,7 +300,7 @@
>  		uart3: serial@48020000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48020000 0x100>;
> -			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart3";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -309,7 +309,7 @@
>  		uart4: serial@4806e000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x4806e000 0x100>;
> -			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart4";
>  			clock-frequency = <48000000>;
>                          status = "disabled";
> @@ -318,7 +318,7 @@
>  		uart5: serial@48066000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48066000 0x100>;
> -			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart5";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -327,7 +327,7 @@
>  		uart6: serial@48068000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48068000 0x100>;
> -			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart6";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -336,6 +336,7 @@
>  		uart7: serial@48420000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48420000 0x100>;
> +			interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart7";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -344,6 +345,7 @@
>  		uart8: serial@48422000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48422000 0x100>;
> +			interrupts = <GIC_SPI 219 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart8";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -352,6 +354,7 @@
>  		uart9: serial@48424000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x48424000 0x100>;
> +			interrupts = <GIC_SPI 220 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart9";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -360,6 +363,7 @@
>  		uart10: serial@4ae2b000 {
>  			compatible = "ti,omap4-uart";
>  			reg = <0x4ae2b000 0x100>;
> +			interrupts = <GIC_SPI 221 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "uart10";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> @@ -368,7 +372,7 @@
>  		timer1: timer@4ae18000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x4ae18000 0x80>;
> -			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer1";
>  			ti,timer-alwon;
>  		};
> @@ -376,28 +380,28 @@
>  		timer2: timer@48032000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48032000 0x80>;
> -			interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer2";
>  		};
>  
>  		timer3: timer@48034000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48034000 0x80>;
> -			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer3";
>  		};
>  
>  		timer4: timer@48036000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48036000 0x80>;
> -			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer4";
>  		};
>  
>  		timer5: timer@48820000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48820000 0x80>;
> -			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer5";
>  			ti,timer-dsp;
>  		};
> @@ -405,7 +409,7 @@
>  		timer6: timer@48822000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48822000 0x80>;
> -			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer6";
>  			ti,timer-dsp;
>  			ti,timer-pwm;
> @@ -414,7 +418,7 @@
>  		timer7: timer@48824000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48824000 0x80>;
> -			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer7";
>  			ti,timer-dsp;
>  		};
> @@ -422,7 +426,7 @@
>  		timer8: timer@48826000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48826000 0x80>;
> -			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer8";
>  			ti,timer-dsp;
>  			ti,timer-pwm;
> @@ -431,21 +435,21 @@
>  		timer9: timer@4803e000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x4803e000 0x80>;
> -			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer9";
>  		};
>  
>  		timer10: timer@48086000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48086000 0x80>;
> -			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer10";
>  		};
>  
>  		timer11: timer@48088000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48088000 0x80>;
> -			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer11";
>  			ti,timer-pwm;
>  		};
> @@ -453,6 +457,7 @@
>  		timer13: timer@48828000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x48828000 0x80>;
> +			interrupts = <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer13";
>  			status = "disabled";
>  		};
> @@ -460,6 +465,7 @@
>  		timer14: timer@4882a000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x4882a000 0x80>;
> +			interrupts = <GIC_SPI 340 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer14";
>  			status = "disabled";
>  		};
> @@ -467,6 +473,7 @@
>  		timer15: timer@4882c000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x4882c000 0x80>;
> +			interrupts = <GIC_SPI 341 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer15";
>  			status = "disabled";
>  		};
> @@ -474,6 +481,7 @@
>  		timer16: timer@4882e000 {
>  			compatible = "ti,omap5430-timer";
>  			reg = <0x4882e000 0x80>;
> +			interrupts = <GIC_SPI 342 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "timer16";
>  			status = "disabled";
>  		};
> @@ -481,7 +489,7 @@
>  		wdt2: wdt@4ae14000 {
>  			compatible = "ti,omap4-wdt";
>  			reg = <0x4ae14000 0x80>;
> -			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "wd_timer2";
>  		};
>  
> @@ -495,14 +503,14 @@
>  		dmm@4e000000 {
>  			compatible = "ti,omap5-dmm";
>  			reg = <0x4e000000 0x800>;
> -			interrupts = <0 113 0x4>;
> +			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "dmm";
>  		};
>  
>  		i2c1: i2c@48070000 {
>  			compatible = "ti,omap4-i2c";
>  			reg = <0x48070000 0x100>;
> -			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "i2c1";
> @@ -512,7 +520,7 @@
>  		i2c2: i2c@48072000 {
>  			compatible = "ti,omap4-i2c";
>  			reg = <0x48072000 0x100>;
> -			interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "i2c2";
> @@ -522,7 +530,7 @@
>  		i2c3: i2c@48060000 {
>  			compatible = "ti,omap4-i2c";
>  			reg = <0x48060000 0x100>;
> -			interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "i2c3";
> @@ -532,7 +540,7 @@
>  		i2c4: i2c@4807a000 {
>  			compatible = "ti,omap4-i2c";
>  			reg = <0x4807a000 0x100>;
> -			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "i2c4";
> @@ -542,7 +550,7 @@
>  		i2c5: i2c@4807c000 {
>  			compatible = "ti,omap4-i2c";
>  			reg = <0x4807c000 0x100>;
> -			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "i2c5";
> @@ -552,7 +560,7 @@
>  		mmc1: mmc@4809c000 {
>  			compatible = "ti,omap4-hsmmc";
>  			reg = <0x4809c000 0x400>;
> -			interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "mmc1";
>  			ti,dual-volt;
>  			ti,needs-special-reset;
> @@ -565,7 +573,7 @@
>  		mmc2: mmc@480b4000 {
>  			compatible = "ti,omap4-hsmmc";
>  			reg = <0x480b4000 0x400>;
> -			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "mmc2";
>  			ti,needs-special-reset;
>  			dmas = <&sdma 47>, <&sdma 48>;
> @@ -576,7 +584,7 @@
>  		mmc3: mmc@480ad000 {
>  			compatible = "ti,omap4-hsmmc";
>  			reg = <0x480ad000 0x400>;
> -			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "mmc3";
>  			ti,needs-special-reset;
>  			dmas = <&sdma 77>, <&sdma 78>;
> @@ -587,7 +595,7 @@
>  		mmc4: mmc@480d1000 {
>  			compatible = "ti,omap4-hsmmc";
>  			reg = <0x480d1000 0x400>;
> -			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
>  			ti,hwmods = "mmc4";
>  			ti,needs-special-reset;
>  			dmas = <&sdma 57>, <&sdma 58>;
> @@ -730,7 +738,7 @@
>  		mcspi1: spi@48098000 {
>  			compatible = "ti,omap4-mcspi";
>  			reg = <0x48098000 0x200>;
> -			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "mcspi1";
> @@ -751,7 +759,7 @@
>  		mcspi2: spi@4809a000 {
>  			compatible = "ti,omap4-mcspi";
>  			reg = <0x4809a000 0x200>;
> -			interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "mcspi2";
> @@ -767,7 +775,7 @@
>  		mcspi3: spi@480b8000 {
>  			compatible = "ti,omap4-mcspi";
>  			reg = <0x480b8000 0x200>;
> -			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "mcspi3";
> @@ -780,7 +788,7 @@
>  		mcspi4: spi@480ba000 {
>  			compatible = "ti,omap4-mcspi";
>  			reg = <0x480ba000 0x200>;
> -			interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			ti,hwmods = "mcspi4";
> -- 
> 1.7.9.5
> 
