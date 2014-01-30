Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaA3PWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:22:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaA3PWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:22:14 -0500
Date: Thu, 30 Jan 2014 16:22:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 9/9] sched: Push down pre_schedule() and idle_balance()
Message-ID: <20140130152208.GA5002@laptop.programming.kicks-ass.net>
References: <20140128171634.974847076@infradead.org>
 <20140128171948.422404759@infradead.org>
 <CAKfTPtAMmhq0tBpu+pk_uzwrfUM-6Fz4Do1yrzc4NRQS4cZ_-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAMmhq0tBpu+pk_uzwrfUM-6Fz4Do1yrzc4NRQS4cZ_-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 01:45:07PM +0100, Vincent Guittot wrote:
> On 28 January 2014 18:16, Peter Zijlstra <peterz@infradead.org> wrote:
> > +idle:
> > +       idle_exit_fair(rq);
> 
> It should be idle_enter_fair.
> 
> we want to update the statistic with the running time of other classes
> than CFS.
> 
> The use case is:
> 
> exit idle
> put_prev_task_idle
> --> idle_exit_fair (account elapsed idle time)
> pick_next_task other than fair tasks
> switch between "other than fair" tasks
> ...
> no more "other than fair" tasks to schedule
> pick_next_task_fair
> --> no fair task on the rq
> --> jump to simple
> --> idle_enter_fair (account elapsed running time of other class
> before trying to pull fair task from other CPUs)
> --> idle_balance()
> ...

Right.. terminal confusion on this topic it seems. Fixed it up.
