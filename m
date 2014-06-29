Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaF2DMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 23:12:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:42080 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaF2DME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 23:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,569,1400050800"; 
   d="log'?scan'208";a="554778957"
Date: Sun, 29 Jun 2014 11:11:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [sched] WARNING: CPU: 0 PID: 1 at kernel/sched/core.c:6069 sd_init()
Message-ID: <20140629031121.GB10256@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <20140629030939.GA10256@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://bee.sh.intel.com/git/ydu19/linux cc-v4-on-3.16-rc2
commit 981fa8778958e70170ad2e757bc75f5e3c688665
Author:     Yuyang Du <yuyang.du@intel.com>
AuthorDate: Wed Jun 25 03:57:18 2014 +0800
Commit:     Yuyang Du <yuyang.du@intel.com>
CommitDate: Thu Jun 26 15:06:56 2014 +0800

    Define SD_WORKLOAD_CONSOLIDATION and attach to sched_domain
    
    Workload Consolidation is completely CPU topology and policy driven. To do so,
    we define SD_WORKLOAD_CONSOLIDATION, and add some fields in sched_domain struct:
    
    1) total_groups is the group number in total in this domain
    2) group_number is this CPU's group sequence number
    3) consolidating_coeff is the coefficient for consolidating CPUs, and is changeable
       via sysctl tool to make consolidation more aggressive or less
    4) first_group is the pointer to this domain's first group ordered by CPU number
    
    This patchset enables SD_WORKLOAD_CONSOLIDATION in MC domain by default. But we need
    to come up with a better way to determine on which architecture this flag should be
    enabled or not. Thanks to PeterZ and Dietmar for pointing this out and help me
    finally understand it.
    
    Signed-off-by: Yuyang Du <yuyang.du@intel.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+--------------------------------------------------+------------+------------+------------------+
|                                                  | 3b3fb61976 | 981fa87789 | v3.16-rc2_062617 |
+--------------------------------------------------+------------+------------+------------------+
| boot_successes                                   | 56         | 0          | 0                |
| boot_failures                                    | 1          | 19         | 13               |
| BUG:kernel_boot_crashed                          | 1          |            |                  |
| WARNING:CPU:PID:at_kernel/sched/core.c:sd_init() | 0          | 19         | 13               |
| backtrace:sd_init                                | 0          | 19         | 13               |
| backtrace:warn_slowpath_fmt                      | 0          | 19         | 13               |
| backtrace:build_sched_domains                    | 0          | 19         | 13               |
| backtrace:sched_init_smp                         | 0          | 19         | 13               |
| backtrace:kernel_init_freeable                   | 0          | 19         | 13               |
+--------------------------------------------------+------------+------------+------------------+

[    0.182210] ---------------------------------
[    0.183384] smpboot: Total of 2 processors activated (10774.02 BogoMIPS)
[    0.185468] ------------[ cut here ]------------
[    0.185468] WARNING: CPU: 0 PID: 1 at kernel/sched/core.c:6069 sd_init+0x3e6/0x400()
[    0.185468] wrong sd_flags in topology description
[    0.190008] Modules linked in:
[    0.191075] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc2-00004-g981fa87 #1
[    0.193126] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    0.195267]  0000000000000009 ffff880013487d30 ffffffff822ec723 ffff880013487d78
[    0.197754]  ffff880013487d68 ffffffff810ca0d7 ffffffff82d90038 0000000000008000
[    0.200484]  0000000000000001 ffff8800135b8000 0000000000000001 ffff880013487dc8
[    0.202956] Call Trace:
[    0.203814]  [<ffffffff822ec723>] dump_stack+0xc1/0x111
[    0.205138]  [<ffffffff810ca0d7>] warn_slowpath_common+0xc7/0x100
[    0.206629]  [<ffffffff810ca1f7>] warn_slowpath_fmt+0x57/0x70
[    0.208029]  [<ffffffff817c3eb4>] ? __bitmap_weight+0xe4/0x110
[    0.209447]  [<ffffffff811268d6>] sd_init+0x3e6/0x400
[    0.210015]  [<ffffffff81137851>] build_sched_domain+0x31/0x230
[    0.211450]  [<ffffffff81138696>] build_sched_domains+0xc46/0x1770
[    0.212931]  [<ffffffff83807858>] sched_init_smp+0x118/0x3b0
[    0.214329]  [<ffffffff837dec4c>] kernel_init_freeable+0xcd/0x31a
[    0.215816]  [<ffffffff822c46e0>] ? rest_init+0x120/0x120
[    0.217155]  [<ffffffff822c46f1>] kernel_init+0x11/0x230
[    0.218491]  [<ffffffff8230a97c>] ret_from_fork+0x7c/0xb0
[    0.220014]  [<ffffffff822c46e0>] ? rest_init+0x120/0x120
[    0.221383] ---[ end trace 66f6dff8a935a04a ]---
[    0.233431] gcov: version magic: 0x3430382a

git bisect start 9c33bf1e59d26dad8dc45e438cbdc28783589b11 a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
git bisect good 10d9d029067f2aacbdc140786efff146d79b34c5  # 08:26     19+      0  Merge 'cgroup/for-3.16-fixes' into devel-hourly-2014062617
git bisect  bad b8db0fc896849e940f23fbea02c137869c94f3d3  # 08:33      0-      6  Merge 'kvm-ppc/kvm-ppc-queue' into devel-hourly-2014062617
git bisect good 7135b130d9f1c30321f9a9e024498557026cdd03  # 08:41     19+      0  Merge 'arm-platforms/kvm-arm64/irq-forward' into devel-hourly-2014062617
git bisect good c2484a8acda7d9ff41a98d3e2fcc5a65bbd02747  # 08:50     19+      0  Merge 'arc/for-next' into devel-hourly-2014062617
git bisect good 1a799f5c9dbbd47d503af1e0cedf9d252cca2d6d  # 09:00     19+      0  Merge 'cryptodev/master' into devel-hourly-2014062617
git bisect  bad 9c259d6a46e754ea8fb42bcf688255ffa2c8c048  # 09:09      0-     16  Merge 'yuyang/cc-v4-on-3.16-rc2' into devel-hourly-2014062617
git bisect  bad 1a43e8a377f4adc5c9a412de1a57ab453f8313d4  # 09:17      0-     13  Workload Consolidation: Consolidating workload to a subset of CPUs if possible
git bisect good 7dee841147a972e809dfcd75f638d7145dd8e756  # 09:29     19+      0  sched: Precise accumulated time and acount runnable number in update_entity_runnable_avg
git bisect  bad 981fa8778958e70170ad2e757bc75f5e3c688665  # 09:41      0-     12  Define SD_WORKLOAD_CONSOLIDATION and attach to sched_domain
git bisect good 3b3fb61976509ef8f7c0c05adba0b61cea6b05db  # 09:52     19+      0  How CPU ConCurrency (CC) accrues with runqueue change and time
# first bad commit: [981fa8778958e70170ad2e757bc75f5e3c688665] Define SD_WORKLOAD_CONSOLIDATION and attach to sched_domain
git bisect good 3b3fb61976509ef8f7c0c05adba0b61cea6b05db  # 09:58     57+      1  How CPU ConCurrency (CC) accrues with runqueue change and time
git bisect  bad 9c33bf1e59d26dad8dc45e438cbdc28783589b11  # 09:58      0-     13  0day head guard for 'devel-hourly-2014062617'
git bisect good 24b414d5a7d3e6a716350464dfdb44da610ed142  # 10:10     57+      0  Merge tag 'spi-v3.16-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect good 96426007c90cde23c0402856f3e0aec0f4cc2e48  # 10:18     57+      0  Add linux-next specific files for 20140627


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
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
Fengguang

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-51:20140629093503:x86_64-randconfig-hsxa0-06261808::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc2-00004-g981fa87 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Jun 29 09:33:12 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-dev=
el:devel-hourly-2014062617:981fa8778958e70170ad2e757bc75f5e3c688665:bisect-=
linux0/.vmlinuz-981fa8778958e70170ad2e757bc75f5e3c688665-20140629093339-2-i=
vb41 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c688665/vmlin=
uz-3.16.0-rc2-00004-g981fa87 drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04bc1000, 0x04bc1fff] PGTABLE
[    0.000000] BRK [0x04bc2000, 0x04bc2fff] PGTABLE
[    0.000000] BRK [0x04bc3000, 0x04bc3fff] PGTABLE
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
[    0.000000] BRK [0x04bc4000, 0x04bc4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] ACPI: IRQ2 used by override.
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79488 r8192=
 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/li=
nux-devel:devel-hourly-2014062617:981fa8778958e70170ad2e757bc75f5e3c688665:=
bisect-linux0/.vmlinuz-981fa8778958e70170ad2e757bc75f5e3c688665-20140629093=
339-2-ivb41 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c68866=
5/vmlinuz-3.16.0-rc2-00004-g981fa87 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 254604K/327280K available (19508K kernel code, 10935=
K rwdata, 10220K rodata, 1412K init, 19004K bss, 72676K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.16.0-rc2-00004-g981fa87 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Jun 29 09:33:12 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-dev=
el:devel-hourly-2014062617:981fa8778958e70170ad2e757bc75f5e3c688665:bisect-=
linux0/.vmlinuz-981fa8778958e70170ad2e757bc75f5e3c688665-20140629093339-2-i=
vb41 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c688665/vmlin=
uz-3.16.0-rc2-00004-g981fa87 drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04bc1000, 0x04bc1fff] PGTABLE
[    0.000000] BRK [0x04bc2000, 0x04bc2fff] PGTABLE
[    0.000000] BRK [0x04bc3000, 0x04bc3fff] PGTABLE
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
[    0.000000] BRK [0x04bc4000, 0x04bc4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] ACPI: IRQ2 used by override.
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79488 r8192=
 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/li=
nux-devel:devel-hourly-2014062617:981fa8778958e70170ad2e757bc75f5e3c688665:=
bisect-linux0/.vmlinuz-981fa8778958e70170ad2e757bc75f5e3c688665-20140629093=
339-2-ivb41 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c68866=
5/vmlinuz-3.16.0-rc2-00004-g981fa87 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 254604K/327280K available (19508K kernel code, 10935=
K rwdata, 10220K rodata, 1412K init, 19004K bss, 72676K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8127 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935060)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.024108] ACPI: All ACPI Tables successfully acquired
[    0.025812] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.027312] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.029559] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.029559] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.029559] tlb_flushall_shift: 6
[    0.030395] Freeing SMP alternatives memory: 28K (ffffffff8392a000 - fff=
fffff83931000)
[    0.040315] Getting VERSION: 1050014
[    0.041614] Getting VERSION: 1050014
[    0.042847] Getting ID: 0
[    0.043894] Getting ID: ff000000
[    0.045044] Getting LVT0: 8700
[    0.046167] Getting LVT1: 8400
[    0.047490] enabled ExtINT on CPU#0
[    0.049931] ENABLING IO-APIC IRQs
[    0.050012] init IO_APIC IRQs
[    0.051193]  apic 0 pin 0 not connected
[    0.052508] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.055053] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.057651] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060047] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.062633] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.065278] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.067750] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.070038] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072640] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.075077] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.077679] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.080038] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.082615] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.085098] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.087804] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.090058]  apic 0 pin 16 not connected
[    0.091333]  apic 0 pin 17 not connected
[    0.092600]  apic 0 pin 18 not connected
[    0.093968]  apic 0 pin 19 not connected
[    0.095231]  apic 0 pin 20 not connected
[    0.096492]  apic 0 pin 21 not connected
[    0.100009]  apic 0 pin 22 not connected
[    0.101268]  apic 0 pin 23 not connected
[    0.102658] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.104633] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.107949] Using local APIC timer interrupts.
[    0.107949] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 6247398
[    0.120000] ... PM-Timer delta =3D 357838
[    0.120000] ... PM-Timer result ok
[    0.120000] ..... delta 6247398
[    0.120000] ..... mult: 268323700
[    0.120000] ..... calibration result: 9995836
[    0.120000] ..... CPU clock speed is 2692.6363 MHz.
[    0.120000] ..... host bus clock speed is 999.5836 MHz.
[    0.120134] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.124452] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.126700] x86: Booting SMP configuration:
[    0.128071] .... node  #0, CPUs:      #1
[    0.020000] kvm-clock: cpu 1, msr 0:13c66041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.150122] x86: Booted up 1 node, 2 CPUs
[    0.150093] KVM setup async PF for cpu 1
[    0.150102] kvm-stealtime: cpu 1, msr 1390cd40
[    0.153912] ----------------
[    0.154825] | NMI testsuite:
[    0.155766] --------------------
[    0.156738]   remote IPI:  ok  |
[    0.160767]    local IPI:  ok  |
[    0.180035] --------------------
[    0.181052] Good, all   2 testcases passed! |
[    0.182210] ---------------------------------
[    0.183384] smpboot: Total of 2 processors activated (10774.02 BogoMIPS)
[    0.185468] ------------[ cut here ]------------
[    0.185468] WARNING: CPU: 0 PID: 1 at kernel/sched/core.c:6069 sd_init+0=
x3e6/0x400()
[    0.185468] wrong sd_flags in topology description
[    0.190008] Modules linked in:
[    0.191075] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc2-00004-g=
981fa87 #1
[    0.193126] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.195267]  0000000000000009 ffff880013487d30 ffffffff822ec723 ffff8800=
13487d78
[    0.197754]  ffff880013487d68 ffffffff810ca0d7 ffffffff82d90038 00000000=
00008000
[    0.200484]  0000000000000001 ffff8800135b8000 0000000000000001 ffff8800=
13487dc8
[    0.202956] Call Trace:
[    0.203814]  [<ffffffff822ec723>] dump_stack+0xc1/0x111
[    0.205138]  [<ffffffff810ca0d7>] warn_slowpath_common+0xc7/0x100
[    0.206629]  [<ffffffff810ca1f7>] warn_slowpath_fmt+0x57/0x70
[    0.208029]  [<ffffffff817c3eb4>] ? __bitmap_weight+0xe4/0x110
[    0.209447]  [<ffffffff811268d6>] sd_init+0x3e6/0x400
[    0.210015]  [<ffffffff81137851>] build_sched_domain+0x31/0x230
[    0.211450]  [<ffffffff81138696>] build_sched_domains+0xc46/0x1770
[    0.212931]  [<ffffffff83807858>] sched_init_smp+0x118/0x3b0
[    0.214329]  [<ffffffff837dec4c>] kernel_init_freeable+0xcd/0x31a
[    0.215816]  [<ffffffff822c46e0>] ? rest_init+0x120/0x120
[    0.217155]  [<ffffffff822c46f1>] kernel_init+0x11/0x230
[    0.218491]  [<ffffffff8230a97c>] ret_from_fork+0x7c/0xb0
[    0.220014]  [<ffffffff822c46e0>] ? rest_init+0x120/0x120
[    0.221383] ---[ end trace 66f6dff8a935a04a ]---
[    0.233431] gcov: version magic: 0x3430382a
[    0.236279] xor: measuring software checksum speed
[    0.330014]    prefetch64-sse:  8748.000 MB/sec
[    0.430015]    generic_sse:  7647.200 MB/sec
[    0.431398] xor: using function: prefetch64-sse (8748.000 MB/sec)
[    0.433109] prandom: seed boundary self test passed
[    0.435385] prandom: 100 self tests passed
[    0.436696] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.438952] NET: Registered protocol family 16
[    0.441068] cpuidle: using governor menu
[    0.442982] ACPI: bus type PCI registered
[    0.444412] dca service started, version 1.12.1
[    0.445794] PCI: Using configuration type 1 for base access
[    0.639141] raid6: sse2x1    1496 MB/s
[    0.809130] raid6: sse2x2    2700 MB/s
[    0.979131] raid6: sse2x4    3378 MB/s
[    0.979898] raid6: using algorithm sse2x4 (3378 MB/s)
[    0.980006] raid6: using intx1 recovery algorithm
[    0.981139] ACPI: Added _OSI(Module Device)
[    0.981939] ACPI: Added _OSI(Processor Device)
[    0.982729] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.983593] ACPI: Added _OSI(Processor Aggregator Device)
[    0.993227] ACPI: Interpreter enabled
[    0.993972] ACPI: (supports S0 S5)
[    0.994870] ACPI: Using IOAPIC for interrupt routing
[    0.996122] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.010769] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.011823] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    1.012895] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.014387] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.017196] PCI host bridge to bus 0000:00
[    1.017964] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.018887] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.019907] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.020008] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.021018] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.022033] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.023044] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.024126] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.025289] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.026883] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.028581] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.032323] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.034089] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.035200] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.036224] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.037335] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.038752] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.040361] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.041723] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.046100] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.048096] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.050011] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.055757] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.057225] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.058994] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.060743] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.065395] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.066815] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.068241] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.072360] pci_bus 0000:00: on NUMA node 0
[    1.074261] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.075824] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.077451] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.079076] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.080672] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.082714] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.083981] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.085456] vgaarb: loaded
[    1.086031] vgaarb: bridge control possible 0000:00:02.0
[    1.086977] SCSI subsystem initialized
[    1.086977] libata version 3.00 loaded.
[    1.086977] ACPI: bus type USB registered
[    1.090026] usbcore: registered new interface driver usbfs
[    1.090994] usbcore: registered new interface driver hub
[    1.092237] usbcore: registered new device driver usb
[    1.092237] pps_core: LinuxPPS API ver. 1 registered
[    1.092620] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.094769] PTP clock support registered
[    1.095947] wmi: Mapper loaded
[    1.096835] PCI: Using ACPI for IRQ routing
[    1.100008] PCI: pci_cache_line_size set to 64 bytes
[    1.100984] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.101979] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.103417] irda_init()
[    1.104008] NET: Registered protocol family 23
[    1.105187] Switched to clocksource kvm-clock
[    1.106363] Warning: could not register all branches stats
[    1.107289] Warning: could not register annotated branches stats
[    1.124361] pnp: PnP ACPI init
[    1.125058] ACPI: bus type PNP registered
[    1.125910] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.127498] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.128641] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.130217] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.131310] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.132804] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.133935] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.135390] pnp 00:03: [dma 2]
[    1.136127] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.137283] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.138782] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.139941] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.141511] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.143290] pnp: PnP ACPI: found 6 devices
[    1.144030] ACPI: bus type PNP unregistered
[    1.153675] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.154632] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.155569] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.156528] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.157449] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.158380] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.159388] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.160486] NET: Registered protocol family 1
[    1.161333] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.162332] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.163309] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.164348] pci 0000:00:02.0: Boot video device
[    1.165207] PCI: CLS 0 bytes, default 64
[    1.166209] Unpacking initramfs...
[    1.250710] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    1.253991] cryptomgr_test (33) used greatest stack depth: 14888 bytes l=
eft
[    1.255660] cryptomgr_test (34) used greatest stack depth: 14768 bytes l=
eft
[    1.258553] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.260218] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.261863] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.265617] spin_lock-torture: Creating torture_shuffle task
[    1.267242] spin_lock-torture: Creating torture_stutter task
[    1.268571] spin_lock-torture: torture_shuffle task started
[    1.269892] spin_lock-torture: Creating lock_torture_writer task
[    1.269915] spin_lock-torture: torture_stutter task started
[    1.272806] spin_lock-torture: Creating lock_torture_writer task
[    1.273911] spin_lock-torture: lock_torture_writer task started
[    1.274903] spin_lock-torture: Creating lock_torture_writer task
[    1.274926] spin_lock-torture: lock_torture_writer task started
[    1.276950] spin_lock-torture: Creating lock_torture_writer task
[    1.277916] spin_lock-torture: lock_torture_writer task started
[    1.278892] spin_lock-torture: Creating lock_torture_stats task
[    1.278916] spin_lock-torture: lock_torture_writer task started
[    1.281553] futex hash table entries: 512 (order: 4, 65536 bytes)
[    1.282572] Initialise system trusted keyring
[    1.290141] spin_lock-torture: lock_torture_stats task started
[    1.933354] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.954543] VFS: Disk quotas dquot_6.5.2
[    1.956070] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.959062] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, debug enabled
[    1.968184] gfs2: GFS2 installed
[    1.976659] NET: Registered protocol family 38
[    1.977847] Key type asymmetric registered
[    1.978826] Asymmetric key parser 'x509' registered
[    1.980417] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.982191] io scheduler noop registered
[    1.983119] io scheduler deadline registered (default)
[    1.984298] test_string_helpers: Running tests...
[    2.009917] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.010809] crc32: self tests passed, processed 225944 bytes in 16377379=
 nsec
