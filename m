Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaJ0CON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:14:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:45142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaJ0COL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:14:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="yaml'?scan'208";a="621098066"
Date: Mon, 27 Oct 2014 10:14:25 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched] 8236d907ab3: 2% vm-scalability.throughput
Message-ID: <20141027021425.GD27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 8236d907ab3411ad452280faa8b26c1347327380 ("sched: Reduce contention in update_cfs_rq_blocked_load()")


5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
   8957484 ±  0%      +1.9%    9123335 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
   8977343 ±  0%      +2.0%    9152823 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
   8967408            +1.9%    9138067        GEO-MEAN vm-scalability.throughput

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      4.05 ±  5%     -99.0%       0.04 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      3.95 ±  4%     -98.9%       0.04 ±  9%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      4.00           -99.0%       0.04        GEO-MEAN perf-profile.cpu-cycles.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle.tick_sched_timer

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      3.88 ±  4%     -99.5%       0.02 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      3.83 ±  2%     -99.5%       0.02 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      3.85           -99.5%       0.02        GEO-MEAN perf-profile.cpu-cycles.update_cfs_rq_blocked_load.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        61 ± 43%     -70.8%         18 ± 24%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
        61           -70.8%         17        GEO-MEAN sched_debug.cfs_rq[50]:/.tg_load_contrib

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      7257 ± 37%    +106.2%      14962 ± 49%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      7257          +106.2%      14962        GEO-MEAN sched_debug.cpu#1.sched_count

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      0.06 ± 15%     +96.8%       0.12 ± 18%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      0.06           +96.8%       0.12        GEO-MEAN turbostat.%c1

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
       415 ± 14%     -24.7%        313 ± 33%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
       415           -24.7%        312        GEO-MEAN slabinfo.blkdev_queue.num_objs

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      2080 ± 21%     +78.4%       3711 ± 44%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      2080           +78.4%       3711        GEO-MEAN sched_debug.cpu#33.ttwu_count

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        58 ± 39%     +93.1%        112 ± 34%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
        58           +93.1%        112        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_load_contrib

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      5708 ± 13%     -14.8%       4862 ± 19%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      5708           -14.8%       4862        GEO-MEAN meminfo.AnonHugePages

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
       487 ±  9%     +42.3%        693 ± 14%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
       487           +42.3%        693        GEO-MEAN sched_debug.cpu#20.sched_goidle

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        15 ± 10%     +37.3%         20 ± 12%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
        15           +37.3%         20        GEO-MEAN sched_debug.cpu#26.load

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        18 ±  7%     -19.4%         15 ±  5%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
        18           -19.4%         15        GEO-MEAN sched_debug.cpu#49.cpu_load[3]

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
       231 ± 14%     -25.0%        173 ± 20%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
       231           -25.0%        173        GEO-MEAN sched_debug.cpu#58.sched_goidle

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
   1441314 ±  3%     +26.9%    1829712 ±  2%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
   1414086 ±  8%     +23.6%    1747307 ±  8%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
   1427635           +25.2%    1788034        GEO-MEAN softirqs.RCU

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        17 ±  6%     -16.9%         14 ±  5%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
        17           -16.9%         14        GEO-MEAN sched_debug.cpu#49.cpu_load[4]

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
        19 ±  9%     -16.8%         15 ±  7%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
        18           -16.8%         15        GEO-MEAN sched_debug.cpu#49.cpu_load[2]

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      1196 ±  8%     +17.3%       1403 ±  5%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      1196           +17.3%       1403        GEO-MEAN sched_debug.cpu#49.sched_goidle

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
     98963 ±  0%     +52.9%     151281 ± 38%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
     98963           +52.9%     151281        GEO-MEAN numa-meminfo.node3.FilePages

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
     24740 ±  0%     +52.9%      37819 ± 38%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
     24740           +52.9%      37819        GEO-MEAN numa-vmstat.node3.nr_file_pages

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
     38000 ±  1%     +15.9%      44042 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
     38312 ±  2%     +13.9%      43643 ±  1%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
     38156           +14.9%      43842        GEO-MEAN proc-vmstat.pgactivate

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      3.29 ±  6%     +15.3%       3.80 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      3.33 ±  2%     +14.0%       3.79 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      3.31           +14.7%       3.79        GEO-MEAN perf-profile.cpu-cycles.__drand48_iterate

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
      3.34 ±  6%     +14.9%       3.83 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
      3.37 ±  2%     +13.8%       3.84 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
      3.35           +14.3%       3.83        GEO-MEAN perf-profile.cpu-cycles.__nrand48_r

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
     81.57 ±  0%     +10.8%      90.40 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
     81.61 ±  0%     +10.8%      90.40 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
     81.59           +10.8%      90.40        GEO-MEAN perf-profile.cpu-cycles.do_unit

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
     39878 ±  0%      -9.5%      36107 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
     39774 ±  0%      -9.3%      36061 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
     39826            -9.4%      36084        GEO-MEAN proc-vmstat.nr_shmem

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
    159494 ±  0%      -9.5%     144409 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
    159156 ±  0%      -9.3%     144313 ±  0%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand
    159325            -9.4%     144361        GEO-MEAN meminfo.Shmem

