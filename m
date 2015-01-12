Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbbALMW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:22:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53447 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbALMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:22:25 -0500
Date: Mon, 12 Jan 2015 13:22:00 +0100
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
Message-ID: <20150112122200.GC18908@pengutronix.de>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
 <1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
 <CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
 <20141127101830.GP30369@pengutronix.de>
 <CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
 <20141202135527.GM30369@pengutronix.de>
 <CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:11:58 up 88 days, 20:25, 101 users,  load average: 0.15, 0.08,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Jan 10, 2015 at 10:33:46PM +0100, Linus Walleij wrote:
> On Tue, Dec 2, 2014 at 2:55 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> Sorry for taking eternities to get back on this, I ran into a merge window
> and some christmas. I do hope we can resolve this in the current
> development cycle so we can get this support in.

No problem, I'm sure there are nicer things to do than discussing about
this topic ;)
I also hope we get this from the table soon.

> >>
> >> I am worried about semantic coexistance...
> >
> > We could rename the property from 'pins' to 'pinmux' for this variant of
> > the binding. Then a parser would know that this property is about pins
> > and muxing.
> 
> OK sounds like a viable compromise.

Ok, will change this.

> I'm sorry about not migrating the ste,config part to
> generic bindings yet :( that is next.
> 
> > For the SSP0 it needs the string "ssp0_a_1" which is documented exactly
> > nowhere.
> 
> Is this a bug report about the documentation? I don't see how
> that is relevant to the overall design.

The best documentation is one that is not needed. I mandate to use
defines with combinations of pin with mux setting to reduce the
necessary documentation to: "Pick one (many) of these and you're done".
So my criticism here is not mainly that there is no documentation but
that the necessary documention would be very voluminous. Normally it
must cover all possible combinations of pin/mux settings. If you add
this you can equally well add it to defines instead, which makes it
impossible to write inconsistent device trees and makes it easier to
understand what's happening.

> 
> > Only the sourcecode shows that this (totally made up) string
> > means that the pins DB8500_PIN_D12, DB8500_PIN_B13, DB8500_PIN_C13 and
> > DB8500_PIN_D13 shall be muxed.
> 
> So this pins and pins ambiguity (which has nothing to do with the
> generic bindings BTW) is now fixed up somewhat. The first thing is
> a group, the pins are pin names.
> 
> > The corresponding ste,function property
> > has the value "ssp0" which again is not documented. The following config
> > nodes reference the same pins under a different name: "GPIO144_B13",
> > "GPIO145_C13", "GPIO146_D13" and "GPIO143_D12".
> 
> Yes, because it references individual pins, not groups. Config
> is per-pin, multiplexing is per-group in the Nomadik case.
> (Some hardware and drivers are different.)
> 
> > Again, these strings are
> > completely undocumented and only the sourcecode shows which strings can
> > be used for the ste,pins property. Not only that no documentation shows
> > which strings are allowed, there's also no documentation which describes
> > which combination of strings for the different properties make sense.
> 
> OK again a documentation bug report I guess, if you want to I can
> add this to the documentation (there are indeed some pin control
> drivers that list these groups and functions). This documentation was
> not written by me, but I can sure fix it up if that makes you happier.
> 
> > The use of ## for concatenating defines in the driver makes the whole
> > stuff even harder to understand. It even took me quite a while to
> > realize that the binding requires me to configure the muxes in groups,
> > but the config as individual pins.
> 
> The hardware is such that muxes are in groups and pin config per-pin.
> We cannot augment reality, just describe it in an as structured way
> as possible.
> 
> To add to the complexity, some pin controllers mux things in groups,
> some per-pin (like freescale I think?) some controllers even do config
> of things like pull-up across groups of pins rather than individually.
> 
> > So no, the current devicetrees are
> > not about readability.
> 
> Is this an argument that goes away if I fix the documentation?
> 
> > #define GPIO143_D12_SSP0_CLK    PINMUX_PIN(143, 1)
> > #define GPIO144_B13_SSP0_FRM    PINMUX_PIN(144, 1)
> > #define GPIO145_C13_SSP0_RXD    PINMUX_PIN(145, 1)
> > #define GPIO146_D13_SSP0_TXD    PINMUX_PIN(146, 1)
> >
> > and we get:
> >
> >         ssp0_snowball_mode: ssp0_snowball_default {
> >                 snowball_cfg1 {
> >                         pinmux = <GPIO144_B13_SSP0_FRM>;
> >                         ste,config = <&gpio_out_hi>;
> >                 };
> >                 snowball_cfg2 {
> >                         pinmux = <GPIO145_C13_SSP0_RXD>;
> >                         ste,config = <&in_pd>;
> >                 };
> >                 snowball_cfg3 {
> >                         pinmux = <GPIO143_D12_SSP0_CLK GPIO146_D13_SSP0_TXD>;
> >                         ste,config = <&out_lo>;
> >                 };
> >         };
> 
> But this gives the false impression that pins can be muxed
> individually, and it makes it possible to write device trees that
> attempt to do so, while in practice it will not perform on the
> hardware.

If I understand the driver correctly on snowball (ab8500, right?) the
pins can be muxed individually. If you say that does not perform on the
hardware, that's something different. If a board designer decides to use
a pin northeast on the BGA and a pin southwest together for a single
I2C bus, then I as a device tree writer have no other choice but to
support this case, no matter if it's ideal or not. What's written in the
devicetree is dictated by the board designers, not the devicetree
writers.
I don't think board designers will create such a hardware just because
the Linux driver supports this. More likely they will create such a
hardware even though Linux does not support it ;)

