Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaEFPBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:01:16 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:54118 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaEFPBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi_0fT4UbfGUp9jkrwYMXgfxC5gmXOBviU9PjAutPdHiw@mail.gmail.com>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-2-git-send-email-bigeasy@linutronix.de>
	<CAOesGMi_0fT4UbfGUp9jkrwYMXgfxC5gmXOBviU9PjAutPdHiw@mail.gmail.com>
Date: Tue, 6 May 2014 10:01:11 -0500
Message-ID: <CANk1AXQXWrsgbypTFENFf+X9yhE2t967icK0=3WAvxCPwsXFYA@mail.gmail.com>
Subject: Re: [PATCH 1/7] ARM: dts: socfpga: add gpio pieces
From: Alan Tull <delicious.quinoa@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Tull <atull@altera.com>, LinusW <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 5:02 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> I saw this patch as it came in through Dinh's pull request, see below:
>
>
> On Sat, Mar 22, 2014 at 9:16 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> The cycloneV has three gpio controllers, the first two with 29 gpios, the last
>> one with 27. This patch adds the three controller with the gpio driver which is
>> now sitting the gpio tree.
>>
>> Cc: devicetree@vger.kernel.org
>> Acked-by: Alan Tull <atull@altera.com>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>> v1…v2:
>>         - #gpio-cells = <2>
>>         - third gpio block has now only 27 gpios
>>
>>  arch/arm/boot/dts/socfpga.dtsi | 64 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 64 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 537f1a5..2a84e67 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -463,6 +463,70 @@
>>                         status = "disabled";
>>                 };
>>
>> +               gpio@ff708000 {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +                       compatible = "snps,dw-apb-gpio";
>> +                       reg = <0xff708000 0x1000>;
>> +                       clocks = <&per_base_clk>;
>> +                       status = "disabled";
>> +
>> +                       gpio0: gpio-controller@0 {
>> +                               compatible = "snps,dw-apb-gpio-port";
>> +                               gpio-controller;
>> +                               #gpio-cells = <2>;
>> +                               snps,nr-gpios = <29>;
>> +                               reg = <0>;
>> +                               interrupt-controller;
>> +                               #interrupt-cells = <2>;
>> +                               interrupts = <0 164 4>;
>> +                       };
>> +               };
>
> This is an odd setup. We usually would have it all in one node, since
> the @ff708000 is the GPIO controller, instead of adding a subnode with
> the actual GPIO info.
>
> So I would have expected something more like:
>
>
> gpio0: gpio-controller@ff708000 {
>                        #address-cells = <1>;
>                        #size-cells = <0>;
>                        compatible = "snps,dw-apb-gpio";
>                        reg = <0xff708000 0x1000>;
>                        interrupts = <0 164 4>;
>                       clocks = <&per_base_clk>;
>                        status = "disabled";
>                        gpio-controller;
>                        #gpio-cells = <2>;
>                        snps,nr-gpios = <29>;
>                        interrupt-controller;
>                        #interrupt-cells = <2>;
>                };
>
>
> ... or is there some underlying reason for having the two-layer
> approach that isn't obvious from this device tree?
>
>
> -Olof

The synopsys gpio ip can have 1, 2, or 3 gpio ports of varying widths
per IP block.  The simpler bindings assume one gpio port per IP block.

Alan Tull
aka
delicious quinoa
