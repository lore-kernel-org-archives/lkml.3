Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3EXRCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:02:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24654 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3EXRCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:02:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+qtp9SrS76T8HF7tB+td9iaNOCMxdRHbI=
Date: Fri, 24 May 2013 13:01:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 2/2] net: mv643xx_eth: proper initialization for
 Kirkwood SoCs
Message-ID: <20130524170125.GX31290@titan.lakedaemon.net>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369253042-15082-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130522201607.GA18823@obsidianresearch.com>
 <20130523160111.GP31290@titan.lakedaemon.net>
 <20130523171112.GB31281@obsidianresearch.com>
 <20130523172339.GQ31290@titan.lakedaemon.net>
 <20130523175357.GB2821@obsidianresearch.com>
 <20130523184028.GU31290@titan.lakedaemon.net>
 <519E9ADA.3040204@gmail.com>
 <CACRpkdbsicPkPAiaQCOg2mQF2Ce2dg_K=BKqqx=FCdAH7Y+QBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbsicPkPAiaQCOg2mQF2Ce2dg_K=BKqqx=FCdAH7Y+QBg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 01:03:25PM +0200, Linus Walleij wrote:
> On Fri, May 24, 2013 at 12:40 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
> > On 05/23/2013 08:40 PM, Jason Cooper wrote:
> 
> >> I think marvell,psc1_reset =<>; gives us the most flexibility in
> >> accurately describing the hardware.
> >
> >
> > IMHO using that is just another workaround for a broken driver. We
> > could hack the whole register setup in DT as it would still accurately
> > describe HW. Don't get me wrong, but I don't like it.
> >
> > Haven't checked how happy Linus Walleij is about pinctrl drivers with
> > reg values hacked in lately.
> 
> One of the things I've been ranting about lately is that Linux
> subsystem maintainers have become de-facto device tree
> standard commite chairs. :-(

This is the first I've heard this rant.  :(

To that end, I agree with you.  My frustration boiled down to trying to
predict the future, which is futile. :-P

For our scenario, once we can confirm our least popular kirkwood
variant, the 6282, behaves the same as we've seen so far, then
"marvell,kirkwood-eth" is fine by me.

> So to the actual question:
> 
> In general I think we need to draw a line and define what we
> mean with "describing the hardware" in a device tree.
> 
> We have some consensus:
> - <reg> properties to describe regsiter BASE offset in physical
>   memory and size.
> - Resources like IRQ, DMA channel, regulator, GPIO pin control
>   handles, are passed using <&ampersand> notation.
> 
> And so it goes on.
> 
> When it comes to defining different registers and their individual
> bits and the meaning of these and/or default values, I personally
> think that is making things harder for developers rather than
> simplifying things. I know that pinctrl-single is anyway doing this
> and I was talked into accepting it under circumstances where
> developers are being passed opaque machine-generated
> data that would otherwise be translated into unreadable header
> files littering the kernel.
> 
> For a coder it is definately better if the *driver* know these
> details, but whether that is possible seems to depend on things
> like hardware development process.

Agree.

> IMO: if you want to go down that road, what you really want is not
> ever more expressible device trees, but real open firmware,
> or ACPI or UEFI that can interpret and run bytecode as some
> "bios" for you. With DT coming from OF maybe this is a natural
> progression of things, but one has to realize when we reach the
> point where what we really want is a bios. Then your time is
> likely better spent with Tianocore or something than with the
> kernel.

shudder.  I like embedded systems because the *don't* have a bios.

thx,

Jason.