[    2.023682] crc32c: CRC_LE_BITS =3D 1
[    2.024420] crc32c: self tests passed, processed 225944 bytes in 7887384=
 nsec
[    2.250168] tsc: Refined TSC clocksource calibration: 2693.500 MHz
[    2.945437] crc32_combine: 8373 self tests passed
[    3.904318] crc32c_combine: 8373 self tests passed
[    3.905340] rbtree testing -> 12198 cycles
[    4.420812] augmented rbtree testing -> 28919 cycles
[    5.646745] ipmi message handler version 39.2
[    5.648048] IPMI System Interface driver.
[    5.649484] ipmi_si: Unable to find any System Interface(s)
[    5.651027] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.652875] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.680646] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.684851] kworker/u4:0 (88) used greatest stack depth: 14656 bytes left
[    5.684929] lp: driver loaded but no devices found
[    5.685067] Non-volatile memory driver v1.3
[    5.688933] kworker/u4:0 (87) used greatest stack depth: 14256 bytes left
[    5.690656] ppdev: user-space parallel port driver
[    5.691994] smapi::smapi_init, ERROR invalid usSmapiID
[    5.693387] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    5.695867] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    5.697940] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.699468] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.701874] Hangcheck: Using getrawmonotonic().
[    5.703357] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    5.705191] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.707559] Guest personality initialized and is inactive
[    5.709050] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D62)
[    5.710652] Initialized host personality
[    5.712365] usbcore: registered new interface driver viperboard
[    5.713902] Uniform Multi-Platform E-IDE driver
[    5.715765] Loading iSCSI transport class v2.0-870.
[    5.717454] hp_sw: device handler registered
[    5.718642] alua: device handler registered
[    5.720849] Adaptec aacraid driver 1.2-0[30300]-ms
[    5.722367] scsi: <fdomain> Detection failed (no card)
[    5.723830] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    5.725569] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    5.727332] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    5.729507] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.731070] iscsi: registered transport (be2iscsi)
[    5.732406] In beiscsi_module_init, tt=3Dffffffff83043c60
[    5.734007] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.740136] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    5.742900] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    5.746242] libphy: Fixed MDIO Bus: probed
[    5.748048] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    5.750777] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[    5.752843] tlan: ThunderLAN driver v1.17
[    5.754093] tlan: 0 devices installed, PCI: 0  EISA: 0
[    5.755580] w83977af_init()
[    5.756556] w83977af_open()
[    5.757506] w83977af_probe()
[    5.763101] w83977af_probe(), Wrong chip version
[    5.764019] w83977af_probe()
[    5.765605] w83977af_probe(), Wrong chip version
[    5.766608] usbcore: registered new interface driver mcs7780
[    5.768679] PPP generic driver version 2.4.2
[    5.770133] PPP MPPE Compression module registered
[    5.771466] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    5.773279] usbcore: registered new interface driver ipheth
[    5.775465] usbcore: registered new interface driver hwa-rc
[    5.777049] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.778617] ehci-pci: EHCI PCI platform driver
[    5.779946] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    5.781806] usbcore: registered new interface driver wusb-cbaf
[    5.783392] usbcore: registered new interface driver cdc_acm
[    5.784878] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    5.787186] usbcore: registered new interface driver usbtmc
[    5.788632] usbcore: registered new interface driver microtekX6
[    5.790348] usbcore: registered new interface driver appledisplay
[    5.791956] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.793745] usbcore: registered new interface driver usblcd
[    5.795281] usbcore: registered new interface driver usbtest
[    5.796808] usbcore: registered new interface driver uss720
[    5.798216] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    5.800622] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    5.802759] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    5.804868] uss720: If you just want to connect to a printer, use usblp =
instead
[    5.807699] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.811073] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.812475] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.814620] parkbd: no such parport
[    5.816020] usbcore: registered new interface driver appletouch
[    5.817604] usbcore: registered new interface driver bcm5974
[    5.819850] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    5.823055] mk712: device not present
[    5.824269] usbcore: registered new interface driver usbtouchscreen
[    5.826045] cm109: Keymap for Komunikate KIP1000 phone loaded
[    5.827586] usbcore: registered new interface driver cm109
[    5.828966] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    5.831640] usbcore: registered new interface driver ims_pcu
[    5.835856] pps pps0: new PPS source ktimer
[    5.837083] pps pps0: ktimer PPS source registered
[    5.838360] pps_ldisc: PPS line discipline registered
[    5.840928] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    5.842379] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    5.843935] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    5.846291] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    5.847875] sc1200wdt: build 20020303
[    5.848984] sc1200wdt: io parameter must be specified
[    5.850407] pc87413_wdt: Version 1.1 at io 0x2E
[    5.851709] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.853369] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    5.856585] usbcore: registered new interface driver tranzport
[    5.858121] usbcore: registered new interface driver alphatrack
[    5.859890] input: Speakup as /devices/virtual/input/input3
[    5.861680] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    5.863468] speakup 3.1.6: initialized
[    5.864652] synth name on entry is: (null)
[    5.865938] usbcore: registered new interface driver gdm_wimax
[    5.868193] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[    5.869927] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[    5.872782] FPGA DOWNLOAD --->
[    5.873821] FPGA image file name: xlinx_fpga_firmware.bit
[    5.875400] GPIO INIT FAIL!!
[    5.876657] dell_wmi_aio: No known WMI GUID found
[    5.878004] Initializing HPQ6001 module
[    5.879422] Mirror/redirect action on
[    5.880552] Simple TC action Loaded
[    5.881689] netem: version 1.3
[    5.882766] NET: Registered protocol family 17
[    5.884198] NET: Registered protocol family 5
[    5.886067] IrCOMM protocol (Dag Brattli)
[    5.890254] 9pnet: Installing 9P2000 support
[    5.891534] Key type dns_resolver registered
[    5.893002] batman_adv: B.A.T.M.A.N. advanced 2014.3.0 (compatibility ve=
rsion 15) loaded
[    5.895314] mpls_gso: MPLS GSO support
[    5.896900]=20
[    5.896900] printing PIC contents
[    5.898530] ... PIC  IMR: ffff
[    5.899515] ... PIC  IRR: 1013
[    5.900561] ... PIC  ISR: 0000
[    5.901605] ... PIC ELCR: 0c00
[    5.902655] printing local APIC contents on CPU#0/0:
[    5.903614] ... APIC ID:      00000000 (0)
[    5.904396] ... APIC VERSION: 01050014
[    5.905141] ... APIC TASKPRI: 00000000 (00)
[    5.905984] ... APIC PROCPRI: 00000000
[    5.906738] ... APIC LDR: 01000000
[    5.907435] ... APIC DFR: ffffffff
[    5.908164] ... APIC SPIV: 000001ff
[    5.908862] ... APIC ISR field:
[    5.909590] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.911394] ... APIC TMR field:
[    5.912119] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.912650] ... APIC IRR field:
[    5.912650] 000000000000000000000000000000000000000000000000000000002000=
0000
[    5.912650] ... APIC ESR: 00000000
[    5.912650] ... APIC ICR: 000008fd
[    5.912650] ... APIC ICR2: 02000000
[    5.912650] ... APIC LVTT: 000000ef
[    5.912650] ... APIC LVTPC: 00010000
[    5.912650] ... APIC LVT0: 00010700
[    5.912650] ... APIC LVT1: 00000400
[    5.912650] ... APIC LVTERR: 000000fe
[    5.912650] ... APIC TMICT: 001c8b1f
[    5.912650] ... APIC TMCCT: 0006a3bc
[    5.912650] ... APIC TDCR: 00000003
[    5.912650]=20
[    5.924985] number of MP IRQ sources: 15.
[    5.926211] number of IO-APIC #0 registers: 24.
[    5.927483] testing the IO APIC.......................
[    5.928834] IO APIC #0......
[    5.929783] .... register #00: 00000000
[    5.930932] .......    : physical APIC id: 00
[    5.932206] .......    : Delivery Type: 0
[    5.933404] .......    : LTS          : 0
[    5.934606] .... register #01: 00170011
[    5.935770] .......     : max redirection entries: 17
[    5.937146] .......     : PRQ implemented: 0
[    5.938339] .......     : IO APIC version: 11
[    5.939537] .... register #02: 00000000
[    5.940680] .......     : arbitration: 00
[    5.941885] .... IRQ redirection table:
[    5.943067] 1    0    0   0   0    0    0    00
[    5.944376] 0    0    0   0   0    1    1    31
[    5.945678] 0    0    0   0   0    1    1    30
[    5.946981] 0    0    0   0   0    1    1    33
[    5.948234] 1    0    0   0   0    1    1    34
[    5.949471] 1    1    0   0   0    1    1    35
[    5.950753] 0    0    0   0   0    1    1    36
[    5.952063] 0    0    0   0   0    1    1    37
[    5.953375] 0    0    0   0   0    1    1    38
[    5.954682] 0    1    0   0   0    1    1    39
[    5.955984] 1    1    0   0   0    1    1    3A
[    5.957284] 1    1    0   0   0    1    1    3B
[    5.958525] 0    0    0   0   0    1    1    3C
[    5.959766] 0    0    0   0   0    1    1    3D
[    5.961049] 0    0    0   0   0    1    1    3E
[    5.962362] 0    0    0   0   0    1    1    3F
[    5.963665] 1    0    0   0   0    0    0    00
[    5.964970] 1    0    0   0   0    0    0    00
[    5.966282] 1    0    0   0   0    0    0    00
[    5.967569] 1    0    0   0   0    0    0    00
[    5.968810] 1    0    0   0   0    0    0    00
[    5.970075] 1    0    0   0   0    0    0    00
[    5.971369] 1    0    0   0   0    0    0    00
[    5.972673] 1    0    0   0   0    0    0    00
[    5.973961] IRQ to pin mappings:
[    5.975020] IRQ0 -> 0:2
[    5.976192] IRQ1 -> 0:1
[    5.977340] IRQ3 -> 0:3
[    5.978448] IRQ4 -> 0:4
[    5.979561] IRQ5 -> 0:5
[    5.980709] IRQ6 -> 0:6
[    5.981872] IRQ7 -> 0:7
[    5.983039] IRQ8 -> 0:8
[    5.984215] IRQ9 -> 0:9
[    5.985384] IRQ10 -> 0:10
[    5.986582] IRQ11 -> 0:11
[    5.987738] IRQ12 -> 0:12
[    5.988875] IRQ13 -> 0:13
[    5.990069] IRQ14 -> 0:14
[    5.991269] IRQ15 -> 0:15
[    5.992058] .................................... done.
[    5.993250] Loading compiled-in X.509 certificates
[    5.995600] Loaded X.509 cert 'Magrathea: Glacier signing key: 213542796=
12fcea73a759ebf477f7baaf7f82f24'
[    6.000464] Btrfs loaded, integrity-checker=3Don
[    6.007064] Freeing unused kernel memory: 1412K (ffffffff837c9000 - ffff=
ffff8392a000)
[    6.017082] mount (116) used greatest stack depth: 13720 bytes left
[    6.023805] S00fbsetup (118) used greatest stack depth: 13640 bytes left
[    6.095386] gfs2: path_lookup on rootfs returned error -2
[    6.273903] chown (269) used greatest stack depth: 13552 bytes left
[    6.632464] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[   61.290086] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[   73.382499] S40umountfs (394) used greatest stack depth: 13512 bytes left
[   75.395759] Unregister pv shared memory for cpu 0
[   75.397554] Unregister pv shared memory for cpu 1
[   75.398930] spin_lock-torture: Unscheduled system shutdown detected
[   75.400666] torture thread torture_stutter parking due to system shutdown
[   75.402322] torture thread torture_shuffle parking due to system shutdown
[   75.416383] reboot: Restarting system
[   75.417505] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c688665/vmlinuz-3.16.0-rc2=
-00004-g981fa87 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-devel=
:devel-hourly-2014062617:981fa8778958e70170ad2e757bc75f5e3c688665:bisect-li=
nux0/.vmlinuz-981fa8778958e70170ad2e757bc75f5e3c688665-20140629093339-2-ivb=
41 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel/x86_64=
-randconfig-hsxa0-06261808/981fa8778958e70170ad2e757bc75f5e3c688665/vmlinuz=
-3.16.0-rc2-00004-g981fa87 drbd.minor_count=3D8'  -initrd /kernel-tests/ini=
trd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 =
-net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-51 -serial file:/dev/s=
hm/kboot/serial-yocto-ivb41-51 -daemonize -display none -monitor null=20

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-wsx01-130:20140629095427:x86_64-randconfig-hsxa0-06261808::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc2-00003-g3b3fb61 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Jun 29 09:43:54 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-dev=
el:devel-hourly-2014062617:3b3fb61976509ef8f7c0c05adba0b61cea6b05db:bisect-=
linux0/.vmlinuz-3b3fb61976509ef8f7c0c05adba0b61cea6b05db-20140629095255-19-=
lkp-wsx01 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel=
/x86_64-randconfig-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea6b05db/=
vmlinuz-3.16.0-rc2-00003-g3b3fb61 drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04bc1000, 0x04bc1fff] PGTABLE
[    0.000000] BRK [0x04bc2000, 0x04bc2fff] PGTABLE
[    0.000000] BRK [0x04bc3000, 0x04bc3fff] PGTABLE
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
[    0.000000] BRK [0x04bc4000, 0x04bc4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] ACPI: IRQ2 used by override.
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79488 r8192=
 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/li=
