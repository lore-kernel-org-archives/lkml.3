Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3I0G3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:29:38 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44985 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3I0G3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:29:36 -0400
Date: Fri, 27 Sep 2013 08:29:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
Message-ID: <20130927062932.GC6726@gmail.com>
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
 <20130926175105.GB9121@krava.brq.redhat.com>
 <5244C09B.7040500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5244C09B.7040500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/26/13 11:51 AM, Jiri Olsa wrote:
> >but it's still faster, since we finally get perf a chance to sleep ;-)
> >
> >new time:
> >	real    0m30.392s
> >	user    0m0.041s
> >	sys     0m0.389s
> >
> >old time:
> >	real    0m32.235s
> >	user    0m3.080s
> >	sys     0m14.444s
> >
> 
> Another data point on the performance improvement of perf itself.
> Using openssl speed as a workload and perf-stat to collect
> information about the perf-record process only:
> 
> perf stat -i -- perf record -g -o /tmp/perf.data openssl speed aes
> 
> With write():
>        158.606380 task-clock
>                 72 context-switches
>                 34 cpu-migrations
>              5,400 page-faults
>        336,054,007 cycles
>        137,804,036 stalled-cycles-frontend
>         74,505,914 stalled-cycles-backend
>        474,401,639 instructions
>         91,246,072 branches
>          1,968,289 branch-misses
> 
> With mmap():
>         50.314270 task-clock
>                 61 context-switches
>                  7 cpu-migrations
>              3,958 page-faults
>         93,585,618 cycles
>         64,878,225 stalled-cycles-frontend
>         41,680,427 stalled-cycles-backend
>         81,552,219 instructions
>         15,301,389 branches
>            387,230 branch-misses
> 
> So time, CPU cycles, instructions all drop by more than a factor of 3.

Impressive!

Btw., a perf stat bugreport: it's not clear at all that 'task-clock' is in 
units of milliseconds. Would be nice to print the unit as '(ms)' or so ...

For the other entries the unit is obvious (a count) - with the exception 
of the task-clock.

Thanks,

	Ingo
