Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab3GaUQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:16:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39455 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3GaUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:16:37 -0400
Date: Wed, 31 Jul 2013 21:14:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, mbizon@freebox.fr,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
	people interested in device tree janitoring / cleanup?]
Message-ID: <20130731201457.GA24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy> <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731200017.GC8027@netboy>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:00:17PM +0200, Richard Cochran wrote:
> On Wed, Jul 31, 2013 at 09:29:35PM +0200, Tomasz Figa wrote:
> > 
> > I showed you two example solutions that could handle this use case without 
> > stable binding ABI, just to prove that b) is not the only option (even if 
> > it's the best one, which I continue to agree on, don't get me wrong).
> 
> You only showed *one* solution (b) that satisfies the use case. The
> use case was:
> 
>    User acquires a machine running ARM Linux version 3.x, with u-boot
>    and dtb in a read only flash partition. The board boots and works just
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^
>    fine. However, for his application, the user requires a new kernel
>    feature that appeared in version 3.y where y > x. He compiles the new
>    kernel, and it also works.
> 
> But you suggested:
> 
>  a) using DT as direct replacement for board files - this means that you
>     are free to say that DTSes are strictly coupled with kernel version
>     and you are free to modify the bindings - see the analogy to board
>     files, where you could modify the platform data structures and could
>     not directly copy board file from one kernel version to another,
> 
> In the use case, the kernel is upgraded, but not the DTB. So this
> solution makes no sense.

That's also crap for another reason.  DT on the whole is _supposed_ to
describe what the hardware is, and how it is wired up in a WELL DEFINED
and STABLE manner.  Unfortunately, there's a *BIG* mistake that was made
- having this /chosen node in DT which gets used for "software"
configuration - eg, the command line and so forth.

That was a mistake because it means that the DT isn't purely a
description of the hardware.  Such stuff should have been left in ATAGs,
and DT should have been placed into its own ATAG entry.  There would
not have been any conflict between ATAGs and DT, because ATAGs generally
don't deal with hardware configuration - the only real bit of hardware
configuration conveyed via ATAGs is the location of memory and size of
memory.

However, if we go back to the idea that DT is supposed to describe the
hardware, _and_ that the way to describe that hardware is well defined
and _stable_ (as it should be) then there should be no reason what so
ever that your old DT blob should not continue working in later kernels.
If it doesn't, then the contract that DT promised when we first moved
over to using DT has been _broken_.

Quite frankly, the fact that this discussion has gone on soo far, and
everyone is saying that the existing DT descriptions to date (for what,
two years) are all unstable is really extremely sad.

I've stated in my previous postings what I think very clearly - and it
comes down to the fact that every DT binding which is in existence in
a released kernel _is_ by that very nature a stable binding.  If it
wasn't a stable binding, it should have been clearly marked as such
and been subject to CONFIG_EXPERIMENTAL (when it existed) or
CONFIG_STAGING or similar.

We even went as far as creating documentation for the bindings - directly
along side the documentation for PPC bindings, with no distinction.

Given all that, it's down right insulting to those who have been using
ARM kernels to now start off a discussion about making these things
stable.  Those people who think that these bindings are not stable need
to wake up to reality - we have USERS of this stuff over the last two
years.  It's found its way into products.  If we're going to keep this
stuff "unstable" then we are actively _hurting_ our users.

I'll say it again: if a binding has been in a final kernel, it is by
definition a *stable* binding, and compatibility with that binding
*must* be maintained.

If we're not going to do that, then we owe all the users of the ARM
kernel a VERY BIG apology.