nux-devel:devel-hourly-2014062617:3b3fb61976509ef8f7c0c05adba0b61cea6b05db:=
bisect-linux0/.vmlinuz-3b3fb61976509ef8f7c0c05adba0b61cea6b05db-20140629095=
255-19-lkp-wsx01 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea=
6b05db/vmlinuz-3.16.0-rc2-00003-g3b3fb61 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 254604K/327280K available (19508K kernel code, 10935=
K rwdata, 10220K rodata, 1412K init, 19004K bss, 72676K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.16.0-rc2-00003-g3b3fb61 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Jun 29 09:43:54 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-dev=
el:devel-hourly-2014062617:3b3fb61976509ef8f7c0c05adba0b61cea6b05db:bisect-=
linux0/.vmlinuz-3b3fb61976509ef8f7c0c05adba0b61cea6b05db-20140629095255-19-=
lkp-wsx01 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel=
/x86_64-randconfig-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea6b05db/=
vmlinuz-3.16.0-rc2-00003-g3b3fb61 drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04bc1000, 0x04bc1fff] PGTABLE
[    0.000000] BRK [0x04bc2000, 0x04bc2fff] PGTABLE
[    0.000000] BRK [0x04bc3000, 0x04bc3fff] PGTABLE
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
[    0.000000] BRK [0x04bc4000, 0x04bc4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] ACPI: IRQ2 used by override.
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79488 r8192=
 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/li=
nux-devel:devel-hourly-2014062617:3b3fb61976509ef8f7c0c05adba0b61cea6b05db:=
bisect-linux0/.vmlinuz-3b3fb61976509ef8f7c0c05adba0b61cea6b05db-20140629095=
255-19-lkp-wsx01 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea=
6b05db/vmlinuz-3.16.0-rc2-00003-g3b3fb61 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 254604K/327280K available (19508K kernel code, 10935=
K rwdata, 10220K rodata, 1412K init, 19004K bss, 72676K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8127 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.998 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 4787.99 Bogo=
MIPS (lpj=3D23939980)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.024677] ACPI: All ACPI Tables successfully acquired
[    0.026206] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.027566] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030388] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030388] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030388] tlb_flushall_shift: 6
[    0.035536] Freeing SMP alternatives memory: 28K (ffffffff8392a000 - fff=
fffff83931000)
[    0.040786] Getting VERSION: 1050014
[    0.041706] Getting VERSION: 1050014
[    0.042599] Getting ID: 0
[    0.043381] Getting ID: ff000000
[    0.044229] Getting LVT0: 8700
[    0.045061] Getting LVT1: 8400
[    0.045955] enabled ExtINT on CPU#0
[    0.048596] ENABLING IO-APIC IRQs
[    0.049769] init IO_APIC IRQs
[    0.050015]  apic 0 pin 0 not connected
[    0.050988] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052828] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.054695] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056514] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.058663] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.060044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.062640] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.065125] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.067633] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070041] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.072728] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.075500] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.080044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.082828] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.085799] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.088111]  apic 0 pin 16 not connected
[    0.089048]  apic 0 pin 17 not connected
[    0.090009]  apic 0 pin 18 not connected
[    0.090950]  apic 0 pin 19 not connected
[    0.091924]  apic 0 pin 20 not connected
[    0.093381]  apic 0 pin 21 not connected
[    0.094826]  apic 0 pin 22 not connected
[    0.096262]  apic 0 pin 23 not connected
[    0.097872] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.100010] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.103046] Using local APIC timer interrupts.
[    0.103046] calibrating APIC timer ...
[    0.110000] ... lapic delta =3D 6250102
[    0.110000] ... PM-Timer delta =3D 357931
[    0.110000] ... PM-Timer result ok
[    0.110000] ..... delta 6250102
[    0.110000] ..... mult: 268439836
[    0.110000] ..... calibration result: 10000163
[    0.110000] ..... CPU clock speed is 2393.8053 MHz.
[    0.110000] ..... host bus clock speed is 1000.0163 MHz.
[    0.110168] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.115326] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.117994] x86: Booting SMP configuration:
[    0.119606] .... node  #0, CPUs:      #1
[    0.020000] kvm-clock: cpu 1, msr 0:13c66041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.140162] x86: Booted up 1 node, 2 CPUs
[    0.140131] KVM setup async PF for cpu 1
[    0.140142] kvm-stealtime: cpu 1, msr 1390cd40
[    0.143721] ----------------
[    0.144499] | NMI testsuite:
[    0.145280] --------------------
[    0.146111]   remote IPI:  ok  |
[    0.151042]    local IPI:  ok  |
[    0.170041] --------------------
[    0.171361] Good, all   2 testcases passed! |
[    0.172995] ---------------------------------
[    0.174568] smpboot: Total of 2 processors activated (9575.99 BogoMIPS)
[    0.193309] gcov: version magic: 0x3430382a
[    0.196993] xor: measuring software checksum speed
[    0.300019]    prefetch64-sse:  8529.200 MB/sec
[    0.400017]    generic_sse:  7462.000 MB/sec
[    0.401500] xor: using function: prefetch64-sse (8529.200 MB/sec)
[    0.403343] prandom: seed boundary self test passed
[    0.405230] prandom: 100 self tests passed
[    0.406213] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.407984] NET: Registered protocol family 16
[    0.411041] cpuidle: using governor menu
[    0.413089] ACPI: bus type PCI registered
[    0.414317] dca service started, version 1.12.1
[    0.415443] PCI: Using configuration type 1 for base access
[    0.607243] raid6: sse2x1    1281 MB/s
[    0.777248] raid6: sse2x2    1967 MB/s
[    0.947326] raid6: sse2x4    1735 MB/s
[    0.949037] raid6: using algorithm sse2x2 (1967 MB/s)
[    0.950015] raid6: using intx1 recovery algorithm
[    0.952036] ACPI: Added _OSI(Module Device)
[    0.953073] ACPI: Added _OSI(Processor Device)
[    0.954143] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.955230] ACPI: Added _OSI(Processor Aggregator Device)
[    0.972391] ACPI: Interpreter enabled
[    0.973397] ACPI: (supports S0 S5)
[    0.974414] ACPI: Using IOAPIC for interrupt routing
[    0.976407] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.997373] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.998730] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    1.000099] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.002119] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.006326] PCI host bridge to bus 0000:00
[    1.007803] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.009516] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.010015] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.011326] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.012642] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.014293] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.015597] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.017041] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.018520] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.021237] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.023437] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.028333] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.031100] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.032548] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.033874] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.035727] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.037613] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.040099] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.041826] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.045058] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.048139] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.050676] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.059100] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.060709] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.062991] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.065327] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.073006] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.074932] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.076784] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.082310] pci_bus 0000:00: on NUMA node 0
[    1.085025] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.087112] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.089189] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.091309] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.093166] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.095868] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.097641] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.099510] vgaarb: loaded
[    1.100011] vgaarb: bridge control possible 0000:00:02.0
[    1.101295] SCSI subsystem initialized
[    1.101691] libata version 3.00 loaded.
[    1.101691] ACPI: bus type USB registered
[    1.102390] usbcore: registered new interface driver usbfs
[    1.103652] usbcore: registered new interface driver hub
[    1.110065] usbcore: registered new device driver usb
[    1.110142] pps_core: LinuxPPS API ver. 1 registered
[    1.111407] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.118583] PTP clock support registered
[    1.120201] wmi: Mapper loaded
[    1.121328] PCI: Using ACPI for IRQ routing
[    1.122359] PCI: pci_cache_line_size set to 64 bytes
[    1.123621] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.124907] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.126855] irda_init()
[    1.127788] NET: Registered protocol family 23
[    1.130012] Switched to clocksource kvm-clock
[    1.131701] Warning: could not register all branches stats
[    1.132929] Warning: could not register annotated branches stats
[    1.173510] pnp: PnP ACPI init
[    1.174520] ACPI: bus type PNP registered
[    1.175675] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.177714] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.179233] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.181596] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.183626] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.186504] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.188633] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.190585] pnp 00:03: [dma 2]
[    1.192031] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.194328] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.196422] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.198827] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.202081] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.205898] pnp: PnP ACPI: found 6 devices
[    1.207491] ACPI: bus type PNP unregistered
[    1.221176] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.222425] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.223677] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.224928] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.226140] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.227358] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.228788] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.230257] NET: Registered protocol family 1
[    1.231417] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.232726] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.234014] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.235371] pci 0000:00:02.0: Boot video device
[    1.236504] PCI: CLS 0 bytes, default 64
[    1.238077] Unpacking initramfs...
[    1.387485] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    1.392351] cryptomgr_test (34) used greatest stack depth: 14888 bytes l=
eft
[    1.396538] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.398508] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.400553] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.404961] spin_lock-torture: Creating torture_shuffle task
[    1.406832] spin_lock-torture: Creating torture_stutter task
[    1.406843] spin_lock-torture: torture_shuffle task started
[    1.410379] spin_lock-torture: Creating lock_torture_writer task
[    1.410405] spin_lock-torture: torture_stutter task started
[    1.413847] spin_lock-torture: Creating lock_torture_writer task
[    1.413875] spin_lock-torture: lock_torture_writer task started
[    1.417335] spin_lock-torture: Creating lock_torture_writer task
[    1.417361] spin_lock-torture: lock_torture_writer task started
[    1.420945] spin_lock-torture: Creating lock_torture_writer task
[    1.420962] spin_lock-torture: lock_torture_writer task started
[    1.424431] spin_lock-torture: Creating lock_torture_stats task
[    1.424446] spin_lock-torture: lock_torture_writer task started
[    1.428210] spin_lock-torture: lock_torture_stats task started
[    1.429614] futex hash table entries: 512 (order: 4, 65536 bytes)
[    1.431711] Initialise system trusted keyring
[    2.392036] tsc: Refined TSC clocksource calibration: 2393.992 MHz
[    2.702747] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.723726] VFS: Disk quotas dquot_6.5.2
[    2.726657] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.731339] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, debug enabled
[    2.744374] gfs2: GFS2 installed
[    2.746294] cryptomgr_test (60) used greatest stack depth: 14768 bytes l=
eft
[    2.749980] NET: Registered protocol family 38
[    2.751894] Key type asymmetric registered
[    2.753627] Asymmetric key parser 'x509' registered
[    2.756019] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.759061] io scheduler noop registered
[    2.760775] io scheduler deadline registered (default)
[    2.762728] test_string_helpers: Running tests...
[    2.806392] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.808160] crc32: self tests passed, processed 225944 bytes in 27693485=
 nsec
