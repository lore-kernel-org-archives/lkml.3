Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3GOVzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:55:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60767 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758026Ab3GOVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:55:13 -0400
X-Sasl-enc: KQgo372ORC/4XC/0cGaSa83QBKfAPYDZJ4jt+XGpDZpC 1373925312
Date: Mon, 15 Jul 2013 14:55:04 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the cc:
 stable tag
Message-ID: <20130715215504.GA3029@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715214422.GA2478@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 02:44:22PM -0700, Greg KH wrote:
> On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
> > Before the "3.10.1-stable review" thread degenerated into a disagreement
> > about habits of politeness, there were some solid points being made
> > which, I think, bear consideration and which may now be lost.
> > 
> > The problem, as Ji???? Kosina put is succinctly is that the distributions
> > are finding stable less useful because it contains to much stuff they'd
> > classify as not stable material.
> > 
> > The question that arises from this is who is stable aiming at ...
> > because if it's the distributions (and that's what people seem to be
> > using it for) then we need to take this feedback seriously.
> > 
> > The next question is how should we, the maintainers, be policing commits
> > to stable.  As I think has been demonstrated in the discussion the
> > "stable rules" are more sort of guidelines (apologies for the pirates
> > reference).  In many ways, this is as it should be, because people
> > should have enough taste to know what constitutes a stable fix.  The
> > real root cause of the problem is that the cc: stable tag can't be
> > stripped once it's in the tree, so maintainers only get to police things
> > they put in the tree.  Stuff they pull from others is already tagged and
> > that tag can't be changed.  This effectively pushes the problem out to
> > the lowest (and possibly more inexperienced) leaves of the Maintainer
> > tree.  In theory we have a review stage for stable, but the review
> > patches don't automatically get routed to the right mailing list and the
> > first round usually comes out in the merge window when Maintainers'
> > attention is elsewhere.
> > 
> > The solution, to me, looks simple:  Let's co-opt a process we already
> > know how to do: mailing list review and tree handling.  So the proposal
> > is simple:
> > 
> >      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
> >         reviewed patch to stable
> >      2. All patches to stable should follow current review rules: They
> >         should go to the mailing list the original patch was sent to
> >         once the original is upstream as a request for stable.
> >      3. Following debate on the list, the original maintainer would be
> >         responsible for collecting the patches (including the upstream
> >         commit) adjudicating on them and passing them on to stable after
> >         list review (either by git tree pull or email to stable@).
> > 
> > I contend this raises the bar for adding patches to stable much higher,
> > which seems to be needed, and adds a review stage which involves all the
> > original reviewers.
> 
> I don't like this at all, just for the simple reason that it will push
> the majority of the work of stable kernel development on to the
> subsystem maintainers, who have enough work to do as it is.

Oh, and one other thing, some subsystem maintainers do do exactly this,
and I don't object to it at all.

Specifically David Miller batches up stable kernel patches, tests them,
and then resends them to us for application.  He doesn't mark anything
with Cc: stable, so I don't automatically pull them in, and it's been
working really well for many years now.

There are a few other "smaller" subsystems also doing this, one even
going so far as to give me git trees to pull from, as it works out
better for their workflow, and that's fine.

One major subsystem told me to flat-out-refuse any stable patches that
get marked for it, as they wanted to do the work to verify them all
beforehand and resend them to me.  In the end, the work got to be too
much, and they gave up, but they sure tried :)

So if you want to change the way you, as a subsystem maintainer have the
end-say as to how I will apply stable patches for your area of the
kernel, please do so.  The Cc: stable stuff evolved over time to make it
_easy_ for maintainers to get patches to me with the least amount of
work.  But if you want to do more work on your end, sure, I'll be glad
to let you do that...

thanks,

greg k-h
