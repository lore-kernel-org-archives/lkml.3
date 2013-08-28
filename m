Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3H1MwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:52:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754969Ab3H1MwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:52:00 -0400
Date: Wed, 28 Aug 2013 14:51:51 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130828145151.6db29d70@skate>
In-Reply-To: <20130828124255.GL6617@n2100.arm.linux.org.uk>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
	<20130828121943.1c8327ca@skate>
	<521DD057.4040208@gmail.com>
	<20130828131548.0009d613@skate>
	<521DE2B3.9050508@gmail.com>
	<20130828135827.2307c89e@skate>
	<20130828121320.GK6617@n2100.arm.linux.org.uk>
	<20130828142909.3521064b@skate>
	<20130828124255.GL6617@n2100.arm.linux.org.uk>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell King - ARM Linux,

On Wed, 28 Aug 2013 13:42:55 +0100, Russell King - ARM Linux wrote:

> > Using the name of the oldest SoC in the family that had the IP block is
> > the norm, because it's really what "compatible" means: the IP block in
> > Dove is *compatible* with the one that was originally introduced in
> > Kirkwood.
> > 
> > See what Rob Herring (one of the DT maintainer) says in
> > http://lists.infradead.org/pipermail/linux-mtd/2012-March/040417.html:
> > 
> > """
> > There is no reason all machines can't use "st,spear600-smi" in their
> > dts. It doesn't have to be a spear600, just compatible with it. Really
> > you want the string to be the oldest SOC the block is in and then newer
> > SOCs can claim compatibility with the old version.
> > """
> > 
> > The thread was precisely about replacing a SoC-specific compatible
> > string "st,spear600-smi" by a more generic "st,spear-smi" and Rob
> > Herring (above) was opposing to that.
> 
> We're not talking about replacing a pre-existing string, we're talking
> about adding one, which is a different situation.

I don't see how this makes this a different situation. See for example
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/161065.html
and
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-March/087702.html
where Arnd also said using the oldest SoC that has the same IP block as
the compatible string was the right thing to do.

> > > ... which means there's no problem with using marvell,mvebu-audio as the
> > > compatible string if you're going to use properties to describe what
> > > facilities are available.
> > 
> > I disagree, because how do you know if a future "mvebu" SOC such as
> > Armada 370, or one that doesn't exist yet, will not have a different
> > audio IP block?
> 
> The Dove already contains _three_ audio blocks, two of which are this
> one, and another which is block for driving an AC'97 codec (which doesn't
> have a driver.)  That's no problem because you won't call that one an
> "audio" block but an AC'97 block.  So...

And? If that's a different IP block, it'll have a different compatible
string, that's it.

That doesn't change my point: using "marvell,mvebu-audio" as the
compatible string is stupid, because you have absolutely no idea what
the future of audio in mvebu SOCs will be. However, you do know,
*today* that Kirkwood and Dove have compatible IP blocks for audio, and
that they were first introduced with Kirkwood.

> > It will still be audio, it will still be mvebu, but it
> > will not be able to use a "marvell,mvebu-audio" driver. Or maybe it can
> > use the same driver, but with a few variations, so a different
> > compatible string will be needed to identify the original IP
> > ("marvell,kirkwood-audio", used on Kirkwood/Dove) and slightly newer
> > versions of the IP ("marvell,some-funky-soc-audio").
> 
> I don't think this really applies.

It does. We're exactly in this situation, as I will soon be working on
Armada 370 audio support, and while the IP looks similar, I have
checked all the details to see if it's exactly identical.

And Armada 370 is really a mvebu architecture: it's even supported in
mach-mvebu/, while Kirkwood and Dove are not (yet).


> > > In any case "marvell,has-spdif" is too generic - as I've indicated above,
> > > there's versions with spdif out, and other versions with spdif in and
> > > out.
> > 
> > Right, the above was just an example to illustrate that we can have
> > additional properties to encode the differences between each instance
> > of the audio devices.
> 
> I think this is a mistake too: these properties will just tell us what
> may be possible, and the driver will take no real action on them.  I
> suppose that a property specifying whether there is a SPDIF output could
> be used to control whether the IEC958 channel status controls are
> registered.  However...
> 
> What's more important is which outputs are actually wired up, and
> therefore which bits of this hardware are enabled.  Even then, we
> wouldn't want to expose (eg) the IEC958 channel status controls if
> the SPDIF output isn't wired.  So all in all, I don't see any point
> to a set of properties saying "we have SPDIF" etc.  That information
> should come solely from whether the SPDIF output has been "wired up".
> 
> Let me put that another way: we _can_ provide those properties to
> indicate what facilities the hardware has, we just wouldn't use them
> at all - and to provide them seems like over-design to me.

I am not arguing about the properties, as I haven't looked at the
specific problem that needs to be solved. By suggesting properties, I
was merely suggesting one possible solution to the problem that
Sebastian was raising, where the different instances of the IP block
don't have the same capabilities.

What I am however strongly arguing on is the choice of the compatible
string. marvell,mvebu-audio is a wrong choice.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
