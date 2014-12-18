Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaLRIQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:16:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:39212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaLRIQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:16:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,599,1413270000"; 
   d="yaml'?scan'208";a="639527362"
Message-ID: <1418890547.26403.4.camel@intel.com>
Subject: [LKP] [x86, mm] 982792c782e: -12.3% boot-meminfo.SUnreclaim
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Thu, 18 Dec 2014 16:15:47 +0800
Content-Type: multipart/mixed; boundary="=-Rg7sOIlNTMRZ05lGqdPb"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rg7sOIlNTMRZ05lGqdPb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 982792c782ef337381e982fd2047391886f89693 ("x86, mm: probe memory block size for generic x86 64bit")

I think this is use memory size reduction, so should be a good thing.

testbox/testcase/testparams: brickland3/boot/1

c46a7c817e662a82  982792c782ef337381e982fd20  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    128348 ±  0%     -12.3%     112541 ±  1%  boot-meminfo.SUnreclaim
    903719 ±  0%     -13.9%     778082 ±  0%  boot-slabinfo.num_objs
    169283 ±  0%      -9.7%     152819 ±  1%  boot-meminfo.Slab
     45691 ±  0%      -8.2%      41954 ±  1%  boot-slabinfo.num_pages

brickland3: Brickland Ivy Bridge-EX
Memory: 512G




                               boot-slabinfo.num_objs

  940000 ++-----------------------------------------------------------------+
  920000 ++         *.     *                                                |
         *.**.**.*. : *   + *.* .*.**. *.*.  .* .*                          |
  900000 ++        *   *.*     *      *    **  *  *                         |
  880000 ++                                                                 |
         |                                                                  |
  860000 ++                                                                 |
  840000 ++                                                                 |
  820000 ++                                                                 |
         |                                                                  |
  800000 O+    O           O                                                |
  780000 ++OO O  O OO         OO           OO    O  O  O      OO  O O OO    O
         |            OO O       O OO O  O    OO  O       O O    O       OO |
  760000 ++                 O          O              O  O                  |
  740000 ++-----------------------------------------------------------------+


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


--=-Rg7sOIlNTMRZ05lGqdPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: boot
boot-meminfo: 
boot-slabinfo: 
boot-memory: 
memmap: 
bootmem: 
default_monitors:
  boottime: 
  kernel-size: 
sleep: 1
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/vmlinuz-3.16.0"
commit: 19583ca584d6f574384e17fe7613dfaeadcdc4a6
user: lkp
queue: wfg
testbox: brickland3
branch: linus/master
enqueue_time: 2014-09-25 21:56:15.069539322 +08:00
result_root: "/result/brickland3/boot/1/debian-x86_64.cgz/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/0"
job_file: "/lkp/scheduled/brickland3/wfg_boot-1-x86_64-rhel-19583ca584d6f574384e17fe7613dfaeadcdc4a6-0.yaml"
dequeue_time: 2014-09-25 22:00:26.067849442 +08:00
job_state: finished
loadavg: 1.09 0.29 0.10 1/979 3413
start_time: '1411653710'
end_time: '1411653711'
version: "/lkp/lkp/.src-20140925-212910"

--=-Rg7sOIlNTMRZ05lGqdPb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-Rg7sOIlNTMRZ05lGqdPb--