> 
> >> >> One node for the multiplexing, one node for the config. This is the
> >> >> pattern used by most drivers, so I want to have this structure.
> >> >>
> >> >> It is also easy to tell one node from the other: if it contains "function"
> >> >> we know it's a multiplexing node, if it doesn't, it's a config node.
> >> >
> >> > So when merging these together a node is always multiplexing and
> >> > configuration. But do we really win anything if both are separated? When
> >> > both are separated you still need an array of pins in the nodes to
> >> > tell which pins this node is for. If this array also contains the
> >> > mux information then this won't hurt. You can still ignore it.
> >>
> >> Well we definately have to support the case with split config and
> >> muxing nodes at least. I am very worried that we would get into
> >> ambguities where that is not possible.
> >
> > Sure we have as we cannot change existing bindings,
> 
> For Nomadik I did, because there are no deployed systems suffering
> from it. I just had to use some board I had to make some kind of
> example. I would encourage any other system not deployed in the
> masses with flashed-in device trees to do the same as this is
> still somewhat in a flux.

In certain cases it may make sense to break existing device trees, I
just wanted to express that with any kind of generic binding I don't
want to enforce breaking existing bindings.

> 
> I am worried that there is something in your reasoning that sort of
> assumes all pin controllers mux pins one-by-one and not in groups.
> How do we make it impossible to write a device tree that also
> make hardware that do groupwise config viable without ambiguities?

Sorry, I don't understand this sentence. What do you mean here?

The bindings I suggested are for individual pin based controllers
only. I know there are group based controllers, but I don't want to
change their bindings. I believe there is no single binding that is
good for both types of controllers.

I think we must face it that individual pin based controllers are
different from group based controllers. That's the main difference
between different pin controllers and I think there are good reasons
to reflect that in the device tree.

You often talk about ambiguities. Could you give an example what
ambiguities you mean? I can't think of a situation where the device tree
is ambiguous. I can only think of a common device tree parser that
misinterpretes the device tree, but that would be a problem in the
implementation, not with the binding.

Note that the way we combine pin/mux in a single define is not new,
the i.MX pin controller uses this already and so far I'm not aware of
any problems this makes. I wouldn't integrate the pinconf settings
in the same define again though, but for this part we have the generic
pinconf bindings.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
