Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3GYS3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:29:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62335 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756851Ab3GYS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:29:23 -0400
Date: Thu, 25 Jul 2013 19:29:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Catalin Marinas <Catalin.Marinas@arm.com>,
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
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Message-ID: <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F168FC.9070906@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 07:05:48PM +0100, Stephen Warren wrote:
> On 07/25/2013 10:57 AM, Mark Rutland wrote:
> > On Thu, Jul 25, 2013 at 05:09:19PM +0100, Olof Johansson wrote:
> ...
> >> So, there really seems to be a need for a layered approach, one in
> >> which a binding "graduates" from being tentative to being locked in.
> >> I'm refraining from using the terms "staging" and "stable" here, since
> >> they have overloaded meaning in the kernel world that doesn't apply
> >> here.
> > 
> > I'm not sure how realistic it is to have drivers in the kernel using
> > unstable bindings, and expect people to not rely on them, but I don't
> > have a better option to give. We need a big fat warning that an unstable
> > binding is in use.
> 
> I don't think having people "rely" on the bindings is the issue so much
> as the awareness that if they do, there will be compatibility issues for
> unstable bindings.

As long as we can make sufficiently clear that trying to use an unstable
binding is going to be *very* painful, and not necessarily supported.

> 
> >> One problem that needs to be solved is obviously how a binding
> >> graduates from tentative to locked. This work isn't going to be very
> >> interesting to most people, I suspect. Think standards committee type
> >> work.
> >>
> >> A possible way to handle this is to have exactly that: A group of
> >> people that essentially constitute the "standards committee" that meet
> >> on a regular basis to review and approve new bindings. They should be
> >> people not just doing ARM Linux work, but other stakeholders in these
> >> bindings too. One of the things they should probably do is sift
> >> through our current in-kernel bindings and select those who seem ready
> >> to be locked in, review/discuss/decide upon that and once the decision
> >> is made, that specific binding does become part of the static,
> >> never-ever-change ABI of firmware-to-kernel interfaces.   That might
> >> also be the time that the binding is moved from the kernel to a
> >> separate repo, but that's a technicality that we'll let the DT
> >> maintainers decide among themselves, IMHO.
> > 
> > We're going to need input from other OSs too, or the bindings will
> > remain Linux-specific regardless of how far away the bindings and dts
> > repo(s) is/are.
> 
> And bootloaders too. Some U-Boot platforms are starting to use DT for
> exactly the same reason that the kernel does; to allow a single
> bootloader binary to run on a variety of different boards, with all
> configuration coming from DT.

Ah, I'd not considered that. We certainly need to include them in the
discussion.

> 
> On another related topic, something that may be useful for the DT
> bindings reviewer team is a basic checklist for new DT bindings.
> Something similar to Fedora's package review checklist. Perhaps also
> (yet another?) document on a bit of DT philosophy. If this sounds
> useful, I could try and take a stab at some basic initial version.

That does indeed sound useful. Please do :)

> 
> We also need to decide (or just document) exactly what "describes the
> HW" means; see the thread on thermal limits, and consider the extension
> of describing hard/absolute thermal limits to describing use-cased base
> thermal profiles using the same schema, or not allowing that.
> 

Certainly. This is an unfortunate gray area.

Thanks,
Mark.
