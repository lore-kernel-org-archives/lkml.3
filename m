Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaB1B1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:27:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49981 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaB1B1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:27:10 -0500
Date: Thu, 27 Feb 2014 17:27:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        oleg@redhat.com, rostedt@goodmis.org, bitbucket@online.de
Subject: [GIT PULL timers] Timer-wheel bandaids^Wcommits for 3.15
Message-ID: <20140228012704.GA20805@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022801-0928-0000-0000-0000000B8AAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas and Ingo,

This pull request contains latency bandaids^Woptimizations to the
timer-wheel code that are useful in conjunction with NO_HZ_FULL Kconfig
option.  These optimizations reduce the jiffy-by-jiffy looping in cases
where there is either zero or one timers in the timer wheel, which is
a common case for NO_HZ_FULL "worker" CPUs that run almost entirely
in usermode for a single task.

This is of course no substitute for a more extensive reworking of the
timer-wheel code, but it does provide some simple patches that can
provide significant latency improvements for NO_HZ_FULL systems that
have CPUs that very rarely enter the kernel.

							Thanx, Paul

These changes since commit 849401b66d305f3feb75b6db7459b95ad190552a:

  tick: Fixup more fallout from hrtimer broadcast mode (2014-02-09 15:11:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git timers.2014.02.25a

for you to fetch changes up to aea369b959bef10d235cd0714789cd8b0fe170b8:

  timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0 (2014-02-25 12:39:01 -0800)

----------------------------------------------------------------
Oleg Nesterov (1):
      timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0

Paul E. McKenney (4):
      timers: Track total number of timers in list
      timers: Reduce __run_timers() latency for empty list
      timers: Reduce future __run_timers() latency for newly emptied list
      timers: Reduce future __run_timers() latency for first add to empty list

 kernel/timer.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

