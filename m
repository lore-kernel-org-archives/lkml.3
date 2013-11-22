Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3KVEWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 23:22:14 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48082 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3KVEWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 23:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1311192319180.27775@tundra.namei.org>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org>
	<CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
	<alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
	<CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
	<alpine.LRH.2.02.1311192319180.27775@tundra.namei.org>
Date: Thu, 21 Nov 2013 20:22:11 -0800
X-Google-Sender-Auth: lZfdcWv5TJ_x31xWrkHn50owb9I
Message-ID: <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've finally pulled this - at least tentatively (ie I have it on
my machine, it's going through allmodconfig test-builds and I'll test
booting asap, but I expect all that to succeed, and will push out the
merge if/when it does so).

However, I have to say, that pulling this was more than a little
annoying. I would really have preferred seeing the key subsystem
changes in a separate branch, to make it easier for me to do the
"normal updates" first, and then do just the big changes separately.
The key subsystem changes had absolutely _nothing_ in common with the
rest of the security subsystem changes afaik.

The fact that they got mixed up also made it all messier to go
through, since there were (two sets of) fixes after the internal
merges of the other security stuff - if the key subsystem changes had
been a branch of its own, the fixes would have remained on that branch
too.

So for future cases: if there are big independent overhauls of core
subsystems, I'd really like to see them kept separate, ok?

Also, David, with (for example) 1700+ new lines in lib/assoc_array.c,
I would really *really* like code like this to have some review by
outsiders. Maybe you did have that, but I saw absolutely no sign of it
in the tree when I merged it. That code alone made me go "Hmm, where
did this come from, how was it tested, why should I merge it?".

I do see *some* minimal comments on it from George Spelvin on lkml. I
don't see any sign of that in the commit messages, though. I'd also
see no comments on where the algorithm came from etc. It clearly has
subtle memory ordering (smp_read_barrier_depends() etc), so I'm
assuming it is based on something else or at least has some history to
it. What is that history?

In short: this is exactly the kind of thing I *don't* enjoy merging,
because the code that needed review was

 - mixed up with other changes that had nothing to do with it
 - had no pointers to help me review it
 - had zero information about others who had possibly reviewed it before

and quite frankly, without the extended explanation of what the
changes were for (which I also didn't get initially), I'd probably
have decided half-way that it's not worth the headache.

In the end, the code didn't look bad, and I didn't find any obvious
problems, but there's very much a reason why I merged this over two
weeks after the first pull request was originally sent to me.

So guys, make it easier for me to merge these kinds of things, and
*don't* do what happened this time. Ok? Pretty please?

                  Linus

On Tue, Nov 19, 2013 at 4:20 AM, James Morris <jmorris@namei.org> wrote:
> Also, here's an updated branch to pull from with four new fixes from
> David.
>
> ---
>
> The following changes since commit be408cd3e1fef73e9408b196a79b9934697fe3b1:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-11-04 06:40:55 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus2
...
