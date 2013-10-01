Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3JAPXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab3JAPXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:23:36 -0400
Date: Tue, 1 Oct 2013 17:16:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20131001151638.GA2246@redhat.com>
References: <20130930152242.207382649@infradead.org> <20130930174054.GA28129@redhat.com> <20130930180939.GN15690@laptop.programming.kicks-ass.net> <20130930181358.GA29544@redhat.com> <20131001140940.GA32328@redhat.com> <20131001143921.GO3657@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001143921.GO3657@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Peter Zijlstra wrote:
>
> On Tue, Oct 01, 2013 at 04:09:40PM +0200, Oleg Nesterov wrote:
> > But somehow I didn't realize that ___wait_cond_timeout() can be used
> > as is, so the simple patch below should work?
>
> Yeah, should work.. But how often do people use timeout=0?

I do not know. Perhaps never.

> Should we
> really care about that case to the effect of adding more code.

Again, I do not really know. But imo it would be better to fix
this anyway, even if the problem is really minor. If nothing
else, wait_event_timeout() and __wait_event_timeout() should have
the same semantics.

And suppose that we ha a helper(timeout) which calls wait_event_timeout(),
and checks the non-trivial condition inside. Now suppose that someone
does

	timeout = DEFAULT_TIMEOUT;

	if (option_nonblock)
		timeout = 0;

	ok = helper(timeout);

So do you think we should ignore this or I should send 7/6 with the
changelog ?

(In fact I am going to send another patch on top of this series later.
 At least, try to send for discussion because I know you dislike the
 idea to move the signal-pending checks out of line).

Oleg.

