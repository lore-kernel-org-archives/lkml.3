Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3KSAS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:18:26 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44698 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3KSASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:18:23 -0500
X-AuditID: 9c93017e-b7ba2ae00000088c-a8-528aae4d8ca2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/3] perf script: Print comm, fork and exit events also
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
	<1384752894-10974-2-git-send-email-namhyung@kernel.org>
	<20131118135700.GB3669@ghostprotocols.net>
Date: Tue, 19 Nov 2013 09:18:20 +0900
In-Reply-To: <20131118135700.GB3669@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 18 Nov 2013 10:57:00 -0300")
Message-ID: <87bo1hutv7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 18 Nov 2013 10:57:00 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 18, 2013 at 02:34:53PM +0900, Namhyung Kim escreveu:
>> If --show-task option is given, also print internal COMM, FORK and
>> EXIT events.  It would be helpful for debugging.
>
> Humm, --show-task-events is clearer albeit long :-\ With shell
> completion shouldn't be an issue tho.

Okay, will change.

>
> Also, can't we use: perf_event__fprintf_{mmap,comm,task}?

We can do it.  The output will look like below if we use
perf_event__fprintf():

          swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
            sleep  9486 [009] 3350640.335509: PERF_RECORD_COMM: sleep:9486
            sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
          firefox  2635 [003] 3350641.275896: PERF_RECORD_FORK(2635:9487):(2635:2635)
          firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
            sleep  9486 [009] 3350641.336009: PERF_RECORD_EXIT(9486:9486):(9486:9486)


But I'd prefer original version below since it shows the changes more
intuitively, no?

Thanks,
Namhyung

>  
>>   $ perf script --show-task
>>   ...
>>          swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
>>            sleep  9486 [009] 3350640.335509: comm: perf --> sleep (9486)
>>            sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
>>          firefox  2635 [003] 3350641.275896: fork: firefox (2635 --> 9487)
>>          firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
>>            sleep  9486 [009] 3350641.336009: exit: sleep (9486)
