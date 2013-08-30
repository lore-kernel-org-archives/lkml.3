Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3H3R0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:26:11 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40449 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3H3R0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUWtEHy3CLadSQBKT5++UOxJuV-uxFf=UdAZLqysfourzw@mail.gmail.com>
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
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUWtEHy3CLadSQBKT5++UOxJuV-uxFf=UdAZLqysfourzw@mail.gmail.com>
Date: Fri, 30 Aug 2013 10:26:07 -0700
X-Google-Sender-Auth: 3wE6KFWn0Whf1eUC02QqTmObWA8
Message-ID: <CA+55aFzV-S+bxBQN52wgT8vPwNjXHgkUYOnQi9cEeoUYoQnmVA@mail.gmail.com>
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

On Fri, Aug 30, 2013 at 10:11 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> There is no -f option for record but for report, so I swapped them:

That's odd. "perf record -f" very much works for me, and I use it all
the time to make sure that I don't mix perf data from older runs..

[ Time passes. I check current 'perf'. Dammit. This has changed. I
seldom rebuild "perf", so I never noticed. It was removed in commit
4a4d371a4dfb, apparently because the old "append" mode no longer even
exists ]

But never mind, that doesn't matter for your numbers:

> $ sudo ~/src/linux-kernel/linux/tools/perf/perf report -f
>
> Samples: 159K of event 'cycles:pp', Event count (approx.): 76535356682
>  84,10%  t_lockref_from-  [kernel.kallsyms]     [k] check_poison_obj
>   5,22%  t_lockref_from-  [kernel.kallsyms]     [k] memset
>   1,15%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
>   0,45%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
>   0,44%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_free

You're wasting all the time in slab debugging, probably due to the
object debug option.

None of the rest is even remotely interesting, and the spinlock hits
you do have are more likely to come from the same object debug code
than from pathname lookup.

                Linus