[    2.829959] crc32c: CRC_LE_BITS =3D 1
[    2.831448] crc32c: self tests passed, processed 225944 bytes in 1274552=
2 nsec
[    4.394970] crc32_combine: 8373 self tests passed
[    6.035738] crc32c_combine: 8373 self tests passed
[    6.038720] rbtree testing -> 42940 cycles
[    8.030685] augmented rbtree testing -> 62345 cycles
[   10.902095] ipmi message handler version 39.2
[   10.903833] IPMI System Interface driver.
[   10.905760] ipmi_si: Unable to find any System Interface(s)
[   10.907854] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   10.911098] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   10.946612] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   10.970917] kworker/u4:0 (87) used greatest stack depth: 14256 bytes left
[   10.971680] lp: driver loaded but no devices found
[   10.971852] Non-volatile memory driver v1.3
[   10.976445] ppdev: user-space parallel port driver
[   10.978149] smapi::smapi_init, ERROR invalid usSmapiID
[   10.980996] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   10.984026] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   10.986611] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   10.988627] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   10.991608] Hangcheck: Using getrawmonotonic().
[   10.993391] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   10.995738] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   10.998673] Guest personality initialized and is inactive
[   11.000666] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D62)
[   11.002625] Initialized host personality
[   11.004684] usbcore: registered new interface driver viperboard
[   11.006511] Uniform Multi-Platform E-IDE driver
[   11.008772] Loading iSCSI transport class v2.0-870.
[   11.035023] hp_sw: device handler registered
[   11.036562] alua: device handler registered
[   11.039053] Adaptec aacraid driver 1.2-0[30300]-ms
[   11.040953] scsi: <fdomain> Detection failed (no card)
[   11.042754] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[   11.044853] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   11.046998] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   11.049789] RocketRAID 3xxx/4xxx Controller driver v1.8
[   11.051867] iscsi: registered transport (be2iscsi)
[   11.053492] In beiscsi_module_init, tt=3Dffffffff83043c20
[   11.055420] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[   11.063174] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   11.074666] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   11.078632] libphy: Fixed MDIO Bus: probed
[   11.080896] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[   11.084100] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[   11.086745] tlan: ThunderLAN driver v1.17
[   11.088223] tlan: 0 devices installed, PCI: 0  EISA: 0
[   11.090103] w83977af_init()
[   11.092648] w83977af_open()
[   11.093798] w83977af_probe()
[   11.095079] w83977af_probe(), Wrong chip version
[   11.095978] w83977af_probe()
[   11.097242] w83977af_probe(), Wrong chip version
[   11.098065] usbcore: registered new interface driver mcs7780
[   11.099921] PPP generic driver version 2.4.2
[   11.101119] PPP MPPE Compression module registered
[   11.102571] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[   11.104772] usbcore: registered new interface driver ipheth
[   11.107506] usbcore: registered new interface driver hwa-rc
[   11.109404] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.111502] ehci-pci: EHCI PCI platform driver
[   11.113249] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   11.115450] usbcore: registered new interface driver wusb-cbaf
[   11.117372] usbcore: registered new interface driver cdc_acm
[   11.119176] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[   11.122093] usbcore: registered new interface driver usbtmc
[   11.123920] usbcore: registered new interface driver microtekX6
[   11.126050] usbcore: registered new interface driver appledisplay
[   11.127991] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   11.130217] usbcore: registered new interface driver usblcd
[   11.132060] usbcore: registered new interface driver usbtest
[   11.133910] usbcore: registered new interface driver uss720
[   11.135653] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[   11.137630] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[   11.139350] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[   11.141411] uss720: If you just want to connect to a printer, use usblp =
instead
[   11.150798] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   11.155032] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.156662] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.169089] parkbd: no such parport
[   11.170897] usbcore: registered new interface driver appletouch
[   11.173039] usbcore: registered new interface driver bcm5974
[   11.175945] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   11.187542] mk712: device not present
[   11.189086] usbcore: registered new interface driver usbtouchscreen
[   11.191700] cm109: Keymap for Komunikate KIP1000 phone loaded
[   11.193716] usbcore: registered new interface driver cm109
[   11.195618] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   11.197685] usbcore: registered new interface driver ims_pcu
[   11.200677] pps pps0: new PPS source ktimer
[   11.202235] pps pps0: ktimer PPS source registered
[   11.203872] pps_ldisc: PPS line discipline registered
[   11.206981] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   11.208804] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   11.213627] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   11.217254] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[   11.219064] sc1200wdt: build 20020303
[   11.220420] sc1200wdt: io parameter must be specified
[   11.222411] pc87413_wdt: Version 1.1 at io 0x2E
[   11.224175] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   11.226560] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   11.235120] usbcore: registered new interface driver tranzport
[   11.237385] usbcore: registered new interface driver alphatrack
[   11.239949] input: Speakup as /devices/virtual/input/input3
[   11.242323] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   11.244878] speakup 3.1.6: initialized
[   11.246496] synth name on entry is: (null)
[   11.248250] usbcore: registered new interface driver gdm_wimax
[   11.262909] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[   11.265154] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[   11.268784] FPGA DOWNLOAD --->
[   11.270212] FPGA image file name: xlinx_fpga_firmware.bit
[   11.272515] GPIO INIT FAIL!!
[   11.274167] dell_wmi_aio: No known WMI GUID found
[   11.275961] Initializing HPQ6001 module
[   11.277829] Mirror/redirect action on
[   11.279342] Simple TC action Loaded
[   11.281072] netem: version 1.3
[   11.282612] NET: Registered protocol family 17
[   11.284352] NET: Registered protocol family 5
[   11.286689] IrCOMM protocol (Dag Brattli)
[   11.292072] 9pnet: Installing 9P2000 support
[   11.293728] Key type dns_resolver registered
[   11.295600] batman_adv: B.A.T.M.A.N. advanced 2014.3.0 (compatibility ve=
rsion 15) loaded
[   11.298386] mpls_gso: MPLS GSO support
[   11.300367]=20
[   11.300367] printing PIC contents
[   11.302612] ... PIC  IMR: ffff
[   11.303957] ... PIC  IRR: 1013
[   11.305249] ... PIC  ISR: 0000
[   11.306561] ... PIC ELCR: 0c00
[   11.307892] printing local APIC contents on CPU#0/0:
[   11.309609] ... APIC ID:      00000000 (0)
[   11.311103] ... APIC VERSION: 01050014
[   11.312614] ... APIC TASKPRI: 00000000 (00)
[   11.314351] ... APIC PROCPRI: 00000000
[   11.315948] ... APIC LDR: 01000000
[   11.317259] ... APIC DFR: ffffffff
[   11.317878] ... APIC SPIV: 000001ff
[   11.317878] ... APIC ISR field:
[   11.317878] 000000000000000000000000000000000000000000000000000000000000=
0000
[   11.317878] ... APIC TMR field:
[   11.317878] 000000000200000000000000000000000000000000000000000000000000=
0000
[   11.317878] ... APIC IRR field:
[   11.317878] 000000000000000000000000000000000000000000000000000000000000=
8000
[   11.317878] ... APIC ESR: 00000000
[   11.317878] ... APIC ICR: 000008fd
[   11.317878] ... APIC ICR2: 02000000
[   11.317878] ... APIC LVTT: 000000ef
[   11.317878] ... APIC LVTPC: 00010000
[   11.317878] ... APIC LVT0: 00010700
[   11.317878] ... APIC LVT1: 00000400
[   11.317878] ... APIC LVTERR: 000000fe
[   11.317878] ... APIC TMICT: 0009808b
[   11.317878] ... APIC TMCCT: 00000000
[   11.317878] ... APIC TDCR: 00000003
[   11.317878]=20
[   11.350929] number of MP IRQ sources: 15.
[   11.352383] number of IO-APIC #0 registers: 24.
[   11.353942] testing the IO APIC.......................
[   11.355747] IO APIC #0......
[   11.356979] .... register #00: 00000000
[   11.358368] .......    : physical APIC id: 00
[   11.359952] .......    : Delivery Type: 0
[   11.361546] .......    : LTS          : 0
[   11.362976] .... register #01: 00170011
[   11.364451] .......     : max redirection entries: 17
[   11.366265] .......     : PRQ implemented: 0
[   11.367828] .......     : IO APIC version: 11
[   11.369292] .... register #02: 00000000
[   11.370857] .......     : arbitration: 00
[   11.372341] .... IRQ redirection table:
[   11.373779] 1    0    0   0   0    0    0    00
[   11.375359] 0    0    0   0   0    1    1    31
[   11.376963] 0    0    0   0   0    1    1    30
[   11.378597] 0    0    0   0   0    1    1    33
[   11.380285] 1    0    0   0   0    1    1    34
[   11.382018] 1    1    0   0   0    1    1    35
[   11.383617] 0    0    0   0   0    1    1    36
[   11.385190] 0    0    0   0   0    1    1    37
[   11.386789] 0    0    0   0   0    1    1    38
[   11.388373] 0    1    0   0   0    1    1    39
[   11.390146] 1    1    0   0   0    1    1    3A
[   11.391824] 1    1    0   0   0    1    1    3B
[   11.393421] 0    0    0   0   0    1    1    3C
[   11.395013] 0    0    0   0   0    1    1    3D
[   11.396636] 0    0    0   0   0    1    1    3E
[   11.398221] 0    0    0   0   0    1    1    3F
[   11.399822] 1    0    0   0   0    0    0    00
[   11.401579] 1    0    0   0   0    0    0    00
[   11.403032] 1    0    0   0   0    0    0    00
[   11.404671] 1    0    0   0   0    0    0    00
[   11.406281] 1    0    0   0   0    0    0    00
[   11.407868] 1    0    0   0   0    0    0    00
[   11.409420] 1    0    0   0   0    0    0    00
[   11.411200] 1    0    0   0   0    0    0    00
[   11.412798] IRQ to pin mappings:
[   11.414103] IRQ0 -> 0:2
[   11.415510] IRQ1 -> 0:1
[   11.416911] IRQ3 -> 0:3
[   11.418304] IRQ4 -> 0:4
[   11.419822] IRQ5 -> 0:5
[   11.421452] IRQ6 -> 0:6
[   11.422847] IRQ7 -> 0:7
[   11.424356] IRQ8 -> 0:8
[   11.425884] IRQ9 -> 0:9
[   11.427306] IRQ10 -> 0:10
[   11.428761] IRQ11 -> 0:11
[   11.430266] IRQ12 -> 0:12
[   11.431822] IRQ13 -> 0:13
[   11.433272] IRQ14 -> 0:14
[   11.434760] IRQ15 -> 0:15
[   11.436190] .................................... done.
[   11.439073] Loading compiled-in X.509 certificates
[   11.444541] Loaded X.509 cert 'Magrathea: Glacier signing key: 90a762e8d=
b947539e440b925bc25b6bb854446b4'
[   11.463225] Btrfs loaded, integrity-checker=3Don
[   11.480799] Freeing unused kernel memory: 1412K (ffffffff837c9000 - ffff=
ffff8392a000)
[   11.495009] mount (116) used greatest stack depth: 13720 bytes left
[   11.505157] S00fbsetup (118) used greatest stack depth: 13640 bytes left
[   11.606071] S03udev (125) used greatest stack depth: 13632 bytes left
[   11.637292] gfs2: path_lookup on rootfs returned error -2
[   11.641397] mount (143) used greatest stack depth: 13392 bytes left
[   12.043811] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[   61.420099] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[   81.194543] Unregister pv shared memory for cpu 1
[   81.196067] Unregister pv shared memory for cpu 0
[   81.197674] spin_lock-torture: Unscheduled system shutdown detected
[   81.200104] torture thread torture_shuffle parking due to system shutdown

BUG: kernel boot crashed
Elapsed time: 90
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea6b05db/vmlinuz-3.16.0-rc2=
-00003-g3b3fb61 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06261808/linux-devel=
:devel-hourly-2014062617:3b3fb61976509ef8f7c0c05adba0b61cea6b05db:bisect-li=
nux0/.vmlinuz-3b3fb61976509ef8f7c0c05adba0b61cea6b05db-20140629095255-19-lk=
p-wsx01 branch=3Dlinux-devel/devel-hourly-2014062617 BOOT_IMAGE=3D/kernel/x=
86_64-randconfig-hsxa0-06261808/3b3fb61976509ef8f7c0c05adba0b61cea6b05db/vm=
linuz-3.16.0-rc2-00003-g3b3fb61 drbd.minor_count=3D8'  -initrd /kernel-test=
s/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De=
1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc=
 base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-lkp-wsx01-130 -serial f=
ile:/dev/shm/kboot/serial-yocto-lkp-wsx01-130 -daemonize -display none -mon=
itor null=20

