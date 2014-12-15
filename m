Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaLOBCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:02:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:46500 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaLOBCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:02:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="yaml'?scan'208";a="498672075"
Message-ID: <1418605329.5745.141.camel@linux.intel.com>
Subject: [LKP] [aio] 6098b45b32e: 2200.00% xfstests.generic.239.seconds
From: Huang Ying <ying.huang@linux.intel.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Mon, 15 Dec 2014 09:02:09 +0800
Content-Type: multipart/mixed; boundary="=-ObBlkJEUsf/sER2oucSA"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ObBlkJEUsf/sER2oucSA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 6098b45b32e6baeacc04790773ced9340601d511 ("aio: block exit_aio() until all context requests are completed")


testbox/testcase/testparams: vm-vp-2G/xfstests/4HDD-btrfs-generic-quick

2ff396be602f10b5  6098b45b32e6baeacc04790773  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     26352 ±  9%     -13.6%      22774 ±  1%  vmstat.system.cs
     10342 ±  6%     -12.3%       9066 ±  0%  vmstat.system.in
        37 ±  4%     -12.1%         32 ±  3%  time.percent_of_cpu_this_job_got
      1197 ±  2%     -14.2%       1028 ±  0%  vmstat.io.bi
     18470 ±  2%     -10.1%      16609 ±  1%  vmstat.io.bo
       157 ±  3%     +13.7%        179 ±  0%  time.elapsed_time

vm-vp-2G: qemu-system-x86_64 -enable-kvm -cpu Penryn
Memory: 2G

                          xfstests.generic.239.seconds

  30 ++-----------O---------------------------------------------------------+
     |              O         O            O         O                      |
  25 ++                O                                                    |
     |  O O  O O            O    O O  O  O    O O  O                        |
     |                   O                                                  |
  20 O+                                                                     |
     |                                                                      |
  15 ++                                                                     |
     |                                                                      |
  10 ++                                                                     |
     |                                                                      |
     |                                                                      |
   5 ++                                                                     |
     |                                                                      |
   0 *+-*-*--*-*--*-*--*-*--*-*--*-*--*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*


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


--=-ObBlkJEUsf/sER2oucSA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: xfstests
default_monitors:
  wait: pre-test
  vmstat: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor: 
model: qemu-system-x86_64 -enable-kvm -cpu Penryn
nr_vm: 4
nr_cpu: 4
memory: 2G
rootfs: debian-x86_64.cgz
hdd_partitions: "/dev/vda /dev/vdb /dev/vdc /dev/vdd /dev/vde"
swap_partitions: "/dev/vdf"
disk: 4HDD
fs:
- btrfs
xfstests:
  test:
  - generic-quick
enqueue_time: 2014-12-12 14:10:35.953340165 +08:00
branch: renesas-drivers/master
commit: bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9
testbox: vm-vp-2G-1
tbox_group: vm-vp-2G
kconfig: x86_64-lkp
user: lkp
queue: reconfirm
result_root: "/result/vm-vp-2G/xfstests/4HDD-btrfs-generic-quick/debian-x86_64.cgz/x86_64-lkp/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/0"
job_file: "/lkp/scheduled/vm-vp-2G-1/reconfirm_xfstests-4HDD-btrfs-generic-quick-debian-x86_64.cgz-x86_64-lkp-bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9-4.yaml"
repeat_to: 5
kernel: "/kernel/x86_64-lkp/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0"
dequeue_time: 2014-12-12 14:27:47.679087537 +08:00
job_state: finished
loadavg: 63.87 27.33 10.18 1/108 6683
start_time: '1418365712'
end_time: '1418366002'
version: "/lkp/lkp/.src-20141212-075301"

--=-ObBlkJEUsf/sER2oucSA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: base64

