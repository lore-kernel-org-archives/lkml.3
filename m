Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaHBCu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 22:50:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:15284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaHBCuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 22:50:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,784,1400050800"; 
   d="log'?scan'208";a="570703051"
Date: Sat, 2 Aug 2014 10:50:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hong Zhiguo <zhiguohong@tencent.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [blkg_stat] WARNING: CPU: 0 PID: 85 at kernel/softirq.c:156
 _local_bh_enable_ip()
Message-ID: <20140802025046.GA6683@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 2c575026fae6e63771bd2a4c1d407214a8096a89
Author:     Hong Zhiguo <zhiguohong@tencent.com>
AuthorDate: Wed Nov 20 10:35:05 2013 -0700
Commit:     Jens Axboe <axboe@kernel.dk>
CommitDate: Wed Nov 20 15:33:04 2013 -0700

    Update of blkg_stat and blkg_rwstat may happen in bh context.
    While u64_stats_fetch_retry is only preempt_disable on 32bit
    UP system. This is not enough to avoid preemption by bh and
    may read strange 64 bit value.
    
    Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

+-----------------------------------------------------------------------------+------------+------------+------------------+
|                                                                             | 82023bb7f7 | 2c575026fa | v3.16-rc7_080120 |
+-----------------------------------------------------------------------------+------------+------------+------------------+
| boot_successes                                                              | 270        | 22         | 7                |
| boot_failures                                                               | 0          | 68         | 4                |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 0          | 1          |                  |
| Oops                                                                        | 0          | 1          |                  |
| EIP_is_at_strlen                                                            | 0          | 1          |                  |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 1          |                  |
| INFO:lockdep_is_turned_off                                                  | 0          | 1          |                  |
| backtrace:vfs_write                                                         | 0          | 1          |                  |
| backtrace:SyS_write                                                         | 0          | 1          |                  |
| WARNING:CPU:PID:at_kernel/softirq.c:_local_bh_enable_ip()                   | 0          | 67         |                  |
| inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-W_usage                                | 0          | 67         | 4                |
| backtrace:redo_fd_request                                                   | 0          | 67         |                  |
| backtrace:floppy_work_workfn                                                | 0          | 0          | 4                |
| backtrace:cpu_startup_entry                                                 | 0          | 0          | 4                |
+-----------------------------------------------------------------------------+------------+------------+------------------+

