Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaHLR5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:57:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaHLR5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:57:05 -0400
Message-ID: <53EA556C.6020004@infradead.org>
Date: Tue, 12 Aug 2014 10:57:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org
CC: luca.abeni@unitn.it, mingo@redhat.com, henrik@austad.us, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation/scheduler/sched-deadline.txt: add tests
 suite appendix
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com> <1407858555-14371-5-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1407858555-14371-5-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 08:49, Juri Lelli wrote:
> Add an appendix briefly describing tools that can be used to test SCHED_DEADLINE
> (and the scheduler in general). Links to where source code of the tools is hosted
> are also provided.
> 
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
>  Documentation/scheduler/sched-deadline.txt |   52 ++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index d056034..52eb25f 100644
> --- a/Documentation/scheduler/sched-deadline.txt
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -15,6 +15,7 @@ CONTENTS
>   5. Tasks CPU affinity
>     5.1 SCHED_DEADLINE and cpusets HOWTO
>   6. Future plans
> + A. Test suite
>  
>  
>  0. WARNING
> @@ -339,3 +340,54 @@ CONTENTS
>   throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
>   the preliminary phases of the merge and we really seek feedback that would
>   help us decide on the direction it should take.
> +
> +Appendix A. Test suite
> +======================
> +
> + The SCHED_DEADLINE policy can be easily tested using two applications that
> + are part of a wider Linux Scheduler validation suite. The suite is
> + available as a GitHub repository: https://github.com/scheduler-tools.
> +
> + The first testing application is called rt-app and can be used to
> + start multiple threads with specific parameters. rt-app supports
> + SCHED_{OTHER,FIFO,RR,DEADLINE} scheduling policies and their related
> + parameters (e.g., niceness, priority, runtime/deadline/period). rt-app
> + is a valuable tool, as it can be used to synthetically recreate certain
> + workloads (maybe mimicking real use-cases) and evaluate how the scheduler
> + behaves under such workloads. In this way, results are easily reproducible.
> + rt-app is available at: https://github.com/scheduler-tools/rt-app.
> +
> + Threads parameters can be specified from command line, with something like

    Thread                              from the

> + this:
> +
> +  # rt-app -t 100000:10000:d -t 150000:20000:f:10 -D5
> +
> + What above creates two threads, first one, scheduled by SCHED_DEADLINE,

    The above creates two threads. The first one,

> + executes for 10ms every 100ms and second one, scheduled at RT priority 10

                                  and the second one,

> + with SCHED_FIFO, executes for 20ms every 150ms. The configuration runs
> + for 5 seconds.
> +
> + More interestingly, configurations can be described with a json file, that

                                                    drop comma here     ^

> + can be passed as input to rt-app with something like this:
> +
> +  # rt-app my_config.json
> +
> + The parameters that can be specified with the second method are a superset
> + of the command line options. Please refer to rt-app documentation for more
> + details.
> +
> + The second testing application is a modification of schedtool, called
> + schedtool-dl, which can be used to setup SCHED_DEADLINE parameters for a
> + certain pid/application. schedtool-dl is available at:
> + https://github.com/scheduler-tools/schedtool-dl.git.
> +
> + The usage is straightforward:
> +
> +  # schedtool -E -t 10000000:100000000 -e ./my_cpuhog_app
> +
> + With this, my_cpuhog_app is put to run inside a SCHED_DEADLINE reservation
> + of 10ms every 100ms (note that parameters are expressed in microseconds).
> + You can also use schedtool to create a reservation for an already running
> + application, given that you know its pid:
> +
> +  # schedtool -E -t 10000000:100000000 my_app_pid
> 


-- 
~Randy
