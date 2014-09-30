Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaI3Hqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:46:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:19070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaI3Hqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="log'?scan'208";a="607417696"
Date: Tue, 30 Sep 2014 15:46:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [x86, irq] WARNING: CPU: 0 PID: 0 at
 arch/x86/kernel/cpu/common.c:1430 warn_pre_alternatives()
Message-ID: <20140930074632.GB8090@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Gerry,

0day kernel testing robot got the below dmesg and the first bad commit is

https://github.com/jiangliu/linux.git irqdomain/p3v1

commit f2bb95f78a694f575ef41a9f65c003ee934fc263
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed Jun 25 14:16:18 2014 +0800
Commit:     Jiang Liu <jiang.liu@linux.intel.com>
CommitDate: Fri Sep 26 19:09:42 2014 +0800

    x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
    
    Move IRQ initialization routines from io_apic.c into vector.c,
    preparing for enabling hierarchy irqdomain.
    
    Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
It looks to me that the OOM errors in the parent commit is irrelevant.

+------------------------------------------------------------------+------------+------------+------------------+
|                                                                  | 9d24b890d0 | f2bb95f78a | v3.17-rc6_092700 |
+------------------------------------------------------------------+------------+------------+------------------+
| boot_successes                                                   | 43         | 0          | 0                |
| boot_failures                                                    | 37         | 20         | 11               |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 37         |            |                  |
| backtrace:serio_handle_event                                     | 28         |            |                  |
| backtrace:do_fork                                                | 4          |            |                  |
| backtrace:kthreadd                                               | 4          |            |                  |
| backtrace:rcu_torture_stats                                      | 5          |            |                  |
| WARNING:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives()  | 0          | 20         | 11               |
| BUG:unable_to_handle_kernel                                      | 0          | 20         | 11               |
| Oops                                                             | 0          | 20         | 11               |
| EIP_is_at_setup_irq                                              | 0          | 20         | 11               |
| Kernel_panic-not_syncing:Fatal_exception                         | 0          | 20         | 11               |
+------------------------------------------------------------------+------------+------------+------------------+

