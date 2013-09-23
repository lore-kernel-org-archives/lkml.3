Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3IWQDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:03:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3IWQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:03:10 -0400
Date: Mon, 23 Sep 2013 18:02:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923160254.GD9326@twins.programming.kicks-ass.net>
References: <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
 <20130923145446.GX9326@twins.programming.kicks-ass.net>
 <20130923111303.04b99db8@gandalf.local.home>
 <20130923152223.GZ9326@twins.programming.kicks-ass.net>
 <20130923115908.6e710d29@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923115908.6e710d29@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:59:08AM -0400, Steven Rostedt wrote:
> On Mon, 23 Sep 2013 17:22:23 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Still no point in using srcu for this; preempt_disable +
> > synchronize_sched() is similar and much faster -- its the rcu_sched
> > equivalent of what you propose.
> 
> To be honest, I sent this out last week and it somehow got trashed by
> my laptop and connecting to my smtp server. Where the last version of
> your patch still had the memory barrier ;-)

Ah, ok, yes in that case things start to make sense again.