bWtmcyAtdCBidHJmcyAvZGV2L3ZkYg0KbWtmcyAtdCBidHJmcyAvZGV2L3ZkZA0KbWtmcyAtdCBi
dHJmcyAvZGV2L3ZkYQ0KbWtmcyAtdCBidHJmcyAvZGV2L3ZkYw0KbW91bnQgLXQgYnRyZnMgL2Rl
di92ZGEgL2ZzL3ZkYQ0KbW91bnQgLXQgYnRyZnMgL2Rldi92ZGIgL2ZzL3ZkYg0KbW91bnQgLXQg
YnRyZnMgL2Rldi92ZGMgL2ZzL3ZkYw0KbW91bnQgLXQgYnRyZnMgL2Rldi92ZGQgL2ZzL3ZkZA0K
ZXhwb3J0IFRFU1RfRElSPS9mcy92ZGENCmV4cG9ydCBURVNUX0RFVj0vZGV2L3ZkYQ0KZXhwb3J0
IEZTVFlQPWJ0cmZzDQpleHBvcnQgU0NSQVRDSF9NTlQ9L2ZzL3NjcmF0Y2gNCm1rZGlyIC9mcy9z
Y3JhdGNoIC1wDQpleHBvcnQgU0NSQVRDSF9ERVZfUE9PTD0iL2Rldi92ZGIgL2Rldi92ZGMgL2Rl
di92ZGQiDQouL2NoZWNrIGdlbmVyaWMvMDAxIGdlbmVyaWMvMDAyIGdlbmVyaWMvMDAzIGdlbmVy
aWMvMDA0IGdlbmVyaWMvMDA1IGdlbmVyaWMvMDA2IGdlbmVyaWMvMDA3IGdlbmVyaWMvMDA4IGdl
bmVyaWMvMDA5IGdlbmVyaWMvMDEwIGdlbmVyaWMvMDExIGdlbmVyaWMvMDEyIGdlbmVyaWMvMDE0
IGdlbmVyaWMvMDE1IGdlbmVyaWMvMDE2IGdlbmVyaWMvMDE3IGdlbmVyaWMvMDE4IGdlbmVyaWMv
MDE5IGdlbmVyaWMvMDIwIGdlbmVyaWMvMDIxIGdlbmVyaWMvMDIyIGdlbmVyaWMvMDIzIGdlbmVy
aWMvMDI0IGdlbmVyaWMvMDI1IGdlbmVyaWMvMDI2IGdlbmVyaWMvMDI4IGdlbmVyaWMvMDUzIGdl
bmVyaWMvMDYyIGdlbmVyaWMvMDY5IGdlbmVyaWMvMDc2IGdlbmVyaWMvMDc3IGdlbmVyaWMvMDc5
IGdlbmVyaWMvMDg4IGdlbmVyaWMvMDg5IGdlbmVyaWMvMDkzIGdlbmVyaWMvMDk3IGdlbmVyaWMv
MDk5IGdlbmVyaWMvMTA1IGdlbmVyaWMvMTIzIGdlbmVyaWMvMTI0IGdlbmVyaWMvMTI2IGdlbmVy
aWMvMTI4IGdlbmVyaWMvMTI5IGdlbmVyaWMvMTMxIGdlbmVyaWMvMTM1IGdlbmVyaWMvMTQxIGdl
bmVyaWMvMTY5IGdlbmVyaWMvMTg0IGdlbmVyaWMvMTkzIGdlbmVyaWMvMTk4IGdlbmVyaWMvMjA3
IGdlbmVyaWMvMjEwIGdlbmVyaWMvMjExIGdlbmVyaWMvMjEyIGdlbmVyaWMvMjEzIGdlbmVyaWMv
MjE0IGdlbmVyaWMvMjE1IGdlbmVyaWMvMjE5IGdlbmVyaWMvMjIxIGdlbmVyaWMvMjI4IGdlbmVy
aWMvMjM0IGdlbmVyaWMvMjM1IGdlbmVyaWMvMjM2IGdlbmVyaWMvMjM3IGdlbmVyaWMvMjM5IGdl
bmVyaWMvMjQwIGdlbmVyaWMvMjQ1IGdlbmVyaWMvMjQ2IGdlbmVyaWMvMjQ4IGdlbmVyaWMvMjQ5
IGdlbmVyaWMvMjUxIGdlbmVyaWMvMjU1IGdlbmVyaWMvMjU3IGdlbmVyaWMvMjU4IGdlbmVyaWMv
MjYwIGdlbmVyaWMvMjc3IGdlbmVyaWMvMjgwIGdlbmVyaWMvMjg1IGdlbmVyaWMvMjg2IGdlbmVy
aWMvMjg4IGdlbmVyaWMvMjk0IGdlbmVyaWMvMzA3IGdlbmVyaWMvMzA4IGdlbmVyaWMvMzA5IGdl
bmVyaWMvMzEyIGdlbmVyaWMvMzEzIGdlbmVyaWMvMzE0IGdlbmVyaWMvMzE1IGdlbmVyaWMvMzE2
IGdlbmVyaWMvMzE3IGdlbmVyaWMvMzE4IGdlbmVyaWMvMzIwIGdlbmVyaWMvMzIxIGdlbmVyaWMv
MzIyDQoN


--=-ObBlkJEUsf/sER2oucSA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-ObBlkJEUsf/sER2oucSA--

