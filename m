Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3I3PHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:07:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I3PHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:07:17 -0400
Date: Mon, 30 Sep 2013 17:06:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20130930150653.GL26785@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130929183634.GA15563@redhat.com>
 <20130930125942.GB12926@twins.programming.kicks-ass.net>
 <20130930142400.GK26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930142400.GK26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:24:00PM +0200, Peter Zijlstra wrote:
> For that we'd have to decrement xxx->gp_count from cb_rcu_func(),
> wouldn't we?
> 
> Without that there's no guarantee the fast path readers will have a MB
> to observe the write critical section, unless I'm completely missing
> something obviuos here.

Duh.. we should be looking at gp_state like Paul said.
