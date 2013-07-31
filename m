Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab3GaUsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:48:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39474 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3GaUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:48:46 -0400
Date: Wed, 31 Jul 2013 21:48:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
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
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
	people interested in device tree janitoring / cleanup?]
Message-ID: <20130731204817.GC24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy> <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy> <20130731201457.GA24642@n2100.arm.linux.org.uk> <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:37:36PM -0400, jonsmirl@gmail.com wrote:
> On Wed, Jul 31, 2013 at 4:14 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > However, if we go back to the idea that DT is supposed to describe the
> > hardware, _and_ that the way to describe that hardware is well defined
> > and _stable_ (as it should be) then there should be no reason what so
> > ever that your old DT blob should not continue working in later kernels.
> > If it doesn't, then the contract that DT promised when we first moved
> > over to using DT has been _broken_.
> 
> Suppose your DT predates PINCTRL and the CPU needs the pins set to
> function.  But setting the pins up is a board specific function. How
> is this going to get implemented in a generic kernel that doesn't have
> any board specific code in it?
> 
> I would propose that we only need to worry about DTs that got put into
> boot loaders and not worry about ones that were only used when
> appended to a kernel.

That is - again - our mistake.  We should have made it clear from the
start that the use of an _appended_ DT, or a DT provided with the kernel
being booted was more or less mandatory for the time being.  We actually
did exactly the opposite - we advertised the appended DT as a stop-gap
measure just to allow a DT kernel to be booted with a boot loader which
didn't support DT.

That in itself _encouraged_ boot loader support for DT on ARM (which in
itself is not a bad thing) but also leads people down the path of
potentially separating the DT from the kernel.

Had we encouraged the use of an appended DT instead, but still encouraged
boot loaders to update, and also made a clear statement that DT is
unstable (which everyone can see - for example by making our DT stuff
depend on CONFIG_EXPERIMENTAL when it existed) then everyone would have
been clear about its status.

The fact that we did not - the fact that we ignored this process means
that it is _our_ problem that people like Richard are blowing up such a
storm over this.  We need to admit that we got it wrong, and commit to
doing it the right way in future.  What that means is starting off today
with a commitment to keep as much of the stuff which works today working
_tomorrow_, and the day after, and so forth.
