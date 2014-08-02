Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaHBFst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 01:48:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:13011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaHBFsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 01:48:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,785,1400050800"; 
   d="log'?scan'208";a="570728904"
Date: Sat, 2 Aug 2014 13:48:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-mtd@lists.infradead.org
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [SBC-GXx] kernel BUG at include/linux/mtd/map.h:148!
Message-ID: <20140802054839.GB11701@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I hit a very old bug and it's 100% reproducible in linux-next.

+------------------------------------------+---------------+
|                                          | next-20140801 |
+------------------------------------------+---------------+
| boot_successes                           | 0             |
| boot_failures                            | 11            |
+------------------------------------------+---------------+
| kernel_BUG_at_include/linux/mtd/map.h    | 11            |
| invalid_opcode                           | 11            |
| EIP_is_at_mtd_do_chip_probe              | 11            |
| Kernel_panic-not_syncing:Fatal_exception | 11            |
| backtrace:do_map_probe                   | 11            |
| backtrace:init_sbc_gxx                   | 11            |
| backtrace:kernel_init_freeable           | 11            |
+------------------------------------------+---------------+

[   11.176775] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[   11.178043] ------------[ cut here ]------------
[   11.178043] ------------[ cut here ]------------
[   11.179055] kernel BUG at include/linux/mtd/map.h:148!
[   11.179055] kernel BUG at include/linux/mtd/map.h:148!
[   11.180013] invalid opcode: 0000 [#1] 
[   11.180013] invalid opcode: 0000 [#1] SMP SMP 

[   11.180013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3-00024-gaf058ab #13
[   11.180013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3-00024-gaf058ab #13
[   11.180013] task: c0040000 ti: c003e000 task.ti: c003e000
[   11.180013] task: c0040000 ti: c003e000 task.ti: c003e000
[   11.180013] EIP: 0060:[<c13053fa>] EFLAGS: 00010246 CPU: 0
[   11.180013] EIP: 0060:[<c13053fa>] EFLAGS: 00010246 CPU: 0
[   11.180013] EIP is at mtd_do_chip_probe+0x1a/0x20
[   11.180013] EIP is at mtd_do_chip_probe+0x1a/0x20
[   11.180013] EAX: 00000000 EBX: c1737fd0 ECX: 00000000 EDX: c003fe84
[   11.180013] EAX: 00000000 EBX: c1737fd0 ECX: 00000000 EDX: c003fe84
[   11.180013] ESI: c16b09a5 EDI: c003fec0 EBP: c003fec4 ESP: c003fe84
[   11.180013] ESI: c16b09a5 EDI: c003fec0 EBP: c003fec4 ESP: c003fe84
[   11.180013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   11.180013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   11.180013] CR0: 80050033 CR2: 00000000 CR3: 01816000 CR4: 000406b0
[   11.180013] CR0: 80050033 CR2: 00000000 CR3: 01816000 CR4: 000406b0
[   11.180013] Stack:
[   11.180013] Stack:
[   11.180013]  00000000
[   11.180013]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000

[   11.180013]  00000000
[   11.180013]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000 c17387e0 c17387e0

[   11.180013]  c003fecc
[   11.180013]  c003fecc c1301c62 c1301c62 c003fee0 c003fee0 c1301bfc c1301bfc 00000000 00000000 c17ce159 c17ce159 000001bf
000001bf c003ff00 c003ff00

[   11.180013] Call Trace:
[   11.180013] Call Trace:
[   11.180013]  [<c1301c62>] cfi_probe+0x12/0x20
[   11.180013]  [<c1301c62>] cfi_probe+0x12/0x20
[   11.180013]  [<c1301bfc>] do_map_probe+0x5c/0x80
[   11.180013]  [<c1301bfc>] do_map_probe+0x5c/0x80
[   11.180013]  [<c17ce159>] ? physmap_init+0x35/0x35
[   11.180013]  [<c17ce159>] ? physmap_init+0x35/0x35
[   11.180013]  [<c17ce241>] init_sbc_gxx+0xe8/0x123
[   11.180013]  [<c17ce241>] init_sbc_gxx+0xe8/0x123
[   11.180013]  [<c179ab44>] do_one_initcall+0xac/0x13a
[   11.180013]  [<c179ab44>] do_one_initcall+0xac/0x13a
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c179a519>] ? repair_env_string+0x12/0x51
[   11.180013]  [<c179a519>] ? repair_env_string+0x12/0x51
[   11.180013]  [<c105f285>] ? parse_args+0x2a5/0x3f0
[   11.180013]  [<c105f285>] ? parse_args+0x2a5/0x3f0
[   11.180013]  [<c179acfa>] kernel_init_freeable+0x128/0x1c2
[   11.180013]  [<c179acfa>] kernel_init_freeable+0x128/0x1c2
[   11.180013]  [<c179a507>] ? do_early_param+0x7a/0x7a
[   11.180013]  [<c179a507>] ? do_early_param+0x7a/0x7a
[   11.180013]  [<c14b5050>] kernel_init+0x10/0x150
[   11.180013]  [<c14b5050>] kernel_init+0x10/0x150
[   11.180013]  [<c14c22bb>] ret_from_kernel_thread+0x1b/0x30                                                  
[   11.180013]  [<c14c22bb>] ret_from_kernel_thread+0x1b/0x30
[   11.180013]  [<c14b5040>] ? rest_init+0xd0/0xd0
[   11.180013]  [<c14b5040>] ? rest_init+0xd0/0xd0
[   11.180013] Code:
[   11.180013] Code: 5d 5d c3 c3 66 66 90 90 66 66 90 90 66 66 90 90 66 66 90 90 66 66 90 90 66 66 90 90 66 66 90 90 90 90 55 55
89 89 e5 e5 57 57 83 83 ec ec 3c 3c e8 e8 04 04 d5 d5 1b 1b 00 00 31 31 c0 c0 b9 b9 0f 0f 00 00 00 00 00 00 8d 8d 55 55 c0 c0 89
89 d7 d7 f3 f3 ab ab <0f> <0f> 0b 0b 66 66 90 90 66 66 90 90 55 55 89 89 e5 e5 e8 e8 e8 e8 d4 d4 1b 1b 00 00 ba ba 10 10 82 82 73
73 c1 c1 e8 e8 ce ce

[   11.180013] EIP: [<c13053fa>]
[   11.180013] EIP: [<c13053fa>] mtd_do_chip_probe+0x1a/0x20mtd_do_chip_probe+0x1a/0x20 SS:ESP 0068:c003fe84
 SS:ESP 0068:c003fe84
[   11.220762] ---[ end trace 6b2355da72108a70 ]---
[   11.220762] ---[ end trace 6b2355da72108a70 ]---
[   11.221768] Kernel panic - not syncing: Fatal exception
[   11.221768] Kernel panic - not syncing: Fatal exception
[   11.222981] Rebooting in 10 seconds..
[   11.222981] Rebooting in 10 seconds..


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

--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-29:20140802122123:i386-randconfig-x1-08020829:3.11.0-rc3-00024-gaf058ab:13"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc3-00024-gaf058ab (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #13 SMP Sat Aug 2 12:22:12 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x01c85000, 0x01c85fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x01c86000, 0x01c86fff] PGTABLE
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
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @d2393000 s34624 r0 d14528 u49=
152
[    0.000000] pcpu-alloc: s34624 r0 d14528 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12395fc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-x1-08020829/next:ma=
ster:af058ab04d3d11383e5159132fc78a3700be3af5:bisect-linux6/.vmlinuz-af058a=
b04d3d11383e5159132fc78a3700be3af5-20140802122219-16-kbuild branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-x1-08020829/af058ab04d3d11383e51=
59132fc78a3700be3af5/vmlinuz-3.11.0-rc3-00024-gaf058ab drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 284900K/327280K available (4876K kernel code, 775K r=
wdata, 2124K rodata, 472K init, 4484K bss, 42380K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc179a000 - 0xc1810000   ( 472 kB)
[    0.000000]       .data : 0xc14c34aa - 0xc1799e40   (2906 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14c34aa   (4877 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0094000 soft=3Dc0096000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc3-00024-gaf058ab (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #13 SMP Sat Aug 2 12:22:12 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x01c85000, 0x01c85fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x01c86000, 0x01c86fff] PGTABLE
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
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @d2393000 s34624 r0 d14528 u49=
152
[    0.000000] pcpu-alloc: s34624 r0 d14528 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12395fc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-x1-08020829/next:ma=
ster:af058ab04d3d11383e5159132fc78a3700be3af5:bisect-linux6/.vmlinuz-af058a=
b04d3d11383e5159132fc78a3700be3af5-20140802122219-16-kbuild branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-x1-08020829/af058ab04d3d11383e51=
59132fc78a3700be3af5/vmlinuz-3.11.0-rc3-00024-gaf058ab drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 284900K/327280K available (4876K kernel code, 775K r=
wdata, 2124K rodata, 472K init, 4484K bss, 42380K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc179a000 - 0xc1810000   ( 472 kB)
[    0.000000]       .data : 0xc14c34aa - 0xc1799e40   (2906 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14c34aa   (4877 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.66 Bogo=
MIPS (lpj=3D26933320)
5386.66 BogoMIPS (lpj=3D26933320)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] Security Framework initialized
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Mount-cache hash table entries: 512
[    0.020380] Initializing cgroup subsys devices
[    0.020380] Initializing cgroup subsys devices
[    0.021721] Initializing cgroup subsys perf_event
[    0.021721] Initializing cgroup subsys perf_event
[    0.023231] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023231] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023231] tlb_flushall_shift: -1
[    0.023231] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023231] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023231] tlb_flushall_shift: -1
[    0.028155] Freeing SMP alternatives memory: 12K (c1810000 - c1813000)
[    0.028155] Freeing SMP alternatives memory: 12K (c1810000 - c1813000)
[    0.033540] ACPI: Core revision 20130517
[    0.033540] ACPI: Core revision 20130517
[    0.036440] ACPI:=20
[    0.036440] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.038274] Getting VERSION: 1050014
[    0.038274] Getting VERSION: 1050014
[    0.040019] Getting VERSION: 1050014
[    0.040019] Getting VERSION: 1050014
[    0.041109] Getting ID: 0
[    0.041109] Getting ID: 0
[    0.041923] Getting ID: f000000
[    0.041923] Getting ID: f000000
[    0.042886] Getting LVT0: 8700
[    0.042886] Getting LVT0: 8700
[    0.043805] Getting LVT1: 8400
[    0.043805] Getting LVT1: 8400
[    0.044730] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.044730] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.046462] enabled ExtINT on CPU#0
[    0.046462] enabled ExtINT on CPU#0
[    0.049020] ENABLING IO-APIC IRQs
[    0.049020] ENABLING IO-APIC IRQs
[    0.050013] init IO_APIC IRQs
[    0.050013] init IO_APIC IRQs
[    0.050914]  apic 0 pin 0 not connected
[    0.050914]  apic 0 pin 0 not connected
[    0.052076] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052076] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.054456] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.054456] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.056823] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056823] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.059203] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.059203] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.060030] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.060030] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.062388] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.062388] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.064763] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.064763] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.067127] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.067127] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.070031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072399] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.072399] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.074813] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.074813] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.077221] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.077221] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.080031] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080031] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.082439] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.082439] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.084865] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.084865] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.087267]  apic 0 pin 16 not connected
[    0.087267]  apic 0 pin 16 not connected
[    0.088436]  apic 0 pin 17 not connected
[    0.088436]  apic 0 pin 17 not connected
[    0.090005]  apic 0 pin 18 not connected
[    0.090005]  apic 0 pin 18 not connected
[    0.091174]  apic 0 pin 19 not connected
[    0.091174]  apic 0 pin 19 not connected
[    0.092344]  apic 0 pin 20 not connected
[    0.092344]  apic 0 pin 20 not connected
[    0.093504]  apic 0 pin 21 not connected
[    0.093504]  apic 0 pin 21 not connected
[    0.094671]  apic 0 pin 22 not connected
[    0.094671]  apic 0 pin 22 not connected
[    0.095837]  apic 0 pin 23 not connected
[    0.095837]  apic 0 pin 23 not connected
[    0.097157] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.097157] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.100006] smpboot: CPU0:=20
[    0.100006] smpboot: CPU0: GenuineIntel GenuineIntel Intel Core Processo=
r (Haswell)Intel Core Processor (Haswell) (fam: 06, model: 3c (fam: 06, mod=
el: 3c, stepping: 01)
, stepping: 01)
[    0.103985] TSC deadline timer enabled
[    0.103985] TSC deadline timer enabled
[    0.105557] Performance Events:=20
[    0.105557] Performance Events:=20

[    0.107188] ftrace: Allocated trace_printk buffers
[    0.107188] ftrace: Allocated trace_printk buffers
[    0.110000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.110000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.110000] SMP alternatives: lockdep: fixing up alternatives
[    0.110000] SMP alternatives: lockdep: fixing up alternatives
[    0.110023] CPU 1 irqstacks, hard=3Dc03de000 soft=3Dc03e0000
[    0.110023] CPU 1 irqstacks, hard=3Dc03de000 soft=3Dc03e0000
[    0.112135] smpboot: Booting Node   0, Processors=20
[    0.112135] smpboot: Booting Node   0, Processors  #1 OK
 #1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.126557] Brought up 2 CPUs
[    0.126557] Brought up 2 CPUs
[    0.126500] KVM setup async PF for cpu 1
[    0.126500] KVM setup async PF for cpu 1
[    0.126500] kvm-stealtime: cpu 1, msr 123a1fc0
[    0.126500] kvm-stealtime: cpu 1, msr 123a1fc0
[    0.129836] ----------------
[    0.129836] ----------------
[    0.130007] | NMI testsuite:
[    0.130007] | NMI testsuite:
[    0.130839] --------------------
[    0.130839] --------------------
[    0.131776]   remote IPI:
[    0.131776]   remote IPI:  ok  |  ok  |

[    0.160308]    local IPI:
[    0.160308]    local IPI:  ok  |  ok  |

[    0.220031] --------------------
[    0.220031] --------------------
[    0.221008] Good, all   2 testcases passed! |
[    0.221008] Good, all   2 testcases passed! |
[    0.222253] ---------------------------------
[    0.222253] ---------------------------------
[    0.223496] smpboot: Total of 2 processors activated (10773.32 BogoMIPS)
[    0.223496] smpboot: Total of 2 processors activated (10773.32 BogoMIPS)
[    0.226448] devtmpfs: initialized
[    0.226448] devtmpfs: initialized
[    0.230039] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.230039] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.230039] regulator-dummy: no parameters
[    0.230039] regulator-dummy: no parameters
[    0.230039] NET: Registered protocol family 16
[    0.230039] NET: Registered protocol family 16
[    0.230039] EISA bus registered
[    0.230039] EISA bus registered
[    0.235726] ACPI: bus type PCI registered
[    0.235726] ACPI: bus type PCI registered
[    0.235726] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.235726] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.235726] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.235726] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.235726] PCI: Using configuration type 1 for base access
[    0.235726] PCI: Using configuration type 1 for base access
[    0.250086] ACPI: Added _OSI(Module Device)
[    0.250086] ACPI: Added _OSI(Module Device)
[    0.250086] ACPI: Added _OSI(Processor Device)
[    0.250086] ACPI: Added _OSI(Processor Device)
[    0.250086] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.250086] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.250086] ACPI: Added _OSI(Processor Aggregator Device)
[    0.250086] ACPI: Added _OSI(Processor Aggregator Device)
[    0.250315] ACPI: EC: Look up EC in DSDT
[    0.250315] ACPI: EC: Look up EC in DSDT
[    0.255286] ACPI: Interpreter enabled
[    0.255286] ACPI: Interpreter enabled
[    0.256183] ACPI Exception: AE_NOT_FOUND,=20
[    0.256183] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
 (20130517/hwxface-571)
[    0.258388] ACPI Exception: AE_NOT_FOUND,=20
[    0.258388] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
 (20130517/hwxface-571)
[    0.260710] ACPI: (supports S0 S3 S5)
[    0.260710] ACPI: (supports S0 S3 S5)
[    0.261580] ACPI: Using IOAPIC for interrupt routing
[    0.261580] ACPI: Using IOAPIC for interrupt routing
[    0.262788] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.262788] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.272771] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.272771] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.274647] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.274647] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.277724] PCI host bridge to bus 0000:00
[    0.277724] PCI host bridge to bus 0000:00
[    0.278830] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.278830] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.280022] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.280022] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.281520] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.281520] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.290021] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.290021] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.290021] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.290021] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.290021] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.290021] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.290021] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.290021] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.290559] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.290559] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.295793] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.295793] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.298933] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.298933] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.300478] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.300478] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.302305] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.302305] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.304507] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.304507] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.309150] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.309150] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.311878] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.311878] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.321723] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.321723] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.324142] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.324142] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.326813] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.326813] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.329651] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.329651] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.346036] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.346036] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.348052] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.348052] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.350418] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.350418] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.356287] pci_bus 0000:00: on NUMA node 0
[    0.356287] pci_bus 0000:00: on NUMA node 0
[    0.357270] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.357270] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.360546] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.360546] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.362329] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.362329] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.364036] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.364036] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.365817] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.365817] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.367665] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.367665] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.369770] ACPI:=20
[    0.369770] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.370020] ACPI: \_SB_.PCI0: notify handler is installed
[    0.370020] ACPI: \_SB_.PCI0: notify handler is installed
[    0.371470] Found 1 acpi root devices
[    0.371470] Found 1 acpi root devices
[    0.374811] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.374811] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.375774] vgaarb: loaded
[    0.375774] vgaarb: loaded
[    0.376440] vgaarb: bridge control possible 0000:00:02.0
[    0.376440] vgaarb: bridge control possible 0000:00:02.0
[    0.378134] pps_core: LinuxPPS API ver. 1 registered
[    0.378134] pps_core: LinuxPPS API ver. 1 registered
[    0.379531] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.379531] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.385350] PCI: Using ACPI for IRQ routing
[    0.385350] PCI: Using ACPI for IRQ routing
[    0.385350] PCI: pci_cache_line_size set to 64 bytes
[    0.385350] PCI: pci_cache_line_size set to 64 bytes
[    0.385350] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.385350] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.385350] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.385350] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.390005] Switched to clocksource kvm-clock
[    0.390005] Switched to clocksource kvm-clock
[    0.438160] FS-Cache: Loaded
[    0.438160] FS-Cache: Loaded
[    0.439151] pnp: PnP ACPI init
[    0.439151] pnp: PnP ACPI init
[    0.440129] ACPI: bus type PNP registered
[    0.440129] ACPI: bus type PNP registered
[    0.441501] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.441501] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.443787] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.443787] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.445985] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.445985] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.450134] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.450134] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.451936] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.451936] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.454335] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.454335] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.456371] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.456371] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.458790] pnp 00:03: [dma 2]
[    0.458790] pnp 00:03: [dma 2]
[    0.459767] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.459767] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.461727] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.461727] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.463947] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.463947] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.465969] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.465969] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.468374] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.468374] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.470424] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.470424] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.472672] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.472672] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.474907] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.474907] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.477122] pnp: PnP ACPI: found 8 devices
[    0.477122] pnp: PnP ACPI: found 8 devices
[    0.478285] ACPI: bus type PNP unregistered
[    0.478285] ACPI: bus type PNP unregistered
[    0.515580] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.515580] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.517454] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.517454] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.519263] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.519263] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.521268] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.521268] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.523257] NET: Registered protocol family 1
[    0.523257] NET: Registered protocol family 1
[    0.524827] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.524827] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.526725] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.526725] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.528718] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.528718] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.530749] pci 0000:00:02.0: Boot video device
[    0.530749] pci 0000:00:02.0: Boot video device
[    0.532189] PCI: CLS 0 bytes, default 64
[    0.532189] PCI: CLS 0 bytes, default 64
[    0.533398] Unpacking initramfs...
[    0.533398] Unpacking initramfs...
[    1.662128] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    1.662128] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    1.664436] apm: BIOS not found.
[    1.664436] apm: BIOS not found.
[    1.665288] microcode: no support for this CPU vendor
[    1.665288] microcode: no support for this CPU vendor
[    1.687751] cryptomgr_test (24) used greatest stack depth: 7448 bytes le=
ft
[    1.687751] cryptomgr_test (24) used greatest stack depth: 7448 bytes le=
ft
[    1.689664] cryptomgr_test (25) used greatest stack depth: 6908 bytes le=
ft
[    1.689664] cryptomgr_test (25) used greatest stack depth: 6908 bytes le=
ft
[    1.691369] alg: No test for crc32 (crc32-pclmul)
[    1.691369] alg: No test for crc32 (crc32-pclmul)
[    1.697530] msgmni has been set to 605
[    1.697530] msgmni has been set to 605
[    1.699766] cryptomgr_test (38) used greatest stack depth: 6896 bytes le=
ft
[    1.699766] cryptomgr_test (38) used greatest stack depth: 6896 bytes le=
ft
[    1.701802] cryptomgr_test (39) used greatest stack depth: 6860 bytes le=
ft
[    1.701802] cryptomgr_test (39) used greatest stack depth: 6860 bytes le=
ft
[    1.703977] cryptomgr_test (41) used greatest stack depth: 6696 bytes le=
ft
[    1.703977] cryptomgr_test (41) used greatest stack depth: 6696 bytes le=
ft
[    1.721060] cryptomgr_test (43) used greatest stack depth: 6404 bytes le=
ft
[    1.721060] cryptomgr_test (43) used greatest stack depth: 6404 bytes le=
ft
[    1.722907] cryptomgr_test (44) used greatest stack depth: 6324 bytes le=
ft
[    1.722907] cryptomgr_test (44) used greatest stack depth: 6324 bytes le=
ft
[    1.757736] alg: No test for crc32 (crc32-table)
[    1.757736] alg: No test for crc32 (crc32-table)
[    1.759340] alg: No test for lz4 (lz4-generic)
[    1.759340] alg: No test for lz4 (lz4-generic)
[    1.760820] alg: No test for lz4hc (lz4hc-generic)
[    1.760820] alg: No test for lz4hc (lz4hc-generic)
[    1.762202] alg: No test for stdrng (krng)
[    1.762202] alg: No test for stdrng (krng)
[    1.788394] list_sort_test: start testing list_sort()
[    1.788394] list_sort_test: start testing list_sort()
[    1.790122] test_string_helpers: Running tests...
[    1.790122] test_string_helpers: Running tests...
[    1.791603] xz_dec_test: module loaded
[    1.791603] xz_dec_test: module loaded
[    1.792626] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    1.792626] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    1.795580] hgafb: HGA card not detected.
[    1.795580] hgafb: HGA card not detected.
[    1.796471] hgafb: probe of hgafb.0 failed with error -22
[    1.796471] hgafb: probe of hgafb.0 failed with error -22
[    1.797889] ipmi message handler version 39.2
[    1.797889] ipmi message handler version 39.2
[    1.798853] ipmi device interface
[    1.798853] ipmi device interface
[    1.799631] IPMI System Interface driver.
[    1.799631] IPMI System Interface driver.
[    1.816852] ipmi_si: Adding default-specified kcs state machine
[    1.816852] ipmi_si: Adding default-specified kcs state machine

