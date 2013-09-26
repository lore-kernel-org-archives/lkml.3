Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab3IZXRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:17:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64594 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:17:51 -0400
Message-ID: <5244C09B.7040500@gmail.com>
Date: Thu, 26 Sep 2013 17:17:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com> <20130926175105.GB9121@krava.brq.redhat.com>
In-Reply-To: <20130926175105.GB9121@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/13 11:51 AM, Jiri Olsa wrote:
> but it's still faster, since we finally get perf a chance to sleep ;-)
>
> new time:
> 	real    0m30.392s
> 	user    0m0.041s
> 	sys     0m0.389s
>
> old time:
> 	real    0m32.235s
> 	user    0m3.080s
> 	sys     0m14.444s
>

Another data point on the performance improvement of perf itself. Using 
openssl speed as a workload and perf-stat to collect information about 
the perf-record process only:

perf stat -i -- perf record -g -o /tmp/perf.data openssl speed aes

With write():
        158.606380 task-clock
                 72 context-switches
                 34 cpu-migrations
              5,400 page-faults
        336,054,007 cycles
        137,804,036 stalled-cycles-frontend
         74,505,914 stalled-cycles-backend
        474,401,639 instructions
         91,246,072 branches
          1,968,289 branch-misses

With mmap():
         50.314270 task-clock
                 61 context-switches
                  7 cpu-migrations
              3,958 page-faults
         93,585,618 cycles
         64,878,225 stalled-cycles-frontend
         41,680,427 stalled-cycles-backend
         81,552,219 instructions
         15,301,389 branches
            387,230 branch-misses

So time, CPU cycles, instructions all drop by more than a factor of 3.

David
