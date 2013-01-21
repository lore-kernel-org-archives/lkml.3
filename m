Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3AUDQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:16:18 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:38875 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3AUDQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:16:15 -0500
MIME-Version: 1.0
In-Reply-To: <871udfw8e0.fsf@rustcorp.com.au>
References: <87zk03wg7r.fsf@rustcorp.com.au> <CA+55aFwzdcv0LXovZobha=EH=L6DapJt+ODP0nq=TWWAqCxLYQ@mail.gmail.com>
 <87fw1vwcao.fsf@rustcorp.com.au> <CA+55aFy1nW859yaGP17epRX8A+TaJ8APvb0-Ww1zw91dCAOhoQ@mail.gmail.com>
 <871udfw8e0.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 19:15:54 -0800
X-Google-Sender-Auth: 6eaoo40IZnGoePxJcsLCkz6u51I
Message-ID: <CA+55aFwNiKaWPTWuxvyud2jkpZgO8z0DGaof7icBDM1ycAFb_A@mail.gmail.com>
Subject: Re: [PULL] Module fixes, and a virtio block fix.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Junio C Hamano <gitster@pobox.com>, Git Mailing List <git@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 6:57 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> I'm confused.  The default argument is HEAD: what does it know about tag
> names?

Ugh. I actually thought that if you give it the tag name directly (as
the "end") it will use that.

But no. It figures it out with "git describe --exact" internally.
Regardless, if your HEAD is actually tagged, it *will* have the
tag-name in git-request-pull.

And it will have it based on your *local* repo, so the fact that it
hasn't been mirrored out yet doesn't really matter. git request-pull
knows that tag name regardless of mirroring issues.

> The bug is that if it can't find that commit at the remote end, it
> still generates a valid-looking request (with a warning at the end),
> where it guesses you're talking about the master branch.

It really shouldn't do that any more, but you seem to have the older
version with the bug.

At  least one of the annoying problems was fixed in the 1.7.11 series,
you have 1.7.10.

The nice thing about git is that it is *really* easy to upgrade. Just
fetch the sources, do "make; make install" all as a normal user, and
you do not need to worry about package management or distro issues or
any crap like that. It installs into your $(HOME)/bin, and as long as
your PATH has that first, you'll get it. I've long suggested that as
the workaround for distros having old versions (some more so than
others).

> Since I use a wrapper script now for your pull requests I can use sed to
> unscrew it:
>
> [alias]
>         for-linus = !check-commits && TAGNAME=`git symbolic-ref HEAD | cut -d/ -f3`-for-linus && git tag -f -u D1ADB8F1 $TAGNAME HEAD && git push korg tag $TAGNAME && git request-pull master korg | sed s,gitolite@ra.kernel.org:/pub,git://git.kernel.org/pub, && git log --stat --reverse master..$TAGNAME | emails-from-log | grep -v 'rusty@rustcorp' | grep -v 'stable@kernel.org' | sed 's/^/Cc: /'

Heh. Ok. That will at least hide the breakage. But I suspect you could
fix it by just updating git.

             Linus