[    2.848648] NX-protecting the kernel data: 5832k
[    2.903073] udev[122]: starting version 164
[    3.123339] ------------[ cut here ]------------
[    3.123386] WARNING: CPU: 0 PID: 85 at kernel/softirq.c:156 _local_bh_enable_ip+0x34/0x97()
[    3.123386] Modules linked in:
[    3.123386] CPU: 0 PID: 85 Comm: kworker/u2:2 Not tainted 3.12.0-10878-g2c57502 #1
[    3.123386] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.123386] Workqueue: floppy redo_fd_request
[    3.123386]  c0258bca 00000000 d277bce8 c0646df5 d277bd00 c022d793 c0230f4d c04297b7
[    3.123386]  d2746634 d277bd6c d277bd10 c022d81d 00000009 00000000 d277bd1c c0230f4d
[    3.123386]  d277bd4c d277bd24 c0230fc0 d277bd38 c04297b7 c001be10 d2746400 d2743c00
[    3.123386] Call Trace:
[    3.123386]  [<c0258bca>] ? console_unlock+0x355/0x382
[    3.123386]  [<c0646df5>] dump_stack+0x16/0x18
[    3.123386]  [<c022d793>] warn_slowpath_common+0x5f/0x76
[    3.123386]  [<c0230f4d>] ? _local_bh_enable_ip+0x34/0x97
[    3.123386]  [<c04297b7>] ? blkg_rwstat_read+0x1d/0x24
[    3.123386]  [<c022d81d>] warn_slowpath_null+0x14/0x18
[    3.123386]  [<c0230f4d>] _local_bh_enable_ip+0x34/0x97
[    3.123386]  [<c0230fc0>] local_bh_enable+0x10/0x12
[    3.123386]  [<c04297b7>] blkg_rwstat_read+0x1d/0x24
[    3.123386]  [<c042ab0a>] __cfq_set_active_queue+0x65/0x165
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c0252132>] ? __lock_is_held+0x2d/0x43
[    3.123386]  [<c021d2e1>] ? pvclock_clocksource_read+0xb1/0xda
[    3.123386]  [<c021c888>] ? kvm_clock_read+0x14/0x1d
[    3.123386]  [<c0206476>] ? paravirt_sched_clock+0x9/0xd
[    3.123386]  [<c042d08d>] cfq_dispatch_requests+0x521/0x78a
[    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
[    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c02548e7>] ? lock_acquire+0xa3/0xfc
[    3.123386]  [<c04f73a5>] ? redo_fd_request+0x3f/0xc0c
[    3.123386]  [<c041a1a4>] blk_peek_request+0x59/0x211
[    3.123386]  [<c041a36a>] blk_fetch_request+0xe/0x1e
[    3.123386]  [<c04f73e0>] redo_fd_request+0x7a/0xc0c
[    3.123386]  [<c02407ab>] ? process_one_work+0x13c/0x398
[    3.123386]  [<c0240843>] process_one_work+0x1d4/0x398
[    3.123386]  [<c0241092>] worker_thread+0x12b/0x1c8
[    3.123386]  [<c0240f67>] ? rescuer_thread+0x1ff/0x1ff
[    3.123386]  [<c0244b79>] kthread+0x8b/0x90
[    3.123386]  [<c064ccb7>] ret_from_kernel_thread+0x1b/0x28
[    3.123386]  [<c0244aee>] ? insert_kthread_work+0x5a/0x5a
[    3.123386] ---[ end trace 470268993472ede8 ]---
[    3.246919] end_request: I/O error, dev fd0, sector 0

git bisect start v3.13 v3.12 --
git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 22:45     62+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect  bad dd0508093b79141e0044ca02f0acb6319f69f546  # 22:59      0-     62  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3f02ff5c2c69753666787ed125708d283a823ffb  # 23:11      5-     26  Merge tag 'tty-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 1ab231b274ba51a54acebec23c6aded0f3cdf54e  # 23:19     62+      5  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 23:32      7-      5  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 53c6de50262a8edd6932bb59a32db7b9d92f8d67  # 23:39     90+      0  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 59fb2f0e9e30ad99a8bab0ff1efaf8f4a3b7105f  # 00:12     90+      0  Merge tag 'fbdev-fixes-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 01:00     90+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 01:08     90+      0  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 01:38     31-     32  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 01:43     28-     19  block: submit_bio_wait() conversions
git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 02:04      6-     16  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
# first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 02:29    270+      0  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad f1f29248d675d4762e7b7f498be50d2fb9c294f3  # 02:30      0-      4  0day head guard for 'devel-hourly-2014080120'
git bisect  bad 6f0928036bcbd8dd2ebee9201580da8bcc0a81af  # 03:31     20-     20  Merge tag 'pm+acpi-3.16-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 4198cf324ddea447daac3f83d3c2319ced774201  # 03:38     16-     17  Add linux-next specific files for 20140801


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-6:20140802020409:i386-randconfig-c1-08012124:3.12.0-10878-g2c57502:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-10878-g2c57502 (kbuild@cairo) (gcc vers=
ion 4.8.2 (Debian 4.8.2-18) ) #1 Sat Aug 2 02:07:34 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x015fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01003000, 0x01003fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd9a0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe4b0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe4f0 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff800 000735 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff6e0 000078 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff6a0 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x01004000, 0x01004fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 8fd700
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-08012124/linux-d=
evel:devel-hourly-2014080120:2c575026fae6e63771bd2a4c1d407214a8096a89:bisec=
t-linux-8/.vmlinuz-2c575026fae6e63771bd2a4c1d407214a8096a89-20140802020745-=
63-kbuild branch=3Dlinux-devel/devel-hourly-2014080120 BOOT_IMAGE=3D/kernel=
/i386-randconfig-c1-08012124/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlin=
uz-3.12.0-10878-g2c57502 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 305000K/327280K available (4406K kernel code, 661K r=
wdata, 2656K rodata, 536K init, 6032K bss, 22280K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc098d000 - 0xc0a13000   ( 536 kB)
[    0.000000]       .data : 0xc064dc7e - 0xc098c780   (3322 kB)
[    0.000000]       .text : 0xc0200000 - 0xc064dc7e   (4407 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-10878-g2c57502 (kbuild@cairo) (gcc vers=
ion 4.8.2 (Debian 4.8.2-18) ) #1 Sat Aug 2 02:07:34 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x015fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01003000, 0x01003fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd9a0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe4b0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe4f0 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff800 000735 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff6e0 000078 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff6a0 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x01004000, 0x01004fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 8fd700
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-08012124/linux-d=
evel:devel-hourly-2014080120:2c575026fae6e63771bd2a4c1d407214a8096a89:bisec=
t-linux-8/.vmlinuz-2c575026fae6e63771bd2a4c1d407214a8096a89-20140802020745-=
63-kbuild branch=3Dlinux-devel/devel-hourly-2014080120 BOOT_IMAGE=3D/kernel=
/i386-randconfig-c1-08012124/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlin=
uz-3.12.0-10878-g2c57502 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 305000K/327280K available (4406K kernel code, 661K r=
wdata, 2656K rodata, 536K init, 6032K bss, 22280K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc098d000 - 0xc0a13000   ( 536 kB)
[    0.000000]       .data : 0xc064dc7e - 0xc098c780   (3322 kB)
[    0.000000]       .text : 0xc0200000 - 0xc064dc7e   (4407 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5388.10 Bogo=
MIPS (lpj=3D8977773)
[    0.008041] pid_max: default: 32768 minimum: 301
[    0.010066] Security Framework initialized
[    0.011275] Mount-cache hash table entries: 512
[    0.013633] Initializing cgroup subsys blkio
[    0.014873] Initializing cgroup subsys perf_event
[    0.016099] Initializing cgroup subsys hugetlb
[    0.016830] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016830] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016830] tlb_flushall_shift: 6
[    0.020008] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, ste=
pping: 01)
[    0.025146] ACPI: Core revision 20130927
[    0.029455] ACPI: All ACPI Tables successfully acquired
[    0.030451] ACPI: setting ELCR to 0200 (from 0c00)
[    0.031837] ftrace: allocating 22267 entries in 44 pages
[    0.043891] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.051522] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.053875] EVM: security.capability
[    0.057106] xor: automatically using best checksumming function:
[    0.090039]    avx       :    82.800 MB/sec
[    0.091331] prandom: seed boundary self test passed
[    0.093554] prandom: 100 self tests passed
[    0.094869] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.096666] regulator-dummy: no parameters
[    0.096965] NET: Registered protocol family 16
[    0.098847] cpuidle: using governor ladder
[    0.100012] cpuidle: using governor menu
[    0.103588] ACPI: bus type PCI registered
[    0.104890] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.106679] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.108101] PCI: Using configuration type 1 for base access
[    0.113427] bio: create slab <bio-0> at 0
[    0.170023] raid6: mmxx1     2810 MB/s
[    0.226696] raid6: mmxx2     3413 MB/s
[    0.283366] raid6: sse1x1    2225 MB/s
[    0.340018] raid6: sse1x2    2888 MB/s
[    0.396678] raid6: sse2x1    4477 MB/s
[    0.453346] raid6: sse2x2    5851 MB/s
[    0.454683] raid6: using algorithm sse2x2 (5851 MB/s)
[    0.456284] raid6: using ssse3x1 recovery algorithm
[    0.456767] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.458524] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.460157] ACPI: Added _OSI(Module Device)
[    0.461580] ACPI: Added _OSI(Processor Device)
[    0.463343] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.464859] ACPI: Added _OSI(Processor Aggregator Device)
[    0.476242] ACPI: Interpreter enabled
[    0.476692] ACPI: (supports S0 S5)
[    0.477925] ACPI: Using PIC for interrupt routing
[    0.480066] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.497682] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.498981] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.500090] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.501941] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.503550] PCI host bridge to bus 0000:00
[    0.504672] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.506678] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.508174] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.510013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.511616] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.513447] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.515386] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.517427] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.521711] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.524645] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.526496] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.526691] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.530534] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.534323] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.538257] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.547443] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.550557] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.553158] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.554364] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.562151] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.563813] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.565784] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.571549] pci_bus 0000:00: on NUMA node 0
[    0.574468] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.576546] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.577866] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.580724] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.582623] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.584626] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.586109] ACPI: \_SB_.PCI0: notify handler is installed
[    0.586765] Found 1 acpi root devices
[    0.588591] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.590010] vgaarb: loaded
[    0.590717] vgaarb: bridge control possible 0000:00:02.0
[    0.593624] SCSI subsystem initialized
[    0.594567] libata version 3.00 loaded.
[    0.595856] PCI: Using ACPI for IRQ routing
[    0.596680] PCI: pci_cache_line_size set to 64 bytes
[    0.597913] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.599396] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.601028] Switched to clocksource kvm-clock
[    0.654319] pnp: PnP ACPI init
[    0.655251] ACPI: bus type PNP registered
[    0.656411] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.657948] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.659562] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.661258] pnp 00:03: [dma 2]
[    0.662186] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.663832] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.665497] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.667263] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.669532] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.671535] pnp: PnP ACPI: found 8 devices
[    0.672637] ACPI: bus type PNP unregistered
[    0.711642] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.712940] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.714151] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.715525] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.717042] NET: Registered protocol family 1
[    0.718191] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.719610] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.720996] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.722471] pci 0000:00:02.0: Boot video device
[    0.723742] PCI: CLS 0 bytes, default 64
[    0.725400] Unpacking initramfs...
[    0.852720] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    0.855045] cryptomgr_test (17) used greatest stack depth: 7132 bytes le=
ft
[    0.857618] kworker/u2:0 (26) used greatest stack depth: 7084 bytes left
[    0.860012] cryptomgr_test (23) used greatest stack depth: 6324 bytes le=
ft
[    0.863608] alg: No test for crc32 (crc32-pclmul)
[    0.865194] Initialise module verification
[    0.866528] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.872785] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    0.874041] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.875184] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.876263] QNX4 filesystem 0.2.3 registered.
[    0.877401] QNX6 filesystem 1.0.0 registered.
[    0.878370] SGI XFS with security attributes, no debug enabled
[    0.885081] NILFS version 2 loaded
[    0.891491] alg: No test for crc32 (crc32-table)
[    0.893010] alg: No test for lz4 (lz4-generic)
[    0.894583] alg: No test for lz4hc (lz4hc-generic)
[    0.899514] alg: No test for stdrng (krng)
[    0.900801] Key type asymmetric registered
[    0.901939] Asymmetric key parser 'x509' registered
[    0.903231] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.905253] io scheduler noop registered
[    0.906433] io scheduler cfq registered (default)
[    0.909596] list_sort_test: start testing list_sort()
[    0.911584] rbtree testing
[    1.132034] hrtimer: interrupt took 17713082 ns
[    1.843000]  -> 25071 cycles
[    1.895395] augmented rbtree testing -> 19967 cycles
[    2.686069] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    2.688331] hgafb: HGA card not detected.
[    2.689503] hgafb: probe of hgafb.0 failed with error -22
[    2.691278] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.697210] ACPI: Power Button [PWRF]
[    2.699189] HDLC line discipline maxframe=3D4096
[    2.700509] N_HDLC line discipline registered.
[    2.701928] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.730417] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.733553] serial: Freescale lpuart driver
[    2.735045] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.736920] platform pc8736x_gpio.0: no device found
[    2.738535] nsc_gpio initializing
[    2.739629] SyncLink PC Card driver $Revision: 4.34 $, tty major#252
[    2.744937] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.747555] Hangcheck: Using getrawmonotonic().
[    2.749414] Floppy drive(s): fd0 is 1.44M
[    2.751626] Uniform Multi-Platform E-IDE driver
[    2.752907] ide-cd driver 5.00
[    2.754295] osst :I: Tape driver with OnStream support version 0.99.4
[    2.754295] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.757602] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.760786] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.762017] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.764908] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.767654] Driver for 1-wire Dallas network protocol.
[    2.768958] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.771000] FDC 0 is a S82078B
[    2.774571] md: raid1 personality registered for level 1
[    2.775858] md: raid10 personality registered for level 10
[    2.777330] md: raid6 personality registered for level 6
[    2.778766] md: raid5 personality registered for level 5
[    2.780368] md: raid4 personality registered for level 4
[    2.781882] md: faulty personality registered for level -5
[    2.783845] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    2.785951] device-mapper: raid: Loading target version 1.5.2
[    2.787330] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    2.817893] input: Speakup as /devices/virtual/input/input3
[    2.819309] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    2.820815] speakup 3.1.6: initialized
[    2.821714] synth name on entry is: (null)
[    2.822773] ashmem: initialized
[    2.823798] logger: created 256K log 'log_main'
[    2.824936] logger: created 256K log 'log_events'
[    2.826094] logger: created 256K log 'log_radio'
[    2.827369] logger: created 256K log 'log_system'
[    2.829082] Loading module verification certificates
[    2.833238] X.509: Cert f317836dd61e56c80bd5556d628d78cd442f5179 is not =
yet valid
[    2.834986] MODSIGN: Problem loading in-kernel X.509 certificate (-129)
[    2.837156] Key type encrypted registered
[    2.838562] IMA: No TPM chip found, activating TPM-bypass!
[    2.840625] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    2.843711] Freeing unused kernel memory: 536K (c098d000 - c0a13000)
[    2.845193] Write protecting the kernel text: 4408k
[    2.846508] Write protecting the kernel read-only data: 2660k
[    2.848648] NX-protecting the kernel data: 5832k
[    2.903073] udev[122]: starting version 164
[    3.123339] ------------[ cut here ]------------
[    3.123386] WARNING: CPU: 0 PID: 85 at kernel/softirq.c:156 _local_bh_en=
able_ip+0x34/0x97()
[    3.123386] Modules linked in:
[    3.123386] CPU: 0 PID: 85 Comm: kworker/u2:2 Not tainted 3.12.0-10878-g=
2c57502 #1
[    3.123386] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.123386] Workqueue: floppy redo_fd_request
[    3.123386]  c0258bca 00000000 d277bce8 c0646df5 d277bd00 c022d793 c0230=
f4d c04297b7
[    3.123386]  d2746634 d277bd6c d277bd10 c022d81d 00000009 00000000 d277b=
d1c c0230f4d
[    3.123386]  d277bd4c d277bd24 c0230fc0 d277bd38 c04297b7 c001be10 d2746=
400 d2743c00
[    3.123386] Call Trace:
[    3.123386]  [<c0258bca>] ? console_unlock+0x355/0x382
[    3.123386]  [<c0646df5>] dump_stack+0x16/0x18
[    3.123386]  [<c022d793>] warn_slowpath_common+0x5f/0x76
[    3.123386]  [<c0230f4d>] ? _local_bh_enable_ip+0x34/0x97
[    3.123386]  [<c04297b7>] ? blkg_rwstat_read+0x1d/0x24
[    3.123386]  [<c022d81d>] warn_slowpath_null+0x14/0x18
[    3.123386]  [<c0230f4d>] _local_bh_enable_ip+0x34/0x97
[    3.123386]  [<c0230fc0>] local_bh_enable+0x10/0x12
[    3.123386]  [<c04297b7>] blkg_rwstat_read+0x1d/0x24
[    3.123386]  [<c042ab0a>] __cfq_set_active_queue+0x65/0x165
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c0252132>] ? __lock_is_held+0x2d/0x43
[    3.123386]  [<c021d2e1>] ? pvclock_clocksource_read+0xb1/0xda
[    3.123386]  [<c021c888>] ? kvm_clock_read+0x14/0x1d
[    3.123386]  [<c0206476>] ? paravirt_sched_clock+0x9/0xd
[    3.123386]  [<c042d08d>] cfq_dispatch_requests+0x521/0x78a
[    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
[    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
[    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
[    3.123386]  [<c02548e7>] ? lock_acquire+0xa3/0xfc
[    3.123386]  [<c04f73a5>] ? redo_fd_request+0x3f/0xc0c
[    3.123386]  [<c041a1a4>] blk_peek_request+0x59/0x211
[    3.123386]  [<c041a36a>] blk_fetch_request+0xe/0x1e
[    3.123386]  [<c04f73e0>] redo_fd_request+0x7a/0xc0c
[    3.123386]  [<c02407ab>] ? process_one_work+0x13c/0x398
[    3.123386]  [<c0240843>] process_one_work+0x1d4/0x398
[    3.123386]  [<c0241092>] worker_thread+0x12b/0x1c8
[    3.123386]  [<c0240f67>] ? rescuer_thread+0x1ff/0x1ff
[    3.123386]  [<c0244b79>] kthread+0x8b/0x90
[    3.123386]  [<c064ccb7>] ret_from_kernel_thread+0x1b/0x28
[    3.123386]  [<c0244aee>] ? insert_kthread_work+0x5a/0x5a
[    3.123386] ---[ end trace 470268993472ede8 ]---
[    3.246919] end_request: I/O error, dev fd0, sector 0
[    3.253509]=20
[    3.254083] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    3.255061] [ INFO: inconsistent lock state ]
[    3.256032] 3.12.0-10878-g2c57502 #1 Tainted: G        W  =20
[    3.256742] ---------------------------------
[    3.256742] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[    3.256742] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
[    3.256742]  (floppy_lock){+.?...}, at: [<c042b55e>] cfq_idle_slice_time=
r+0x1a/0x77
[    3.256742] {SOFTIRQ-ON-W} state was registered at:
[    3.256742]   [<c025369b>] mark_held_locks+0x5b/0x72
[    3.256742]   [<c02537fd>] trace_hardirqs_on_caller+0x14b/0x165
[    3.256742]   [<c0253822>] trace_hardirqs_on+0xb/0xd
[    3.256742]   [<c0230fa8>] _local_bh_enable_ip+0x8f/0x97
[    3.256742]   [<c0230fc0>] local_bh_enable+0x10/0x12
[    3.256742]   [<c04297b7>] blkg_rwstat_read+0x1d/0x24
[    3.256742]   [<c042ab0a>] __cfq_set_active_queue+0x65/0x165
[    3.256742]   [<c042d08d>] cfq_dispatch_requests+0x521/0x78a
[    3.256742]   [<c041a1a4>] blk_peek_request+0x59/0x211
[    3.256742]   [<c041a36a>] blk_fetch_request+0xe/0x1e
[    3.256742]   [<c04f73e0>] redo_fd_request+0x7a/0xc0c
[    3.256742]   [<c0240843>] process_one_work+0x1d4/0x398
[    3.256742]   [<c0241092>] worker_thread+0x12b/0x1c8
[    3.256742]   [<c0244b79>] kthread+0x8b/0x90
[    3.256742]   [<c064ccb7>] ret_from_kernel_thread+0x1b/0x28
[    3.256742] irq event stamp: 21291
[    3.256742] hardirqs last  enabled at (21290): [<c064c02f>] _raw_spin_un=
lock_irq+0x27/0x35
[    3.256742] hardirqs last disabled at (21291): [<c064beaa>] _raw_spin_lo=
ck_irqsave+0x18/0x43
[    3.256742] softirqs last  enabled at (21286): [<c02308e5>] _local_bh_en=
able+0x3d/0x3f
[    3.256742] softirqs last disabled at (21287): [<c0202d80>] do_softirq_o=
wn_stack+0x34/0x3a
[    3.256742]=20
[    3.256742] other info that might help us debug this:
[    3.256742]  Possible unsafe locking scenario:
[    3.256742]=20
[    3.256742]        CPU0
[    3.256742]        ----
[    3.256742]   lock(floppy_lock);
[    3.256742]   <Interrupt>
[    3.256742]     lock(floppy_lock);
[    3.256742]=20
[    3.256742]  *** DEADLOCK ***
[    3.256742]=20
[    3.256742] 1 lock held by swapper/0:
[    3.256742]  #0:  ((&cfqd->idle_slice_timer)){+.-...}, at: [<c0235fb1>] =
call_timer_fn+0x0/0x1b3
[    3.256742]=20
[    3.256742] stack backtrace:
[    3.256742] CPU: 0 PID: 0 Comm: swapper Tainted: G        W    3.12.0-10=
878-g2c57502 #1
[    3.256742] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.256742]  00000000 c08f1534 d340be54 c0646df5 d340be80 c0644913 c0816=
0f3 c0815ff2
[    3.256742]  c0815fba c0815fd9 c0815fe3 c0816e22 00000004 c08f1898 00000=
002 d340bea8
[    3.256742]  c0253562 00000004 00000000 c0253021 c08f1534 00000006 00000=
043 c08f1898
[    3.256742] Call Trace:
[    3.256742]  [<c0646df5>] dump_stack+0x16/0x18
[    3.256742]  [<c0644913>] print_usage_bug+0x180/0x18d
[    3.256742]  [<c0253562>] mark_lock+0xf5/0x1d3
[    3.256742]  [<c0253021>] ? check_usage_backwards+0x89/0x89
[    3.256742]  [<c0253c96>] __lock_acquire+0x25d/0xbdf
[    3.256742]  [<c0252f98>] ? print_shortest_lock_dependencies+0x133/0x133
[    3.256742]  [<c0251ba9>] ? trace_hardirqs_off_caller+0x2d/0x95
[    3.256742]  [<c02548d1>] lock_acquire+0x8d/0xfc
[    3.256742]  [<c042b55e>] ? cfq_idle_slice_timer+0x1a/0x77
[    3.256742]  [<c042b544>] ? cfq_preempt_queue+0x8d/0x8d
[    3.256742]  [<c064bec5>] _raw_spin_lock_irqsave+0x33/0x43
[    3.256742]  [<c042b55e>] ? cfq_idle_slice_timer+0x1a/0x77
[    3.256742]  [<c042b55e>] cfq_idle_slice_timer+0x1a/0x77
[    3.256742]  [<c042b544>] ? cfq_preempt_queue+0x8d/0x8d
[    3.256742]  [<c0236048>] call_timer_fn+0x97/0x1b3
[    3.256742]  [<c042b544>] ? cfq_preempt_queue+0x8d/0x8d
[    3.256742]  [<c042b544>] ? cfq_preempt_queue+0x8d/0x8d
[    3.256742]  [<c02365da>] run_timer_softirq+0x172/0x194
[    3.256742]  [<c0230bf9>] ? local_bh_disable+0x17/0x17
[    3.256742]  [<c0230cd2>] __do_softirq+0xd9/0x271
[    3.256742]  [<c0230bf9>] ? local_bh_disable+0x17/0x17
[    3.256742]  <IRQ>  [<c023106a>] ? irq_exit+0x4a/0x58
[    3.256742]  [<c0202b23>] ? do_IRQ+0x64/0x77
[    3.256742]  [<c064d1f1>] ? common_interrupt+0x31/0x38
[    3.256742]  [<c021ca07>] ? native_safe_halt+0x5/0x7
[    3.256742]  [<c02078e4>] ? default_idle+0x1b/0x3d
[    3.256742]  [<c0207d8d>] ? arch_cpu_idle+0x17/0x25
[    3.256742]  [<c025a04e>] ? cpu_startup_entry+0x8f/0xf6
[    3.256742]  [<c06413bd>] ? rest_init+0x10e/0x113
[    3.256742]  [<c098d98e>] ? start_kernel+0x368/0x36d
[    3.256742]  [<c098d2a3>] ? i386_start_kernel+0x79/0x7d
[    3.345302] end_request: I/O error, dev fd0, sector 0
[    3.364186] end_request: I/O error, dev fd0, sector 0
[    3.384979] end_request: I/O error, dev fd0, sector 0
[    3.403454] end_request: I/O error, dev fd0, sector 0
[    3.423477] end_request: I/O error, dev fd0, sector 0
[    3.443494] end_request: I/O error, dev fd0, sector 0
[    3.463924] end_request: I/O error, dev fd0, sector 0
[    3.483515] end_request: I/O error, dev fd0, sector 0
[    3.503488] end_request: I/O error, dev fd0, sector 0
Kernel tests: Boot OK!
[    3.809161] random: trinity urandom read with 31 bits of entropy availab=
le
[    6.557211] udevd (125) used greatest stack depth: 6264 bytes left
[   14.159228] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   15.454524] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[   15.503338] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[   15.642151] warning: process `trinity-c0' used the obsolete bdflush syst=
em call
[   15.644747] Fix your initscripts?
[   15.646079] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[   24.486950] random: nonblocking pool is initialized
[   70.940010] Unregister pv shared memory for cpu 0
[   70.941313] reboot: Restarting system
[   70.941941] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i38=
6-randconfig-c1-08012124/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlinuz-3=
=2E12.0-10878-g2c57502 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115=
200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-08012124/linux-deve=
l:devel-hourly-2014080120:2c575026fae6e63771bd2a4c1d407214a8096a89:bisect-l=
inux-8/.vmlinuz-2c575026fae6e63771bd2a4c1d407214a8096a89-20140802020745-63-=
kbuild branch=3Dlinux-devel/devel-hourly-2014080120 BOOT_IMAGE=3D/kernel/i3=
86-randconfig-c1-08012124/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlinuz-=
3.12.0-10878-g2c57502 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/y=
octo-minimal-i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net us=
er,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloca=
ltime -pidfile /dev/shm/kboot/pid-yocto-kbuild-6 -serial file:/dev/shm/kboo=
t/serial-yocto-kbuild-6 -daemonize -display none -monitor null=20

--k+w/mQv8wyuph6w0
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c1-08012124-f1f29248d675d4762e7b7f498be50d2fb9c294f3-inconsistent----usage--85685.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZjFmMjkyNC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA4MDEyMCcKZ2l0IGNoZWNrb3V0IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5
OGE3ZDBlY2NmYmQ2YzFhOTEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA4MDEyMDo2NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxOmJpc2Vj
dC1saW51eC04CgoyMDE0LTA4LTAxLTIxOjQ1OjA0IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5
OGE3ZDBlY2NmYmQ2YzFhOTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNi
MmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtNjRh
YTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MQprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3
ZDBlY2NmYmQ2YzFhOTEvdm1saW51ei0zLjE2LjAtcmM3CgoyMDE0LTA4LTAxLTIxOjQ3OjA0
IGRldGVjdGluZyBib290IHN0YXRlIC4JMQkzCTE1IFRFU1QgRkFJTFVSRQpbICAgIDMuMTIw
ODA3XSByYW5kb206IGluaXQgdXJhbmRvbSByZWFkIHdpdGggMTQgYml0cyBvZiBlbnRyb3B5
IGF2YWlsYWJsZQpbICAgIDMuMjMyMDg3XSBtb3VudGFsbCAoMTA1KSB1c2VkIGdyZWF0ZXN0
IHN0YWNrIGRlcHRoOiA2MjQ0IGJ5dGVzIGxlZnQKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpF
bGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNjRhYTkw
ZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS92bWxpbnV6LTMuMTYuMC1yYzcg
LWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRl
YnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9z
dGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNo
ZG9nPXBhbmljIGxvYWRfcmFtZGlzaz0yIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlT
MCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxp
bms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEyMDo2NGFhOTBmMjZjMDZl
MWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxOmJpc2VjdC1saW51eC04Ly52bWxpbnV6LTY0
YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEtMjAxNDA4MDIwNTQ3MjMt
MTQtdnAgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDgwMTIwIEJPT1Rf
SU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNjRhYTkwZjI2YzA2
ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS92bWxpbnV6LTMuMTYuMC1yYzcgZHJiZC5t
aW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNv
cmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAg
LW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBp
NjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0v
ZGlzazAtcXVhbnRhbC12cC0zLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9m
cy9MQUJFTD1LVk0vZGlzazEtcXVhbnRhbC12cC0zLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1k
cml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazItcXVhbnRhbC12cC0zLG1lZGlhPWRpc2ss
aWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazMtcXVhbnRhbC12cC0z
LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazQt
cXVhbnRhbC12cC0zLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJF
TD1LVk0vZGlzazUtcXVhbnRhbC12cC0zLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1waWRmaWxl
IC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLXZwLTMgLXNlcmlhbCBmaWxlOi9kZXYvc2ht
L2tib290L3NlcmlhbC1xdWFudGFsLXZwLTMgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1t
b25pdG9yIG51bGwgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxk
LTE3OjIwMTQwODAxMjE0NjM4OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAt
cmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNjRhYTkwZjI2YzA2
ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtMjA6MjAx
NDA4MDEyMTQ2Mzg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzc6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNiMmFh
Y2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDgwMTIx
NDYzODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNi4wLXJjNzoxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3
ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTIyOjIwMTQwODAxMjE0NjM1Omkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2Zi
ZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtMjg6MjAxNDA4MDEyMTQ2MzM6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkx
L2RtZXNnLXlvY3RvLWtidWlsZC0yOToyMDE0MDgwMTIxNDYzNTppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2ct
eW9jdG8ta2J1aWxkLTMxOjIwMTQwODAxMjE0NjM2OmkzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNDozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQv
NjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by12
cC0xNjoyMDE0MDgwMTIxNDkxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNi4w
LXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5MGYyNmMw
NmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8tdnAtMTk6MjAxNDA4
MDEyMTQ5MjE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzc6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNiMmFhY2Zi
OThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA4MDEyMTQ5MTk6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJk
NmMxYTkxL2RtZXNnLXlvY3RvLXZwLTIxOjIwMTQwODAxMjE0OTI1OmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVz
Zy15b2N0by12cC0yNToyMDE0MDgwMTIxNDkxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQ6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0
YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8tdnAt
MzQ6MjAxNDA4MDEyMTQ5MjU6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1y
Yzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZl
MWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLXZwLTQ6MjAxNDA4MDEy
MTQ5MjQ6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzc6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThh
N2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLXZwLTUwOjIwMTQwODAxMjE0OTI0OmkzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZj
MWE5MS9kbWVzZy15b2N0by12cC01MzoyMDE0MDgwMTIxNDkxOTppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2ct
eW9jdG8tdnAtNToyMDE0MDgwMTIxNDkxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6
My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxk
LTM6MjAxNDA4MDEyMTQ2NDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1y
Yzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC82NGFhOTBmMjZjMDZl
MWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQwODAx
MjE0OTI5OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3OjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4
YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by12cC00NjoyMDE0MDgwMTIxNDkyOTppMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2
YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwODAxMjE0NjQxOmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3OjEKMTI6MjE6MjQgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCA2NGFhOTBmMjZjMDZlMWNiMmFhY2Zi
OThhN2QwZWNjZmJkNmMxYTkxCmdpdCBjaGVja291dCB2My4xNQpscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThh
ZWRkZmZlNWFmZDlkMGQ6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDEtMjE6NTE6MzEgMTg2
MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZCBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQw
ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNC0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5
ZDBkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTE4NjBl
Mzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVk
ZGZmZTVhZmQ5ZDBkL3ZtbGludXotMy4xNS4wCgoyMDE0LTA4LTAxLTIxOjU2OjMxIGRldGVj
dGluZyBib290IHN0YXRlIC4JMTMgVEVTVCBGQUlMVVJFClsgICAgMi44NTUyMjFdIFsgSU5G
TzogaW5jb25zaXN0ZW50IGxvY2sgc3RhdGUgXQpbICAgIDIuODU2MTI3XSAzLjE1LjAgIzIg
Tm90IHRhaW50ZWQKWyAgICAyLjg1NjcxM10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tClsgICAgMi44NTY3MTNdIGluY29uc2lzdGVudCB7U09GVElSUS1PTi1XfSAtPiB7
SU4tU09GVElSUS1XfSB1c2FnZS4KWyAgICAyLjg1NjcxM10gc3dhcHBlci8wIFtIQzBbMF06
U0MxWzFdOkhFMDpTRTBdIHRha2VzOgpbICAgIDIuODU2NzEzXSAgKGZsb3BweV9sb2NrKXsr
Lj8uLi59LCBhdDogWzxjM2UzMjVlZj5dIGNmcV9pZGxlX3NsaWNlX3RpbWVyKzB4MWEvMHg3
NwpbICAgIDIuODU2NzEzXSB7U09GVElSUS1PTi1XfSBzdGF0ZSB3YXMgcmVnaXN0ZXJlZCBh
dDoKWyAgICAyLjg1NjcxM10gICBbPGMzYzU1Yzk5Pl0gbWFya19oZWxkX2xvY2tzKzB4NGEv
MHg2MApbICAgIDIuODU2NzEzXSAgIFs8YzNjNTVkZmE+XSB0cmFjZV9oYXJkaXJxc19vbl9j
YWxsZXIrMHgxNGIvMHgxNjUKWyAgICAyLjg1NjcxM10gICBbPGMzYzU1ZTFmPl0gdHJhY2Vf
aGFyZGlycXNfb24rMHhiLzB4ZApbICAgIDIuODU2NzEzXSAgIFs8YzNlMzBhMDQ+XSBibGtn
X3J3c3RhdF9yZWFkKzB4MjIvMHgyZQpbICAgIDIuODU2NzEzXSAgIFs8YzNlMzFjMTA+XSBf
X2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4NjUvMHgxNjUKWyAgICAyLjg1NjcxM10gICBbPGMz
ZTMzZTk2Pl0gY2ZxX2Rpc3BhdGNoX3JlcXVlc3RzKzB4NTIxLzB4NzhhClsgICAgMi44NTY3
MTNdICAgWzxjM2UyMTFlYz5dIGJsa19wZWVrX3JlcXVlc3QrMHg1OS8weDIxMQpbICAgIDIu
ODU2NzEzXSAgIFs8YzNlMjEzYjI+XSBibGtfZmV0Y2hfcmVxdWVzdCsweGUvMHgxZQpbICAg
IDIuODU2NzEzXSAgIFs8YzNmMDJlMDg+XSByZWRvX2ZkX3JlcXVlc3QrMHg3YS8weGM2Ngpb
ICAgIDIuODU2NzEzXSAgIFs8YzNmMDA3YzQ+XSBmbG9wcHlfd29ya193b3JrZm4rMHhlLzB4
MTAKWyAgICAyLjg1NjcxM10gICBbPGMzYzQxODYxPl0gcHJvY2Vzc19vbmVfd29yaysweDFk
NC8weDM5OApbICAgIDIuODU2NzEzXSAgIFs8YzNjNDIwYjk+XSB3b3JrZXJfdGhyZWFkKzB4
MTJiLzB4MWM4ClsgICAgMi44NTY3MTNdICAgWzxjM2M0NWI0Yj5dIGt0aHJlYWQrMHg4Yi8w
eDkwClsgICAgMi44NTY3MTNdICAgWzxjNDA2NzI4MD5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgyMC8weDMwClsgICAgMi44NTY3MTNdIGlycSBldmVudCBzdGFtcDogMjgwOTEKWyAg
ICAyLjg1NjcxM10gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoMjgwOTApOiBbPGM0MDY2
NWQxPl0gX3Jhd19zcGluX3VubG9ja19pcnErMHgyNy8weDM1ClsgICAgMi44NTY3MTNdIGhh
cmRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDI4MDkxKTogWzxjNDA2NjQ0ZD5dIF9yYXdfc3Bp
bl9sb2NrX2lycXNhdmUrMHgxOC8weDQzClsgICAgMi44NTY3MTNdIHNvZnRpcnFzIGxhc3Qg
IGVuYWJsZWQgYXQgKDI4MDgyKTogWzxjM2MzMWFmNj5dIF9sb2NhbF9iaF9lbmFibGUrMHgz
ZC8weDNmClsgICAgMi44NTY3MTNdIHNvZnRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDI4MDgz
KTogWzxjM2MwMmQ1OD5dIGRvX3NvZnRpcnFfb3duX3N0YWNrKzB4MjEvMHgyNwpbICAgIDIu
ODU2NzEzXSAKWyAgICAyLjg1NjcxM10gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMg
ZGVidWcgdGhpczoKWyAgICAyLjg1NjcxM10gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNj
ZW5hcmlvOgpbICAgIDIuODU2NzEzXSAKWyAgICAyLjg1NjcxM10gICAgICAgIENQVTAKWyAg
ICAyLjg1NjcxM10gICAgICAgIC0tLS0KWyAgICAyLjg1NjcxM10gICBsb2NrKGZsb3BweV9s
b2NrKTsKWyAgICAyLjg1NjcxM10gICA8SW50ZXJydXB0PgpbICAgIDIuODU2NzEzXSAgICAg
bG9jayhmbG9wcHlfbG9jayk7ClsgICAgMi44NTY3MTNdIApbICAgIDIuODU2NzEzXSAgKioq
IERFQURMT0NLICoqKgpbICAgIDIuODU2NzEzXSAKWyAgICAyLjg1NjcxM10gMSBsb2NrIGhl
bGQgYnkgc3dhcHBlci8wOgpbICAgIDIuODU2NzEzXSAgIzA6ICAoKCZjZnFkLT5pZGxlX3Ns
aWNlX3RpbWVyKSl7Ky4tLi4ufSwgYXQ6IFs8YzNjMzZmYmM+XSBjYWxsX3RpbWVyX2ZuKzB4
MC8weDFiMwpbICAgIDIuODU2NzEzXSAKWyAgICAyLjg1NjcxM10gc3RhY2sgYmFja3RyYWNl
OgpbICAgIDIuODU2NzEzXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xNS4wICMyClsgICAgMi44NTY3MTNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hz
LCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjg1NjcxM10gIDAwMDAwMDAwIGM0MzFk
NTM0IGQzNDBiZTQ4IGM0MDYxMjY0IGQzNDBiZTc0IGM0MDVlY2Q2IGM0MjNkODI5IGM0MjNk
NzI4ClsgICAgMi44NTY3MTNdICBjNDIzZDZmMCBjNDIzZDcwZiBjNDIzZDcxOSBjNDIzZTU1
YiAwMDAwMDAwNCBjNDMxZDk0OCAwMDAwMDAwMiBkMzQwYmU5YwpbICAgIDIuODU2NzEzXSAg
YzNjNTViNzEgMDAwMDAwMDQgMDAwMDAwMDAgYzNjNTU2MzAgYzQzMWQ1MzQgMDAwMDAwMDYg
MDAwMDAwMDAgYzQzMWQ5NDgKWyAgICAyLjg1NjcxM10gQ2FsbCBUcmFjZToKWyAgICAyLjg1
NjcxM10gIFs8YzQwNjEyNjQ+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDIuODU2NzEz
XSAgWzxjNDA1ZWNkNj5dIHByaW50X3VzYWdlX2J1ZysweDE4MC8weDE4ZApbICAgIDIuODU2
NzEzXSAgWzxjM2M1NWI3MT5dIG1hcmtfbG9jaysweGY1LzB4MWQzClsgICAgMi44NTY3MTNd
ICBbPGMzYzU1NjMwPl0gPyBjaGVja191c2FnZV9iYWNrd2FyZHMrMHg4OS8weDg5ClsgICAg
Mi44NTY3MTNdICBbPGMzYzU2Mjk2Pl0gX19sb2NrX2FjcXVpcmUrMHgyNjAvMHhiZTkKWyAg
ICAyLjg1NjcxM10gIFs8YzNjNTU1YTc+XSA/IHByaW50X3Nob3J0ZXN0X2xvY2tfZGVwZW5k
ZW5jaWVzKzB4MTMzLzB4MTMzClsgICAgMi44NTY3MTNdICBbPGMzYzU2ZWQ4Pl0gbG9ja19h
Y3F1aXJlKzB4OGQvMHhmYwpbICAgIDIuODU2NzEzXSAgWzxjM2UzMjVlZj5dID8gY2ZxX2lk
bGVfc2xpY2VfdGltZXIrMHgxYS8weDc3ClsgICAgMi44NTY3MTNdICBbPGMzZTMyNWQ1Pl0g
PyBjZnFfcHJlZW1wdF9xdWV1ZSsweDhkLzB4OGQKWyAgICAyLjg1NjcxM10gIFs8YzQwNjY0
Njg+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MzMvMHg0MwpbICAgIDIuODU2NzEzXSAg
WzxjM2UzMjVlZj5dID8gY2ZxX2lkbGVfc2xpY2VfdGltZXIrMHgxYS8weDc3ClsgICAgMi44
NTY3MTNdICBbPGMzZTMyNWVmPl0gY2ZxX2lkbGVfc2xpY2VfdGltZXIrMHgxYS8weDc3Clsg
ICAgMi44NTY3MTNdICBbPGMzZTMyNWQ1Pl0gPyBjZnFfcHJlZW1wdF9xdWV1ZSsweDhkLzB4
OGQKWyAgICAyLjg1NjcxM10gIFs8YzNjMzcwNTM+XSBjYWxsX3RpbWVyX2ZuKzB4OTcvMHgx
YjMKWyAgICAyLjg1NjcxM10gIFs8YzNlMzI1ZDU+XSA/IGNmcV9wcmVlbXB0X3F1ZXVlKzB4
OGQvMHg4ZApbICAgIDIuODU2NzEzXSAgWzxjM2UzMjVkNT5dID8gY2ZxX3ByZWVtcHRfcXVl
dWUrMHg4ZC8weDhkClsgICAgMi44NTY3MTNdICBbPGMzYzM3NjZkPl0gcnVuX3RpbWVyX3Nv
ZnRpcnErMHgxOWEvMHgxYmMKWyAgICAyLjg1NjcxM10gIFs8YzNjMzFlYzU+XSBfX2RvX3Nv
ZnRpcnErMHgxMGYvMHgyYjgKWyAgICAyLjg1NjcxM10gIFs8YzNjMzFkYjY+XSA/IF9fbG9j
YWxfYmhfZGlzYWJsZV9pcCsweDZiLzB4NmIKWyAgICAyLjg1NjcxM10gIFs8YzNjMDJkNTg+
XSBkb19zb2Z0aXJxX293bl9zdGFjaysweDIxLzB4MjcKWyAgICAyLjg1NjcxM10gIDxJUlE+
ICBbPGMzYzMyMjU0Pl0gaXJxX2V4aXQrMHgzZi8weDU4ClsgICAgMi44NTY3MTNdICBbPGMz
YzAyYjM3Pl0gZG9fSVJRKzB4N2IvMHg4ZQpbICAgIDIuODU2NzEzXSAgWzxjNDA2NzdiMT5d
IGNvbW1vbl9pbnRlcnJ1cHQrMHgzMS8weDM4ClsgICAgMi44NTY3MTNdICBbPGMzYzFkODM3
Pl0gPyBuYXRpdmVfc2FmZV9oYWx0KzB4NS8weDcKWyAgICAyLjg1NjcxM10gIFs8YzNjMDdm
MmI+XSBkZWZhdWx0X2lkbGUrMHgxYi8weDNkClsgICAgMi44NTY3MTNdICBbPGMzYzA4M2Nk
Pl0gYXJjaF9jcHVfaWRsZSsweGUvMHgxMApbICAgIDIuODU2NzEzXSAgWzxjM2M1Mzc5YT5d
IGNwdV9zdGFydHVwX2VudHJ5KzB4MWJiLzB4MWJkClsgICAgMi44NTY3MTNdICBbPGM0MDVi
NzM2Pl0gcmVzdF9pbml0KzB4MTBlLzB4MTEzClsgICAgMi44NTY3MTNdICBbPGM0M2JjOWE0
Pl0gc3RhcnRfa2VybmVsKzB4MzVlLzB4MzYzClsgICAgMi44NTY3MTNdICBbPGM0M2JjMmFi
Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMi45MzUyMzNdIGVuZF9yZXF1
ZXN0OiBJL08gZXJyb3IsIGRldiBmZDAsIHNlY3RvciAwClsgICAgMi45MzYyNDVdIGZsb3Bw
eTogZXJyb3IgLTUgd2hpbGUgcmVhZGluZyBibG9jayAwClsgICAgMi45NTY3OTFdIGVuZF9y
ZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBmZDAsIHNlY3RvciAwCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFm
ZDlkMGQvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwODAxMjE1NTAwOmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNn
LXlvY3RvLWtidWlsZC0yNzoyMDE0MDgwMTIxNTQ1ODppMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2
MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by1rYnVp
bGQtMjoyMDE0MDgwMTIxNTQ1ODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNS4w
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3
MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC0yODoyMDE0MDgwMTIx
NTc0NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRm
ZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC0yOToyMDE0MDgwMTIxNTc0NjppMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVz
Zy15b2N0by12cC0zNjoyMDE0MDgwMTIxNTc0NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUz
Nzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC0zNzoy
MDE0MDgwMTIxNTc0NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0
OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC00MToyMDE0MDgwMTIxNTc0Njpp
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZk
OWQwZC9kbWVzZy15b2N0by12cC01ODoyMDE0MDgwMTIxNTc0NjppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0
by1rYnVpbGQtMjg6MjAxNDA4MDEyMTU1MDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzE4NjBlMzc5
ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtMTQ6MjAx
NDA4MDEyMTU3NTA6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTUuMDoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkw
NThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtMzg6MjAxNDA4MDEyMTU3NTA6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlk
MGQvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwODAxMjE1NTA2OmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXlv
Y3RvLWtidWlsZC0zMDoyMDE0MDgwMTIxNTUwNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQ6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUz
Nzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC01NDoy
MDE0MDgwMTIxNTc1MTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNS4wOjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvMTg2MGUzNzk4NzVkZmU3MjcxYzY0
OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by12cC01OjIwMTQwODAxMjE1NzUxOmkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE1LjA6MgoxMzoxNjoxNiBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjE1CmdpdCBjaGVja291
dCB2My4xNApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjQ1
NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxpbnV4LTgK
CjIwMTQtMDgtMDEtMjE6NTg6MzQgNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZk
NzNkZTExYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtNDU1YzZmZGJkMjE5MTYx
YmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYx
MTY5OWQ2ZDczZGUxMWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC00NTVjNmZkYmQyMTkx
NjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNk
ZTExYy92bWxpbnV6LTMuMTQuMAoKMjAxNC0wOC0wMS0yMjowMDo0MSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuCTkJMTcgVEVTVCBGQUlMVVJFClsgICAgMi4xODM2MzRdIE5YLXByb3RlY3Rp
bmcgdGhlIGtlcm5lbCBkYXRhOiA1NzU2awpbICAgIDIuMjE4OTk4XSB1ZGV2WzEyMl06IHN0
YXJ0aW5nIHZlcnNpb24gMTY0ClsgICAgMi40NjA0NjldIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDIuNDYxNTQ5XSBXQVJOSU5HOiBDUFU6IDAgUElEOiA4
NSBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9rZXJuZWwvc29mdGlycS5jOjE0NSBfX2xvY2Fs
X2JoX2VuYWJsZV9pcCsweDNjLzB4YTEoKQpbICAgIDIuNDYzNDEyXSBNb2R1bGVzIGxpbmtl
ZCBpbjoKWyAgICAyLjQ2MzQxMl0gQ1BVOiAwIFBJRDogODUgQ29tbToga3dvcmtlci91Mjoy
IE5vdCB0YWludGVkIDMuMTQuMCAjMwpbICAgIDIuNDYzNDEyXSBIYXJkd2FyZSBuYW1lOiBC
b2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi40NjM0MTJdIFdvcmtx
dWV1ZTogZmxvcHB5IHJlZG9fZmRfcmVxdWVzdApbICAgIDIuNDYzNDEyXSAgY2I0NWI4OWQg
MDAwMDAwMDAgYzAwMjdjZDAgY2I4NTlkNzEgYzAwMjdjZTggY2I0MmU5ODYgY2I0MzIyMWUg
Y2I2MzAwNDQKWyAgICAyLjQ2MzQxMl0gIDAwMDAwMjAwIGMwMDI3ZDU4IGMwMDI3Y2Y4IGNi
NDJlYTEwIDAwMDAwMDA5IDAwMDAwMDAwIGMwMDI3ZDA4IGNiNDMyMjFlClsgICAgMi40NjM0
MTJdICBjMDAyN2QzOCBjMDA5MDIzNCBjMDAyN2QxMCBjYjYzMDA1NiBjMDAyN2QyNCBjYjYz
MDA3NSBjMDcyYTAwMCBjMDA5MDAwMApbICAgIDIuNDYzNDEyXSBDYWxsIFRyYWNlOgpbICAg
IDIuNDYzNDEyXSAgWzxjYjQ1Yjg5ZD5dID8gY29uc29sZV91bmxvY2srMHgzNTUvMHgzODIK
WyAgICAyLjQ2MzQxMl0gIFs8Y2I4NTlkNzE+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAg
IDIuNDYzNDEyXSAgWzxjYjQyZTk4Nj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NWYvMHg3
NgpbICAgIDIuNDYzNDEyXSAgWzxjYjQzMjIxZT5dID8gX19sb2NhbF9iaF9lbmFibGVfaXAr
MHgzYy8weGExClsgICAgMi40NjM0MTJdICBbPGNiNjMwMDQ0Pl0gPyBsb2NhbF9iaF9kaXNh
YmxlKzB4MTQvMHgxNApbICAgIDIuNDYzNDEyXSAgWzxjYjQyZWExMD5dIHdhcm5fc2xvd3Bh
dGhfbnVsbCsweDE0LzB4MTgKWyAgICAyLjQ2MzQxMl0gIFs8Y2I0MzIyMWU+XSBfX2xvY2Fs
X2JoX2VuYWJsZV9pcCsweDNjLzB4YTEKWyAgICAyLjQ2MzQxMl0gIFs8Y2I2MzAwNTY+XSBs
b2NhbF9iaF9lbmFibGUrMHgxMi8weDE0ClsgICAgMi40NjM0MTJdICBbPGNiNjMwMDc1Pl0g
YmxrZ19yd3N0YXRfcmVhZCsweDFkLzB4MjQKWyAgICAyLjQ2MzQxMl0gIFs8Y2I2MzE0MDQ+
XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4NjUvMHgxNjUKWyAgICAyLjQ2MzQxMl0gIFs8
Y2I0NTZiNjk+XSA/IF9fbG9ja19hY3F1aXJlKzB4NTIzLzB4YmRmClsgICAgMi40NjM0MTJd
ICBbPGNiNDU0Y2MwPl0gPyBfX2xvY2tfaXNfaGVsZCsweDJkLzB4NDMKWyAgICAyLjQ2MzQx
Ml0gIFs8Y2I0NTYwOTg+XSA/IG1hcmtfbG9jaysweDFlLzB4MWQzClsgICAgMi40NjM0MTJd
ICBbPGNiNDU2MDk4Pl0gPyBtYXJrX2xvY2srMHgxZS8weDFkMwpbICAgIDIuNDYzNDEyXSAg
WzxjYjQxZGZiOT5dID8gcHZjbG9ja19jbG9ja3NvdXJjZV9yZWFkKzB4YjEvMHhkYQpbICAg
IDIuNDYzNDEyXSAgWzxjYjYzMzk4Nz5dIGNmcV9kaXNwYXRjaF9yZXF1ZXN0cysweDUyMS8w
eDc4YQpbICAgIDIuNDYzNDEyXSAgWzxjYjQ1NmI2OT5dID8gX19sb2NrX2FjcXVpcmUrMHg1
MjMvMHhiZGYKWyAgICAyLjQ2MzQxMl0gIFs8Y2I0NTRkM2M+XSA/IHJlZ2lzdGVyX2xvY2tf
Y2xhc3MrMHgxNi8weDI0MApbICAgIDIuNDYzNDEyXSAgWzxjYjQ1NjA5OD5dID8gbWFya19s
b2NrKzB4MWUvMHgxZDMKWyAgICAyLjQ2MzQxMl0gIFs8Y2I0NTc0ZjQ+XSA/IGxvY2tfYWNx
dWlyZSsweGEzLzB4ZmMKWyAgICAyLjQ2MzQxMl0gIFs8Y2I3MDE2MDI+XSA/IHJlZG9fZmRf
cmVxdWVzdCsweDNmLzB4YzY2ClsgICAgMi40NjM0MTJdICBbPGNiNjIwOGUxPl0gYmxrX3Bl
ZWtfcmVxdWVzdCsweDU5LzB4MjExClsgICAgMi40NjM0MTJdICBbPGNiNjIwYWE3Pl0gYmxr
X2ZldGNoX3JlcXVlc3QrMHhlLzB4MWUKWyAgICAyLjQ2MzQxMl0gIFs8Y2I3MDE2M2Q+XSBy
ZWRvX2ZkX3JlcXVlc3QrMHg3YS8weGM2NgpbICAgIDIuNDYzNDEyXSAgWzxjYjQ1NzRmND5d
ID8gbG9ja19hY3F1aXJlKzB4YTMvMHhmYwpbICAgIDIuNDYzNDEyXSAgWzxjYjQ0MWI3ZD5d
ID8gcHJvY2Vzc19vbmVfd29yaysweDEzYy8weDM5OApbICAgIDIuNDYzNDEyXSAgWzxjYjQ0
MWMxNT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDQvMHgzOTgKWyAgICAyLjQ2MzQxMl0gIFs8
Y2I0NDI0NjQ+XSB3b3JrZXJfdGhyZWFkKzB4MTJiLzB4MWM4ClsgICAgMi40NjM0MTJdICBb
PGNiNDQyMzM5Pl0gPyByZXNjdWVyX3RocmVhZCsweDFmZi8weDFmZgpbICAgIDIuNDYzNDEy
XSAgWzxjYjQ0NWYwYj5dIGt0aHJlYWQrMHg4Yi8weDkwClsgICAgMi40NjM0MTJdICBbPGNi
ODVmYmY3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAyLjQ2MzQx
Ml0gIFs8Y2I0NDVlODA+XSA/IGluc2VydF9rdGhyZWFkX3dvcmsrMHg1YS8weDVhClsgICAg
Mi40NjM0MTJdIC0tLVsgZW5kIHRyYWNlIGUwN2I0YjU3YmZlNWZiZmMgXS0tLQpbICAgIDIu
NTg2ODYzXSBlbmRfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgZmQwLCBzZWN0b3IgMAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC80NTVjNmZkYmQyMTkxNjFiZDA5YjEx
NjVmMTE2OTlkNmQ3M2RlMTFjL2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDgwMTIxNTkz
ODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZk
NzNkZTExYy9kbWVzZy15b2N0by1rYnVpbGQtNDoyMDE0MDgwMTIxNTkzNzppMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQ6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVz
Zy15b2N0by1rYnVpbGQtMTA6MjAxNDA4MDEyMTU5NTA6aTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzQ1
NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2cteW9jdG8ta2J1
aWxkLTI6MjAxNDA4MDEyMTU5NTI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTQu
MDozCjE3OjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0w
MSAyMjowMjoyNCBSRVBFQVQgQ09VTlQ6IDYyICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgv
b2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjE0CmdpdCBj
aGVja291dCB2My4xMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgw
MTIwOmQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmU6YmlzZWN0LWxp
bnV4LTgKCjIwMTQtMDgtMDEtMjI6MDg6MDkgZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtZDhlYzI2ZDdm
ODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0
OTRmNTZlODgxNDIxMGYwZTY0YmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC1kOGVjMjZk
N2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0
MjEwZjBlNjRiZS92bWxpbnV6LTMuMTMuMAoKMjAxNC0wOC0wMS0yMjoxMDoxMyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJMTEJMjcgVEVTVCBGQUlMVVJFClsgICAgMy41MTE1NjBdIHJhbmRv
bTogaW5pdCB1cmFuZG9tIHJlYWQgd2l0aCAxNiBiaXRzIG9mIGVudHJvcHkgYXZhaWxhYmxl
ClsgICAgMy42NDcxMzRdIG1vdW50YWxsICgxMjEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVw
dGg6IDYyOTYgYnl0ZXMgbGVmdAoKQlVHOiBrZXJuZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGlt
ZTogMzUKcWVtdS1zeXN0ZW0teDg2XzY0IC1lbmFibGUta3ZtIC1jcHUgSGFzd2VsbCwrc21l
cCwrc21hcCAta2VybmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4
ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvdm1saW51ei0zLjEzLjAg
LWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRl
YnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9z
dGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNo
ZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNv
bGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODAxMjA6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZTpiaXNlY3QtbGludXgtOC8udm1saW51ei1kOGVjMjZkN2Y4Mjg3ZjU3
ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlLTIwMTQwODAxMjIxMzU1LTI3LWtidWlsZCBicmFu
Y2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwODAxMjAgQk9PVF9JTUFHRT0va2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0
ZjU2ZTg4MTQyMTBmMGU2NGJlL3ZtbGludXotMy4xMy4wIGRyYmQubWlub3JfY291bnQ9OCcg
IC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1t
IDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFu
PTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBi
YXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1rYnVp
bGQtMTMgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWtidWls
ZC0xMyAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMjE6MjAxNDA4MDEyMjA4NTI6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0
YmUvZG1lc2cteW9jdG8ta2J1aWxkLTI5OjIwMTQwODAxMjIwODUyOmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlv
Y3RvLWtidWlsZC0zMToyMDE0MDgwMTIyMDg1NDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2
ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQt
NToyMDE0MDgwMTIyMDg1MjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4
YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC0yMzoyMDE0MDgwMTIyMTEz
NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEw
ZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA4MDEyMjA4NTY6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1l
c2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwODAxMjIwODU1OmkzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNDozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9k
OGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWti
dWlsZC03OjIwMTQwODAxMjIwODU2OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEz
LjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kOGVjMjZkN2Y4Mjg3
ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWtidWlsZC0xNToyMDE0
MDgwMTIyMDg1ODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1
NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMTk6MjAxNDA4MDEyMjA4NTg6
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYw
ZTY0YmUvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwODAxMjIwODU4OmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNn
LXlvY3RvLWtidWlsZC0yMjoyMDE0MDgwMTIyMDg1ODppMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVp
bGQtMjU6MjAxNDA4MDEyMjA4NTg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMu
MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdm
NTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA4
MDEyMjA4NTg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZl
ODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA4MDEyMjA4NTk6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0
YmUvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA4MDEyMjA4NTg6aTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9j
dG8ta2J1aWxkLTk6MjAxNDA4MDEyMjA4NTg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3
ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtMTM6MjAx
NDA4MDEyMjExNDY6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRm
NTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtMTg6MjAxNDA4MDEyMjExNTM6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0
YmUvZG1lc2cteW9jdG8tdnAtMjY6MjAxNDA4MDEyMjExNDc6aTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8t
dnAtMzI6MjAxNDA4MDEyMjExNDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMu
MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdm
NTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtNDI6MjAxNDA4MDEy
MjExNDQ6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgx
NDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA4MDEyMjExNDI6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1l
c2cteW9jdG8tdnAtNjQ6MjAxNDA4MDEyMjExNDg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMy
NmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtMzA6
MjAxNDA4MDEyMjExNTM6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMDoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0
OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tdnAtMToyMDE0MDgwMTIyMTIwNDpp
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBl
NjRiZS9kbWVzZy15b2N0by12cC0yOToyMDE0MDgwMTIyMTIwNDppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0
by12cC00NzoyMDE0MDgwMTIyMTIwNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4x
My4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4
N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC01NzoyMDE0MDgw
MTIyMTIwNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC01OToyMDE0MDgwMTIyMTIwNDppMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9k
bWVzZy15b2N0by12cC04OjIwMTQwODAxMjIxMjA0OmkzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNDozLjEzLjA6MQoxODozMTo0MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlz
ZWN0OiBiYWQgY29tbWl0IHYzLjEzCmdpdCBjaGVja291dCB2My4xMgpscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNl
NWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDEtMjI6MjU6MDYg
NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQtNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVj
ZWI1MgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC01ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZh
NWNlYjUyCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNWUw
MWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi92bWxpbnV6LTMuMTIuMAoK
MjAxNC0wOC0wMS0yMjoyNzowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTE2CTQ2CTYyIFNV
Q0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTIKZ2l0IGJpc2VjdCBzdGFydCB2My4x
MyB2My4xMiAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJ2My4x
MyIsICItZyIsICJ2My4xMiIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdCJdCkJpc2Vj
dGluZzogMTMyODggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDE0IHN0ZXBzKQpbM2JhZDhiYjVjZDMwNDhhNjdkZjQzYWM2YjFlMmYxOTFmMTlkOWZmMF0g
TWVyZ2UgYnJhbmNoICdmb3ItbmV4dCcgb2YgZ2l0Oi8vZ2l0LnNhbWJhLm9yZy9zZnJlbmNo
L2NpZnMtMi42CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEyMDozYmFkOGJiNWNkMzA0OGE2N2RmNDNh
YzZiMWUyZjE5MWYxOWQ5ZmYwOmJpc2VjdC1saW51eC04CgoyMDE0LTA4LTAxLTIyOjM4OjQy
IDNiYWQ4YmI1Y2QzMDQ4YTY3ZGY0M2FjNmIxZTJmMTkxZjE5ZDlmZjAgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0LTNiYWQ4YmI1Y2QzMDQ4YTY3ZGY0M2FjNmIxZTJmMTkxZjE5
ZDlmZjAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC8zYmFkOGJiNWNkMzA0OGE2N2RmNDNhYzZiMWUyZjE5MWYxOWQ5ZmYwCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQtM2JhZDhiYjVjZDMwNDhhNjdkZjQzYWM2YjFlMmYxOTFm
MTlkOWZmMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTNi
YWQ4YmI1Y2QzMDQ4YTY3ZGY0M2FjNmIxZTJmMTkxZjE5ZDlmZjAKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zYmFkOGJiNWNkMzA0OGE2N2RmNDNhYzZi
MWUyZjE5MWYxOWQ5ZmYwL3ZtbGludXotMy4xMy4wLXJjMS0wMDIxNi1nM2JhZDhiYgoKMjAx
NC0wOC0wMS0yMjo0NDo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTYyIFNVQ0NFU1MKCkJp
c2VjdGluZzogMTY5NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMTEgc3RlcHMpCltkZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2
XSBNZXJnZSBicmFuY2ggJ3NjaGVkLXVyZ2VudC1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA4MDEyMDpkZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2OmJp
c2VjdC1saW51eC04CgoyMDE0LTA4LTAxLTIyOjQ3OjQxIGRkMDUwODA5M2I3OTE0MWUwMDQ0
Y2EwMmYwYWNiNjMxOWY2OWY1NDYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LWRk
MDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkx
NDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQt
ZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ngp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3Vt
ZXIvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LWRkMDUwODA5M2I3OTE0MWUwMDQ0Y2Ew
MmYwYWNiNjMxOWY2OWY1NDYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L3ZtbGlu
dXotMy4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MAoKMjAxNC0wOC0wMS0yMjo1ODoxOCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDEuNjkwMzA1XSB0c2M6IFJl
ZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyNjkzLjUxMSBNSHoKWyAgICAx
LjY5MTE2MV0gdWRldlsxMDRdOiBzdGFydGluZyB2ZXJzaW9uIDE2NApbICAgIDEuODE0ODA0
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjgxNjcwNV0g
V0FSTklORzogQ1BVOiAwIFBJRDogNjcgYXQgL2tidWlsZC9zcmMvY29uc3VtZXIva2VybmVs
L3NvZnRpcnEuYzoxNTYgX2xvY2FsX2JoX2VuYWJsZV9pcCsweDM0LzB4OTcoKQpbICAgIDEu
ODE2NzA1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjgxNjcwNV0gQ1BVOiAwIFBJRDog
NjcgQ29tbToga3dvcmtlci91MjoyIE5vdCB0YWludGVkIDMuMTMuMC1yYzQtMDAwMjgtZ2Rk
MDUwODAgIzIKWyAgICAxLjgxNjcwNV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEu
ODE2NzA1XSBXb3JrcXVldWU6IGZsb3BweSByZWRvX2ZkX3JlcXVlc3QKWyAgICAxLjgxNjcw
NV0gIGMwMjU4YmFhIDAwMDAwMDAwIGQyNzhkY2U4IGMwNjQ4YjZjIGQyNzhkZDAwIGMwMjJk
NjAzIGMwMjMwZGYzIGMwNDI5ZTUyClsgICAgMS44MTY3MDVdICBkMjczMDIzNCBkMjc4ZGQ2
YyBkMjc4ZGQxMCBjMDIyZDY4ZCAwMDAwMDAwOSAwMDAwMDAwMCBkMjc4ZGQxYyBjMDIzMGRm
MwpbICAgIDEuODE2NzA1XSAgZDI3OGRkNGMgZDI3OGRkMjQgYzAyMzBlNjYgZDI3OGRkMzgg
YzA0MjllNTIgZDIwZGViZDAgZDI3MzAwMDAgZDI3M2NlMDAKWyAgICAxLjgxNjcwNV0gQ2Fs
bCBUcmFjZToKWyAgICAxLjgxNjcwNV0gIFs8YzAyNThiYWE+XSA/IGNvbnNvbGVfdW5sb2Nr
KzB4MzU1LzB4MzgyClsgICAgMS44MTY3MDVdICBbPGMwNjQ4YjZjPl0gZHVtcF9zdGFjaysw
eDE2LzB4MTgKWyAgICAxLjgxNjcwNV0gIFs8YzAyMmQ2MDM+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDVmLzB4NzYKWyAgICAxLjgxNjcwNV0gIFs8YzAyMzBkZjM+XSA/IF9sb2NhbF9i
aF9lbmFibGVfaXArMHgzNC8weDk3ClsgICAgMS44MTY3MDVdICBbPGMwNDI5ZTUyPl0gPyBi
bGtnX3J3c3RhdF9yZWFkKzB4MWQvMHgyNApbICAgIDEuODE2NzA1XSAgWzxjMDIyZDY4ZD5d
IHdhcm5fc2xvd3BhdGhfbnVsbCsweDE0LzB4MTgKWyAgICAxLjgxNjcwNV0gIFs8YzAyMzBk
ZjM+XSBfbG9jYWxfYmhfZW5hYmxlX2lwKzB4MzQvMHg5NwpbICAgIDEuODE2NzA1XSAgWzxj
MDIzMGU2Nj5dIGxvY2FsX2JoX2VuYWJsZSsweDEwLzB4MTIKWyAgICAxLjgxNjcwNV0gIFs8
YzA0MjllNTI+XSBibGtnX3J3c3RhdF9yZWFkKzB4MWQvMHgyNApbICAgIDEuODE2NzA1XSAg
WzxjMDQyYjFhNT5dIF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHg2NS8weDE2NQpbICAgIDEu
ODE2NzA1XSAgWzxjMDI1MzQ2Yj5dID8gbWFya19sb2NrKzB4MWUvMHgxZDMKWyAgICAxLjgx
NjcwNV0gIFs8YzAyNTM0NmI+XSA/IG1hcmtfbG9jaysweDFlLzB4MWQzClsgICAgMS44MTY3
MDVdICBbPGMwMjUyMjYyPl0gPyBfX2xvY2tfaXNfaGVsZCsweDJkLzB4NDMKWyAgICAxLjgx
NjcwNV0gIFs8YzAyMWM4YTQ+XSA/IGt2bV9jbG9ja19yZWFkKzB4MTQvMHgxZApbICAgIDEu
ODE2NzA1XSAgWzxjMDIwNjQ5ND5dID8gcGFyYXZpcnRfc2NoZWRfY2xvY2srMHg5LzB4ZApb
ICAgIDEuODE2NzA1XSAgWzxjMDQyZDcyOD5dIGNmcV9kaXNwYXRjaF9yZXF1ZXN0cysweDUy
MS8weDc4YQpbICAgIDEuODE2NzA1XSAgWzxjMDI1M2YzYz5dID8gX19sb2NrX2FjcXVpcmUr
MHg1MjMvMHhiZGYKWyAgICAxLjgxNjcwNV0gIFs8YzAyNTNmM2M+XSA/IF9fbG9ja19hY3F1
aXJlKzB4NTIzLzB4YmRmClsgICAgMS44MTY3MDVdICBbPGMwMjUzNDZiPl0gPyBtYXJrX2xv
Y2srMHgxZS8weDFkMwpbICAgIDEuODE2NzA1XSAgWzxjMDI1NDhjNz5dID8gbG9ja19hY3F1
aXJlKzB4YTMvMHhmYwpbICAgIDEuODE2NzA1XSAgWzxjMDRmOGQ1MT5dID8gcmVkb19mZF9y
ZXF1ZXN0KzB4M2YvMHhjMGMKWyAgICAxLjgxNjcwNV0gIFs8YzA0MWE4YzA+XSBibGtfcGVl
a19yZXF1ZXN0KzB4NTkvMHgyMTEKWyAgICAxLjgxNjcwNV0gIFs8YzA0MWFhODY+XSBibGtf
ZmV0Y2hfcmVxdWVzdCsweGUvMHgxZQpbICAgIDEuODE2NzA1XSAgWzxjMDRmOGQ4Yz5dIHJl
ZG9fZmRfcmVxdWVzdCsweDdhLzB4YzBjClsgICAgMS44MTY3MDVdICBbPGMwMjQwNjUxPl0g
PyBwcm9jZXNzX29uZV93b3JrKzB4MTNjLzB4Mzk4ClsgICAgMS44MTY3MDVdICBbPGMwMjQw
NmU5Pl0gcHJvY2Vzc19vbmVfd29yaysweDFkNC8weDM5OApbICAgIDEuODE2NzA1XSAgWzxj
MDI0MGYzOD5dIHdvcmtlcl90aHJlYWQrMHgxMmIvMHgxYzgKWyAgICAxLjgxNjcwNV0gIFs8
YzAyNDBlMGQ+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4MWZmLzB4MWZmClsgICAgMS44MTY3MDVd
ICBbPGMwMjQ0YTcyPl0ga3RocmVhZCsweDhiLzB4OTAKWyAgICAxLjgxNjcwNV0gIFs8YzA2
NGVhYjc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDEuODE2NzA1
XSAgWzxjMDI0NDllNz5dID8gaW5zZXJ0X2t0aHJlYWRfd29yaysweDVhLzB4NWEKWyAgICAx
LjgxNjcwNV0gLS0tWyBlbmQgdHJhY2UgYmYwNWU0MGI1NDlmOTQ0MyBdLS0tClsgICAgMS45
MTAxNzFdIGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBmZDAsIHNlY3RvciAwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2Ew
MmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8taXZiNDMtMTA2OjIwMTQwODAxMjI1ODEy
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYv
ZG1lc2cteW9jdG8taXZiNDMtMjU6MjAxNDA4MDEyMjU4MTI6aTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4
MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1pdmI0My0y
NjoyMDE0MDgwMTIyNTgxMDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJm
MGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTcxOjIwMTQwODAxMjI1ODEyOmkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1l
c2cteW9jdG8tdnAtMjE6MjAxNDA4MDEyMjU4NDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2
L2RtZXNnLXlvY3RvLWl2YjQzLTExNDoyMDE0MDgwMTIyNTgxMjppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1
MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQz
LTExODoyMDE0MDgwMTIyNTgxMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNh
MDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTEzOjIwMTQwODAxMjI1ODEy
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYv
ZG1lc2cteW9jdG8taXZiNDMtMTY6MjAxNDA4MDEyMjU4MTI6aTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4
MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1pdmI0My0x
ODoyMDE0MDgwMTIyNTgxMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJm
MGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTE5OjIwMTQwODAxMjI1ODEyOmkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1l
c2cteW9jdG8taXZiNDMtNDc6MjAxNDA4MDEyMjU4MTI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkz
Yjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1pdmI0My02Mjoy
MDE0MDgwMTIyNTgxMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFj
YjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTc4OjIwMTQwODAxMjI1ODEyOmkzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2ct
eW9jdG8taXZiNDMtODU6MjAxNDA4MDEyMjU4MTI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5
MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1pdmI0My04NjoyMDE0
MDgwMTIyNTgxMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYz
MTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTkxOjIwMTQwODAxMjI1ODEyOmkzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9j
dG8taXZiNDMtOTM6MjAxNDA4MDEyMjU4MTI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQx
ZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1pdmI0My02MzoyMDE0MDgw
MTIyNTgxMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlm
NjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0xOToyMDE0MDgwMTIyNTYwMDppMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYw
YWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8tdnAtMTA6MjAxNDA4MDEyMjU4NDY6aTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNh
MDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLXZwLTE3OjIwMTQwODAxMjI1ODQ2Omkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAw
NDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by12cC0zMToyMDE0MDgwMTIyNTg0
NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4
MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0
MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8tdnAtMzk6MjAxNDA4MDEy
MjU4NDY6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2Rk
MDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNi
NzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLXZwLTQzOjIwMTQw
ODAxMjI1ODQ2OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4
LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4
MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by12cC00Njoy
MDE0MDgwMTIyNTg0NjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0w
MDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2Rk
MDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8tdnAt
NTc6MjAxNDA4MDEyMjU4NDY6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1y
YzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEy
NC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3Rv
LWl2YjQzLTMzOjIwMTQwODAxMjI1ODEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUw
MDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8taXZiNDMtMzY6MjAxNDA4MDEy
MjU4MTM6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5
ZjU0Ni9kbWVzZy15b2N0by1pdmI0My0xMTU6MjAxNDA4MDEyMjU4MTc6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQv
ZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1p
dmI0My00MToyMDE0MDgwMTIyNTgxNzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0
NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWl2YjQzLTYwOjIwMTQwODAxMjI1
ODE3OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1
NDYvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2
MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA4MDEyMjU2MDM6aTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNh
MDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDgwMTIyNTYw
NTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4
MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0
MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQw
ODAxMjI1NjAzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4
LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4
MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQt
MTQ6MjAxNDA4MDEyMjU2MDU6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1y
YzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEy
NC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3Rv
LWtidWlsZC0xNToyMDE0MDgwMTIyNTYwMzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6
My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1l
c2cteW9jdG8ta2J1aWxkLTE3OjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5
ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA4MDEyMjU2MDI6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFj
YjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0xOjIwMTQwODAxMjI1NjAyOmkzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRj
YTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQtMjA6MjAxNDA4MDEyMjU2
MDU6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUw
ODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkx
NDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0
MDgwMTIyNTYwNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAy
OC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUw
ODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8ta2J1aWxk
LTIyOjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAt
cmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0
by1rYnVpbGQtMjM6MjAxNDA4MDEyMjU2MDI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2Rt
ZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDgwMTIyNTYwMzppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2
OWY1NDYvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBh
Y2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQtMjc6MjAxNDA4MDEyMjU2MDM6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0
NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0yODoyMDE0MDgwMTIy
NTYwMzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQw
NTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3
OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8ta2J1aWxkLTI5OjIw
MTQwODAxMjI1NjA1OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAw
MDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQw
NTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVp
bGQtMjoyMDE0MDgwMTIyNTYwMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4w
LXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9j
dG8ta2J1aWxkLTMwOjIwMTQwODAxMjI1NjA0OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEy
NDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9k
bWVzZy15b2N0by1rYnVpbGQtMzE6MjAxNDA4MDEyMjU2MDM6aTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlm
NjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBh
Y2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQtNDoyMDE0MDgwMTIyNTYwNTppMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0
Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8ta2J1aWxkLTU6MjAxNDA4MDEyMjU2
MDQ6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUw
ODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9kZDA1MDgwOTNiNzkx
NDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNnLXlvY3RvLWtidWlsZC02OjIwMTQw
ODAxMjI1NjA0OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmM0LTAwMDI4
LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZGQwNTA4
MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0Ni9kbWVzZy15b2N0by1rYnVpbGQt
NzoyMDE0MDgwMTIyNTYwMzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJj
NC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDYvZG1lc2cteW9jdG8t
a2J1aWxkLTg6MjAxNDA4MDEyMjU2MDI6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMu
MTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC9kZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2L2RtZXNn
LXlvY3RvLWtidWlsZC05OjIwMTQwODAxMjI1NjA1OmkzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNDozLjEzLjAtcmM0LTAwMDI4LWdkZDA1MDgwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0
Ni9kbWVzZy15b2N0by12cC0xNDoyMDE0MDgwMTIyNTg1MTppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMy4wLXJjNC0wMDAyOC1nZGQwNTA4MDoyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0L2RkMDUwODA5M2I3OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2
OWY1NDYvZG1lc2cteW9jdG8tdnAtNTE6MjAxNDA4MDEyMjU4NTE6aTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0OjMuMTMuMC1yYzQtMDAwMjgtZ2RkMDUwODA6MgowOjYyOjYyIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDk2NCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClszZjAyZmY1YzJjNjk3NTM2
NjY3ODdlZDEyNTcwOGQyODNhODIzZmZiXSBNZXJnZSB0YWcgJ3R0eS0zLjEzLXJjMycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC90
dHkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4
ZDI4M2E4MjNmZmI6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDEtMjM6MDA6MzcgM2YwMmZm
NWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQtM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYgpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC0zZjAyZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNhODIzZmZi
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9q
YWtldG93bi1jb25zdW1lci9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtM2YwMmZmNWMy
YzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4
M2E4MjNmZmIvdm1saW51ei0zLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YwoKMjAxNC0wOC0w
MS0yMzoxMDo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNSBURVNUIEZBSUxVUkUKWyAgICAx
LjgxNzU4N10gTlgtcHJvdGVjdGluZyB0aGUga2VybmVsIGRhdGE6IDU4MjRrClsgICAgMS44
NTA1MjJdIHVkZXZbMTA0XTogc3RhcnRpbmcgdmVyc2lvbiAxNjQKWyAgICAxLjk5NjU3Nl0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS45OTY3MDVdIFdB
Uk5JTkc6IENQVTogMCBQSUQ6IDY3IGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2tlcm5lbC9z
b2Z0aXJxLmM6MTU2IF9sb2NhbF9iaF9lbmFibGVfaXArMHgzNC8weDk3KCkKWyAgICAxLjk5
NjcwNV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS45OTY3MDVdIENQVTogMCBQSUQ6IDY3
IENvbW06IGt3b3JrZXIvdTI6MiBOb3QgdGFpbnRlZCAzLjEzLjAtcmMzLTAwMDcwLWczZjAy
ZmY1YyAjMwpbICAgIDEuOTk2NzA1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMS45OTY3MDVdIFdvcmtxdWV1ZTogZmxvcHB5IHJl
ZG9fZmRfcmVxdWVzdApbICAgIDEuOTk2NzA1XSAgYzAyNThiNTYgMDAwMDAwMDAgZDI3ODdj
ZTggYzA2NDg5NjUgZDI3ODdkMDAgYzAyMmQ2MDMgYzAyMzBkZjMgYzA0MjlkYjIKWyAgICAx
Ljk5NjcwNV0gIGQyNzUwNjM0IGQyNzg3ZDZjIGQyNzg3ZDEwIGMwMjJkNjhkIDAwMDAwMDA5
IDAwMDAwMDAwIGQyNzg3ZDFjIGMwMjMwZGYzClsgICAgMS45OTY3MDVdICBkMjc4N2Q0YyBk
Mjc4N2QyNCBjMDIzMGU2NiBkMjc4N2QzOCBjMDQyOWRiMiBkMjI2ODM2MCBkMjc1MDQwMCBk
MjczZWUwMApbICAgIDEuOTk2NzA1XSBDYWxsIFRyYWNlOgpbICAgIDEuOTk2NzA1XSAgWzxj
MDI1OGI1Nj5dID8gY29uc29sZV91bmxvY2srMHgzNTUvMHgzODIKWyAgICAxLjk5NjcwNV0g
IFs8YzA2NDg5NjU+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDEuOTk2NzA1XSAgWzxj
MDIyZDYwMz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NWYvMHg3NgpbICAgIDEuOTk2NzA1
XSAgWzxjMDIzMGRmMz5dID8gX2xvY2FsX2JoX2VuYWJsZV9pcCsweDM0LzB4OTcKWyAgICAx
Ljk5NjcwNV0gIFs8YzA0MjlkYjI+XSA/IGJsa2dfcndzdGF0X3JlYWQrMHgxZC8weDI0Clsg
ICAgMS45OTY3MDVdICBbPGMwMjJkNjhkPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTQvMHgx
OApbICAgIDEuOTk2NzA1XSAgWzxjMDIzMGRmMz5dIF9sb2NhbF9iaF9lbmFibGVfaXArMHgz
NC8weDk3ClsgICAgMS45OTY3MDVdICBbPGMwMjMwZTY2Pl0gbG9jYWxfYmhfZW5hYmxlKzB4
MTAvMHgxMgpbICAgIDEuOTk2NzA1XSAgWzxjMDQyOWRiMj5dIGJsa2dfcndzdGF0X3JlYWQr
MHgxZC8weDI0ClsgICAgMS45OTY3MDVdICBbPGMwNDJiMTA1Pl0gX19jZnFfc2V0X2FjdGl2
ZV9xdWV1ZSsweDY1LzB4MTY1ClsgICAgMS45OTY3MDVdICBbPGMwMjUzNDE3Pl0gPyBtYXJr
X2xvY2srMHgxZS8weDFkMwpbICAgIDEuOTk2NzA1XSAgWzxjMDI1MzQxNz5dID8gbWFya19s
b2NrKzB4MWUvMHgxZDMKWyAgICAxLjk5NjcwNV0gIFs8YzAyNTIyMGU+XSA/IF9fbG9ja19p
c19oZWxkKzB4MmQvMHg0MwpbICAgIDEuOTk2NzA1XSAgWzxjMDIxZDJmZD5dID8gcHZjbG9j
a19jbG9ja3NvdXJjZV9yZWFkKzB4YjEvMHhkYQpbICAgIDEuOTk2NzA1XSAgWzxjMDIxYzhh
ND5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxNC8weDFkClsgICAgMS45OTY3MDVdICBbPGMwMjA2
NDk0Pl0gPyBwYXJhdmlydF9zY2hlZF9jbG9jaysweDkvMHhkClsgICAgMS45OTY3MDVdICBb
PGMwNDJkNjg4Pl0gY2ZxX2Rpc3BhdGNoX3JlcXVlc3RzKzB4NTIxLzB4NzhhClsgICAgMS45
OTY3MDVdICBbPGMwMjUzZWU4Pl0gPyBfX2xvY2tfYWNxdWlyZSsweDUyMy8weGJkZgpbICAg
IDEuOTk2NzA1XSAgWzxjMDI1M2VlOD5dID8gX19sb2NrX2FjcXVpcmUrMHg1MjMvMHhiZGYK
WyAgICAxLjk5NjcwNV0gIFs8YzAyNTM0MTc+XSA/IG1hcmtfbG9jaysweDFlLzB4MWQzClsg
ICAgMS45OTY3MDVdICBbPGMwMjU0ODczPl0gPyBsb2NrX2FjcXVpcmUrMHhhMy8weGZjClsg
ICAgMS45OTY3MDVdICBbPGMwNGY4YzY4Pl0gPyByZWRvX2ZkX3JlcXVlc3QrMHgzZi8weGMw
YwpbICAgIDEuOTk2NzA1XSAgWzxjMDQxYTgyMD5dIGJsa19wZWVrX3JlcXVlc3QrMHg1OS8w
eDIxMQpbICAgIDEuOTk2NzA1XSAgWzxjMDQxYTllNj5dIGJsa19mZXRjaF9yZXF1ZXN0KzB4
ZS8weDFlClsgICAgMS45OTY3MDVdICBbPGMwNGY4Y2EzPl0gcmVkb19mZF9yZXF1ZXN0KzB4
N2EvMHhjMGMKWyAgICAxLjk5NjcwNV0gIFs8YzAyNDA2NTE+XSA/IHByb2Nlc3Nfb25lX3dv
cmsrMHgxM2MvMHgzOTgKWyAgICAxLjk5NjcwNV0gIFs8YzAyNDA2ZTk+XSBwcm9jZXNzX29u
ZV93b3JrKzB4MWQ0LzB4Mzk4ClsgICAgMS45OTY3MDVdICBbPGMwMjQwZjM4Pl0gd29ya2Vy
X3RocmVhZCsweDEyYi8weDFjOApbICAgIDEuOTk2NzA1XSAgWzxjMDI0MGUwZD5dID8gcmVz
Y3Vlcl90aHJlYWQrMHgxZmYvMHgxZmYKWyAgICAxLjk5NjcwNV0gIFs8YzAyNDRhNzI+XSBr
dGhyZWFkKzB4OGIvMHg5MApbICAgIDEuOTk2NzA1XSAgWzxjMDY0ZTg3Nz5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMS45OTY3MDVdICBbPGMwMjQ0OWU3Pl0g
PyBpbnNlcnRfa3RocmVhZF93b3JrKzB4NWEvMHg1YQpbICAgIDEuOTk2NzA1XSAtLS1bIGVu
ZCB0cmFjZSAwNmY0MDgwODA5YmJmMjlkIF0tLS0KWyAgICAyLjA5MDEyNl0gZW5kX3JlcXVl
c3Q6IEkvTyBlcnJvciwgZGV2IGZkMCwgc2VjdG9yIDAKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2Zm
Yi9kbWVzZy15b2N0by12cC0zMDoyMDE0MDgwMTIzMTEyNTppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNh
ODIzZmZiL2RtZXNnLXlvY3RvLXZwLTQ1OjIwMTQwODAxMjMxMTI2OmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4
ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8tdnAtMTA6MjAxNDA4MDEyMzExMzE6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQx
MjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15b2N0by12cC0xMToyMDE0MDgwMTIzMTEyODppMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3
ODdlZDEyNTcwOGQyODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTE1OjIwMTQwODAxMjMxMTMw
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1
YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1
MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8tdnAtMTg6MjAxNDA4MDEy
MzExMjg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNm
MDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMy
YzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15b2N0by12cC0xOToyMDE0
MDgwMTIzMTEzNTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3
MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAy
ZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTI1
OjIwMTQwODAxMjMxMTMzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMz
LTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8t
dnAtMjg6MjAxNDA4MDEyMzExMzA6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMu
MC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15
b2N0by12cC0yOjIwMTQwODAxMjMxMTMwOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDoz
LjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1l
c2cteW9jdG8tdnAtMzM6MjAxNDA4MDEyMzExMjg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2Zm
Yi9kbWVzZy15b2N0by12cC0zNDoyMDE0MDgwMTIzMTEzMzppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNh
ODIzZmZiL2RtZXNnLXlvY3RvLXZwLTM2OjIwMTQwODAxMjMxMTMzOmkzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4
ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8tdnAtNDI6MjAxNDA4MDEyMzExMzA6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQx
MjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15b2N0by12cC00NDoyMDE0MDgwMTIzMTEzMDppMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3
ODdlZDEyNTcwOGQyODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTQ2OjIwMTQwODAxMjMxMTMw
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1
YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1
MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8tdnAtNTU6MjAxNDA4MDEy
MzExMzA6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNm
MDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMy
YzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15b2N0by12cC01NzoyMDE0
MDgwMTIzMTEyODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3
MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAy
ZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTU4
OjIwMTQwODAxMjMxMTI4OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMz
LTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8t
dnAtNjI6MjAxNDA4MDEyMzExMzE6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMu
MC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15
b2N0by12cC02OjIwMTQwODAxMjMxMTI4OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDoz
LjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1NzA4ZDI4M2E4MjNmZmIvZG1l
c2cteW9jdG8tdnAtNzoyMDE0MDgwMTIzMTEzMTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQyODNhODIzZmZi
L2RtZXNnLXlvY3RvLXZwLTk6MjAxNDA4MDEyMzExMzM6aTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3ZWQxMjU3MDhkMjgzYTgy
M2ZmYi9kbWVzZy15b2N0by12cC0zMToyMDE0MDgwMTIzMTE0NjppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2NjY3ODdlZDEyNTcwOGQy
ODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTM5OjIwMTQwODAxMjMxMTQ1OmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAyZmY1YzozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzNmMDJmZjVjMmM2OTc1MzY2Njc4N2VkMTI1
NzA4ZDI4M2E4MjNmZmIvZG1lc2cteW9jdG8tdnAtNTk6MjAxNDA4MDEyMzExNDU6aTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTMuMC1yYzMtMDAwNzAtZzNmMDJmZjVjOjMKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvM2YwMmZmNWMyYzY5NzUzNjY2Nzg3
ZWQxMjU3MDhkMjgzYTgyM2ZmYi9kbWVzZy15b2N0by12cC0xNDoyMDE0MDgwMTIzMTIxMDpp
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMy4wLXJjMy0wMDA3MC1nM2YwMmZmNWM6
Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8zZjAyZmY1YzJjNjk3NTM2
NjY3ODdlZDEyNTcwOGQyODNhODIzZmZiL2RtZXNnLXlvY3RvLXZwLTI2OjIwMTQwODAxMjMx
MjEwOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEzLjAtcmMzLTAwMDcwLWczZjAy
ZmY1YzozCjE0OjI4OjI2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6
IDQ3MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVw
cykKWzFhYjIzMWIyNzRiYTUxYTU0YWNlYmVjMjNjNmFkZWQwZjNjZGY1NGVdIE1lcmdlIGJy
YW5jaCAndGltZXJzLXVyZ2VudC1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEy
MDoxYWIyMzFiMjc0YmE1MWE1NGFjZWJlYzIzYzZhZGVkMGYzY2RmNTRlOmJpc2VjdC1saW51
eC04CgoyMDE0LTA4LTAxLTIzOjEzOjEzIDFhYjIzMWIyNzRiYTUxYTU0YWNlYmVjMjNjNmFk
ZWQwZjNjZGY1NGUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTFhYjIzMWIyNzRi
YTUxYTU0YWNlYmVjMjNjNmFkZWQwZjNjZGY1NGUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8xYWIyMzFiMjc0YmE1MWE1NGFjZWJl
YzIzYzZhZGVkMGYzY2RmNTRlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtMWFiMjMxYjI3
NGJhNTFhNTRhY2ViZWMyM2M2YWRlZDBmM2NkZjU0ZQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0LTFhYjIzMWIyNzRiYTUxYTU0YWNlYmVjMjNjNmFkZWQwZjNjZGY1
NGUKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8xYWIyMzFi
Mjc0YmE1MWE1NGFjZWJlYzIzYzZhZGVkMGYzY2RmNTRlL3ZtbGludXotMy4xMy4wLXJjMi0w
MDEzNS1nMWFiMjMxYgoKMjAxNC0wOC0wMS0yMzoxNjoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuCTE4CTMyCTUyCTYyIFNVQ0NFU1MKCkJpc2VjdGluZzogMjYyIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNWVlNTQwNjEzZGI1MDRh
MTBlMTVmYWZhZjRjMDhjYWM5NmFhMTgyM10gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9m
IGdpdDovL2dpdC5rZXJuZWwuZGsvbGludXgtYmxvY2sKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIw
OjVlZTU0MDYxM2RiNTA0YTEwZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjM6YmlzZWN0LWxpbnV4
LTgKCjIwMTQtMDgtMDEtMjM6MTk6NDIgNWVlNTQwNjEzZGI1MDRhMTBlMTVmYWZhZjRjMDhj
YWM5NmFhMTgyMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtNWVlNTQwNjEzZGI1
MDRhMTBlMTVmYWZhZjRjMDhjYWM5NmFhMTgyMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzVlZTU0MDYxM2RiNTA0YTEwZTE1ZmFm
YWY0YzA4Y2FjOTZhYTE4MjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC01ZWU1NDA2MTNk
YjUwNGExMGUxNWZhZmFmNGMwOGNhYzk2YWExODIzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQtNWVlNTQwNjEzZGI1MDRhMTBlMTVmYWZhZjRjMDhjYWM5
NmFhMTgyMwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzVl
ZTU0MDYxM2RiNTA0YTEwZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjMvdm1saW51ei0zLjEzLjAt
cmMyLTAwMjQ5LWc1ZWU1NDA2CgoyMDE0LTA4LTAxLTIzOjMxOjU2IGRldGVjdGluZyBib290
IHN0YXRlIAk3IFRFU1QgRkFJTFVSRQpbICAgIDMuMjg2NjA3XSByYW5kb206IGluaXQgdXJh
bmRvbSByZWFkIHdpdGggMTUgYml0cyBvZiBlbnRyb3B5IGF2YWlsYWJsZQpbICAgIDMuNDA3
MTk5XSBtb3VudGFsbCAoMTIxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2Mjk2IGJ5
dGVzIGxlZnQKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDM1CnFlbXUt
c3lzdGVtLXg4Nl82NCAtZW5hYmxlLWt2bSAtY3B1IEhhc3dlbGwsK3NtZXAsK3NtYXAgLWtl
cm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC81ZWU1NDA2MTNkYjUw
NGExMGUxNWZhZmFmNGMwOGNhYzk2YWExODIzL3ZtbGludXotMy4xMy4wLXJjMi0wMDI0OS1n
NWVlNTQwNiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwx
MTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBu
bWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUy
MDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEyMDo1ZWU1NDA2MTNkYjUwNGExMGUx
NWZhZmFmNGMwOGNhYzk2YWExODIzOmJpc2VjdC1saW51eC04Ly52bWxpbnV6LTVlZTU0MDYx
M2RiNTA0YTEwZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjMtMjAxNDA4MDEyMzMwNTUtMi1rYnVp
bGQgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDgwMTIwIEJPT1RfSU1B
R0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNWVlNTQwNjEzZGI1MDRh
MTBlMTVmYWZhZjRjMDhjYWM5NmFhMTgyMy92bWxpbnV6LTMuMTMuMC1yYzItMDAyNDktZzVl
ZTU0MDYgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRy
ZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEs
bW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290
IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYv
c2htL2tib290L3BpZC1xdWFudGFsLWtidWlsZC0xNSAtc2VyaWFsIGZpbGU6L2Rldi9zaG0v
a2Jvb3Qvc2VyaWFsLXF1YW50YWwta2J1aWxkLTE1IC1kYWVtb25pemUgLWRpc3BsYXkgbm9u
ZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC81
ZWU1NDA2MTNkYjUwNGExMGUxNWZhZmFmNGMwOGNhYzk2YWExODIzL2RtZXNnLXlvY3RvLWti
dWlsZC03OjIwMTQwODAxMjMzMDA3OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEz
LjAtcmMyLTAwMjQ5LWc1ZWU1NDA2OjQKMzoxOjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDgtMDEgMjM6MzI6MzAgUkVQRUFUIENPVU5UOiA5MCAgIyAvYy9i
b290LWJpc2VjdC9saW51eC04L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzog
MTQ4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBz
KQpbNTNjNmRlNTAyNjJhOGVkZDY5MzJiYjU5YTMyZGI3YjlkOTJmOGQ2N10gTWVyZ2UgYnJh
bmNoICd4ODYvdXJnZW50JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOC9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODAxMjA6NTNjNmRlNTAyNjJh
OGVkZDY5MzJiYjU5YTMyZGI3YjlkOTJmOGQ2NzpiaXNlY3QtbGludXgtOAoKMjAxNC0wOC0w
MS0yMzozMjozMSA1M2M2ZGU1MDI2MmE4ZWRkNjkzMmJiNTlhMzJkYjdiOWQ5MmY4ZDY3IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC01M2M2ZGU1MDI2MmE4ZWRkNjkzMmJiNTlh
MzJkYjdiOWQ5MmY4ZDY3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvNTNjNmRlNTAyNjJhOGVkZDY5MzJiYjU5YTMyZGI3YjlkOTJm
OGQ2Nwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTUzYzZkZTUwMjYyYThlZGQ2OTMyYmI1
OWEzMmRiN2I5ZDkyZjhkNjcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC01M2M2ZGU1MDI2MmE4ZWRkNjkzMmJiNTlhMzJkYjdiOWQ5MmY4ZDY3Cmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNTNjNmRlNTAyNjJhOGVk
ZDY5MzJiYjU5YTMyZGI3YjlkOTJmOGQ2Ny92bWxpbnV6LTMuMTMuMC1yYzItMDAyMDktZzUz
YzZkZTUKCjIwMTQtMDgtMDEtMjM6MzU6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk0Li4J
MzcJNTAJNzAJOTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA2OCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzU5ZmIyZjBlOWUzMGFkOTlhOGJh
YjBmZjFlZmFmOGY0YTNiNzEwNWZdIE1lcmdlIHRhZyAnZmJkZXYtZml4ZXMtMy4xMycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvbWJhL2xp
bnV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDA4MDEyMDo1OWZiMmYwZTllMzBhZDk5YThiYWIwZmYxZWZh
ZjhmNGEzYjcxMDVmOmJpc2VjdC1saW51eC04CgoyMDE0LTA4LTAxLTIzOjM5OjUzIDU5ZmIy
ZjBlOWUzMGFkOTlhOGJhYjBmZjFlZmFmOGY0YTNiNzEwNWYgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0LTU5ZmIyZjBlOWUzMGFkOTlhOGJhYjBmZjFlZmFmOGY0YTNiNzEwNWYK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEy
NC81OWZiMmYwZTllMzBhZDk5YThiYWIwZmYxZWZhZjhmNGEzYjcxMDVmCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQtNTlmYjJmMGU5ZTMwYWQ5OWE4YmFiMGZmMWVmYWY4ZjRhM2I3MTA1
Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
Y2Fpcm8tc21va2UvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTU5ZmIyZjBlOWUzMGFk
OTlhOGJhYjBmZjFlZmFmOGY0YTNiNzEwNWYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNC81OWZiMmYwZTllMzBhZDk5YThiYWIwZmYxZWZhZjhmNGEzYjcx
MDVmL3ZtbGludXotMy4xMy4wLXJjMi0wMDI2My1nNTlmYjJmMAoKMjAxNC0wOC0wMi0wMDow
ODo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTUJMTgJNDIuCTcwCTkwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDUgc3RlcHMpCltlZjFlNGUzMmQ1OTVkM2U2YzlhNmQzZDI5NTZmMDg3ZDU4ODZjNWU1XSBN
ZXJnZSB0YWcgJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L21hc29uL2xpbnV4LWJ0cmZzCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEy
MDplZjFlNGUzMmQ1OTVkM2U2YzlhNmQzZDI5NTZmMDg3ZDU4ODZjNWU1OmJpc2VjdC1saW51
eC04CgoyMDE0LTA4LTAyLTAwOjEyOjIzIGVmMWU0ZTMyZDU5NWQzZTZjOWE2ZDNkMjk1NmYw
ODdkNTg4NmM1ZTUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LWVmMWU0ZTMyZDU5
NWQzZTZjOWE2ZDNkMjk1NmYwODdkNTg4NmM1ZTUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lZjFlNGUzMmQ1OTVkM2U2YzlhNmQz
ZDI5NTZmMDg3ZDU4ODZjNWU1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtZWYxZTRlMzJk
NTk1ZDNlNmM5YTZkM2QyOTU2ZjA4N2Q1ODg2YzVlNQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0LWVmMWU0ZTMyZDU5NWQzZTZjOWE2ZDNkMjk1NmYwODdkNTg4NmM1
ZTUKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lZjFlNGUz
MmQ1OTVkM2U2YzlhNmQzZDI5NTZmMDg3ZDU4ODZjNWU1L3ZtbGludXotMy4xMy4wLXJjMi0w
MDI2NS1nZWYxZTRlMwoKMjAxNC0wOC0wMi0wMDo1NjoyMyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkzNAk1MQk3MQk4Mgk5MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE4IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbMjliZTYzNDViYmFl
Yzg1MDJhNzBjNGUyMjA0ZDU4MThiNDhjNGU4Zl0gTWVyZ2UgdGFnICduZnMtZm9yLTMuMTMt
Mycgb2YgZ2l0Oi8vZ2l0LmxpbnV4LW5mcy5vcmcvcHJvamVjdHMvdHJvbmRteS9saW51eC1u
ZnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjI5YmU2MzQ1YmJhZWM4NTAyYTcwYzRlMjIwNGQ1
ODE4YjQ4YzRlOGY6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDItMDE6MDA6MDQgMjliZTYz
NDViYmFlYzg1MDJhNzBjNGUyMjA0ZDU4MThiNDhjNGU4ZiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQtMjliZTYzNDViYmFlYzg1MDJhNzBjNGUyMjA0ZDU4MThiNDhjNGU4ZgpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
LzI5YmU2MzQ1YmJhZWM4NTAyYTcwYzRlMjIwNGQ1ODE4YjQ4YzRlOGYKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC0yOWJlNjM0NWJiYWVjODUwMmE3MGM0ZTIyMDRkNTgxOGI0OGM0ZThm
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9j
YWlyby1zbW9rZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtMjliZTYzNDViYmFlYzg1
MDJhNzBjNGUyMjA0ZDU4MThiNDhjNGU4ZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0LzI5YmU2MzQ1YmJhZWM4NTAyYTcwYzRlMjIwNGQ1ODE4YjQ4YzRl
OGYvdm1saW51ei0zLjEzLjAtcmMyLTAwMjc1LWcyOWJlNjM0CgoyMDE0LTA4LTAyLTAxOjA2
OjA0IGRldGVjdGluZyBib290IHN0YXRlIC4JMjMJMzYJNTIJOTAgU1VDQ0VTUwoKbGluZWFy
LWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDov
L2dpdC5rZXJuZWwuZGsvbGludXgtYmxvY2sKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIg
dG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDVlZTU0MDYx
M2RiNTA0YTEwZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjMgMjliZTYzNDViYmFlYzg1MDJhNzBj
NGUyMjA0ZDU4MThiNDhjNGU4ZiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyOWJl
NjM0Li4uIE1lcmdlIHRhZyAnbmZzLWZvci0zLjEzLTMnIG9mIGdpdDovL2dpdC5saW51eC1u
ZnMub3JnL3Byb2plY3RzL3Ryb25kbXkvbGludXgtbmZzCkhFQUQgaXMgbm93IGF0IGI0ZDMz
MTguLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnY3J5cHRvL21hc3RlcicKQmlz
ZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAy
IHN0ZXBzKQpbZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NV0gTWVy
Z2UgYnJhbmNoICdzdGFibGUvZm9yLWplbnMtMy4xMy10YWtlLXR3bycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3hlbi90aXAgaW50byBmb3It
bGludXMKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1i
aXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOmUzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdl
YTI0ODA3MmE5YzY5NzU6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDItMDE6MTM6MDMgZTM0
NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQtZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3
NQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNC1lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2
OTc1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9qYWtldG93bi1jb25zdW1lci9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtZTM0NWQ3
NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NQprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0
ODA3MmE5YzY5NzUvdm1saW51ei0zLjEyLjAtMDI3OTktZ2UzNDVkNzYKCjIwMTQtMDgtMDIt
MDE6Mzc6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzMSBURVNUIEZBSUxVUkUKWyAgICAy
LjQwMDIxMl0gTlgtcHJvdGVjdGluZyB0aGUga2VybmVsIGRhdGE6IDU4MzJrClsgICAgMi40
NTUwNDFdIHVkZXZbMTIyXTogc3RhcnRpbmcgdmVyc2lvbiAxNjQKWyAgICAyLjc1Njc5OV0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi43NTgwMDFdIFdB
Uk5JTkc6IENQVTogMCBQSUQ6IDg1IGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2tlcm5lbC9z
b2Z0aXJxLmM6MTU2IF9sb2NhbF9iaF9lbmFibGVfaXArMHgzNC8weDk3KCkKWyAgICAyLjc2
MDA1OF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMi43NjAwNThdIENQVTogMCBQSUQ6IDg1
IENvbW06IGt3b3JrZXIvdTI6MiBOb3QgdGFpbnRlZCAzLjEyLjAtMDI3OTktZ2UzNDVkNzYg
IzYKWyAgICAyLjc2MDA1OF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgIDIuNzYwMDU4XSBXb3JrcXVldWU6IGZsb3BweSByZWRvX2Zk
X3JlcXVlc3QKWyAgICAyLjc2MDA1OF0gIGMwMjU4YmNhIDAwMDAwMDAwIGQyNzdiY2U4IGMw
NjQ2Y2M2IGQyNzdiZDAwIGMwMjJkNzkzIGMwMjMwZjRkIGMwNDI5NmNjClsgICAgMi43NjAw
NThdICBkMjc0NjYzNCBkMjc3YmQ2YyBkMjc3YmQxMCBjMDIyZDgxZCAwMDAwMDAwOSAwMDAw
MDAwMCBkMjc3YmQxYyBjMDIzMGY0ZApbICAgIDIuNzYwMDU4XSAgZDI3N2JkNGMgZDI3N2Jk
MjQgYzAyMzBmYzAgZDI3N2JkMzggYzA0Mjk2Y2MgZDIwZTVkODAgZDI3NDY0MDAgZDI3NDNj
MDAKWyAgICAyLjc2MDA1OF0gQ2FsbCBUcmFjZToKWyAgICAyLjc2MDA1OF0gIFs8YzAyNThi
Y2E+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MzU1LzB4MzgyClsgICAgMi43NjAwNThdICBbPGMw
NjQ2Y2M2Pl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAyLjc2MDA1OF0gIFs8YzAyMmQ3
OTM+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDVmLzB4NzYKWyAgICAyLjc2MDA1OF0gIFs8
YzAyMzBmNGQ+XSA/IF9sb2NhbF9iaF9lbmFibGVfaXArMHgzNC8weDk3ClsgICAgMi43NjAw
NThdICBbPGMwNDI5NmNjPl0gPyBibGtnX3J3c3RhdF9yZWFkKzB4MWQvMHgyNApbICAgIDIu
NzYwMDU4XSAgWzxjMDIyZDgxZD5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE0LzB4MTgKWyAg
ICAyLjc2MDA1OF0gIFs8YzAyMzBmNGQ+XSBfbG9jYWxfYmhfZW5hYmxlX2lwKzB4MzQvMHg5
NwpbICAgIDIuNzYwMDU4XSAgWzxjMDIzMGZjMD5dIGxvY2FsX2JoX2VuYWJsZSsweDEwLzB4
MTIKWyAgICAyLjc2MDA1OF0gIFs8YzA0Mjk2Y2M+XSBibGtnX3J3c3RhdF9yZWFkKzB4MWQv
MHgyNApbICAgIDIuNzYwMDU4XSAgWzxjMDQyYWExZj5dIF9fY2ZxX3NldF9hY3RpdmVfcXVl
dWUrMHg2NS8weDE2NQpbICAgIDIuNzYwMDU4XSAgWzxjMDI1MzQ4Yj5dID8gbWFya19sb2Nr
KzB4MWUvMHgxZDMKWyAgICAyLjc2MDA1OF0gIFs8YzAyNTM0OGI+XSA/IG1hcmtfbG9jaysw
eDFlLzB4MWQzClsgICAgMi43NjAwNThdICBbPGMwMjUyMTMyPl0gPyBfX2xvY2tfaXNfaGVs
ZCsweDJkLzB4NDMKWyAgICAyLjc2MDA1OF0gIFs8YzAyMWQyZTE+XSA/IHB2Y2xvY2tfY2xv
Y2tzb3VyY2VfcmVhZCsweGIxLzB4ZGEKWyAgICAyLjc2MDA1OF0gIFs8YzAyNTIxOGE+XSA/
IGxvY2tfaXNfaGVsZCsweDQyLzB4NTAKWyAgICAyLjc2MDA1OF0gIFs8YzA0MmNmYTI+XSBj
ZnFfZGlzcGF0Y2hfcmVxdWVzdHMrMHg1MjEvMHg3OGEKWyAgICAyLjc2MDA1OF0gIFs8YzAy
NTNmNWM+XSA/IF9fbG9ja19hY3F1aXJlKzB4NTIzLzB4YmRmClsgICAgMi43NjAwNThdICBb
PGMwMjUxYzFjPl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHhiLzB4ZApbICAgIDIuNzYwMDU4
XSAgWzxjMDI1M2Y1Yz5dID8gX19sb2NrX2FjcXVpcmUrMHg1MjMvMHhiZGYKWyAgICAyLjc2
MDA1OF0gIFs8YzAyNTM0OGI+XSA/IG1hcmtfbG9jaysweDFlLzB4MWQzClsgICAgMi43NjAw
NThdICBbPGMwMjU0OGU3Pl0gPyBsb2NrX2FjcXVpcmUrMHhhMy8weGZjClsgICAgMi43NjAw
NThdICBbPGMwNGY3MmI1Pl0gPyByZWRvX2ZkX3JlcXVlc3QrMHgzZi8weGMwYwpbICAgIDIu
NzYwMDU4XSAgWzxjMDQxYTE0ND5dIGJsa19wZWVrX3JlcXVlc3QrMHg1OS8weDIxMQpbICAg
IDIuNzYwMDU4XSAgWzxjMDQxYTMwYT5dIGJsa19mZXRjaF9yZXF1ZXN0KzB4ZS8weDFlClsg
ICAgMi43NjAwNThdICBbPGMwNGY3MmYwPl0gcmVkb19mZF9yZXF1ZXN0KzB4N2EvMHhjMGMK
WyAgICAyLjc2MDA1OF0gIFs8YzAyNDA3YWI+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxM2Mv
MHgzOTgKWyAgICAyLjc2MDA1OF0gIFs8YzAyNDA4NDM+XSBwcm9jZXNzX29uZV93b3JrKzB4
MWQ0LzB4Mzk4ClsgICAgMi43NjAwNThdICBbPGMwMjQxMDkyPl0gd29ya2VyX3RocmVhZCsw
eDEyYi8weDFjOApbICAgIDIuNzYwMDU4XSAgWzxjMDI0MGY2Nz5dID8gcmVzY3Vlcl90aHJl
YWQrMHgxZmYvMHgxZmYKWyAgICAyLjc2MDA1OF0gIFs8YzAyNDRiNzk+XSBrdGhyZWFkKzB4
OGIvMHg5MApbICAgIDIuNzYwMDU4XSAgWzxjMDY0Y2I3Nz5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgxYi8weDI4ClsgICAgMi43NjAwNThdICBbPGMwMjQ0YWVlPl0gPyBpbnNlcnRf
a3RocmVhZF93b3JrKzB4NWEvMHg1YQpbICAgIDIuNzYwMDU4XSAtLS1bIGVuZCB0cmFjZSAw
MDA1MmIzZWNhMGU1OGE3IF0tLS0KWyAgICAyLjg4MzU2N10gZW5kX3JlcXVlc3Q6IEkvTyBl
cnJvciwgZGV2IGZkMCwgc2VjdG9yIDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15
b2N0by1rYnVpbGQtMTA6MjAxNDA4MDIwMTM1MTY6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjMuMTIuMC0wMjc5OS1nZTM0NWQ3Njo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUvZG1l
c2cteW9jdG8ta2J1aWxkLTExOjIwMTQwODAyMDEzNTE3OmkzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2OTc1
L2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDgwMjAxMzUxNTppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTlj
Njk3NS9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA4MDIwMTM1MTU6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0wMjc5OS1nZTM0NWQ3Njo2Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA4MDEyMTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3
MmE5YzY5NzUvZG1lc2cteW9jdG8ta2J1aWxkLTE1OjIwMTQwODAyMDEzNTE3OmkzODYtcmFu
ZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6Ngova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEy
NDgwNzJhOWM2OTc1L2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDgwMjAxMzUxNjppMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFi
N2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA4MDIwMTM1MTc6
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0wMjc5OS1nZTM0NWQ3Njo2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBh
YWJhYjdlYTI0ODA3MmE5YzY5NzUvZG1lc2cteW9jdG8ta2J1aWxkLTE5OjIwMTQwODAyMDEz
NTE4OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6
Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5
Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2OTc1L2RtZXNnLXlvY3RvLWtidWlsZC0yMDoyMDE0MDgw
MjAxMzUxNzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtMjI6MjAx
NDA4MDIwMTM1MTg6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0wMjc5OS1n
ZTM0NWQ3Njo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2UzNDVkNzY3
ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUvZG1lc2cteW9jdG8ta2J1aWxkLTI0
OjIwMTQwODAyMDEzNTE5OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMDI3
OTktZ2UzNDVkNzY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lMzQ1
ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2OTc1L2RtZXNnLXlvY3RvLWtidWls
ZC0yNToyMDE0MDgwMjAxMzUxODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4w
LTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQv
ZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by1r
YnVpbGQtMjY6MjAxNDA4MDIwMTM1MjA6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMu
MTIuMC0wMjc5OS1nZTM0NWQ3Njo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUvZG1lc2cteW9j
dG8ta2J1aWxkLTI5OjIwMTQwODAyMDEzNTIwOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEy
NDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2OTc1L2RtZXNn
LXlvY3RvLWtidWlsZC0yOjIwMTQwODAyMDEzNTE1OmkzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEyNDgwNzJhOWM2OTc1L2Rt
ZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDgwMjAxMzUxNjppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3
NS9kbWVzZy15b2N0by1rYnVpbGQtMzoyMDE0MDgwMjAxMzUxNTppMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTlj
Njk3NS9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDgwMjAxMzUxNjppMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcy
YTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtNzoyMDE0MDgwMjAxMzUxNTppMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2VhMjQ4
MDcyYTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0MDgwMjAxMzUxNzppMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2OjYKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVjOWNiMGFhYmFiN2Vh
MjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtMjM6MjAxNDA4MDIwMTM1MjE6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0wMjc5OS1nZTM0NWQ3Njo2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJh
YjdlYTI0ODA3MmE5YzY5NzUvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwODAyMDEzNTIw
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMDI3OTktZ2UzNDVkNzY6Ngov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2Iw
YWFiYWI3ZWEyNDgwNzJhOWM2OTc1L2RtZXNnLXlvY3RvLWtidWlsZC0zMjoyMDE0MDgwMjAx
MzUyMzppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1ZDc2
OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUzMGVj
OWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by1rYnVpbGQtNDoyMDE0MDgw
MjAxMzUyMDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC0xNzoyMDE0MDgw
MjAxMzgxNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC0yNzoyMDE0MDgw
MjAxMzgxNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC00MDoyMDE0MDgw
MjAxMzgxNDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC0xMzoyMDE0MDgw
MjAxMzgxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC0xODoyMDE0MDgw
MjAxMzgxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC0yOToyMDE0MDgw
MjAxMzgxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC00NzoyMDE0MDgw
MjAxMzgxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvZTM0NWQ3NjdmNjUz
MGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy15b2N0by12cC02MzoyMDE0MDgw
MjAxMzgxOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTAyNzk5LWdlMzQ1
ZDc2OjYKMzE6MzI6MzIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzog
MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpb
YzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlN10gYmxvY2s6IHN1Ym1p
dF9iaW9fd2FpdCgpIGNvbnZlcnNpb25zCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1j
MS0wODAxMjEyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MDEyMDpjMTcwYmJi
NDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3OmJpc2VjdC1saW51eC04CgoyMDE0
LTA4LTAyLTAxOjM4OjA1IGMxNzBiYmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEwNGI3
ZTcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LWMxNzBiYmI0NWZlYmMwM2FjNGQz
NGJhMmI4YmI1NWUwNjEwNGI3ZTcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVl
MDYxMDRiN2U3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtYzE3MGJiYjQ1ZmViYzAzYWM0
ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0LWMxNzBiYmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEwNGI3ZTcKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNh
YzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L3ZtbGludXotMy4xMi4wLTEwODc5LWdjMTcwYmJi
CgoyMDE0LTA4LTAyLTAxOjQyOjA3IGRldGVjdGluZyBib290IHN0YXRlIC4JNAkyOCBURVNU
IEZBSUxVUkUKWyAgICAzLjY0MzM3NV0gQ0U6IGhwZXQgaW5jcmVhc2VkIG1pbl9kZWx0YV9u
cyB0byAxMTI1MCBuc2VjClsgICAgMy42NDMzNzVdIENFOiBocGV0IGluY3JlYXNlZCBtaW5f
ZGVsdGFfbnMgdG8gMTY4NzUgbnNlYwpbICAgIDMuNzM1NDg0XSBtb3VudGFsbCAoMTAzKSB1
c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2Mjk2IGJ5dGVzIGxlZnQKWyAgIDE0Ljg3MjEx
N10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVu
Y2UgYXQgICAobnVsbCkKWyAgIDE0Ljg3MzI0OV0gSVA6IFs8YzA0Mzc5OWQ+XSBzdHJsZW4r
MHgxMC8weDFjClsgICAxNC44NzMzNjddICpwZHB0ID0gMDAwMDAwMDAxMzlhNjAwMSAqcGRl
ID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE0Ljg3MzM2N10gT29wczogMDAwMCBbIzFdIApb
ICAgMTQuODczMzY3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDE0Ljg3MzM2N10gQ1BVOiAw
IFBJRDogMTQyIENvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjEyLjAtMTA4Nzkt
Z2MxNzBiYmIgIzEKWyAgIDE0Ljg3MzM2N10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTQuODczMzY3XSB0YXNrOiBkMzgxNTc4MCB0
aTogZDM5NjAwMDAgdGFzay50aTogZDM5NjAwMDAKWyAgIDE0Ljg3MzM2N10gRUlQOiAwMDYw
Ols8YzA0Mzc5OWQ+XSBFRkxBR1M6IDAwMDEwMDQ2IENQVTogMApbICAgMTQuODczMzY3XSBF
SVAgaXMgYXQgc3RybGVuKzB4MTAvMHgxYwpbICAgMTQuODczMzY3XSBFQVg6IDAwMDAwMDAw
IEVCWDogYzBmMTI2OWMgRUNYOiBmZmZmZmZmZiBFRFg6IGMwZjEyNjljClsgICAxNC44NzMz
NjddIEVTSTogYzBmMTI2OWMgRURJOiAwMDAwMDAwMCBFQlA6IGQzOTYxZGRjIEVTUDogZDM5
NjFkZDgKWyAgIDE0Ljg3MzM2N10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAw
MDMzIFNTOiAwMDY4ClsgICAxNC44NzMzNjddIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAw
MCBDUjM6IDEzOWMyMDAwIENSNDogMDAwMDA2YjAKWyAgIDE0Ljg3MzM2N10gU3RhY2s6Clsg
ICAxNC44NzMzNjddICBjMDkwODdkMCBkMzk2MWU0MCBjMDI1Mjc4NyAwMDAwMDAwYSBlNDU3
MDAxYSBjMGMzODA1NCAwMDAwMDAwMCBkMzk2MWQ5OApbICAgMTQuODczMzY3XSAgMDAwMDAw
MDAgYzAyNTM0OGIgMDAwMDAwMDAgMDAwMDAwMDAgZDM4MTU3ODAgMDAwMDAwMDAgMDAwMDAw
MDIgZDM4MTVhZTQKWyAgIDE0Ljg3MzM2N10gIDAwMDAwMDQ2IGQzODE1NzgwIDAwMDAwMDQ2
IDAwMDAwMDQ2IGQzOTYxZTVjIGMwMjU0OGU3IDAwMDAwMDAyIGNjY2JkYWM4ClsgICAxNC44
NzMzNjddIENhbGwgVHJhY2U6ClsgICAxNC44NzMzNjddICBbPGMwMjUyNzg3Pl0gcGVyZl90
cmFjZV9sb2NrKzB4MTUvMHg5OQpbICAgMTQuODczMzY3XSAgWzxjMDI1MzQ4Yj5dID8gbWFy
a19sb2NrKzB4MWUvMHgxZDMKWyAgIDE0Ljg3MzM2N10gIFs8YzAyNTQ4ZTc+XSA/IGxvY2tf
YWNxdWlyZSsweGEzLzB4ZmMKWyAgIDE0Ljg3MzM2N10gIFs8YzAyNjBjZjQ+XSA/IGN1cnJl
bnRfa2VybmVsX3RpbWUrMHhlLzB4MjAKWyAgIDE0Ljg3MzM2N10gIFs8YzAyNTRjZTM+XSBs
b2NrX3JlbGVhc2UrMHgxYjgvMHgxZGYKWyAgIDE0Ljg3MzM2N10gIFs8YzAyNjA4YjY+XSBy
ZWFkX3NlcWNvdW50X2JlZ2luLmNvbnN0cHJvcC4yNisweDM5LzB4NmQKWyAgIDE0Ljg3MzM2
N10gIFs8YzAyNjBjZjQ+XSA/IGN1cnJlbnRfa2VybmVsX3RpbWUrMHhlLzB4MjAKWyAgIDE0
Ljg3MzM2N10gIFs8YzAyNjBjZjQ+XSBjdXJyZW50X2tlcm5lbF90aW1lKzB4ZS8weDIwClsg
ICAxNC44NzMzNjddICBbPGMwMjMwMTZjPl0gY3VycmVudF9mc190aW1lKzB4MTAvMHgxZQpb
ICAgMTQuODczMzY3XSAgWzxjMDJkZjY3MD5dIGZpbGVfdXBkYXRlX3RpbWUrMHgyYS8weDhl
ClsgICAxNC44NzMzNjddICBbPGMwMjk5NzRlPl0gX19nZW5lcmljX2ZpbGVfYWlvX3dyaXRl
KzB4YzMvMHgxZGIKWyAgIDE0Ljg3MzM2N10gIFs8YzAyOTk4YmU+XSBnZW5lcmljX2ZpbGVf
YWlvX3dyaXRlKzB4NTgvMHg4OQpbICAgMTQuODczMzY3XSAgWzxjMDJjYzZkYz5dIGRvX3N5
bmNfd3JpdGUrMHg1MS8weDc4ClsgICAxNC44NzMzNjddICBbPGMwMmNjNjhiPl0gPyBmZHB1
dCsweGUvMHhlClsgICAxNC44NzMzNjddICBbPGMwMmNjZDFmPl0gdmZzX3dyaXRlKzB4NzYv
MHhiOApbICAgMTQuODczMzY3XSAgWzxjMDJjZDA5OD5dIFN5U193cml0ZSsweDQzLzB4NzAK
WyAgIDE0Ljg3MzM2N10gIFs8YzA2NGM2MDg+XSBzeXNjYWxsX2NhbGwrMHg3LzB4YgpbICAg
MTQuODczMzY3XSBDb2RlOiAwMCA4OSBjNiA4OSBkMCA4OCBjNCBhYyAzOCBlMCA3NCAwOSA4
NCBjMCA3NSBmNyBiZSAwMSAwMCAwMCAwMCA4OSBmMCA0OCA1ZSA1ZCBjMyA1NSA4OSBlNSA1
NyAzZSA4ZCA3NCAyNiAwMCA4MyBjOSBmZiA4OSBjNyAzMSBjMCA8ZjI+IGFlIGI4IGZlIGZm
IGZmIGZmIDI5IGM4IDVmIDVkIGMzIDU1IDg5IGU1IDU3IDNlIDhkIDc0IDI2IDAwClsgICAx
NC44NzMzNjddIEVJUDogWzxjMDQzNzk5ZD5dIHN0cmxlbisweDEwLzB4MWMgU1M6RVNQIDAw
Njg6ZDM5NjFkZDgKWyAgIDE0Ljg3MzM2N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAx
NC44NzMzNjddIC0tLVsgZW5kIHRyYWNlIGViNWU4YmRiZTE1YTk0NjQgXS0tLQpbICAgMTQu
ODczMzY3XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29u
dGV4dCBhdCAva2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwvbG9ja2luZy9yd3NlbS5jOjIwCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2MxNzBiYmI0NWZlYmMwM2FjNGQz
NGJhMmI4YmI1NWUwNjEwNGI3ZTcvZG1lc2cteW9jdG8ta2J1aWxkLTMxOjIwMTQwODAyMDE0
MDUyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzktZ2MxNzBiYmI6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNh
YzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXlvY3RvLWtidWlsZC00OjIwMTQwODAy
MDE0MDUyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzktZ2MxNzBi
YmI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJj
MDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0
MDgwMjAxNDEwODppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTEwODc5LWdj
MTcwYmJiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1
ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0by1rYnVpbGQtMTI6
MjAxNDA4MDIwMTQxMDk6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0xMDg3
OS1nYzE3MGJiYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2MxNzBi
YmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEwNGI3ZTcvZG1lc2cteW9jdG8ta2J1aWxk
LTIxOjIwMTQwODAyMDE0MTA1OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAt
MTA4NzktZ2MxNzBiYmI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9j
MTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXlvY3RvLWti
dWlsZC0yMjoyMDE0MDgwMjAxNDEwOTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4x
Mi4wLTEwODc5LWdjMTcwYmJiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQvYzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0
by1rYnVpbGQtMzI6MjAxNDA4MDIwMTQxMDk6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0
OjMuMTIuMC0xMDg3OS1nYzE3MGJiYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0L2MxNzBiYmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEwNGI3ZTcvZG1lc2ct
eW9jdG8ta2J1aWxkLTE1OjIwMTQwODAyMDE0MTIyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNDozLjEyLjAtMTA4NzktZ2MxNzBiYmI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2Rt
ZXNnLXlvY3RvLWtidWlsZC0yMDoyMDE0MDgwMjAxNDEyMDppMzg2LXJhbmRjb25maWctYzEt
MDgwMTIxMjQ6My4xMi4wLTEwODc5LWdjMTcwYmJiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0Yjdl
Ny9kbWVzZy15b2N0by1rYnVpbGQtMjM6MjAxNDA4MDIwMTQxMjM6aTM4Ni1yYW5kY29uZmln
LWMxLTA4MDEyMTI0OjMuMTIuMC0xMDg3OS1nYzE3MGJiYjoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0L2MxNzBiYmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEw
NGI3ZTcvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwODAyMDE0MTIwOmkzODYtcmFuZGNv
bmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzktZ2MxNzBiYmI6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVl
MDYxMDRiN2U3L2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDgwMjAxNDEyMDppMzg2LXJh
bmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTEwODc5LWdjMTcwYmJiOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhi
YjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA4MDIwMTQxMjE6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0xMDg3OS1nYzE3MGJiYjoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2MxNzBiYmI0NWZlYmMwM2FjNGQzNGJh
MmI4YmI1NWUwNjEwNGI3ZTcvZG1lc2cteW9jdG8ta2J1aWxkLTI5OjIwMTQwODAyMDE0MTIw
OmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzktZ2MxNzBiYmI6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9jMTcwYmJiNDVmZWJjMDNhYzRk
MzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDgwMjAx
NDEyMTppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTEwODc5LWdjMTcwYmJi
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1ZmViYzAz
YWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0by1rYnVpbGQtNzoyMDE0MDgw
MjAxNDEyMDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTEwODc5LWdjMTcw
YmJiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1ZmVi
YzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0
MDgwMjAxNDEyMDppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xMi4wLTEwODc5LWdj
MTcwYmJiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvYzE3MGJiYjQ1
ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy15b2N0by1rYnVpbGQtMTg6
MjAxNDA4MDIwMTQxMjM6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0xMDg3
OS1nYzE3MGJiYjoxCjI3OjE4OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNl
Y3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAg
c3RlcHMpClsyYzU3NTAyNmZhZTZlNjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5XSBVcGRh
dGUgb2YgYmxrZ19zdGF0IGFuZCBibGtnX3J3c3RhdCBtYXkgaGFwcGVuIGluIGJoIGNvbnRl
eHQuIFdoaWxlIHU2NF9zdGF0c19mZXRjaF9yZXRyeSBpcyBvbmx5IHByZWVtcHRfZGlzYWJs
ZSBvbiAzMmJpdCBVUCBzeXN0ZW0uIFRoaXMgaXMgbm90IGVub3VnaCB0byBhdm9pZCBwcmVl
bXB0aW9uIGJ5IGJoIGFuZCBtYXkgcmVhZCBzdHJhbmdlIDY0IGJpdCB2YWx1ZS4KcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDgwMTIwOjJjNTc1MDI2ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZh
ODk6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMDItMDE6NDQ6MTIgMmM1NzUwMjZmYWU2ZTYz
NzcxYmQyYTRjMWQ0MDcyMTRhODA5NmE4OSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIx
MjQtMmM1NzUwMjZmYWU2ZTYzNzcxYmQyYTRjMWQ0MDcyMTRhODA5NmE4OQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzJjNTc1MDI2
ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODkKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC0yYzU3NTAyNmZhZTZlNjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby1zbW9r
ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtMmM1NzUwMjZmYWU2ZTYzNzcxYmQyYTRj
MWQ0MDcyMTRhODA5NmE4OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4
MDEyMTI0LzJjNTc1MDI2ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODkvdm1saW51
ei0zLjEyLjAtMTA4NzgtZzJjNTc1MDIKCjIwMTQtMDgtMDItMDI6MDQ6MjAgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgCTYgVEVTVCBGQUlMVVJFClsgICAgMi40NzAzMTBdIE5YLXByb3RlY3Rp
bmcgdGhlIGtlcm5lbCBkYXRhOiA1ODMyawpbICAgIDIuNTIyMTMyXSB1ZGV2WzEwNF06IHN0
YXJ0aW5nIHZlcnNpb24gMTY0ClsgICAgMi43NDA3OTldIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDIuNzQyMDQ1XSBXQVJOSU5HOiBDUFU6IDAgUElEOiA2
NyBhdCAva2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwvc29mdGlycS5jOjE1NiBfbG9jYWxfYmhf
ZW5hYmxlX2lwKzB4MzQvMHg5NygpClsgICAgMi43NDMzNzhdIE1vZHVsZXMgbGlua2VkIGlu
OgpbICAgIDIuNzQzMzc4XSBDUFU6IDAgUElEOiA2NyBDb21tOiBrd29ya2VyL3UyOjIgTm90
IHRhaW50ZWQgMy4xMi4wLTEwODc4LWcyYzU3NTAyICMxClsgICAgMi43NDMzNzhdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjc0
MzM3OF0gV29ya3F1ZXVlOiBmbG9wcHkgcmVkb19mZF9yZXF1ZXN0ClsgICAgMi43NDMzNzhd
ICBjMDI1OGJjYSAwMDAwMDAwMCBkMjc3N2NlOCBjMDY0NmRmNSBkMjc3N2QwMCBjMDIyZDc5
MyBjMDIzMGY0ZCBjMDQyOTdiNwpbICAgIDIuNzQzMzc4XSAgZDI3NGU2MzQgZDI3NzdkNmMg
ZDI3NzdkMTAgYzAyMmQ4MWQgMDAwMDAwMDkgMDAwMDAwMDAgZDI3NzdkMWMgYzAyMzBmNGQK
WyAgICAyLjc0MzM3OF0gIGQyNzc3ZDRjIGQyNzc3ZDI0IGMwMjMwZmMwIGQyNzc3ZDM4IGMw
NDI5N2I3IGQxYzBhMWIwIGQyNzRlNDAwIGQyNzNkZTAwClsgICAgMi43NDMzNzhdIENhbGwg
VHJhY2U6ClsgICAgMi43NDMzNzhdICBbPGMwMjU4YmNhPl0gPyBjb25zb2xlX3VubG9jaysw
eDM1NS8weDM4MgpbICAgIDIuNzQzMzc4XSAgWzxjMDY0NmRmNT5dIGR1bXBfc3RhY2srMHgx
Ni8weDE4ClsgICAgMi43NDMzNzhdICBbPGMwMjJkNzkzPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg1Zi8weDc2ClsgICAgMi43NDMzNzhdICBbPGMwMjMwZjRkPl0gPyBfbG9jYWxfYmhf
ZW5hYmxlX2lwKzB4MzQvMHg5NwpbICAgIDIuNzQzMzc4XSAgWzxjMDQyOTdiNz5dID8gYmxr
Z19yd3N0YXRfcmVhZCsweDFkLzB4MjQKWyAgICAyLjc0MzM3OF0gIFs8YzAyMmQ4MWQ+XSB3
YXJuX3Nsb3dwYXRoX251bGwrMHgxNC8weDE4ClsgICAgMi43NDMzNzhdICBbPGMwMjMwZjRk
Pl0gX2xvY2FsX2JoX2VuYWJsZV9pcCsweDM0LzB4OTcKWyAgICAyLjc0MzM3OF0gIFs8YzAy
MzBmYzA+XSBsb2NhbF9iaF9lbmFibGUrMHgxMC8weDEyClsgICAgMi43NDMzNzhdICBbPGMw
NDI5N2I3Pl0gYmxrZ19yd3N0YXRfcmVhZCsweDFkLzB4MjQKWyAgICAyLjc0MzM3OF0gIFs8
YzA0MmFiMGE+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4NjUvMHgxNjUKWyAgICAyLjc0
MzM3OF0gIFs8YzAyNTM0OGI+XSA/IG1hcmtfbG9jaysweDFlLzB4MWQzClsgICAgMi43NDMz
NzhdICBbPGMwMjUzNDhiPl0gPyBtYXJrX2xvY2srMHgxZS8weDFkMwpbICAgIDIuNzQzMzc4
XSAgWzxjMDI1MjEzMj5dID8gX19sb2NrX2lzX2hlbGQrMHgyZC8weDQzClsgICAgMi43NDMz
NzhdICBbPGMwMjFkMmUxPl0gPyBwdmNsb2NrX2Nsb2Nrc291cmNlX3JlYWQrMHhiMS8weGRh
ClsgICAgMi43NDMzNzhdICBbPGMwMjFjODg4Pl0gPyBrdm1fY2xvY2tfcmVhZCsweDE0LzB4
MWQKWyAgICAyLjc0MzM3OF0gIFs8YzAyMDY0NzY+XSA/IHBhcmF2aXJ0X3NjaGVkX2Nsb2Nr
KzB4OS8weGQKWyAgICAyLjc0MzM3OF0gIFs8YzA0MmQwOGQ+XSBjZnFfZGlzcGF0Y2hfcmVx
dWVzdHMrMHg1MjEvMHg3OGEKWyAgICAyLjc0MzM3OF0gIFs8YzAyNTNmNWM+XSA/IF9fbG9j
a19hY3F1aXJlKzB4NTIzLzB4YmRmClsgICAgMi43NDMzNzhdICBbPGMwMjUzZjVjPl0gPyBf
X2xvY2tfYWNxdWlyZSsweDUyMy8weGJkZgpbICAgIDIuNzQzMzc4XSAgWzxjMDI1MzQ4Yj5d
ID8gbWFya19sb2NrKzB4MWUvMHgxZDMKWyAgICAyLjc0MzM3OF0gIFs8YzAyNTQ4ZTc+XSA/
IGxvY2tfYWNxdWlyZSsweGEzLzB4ZmMKWyAgICAyLjc0MzM3OF0gIFs8YzA0ZjczYTU+XSA/
IHJlZG9fZmRfcmVxdWVzdCsweDNmLzB4YzBjClsgICAgMi43NDMzNzhdICBbPGMwNDFhMWE0
Pl0gYmxrX3BlZWtfcmVxdWVzdCsweDU5LzB4MjExClsgICAgMi43NDMzNzhdICBbPGMwNDFh
MzZhPl0gYmxrX2ZldGNoX3JlcXVlc3QrMHhlLzB4MWUKWyAgICAyLjc0MzM3OF0gIFs8YzA0
ZjczZTA+XSByZWRvX2ZkX3JlcXVlc3QrMHg3YS8weGMwYwpbICAgIDIuNzQzMzc4XSAgWzxj
MDI0MDdhYj5dID8gcHJvY2Vzc19vbmVfd29yaysweDEzYy8weDM5OApbICAgIDIuNzQzMzc4
XSAgWzxjMDI0MDg0Mz5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDQvMHgzOTgKWyAgICAyLjc0
MzM3OF0gIFs8YzAyNDEwOTI+XSB3b3JrZXJfdGhyZWFkKzB4MTJiLzB4MWM4ClsgICAgMi43
NDMzNzhdICBbPGMwMjQwZjY3Pl0gPyByZXNjdWVyX3RocmVhZCsweDFmZi8weDFmZgpbICAg
IDIuNzQzMzc4XSAgWzxjMDI0NGI3OT5dIGt0aHJlYWQrMHg4Yi8weDkwClsgICAgMi43NDMz
NzhdICBbPGMwNjRjY2I3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAg
ICAyLjc0MzM3OF0gIFs8YzAyNDRhZWU+XSA/IGluc2VydF9rdGhyZWFkX3dvcmsrMHg1YS8w
eDVhClsgICAgMi43NDMzNzhdIC0tLVsgZW5kIHRyYWNlIGRiNmNlMDZmYWUwZThmNDMgXS0t
LQpbICAgIDIuODQwMjY4XSBlbmRfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgZmQwLCBzZWN0
b3IgMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTEwOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTEyOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTE5OjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTIyOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTI0OjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTI1OjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTMxOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTMyOjIwMTQwODAy
MDIwNTEyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTMzOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTQyOjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTQ5OjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTUwOjIwMTQwODAy
MDIwNTEyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTU0OjIwMTQwODAy
MDIwNTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTU1OjIwMTQwODAy
MDIwNTEyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTY0OjIwMTQwODAy
MDIwNTEyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjEyLjAtMTA4NzgtZzJjNTc1
MDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC8yYzU3NTAyNmZhZTZl
NjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXlvY3RvLXZwLTg6MjAxNDA4MDIw
MjA1MTM6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTIuMC0xMDg3OC1nMmM1NzUw
MjoxCjY6MTY6MTYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjJjNTc1MDI2ZmFlNmU2
Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODkgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29t
bWl0IDJjNTc1MDI2ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODkKQXV0aG9yOiBI
b25nIFpoaWd1byA8emhpZ3VvaG9uZ0B0ZW5jZW50LmNvbT4KRGF0ZTogICBXZWQgTm92IDIw
IDEwOjM1OjA1IDIwMTMgLTA3MDAKCiAgICBVcGRhdGUgb2YgYmxrZ19zdGF0IGFuZCBibGtn
X3J3c3RhdCBtYXkgaGFwcGVuIGluIGJoIGNvbnRleHQuCiAgICBXaGlsZSB1NjRfc3RhdHNf
ZmV0Y2hfcmV0cnkgaXMgb25seSBwcmVlbXB0X2Rpc2FibGUgb24gMzJiaXQKICAgIFVQIHN5
c3RlbS4gVGhpcyBpcyBub3QgZW5vdWdoIHRvIGF2b2lkIHByZWVtcHRpb24gYnkgYmggYW5k
CiAgICBtYXkgcmVhZCBzdHJhbmdlIDY0IGJpdCB2YWx1ZS4KICAgIAogICAgU2lnbmVkLW9m
Zi1ieTogSG9uZyBaaGlndW8gPHpoaWd1b2hvbmdAdGVuY2VudC5jb20+CiAgICBBY2tlZC1i
eTogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgogICAgQ2M6IHN0YWJsZUBrZXJuZWwub3Jn
CiAgICBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Cgo6MDQw
MDAwIDA0MDAwMCA4NDMwYTExZGRhZjQ2NDA2NjNiN2VkOTlmZWFjYjFkM2RlMTI2MzIxIDg1
YjgyN2ZhMzA2MzM5MGUxMDYyOGRmNGU2NmMwZjU0OTVhMjcwNjcgTQlibG9jawpiaXNlY3Qg
cnVuIHN1Y2Nlc3MKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMmM1NzUwMi4uLiBVcGRh
dGUgb2YgYmxrZ19zdGF0IGFuZCBibGtnX3J3c3RhdCBtYXkgaGFwcGVuIGluIGJoIGNvbnRl
eHQuIFdoaWxlIHU2NF9zdGF0c19mZXRjaF9yZXRyeSBpcyBvbmx5IHByZWVtcHRfZGlzYWJs
ZSBvbiAzMmJpdCBVUCBzeXN0ZW0uIFRoaXMgaXMgbm90IGVub3VnaCB0byBhdm9pZCBwcmVl
bXB0aW9uIGJ5IGJoIGFuZCBtYXkgcmVhZCBzdHJhbmdlIDY0IGJpdCB2YWx1ZS4KSEVBRCBp
cyBub3cgYXQgODIwMjNiYi4uLiBNZXJnZSB0YWcgJ3BtK2FjcGktMi0zLjEzLXJjMScgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JhZmFlbC9s
aW51eC1wbQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOjgy
MDIzYmI3Zjc1YjAwNTJmNDBkM2U3NDE2OWQxOTFjM2U0ZTYyODY6YmlzZWN0LWxpbnV4LTgK
CjIwMTQtMDgtMDItMDI6MDc6MTQgODIwMjNiYjdmNzViMDA1MmY0MGQzZTc0MTY5ZDE5MWMz
ZTRlNjI4NiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQtODIwMjNiYjdmNzViMDA1
MmY0MGQzZTc0MTY5ZDE5MWMzZTRlNjI4NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzgyMDIzYmI3Zjc1YjAwNTJmNDBkM2U3NDE2
OWQxOTFjM2U0ZTYyODYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC04MjAyM2JiN2Y3NWIw
MDUyZjQwZDNlNzQxNjlkMTkxYzNlNGU2Mjg2Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvODIwMjNiYjdmNzViMDA1MmY0MGQzZTc0MTY5ZDE5MWMzZTRl
NjI4Ni92bWxpbnV6LTMuMTIuMC0xMDg3Ny1nODIwMjNiYgoKMjAxNC0wOC0wMi0wMjoxMTox
NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uCTEJMzQJNDIJNzUJNzcJ
MTIwLgkxMjgJMTQyCTE2MQkxNzcJMTgyCTIwNwkyMTcJMjM4LgkyNzAgU1VDQ0VTUwoKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODIwMjNiYi4uLiBNZXJnZSB0YWcgJ3BtK2FjcGkt
Mi0zLjEzLXJjMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3JhZmFlbC9saW51eC1wbQpIRUFEIGlzIG5vdyBhdCBmMWYyOTI0Li4uIDBkYXkg
aGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDgwMTIwJwpscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgwMTIwOmYxZjI5MjQ4ZDY3NWQ0NzYyZTdiN2Y0
OThiZTUwZDJmYjljMjk0ZjM6YmlzZWN0LWxpbnV4LTgKIFRFU1QgRkFJTFVSRQpbICAgIDIu
Njg4Nzk1XSBbIElORk86IGluY29uc2lzdGVudCBsb2NrIHN0YXRlIF0KWyAgICAyLjY4OTc3
MV0gMy4xNi4wLXJjNy13bC0wMzQ1OS1nZjFmMjkyNCAjMzcyIE5vdCB0YWludGVkClsgICAg
Mi42OTAwNTVdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDIuNjkw
MDU1XSBpbmNvbnNpc3RlbnQge1NPRlRJUlEtT04tV30gLT4ge0lOLVNPRlRJUlEtV30gdXNh
Z2UuClsgICAgMi42OTAwNTVdIHN3YXBwZXIvMCBbSEMwWzBdOlNDMVsxXTpIRTA6U0UwXSB0
YWtlczoKWyAgICAyLjY5MDA1NV0gIChmbG9wcHlfbG9jayl7Ky4/Li4ufSwgYXQ6IFs8YzI0
Mzg3ODI+XSBjZnFfaWRsZV9zbGljZV90aW1lcisweDFhLzB4NzcKWyAgICAyLjY5MDA1NV0g
e1NPRlRJUlEtT04tV30gc3RhdGUgd2FzIHJlZ2lzdGVyZWQgYXQ6ClsgICAgMi42OTAwNTVd
ICAgWzxjMjI1MDQxNT5dIG1hcmtfaGVsZF9sb2NrcysweDRhLzB4NjAKWyAgICAyLjY5MDA1
NV0gICBbPGMyMjUwNTc2Pl0gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4MTRiLzB4MTY1
ClsgICAgMi42OTAwNTVdICAgWzxjMjI1MDU5Yj5dIHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8w
eGQKWyAgICAyLjY5MDA1NV0gICBbPGMyNDM2YzE5Pl0gYmxrZ19yd3N0YXRfcmVhZCsweDIy
LzB4MmUKWyAgICAyLjY5MDA1NV0gICBbPGMyNDM3ZGEzPl0gX19jZnFfc2V0X2FjdGl2ZV9x
dWV1ZSsweDY1LzB4MTY1ClsgICAgMi42OTAwNTVdICAgWzxjMjQzYTAyOT5dIGNmcV9kaXNw
YXRjaF9yZXF1ZXN0cysweDUyMS8weDc4YQpbICAgIDIuNjkwMDU1XSAgIFs8YzI0MjVkNzY+
XSBibGtfcGVla19yZXF1ZXN0KzB4NTkvMHgyMTEKWyAgICAyLjY5MDA1NV0gICBbPGMyNDI1
ZjNjPl0gYmxrX2ZldGNoX3JlcXVlc3QrMHhlLzB4MWUKWyAgICAyLjY5MDA1NV0gICBbPGMy
NTBiZWE3Pl0gcmVkb19mZF9yZXF1ZXN0KzB4N2EvMHhjZjAKWyAgICAyLjY5MDA1NV0gICBb
PGMyNTA5ODFhPl0gZmxvcHB5X3dvcmtfd29ya2ZuKzB4ZS8weDEwClsgICAgMi42OTAwNTVd
ICAgWzxjMjIzZjdhMj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxY2QvMHgzOTEKWyAgICAyLjY5
MDA1NV0gICBbPGMyMjQwMGMxPl0gd29ya2VyX3RocmVhZCsweDIyOS8weDJlNQpbICAgIDIu
NjkwMDU1XSAgIFs8YzIyNDJiNTY+XSBrdGhyZWFkKzB4OGIvMHg5MApbICAgIDIuNjkwMDU1
XSAgIFs8YzI2NzE2NDA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAg
IDIuNjkwMDU1XSBpcnEgZXZlbnQgc3RhbXA6IDI4MzM1ClsgICAgMi42OTAwNTVdIGhhcmRp
cnFzIGxhc3QgIGVuYWJsZWQgYXQgKDI4MzM0KTogWzxjMjY3MGY4OT5dIF9yYXdfc3Bpbl91
bmxvY2tfaXJxKzB4MjcvMHgzNQpbICAgIDIuNjkwMDU1XSBoYXJkaXJxcyBsYXN0IGRpc2Fi
bGVkIGF0ICgyODMzNSk6IFs8YzI2NzBlMDU+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4
MTgvMHg0MwpbICAgIDIuNjkwMDU1XSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICgyODMy
Nik6IFs8YzIyMzExNjI+XSBfbG9jYWxfYmhfZW5hYmxlKzB4M2QvMHgzZgpbICAgIDIuNjkw
MDU1XSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyODMyNyk6IFs8YzIyMDJkZDM+XSBk
b19zb2Z0aXJxX293bl9zdGFjaysweDIxLzB4MjcKWyAgICAyLjY5MDA1NV0gClsgICAgMi42
OTAwNTVdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAg
Mi42OTAwNTVdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAyLjY5
MDA1NV0gClsgICAgMi42OTAwNTVdICAgICAgICBDUFUwClsgICAgMi42OTAwNTVdICAgICAg
ICAtLS0tClsgICAgMi42OTAwNTVdICAgbG9jayhmbG9wcHlfbG9jayk7ClsgICAgMi42OTAw
NTVdICAgPEludGVycnVwdD4KWyAgICAyLjY5MDA1NV0gICAgIGxvY2soZmxvcHB5X2xvY2sp
OwpbICAgIDIuNjkwMDU1XSAKWyAgICAyLjY5MDA1NV0gICoqKiBERUFETE9DSyAqKioKWyAg
ICAyLjY5MDA1NV0gClsgICAgMi42OTAwNTVdIDEgbG9jayBoZWxkIGJ5IHN3YXBwZXIvMDoK
WyAgICAyLjY5MDA1NV0gICMwOiAgKCgmY2ZxZC0+aWRsZV9zbGljZV90aW1lcikpeysuLS4u
Ln0sIGF0OiBbPGMyMjVmMGMyPl0gY2FsbF90aW1lcl9mbisweDAvMHgxYjMKWyAgICAyLjY5
MDA1NV0gClsgICAgMi42OTAwNTVdIHN0YWNrIGJhY2t0cmFjZToKWyAgICAyLjY5MDA1NV0g
Q1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzctd2wt
MDM0NTktZ2YxZjI5MjQgIzM3MgpbICAgIDIuNjkwMDU1XSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi42OTAwNTVdICAwMDAwMDAw
MCBjMjkzNTUzYyBkMzQwYmU0OCBjMjY2YmI2NSBkMzQwYmU3NCBjMjY2OTNjZSBjMjg1MWNk
NCBjMjg1MWJkMwpbICAgIDIuNjkwMDU1XSAgYzI4NTFiOWIgYzI4NTFiYmEgYzI4NTFiYzQg
YzI4NTJhMDMgMDAwMDAwMDQgYzI5MzU5ODggMDAwMDAwMDIgZDM0MGJlOWMKWyAgICAyLjY5
MDA1NV0gIGMyMjUwMmVkIDAwMDAwMDA0IDAwMDAwMDAwIGMyMjRmZGFjIGMyOTM1NTNjIDAw
MDAwMDA2IDAwMDAwMDAwIGMyOTM1OTg4ClsgICAgMi42OTAwNTVdIENhbGwgVHJhY2U6Clsg
ICAgMi42OTAwNTVdICBbPGMyNjZiYjY1Pl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAy
LjY5MDA1NV0gIFs8YzI2NjkzY2U+XSBwcmludF91c2FnZV9idWcrMHgxODAvMHgxOGQKWyAg
ICAyLjY5MDA1NV0gIFs8YzIyNTAyZWQ+XSBtYXJrX2xvY2srMHhmNS8weDFkMwpbICAgIDIu
NjkwMDU1XSAgWzxjMjI0ZmRhYz5dID8gY2hlY2tfdXNhZ2VfYmFja3dhcmRzKzB4ODkvMHg4
OQpbICAgIDIuNjkwMDU1XSAgWzxjMjI1MGExMj5dIF9fbG9ja19hY3F1aXJlKzB4MjYwLzB4
YmU5ClsgICAgMi42OTAwNTVdICBbPGMyMjRmZDIzPl0gPyBwcmludF9zaG9ydGVzdF9sb2Nr
X2RlcGVuZGVuY2llcysweDEzMy8weDEzMwpbICAgIDIuNjkwMDU1XSAgWzxjMjI1MTY1ND5d
IGxvY2tfYWNxdWlyZSsweDhkLzB4ZmMKWyAgICAyLjY5MDA1NV0gIFs8YzI0Mzg3ODI+XSA/
IGNmcV9pZGxlX3NsaWNlX3RpbWVyKzB4MWEvMHg3NwpbICAgIDIuNjkwMDU1XSAgWzxjMjQz
ODc2OD5dID8gY2ZxX3ByZWVtcHRfcXVldWUrMHg4ZC8weDhkClsgICAgMi42OTAwNTVdICBb
PGMyNjcwZTIwPl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDMzLzB4NDMKWyAgICAyLjY5
MDA1NV0gIFs8YzI0Mzg3ODI+XSA/IGNmcV9pZGxlX3NsaWNlX3RpbWVyKzB4MWEvMHg3Nwpb
ICAgIDIuNjkwMDU1XSAgWzxjMjQzODc4Mj5dIGNmcV9pZGxlX3NsaWNlX3RpbWVyKzB4MWEv
MHg3NwpbICAgIDIuNjkwMDU1XSAgWzxjMjQzODc2OD5dID8gY2ZxX3ByZWVtcHRfcXVldWUr
MHg4ZC8weDhkClsgICAgMi42OTAwNTVdICBbPGMyMjVmMTU5Pl0gY2FsbF90aW1lcl9mbisw
eDk3LzB4MWIzClsgICAgMi42OTAwNTVdICBbPGMyNDM4NzY4Pl0gPyBjZnFfcHJlZW1wdF9x
dWV1ZSsweDhkLzB4OGQKWyAgICAyLjY5MDA1NV0gIFs8YzI0Mzg3Njg+XSA/IGNmcV9wcmVl
bXB0X3F1ZXVlKzB4OGQvMHg4ZApbICAgIDIuNjkwMDU1XSAgWzxjMjI1ZjVjND5dIHJ1bl90
aW1lcl9zb2Z0aXJxKzB4MTlhLzB4MWJjClsgICAgMi42OTAwNTVdICBbPGMyMjMxNTMxPl0g
X19kb19zb2Z0aXJxKzB4MTBmLzB4MmI4ClsgICAgMi42OTAwNTVdICBbPGMyMjMxNDIyPl0g
PyBfX2xvY2FsX2JoX2Rpc2FibGVfaXArMHg2Yi8weDZiClsgICAgMi42OTAwNTVdICBbPGMy
MjAyZGQzPl0gZG9fc29mdGlycV9vd25fc3RhY2srMHgyMS8weDI3ClsgICAgMi42OTAwNTVd
ICA8SVJRPiAgWzxjMjIzMThjMD5dIGlycV9leGl0KzB4M2YvMHg1OApbICAgIDIuNjkwMDU1
XSAgWzxjMjIwMmJiMj5dIGRvX0lSUSsweDdiLzB4OGUKWyAgICAyLjY5MDA1NV0gIFs8YzI2
NzFkYjE+XSBjb21tb25faW50ZXJydXB0KzB4MzEvMHgzOApbICAgIDIuNjkwMDU1XSAgWzxj
MjIxZGM0MD5dID8gbmF0aXZlX3NhZmVfaGFsdCsweDUvMHg3ClsgICAgMi42OTAwNTVdICBb
PGMyMjA4MDBlPl0gZGVmYXVsdF9pZGxlKzB4MWIvMHgzZApbICAgIDIuNjkwMDU1XSAgWzxj
MjIwODUwZj5dIGFyY2hfY3B1X2lkbGUrMHhlLzB4MTAKWyAgICAyLjY5MDA1NV0gIFs8YzIy
NGRlMjI+XSBjcHVfc3RhcnR1cF9lbnRyeSsweGU3LzB4MWRkClsgICAgMi42OTAwNTVdICBb
PGMyNjY2Yjk4Pl0gcmVzdF9pbml0KzB4MTBlLzB4MTEzClsgICAgMi42OTAwNTVdICBbPGMy
OWQ3YWFiPl0gc3RhcnRfa2VybmVsKzB4MzdlLzB4MzgzClsgICAgMi42OTAwNTVdICBbPGMy
OWQ3MmFiPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMi43NzQ5NjhdIGVu
ZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBmZDAsIHNlY3RvciAwClsgICAgMi43NzYwMTJd
IGZsb3BweTogZXJyb3IgLTUgd2hpbGUgcmVhZGluZyBibG9jayAwClsgICAgMi43OTY4MDld
IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBmZDAsIHNlY3RvciAwCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2YxZjI5MjQ4ZDY3NWQ0NzYyZTdiN2Y0OThiZTUw
ZDJmYjljMjk0ZjMvZG1lc2cteW9jdG8tdnAtMjU6MjAxNDA4MDEyMTI1NDc6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzctd2wtMDM0NTktZ2YxZjI5MjQ6MzcyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0L2YxZjI5MjQ4ZDY3NWQ0NzYyZTdi
N2Y0OThiZTUwZDJmYjljMjk0ZjMvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQwODAxMjE0
MTEyOmkzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3LXdsLTAzNDU5LWdm
MWYyOTI0OjM3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC9mMWYyOTI0
OGQ2NzVkNDc2MmU3YjdmNDk4YmU1MGQyZmI5YzI5NGYzL2RtZXNnLXlvY3RvLWtidWlsZC0y
MjoyMDE0MDgwMTIxNDExMjppMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQ6My4xNi4wLXJj
Ny13bC0wMzQ1OS1nZjFmMjkyNDozNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvZjFmMjkyNDhkNjc1ZDQ3NjJlN2I3ZjQ5OGJlNTBkMmZiOWMyOTRmMy9kbWVzZy15
b2N0by1rYnVpbGQtMTI6MjAxNDA4MDEyMTQxMTc6aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEy
MTI0OjMuMTYuMC1yYzctd2wtMDM0NTktZ2YxZjI5MjQ6MzcyCjc6NDo0IGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCBmMWYyOTI0IDBkYXkgaGVhZCBndWFy
ZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDgwMTIwJwoKPT09PT09PT09IGxpbnVzL21hc3Rl
ciA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjFmMjkyNC4uLiAwZGF5
IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA4MDEyMCcKSEVBRCBpcyBub3cg
YXQgNmYwOTI4MC4uLiBNZXJnZSB0YWcgJ3BtK2FjcGktMy4xNi1yYzgnIG9mIGdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9yYWZhZWwvbGludXgtcG0K
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC9saW51czptYXN0ZXI6NmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJj
YzBhODFhZjpiaXNlY3QtbGludXgtOAoKMjAxNC0wOC0wMi0wMjozNjowNSA2ZjA5MjgwMzZi
Y2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0w
ODAxMjEyNC02ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvNmYw
OTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMx
LTA4MDEyMTI0LTZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJv
LXNtb2tlL2kzODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC02ZjA5MjgwMzZiY2JkOGRkMmVi
ZWU5MjAxNTgwZGE4YmNjMGE4MWFmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDgwMTIxMjQvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi92
bWxpbnV6LTMuMTYuMC1yYzctMDAwODQtZzZmMDkyODAKCjIwMTQtMDgtMDItMDM6MzA6MDYg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxMgkyMCBURVNUIEZBSUxVUkUKWyAgICAzLjQ3NDU3
Ml0gcmFuZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3aXRoIDE2IGJpdHMgb2YgZW50cm9weSBh
dmFpbGFibGUKWyAgICAzLjY0MjgyOF0gbW91bnRhbGwgKDEyNSkgdXNlZCBncmVhdGVzdCBz
dGFjayBkZXB0aDogNjI0NCBieXRlcyBsZWZ0CgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxh
cHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNwdSBIYXN3
ZWxsLCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgw
MTIxMjQvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi92bWxpbnV6
LTMuMTYuMC1yYzctMDAwODQtZzZmMDkyODAgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEg
ZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlz
X2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBz
b2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0w
IGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9k
ZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvbGludXM6bWFzdGVyOjZmMDkyODAzNmJjYmQ4ZGQyZWJlZTky
MDE1ODBkYThiY2MwYTgxYWY6YmlzZWN0LWxpbnV4LTgvLnZtbGludXotNmYwOTI4MDM2YmNi
ZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi0yMDE0MDgwMjAzMzQwNy0xMDcta2J1aWxk
IGJyYW5jaD1saW51cy9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wODAxMjEyNC82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFm
L3ZtbGludXotMy4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MCBkcmJkLm1pbm9yX2NvdW50PTgn
ICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAt
bSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxh
bj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMg
YmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwta2J1
aWxkLTEyIC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1rYnVp
bGQtMTIgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1
ODBkYThiY2MwYTgxYWYvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwODAyMDMyOTExOmkz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNDozLjE2LjAtcmM3LTAwMDg0LWc2ZjA5MjgwOjEK
MToxOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgoKPT09PT09PT09IG5leHQvbWFz
dGVyID09PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIGRmMjgwMmYuLi4z
ZjgzZjgzIGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgMGNl
Y2M4My4uLjhlYjRmMTIgYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1
cGRhdGUpCiArIDVjMTU5NzguLi40MTk4Y2YzIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIg
IChmb3JjZWQgdXBkYXRlKQogICAyNmJjZDhiLi43YzkwOWIwICBzdGFibGUgICAgIC0+IG5l
eHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDgwMSAtPiBuZXh0LTIwMTQwODAxClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDZmMDkyODAuLi4gTWVyZ2UgdGFnICdwbSthY3BpLTMuMTYtcmM4JyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcmFmYWVsL2xpbnV4
LXBtCkhFQUQgaXMgbm93IGF0IDQxOThjZjMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMg
ZmlsZXMgZm9yIDIwMTQwODAxCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQvbmV4dDptYXN0ZXI6NDE5OGNmMzI0ZGRlYTQ0
N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMTpiaXNlY3QtbGludXgtOAoKMjAxNC0wOC0wMi0w
MzozMjowNCA0MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1jMS0wODAxMjEyNC00MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2My
MzE5Y2VkNzc0MjAxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDgwMTIxMjQvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIw
MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LTQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2Qz
YzIzMTljZWQ3NzQyMDEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL3ZtbGludXot
My4xNi4wLXJjNy1uZXh0LTIwMTQwODAxCgoyMDE0LTA4LTAyLTAzOjM2OjA0IGRldGVjdGlu
ZyBib290IHN0YXRlIC4JNQkxNAkxNiBURVNUIEZBSUxVUkUKWyAgICA0LjkxNTYwNV0gcmFu
ZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3aXRoIDIxIGJpdHMgb2YgZW50cm9weSBhdmFpbGFi
bGUKWyAgICA1LjIyNDA3N10gbW91bnRhbGwgKDEyMCkgdXNlZCBncmVhdGVzdCBzdGFjayBk
ZXB0aDogNjI0NCBieXRlcyBsZWZ0CgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0
aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNwdSBIYXN3ZWxsLCtz
bWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDgwMTIxMjQv
NDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMS92bWxpbnV6LTMuMTYu
MC1yYzctbmV4dC0yMDE0MDgwMSAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXBy
aW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxl
ZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2Nr
dXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29s
ZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0w
IHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1j
MS0wODAxMjEyNC9uZXh0Om1hc3Rlcjo0MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5
Y2VkNzc0MjAxOmJpc2VjdC1saW51eC04Ly52bWxpbnV6LTQxOThjZjMyNGRkZWE0NDdkYWFj
M2Y4M2QzYzIzMTljZWQ3NzQyMDEtMjAxNDA4MDIwMzQwMDYtMTExLWtidWlsZCBicmFuY2g9
bmV4dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wODAx
MjEyNC80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL3ZtbGludXot
My4xNi4wLXJjNy1uZXh0LTIwMTQwODAxIGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQg
L2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21w
IDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qg
b3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2Fs
dGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1rYnVpbGQtMTEgLXNl
cmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWtidWlsZC0xMSAtZGFl
bW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDgwMTIxMjQvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3
NDIwMS9kbWVzZy15b2N0by1rYnVpbGQtMTk6MjAxNDA4MDIwMzM1MTc6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2QzYzIz
MTljZWQ3NzQyMDEvZG1lc2cteW9jdG8tdnAtMjk6MjAxNDA4MDIwMzM4MTM6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0LzQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2Qz
YzIzMTljZWQ3NzQyMDEvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA4MDIwMzM1NDc6aTM4
Ni1yYW5kY29uZmlnLWMxLTA4MDEyMTI0OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxCjI6
MzoxNyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-10878-g2c57502"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
CONFIG_MODULE_SIG_SHA224=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha224"
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
CONFIG_MVIAC7=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_AHCI_IMX is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
# CONFIG_DM_CACHE_CLEANER is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=m
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_WM831X=m
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_MAX8925_POWER=m
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_88PM860X is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=m
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=m
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA903X=m
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8994=m
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_VX_LIB=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=m
# CONFIG_SOUND_TRIX is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
# CONFIG_PSS_MIXER is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
# CONFIG_COMEDI_PCL818 is not set
# CONFIG_COMEDI_PCM3724 is not set
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
CONFIG_COMEDI_AMPLC_PC236_ISA=m
CONFIG_COMEDI_AMPLC_PC263_ISA=m
# CONFIG_COMEDI_RTI800 is not set
CONFIG_COMEDI_RTI802=m
# CONFIG_COMEDI_DAS16M1 is not set
CONFIG_COMEDI_DAS08_ISA=m
# CONFIG_COMEDI_DAS16 is not set
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
# CONFIG_COMEDI_DAS6402 is not set
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
# CONFIG_COMEDI_DT2815 is not set
# CONFIG_COMEDI_DT2817 is not set
# CONFIG_COMEDI_DT282X is not set
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_UNIOXX5=m
# CONFIG_COMEDI_FL512 is not set
# CONFIG_COMEDI_AIO_AIO12_8 is not set
CONFIG_COMEDI_AIO_IIRO_16=m
# CONFIG_COMEDI_II_PCI20KC is not set
# CONFIG_COMEDI_C6XDIGIO is not set
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
# CONFIG_COMEDI_NI_LABPC_ISA is not set
CONFIG_COMEDI_PCMAD=m
# CONFIG_COMEDI_PCMDA12 is not set
CONFIG_COMEDI_PCMMIO=m
# CONFIG_COMEDI_PCMUIO is not set
CONFIG_COMEDI_MULTIQ3=m
# CONFIG_COMEDI_POC is not set
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=m
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=m
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
CONFIG_SPEAKUP_SYNTH_DECEXT=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=m
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_SYNC is not set
CONFIG_DGRP=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_PALMAS=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
CONFIG_NAU7802=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
CONFIG_EXOFS_DEBUG=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--k+w/mQv8wyuph6w0--
