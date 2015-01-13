Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbbAMKF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:05:29 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64145 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbAMKFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:05:23 -0500
MIME-Version: 1.0
In-Reply-To: <20150112122200.GC18908@pengutronix.de>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
	<1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
	<CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
	<20141127101830.GP30369@pengutronix.de>
	<CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
	<20141202135527.GM30369@pengutronix.de>
	<CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
	<20150112122200.GC18908@pengutronix.de>
Date: Tue, 13 Jan 2015 11:05:22 +0100
Message-ID: <CACRpkdYXrdiRWMV8YpxrSLe2rLEV-ZnX7=36w21zGquh==6WgA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, dandan.he@mediatek.com,
        alan.cheng@mediatek.com, toby.liu@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 1:22 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Jan 10, 2015 at 10:33:46PM +0100, Linus Walleij wrote:
>> On Tue, Dec 2, 2014 at 2:55 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

>> > For the SSP0 it needs the string "ssp0_a_1" which is documented exactly
>> > nowhere.
>>
>> Is this a bug report about the documentation? I don't see how
>> that is relevant to the overall design.
>
> The best documentation is one that is not needed. I mandate to use
> defines with combinations of pin with mux setting to reduce the
> necessary documentation to: "Pick one (many) of these and you're done".
> So my criticism here is not mainly that there is no documentation but
> that the necessary documention would be very voluminous.

I don't know. I have since we discussed merged the long
overdue zynq driver that use this generic function+group mechanism.
The docs look like so:

Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
(...)
Required properties for pinmux nodes are:
 - groups: A list of pinmux groups.
 - function: The name of a pinmux function to activate for the specified set
   of groups.

Required properties for configuration nodes:
One of:
 - pins: a list of pin names
 - groups: A list of pinmux groups.

The following generic properties as defined in pinctrl-bindings.txt are valid
to specify in a pinmux subnode:
 groups, function

The following generic properties as defined in pinctrl-bindings.txt are valid
to specify in a pinconf subnode:
 groups, pins, bias-disable, bias-high-impedance, bias-pull-up, slew-rate,
 low-power-disable, low-power-enable

 Valid arguments for 'slew-rate' are '0' and '1' to select between slow and fast
 respectively.

 Valid values for groups are:
   ethernet0_0_grp, ethernet1_0_grp, mdio0_0_grp, mdio1_0_grp,
   qspi0_0_grp, qspi1_0_grp, qspi_fbclk, qspi_cs1_grp, spi0_0_grp,
   spi0_1_grp - spi0_2_grp, spi1_0_grp - spi1_3_grp, sdio0_0_grp - sdio0_2_grp,
   sdio1_0_grp - sdio1_3_grp, sdio0_emio_wp, sdio0_emio_cd, sdio1_emio_wp,
   sdio1_emio_cd, smc0_nor, smc0_nor_cs1_grp, smc0_nor_addr25_grp, smc0_nand,
   can0_0_grp - can0_10_grp, can1_0_grp - can1_11_grp, uart0_0_grp -
uart0_10_grp,
   uart1_0_grp - uart1_11_grp, i2c0_0_grp - i2c0_10_grp, i2c1_0_grp -
i2c1_10_grp,
   ttc0_0_grp - ttc0_2_grp, ttc1_0_grp - ttc1_2_grp, swdt0_0_grp - swdt0_4_grp,
   gpio0_0_grp - gpio0_53_grp, usb0_0_grp, usb1_0_grp

 Valid values for pins are:
   MIO0 - MIO53

 Valid values for function are:
   ethernet0, ethernet1, mdio0, mdio1, qspi0, qspi1, qspi_fbclk, qspi_cs1,
   spi0, spi1, sdio0, sdio0_pc, sdio0_cd, sdio0_wp,
   sdio1, sdio1_pc, sdio1_cd, sdio1_wp,
   smc0_nor, smc0_nor_cs1, smc0_nor_addr25, smc0_nand, can0, can1, uart0, uart1,
   i2c0, i2c1, ttc0, ttc1, swdt0, gpio0, usb0, usb1

(...)

