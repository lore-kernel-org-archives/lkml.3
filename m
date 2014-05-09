Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaEIQYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:24:49 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52492 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <536CD0D1.4080903@ti.com>
References: <1399614983-552-1-git-send-email-mranostay@gmail.com>
	<536CD0D1.4080903@ti.com>
Date: Fri, 9 May 2014 09:24:46 -0700
Message-ID: <CAKzfze-ijg1GTJzNvhEVN5ULm9q0gQhScLpwC-CLNa90Whf1sg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: am335x-bone-common: Add i2c2 definition
From: Matt Ranostay <mranostay@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Matt Porter <matt.porter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 5:57 AM, Nishanth Menon <nm@ti.com> wrote:
> On Fri 09 May 2014 12:56:23 AM CDT, Matt Ranostay wrote:
>> Add missing i2c2 bus define to access various cape and
>> prototype/breakout board devices.
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>  arch/arm/boot/dts/am335x-bone-common.dtsi | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> index 2e7d932..2aedfee 100644
>> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
>> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> @@ -84,6 +84,13 @@
>>               >;
>>       };
>>
>> +     i2c2_pins: pinmux_i2c2_pins {
>> +             pinctrl-single,pins = <
>> +                     0x178 (PIN_INPUT_PULLUP | MUX_MODE3)    /* i2c2_sda.uart1_ctsn */
>> +                     0x17c (PIN_INPUT_PULLUP | MUX_MODE3)    /* i2c2_scl.uart1_rtsn */
>
> I dont understand the comment -> i2c2_sda is being muxed to uart1_cstsn?
>
Good catch I mixed up the ordering of the comment.

>> +             >;
>> +     };
>> +
>>       uart0_pins: pinmux_uart0_pins {
>>               pinctrl-single,pins = <
>>                       0x170 (PIN_INPUT_PULLUP | MUX_MODE0)    /* uart0_rxd.uart0_rxd */
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
>> +     clock-frequency = <400000>;
>
> How did we decide on 400KHz -> do all all i2c2 devices on ALL capes
> work in full speed? OR should we consider a conservative 100KHz?
>

Probably a better plan.
Will submit v2 this weekend.

>> +};
>> +
>>  /include/ "tps65217.dtsi"
>>
>>  &tps {
>
>
> --
> Regards,
> Nishanth Menon
>
