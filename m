Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaLWDK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:10:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:64711 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbaLWDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:10:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="432401352"
Message-ID: <1419304217.26403.44.camel@intel.com>
Subject: [LKP] [ftrace] fef5aeeee9e: -27.2% boot-slabinfo.num_objs
From: Huang Ying <ying.huang@intel.com>
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Tue, 23 Dec 2014 11:10:17 +0800
Content-Type: multipart/mixed; boundary="=-gJdUyqXFQfrzHs3XUnQj"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gJdUyqXFQfrzHs3XUnQj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit fef5aeeee9e3717e7aea991a7ae9ff6a7a2d4c85 ("ftrace: Replace tramp_hash with old_*_hash to save space")


testbox/testcase/testparams: vm-kbuild-4G/boot/1

e1effa0144a1ddf5  fef5aeeee9e3717e7aea991a7a  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    437752 ±  0%     -27.2%     318545 ±  0%  boot-slabinfo.num_objs

vm-kbuild-4G: qemu-system-x86_64 -enable-kvm
Memory: 4G



                               boot-slabinfo.num_objs

  440000 *+*--*-*-*------*----*-*-*--*--------*-*--*-*-*--*-----------------+
         |           *.*   *.          *.*..*                               |
  420000 ++                                                                 |
         |                                                                  |
  400000 ++                                                                 |
         |                                                                  |
  380000 ++                                                                 |
         |                                                                  |
  360000 ++                                                                 |
         |                                                                  |
  340000 ++                                                                 |
         |                                                                  |
  320000 O+O  O   O  O O O O  O O O  O O    O O O    O O  O O O O  O O O  O O
         |      O                        O         O                        |
  300000 ++-----------------------------------------------------------------+

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
Huang, Ying


--=-gJdUyqXFQfrzHs3XUnQj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: boot
default_monitors:
  boottime: 
  kernel-size: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor: 
model: qemu-system-x86_64 -enable-kvm
nr_vm: 8
nr_cpu: 4
memory: 4G
rootfs: debian-x86_64.cgz
hdd_partitions: "/dev/vda /dev/vdb /dev/vdc /dev/vdd"
swap_partitions: "/dev/vde"
boot-meminfo: 
boot-slabinfo: 
boot-memory: 
memmap: 
bootmem: 
sleep: 1
branch: linus/master
commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
testbox: vm-kbuild-4G-1
tbox_group: vm-kbuild-4G
kconfig: x86_64-allyesdebian
enqueue_time: 2014-12-15 07:00:22.267392531 +08:00
kernel: "/kernel/x86_64-allyesdebian/b2776bf7149bddd1f4161f14f79520f17fc1d71d/vmlinuz-3.18.0"
user: lkp
queue: rand
result_root: "/result/vm-kbuild-4G/boot/1/debian-x86_64.cgz/x86_64-allyesdebian/b2776bf7149bddd1f4161f14f79520f17fc1d71d/0"
job_file: "/lkp/scheduled/vm-kbuild-4G-1/rand_boot-1-debian-x86_64.cgz-x86_64-allyesdebian-b2776bf7149bddd1f4161f14f79520f17fc1d71d-0.yaml"
dequeue_time: 2014-12-15 07:01:52.000092900 +08:00
job_state: finished
loadavg: 2.54 1.47 0.58 2/196 5734
start_time: '1418598302'
end_time: '1418598303'
version: "/lkp/lkp/.src-20141214-133531"

--=-gJdUyqXFQfrzHs3XUnQj
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-gJdUyqXFQfrzHs3XUnQj--

