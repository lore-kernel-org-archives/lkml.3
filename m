Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaIBVOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:14:48 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55303 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaIBVOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:14:46 -0400
Date: Tue, 2 Sep 2014 23:14:39 +0200
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, luca.abeni@unitn.it, rdunlap@infradead.org,
        mingo@redhat.com, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Documentation/scheduler/sched-deadline.txt:
 Rewrite section 4 intro
Message-ID: <20140902211439.GB22581@sisyphus.home.austad.us>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
 <1409220029-9002-3-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409220029-9002-3-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:00:27AM +0100, Juri Lelli wrote:
> Section 4 intro was still describing the old interface. Rewrite it.
> 
> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Henrik Austad <henrik@austad.us>
> Cc: Dario Faggioli <raistlin@linux.it>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/scheduler/sched-deadline.txt | 51 +++++++++++++++---------------
>  1 file changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index dce6d63..0aff2d5 100644
> --- a/Documentation/scheduler/sched-deadline.txt
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -165,39 +165,38 @@ CONTENTS
>  
>   In order for the -deadline scheduling to be effective and useful, it is
>   important to have some method to keep the allocation of the available CPU
> - bandwidth to the tasks under control.
> - This is usually called "admission control" and if it is not performed at all,
> - no guarantee can be given on the actual scheduling of the -deadline tasks.
> -
> - Since when RT-throttling has been introduced each task group has a bandwidth
> - associated, calculated as a certain amount of runtime over a period.
> - Moreover, to make it possible to manipulate such bandwidth, readable/writable
> - controls have been added to both procfs (for system wide settings) and cgroupfs
> - (for per-group settings).
> - Therefore, the same interface is being used for controlling the bandwidth
> - distrubution to -deadline tasks.
> -
> - However, more discussion is needed in order to figure out how we want to manage
> - SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
> - uses (for now) a less sophisticated, but actually very sensible, mechanism to
> - ensure that a certain utilization cap is not overcome per each root_domain.
> -
> - Another main difference between deadline bandwidth management and RT-throttling
> + bandwidth to the tasks under control. This is usually called "admission
> + control" and if it is not performed at all, no guarantee can be given on
> + the actual scheduling of the -deadline tasks.
> +
> + The interface used to control the fraction of CPU bandwidth that can be
> + allocated to -deadline tasks is similar to the one already used for -rt
> + tasks with real-time group scheduling (a.k.a. RT-throttling - see
> + Documentation/scheduler/sched-rt-group.txt), and is based on readable/
> + writable control files located in procfs (for system wide settings).
> + Notice that per-group settings (controlled through cgroupfs) are still not
> + defined for -deadline tasks, because more discussion is needed in order to
> + figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
> + level.
> +
> + A main difference between deadline bandwidth management and RT-throttling
>   is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
> - and thus we don't need an higher level throttling mechanism to enforce the
> - desired bandwidth.
> + and thus we don't need a higher level throttling mechanism to enforce the
> + desired bandwidth. Therefore, using this simple interface we can put a cap
> + on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
> + some_desired_value).

s/some_desired_value/global_dl_utilization_cap/  perhaps?

>  4.1 System wide settings
>  ------------------------
>  
>   The system wide settings are configured under the /proc virtual file system.
>  
> - For now the -rt knobs are used for dl admission control and the -deadline
> - runtime is accounted against the -rt runtime. We realise that this isn't
> - entirely desirable; however, it is better to have a small interface for now,
> - and be able to change it easily later. The ideal situation (see 5.) is to run
> - -rt tasks from a -deadline server; in which case the -rt bandwidth is a direct
> - subset of dl_bw.
> + For now the -rt knobs are used for -deadline admission control and the
> + -deadline runtime is accounted against the -rt runtime. We realise that this
> + isn't entirely desirable; however, it is better to have a small interface for
> + now, and be able to change it easily later. The ideal situation (see 5.) is to
> + run -rt tasks from a -deadline server; in which case the -rt bandwidth is a
> + direct subset of dl_bw.

Isn't forking forbidden for _dl tasks? Or did I miss a memo somewhere?

>   This means that, for a root_domain comprising M CPUs, -deadline tasks
>   can be created while the sum of their bandwidths stays below:
> -- 
> 2.0.4
> 
> 

All in all, looks pretty good to me!

-- 
Henrik