[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 0
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1430 warn_pre_alternatives+0x17/0x20()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc6-00208-gf2bb95f #2
[    0.000000]  c1a91eac c1a91eac c1a91e80 c175a430 c1a91e9c c1034c47 00000596 c100fb87
[    0.000000]  0000003a c1a91f64 c1026fc0 c1a91eb4 c1034cb6 00000009 c1a91eac c198ecbc
[    0.000000]  c1a91ec8 c1a91ec8 c100fb87 c198ec6c 00000596 c198ecbc c1a91f44 c1029a4d
[    0.000000] Call Trace:
[    0.000000]  [<c175a430>] dump_stack+0x16/0x18
[    0.000000]  [<c1034c47>] warn_slowpath_common+0x57/0x70
[    0.000000]  [<c100fb87>] ? warn_pre_alternatives+0x17/0x20
[    0.000000]  [<c1026fc0>] ? kvm_read_and_reset_pf_reason+0x20/0x20
[    0.000000]  [<c1034cb6>] warn_slowpath_fmt+0x26/0x30
[    0.000000]  [<c100fb87>] warn_pre_alternatives+0x17/0x20
[    0.000000]  [<c1029a4d>] __do_page_fault+0x19d/0x4a0
[    0.000000]  [<c105a657>] ? __lock_acquire+0x2f7/0xcb0
[    0.000000]  [<c1026fc0>] ? kvm_read_and_reset_pf_reason+0x20/0x20
[    0.000000]  [<c1029ee4>] do_page_fault+0x24/0x40
[    0.000000]  [<c1026fd2>] do_async_page_fault+0x12/0x80
[    0.000000]  [<c17618bd>] error_code+0x65/0x6c
[    0.000000]  [<c13c0000>] ? sg_scsi_ioctl+0x150/0x3a0
[    0.000000]  [<c1068edf>] ? setup_irq+0xf/0x80
[    0.000000]  [<c1c977ae>] native_init_IRQ+0x2ee/0x2fc
[    0.000000]  [<c1c974be>] init_IRQ+0x1f/0x21
[    0.000000]  [<c1c94976>] start_kernel+0x23b/0x389
[    0.000000]  [<c1c942cb>] i386_start_kernel+0x79/0x7d
[    0.000000] ---[ end trace 4d5ff9f2f68c4233 ]---
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000003a

git bisect start fe34ad1c7f6455ab6827d4cc84224b7f57eec1eb 0f33be009b89d2268e94194dc4fd01a7851b6d51 --
git bisect  bad a3f28bd4c220897d58cba325209d64613f8a6d0a  # 14:05      0-     20  Merge 'arm-soc/sunxi/rtc' into devel-hourly-2014092700
git bisect good a25102b03066c1e532fb15f9dc96fd4560e27718  # 14:11     20+     12  Merge 'tomeu/clk-constraints' into devel-hourly-2014092700
git bisect good c3d8a4dadca4527de0c294fb3befba882fc4f116  # 14:15     20+      7  Merge 'ljones-mfd/for-mfd-next' into devel-hourly-2014092700
git bisect  bad c42622ecfc1b3ca7110002aa37fa37e0bc6e2bbf  # 14:20      0-     10  Merge 'jiangliu/irqdomain/p1v2' into devel-hourly-2014092700
git bisect good 07c59feab0eab9e51d0306e5f254e6ec148b568b  # 14:31     20+      7  Merge 'gpio/devel' into devel-hourly-2014092700
git bisect good 452b6361c4d9baf6940adb7b1316e0f386c39799  # 14:48     20+      9  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git bisect good 424fff7ae225da25606f2ba6aafc5df3df1e8b7f  # 14:57     20+      8  x86, irq: Kill fourth parameter of IO_APIC_get_PCI_irq_vector()
git bisect good 65bc21db96059f859a4e88676578bb485f2eb1b0  # 15:05     20+     14  x86, irq: Move PCI MSI related code from io_apic.c into msi.c
git bisect  bad 9a55fc663ec935de7912d8a649abdc6351bef2b9  # 15:08      0-     20  x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
git bisect good 9d24b890d00698320c804c335673a5a5dad177bb  # 16:40     20+      8  x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
git bisect  bad f2bb95f78a694f575ef41a9f65c003ee934fc263  # 18:44      0-     20  x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
# first bad commit: [f2bb95f78a694f575ef41a9f65c003ee934fc263] x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
git bisect good 9d24b890d00698320c804c335673a5a5dad177bb  # 18:48     60+     37  x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
git bisect  bad fe34ad1c7f6455ab6827d4cc84224b7f57eec1eb  # 18:48      0-     11  0day head guard for 'devel-hourly-2014092700'
git bisect good 1e3827bf8aebe29af2d6e49b89d85dfae4d0154f  # 23:29     60+     27  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 4d8426f9ac601db2a64fa7be64051d02b9c9fe01  # 00:23     60+     22  Add linux-next specific files for 20140926


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-m 320
	-smp 2
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
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
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

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-83:20140928184420:i386-randconfig-c1-09270045::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc6-00208-gf2bb95f (kbuild@cairo) (gcc =
version 4.9.1 (Debian 4.9.1-11) ) #2 Sun Sep 28 18:43:32 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02333000, 0x02333fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat c1c7e500, node_mem_map d2=
513020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1aa7280
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c1-09270045/linux-devel:devel-hourly-2014092700:f2bb95f78a694f575=
ef41a9f65c003ee934fc263:bisect-linux-0/.vmlinuz-f2bb95f78a694f575ef41a9f65c=
003ee934fc263-20140928184346-19-ivb41 branch=3Dlinux-devel/devel-hourly-201=
4092700 BOOT_IMAGE=3D/kernel/i386-randconfig-c1-09270045/f2bb95f78a694f575e=
f41a9f65c003ee934fc263/vmlinuz-3.17.0-rc6-00208-gf2bb95f drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 279532K/327160K available (7560K kernel code, 2062K =
rwdata, 3244K rodata, 356K init, 6384K bss, 47628K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xfffe0000   ( 696 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc1c94000 - 0xc1ced000   ( 356 kB)
[    0.000000]       .data : 0xc176247f - 0xc1c92980   (5313 kB)
[    0.000000]       .text : 0xc1000000 - 0xc176247f   (7561 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 0
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1430 =
warn_pre_alternatives+0x17/0x20()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc6-00208-gf2=
bb95f #2
[    0.000000]  c1a91eac c1a91eac c1a91e80 c175a430 c1a91e9c c1034c47 00000=
596 c100fb87
[    0.000000]  0000003a c1a91f64 c1026fc0 c1a91eb4 c1034cb6 00000009 c1a91=
eac c198ecbc
[    0.000000]  c1a91ec8 c1a91ec8 c100fb87 c198ec6c 00000596 c198ecbc c1a91=
f44 c1029a4d
[    0.000000] Call Trace:
[    0.000000]  [<c175a430>] dump_stack+0x16/0x18
[    0.000000]  [<c1034c47>] warn_slowpath_common+0x57/0x70
[    0.000000]  [<c100fb87>] ? warn_pre_alternatives+0x17/0x20
[    0.000000]  [<c1026fc0>] ? kvm_read_and_reset_pf_reason+0x20/0x20
[    0.000000]  [<c1034cb6>] warn_slowpath_fmt+0x26/0x30
[    0.000000]  [<c100fb87>] warn_pre_alternatives+0x17/0x20
[    0.000000]  [<c1029a4d>] __do_page_fault+0x19d/0x4a0
[    0.000000]  [<c105a657>] ? __lock_acquire+0x2f7/0xcb0
[    0.000000]  [<c1026fc0>] ? kvm_read_and_reset_pf_reason+0x20/0x20
[    0.000000]  [<c1029ee4>] do_page_fault+0x24/0x40
[    0.000000]  [<c1026fd2>] do_async_page_fault+0x12/0x80
[    0.000000]  [<c17618bd>] error_code+0x65/0x6c
[    0.000000]  [<c13c0000>] ? sg_scsi_ioctl+0x150/0x3a0
[    0.000000]  [<c1068edf>] ? setup_irq+0xf/0x80
[    0.000000]  [<c1c977ae>] native_init_IRQ+0x2ee/0x2fc
[    0.000000]  [<c1c974be>] init_IRQ+0x1f/0x21
[    0.000000]  [<c1c94976>] start_kernel+0x23b/0x389
[    0.000000]  [<c1c942cb>] i386_start_kernel+0x79/0x7d
[    0.000000] ---[ end trace 4d5ff9f2f68c4233 ]---
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 000=
0003a
[    0.000000] IP: [<c1068edf>] setup_irq+0xf/0x80
[    0.000000] *pde =3D 00000000=20
[    0.000000] Oops: 0000 [#1]=20
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W      3.17.0-=
rc6-00208-gf2bb95f #2
[    0.000000] task: c1a990c0 ti: c1a90000 task.ti: c1a90000
[    0.000000] EIP: 0060:[<c1068edf>] EFLAGS: 00210046 CPU: 0
[    0.000000] EIP is at setup_irq+0xf/0x80
[    0.000000] EAX: 00000000 EBX: 00000100 ECX: 00000000 EDX: 00000002
[    0.000000] ESI: 00000002 EDI: c1a9b0c0 EBP: c1a91fac ESP: c1a91fa0
[    0.000000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.000000] CR0: 8005003b CR2: 0000003a CR3: 01cf0000 CR4: 00000690
[    0.000000] Stack:
[    0.000000]  00000100 c1a91fb4 c1cf1000 c1a91fc8 c1c977ae 006015f0 c1768=
e00 00000800
[    0.000000]  c1cce3c0 cb885388 c1a91fd0 c1c974be c1a91fe8 c1c94976 c1cce=
3c0 cb30a300
[    0.000000]  00020800 c1cf1800 c1a91ff8 c1c942cb 00000800 c1cf1800 0253f=
003 00000000
[    0.000000] Call Trace:
[    0.000000]  [<c1c977ae>] native_init_IRQ+0x2ee/0x2fc
[    0.000000]  [<c1c974be>] init_IRQ+0x1f/0x21
[    0.000000]  [<c1c94976>] start_kernel+0x23b/0x389
[    0.000000]  [<c1c942cb>] i386_start_kernel+0x79/0x7d
[    0.000000] Code: 00 b8 e4 85 99 c1 e8 31 be fc ff eb dd eb 0d 90 90 90 =
90 90 90 90 90 90 90 90 90 90 55 89 e5 57 56 53 89 c6 89 d7 e8 61 e8 ff ff =
<f6> 40 3a 02 89 c3 75 29 8b 40 14 8b 50 38 85 d2 75 3f 89 da 89
[    0.000000] EIP: [<c1068edf>] setup_irq+0xf/0x80 SS:ESP 0068:c1a91fa0
[    0.000000] CR2: 000000000000003a
[    0.000000] ---[ end trace 4d5ff9f2f68c4234 ]---
[    0.000000] Kernel panic - not syncing: Fatal exception

Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-09270045/f2bb95f78a694f575ef41a9f65c003ee934fc263/vmlinuz-3.17.0-rc6-0020=
8-gf2bb95f -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-=
09270045/linux-devel:devel-hourly-2014092700:f2bb95f78a694f575ef41a9f65c003=
ee934fc263:bisect-linux-0/.vmlinuz-f2bb95f78a694f575ef41a9f65c003ee934fc263=
-20140928184346-19-ivb41 branch=3Dlinux-devel/devel-hourly-2014092700 BOOT_=
IMAGE=3D/kernel/i386-randconfig-c1-09270045/f2bb95f78a694f575ef41a9f65c003e=
e934fc263/vmlinuz-3.17.0-rc6-00208-gf2bb95f drbd.minor_count=3D8'  -initrd =
/kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,=
model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i630=
0esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-83 -se=
rial file:/dev/shm/kboot/serial-quantal-ivb41-83 -daemonize -display none -=
monitor null=20

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-100:20140928184658:i386-randconfig-c1-09270045::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc6-00207-g9d24b89 (kbuild@cairo) (gcc =
version 4.9.1 (Debian 4.9.1-11) ) #1 Sun Sep 28 16:36:30 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02333000, 0x02333fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat c1c7e500, node_mem_map d2=
513020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1aa7280
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c1-09270045/linux-devel:devel-hourly-2014092700:9d24b890d00698320=
c804c335673a5a5dad177bb:bisect-linux-0/.vmlinuz-9d24b890d00698320c804c33567=
3a5a5dad177bb-20140928184457-54-ivb41 branch=3Dlinux-devel/devel-hourly-201=
4092700 BOOT_IMAGE=3D/kernel/i386-randconfig-c1-09270045/9d24b890d00698320c=
804c335673a5a5dad177bb/vmlinuz-3.17.0-rc6-00207-g9d24b89 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 279532K/327160K available (7560K kernel code, 2062K =
rwdata, 3244K rodata, 356K init, 6384K bss, 47628K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xfffe0000   ( 696 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc1c94000 - 0xc1ced000   ( 356 kB)
[    0.000000]       .data : 0xc176247f - 0xc1c92980   (5313 kB)
[    0.000000]       .text : 0xc1000000 - 0xc176247f   (7561 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0094000 soft=3Dc0096000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc6-00207-g9d24b89 (kbuild@cairo) (gcc =
version 4.9.1 (Debian 4.9.1-11) ) #1 Sun Sep 28 16:36:30 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02333000, 0x02333fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat c1c7e500, node_mem_map d2=
513020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1aa7280
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c1-09270045/linux-devel:devel-hourly-2014092700:9d24b890d00698320=
c804c335673a5a5dad177bb:bisect-linux-0/.vmlinuz-9d24b890d00698320c804c33567=
3a5a5dad177bb-20140928184457-54-ivb41 branch=3Dlinux-devel/devel-hourly-201=
4092700 BOOT_IMAGE=3D/kernel/i386-randconfig-c1-09270045/9d24b890d00698320c=
804c335673a5a5dad177bb/vmlinuz-3.17.0-rc6-00207-g9d24b89 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 279532K/327160K available (7560K kernel code, 2062K =
rwdata, 3244K rodata, 356K init, 6384K bss, 47628K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xfffe0000   ( 696 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc1c94000 - 0xc1ced000   ( 356 kB)
[    0.000000]       .data : 0xc176247f - 0xc1c92980   (5313 kB)
[    0.000000]       .text : 0xc1000000 - 0xc176247f   (7561 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0094000 soft=3Dc0096000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 5151 kB
[    0.000000]  memory used by lock dependency info: 5151 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140724
[    0.020000] ACPI: Core revision 20140724
[    0.024200] ACPI:=20
[    0.024200] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.025396] ACPI: setting ELCR to 0200 (from 0c00)
[    0.025396] ACPI: setting ELCR to 0200 (from 0c00)
[    0.026538] Security Framework initialized
[    0.026538] Security Framework initialized
[    0.027465] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.027465] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.028896] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.028896] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.030429] Initializing cgroup subsys freezer
[    0.030429] Initializing cgroup subsys freezer
[    0.031612] Initializing cgroup subsys blkio
[    0.031612] Initializing cgroup subsys blkio
[    0.032644] Initializing cgroup subsys debug
[    0.032644] Initializing cgroup subsys debug
[    0.033683] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033683] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.033683] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033683] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.036211] CPU:=20
[    0.036211] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.042804] Performance Events:=20
[    0.042804] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.046994] Getting VERSION: 1050014
[    0.046994] Getting VERSION: 1050014
[    0.047922] Getting VERSION: 1050014
[    0.047922] Getting VERSION: 1050014
[    0.048798] Getting ID: 0
[    0.048798] Getting ID: 0
[    0.049386] Getting ID: f000000
[    0.049386] Getting ID: f000000
[    0.050011] Getting LVT0: 8700
[    0.050011] Getting LVT0: 8700
[    0.050706] Getting LVT1: 8400
[    0.050706] Getting LVT1: 8400
[    0.051478] enabled ExtINT on CPU#0
[    0.051478] enabled ExtINT on CPU#0
[    0.052297] Using local APIC timer interrupts.
[    0.052297] calibrating APIC timer ...
[    0.052297] Using local APIC timer interrupts.
[    0.052297] calibrating APIC timer ...
[    0.060000] ... lapic delta =3D 6249438
[    0.060000] ... lapic delta =3D 6249438
[    0.060000] ... PM-Timer delta =3D 357919
[    0.060000] ... PM-Timer delta =3D 357919
[    0.060000] ... PM-Timer result ok
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6249438
[    0.060000] ..... delta 6249438
[    0.060000] ..... mult: 268411318
[    0.060000] ..... mult: 268411318
[    0.060000] ..... calibration result: 9999100
[    0.060000] ..... calibration result: 9999100
[    0.060000] ..... CPU clock speed is 2693.2425 MHz.
[    0.060000] ..... CPU clock speed is 2693.2425 MHz.
[    0.060000] ..... host bus clock speed is 999.9100 MHz.
[    0.060000] ..... host bus clock speed is 999.9100 MHz.
[    0.060149] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.060149] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.063553] xor: measuring software checksum speed
[    0.063553] xor: measuring software checksum speed
[    0.160012]    pIII_sse  :  2045.200 MB/sec
[    0.160012]    pIII_sse  :  2045.200 MB/sec
[    0.260007]    prefetch64-sse:  6497.200 MB/sec
[    0.260007]    prefetch64-sse:  6497.200 MB/sec
[    0.270006] xor: using function: prefetch64-sse (6497.200 MB/sec)
[    0.270006] xor: using function: prefetch64-sse (6497.200 MB/sec)
[    0.272546] prandom: seed boundary self test passed
[    0.272546] prandom: seed boundary self test passed
[    0.275676] prandom: 100 self tests passed
[    0.275676] prandom: 100 self tests passed
[    0.280014] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.280014] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.283061] regulator-dummy: no parameters
[    0.283061] regulator-dummy: no parameters
[    0.290366] NET: Registered protocol family 16
[    0.290366] NET: Registered protocol family 16
[    0.293518] cpuidle: using governor ladder
[    0.293518] cpuidle: using governor ladder
[    0.300019] cpuidle: using governor menu
[    0.300019] cpuidle: using governor menu
[    0.301865] ACPI: bus type PCI registered
[    0.301865] ACPI: bus type PCI registered
[    0.303479] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.303479] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.305829] PCI: Using configuration type 1 for base access
[    0.305829] PCI: Using configuration type 1 for base access
[    0.520023] raid6: mmxx1     1548 MB/s
[    0.520023] raid6: mmxx1     1548 MB/s
[    0.700022] raid6: mmxx2     1894 MB/s
[    0.700022] raid6: mmxx2     1894 MB/s
[    0.870025] raid6: sse1x1    1446 MB/s
[    0.870025] raid6: sse1x1    1446 MB/s
[    1.040012] raid6: sse1x2    1333 MB/s
[    1.040012] raid6: sse1x2    1333 MB/s
[    1.210013] raid6: sse2x1    2063 MB/s
[    1.210013] raid6: sse2x1    2063 MB/s
[    1.380011] raid6: sse2x2    2332 MB/s
[    1.380011] raid6: sse2x2    2332 MB/s
[    1.382139] raid6: using algorithm sse2x2 (2332 MB/s)
[    1.382139] raid6: using algorithm sse2x2 (2332 MB/s)
[    1.384541] raid6: using intx1 recovery algorithm
[    1.384541] raid6: using intx1 recovery algorithm
[    1.388209] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.388209] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.392243] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.392243] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.401570] ACPI: Added _OSI(Module Device)
[    1.401570] ACPI: Added _OSI(Module Device)
[    1.405805] ACPI: Added _OSI(Processor Device)
[    1.405805] ACPI: Added _OSI(Processor Device)
[    1.410006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.410006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.414576] ACPI: Added _OSI(Processor Aggregator Device)
[    1.414576] ACPI: Added _OSI(Processor Aggregator Device)
[    1.440341] ACPI: Interpreter enabled
[    1.440341] ACPI: Interpreter enabled
[    1.442436] ACPI: (supports S0 S4 S5)
[    1.442436] ACPI: (supports S0 S4 S5)
[    1.444520] ACPI: Using PIC for interrupt routing
[    1.444520] ACPI: Using PIC for interrupt routing
[    1.448143] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.448143] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.488747] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.488747] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.490015] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.490015] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.493726] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.493726] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.500283] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.500283] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.511424] PCI host bridge to bus 0000:00
[    1.511424] PCI host bridge to bus 0000:00
[    1.513793] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.513793] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.520008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.520008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.526903] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.526903] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.530007] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.530007] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.533956] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.533956] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.540006] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.540006] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.550006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.550006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.560007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.560007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.570100] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.570100] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.590495] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.590495] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.603515] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.603515] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.626539] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.626539] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.632350] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.632350] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.640005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.640005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.650006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.650006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.655779] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.655779] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.661026] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.661026] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.670415] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.670415] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.677940] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.677940] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.680579] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.680579] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.691807] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.691807] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.700016] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.700016] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.715204] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.715204] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.720502] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.720502] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.724426] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.724426] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.729398] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.729398] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.740007] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.740007] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.746466] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.746466] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.751021] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.751021] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.768732] pci_bus 0000:00: on NUMA node 0
[    1.768732] pci_bus 0000:00: on NUMA node 0
[    1.773270] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.773270] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.780114] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.780114] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.786207] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.786207] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.790219] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.790219] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.795079] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.795079] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.803673] ACPI:=20
[    1.803673] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.813819] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.813819] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.820000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.820000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.820007] vgaarb: loaded
[    1.820007] vgaarb: loaded
[    1.830003] vgaarb: bridge control possible 0000:00:02.0
[    1.830003] vgaarb: bridge control possible 0000:00:02.0
[    1.840734] SCSI subsystem initialized
[    1.840734] SCSI subsystem initialized
[    1.844299] libata version 3.00 loaded.
[    1.844299] libata version 3.00 loaded.
[    1.848033] pps_core: LinuxPPS API ver. 1 registered
[    1.848033] pps_core: LinuxPPS API ver. 1 registered
[    1.850003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.850003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.860384] Advanced Linux Sound Architecture Driver Initialized.
[    1.860384] Advanced Linux Sound Architecture Driver Initialized.
[    1.865287] PCI: Using ACPI for IRQ routing
[    1.865287] PCI: Using ACPI for IRQ routing
[    1.869190] PCI: pci_cache_line_size set to 64 bytes
[    1.869190] PCI: pci_cache_line_size set to 64 bytes
[    1.870329] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.870329] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.880008] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.880008] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.887129] Switched to clocksource kvm-clock
[    1.887129] Switched to clocksource kvm-clock
[    1.887129] FS-Cache: Loaded
[    1.887129] FS-Cache: Loaded
[    1.887129] CacheFiles: Loaded
[    1.887129] CacheFiles: Loaded
[    1.888574] pnp: PnP ACPI init
[    1.888574] pnp: PnP ACPI init
[    1.891828] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.891828] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.896928] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.896928] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.901120] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.901120] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.906864] pnp 00:03: [dma 2]
[    1.906864] pnp 00:03: [dma 2]
[    1.908883] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.908883] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.914974] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.914974] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.920688] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.920688] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.930718] pnp: PnP ACPI: found 6 devices
[    1.930718] pnp: PnP ACPI: found 6 devices
[    1.975607] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.975607] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.981179] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.981179] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.988529] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.988529] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.991034] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.991034] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.996040] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.996040] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    2.000625] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    2.000625] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    2.005698] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    2.005698] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    2.009726] NET: Registered protocol family 1
[    2.009726] NET: Registered protocol family 1
[    2.015556] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.015556] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.018708] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.018708] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.025562] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.025562] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.031606] pci 0000:00:02.0: Video device with shadowed ROM
[    2.031606] pci 0000:00:02.0: Video device with shadowed ROM
[    2.036181] PCI: CLS 0 bytes, default 64
[    2.036181] PCI: CLS 0 bytes, default 64
[    2.040980] Unpacking initramfs...
[    2.040980] Unpacking initramfs...
[    5.278571] Freeing initrd memory: 24852K (d2793000 - d3fd8000)
[    5.278571] Freeing initrd memory: 24852K (d2793000 - d3fd8000)
[    5.280980] apm: BIOS not found.
[    5.280980] apm: BIOS not found.
[    5.292030] Scanning for low memory corruption every 60 seconds
[    5.292030] Scanning for low memory corruption every 60 seconds
[    5.293968] PCLMULQDQ-NI instructions are not detected.
[    5.293968] PCLMULQDQ-NI instructions are not detected.
[    5.295261] NatSemi SCx200 Driver
[    5.295261] NatSemi SCx200 Driver
[    5.296274] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    5.296274] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    5.313898] rcu-torture: Creating rcu_torture_writer task
[    5.313898] rcu-torture: Creating rcu_torture_writer task
[    5.315375] rcu-torture: Creating rcu_torture_fakewriter task
[    5.315375] rcu-torture: Creating rcu_torture_fakewriter task
[    5.316831] rcu-torture: rcu_torture_writer task started
[    5.316831] rcu-torture: rcu_torture_writer task started
[    5.318146] rcu-torture: Creating rcu_torture_fakewriter task
[    5.318146] rcu-torture: Creating rcu_torture_fakewriter task
[    5.319697] rcu-torture: rcu_torture_fakewriter task started
[    5.319697] rcu-torture: rcu_torture_fakewriter task started
[    5.321228] rcu-torture: Creating rcu_torture_fakewriter task
[    5.321228] rcu-torture: Creating rcu_torture_fakewriter task
[    5.330056] rcu-torture: rcu_torture_fakewriter task started
[    5.330056] rcu-torture: rcu_torture_fakewriter task started
[    5.331426] rcu-torture: Creating rcu_torture_fakewriter task
[    5.331426] rcu-torture: Creating rcu_torture_fakewriter task
[    5.332888] rcu-torture: rcu_torture_fakewriter task started
[    5.332888] rcu-torture: rcu_torture_fakewriter task started
[    5.334361] rcu-torture: Creating rcu_torture_reader task
[    5.334361] rcu-torture: Creating rcu_torture_reader task
[    5.335739] rcu-torture: rcu_torture_fakewriter task started
[    5.335739] rcu-torture: rcu_torture_fakewriter task started
[    5.337151] rcu-torture: Creating rcu_torture_stats task
[    5.337151] rcu-torture: Creating rcu_torture_stats task
[    5.348389] rcu-torture: rcu_torture_reader task started
[    5.348389] rcu-torture: rcu_torture_reader task started
[    5.349735] rcu-torture: Creating torture_shuffle task
[    5.349735] rcu-torture: Creating torture_shuffle task
[    5.351375] rcu-torture: rcu_torture_stats task started
[    5.351375] rcu-torture: rcu_torture_stats task started
[    5.352709] rcu-torture: Creating torture_stutter task
[    5.352709] rcu-torture: Creating torture_stutter task
[    5.354093] rcu-torture: torture_shuffle task started
[    5.354093] rcu-torture: torture_shuffle task started
[    5.356167] futex hash table entries: 16 (order: -3, 832 bytes)
[    5.356167] futex hash table entries: 16 (order: -3, 832 bytes)
[    5.358008] rcu-torture: torture_stutter task started
[    5.358008] rcu-torture: torture_stutter task started
[    5.359376] zpool: loaded
[    5.359376] zpool: loaded
[    5.373090] zbud: loaded
[    5.373090] zbud: loaded
[    5.373981] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    5.373981] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    5.375562] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    5.375562] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    5.376881] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.376881] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.378184] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.378184] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.379404] QNX4 filesystem 0.2.3 registered.
[    5.379404] QNX4 filesystem 0.2.3 registered.
[    5.380566] fuse init (API version 7.23)
[    5.380566] fuse init (API version 7.23)
[    5.381837] SGI XFS with ACLs, security attributes, no debug enabled
[    5.381837] SGI XFS with ACLs, security attributes, no debug enabled
[    5.383761] NILFS version 2 loaded
[    5.383761] NILFS version 2 loaded
[    5.384646] befs: version: 0.9.3
[    5.384646] befs: version: 0.9.3
[    5.406018] gfs2: GFS2 installed
[    5.406018] gfs2: GFS2 installed
[    5.409625] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    5.409625] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    5.411439] io scheduler noop registered
[    5.411439] io scheduler noop registered
[    5.412465] io scheduler deadline registered (default)
[    5.412465] io scheduler deadline registered (default)
[    5.413784] start plist test
[    5.413784] start plist test
[    5.427127] end plist test
[    5.427127] end plist test
[    5.428465] test_firmware: interface ready
[    5.428465] test_firmware: interface ready
[    5.429740] xz_dec_test: module loaded
[    5.429740] xz_dec_test: module loaded
[    5.430700] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    5.430700] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    5.442288] glob: 64 self-tests passed, 0 failed
[    5.442288] glob: 64 self-tests passed, 0 failed
[    5.443466] rbtree testing
[    5.443466] rbtree testing -> 14635 cycles
 -> 14635 cycles
[    6.025535] augmented rbtree testing
[    6.025535] augmented rbtree testing -> 19144 cycles
 -> 19144 cycles
