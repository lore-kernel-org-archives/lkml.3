Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaLWJFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:05:33 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:41421 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLWJFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:05:30 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2014 04:05:29 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Huang Ying <ying.huang@intel.com>, Kirill Tkhai <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
In-Reply-To: <1419311754.26403.51.camel@intel.com>
References: <1419311754.26403.51.camel@intel.com>
Subject: Re: [LKP] [sched] a15b12ac36a: -46.9% time.voluntary_context_switches +1.5% will-it-scale.per_process_ops
MIME-Version: 1.0
Message-Id: <4750651419325033@web14h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 23 Dec 2014 11:57:13 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Huang,

what do these digits mean? What test does?

23.12.2014, 08:16, "Huang Ying" <ying.huang@intel.com>:
> FYI, we noticed the below changes on
>
> commit a15b12ac36ad4e7b856a4ae54937ae26a51aebad ("sched: Do not stop cpu in set_cpus_allowed_ptr() if task is not running")
>
> testbox/testcase/testparams: lkp-g5/will-it-scale/performance-lock1
>
> 1ba93d42727c4400  a15b12ac36ad4e7b856a4ae549
> ----------------  --------------------------
>          %stddev     %change         %stddev
>              \          |                \
>    1517261 ±  0%      +1.5%    1539994 ±  0%  will-it-scale.per_process_ops
>        247 ± 30%    +131.8%        573 ± 49%  sched_debug.cpu#61.ttwu_count
>        225 ± 22%    +142.8%        546 ± 34%  sched_debug.cpu#81.ttwu_local
>      15115 ± 44%     +37.3%      20746 ± 40%  numa-meminfo.node7.Active
>       1028 ± 38%    +115.3%       2214 ± 36%  sched_debug.cpu#16.ttwu_local
>          2 ± 19%    +133.3%          5 ± 43%  sched_debug.cpu#89.cpu_load[3]
>         21 ± 45%     +88.2%         40 ± 23%  sched_debug.cfs_rq[99]:/.tg_load_contrib
>        414 ± 33%     +98.6%        823 ± 28%  sched_debug.cpu#81.ttwu_count
>          4 ± 10%     +88.2%          8 ± 12%  sched_debug.cfs_rq[33]:/.runnable_load_avg
>         22 ± 26%     +80.9%         40 ± 24%  sched_debug.cfs_rq[103]:/.tg_load_contrib
>          7 ± 17%     -41.4%          4 ± 25%  sched_debug.cfs_rq[41]:/.load
>          7 ± 17%     -37.9%          4 ± 19%  sched_debug.cpu#41.load
>          3 ± 22%    +106.7%          7 ± 10%  sched_debug.cfs_rq[36]:/.runnable_load_avg
>        174 ± 13%     +48.7%        259 ± 31%  sched_debug.cpu#112.ttwu_count
>          4 ± 19%     +88.9%          8 ±  5%  sched_debug.cfs_rq[35]:/.runnable_load_avg
>        260 ± 10%     +55.6%        405 ± 26%  numa-vmstat.node3.nr_anon_pages
>       1042 ± 10%     +56.0%       1626 ± 26%  numa-meminfo.node3.AnonPages
>         26 ± 22%     +74.3%         45 ± 16%  sched_debug.cfs_rq[65]:/.tg_load_contrib
>         21 ± 43%     +71.3%         37 ± 26%  sched_debug.cfs_rq[100]:/.tg_load_contrib
>       3686 ± 21%     +40.2%       5167 ± 19%  sched_debug.cpu#16.ttwu_count
>        142 ±  9%     +34.4%        191 ± 24%  sched_debug.cpu#112.ttwu_local
>          5 ± 18%     +69.6%          9 ± 15%  sched_debug.cfs_rq[35]:/.load
>          2 ± 30%    +100.0%          5 ± 37%  sched_debug.cpu#106.cpu_load[1]
>          3 ± 23%    +100.0%          6 ± 48%  sched_debug.cpu#106.cpu_load[2]
>          5 ± 18%     +69.6%          9 ± 15%  sched_debug.cpu#35.load
>          9 ± 20%     +48.6%         13 ± 16%  sched_debug.cfs_rq[7]:/.runnable_load_avg
>       1727 ± 15%     +43.9%       2484 ± 30%  sched_debug.cpu#34.ttwu_local
>         10 ± 17%     -40.5%          6 ± 13%  sched_debug.cpu#41.cpu_load[0]
>         10 ± 14%     -29.3%          7 ±  5%  sched_debug.cpu#45.cpu_load[4]
>         10 ± 17%     -33.3%          7 ± 10%  sched_debug.cpu#41.cpu_load[1]
>       6121 ±  8%     +56.7%       9595 ± 30%  sched_debug.cpu#13.sched_goidle
>         13 ±  8%     -25.9%         10 ± 17%  sched_debug.cpu#39.cpu_load[2]
>         12 ± 16%     -24.0%          9 ± 15%  sched_debug.cpu#37.cpu_load[2]
>        492 ± 17%     -21.3%        387 ± 24%  sched_debug.cpu#46.ttwu_count
>       3761 ± 11%     -23.9%       2863 ± 15%  sched_debug.cpu#93.curr->pid
>        570 ± 19%     +43.2%        816 ± 17%  sched_debug.cpu#86.ttwu_count
>       5279 ±  8%     +63.5%       8631 ± 33%  sched_debug.cpu#13.ttwu_count
>        377 ± 22%     -28.6%        269 ± 14%  sched_debug.cpu#46.ttwu_local
>       5396 ± 10%     +29.9%       7007 ± 14%  sched_debug.cpu#16.sched_goidle
>       1959 ± 12%     +36.9%       2683 ± 15%  numa-vmstat.node2.nr_slab_reclaimable
>       7839 ± 12%     +37.0%      10736 ± 15%  numa-meminfo.node2.SReclaimable
>          5 ± 15%     +66.7%          8 ±  9%  sched_debug.cfs_rq[33]:/.load
>          5 ± 25%     +47.8%          8 ± 10%  sched_debug.cfs_rq[37]:/.load
>          2 ±  0%     +87.5%          3 ± 34%  sched_debug.cpu#89.cpu_load[4]
>          5 ± 15%     +66.7%          8 ±  9%  sched_debug.cpu#33.load
>          6 ± 23%     +41.7%          8 ± 10%  sched_debug.cpu#37.load
>          8 ± 10%     -26.5%          6 ±  6%  sched_debug.cpu#51.cpu_load[1]
>       7300 ± 37%     +63.6%      11943 ± 16%  softirqs.TASKLET
>       2984 ±  6%     +43.1%       4271 ± 23%  sched_debug.cpu#20.ttwu_count
>        328 ±  4%     +40.5%        462 ± 25%  sched_debug.cpu#26.ttwu_local
>         10 ±  7%     -27.5%          7 ±  5%  sched_debug.cpu#43.cpu_load[3]
>          9 ±  8%     -30.8%          6 ±  6%  sched_debug.cpu#41.cpu_load[3]
>          9 ±  8%     -27.0%          6 ±  6%  sched_debug.cpu#41.cpu_load[4]
>         10 ± 14%     -32.5%          6 ±  6%  sched_debug.cpu#41.cpu_load[2]
>      16292 ±  6%     +42.8%      23260 ± 25%  sched_debug.cpu#13.nr_switches
>         14 ± 28%     +55.9%         23 ±  8%  sched_debug.cpu#99.cpu_load[0]
>          5 ±  8%     +28.6%          6 ± 12%  sched_debug.cpu#17.load
>         13 ±  7%     -23.1%         10 ± 12%  sched_debug.cpu#39.cpu_load[3]
>          7 ± 10%     -35.7%          4 ± 11%  sched_debug.cfs_rq[45]:/.runnable_load_avg
>       5076 ± 13%     -21.8%       3970 ± 11%  numa-vmstat.node0.nr_slab_unreclaimable
>      20306 ± 13%     -21.8%      15886 ± 11%  numa-meminfo.node0.SUnreclaim
>         10 ± 10%     -28.6%          7 ±  6%  sched_debug.cpu#45.cpu_load[3]
>         11 ± 11%     -29.5%          7 ± 14%  sched_debug.cpu#45.cpu_load[1]
>         10 ± 12%     -26.8%          7 ±  6%  sched_debug.cpu#44.cpu_load[1]
>         10 ± 10%     -28.6%          7 ±  6%  sched_debug.cpu#44.cpu_load[0]
>          7 ± 17%     +48.3%         10 ±  7%  sched_debug.cfs_rq[11]:/.runnable_load_avg
>         11 ± 12%     -34.1%          7 ± 11%  sched_debug.cpu#47.cpu_load[0]
>         10 ± 10%     -27.9%          7 ±  5%  sched_debug.cpu#47.cpu_load[1]
>         10 ±  8%     -26.8%          7 ± 11%  sched_debug.cpu#47.cpu_load[2]
>         10 ±  8%     -28.6%          7 ± 14%  sched_debug.cpu#43.cpu_load[0]
>         10 ± 10%     -27.9%          7 ± 10%  sched_debug.cpu#43.cpu_load[1]
>         10 ± 10%     -28.6%          7 ±  6%  sched_debug.cpu#43.cpu_load[2]
>      12940 ±  3%     +49.8%      19387 ± 35%  numa-meminfo.node2.Active(anon)
>       3235 ±  2%     +49.8%       4844 ± 35%  numa-vmstat.node2.nr_active_anon
>         17 ± 17%     +36.6%         24 ±  9%  sched_debug.cpu#97.cpu_load[2]
>      14725 ±  8%     +21.8%      17928 ± 11%  sched_debug.cpu#16.nr_switches
>        667 ± 10%     +45.3%        969 ± 22%  sched_debug.cpu#17.ttwu_local
>       3257 ±  5%     +22.4%       3988 ± 11%  sched_debug.cpu#118.curr->pid
>       3144 ± 15%     -20.7%       2493 ±  8%  sched_debug.cpu#95.curr->pid
>       2192 ± 11%     +50.9%       3308 ± 37%  sched_debug.cpu#18.ttwu_count
>          6 ± 11%     +37.5%          8 ± 19%  sched_debug.cfs_rq[22]:/.load
>         12 ±  5%     +27.1%         15 ±  8%  sched_debug.cpu#5.cpu_load[1]
>         11 ± 12%     -23.4%          9 ± 13%  sched_debug.cpu#37.cpu_load[3]
>          6 ± 11%     +37.5%          8 ± 19%  sched_debug.cpu#22.load
>          8 ±  8%     -25.0%          6 ±  0%  sched_debug.cpu#51.cpu_load[2]
>          7 ±  6%     -20.0%          6 ± 11%  sched_debug.cpu#55.cpu_load[3]
>         11 ±  9%     -17.4%          9 ±  9%  sched_debug.cpu#39.cpu_load[4]
>         12 ±  5%     -22.9%          9 ± 11%  sched_debug.cpu#38.cpu_load[3]
>        420 ± 13%     +43.0%        601 ±  9%  sched_debug.cpu#30.ttwu_local
>       1682 ± 14%     +38.5%       2329 ± 17%  numa-meminfo.node7.AnonPages
>        423 ± 13%     +37.0%        579 ± 16%  numa-vmstat.node7.nr_anon_pages
>         15 ± 13%     +41.9%         22 ±  5%  sched_debug.cpu#99.cpu_load[1]
>          6 ± 20%     +44.0%          9 ± 13%  sched_debug.cfs_rq[19]:/.runnable_load_avg
>          9 ±  4%     -24.3%          7 ±  0%  sched_debug.cpu#43.cpu_load[4]
>       6341 ±  7%     -19.6%       5100 ± 16%  sched_debug.cpu#43.curr->pid
>       2577 ± 11%     -11.9%       2270 ± 10%  sched_debug.cpu#33.ttwu_count
>         13 ±  6%     -18.5%         11 ± 12%  sched_debug.cpu#40.cpu_load[2]
>       4828 ±  6%     +23.8%       5979 ±  6%  sched_debug.cpu#34.curr->pid
>       4351 ± 12%     +33.9%       5824 ± 12%  sched_debug.cpu#36.curr->pid
>         10 ±  8%     -23.8%          8 ±  8%  sched_debug.cpu#37.cpu_load[4]
>         10 ± 14%     -28.6%          7 ±  6%  sched_debug.cpu#45.cpu_load[2]
>         17 ± 22%     +40.6%         24 ±  7%  sched_debug.cpu#97.cpu_load[1]
>         11 ±  9%     +21.3%         14 ±  5%  sched_debug.cpu#7.cpu_load[2]
>         10 ±  8%     -26.2%          7 ± 10%  sched_debug.cpu#36.cpu_load[4]
>      12853 ±  2%     +20.0%      15429 ± 11%  numa-meminfo.node2.AnonPages
>       4744 ±  8%     +30.8%       6204 ± 11%  sched_debug.cpu#35.curr->pid
>       3214 ±  2%     +20.0%       3856 ± 11%  numa-vmstat.node2.nr_anon_pages
>       6181 ±  6%     +24.9%       7718 ±  9%  sched_debug.cpu#13.curr->pid
>       6675 ± 23%     +27.5%       8510 ± 10%  sched_debug.cfs_rq[91]:/.tg_load_avg
>     171261 ±  5%     -22.2%     133177 ± 15%  numa-numastat.node0.local_node
>       6589 ± 21%     +29.3%       8522 ± 11%  sched_debug.cfs_rq[89]:/.tg_load_avg
>       6508 ± 20%     +28.0%       8331 ±  8%  sched_debug.cfs_rq[88]:/.tg_load_avg
>       6598 ± 22%     +29.2%       8525 ± 11%  sched_debug.cfs_rq[90]:/.tg_load_avg
>        590 ± 13%     -21.4%        464 ±  7%  sched_debug.cpu#105.ttwu_local
>     175392 ±  5%     -21.7%     137308 ± 14%  numa-numastat.node0.numa_hit
>         11 ±  6%     -18.2%          9 ±  7%  sched_debug.cpu#38.cpu_load[4]
>       6643 ± 23%     +27.4%       8465 ± 10%  sched_debug.cfs_rq[94]:/.tg_load_avg
>       6764 ±  7%     +13.8%       7695 ±  7%  sched_debug.cpu#12.curr->pid
>         29 ± 28%     +34.5%         39 ±  5%  sched_debug.cfs_rq[98]:/.tg_load_contrib
>       1776 ±  7%     +29.4%       2298 ± 13%  sched_debug.cpu#11.ttwu_local
>         13 ±  0%     -19.2%         10 ±  8%  sched_debug.cpu#40.cpu_load[3]
>          7 ±  5%     -17.2%          6 ±  0%  sched_debug.cpu#51.cpu_load[3]
>       7371 ± 20%     -18.0%       6045 ±  3%  sched_debug.cpu#1.sched_goidle
>      26560 ±  2%     +14.0%      30287 ±  7%  numa-meminfo.node2.Slab
>      16161 ±  6%      -9.4%      14646 ±  1%  sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
>        351 ±  6%      -9.3%        318 ±  1%  sched_debug.cfs_rq[27]:/.tg_runnable_contrib
>       7753 ± 27%     -22.9%       5976 ±  5%  sched_debug.cpu#2.sched_goidle
>       3828 ±  9%     +17.3%       4490 ±  6%  sched_debug.cpu#23.sched_goidle
>      23925 ±  2%     +23.0%      29419 ± 23%  numa-meminfo.node2.Active
>         47 ±  6%     -15.8%         40 ± 19%  sched_debug.cpu#42.cpu_load[1]
>        282 ±  5%      -9.7%        254 ±  7%  sched_debug.cfs_rq[109]:/.tg_runnable_contrib
>        349 ±  5%      -9.3%        317 ±  1%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
>       6941 ±  3%      +8.9%       7558 ±  7%  sched_debug.cpu#61.nr_switches
>      16051 ±  5%      -8.9%      14618 ±  1%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
>     238944 ±  3%      +9.2%     260958 ±  5%  numa-vmstat.node2.numa_local
>      12966 ±  5%      -9.5%      11732 ±  6%  sched_debug.cfs_rq[109]:/.avg->runnable_avg_sum
>       1004 ±  3%      +8.2%       1086 ±  4%  sched_debug.cpu#118.sched_goidle
>      20746 ±  4%      -8.4%      19000 ±  1%  sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum
>        451 ±  4%      -8.3%        413 ±  1%  sched_debug.cfs_rq[45]:/.tg_runnable_contrib
>       3538 ±  4%     +17.2%       4147 ±  8%  sched_debug.cpu#26.ttwu_count
>         16 ±  9%     +13.8%         18 ±  2%  sched_debug.cpu#99.cpu_load[3]
>       1531 ±  0%     +11.3%       1704 ±  1%  numa-meminfo.node7.KernelStack
>       3569 ±  3%     +17.2%       4182 ± 10%  sched_debug.cpu#24.sched_goidle
>       1820 ±  3%     -12.5%       1594 ±  8%  slabinfo.taskstats.num_objs
>       1819 ±  3%     -12.4%       1594 ±  8%  slabinfo.taskstats.active_objs
>       4006 ±  5%     +19.1%       4769 ±  8%  sched_debug.cpu#17.sched_goidle
>      21412 ± 19%     -17.0%      17779 ±  3%  sched_debug.cpu#2.nr_switches
>         16 ±  9%     +24.2%         20 ±  4%  sched_debug.cpu#99.cpu_load[2]
>      10493 ±  7%     +13.3%      11890 ±  4%  sched_debug.cpu#23.nr_switches
>       1207 ±  2%     -46.9%        640 ±  4%  time.voluntary_context_switches
>
>                           time.voluntary_context_switches
>
>   1300 ++-----------*--*--------------------*-------------------------------+
>        *..*.*..*.. +      *.*..*..*.*..*..*     .*..*..*.  .*..*.*..*..     |
>   1200 ++         *                            *         *.            *.*..*
>   1100 ++                                                                   |
>        |                                                                    |
>   1000 ++                                                                   |
>        |                                                                    |
>    900 ++                                                                   |
>        |                                                                    |
>    800 ++                                                                   |
>    700 ++                                                                   |
>        O    O     O       O O  O       O  O O  O O       O       O          |
>    600 ++ O    O    O  O          O O                  O    O  O            |
>        |                                            O                       |
>    500 ++-------------------------------------------------------------------+
>
>         [*] bisect-good sample
>         [O] bisect-bad  sample
>
> To reproduce:
>
>         apt-get install ruby ruby-oj
>         git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>         cd lkp-tests
>         bin/setup-local job.yaml # the job file attached in this email
>         bin/run-local   job.yaml
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
>

Regards,
Kirill
