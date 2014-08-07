Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaHGUrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:47:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbaHGUrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:47:09 -0400
Message-ID: <53E3E5C8.9090408@nod.at>
Date: Thu, 07 Aug 2014 22:47:04 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at>	<20140806212720.66dbd58b@canb.auug.org.au>	<53E21186.3000702@nod.at>	<20140807102823.7a743bdf@canb.auug.org.au>	<53E32C5C.5010103@nod.at> <CA+55aFy0OFQ5ncwHwpah4xwxuOuMEWL+w6Dv-akTFnogpLo1yA@mail.gmail.com>
In-Reply-To: <CA+55aFy0OFQ5ncwHwpah4xwxuOuMEWL+w6Dv-akTFnogpLo1yA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.08.2014 20:53, schrieb Linus Torvalds:
> On Wed, Aug 6, 2014 at 9:35 PM, Richard Weinberger <richard@nod.at> wrote:
>>
>> It would be nice to see these rules written down somewhere.
> 
> The rules have been pretty clear: "don't rebase public trees".
> 
> That's always been the basic rule. There are _exceptions_ when
> rebasing is the right thing to do, and they all boil down to "lesser
> of two evils", but the evils really have to be pretty big.
> 
> Possible reasons to rebase:
> 
>  (a) It's not public yet. You haven't pushed to kernel.org or any
> other public site, and nobody saw you do it.
> 
>      You can rebase to your hearts content, although you should still
> use sane logic (ie don't rebase on top of random "merge window kernel
> of the day" for example: choose a good starting point, like a previous
> release, or something else that makes sense)
> 
>    "git rebase" is a great tool for a developers own _private_ data.
> It's a great way to split patches up in smaller pieces, or to combine
> half-way work, or to re-order patches to be more logical. And as long
> as you're doing development on your own, there are no downsides as
> with the whole next confusion.
> 
>  (b) You *really* screwed up, and the downsides of rebasing are
> smaller than the downsides of exposing it.
> 
>      As in "oops, that half-way commit doesn't even compile or work at
> all, so leaving it in that state will screw up anybody trying to find
> other bugs with 'git bisect'"
> 
>      At the same time, if you do this just before pushing to me, maybe
> you should take a step back and say "oops, my tree was completely
> broken, maybe I shouldn't push this to Linus just after fixing it".
> 
>  (c) You want to clean things up, and you're not even remotely ready
> to push things upstream, and while people have *seen* your work,
> nobody relies on it or uses it.
> 
>      In other words, your branch was a "Work-in-Progress", and you
> preferably let people know it was that.
> 
>      Again, rebasing just before pushing to me is *not* good. See the
> "really screwed up" thing. If it was WIP code, it doesn't suddenly
> become release-quality just because you rebase it.
> 
> There may be other reasons, but those are the three main ones. In
> general, "rebase just before asking somebody to pull" is just a bad
> idea. It either fixed some big problem (in which case it should have
> gotten more time before being pushed), or it fixes something truly
> trivial (in which case the downsides of sudden rebases outweigh the
> upsides).

Thanks for the clarification.

Here is what happened:

Branch signal_v4 is in linux-next, it never got rebased.
While preparing the pull request I noticed that some of the patches gained new acks
from various architectures.
So I took the *local* copy of signal_v4 added these acks using git rebase and rebased them to v3.16.
Then I've pushed that branch to signal-cleanup and sent you the request.
signal-cleanup did not exist before that.
My fault was rebasing my work from v3.16-rc6 to v3.16 before pushing it.
It won't happen again. But I never did a push -f or something like that.

If you feel better you can still pull from:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4

It is the as-is branch from linux-next.

Thanks,
//richard