[    6.789766] no IO addresses supplied
[    6.789766] no IO addresses supplied
[    6.790879] hgafb: HGA card not detected.
[    6.790879] hgafb: HGA card not detected.
[    6.791809] hgafb: probe of hgafb.0 failed with error -22
[    6.791809] hgafb: probe of hgafb.0 failed with error -22
[    6.794197] ipmi message handler version 39.2
[    6.794197] ipmi message handler version 39.2
[    6.795298] ipmi device interface
[    6.795298] ipmi device interface
[    6.796192] IPMI System Interface driver.
[    6.796192] IPMI System Interface driver.
[    6.797354] ipmi_si: Unable to find any System Interface(s)
[    6.797354] ipmi_si: Unable to find any System Interface(s)
[    6.798635] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    6.798635] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    6.800876] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.800876] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.802569] ACPI: Power Button [PWRF]
[    6.802569] ACPI: Power Button [PWRF]
[    6.804362] tsc: Refined TSC clocksource calibration: 2693.509 MHz
[    6.804362] tsc: Refined TSC clocksource calibration: 2693.509 MHz
[    6.864610] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.864610] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.867033] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.867033] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.955918] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.955918] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.959556] serial: Freescale lpuart driver
[    6.959556] serial: Freescale lpuart driver
[    6.960973] lp: driver loaded but no devices found
[    6.960973] lp: driver loaded but no devices found
[    6.962266] Non-volatile memory driver v1.3
[    6.962266] Non-volatile memory driver v1.3
[    6.963392] toshiba: not a supported Toshiba laptop
[    6.963392] toshiba: not a supported Toshiba laptop
[    6.964677] scx200_gpio: no SCx200 gpio present
[    6.964677] scx200_gpio: no SCx200 gpio present
[    6.987869] nsc_gpio initializing
[    6.987869] nsc_gpio initializing
[    6.988736] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.988736] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.990090] smapi::smapi_init, ERROR invalid usSmapiID
[    6.990090] smapi::smapi_init, ERROR invalid usSmapiID
[    6.991361] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    6.991361] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    6.993713] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    6.993713] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    6.995576] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.995576] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    7.015394] [drm] Initialized drm 1.1.0 20060810
[    7.015394] [drm] Initialized drm 1.1.0 20060810
[    7.017133] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    7.017133] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    7.019224] c2port c2port0: C2 port uc added
[    7.019224] c2port c2port0: C2 port uc added
[    7.020334] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    7.020334] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    7.041022] Uniform Multi-Platform E-IDE driver
[    7.041022] Uniform Multi-Platform E-IDE driver
[    7.042788] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    7.042788] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    7.045469] emc: device handler registered
[    7.045469] emc: device handler registered
[    7.046387] alua: device handler registered
[    7.046387] alua: device handler registered
[    7.047318] osst :I: Tape driver with OnStream support version 0.99.4
[    7.047318] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.047318] osst :I: Tape driver with OnStream support version 0.99.4
[    7.047318] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.068428] SCSI Media Changer driver v0.25=20
[    7.068428] SCSI Media Changer driver v0.25=20
[    7.069574] osd: LOADED open-osd 0.2.1
[    7.069574] osd: LOADED open-osd 0.2.1
[    7.070956] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    7.070956] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    7.073098] SSFDC read-only Flash Translation layer
[    7.073098] SSFDC read-only Flash Translation layer
[    7.074221] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    7.074221] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    7.098089] ftl_cs: FTL header not found.
[    7.098089] ftl_cs: FTL header not found.
[    7.198796] No valid DiskOnChip devices found
[    7.198796] No valid DiskOnChip devices found
[    7.199889] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.199889] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.202119] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.202119] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.204470] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.204470] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.224819] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.224819] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.227025] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.227025] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.229342] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.229342] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.231631] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    7.231631] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    7.251108] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    7.251108] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    7.252228] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    7.252228] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    7.253733] flash size: 128 MiB
[    7.253733] flash size: 128 MiB
[    7.254549] page size: 512 bytes
[    7.254549] page size: 512 bytes
[    7.255335] OOB area size: 16 bytes
[    7.255335] OOB area size: 16 bytes
[    7.256086] sector size: 16 KiB
[    7.256086] sector size: 16 KiB
[    7.256775] pages number: 262144
[    7.256775] pages number: 262144
[    7.257488] pages per sector: 32
[    7.257488] pages per sector: 32
[    7.258206] bus width: 8
[    7.258206] bus width: 8
[    7.258737] bits in sector size: 14
[    7.258737] bits in sector size: 14
[    7.259514] bits in page size: 9
[    7.259514] bits in page size: 9
[    7.278279] bits in OOB size: 4
[    7.278279] bits in OOB size: 4
[    7.278952] flash size with OOB: 135168 KiB
[    7.278952] flash size with OOB: 135168 KiB
[    7.279875] page address bytes: 4
[    7.279875] page address bytes: 4
[    7.280612] sector address bytes: 3
[    7.280612] sector address bytes: 3
[    7.281428] options: 0x42
[    7.281428] options: 0x42
[    7.282553] Scanning device for bad blocks
[    7.282553] Scanning device for bad blocks
[    7.385934] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    7.385934] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    7.387503] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    7.387503] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    7.389951] ftl_cs: FTL header not found.
[    7.389951] ftl_cs: FTL header not found.
[    7.391933] HSI/SSI char device loaded
[    7.391933] HSI/SSI char device loaded
[    7.393088] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    7.393088] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    7.414036] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.414036] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.415262] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.415262] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.416514] parkbd: no such parport
[    7.416514] parkbd: no such parport
[    7.417900] mousedev: PS/2 mouse device common for all mice
[    7.417900] mousedev: PS/2 mouse device common for all mice
[    7.419545] i2c-parport-light: adapter type unspecified
[    7.419545] i2c-parport-light: adapter type unspecified
[    7.421008] pps pps0: new PPS source ktimer
[    7.421008] pps pps0: new PPS source ktimer
[    7.439994] pps pps0: ktimer PPS source registered
[    7.439994] pps pps0: ktimer PPS source registered
[    7.441162] pps_parport: parallel port PPS client
[    7.441162] pps_parport: parallel port PPS client
[    7.443328] f71882fg: Not a Fintek device
[    7.443328] f71882fg: Not a Fintek device
[    7.444346] f71882fg: Not a Fintek device
[    7.444346] f71882fg: Not a Fintek device
[    7.447990] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    7.447990] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    7.467705] cpufreq-nforce2: No nForce2 chipset.
[    7.467705] cpufreq-nforce2: No nForce2 chipset.
[    7.468830] sdhci: Secure Digital Host Controller Interface driver
[    7.468830] sdhci: Secure Digital Host Controller Interface driver
[    7.470211] sdhci: Copyright(c) Pierre Ossman
[    7.470211] sdhci: Copyright(c) Pierre Ossman
[    7.471151] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    7.471151] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    7.472486] wbsd: Copyright(c) Pierre Ossman
[    7.472486] wbsd: Copyright(c) Pierre Ossman
[    7.473633] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.473633] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.475575] panel: driver version 0.9.5 not yet registered
[    7.475575] panel: driver version 0.9.5 not yet registered
[    7.496211] dgap-1.3-16, Digi International Part Number 40002347_C
[    7.496211] dgap-1.3-16, Digi International Part Number 40002347_C
[    7.497735] For the tools package please visit http://www.digi.com
[    7.497735] For the tools package please visit http://www.digi.com
[    7.499657] FPGA DOWNLOAD --->
[    7.499657] FPGA DOWNLOAD --->
[    7.500490] FPGA image file name: xlinx_fpga_firmware.bit
[    7.500490] FPGA image file name: xlinx_fpga_firmware.bit
[    7.501945] GPIO INIT FAIL!!
[    7.501945] GPIO INIT FAIL!!
[    7.523371]  fake-fmc-carrier: mezzanine 0
[    7.523371]  fake-fmc-carrier: mezzanine 0
[    7.524424]       Manufacturer: fake-vendor
[    7.524424]       Manufacturer: fake-vendor
[    7.525464]       Product name: fake-design-for-testing
[    7.525464]       Product name: fake-design-for-testing
[    7.526885] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.526885] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.528634] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    7.528634] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    7.548757] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.548757] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.550589] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    7.550589] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    7.553160] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.553160] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.554966] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    7.554966] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    7.581386] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    7.581386] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    7.603767] ... APIC ID:      00000000 (0)
[    7.603767] ... APIC ID:      00000000 (0)
[    7.604845] ... APIC VERSION: 01050014
[    7.604845] ... APIC VERSION: 01050014
[    7.605770] 00000000
[    7.605770] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    7.607638] 00000000
[    7.607638] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    7.609541] 00000000
[    7.609541] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    7.611776]=20
[    7.611776]=20
[    7.629897] Using IPI Shortcut mode
[    7.629897] Using IPI Shortcut mode
[    7.631152] bootconsole [earlyser0] disabled
[    7.631152] bootconsole [earlyser0] disabled
[    7.633702] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    7.637732] Btrfs loaded, debug=3Don, integrity-checker=3Don
[    7.656485] BTRFS: selftest: Running btrfs free space cache tests
[    7.657208] BTRFS: selftest: Running extent only tests
[    7.657808] BTRFS: selftest: Running bitmap only tests
[    7.658461] BTRFS: selftest: Running bitmap and extent tests
[    7.659167] BTRFS: selftest: Free space cache tests finished
[    7.659812] BTRFS: selftest: Running extent buffer operation tests
[    7.660528] BTRFS: selftest: Running btrfs_split_item tests
[    7.661298] BTRFS: selftest: Running find delalloc tests
[    8.337320] kworker/0:1 invoked oom-killer: gfp_mask=3D0x2040d0, order=
=3D0, oom_score_adj=3D0
[    8.340464] kworker/0:1 cpuset=3D/ mems_allowed=3D0
[    8.343293] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 3.17.0-rc6-0020=
7-g9d24b89 #1
[    8.346384] Workqueue: events_long serio_handle_event
[    8.347068]  c0136390 c0136390 d1c01b58 c175a430 d1c01ba0 c109ff5c c199b=
364 c01365ec
[    8.352411]  002040d0 00000000 00000000 1660b381 c1bebd48 00000006 c0136=
390 d1c01ba0
[    8.355610]  00000286 00000000 00000286 d30ae7b0 00000000 002040d0 d1c01=
bd8 c10a0a45
[    8.357786] Call Trace:
[    8.360253]  [<c175a430>] dump_stack+0x16/0x18
[    8.360767]  [<c109ff5c>] dump_header+0x6c/0x210
[    8.364540]  [<c10a0a45>] out_of_memory+0x2e5/0x2f0
[    8.366273]  [<c10a4632>] __alloc_pages_nodemask+0x912/0x930
[    8.366915]  [<c10cbf1a>] cache_alloc_refill+0x2ca/0x620
[    8.369691]  [<c10cb5da>] ? cache_alloc_debugcheck_after+0x19a/0x230
[    8.372676]  [<c10275e0>] ? native_restore_fl+0x10/0x10
[    8.376463]  [<c10cbbf4>] kmem_cache_alloc+0x144/0x1a0
[    8.380252]  [<c11132c6>] ? __kernfs_new_node+0x46/0xc0
[    8.380877]  [<c11132c6>] __kernfs_new_node+0x46/0xc0
[    8.383638]  [<c11143fd>] kernfs_new_node+0x1d/0x40
[    8.385385]  [<c1115af6>] kernfs_create_link+0x16/0x70
[    8.386030]  [<c1116553>] sysfs_do_create_link_sd+0x43/0xb0
[    8.387914]  [<c11165e8>] sysfs_create_link+0x18/0x40
[    8.390375]  [<c14bf3e9>] device_add+0x279/0x580
[    8.390895]  [<c10cb5da>] ? cache_alloc_debugcheck_after+0x19a/0x230
[    8.392864]  [<c10cc41a>] ? __kmalloc+0x1aa/0x1c0
[    8.394627]  [<c15e326d>] input_register_device+0x2ad/0x470
[    8.396496]  [<c15e326d>] ? input_register_device+0x2ad/0x470
[    8.398328]  [<c15ea1dc>] psmouse_connect+0x1dc/0x2c0
[    8.398892]  [<c15ea1dc>] ? psmouse_connect+0x1dc/0x2c0
[    8.400734]  [<c15db1f0>] serio_connect_driver+0x20/0x30
[    8.402575]  [<c15db216>] serio_driver_probe+0x16/0x20
[    8.404364]  [<c14c2867>] driver_probe_device+0x87/0x360
[    8.404952]  [<c14c2b71>] __device_attach+0x31/0x40
[    8.406757]  [<c14c2b40>] ? driver_probe_device+0x360/0x360
[    8.408613]  [<c14c2b71>] ? __device_attach+0x31/0x40
[    8.410408]  [<c14c13c7>] bus_for_each_drv+0x47/0x80
[    8.410965]  [<c14c2c7c>] device_attach+0x7c/0x90
[    8.412671]  [<c14c2b40>] ? driver_probe_device+0x360/0x360
[    8.416487]  [<c14c1657>] bus_probe_device+0x77/0xa0
[    8.419208]  [<c14bf5e2>] device_add+0x472/0x580
[    8.419753]  [<c15dbc01>] ? serio_handle_event+0x51/0x1b0
[    8.421551]  [<c15dbc94>] serio_handle_event+0xe4/0x1b0
[    8.424333]  [<c15dbc94>] ? serio_handle_event+0xe4/0x1b0
[    8.424935]  [<c10445d8>] ? process_one_work+0xf8/0x390
[    8.427705]  [<c104462e>] process_one_work+0x14e/0x390
[    8.430493]  [<c10445d8>] ? process_one_work+0xf8/0x390
[    8.433279]  [<c10448a9>] worker_thread+0x39/0x440
[    8.433824]  [<c1044870>] ? process_one_work+0x390/0x390
[    8.437598]  [<c1048f54>] kthread+0xb4/0xd0
[    8.440261]  [<c1760f00>] ret_from_kernel_thread+0x20/0x30
[    8.440887]  [<c1048ea0>] ? __kthread_parkme+0x60/0x60
[    8.442639] Mem-Info:
[    8.442909] Normal per-cpu:
[    8.446416] CPU    0: hi:   90, btch:  15 usd:  14
[    8.446958] active_anon:0 inactive_anon:0 isolated_anon:0
[    8.446958]  active_file:2010 inactive_file:51513 isolated_file:0
[    8.446958]  unevictable:17874 dirty:0 writeback:0 unstable:0
[    8.446958]  free:545 slab_reclaimable:1419 slab_unreclaimable:976
[    8.446958]  mapped:0 shmem:0 pagetables:0 bounce:0
[    8.446958]  free_cma:0
[    8.456699] Normal free:2180kB min:2204kB low:2752kB high:3304kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:206052kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:304384kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:5676kB slab_unreclaimable:3904kB kernel_stack:336kB pagetables:0k=
B unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:1374=
268 all_unreclaimable? yes
[    8.468585] lowmem_reserve[]: 0 0
[    8.469013] Normal: 1*4kB (R) 0*8kB 0*16kB 0*32kB 0*64kB 1*128kB (R) 0*2=
56kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2180kB
[    8.472972] 71397 total pagecache pages
[    8.474592] 0 pages in swap cache
[    8.474970] Swap cache stats: add 0, delete 0, find 0/0
[    8.476735] Free swap  =3D 0kB
[    8.479241] Total swap =3D 0kB
[    8.479624] 81790 pages RAM
[    8.480016] 0 pages HighMem/MovableOnly
[    8.483688] 5694 pages reserved
[    8.486277] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_s=
core_adj name
[    8.488874] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[    8.488874]=20
[    8.490010] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 3.17.0-rc6-0020=
7-g9d24b89 #1
[    8.490010] Workqueue: events_long serio_handle_event
[    8.490010]  d30ae7b0 d30ae7b0 d1c01b84 c175a430 d1c01b9c c1758840 00000=
000 d30ae7b0
[    8.490010]  00000000 002040d0 d1c01bd8 c10a0a4f c199b53c 00000000 00204=
0d0 d30a8310
[    8.490010]  00000000 00000000 00012940 00000000 00000000 c1a991f0 c1c7e=
b18 00000000
[    8.490010] Call Trace:
[    8.490010]  [<c175a430>] dump_stack+0x16/0x18
[    8.490010]  [<c1758840>] panic+0x87/0x1a2
[    8.490010]  [<c10a0a4f>] out_of_memory+0x2ef/0x2f0
[    8.490010]  [<c10a4632>] __alloc_pages_nodemask+0x912/0x930
[    8.490010]  [<c10cbf1a>] cache_alloc_refill+0x2ca/0x620
[    8.490010]  [<c10cb5da>] ? cache_alloc_debugcheck_after+0x19a/0x230
[    8.490010]  [<c10275e0>] ? native_restore_fl+0x10/0x10
[    8.490010]  [<c10cbbf4>] kmem_cache_alloc+0x144/0x1a0
[    8.490010]  [<c11132c6>] ? __kernfs_new_node+0x46/0xc0
[    8.490010]  [<c11132c6>] __kernfs_new_node+0x46/0xc0
[    8.490010]  [<c11143fd>] kernfs_new_node+0x1d/0x40
[    8.490010]  [<c1115af6>] kernfs_create_link+0x16/0x70
[    8.490010]  [<c1116553>] sysfs_do_create_link_sd+0x43/0xb0
[    8.490010]  [<c11165e8>] sysfs_create_link+0x18/0x40
[    8.490010]  [<c14bf3e9>] device_add+0x279/0x580
[    8.490010]  [<c10cb5da>] ? cache_alloc_debugcheck_after+0x19a/0x230
[    8.490010]  [<c10cc41a>] ? __kmalloc+0x1aa/0x1c0
[    8.490010]  [<c15e326d>] input_register_device+0x2ad/0x470
[    8.490010]  [<c15e326d>] ? input_register_device+0x2ad/0x470
[    8.490010]  [<c15ea1dc>] psmouse_connect+0x1dc/0x2c0
[    8.490010]  [<c15ea1dc>] ? psmouse_connect+0x1dc/0x2c0
[    8.490010]  [<c15db1f0>] serio_connect_driver+0x20/0x30
[    8.490010]  [<c15db216>] serio_driver_probe+0x16/0x20
[    8.490010]  [<c14c2867>] driver_probe_device+0x87/0x360
[    8.490010]  [<c14c2b71>] __device_attach+0x31/0x40
[    8.490010]  [<c14c2b40>] ? driver_probe_device+0x360/0x360
[    8.490010]  [<c14c2b71>] ? __device_attach+0x31/0x40
[    8.490010]  [<c14c13c7>] bus_for_each_drv+0x47/0x80
[    8.490010]  [<c14c2c7c>] device_attach+0x7c/0x90
[    8.490010]  [<c14c2b40>] ? driver_probe_device+0x360/0x360
[    8.490010]  [<c14c1657>] bus_probe_device+0x77/0xa0
[    8.490010]  [<c14bf5e2>] device_add+0x472/0x580
[    8.490010]  [<c15dbc01>] ? serio_handle_event+0x51/0x1b0
[    8.490010]  [<c15dbc94>] serio_handle_event+0xe4/0x1b0
[    8.490010]  [<c15dbc94>] ? serio_handle_event+0xe4/0x1b0
[    8.490010]  [<c10445d8>] ? process_one_work+0xf8/0x390
[    8.490010]  [<c104462e>] process_one_work+0x14e/0x390
[    8.490010]  [<c10445d8>] ? process_one_work+0xf8/0x390
[    8.490010]  [<c10448a9>] worker_thread+0x39/0x440
[    8.490010]  [<c1044870>] ? process_one_work+0x390/0x390
[    8.490010]  [<c1048f54>] kthread+0xb4/0xd0
[    8.490010]  [<c1760f00>] ret_from_kernel_thread+0x20/0x30
[    8.490010]  [<c1048ea0>] ? __kthread_parkme+0x60/0x60
[    8.490010] Kernel Offset: 0x0 from 0xc1000000 (relocation range: 0xc000=
0000-0xd47dffff)

