Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaJMV4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 17:56:01 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29789 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbaJMV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 17:56:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkuAABKPFR5LODnPGdsb2JhbABbgw6BK4I2hQewOgaVGYVqAgIBAQKBHhcBBgEBAQE4O4QCAQEBAwE6HCMFCwgDGAkMGQ8FJQMHGhOINgfFGgEBAQcCAR8YhgiKJQcKgyOBHgWdSoEvkGWICSkvgkoBAQE
Date: Tue, 14 Oct 2014 08:55:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [GIT PULL] xfs: updates for 3.18-rc1
Message-ID: <20141013215531.GD17506@dastard>
References: <20141013013715.GD4503@dastard>
 <CA+55aFwcE=OX7FvckrsZRopCAxw0QnEu5iQUEM5JBoDVzg7uEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwcE=OX7FvckrsZRopCAxw0QnEu5iQUEM5JBoDVzg7uEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:48:18AM -0400, Linus Torvalds wrote:
> On Sun, Oct 12, 2014 at 9:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > i.e. I have generated this pull-req from the base tree I've been working
> > on (3.17-rc2) but there have already been commits merged into a more
> > recent upstream tree (3.17-rc4) in this tree. When I generate the
> > pull request from the underlying 3.17-rc2 branch, it includes all
> > those commits, both in the summary and the diffstat. If I base the
> > pull request off 3.17, the base commit is the last one that was
> > merged into your tree, and the diffstat and commit list reflect
> > that.
> 
> That's fine, and works for me too. This is normal and expected for
> stuff that has gotten into my tree other ways (ie bugfixes that were
> cherrypicked to be backported from development trees etc).  I'm used
> to it, and while I hope people minimize it (not only because of
> multiple commits showing up with the same patch, but because it can
> easily cause stupid merge conflicts because the development tree then
> made further changes on top of the same patch), it's also very much
> considered "normal development".
> 
> That said, when there are actual *common* commits as in your case (as
> opposed to cherrypicked commits that generate duplicate commits with
> the same patch), I would generally suggest you just let "git
> merge-base" figure it all out from my latest tree. That way it takes
> into account the stuff that you sent earlier on its own.

Ok, that seems easy enough to check. I wasn't aware of git
merge-base, so thanks for letting me know about it.

> But this is not a big deal.
> 
> > So my question is this: Which tree should I generate the pull
> > request from? I flipped a coin an generated this one from 3.17-rc2,
> > but if you'd prefer to see just the commits/diffstat that aren't in
> > your tree, let me know and I'll do it differently next time....
> 
> Normally, I'd suggest the easiest way to handle things is to have a
> "linus" branch that tracks my upstream, and then just generate the
> pull request off that. Git will figure out the latest merge base and
> just do the right thing, and you don't need to really think about
> where you forked things off, and which parts you have already sent to
> me.

OK, that's exactly what I would have done if the coin flip landed
the other way.  I'll use that method in future.

> As mentioned, even then the diffstat doesn't always end up being
> exactly right, because the history with partially merged branches, and
> with potential cherry-picked commits. So I am not surprised or upset
> if the diffstat doesn't always match, it happens quite commonly. I go
> on a rant when that i sdue to bad development practices, but I don't
> see anything like that in your tree.

That's good to know - I'm trying to keep the topic branches as
stable as possible so you can see when they were first pushed into
the tree, if/when fixes are appended to them and the dependencies
between them so bisects won't break. If you do see something wrong
or dodgy, just yell. ;)

> Some people avoid this by actually generating a test-merge (to warn me
> about upcoming conflicts etc), and then generate the diffstat from
> that test merge instead of just using the plain "git diff" in the
> git-pull-request helper scripts. Whatever works. This is not a huge
> deal, exactly because it's "normal development" (unlike the
> back-merges issue).

*nod*

Definitely "normal development" - I do that "test merge" as part of
my day-to-day workflow. My test tree (i.e. what I point overnight
xfstests runs at) is your TOT + the current XFS for-next + any patch
sets I'm reviewing, testing and/or developing....

Thanks for the info, Linus.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
