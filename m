Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaKXCvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:51:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:64404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaKXCvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:51:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,446,1413270000"; 
   d="yaml'?scan'208";a="642316807"
Date: Mon, 24 Nov 2014 10:51:41 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [x86, irq, ACPI] 5fcb864ef90: -3.3%(vm-scalability.throughput)
   +12.9%(turbostat.%c0)
Message-ID: <20141124025141.GA7310@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hi,

We noticed the below changes on(NOTE: I'm not sure the bisect is correct
or not, here I report it out JFYI).

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 5fcb864ef90df093d964171539c87ffa0ab49f0f ("x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC hot-removal")


testbox/testcase/testparams: lkp-nex06/vm-scalability/performance-300s-small-allocs-mt

ff6213974cd90e1e  5fcb864ef90df093d964171539  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :5           20%           1:5     kmsg.CE:hpet_increased_min_delta_ns_to#nsec
         %stddev     %change         %stddev
             \          |                \  
    315326 ±  0%      -3.3%     304841 ±  0%  vm-scalability.throughput
     11.82 ±  0%     +12.9%      13.34 ±  0%  turbostat.%c0
      1.34 ±  0%      +9.4%       1.46 ±  0%  turbostat.GHz
        12 ± 47%     +78.7%         21 ± 32%  sched_debug.cfs_rq[29]:/.load
       113 ± 26%     +86.3%        212 ± 28%  sched_debug.cfs_rq[39]:/.tg_load_contrib
       106 ± 28%     +89.5%        202 ± 30%  sched_debug.cfs_rq[39]:/.blocked_load_avg
        66 ± 23%    +120.6%        145 ± 29%  sched_debug.cfs_rq[40]:/.blocked_load_avg
        70 ± 23%    +113.0%        150 ± 29%  sched_debug.cfs_rq[40]:/.tg_load_contrib
     10145 ± 23%     -38.3%       6255 ± 35%  numa-meminfo.node1.AnonPages
      2535 ± 23%     -38.3%       1564 ± 35%  numa-vmstat.node1.nr_anon_pages
       605 ± 16%     -22.0%        471 ±  5%  sched_debug.cpu#58.nr_uninterruptible
     58904 ±  7%     -13.8%      50762 ±  7%  sched_debug.cfs_rq[0]:/.min_vruntime
    481299 ±  8%     -13.4%     416975 ±  7%  sched_debug.cpu#0.sched_count
    409009 ± 11%     -15.7%     344638 ±  2%  sched_debug.cpu#4.sched_count
     52022 ± 10%     -16.1%      43623 ±  2%  sched_debug.cfs_rq[4]:/.min_vruntime
        68 ±  3%     -12.2%         60 ±  3%  sched_debug.cfs_rq[4]:/.tg_runnable_contrib
      3175 ±  3%     -12.1%       2791 ±  3%  sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
     50060 ±  6%     -12.3%      43914 ±  4%  sched_debug.cfs_rq[29]:/.min_vruntime
      1751 ± 12%     -15.5%       1480 ±  6%  sched_debug.cpu#63.nr_uninterruptible
      2967 ±  6%     -13.7%       2562 ±  4%  sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum
        63 ±  6%     -13.8%         55 ±  4%  sched_debug.cfs_rq[37]:/.tg_runnable_contrib
      1.07 ±  2%     -10.9%       0.95 ±  3%  perf-profile.cpu-cycles.tick_nohz_restart.tick_nohz_idle_exit.cpu_startup_entry.start_secondary
      1.64 ±  2%      -8.4%       1.50 ±  4%  perf-profile.cpu-cycles.__tick_nohz_idle_enter.tick_nohz_idle_enter.cpu_startup_entry.start_secondary
     35173 ±  5%      -9.1%      31983 ±  3%  sched_debug.cfs_rq[56]:/.min_vruntime
      1.41 ±  2%      -8.3%       1.29 ±  4%  perf-profile.cpu-cycles.tick_nohz_stop_sched_tick.__tick_nohz_idle_enter.tick_nohz_idle_enter.cpu_startup_entry.start_secondary
      1.63 ±  1%      -9.3%       1.48 ±  3%  perf-profile.cpu-cycles.tick_nohz_idle_exit.cpu_startup_entry.start_secondary
     45161 ± 11%     -12.8%      39358 ±  4%  sched_debug.cfs_rq[25]:/.min_vruntime
     39201 ±  5%     +17.3%      45969 ± 18%  sched_debug.cfs_rq[8]:/.min_vruntime
  21071502 ±  0%      -3.3%   20379730 ±  0%  time.minor_page_faults
       299 ±  0%      -3.1%        290 ±  0%  time.user_time
  21763267 ±  0%      -3.3%   21055329 ±  0%  time.voluntary_context_switches
    142199 ±  0%      -3.1%     137732 ±  0%  vmstat.system.cs
       737 ±  0%      -2.1%        721 ±  1%  time.system_time
       341 ±  0%      -2.5%        333 ±  0%  time.percent_of_cpu_this_job_got

