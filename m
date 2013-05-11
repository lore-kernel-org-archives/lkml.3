Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3EKAdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:33:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41799 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3EKAdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:33:21 -0400
Date: Sat, 11 May 2013 02:33:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] posix_timers: do not account group_exec_runtime
 for dying autoreaped tasks
Message-ID: <20130511003317.GB13340@somewhere>
References: <1367258649.8833.19.camel@Wailaba2>
 <20130506231835.GC1225@somewhere>
 <1367897750.14310.59.camel@Wailaba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367897750.14310.59.camel@Wailaba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:35:50PM -0400, Olivier Langlois wrote:
> Frederic,
> 
> On Tue, 2013-05-07 at 01:18 +0200, Frederic Weisbecker wrote:
> > On Mon, Apr 29, 2013 at 02:04:09PM -0400, Olivier Langlois wrote:
> > > 
> > > 
> > > Forbids the cputimer to drift ahead of its process clock by
> > > blocking its update when a tick occurs while a autoreaping task
> > > is currently in do_exit() between the call to release_task() and
> > > its final call to schedule().
> > > 
> > > Any task stats update after having called release_task() will
> > > be lost because they are added to the global process stats located
> > > in the signal struct from release_task().
> > 
> > I wonder if this is real problem that the clock is ahead of the timer.
> > Have you seen any issue in practice with this?
> 
> note that it is the timer that will be ahead because the process clock
> is the sum of past group tasks exec time plus current group tasks exec
> time. Few updates are missing in the past group tasks exec time counter
> in struct signal.
> 
> The effect of this is failure of the unittest testing POSIX compliance
> in glibc rt/tst-cputimer1.c
> 
> pseudo code of the test is:
> 
> 1. call clock_gettime() to get now
> 2. Compute timer expiring time now+timer interval
> 3. call clock_gettime() when timer cb is called
> 4. Compare that clock_gettime() result is >= than computed expiring time
> 
> The error is adding up as more thread exits and usually the test fails
> when testing periodic timers where threads are created to handle the
> timer timeouts.

I see. Ok if it breaks a glibc test, it seems like a good reason to fix it :)

Thanks!
