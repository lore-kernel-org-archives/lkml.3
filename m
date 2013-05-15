Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab3EOQIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3EOQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:08:50 -0400
Date: Wed, 15 May 2013 12:26:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515162654.GR23604@redhat.com>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368631622.6828.69.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:27:02AM -0400, Steven Rostedt wrote:
> > Coming into the middle of the thread is always hard, but why/how does perf
> > disable nohz_full?  I didn't think the hardware events of perf would cause
> > problems as they are no different than an irq.  Curious.
> 
> Right now perf requires a tick, not sure exactly why, but you can look
> at the code in perf_event_task_tick(). Thus if NO_HZ_FULL sees that a
> perf tick is pending, it won't disable ticks. Unfortunately, the
> watchdogs, both NMI and soft lockup, use the perf infrastructure to
> trigger NMIs or interrupts. This adds a perf element on the rotate list
> and keeps NO_HZ_FULL from *ever* activating.

Ok.  Thanks.  I don't know what the rotate list is for (nor what it does
in general).  But I'll poke around.

Cheers,
Don
