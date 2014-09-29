Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaI2GTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:19:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:57923 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaI2GTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="392882780"
Date: Mon, 29 Sep 2014 14:19:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [xen/spinlock] e0fc17a9363: +24.6% aim9.dir_rtns_1.ops_per_sec
Message-ID: <20140929061927.GA7320@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Konrad,

We are glad to find that your patch increases the aim9 test
performance by up to +24.6%!

e0fc17a936334c08b2729fff87168c03fdecf5b6 ("xen/spinlock: Don't enable them unconditionally.")

test case: brickland3/aim9/5s-all

brickland3 is an Ivy Bridge-EX with 512G memory.

c0914e61660fa7d  e0fc17a936334c08b2729fff8 
---------------  ------------------------- 
  10401445 ± 0%     +24.6%   12958400 ± 0%  TOTAL aim9.dir_rtns_1.ops_per_sec
    494461 ± 5%      +8.0%     534028 ± 1%  TOTAL aim9.link_test.ops_per_sec
   1840820 ± 0%      +4.5%    1924528 ± 0%  TOTAL aim9.fifo_test.ops_per_sec
   1251672 ± 0%      +5.0%    1314071 ± 0%  TOTAL aim9.dgram_pipe.ops_per_sec
   1097240 ± 1%      +5.0%    1152480 ± 0%  TOTAL aim9.signal_test.ops_per_sec
   1407192 ± 0%      +4.8%    1474424 ± 0%  TOTAL aim9.stream_pipe.ops_per_sec
   1898068 ± 1%      +4.7%    1987232 ± 0%  TOTAL aim9.pipe_cpy.ops_per_sec
   1298388 ± 1%      +3.5%    1343704 ± 0%  TOTAL aim9.shared_memory.ops_per_sec
     64202 ± 0%      -3.2%      62178 ± 1%  TOTAL aim9.misc_rtns_1.ops_per_sec
    -12622 ±-16%     +32.4%     -16710 ±-14%  TOTAL sched_debug.cfs_rq[116]:/.spread0
     -1977 ±-26%     -59.3%       -805 ±-42%  TOTAL cpuidle.C3-IVB.usage
    -13457 ±-8%     +19.2%     -16045 ±-17%  TOTAL sched_debug.cfs_rq[14]:/.spread0
     -7867 ±-42%     +61.3%     -12692 ±-10%  TOTAL sched_debug.cfs_rq[18]:/.spread0
        -4 ±-27%     -36.4%         -2 ±-34%  TOTAL sched_debug.cpu#19.nr_uninterruptible
    -12763 ±-8%     +19.1%     -15202 ±-10%  TOTAL sched_debug.cfs_rq[24]:/.spread0
    -13552 ±-8%     +20.5%     -16333 ±-14%  TOTAL sched_debug.cfs_rq[97]:/.spread0
         1 ± 0%    -100.0%          0 ± 0%  TOTAL sched_debug.cfs_rq[105]:/.nr_spread_over
      1857 ±48%     -69.7%        563 ±20%  TOTAL sched_debug.cfs_rq[97]:/.min_vruntime
       111 ±44%     -73.0%         30 ±42%  TOTAL sched_debug.cfs_rq[4]:/.blocked_load_avg
       160 ±48%     -60.5%         63 ±26%  TOTAL sched_debug.cpu#104.sched_goidle
      1288 ±37%     -58.1%        540 ±37%  TOTAL sched_debug.cfs_rq[67]:/.min_vruntime
       988 ±36%     -49.7%        497 ±46%  TOTAL sched_debug.cpu#55.ttwu_count
       114 ±20%     -59.4%         46 ±24%  TOTAL sched_debug.cfs_rq[48]:/.tg_load_contrib
       101 ±16%     -54.2%         46 ±24%  TOTAL sched_debug.cfs_rq[48]:/.blocked_load_avg
     32.50 ±41%     -52.7%      15.37 ±40%  TOTAL sched_debug.cfs_rq[66]:/.exec_clock
        38 ±29%     -39.3%         23 ±43%  TOTAL sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum
       469 ±24%     -40.5%        279 ±47%  TOTAL sched_debug.cpu#26.ttwu_local
      1754 ±34%    +113.5%       3744 ±14%  TOTAL sched_debug.cpu#40.sched_count
       123 ±27%     -49.9%         62 ±36%  TOTAL sched_debug.cfs_rq[47]:/.blocked_load_avg
       151 ±12%     -40.8%         89 ±31%  TOTAL sched_debug.cpu#93.ttwu_count
        68 ±44%     -49.6%         34 ±27%  TOTAL sched_debug.cfs_rq[50]:/.avg->runnable_avg_sum
      5584 ±20%     +40.0%       7818 ±18%  TOTAL sched_debug.cpu#84.nr_load_updates
       411 ±30%     -36.1%        262 ±24%  TOTAL sched_debug.cpu#23.ttwu_local
      1655 ±33%     -45.4%        903 ±32%  TOTAL sched_debug.cpu#2.sched_goidle
      3341 ±33%     -45.0%       1836 ±31%  TOTAL sched_debug.cpu#2.nr_switches
      8488 ±11%     +24.1%      10538 ±13%  TOTAL sched_debug.cpu#10.nr_load_updates
        19 ± 7%     +25.0%         24 ±12%  TOTAL sched_debug.cpu#114.ttwu_local
      8752 ±13%     +23.9%      10842 ±11%  TOTAL sched_debug.cpu#8.nr_load_updates
        24 ±10%     -16.9%         20 ± 9%  TOTAL sched_debug.cpu#68.ttwu_local
       901 ±38%     -46.5%        482 ±40%  TOTAL sched_debug.cpu#62.sched_goidle
      1862 ±37%     -43.9%       1045 ±35%  TOTAL sched_debug.cpu#62.nr_switches
     14555 ± 7%     +13.4%      16512 ± 8%  TOTAL sched_debug.cpu#106.nr_load_updates
      5433 ±10%     +20.4%       6542 ± 5%  TOTAL sched_debug.cpu#0.ttwu_local

                             aim9.signal_test.ops_per_sec

  1.16e+06 O+-O----O----------------------O-------O----O--O-O--O--O----O-O--+
           |    O    O     O O  O O  O  O    O O                            |
  1.14e+06 ++           O                            O              O       O
           |                                                                |
           |                                                                |
  1.12e+06 ++                                                               |
           |            *..*.    .*..*..       *..*..*.*..*.*..*..*         |
   1.1e+06 ++          :     *..*       *.*.. :                   :         |
           |           :                      :                    :        |
  1.08e+06 *+.  *..   :                      *                     :        |
           |   +   *.*                                             :        |
           |  *                                                     :       |
  1.06e+06 ++                                                       *       |
           |                                                                |
  1.04e+06 ++---------------------------------------------------------------+


                              aim9.dir_rtns_1.ops_per_sec

   1.4e+07 ++---------------------------------------------------------------+
           |            O  O      O          O O  O  O O  O O  O            |
  1.35e+07 ++                        O                                      |
   1.3e+07 ++      O O       O  O                                      O O  |
           O  O O                       O O                       O O       O
  1.25e+07 ++                                                               |
           |                                                                |
   1.2e+07 ++                                                               |
           |                                                                |
  1.15e+07 ++                                                               |
   1.1e+07 ++                                                               |
           |                                                                |
  1.05e+07 *+.*.*..*.*..*..*.          .*.*..*.*..*..         .*..          |
           |                 *..*.*..*.              *.*..*.*.    *.*       |
     1e+07 ++---------------------------------------------------------------+

	[*] bisect-good sample
	[O] bisect-bad  sample

