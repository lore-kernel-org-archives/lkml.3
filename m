Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3G0Kgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:36:40 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48384 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3G0Kgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:36:37 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
Date: Sat, 27 Jul 2013 12:36:30 +0200
Message-ID: <2460092.aLmjrOVh1g@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F39FD8.6080808@broadcom.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 of July 2013 12:24:24 Arend van Spriel wrote:
> On 07/27/2013 11:51 AM, Tomasz Figa wrote:
> > On Saturday 27 of July 2013 07:04:08 Richard Cochran wrote:
> >> On Fri, Jul 26, 2013 at 08:49:43AM -0700, Olof Johansson wrote:
> >>> Long term, final goal is likely to be close to what Russell is
> >>> saying
> >> 
> >> Why is this a long term goal? Start today.
> >> 
> >>> -- nothing should go into the kernel tree unless the binding is in a
> >>> fully stable state. However, we have a transitional period between
> >>> now
> >>> and then, and even when we're at the final state there will be need
> >>> to
> >>> have some sort of sandbox for development and test of future
> >>> bindings.
> >> 
> >> Why not just set up a git tree right away?
> >> 
> >>> Dealing with all that, as well as the actual process for locking in
> >>> bindings, is what needs to be sorted out.
> >>> 
> >>> I think we're all in agreement that bindings that change over time
> >>> are
> >>> nothing but pain, but we're arguing that in circles anyway.
> >> 
> >> No.
> >> 
> >> I keep saying, the bindings must be stable ABI, *today*.
> >> 
> >> You keep saying, maybe later, but until then we will make things up
> >> as
> >> we go along.
> > 
> > We have currently a lot of broken bindings, because people didn't know
> > how to define ones and those they defined have not been properly
> > reviewed. Do you really want such broken ABI in the kernel?
> > 
> > Sure, there are many existing bindings that can be just made stable
> > and
> > well they probably are already de facto stable. This is mostly about
> > subsystem bindings and whatever already has many users, both made them
> > get more thought when designing and more review before merging.
> > 
> > Still, a lot of device and platform-specific bindings are simply
> > broken. Take max8925 backlight driver, that Olof started this whole
> > discussion with, as an example. We need to sort them out before they
> > can be stabilized.
> 
> That is a nice summary of how we got from null to now and Richard seems
> to be simply saying: let's stop mucking about and make this a project
> with a well-defined process of dealing with staging and stable bindings
> and keep stable bindings stable. Whether it should be within the kernel
> repo as a separate subsystem or in an entire different repo is a trivial
> decision, but still a decision that needs to be made.

Yes, basically that's our current situation.

Still, I would disagree about the decision being trivial, as each choice 
will have further, and likely pretty significant, consequences on binding 
maintenance, submission, review and for dependent things, like drivers or 
platforms using such bindings. This needs to be discussed enough.

> Apart from stable DT bindings I would love to see a DT compiler that
> that next to DT syntax detects mistakes in properties used for the
> selfish reason that I spent hours debugging regulator code, because I
> typed vmmc_supply iso vmmc-supply. I did not go through all the
> bindings, but this may require a more formal description so it could be
> compiled/read in the DT compiler.

This bothered me as well and that's why I'm working on this. I still can't 
get myself to write a very long mail (I'm more a coder than writer...) 
about the whole idea, my proposal of how it could look and problems we 
need to solve, but I'll try better this evening.

Best regards,
Tomasz

