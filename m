Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3LRRoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:44:10 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62015 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3LRRoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:44:08 -0500
Date: Wed, 18 Dec 2013 18:43:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 00/13] nohz: Use sysidle detection to let the
 timekeeper sleep
Message-ID: <20131218174355.GA19788@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <52B102BB.1050907@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B102BB.1050907@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:04:43AM +0800, Alex Shi wrote:
> On 12/18/2013 06:51 AM, Frederic Weisbecker wrote:
> > So this is what this series brings, more details following:
> > 
> > * Some code, naming and whitespace cleanups
> > 
> > * Allow all CPUs outside the nohz_full range to handle the timekeeping
> >   duty, not just CPU 0. Balancing the timekeeping duty should improve
> >   powersavings.
> 
> If the system just has one nohz_full cpu running, it will need another
> cpu to do timerkeeper job. Then the system roughly needs 2 cpu living.
> From powersaving POV, that is not good compare to normal nohz idle.

Sure, but everything has a tradeoff :)

We could theoretically run with the timekeeper purely idle if the other
CPU in full dynticks mode runs in userspace for a long while and seldom
do syscalls and faults. Timekeeping could be updated on kernel/user
boundaries in this case without much impact on performances.

But then there is one strict condition for that: it can't read the timeofday
through the vdso but only through a syscall.

Then if we can meet that condition, then CPU 0 could as well be full dynticks.

Now that's real extreme HPC ;)
