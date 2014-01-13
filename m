Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaAMSwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:52:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaAMSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:52:41 -0500
Date: Mon, 13 Jan 2014 19:52:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg
	of __lock_acquire()
Message-ID: <20140113185238.GB14125@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com> <20140112174532.GA12147@redhat.com> <20140112174554.GB12147@redhat.com> <20140113170609.GA9873@redhat.com> <20140113172833.GT31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113172833.GT31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Peter Zijlstra wrote:
>
> On Mon, Jan 13, 2014 at 06:06:09PM +0100, Oleg Nesterov wrote:
> >
> > And I just realized that rcu_lock_acquire() does lock_acquire(check => 1).
> > Probably we can mark rcu_lock_map's as __lockdep_no_validate__.
>
> Can't, RCU needs its own classes. Otherwise it cannot tell which version
> of the RCU read lock its holding at just that moment.

Ah, indeed. Thanks.

Can't it do lock_acquire(trylock => 1, read => 2) ? this still means
mark_irqflags(), but perhaps this won't hurt too much.

> At the very least we can reduce check to a single bit.

Or this, yes.

Oleg.

