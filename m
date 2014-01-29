Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaA2Xjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:39:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53030 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaA2Xjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:39:43 -0500
Date: Wed, 29 Jan 2014 15:39:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: josh@joshtriplett.org, peterz@infradead.org, oleg@redhat.com,
        rostedt@goodmis.org, bitbucket@online.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL timers] Timer-wheel bandaids^Wcommits
Message-ID: <20140129233936.GA11150@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012923-1542-0000-0000-0000059F68BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request contains latency bandaids^Woptimizations to the
timer-wheel code that are useful in conjunction with NO_HZ_FULL Kconfig
option.  These optimizations reduce the jiffy-by-jiffy looping in cases
where there is either zero or one timers in the timer wheel, which is
a common case for NO_HZ_FULL "worker" CPUs that run almost entirely
in usermode for a single task.

Each of these commits has at least two Reviewed-by, one Acked-by, and
one Tested-by tag, so they are ready for more extensive testing in -tip.

							Thanx, Paul

The following changes since commit 00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506:

  clocksource: Timer-sun5i: Switch to sched_clock_register() (2014-01-19 13:23:23 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/timers

for you to fetch changes up to 6f089d0be7fef9705b3a7755b05d1092e772b910:

  timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0 (2014-01-29 15:25:16 -0800)

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

