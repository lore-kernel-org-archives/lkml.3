Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbbAJVdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:33:52 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:56181 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbAJVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:33:50 -0500
MIME-Version: 1.0
In-Reply-To: <20141202135527.GM30369@pengutronix.de>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
	<1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
	<CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
	<20141127101830.GP30369@pengutronix.de>
	<CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
	<20141202135527.GM30369@pengutronix.de>
Date: Sat, 10 Jan 2015 22:33:46 +0100
Message-ID: <CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
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

On Tue, Dec 2, 2014 at 2:55 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

Sorry for taking eternities to get back on this, I ran into a merge window
and some christmas. I do hope we can resolve this in the current
development cycle so we can get this support in.

> On Fri, Nov 28, 2014 at 05:12:44PM +0100, Linus Walleij wrote:
>> On Thu, Nov 27, 2014 at 11:18 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Thu, Nov 27, 2014 at 09:44:42AM +0100, Linus Walleij wrote:
>> >> On Tue, Nov 11, 2014 at 1:38 PM, Hongzhou Yang
>> >> <hongzhou.yang@mediatek.com> wrote:

>> >> > +    node {
>> >> > +     mediatek,pins = <PIN_NUMBER_PINMUX>;
>> >> > +                     GENERIC_PINCONFIG;
>> >> > +    };
>> >>
>> >> As suggested by Sacha, use just "pins" and define the binding as a patch
>> >> to Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> >> that is generic for multiplexing, so we get some order here.
>> >>
>> >> I want you however to put pin multiplexing and pin configuration into
>> >> different nodes if possible. I don't like combines muxing and config
>> >> nodes. If necessary tag the node with something.
>> >
>> > Why? I think the properties can live happily together, even when the
>> > parsing functions go to the pinctrl core.
>>
>> I'm worried about the semantic ambiguity between the pins = <...>;
>> property on different pin controllers, whether they are based on
>> function+group or per-pin. It's not even up to me to decide,
>> this is for the DT binding people.
>>
>> In this case:
>>
>> pins = <MT8135_PIN_100_SDA0__FUNC_SDA0>,
>>           <MT8135_PIN_101_SCL0__FUNC_SCL0>;
>>
>> Each element is a 32bit unsigned where the lower and higher
>> 16 bits have different meanings.
>>
>> In some other pin controller (using generic bindings and
>> already merged! arch/arm/boot/dts/ste-href-ab8500.dtsi):
>>
>> gpio39 {
>>       gpio39_default_mode: gpio39_default {
>>              default_mux {
>>                       function = "gpio";
>>                       groups = "gpio39_a_1";
>>              };
>>              default_cfg {
>>                       pins = "GPIO39_E16";
>>                       input-enable;
>>                       bias-pull-down;
>>              };
>>      };
>> };
>>
>> Can we get away with using the same core parser with this
>> as well, here the nodes are split and using strings to identify
>> pins, not 32bit numbers.
>>
>> I am worried about semantic coexistance...
>
> We could rename the property from 'pins' to 'pinmux' for this variant of
> the binding. Then a parser would know that this property is about pins
> and muxing.

OK sounds like a viable compromise.

I am mostly worried that none of the fine device tree people say
anything about this stuff we're discussing here, maybe absolutely
nobody else understands...

