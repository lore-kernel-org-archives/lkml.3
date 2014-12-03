Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLCCay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:30:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:19483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaLCCaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="424346842"
Date: Wed, 3 Dec 2014 10:31:31 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [drm/fb] f5ef139cbe5: *ERROR* not all connectors configured
Message-ID: <20141203023131.GC10048@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://people.freedesktop.org/~airlied/linux.git radeon-mst-hacks
commit f5ef139cbe5dbd755dab3706022d7147800099a8 ("drm/fb: add support for tiled monitor configurations.")


testbox/testcase/testparams: vm-kbuild-1G/xfstests/4HDD-btrfs-generic-113

9cf13203b1fd7cc3  f5ef139cbe5dbd755dab370602  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :10         100%          10:10    kmsg.drm:drm_setup_crtcs[drm_kms_helper]]*ERROR*not_all_connectors_configured

vm-kbuild-1G: qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap
Memory: 1G




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

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: xfstests
default_monitors:
  wait: pre-test
  vmstat: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor: 
model: qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap
nr_vm: 16
nr_cpu: 2
memory: 1G
disk_type: virtio-scsi
rootfs: debian-x86_64.cgz
hdd_partitions: "/dev/sda /dev/sdb /dev/sdc /dev/sdd"
swap_partitions: "/dev/sde"
disk: 4HDD
fs:
- btrfs
xfstests:
  test:
  - generic-113
enqueue_time: 2014-11-26 13:11:19.191840759 +08:00
branch: linux-devel/devel-hourly-2014112611
commit: a7a1168f6b45bb0d29a20c942e1ca300ef54dc6e
repeat_to: 2
testbox: vm-kbuild-1G-3
tbox_group: vm-kbuild-1G
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/a7a1168f6b45bb0d29a20c942e1ca300ef54dc6e/vmlinuz-3.18.0-rc6-wl-ath-ga7a1168f"
user: lkp
queue: rand
result_root: "/result/vm-kbuild-1G/xfstests/4HDD-btrfs-generic-113/debian-x86_64.cgz/x86_64-rhel/a7a1168f6b45bb0d29a20c942e1ca300ef54dc6e/0"
job_file: "/lkp/scheduled/vm-kbuild-1G-3/rand_xfstests-4HDD-btrfs-generic-113-debian-x86_64.cgz-x86_64-rhel-a7a1168f6b45bb0d29a20c942e1ca300ef54dc6e-1.yaml"
dequeue_time: 2014-11-26 13:25:10.605471464 +08:00
job_state: finished
loadavg: 96.37 33.89 12.20 1/593 3339
start_time: '1416979556'
end_time: '1416979727'
version: "/lkp/lkp/.src-20141126-053142"

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

mkfs -t btrfs /dev/sdd
mkfs -t btrfs /dev/sdc
mkfs -t btrfs /dev/sdb
mkfs -t btrfs /dev/sda
mount -t btrfs /dev/sda /fs/sda
mount -t btrfs /dev/sdb /fs/sdb
mount -t btrfs /dev/sdc /fs/sdc
mount -t btrfs /dev/sdd /fs/sdd
export TEST_DIR=/fs/sda
export TEST_DEV=/dev/sda
export FSTYP=btrfs
export SCRATCH_MNT=/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV_POOL="/dev/sdb /dev/sdc /dev/sdd"
./check generic/113

--+QahgC5+KEYLbs62--