Elapsed time: 25
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-09270045/9d24b890d00698320c804c335673a5a5dad177bb/vmlinuz-3.17.0-rc6-0020=
7-g9d24b89 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-=
09270045/linux-devel:devel-hourly-2014092700:9d24b890d00698320c804c335673a5=
a5dad177bb:bisect-linux-0/.vmlinuz-9d24b890d00698320c804c335673a5a5dad177bb=
-20140928184457-54-ivb41 branch=3Dlinux-devel/devel-hourly-2014092700 BOOT_=
IMAGE=3D/kernel/i386-randconfig-c1-09270045/9d24b890d00698320c804c335673a5a=
5dad177bb/vmlinuz-3.17.0-rc6-00207-g9d24b89 drbd.minor_count=3D8'  -initrd =
/kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,=
model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i630=
0esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-100 -s=
erial file:/dev/shm/kboot/serial-quantal-ivb41-100 -daemonize -display none=
 -monitor null=20

--R3G7APHDIzY6R/pk
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c1-09270045-fe34ad1c7f6455ab6827d4cc84224b7f57eec1eb-WARNING:---at----warn_pre_alternatives+-x-34281.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZmUzNGFkMS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA5MjcwMCcKZ2l0IGNoZWNrb3V0IDBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0
ZGM0ZmQwMWE3ODUxYjZkNTEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA5MjcwMDowZjMzYmUwMDliODlkMjI2OGU5NDE5NGRjNGZkMDFhNzg1MWI2ZDUxOmJpc2Vj
dC1saW51eC0wCgoyMDE0LTA5LTI4IDEzOjU3OjE3IDBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0
ZGM0ZmQwMWE3ODUxYjZkNTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
LTBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS8wZjMzYmUwMDli
ODlkMjI2OGU5NDE5NGRjNGZkMDFhNzg1MWI2ZDUxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby1zbW9rZS9pMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDUtMGYzM2JlMDA5Yjg5ZDIyNjhlOTQxOTRkYzRmZDAxYTc4NTFiNmQ1
MQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzBmMzNiZTAw
OWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEvdm1saW51ei0zLjE3LjAtcmM2Cgoy
MDE0LTA5LTI4IDEzOjU5OjE3IGRldGVjdGluZyBib290IHN0YXRlIAkzLgk4CTIwIFNVQ0NF
U1MKCmJpc2VjdDogZ29vZCBjb21taXQgMGYzM2JlMDA5Yjg5ZDIyNjhlOTQxOTRkYzRmZDAx
YTc4NTFiNmQ1MQpnaXQgYmlzZWN0IHN0YXJ0IGZlMzRhZDFjN2Y2NDU1YWI2ODI3ZDRjYzg0
MjI0YjdmNTdlZWMxZWIgMGYzM2JlMDA5Yjg5ZDIyNjhlOTQxOTRkYzRmZDAxYTc4NTFiNmQ1
MSAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJmZTM0YWQxYzdm
NjQ1NWFiNjgyN2Q0Y2M4NDIyNGI3ZjU3ZWVjMWViIiwgIi1nIiwgIjBmMzNiZTAwOWI4OWQy
MjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9ib290LWJpc2VjdC9saW51eC0wL29iai1iaXNl
Y3QiXQpCaXNlY3Rpbmc6IDIwMzggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDExIHN0ZXBzKQpbYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEz
ZjhhNmQwYV0gTWVyZ2UgJ2FybS1zb2Mvc3VueGkvcnRjJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDkyNzAwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0wL29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MjcwMDphM2YyOGJkNGMyMjA4OTdkNThjYmEz
MjUyMDlkNjQ2MTNmOGE2ZDBhOmJpc2VjdC1saW51eC0wCgoyMDE0LTA5LTI4IDE0OjAxOjE4
IGEzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4YTZkMGEgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LWEzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2
NDYxM2Y4YTZkMGEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wOTI3MDA0NS9hM2YyOGJkNGMyMjA4OTdkNThjYmEzMjUyMDlkNjQ2MTNmOGE2ZDBh
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9j
YWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtYTNmMjhiZDRjMjIwODk3ZDU4Y2Jh
MzI1MjA5ZDY0NjEzZjhhNmQwYQobWzE7MzVtMjAxNC0wOS0yOCAxNDowMzoxOCBObyBidWls
ZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDUtYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQw
YRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3
MDA0NS1hM2YyOGJkNGMyMjA4OTdkNThjYmEzMjUyMDlkNjQ2MTNmOGE2ZDBhCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYTNmMjhiZDRjMjIwODk3ZDU4
Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS92bWxpbnV6LTMuMTcuMC1yYzYtMDEzODYtZ2EzZjI4
YmQKCjIwMTQtMDktMjggMTQ6MDU6MTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZB
SUxVUkUKWyAgICAwLjAwMDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBwcm9jZXNzb3IgaG9ub3Vy
cyB0aGUgV1AgYml0IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4uT2suClsgICAgMC4wMDAw
MDBdIE5SX0lSUVM6MTYgbnJfaXJxczoxNiAwClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0t
LVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBDUFU6
IDAgUElEOiAwIGF0IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQzMCB3YXJuX3By
ZV9hbHRlcm5hdGl2ZXMrMHgxNy8weDIwKCkKWyAgICAwLjAwMDAwMF0gWW91J3JlIHVzaW5n
IHN0YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4hClsgICAgMC4w
MDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3LjAt
cmM2LTAxMzg2LWdhM2YyOGJkICMxClsgICAgMC4wMDAwMDBdICBjMWE5N2VhYyBjMWE5N2Vh
YyBjMWE5N2U4MCBjMTc1YmNmMCBjMWE5N2U5YyBjMTAzNGRmNyAwMDAwMDU5NiBjMTAwZmI4
NwpbICAgIDAuMDAwMDAwXSAgMDAwMDAwM2EgYzFhOTdmNjQgYzEwMjcxNzAgYzFhOTdlYjQg
YzEwMzRlNjYgMDAwMDAwMDkgYzFhOTdlYWMgYzE5OTNmNDgKWyAgICAwLjAwMDAwMF0gIGMx
YTk3ZWM4IGMxYTk3ZWM4IGMxMDBmYjg3IGMxOTkzZWY4IDAwMDAwNTk2IGMxOTkzZjQ4IGMx
YTk3ZjQ0IGMxMDI5YmZkClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGMxNzViY2YwPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAwLjAwMDAwMF0g
IFs8YzEwMzRkZjc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDU3LzB4NzAKWyAgICAwLjAw
MDAwMF0gIFs8YzEwMGZiODc+XSA/IHdhcm5fcHJlX2FsdGVybmF0aXZlcysweDE3LzB4MjAK
WyAgICAwLjAwMDAwMF0gIFs8YzEwMjcxNzA+XSA/IGt2bV9yZWFkX2FuZF9yZXNldF9wZl9y
ZWFzb24rMHgyMC8weDIwClsgICAgMC4wMDAwMDBdICBbPGMxMDM0ZTY2Pl0gd2Fybl9zbG93
cGF0aF9mbXQrMHgyNi8weDMwClsgICAgMC4wMDAwMDBdICBbPGMxMDBmYjg3Pl0gd2Fybl9w
cmVfYWx0ZXJuYXRpdmVzKzB4MTcvMHgyMApbICAgIDAuMDAwMDAwXSAgWzxjMTAyOWJmZD5d
IF9fZG9fcGFnZV9mYXVsdCsweDE5ZC8weDRhMApbICAgIDAuMDAwMDAwXSAgWzxjMTA1YTgw
Nz5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4zMSsweDJmNy8weGNiMApbICAgIDAuMDAwMDAw
XSAgWzxjMTAyNzE3MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDIwLzB4
MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMmEwOTQ+XSBkb19wYWdlX2ZhdWx0KzB4MjQvMHg0
MApbICAgIDAuMDAwMDAwXSAgWzxjMTAyNzE4Mj5dIGRvX2FzeW5jX3BhZ2VfZmF1bHQrMHgx
Mi8weDgwClsgICAgMC4wMDAwMDBdICBbPGMxNzYzMTdkPl0gZXJyb3JfY29kZSsweDY1LzB4
NmMKWyAgICAwLjAwMDAwMF0gIFs8YzEzYzAwMDA+XSA/IHNnX2lvKzB4MzMwLzB4M2UwClsg
ICAgMC4wMDAwMDBdICBbPGMxMDY5MDhmPl0gPyBzZXR1cF9pcnErMHhmLzB4ODAKWyAgICAw
LjAwMDAwMF0gIFs8YzFjOWU3YWU+XSBuYXRpdmVfaW5pdF9JUlErMHgyZWUvMHgyZmMKWyAg
ICAwLjAwMDAwMF0gIFs8YzFjOWU0YmU+XSBpbml0X0lSUSsweDFmLzB4MjEKWyAgICAwLjAw
MDAwMF0gIFs8YzFjOWI5NzY+XSBzdGFydF9rZXJuZWwrMHgyM2IvMHgzODkKWyAgICAwLjAw
MDAwMF0gIFs8YzFjOWIyY2I+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4N2QKWyAgICAw
LjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgNGQ1ZmY5ZjJmNjhjNDIzMyBdLS0tClsgICAgMC4w
MDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVm
ZXJlbmNlIGF0IDAwMDAwMDNhCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
L2EzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4YTZkMGEvZG1lc2ctcXVhbnRh
bC1pdmI0MS0xMDc6MjAxNDA5MjgxNDA1MDM6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYTNmMjhiZDRjMjIwODk3
ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy15b2N0by1pdmI0MS0xMDY6MjAxNDA5
MjgxNDA1MDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEz
ZjhhNmQwYS9kbWVzZy15b2N0by1pdmI0MS0xMTU6MjAxNDA5MjgxNDA1MDE6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy15b2N0
by1pdmI0MS0yNToyMDE0MDkyODE0MDQ1ODppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9hM2YyOGJkNGMyMjA4OTdk
NThjYmEzMjUyMDlkNjQ2MTNmOGE2ZDBhL2RtZXNnLXlvY3RvLWl2YjQxLTQzOjIwMTQwOTI4
MTQwNTA0OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4
YTZkMGEvZG1lc2cteW9jdG8taXZiNDEtNDk6MjAxNDA5MjgxNDA1MDQ6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUv
YTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy15b2N0by1p
dmI0MS00OjIwMTQwOTI4MTQwNDU4OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5N2Q1OGNi
YTMyNTIwOWQ2NDYxM2Y4YTZkMGEvZG1lc2cteW9jdG8taXZiNDEtNjM6MjAxNDA5MjgxNDA1
MDQ6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQw
YS9kbWVzZy1xdWFudGFsLWl2YjQxLTEwOToyMDE0MDkyODE0MDUwNzppMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9h
M2YyOGJkNGMyMjA4OTdkNThjYmEzMjUyMDlkNjQ2MTNmOGE2ZDBhL2RtZXNnLXF1YW50YWwt
aXZiNDEtMTA6MjAxNDA5MjgxNDA1MDc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYTNmMjhiZDRjMjIwODk3ZDU4
Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy1xdWFudGFsLWl2YjQxLTEyNDoyMDE0MDky
ODE0MDUwNzppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wOTI3MDA0NS9hM2YyOGJkNGMyMjA4OTdkNThjYmEzMjUyMDlkNjQ2MTNm
OGE2ZDBhL2RtZXNnLXF1YW50YWwtaXZiNDEtMzY6MjAxNDA5MjgxNDA1MDc6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy1xdWFu
dGFsLWl2YjQxLTk5OjIwMTQwOTI4MTQwNTA4OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5
N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4YTZkMGEvZG1lc2cteW9jdG8taXZiNDEtMTA3OjIwMTQw
OTI4MTQwNTA2OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2NDYx
M2Y4YTZkMGEvZG1lc2cteW9jdG8taXZiNDEtMTM6MjAxNDA5MjgxNDA1MDY6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy15b2N0
by1pdmI0MS01ODoyMDE0MDkyODE0MDUwNTppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9hM2YyOGJkNGMyMjA4OTdk
NThjYmEzMjUyMDlkNjQ2MTNmOGE2ZDBhL2RtZXNnLXlvY3RvLWl2YjQxLTg2OjIwMTQwOTI4
MTQwNTA2OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4
YTZkMGEvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMTA6MjAxNDA5MjgxNDA1MTA6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvYTNmMjhiZDRjMjIwODk3ZDU4Y2JhMzI1MjA5ZDY0NjEzZjhhNmQwYS9kbWVzZy1xdWFu
dGFsLWl2YjQxLTMyOjIwMTQwOTI4MTQwNTExOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2EzZjI4YmQ0YzIyMDg5
N2Q1OGNiYTMyNTIwOWQ2NDYxM2Y4YTZkMGEvZG1lc2ctcXVhbnRhbC1pdmI0MS01MjoyMDE0
MDkyODE0MDUwOTppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6OgowOjIwOjIwIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTI4IDE0OjA1OjQ4IFJFUEVB
VCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0Ly5yZXBl
YXQbWzBtCgpCaXNlY3Rpbmc6IDEzODYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbYTI1MTAyYjAzMDY2YzFlNTMyZmIxNWY5ZGM5NmZk
NDU2MGUyNzcxOF0gTWVyZ2UgJ3RvbWV1L2Nsay1jb25zdHJhaW50cycgaW50byBkZXZlbC1o
b3VybHktMjAxNDA5MjcwMApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDA6YTI1MTAyYjAzMDY2YzFl
NTMyZmIxNWY5ZGM5NmZkNDU2MGUyNzcxODpiaXNlY3QtbGludXgtMAoKMjAxNC0wOS0yOCAx
NDowNTo0OSBhMjUxMDJiMDMwNjZjMWU1MzJmYjE1ZjlkYzk2ZmQ0NTYwZTI3NzE4IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2Nh
aXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS1hMjUxMDJiMDMwNjZjMWU1MzJmYjE1
ZjlkYzk2ZmQ0NTYwZTI3NzE4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDUvYTI1MTAyYjAzMDY2YzFlNTMyZmIxNWY5ZGM5NmZkNDU2
MGUyNzcxOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LWEyNTEwMmIwMzA2NmMx
ZTUzMmZiMTVmOWRjOTZmZDQ1NjBlMjc3MTgKG1sxOzM1bTIwMTQtMDktMjggMTQ6MDc6NDkg
Tm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1y
YW5kY29uZmlnLWMxLTA5MjcwMDQ1LWEyNTEwMmIwMzA2NmMxZTUzMmZiMTVmOWRjOTZmZDQ1
NjBlMjc3MTgbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDkyNzAwNDUvYTI1MTAyYjAzMDY2YzFlNTMyZmIxNWY5ZGM5NmZkNDU2MGUy
NzcxOC92bWxpbnV6LTMuMTcuMC1yYzYtMDA3NzktZ2EyNTEwMmIKCjIwMTQtMDktMjggMTQ6
MDg6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxMAkxNAkxOAkyMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDYwNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTAgc3RlcHMpCltjM2Q4YTRkYWRjYTQ1MjdkZTBjMjk0ZmIzYmVmYmE4ODJmYzRmMTE2XSBN
ZXJnZSAnbGpvbmVzLW1mZC9mb3ItbWZkLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
OTI3MDAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNzAwOmMzZDhhNGRhZGNhNDUyN2RlMGMyOTRmYjNi
ZWZiYTg4MmZjNGYxMTY6YmlzZWN0LWxpbnV4LTAKCjIwMTQtMDktMjggMTQ6MTE6MjAgYzNk
OGE0ZGFkY2E0NTI3ZGUwYzI5NGZiM2JlZmJhODgyZmM0ZjExNiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby9pMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDUtYzNkOGE0ZGFkY2E0NTI3ZGUwYzI5NGZiM2JlZmJhODgy
ZmM0ZjExNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA5MjcwMDQ1L2MzZDhhNGRhZGNhNDUyN2RlMGMyOTRmYjNiZWZiYTg4MmZjNGYxMTYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJv
L2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS1jM2Q4YTRkYWRjYTQ1MjdkZTBjMjk0ZmIz
YmVmYmE4ODJmYzRmMTE2Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDky
NzAwNDUvYzNkOGE0ZGFkY2E0NTI3ZGUwYzI5NGZiM2JlZmJhODgyZmM0ZjExNi92bWxpbnV6
LTMuMTcuMC1yYzYtMDA5MDUtZ2MzZDhhNGQKCjIwMTQtMDktMjggMTQ6MTM6MjAgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTIJNQkxMQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQ4MSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2M0MjYy
MmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmZdIE1lcmdlICdqaWFuZ2xpdS9p
cnFkb21haW4vcDF2MicgaW50byBkZXZlbC1ob3VybHktMjAxNDA5MjcwMApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtMC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwOTI3MDA6YzQyNjIyZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZjpi
aXNlY3QtbGludXgtMAoKMjAxNC0wOS0yOCAxNDoxNToyMSBjNDI2MjJlY2ZjMWIzY2E3MTEw
MDAyYWEzN2ZhMzdlMGJjNmUyYmJmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3
MDA0NS1jNDI2MjJlY2ZjMWIzY2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYzQyNjIy
ZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmln
LWMxLTA5MjcwMDQ1LWM0MjYyMmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYK
G1sxOzM1bTIwMTQtMDktMjggMTQ6MTk6MjEgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWls
ZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LWM0MjYy
MmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYbWzBtClJldHJ5IGJ1aWxkIC4u
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYzQyNjIyZWNm
YzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZi92bWxpbnV6LTMuMTcuMC1yYzYtMDEx
NjYtZ2M0MjYyMmUKCjIwMTQtMDktMjggMTQ6MjA6MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
LiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBwcm9jZXNz
b3IgaG9ub3VycyB0aGUgV1AgYml0IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4uT2suClsg
ICAgMC4wMDAwMDBdIE5SX0lSUVM6MTYgbnJfaXJxczoxNiAwClsgICAgMC4wMDAwMDBdIC0t
LS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAwIGF0IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQz
MCB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgxNy8weDIwKCkKWyAgICAwLjAwMDAwMF0gWW91
J3JlIHVzaW5nIHN0YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4h
ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRl
ZCAzLjE3LjAtcmM2LTAxMTY2LWdjNDI2MjJlICMyClsgICAgMC4wMDAwMDBdICBjMWE5N2Vh
YyBjMWE5N2VhYyBjMWE5N2U4MCBjMTc1YmNmMCBjMWE5N2U5YyBjMTAzNGRmNyAwMDAwMDU5
NiBjMTAwZmI4NwpbICAgIDAuMDAwMDAwXSAgMDAwMDAwM2EgYzFhOTdmNjQgYzEwMjcxNzAg
YzFhOTdlYjQgYzEwMzRlNjYgMDAwMDAwMDkgYzFhOTdlYWMgYzE5OTNmNDgKWyAgICAwLjAw
MDAwMF0gIGMxYTk3ZWM4IGMxYTk3ZWM4IGMxMDBmYjg3IGMxOTkzZWY4IDAwMDAwNTk2IGMx
OTkzZjQ4IGMxYTk3ZjQ0IGMxMDI5YmZkClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6Clsg
ICAgMC4wMDAwMDBdICBbPGMxNzViY2YwPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAw
LjAwMDAwMF0gIFs8YzEwMzRkZjc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDU3LzB4NzAK
WyAgICAwLjAwMDAwMF0gIFs8YzEwMGZiODc+XSA/IHdhcm5fcHJlX2FsdGVybmF0aXZlcysw
eDE3LzB4MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMjcxNzA+XSA/IGt2bV9yZWFkX2FuZF9y
ZXNldF9wZl9yZWFzb24rMHgyMC8weDIwClsgICAgMC4wMDAwMDBdICBbPGMxMDM0ZTY2Pl0g
d2Fybl9zbG93cGF0aF9mbXQrMHgyNi8weDMwClsgICAgMC4wMDAwMDBdICBbPGMxMDBmYjg3
Pl0gd2Fybl9wcmVfYWx0ZXJuYXRpdmVzKzB4MTcvMHgyMApbICAgIDAuMDAwMDAwXSAgWzxj
MTAyOWJmZD5dIF9fZG9fcGFnZV9mYXVsdCsweDE5ZC8weDRhMApbICAgIDAuMDAwMDAwXSAg
WzxjMTA1YTgwNz5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4zMSsweDJmNy8weGNiMApbICAg
IDAuMDAwMDAwXSAgWzxjMTAyNzE3MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNv
bisweDIwLzB4MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMmEwOTQ+XSBkb19wYWdlX2ZhdWx0
KzB4MjQvMHg0MApbICAgIDAuMDAwMDAwXSAgWzxjMTAyNzE4Mj5dIGRvX2FzeW5jX3BhZ2Vf
ZmF1bHQrMHgxMi8weDgwClsgICAgMC4wMDAwMDBdICBbPGMxNzYzMTdkPl0gZXJyb3JfY29k
ZSsweDY1LzB4NmMKWyAgICAwLjAwMDAwMF0gIFs8YzEzYzAwMDA+XSA/IHNnX2lvKzB4MzMw
LzB4M2UwClsgICAgMC4wMDAwMDBdICBbPGMxMDY5MDhmPl0gPyBzZXR1cF9pcnErMHhmLzB4
ODAKWyAgICAwLjAwMDAwMF0gIFs8YzFjOWU3YWU+XSBuYXRpdmVfaW5pdF9JUlErMHgyZWUv
MHgyZmMKWyAgICAwLjAwMDAwMF0gIFs8YzFjOWU0YmU+XSBpbml0X0lSUSsweDFmLzB4MjEK
WyAgICAwLjAwMDAwMF0gIFs8YzFjOWI5NzY+XSBzdGFydF9rZXJuZWwrMHgyM2IvMHgzODkK
WyAgICAwLjAwMDAwMF0gIFs8YzFjOWIyY2I+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4
N2QKWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgNGQ1ZmY5ZjJmNjhjNDIzMyBdLS0t
ClsgICAgMC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2lu
dGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDNhCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA5MjcwMDQ1L2M0MjYyMmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYvZG1l
c2cteW9jdG8ta2J1aWxkLTExOjIwMTQwOTI4MTQxNzM3OmkzODYtcmFuZGNvbmZpZy1jMS0w
OTI3MDA0NTozLjE3LjAtcmM2LTAxMTY2LWdjNDI2MjJlOjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDkyNzAwNDUvYzQyNjIyZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZl
MmJiZi9kbWVzZy15b2N0by1rYnVpbGQtMTY6MjAxNDA5MjgxNDE3Mzg6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA5MjcwMDQ1OjMuMTcuMC1yYzYtMDExNjYtZ2M0MjYyMmU6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9jNDI2MjJlY2ZjMWIzY2E3MTEwMDAyYWEzN2Zh
MzdlMGJjNmUyYmJmL2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDkyODE0MTczOTppMzg2
LXJhbmRjb25maWctYzEtMDkyNzAwNDU6My4xNy4wLXJjNi0wMTE2Ni1nYzQyNjIyZToyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2M0MjYyMmVjZmMxYjNjYTcxMTAw
MDJhYTM3ZmEzN2UwYmM2ZTJiYmYvZG1lc2cteW9jdG8ta2J1aWxkLTI6MjAxNDA5MjgxNDE3
MzY6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjMuMTcuMC1yYzYtMDExNjYtZ2M0MjYy
MmU6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9jNDI2MjJlY2ZjMWIz
Y2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0
MDkyODE0MTc0MDppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6My4xNy4wLXJjNi0wMTE2
Ni1nYzQyNjIyZToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2M0MjYy
MmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYvZG1lc2cteW9jdG8ta2J1aWxk
LTQ6MjAxNDA5MjgxNDE3Mzc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjMuMTcuMC1y
YzYtMDExNjYtZ2M0MjYyMmU6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NS9jNDI2MjJlY2ZjMWIzY2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmL2RtZXNnLXF1YW50
YWwta2J1aWxkLTIzOjIwMTQwOTI4MTQxNzQyOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NTozLjE3LjAtcmM2LTAxMTY2LWdjNDI2MjJlOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDkyNzAwNDUvYzQyNjIyZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZi9k
bWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xNjk6MjAxNDA5MjgxNDIwNDQ6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUv
YzQyNjIyZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZi9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNC00MzoyMDE0MDkyODE0MjA0MjppMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9jNDI2MjJlY2ZjMWIz
Y2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmL2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xMDU6
MjAxNDA5MjgxNDIwMzk6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYzQyNjIyZWNmYzFiM2NhNzExMDAwMmFhMzdm
YTM3ZTBiYzZlMmJiZi9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTE1OjIwMTQwOTI4MTQyMDQx
OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA5MjcwMDQ1L2M0MjYyMmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYv
ZG1lc2cteW9jdG8tbGtwLW5leDA0LTE0MToyMDE0MDkyODE0MjA0MTppMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9j
NDI2MjJlY2ZjMWIzY2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmL2RtZXNnLXlvY3RvLWxr
cC1uZXgwNC0xNDM6MjAxNDA5MjgxNDIwMzc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYzQyNjIyZWNmYzFiM2Nh
NzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZi9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTYyOjIw
MTQwOTI4MTQyMDM3OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2M0MjYyMmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEz
N2UwYmM2ZTJiYmYvZG1lc2cteW9jdG8tbGtwLW5leDA0LTE3MToyMDE0MDkyODE0MjAzODpp
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wOTI3MDA0NS9jNDI2MjJlY2ZjMWIzY2E3MTEwMDAyYWEzN2ZhMzdlMGJjNmUyYmJmL2Rt
ZXNnLXlvY3RvLWxrcC1uZXgwNC0xNzk6MjAxNDA5MjgxNDIwNDE6aTM4Ni1yYW5kY29uZmln
LWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvYzQy
NjIyZWNmYzFiM2NhNzExMDAwMmFhMzdmYTM3ZTBiYzZlMmJiZi9kbWVzZy15b2N0by1sa3At
bmV4MDQtMTg5OjIwMTQwOTI4MTQyMDM4OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6
CjA6MTc6MTAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMjYxIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMDdj
NTlmZWFiMGVhYjllNTFkMDMwNmU1ZjI1NGU2ZWMxNDhiNTY4Yl0gTWVyZ2UgJ2dwaW8vZGV2
ZWwnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDAKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWMxLTA5MjcwMDQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNzAw
OjA3YzU5ZmVhYjBlYWI5ZTUxZDAzMDZlNWYyNTRlNmVjMTQ4YjU2OGI6YmlzZWN0LWxpbnV4
LTAKCjIwMTQtMDktMjggMTQ6MjA6NTkgMDdjNTlmZWFiMGVhYjllNTFkMDMwNmU1ZjI1NGU2
ZWMxNDhiNTY4YiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9jYWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtMDdjNTlm
ZWFiMGVhYjllNTFkMDMwNmU1ZjI1NGU2ZWMxNDhiNTY4YgpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzA3YzU5ZmVhYjBlYWI5ZTUx
ZDAzMDZlNWYyNTRlNmVjMTQ4YjU2OGIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NS0wN2M1OWZlYWIwZWFiOWU1MWQwMzA2ZTVmMjU0ZTZlYzE0OGI1NjhiChtbMTszNW0yMDE0
LTA5LTI4IDE0OjI1OjU5IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVp
bGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS0wN2M1OWZlYWIwZWFiOWU1
MWQwMzA2ZTVmMjU0ZTZlYzE0OGI1NjhiG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2Uv
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTA3YzU5ZmVhYjBlYWI5ZTUxZDAzMDZlNWYy
NTRlNmVjMTQ4YjU2OGIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3
MDA0NS8wN2M1OWZlYWIwZWFiOWU1MWQwMzA2ZTVmMjU0ZTZlYzE0OGI1NjhiL3ZtbGludXot
My4xNy4wLXJjNi0wMDk1Mi1nMDdjNTlmZQoKMjAxNC0wOS0yOCAxNDoyODo1OSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJMQk1CTgJMTkJMjAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFk
IGJyYW5jaCBtYXkgYmUgamlhbmdsaXUvaXJxZG9tYWluL3AxdjIKbGluZWFyLWJpc2VjdDog
aGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0
YXJ0IGM0MjYyMmVjZmMxYjNjYTcxMTAwMDJhYTM3ZmEzN2UwYmM2ZTJiYmYgMDdjNTlmZWFi
MGVhYjllNTFkMDMwNmU1ZjI1NGU2ZWMxNDhiNTY4YiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyAwN2M1OWZlLi4uIE1lcmdlICdncGlvL2RldmVsJyBpbnRvIGRldmVsLWhvdXJs
eS0yMDE0MDkyNzAwCkhFQUQgaXMgbm93IGF0IGI0ZDMzMTguLi4gTWVyZ2UgcmVtb3RlLXRy
YWNraW5nIGJyYW5jaCAnY3J5cHRvL21hc3RlcicKQmlzZWN0aW5nOiAxMTIgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltlMThiN2ZhYWUx
NWRiZDQ3ZTU4MTFlZDc0OGJkNWI1MDBkY2ZhYTJkXSBNZXJnZSBicmFuY2ggJ2JjbWdlbmV0
JwpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAvb2JqLWJpc2Vj
dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDA6ZTE4YjdmYWFlMTVkYmQ0N2U1ODExZWQ3NDhiZDVi
NTAwZGNmYWEyZDpiaXNlY3QtbGludXgtMAoKMjAxNC0wOS0yOCAxNDozMTo0NiBlMThiN2Zh
YWUxNWRiZDQ3ZTU4MTFlZDc0OGJkNWI1MDBkY2ZhYTJkIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNv
bmZpZy1jMS0wOTI3MDA0NS1lMThiN2ZhYWUxNWRiZDQ3ZTU4MTFlZDc0OGJkNWI1MDBkY2Zh
YTJkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDky
NzAwNDUvZTE4YjdmYWFlMTVkYmQ0N2U1ODExZWQ3NDhiZDViNTAwZGNmYWEyZAp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LWUxOGI3ZmFhZTE1ZGJkNDdlNTgxMWVkNzQ4YmQ1
YjUwMGRjZmFhMmQKG1sxOzM1bTIwMTQtMDktMjggMTQ6Mzc6NDYgTm8gYnVpbGQgc2VydmVk
IGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1LWUxOGI3ZmFhZTE1ZGJkNDdlNTgxMWVkNzQ4YmQ1YjUwMGRjZmFhMmQbWzBtClJl
dHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9jYWlyby1zbW9rZS9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtZTE4
YjdmYWFlMTVkYmQ0N2U1ODExZWQ3NDhiZDViNTAwZGNmYWEyZApzdGF0dXM6IEZBSUw6IGJ1
aWxkIGVycm9yChtbMTszNW0yMDE0LTA5LTI4IDE0OjM5OjQ2IEtlcm5lbCBidWlsZCBmYWls
IG9yIHRpbWVvdXQbWzBtCjIwMTQtMDktMjggMTQ6Mzk6NDYgZTE4YjdmYWFlMTVkYmQ0N2U1
ODExZWQ3NDhiZDViNTAwZGNmYWEyZCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayAva2J1aWxk
LXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtZTE4Yjdm
YWFlMTVkYmQ0N2U1ODExZWQ3NDhiZDViNTAwZGNmYWEyZApCaXNlY3Rpbmc6IDExMiByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzQ1MmI2
MzYxYzRkOWJhZjY5NDBhZGI3YjEzMTZlMGYzODZjMzk3OTldIE1lcmdlIHRhZyAncmRtYS1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9yb2xhbmQvaW5maW5pYmFuZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEt
MDkyNzAwNDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDA6NDUyYjYzNjFj
NGQ5YmFmNjk0MGFkYjdiMTMxNmUwZjM4NmMzOTc5OTpiaXNlY3QtbGludXgtMAoKMjAxNC0w
OS0yOCAxNDozOTo0NyA0NTJiNjM2MWM0ZDliYWY2OTQwYWRiN2IxMzE2ZTBmMzg2YzM5Nzk5
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS00NTJiNjM2MWM0ZDliYWY2
OTQwYWRiN2IxMzE2ZTBmMzg2YzM5Nzk5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvNDUyYjYzNjFjNGQ5YmFmNjk0MGFkYjdiMTMx
NmUwZjM4NmMzOTc5OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTQ1MmI2MzYx
YzRkOWJhZjY5NDBhZGI3YjEzMTZlMGYzODZjMzk3OTkKG1sxOzM1bTIwMTQtMDktMjggMTQ6
NDQ6NDcgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQv
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTQ1MmI2MzYxYzRkOWJhZjY5NDBhZGI3YjEz
MTZlMGYzODZjMzk3OTkbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby1zbW9rZS9pMzg2LXJhbmRj
b25maWctYzEtMDkyNzAwNDUtNDUyYjYzNjFjNGQ5YmFmNjk0MGFkYjdiMTMxNmUwZjM4NmMz
OTc5OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzQ1MmI2
MzYxYzRkOWJhZjY5NDBhZGI3YjEzMTZlMGYzODZjMzk3OTkvdm1saW51ei0zLjE3LjAtcmM2
LTAwMTgwLWc0NTJiNjM2CgoyMDE0LTA5LTI4IDE0OjQ2OjQ3IGRldGVjdGluZyBib290IHN0
YXRlIC4JOS4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzQyNGZmZjdhZTIyNWRhMjU2MDZm
MmJhNmFhZmM1ZGYzZGYxZThiN2ZdIHg4NiwgaXJxOiBLaWxsIGZvdXJ0aCBwYXJhbWV0ZXIg
b2YgSU9fQVBJQ19nZXRfUENJX2lycV92ZWN0b3IoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMC9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYzEtMDkyNzAwNDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDA6
NDI0ZmZmN2FlMjI1ZGEyNTYwNmYyYmE2YWFmYzVkZjNkZjFlOGI3ZjpiaXNlY3QtbGludXgt
MAoKMjAxNC0wOS0yOCAxNDo0ODo0OCA0MjRmZmY3YWUyMjVkYTI1NjA2ZjJiYTZhYWZjNWRm
M2RmMWU4YjdmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS00MjRmZmY3
YWUyMjVkYTI1NjA2ZjJiYTZhYWZjNWRmM2RmMWU4YjdmCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvNDI0ZmZmN2FlMjI1ZGEyNTYw
NmYyYmE2YWFmYzVkZjNkZjFlOGI3Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
LTQyNGZmZjdhZTIyNWRhMjU2MDZmMmJhNmFhZmM1ZGYzZGYxZThiN2YKG1sxOzM1bTIwMTQt
MDktMjggMTQ6NTE6NDkgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWls
ZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTQyNGZmZjdhZTIyNWRhMjU2
MDZmMmJhNmFhZmM1ZGYzZGYxZThiN2YbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvNDI0ZmZmN2FlMjI1ZGEyNTYwNmYy
YmE2YWFmYzVkZjNkZjFlOGI3Zi92bWxpbnV6LTMuMTcuMC1yYzYtMDAxOTctZzQyNGZmZjcK
CjIwMTQtMDktMjggMTQ6NTI6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JNAk2CTE5
CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzY1YmMyMWRiOTYwNTlmODU5YTRlODg2NzY1Nzhi
YjQ4NWYyZWIxYjBdIHg4NiwgaXJxOiBNb3ZlIFBDSSBNU0kgcmVsYXRlZCBjb2RlIGZyb20g
aW9fYXBpYy5jIGludG8gbXNpLmMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNzAwOjY1YmMyMWRiOTYw
NTlmODU5YTRlODg2NzY1NzhiYjQ4NWYyZWIxYjA6YmlzZWN0LWxpbnV4LTAKCjIwMTQtMDkt
MjggMTQ6NTc6MTkgNjViYzIxZGI5NjA1OWY4NTlhNGU4ODY3NjU3OGJiNDg1ZjJlYjFiMCBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9jYWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtNjViYzIxZGI5NjA1OWY4NTlh
NGU4ODY3NjU3OGJiNDg1ZjJlYjFiMApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzY1YmMyMWRiOTYwNTlmODU5YTRlODg2NzY1Nzhi
YjQ4NWYyZWIxYjAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS02NWJjMjFkYjk2
MDU5Zjg1OWE0ZTg4Njc2NTc4YmI0ODVmMmViMWIwChtbMTszNW0yMDE0LTA5LTI4IDE1OjAy
OjE5IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS02NWJjMjFkYjk2MDU5Zjg1OWE0ZTg4Njc2NTc4
YmI0ODVmMmViMWIwG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA5MjcwMDQ1LTY1YmMyMWRiOTYwNTlmODU5YTRlODg2NzY1NzhiYjQ4NWYyZWIx
YjAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS82NWJjMjFk
Yjk2MDU5Zjg1OWE0ZTg4Njc2NTc4YmI0ODVmMmViMWIwL3ZtbGludXotMy4xNy4wLXJjNi0w
MDIwNS1nNjViYzIxZAoKMjAxNC0wOS0yOCAxNTowNDoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMTIJMTUJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbOWE1NWZjNjYzZWM5MzVkZTc5MTJk
OGE2NDlhYmRjNjM1MWJlZjJiOV0geDg2LCBpcnE6IE1ha2UgTVNJIGFuZCBIVF9JUlEgaW5k
ZXBlbmVudCBvZiBYODZfSU9fQVBJQwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEt
MDkyNzAwNDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI3MDA6OWE1NWZjNjYz
ZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOTpiaXNlY3QtbGludXgtMAoKMjAxNC0w
OS0yOCAxNTowNTo1MSA5YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0OWFiZGM2MzUxYmVmMmI5
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS05YTU1ZmM2NjNlYzkzNWRl
NzkxMmQ4YTY0OWFiZGM2MzUxYmVmMmI5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5MzVkZTc5MTJkOGE2NDlh
YmRjNjM1MWJlZjJiOQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTlh
NTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJkYzYzNTFiZWYyYjkKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0
OWFiZGM2MzUxYmVmMmI5L3ZtbGludXotMy4xNy4wLXJjNi0wMDIwOS1nOWE1NWZjNgoKMjAx
NC0wOS0yOCAxNTowNzo1MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpb
ICAgIDAuMDAwMDAwXSBDaGVja2luZyBpZiB0aGlzIHByb2Nlc3NvciBob25vdXJzIHRoZSBX
UCBiaXQgZXZlbiBpbiBzdXBlcnZpc29yIG1vZGUuLi5Pay4KWyAgICAwLjAwMDAwMF0gTlJf
SVJRUzoxNiBucl9pcnFzOjE2IDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDAgYXQgYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYzoxNDMwIHdhcm5fcHJlX2FsdGVy
bmF0aXZlcysweDE3LzB4MjAoKQpbICAgIDAuMDAwMDAwXSBZb3UncmUgdXNpbmcgc3RhdGlj
X2NwdV9oYXMgYmVmb3JlIGFsdGVybmF0aXZlcyBoYXZlIHJ1biEKWyAgICAwLjAwMDAwMF0g
Q1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTcuMC1yYzYtMDAy
MDktZzlhNTVmYzYgIzIKWyAgICAwLjAwMDAwMF0gIGMxYTkxZWFjIGMxYTkxZWFjIGMxYTkx
ZTgwIGMxNzVhOGYwIGMxYTkxZTljIGMxMDM0ZGY3IDAwMDAwNTk2IGMxMDBmYjg3ClsgICAg
MC4wMDAwMDBdICAwMDAwMDAzYSBjMWE5MWY2NCBjMTAyNzE3MCBjMWE5MWViNCBjMTAzNGU2
NiAwMDAwMDAwOSBjMWE5MWVhYyBjMTk4ZWQ4OApbICAgIDAuMDAwMDAwXSAgYzFhOTFlYzgg
YzFhOTFlYzggYzEwMGZiODcgYzE5OGVkMzggMDAwMDA1OTYgYzE5OGVkODggYzFhOTFmNDQg
YzEwMjliZmQKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8
YzE3NWE4ZjA+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDAuMDAwMDAwXSAgWzxjMTAz
NGRmNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NTcvMHg3MApbICAgIDAuMDAwMDAwXSAg
WzxjMTAwZmI4Nz5dID8gd2Fybl9wcmVfYWx0ZXJuYXRpdmVzKzB4MTcvMHgyMApbICAgIDAu
MDAwMDAwXSAgWzxjMTAyNzE3MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisw
eDIwLzB4MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMzRlNjY+XSB3YXJuX3Nsb3dwYXRoX2Zt
dCsweDI2LzB4MzAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMGZiODc+XSB3YXJuX3ByZV9hbHRl
cm5hdGl2ZXMrMHgxNy8weDIwClsgICAgMC4wMDAwMDBdICBbPGMxMDI5YmZkPl0gX19kb19w
YWdlX2ZhdWx0KzB4MTlkLzB4NGEwClsgICAgMC4wMDAwMDBdICBbPGMxMDVhODA3Pl0gPyBf
X2xvY2tfYWNxdWlyZS5pc3JhLjMxKzB4MmY3LzB4Y2IwClsgICAgMC4wMDAwMDBdICBbPGMx
MDI3MTcwPl0gPyBrdm1fcmVhZF9hbmRfcmVzZXRfcGZfcmVhc29uKzB4MjAvMHgyMApbICAg
IDAuMDAwMDAwXSAgWzxjMTAyYTA5ND5dIGRvX3BhZ2VfZmF1bHQrMHgyNC8weDQwClsgICAg
MC4wMDAwMDBdICBbPGMxMDI3MTgyPl0gZG9fYXN5bmNfcGFnZV9mYXVsdCsweDEyLzB4ODAK
WyAgICAwLjAwMDAwMF0gIFs8YzE3NjFkN2Q+XSBlcnJvcl9jb2RlKzB4NjUvMHg2YwpbICAg
IDAuMDAwMDAwXSAgWzxjMTNjMDAwMD5dID8gc2dfaW8rMHgzNzAvMHgzZTAKWyAgICAwLjAw
MDAwMF0gIFs8YzEwNjkwOGY+XSA/IHNldHVwX2lycSsweGYvMHg4MApbICAgIDAuMDAwMDAw
XSAgWzxjMWM5NzdhZT5dIG5hdGl2ZV9pbml0X0lSUSsweDJlZS8weDJmYwpbICAgIDAuMDAw
MDAwXSAgWzxjMWM5NzRiZT5dIGluaXRfSVJRKzB4MWYvMHgyMQpbICAgIDAuMDAwMDAwXSAg
WzxjMWM5NDk3Nj5dIHN0YXJ0X2tlcm5lbCsweDIzYi8weDM4OQpbICAgIDAuMDAwMDAwXSAg
WzxjMWM5NDJjYj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAw
XSAtLS1bIGVuZCB0cmFjZSA0ZDVmZjlmMmY2OGM0MjMzIF0tLS0KWyAgICAwLjAwMDAwMF0g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YXQgMDAwMDAwM2EKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZj
NjYzZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS0x
MDg6MjAxNDA5MjgxNTA3NDc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5MzVkZTc5MTJkOGE2
NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS0xMjU6MjAxNDA5MjgxNTA3NDY6
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9k
bWVzZy15b2N0by1pdmI0MS0xMjY6MjAxNDA5MjgxNTA3NDc6aTM4Ni1yYW5kY29uZmlnLWMx
LTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZj
NjYzZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS0x
NjoyMDE0MDkyODE1MDc0NjppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0
OWFiZGM2MzUxYmVmMmI5L2RtZXNnLXlvY3RvLWl2YjQxLTMxOjIwMTQwOTI4MTUwNzQ4Omkz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA5MjcwMDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJkYzYzNTFiZWYyYjkvZG1l
c2cteW9jdG8taXZiNDEtMzU6MjAxNDA5MjgxNTA3NDY6aTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYz
ZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS0zNzoy
MDE0MDkyODE1MDc0NDppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0OWFi
ZGM2MzUxYmVmMmI5L2RtZXNnLXlvY3RvLWl2YjQxLTUxOjIwMTQwOTI4MTUwNzQ3OmkzODYt
cmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJkYzYzNTFiZWYyYjkvZG1lc2ct
eW9jdG8taXZiNDEtNjE6MjAxNDA5MjgxNTA3NDc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5
MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS02MjoyMDE0
MDkyODE1MDc0NTppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wOTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0OWFiZGM2
MzUxYmVmMmI5L2RtZXNnLXlvY3RvLWl2YjQxLTc0OjIwMTQwOTI4MTUwNzQ2OmkzODYtcmFu
ZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJkYzYzNTFiZWYyYjkvZG1lc2cteW9j
dG8taXZiNDEtODE6MjAxNDA5MjgxNTA3NDg6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5MzVk
ZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy15b2N0by1pdmI0MS04NzoyMDE0MDky
ODE1MDc0NTppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wOTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0OWFiZGM2MzUx
YmVmMmI5L2RtZXNnLXF1YW50YWwtaXZiNDEtMTIwOjIwMTQwOTI4MTUwNzU4OmkzODYtcmFu
ZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJkYzYzNTFiZWYyYjkvZG1lc2ctcXVh
bnRhbC1pdmI0MS0xMjg6MjAxNDA5MjgxNTA3NTc6aTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYzZWM5
MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy1xdWFudGFsLWl2YjQxLTIwOjIw
MTQwOTI4MTUwNzU2OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5YWJk
YzYzNTFiZWYyYjkvZG1lc2ctcXVhbnRhbC1pdmI0MS02MzoyMDE0MDkyODE1MDc1ODppMzg2
LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
OTI3MDA0NS85YTU1ZmM2NjNlYzkzNWRlNzkxMmQ4YTY0OWFiZGM2MzUxYmVmMmI5L2RtZXNn
LXF1YW50YWwtaXZiNDEtNjU6MjAxNDA5MjgxNTA3NTU6aTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWE1NWZjNjYz
ZWM5MzVkZTc5MTJkOGE2NDlhYmRjNjM1MWJlZjJiOS9kbWVzZy1xdWFudGFsLWl2YjQxLTY3
OjIwMTQwOTI4MTUwNzU4OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzlhNTVmYzY2M2VjOTM1ZGU3OTEyZDhhNjQ5
YWJkYzYzNTFiZWYyYjkvZG1lc2ctcXVhbnRhbC1pdmI0MS04MDoyMDE0MDkyODE1MDc1ODpp
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6OgowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTI4IDE1OjA4OjIxIFJFUEVBVCBDT1VOVDogMjAg
ICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNl
Y3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBz
dGVwKQpbOWQyNGI4OTBkMDA2OTgzMjBjODA0YzMzNTY3M2E1YTVkYWQxNzdiYl0geDg2LCBp
cnE6IE1vdmUgSU9BUElDIHJlbGF0ZWQgZGVjbGFyYXRpb25zIGZyb20gaHdfaXJxLmggaW50
byBpb19hcGljLmgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNzAwOjlkMjRiODkwZDAwNjk4MzIwYzgw
NGMzMzU2NzNhNWE1ZGFkMTc3YmI6YmlzZWN0LWxpbnV4LTAKCjIwMTQtMDktMjggMTU6MDg6
MjIgOWQyNGI4OTBkMDA2OTgzMjBjODA0YzMzNTY3M2E1YTVkYWQxNzdiYiBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby9p
Mzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtOWQyNGI4OTBkMDA2OTgzMjBjODA0YzMzNTY3
M2E1YTVkYWQxNzdiYgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA5MjcwMDQ1LzlkMjRiODkwZDAwNjk4MzIwYzgwNGMzMzU2NzNhNWE1ZGFkMTc3
YmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS05ZDI0Yjg5MGQwMDY5ODMyMGM4
MDRjMzM1NjczYTVhNWRhZDE3N2JiChtbMTszNW0yMDE0LTA5LTI4IDE1OjMyOjIyIE5vIGJ1
aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNv
bmZpZy1jMS0wOTI3MDA0NS05ZDI0Yjg5MGQwMDY5ODMyMGM4MDRjMzM1NjczYTVhNWRhZDE3
N2JiG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1LTlkMjRiODkwZDAwNjk4MzIwYzgwNGMzMzU2NzNhNWE1ZGFkMTc3YmIKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS85ZDI0Yjg5MGQwMDY5ODMy
MGM4MDRjMzM1NjczYTVhNWRhZDE3N2JiL3ZtbGludXotMy4xNy4wLXJjNi0wMDIwNy1nOWQy
NGI4OQoKMjAxNC0wOS0yOCAxNjozODoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNAk4CTE3
CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAw
M2VlOTM0ZmMyNjNdIHg4NiwgaXJxOiBNb3ZlIElSUSBpbml0aWFsaXphdGlvbiByb3V0aW5l
cyBmcm9tIGlvX2FwaWMuYyBpbnRvIHZlY3Rvci5jCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0wL29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1jMS0wOTI3MDA0NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MjcwMDpm
MmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZjMjYzOmJpc2VjdC1saW51eC0w
CgoyMDE0LTA5LTI4IDE2OjQwOjIzIGYyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAwM2Vl
OTM0ZmMyNjMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LWYyYmI5NWY3
OGE2OTRmNTc1ZWY0MWE5ZjY1YzAwM2VlOTM0ZmMyNjMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9mMmJiOTVmNzhhNjk0ZjU3NWVm
NDFhOWY2NWMwMDNlZTkzNGZjMjYzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUt
ZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2MwobWzE7MzVtMjAxNC0w
OS0yOCAxNzoyNToyMyBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxk
LXNlcnZlZC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtZjJiYjk1Zjc4YTY5NGY1NzVl
ZjQxYTlmNjVjMDAzZWU5MzRmYzI2MxtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvLXNtb2tlL2kz
ODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS1mMmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMw
MDNlZTkzNGZjMjYzCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUvZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2My92bWxpbnV6LTMu
MTcuMC1yYzYtMDAyMDgtZ2YyYmI5NWYKCjIwMTQtMDktMjggMTg6NDQ6MjQgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gQ2hlY2tpbmcgaWYg
dGhpcyBwcm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0IGV2ZW4gaW4gc3VwZXJ2aXNvciBt
b2RlLi4uT2suClsgICAgMC4wMDAwMDBdIE5SX0lSUVM6MTYgbnJfaXJxczoxNiAwClsgICAg
MC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAu
MDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IGFyY2gveDg2L2tlcm5lbC9jcHUv
Y29tbW9uLmM6MTQzMCB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgxNy8weDIwKCkKWyAgICAw
LjAwMDAwMF0gWW91J3JlIHVzaW5nIHN0YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2
ZXMgaGF2ZSBydW4hClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBl
ciBOb3QgdGFpbnRlZCAzLjE3LjAtcmM2LTAwMjA4LWdmMmJiOTVmICMyClsgICAgMC4wMDAw
MDBdICBjMWE5MWVhYyBjMWE5MWVhYyBjMWE5MWU4MCBjMTc1YTQzMCBjMWE5MWU5YyBjMTAz
NGM0NyAwMDAwMDU5NiBjMTAwZmI4NwpbICAgIDAuMDAwMDAwXSAgMDAwMDAwM2EgYzFhOTFm
NjQgYzEwMjZmYzAgYzFhOTFlYjQgYzEwMzRjYjYgMDAwMDAwMDkgYzFhOTFlYWMgYzE5OGVj
YmMKWyAgICAwLjAwMDAwMF0gIGMxYTkxZWM4IGMxYTkxZWM4IGMxMDBmYjg3IGMxOThlYzZj
IDAwMDAwNTk2IGMxOThlY2JjIGMxYTkxZjQ0IGMxMDI5YTRkClsgICAgMC4wMDAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNzVhNDMwPl0gZHVtcF9zdGFjaysweDE2
LzB4MTgKWyAgICAwLjAwMDAwMF0gIFs8YzEwMzRjNDc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1v
bisweDU3LzB4NzAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMGZiODc+XSA/IHdhcm5fcHJlX2Fs
dGVybmF0aXZlcysweDE3LzB4MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMjZmYzA+XSA/IGt2
bV9yZWFkX2FuZF9yZXNldF9wZl9yZWFzb24rMHgyMC8weDIwClsgICAgMC4wMDAwMDBdICBb
PGMxMDM0Y2I2Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHgyNi8weDMwClsgICAgMC4wMDAwMDBd
ICBbPGMxMDBmYjg3Pl0gd2Fybl9wcmVfYWx0ZXJuYXRpdmVzKzB4MTcvMHgyMApbICAgIDAu
MDAwMDAwXSAgWzxjMTAyOWE0ZD5dIF9fZG9fcGFnZV9mYXVsdCsweDE5ZC8weDRhMApbICAg
IDAuMDAwMDAwXSAgWzxjMTA1YTY1Nz5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4zMSsweDJm
Ny8weGNiMApbICAgIDAuMDAwMDAwXSAgWzxjMTAyNmZjMD5dID8ga3ZtX3JlYWRfYW5kX3Jl
c2V0X3BmX3JlYXNvbisweDIwLzB4MjAKWyAgICAwLjAwMDAwMF0gIFs8YzEwMjllZTQ+XSBk
b19wYWdlX2ZhdWx0KzB4MjQvMHg0MApbICAgIDAuMDAwMDAwXSAgWzxjMTAyNmZkMj5dIGRv
X2FzeW5jX3BhZ2VfZmF1bHQrMHgxMi8weDgwClsgICAgMC4wMDAwMDBdICBbPGMxNzYxOGJk
Pl0gZXJyb3JfY29kZSsweDY1LzB4NmMKWyAgICAwLjAwMDAwMF0gIFs8YzEzYzAwMDA+XSA/
IHNnX3Njc2lfaW9jdGwrMHgxNTAvMHgzYTAKWyAgICAwLjAwMDAwMF0gIFs8YzEwNjhlZGY+
XSA/IHNldHVwX2lycSsweGYvMHg4MApbICAgIDAuMDAwMDAwXSAgWzxjMWM5NzdhZT5dIG5h
dGl2ZV9pbml0X0lSUSsweDJlZS8weDJmYwpbICAgIDAuMDAwMDAwXSAgWzxjMWM5NzRiZT5d
IGluaXRfSVJRKzB4MWYvMHgyMQpbICAgIDAuMDAwMDAwXSAgWzxjMWM5NDk3Nj5dIHN0YXJ0
X2tlcm5lbCsweDIzYi8weDM4OQpbICAgIDAuMDAwMDAwXSAgWzxjMWM5NDJjYj5dIGkzODZf
c3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSA0
ZDVmZjlmMmY2OGM0MjMzIF0tLS0KWyAgICAwLjAwMDAwMF0gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwM2EKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlm
NjVjMDAzZWU5MzRmYzI2My9kbWVzZy1xdWFudGFsLWl2YjQxLTk5OjIwMTQwOTI4MTg0NDEz
OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAwM2VlOTM0ZmMyNjMv
ZG1lc2cteW9jdG8taXZiNDEtMTEwOjIwMTQwOTI4MTg0NDEyOmkzODYtcmFuZGNvbmZpZy1j
MS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5
NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAwM2VlOTM0ZmMyNjMvZG1lc2cteW9jdG8taXZiNDEt
MTI4OjIwMTQwOTI4MTg0NDEyOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5
ZjY1YzAwM2VlOTM0ZmMyNjMvZG1lc2cteW9jdG8taXZiNDEtMjU6MjAxNDA5MjgxODQ0MTQ6
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDkyNzAwNDUvZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2My9k
bWVzZy15b2N0by1pdmI0MS01MToyMDE0MDkyODE4NDQwOTppMzg2LXJhbmRjb25maWctYzEt
MDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9mMmJiOTVm
NzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZjMjYzL2RtZXNnLXlvY3RvLWl2YjQxLTk0
OjIwMTQwOTI4MTg0NDEzOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1
YzAwM2VlOTM0ZmMyNjMvZG1lc2cteW9jdG8tdnAtMjoyMDE0MDkyODE4NDQxNzppMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDU6My4xNy4wLXJjNi0wMDIwOC1nZjJiYjk1ZjoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5
ZjY1YzAwM2VlOTM0ZmMyNjMvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDoyMDE0MDkyODE4NDQy
MjppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wOTI3MDA0NS9mMmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZjMjYz
L2RtZXNnLXF1YW50YWwtaXZiNDEtMTExOjIwMTQwOTI4MTg0NDIwOmkzODYtcmFuZGNvbmZp
Zy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2Yy
YmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAwM2VlOTM0ZmMyNjMvZG1lc2ctcXVhbnRhbC1p
dmI0MS0zOjIwMTQwOTI4MTg0NDIzOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0
MWE5ZjY1YzAwM2VlOTM0ZmMyNjMvZG1lc2ctcXVhbnRhbC1pdmI0MS00OToyMDE0MDkyODE4
NDQyNDppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wOTI3MDA0NS9mMmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZj
MjYzL2RtZXNnLXF1YW50YWwtaXZiNDEtNToyMDE0MDkyODE4NDQyMzppMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9m
MmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZjMjYzL2RtZXNnLXF1YW50YWwt
aXZiNDEtODM6MjAxNDA5MjgxODQ0MjA6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZjJiYjk1Zjc4YTY5NGY1NzVl
ZjQxYTlmNjVjMDAzZWU5MzRmYzI2My9kbWVzZy1xdWFudGFsLXZwLTIwOjIwMTQwOTI4MTg0
NDI0OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTozLjE3LjAtcmM2LTAwMjA4LWdmMmJi
OTVmOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZjJiYjk1Zjc4YTY5
NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2My9kbWVzZy1xdWFudGFsLXZwLTIxOjIwMTQw
OTI4MTg0NDIzOmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTozLjE3LjAtcmM2LTAwMjA4
LWdmMmJiOTVmOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZjJiYjk1
Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2My9kbWVzZy15b2N0by1rYnVpbGQt
MTk6MjAxNDA5MjgxODQxMzA6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjMuMTcuMC1y
YzYtMDAyMDgtZ2YyYmI5NWY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NS9mMmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZjMjYzL2RtZXNnLXlvY3Rv
LWtidWlsZC0xOjIwMTQwOTI4MTg0MTI2OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NToz
LjE3LjAtcmM2LTAwMjA4LWdmMmJiOTVmOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDkyNzAwNDUvZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRmYzI2My9kbWVz
Zy15b2N0by1rYnVpbGQtMjE6MjAxNDA5MjgxODQxMjU6aTM4Ni1yYW5kY29uZmlnLWMxLTA5
MjcwMDQ1OjMuMTcuMC1yYzYtMDAyMDgtZ2YyYmI5NWY6Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wOTI3MDA0NS9mMmJiOTVmNzhhNjk0ZjU3NWVmNDFhOWY2NWMwMDNlZTkzNGZj
MjYzL2RtZXNnLXlvY3RvLWtidWlsZC0yNjoyMDE0MDkyODE4NDEyNDppMzg2LXJhbmRjb25m
aWctYzEtMDkyNzAwNDU6My4xNy4wLXJjNi0wMDIwOC1nZjJiYjk1ZjoyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1L2YyYmI5NWY3OGE2OTRmNTc1ZWY0MWE5ZjY1YzAw
M2VlOTM0ZmMyNjMvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwOTI4MTg0MTMzOmkzODYt
cmFuZGNvbmZpZy1jMS0wOTI3MDA0NTozLjE3LjAtcmM2LTAwMjA4LWdmMmJiOTVmOjIKMDoy
MDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0yOCAxODo0
NDo1NCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTAvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKZjJiYjk1Zjc4YTY5NGY1NzVlZjQxYTlmNjVjMDAzZWU5MzRm
YzI2MyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgZjJiYjk1Zjc4YTY5NGY1NzVl
ZjQxYTlmNjVjMDAzZWU5MzRmYzI2MwpBdXRob3I6IEppYW5nIExpdSA8amlhbmcubGl1QGxp
bnV4LmludGVsLmNvbT4KRGF0ZTogICBXZWQgSnVuIDI1IDE0OjE2OjE4IDIwMTQgKzA4MDAK
CiAgICB4ODYsIGlycTogTW92ZSBJUlEgaW5pdGlhbGl6YXRpb24gcm91dGluZXMgZnJvbSBp
b19hcGljLmMgaW50byB2ZWN0b3IuYwogICAgCiAgICBNb3ZlIElSUSBpbml0aWFsaXphdGlv
biByb3V0aW5lcyBmcm9tIGlvX2FwaWMuYyBpbnRvIHZlY3Rvci5jLAogICAgcHJlcGFyaW5n
IGZvciBlbmFibGluZyBoaWVyYXJjaHkgaXJxZG9tYWluLgogICAgCiAgICBTaWduZWQtb2Zm
LWJ5OiBKaWFuZyBMaXUgPGppYW5nLmxpdUBsaW51eC5pbnRlbC5jb20+Cgo6MDQwMDAwIDA0
MDAwMCAzYzU3OTg3ODFmNTc5MThlOTZmZDlmYzc2NWNkMjc3ZmI0MzNhODQ3IGI0YmE5NGU1
MDU1NWM4YjQ2OTZlNWFjOGUxMmY1MmU5MTcwZTU0ZDkgTQlhcmNoCmJpc2VjdCBydW4gc3Vj
Y2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBmMmJiOTVmLi4uIHg4NiwgaXJxOiBN
b3ZlIElSUSBpbml0aWFsaXphdGlvbiByb3V0aW5lcyBmcm9tIGlvX2FwaWMuYyBpbnRvIHZl
Y3Rvci5jCkhFQUQgaXMgbm93IGF0IDlkMjRiODkuLi4geDg2LCBpcnE6IE1vdmUgSU9BUElD
IHJlbGF0ZWQgZGVjbGFyYXRpb25zIGZyb20gaHdfaXJxLmggaW50byBpb19hcGljLmgKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3
MDA0NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MjcwMDo5ZDI0Yjg5MGQwMDY5
ODMyMGM4MDRjMzM1NjczYTVhNWRhZDE3N2JiOmJpc2VjdC1saW51eC0wCgoyMDE0LTA5LTI4
IDE4OjQ0OjU3IDlkMjRiODkwZDAwNjk4MzIwYzgwNGMzMzU2NzNhNWE1ZGFkMTc3YmIgcmV1
c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvOWQyNGI4OTBkMDA2OTgz
MjBjODA0YzMzNTY3M2E1YTVkYWQxNzdiYi92bWxpbnV6LTMuMTcuMC1yYzYtMDAyMDctZzlk
MjRiODkKCjIwMTQtMDktMjggMTg6NDQ6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzCTEw
CTI3CTQxCTU1CTYwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDlkMjRi
ODkuLi4geDg2LCBpcnE6IE1vdmUgSU9BUElDIHJlbGF0ZWQgZGVjbGFyYXRpb25zIGZyb20g
aHdfaXJxLmggaW50byBpb19hcGljLmgKSEVBRCBpcyBub3cgYXQgZmUzNGFkMS4uLiAwZGF5
IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA5MjcwMCcKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MjcwMDpmZTM0YWQxYzdmNjQ1NWFiNjgyN2Q0
Y2M4NDIyNGI3ZjU3ZWVjMWViOmJpc2VjdC1saW51eC0wCiBURVNUIEZBSUxVUkUKWyAgICAw
LjAwMDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBwcm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0
IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4uT2suClsgICAgMC4wMDAwMDBdIE5SX0lSUVM6
MTYgbnJfaXJxczoxNiAwClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0
IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQzMCB3YXJuX3ByZV9hbHRlcm5hdGl2
ZXMrMHgxNy8weDIwKCkKWyAgICAwLjAwMDAwMF0gWW91J3JlIHVzaW5nIHN0YXRpY19jcHVf
aGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4hClsgICAgMC4wMDAwMDBdIENQVTog
MCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3LjAtcmM2LTAyMDM4LWdm
ZTM0YWQxICMxClsgICAgMC4wMDAwMDBdICBjMWE5OWVhYyBjMWE5OWVhYyBjMWE5OWU4MCBj
MTc1YzU3YyBjMWE5OWU5YyBjMTAzNTNkNyAwMDAwMDU5NiBjMTAwZmI4NwpbICAgIDAuMDAw
MDAwXSAgMDAwMDAwM2EgYzFhOTlmNjQgYzEwMjc3NTAgYzFhOTllYjQgYzEwMzU0NDYgMDAw
MDAwMDkgYzFhOTllYWMgYzE5OTVhNjgKWyAgICAwLjAwMDAwMF0gIGMxYTk5ZWM4IGMxYTk5
ZWM4IGMxMDBmYjg3IGMxOTk1YTE4IDAwMDAwNTk2IGMxOTk1YTY4IGMxYTk5ZjQ0IGMxMDJh
MWRkClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNzVj
NTdjPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAwLjAwMDAwMF0gIFs8YzEwMzUzZDc+
XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDU3LzB4NzAKWyAgICAwLjAwMDAwMF0gIFs8YzEw
MGZiODc+XSA/IHdhcm5fcHJlX2FsdGVybmF0aXZlcysweDE3LzB4MjAKWyAgICAwLjAwMDAw
MF0gIFs8YzEwMjc3NTA+XSA/IGt2bV9yZWFkX2FuZF9yZXNldF9wZl9yZWFzb24rMHgyMC8w
eDIwClsgICAgMC4wMDAwMDBdICBbPGMxMDM1NDQ2Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHgy
Ni8weDMwClsgICAgMC4wMDAwMDBdICBbPGMxMDBmYjg3Pl0gd2Fybl9wcmVfYWx0ZXJuYXRp
dmVzKzB4MTcvMHgyMApbICAgIDAuMDAwMDAwXSAgWzxjMTAyYTFkZD5dIF9fZG9fcGFnZV9m
YXVsdCsweDE5ZC8weDRhMApbICAgIDAuMDAwMDAwXSAgWzxjMTA1YWU0Nz5dID8gX19sb2Nr
X2FjcXVpcmUuaXNyYS4zMSsweDJmNy8weGNiMApbICAgIDAuMDAwMDAwXSAgWzxjMTAyNzc1
MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDIwLzB4MjAKWyAgICAwLjAw
MDAwMF0gIFs8YzEwMmE2NzQ+XSBkb19wYWdlX2ZhdWx0KzB4MjQvMHg0MApbICAgIDAuMDAw
MDAwXSAgWzxjMTAyNzc2Mj5dIGRvX2FzeW5jX3BhZ2VfZmF1bHQrMHgxMi8weDgwClsgICAg
MC4wMDAwMDBdICBbPGMxNzYzOWZkPl0gZXJyb3JfY29kZSsweDY1LzB4NmMKWyAgICAwLjAw
MDAwMF0gIFs8YzEzYzAwMDA+XSA/IHNldF9kaXNrX3JvKzB4NDAvMHhjMApbICAgIDAuMDAw
MDAwXSAgWzxjMTA2OTZjZj5dID8gc2V0dXBfaXJxKzB4Zi8weDgwClsgICAgMC4wMDAwMDBd
ICBbPGMxY2EyN2FlPl0gbmF0aXZlX2luaXRfSVJRKzB4MmVlLzB4MmZjClsgICAgMC4wMDAw
MDBdICBbPGMxY2EyNGJlPl0gaW5pdF9JUlErMHgxZi8weDIxClsgICAgMC4wMDAwMDBdICBb
PGMxYzlmOTc2Pl0gc3RhcnRfa2VybmVsKzB4MjNiLzB4Mzg5ClsgICAgMC4wMDAwMDBdICBb
PGMxYzlmMmNiPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBd
IC0tLVsgZW5kIHRyYWNlIDRkNWZmOWYyZjY4YzQyMzMgXS0tLQpbICAgIDAuMDAwMDAwXSBC
VUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBh
dCAwMDAwMDAzYQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9mZTM0YWQx
YzdmNjQ1NWFiNjgyN2Q0Y2M4NDIyNGI3ZjU3ZWVjMWViL2RtZXNnLXlvY3RvLXZwLTIzOjIw
MTQwOTI3MDYzNTI5OmkzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NTozLjE3LjAtcmM2LTAy
MDM4LWdmZTM0YWQxOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZmUz
NGFkMWM3ZjY0NTVhYjY4MjdkNGNjODQyMjRiN2Y1N2VlYzFlYi9kbWVzZy15b2N0by1pdmI0
MS0xMDg6MjAxNDA5MjgxMzUxMzE6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZmUzNGFkMWM3ZjY0NTVhYjY4Mjdk
NGNjODQyMjRiN2Y1N2VlYzFlYi9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xMTI6MjAxNDA5
MjgxMzUxNDY6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDUvZmUzNGFkMWM3ZjY0NTVhYjY4MjdkNGNjODQyMjRiN2Y1
N2VlYzFlYi9kbWVzZy1xdWFudGFsLWl2YjQxLTcyOjIwMTQwOTI4MTM1MTQzOmkzODYtcmFu
ZGNvbmZpZy1jMS0wOTI3MDA0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1L2ZlMzRhZDFjN2Y2NDU1YWI2ODI3ZDRjYzg0MjI0YjdmNTdlZWMxZWIvZG1lc2cteW9j
dG8ta2J1aWxkLTE6MjAxNDA5MjgxMzQ4Mzg6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjMuMTcuMC1yYzYtMDIwMzgtZ2ZlMzRhZDE6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wOTI3MDA0NS9mZTM0YWQxYzdmNjQ1NWFiNjgyN2Q0Y2M4NDIyNGI3ZjU3ZWVjMWViL2Rt
ZXNnLXlvY3RvLWxrcC1uZXgwNC0zMToyMDE0MDkyODEzNTEzMDppMzg2LXJhbmRjb25maWct
YzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9mZTM0
YWQxYzdmNjQ1NWFiNjgyN2Q0Y2M4NDIyNGI3ZjU3ZWVjMWViL2RtZXNnLXlvY3RvLWtidWls
ZC0xNToyMDE0MDkyODEzNDgzNzppMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDU6My4xNy4w
LXJjNi0wMjAzOC1nZmUzNGFkMToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5Mjcw
MDQ1L2ZlMzRhZDFjN2Y2NDU1YWI2ODI3ZDRjYzg0MjI0YjdmNTdlZWMxZWIvZG1lc2cteW9j
dG8taXZiNDEtMzE6MjAxNDA5MjgxMzUxMzE6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvZmUzNGFkMWM3ZjY0NTVh
YjY4MjdkNGNjODQyMjRiN2Y1N2VlYzFlYi9kbWVzZy1xdWFudGFsLWl2YjQxLTc6MjAxNDA5
MjgxMzUxNDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDkyNzAwNDUvZmUzNGFkMWM3ZjY0NTVhYjY4MjdkNGNjODQyMjRiN2Y1
N2VlYzFlYi9kbWVzZy15b2N0by1pdmI0MS03NDoyMDE0MDkyODEzNTEzMTppMzg2LXJhbmRj
b25maWctYzEtMDkyNzAwNDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0
NS9mZTM0YWQxYzdmNjQ1NWFiNjgyN2Q0Y2M4NDIyNGI3ZjU3ZWVjMWViL2RtZXNnLXF1YW50
YWwtaXZiNDEtNTg6MjAxNDA5MjgxMzUxNDM6aTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1
OjoKMDoxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQg
ZmUzNGFkMSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA5MjcwMCcK
Cj09PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09Ck5vdGU6IGNoZWNraW5nIG91dCAn
bGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVkIEhFQUQnIHN0YXRlLiBZb3Ug
Y2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApjaGFuZ2VzIGFuZCBjb21taXQg
dGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0cyB5b3UgbWFrZSBpbiB0aGlz
CnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hlcyBieSBwZXJmb3JtaW5nIGFu
b3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVhdGUgYSBuZXcgYnJhbmNoIHRv
IHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkKZG8gc28gKG5vdyBvciBsYXRl
cikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29tbWFuZCBhZ2Fpbi4gRXhhbXBs
ZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFtZQoKSEVBRCBpcyBub3cgYXQg
MWUzODI3Yi4uLiBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Zpcm8vdmZzCmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUvbGludXM6
bWFzdGVyOjFlMzgyN2JmOGFlYmUyOWFmMmQ2ZTQ5Yjg5ZDg1ZGZhZTRkMDE1NGY6YmlzZWN0
LWxpbnV4LTAKCjIwMTQtMDktMjggMTg6NTE6MjQgMWUzODI3YmY4YWViZTI5YWYyZDZlNDli
ODlkODVkZmFlNGQwMTU0ZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUt
MWUzODI3YmY4YWViZTI5YWYyZDZlNDliODlkODVkZmFlNGQwMTU0ZgpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LzFlMzgyN2JmOGFl
YmUyOWFmMmQ2ZTQ5Yjg5ZDg1ZGZhZTRkMDE1NGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvL2kzODYtcmFuZGNvbmZpZy1jMS0w
OTI3MDA0NS0xZTM4MjdiZjhhZWJlMjlhZjJkNmU0OWI4OWQ4NWRmYWU0ZDAxNTRmChtbMTsz
NW0yMDE0LTA5LTI4IDIwOjUyOjI0IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVz
dHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS0xZTM4MjdiZjhh
ZWJlMjlhZjJkNmU0OWI4OWQ4NWRmYWU0ZDAxNTRmG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8t
c21va2UvaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTFlMzgyN2JmOGFlYmUyOWFmMmQ2
ZTQ5Yjg5ZDg1ZGZhZTRkMDE1NGYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wOTI3MDA0NS8xZTM4MjdiZjhhZWJlMjlhZjJkNmU0OWI4OWQ4NWRmYWU0ZDAxNTRmL3Zt
bGludXotMy4xNy4wLXJjNi0wMDMzNC1nMWUzODI3YgoKMjAxNC0wOS0yOCAyMDo1NzoyNCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMQkyCTMJOAkx
NAkyMQkzNQk1MAk1NQk1OQk2MCBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09
PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxZTM4MjdiLi4uIE1lcmdlIGJy
YW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdmlyby92ZnMKSEVBRCBpcyBub3cgYXQgNGQ4NDI2Zi4uLiBBZGQgbGlu
dXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA5MjYKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS9uZXh0Om1hc3Rl
cjo0ZDg0MjZmOWFjNjAxZGIyYTY0ZmE3YmU2NDA1MWQwMmI5YzlmZTAxOmJpc2VjdC1saW51
eC0wCgoyMDE0LTA5LTI4IDIzOjMwOjU0IDRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUx
ZDAyYjljOWZlMDEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvY2Fpcm8vaTM4Ni1yYW5kY29uZmlnLWMxLTA5MjcwMDQ1LTRkODQy
NmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUxZDAyYjljOWZlMDEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS80ZDg0MjZmOWFjNjAxZGIy
YTY0ZmE3YmU2NDA1MWQwMmI5YzlmZTAxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAw
NDUtNGQ4NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMQobWzE7MzVtMjAx
NC0wOS0yOCAyMzo0Njo1NCBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1
aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctYzEtMDkyNzAwNDUtNGQ4NDI2ZjlhYzYwMWRi
MmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvLXNtb2tl
L2kzODYtcmFuZGNvbmZpZy1jMS0wOTI3MDA0NS00ZDg0MjZmOWFjNjAxZGIyYTY0ZmE3YmU2
NDA1MWQwMmI5YzlmZTAxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDky
NzAwNDUvNGQ4NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMS92bWxpbnV6
LTMuMTcuMC1yYzYtbmV4dC0yMDE0MDkyNgoKMjAxNC0wOS0yOCAyMzo0OTo1NCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJMgkzCTgJMjIJMjkJMzgJNDIJNDkJNTAuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTUxLgk1Mwk1NAk1NQk1OAk2
MCBTVUNDRVNTCgo=

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc6-00208-gf2bb95f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.17.0-rc6 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
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
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
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
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
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
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_MTD_UBI_BLOCK=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
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
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
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
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_KEYBOARD_CAP1106 is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_OLPC_APSP is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RK3X is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_CROS_EC_TUNNEL is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
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
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SYSCON=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_CRYSTAL_COVE is not set
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_IMX_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
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
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_AXP20X is not set
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS65218 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_PTN3460=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_FB_SSD1307=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
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

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_SPI=y
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=y

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
# CONFIG_SND_SOC_FSL_SAI is not set
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_SOC_FSL_ESAI=y
CONFIG_SND_SOC_IMX_AUDMUX=y
# CONFIG_SND_SOC_INTEL_SST is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
CONFIG_SND_SOC_ALC5623=y
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4265=y
# CONFIG_SND_SOC_CS4270 is not set
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
CONFIG_SND_SOC_PCM512x_SPI=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
CONFIG_SND_SOC_SPDIF=y
# CONFIG_SND_SOC_STA350 is not set
CONFIG_SND_SOC_TAS2552=y
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TLV320AIC31XX is not set
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
# CONFIG_SND_SOC_WM8731 is not set
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
# CONFIG_SND_SOC_WM8750 is not set
CONFIG_SND_SOC_WM8753=y
# CONFIG_SND_SOC_WM8770 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
# CONFIG_SND_SOC_WM8962 is not set
CONFIG_SND_SOC_TPA6130A2=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
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
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_OF_ARASAN=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_FB_OLPC_DCON is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_RTS5208 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=y
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD7606_IFACE_SPI=y
# CONFIG_AD7780 is not set
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
CONFIG_AD9910=y
CONFIG_AD9951=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
# CONFIG_SENSORS_HMC5843_SPI is not set

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_FB_XGI is not set
CONFIG_FT1000=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_MTD_SPINAND_MT29F=y
# CONFIG_MTD_SPINAND_ONDIEECC is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
CONFIG_EXTCON_SM5502=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y
CONFIG_MMA8452=y
# CONFIG_KXCJK1013 is not set

#
# Analog to digital converters
#
CONFIG_AD7266=y
CONFIG_AD7291=y
CONFIG_AD7298=y
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
CONFIG_AD799X=y
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1027=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y
CONFIG_VF610_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16480 is not set
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_ISL29125=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_AK09911=y
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_MPL115 is not set
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_T5403=y

#
# Lightning sensors
#
# CONFIG_AS3935 is not set

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_FSL_FTM is not set
CONFIG_PWM_LP3943=y
# CONFIG_PWM_LPSS is not set
CONFIG_PWM_PCA9685=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
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
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

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
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--R3G7APHDIzY6R/pk--
