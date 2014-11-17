Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaKQOys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:54:48 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62406 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaKQOyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:54:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141117034428.GK24745@yliu-dev.sh.intel.com>
References: <20141110055453.GE1705@yliu-dev.sh.intel.com> <CAKfTPtArGfgkDERN7fg+Kr_eqm_CAOrFdf3fnwym_OC6wFzNqA@mail.gmail.com>
 <20141114033547.GJ24745@yliu-dev.sh.intel.com> <CAKfTPtAKADYCPL0sqaPJwOqU6SCrW5=tmK-QaqnxuOxWQ-Gtug@mail.gmail.com>
 <20141117034428.GK24745@yliu-dev.sh.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 17 Nov 2014 15:54:19 +0100
Message-ID: <CAKfTPtDp-8_bn=tswypKKopiGEkb4GeO=UqE2SjhwnFTCoTJRQ@mail.gmail.com>
Subject: Re: [LKP] [sched] 9597d64116d: -16.1% hackbench.throughput
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: lkp@01.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 November 2014 04:44, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> On Fri, Nov 14, 2014 at 01:59:51PM +0100, Vincent Guittot wrote:
>> On 14 November 2014 04:35, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> > On Wed, Nov 12, 2014 at 03:44:34PM +0100, Vincent Guittot wrote:
>> >> On 10 November 2014 06:54,  <lkp@01.org> wrote:
>> >> > FYI, we noticed the below changes on
>> >> >
>> >> > https://git.linaro.org/people/mturquette/linux.git eas-next
>> >> > commit 9597d64116d0d441dea32e7f5f05fa135d16f44b ("sched: replace capacity_factor by usage")
>> >> >
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  testbox/testcase/testparams
>> >> > ----------------  --------------------------  ---------------------------
>> >> >          %stddev     %change         %stddev
>> >> >              \          |                \
>> >> >     104249 ą  0%     -16.1%      87436 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     104249           -16.1%      87436        GEO-MEAN hackbench.throughput
>> >>
>> >> Hi yuanhan,
>> >>
>> >> i understand this email as a 16% drop in hackbench performance when
>> >> the number of group is half the number of CPUs. Is it the only test
>> >> for which you  have seen some decreases ? where can i find the list of
>> >> tests that you have passed ?
>> >
>> > Sorry, the list is not accessed outside, plus, you have to run some
>> > commands to generate the list on fly. Anyway, I checked it for you,
>>
>> thanks,
>>
>> > and we have run hackbench/performance-50%-threads-socket only on that
>> > commit, which is reasonable in our system as we bisected once on this
>> > issue.
>> >
>> > But I can run more tests(say, with 100% and 1600% cpu) on that commit if
>>
>> yes, that would be interesting
>>
>> > you like, and it also would be good if you can name some of benchmarks
>> > you care most so that we can run it for you.
>>
>> ebizzy with a number of thread that is half the number of CPU is a
>> good candidate as well
>
> I tried ebizzy with 50% of CPU, and here is the script we used:
>
>     duration=10s
>     iterations=100
>
>     for i in $(seq 1 $iterations)
>     do
>             echo Iteration: $i
>             cmd ./ebizzy -t $nr_threads \
>                          -S $duration
>     done
>
> But we observed no performance change.

ok. thanks for the results

>
> BTW, here is the result from the test 50/100/1600%-threads-socket
> and 50%-ebizzy(note: only changes are listed here):
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  testbox/testcase/testparams
> ----------------  --------------------------  ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>     186758 ±  8%     -19.1%     151079 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>     104249 ±  0%     -16.1%      87436 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     139533           -17.6%     114934        GEO-MEAN hackbench.throughput

based on the note above : only changes are listed here, can i assume
that there is no change for 1600% ?

Thanks for the results, i'm going to look more deeply the details value below

Vincent

