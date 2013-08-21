Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3HUP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:58:18 -0400
Received: from mail.abilis.ch ([195.70.19.74]:25261 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3HUP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:58:16 -0400
Date: Wed, 21 Aug 2013 17:57:51 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130821155751.GB3046@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
 <20130805115118.GF20936@ab42.lan>
 <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 06:53:56PM +0200, Linus Walleij wrote:
> On Mon, Aug 5, 2013 at 1:51 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> > [Me]
> >> I don't see any of the port concept creeping into the device tree
> >> in this version and that is how I think it should be kept:
> >> the "port" particulars is a thing for the driver and not the
> >> device tree.
> >
> > I'm not sure if everybody is aligned here (or if we even understand each
> > other): In my terminology, a "port" is a set of pins controlled by the
> > same register/bit field.
> 
> OK, that can also be called a "bank" or "register" but whatever.

As you suggested below I re-read Documentation/pinctrl.txt and it got me
even more confused:
Am I right in my understanding that the whole concept of a
"port/bank/register" or whatever we would like to call it does not exist
in the pinctrl framework?

> > An "interface" is a set of pins which form a
> > functional unit, e.g. an SPI interface.
> 
> This is called a pinmux setting in the pinctrl terminology.

Actually, I was more thinking of the association of a function to a pin
group. It comes probably closest to a mapping in
Documentation/pinctrl.txt terminology although I'm not sure if an
interface and a mapping are 100% identical. An interface is not
necessarily mapped so it is probably rather what one could call a
potential mapping.

> A group is a number of pins, a function is a functionality such as SPI.
> When the function SPI is combined with a group of pins in a map, it
> creates a pinmux setting.

What is the difference between a map and a pinmux setting? Or are they
the same?

> [...]
> > In the driver under discussion, pin groups are defined for every
> > "interface" to make sure that interfaces can be requested in an
> > orthogonal way by different modules and modules don't have to be "aware"
> > of which interfaces are grouped into which port (and which other modules
> > request which other interfaces). A request either succeeds or fails.
> > Resource management (which interfaces can be mapped simultaneously) is
> > done inside the pinctrl driver.
> 
> OK

This actually looks 100% coherent with Documentation/pinctrl.txt. But
then I don't understand Stephen's request to introduce the concept of
"ports" in the device tree. IMHO ports are a hardware limitation which
should be managed inside the pinctrl driver and if possible not leak
out of it. Also (as stated above), the concept of "ports" does not even
exist in the pinmux framework so why introduce it for DT?

I might have thoroughly misunderstood you here, Stephen. Please be
patient with me and explain once more.

> > If I understand Stephen correctly, the traditional way of requesting pin
> > configurations is at "port" level, e.g. a configuration is defined by a
> > port and its mux setting.
> 
> Now it is ever more confused.
> 
> Pin configuration is about things like pull-up in pinctrl terminology.

Sorry, my fault. I wanted to say pin muxing. What I call configuration
above is a mux configuration (i.e. a register field setting). The whole
concept of functions and groups as I understand it from
Documentation/pinctrl.txt does not seem to apply to my understanding of
Stephen's request. As I said, I probably misunderstood Stephen
completely here and would be thankful for clarification.

> Please talk about functions, groups and settings that combine
> functions with groups.
> 
> > The TB10x driver works on a higher level of
> > abstraction ("interface" level), where interfaces are requested and the
> > driver internally decides which configuration(s) to apply to which
> > port(s). Ports are not used in the device tree indeed, but interfaces
> > are.
> >
> > Based on this, I don't quite understand your comment: You say you don't
> > like ports starting to leak outside of the pinctrl driver but according
> > to Stephen that's what is common practice today? Did you mean
> > interfaces? The TB10x driver's configuration nodes are currently defined
> > based on interfaces.
> 
> I think that language is part of the problem here.
> 
> Can you please double-check my definitions of terms in
> Documentation/pinctrl.txt so we are talking the same language?

Did it and promise to use Documentation/pinctrl.txt language where
applicable (I haven't found an equivalent for "port", though, and as I
stated above I consider this a Good Thing since IMHO ports should remain
a private concept inside the driver).

Greetings,
  Christian
