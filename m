Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3GYXUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:20:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38616 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3GYXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:20:46 -0400
Date: Fri, 26 Jul 2013 00:18:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
	device tree janitoring / cleanup?]
Message-ID: <20130725231848.GJ24642@n2100.arm.linux.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com> <20130725193135.GT23879@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725193135.GT23879@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:31:35PM -0400, Jason Cooper wrote:
> On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
> > On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
> 
> > > One problem that needs to be solved is obviously how a binding
> > > graduates from tentative to locked. This work isn't going to be very
> > > interesting to most people, I suspect. Think standards committee type
> > > work.
> > 
> > I think a time based stabilization period would be better than a
> > separate directory to apply bindings too. Or time plus periodic review
> > perhaps.
> 
> The only problem with a time-based versus separate directory is how do
> users who've downloaded the tree determine which bindings are stable?
> If they pull a tarball, or receive an SDK, there is most likely no git
> history attached.
> 
> I think the idea of a 'tentative' directory (or 'locked') is churnish,
> but necessary.  If I DL'd a tarball and had to type 'tentative' to get
> to the binding doc I wanted, that would be a pretty clear clue to be
> delicate about how I trust/use/plan with that binding.

It's actually extremely simple.  If the bindings are in development,
they must not appear in a -final released kernel.  Anything that appears
in a -final kernel becomes part of the ABI at that point.

That obviously does not mean you remove them in the last -rc and put
them back during the merge window!

That's how we handle every other ABI thing in the kernel tree, why should
DT files be any different?  (I've added Linus and Grant to this discussion.)

As I've already stated, it is intended to eventually remove the DT files
from the kernel tree and have them as a separately maintained project,
which means they will be independent of the kernel version.
