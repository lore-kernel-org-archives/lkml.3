Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaAGO0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:26:11 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:64755 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:26:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140107132034.GA1079@localhost>
References: <20140102061242.GB29352@localhost>
	<20140104190228.GG16438@laptop.programming.kicks-ass.net>
	<20140105011423.GB11203@localhost>
	<CABPqkBRqg4K3US3LLw6g6tspvQ53ZwQgy4y7R83w-L9EyhrvFA@mail.gmail.com>
	<20140107132034.GA1079@localhost>
Date: Tue, 7 Jan 2014 15:26:06 +0100
Message-ID: <CABPqkBQqROexLpx5w8EZyX_Zg796+ixO8jCPq+GEfTLdF3Jqyw@mail.gmail.com>
Subject: Re: perf-stat changes after "Use hrtimers for event multiplexing"
From: Stephane Eranian <eranian@google.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp <lkp@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 2:20 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Stephane,
>
> On Tue, Jan 07, 2014 at 10:52:50AM +0100, Stephane Eranian wrote:
>> Hi,
>>
>> With the hrtitmer patch, you will get more regular multiplexing when
>> you have idle cores during your benchmark.
>> Without the patch, multiplexing was piggybacked on timer tick. The
>> timer tick does not occur when a core is idle
>> when using a tickless kernel. Thus, the quality of the results with
>> hrtimers should be improved.
>
In other words, if your measurement was not multiplexing events OR
your benchmark did not incur idle time, you should not see any difference
with previous kernel with no hrtimer mux.

