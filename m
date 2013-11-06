Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3KFQpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:45:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32920 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KFQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:45:31 -0500
Date: Wed, 6 Nov 2013 17:45:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131106164525.GF16117@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927152908.GE15690@laptop.programming.kicks-ass.net>
 <20131106113704.41b6ed5c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106113704.41b6ed5c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:37:04AM -0500, Steven Rostedt wrote:
> On Fri, 27 Sep 2013 17:29:08 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri Sep 27 17:11:00 CEST 2013
> > 
> > Since we now have two need_resched states; trace the two so we can
> > observe discrepancies.
> 
> I see this is dependent on the addition of tif_need_resched() and
> friends.

This also wasn't the last version of the patch, I distinctly remember
you making me update some documentation crap.

> > +
> > +	if ((entry->flags & TRACE_FLAG_NEED_RESCHED) &&
> > +	    (entry->flags & TRACE_FLAG_PREEMPT_RESCHED))
> > +		need_resched = 'N';
> > +	else if (entry->flags & TRACE_FLAG_NEED_RESCHED)
> > +		need_resched = 'n';
> > +	else if (entry->flags & TRACE_FLAG_PREEMPT_RESCHED)
> > +		need_resched = 'p';
> > +	else
> > +		need_resched = '.';
> 
> Perhaps we should make this a switch statement?
> 
> 	switch (entry->flags & (TRACE_FLAG_NEED_RESCHED |
> 				TRACE_FLAG_PREEMPT_RESCHED)) {
> 	case TRACE_FLAG_NEED_RESCHED | TRACE_FLAG_PREEMPT_RESCHED:
> 		need_resched = 'N';
> 		break;
> 	case TRACE_FLAG_NEED_RESCHED:
> 		need_resched = 'n';
> 		break;
> 	case TRACE_FLAG_PREEMPT_RESCHED:
> 		need_resched = 'p';
> 		break;
> 	default:
> 		need_resched = '.';
> 		break;
> 	}
> 
> Simply because I find switch statements easier to read than else if
> statements.

Sure whatever your code ;-), but says he who wrote:

	hardsoft_irq =
		(hardirq && softirq) ? 'H' :
		hardirq ? 'h' :
		softirq ? 's' :
		'.';

Just apply the later patch and change it however you like.
