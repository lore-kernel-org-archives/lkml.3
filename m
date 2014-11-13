Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbaKMNmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:42:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:22356 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaKMNl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:41:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,377,1413270000"; 
   d="scan'208";a="636370604"
Date: Thu, 13 Nov 2014 21:41:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Yuanhan Liu <yuanhan.liu@intel.com>
Subject: [x86, irq] BUG: kernel boot hang
Message-ID: <20141113134139.GA22488@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20141113123958.GA15348@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Jiang,

This is another bisect result.

https://github.com/jiangliu/linux.git irqdomain/p4v2
commit b8c2d075135a41f69254a75c4f26162559503ab4 ("x86, irq: Use cached IOAP=
IC entry instead of reading from hardware")


+----------------------+------------+------------+
|                      | 384c30d19a | b8c2d07513 |
+----------------------+------------+------------+
| boot_successes       | 20         | 5          |
| early-boot-hang      | 1          |            |
| boot_failures        | 0          | 15         |
| BUG:kernel_boot_hang | 0          | 15         |
+----------------------+------------+------------+


[  289.616037] Waiting up to 30 more seconds for network.
[  299.616037] Waiting up to 20 more seconds for network.

BUG: kernel boot hang
Elapsed time: 310
qemu-system-x86_64 -enable-kvm -kernel /kernel/x86_64-lkp/349d0daa5e14b9b40=
2a2dea3e602ef1cb109173b/vmlinuz-3.18.0-rc3-g349d0da -append 'user=3Dlkp job=
=3D/lkp/scheduled/vm-vp-quantal-x86_64-27/rand_boot-1-quantal-core-x86_64.c=
gz-x86_64-lkp-349d0daa5e14b9b402a2dea3e602ef1cb109173b-1.yaml ARCH=3Dx86_64=
 BOOT_IMAGE=3D/kernel/x86_64-lkp/349d0daa5e14b9b402a2dea3e602ef1cb109173b/v=
mlinuz-3.18.0-rc3-g349d0da kconfig=3Dx86_64-lkp commit=3D349d0daa5e14b9b402=
a2dea3e602ef1cb109173b branch=3Djiangliu/irqdomain/p4v2 root=3D/dev/ram0 ma=
x_uptime=3D3600 RESULT_ROOT=3D/result/vm-vp-quantal-x86_64/boot/1/quantal-c=
ore-x86_64.cgz/x86_64-lkp/349d0daa5e14b9b402a2dea3e602ef1cb109173b/0 ip=3D:=
:::vm-vp-quantal-x86_64-27::dhcp earlyprintk=3DttyS0,115200 debug apic=3Dde=
bug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 so=
ftlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.mi=
nor_count=3D8'  -initrd /fs/sdf1/initrd-vm-vp-quantal-x86_64-27 -m 360 -smp=
 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-=
reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid=
-vm-vp-quantal-x86_64-27 -serial file:/dev/shm/kboot/serial-vm-vp-quantal-x=
86_64-27 -daemonize -display none -monitor null=20



Thanks,
Fengguang

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--EVF5PPMfhYS0aIcm--
