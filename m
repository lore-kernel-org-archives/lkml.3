Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaHGKyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:54:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:58905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaHGKyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,817,1400050800"; 
   d="scan'208";a="573044886"
Date: Thu, 7 Aug 2014 18:53:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/numa] 096aa33863a: -21.4% hackbench.throughput, -20.2%
 netperf.Throughput_Mbps
Message-ID: <20140807105311.GA17655@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Rik,

We noticed the below performance regression in commit
096aa33863a5e48de52d2ff30e0801b7487944f4 ("sched/numa: Decay
->wakee_flips instead of zeroing")

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    122361 ± 0%     -21.4%      96140 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    122361 ± 0%     -21.4%      96140 ± 0%  TOTAL hackbench.throughput

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1312 ± 0%     -20.2%       1046 ± 6%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1312 ± 0%     -20.2%       1046 ± 6%  TOTAL netperf.Throughput_Mbps

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      7908 ±22%  +23831.0%    1892653 ±25%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      7908 ±22%  +23831.0%    1892653 ±25%  TOTAL cpuidle.C1-NHM.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.35 ±33%     -96.0%       0.09 ±10%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      2.35 ±33%     -96.0%       0.09 ±10%  TOTAL perf-profile.cpu-cycles.memcpy.sctp_packet_transmit_chunk.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1250 ± 1%    -100.0%          0 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1250 ± 1%    -100.0%          0 ± 0%  TOTAL slabinfo.xfs_buf.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1957 ±19%    -100.0%          0 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1957 ±19%    -100.0%          0 ± 0%  TOTAL slabinfo.xfs_trans.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    288862 ±33%  +34804.6%  1.008e+08 ±27%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    288862 ±33%  +34804.6%  1.008e+08 ±27%  TOTAL cpuidle.C1-NHM.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.10 ±14%   +1423.1%       1.58 ±47%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      0.10 ±14%   +1423.1%       1.58 ±47%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_bh.lock_sock_nested.sctp_recvmsg.sock_common_recvmsg.sock_recvmsg

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    341158 ±30%  +30156.8%  1.032e+08 ±27%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    341158 ±30%  +30156.8%  1.032e+08 ±27%  TOTAL cpuidle.C1E-NHM.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      7320 ±33%  +32271.8%    2369681 ±26%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      7320 ±33%  +32271.8%    2369681 ±26%  TOTAL cpuidle.C1E-NHM.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    506973 ±31%   +3871.2%   20133029 ±25%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    506973 ±31%   +3871.2%   20133029 ±25%  TOTAL cpuidle.C3-NHM.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       292 ±11%   +7707.3%      22813 ±27%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
       292 ±11%   +7707.3%      22813 ±27%  TOTAL cpuidle.C3-NHM.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   7525714 ±17%    +544.6%   48513328 ±20%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   7525714 ±17%    +544.6%   48513328 ±20%  TOTAL cpuidle.C6-NHM.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1952 ±19%    -100.0%          0 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1952 ±19%    -100.0%          0 ± 0%  TOTAL slabinfo.xfs_trans.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1141 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1141 ± 0%    -100.0%          0 ± 0%  TOTAL slabinfo.xfs_buf.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.05 ±33%   +1596.2%       0.88 ±24%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      0.05 ±33%   +1596.2%       0.88 ±24%  TOTAL turbostat.%c3

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       716 ±10%   +2369.6%      17702 ±23%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
       716 ±10%   +2369.6%      17702 ±23%  TOTAL cpuidle.C6-NHM.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.32 ±12%    +291.8%       1.24 ± 6%  lkp-snb01/hackbench/50%-process-pipe
      0.32 ±12%    +291.8%       1.24 ± 6%  TOTAL perf-profile.cpu-cycles.osq_lock.__mutex_lock_slowpath.mutex_lock.pipe_write.do_sync_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.35 ± 8%    +250.9%       1.21 ± 6%  lkp-snb01/hackbench/50%-process-pipe
      0.35 ± 8%    +250.9%       1.21 ± 6%  TOTAL perf-profile.cpu-cycles.mutex_spin_on_owner.__mutex_lock_slowpath.mutex_lock.pipe_write.do_sync_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1108302 ± 1%     +70.8%    1893466 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     13338 ± 1%    +523.8%      83205 ±22%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   1121641 ± 1%     +76.2%    1976671 ± 1%  TOTAL softirqs.SCHED

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2.43 ± 2%     +32.7%       3.23 ± 0%  lkp-snb01/hackbench/50%-process-pipe
      0.08 ±27%  +25202.6%      19.74 ±27%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      2.51 ± 2%    +814.9%      22.96 ±23%  TOTAL turbostat.%c1

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1615.95 ± 4%     +19.9%    1938.14 ± 1%  lkp-snb01/hackbench/50%-process-pipe
     75.27 ± 1%    +413.0%     386.09 ±21%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   1691.22 ± 4%     +37.4%    2324.23 ± 4%  TOTAL uptime.idle

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.58 ±19%    +162.6%       1.52 ±13%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      0.58 ±19%    +162.6%       1.52 ±13%  TOTAL turbostat.%c6

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    704584 ± 4%    +177.7%    1956399 ± 1%  lkp-snb01/hackbench/50%-process-pipe
    704584 ± 4%    +177.7%    1956399 ± 1%  TOTAL cpuidle.C1E-SNB.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.51 ± 7%    +168.4%       1.37 ± 4%  lkp-snb01/hackbench/50%-process-pipe
      0.51 ± 7%    +168.4%       1.37 ± 4%  TOTAL perf-profile.cpu-cycles.__mutex_lock_slowpath.mutex_lock.pipe_write.do_sync_write.vfs_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.65 ± 2%    +140.9%       3.97 ± 4%  lkp-snb01/hackbench/50%-process-pipe
      1.65 ± 2%    +140.9%       3.97 ± 4%  TOTAL perf-profile.cpu-cycles.mutex_unlock.do_sync_write.vfs_write.sys_write.system_call_fastpath

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  30881148 ± 1%    +122.3%   68651628 ± 2%  lkp-snb01/hackbench/50%-process-pipe
  30881148 ± 1%    +122.3%   68651628 ± 2%  TOTAL cpuidle.C1E-SNB.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    130315 ± 1%     -51.5%      63146 ± 1%  lkp-snb01/hackbench/50%-process-pipe
    130315 ± 1%     -51.5%      63146 ± 1%  TOTAL cpuidle.C7-SNB.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      4.04 ± 0%     -50.5%       2.00 ± 8%  lkp-snb01/hackbench/50%-process-pipe
      4.04 ± 0%     -50.5%       2.00 ± 8%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      9880 ± 5%     -47.0%       5238 ± 5%  lkp-snb01/hackbench/50%-process-pipe
      9880 ± 5%     -47.0%       5238 ± 5%  TOTAL cpuidle.C3-SNB.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.40 ± 1%     -45.4%       0.76 ± 9%  lkp-snb01/hackbench/50%-process-pipe
      1.40 ± 1%     -45.4%       0.76 ± 9%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irq.__schedule.schedule.pipe_wait.pipe_read

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.55 ± 2%     -46.3%       0.83 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      1.55 ± 2%     -46.3%       0.83 ± 1%  TOTAL perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.27 ± 0%     +88.8%       2.40 ± 4%  lkp-snb01/hackbench/50%-process-pipe
      1.27 ± 0%     +88.8%       2.40 ± 4%  TOTAL perf-profile.cpu-cycles.mutex_lock.pipe_write.do_sync_write.vfs_write.sys_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
       366 ± 0%     -19.5%        295 ± 0%  lkp-snb01/hackbench/50%-process-pipe
        11 ± 0%     -58.2%          4 ±32%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
       377 ± 0%     -20.6%        300 ± 1%  TOTAL vmstat.procs.r

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      5.26 ± 4%     +70.0%       8.95 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      5.26 ± 4%     +70.0%       8.95 ± 1%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.pipe_write.do_sync_write.vfs_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.99 ± 5%     -37.2%       1.25 ± 6%  lkp-snb01/hackbench/50%-process-pipe
      1.99 ± 5%     -37.2%       1.25 ± 6%  TOTAL perf-profile.cpu-cycles.avc_has_perm.inode_has_perm.file_has_perm.selinux_file_permission.security_file_permission

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  41644859 ± 1%     -36.6%   26412030 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  41644859 ± 1%     -36.6%   26412030 ± 0%  TOTAL numa-numastat.node0.local_node

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  41645708 ± 1%     -36.6%   26414565 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  41645708 ± 1%     -36.6%   26414565 ± 0%  TOTAL numa-numastat.node0.numa_hit

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  21020151 ± 0%     -36.0%   13450417 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  21020151 ± 0%     -36.0%   13450417 ± 0%  TOTAL numa-vmstat.node0.numa_local

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  21084898 ± 0%     -35.9%   13516547 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  21084898 ± 0%     -35.9%   13516547 ± 0%  TOTAL numa-vmstat.node0.numa_hit

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.66 ± 2%     +56.1%       1.02 ± 3%  lkp-snb01/hackbench/50%-process-pipe
      0.66 ± 2%     +56.1%       1.02 ± 3%  TOTAL perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  76135896 ± 0%     -35.6%   49027766 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  76135896 ± 0%     -35.6%   49027766 ± 0%  TOTAL proc-vmstat.pgalloc_normal

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2075 ±17%     -25.7%       1543 ±26%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2075 ±17%     -25.7%       1543 ±26%  TOTAL slabinfo.blkdev_ioc.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      2076 ±17%     -25.4%       1549 ±27%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2076 ±17%     -25.4%       1549 ±27%  TOTAL slabinfo.blkdev_ioc.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  42478629 ± 1%     -35.0%   27615662 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  42478629 ± 1%     -35.0%   27615662 ± 0%  TOTAL numa-numastat.node1.local_node

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  42481997 ± 1%     -35.0%   27617365 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  42481997 ± 1%     -35.0%   27617365 ± 0%  TOTAL numa-numastat.node1.numa_hit

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  21585988 ± 1%     -34.6%   14110975 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  21585988 ± 1%     -34.6%   14110975 ± 0%  TOTAL numa-vmstat.node1.numa_local

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  21597275 ± 1%     -34.6%   14120957 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  21597275 ± 1%     -34.6%   14120957 ± 0%  TOTAL numa-vmstat.node1.numa_hit

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.86 ± 5%     +53.3%       2.85 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      1.86 ± 5%     +53.3%       2.85 ± 1%  TOTAL perf-profile.cpu-cycles.idle_cpu.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.92 ±13%     -31.2%       0.63 ± 5%  lkp-snb01/hackbench/50%-process-pipe
      0.92 ±13%     -31.2%       0.63 ± 5%  TOTAL perf-profile.cpu-cycles.touch_atime.pipe_read.do_sync_read.vfs_read.sys_read

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.96 ± 4%     -30.4%       0.67 ± 5%  lkp-snb01/hackbench/50%-process-pipe
      0.96 ± 4%     -30.4%       0.67 ± 5%  TOTAL perf-profile.cpu-cycles.update_cfs_shares.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    128510 ± 0%     -30.7%      89002 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    128510 ± 0%     -30.7%      89002 ± 2%  TOTAL meminfo.Active(file)

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     32134 ± 0%     -30.8%      22250 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
     32134 ± 0%     -30.8%      22250 ± 2%  TOTAL proc-vmstat.nr_active_file

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.08 ± 4%     -30.1%       0.76 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      1.08 ± 4%     -30.1%       0.76 ± 2%  TOTAL perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_write.system_call_fastpath

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    978152 ± 3%     -21.3%     769740 ±19%  lkp-snb01/hackbench/50%-process-pipe
    978152 ± 3%     -21.3%     769740 ±19%  TOTAL cpuidle.C3-SNB.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   8062365 ± 1%     -37.1%    5070607 ± 0%  lkp-snb01/hackbench/50%-process-pipe
 2.751e+08 ± 0%     -18.4%  2.245e+08 ± 6%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.832e+08 ± 0%     -18.9%  2.296e+08 ± 6%  TOTAL proc-vmstat.pgalloc_dma32

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      7722 ± 1%     -24.6%       5824 ±15%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      7722 ± 1%     -24.6%       5824 ±15%  TOTAL proc-vmstat.pgactivate

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  84116763 ± 0%     -35.8%   54027061 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  49792666 ± 0%     -20.2%   39712359 ± 6%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
 133909429 ± 0%     -30.0%   93739420 ± 2%  TOTAL proc-vmstat.numa_local

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  84120980 ± 0%     -35.8%   54031299 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  49792666 ± 0%     -20.2%   39712359 ± 6%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
 133913646 ± 0%     -30.0%   93743658 ± 2%  TOTAL proc-vmstat.numa_hit

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    672803 ± 0%     -28.1%     483704 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    672803 ± 0%     -28.1%     483704 ± 0%  TOTAL vmstat.memory.cache

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    672747 ± 0%     -28.1%     483713 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    672747 ± 0%     -28.1%     483713 ± 0%  TOTAL meminfo.Cached

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    168187 ± 0%     -28.1%     120926 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    168187 ± 0%     -28.1%     120926 ± 0%  TOTAL proc-vmstat.nr_file_pages

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.28 ± 7%     -28.9%       0.91 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      1.28 ± 7%     -28.9%       0.91 ± 2%  TOTAL perf-profile.cpu-cycles.copy_page_to_iter.pipe_read.do_sync_read.vfs_read.sys_read

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  84177329 ± 0%     -35.8%   54079701 ± 0%  lkp-snb01/hackbench/50%-process-pipe
 2.781e+08 ± 0%     -18.4%  2.269e+08 ± 6%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.623e+08 ± 0%     -22.4%   2.81e+08 ± 5%  TOTAL proc-vmstat.pgfree

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    541579 ± 0%     -27.6%     392085 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    541579 ± 0%     -27.6%     392085 ± 0%  TOTAL meminfo.Inactive(file)

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    135388 ± 0%     -27.6%      98019 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    135388 ± 0%     -27.6%      98019 ± 0%  TOTAL proc-vmstat.nr_inactive_file

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    541892 ± 0%     -27.6%     392387 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    541892 ± 0%     -27.6%     392387 ± 0%  TOTAL meminfo.Inactive

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.07 ± 3%     -27.2%       0.78 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      1.07 ± 3%     -27.2%       0.78 ± 1%  TOTAL perf-profile.cpu-cycles.__read_nocancel

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.91 ± 2%     -26.9%       1.40 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      1.91 ± 2%     -26.9%       1.40 ± 2%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.pipe_write.do_sync_write.vfs_write.sys_write

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    153459 ± 0%     -25.8%     113813 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    153459 ± 0%     -25.8%     113813 ± 2%  TOTAL meminfo.Active

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1426 ± 2%     -25.2%       1067 ± 1%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1426 ± 2%     -25.2%       1067 ± 1%  TOTAL slabinfo.ftrace_event_file.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1426 ± 2%     -25.2%       1067 ± 1%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1426 ± 2%     -25.2%       1067 ± 1%  TOTAL slabinfo.ftrace_event_file.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 4.199e+08 ± 2%     +33.3%  5.596e+08 ± 0%  lkp-snb01/hackbench/50%-process-pipe
 4.199e+08 ± 2%     +33.3%  5.596e+08 ± 0%  TOTAL cpuidle.C1-SNB.time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.49 ± 1%     -25.7%       1.10 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      1.49 ± 1%     -25.7%       1.10 ± 2%  TOTAL perf-profile.cpu-cycles.__switch_to.__read_nocancel

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.25 ± 2%     +31.6%       1.64 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      1.25 ± 2%     +31.6%       1.64 ± 2%  TOTAL perf-profile.cpu-cycles.__fget_light.sys_write.system_call_fastpath.__write_nocancel

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    614765 ± 0%     -23.5%     470579 ± 8%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    614765 ± 0%     -23.5%     470579 ± 8%  TOTAL softirqs.TIMER

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     11425 ± 2%     -12.9%       9951 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      4365 ± 2%     -16.9%       3630 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2117 ± 2%     -34.4%       1388 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
     17908 ± 2%     -16.4%      14970 ± 2%  TOTAL slabinfo.kmalloc-128.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     41164 ±12%     +20.9%      49766 ± 6%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
     41164 ±12%     +20.9%      49766 ± 6%  TOTAL meminfo.DirectMap4k

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8060 ± 3%     -19.9%       6457 ± 4%  lkp-snb01/hackbench/50%-process-pipe
      8060 ± 3%     -19.9%       6457 ± 4%  TOTAL slabinfo.task_xstate.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      8016 ± 3%     -19.5%       6450 ± 4%  lkp-snb01/hackbench/50%-process-pipe
      8016 ± 3%     -19.5%       6450 ± 4%  TOTAL slabinfo.task_xstate.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   3039372 ± 2%     -20.6%    2414002 ± 7%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   3039372 ± 2%     -20.6%    2414002 ± 7%  TOTAL proc-vmstat.pgalloc_dma

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    159254 ± 1%     -19.6%     128113 ± 1%  lkp-snb01/hackbench/50%-process-pipe
    159254 ± 1%     -19.6%     128113 ± 1%  TOTAL proc-vmstat.numa_hint_faults_local

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      9.33 ± 2%     -16.4%       7.80 ± 7%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      9.33 ± 2%     -16.4%       7.80 ± 7%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  86862453 ± 1%     +22.1%  1.061e+08 ± 0%  lkp-snb01/hackbench/50%-process-pipe
  86862453 ± 1%     +22.1%  1.061e+08 ± 0%  TOTAL cpuidle.C1-SNB.usage

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1.30 ± 5%     +16.2%       1.51 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      1.30 ± 5%     +16.2%       1.51 ± 1%  TOTAL perf-profile.cpu-cycles.vfs_write.sys_write.system_call_fastpath.__write_nocancel

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     11443 ± 2%     -12.5%      10010 ± 2%  lkp-snb01/hackbench/50%-process-pipe
      4574 ± 2%     -16.2%       3832 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2117 ± 2%     -17.7%       1741 ± 4%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
     18135 ± 2%     -14.1%      15585 ± 2%  TOTAL slabinfo.kmalloc-128.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    454028 ± 0%     -14.7%     387291 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    454028 ± 0%     -14.7%     387291 ± 0%  TOTAL proc-vmstat.numa_pte_updates

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1129166 ± 0%     +17.1%    1322132 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   1129166 ± 0%     +17.1%    1322132 ± 0%  TOTAL vmstat.memory.free

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1129151 ± 0%     +17.1%    1322021 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   1129151 ± 0%     +17.1%    1322021 ± 0%  TOTAL meminfo.MemFree

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    282289 ± 0%     +17.1%     330504 ± 0%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
    282289 ± 0%     +17.1%     330504 ± 0%  TOTAL proc-vmstat.nr_free_pages

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   1352710 ± 1%      -9.6%    1222637 ± 2%  lkp-snb01/hackbench/50%-process-pipe
     59510 ± 5%     -20.1%      47545 ±10%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   1412220 ± 2%     -10.1%    1270182 ± 2%  TOTAL softirqs.RCU

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      7978 ± 0%     -13.8%       6877 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      7978 ± 0%     -13.8%       6877 ± 1%  TOTAL slabinfo.files_cache.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      7978 ± 0%     -13.8%       6877 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      7978 ± 0%     -13.8%       6877 ± 1%  TOTAL slabinfo.files_cache.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   6685911 ± 6%     -12.8%    5832341 ± 1%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   6685911 ± 6%     -12.8%    5832341 ± 1%  TOTAL softirqs.NET_RX

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3213 ± 1%     -14.3%       2754 ± 2%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2737 ± 1%     -11.8%       2414 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      5950 ± 1%     -13.1%       5168 ± 2%  TOTAL slabinfo.shared_policy_node.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3213 ± 1%     -14.3%       2754 ± 2%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2737 ± 1%     -11.8%       2414 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
      5950 ± 1%     -13.1%       5168 ± 2%  TOTAL slabinfo.shared_policy_node.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     19418 ± 1%     +14.3%      22186 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     19418 ± 1%     +14.3%      22186 ± 0%  TOTAL softirqs.HRTIMER

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      5265 ± 1%      -9.8%       4750 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      5265 ± 1%      -9.8%       4750 ± 1%  TOTAL slabinfo.signal_cache.active_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      5359 ± 1%      -9.5%       4851 ± 1%  lkp-snb01/hackbench/50%-process-pipe
      5359 ± 1%      -9.5%       4851 ± 1%  TOTAL slabinfo.signal_cache.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     19262 ± 2%      -8.2%      17684 ± 3%  lkp-snb01/hackbench/50%-process-pipe
     19262 ± 2%      -8.2%      17684 ± 3%  TOTAL slabinfo.kmalloc-192.num_objs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     72008 ± 0%      -8.7%      65715 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     72008 ± 0%      -8.7%      65715 ± 0%  TOTAL proc-vmstat.pgmigrate_success

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     72008 ± 0%      -8.7%      65715 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     72008 ± 0%      -8.7%      65715 ± 0%  TOTAL proc-vmstat.numa_pages_migrated

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3.05 ±36%     -67.0%       1.01 ± 4%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
      3.05 ±36%     -67.0%       1.01 ± 4%  TOTAL iostat.sdf.wrqm/s

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    873523 ± 1%     +71.8%    1501063 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    873523 ± 1%     +71.8%    1501063 ± 0%  TOTAL vmstat.system.in

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  28067347 ± 1%     -33.7%   18595224 ± 1%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
  28067347 ± 1%     -33.7%   18595224 ± 1%  TOTAL perf-stat.iTLB-load-misses

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 2.631e+09 ± 0%     -26.9%  1.922e+09 ± 0%  lkp-snb01/hackbench/50%-process-pipe
 2.631e+09 ± 0%     -26.9%  1.922e+09 ± 0%  TOTAL time.voluntary_context_switches

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      1240 ± 0%     -25.2%        928 ± 0%  lkp-snb01/hackbench/50%-process-pipe
      1240 ± 0%     -25.2%        928 ± 0%  TOTAL time.user_time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 7.586e+08 ± 0%     -39.2%  4.614e+08 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    149744 ± 1%      +4.0%     155739 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 7.587e+08 ± 0%     -39.2%  4.616e+08 ± 0%  TOTAL time.involuntary_context_switches

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     99.29 ± 0%     -21.6%      77.86 ± 7%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
     99.29 ± 0%     -21.6%      77.86 ± 7%  TOTAL turbostat.%c0

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   5681114 ± 0%     -29.0%    4034794 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     11667 ± 0%      -9.0%      10620 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
     41698 ±10%     +15.9%      48342 ± 2%  lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
   5734480 ± 0%     -28.6%    4093757 ± 0%  TOTAL vmstat.system.cs

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
    729049 ± 0%     -15.6%     615443 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    729049 ± 0%     -15.6%     615443 ± 0%  TOTAL time.minor_page_faults

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.232e+09 ± 7%     -12.6%  1.077e+09 ± 4%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 1.232e+09 ± 7%     -12.6%  1.077e+09 ± 4%  TOTAL perf-stat.dTLB-store-misses

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 7.771e+09 ± 0%     +10.8%  8.608e+09 ± 1%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 7.771e+09 ± 0%     +10.8%  8.608e+09 ± 1%  TOTAL perf-stat.branch-misses

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
   7102173 ± 0%      -8.9%    6468745 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
   7102173 ± 0%      -8.9%    6468745 ± 0%  TOTAL perf-stat.context-switches

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 7.793e+09 ± 0%     +10.2%  8.589e+09 ± 2%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 7.793e+09 ± 0%     +10.2%  8.589e+09 ± 2%  TOTAL perf-stat.branch-load-misses

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
           ± 0%      -4.6%            ± 0%  lkp-snb01/hackbench/50%-process-pipe
           ± 0%      -4.6%            ± 0%  TOTAL turbostat.Cor_W

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.887e+12 ± 0%      +4.4%  1.971e+12 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 1.887e+12 ± 0%      +4.4%  1.971e+12 ± 0%  TOTAL perf-stat.dTLB-loads

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 1.885e+12 ± 0%      +4.4%  1.967e+12 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 1.885e+12 ± 0%      +4.4%  1.967e+12 ± 0%  TOTAL perf-stat.L1-dcache-loads

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
           ± 0%      -3.3%            ± 0%  lkp-snb01/hackbench/50%-process-pipe
           ± 0%      -3.3%            ± 0%  TOTAL turbostat.Pkg_W

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     17763 ± 0%      +2.1%      18139 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     17763 ± 0%      +2.1%      18139 ± 0%  TOTAL time.system_time

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      3087 ± 0%      -1.2%       3050 ± 0%  lkp-snb01/hackbench/50%-process-pipe
      3087 ± 0%      -1.2%       3050 ± 0%  TOTAL time.percent_of_cpu_this_job_got

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
  6.85e+12 ± 0%      +1.5%  6.953e+12 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
  6.85e+12 ± 0%      +1.5%  6.953e+12 ± 0%  TOTAL perf-stat.ref-cycles

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     92145 ± 0%      +0.8%      92909 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
     92145 ± 0%      +0.8%      92909 ± 0%  TOTAL iostat.sdf.wkB/s

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 8.563e+11 ± 0%      +1.5%  8.689e+11 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 8.563e+11 ± 0%      +1.5%  8.689e+11 ± 0%  TOTAL perf-stat.bus-cycles

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     92292 ± 0%      +0.9%      93079 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
     92292 ± 0%      +0.9%      93079 ± 0%  TOTAL iostat.sdj.wkB/s

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 6.859e+12 ± 0%      +1.3%  6.951e+12 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 6.859e+12 ± 0%      +1.3%  6.951e+12 ± 0%  TOTAL perf-stat.cpu-cycles

b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
 6.148e+12 ± 0%      +1.1%  6.217e+12 ± 0%  lkp-st02/dd-write/11HDD-JBOD-cfq-xfs-10dd
 6.148e+12 ± 0%      +1.1%  6.217e+12 ± 0%  TOTAL perf-stat.L1-icache-loads


Thanks,
Fengguang

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000
/usr/bin/hackbench -g 16 --process --pipe -l 60000

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--gKMricLos+KVdGMg--
