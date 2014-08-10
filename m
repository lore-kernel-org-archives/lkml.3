Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaHJKyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 06:54:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:37380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaHJKyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 06:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,836,1400050800"; 
   d="scan'208";a="574545891"
Date: Sun, 10 Aug 2014 18:54:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140810105413.GA29451@localhost>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140810075915.GR9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 09:59:15AM +0200, Peter Zijlstra wrote:
> On Sun, Aug 10, 2014 at 12:41:27PM +0800, Fengguang Wu wrote:
> > Hi Vincent,
> > 
> > FYI, we noticed some performance ups/downs on
> > 
> > commit 143e1e28cb40bed836b0a06567208bd7347c9672 ("sched: Rework sched_domain topology definition")
> > 
> >     128529 ± 1%     +17.9%     151594 ± 0%  brickland1/aim7/6000-page_test
> >      76064 ± 3%     -32.2%      51572 ± 6%  brickland1/aim7/6000-page_test
> >   59366697 ± 3%     -46.1%   32017187 ± 7%  brickland1/aim7/6000-page_test
> >       2561 ± 7%     -42.9%       1463 ± 9%  brickland1/aim7/6000-page_test
> >       9926 ± 2%     -43.8%       5577 ± 4%  brickland1/aim7/6000-page_test
> >      19542 ± 9%     -38.3%      12057 ± 4%  brickland1/aim7/6000-page_test
> >     993654 ± 2%     -19.9%     795962 ± 3%  brickland1/aim7/6000-page_test
> 
> etc..
> 
> how does one read that? afaict its a random number generator..

The "brickland1/aim7/6000-page_test" is the test case part.

The "TOTAL XXX" is the metric part. One test run may generate lots of
metrics, reflecting different aspect of the system dynamics.

This view may be easier to read, by grouping the metrics by test case.

