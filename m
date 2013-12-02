Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3LBH6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:58:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60760 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:58:50 -0500
X-AuditID: 9c930197-b7caaae000001cef-b0-529c3db9b0b9
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] perf sched: Introduce timehist command - v2
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
	<1385943795-11761-2-git-send-email-dsahern@gmail.com>
Date: Mon, 02 Dec 2013 16:58:49 +0900
In-Reply-To: <1385943795-11761-2-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sun, 1 Dec 2013 17:23:14 -0700")
Message-ID: <871u1vptty.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Dec 2013 17:23:14 -0700, David Ahern wrote:
> 'perf sched timehist' provides an analysis of scheduling events.
>
> Example usage:
>     perf sched record -- sleep 1
>     perf sched timehist
>
> By default it shows the individual schedule events, including the time between
> sched-in events for the task, the task scheduling delay (time between wakeup
> and actually running) and run time for the task:
>
>            time cpu  task name[tid/pid]    b/n time sch delay  run time
>   ------------- ---- -------------------- --------- --------- ---------
>    79371.874569 [11] gcc[31949]               0.014     0.000     1.148
>    79371.874591 [10] gcc[31951]               0.000     0.000     0.024
>    79371.874603 [10] migration/10[59]         3.350     0.004     0.011
>    79371.874604 [11] <idle>                   1.148     0.000     0.035
>    79371.874723 [05] <idle>                   0.016     0.000     1.383
>    79371.874746 [05] gcc[31949]               0.153     0.078     0.022
> ...
>
> Times are in msec.usec.

Hmm.. I'm not sure this is right.  It probably confuse users since
timehist_time_str() still uses "sec.usec" format and it looks not
natural for me to use "msec".

Yeah, I see perf stat uses "msec.usec" for result of clock events but
AFAICT it also shows the unit explicitly.  And perf stat -I uses
"sec.nsec" format and perf script also uses "sec.usec" format so there's
a little consistency here.

I think this "msec.usec" format fits well for the scheduling events but
in general "sec.usec" format looks better IMHO.

Thanks,
Namhyung
