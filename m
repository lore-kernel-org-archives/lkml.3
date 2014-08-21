Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaHUNqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:46:32 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35600 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaHUNqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:46:30 -0400
Date: Thu, 21 Aug 2014 15:46:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, luca.abeni@unitn.it, rdunlap@infradead.org,
        mingo@redhat.com, henrik@austad.us, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Documentation/scheduler/sched-deadline.txt:
 Rewrite section 4 intro
Message-ID: <20140821134625.GB29495@gmail.com>
References: <1408611700-9420-1-git-send-email-juri.lelli@arm.com>
 <1408611700-9420-3-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408611700-9420-3-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Juri Lelli <juri.lelli@arm.com> wrote:

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
>  Documentation/scheduler/sched-deadline.txt | 49 +++++++++++++++---------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index dce6d63..8372c3d 100644
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
>   and thus we don't need an higher level throttling mechanism to enforce the

s/an higher/a higher

> - desired bandwidth.
> + desired bandwidth. Therefore, using this simple interface, we can put a cap

s/interface, we/interface we

> + on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
> + some_desired_value).

Thanks,

	Ingo

