Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaHGK4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:56:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:40932 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbaHGK4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:56:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,817,1400050800"; 
   d="scan'208";a="573045855"
Date: Thu, 7 Aug 2014 18:55:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [fs] e691fc4583e: -59.7% dbench.throughput-MB/sec
Message-ID: <20140807105538.GC17655@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Neil,

We noticed the below dbench regression on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit e691fc4583e512f936bd04efb870815fe1ed750d ("fs: allow ->d_manage() to declare -EISDIR in rcu_walk mode.")

test case: ivb44/dbench/100%

53bcc0567b8c520  e691fc4583e512f936bd04efb 
---------------  ------------------------- 
     25957 ± 0%     -59.7%      10460 ± 4%  TOTAL dbench.throughput-MB/sec
      0.00           +Inf%      24.33 ±31%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_get_not_dead.unlazy_walk.lookup_fast.link_path_walk
     15.14 ± 0%     -82.1%       2.71 ±25%  TOTAL perf-profile.cpu-cycles.copy_user_enhanced_fast_string.copy_page_to_iter.generic_file_read_iter.new_sync_read.vfs_read
      0.00           +Inf%       4.33 ±35%  TOTAL perf-profile.cpu-cycles.lockref_put_or_lock.dput.link_path_walk.path_openat.do_filp_open
      0.00           +Inf%       4.35 ±36%  TOTAL perf-profile.cpu-cycles.lockref_get_not_dead.unlazy_walk.lookup_fast.link_path_walk.path_openat
      0.00           +Inf%       5.06 ±36%  TOTAL perf-profile.cpu-cycles.lockref_put_or_lock.dput.link_path_walk.path_lookupat.filename_lookup
      1.11 ± 1%    -100.0%       0.00 ± 0%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath
      0.00           +Inf%       5.10 ±36%  TOTAL perf-profile.cpu-cycles.lockref_get_not_dead.unlazy_walk.lookup_fast.link_path_walk.path_lookupat
      0.00           +Inf%      11.19 ±30%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_put_or_lock.dput.link_path_walk.path_openat
      0.00           +Inf%      12.85 ±31%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_put_or_lock.dput.link_path_walk.path_lookupat
      2.00 ± 0%     -79.5%       0.41 ±26%  TOTAL perf-profile.cpu-cycles.find_get_entry.pagecache_get_page.generic_file_read_iter.new_sync_read.vfs_read
      2.01 ± 3%     -74.0%       0.52 ±17%  TOTAL perf-profile.cpu-cycles.rcu_nocb_kthread.kthread.ret_from_fork
      8.70 ± 1%     -77.5%       1.96 ±24%  TOTAL perf-profile.cpu-cycles.copy_user_enhanced_fast_string.iov_iter_copy_from_user_atomic.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      1.20 ± 0%     -75.9%       0.29 ±25%  TOTAL perf-profile.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_open.sys_openat
      1.11 ± 3%     -72.9%       0.30 ±22%  TOTAL perf-profile.cpu-cycles.selinux_inode_permission.security_inode_permission.__inode_permission.inode_permission.link_path_walk
      2.03 ± 1%     -69.2%       0.63 ±21%  TOTAL perf-profile.cpu-cycles.__vdso_gettimeofday
      1.52 ± 4%     -67.6%       0.49 ±13%  TOTAL perf-profile.cpu-cycles.avc_has_perm_noaudit.selinux_inode_permission.security_inode_permission.__inode_permission.inode_permission
  47938419 ± 0%     -60.6%   18877399 ± 3%  TOTAL proc-vmstat.pgalloc_dma32
  9.25e+08 ± 0%     -59.7%  3.728e+08 ± 3%  TOTAL proc-vmstat.pgalloc_normal
  22194267 ± 0%     -59.3%    9023662 ± 3%  TOTAL proc-vmstat.pgactivate
  4.53e+08 ± 0%     -58.0%  1.904e+08 ± 2%  TOTAL numa-numastat.node1.local_node
  4.53e+08 ± 0%     -58.0%  1.904e+08 ± 2%  TOTAL numa-numastat.node1.numa_hit
   2987057 ± 0%     -56.3%    1306633 ± 2%  TOTAL softirqs.RCU
    964655 ±14%     -47.3%     508785 ±23%  TOTAL cpuidle.C3-IVT.time
      0.32 ± 5%     -37.3%       0.20 ±12%  TOTAL turbostat.%c1
     69254 ± 6%     -32.7%      46602 ± 9%  TOTAL cpuidle.C6-IVT.usage
      2724 ±15%     -32.3%       1843 ± 6%  TOTAL cpuidle.C3-IVT.usage
   6665511 ±11%     -31.9%    4540015 ± 8%  TOTAL cpuidle.C1E-IVT.time
  26138868 ±11%     -27.6%   18932437 ±17%  TOTAL cpuidle.C1-IVT.time
      6013 ± 9%     -28.3%       4311 ±18%  TOTAL proc-vmstat.pgmigrate_success
      6013 ± 9%     -28.3%       4311 ±18%  TOTAL proc-vmstat.numa_pages_migrated
     48751 ± 4%     -18.3%      39837 ± 6%  TOTAL proc-vmstat.numa_hint_faults
      1849 ± 2%     -14.9%       1573 ± 3%  TOTAL numa-vmstat.node0.nr_alloc_batch
     48570 ± 4%     -16.9%      40343 ± 6%  TOTAL proc-vmstat.numa_pte_updates
     17191 ± 6%     -15.3%      14566 ±14%  TOTAL cpuidle.C1E-IVT.usage
     85893 ± 3%     +12.4%      96578 ± 4%  TOTAL meminfo.Committed_AS
     29718 ± 4%      -8.0%      27337 ± 2%  TOTAL proc-vmstat.numa_hint_faults_local
     13612 ± 3%     -10.4%      12195 ± 3%  TOTAL slabinfo.kmalloc-192.num_objs
     13611 ± 3%     -10.4%      12195 ± 3%  TOTAL slabinfo.kmalloc-192.active_objs
      9469 ± 0%     -62.3%       3574 ± 3%  TOTAL time.user_time
   1365218 ± 1%     -44.4%     759678 ± 1%  TOTAL time.involuntary_context_switches
      4818 ± 1%     -38.7%       2954 ± 1%  TOTAL vmstat.system.cs
           ± 0%     -37.0%            ± 1%  TOTAL turbostat.RAM_W
     23661 ± 0%     +28.8%      30466 ± 0%  TOTAL time.system_time
    158133 ± 8%     -16.6%     131932 ± 9%  TOTAL time.voluntary_context_switches
    196790 ± 7%     -15.8%     165728 ± 8%  TOTAL time.minor_page_faults
           ± 0%     -10.5%            ± 0%  TOTAL turbostat.Cor_W
           ± 0%      -9.8%            ± 0%  TOTAL turbostat.Pkg_W
      4599 ± 0%      +2.7%       4724 ± 0%  TOTAL time.percent_of_cpu_this_job_got
     54951 ± 0%      -1.7%      54021 ± 0%  TOTAL vmstat.system.in

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--1LKvkjL3sHcu1TtY
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
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
dbench 48 -c /usr/share/dbench/client.txt

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--1LKvkjL3sHcu1TtY--
