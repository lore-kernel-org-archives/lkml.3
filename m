Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaAPLid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:38:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34928 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaAPLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:38:31 -0500
Date: Thu, 16 Jan 2014 12:38:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, tglx@linutronix.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        Michael wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
Message-ID: <20140116113801.GN31570@twins.programming.kicks-ass.net>
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
 <20140115073533.GU31570@twins.programming.kicks-ass.net>
 <52D69D44.4090504@linaro.org>
 <52D7BC71.9010908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7BC71.9010908@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 12:03:13PM +0100, Daniel Lezcano wrote:
> Hi Alex,
> 
> it is a nice optimization attempt but I agree with Peter we should focus on
> integrating cpuidle.
> 
> The question is "how do we integrate cpuidle ?"
> 
> IMHO, the main problem are the governors, especially the menu governor.

Yah.

> The menu governor tries to predict the events per cpu. This approach which
> gave us a nice benefit for the power saving may not fit well for the
> scheduler.

So the way to start all this is I think to gradually share more and
more.

Start by pulling in the actual idle state; such that we can indeed
observe what the relative cost is of waking a cpu (against another), and
maybe even the predicted wakeup time.

Then pull in the various statistics gathering bits -- without improving
them.

Then improve the statistics; try and remove duplicate statistics -- if
there's such things, try and use the extra information the scheduler has
etc..

Then worry about the governors, or what's left of them.

> In order to finish integrating the cpuidle framework in the scheduler, there
> are pending questions about the impact in the current design.
> 
> Peter or Ingo, if you have time, could you have a look at the email I sent
> previously [1] ?

I read it once, it didn't make sense at the time, I just read it again,
still doesn't make sense.

We need the idle task, since we need to DO something to go idle, the
scheduler needs to pick a task to go do that something. This is the idle
task.

You cannot get rid of that.

In fact, the 'doing' of that task is running much of the cpuidle code,
so by getting rid of it, there's nobody left to execute that code.

Also, since its already running that cpuidle stuff, integrating it more
closely with the scheduler will not in fact change much, it will still
run it.

Could of course be I'm not reading what you meant to write, if so, do
try again ;-)