test case: brickland1/aim7/6000-page_test

    128529 ± 1%     +17.9%     151594 ± 0%  TOTAL aim7.jobs-per-min
    582269 ±14%     -55.6%     258617 ±16%  TOTAL softirqs.SCHED
  59366697 ± 3%     -46.1%   32017187 ± 7%  TOTAL cpuidle.C1-IVT.time
     54543 ±11%     -37.2%      34252 ±16%  TOTAL cpuidle.C1-IVT.usage
      2561 ± 7%     -42.9%       1463 ± 9%  TOTAL numa-numastat.node2.other_node
      9926 ± 2%     -43.8%       5577 ± 4%  TOTAL proc-vmstat.numa_other
      2627 ±12%     -49.1%       1337 ±12%  TOTAL numa-numastat.node1.other_node
     19542 ± 9%     -38.3%      12057 ± 4%  TOTAL cpuidle.C1E-IVT.usage
      2455 ±10%     -41.0%       1448 ± 9%  TOTAL numa-numastat.node0.other_node
    471304 ±11%     -31.4%     323251 ± 8%  TOTAL numa-vmstat.node1.nr_anon_pages
      2281 ±12%     -41.8%       1327 ±16%  TOTAL numa-numastat.node3.other_node
   1903446 ±11%     -30.7%    1318156 ± 7%  TOTAL numa-meminfo.node1.AnonPages
    518274 ±11%     -30.4%     360742 ± 8%  TOTAL numa-vmstat.node1.nr_active_anon
   2097138 ±10%     -30.0%    1469003 ± 8%  TOTAL numa-meminfo.node1.Active(anon)
  49527464 ± 6%     -32.4%   33488833 ± 4%  TOTAL cpuidle.C1E-IVT.time
   2118206 ±10%     -29.7%    1488874 ± 7%  TOTAL numa-meminfo.node1.Active
     76064 ± 3%     -32.2%      51572 ± 6%  TOTAL cpuidle.C6-IVT.usage
    188938 ±33%     -41.3%     110966 ±16%  TOTAL numa-meminfo.node2.PageTables
     47262 ±35%     -42.3%      27273 ±16%  TOTAL numa-vmstat.node2.nr_page_table_pages
   1944687 ±10%     -25.8%    1443923 ±16%  TOTAL numa-meminfo.node3.Active(anon)
   1754763 ±11%     -26.6%    1288713 ±16%  TOTAL numa-meminfo.node3.AnonPages
   1964722 ±10%     -25.5%    1464696 ±16%  TOTAL numa-meminfo.node3.Active
    432109 ± 9%     -26.2%     318886 ±14%  TOTAL numa-vmstat.node3.nr_anon_pages
    479527 ± 9%     -25.3%     358029 ±14%  TOTAL numa-vmstat.node3.nr_active_anon
    463719 ± 8%     -24.7%     349388 ± 7%  TOTAL numa-vmstat.node0.nr_anon_pages
   3157742 ±16%     -26.5%    2320253 ±10%  TOTAL numa-meminfo.node1.MemUsed
   7303589 ± 2%     -24.8%    5495829 ± 3%  TOTAL meminfo.AnonPages
   8064024 ± 2%     -24.0%    6132677 ± 3%  TOTAL meminfo.Active(anon)
    511455 ± 8%     -23.9%     389447 ± 7%  TOTAL numa-vmstat.node0.nr_active_anon
   1818612 ± 2%     -24.9%    1365670 ± 3%  TOTAL proc-vmstat.nr_anon_pages
   2007155 ± 2%     -24.3%    1518688 ± 3%  TOTAL proc-vmstat.nr_active_anon
   8145316 ± 2%     -23.7%    6213832 ± 3%  TOTAL meminfo.Active
   1850230 ± 8%     -24.1%    1405061 ± 8%  TOTAL numa-meminfo.node0.AnonPages
 6.567e+11 ± 3%     -21.4%   5.16e+11 ± 4%  TOTAL meminfo.Committed_AS
   2044097 ± 7%     -23.5%    1562809 ± 8%  TOTAL numa-meminfo.node0.Active(anon)
   2064106 ± 7%     -23.3%    1582792 ± 8%  TOTAL numa-meminfo.node0.Active
    235358 ± 5%     -19.8%     188793 ± 3%  TOTAL proc-vmstat.pgmigrate_success
    235358 ± 5%     -19.8%     188793 ± 3%  TOTAL proc-vmstat.numa_pages_migrated
    433235 ± 4%     -18.1%     354845 ± 5%  TOTAL numa-vmstat.node2.nr_anon_pages
    198747 ±23%     -28.0%     143034 ± 3%  TOTAL proc-vmstat.nr_page_table_pages
      3187 ± 5%     -18.5%       2599 ± 6%  TOTAL numa-vmstat.node0.numa_other
    796281 ±23%     -27.7%     575352 ± 3%  TOTAL meminfo.PageTables
   1395062 ± 6%     -19.0%    1130108 ± 3%  TOTAL proc-vmstat.numa_hint_faults
    477037 ± 4%     -17.2%     394983 ± 5%  TOTAL numa-vmstat.node2.nr_active_anon
      2829 ±10%     +18.7%       3357 ± 3%  TOTAL numa-vmstat.node2.nr_alloc_batch
    993654 ± 2%     -19.9%     795962 ± 3%  TOTAL softirqs.RCU
      2706 ± 4%     +26.1%       3411 ± 5%  TOTAL numa-vmstat.node1.nr_alloc_batch
   2725835 ± 4%     -17.5%    2247537 ± 4%  TOTAL numa-meminfo.node2.MemUsed
    393637 ± 6%     -15.3%     333296 ± 2%  TOTAL proc-vmstat.numa_hint_faults_local
      2.82 ± 3%     +21.9%       3.43 ± 4%  TOTAL turbostat.%pc2
      4.40 ± 2%     +22.0%       5.37 ± 4%  TOTAL turbostat.%c6
   1742111 ± 4%     -16.9%    1447181 ± 5%  TOTAL numa-meminfo.node2.AnonPages
  15865125 ± 1%     -15.0%   13485882 ± 1%  TOTAL softirqs.TIMER
   1923000 ± 4%     -16.4%    1608509 ± 5%  TOTAL numa-meminfo.node2.Active(anon)
   1943185 ± 4%     -16.2%    1629057 ± 5%  TOTAL numa-meminfo.node2.Active
      3077 ± 1%     +14.5%       3523 ± 0%  TOTAL proc-vmstat.pgactivate
       329 ± 1%     -13.3%        285 ± 0%  TOTAL uptime.boot
     13158 ±13%     -14.4%      11261 ± 4%  TOTAL numa-meminfo.node3.SReclaimable
      3289 ±13%     -14.4%       2815 ± 4%  TOTAL numa-vmstat.node3.nr_slab_reclaimable
   3150464 ± 2%     -24.2%    2387551 ± 3%  TOTAL time.voluntary_context_switches
       281 ± 1%     -15.1%        238 ± 0%  TOTAL time.elapsed_time
     29294 ± 1%     -14.3%      25093 ± 0%  TOTAL time.system_time
   4529818 ± 1%      -8.8%    4129398 ± 1%  TOTAL time.involuntary_context_switches
     15.75 ± 1%      -3.4%      15.21 ± 0%  TOTAL turbostat.RAM_W
     10655 ± 0%      +1.4%      10802 ± 0%  TOTAL time.percent_of_cpu_this_job_got

Thanks,
Fengguang