>> >> i2c0_pins_a: i2c0@0 {
>> >>         pins1 {
>> >>                 pins = <MT8135_PIN_100_SDA0>;
>> >>                 function = <MT8135_PIN_100_FUNC_SDA0>;
>> >>         };
>> >
>> > The reason to put this in a single define was to make writing the device
>> > trees less error prone. When you have two arrays you must correlate the
>> > entries.
>>
>> I see the upside. I'm just worried about ambiguity when comparing
>> different device trees to each other, because they should be about
>> readability and understanding, not confusing...
>
> Sorry, given the currently existing devicetrees I don't buy that
> readability argument. Let's look into the snowball example, here ssp0:
>
>         ssp0_snowball_mode: ssp0_snowball_default {
>                 snowball_mux {
>                         ste,function = "ssp0";
>                         ste,pins = "ssp0_a_1";
>                 };
>                 snowball_cfg1 {
>                         ste,pins = "GPIO144_B13"; /* FRM */
>                         ste,config = <&gpio_out_hi>;
>                 };
>                 snowball_cfg2 {
>                         ste,pins = "GPIO145_C13"; /* RXD */
>                         ste,config = <&in_pd>;
>                 };
>                 snowball_cfg3 {
>                         ste,pins =
>                         "GPIO146_D13", /* TXD */
>                         "GPIO143_D12"; /* CLK */
>                         ste,config = <&out_lo>;
>                 };
>         };

I agree the ste,pins is not a good example, it is insane to have
something group and pins mixed, and that is why
I migrated it in the last merge window, notably the pin multiplex thing
so it now looks like this:

                        ssp0 {
                                ssp0_snowball_mode: ssp0_snowball_default {
                                        snowball_mux {
                                                function = "ssp0";
                                                groups = "ssp0_a_1";
                                        };
                                        snowball_cfg1 {
                                                pins = "GPIO144_B13"; /* FRM */
                                                ste,config = <&gpio_out_hi>;
                                        };
(...)

I'm sorry about not migrating the ste,config part to
generic bindings yet :( that is next.

> For the SSP0 it needs the string "ssp0_a_1" which is documented exactly
> nowhere.

Is this a bug report about the documentation? I don't see how
that is relevant to the overall design.

> Only the sourcecode shows that this (totally made up) string
> means that the pins DB8500_PIN_D12, DB8500_PIN_B13, DB8500_PIN_C13 and
> DB8500_PIN_D13 shall be muxed.

So this pins and pins ambiguity (which has nothing to do with the
generic bindings BTW) is now fixed up somewhat. The first thing is
a group, the pins are pin names.

> The corresponding ste,function property
> has the value "ssp0" which again is not documented. The following config
> nodes reference the same pins under a different name: "GPIO144_B13",
> "GPIO145_C13", "GPIO146_D13" and "GPIO143_D12".

Yes, because it references individual pins, not groups. Config
is per-pin, multiplexing is per-group in the Nomadik case.
(Some hardware and drivers are different.)

> Again, these strings are
> completely undocumented and only the sourcecode shows which strings can
> be used for the ste,pins property. Not only that no documentation shows
> which strings are allowed, there's also no documentation which describes
> which combination of strings for the different properties make sense.

OK again a documentation bug report I guess, if you want to I can
add this to the documentation (there are indeed some pin control
drivers that list these groups and functions). This documentation was
not written by me, but I can sure fix it up if that makes you happier.

> The use of ## for concatenating defines in the driver makes the whole
> stuff even harder to understand. It even took me quite a while to
> realize that the binding requires me to configure the muxes in groups,
> but the config as individual pins.

The hardware is such that muxes are in groups and pin config per-pin.
We cannot augment reality, just describe it in an as structured way
as possible.

To add to the complexity, some pin controllers mux things in groups,
some per-pin (like freescale I think?) some controllers even do config
of things like pull-up across groups of pins rather than individually.

> So no, the current devicetrees are
> not about readability.

Is this an argument that goes away if I fix the documentation?

> #define GPIO143_D12_SSP0_CLK    PINMUX_PIN(143, 1)
> #define GPIO144_B13_SSP0_FRM    PINMUX_PIN(144, 1)
> #define GPIO145_C13_SSP0_RXD    PINMUX_PIN(145, 1)
> #define GPIO146_D13_SSP0_TXD    PINMUX_PIN(146, 1)
>
> and we get:
>
>         ssp0_snowball_mode: ssp0_snowball_default {
>                 snowball_cfg1 {
>                         pinmux = <GPIO144_B13_SSP0_FRM>;
>                         ste,config = <&gpio_out_hi>;
>                 };
>                 snowball_cfg2 {
>                         pinmux = <GPIO145_C13_SSP0_RXD>;
>                         ste,config = <&in_pd>;
>                 };
>                 snowball_cfg3 {
>                         pinmux = <GPIO143_D12_SSP0_CLK GPIO146_D13_SSP0_TXD>;
>                         ste,config = <&out_lo>;
>                 };
>         };

But this gives the false impression that pins can be muxed
individually, and it makes it possible to write device trees that
attempt to do so, while in practice it will not perform on the
hardware.

>> >> One node for the multiplexing, one node for the config. This is the
>> >> pattern used by most drivers, so I want to have this structure.
>> >>
>> >> It is also easy to tell one node from the other: if it contains "function"
>> >> we know it's a multiplexing node, if it doesn't, it's a config node.
>> >
>> > So when merging these together a node is always multiplexing and
>> > configuration. But do we really win anything if both are separated? When
>> > both are separated you still need an array of pins in the nodes to
>> > tell which pins this node is for. If this array also contains the
>> > mux information then this won't hurt. You can still ignore it.
>>
>> Well we definately have to support the case with split config and
>> muxing nodes at least. I am very worried that we would get into
>> ambguities where that is not possible.
>
> Sure we have as we cannot change existing bindings,

For Nomadik I did, because there are no deployed systems suffering
from it. I just had to use some board I had to make some kind of
example. I would encourage any other system not deployed in the
masses with flashed-in device trees to do the same as this is
still somewhat in a flux.

I am worried that there is something in your reasoning that sort of
assumes all pin controllers mux pins one-by-one and not in groups.
How do we make it impossible to write a device tree that also
make hardware that do groupwise config viable without ambiguities?

Yours,
Linus Walleij
