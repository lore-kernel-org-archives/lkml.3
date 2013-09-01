Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab3IAPz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:55:59 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42154 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3IAPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUWPUDorK+9KRD-H3FpbDeC_7LMatzrYk35jZk13vNuLBQ@mail.gmail.com>
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
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+icZUWPUDorK+9KRD-H3FpbDeC_7LMatzrYk35jZk13vNuLBQ@mail.gmail.com>
Date: Sun, 1 Sep 2013 08:55:56 -0700
X-Google-Sender-Auth: l0nGBJJdjyeqvGJygf8ssmr1kYo
Message-ID: <CA+55aFzBBADPxK3mJrKt2Qx-y-VJjk9fOrN6A0YRPrujXBNeQg@mail.gmail.com>
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

On Sun, Sep 1, 2013 at 8:45 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Samples: 160K of event 'cycles:pp', Event count (approx.): 77003901089
> +  12,46%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
> +   4,86%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
> +   4,42%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
> +   4,28%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals

You need to go into __ticket_spin_lock to see who the callers are.

Just go down to it and press enter to expand it (and then you need to
go and expand that entry too to get the callers)

I still don't know how you get to irq_return. It should use sysret. Odd.

            Linus