> OK, got it. Thanks for the explanations!
>
> Thanks,
> Fengguang
>
>>
>> On Sun, Jan 5, 2014 at 2:14 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > On Sat, Jan 04, 2014 at 08:02:28PM +0100, Peter Zijlstra wrote:
>> >> On Thu, Jan 02, 2014 at 02:12:42PM +0800, fengguang.wu@intel.com wrote:
>> >> > Greetings,
>> >> >
>> >> > We noticed many perf-stat changes between commit 9e6302056f ("perf: Use
>> >> > hrtimers for event multiplexing") and its parent commit ab573844e.
>> >> > Are these expected changes?
>> >> >
>> >> > ab573844e3058ee  9e6302056f8029f438e853432
>> >> > ---------------  -------------------------
>> >> >     152917         +842.9%    1441897       TOTAL interrupts.0:IO-APIC-edge.timer
>> >> >     545996         +478.0%    3155637       TOTAL interrupts.LOC
>> >> >     182281          +12.3%     204718       TOTAL softirqs.SCHED
>> >> >  1.986e+08          -96.4%    7105919       TOTAL perf-stat.node-store-misses
>> >> >  107241719          -99.7%     317525       TOTAL perf-stat.node-prefetch-misses
>> >> >  1.938e+08          -90.7%   17930426       TOTAL perf-stat.node-load-misses
>> >> >       2590         +247.8%       9009       TOTAL vmstat.system.in
>> >> >  4.549e+12         +158.3%  1.175e+13       TOTAL perf-stat.stalled-cycles-backend
>> >> >  6.807e+12         +149.1%  1.696e+13       TOTAL perf-stat.stalled-cycles-frontend
>> >> >  1.753e+08          -50.8%   86339289       TOTAL perf-stat.node-prefetches
>> >> >  8.326e+11          +45.0%  1.207e+12       TOTAL perf-stat.cpu-cycles
>> >> >   37932143          +32.2%   50146025       TOTAL perf-stat.iTLB-load-misses
>> >> >  4.738e+11          +30.1%  6.165e+11       TOTAL perf-stat.iTLB-loads
>> >> >   2.56e+11          +30.1%   3.33e+11       TOTAL perf-stat.L1-icache-loads
>> >> >  4.951e+11          +24.6%  6.169e+11       TOTAL perf-stat.instructions
>> >> >   7.85e+08           +7.5%  8.439e+08       TOTAL perf-stat.LLC-prefetch-misses
>> >> >  1.891e+12          +22.8%  2.322e+12       TOTAL perf-stat.ref-cycles
>> >> >  4.344e+08          -20.3%  3.462e+08       TOTAL perf-stat.node-loads
>> >> >  2.836e+11          +17.4%  3.328e+11       TOTAL perf-stat.branch-loads
>> >> >  9.506e+10          +24.5%  1.183e+11       TOTAL perf-stat.branch-load-misses
>> >> >  2.803e+11          +18.4%  3.319e+11       TOTAL perf-stat.branch-instructions
>> >> >  7.988e+10          +20.9%  9.658e+10       TOTAL perf-stat.bus-cycles
>> >> >  2.041e+09          +22.2%  2.495e+09       TOTAL perf-stat.branch-misses
>> >> >     229145          -17.3%     189601       TOTAL perf-stat.cpu-migrations
>> >> >  1.782e+11          +17.9%    2.1e+11       TOTAL perf-stat.dTLB-loads
>> >> >  4.702e+08          -14.8%  4.006e+08       TOTAL perf-stat.LLC-load-misses
>> >> >  1.418e+11          +17.4%  1.666e+11       TOTAL perf-stat.L1-dcache-loads
>> >> >  1.838e+09          +16.1%  2.133e+09       TOTAL perf-stat.LLC-stores
>> >> >  2.428e+09          +11.3%  2.702e+09       TOTAL perf-stat.LLC-loads
>> >> >  2.788e+11           +8.6%  3.029e+11       TOTAL perf-stat.dTLB-stores
>> >> >   8.66e+08          +10.8%  9.594e+08       TOTAL perf-stat.LLC-prefetches
>> >> >  1.117e+09          +10.5%  1.234e+09       TOTAL perf-stat.dTLB-store-misses
>> >> >  1.705e+09           +5.3%  1.796e+09       TOTAL perf-stat.L1-dcache-store-misses
>> >> >  5.671e+09           +6.1%  6.015e+09       TOTAL perf-stat.L1-dcache-load-misses
>> >> >  8.794e+10           +3.6%  9.109e+10       TOTAL perf-stat.L1-dcache-stores
>> >> >   3.46e+09           +4.6%  3.618e+09       TOTAL perf-stat.cache-references
>> >> >  8.696e+08           +1.8%  8.849e+08       TOTAL perf-stat.cache-misses
>> >> >    1613129           +2.6%    1655724       TOTAL perf-stat.context-switches
>> >> >
>> >> > All of the changes happen in one of our test box, which has a DX58SO
>> >> > baseboard and 4-core CPU. The boot dmesg and kconfig are attached.
>> >> > We can test more boxes if necessary.
>> >>
>> >> How do you run perf stat?
>> >
>> > perf stat -a $(-e hardware, cache, software events)
>> >
>> >> Curious that you notice this now, its a fairly old commit.
>> >
>> > Yeah, we are feeding old kernels to the 0day performance test system, too. :)
>> >
>> >> IIRC we did have a few wobbles with that, but I cannot remember much
>> >> detail.
>> >>
>> >> The biggest difference between before and after that patch is that we'd
>> >> rotate while the core is 'idle'. So if you do something like 'perf stat
>> >> -a' and have significant idle time it does indeed make a difference.
>> >
>> > It is 'perf stat -a'; the CPU is mostly idle because it's an IO workload.
>> >
>> > btw, we find another commit that changed some perf-stat output:
>> >
>> > 2f7f73a520 ("perf/x86: Fix shared register mutual exclusion enforcement")
>> >
>> > Comparing to its parent commit:
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  1.308e+08 ~26%     -77.8%   29029594 ~12%  fat/micro/dd-write/1HDD-deadline-xfs-10dd
>> >  1.308e+08          -77.8%   29029594       TOTAL perf-stat.LLC-prefetch-misses
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >   97086131 ~ 7%     -71.0%   28127157 ~11%  fat/micro/dd-write/1HDD-deadline-xfs-10dd
>> >   97086131          -71.0%   28127157       TOTAL perf-stat.node-prefetches
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >    1.4e+08 ~ 3%     -56.6%   60744486 ~ 9%  fat/micro/dd-write/1HDD-deadline-xfs-10dd
>> >    1.4e+08          -56.6%   60744486       TOTAL perf-stat.LLC-load-misses
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  6.967e+08 ~ 0%     -49.6%  3.513e+08 ~ 6%  fat/micro/dd-write/1HDD-deadline-xfs-10dd
>> >  6.967e+08          -49.6%  3.513e+08       TOTAL perf-stat.node-stores
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  1.933e+09 ~ 1%     -43.0%  1.103e+09 ~ 2%  fat/micro/dd-write/1HDD-deadline-xfs-10dd
>> >  1.933e+09          -43.0%  1.103e+09       TOTAL perf-stat.LLC-stores
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  7.013e+08 ~ 5%     -55.5%  3.118e+08 ~ 4%  fat/micro/dd-write/1HDD-deadline-btrfs-100dd
>> >  6.775e+09 ~ 1%     -20.4%  5.391e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
>> >  7.477e+09          -23.7%  5.703e+09       TOTAL perf-stat.LLC-store-misses
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  2.294e+09 ~ 1%     -10.0%  2.065e+09 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
>> >  2.294e+09          -10.0%  2.065e+09       TOTAL perf-stat.LLC-prefetches
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  8.685e+09 ~ 0%     -10.0%  7.814e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
>> >  8.685e+09          -10.0%  7.814e+09       TOTAL perf-stat.cache-misses
>> >
>> > 069e0c3c4058147  2f7f73a52078b667d64df16ea
>> > ---------------  -------------------------
>> >  1.591e+12 ~ 0%      -8.7%  1.453e+12 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
>> >  1.591e+12           -8.7%  1.453e+12       TOTAL perf-stat.dTLB-loads
>> >
>> >
>> > Thanks,
>> > Fengguang
