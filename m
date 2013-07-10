Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3GJCuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:50:44 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36039 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3GJCum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130709.145325.1363244885668360965.davem@davemloft.net>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
Date: Tue, 9 Jul 2013 19:50:41 -0700
X-Google-Sender-Auth: HGgiw1I_bFJJGNisO6n6mAetBbE
Message-ID: <CA+55aFwgYoGKRLde_4KBnUr1nENpwdahJv8+wHJ502HcGJW1pA@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 2:53 PM, David Miller <davem@davemloft.net> wrote:
>
> This is a re-do of the net-next pull request for the current merge
> window.  The only difference from the one I made the other day is that
> this has Eliezer's interface renames and the timeout handling changes
> made based upon your feedback, as well as a few bug fixes that have
> trickeled in.

David, what the heck are you doing?

Take a look at commit e1d6fbc3dedb, for example.

That's a *merge* commit that you have done using "git merge --no-ff"
or something equivalent. Fine.

But what is *not* fine is how you've then edited the message to make
the commit log look like it's not a merge at all!

There's another one in dc3d807d6fd9. Again, it's a merge, but you
wouldn't know if from the commit message.

You seem to do this non-ff thing on purpose, since there are also
things like commit b0b02c77d7aa, but there at least you make it clear
it's a merge. I'm not a huge fan of non-ff merges, but I do see the
advantages of maintainers being able to separate that part of the
history and giving an added "overall summary" merge commit message, so
I'm ok with that part, and I've considered it myself. We can even
discuss making it some recommended thing if people really like it
widely.

But the summary lines absolutely needs to spell out that it's a merge.
You can't just make a merge look like it's some kind of normal commit.
Because in many contexts it really is not otherwise all that
noticeable that they are merges.

Seriously. Those commits now have TOTALLY MISLEADING summary messages.
Think about what they look like in shortlogs etc one-liner summary
formats ("git log --oneline" etc).

So the summary message for a merge needs to mention that it's a merge.
Not this insane "try to make merges look like non-merge commits" thing
you've done. There is zero upside to editing away the merge part of
the message. Plus now they look totally different from your other
merges, for no good reasons.

Looking around, you've apparently done this before: commit
912df2628bd1 back in January did it too. I didn't catch it back then.
But now there's two new ones. See which ones stand out by doing

    git log --oneline --merges --author=davem

(There's a few oddball ones by other people too, most from the early
days in 2005 when we didn't have good git workflows. Some much more
recent dubious ones too, so you're not _entirely_ alone here, there's
one from Linville too, for example)

Now, I'm all for making descriptive merge commit messages, including
improving on the summary line. So by all means write those nice merge
messages with explanations. I think something like

    dc3d807d6fd9 Merge "openvswitch: gre tunneling support."

would have been a *fine* summary line, for example, and quite possibly
better than the default kind of git merge summary lines (ie "Merge
branch 'openswitch'"). So I'm not against playing with merge messages
per se, it's literally this "cannot tell it's a merge any more in the
summary" that I thing is a problem.

I'm going to pull it, because trying to fix this is too damn painful,
but I really *really* want to see merges with summary messages that
make it clear that they are merges (ie they spell out that "Merge"
part). If you want to improve them by extending on the branch name
etc, go wild.  But don't break "git shortlog" or "git log --oneline"
etc.

                  Linus
