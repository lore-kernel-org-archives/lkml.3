Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3GOVtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:49:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59466 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239Ab3GOVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:49:11 -0400
X-Sasl-enc: vQaFRj7QZs36hFAGuoieYwtHc1E53HQlh0brAmCoDhcu 1373924950
Date: Mon, 15 Jul 2013 14:44:22 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the cc:
 stable tag
Message-ID: <20130715214422.GA2478@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373916476.2748.69.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
> Before the "3.10.1-stable review" thread degenerated into a disagreement
> about habits of politeness, there were some solid points being made
> which, I think, bear consideration and which may now be lost.
> 
> The problem, as Ji???? Kosina put is succinctly is that the distributions
> are finding stable less useful because it contains to much stuff they'd
> classify as not stable material.
> 
> The question that arises from this is who is stable aiming at ...
> because if it's the distributions (and that's what people seem to be
> using it for) then we need to take this feedback seriously.
> 
> The next question is how should we, the maintainers, be policing commits
> to stable.  As I think has been demonstrated in the discussion the
> "stable rules" are more sort of guidelines (apologies for the pirates
> reference).  In many ways, this is as it should be, because people
> should have enough taste to know what constitutes a stable fix.  The
> real root cause of the problem is that the cc: stable tag can't be
> stripped once it's in the tree, so maintainers only get to police things
> they put in the tree.  Stuff they pull from others is already tagged and
> that tag can't be changed.  This effectively pushes the problem out to
> the lowest (and possibly more inexperienced) leaves of the Maintainer
> tree.  In theory we have a review stage for stable, but the review
> patches don't automatically get routed to the right mailing list and the
> first round usually comes out in the merge window when Maintainers'
> attention is elsewhere.
> 
> The solution, to me, looks simple:  Let's co-opt a process we already
> know how to do: mailing list review and tree handling.  So the proposal
> is simple:
> 
>      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
>         reviewed patch to stable
>      2. All patches to stable should follow current review rules: They
>         should go to the mailing list the original patch was sent to
>         once the original is upstream as a request for stable.
>      3. Following debate on the list, the original maintainer would be
>         responsible for collecting the patches (including the upstream
>         commit) adjudicating on them and passing them on to stable after
>         list review (either by git tree pull or email to stable@).
> 
> I contend this raises the bar for adding patches to stable much higher,
> which seems to be needed, and adds a review stage which involves all the
> original reviewers.

I don't like this at all, just for the simple reason that it will push
the majority of the work of stable kernel development on to the
subsystem maintainers, who have enough work to do as it is.

Stable tree stuff should cause almost _no_ extra burden on the kernel
developers, because it is something that I, and a few other people, have
agreed to do with our time.  It has taken me 8 _years_ to finally get
maintainers to agree to mark stuff for the stable tree, and fine-tune a
development process that makes it easy for us to do this backport work.

I _want_ the exact same commit that is in Linus's tree for the backport
because if I have to rely on a maintainer to do the backport and resend
it, I _know_ it will usually be a changed patch, and the git commit id
will be lost.

I know this because it happens today.  I get patches from maintainers
that are radically changed from what is in Linus's tree without any
justification for why that is.  That's not ok.

Let me work with the distros on the issues they have raised.  So far I
have the following issues they have complained about:
  - patches that shouldn't be there because they don't really do
    anything.
  - patches that aren't obvious why they are there.

The first one I am going to be pushing back on, and have already, much
to the dismay of some subsystem maintainers.

The second one is almost always due to security issues that were unknown
to the distro.  The announcement of security problems to the distros has
now been addressed, and since that has changed, I haven't heard any
problems about this.

Have I missed anything else that the distros are objecting to?  The
"smaller" distros (i.e. ones without lots of kernel developers) have
been giving me nothing but _thanks_ and appreciation with the way that
I've been sucking in all of the different fixes.  Do we want to mess
with a process that is really working out well for them, and only causes
annoyance at times by the larger ones?

thanks,

greg k-h
