Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaHUORn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbaHUORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:17:42 -0400
Message-ID: <53F5FF2D.4010406@redhat.com>
Date: Thu, 21 Aug 2014 10:16:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [sched/fair] caeb178c60f: +252.0% cpuidle.C1-SNB.time, +3.1%
 turbostat.Pkg_W
References: <20140821140134.GB19246@localhost>
In-Reply-To: <20140821140134.GB19246@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 10:01 AM, Fengguang Wu wrote:
> Hi Rik,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
> commit caeb178c60f4f93f1b45c0bc056b5cf6d217b67f ("sched/fair: Make update_sd_pick_busiest() return 'true' on a busier sd")
> 
> testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-tcp6

Is this good or bad?

The numbers suggest the xfs + raid5 workload is doing around 2.4%
more IO to disk per second with this change in, and there is more
CPU idle time in the system...

For the tcp test, I see no throughput numbers, but I see more
idle time as well as more time in turbo mode, and more softirqs,
which could mean that more packets were handled.

Does the patch introduce any performance issues, or did it
simply trip up something in the statistics that your script
noticed?

> 743cb1ff191f00f  caeb178c60f4f93f1b45c0bc0
> ---------------  -------------------------
>   29718911 ±45%    +329.5%  1.277e+08 ±10%  cpuidle.C1E-SNB.time
>        861 ±34%   +1590.4%      14564 ±31%  cpuidle.C3-SNB.usage
>   1.65e+08 ±20%    +175.4%  4.544e+08 ±15%  cpuidle.C1-SNB.time
>         24 ±41%    +247.6%         86 ±23%  numa-numastat.node1.other_node
>      27717 ±11%     +98.7%      55085 ± 6%  softirqs.RCU
>     180767 ±11%     +86.7%     337416 ±10%  cpuidle.C7-SNB.usage
>     104591 ±14%     +77.4%     185581 ±10%  cpuidle.C1E-SNB.usage
>        384 ±10%     +33.3%        512 ±11%  slabinfo.kmem_cache.num_objs
>        384 ±10%     +33.3%        512 ±11%  slabinfo.kmem_cache.active_objs
>        494 ± 8%     +25.9%        622 ± 9%  slabinfo.kmem_cache_node.active_objs
>        512 ± 7%     +25.0%        640 ± 8%  slabinfo.kmem_cache_node.num_objs
>      83427 ± 6%     +10.3%      92028 ± 5%  meminfo.DirectMap4k
>       9508 ± 1%     +21.3%      11534 ± 7%  slabinfo.kmalloc-512.active_objs
>       9838 ± 1%     +20.5%      11852 ± 6%  slabinfo.kmalloc-512.num_objs
>      53997 ± 6%     +11.1%      59981 ± 4%  numa-meminfo.node1.Slab
>       2662 ± 3%      -9.0%       2424 ± 3%  slabinfo.kmalloc-96.active_objs
>       2710 ± 3%      -8.6%       2478 ± 3%  slabinfo.kmalloc-96.num_objs
>        921 ±41%   +3577.7%      33901 ±14%  time.involuntary_context_switches
>       2371 ± 2%     +15.5%       2739 ± 2%  vmstat.system.in
> 
> testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-tcp
> 
> 743cb1ff191f00f  caeb178c60f4f93f1b45c0bc0
> ---------------  -------------------------
>   20657207 ±31%    +358.2%   94650352 ±18%  cpuidle.C1E-SNB.time
>   29718911 ±45%    +329.5%  1.277e+08 ±10%  cpuidle.C1E-SNB.time
>        861 ±34%   +1590.4%      14564 ±31%  cpuidle.C3-SNB.usage
>       0.05 ±46%    +812.5%       0.44 ±34%  turbostat.%c3
>   1.12e+08 ±25%    +364.8%  5.207e+08 ±15%  cpuidle.C1-SNB.time
>   1.65e+08 ±20%    +175.4%  4.544e+08 ±15%  cpuidle.C1-SNB.time
>         35 ±19%    +105.6%         72 ±28%  numa-numastat.node1.other_node
>         24 ±41%    +247.6%         86 ±23%  numa-numastat.node1.other_node
>         43 ±22%     +86.2%         80 ±26%  numa-vmstat.node0.nr_dirtied
>      24576 ± 6%    +113.9%      52574 ± 1%  softirqs.RCU
>      27717 ±11%     +98.7%      55085 ± 6%  softirqs.RCU
>     211533 ± 6%     +58.4%     334990 ± 8%  cpuidle.C7-SNB.usage
>     180767 ±11%     +86.7%     337416 ±10%  cpuidle.C7-SNB.usage
>      77739 ±13%     +52.9%     118876 ±18%  cpuidle.C1E-SNB.usage
>     104591 ±14%     +77.4%     185581 ±10%  cpuidle.C1E-SNB.usage
>      32.09 ±14%     -24.8%      24.12 ±18%  turbostat.%pc2
>       9.04 ± 6%     +41.6%      12.80 ± 6%  turbostat.%c1
>        384 ±10%     +33.3%        512 ±11%  slabinfo.kmem_cache.num_objs
>        384 ±10%     +33.3%        512 ±11%  slabinfo.kmem_cache.active_objs
>        494 ± 8%     +25.9%        622 ± 9%  slabinfo.kmem_cache_node.active_objs
>        512 ± 7%     +25.0%        640 ± 8%  slabinfo.kmem_cache_node.num_objs
>        379 ± 9%     +16.7%        443 ± 7%  numa-vmstat.node0.nr_page_table_pages
>      83427 ± 6%     +10.3%      92028 ± 5%  meminfo.DirectMap4k
>       1579 ± 6%     -15.3%       1338 ± 7%  numa-meminfo.node1.PageTables
>        394 ± 6%     -15.1%        334 ± 7%  numa-vmstat.node1.nr_page_table_pages
>       1509 ± 7%     +16.6%       1760 ± 7%  numa-meminfo.node0.PageTables
>      12681 ± 1%     -17.3%      10482 ±14%  numa-meminfo.node1.AnonPages
>       3169 ± 1%     -17.3%       2620 ±14%  numa-vmstat.node1.nr_anon_pages
>      10171 ± 3%     +10.9%      11283 ± 3%  slabinfo.kmalloc-512.active_objs
>       9508 ± 1%     +21.3%      11534 ± 7%  slabinfo.kmalloc-512.active_objs
>      10481 ± 3%     +10.9%      11620 ± 3%  slabinfo.kmalloc-512.num_objs
>       9838 ± 1%     +20.5%      11852 ± 6%  slabinfo.kmalloc-512.num_objs
>      53997 ± 6%     +11.1%      59981 ± 4%  numa-meminfo.node1.Slab
>       5072 ± 1%     +11.6%       5662 ± 3%  slabinfo.kmalloc-2048.num_objs
>       4974 ± 1%     +11.6%       5551 ± 3%  slabinfo.kmalloc-2048.active_objs
>      12824 ± 2%     -16.1%      10754 ±14%  numa-meminfo.node1.Active(anon)
>       3205 ± 2%     -16.2%       2687 ±14%  numa-vmstat.node1.nr_active_anon
>       2662 ± 3%      -9.0%       2424 ± 3%  slabinfo.kmalloc-96.active_objs
>       2710 ± 3%      -8.6%       2478 ± 3%  slabinfo.kmalloc-96.num_objs
>      15791 ± 1%     +15.2%      18192 ± 9%  numa-meminfo.node0.AnonPages
>       3949 ± 1%     +15.2%       4549 ± 9%  numa-vmstat.node0.nr_anon_pages
>      13669 ± 1%      -7.5%      12645 ± 2%  slabinfo.kmalloc-16.num_objs
>        662 ±23%   +4718.6%      31918 ±12%  time.involuntary_context_switches
>        921 ±41%   +3577.7%      33901 ±14%  time.involuntary_context_switches
>       2463 ± 1%     +13.1%       2786 ± 3%  vmstat.system.in
>       2371 ± 2%     +15.5%       2739 ± 2%  vmstat.system.in
>      49.40 ± 2%      +4.8%      51.79 ± 2%  turbostat.Cor_W
>      77.48 ± 1%      +3.1%      79.91 ± 1%  turbostat.Pkg_W
> 
> testbox/testcase/testparams: lkp-st02/dd-write/5m-11HDD-RAID5-cfq-xfs-1dd
> 
> 743cb1ff191f00f  caeb178c60f4f93f1b45c0bc0
> ---------------  -------------------------
>      18571 ± 7%     +31.4%      24396 ± 4%  proc-vmstat.pgscan_direct_normal
>      39983 ± 2%     +38.3%      55286 ± 0%  perf-stat.cpu-migrations
>    4193962 ± 2%     +20.9%    5072009 ± 3%  perf-stat.iTLB-load-misses
>  4.568e+09 ± 2%     -17.2%  3.781e+09 ± 1%  perf-stat.L1-icache-load-misses
>  1.762e+10 ± 0%      -7.8%  1.625e+10 ± 1%  perf-stat.cache-references
>  1.408e+09 ± 1%      -6.6%  1.315e+09 ± 1%  perf-stat.branch-load-misses
>  1.407e+09 ± 1%      -6.5%  1.316e+09 ± 1%  perf-stat.branch-misses
>  6.839e+09 ± 1%      +5.0%  7.185e+09 ± 2%  perf-stat.LLC-loads
>  1.558e+10 ± 0%      +3.5%  1.612e+10 ± 1%  perf-stat.L1-dcache-load-misses
>  1.318e+12 ± 0%      +3.4%  1.363e+12 ± 0%  perf-stat.L1-icache-loads
>  2.979e+10 ± 1%      +2.4%  3.051e+10 ± 0%  perf-stat.L1-dcache-store-misses
>  1.893e+11 ± 0%      +2.5%   1.94e+11 ± 0%  perf-stat.branch-instructions
>  2.298e+11 ± 0%      +2.7%  2.361e+11 ± 0%  perf-stat.L1-dcache-stores
>  1.016e+12 ± 0%      +2.6%  1.042e+12 ± 0%  perf-stat.instructions
>  1.892e+11 ± 0%      +2.5%   1.94e+11 ± 0%  perf-stat.branch-loads
>   3.71e+11 ± 0%      +2.4%  3.799e+11 ± 0%  perf-stat.dTLB-loads
>  3.711e+11 ± 0%      +2.3%  3.798e+11 ± 0%  perf-stat.L1-dcache-loads
>     325768 ± 0%      +2.7%     334461 ± 0%  vmstat.io.bo
>       8083 ± 0%      +2.4%       8278 ± 0%  iostat.sdf.wrqm/s
>       8083 ± 0%      +2.4%       8278 ± 0%  iostat.sdk.wrqm/s
>       8082 ± 0%      +2.4%       8276 ± 0%  iostat.sdg.wrqm/s
>      32615 ± 0%      +2.4%      33398 ± 0%  iostat.sdf.wkB/s
>      32617 ± 0%      +2.4%      33401 ± 0%  iostat.sdk.wkB/s
>      32612 ± 0%      +2.4%      33393 ± 0%  iostat.sdg.wkB/s
>       8083 ± 0%      +2.4%       8277 ± 0%  iostat.sdl.wrqm/s
>       8083 ± 0%      +2.4%       8276 ± 0%  iostat.sdi.wrqm/s
>       8082 ± 0%      +2.4%       8277 ± 0%  iostat.sdc.wrqm/s
>      32614 ± 0%      +2.4%      33396 ± 0%  iostat.sdl.wkB/s
>       8083 ± 0%      +2.4%       8278 ± 0%  iostat.sde.wrqm/s
>       8082 ± 0%      +2.4%       8277 ± 0%  iostat.sdh.wrqm/s
>       8083 ± 0%      +2.4%       8277 ± 0%  iostat.sdd.wrqm/s
>      32614 ± 0%      +2.4%      33393 ± 0%  iostat.sdi.wkB/s
>      32611 ± 0%      +2.4%      33395 ± 0%  iostat.sdc.wkB/s
>     325759 ± 0%      +2.4%     333577 ± 0%  iostat.md0.wkB/s
>       1274 ± 0%      +2.4%       1305 ± 0%  iostat.md0.w/s
>       8082 ± 0%      +2.4%       8277 ± 0%  iostat.sdb.wrqm/s
>      32618 ± 0%      +2.4%      33398 ± 0%  iostat.sde.wkB/s
>      32612 ± 0%      +2.4%      33395 ± 0%  iostat.sdh.wkB/s
>      32618 ± 0%      +2.4%      33397 ± 0%  iostat.sdd.wkB/s
>       8084 ± 0%      +2.4%       8278 ± 0%  iostat.sdj.wrqm/s
>      32611 ± 0%      +2.4%      33396 ± 0%  iostat.sdb.wkB/s
>      32618 ± 0%      +2.4%      33400 ± 0%  iostat.sdj.wkB/s
>    2.3e+11 ± 0%      +2.5%  2.357e+11 ± 0%  perf-stat.dTLB-stores
>       4898 ± 0%      +2.1%       5003 ± 0%  vmstat.system.cs
>  1.017e+12 ± 0%      +2.4%  1.042e+12 ± 0%  perf-stat.iTLB-loads
>    1518279 ± 0%      +2.1%    1549457 ± 0%  perf-stat.context-switches
>  1.456e+12 ± 0%      +1.4%  1.476e+12 ± 0%  perf-stat.cpu-cycles
>  1.456e+12 ± 0%      +1.3%  1.475e+12 ± 0%  perf-stat.ref-cycles
>  1.819e+11 ± 0%      +1.3%  1.843e+11 ± 0%  perf-stat.bus-cycles
> 
> lkp-sb03 is a Sandy Bridge-EP server.
> Memory: 64G
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                32
> On-line CPU(s) list:   0-31
> Thread(s) per core:    2
> Core(s) per socket:    8
> Socket(s):             2
> NUMA node(s):          2
> Vendor ID:             GenuineIntel
> CPU family:            6
> Model:                 45
> Stepping:              6
> CPU MHz:               3500.613
> BogoMIPS:              5391.16
> Virtualization:        VT-x
> L1d cache:             32K
> L1i cache:             32K
> L2 cache:              256K
> L3 cache:              20480K
> NUMA node0 CPU(s):     0-7,16-23
> NUMA node1 CPU(s):     8-15,24-31
> 
> lkp-st02 is Core2
> Memory: 8G
> 
> 
> 
> 
>                           time.involuntary_context_switches
> 
>   40000 O+------------------------------------------------------------------+
>         |        O               O          O                               |
>   35000 ++O  O O        O   O             O                                 |
>   30000 ++         O                 O         O                            |
>         |                 O    O   O                                        |
>   25000 ++            O                 O                                   |
>         |                                                                   |
>   20000 ++                                                                  |
>         |                                                                   |
>   15000 ++                                                                  |
>   10000 ++                                                                  |
>         |                                                                   |
>    5000 ++                                                                  |
>         |                                                .*.                |
>       0 *+*--*-*-*-*--*-*-*-*--*-*-*-*--*-*-*--*-*-*-*--*---*-*--*-*-*-*--*-*
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Fengguang
> 