5cd038f53ed9ec7a  8236d907ab3411ad452280faa8  
----------------  --------------------------  
    144353 ±  2%      -3.7%     138984 ±  2%  lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt
    144353            -3.7%     138984        GEO-MEAN time.involuntary_context_switches

lkp-nex06: Nehalem-EX
Memory: 64G




                               vm-scalability.throughput

  9.15e+06 ++---------------------------------------------------------------+
           O  O O  O O  O O    O  O O    O    O    O  O O  O O  O O  O O    |
           |                 O         O    O    O                        O O
   9.1e+06 ++                                                               |
           |                                                                |
           |                                                                |
  9.05e+06 ++                                                               |
           |                                                                |
     9e+06 ++             *..                                               |
           |             :       .*.*..*.  .*.*..                           |
           | .*     .*.. :   *.*.        *.          .*    *.  .*           |
  8.95e+06 *+  +  .*    *                        *.*.  :  +  *.             |
           |    *.                                     : +                  |
           |                                            *                   |
   8.9e+06 ++---------------------------------------------------------------+


                         perf-profile.cpu-cycles.do_unit

  91 ++---------------------------------------------------------------------+
  90 O+ O O  O  O  O O  O  O  O O  O  O  O O  O  O O  O  O  O O  O  O  O O  O
     |                                                                      |
  89 ++                                                                     |
  88 ++                                                                     |
     |                                                                      |
  87 ++                                                                     |
  86 ++                                                                     |
  85 ++                                                                     |
     |                                                                      |
  84 ++                                                                     |
  83 ++             .*..  .*..                                              |
     |            .*    *.    *.*..*..*..*.                                 |
  82 *+.*.*..  .*.                         *..  .*.  .*..  .*.*             |
  81 ++------*--------------------------------*----*-----*------------------+




  4.5 ++--------------------------------------------------------------------+
      |    *..                               .*..*..*.*..*..                |
    4 *+. +   *..*.                         *               *..             |
  3.5 ++ *         *..   *..*.            ..                   *            |
      |                ..     *..*..*.*..*                                  |
    3 ++              *                                                     |
  2.5 ++                                                                    |
      |                                                                     |
    2 ++                                                                    |
  1.5 ++                                                                    |
      |                                                                     |
    1 ++                                                                    |
  0.5 ++                                                                    |
      |                                                                     |
    0 O+-O-O--O--O-O--O--O--O-O--O--O-O--O--O-O--O--O-O--O--O--O-O--O--O-O--O




  4.5 ++--------------------------------------------------------------------+
      | .*.  .*..                             *..    .*..                   |
    4 *+   *.                           .*.. +   *..*    *..*..             |
  3.5 ++         *.*..  .*..  *..*..*.*.    *                  *            |
      |               *.     +                                              |
    3 ++                    *                                               |
  2.5 ++                                                                    |
      |                                                                     |
    2 ++                                                                    |
  1.5 ++                                                                    |
      |                                                                     |
    1 ++                                                                    |
  0.5 ++                                                                    |
      |                                                                     |
    0 O+-O-O--O--O-O--O--O--O-O--O--O-O--O--O-O--O--O-O--O--O--O-O--O--O-O--O

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

--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: vm-scalability
default_monitors:
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
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: f114040e3ea6e07372334ade75d1ee0775c355e1
model: Nehalem-EX
memory: 64G
nr_cpu: 64
nr_hdd_partitions: 0
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
rootfs: clearlinux-x86_64.cgz
perf-profile: 
runtime: 300s
size: 
vm-scalability:
  test:
  - anon-r-rand-mt
enqueue_time: 2014-10-20 19:47:26.224657155 +08:00
testbox: lkp-nex06
tbox_group: lkp-nex06
kconfig: x86_64-rhel
head_commit: 013f60452114297bfd33978560ffa4af7e86d4a8
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102021
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/lkp-nex06/vm-scalability/performance-300s-anon-r-rand-mt/clearlinux-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/lkp-nex06/cyclic_vm-scalability-performance-300s-anon-r-rand-mt-clearlinux-x86_64.cgz-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-20 21:31:13.916638103 +08:00
job_state: finished
loadavg: 54.12 39.81 17.83 1/527 10830
start_time: '1413811953'
end_time: '1413812255'
version: "/lkp/lkp/.src-20141020-213002"

--zx4FCpZtqtKETZ7O
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
echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
truncate -s 33607528448 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-anon-r-rand-mt
./usemem --runtime 300 -t 64 --readonly --random 68719476736
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--zx4FCpZtqtKETZ7O--
