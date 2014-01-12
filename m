Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaALRpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:45:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaALRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:45:44 -0500
Date: Sun, 12 Jan 2014 18:45:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/1] lockdep: Kill held_lock->check and "int check" arg of
	__lock_acquire()
Message-ID: <20140112174532.GA12147@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112094041.GB31809@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Ingo Molnar wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
> > > But what I really can't understans is what "check == 0" means? It
> > > seems that in fact it can be 1 or 2? Or, iow, "check == 0" is
> > > actually equivalent to "check == 1" ?
> >
> > Hmm indeed, the comment in lockdep.h says 0 means no checks at all,
> > but the code doesn't actually appear to work like that. I'm not sure
> > it ever did or not, I'd have to go dig through history.
> >
> > That said, given the current state it certainly looks like we can
> > remove the check argument.
> >
> > Ingo?
>
> Agreed.

OK, could you and Peter review the patch?

If it passes the review I'll send another one which changes the callers
of lock_acquire(). And trace_lock_acquire() should be trivially updated
too.

But could someone please explain me what should lockdep_no_validate
actually do? 1704f47b5 "lockdep: Add novalidate class for dev->mutex
conversion" doesn't tell which kind of warnings it tries to avoid,
and it looks buggy (see another email from me).

Oleg.

