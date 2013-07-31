Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3GaV0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:26:51 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39252 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3GaV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130731204817.GC24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<1999586.84BnWE5EUh@thinkpad>
	<20130731191209.GA8027@netboy>
	<1409617.9untvfnOTJ@flatron>
	<20130731200017.GC8027@netboy>
	<20130731201457.GA24642@n2100.arm.linux.org.uk>
	<CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
	<20130731204817.GC24642@n2100.arm.linux.org.uk>
Date: Wed, 31 Jul 2013 17:26:47 -0400
Message-ID: <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arend van Spriel <arend@broadcom.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 4:48 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jul 31, 2013 at 04:37:36PM -0400, jonsmirl@gmail.com wrote:
>> On Wed, Jul 31, 2013 at 4:14 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > However, if we go back to the idea that DT is supposed to describe the
>> > hardware, _and_ that the way to describe that hardware is well defined
>> > and _stable_ (as it should be) then there should be no reason what so
>> > ever that your old DT blob should not continue working in later kernels.
>> > If it doesn't, then the contract that DT promised when we first moved
>> > over to using DT has been _broken_.
>>
>> Suppose your DT predates PINCTRL and the CPU needs the pins set to
>> function.  But setting the pins up is a board specific function. How
>> is this going to get implemented in a generic kernel that doesn't have
>> any board specific code in it?
>>
>> I would propose that we only need to worry about DTs that got put into
>> boot loaders and not worry about ones that were only used when
>> appended to a kernel.
>
> That is - again - our mistake.  We should have made it clear from the
> start that the use of an _appended_ DT, or a DT provided with the kernel
> being booted was more or less mandatory for the time being.  We actually
> did exactly the opposite - we advertised the appended DT as a stop-gap
> measure just to allow a DT kernel to be booted with a boot loader which
> didn't support DT.
>
> That in itself _encouraged_ boot loader support for DT on ARM (which in
> itself is not a bad thing) but also leads people down the path of
> potentially separating the DT from the kernel.
>
> Had we encouraged the use of an appended DT instead, but still encouraged
> boot loaders to update, and also made a clear statement that DT is
> unstable (which everyone can see - for example by making our DT stuff
> depend on CONFIG_EXPERIMENTAL when it existed) then everyone would have
> been clear about its status.
>
> The fact that we did not - the fact that we ignored this process means
> that it is _our_ problem that people like Richard are blowing up such a
> storm over this.  We need to admit that we got it wrong, and commit to
> doing it the right way in future.  What that means is starting off today
> with a commitment to keep as much of the stuff which works today working
> _tomorrow_, and the day after, and so forth.

What do you think about using a quirk layer to decouple deployed DTs
from whatever is implemented in the kernel? I still think there is
going to be volatility in the the kernel DT usage simply because we
haven't figured out all of the issues with it yet.  For example
defining a global schema system is going to expose a lot of irregular
DT syntax when you line up all of the platform DTs in a system where
it is easy to compare them. One the plus side the kernel is certainly
evolving to a point where this volatility will stop in the future, we
just aren't there yet.  If we don't use a quirk fixup system, then
board specific code is going to continue to exist scattered around in
the arch directories.

My preference would be to contain the board specific DT fixup code
inside a quirk system and have the goal of making the arch directories
free of board specific code. Any new board would have a good enough DT
that they don't need any board specific DT fixup code. Of course
there's quite a ways to go before reaching that goal.

Alternatively you may be of the belief that it is impossible to get
rid of the board specific code. But x86 doesn't have any of it, why
should ARM?

-- 
Jon Smirl
jonsmirl@gmail.com
