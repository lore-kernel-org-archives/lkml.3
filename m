Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaI3IGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:06:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:6184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaI3IF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="393438589"
Date: Tue, 30 Sep 2014 16:05:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [LKP] [mm] f1820361f83: -53.5% proc-vmstat.pgfault
Message-ID: <20140930080557.GE9561@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Kirill,

FYI, we noticed 53.5% reduction of page faults and more mmap pages on

commit f1820361f83d556a7f0a9f629100f3825e594328 ("mm: implement ->map_pages for page cache")

testbox/testcase/testparams: lituya/will-it-scale/brk1

8c6e50b0290c4c7  f1820361f83d556a7f0a9f629  
---------------  -------------------------  
   1111649 ± 0%     -53.5%     517160 ± 0%  proc-vmstat.pgfault
        42 ±15%     -39.6%         25 ±22%  sched_debug.cpu#0.load
        21 ±23%     +45.3%         30 ±20%  sched_debug.cfs_rq[3]:/.runnable_load_avg
      1907 ± 0%     +56.4%       2983 ± 0%  proc-vmstat.nr_mapped
      7631 ± 0%     +56.4%      11938 ± 0%  meminfo.Mapped
      5002 ± 0%     +42.3%       7119 ± 0%  time.maximum_resident_set_size
     38824 ±17%     +40.3%      54478 ±19%  sched_debug.cpu#4.nr_load_updates
    572834 ±18%     +32.3%     757713 ±10%  sched_debug.cpu#4.sched_count
    563679 ±18%     +32.3%     745714 ±11%  sched_debug.cpu#4.nr_switches
    280478 ±18%     +32.3%     371078 ±11%  sched_debug.cpu#4.sched_goidle
     67648 ± 0%     +25.6%      84935 ± 0%  meminfo.Active(file)
     16911 ± 0%     +25.6%      21233 ± 0%  proc-vmstat.nr_active_file
        21 ± 9%     +27.5%         27 ±17%  sched_debug.cfs_rq[2]:/.runnable_load_avg
    331375 ±18%     +31.0%     434139 ± 9%  sched_debug.cpu#4.ttwu_count
    104185 ± 0%     +16.6%     121516 ± 0%  meminfo.Active
      2716 ± 0%     +15.5%       3138 ± 0%  proc-vmstat.pgactivate
     22227 ± 0%     -40.5%      13227 ± 0%  time.minor_page_faults
  14852144 ± 3%      +7.5%   15967380 ± 4%  time.voluntary_context_switches
    103047 ± 3%      +7.1%     110336 ± 4%  vmstat.system.cs


                               time.minor_page_faults

   3000 ++------------------------------------------------------------------+
   2800 *+*..*.*..*.*..*.*.*..*.*..*.*..*.*.*..*.*..*.*..*.*.*..*.*..*.*..*.*
        |                                                                   |
   2600 ++                                                                  |
   2400 ++                                                                  |
        |                                                                   |
   2200 ++                                                                  |
   2000 ++                                                                  |
   1800 ++                                                                  |
        |                                                                   |
   1600 ++                                                                  |
   1400 ++                                                                  |
        |                                                                   |
   1200 O+O  O O  O O  O O O  O O  O O  O O O  O O  O O  O O O  O O  O O  O |
   1000 ++------------------------------------------------------------------+

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

--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: will-it-scale
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
model: Grantley Haswell
nr_cpu: 16
memory: 16G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - brk1
branch: linus/master
commit: 19583ca584d6f574384e17fe7613dfaeadcdc4a6
repeat_to: 3
enqueue_time: 2014-09-25 21:45:43.051375027 +08:00
testbox: lituya
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/vmlinuz-3.16.0"
user: lkp
queue: wfg
result_root: "/result/lituya/will-it-scale/brk1/debian-x86_64.cgz/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/0"
job_file: "/lkp/scheduled/lituya/wfg_will-it-scale-brk1-x86_64-rhel-19583ca584d6f574384e17fe7613dfaeadcdc4a6-2.yaml"
dequeue_time: 2014-09-25 23:19:40.512443629 +08:00
history_time: 300
job_state: finished
loadavg: 14.25 6.83 2.71 1/443 6625
start_time: '1411658412'
end_time: '1411658717'
version: "/lkp/lkp/.src-20140925-212910"

--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./runtest.py brk1 32 1 8 12 16

--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--47eKBCiAZYFK5l32--
