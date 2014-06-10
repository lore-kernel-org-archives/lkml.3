Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaFJUpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:45:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:55340 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFJUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:45:15 -0400
Date: Tue, 10 Jun 2014 22:45:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
In-Reply-To: <20140610134745.668c8a4e@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406102244080.5170@nanos>
References: <20140609201118.387571774@linutronix.de> <20140609202336.506044876@linutronix.de> <20140609212033.1cff0999@gandalf.local.home> <alpine.DEB.2.10.1406101630350.31315@nanos> <20140610134745.668c8a4e@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Steven Rostedt wrote:

> On Tue, 10 Jun 2014 19:41:39 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>  
> > > On the loop back around, have something like:
> > > 
> > > 	if (top_waiter) {
> > > 		if (!task_has_pi_waiters(task))
> > > 			goto out_unlock_pi;
> > 
> > 	The task has at least one pi waiter.
> >  
> > > 		if (!requeue &&
> > > 		    top_waiter != task_top_pi_waiter(task)) {
> > > 			if (!detect_deadlock)
> > > 				goto out_unlock_pi;
> > > 			else
> > > 				requeue = false;
> > > 		}
> > 
> > 	Errm? if requeue is off we are in deadlock detection chainwalk
> > 	mode. So all we care about is whether task is blocked on
> > 	next_lock or not.
> 
> Actually that was a typo on my part. That should have been:
> 
> 	if (requeue &&
> 		...
> 
> As we don't need to read the task_top_pi_waiter() again.

     if (requeue ...

is completely pointless as the code you were talking about is in the

   if (!requeue) {

branch. So what?

Thanks,

	tglx
