Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaB0MxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:53:16 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35444 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaB0MxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:53:14 -0500
Date: Thu, 27 Feb 2014 13:53:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [GIT PULL] timers update for 3.15
Message-ID: <20140227125306.GA17608@localhost.localdomain>
References: <1393433525-5765-1-git-send-email-fweisbec@gmail.com>
 <20140227121707.GE9712@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227121707.GE9712@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:17:07PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the timers/core branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	timers/core
> > ---
> > 
> > * The patch from Viresh removes some unecessary scheduler IPIs that wake
> >   up the CPUs when deferrable timers are enqueued on remote targets.
> > 
> >   In practice I have seen on boot some of these IPIs from various
> >   sources:  MCE, vmstat/SLAB, cpufreq. They happen either on initcall
> >   or cpu hotplug. Since these timers are enqueued on all CPUs, there
> >   are some potential big rounds of IPIs that are spared with this patch.
> >   
> >   But it's just what I've seen on my own machine on boot. I expect some
> >   more scenarios where a few IPIs will be avoided depending on configs
> >   and usecases because we have some more users of deferrable timers.
> > 
> > * Kconfig text made clearer for full dynticks by Paul Gortmaker.
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Paul Gortmaker (1):
> >       nohz: ensure users are aware boot CPU is not NO_HZ_FULL
> > 
> > Viresh Kumar (1):
> >       timer: Spare IPI when deferrable timer is queued on idle remote targets
> > 
> > 
> >  kernel/time/Kconfig | 2 +-
> >  kernel/timer.c      | 9 ++++++++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> So I wanted to pull this fine set of commits, just to discover that 
> Thomas already pulled it into timers/core :-)

Ah! Now I understand why it was pulled silently in the evening ;)