>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     340536 ± 25%     -77.7%      75915 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>     340536           -77.7%      75915        GEO-MEAN sched_debug.cpu#32.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1420 ± 12%    +370.7%       6686 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1420          +370.7%       6686        GEO-MEAN sched_debug.cpu#97.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.00 ±  0%  +7.4e+13%  738901.37 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>       0.00        +7.4e+13%  738901.37        GEO-MEAN sched_debug.cfs_rq[23]:/.max_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.00 ±  0%  +7.4e+13%  738901.37 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>       0.00        +7.4e+13%  738901.37        GEO-MEAN sched_debug.cfs_rq[23]:/.MIN_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>  808074.08 ± 24%    -100.0%       0.00 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>  808074.08          -100.0%       0.00        GEO-MEAN sched_debug.cfs_rq[10]:/.max_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>  808074.08 ± 24%    -100.0%       0.00 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>  808074.08          -100.0%       0.00        GEO-MEAN sched_debug.cfs_rq[10]:/.MIN_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     360093 ± 31%     -78.1%      78716 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>     360093           -78.1%      78716        GEO-MEAN sched_debug.cpu#7.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.00 ±  0%  +7.7e+13%  770048.71 ± 43%  ivb42/hackbench/performance-100%-threads-socket
>       0.00        +7.7e+13%  770048.71        GEO-MEAN sched_debug.cfs_rq[6]:/.max_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.00 ±  0%  +7.7e+13%  770048.71 ± 43%  ivb42/hackbench/performance-100%-threads-socket
>       0.00        +7.7e+13%  770048.71        GEO-MEAN sched_debug.cfs_rq[6]:/.MIN_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     358961 ± 38%     -73.5%      95026 ± 17%  ivb42/hackbench/performance-100%-threads-socket
>     358961           -73.5%      95026        GEO-MEAN sched_debug.cpu#24.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.88 ± 25%    +209.7%       2.74 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>       0.88          +209.7%       2.74        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt.reschedule_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3276492 ±  5%     +15.5%    3784016 ±  8%  ivb42/hackbench/performance-50%-threads-socket
>    3276492           +15.5%    3784016        GEO-MEAN sched_debug.cfs_rq[35]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         57 ± 29%     -50.6%         28 ± 29%  ivb42/hackbench/performance-1600%-threads-socket
>         57           -50.6%         28        GEO-MEAN sched_debug.cpu#22.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3387494 ±  6%     +16.9%    3960647 ±  7%  ivb42/hackbench/performance-50%-threads-socket
>    3387494           +16.9%    3960647        GEO-MEAN sched_debug.cfs_rq[33]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3335586 ±  3%     +22.0%    4070327 ±  8%  ivb42/hackbench/performance-50%-threads-socket
>    3335586           +22.0%    4070327        GEO-MEAN sched_debug.cfs_rq[34]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3230592 ±  8%     +14.9%    3712705 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>    3230592           +14.9%    3712705        GEO-MEAN sched_debug.cfs_rq[30]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     323284 ± 30%     -74.7%      81724 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>     323284           -74.7%      81723        GEO-MEAN sched_debug.cpu#31.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3155171 ±  2%     +19.0%    3753143 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>    3155171           +19.0%    3753143        GEO-MEAN sched_debug.cfs_rq[31]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1524 ± 16%    +253.1%       5383 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1524          +253.1%       5383        GEO-MEAN sched_debug.cpu#94.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1304331 ± 11%     +49.2%    1946271 ± 13%  ivb42/hackbench/performance-50%-threads-socket
>    1304331           +49.2%    1946271        GEO-MEAN sched_debug.cfs_rq[11]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2877453 ±  6%     +25.4%    3608032 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>    2877453           +25.4%    3608032        GEO-MEAN sched_debug.cfs_rq[26]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3170186 ± 12%     +20.8%    3830642 ±  8%  ivb42/hackbench/performance-50%-threads-socket
>    3170186           +20.8%    3830642        GEO-MEAN sched_debug.cfs_rq[41]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3100432 ± 12%     +22.4%    3793805 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>    3100432           +22.4%    3793805        GEO-MEAN sched_debug.cfs_rq[37]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3116277 ±  7%     +13.2%    3527174 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>    3116277           +13.2%    3527174        GEO-MEAN sched_debug.cfs_rq[29]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         71 ± 35%     -69.0%         22 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>         71           -69.0%         22        GEO-MEAN sched_debug.cfs_rq[24]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2069 ±  8%    +257.0%       7388 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2069          +257.0%       7388        GEO-MEAN sched_debug.cpu#71.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2820456 ±  4%     +23.4%    3479484 ±  7%  ivb42/hackbench/performance-50%-threads-socket
>    2820456           +23.4%    3479484        GEO-MEAN sched_debug.cfs_rq[27]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.76 ± 26%    +209.2%       2.36 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>       0.76          +209.2%       2.36        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.76 ± 26%    +210.6%       2.35 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>       0.76          +210.6%       2.35        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2095 ± 47%    +153.6%       5314 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2095          +153.6%       5314        GEO-MEAN sched_debug.cpu#93.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2329483 ± 18%     -66.1%     788636 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>    3321870 ±  7%     +14.8%    3811901 ±  7%  ivb42/hackbench/performance-50%-threads-socket
>    2781769           -37.7%    1733841        GEO-MEAN sched_debug.cfs_rq[47]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1008818 ± 20%     +70.9%    1724167 ± 14%  ivb42/hackbench/performance-50%-threads-socket
>    1008818           +70.9%    1724167        GEO-MEAN sched_debug.cfs_rq[6]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.70 ± 25%    +203.1%       2.13 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>       0.70          +203.1%       2.13        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     243252 ± 46%    +242.5%     833240 ± 42%  ivb42/hackbench/performance-50%-threads-socket
>     243252          +242.5%     833240        GEO-MEAN sched_debug.cfs_rq[2]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         78 ± 27%    +171.4%        211 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         78          +171.4%        211        GEO-MEAN sched_debug.cfs_rq[17]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6805 ±  7%    +211.4%      21195 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6805          +211.4%      21195        GEO-MEAN sched_debug.cpu#97.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     915637 ± 16%     +93.4%    1771080 ± 18%  ivb42/hackbench/performance-50%-threads-socket
>     915637           +93.4%    1771080        GEO-MEAN sched_debug.cfs_rq[7]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2231 ± 11%    +227.0%       7298 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2231          +227.0%       7298        GEO-MEAN sched_debug.cpu#68.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1374284 ± 42%     +63.3%    2243578 ± 23%  ivb42/hackbench/performance-100%-threads-socket
>    1374284           +63.3%    2243578        GEO-MEAN sched_debug.cfs_rq[42]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2958 ±  9%    +196.1%       8759 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2958          +196.1%       8759        GEO-MEAN sched_debug.cpu#97.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 36%     -64.7%          4 ± 20%  ivb42/hackbench/performance-100%-threads-socket
>         11           -64.7%          4        GEO-MEAN sched_debug.cpu#16.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1128380 ± 24%     +67.1%    1886076 ± 15%  ivb42/hackbench/performance-50%-threads-socket
>    1128380           +67.1%    1886076        GEO-MEAN sched_debug.cfs_rq[8]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     311556 ± 28%     -82.5%      54597 ± 41%  ivb42/hackbench/performance-100%-threads-socket
>      35577 ± 20%     +42.9%      50840 ± 15%  ivb42/hackbench/performance-50%-threads-socket
>     105282           -50.0%      52685        GEO-MEAN sched_debug.cpu#11.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2115 ± 40%    +228.2%       6943 ± 39%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2115          +228.2%       6943        GEO-MEAN sched_debug.cpu#100.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1663 ± 14%    +193.5%       4882 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1663          +193.5%       4882        GEO-MEAN sched_debug.cpu#117.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1605 ± 18%    +248.8%       5598 ± 35%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1605          +248.8%       5598        GEO-MEAN sched_debug.cpu#105.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1357971 ± 14%     +41.3%    1918898 ±  9%  ivb42/hackbench/performance-50%-threads-socket
>    1357971           +41.3%    1918898        GEO-MEAN sched_debug.cfs_rq[9]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9696 ± 26%    +159.1%      25126 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9696          +159.1%      25126        GEO-MEAN sched_debug.cpu#94.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3341263 ± 11%     +20.3%    4019480 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>    3341263           +20.3%    4019480        GEO-MEAN sched_debug.cfs_rq[45]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1590814 ± 37%     -47.3%     837986 ± 20%  ivb42/hackbench/performance-1600%-threads-socket
>    2845181 ± 10%     +25.9%    3581780 ±  9%  ivb42/hackbench/performance-50%-threads-socket
>    2127476           -18.6%    1732478        GEO-MEAN sched_debug.cfs_rq[40]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     683813 ±  7%     -21.3%     538426 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>     683813           -21.3%     538426        GEO-MEAN sched_debug.cpu#46.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11733 ± 31%    +150.3%      29364 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11733          +150.3%      29364        GEO-MEAN sched_debug.cpu#100.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7947 ± 11%    +220.2%      25445 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7947          +220.2%      25445        GEO-MEAN sched_debug.cpu#102.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     324927 ± 17%     -80.7%      62808 ± 12%  ivb42/hackbench/performance-100%-threads-socket
>    1019932 ± 15%     -19.9%     817432 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>     575677           -60.6%     226586        GEO-MEAN sched_debug.cpu#9.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     335420 ± 27%     -75.9%      80856 ± 35%  ivb42/hackbench/performance-100%-threads-socket
>    2006305 ± 16%     +21.8%    2443697 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>     820339           -45.8%     444510        GEO-MEAN sched_debug.cpu#34.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.05 ± 42%     -75.5%       0.50 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       3.76 ± 15%     -48.7%       1.93 ± 42%  ivb42/hackbench/performance-1600%-threads-socket
>       2.78           -64.5%       0.99        GEO-MEAN perf-profile.cpu-cycles.unix_destruct_scm.skb_release_all.consume_skb.unix_stream_recvmsg.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3311434 ±  8%     +19.3%    3950522 ± 12%  ivb42/hackbench/performance-50%-threads-socket
>    3311434           +19.3%    3950522        GEO-MEAN sched_debug.cfs_rq[46]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     699300 ±  3%     -19.5%     562724 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>     328558 ± 33%     -78.1%      71849 ± 27%  ivb42/hackbench/performance-100%-threads-socket
>     479333           -58.1%     201075        GEO-MEAN sched_debug.cpu#26.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     824608 ±  2%     -19.2%     666616 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     824608           -19.2%     666616        GEO-MEAN sched_debug.cpu#23.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         15 ± 25%    +260.0%         54 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         15          +260.0%         54        GEO-MEAN sched_debug.cfs_rq[90]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2085 ±  8%    +248.2%       7260 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2085          +248.2%       7260        GEO-MEAN sched_debug.cpu#72.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3043317 ±  9%     +25.3%    3814417 ± 13%  ivb42/hackbench/performance-50%-threads-socket
>    3043317           +25.3%    3814417        GEO-MEAN sched_debug.cfs_rq[38]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     762721 ±  1%     -14.5%     652458 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     318111 ± 31%     -80.9%      60809 ± 32%  ivb42/hackbench/performance-100%-threads-socket
>     492575           -59.6%     199187        GEO-MEAN sched_debug.cpu#2.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     763331 ±  2%     -10.9%     679883 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     311279 ± 32%     -80.1%      62076 ± 37%  ivb42/hackbench/performance-100%-threads-socket
>     487451           -57.9%     205437        GEO-MEAN sched_debug.cpu#4.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     647286 ±  7%     -12.3%     567405 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     347686 ± 30%     -78.8%      73643 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>     474396           -56.9%     204415        GEO-MEAN sched_debug.cpu#35.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     637961 ±  7%     -13.2%     553592 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     359647 ± 29%     -79.8%      72691 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>     479000           -58.1%     200602        GEO-MEAN sched_debug.cpu#33.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     755170 ±  2%     -10.6%     674786 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     348991 ± 32%     -77.3%      79313 ± 38%  ivb42/hackbench/performance-100%-threads-socket
>     513369           -54.9%     231342        GEO-MEAN sched_debug.cpu#10.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     289530 ± 21%     -76.4%      68398 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>     868862 ± 13%     +24.0%    1077186 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>     501559           -45.9%     271435        GEO-MEAN sched_debug.cpu#1.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10651 ± 37%    +132.5%      24769 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10651          +132.5%      24769        GEO-MEAN sched_debug.cpu#103.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3234028 ±  9%     +15.2%    3724307 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>    3234028           +15.2%    3724307        GEO-MEAN sched_debug.cfs_rq[39]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         92 ± 23%    +152.9%        232 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>         92          +152.9%        232        GEO-MEAN sched_debug.cfs_rq[17]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     801963 ±  4%     -24.0%     609711 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     801963           -24.0%     609711        GEO-MEAN sched_debug.cpu#19.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2896486 ±  7%     +19.6%    3463508 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>    2896486           +19.6%    3463508        GEO-MEAN sched_debug.cfs_rq[25]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2372 ± 27%    +213.7%       7442 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2372          +213.7%       7442        GEO-MEAN sched_debug.cpu#118.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     718225 ±  3%      -8.6%     656214 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     329552 ± 25%     -75.6%      80488 ± 26%  ivb42/hackbench/performance-100%-threads-socket
>     486510           -52.8%     229820        GEO-MEAN sched_debug.cpu#3.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     641106 ±  3%     -21.5%     503105 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     641106           -21.5%     503105        GEO-MEAN sched_debug.cpu#45.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1629 ±  8%    +218.9%       5194 ± 40%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1629          +218.9%       5194        GEO-MEAN sched_debug.cpu#112.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4992 ± 11%    +217.0%      15828 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4992          +217.0%      15828        GEO-MEAN sched_debug.cpu#89.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1560 ± 15%    +225.9%       5085 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1560          +225.9%       5085        GEO-MEAN sched_debug.cpu#102.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10025 ± 31%    +187.4%      28813 ± 33%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10025          +187.4%      28812        GEO-MEAN sched_debug.cpu#95.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11381 ± 11%    +203.5%      34548 ±  2%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11381          +203.5%      34548        GEO-MEAN sched_debug.cpu#89.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     658371 ±  2%     -22.4%     510864 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>     349779 ± 26%     -74.9%      87948 ± 22%  ivb42/hackbench/performance-100%-threads-socket
>     479879           -55.8%     211966        GEO-MEAN sched_debug.cpu#30.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     715056 ±  2%      -9.2%     649573 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     304375 ± 24%     -78.2%      66392 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>     466524           -55.5%     207669        GEO-MEAN sched_debug.cpu#8.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     645934 ±  3%     -10.7%     576615 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     358510 ± 34%     -74.3%      92018 ± 15%  ivb42/hackbench/performance-100%-threads-socket
>     481221           -52.1%     230346        GEO-MEAN sched_debug.cpu#29.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         59 ± 41%     +71.8%        101 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>         59           +71.8%        101        GEO-MEAN sched_debug.cfs_rq[32]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2523 ± 27%    +177.2%       6996 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2523          +177.2%       6996        GEO-MEAN sched_debug.cpu#63.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2236 ±  9%    +171.5%       6070 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2236          +171.5%       6070        GEO-MEAN sched_debug.cpu#73.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7994 ± 13%    +160.1%      20794 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7994          +160.1%      20794        GEO-MEAN sched_debug.cpu#71.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 10%    +133.3%         30 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         13          +133.3%         30        GEO-MEAN sched_debug.cfs_rq[17]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10252 ± 42%    +102.7%      20784 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10252          +102.7%      20783        GEO-MEAN sched_debug.cpu#65.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8236 ± 23%    +121.3%      18224 ± 15%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8236          +121.3%      18224        GEO-MEAN sched_debug.cpu#93.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1783 ± 14%    +204.8%       5435 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1783          +204.8%       5435        GEO-MEAN sched_debug.cpu#103.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7354 ±  9%    +149.2%      18329 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7354          +149.2%      18329        GEO-MEAN sched_debug.cpu#94.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3993 ± 19%    +162.6%      10485 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3993          +162.6%      10485        GEO-MEAN sched_debug.cpu#72.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12300 ± 21%    +146.6%      30332 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12300          +146.6%      30332        GEO-MEAN sched_debug.cpu#118.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7527 ± 10%    +152.1%      18978 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7527          +152.1%      18978        GEO-MEAN sched_debug.cpu#117.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     687894 ±  3%     -13.8%     592946 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     382098 ± 33%     -80.0%      76426 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>    1658515 ± 17%     +42.3%    2360101 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>     758237           -37.4%     474675        GEO-MEAN sched_debug.cpu#27.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11102 ± 42%     +98.6%      22048 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11102           +98.6%      22048        GEO-MEAN sched_debug.cpu#73.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4059 ± 15%    +165.4%      10773 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4059          +165.4%      10773        GEO-MEAN sched_debug.cpu#71.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3328 ± 28%     -42.3%       1920 ± 39%  ivb42/hackbench/performance-1600%-threads-socket
>       3328           -42.3%       1920        GEO-MEAN sched_debug.cfs_rq[14]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1671 ± 15%    +286.3%       6455 ± 48%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1671          +286.3%       6455        GEO-MEAN sched_debug.cpu#95.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3956 ± 10%     -26.7%       2898 ±  3%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      77244 ± 16%     -69.0%      23916 ± 38%  ivb42/hackbench/performance-1600%-threads-socket
>      17481           -52.4%       8325        GEO-MEAN sched_debug.cpu#37.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2559 ± 46%    +139.7%       6134 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2559          +139.7%       6134        GEO-MEAN sched_debug.cpu#60.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     741796 ±  2%     -16.7%     618285 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     309425 ± 23%     -79.2%      64385 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>     738410 ± 14%     +46.7%    1082966 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>     553409           -36.6%     350641        GEO-MEAN sched_debug.cpu#6.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10088 ± 27%    +143.3%      24541 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10088          +143.3%      24541        GEO-MEAN sched_debug.cpu#117.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8180 ± 20%    +169.7%      22064 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8180          +169.7%      22063        GEO-MEAN sched_debug.cpu#100.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2061 ± 15%    +122.1%       4577 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2061          +122.1%       4577        GEO-MEAN sched_debug.cpu#113.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3854 ±  6%     -27.4%       2796 ±  3%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      83004 ± 23%     -60.4%      32834 ± 42%  ivb42/hackbench/performance-1600%-threads-socket
>      17887           -46.4%       9582        GEO-MEAN sched_debug.cpu#39.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9201 ± 12%    +164.6%      24347 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9201          +164.6%      24347        GEO-MEAN sched_debug.cpu#118.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        131 ± 27%     -63.5%         48 ± 36%  ivb42/hackbench/performance-1600%-threads-socket
>        131           -63.5%         48        GEO-MEAN sched_debug.cpu#26.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     321515 ± 38%     -75.1%      79944 ± 23%  ivb42/hackbench/performance-100%-threads-socket
>     969764 ± 14%     +27.3%    1234187 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>     558385           -43.7%     314112        GEO-MEAN sched_debug.cpu#0.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13938 ± 39%     +73.4%      24172 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13938           +73.4%      24172        GEO-MEAN sched_debug.cpu#64.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     674402 ±  4%     -20.0%     539774 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     674402           -20.0%     539773        GEO-MEAN sched_debug.cpu#41.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     838140 ±  2%     -22.0%     653719 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>     991119 ± 21%     +29.7%    1285398 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>     911425            +0.6%     916673        GEO-MEAN sched_debug.cpu#17.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7748 ± 15%    +158.6%      20041 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7748          +158.6%      20041        GEO-MEAN sched_debug.cpu#105.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7467 ± 10%    +174.0%      20458 ± 29%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7467          +174.0%      20458        GEO-MEAN sched_debug.cpu#95.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3916 ±  9%     -28.1%       2817 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      91776 ± 12%     -64.9%      32254 ± 28%  ivb42/hackbench/performance-1600%-threads-socket
>      18959           -49.7%       9532        GEO-MEAN sched_debug.cpu#38.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3729 ± 26%     +95.4%       7286 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3729           +95.4%       7286        GEO-MEAN sched_debug.cpu#93.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3804 ±  8%    +145.2%       9326 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3804          +145.2%       9326        GEO-MEAN sched_debug.cpu#73.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1737 ± 29%    +150.0%       4344 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1737          +150.0%       4344        GEO-MEAN sched_debug.cpu#90.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12302 ± 25%     +97.6%      24308 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12302           +97.6%      24307        GEO-MEAN sched_debug.cpu#96.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10067 ± 40%     +92.4%      19368 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10067           +92.4%      19368        GEO-MEAN sched_debug.cpu#91.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8462 ± 17%    +141.0%      20398 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8462          +141.0%      20398        GEO-MEAN sched_debug.cpu#68.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10319 ± 13%    +116.7%      22363 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10319          +116.7%      22363        GEO-MEAN sched_debug.cpu#113.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9187 ± 21%    +154.7%      23398 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9187          +154.7%      23398        GEO-MEAN sched_debug.cpu#71.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7161 ±  9%    +154.0%      18188 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7161          +154.0%      18188        GEO-MEAN sched_debug.cpu#102.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 14%    +122.7%         32 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>         14          +122.7%         32        GEO-MEAN sched_debug.cpu#17.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9525 ± 29%    +122.7%      21212 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9525          +122.7%      21212        GEO-MEAN sched_debug.cpu#60.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3352 ±  7%    +118.5%       7324 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3352          +118.5%       7324        GEO-MEAN sched_debug.cpu#94.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8128 ±  7%    +148.8%      20226 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8128          +148.8%      20226        GEO-MEAN sched_debug.cpu#72.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2219 ± 13%    +172.1%       6040 ± 32%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2219          +172.1%       6040        GEO-MEAN sched_debug.cpu#61.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8669 ±  6%    +111.2%      18311 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8669          +111.2%      18311        GEO-MEAN sched_debug.cpu#113.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.94 ± 32%     -54.5%       0.88 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       1.94           -54.5%       0.88        GEO-MEAN perf-profile.cpu-cycles.finish_wait.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14243 ± 39%     +68.8%      24044 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14243           +68.8%      24044        GEO-MEAN sched_debug.cpu#106.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9743 ± 26%    +152.1%      24562 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9743          +152.1%      24562        GEO-MEAN sched_debug.cpu#105.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3127 ± 42%    +142.2%       7574 ± 33%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3127          +142.2%       7574        GEO-MEAN sched_debug.cpu#64.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2687 ± 20%     -51.4%       1304 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     652448 ± 29%     +97.5%    1288375 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      41871            -2.1%      41000        GEO-MEAN sched_debug.cpu#26.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12052 ± 43%    +128.7%      27562 ± 43%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12052          +128.7%      27562        GEO-MEAN sched_debug.cpu#111.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1725 ± 17%    +170.8%       4672 ± 30%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1725          +170.8%       4672        GEO-MEAN sched_debug.cpu#109.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4343 ± 21%    +142.1%      10513 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4343          +142.1%      10512        GEO-MEAN sched_debug.cpu#68.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     104282 ± 12%     -66.4%      35064 ± 39%  ivb42/ebizzy/performance-50%-100x-10s
>   17116572 ± 11%     +59.5%   27297076 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>   30485250 ±  0%     -16.9%   25323543 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    3789417           -23.6%    2894014        GEO-MEAN sched_debug.cpu#30.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7944 ±  5%    +146.0%      19544 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7944          +146.0%      19544        GEO-MEAN sched_debug.cpu#112.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7955 ±  7%    +138.7%      18986 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7955          +138.7%      18986        GEO-MEAN sched_debug.cpu#103.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     666391 ±  1%     -10.6%     595956 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     318210 ± 25%     -71.4%      91037 ± 21%  ivb42/hackbench/performance-100%-threads-socket
>    2209362 ± 26%     -32.0%    1502193 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>     776670           -44.2%     433564        GEO-MEAN sched_debug.cpu#28.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2893 ± 37%    +118.0%       6307 ± 29%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2893          +118.0%       6307        GEO-MEAN sched_debug.cpu#96.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14287 ± 35%    +100.8%      28694 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14287          +100.8%      28694        GEO-MEAN sched_debug.cpu#99.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     675773 ± 26%     +90.6%    1287832 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>     675773           +90.6%    1287832        GEO-MEAN sched_debug.cpu#30.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4137 ± 32%    +127.3%       9402 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4137          +127.3%       9402        GEO-MEAN sched_debug.cpu#60.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        337 ± 24%     +37.2%        463 ± 12%  ivb42/hackbench/performance-100%-threads-socket
>        337           +37.2%        463        GEO-MEAN numa-vmstat.node0.nr_inactive_anon
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      51208 ±  3%    +124.9%     115155 ±  2%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      51208          +124.9%     115155        GEO-MEAN sched_debug.cpu#89.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11401 ± 34%    +130.6%      26290 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11401          +130.6%      26289        GEO-MEAN sched_debug.cpu#90.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2028 ± 31%    +164.0%       5355 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2028          +164.0%       5354        GEO-MEAN sched_debug.cpu#65.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         94 ± 12%     -50.4%         47 ± 32%  ivb42/hackbench/performance-1600%-threads-socket
>         94           -50.4%         46        GEO-MEAN sched_debug.cpu#3.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     742428 ±  1%      -9.6%     671471 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     333691 ± 28%     -76.4%      78910 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>    1024709 ± 18%     -25.3%     765836 ± 18%  ivb42/hackbench/performance-1600%-threads-socket
>     633189           -45.7%     343635        GEO-MEAN sched_debug.cpu#5.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      52076 ±  3%    +121.7%     115435 ±  2%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      52076          +121.7%     115435        GEO-MEAN sched_debug.cpu#89.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3972 ±  5%     -30.6%       2755 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2831 ± 27%     +74.9%       4954 ± 24%  ivb42/ebizzy/performance-50%-100x-10s
>     873871 ± 33%     +47.0%    1284286 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      79678 ± 34%     -64.1%      28635 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>      29748           -10.5%      26617        GEO-MEAN sched_debug.cpu#36.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10975 ± 41%    +124.1%      24599 ± 33%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10975          +124.1%      24599        GEO-MEAN sched_debug.cpu#61.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     674586 ± 26%     +88.0%    1268103 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>     674586           +88.0%    1268103        GEO-MEAN sched_debug.cpu#29.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3726 ± 23%    +144.9%       9124 ± 31%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3726          +144.9%       9124        GEO-MEAN sched_debug.cpu#100.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     680865 ± 26%     +86.2%    1267993 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>     680865           +86.2%    1267993        GEO-MEAN sched_debug.cpu#25.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2244 ± 10%    +125.4%       5058 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2244          +125.4%       5058        GEO-MEAN sched_debug.cpu#119.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1974 ± 34%     +83.1%       3614 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1974           +83.1%       3614        GEO-MEAN sched_debug.cpu#115.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9839 ± 17%    +109.4%      20599 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9838          +109.4%      20598        GEO-MEAN sched_debug.cpu#96.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8190 ±  8%    +119.8%      18004 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8190          +119.8%      18004        GEO-MEAN sched_debug.cpu#73.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12965 ± 37%     +67.3%      21693 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12965           +67.3%      21693        GEO-MEAN sched_debug.cpu#109.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         78 ± 31%     +55.1%        122 ± 17%  ivb42/hackbench/performance-100%-threads-socket
>         78           +55.1%        122        GEO-MEAN sched_debug.cfs_rq[32]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     640509 ±  6%     -10.4%     573818 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     303671 ± 24%     -69.4%      92852 ± 19%  ivb42/hackbench/performance-100%-threads-socket
>     441026           -47.7%     230825        GEO-MEAN sched_debug.cpu#25.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         28 ±  2%     -51.2%         13 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -51.2%         13        GEO-MEAN sched_debug.cpu#44.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  7%     -50.0%         13 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -50.0%         13        GEO-MEAN sched_debug.cfs_rq[44]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  8%     -50.6%         13 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -50.6%         13        GEO-MEAN sched_debug.cfs_rq[44]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  6%     -50.0%         13 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -50.0%         13        GEO-MEAN sched_debug.cpu#44.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3868 ± 33%    +126.0%       8740 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3868          +126.0%       8740        GEO-MEAN sched_debug.cpu#65.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.31 ± 35%     -60.0%       1.73 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       4.95 ± 14%     -43.7%       2.79 ± 37%  ivb42/hackbench/performance-1600%-threads-socket
>       4.62           -52.5%       2.19        GEO-MEAN perf-profile.cpu-cycles.copy_user_enhanced_fast_string.skb_copy_datagram_iovec.unix_stream_recvmsg.sock_aio_read.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3497 ±  9%    +117.2%       7598 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3497          +117.2%       7598        GEO-MEAN sched_debug.cpu#103.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3266 ± 11%    +102.4%       6611 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3266          +102.4%       6611        GEO-MEAN sched_debug.cpu#117.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10902 ± 21%    +153.2%      27605 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10902          +153.2%      27605        GEO-MEAN sched_debug.cpu#97.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2039 ± 32%     +89.0%       3855 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2039           +89.0%       3855        GEO-MEAN sched_debug.cpu#101.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3387 ± 13%    +148.0%       8401 ± 36%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3387          +148.0%       8401        GEO-MEAN sched_debug.cpu#95.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4839 ± 31%    +126.0%      10939 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4839          +126.0%      10939        GEO-MEAN sched_debug.cpu#64.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4041 ± 38%    +184.1%      11482 ± 32%  ivb42/ebizzy/performance-50%-100x-10s
>     875043 ±  2%     -10.0%     787246 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      59467           +59.9%      95075        GEO-MEAN sched_debug.cpu#34.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7706 ± 14%    +115.5%      16604 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7706          +115.5%      16604        GEO-MEAN sched_debug.cpu#90.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12855 ± 30%     +67.5%      21531 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      12855           +67.5%      21531        GEO-MEAN softirqs.HRTIMER
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4317 ± 16%    +119.8%       9490 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4317          +119.8%       9490        GEO-MEAN sched_debug.cpu#61.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        110 ± 27%     +67.9%        184 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>        110           +67.9%        184        GEO-MEAN sched_debug.cfs_rq[22]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8104 ± 16%     +90.8%      15464 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8104           +90.8%      15464        GEO-MEAN sched_debug.cpu#101.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2328798 ± 10%     -62.2%     880977 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    1109100 ± 25%     +53.9%    1707190 ± 16%  ivb42/hackbench/performance-50%-threads-socket
>    1607131           -23.7%    1226375        GEO-MEAN sched_debug.cfs_rq[15]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8172 ± 10%    +123.8%      18287 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8172          +123.8%      18287        GEO-MEAN sched_debug.cpu#109.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4915 ± 14%     -31.2%       3380 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     890704 ± 36%     +51.7%    1351140 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      95322 ± 16%     -59.1%      39011 ± 24%  ivb42/hackbench/performance-1600%-threads-socket
>      74731           -24.7%      56273        GEO-MEAN sched_debug.cpu#46.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4476 ± 15%    +131.1%      10345 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4476          +131.1%      10345        GEO-MEAN sched_debug.cpu#63.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12953 ± 33%     +65.1%      21382 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12953           +65.1%      21382        GEO-MEAN sched_debug.cpu#107.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4005 ±  9%     -21.4%       3147 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     882034 ± 33%     +46.5%    1292381 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      91195 ± 14%     -66.2%      30860 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      68554           -27.0%      50072        GEO-MEAN sched_debug.cpu#44.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        107 ± 36%    +123.9%        240 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         98 ± 36%     -49.1%         50 ± 34%  ivb42/hackbench/performance-50%-threads-socket
>        102            +6.8%        109        GEO-MEAN sched_debug.cfs_rq[18]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8604 ± 14%     +89.6%      16312 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8603           +89.6%      16312        GEO-MEAN sched_debug.cpu#115.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3129 ± 28%    +114.4%       6710 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3129          +114.4%       6710        GEO-MEAN sched_debug.cpu#74.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2156 ± 29%     +95.4%       4214 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2156           +95.4%       4214        GEO-MEAN sched_debug.cpu#110.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8779 ± 30%    +103.3%      17847 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8779          +103.3%      17847        GEO-MEAN sched_debug.cpu#60.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12004 ± 21%    +108.9%      25079 ± 27%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12004          +108.9%      25079        GEO-MEAN sched_debug.cpu#93.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13436 ± 29%    +104.9%      27528 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13436          +104.9%      27528        GEO-MEAN sched_debug.cpu#92.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10222 ± 20%    +150.2%      25577 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10222          +150.2%      25577        GEO-MEAN sched_debug.cpu#72.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8816 ± 15%    +104.3%      18014 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8816          +104.3%      18014        GEO-MEAN sched_debug.cpu#61.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3264 ± 13%    +120.0%       7182 ± 27%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3263          +120.0%       7182        GEO-MEAN sched_debug.cpu#105.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2479 ± 17%    +133.9%       5799 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2479          +133.9%       5799        GEO-MEAN sched_debug.cpu#66.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4210 ±  4%     -31.4%       2889 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     854454 ± 35%     +47.8%    1262955 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      87160 ± 24%     -58.6%      36096 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>      67938           -25.1%      50880        GEO-MEAN sched_debug.cpu#41.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3268 ± 11%    +122.6%       7276 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3268          +122.6%       7276        GEO-MEAN sched_debug.cpu#102.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7923 ± 30%    +110.7%      16696 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7923          +110.7%      16696        GEO-MEAN sched_debug.cpu#65.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1659 ± 14%    +140.5%       3991 ± 30%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1659          +140.5%       3991        GEO-MEAN sched_debug.cpu#111.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13480 ± 39%     +61.4%      21753 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13480           +61.4%      21753        GEO-MEAN sched_debug.cpu#116.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3895 ±  9%     -21.0%       3075 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     877671 ± 33%     +49.6%    1312951 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>      94555 ± 24%     -65.5%      32586 ± 17%  ivb42/hackbench/performance-1600%-threads-socket
>      68629           -25.9%      50863        GEO-MEAN sched_debug.cpu#45.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ± 11%     -42.2%         12 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -42.2%         12        GEO-MEAN sched_debug.cpu#41.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        199 ± 13%     -59.6%         80 ± 39%  ivb42/hackbench/performance-100%-threads-socket
>        198           -59.6%         80        GEO-MEAN sched_debug.cfs_rq[29]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 26%     +68.6%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         11           +68.6%         19        GEO-MEAN sched_debug.cpu#23.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10700 ± 13%     +91.9%      20535 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10700           +91.9%      20535        GEO-MEAN sched_debug.cpu#119.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8157 ±  8%    +110.3%      17158 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8157          +110.3%      17158        GEO-MEAN sched_debug.cpu#111.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4428 ± 23%    +107.8%       9202 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4428          +107.8%       9202        GEO-MEAN sched_debug.cpu#66.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12467 ± 43%    +105.2%      25584 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12467          +105.2%      25584        GEO-MEAN sched_debug.cpu#91.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11149 ± 19%    +127.4%      25350 ± 30%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11148          +127.4%      25350        GEO-MEAN sched_debug.cpu#112.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2398 ± 44%    +145.4%       5885 ± 40%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2398          +145.4%       5885        GEO-MEAN sched_debug.cpu#99.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        124 ± 22%     +62.6%        201 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>        124           +62.6%        201        GEO-MEAN sched_debug.cfs_rq[22]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        543 ± 12%     -42.4%        312 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>        542           -42.4%        312        GEO-MEAN sched_debug.cfs_rq[41]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11100 ± 35%    +113.3%      23677 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11100          +113.3%      23677        GEO-MEAN sched_debug.cpu#68.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9096 ± 14%    +119.4%      19955 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9096          +119.4%      19955        GEO-MEAN sched_debug.cpu#63.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10347 ± 28%    +104.1%      21118 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10347          +104.1%      21118        GEO-MEAN sched_debug.cpu#64.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        141 ±  2%     +39.5%        196 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>         55 ± 24%    +164.8%        145 ± 24%  ivb42/hackbench/performance-100%-threads-socket
>         88           +92.2%        169        GEO-MEAN sched_debug.cfs_rq[33]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4817 ± 15%     -30.3%       3359 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      84395 ± 33%     -65.5%      29123 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>      20163           -50.9%       9891        GEO-MEAN sched_debug.cpu#47.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         51 ± 24%    +160.1%        132 ± 47%  ivb42/hackbench/performance-100%-threads-socket
>         51          +160.1%        132        GEO-MEAN sched_debug.cfs_rq[7]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5109 ± 29%    +100.1%      10224 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       5109          +100.1%      10224        GEO-MEAN sched_debug.cpu#74.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14788 ± 12%     +92.3%      28443 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14788           +92.3%      28443        GEO-MEAN sched_debug.cpu#104.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      78375 ± 26%     -60.1%      31238 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>    1487380 ±  1%     -16.3%    1244520 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     341429           -42.3%     197171        GEO-MEAN sched_debug.cpu#23.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      75615 ± 14%     -60.8%      29648 ± 22%  ivb42/hackbench/performance-1600%-threads-socket
>    1418996 ±  0%     -16.4%    1186744 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     327564           -42.7%     187577        GEO-MEAN sched_debug.cpu#16.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11926 ± 12%    +101.0%      23972 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11926          +101.0%      23972        GEO-MEAN sched_debug.cpu#104.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 17%     -45.5%         12 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>         22           -45.5%         12        GEO-MEAN sched_debug.cpu#41.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ± 13%     -41.9%         12 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -41.9%         12        GEO-MEAN sched_debug.cfs_rq[41]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ± 13%     -41.9%         12 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -41.9%         12        GEO-MEAN sched_debug.cfs_rq[41]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 30%     +50.0%         21 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +50.0%         21        GEO-MEAN sched_debug.cpu#39.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2697666 ± 25%     -42.1%    1561300 ± 38%  ivb42/hackbench/performance-1600%-threads-socket
>     923375 ± 22%     +96.3%    1812750 ± 21%  ivb42/hackbench/performance-50%-threads-socket
>    1578277            +6.6%    1682334        GEO-MEAN sched_debug.cfs_rq[14]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4394 ± 15%    +109.0%       9183 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4394          +109.0%       9183        GEO-MEAN sched_debug.cpu#118.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7129 ± 17%     -43.6%       4020 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>       7129           -43.6%       4020        GEO-MEAN sched_debug.cpu#45.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3428 ± 10%     +96.3%       6727 ± 31%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3427           +96.3%       6727        GEO-MEAN sched_debug.cpu#112.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9071 ± 25%    +114.8%      19484 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9071          +114.8%      19483        GEO-MEAN sched_debug.cpu#99.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13501 ± 24%     +81.2%      24458 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13501           +81.2%      24458        GEO-MEAN sched_debug.cpu#110.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4656 ± 19%     +77.9%       8286 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4656           +77.9%       8286        GEO-MEAN sched_debug.cpu#96.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4101 ±  5%     -27.6%       2969 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      86361 ± 42%     -68.6%      27099 ± 17%  ivb42/hackbench/performance-1600%-threads-socket
>      18821           -52.3%       8969        GEO-MEAN sched_debug.cpu#43.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4195 ± 12%     -32.6%       2828 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4454 ± 27%    +113.0%       9485 ± 24%  ivb42/ebizzy/performance-50%-100x-10s
>     702933 ± 25%     +86.9%    1313646 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      23594           +39.0%      32786        GEO-MEAN sched_debug.cpu#34.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9428 ± 12%     +87.6%      17690 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9428           +87.6%      17690        GEO-MEAN sched_debug.cpu#110.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2700 ± 28%     +89.5%       5115 ± 33%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2699           +89.5%       5115        GEO-MEAN sched_debug.cpu#104.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  1%     -43.4%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -43.4%         15        GEO-MEAN sched_debug.cpu#44.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8665 ±  7%     +88.1%      16301 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8665           +88.1%      16301        GEO-MEAN sched_debug.cpu#108.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4667 ±  9%     -40.5%       2776 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>      78363 ± 16%     -60.5%      30923 ± 21%  ivb42/hackbench/performance-1600%-threads-socket
>    1417611 ±  1%     -16.1%    1189420 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      80336           -41.8%      46743        GEO-MEAN sched_debug.cpu#14.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10055 ± 22%     +70.8%      17173 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10055           +70.8%      17173        GEO-MEAN sched_debug.cpu#116.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        305 ± 17%     +65.9%        507 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        305           +65.9%        507        GEO-MEAN sched_debug.cfs_rq[23]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  6%     -37.7%         14 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -37.7%         14        GEO-MEAN sched_debug.cfs_rq[43]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  7%     -41.4%         13 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -41.4%         13        GEO-MEAN sched_debug.cpu#41.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  6%     -37.7%         14 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -37.7%         14        GEO-MEAN sched_debug.cfs_rq[43]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 10%     -37.3%         14 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         22           -37.3%         13        GEO-MEAN sched_debug.cpu#45.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         96 ± 41%     -48.6%         49 ± 23%  ivb42/hackbench/performance-100%-threads-socket
>       1482 ± 17%     +87.6%       2782 ± 30%  ivb42/hackbench/performance-1600%-threads-socket
>        378            -1.8%        371        GEO-MEAN sched_debug.cfs_rq[4]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14015 ± 16%     +65.6%      23204 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      14014           +65.6%      23203        GEO-MEAN sched_debug.cfs_rq[23]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4468 ± 14%     -30.6%       3102 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     684347 ± 25%     +91.0%    1307218 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      55299           +15.2%      63680        GEO-MEAN sched_debug.cpu#33.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9108 ± 17%     +94.8%      17740 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9108           +94.8%      17740        GEO-MEAN sched_debug.cpu#66.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        119 ± 29%     +77.9%        211 ± 27%  ivb42/ebizzy/performance-50%-100x-10s
>        119           +77.9%        211        GEO-MEAN sched_debug.cfs_rq[21]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        121 ± 32%    +112.1%        257 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        119 ± 32%     -41.7%         69 ± 23%  ivb42/hackbench/performance-50%-threads-socket
>        120           +11.2%        134        GEO-MEAN sched_debug.cfs_rq[18]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4506 ± 26%     +63.3%       7357 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4506           +63.3%       7357        GEO-MEAN sched_debug.cpu#58.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         45 ± 17%     -55.0%         20 ± 28%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         45           -55.0%         20        GEO-MEAN sched_debug.cfs_rq[46]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         94 ± 23%     +99.6%        187 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         94           +99.6%        187        GEO-MEAN sched_debug.cfs_rq[20]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         89 ± 22%     +57.8%        141 ± 32%  ivb42/hackbench/performance-100%-threads-socket
>         89           +57.8%        141        GEO-MEAN sched_debug.cfs_rq[43]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         45 ± 39%     +91.1%         86 ± 25%  ivb42/ebizzy/performance-50%-100x-10s
>         44           +91.1%         85        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 24%     +55.3%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +55.3%         19        GEO-MEAN sched_debug.cpu#23.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 11%     +63.9%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +63.9%         19        GEO-MEAN sched_debug.cpu#20.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3549 ± 12%     +79.2%       6361 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3549           +79.2%       6361        GEO-MEAN sched_debug.cpu#90.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10074 ± 20%     +83.0%      18438 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10073           +83.0%      18437        GEO-MEAN sched_debug.cpu#114.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        160 ± 18%     +51.0%        241 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>         65 ± 36%    +107.6%        136 ± 22%  ivb42/hackbench/performance-100%-threads-socket
>       3368 ± 28%     -42.4%       1940 ± 39%  ivb42/hackbench/performance-1600%-threads-socket
>        328           +21.8%        399        GEO-MEAN sched_debug.cfs_rq[14]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14851 ± 29%     +62.6%      24151 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14851           +62.6%      24151        GEO-MEAN sched_debug.cpu#119.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12294 ± 25%     +76.6%      21718 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12294           +76.6%      21717        GEO-MEAN sched_debug.cpu#66.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        313 ± 11%     +66.0%        519 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        312           +66.0%        519        GEO-MEAN sched_debug.cfs_rq[20]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        176 ± 26%     +30.1%        229 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>        100 ±  4%     -55.3%         45 ± 22%  ivb42/hackbench/performance-100%-threads-socket
>       3329 ± 11%     -41.0%       1963 ± 28%  ivb42/hackbench/performance-1600%-threads-socket
>        389           -30.0%        272        GEO-MEAN sched_debug.cfs_rq[5]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        119 ± 35%     -40.2%         71 ± 15%  ivb42/hackbench/performance-100%-threads-socket
>       1511 ± 17%     +85.4%       2801 ± 30%  ivb42/hackbench/performance-1600%-threads-socket
>        424            +5.3%        447        GEO-MEAN sched_debug.cfs_rq[4]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14368 ± 11%     +65.6%      23794 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>      14368           +65.6%      23794        GEO-MEAN sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         28 ± 35%     +91.4%         53 ± 44%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         27           +91.4%         53        GEO-MEAN sched_debug.cfs_rq[39]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2121 ±  8%     -29.9%       1487 ± 32%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     674766 ± 29%     +84.3%    1243680 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      37834           +13.7%      43006        GEO-MEAN sched_debug.cpu#28.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3865 ± 10%     +62.2%       6270 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3865           +62.2%       6270        GEO-MEAN sched_debug.cpu#113.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3681 ± 20%    +109.1%       7697 ± 31%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3681          +109.1%       7697        GEO-MEAN sched_debug.cpu#30.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        757 ± 39%     -49.3%        383 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        756           -49.3%        383        GEO-MEAN sched_debug.cpu#84.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4694 ± 11%     -27.9%       3383 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     690405 ± 25%     +89.0%    1304632 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      56927           +16.7%      66434        GEO-MEAN sched_debug.cpu#31.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4565 ± 36%    +106.5%       9429 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4565          +106.5%       9429        GEO-MEAN sched_debug.cpu#69.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14499 ± 21%     +83.6%      26623 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14499           +83.6%      26623        GEO-MEAN sched_debug.cpu#114.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        679 ± 29%     -56.0%        299 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        679           -56.0%        299        GEO-MEAN sched_debug.cpu#85.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12264 ± 18%     +73.0%      21211 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12264           +73.0%      21211        GEO-MEAN sched_debug.cpu#115.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1006499 ± 33%     +67.8%    1688436 ± 22%  ivb42/hackbench/performance-50%-threads-socket
>    1006499           +67.8%    1688436        GEO-MEAN sched_debug.cfs_rq[13]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3741 ± 29%     +58.4%       5927 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>     692121 ± 29%     +82.6%    1263807 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      50888           +70.1%      86550        GEO-MEAN sched_debug.cpu#24.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12227 ± 31%    +142.1%      29608 ± 31%  ivb42/ebizzy/performance-50%-100x-10s
>   17773083 ± 10%     +54.6%   27478266 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   31340929 ±  0%     -16.7%   26094438 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1895568           +46.1%    2768962        GEO-MEAN sched_debug.cpu#34.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  8%     -38.5%         13 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -38.5%         13        GEO-MEAN sched_debug.cfs_rq[45]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  8%     -38.5%         13 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -38.5%         13        GEO-MEAN sched_debug.cfs_rq[45]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 12%     +76.9%         23 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +76.9%         23        GEO-MEAN sched_debug.cpu#17.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        107 ± 21%     +90.3%        203 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>        106           +90.3%        203        GEO-MEAN sched_debug.cfs_rq[20]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4744 ±  4%     -26.5%       3488 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4034 ± 27%     +73.4%       6995 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>     686771 ± 30%     +88.0%    1291369 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      23600           +33.8%      31585        GEO-MEAN sched_debug.cpu#32.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2760 ± 37%     +72.2%       4751 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2760           +72.2%       4751        GEO-MEAN sched_debug.cpu#114.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 11%     -40.3%         13 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         22           -40.3%         13        GEO-MEAN sched_debug.cfs_rq[47]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 11%     -40.3%         13 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         22           -40.3%         13        GEO-MEAN sched_debug.cfs_rq[47]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2501 ± 39%    +119.5%       5490 ± 35%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2501          +119.5%       5490        GEO-MEAN sched_debug.cpu#92.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        134 ± 24%     +67.9%        225 ± 25%  ivb42/ebizzy/performance-50%-100x-10s
>        133           +67.9%        225        GEO-MEAN sched_debug.cfs_rq[21]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9384 ± 35%     +94.2%      18221 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9384           +94.2%      18221        GEO-MEAN sched_debug.cpu#69.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9462 ± 18%     +97.7%      18705 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9462           +97.7%      18705        GEO-MEAN sched_debug.cpu#92.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2123826 ± 11%     -43.5%    1200487 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2588915 ± 20%     -27.8%    1869878 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>    1067752 ± 25%     +65.3%    1764542 ± 11%  ivb42/hackbench/performance-50%-threads-socket
>    1803996           -12.3%    1582223        GEO-MEAN sched_debug.cfs_rq[16]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10916 ± 22%     +81.0%      19761 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10916           +81.0%      19760        GEO-MEAN sched_debug.cpu#74.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4129 ± 10%     -25.6%       3072 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     702266 ± 27%     +91.0%    1341447 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      53853           +19.2%      64202        GEO-MEAN sched_debug.cpu#35.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 30%     +50.0%         19 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +50.0%         18        GEO-MEAN sched_debug.cpu#23.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 11%     +58.3%         19 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +58.3%         18        GEO-MEAN sched_debug.cpu#20.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2141496 ± 10%     -43.3%    1213650 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    1203841 ± 25%     +53.0%    1842451 ± 19%  ivb42/hackbench/performance-50%-threads-socket
>    1605622            -6.9%    1495357        GEO-MEAN sched_debug.cfs_rq[17]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6826 ± 16%     -42.2%       3947 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>       6826           -42.2%       3947        GEO-MEAN sched_debug.cpu#42.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +68.3%         23 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +68.3%         23        GEO-MEAN sched_debug.cpu#17.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +68.3%         23 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +68.3%         23        GEO-MEAN sched_debug.cpu#17.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  7%     +67.5%         22 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +67.5%         22        GEO-MEAN sched_debug.cpu#12.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ± 11%     -38.4%         15 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -38.4%         15        GEO-MEAN sched_debug.cpu#43.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  4%     -40.0%         14 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -40.0%         13        GEO-MEAN sched_debug.cpu#45.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4220 ± 27%     +89.2%       7986 ± 30%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4220           +89.2%       7986        GEO-MEAN sched_debug.cpu#99.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     783024 ± 10%     +67.2%    1309563 ± 22%  ivb42/hackbench/performance-50%-threads-socket
>     783024           +67.2%    1309563        GEO-MEAN sched_debug.cfs_rq[5]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4437 ± 24%    +106.1%       9146 ± 15%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     868193 ±  1%     -15.6%     732542 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      62068           +31.9%      81852        GEO-MEAN sched_debug.cpu#13.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        129 ± 20%     +30.6%        169 ± 22%  ivb42/ebizzy/performance-50%-100x-10s
>        129           +30.6%        169        GEO-MEAN sched_debug.cfs_rq[27]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3679 ± 15%     +61.4%       5937 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3679           +61.4%       5937        GEO-MEAN sched_debug.cpu#101.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        303 ± 21%     +76.5%        535 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>        303           +76.5%        535        GEO-MEAN sched_debug.cfs_rq[22]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6.27 ± 30%     -53.4%       2.92 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       6.39 ± 14%     -42.5%       3.67 ± 36%  ivb42/hackbench/performance-1600%-threads-socket
>       2.62 ±  1%     +10.8%       2.90 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.72           -33.3%       3.15        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_iovec.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15488825 ± 11%     +52.2%   23580743 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25578650 ±  1%     -18.4%   20864649 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   19904352           +11.4%   22181161        GEO-MEAN sched_debug.cpu#4.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13913 ± 21%     +76.1%      24495 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>      13913           +76.1%      24495        GEO-MEAN sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3918 ±  8%     -25.7%       2912 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      70998 ± 22%     -58.0%      29820 ± 26%  ivb42/hackbench/performance-1600%-threads-socket
>      16678           -44.1%       9318        GEO-MEAN sched_debug.cpu#40.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3322 ± 38%    +106.6%       6864 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3322          +106.6%       6864        GEO-MEAN sched_debug.cpu#70.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   56932895 ± 29%     +53.2%   87212652 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    6311098 ± 10%     -52.0%    3030624 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>  1.356e+08 ±  0%     -15.5%  1.147e+08 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   36525190           -14.6%   31177685        GEO-MEAN cpuidle.C1-IVT.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.70 ±  5%     +27.7%       3.45 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       2.70           +27.7%       3.45        GEO-MEAN perf-profile.cpu-cycles.idle_cpu.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6916 ± 20%     -48.5%       3561 ± 22%  ivb42/ebizzy/performance-50%-100x-10s
>      27938 ±  6%     -10.6%      24989 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      13900           -32.1%       9433        GEO-MEAN sched_debug.cpu#41.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      71213 ± 24%     -53.3%      33238 ± 28%  ivb42/hackbench/performance-1600%-threads-socket
>    1443239 ±  0%     -16.5%    1205709 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     320589           -37.6%     200190        GEO-MEAN sched_debug.cpu#12.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  6%     +71.8%         22 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +71.8%         22        GEO-MEAN sched_debug.cpu#17.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  6%     +61.0%         22 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +61.0%         22        GEO-MEAN sched_debug.cpu#12.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7629 ± 19%     +92.3%      14669 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   21654231 ±  1%     -24.3%   16385202 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     406469           +20.6%     490269        GEO-MEAN sched_debug.cpu#13.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.26 ±  4%     -38.0%       1.40 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>       2.26           -38.0%       1.40        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        563 ±  9%     -36.6%        357 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>        563           -36.6%        356        GEO-MEAN sched_debug.cfs_rq[45]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     682108 ± 27%     +89.0%    1289515 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      50797 ± 38%     -40.9%      30042 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>     186142            +5.7%     196825        GEO-MEAN sched_debug.cpu#27.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3963 ± 11%     -26.4%       2916 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     866574 ± 35%     +50.8%    1306785 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      80354 ± 15%     -39.7%      48426 ± 21%  ivb42/hackbench/performance-1600%-threads-socket
>      65108           -12.6%      56933        GEO-MEAN sched_debug.cpu#42.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        107 ± 18%     +48.4%        159 ± 28%  ivb42/hackbench/performance-100%-threads-socket
>        107           +48.4%        159        GEO-MEAN sched_debug.cfs_rq[43]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      68301 ± 22%     -46.5%      36531 ± 46%  ivb42/ebizzy/performance-50%-100x-10s
>   17193479 ± 12%     +57.7%   27116974 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30548238 ±  0%     -17.4%   25222173 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    3298074           -11.4%    2923455        GEO-MEAN sched_debug.cpu#25.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      38016 ±  8%     -51.8%      18317 ± 43%  ivb42/ebizzy/performance-50%-100x-10s
>   15881533 ±  9%     +51.7%   24085282 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25808917 ±  0%     -18.1%   21133286 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2497729           -15.7%    2104729        GEO-MEAN sched_debug.cpu#6.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14939 ±  5%     +65.9%      24777 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>      14939           +65.9%      24777        GEO-MEAN sched_debug.cfs_rq[14]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        325 ±  5%     +66.0%        540 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>        325           +66.0%        540        GEO-MEAN sched_debug.cfs_rq[14]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 10%     +51.3%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +51.3%         19        GEO-MEAN sched_debug.cpu#21.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  5%     -39.2%         15 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -39.2%         15        GEO-MEAN sched_debug.cpu#41.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ± 11%     -33.8%         16 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -33.8%         16        GEO-MEAN sched_debug.cpu#46.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.99 ±  4%     -39.9%       0.59 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       0.99           -39.9%       0.59        GEO-MEAN perf-profile.cpu-cycles.__fdget_pos.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 16%     +51.0%         24 ±  1%  ivb42/hackbench/performance-1600%-threads-socket
>         16           +51.0%         24        GEO-MEAN sched_debug.cfs_rq[16]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15519 ±  3%     +69.7%      26336 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>      15518           +69.7%      26336        GEO-MEAN sched_debug.cfs_rq[17]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        161 ±  1%     +32.2%        213 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         75 ± 17%    +119.6%        164 ± 22%  ivb42/hackbench/performance-100%-threads-socket
>        110           +70.3%        187        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        338 ±  3%     +69.9%        574 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        338           +69.9%        574        GEO-MEAN sched_debug.cfs_rq[17]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 13%     -24.2%         16 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ± 18%    +102.2%         30 ± 32%  ivb42/hackbench/performance-1600%-threads-socket
>         18           +23.8%         22        GEO-MEAN sched_debug.cfs_rq[38]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4133 ±  3%     +69.6%       7011 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4133           +69.6%       7011        GEO-MEAN sched_debug.cpu#119.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        195 ± 23%     +27.3%        248 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>        122 ±  4%     -46.3%         65 ± 14%  ivb42/hackbench/performance-100%-threads-socket
>       3356 ± 11%     -40.8%       1988 ± 28%  ivb42/hackbench/performance-1600%-threads-socket
>        431           -26.0%        319        GEO-MEAN sched_debug.cfs_rq[5]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14285 ± 30%     +65.4%      23622 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      14285           +65.4%      23622        GEO-MEAN sched_debug.cpu#98.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9343 ± 12%     +65.6%      15471 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9343           +65.6%      15471        GEO-MEAN sched_debug.cpu#106.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  1%     -37.3%         17 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -37.3%         17        GEO-MEAN sched_debug.cpu#44.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         52 ± 14%     -47.9%         27 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         52           -47.9%         27        GEO-MEAN sched_debug.cfs_rq[46]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  7%     +70.0%         22 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +70.0%         22        GEO-MEAN sched_debug.cpu#17.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 10%     -38.0%         14 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -38.0%         14        GEO-MEAN sched_debug.cpu#47.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3618 ± 20%     +86.7%       6755 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4494 ± 29%     +94.3%       8734 ± 23%  ivb42/ebizzy/performance-50%-100x-10s
>    2231243 ±  6%     +10.5%    2465052 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>     860847 ±  2%     -11.2%     764541 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      74760           +37.4%     102689        GEO-MEAN sched_debug.cpu#39.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1206549 ± 22%     +39.1%    1678852 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    1206549           +39.1%    1678852        GEO-MEAN softirqs.SCHED
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3173 ± 18%     -28.6%       2266 ± 32%  ivb42/hackbench/performance-1600%-threads-socket
>       3173           -28.6%       2266        GEO-MEAN sched_debug.cfs_rq[38]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     537895 ± 26%     +82.5%     981394 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    1471462 ±  1%      -9.5%    1331414 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     889658           +28.5%    1143084        GEO-MEAN sched_debug.cpu#8.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4541 ±  8%     -20.5%       3611 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>      84588 ± 17%     -58.8%      34872 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>    1487383 ±  1%     -17.0%    1233892 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      82979           -35.2%      53761        GEO-MEAN sched_debug.cpu#22.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3196 ± 18%     -28.1%       2298 ± 32%  ivb42/hackbench/performance-1600%-threads-socket
>       3196           -28.1%       2298        GEO-MEAN sched_debug.cfs_rq[38]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  1%     -37.7%         16 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -37.7%         15        GEO-MEAN sched_debug.cpu#41.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  9%     -32.5%         18 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -32.5%         17        GEO-MEAN sched_debug.cpu#46.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  1%     -39.0%         15 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -39.0%         15        GEO-MEAN sched_debug.cpu#41.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        325 ±  9%     +57.9%        513 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        324           +57.9%        513        GEO-MEAN sched_debug.cfs_rq[21]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         90 ± 49%     -49.6%         45 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>         90           -49.6%         45        GEO-MEAN sched_debug.cpu#24.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        134 ± 23%     +69.9%        227 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        133           +69.9%        227        GEO-MEAN sched_debug.cfs_rq[19]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.61 ± 19%     +56.0%       0.96 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.61           +56.0%       0.96        GEO-MEAN perf-profile.cpu-cycles.load_balance.pick_next_task_fair.__sched_text_start.schedule.schedule_hrtimeout_range_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14901 ±  9%     +57.7%      23504 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>      14901           +57.7%      23504        GEO-MEAN sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.68 ± 17%     +52.5%       1.04 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.68           +52.5%       1.04        GEO-MEAN perf-profile.cpu-cycles.schedule.schedule_hrtimeout_range_clock.schedule_hrtimeout_range.poll_schedule_timeout.do_sys_poll
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.67 ± 17%     +53.5%       1.03 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.67           +53.5%       1.03        GEO-MEAN perf-profile.cpu-cycles.__sched_text_start.schedule.schedule_hrtimeout_range_clock.schedule_hrtimeout_range.poll_schedule_timeout
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -36.2%         14 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         16 ± 23%     +62.5%         26 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         19            +1.8%         19        GEO-MEAN sched_debug.cfs_rq[40]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5478 ±  4%     -25.0%       4108 ± 22%  ivb42/ebizzy/performance-50%-100x-10s
>      73277 ± 19%     -55.6%      32537 ± 17%  ivb42/hackbench/performance-1600%-threads-socket
>    1429701 ±  1%     -16.2%    1198182 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      83103           -34.7%      54305        GEO-MEAN sched_debug.cpu#15.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4024 ± 19%     +50.6%       6062 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4024           +50.6%       6062        GEO-MEAN sched_debug.cpu#52.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ±  3%     +65.8%         21 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +65.8%         21        GEO-MEAN sched_debug.cpu#14.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 10%     +50.0%         21 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +50.0%         21        GEO-MEAN sched_debug.cpu#13.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6909 ± 14%     +59.1%      10993 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6097 ± 25%     +76.4%      10756 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>   20172173 ±  0%     -24.0%   15328449 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      94717           +28.7%     121923        GEO-MEAN sched_debug.cpu#39.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        583 ±  7%     -39.3%        354 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>        582           -39.3%        353        GEO-MEAN sched_debug.cfs_rq[46]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.63 ± 19%     +54.8%       0.97 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.63           +54.8%       0.97        GEO-MEAN perf-profile.cpu-cycles.pick_next_task_fair.__sched_text_start.schedule.schedule_hrtimeout_range_clock.schedule_hrtimeout_range
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.68 ± 17%     +52.2%       1.04 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.68           +52.2%       1.04        GEO-MEAN perf-profile.cpu-cycles.poll_schedule_timeout.do_sys_poll.sys_poll.system_call_fastpath.poll
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     546799 ± 23%     +82.5%     997770 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    1499703 ±  0%      -9.7%    1354350 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     905558           +28.4%    1162467        GEO-MEAN sched_debug.cpu#10.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7322 ± 18%     -42.4%       4214 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7321           -42.4%       4214        GEO-MEAN sched_debug.cpu#38.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        580 ±  5%     -39.0%        354 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        580           -39.0%        353        GEO-MEAN sched_debug.cfs_rq[43]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5981 ± 16%     -39.5%       3621 ± 32%  ivb42/ebizzy/performance-50%-100x-10s
>     872462 ±  0%     -15.4%     737745 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      72237           -28.5%      51685        GEO-MEAN sched_debug.cpu#15.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 16%     +49.0%         24 ±  1%  ivb42/hackbench/performance-1600%-threads-socket
>         16           +49.0%         24        GEO-MEAN sched_debug.cpu#16.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -33.8%         15 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -33.8%         15        GEO-MEAN sched_debug.cpu#46.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -33.8%         15 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -33.8%         15        GEO-MEAN sched_debug.cfs_rq[46]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.68 ± 17%     +51.7%       1.04 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.68           +51.7%       1.04        GEO-MEAN perf-profile.cpu-cycles.schedule_hrtimeout_range.poll_schedule_timeout.do_sys_poll.sys_poll.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.68 ± 17%     +51.7%       1.04 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.68           +51.7%       1.04        GEO-MEAN perf-profile.cpu-cycles.schedule_hrtimeout_range_clock.schedule_hrtimeout_range.poll_schedule_timeout.do_sys_poll.sys_poll
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4148 ± 10%     -37.2%       2604 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4148           -37.2%       2604        GEO-MEAN sched_debug.cpu#54.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.45 ±  4%     -35.2%       2.88 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       4.45           -35.2%       2.88        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        122 ± 24%     +71.9%        209 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>        122           +71.9%        209        GEO-MEAN sched_debug.cfs_rq[19]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     531678 ± 21%     +73.3%     921348 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    1427072 ±  1%      -9.9%    1285217 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     871058           +24.9%    1088178        GEO-MEAN sched_debug.cpu#5.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5329 ± 29%     +90.0%      10124 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       5328           +90.0%      10124        GEO-MEAN sched_debug.cpu#70.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        836 ± 42%     -45.7%        454 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        836           -45.7%        454        GEO-MEAN sched_debug.cpu#79.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3921 ± 19%     -38.5%       2413 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4015 ±  9%     -31.4%       2754 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>      66687 ±  7%     -49.1%      33950 ± 20%  ivb42/hackbench/performance-1600%-threads-socket
>    1450656 ±  1%     -17.1%    1202921 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      35130           -35.0%      22824        GEO-MEAN sched_debug.cpu#18.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7426 ± 16%     +53.1%      11372 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7426           +53.1%      11372        GEO-MEAN sched_debug.cpu#58.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3955 ± 13%     -24.9%       2970 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     545421 ± 22%     +82.6%     996072 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    1495572 ±  0%     -10.9%    1333271 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     147764            +6.9%     158010        GEO-MEAN sched_debug.cpu#9.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  3%     -35.4%         17 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -35.4%         17        GEO-MEAN sched_debug.cpu#43.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  9%     -33.7%         18 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -33.7%         18        GEO-MEAN sched_debug.cpu#46.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  6%     -35.8%         17 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -35.8%         17        GEO-MEAN sched_debug.cpu#43.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  9%     -33.7%         18 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         27           -33.7%         18        GEO-MEAN sched_debug.cpu#46.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  6%     -32.9%         17 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -32.9%         17        GEO-MEAN sched_debug.cpu#47.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4030 ± 18%     +61.5%       6508 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4030           +61.5%       6508        GEO-MEAN sched_debug.cpu#50.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        351 ±  9%     +58.8%        557 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        350           +58.8%        557        GEO-MEAN sched_debug.cfs_rq[12]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.11 ±  3%     -29.1%       0.78 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>       1.11           -29.1%       0.78        GEO-MEAN perf-profile.cpu-cycles.check_preempt_curr.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        882 ± 30%     -38.9%        539 ± 32%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        882           -38.9%        539        GEO-MEAN sched_debug.cpu#88.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16092 ±  9%     +58.6%      25525 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      16091           +58.6%      25525        GEO-MEAN sched_debug.cfs_rq[12]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ±  3%     +54.1%         19 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +54.1%         18        GEO-MEAN sched_debug.cpu#14.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 13%     +52.6%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +52.6%         19        GEO-MEAN sched_debug.cpu#21.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 10%     +51.4%         18 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +51.4%         18        GEO-MEAN sched_debug.cpu#20.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6.42 ±  4%     -33.1%       4.30 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       6.42           -33.1%       4.30        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.22 ±  3%     -29.1%       0.87 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       1.22           -29.1%       0.87        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.24 ± 23%     -42.5%       0.71 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       1.24           -42.5%       0.71        GEO-MEAN perf-profile.cpu-cycles.cmpxchg_double_slab.isra.49.__slab_free.kmem_cache_free.kfree_skbmem.consume_skb
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5.13 ±  4%     -33.8%       3.40 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       5.13           -33.8%       3.40        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.63 ±  3%     +17.9%       4.29 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.63           +17.9%       4.29        GEO-MEAN perf-profile.cpu-cycles.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8188 ± 16%     +67.0%      13677 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11910986 ± 14%     +61.3%   19211796 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   21798079 ±  1%     -14.6%   18621574 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1285823           +32.0%    1697690        GEO-MEAN sched_debug.cpu#9.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30345040 ±  1%     -18.8%   24632965 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   30345040           -18.8%   24632965        GEO-MEAN sched_debug.cpu#39.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5.14 ±  4%     -33.8%       3.41 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       5.14           -33.8%       3.41        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2029 ± 16%     +79.2%       3637 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2029           +79.2%       3637        GEO-MEAN sched_debug.cpu#108.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  5%     +64.3%         23 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +64.3%         23        GEO-MEAN sched_debug.cpu#12.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  5%     +61.9%         22 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +61.9%         22        GEO-MEAN sched_debug.cpu#12.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  5%     +61.9%         22 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +61.9%         22        GEO-MEAN sched_debug.cpu#12.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7338 ± 12%     -46.3%       3940 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      27156 ±  7%     -12.6%      23745 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      14116           -31.5%       9672        GEO-MEAN sched_debug.cpu#43.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3570 ± 11%     +73.3%       6187 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3570           +73.3%       6187        GEO-MEAN sched_debug.cpu#109.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     529022 ± 23%     +76.8%     935086 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>    1395020 ±  0%     -10.0%    1255965 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     859067           +26.2%    1083713        GEO-MEAN sched_debug.cpu#1.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         15 ± 28%     +55.3%         24 ± 20%  ivb42/hackbench/performance-1600%-threads-socket
>         15           +55.3%         24        GEO-MEAN sched_debug.cpu#38.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         15 ± 23%     +78.7%         28 ± 34%  ivb42/ebizzy/performance-50%-100x-10s
>         15           +78.7%         27        GEO-MEAN sched_debug.cpu#12.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  6%     -33.3%         16 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -33.3%         16        GEO-MEAN sched_debug.cpu#47.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -36.4%         16 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -36.4%         16        GEO-MEAN sched_debug.cpu#43.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -34.8%         15 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>         16 ± 24%     +56.0%         26 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         19            +0.9%         19        GEO-MEAN sched_debug.cpu#40.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     535261 ± 24%     +78.9%     957745 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>    1451847 ±  1%      -9.6%    1311874 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     881543           +27.2%    1120911        GEO-MEAN sched_debug.cpu#7.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      20643 ± 23%     +36.4%      28161 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      16155 ±  3%     +66.8%      26952 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      18262           +50.9%      27550        GEO-MEAN proc-vmstat.numa_pages_migrated
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      20643 ± 23%     +36.4%      28161 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      16155 ±  3%     +66.8%      26952 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      18262           +50.9%      27550        GEO-MEAN proc-vmstat.pgmigrate_success
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9385 ± 14%     -41.0%       5534 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   17006086 ± 12%     +60.9%   27369535 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30313545 ±  1%     -17.1%   25125827 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1691341            -7.7%    1561336        GEO-MEAN sched_debug.cpu#26.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        356 ± 10%     +53.4%        546 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        356           +53.4%        546        GEO-MEAN sched_debug.cfs_rq[13]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7389 ±  8%     +71.4%      12668 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   19417423 ±  1%     -23.3%   14891714 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     378801           +14.7%     434336        GEO-MEAN sched_debug.cpu#41.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 24%     -29.4%          7 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         31 ± 24%     -38.3%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         17           -34.0%         11        GEO-MEAN sched_debug.cfs_rq[15]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        592 ±  5%     -40.1%        354 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>        312 ±  7%     +31.6%        410 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>        429           -11.2%        381        GEO-MEAN sched_debug.cfs_rq[44]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3416598 ±  7%     -35.9%    2189890 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3416598           -35.9%    2189890        GEO-MEAN sched_debug.cfs_rq[88]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3832 ± 15%     +39.8%       5358 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3832           +39.8%       5358        GEO-MEAN sched_debug.cpu#115.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23.87 ± 12%     -32.1%      16.21 ± 24%  ivb42/hackbench/performance-1600%-threads-socket
>      23.87           -32.1%      16.21        GEO-MEAN perf-profile.cpu-cycles.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read.vfs_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3655 ± 10%     -21.4%       2872 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      87492 ± 28%     -57.0%      37635 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>    1447302 ±  0%     -16.4%    1210584 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      77353           -34.4%      50773        GEO-MEAN sched_debug.cpu#19.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.32 ±  2%     +13.3%       4.90 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.32           +13.3%       4.90        GEO-MEAN perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24.70 ± 12%     -31.9%      16.82 ± 24%  ivb42/hackbench/performance-1600%-threads-socket
>      24.70           -31.9%      16.82        GEO-MEAN perf-profile.cpu-cycles.sock_aio_read.part.10.sock_aio_read.do_sync_read.vfs_read.sys_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ±  2%     -28.0%         12 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>         16           -28.0%         12        GEO-MEAN sched_debug.cpu#27.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ±  2%     -30.0%         11 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         16           -30.0%         11        GEO-MEAN sched_debug.cfs_rq[27]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ±  2%     -30.0%         11 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         16           -30.0%         11        GEO-MEAN sched_debug.cfs_rq[27]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 15%     +51.4%         18 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +51.4%         18        GEO-MEAN sched_debug.cfs_rq[17]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24.74 ± 12%     -31.9%      16.85 ± 24%  ivb42/hackbench/performance-1600%-threads-socket
>      24.74           -31.9%      16.85        GEO-MEAN perf-profile.cpu-cycles.sock_aio_read.do_sync_read.vfs_read.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27.38 ± 12%     -31.8%      18.68 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      27.38           -31.8%      18.68        GEO-MEAN perf-profile.cpu-cycles.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16368 ± 10%     +52.9%      25026 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      16368           +52.9%      25026        GEO-MEAN sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      26.74 ± 12%     -31.7%      18.25 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      26.74           -31.7%      18.25        GEO-MEAN perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9928 ± 16%     +65.5%      16433 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9928           +65.5%      16432        GEO-MEAN sched_debug.cpu#107.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24.94 ± 12%     -31.8%      17.00 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      24.94           -31.8%      17.00        GEO-MEAN perf-profile.cpu-cycles.do_sync_read.vfs_read.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1906 ±  6%     -32.3%       1291 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1906           -32.3%       1291        GEO-MEAN sched_debug.cpu#104.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +60.0%         21 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +60.0%         21        GEO-MEAN sched_debug.cpu#18.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 15%     +47.5%         19 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +47.5%         19        GEO-MEAN sched_debug.cpu#21.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ±  3%     +57.9%         20 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +57.9%         19        GEO-MEAN sched_debug.cpu#14.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +62.5%         21 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +62.5%         21        GEO-MEAN sched_debug.cpu#18.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ±  3%     +60.5%         20 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +60.5%         20        GEO-MEAN sched_debug.cpu#14.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +60.0%         21 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +60.0%         21        GEO-MEAN sched_debug.cpu#18.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3140 ± 36%    +144.5%       7678 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>    3441316 ± 10%     +10.7%    3808986 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>     103950           +64.5%     171016        GEO-MEAN sched_debug.cpu#24.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8114 ± 16%     +95.9%      15897 ± 23%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11925417 ± 16%     +62.2%   19343786 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   21736276 ±  0%     -15.7%   18334370 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1281273           +38.9%    1779842        GEO-MEAN sched_debug.cpu#8.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4725 ± 17%     +64.0%       7751 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4725           +64.0%       7750        GEO-MEAN sched_debug.cpu#104.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7495 ± 17%     +32.7%       9948 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       7495           +32.7%       9948        GEO-MEAN sched_debug.cfs_rq[12]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4917 ± 16%     +82.6%       8980 ± 29%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4257 ± 14%     -45.8%       2307 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>    2403163 ±  2%      -8.8%    2191554 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>     862442 ±  0%     -15.1%     732316 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      81157            -6.4%      75937        GEO-MEAN sched_debug.cpu#14.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7576 ± 16%     +31.7%       9978 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7576           +31.7%       9978        GEO-MEAN sched_debug.cfs_rq[13]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      32805 ±  9%     -33.8%      21701 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>      32805           -33.8%      21701        GEO-MEAN sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        716 ±  9%     -33.9%        473 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>        716           -33.9%        473        GEO-MEAN sched_debug.cfs_rq[46]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      75672 ± 15%     -50.5%      37483 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>    1473950 ±  1%     -16.2%    1235367 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     333971           -35.6%     215187        GEO-MEAN sched_debug.cpu#20.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  6%     -33.8%         17 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -33.7%         17        GEO-MEAN sched_debug.cpu#43.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  9%     -30.8%         18 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -30.8%         17        GEO-MEAN sched_debug.cpu#46.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        382 ±  6%     +46.4%        559 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        382           +46.4%        559        GEO-MEAN sched_debug.cfs_rq[15]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4992 ± 25%    +100.4%      10005 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>   11668236 ± 13%     +59.7%   18628665 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   20231936 ±  0%     -13.8%   17436914 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1056263           +40.2%    1481231        GEO-MEAN sched_debug.cpu#24.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14541 ± 18%     +69.8%      24696 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      14541           +69.8%      24695        GEO-MEAN sched_debug.cfs_rq[19]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        317 ± 18%     +70.1%        539 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        317           +70.1%        539        GEO-MEAN sched_debug.cfs_rq[19]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7215 ± 15%     +34.7%       9716 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       7214           +34.7%       9716        GEO-MEAN sched_debug.cfs_rq[9]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17530 ±  6%     +46.0%      25603 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      17530           +46.0%      25602        GEO-MEAN sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7309 ± 16%     +33.9%       9789 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       7309           +33.9%       9789        GEO-MEAN sched_debug.cfs_rq[10]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30019 ±  7%     +14.9%      34496 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       6890 ± 19%     -54.9%       3109 ± 17%  ivb42/hackbench/performance-1600%-threads-socket
>      22044 ±  1%     +25.8%      27733 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      16582           -13.3%      14381        GEO-MEAN cpuidle.C1E-IVT.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.63 ±  8%     -32.9%       1.09 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       1.63           -32.9%       1.09        GEO-MEAN perf-profile.cpu-cycles.inode_has_perm.isra.30.file_has_perm.selinux_file_permission.security_file_permission.rw_verify_area
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7383 ± 17%     +33.5%       9857 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       7383           +33.5%       9857        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7949 ± 18%     +28.4%      10203 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7949           +28.4%      10203        GEO-MEAN sched_debug.cfs_rq[19]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1230679 ±  9%     +65.1%    2032295 ± 14%  ivb42/hackbench/performance-50%-threads-socket
>    1230679           +65.1%    2032295        GEO-MEAN sched_debug.cfs_rq[10]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8408 ± 11%     +19.2%      10025 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6401 ± 24%    +120.5%      14112 ± 27%  ivb42/ebizzy/performance-50%-100x-10s
>   11821848 ± 11%     +56.6%   18516571 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   20560704 ±  0%     -16.2%   17227893 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     338198           +36.3%     460924        GEO-MEAN sched_debug.cpu#34.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7677 ± 16%     +30.2%       9992 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7677           +30.2%       9992        GEO-MEAN sched_debug.cfs_rq[14]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7909 ± 18%     +28.7%      10178 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7909           +28.7%      10178        GEO-MEAN sched_debug.cfs_rq[18]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5847 ± 24%     -28.9%       4154 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     516962 ± 23%     +80.2%     931432 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    1404122 ±  0%     -10.1%    1262026 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     161907            +4.8%     169658        GEO-MEAN sched_debug.cpu#2.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   5.22e+09 ±  7%     +58.9%  8.293e+09 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>  6.257e+08 ± 12%     +34.0%  8.383e+08 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>  1.807e+09           +45.9%  2.637e+09        GEO-MEAN cpuidle.C1-IVT.time
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15999 ± 10%     +59.5%      25516 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      15999           +59.5%      25515        GEO-MEAN sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        349 ± 10%     +59.5%        557 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        349           +59.5%        557        GEO-MEAN sched_debug.cfs_rq[18]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7975 ± 18%     +28.3%      10236 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7975           +28.3%      10236        GEO-MEAN sched_debug.cfs_rq[20]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17005681 ± 14%     +56.0%   26524924 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30364476 ±  0%     -17.2%   25142879 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   22723745           +13.6%   25824658        GEO-MEAN sched_debug.cpu#28.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     640395 ±  3%     -15.6%     540784 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>    1456410 ± 18%     +70.5%    2483287 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>     965753           +20.0%    1158845        GEO-MEAN sched_debug.cpu#47.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.44 ±  8%     -32.3%       0.98 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.44           -32.3%       0.98        GEO-MEAN perf-profile.cpu-cycles.avc_has_perm.inode_has_perm.file_has_perm.selinux_file_permission.security_file_permission
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8919 ± 11%     +65.7%      14777 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12095766 ± 13%     +62.2%   19621720 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   21609616 ±  0%     -14.6%   18459478 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1326005           +31.9%    1749264        GEO-MEAN sched_debug.cpu#5.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7935 ± 18%     +28.0%      10155 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7935           +28.0%      10155        GEO-MEAN sched_debug.cfs_rq[17]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7977 ± 18%     +28.6%      10256 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       7977           +28.6%      10256        GEO-MEAN sched_debug.cfs_rq[21]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3478 ± 17%    +117.2%       7555 ± 28%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     870275 ±  1%     -13.3%     754578 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      55021           +37.2%      75505        GEO-MEAN sched_debug.cpu#36.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9062 ± 23%     -32.3%       6135 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   16827253 ± 13%     +60.0%   26927363 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30468014 ±  1%     -17.2%   25213426 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1668668            -3.6%    1609000        GEO-MEAN sched_debug.cpu#27.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  5%     -30.9%         18 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ±  8%     +32.6%         20 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -4.3%         19        GEO-MEAN sched_debug.cpu#47.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17581 ± 19%     +65.3%      29062 ± 12%  ivb42/hackbench/performance-100%-threads-socket
>     254353 ±  4%     +18.7%     302028 ±  7%  ivb42/hackbench/performance-50%-threads-socket
>      66872           +40.1%      93688        GEO-MEAN proc-vmstat.numa_hint_faults_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13264 ± 35%     +84.1%      24424 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13264           +84.1%      24424        GEO-MEAN sched_debug.cpu#62.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.11 ± 11%     -35.1%       0.72 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.11           -35.1%       0.72        GEO-MEAN perf-profile.cpu-cycles.file_has_perm.selinux_file_permission.security_file_permission.rw_verify_area.vfs_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     526427 ± 23%     +76.6%     929461 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    1394923 ±  0%      -9.3%    1265094 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     856928           +26.5%    1084369        GEO-MEAN sched_debug.cpu#3.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7863 ± 17%     +28.3%      10087 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       7863           +28.3%      10087        GEO-MEAN sched_debug.cfs_rq[16]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7187 ± 14%     +33.6%       9600 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       7187           +33.6%       9600        GEO-MEAN sched_debug.cfs_rq[8]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.53 ± 15%     -37.7%       2.82 ± 32%  ivb42/hackbench/performance-1600%-threads-socket
>       2.57 ±  4%     +13.8%       2.92 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.41           -15.8%       2.87        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     557866 ± 23%     +80.5%    1007189 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      53065 ± 20%     -30.0%      37147 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>    1493710 ±  1%     -10.0%    1344628 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     353619            +4.4%     369158        GEO-MEAN sched_debug.cpu#11.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4063 ± 15%    +107.1%       8413 ± 36%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2179222 ±  5%     +10.1%    2399421 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>     839076 ±  1%     -11.6%     741571 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     195133           +26.3%     246460        GEO-MEAN sched_debug.cpu#41.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9837 ± 32%     +95.8%      19258 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>   17220541 ± 16%     +56.5%   26958322 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30884674 ±  0%     -18.7%   25097824 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1736043           +35.5%    2353134        GEO-MEAN sched_debug.cpu#24.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 28%     +47.7%         21 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>         14           +47.7%         21        GEO-MEAN sched_debug.cpu#45.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 22%     +38.6%         20 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         14           +38.6%         20        GEO-MEAN sched_debug.cfs_rq[23]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  2%     +49.1%         26 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         17           +49.1%         26        GEO-MEAN sched_debug.cpu#9.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 12%     +60.0%         21 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +60.0%         21        GEO-MEAN sched_debug.cpu#18.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 25%     +46.5%         21 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>         14           +46.5%         21        GEO-MEAN sched_debug.cpu#47.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  8%     +44.2%         20 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         14           +44.2%         20        GEO-MEAN sched_debug.cpu#13.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 19%     +64.9%         20 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +64.9%         20        GEO-MEAN sched_debug.cpu#22.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7773 ± 17%     +28.9%      10021 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>       7773           +28.9%      10021        GEO-MEAN sched_debug.cfs_rq[15]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15443 ± 16%     -42.1%       8942 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>    3938792 ±  4%     -14.0%    3386333 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   25580176 ±  0%     -21.8%   19998098 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1158775           -27.0%     846027        GEO-MEAN sched_debug.cpu#14.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9653 ±  9%     -32.9%       6480 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>   26079901 ±  0%     -22.7%   20147877 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     501746           -28.0%     361347        GEO-MEAN sched_debug.cpu#18.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        703 ±  4%     -30.6%        488 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        703           -30.6%        488        GEO-MEAN sched_debug.cfs_rq[44]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2896697 ±  4%     -38.1%    1793407 ± 29%  ivb42/hackbench/performance-1600%-threads-socket
>    1443204 ± 24%     +51.5%    2187058 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>    2044633            -3.1%    1980476        GEO-MEAN sched_debug.cfs_rq[23]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8004 ± 17%     +28.4%      10276 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       8004           +28.4%      10276        GEO-MEAN sched_debug.cfs_rq[22]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8027 ± 18%     +28.8%      10336 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       8027           +28.8%      10336        GEO-MEAN sched_debug.cfs_rq[24]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      32238 ±  4%     -30.6%      22365 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      32238           -30.6%      22365        GEO-MEAN sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4820 ± 11%     -31.9%       3282 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4820           -31.9%       3282        GEO-MEAN sched_debug.cpu#48.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  6%     -39.3%         11 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  6%     +19.0%         23 ±  9%  ivb42/hackbench/performance-100%-threads-socket
>         18           -15.0%         16        GEO-MEAN sched_debug.cfs_rq[28]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8011 ± 17%     +28.6%      10298 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>       8011           +28.6%      10298        GEO-MEAN sched_debug.cfs_rq[23]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      31701 ±  2%     -32.5%      21398 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>      31701           -32.5%      21398        GEO-MEAN sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4167 ± 19%    +107.5%       8648 ± 37%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6235 ± 28%     +44.5%       9006 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>     871725 ±  3%      -9.5%     788740 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      28293           +39.5%      39459        GEO-MEAN sched_debug.cpu#35.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        449 ±  6%     -27.7%        324 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>        449           -27.7%        324        GEO-MEAN sched_debug.cfs_rq[31]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.53 ±  3%     -16.4%       1.28 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       1.53           -16.4%       1.28        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        692 ±  2%     -32.5%        467 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>        692           -32.5%        467        GEO-MEAN sched_debug.cfs_rq[38]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      38613 ± 21%     +52.0%      58679 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>     287269 ±  4%     +32.4%     380327 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>     105320           +41.8%     149389        GEO-MEAN proc-vmstat.numa_hint_faults
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.37 ±  3%     -15.6%       1.15 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.37           -15.6%       1.15        GEO-MEAN perf-profile.cpu-cycles.schedule_user.sysret_careful
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8063 ± 18%     +28.1%      10333 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8063           +28.1%      10333        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7348 ± 15%     +74.3%      12808 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11806551 ± 11%     +55.2%   18329503 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   20314951 ±  0%     -15.6%   17140944 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1207946           +31.7%    1590605        GEO-MEAN sched_debug.cpu#30.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.61 ±  1%     -14.9%       1.37 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.61           -14.9%       1.37        GEO-MEAN perf-profile.cpu-cycles.pick_next_task_fair.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.01 ± 28%     -40.8%       0.60 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.01           -40.8%       0.60        GEO-MEAN perf-profile.cpu-cycles.cmpxchg_double_slab.isra.49.__slab_free.kfree.skb_free_head.skb_release_data
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16941114 ± 11%     +64.1%   27793664 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   31373706 ±  0%     -18.0%   25734789 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   23054404           +16.0%   26744422        GEO-MEAN sched_debug.cpu#33.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.40 ±  2%     -16.1%       1.17 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.40           -16.1%       1.17        GEO-MEAN perf-profile.cpu-cycles.sysret_careful
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.33 ±  2%     -16.4%       1.11 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.33           -16.4%       1.11        GEO-MEAN perf-profile.cpu-cycles.__sched_text_start.schedule_user.sysret_careful
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16927905 ± 11%     +64.2%   27789022 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   31356060 ±  0%     -17.9%   25728656 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   23038932           +16.1%   26739001        GEO-MEAN sched_debug.cpu#33.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10.34 ± 19%     -34.7%       6.75 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       8.89 ± 10%     -30.5%       6.18 ± 21%  ivb42/hackbench/performance-1600%-threads-socket
>       9.59           -32.7%       6.46        GEO-MEAN perf-profile.cpu-cycles.skb_release_all.consume_skb.unix_stream_recvmsg.sock_aio_read.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     677903 ± 23%     +44.6%     980014 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>     677903           +44.6%     980014        GEO-MEAN sched_debug.cpu#35.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        101 ± 17%     +47.5%        149 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>       1868 ± 11%     -23.9%       1421 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>        434            +5.9%        460        GEO-MEAN sched_debug.cfs_rq[1]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        150 ± 28%     +58.0%        237 ± 26%  ivb42/ebizzy/performance-50%-100x-10s
>         84 ±  3%     -25.0%         63 ± 33%  ivb42/hackbench/performance-100%-threads-socket
>        112            +8.9%        122        GEO-MEAN sched_debug.cfs_rq[15]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>          8 ±  7%     +40.0%         11 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         18 ±  5%     -32.7%         12 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         12            -3.0%         11        GEO-MEAN sched_debug.cpu#30.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8083 ± 13%     +78.7%      14442 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6483 ±  9%     -33.4%       4316 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>    2866789 ±  2%     -12.7%    2501832 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>   21661306 ±  0%     -24.2%   16411873 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     238841            -5.8%     224927        GEO-MEAN sched_debug.cpu#14.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4514 ± 18%     +74.5%       7876 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     884715 ±  2%     -11.6%     782521 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      63194           +24.2%      78506        GEO-MEAN sched_debug.cpu#9.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.25 ±  2%     -25.4%       0.93 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.25           -25.4%       0.93        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10616 ± 25%     -38.7%       6506 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   16835397 ± 13%     +60.0%   26932709 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30477512 ±  1%     -17.2%   25229055 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1759527            -6.7%    1641230        GEO-MEAN sched_debug.cpu#27.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8105 ± 18%     +27.2%      10311 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8105           +27.2%      10311        GEO-MEAN sched_debug.cfs_rq[26]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7379 ±  8%     +49.8%      11053 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7379           +49.8%      11053        GEO-MEAN sched_debug.cpu#50.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7697 ± 15%     +70.3%      13108 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8581 ± 15%     +39.8%      11998 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>   11754315 ± 15%     +57.2%   18472436 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   20829936 ±  0%     -17.0%   17279112 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     356612           +32.7%     473344        GEO-MEAN sched_debug.cpu#35.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        444 ± 17%     -27.5%        322 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>        576 ±  4%     -21.6%        452 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>        506           -24.6%        381        GEO-MEAN sched_debug.cfs_rq[25]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8412 ±  5%     -22.9%       6484 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>     536508 ± 25%     +72.1%     923157 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    1406705 ±  1%     -10.8%    1254824 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     185165            +5.8%     195839        GEO-MEAN sched_debug.cpu#0.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 15%     +49.0%         24 ± 20%  ivb42/hackbench/performance-1600%-threads-socket
>         16           +49.0%         24        GEO-MEAN sched_debug.cpu#21.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -33.3%         16 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -33.3%         16        GEO-MEAN sched_debug.cpu#45.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  5%     -28.4%         17 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -28.4%         17        GEO-MEAN sched_debug.cpu#37.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  5%     -28.4%         19 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ±  0%     +35.6%         20 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -1.5%         19        GEO-MEAN sched_debug.cpu#47.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9010 ± 13%     +54.6%      13927 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12233313 ± 17%     +57.5%   19266075 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   22693545 ±  0%     -16.6%   18915402 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1357459           +26.6%    1718539        GEO-MEAN sched_debug.cpu#11.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7218 ± 19%     +42.0%      10253 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7218           +42.0%      10253        GEO-MEAN sched_debug.cpu#55.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4577 ± 13%     +92.1%       8792 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4497 ± 47%     -45.5%       2450 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>     869234 ±  1%     -10.1%     781750 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      26155            -2.0%      25632        GEO-MEAN sched_debug.cpu#3.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13499 ± 34%     +77.7%      23993 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13499           +77.7%      23993        GEO-MEAN sched_debug.cpu#74.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7502 ± 13%     +47.8%      11086 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11693700 ± 14%     +57.5%   18413834 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   20020943 ±  0%     -14.5%   17120192 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1206550           +25.8%    1517548        GEO-MEAN sched_debug.cpu#33.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        571 ±  9%     -35.9%        366 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>        569 ± 13%     -15.7%        480 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>        570           -26.5%        419        GEO-MEAN sched_debug.cfs_rq[40]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8128 ± 18%     +27.0%      10320 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8128           +27.0%      10320        GEO-MEAN sched_debug.cfs_rq[27]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4417 ± 13%     -19.8%       3540 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       5065 ± 16%     -17.6%       4173 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>     515138 ± 26%     +78.8%     921170 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    1423158 ±  1%     -10.2%    1278070 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      63641            +1.5%      64581        GEO-MEAN sched_debug.cpu#4.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15390 ± 12%     +34.2%      20648 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      12822 ± 23%     +79.5%      23018 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>   30316596 ±  1%     -18.8%   24607293 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     181538           +25.0%     226989        GEO-MEAN sched_debug.cpu#39.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ± 10%     -34.5%         12 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -34.5%         12        GEO-MEAN sched_debug.cpu#28.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     -27.6%         14 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -27.6%         13        GEO-MEAN sched_debug.cpu#30.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4118 ± 12%     -21.6%       3229 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     541605 ± 22%     +73.4%     939202 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>    1440886 ±  0%     -10.0%    1296355 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     147577            +6.9%     157827        GEO-MEAN sched_debug.cpu#6.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3158 ±  7%     -18.3%       2580 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      71506 ± 21%     -47.2%      37754 ± 19%  ivb42/hackbench/performance-1600%-threads-socket
>    1423709 ±  0%     -15.8%    1198274 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      68507           -28.7%      48874        GEO-MEAN sched_debug.cpu#17.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7156 ± 13%     +31.9%       9438 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       7156           +31.9%       9438        GEO-MEAN sched_debug.cfs_rq[7]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8153 ± 18%     +26.4%      10309 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8153           +26.4%      10309        GEO-MEAN sched_debug.cfs_rq[29]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5419 ± 22%     +54.4%       8369 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     895578 ±  2%     -11.5%     792265 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      69665           +16.9%      81429        GEO-MEAN sched_debug.cpu#11.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8153 ± 18%     +26.5%      10314 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8153           +26.5%      10314        GEO-MEAN sched_debug.cfs_rq[28]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        580 ± 12%     -38.0%        359 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        580           -38.0%        359        GEO-MEAN sched_debug.cfs_rq[38]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -33.8%         15 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         22 ± 15%     -26.9%         16 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -30.4%         15        GEO-MEAN sched_debug.cfs_rq[46]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15444360 ± 11%     +61.0%   24864698 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26710729 ±  1%     -19.1%   21602428 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20310837           +14.1%   23176234        GEO-MEAN sched_debug.cpu#9.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4500 ± 12%     -25.2%       3366 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4500           -25.2%       3366        GEO-MEAN sched_debug.cpu#49.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1525 ± 18%     +48.7%       2268 ± 32%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1525           +48.7%       2267        GEO-MEAN sched_debug.cpu#86.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10770 ±  9%     +50.5%      16213 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12271585 ± 16%     +57.9%   19381310 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   22662241 ±  0%     -15.3%   19188484 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1441472           +26.3%    1820131        GEO-MEAN sched_debug.cpu#3.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8113 ± 19%     +26.9%      10296 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8112           +26.9%      10296        GEO-MEAN sched_debug.cfs_rq[30]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4302 ± 21%     +71.4%       7373 ± 25%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4302           +71.4%       7373        GEO-MEAN sched_debug.cpu#92.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8951 ± 23%     +48.3%      13272 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12573544 ± 11%     +53.2%   19263201 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   22458882 ±  0%     -16.7%   18703491 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1362194           +23.7%    1684742        GEO-MEAN sched_debug.cpu#10.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8998 ± 21%     +54.1%      13866 ± 15%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12201362 ± 16%     +58.9%   19384000 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   22476314 ±  1%     -16.3%   18802789 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1351324           +27.0%    1716118        GEO-MEAN sched_debug.cpu#7.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8190 ± 20%     +25.3%      10261 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8189           +25.3%      10261        GEO-MEAN sched_debug.cfs_rq[36]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4014 ±  9%    +119.8%       8826 ± 27%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2434032 ±  0%      -8.9%    2217954 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>     873433 ±  1%     -15.8%     735098 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     204361           +19.0%     243231        GEO-MEAN sched_debug.cpu#12.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8250 ± 21%     +24.5%      10271 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8250           +24.5%      10271        GEO-MEAN sched_debug.cfs_rq[37]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8.05 ±  2%     -12.5%       7.04 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       8.05           -12.5%       7.04        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17308722 ± 16%     +55.8%   26962813 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30891431 ±  0%     -18.7%   25116019 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   23123391           +12.5%   26023038        GEO-MEAN sched_debug.cpu#24.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8184 ± 20%     +25.3%      10254 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8184           +25.3%      10254        GEO-MEAN sched_debug.cfs_rq[35]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8129 ± 19%     +26.5%      10286 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8128           +26.5%      10285        GEO-MEAN sched_debug.cfs_rq[31]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8182 ± 20%     +25.2%      10245 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8182           +25.2%      10245        GEO-MEAN sched_debug.cfs_rq[34]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   12346526 ± 13%     +58.9%   19614719 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   22483652 ±  1%     -15.0%   19119883 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   16661182           +16.2%   19365720        GEO-MEAN sched_debug.cpu#1.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8144 ± 19%     +26.1%      10267 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8144           +26.1%      10267        GEO-MEAN sched_debug.cfs_rq[32]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8166 ± 19%     +25.7%      10263 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8166           +25.7%      10263        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17017865 ± 12%     +60.8%   27370190 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   30325190 ±  1%     -17.1%   25139575 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   22717174           +15.5%   26231183        GEO-MEAN sched_debug.cpu#26.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        165 ± 25%     +54.9%        256 ± 24%  ivb42/ebizzy/performance-50%-100x-10s
>        103 ±  2%     -18.7%         84 ± 23%  ivb42/hackbench/performance-100%-threads-socket
>        130           +12.2%        146        GEO-MEAN sched_debug.cfs_rq[15]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5106 ± 26%     +49.5%       7632 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     860018 ±  2%     -10.0%     773781 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      66269           +16.0%      76847        GEO-MEAN sched_debug.cpu#4.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8251 ± 21%     +24.4%      10265 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8250           +24.4%      10265        GEO-MEAN sched_debug.cfs_rq[38]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15824219 ± 12%     +54.9%   24515228 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   26226903 ±  1%     -17.9%   21539753 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20372046           +12.8%   22979381        GEO-MEAN sched_debug.cpu#8.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  4%     -27.8%         19 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -27.8%         18        GEO-MEAN sched_debug.cpu#38.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  3%     -29.5%         18 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -29.5%         18        GEO-MEAN sched_debug.cpu#45.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  4%     -29.1%         18 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -29.1%         18        GEO-MEAN sched_debug.cpu#38.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7515 ± 11%     +60.0%      12025 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   19963010 ±  1%     -24.1%   15143746 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     387342           +10.2%     426750        GEO-MEAN sched_debug.cpu#37.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      31979 ±  7%     -33.2%      21356 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      31979           -33.2%      21356        GEO-MEAN sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8253 ± 20%     +24.2%      10251 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8253           +24.2%      10251        GEO-MEAN sched_debug.cfs_rq[40]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8250 ± 20%     +24.3%      10256 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8249           +24.3%      10256        GEO-MEAN sched_debug.cfs_rq[39]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5816 ±  9%     -28.7%       4145 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>      28245 ±  7%     -15.0%      24021 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      12817           -22.1%       9979        GEO-MEAN sched_debug.cpu#31.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        698 ±  7%     -33.2%        466 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        698           -33.2%        466        GEO-MEAN sched_debug.cfs_rq[43]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.74 ± 13%     -32.0%       1.86 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       1.01 ± 12%     -30.9%       0.70 ± 22%  ivb42/hackbench/performance-1600%-threads-socket
>       1.67           -31.5%       1.14        GEO-MEAN perf-profile.cpu-cycles.fsnotify.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8277 ± 20%     +23.8%      10249 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       8277           +23.8%      10249        GEO-MEAN sched_debug.cfs_rq[41]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        415 ±  7%     -25.6%        309 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>        415           -25.6%        309        GEO-MEAN sched_debug.cfs_rq[26]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      32646 ±  5%     -27.7%      23597 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>      32646           -27.7%      23596        GEO-MEAN sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 22%     +77.1%         20 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ±  8%     +27.3%         18 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +50.2%         19        GEO-MEAN sched_debug.cpu#19.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        445 ±  6%     -33.1%        297 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        444           -33.1%        297        GEO-MEAN sched_debug.cfs_rq[28]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17189411 ± 12%     +57.7%   27104451 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30533255 ±  0%     -17.4%   25208231 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   22909576           +14.1%   26139152        GEO-MEAN sched_debug.cpu#25.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8318 ± 19%     +23.1%      10244 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       8318           +23.1%      10244        GEO-MEAN sched_debug.cfs_rq[42]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7466 ±  7%     +90.2%      14197 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2928574 ±  0%     -13.5%    2534027 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   21686213 ±  1%     -24.5%   16369380 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     779786            +7.5%     838210        GEO-MEAN sched_debug.cpu#12.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8318 ± 19%     +23.2%      10246 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       8318           +23.2%      10246        GEO-MEAN sched_debug.cfs_rq[44]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8320 ± 19%     +23.1%      10246 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       8320           +23.1%      10246        GEO-MEAN sched_debug.cfs_rq[43]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16126 ± 14%     +50.1%      24205 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   25625064 ±  1%     -21.6%   20086187 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     642837            +8.5%     697279        GEO-MEAN sched_debug.cpu#13.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ± 10%     -20.0%         16 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>         17 ± 17%     +43.4%         25 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>         18            +7.1%         20        GEO-MEAN sched_debug.cpu#16.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ± 12%     +27.5%         21 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         17           +27.5%         21        GEO-MEAN sched_debug.cpu#7.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        713 ±  5%     -27.7%        515 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        713           -27.7%        515        GEO-MEAN sched_debug.cfs_rq[47]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10961 ± 27%     +79.4%      19666 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      10961           +79.4%      19666        GEO-MEAN sched_debug.cpu#70.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8319 ± 19%     +23.0%      10235 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>       8319           +23.0%      10235        GEO-MEAN sched_debug.cfs_rq[45]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        659 ±  4%     -32.2%        447 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        659           -32.2%        447        GEO-MEAN sched_debug.cfs_rq[42]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7304 ± 19%     -41.4%       4277 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>      24956 ±  4%     +17.6%      29349 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>      13501           -17.0%      11204        GEO-MEAN sched_debug.cpu#40.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4189 ± 12%     +44.5%       6051 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4189           +44.5%       6051        GEO-MEAN sched_debug.cpu#110.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  4%     -24.7%         19 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         13 ± 26%     +48.8%         20 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         18            +5.9%         19        GEO-MEAN sched_debug.cpu#40.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.93 ± 40%     +62.9%       1.51 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       1.48 ±  4%     -23.7%       1.13 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.17           +11.5%       1.31        GEO-MEAN perf-profile.cpu-cycles.__switch_to
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17279000 ± 12%     +56.0%   26953707 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30917867 ±  0%     -16.9%   25707653 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   23113412           +13.9%   26323308        GEO-MEAN sched_debug.cpu#31.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17290091 ± 12%     +55.9%   26954969 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30924268 ±  0%     -16.8%   25716265 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   23123222           +13.9%   26328333        GEO-MEAN sched_debug.cpu#31.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.45 ±  1%     -11.6%       3.93 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.45           -11.6%       3.93        GEO-MEAN perf-profile.cpu-cycles.deactivate_task.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8326 ± 19%     +22.7%      10215 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8325           +22.7%      10215        GEO-MEAN sched_debug.cfs_rq[46]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30211 ±  4%     -32.2%      20486 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>      30211           -32.2%      20486        GEO-MEAN sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8319 ± 19%     +22.6%      10197 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>       8319           +22.6%      10197        GEO-MEAN sched_debug.cfs_rq[47]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   11644496 ± 13%     +56.4%   18216544 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   20618809 ±  0%     -15.7%   17385264 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   15495020           +14.9%   17796051        GEO-MEAN sched_debug.cpu#27.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ±  6%     -12.1%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         22           -12.1%         19        GEO-MEAN sched_debug.cfs_rq[2]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 19%     +62.2%         20 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +62.2%         19        GEO-MEAN sched_debug.cpu#22.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ± 10%     -28.6%         15 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -28.6%         15        GEO-MEAN sched_debug.cfs_rq[37]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ± 10%     -28.6%         15 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -28.6%         15        GEO-MEAN sched_debug.cfs_rq[37]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  8%     +41.9%         20 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         14           +41.9%         20        GEO-MEAN sched_debug.cpu#13.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7383 ± 19%     -44.1%       4124 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>      28557 ±  8%     -17.7%      23506 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      14050 ±  2%      -9.9%      12664 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>      14361           -25.4%      10708        GEO-MEAN sched_debug.cpu#47.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   12348995 ± 14%     +57.9%   19497335 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   22509799 ±  0%     -15.2%   19080882 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   16672534           +15.7%   19287984        GEO-MEAN sched_debug.cpu#2.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   11773827 ± 11%     +57.4%   18530291 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   20534273 ±  1%     -15.8%   17284516 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   15548857           +15.1%   17896567        GEO-MEAN sched_debug.cpu#25.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3689 ± 19%     -24.3%       2792 ± 15%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3689           -24.3%       2792        GEO-MEAN sched_debug.cpu#84.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        282 ± 18%     +31.4%        371 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>        396 ± 13%     -25.1%        297 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>        334            -0.8%        331        GEO-MEAN sched_debug.cfs_rq[21]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4740 ± 21%    +118.4%      10349 ± 36%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     879602 ±  1%     -11.5%     778421 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      64570           +39.0%      89758        GEO-MEAN sched_debug.cpu#8.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8032 ± 16%     -22.5%       6222 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>   19455420 ±  1%     -24.4%   14708872 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     395321           -23.5%     302520        GEO-MEAN sched_debug.cpu#44.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  6%     -20.5%         19 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         12 ± 20%     +64.9%         20 ± 12%  ivb42/hackbench/performance-1600%-threads-socket
>         17           +14.5%         19        GEO-MEAN sched_debug.cpu#40.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9375 ± 20%     +44.3%      13529 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12271244 ± 12%     +58.5%   19451933 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   22069167 ±  0%     -15.4%   18674407 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1364251           +24.6%    1700184        GEO-MEAN sched_debug.cpu#6.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 29%     +70.6%         19 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ± 10%     +35.7%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         12           +52.2%         19        GEO-MEAN sched_debug.cpu#19.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7230 ± 16%     +54.3%      11153 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   19641786 ±  1%     -23.5%   15029146 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     376857            +8.6%     409421        GEO-MEAN sched_debug.cpu#42.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        356 ± 10%     +46.9%        524 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        356           +46.9%        523        GEO-MEAN sched_debug.cfs_rq[16]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6454 ±  7%     +69.5%      10937 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11434344 ± 12%     +60.0%   18296120 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    2575345 ±  6%      +8.9%    2805431 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>   19897448 ±  1%     -15.2%   16867976 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1394542           +25.8%    1754235        GEO-MEAN sched_debug.cpu#29.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        159 ± 23%     -40.4%         95 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>        608 ±  3%     -28.7%        433 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>        311           -34.8%        203        GEO-MEAN cpuidle.POLL.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        427 ±  1%     -29.0%        303 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        594 ±  7%     -24.0%        451 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>        503           -26.6%        369        GEO-MEAN sched_debug.cfs_rq[27]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16367 ± 10%     +46.5%      23982 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>      16367           +46.5%      23982        GEO-MEAN sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1855 ±  5%     -10.7%       1657 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      10787 ± 17%     -48.1%       5597 ± 21%  ivb42/hackbench/performance-1600%-threads-socket
>      26923 ±  2%     +29.2%      34786 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       8137           -15.7%       6859        GEO-MEAN cpuidle.C3-IVT.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2377 ± 28%     +37.8%       3275 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2377           +37.8%       3275        GEO-MEAN sched_debug.cpu#106.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7152 ± 13%     +30.1%       9305 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>       7152           +30.1%       9305        GEO-MEAN sched_debug.cfs_rq[6]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        639 ±  3%     -28.1%        459 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        639           -28.1%        459        GEO-MEAN sched_debug.cfs_rq[39]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  3%     -29.1%         18 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -29.1%         18        GEO-MEAN sched_debug.cpu#45.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1371 ± 11%     +35.6%       1860 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1371           +35.6%       1859        GEO-MEAN sched_debug.cfs_rq[89]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      29270 ±  3%     -28.1%      21048 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      29270           -28.1%      21048        GEO-MEAN sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      66373 ± 13%     -23.6%      50702 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      66373           -23.6%      50702        GEO-MEAN slabinfo.kmalloc-256.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        742 ± 14%     -28.3%        532 ± 19%  ivb42/hackbench/performance-100%-threads-socket
>        742           -28.3%        532        GEO-MEAN slabinfo.xfs_buf.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 12%     -30.0%         11 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         16           -30.0%         11        GEO-MEAN sched_debug.cfs_rq[30]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ±  4%     +48.6%         17 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         11           +48.6%         17        GEO-MEAN sched_debug.cpu#14.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        742 ± 14%     -28.3%        532 ± 19%  ivb42/hackbench/performance-100%-threads-socket
>        742           -28.3%        532        GEO-MEAN slabinfo.xfs_buf.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 12%     -28.0%         12 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         16           -28.0%         12        GEO-MEAN sched_debug.cfs_rq[30]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  2%     -28.8%         12 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         17           -28.8%         12        GEO-MEAN sched_debug.cpu#27.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      67758 ± 12%     -23.5%      51824 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      67758           -23.5%      51824        GEO-MEAN slabinfo.kmalloc-512.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3881 ±  8%     -27.8%       2802 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3881           -27.8%       2802        GEO-MEAN sched_debug.cpu#55.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15720685 ± 11%     +52.2%   23926629 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   26008985 ±  0%     -17.3%   21498163 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20220758           +12.2%   22679915        GEO-MEAN sched_debug.cpu#7.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  6%     -39.3%         11 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         18 ±  2%     +14.3%         21 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         18           -16.7%         15        GEO-MEAN sched_debug.cfs_rq[28]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15728389 ± 11%     +52.2%   23931307 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   26021354 ±  0%     -17.3%   21510179 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20230521           +12.1%   22688470        GEO-MEAN sched_debug.cpu#7.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17210 ±  9%     +40.2%      24126 ± 22%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      13814 ± 10%     -38.5%       8490 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>    3917354 ±  4%     -13.8%    3376712 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   25569796 ±  0%     -21.9%   19978756 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     392839           -12.7%     342859        GEO-MEAN sched_debug.cpu#14.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4133 ±  5%     -28.8%       2941 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4133           -28.8%       2941        GEO-MEAN sched_debug.cpu#51.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15414448 ± 10%     +53.7%   23690369 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   25437824 ±  0%     -19.0%   20602002 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   19801767           +11.6%   22092284        GEO-MEAN sched_debug.cpu#1.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        683 ±  3%     -27.8%        493 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        683           -27.8%        493        GEO-MEAN sched_debug.cfs_rq[45]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     654510 ± 16%     +17.7%     770657 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>    2295224 ± 23%     -35.1%    1489091 ± 45%  ivb42/hackbench/performance-1600%-threads-socket
>    1225662           -12.6%    1071251        GEO-MEAN sched_debug.cfs_rq[12]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  5%     -26.8%         17 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -26.8%         17        GEO-MEAN sched_debug.cpu#37.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  6%     -23.2%         17 ± 23%  ivb42/ebizzy/performance-50%-100x-10s
>         23           -23.2%         17        GEO-MEAN sched_debug.cpu#43.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.01 ±  2%     -18.4%       2.46 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.01           -18.4%       2.46        GEO-MEAN perf-profile.cpu-cycles.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.91 ±  1%     -14.3%       3.35 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.91           -14.3%       3.35        GEO-MEAN perf-profile.cpu-cycles.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start.schedule
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        670 ±  5%     -30.2%        468 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        670           -30.2%        468        GEO-MEAN sched_debug.cfs_rq[36]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30700 ±  5%     -30.1%      21472 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      30700           -30.1%      21472        GEO-MEAN sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5171 ± 12%     +78.1%       9208 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     883237 ±  2%     -11.9%     777826 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      67586           +25.2%      84633        GEO-MEAN sched_debug.cpu#1.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.46 ±  1%     -11.2%       3.96 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.46           -11.2%       3.96        GEO-MEAN perf-profile.cpu-cycles.dequeue_task.deactivate_task.__sched_text_start.schedule.schedule_timeout
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.89 ± 15%     -27.1%       2.11 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>       0.95 ± 12%     -29.1%       0.67 ± 19%  ivb42/hackbench/performance-1600%-threads-socket
>       1.66           -28.1%       1.19        GEO-MEAN perf-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_read.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17777759 ± 10%     +54.6%   27486266 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   31354076 ±  0%     -16.7%   26120882 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   23609430           +13.5%   26794878        GEO-MEAN sched_debug.cpu#34.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  6%     -21.3%         19 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         13 ± 24%     +55.0%         20 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>         18           +10.4%         20        GEO-MEAN sched_debug.cpu#40.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11475 ± 31%     +79.7%      20626 ± 31%  ivb42/ebizzy/performance-50%-100x-10s
>   16828977 ± 15%     +61.6%   27191839 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    3191735 ±  2%      +7.9%    3442470 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>   30929790 ±  1%     -16.7%   25766295 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    2089584           +27.1%    2655802        GEO-MEAN sched_debug.cpu#32.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        580 ± 12%     -38.8%        355 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>        582 ±  4%     -14.7%        496 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>        581           -27.7%        419        GEO-MEAN sched_debug.cfs_rq[47]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16557 ±  8%     +45.9%      24152 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   30196745 ±  1%     -19.4%   24347741 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     707088            +8.5%     766845        GEO-MEAN sched_debug.cpu#41.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16853 ± 13%     +58.8%      26761 ± 27%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15740913 ± 12%     +55.7%   24510192 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   26216240 ±  1%     -17.9%   21529356 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1908802           +26.6%    2417111        GEO-MEAN sched_debug.cpu#8.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15445 ± 10%     +48.8%      22974 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   17102719 ± 11%     +59.6%   27293530 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>   30424082 ±  0%     -16.8%   25305405 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2003042           +25.5%    2512898        GEO-MEAN sched_debug.cpu#30.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5615 ± 23%     -32.3%       3801 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>      27987 ±  9%     -16.0%      23509 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      14093 ±  3%      -9.5%      12748 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>      13035           -19.9%      10444        GEO-MEAN sched_debug.cpu#25.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4417 ± 20%     +65.5%       7308 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     859082 ±  1%     -12.0%     756012 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      61602           +20.7%      74332        GEO-MEAN sched_debug.cpu#37.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1814 ±  9%     -24.7%       1365 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1814           -24.7%       1365        GEO-MEAN sched_debug.cpu#112.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15485508 ± 11%     +52.3%   23577239 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25532967 ±  1%     -18.3%   20857796 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   19884441           +11.5%   22175871        GEO-MEAN sched_debug.cpu#4.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.09 ±  9%     -28.2%       0.78 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       1.09           -28.2%       0.78        GEO-MEAN perf-profile.cpu-cycles.file_has_perm.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 24%     +66.7%         20 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ±  6%     +30.2%         18 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +47.3%         19        GEO-MEAN sched_debug.cpu#19.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 24%     +72.2%         20 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ±  8%     +27.3%         18 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +48.1%         19        GEO-MEAN sched_debug.cpu#19.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22705 ±  8%     +31.3%      29822 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      22705           +31.3%      29822        GEO-MEAN sched_debug.cpu#20.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   11363979 ± 12%     +60.6%   18249720 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   19520181 ±  0%     -14.6%   16662350 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   14893855           +17.1%   17437982        GEO-MEAN sched_debug.cpu#28.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  4%     -26.0%         19 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         13 ± 26%     +46.3%         20 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         18            +4.1%         19        GEO-MEAN sched_debug.cpu#40.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        304 ± 10%     +29.8%        394 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>        304           +29.8%        394        GEO-MEAN sched_debug.cfs_rq[18]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16225534 ± 12%     +54.3%   25043461 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26692010 ±  0%     -17.7%   21973527 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20810865           +12.7%   23458328        GEO-MEAN sched_debug.cpu#11.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14.75 ± 19%     -32.9%       9.90 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      11.09 ± 10%     -26.9%       8.11 ± 18%  ivb42/hackbench/performance-1600%-threads-socket
>      12.79           -30.0%       8.96        GEO-MEAN perf-profile.cpu-cycles.consume_skb.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 10%     -13.4%         19 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         12 ± 20%     +64.9%         20 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>         16           +19.5%         19        GEO-MEAN sched_debug.cpu#40.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16292415 ±  7%     +51.7%   24718068 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26524961 ±  0%     -17.8%   21793394 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20788354           +11.6%   23209709        GEO-MEAN sched_debug.cpu#10.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12271 ± 32%     -43.2%       6968 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>   26295715 ±  1%     -21.6%   20610286 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     568052           -33.3%     378971        GEO-MEAN sched_debug.cpu#21.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17232 ± 12%     +26.9%      21875 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15433879 ± 11%     +61.1%   24860000 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26700103 ±  1%     -19.1%   21595767 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1922116           +18.3%    2273040        GEO-MEAN sched_debug.cpu#9.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16303455 ±  7%     +51.7%   24728475 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26544024 ±  0%     -17.7%   21833203 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20802867           +11.7%   23235787        GEO-MEAN sched_debug.cpu#10.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4411 ± 14%     +97.3%       8701 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2197327 ±  3%     +12.1%    2463596 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>     863764 ±  1%      -9.4%     782356 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     203052           +26.1%     255965        GEO-MEAN sched_debug.cpu#5.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ±  6%     -10.6%         19 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         22           -10.6%         19        GEO-MEAN sched_debug.cpu#2.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8018 ± 15%     +33.6%      10715 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       5953 ± 21%     +74.9%      10412 ± 25%  ivb42/ebizzy/performance-50%-100x-10s
>   11483246 ± 13%     +60.7%   18459096 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   20008939 ±  0%     -15.6%   16896437 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     323617           +33.5%     431905        GEO-MEAN sched_debug.cpu#32.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17533 ± 13%     +34.5%      23588 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      17533           +34.5%      23587        GEO-MEAN sched_debug.cpu#58.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -29.9%         18 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -29.9%         17        GEO-MEAN sched_debug.cpu#45.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  5%     -24.4%         19 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>         26           -24.4%         19        GEO-MEAN sched_debug.cpu#38.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  4%     -30.3%         17 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -30.3%         17        GEO-MEAN sched_debug.cpu#37.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -29.3%         17 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -29.3%         17        GEO-MEAN sched_debug.cpu#39.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -28.0%         18 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -28.0%         17        GEO-MEAN sched_debug.cpu#37.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        435 ±  8%     -31.4%        298 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        349 ±  3%     +31.1%        458 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>        390            -5.2%        369        GEO-MEAN sched_debug.cfs_rq[33]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7143 ± 13%     +27.8%       9131 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>       7143           +27.8%       9131        GEO-MEAN sched_debug.cfs_rq[5]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15737422 ± 12%     +50.4%   23663020 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   25599960 ±  0%     -19.5%   20605928 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20071806           +10.0%   22081632        GEO-MEAN sched_debug.cpu#0.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3865 ± 14%     +66.8%       6448 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     865949 ±  2%      -8.8%     789915 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      57856           +23.4%      71367        GEO-MEAN sched_debug.cpu#33.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4097 ± 15%     -28.2%       2941 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>      78671 ± 26%     -48.2%      40787 ± 29%  ivb42/hackbench/performance-1600%-threads-socket
>    1472841 ±  1%     -15.7%    1241382 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      78013           -32.1%      53004        GEO-MEAN sched_debug.cpu#21.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        108 ± 29%     +74.5%        189 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>        108           +74.5%        189        GEO-MEAN sched_debug.cfs_rq[11]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        459 ±  8%     -30.6%        318 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        611 ± 12%     -19.3%        493 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>        529           -25.2%        396        GEO-MEAN sched_debug.cfs_rq[34]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        321 ± 11%     +34.5%        432 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        652 ±  5%     -21.2%        514 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>        457            +3.0%        471        GEO-MEAN sched_debug.cfs_rq[17]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -36.2%         14 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         13 ± 24%     +48.8%         20 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>         17            -2.6%         17        GEO-MEAN sched_debug.cfs_rq[40]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        659 ± 14%     -23.4%        505 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>        659           -23.4%        505        GEO-MEAN sched_debug.cfs_rq[1]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1850 ± 11%     -21.4%       1454 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1850           -21.4%       1454        GEO-MEAN sched_debug.cpu#116.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      18037 ± 11%     -30.9%      12471 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>   25682384 ±  0%     -22.1%   20009219 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     680612           -26.6%     499548        GEO-MEAN sched_debug.cpu#15.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      21409 ±  6%     +31.4%      28140 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15408401 ± 10%     +53.7%   23680354 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   25429518 ±  0%     -19.0%   20597694 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    2031902           +17.8%    2394291        GEO-MEAN sched_debug.cpu#1.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3985 ±  2%     -26.7%       2920 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3985           -26.7%       2920        GEO-MEAN sched_debug.cpu#52.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     207498 ± 12%     +26.5%     262500 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     207498           +26.5%     262500        GEO-MEAN sched_debug.cfs_rq[23]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16654 ± 13%     +48.5%      24724 ± 24%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      16868 ± 22%     +37.9%      23264 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>   17534415 ± 14%     +61.2%   28267329 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    3492372 ±  3%      -9.1%    3175249 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   31557915 ±  0%     -16.4%   26383001 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     885007           +20.2%    1063749        GEO-MEAN sched_debug.cpu#35.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30.79 ± 15%     +35.8%      41.81 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>      30.79           +35.8%      41.81        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.prepare_to_wait.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5061398 ± 12%     +26.5%    6402439 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    5061398           +26.5%    6402439        GEO-MEAN sched_debug.cfs_rq[23]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15520997 ±  9%     +52.7%   23705723 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25252993 ±  1%     -18.0%   20700339 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   19797768           +11.9%   22152122        GEO-MEAN sched_debug.cpu#2.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15518742 ±  9%     +52.7%   23702598 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25242747 ±  1%     -18.0%   20695565 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   19792313           +11.9%   22148107        GEO-MEAN sched_debug.cpu#2.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5733 ± 13%     -39.4%       3474 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>      27414 ±  7%      -9.0%      24942 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      12537           -25.7%       9309        GEO-MEAN sched_debug.cpu#28.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   12027700 ± 13%     +51.3%   18194381 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   20609132 ±  0%     -15.8%   17362846 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   15744220           +12.9%   17773751        GEO-MEAN sched_debug.cpu#26.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1508175 ± 18%     +37.7%    2076043 ± 16%  ivb42/hackbench/performance-50%-threads-socket
>    1508175           +37.7%    2076043        GEO-MEAN sched_debug.cfs_rq[21]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.82 ±  8%     +39.7%       1.15 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      14.75 ±  1%     -12.6%      12.89 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.48           +10.5%       3.85        GEO-MEAN perf-profile.cpu-cycles.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 22%     -31.0%         16 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ± 17%     +33.3%         18 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>         18            -4.1%         17        GEO-MEAN sched_debug.cpu#39.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4047900 ±  7%     -26.6%    2971876 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4047900           -26.6%    2971876        GEO-MEAN sched_debug.cfs_rq[84]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      31.10 ± 14%     +35.4%      42.10 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>      31.10           +35.4%      42.10        GEO-MEAN perf-profile.cpu-cycles.prepare_to_wait.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        558 ±  6%     -31.9%        380 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>        558           -31.9%        380        GEO-MEAN sched_debug.cfs_rq[36]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3145 ± 10%     +71.0%       5380 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2258112 ±  4%     +10.3%    2489655 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      84279           +37.3%     115738        GEO-MEAN sched_debug.cpu#29.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.82 ±  7%     +39.0%       1.14 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      14.50 ±  1%     -13.3%      12.57 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       3.45            +9.8%       3.79        GEO-MEAN perf-profile.cpu-cycles.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.09 ± 13%     -35.3%       0.70 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.09           -35.3%       0.70        GEO-MEAN perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16175 ± 14%     +26.8%      20509 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      16174           +26.8%      20509        GEO-MEAN numa-vmstat.node1.numa_other
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9151 ± 13%     +36.5%      12495 ± 21%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   11781359 ± 14%     +55.6%   18330287 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   20626695 ±  0%     -16.6%   17207030 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1305291           +21.0%    1579580        GEO-MEAN sched_debug.cpu#31.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15865603 ±  9%     +51.7%   24075127 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25755165 ±  0%     -18.0%   21119793 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20214382           +11.5%   22549095        GEO-MEAN sched_debug.cpu#6.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  1%     -36.1%         17 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ± 13%     +31.9%         20 ± 14%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -8.2%         19        GEO-MEAN sched_debug.cpu#44.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30191 ±  5%     -29.3%      21352 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      30190           -29.3%      21352        GEO-MEAN sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3879 ± 18%     -28.9%       2758 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3879           -28.9%       2758        GEO-MEAN sched_debug.cpu#85.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.88 ±  7%     +37.1%       1.21 ± 22%  ivb42/hackbench/performance-1600%-threads-socket
>      15.05 ±  1%     -11.8%      13.27 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>       3.64           +10.0%       4.00        GEO-MEAN perf-profile.cpu-cycles.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6570 ± 18%     -29.7%       4615 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>       6570           -29.7%       4615        GEO-MEAN sched_debug.cpu#39.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.98 ± 12%     -35.4%       0.63 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>       0.98           -35.4%       0.63        GEO-MEAN perf-profile.cpu-cycles.copy_user_enhanced_fast_string.skb_copy_datagram_from_iovec.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17038360 ± 13%     +58.6%   27029572 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    3294532 ±  6%     +12.7%    3712740 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>   30130205 ±  0%     -16.7%   25101385 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11914465           +14.2%   13606418        GEO-MEAN sched_debug.cpu#29.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   17102761 ± 13%     +58.5%   27104251 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    3297892 ±  6%     +12.6%    3714290 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>   30140313 ±  0%     -16.7%   25115800 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11934845           +14.1%   13623439        GEO-MEAN sched_debug.cpu#29.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5402 ± 18%     -29.1%       3830 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      28528 ±  7%     -14.0%      24532 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      12414           -21.9%       9693        GEO-MEAN sched_debug.cpu#30.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -30.3%         17 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -30.3%         17        GEO-MEAN sched_debug.cpu#42.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        658 ±  5%     -29.2%        466 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        658           -29.2%        466        GEO-MEAN sched_debug.cfs_rq[37]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3422 ± 45%     -50.3%       1702 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>     876946 ±  1%     -16.9%     728531 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      54780           -35.7%      35216        GEO-MEAN sched_debug.cpu#21.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   16891713 ± 15%     +61.0%   27201743 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    3209126 ±  2%      +7.3%    3442495 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>   30944860 ±  1%     -16.7%   25778928 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   11881820           +12.9%   13414617        GEO-MEAN sched_debug.cpu#32.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     737173 ± 24%     +38.4%    1020501 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>     737173           +38.4%    1020501        GEO-MEAN sched_debug.cpu#47.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4139 ± 14%     +27.5%       5277 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>       4138           +27.5%       5277        GEO-MEAN sched_debug.cpu#17.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15354091 ± 12%     +53.0%   23491482 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25405187 ±  1%     -18.1%   20818635 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   19750280           +12.0%   22114714        GEO-MEAN sched_debug.cpu#3.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7724 ± 15%     -46.1%       4160 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>      28134 ±  7%     -12.1%      24727 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      29633 ±  1%      -9.1%      26932 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      14168 ±  3%     -11.3%      12566 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>      17379           -21.4%      13659        GEO-MEAN sched_debug.cpu#44.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.65 ±  0%     +24.0%       2.05 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>      14.53 ±  1%     -12.9%      12.66 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.90            +3.9%       5.09        GEO-MEAN perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14337 ± 13%     -29.1%      10161 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>   26674784 ±  1%     -23.1%   20500535 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     618414           -26.2%     456420        GEO-MEAN sched_debug.cpu#22.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 22%     +74.3%         20 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         18 ±  2%      +7.3%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         14           +36.7%         19        GEO-MEAN sched_debug.cpu#22.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4130334 ±  6%     -28.0%    2974799 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4130334           -28.0%    2974799        GEO-MEAN sched_debug.cfs_rq[76]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        457 ± 16%     -22.1%        356 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        457           -22.1%        356        GEO-MEAN sched_debug.cfs_rq[35]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        575 ±  9%     -23.0%        442 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>        575           -23.0%        442        GEO-MEAN slabinfo.taskstats.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        575 ±  9%     -23.0%        442 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>        575           -23.0%        442        GEO-MEAN slabinfo.taskstats.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4491 ± 18%     +41.5%       6353 ± 16%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4490           +41.5%       6353        GEO-MEAN sched_debug.cpu#56.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7535 ± 13%     -46.5%       4029 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>      14193 ±  2%     -10.5%      12697 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      10341           -30.8%       7152        GEO-MEAN sched_debug.cpu#46.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27484 ±  6%     -21.9%      21460 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      18247 ±  5%     -20.7%      14477 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>   12296466 ± 14%     +60.2%   19704481 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   22444826 ±  1%     -14.2%   19266125 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     609946            -3.9%     586031        GEO-MEAN sched_debug.cpu#0.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6887 ± 20%     -39.9%       4142 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      28082 ±  7%     -11.3%      24899 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      13906           -27.0%      10155        GEO-MEAN sched_debug.cpu#37.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     -22.4%         15 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -22.4%         15        GEO-MEAN sched_debug.cpu#30.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 22%     +46.2%         19 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +46.2%         18        GEO-MEAN sched_debug.cpu#22.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 12%     +45.0%         19 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +45.0%         19        GEO-MEAN sched_debug.cpu#19.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     -23.6%         14 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>         18           -23.6%         13        GEO-MEAN sched_debug.cpu#27.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 10%     +48.7%         19 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +48.7%         19        GEO-MEAN sched_debug.cfs_rq[12]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ±  8%     +32.6%         19 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>         14           +32.6%         18        GEO-MEAN sched_debug.cpu#13.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2742 ± 20%     +28.1%       3514 ±  7%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       6547 ±  8%     -23.8%       4992 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>   21754207 ±  0%     -24.2%   16487812 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      73099            -9.5%      66134        GEO-MEAN sched_debug.cpu#22.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30288 ±  5%     -26.5%      22265 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>      30288           -26.5%      22265        GEO-MEAN sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5.33 ± 18%     -31.2%       3.67 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       3.32 ±  9%     -24.1%       2.52 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       4.21           -27.7%       3.04        GEO-MEAN perf-profile.cpu-cycles.skb_release_data.skb_release_all.consume_skb.unix_stream_recvmsg.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     820452 ±  1%     -14.9%     698371 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     852002 ± 25%     +61.6%    1376769 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>     836078           +17.3%     980559        GEO-MEAN sched_debug.cpu#14.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        661 ±  5%     -26.5%        486 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>        661           -26.5%        485        GEO-MEAN sched_debug.cfs_rq[40]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      81817 ± 11%     -20.4%      65120 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      81817           -20.4%      65120        GEO-MEAN slabinfo.kmalloc-256.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.19 ± 15%     -35.7%       0.76 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       1.19           -35.7%       0.76        GEO-MEAN perf-profile.cpu-cycles.system_call
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1278 ± 11%     -20.4%       1017 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       1277           -20.4%       1017        GEO-MEAN slabinfo.kmalloc-256.active_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1278 ± 11%     -20.4%       1017 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       1277           -20.4%       1017        GEO-MEAN slabinfo.kmalloc-256.num_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4015 ±  9%     -21.6%       3150 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4015           -21.6%       3149        GEO-MEAN sched_debug.cpu#56.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7131 ± 13%     +26.0%       8988 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>       7131           +26.0%       8988        GEO-MEAN sched_debug.cfs_rq[4]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ± 12%     -27.1%         17 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         23           -27.1%         17        GEO-MEAN sched_debug.cpu#29.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ± 14%     +25.5%         23 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         18           +25.5%         23        GEO-MEAN sched_debug.cpu#22.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17505 ± 13%     +35.9%      23793 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15340856 ±  8%     +55.1%   23793350 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    3152835 ±  6%     +16.2%    3662411 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>   25624862 ±  0%     -18.0%   21018684 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2158234           +19.0%    2569348        GEO-MEAN sched_debug.cpu#5.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7005 ± 15%     +70.4%      11936 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2854139 ±  2%      -9.5%    2581771 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   19904854 ±  1%     -24.2%   15083433 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     735560            +5.3%     774626        GEO-MEAN sched_debug.cpu#36.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2119713 ±  9%     -31.4%    1453596 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    1336731 ± 24%     +41.1%    1886101 ± 10%  ivb42/hackbench/performance-50%-threads-socket
>    1683296            -1.6%    1655786        GEO-MEAN sched_debug.cfs_rq[18]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.27 ± 11%     +37.2%       1.75 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>       1.27           +37.2%       1.75        GEO-MEAN perf-profile.cpu-cycles.do_sys_poll.sys_poll.system_call_fastpath.poll.start_thread
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      18892 ±  8%     +39.1%      26286 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15335716 ± 12%     +53.2%   23488460 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   25398742 ±  1%     -18.1%   20807675 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1945080           +20.4%    2342099        GEO-MEAN sched_debug.cpu#3.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1700 ± 11%     -21.1%       1342 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1700           -21.1%       1342        GEO-MEAN sched_debug.cpu#98.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1468667 ± 15%     +43.2%    2102926 ±  9%  ivb42/hackbench/performance-50%-threads-socket
>    1468667           +43.2%    2102926        GEO-MEAN sched_debug.cfs_rq[22]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3913375 ±  5%     -26.5%    2877791 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3913375           -26.5%    2877791        GEO-MEAN sched_debug.cfs_rq[86]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1291 ± 11%     -20.1%       1031 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       1291           -20.1%       1031        GEO-MEAN slabinfo.kmalloc-512.num_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1291 ± 11%     -20.1%       1031 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       1291           -20.1%       1031        GEO-MEAN slabinfo.kmalloc-512.active_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        147 ±  2%     +35.1%        199 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>        147           +35.1%        198        GEO-MEAN sched_debug.cfs_rq[34]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      82655 ± 11%     -20.1%      66035 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      82655           -20.1%      66034        GEO-MEAN slabinfo.kmalloc-512.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12164 ± 25%     +90.9%      23225 ± 38%  ivb42/ebizzy/performance-50%-100x-10s
>   31047087 ±  1%     -19.2%   25085514 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     614554           +24.2%     763289        GEO-MEAN sched_debug.cpu#45.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 23%     -25.5%          7 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         14 ±  6%     +47.7%         21 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12            +4.9%         12        GEO-MEAN sched_debug.cpu#15.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5153 ± 14%     -28.1%       3705 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>      27914 ±  6%     -11.6%      24667 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      11993           -20.3%       9560        GEO-MEAN sched_debug.cpu#26.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.96 ±  6%     +43.2%       1.37 ± 23%  ivb42/hackbench/performance-1600%-threads-socket
>      23.87 ±  1%     -10.7%      21.31 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       4.78           +13.1%       5.40        GEO-MEAN perf-profile.cpu-cycles.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -28.9%         18 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ± 19%     +28.9%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         19            -4.3%         18        GEO-MEAN sched_debug.cpu#39.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        536 ±  8%     -35.4%        346 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>        536 ±  6%     +12.2%        602 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>        536           -14.9%        456        GEO-MEAN sched_debug.cfs_rq[42]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3561 ± 10%     +61.8%       5763 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3561           +61.8%       5763        GEO-MEAN sched_debug.cpu#111.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     291407 ±  4%     +31.7%     383859 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>     291407           +31.7%     383859        GEO-MEAN proc-vmstat.numa_pte_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ± 10%     -37.9%         12 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  0%     +10.5%         21 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         19           -17.2%         15        GEO-MEAN sched_debug.cpu#28.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6197 ± 19%     -21.6%       4858 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>     860253 ±  1%     -13.1%     747838 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      73017           -17.5%      60274        GEO-MEAN sched_debug.cpu#44.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      18668 ± 11%     +22.2%      22817 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   16200259 ± 12%     +54.6%   25039683 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   26676971 ±  0%     -17.7%   21964784 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2005643           +15.9%    2323839        GEO-MEAN sched_debug.cpu#11.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.28 ± 11%     +36.4%       1.75 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>       1.28           +36.4%       1.75        GEO-MEAN perf-profile.cpu-cycles.sys_poll.system_call_fastpath.poll.start_thread
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   15413656 ±  9%     +55.1%   23913955 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    3160285 ±  6%     +15.9%    3664235 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>   25640553 ±  0%     -18.0%   21025853 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   10769274           +13.8%   12259218        GEO-MEAN sched_debug.cpu#5.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7197 ±  9%     +41.0%      10147 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7197           +41.0%      10146        GEO-MEAN sched_debug.cpu#52.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8244 ±  3%     -24.8%       6200 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   17001269 ± 14%     +56.0%   26513630 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   30298989 ±  0%     -17.1%   25132450 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1619381            -0.9%    1604646        GEO-MEAN sched_debug.cpu#28.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   20399319 ±  1%     -24.9%   15320065 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20399319           -24.9%   15320065        GEO-MEAN sched_debug.cpu#47.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        434 ± 11%     -28.6%        310 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        600 ±  6%     -17.5%        495 ± 15%  ivb42/hackbench/performance-100%-threads-socket
>        510           -23.3%        391        GEO-MEAN sched_debug.cfs_rq[30]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        322 ± 14%     +29.0%        415 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        322           +29.0%        415        GEO-MEAN numa-vmstat.node1.nr_page_table_pages
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        518 ±  9%     -26.3%        381 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        517           -26.3%        381        GEO-MEAN sched_debug.cfs_rq[39]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.30 ± 11%     +36.2%       1.77 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>       1.30           +36.2%       1.77        GEO-MEAN perf-profile.cpu-cycles.poll.start_thread
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      16455 ±  9%     +26.0%      20741 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      16455           +26.0%      20741        GEO-MEAN sched_debug.cpu#52.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4239 ± 11%     -28.6%       3026 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4238           -28.6%       3026        GEO-MEAN sched_debug.cpu#50.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3909 ±  5%     -23.9%       2976 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3909           -23.9%       2976        GEO-MEAN sched_debug.cpu#59.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ±  3%     -32.9%         18 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         16 ± 13%     +27.1%         20 ± 12%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -7.7%         19        GEO-MEAN sched_debug.cpu#44.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4027310 ±  6%     -25.3%    3007061 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4027310           -25.3%    3007061        GEO-MEAN sched_debug.cfs_rq[87]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   21955842 ±  1%     -25.2%   16425955 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   21955842           -25.2%   16425955        GEO-MEAN sched_debug.cpu#19.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4086 ± 24%     +62.7%       6648 ± 17%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2265114 ±  5%     +14.0%    2581650 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>     860005 ±  1%     -12.9%     748893 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     199669           +17.3%     234246        GEO-MEAN sched_debug.cpu#42.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   21384750 ±  0%     -24.7%   16103640 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   21384750           -24.7%   16103640        GEO-MEAN sched_debug.cpu#21.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ± 10%     +34.3%         15 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ±  7%     +23.4%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +28.7%         17        GEO-MEAN sched_debug.cfs_rq[16]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     -24.1%         14 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -24.1%         14        GEO-MEAN sched_debug.cpu#27.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     +26.8%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +26.8%         23        GEO-MEAN sched_debug.cpu#7.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.98 ± 15%     -34.1%       0.64 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>       0.98           -34.1%       0.64        GEO-MEAN perf-profile.cpu-cycles.__srcu_read_unlock.fsnotify.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     -20.7%         15 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -20.7%         15        GEO-MEAN sched_debug.cpu#29.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     +25.0%         23 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +25.0%         23        GEO-MEAN sched_debug.cpu#7.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ±  3%     +89.2%         23 ± 35%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ±  7%     +23.4%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         20 ±  4%     -10.7%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>         15           +27.8%         20        GEO-MEAN sched_debug.cpu#16.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1999 ± 13%     -21.2%       1575 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1999           -21.2%       1575        GEO-MEAN sched_debug.cpu#79.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10562 ± 13%     +29.7%      13701 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   12153175 ± 13%     +58.1%   19209563 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>   21278578 ±  0%     -14.0%   18299464 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1397846           +20.8%    1688782        GEO-MEAN sched_debug.cpu#4.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        528 ±  2%     -19.4%        425 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        528           -19.4%        425        GEO-MEAN sched_debug.cfs_rq[31]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     165567 ±  9%     -37.0%     104359 ± 33%  ivb42/ebizzy/performance-50%-100x-10s
>   17557884 ± 14%     +61.0%   28269645 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>    3504314 ±  3%      -9.4%    3175807 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   31570143 ±  0%     -16.4%   26389314 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    4234785            -6.4%    3965367        GEO-MEAN sched_debug.cpu#35.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1287 ± 14%     +28.8%       1658 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>       1287           +28.8%       1658        GEO-MEAN numa-meminfo.node1.PageTables
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        675 ±  0%     -36.7%        427 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        869 ±  5%      +8.4%        942 ±  0%  ivb42/hackbench/performance-1600%-threads-socket
>        766           -17.2%        634        GEO-MEAN sched_debug.cfs_rq[41]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5831 ± 13%     -37.8%       3624 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      27873 ±  4%      -9.6%      25194 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      14332 ±  2%      -9.0%      13045 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      13256           -20.0%      10600        GEO-MEAN sched_debug.cpu#33.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.24 ± 12%     +27.6%       4.13 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3.24           +27.6%       4.13        GEO-MEAN perf-profile.cpu-cycles.clockevents_program_event.tick_program_event.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      30899 ±  0%     -36.6%      19596 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      39777 ±  5%      +8.8%      43276 ±  0%  ivb42/hackbench/performance-1600%-threads-socket
>      35058           -16.9%      29121        GEO-MEAN sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      15605 ±  4%     +52.6%      23814 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3926577 ±  2%     -14.6%    3352124 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>   25785235 ±  0%     -21.6%   20221040 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1164715            +0.7%    1173065        GEO-MEAN sched_debug.cpu#12.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2262327 ± 11%     -25.5%    1684998 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2262327           -25.5%    1684998        GEO-MEAN sched_debug.cfs_rq[20]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24185 ±  2%     -19.4%      19484 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>      24184           -19.4%      19483        GEO-MEAN sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.25 ± 12%     +27.4%       4.14 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3.25           +27.4%       4.14        GEO-MEAN perf-profile.cpu-cycles.tick_program_event.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        117 ± 31%     +53.6%        179 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        117           +53.6%        179        GEO-MEAN sched_debug.cfs_rq[24]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4066351 ±  5%     -25.6%    3025134 ±  3%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4066351           -25.6%    3025134        GEO-MEAN sched_debug.cfs_rq[85]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.92 ± 12%     -33.0%       0.62 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>       0.92           -33.0%       0.62        GEO-MEAN perf-profile.cpu-cycles.system_call_after_swapgs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  9%     -28.3%         12 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  7%     +20.0%         26 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>         19            -7.2%         18        GEO-MEAN sched_debug.cpu#29.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      25356 ±  6%     +13.7%      28842 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   15698679 ± 12%     +50.7%   23654259 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   25587783 ±  0%     -19.5%   20590387 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2167687           +11.3%    2412887        GEO-MEAN sched_debug.cpu#0.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4144596 ±  5%     -26.6%    3041569 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4144596           -26.6%    3041569        GEO-MEAN sched_debug.cfs_rq[75]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   20991987 ±  0%     -24.1%   15929117 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20991987           -24.1%   15929117        GEO-MEAN sched_debug.cpu#20.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   20232670 ±  1%     -24.7%   15244668 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   20232670           -24.7%   15244668        GEO-MEAN sched_debug.cpu#43.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.41 ±  9%     +25.3%       3.02 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       2.41           +25.3%       3.02        GEO-MEAN turbostat.%c1
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        164 ± 10%     +35.2%        221 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>         88 ± 18%     +28.8%        113 ± 11%  ivb42/hackbench/performance-100%-threads-socket
>        120           +31.9%        158        GEO-MEAN sched_debug.cfs_rq[40]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1775 ± 11%     -23.4%       1359 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1775           -23.4%       1359        GEO-MEAN sched_debug.cpu#91.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7155 ± 14%     +42.7%      10211 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2957082 ±  8%     -13.8%    2547856 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>   20091416 ±  0%     -24.4%   15193784 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     751915            -2.4%     733913        GEO-MEAN sched_debug.cpu#38.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     817086 ±  3%     -24.5%     617070 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     817086           -24.5%     617070        GEO-MEAN sched_debug.cpu#18.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7630 ±  9%     +40.3%      10708 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7630           +40.3%      10708        GEO-MEAN sched_debug.cpu#59.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2013 ± 11%     -27.7%       1456 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       2013           -27.7%       1456        GEO-MEAN sched_debug.cpu#110.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        118 ±  4%     -25.1%         88 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>        118           -25.1%         88        GEO-MEAN sched_debug.cpu#8.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   19221661 ±  1%     -23.7%   14665426 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   19221661           -23.7%   14665426        GEO-MEAN sched_debug.cpu#40.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   21058318 ±  1%     -24.2%   15959916 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   21058318           -24.2%   15959916        GEO-MEAN sched_debug.cpu#17.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        126 ± 24%     +63.6%        206 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>        126           +63.6%        206        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        437 ± 11%     -29.6%        308 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        674 ±  5%     -18.6%        548 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>        542           -24.3%        411        GEO-MEAN sched_debug.cfs_rq[29]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     605972 ± 12%     +40.9%     853678 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>     605972           +40.9%     853678        GEO-MEAN sched_debug.cpu#32.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        438 ± 15%     -23.7%        334 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        438           -23.7%        334        GEO-MEAN sched_debug.cfs_rq[32]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  9%     -26.7%         18 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>         24           -26.7%         18        GEO-MEAN sched_debug.cpu#34.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     +29.8%         24 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +29.8%         24        GEO-MEAN sched_debug.cpu#9.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  1%     -30.3%         17 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         25           -30.3%         17        GEO-MEAN sched_debug.cpu#42.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     754687 ± 24%     +34.7%    1016297 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>     754687           +34.7%    1016297        GEO-MEAN sched_debug.cpu#40.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      89908 ±  6%     -13.7%      77620 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>      89907           -13.7%      77619        GEO-MEAN meminfo.DirectMap4k
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4142 ± 20%     +40.9%       5836 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4141           +40.9%       5836        GEO-MEAN sched_debug.cpu#48.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ± 10%     -20.0%         16 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>         19           -20.0%         15        GEO-MEAN sched_debug.cpu#10.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 13%     -24.2%         16 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         22           -24.2%         16        GEO-MEAN sched_debug.cfs_rq[38]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -21.0%         16 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         20           -21.0%         16        GEO-MEAN sched_debug.cpu#1.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  2%     -17.7%         17 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -17.7%         17        GEO-MEAN sched_debug.cpu#31.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4184 ± 24%     +46.1%       6112 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3817 ± 32%     +99.0%       7596 ± 37%  ivb42/ebizzy/performance-50%-100x-10s
>     863792 ±  1%     -10.0%     777585 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      23984           +37.8%      33051        GEO-MEAN sched_debug.cpu#32.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   20748744 ±  1%     -23.7%   15832368 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   20748743           -23.7%   15832368        GEO-MEAN sched_debug.cpu#16.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1771 ±  4%     -23.4%       1357 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1771           -23.4%       1357        GEO-MEAN sched_debug.cpu#108.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1721 ±  5%     -19.8%       1379 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1721           -19.8%       1379        GEO-MEAN sched_debug.cpu#99.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1846 ± 11%     -24.4%       1395 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>       1846           -24.4%       1395        GEO-MEAN sched_debug.cfs_rq[1]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8712 ± 13%     -26.5%       6406 ± 16%  ivb42/ebizzy/performance-50%-100x-10s
>   21896234 ±  0%     -24.2%   16598293 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     436769           -25.3%     326089        GEO-MEAN sched_debug.cpu#15.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        447 ±  8%     -22.1%        348 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>        447           -22.1%        348        GEO-MEAN sched_debug.cfs_rq[3]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4047485 ±  7%     -25.7%    3008163 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4047485           -25.7%    3008163        GEO-MEAN sched_debug.cfs_rq[83]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 13%     +40.5%         17 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +40.5%         17        GEO-MEAN sched_debug.cpu#20.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   26689071 ±  1%     -23.1%   20511407 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   26689071           -23.1%   20511407        GEO-MEAN sched_debug.cpu#22.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5169 ±  9%     -33.3%       3449 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>      28241 ±  8%     -13.3%      24473 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      23285 ±  3%     +24.7%      29036 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>      14153 ±  3%      -9.4%      12817 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      14810           -10.1%      13313        GEO-MEAN sched_debug.cpu#27.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   21264995 ±  1%     -23.6%   16250715 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   21264995           -23.6%   16250715        GEO-MEAN sched_debug.cpu#18.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 10%     -30.0%         11 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  2%     -10.8%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         19           -21.0%         15        GEO-MEAN sched_debug.cfs_rq[29]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5509 ± 19%     -32.6%       3712 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>      28775 ±  7%     -13.1%      24996 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      12590           -23.5%       9632        GEO-MEAN sched_debug.cpu#29.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1755 ± 15%     -28.9%       1247 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1755           -28.9%       1247        GEO-MEAN sched_debug.cpu#107.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.70 ±  8%     +34.0%       0.93 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>       0.70           +34.0%       0.93        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.get_partial_node.__slab_alloc.kmem_cache_alloc_node.__alloc_skb
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.08 ± 19%     -28.2%       2.93 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       4.08           -28.2%       2.93        GEO-MEAN perf-profile.cpu-cycles.kmem_cache_free.kfree_skbmem.consume_skb.unix_stream_recvmsg.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3540 ± 19%     -26.1%       2618 ± 11%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3540           -26.1%       2617        GEO-MEAN sched_debug.cpu#85.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3912740 ±  6%     -23.8%    2982939 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3912740           -23.8%    2982939        GEO-MEAN sched_debug.cfs_rq[81]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2492 ± 17%     -25.8%       1848 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>       2492           -25.8%       1848        GEO-MEAN sched_debug.cfs_rq[3]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4125871 ±  6%     -23.7%    3148724 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4125871           -23.7%    3148724        GEO-MEAN sched_debug.cfs_rq[79]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        511 ±  6%     -18.1%        418 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        511           -18.1%        418        GEO-MEAN sched_debug.cfs_rq[32]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2465 ± 17%     -25.8%       1828 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>       2465           -25.8%       1828        GEO-MEAN sched_debug.cfs_rq[3]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     670477 ± 17%     +42.3%     954251 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>     670477           +42.3%     954251        GEO-MEAN sched_debug.cpu#33.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4.21 ± 19%     -28.1%       3.03 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       4.21           -28.1%       3.03        GEO-MEAN perf-profile.cpu-cycles.kfree_skbmem.consume_skb.unix_stream_recvmsg.sock_aio_read.sock_aio_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 25%     -28.3%          7 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         15 ±  8%     +39.1%         21 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         12            -0.1%         12        GEO-MEAN sched_debug.cpu#15.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        411 ±  8%     -18.8%        334 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        317 ± 10%     +27.8%        405 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>        361            +1.9%        368        GEO-MEAN sched_debug.cfs_rq[24]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ± 11%     -17.2%         17 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>         21           -17.2%         17        GEO-MEAN sched_debug.cpu#6.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   26104071 ±  0%     -22.7%   20165898 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   26104071           -22.7%   20165898        GEO-MEAN sched_debug.cpu#18.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     642767 ±  2%     -23.7%     490470 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     642767           -23.7%     490470        GEO-MEAN sched_debug.cpu#43.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23380 ±  6%     -18.0%      19170 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      23380           -18.0%      19170        GEO-MEAN sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4232 ± 20%     -31.2%       2913 ± 23%  ivb42/ebizzy/performance-50%-100x-10s
>     885971 ±  1%     -17.6%     730417 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      61237           -24.7%      46127        GEO-MEAN sched_debug.cpu#22.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      11923 ± 38%     +84.4%      21984 ± 19%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      11923           +84.4%      21984        GEO-MEAN sched_debug.cpu#69.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5726033 ±  6%     +23.5%    7070171 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>    5726033           +23.5%    7070171        GEO-MEAN sched_debug.cfs_rq[10]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.07 ± 12%     +26.5%       3.88 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3.07           +26.5%       3.88        GEO-MEAN perf-profile.cpu-cycles.ktime_get.clockevents_program_event.tick_program_event.hrtimer_interrupt.local_apic_timer_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        167 ±  1%     +29.3%        216 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>        167           +29.3%        216        GEO-MEAN sched_debug.cfs_rq[34]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         29 ± 27%     -32.2%         19 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  7%     +13.3%         22 ±  9%  ivb42/hackbench/performance-100%-threads-socket
>         24           -12.3%         21        GEO-MEAN sched_debug.cpu#15.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        133 ± 27%     +47.9%        197 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        133           +47.9%        197        GEO-MEAN sched_debug.cfs_rq[24]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.81 ± 19%     -28.3%       2.01 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       2.81           -28.3%       2.01        GEO-MEAN perf-profile.cpu-cycles.__slab_free.kmem_cache_free.kfree_skbmem.consume_skb.unix_stream_recvmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4006326 ±  6%     -20.7%    3176947 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4006326           -20.7%    3176947        GEO-MEAN sched_debug.cfs_rq[80]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  4%     -27.6%         18 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ± 17%     +29.5%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         19            -3.2%         18        GEO-MEAN sched_debug.cpu#39.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        490 ±  3%     +21.0%        593 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        490           +21.0%        593        GEO-MEAN sched_debug.cfs_rq[7]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22513 ±  3%     +20.9%      27230 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      22513           +20.9%      27230        GEO-MEAN sched_debug.cfs_rq[7]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17031 ±  9%     +29.9%      22132 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   30527777 ±  1%     -19.2%   24677022 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     721070            +2.5%     739020        GEO-MEAN sched_debug.cpu#37.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ± 11%     -22.6%         13 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>         17           -22.6%         13        GEO-MEAN sched_debug.cpu#30.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     -21.4%         14 ± 11%  ivb42/hackbench/performance-100%-threads-socket
>         18           -21.4%         14        GEO-MEAN sched_debug.cpu#25.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 17%     +35.7%         19 ± 11%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +35.7%         18        GEO-MEAN sched_debug.cpu#21.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 24%     -29.4%          7 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         10           -29.4%          7        GEO-MEAN sched_debug.cfs_rq[15]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +53.7%         21 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  5%     -10.9%         19 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         16 ± 12%     +16.0%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         16           +16.7%         19        GEO-MEAN sched_debug.cpu#16.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3916 ±  5%     -22.3%       3043 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3916           -22.3%       3043        GEO-MEAN sched_debug.cpu#58.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    7138831 ±  1%     -22.1%    5563134 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    7138831           -22.1%    5563134        GEO-MEAN proc-vmstat.pgfree
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  6%     -24.7%         19 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         16 ± 10%     +22.9%         19 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -3.8%         19        GEO-MEAN sched_debug.cpu#36.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  6%     -22.1%         20 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         15 ± 13%     +27.7%         20 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -0.3%         19        GEO-MEAN sched_debug.cpu#36.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    7160822 ±  1%     -22.0%    5584442 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    7160822           -22.0%    5584442        GEO-MEAN proc-vmstat.pgalloc_normal
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4082355 ±  5%     -23.2%    3133632 ±  3%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4082355           -23.2%    3133632        GEO-MEAN sched_debug.cfs_rq[78]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        613 ±  6%     -18.4%        500 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>        613           -18.4%        499        GEO-MEAN sched_debug.cfs_rq[19]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25705305 ±  0%     -22.1%   20026342 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   25705305           -22.1%   20026342        GEO-MEAN sched_debug.cpu#15.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     563117 ±  3%     +19.0%     669901 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>     424656 ±  2%     +37.7%     584637 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     489010           +28.0%     625818        GEO-MEAN cpuidle.C6-IVT.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1790 ±  5%     -22.1%       1394 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1790           -22.1%       1394        GEO-MEAN sched_debug.cpu#103.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25686569 ±  1%     -21.6%   20148163 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   25686569           -21.6%   20148163        GEO-MEAN sched_debug.cpu#13.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.01 ± 11%     +26.3%       3.81 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3.01           +26.3%       3.81        GEO-MEAN perf-profile.cpu-cycles.read_hpet.ktime_get.clockevents_program_event.tick_program_event.hrtimer_interrupt
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7192 ± 13%     -36.7%       4555 ± 15%  ivb42/ebizzy/performance-50%-100x-10s
>      28185 ±  7%     -12.3%      24706 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      23128 ±  5%     +25.5%      29028 ± 14%  ivb42/hackbench/performance-1600%-threads-socket
>      14225 ±  2%      -7.6%      13149 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      16070           -10.4%      14397        GEO-MEAN sched_debug.cpu#36.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     659506 ±  0%     -21.1%     520254 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     659506           -21.1%     520254        GEO-MEAN sched_debug.cpu#44.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        474 ±  2%     +28.6%        610 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        474           +28.6%        610        GEO-MEAN sched_debug.cfs_rq[10]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      21738 ±  2%     +28.6%      27956 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>      21738           +28.6%      27956        GEO-MEAN sched_debug.cfs_rq[10]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   26289191 ±  1%     -21.5%   20639754 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   26289191           -21.5%   20639754        GEO-MEAN sched_debug.cpu#20.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  9%     +20.7%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +20.7%         23        GEO-MEAN sched_debug.cpu#8.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   26272949 ±  1%     -21.5%   20616474 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   26272949           -21.5%   20616474        GEO-MEAN sched_debug.cpu#20.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         68 ±  8%     +23.9%         84 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>         68           +23.9%         84        GEO-MEAN sched_debug.cpu#31.nr_uninterruptible
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  5%     -23.4%         16 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         23 ± 11%     -18.3%         19 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -20.9%         17        GEO-MEAN sched_debug.cpu#34.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     233620 ±  5%     +23.6%     288688 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     233620           +23.6%     288688        GEO-MEAN sched_debug.cfs_rq[10]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     106116 ± 14%     -29.3%      75002 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>     106116           -29.3%      75002        GEO-MEAN sched_debug.cfs_rq[1]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         76 ±  7%     -24.6%         57 ± 27%  ivb42/hackbench/performance-100%-threads-socket
>         76           -24.6%         57        GEO-MEAN sched_debug.cfs_rq[13]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1355 ± 24%     +36.0%       1843 ± 11%  ivb42/hackbench/performance-100%-threads-socket
>       1355           +36.0%       1843        GEO-MEAN numa-meminfo.node0.Inactive(anon)
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6844 ± 14%     +49.9%      10259 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     869997 ±  1%     -10.0%     782794 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      77167           +16.1%      89615        GEO-MEAN sched_debug.cpu#2.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     837853 ±  1%     -22.6%     648690 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>     836852 ± 41%     +54.5%    1293306 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>     837352            +9.4%     915945        GEO-MEAN sched_debug.cpu#22.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25525885 ±  0%     -21.5%   20037162 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   25525885           -21.5%   20037162        GEO-MEAN sched_debug.cpu#17.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        545 ±  2%     -23.8%        415 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        545           -23.8%        415        GEO-MEAN sched_debug.cfs_rq[34]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.53 ± 12%     +44.0%       0.76 ± 25%  ivb42/hackbench/performance-1600%-threads-socket
>       0.53           +44.0%       0.76        GEO-MEAN perf-profile.cpu-cycles.get_partial_node.isra.47.__slab_alloc.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25575741 ±  0%     -21.4%   20104812 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   25575741           -21.4%   20104812        GEO-MEAN sched_debug.cpu#17.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     265158 ±  4%     -21.7%     207674 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     265158           -21.7%     207674        GEO-MEAN sched_debug.cfs_rq[34]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4050059 ±  8%     -23.8%    3088113 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4050059           -23.8%    3088113        GEO-MEAN sched_debug.cfs_rq[82]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6479886 ±  4%     -21.5%    5085287 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    6479886           -21.5%    5085287        GEO-MEAN sched_debug.cfs_rq[34]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        298 ±  9%     +33.7%        399 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        584 ±  5%     -13.8%        503 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>        417            +7.4%        448        GEO-MEAN sched_debug.cfs_rq[16]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.35 ± 15%     -26.1%       2.48 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       3.35           -26.1%       2.48        GEO-MEAN perf-profile.cpu-cycles.rw_verify_area.vfs_read.sys_read.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        266 ± 22%     +36.1%        362 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        609 ± 14%     -18.4%        497 ±  9%  ivb42/hackbench/performance-100%-threads-socket
>        402            +5.4%        424        GEO-MEAN sched_debug.cfs_rq[20]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24955 ±  1%     -23.7%      19033 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      24955           -23.7%      19033        GEO-MEAN sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     650072 ±  4%     -17.8%     534335 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      31534 ± 13%     +41.8%      44720 ± 14%  ivb42/hackbench/performance-50%-threads-socket
>     143177            +8.0%     154583        GEO-MEAN sched_debug.cpu#38.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  6%     +23.6%         22 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         26 ± 22%     -27.5%         19 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         22            -5.3%         20        GEO-MEAN sched_debug.cpu#7.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  7%     +22.8%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         23 ±  8%     -18.3%         19 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         21            +0.2%         21        GEO-MEAN sched_debug.cpu#7.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.62 ± 12%     -33.5%       1.08 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.03 ±  1%     -13.2%       0.89 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       1.29           -24.0%       0.98        GEO-MEAN perf-profile.cpu-cycles.skb_unlink.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1877 ±  8%     -20.7%       1489 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1877           -20.7%       1489        GEO-MEAN sched_debug.cpu#111.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        636 ±  7%     -18.1%        521 ± 11%  ivb42/hackbench/performance-100%-threads-socket
>        636           -18.1%        521        GEO-MEAN sched_debug.cfs_rq[6]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     816065 ±  2%     -20.8%     645990 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     816064           -20.8%     645989        GEO-MEAN sched_debug.cpu#21.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     -31.7%         13 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  0%     +10.5%         21 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         19           -13.1%         16        GEO-MEAN sched_debug.cpu#28.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +51.2%         20 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  2%      -9.7%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>         16           +16.8%         19        GEO-MEAN sched_debug.cpu#16.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        587 ±  5%     -11.8%        517 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>        487 ±  5%     +36.3%        664 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>        534            +9.7%        586        GEO-MEAN sched_debug.cfs_rq[0]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     -17.2%         16 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -17.2%         15        GEO-MEAN sched_debug.cpu#30.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ± 13%     +43.9%         19 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         13           +43.9%         19        GEO-MEAN sched_debug.cfs_rq[19]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     -17.5%         15 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>         18           -17.5%         15        GEO-MEAN sched_debug.cpu#27.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     -19.0%         15 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -19.0%         15        GEO-MEAN sched_debug.cpu#30.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25395850 ±  0%     -21.3%   19996864 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   25395850           -21.3%   19996864        GEO-MEAN sched_debug.cpu#16.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   25385835 ±  0%     -21.3%   19979026 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   25385835           -21.3%   19979026        GEO-MEAN sched_debug.cpu#16.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        536 ± 10%     -33.0%        359 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        586 ±  2%      -8.0%        540 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>        560           -21.4%        440        GEO-MEAN sched_debug.cfs_rq[37]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5092506 ±  4%     +25.6%    6395946 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>    5092506           +25.6%    6395946        GEO-MEAN sched_debug.cfs_rq[14]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     208891 ±  4%     +25.5%     262171 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     208891           +25.5%     262171        GEO-MEAN sched_debug.cfs_rq[14]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5694 ± 14%     -28.1%       4091 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>      27951 ±  7%     -14.0%      24051 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      31238 ±  7%     -19.4%      25181 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>      13928 ±  3%     -10.0%      12532 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      16222           -18.2%      13275        GEO-MEAN sched_debug.cpu#34.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   26311333 ±  1%     -21.6%   20632524 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   26311333           -21.6%   20632524        GEO-MEAN sched_debug.cpu#21.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3042142 ±  4%     -14.0%    2614903 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>   22221059 ±  1%     -25.7%   16516998 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    8221899           -20.1%    6571936        GEO-MEAN sched_debug.cpu#23.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     +24.6%         23 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +24.6%         23        GEO-MEAN sched_debug.cpu#10.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     +22.4%         23 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +22.4%         23        GEO-MEAN sched_debug.cpu#10.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  5%     -17.8%         20 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         24           -17.8%         19        GEO-MEAN sched_debug.cfs_rq[8]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  8%     +22.0%         24 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +22.0%         24        GEO-MEAN sched_debug.cpu#10.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     +20.3%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         24 ±  6%     -19.4%         19 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         21            -1.5%         21        GEO-MEAN sched_debug.cpu#9.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     +22.0%         24 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +22.0%         24        GEO-MEAN sched_debug.cpu#9.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         27 ± 25%     -34.1%         18 ± 16%  ivb42/hackbench/performance-1600%-threads-socket
>         27           -34.1%         17        GEO-MEAN sched_debug.cpu#34.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  8%     +20.3%         23 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +20.3%         23        GEO-MEAN sched_debug.cpu#8.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3962812 ±  2%     -13.8%    3417120 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>   25842972 ±  0%     -21.5%   20284708 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   10119824           -17.7%    8325580        GEO-MEAN sched_debug.cpu#12.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     660294 ±  9%     -14.4%     564994 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>    1526194 ± 17%     +65.4%    2524720 ± 29%  ivb42/hackbench/performance-1600%-threads-socket
>    1003861           +19.0%    1194341        GEO-MEAN sched_debug.cpu#40.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 25%     -28.3%          7 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         15 ±  8%     +37.0%         21 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         12            -0.9%         12        GEO-MEAN sched_debug.cpu#15.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1354 ± 16%    +100.7%       2717 ± 49%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     882994 ±  2%      -9.2%     801606 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      34579           +35.0%      46672        GEO-MEAN sched_debug.cpu#25.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30824379 ±  1%     -20.1%   24621183 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   30824379           -20.1%   24621183        GEO-MEAN sched_debug.cpu#42.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1791 ±  8%     -17.4%       1480 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1791           -17.4%       1480        GEO-MEAN sched_debug.cpu#113.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30849469 ±  1%     -20.1%   24636230 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   30849469           -20.1%   24636230        GEO-MEAN sched_debug.cpu#42.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.05 ± 17%     -22.7%       1.59 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>       2.05           -22.7%       1.59        GEO-MEAN perf-profile.cpu-cycles.__slab_free.kfree.skb_free_head.skb_release_data.skb_release_all
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      17108 ±  9%     +29.5%      22154 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      17108           +29.5%      22154        GEO-MEAN sched_debug.cpu#50.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     -20.0%         16 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>         31 ± 17%     +29.0%         40 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         24            +1.6%         25        GEO-MEAN sched_debug.cpu#0.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1857 ± 22%     -24.1%       1410 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1857           -24.1%       1410        GEO-MEAN sched_debug.cpu#85.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        423 ± 11%     -19.9%        339 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        422           -19.9%        338        GEO-MEAN numa-vmstat.node0.nr_page_table_pages
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      31306 ±  3%     -27.8%      22592 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>      40348 ±  4%      +6.7%      43051 ±  1%  ivb42/hackbench/performance-1600%-threads-socket
>      35540           -12.3%      31186        GEO-MEAN sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1690 ± 11%     -19.9%       1353 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>       1690           -19.9%       1353        GEO-MEAN numa-meminfo.node0.PageTables
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5462429 ±  7%     +16.4%    6355796 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    5462429           +16.4%    6355796        GEO-MEAN sched_debug.cfs_rq[13]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31513770 ±  0%     -20.1%   25180158 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   31513770           -20.1%   25180158        GEO-MEAN sched_debug.cpu#46.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31530459 ±  0%     -20.1%   25191647 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   31530459           -20.1%   25191647        GEO-MEAN sched_debug.cpu#46.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6940689 ± 10%     -14.9%    5905543 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    6940689           -14.9%    5905543        GEO-MEAN sched_debug.cfs_rq[47]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14799 ±  7%     +50.6%      22281 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3863385 ±  3%     -10.9%    3441935 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>   30720180 ±  0%     -19.4%   24772598 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1206555            +2.6%    1238523        GEO-MEAN sched_debug.cpu#36.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     285373 ± 10%     -14.9%     242798 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     285373           -14.9%     242798        GEO-MEAN sched_debug.cfs_rq[47]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.04 ± 13%     -28.0%       0.75 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.04           -28.0%       0.75        GEO-MEAN perf-profile.cpu-cycles.__pthread_disable_asynccancel.start_thread
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ± 25%     +52.9%         26 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         17           +52.9%         26        GEO-MEAN sched_debug.cpu#23.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.90 ± 13%     -27.1%       1.38 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>       1.11 ±  7%     -12.5%       0.97 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       1.45           -20.1%       1.16        GEO-MEAN perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_read.sys_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     224197 ±  7%     +16.2%     260451 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     224197           +16.2%     260451        GEO-MEAN sched_debug.cfs_rq[13]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       4865 ± 15%     +28.4%       6248 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     860946 ±  1%     -13.4%     745561 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      64718            +5.5%      68251        GEO-MEAN sched_debug.cpu#45.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    7047781 ±  9%     -20.6%    5593913 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    7047781           -20.6%    5593913        GEO-MEAN sched_debug.cfs_rq[36]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     288861 ±  9%     -20.7%     229030 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     288861           -20.7%     229030        GEO-MEAN sched_debug.cfs_rq[36]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        509 ±  3%     -21.2%        401 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        509           -21.2%        401        GEO-MEAN sched_debug.cfs_rq[28]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     810012 ± 27%     +35.8%    1100210 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>     810012           +35.8%    1100210        GEO-MEAN sched_debug.cpu#9.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23365 ±  3%     -21.2%      18418 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      23365           -21.2%      18417        GEO-MEAN sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     -20.7%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -20.7%         15        GEO-MEAN sched_debug.cpu#27.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         15 ±  7%     +23.4%         19 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         15           +23.4%         19        GEO-MEAN sched_debug.cpu#41.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     -20.7%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -20.7%         15        GEO-MEAN sched_debug.cpu#27.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         11 ±  8%     +35.3%         15 ± 13%  ivb42/ebizzy/performance-50%-100x-10s
>         11           +35.3%         15        GEO-MEAN sched_debug.cfs_rq[14]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +23.3%         24 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +23.3%         24        GEO-MEAN sched_debug.cpu#3.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  3%     -25.3%         18 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>         24           -25.3%         18        GEO-MEAN sched_debug.cpu#42.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ± 10%     -23.1%         16 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>         21           -23.1%         16        GEO-MEAN sched_debug.cpu#2.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     -18.6%         16 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -18.6%         15        GEO-MEAN sched_debug.cpu#29.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  8%     -18.3%         16 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -18.3%         16        GEO-MEAN sched_debug.cpu#32.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.95 ± 12%     -30.5%       1.36 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       2.00 ±  2%     +13.0%       2.26 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>       1.97           -11.4%       1.75        GEO-MEAN perf-profile.cpu-cycles.start_thread
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3968 ±  8%     -20.3%       3161 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3968           -20.3%       3161        GEO-MEAN sched_debug.cpu#57.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      12911 ± 12%     -20.6%      10247 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    3911134 ±  5%     -10.6%    3495961 ±  1%  ivb42/hackbench/performance-1600%-threads-socket
>   25905972 ±  0%     -21.3%   20386581 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1093673           -17.7%     900550        GEO-MEAN sched_debug.cpu#19.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9523 ±  9%     -19.7%       7649 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4167689 ±  9%     -15.5%    3522556 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>   26595019 ±  0%     -21.8%   20795049 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1018190           -19.0%     824434        GEO-MEAN sched_debug.cpu#23.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      32393 ± 24%     +36.5%      44205 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      32393           +36.5%      44205        GEO-MEAN proc-vmstat.pgactivate
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        141 ± 19%     -29.6%         99 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>        141           -29.6%         99        GEO-MEAN sched_debug.cfs_rq[28]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30227050 ±  1%     -19.3%   24406165 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   30227049           -19.3%   24406164        GEO-MEAN sched_debug.cpu#41.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     114395 ± 12%     -25.5%      85254 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>     114395           -25.5%      85254        GEO-MEAN sched_debug.cfs_rq[2]:/.tg_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8088 ± 14%     +24.1%      10036 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8088           +24.1%      10036        GEO-MEAN sched_debug.cpu#51.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      57291 ± 10%     +15.4%      66141 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      57291           +15.4%      66141        GEO-MEAN numa-vmstat.node0.nr_file_pages
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     229200 ± 10%     +15.4%     264540 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>     229200           +15.4%     264540        GEO-MEAN numa-meminfo.node0.FilePages
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3831 ±  6%     -24.6%       2887 ± 12%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3831           -24.6%       2887        GEO-MEAN sched_debug.cpu#53.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5349079 ± 12%     +26.8%    6781934 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    5349079           +26.8%    6781934        GEO-MEAN sched_debug.cfs_rq[12]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27900 ±  7%     -14.5%      23846 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      27900           -14.5%      23846        GEO-MEAN sched_debug.cpu#35.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     219437 ± 12%     +26.1%     276803 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     219437           +26.1%     276803        GEO-MEAN sched_debug.cfs_rq[12]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3872 ±  7%     +33.7%       5176 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3872           +33.7%       5175        GEO-MEAN sched_debug.cpu#108.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     905517 ±  0%     -20.3%     721697 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     905517           -20.3%     721697        GEO-MEAN cpuidle.C6-IVT-4S.usage
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28374 ±  9%     -14.5%      24267 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      28374           -14.5%      24266        GEO-MEAN sched_debug.cpu#14.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  9%     -28.4%         17 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         14 ± 16%     +27.9%         18 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         18            -4.3%         17        GEO-MEAN sched_debug.cpu#39.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  7%     +20.6%         25 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +20.6%         25        GEO-MEAN sched_debug.cpu#1.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30686015 ±  0%     -19.0%   24852515 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   30686015           -19.0%   24852515        GEO-MEAN sched_debug.cpu#43.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30567772 ±  1%     -19.1%   24719285 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   30567772           -19.1%   24719285        GEO-MEAN sched_debug.cpu#37.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   30700393 ±  0%     -19.0%   24871670 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   30700393           -19.0%   24871669        GEO-MEAN sched_debug.cpu#43.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4067106 ±  4%     -23.1%    3129521 ±  6%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    4067106           -23.1%    3129521        GEO-MEAN sched_debug.cfs_rq[77]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  7%     +65.0%         22 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         22 ± 11%     -14.9%         19 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         16 ± 10%     +18.4%         19 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         20 ±  3%      -9.8%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>         17           +10.6%         19        GEO-MEAN sched_debug.cpu#16.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     +22.4%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         23 ±  7%     -15.9%         19 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>         21            +1.4%         21        GEO-MEAN sched_debug.cpu#7.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28022 ± 13%     -15.9%      23564 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>      28022           -15.9%      23564        GEO-MEAN numa-meminfo.node1.SReclaimable
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.98 ±  9%     -19.0%       1.60 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       1.98           -19.0%       1.60        GEO-MEAN perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write.sys_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7002 ± 13%     -15.9%       5891 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>       7002           -15.9%       5891        GEO-MEAN numa-vmstat.node1.nr_slab_reclaimable
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  7%     -21.5%         17 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -21.5%         17        GEO-MEAN sched_debug.cpu#37.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6844932 ±  6%     -13.3%    5937522 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    6844932           -13.3%    5937522        GEO-MEAN sched_debug.cfs_rq[37]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     280599 ±  6%     -13.3%     243386 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     280599           -13.3%     243386        GEO-MEAN sched_debug.cfs_rq[37]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5215378 ±  9%     +24.2%    6475445 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>    5215378           +24.2%    6475445        GEO-MEAN sched_debug.cfs_rq[20]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        503 ±  6%     +18.5%        597 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        503           +18.5%        597        GEO-MEAN sched_debug.cfs_rq[8]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4132420 ± 13%     -20.0%    3307061 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>   30426640 ±  0%     -18.9%   24661763 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11213191           -19.5%    9030944        GEO-MEAN sched_debug.cpu#38.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    7197555 ±  3%     -18.5%    5868547 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>    7197555           -18.5%    5868547        GEO-MEAN sched_debug.cfs_rq[38]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2148640 ±  9%     -23.4%    1645673 ±  8%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    1374659 ± 25%     +37.8%    1894017 ±  8%  ivb42/hackbench/performance-50%-threads-socket
>    1718618            +2.7%    1765484        GEO-MEAN sched_debug.cfs_rq[19]:/.spread0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     294987 ±  3%     -18.5%     240496 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>     294987           -18.5%     240496        GEO-MEAN sched_debug.cfs_rq[38]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     214039 ±  9%     +24.1%     265518 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     214039           +24.1%     265518        GEO-MEAN sched_debug.cfs_rq[20]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22926 ±  1%     -14.5%      19608 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>      22926           -14.5%      19608        GEO-MEAN sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  4%     +20.3%         23 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         24 ±  3%     -18.1%         19 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         21            -0.7%         21        GEO-MEAN sched_debug.cpu#9.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.19 ±  8%     -20.4%       0.95 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>       1.19           -20.4%       0.95        GEO-MEAN turbostat.%c6
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        500 ±  1%     -14.4%        428 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>        499           -14.4%        427        GEO-MEAN sched_debug.cfs_rq[30]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  6%     +56.4%         20 ± 33%  ivb42/ebizzy/performance-50%-100x-10s
>         13           +56.4%         20        GEO-MEAN sched_debug.cpu#18.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ± 14%     -25.4%         16 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>         23 ±  3%     -22.5%         18 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -24.0%         17        GEO-MEAN sched_debug.cpu#34.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23114 ±  6%     +18.2%      27326 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>      23114           +18.2%      27326        GEO-MEAN sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9273 ±  8%     +30.0%      12054 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     882824 ±  1%     -10.1%     793313 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>      90479            +8.1%      97790        GEO-MEAN sched_debug.cpu#0.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28202 ±  8%     -15.5%      23828 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      28202           -15.5%      23828        GEO-MEAN sched_debug.cpu#2.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         10 ± 22%     -26.4%          7 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         15 ± 10%     +35.6%         20 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         12            -0.1%         12        GEO-MEAN sched_debug.cpu#15.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5249761 ±  7%     +21.7%    6386909 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>    5249761           +21.7%    6386909        GEO-MEAN sched_debug.cfs_rq[19]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8828 ±  9%     +18.6%      10472 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>   19800323 ±  1%     -24.6%   14937832 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     418097            -5.4%     395514        GEO-MEAN sched_debug.cpu#45.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   29982666 ±  0%     -18.4%   24458570 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   29982666           -18.4%   24458570        GEO-MEAN sched_debug.cpu#40.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1614 ±  4%     -16.5%       1348 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1614           -16.5%       1348        GEO-MEAN sched_debug.cpu#93.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   29960708 ±  0%     -18.4%   24438001 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   29960708           -18.4%   24438001        GEO-MEAN sched_debug.cpu#40.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31032942 ±  1%     -19.2%   25067720 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   31032942           -19.2%   25067720        GEO-MEAN sched_debug.cpu#45.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     215352 ±  7%     +21.6%     261827 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>     215352           +21.6%     261827        GEO-MEAN sched_debug.cfs_rq[19]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7824 ± 12%     +34.6%      10529 ± 14%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       7824           +34.6%      10529        GEO-MEAN sched_debug.cpu#56.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.53 ±  3%     +23.0%       1.88 ±  7%  ivb42/hackbench/performance-50%-threads-socket
>       1.53           +23.0%       1.88        GEO-MEAN perf-profile.cpu-cycles.fput.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  5%     +27.7%         27 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +27.7%         27        GEO-MEAN sched_debug.cpu#1.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     819312 ±  2%     -19.6%     658365 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>     819312           -19.6%     658365        GEO-MEAN sched_debug.cpu#20.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4164779 ±  9%     -16.9%    3460017 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>   26577794 ±  0%     -22.0%   20738980 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   10520962           -19.5%    8470964        GEO-MEAN sched_debug.cpu#23.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31156436 ±  0%     -18.7%   25325830 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   31156435           -18.7%   25325830        GEO-MEAN sched_debug.cpu#44.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        494 ±  6%     -16.0%        415 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>        494           -16.0%        414        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3898 ± 18%     -23.9%       2965 ± 10%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3897           -23.9%       2964        GEO-MEAN sched_debug.cpu#79.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31140524 ±  0%     -18.8%   25300128 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   31140524           -18.8%   25300128        GEO-MEAN sched_debug.cpu#44.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23171 ±  7%     -18.6%      18867 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      23171           -18.6%      18867        GEO-MEAN sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22629 ±  6%     -16.0%      19000 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>      22629           -16.0%      19000        GEO-MEAN sched_debug.cfs_rq[33]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ±  5%     -17.9%         18 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -17.9%         18        GEO-MEAN sched_debug.cfs_rq[4]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  9%     +25.0%         21 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         17           +25.0%         21        GEO-MEAN sched_debug.cpu#1.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  6%     +23.6%         22 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +23.6%         22        GEO-MEAN sched_debug.cpu#10.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     226665 ±  5%     +25.4%     284127 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     226665           +25.4%     284127        GEO-MEAN sched_debug.cfs_rq[17]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     855729 ± 28%     +34.2%    1148664 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>     855729           +34.2%    1148664        GEO-MEAN sched_debug.cpu#6.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5526644 ±  5%     +25.4%    6930225 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    5526644           +25.4%    6930225        GEO-MEAN sched_debug.cfs_rq[17]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2372846 ± 10%     -14.4%    2031906 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>    2372845           -14.4%    2031906        GEO-MEAN cpuidle.C3-IVT.time
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        707 ± 12%     +40.6%        995 ± 18%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        707           +40.6%        995        GEO-MEAN sched_debug.cpu#81.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        586 ±  3%     -17.0%        486 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>        586           -17.0%        486        GEO-MEAN sched_debug.cfs_rq[8]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  8%     -21.9%         16 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         23 ±  7%     -20.0%         18 ± 11%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -20.9%         17        GEO-MEAN sched_debug.cpu#34.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     -20.3%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  2%      -6.5%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         20           -13.7%         17        GEO-MEAN sched_debug.cpu#29.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  0%     -23.3%         15 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  0%     +10.5%         21 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         19            -7.9%         17        GEO-MEAN sched_debug.cpu#28.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  0%     -25.0%         15 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  0%     +12.3%         21 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         19            -8.2%         17        GEO-MEAN sched_debug.cpu#28.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        505 ±  7%     -18.3%        412 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        505           -18.3%        412        GEO-MEAN sched_debug.cfs_rq[29]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1188 ±  9%     +14.5%       1361 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1188           +14.5%       1360        GEO-MEAN slabinfo.anon_vma.active_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1188 ±  9%     +14.5%       1361 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1188           +14.5%       1360        GEO-MEAN slabinfo.anon_vma.num_slabs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      66604 ±  9%     +14.5%      76248 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      66604           +14.5%      76248        GEO-MEAN slabinfo.anon_vma.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    4139312 ± 13%     -19.2%    3345528 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>   30443857 ±  0%     -18.9%   24679394 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11225713           -19.1%    9086562        GEO-MEAN sched_debug.cpu#38.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      66162 ±  9%     +14.3%      75642 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      66161           +14.3%      75642        GEO-MEAN slabinfo.anon_vma.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         13 ±  9%     +48.8%         20 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         16 ± 15%     +18.0%         19 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>         20 ±  2%      -8.7%         18 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>         16           +17.0%         19        GEO-MEAN sched_debug.cpu#16.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         25 ±  5%     -16.0%         21 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>         21 ±  9%     +23.4%         26 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>         23            +1.8%         23        GEO-MEAN sched_debug.cfs_rq[29]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         86 ±  4%     -23.6%         65 ± 18%  ivb42/hackbench/performance-100%-threads-socket
>         85           -23.6%         65        GEO-MEAN sched_debug.cfs_rq[6]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3912870 ±  3%     -11.4%    3466362 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>   30769646 ±  1%     -19.3%   24823365 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   10972585           -15.5%    9276139        GEO-MEAN sched_debug.cpu#36.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     881319 ±  1%     -16.5%     735645 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     881319           -16.5%     735645        GEO-MEAN sched_debug.cpu#19.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28336 ±  7%     -13.6%      24483 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      28336           -13.6%      24483        GEO-MEAN sched_debug.cpu#4.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1788 ±  8%     -23.9%       1360 ± 13%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1788           -23.9%       1360        GEO-MEAN sched_debug.cpu#114.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  6%     -21.4%         14 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  4%     -10.9%         19 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         19           -16.3%         16        GEO-MEAN sched_debug.cpu#29.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9047 ± 12%     -16.0%       7597 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>   19955834 ±  0%     -23.9%   15189591 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     424908           -20.1%     339698        GEO-MEAN sched_debug.cpu#46.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27812 ±  7%     -13.7%      23998 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      27812           -13.7%      23998        GEO-MEAN sched_debug.cpu#6.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        978 ±  7%     -13.0%        850 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>        978           -13.0%        850        GEO-MEAN vmstat.procs.r
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     +20.7%         23 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +20.7%         23        GEO-MEAN sched_debug.cpu#8.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     +20.7%         23 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +20.7%         23        GEO-MEAN sched_debug.cpu#8.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     +34.5%         26 ± 19%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +34.5%         26        GEO-MEAN sched_debug.cpu#3.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     +15.5%         22 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +15.5%         22        GEO-MEAN sched_debug.cpu#11.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  2%     +25.0%         23 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         18           +25.0%         23        GEO-MEAN sched_debug.cpu#10.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        502 ±  5%     -18.0%        411 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        501           -18.0%        411        GEO-MEAN sched_debug.cfs_rq[27]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     654341 ±  4%     -18.0%     536748 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     654341           -18.0%     536747        GEO-MEAN sched_debug.cpu#39.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        134 ± 28%     +61.3%        216 ± 23%  ivb42/ebizzy/performance-50%-100x-10s
>        134           +61.3%        216        GEO-MEAN sched_debug.cfs_rq[30]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22993 ±  5%     -18.0%      18852 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      22993           -18.0%      18851        GEO-MEAN sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9.33 ± 12%     -21.7%       7.31 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       9.33           -21.7%       7.31        GEO-MEAN perf-profile.cpu-cycles.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.81 ±  7%     +28.4%       1.04 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>       0.81           +28.4%       1.04        GEO-MEAN perf-profile.cpu-cycles.get_partial_node.isra.47.__slab_alloc.kmem_cache_alloc_node.__alloc_skb.sock_alloc_send_pskb
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5422421 ±  9%      +6.7%    5784234 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>    5422421            +6.7%    5784234        GEO-MEAN meminfo.DirectMap2M
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        480 ±  3%     +21.3%        582 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        480           +21.3%        582        GEO-MEAN sched_debug.cfs_rq[1]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23982 ±  5%     +14.9%      27559 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      23982           +14.9%      27558        GEO-MEAN sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22036 ±  3%     +21.1%      26680 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>      22036           +21.1%      26680        GEO-MEAN sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     248037 ±  4%     -14.6%     211800 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>     248037           -14.6%     211800        GEO-MEAN sched_debug.cfs_rq[30]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        523 ±  5%     +14.8%        600 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        523           +14.8%        600        GEO-MEAN sched_debug.cfs_rq[9]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3975794 ±  3%     -12.4%    3484643 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   31508807 ±  0%     -19.2%   25447218 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11192521           -15.9%    9416713        GEO-MEAN sched_debug.cpu#47.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      13.79 ± 11%     -18.7%      11.22 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      13.79           -18.7%      11.22        GEO-MEAN perf-profile.cpu-cycles.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6707995 ±  4%     -20.4%    5338153 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    6707995           -20.4%    5338153        GEO-MEAN sched_debug.cfs_rq[41]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28480 ±  6%     -14.5%      24340 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      28480           -14.5%      24340        GEO-MEAN sched_debug.cpu#3.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.44 ± 13%     -31.5%       1.67 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       1.30 ±  2%     -10.9%       1.16 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       1.78           -21.9%       1.39        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_from_iovec.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5630 ± 20%     -27.4%       4085 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>      28428 ±  6%     -13.4%      24615 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      14374 ±  1%      -9.7%      12976 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      13201           -17.2%      10927        GEO-MEAN sched_debug.cpu#32.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +28.3%         25 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +28.3%         25        GEO-MEAN sched_debug.cpu#3.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  8%     +16.7%         23 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +16.7%         23        GEO-MEAN sched_debug.cpu#5.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ± 10%     +18.6%         23 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +18.6%         23        GEO-MEAN sched_debug.cpu#5.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  8%     -14.1%         20 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         23           -14.1%         20        GEO-MEAN sched_debug.cfs_rq[31]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     -16.1%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         18           -16.1%         15        GEO-MEAN sched_debug.cpu#26.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +21.7%         24 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         19           +21.7%         24        GEO-MEAN sched_debug.cpu#3.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         23 ±  6%     -13.0%         20 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         23           -13.0%         19        GEO-MEAN sched_debug.cfs_rq[2]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  2%     -14.5%         15 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         18           -14.5%         15        GEO-MEAN sched_debug.cpu#26.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3976394 ±  3%     -11.7%    3510398 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>   31529669 ±  0%     -19.1%   25504070 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>   11197071           -15.5%    9462000        GEO-MEAN sched_debug.cpu#47.sched_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        299 ±  9%     +31.8%        394 ± 14%  ivb42/ebizzy/performance-50%-100x-10s
>        299           +31.8%        394        GEO-MEAN sched_debug.cfs_rq[14]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6188990 ±  4%     -16.9%    5143546 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    6188990           -16.9%    5143546        GEO-MEAN sched_debug.cfs_rq[28]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27911 ±  7%      -9.1%      25365 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      27590 ±  9%     -10.0%      24831 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>      27750            -9.6%      25096        GEO-MEAN sched_debug.cpu#15.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24152 ±  3%     -17.9%      19823 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      24152           -17.9%      19823        GEO-MEAN sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  7%     +15.8%         22 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  2%      -8.1%         19 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         23 ±  6%     -14.5%         19 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         20            -3.1%         20        GEO-MEAN sched_debug.cpu#8.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        527 ±  3%     -17.8%        433 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        527           -17.8%        432        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         95 ±  5%     -19.2%         77 ± 19%  ivb42/hackbench/performance-100%-threads-socket
>         95           -19.2%         77        GEO-MEAN sched_debug.cfs_rq[13]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ± 12%     -23.5%         13 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  4%     -10.9%         19 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         19           -17.5%         15        GEO-MEAN sched_debug.cpu#29.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     253158 ±  4%     -16.8%     210701 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     253158           -16.8%     210701        GEO-MEAN sched_debug.cfs_rq[28]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    3881265 ±  5%     -11.0%    3454243 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>   25887804 ±  0%     -21.3%   20372718 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>   10023843           -16.3%    8388821        GEO-MEAN sched_debug.cpu#19.nr_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8120 ±  7%     +21.9%       9900 ±  5%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       8120           +21.9%       9900        GEO-MEAN sched_debug.cpu#48.ttwu_count
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     291131 ±  6%     +13.4%     330032 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     291131           +13.4%     330032        GEO-MEAN sched_debug.cpu#23.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        151 ±  6%     +14.1%        172 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         64 ±  6%     -30.9%         44 ± 32%  ivb42/hackbench/performance-100%-threads-socket
>         98           -11.2%         87        GEO-MEAN sched_debug.cfs_rq[6]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.98 ±  3%     +20.0%       1.18 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>       0.98           +20.0%       1.18        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     798851 ±  3%     -15.8%     672484 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     798851           -15.8%     672484        GEO-MEAN sched_debug.cpu#15.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +15.0%         23 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>         26 ±  6%     -15.0%         22 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         23            -1.1%         22        GEO-MEAN sched_debug.cpu#4.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  7%     +19.0%         25 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +19.0%         24        GEO-MEAN sched_debug.cpu#1.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  9%     -16.4%         17 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         16 ± 24%     +48.0%         24 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>         18           +11.2%         20        GEO-MEAN sched_debug.cpu#12.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>  1.883e+10 ±  2%     -16.3%  1.575e+10 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>  1.883e+10           -16.3%  1.575e+10        GEO-MEAN cpuidle.C6-IVT.time
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     242217 ±  3%     -12.7%     211488 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>     242217           -12.7%     211488        GEO-MEAN sched_debug.cfs_rq[33]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     851770 ±  0%     -15.3%     721480 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     851770           -15.3%     721480        GEO-MEAN sched_debug.cpu#17.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ± 10%     -19.0%         15 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>         19           -19.0%         15        GEO-MEAN sched_debug.cpu#11.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  8%     -22.0%         15 ± 16%  ivb42/hackbench/performance-100%-threads-socket
>         19           -22.0%         15        GEO-MEAN sched_debug.cpu#30.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         15 ± 14%     +28.9%         19 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>         15           +28.9%         19        GEO-MEAN sched_debug.cpu#36.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  6%     -15.5%         16 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -15.5%         16        GEO-MEAN sched_debug.cpu#33.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  8%     -16.9%         16 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -16.9%         16        GEO-MEAN sched_debug.cpu#33.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        935 ±  5%     -14.5%        799 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>        935           -14.5%        799        GEO-MEAN slabinfo.mnt_cache.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        935 ±  5%     -14.5%        799 ± 13%  ivb42/hackbench/performance-1600%-threads-socket
>        935           -14.5%        799        GEO-MEAN slabinfo.mnt_cache.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        161 ± 16%     -24.4%        121 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>        161           -24.4%        121        GEO-MEAN sched_debug.cfs_rq[28]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.23 ±  9%     -16.9%       1.85 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       2.23           -16.9%       1.85        GEO-MEAN perf-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6402970 ±  6%     -14.7%    5458801 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    6402970           -14.7%    5458801        GEO-MEAN sched_debug.cfs_rq[25]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +28.3%         25 ± 17%  ivb42/ebizzy/performance-50%-100x-10s
>         28 ± 39%     -34.1%         18 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>         23            -8.0%         21        GEO-MEAN sched_debug.cpu#4.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     262352 ±  6%     -14.7%     223668 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     262352           -14.7%     223668        GEO-MEAN sched_debug.cfs_rq[25]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     -20.7%         15 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>         19 ±  0%     +10.5%         21 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         19            -6.4%         17        GEO-MEAN sched_debug.cpu#28.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        703 ± 15%     -23.1%        541 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>        703           -23.1%        540        GEO-MEAN sched_debug.cfs_rq[2]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27795 ±  5%     -13.2%      24134 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      27794           -13.2%      24134        GEO-MEAN sched_debug.cpu#16.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3412 ±  8%     -15.1%       2898 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    1420038 ±  1%     -16.0%    1193250 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      69611           -15.5%      58809        GEO-MEAN sched_debug.cpu#13.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22447 ±  4%     -15.7%      18930 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>      22447           -15.7%      18930        GEO-MEAN sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28675 ±  6%     -13.0%      24950 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      28675           -13.0%      24950        GEO-MEAN sched_debug.cpu#13.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5675688 ±  1%     +15.1%    6531142 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    5675688           +15.1%    6531142        GEO-MEAN sched_debug.cfs_rq[15]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        521 ±  4%     -14.2%        447 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>        521           -14.2%        447        GEO-MEAN sched_debug.cfs_rq[35]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  5%     +20.0%         26 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +20.0%         26        GEO-MEAN sched_debug.cpu#1.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  5%     +16.9%         25 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +16.9%         25        GEO-MEAN sched_debug.cpu#2.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         26 ±  6%     -15.0%         22 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>         26           -15.0%         22        GEO-MEAN sched_debug.cfs_rq[4]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  4%     +17.2%         25 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +17.2%         24        GEO-MEAN sched_debug.cpu#2.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        507 ±  8%     +18.0%        598 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>        507           +18.0%        598        GEO-MEAN sched_debug.cfs_rq[5]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23248 ±  8%     +18.1%      27465 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>      23248           +18.1%      27465        GEO-MEAN sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23877 ±  4%     -14.2%      20481 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>      23877           -14.2%      20481        GEO-MEAN sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        494 ±  4%     +15.8%        573 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        494           +15.8%        573        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        514 ±  1%     +13.2%        581 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>        514           +13.2%        581        GEO-MEAN sched_debug.cfs_rq[6]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        489 ±  4%     -15.6%        413 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        489           -15.6%        413        GEO-MEAN sched_debug.cfs_rq[26]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     235161 ±  1%     +14.8%     269925 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     235161           +14.8%     269925        GEO-MEAN sched_debug.cfs_rq[15]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27474 ±  0%     +17.4%      32249 ±  0%  ivb42/hackbench/performance-1600%-threads-socket
>      27474           +17.4%      32249        GEO-MEAN sched_debug.cpu#5.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     654103 ± 16%     +35.4%     885670 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>     654103           +35.4%     885670        GEO-MEAN sched_debug.cpu#34.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28467 ±  8%     -13.3%      24684 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      14483 ±  2%     -11.5%      12813 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>      20305           -12.4%      17784        GEO-MEAN sched_debug.cpu#7.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23596 ±  1%     +13.0%      26662 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>      23596           +13.0%      26661        GEO-MEAN sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        107 ± 15%     +22.9%        132 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>        107           +22.9%        132        GEO-MEAN sched_debug.cfs_rq[40]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        340 ±  7%     +26.7%        430 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        595 ± 10%     -16.5%        496 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>        449            +2.8%        462        GEO-MEAN sched_debug.cfs_rq[12]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22666 ±  4%     +15.7%      26230 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      22666           +15.7%      26230        GEO-MEAN sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -16.4%         17 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -16.4%         17        GEO-MEAN sched_debug.cpu#32.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        110 ± 13%     -17.9%         90 ± 13%  ivb42/hackbench/performance-100%-threads-socket
>        110           -17.9%         90        GEO-MEAN sched_debug.cfs_rq[16]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6564712 ±  2%     -12.6%    5736157 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    6564712           -12.6%    5736157        GEO-MEAN sched_debug.cfs_rq[39]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.91 ± 14%     -20.7%       2.31 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>       1.65 ±  3%     -11.9%       1.45 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       2.19           -16.4%       1.83        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_reserve.isra.26.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     269231 ±  2%     -12.7%     234926 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     269231           -12.7%     234926        GEO-MEAN sched_debug.cfs_rq[39]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        415 ± 12%     -21.2%        327 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>        414           -21.2%        327        GEO-MEAN sched_debug.cfs_rq[5]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8082 ±  6%     -16.3%       6768 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       8082           -16.3%       6768        GEO-MEAN slabinfo.sock_inode_cache.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        167 ± 30%     +52.1%        254 ± 18%  ivb42/ebizzy/performance-50%-100x-10s
>        167           +52.1%        254        GEO-MEAN sched_debug.cfs_rq[12]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28252 ±  6%     -15.3%      23930 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>      14095 ±  2%      -9.6%      12748 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      19955           -12.5%      17466        GEO-MEAN sched_debug.cpu#12.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     866621 ±  1%     -15.9%     728734 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     866621           -15.9%     728734        GEO-MEAN sched_debug.cpu#18.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1039319 ±  1%     -14.8%     885271 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1039319           -14.8%     885271        GEO-MEAN numa-numastat.node0.local_node
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -12.9%         18 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -12.9%         17        GEO-MEAN sched_debug.cpu#31.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  4%     +20.4%         21 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>         17           +20.4%         21        GEO-MEAN sched_debug.cpu#21.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ± 17%     +31.4%         22 ± 15%  ivb42/hackbench/performance-1600%-threads-socket
>         17           +31.4%         22        GEO-MEAN sched_debug.cpu#43.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -16.1%         17 ±  9%  ivb42/hackbench/performance-100%-threads-socket
>         20           -16.1%         17        GEO-MEAN sched_debug.cpu#17.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  0%     +14.8%         20 ±  6%  ivb42/hackbench/performance-100%-threads-socket
>         17           +14.8%         20        GEO-MEAN sched_debug.cfs_rq[26]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         22 ±  6%     -18.2%         18 ±  9%  ivb42/hackbench/performance-1600%-threads-socket
>         22           -18.2%         17        GEO-MEAN sched_debug.cfs_rq[9]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  7%     +16.9%         20 ±  4%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>         17           +16.9%         20        GEO-MEAN sched_debug.cpu#89.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>          7 ± 10%     -18.9%          6 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>          7           -18.9%          6        GEO-MEAN sched_debug.cpu#31.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.65 ± 10%     -16.4%       2.21 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       2.65           -16.4%       2.21        GEO-MEAN perf-profile.cpu-cycles.rw_verify_area.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2279041 ±  3%      +9.8%    2501740 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>     867410 ±  1%     -15.8%     730524 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>    1406009            -3.8%    1351880        GEO-MEAN sched_debug.cpu#20.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       0.92 ±  3%     +16.1%       1.07 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>       0.92           +16.1%       1.07        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1043155 ±  1%     -14.6%     891335 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    1043155           -14.6%     891335        GEO-MEAN numa-numastat.node0.numa_hit
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        661 ± 10%     +32.4%        875 ± 20%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        661           +32.4%        875        GEO-MEAN sched_debug.cpu#80.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.39 ± 13%     -18.5%       1.95 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>       1.36 ±  3%     -11.6%       1.20 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>       1.80           -15.1%       1.53        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.05 ±  7%     -20.6%       0.83 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       1.05           -20.6%       0.83        GEO-MEAN perf-profile.cpu-cycles.unix_write_space.sock_wfree.unix_destruct_scm.skb_release_head_state.skb_release_all
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     846804 ±  1%     -14.7%     722316 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     846804           -14.7%     722316        GEO-MEAN sched_debug.cpu#16.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     238110 ±  3%     -11.2%     211524 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     238110           -11.2%     211524        GEO-MEAN sched_debug.cfs_rq[26]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         24 ±  6%     +16.4%         28 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>         24           +16.4%         28        GEO-MEAN sched_debug.cpu#31.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      83778 ±  3%     -12.3%      73451 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>      83778           -12.3%      73451        GEO-MEAN numa-meminfo.node0.SUnreclaim
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28311 ±  6%     -14.4%      24235 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      14371 ±  1%     -10.2%      12907 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      20170           -12.3%      17686        GEO-MEAN sched_debug.cpu#22.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      20954 ±  3%     -12.3%      18370 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>      20954           -12.3%      18370        GEO-MEAN numa-vmstat.node0.nr_slab_unreclaimable
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23494 ±  5%     +19.1%      27971 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>      23494           +19.1%      27971        GEO-MEAN sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        512 ±  5%     +19.1%        610 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>        512           +19.1%        610        GEO-MEAN sched_debug.cfs_rq[4]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     309512 ±  3%     +13.0%     349773 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>     309511           +13.0%     349773        GEO-MEAN sched_debug.cpu#10.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     871677 ±  0%     -13.2%     756998 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     871677           -13.2%     756998        GEO-MEAN sched_debug.cpu#47.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5912874 ±  3%     -12.7%    5163918 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>   32948870 ±  2%      +9.6%   36105667 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   13957884            -2.2%   13654549        GEO-MEAN sched_debug.cfs_rq[33]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6896945 ±  7%     -15.7%    5811415 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    6896945           -15.7%    5811415        GEO-MEAN sched_debug.cfs_rq[44]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     282705 ±  7%     -15.7%     238207 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     282705           -15.7%     238207        GEO-MEAN sched_debug.cfs_rq[44]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     252684 ±  2%     +13.0%     285532 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     252684           +13.0%     285532        GEO-MEAN sched_debug.cfs_rq[6]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6163243 ±  2%     +13.1%    6967723 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    6163243           +13.1%    6967723        GEO-MEAN sched_debug.cfs_rq[6]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     225520 ±  1%     +19.1%     268653 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>     225520           +19.1%     268653        GEO-MEAN sched_debug.cfs_rq[16]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2537303 ±  4%     -10.2%    2278663 ±  3%  ivb42/hackbench/performance-1600%-threads-socket
>     884857 ±  0%     -16.3%     741031 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1498383           -13.3%    1299446        GEO-MEAN sched_debug.cpu#23.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     832647 ±  3%     -13.7%     718243 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>     832647           -13.7%     718242        GEO-MEAN sched_debug.cpu#13.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6056418 ±  4%     -14.7%    5168979 ±  8%  ivb42/ebizzy/performance-50%-100x-10s
>   32932650 ±  1%      +8.8%   35838098 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>   14122815            -3.6%   13610524        GEO-MEAN sched_debug.cfs_rq[30]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5916186 ±  5%     +14.2%    6756084 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>    5916186           +14.2%    6756084        GEO-MEAN sched_debug.cfs_rq[1]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7942 ±  5%     -15.6%       6700 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       7941           -15.6%       6699        GEO-MEAN slabinfo.sock_inode_cache.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     +23.3%         24 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  3%      -7.9%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         20            +6.6%         21        GEO-MEAN sched_debug.cpu#3.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     938148 ± 38%     +41.3%    1325208 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>     938148           +41.3%    1325208        GEO-MEAN sched_debug.cpu#16.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10568 ±  2%     -11.4%       9365 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>      10567           -11.4%       9365        GEO-MEAN slabinfo.kmalloc-192.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6645 ±  6%     -12.5%       5816 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>       4025 ±  6%      -8.3%       3691 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>       5172           -10.4%       4634        GEO-MEAN slabinfo.RAW.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     242508 ±  5%     +14.2%     276835 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     242508           +14.2%     276835        GEO-MEAN sched_debug.cfs_rq[1]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     827688 ± 27%     +32.6%    1097797 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>     827688           +32.6%    1097797        GEO-MEAN sched_debug.cpu#5.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     863531 ±  1%     -12.4%     756423 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     863531           -12.4%     756423        GEO-MEAN sched_debug.cpu#46.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      10568 ±  2%     -11.4%       9367 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>      10567           -11.4%       9366        GEO-MEAN slabinfo.kmalloc-192.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     278399 ±  1%      +9.4%     304661 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     275094 ±  4%     -20.4%     218896 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     276742            -6.7%     258243        GEO-MEAN sched_debug.cfs_rq[41]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6954107 ±  6%     -15.0%    5908384 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>    6954107           -15.0%    5908384        GEO-MEAN sched_debug.cfs_rq[43]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     860124 ±  0%     -12.8%     750152 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     860124           -12.8%     750152        GEO-MEAN sched_debug.cpu#38.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        150 ± 25%     +52.2%        229 ± 22%  ivb42/ebizzy/performance-50%-100x-10s
>        150           +52.2%        229        GEO-MEAN sched_debug.cfs_rq[30]:/.tg_load_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.56 ± 14%     -18.9%       2.89 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       2.04 ±  7%     -16.0%       1.72 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>       2.70           -17.5%       2.23        GEO-MEAN perf-profile.cpu-cycles.kfree.skb_free_head.skb_release_data.skb_release_all.consume_skb
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     349472 ±  5%     -12.3%     306466 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     349472           -12.3%     306466        GEO-MEAN sched_debug.cpu#36.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  7%     +24.6%         23 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>         18           +24.6%         23        GEO-MEAN sched_debug.cpu#19.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   31982562 ±  0%     +15.7%   37009149 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    5977374 ±  3%     -12.1%    5255719 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>   13826487            +0.9%   13946673        GEO-MEAN sched_debug.cfs_rq[29]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1950 ±  5%     +12.4%       2191 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>       1950           +12.4%       2191        GEO-MEAN numa-vmstat.node1.nr_inactive_anon
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23783 ±  4%     +16.4%      27678 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      23783           +16.4%      27678        GEO-MEAN sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5834 ±  6%     +11.1%       6483 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       5834           +11.1%       6483        GEO-MEAN slabinfo.mm_struct.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6222825 ± 12%     -18.5%    5072717 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    6222825           -18.5%    5072717        GEO-MEAN sched_debug.cfs_rq[24]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     255038 ± 12%     -18.8%     207195 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     255038           -18.8%     207195        GEO-MEAN sched_debug.cfs_rq[24]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        519 ±  4%     +16.2%        603 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>        518           +16.2%        603        GEO-MEAN sched_debug.cfs_rq[2]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     870131 ±  1%     -13.0%     757186 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     870131           -13.0%     757185        GEO-MEAN sched_debug.cpu#43.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3.62 ± 14%     -18.5%       2.95 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>       2.08 ±  7%     -16.1%       1.74 ± 10%  ivb42/hackbench/performance-1600%-threads-socket
>       2.74           -17.3%       2.27        GEO-MEAN perf-profile.cpu-cycles.skb_free_head.skb_release_data.skb_release_all.consume_skb.unix_stream_recvmsg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27743 ±  7%     -12.0%      24409 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      27743           -12.0%      24409        GEO-MEAN sched_debug.cpu#18.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       7804 ±  5%     +12.1%       8751 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>       7804           +12.1%       8751        GEO-MEAN numa-meminfo.node1.Inactive(anon)
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27888 ±  5%      -9.6%      25222 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      27888            -9.6%      25222        GEO-MEAN sched_debug.cpu#19.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5495470 ±  1%     +18.8%    6526373 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>    5495470           +18.8%    6526373        GEO-MEAN sched_debug.cfs_rq[16]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5884155 ±  4%     -10.8%    5248844 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    5884155           -10.8%    5248844        GEO-MEAN sched_debug.cfs_rq[27]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     244799 ±  3%     -12.1%     215287 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     244799           -12.1%     215287        GEO-MEAN sched_debug.cfs_rq[29]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -16.4%         17 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  2%     -11.5%         18 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         20           -14.0%         17        GEO-MEAN sched_debug.cpu#25.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -16.4%         17 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>         20 ±  2%     -11.5%         18 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         20           -14.0%         17        GEO-MEAN sched_debug.cpu#25.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3212 ± 16%     +30.7%       4199 ± 10%  ivb42/hackbench/performance-100%-threads-socket
>       3212           +30.7%       4199        GEO-MEAN meminfo.AnonHugePages
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       6578 ±  5%     -12.2%       5778 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       3989 ±  5%      -8.8%       3639 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>       5122           -10.5%       4585        GEO-MEAN slabinfo.RAW.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     885844 ±  1%     -11.8%     780892 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     885844           -11.8%     780892        GEO-MEAN sched_debug.cpu#10.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     +16.1%         24 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         20           +16.1%         24        GEO-MEAN sched_debug.cpu#4.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  7%     +14.3%         24 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +14.3%         24        GEO-MEAN sched_debug.cpu#4.cpu_load[3]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  4%     +12.3%         24 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +12.3%         24        GEO-MEAN sched_debug.cpu#4.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  7%     +15.9%         24 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>         21           +15.9%         24        GEO-MEAN sched_debug.cpu#1.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  8%     +14.8%         23 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20           +14.8%         23        GEO-MEAN sched_debug.cpu#5.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         12 ± 19%     +27.0%         15 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>         12           +27.0%         15        GEO-MEAN sched_debug.cpu#20.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     247955 ±  4%     +15.1%     285457 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     247955           +15.1%     285457        GEO-MEAN sched_debug.cfs_rq[4]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     292711 ±  7%     +15.4%     337697 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     292710           +15.4%     337697        GEO-MEAN sched_debug.cpu#12.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     354011 ±  2%     -11.3%     314109 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     354010           -11.3%     314109        GEO-MEAN sched_debug.cpu#38.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1946 ±  1%     +15.1%       2240 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>       1946           +15.1%       2240        GEO-MEAN uptime.idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        153 ± 33%     +52.3%        233 ± 20%  ivb42/ebizzy/performance-50%-100x-10s
>        152           +52.3%        232        GEO-MEAN sched_debug.cfs_rq[12]:/.blocked_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     668434 ±  4%     -17.5%     551164 ± 12%  ivb42/ebizzy/performance-50%-100x-10s
>     668433           -17.5%     551164        GEO-MEAN sched_debug.cpu#37.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5316 ± 31%     +57.6%       8376 ± 26%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     884511 ±  1%     -10.9%     788238 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      68572           +18.5%      81254        GEO-MEAN sched_debug.cpu#7.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      33.71 ± 10%     +19.5%      40.27 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      62.72 ±  6%     +15.1%      72.21 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>      45.98           +17.3%      53.93        GEO-MEAN perf-profile.cpu-cycles.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write.sys_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     240644 ±  4%     -10.7%     214983 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     240644           -10.7%     214983        GEO-MEAN sched_debug.cfs_rq[27]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     343906 ±  3%      -8.1%     315903 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     343906            -8.1%     315903        GEO-MEAN sched_debug.cpu#37.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2115995 ±  0%     -11.9%    1863524 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2115994           -11.9%    1863523        GEO-MEAN proc-vmstat.numa_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    2122348 ±  0%     -11.9%    1869613 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    2122348           -11.9%    1869613        GEO-MEAN proc-vmstat.numa_hit
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        604 ±  6%     -10.5%        541 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>        604           -10.5%        540        GEO-MEAN sched_debug.cfs_rq[15]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     276025 ±  2%     -14.9%     234860 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>     276025           -14.9%     234860        GEO-MEAN sched_debug.cfs_rq[40]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6732351 ±  2%     -14.9%    5729702 ± 10%  ivb42/ebizzy/performance-50%-100x-10s
>    6732351           -14.9%    5729702        GEO-MEAN sched_debug.cfs_rq[40]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     301307 ±  4%      +8.8%     327692 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     301307            +8.8%     327692        GEO-MEAN sched_debug.cpu#13.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23540 ±  4%     +17.1%      27569 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>      23540           +17.1%      27569        GEO-MEAN sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5809119 ±  3%     -11.1%    5164063 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>   32901785 ±  1%      +8.6%   35724630 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   13824991            -1.8%   13582498        GEO-MEAN sched_debug.cfs_rq[26]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9580 ±  5%     +11.5%      10681 ±  2%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       3727 ±  0%     -10.3%       3344 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>       5975            +0.0%       5977        GEO-MEAN slabinfo.task_xstate.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        495 ±  7%     -11.4%        439 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        495           -11.4%        439        GEO-MEAN sched_debug.cfs_rq[24]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      22713 ±  7%     -11.4%      20122 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      22713           -11.4%      20121        GEO-MEAN sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      36.10 ±  9%     +17.3%      42.37 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      63.71 ±  6%     +14.6%      72.99 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      47.96           +16.0%      55.61        GEO-MEAN perf-profile.cpu-cycles.sock_aio_write.do_sync_write.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     809883 ± 27%     +39.6%    1130362 ± 16%  ivb42/hackbench/performance-100%-threads-socket
>     809883           +39.6%    1130362        GEO-MEAN sched_debug.cpu#2.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      66.69 ±  5%     +13.0%      75.33 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      66.69           +13.0%      75.33        GEO-MEAN perf-profile.cpu-cycles.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        513 ±  4%     +17.1%        601 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>        513           +17.1%        601        GEO-MEAN sched_debug.cfs_rq[3]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5371188 ±  6%     +14.5%    6151452 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>    5371188           +14.5%    6151452        GEO-MEAN sched_debug.cfs_rq[21]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     291849 ±  2%     +12.8%     329163 ±  3%  ivb42/ebizzy/performance-50%-100x-10s
>     291849           +12.8%     329163        GEO-MEAN sched_debug.cpu#14.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     124649 ±  4%      +8.9%     135753 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>     124648            +8.9%     135753        GEO-MEAN meminfo.Committed_AS
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     220313 ±  6%     +14.4%     252043 ±  6%  ivb42/ebizzy/performance-50%-100x-10s
>     220313           +14.4%     252043        GEO-MEAN sched_debug.cfs_rq[21]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  0%     +13.3%         22 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         21 ±  0%      -7.9%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         20            +2.1%         20        GEO-MEAN sched_debug.cpu#6.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      36.84 ±  9%     +16.4%      42.88 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      63.94 ±  5%     +14.4%      73.15 ±  6%  ivb42/hackbench/performance-1600%-threads-socket
>      48.53           +15.4%      56.01        GEO-MEAN perf-profile.cpu-cycles.do_sync_write.vfs_write.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     247217 ±  3%     -12.5%     216334 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     247217           -12.5%     216334        GEO-MEAN sched_debug.cfs_rq[31]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6076887 ±  4%     +14.6%    6964063 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>    6076887           +14.6%    6964063        GEO-MEAN sched_debug.cfs_rq[4]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     873852 ±  2%     -10.8%     779782 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     873852           -10.8%     779782        GEO-MEAN sched_debug.cpu#31.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     332613 ±  2%     -11.7%     293591 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     332613           -11.7%     293591        GEO-MEAN sched_debug.cpu#34.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6034414 ±  3%     -12.4%    5283623 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    6034414           -12.4%    5283623        GEO-MEAN sched_debug.cfs_rq[31]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     872491 ±  2%     -10.3%     782420 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     872491           -10.3%     782420        GEO-MEAN sched_debug.cpu#6.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     278773 ±  2%      +9.5%     305360 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     285131 ±  6%     -15.0%     242231 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     281934            -3.5%     271970        GEO-MEAN sched_debug.cfs_rq[43]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         14 ± 12%     +22.7%         18 ±  0%  ivb42/hackbench/performance-1600%-threads-socket
>         14           +22.7%         17        GEO-MEAN sched_debug.cpu#36.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         18 ±  5%     -14.3%         16 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>         18           -14.3%         15        GEO-MEAN sched_debug.cpu#26.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      67.85 ±  5%     +12.6%      76.39 ±  5%  ivb42/hackbench/performance-1600%-threads-socket
>      67.85           +12.6%      76.39        GEO-MEAN perf-profile.cpu-cycles.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27894 ±  5%     -11.3%      24750 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      14326 ±  3%      -7.6%      13231 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>      19990            -9.5%      18096        GEO-MEAN sched_debug.cpu#9.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9581 ±  5%     +11.5%      10681 ±  2%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       9581           +11.5%      10681        GEO-MEAN slabinfo.task_xstate.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23986 ±  5%     -10.6%      21444 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      23986           -10.6%      21444        GEO-MEAN slabinfo.kmalloc-128.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28074 ±  6%     -10.9%      25010 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>      14384 ±  2%     -10.9%      12817 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      20095           -10.9%      17904        GEO-MEAN sched_debug.cpu#23.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1.39 ±  2%     +11.9%       1.56 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>       1.39           +11.9%       1.56        GEO-MEAN perf-profile.cpu-cycles.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        593 ±  8%     -15.5%        501 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>        593           -15.5%        501        GEO-MEAN sched_debug.cfs_rq[7]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     863793 ±  3%     +12.2%     969283 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     863793           +12.2%     969283        GEO-MEAN sched_debug.cpu#107.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     303913 ±  3%     +13.7%     345451 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     303913           +13.7%     345451        GEO-MEAN sched_debug.cpu#17.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     244221 ±  1%      +8.7%     265370 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>     244221            +8.7%     265370        GEO-MEAN sched_debug.cfs_rq[11]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    5955487 ±  2%      +8.7%    6472486 ±  5%  ivb42/ebizzy/performance-50%-100x-10s
>    5955487            +8.7%    6472486        GEO-MEAN sched_debug.cfs_rq[11]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      24029 ±  5%     -10.7%      21463 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>      24029           -10.7%      21463        GEO-MEAN slabinfo.kmalloc-128.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2677 ±  2%     +10.5%       2957 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       2818 ±  2%      +8.5%       3057 ±  4%  ivb42/hackbench/performance-1600%-threads-socket
>       2746            +9.5%       3006        GEO-MEAN slabinfo.signal_cache.active_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     264668 ±  2%      +9.0%     288425 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     264668            +9.0%     288425        GEO-MEAN sched_debug.cfs_rq[2]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     869839 ±  3%     +10.9%     964876 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     869839           +10.9%     964876        GEO-MEAN sched_debug.cpu#114.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6459224 ±  2%      +8.9%    7036571 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>    6459224            +8.9%    7036571        GEO-MEAN sched_debug.cfs_rq[2]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     295316 ±  5%     +12.9%     333345 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>     295316           +12.9%     333345        GEO-MEAN sched_debug.cpu#20.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      14692 ±  1%     -10.8%      13111 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>      14692           -10.8%      13111        GEO-MEAN sched_debug.cpu#10.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       5361 ±  5%     +33.2%       7141 ± 21%  ivb42/ebizzy/performance-50%-100x-10s
>     882178 ±  2%      -8.7%     805480 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>      68774           +10.3%      75841        GEO-MEAN sched_debug.cpu#26.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  8%     -15.3%         16 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         19           -15.3%         16        GEO-MEAN sched_debug.cpu#33.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         16 ± 13%     +22.9%         19 ±  8%  ivb42/hackbench/performance-1600%-threads-socket
>         15           +22.9%         19        GEO-MEAN sched_debug.cpu#23.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        512 ±  8%     +13.4%        580 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>        511           +13.4%        580        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_runnable_contrib
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     340066 ±  2%     -12.4%     298050 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     340066           -12.4%     298050        GEO-MEAN sched_debug.cpu#41.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     864616 ±  4%     +11.7%     965878 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     864616           +11.7%     965878        GEO-MEAN sched_debug.cpu#98.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      23481 ±  8%     +13.5%      26650 ±  1%  ivb42/ebizzy/performance-50%-100x-10s
>      23481           +13.5%      26649        GEO-MEAN sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      27727 ±  4%     -12.8%      24187 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>      27727           -12.8%      24187        GEO-MEAN sched_debug.cpu#21.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       1629 ±  4%     -14.7%       1389 ±  9%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1629           -14.7%       1389        GEO-MEAN sched_debug.cpu#101.sched_goidle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        595 ±  2%     -12.3%        522 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>        595           -12.3%        522        GEO-MEAN sched_debug.cfs_rq[11]:/.utilization_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     296137 ±  4%     +11.3%     329486 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>     296137           +11.3%     329486        GEO-MEAN sched_debug.cpu#19.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     292298 ±  2%      +8.3%     316492 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     292298            +8.3%     316492        GEO-MEAN sched_debug.cpu#1.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  2%     -11.5%         18 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         20           -11.5%         17        GEO-MEAN sched_debug.cpu#25.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  6%     -19.0%         17 ±  8%  ivb42/hackbench/performance-100%-threads-socket
>         21           -19.0%         17        GEO-MEAN sched_debug.cpu#3.nr_running
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  4%     -10.0%         18 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         19           -10.0%         17        GEO-MEAN sched_debug.cfs_rq[25]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         21 ±  6%     -15.9%         17 ±  7%  ivb42/ebizzy/performance-50%-100x-10s
>         21           -15.9%         17        GEO-MEAN sched_debug.cpu#32.cpu_load[2]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  2%     -11.5%         18 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>         20           -11.5%         17        GEO-MEAN sched_debug.cpu#25.cpu_load[1]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  3%     -10.9%         18 ±  3%  ivb42/hackbench/performance-50%-threads-socket
>         20           -10.9%         17        GEO-MEAN sched_debug.cpu#5.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -13.1%         17 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         20           -13.1%         17        GEO-MEAN sched_debug.cpu#25.cpu_load[0]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         17 ±  7%     +11.3%         19 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>         17           +11.3%         19        GEO-MEAN sched_debug.cfs_rq[22]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  6%     -11.5%         18 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>         20           -11.5%         17        GEO-MEAN sched_debug.cpu#35.cpu_load[4]
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     863639 ±  5%     +12.7%     973188 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     863639           +12.7%     973188        GEO-MEAN sched_debug.cpu#111.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     887828 ±  2%      +9.8%     974669 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     887828            +9.8%     974669        GEO-MEAN sched_debug.cpu#108.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      45906 ±  4%      -7.3%      42564 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      45906            -7.3%      42563        GEO-MEAN proc-vmstat.nr_slab_unreclaimable
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     878539 ±  3%     +10.0%     966188 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     878539           +10.0%     966188        GEO-MEAN sched_debug.cpu#105.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     882058 ±  4%      +9.2%     962926 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     882058            +9.2%     962926        GEO-MEAN sched_debug.cpu#115.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     183127 ±  4%      -7.0%     170358 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>     183127            -7.0%     170358        GEO-MEAN meminfo.SUnreclaim
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.38 ±  1%     +12.1%       2.67 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>       2.38           +12.1%       2.67        GEO-MEAN perf-profile.cpu-cycles.__fdget_pos.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6169346 ± 12%     +17.8%    7267207 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    6169346           +17.8%    7267207        GEO-MEAN sched_debug.cfs_rq[0]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     325723 ±  2%      -9.6%     294426 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     325723            -9.6%     294426        GEO-MEAN sched_debug.cpu#28.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     641780 ±  4%     -13.1%     557691 ±  9%  ivb42/ebizzy/performance-50%-100x-10s
>     641780           -13.1%     557691        GEO-MEAN sched_debug.cpu#42.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     878266 ±  2%      +9.4%     960869 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     878265            +9.4%     960869        GEO-MEAN sched_debug.cpu#112.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     873490 ±  2%     +11.3%     972078 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     873490           +11.3%     972078        GEO-MEAN sched_debug.cpu#110.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     869768 ±  3%     +12.3%     976670 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     869768           +12.3%     976670        GEO-MEAN sched_debug.cpu#116.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    6168215 ±  3%      -8.4%    5647800 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>    6168215            -8.4%    5647800        GEO-MEAN sched_debug.cfs_rq[35]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  3%      -8.7%         19 ±  5%  ivb42/hackbench/performance-50%-threads-socket
>         20            -8.7%         18        GEO-MEAN sched_debug.cfs_rq[5]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  2%     +12.1%         21 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>         19           +12.1%         21        GEO-MEAN sched_debug.cpu#32.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         19 ±  0%     +14.0%         21 ±  7%  ivb42/hackbench/performance-100%-threads-socket
>         18           +14.0%         21        GEO-MEAN sched_debug.cfs_rq[32]:/.load
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>         20 ±  2%      -8.1%         19 ±  4%  ivb42/hackbench/performance-100%-threads-socket
>         20            -8.1%         18        GEO-MEAN sched_debug.cfs_rq[34]:/.runnable_load_avg
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     875905 ±  3%      +9.6%     960122 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     875905            +9.6%     960122        GEO-MEAN sched_debug.cpu#97.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     252344 ±  3%      -8.3%     231291 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     252344            -8.3%     231291        GEO-MEAN sched_debug.cfs_rq[35]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      28092 ±  6%     +12.8%      31678 ±  7%  ivb42/hackbench/performance-1600%-threads-socket
>      28092           +12.8%      31678        GEO-MEAN sched_debug.cpu#8.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     885542 ±  1%      +9.2%     967066 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     885542            +9.2%     967066        GEO-MEAN sched_debug.cpu#117.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     331866 ±  3%      -8.5%     303502 ±  2%  ivb42/ebizzy/performance-50%-100x-10s
>     331866            -8.5%     303502        GEO-MEAN sched_debug.cpu#25.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     883209 ±  2%     +10.3%     973864 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     883208           +10.3%     973864        GEO-MEAN sched_debug.cpu#119.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     257326 ± 11%     +17.1%     301232 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     257326           +17.1%     301232        GEO-MEAN sched_debug.cfs_rq[0]:/.exec_clock
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     877064 ±  0%      -8.9%     799209 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>     877064            -8.9%     799208        GEO-MEAN sched_debug.cpu#27.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1081809 ±  1%      -9.1%     983451 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1081809            -9.1%     983451        GEO-MEAN numa-numastat.node1.local_node
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>    1084327 ±  1%      -9.3%     983476 ±  1%  ivb42/hackbench/performance-50%-threads-socket
>    1084327            -9.3%     983475        GEO-MEAN numa-numastat.node1.numa_hit
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     866831 ±  3%     +11.9%     969612 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     866831           +11.9%     969612        GEO-MEAN sched_debug.cpu#113.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.29 ±  1%     +11.9%       2.57 ±  4%  ivb42/hackbench/performance-50%-threads-socket
>       2.29           +11.9%       2.57        GEO-MEAN perf-profile.cpu-cycles.__fget_light.__fdget_pos.sys_write.system_call_fastpath
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>   33152118 ±  2%      +7.8%   35741164 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>   33152118            +7.8%   35741164        GEO-MEAN sched_debug.cfs_rq[32]:/.min_vruntime
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     847788 ±  3%     -12.0%     746038 ±  2%  ivb42/hackbench/performance-50%-threads-socket
>     847788           -12.0%     746038        GEO-MEAN sched_debug.cpu#40.ttwu_local
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2.42 ± 10%     -15.2%       2.05 ±  5%  ivb42/hackbench/performance-100%-threads-socket
>       2.42           -15.2%       2.05        GEO-MEAN perf-profile.cpu-cycles.kmem_cache_alloc_node.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     889659 ± 30%     +30.7%    1162352 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>     889659           +30.7%    1162352        GEO-MEAN sched_debug.cpu#15.max_idle_balance_cost
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     320242 ±  2%      -8.3%     293814 ±  4%  ivb42/ebizzy/performance-50%-100x-10s
>     320241            -8.3%     293814        GEO-MEAN sched_debug.cpu#30.nr_load_updates
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     861007 ±  2%     +11.8%     962300 ±  1%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>     861007           +11.8%     962300        GEO-MEAN sched_debug.cpu#104.avg_idle
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       2762 ±  0%      +8.7%       3004 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>       2762            +8.7%       3004        GEO-MEAN slabinfo.signal_cache.num_objs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      26457 ±  6%     +10.4%      29200 ±  2%  ivb42/hackbench/performance-1600%-threads-socket
>      26457           +10.4%      29200        GEO-MEAN sched_debug.cpu#11.curr->pid
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       9.40 ±  2%     +52.1%      14.30 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>       9.40           +52.1%      14.30        GEO-MEAN turbostat.RAM_W
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     649374 ±  3%    +105.3%    1333405 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      50784 ±  4%     -32.0%      34549 ±  0%  ivb42/ebizzy/performance-50%-100x-10s
>  4.442e+08 ± 10%     +26.0%  5.596e+08 ±  1%  ivb42/hackbench/performance-100%-threads-socket
>  5.504e+08 ±  0%     -18.7%  4.477e+08 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>    9475905            +9.4%   10364881        GEO-MEAN time.involuntary_context_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>  1.349e+09 ± 18%     +35.8%  1.832e+09 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>  2.029e+09 ±  0%     -19.6%  1.632e+09 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>  1.654e+09            +4.5%  1.729e+09        GEO-MEAN time.voluntary_context_switches
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       3287 ±  1%     +47.1%       4835 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>    2984855 ± 18%     +31.9%    3935924 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>    4221419 ±  0%     -18.2%    3451963 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     346015           +16.6%     403510        GEO-MEAN vmstat.system.cs
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     527825 ± 25%     +55.6%     821385 ±  3%  ivb42/hackbench/performance-100%-threads-socket
>      57542 ±  2%      -5.1%      54624 ±  0%  ivb42/hackbench/performance-1600%-threads-socket
>    1096082 ±  1%     +11.3%    1220347 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>     321692           +18.0%     379728        GEO-MEAN vmstat.system.in
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>     135280 ±  1%      +3.5%     140039 ±  2%  ivb42/hackbench/performance-100%-threads-socket
>     328603 ±  4%     +28.0%     420733 ±  6%  ivb42/hackbench/performance-50%-threads-socket
>     210840           +15.1%     242732        GEO-MEAN time.minor_page_faults
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      19219 ±  3%      -4.1%      18425 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       1263 ±  7%     -13.1%       1097 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>        808 ±  0%     -10.7%        721 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>       2697            -9.4%       2443        GEO-MEAN time.user_time
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        327 ±  9%     +12.5%        368 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        173 ±  0%      -3.0%        168 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>        238            +4.5%        249        GEO-MEAN turbostat.Cor_W
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        409 ±  7%     +10.3%        452 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>        204 ±  0%      -1.8%        200 ±  0%  ivb42/hackbench/performance-50%-threads-socket
>        289            +4.1%        301        GEO-MEAN turbostat.Pkg_W
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      56589 ±  1%      +4.5%      59152 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      27783 ±  0%      +1.4%      28183 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>      39651            +3.0%      40830        GEO-MEAN time.system_time
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>      74.04 ±  0%      +1.6%      75.20 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>      74.04            +1.6%      75.20        GEO-MEAN turbostat.%c0
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>       8852 ±  0%      +1.6%       8992 ±  0%  brickland3/vm-scalability/performance-300s-8T-anon-cow-seq
>       4659 ±  0%      -0.9%       4618 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>       6422            +0.3%       6444        GEO-MEAN time.percent_of_cpu_this_job_got
>
> b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
> ----------------  --------------------------
>        623 ±  0%      +1.7%        633 ±  0%  ivb42/hackbench/performance-100%-threads-socket
>        623            +1.7%        633        GEO-MEAN time.elapsed_time
>
>
>         --yliu
>
>
>> Regards,
>> Vincent
>>
>> >
>> >         --yliu
>> >>
>> >> I'm going to try to reproduce the test in my local setup
>> >>
>> >> Regards,
>> >> Vincent
>> >>
>> >>
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.88 ą 25%    +209.7%       2.74 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.88          +209.7%       2.74        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt.reschedule_interrupt
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.76 ą 26%    +209.2%       2.36 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.76          +209.2%       2.36        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.76 ą 26%    +210.6%       2.35 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.76          +210.6%       2.35        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.70 ą 25%    +203.1%       2.13 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.70          +203.1%       2.13        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     243252 ą 46%    +242.5%     833240 ą 42%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     243252          +242.5%     833240        GEO-MEAN sched_debug.cfs_rq[2]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         98 ą 36%     -49.1%         50 ą 34%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         98           -49.1%         50        GEO-MEAN sched_debug.cfs_rq[18]:/.blocked_load_avg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1067752 ą 25%     +65.3%    1764542 ą 11%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1067752           +65.3%    1764542        GEO-MEAN sched_debug.cfs_rq[16]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     923375 ą 22%     +96.3%    1812750 ą 21%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     923375           +96.3%    1812750        GEO-MEAN sched_debug.cfs_rq[14]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1008818 ą 20%     +70.9%    1724167 ą 14%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1008818           +70.9%    1724167        GEO-MEAN sched_debug.cfs_rq[6]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1109100 ą 25%     +53.9%    1707190 ą 16%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1109100           +53.9%    1707190        GEO-MEAN sched_debug.cfs_rq[15]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1006499 ą 33%     +67.8%    1688436 ą 22%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1006499           +67.8%    1688436        GEO-MEAN sched_debug.cfs_rq[13]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     915637 ą 16%     +93.4%    1771080 ą 18%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     915637           +93.4%    1771080        GEO-MEAN sched_debug.cfs_rq[7]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     783024 ą 10%     +67.2%    1309563 ą 22%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     783024           +67.2%    1309563        GEO-MEAN sched_debug.cfs_rq[5]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      16155 ą  3%     +66.8%      26952 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      16155           +66.8%      26952        GEO-MEAN proc-vmstat.numa_pages_migrated
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      16155 ą  3%     +66.8%      26952 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      16155           +66.8%      26952        GEO-MEAN proc-vmstat.pgmigrate_success
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1443204 ą 24%     +51.5%    2187058 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1443204           +51.5%    2187058        GEO-MEAN sched_debug.cfs_rq[23]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.26 ą  4%     -38.0%       1.40 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.26           -38.0%       1.40        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1203841 ą 25%     +53.0%    1842451 ą 19%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1203841           +53.0%    1842451        GEO-MEAN sched_debug.cfs_rq[17]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >        119 ą 32%     -41.7%         69 ą 23%  ivb42/hackbench/performance-50%-threads-socket
>> >> >        119           -41.7%         69        GEO-MEAN sched_debug.cfs_rq[18]:/.tg_load_contrib
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1128380 ą 24%     +67.1%    1886076 ą 15%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1128380           +67.1%    1886076        GEO-MEAN sched_debug.cfs_rq[8]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      35577 ą 20%     +42.9%      50840 ą 15%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      35577           +42.9%      50840        GEO-MEAN sched_debug.cpu#11.avg_idle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       4.45 ą  4%     -35.2%       2.88 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       4.45           -35.2%       2.88        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1230679 ą  9%     +65.1%    2032295 ą 14%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1230679           +65.1%    2032295        GEO-MEAN sched_debug.cfs_rq[10]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       6.42 ą  4%     -33.1%       4.30 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       6.42           -33.1%       4.30        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       5.13 ą  4%     -33.8%       3.40 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       5.13           -33.8%       3.40        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       5.14 ą  4%     -33.8%       3.41 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       5.14           -33.8%       3.41        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.11 ą  3%     -29.1%       0.78 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.11           -29.1%       0.78        GEO-MEAN perf-profile.cpu-cycles.check_preempt_curr.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.22 ą  3%     -29.1%       0.87 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.22           -29.1%       0.87        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1357971 ą 14%     +41.3%    1918898 ą  9%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1357971           +41.3%    1918898        GEO-MEAN sched_debug.cfs_rq[9]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1304331 ą 11%     +49.2%    1946271 ą 13%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1304331           +49.2%    1946271        GEO-MEAN sched_debug.cfs_rq[11]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >        608 ą  3%     -28.7%        433 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >        608           -28.7%        433        GEO-MEAN cpuidle.POLL.usage
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     424656 ą  2%     +37.7%     584637 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     424656           +37.7%     584637        GEO-MEAN cpuidle.C6-IVT.usage
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1508175 ą 18%     +37.7%    2076043 ą 16%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1508175           +37.7%    2076043        GEO-MEAN sched_debug.cfs_rq[21]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     287269 ą  4%     +32.4%     380327 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     287268           +32.4%     380326        GEO-MEAN proc-vmstat.numa_hint_faults
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22221059 ą  1%     -25.7%   16516998 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22221059           -25.7%   16516998        GEO-MEAN sched_debug.cpu#23.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1468667 ą 15%     +43.2%    2102926 ą  9%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1468667           +43.2%    2102926        GEO-MEAN sched_debug.cfs_rq[22]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     291407 ą  4%     +31.7%     383859 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     291407           +31.7%     383859        GEO-MEAN proc-vmstat.numa_pte_updates
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20399319 ą  1%     -24.9%   15320065 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20399319           -24.9%   15320065        GEO-MEAN sched_debug.cpu#47.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21955842 ą  1%     -25.2%   16425955 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21955842           -25.2%   16425955        GEO-MEAN sched_debug.cpu#19.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21384750 ą  0%     -24.7%   16103640 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21384750           -24.7%   16103640        GEO-MEAN sched_debug.cpu#21.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19455420 ą  1%     -24.4%   14708872 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19455420           -24.4%   14708872        GEO-MEAN sched_debug.cpu#44.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.48 ą  4%     -23.7%       1.13 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.48           -23.7%       1.13        GEO-MEAN perf-profile.cpu-cycles.__switch_to
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.70 ą  5%     +27.7%       3.45 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.70           +27.7%       3.45        GEO-MEAN perf-profile.cpu-cycles.idle_cpu.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20991987 ą  0%     -24.1%   15929117 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20991987           -24.1%   15929117        GEO-MEAN sched_debug.cpu#20.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20232670 ą  1%     -24.7%   15244668 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20232670           -24.7%   15244668        GEO-MEAN sched_debug.cpu#43.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21686213 ą  1%     -24.5%   16369380 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21686213           -24.5%   16369380        GEO-MEAN sched_debug.cpu#12.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21654231 ą  1%     -24.3%   16385202 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21654231           -24.3%   16385202        GEO-MEAN sched_debug.cpu#13.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19800323 ą  1%     -24.6%   14937832 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19800323           -24.6%   14937832        GEO-MEAN sched_debug.cpu#45.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20091416 ą  0%     -24.4%   15193784 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20091416           -24.4%   15193784        GEO-MEAN sched_debug.cpu#38.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19904854 ą  1%     -24.2%   15083433 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19904854           -24.2%   15083433        GEO-MEAN sched_debug.cpu#36.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20172173 ą  0%     -24.0%   15328449 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20172173           -24.0%   15328448        GEO-MEAN sched_debug.cpu#39.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.25 ą  2%     -25.4%       0.93 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.25           -25.4%       0.93        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21661306 ą  0%     -24.2%   16411873 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21661306           -24.2%   16411873        GEO-MEAN sched_debug.cpu#14.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21896234 ą  0%     -24.2%   16598293 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21896234           -24.2%   16598293        GEO-MEAN sched_debug.cpu#15.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19221661 ą  1%     -23.7%   14665426 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19221661           -23.7%   14665426        GEO-MEAN sched_debug.cpu#40.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21058318 ą  1%     -24.2%   15959916 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21058318           -24.2%   15959916        GEO-MEAN sched_debug.cpu#17.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21754207 ą  0%     -24.2%   16487812 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21754207           -24.2%   16487812        GEO-MEAN sched_debug.cpu#22.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19963010 ą  1%     -24.1%   15143746 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19963009           -24.1%   15143746        GEO-MEAN sched_debug.cpu#37.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20748744 ą  1%     -23.7%   15832368 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20748743           -23.7%   15832368        GEO-MEAN sched_debug.cpu#16.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19955834 ą  0%     -23.9%   15189591 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19955834           -23.9%   15189591        GEO-MEAN sched_debug.cpu#46.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26674784 ą  1%     -23.1%   20500535 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26674784           -23.1%   20500535        GEO-MEAN sched_debug.cpu#22.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26689071 ą  1%     -23.1%   20511407 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26689071           -23.1%   20511407        GEO-MEAN sched_debug.cpu#22.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21264995 ą  1%     -23.6%   16250715 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21264995           -23.6%   16250715        GEO-MEAN sched_debug.cpu#18.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19641786 ą  1%     -23.5%   15029146 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19641786           -23.5%   15029146        GEO-MEAN sched_debug.cpu#42.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      26923 ą  2%     +29.2%      34786 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      26923           +29.2%      34786        GEO-MEAN cpuidle.C3-IVT.usage
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19417423 ą  1%     -23.3%   14891714 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19417423           -23.3%   14891714        GEO-MEAN sched_debug.cpu#41.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26079901 ą  0%     -22.7%   20147877 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26079901           -22.7%   20147877        GEO-MEAN sched_debug.cpu#18.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26104071 ą  0%     -22.7%   20165898 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26104071           -22.7%   20165898        GEO-MEAN sched_debug.cpu#18.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25569796 ą  0%     -21.9%   19978756 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25569796           -21.9%   19978756        GEO-MEAN sched_debug.cpu#14.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25580176 ą  0%     -21.8%   19998098 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25580176           -21.8%   19998098        GEO-MEAN sched_debug.cpu#14.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1336731 ą 24%     +41.1%    1886101 ą 10%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1336731           +41.1%    1886101        GEO-MEAN sched_debug.cfs_rq[18]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    7138831 ą  1%     -22.1%    5563134 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    7138831           -22.1%    5563134        GEO-MEAN proc-vmstat.pgfree
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    7160822 ą  1%     -22.0%    5584442 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    7160822           -22.0%    5584442        GEO-MEAN proc-vmstat.pgalloc_normal
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25705305 ą  0%     -22.1%   20026342 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25705305           -22.1%   20026342        GEO-MEAN sched_debug.cpu#15.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26577794 ą  0%     -22.0%   20738980 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26577794           -22.0%   20738980        GEO-MEAN sched_debug.cpu#23.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25887804 ą  0%     -21.3%   20372718 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25887804           -21.3%   20372718        GEO-MEAN sched_debug.cpu#19.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25686569 ą  1%     -21.6%   20148163 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25686569           -21.6%   20148163        GEO-MEAN sched_debug.cpu#13.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25905972 ą  0%     -21.3%   20386581 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25905972           -21.3%   20386581        GEO-MEAN sched_debug.cpu#19.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26595019 ą  0%     -21.8%   20795049 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26595019           -21.8%   20795049        GEO-MEAN sched_debug.cpu#23.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25682384 ą  0%     -22.1%   20009219 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25682384           -22.1%   20009218        GEO-MEAN sched_debug.cpu#15.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25625064 ą  1%     -21.6%   20086187 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25625064           -21.6%   20086187        GEO-MEAN sched_debug.cpu#13.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26289191 ą  1%     -21.5%   20639754 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26289191           -21.5%   20639754        GEO-MEAN sched_debug.cpu#20.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26272949 ą  1%     -21.5%   20616474 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26272949           -21.5%   20616474        GEO-MEAN sched_debug.cpu#20.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25785235 ą  0%     -21.6%   20221040 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25785235           -21.6%   20221040        GEO-MEAN sched_debug.cpu#12.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25525885 ą  0%     -21.5%   20037162 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25525885           -21.5%   20037162        GEO-MEAN sched_debug.cpu#17.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25575741 ą  0%     -21.4%   20104812 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25575741           -21.4%   20104812        GEO-MEAN sched_debug.cpu#17.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25842972 ą  0%     -21.5%   20284708 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25842972           -21.5%   20284708        GEO-MEAN sched_debug.cpu#12.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25395850 ą  0%     -21.3%   19996864 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25395850           -21.3%   19996864        GEO-MEAN sched_debug.cpu#16.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25385835 ą  0%     -21.3%   19979026 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25385835           -21.3%   19979026        GEO-MEAN sched_debug.cpu#16.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26295715 ą  1%     -21.6%   20610286 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26295715           -21.6%   20610286        GEO-MEAN sched_debug.cpu#21.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26311333 ą  1%     -21.6%   20632524 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26311333           -21.6%   20632524        GEO-MEAN sched_debug.cpu#21.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30824379 ą  1%     -20.1%   24621183 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30824379           -20.1%   24621183        GEO-MEAN sched_debug.cpu#42.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30849469 ą  1%     -20.1%   24636230 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30849469           -20.1%   24636230        GEO-MEAN sched_debug.cpu#42.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31513770 ą  0%     -20.1%   25180158 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31513770           -20.1%   25180158        GEO-MEAN sched_debug.cpu#46.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31530459 ą  0%     -20.1%   25191647 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31530459           -20.1%   25191647        GEO-MEAN sched_debug.cpu#46.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      31534 ą 13%     +41.8%      44720 ą 14%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      31534           +41.8%      44720        GEO-MEAN sched_debug.cpu#38.avg_idle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3311434 ą  8%     +19.3%    3950522 ą 12%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3311434           +19.3%    3950522        GEO-MEAN sched_debug.cfs_rq[46]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25599960 ą  0%     -19.5%   20605928 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25599960           -19.5%   20605928        GEO-MEAN sched_debug.cpu#0.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25587783 ą  0%     -19.5%   20590387 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25587783           -19.5%   20590387        GEO-MEAN sched_debug.cpu#0.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30196745 ą  1%     -19.4%   24347741 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30196745           -19.4%   24347740        GEO-MEAN sched_debug.cpu#41.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2845181 ą 10%     +25.9%    3581780 ą  9%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2845181           +25.9%    3581780        GEO-MEAN sched_debug.cfs_rq[40]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30227050 ą  1%     -19.3%   24406165 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30227049           -19.3%   24406164        GEO-MEAN sched_debug.cpu#41.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30720180 ą  0%     -19.4%   24772598 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30720180           -19.4%   24772598        GEO-MEAN sched_debug.cpu#36.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30769646 ą  1%     -19.3%   24823365 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30769646           -19.3%   24823365        GEO-MEAN sched_debug.cpu#36.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30527777 ą  1%     -19.2%   24677022 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30527776           -19.2%   24677022        GEO-MEAN sched_debug.cpu#37.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      22044 ą  1%     +25.8%      27733 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      22044           +25.8%      27733        GEO-MEAN cpuidle.C1E-IVT.usage
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3387494 ą  6%     +16.9%    3960647 ą  7%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3387494           +16.9%    3960647        GEO-MEAN sched_debug.cfs_rq[33]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31508807 ą  0%     -19.2%   25447218 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31508807           -19.2%   25447218        GEO-MEAN sched_debug.cpu#47.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30884674 ą  0%     -18.7%   25097824 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30884674           -18.7%   25097824        GEO-MEAN sched_debug.cpu#24.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31529669 ą  0%     -19.1%   25504070 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31529669           -19.1%   25504070        GEO-MEAN sched_debug.cpu#47.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30891431 ą  0%     -18.7%   25116019 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30891431           -18.7%   25116019        GEO-MEAN sched_debug.cpu#24.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2877453 ą  6%     +25.4%    3608032 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2877453           +25.4%    3608032        GEO-MEAN sched_debug.cfs_rq[26]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30686015 ą  0%     -19.0%   24852515 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30686015           -19.0%   24852515        GEO-MEAN sched_debug.cpu#43.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30567772 ą  1%     -19.1%   24719285 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30567772           -19.1%   24719285        GEO-MEAN sched_debug.cpu#37.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30700393 ą  0%     -19.0%   24871670 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30700393           -19.0%   24871669        GEO-MEAN sched_debug.cpu#43.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25429518 ą  0%     -19.0%   20597694 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25429518           -19.0%   20597693        GEO-MEAN sched_debug.cpu#1.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30426640 ą  0%     -18.9%   24661763 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30426640           -18.9%   24661762        GEO-MEAN sched_debug.cpu#38.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25437824 ą  0%     -19.0%   20602002 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25437824           -19.0%   20602002        GEO-MEAN sched_debug.cpu#1.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30443857 ą  0%     -18.9%   24679394 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30443857           -18.9%   24679394        GEO-MEAN sched_debug.cpu#38.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3170186 ą 12%     +20.8%    3830642 ą  8%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3170186           +20.8%    3830642        GEO-MEAN sched_debug.cfs_rq[41]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30345040 ą  1%     -18.8%   24632965 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30345040           -18.8%   24632965        GEO-MEAN sched_debug.cpu#39.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30316596 ą  1%     -18.8%   24607293 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30316596           -18.8%   24607293        GEO-MEAN sched_debug.cpu#39.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   29982666 ą  0%     -18.4%   24458570 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   29982666           -18.4%   24458570        GEO-MEAN sched_debug.cpu#40.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   29960708 ą  0%     -18.4%   24438001 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   29960708           -18.4%   24438001        GEO-MEAN sched_debug.cpu#40.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31047087 ą  1%     -19.2%   25085514 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31047087           -19.2%   25085514        GEO-MEAN sched_debug.cpu#45.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31032942 ą  1%     -19.2%   25067720 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31032942           -19.2%   25067720        GEO-MEAN sched_debug.cpu#45.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25578650 ą  1%     -18.4%   20864649 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25578650           -18.4%   20864649        GEO-MEAN sched_debug.cpu#4.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.53 ą  3%     +23.0%       1.88 ą  7%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.53           +23.0%       1.88        GEO-MEAN perf-profile.cpu-cycles.fput.system_call_fastpath
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25532967 ą  1%     -18.3%   20857796 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25532967           -18.3%   20857796        GEO-MEAN sched_debug.cpu#4.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3155171 ą  2%     +19.0%    3753143 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3155171           +19.0%    3753143        GEO-MEAN sched_debug.cfs_rq[31]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26700103 ą  1%     -19.1%   21595767 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26700103           -19.1%   21595767        GEO-MEAN sched_debug.cpu#9.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26710729 ą  1%     -19.1%   21602428 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26710729           -19.1%   21602428        GEO-MEAN sched_debug.cpu#9.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31156436 ą  0%     -18.7%   25325830 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31156435           -18.7%   25325830        GEO-MEAN sched_debug.cpu#44.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31140524 ą  0%     -18.8%   25300128 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31140524           -18.8%   25300128        GEO-MEAN sched_debug.cpu#44.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26524961 ą  0%     -17.8%   21793394 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26524961           -17.8%   21793394        GEO-MEAN sched_debug.cpu#10.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3335586 ą  3%     +22.0%    4070327 ą  8%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3335586           +22.0%    4070327        GEO-MEAN sched_debug.cfs_rq[34]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25755165 ą  0%     -18.0%   21119793 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25755165           -18.0%   21119793        GEO-MEAN sched_debug.cpu#6.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25808917 ą  0%     -18.1%   21133286 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25808917           -18.1%   21133286        GEO-MEAN sched_debug.cpu#6.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31373706 ą  0%     -18.0%   25734789 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31373706           -18.0%   25734789        GEO-MEAN sched_debug.cpu#33.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31356060 ą  0%     -17.9%   25728656 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31356060           -17.9%   25728656        GEO-MEAN sched_debug.cpu#33.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26544024 ą  0%     -17.7%   21833203 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26544024           -17.7%   21833203        GEO-MEAN sched_debug.cpu#10.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26226903 ą  1%     -17.9%   21539753 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26226903           -17.9%   21539753        GEO-MEAN sched_debug.cpu#8.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26216240 ą  1%     -17.9%   21529356 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26216240           -17.9%   21529356        GEO-MEAN sched_debug.cpu#8.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26008985 ą  0%     -17.3%   21498163 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26008985           -17.3%   21498162        GEO-MEAN sched_debug.cpu#7.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25640553 ą  0%     -18.0%   21025853 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25640553           -18.0%   21025853        GEO-MEAN sched_debug.cpu#5.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25624862 ą  0%     -18.0%   21018684 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25624862           -18.0%   21018684        GEO-MEAN sched_debug.cpu#5.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26021354 ą  0%     -17.3%   21510179 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26021354           -17.3%   21510179        GEO-MEAN sched_debug.cpu#7.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     254353 ą  4%     +18.7%     302028 ą  7%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     254353           +18.7%     302028        GEO-MEAN proc-vmstat.numa_hint_faults_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25398742 ą  1%     -18.1%   20807675 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25398742           -18.1%   20807675        GEO-MEAN sched_debug.cpu#3.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25405187 ą  1%     -18.1%   20818635 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25405187           -18.1%   20818635        GEO-MEAN sched_debug.cpu#3.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     881319 ą  1%     -16.5%     735645 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     881319           -16.5%     735645        GEO-MEAN sched_debug.cpu#19.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30533255 ą  0%     -17.4%   25208231 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30533255           -17.4%   25208231        GEO-MEAN sched_debug.cpu#25.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26692010 ą  0%     -17.7%   21973527 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26692010           -17.7%   21973527        GEO-MEAN sched_debug.cpu#11.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   26676971 ą  0%     -17.7%   21964784 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   26676971           -17.7%   21964784        GEO-MEAN sched_debug.cpu#11.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30548238 ą  0%     -17.4%   25222173 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30548238           -17.4%   25222173        GEO-MEAN sched_debug.cpu#25.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30313545 ą  1%     -17.1%   25125827 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30313545           -17.1%   25125827        GEO-MEAN sched_debug.cpu#26.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30325190 ą  1%     -17.1%   25139575 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30325190           -17.1%   25139575        GEO-MEAN sched_debug.cpu#26.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30298989 ą  0%     -17.1%   25132450 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30298989           -17.1%   25132450        GEO-MEAN sched_debug.cpu#28.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30364476 ą  0%     -17.2%   25142879 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30364476           -17.2%   25142879        GEO-MEAN sched_debug.cpu#28.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       3.63 ą  3%     +17.9%       4.29 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       3.63           +17.9%       4.29        GEO-MEAN perf-profile.cpu-cycles.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     885971 ą  1%     -17.6%     730417 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     885971           -17.6%     730417        GEO-MEAN sched_debug.cpu#22.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.61 ą  1%     -14.9%       1.37 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.61           -14.9%       1.37        GEO-MEAN perf-profile.cpu-cycles.pick_next_task_fair.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1487383 ą  1%     -17.0%    1233892 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1487383           -17.0%    1233892        GEO-MEAN sched_debug.cpu#22.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     873433 ą  1%     -15.8%     735098 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     873433           -15.8%     735098        GEO-MEAN sched_debug.cpu#12.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25242747 ą  1%     -18.0%   20695565 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25242747           -18.0%   20695565        GEO-MEAN sched_debug.cpu#2.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   25252993 ą  1%     -18.0%   20700339 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   25252993           -18.0%   20700338        GEO-MEAN sched_debug.cpu#2.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     876946 ą  1%     -16.9%     728531 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     876946           -16.9%     728531        GEO-MEAN sched_debug.cpu#21.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30929790 ą  1%     -16.7%   25766295 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30929790           -16.7%   25766295        GEO-MEAN sched_debug.cpu#32.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30944860 ą  1%     -16.7%   25778928 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30944860           -16.7%   25778928        GEO-MEAN sched_debug.cpu#32.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31340929 ą  0%     -16.7%   26094438 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31340929           -16.7%   26094438        GEO-MEAN sched_debug.cpu#34.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31354076 ą  0%     -16.7%   26120882 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31354075           -16.7%   26120882        GEO-MEAN sched_debug.cpu#34.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       3.01 ą  2%     -18.4%       2.46 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       3.01           -18.4%       2.46        GEO-MEAN perf-profile.cpu-cycles.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     884857 ą  0%     -16.3%     741031 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     884857           -16.3%     741031        GEO-MEAN sched_debug.cpu#23.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22693545 ą  0%     -16.6%   18915402 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22693545           -16.6%   18915402        GEO-MEAN sched_debug.cpu#11.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30424082 ą  0%     -16.8%   25305405 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30424082           -16.8%   25305405        GEO-MEAN sched_debug.cpu#30.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30485250 ą  0%     -16.9%   25323543 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30485250           -16.9%   25323542        GEO-MEAN sched_debug.cpu#30.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30917867 ą  0%     -16.9%   25707653 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30917867           -16.9%   25707653        GEO-MEAN sched_debug.cpu#31.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30924268 ą  0%     -16.8%   25716265 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30924268           -16.8%   25716265        GEO-MEAN sched_debug.cpu#31.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30468014 ą  1%     -17.2%   25213426 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30468014           -17.2%   25213426        GEO-MEAN sched_debug.cpu#27.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30477512 ą  1%     -17.2%   25229055 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30477512           -17.2%   25229055        GEO-MEAN sched_debug.cpu#27.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30130205 ą  0%     -16.7%   25101385 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30130205           -16.7%   25101385        GEO-MEAN sched_debug.cpu#29.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22458882 ą  0%     -16.7%   18703491 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22458882           -16.7%   18703491        GEO-MEAN sched_debug.cpu#10.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   30140313 ą  0%     -16.7%   25115800 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   30140313           -16.7%   25115800        GEO-MEAN sched_debug.cpu#29.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     868193 ą  1%     -15.6%     732542 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     868193           -15.6%     732542        GEO-MEAN sched_debug.cpu#13.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1374659 ą 25%     +37.8%    1894017 ą  8%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1374659           +37.8%    1894017        GEO-MEAN sched_debug.cfs_rq[19]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20829936 ą  0%     -17.0%   17279112 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20829936           -17.0%   17279112        GEO-MEAN sched_debug.cpu#35.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1418996 ą  0%     -16.4%    1186744 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1418996           -16.4%    1186744        GEO-MEAN sched_debug.cpu#16.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31557915 ą  0%     -16.4%   26383001 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31557915           -16.4%   26383001        GEO-MEAN sched_debug.cpu#35.nr_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   31570143 ą  0%     -16.4%   26389314 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   31570143           -16.4%   26389314        GEO-MEAN sched_debug.cpu#35.sched_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1420038 ą  1%     -16.0%    1193250 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1420038           -16.0%    1193250        GEO-MEAN sched_debug.cpu#13.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1450656 ą  1%     -17.1%    1202921 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1450656           -17.1%    1202921        GEO-MEAN sched_debug.cpu#18.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20626695 ą  0%     -16.6%   17207030 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20626695           -16.6%   17207030        GEO-MEAN sched_debug.cpu#31.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22476314 ą  1%     -16.3%   18802789 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22476314           -16.3%   18802789        GEO-MEAN sched_debug.cpu#7.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20008939 ą  0%     -15.6%   16896437 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20008939           -15.6%   16896437        GEO-MEAN sched_debug.cpu#32.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1447302 ą  0%     -16.4%    1210584 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1447302           -16.4%    1210584        GEO-MEAN sched_debug.cpu#19.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1429701 ą  1%     -16.2%    1198182 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1429701           -16.2%    1198181        GEO-MEAN sched_debug.cpu#15.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     872462 ą  0%     -15.4%     737745 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     872462           -15.4%     737745        GEO-MEAN sched_debug.cpu#15.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.53 ą  3%     -16.4%       1.28 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.53           -16.4%       1.28        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20534273 ą  1%     -15.8%   17284516 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20534273           -15.8%   17284516        GEO-MEAN sched_debug.cpu#25.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20560704 ą  0%     -16.2%   17227893 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20560704           -16.2%   17227893        GEO-MEAN sched_debug.cpu#34.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     862442 ą  0%     -15.1%     732316 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     862442           -15.1%     732316        GEO-MEAN sched_debug.cpu#14.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1443239 ą  0%     -16.5%    1205709 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1443239           -16.5%    1205709        GEO-MEAN sched_debug.cpu#12.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.98 ą  3%     +20.0%       1.18 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.98           +20.0%       1.18        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1487380 ą  1%     -16.3%    1244520 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1487380           -16.3%    1244520        GEO-MEAN sched_debug.cpu#23.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >  1.356e+08 ą  0%     -15.5%  1.147e+08 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >  1.356e+08           -15.5%  1.147e+08        GEO-MEAN cpuidle.C1-IVT.usage
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20314951 ą  0%     -15.6%   17140944 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20314951           -15.6%   17140944        GEO-MEAN sched_debug.cpu#30.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1473950 ą  1%     -16.2%    1235367 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1473950           -16.2%    1235367        GEO-MEAN sched_debug.cpu#20.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     867410 ą  1%     -15.8%     730524 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     867410           -15.8%     730524        GEO-MEAN sched_debug.cpu#20.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.33 ą  2%     -16.4%       1.11 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.33           -16.4%       1.11        GEO-MEAN perf-profile.cpu-cycles.__sched_text_start.schedule_user.sysret_careful
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1472841 ą  1%     -15.7%    1241382 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1472841           -15.7%    1241382        GEO-MEAN sched_debug.cpu#21.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1423709 ą  0%     -15.8%    1198274 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1423709           -15.8%    1198274        GEO-MEAN sched_debug.cpu#17.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     851770 ą  0%     -15.3%     721480 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     851770           -15.3%     721480        GEO-MEAN sched_debug.cpu#17.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.40 ą  2%     -16.1%       1.17 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.40           -16.1%       1.17        GEO-MEAN perf-profile.cpu-cycles.sysret_careful
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21736276 ą  0%     -15.7%   18334370 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21736276           -15.7%   18334370        GEO-MEAN sched_debug.cpu#8.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1417611 ą  1%     -16.1%    1189420 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1417611           -16.1%    1189420        GEO-MEAN sched_debug.cpu#14.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20609132 ą  0%     -15.8%   17362846 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20609132           -15.8%   17362846        GEO-MEAN sched_debug.cpu#26.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22069167 ą  0%     -15.4%   18674407 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22069167           -15.4%   18674407        GEO-MEAN sched_debug.cpu#6.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2820456 ą  4%     +23.4%    3479484 ą  7%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2820456           +23.4%    3479484        GEO-MEAN sched_debug.cfs_rq[27]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20618809 ą  0%     -15.7%   17385264 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20618809           -15.7%   17385264        GEO-MEAN sched_debug.cpu#27.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19897448 ą  1%     -15.2%   16867976 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19897448           -15.2%   16867976        GEO-MEAN sched_debug.cpu#29.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22444826 ą  1%     -14.2%   19266125 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22444826           -14.2%   19266125        GEO-MEAN sched_debug.cpu#0.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3341263 ą 11%     +20.3%    4019480 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3341263           +20.3%    4019480        GEO-MEAN sched_debug.cfs_rq[45]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22509799 ą  0%     -15.2%   19080882 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22509799           -15.2%   19080882        GEO-MEAN sched_debug.cpu#2.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22483652 ą  1%     -15.0%   19119883 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22483652           -15.0%   19119883        GEO-MEAN sched_debug.cpu#1.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20020943 ą  0%     -14.5%   17120192 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20020943           -14.5%   17120192        GEO-MEAN sched_debug.cpu#33.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21609616 ą  0%     -14.6%   18459478 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21609616           -14.6%   18459478        GEO-MEAN sched_debug.cpu#5.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   19520181 ą  0%     -14.6%   16662350 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   19520181           -14.6%   16662349        GEO-MEAN sched_debug.cpu#28.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.37 ą  3%     -15.6%       1.15 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.37           -15.6%       1.15        GEO-MEAN perf-profile.cpu-cycles.schedule_user.sysret_careful
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   22662241 ą  0%     -15.3%   19188484 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   22662241           -15.3%   19188484        GEO-MEAN sched_debug.cpu#3.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     866621 ą  1%     -15.9%     728734 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     866621           -15.9%     728734        GEO-MEAN sched_debug.cpu#18.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1039319 ą  1%     -14.8%     885271 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1039319           -14.8%     885271        GEO-MEAN numa-numastat.node0.local_node
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21798079 ą  1%     -14.6%   18621574 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21798079           -14.6%   18621574        GEO-MEAN sched_debug.cpu#9.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3043317 ą  9%     +25.3%    3814417 ą 13%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3043317           +25.3%    3814417        GEO-MEAN sched_debug.cfs_rq[38]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   20231936 ą  0%     -13.8%   17436914 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   20231936           -13.8%   17436914        GEO-MEAN sched_debug.cpu#24.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  4%     -10.7%         18 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20           -10.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[0]
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  3%      -9.8%         18 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20            -9.8%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[1]
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       0.92 ą  3%     +16.1%       1.07 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       0.92           +16.1%       1.07        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >   21278578 ą  0%     -14.0%   18299464 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >   21278578           -14.0%   18299464        GEO-MEAN sched_debug.cpu#4.ttwu_count
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1043155 ą  1%     -14.6%     891335 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1043155           -14.6%     891335        GEO-MEAN numa-numastat.node0.numa_hit
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860946 ą  1%     -13.4%     745561 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860946           -13.4%     745561        GEO-MEAN sched_debug.cpu#45.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     846804 ą  1%     -14.7%     722316 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     846804           -14.7%     722316        GEO-MEAN sched_debug.cpu#16.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3100432 ą 12%     +22.4%    3793805 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3100432           +22.4%    3793805        GEO-MEAN sched_debug.cfs_rq[37]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860253 ą  1%     -13.1%     747838 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860253           -13.1%     747838        GEO-MEAN sched_debug.cpu#44.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2896486 ą  7%     +19.6%    3463508 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2896486           +19.6%    3463508        GEO-MEAN sched_debug.cfs_rq[25]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     871677 ą  0%     -13.2%     756998 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     871677           -13.2%     756998        GEO-MEAN sched_debug.cpu#47.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3230592 ą  8%     +14.9%    3712705 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3230592           +14.9%    3712705        GEO-MEAN sched_debug.cfs_rq[30]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       3.91 ą  1%     -14.3%       3.35 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       3.91           -14.3%       3.35        GEO-MEAN perf-profile.cpu-cycles.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start.schedule
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860005 ą  1%     -12.9%     748893 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860005           -12.9%     748893        GEO-MEAN sched_debug.cpu#42.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3321870 ą  7%     +14.8%    3811901 ą  7%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3321870           +14.8%    3811901        GEO-MEAN sched_debug.cfs_rq[47]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14483 ą  2%     -11.5%      12813 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14483           -11.5%      12813        GEO-MEAN sched_debug.cpu#7.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14.50 ą  1%     -13.3%      12.57 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14.50           -13.3%      12.57        GEO-MEAN perf-profile.cpu-cycles.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3234028 ą  9%     +15.2%    3724307 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3234028           +15.2%    3724307        GEO-MEAN sched_debug.cfs_rq[39]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     863531 ą  1%     -12.4%     756423 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     863531           -12.4%     756423        GEO-MEAN sched_debug.cpu#46.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3276492 ą  5%     +15.5%    3784016 ą  8%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3276492           +15.5%    3784016        GEO-MEAN sched_debug.cfs_rq[35]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860124 ą  0%     -12.8%     750152 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860124           -12.8%     750152        GEO-MEAN sched_debug.cpu#38.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       4.32 ą  2%     +13.3%       4.90 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       4.32           +13.3%       4.90        GEO-MEAN perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       4025 ą  6%      -8.3%       3691 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       4025            -8.3%       3691        GEO-MEAN slabinfo.RAW.num_objs
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     859082 ą  1%     -12.0%     756012 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     859082           -12.0%     756012        GEO-MEAN sched_debug.cpu#37.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     870131 ą  1%     -13.0%     757186 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     870131           -13.0%     757185        GEO-MEAN sched_debug.cpu#43.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14.53 ą  1%     -12.9%      12.66 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14.53           -12.9%      12.66        GEO-MEAN perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14.75 ą  1%     -12.6%      12.89 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14.75           -12.6%      12.89        GEO-MEAN perf-profile.cpu-cycles.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     870275 ą  1%     -13.3%     754578 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     870275           -13.3%     754578        GEO-MEAN sched_debug.cpu#36.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       3989 ą  5%      -8.8%       3639 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       3989            -8.8%       3639        GEO-MEAN slabinfo.RAW.active_objs
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.03 ą  1%     -13.2%       0.89 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.03           -13.2%       0.89        GEO-MEAN perf-profile.cpu-cycles.skb_unlink.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     885844 ą  1%     -11.8%     780892 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     885844           -11.8%     780892        GEO-MEAN sched_debug.cpu#10.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     895578 ą  2%     -11.5%     792265 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     895578           -11.5%     792265        GEO-MEAN sched_debug.cpu#11.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     883237 ą  2%     -11.9%     777826 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     883237           -11.9%     777826        GEO-MEAN sched_debug.cpu#1.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2115995 ą  0%     -11.9%    1863524 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2115994           -11.9%    1863523        GEO-MEAN proc-vmstat.numa_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    2122348 ą  0%     -11.9%    1869613 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    2122348           -11.9%    1869613        GEO-MEAN proc-vmstat.numa_hit
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.57 ą  4%     +13.8%       2.92 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.57           +13.8%       2.92        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1406705 ą  1%     -10.8%    1254824 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1406705           -10.8%    1254824        GEO-MEAN sched_debug.cpu#0.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      15.05 ą  1%     -11.8%      13.27 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      15.05           -11.8%      13.27        GEO-MEAN perf-profile.cpu-cycles.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     879602 ą  1%     -11.5%     778421 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     879602           -11.5%     778421        GEO-MEAN sched_debug.cpu#8.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     884715 ą  2%     -11.6%     782521 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     884714           -11.6%     782521        GEO-MEAN sched_debug.cpu#9.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     869234 ą  1%     -10.1%     781750 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     869234           -10.1%     781749        GEO-MEAN sched_debug.cpu#3.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      13928 ą  3%     -10.0%      12532 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      13928           -10.0%      12531        GEO-MEAN sched_debug.cpu#34.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.65 ą  3%     -11.9%       1.45 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.65           -11.9%       1.45        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_reserve.isra.26.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860847 ą  2%     -11.2%     764541 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860847           -11.2%     764541        GEO-MEAN sched_debug.cpu#39.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     839076 ą  1%     -11.6%     741571 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     839076           -11.6%     741571        GEO-MEAN sched_debug.cpu#41.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     875043 ą  2%     -10.0%     787246 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     875042           -10.0%     787246        GEO-MEAN sched_debug.cpu#34.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      23.87 ą  1%     -10.7%      21.31 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      23.87           -10.7%      21.31        GEO-MEAN perf-profile.cpu-cycles.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write.do_sync_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       4.45 ą  1%     -11.6%       3.93 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       4.45           -11.6%       3.93        GEO-MEAN perf-profile.cpu-cycles.deactivate_task.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     873852 ą  2%     -10.8%     779782 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     873852           -10.8%     779782        GEO-MEAN sched_debug.cpu#31.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     872491 ą  2%     -10.3%     782420 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     872491           -10.3%     782420        GEO-MEAN sched_debug.cpu#6.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.11 ą  7%     -12.5%       0.97 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.11           -12.5%       0.97        GEO-MEAN perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_read.sys_read
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       8.05 ą  2%     -12.5%       7.04 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       8.05           -12.5%       7.04        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.36 ą  3%     -11.6%       1.20 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.36           -11.6%       1.20        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     884511 ą  1%     -10.9%     788238 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     884511           -10.9%     788238        GEO-MEAN sched_debug.cpu#7.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1423158 ą  1%     -10.2%    1278070 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1423157           -10.2%    1278070        GEO-MEAN sched_debug.cpu#4.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.39 ą  2%     +11.9%       1.56 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.39           +11.9%       1.56        GEO-MEAN perf-profile.cpu-cycles.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       4.46 ą  1%     -11.2%       3.96 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       4.46           -11.2%       3.96        GEO-MEAN perf-profile.cpu-cycles.dequeue_task.deactivate_task.__sched_text_start.schedule.schedule_timeout
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     882994 ą  2%      -9.2%     801606 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     882994            -9.2%     801606        GEO-MEAN sched_debug.cpu#25.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14371 ą  1%     -10.2%      12907 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14371           -10.2%      12907        GEO-MEAN sched_debug.cpu#22.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14692 ą  1%     -10.8%      13111 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14692           -10.8%      13111        GEO-MEAN sched_debug.cpu#10.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14093 ą  3%      -9.5%      12748 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14093            -9.5%      12748        GEO-MEAN sched_debug.cpu#25.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1495572 ą  0%     -10.9%    1333271 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1495571           -10.9%    1333271        GEO-MEAN sched_debug.cpu#9.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14153 ą  3%      -9.4%      12817 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14153            -9.4%      12817        GEO-MEAN sched_debug.cpu#27.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14374 ą  1%      -9.7%      12976 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14374            -9.7%      12976        GEO-MEAN sched_debug.cpu#32.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     860018 ą  2%     -10.0%     773781 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     860018           -10.0%     773781        GEO-MEAN sched_debug.cpu#4.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     863792 ą  1%     -10.0%     777585 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     863792           -10.0%     777585        GEO-MEAN sched_debug.cpu#32.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14193 ą  2%     -10.5%      12697 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14193           -10.5%      12697        GEO-MEAN sched_debug.cpu#46.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1394923 ą  0%      -9.3%    1265094 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1394922            -9.3%    1265094        GEO-MEAN sched_debug.cpu#3.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1427072 ą  1%      -9.9%    1285217 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1427072            -9.9%    1285217        GEO-MEAN sched_debug.cpu#5.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  3%     -10.9%         18 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20           -10.9%         17        GEO-MEAN sched_debug.cpu#5.cpu_load[0]
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       1.30 ą  2%     -10.9%       1.16 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       1.30           -10.9%       1.16        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_from_iovec.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1404122 ą  0%     -10.1%    1262026 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1404122           -10.1%    1262026        GEO-MEAN sched_debug.cpu#2.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     871725 ą  3%      -9.5%     788740 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     871725            -9.5%     788740        GEO-MEAN sched_debug.cpu#35.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.62 ą  1%     +10.8%       2.90 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.62           +10.8%       2.90        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_iovec.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1440886 ą  0%     -10.0%    1296355 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1440886           -10.0%    1296355        GEO-MEAN sched_debug.cpu#6.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14332 ą  2%      -9.0%      13045 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14332            -9.0%      13045        GEO-MEAN sched_debug.cpu#33.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     882824 ą  1%     -10.1%     793313 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     882824           -10.1%     793312        GEO-MEAN sched_debug.cpu#0.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    3116277 ą  7%     +13.2%    3527174 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    3116277           +13.2%    3527174        GEO-MEAN sched_debug.cfs_rq[29]:/.spread0
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.38 ą  1%     +12.1%       2.67 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.38           +12.1%       2.67        GEO-MEAN perf-profile.cpu-cycles.__fdget_pos.sys_write.system_call_fastpath
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14095 ą  2%      -9.6%      12748 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14095            -9.6%      12748        GEO-MEAN sched_debug.cpu#12.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1499703 ą  0%      -9.7%    1354350 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1499703            -9.7%    1354350        GEO-MEAN sched_debug.cpu#10.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14050 ą  2%      -9.9%      12664 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14050            -9.9%      12664        GEO-MEAN sched_debug.cpu#47.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1493710 ą  1%     -10.0%    1344628 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1493710           -10.0%    1344628        GEO-MEAN sched_debug.cpu#11.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     882178 ą  2%      -8.7%     805480 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     882178            -8.7%     805480        GEO-MEAN sched_debug.cpu#26.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1451847 ą  1%      -9.6%    1311874 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1451847            -9.6%    1311874        GEO-MEAN sched_debug.cpu#7.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     869997 ą  1%     -10.0%     782794 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     869997           -10.0%     782794        GEO-MEAN sched_debug.cpu#2.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14168 ą  3%     -11.3%      12566 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14168           -11.3%      12565        GEO-MEAN sched_debug.cpu#44.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     863764 ą  1%      -9.4%     782356 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     863764            -9.4%     782356        GEO-MEAN sched_debug.cpu#5.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  2%      -9.7%         18 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20            -9.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[3]
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  2%      -8.7%         18 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20            -8.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[4]
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >         20 ą  3%      -8.7%         19 ą  5%  ivb42/hackbench/performance-50%-threads-socket
>> >> >         20            -8.7%         18        GEO-MEAN sched_debug.cfs_rq[5]:/.runnable_load_avg
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1471462 ą  1%      -9.5%    1331414 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1471462            -9.5%    1331414        GEO-MEAN sched_debug.cpu#8.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     877064 ą  0%      -8.9%     799209 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     877064            -8.9%     799208        GEO-MEAN sched_debug.cpu#27.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1081809 ą  1%      -9.1%     983451 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1081809            -9.1%     983451        GEO-MEAN numa-numastat.node1.local_node
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14225 ą  2%      -7.6%      13149 ą  3%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14225            -7.6%      13149        GEO-MEAN sched_debug.cpu#36.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1084327 ą  1%      -9.3%     983476 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1084327            -9.3%     983475        GEO-MEAN numa-numastat.node1.numa_hit
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       2.29 ą  1%     +11.9%       2.57 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       2.29           +11.9%       2.57        GEO-MEAN perf-profile.cpu-cycles.__fget_light.__fdget_pos.sys_write.system_call_fastpath
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     847788 ą  3%     -12.0%     746038 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     847788           -12.0%     746038        GEO-MEAN sched_debug.cpu#40.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     865949 ą  2%      -8.8%     789915 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     865949            -8.8%     789915        GEO-MEAN sched_debug.cpu#33.ttwu_local
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14384 ą  2%     -10.9%      12817 ą  2%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14384           -10.9%      12816        GEO-MEAN sched_debug.cpu#23.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1395020 ą  0%     -10.0%    1255965 ą  1%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1395020           -10.0%    1255965        GEO-MEAN sched_debug.cpu#1.sched_goidle
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >      14326 ą  3%      -7.6%      13231 ą  4%  ivb42/hackbench/performance-50%-threads-socket
>> >> >      14326            -7.6%      13231        GEO-MEAN sched_debug.cpu#9.curr->pid
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >       9.40 ą  2%     +52.1%      14.30 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >       9.40           +52.1%      14.30        GEO-MEAN turbostat.RAM_W
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >     328603 ą  4%     +28.0%     420733 ą  6%  ivb42/hackbench/performance-50%-threads-socket
>> >> >     328603           +28.0%     420732        GEO-MEAN time.minor_page_faults
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >  2.029e+09 ą  0%     -19.6%  1.632e+09 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >  2.029e+09           -19.6%  1.632e+09        GEO-MEAN time.voluntary_context_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >  5.504e+08 ą  0%     -18.7%  4.477e+08 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >  5.504e+08           -18.7%  4.477e+08        GEO-MEAN time.involuntary_context_switches
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    4221419 ą  0%     -18.2%    3451963 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    4221418           -18.2%    3451963        GEO-MEAN vmstat.system.cs
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >        808 ą  0%     -10.7%        721 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >        808           -10.7%        721        GEO-MEAN time.user_time
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >    1096082 ą  1%     +11.3%    1220347 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >    1096082           +11.3%    1220347        GEO-MEAN vmstat.system.in
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >        173 ą  0%      -3.0%        168 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >        173            -3.0%        168        GEO-MEAN turbostat.Cor_W
>> >> >
>> >> > b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f
>> >> > ----------------  --------------------------
>> >> >        204 ą  0%      -1.8%        200 ą  0%  ivb42/hackbench/performance-50%-threads-socket
>> >> >        204            -1.8%        200        GEO-MEAN turbostat.Pkg_W
>> >> >
>> >> >
>> >> > ivb42: Ivytown Ivy Bridge-EP
>> >> > Memory: 64G
>> >> >
>> >> >
>> >> > To reproduce:
>> >> >
>> >> >         apt-get install ruby ruby-oj
>> >> >         git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>> >> >         cd lkp-tests
>> >> >         bin/setup-local job.yaml # the job file attached in this email
>> >> >         bin/run-local   job.yaml
>> >> >
>> >> >
>> >> > Disclaimer:
>> >> > Results have been estimated based on internal Intel analysis and are provided
>> >> > for informational purposes only. Any difference in system hardware or software
>> >> > design or configuration may affect actual performance.
>> >> >
>> >> > _______________________________________________
>> >> > LKP mailing list
>> >> > LKP@linux.intel.com
>> >> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
