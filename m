Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaKVSmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:42:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:36282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaKVSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:42:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,438,1413270000"; 
   d="scan'208";a="636497847"
Date: Sat, 22 Nov 2014 10:42:31 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@linaro.org>, LKP <lkp@01.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [spi/of] WARNING: CPU: 0 PID: 1 at drivers/spi/spi.c:2434 spi_init()
Message-ID: <20141122184231.GA29361@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux devicetree/next-overlay

commit 9b84294398291359d6c8f4ac4f36c7c666c6948a
Author:     Pantelis Antoniou <pantelis.antoniou@konsulko.com>
AuthorDate: Tue Oct 28 22:36:05 2014 +0200
Commit:     Grant Likely <grant.likely@linaro.org>
CommitDate: Fri Nov 21 16:51:58 2014 +0000

    spi/of: Add OF notifier handler
    
    Add OF notifier handler needed for creating/destroying spi devices
    according to dynamic runtime changes in the DT live tree. This code is
    enabled when CONFIG_OF_DYNAMIC is selected.
    
    Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

+-----------------------------------------+------------+------------+------------+
|                                         | 528a376eb2 | 9b84294398 | 7ddde6bcf8 |
+-----------------------------------------+------------+------------+------------+
| boot_successes                          | 60         | 0          | 0          |
| boot_failures                           | 0          | 20         | 12         |
| WARNING:at_drivers/spi/spi.c:spi_init() | 0          | 20         | 12         |
| backtrace:spi_init                      | 0          | 20         | 12         |
| backtrace:warn_slowpath_null            | 0          | 20         | 12         |
| backtrace:kernel_init_freeable          | 0          | 20         | 12         |
+-----------------------------------------+------------+------------+------------+

[    0.157186] regulator-dummy: no parameters
[    0.158309] NET: Registered protocol family 16
[    0.160561] ------------[ cut here ]------------
[    0.161315] WARNING: CPU: 0 PID: 1 at drivers/spi/spi.c:2434 spi_init+0x5c/0x81()
[    0.162667] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc5-00044-g9b84294 #6
[    0.167195]  00000000 00000000 51c75ef0 4160e32b 51c75f0c 4103776f 00000982 41abbd9c
[    0.168590]  00000000 41abbd40 51e60ea0 51c75f1c 41037817 00000009 00000000 51c75f28
[    0.170011]  41abbd9c 00000000 51c75f88 41a82c87 00000000 53ff7821 51c75f00 4104e04b
[    0.171428] Call Trace:
[    0.171820]  [<4160e32b>] dump_stack+0x16/0x18
[    0.172513]  [<4103776f>] warn_slowpath_common+0x61/0x78
[    0.173394]  [<41abbd9c>] ? spi_init+0x5c/0x81
[    0.174081]  [<41abbd40>] ? ftrace_define_fields_spi_transfer+0x85/0x85
[    0.175070]  [<41037817>] warn_slowpath_null+0x14/0x18
[    0.175871]  [<41abbd9c>] spi_init+0x5c/0x81
[    0.176584]  [<41a82c87>] do_one_initcall+0x100/0x1aa
[    0.177382]  [<4104e04b>] ? parse_args+0x2c7/0x3e1
[    0.178120]  [<41a82435>] ? do_early_param+0x73/0x73
[    0.178892]  [<41a82e0c>] kernel_init_freeable+0xdb/0x158
[    0.179736]  [<41a82e0c>] ? kernel_init_freeable+0xdb/0x158
[    0.180020]  [<4160ab57>] kernel_init+0xd/0xb8
[    0.180755]  [<41615980>] ret_from_kernel_thread+0x20/0x30
[    0.181634]  [<4160ab4a>] ? rest_init+0xa5/0xa5
[    0.182354] ---[ end trace d94d5f4e01dcfac4 ]---
[    0.210073] cpuidle: using governor menu

git bisect start 7ddde6bcf8a4f0d1ed5e4aa1738ac0a190c46342 0df1f2487d2f0d04703f142813d53615d62a1da4 --
git bisect good 53a4ab96c61a34d62717b1481f6043e0b4338d74  # 17:50     20+      0  of: Change of_device_is_available() to return bool
git bisect good 8c77e1164d2c04e401807d11c854484716c6e84f  # 17:52     20+      0  of/overlay: Add overlay unittests
git bisect good 0eec03c7fbec316b885ee158f0f57a618392cab5  # 17:56     20+      0  fixup of_platform
git bisect good 0b90f7808351f9d0c0a2ba6cd96f4246505b592b  # 17:59     20+      0  i2c: Add OF notifier handler
git bisect good 528a376eb2db8e9b18054ab4dee952b9dfddef57  # 18:03     20+      0  spi/of: Create new device registration method and accessors
git bisect  bad 9b84294398291359d6c8f4ac4f36c7c666c6948a  # 18:06      0-     20  spi/of: Add OF notifier handler
# first bad commit: [9b84294398291359d6c8f4ac4f36c7c666c6948a] spi/of: Add OF notifier handler
git bisect good 528a376eb2db8e9b18054ab4dee952b9dfddef57  # 18:09     60+      0  spi/of: Create new device registration method and accessors
git bisect  bad 7ddde6bcf8a4f0d1ed5e4aa1738ac0a190c46342  # 18:09      0-     12  HACK: Make overlay support user selectable
git bisect good 8a84e01e147f44111988f9d8ccd2eaa30215a0f2  # 18:12     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good ed6778aef7428a6c5fc1acf08a3e9126f5eef770  # 18:16     60+      0  Add linux-next specific files for 20141121


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
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

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-21:20141122180322:i386-randconfig-ib0-11221632:3.18.0-rc5-00044-g9b84294:6"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc5-00044-g9b84294 (kbuild@lkp-ib03) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #6 PREEMPT Sat Nov 22 18:04:31 CST 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x02dfffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0213b000, 0x0213bfff] PGTABLE
[    0.000000] BRK [0x0213c000, 0x0213cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x0213d000, 0x0213dfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1972680
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-ib0-11221632/glikely:devicetree:next-overlay:9b84294398291359d6c8=
f4ac4f36c7c666c6948a:bisect-linux-4/.vmlinuz-9b84294398291359d6c8f4ac4f36c7=
c666c6948a-20141122180436-1-kbuild branch=3Dglikely/devicetree/next-overlay=
 BOOT_IMAGE=3D/kernel/i386-randconfig-ib0-11221632/9b84294398291359d6c8f4ac=
4f36c7c666c6948a/vmlinuz-3.18.0-rc5-00044-g9b84294 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 280128K/327280K available (6235K kernel code, 1153K =
rwdata, 3360K rodata, 552K init, 6240K bss, 47152K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
[    0.000000]     vmalloc : 0x547fe000 - 0xff7fe000   (2736 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53ffe000   ( 319 MB)
[    0.000000]       .init : 0x41a82000 - 0x41b0c000   ( 552 kB)
[    0.000000]       .data : 0x416170c0 - 0x41a804c0   (4517 kB)
[    0.000000]       .text : 0x41000000 - 0x416170c0   (6236 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 0
[    0.000000] CPU 0 irqstacks, hard=3D51c08000 soft=3D51c0a000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4895 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D26935280)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.026238] ACPI: All ACPI Tables successfully acquired
[    0.030239] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.031070] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.034636] Initializing cgroup subsys devices
[    0.040012] Initializing cgroup subsys freezer
[    0.040700] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.040700] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.043215] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, ste=
pping: 01)
[    0.056668] ftrace: allocating 28008 entries in 55 pages
[    0.080421] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.082475]=20
[    0.082475] **********************************************************
[    0.083521] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.084326] **                                                      **
[    0.085126] ** trace_printk() being used. Allocating extra memory.  **
[    0.085973] **                                                      **
[    0.086783] ** This means that this is a DEBUG kernel and it is     **
[    0.087588] ** unsafe for produciton use.                           **
[    0.088395] **                                                      **
[    0.090022] ** If you see this message and you are not debugging    **
[    0.090835] ** the kernel, report this immediately to your vendor!  **
[    0.091631] **                                                      **
[    0.092439] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.093306] **********************************************************
[    0.098718] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.100019] Getting VERSION: 1050014
[    0.100480] Getting VERSION: 1050014
[    0.100937] Getting ID: 0
[    0.101302] Getting ID: f000000
[    0.101707] Getting LVT0: 8700
[    0.102101] Getting LVT1: 8400
[    0.102577] enabled ExtINT on CPU#0
[    0.110021] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.111945] ENABLING IO-APIC IRQs
[    0.112413] init IO_APIC IRQs
[    0.112795]  apic 0 pin 0 not connected
[    0.114426] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.115438] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.116436] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.120047] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.121041] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.122024] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.123047] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.124034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.125015] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.130035] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.131025] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.132058] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.133062] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.134064] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.135073] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.140034] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.141051]  apic 0 pin 16 not connected
[    0.141543]  apic 0 pin 17 not connected
[    0.142022]  apic 0 pin 18 not connected
[    0.142560]  apic 0 pin 19 not connected
[    0.143040]  apic 0 pin 20 not connected
[    0.143530]  apic 0 pin 21 not connected
[    0.144012]  apic 0 pin 22 not connected
[    0.144501]  apic 0 pin 23 not connected
[    0.145138] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.150056] TSC deadline timer enabled
[    0.157186] regulator-dummy: no parameters
[    0.158309] NET: Registered protocol family 16
[    0.160561] ------------[ cut here ]------------
[    0.161315] WARNING: CPU: 0 PID: 1 at drivers/spi/spi.c:2434 spi_init+0x=
5c/0x81()
[    0.162667] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc5-00044-g9b=
84294 #6
[    0.167195]  00000000 00000000 51c75ef0 4160e32b 51c75f0c 4103776f 00000=
982 41abbd9c
[    0.168590]  00000000 41abbd40 51e60ea0 51c75f1c 41037817 00000009 00000=
000 51c75f28
[    0.170011]  41abbd9c 00000000 51c75f88 41a82c87 00000000 53ff7821 51c75=
f00 4104e04b
[    0.171428] Call Trace:
[    0.171820]  [<4160e32b>] dump_stack+0x16/0x18
[    0.172513]  [<4103776f>] warn_slowpath_common+0x61/0x78
[    0.173394]  [<41abbd9c>] ? spi_init+0x5c/0x81
[    0.174081]  [<41abbd40>] ? ftrace_define_fields_spi_transfer+0x85/0x85
[    0.175070]  [<41037817>] warn_slowpath_null+0x14/0x18
[    0.175871]  [<41abbd9c>] spi_init+0x5c/0x81
[    0.176584]  [<41a82c87>] do_one_initcall+0x100/0x1aa
[    0.177382]  [<4104e04b>] ? parse_args+0x2c7/0x3e1
[    0.178120]  [<41a82435>] ? do_early_param+0x73/0x73
[    0.178892]  [<41a82e0c>] kernel_init_freeable+0xdb/0x158
[    0.179736]  [<41a82e0c>] ? kernel_init_freeable+0xdb/0x158
[    0.180020]  [<4160ab57>] kernel_init+0xd/0xb8
[    0.180755]  [<41615980>] ret_from_kernel_thread+0x20/0x30
[    0.181634]  [<4160ab4a>] ? rest_init+0xa5/0xa5
[    0.182354] ---[ end trace d94d5f4e01dcfac4 ]---
[    0.210073] cpuidle: using governor menu
[    0.211402] ACPI: bus type PCI registered
[    0.212237] dca service started, version 1.12.1
[    0.213047] PCI: Using configuration type 1 for base access
[    0.247873] Running resizable hashtable tests...
[    0.248676]   Adding 2048 keys
[    0.580513]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.581786]   Table expansion iteration 0...
[    0.610164]   Verifying lookups...
[    0.610798]   Table expansion iteration 1...
[    0.640176]   Verifying lookups...
[    0.640913]   Table expansion iteration 2...
[    0.670223]   Verifying lookups...
[    0.671027]   Table expansion iteration 3...
[    0.700294]   Verifying lookups...
[    0.701478]   Table shrinkage iteration 0...
[    0.730126]   Verifying lookups...
[    0.730891]   Table shrinkage iteration 1...
[    0.760115]   Verifying lookups...
[    0.761074]   Table shrinkage iteration 2...
[    0.790080]   Verifying lookups...
[    0.790824]   Table shrinkage iteration 3...
[    0.820062]   Verifying lookups...
[    0.820995]   Deleting 2048 keys
[    1.120773] ACPI: Added _OSI(Module Device)
[    1.121584] ACPI: Added _OSI(Processor Device)
[    1.122413] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.123320] ACPI: Added _OSI(Processor Aggregator Device)
[    1.126222] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.136627] ACPI: Interpreter enabled
[    1.137405] ACPI: (supports S0 S4 S5)
[    1.137996] ACPI: Using IOAPIC for interrupt routing
[    1.140158] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.157314] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.158246] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    1.159099] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.160855] PCI host bridge to bus 0000:00
[    1.161470] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.162262] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.163183] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.164100] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.165172] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.166245] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.167984] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.169886] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.173072] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.175506] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.177243] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.178559] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.180016] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.182091] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.183860] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.185429] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.187654] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.190805] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.193684] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.202278] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.208403] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.211283] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.215504] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.222275] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.224283] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.226081] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.231680] pci_bus 0000:00: on NUMA node 0
[    1.234021] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.235607] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.237251] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.238798] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.240190] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.242485] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.245369] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.246530] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.248108] vgaarb: loaded
[    1.248641] vgaarb: bridge control possible 0000:00:02.0
[    1.251366] EDAC MC: Ver: 3.0.0
[    1.253639] PCI: Using ACPI for IRQ routing
[    1.254525] PCI: pci_cache_line_size set to 64 bytes
[    1.255697] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.256928] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.261659] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.263008] Switched to clocksource kvm-clock
[    1.264691] Warning: could not register annotated branches stats
[    1.324187] FS-Cache: Loaded
[    1.324821] CacheFiles: Loaded
[    1.325545] pnp: PnP ACPI init
[    1.326338] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.327984] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.329144] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.330802] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.331966] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.333614] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.334707] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.336191] pnp 00:03: [dma 2]
[    1.336842] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.338190] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.339716] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.341044] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.342598] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.343789] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.345396] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.347440] pnp: PnP ACPI: found 7 devices
[    1.384851] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.386013] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.387405] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.388705] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.390295] NET: Registered protocol family 1
[    1.391338] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.392661] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.394067] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.395446] pci 0000:00:02.0: Video device with shadowed ROM
[    1.396741] PCI: CLS 0 bytes, default 64
[    1.398609] Unpacking initramfs...
[    2.640338] Freeing initrd memory: 24852K (527ab000 - 53ff0000)
[    2.648698] apm: BIOS not found.
[    2.652244] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.653767] NatSemi SCx200 Driver
[    2.654614] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.657470] spin_lock-torture: Creating torture_shuffle task
[    2.658499] spin_lock-torture: torture_shuffle task started
[    2.659502] spin_lock-torture: Creating torture_stutter task
[    2.660544] spin_lock-torture: Creating lock_torture_writer task
[    2.661559] spin_lock-torture: torture_stutter task started
[    2.662554] spin_lock-torture: Creating lock_torture_writer task
[    2.663630] spin_lock-torture: lock_torture_writer task started
[    2.664749] spin_lock-torture: Creating lock_torture_stats task
[    2.665800] spin_lock-torture: lock_torture_writer task started
[    2.666965] torture_init_begin: refusing rcu init: spin_lock running
[    2.668890] futex hash table entries: 256 (order: 1, 11264 bytes)
[    2.670041] spin_lock-torture: lock_torture_stats task started
[    2.690502] zpool: loaded
[    2.691189] VFS: Disk quotas dquot_6.5.2
[    2.692020] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.693770] ntfs: driver 2.1.31 [Flags: R/O].
[    2.694756] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.697177] SGI XFS with ACLs, security attributes, no debug enabled
[    2.698718] befs: version: 0.9.3
[    2.699809] gfs2: GFS2 installed
[    2.700635] msgmni has been set to 595
[    2.707052] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    2.708420] io scheduler noop registered
[    2.709165] io scheduler deadline registered (default)
[    2.710191] start plist test
[    2.719510] end plist test
[    2.719980] test_string_helpers: Running tests...
[    2.722586] test_firmware: interface ready
[    2.724762] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.725662] crc32: self tests passed, processed 225944 bytes in 720636 n=
sec
[    2.727551] crc32c: CRC_LE_BITS =3D 8
[    2.728238] crc32c: self tests passed, processed 225944 bytes in 310556 =
nsec
[    2.784521] crc32_combine: 8373 self tests passed
[    2.819966] crc32c_combine: 8373 self tests passed
[    2.821100] xz_dec_test: module loaded
[    2.821803] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
253 0' and write .xz files to it.
[    2.824665] ipmi message handler version 39.2
[    2.825316] ipmi device interface
[    2.825942] IPMI System Interface driver.
[    2.826772] ipmi_si: Unable to find any System Interface(s)
[    2.827597] IPMI Watchdog: driver initialized
[    2.828676] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.829750] ACPI: Power Button [PWRF]
[    2.830989] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.888240] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.934514] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.937569] toshiba: not a supported Toshiba laptop
[    2.938421] scx200_gpio: no SCx200 gpio present
[    2.939188] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.940241] platform pc8736x_gpio.0: no device found
[    2.941119] nsc_gpio initializing
[    2.941597] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.942434] Linux agpgart interface v0.103
[    2.943858] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.949849] loop: module loaded
[    2.950506] HP CISS Driver (v 3.6.26)
[    2.951639] MM: desc_per_page =3D 128
[    2.965090] mtip32xx Version 1.3.1
[    2.966402]  nullb0: unknown partition table
[    2.967788]  nullb1: unknown partition table
[    2.971860] null: module loaded
[    2.982578] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.984007] Phantom Linux Driver, version n0.9.8, init OK
[    2.985271] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.986171] c2port c2port0: C2 port uc added
[    2.986595] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.988419] Uniform Multi-Platform E-IDE driver
[    2.990897] ide-gd driver 1.18
[    2.991402] ide-cd driver 5.00
[    2.993032] SSFDC read-only Flash Translation layer
[    2.993848] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    2.994831] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.995949] device id =3D 2440
[    2.996381] device id =3D 2480
[    2.996807] device id =3D 24c0
[    2.997210] device id =3D 24d0
[    2.997580] device id =3D 25a1
[    2.998019] device id =3D 2670
[    2.998487] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.999438] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    3.038961] No valid DiskOnChip devices found
[    3.039741] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.041094] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.044876] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.046181] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.047473] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.048775] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.060033] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.060969] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.061581] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.062532] flash size: 128 MiB
[    3.063026] page size: 512 bytes
[    3.063467] OOB area size: 16 bytes
[    3.063993] sector size: 16 KiB
[    3.064467] pages number: 262144
[    3.064946] pages per sector: 32
[    3.065377] bus width: 8
[    3.065753] bits in sector size: 14
[    3.066291] bits in page size: 9
[    3.066771] bits in OOB size: 4
[    3.067237] flash size with OOB: 135168 KiB
[    3.067827] page address bytes: 4
[    3.068314] sector address bytes: 3
[    3.068856] options: 0x42
[    3.069789] Scanning device for bad blocks
[    3.096351] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.097228] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.100926] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.103087] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.104004] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.105564] mousedev: PS/2 mouse device common for all mice
[    3.106544] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    3.108450] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.109793] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.113907] mk712: device not present
[    3.114962] I2O subsystem v1.325
[    3.115433] i2o: max drivers =3D 8
[    3.118123] I2O Bus Adapter OSM v1.317
[    3.118712] I2O Block Device OSM v1.325
[    3.119680] I2O ProcFS OSM v1.316
[    3.120318] i2c /dev entries driver
[    3.121753] i2c-parport-light: adapter type unspecified
[    3.122934] isa i2c-pca-isa.0: Please specify I/O base
[    3.123965] Driver for 1-wire Dallas network protocol.
[    3.124966] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.125993] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    3.127584] power_supply test_ac: uevent
[    3.128178] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.129026] power_supply test_ac: prop ONLINE=3D1
[    3.129650] power_supply test_ac: power_supply_changed
[    3.130482] power_supply test_ac: power_supply_changed_work
[    3.131272] power_supply test_ac: uevent
[    3.131821] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.132638] power_supply test_ac: prop ONLINE=3D1
[    3.133567] power_supply test_battery: uevent
[    3.134176] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.135123] power_supply test_battery: prop STATUS=3DDischarging
[    3.135945] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.136749] power_supply test_battery: prop HEALTH=3DGood
[    3.137435] power_supply test_battery: prop PRESENT=3D1
[    3.138170] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.139001] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.139874] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.140706] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.141421] power_supply test_battery: prop CAPACITY=3D50
[    3.142192] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.143110] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.144027] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.144932] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.145826] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.146686] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc5-0=
0044-g9b84294
[    3.147800] power_supply test_battery: prop TEMP=3D26
[    3.148553] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.149707] power_supply test_battery: power_supply_changed
[    3.150553] power_supply test_battery: power_supply_changed_work
[    3.151420] power_supply test_battery: uevent
[    3.152043] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.152975] power_supply test_battery: prop STATUS=3DDischarging
[    3.153752] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.154585] power_supply test_battery: prop HEALTH=3DGood
[    3.155333] power_supply test_battery: prop PRESENT=3D1
[    3.156060] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.156845] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.157696] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.158471] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.159260] power_supply test_battery: prop CAPACITY=3D50
[    3.160218] power_supply test_usb: uevent
[    3.160781] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.161567] power_supply test_usb: prop ONLINE=3D1
[    3.162249] power_supply test_usb: power_supply_changed
[    3.164487] applesmc: supported laptop not found!
[    3.165162] applesmc: driver init failed (ret=3D-19)!
[    3.170037] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.170904] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.171774] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.172693] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.173566] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.174391] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc5-0=
0044-g9b84294
[    3.175514] power_supply test_battery: prop TEMP=3D26
[    3.176197] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.177002] power_supply test_usb: power_supply_changed_work
[    3.177769] power_supply test_usb: uevent
[    3.178358] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.179192] power_supply test_usb: prop ONLINE=3D1
[    3.180504] sdhci: Secure Digital Host Controller Interface driver
[    3.181379] sdhci: Copyright(c) Pierre Ossman
[    3.182086] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.182946] wbsd: Copyright(c) Pierre Ossman
[    3.183706] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.185937] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.189438] hdaps: supported laptop not found!
[    3.190149] hdaps: driver init failed (ret=3D-19)!
[    3.191679]=20
[    3.191679] printing PIC contents
[    3.192377] ... PIC  IMR: ffff
[    3.192816] ... PIC  IRR: 1013
[    3.193279] ... PIC  ISR: 0000
[    3.193712] ... PIC ELCR: 0c00
[    3.194143] printing local APIC contents on CPU#0/0:
[    3.194930] ... APIC ID:      00000000 (0)
[    3.195510] ... APIC VERSION: 01050014
[    3.196071] ... APIC TASKPRI: 00000000 (00)
[    3.196657] ... APIC PROCPRI: 00000000
[    3.197162] ... APIC LDR: 01000000
[    3.197652] ... APIC DFR: ffffffff
[    3.198142] ... APIC SPIV: 000001ff
[    3.198653] ... APIC ISR field:
[    3.199138] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.200125] ... APIC TMR field:
[    3.200125] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.200125] ... APIC IRR field:
[    3.200125] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.200125] ... APIC ESR: 00000000
[    3.200125] ... APIC ICR: 00000831
[    3.200125] ... APIC ICR2: 01000000
[    3.200125] ... APIC LVTT: 000400ef
[    3.200125] ... APIC LVTPC: 00000400
[    3.200125] ... APIC LVT0: 00010700
[    3.200125] ... APIC LVT1: 00000400
[    3.200125] ... APIC LVTERR: 000000fe
[    3.200125] ... APIC TMICT: 00000000
[    3.200125] ... APIC TMCCT: 00000000
[    3.200125] ... APIC TDCR: 00000000
[    3.200125]=20
[    3.209843] number of MP IRQ sources: 15.
[    3.210459] number of IO-APIC #0 registers: 24.
[    3.211134] testing the IO APIC.......................
[    3.211901] IO APIC #0......
[    3.212347] .... register #00: 00000000
[    3.212939] .......    : physical APIC id: 00
[    3.213522] .......    : Delivery Type: 0
[    3.214087] .......    : LTS          : 0
[    3.214688] .... register #01: 00170011
[    3.215218] .......     : max redirection entries: 17
[    3.215927] .......     : PRQ implemented: 0
[    3.216549] .......     : IO APIC version: 11
[    3.217149] .... register #02: 00000000
[    3.217685] .......     : arbitration: 00
[    3.218263] .... IRQ redirection table:
[    3.218814] 1    0    0   0   0    0    0    00
[    3.219478] 0    0    0   0   0    1    1    31
[    3.220169] 0    0    0   0   0    1    1    30
[    3.220845] 0    0    0   0   0    1    1    33
[    3.221489] 1    0    0   0   0    1    1    34
[    3.222169] 1    1    0   0   0    1    1    35
[    3.222853] 0    0    0   0   0    1    1    36
[    3.223573] 0    0    0   0   0    1    1    37
[    3.224228] 0    0    0   0   0    1    1    38
[    3.224870] 0    1    0   0   0    1    1    39
[    3.225491] 1    1    0   0   0    1    1    3A
[    3.226171] 1    1    0   0   0    1    1    3B
[    3.226845] 0    0    0   0   0    1    1    3C
[    3.227525] 0    0    0   0   0    1    1    3D
[    3.228222] 0    0    0   0   0    1    1    3E
[    3.228870] 0    0    0   0   0    1    1    3F
[    3.229534] 1    0    0   0   0    0    0    00
[    3.230249] 1    0    0   0   0    0    0    00
[    3.230926] 1    0    0   0   0    0    0    00
[    3.231603] 1    0    0   0   0    0    0    00
[    3.232312] 1    0    0   0   0    0    0    00
[    3.233010] 1    0    0   0   0    0    0    00
[    3.233662] 1    0    0   0   0    0    0    00
[    3.234352] 1    0    0   0   0    0    0    00
[    3.235009] IRQ to pin mappings:
[    3.235515] IRQ0 -> 0:2
[    3.235928] IRQ1 -> 0:1
[    3.236356] IRQ3 -> 0:3
[    3.236770] IRQ4 -> 0:4
[    3.237177] IRQ5 -> 0:5
[    3.237549] IRQ6 -> 0:6
[    3.237971] IRQ7 -> 0:7
[    3.238382] IRQ8 -> 0:8
[    3.238803] IRQ9 -> 0:9
[    3.239208] IRQ10 -> 0:10
[    3.239642] IRQ11 -> 0:11
[    3.240125] IRQ12 -> 0:12
[    3.240548] IRQ13 -> 0:13
[    3.240976] IRQ14 -> 0:14
[    3.241388] IRQ15 -> 0:15
[    3.241825] .................................... done.
[    3.242626] Using IPI Shortcut mode
[    3.243672] Running ring buffer tests...
[    3.311837] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    3.313492] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    3.640126] tsc: Refined TSC clocksource calibration: 2693.504 MHz
[   13.240101] finished
[   13.240493] CPU 0:
[   13.240821]               events:    999
[   13.241452]        dropped bytes:    0
[   13.242056]        alloced bytes:    77232
[   13.242689]        written bytes:    75750
[   13.243335]        biggest event:    93
[   13.243946]       smallest event:    0
[   13.245077]          read events:   999
[   13.245687]          lost events:   0
[   13.246270]         total events:   999
[   13.246881]   recorded len bytes:   77232
[   13.247505]  recorded size bytes:   75750
[   13.248141] Ring buffer PASSED!
[   13.251264] Freeing unused kernel memory: 552K (41a82000 - 41b0c000)
[   13.260123] random: init urandom read with 2 bits of entropy available
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[   13.341343] Unregister pv shared memory for cpu 0
[   13.342121] spin_lock-torture: Unscheduled system shutdown detected
[   13.344208] reboot: Restarting system
[   13.344770] reboot: machine restart
Elapsed time: 20
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i38=
6-randconfig-ib0-11221632/9b84294398291359d6c8f4ac4f36c7c666c6948a/vmlinuz-=
3.18.0-rc5-00044-g9b84294 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeo=
ut=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic =
load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 v=
ga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-ra=
ndconfig-ib0-11221632/glikely:devicetree:next-overlay:9b84294398291359d6c8f=
4ac4f36c7c666c6948a:bisect-linux-4/.vmlinuz-9b84294398291359d6c8f4ac4f36c7c=
666c6948a-20141122180436-1-kbuild branch=3Dglikely/devicetree/next-overlay =
BOOT_IMAGE=3D/kernel/i386-randconfig-ib0-11221632/9b84294398291359d6c8f4ac4=
f36c7c666c6948a/vmlinuz-3.18.0-rc5-00044-g9b84294 drbd.minor_count=3D8'  -i=
nitrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vla=
n=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdo=
g i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-kbuild=
-21 -serial file:/dev/shm/kboot/serial-quantal-kbuild-21 -daemonize -displa=
y none -monitor null=20

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc5-00044-g9b84294"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.18.0-rc5 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
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
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
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
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_CE=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
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
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_X86_16BIT is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
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
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
# CONFIG_ACPI_PROCFS_POWER is not set
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
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

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
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

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
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_OMAP4=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_KEYBOARD_CAP1106=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_OF_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_AR1021_I2C=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
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
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
CONFIG_I2C_CROS_EC_TUNNEL=y
CONFIG_SCx200_ACB=y
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
CONFIG_SPI_GPIO=y
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

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
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_TIMBERDALE=y
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
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_GPIO is not set
# CONFIG_POWER_RESET_GPIO_RESTART is not set
CONFIG_POWER_RESET_LTC2952=y
# CONFIG_POWER_RESET_SYSCON is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_MENF21BMC_HWMON=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_INTEL_SOC_DTS_THERMAL=y
# CONFIG_INT340X_THERMAL is not set

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_MENF21BMC=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_RK808=y
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_HI6421=y
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_RK808=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65218=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_VGASTATE is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_OF_ARASAN is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_MENF21BMC=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_IE31200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
# CONFIG_FSL_EDMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#
CONFIG_SOC_TI=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_EXTCON_RT8973A is not set
# CONFIG_EXTCON_SM5502 is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_FSL_FTM=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
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
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAYFS_FS=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
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
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
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
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_RING_BUFFER_STARTUP_TEST=y

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_RHASHTABLE=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
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
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_LIBFDT=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--VbJkn9YxBvnuCH5J--