To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: aim9
default_monitors:
  watch-oom: 
  wait: pre-test
  uptime: 
  iostat: 
  vmstat: 
  numa-numastat: 
  numa-vmstat: 
  numa-meminfo: 
  proc-vmstat: 
  proc-stat: 
  meminfo: 
  slabinfo: 
  interrupts: 
  lock_stat: 
  latency_stats: 
  softirqs: 
  bdi_dev_mapping: 
  diskstats: 
  energy: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
model: Brickland Ivy Bridge-EX
nr_cpu: 120
memory: 512G
hdd_partitions: 
swap_partitions: 
aim9:
  testtime: 5s
  test:
  - all
branch: linus/master
commit: 19583ca584d6f574384e17fe7613dfaeadcdc4a6
repeat_to: 3
enqueue_time: 2014-09-25 21:56:15.069539322 +08:00
testbox: brickland3
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/vmlinuz-3.16.0"
user: lkp
queue: wfg
result_root: "/result/brickland3/aim9/5s-all/debian-x86_64.cgz/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/0"
job_file: "/lkp/scheduled/brickland3/wfg_aim9-5s-all-x86_64-rhel-19583ca584d6f574384e17fe7613dfaeadcdc4a6-2.yaml"
dequeue_time: 2014-09-25 22:35:03.558121828 +08:00
history_time: 351.36
job_state: finished
loadavg: 0.96 0.69 0.32 1/969 35857
start_time: '1411655785'
end_time: '1411656085'
version: "/lkp/lkp/.src-20140925-212910"

--fdj2RfSjLxBAspz7--