--WhfpMioaduB5tiZL
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsxa0-06261808-9c33bf1e59d26dad8dc45e438cbdc28783589b11-WARNING:---at----sd_init+-x-59038.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgOWMzM2JmMS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MjYxNycKZ2l0IGNoZWNrb3V0IGE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3
Yjk2NDM1YmE4YzJjYjQyZWUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDYyNjE3OmE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWU6
YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0wODowNjozMyBhNDk3YzNiYTFkOTdmYzY5YzFl
NzhlN2I5NjQzNWJhOGMyY2I0MmVlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYx
ODA4LWE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2E0
OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MjYxODA4LWE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQy
ZWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2xrcC1oc3gwMS1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC1hNDk3
YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9hNDk3YzNiYTFkOTdmYzY5YzFlNzhl
N2I5NjQzNWJhOGMyY2I0MmVlL3ZtbGludXotMy4xNi4wLXJjMgoKMjAxNC0wNi0yOS0wODox
MDozMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4JNgkxOSBTVUNDRVNTCgpiaXNlY3Q6
IGdvb2QgY29tbWl0IGE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUK
Z2l0IGJpc2VjdCBzdGFydCA5YzMzYmYxZTU5ZDI2ZGFkOGRjNDVlNDM4Y2JkYzI4NzgzNTg5
YjExIGE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUgLS0KL2Mva2Vy
bmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiOWMzM2JmMWU1OWQyNmRhZDhkYzQ1
ZTQzOGNiZGMyODc4MzU4OWIxMSIsICItZyIsICJhNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5
NjQzNWJhOGMyY2I0MmVlIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QiXQpCaXNlY3Rp
bmc6IDM0MzIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEy
IHN0ZXBzKQpbMTBkOWQwMjkwNjdmMmFhY2JkYzE0MDc4NmVmZmYxNDZkNzliMzRjNV0gTWVy
Z2UgJ2Nncm91cC9mb3ItMy4xNi1maXhlcycgaW50byBkZXZlbC1ob3VybHktMjAxNDA2MjYx
NwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDYyNjE3OjEwZDlkMDI5MDY3ZjJhYWNiZGMxNDA3ODZl
ZmZmMTQ2ZDc5YjM0YzU6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0wODoxNDozNyAxMGQ5
ZDAyOTA2N2YyYWFjYmRjMTQwNzg2ZWZmZjE0NmQ3OWIzNGM1IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MjYxODA4LTEwZDlkMDI5MDY3ZjJhYWNiZGMxNDA3ODZlZmZmMTQ2ZDc5
YjM0YzUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MjYxODA4LzEwZDlkMDI5MDY3ZjJhYWNiZGMxNDA3ODZlZmZmMTQ2ZDc5YjM0YzUK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTEwZDlkMDI5MDY3ZjJhYWNiZGMxNDA3
ODZlZmZmMTQ2ZDc5YjM0YzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjI2MTgwOC0xMGQ5ZDAyOTA2N2YyYWFjYmRjMTQwNzg2ZWZmZjE0NmQ3OWIzNGM1Cmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC8xMGQ5ZDAy
OTA2N2YyYWFjYmRjMTQwNzg2ZWZmZjE0NmQ3OWIzNGM1L3ZtbGludXotMy4xNi4wLXJjMi0w
MjY0My1nMTBkOWQwMgoKMjAxNC0wNi0yOS0wODoxNzozNyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uCTcJMTUuLi4uLi4uLi4uCTE5IFNVQ0NFU1MKCkJpc2VjdGluZzogNzg5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2I4ZGIw
ZmM4OTY4NDllOTQwZjIzZmJlYTAyYzEzNzg2OWM5NGYzZDNdIE1lcmdlICdrdm0tcHBjL2t2
bS1wcGMtcXVldWUnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjI2MTcKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA2MjYxNzpiOGRiMGZjODk2ODQ5ZTk0MGYyM2ZiZWEwMmMxMzc4NjljOTRmM2Qz
OmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjktMDg6MjY6MDggYjhkYjBmYzg5Njg0OWU5NDBm
MjNmYmVhMDJjMTM3ODY5Yzk0ZjNkMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2
MTgwOC1iOGRiMGZjODk2ODQ5ZTk0MGYyM2ZiZWEwMmMxMzc4NjljOTRmM2QzCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9i
OGRiMGZjODk2ODQ5ZTk0MGYyM2ZiZWEwMmMxMzc4NjljOTRmM2QzCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjI2MTgwOC1iOGRiMGZjODk2ODQ5ZTk0MGYyM2ZiZWEwMmMxMzc4NjljOTRm
M2QzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDEtc21va2UveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgtYjhk
YjBmYzg5Njg0OWU5NDBmMjNmYmVhMDJjMTM3ODY5Yzk0ZjNkMwprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvYjhkYjBmYzg5Njg0OWU5NDBmMjNm
YmVhMDJjMTM3ODY5Yzk0ZjNkMy92bWxpbnV6LTMuMTYuMC1yYzItMDI4OTctZ2I4ZGIwZmMK
CjIwMTQtMDYtMjktMDg6Mjk6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4gVEVT
VCBGQUlMVVJFClsgICAgMC4xNjI0NTZdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQpbICAgIDAuMTY0NTEzXSBzbXBib290OiBUb3RhbCBvZiAyIHByb2Nlc3NvcnMgYWN0
aXZhdGVkICgxMDc3NC4wMSBCb2dvTUlQUykKWyAgICAwLjE2NzIwN10gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4xNjg0NTRdIFdBUk5JTkc6IENQVTog
MCBQSUQ6IDEgYXQgL2tidWlsZC9zcmMvc21va2Uva2VybmVsL3NjaGVkL2NvcmUuYzo2MDc4
IHNkX2luaXQrMHgzZTYvMHg0MDAoKQpbICAgIDAuMTcwMDA2XSB3cm9uZyBzZF9mbGFncyBp
biB0b3BvbG9neSBkZXNjcmlwdGlvbgpbICAgIDAuMTcxMDM1XSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgICAwLjE3MjM0NF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xNi4wLXJjMi0wMjg5Ny1nYjhkYjBmYyAjMQpbICAgIDAuMTc0MzQ1XSBIYXJk
d2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4xNzYwNDZdICAwMDAwMDAwMDAwMDAwMDA5IGZm
ZmY4ODAwMTIwODdkMzAgZmZmZmZmZmY4MjJmYjViYiBmZmZmODgwMDEyMDg3ZDc4ClsgICAg
MC4xNzgxMTJdICBmZmZmODgwMDEyMDg3ZDY4IGZmZmZmZmZmODEwZDM4YzcgZmZmZmZmZmY4
MmRhMjMxOCAwMDAwMDAwMDAwMDA4MDAwClsgICAgMC4xODAzNzFdICAwMDAwMDAwMDAwMDAw
MDAxIGZmZmY4ODAwMTIxYjgwMDAgMDAwMDAwMDAwMDAwMDAwMSBmZmZmODgwMDEyMDg3ZGM4
ClsgICAgMC4xODIzMzldIENhbGwgVHJhY2U6ClsgICAgMC4xODMzNDldICBbPGZmZmZmZmZm
ODIyZmI1YmI+XSBkdW1wX3N0YWNrKzB4YzEvMHgxMTEKWyAgICAwLjE4NDUxMV0gIFs8ZmZm
ZmZmZmY4MTBkMzhjNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YzcvMHgxMDAKWyAgICAw
LjE4NTUyMl0gIFs8ZmZmZmZmZmY4MTBkMzllNz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NTcv
MHg3MApbICAgIDAuMTg2NjgxXSAgWzxmZmZmZmZmZjgxN2QxNTE0Pl0gPyBfX2JpdG1hcF93
ZWlnaHQrMHhlNC8weDExMApbICAgIDAuMTg4Mjg1XSAgWzxmZmZmZmZmZjgxMTMwMTI2Pl0g
c2RfaW5pdCsweDNlNi8weDQwMApbICAgIDAuMTg5MzcxXSAgWzxmZmZmZmZmZjgxMTQxMGIx
Pl0gYnVpbGRfc2NoZWRfZG9tYWluKzB4MzEvMHgyMzAKWyAgICAwLjE5MDAxNl0gIFs8ZmZm
ZmZmZmY4MTE0MWVmNj5dIGJ1aWxkX3NjaGVkX2RvbWFpbnMrMHhjNDYvMHgxNzcwClsgICAg
MC4xOTE0ODFdICBbPGZmZmZmZmZmODM4MWI5NjA+XSBzY2hlZF9pbml0X3NtcCsweDExOC8w
eDNiMApbICAgIDAuMTkyNzM5XSAgWzxmZmZmZmZmZjgzN2YyYzRjPl0ga2VybmVsX2luaXRf
ZnJlZWFibGUrMHhjZC8weDMxYQpbICAgIDAuMTk0MjgyXSAgWzxmZmZmZmZmZjgyMmQzM2Mw
Pl0gPyByZXN0X2luaXQrMHgxMjAvMHgxMjAKWyAgICAwLjE5NTM0M10gIFs8ZmZmZmZmZmY4
MjJkMzNkMT5dIGtlcm5lbF9pbml0KzB4MTEvMHgyMzAKWyAgICAwLjE5NjI4Nl0gIFs8ZmZm
ZmZmZmY4MjMxOTdmYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC4xOTcxNjJd
ICBbPGZmZmZmZmZmODIyZDMzYzA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAgIDAu
MTk4NDMwXSAtLS1bIGVuZCB0cmFjZSA0MTU2MjVkYzc3MGYwMWNmIF0tLS0KWyAgICAwLjIw
NjUxOF0gZ2NvdjogdmVyc2lvbiBtYWdpYzogMHgzNDMwMzgyYQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2I4ZGIwZmM4OTY4NDllOTQwZjIzZmJlYTAyYzEz
Nzg2OWM5NGYzZDMvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMDI6MjAxNDA2MjkwODMwMjM6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MjYxODA4L2I4ZGIwZmM4OTY4NDllOTQwZjIzZmJlYTAyYzEzNzg2OWM5
NGYzZDMvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMToyMDE0MDYyOTA4MzAyMjp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDgvYjhkYjBmYzg5Njg0OWU5NDBmMjNmYmVhMDJjMTM3ODY5Yzk0ZjNkMy9k
bWVzZy1xdWFudGFsLWl2YjQyLTU6MjAxNDA2MjkwODMwMjI6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYx
ODA4L2I4ZGIwZmM4OTY4NDllOTQwZjIzZmJlYTAyYzEzNzg2OWM5NGYzZDMvZG1lc2ctcXVh
bnRhbC1pdmI0Mi04MjoyMDE0MDYyOTA4MzAyMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvYjhk
YjBmYzg5Njg0OWU5NDBmMjNmYmVhMDJjMTM3ODY5Yzk0ZjNkMy9kbWVzZy1xdWFudGFsLWl2
YjQyLTkxOjIwMTQwNjI5MDgzMDI3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9iOGRiMGZjODk2
ODQ5ZTk0MGYyM2ZiZWEwMmMxMzc4NjljOTRmM2QzL2RtZXNnLXF1YW50YWwtaXZiNDItOTQ6
MjAxNDA2MjkwODMwMjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2I4ZGIwZmM4OTY4NDllOTQw
ZjIzZmJlYTAyYzEzNzg2OWM5NGYzZDMvZG1lc2ctcXVhbnRhbC1pdmI0Mi05NzoyMDE0MDYy
OTA4MzAyNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6CjA6Nzo2IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDI1NCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzcxMzViMTMwZDlmMWMzMDMy
MWY5YTllMDI0NDk4NTU3MDI2Y2RkMDNdIE1lcmdlICdhcm0tcGxhdGZvcm1zL2t2bS1hcm02
NC9pcnEtZm9yd2FyZCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA2MjYxNwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDYyNjE3OjcxMzViMTMwZDlmMWMzMDMyMWY5YTllMDI0NDk4NTU3MDI2Y2Rk
MDM6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0wODozMzoxMCA3MTM1YjEzMGQ5ZjFjMzAz
MjFmOWE5ZTAyNDQ5ODU1NzAyNmNkZDAzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MjYxODA4LTcxMzViMTMwZDlmMWMzMDMyMWY5YTllMDI0NDk4NTU3MDI2Y2RkMDMKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
LzcxMzViMTMwZDlmMWMzMDMyMWY5YTllMDI0NDk4NTU3MDI2Y2RkMDMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MjYxODA4LTcxMzViMTMwZDlmMWMzMDMyMWY5YTllMDI0NDk4NTU3MDI2
Y2RkMDMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1oc3gwMS1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC03
MTM1YjEzMGQ5ZjFjMzAzMjFmOWE5ZTAyNDQ5ODU1NzAyNmNkZDAzCmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC83MTM1YjEzMGQ5ZjFjMzAzMjFm
OWE5ZTAyNDQ5ODU1NzAyNmNkZDAzL3ZtbGludXotMy4xNi4wLXJjMi0wMjgwNC1nNzEzNWIx
MwoKMjAxNC0wNi0yOS0wODozNzoxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uCTMJ
MTkgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2MyNDg0YThhY2RhN2Q5ZmY0MWE5OGQzZTJmY2M1
YTY1YmJkMDI3NDddIE1lcmdlICdhcmMvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNjI2MTcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYxNzpjMjQ4NGE4YWNkYTdkOWZmNDFh
OThkM2UyZmNjNWE2NWJiZDAyNzQ3OmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjktMDg6NDE6
NDEgYzI0ODRhOGFjZGE3ZDlmZjQxYTk4ZDNlMmZjYzVhNjViYmQwMjc0NyBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC1jMjQ4NGE4YWNkYTdkOWZmNDFhOThkM2UyZmNj
NWE2NWJiZDAyNzQ3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjI2MTgwOC9jMjQ4NGE4YWNkYTdkOWZmNDFhOThkM2UyZmNjNWE2NWJi
ZDAyNzQ3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC1jMjQ4NGE4YWNkYTdkOWZm
NDFhOThkM2UyZmNjNWE2NWJiZDAyNzQ3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtc21va2UveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYyNjE4MDgtYzI0ODRhOGFjZGE3ZDlmZjQxYTk4ZDNlMmZjYzVhNjViYmQw
Mjc0NwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgv
YzI0ODRhOGFjZGE3ZDlmZjQxYTk4ZDNlMmZjYzVhNjViYmQwMjc0Ny92bWxpbnV6LTMuMTYu
MC1yYzItMDI4MjQtZ2MyNDg0YTgKCjIwMTQtMDYtMjktMDg6NDU6NDEgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uLi4JNAkxOSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDczIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbMWE3OTlmNWM5
ZGJiZDQ3ZDUwM2FmMWUwY2VkZjlkMjUyY2NhMmQ2ZF0gTWVyZ2UgJ2NyeXB0b2Rldi9tYXN0
ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjI2MTcKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2
MjYxNzoxYTc5OWY1YzlkYmJkNDdkNTAzYWYxZTBjZWRmOWQyNTJjY2EyZDZkOmJpc2VjdC1s
aW51eDAKCjIwMTQtMDYtMjktMDg6NTA6NDEgMWE3OTlmNWM5ZGJiZDQ3ZDUwM2FmMWUwY2Vk
ZjlkMjUyY2NhMmQ2ZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC0xYTc5
OWY1YzlkYmJkNDdkNTAzYWYxZTBjZWRmOWQyNTJjY2EyZDZkCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC8xYTc5OWY1Yzlk
YmJkNDdkNTAzYWYxZTBjZWRmOWQyNTJjY2EyZDZkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjI2MTgwOC0xYTc5OWY1YzlkYmJkNDdkNTAzYWYxZTBjZWRmOWQyNTJjY2EyZDZkCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4
MDEtc21va2UveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgtMWE3OTlmNWM5ZGJi
ZDQ3ZDUwM2FmMWUwY2VkZjlkMjUyY2NhMmQ2ZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYyNjE4MDgvMWE3OTlmNWM5ZGJiZDQ3ZDUwM2FmMWUwY2VkZjlk
MjUyY2NhMmQ2ZC92bWxpbnV6LTMuMTYuMC1yYzItMDI4NzEtZzFhNzk5ZjUKCjIwMTQtMDYt
MjktMDg6NTQ6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uCTMJMTkgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAyNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNSBzdGVwcykKWzljMjU5ZDZhNDZlNzU0ZWE4ZmI0MmJjZjY4ODI1NWZmYTJjOGMw
NDhdIE1lcmdlICd5dXlhbmcvY2MtdjQtb24tMy4xNi1yYzInIGludG8gZGV2ZWwtaG91cmx5
LTIwMTQwNjI2MTcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
OC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYxNzo5YzI1OWQ2YTQ2ZTc1NGVh
OGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4OmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjktMDk6
MDA6MTIgOWMyNTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OCBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC05YzI1OWQ2YTQ2ZTc1NGVhOGZiNDJiY2Y2
ODgyNTVmZmEyYzhjMDQ4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1NGVhOGZiNDJiY2Y2ODgyNTVm
ZmEyYzhjMDQ4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC05YzI1OWQ2YTQ2ZTc1
NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtc21va2UveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYyNjE4MDgtOWMyNTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZh
MmM4YzA0OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4
MDgvOWMyNTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OC92bWxpbnV6LTMu
MTYuMC1yYzItMDI4ODItZzljMjU5ZDYKCjIwMTQtMDYtMjktMDk6MDQ6MTIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjIxMjA0Ml0gLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4yMTMxMThdIHNtcGJvb3Q6
IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDEwNzc0LjAzIEJvZ29NSVBTKQpb
ICAgIDAuMjE1MTM2XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICAwLjIxNjI3Ml0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAva2J1aWxkL3NyYy9zbW9r
ZS9rZXJuZWwvc2NoZWQvY29yZS5jOjYwNzggc2RfaW5pdCsweDNlNi8weDQwMCgpClsgICAg
MC4yMTg0MTZdIHdyb25nIHNkX2ZsYWdzIGluIHRvcG9sb2d5IGRlc2NyaXB0aW9uClsgICAg
MC4yMTk1NTFdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMjIwNDY4XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMyLTAyODgyLWc5YzI1
OWQ2ICMxClsgICAgMC4yMzAwMTRdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMg
KGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjIz
MjAwMF0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAxMjA4N2QzMCBmZmZmZmZmZjgyMmZi
NWJiIGZmZmY4ODAwMTIwODdkNzgKWyAgICAwLjIzNDI2OV0gIGZmZmY4ODAwMTIwODdkNjgg
ZmZmZmZmZmY4MTBkMzhjNyBmZmZmZmZmZjgyZGEyMzE4IDAwMDAwMDAwMDAwMDgwMDAKWyAg
ICAwLjI0MTc0MF0gIDAwMDAwMDAwMDAwMDAwMDEgZmZmZjg4MDAxMjFiODAwMCAwMDAwMDAw
MDAwMDAwMDAxIGZmZmY4ODAwMTIwODdkYzgKWyAgICAwLjI0NDAwOV0gQ2FsbCBUcmFjZToK
WyAgICAwLjI0NDc5Ml0gIFs8ZmZmZmZmZmY4MjJmYjViYj5dIGR1bXBfc3RhY2srMHhjMS8w
eDExMQpbICAgIDAuMjQ2MDEyXSAgWzxmZmZmZmZmZjgxMGQzOGM3Pl0gd2Fybl9zbG93cGF0
aF9jb21tb24rMHhjNy8weDEwMApbICAgIDAuMjQ3MzU3XSAgWzxmZmZmZmZmZjgxMGQzOWU3
Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsgICAgMC4yNDg2NDddICBbPGZmZmZm
ZmZmODE3ZDE1MTQ+XSA/IF9fYml0bWFwX3dlaWdodCsweGU0LzB4MTEwClsgICAgMC4yNTAw
MTddICBbPGZmZmZmZmZmODExMzAxMjY+XSBzZF9pbml0KzB4M2U2LzB4NDAwClsgICAgMC4y
NjAwMjRdICBbPGZmZmZmZmZmODExNDEwYjE+XSBidWlsZF9zY2hlZF9kb21haW4rMHgzMS8w
eDIzMApbICAgIDAuMjYxMzYwXSAgWzxmZmZmZmZmZjgxMTQxZWY2Pl0gYnVpbGRfc2NoZWRf
ZG9tYWlucysweGM0Ni8weDE3NzAKWyAgICAwLjI2MjcyOV0gIFs8ZmZmZmZmZmY4MzgxYjk2
MD5dIHNjaGVkX2luaXRfc21wKzB4MTE4LzB4M2IwClsgICAgMC4yNjQwMDldICBbPGZmZmZm
ZmZmODM3ZjJjNGM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGNkLzB4MzFhClsgICAgMC4y
NjUzNDhdICBbPGZmZmZmZmZmODIyZDMzYzA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApb
ICAgIDAuMjcwMDE0XSAgWzxmZmZmZmZmZjgyMmQzM2QxPl0ga2VybmVsX2luaXQrMHgxMS8w
eDIzMApbICAgIDAuMjcxMzE4XSAgWzxmZmZmZmZmZjgyMzE5N2ZjPl0gcmV0X2Zyb21fZm9y
aysweDdjLzB4YjAKWyAgICAwLjI3MjY0Nl0gIFs8ZmZmZmZmZmY4MjJkMzNjMD5dID8gcmVz
dF9pbml0KzB4MTIwLzB4MTIwClsgICAgMC4yNzM5MDZdIC0tLVsgZW5kIHRyYWNlIDIyNzc2
ZTQxYWUyNmJhNDUgXS0tLQpbICAgIDAuMjk4MzQxXSBnY292OiB2ZXJzaW9uIG1hZ2ljOiAw
eDM0MzAzODJhCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMy
NTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OC9kbWVzZy1xdWFudGFsLWl2
YjQxLTExMzoyMDE0MDYyOTA5MDQ1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMyNTlkNmE0
NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OC9kbWVzZy1xdWFudGFsLWl2YjQxLTE3
OjIwMTQwNjI5MDkwNDU0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1NGVh
OGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtaXZiNDEtMjY6MjAxNDA2
MjkwOTA0NDk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMjU5ZDZhNDZlNzU0ZWE4ZmI0MmJj
ZjY4ODI1NWZmYTJjOGMwNDgvZG1lc2ctcXVhbnRhbC1pdmI0MS0zNToyMDE0MDYyOTA5MDQ1
NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMyNTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1
ZmZhMmM4YzA0OC9kbWVzZy1xdWFudGFsLWl2YjQxLTM5OjIwMTQwNjI5MDkwNDU0Ong4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhj
MDQ4L2RtZXNnLXF1YW50YWwtaXZiNDEtNTU6MjAxNDA2MjkwOTA0NTQ6eDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MjYxODA4LzljMjU5ZDZhNDZlNzU0ZWE4ZmI0MmJjZjY4ODI1NWZmYTJjOGMwNDgvZG1l
c2ctcXVhbnRhbC1pdmI0MS05OjIwMTQwNjI5MDkwNDU0Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
OC85YzI1OWQ2YTQ2ZTc1NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50
YWwtbGtwLW5leDA0LTEwMToyMDE0MDYyOTA5MDUxODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgv
OWMyNTlkNmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OC9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNC0xMDU6MjAxNDA2MjkwOTA1MTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4Lzlj
MjU5ZDZhNDZlNzU0ZWE4ZmI0MmJjZjY4ODI1NWZmYTJjOGMwNDgvZG1lc2ctcXVhbnRhbC1s
a3AtbmV4MDQtMTU5OjIwMTQwNjI5MDkwNTExOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1
OWQ2YTQ2ZTc1NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtbGtw
LW5leDA0LTE2MToyMDE0MDYyOTA5MDUxNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2
MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMyNTlk
NmE0NmU3NTRlYThmYjQyYmNmNjg4MjU1ZmZhMmM4YzA0OC9kbWVzZy1xdWFudGFsLWxrcC1u
ZXgwNC0xNjI6MjAxNDA2MjkwOTA1MTE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4
MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMjU5ZDZh
NDZlNzU0ZWE4ZmI0MmJjZjY4ODI1NWZmYTJjOGMwNDgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4
MDQtMTYzOjIwMTQwNjI5MDkwNTE5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2
ZTc1NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0
LTI1OjIwMTQwNjI5MDkwNTE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1
NGVhOGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTI3
OjIwMTQwNjI5MDkwNTEzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1NGVh
OGZiNDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTMxOjIw
MTQwNjI5MDkwNTEyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzI1OWQ2YTQ2ZTc1NGVhOGZi
NDJiY2Y2ODgyNTVmZmEyYzhjMDQ4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTM4OjIwMTQw
NjI5MDkwNTE1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKMDoxNzoxNiBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0yOSAwOTowOToxNCBS
RVBFQVQgQ09VTlQ6IDE5ICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSB5dXlhbmcvY2Mt
djQtb24tMy4xNi1yYzIKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDljMjU5ZDZhNDZlNzU0ZWE4ZmI0
MmJjZjY4ODI1NWZmYTJjOGMwNDggMWE3OTlmNWM5ZGJiZDQ3ZDUwM2FmMWUwY2VkZjlkMjUy
Y2NhMmQ2ZCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5YzI1OWQ2Li4uIE1lcmdl
ICd5dXlhbmcvY2MtdjQtb24tMy4xNi1yYzInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjI2
MTcKSEVBRCBpcyBub3cgYXQgZTI0NDdjNS4uLiBNZXJnZSAnY3J5cHRvZGV2L21hc3Rlcicg
aW50byBkZXZlbC1ob3VybHktMjAxNDA2MjcxMwpCaXNlY3Rpbmc6IDUgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClsxYTQzZThhMzc3ZjRh
ZGM1YzlhNDEyZGUxYTU3YWI0NTNmODMxM2Q0XSBXb3JrbG9hZCBDb25zb2xpZGF0aW9uOiBD
b25zb2xpZGF0aW5nIHdvcmtsb2FkIHRvIGEgc3Vic2V0IG9mIENQVXMgaWYgcG9zc2libGUK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDYyNjE3OjFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdh
YjQ1M2Y4MzEzZDQ6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0wOTowOToxNyAxYTQzZThh
Mzc3ZjRhZGM1YzlhNDEyZGUxYTU3YWI0NTNmODMxM2Q0IGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MjYxODA4LTFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEz
ZDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MjYxODA4LzFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFh
NTdhYjQ1M2Y4MzEzZDQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MjYxODA4LzFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQvdm1s
aW51ei0zLjE2LjAtcmMyLTAwMDA1LWcxYTQzZThhCgoyMDE0LTA2LTI5LTA5OjEzOjE4IGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjI4MzA3
NV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4yODQ2MjJdIHNt
cGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDkwNDMuOTkgQm9nb01J
UFMpClsgICAgMC4yOTA0NDhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQpbICAgIDAuMjkyMTM2XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IC9rYnVpbGQvc3Jj
L3Ntb2tlL2tlcm5lbC9zY2hlZC9jb3JlLmM6NjA2OSBzZF9pbml0KzB4M2U2LzB4NDAwKCkK
WyAgICAwLjMwMDAxMF0gd3Jvbmcgc2RfZmxhZ3MgaW4gdG9wb2xvZ3kgZGVzY3JpcHRpb24K
WyAgICAwLjMwMTcyM10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4zMDkyODZdIENQVTog
MCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAwMDUt
ZzFhNDNlOGEgIzEKWyAgICAwLjMxMDAxMV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFy
ZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDAuMzEyODk5XSAgMDAwMDAwMDAwMDAwMDAwOSBmZmZmODgwMDEyMDg3ZDMwIGZmZmZmZmZm
ODIyZWM3MjMgZmZmZjg4MDAxMjA4N2Q3OApbICAgIDAuMzE2MTY5XSAgZmZmZjg4MDAxMjA4
N2Q2OCBmZmZmZmZmZjgxMGNhMGQ3IGZmZmZmZmZmODJkOTAwMzggMDAwMDAwMDAwMDAwODAw
MApbICAgIDAuMzMyMDU2XSAgMDAwMDAwMDAwMDAwMDAwMSBmZmZmODgwMDEyMWI4MDAwIDAw
MDAwMDAwMDAwMDAwMDEgZmZmZjg4MDAxMjA4N2RjOApbICAgIDAuMzM1Mzc3XSBDYWxsIFRy
YWNlOgpbICAgIDAuMzM2NTI3XSAgWzxmZmZmZmZmZjgyMmVjNzIzPl0gZHVtcF9zdGFjaysw
eGMxLzB4MTExClsgICAgMC4zMzgyNjldICBbPGZmZmZmZmZmODEwY2EwZDc+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweGM3LzB4MTAwClsgICAgMC4zNDAwMjNdICBbPGZmZmZmZmZmODEw
Y2ExZjc+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDU3LzB4NzAKWyAgICAwLjM0MTkxM10gIFs8
ZmZmZmZmZmY4MTdjM2ViND5dID8gX19iaXRtYXBfd2VpZ2h0KzB4ZTQvMHgxMTAKWyAgICAw
LjM0Mzc4OV0gIFs8ZmZmZmZmZmY4MTEyNjhkNj5dIHNkX2luaXQrMHgzZTYvMHg0MDAKWyAg
ICAwLjM0NTQ5M10gIFs8ZmZmZmZmZmY4MTEzNzg1MT5dIGJ1aWxkX3NjaGVkX2RvbWFpbisw
eDMxLzB4MjMwClsgICAgMC4zNDc0MjldICBbPGZmZmZmZmZmODExMzg2OTY+XSBidWlsZF9z
Y2hlZF9kb21haW5zKzB4YzQ2LzB4MTc3MApbICAgIDAuMzUwMDQxXSAgWzxmZmZmZmZmZjgz
ODA3ODU4Pl0gc2NoZWRfaW5pdF9zbXArMHgxMTgvMHgzYjAKWyAgICAwLjM1MTg5MF0gIFs8
ZmZmZmZmZmY4MzdkZWM0Yz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4Y2QvMHgzMWEKWyAg
ICAwLjM1NDAxNl0gIFs8ZmZmZmZmZmY4MjJjNDZlMD5dID8gcmVzdF9pbml0KzB4MTIwLzB4
MTIwClsgICAgMC4zNTU3NzhdICBbPGZmZmZmZmZmODIyYzQ2ZjE+XSBrZXJuZWxfaW5pdCsw
eDExLzB4MjMwClsgICAgMC4zNTc1MzFdICBbPGZmZmZmZmZmODIzMGE5N2M+XSByZXRfZnJv
bV9mb3JrKzB4N2MvMHhiMApbICAgIDAuMzU5NDU0XSAgWzxmZmZmZmZmZjgyMmM0NmUwPl0g
PyByZXN0X2luaXQrMHgxMjAvMHgxMjAKWyAgICAwLjM2MDA3M10gLS0tWyBlbmQgdHJhY2Ug
OWEyMGI2ZjRlYzJhOTQ5YSBdLS0tClsgICAgMC4zOTMwMjFdIGdjb3Y6IHZlcnNpb24gbWFn
aWM6IDB4MzQzMDM4MmEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
OC8xYTQzZThhMzc3ZjRhZGM1YzlhNDEyZGUxYTU3YWI0NTNmODMxM2Q0L2RtZXNnLXF1YW50
YWwtbGtwLW5leDA0LTEwNzoyMDE0MDYyOTA5MTQ0NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgv
MWE0M2U4YTM3N2Y0YWRjNWM5YTQxMmRlMWE1N2FiNDUzZjgzMTNkNC9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNC0xNDY6MjAxNDA2MjkwOTE0NDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzFh
NDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQvZG1lc2ctcXVhbnRhbC1s
a3AtbmV4MDQtMTgyOjIwMTQwNjI5MDkxNDM3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC8xYTQz
ZThhMzc3ZjRhZGM1YzlhNDEyZGUxYTU3YWI0NTNmODMxM2Q0L2RtZXNnLXF1YW50YWwtbGtw
LW5leDA0LTE4NzoyMDE0MDYyOTA5MTQ0Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2
MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvMWE0M2U4
YTM3N2Y0YWRjNWM5YTQxMmRlMWE1N2FiNDUzZjgzMTNkNC9kbWVzZy1xdWFudGFsLWxrcC1u
ZXgwNC02NToyMDE0MDYyOTA5MTQ0NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvMWE0M2U4YTM3
N2Y0YWRjNWM5YTQxMmRlMWE1N2FiNDUzZjgzMTNkNC9kbWVzZy1xdWFudGFsLWxrcC13c3gw
MS0xNTE6MjAxNDA2MjkwOTE0NDM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzFhNDNlOGEzNzdm
NGFkYzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEt
NTM6MjAxNDA2MjkwOTE0NDE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzFhNDNlOGEzNzdmNGFk
YzVjOWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtNzA6
MjAxNDA2MjkwOTE0Mzc6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzFhNDNlOGEzNzdmNGFkYzVj
OWE0MTJkZTFhNTdhYjQ1M2Y4MzEzZDQvZG1lc2cteW9jdG8tbGtwLW5leDA0LTEwMToyMDE0
MDYyOTA5MTQ0Mjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvMWE0M2U4YTM3N2Y0YWRjNWM5YTQx
MmRlMWE1N2FiNDUzZjgzMTNkNC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTA2OjIwMTQwNjI5
MDkxNDQ1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC8xYTQzZThhMzc3ZjRhZGM1YzlhNDEyZGUx
YTU3YWI0NTNmODMxM2Q0L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNDg6MjAxNDA2MjkwOTE0
NDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzFhNDNlOGEzNzdmNGFkYzVjOWE0MTJkZTFhNTdh
YjQ1M2Y4MzEzZDQvZG1lc2cteW9jdG8tbGtwLW5leDA0LTgyOjIwMTQwNjI5MDkxNDQ1Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjI2MTgwOC8xYTQzZThhMzc3ZjRhZGM1YzlhNDEyZGUxYTU3YWI0NTNm
ODMxM2Q0L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC04MzoyMDE0MDYyOTA5MTQ0Njp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDYyNjE4MDgvMWE0M2U4YTM3N2Y0YWRjNWM5YTQxMmRlMWE1N2FiNDUzZjgzMTNk
NC9kbWVzZy15b2N0by1sa3AtbmV4MDQtOToyMDE0MDYyOTA5MTQ0Mjp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjI2MTgwODo6CjA6MTQ6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDYtMjkgMDk6MTc6NDkgUkVQRUFUIENPVU5UOiAxOSAgIyAvYy9i
b290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAy
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls3
ZGVlODQxMTQ3YTk3MmU4MDlkZmNkNzVmNjM4ZDcxNDVkZDhlNzU2XSBzY2hlZDogUHJlY2lz
ZSBhY2N1bXVsYXRlZCB0aW1lIGFuZCBhY291bnQgcnVubmFibGUgbnVtYmVyIGluIHVwZGF0
ZV9lbnRpdHlfcnVubmFibGVfYXZnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjI2MTc6N2RlZTg0
MTE0N2E5NzJlODA5ZGZjZDc1ZjYzOGQ3MTQ1ZGQ4ZTc1NjpiaXNlY3QtbGludXgwCgoyMDE0
LTA2LTI5LTA5OjE3OjQ5IDdkZWU4NDExNDdhOTcyZTgwOWRmY2Q3NWY2MzhkNzE0NWRkOGU3
NTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgtN2RlZTg0MTE0N2E5NzJl
ODA5ZGZjZDc1ZjYzOGQ3MTQ1ZGQ4ZTc1NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvN2RlZTg0MTE0N2E5NzJlODA5ZGZj
ZDc1ZjYzOGQ3MTQ1ZGQ4ZTc1Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgtN2Rl
ZTg0MTE0N2E5NzJlODA5ZGZjZDc1ZjYzOGQ3MTQ1ZGQ4ZTc1Ngp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLXNtb2tlL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTdkZWU4NDExNDdhOTcyZTgwOWRmY2Q3
NWY2MzhkNzE0NWRkOGU3NTYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MjYxODA4LzdkZWU4NDExNDdhOTcyZTgwOWRmY2Q3NWY2MzhkNzE0NWRkOGU3NTYv
dm1saW51ei0zLjE2LjAtcmMyLTAwMDAyLWc3ZGVlODQxCgoyMDE0LTA2LTI5LTA5OjIzOjUw
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4JMTQJMTkgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCls5ODFmYTg3Nzg5NThlNzAxNzBhZDJlNzU3YmM3NWY1ZTNjNjg4NjY1XSBEZWZpbmUg
U0RfV09SS0xPQURfQ09OU09MSURBVElPTiBhbmQgYXR0YWNoIHRvIHNjaGVkX2RvbWFpbgpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDYyNjE3Ojk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1
ZjVlM2M2ODg2NjU6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0wOToyOTo1MCA5ODFmYTg3
Nzg5NThlNzAxNzBhZDJlNzU3YmM3NWY1ZTNjNjg4NjY1IGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MjYxODA4LTk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2
NjUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MjYxODA4Lzk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdi
Yzc1ZjVlM2M2ODg2NjUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MjYxODA4Lzk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUvdm1s
aW51ei0zLjE2LjAtcmMyLTAwMDA0LWc5ODFmYTg3CgoyMDE0LTA2LTI5LTA5OjMzOjUwIGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAw
LjE0MjE4NV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4xNDMz
NTddIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDEwNzc0LjAy
IEJvZ29NSVBTKQpbICAgIDAuMTQ1NTQ1XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0t
LS0tLS0tLS0KWyAgICAwLjE0Njc4M10gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAva2J1
aWxkL3NyYy9zbW9rZS9rZXJuZWwvc2NoZWQvY29yZS5jOjYwNjkgc2RfaW5pdCsweDNlNi8w
eDQwMCgpClsgICAgMC4xNDkxMDVdIHdyb25nIHNkX2ZsYWdzIGluIHRvcG9sb2d5IGRlc2Ny
aXB0aW9uClsgICAgMC4xNTAwMDhdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMTUxMDU1
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMy
LTAwMDA0LWc5ODFmYTg3ICMxClsgICAgMC4xNTMxMDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUg
U3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgICAwLjE1NTIyNV0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAxMjA4N2QzMCBm
ZmZmZmZmZjgyMmVjNzIzIGZmZmY4ODAwMTIwODdkNzgKWyAgICAwLjE1NzY2NV0gIGZmZmY4
ODAwMTIwODdkNjggZmZmZmZmZmY4MTBjYTBkNyBmZmZmZmZmZjgyZDkwMDM4IDAwMDAwMDAw
MDAwMDgwMDAKWyAgICAwLjE2MDQ5NV0gIDAwMDAwMDAwMDAwMDAwMDEgZmZmZjg4MDAxMjFi
ODAwMCAwMDAwMDAwMDAwMDAwMDAxIGZmZmY4ODAwMTIwODdkYzgKWyAgICAwLjE2MjkyMV0g
Q2FsbCBUcmFjZToKWyAgICAwLjE2Mzc3NF0gIFs8ZmZmZmZmZmY4MjJlYzcyMz5dIGR1bXBf
c3RhY2srMHhjMS8weDExMQpbICAgIDAuMTY1MDg0XSAgWzxmZmZmZmZmZjgxMGNhMGQ3Pl0g
d2Fybl9zbG93cGF0aF9jb21tb24rMHhjNy8weDEwMApbICAgIDAuMTY2NTU4XSAgWzxmZmZm
ZmZmZjgxMGNhMWY3Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsgICAgMC4xNjc5
NDZdICBbPGZmZmZmZmZmODE3YzNlYjQ+XSA/IF9fYml0bWFwX3dlaWdodCsweGU0LzB4MTEw
ClsgICAgMC4xNjkzNThdICBbPGZmZmZmZmZmODExMjY4ZDY+XSBzZF9pbml0KzB4M2U2LzB4
NDAwClsgICAgMC4xNzAwMTVdICBbPGZmZmZmZmZmODExMzc4NTE+XSBidWlsZF9zY2hlZF9k
b21haW4rMHgzMS8weDIzMApbICAgIDAuMTcxNDM3XSAgWzxmZmZmZmZmZjgxMTM4Njk2Pl0g
YnVpbGRfc2NoZWRfZG9tYWlucysweGM0Ni8weDE3NzAKWyAgICAwLjE3MjkwNl0gIFs8ZmZm
ZmZmZmY4MzgwNzg1OD5dIHNjaGVkX2luaXRfc21wKzB4MTE4LzB4M2IwClsgICAgMC4xNzQy
OTNdICBbPGZmZmZmZmZmODM3ZGVjNGM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGNkLzB4
MzFhClsgICAgMC4xNzU3NjNdICBbPGZmZmZmZmZmODIyYzQ2ZTA+XSA/IHJlc3RfaW5pdCsw
eDEyMC8weDEyMApbICAgIDAuMTc3MDkyXSAgWzxmZmZmZmZmZjgyMmM0NmYxPl0ga2VybmVs
X2luaXQrMHgxMS8weDIzMApbICAgIDAuMTc4NDIwXSAgWzxmZmZmZmZmZjgyMzBhOTdjPl0g
cmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjE4MDAxNF0gIFs8ZmZmZmZmZmY4MjJj
NDZlMD5dID8gcmVzdF9pbml0KzB4MTIwLzB4MTIwClsgICAgMC4xODEzNjddIC0tLVsgZW5k
IHRyYWNlIGNmNjA1YTYzMDhkNmEzMjEgXS0tLQpbICAgIDAuMTkzMjIwXSBnY292OiB2ZXJz
aW9uIG1hZ2ljOiAweDM0MzAzODJhCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYyNjE4MDgvOTgxZmE4Nzc4OTU4ZTcwMTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9kbWVz
Zy1xdWFudGFsLWl2YjQxLTEwNDoyMDE0MDYyOTA5MzQ1ODp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4
MDgvOTgxZmE4Nzc4OTU4ZTcwMTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9kbWVzZy1xdWFu
dGFsLWxrcC1uZXgwNC0xMDE6MjAxNDA2MjkwOTM1MDg6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
Lzk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUvZG1lc2ctcXVhbnRh
bC1sa3AtbmV4MDQtODM6MjAxNDA2MjkwOTM1MDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4Lzk4
MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUvZG1lc2ctcXVhbnRhbC1s
a3Atd3N4MDEtMTA0OjIwMTQwNjI5MDkzNTAxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85ODFm
YTg3Nzg5NThlNzAxNzBhZDJlNzU3YmM3NWY1ZTNjNjg4NjY1L2RtZXNnLXF1YW50YWwtbGtw
LXdzeDAxLTE0NDoyMDE0MDYyOTA5MzUwMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2
MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOTgxZmE4
Nzc4OTU4ZTcwMTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9kbWVzZy1xdWFudGFsLWxrcC13
c3gwMS0yMDQ6MjAxNDA2MjkwOTM1MDM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4
MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4Lzk4MWZhODc3
ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUvZG1lc2ctcXVhbnRhbC1sa3Atd3N4
MDEtODoyMDE0MDYyOTA5MzUwODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOTgxZmE4Nzc4OTU4
ZTcwMTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9kbWVzZy1xdWFudGFsLWxrcC13c3gwMi01
NzoyMDE0MDYyOTA5MzUwMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOTgxZmE4Nzc4OTU4ZTcw
MTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9kbWVzZy15b2N0by1pdmI0MS0yNDoyMDE0MDYy
OTA5MzUwMTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOTgxZmE4Nzc4OTU4ZTcwMTcwYWQyZTc1
N2JjNzVmNWUzYzY4ODY2NS9kbWVzZy15b2N0by1pdmI0MS01MToyMDE0MDYyOTA5MzUwMzp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYyNjE4MDgvOTgxZmE4Nzc4OTU4ZTcwMTcwYWQyZTc1N2JjNzVmNWUz
YzY4ODY2NS9kbWVzZy15b2N0by1pdmI0MS02MjoyMDE0MDYyOTA5MzUwNDp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDgvOTgxZmE4Nzc4OTU4ZTcwMTcwYWQyZTc1N2JjNzVmNWUzYzY4ODY2NS9k
bWVzZy15b2N0by1sa3AtbmV4MDQtMTMxOjIwMTQwNjI5MDkzNTA4Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjI2MTgwOC85ODFmYTg3Nzg5NThlNzAxNzBhZDJlNzU3YmM3NWY1ZTNjNjg4NjY1L2RtZXNn
LXlvY3RvLWxrcC1uZXgwNC0xNToyMDE0MDYyOTA5MzUxMjp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjI2MTgwODo6CjA6MTM6MTIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sx
OzM1bTIwMTQtMDYtMjkgMDk6NDE6MjEgUkVQRUFUIENPVU5UOiAxOSAgIyAvYy9ib290LWJp
c2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbM2IzZmI2
MTk3NjUwOWVmOGY3YzBjMDVhZGJhMGI2MWNlYTZiMDVkYl0gSG93IENQVSBDb25DdXJyZW5j
eSAoQ0MpIGFjY3J1ZXMgd2l0aCBydW5xdWV1ZSBjaGFuZ2UgYW5kIHRpbWUKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA2MjYxNzozYjNmYjYxOTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2VhNmIw
NWRiOmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjktMDk6NDE6MjIgM2IzZmI2MTk3NjUwOWVm
OGY3YzBjMDVhZGJhMGI2MWNlYTZiMDVkYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjI2MTgwOC0zYjNmYjYxOTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2VhNmIwNWRiCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
OC8zYjNmYjYxOTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2VhNmIwNWRiCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjI2MTgwOC0zYjNmYjYxOTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2Vh
NmIwNWRiCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgw
OC8zYjNmYjYxOTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2VhNmIwNWRiL3ZtbGludXotMy4x
Ni4wLXJjMi0wMDAwMy1nM2IzZmI2MQoKMjAxNC0wNi0yOS0wOTo0NDoyMiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLgkyCTE3CTE5IFNVQ0NFU1MKCjk4MWZhODc3ODk1
OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQK
Y29tbWl0IDk4MWZhODc3ODk1OGU3MDE3MGFkMmU3NTdiYzc1ZjVlM2M2ODg2NjUKQXV0aG9y
OiBZdXlhbmcgRHUgPHl1eWFuZy5kdUBpbnRlbC5jb20+CkRhdGU6ICAgV2VkIEp1biAyNSAw
Mzo1NzoxOCAyMDE0ICswODAwCgogICAgRGVmaW5lIFNEX1dPUktMT0FEX0NPTlNPTElEQVRJ
T04gYW5kIGF0dGFjaCB0byBzY2hlZF9kb21haW4KICAgIAogICAgV29ya2xvYWQgQ29uc29s
aWRhdGlvbiBpcyBjb21wbGV0ZWx5IENQVSB0b3BvbG9neSBhbmQgcG9saWN5IGRyaXZlbi4g
VG8gZG8gc28sCiAgICB3ZSBkZWZpbmUgU0RfV09SS0xPQURfQ09OU09MSURBVElPTiwgYW5k
IGFkZCBzb21lIGZpZWxkcyBpbiBzY2hlZF9kb21haW4gc3RydWN0OgogICAgCiAgICAxKSB0
b3RhbF9ncm91cHMgaXMgdGhlIGdyb3VwIG51bWJlciBpbiB0b3RhbCBpbiB0aGlzIGRvbWFp
bgogICAgMikgZ3JvdXBfbnVtYmVyIGlzIHRoaXMgQ1BVJ3MgZ3JvdXAgc2VxdWVuY2UgbnVt
YmVyCiAgICAzKSBjb25zb2xpZGF0aW5nX2NvZWZmIGlzIHRoZSBjb2VmZmljaWVudCBmb3Ig
Y29uc29saWRhdGluZyBDUFVzLCBhbmQgaXMgY2hhbmdlYWJsZQogICAgICAgdmlhIHN5c2N0
bCB0b29sIHRvIG1ha2UgY29uc29saWRhdGlvbiBtb3JlIGFnZ3Jlc3NpdmUgb3IgbGVzcwog
ICAgNCkgZmlyc3RfZ3JvdXAgaXMgdGhlIHBvaW50ZXIgdG8gdGhpcyBkb21haW4ncyBmaXJz
dCBncm91cCBvcmRlcmVkIGJ5IENQVSBudW1iZXIKICAgIAogICAgVGhpcyBwYXRjaHNldCBl
bmFibGVzIFNEX1dPUktMT0FEX0NPTlNPTElEQVRJT04gaW4gTUMgZG9tYWluIGJ5IGRlZmF1
bHQuIEJ1dCB3ZSBuZWVkCiAgICB0byBjb21lIHVwIHdpdGggYSBiZXR0ZXIgd2F5IHRvIGRl
dGVybWluZSBvbiB3aGljaCBhcmNoaXRlY3R1cmUgdGhpcyBmbGFnIHNob3VsZCBiZQogICAg
ZW5hYmxlZCBvciBub3QuIFRoYW5rcyB0byBQZXRlclogYW5kIERpZXRtYXIgZm9yIHBvaW50
aW5nIHRoaXMgb3V0IGFuZCBoZWxwIG1lCiAgICBmaW5hbGx5IHVuZGVyc3RhbmQgaXQuCiAg
ICAKICAgIFNpZ25lZC1vZmYtYnk6IFl1eWFuZyBEdSA8eXV5YW5nLmR1QGludGVsLmNvbT4K
CjowNDAwMDAgMDQwMDAwIDc5OWI1NTEwZDkwMzZjYzNjZWQyNTI2MDNkODBiZTA0ODg0Y2Iz
ZGUgZDUwNmNiYTUzMzQ3NThiNmU1NWYzMDc5ZTgxM2EzOTViNWQwNzQ0NyBNCWluY2x1ZGUK
OjA0MDAwMCAwNDAwMDAgYTBhYjQ2YjEwMTVlNjE4YmY1MjIzZDg0ZDQ1YmZkNzczNTVlNjc4
OSBiZmMxMjU3YTc3NzZiYWUwMDQyMTk2MzQxOWRhYjIyZThmNTJhZTBjIE0Ja2VybmVsCmJp
c2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBhdCAzYjNmYjYxLi4uIEhvdyBDUFUgQ29u
Q3VycmVuY3kgKENDKSBhY2NydWVzIHdpdGggcnVucXVldWUgY2hhbmdlIGFuZCB0aW1lCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjI2MTgwOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYxNzozYjNmYjYx
OTc2NTA5ZWY4ZjdjMGMwNWFkYmEwYjYxY2VhNmIwNWRiOmJpc2VjdC1saW51eDAKCjIwMTQt
MDYtMjktMDk6NTI6NTUgM2IzZmI2MTk3NjUwOWVmOGY3YzBjMDVhZGJhMGI2MWNlYTZiMDVk
YiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzNiM2Zi
NjE5NzY1MDllZjhmN2MwYzA1YWRiYTBiNjFjZWE2YjA1ZGIvdm1saW51ei0zLjE2LjAtcmMy
LTAwMDAzLWczYjNmYjYxCgoyMDE0LTA2LTI5LTA5OjUyOjU1IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uCTI2CTQyCTU3IFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDNiM2ZiNjEuLi4gSG93IENQVSBDb25DdXJyZW5jeSAoQ0MpIGFjY3J1ZXMgd2l0aCBy
dW5xdWV1ZSBjaGFuZ2UgYW5kIHRpbWUKSEVBRCBpcyBub3cgYXQgOWMzM2JmMS4uLiAwZGF5
IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA2MjYxNycKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyNjE3OjljMzNiZjFlNTlkMjZkYWQ4
ZGM0NWU0MzhjYmRjMjg3ODM1ODliMTE6YmlzZWN0LWxpbnV4MAogVEVTVCBGQUlMVVJFClsg
ICAgMC4zNDI2MzJdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDAu
MzQzOTg5XSBzbXBib290OiBUb3RhbCBvZiAyIHByb2Nlc3NvcnMgYWN0aXZhdGVkICgxMDc3
NC4wMiBCb2dvTUlQUykKWyAgICAwLjM1NTMyMV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBd
LS0tLS0tLS0tLS0tClsgICAgMC4zNTY4NDddIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQg
L2tidWlsZC9zcmMvc21va2Uva2VybmVsL3NjaGVkL2NvcmUuYzo2MDc4IHNkX2luaXQrMHgz
ZTYvMHg0MDAoKQpbICAgIDAuMzU5NTYxXSB3cm9uZyBzZF9mbGFncyBpbiB0b3BvbG9neSBk
ZXNjcmlwdGlvbgpbICAgIDAuMzYwMDE5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjM2
Mzg3NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4w
LXJjMi13bC0wMzQzMi1nOWMzM2JmMSAjMTkxClsgICAgMC4zNjc3OTddIEhhcmR3YXJlIG5h
bWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hz
IDAxLzAxLzIwMTEKWyAgICAwLjM3MDAxOV0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAx
MjA4N2QzMCBmZmZmZmZmZjgyMmZiYmZiIGZmZmY4ODAwMTIwODdkNzgKWyAgICAwLjM4MTcw
MV0gIGZmZmY4ODAwMTIwODdkNjggZmZmZmZmZmY4MTBkMzg2NyBmZmZmZmZmZjgyZGEyMzE4
IDAwMDAwMDAwMDAwMDgwMDAKWyAgICAwLjM5MDAxNF0gIDAwMDAwMDAwMDAwMDAwMDEgZmZm
Zjg4MDAxMjFiODAwMCAwMDAwMDAwMDAwMDAwMDAxIGZmZmY4ODAwMTIwODdkYzgKWyAgICAw
LjM5NjAwN10gQ2FsbCBUcmFjZToKWyAgICAwLjM5OTQyNF0gIFs8ZmZmZmZmZmY4MjJmYmJm
Yj5dIGR1bXBfc3RhY2srMHhjMS8weDExMQpbICAgIDAuNDAwMDM1XSAgWzxmZmZmZmZmZjgx
MGQzODY3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhjNy8weDEwMApbICAgIDAuNDAxNzg4
XSAgWzxmZmZmZmZmZjgxMGQzOTg3Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsg
ICAgMC40MDM5NDhdICBbPGZmZmZmZmZmODE3ZDFiNDQ+XSA/IF9fYml0bWFwX3dlaWdodCsw
eGU0LzB4MTEwClsgICAgMC40MTAwMjJdICBbPGZmZmZmZmZmODExMzAwYzY+XSBzZF9pbml0
KzB4M2U2LzB4NDAwClsgICAgMC40MjAwMzddICBbPGZmZmZmZmZmODExNDEwNTE+XSBidWls
ZF9zY2hlZF9kb21haW4rMHgzMS8weDIzMApbICAgIDAuNDIxNjU0XSAgWzxmZmZmZmZmZjgx
MTQxZTk2Pl0gYnVpbGRfc2NoZWRfZG9tYWlucysweGM0Ni8weDE3NzAKWyAgICAwLjQyNjk0
NV0gIFs8ZmZmZmZmZmY4MzgxYjk2MD5dIHNjaGVkX2luaXRfc21wKzB4MTE4LzB4M2IwClsg
ICAgMC40MzAwNDBdICBbPGZmZmZmZmZmODM3ZjJjNGM+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweGNkLzB4MzFhClsgICAgMC40MzE1NzJdICBbPGZmZmZmZmZmODIyZDNhMDA+XSA/IHJl
c3RfaW5pdCsweDEyMC8weDEyMApbICAgIDAuNDM1MTg2XSAgWzxmZmZmZmZmZjgyMmQzYTEx
Pl0ga2VybmVsX2luaXQrMHgxMS8weDIzMApbICAgIDAuNDM2NTczXSAgWzxmZmZmZmZmZjgy
MzE5ZTNjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjQ0MDAyOF0gIFs8ZmZm
ZmZmZmY4MjJkM2EwMD5dID8gcmVzdF9pbml0KzB4MTIwLzB4MTIwClsgICAgMC40NDY5NDdd
IC0tLVsgZW5kIHRyYWNlIDZkNTVmMmRhZDM0ZDM0OTEgXS0tLQpbICAgIDAuNDg1MzQyXSBn
Y292OiB2ZXJzaW9uIG1hZ2ljOiAweDM0MzAzODJhCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYyNjE4MDgvOWMzM2JmMWU1OWQyNmRhZDhkYzQ1ZTQzOGNiZGMyODc4MzU4
OWIxMS9kbWVzZy15b2N0by1pdmI0MS04OjIwMTQwNjI5MDgwMjU5Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MjYxODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjI2MTgwOC85YzMzYmYxZTU5ZDI2ZGFkOGRjNDVlNDM4Y2JkYzI4NzgzNTg5YjExL2RtZXNn
LXF1YW50YWwtaXZiNDEtMjQ6MjAxNDA2MjkwODAyNTk6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
LzljMzNiZjFlNTlkMjZkYWQ4ZGM0NWU0MzhjYmRjMjg3ODM1ODliMTEvZG1lc2cteW9jdG8t
aXZiNDEtMTAyOjIwMTQwNjI5MDgwMjU5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYx
ODA4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzMzYmYx
ZTU5ZDI2ZGFkOGRjNDVlNDM4Y2JkYzI4NzgzNTg5YjExL2RtZXNnLXlvY3RvLWl2YjQxLTk6
MjAxNDA2MjkwODAyNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMzNiZjFlNTlkMjZkYWQ4
ZGM0NWU0MzhjYmRjMjg3ODM1ODliMTEvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDI6MjAxNDA2
MjkwODAyNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMzNiZjFlNTlkMjZkYWQ4ZGM0NWU0
MzhjYmRjMjg3ODM1ODliMTEvZG1lc2cteW9jdG8taXZiNDEtODY6MjAxNDA2MjYxODIzMzI6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6My4xNi4wLXJjMi13bC0wMzQzMi1n
OWMzM2JmMToxOTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85
YzMzYmYxZTU5ZDI2ZGFkOGRjNDVlNDM4Y2JkYzI4NzgzNTg5YjExL2RtZXNnLXlvY3RvLWl2
YjQxLTQyOjIwMTQwNjI5MDgwMjU5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC85YzMzYmYxZTU5
ZDI2ZGFkOGRjNDVlNDM4Y2JkYzI4NzgzNTg5YjExL2RtZXNnLXlvY3RvLWl2YjQxLTExNjoy
MDE0MDYyOTA4MDI1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMzM2JmMWU1OWQyNmRhZDhk
YzQ1ZTQzOGNiZGMyODc4MzU4OWIxMS9kbWVzZy15b2N0by1pdmI0MS0xODoyMDE0MDYyOTA4
MDI1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOWMzM2JmMWU1OWQyNmRhZDhkYzQ1ZTQzOGNi
ZGMyODc4MzU4OWIxMS9kbWVzZy15b2N0by1pdmI0MS00NzoyMDE0MDYyNjE4MjEzMDp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwODozLjE2LjAtcmMyLXdsLTAzNDMyLWc5YzMz
YmYxOjE5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMzNi
ZjFlNTlkMjZkYWQ4ZGM0NWU0MzhjYmRjMjg3ODM1ODliMTEvZG1lc2cteW9jdG8taXZiNDEt
Mzc6MjAxNDA2MjkwODAyNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMzNiZjFlNTlkMjZk
YWQ4ZGM0NWU0MzhjYmRjMjg3ODM1ODliMTEvZG1lc2cteW9jdG8taXZiNDEtNDE6MjAxNDA2
MjkwODAyNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzljMzNiZjFlNTlkMjZkYWQ4ZGM0NWU0
MzhjYmRjMjg3ODM1ODliMTEvZG1lc2cteW9jdG8taXZiNDEtNTg6MjAxNDA2MjYxODIzMzI6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDg6My4xNi4wLXJjMi13bC0wMzQzMi1n
OWMzM2JmMToxOTEKMDoxMzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBp
cyBub3cgYXQgOWMzM2JmMSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAx
NDA2MjYxNycKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgOWMzM2JmMS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3Vy
bHktMjAxNDA2MjYxNycKSEVBRCBpcyBub3cgYXQgMjRiNDE0ZC4uLiBNZXJnZSB0YWcgJ3Nw
aS12My4xNi1yYzInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9icm9vbmllL3NwaQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvbGludXM6bWFzdGVyOjI0YjQxNGQ1
YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRhNjEwZWQxNDI6YmlzZWN0LWxpbnV4MAoKMjAxNC0w
Ni0yOS0wOTo1ODozMSAyNGI0MTRkNWE3ZDNlNmE3MTYzNTA0NjRkZmRiNDRkYTYxMGVkMTQy
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTI0YjQxNGQ1YTdkM2U2YTcx
NjM1MDQ2NGRmZGI0NGRhNjEwZWQxNDIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LzI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2
NGRmZGI0NGRhNjEwZWQxNDIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MjYxODA4LTI0YjQx
NGQ1YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRhNjEwZWQxNDIKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1zbW9rZS94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC0yNGI0MTRkNWE3ZDNlNmE3MTYzNTA0NjRk
ZmRiNDRkYTYxMGVkMTQyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjI2MTgwOC8yNGI0MTRkNWE3ZDNlNmE3MTYzNTA0NjRkZmRiNDRkYTYxMGVkMTQyL3Zt
bGludXotMy4xNi4wLXJjMi0wMDM0MS1nMjRiNDE0ZAoKMjAxNC0wNi0yOS0xMDowNTozMSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4JMTEJMjgJNDUJNTcgU1VDQ0VTUwoKCj09PT09
PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAy
NGI0MTRkLi4uIE1lcmdlIHRhZyAnc3BpLXYzLjE2LXJjMicgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Jyb29uaWUvc3BpCkhFQUQgaXMgbm93
IGF0IDk2NDI2MDAuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQw
NjI3CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjI2MTgwOC9uZXh0Om1hc3Rlcjo5NjQyNjAwN2M5MGNkZTIzYzA0MDI4NTZm
M2UwYWVjMGY0Y2MyZTQ4OmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjktMTA6MTA6MzUgOTY0
MjYwMDdjOTBjZGUyM2MwNDAyODU2ZjNlMGFlYzBmNGNjMmU0OCBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjI2MTgwOC05NjQyNjAwN2M5MGNkZTIzYzA0MDI4NTZmM2UwYWVjMGY0
Y2MyZTQ4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjI2MTgwOC85NjQyNjAwN2M5MGNkZTIzYzA0MDI4NTZmM2UwYWVjMGY0Y2MyZTQ4
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjI2MTgwOC05NjQyNjAwN2M5MGNkZTIzYzA0MDI4
NTZmM2UwYWVjMGY0Y2MyZTQ4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtc21va2UveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYyNjE4MDgtOTY0MjYwMDdjOTBjZGUyM2MwNDAyODU2ZjNlMGFlYzBmNGNjMmU0OApr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYyNjE4MDgvOTY0MjYw
MDdjOTBjZGUyM2MwNDAyODU2ZjNlMGFlYzBmNGNjMmU0OC92bWxpbnV6LTMuMTYuMC1yYzIt
bmV4dC0yMDE0MDYyNwoKMjAxNC0wNi0yOS0xMDoxNDozNSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4JMQkxOAkzNQk1Mwk1NyBTVUNDRVNTCgo=

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc2-00004-g981fa87"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc2 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
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
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLUB_CPU_PARTIAL is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
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
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=m
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_MCAST is not set
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_CAN_AT91 is not set
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
# CONFIG_CAN_EMS_PCMCIA is not set
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=m
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
# CONFIG_CAN_CC770 is not set

