Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3BTB3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:29:39 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41055 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3BTB3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130217191819.GA21778@redhat.com>
References: <20130217191819.GA21778@redhat.com>
Date: Tue, 19 Feb 2013 17:29:37 -0800
X-Google-Sender-Auth: W_onTzYEtBmtG_7_Aa6QjT59YAY
Message-ID: <CACBanvoxwb341yO_hoJDDqZf9htgY2NNiOw0LfYj3TUe9zM5+w@mail.gmail.com>
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hello.
>
> These problems are really annoying. I reported and tried to fix
> them in 2008 (see http://marc.info/?l=linux-kernel&m=121665710711931)
> but nobody was interested.
>
> Since then I had a lot of (to some degree contradictory) bug reports:
> we do not want the interrupted coredumps (this is what the current code
> tries to achieve but the logic is very wrong), but at the same time some
> people blame the coredump because it is not interruptible.
>
> And every time the discussion was confusing, it is not clear what should
> we actually do to make everyone happy.
>
> Linus, et al, could you please ack/nack the intent? Of course I will
> appreciate if you can review the code, but what I am actually worried
> about is the user-visible change: the coredumping becomes killable but
> only by the _explicit_ SIGKILL, other fatal signals are "ignored".
>
> The changes were not tested at all, I'll try to recheck everything and
> test this tomorrow. I am sending this series right now because I strongly
> believe that the recent -mm patches in this area are not right and should
> be dropped, and I also disagree with the pending v2.
>
> Mandeep, just in case please note that 1/3 alone should fix the problems
> with non-fatal signals and wait_dump_helper(). As for the freezer, afaics
> we are almost ready for the (slightly modified) fix proposed in
> http://marc.info/?l=linux-kernel&m=136103469831268.
>
> Oleg.

For the whole series:

Tested-by: Mandeep Singh Baines <msb@chromium.org>

This was an important issue for us so I'm in the process of merging
these into the ChromiumOS kernel tree.

Thanks,
Mandeep

>
>  fs/coredump.c         |   33 +++++++++++++++++++--------------
>  include/linux/sched.h |    1 +
>  kernel/signal.c       |    6 ++++--
>  3 files changed, 24 insertions(+), 16 deletions(-)
>
