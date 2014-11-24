Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKXMiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:38:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:40795 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbaKXMiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,448,1413270000"; 
   d="yaml'?scan'208";a="627355521"
Date: Mon, 24 Nov 2014 20:38:59 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Willem de Bruijn <willemb@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [net] 4ed2d765dfa:
Message-ID: <20141124123859.GD7310@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

commit 4ed2d765dfaccff5ebdac68e2064b59125033a3b ("net-timestamp: TCP timestamping")


testbox/testcase/testparams: vm-vp-2G/ltp/syscalls

e7fd2885385157d4  4ed2d765dfaccff5ebdac68e20  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :5          100%           5:5     ltp.recv01.fail
           :5          100%           5:5     ltp.recvfrom01.fail
           :5          100%           5:5     ltp.recvmsg01.fail
           :5           20%           1:5     kmsg.APIC_calibration_not_consistent_with_PM-Timer:#ms_instead_of#ms
           :5           20%           1:5     kmsg.hrtimer:interrupt_took#ns
           :5           20%           1:5     kmsg.TINFO:mlock_failed:errno=ENOMEM(#):Cannot_allocate_memory
           :5           20%           1:5     kmsg.estcases/kernel/syscalls/getgroups/../utils/compat_16.h::#-bit_version_of_getgroups()is_not_supported_on_your_platform

testbox/testcase/testparams: nhm-white/ltp/syscalls

e7fd2885385157d4  4ed2d765dfaccff5ebdac68e20  
----------------  --------------------------  
           :10         100%           5:5     ltp.recv01.fail
           :10         100%           5:5     ltp.recvfrom01.fail
           :10         100%           5:5     ltp.recvmsg01.fail

vm-vp-2G: qemu-system-x86_64 -enable-kvm -cpu Penryn
Memory: 2G

nhm-white: Nehalem
Memory: 6G




To reproduce:

  apt-get install ruby ruby-oj
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
  cd lkp-tests
  bin/setup-local job.yaml # the job file attached in this email
  bin/run-local   job.yaml


	--yliu

--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: ltp
default_monitors:
  wait: pre-test
  vmstat: 
model: qemu-system-x86_64 -enable-kvm -cpu Penryn
nr_vm: 4
nr_cpu: 4
memory: 2G
rootfs: debian-x86_64.cgz
hdd_partitions: "/dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf"
swap_partitions: "/dev/vda"
ltp:
  test:
  - syscalls
enqueue_time: 2014-10-02 10:07:25.199207485 +08:00
branch: net/master
commit: 0754476419f127eb8c294b17b6fc8b6787ded1e2
testbox: vm-vp-2G-3
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/0754476419f127eb8c294b17b6fc8b6787ded1e2/vmlinuz-3.17.0-rc6-00145-g0754476"
user: lkp
queue: rand
result_root: "/result/vm-vp-2G/ltp/syscalls/debian-x86_64.cgz/x86_64-rhel/0754476419f127eb8c294b17b6fc8b6787ded1e2/0"
job_file: "/lkp/scheduled/vm-vp-2G-3/rand_ltp-syscalls-debian-x86_64.cgz-x86_64-rhel-0754476419f127eb8c294b17b6fc8b6787ded1e2-0.yaml"
dequeue_time: 2014-10-02 11:55:51.761588446 +08:00
job_state: finished
loadavg: 4.39 5.61 2.69 1/85 10461
start_time: '1412222188'
end_time: '1412222759'
version: "/lkp/lkp/.src-20141001-203321"

--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./runltp -f syscalls

--qGV0fN9tzfkG3CxV--
