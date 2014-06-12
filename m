Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaFLRaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:30:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaFLRaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:30:11 -0400
Date: Thu, 12 Jun 2014 19:28:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140612172844.GA15795@redhat.com>
References: <alpine.DEB.2.10.1406101959420.5170@nanos> <20140610141306.04a4bcf3@gandalf.local.home> <alpine.DEB.2.10.1406102203430.5170@nanos> <alpine.DEB.2.10.1406102210580.5170@nanos> <20140611155251.GA4581@linux.vnet.ibm.com> <20140611170705.GA26816@redhat.com> <20140611171734.GA27457@redhat.com> <20140611172958.GF4581@linux.vnet.ibm.com> <20140611175934.GA28912@redhat.com> <20140611195613.GM4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611195613.GM4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Paul E. McKenney wrote:
>
> On Wed, Jun 11, 2014 at 07:59:34PM +0200, Oleg Nesterov wrote:
> > On 06/11, Paul E. McKenney wrote:
> > >
> > > I was thinking of ->boost_completion as the way to solve it easily, but
> > > what did you have in mind?
> >
> > I meant, rcu_boost() could probably just do "mtx->owner = t", we know that
> > it was unlocked by us and nobody else can use it until we set
> > t->rcu_boost_mutex.
>
> My concern with this is that rcu_read_unlock_special() could hypothetically
> get preempted (either by kernel or hypervisor), so that it might be a long
> time until it makes its reference.  But maybe that reference would be
> harmless in this case.

Confused... Not sure I understand what did you mean, and certainly I do not
understand how this connects to the proxy-locking method.

Could you explain?

> > And if we move it into rcu_node, then we can probably kill ->rcu_boost_mutex,
> > rcu_read_unlock_special() could check rnp->boost_mutex->owner == current.
>
> If this was anywhere near a hot code path, I would be sorely tempted.

Ah, but I didn't mean perfomance. I think it is always good to try to remove
something from task_struct, it is huge. I do not mean sizeof() in the first
place, the very fact that I can hardly understand the purpose of a half of its
members makes me sad ;)

Oleg.

