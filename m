Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab3CUScd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3CUScc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:32:32 -0400
Date: Thu, 21 Mar 2013 19:30:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130321183021.GA27586@redhat.com>
References: <20130314162413.GA21344@redhat.com> <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com> <20130315134632.GA18335@redhat.com> <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com> <20130315165131.GA32065@redhat.com> <20130317172621.GQ3656@linux.vnet.ibm.com> <20130321170827.GA23539@redhat.com> <1363889025.4431.35.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363889025.4431.35.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Eric Dumazet wrote:
>
> On Thu, 2013-03-21 at 18:08 +0100, Oleg Nesterov wrote:
>
> > OK... since nobody volunteered to make a patch, what do you think about
> > the change below?
> >
> > It should "fix" atomic_add_unless() (only on x86) and optimize
> > atomic_inc/dec_unless.
> >
> > With this change atomic_*_unless() can do the unnecessary mb() after
> > cmpxchg() fails, but I think this case is very unlikely.
> >
> > And, in the likely case atomic_inc/dec_unless avoids the 1st cmpxchg()
> > which in most cases just reads the memory for the next cmpxchg().
> >
> > Oleg.
>
> Hmm, cmpxchg() has different effect on MESI transaction, than a plain
> read.

But this doesn't matter?

We will do cmpxchg() anyway. Unless we can see that it will fail.

Or could you explain what I missed?

> maybe the 'hint' idea used in atomic_inc_not_zero_hint() could be used.

To me, it would be better to kill atomic_inc_not_zero_hint() or unify
unify it with atomic_inc_not_zero(). But this is another story.

Oleg.

