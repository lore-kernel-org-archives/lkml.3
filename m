Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3H3QcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:32:06 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:58349 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab3H3QcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
Date: Fri, 30 Aug 2013 09:32:02 -0700
X-Google-Sender-Auth: jz0Mbe_WHdCX9jDKvErmyPD9Myk
Message-ID: <CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 8:38 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> A Samsung series-5 ultrabook.
>
> $ grep "model name" /proc/cpuinfo | uniq
> model name      : Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz

Hmm. Do you have debugging options enabled? Because that CPU should
have the same core count as mine (two+HT), a slightly smaller cache
(3M vs 4M) and runs at a noticeably lower frequency (1.6GHz vs 3.5).
It probably also has slower memory etc, but that should still make it
maybe half speed of mine. Not 1/20th.

As mentioned, I get numbers in the 65M range. Yours are under 2.7M.
Even with some thermal throttling, I would expect better than that.

My pixel (1.8GHz i5-3427U) should be a *bit* faster that yours. And I
get 54M iterations on that.

I saw you mentioned CONFIG_CMPXCHG_LOCKREF=y in your .config, so you
don't have spinlock debugging enabled, but maybe you have some other
expensive debug option enabled. Like DEBUG_PAGEALLOC etc.

If you get "perf" compiled, mind doing a

    perf record -f -e cycles:pp ./a.out
    perf report

on it and look what that says?

              Linus
