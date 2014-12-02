Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaLBN4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:56:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLBN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:56:11 -0500
Date: Tue, 2 Dec 2014 14:55:27 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
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
        Heiko =?iso-8859-15?Q?St=FCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, dandan.he@mediatek.com,
        alan.cheng@mediatek.com, toby.liu@mediatek.com
Subject: Re: [PATCH v3 2/3] dt-bindings: Add pinctrl bindings for
 mt65xx/mt81xx.
Message-ID: <20141202135527.GM30369@pengutronix.de>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
 <1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
 <CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
 <20141127101830.GP30369@pengutronix.de>
 <CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:31 up 47 days, 20:29, 61 users,  load average: 0.09, 0.13,
 0.18
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Nov 28, 2014 at 05:12:44PM +0100, Linus Walleij wrote:
> On Thu, Nov 27, 2014 at 11:18 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Thu, Nov 27, 2014 at 09:44:42AM +0100, Linus Walleij wrote:
> >> On Tue, Nov 11, 2014 at 1:38 PM, Hongzhou Yang
> >> <hongzhou.yang@mediatek.com> wrote:
> 
> >> > +- mediatek,pins: 2 integers array, represents gpio pinmux number and config
> >> > +  setting. The format as following
> >> > +
> >> > +    node {
> >> > +     mediatek,pins = <PIN_NUMBER_PINMUX>;
> >> > +                     GENERIC_PINCONFIG;
> >> > +    };
> >>
> >> As suggested by Sacha, use just "pins" and define the binding as a patch
> >> to Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> >> that is generic for multiplexing, so we get some order here.
> >>
> >> I want you however to put pin multiplexing and pin configuration into
> >> different nodes if possible. I don't like combines muxing and config
> >> nodes. If necessary tag the node with something.
> >
> > Why? I think the properties can live happily together, even when the
> > parsing functions go to the pinctrl core.
> 
> I'm worried about the semantic ambiguity between the pins = <...>;
> property on different pin controllers, whether they are based on
> function+group or per-pin. It's not even up to me to decide,
> this is for the DT binding people.
> 
> In this case:
> 
> pins = <MT8135_PIN_100_SDA0__FUNC_SDA0>,
>           <MT8135_PIN_101_SCL0__FUNC_SCL0>;
> 
> Each element is a 32bit unsigned where the lower and higher
> 16 bits have different meanings.
> 
> In some other pin controller (using generic bindings and
> already merged! arch/arm/boot/dts/ste-href-ab8500.dtsi):
> 
> gpio39 {
>       gpio39_default_mode: gpio39_default {
>              default_mux {
>                       function = "gpio";
>                       groups = "gpio39_a_1";
>              };
>              default_cfg {
>                       pins = "GPIO39_E16";
>                       input-enable;
>                       bias-pull-down;
>              };
>      };
> };
> 
> Can we get away with using the same core parser with this
> as well, here the nodes are split and using strings to identify
> pins, not 32bit numbers.
> 
> I am worried about semantic coexistance...

We could rename the property from 'pins' to 'pinmux' for this variant of
the binding. Then a parser would know that this property is about pins
and muxing.

