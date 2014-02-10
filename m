Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBJLWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:22:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:57308 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbaBJLWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:22:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="472703663"
Date: Mon, 10 Feb 2014 19:22:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [process_vm_access] BUG: unable to handle kernel paging request at
 fffffff27b92dd20
Message-ID: <20140210112231.GA11951@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Al,

We noticed the below oops since commit 68a25f08c9bec07ad95e55a01b127168e43aed84
("process_vm_access: take get_user_pages/put_pages one level up")
while running ltp tests inside kvm.

[  466.193846] BUG: unable to handle kernel paging request at fffffff27b92dd20
[  466.195225] IP: [<ffffffff81190d7f>] put_page+0x5/0x28
[  466.196263] PGD 220d067 PUD 0
[  466.197137] Oops: 0000 [#1] SMP
[  466.197261] Modules linked in: msr microcode processor
[  466.197261] CPU: 2 PID: 30338 Comm: process_vm01 Not tainted 3.14.0-rc1-00027-g68a25f0 #1
[  466.197261] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  466.197261] task: ffff88007c11ecc0 ti: ffff88007b92c000 task.ti: ffff88007b92c000
[  466.197261] RIP: 0010:[<ffffffff81190d7f>]  [<ffffffff81190d7f>] put_page+0x5/0x28
[  466.197261] RSP: 0018:ffff88007b92dc98  EFLAGS: 00010286
[  466.197261] RAX: fffffffffffffff0 RBX: 0000000000000000 RCX: 0000000000001000
[  466.197261] RDX: 0000000000000000 RSI: 0000000097230000 RDI: fffffff27b92dd20
[  466.197261] RBP: ffff88007b92dde8 R08: 0000000000000000 R09: 00007fe39722f001
[  466.197261] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007c11ecc0
[  466.197261] R13: ffff88007b92dd40 R14: fffffffffffffff2 R15: ffff88007b92de10
[  466.197261] FS:  00007fe397228700(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
[  466.197261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  466.197261] CR2: fffffff27b92dd20 CR3: 000000007f537000 CR4: 00000000000006e0
[  466.197261] Stack:
[  466.197261]  ffffffff811b7ea1 ffff88007b92dd40 0000000000000000 000000000000000d
[  466.197261]  ffffffff81f7ad76 fffffff27b92dd20 ffff88007baa4420 0000000000000001
[  466.197261]  0000000000000000 ffff88007b92deb0 0000000000001000 0000000000000001
[  466.197261] Call Trace:
[  466.197261]  [<ffffffff811b7ea1>] ? process_vm_rw_core.isra.1+0x39f/0x444
[  466.197261]  [<ffffffff811aadbb>] ? handle_mm_fault+0x9e9/0xc9c
[  466.197261]  [<ffffffff811a65f0>] ? might_fault+0x3e/0x40
[  466.197261]  [<ffffffff811e2264>] ? rw_copy_check_uvector+0x6f/0xfd
[  466.197261]  [<ffffffff811b8017>] process_vm_rw+0xd1/0x117
[  466.197261]  [<ffffffff811b05ae>] ? do_mmap_pgoff+0x2e1/0x34c
[  466.197261]  [<ffffffff8119d9fe>] ? vm_mmap_pgoff+0x72/0x94
[  466.197261]  [<ffffffff81a2eb5e>] ? do_page_fault+0xe/0x10
[  466.197261]  [<ffffffff8151472b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  466.197261]  [<ffffffff811b8073>] SyS_process_vm_readv+0x16/0x18
[  466.197261]  [<ffffffff81a32b29>] system_call_fastpath+0x16/0x1b

Attached is the full dmesg.

Thanks,
Fengguang

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-vpx-1:20140208151504:x86_64-lkp:3.14.0-rc1-00027-g68a25f0:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00027-g68a25f0 (kbuild@inn) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Feb 8 15:01:51 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/bisect_l=
tp-syscalls-x86_64-lkp-68a25f08c9bec07ad95e55a01b127168e43aed84-0.yaml ARCH=
=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e=
43aed84/vmlinuz-3.14.0-rc1-00027-g68a25f0 kconfig=3Dx86_64-lkp commit=3D68a=
25f08c9bec07ad95e55a01b127168e43aed84 bm_initrd=3D/lkp/benchmarks/ltp.cgz m=
odules_initrd=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84=
/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/sysc=
alls/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84/0 initrd=3D/kernel=
-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02663000, 0x02663fff] PGTABLE
[    0.000000] BRK [0x02664000, 0x02664fff] PGTABLE
[    0.000000] BRK [0x02665000, 0x02665fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02666000, 0x02666fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x70b06000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81088 r8192=
 d21312 u524288
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/b=
isect_ltp-syscalls-x86_64-lkp-68a25f08c9bec07ad95e55a01b127168e43aed84-0.ya=
ml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b=
127168e43aed84/vmlinuz-3.14.0-rc1-00027-g68a25f0 kconfig=3Dx86_64-lkp commi=
t=3D68a25f08c9bec07ad95e55a01b127168e43aed84 bm_initrd=3D/lkp/benchmarks/lt=
p.cgz modules_initrd=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e=
43aed84/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/l=
tp/syscalls/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 p=
rompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3787676K/4193904K available (10464K kernel code, 124=
6K rwdata, 4168K rodata, 1436K init, 1752K bss, 406228K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00027-g68a25f0 (kbuild@inn) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Feb 8 15:01:51 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/bisect_l=
tp-syscalls-x86_64-lkp-68a25f08c9bec07ad95e55a01b127168e43aed84-0.yaml ARCH=
=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e=
43aed84/vmlinuz-3.14.0-rc1-00027-g68a25f0 kconfig=3Dx86_64-lkp commit=3D68a=
25f08c9bec07ad95e55a01b127168e43aed84 bm_initrd=3D/lkp/benchmarks/ltp.cgz m=
odules_initrd=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84=
/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/sysc=
alls/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84/0 initrd=3D/kernel=
-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02663000, 0x02663fff] PGTABLE
[    0.000000] BRK [0x02664000, 0x02664fff] PGTABLE
[    0.000000] BRK [0x02665000, 0x02665fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02666000, 0x02666fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x70b06000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81088 r8192=
 d21312 u524288
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/b=
isect_ltp-syscalls-x86_64-lkp-68a25f08c9bec07ad95e55a01b127168e43aed84-0.ya=
ml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b=
127168e43aed84/vmlinuz-3.14.0-rc1-00027-g68a25f0 kconfig=3Dx86_64-lkp commi=
t=3D68a25f08c9bec07ad95e55a01b127168e43aed84 bm_initrd=3D/lkp/benchmarks/lt=
p.cgz modules_initrd=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e=
43aed84/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/l=
tp/syscalls/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 p=
rompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3787676K/4193904K available (10464K kernel code, 124=
6K rwdata, 4168K rodata, 1436K init, 1752K bss, 406228K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.600 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.20 Bogo=
MIPS (lpj=3D10774400)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.010861] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.013410] Mount-cache hash table entries: 256
[    0.014536] Initializing cgroup subsys memory
[    0.015340] Initializing cgroup subsys devices
[    0.016005] Initializing cgroup subsys freezer
[    0.016803] Initializing cgroup subsys blkio
[    0.017609] Initializing cgroup subsys perf_event
[    0.018459] Initializing cgroup subsys hugetlb
[    0.019319] mce: CPU supports 10 MCE banks
[    0.020041] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020041] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020041] tlb_flushall_shift: 6
[    0.022535] Freeing SMP alternatives memory: 44K (ffffffff824a0000 - fff=
fffff824ab000)
[    0.028713] ftrace: allocating 39928 entries in 156 pages
[    0.040168] Getting VERSION: 50014
[    0.040913] Getting VERSION: 50014
[    0.041614] Getting ID: 0
[    0.042239] Getting ID: ff000000
[    0.044010] Getting LVT0: 8700
[    0.044701] Getting LVT1: 8400
[    0.045406] enabled ExtINT on CPU#0
[    0.046762] ENABLING IO-APIC IRQs
[    0.047475] init IO_APIC IRQs
[    0.048004]  apic 0 pin 0 not connected
[    0.048742] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.050251] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.052015] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.053493] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.054965] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.056014] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.057475] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.058904] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.060014] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.061472] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.062916] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.064014] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.065484] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.068014] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.069467] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.070925]  apic 0 pin 16 not connected
[    0.072002]  apic 0 pin 17 not connected
[    0.072741]  apic 0 pin 18 not connected
[    0.073480]  apic 0 pin 19 not connected
[    0.074238]  apic 0 pin 20 not connected
[    0.074971]  apic 0 pin 21 not connected
[    0.075702]  apic 0 pin 22 not connected
[    0.076002]  apic 0 pin 23 not connected
[    0.076887] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.078008] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.080003] Using local APIC timer interrupts.
[    0.080003] calibrating APIC timer ...
[    0.084000] ... lapic delta =3D 6249883
[    0.084000] ... PM-Timer delta =3D 357987
[    0.084000] ... PM-Timer result ok
[    0.084000] ..... delta 6249883
[    0.084000] ..... mult: 268430430
[    0.084000] ..... calibration result: 3999925
[    0.084000] ..... CPU clock speed is 2693.2624 MHz.
[    0.084000] ..... host bus clock speed is 999.3925 MHz.
[    0.084056] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.087677] x86: Booting SMP configuration:
[    0.088003] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 1:1ffef041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.104022] KVM setup async PF for cpu 1
[    0.105259]  #2
[    0.105259] kvm-stealtime: cpu 1, msr 11fc8d040
[    0.008000] kvm-clock: cpu 2, msr 1:1ffef081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.120020] KVM setup async PF for cpu 2
[    0.121005]  #3
[    0.121005] kvm-stealtime: cpu 2, msr 11fd0d040
[    0.008000] kvm-clock: cpu 3, msr 1:1ffef0c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3
[    0.136043] x86: Booted up 1 node, 4 CPUs
[    0.136023] KVM setup async PF for cpu 3
[    0.136023] kvm-stealtime: cpu 3, msr 11fd8d040
[    0.138450] smpboot: Total of 4 processors activated (21548.80 BogoMIPS)
[    0.140184] devtmpfs: initialized
[    0.145004] xor: measuring software checksum speed
[    0.184011]    prefetch64-sse:   188.000 MB/sec
[    0.224003]    generic_sse:   184.000 MB/sec
[    0.224896] xor: using function: prefetch64-sse (188.000 MB/sec)
[    0.225882] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.227272] NET: Registered protocol family 16
[    0.228564] cpuidle: using governor ladder
[    0.228861] cpuidle: using governor menu
[    0.232345] ACPI: bus type PCI registered
[    0.233159] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.234218] PCI: Using configuration type 1 for base access
[    0.260127] bio: create slab <bio-0> at 0
[    0.328004] raid6: sse2x1    8368 MB/s
[    0.396010] raid6: sse2x2   10609 MB/s
[    0.464004] raid6: sse2x4   12381 MB/s
[    0.464852] raid6: using algorithm sse2x4 (12381 MB/s)
[    0.465736] raid6: using intx1 recovery algorithm
[    0.466662] ACPI: Added _OSI(Module Device)
[    0.467473] ACPI: Added _OSI(Processor Device)
[    0.468012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.468913] ACPI: Added _OSI(Processor Aggregator Device)
[    0.471433] ACPI: Interpreter enabled
[    0.472007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.473778] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.476023] ACPI: (supports S0 S3 S4 S5)
[    0.476840] ACPI: Using IOAPIC for interrupt routing
[    0.477752] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.477872] ACPI: No dock devices found.
[    0.484189] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.488008] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.489149] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.490345] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.492289] acpiphp: Slot [3] registered
[    0.492876] acpiphp: Slot [4] registered
[    0.492876] acpiphp: Slot [5] registered
[    0.492876] acpiphp: Slot [6] registered
[    0.496051] acpiphp: Slot [7] registered
[    0.496871] acpiphp: Slot [8] registered
[    0.496872] acpiphp: Slot [9] registered
[    0.496872] acpiphp: Slot [10] registered
[    0.500062] acpiphp: Slot [11] registered
[    0.500871] acpiphp: Slot [12] registered
[    0.500880] acpiphp: Slot [13] registered
[    0.500888] acpiphp: Slot [14] registered
[    0.500888] acpiphp: Slot [15] registered
[    0.504048] acpiphp: Slot [16] registered
[    0.504877] acpiphp: Slot [17] registered
[    0.504886] acpiphp: Slot [18] registered
[    0.504886] acpiphp: Slot [19] registered
[    0.508058] acpiphp: Slot [20] registered
[    0.508880] acpiphp: Slot [21] registered
[    0.508880] acpiphp: Slot [22] registered
[    0.508880] acpiphp: Slot [23] registered
[    0.508880] acpiphp: Slot [24] registered
[    0.512053] acpiphp: Slot [25] registered
[    0.512869] acpiphp: Slot [26] registered
[    0.512877] acpiphp: Slot [27] registered
[    0.512878] acpiphp: Slot [28] registered
[    0.516058] acpiphp: Slot [29] registered
[    0.516870] acpiphp: Slot [30] registered
[    0.516875] acpiphp: Slot [31] registered
[    0.516875] PCI host bridge to bus 0000:00
[    0.517658] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.520004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.521053] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.522097] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.524003] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.525165] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.526506] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.528057] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.531797] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.533597] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.536308] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.537798] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.539108] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.544618] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.548604] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.556043] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.557672] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.557988] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.560969] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.568005] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.572178] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.576572] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.578477] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.584808] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.586003] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.588542] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.594652] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.596537] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.598408] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.604770] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.606000] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.608527] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.614693] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.617053] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.618904] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.624773] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.626027] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.629016] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.635128] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.636564] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.640921] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.641756] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.644041] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.645415] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.646655] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.648224] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.649291] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.649472] vgaarb: loaded
[    0.652015] vgaarb: bridge control possible 0000:00:02.0
[    0.653098] SCSI subsystem initialized
[    0.653098] libata version 3.00 loaded.
[    0.653098] ACPI: bus type USB registered
[    0.656068] usbcore: registered new interface driver usbfs
[    0.656993] usbcore: registered new interface driver hub
[    0.656993] usbcore: registered new device driver usb
[    0.656993] pps_core: LinuxPPS API ver. 1 registered
[    0.660012] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.661675] PTP clock support registered
[    0.661675] EDAC MC: Ver: 3.0.0
[    0.664206] PCI: Using ACPI for IRQ routing
[    0.664807] PCI: pci_cache_line_size set to 64 bytes
[    0.665832] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.666800] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.668609] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.669703] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.670817] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.676136] Switched to clocksource kvm-clock
[    0.690892] pnp: PnP ACPI init
[    0.691599] ACPI: bus type PNP registered
[    0.692435] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.694040] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.695073] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.696761] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.697811] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.699413] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.700506] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.701952] pnp 00:03: [dma 2]
[    0.702763] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.703799] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.705452] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.706500] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.708072] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.709298] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.710390] pnp: PnP ACPI: found 7 devices
[    0.711151] ACPI: bus type PNP unregistered
[    0.726994] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.727920] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.728856] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.729839] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.730903] NET: Registered protocol family 2
[    0.731915] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    0.733520] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.734859] TCP: Hash tables configured (established 32768 bind 32768)
[    0.735963] TCP: reno registered
[    0.736753] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.737754] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.738850] NET: Registered protocol family 1
[    0.739947] RPC: Registered named UNIX socket transport module.
[    0.740988] RPC: Registered udp transport module.
[    0.741802] RPC: Registered tcp transport module.
[    0.742605] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.743581] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.744575] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.745510] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.746470] pci 0000:00:02.0: Boot video device
[    0.747306] PCI: CLS 0 bytes, default 64
[    0.748179] Trying to unpack rootfs image as initramfs...
[    5.136387] Freeing initrd memory: 250856K (ffff880070b06000 - ffff88008=
0000000)
[    5.137924] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.138983] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    5.141259] kvm: no hardware support
[    5.142636] Scanning for low memory corruption every 60 seconds
[    5.144008] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    5.145755] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    5.147599] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    5.150280] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    5.151347] PCLMULQDQ-NI instructions are not detected.
[    5.152352] AVX or AES-NI instructions are not detected.
[    5.153322] AVX instructions are not detected.
[    5.154180] AVX instructions are not detected.
[    5.155033] AVX instructions are not detected.
[    5.155894] AVX instructions are not detected.
[    5.159427] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    5.181878] bounce pool size: 64 pages
[    5.182706] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.192319] VFS: Disk quotas dquot_6.5.2
[    5.193286] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.197428] NFS: Registering the id_resolver key type
[    5.198373] Key type id_resolver registered
[    5.199211] Key type id_legacy registered
[    5.200058] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    5.201184] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.202972] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.204100] fuse init (API version 7.22)
[    5.205383] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    5.210836] msgmni has been set to 7887
[    5.218290] NET: Registered protocol family 38
[    5.219184] Key type asymmetric registered
[    5.220317] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    5.221948] io scheduler noop registered
[    5.222778] io scheduler deadline registered
[    5.223646] io scheduler cfq registered (default)
[    5.225137] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.226435] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.227829] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.229412] ACPI: Power Button [PWRF]
[    5.230659] GHES: HEST is not enabled!
[    5.231953] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.233021] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    5.236155] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.237203] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    5.240477] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.243386] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.251650] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.274184] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.277643] Non-volatile memory driver v1.3
[    5.282397] brd: module loaded
[    5.285367] loop: module loaded
[    5.286301] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.287282] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.288435] blk-mq: CPU -> queue map
[    5.289212]   CPU 0 -> Queue 0
[    5.289921]   CPU 1 -> Queue 0
[    5.290639]   CPU 2 -> Queue 0
[    5.291357]   CPU 3 -> Queue 0
[    5.293111]  vda: unknown partition table
[    5.295903] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.296935] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.298113] blk-mq: CPU -> queue map
[    5.298888]   CPU 0 -> Queue 0
[    5.299610]   CPU 1 -> Queue 0
[    5.300341]   CPU 2 -> Queue 0
[    5.301058]   CPU 3 -> Queue 0
[    5.302831]  vdb: unknown partition table
[    5.305520] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.306500] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.307609] blk-mq: CPU -> queue map
[    5.308391]   CPU 0 -> Queue 0
[    5.309099]   CPU 1 -> Queue 0
[    5.309804]   CPU 2 -> Queue 0
[    5.315680]   CPU 3 -> Queue 0
[    5.317231]  vdc: unknown partition table
[    5.319839] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    5.320870] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    5.321985] blk-mq: CPU -> queue map
[    5.322755]   CPU 0 -> Queue 0
[    5.323456]   CPU 1 -> Queue 0
[    5.324174]   CPU 2 -> Queue 0
[    5.324874]   CPU 3 -> Queue 0
[    5.326243]  vdd: unknown partition table
[    5.328930] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    5.329929] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.331028] blk-mq: CPU -> queue map
[    5.331805]   CPU 0 -> Queue 0
[    5.332558]   CPU 1 -> Queue 0
[    5.333306]   CPU 2 -> Queue 0
[    5.334018]   CPU 3 -> Queue 0
[    5.335678]  vde: unknown partition table
[    5.338447] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    5.339461] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    5.340639] blk-mq: CPU -> queue map
[    5.341435]   CPU 0 -> Queue 0
[    5.342169]   CPU 1 -> Queue 0
[    5.342899]   CPU 2 -> Queue 0
[    5.343629]   CPU 3 -> Queue 0
[    5.345312]  vdf: unknown partition table
[    5.347787] lkdtm: No crash points registered, enable through debugfs
[    5.349535] Loading iSCSI transport class v2.0-870.
[    5.351493] Adaptec aacraid driver 1.2-0[30200]-ms
[    5.352485] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.353855] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[    5.355617] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    5.357321] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    5.358576] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    5.359844] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    5.361026] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.362535] ata_piix 0000:00:01.1: version 2.13
[    5.365795] scsi0 : ata_piix
[    5.366761] scsi1 : ata_piix
[    5.367613] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    5.368744] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    5.370805] tun: Universal TUN/TAP device driver, 1.6
[    5.371734] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.373195] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    5.374463] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    5.375453] Copyright (c) 2007 Atheros Corporation.
[    5.376743] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    5.377965] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    5.377965]   http://www.scyld.com/network/drivers.html
[    5.380263] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    5.381522] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.382566] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.383615] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    5.384783] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.524483] ata2.01: NODEV after polling detection
[    5.525541] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    5.526799] ata2.00: configured for MWDMA2
[    5.528547] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    5.531099] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[    5.708368] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    5.709426] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.710677] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.711611] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    5.712849] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    5.713886] igb: Copyright (c) 2007-2013 Intel Corporation.
[    5.715017] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.19.1-k
[    5.716464] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    5.717640] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    5.718710] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.719993] sky2: driver version 1.30
[    5.722293] usbcore: registered new interface driver catc
[    5.723300] usbcore: registered new interface driver kaweth
[    5.724247] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    5.725777] usbcore: registered new interface driver pegasus
[    5.726800] usbcore: registered new interface driver rtl8150
[    5.727826] usbcore: registered new interface driver asix
[    5.728876] usbcore: registered new interface driver ax88179_178a
[    5.729937] usbcore: registered new interface driver cdc_ether
[    5.730975] usbcore: registered new interface driver r815x
[    5.731975] usbcore: registered new interface driver cdc_eem
[    5.733073] usbcore: registered new interface driver dm9601
[    5.734088] usbcore: registered new interface driver smsc75xx
[    5.735131] usbcore: registered new interface driver smsc95xx
[    5.736198] usbcore: registered new interface driver gl620a
[    5.737213] usbcore: registered new interface driver net1080
[    5.738227] usbcore: registered new interface driver plusb
[    5.739224] usbcore: registered new interface driver rndis_host
[    5.740329] usbcore: registered new interface driver cdc_subset
[    5.741379] usbcore: registered new interface driver zaurus
[    5.742388] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    5.743889] usbcore: registered new interface driver int51x1
[    5.744923] usbcore: registered new interface driver ipheth
[    5.745935] usbcore: registered new interface driver sierra_net
[    5.746982] usbcore: registered new interface driver cdc_ncm
[    5.747918] Fusion MPT base driver 3.04.20
[    5.748711] Copyright (c) 1999-2008 LSI Corporation
[    5.749583] Fusion MPT SPI Host driver 3.04.20
[    5.750509] Fusion MPT FC Host driver 3.04.20
[    5.751407] Fusion MPT SAS Host driver 3.04.20
[    5.752330] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.753347] mptctl: Registered with Fusion MPT base driver
[    5.754270] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    5.755358] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.756391] ehci-pci: EHCI PCI platform driver
[    5.757273] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.758264] ohci-pci: OHCI PCI platform driver
[    5.759129] uhci_hcd: USB Universal Host Controller Interface driver
[    5.760307] usbcore: registered new interface driver usb-storage
[    5.761334] usbcore: registered new interface driver ums-alauda
[    5.762347] usbcore: registered new interface driver ums-datafab
[    5.763365] usbcore: registered new interface driver ums-freecom
[    5.764412] usbcore: registered new interface driver ums-isd200
[    5.765429] usbcore: registered new interface driver ums-jumpshot
[    5.766454] usbcore: registered new interface driver ums-sddr09
[    5.767468] usbcore: registered new interface driver ums-sddr55
[    5.768495] usbcore: registered new interface driver ums-usbat
[    5.769509] usbcore: registered new interface driver usbtest
[    5.770576] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.772754] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.773702] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.775269] mousedev: PS/2 mouse device common for all mice
[    5.776925] rtc_cmos 00:00: RTC can wake from S4
[    5.777938] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.779897] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.781075] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.782343] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.783619] i6300esb: initialized (0xffffc9000072a000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    5.785176] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.786202] iTCO_vendor_support: vendor-support=3D0
[    5.787089] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.788578] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    5.790258] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    5.792030] md: linear personality registered for level -1
[    5.792920] md: raid0 personality registered for level 0
[    5.793777] md: raid1 personality registered for level 1
[    5.794631] md: raid10 personality registered for level 10
[    5.795669] md: raid6 personality registered for level 6
[    5.796623] md: raid5 personality registered for level 5
[    5.797587] md: raid4 personality registered for level 4
[    5.798448] md: multipath personality registered for level -4
[    5.799348] md: faulty personality registered for level -5
[    5.801302] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.803124] device-mapper: multipath: version 1.6.0 loaded
[    5.804057] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.805075] device-mapper: cache-policy-mq: version 1.2.0 loaded
[    5.805999] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.807182] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.810201] usbcore: registered new interface driver usbhid
[    5.811090] usbhid: USB HID core driver
[    5.811940] TCP: bic registered
[    5.812666] Initializing XFRM netlink socket
[    5.813775] NET: Registered protocol family 10
[    5.814752] sit: IPv6 over IPv4 tunneling driver
[    5.815804] NET: Registered protocol family 17
[    5.816645] 8021q: 802.1Q VLAN Support v1.8
[    5.818185] sctp: Hash tables configured (established 65536 bind 65536)
[    5.819443] Key type dns_resolver registered
[    5.821111]=20
[    5.821111] printing PIC contents
[    5.822219] ... PIC  IMR: ffff
[    5.822859] ... PIC  IRR: 9113
[    5.823505] ... PIC  ISR: 0000
[    5.824163] ... PIC ELCR: 0c00
[    5.824856] printing local APIC contents on CPU#0/0:
[    5.825740] ... APIC ID:      00000000 (0)
[    5.826519] ... APIC VERSION: 00050014
[    5.828845] ... APIC TASKPRI: 00000000 (00)
[    5.828845] ... APIC PROCPRI: 00000000
[    5.828845] ... APIC LDR: 01000000
[    5.828845] ... APIC DFR: ffffffff
[    5.828845] ... APIC SPIV: 000001ff
[    5.828845] ... APIC ISR field:
[    5.828845] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.828845] ... APIC TMR field:
[    5.828845] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.828845] ... APIC IRR field:
[    5.828845] 000000000000000000000000000000000000000000000000000000002000=
0000
[    5.828845] ... APIC ESR: 00000000
[    5.828845] ... APIC ICR: 000008fd
[    5.828845] ... APIC ICR2: 02000000
[    5.828845] ... APIC LVTT: 000000ef
[    5.828845] ... APIC LVTPC: 00010000
[    5.828845] ... APIC LVT0: 00010700
[    5.828845] ... APIC LVT1: 00000400
[    5.828845] ... APIC LVTERR: 000000fe
[    5.828845] ... APIC TMICT: 01405f24
[    5.828845] ... APIC TMCCT: 011540b3
[    5.828845] ... APIC TDCR: 00000003
[    5.828845]=20
[    5.851187] number of MP IRQ sources: 15.
[    5.851920] number of IO-APIC #0 registers: 24.
[    5.852713] testing the IO APIC.......................
[    5.853568] IO APIC #0......
[    5.854192] .... register #00: 00000000
[    5.854900] .......    : physical APIC id: 00
[    5.855667] .......    : Delivery Type: 0
[    5.856406] .......    : LTS          : 0
[    5.857133] .... register #01: 00170011
[    5.857844] .......     : max redirection entries: 17
[    5.858673] .......     : PRQ implemented: 0
[    5.859429] .......     : IO APIC version: 11
[    5.860202] .... register #02: 00000000
[    5.860916] .......     : arbitration: 00
[    5.861648] .... IRQ redirection table:
[    5.862370] 1    0    0   0   0    0    0    00
[    5.863152] 0    0    0   0   0    1    1    31
[    5.863933] 0    0    0   0   0    1    1    30
[    5.864735] 0    0    0   0   0    1    1    33
[    5.865523] 1    0    0   0   0    1    1    34
[    5.866310] 1    1    0   0   0    1    1    35
[    5.867099] 0    0    0   0   0    1    1    36
[    5.867881] 0    0    0   0   0    1    1    37
[    5.868678] 0    0    0   0   0    1    1    38
[    5.869468] 0    1    0   0   0    1    1    39
[    5.870258] 1    1    0   0   0    1    1    3A
[    5.871048] 1    1    0   0   0    1    1    3B
[    5.871829] 0    0    0   0   0    1    1    3C
[    5.872626] 0    0    0   0   0    1    1    3D
[    5.873423] 0    0    0   0   0    1    1    3E
[    5.874209] 0    0    0   0   0    1    1    3F
[    5.874990] 1    0    0   0   0    0    0    00
[    5.875776] 1    0    0   0   0    0    0    00
[    5.876576] 1    0    0   0   0    0    0    00
[    5.877365] 1    0    0   0   0    0    0    00
[    5.878150] 1    0    0   0   0    0    0    00
[    5.878932] 1    0    0   0   0    0    0    00
[    5.879716] 1    0    0   0   0    0    0    00
[    5.880515] 1    0    0   0   0    0    0    00
[    5.881295] IRQ to pin mappings:
[    5.881950] IRQ0 -> 0:2
[    5.882657] IRQ1 -> 0:1
[    5.883356] IRQ3 -> 0:3
[    5.884072] IRQ4 -> 0:4
[    5.884770] IRQ5 -> 0:5
[    5.885472] IRQ6 -> 0:6
[    5.886175] IRQ7 -> 0:7
[    5.886877] IRQ8 -> 0:8
[    5.887575] IRQ9 -> 0:9
[    5.888287] IRQ10 -> 0:10
[    5.889007] IRQ11 -> 0:11
[    5.889730] IRQ12 -> 0:12
[    5.890449] IRQ13 -> 0:13
[    5.891171] IRQ14 -> 0:14
[    5.891889] IRQ15 -> 0:15
[    5.892625] .................................... done.
[    5.893827] registered taskstats version 1
[    5.895116] rtc_cmos 00:00: setting system clock to 2014-02-08 15:07:04 =
UTC (1391872024)
[    5.896571] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    5.901346] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.902265] 8021q: adding VLAN 0 to HW filter on device eth0
[    6.140119] tsc: Refined TSC clocksource calibration: 2693.410 MHz
[    6.402416] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.904542] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    7.908104] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.924091] Sending DHCP requests ., OK
[    7.984102] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    7.985288] IP-Config: Complete:
[    7.985952]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.987500]      host=3Dvpx-1, domain=3D, nis-domain=3D(none)
[    7.988374]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    7.989033]      nameserver0=3D10.0.2.3
[    7.990163] PM: Hibernation image not present or could not be loaded.
[    7.992520] Freeing unused kernel memory: 1436K (ffffffff82339000 - ffff=
ffff824a0000)
[    7.993922] Write protecting the kernel read-only data: 18432k
[    7.998771] Freeing unused kernel memory: 1812K (ffff880001a3b000 - ffff=
880001c00000)
[    8.003865] Freeing unused kernel memory: 1976K (ffff880002012000 - ffff=
880002200000)
[    8.200963] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.202368] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.203425] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.207585] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.211558] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    8.514165] random: vgscan urandom read with 20 bits of entropy available

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/lkp/src/tmp/err_log <=3D=3D

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/syscalls/x86_64-lkp/68a25f08c9bec07=
ad95e55a01b127168e43aed84/0
job=3D/lkp/scheduled/vpx-1/bisect_ltp-syscalls-x86_64-lkp-68a25f08c9bec07ad=
95e55a01b127168e43aed84-0.yaml
run-job /lkp/scheduled/vpx-1/bisect_ltp-syscalls-x86_64-lkp-68a25f08c9bec07=
ad95e55a01b127168e43aed84-0.yaml
run: pre-test
run: /lkp/lkp/src/monitors/event/wait pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper latency_stats
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /lkp/lkp/src/monitors/wrapper pmeter
run: /lkp/lkp/src/monitors/wrapper diskstats
run: /lkp/lkp/src/monitors/wrapper zoneinfo
run: /lkp/lkp/src/monitors/wrapper energy
run: /lkp/lkp/src/monitors/wrapper cpuidle
run: /lkp/lkp/src/monitors/wrapper turbostat
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/micro/wra=
pper ltp
[   62.012562] random: nonblocking pool is initialized
[   85.767028] warning: `capget01' uses 32-bit capabilities (legacy support=
 in use)
[  382.932150] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[  466.193846] BUG: unable to handle kernel paging request at fffffff27b92d=
d20
[  466.195225] IP: [<ffffffff81190d7f>] put_page+0x5/0x28
[  466.196263] PGD 220d067 PUD 0=20
[  466.197137] Oops: 0000 [#1] SMP=20
[  466.197261] Modules linked in: msr microcode processor
[  466.197261] CPU: 2 PID: 30338 Comm: process_vm01 Not tainted 3.14.0-rc1-=
00027-g68a25f0 #1
[  466.197261] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  466.197261] task: ffff88007c11ecc0 ti: ffff88007b92c000 task.ti: ffff880=
07b92c000
[  466.197261] RIP: 0010:[<ffffffff81190d7f>]  [<ffffffff81190d7f>] put_pag=
e+0x5/0x28
[  466.197261] RSP: 0018:ffff88007b92dc98  EFLAGS: 00010286
[  466.197261] RAX: fffffffffffffff0 RBX: 0000000000000000 RCX: 00000000000=
01000
[  466.197261] RDX: 0000000000000000 RSI: 0000000097230000 RDI: fffffff27b9=
2dd20
[  466.197261] RBP: ffff88007b92dde8 R08: 0000000000000000 R09: 00007fe3972=
2f001
[  466.197261] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007c1=
1ecc0
[  466.197261] R13: ffff88007b92dd40 R14: fffffffffffffff2 R15: ffff88007b9=
2de10
[  466.197261] FS:  00007fe397228700(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  466.197261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  466.197261] CR2: fffffff27b92dd20 CR3: 000000007f537000 CR4: 00000000000=
006e0
[  466.197261] Stack:
[  466.197261]  ffffffff811b7ea1 ffff88007b92dd40 0000000000000000 00000000=
0000000d
[  466.197261]  ffffffff81f7ad76 fffffff27b92dd20 ffff88007baa4420 00000000=
00000001
[  466.197261]  0000000000000000 ffff88007b92deb0 0000000000001000 00000000=
00000001
[  466.197261] Call Trace:
[  466.197261]  [<ffffffff811b7ea1>] ? process_vm_rw_core.isra.1+0x39f/0x444
[  466.197261]  [<ffffffff811aadbb>] ? handle_mm_fault+0x9e9/0xc9c
[  466.197261]  [<ffffffff811a65f0>] ? might_fault+0x3e/0x40
[  466.197261]  [<ffffffff811e2264>] ? rw_copy_check_uvector+0x6f/0xfd
[  466.197261]  [<ffffffff811b8017>] process_vm_rw+0xd1/0x117
[  466.197261]  [<ffffffff811b05ae>] ? do_mmap_pgoff+0x2e1/0x34c
[  466.197261]  [<ffffffff8119d9fe>] ? vm_mmap_pgoff+0x72/0x94
[  466.197261]  [<ffffffff81a2eb5e>] ? do_page_fault+0xe/0x10
[  466.197261]  [<ffffffff8151472b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  466.197261]  [<ffffffff811b8073>] SyS_process_vm_readv+0x16/0x18
[  466.197261]  [<ffffffff81a32b29>] system_call_fastpath+0x16/0x1b
[  466.197261] Code: 45 fc 65 48 01 04 25 50 f3 00 00 c9 c3 0f 1f 44 00 00 =
55 31 d2 48 c7 c6 20 01 19 81 48 89 e5 e8 d4 fe ff ff 5d c3 0f 1f 44 00 00 =
<48> f7 07 00 c0 00 00 55 48 89 e5 74 07 e8 d6 fa ff ff eb 0d f0=20
[  466.197261] RIP  [<ffffffff81190d7f>] put_page+0x5/0x28
[  466.197261]  RSP <ffff88007b92dc98>
[  466.197261] CR2: fffffff27b92dd20
[  466.197261] ---[ end trace c832eda068281bf7 ]---
[  466.197261] Kernel panic - not syncing: Fatal exception
[  466.197261] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[  466.197261] Rebooting in 10 seconds..
Elapsed time: 190
numactl --preferred=3D0 --physcpubind=3D4-7 qemu-system-x86_64 -cpu kvm64 -=
enable-kvm -kernel /kernel/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43ae=
d84/vmlinuz-3.14.0-rc1-00027-g68a25f0 -append 'user=3Dlkp job=3D/lkp/schedu=
led/vpx-1/bisect_ltp-syscalls-x86_64-lkp-68a25f08c9bec07ad95e55a01b127168e4=
3aed84-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/68a25f08c9bec07=
ad95e55a01b127168e43aed84/vmlinuz-3.14.0-rc1-00027-g68a25f0 kconfig=3Dx86_6=
4-lkp commit=3D68a25f08c9bec07ad95e55a01b127168e43aed84 bm_initrd=3D/lkp/be=
nchmarks/ltp.cgz modules_initrd=3D/kernel/x86_64-lkp/68a25f08c9bec07ad95e55=
a01b127168e43aed84/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/=
vpx/micro/ltp/syscalls/x86_64-lkp/68a25f08c9bec07ad95e55a01b127168e43aed84/=
0 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vp=
x-1::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_=
always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ra=
mdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal'  -initrd /fs/sdb1/initrd-vpx-1 -m 4G -smp 4 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::9334-:22 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdb1/disk0-=
vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdb1/disk1-vpx-1,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sdb1/disk2-vpx-1,media=3Ddisk,if=3Dvirtio=
 -drive file=3D/fs/sdb1/disk3-vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sdb1/disk4-vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdb1/disk5-=
vpx-1,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-1 -serial fi=
le:/dev/shm/kboot/serial-vpx-1 -daemonize -display none -monitor null=20

--OXfL5xGRrasGEqWY--
