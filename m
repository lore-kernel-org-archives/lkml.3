Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3CYPYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:24:11 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44088 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab3CYPYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:24:09 -0400
Message-ID: <51506BED.4040203@interlog.com>
Date: Mon, 25 Mar 2013 11:23:25 -0400
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
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com> <20130325122220.GF2001@game.jcrosoft.org> <5150559D.3030109@interlog.com> <20130325143147.GA20693@game.jcrosoft.org>
In-Reply-To: <20130325143147.GA20693@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-25 10:31 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 09:48 Mon 25 Mar     , Douglas Gilbert wrote:
>> On 13-03-25 08:22 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> On 09:49 Mon 25 Mar     , Nicolas Ferre wrote:
>>>> From: Douglas Gilbert <dgilbert@interlog.com>
>>>>
>>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> ---
>>>>   arch/arm/boot/dts/ariag25.dts | 168 ++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 168 insertions(+)
>>>>   create mode 100644 arch/arm/boot/dts/ariag25.dts
>>>>
>>>> diff --git a/arch/arm/boot/dts/ariag25.dts b/arch/arm/boot/dts/ariag25.dts
>>>> new file mode 100644
>>>> index 0000000..d18ef50
>>>> --- /dev/null
>>>> +++ b/arch/arm/boot/dts/ariag25.dts
>>>> @@ -0,0 +1,168 @@
>>>> +/*
>>>> + * ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
>>>> + *
>>>> + * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
>>>> + *                    Robert Nelson <robertcnelson@gmail.com>
>>>> + *
>>>> + * Licensed under GPLv2 or later.
>>>> + */
>>>> +/dts-v1/;
>>>> +/include/ "at91sam9g25.dtsi"
>>>> +
>>>> +/ {
>>>> +	model = "Acme Systems Aria G25";
>>>> +	compatible = "acme,ariag25", "atmel,at91sam9g25ek", "atmel,at91sam9x5ek",
>>>> +		     "atmel,at91sam9x5", "atmel,at91sam9";
>>> I doube the code is compatible with the 9g25ek
>>>
>>> specially when you do not include it
>>>> +
>>>> +	aliases {
>>>> +		serial4 = &usart3;
>>>> +		serial5 = &uart0;
>>>> +	};
>>> you need to specify all
>>>> +
>>>> +	chosen {
>>>> +		bootargs = "console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait";
>>>> +	};
>>>> +
>>>> +	memory {
>>>> +		/* 128 MB, change this for 256 MB revision */
>>>> +		reg = <0x20000000 0x8000000>;
>>>> +	};
>>>> +
>>>> +	clocks {
>>>> +		#address-cells = <1>;
>>>> +		#size-cells = <1>;
>>>> +		ranges;
>>>> +
>>>> +		main_clock: clock@0 {
>>>> +			compatible = "atmel,osc", "fixed-clock";
>>>> +			clock-frequency = <12000000>;
>>>> +		};
>>>> +	};
>>>> +
>>>> +	ahb {
>>>> +		apb {
>>>> +			mmc0: mmc@f0008000 {
>>>> +				/* N.B. Aria has no SD card detect (CD), assumed present */
>>>> +
>>>> +				pinctrl-0 = <
>>>> +					&pinctrl_mmc0_slot0_clk_cmd_dat0
>>>> +					&pinctrl_mmc0_slot0_dat1_3>;
>>>> +				status = "okay";
>>>> +				slot@0 {
>>>> +					reg = <0>;
>>>> +					bus-width = <4>;
>>>> +				};
>>>> +			};
>>>> +
>>>> +			i2c0: i2c@f8010000 {
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			i2c1: i2c@f8014000 {
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			/* TWD2+TCLK2 hidden behind ethernet, so no i2c2 */
>>>> +
>>>> +			usart0: serial@f801c000 {
>>>> +				pinctrl-0 = <&pinctrl_usart0
>>>> +					     &pinctrl_usart0_rts
>>>> +					     &pinctrl_usart0_cts>;
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			usart1: serial@f8020000 {
>>>> +				pinctrl-0 = <&pinctrl_usart1
>>>> +					     /* &pinctrl_usart1_rts */
>>>> +					     /* &pinctrl_usart1_cts */
>>>> +					    >;
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			usart2: serial@f8024000 {
>>>> +				/* cannot activate RTS2+CTS2, clash with
>>>> +				 * ethernet on PB0 and PB1 */
>>>> +				pinctrl-0 = <&pinctrl_usart2>;
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			usart3: serial@f8028000 {
>>>> +				compatible = "atmel,at91sam9260-usart";
>>>> +				reg = <0xf8028000 0x200>;
>>>> +				interrupts = <8 4 5>;
>>>> +				pinctrl-names = "default";
>>>> +				pinctrl-0 = <&pinctrl_usart3
>>>> +					     /* &pinctrl_usart3_rts */
>>>> +					     /* &pinctrl_usart3_cts */
>>>> +					    >;
>>>> +				status = "okay";
>>>> +			};
>>>> +
>>>> +			macb0: ethernet@f802c000 {
>>>> +				phy-mode = "rmii";
>>>> +				/* following can be overwritten by uboot 'ftd set' command */
>>>> +				local-mac-address = [00 04 25 dd 10 01];
>>> drop this, this is board specific
>>>> +				status = "okay";
>>
>> Also the local-mac-address line is needed since it is edited
>> by u-boot via this line:
>>
>> mod_dtb=fdt addr 0x27FF0000 ; fdt set ${eth0_dt_path}
>> local-mac-address [ ${my_ethaddr} ]
>>
>> Interesting technique that: editing the dtb from u-boot prior to the
>> Linux kernel using it ...
>>
>> So the u-boot environment file actually sets the MAC address. The Aria
>> G25 has no NAND, flash or switches for setting a quasi unique MAC
>> address. There seems to be no way to pass the MAC address on the
>> kernel boot line (there was in the past). That leaves the microSD card
>> and IMO u-boot is the best place to set that MAC address. My guess
>> is that the Aria G25 is not the only board that has this "setting the
>> MAC address" challenge.
>>
>> Finally of course that line is "board specific", that is why the
>> file is called ariag25.dts :-)
> The mac address is board (hw) uniq so no default in the dts, if none present
> the kernel will generate one (private class).

Since when have MAC addresses been hw uniq? My guess is
a huge majority of MAC addresses are set in firmware.
Since many embedded systems with wired ethernet face
this problem, is it the job of Linux to make this more
difficult than it already is?

> If the mac is specifued in the register the kernel re-use it.

Unless u-boot (or whatever) edits the dtb file before the
Linux kernel sees it.

> This is the job of the booloader to set one. The dts in the kernel will be
> used for every Aria not one board in particular

It is the job of someone to set it. A MAC address can be
compiled into u-boot but that is about as useful as
compiling it into Linux kernel.

> if you keep the mac addres in the dts NACK

Seems strange to object to setting
   local-mac-address = [00 00 00 00 00 00];
when if the kernel sees that line it will do exactly the
same thing as without that line? But the advantage of that
line is that it gives the u-boot environment file the
ability to edit the ariag25.dtb before the kernel sees it.
And if the u-boot environment file is properly configured
by the board manufacturer, then a quasi uniq, stable MAC
address is generated.

For more information about this technique see:
   http://www.petalogix.com/support/kb/mac_addr_update


Doug Gilbert

