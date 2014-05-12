Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaELT7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:59:21 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54873 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaELT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140512195050.GB5668@atomide.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
	<20140512195050.GB5668@atomide.com>
Date: Mon, 12 May 2014 14:59:18 -0500
Message-ID: <CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
From: Robert Nelson <robertcnelson@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Matt Ranostay <mranostay@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        pantelis.antoniou@gmail.com, matt.porter@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> +     i2c2_pins: pinmux_i2c2_pins {
>> +             pinctrl-single,pins = <
>> +                     0x178 (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1_ctsn.i2c2_sda */
>> +                     0x17c (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1_rtsn.i2c2_scl */
>> +             >;
>> +     };
>> +
>>       uart0_pins: pinmux_uart0_pins {
>>               pinctrl-single,pins = <
>>                       0x170 (PIN_INPUT_PULLUP | MUX_MODE0)    /* uart0_rxd.uart0_rxd */
>>
>> @@ -222,6 +229,15 @@
>>
>>  };
>>
>> +
>> +&i2c2 {
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = <&i2c2_pins>;
>> +
>> +     status = "okay";
>> +     clock-frequency = <100000>;
>> +};
>> +
>
> If these pins are not used for i2c2 on some capes, this device
> should be set to status = "disabled" state by default. Then
> u-boot could re-enable it on the boards that have i2c2 in use.

To-date, this is the i2c bus that all capes have placed an at24 eeprom
for cape identification.

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
