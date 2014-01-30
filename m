Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaA3Fo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:44:58 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46984 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaA3Fo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:44:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140129233936.GA11150@linux.vnet.ibm.com>
References: <20140129233936.GA11150@linux.vnet.ibm.com>
Date: Thu, 30 Jan 2014 11:14:57 +0530
Message-ID: <CAM4v1pM_6G9ELtwdDe6K+4=MCT2giKSx-jok0RioDy7auJxegA@mail.gmail.com>
Subject: Re: [GIT PULL timers] Timer-wheel bandaids^Wcommits
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: mingo@kernel.org, josh@joshtriplett.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com,
        rostedt@goodmis.org, bitbucket@online.de,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

The commit id:e1d690cdc07637131ba4334: timers: Track total number of
timers in list has
a minor glitch in the changelog.

I am referring to your
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
rcu/timers branch.

"even if ->active_timers is zero, there might well be *non-deferrable*
timers in the list"

s/non-deferrable/deferrable.

Thanks

Regards
Preeti U Murthy

On Thu, Jan 30, 2014 at 5:09 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello, Ingo,
>
> This pull request contains latency bandaids^Woptimizations to the
> timer-wheel code that are useful in conjunction with NO_HZ_FULL Kconfig
> option.  These optimizations reduce the jiffy-by-jiffy looping in cases
> where there is either zero or one timers in the timer wheel, which is
> a common case for NO_HZ_FULL "worker" CPUs that run almost entirely
> in usermode for a single task.
>
> Each of these commits has at least two Reviewed-by, one Acked-by, and
> one Tested-by tag, so they are ready for more extensive testing in -tip.
>
>                                                         Thanx, Paul
>
> The following changes since commit 00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506:
>
>   clocksource: Timer-sun5i: Switch to sched_clock_register() (2014-01-19 13:23:23 +0100)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/timers
>
> for you to fetch changes up to 6f089d0be7fef9705b3a7755b05d1092e772b910:
>
>   timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0 (2014-01-29 15:25:16 -0800)
>
> ----------------------------------------------------------------
> Oleg Nesterov (1):
>       timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0
>
> Paul E. McKenney (4):
>       timers: Track total number of timers in list
>       timers: Reduce __run_timers() latency for empty list
>       timers: Reduce future __run_timers() latency for newly emptied list
>       timers: Reduce future __run_timers() latency for first add to empty list
>
>  kernel/timer.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
