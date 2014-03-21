Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaCUWPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:15:19 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54009 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaCUWPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
	<1395345324-18299-4-git-send-email-bigeasy@linutronix.de>
	<CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com>
Date: Fri, 21 Mar 2014 17:15:14 -0500
Message-ID: <CANk1AXSQVFZvRmvYt+JF+TDVpfX-_RLiUcQXotGzpHoTMUVymQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 1:14 PM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:
> On Thu, Mar 20, 2014 at 2:55 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> The cycloneV has three gpio controllers, each one with 29 gpios. This patch
>> adds the three controller with the gpio driver which is now sitting the
>> gpio tree.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>>  arch/arm/boot/dts/socfpga.dtsi | 60 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 60 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 537f1a5..c3a97e1 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -463,6 +463,66 @@
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
>> +                               #gpio-cells = <1>;
>
> #gpio-cells = <2>;
>
> I applied this patch, fixed the gpio-cells, tested on a cyclone5 soc
> devkit, and see that it breaks the interrupts.  Did you test this?
>
> Alan
>
>> +                               snps,nr-gpios = <29>;
>> +                               reg = <0>;
>> +                               interrupt-controller;
>> +                               #interrupt-cells = <2>;
>> +                               interrupts = <0 164 4>;
>> +                       };
>> +               };
>> +
>> +               gpio@ff709000 {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +                       compatible = "snps,dw-apb-gpio";
>> +                       reg = <0xff709000 0x1000>;
>> +                       clocks = <&per_base_clk>;
>> +                       status = "disabled";
>> +
>> +                       gpio1: gpio-controller@0 {
>> +                               compatible = "snps,dw-apb-gpio-port";
>> +                               gpio-controller;
>> +                               #gpio-cells = <1>;
>> +                               snps,nr-gpios = <29>;
>> +                               reg = <0>;
>> +                               interrupt-controller;
>> +                               #interrupt-cells = <2>;
>> +                               interrupts = <0 165 4>;
>> +                       };
>> +               };
>> +
>> +               gpio@ff70a000 {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +                       compatible = "snps,dw-apb-gpio";
>> +                       reg = <0xff70a000 0x1000>;
>> +                       clocks = <&per_base_clk>;
>> +                       status = "disabled";
>> +
>> +                       gpio2: gpio-controller@0 {
>> +                               compatible = "snps,dw-apb-gpio-port";
>> +                               gpio-controller;
>> +                               #gpio-cells = <1>;
>> +                               snps,nr-gpios = <29>;

snps,nr-gpios = <27>;

As noted on other thread, gpio2 is 27 wide, despite what the
documentation says.  When I made that change and remove your other two
patches the gpios worked for me on a cyclone5 devkit board.

So if you fix the "#gpio-cells = <2>;" for all 3 gpios and fix
"snps,nr-gpios = <27>;" for gpio2, then this one patch looks good to
me.  With these changes,

Acked-by: Alan Tull <atull@altera.com>

Alan Tull
aka
delicous quinoa


>> +                               reg = <0>;
>> +                               interrupt-controller;
>> +                               #interrupt-cells = <2>;
>> +                               interrupts = <0 166 4>;
>> +                       };
>> +               };
>> +
>>                 L2: l2-cache@fffef000 {
>>                         compatible = "arm,pl310-cache";
>>                         reg = <0xfffef000 0x1000>;
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