#
# CAN SPI interfaces
#
CONFIG_CAN_MCP251X=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_GS_USB=m
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=y
CONFIG_SH_IRDA=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_WILINK is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_MPL_DEBUG is not set
CONFIG_MAC80211_MPATH_DEBUG=y
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
CONFIG_MAC80211_MESH_CSA_DEBUG=y
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
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
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_NAND_SH_FLCTL=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
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
# CONFIG_BLK_DEV_SKD is not set
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
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
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
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=m
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=m
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
CONFIG_SCSI_UFSHCD_PLATFORM=m
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_FLASHPOINT=y
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=m
CONFIG_SATA_RCAR=y
CONFIG_SATA_SIL=m
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARASAN_CF=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=m
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=y
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OLDPIIX is not set
CONFIG_PATA_OPTIDMA=m
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=y
# CONFIG_PATA_SCH is not set
CONFIG_PATA_SERVERWORKS=y
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=m
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_SUNGEM_PHY=y
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=y
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=m
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_ALX=m
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_CX_ECAT=y
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=m
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=m
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=m
CONFIG_PCMCIA_PCNET=m
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R8169 is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=m
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=m
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=m
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=m
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_HSO=m
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_IEEE802154_FAKELB is not set
CONFIG_IEEE802154_AT86RF230=m
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_ST_KEYSCAN is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=m
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUN4I is not set
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_PCAP=m
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_OLPC_APSP is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=m

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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=m
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_SERIAL_MEN_Z135=m
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_EFM32 is not set
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
# CONFIG_I2C_SH_MOBILE is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_ATMEL=m
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_CLPS711X=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=m
CONFIG_SPI_IMX=m
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_TI_QSPI=y
# CONFIG_SPI_OMAP_100K is not set
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_SH=m
CONFIG_SPI_SH_HSPI=m
# CONFIG_SPI_SUN4I is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=m
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_XTENSA_XTFPGA=m
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=y
# CONFIG_HSI is not set

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
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHTC1=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=m
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_ACPI_INT3403_THERMAL=m
CONFIG_INTEL_SOC_DTS_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=m
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=m
CONFIG_TEGRA_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
# CONFIG_KEMPLD_WDT is not set
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_MC13XXX=m
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=m
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RTSX_USB is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=m
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_I915_FBDEV is not set
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=m
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=m
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=m
CONFIG_USB_MON=m
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_XHCI_MVEBU=m
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_MAX3421_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_WHCI_HCD=y
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_REALTEK_AUTOPM is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
# CONFIG_USB_MUSB_TUSB6010 is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m
CONFIG_USB_DWC3_EXYNOS=m
CONFIG_USB_DWC3_PCI=m
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=m
CONFIG_USB_DWC2_PLATFORM=y
CONFIG_USB_DWC2_PCI=y

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_KEYSTONE_USB_PHY=m
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_RCAR_GEN2_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=m
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=m
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=m
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
CONFIG_USB_CONFIGFS_ACM=y
# CONFIG_USB_CONFIGFS_OBEX is not set
CONFIG_USB_CONFIGFS_NCM=y
CONFIG_USB_CONFIGFS_ECM=y
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
# CONFIG_USB_CONFIGFS_PHONET is not set
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
CONFIG_USB_CONFIGFS_F_LB_SS=y
# CONFIG_USB_CONFIGFS_F_FS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=m
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_PWM=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=m
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=m
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set
CONFIG_RTC_DRV_MCP795=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=y
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_SH_DMAE_BASE=y
CONFIG_SH_DMAE=m
CONFIG_SUDMAC=m
# CONFIG_RCAR_HPB_DMAE is not set
CONFIG_RCAR_AUDMAC_PP=m
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=m
# CONFIG_USBIP_CORE is not set
# CONFIG_COMEDI is not set
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_RTS5208=m
# CONFIG_RTS5208_DEBUG is not set
CONFIG_TRANZPORT=y
# CONFIG_IDE_PHISON is not set
CONFIG_DX_SEP=y
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=m
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_ACNTPC=y
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=m
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
# CONFIG_SPEAKUP_SYNTH_DECPC is not set
CONFIG_SPEAKUP_SYNTH_DTLK=y
CONFIG_SPEAKUP_SYNTH_KEYPC=m
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
CONFIG_SPEAKUP_SYNTH_DUMMY=m
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_USB_PM is not set
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=m
CONFIG_DGRP=y
CONFIG_FIREWIRE_SERIAL=y
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_MTD_SPINAND_MT29F=y
# CONFIG_MTD_SPINAND_ONDIEECC is not set
CONFIG_XILLYBUS=y
CONFIG_DGNC=y
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACERHDF is not set
CONFIG_ALIENWARE_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=y
CONFIG_DELL_SMO8800=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=y
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=m
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO1_RFKILL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
CONFIG_SH_TIMER_TMU=y
# CONFIG_EM_TIMER_STI is not set
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
CONFIG_EXTCON_GPIO=m
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_CLPS711X=m
CONFIG_PWM_LPSS=y
# CONFIG_PWM_RENESAS_TPU is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

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
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

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
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_HAVE_FENTRY=y
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
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
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
# CONFIG_FONT_10x18 is not set

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--WhfpMioaduB5tiZL--
