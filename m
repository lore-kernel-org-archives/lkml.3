Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaLJJzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:55:42 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:57910 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaLJJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:55:37 -0500
Date: Wed, 10 Dec 2014 09:55:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MFD for v3.19
Message-ID: <20141210095530.GB23481@x1>
References: <20141208120058.GI3951@x1>
 <CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
 <20141209100035.GH14346@localhost>
 <CA+55aFzSeGqDMMmf5qh17aKdCwjhZo0pbbub9QWpHWU3i4jwEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzSeGqDMMmf5qh17aKdCwjhZo0pbbub9QWpHWU3i4jwEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2014, Linus Torvalds wrote:

> On Tue, Dec 9, 2014 at 2:00 AM, Johan Hovold <johan@kernel.org> wrote:
> >
> > Not sure what happened to the git history after your merge, though,
> > since commit
> >
> >         b6684228726c ("mfd: viperboard: Fix platform-device id collision")
> >
> > no longer shows up when doing
> >
> >         git log origin/master -- drivers/mfd/viperboard.c
> 
> So when you do "git log" with a pathname specifier, git obviously no
> longer shows you all the history. In particular, it shows you the
> relevant history for just that file. And by "relevant", it not only
> skips commits that don't change the file, but it also does merge
> simplification: if it hits a merge, and all changes to the file came
> from one side of the merge, it will ignore the other side.
> 
> And in this case, since after my merge the file was identical to your
> branch, clearly the other side didn't bring anything interesting to
> the table, and that history simplification basically means that it's
> ignoring all the changes done in the other side of the merge that got
> thrown away and aren't really relevant for the end result.
> 
> You can get rid of that extra simplification with "--full-history",
> but then you'll usually also want to skip all the merges that aren't
> really intersting, so you'd usually end up doing "--full-history
> --no-merges" or something.
> 
> Thenm you'll see that commit that didn't actually matter fot the end result..

Interesting.  I know Git does some pretty amazing things, but I wasn't
aware it was capable of this kind of simplification when displaying
logs.  I would have expected it to display all commits pertaining to a
file if you'd specified it implicitly.  Thanks for clearing that up.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
