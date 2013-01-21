Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3AUBpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:45:55 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55925 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3AUBpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:45:54 -0500
MIME-Version: 1.0
In-Reply-To: <87fw1vwcao.fsf@rustcorp.com.au>
References: <87zk03wg7r.fsf@rustcorp.com.au> <CA+55aFwzdcv0LXovZobha=EH=L6DapJt+ODP0nq=TWWAqCxLYQ@mail.gmail.com>
 <87fw1vwcao.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 17:45:33 -0800
X-Google-Sender-Auth: -A1zmeG7ioQAwkgxJZYs89ETsME
Message-ID: <CA+55aFy1nW859yaGP17epRX8A+TaJ8APvb0-Ww1zw91dCAOhoQ@mail.gmail.com>
Subject: Re: [PULL] Module fixes, and a virtio block fix.
To: Rusty Russell <rusty@rustcorp.com.au>, Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 5:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Due to the delay on git.kernel.org, git request-pull fails.  It *looks*
> like it succeeds, except the warning, but (as we learned last time I
> screwed up), it doesn't put the branchname because it can't know.

I think this should be fixed in modern git versions.

And it sure as hell knows the proper tag name, since you *gave* it the
name and it used it for generating the actual contents. The fact that
some versions then screw that up and re-write the tag-name to
something randomly matching that isn't a tag was just a bug.

> For want of a better solution, I'll now resort to sending pull requests
> with the anti-social gitolite URL in it, like so:

That's even worse, fwiw. It means that the pull request address makes
no sense to anybody who doesn't have a kernel.org address, and then
I'm forced to just edit things by hand instead to not pollute the
kernel changelog history with crap.

Junio, didn't "git request-pull" get fixed so that it *warns* about
missing tagnames/branches, but never actually corrupts the pull
request? Or did it just get "fixed" to be a hard error instead of
corrupting things? Because this is annoying.

                Linus