Example:
        pinctrl0: pinctrl@700 {
                compatible = "xlnx,pinctrl-zynq";
                reg = <0x700 0x200>;
                syscon = <&slcr>;

                pinctrl_uart1_default: uart1-default {
                        mux {
                                groups = "uart1_10_grp";
                                function = "uart1";
                        };

                        conf {
                                groups = "uart1_10_grp";
                                slew-rate = <0>;
                                io-standard = <1>;
                        };

                        conf-rx {
                                pins = "MIO49";
                                bias-high-impedance;
                        };

                        conf-tx {
                                pins = "MIO48";
                                bias-disable;
                        };
                };
        };


> Normally it
> must cover all possible combinations of pin/mux settings.

I think it's fairly intuitive to combine function uart1 with
group uart1_10_grp without documenting that this is a
valid combination. For complex stuff it may be complex,
but that is the nature of the complex hardware I think.

>> >         ssp0_snowball_mode: ssp0_snowball_default {
>> >                 snowball_cfg1 {
>> >                         pinmux = <GPIO144_B13_SSP0_FRM>;
>> >                         ste,config = <&gpio_out_hi>;
>> >                 };
>> >                 snowball_cfg2 {
>> >                         pinmux = <GPIO145_C13_SSP0_RXD>;
>> >                         ste,config = <&in_pd>;
>> >                 };
>> >                 snowball_cfg3 {
>> >                         pinmux = <GPIO143_D12_SSP0_CLK GPIO146_D13_SSP0_TXD>;
>> >                         ste,config = <&out_lo>;
>> >                 };
>> >         };
>>
>> But this gives the false impression that pins can be muxed
>> individually, and it makes it possible to write device trees that
>> attempt to do so, while in practice it will not perform on the
>> hardware.
>
> If I understand the driver correctly on snowball (ab8500, right?)

No that is drivers/pinctrl/nomadik/pinctrl-nomadik.c
and the db8500 subdriver pinctrl-nomadik-db8500.c

> the
> pins can be muxed individually.

Nope. They have individual registers per-pin, but if you try to
mux them in certain ways you will screw up the hardware or
even cause damage.

They also have to be reconfigured in batch in order to avoid
glitches on the lines, causing spurious IRQs & stuff.

So the driver has to restrict this by enforcing a groups concept
which is there in the hardware, but which is not visible in
the register map.

We have another driver under review, the Broadcom Cygnus.
This one configures a whole patch of pins with a single
register write and thus even reflects the non-one-register-per-pin
layout of the hardware in the register map.
http://marc.info/?l=linux-kernel&m=142113721817137&w=2

>> I am worried that there is something in your reasoning that sort of
>> assumes all pin controllers mux pins one-by-one and not in groups.
>> How do we make it impossible to write a device tree that also
>> make hardware that do groupwise config viable without ambiguities?
>
> Sorry, I don't understand this sentence. What do you mean here?
>
> The bindings I suggested are for individual pin based controllers
> only. I know there are group based controllers, but I don't want to
> change their bindings. I believe there is no single binding that is
> good for both types of controllers.
>
> I think we must face it that individual pin based controllers are
> different from group based controllers. That's the main difference
> between different pin controllers and I think there are good reasons
> to reflect that in the device tree.

OK let's work on a binding for this usecase.

> You often talk about ambiguities. Could you give an example what
> ambiguities you mean?

What happened was this pins = ; arguments were sometimes
strings and sometimes integers, that becomes strange to handle
in code, ambiguous.

I'm fuzzily referring to the concept of things being named the
same way in different device trees, yet lacking commonality,
confusing a human reader that they may be the same thing,
even if it is possible to write schemas and parsers handling
it unambigously, so not ambiguity in the formal logic sense.

If i later want to refactor the code around this to a central
parser I cannot do so because it would lead to formal ambiguities
and is non-doable.

> Note that the way we combine pin/mux in a single define is not new,
> the i.MX pin controller uses this already and so far I'm not aware of
> any problems this makes.

Yeah we never had time to sit down and come up with proper
generic pin control bindings, we went with custom bindings
partly because of general disagreements, partly because I
was new to device tree and honestly had no idea of how
to skin this cat.

Now that we get to formalize generic bindings for DT and
ACPI and whatever alike, I prefer if we make both groupwise
and per-pin pin controllers as strict and well defined as
possible.

One minor problem I have with using an integer for mux config
is that it assumes something about how many pins, configs etc
that may exist on such a system. This should be stated
explicitly in the bindings atleast so we know what restrictions
we build into them. String-based function+group matching has
no such restrictions.

Yours,
Linus Walleij