> 
> >> > +               i2c0_pins_a: i2c0@0 {
> >> > +                       pins1 {
> >> > +                               mediatek,pins = <MT8135_PIN_100_SDA0__FUNC_SDA0>,
> >> > +                                               <MT8135_PIN_101_SCL0__FUNC_SCL0>;
> >> > +                               bias-disable;
> >> > +                       };
> >> > +               };
> >>
> >> I would split it up.
> >>
> >> i2c0_pins_a: i2c0@0 {
> >>         pins1 {
> >>                 pins = <MT8135_PIN_100_SDA0>;
> >>                 function = <MT8135_PIN_100_FUNC_SDA0>;
> >>         };
> >
> > The reason to put this in a single define was to make writing the device
> > trees less error prone. When you have two arrays you must correlate the
> > entries.
> 
> I see the upside. I'm just worried about ambiguity when comparing
> different device trees to each other, because they should be about
> readability and understanding, not confusing...

Sorry, given the currently existing devicetrees I don't buy that
readability argument. Let's look into the snowball example, here ssp0:

	ssp0_snowball_mode: ssp0_snowball_default {
		snowball_mux {
			ste,function = "ssp0";
			ste,pins = "ssp0_a_1";
		};
		snowball_cfg1 {
			ste,pins = "GPIO144_B13"; /* FRM */
			ste,config = <&gpio_out_hi>;
		};
		snowball_cfg2 {
			ste,pins = "GPIO145_C13"; /* RXD */
			ste,config = <&in_pd>;
		};
		snowball_cfg3 {
			ste,pins =
			"GPIO146_D13", /* TXD */
			"GPIO143_D12"; /* CLK */
			ste,config = <&out_lo>;
		};
	};


For the SSP0 it needs the string "ssp0_a_1" which is documented exactly
nowhere. Only the sourcecode shows that this (totally made up) string
means that the pins DB8500_PIN_D12, DB8500_PIN_B13, DB8500_PIN_C13 and
DB8500_PIN_D13 shall be muxed. The corresponding ste,function property
has the value "ssp0" which again is not documented. The following config
nodes reference the same pins under a different name: "GPIO144_B13",
"GPIO145_C13", "GPIO146_D13" and "GPIO143_D12". Again, these strings are
completely undocumented and only the sourcecode shows which strings can
be used for the ste,pins property. Not only that no documentation shows
which strings are allowed, there's also no documentation which describes
which combination of strings for the different properties make sense.
The use of ## for concatenating defines in the driver makes the whole
stuff even harder to understand. It even took me quite a while to
realize that the binding requires me to configure the muxes in groups,
but the config as individual pins. So no, the current devicetrees are
not about readability.

Rewrite this to:

#define GPIO143_D12_SSP0_CLK	PINMUX_PIN(143, 1)
#define GPIO144_B13_SSP0_FRM	PINMUX_PIN(144, 1)
#define GPIO145_C13_SSP0_RXD	PINMUX_PIN(145, 1)
#define GPIO146_D13_SSP0_TXD	PINMUX_PIN(146, 1)

and we get:

	ssp0_snowball_mode: ssp0_snowball_default {
		snowball_cfg1 {
			pinmux = <GPIO144_B13_SSP0_FRM>;
			ste,config = <&gpio_out_hi>;
		};
		snowball_cfg2 {
			pinmux = <GPIO145_C13_SSP0_RXD>;
			ste,config = <&in_pd>;
		};
		snowball_cfg3 {
			pinmux = <GPIO143_D12_SSP0_CLK GPIO146_D13_SSP0_TXD>;
			ste,config = <&out_lo>;
		};
	};

And the documentation we need is: "For the pinmux property pick macros
from dt-bindings/.../xy.h"

> 
> >> One node for the multiplexing, one node for the config. This is the
> >> pattern used by most drivers, so I want to have this structure.
> >>
> >> It is also easy to tell one node from the other: if it contains "function"
> >> we know it's a multiplexing node, if it doesn't, it's a config node.
> >
> > So when merging these together a node is always multiplexing and
> > configuration. But do we really win anything if both are separated? When
> > both are separated you still need an array of pins in the nodes to
> > tell which pins this node is for. If this array also contains the
> > mux information then this won't hurt. You can still ignore it.
> 
> Well we definately have to support the case with split config and
> muxing nodes at least. I am very worried that we would get into
> ambguities where that is not possible.

Sure we have as we cannot change existing bindings, but I cannot see
any ambiguities. In the end it's the SoC specific driver which decides
over the binding. Of course we do ourselves a favor when all use a
similar binding and use common code to parse it, but when everything
else fails we can still make a SoC specific parser. Nobody wants that
of course, we are all lazy ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
