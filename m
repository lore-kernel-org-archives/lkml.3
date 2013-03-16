Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3CPSVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab3CPSVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:21:48 -0400
Date: Sat, 16 Mar 2013 19:19:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130316181947.GA7560@redhat.com>
References: <20130314162413.GA21344@redhat.com> <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com> <20130315134632.GA18335@redhat.com> <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com> <20130315165131.GA32065@redhat.com> <CAFTL4hxNh5qMZyyrLc8_yG5-i7UoS_nan22pO8o1fb8yS7Vz3w@mail.gmail.com> <20130315175117.GA2462@redhat.com> <CAFTL4hwZQcN_sO0SN8bJqEsQdC8ArDvJhFPg62Kh8OQyUe=MUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwZQcN_sO0SN8bJqEsQdC8ArDvJhFPg62Kh8OQyUe=MUw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Frederic Weisbecker wrote:
>
> 2013/3/15 Oleg Nesterov <oleg@redhat.com>:
> >
> > do_something() looks fine, if atomic_add_unless_negative() succeeds
> > we do have a barrier?
>
> Ok, I guess the guarantee of a barrier in case of failure is probably
> not needed. But since the only way to safely read the atomic value is
> a cmpxchg like operation, I guess a barrier must be involved in any
> case.
>
> Using atomic_read() may return some stale value.

Oh, if the lack of the barrier is fine, then "stale" should be fine
too, I think. I bet you can't describe accurately what "stale" can
actually mean in this case ;)

If, say, atomic_inc_unless_negative(p) sees the stale value < 0, it
was actually negative somewhere in the past. If it was changed later,
we can pretend that atomic_inc_unless_negative() was called before
the change which makes it positive.

> > Anyway, I understand that it is possible to write the code which
> > won't work without the uncoditional mb().
>
> Yeah that's my fear.

I see... well personally I can't imagine the "natural" (non-artificial)
code example which needs mb() in case of failure.


However, I have to agree with Paul's "It is not like memory ordering is
simple", so I won't argue.

> > My point was: should we fix atomic_add_unless() then? If not, why
> > should atomic_add_unless_negative() differ?
>
> They shouldn't differ I guess.

Agreed, they shouldn't.

Oleg.