lkp-nex06: Nehalem-EX
Memory: 64G




                                   turbostat.%c0

    14 ++-------------------------------------------------------------------+
       |                                                    O               |
       |                      O  O   O  O  O                                |
  13.5 O+           O                         O   O  O  O         O  O      |
       |  O   O        O                                       O         O  |
       |         O         O                                                O
    13 ++                                                                   |
       |                                                                    |
  12.5 ++                                                                   |
       |                                                                    |
       |                                                                    |
    12 *+.*...*..     .*...                                                 |
       |         *..*.     *..  .*...*..*..*..*...  .*..*                   |
       |                      *.                  *.                        |
  11.5 ++-------------------------------------------------------------------+


                                   turbostat.GHz

  1.48 ++-------------------------------------------------------------------+
       O            O  O      O  O   O  O  O  O   O         O     O         |
  1.46 ++ O   O  O         O                         O  O      O     O   O  O
  1.44 ++                                                                   |
       |                                                                    |
  1.42 ++                                                                   |
       |                                                                    |
   1.4 ++                                                                   |
       |                                                                    |
  1.38 ++                                                                   |
  1.36 ++                                                                   |
       |                                                                    |
  1.34 ++             .*...*..            .*..*...  .*..                    |
       *..*...*..*..*.        *..*...*..*.        *.    *                   |
  1.32 ++-------------------------------------------------------------------+

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

	--yliu

--9jxsPFA5p3P2qPhR
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
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: a03701e00a84696f75e964e9bbfd65f877c14a79
model: Nehalem-EX
memory: 64G
nr_cpu: 64
nr_hdd_partitions: 0
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
rootfs: clearlinux-x86_64-20141105.cgz
perf-profile: 
runtime: 300s
size: 
vm-scalability:
  test:
  - small-allocs-mt
testbox: lkp-nex06
tbox_group: lkp-nex06
kconfig: x86_64-rhel
head_commit: a03701e00a84696f75e964e9bbfd65f877c14a79
base_commit: 206c5f60a3d902bc4b56dab2de3e88de5eb06108
branch: linux-devel/devel-hourly-2014111608
kernel: "/kernel/x86_64-rhel/a03701e00a84696f75e964e9bbfd65f877c14a79/vmlinuz-3.18.0-rc4-ga03701e"
user: lkp
queue: cyclic
result_root: "/result/lkp-nex06/vm-scalability/performance-300s-small-allocs-mt/clearlinux-x86_64-20141105.cgz/x86_64-rhel/a03701e00a84696f75e964e9bbfd65f877c14a79/0"
job_file: "/lkp/scheduled/lkp-nex06/cyclic_vm-scalability-performance-300s-small-allocs-mt-clearlinux-x86_64.cgz-x86_64-rhel-HEAD-a03701e00a84696f75e964e9bbfd65f877c14a79-0.yaml"
dequeue_time: 2014-11-16 12:04:05.930676475 +08:00
job_state: finished
loadavg: 53.94 39.41 17.58 1/531 11109
start_time: '1416139534'
end_time: '1416139837'
version: "/lkp/lkp/.src-20141116-120022"

--9jxsPFA5p3P2qPhR
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
truncate -s 33607413760 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-small-allocs-mt
./usemem --runtime 300 -t 64 --readonly --unit 40960 68719476736
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--9jxsPFA5p3P2qPhR--
