Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaLIUoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:44:12 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:38101 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaLIUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:44:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141209100035.GH14346@localhost>
References: <20141208120058.GI3951@x1>
	<CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
	<20141209100035.GH14346@localhost>
Date: Tue, 9 Dec 2014 12:44:09 -0800
X-Google-Sender-Auth: yAhuINmBxvavExZ9l3sw0G3VIos
Message-ID: <CA+55aFzSeGqDMMmf5qh17aKdCwjhZo0pbbub9QWpHWU3i4jwEw@mail.gmail.com>
Subject: Re: [GIT PULL] MFD for v3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 2:00 AM, Johan Hovold <johan@kernel.org> wrote:
>
> Not sure what happened to the git history after your merge, though,
> since commit
>
>         b6684228726c ("mfd: viperboard: Fix platform-device id collision")
>
> no longer shows up when doing
>
>         git log origin/master -- drivers/mfd/viperboard.c

So when you do "git log" with a pathname specifier, git obviously no
longer shows you all the history. In particular, it shows you the
relevant history for just that file. And by "relevant", it not only
skips commits that don't change the file, but it also does merge
simplification: if it hits a merge, and all changes to the file came
from one side of the merge, it will ignore the other side.

And in this case, since after my merge the file was identical to your
branch, clearly the other side didn't bring anything interesting to
the table, and that history simplification basically means that it's
ignoring all the changes done in the other side of the merge that got
thrown away and aren't really relevant for the end result.

You can get rid of that extra simplification with "--full-history",
but then you'll usually also want to skip all the merges that aren't
really intersting, so you'd usually end up doing "--full-history
--no-merges" or something.

Thenm you'll see that commit that didn't actually matter fot the end result..

                    Linus
