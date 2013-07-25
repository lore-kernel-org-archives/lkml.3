Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3GYR5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:57:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456Ab3GYR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:57:06 -0400
Date: Thu, 25 Jul 2013 18:57:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Message-ID: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
Thread-Topic: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

[Adding the other new dt bindings maintainers to Cc]

On Thu, Jul 25, 2013 at 05:09:19PM +0100, Olof Johansson wrote:
> [I'm adding LKML and ksummit-discuss to this thread, since the ACPI/DT
> discussions have been covered there and this overlaps some with that]
> 
> On Thu, Jul 25, 2013 at 7:38 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Jul 25, 2013 at 03:27:02PM +0100, Russell King - ARM Linux wrote:
> >> Remember the stated assertion when DT was first added to the kernel: the
> >> DT descriptions _will_ become a separately maintained project which is
> >> independent of the kernel.  They will _not_ be kernel version specific.
> >
> > I'm looking forward to this.
> >
> > Question for the DT guys: what are the plans here? Are we going to get
> > rid of the .dts files inside the kernel tree?
> 
> In the discussions we had in Dublin, a couple of options on how to
> lock in bindings were discussed. I'm a little surprised that Grant
> didn't cover them in his initial emails on the new maintainership
> model, but maybe he wanted the new group to handle it. And they didn't
> bring it up yet either. So I am. :-)

Apologies for the delay on this, thanks for bringing it up. We certainly
need a kick regarding this.

> 
> Until now, we have been working under the assumption that the bindings
> are _NOT LOCKED_. I.e. they can change as needed, and we _ARE_
> assuming that the device tree has to match the kernel. That has been a
> good choice as people get up to speed on what is a good binding and
> not, and has given us much-needed room to adjust things as needed.
> That obviously has to change, but doing so needs to be done carefully.

While it's been the most natural way for us kernel folk to build the
necessary infrastructure and adapt to the new way of doing things, as
Dave and Russell pointed out in the original thread [1], we've blindly
walked into building a horrible ABI for ourselves. With KVM we've also
exposed this ABI to userspace...

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/186114.html

> 
> It's likely that we still want to have a period in which a binding is
> tentative and can be changed. Sometimes we don't know what we really
> want until after we've used it a while, and sometimes we, like
> everybody else, make mistakes on what is a good idea and not. The
> alternative is to grind most new binding proposals to a halt while we
> spend mind-numbing hours and hours on polishing every single aspect of
> the binding to a perfect shine, since we can't go back and fix it.
> 
> So, there really seems to be a need for a layered approach, one in
> which a binding "graduates" from being tentative to being locked in.
> I'm refraining from using the terms "staging" and "stable" here, since
> they have overloaded meaning in the kernel world that doesn't apply
> here.

I'm not sure how realistic it is to have drivers in the kernel using
unstable bindings, and expect people to not rely on them, but I don't
have a better option to give. We need a big fat warning that an unstable
binding is in use.

> 
> One problem that needs to be solved is obviously how a binding
> graduates from tentative to locked. This work isn't going to be very
> interesting to most people, I suspect. Think standards committee type
> work.
> 
> A possible way to handle this is to have exactly that: A group of
> people that essentially constitute the "standards committee" that meet
> on a regular basis to review and approve new bindings. They should be
> people not just doing ARM Linux work, but other stakeholders in these
> bindings too. One of the things they should probably do is sift
> through our current in-kernel bindings and select those who seem ready
> to be locked in, review/discuss/decide upon that and once the decision
> is made, that specific binding does become part of the static,
> never-ever-change ABI of firmware-to-kernel interfaces.   That might
> also be the time that the binding is moved from the kernel to a
> separate repo, but that's a technicality that we'll let the DT
> maintainers decide among themselves, IMHO.

We're going to need input from other OSs too, or the bindings will
remain Linux-specific regardless of how far away the bindings and dts
repo(s) is/are.

I'd be happy with a Linux-specific unstable binding and an accepted,
stable binding documented externally, that gives people the most freedom
to prototype while keeping stable and unstable bindings clearly
separated.

> 
> I think that captures most of what we discussed in person. Others
> might have changed their opinions since then, so I'm definitely not
> claiming that any of this was an official decision made by anybody.
> It's just one proposal on how to handle these things moving forward.

I think you've got the gist of it. 

How about the following:

* We reach out to other users of devicetree, and attempt to form the
  standards/review commitee.

* At v3.11, we pull (a copy of?) all binding documents out of the
  kernel, into an 'unstable/linux bindings' repo. 

* The minimal set of 'stable' bindings (e.g. those having been used for
  years without modification by powerpc) will be moved to a stable repo
  after consensus from the committee, and developers outside of the
  committee using said bindings. Hopefully there will be no showstoppers
  here. These should contain no Linux-specific information.

  Those bindings that have been modified recently or are in areas where
  there is currently heavy churn will not be marked stable.

* We attempt to graduate bindings to stable, once the appropriate
  infrastructure is in place to prove the concept, preferably with
  bindings for similar devices from different vendors.

Thoughts?

Thanks,
Mark.
