Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3I3RFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:05:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3I3RFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:05:11 -0400
Date: Mon, 30 Sep 2013 18:58:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] introduce synchronize_sched_{enter,exit}()
Message-ID: <20130930165801.GB25642@redhat.com>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de> <1378805550-29949-38-git-send-email-mgorman@suse.de> <20130917143003.GA29354@twins.programming.kicks-ass.net> <20130929183634.GA15563@redhat.com> <20130930125942.GB12926@twins.programming.kicks-ass.net> <20130930142400.GK26785@twins.programming.kicks-ass.net> <20130930150653.GL26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930150653.GL26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Peter Zijlstra wrote:
>
> On Mon, Sep 30, 2013 at 04:24:00PM +0200, Peter Zijlstra wrote:
> > For that we'd have to decrement xxx->gp_count from cb_rcu_func(),
> > wouldn't we?
> >
> > Without that there's no guarantee the fast path readers will have a MB
> > to observe the write critical section, unless I'm completely missing
> > something obviuos here.
>
> Duh.. we should be looking at gp_state like Paul said.

Yes, yes, that is why we have xxx_is_idle(). Its name is confusing
even ignoring "xxx".

OK, I'll try to invent the naming (but I'd like to hear suggestions ;)
and send the patch. I am going to add "exclusive" and "rcu_domain/ops"
later, currently percpu_rw_semaphore needs ->rw_sem anyway.

Oleg.

