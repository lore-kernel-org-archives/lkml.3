Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3CYMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:34:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34527 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038Ab3CYMee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:34:34 -0400
Message-ID: <51504433.5000801@interlog.com>
Date: Mon, 25 Mar 2013 08:33:55 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        tanzilli@acmesystems.it, Robert.Nelson@digikey.com
Subject: Re: [PATCH] ARM: at91: add Acme Systems Aria G25 board
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com> <20130325122220.GF2001@game.jcrosoft.org>
In-Reply-To: <20130325122220.GF2001@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-25 08:22 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 09:49 Mon 25 Mar     , Nicolas Ferre wrote:
>> From: Douglas Gilbert <dgilbert@interlog.com>
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>   arch/arm/boot/dts/ariag25.dts | 168 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 168 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/ariag25.dts
>>
>> diff --git a/arch/arm/boot/dts/ariag25.dts b/arch/arm/boot/dts/ariag25.dts
>> new file mode 100644
>> index 0000000..d18ef50
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/ariag25.dts
>> @@ -0,0 +1,168 @@
>> +/*
>> + * ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
>> + *
>> + * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
>> + *                    Robert Nelson <robertcnelson@gmail.com>
>> + *
>> + * Licensed under GPLv2 or later.
>> + */
>> +/dts-v1/;
>> +/include/ "at91sam9g25.dtsi"
>> +
>> +/ {
>> +	model = "Acme Systems Aria G25";
>> +	compatible = "acme,ariag25", "atmel,at91sam9g25ek", "atmel,at91sam9x5ek",
>> +		     "atmel,at91sam9x5", "atmel,at91sam9";
> I doube the code is compatible with the 9g25ek
>
> specially when you do not include it
>> +
>> +	aliases {
>> +		serial4 = &usart3;
>> +		serial5 = &uart0;
>> +	};
> you need to specify all
>> +
>> +	chosen {
>> +		bootargs = "console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait";
>> +	};
>> +
>> +	memory {
>> +		/* 128 MB, change this for 256 MB revision */
>> +		reg = <0x20000000 0x8000000>;
>> +	};
>> +
>> +	clocks {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +
>> +		main_clock: clock@0 {
>> +			compatible = "atmel,osc", "fixed-clock";
>> +			clock-frequency = <12000000>;
>> +		};
>> +	};
>> +
>> +	ahb {
>> +		apb {
>> +			mmc0: mmc@f0008000 {
>> +				/* N.B. Aria has no SD card detect (CD), assumed present */
>> +
>> +				pinctrl-0 = <
>> +					&pinctrl_mmc0_slot0_clk_cmd_dat0
>> +					&pinctrl_mmc0_slot0_dat1_3>;
>> +				status = "okay";
>> +				slot@0 {
>> +					reg = <0>;
>> +					bus-width = <4>;
>> +				};
>> +			};
>> +
>> +			i2c0: i2c@f8010000 {
>> +				status = "okay";
>> +			};
>> +
>> +			i2c1: i2c@f8014000 {
>> +				status = "okay";
>> +			};
>> +
>> +			/* TWD2+TCLK2 hidden behind ethernet, so no i2c2 */
>> +
>> +			usart0: serial@f801c000 {
>> +				pinctrl-0 = <&pinctrl_usart0
>> +					     &pinctrl_usart0_rts
>> +					     &pinctrl_usart0_cts>;
>> +				status = "okay";
>> +			};
>> +
>> +			usart1: serial@f8020000 {
>> +				pinctrl-0 = <&pinctrl_usart1
>> +					     /* &pinctrl_usart1_rts */
>> +					     /* &pinctrl_usart1_cts */
>> +					    >;
>> +				status = "okay";
>> +			};
>> +
>> +			usart2: serial@f8024000 {
>> +				/* cannot activate RTS2+CTS2, clash with
>> +				 * ethernet on PB0 and PB1 */
>> +				pinctrl-0 = <&pinctrl_usart2>;
>> +				status = "okay";
>> +			};
>> +
>> +			usart3: serial@f8028000 {
>> +				compatible = "atmel,at91sam9260-usart";
>> +				reg = <0xf8028000 0x200>;
>> +				interrupts = <8 4 5>;
>> +				pinctrl-names = "default";
>> +				pinctrl-0 = <&pinctrl_usart3
>> +					     /* &pinctrl_usart3_rts */
>> +					     /* &pinctrl_usart3_cts */
>> +					    >;
>> +				status = "okay";
>> +			};
>> +
>> +			macb0: ethernet@f802c000 {
>> +				phy-mode = "rmii";
>> +				/* following can be overwritten by uboot 'ftd set' command */
>> +				local-mac-address = [00 04 25 dd 10 01];
> drop this, this is board specific
>> +				status = "okay";

Why not leave it but change the data to 00 00 00 00 00 00.
It is a useful technique and really hard to find.

Trying to find a Linux embedded system with an IP address
the jumps around (because it finds a 00 00 00 00 00 00 MAC
address) can be very frustrating. Showing folks where they
can give a non-NULL MAC address may save a lot of frustration.

Doug Gilbert


