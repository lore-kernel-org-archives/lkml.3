Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaHEV2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:28:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:3804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbaHEV2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:28:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,807,1400050800"; 
   d="scan'208";a="572188444"
Date: Wed, 6 Aug 2014 05:28:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched] 40c5e72463e: +64.8% hackbench.throughput
Message-ID: <20140805212841.GC14042@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

FYI, we noticed the below changes on

git://bee.sh.intel.com/git/ydu19/linux rewrite-v5-on-3.16-rc7
commit 40c5e72463e42659e15eba0c8c2f46f96f703fac ("sched: Rewrite per entity runnable load average tracking")

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    153447 ± 6%     +64.8%     252931 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
    153447 ± 6%     +64.8%     252931 ± 0%  TOTAL hackbench.throughput

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.02 ±44%     -89.3%       0.11 ±29%  lkp-snb01/hackbench/1600%-process-pipe
      1.02 ±44%     -89.3%       0.11 ±29%  TOTAL perf-profile.cpu-cycles.__schedule.schedule_user.sysret_careful.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      9166 ±15%    +703.0%      73599 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      9166 ±15%    +703.0%      73599 ± 1%  TOTAL numa-vmstat.node1.numa_other

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.49 ±12%    -100.0%       0.00 ± 0%  xps2/pigz/100%-512K
      1.49 ±12%    -100.0%       0.00 ± 0%  TOTAL perf-profile.cpu-cycles.update_cfs_rq_blocked_load.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.64 ±40%     -85.6%       0.09 ±18%  lkp-snb01/hackbench/1600%-process-pipe
      0.64 ±40%     -85.6%       0.09 ±18%  TOTAL perf-profile.cpu-cycles.__switch_to.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 2.319e+08 ±10%    +368.0%  1.085e+09 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 2.319e+08 ±10%    +368.0%  1.085e+09 ± 1%  TOTAL cpuidle.C1-SNB.time

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2658 ±40%    +240.4%       9049 ±14%  lkp-snb01/hackbench/1600%-process-pipe
      2658 ±40%    +240.4%       9049 ±14%  TOTAL numa-vmstat.node0.nr_kernel_stack

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     42829 ±40%    +233.0%     142608 ±14%  lkp-snb01/hackbench/1600%-process-pipe
     42829 ±40%    +233.0%     142608 ±14%  TOTAL numa-meminfo.node0.KernelStack

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3.41 ±11%     -69.8%       1.03 ± 7%  lkp-snb01/hackbench/1600%-process-pipe
      3.41 ±11%     -69.8%       1.03 ± 7%  TOTAL turbostat.%c7

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.11 ±36%     -71.1%       0.32 ±17%  lkp-snb01/hackbench/1600%-process-pipe
      1.11 ±36%     -71.1%       0.32 ±17%  TOTAL perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3629 ±20%     -60.8%       1421 ±11%  lkp-snb01/hackbench/1600%-process-pipe
      3629 ±20%     -60.8%       1421 ±11%  TOTAL cpuidle.C3-SNB.usage

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.17 ±29%     -67.6%       0.38 ±12%  lkp-snb01/hackbench/1600%-process-pipe
      1.17 ±29%     -67.6%       0.38 ±12%  TOTAL perf-profile.cpu-cycles.__switch_to.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.52 ±39%     -70.6%       0.74 ±17%  lkp-snb01/hackbench/1600%-process-pipe
      2.52 ±39%     -70.6%       0.74 ±17%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.new_sync_read

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     21455 ±32%    +183.8%      60881 ±12%  lkp-snb01/hackbench/1600%-process-pipe
     21455 ±32%    +183.8%      60881 ±12%  TOTAL numa-vmstat.node0.nr_slab_unreclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.79 ± 9%    +177.2%       7.75 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      2.79 ± 9%    +177.2%       7.75 ± 0%  TOTAL turbostat.%c1

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     86194 ±32%    +180.9%     242116 ±13%  lkp-snb01/hackbench/1600%-process-pipe
     86194 ±32%    +180.9%     242116 ±13%  TOTAL numa-meminfo.node0.SUnreclaim

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       226 ±10%    +149.5%        563 ±22%  lkp-snb01/hackbench/1600%-process-pipe
       226 ±10%    +149.5%        563 ±22%  TOTAL slabinfo.nfs_read_data.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       226 ±10%    +149.5%        563 ±22%  lkp-snb01/hackbench/1600%-process-pipe
       226 ±10%    +149.5%        563 ±22%  TOTAL slabinfo.nfs_read_data.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  19845625 ± 7%     -64.3%    7081268 ± 9%  lkp-snb01/hackbench/1600%-process-pipe
  19845625 ± 7%     -64.3%    7081268 ± 9%  TOTAL cpuidle.C1-SNB.usage

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.79 ±40%     -67.9%       0.25 ± 9%  lkp-snb01/hackbench/1600%-process-pipe
      0.79 ±40%     -67.9%       0.25 ± 9%  TOTAL perf-profile.cpu-cycles.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  65227388 ±15%    +144.4%  1.594e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  65227388 ±15%    +144.4%  1.594e+08 ± 1%  TOTAL numa-numastat.node0.local_node

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  65230757 ±15%    +144.3%  1.594e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  65230757 ±15%    +144.3%  1.594e+08 ± 1%  TOTAL numa-numastat.node0.numa_hit

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  12740359 ±15%    +142.5%   30890379 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  12740359 ±15%    +142.5%   30890379 ± 1%  TOTAL proc-vmstat.pgalloc_dma32

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  74621961 ±14%    +165.6%  1.982e+08 ± 9%  lkp-snb01/hackbench/1600%-process-pipe
  74621961 ±14%    +165.6%  1.982e+08 ± 9%  TOTAL cpuidle.C1E-SNB.time

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.26 ±29%     -58.4%       0.53 ±28%  lkp-snb01/hackbench/1600%-process-pipe
      1.26 ±29%     -58.4%       0.53 ±28%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    110174 ±25%    +145.0%     269959 ±11%  lkp-snb01/hackbench/1600%-process-pipe
    110174 ±25%    +145.0%     269959 ±11%  TOTAL numa-meminfo.node0.Slab

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    251603 ±12%     -50.5%     124607 ±17%  lkp-snb01/hackbench/1600%-process-pipe
    251603 ±12%     -50.5%     124607 ±17%  TOTAL numa-meminfo.node1.KernelStack

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  35446837 ±10%    +128.9%   81153081 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
  35446837 ±10%    +128.9%   81153081 ± 3%  TOTAL numa-vmstat.node0.numa_local

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  35512157 ±10%    +128.5%   81153946 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
  35512157 ±10%    +128.5%   81153946 ± 3%  TOTAL numa-vmstat.node0.numa_hit

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     49301 ±31%    +142.9%     119747 ±19%  xps2/pigz/100%-512K
     49301 ±31%    +142.9%     119747 ±19%  TOTAL cpuidle.C1-NHM.time

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     15690 ±12%     -50.7%       7735 ±15%  lkp-snb01/hackbench/1600%-process-pipe
     15690 ±12%     -50.7%       7735 ±15%  TOTAL numa-vmstat.node1.nr_kernel_stack

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  9.01e+08 ± 9%     -52.7%  4.263e+08 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
  9.01e+08 ± 9%     -52.7%  4.263e+08 ± 4%  TOTAL cpuidle.C7-SNB.time

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    413966 ±10%     -47.6%     216914 ±15%  lkp-snb01/hackbench/1600%-process-pipe
    413966 ±10%     -47.6%     216914 ±15%  TOTAL numa-meminfo.node1.SUnreclaim

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    103395 ±10%     -47.9%      53859 ±13%  lkp-snb01/hackbench/1600%-process-pipe
    103395 ±10%     -47.9%      53859 ±13%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       316 ±12%    +100.0%        632 ±10%  lkp-snb01/hackbench/1600%-process-pipe
       316 ±12%    +100.0%        632 ±10%  TOTAL slabinfo.mnt_cache.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       316 ±12%    +100.0%        632 ±10%  lkp-snb01/hackbench/1600%-process-pipe
       316 ±12%    +100.0%        632 ±10%  TOTAL slabinfo.mnt_cache.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       175 ±13%     +81.9%        319 ±12%  lkp-snb01/hackbench/1600%-process-pipe
       175 ±13%     +81.9%        319 ±12%  TOTAL cpuidle.POLL.usage

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    447801 ± 9%     -45.5%     243827 ±13%  lkp-snb01/hackbench/1600%-process-pipe
    447801 ± 9%     -45.5%     243827 ±13%  TOTAL numa-meminfo.node1.Slab

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.599e+08 ± 6%    +102.1%  3.233e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 1.599e+08 ± 6%    +102.1%  3.233e+08 ± 1%  TOTAL proc-vmstat.numa_local

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.599e+08 ± 6%    +102.1%  3.233e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 1.599e+08 ± 6%    +102.1%  3.233e+08 ± 1%  TOTAL proc-vmstat.numa_hit

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.633e+08 ± 6%    +101.2%  3.286e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 1.633e+08 ± 6%    +101.2%  3.286e+08 ± 1%  TOTAL proc-vmstat.pgfree

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    362173 ±14%     -67.0%     119526 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
     17618 ± 1%     -12.5%      15410 ± 1%  xps2/pigz/100%-512K
    379792 ±13%     -64.5%     134936 ± 1%  TOTAL softirqs.SCHED

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.506e+08 ± 8%     +97.7%  2.978e+08 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 1.506e+08 ± 8%     +97.7%  2.978e+08 ± 1%  TOTAL proc-vmstat.pgalloc_normal

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    363748 ±10%     -38.8%     222459 ±13%  lkp-snb01/hackbench/1600%-process-pipe
    363748 ±10%     -38.8%     222459 ±13%  TOTAL numa-meminfo.node1.PageTables

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  46501465 ±25%     +80.7%   84012112 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
  46501465 ±25%     +80.7%   84012112 ± 4%  TOTAL numa-vmstat.node1.numa_hit

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  46492299 ±25%     +80.5%   83938512 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
  46492299 ±25%     +80.5%   83938512 ± 4%  TOTAL numa-vmstat.node1.numa_local

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     90828 ±10%     -39.8%      54666 ±10%  lkp-snb01/hackbench/1600%-process-pipe
     90828 ±10%     -39.8%      54666 ±10%  TOTAL numa-vmstat.node1.nr_page_table_pages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   2182344 ± 8%     -36.1%    1394287 ±10%  lkp-snb01/hackbench/1600%-process-pipe
   2182344 ± 8%     -36.1%    1394287 ±10%  TOTAL numa-meminfo.node1.MemUsed

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.99 ±24%     +46.2%       1.44 ±13%  xps2/pigz/100%-512K
      0.99 ±24%     +46.2%       1.44 ±13%  TOTAL perf-profile.cpu-cycles.update_cfs_shares.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    169771 ± 5%     +45.6%     247119 ±11%  lkp-snb01/hackbench/1600%-process-pipe
    169771 ± 5%     +45.6%     247119 ±11%  TOTAL numa-meminfo.node0.PageTables

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     42466 ± 5%     +44.8%      61470 ±12%  lkp-snb01/hackbench/1600%-process-pipe
     42466 ± 5%     +44.8%      61470 ±12%  TOTAL numa-vmstat.node0.nr_page_table_pages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  94704593 ±22%     +73.1%  1.639e+08 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
  94704593 ±22%     +73.1%  1.639e+08 ± 3%  TOTAL numa-numastat.node1.numa_hit

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  94703743 ±22%     +73.1%  1.639e+08 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
  94703743 ±22%     +73.1%  1.639e+08 ± 3%  TOTAL numa-numastat.node1.local_node

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    386264 ± 9%     -29.0%     274232 ±12%  lkp-snb01/hackbench/1600%-process-pipe
    386264 ± 9%     -29.0%     274232 ±12%  TOTAL numa-meminfo.node1.AnonPages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.29 ±32%     +72.4%       2.22 ± 5%  lkp-snb01/hackbench/1600%-process-pipe
      1.29 ±32%     +72.4%       2.22 ± 5%  TOTAL perf-profile.cpu-cycles.__sb_start_write.pipe_write.new_sync_write.vfs_write.sys_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    386033 ± 9%     -28.9%     274285 ±12%  lkp-snb01/hackbench/1600%-process-pipe
    386033 ± 9%     -28.9%     274285 ±12%  TOTAL numa-meminfo.node1.Active(anon)

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    451326 ± 7%     -29.5%     317996 ± 9%  lkp-snb01/hackbench/1600%-process-pipe
    451326 ± 7%     -29.5%     317996 ± 9%  TOTAL numa-meminfo.node1.Active

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1054737 ± 7%     +47.7%    1557962 ± 8%  lkp-snb01/hackbench/1600%-process-pipe
   1054737 ± 7%     +47.7%    1557962 ± 8%  TOTAL numa-meminfo.node0.MemUsed

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.78 ±35%     +69.4%       1.33 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      0.78 ±35%     +69.4%       1.33 ± 4%  TOTAL perf-profile.cpu-cycles.system_call.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.18 ±33%     +70.1%       2.01 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      1.18 ±33%     +70.1%       2.01 ± 3%  TOTAL perf-profile.cpu-cycles.__srcu_read_unlock.fsnotify.vfs_write.sys_write.system_call_fastpath

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3.36 ±22%     +54.1%       5.18 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      3.36 ±22%     +54.1%       5.18 ± 2%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.copy_page_to_iter.pipe_read.new_sync_read.vfs_read

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       712 ±12%     +55.6%       1108 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
       712 ±12%     +55.6%       1108 ± 4%  TOTAL slabinfo.RAW.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       712 ±12%     +55.6%       1108 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
       712 ±12%     +55.6%       1108 ± 4%  TOTAL slabinfo.RAW.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  18948890 ± 5%     +52.1%   28823331 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  18948890 ± 5%     +52.1%   28823331 ± 1%  TOTAL proc-vmstat.pgfault

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.77 ±34%     +69.4%       1.30 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      0.77 ±34%     +69.4%       1.30 ± 4%  TOTAL perf-profile.cpu-cycles.system_call.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.05 ±34%     +68.3%       1.77 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      1.05 ±34%     +68.3%       1.77 ± 3%  TOTAL perf-profile.cpu-cycles.__sb_end_write.pipe_write.new_sync_write.vfs_write.sys_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.60 ±34%     +63.1%       0.97 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      0.60 ±34%     +63.1%       0.97 ± 3%  TOTAL perf-profile.cpu-cycles.mutex_lock.pipe_read.new_sync_read.vfs_read.sys_read

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.46 ±34%     +63.8%       2.39 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      1.46 ±34%     +63.8%       2.39 ± 2%  TOTAL perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_write.system_call_fastpath

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.01 ±31%     +61.5%       1.63 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      1.01 ±31%     +61.5%       1.63 ± 3%  TOTAL perf-profile.cpu-cycles.new_sync_read.vfs_read.sys_read.system_call_fastpath.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     96485 ± 9%     -30.0%      67541 ±10%  lkp-snb01/hackbench/1600%-process-pipe
     96485 ± 9%     -30.0%      67541 ±10%  TOTAL numa-vmstat.node1.nr_anon_pages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     96426 ± 9%     -29.9%      67560 ±10%  lkp-snb01/hackbench/1600%-process-pipe
     96426 ± 9%     -29.9%      67560 ±10%  TOTAL numa-vmstat.node1.nr_active_anon

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.53 ±31%     +59.6%       4.03 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      2.53 ±31%     +59.6%       4.03 ± 2%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.copy_page_from_iter.pipe_write.new_sync_write.vfs_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.98 ±35%     +58.7%       1.55 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      0.98 ±35%     +58.7%       1.55 ± 1%  TOTAL perf-profile.cpu-cycles.new_sync_write.vfs_write.sys_write.system_call_fastpath.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.75 ±29%     +50.7%       1.13 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      0.75 ±29%     +50.7%       1.13 ± 2%  TOTAL perf-profile.cpu-cycles.mutex_unlock.new_sync_read.vfs_read.sys_read.system_call_fastpath

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     10716 ±13%     -31.5%       7336 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
     10716 ±13%     -31.5%       7336 ± 3%  TOTAL slabinfo.proc_inode_cache.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   2462781 ±11%     -32.2%    1669715 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
    104190 ± 1%     -28.0%      75034 ± 7%  xps2/pigz/100%-512K
   2566971 ±10%     -32.0%    1744750 ± 1%  TOTAL softirqs.RCU

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.14 ±27%     +47.7%       1.68 ± 6%  lkp-snb01/hackbench/1600%-process-pipe
      1.14 ±27%     +47.7%       1.68 ± 6%  TOTAL perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.26 ±11%     +40.7%       3.18 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      2.26 ±11%     +40.7%       3.18 ± 2%  TOTAL perf-profile.cpu-cycles.mutex_unlock.new_sync_write.vfs_write.sys_write.system_call_fastpath

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.49 ±31%     +52.2%       2.26 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      1.49 ±31%     +52.2%       2.26 ± 2%  TOTAL perf-profile.cpu-cycles.copy_page_from_iter_iovec.copy_page_from_iter.pipe_write.new_sync_write.vfs_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3627 ± 4%     +31.3%       4761 ± 5%  xps2/pigz/100%-512K
      3627 ± 4%     +31.3%       4761 ± 5%  TOTAL slabinfo.anon_vma.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3627 ± 4%     +31.3%       4761 ± 5%  xps2/pigz/100%-512K
      3627 ± 4%     +31.3%       4761 ± 5%  TOTAL slabinfo.anon_vma.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.12 ±14%     +35.1%       2.86 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      2.12 ±14%     +35.1%       2.86 ± 1%  TOTAL perf-profile.cpu-cycles.copy_page_to_iter_iovec.copy_page_to_iter.pipe_read.new_sync_read.vfs_read

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.06 ±33%     +56.8%       1.66 ±13%  lkp-snb01/hackbench/1600%-process-pipe
      1.06 ±33%     +56.8%       1.66 ±13%  TOTAL perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write.sys_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.97 ±32%     +50.2%       2.96 ± 6%  lkp-snb01/hackbench/1600%-process-pipe
      1.97 ±32%     +50.2%       2.96 ± 6%  TOTAL perf-profile.cpu-cycles.pipe_write.new_sync_write.vfs_write.sys_write.system_call_fastpath

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.72 ±33%     +54.7%       1.12 ± 6%  lkp-snb01/hackbench/1600%-process-pipe
      0.72 ±33%     +54.7%       1.12 ± 6%  TOTAL perf-profile.cpu-cycles.system_call_after_swapgs.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8466 ± 6%     -20.5%       6731 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      8466 ± 6%     -20.5%       6731 ± 3%  TOTAL numa-vmstat.node1.nr_slab_reclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.94 ±30%     +51.1%       1.41 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      0.94 ±30%     +51.1%       1.41 ± 4%  TOTAL perf-profile.cpu-cycles.fsnotify.vfs_write.sys_write.system_call_fastpath.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     33833 ± 6%     -20.5%      26913 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
     33833 ± 6%     -20.5%      26913 ± 4%  TOTAL numa-meminfo.node1.SReclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     49037 ±14%     +38.1%      67717 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
     49037 ±14%     +38.1%      67717 ± 2%  TOTAL cpuidle.C7-SNB.usage

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.73 ±34%     +49.3%       1.09 ± 7%  lkp-snb01/hackbench/1600%-process-pipe
      0.73 ±34%     +49.3%       1.09 ± 7%  TOTAL perf-profile.cpu-cycles.system_call_after_swapgs.__write_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      9215 ±21%     -22.4%       7152 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      9215 ±21%     -22.4%       7152 ± 3%  TOTAL slabinfo.proc_inode_cache.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    221963 ±11%     +25.7%     279098 ± 5%  lkp-snb01/hackbench/1600%-process-pipe
    221963 ±11%     +25.7%     279098 ± 5%  TOTAL cpuidle.C1E-SNB.usage

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.96 ±12%     +22.0%       1.17 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      0.96 ±12%     +22.0%       1.17 ± 2%  TOTAL perf-profile.cpu-cycles._raw_spin_unlock_irqrestore.__wake_up_sync_key.pipe_write.new_sync_write.vfs_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1397 ± 8%     +23.4%       1723 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      1397 ± 8%     +23.4%       1723 ± 3%  TOTAL slabinfo.sock_inode_cache.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1397 ± 8%     +23.4%       1723 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      1397 ± 8%     +23.4%       1723 ± 3%  TOTAL slabinfo.sock_inode_cache.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      6328 ± 5%     +26.3%       7995 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      6328 ± 5%     +26.3%       7995 ± 0%  TOTAL vmstat.procs.r

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     23979 ± 5%     +16.1%      27842 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
     23979 ± 5%     +16.1%      27842 ± 4%  TOTAL numa-meminfo.node0.SReclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.91 ±14%     +26.5%       1.15 ± 7%  lkp-snb01/hackbench/1600%-process-pipe
      0.91 ±14%     +26.5%       1.15 ± 7%  TOTAL perf-profile.cpu-cycles.touch_atime.pipe_read.new_sync_read.vfs_read.sys_read

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      5990 ± 6%     +16.0%       6951 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      5990 ± 6%     +16.0%       6951 ± 4%  TOTAL numa-vmstat.node0.nr_slab_reclaimable

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3249 ± 5%     -13.7%       2802 ± 4%  xps2/pigz/100%-512K
      3249 ± 5%     -13.7%       2802 ± 4%  TOTAL slabinfo.vm_area_struct.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.36 ±10%     +19.0%       1.62 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      1.36 ±10%     +19.0%       1.62 ± 2%  TOTAL perf-profile.cpu-cycles.__read_nocancel

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.84 ±25%     +37.2%       1.15 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      0.84 ±25%     +37.2%       1.15 ± 4%  TOTAL perf-profile.cpu-cycles.file_update_time.pipe_write.new_sync_write.vfs_write.sys_write

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2093 ± 6%     +21.6%       2545 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      2093 ± 6%     +21.6%       2545 ± 2%  TOTAL uptime.idle

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2800 ± 1%     +13.1%       3168 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      2800 ± 1%     +13.1%       3168 ± 4%  TOTAL slabinfo.kmalloc-96.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    393737 ± 5%      -8.2%     361521 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      3287 ± 4%     -13.2%       2852 ± 4%  xps2/pigz/100%-512K
    397025 ± 5%      -8.2%     364373 ± 1%  TOTAL slabinfo.vm_area_struct.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    315204 ± 6%     +14.2%     360116 ± 7%  lkp-snb01/hackbench/1600%-process-pipe
    315204 ± 6%     +14.2%     360116 ± 7%  TOTAL numa-meminfo.node0.Active

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      9685 ± 6%     +20.0%      11625 ± 9%  xps2/pigz/100%-512K
      9685 ± 6%     +20.0%      11625 ± 9%  TOTAL meminfo.AnonHugePages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    164662 ± 6%      -8.9%     150041 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
    164662 ± 6%      -8.9%     150041 ± 1%  TOTAL proc-vmstat.nr_anon_pages

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    164625 ± 6%      -8.8%     150107 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
    164625 ± 6%      -8.8%     150107 ± 1%  TOTAL proc-vmstat.nr_active_anon

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2881 ± 1%     +11.4%       3208 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      2881 ± 1%     +11.4%       3208 ± 4%  TOTAL slabinfo.kmalloc-96.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8948 ± 5%      -8.2%       8216 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      8948 ± 5%      -8.2%       8216 ± 1%  TOTAL slabinfo.vm_area_struct.num_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8948 ± 5%      -8.2%       8216 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      8948 ± 5%      -8.2%       8216 ± 1%  TOTAL slabinfo.vm_area_struct.active_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1057 ± 4%      -8.9%        963 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      1057 ± 4%      -8.9%        963 ± 1%  TOTAL slabinfo.mm_struct.num_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1057 ± 4%      -8.9%        963 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      1057 ± 4%      -8.9%        963 ± 1%  TOTAL slabinfo.mm_struct.active_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     17987 ± 4%      -8.9%      16386 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
     17987 ± 4%      -8.9%      16386 ± 1%  TOTAL slabinfo.mm_struct.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8196 ± 5%      -7.9%       7551 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      8196 ± 5%      -7.9%       7551 ± 1%  TOTAL slabinfo.kmalloc-64.num_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8196 ± 5%      -7.9%       7551 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      8196 ± 5%      -7.9%       7551 ± 1%  TOTAL slabinfo.kmalloc-64.active_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    524580 ± 5%      -7.9%     483309 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
    524580 ± 5%      -7.9%     483309 ± 1%  TOTAL slabinfo.kmalloc-64.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1396 ± 1%     -10.2%       1253 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      1396 ± 1%     -10.2%       1253 ± 0%  TOTAL slabinfo.sighand_cache.num_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1396 ± 1%     -10.2%       1253 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      1396 ± 1%     -10.2%       1253 ± 0%  TOTAL slabinfo.sighand_cache.active_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     20950 ± 1%     -10.2%      18812 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     20950 ± 1%     -10.2%      18812 ± 0%  TOTAL slabinfo.sighand_cache.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      4787 ± 4%      -8.7%       4371 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      4787 ± 4%      -8.7%       4371 ± 0%  TOTAL slabinfo.task_struct.num_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      4787 ± 4%      -8.7%       4371 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      4787 ± 4%      -8.7%       4371 ± 0%  TOTAL slabinfo.task_struct.active_slabs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     19150 ± 4%      -8.7%      17485 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     19150 ± 4%      -8.7%      17485 ± 0%  TOTAL slabinfo.task_struct.num_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1385 ± 2%     +13.8%       1576 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
      1385 ± 2%     +13.8%       1576 ± 4%  TOTAL numa-vmstat.node0.nr_alloc_batch

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     15330 ± 3%      -8.3%      14061 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     15330 ± 3%      -8.3%      14061 ± 0%  TOTAL slabinfo.kmalloc-1024.active_objs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    854631 ±15%     -82.4%     150502 ± 8%  lkp-snb01/hackbench/1600%-process-pipe
      8975 ± 0%      -5.5%       8486 ± 0%  xps2/pigz/100%-512K
    863606 ±15%     -81.6%     158988 ± 8%  TOTAL vmstat.system.in

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.089e+09 ± 5%     -48.6%  5.603e+08 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
    225282 ± 3%     +75.6%     395515 ± 0%  xps2/pigz/100%-512K
 1.089e+09 ± 5%     -48.5%  5.607e+08 ± 2%  TOTAL time.involuntary_context_switches

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 2.226e+09 ± 2%     -50.4%  1.104e+09 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
    259846 ± 0%     +67.5%     435184 ± 0%  xps2/pigz/100%-512K
 2.227e+09 ± 2%     -50.4%  1.105e+09 ± 2%  TOTAL time.voluntary_context_switches

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   5516027 ± 0%     -50.2%    2748065 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      1994 ± 1%     +61.1%       3212 ± 0%  xps2/pigz/100%-512K
   5518022 ± 0%     -50.1%    2751278 ± 1%  TOTAL vmstat.system.cs

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  17665402 ± 5%     +59.9%   28239273 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  17665402 ± 5%     +59.9%   28239273 ± 1%  TOTAL time.minor_page_faults

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1489 ± 1%      -5.8%       1402 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      1489 ± 1%      -5.8%       1402 ± 0%  TOTAL time.user_time

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     93.79 ± 0%      -2.7%      91.22 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     93.79 ± 0%      -2.7%      91.22 ± 0%  TOTAL turbostat.%c0

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2989 ± 0%      -2.5%       2916 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      2989 ± 0%      -2.5%       2916 ± 0%  TOTAL time.percent_of_cpu_this_job_got

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
           ± 0%      +1.8%            ± 0%  lkp-snb01/hackbench/1600%-process-pipe
           ± 0%      +1.8%            ± 0%  TOTAL turbostat.Cor_W

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
           ± 0%      +1.5%            ± 0%  lkp-snb01/hackbench/1600%-process-pipe
           ± 0%      +1.5%            ± 0%  TOTAL turbostat.Pkg_W

d9dcf63eab17615  40c5e72463e42659e15eba0c8  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     16679 ± 1%      -2.0%      16340 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     16679 ± 1%      -2.0%      16340 ± 0%  TOTAL time.system_time


Legend:
	±XX%    - stddev percent
	[+-]XX% - change percent


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang
