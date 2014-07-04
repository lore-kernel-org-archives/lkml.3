Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbaGDDZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:25:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbaGDDY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,598,1400050800"; 
   d="log'?scan'208";a="538640016"
Message-ID: <53B61E83.7090605@intel.com>
Date: Fri, 04 Jul 2014 11:24:51 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [cgroup] WARNING: CPU: 0 PID: 0 at kernel/cgroup.c:2988 cgroup_init_cftypes()
Content-Type: multipart/mixed;
 boundary="------------060102060606030502050202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060102060606030502050202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Tejun,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl_files
commit 53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu Jul 3 11:18:30 2014 -0400
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Thu Jul 3 11:18:30 2014 -0400

    cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
        Currently cgroup_base_files[] contains the cgroup core interface files
    for both legacy and default hierarchies with each file tagged with
    CFTYPE_INSANE and CFTYPE_ONLY_ON_DFL.  This is difficult to read.
        Let's separate it out to two separate tables, cgroup_dfl_base_files[]
    and cgroup_legacy_base_files[], and use the appropriate one in
    cgroup_mkdir() depending on the hierarchy type.  This makes tagging
    each file unnecessary.
        This patch doesn't introduce any behavior changes.
        Signed-off-by: Tejun Heo <tj@kernel.org>

+-------------------------------------------------------------------------+------------+------------+
|                                                                         | 4eff080ef0 | 53fcf10b90 |
+-------------------------------------------------------------------------+------------+------------+
| boot_successes                                                          | 60         | 0          |
| boot_failures                                                           | 0          | 20         |
| WARNING:CPU:PID:at_kernel/cgroup.c:cgroup_init_cftypes()                | 0          | 20         |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives() | 0          | 20         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                    | 0          | 20         |
| Oops                                                                    | 0          | 20         |
| EIP_is_at_strchr                                                        | 0          | 20         |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task                | 0          | 20         |
| backtrace:cgroup_init_cftypes                                           | 0          | 20         |
| backtrace:warn_slowpath_null                                            | 0          | 20         |
| backtrace:cgroup_init                                                   | 0          | 20         |
| backtrace:register_filesystem                                           | 0          | 20         |
+-------------------------------------------------------------------------+------------+------------+

[    0.020000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.020000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.020227] ------------[ cut here ]------------
[    0.020756] WARNING: CPU: 0 PID: 0 at kernel/cgroup.c:2988 cgroup_init_cftypes+0x7f/0x86()
[    0.021827] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc2-00005-g53fcf10 #369
[    0.022644] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    0.023510]  00000000 00000000 81b97f50 817e52a2 81b97f80 8103257a 81a73029 00000000
[    0.024469]  00000000 81a79d73 00000bac 8106e0cc 8106e0cc 81bb29d8 81bb271c 00000000
[    0.025427]  81b97f90 81032626 00000009 00000000 81b97fa4 8106e0cc 00000000 00020800
[    0.026389] Call Trace:
[    0.026665]  [<817e52a2>] dump_stack+0x16/0x18
[    0.027162]  [<8103257a>] warn_slowpath_common+0x6b/0x82
[    0.027734]  [<8106e0cc>] ? cgroup_init_cftypes+0x7f/0x86
[    0.028322]  [<8106e0cc>] ? cgroup_init_cftypes+0x7f/0x86
[    0.028903]  [<81032626>] warn_slowpath_null+0x1d/0x1f
[    0.029467]  [<8106e0cc>] cgroup_init_cftypes+0x7f/0x86
[    0.030015]  [<81c8213c>] cgroup_init+0x15/0x1a9
[    0.030518]  [<810f123b>] ? proc_mkdir+0x14/0x16
[    0.031030]  [<81c6eb40>] start_kernel+0x41c/0x453
[    0.031546]  [<81c6e4da>] ? set_init_arg+0x49/0x49
[    0.032074]  [<81c6e2cb>] i386_start_kernel+0x79/0x7d
[    0.032622] ---[ end trace f7c9b96c96ca301f ]---
[    0.033214] Initializing cgroup subsys perf_event


git bisect start 7af305fa6329db0131931fa49d30aeb8ebffd865 4c834452aad01531db949414f94f817a86348d59 --
git bisect  bad 15c0370d9a7b84a5be4b4c6eb50b68b3a4c8a054  # 08:55      0-     20  Merge 'bluetooth/master' into devel-lkp-hsx01-i386-201407040014
git bisect good d9f509f8cad2453e734c1deeb876e86d6656cecb  # 08:59     20+      0  Merge 'amirv/for-netdev' into devel-lkp-hsx01-i386-201407040014
git bisect  bad 2f1320f7cecbb26ee09814c18f6ace48452fca11  # 09:01      0-     20  Merge 'cgroup/review-dfl_files' into devel-lkp-hsx01-i386-201407040014
git bisect  bad 53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78  # 09:04      0-     10  cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
git bisect good afbb1b5b595c1a4b1a6f036f220f7b107a504e2d  # 09:14     20+      0  cgroup: make interface file "cgroup.sane_behavior" legacy-only
git bisect good 4eff080ef0fc3d5ba30c6b464c877c24f85b5d71  # 09:17     20+      0  cgroup: clean up sane_behavior handling
# first bad commit: [53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78] cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
git bisect good 4eff080ef0fc3d5ba30c6b464c877c24f85b5d71  # 09:20     60+      0  cgroup: clean up sane_behavior handling
git bisect  bad 7af305fa6329db0131931fa49d30aeb8ebffd865  # 09:20      0-     11  0day head guard for 'devel-lkp-hsx01-i386-201407040014'
git bisect good 5170a3b24a9141e2349a3420448743b7c68f2223  # 09:23     60+      0  Merge branch 'akpm' (patches from Andrew Morton)
git bisect good 0e9ce823ad7bc6b85c279223ae6638d47089461e  # 09:26     60+      0  Add linux-next specific files for 20140703


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
 	-kernel $kernel
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Jet


--------------060102060606030502050202
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-quantal-ivb42-17:20140704090358:i386-randconfig-ha1-0704::"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-quantal-ivb42-17:20140704090358:i386-randconfig-ha1-07";
 filename*1="04::"

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.16.0-rc2-00005-g53fcf10 (kbuild@lkp-hsx01)=
 (gcc version 4.8.2 (Debian 4.8.2-18) ) #369 PREEMPT Fri Jul 4 09:03:30 C=
ST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01=
/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02361000, 0x02361fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001=
 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACS 0x13FFE000 000040
[    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001=
 BXPC 00000001)
[    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001=
 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02362000, 0x02362fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1bab7c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha1-0704/=
linux-devel:devel-lkp-hsx01-i386-201407040014:53fcf10b90f01b8dbdaa9fd380e=
be64a10ffbc78:bisect-linux5/.vmlinuz-53fcf10b90f01b8dbdaa9fd380ebe64a10ff=
bc78-20140704090344-2-ivb42 branch=3Dlinux-devel/devel-lkp-hsx01-i386-201=
407040014 BOOT_IMAGE=3D/kernel/i386-randconfig-ha1-0704/53fcf10b90f01b8db=
daa9fd380ebe64a10ffbc78/vmlinuz-3.16.0-rc2-00005-g53fcf10 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 279468K/327280K available (8136K kernel code, 862K=
 rwdata, 3716K rodata, 536K init, 6536K bss, 47812K reserved, 0K highmem)=

[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81c6e000 - 0x81cf4000   ( 536 kB)
[    0.000000]       .data : 0x817f270c - 0x81c6c9c0   (4584 kB)
[    0.000000]       .text : 0x81000000 - 0x817f270c   (8137 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1=
, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3D80092000 soft=3D80094000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
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
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |fai=
led|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]               recursive read-lock:             |  ok  |   =
          |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |   =
          |failed|
[    0.000000]             mixed read-write-lock:             |failed|   =
          |failed|
[    0.000000]             mixed write-read-lock:             |failed|   =
          |failed|
[    0.000000]   --------------------------------------------------------=
------------------
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
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  o=
k  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bo=
goMIPS (lpj=3D26935060)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Security Framework initialized
[    0.020000] Yama: becoming mindful.
[    0.020000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes=
)
[    0.020000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes)
[    0.020227] ------------[ cut here ]------------
[    0.020756] WARNING: CPU: 0 PID: 0 at kernel/cgroup.c:2988 cgroup_init=
_cftypes+0x7f/0x86()
[    0.021827] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc2-00005-g=
53fcf10 #369
[    0.022644] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S Bochs 01/01/2011
[    0.023510]  00000000 00000000 81b97f50 817e52a2 81b97f80 8103257a 81a=
73029 00000000
[    0.024469]  00000000 81a79d73 00000bac 8106e0cc 8106e0cc 81bb29d8 81b=
b271c 00000000
[    0.025427]  81b97f90 81032626 00000009 00000000 81b97fa4 8106e0cc 000=
00000 00020800
[    0.026389] Call Trace:
[    0.026665]  [<817e52a2>] dump_stack+0x16/0x18
[    0.027162]  [<8103257a>] warn_slowpath_common+0x6b/0x82
[    0.027734]  [<8106e0cc>] ? cgroup_init_cftypes+0x7f/0x86
[    0.028322]  [<8106e0cc>] ? cgroup_init_cftypes+0x7f/0x86
[    0.028903]  [<81032626>] warn_slowpath_null+0x1d/0x1f
[    0.029467]  [<8106e0cc>] cgroup_init_cftypes+0x7f/0x86
[    0.030015]  [<81c8213c>] cgroup_init+0x15/0x1a9
[    0.030518]  [<810f123b>] ? proc_mkdir+0x14/0x16
[    0.031030]  [<81c6eb40>] start_kernel+0x41c/0x453
[    0.031546]  [<81c6e4da>] ? set_init_arg+0x49/0x49
[    0.032074]  [<81c6e2cb>] i386_start_kernel+0x79/0x7d
[    0.032622] ---[ end trace f7c9b96c96ca301f ]---
[    0.033214] Initializing cgroup subsys perf_event
[    0.033728] Initializing cgroup subsys debug
[    0.034235] ------------[ cut here ]------------
[    0.034752] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:142=
2 warn_pre_alternatives+0x22/0x24()
[    0.035964] You're using static_cpu_has before alternatives have run!
[    0.036671] CPU: 0 PID: 0 Comm: swapper Tainted: G        W     3.16.0=
-rc2-00005-g53fcf10 #369
[    0.037613] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S Bochs 01/01/2011
[    0.040000]  81b97e88 81b97e88 81b97e48 817e52a2 81b97e78 8103257a 81a=
6af06 81b97ea4
[    0.040000]  00000000 81a6ae52 0000058e 8100c71b 8100c71b 81b97f54 000=
00000 00000000
[    0.040000]  81b97e90 810325d8 00000009 81b97e88 81a6af06 81b97ea4 81b=
97ea4 8100c71b
[    0.040000] Call Trace:
[    0.040000]  [<817e52a2>] dump_stack+0x16/0x18
[    0.040000]  [<8103257a>] warn_slowpath_common+0x6b/0x82
[    0.040000]  [<8100c71b>] ? warn_pre_alternatives+0x22/0x24
[    0.040000]  [<8100c71b>] ? warn_pre_alternatives+0x22/0x24
[    0.040000]  [<810325d8>] warn_slowpath_fmt+0x2e/0x30
[    0.040000]  [<8100c71b>] warn_pre_alternatives+0x22/0x24
[    0.040000]  [<81021f8c>] __do_page_fault+0x7f/0x38a
[    0.040000]  [<810f7532>] ? kernfs_activate+0x91/0xa2
[    0.040000]  [<810f7628>] ? kernfs_add_one+0xe5/0x110
[    0.040000]  [<810f7459>] ? kernfs_new_node+0x32/0x3d
[    0.040000]  [<810f768c>] ? kernfs_create_dir_ns+0x39/0x54
[    0.040000]  [<810f8e5d>] ? sysfs_create_dir_ns+0x3c/0x6a
[    0.040000]  [<810209cb>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
[    0.040000]  [<81022348>] do_page_fault+0x25/0x29
[    0.040000]  [<810209ee>] do_async_page_fault+0x23/0x49
[    0.040000]  [<817f1ced>] error_code+0x65/0x6c
[    0.040000]  [<81376bf6>] ? strchr+0xa/0x1e
[    0.040000]  [<810ca0bc>] register_filesystem+0x13/0x5e
[    0.040000]  [<81c8228e>] cgroup_init+0x167/0x1a9
[    0.040000]  [<81c6eb40>] start_kernel+0x41c/0x453
[    0.040000]  [<81c6e4da>] ? set_init_arg+0x49/0x49
[    0.040000]  [<81c6e2cb>] i386_start_kernel+0x79/0x7d
[    0.040000] ---[ end trace f7c9b96c96ca3020 ]---
[    0.040000] BUG: unable to handle kernel NULL pointer dereference at  =
 (null)
[    0.040000] IP: [<81376bf6>] strchr+0xa/0x1e
[    0.040000] *pde =3D 00000000=20
[    0.040000] Oops: 0000 [#1] PREEMPT=20
[    0.040000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W     3.16.0=
-rc2-00005-g53fcf10 #369
[    0.040000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S Bochs 01/01/2011
[    0.040000] task: 81b9e374 ti: 81b96000 task.ti: 81b96000
[    0.040000] EIP: 0060:[<81376bf6>] EFLAGS: 00210286 CPU: 0
[    0.040000] EIP is at strchr+0xa/0x1e
[    0.040000] EAX: 00002e2e EBX: 81bb2a28 ECX: 00000000 EDX: 0000002e
[    0.040000] ESI: 00000000 EDI: 00000000 EBP: 81b97f94 ESP: 81b97f90
[    0.040000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.040000] CR0: 8005003b CR2: 00000000 CR3: 01cf7000 CR4: 00000690
[    0.040000] Stack:
[    0.040000]  0000000c 81b97fa4 810ca0bc 81bb1ef0 0000000c 81b97fc4 81c=
8228e 00000002
[    0.040000]  000000d0 81bb3560 00000000 00020800 81cf8800 81b97fe8 81c=
6eb40 000002e7
[    0.040000]  ffffffff ffffffff 81c6e4da 81cbc390 611cf1c9 00000800 81b=
97ff8 81c6e2cb
[    0.040000] Call Trace:
[    0.040000]  [<810ca0bc>] register_filesystem+0x13/0x5e
[    0.040000]  [<81c8228e>] cgroup_init+0x167/0x1a9
[    0.040000]  [<81c6eb40>] start_kernel+0x41c/0x453
[    0.040000]  [<81c6e4da>] ? set_init_arg+0x49/0x49
[    0.040000]  [<81c6e2cb>] i386_start_kernel+0x79/0x7d
[    0.040000] Code: c3 55 89 e5 57 89 d7 56 89 c6 49 78 08 ac ae 75 08 8=
4 c0 75 f5 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 55 89 e5 56 89 c6 89 d0 88=
 c4 <ac> 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e 5d c3 55
[    0.040000] EIP: [<81376bf6>] strchr+0xa/0x1e SS:ESP 0068:81b97f90
[    0.040000] CR2: 0000000000000000
[    0.040000] ---[ end trace f7c9b96c96ca3021 ]---
[    0.040000] Kernel panic - not syncing: Attempted to kill the idle tas=
k!
[    0.040000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig=
-ha1-0704/53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78/vmlinuz-3.16.0-rc2-000=
05-g53fcf10 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 c=
onsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha1-0704/linux-devel:dev=
el-lkp-hsx01-i386-201407040014:53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78:b=
isect-linux5/.vmlinuz-53fcf10b90f01b8dbdaa9fd380ebe64a10ffbc78-2014070409=
0344-2-ivb42 branch=3Dlinux-devel/devel-lkp-hsx01-i386-201407040014 BOOT_=
IMAGE=3D/kernel/i386-randconfig-ha1-0704/53fcf10b90f01b8dbdaa9fd380ebe64a=
10ffbc78/vmlinuz-3.16.0-rc2-00005-g53fcf10 drbd.minor_count=3D8'  -initrd=
 /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D=
1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog =
i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb42-=
17 -serial file:/dev/shm/kboot/serial-quantal-ivb42-17 -daemonize -displa=
y none -monitor null=20


--------------060102060606030502050202
Content-Type: application/octet-stream;
 name="i386-randconfig-ha1-0704-7af305fa6329db0131931fa49d30aeb8ebffd865-WARNING:---at----cgroup_init_cftypes+-x-75771.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="i386-randconfig-ha1-0704-7af305fa6329db0131931fa49d30aeb8ebf";
 filename*1="fd865-WARNING:---at----cgroup_init_cftypes+-x-75771.log"

SEVBRCBpcyBub3cgYXQgN2FmMzA1Zi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1s
a3AtaHN4MDEtaTM4Ni0yMDE0MDcwNDAwMTQnCmdpdCBjaGVja291dCA0YzgzNDQ1MmFhZDAx
NTMxZGI5NDk0MTRmOTRmODE3YTg2MzQ4ZDU5CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtw
LWhzeDAxLWkzODYtMjAxNDA3MDQwMDE0OjRjODM0NDUyYWFkMDE1MzFkYjk0OTQxNGY5NGY4
MTdhODYzNDhkNTk6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNy0wNC0wODo1MDoxMSA0YzgzNDQ1
MmFhZDAxNTMxZGI5NDk0MTRmOTRmODE3YTg2MzQ4ZDU5IHJldXNlIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMS0wNzA0LzRjODM0NDUyYWFkMDE1MzFkYjk0OTQxNGY5NGY4MTdhODYz
NDhkNTkvdm1saW51ei0zLjE2LjAtcmMzCgoyMDE0LTA3LTA0LTA4OjUwOjExIGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTEwCTExCTE4CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21t
aXQgNGM4MzQ0NTJhYWQwMTUzMWRiOTQ5NDE0Zjk0ZjgxN2E4NjM0OGQ1OQpnaXQgYmlzZWN0
IHN0YXJ0IDdhZjMwNWZhNjMyOWRiMDEzMTkzMWZhNDlkMzBhZWI4ZWJmZmQ4NjUgNGM4MzQ0
NTJhYWQwMTUzMWRiOTQ5NDE0Zjk0ZjgxN2E4NjM0OGQ1OSAtLQovYy9rZXJuZWwtdGVzdHMv
bGluZWFyLWJpc2VjdDogWyItYiIsICI3YWYzMDVmYTYzMjlkYjAxMzE5MzFmYTQ5ZDMwYWVi
OGViZmZkODY1IiwgIi1nIiwgIjRjODM0NDUyYWFkMDE1MzFkYjk0OTQxNGY5NGY4MTdhODYz
NDhkNTkiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIs
ICIvYy9ib290LWJpc2VjdC9saW51eDUvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogNjA0IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzE1
YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTRdIE1lcmdlICdibHVldG9v
dGgvbWFzdGVyJyBpbnRvIGRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNzA0MDAxNApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC9saW51eC1kZXZlbDpkZXZlbC1sa3At
aHN4MDEtaTM4Ni0yMDE0MDcwNDAwMTQ6MTVjMDM3MGQ5YTdiODRhNWJlNGI0YzZlYjUwYjY4
YjNhNGM4YTA1NDpiaXNlY3QtbGludXg1CgoyMDE0LTA3LTA0LTA4OjUzOjEyIDE1YzAzNzBk
OWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhh
MS0wNzA0LTE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcw
ZDlhN2I4NGE1YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGExLTA3
MDQtMTVjMDM3MGQ5YTdiODRhNWJlNGI0YzZlYjUwYjY4YjNhNGM4YTA1NAprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2
ZWI1MGI2OGIzYTRjOGEwNTQvdm1saW51ei0zLjE2LjAtcmMzLTAwNTU3LWcxNWMwMzcwCgoy
MDE0LTA3LTA0LTA4OjU1OjEzIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJF
ClsgICAgMC4wMjAwMDBdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMTAyNCAo
b3JkZXI6IDAsIDQwOTYgYnl0ZXMpClsgICAgMC4wMjAwMDBdIE1vdW50cG9pbnQtY2FjaGUg
aGFzaCB0YWJsZSBlbnRyaWVzOiAxMDI0IChvcmRlcjogMCwgNDA5NiBieXRlcykKWyAgICAw
LjAyMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4w
MjAwMDBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDAgYXQgL2tidWlsZC9zcmMvaTM4Ni9rZXJu
ZWwvY2dyb3VwLmM6Mjk5MCBjZ3JvdXBfaW5pdF9jZnR5cGVzKzB4N2YvMHg4NigpClsgICAg
MC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE2
LjAtcmMzLTAwNTU3LWcxNWMwMzcwICMzNjYKWyAgICAwLjAyMDAwMF0gSGFyZHdhcmUgbmFt
ZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgIDAuMDIwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgODFiOTdmNTAg
ODE3ZTYwNGIgODFiOTdmODAgODEwMzI1ZGEgODFhNzMxNjQgMDAwMDAwMDAKWyAgICAwLjAy
MDAwMF0gIDAwMDAwMDAwIDgxYTc5ZWJiIDAwMDAwYmFlIDgxMDZlMTNjIDgxMDZlMTNjIDgx
YmIyOWRjIDgxYmIyNzIwIDAwMDAwMDAwClsgICAgMC4wMjAwMDBdICA4MWI5N2Y5MCA4MTAz
MjY4NiAwMDAwMDAwOSAwMDAwMDAwMCA4MWI5N2ZhNCA4MTA2ZTEzYyAwMDAwMDAwMCAwMDAy
MDgwMApbICAgIDAuMDIwMTgxXSBDYWxsIFRyYWNlOgpbICAgIDAuMDIwMzkwXSAgWzw4MTdl
NjA0Yj5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMC4wMjA3NTddICBbPDgxMDMyNWRh
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Yi8weDgyClsgICAgMC4wMjExODNdICBbPDgx
MDZlMTNjPl0gPyBjZ3JvdXBfaW5pdF9jZnR5cGVzKzB4N2YvMHg4NgpbICAgIDAuMDIxNjI0
XSAgWzw4MTA2ZTEzYz5dID8gY2dyb3VwX2luaXRfY2Z0eXBlcysweDdmLzB4ODYKWyAgICAw
LjAyMjA2MF0gIFs8ODEwMzI2ODY+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxZC8weDFmClsg
ICAgMC4wMjI0NzddICBbPDgxMDZlMTNjPl0gY2dyb3VwX2luaXRfY2Z0eXBlcysweDdmLzB4
ODYKWyAgICAwLjAyMjg5OV0gIFs8ODFjODIxNzM+XSBjZ3JvdXBfaW5pdCsweDE1LzB4MjEw
ClsgICAgMC4wMjMyNzRdICBbPDgxMGYxNDBjPl0gPyBwcm9jX21rZGlyKzB4MTQvMHgxNgpb
ICAgIDAuMDIzNjU0XSAgWzw4MWM2ZWI0MD5dIHN0YXJ0X2tlcm5lbCsweDQxYy8weDQ1Mwpb
ICAgIDAuMDI0MDQwXSAgWzw4MWM2ZTRkYT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpb
ICAgIDAuMDI0NDE5XSAgWzw4MWM2ZTJjYj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3
ZApbICAgIDAuMDI0ODMxXSAtLS1bIGVuZCB0cmFjZSA1Y2JhODdlZmRkOTYzOGZkIF0tLS0K
WyAgICAwLjAyNTI0OV0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgcGVyZl9ldmVudAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRj
NmViNTBiNjhiM2E0YzhhMDU0L2RtZXNnLXlvY3RvLWl2YjQyLTExNjoyMDE0MDcwNDA4NTQx
MjppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0L2RtZXNn
LXF1YW50YWwtaXZiNDItNTk6MjAxNDA3MDQwODU0MTg6aTM4Ni1yYW5kY29uZmlnLWhhMS0w
NzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMTVjMDM3MGQ5YTdiODRh
NWJlNGI0YzZlYjUwYjY4YjNhNGM4YTA1NC9kbWVzZy15b2N0by1pdmI0Mi0yNjoyMDE0MDcw
NDA4NTQxNjppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0
L2RtZXNnLXF1YW50YWwtaXZiNDItMjY6MjAxNDA3MDQwODU0Mjg6aTM4Ni1yYW5kY29uZmln
LWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMTVjMDM3MGQ5
YTdiODRhNWJlNGI0YzZlYjUwYjY4YjNhNGM4YTA1NC9kbWVzZy1xdWFudGFsLWl2YjQyLTQ6
MjAxNDA3MDQwODU0MjQ6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaGExLTA3MDQvMTVjMDM3MGQ5YTdiODRhNWJlNGI0YzZlYjUwYjY4YjNh
NGM4YTA1NC9kbWVzZy1xdWFudGFsLWl2YjQyLTUzOjIwMTQwNzA0MDg1NDI3OmkzODYtcmFu
ZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzE1
YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQvZG1lc2ctcXVhbnRhbC1p
dmI0Mi01OToyMDE0MDcwNDA4NTQyODppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRjNmVi
NTBiNjhiM2E0YzhhMDU0L2RtZXNnLXlvY3RvLWl2YjQyLTQxOjIwMTQwNzA0MDg1NDI3Omkz
ODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0w
NzA0LzE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQvZG1lc2cteW9j
dG8taXZiNDItNTg6MjAxNDA3MDQwODU0Mjc6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMTVjMDM3MGQ5YTdiODRhNWJlNGI0
YzZlYjUwYjY4YjNhNGM4YTA1NC9kbWVzZy1xdWFudGFsLWl2YjQyLTEwOjIwMTQwNzA0MDg1
NDM4OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWhhMS0wNzA0LzE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQvZG1l
c2ctcXVhbnRhbC1pdmI0Mi0xMToyMDE0MDcwNDA4NTQzOTppMzg2LXJhbmRjb25maWctaGEx
LTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4
NGE1YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0L2RtZXNnLXlvY3RvLWl2YjQyLTEwMzoyMDE0
MDcwNDA4NTQzNTppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRjNmViNTBiNjhiM2E0Yzhh
MDU0L2RtZXNnLXlvY3RvLWl2YjQyLTgxOjIwMTQwNzA0MDg1NDM1OmkzODYtcmFuZGNvbmZp
Zy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzE1YzAzNzBk
OWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQvZG1lc2ctcXVhbnRhbC1pdmI0Mi0x
MTk6MjAxNDA3MDQwODU0NDk6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGExLTA3MDQvMTVjMDM3MGQ5YTdiODRhNWJlNGI0YzZlYjUwYjY4
YjNhNGM4YTA1NC9kbWVzZy1xdWFudGFsLWl2YjQyLTQ6MjAxNDA3MDQwODU0NTU6aTM4Ni1y
YW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQv
MTVjMDM3MGQ5YTdiODRhNWJlNGI0YzZlYjUwYjY4YjNhNGM4YTA1NC9kbWVzZy1xdWFudGFs
LWl2YjQyLTU5OjIwMTQwNzA0MDg1NDUwOmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2
ZWI1MGI2OGIzYTRjOGEwNTQvZG1lc2ctcXVhbnRhbC1pdmI0Mi05NToyMDE0MDcwNDA4NTQ1
NDppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0L2RtZXNn
LXlvY3RvLWl2YjQyLTEwMzoyMDE0MDcwNDA4NTQ1NTppMzg2LXJhbmRjb25maWctaGExLTA3
MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8xNWMwMzcwZDlhN2I4NGE1
YmU0YjRjNmViNTBiNjhiM2E0YzhhMDU0L2RtZXNnLXlvY3RvLWl2YjQyLTM5OjIwMTQwNzA0
MDg1NDUxOmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWhhMS0wNzA0LzE1YzAzNzBkOWE3Yjg0YTViZTRiNGM2ZWI1MGI2OGIzYTRjOGEwNTQv
ZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMTk6MjAxNDA3MDQwODU0NTk6aTM4Ni1yYW5kY29uZmln
LWhhMS0wNzA0OjoKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVt
MjAxNC0wNy0wNCAwODo1NTo0MyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4NS9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDU1NyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCltkOWY1MDlm
OGNhZDI0NTNlNzM0YzFkZWViODc2ZTg2ZDY2NTZjZWNiXSBNZXJnZSAnYW1pcnYvZm9yLW5l
dGRldicgaW50byBkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDcwNDAwMTQKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAx
LWkzODYtMjAxNDA3MDQwMDE0OmQ5ZjUwOWY4Y2FkMjQ1M2U3MzRjMWRlZWI4NzZlODZkNjY1
NmNlY2I6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNy0wNC0wODo1NTo0NCBkOWY1MDlmOGNhZDI0
NTNlNzM0YzFkZWViODc2ZTg2ZDY2NTZjZWNiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcw
NC1kOWY1MDlmOGNhZDI0NTNlNzM0YzFkZWViODc2ZTg2ZDY2NTZjZWNiCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvZDlmNTA5ZjhjYWQy
NDUzZTczNGMxZGVlYjg3NmU4NmQ2NjU2Y2VjYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LWQ5
ZjUwOWY4Y2FkMjQ1M2U3MzRjMWRlZWI4NzZlODZkNjY1NmNlY2IKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC9kOWY1MDlmOGNhZDI0NTNlNzM0YzFkZWViODc2
ZTg2ZDY2NTZjZWNiL3ZtbGludXotMy4xNi4wLXJjMy0wMDE5NC1nZDlmNTA5ZgoKMjAxNC0w
Ny0wNC0wODo1Nzo0NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTYJMTkJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAzNjMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDkgc3RlcHMpClsyZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTEx
XSBNZXJnZSAnY2dyb3VwL3Jldmlldy1kZmxfZmlsZXMnIGludG8gZGV2ZWwtbGtwLWhzeDAx
LWkzODYtMjAxNDA3MDQwMDE0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDUvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0
L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNzA0MDAxNDoyZjEzMjBm
N2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTExOmJpc2VjdC1saW51eDUKCjIwMTQt
MDctMDQtMDg6NTk6MTQgMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2YWNlNDg0NTJmY2Ex
MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQtMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMx
OGY2YWNlNDg0NTJmY2ExMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2VjYmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNh
MTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC0yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZh
Y2U0ODQ1MmZjYTExCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQv
MmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2YWNlNDg0NTJmY2ExMS92bWxpbnV6LTMuMTYu
MC1yYzMtMDAyMDUtZzJmMTMyMGYKCjIwMTQtMDctMDQtMDk6MDE6MTQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAyMDAwMF0gTW91bnQtY2FjaGUgaGFz
aCB0YWJsZSBlbnRyaWVzOiAxMDI0IChvcmRlcjogMCwgNDA5NiBieXRlcykKWyAgICAwLjAy
MDAwMF0gTW91bnRwb2ludC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEwMjQgKG9yZGVy
OiAwLCA0MDk2IGJ5dGVzKQpbICAgIDAuMDIwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KWyAgICAwLjAyMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDogMCBh
dCAva2J1aWxkL3NyYy9pMzg2L2tlcm5lbC9jZ3JvdXAuYzoyOTkwIGNncm91cF9pbml0X2Nm
dHlwZXMrMHg3Zi8weDg2KCkKWyAgICAwLjAyMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzMtMDAyMDUtZzJmMTMyMGYgIzM2OApbICAg
IDAuMDIwMDA3XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQ
SUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMjA4OTZdICAwMDAw
MDAwMCAwMDAwMDAwMCA4MWI5N2Y1MCA4MTdlNjAzZiA4MWI5N2Y4MCA4MTAzMjVkYSA4MWE3
MzE2NCAwMDAwMDAwMApbICAgIDAuMDIxODg1XSAgMDAwMDAwMDAgODFhNzllYmIgMDAwMDBi
YWUgODEwNmUxM2MgODEwNmUxM2MgODFiYjI5ZGMgODFiYjI3MjAgMDAwMDAwMDAKWyAgICAw
LjAyMjg4MF0gIDgxYjk3ZjkwIDgxMDMyNjg2IDAwMDAwMDA5IDAwMDAwMDAwIDgxYjk3ZmE0
IDgxMDZlMTNjIDAwMDAwMDAwIDAwMDIwODAwClsgICAgMC4wMjM4NzBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMjQxNTJdICBbPDgxN2U2MDNmPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAg
ICAwLjAyNDY1NV0gIFs8ODEwMzI1ZGE+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDZiLzB4
ODIKWyAgICAwLjAyNTI0MV0gIFs8ODEwNmUxM2M+XSA/IGNncm91cF9pbml0X2NmdHlwZXMr
MHg3Zi8weDg2ClsgICAgMC4wMjU4NDVdICBbPDgxMDZlMTNjPl0gPyBjZ3JvdXBfaW5pdF9j
ZnR5cGVzKzB4N2YvMHg4NgpbICAgIDAuMDI2NDM3XSAgWzw4MTAzMjY4Nj5dIHdhcm5fc2xv
d3BhdGhfbnVsbCsweDFkLzB4MWYKWyAgICAwLjAyNzAxMF0gIFs8ODEwNmUxM2M+XSBjZ3Jv
dXBfaW5pdF9jZnR5cGVzKzB4N2YvMHg4NgpbICAgIDAuMDI3NTkwXSAgWzw4MWM4MjE3Mz5d
IGNncm91cF9pbml0KzB4MTUvMHgyMTAKWyAgICAwLjAyODEwMF0gIFs8ODEwZjE0MGM+XSA/
IHByb2NfbWtkaXIrMHgxNC8weDE2ClsgICAgMC4wMjg2MjBdICBbPDgxYzZlYjQwPl0gc3Rh
cnRfa2VybmVsKzB4NDFjLzB4NDUzClsgICAgMC4wMjkxNDldICBbPDgxYzZlNGRhPl0gPyBz
ZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMzAwMTBdICBbPDgxYzZlMmNiPl0gaTM4
Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMzA1NjddIC0tLVsgZW5kIHRyYWNl
IDc3MDg1OWEyOWE1YWQ5NDYgXS0tLQpbICAgIDAuMDMxMTM4XSBJbml0aWFsaXppbmcgY2dy
b3VwIHN1YnN5cyBwZXJmX2V2ZW50Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0
LzJmMTMyMGY3Y2VjYmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNhMTEvZG1lc2ctcXVhbnRh
bC1pdmI0Mi0xMDY6MjAxNDA3MDQwOTAwMzg6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIwZjdjZWNiYjI2ZWUwOTgx
NGMxOGY2YWNlNDg0NTJmY2ExMS9kbWVzZy1xdWFudGFsLWl2YjQyLTExNzoyMDE0MDcwNDA5
MDAzODppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTEtMDcwNC8yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTExL2Rt
ZXNnLXF1YW50YWwtaXZiNDItMjU6MjAxNDA3MDQwOTAwMzc6aTM4Ni1yYW5kY29uZmlnLWhh
MS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIwZjdjZWNi
YjI2ZWUwOTgxNGMxOGY2YWNlNDg0NTJmY2ExMS9kbWVzZy1xdWFudGFsLWl2YjQyLTYwOjIw
MTQwNzA0MDkwMDM2OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2VjYmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUy
ZmNhMTEvZG1lc2ctcXVhbnRhbC1pdmI0Mi02MToyMDE0MDcwNDA5MDAzNjppMzg2LXJhbmRj
b25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8yZjEz
MjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTExL2RtZXNnLXF1YW50YWwtaXZi
NDItNjU6MjAxNDA3MDQwOTAwMzk6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2
YWNlNDg0NTJmY2ExMS9kbWVzZy15b2N0by1pdmI0Mi02MzoyMDE0MDcwNDA5MDAzMjppMzg2
LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcw
NC8yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTExL2RtZXNnLXlvY3Rv
LWl2YjQyLTkxOjIwMTQwNzA0MDkwMDMzOmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2VjYmIyNmVlMDk4MTRj
MThmNmFjZTQ4NDUyZmNhMTEvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMTc6MjAxNDA3MDQwOTAw
NDk6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGExLTA3MDQvMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2YWNlNDg0NTJmY2ExMS9kbWVz
Zy1xdWFudGFsLWl2YjQyLTI1OjIwMTQwNzA0MDkwMDQ4OmkzODYtcmFuZGNvbmZpZy1oYTEt
MDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2VjYmIy
NmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNhMTEvZG1lc2ctcXVhbnRhbC1pdmI0Mi00ODoyMDE0
MDcwNDA5MDA0NjppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1oYTEtMDcwNC8yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZj
YTExL2RtZXNnLXF1YW50YWwtaXZiNDItNTc6MjAxNDA3MDQwOTAwNDg6aTM4Ni1yYW5kY29u
ZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIw
ZjdjZWNiYjI2ZWUwOTgxNGMxOGY2YWNlNDg0NTJmY2ExMS9kbWVzZy15b2N0by1pdmI0Mi01
NDoyMDE0MDcwNDA5MDA0NDppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1oYTEtMDcwNC8yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0
ODQ1MmZjYTExL2RtZXNnLXlvY3RvLWl2YjQyLTYzOjIwMTQwNzA0MDkwMDQyOmkzODYtcmFu
ZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzJm
MTMyMGY3Y2VjYmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNhMTEvZG1lc2cteW9jdG8taXZi
NDItOTQ6MjAxNDA3MDQwOTAwNDY6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2
YWNlNDg0NTJmY2ExMS9kbWVzZy1xdWFudGFsLWl2YjQyLTEwNDoyMDE0MDcwNDA5MDA1Njpp
Mzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEt
MDcwNC8yZjEzMjBmN2NlY2JiMjZlZTA5ODE0YzE4ZjZhY2U0ODQ1MmZjYTExL2RtZXNnLXF1
YW50YWwtaXZiNDItMTQ6MjAxNDA3MDQwOTAwNTE6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMmYxMzIwZjdjZWNiYjI2ZWUw
OTgxNGMxOGY2YWNlNDg0NTJmY2ExMS9kbWVzZy1xdWFudGFsLWl2YjQyLTQ4OjIwMTQwNzA0
MDkwMDU3OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2VjYmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNhMTEv
ZG1lc2cteW9jdG8taXZiNDItMTI2OjIwMTQwNzA0MDkwMDUyOmkzODYtcmFuZGNvbmZpZy1o
YTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzJmMTMyMGY3Y2Vj
YmIyNmVlMDk4MTRjMThmNmFjZTQ4NDUyZmNhMTEvZG1lc2cteW9jdG8taXZiNDItNTU6MjAx
NDA3MDQwOTAwNTM6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKMDoyMDoyMCBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0wNCAwOTowMTo0NSBSRVBFQVQg
Q09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBjZ3JvdXAvcmV2aWV3LWRm
bF9maWxlcwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVh
ci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgMmYxMzIwZjdjZWNiYjI2ZWUwOTgxNGMxOGY2
YWNlNDg0NTJmY2ExMSBkOWY1MDlmOGNhZDI0NTNlNzM0YzFkZWViODc2ZTg2ZDY2NTZjZWNi
IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDJmMTMyMGYuLi4gTWVyZ2UgJ2Nncm91
cC9yZXZpZXctZGZsX2ZpbGVzJyBpbnRvIGRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNzA0
MDAxNApIRUFEIGlzIG5vdyBhdCA1NGFmNjFkLi4uIE1lcmdlIGJyYW5jaCAnYWtwbS1jdXJy
ZW50L2N1cnJlbnQnCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzUzZmNmMTBiOTBmMDFiOGRiZGFhOWZkMzgwZWJl
NjRhMTBmZmJjNzhdIGNncm91cDogc3BsaXQgY2dyb3VwX2Jhc2VfZmlsZXNbXSBpbnRvIGNn
cm91cF97ZGZsfGxlZ2FjeX1fYmFzZV9maWxlc1tdCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNl
Y3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXg1L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaGExLTA3MDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA3MDQw
MDE0OjUzZmNmMTBiOTBmMDFiOGRiZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzg6YmlzZWN0LWxp
bnV4NQoKMjAxNC0wNy0wNC0wOTowMTo0OSA1M2ZjZjEwYjkwZjAxYjhkYmRhYTlmZDM4MGVi
ZTY0YTEwZmZiYzc4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC01M2ZjZjEwYjkwZjAx
YjhkYmRhYTlmZDM4MGViZTY0YTEwZmZiYzc4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvNTNmY2YxMGI5MGYwMWI4ZGJkYWE5ZmQzODBl
YmU2NGExMGZmYmM3OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LTUzZmNmMTBiOTBmMDFiOGRi
ZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTEtMDcwNC81M2ZjZjEwYjkwZjAxYjhkYmRhYTlmZDM4MGViZTY0YTEwZmZiYzc4L3Zt
bGludXotMy4xNi4wLXJjMi0wMDAwNS1nNTNmY2YxMAoKMjAxNC0wNy0wNC0wOTowMzo0OSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAwXSBNb3Vu
dC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEwMjQgKG9yZGVyOiAwLCA0MDk2IGJ5dGVz
KQpbICAgIDAuMDIwMDAwXSBNb3VudHBvaW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczog
MTAyNCAob3JkZXI6IDAsIDQwOTYgYnl0ZXMpClsgICAgMC4wMjAyNDFdIC0tLS0tLS0tLS0t
LVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDIwOTc5XSBXQVJOSU5HOiBDUFU6
IDAgUElEOiAwIGF0IC9rYnVpbGQvc3JjL2kzODYva2VybmVsL2Nncm91cC5jOjI5ODggY2dy
b3VwX2luaXRfY2Z0eXBlcysweDdmLzB4ODYoKQpbICAgIDAuMDIyNDYxXSBDUFU6IDAgUElE
OiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjMi0wMDAwNS1nNTNmY2Yx
MCAjMzY5ClsgICAgMC4wMjM2MTBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMg
KGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAy
NDgzNV0gIDAwMDAwMDAwIDAwMDAwMDAwIDgxYjk3ZjUwIDgxN2U1MmEyIDgxYjk3ZjgwIDgx
MDMyNTdhIDgxYTczMDI5IDAwMDAwMDAwClsgICAgMC4wMjYyNDFdICAwMDAwMDAwMCA4MWE3
OWQ3MyAwMDAwMGJhYyA4MTA2ZTBjYyA4MTA2ZTBjYyA4MWJiMjlkOCA4MWJiMjcxYyAwMDAw
MDAwMApbICAgIDAuMDI3NjA0XSAgODFiOTdmOTAgODEwMzI2MjYgMDAwMDAwMDkgMDAwMDAw
MDAgODFiOTdmYTQgODEwNmUwY2MgMDAwMDAwMDAgMDAwMjA4MDAKWyAgICAwLjAzMDA1OF0g
Q2FsbCBUcmFjZToKWyAgICAwLjAzMDQ1NF0gIFs8ODE3ZTUyYTI+XSBkdW1wX3N0YWNrKzB4
MTYvMHgxOApbICAgIDAuMDMxMTUxXSAgWzw4MTAzMjU3YT5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4NmIvMHg4MgpbICAgIDAuMDMxOTcyXSAgWzw4MTA2ZTBjYz5dID8gY2dyb3VwX2lu
aXRfY2Z0eXBlcysweDdmLzB4ODYKWyAgICAwLjAzMjgwMF0gIFs8ODEwNmUwY2M+XSA/IGNn
cm91cF9pbml0X2NmdHlwZXMrMHg3Zi8weDg2ClsgICAgMC4wMzM2MzldICBbPDgxMDMyNjI2
Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWQvMHgxZgpbICAgIDAuMDM0NDM5XSAgWzw4MTA2
ZTBjYz5dIGNncm91cF9pbml0X2NmdHlwZXMrMHg3Zi8weDg2ClsgICAgMC4wMzUyNDZdICBb
PDgxYzgyMTNjPl0gY2dyb3VwX2luaXQrMHgxNS8weDFhOQpbICAgIDAuMDM2MTI1XSAgWzw4
MTBmMTIzYj5dID8gcHJvY19ta2RpcisweDE0LzB4MTYKWyAgICAwLjAzNjg1MF0gIFs8ODFj
NmViNDA+XSBzdGFydF9rZXJuZWwrMHg0MWMvMHg0NTMKWyAgICAwLjAzNzU5Nl0gIFs8ODFj
NmU0ZGE+XSA/IHNldF9pbml0X2FyZysweDQ5LzB4NDkKWyAgICAwLjAzODMzOF0gIFs8ODFj
NmUyY2I+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4N2QKWyAgICAwLjAzOTEyM10gLS0t
WyBlbmQgdHJhY2UgZDYzZGFjMTBjNGZjNTlkOCBdLS0tClsgICAgMC4wNDAwNjFdIEluaXRp
YWxpemluZyBjZ3JvdXAgc3Vic3lzIHBlcmZfZXZlbnQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGExLTA3MDQvNTNmY2YxMGI5MGYwMWI4ZGJkYWE5ZmQzODBlYmU2NGExMGZmYmM3OC9k
bWVzZy1xdWFudGFsLWl2YjQyLTE3OjIwMTQwNzA0MDkwMzQwOmkzODYtcmFuZGNvbmZpZy1o
YTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzUzZmNmMTBiOTBm
MDFiOGRiZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzgvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xODoy
MDE0MDcwNDA5MDM0MDppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTEtMDcwNC81M2ZjZjEwYjkwZjAxYjhkYmRhYTlmZDM4MGViZTY0YTEw
ZmZiYzc4L2RtZXNnLXF1YW50YWwtaXZiNDItODA6MjAxNDA3MDQwOTAzMzg6aTM4Ni1yYW5k
Y29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvNTNm
Y2YxMGI5MGYwMWI4ZGJkYWE5ZmQzODBlYmU2NGExMGZmYmM3OC9kbWVzZy15b2N0by1pdmI0
Mi0xMDM6MjAxNDA3MDQwOTAzMzQ6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvNTNmY2YxMGI5MGYwMWI4ZGJkYWE5ZmQzODBl
YmU2NGExMGZmYmM3OC9kbWVzZy15b2N0by1pdmI0Mi0xMDc6MjAxNDA3MDQwOTAzNTM6aTM4
Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3
MDQvNTNmY2YxMGI5MGYwMWI4ZGJkYWE5ZmQzODBlYmU2NGExMGZmYmM3OC9kbWVzZy15b2N0
by1pdmI0Mi0xNToyMDE0MDcwNDA5MDM1MjppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC81M2ZjZjEwYjkwZjAxYjhkYmRhYTlm
ZDM4MGViZTY0YTEwZmZiYzc4L2RtZXNnLXlvY3RvLWl2YjQyLTIzOjIwMTQwNzA0MDkwMzU0
OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhh
MS0wNzA0LzUzZmNmMTBiOTBmMDFiOGRiZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzgvZG1lc2ct
eW9jdG8taXZiNDItNzY6MjAxNDA3MDQwOTAzNTM6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvNTNmY2YxMGI5MGYwMWI4ZGJk
YWE5ZmQzODBlYmU2NGExMGZmYmM3OC9kbWVzZy15b2N0by1pdmI0Mi05MDoyMDE0MDcwNDA5
MDM1MjppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTEtMDcwNC81M2ZjZjEwYjkwZjAxYjhkYmRhYTlmZDM4MGViZTY0YTEwZmZiYzc4L2Rt
ZXNnLXlvY3RvLWl2YjQyLTkxOjIwMTQwNzA0MDkwMzUyOmkzODYtcmFuZGNvbmZpZy1oYTEt
MDcwNDo6CjA6MTA6MTAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDctMDQgMDk6MDQ6MTkgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eDUvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClthZmJiMWI1YjU5NWMxYTRi
MWE2ZjAzNmYyMjBmN2IxMDdhNTA0ZTJkXSBjZ3JvdXA6IG1ha2UgaW50ZXJmYWNlIGZpbGUg
ImNncm91cC5zYW5lX2JlaGF2aW9yIiBsZWdhY3ktb25seQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg1
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1oYTEtMDcwNC9saW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0
MDcwNDAwMTQ6YWZiYjFiNWI1OTVjMWE0YjFhNmYwMzZmMjIwZjdiMTA3YTUwNGUyZDpiaXNl
Y3QtbGludXg1CgoyMDE0LTA3LTA0LTA5OjA0OjIwIGFmYmIxYjViNTk1YzFhNGIxYTZmMDM2
ZjIyMGY3YjEwN2E1MDRlMmQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LWFmYmIxYjVi
NTk1YzFhNGIxYTZmMDM2ZjIyMGY3YjEwN2E1MDRlMmQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC9hZmJiMWI1YjU5NWMxYTRiMWE2ZjAz
NmYyMjBmN2IxMDdhNTA0ZTJkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQtYWZiYjFiNWI1OTVj
MWE0YjFhNmYwMzZmMjIwZjdiMTA3YTUwNGUyZAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMS0wNzA0L2FmYmIxYjViNTk1YzFhNGIxYTZmMDM2ZjIyMGY3YjEwN2E1MDRl
MmQvdm1saW51ei0zLjE2LjAtcmMyLTAwMDAyLWdhZmJiMWI1CgoyMDE0LTA3LTA0LTA5OjA2
OjIwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4JMwk5CTE1CTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMSBzdGVwKQpbNGVmZjA4MGVmMGZjM2Q1YmEzMGM2YjQ2NGM4NzdjMjRmODViNWQ3
MV0gY2dyb3VwOiBjbGVhbiB1cCBzYW5lX2JlaGF2aW9yIGhhbmRsaW5nCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1p
Mzg2LTIwMTQwNzA0MDAxNDo0ZWZmMDgwZWYwZmMzZDViYTMwYzZiNDY0Yzg3N2MyNGY4NWI1
ZDcxOmJpc2VjdC1saW51eDUKCjIwMTQtMDctMDQtMDk6MTQ6NTEgNGVmZjA4MGVmMGZjM2Q1
YmEzMGM2YjQ2NGM4NzdjMjRmODViNWQ3MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQt
NGVmZjA4MGVmMGZjM2Q1YmEzMGM2YjQ2NGM4NzdjMjRmODViNWQ3MQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzRlZmYwODBlZjBmYzNk
NWJhMzBjNmI0NjRjODc3YzI0Zjg1YjVkNzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC00ZWZm
MDgwZWYwZmMzZDViYTMwYzZiNDY0Yzg3N2MyNGY4NWI1ZDcxCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGExLTA3MDQvNGVmZjA4MGVmMGZjM2Q1YmEzMGM2YjQ2NGM4Nzdj
MjRmODViNWQ3MS92bWxpbnV6LTMuMTYuMC1yYzItMDAwMDQtZzRlZmYwODAKCjIwMTQtMDct
MDQtMDk6MTY6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE0CTIwIFNVQ0NFU1MKCjUzZmNm
MTBiOTBmMDFiOGRiZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzggaXMgdGhlIGZpcnN0IGJhZCBj
b21taXQKY29tbWl0IDUzZmNmMTBiOTBmMDFiOGRiZGFhOWZkMzgwZWJlNjRhMTBmZmJjNzgK
QXV0aG9yOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CkRhdGU6ICAgVGh1IEp1bCAzIDEx
OjE4OjMwIDIwMTQgLTA0MDAKCiAgICBjZ3JvdXA6IHNwbGl0IGNncm91cF9iYXNlX2ZpbGVz
W10gaW50byBjZ3JvdXBfe2RmbHxsZWdhY3l9X2Jhc2VfZmlsZXNbXQogICAgCiAgICBDdXJy
ZW50bHkgY2dyb3VwX2Jhc2VfZmlsZXNbXSBjb250YWlucyB0aGUgY2dyb3VwIGNvcmUgaW50
ZXJmYWNlIGZpbGVzCiAgICBmb3IgYm90aCBsZWdhY3kgYW5kIGRlZmF1bHQgaGllcmFyY2hp
ZXMgd2l0aCBlYWNoIGZpbGUgdGFnZ2VkIHdpdGgKICAgIENGVFlQRV9JTlNBTkUgYW5kIENG
VFlQRV9PTkxZX09OX0RGTC4gIFRoaXMgaXMgZGlmZmljdWx0IHRvIHJlYWQuCiAgICAKICAg
IExldCdzIHNlcGFyYXRlIGl0IG91dCB0byB0d28gc2VwYXJhdGUgdGFibGVzLCBjZ3JvdXBf
ZGZsX2Jhc2VfZmlsZXNbXQogICAgYW5kIGNncm91cF9sZWdhY3lfYmFzZV9maWxlc1tdLCBh
bmQgdXNlIHRoZSBhcHByb3ByaWF0ZSBvbmUgaW4KICAgIGNncm91cF9ta2RpcigpIGRlcGVu
ZGluZyBvbiB0aGUgaGllcmFyY2h5IHR5cGUuICBUaGlzIG1ha2VzIHRhZ2dpbmcKICAgIGVh
Y2ggZmlsZSB1bm5lY2Vzc2FyeS4KICAgIAogICAgVGhpcyBwYXRjaCBkb2Vzbid0IGludHJv
ZHVjZSBhbnkgYmVoYXZpb3IgY2hhbmdlcy4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogVGVq
dW4gSGVvIDx0akBrZXJuZWwub3JnPgoKOjA0MDAwMCAwNDAwMDAgNDA5ZjA0YmNmODRlYzhm
ZjJkZTliNzEyN2MyNDZlOWRhMWNkOTg3YiBhMjIzNWI3N2M1MTM3MmYwY2Y2YTliMGQyM2Ix
MjhjZGIxYTAyZDFhIE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBh
dCA0ZWZmMDgwLi4uIGNncm91cDogY2xlYW4gdXAgc2FuZV9iZWhhdmlvciBoYW5kbGluZwps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMS0w
NzA0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNzA0MDAxNDo0ZWZm
MDgwZWYwZmMzZDViYTMwYzZiNDY0Yzg3N2MyNGY4NWI1ZDcxOmJpc2VjdC1saW51eDUKCjIw
MTQtMDctMDQtMDk6MTc6NTEgNGVmZjA4MGVmMGZjM2Q1YmEzMGM2YjQ2NGM4NzdjMjRmODVi
NWQ3MSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC80ZWZmMDgwZWYw
ZmMzZDViYTMwYzZiNDY0Yzg3N2MyNGY4NWI1ZDcxL3ZtbGludXotMy4xNi4wLXJjMi0wMDAw
NC1nNGVmZjA4MAoKMjAxNC0wNy0wNC0wOToxNzo1MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJ
MjEJMzUJNDMJNTMJNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNGVm
ZjA4MC4uLiBjZ3JvdXA6IGNsZWFuIHVwIHNhbmVfYmVoYXZpb3IgaGFuZGxpbmcKSEVBRCBp
cyBub3cgYXQgN2FmMzA1Zi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1sa3AtaHN4
MDEtaTM4Ni0yMDE0MDcwNDAwMTQnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAx
LWkzODYtMjAxNDA3MDQwMDE0OjdhZjMwNWZhNjMyOWRiMDEzMTkzMWZhNDlkMzBhZWI4ZWJm
ZmQ4NjU6YmlzZWN0LWxpbnV4NQogVEVTVCBGQUlMVVJFClsgICAgMC4wMjAwMDBdIE1vdW50
LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMTAyNCAob3JkZXI6IDAsIDQwOTYgYnl0ZXMp
ClsgICAgMC4wMjAwMDBdIE1vdW50cG9pbnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAx
MDI0IChvcmRlcjogMCwgNDA5NiBieXRlcykKWyAgICAwLjAyMDAwMF0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMjAwMDBdIFdBUk5JTkc6IENQVTog
MCBQSUQ6IDAgYXQgL2tidWlsZC9zcmMvaTM4Ni9rZXJuZWwvY2dyb3VwLmM6Mjk5MCBjZ3Jv
dXBfaW5pdF9jZnR5cGVzKzB4N2YvMHg4NigpClsgICAgMC4wMjAwMDBdIENQVTogMCBQSUQ6
IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE2LjAtcmMzLTAwNjA0LWc3YWYzMDVm
ICMyMTMKWyAgICAwLjAyMDAwMF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAo
aTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDIw
MDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgODFiOTdmNTAgODE3ZTYwNGIgODFiOTdmODAgODEw
MzI1ZGEgODFhNzMxNjQgMDAwMDAwMDAKWyAgICAwLjAyMDAwMF0gIDAwMDAwMDAwIDgxYTc5
ZWJiIDAwMDAwYmFlIDgxMDZlMTNjIDgxMDZlMTNjIDgxYmIyOWRjIDgxYmIyNzIwIDAwMDAw
MDAwClsgICAgMC4wMjAwMDBdICA4MWI5N2Y5MCA4MTAzMjY4NiAwMDAwMDAwOSAwMDAwMDAw
MCA4MWI5N2ZhNCA4MTA2ZTEzYyAwMDAwMDAwMCAwMDAyMDgwMApbICAgIDAuMDIwMTA3XSBD
YWxsIFRyYWNlOgpbICAgIDAuMDIwMzEzXSAgWzw4MTdlNjA0Yj5dIGR1bXBfc3RhY2srMHgx
Ni8weDE4ClsgICAgMC4wMjA2NzBdICBbPDgxMDMyNWRhPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg2Yi8weDgyClsgICAgMC4wMjEwOThdICBbPDgxMDZlMTNjPl0gPyBjZ3JvdXBfaW5p
dF9jZnR5cGVzKzB4N2YvMHg4NgpbICAgIDAuMDIxNTIzXSAgWzw4MTA2ZTEzYz5dID8gY2dy
b3VwX2luaXRfY2Z0eXBlcysweDdmLzB4ODYKWyAgICAwLjAyMTk1NV0gIFs8ODEwMzI2ODY+
XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxZC8weDFmClsgICAgMC4wMjIzNjVdICBbPDgxMDZl
MTNjPl0gY2dyb3VwX2luaXRfY2Z0eXBlcysweDdmLzB4ODYKWyAgICAwLjAyMjc4M10gIFs8
ODFjODIxNzM+XSBjZ3JvdXBfaW5pdCsweDE1LzB4MjEwClsgICAgMC4wMjMxNjFdICBbPDgx
MGYxNDBjPl0gPyBwcm9jX21rZGlyKzB4MTQvMHgxNgpbICAgIDAuMDIzNTMxXSAgWzw4MWM2
ZWI0MD5dIHN0YXJ0X2tlcm5lbCsweDQxYy8weDQ1MwpbICAgIDAuMDIzOTI1XSAgWzw4MWM2
ZTRkYT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDI0MzA2XSAgWzw4MWM2
ZTJjYj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDI0NzA4XSAtLS1b
IGVuZCB0cmFjZSAxYjVlOTAzM2Q3MjA1YmNmIF0tLS0KWyAgICAwLjAyNTEyM10gSW5pdGlh
bGl6aW5nIGNncm91cCBzdWJzeXMgcGVyZl9ldmVudAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTEtMDcwNC83YWYzMDVmYTYzMjlkYjAxMzE5MzFmYTQ5ZDMwYWViOGViZmZkODY1L2Rt
ZXNnLXF1YW50YWwtaXZiNDItMTAzOjIwMTQwNzA0MDg0OTQ2OmkzODYtcmFuZGNvbmZpZy1o
YTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzdhZjMwNWZhNjMy
OWRiMDEzMTkzMWZhNDlkMzBhZWI4ZWJmZmQ4NjUvZG1lc2cteW9jdG8taXZiNDItNjU6MjAx
NDA3MDQwODQ5Mjg6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaGExLTA3MDQvN2FmMzA1ZmE2MzI5ZGIwMTMxOTMxZmE0OWQzMGFlYjhlYmZm
ZDg2NS9kbWVzZy15b2N0by1pdmI0Mi0zMjoyMDE0MDcwNDA4NDk0NjppMzg2LXJhbmRjb25m
aWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC83YWYzMDVm
YTYzMjlkYjAxMzE5MzFmYTQ5ZDMwYWViOGViZmZkODY1L2RtZXNnLXF1YW50YWwtaXZiNDIt
OTk6MjAxNDA3MDQwODQ5NDY6aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGExLTA3MDQvN2FmMzA1ZmE2MzI5ZGIwMTMxOTMxZmE0OWQzMGFl
YjhlYmZmZDg2NS9kbWVzZy1xdWFudGFsLWl2YjQyLTEwMzoyMDE0MDcwNDA4NDkzNjppMzg2
LXJhbmRjb25maWctaGExLTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcw
NC83YWYzMDVmYTYzMjlkYjAxMzE5MzFmYTQ5ZDMwYWViOGViZmZkODY1L2RtZXNnLXlvY3Rv
LWl2YjQyLTQ2OjIwMTQwNzA0MDg0OTM5OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LzdhZjMwNWZhNjMyOWRiMDEzMTkzMWZh
NDlkMzBhZWI4ZWJmZmQ4NjUvZG1lc2cteW9jdG8taXZiNDItMzg6MjAxNDA3MDQwMDE5MjI6
aTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEx
LTA3MDQvN2FmMzA1ZmE2MzI5ZGIwMTMxOTMxZmE0OWQzMGFlYjhlYmZmZDg2NS9kbWVzZy15
b2N0by1pdmI0Mi02NDoyMDE0MDcwNDA4NDkzODppMzg2LXJhbmRjb25maWctaGExLTA3MDQ6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC83YWYzMDVmYTYzMjlkYjAxMzE5
MzFmYTQ5ZDMwYWViOGViZmZkODY1L2RtZXNnLXlvY3RvLWl2YjQyLTY0OjIwMTQwNzA0MDg0
OTQ4OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWhhMS0wNzA0LzdhZjMwNWZhNjMyOWRiMDEzMTkzMWZhNDlkMzBhZWI4ZWJmZmQ4NjUvZG1l
c2ctcXVhbnRhbC1pdmI0Mi00MzoyMDE0MDcwNDA4NDk0NjppMzg2LXJhbmRjb25maWctaGEx
LTA3MDQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC83YWYzMDVmYTYzMjlk
YjAxMzE5MzFmYTQ5ZDMwYWViOGViZmZkODY1L2RtZXNnLXlvY3RvLWl2YjQyLTY0OjIwMTQw
NzA0MDg0OTI4OmkzODYtcmFuZGNvbmZpZy1oYTEtMDcwNDo6CjA6MTE6MTEgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93IGF0IDdhZjMwNWYgMGRheSBoZWFkIGd1
YXJkIGZvciAnZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA3MDQwMDE0JwoKPT09PT09PT09
IHVwc3RyZWFtID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3YWYzMDVm
Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNzA0
MDAxNCcKSEVBRCBpcyBub3cgYXQgNTE3MGEzYi4uLiBNZXJnZSBicmFuY2ggJ2FrcG0nIChw
YXRjaGVzIGZyb20gQW5kcmV3IE1vcnRvbikKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC9saW51czptYXN0ZXI6NTE3MGEzYjI0
YTkxNDFlMjM0OWEzNDIwNDQ4NzQzYjdjNjhmMjIyMzpiaXNlY3QtbGludXg1CgoyMDE0LTA3
LTA0LTA5OjIwOjI0IDUxNzBhM2IyNGE5MTQxZTIzNDlhMzQyMDQ0ODc0M2I3YzY4ZjIyMjMg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvNTE3MGEzYjI0YTkxNDFl
MjM0OWEzNDIwNDQ4NzQzYjdjNjhmMjIyMy92bWxpbnV6LTMuMTYuMC1yYzMtMDAwOTEtZzUx
NzBhM2IKCjIwMTQtMDctMDQtMDk6MjA6MjUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMzQJ
NDYJNTUJNjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1MTcwYTNiLi4uIE1lcmdlIGJyYW5jaCAnYWtwbScg
KHBhdGNoZXMgZnJvbSBBbmRyZXcgTW9ydG9uKQpIRUFEIGlzIG5vdyBhdCAwZTljZTgyLi4u
IEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcwMwpscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0L25leHQ6
bWFzdGVyOjBlOWNlODIzYWQ3YmM2Yjg1YzI3OTIyM2FlNjYzOGQ0NzA4OTQ2MWU6YmlzZWN0
LWxpbnV4NQoKMjAxNC0wNy0wNC0wOToyMzoyNiAwZTljZTgyM2FkN2JjNmI4NWMyNzkyMjNh
ZTY2MzhkNDcwODk0NjFlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTEtMDcwNC0wZTljZTgyM2Fk
N2JjNmI4NWMyNzkyMjNhZTY2MzhkNDcwODk0NjFlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaGExLTA3MDQvMGU5Y2U4MjNhZDdiYzZiODVjMjc5MjIz
YWU2NjM4ZDQ3MDg5NDYxZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMS0wNzA0LTBlOWNlODIzYWQ3YmM2
Yjg1YzI3OTIyM2FlNjYzOGQ0NzA4OTQ2MWUKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTEtMDcwNC8wZTljZTgyM2FkN2JjNmI4NWMyNzkyMjNhZTY2MzhkNDcwODk0NjFl
L3ZtbGludXotMy4xNi4wLXJjMy1uZXh0LTIwMTQwNzAzCgoyMDE0LTA3LTA0LTA5OjI1OjI2
IGRldGVjdGluZyBib290IHN0YXRlIAk0Mgk2MCBTVUNDRVNTCgo=
--------------060102060606030502050202
Content-Type: text/plain; charset=UTF-8;
 name="config-3.16.0-rc2-00005-g53fcf10"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.16.0-rc2-00005-g53fcf10"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc2 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_HAVE_INTEL_TXT=y
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
CONFIG_COMPILE_TEST=y
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SGETMASK_SYSCALL=y
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
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
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
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
CONFIG_X86_32_IRIS=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
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
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
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
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_I82365=y
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
CONFIG_HOTPLUG_PCI_IBM=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

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
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_OPENVSWITCH_VXLAN=y
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
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
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
# CONFIG_NFC_MRVL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
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
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

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
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_VMXNET3=y
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_CAPI20 is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_ST_KEYSCAN=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_SH_KEYSC is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUN4I=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_OLPC_APSP is not set
# CONFIG_HYPERV_KEYBOARD is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EFM32 is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_CROS_EC_TUNNEL is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
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
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

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

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_MXC is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=y

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
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_AB3100 is not set
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_IMG=y
CONFIG_IR_IMG_RAW=y
# CONFIG_IR_IMG_HW is not set
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
# CONFIG_VIDEO_SH_VEU is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=y
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_SI2157=y
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y
# CONFIG_DVB_M88DS3103 is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
# CONFIG_DVB_STV6110 is not set
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_CX24117=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_TS2020=y
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=y
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y
# CONFIG_DVB_RTL2832 is not set
CONFIG_DVB_SI2168=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=y
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
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
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_SH_DMAE_BASE is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_BALLOON=y
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_SH_TIMER_CMT=y
CONFIG_SH_TIMER_MTU2=y
# CONFIG_SH_TIMER_TMU is not set
CONFIG_EM_TIMER_STI=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_CLPS711X=y
CONFIG_PWM_LPSS=y
CONFIG_PWM_RENESAS_TPU=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_OMAP_CONTROL_PHY is not set
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
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
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
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
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
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
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
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
CONFIG_ASSOCIATIVE_ARRAY=y
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
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y


--------------060102060606030502050202
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------060102060606030502050202--
