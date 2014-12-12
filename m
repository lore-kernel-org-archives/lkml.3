Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbaLLDDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:03:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:48850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964839AbaLLDDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:03:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="428035551"
Message-ID: <1418353365.5745.95.camel@intel.com>
Subject: [LKP] [ext4] fdfe0739876: Failed to mount
From: Huang Ying <ying.huang@intel.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Fri, 12 Dec 2014 11:02:45 +0800
Content-Type: multipart/mixed; boundary="=-2LAWNg815/BnDin+f9ME"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2LAWNg815/BnDin+f9ME
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

FYI, we noticed the below changes on

After the commit, the file system failed to mount as in stderr file attached.

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
commit fdfe073987619ec375da8d8a2701ab271d1b1339 ("ext4: fix potential use after free during resize")


testbox/testcase/testparams: nhm4/fsmark/performance-1x-32t-1HDD-ext4-16MB-60G-NoSync-16d-256fpd

2f2d74ef698b163a  fdfe073987619ec375da8d8a27  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :20          80%          16:20    stderr.mount:wrong_fs_type,bad_option,bad_superblock_on/dev/sda1
           :20          80%          16:20    stderr.missing_codepage_or_helper_program,or_other_error
           :20          80%          16:20    stderr.In_some_cases_useful_info_is_found_in_syslog-try
           :20          80%          16:20    stderr.dmesg|tail_or_so
           :20          80%          16:20    last_state.fs.exit_code.32
           :20          80%          16:20    last_state.has_stderr
           :20          15%           3:20    last_state.running
          4:20         -20%            :20    last_state.booting

nhm4: Nehalem
Memory: 4G

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


--=-2LAWNg815/BnDin+f9ME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: fsmark
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
  pmeter: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 8191d07dbb16ae88cc2bc475584b9f185f02795f
model: Nehalem
nr_cpu: 8
memory: 4G
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part1"
swap_partitions: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part2"
rootfs_partition: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part3"
iterations: 1x
nr_threads: 32t
disk: 1HDD
fs:
- ext4
fs2:
- 
fsmark:
  filesize: 16MB
  test_size: 60G
  sync_method:
  - NoSync
  nr_directories: 16d
  nr_files_per_directory: 256fpd
testbox: nhm4
tbox_group: nhm4
kconfig: x86_64-rhel
enqueue_time: 2014-12-05 21:42:14.918960219 +08:00
head_commit: 8191d07dbb16ae88cc2bc475584b9f185f02795f
base_commit: 009d0431c3914de64666bec0d350e54fdd59df6a
branch: next/master
kernel: "/kernel/x86_64-rhel/8191d07dbb16ae88cc2bc475584b9f185f02795f/vmlinuz-3.18.0-rc7-next-20141205-g8191d07"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/nhm4/fsmark/performance-1x-32t-1HDD-ext4-16MB-60G-NoSync-16d-256fpd/debian-x86_64.cgz/x86_64-rhel/8191d07dbb16ae88cc2bc475584b9f185f02795f/0"
job_file: "/lkp/scheduled/nhm4/cyclic_fsmark-performance-1x-32t-1HDD-ext4-16MB-60G-NoSync-16d-256fpd-x86_64-rhel-HEAD-8191d07dbb16ae88cc2bc475584b9f185f02795f-0.yaml"
dequeue_time: 2014-12-06 11:57:08.327465988 +08:00
job_state: failed
loadavg: 0.24 0.06 0.02 1/146 1789
start_time: ''
end_time: '1417838258'
version: "/lkp/lkp/.src-20141206-060219"

--=-2LAWNg815/BnDin+f9ME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
mkfs -t ext4 -q -F /dev/sda1
mount -t ext4 /dev/sda1 /fs/sda1

--=-2LAWNg815/BnDin+f9ME
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-2LAWNg815/BnDin+f9ME
Content-Disposition: attachment; filename="stderr"
Content-Type: text/plain; name="stderr"; charset="UTF-8"
Content-Transfer-Encoding: base64

bW91bnQ6IHdyb25nIGZzIHR5cGUsIGJhZCBvcHRpb24sIGJhZCBzdXBlcmJsb2NrIG9uIC9kZXYv
c2RhMSwKICAgICAgIG1pc3NpbmcgY29kZXBhZ2Ugb3IgaGVscGVyIHByb2dyYW0sIG9yIG90aGVy
IGVycm9yCiAgICAgICBJbiBzb21lIGNhc2VzIHVzZWZ1bCBpbmZvIGlzIGZvdW5kIGluIHN5c2xv
ZyAtIHRyeQogICAgICAgZG1lc2cgfCB0YWlsICBvciBzbwoK


--=-2LAWNg815/BnDin+f9ME--

