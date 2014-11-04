Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaKDEZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:25:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:32095 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaKDEZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,311,1413270000"; 
   d="yaml'?scan'208";a="626007655"
Date: Tue, 4 Nov 2014 12:26:04 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: LKP <lkp@linux.intel.com>, Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [mm] aabfb57296e: -14.0% time.system_time
Message-ID: <20141104042604.GK27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9ZOS6odDaRI+0hI"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit aabfb57296e3dd9761e47736ec69305c95461d7d ("mm: memcontrol: do not kill uncharge batching in free_pages_and_swap_cache")


01c2965f0723a252  aabfb57296e3dd9761e47736ec  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \
      2017 ±  3%     -14.0%       1735 ±  2%  lkp-hsw01/vm-scalability/performance-300s-16G-shm-pread-rand
      2017           -14.0%       1735        GEO-MEAN time.system_time

01c2965f0723a252  aabfb57296e3dd9761e47736ec
----------------  --------------------------
       332 ±  0%      -1.3%        328 ±  0%  lkp-hsw01/vm-scalability/performance-300s-16G-shm-pread-rand
       332            -1.3%        328        GEO-MEAN time.elapsed_time



                                 time.elapsed_time

  334 ++--------------------------------------------------------------------+
      *.    .*.. .*.*.. .*..*.*..*.*.*..*.                                  |
  333 ++*..*    *      *                  *..*.*.*..*.    .*..   .*..*      |
      |                                               *..*    *.*     +  .* |
  332 ++                                                               *.   |
      |                                                                     |
  331 ++                                                                    |
      |                                                                     |
  330 ++                                                                    |
      |                                                                     |
  329 ++                                                                    |
      |    O O  O O              O O O       O   O         O      O  O      |
  328 O+            O  O O  O O         O           O O  O      O      O  O O
      | O                                 O    O              O             |
  327 ++--------------------------------------------------------------------+


  
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

--/9ZOS6odDaRI+0hI
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
model: Grantley Haswell-EP
nr_cpu: 56
memory: 64G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
perf-profile: 
runtime: 300s
size: 16G
vm-scalability:
  test:
  - shm-pread-rand
enqueue_time: 2014-10-20 23:45:27.303040617 +08:00
testbox: lkp-hsw01
tbox_group: lkp-hsw01
kconfig: x86_64-rhel
head_commit: 34295884f135c1d9f34936a39b87741cdb04c492
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102109
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/lkp-hsw01/vm-scalability/performance-300s-16G-shm-pread-rand/debian-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-16G-shm-pread-rand-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-21 10:08:31.140512609 +08:00
job_state: finished
loadavg: 51.25 36.48 16.41 1/451 11058
start_time: '1413857358'
end_time: '1413857686'
version: "/lkp/lkp/.src-20141020-230438"

--/9ZOS6odDaRI+0hI
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
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
truncate -s 67407212544 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-shm-pread-rand
truncate /tmp/vm-scalability-tmp/sparse-shm-pread-rand -s 67407212544
./usemem --runtime 300 -n 56 -f /tmp/vm-scalability-tmp/sparse-shm-pread-rand --readonly --random 33703606272
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/9ZOS6odDaRI+0hI--
