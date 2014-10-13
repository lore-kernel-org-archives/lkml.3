Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaJMJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:48:20 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60653 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaJMJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <20141013013715.GD4503@dastard>
References: <20141013013715.GD4503@dastard>
Date: Mon, 13 Oct 2014 05:48:18 -0400
X-Google-Sender-Auth: NEyI2Bfip44LzpO-LzesoTNSKbk
Message-ID: <CA+55aFwcE=OX7FvckrsZRopCAxw0QnEu5iQUEM5JBoDVzg7uEA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: updates for 3.18-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 9:37 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> i.e. I have generated this pull-req from the base tree I've been working
> on (3.17-rc2) but there have already been commits merged into a more
> recent upstream tree (3.17-rc4) in this tree. When I generate the
> pull request from the underlying 3.17-rc2 branch, it includes all
> those commits, both in the summary and the diffstat. If I base the
> pull request off 3.17, the base commit is the last one that was
> merged into your tree, and the diffstat and commit list reflect
> that.

That's fine, and works for me too. This is normal and expected for
stuff that has gotten into my tree other ways (ie bugfixes that were
cherrypicked to be backported from development trees etc).  I'm used
to it, and while I hope people minimize it (not only because of
multiple commits showing up with the same patch, but because it can
easily cause stupid merge conflicts because the development tree then
made further changes on top of the same patch), it's also very much
considered "normal development".

That said, when there are actual *common* commits as in your case (as
opposed to cherrypicked commits that generate duplicate commits with
the same patch), I would generally suggest you just let "git
merge-base" figure it all out from my latest tree. That way it takes
into account the stuff that you sent earlier on its own.

But this is not a big deal.

> So my question is this: Which tree should I generate the pull
> request from? I flipped a coin an generated this one from 3.17-rc2,
> but if you'd prefer to see just the commits/diffstat that aren't in
> your tree, let me know and I'll do it differently next time....

Normally, I'd suggest the easiest way to handle things is to have a
"linus" branch that tracks my upstream, and then just generate the
pull request off that. Git will figure out the latest merge base and
just do the right thing, and you don't need to really think about
where you forked things off, and which parts you have already sent to
me.

As mentioned, even then the diffstat doesn't always end up being
exactly right, because the history with partially merged branches, and
with potential cherry-picked commits. So I am not surprised or upset
if the diffstat doesn't always match, it happens quite commonly. I go
on a rant when that i sdue to bad development practices, but I don't
see anything like that in your tree.

Some people avoid this by actually generating a test-merge (to warn me
about upcoming conflicts etc), and then generate the diffstat from
that test merge instead of just using the plain "git diff" in the
git-pull-request helper scripts. Whatever works. This is not a huge
deal, exactly because it's "normal development" (unlike the
back-merges issue).

And in this case, it looks like you don't even have cherry-picks, but
just shared common branches, some of which you sent earlier. It looks
like the diffstat if you just use my current tree as the other point
of the git merge-base is correct, although I haven't actually done the
merge itself yet (still waiting for the build for the previous merge
to finish).

                Linus
