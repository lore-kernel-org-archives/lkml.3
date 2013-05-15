Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab3EOQ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:59:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54727
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759374Ab3EOQ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:59:29 -0400
Date: Wed, 15 May 2013 18:59:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515165915.GE13916@laptop.home>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368631622.6828.69.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:27:02AM -0400, Steven Rostedt wrote:
> Right now perf requires a tick, not sure exactly why, but you can look
> at the code in perf_event_task_tick(). Thus if NO_HZ_FULL sees that a
> perf tick is pending, it won't disable ticks. Unfortunately, the
> watchdogs, both NMI and soft lockup, use the perf infrastructure to
> trigger NMIs or interrupts. This adds a perf element on the rotate list
> and keeps NO_HZ_FULL from *ever* activating.
> 

Hmm.. Stephane had a bunch of patches converting the rotation thing to
an hrtimer. I seem to have forgotten what happened to them but I can't
seem to find them merged.

I'll go look.

That leaves the frequency stuff, but the watchdog doesn't use that.

At which point we could run the watchdog without perf_event_task_tick().
> 
