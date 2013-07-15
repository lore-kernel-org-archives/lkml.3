Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3GOTpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:45:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3GOTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:45:19 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=cVUgu_3N-3HNSd6AZ7AA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373917517.17876.193.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 15:45:17 -0400
In-Reply-To: <1373916476.2748.69.camel@dabdike>
References: <1373916476.2748.69.camel@dabdike>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:
> Before the "3.10.1-stable review" thread degenerated into a disagreement
> about habits of politeness, there were some solid points being made
> which, I think, bear consideration and which may now be lost.

Party pooper ;-)

> 
> The problem, as Jiří Kosina put is succinctly is that the distributions
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

How about this as a proposal.

Keep the Cc: stable@ tag as it is today.

Have Greg, or whoever, change his script to not take commits marked for
stable, but instead, forward the commit to the maintainer. Or as it
already does today, to everyone on the Cc, and -by: tags. Change the
script from being "stable review" to say "Look to see what you want, and
resend what is needed for stable".

Then the maintainer needs to look at all the patches that were marked
for stable, and resend them to Greg saying which ones should go into
stable.

This has a few advantages.

1) lets anyone still mark their patch as a stable fix, even if at the
end isn't.

2) Some commits can be marked for stable, for those that want to read
git logs, but not send to stable (the Fixes: tag as described in another
thread).

2) Makes the stable decision go where it belongs. To the maintainer of
that system. It lets the maintainer think twice about what goes to
stable or not.

3) gives a little more time if needed, to let stable commits stir in
mainline. If its a security fix, the maintainer should be on the ball to
get in to stable, and not just let Greg worry about it.

4) Probably the most important. It should unload most of the work off of
Greg, and push it more on the maintainers. Greg would just need to make
sure the patch goes to the right person (probably not an issue, as it is
most likely on the Signed off by line). Then the maintainers could
review the commits that should go to stable, and if needed, not send
them. They could also send commits that were not marked for stable, as
long as they are already in mainline.

Also, we could mandate that the maintainers do the backports too.

> 
> Oh, and did someone mention plum brandy ...?

No, but I was looking forward to cookies.

-- Steve


