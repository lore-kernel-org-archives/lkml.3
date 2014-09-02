Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaIBVK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:10:28 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:46557 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaIBVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:10:26 -0400
Date: Tue, 2 Sep 2014 23:10:19 +0200
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, luca.abeni@unitn.it, rdunlap@infradead.org,
        mingo@redhat.com, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Documentation/scheduler/sched-deadline.txt: fix
 terminology and improve clarity
Message-ID: <20140902211019.GA22581@sisyphus.home.austad.us>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
 <1409220029-9002-2-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409220029-9002-2-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:00:26AM +0100, Juri Lelli wrote:
> From: Luca Abeni <luca.abeni@unitn.it>
> 
> Several small changes regarding SCHED_DEADLINE documentation that fix
> terminology and improve clarity and readability:
> 
>  - "current runtime" becomes "remaining runtime"
> 
>  - readablity of an equation is improved by introducing more spacing
> 
>  - clarify when admission control will certainly fail
> 
>  - new URL for CBS technical report
> 
>  - substitue "smallest" with "closest"

I'm tempted to say "earliest" (being part of the algorithm's name and all 
;)

> 
> Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Henrik Austad <henrik@austad.us>
> Cc: Dario Faggioli <raistlin@linux.it>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/scheduler/sched-deadline.txt | 32 ++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index 18adc92..dce6d63 100644
> --- a/Documentation/scheduler/sched-deadline.txt
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -45,14 +45,14 @@ CONTENTS
>   every time the task wakes up, the scheduler computes a "scheduling deadline"
>   consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are then
>   scheduled using EDF[1] on these scheduling deadlines (the task with the
> - smallest scheduling deadline is selected for execution). Notice that this
> + closest scheduling deadline is selected for execution). Notice that this
>   guaranteed is respected if a proper "admission control" strategy (see Section
>   "4. Bandwidth management") is used.
>  
>   Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
>   that each task runs for at most its runtime every period, avoiding any
>   interference between different tasks (bandwidth isolation), while the EDF[1]
> - algorithm selects the task with the smallest scheduling deadline as the one
> + algorithm selects the task with the closest scheduling deadline as the one
>   to be executed first.  Thanks to this feature, also tasks that do not

s/first/next/

Also, next sentence does not make much sense, I would drop the also;

"Thanks to this feature, tasks that do not strictly comply with the ..."

>   strictly comply with the "traditional" real-time task model (see Section 3)
>   can effectively use the new policy.
> @@ -64,45 +64,45 @@ CONTENTS
>      "deadline", and "period" parameters;
>  
>    - The state of the task is described by a "scheduling deadline", and
> -    a "current runtime". These two parameters are initially set to 0;
> +    a "remaining runtime". These two parameters are initially set to 0;
>  
>    - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
>      the scheduler checks if
>  
> -                    current runtime                runtime
> -         ---------------------------------- > ----------------
> -         scheduling deadline - current time         period
> +                 remaining runtime                  runtime
> +        ----------------------------------    >    ---------
> +        scheduling deadline - current time           period
>
>      then, if the scheduling deadline is smaller than the current time, or
>      this condition is verified, the scheduling deadline and the
> -    current budget are re-initialised as
> +    remaining runtime are re-initialised as
>  
>           scheduling deadline = current time + deadline
> -         current runtime = runtime
> +         remaining runtime = runtime
>  
> -    otherwise, the scheduling deadline and the current runtime are
> +    otherwise, the scheduling deadline and the remaining runtime are
>      left unchanged;
>  
>    - When a SCHED_DEADLINE task executes for an amount of time t, its
> -    current runtime is decreased as
> +    remaining runtime is decreased as
>  
> -         current runtime = current runtime - t
> +         remaining runtime = remaining runtime - t
>  
>      (technically, the runtime is decreased at every tick, or when the
>      task is descheduled / preempted);
>  
> -  - When the current runtime becomes less or equal than 0, the task is
> +  - When the remaining runtime becomes less or equal than 0, the task is
>      said to be "throttled" (also known as "depleted" in real-time literature)
>      and cannot be scheduled until its scheduling deadline. The "replenishment
>      time" for this task (see next item) is set to be equal to the current
>      value of the scheduling deadline;
>  
>    - When the current time is equal to the replenishment time of a
> -    throttled task, the scheduling deadline and the current runtime are
> +    throttled task, the scheduling deadline and the remaining runtime are
>      updated as
>  
>           scheduling deadline = scheduling deadline + period
> -         current runtime = current runtime + runtime
> +         remaining runtime = remaining runtime + runtime
>  
>  
>  3. Scheduling Real-Time Tasks
> @@ -147,6 +147,8 @@ CONTENTS
>   and the absolute deadlines (d_j) coincide, so a proper admission control
>   allows to respect the jobs' absolute deadlines for this task (this is what is
>   called "hard schedulability property" and is an extension of Lemma 1 of [2]).
> + Notice that if runtime > deadline the admission control will surely reject
> + this task, as it is not possible to respect its temporal constraints.
>  
>   References:
>    1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
> @@ -156,7 +158,7 @@ CONTENTS
>        Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
>        Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
>    3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
> -      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
> +      Technical Report. http://disi.unitn.it/~abeni/tr-98-01.pdf
>  
>  4. Bandwidth management
>  =======================
> -- 
> 2.0.4

Apart from the minor nitpick, it looks good!

-- 
Henrik
