Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbaKMODa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:03:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaKMOD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:03:29 -0500
Date: Thu, 13 Nov 2014 15:03:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@kernel.org, torvalds@linux-foundation.org, rjw@rjwysocki.net,
        hpa@zytor.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/wait: Reimplement wait_event_freezable()
Message-ID: <20141113140326.GA18995@amd>
References: <tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org>
 <20141104201203.GA15071@amd>
 <20141105081838.GN10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105081838.GN10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Did you test it with suspend/hibernation? Because I can't really see
> > how it works.
> 
> It calls try_to_freeze() after each schedule(). But no, I've not
> actually tried.
> 
> If we're stuck in the schedule, waiting for the event, freeze_task()
> will wake us up and then we'll find freeing() true and call into
> __refrigerator().
> 
> If we're not stuck in schedule() we're running and the freezer
> can see us running and will wait for us to hit another freeze point.

Ok, let me try it here.

> > > +#define __wait_event_freezable(wq, condition)				\
> > > +	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
> > > +			    schedule(); try_to_freeze())
> > > +
> 
> > _Three_ underscores. And two underscore version exists, too,
> > fortunately it at least has different number of arguments.
> 
> Hehe, yeah, there was a discount on underscores that day. The double
> underscore variants can be used in code along with the no underscores
> variants. The tripple one is implementation goo.

Lets see, add 5 underscore variant, and we have contestant for
obfuscated C code contest...

Anyway, it seems it works for me (tested suspend, not hibernation).

Test-by: Pavel Machek <pavel@ucw.cz>

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