[    1.818538] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.818538] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.821015] ipmi_si: Interface detection failed
[    1.821015] ipmi_si: Interface detection failed
[   10.990076] ipmi_si: Adding default-specified smic state machine
[   10.990076] ipmi_si: Adding default-specified smic state machine

[   10.991467] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   10.991467] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   10.993680] ipmi_si: Interface detection failed
[   10.993680] ipmi_si: Interface detection failed
[   11.010046] ipmi_si: Adding default-specified bt state machine
[   11.010046] ipmi_si: Adding default-specified bt state machine

[   11.011417] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.011417] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.013591] ipmi_si: Interface detection failed
[   11.013591] ipmi_si: Interface detection failed
[   11.040138] ipmi_si: Unable to find any System Interface(s)
[   11.040138] ipmi_si: Unable to find any System Interface(s)
[   11.041443] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   11.041443] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   11.043398] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.043398] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.045079] ACPI: Power Button [PWRF]
[   11.045079] ACPI: Power Button [PWRF]
[   11.046297] xenfs: not registering filesystem on non-xen platform
[   11.046297] xenfs: not registering filesystem on non-xen platform
[   11.047793] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.047793] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.075066] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   11.075066] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   11.077467] DoubleTalk PC - not found
[   11.077467] DoubleTalk PC - not found
[   11.078422] Non-volatile memory driver v1.3
[   11.078422] Non-volatile memory driver v1.3
[   11.079538] ppdev: user-space parallel port driver
[   11.079538] ppdev: user-space parallel port driver
[   11.080712] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   11.080712] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   11.082286] platform pc8736x_gpio.0: no device found
[   11.082286] platform pc8736x_gpio.0: no device found
[   11.083486] nsc_gpio initializing
[   11.083486] nsc_gpio initializing
[   11.084291] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   11.084291] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   11.085378] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   11.085378] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   11.087475] Hangcheck: Using getrawmonotonic().
[   11.087475] Hangcheck: Using getrawmonotonic().
[   11.088610] parport_pc 00:04: reported by Plug and Play ACPI
[   11.088610] parport_pc 00:04: reported by Plug and Play ACPI
[   11.090084] parport0: PC-style at 0x378
[   11.090084] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[   11.170691] dummy-irq: no IRQ given.  Use irq=3DN
[   11.170691] dummy-irq: no IRQ given.  Use irq=3DN
[   11.171780] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   11.171780] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   11.173785] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[   11.173785] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[   11.175472] platform physmap-flash.0: failed to claim resource 0
[   11.175472] platform physmap-flash.0: failed to claim resource 0
[   11.176775] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[   11.176775] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[   11.178043] ------------[ cut here ]------------
[   11.178043] ------------[ cut here ]------------
[   11.179055] kernel BUG at include/linux/mtd/map.h:148!
[   11.179055] kernel BUG at include/linux/mtd/map.h:148!
[   11.180013] invalid opcode: 0000 [#1]=20
[   11.180013] invalid opcode: 0000 [#1] SMP SMP=20

[   11.180013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3-00024-g=
af058ab #13
[   11.180013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3-00024-g=
af058ab #13
[   11.180013] task: c0040000 ti: c003e000 task.ti: c003e000
[   11.180013] task: c0040000 ti: c003e000 task.ti: c003e000
[   11.180013] EIP: 0060:[<c13053fa>] EFLAGS: 00010246 CPU: 0
[   11.180013] EIP: 0060:[<c13053fa>] EFLAGS: 00010246 CPU: 0
[   11.180013] EIP is at mtd_do_chip_probe+0x1a/0x20
[   11.180013] EIP is at mtd_do_chip_probe+0x1a/0x20
[   11.180013] EAX: 00000000 EBX: c1737fd0 ECX: 00000000 EDX: c003fe84
[   11.180013] EAX: 00000000 EBX: c1737fd0 ECX: 00000000 EDX: c003fe84
[   11.180013] ESI: c16b09a5 EDI: c003fec0 EBP: c003fec4 ESP: c003fe84
[   11.180013] ESI: c16b09a5 EDI: c003fec0 EBP: c003fec4 ESP: c003fe84
[   11.180013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   11.180013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   11.180013] CR0: 80050033 CR2: 00000000 CR3: 01816000 CR4: 000406b0
[   11.180013] CR0: 80050033 CR2: 00000000 CR3: 01816000 CR4: 000406b0
[   11.180013] Stack:
[   11.180013] Stack:
[   11.180013]  00000000
[   11.180013]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

[   11.180013]  00000000
[   11.180013]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
000 00000000 00000000 00000000 00000000 00000000 00000000 c17387e0 c17387e0

[   11.180013]  c003fecc
[   11.180013]  c003fecc c1301c62 c1301c62 c003fee0 c003fee0 c1301bfc c1301=
bfc 00000000 00000000 c17ce159 c17ce159 000001bf 000001bf c003ff00 c003ff00

[   11.180013] Call Trace:
[   11.180013] Call Trace:
[   11.180013]  [<c1301c62>] cfi_probe+0x12/0x20
[   11.180013]  [<c1301c62>] cfi_probe+0x12/0x20
[   11.180013]  [<c1301bfc>] do_map_probe+0x5c/0x80
[   11.180013]  [<c1301bfc>] do_map_probe+0x5c/0x80
[   11.180013]  [<c17ce159>] ? physmap_init+0x35/0x35
[   11.180013]  [<c17ce159>] ? physmap_init+0x35/0x35
[   11.180013]  [<c17ce241>] init_sbc_gxx+0xe8/0x123
[   11.180013]  [<c17ce241>] init_sbc_gxx+0xe8/0x123
[   11.180013]  [<c179ab44>] do_one_initcall+0xac/0x13a
[   11.180013]  [<c179ab44>] do_one_initcall+0xac/0x13a
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c11d5289>] ? strlen+0x9/0x20
[   11.180013]  [<c179a519>] ? repair_env_string+0x12/0x51
[   11.180013]  [<c179a519>] ? repair_env_string+0x12/0x51
[   11.180013]  [<c105f285>] ? parse_args+0x2a5/0x3f0
[   11.180013]  [<c105f285>] ? parse_args+0x2a5/0x3f0
[   11.180013]  [<c179acfa>] kernel_init_freeable+0x128/0x1c2
[   11.180013]  [<c179acfa>] kernel_init_freeable+0x128/0x1c2
[   11.180013]  [<c179a507>] ? do_early_param+0x7a/0x7a
[   11.180013]  [<c179a507>] ? do_early_param+0x7a/0x7a
[   11.180013]  [<c14b5050>] kernel_init+0x10/0x150
[   11.180013]  [<c14b5050>] kernel_init+0x10/0x150
[   11.180013]  [<c14c22bb>] ret_from_kernel_thread+0x1b/0x30
[   11.180013]  [<c14c22bb>] ret_from_kernel_thread+0x1b/0x30
[   11.180013]  [<c14b5040>] ? rest_init+0xd0/0xd0
[   11.180013]  [<c14b5040>] ? rest_init+0xd0/0xd0
[   11.180013] Code:
[   11.180013] Code: 5d 5d c3 c3 66 66 90 90 66 66 90 90 66 66 90 90 66 66 =
90 90 66 66 90 90 66 66 90 90 66 66 90 90 90 90 55 55 89 89 e5 e5 57 57 83 =
83 ec ec 3c 3c e8 e8 04 04 d5 d5 1b 1b 00 00 31 31 c0 c0 b9 b9 0f 0f 00 00 =
00 00 00 00 8d 8d 55 55 c0 c0 89 89 d7 d7 f3 f3 ab ab <0f> <0f> 0b 0b 66 66=
 90 90 66 66 90 90 55 55 89 89 e5 e5 e8 e8 e8 e8 d4 d4 1b 1b 00 00 ba ba 10=
 10 82 82 73 73 c1 c1 e8 e8 ce ce

[   11.180013] EIP: [<c13053fa>]=20
[   11.180013] EIP: [<c13053fa>] mtd_do_chip_probe+0x1a/0x20mtd_do_chip_pro=
be+0x1a/0x20 SS:ESP 0068:c003fe84
 SS:ESP 0068:c003fe84
[   11.220762] ---[ end trace 6b2355da72108a70 ]---
[   11.220762] ---[ end trace 6b2355da72108a70 ]---
[   11.221768] Kernel panic - not syncing: Fatal exception
[   11.221768] Kernel panic - not syncing: Fatal exception
[   11.222981] Rebooting in 10 seconds..
[   11.222981] Rebooting in 10 seconds..
Elapsed time: 20
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i38=
6-randconfig-x1-08020829/af058ab04d3d11383e5159132fc78a3700be3af5/vmlinuz-3=
=2E11.0-rc3-00024-gaf058ab -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-x1-08020829/next:ma=
ster:af058ab04d3d11383e5159132fc78a3700be3af5:bisect-linux6/.vmlinuz-af058a=
b04d3d11383e5159132fc78a3700be3af5-20140802122219-16-kbuild branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-x1-08020829/af058ab04d3d11383e51=
59132fc78a3700be3af5/vmlinuz-3.11.0-rc3-00024-gaf058ab drbd.minor_count=3D8=
'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net ni=
c,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wa=
tchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-k=
build-29 -serial file:/dev/shm/kboot/serial-quantal-kbuild-29 -daemonize -d=
isplay none -monitor null=20

--CUfgB8w4ZwR/yMy5
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-x1-08020829-4198cf324ddea447daac3f83d3c2319ced774201-kernel-BUG-at-112284.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNDE5OGNmMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA4MDEKZ2l0IGNoZWNrb3V0IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3
ZDBlY2NmYmQ2YzFhOTEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS9uZXh0Om1hc3Rlcjo2NGFhOTBmMjZjMDZlMWNiMmFh
Y2ZiOThhN2QwZWNjZmJkNmMxYTkxOmJpc2VjdC1saW51eDYKCjIwMTQtMDgtMDItMTA6Mzc6
MzYgNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MSBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjktNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2Zi
ZDZjMWE5MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS02NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNj
ZmJkNmMxYTkxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkv
NjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS92bWxpbnV6LTMuMTYu
MC1yYzcKCjIwMTQtMDgtMDItMTA6Mzk6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNU
IEZBSUxVUkUKWyAgICAwLjY3OTAwMl0gU0JDLUdYeCBmbGFzaDogSU86MHgyNTgtMHgyNTkg
TUVNOjB4ZGMwMDAtMHhkZmZmZgpbICAgIDAuNjgwNzE3XSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjY4MDcxN10gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tClsgICAgMC42ODIwMzhdIGtlcm5lbCBCVUcgYXQgL2tidWlsZC9z
cmMvY29uc3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6MTQ4IQpbICAgIDAuNjgyMDM4
XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRk
L21hcC5oOjE0OCEKWyAgICAwLjY4NDAwOF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSAK
WyAgICAwLjY4NDAwOF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAgU01QIAoKWyAg
ICAwLjY4NTE5NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQg
My4xNi4wLXJjNyAjMQpbICAgIDAuNjg1MTk1XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM3ICMxClsgICAgMC42ODcwMDFdIHRhc2s6IGMw
MDQwMDAwIHRpOiBjMDAzYzAwMCB0YXNrLnRpOiBjMDAzYzAwMApbICAgIDAuNjg3MDAxXSB0
YXNrOiBjMDA0MDAwMCB0aTogYzAwM2MwMDAgdGFzay50aTogYzAwM2MwMDAKWyAgICAwLjY4
ODU3OF0gRUlQOiAwMDYwOls8YzEzMmM0M2E+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApb
ICAgIDAuNjg4NTc4XSBFSVA6IDAwNjA6WzxjMTMyYzQzYT5dIEVGTEFHUzogMDAwMTAyNDYg
Q1BVOiAwClsgICAgMC42OTAxMzRdIEVJUCBpcyBhdCBtdGRfZG9fY2hpcF9wcm9iZSsweDFh
LzB4MjAKWyAgICAwLjY5MDEzNF0gRUlQIGlzIGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEv
MHgyMApbICAgIDAuNjkwNjY5XSBFQVg6IDAwMDAwMDAwIEVCWDogYzE3YTVjOTAgRUNYOiAw
MDAwMDAwMCBFRFg6IGMwMDNkZTg0ClsgICAgMC42OTA2NjldIEVBWDogMDAwMDAwMDAgRUJY
OiBjMTdhNWM5MCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwM2RlODQKWyAgICAwLjY5MDY2OV0g
RVNJOiBjMTZkOGZkMCBFREk6IGMwMDNkZWMwIEVCUDogYzAwM2RlYzQgRVNQOiBjMDAzZGU4
NApbICAgIDAuNjkwNjY5XSBFU0k6IGMxNmQ4ZmQwIEVESTogYzAwM2RlYzAgRUJQOiBjMDAz
ZGVjNCBFU1A6IGMwMDNkZTg0ClsgICAgMC42OTA2NjldICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDAuNjkwNjY5XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAwLjY5MDY2OV0gQ1IwOiA4
MDA1MDAzMyBDUjI6IDAwMDAwMDAwIENSMzogMDE4OGYwMDAgQ1I0OiAwMDA0MDZiMApbICAg
IDAuNjkwNjY5XSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMTg4ZjAwMCBD
UjQ6IDAwMDQwNmIwClsgICAgMC42OTA2NjldIFN0YWNrOgpbICAgIDAuNjkwNjY5XSBTdGFj
azoKWyAgICAwLjY5MDY2OV0gIDAwMDAwMDAwClsgICAgMC42OTA2NjldICAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMAoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkv
NjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by1r
YnVpbGQtMTE6MjAxNDA4MDIxMDM2MjE6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82NGFhOTBm
MjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLWtidWlsZC0x
MzoyMDE0MDgwMjEwMzYyMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJj
NzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0YWE5MGYyNmMwNmUx
Y2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTE1OjIwMTQw
ODAyMTAzNjE3OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNjRhYTkwZjI2YzA2ZTFjYjJhYWNm
Yjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA4MDIxMDM2
MTk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzc6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2Qw
ZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDgwMjEwMzYxNzppMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2
YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwODAyMTAzNjIxOmkzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9k
bWVzZy15b2N0by1rYnVpbGQtMjE6MjAxNDA4MDIxMDM2MjE6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlv
Y3RvLWtidWlsZC0yMjoyMDE0MDgwMjEwMzYyMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
Mjk6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0
YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1
aWxkLTIzOjIwMTQwODAyMTAzNjIxOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2
LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNjRhYTkwZjI2
YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtMjQ6
MjAxNDA4MDIxMDM2MTc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzc6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82NGFhOTBmMjZjMDZlMWNi
MmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLWtidWlsZC0yNzoyMDE0MDgw
MjEwMzYyMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNzoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5
OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwODAyMTAzNjE3
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVj
Y2ZiZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtMjk6MjAxNDA4MDIxMDM2MTc6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOS82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMx
YTkxL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwODAyMTAzNjIxOmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjE2LjAtcmM3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvNjRhYTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVz
Zy15b2N0by1rYnVpbGQtMzA6MjAxNDA4MDIxMDM2MTc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTYuMC1yYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS82NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3Rv
LWtidWlsZC0zMToyMDE0MDgwMjEwMzYyMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxk
LTM6MjAxNDA4MDIxMDM2MjE6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1y
Yzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82NGFhOTBmMjZjMDZl
MWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxL2RtZXNnLXlvY3RvLWtidWlsZC00OjIwMTQw
ODAyMTAzNjE3OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNjRhYTkwZjI2YzA2ZTFjYjJhYWNm
Yjk4YTdkMGVjY2ZiZDZjMWE5MS9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDgwMjEwMzYy
MTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNzoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBl
Y2NmYmQ2YzFhOTEvZG1lc2cteW9jdG8ta2J1aWxkLTk6MjAxNDA4MDIxMDM2MTc6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzc6MQowOjIwOjIwIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAyIDEwOjQwOjA2IFJFUEVBVCBDT1VO
VDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QvLnJlcGVhdBtbMG0K
CmJpc2VjdDogYmFkIGNvbW1pdCA2NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJk
NmMxYTkxCmdpdCBjaGVja291dCB2My4xNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOjE4NjBlMzc5
ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQ6YmlzZWN0LWxpbnV4NgoKMjAxNC0w
OC0wMi0xMDo0Njo1OSAxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBk
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5
MDU4YWVkZGZmZTVhZmQ5ZDBkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1
YWZkOWQwZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTE4NjBlMzc5ODc1ZGZlNzI3MWM2
NDkwNThhZWRkZmZlNWFmZDlkMGQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL3Zt
bGludXotMy4xNS4wCgoyMDE0LTA4LTAyLTEwOjQ4OjU5IGRldGVjdGluZyBib290IHN0YXRl
IC4gVEVTVCBGQUlMVVJFClsgICAxMS44ODc0NDRdIFNCQy1HWHggZmxhc2g6IElPOjB4MjU4
LTB4MjU5IE1FTToweGRjMDAwLTB4ZGZmZmYKWyAgIDExLjg4ODc1OF0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAxMS44ODg3NThdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTEuODg5ODAzXSBrZXJuZWwgQlVHIGF0IC9r
YnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRkL21hcC5oOjE0OCEKWyAgIDEx
Ljg4OTgwM10ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRlL2xp
bnV4L210ZC9tYXAuaDoxNDghClsgICAxMS44OTAwMjBdIGludmFsaWQgb3Bjb2RlOiAwMDAw
IFsjMV0gClsgICAxMS44OTAwMjBdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gU01QIFNN
UCAKClsgICAxMS44OTAwMjBdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0
YWludGVkIDMuMTUuMCAjMgpbICAgMTEuODkwMDIwXSBDUFU6IDEgUElEOiAxIENvbW06IHN3
YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE1LjAgIzIKWyAgIDExLjg5MDAyMF0gdGFzazogYzAw
NDAwMDAgdGk6IGMwMDQ4MDAwIHRhc2sudGk6IGMwMDQ4MDAwClsgICAxMS44OTAwMjBdIHRh
c2s6IGMwMDQwMDAwIHRpOiBjMDA0ODAwMCB0YXNrLnRpOiBjMDA0ODAwMApbICAgMTEuODkw
MDIwXSBFSVA6IDAwNjA6WzxjMTMyMjNiYT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsg
ICAxMS44OTAwMjBdIEVJUDogMDA2MDpbPGMxMzIyM2JhPl0gRUZMQUdTOiAwMDAxMDI0NiBD
UFU6IDEKWyAgIDExLjg5MDAyMF0gRUlQIGlzIGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEv
MHgyMApbICAgMTEuODkwMDIwXSBFSVAgaXMgYXQgbXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8w
eDIwClsgICAxMS44OTAwMjBdIEVBWDogMDAwMDAwMDAgRUJYOiBjMTc4OGM5MCBFQ1g6IDAw
MDAwMDAwIEVEWDogYzAwNDllODQKWyAgIDExLjg5MDAyMF0gRUFYOiAwMDAwMDAwMCBFQlg6
IGMxNzg4YzkwIEVDWDogMDAwMDAwMDAgRURYOiBjMDA0OWU4NApbICAgMTEuODkwMDIwXSBF
U0k6IGMxNmMwMmFiIEVESTogYzAwNDllYzAgRUJQOiBjMDA0OWVjNCBFU1A6IGMwMDQ5ZTg0
ClsgICAxMS44OTAwMjBdIEVTSTogYzE2YzAyYWIgRURJOiBjMDA0OWVjMCBFQlA6IGMwMDQ5
ZWM0IEVTUDogYzAwNDllODQKWyAgIDExLjg5MDAyMF0gIERTOiAwMDdiIEVTOiAwMDdiIEZT
OiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAxMS44OTAwMjBdICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgMTEuODkwMDIwXSBDUjA6IDgw
MDUwMDMzIENSMjogZmZmZmZmZmYgQ1IzOiAwMTg3MTAwMCBDUjQ6IDAwMDQwNmIwClsgICAx
MS44OTAwMjBdIENSMDogODAwNTAwMzMgQ1IyOiBmZmZmZmZmZiBDUjM6IDAxODcxMDAwIENS
NDogMDAwNDA2YjAKWyAgIDExLjg5MDAyMF0gU3RhY2s6ClsgICAxMS44OTAwMjBdIFN0YWNr
OgpbICAgMTEuODkwMDIwXSAgMDAwMDAwMDAKWyAgIDExLjg5MDAyMF0gIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8x
ODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwt
a2J1aWxkLTEyOjIwMTQwODAyMTA0NjE3OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOToz
LjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3
NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwta2J1aWxkLTI0
OjIwMTQwODAyMTA0NjE5OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFj
NjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwta2J1aWxkLTI4OjIwMTQwODAy
MTA0NjI1OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVk
ZGZmZTVhZmQ5ZDBkL2RtZXNnLXlvY3RvLXZwLTIyOjIwMTQwODAyMTA0ODU1OmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2Rt
ZXNnLXlvY3RvLXZwLTUwOjIwMTQwODAyMTA0ODU0OmkzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOTozLjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYw
ZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXlvY3RvLXZwLTU4
OjIwMTQwODAyMTA0ODUyOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFj
NjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXlvY3RvLXZwLTU5OjIwMTQwODAyMTA0ODUx
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6Mgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVh
ZmQ5ZDBkL2RtZXNnLXlvY3RvLWtidWlsZC0yNjoyMDE0MDgwMjEwNDYzMzppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVz
Zy15b2N0by1rYnVpbGQtMzI6MjAxNDA4MDIxMDQ2MzM6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzE4
NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAt
MjI6MjAxNDA4MDIxMDQ5MDY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3
MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtMzM6MjAxNDA4MDIxMDQ4
NTk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZl
NWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtMzc6MjAxNDA4MDIxMDQ5MDY6aTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2ct
eW9jdG8tdnAtNTg6MjAxNDA4MDIxMDQ5MDQ6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5
ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtNTk6MjAx
NDA4MDIxMDQ5MDc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkw
NThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtNjI6MjAxNDA4MDIxMDQ5MDE6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlk
MGQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtNzoyMDE0MDgwMjEwNDY0MjppMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4Mjk6My4xNS4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy1x
dWFudGFsLXZwLTE2OjIwMTQwODAyMTA0OTExOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OTozLjE1LjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3
OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwta2J1aWxk
LTI0OjIwMTQwODAyMTA0NjUzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE1LjA6
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS8xODYwZTM3OTg3NWRmZTcy
NzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwtdnAtMjI6MjAxNDA4MDIx
MDQ5MTc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRk
ZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8tdnAtNTA6MjAxNDA4MDIxMDQ5MTI6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTUuMDoyCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKG1sxOzM1bTIwMTQtMDgtMDIgMTA6NDk6MzAgUkVQRUFUIENPVU5UOiAyMCAg
IyAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0
OiBiYWQgY29tbWl0IHYzLjE1CmdpdCBjaGVja291dCB2My4xNApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFz
dGVyOjQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxp
bnV4NgoKMjAxNC0wOC0wMi0xMDo1ODoxNyA0NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2
OTlkNmQ3M2RlMTFjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS00NTVjNmZkYmQy
MTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIx
MTY1ZjExNjk5ZDZkNzNkZTExYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTQ1NWM2ZmRi
ZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlk
NmQ3M2RlMTFjL3ZtbGludXotMy4xNC4wCgoyMDE0LTA4LTAyLTExOjAwOjE3IGRldGVjdGlu
ZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgNy4xMDcwNjZdIFNCQy1HWHggZmxh
c2g6IElPOjB4MjU4LTB4MjU5IE1FTToweGRjMDAwLTB4ZGZmZmYKWyAgICA3LjEwODUyNF0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNy4xMDg1MjRdIC0t
LS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDcuMTA5NTQyXSBrZXJu
ZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRkL21hcC5o
OjE0OCEKWyAgICA3LjEwOTU0Ml0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1l
ci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAgNy4xMTAwMDhdIGludmFsaWQg
b3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgNy4xMTAwMDhdIGludmFsaWQgb3Bjb2RlOiAwMDAw
IFsjMV0gU01QIFNNUCAKClsgICAgNy4xMTAwMDhdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dh
cHBlci8wIE5vdCB0YWludGVkIDMuMTQuMCAjMwpbICAgIDcuMTEwMDA4XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAgIzMKWyAgICA3LjExMDAw
OF0gdGFzazogYzAwNDAwMDAgdGk6IGMwMDJhMDAwIHRhc2sudGk6IGMwMDJhMDAwClsgICAg
Ny4xMTAwMDhdIHRhc2s6IGMwMDQwMDAwIHRpOiBjMDAyYTAwMCB0YXNrLnRpOiBjMDAyYTAw
MApbICAgIDcuMTEwMDA4XSBFSVA6IDAwNjA6WzxjMTMyNWFjYT5dIEVGTEFHUzogMDAwMTAy
NDYgQ1BVOiAwClsgICAgNy4xMTAwMDhdIEVJUDogMDA2MDpbPGMxMzI1YWNhPl0gRUZMQUdT
OiAwMDAxMDI0NiBDUFU6IDAKWyAgICA3LjExMDAwOF0gRUlQIGlzIGF0IG10ZF9kb19jaGlw
X3Byb2JlKzB4MWEvMHgyMApbICAgIDcuMTEwMDA4XSBFSVAgaXMgYXQgbXRkX2RvX2NoaXBf
cHJvYmUrMHgxYS8weDIwClsgICAgNy4xMTAwMDhdIEVBWDogMDAwMDAwMDAgRUJYOiBjMTc3
YzYxMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwMmJlODQKWyAgICA3LjExMDAwOF0gRUFYOiAw
MDAwMDAwMCBFQlg6IGMxNzdjNjEwIEVDWDogMDAwMDAwMDAgRURYOiBjMDAyYmU4NApbICAg
IDcuMTEwMDA4XSBFU0k6IGMxNmI4OTY4IEVESTogYzAwMmJlYzAgRUJQOiBjMDAyYmVjNCBF
U1A6IGMwMDJiZTg0ClsgICAgNy4xMTAwMDhdIEVTSTogYzE2Yjg5NjggRURJOiBjMDAyYmVj
MCBFQlA6IGMwMDJiZWM0IEVTUDogYzAwMmJlODQKWyAgICA3LjExMDAwOF0gIERTOiAwMDdi
IEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgNy4xMTAwMDhdICBE
UzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDcuMTEw
MDA4XSBDUjA6IDgwMDUwMDMzIENSMjogZmZmZmZmZmYgQ1IzOiAwMTg2MjAwMCBDUjQ6IDAw
MDQwNmIwClsgICAgNy4xMTAwMDhdIENSMDogODAwNTAwMzMgQ1IyOiBmZmZmZmZmZiBDUjM6
IDAxODYyMDAwIENSNDogMDAwNDA2YjAKWyAgICA3LjExMDAwOF0gU3RhY2s6ClsgICAgNy4x
MTAwMDhdIFN0YWNrOgpbICAgIDcuMTEwMDA4XSAgMDAwMDAwMDAKWyAgICA3LjExMDAwOF0g
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjL2Rt
ZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDgwMjEwNTY0OTppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkv
NDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy1xdWFudGFs
LWtidWlsZC0xMDoyMDE0MDgwMjEwNTY1ODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDU1YzZmZGJk
MjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy15b2N0by12cC0yMjoyMDE0
MDgwMjEwNTkyNTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1
ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy1xdWFudGFsLWtidWlsZC0xNzoyMDE0MDgwMjEwNTcw
MjppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZk
NzNkZTExYy9kbWVzZy1xdWFudGFsLWtidWlsZC0xOToyMDE0MDgwMjEwNTcwNzppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9k
bWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA4MDIxMDU3MDc6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2cteW9jdG8t
a2J1aWxkLTE6MjAxNDA4MDIxMDU3MDU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ1NWM2ZmRiZDIx
OTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA4
MDIxMDU5MzI6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTQuMDozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYx
MTY5OWQ2ZDczZGUxMWMvZG1lc2cteW9jdG8tdnAtNTk6MjAxNDA4MDIxMDU5MzY6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMv
ZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDA4MDIxMDU5Mzc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ1
NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2ctcXVhbnRhbC12
cC0yNjoyMDE0MDgwMjEwNTk0NTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNC4w
OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYx
YmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy1xdWFudGFsLXZwLTMwOjIwMTQwODAy
MTA1OTQ2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE0LjA6Mwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2
OTlkNmQ3M2RlMTFjL2RtZXNnLXlvY3RvLWtidWlsZC0xMzoyMDE0MDgwMjEwNTcxOTppMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTEx
Yy9kbWVzZy1xdWFudGFsLWtidWlsZC0xNzoyMDE0MDgwMjEwNTczMDppMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy1x
dWFudGFsLWtidWlsZC0yMzoyMDE0MDgwMjEwNTcyMjppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xNC4wOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDU1
YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy1xdWFudGFsLWti
dWlsZC02OjIwMTQwODAyMTA1NzIzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE0
LjA6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NTVjNmZkYmQyMTkx
NjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjL2RtZXNnLXF1YW50YWwtdnAtMTI6MjAxNDA4
MDIxMDU5NDk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTQuMDozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYx
MTY5OWQ2ZDczZGUxMWMvZG1lc2cteW9jdG8tdnAtMzc6MjAxNDA4MDIxMDU5NDg6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMv
ZG1lc2cteW9jdG8tdnAtNTk6MjAxNDA4MDIxMDU5NTI6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTQuMDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ1
NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMTI6MjAxNDA4MDIxMDU3MzY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTQuMDozCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDgtMDIgMTE6MDA6NDcgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjE0Cmdp
dCBjaGVja291dCB2My4xMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOmQ4ZWMyNmQ3ZjgyODdmNTc4
OGE0OTRmNTZlODgxNDIxMGYwZTY0YmU6YmlzZWN0LWxpbnV4NgoKMjAxNC0wOC0wMi0xMTow
MzoyMSBkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQy
MTBmMGU2NGJlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgx
NDIxMGYwZTY0YmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMuMTMuMAoKMjAxNC0wOC0wMi0xMTowNjoy
MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgMTEuNjY5OTE3XSBT
QkMtR1h4IGZsYXNoOiBJTzoweDI1OC0weDI1OSBNRU06MHhkYzAwMC0weGRmZmZmClsgICAx
MS42NzE2MjBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTEu
NjcxNjIwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDExLjY3
Mjg5NV0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRlL2xpbnV4
L210ZC9tYXAuaDoxNDghClsgICAxMS42NzI4OTVdIGtlcm5lbCBCVUcgYXQgL2tidWlsZC9z
cmMvY29uc3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6MTQ4IQpbICAgMTEuNjc0ODEw
XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIApbICAgMTEuNjc0ODEwXSBpbnZhbGlkIG9w
Y29kZTogMDAwMCBbIzFdIFNNUCBTTVAgCgpbICAgMTEuNjc2MDAxXSBDUFU6IDEgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEzLjAgIzEKWyAgIDExLjY3NjAwMV0g
Q1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMy4wICMxClsg
ICAxMS42Nzc2NDddIHRhc2s6IGMwMDQwMDAwIHRpOiBjMDAzZTAwMCB0YXNrLnRpOiBjMDAz
ZTAwMApbICAgMTEuNjc3NjQ3XSB0YXNrOiBjMDA0MDAwMCB0aTogYzAwM2UwMDAgdGFzay50
aTogYzAwM2UwMDAKWyAgIDExLjY3OTE0OV0gRUlQOiAwMDYwOls8YzEzMTY3YWE+XSBFRkxB
R1M6IDAwMDEwMjQ2IENQVTogMQpbICAgMTEuNjc5MTQ5XSBFSVA6IDAwNjA6WzxjMTMxNjdh
YT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAxMS42ODA2OTRdIEVJUCBpcyBhdCBt
dGRfZG9fY2hpcF9wcm9iZSsweDFhLzB4MjAKWyAgIDExLjY4MDY5NF0gRUlQIGlzIGF0IG10
ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTEuNjgxNTQ3XSBFQVg6IDAwMDAwMDAw
IEVCWDogYzE3NjM0ZDAgRUNYOiAwMDAwMDAwMCBFRFg6IGMwMDNmZTg0ClsgICAxMS42ODE1
NDddIEVBWDogMDAwMDAwMDAgRUJYOiBjMTc2MzRkMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAw
M2ZlODQKWyAgIDExLjY4MTU0N10gRVNJOiBjMTY5ZDc1ZCBFREk6IGMwMDNmZWMwIEVCUDog
YzAwM2ZlYzQgRVNQOiBjMDAzZmU4NApbICAgMTEuNjgxNTQ3XSBFU0k6IGMxNjlkNzVkIEVE
STogYzAwM2ZlYzAgRUJQOiBjMDAzZmVjNCBFU1A6IGMwMDNmZTg0ClsgICAxMS42ODE1NDdd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgMTEu
NjgxNTQ3XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgK
WyAgIDExLjY4MTU0N10gQ1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDAwIENSMzogMDE4NDYw
MDAgQ1I0OiAwMDA0MDZiMApbICAgMTEuNjgxNTQ3XSBDUjA6IDgwMDUwMDMzIENSMjogMDAw
MDAwMDAgQ1IzOiAwMTg0NjAwMCBDUjQ6IDAwMDQwNmIwClsgICAxMS42ODE1NDddIFN0YWNr
OgpbICAgMTEuNjgxNTQ3XSBTdGFjazoKWyAgIDExLjY4MTU0N10gIDAwMDAwMDAwClsgICAx
MS42ODE1NDddICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEw
ZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA4MDIxMTAzMjU6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1l
c2cteW9jdG8ta2J1aWxkLTI6MjAxNDA4MDIxMTAzMjU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Q4
ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8ta2J1
aWxkLTc6MjAxNDA4MDIxMTAzMjY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTMu
MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Q4ZWMyNmQ3ZjgyODdm
NTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTU6MjAx
NDA4MDIxMTAzMzk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTMuMDoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRm
NTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwODAyMTEwMzQ0
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBm
MGU2NGJlL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDgwMjExMDM0NTppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVz
Zy15b2N0by1rYnVpbGQtNDoyMDE0MDgwMjExMDM0NjppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVp
bGQtNjoyMDE0MDgwMjExMDM0NzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMy4w
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC02MjoyMDE0MDgwMjEx
MDYxMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMy4wOjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0
MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC0yOToyMDE0MDgwMjExMDYxNDppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVz
Zy15b2N0by12cC0zOToyMDE0MDgwMjExMDYxNDppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
Mjk6My4xMy4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvZDhlYzI2
ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by12cC04OjIw
MTQwODAyMTEwNjE0OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEzLjA6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0
ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwODAyMTEwMzUx
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBm
MGU2NGJlL2RtZXNnLXlvY3RvLXZwLTE3OjIwMTQwODAyMTEwNjE4OmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlv
Y3RvLXZwLTIwOjIwMTQwODAyMTEwNjE5OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOToz
LjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4
Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLXZwLTI2OjIwMTQw
ODAyMTEwNjE4OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLXZwLTMxOjIwMTQwODAyMTEwNjE5OmkzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJl
L2RtZXNnLXF1YW50YWwta2J1aWxkLTEyOjIwMTQwODAyMTEwNDA3OmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjEzLjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1
YW50YWwtdnAtMTA6MjAxNDA4MDIxMTA2Mjg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
OjMuMTMuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Q4ZWMyNmQ3
ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
NjoyMDE0MDgwMjExMDQxMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMy4wOjEK
MDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0wMiAx
MTowNjo1MSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmot
YmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTMKZ2l0IGNoZWNr
b3V0IHYzLjEyCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1
ZGE5OGNjYmQ2YTVjZWI1MjpiaXNlY3QtbGludXg2CgoyMDE0LTA4LTAyLTExOjA4OjUwIDVl
MDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LTVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2Vi
NTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4MjktNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVj
ZWI1Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTVlMDFk
YzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4
Y2NiZDZhNWNlYjUyL3ZtbGludXotMy4xMi4wCgoyMDE0LTA4LTAyLTExOjExOjUwIGRldGVj
dGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAxMS4xMTY5NjhdIFNCQy1HWHgg
Zmxhc2g6IElPOjB4MjU4LTB4MjU5IE1FTToweGRjMDAwLTB4ZGZmZmYKWyAgIDExLjExODI2
NV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAxMS4xMTgyNjVd
IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTEuMTE5MjkxXSBr
ZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRkL21h
cC5oOjE0OCEKWyAgIDExLjExOTI5MV0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25z
dW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAxMS4xMjAwMTFdIGludmFs
aWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAxMS4xMjAwMTFdIGludmFsaWQgb3Bjb2RlOiAw
MDAwIFsjMV0gU01QIFNNUCAKClsgICAxMS4xMjAwMTFdIENQVTogMSBQSUQ6IDEgQ29tbTog
c3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMCAjMgpbICAgMTEuMTIwMDExXSBDUFU6IDEg
UElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAgIzIKWyAgIDExLjEy
MDAxMV0gdGFzazogYzAwNDAwMDAgdGk6IGMwMDNlMDAwIHRhc2sudGk6IGMwMDNlMDAwClsg
ICAxMS4xMjAwMTFdIHRhc2s6IGMwMDQwMDAwIHRpOiBjMDAzZTAwMCB0YXNrLnRpOiBjMDAz
ZTAwMApbICAgMTEuMTIwMDExXSBFSVA6IDAwNjA6WzxjMTMwYzJkYT5dIEVGTEFHUzogMDAw
MTAyNDYgQ1BVOiAxClsgICAxMS4xMjAwMTFdIEVJUDogMDA2MDpbPGMxMzBjMmRhPl0gRUZM
QUdTOiAwMDAxMDI0NiBDUFU6IDEKWyAgIDExLjEyMDAxMV0gRUlQIGlzIGF0IG10ZF9kb19j
aGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTEuMTIwMDExXSBFSVAgaXMgYXQgbXRkX2RvX2No
aXBfcHJvYmUrMHgxYS8weDIwClsgICAxMS4xMjAwMTFdIEVBWDogMDAwMDAwMDAgRUJYOiBj
MTc0YmVkMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwM2ZlODQKWyAgIDExLjEyMDAxMV0gRUFY
OiAwMDAwMDAwMCBFQlg6IGMxNzRiZWQwIEVDWDogMDAwMDAwMDAgRURYOiBjMDAzZmU4NApb
ICAgMTEuMTIwMDExXSBFU0k6IGMxNmMzMWZmIEVESTogYzAwM2ZlYzAgRUJQOiBjMDAzZmVj
NCBFU1A6IGMwMDNmZTg0ClsgICAxMS4xMjAwMTFdIEVTSTogYzE2YzMxZmYgRURJOiBjMDAz
ZmVjMCBFQlA6IGMwMDNmZWM0IEVTUDogYzAwM2ZlODQKWyAgIDExLjEyMDAxMV0gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAxMS4xMjAwMTFd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgMTEu
MTIwMDExXSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMTgyYzAwMCBDUjQ6
IDAwMDQwNmIwClsgICAxMS4xMjAwMTFdIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAwMCBD
UjM6IDAxODJjMDAwIENSNDogMDAwNDA2YjAKWyAgIDExLjEyMDAxMV0gU3RhY2s6ClsgICAx
MS4xMjAwMTFdIFN0YWNrOgpbICAgMTEuMTIwMDExXSAgMDAwMDAwMDAKWyAgIDExLjEyMDAx
MV0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUy
L2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDgwMjExMDk0ODppMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4Mjk6My4xMi4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0
by1rYnVpbGQtMTg6MjAxNDA4MDIxMTA5NDg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
OjMuMTIuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzVlMDFkYzdi
MjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8ta2J1aWxkLTE6
MjAxNDA4MDIxMTA5NDg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTIuMDoyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzVlMDFkYzdiMjZkOWYyNGYzOWFi
YWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwODAyMTEw
OTUxOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEyLjA6Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2Ni
ZDZhNWNlYjUyL2RtZXNnLXlvY3RvLWtidWlsZC02OjIwMTQwODAyMTEwOTQ1OmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjEyLjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2Rt
ZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwODAyMTEwOTQ2OmkzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOTozLjEyLjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS81
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLWti
dWlsZC0xMToyMDE0MDgwMjExMDk1NjppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
Mi4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNWUwMWRjN2IyNmQ5
ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAx
NDA4MDIxMTA5NTU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTIuMDoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNl
NWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwODAyMTEwOTU0
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEyLjA6Mgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZh
NWNlYjUyL2RtZXNnLXlvY3RvLWtidWlsZC0yMzoyMDE0MDgwMjExMDk1NTppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xMi4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVz
Zy15b2N0by1rYnVpbGQtNjoyMDE0MDgwMjExMDk1NjppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xMi4wOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNWUw
MWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1rYnVp
bGQtOToyMDE0MDgwMjExMDk1NzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4w
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNWUwMWRjN2IyNmQ5ZjI0
ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLWtidWlsZC0xNzoyMDE0
MDgwMjExMTAwMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4wOjIKMDoxMzox
MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0wMiAxMToxMjoy
MSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTIKZ2l0IGNoZWNrb3V0IHYz
LjExCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3Zjcw
YTk0YzE5MjEzZTpiaXNlY3QtbGludXg2CgoyMDE0LTA4LTAyLTExOjEzOjM4IDZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5LTZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjktNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZQpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uvdm1saW51ei0zLjExLjAKCjIwMTQtMDgt
MDItMTE6MTU6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIwIFNVQ0NFU1MKCmJpc2VjdDog
Z29vZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCB2My4xMiB2My4xMSAtLQovYy9r
ZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJ2My4xMiIsICItZyIsICJ2My4x
MSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9j
L2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxMTkwNiByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls3Yjll
M2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmXSBNZXJnZSB0YWcgJ2ZpeGVz
LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2FybS9hcm0tc29jCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5L25leHQ6bWFzdGVyOjdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0NmMy
MmY6YmlzZWN0LWxpbnV4NgoKMjAxNC0wOC0wMi0xMToxNjoxMyA3YjllM2E2YWMwMGJlNGYz
ZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS03YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2I5ZTNhNmFj
MDBiZTRmM2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIyZgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5LTdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0NmMyMmYKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1
NGE3MTE1NzNiMTc5NGIwNDZjMjJmL3ZtbGludXotMy4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNh
NgoKMjAxNC0wOC0wMi0xMToxODoyNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJ
TFVSRQpbICAgMTAuNDI1OTc0XSBTQkMtR1h4IGZsYXNoOiBJTzoweDI1OC0weDI1OSBNRU06
MHhkYzAwMC0weGRmZmZmClsgICAxMC40MjY4NzddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgMTAuNDI2ODc3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgIDEwLjQyNzU3MF0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9j
b25zdW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAxMC40Mjc1NzBdIGtl
cm5lbCBCVUcgYXQgL2tidWlsZC9zcmMvY29uc3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFw
Lmg6MTQ4IQpbICAgMTAuNDI4NTk2XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIApbICAg
MTAuNDI4NTk2XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUCBTTVAgCgpbICAgMTAu
NDI5MjMwXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEy
LjAtcmMxLTAwMjUwLWc3YjllM2E2ICM1ClsgICAxMC40MjkyMzBdIENQVTogMSBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTYg
IzUKWyAgIDEwLjQzMDM0Nl0gdGFzazogYzAwNDAwMDAgdGk6IGMwMDNlMDAwIHRhc2sudGk6
IGMwMDNlMDAwClsgICAxMC40MzAzNDZdIHRhc2s6IGMwMDQwMDAwIHRpOiBjMDAzZTAwMCB0
YXNrLnRpOiBjMDAzZTAwMApbICAgMTAuNDMxMTUzXSBFSVA6IDAwNjA6WzxjMTMwYzVhYT5d
IEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAxMC40MzExNTNdIEVJUDogMDA2MDpbPGMx
MzBjNWFhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDEKWyAgIDEwLjQzMTQzMV0gRUlQIGlz
IGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTAuNDMxNDMxXSBFSVAgaXMg
YXQgbXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAxMC40MzE0MzFdIEVBWDogMDAw
MDAwMDAgRUJYOiBjMTc0YmUzMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwM2ZlODQKWyAgIDEw
LjQzMTQzMV0gRUFYOiAwMDAwMDAwMCBFQlg6IGMxNzRiZTMwIEVDWDogMDAwMDAwMDAgRURY
OiBjMDAzZmU4NApbICAgMTAuNDMxNDMxXSBFU0k6IGMxNmMyMGRmIEVESTogYzAwM2ZlYzAg
RUJQOiBjMDAzZmVjNCBFU1A6IGMwMDNmZTg0ClsgICAxMC40MzE0MzFdIEVTSTogYzE2YzIw
ZGYgRURJOiBjMDAzZmVjMCBFQlA6IGMwMDNmZWM0IEVTUDogYzAwM2ZlODQKWyAgIDEwLjQz
MTQzMV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4Clsg
ICAxMC40MzE0MzFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzog
MDA2OApbICAgMTAuNDMxNDMxXSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAw
MTgyYzAwMCBDUjQ6IDAwMDAwNmIwClsgICAxMC40MzE0MzFdIENSMDogODAwNTAwM2IgQ1Iy
OiAwMDAwMDAwMCBDUjM6IDAxODJjMDAwIENSNDogMDAwMDA2YjAKWyAgIDEwLjQzMTQzMV0g
U3RhY2s6ClsgICAxMC40MzE0MzFdIFN0YWNrOgpbICAgMTAuNDMxNDMxXSAgMDAwMDAwMDAK
WyAgIDEwLjQzMTQzMV0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNi
MTc5NGIwNDZjMjJmL2RtZXNnLXlvY3RvLWtidWlsZC0yMDoyMDE0MDgwMjExMTQ0NjppMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNhNjo1Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdiOWUzYTZhYzAwYmU0ZjNkNjU0
YTcxMTU3M2IxNzk0YjA0NmMyMmYvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwODAyMTEx
NDQ2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEyLjAtcmMxLTAwMjUwLWc3Yjll
M2E2OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2I5ZTNhNmFjMDBi
ZTRmM2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIyZi9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAx
NDA4MDIxMTE0NDU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTIuMC1yYzEtMDAy
NTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83Yjll
M2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmL2RtZXNnLXlvY3RvLWtidWls
ZC0zMToyMDE0MDgwMjExMTQ0NjppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4w
LXJjMS0wMDI1MC1nN2I5ZTNhNjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5LzdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0NmMyMmYvZG1lc2cteW9j
dG8ta2J1aWxkLTM6MjAxNDA4MDIxMTE0NDY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
OjMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmL2Rt
ZXNnLXlvY3RvLXZwLTExOjIwMTQwODAyMTExNzExOmkzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOTozLjEyLjAtcmMxLTAwMjUwLWc3YjllM2E2OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4MjkvN2I5ZTNhNmFjMDBiZTRmM2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIy
Zi9kbWVzZy15b2N0by12cC0xMjoyMDE0MDgwMjExMTcxMTppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNhNjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0
NmMyMmYvZG1lc2cteW9jdG8tdnAtNDg6MjAxNDA4MDIxMTE3MTI6aTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5OjMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5
NGIwNDZjMjJmL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDgwMjExMTQ0NjppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNhNjo1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcx
MTU3M2IxNzk0YjA0NmMyMmYvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwODAyMTExNDQ2
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEyLjAtcmMxLTAwMjUwLWc3YjllM2E2
OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2I5ZTNhNmFjMDBiZTRm
M2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIyZi9kbWVzZy15b2N0by1rYnVpbGQtMjM6MjAxNDA4
MDIxMTE0NDc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTIuMC1yYzEtMDAyNTAt
ZzdiOWUzYTY6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2
YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmL2RtZXNnLXlvY3RvLWtidWlsZC0y
ODoyMDE0MDgwMjExMTQ0NzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4wLXJj
MS0wMDI1MC1nN2I5ZTNhNjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LzdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0NmMyMmYvZG1lc2cteW9jdG8t
dnAtMjY6MjAxNDA4MDIxMTE3MTI6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTIu
MC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIwNDZjMjJmL2RtZXNnLXlv
Y3RvLXZwLTI4OjIwMTQwODAyMTExNzEyOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOToz
LjEyLjAtcmMxLTAwMjUwLWc3YjllM2E2OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvN2I5ZTNhNmFjMDBiZTRmM2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIyZi9kbWVz
Zy15b2N0by12cC0yOjIwMTQwODAyMTExNzEyOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OTozLjEyLjAtcmMxLTAwMjUwLWc3YjllM2E2OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvN2I5ZTNhNmFjMDBiZTRmM2Q2NTRhNzExNTczYjE3OTRiMDQ2YzIyZi9k
bWVzZy15b2N0by12cC0zMToyMDE0MDgwMjExMTcxMjppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNhNjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LzdiOWUzYTZhYzAwYmU0ZjNkNjU0YTcxMTU3M2IxNzk0YjA0NmMy
MmYvZG1lc2cteW9jdG8tdnAtMzk6MjAxNDA4MDIxMTE3MTI6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5NGIw
NDZjMjJmL2RtZXNnLXlvY3RvLXZwLTY6MjAxNDA4MDIxMTE3MTI6aTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5OjMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1NzNiMTc5
NGIwNDZjMjJmL2RtZXNnLXF1YW50YWwtdnAtMzE6MjAxNDA4MDIxMTE3MjI6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTIuMC1yYzEtMDAyNTAtZzdiOWUzYTY6NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83YjllM2E2YWMwMGJlNGYzZDY1NGE3MTE1
NzNiMTc5NGIwNDZjMjJmL2RtZXNnLXF1YW50YWwtdnAtOToyMDE0MDgwMjExMTcyMjppMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMi4wLXJjMS0wMDI1MC1nN2I5ZTNhNjo1CjA6
MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDgtMDIgMTE6
MTg6NTcgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxMDQwMyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls2Y2NjYzdkMzAxMjM0NDM3MWE4
OTdlY2RkMWExMzk4Mjg2YTZlZThhXSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZ2UvY2VwaC1j
bGllbnQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvbmV4dDptYXN0
ZXI6NmNjY2M3ZDMwMTIzNDQzNzFhODk3ZWNkZDFhMTM5ODI4NmE2ZWU4YTpiaXNlY3QtbGlu
dXg2CgoyMDE0LTA4LTAyLTExOjE5OjU3IDZjY2NjN2QzMDEyMzQ0MzcxYTg5N2VjZGQxYTEz
OTgyODZhNmVlOGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTZjY2NjN2QzMDEy
MzQ0MzcxYTg5N2VjZGQxYTEzOTgyODZhNmVlOGEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82Y2NjYzdkMzAxMjM0NDM3MWE4OTdl
Y2RkMWExMzk4Mjg2YTZlZThhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjktNmNjY2M3ZDMw
MTIzNDQzNzFhODk3ZWNkZDFhMTM5ODI4NmE2ZWU4YQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5LTZjY2NjN2QzMDEyMzQ0MzcxYTg5N2VjZGQxYTEzOTgy
ODZhNmVlOGEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82
Y2NjYzdkMzAxMjM0NDM3MWE4OTdlY2RkMWExMzk4Mjg2YTZlZThhL3ZtbGludXotMy4xMS4w
LTA3OTA0LWc2Y2NjYzdkCgoyMDE0LTA4LTAyLTExOjIyOjU3IGRldGVjdGluZyBib290IHN0
YXRlIC4uCTE3LgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI0MjYgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbOGIxOWUzNDE4OGEzMmQ2
M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MF0gdmZzOiBtYWtlIGdldGN3ZCgpIGdldCB0aGUg
cm9vdCBhbmQgcHdkIHBhdGggdW5kZXIgcmN1CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOjhiMTllMzQxODhhMzJkNjNhN2RhOTRlYThhM2Y1
ZTM5YjBjNjYwNTA6YmlzZWN0LWxpbnV4NgoKMjAxNC0wOC0wMi0xMToyNTozMSA4YjE5ZTM0
MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUwIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS04YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUwCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkv
OGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5LThiMTllMzQxODhhMzJkNjNhN2RhOTRlYThhM2Y1ZTM5YjBjNjYwNTAK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS84YjE5ZTM0MTg4
YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUwL3ZtbGludXotMy4xMS4wLTA2NTY4LWc4
YjE5ZTM0CgoyMDE0LTA4LTAyLTExOjI3OjMxIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVT
VCBGQUlMVVJFClsgICAgMC41MTYyMTVdIFNCQy1HWHggZmxhc2g6IElPOjB4MjU4LTB4MjU5
IE1FTToweGRjMDAwLTB4ZGZmZmYKWyAgICAwLjUxNzE1OF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC41MTcxNThdIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuNTE3ODk0XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQv
c3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRkL21hcC5oOjE0OCEKWyAgICAwLjUxNzg5
NF0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRlL2xpbnV4L210
ZC9tYXAuaDoxNDghClsgICAgMC41MTg5ODldIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0g
ClsgICAgMC41MTg5ODldIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gU01QIFNNUCAKClsg
ICAgMC41MTk2NzFdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVk
IDMuMTEuMC0wNjU2OC1nOGIxOWUzNCAjNgpbICAgIDAuNTE5NjcxXSBDUFU6IDAgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtMDY1NjgtZzhiMTllMzQgIzYK
WyAgICAwLjUyMDAxN10gdGFzazogYzAwMzgwMDAgdGk6IGMwMDQwMDAwIHRhc2sudGk6IGMw
MDQwMDAwClsgICAgMC41MjAwMTddIHRhc2s6IGMwMDM4MDAwIHRpOiBjMDA0MDAwMCB0YXNr
LnRpOiBjMDA0MDAwMApbICAgIDAuNTIwMDE3XSBFSVA6IDAwNjA6WzxjMTMwYjliYT5dIEVG
TEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgMC41MjAwMTddIEVJUDogMDA2MDpbPGMxMzBi
OWJhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgICAwLjUyMDAxN10gRUlQIGlzIGF0
IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgIDAuNTIwMDE3XSBFSVAgaXMgYXQg
bXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAgMC41MjAwMTddIEVBWDogMDAwMDAw
MDAgRUJYOiBjMTc0N2UzMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwNDFlODQKWyAgICAwLjUy
MDAxN10gRUFYOiAwMDAwMDAwMCBFQlg6IGMxNzQ3ZTMwIEVDWDogMDAwMDAwMDAgRURYOiBj
MDA0MWU4NApbICAgIDAuNTIwMDE3XSBFU0k6IGMxNmJmNTZiIEVESTogYzAwNDFlYzAgRUJQ
OiBjMDA0MWVjNCBFU1A6IGMwMDQxZTg0ClsgICAgMC41MjAwMTddIEVTSTogYzE2YmY1NmIg
RURJOiBjMDA0MWVjMCBFQlA6IGMwMDQxZWM0IEVTUDogYzAwNDFlODQKWyAgICAwLjUyMDAx
N10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAg
MC41MjAwMTddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2
OApbICAgIDAuNTIwMDE3XSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMTgy
ODAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMC41MjAwMTddIENSMDogODAwNTAwMzMgQ1IyOiAw
MDAwMDAwMCBDUjM6IDAxODI4MDAwIENSNDogMDAwNDA2YjAKWyAgICAwLjUyMDAxN10gU3Rh
Y2s6ClsgICAgMC41MjAwMTddIFN0YWNrOgpbICAgIDAuNTIwMDE3XSAgMDAwMDAwMDAKWyAg
ICAwLjUyMDAxN10gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS84YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUz
OWIwYzY2MDUwL2RtZXNnLXlvY3RvLWtidWlsZC0xMDoyMDE0MDgwMjExMjM1OTppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEz
ZjVlMzliMGM2NjA1MC9kbWVzZy15b2N0by1rYnVpbGQtMTI6MjAxNDA4MDIxMTI0MDA6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNjU2OC1nOGIxOWUzNDo2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzhiMTllMzQxODhhMzJkNjNhN2RhOTRl
YThhM2Y1ZTM5YjBjNjYwNTAvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwODAyMTEyNDAx
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDY1NjgtZzhiMTllMzQ6Ngov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS84YjE5ZTM0MTg4YTMyZDYzYTdk
YTk0ZWE4YTNmNWUzOWIwYzY2MDUwL2RtZXNnLXlvY3RvLWtidWlsZC0xOToyMDE0MDgwMjEx
MjQwMTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA2NTY4LWc4YjE5ZTM0
OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvOGIxOWUzNDE4OGEzMmQ2
M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15b2N0by1rYnVpbGQtMToyMDE0MDgw
MjExMjQwMDppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA2NTY4LWc4YjE5
ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvOGIxOWUzNDE4OGEz
MmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15b2N0by1rYnVpbGQtMjI6MjAx
NDA4MDIxMTI0MDA6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNjU2OC1n
OGIxOWUzNDo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzhiMTllMzQx
ODhhMzJkNjNhN2RhOTRlYThhM2Y1ZTM5YjBjNjYwNTAvZG1lc2cteW9jdG8ta2J1aWxkLTI1
OjIwMTQwODAyMTEyNDAxOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDY1
NjgtZzhiMTllMzQ6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS84YjE5
ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUwL2RtZXNnLXlvY3RvLWtidWls
ZC0yOjIwMTQwODAyMTEyNDAwOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAt
MDY1NjgtZzhiMTllMzQ6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS84
YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUwL2RtZXNnLXlvY3RvLWti
dWlsZC0zMjoyMDE0MDgwMjExMjQwMDppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15b2N0
by1rYnVpbGQtODoyMDE0MDgwMjExMjQwMDppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15
b2N0by12cC0xMToyMDE0MDgwMjExMjYyMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15
b2N0by12cC0xNDoyMDE0MDgwMjExMjYyMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15
b2N0by12cC0zNjoyMDE0MDgwMjExMjYyMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVlMzliMGM2NjA1MC9kbWVzZy15
b2N0by1rYnVpbGQtMTU6MjAxNDA4MDIxMTI0MDI6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5OjMuMTEuMC0wNjU2OC1nOGIxOWUzNDo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5LzhiMTllMzQxODhhMzJkNjNhN2RhOTRlYThhM2Y1ZTM5YjBjNjYwNTAvZG1l
c2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwODAyMTEyNDAyOmkzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOTozLjExLjAtMDY1NjgtZzhiMTllMzQ6Ngova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS84YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2MDUw
L2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwODAyMTEyNDAyOmkzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOTozLjExLjAtMDY1NjgtZzhiMTllMzQ6Ngova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOS84YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIwYzY2
MDUwL2RtZXNnLXlvY3RvLWtidWlsZC03OjIwMTQwODAyMTEyNDAyOmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjExLjAtMDY1NjgtZzhiMTllMzQ6Ngova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS84YjE5ZTM0MTg4YTMyZDYzYTdkYTk0ZWE4YTNmNWUzOWIw
YzY2MDUwL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDgwMjExMjQwMjppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA2NTY4LWc4YjE5ZTM0OjYKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvOGIxOWUzNDE4OGEzMmQ2M2E3ZGE5NGVhOGEzZjVl
MzliMGM2NjA1MC9kbWVzZy15b2N0by1rYnVpbGQtMTQ6MjAxNDA4MDIxMTI0MDM6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNjU2OC1nOGIxOWUzNDo2Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzhiMTllMzQxODhhMzJkNjNhN2RhOTRlYThh
M2Y1ZTM5YjBjNjYwNTAvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwODAyMTEyNDAzOmkz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDY1NjgtZzhiMTllMzQ6NgowOjIw
OjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAyIDExOjI4
OjAyIFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTY2OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCls0NDJlMDk3M2U5MjczYWU4ODMyYWJk
NzBmNTJlZmRlOGI4MzI2MTc4XSBNZXJnZSBicmFuY2ggJ3g4Ni9qdW1wbGFiZWwnIG9mIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOjQ0MmUw
OTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzg6YmlzZWN0LWxpbnV4NgoKMjAx
NC0wOC0wMi0xMToyODowMyA0NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2
MTc4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS00NDJlMDk3M2U5MjczYWU4ODMy
YWJkNzBmNTJlZmRlOGI4MzI2MTc4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDQyZTA5NzNlOTI3M2FlODgzMmFiZDcwZjUyZWZk
ZThiODMyNjE3OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTQ0MmUwOTczZTkyNzNhZTg4
MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4
L3ZtbGludXotMy4xMS4wLTA1ODY5LWc0NDJlMDk3CgoyMDE0LTA4LTAyLTExOjMwOjAzIGRl
dGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMS4yMDQ2OTJdIFNCQy1H
WHggZmxhc2g6IElPOjB4MjU4LTB4MjU5IE1FTToweGRjMDAwLTB4ZGZmZmYKWyAgICAxLjIw
NTU5M10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS4yMDU1
OTNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuMjA2MzA2
XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRk
L21hcC5oOjE0OCEKWyAgICAxLjIwNjMwNl0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9j
b25zdW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAgMS4yMDczNjhdIGlu
dmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgMS4yMDczNjhdIGludmFsaWQgb3Bjb2Rl
OiAwMDAwIFsjMV0gU01QIFNNUCAKClsgICAgMS4yMDgwMjhdIENQVTogMSBQSUQ6IDEgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC0wNTg2OS1nNDQyZTA5NyAjNwpbICAg
IDEuMjA4MDI4XSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAz
LjExLjAtMDU4NjktZzQ0MmUwOTcgIzcKWyAgICAxLjIwOTEzM10gdGFzazogYzAwNDAwMDAg
dGk6IGMwMDNlMDAwIHRhc2sudGk6IGMwMDNlMDAwClsgICAgMS4yMDkxMzNdIHRhc2s6IGMw
MDQwMDAwIHRpOiBjMDAzZTAwMCB0YXNrLnRpOiBjMDAzZTAwMApbICAgIDEuMjA5OTY5XSBF
SVA6IDAwNjA6WzxjMTMwYjE1YT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAgMS4y
MDk5NjldIEVJUDogMDA2MDpbPGMxMzBiMTVhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDEK
WyAgICAxLjIxMDAwNF0gRUlQIGlzIGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApb
ICAgIDEuMjEwMDA0XSBFSVAgaXMgYXQgbXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsg
ICAgMS4yMTAwMDRdIEVBWDogMDAwMDAwMDAgRUJYOiBjMTc0NWUzMCBFQ1g6IDAwMDAwMDAw
IEVEWDogYzAwM2ZlODQKWyAgICAxLjIxMDAwNF0gRUFYOiAwMDAwMDAwMCBFQlg6IGMxNzQ1
ZTMwIEVDWDogMDAwMDAwMDAgRURYOiBjMDAzZmU4NApbICAgIDEuMjEwMDA0XSBFU0k6IGMx
NmJjOTA3IEVESTogYzAwM2ZlYzAgRUJQOiBjMDAzZmVjNCBFU1A6IGMwMDNmZTg0ClsgICAg
MS4yMTAwMDRdIEVTSTogYzE2YmM5MDcgRURJOiBjMDAzZmVjMCBFQlA6IGMwMDNmZWM0IEVT
UDogYzAwM2ZlODQKWyAgICAxLjIxMDAwNF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4
IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMS4yMTAwMDRdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDEuMjEwMDA0XSBDUjA6IDgwMDUwMDMz
IENSMjogMDAwMDAwMDAgQ1IzOiAwMTgyNDAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMS4yMTAw
MDRdIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAwMCBDUjM6IDAxODI0MDAwIENSNDogMDAw
NDA2YjAKWyAgICAxLjIxMDAwNF0gU3RhY2s6ClsgICAgMS4yMTAwMDRdIFN0YWNrOgpbICAg
IDEuMjEwMDA0XSAgMDAwMDAwMDAKWyAgICAxLjIxMDAwNF0gIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwCgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3
M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNnLXlvY3RvLXZwLTE1OjIw
MTQwODAyMTEyODU2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4Njkt
ZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3
M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNnLXlvY3RvLXZwLTIyOjIw
MTQwODAyMTEyODU0OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4Njkt
ZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3
M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNnLXlvY3RvLXZwLTI0OjIw
MTQwODAyMTEyODU1OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4Njkt
ZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3
M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNnLXlvY3RvLXZwLTU6MjAx
NDA4MDIxMTI4NTY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTg2OS1n
NDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ0MmUwOTcz
ZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgvZG1lc2cteW9jdG8tdnAtNjE6MjAx
NDA4MDIxMTI4NTU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTg2OS1n
NDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ0MmUwOTcz
ZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MTA6MjAxNDA4MDIxMTI2Mzk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0w
NTg2OS1nNDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQ0
MmUwOTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMjI6MjAxNDA4MDIxMTI2Mzk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTEuMC0wNTg2OS1nNDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5LzQ0MmUwOTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgvZG1lc2ctcXVh
bnRhbC12cC0xMjoyMDE0MDgwMjExMjkwMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6
My4xMS4wLTA1ODY5LWc0NDJlMDk3OjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvNDQyZTA5NzNlOTI3M2FlODgzMmFiZDcwZjUyZWZkZThiODMyNjE3OC9kbWVzZy1x
dWFudGFsLXZwLTEzOjIwMTQwODAyMTEyOTAzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNn
LXF1YW50YWwtdnAtMTU6MjAxNDA4MDIxMTI5MTA6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5OjMuMTEuMC0wNTg2OS1nNDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5LzQ0MmUwOTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYxNzgvZG1l
c2ctcXVhbnRhbC12cC0xNjoyMDE0MDgwMjExMjkxMTppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xMS4wLTA1ODY5LWc0NDJlMDk3OjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvNDQyZTA5NzNlOTI3M2FlODgzMmFiZDcwZjUyZWZkZThiODMyNjE3OC9k
bWVzZy1xdWFudGFsLXZwLTIwOjIwMTQwODAyMTEyOTA1OmkzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2MTc4
L2RtZXNnLXF1YW50YWwtdnAtNToyMDE0MDgwMjExMjkxMjppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xMS4wLTA1ODY5LWc0NDJlMDk3OjcKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4MjkvNDQyZTA5NzNlOTI3M2FlODgzMmFiZDcwZjUyZWZkZThiODMyNjE3
OC9kbWVzZy1xdWFudGFsLXZwLTg6MjAxNDA4MDIxMTI5MTA6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTEuMC0wNTg2OS1nNDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LzQ0MmUwOTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4YjgzMjYx
NzgvZG1lc2ctcXVhbnRhbC12cC05OjIwMTQwODAyMTEyOTEyOmkzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4MzI2
MTc4L2RtZXNnLXF1YW50YWwtdnAtMjE6MjAxNDA4MDIxMTI5MTM6aTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5OjMuMTEuMC0wNTg2OS1nNDQyZTA5Nzo3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzQ0MmUwOTczZTkyNzNhZTg4MzJhYmQ3MGY1MmVmZGU4Yjgz
MjYxNzgvZG1lc2ctcXVhbnRhbC12cC0zOjIwMTQwODAyMTEyOTEzOmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJlZmRlOGI4
MzI2MTc4L2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwODAyMTEyNjQ5OmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJkNzBmNTJl
ZmRlOGI4MzI2MTc4L2RtZXNnLXF1YW50YWwta2J1aWxkLTI4OjIwMTQwODAyMTEyNjQ5Omkz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6Nwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80NDJlMDk3M2U5MjczYWU4ODMyYWJk
NzBmNTJlZmRlOGI4MzI2MTc4L2RtZXNnLXF1YW50YWwta2J1aWxkLTE1OjIwMTQwODAyMTEy
NjQ5OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDU4NjktZzQ0MmUwOTc6
NwowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAy
IDExOjMwOjM0IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg2L29i
ai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogOTcwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2EzNWM2MzIyZTUyYzU1MGI2
MWEwNGE0NGRmMjdkMjIzOTRlZTBhMmNdIE1lcmdlIHRhZyAnZHJpdmVycy1mb3ItbGludXMn
IG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9hcm0v
YXJtLXNvYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9uZXh0Om1h
c3RlcjphMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjOmJpc2VjdC1s
aW51eDYKCjIwMTQtMDgtMDItMTE6MzA6MzUgYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYy
N2QyMjM5NGVlMGEyYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjktYTM1YzYzMjJl
NTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYwpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EzNWM2MzIyZTUyYzU1MGI2MWEw
NGE0NGRmMjdkMjIzOTRlZTBhMmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS1hMzVjNjMy
MmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjCmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2Qy
MjM5NGVlMGEyYy92bWxpbnV6LTMuMTEuMC0wNTQ3Ny1nYTM1YzYzMgoKMjAxNC0wOC0wMi0x
MTozMjozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuNzA0
MTE0XSBTQkMtR1h4IGZsYXNoOiBJTzoweDI1OC0weDI1OSBNRU06MHhkYzAwMC0weGRmZmZm
ClsgICAgMC43MDU0NjNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpb
ICAgIDAuNzA1NDYzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICAwLjcwNjUzM10ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRl
L2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAgMC43MDY1MzNdIGtlcm5lbCBCVUcgYXQgL2ti
dWlsZC9zcmMvY29uc3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6MTQ4IQpbICAgIDAu
NzA2ODI0XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIApbICAgIDAuNzA2ODI0XSBpbnZh
bGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUCBTTVAgCgpbICAgIDAuNzA2ODI0XSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtMDU0NzctZ2EzNWM2
MzIgIzgKWyAgICAwLjcwNjgyNF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90
IHRhaW50ZWQgMy4xMS4wLTA1NDc3LWdhMzVjNjMyICM4ClsgICAgMC43MDY4MjRdIHRhc2s6
IGMwMDM4MDAwIHRpOiBjMDA0MDAwMCB0YXNrLnRpOiBjMDA0MDAwMApbICAgIDAuNzA2ODI0
XSB0YXNrOiBjMDAzODAwMCB0aTogYzAwNDAwMDAgdGFzay50aTogYzAwNDAwMDAKWyAgICAw
LjcwNjgyNF0gRUlQOiAwMDYwOls8YzEzMGFlMmE+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTog
MApbICAgIDAuNzA2ODI0XSBFSVA6IDAwNjA6WzxjMTMwYWUyYT5dIEVGTEFHUzogMDAwMTAy
NDYgQ1BVOiAwClsgICAgMC43MDY4MjRdIEVJUCBpcyBhdCBtdGRfZG9fY2hpcF9wcm9iZSsw
eDFhLzB4MjAKWyAgICAwLjcwNjgyNF0gRUlQIGlzIGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4
MWEvMHgyMApbICAgIDAuNzA2ODI0XSBFQVg6IDAwMDAwMDAwIEVCWDogYzE3NDVlMzAgRUNY
OiAwMDAwMDAwMCBFRFg6IGMwMDQxZTg0ClsgICAgMC43MDY4MjRdIEVBWDogMDAwMDAwMDAg
RUJYOiBjMTc0NWUzMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwNDFlODQKWyAgICAwLjcwNjgy
NF0gRVNJOiBjMTZiYzgzYiBFREk6IGMwMDQxZWMwIEVCUDogYzAwNDFlYzQgRVNQOiBjMDA0
MWU4NApbICAgIDAuNzA2ODI0XSBFU0k6IGMxNmJjODNiIEVESTogYzAwNDFlYzAgRUJQOiBj
MDA0MWVjNCBFU1A6IGMwMDQxZTg0ClsgICAgMC43MDY4MjRdICBEUzogMDA3YiBFUzogMDA3
YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDAuNzA2ODI0XSAgRFM6IDAwN2Ig
RVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAwLjcwNjgyNF0gQ1Iw
OiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDE4MjQwMDAgQ1I0OiAwMDAwMDZiMApb
ICAgIDAuNzA2ODI0XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMTgyNDAw
MCBDUjQ6IDAwMDAwNmIwClsgICAgMC43MDY4MjRdIFN0YWNrOgpbICAgIDAuNzA2ODI0XSBT
dGFjazoKWyAgICAwLjcwNjgyNF0gIDAwMDAwMDAwClsgICAgMC43MDY4MjRdICAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMAoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0yMDoyMDE0MDgwMjExMzEyODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0zOToyMDE0MDgwMjExMzEyNTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC00MDoyMDE0MDgwMjExMzEyODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC02NDoyMDE0MDgwMjExMzEyODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0xNDoyMDE0MDgwMjExMzEzNjppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0xOToyMDE0MDgwMjExMzEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0yNzoyMDE0MDgwMjExMzEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0zMjoyMDE0MDgwMjExMzEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0zNDoyMDE0MDgwMjExMzEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLTA1NDc3LWdhMzVjNjMyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvYTM1YzYzMjJlNTJjNTUwYjYxYTA0YTQ0ZGYyN2QyMjM5NGVlMGEyYy9kbWVzZy15b2N0
by12cC0zOjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTQ0OjIwMTQwODAyMTEzMTMzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTUxOjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTUyOjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTUzOjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTU0OjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTU1OjIwMTQwODAyMTEzMTM2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTU2OjIwMTQwODAyMTEzMTMzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTU3OjIwMTQwODAyMTEzMTMzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTYyOjIwMTQwODAyMTEzMTMzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtMDU0NzctZ2EzNWM2MzI6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMzVjNjMyMmU1MmM1NTBiNjFhMDRhNDRkZjI3ZDIyMzk0ZWUwYTJjL2RtZXNnLXlvY3Rv
LXZwLTY6MjAxNDA4MDIxMTMxMzY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEu
MC0wNTQ3Ny1nYTM1YzYzMjo4CjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
G1sxOzM1bTIwMTQtMDgtMDIgMTE6MzM6MDUgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290
LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA1Nzgg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpb
NjRjMzUzODY0ZTNmN2NjYmEwYWRlMWJkNmY1NjJmOWEzYmM3ZTY4ZF0gTWVyZ2UgYnJhbmNo
ICdmb3ItdjMuMTInIG9mIGdpdDovL2dpdC5saW5hcm8ub3JnL3Blb3BsZS9tc3p5cHJvd3Nr
aS9saW51eC1kbWEtbWFwcGluZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS9uZXh0Om1hc3Rlcjo2NGMzNTM4NjRlM2Y3Y2NiYTBhZGUxYmQ2ZjU2MmY5YTNiYzdl
NjhkOmJpc2VjdC1saW51eDYKCjIwMTQtMDgtMDItMTE6MzM6MDYgNjRjMzUzODY0ZTNmN2Nj
YmEwYWRlMWJkNmY1NjJmOWEzYmM3ZTY4ZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjktNjRjMzUzODY0ZTNmN2NjYmEwYWRlMWJkNmY1NjJmOWEzYmM3ZTY4ZApDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzY0YzM1Mzg2
NGUzZjdjY2JhMGFkZTFiZDZmNTYyZjlhM2JjN2U2OGQKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS02NGMzNTM4NjRlM2Y3Y2NiYTBhZGUxYmQ2ZjU2MmY5YTNiYzdlNjhkCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNjRjMzUzODY0ZTNmN2NjYmEw
YWRlMWJkNmY1NjJmOWEzYmM3ZTY4ZC92bWxpbnV6LTMuMTEuMC0wNTA0OS1nNjRjMzUzOAoK
MjAxNC0wOC0wMi0xMTozNToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA0MjggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDkgc3RlcHMpCls0NTE1MGM0M2IxYjBjMTZlNjY1ZmQwYTVjZGNjYTEyOGI4MTkyZGIx
XSBkaXJlY3QtaW86IFVzZSByZXR1cm4gZnJvbSBjbXB4Y2hnIHRvIGRlY2lkZSBvZiBhc3Np
Z25tZW50IGhhcHBlbmVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
L25leHQ6bWFzdGVyOjQ1MTUwYzQzYjFiMGMxNmU2NjVmZDBhNWNkY2NhMTI4YjgxOTJkYjE6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wOC0wMi0xMTozNzoxMCA0NTE1MGM0M2IxYjBjMTZlNjY1
ZmQwYTVjZGNjYTEyOGI4MTkyZGIxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS00
NTE1MGM0M2IxYjBjMTZlNjY1ZmQwYTVjZGNjYTEyOGI4MTkyZGIxCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDUxNTBjNDNiMWIw
YzE2ZTY2NWZkMGE1Y2RjY2ExMjhiODE5MmRiMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LTQ1MTUwYzQzYjFiMGMxNmU2NjVmZDBhNWNkY2NhMTI4YjgxOTJkYjEKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1
bWVyL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS00NTE1MGM0M2IxYjBjMTZlNjY1ZmQw
YTVjZGNjYTEyOGI4MTkyZGIxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvNDUxNTBjNDNiMWIwYzE2ZTY2NWZkMGE1Y2RjY2ExMjhiODE5MmRiMS92bWxp
bnV6LTMuMTEuMC0wNTI0Mi1nNDUxNTBjNAoKMjAxNC0wOC0wMi0xMTo0MDoxMCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTE5Li4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMzUgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls3ZWI2OTUy
OWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0NjM1MmM2ZTUyXSBNZXJnZSB0YWcgJ3RyYWNlLTMu
MTInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9y
b3N0ZWR0L2xpbnV4LXRyYWNlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5L25leHQ6bWFzdGVyOjdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2MzUyYzZl
NTI6YmlzZWN0LWxpbnV4NgoKMjAxNC0wOC0wMi0xMTo0Mjo0MSA3ZWI2OTUyOWNiYWY0MjI5
YmFmNTU1OWE0MDBhN2E0NjM1MmM2ZTUyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS03ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0NjM1MmM2ZTUyCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1Mjlj
YmFmNDIyOWJhZjU1NTlhNDAwYTdhNDYzNTJjNmU1Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5LTdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2MzUyYzZlNTIKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFm
NTU1OWE0MDBhN2E0NjM1MmM2ZTUyL3ZtbGludXotMy4xMS4wLTA1MzY0LWc3ZWI2OTUyCgoy
MDE0LTA4LTAyLTExOjQ0OjQxIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJF
ClsgICAxMS4zMjcxOTNdIFNCQy1HWHggZmxhc2g6IElPOjB4MjU4LTB4MjU5IE1FTToweGRj
MDAwLTB4ZGZmZmYKWyAgIDExLjMyODUyNl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAxMS4zMjg1MjZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgMTEuMzI5NTY5XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1
bWVyL2luY2x1ZGUvbGludXgvbXRkL21hcC5oOjE0OCEKWyAgIDExLjMyOTU2OV0ga2VybmVs
IEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDox
NDghClsgICAxMS4zMzAwMzFdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAxMS4z
MzAwMzFdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gU01QIFNNUCAKClsgICAxMS4zMzAw
MzFdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC0w
NTM2NC1nN2ViNjk1MiAjMTAKWyAgIDExLjMzMDAzMV0gQ1BVOiAxIFBJRDogMSBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLTA1MzY0LWc3ZWI2OTUyICMxMApbICAgMTEu
MzMwMDMxXSB0YXNrOiBjMDA0MDAwMCB0aTogYzAwM2UwMDAgdGFzay50aTogYzAwM2UwMDAK
WyAgIDExLjMzMDAzMV0gdGFzazogYzAwNDAwMDAgdGk6IGMwMDNlMDAwIHRhc2sudGk6IGMw
MDNlMDAwClsgICAxMS4zMzAwMzFdIEVJUDogMDA2MDpbPGMxMzBhZTJhPl0gRUZMQUdTOiAw
MDAxMDI0NiBDUFU6IDEKWyAgIDExLjMzMDAzMV0gRUlQOiAwMDYwOls8YzEzMGFlMmE+XSBF
RkxBR1M6IDAwMDEwMjQ2IENQVTogMQpbICAgMTEuMzMwMDMxXSBFSVAgaXMgYXQgbXRkX2Rv
X2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAxMS4zMzAwMzFdIEVJUCBpcyBhdCBtdGRfZG9f
Y2hpcF9wcm9iZSsweDFhLzB4MjAKWyAgIDExLjMzMDAzMV0gRUFYOiAwMDAwMDAwMCBFQlg6
IGMxNzQ1ZTMwIEVDWDogMDAwMDAwMDAgRURYOiBjMDAzZmU4NApbICAgMTEuMzMwMDMxXSBF
QVg6IDAwMDAwMDAwIEVCWDogYzE3NDVlMzAgRUNYOiAwMDAwMDAwMCBFRFg6IGMwMDNmZTg0
ClsgICAxMS4zMzAwMzFdIEVTSTogYzE2YmM4M2IgRURJOiBjMDAzZmVjMCBFQlA6IGMwMDNm
ZWM0IEVTUDogYzAwM2ZlODQKWyAgIDExLjMzMDAzMV0gRVNJOiBjMTZiYzgzYiBFREk6IGMw
MDNmZWMwIEVCUDogYzAwM2ZlYzQgRVNQOiBjMDAzZmU4NApbICAgMTEuMzMwMDMxXSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgIDExLjMzMDAz
MV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAx
MS4zMzAwMzFdIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAwMCBDUjM6IDAxODI0MDAwIENS
NDogMDAwNDA2YjAKWyAgIDExLjMzMDAzMV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDAw
IENSMzogMDE4MjQwMDAgQ1I0OiAwMDA0MDZiMApbICAgMTEuMzMwMDMxXSBTdGFjazoKWyAg
IDExLjMzMDAzMV0gU3RhY2s6ClsgICAxMS4zMzAwMzFdICAwMDAwMDAwMApbICAgMTEuMzMw
MDMxXSAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2MzUyYzZl
NTIvZG1lc2cteW9jdG8tdnAtMTM6MjAxNDA4MDIxMTQzMzI6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0NjM1MmM2
ZTUyL2RtZXNnLXlvY3RvLXZwLTE0OjIwMTQwODAyMTE0MzMxOmkzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6MTAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIyOWJhZjU1NTlhNDAwYTdhNDYzNTJj
NmU1Mi9kbWVzZy15b2N0by12cC0xNzoyMDE0MDgwMjExNDMzMjppMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2MzUy
YzZlNTIvZG1lc2cteW9jdG8tdnAtMjQ6MjAxNDA4MDIxMTQzMzE6aTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0NjM1
MmM2ZTUyL2RtZXNnLXlvY3RvLXZwLTI4OjIwMTQwODAyMTE0MzMxOmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6MTAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIyOWJhZjU1NTlhNDAwYTdhNDYz
NTJjNmU1Mi9kbWVzZy15b2N0by12cC0zMToyMDE0MDgwMjExNDMzMzppMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2
MzUyYzZlNTIvZG1lc2cteW9jdG8tdnAtMzg6MjAxNDA4MDIxMTQzMzE6aTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0
NjM1MmM2ZTUyL2RtZXNnLXlvY3RvLXZwLTM5OjIwMTQwODAyMTE0MzMxOmkzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6MTAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIyOWJhZjU1NTlhNDAwYTdh
NDYzNTJjNmU1Mi9kbWVzZy15b2N0by12cC00MzoyMDE0MDgwMjExNDMzMjppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQwMGE3
YTQ2MzUyYzZlNTIvZG1lc2cteW9jdG8tdnAtNTI6MjAxNDA4MDIxMTQzMzI6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBh
N2E0NjM1MmM2ZTUyL2RtZXNnLXlvY3RvLXZwLTU1OjIwMTQwODAyMTE0MzMyOmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6MTAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIyOWJhZjU1NTlhNDAw
YTdhNDYzNTJjNmU1Mi9kbWVzZy15b2N0by12cC01NjoyMDE0MDgwMjExNDMzMjppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQw
MGE3YTQ2MzUyYzZlNTIvZG1lc2cteW9jdG8tdnAtOToyMDE0MDgwMjExNDMzMTppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5YTQw
MGE3YTQ2MzUyYzZlNTIvZG1lc2cteW9jdG8tdnAtMTI6MjAxNDA4MDIxMTQzNDM6aTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0
MDBhN2E0NjM1MmM2ZTUyL2RtZXNnLXlvY3RvLXZwLTMzOjIwMTQwODAyMTE0MzQzOmkzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6MTAKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIyOWJhZjU1NTlh
NDAwYTdhNDYzNTJjNmU1Mi9kbWVzZy15b2N0by12cC00MToyMDE0MDgwMjExNDM0MzppMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3ZWI2OTUyOjEwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5Y2JhZjQyMjliYWY1NTU5
YTQwMGE3YTQ2MzUyYzZlNTIvZG1lc2cteW9jdG8tdnAtNDk6MjAxNDA4MDIxMTQzNDM6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC0wNTM2NC1nN2ViNjk1MjoxMAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS83ZWI2OTUyOWNiYWY0MjI5YmFmNTU1
OWE0MDBhN2E0NjM1MmM2ZTUyL2RtZXNnLXF1YW50YWwta2J1aWxkLTIwOjIwMTQwODAyMTE0
MTMyOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtMDUzNjQtZzdlYjY5NTI6
MTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvN2ViNjk1MjljYmFmNDIy
OWJhZjU1NTlhNDAwYTdhNDYzNTJjNmU1Mi9kbWVzZy1xdWFudGFsLWtidWlsZC0yNzoyMDE0
MDgwMjExNDEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1MzY0LWc3
ZWI2OTUyOjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzdlYjY5NTI5
Y2JhZjQyMjliYWY1NTU5YTQwMGE3YTQ2MzUyYzZlNTIvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MjoyMDE0MDgwMjExNDEzMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLTA1
MzY0LWc3ZWI2OTUyOjEwCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sx
OzM1bTIwMTQtMDgtMDIgMTE6NDU6MTIgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJp
c2VjdC9saW51eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxMjIgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClszMDA4
OTNiMDhmM2JjNzA1N2E3YTVmODQwNzQwOTBiYTY2YzhiNWNhXSBNZXJnZSB0YWcgJ3hmcy1m
b3ItbGludXMtdjMuMTItcmMxJyBvZiBnaXQ6Ly9vc3Muc2dpLmNvbS94ZnMveGZzCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOjMwMDg5M2Iw
OGYzYmM3MDU3YTdhNWY4NDA3NDA5MGJhNjZjOGI1Y2E6YmlzZWN0LWxpbnV4NgoKMjAxNC0w
OC0wMi0xMTo0NToxMiAzMDA4OTNiMDhmM2JjNzA1N2E3YTVmODQwNzQwOTBiYTY2YzhiNWNh
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS0zMDA4OTNiMDhmM2JjNzA1N2E3YTVm
ODQwNzQwOTBiYTY2YzhiNWNhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvMzAwODkzYjA4ZjNiYzcwNTdhN2E1Zjg0MDc0MDkwYmE2
NmM4YjVjYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTMwMDg5M2IwOGYzYmM3MDU3YTdh
NWY4NDA3NDA5MGJhNjZjOGI1Y2EKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS8zMDA4OTNiMDhmM2JjNzA1N2E3YTVmODQwNzQwOTBiYTY2YzhiNWNhL3Zt
bGludXotMy4xMS4wLTA1MzU1LWczMDA4OTNiCgoyMDE0LTA4LTAyLTExOjQ3OjI0IGRldGVj
dGluZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNo
IG1heSBiZSB0YWcgJ3RyYWNlLTMuMTInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9yb3N0ZWR0L2xpbnV4LXRyYWNlCmxpbmVhci1iaXNlY3Q6
IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBz
dGFydCA3ZWI2OTUyOWNiYWY0MjI5YmFmNTU1OWE0MDBhN2E0NjM1MmM2ZTUyIDMwMDg5M2Iw
OGYzYmM3MDU3YTdhNWY4NDA3NDA5MGJhNjZjOGI1Y2EgLS0KUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgMzAwODkzYi4uLiBNZXJnZSB0YWcgJ3hmcy1mb3ItbGludXMtdjMuMTItcmMx
JyBvZiBnaXQ6Ly9vc3Muc2dpLmNvbS94ZnMveGZzCkhFQUQgaXMgbm93IGF0IDFlYTUyYTku
Li4gTWVyZ2UgJ2piYXJuZXMvYXN5bmMtZmItcHJvYmUnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNjAyMTAKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAyIHN0ZXBzKQpbODM2ZDQ4MWVkN2M5MTE1MmM2MTQ0ZWEzYTMzNjNjYWQz
OTQwYjNlMF0gdHJhY2luZzogS2lsbCB0aGUgIUNPTkZJR19NT0RVTEVTIGNvZGUgaW4gdHJh
Y2VfZXZlbnRzLmMKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYv
b2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9uZXh0
Om1hc3Rlcjo4MzZkNDgxZWQ3YzkxMTUyYzYxNDRlYTNhMzM2M2NhZDM5NDBiM2UwOmJpc2Vj
dC1saW51eDYKCjIwMTQtMDgtMDItMTI6MTE6MDUgODM2ZDQ4MWVkN2M5MTE1MmM2MTQ0ZWEz
YTMzNjNjYWQzOTQwYjNlMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjktODM2ZDQ4
MWVkN2M5MTE1MmM2MTQ0ZWEzYTMzNjNjYWQzOTQwYjNlMApDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzgzNmQ0ODFlZDdjOTExNTJj
NjE0NGVhM2EzMzYzY2FkMzk0MGIzZTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS04MzZk
NDgxZWQ3YzkxMTUyYzYxNDRlYTNhMzM2M2NhZDM5NDBiM2UwCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci9p
Mzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjktODM2ZDQ4MWVkN2M5MTE1MmM2MTQ0ZWEzYTMz
NjNjYWQzOTQwYjNlMAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5LzgzNmQ0ODFlZDdjOTExNTJjNjE0NGVhM2EzMzYzY2FkMzk0MGIzZTAvdm1saW51ei0z
LjExLjAtcmMzLTAwMDA0LWc4MzZkNDgxCgoyMDE0LTA4LTAyLTEyOjE1OjA5IGRldGVjdGlu
ZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzU5MzM4Zjc1NGE1NWYwNzg1
NzM0MmRiY2Q4MTY1MmE0ZjA5MWQ3MmZdIGZ0cmFjZTogRml4IGEgc2xpZ2h0IHJhY2UgaW4g
bW9kaWZ5aW5nIHdoYXQgZnVuY3Rpb24gY2FsbGJhY2sgZ2V0cyB0cmFjZWQKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6NTkzMzhmNzU0YTU1
ZjA3ODU3MzQyZGJjZDgxNjUyYTRmMDkxZDcyZjpiaXNlY3QtbGludXg2CgoyMDE0LTA4LTAy
LTEyOjE1OjQwIDU5MzM4Zjc1NGE1NWYwNzg1NzM0MmRiY2Q4MTY1MmE0ZjA5MWQ3MmYgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LTU5MzM4Zjc1NGE1NWYwNzg1NzM0MmRiY2Q4
MTY1MmE0ZjA5MWQ3MmYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOS81OTMzOGY3NTRhNTVmMDc4NTczNDJkYmNkODE2NTJhNGYwOTFk
NzJmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjktNTkzMzhmNzU0YTU1ZjA3ODU3MzQyZGJj
ZDgxNjUyYTRmMDkxZDcyZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5LzU5MzM4Zjc1NGE1NWYwNzg1NzM0MmRiY2Q4MTY1MmE0ZjA5MWQ3MmYvdm1saW51
ei0zLjExLjAtcmMzLTAwMDIzLWc1OTMzOGY3CgoyMDE0LTA4LTAyLTEyOjE3OjQ4IGRldGVj
dGluZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2EwYTVhMDU2MWY2Mzkw
NWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWVdIGZ0cmFjZS9yY3U6IERvIG5vdCB0cmFjZSBk
ZWJ1Z19sb2NrZGVwX3JjdV9lbmFibGVkKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6YTBhNWEwNTYxZjYzOTA1ZmU5NGM0OWJjNTY3NjE1
ODI5ZjQyY2UxZTpiaXNlY3QtbGludXg2CgoyMDE0LTA4LTAyLTEyOjE4OjI0IGEwYTVhMDU2
MWY2MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5LWEwYTVhMDU2MWY2MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9h
MGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFlCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjktYTBhNWEwNTYxZjYzOTA1ZmU5NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZQpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2MWY2
MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUvdm1saW51ei0zLjExLjAtcmMzCgoyMDE0
LTA4LTAyLTEyOjIwOjQ0IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsg
ICAgMC40OTQ2MTBdIFNCQy1HWHggZmxhc2g6IElPOjB4MjU4LTB4MjU5IE1FTToweGRjMDAw
LTB4ZGZmZmYKWyAgICAwLjQ5NTUxMl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0t
LS0tLS0tClsgICAgMC40OTU1MTJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQpbICAgIDAuNDk2MjI0XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVy
L2luY2x1ZGUvbGludXgvbXRkL21hcC5oOjE0OCEKWyAgICAwLjQ5NjIyNF0ga2VybmVsIEJV
RyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDgh
ClsgICAgMC40OTcyNzZdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgMC40OTcy
NzZdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gU01QIFNNUCAKClsgICAgMC40OTc5Mjld
IENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC1yYzMg
IzYKWyAgICAwLjQ5NzkyOV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xMS4wLXJjMyAjNgpbICAgIDAuNDk4ODg0XSB0YXNrOiBjMDAzODAwMCB0aTog
YzAwNDAwMDAgdGFzay50aTogYzAwNDAwMDAKWyAgICAwLjQ5ODg4NF0gdGFzazogYzAwMzgw
MDAgdGk6IGMwMDQwMDAwIHRhc2sudGk6IGMwMDQwMDAwClsgICAgMC40OTk3MDVdIEVJUDog
MDA2MDpbPGMxMzA1M2VhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgICAwLjQ5OTcw
NV0gRUlQOiAwMDYwOls8YzEzMDUzZWE+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAg
IDAuNTAwMDA1XSBFSVAgaXMgYXQgbXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAg
MC41MDAwMDVdIEVJUCBpcyBhdCBtdGRfZG9fY2hpcF9wcm9iZSsweDFhLzB4MjAKWyAgICAw
LjUwMDAwNV0gRUFYOiAwMDAwMDAwMCBFQlg6IGMxNzM3ZmQwIEVDWDogMDAwMDAwMDAgRURY
OiBjMDA0MWU4NApbICAgIDAuNTAwMDA1XSBFQVg6IDAwMDAwMDAwIEVCWDogYzE3MzdmZDAg
RUNYOiAwMDAwMDAwMCBFRFg6IGMwMDQxZTg0ClsgICAgMC41MDAwMDVdIEVTSTogYzE2YjA5
NjIgRURJOiBjMDA0MWVjMCBFQlA6IGMwMDQxZWM0IEVTUDogYzAwNDFlODQKWyAgICAwLjUw
MDAwNV0gRVNJOiBjMTZiMDk2MiBFREk6IGMwMDQxZWMwIEVCUDogYzAwNDFlYzQgRVNQOiBj
MDA0MWU4NApbICAgIDAuNTAwMDA1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6
IDAwMDAgU1M6IDAwNjgKWyAgICAwLjUwMDAwNV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAw
MGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC41MDAwMDVdIENSMDogODAwNTAwMzMgQ1Iy
OiAwMDAwMDAwMCBDUjM6IDAxODE2MDAwIENSNDogMDAwNDA2YjAKWyAgICAwLjUwMDAwNV0g
Q1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDAwIENSMzogMDE4MTYwMDAgQ1I0OiAwMDA0MDZi
MApbICAgIDAuNTAwMDA1XSBTdGFjazoKWyAgICAwLjUwMDAwNV0gU3RhY2s6ClsgICAgMC41
MDAwMDVdICAwMDAwMDAwMApbICAgIDAuNTAwMDA1XSAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAKCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2MWY2
MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIw
MTQwODAyMTIxNzE2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzOjYK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYTBhNWEwNTYxZjYzOTA1ZmU5
NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZS9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA4MDIx
MjE3MzA6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzM6Ngova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1
Njc2MTU4MjlmNDJjZTFlL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDgwMjEyMTczMDpp
Mzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMzo2Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2MWY2MzkwNWZlOTRjNDliYzU2NzYxNTgy
OWY0MmNlMWUvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA4MDIxMjE3MjM6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzM6Ngova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFl
L2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwODAyMTIxNzIzOmkzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOTozLjExLjAtcmMzOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4MjkvYTBhNWEwNTYxZjYzOTA1ZmU5NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZS9kbWVzZy15
b2N0by1rYnVpbGQtMTI6MjAxNDA4MDIxMjE3Mzg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIw
ODI5OjMuMTEuMC1yYzM6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9h
MGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFlL2RtZXNnLXlvY3RvLWti
dWlsZC0xNjoyMDE0MDgwMjEyMTczODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLXJjMzo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2
MWY2MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUvZG1lc2cteW9jdG8ta2J1aWxkLTE5
OjIwMTQwODAyMTIxNzM4OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMz
OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYTBhNWEwNTYxZjYzOTA1
ZmU5NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZS9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA4
MDIxMjE3Mzg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzM6Ngova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5
YmM1Njc2MTU4MjlmNDJjZTFlL2RtZXNnLXlvY3RvLWtidWlsZC0zMjoyMDE0MDgwMjEyMTcz
ODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMzo2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2MWY2MzkwNWZlOTRjNDliYzU2NzYx
NTgyOWY0MmNlMWUvZG1lc2cteW9jdG8tdnAtMTU6MjAxNDA4MDIxMjE5NTU6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzM6Ngova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFl
L2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA4MDIxMjE5NTQ6aTM4Ni1yYW5kY29uZmlnLXgxLTA4
MDIwODI5OjMuMTEuMC1yYzM6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFlL2RtZXNnLXlvY3Rv
LXZwLTM1OjIwMTQwODAyMTIxOTU1OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjEx
LjAtcmMzOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYTBhNWEwNTYx
ZjYzOTA1ZmU5NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZS9kbWVzZy15b2N0by12cC00MDoyMDE0
MDgwMjEyMjAwMzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMzo2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2EwYTVhMDU2MWY2MzkwNWZlOTRj
NDliYzU2NzYxNTgyOWY0MmNlMWUvZG1lc2cteW9jdG8tdnAtNTM6MjAxNDA4MDIxMjE5NTQ6
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzM6Ngova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS9hMGE1YTA1NjFmNjM5MDVmZTk0YzQ5YmM1Njc2MTU4
MjlmNDJjZTFlL2RtZXNnLXlvY3RvLXZwLTEzOjIwMTQwODAyMTIyMDA3OmkzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvYTBhNWEwNTYxZjYzOTA1ZmU5NGM0OWJjNTY3NjE1ODI5ZjQyY2UxZS9k
bWVzZy15b2N0by12cC0zNzoyMDE0MDgwMjEyMjAwNzppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xMS4wLXJjMzo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
L2EwYTVhMDU2MWY2MzkwNWZlOTRjNDliYzU2NzYxNTgyOWY0MmNlMWUvZG1lc2cteW9jdG8t
dnAtNTA6MjAxNDA4MDIxMjIwMDc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEu
MC1yYzM6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hMGE1YTA1NjFm
NjM5MDVmZTk0YzQ5YmM1Njc2MTU4MjlmNDJjZTFlL2RtZXNnLXlvY3RvLXZwLTUyOjIwMTQw
ODAyMTIyMDA3OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzOjYKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYTBhNWEwNTYxZjYzOTA1ZmU5NGM0
OWJjNTY3NjE1ODI5ZjQyY2UxZS9kbWVzZy15b2N0by12cC02OjIwMTQwODAyMTIyMDA3Omkz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzOjYKMDoyMDoyMCBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0wMiAxMjoyMTozNCBSRVBFQVQg
Q09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDAgc3RlcHMpClthZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUz
YWY1XSB4ODYtMzIsIGZ0cmFjZTogRml4IHN0YXRpYyBmdHJhY2Ugd2hlbiBlYXJseSBtaWNy
b2NvZGUgaXMgZW5hYmxlZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS9uZXh0Om1hc3RlcjphZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUzYWY1
OmJpc2VjdC1saW51eDYKCjIwMTQtMDgtMDItMTI6MjE6NDkgYWYwNThhYjA0ZDNkMTEzODNl
NTE1OTEzMmZjNzhhMzcwMGJlM2FmNSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkt
YWYwNThhYjA0ZDNkMTEzODNlNTE1OTEzMmZjNzhhMzcwMGJlM2FmNQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2FmMDU4YWIwNGQz
ZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS1hZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUzYWY1Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1
OTEzMmZjNzhhMzcwMGJlM2FmNS92bWxpbnV6LTMuMTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWIK
CjIwMTQtMDgtMDItMTI6MjM6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxV
UkUKWyAgIDEyLjAzNjkxOF0gU0JDLUdYeCBmbGFzaDogSU86MHgyNTgtMHgyNTkgTUVNOjB4
ZGMwMDAtMHhkZmZmZgpbICAgMTIuMDM4MjIzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgIDEyLjAzODIyM10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAxMi4wMzkyNTZdIGtlcm5lbCBCVUcgYXQgL2tidWlsZC9zcmMvY29u
c3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6MTQ4IQpbICAgMTIuMDM5MjU2XSBrZXJu
ZWwgQlVHIGF0IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvbXRkL21hcC5o
OjE0OCEKWyAgIDEyLjA0MDAxMF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSAKWyAgIDEy
LjA0MDAxMF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAgU01QIAoKWyAgIDEyLjA0
MDAxMF0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4w
LXJjMy0wMDAyNC1nYWYwNThhYiAjMTMKWyAgIDEyLjA0MDAxMF0gQ1BVOiAxIFBJRDogMSBD
b21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLXJjMy0wMDAyNC1nYWYwNThhYiAj
MTMKWyAgIDEyLjA0MDAxMF0gdGFzazogYzAwNDAwMDAgdGk6IGMwMDNlMDAwIHRhc2sudGk6
IGMwMDNlMDAwClsgICAxMi4wNDAwMTBdIHRhc2s6IGMwMDQwMDAwIHRpOiBjMDAzZTAwMCB0
YXNrLnRpOiBjMDAzZTAwMApbICAgMTIuMDQwMDEwXSBFSVA6IDAwNjA6WzxjMTMwNTNmYT5d
IEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAxMi4wNDAwMTBdIEVJUDogMDA2MDpbPGMx
MzA1M2ZhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDEKWyAgIDEyLjA0MDAxMF0gRUlQIGlz
IGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTIuMDQwMDEwXSBFSVAgaXMg
YXQgbXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAxMi4wNDAwMTBdIEVBWDogMDAw
MDAwMDAgRUJYOiBjMTczN2ZkMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwM2ZlODQKWyAgIDEy
LjA0MDAxMF0gRUFYOiAwMDAwMDAwMCBFQlg6IGMxNzM3ZmQwIEVDWDogMDAwMDAwMDAgRURY
OiBjMDAzZmU4NApbICAgMTIuMDQwMDEwXSBFU0k6IGMxNmIwOWE1IEVESTogYzAwM2ZlYzAg
RUJQOiBjMDAzZmVjNCBFU1A6IGMwMDNmZTg0ClsgICAxMi4wNDAwMTBdIEVTSTogYzE2YjA5
YTUgRURJOiBjMDAzZmVjMCBFQlA6IGMwMDNmZWM0IEVTUDogYzAwM2ZlODQKWyAgIDEyLjA0
MDAxMF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4Clsg
ICAxMi4wNDAwMTBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzog
MDA2OApbICAgMTIuMDQwMDEwXSBDUjA6IDgwMDUwMDMzIENSMjogZmZmZmZmZmYgQ1IzOiAw
MTgxNjAwMCBDUjQ6IDAwMDQwNmIwClsgICAxMi4wNDAwMTBdIENSMDogODAwNTAwMzMgQ1Iy
OiBmZmZmZmZmZiBDUjM6IDAxODE2MDAwIENSNDogMDAwNDA2YjAKWyAgIDEyLjA0MDAxMF0g
U3RhY2s6ClsgICAxMi4wNDAwMTBdIFN0YWNrOgpbICAgMTIuMDQwMDEwXSAgMDAwMDAwMDAK
WyAgIDEyLjA0MDAxMF0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3
OGEzNzAwYmUzYWY1L2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQwODAyMTIyMzI3OmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAwMDI0LWdhZjA1OGFiOjEzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2FmMDU4YWIwNGQzZDExMzgzZTUxNTkx
MzJmYzc4YTM3MDBiZTNhZjUvZG1lc2cteW9jdG8tdnAtNjM6MjAxNDA4MDIxMjIzMjQ6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNl
NTE1OTEzMmZjNzhhMzcwMGJlM2FmNS9kbWVzZy15b2N0by12cC0xNDoyMDE0MDgwMjEyMjMz
MjppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMy0wMDAyNC1nYWYwNThh
YjoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2Qx
MTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUzYWY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTE2OjIw
MTQwODAyMTIyMTIzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAw
MDI0LWdhZjA1OGFiOjEzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Fm
MDU4YWIwNGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMTg6MjAxNDA4MDIxMjIxMjM6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1OTEzMmZjNzhhMzcwMGJlM2FmNS9kbWVz
Zy1xdWFudGFsLWtidWlsZC0xOjIwMTQwODAyMTIyMTIzOmkzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOTozLjExLjAtcmMzLTAwMDI0LWdhZjA1OGFiOjEzCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5L2FmMDU4YWIwNGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBi
ZTNhZjUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjA6MjAxNDA4MDIxMjIxMjM6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1OTEz
MmZjNzhhMzcwMGJlM2FmNS9kbWVzZy1xdWFudGFsLWtidWlsZC0yMjoyMDE0MDgwMjEyMjEy
MzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMy0wMDAyNC1nYWYwNThh
YjoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2Qx
MTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUzYWY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTI0OjIw
MTQwODAyMTIyMTE3OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAw
MDI0LWdhZjA1OGFiOjEzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Fm
MDU4YWIwNGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMjY6MjAxNDA4MDIxMjIxMjM6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1OTEzMmZjNzhhMzcwMGJlM2FmNS9kbWVz
Zy1xdWFudGFsLWtidWlsZC0yODoyMDE0MDgwMjEyMjEyMzppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xMS4wLXJjMy0wMDAyNC1nYWYwNThhYjoxMwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3OGEzNzAw
YmUzYWY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTI5OjIwMTQwODAyMTIyMTIzOmkzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAwMDI0LWdhZjA1OGFiOjEzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2FmMDU4YWIwNGQzZDExMzgzZTUxNTkx
MzJmYzc4YTM3MDBiZTNhZjUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjoyMDE0MDgwMjEyMjEy
MzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xMS4wLXJjMy0wMDAyNC1nYWYwNThh
YjoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2Qx
MTM4M2U1MTU5MTMyZmM3OGEzNzAwYmUzYWY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTMwOjIw
MTQwODAyMTIyMTIzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAw
MDI0LWdhZjA1OGFiOjEzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2Fm
MDU4YWIwNGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMzE6MjAxNDA4MDIxMjIxMjM6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1OTEzMmZjNzhhMzcwMGJlM2FmNS9kbWVz
Zy1xdWFudGFsLWtidWlsZC0zMjoyMDE0MDgwMjEyMjEyMzppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xMS4wLXJjMy0wMDAyNC1nYWYwNThhYjoxMwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS9hZjA1OGFiMDRkM2QxMTM4M2U1MTU5MTMyZmM3OGEzNzAw
YmUzYWY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTY6MjAxNDA4MDIxMjIxMjM6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzMtMDAwMjQtZ2FmMDU4YWI6MTMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYWYwNThhYjA0ZDNkMTEzODNlNTE1OTEz
MmZjNzhhMzcwMGJlM2FmNS9kbWVzZy1xdWFudGFsLWtidWlsZC05OjIwMTQwODAyMTIyMTIz
OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjExLjAtcmMzLTAwMDI0LWdhZjA1OGFi
OjEzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L2FmMDU4YWIwNGQzZDEx
MzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTM6MjAx
NDA4MDIxMjIxMjc6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTEuMC1yYzMtMDAw
MjQtZ2FmMDU4YWI6MTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvYWYw
NThhYjA0ZDNkMTEzODNlNTE1OTEzMmZjNzhhMzcwMGJlM2FmNS9kbWVzZy1xdWFudGFsLWti
dWlsZC0xNToyMDE0MDgwMjEyMjEyNzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4x
MS4wLXJjMy0wMDAyNC1nYWYwNThhYjoxMwowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzChtbMTszNW0yMDE0LTA4LTAyIDEyOjI0OjIwIFJFUEVBVCBDT1VOVDogMjAgICMg
L2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmFmMDU4YWIw
NGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUgaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IGFmMDU4YWIwNGQzZDExMzgzZTUxNTkxMzJmYzc4YTM3MDBiZTNhZjUKQXV0
aG9yOiBILiBQZXRlciBBbnZpbiA8aHBhQGxpbnV4LmludGVsLmNvbT4KRGF0ZTogICBGcmkg
QXVnIDMwIDE3OjI5OjI5IDIwMTMgLTA3MDAKCiAgICB4ODYtMzIsIGZ0cmFjZTogRml4IHN0
YXRpYyBmdHJhY2Ugd2hlbiBlYXJseSBtaWNyb2NvZGUgaXMgZW5hYmxlZAogICAgCiAgICBF
YXJseSBtaWNyb2NvZGUgbG9hZGluZyBydW5zIEMgY29kZSBiZWZvcmUgcGFnaW5nIGlzIGVu
YWJsZWQgb24gMzIKICAgIGJpdHMuICBTaW5jZSBmdHJhY2UgcHV0cyBhIGhvb2sgaW50byBl
dmVyeSBmdW5jdGlvbiwgdGhhdCBob29rIG5lZWRzCiAgICB0byBiZSBzYWZlIHRvIGV4ZWN1
dGUgaW4gdGhlIHByZS1wYWdpbmcgZW52aXJvbm1lbnQuICBUaGlzIGlzCiAgICBjdXJyZW50
bHkgdHJ1ZSBmb3IgZHluYW1pYyBmdHJhY2UgYnV0IG5vdCBmb3Igc3RhdGljIGZ0cmFjZS4K
ICAgIAogICAgU3RhdGljIGZ0cmFjZSBpcyBvYnNvbGVzY2VudCBhbmQgYXNzdW1lZCB0byBu
b3QgYmUKICAgIHBlcmZvcm1hbmNlLWNyaXRpY2FsLCBzbyB3ZSBjYW4gc2ltcGx5IHRlc3Qg
dGhhdCB0aGUgc3RhY2sgcG9pbnRlcgogICAgZmFsbHMgd2l0aGluIHRoZSB2YWxpZCByYW5n
ZSBvZiBrZXJuZWwgYWRkcmVzc2VzLgogICAgCiAgICBSZXBvcnRlZC1ieTogSmFuIEtpc3pr
YSA8amFuLmtpc3prYUBzaWVtZW5zLmNvbT4KICAgIFRlc3RlZC1ieTogSmFuIEtpc3prYSA8
amFuLmtpc3prYUBzaWVtZW5zLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFu
dmluIDxocGFAbGludXguaW50ZWwuY29tPgogICAgU2lnbmVkLW9mZi1ieTogU3RldmVuIFJv
c3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+Cgo6MDQwMDAwIDA0MDAwMCAzNTQ1N2I4Mzhk
ZGVhN2IzYWU4YWNkZjE5MTg5ZWMxMzUwNjRkZWY3IDk5YmViZmYxMzhmMjBhZmQ2NzI2ZTA5
YTIzNDU4ZmNmY2ZhMmZlOWIgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBhZjA1OGFiLi4uIHg4Ni0zMiwgZnRyYWNlOiBGaXggc3RhdGlj
IGZ0cmFjZSB3aGVuIGVhcmx5IG1pY3JvY29kZSBpcyBlbmFibGVkCkhFQUQgaXMgbm93IGF0
IDU5MzM4ZjcuLi4gZnRyYWNlOiBGaXggYSBzbGlnaHQgcmFjZSBpbiBtb2RpZnlpbmcgd2hh
dCBmdW5jdGlvbiBjYWxsYmFjayBnZXRzIHRyYWNlZApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5L25leHQ6bWFzdGVyOjU5
MzM4Zjc1NGE1NWYwNzg1NzM0MmRiY2Q4MTY1MmE0ZjA5MWQ3MmY6YmlzZWN0LWxpbnV4NgoK
MjAxNC0wOC0wMi0xMjoyNDoyMyA1OTMzOGY3NTRhNTVmMDc4NTczNDJkYmNkODE2NTJhNGYw
OTFkNzJmIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzU5MzM4
Zjc1NGE1NWYwNzg1NzM0MmRiY2Q4MTY1MmE0ZjA5MWQ3MmYvdm1saW51ei0zLjExLjAtcmMz
LTAwMDIzLWc1OTMzOGY3CgoyMDE0LTA4LTAyLTEyOjI0OjIzIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uLi4uCTEuCTI4Lgk1Mwk1OS4JNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgNTkzMzhmNy4uLiBmdHJhY2U6IEZpeCBhIHNsaWdodCByYWNlIGlu
IG1vZGlmeWluZyB3aGF0IGZ1bmN0aW9uIGNhbGxiYWNrIGdldHMgdHJhY2VkCkhFQUQgaXMg
bm93IGF0IDQxOThjZjMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIw
MTQwODAxCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6NDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNj
MjMxOWNlZDc3NDIwMTpiaXNlY3QtbGludXg2CiBURVNUIEZBSUxVUkUKWyAgIDExLjA4MTIy
MV0gU0JDLUdYeCBmbGFzaDogSU86MHgyNTgtMHgyNTkgTUVNOjB4ZGMwMDAtMHhkZmZmZgpb
ICAgMTEuMDgzMjUxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
IDExLjA4MzI1MV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAx
MS4wODQ2ODNdIGtlcm5lbCBCVUcgYXQgaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6MTQ4IQpb
ICAgMTEuMDg0NjgzXSBrZXJuZWwgQlVHIGF0IGluY2x1ZGUvbGludXgvbXRkL21hcC5oOjE0
OCEKWyAgIDExLjA4NzEwNF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSAKWyAgIDExLjA4
NzEwNF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAgU01QIAoKWyAgIDExLjA4ODUx
N10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJj
Ny1uZXh0LTIwMTQwODAxICMxOApbICAgMTEuMDg4NTE3XSBDUFU6IDAgUElEOiAxIENvbW06
IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM3LW5leHQtMjAxNDA4MDEgIzE4Clsg
ICAxMS4wOTEwODFdIHRhc2s6IGMwMDQ4MDAwIHRpOiBjMDA0NDAwMCB0YXNrLnRpOiBjMDA0
NDAwMApbICAgMTEuMDkxMDgxXSB0YXNrOiBjMDA0ODAwMCB0aTogYzAwNDQwMDAgdGFzay50
aTogYzAwNDQwMDAKWyAgIDExLjA5MTA4MV0gRUlQOiAwMDYwOls8YzEzMzFiY2E+XSBFRkxB
R1M6IDAwMDEwMjQ2IENQVTogMApbICAgMTEuMDkxMDgxXSBFSVA6IDAwNjA6WzxjMTMzMWJj
YT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAxMS4wOTEwODFdIEVJUCBpcyBhdCBt
dGRfZG9fY2hpcF9wcm9iZSsweDFhLzB4MjAKWyAgIDExLjA5MTA4MV0gRUlQIGlzIGF0IG10
ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTEuMDkxMDgxXSBFQVg6IDAwMDAwMDAw
IEVCWDogYzE3ZjBiMzAgRUNYOiAwMDAwMDAwMCBFRFg6IGMwMDQ1ZTg0ClsgICAxMS4wOTEw
ODFdIEVBWDogMDAwMDAwMDAgRUJYOiBjMTdmMGIzMCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAw
NDVlODQKWyAgIDExLjA5MTA4MV0gRVNJOiBjMTcxOWM0MSBFREk6IGMwMDQ1ZWMwIEVCUDog
YzAwNDVlYzQgRVNQOiBjMDA0NWU4NApbICAgMTEuMDkxMDgxXSBFU0k6IGMxNzE5YzQxIEVE
STogYzAwNDVlYzAgRUJQOiBjMDA0NWVjNCBFU1A6IGMwMDQ1ZTg0ClsgICAxMS4wOTEwODFd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgMTEu
MDkxMDgxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgK
WyAgIDExLjA5MTA4MV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDAwIENSMzogMDE4ZTIw
MDAgQ1I0OiAwMDA0MDZiMApbICAgMTEuMDkxMDgxXSBDUjA6IDgwMDUwMDMzIENSMjogMDAw
MDAwMDAgQ1IzOiAwMThlMjAwMCBDUjQ6IDAwMDQwNmIwClsgICAxMS4wOTEwODFdIFN0YWNr
OgpbICAgMTEuMDkxMDgxXSBTdGFjazoKWyAgIDExLjA5MTA4MV0gIDAwMDAwMDAwClsgICAx
MS4wOTEwODFdICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNl
ZDc3NDIwMS9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA4MDIxMDE0MjU6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxOAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNk
M2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3RvLXZwLTYzOjIwMTQwODAyMTAxNjQ1OmkzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LW5leHQtMjAxNDA4MDE6MTgKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMz
ZjgzZDNjMjMxOWNlZDc3NDIwMS9kbWVzZy15b2N0by1rYnVpbGQtMTQ6MjAxNDA4MDIxMDE0
MjY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgw
MToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRkZGVh
NDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3RvLXZwLTU6MjAxNDA4MDIx
MDE2NDU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0
MDgwMToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRk
ZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3RvLWtidWlsZC03OjIw
MTQwODAyMTAxNDI2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LW5l
eHQtMjAxNDA4MDE6MTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDE5
OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMS9kbWVzZy15b2N0by1rYnVp
bGQtMjc6MjAxNDA4MDIxMDE0MjU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYu
MC1yYzctbmV4dC0yMDE0MDgwMToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlv
Y3RvLXZwLTE2OjIwMTQwODAyMTAxNjUzOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOToz
LjE2LjAtcmM3LW5leHQtMjAxNDA4MDE6MTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMS9kbWVz
Zy15b2N0by12cC00OToyMDE0MDgwMjEwMTY1NDppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
Mjk6My4xNi4wLXJjNy1uZXh0LTIwMTQwODAxOjE4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5LzQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2QzYzIzMTljZWQ3NzQyMDEv
ZG1lc2cteW9jdG8ta2J1aWxkLTM6MjAxNDA4MDIxMDE0Mjg6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxOAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2Vk
Nzc0MjAxL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDgwMjEwMTQyODppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy1uZXh0LTIwMTQwODAxOjE4Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2Qz
YzIzMTljZWQ3NzQyMDEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjg6MjAxNDA4MDIwODMyMzA6
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMTox
OAowOjExOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA0
MTk4Y2YzIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDgwMQoKPT09
PT09PT09IGxpbnVzL21hc3RlciA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgNDE5OGNmMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA4
MDEKSEVBRCBpcyBub3cgYXQgNmYwOTI4MC4uLiBNZXJnZSB0YWcgJ3BtK2FjcGktMy4xNi1y
YzgnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9y
YWZhZWwvbGludXgtcG0KbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS9saW51czptYXN0ZXI6NmYwOTI4MDM2YmNiZDhkZDJl
YmVlOTIwMTU4MGRhOGJjYzBhODFhZjpiaXNlY3QtbGludXg2CgoyMDE0LTA4LTAyLTEyOjQz
OjUxIDZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXgxLTA4MDIwODI5LTZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThi
Y2MwYTgxYWYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjktNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRh
OGJjYzBhODFhZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LTZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5
MjAxNTgwZGE4YmNjMGE4MWFmL3ZtbGludXotMy4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MAoK
MjAxNC0wOC0wMi0xMjo0Nzo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVS
RQpbICAgMTAuODY3MTYzXSBTQkMtR1h4IGZsYXNoOiBJTzoweDI1OC0weDI1OSBNRU06MHhk
YzAwMC0weGRmZmZmClsgICAxMC44Njg0MzddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0t
LS0tLS0tLS0tLQpbICAgMTAuODY4NDM3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0t
LS0tLS0tLS0KWyAgIDEwLjg2OTQ0NV0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25z
dW1lci9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaDoxNDghClsgICAxMC44Njk0NDVdIGtlcm5l
bCBCVUcgYXQgL2tidWlsZC9zcmMvY29uc3VtZXIvaW5jbHVkZS9saW51eC9tdGQvbWFwLmg6
MTQ4IQpbICAgMTAuODcwMDEyXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIApbICAgMTAu
ODcwMDEyXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUCBTTVAgCgpbICAgMTAuODcw
MDEyXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAt
cmM3LTAwMDg0LWc2ZjA5MjgwICM3ClsgICAxMC44NzAwMTJdIENQVTogMSBQSUQ6IDEgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzctMDAwODQtZzZmMDkyODAgIzcK
WyAgIDEwLjg3MDAxMl0gdGFzazogYzAwNDgwMDAgdGk6IGMwMDQ0MDAwIHRhc2sudGk6IGMw
MDQ0MDAwClsgICAxMC44NzAwMTJdIHRhc2s6IGMwMDQ4MDAwIHRpOiBjMDA0NDAwMCB0YXNr
LnRpOiBjMDA0NDAwMApbICAgMTAuODcwMDEyXSBFSVA6IDAwNjA6WzxjMTMyYzRjYT5dIEVG
TEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAxMC44NzAwMTJdIEVJUDogMDA2MDpbPGMxMzJj
NGNhPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDEKWyAgIDEwLjg3MDAxMl0gRUlQIGlzIGF0
IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTAuODcwMDEyXSBFSVAgaXMgYXQg
bXRkX2RvX2NoaXBfcHJvYmUrMHgxYS8weDIwClsgICAxMC44NzAwMTJdIEVBWDogMDAwMDAw
MDAgRUJYOiBjMTdhNWM5MCBFQ1g6IDAwMDAwMDAwIEVEWDogYzAwNDVlODQKWyAgIDEwLjg3
MDAxMl0gRUFYOiAwMDAwMDAwMCBFQlg6IGMxN2E1YzkwIEVDWDogMDAwMDAwMDAgRURYOiBj
MDA0NWU4NApbICAgMTAuODcwMDEyXSBFU0k6IGMxNmQ4ZmMzIEVESTogYzAwNDVlYzAgRUJQ
OiBjMDA0NWVjNCBFU1A6IGMwMDQ1ZTg0ClsgICAxMC44NzAwMTJdIEVTSTogYzE2ZDhmYzMg
RURJOiBjMDA0NWVjMCBFQlA6IGMwMDQ1ZWM0IEVTUDogYzAwNDVlODQKWyAgIDEwLjg3MDAx
Ml0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAx
MC44NzAwMTJdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2
OApbICAgMTAuODcwMDEyXSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMTg4
ZjAwMCBDUjQ6IDAwMDQwNmIwClsgICAxMC44NzAwMTJdIENSMDogODAwNTAwMzMgQ1IyOiAw
MDAwMDAwMCBDUjM6IDAxODhmMDAwIENSNDogMDAwNDA2YjAKWyAgIDEwLjg3MDAxMl0gU3Rh
Y2s6ClsgICAxMC44NzAwMTJdIFN0YWNrOgpbICAgMTAuODcwMDEyXSAgMDAwMDAwMDAKWyAg
IDEwLjg3MDAxMl0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4
YmNjMGE4MWFmL2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDgwMjEyNDUxNDppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTky
MDE1ODBkYThiY2MwYTgxYWYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTk6MjAxNDA4MDIxMjQ1
Mjg6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDky
ODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2Jk
OGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXF1YW50YWwta2J1aWxkLTMwOjIw
MTQwODAyMTI0NTI0OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LTAw
MDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNmYw
OTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy1xdWFudGFsLXZw
LTEzOjIwMTQwODAyMTI0NzQ4OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAt
cmM3LTAwMDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4
MjkvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy15b2N0
by1rYnVpbGQtMjE6MjAxNDA4MDIxMjQ1MjQ6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2Rt
ZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDgwMjEyNDUzNTppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2Mw
YTgxYWYvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwODAyMTI0NTIxOmkzODYtcmFuZGNv
bmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LTAwMDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4
MGRhOGJjYzBhODFhZi9kbWVzZy15b2N0by12cC00MjoyMDE0MDgwMjEyNDc0NDppMzg2LXJh
bmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTky
MDE1ODBkYThiY2MwYTgxYWYvZG1lc2cteW9jdG8tdnAtNDY6MjAxNDA4MDIxMjQ3MzU6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmVi
ZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlvY3RvLXZwLTU6MjAxNDA4MDIxMjQ3NDA6
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6
Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRk
MmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlvY3RvLXZwLTg6MjAxNDA4MDIxMjQ3
NTY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDky
ODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2Jk
OGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlvY3RvLXZwLTI2OjIwMTQwODAy
MTI0ODAwOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LTAwMDg0LWc2
ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNmYwOTI4MDM2
YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy1xdWFudGFsLWtidWlsZC0z
MDoyMDE0MDgwMjEyNDU0NTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJj
Ny0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYvZG1lc2cteW9jdG8t
a2J1aWxkLTc6MjAxNDA4MDIxMjQ1NDM6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMu
MTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0w
ODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNn
LXlvY3RvLXZwLTI3OjIwMTQwODAyMTI0ODA5OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OTozLjE2LjAtcmM3LTAwMDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9k
bWVzZy15b2N0by12cC00MjoyMDE0MDgwMjEyNDgwNTppMzg2LXJhbmRjb25maWcteDEtMDgw
MjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgx
YWYvZG1lc2cteW9jdG8tdnAtNjE6MjAxNDA4MDIxMjQ4MDU6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNj
MGE4MWFmL2RtZXNnLXlvY3RvLXZwLTg6MjAxNDA4MDIxMjQ4MDg6aTM4Ni1yYW5kY29uZmln
LXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4
YmNjMGE4MWFmL2RtZXNnLXF1YW50YWwta2J1aWxkLTE5OjIwMTQwODAyMTI0NTQ5OmkzODYt
cmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LTAwMDg0LWc2ZjA5MjgwOjcKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNmYwOTI4MDM2YmNiZDhkZDJlYmVl
OTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA4MDIxMjQ1
NTY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDky
ODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2Jk
OGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlvY3RvLWtidWlsZC02OjIwMTQw
ODAyMTI0NTU1OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LTAwMDg0
LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNmYwOTI4
MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy15b2N0by1rYnVpbGQt
NzoyMDE0MDgwMjEyNDU1MzppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJj
Ny0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5
LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYvZG1lc2cteW9jdG8t
dnAtMjY6MjAxNDA4MDIxMjQ4MTk6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYu
MC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlv
Y3RvLXZwLTUyOjIwMTQwODAyMTI0ODIwOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOToz
LjE2LjAtcmM3LTAwMDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4MjkvNmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVz
Zy1xdWFudGFsLWtidWlsZC0xOToyMDE0MDgwMjEyNDYwOTppMzg2LXJhbmRjb25maWcteDEt
MDgwMjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYwOTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2Mw
YTgxYWYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzA6MjAxNDA4MDIxMjQ2MDY6aTM4Ni1yYW5k
Y29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6Nwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRkMmViZWU5MjAx
NTgwZGE4YmNjMGE4MWFmL2RtZXNnLXF1YW50YWwta2J1aWxkLTU6MjAxNDA4MDIxMjQ2MDI6
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAwODQtZzZmMDkyODA6
Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5MjgwMzZiY2JkOGRk
MmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXF1YW50YWwtdnAtMjoyMDE0MDgwMjEy
NDgyNTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy0wMDA4NC1nNmYw
OTI4MDo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzZmMDkyODAzNmJj
YmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgxYWYvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAx
NDA4MDIxMjQ2MDY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctMDAw
ODQtZzZmMDkyODA6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS82ZjA5
MjgwMzZiY2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmL2RtZXNnLXlvY3RvLXZwLTQ3
OjIwMTQwODAyMTI0ODMyOmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3
LTAwMDg0LWc2ZjA5MjgwOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjkv
NmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJjYzBhODFhZi9kbWVzZy15b2N0by12
cC02MToyMDE0MDgwMjEyNDgyNTppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4w
LXJjNy0wMDA4NC1nNmYwOTI4MDo3CjA6MzE6MzEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDZmMDkyODAuLi4gTWVyZ2UgdGFnICdwbSthY3BpLTMuMTYtcmM4JyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcmFmYWVsL2xp
bnV4LXBtCkhFQUQgaXMgbm93IGF0IDQxOThjZjMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lm
aWMgZmlsZXMgZm9yIDIwMTQwODAxCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvbmV4dDptYXN0ZXI6NDE5OGNmMzI0ZGRl
YTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMTpiaXNlY3QtbGludXg2CiBURVNUIEZBSUxV
UkUKWyAgIDExLjA4MTIyMV0gU0JDLUdYeCBmbGFzaDogSU86MHgyNTgtMHgyNTkgTUVNOjB4
ZGMwMDAtMHhkZmZmZgpbICAgMTEuMDgzMjUxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgIDExLjA4MzI1MV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAxMS4wODQ2ODNdIGtlcm5lbCBCVUcgYXQgaW5jbHVkZS9saW51eC9t
dGQvbWFwLmg6MTQ4IQpbICAgMTEuMDg0NjgzXSBrZXJuZWwgQlVHIGF0IGluY2x1ZGUvbGlu
dXgvbXRkL21hcC5oOjE0OCEKWyAgIDExLjA4NzEwNF0gaW52YWxpZCBvcGNvZGU6IDAwMDAg
WyMxXSAKWyAgIDExLjA4NzEwNF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAgU01Q
IAoKWyAgIDExLjA4ODUxN10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xNi4wLXJjNy1uZXh0LTIwMTQwODAxICMxOApbICAgMTEuMDg4NTE3XSBDUFU6
IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM3LW5leHQt
MjAxNDA4MDEgIzE4ClsgICAxMS4wOTEwODFdIHRhc2s6IGMwMDQ4MDAwIHRpOiBjMDA0NDAw
MCB0YXNrLnRpOiBjMDA0NDAwMApbICAgMTEuMDkxMDgxXSB0YXNrOiBjMDA0ODAwMCB0aTog
YzAwNDQwMDAgdGFzay50aTogYzAwNDQwMDAKWyAgIDExLjA5MTA4MV0gRUlQOiAwMDYwOls8
YzEzMzFiY2E+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgMTEuMDkxMDgxXSBFSVA6
IDAwNjA6WzxjMTMzMWJjYT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAxMS4wOTEw
ODFdIEVJUCBpcyBhdCBtdGRfZG9fY2hpcF9wcm9iZSsweDFhLzB4MjAKWyAgIDExLjA5MTA4
MV0gRUlQIGlzIGF0IG10ZF9kb19jaGlwX3Byb2JlKzB4MWEvMHgyMApbICAgMTEuMDkxMDgx
XSBFQVg6IDAwMDAwMDAwIEVCWDogYzE3ZjBiMzAgRUNYOiAwMDAwMDAwMCBFRFg6IGMwMDQ1
ZTg0ClsgICAxMS4wOTEwODFdIEVBWDogMDAwMDAwMDAgRUJYOiBjMTdmMGIzMCBFQ1g6IDAw
MDAwMDAwIEVEWDogYzAwNDVlODQKWyAgIDExLjA5MTA4MV0gRVNJOiBjMTcxOWM0MSBFREk6
IGMwMDQ1ZWMwIEVCUDogYzAwNDVlYzQgRVNQOiBjMDA0NWU4NApbICAgMTEuMDkxMDgxXSBF
U0k6IGMxNzE5YzQxIEVESTogYzAwNDVlYzAgRUJQOiBjMDA0NWVjNCBFU1A6IGMwMDQ1ZTg0
ClsgICAxMS4wOTEwODFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBT
UzogMDA2OApbICAgMTEuMDkxMDgxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6
IDAwMDAgU1M6IDAwNjgKWyAgIDExLjA5MTA4MV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAw
MDAwIENSMzogMDE4ZTIwMDAgQ1I0OiAwMDA0MDZiMApbICAgMTEuMDkxMDgxXSBDUjA6IDgw
MDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMThlMjAwMCBDUjQ6IDAwMDQwNmIwClsgICAx
MS4wOTEwODFdIFN0YWNrOgpbICAgMTEuMDkxMDgxXSBTdGFjazoKWyAgIDExLjA5MTA4MV0g
IDAwMDAwMDAwClsgICAxMS4wOTEwODFdICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2Rh
YWMzZjgzZDNjMjMxOWNlZDc3NDIwMS9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA4MDIx
MDE0MjU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0
MDgwMToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRk
ZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3RvLXZwLTYzOjIwMTQw
ODAyMTAxNjQ1OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOTozLjE2LjAtcmM3LW5leHQt
MjAxNDA4MDE6MTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDE5OGNm
MzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMS9kbWVzZy15b2N0by1rYnVpbGQt
MTQ6MjAxNDA4MDIxMDE0MjY6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1y
YzctbmV4dC0yMDE0MDgwMToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3Rv
LXZwLTU6MjAxNDA4MDIxMDE2NDU6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYu
MC1yYzctbmV4dC0yMDE0MDgwMToxOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAy
MDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlv
Y3RvLWtidWlsZC03OjIwMTQwODAyMTAxNDI2OmkzODYtcmFuZGNvbmZpZy14MS0wODAyMDgy
OTozLjE2LjAtcmM3LW5leHQtMjAxNDA4MDE6MTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMxOWNlZDc3NDIwMS9k
bWVzZy15b2N0by1rYnVpbGQtMjc6MjAxNDA4MDIxMDE0MjU6aTM4Ni1yYW5kY29uZmlnLXgx
LTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxOAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFhYzNmODNkM2MyMzE5Y2Vk
Nzc0MjAxL2RtZXNnLXlvY3RvLXZwLTE2OjIwMTQwODAyMTAxNjUzOmkzODYtcmFuZGNvbmZp
Zy14MS0wODAyMDgyOTozLjE2LjAtcmM3LW5leHQtMjAxNDA4MDE6MTgKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDgwMjA4MjkvNDE5OGNmMzI0ZGRlYTQ0N2RhYWMzZjgzZDNjMjMx
OWNlZDc3NDIwMS9kbWVzZy15b2N0by12cC00OToyMDE0MDgwMjEwMTY1NDppMzg2LXJhbmRj
b25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy1uZXh0LTIwMTQwODAxOjE4Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQxOThjZjMyNGRkZWE0NDdkYWFjM2Y4M2Qz
YzIzMTljZWQ3NzQyMDEvZG1lc2cteW9jdG8ta2J1aWxkLTM6MjAxNDA4MDIxMDE0Mjg6aTM4
Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzctbmV4dC0yMDE0MDgwMToxOAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wODAyMDgyOS80MTk4Y2YzMjRkZGVhNDQ3ZGFh
YzNmODNkM2MyMzE5Y2VkNzc0MjAxL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDgwMjEw
MTQyODppMzg2LXJhbmRjb25maWcteDEtMDgwMjA4Mjk6My4xNi4wLXJjNy1uZXh0LTIwMTQw
ODAxOjE4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5LzQxOThjZjMyNGRk
ZWE0NDdkYWFjM2Y4M2QzYzIzMTljZWQ3NzQyMDEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjg6
MjAxNDA4MDIwODMyMzA6aTM4Ni1yYW5kY29uZmlnLXgxLTA4MDIwODI5OjMuMTYuMC1yYzct
bmV4dC0yMDE0MDgwMToxOAowOjExOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc3-00024-gaf058ab"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc3 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
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
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
CONFIG_MVIAC3_2=y
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

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
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_LL_RX_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
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
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
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
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
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
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
CONFIG_I2C_MUX_PCA954x=y
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
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
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
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
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y
# CONFIG_XEN_WDT is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_MFD_CROS_EC_SPI is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

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
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
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
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=y
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=y

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD799X is not set
# CONFIG_AD7780 is not set
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
# CONFIG_AD9832 is not set
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
CONFIG_AD9910=y
CONFIG_AD9951=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y
CONFIG_ADIS16260=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_CXD2099 is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_DGRP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_MEMORY=y
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_KXSD9=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
# CONFIG_AD7923 is not set
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
CONFIG_AD7476=y
CONFIG_AD7887=y
# CONFIG_LP8788_ADC is not set
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5504=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD5686=y
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=y
# CONFIG_ADXRS450 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=y
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure Sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
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
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
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
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
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
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
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
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_APPRAISE is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
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
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--CUfgB8w4ZwR/yMy5--
