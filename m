Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaCGCKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:10:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:28273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaCGCKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633412"
Date: Fri, 7 Mar 2014 09:48:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86, vdso]  BUG: unable to handle kernel paging request at 91c24000
Message-ID: <20140307014844.GF8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kbCYTQG2MZjuOjyn"
Content-Disposition: inline
In-Reply-To: <20140307013833.GD8427@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Stefani,

FYI, here is a similar bisect result for 4dea8e4824b363c53f320d328040d7c6c5921419
("x86, vdso: Add 32 bit VDSO time support for 32 bit kernel").

+----------------------------------------------------------+------------+------------+------------+
|                                                          | 8272416968 | 4dea8e4824 | d478a960ed |
+----------------------------------------------------------+------------+------------+------------+
| boot_successes                                           | 0          | 0          | 0          |
| boot_failures                                            | 80         | 20         | 19         |
| INFO:task_blocked_for_more_than_seconds                  | 80         |            |            |
| EIP_is_at_native_safe_halt                               | 80         |            |            |
| EIP_is_at_default_send_IPI_mask_logical                  | 80         |            |            |
| Kernel_panic-not_syncing:hung_task:blocked_tasks         | 80         |            |            |
| backtrace:pi_probe_unit                                  | 80         |            |            |
| backtrace:pi_init                                        | 80         |            |            |
| backtrace:pcd_init                                       | 80         |            |            |
| backtrace:kernel_init_freeable                           | 80         |            |            |
| backtrace:cpu_startup_entry                              | 76         |            |            |
| backtrace:watchdog                                       | 80         |            |            |
| BUG:unable_to_handle_kernel_paging_request               | 0          | 20         | 19         |
| Oops:SMP_DEBUG_PAGEALLOC                                 | 0          | 20         | 19         |
| EIP_is_at_sysenter_setup                                 | 0          | 20         | 19         |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task | 0          | 20         | 19         |
+----------------------------------------------------------+------------+------------+------------+

[    0.009720] Initializing cgroup subsys blkio
[    0.010256] Initializing cgroup subsys perf_event
[    0.010830] Initializing cgroup subsys net_prio
[    0.011479] BUG: unable to handle kernel paging request at 91c24000
[    0.012000] IP: [<820444c8>] sysenter_setup+0x90/0x2b4
[    0.012000] *pde = 123fd067 *pte = 11c24060 
[    0.012000] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[    0.012000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-gd478a96 #4
[    0.012000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.012000] task: 81f5ff20 ti: 81f58000 task.ti: 81f58000
[    0.012000] EIP: 0060:[<820444c8>] EFLAGS: 00210206 CPU: 0
[    0.012000] EIP is at sysenter_setup+0x90/0x2b4
[    0.012000] EAX: 078bfbfd EBX: 91c23000 ECX: 00000044 EDX: 00001044
[    0.012000] ESI: 82091418 EDI: 91c24000 EBP: 81f59fb4 ESP: 81f59f90
[    0.012000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.012000] CR0: 8005003b CR2: 91c24000 CR3: 02228000 CR4: 00000690
[    0.012000] Stack:
[    0.012000]  81f6d0c0 91c22b80 00000f61 00000800 80002001 078bfbfd 820850e0 00020800
[    0.012000]  82229800 81f59fbc 82039789 81f59fcc 820397bf 820850e0 00020800 81f59fec
[    0.012000]  82033a6d 0000027e ffffffff ffffffff 82033530 820850e0 00000800 81f59ff8
[    0.012000] Call Trace:
[    0.012000]  [<82039789>] identify_boot_cpu+0x17/0x28
[    0.012000]  [<820397bf>] check_bugs+0xb/0xbb
[    0.012000]  [<82033a6d>] start_kernel+0x376/0x381
[    0.012000]  [<82033530>] ? repair_env_string+0x51/0x51
[    0.012000]  [<82033364>] i386_start_kernel+0x12e/0x131
[    0.012000] Code: f6 c4 08 74 12 ba 5c 14 09 82 be 18 04 09 82 81 ea 18 04 09 82 eb 10 ba 18 04 09 82 be e8 f3 08 82 81 ea e8 f3 08 82 89 d1 89 df <f3> a4 89 d8 e8 bf fe ff ff b9 04 00 00 00 ba c0 39 df 81 89 d8
[    0.012000] EIP: [<820444c8>] sysenter_setup+0x90/0x2b4 SS:ESP 0068:81f59f90
[    0.012000] CR2: 0000000091c24000
[    0.012000] ---[ end trace 244d6fd44ed68f46 ]---
[    0.012000] Kernel panic - not syncing: Attempted to kill the idle task!

git bisect start d478a960edf1ea61ca31a07a48a8771f043dba78 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect  bad 6c2191ad9b6225860eef70a77d300c3d5ad39182  # 07:28      0-      8  Merge 'digsig/for-mimi' into devel-hourly-2014030618
git bisect good 61ca01b5aa63605e033f1826dcceb41421aa72cd  # 07:37     20+     20  Merge 'ubifs/master' into devel-hourly-2014030618
git bisect  bad 53dca0b5f0e257f00b91fc3be98fb47c07d20cfc  # 07:44      0-     16  Merge 'tip/x86/vdso' into devel-hourly-2014030618
git bisect good f25ed0ebc194a51042a5392ca821de2ff6661275  # 07:51     20+     20  Merge 'slave-dma/next' into devel-hourly-2014030618
git bisect good e0099b8165e2525541d7844e29e8838824b3601e  # 07:58     20+     20  Merge 'pcmoore-selinux/next' into devel-hourly-2014030618
git bisect good c24bf54683dd0098e878a0cf40e2667e46a39a0a  # 08:11     20+     20  Merge 'renesas/next' into devel-hourly-2014030618
git bisect good 6543ca6fee7d3b314bda69b83fd429ed3e336645  # 08:19     20+     20  x86, vdso: Cleanup __vdso_gettimeofday()
git bisect  bad 4dea8e4824b363c53f320d328040d7c6c5921419  # 08:23      0-      8  x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 08:30     20+     20  x86, vdso: Patch alternatives in the 32-bit VDSO
# first bad commit: [4dea8e4824b363c53f320d328040d7c6c5921419] x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 08:37     60+     80  x86, vdso: Patch alternatives in the 32-bit VDSO
git bisect  bad d478a960edf1ea61ca31a07a48a8771f043dba78  # 08:37      0-     19  0day head guard for 'devel-hourly-2014030618'
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 08:50     60+     60  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 08:52     60+     69  Add linux-next specific files for 20140306

Thanks,
Fengguang

--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivytown2-19:20140307064920:i386-randconfig-an1-03070605:3.14.0-rc5-03765-gd478a96:4"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@ant) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #4 SMP Fri Mar 7 06:43:04 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[800fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x027a7000, 0x027a7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x027a8000, 0x027a8fff] PGTABLE
[    0.000000] BRK [0x027a9000, 0x027a9fff] PGTABLE
[    0.000000] BRK [0x027aa000, 0x027aafff] PGTABLE
[    0.000000] BRK [0x027ab000, 0x027abfff] PGTABLE
[    0.000000] BRK [0x027ac000, 0x027acfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
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
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 82003620, node_mem_map 92=
48b028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @92125000 s1355376 r0 d12688 =
u1368064
[    0.000000] pcpu-alloc: s1355376 r0 d12688 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12127540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an1-03070605/linux-devel:devel-hourly-2014030618/.vmlinu=
z-d478a960edf1ea61ca31a07a48a8771f043dba78-20140307064414-3-ivytown2 branch=
=3Dlinux-devel/devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig=
-an1-03070605/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-0=
3765-gd478a96
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 271544K/327280K available (11636K kernel code, 868K =
rwdata, 4068K rodata, 1956K init, 5592K bss, 55736K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa93000 - 0xfffff000   (5552 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff3fe000   (1708 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x82033000 - 0x8221c000   (1956 kB)
[    0.000000]       .data : 0x81b5d71f - 0x82031360   (4943 kB)
[    0.000000]       .text : 0x81000000 - 0x81b5d71f   (11637 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D91c0a000 soft=3D91c0c000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.918 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008000] Calibrating delay loop (skipped) preset value.. 4987.83 Bogo=
MIPS (lpj=3D9975672)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] Mount-cache hash table entries: 512
[    0.008000] Initializing cgroup subsys debug
[    0.008014] Initializing cgroup subsys devices
[    0.008562] Initializing cgroup subsys freezer
[    0.009166] Initializing cgroup subsys net_cls
[    0.009720] Initializing cgroup subsys blkio
[    0.010256] Initializing cgroup subsys perf_event
[    0.010830] Initializing cgroup subsys net_prio
[    0.011479] BUG: unable to handle kernel paging request at 91c24000
[    0.012000] IP: [<820444c8>] sysenter_setup+0x90/0x2b4
[    0.012000] *pde =3D 123fd067 *pte =3D 11c24060=20
[    0.012000] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[    0.012000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-g=
d478a96 #4
[    0.012000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.012000] task: 81f5ff20 ti: 81f58000 task.ti: 81f58000
[    0.012000] EIP: 0060:[<820444c8>] EFLAGS: 00210206 CPU: 0
[    0.012000] EIP is at sysenter_setup+0x90/0x2b4
[    0.012000] EAX: 078bfbfd EBX: 91c23000 ECX: 00000044 EDX: 00001044
[    0.012000] ESI: 82091418 EDI: 91c24000 EBP: 81f59fb4 ESP: 81f59f90
[    0.012000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.012000] CR0: 8005003b CR2: 91c24000 CR3: 02228000 CR4: 00000690
[    0.012000] Stack:
[    0.012000]  81f6d0c0 91c22b80 00000f61 00000800 80002001 078bfbfd 82085=
0e0 00020800
[    0.012000]  82229800 81f59fbc 82039789 81f59fcc 820397bf 820850e0 00020=
800 81f59fec
[    0.012000]  82033a6d 0000027e ffffffff ffffffff 82033530 820850e0 00000=
800 81f59ff8
[    0.012000] Call Trace:
[    0.012000]  [<82039789>] identify_boot_cpu+0x17/0x28
[    0.012000]  [<820397bf>] check_bugs+0xb/0xbb
[    0.012000]  [<82033a6d>] start_kernel+0x376/0x381
[    0.012000]  [<82033530>] ? repair_env_string+0x51/0x51
[    0.012000]  [<82033364>] i386_start_kernel+0x12e/0x131
[    0.012000] Code: f6 c4 08 74 12 ba 5c 14 09 82 be 18 04 09 82 81 ea 18 =
04 09 82 eb 10 ba 18 04 09 82 be e8 f3 08 82 81 ea e8 f3 08 82 89 d1 89 df =
<f3> a4 89 d8 e8 bf fe ff ff b9 04 00 00 00 ba c0 39 df 81 89 d8
[    0.012000] EIP: [<820444c8>] sysenter_setup+0x90/0x2b4 SS:ESP 0068:81f5=
9f90
[    0.012000] CR2: 0000000091c24000
[    0.012000] ---[ end trace 244d6fd44ed68f46 ]---
[    0.012000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.012000] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-a=
n1-03070605/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-037=
65-gd478a96 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-an1-03070605/linux-devel:devel-hourly-2014030618/.vmlinuz-d478a960edf1e=
a61ca31a07a48a8771f043dba78-20140307064414-3-ivytown2 branch=3Dlinux-devel/=
devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-an1-03070605/d=
478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-gd478a96' =
 -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,=
vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::12350-:22 -boot or=
der=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/=
shm/kboot/pid-quantal-ivytown2-19 -serial file:/dev/shm/kboot/serial-quanta=
l-ivytown2-19 -daemonize -display none -monitor null=20

--kbCYTQG2MZjuOjyn
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-an1-03070605-d478a960edf1ea61ca31a07a48a8771f043dba78-Kernel-panic---not-syncing:-Attempted-to-kill-the-idle-102631.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEt
MDMwNzA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg0CgoyMDE0LTAz
LTA3LTA3OjEwOjU2IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjE1MCByZWFsICAxOTIwIHVzZXIgIDE3NCBzeXMgIDEzODguODYlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNQoKMjAxNC0wMy0wNy0wNzoxMzo0NiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1Li4uLi4uLi4uLgkyCTYJMTIJMTkJMjAgU1VD
Q0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCAwNDE0ODU1ZmRjNGE0MGRhMDUyMjFmYzYwNjJj
Y2NiYzBjMzBmMTY5CmdpdCBiaXNlY3Qgc3RhcnQgZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdh
NDhhODc3MWYwNDNkYmE3OCAwNDE0ODU1ZmRjNGE0MGRhMDUyMjFmYzYwNjJjY2NiYzBjMzBm
MTY5IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImQ0NzhhOTYw
ZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgiLCAiLWciLCAiMDQxNDg1NWZkYzRh
NDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNl
Y3QiXQpCaXNlY3Rpbmc6IDM3NjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEyIHN0ZXBzKQpbNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1
YWQzOTE4Ml0gTWVyZ2UgJ2RpZ3NpZy9mb3ItbWltaScgaW50byBkZXZlbC1ob3VybHktMjAx
NDAzMDYxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo2YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3
ZDMwMGMzZDVhZDM5MTgyOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDc6MjE6MjQgNmMy
MTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4MiBjb21waWxpbmcKMjU2IHJl
YWwgIDE5MTEgdXNlciAgMTczIHN5cyAgODEyLjIzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1h
bjEtMDMwNzA2MDUKCjIwMTQtMDMtMDctMDc6MjU6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYS4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjAy
MDAyM10gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgYmxraW8KWyAgICAwLjAyMDYwN10g
SW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgcGVyZl9ldmVudApbICAgIDAuMDIxMzQxXSBJ
bml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBuZXRfcHJpbwpbICAgIDAuMDI0MTM0XSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDhkYzI0MDAwClsg
ICAgMC4wMjYxMzJdIElQOiBbPDgyMDI4NTA4Pl0gc3lzZW50ZXJfc2V0dXArMHg5MC8weDJi
NApbICAgIDAuMDI3OTI4XSAqcGRlID0gMGUzZWQwNjcgKnB0ZSA9IDBkYzI0MDYwIApbICAg
IDAuMDI4MDAwXSBPb3BzOiAwMDAyIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAu
MDI4MDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0
LjAtcmM1LTAxNDAwLWc2YzIxOTFhICM1MwpbICAgIDAuMDI4MDAwXSBIYXJkd2FyZSBuYW1l
OiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMjgwMDBdIHRh
c2s6IDgxZjQ1ZjIwIHRpOiA4MWYzZTAwMCB0YXNrLnRpOiA4MWYzZTAwMApbICAgIDAuMDI4
MDAwXSBFSVA6IDAwNjA6Wzw4MjAyODUwOD5dIEVGTEFHUzogMDAyMTAyMDYgQ1BVOiAwClsg
ICAgMC4wMjgwMDBdIEVJUCBpcyBhdCBzeXNlbnRlcl9zZXR1cCsweDkwLzB4MmI0ClsgICAg
MC4wMjgwMDBdIEVBWDogMDc4YmZiZmQgRUJYOiA4ZGMyMzAwMCBFQ1g6IDAwMDAwMDQ0IEVE
WDogMDAwMDEwNDQKWyAgICAwLjAyODAwMF0gRVNJOiA4MjA3NTQxOCBFREk6IDhkYzI0MDAw
IEVCUDogODFmM2ZmYjQgRVNQOiA4MWYzZmY5MApbICAgIDAuMDI4MDAwXSAgRFM6IDAwN2Ig
RVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAwLjAyODAwMF0gQ1Iw
OiA4MDA1MDAzYiBDUjI6IDhkYzI0MDAwIENSMzogMDIyMGIwMDAgQ1I0OiAwMDAwMDY5MApb
ICAgIDAuMDI4MDAwXSBTdGFjazoKWyAgICAwLjAyODAwMF0gIDgxZjUyZjQwIDhkYzIyYjgw
IDAwMDAwZjYxIDAwMDAwODAwIDgwMDAyMDAxIDA3OGJmYmZkIDgyMDY5MGUwIDAwMDIwODAw
ClsgICAgMC4wMjgwMDBdICA4MjIwYzgwMCA4MWYzZmZiYyA4MjAxZDc5NCA4MWYzZmZjYyA4
MjAxZDdjYSA4MjA2OTBlMCAwMDAyMDgwMCA4MWYzZmZlYwpbICAgIDAuMDI4MDAwXSAgODIw
MTdhNmQgMDAwMDAyNzEgZmZmZmZmZmYgZmZmZmZmZmYgODIwMTc1MzAgODIwNjkwZTAgMDAw
MDA4MDAgODFmM2ZmZjgKWyAgICAwLjAyODAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAyODAw
MF0gIFs8ODIwMWQ3OTQ+XSBpZGVudGlmeV9ib290X2NwdSsweDE3LzB4MjgKWyAgICAwLjAy
ODAwMF0gIFs8ODIwMWQ3Y2E+XSBjaGVja19idWdzKzB4Yi8weGJiClsgICAgMC4wMjgwMDBd
ICBbPDgyMDE3YTZkPl0gc3RhcnRfa2VybmVsKzB4Mzc2LzB4MzgxClsgICAgMC4wMjgwMDBd
ICBbPDgyMDE3NTMwPl0gPyByZXBhaXJfZW52X3N0cmluZysweDUxLzB4NTEKWyAgICAwLjAy
ODAwMF0gIFs8ODIwMTczNjQ+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDEyZS8weDEzMQpbICAg
IDAuMDI4MDAwXSBDb2RlOiBmNiBjNCAwOCA3NCAxMiBiYSA1YyA1NCAwNyA4MiBiZSAxOCA0
NCAwNyA4MiA4MSBlYSAxOCA0NCAwNyA4MiBlYiAxMCBiYSAxOCA0NCAwNyA4MiBiZSBlOCAz
MyAwNyA4MiA4MSBlYSBlOCAzMyAwNyA4MiA4OSBkMSA4OSBkZiA8ZjM+IGE0IDg5IGQ4IGU4
IGJmIGZlIGZmIGZmIGI5IDA0IDAwIDAwIDAwIGJhIDNmIGQwIGRkIDgxIDg5IGQ4ClsgICAg
MC4wMjgwMDBdIEVJUDogWzw4MjAyODUwOD5dIHN5c2VudGVyX3NldHVwKzB4OTAvMHgyYjQg
U1M6RVNQIDAwNjg6ODFmM2ZmOTAKWyAgICAwLjAyODAwMF0gQ1IyOiAwMDAwMDAwMDhkYzI0
MDAwClsgICAgMC4wMjgwMDBdIC0tLVsgZW5kIHRyYWNlIGYxMzE0MzYyMTM3M2JlOTQgXS0t
LQpbICAgIDAuMDI4MDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVk
IHRvIGtpbGwgdGhlIGlkbGUgdGFzayEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAz
MDcwNjA1LzZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2ct
cXVhbnRhbC1pbm4tMTM6MjAxNDAzMDcwNzI4NDA6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3
MDYwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS82YzIxOTFhZDli
NjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyL2RtZXNnLXlvY3RvLWlubi0xOToyMDE0
MDMwNzA3MjgzNzppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAw
YzNkNWFkMzkxODIvZG1lc2cteW9jdG8taW5uLTI2OjIwMTQwMzA3MDcyODQxOmkzODYtcmFu
ZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMw
NzA2MDUvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy15
b2N0by1pbm4tMzI6MjAxNDAzMDcwNzI4Mzc6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYw
NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS82YzIxOTFhZDliNjIy
NTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyL2RtZXNnLXlvY3RvLWlubi00MToyMDE0MDMw
NzA3Mjg0MDppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4xLTAzMDcwNjA1LzZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNk
NWFkMzkxODIvZG1lc2cteW9jdG8taW5uLTg6MjAxNDAzMDcwNzI4NDA6aTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMzA3MDYwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYw
NS82YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyL2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTE1OjIwMTQwMzA3MDcyODM2OmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2
MDU6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo1Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1hbjEtMDMwNzA2MDUvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4
Mi9kbWVzZy1xdWFudGFsLXJvYW0tMTg6MjAxNDAzMDcwNzI4NDI6aTM4Ni1yYW5kY29uZmln
LWFuMS0wMzA3MDYwNTozLjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhOjUzCjA6ODo4IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA3IDA3OjI4OjU3IFJFUEVB
VCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAxNDAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKWzYxY2EwMWI1YWE2MzYwNWUwMzNmMTgyNmRjY2ViNDE0
MjFhYTcyY2RdIE1lcmdlICd1Ymlmcy9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
MzA2MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6NjFjYTAxYjVhYTYzNjA1ZTAzM2YxODI2ZGNj
ZWI0MTQyMWFhNzJjZDpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA3OjI4OjU5IDYxY2Ew
MWI1YWE2MzYwNWUwMzNmMTgyNmRjY2ViNDE0MjFhYTcyY2QgY29tcGlsaW5nCjEzNCByZWFs
ICAxOTAzIHVzZXIgIDE3MSBzeXMgIDE1NDIuODUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFu
MS0wMzA3MDYwNQoKMjAxNC0wMy0wNy0wNzozMToyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmM1LTAwNzg0LWc2MWNhMDFiLi4JMS4uLi4uLi4JMTkJMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA2MTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEwIHN0ZXBzKQpbNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmY10g
TWVyZ2UgJ3RpcC94ODYvdmRzbycgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODo1M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIw
Y2ZjOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDc6Mzc6MzAgNTNkY2EwYjVmMGUyNTdm
MDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYyBjb21waWxpbmcKMTEzIHJlYWwgIDE4OTIgdXNl
ciAgMTY4IHN5cyAgMTgxOS40NCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1
CgoyMDE0LTAzLTA3LTA3OjM5OjM4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUt
MDExOTItZzUzZGNhMGIuLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC4wMTA1MjNdIElu
aXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGJsa2lvClsgICAgMC4wMTA5OTddIEluaXRpYWxp
emluZyBjZ3JvdXAgc3Vic3lzIHBlcmZfZXZlbnQKWyAgICAwLjAxMTU2OV0gSW5pdGlhbGl6
aW5nIGNncm91cCBzdWJzeXMgbmV0X3ByaW8KWyAgICAwLjAxMjEwN10gQlVHOiB1bmFibGUg
dG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA4ZGMyNDAwMApbICAgIDAuMDEy
ODY4XSBJUDogWzw4MjAyODRhYz5dIHN5c2VudGVyX3NldHVwKzB4OTAvMHgyYjQKWyAgICAw
LjAxMzUwMV0gKnBkZSA9IDBlM2VkMDY3ICpwdGUgPSAwZGMyNDA2MCAKWyAgICAwLjAxNDAx
M10gT29wczogMDAwMiBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjAxNDU5OV0g
Q1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0w
MTE5Mi1nNTNkY2EwYiAjNTUKWyAgICAwLjAxNTQ5Ml0gSGFyZHdhcmUgbmFtZTogQm9jaHMg
Qm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDE2MDAwXSB0YXNrOiA4MWY0
NWYyMCB0aTogODFmM2UwMDAgdGFzay50aTogODFmM2UwMDAKWyAgICAwLjAxNjAwMF0gRUlQ
OiAwMDYwOls8ODIwMjg0YWM+XSBFRkxBR1M6IDAwMjEwMjA2IENQVTogMApbICAgIDAuMDE2
MDAwXSBFSVAgaXMgYXQgc3lzZW50ZXJfc2V0dXArMHg5MC8weDJiNApbICAgIDAuMDE2MDAw
XSBFQVg6IDA3OGJmYmZkIEVCWDogOGRjMjMwMDAgRUNYOiAwMDAwMDA0NCBFRFg6IDAwMDAx
MDQ0ClsgICAgMC4wMTYwMDBdIEVTSTogODIwNzU0MTggRURJOiA4ZGMyNDAwMCBFQlA6IDgx
ZjNmZmI0IEVTUDogODFmM2ZmOTAKWyAgICAwLjAxNjAwMF0gIERTOiAwMDdiIEVTOiAwMDdi
IEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC4wMTYwMDBdIENSMDogODAwNTAw
M2IgQ1IyOiA4ZGMyNDAwMCBDUjM6IDAyMjA2MDAwIENSNDogMDAwMDA2OTAKWyAgICAwLjAx
NjAwMF0gU3RhY2s6ClsgICAgMC4wMTYwMDBdICA4MWY1MmY0MCA4ZGMyMmI4MCAwMDAwMGY2
MSAwMDAwMDgwMCA4MDAwMjAwMSAwNzhiZmJmZCA4MjA2OTBlMCAwMDAyMDgwMApbICAgIDAu
MDE2MDAwXSAgODIyMDc4MDAgODFmM2ZmYmMgODIwMWQ3OTQgODFmM2ZmY2MgODIwMWQ3Y2Eg
ODIwNjkwZTAgMDAwMjA4MDAgODFmM2ZmZWMKWyAgICAwLjAxNjAwMF0gIDgyMDE3YTZkIDAw
MDAwMjcxIGZmZmZmZmZmIGZmZmZmZmZmIDgyMDE3NTMwIDgyMDY5MGUwIDAwMDAwODAwIDgx
ZjNmZmY4ClsgICAgMC4wMTYwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMTYwMDBdICBbPDgy
MDFkNzk0Pl0gaWRlbnRpZnlfYm9vdF9jcHUrMHgxNy8weDI4ClsgICAgMC4wMTYwMDBdICBb
PDgyMDFkN2NhPl0gY2hlY2tfYnVncysweGIvMHhiYgpbICAgIDAuMDE2MDAwXSAgWzw4MjAx
N2E2ZD5dIHN0YXJ0X2tlcm5lbCsweDM3Ni8weDM4MQpbICAgIDAuMDE2MDAwXSAgWzw4MjAx
NzUzMD5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1MS8weDUxClsgICAgMC4wMTYwMDBdICBb
PDgyMDE3MzY0Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHgxMmUvMHgxMzEKWyAgICAwLjAxNjAw
MF0gQ29kZTogZjYgYzQgMDggNzQgMTIgYmEgNWMgNTQgMDcgODIgYmUgMTggNDQgMDcgODIg
ODEgZWEgMTggNDQgMDcgODIgZWIgMTAgYmEgMTggNDQgMDcgODIgYmUgZTggMzMgMDcgODIg
ODEgZWEgZTggMzMgMDcgODIgODkgZDEgODkgZGYgPGYzPiBhNCA4OSBkOCBlOCBiZiBmZSBm
ZiBmZiBiOSAwNCAwMCAwMCAwMCBiYSBmZiBjYiBkZCA4MSA4OSBkOApbICAgIDAuMDE2MDAw
XSBFSVA6IFs8ODIwMjg0YWM+XSBzeXNlbnRlcl9zZXR1cCsweDkwLzB4MmI0IFNTOkVTUCAw
MDY4OjgxZjNmZjkwClsgICAgMC4wMTYwMDBdIENSMjogMDAwMDAwMDA4ZGMyNDAwMApbICAg
IDAuMDE2MDAwXSAtLS1bIGVuZCB0cmFjZSBhNDgxODI4MTZiZGEzZWM5IF0tLS0KWyAgICAw
LjAxNjAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxs
IHRoZSBpZGxlIHRhc2shCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81
M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXF1YW50YWwt
aW5uLTE1OjIwMTQwMzA3MDc0MzUyOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvNTNkY2EwYjVmMGUyNTdmMDBi
OTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy1xdWFudGFsLWlubi0yMDoyMDE0MDMwNzA3
NDM1MTppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4xLTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdk
MjBjZmMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNzoyMDE0MDMwNzA3NDM1MjppMzg2LXJh
bmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NTUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkx
ZmMzYmU5OGZiNDdjMDdkMjBjZmMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQwMzA3
MDc0MzUyOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6My4xNC4wLXJjNS0wMTE5Mi1n
NTNkY2EwYjo1NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvNTNkY2Ew
YjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy15b2N0by1pbm4tMjM6
MjAxNDAzMDcwNzQzNTE6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2Jl
OThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXlvY3RvLWlubi00MToyMDE0MDMwNzA3NDM1MjppMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4x
LTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMvZG1l
c2cteW9jdG8taW5uLTQ0OjIwMTQwMzA3MDc0MzUxOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMw
NzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvNTNkY2EwYjVm
MGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy15b2N0by1pbm4tNDg6MjAx
NDAzMDcwNzQzNTE6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThm
YjQ3YzA3ZDIwY2ZjL2RtZXNnLXlvY3RvLWlubi00OjIwMTQwMzA3MDc0MzUyOmkzODYtcmFu
ZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMw
NzA2MDUvNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy15
b2N0by1pdnl0b3duMi0xODoyMDE0MDMwNzA3NDM0OTppMzg2LXJhbmRjb25maWctYW4xLTAz
MDcwNjA1OjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NTUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4xLTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdk
MjBjZmMvZG1lc2cteW9jdG8taXZ5dG93bjItMjg6MjAxNDAzMDcwNzQzNTI6aTM4Ni1yYW5k
Y29uZmlnLWFuMS0wMzA3MDYwNTozLjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBiOjU1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81M2RjYTBiNWYwZTI1N2YwMGI5MWZj
M2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXlvY3RvLXJvYW0tMTY6MjAxNDAzMDcwNzQzNTE6
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTozLjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBi
OjU1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81M2RjYTBiNWYwZTI1
N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTM6MjAx
NDAzMDcwNzQzNTE6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTozLjE0LjAtcmM1LTAx
MTkyLWc1M2RjYTBiOjU1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS81
M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXF1YW50YWwt
c3RvYWtsZXktNjoyMDE0MDMwNzA3NDM1NjppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1
OjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YW4xLTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMv
ZG1lc2cteW9jdG8tbGtwLXN0MDEtODoyMDE0MDMwNzA3NDM1NjppMzg2LXJhbmRjb25maWct
YW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NTUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZi
NDdjMDdkMjBjZmMvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS0zOjIwMTQwMzA3MDc0NDAwOmkz
ODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6My4xNC4wLXJjNS0wMTE5Mi1nNTNkY2EwYjo1
NQowOjE2OjE2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA3
IDA3OjQ0OjA5IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA0MDggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltmMjVlZDBlYmMxOTRhNTEwNDJh
NTM5MmNhODIxZGUyZmY2NjYxMjc1XSBNZXJnZSAnc2xhdmUtZG1hL25leHQnIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwMzA2MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMw
NzA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZjI1ZWQwZWJjMTk0
YTUxMDQyYTUzOTJjYTgyMWRlMmZmNjY2MTI3NTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3
LTA3OjQ0OjEwIGYyNWVkMGViYzE5NGE1MTA0MmE1MzkyY2E4MjFkZTJmZjY2NjEyNzUgY29t
cGlsaW5nCjEyMCByZWFsICAxODkzIHVzZXIgIDE2NiBzeXMgIDE3MTUuNzUlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNQoKMjAxNC0wMy0wNy0wNzo0NjoyNiBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwNzk5LWdmMjVlZDBlLi4uLi4uLi4uCTE0CTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMzkzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZTAwOTliODE2NWUyNTI1NTQxZDc4NDRlMjllODgz
ODgyNGIzNjAxZV0gTWVyZ2UgJ3BjbW9vcmUtc2VsaW51eC9uZXh0JyBpbnRvIGRldmVsLWhv
dXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OmUwMDk5YjgxNjVlMjUyNTU0
MWQ3ODQ0ZTI5ZTg4Mzg4MjRiMzYwMWU6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNy0wNzo1
MTo1NyBlMDA5OWI4MTY1ZTI1MjU1NDFkNzg0NGUyOWU4ODM4ODI0YjM2MDFlIGNvbXBpbGlu
ZwozMSByZWFsICA1MSB1c2VyICA1IHN5cyAgMTgwLjY2JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1hbjEtMDMwNzA2MDUKCjIwMTQtMDMtMDctMDc6NTI6MzggZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xNC4wLXJjNS0wMTA1NC1nZTAwOTliOC4uLi4uLi4uLgkyCTIwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMTM4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA4IHN0ZXBzKQpbYzI0YmY1NDY4M2RkMDA5OGU4NzhhMGNmNDBlMjY2N2U0NmEzOWEwYV0g
TWVyZ2UgJ3JlbmVzYXMvbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODpjMjRiZjU0NjgzZGQwMDk4ZTg3OGEwY2Y0MGUyNjY3ZTQ2YTM5
YTBhOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDc6NTg6MDkgYzI0YmY1NDY4M2RkMDA5
OGU4NzhhMGNmNDBlMjY2N2U0NmEzOWEwYSBjb21waWxpbmcKMzQgcmVhbCAgNTYgdXNlciAg
NiBzeXMgIDE3OS43OCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1CgoyMDE0
LTAzLTA3LTA3OjU4OjU3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDExNzkt
Z2MyNGJmNTQuLi4JMS4uLi4JNAk5CTEyCTE3Li4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgps
aW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSB0aXAveDg2L3Zkc28KbGluZWFyLWJp
c2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlz
ZWN0IHN0YXJ0IDUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMgYzI0
YmY1NDY4M2RkMDA5OGU4NzhhMGNmNDBlMjY2N2U0NmEzOWEwYSAtLQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBjMjRiZjU0Li4uIE1lcmdlICdyZW5lc2FzL25leHQnIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwMzA2MTgKSEVBRCBpcyBub3cgYXQgZmJlOTM4ZS4uLiBNZXJnZSAn
YXJtLXNvYy9uZXh0L2RyaXZlcnMnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTgKQmlz
ZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAz
IHN0ZXBzKQpbNjU0M2NhNmZlZTdkM2IzMTRiZGE2OWI4M2ZkNDI5ZWQzZTMzNjY0NV0geDg2
LCB2ZHNvOiBDbGVhbnVwIF9fdmRzb19nZXR0aW1lb2ZkYXkoKQpsaW5lYXItYmlzZWN0OiBn
aXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1hbjEtMDMwNzA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2
MTg6NjU0M2NhNmZlZTdkM2IzMTRiZGE2OWI4M2ZkNDI5ZWQzZTMzNjY0NTpiaXNlY3QtbGlu
dXg0CgoyMDE0LTAzLTA3LTA4OjEyOjAxIDY1NDNjYTZmZWU3ZDNiMzE0YmRhNjliODNmZDQy
OWVkM2UzMzY2NDUgY29tcGlsaW5nCjEyMyByZWFsICAxOTM5IHVzZXIgIDE1OCBzeXMgIDE3
MDEuNTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNQoKMjAxNC0wMy0wNy0w
ODoxNDoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwMDA2LWc2NTQzY2E2
Li4uLi4uLi4JMTMJMTYJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbNGRlYThlNDgyNGIzNjNj
NTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOV0geDg2LCB2ZHNvOiBBZGQgMzIgYml0IFZEU08g
dGltZSBzdXBwb3J0IGZvciAzMiBiaXQga2VybmVsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYW4xLTAzMDcwNjA1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjRk
ZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTk6YmlzZWN0LWxpbnV4NAoK
MjAxNC0wMy0wNy0wODoxOTo1MSA0ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1
OTIxNDE5IGNvbXBpbGluZwo4NiByZWFsICAxMjUzIHVzZXIgIDEwMiBzeXMgIDE1NzUuMjYl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNQoKMjAxNC0wMy0wNy0wODoyMToy
NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0Li4uLiBU
RVNUIEZBSUxVUkUKWyAgICAwLjAwODM4NV0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMg
YmxraW8KWyAgICAwLjAwODc1Nl0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgcGVyZl9l
dmVudApbICAgIDAuMDA5MTU0XSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBuZXRfcHJp
bwpbICAgIDAuMDA5NTk0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyBy
ZXF1ZXN0IGF0IDkxYzI0MDAwClsgICAgMC4wMTAxNDddIElQOiBbPDgyMDE4NDk0Pl0gc3lz
ZW50ZXJfc2V0dXArMHg5MC8weDJiNApbICAgIDAuMDEwNTk3XSAqcGRlID0gMTIzZmQwNjcg
KnB0ZSA9IDExYzI0MDYwIApbICAgIDAuMDEwOTgyXSBPb3BzOiAwMDAyIFsjMV0gU01QIERF
QlVHX1BBR0VBTExPQwpbICAgIDAuMDExNDAxXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0ICM2MApbICAgIDAu
MDEyMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICAgMC4wMTIwMDBdIHRhc2s6IDgxZjM1ZjIwIHRpOiA4MWYyZTAwMCB0YXNrLnRp
OiA4MWYyZTAwMApbICAgIDAuMDEyMDAwXSBFSVA6IDAwNjA6Wzw4MjAxODQ5ND5dIEVGTEFH
UzogMDAyMTAyMDYgQ1BVOiAwClsgICAgMC4wMTIwMDBdIEVJUCBpcyBhdCBzeXNlbnRlcl9z
ZXR1cCsweDkwLzB4MmI0ClsgICAgMC4wMTIwMDBdIEVBWDogMDc4YmZiZmQgRUJYOiA5MWMy
MzAwMCBFQ1g6IDAwMDAwMGQ0IEVEWDogMDAwMDEwZDQKWyAgICAwLjAxMjAwMF0gRVNJOiA4
MjA2NTQ0OCBFREk6IDkxYzI0MDAwIEVCUDogODFmMmZmYjQgRVNQOiA4MWYyZmY5MApbICAg
IDAuMDEyMDAwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAw
NjgKWyAgICAwLjAxMjAwMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDkxYzI0MDAwIENSMzogMDIx
ZjYwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDAuMDEyMDAwXSBTdGFjazoKWyAgICAwLjAxMjAw
MF0gIDgxZjQyZTQwIDkxYzIyYjgwIDAwMDAwZjYxIDAwMDAwODAwIDgwMDAyMDAxIDA3OGJm
YmZkIDgyMDU5MGUwIDAwMDIwODAwClsgICAgMC4wMTIwMDBdICA4MjFmNzgwMCA4MWYyZmZi
YyA4MjAwZDc4YiA4MWYyZmZjYyA4MjAwZDdjMSA4MjA1OTBlMCAwMDAyMDgwMCA4MWYyZmZl
YwpbICAgIDAuMDEyMDAwXSAgODIwMDdhNmQgMDAwMDAyNzEgZmZmZmZmZmYgZmZmZmZmZmYg
ODIwMDc1MzAgODIwNTkwZTAgMDAwMDA4MDAgODFmMmZmZjgKWyAgICAwLjAxMjAwMF0gQ2Fs
bCBUcmFjZToKWyAgICAwLjAxMjAwMF0gIFs8ODIwMGQ3OGI+XSBpZGVudGlmeV9ib290X2Nw
dSsweDE3LzB4MjgKWyAgICAwLjAxMjAwMF0gIFs8ODIwMGQ3YzE+XSBjaGVja19idWdzKzB4
Yi8weGJiClsgICAgMC4wMTIwMDBdICBbPDgyMDA3YTZkPl0gc3RhcnRfa2VybmVsKzB4Mzc2
LzB4MzgxClsgICAgMC4wMTIwMDBdICBbPDgyMDA3NTMwPl0gPyByZXBhaXJfZW52X3N0cmlu
ZysweDUxLzB4NTEKWyAgICAwLjAxMjAwMF0gIFs8ODIwMDczNjQ+XSBpMzg2X3N0YXJ0X2tl
cm5lbCsweDEyZS8weDEzMQpbICAgIDAuMDEyMDAwXSBDb2RlOiBmNiBjNCAwOCA3NCAxMiBi
YSAxYyA1NSAwNiA4MiBiZSA0OCA0NCAwNiA4MiA4MSBlYSA0OCA0NCAwNiA4MiBlYiAxMCBi
YSA0OCA0NCAwNiA4MiBiZSA4OCAzMyAwNiA4MiA4MSBlYSA4OCAzMyAwNiA4MiA4OSBkMSA4
OSBkZiA8ZjM+IGE0IDg5IGQ4IGU4IGJmIGZlIGZmIGZmIGI5IDA0IDAwIDAwIDAwIGJhIDc3
IGI5IGRjIDgxIDg5IGQ4ClsgICAgMC4wMTIwMDBdIEVJUDogWzw4MjAxODQ5ND5dIHN5c2Vu
dGVyX3NldHVwKzB4OTAvMHgyYjQgU1M6RVNQIDAwNjg6ODFmMmZmOTAKWyAgICAwLjAxMjAw
MF0gQ1IyOiAwMDAwMDAwMDkxYzI0MDAwClsgICAgMC4wMTIwMDBdIC0tLVsgZW5kIHRyYWNl
IDQ1ZGFhZDY1ZWQ0MDg1NTkgXS0tLQpbICAgIDAuMDEyMDAwXSBLZXJuZWwgcGFuaWMgLSBu
b3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgdGhlIGlkbGUgdGFzayEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgw
NDBkN2M2YzU5MjE0MTkvZG1lc2ctcXVhbnRhbC1zbmItNzoyMDE0MDMwNzA4MjMwMzppMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4x
LTAzMDcwNjA1LzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1l
c2cteW9jdG8tc25iLTM0OjIwMTQwMzA3MDgyMzAzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMw
NzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvNGRlYThlNDgy
NGIzNjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy15b2N0by1zbmItNjoyMDE0
MDMwNzA4MjMwMzppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBk
N2M2YzU5MjE0MTkvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yNzoyMDE0MDMwNzA4MjMxMjpp
Mzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6
NjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzRkZWE4ZTQ4MjRiMzYz
YzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1lc2cteW9jdG8tYmVucy03OjIwMTQwMzA3
MDgyMzEzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6My4xNC4wLXJjNS0wMDAwOS1n
NGRlYThlNDo2MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvNGRlYThl
NDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy15b2N0by1qYWtldG93
bi0xMzoyMDE0MDMwNzA4MjMxMDppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzRkZWE4ZTQ4MjRiMzYzYzUzZjMy
MGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1lc2cteW9jdG8tc25iLTI0OjIwMTQwMzA3MDgyMzA5
OmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1hbjEtMDMwNzA2MDUvNGRlYThlNDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQx
OS9kbWVzZy15b2N0by14Z3dvLTQ6MjAxNDAzMDcwODIzMTI6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMzA3MDYwNTozLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0OjYwCjA6ODo4IGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA3IDA4OjIzOjI3IFJFUEVBVCBD
T1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxIHN0ZXApCls4MjcyNDE2OTY4YTliZDgyNDQ1MTUxNzk2MjVjZGVmZmQ3YzJjOTBh
XSB4ODYsIHZkc286IFBhdGNoIGFsdGVybmF0aXZlcyBpbiB0aGUgMzItYml0IFZEU08KcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJu
ZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwMzA2MTg6ODI3MjQxNjk2OGE5YmQ4MjQ0NTE1MTc5NjI1Y2RlZmZkN2My
YzkwYTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA4OjIzOjI4IDgyNzI0MTY5NjhhOWJk
ODI0NDUxNTE3OTYyNWNkZWZmZDdjMmM5MGEgY29tcGlsaW5nCjkxIHJlYWwgIDEyNTAgdXNl
ciAgMTAzIHN5cyAgMTQ3Ni40NCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1
CgoyMDE0LTAzLTA3LTA4OjI1OjE0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUt
MDAwMDgtZzgyNzI0MTYuLi4uLi4uLgkxOQkyMCBTVUNDRVNTCgo0ZGVhOGU0ODI0YjM2M2M1
M2YzMjBkMzI4MDQwZDdjNmM1OTIxNDE5IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1p
dCA0ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1OTIxNDE5CkF1dGhvcjogU3Rl
ZmFuaSBTZWlib2xkIDxzdGVmYW5pQHNlaWJvbGQubmV0PgpEYXRlOiAgIE1vbiBNYXIgMyAy
MjoxMjoyMCAyMDE0ICswMTAwCgogICAgeDg2LCB2ZHNvOiBBZGQgMzIgYml0IFZEU08gdGlt
ZSBzdXBwb3J0IGZvciAzMiBiaXQga2VybmVsCiAgICAKICAgIFRoaXMgcGF0Y2ggYWRkIHRo
ZSB0aW1lIHN1cHBvcnQgZm9yIDMyIGJpdCBhIFZEU08gdG8gYSAzMiBiaXQga2VybmVsLgog
ICAgCiAgICBGb3IgMzIgYml0IHByb2dyYW1zIHJ1bm5pbmcgb24gYSAzMiBiaXQga2VybmVs
LCB0aGUgc2FtZSBtZWNoYW5pc20gaXMKICAgIHVzZWQgYXMgZm9yIDY0IGJpdCBwcm9ncmFt
cyBydW5uaW5nIG9uIGEgNjQgYml0IGtlcm5lbC4KICAgIAogICAgUmV2aWV3ZWQtYnk6IEFu
ZHkgTHV0b21pcnNraSA8bHV0b0BhbWFjYXBpdGFsLm5ldD4KICAgIFNpZ25lZC1vZmYtYnk6
IFN0ZWZhbmkgU2VpYm9sZCA8c3RlZmFuaUBzZWlib2xkLm5ldD4KICAgIExpbms6IGh0dHA6
Ly9sa21sLmtlcm5lbC5vcmcvci8xMzkzODgxMTQzLTM1NjktMTAtZ2l0LXNlbmQtZW1haWwt
c3RlZmFuaUBzZWlib2xkLm5ldAogICAgU2lnbmVkLW9mZi1ieTogSC4gUGV0ZXIgQW52aW4g
PGhwYUBsaW51eC5pbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCAzMGZiMzIzNzQyNjYzYmUx
YjAwNzk4MDI3ZWU3YjMwOTQxMzVjNGQ5IDFkMjg2NGY1Y2JmMjNmZTg1MmU4NTUxZDYxMTQx
ZGQ4OWEwZGQ5NjIgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo4MjcyNDE2OTY4YTliZDgyNDQ1MTUxNzk2
MjVjZGVmZmQ3YzJjOTBhOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDg6MzA6MTUgODI3
MjQxNjk2OGE5YmQ4MjQ0NTE1MTc5NjI1Y2RlZmZkN2MyYzkwYSByZXVzZSAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvODI3MjQxNjk2OGE5YmQ4MjQ0NTE1MTc5NjI1
Y2RlZmZkN2MyYzkwYS92bWxpbnV6LTMuMTQuMC1yYzUtMDAwMDgtZzgyNzI0MTYKCjIwMTQt
MDMtMDctMDg6MzA6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4JMgkyNwk1NQk1
Ni4JNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
MzA2MTg6ZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3ODpiaXNlY3Qt
bGludXg0CiBURVNUIEZBSUxVUkUKWyAgICAwLjAxMTA3MV0gSW5pdGlhbGl6aW5nIGNncm91
cCBzdWJzeXMgYmxraW8KWyAgICAwLjAxMTU1Nl0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJz
eXMgcGVyZl9ldmVudApbICAgIDAuMDEyMDE3XSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5
cyBuZXRfcHJpbwpbICAgIDAuMDEyNjc4XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVs
IHBhZ2luZyByZXF1ZXN0IGF0IDhkYzI0MDAwClsgICAgMC4wMTM0OTddIElQOiBbPDgyMDQ0
NGM4Pl0gc3lzZW50ZXJfc2V0dXArMHg5MC8weDJiNApbICAgIDAuMDE0MTIwXSAqcGRlID0g
MGUzZWQwNjcgKnB0ZSA9IDBkYzI0MDYwIApbICAgIDAuMDE0NjY3XSBPb3BzOiAwMDAyIFsj
MV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMDE1MjY0XSBDUFU6IDAgUElEOiAwIENv
bW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2ICM0
ClsgICAgMC4wMTYwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hz
IDAxLzAxLzIwMTEKWyAgICAwLjAxNjAwMF0gdGFzazogODFmNWZmMjAgdGk6IDgxZjU4MDAw
IHRhc2sudGk6IDgxZjU4MDAwClsgICAgMC4wMTYwMDBdIEVJUDogMDA2MDpbPDgyMDQ0NGM4
Pl0gRUZMQUdTOiAwMDIxMDIwNiBDUFU6IDAKWyAgICAwLjAxNjAwMF0gRUlQIGlzIGF0IHN5
c2VudGVyX3NldHVwKzB4OTAvMHgyYjQKWyAgICAwLjAxNjAwMF0gRUFYOiAwNzhiZmJmZCBF
Qlg6IDhkYzIzMDAwIEVDWDogMDAwMDAwNDQgRURYOiAwMDAwMTA0NApbICAgIDAuMDE2MDAw
XSBFU0k6IDgyMDkxNDE4IEVESTogOGRjMjQwMDAgRUJQOiA4MWY1OWZiNCBFU1A6IDgxZjU5
ZjkwClsgICAgMC4wMTYwMDBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAw
MCBTUzogMDA2OApbICAgIDAuMDE2MDAwXSBDUjA6IDgwMDUwMDNiIENSMjogOGRjMjQwMDAg
Q1IzOiAwMjIyODAwMCBDUjQ6IDAwMDAwNjkwClsgICAgMC4wMTYwMDBdIFN0YWNrOgpbICAg
IDAuMDE2MDAwXSAgODFmNmQwYzAgOGRjMjJiODAgMDAwMDBmNjEgMDAwMDA4MDAgODAwMDIw
MDEgMDc4YmZiZmQgODIwODUwZTAgMDAwMjA4MDAKWyAgICAwLjAxNjAwMF0gIDgyMjI5ODAw
IDgxZjU5ZmJjIDgyMDM5Nzg5IDgxZjU5ZmNjIDgyMDM5N2JmIDgyMDg1MGUwIDAwMDIwODAw
IDgxZjU5ZmVjClsgICAgMC4wMTYwMDBdICA4MjAzM2E2ZCAwMDAwMDI3ZSBmZmZmZmZmZiBm
ZmZmZmZmZiA4MjAzMzUzMCA4MjA4NTBlMCAwMDAwMDgwMCA4MWY1OWZmOApbICAgIDAuMDE2
MDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDE2MDAwXSAgWzw4MjAzOTc4OT5dIGlkZW50aWZ5
X2Jvb3RfY3B1KzB4MTcvMHgyOApbICAgIDAuMDE2MDAwXSAgWzw4MjAzOTdiZj5dIGNoZWNr
X2J1Z3MrMHhiLzB4YmIKWyAgICAwLjAxNjAwMF0gIFs8ODIwMzNhNmQ+XSBzdGFydF9rZXJu
ZWwrMHgzNzYvMHgzODEKWyAgICAwLjAxNjAwMF0gIFs8ODIwMzM1MzA+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4NTEvMHg1MQpbICAgIDAuMDE2MDAwXSAgWzw4MjAzMzM2ND5dIGkzODZf
c3RhcnRfa2VybmVsKzB4MTJlLzB4MTMxClsgICAgMC4wMTYwMDBdIENvZGU6IGY2IGM0IDA4
IDc0IDEyIGJhIDVjIDE0IDA5IDgyIGJlIDE4IDA0IDA5IDgyIDgxIGVhIDE4IDA0IDA5IDgy
IGViIDEwIGJhIDE4IDA0IDA5IDgyIGJlIGU4IGYzIDA4IDgyIDgxIGVhIGU4IGYzIDA4IDgy
IDg5IGQxIDg5IGRmIDxmMz4gYTQgODkgZDggZTggYmYgZmUgZmYgZmYgYjkgMDQgMDAgMDAg
MDAgYmEgYzAgMzkgZGYgODEgODkgZDgKWyAgICAwLjAxNjAwMF0gRUlQOiBbPDgyMDQ0NGM4
Pl0gc3lzZW50ZXJfc2V0dXArMHg5MC8weDJiNCBTUzpFU1AgMDA2ODo4MWY1OWY5MApbICAg
IDAuMDE2MDAwXSBDUjI6IDAwMDAwMDAwOGRjMjQwMDAKWyAgICAwLjAxNjAwMF0gLS0tWyBl
bmQgdHJhY2UgOGQ1YTdmYmRlOGZjZThkMiBdLS0tClsgICAgMC4wMTYwMDBdIEtlcm5lbCBw
YW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrIQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvZDQ3OGE5NjBlZGYxZWE2MWNh
MzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy1xdWFudGFsLXdhaW1lYS0xOjIwMTQwMzA3
MDcxMDIzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6My4xNC4wLXJjNS0wMzc2NS1n
ZDQ3OGE5Njo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9kNDc4YTk2
MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXF1YW50YWwtaXZ5dG93
bjItMTk6MjAxNDAzMDcwNjQ5MjA6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTozLjE0
LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAz
MDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2ct
eW9jdG8taW5uLTE1OjIwMTQwMzA3MDcxMDE0OmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2
MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvZDQ3OGE5NjBlZGYx
ZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pdnl0b3duMi0xNDoy
MDE0MDMwNzA3MTAxNTppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUt
MDM3NjUtZ2Q0NzhhOTY6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUv
ZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1p
dnl0b3duMi00OjIwMTQwMzA3MDY0OTIyOmkzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6
My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5Njo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MS0wMzA3MDYwNS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTg6MjAxNDAzMDcwNjQ5MjA6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMzA3MDYwNTozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4xLTAzMDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFm
MDQzZGJhNzgvZG1lc2cteW9jdG8taXZ5dG93bjItMzA6MjAxNDAzMDcwNjQ5MjQ6aTM4Ni1y
YW5kY29uZmlnLWFuMS0wMzA3MDYwNTozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjQKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMx
YTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNzoyMDE0MDMw
NzA2NDkyMTppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDM3NjUt
Z2Q0NzhhOTY6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvZDQ3OGE5
NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pbm4tMjY6
MjAxNDAzMDcwNzEwMTY6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0
OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWlubi00OjIwMTQwMzA3MDcxMDE2OmkzODYt
cmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEt
MDMwNzA2MDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVz
Zy15b2N0by1pbm4tMTI6MjAxNDAzMDcwNjQ5MjY6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3
MDYwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9kNDc4YTk2MGVk
ZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWlubi0yMzoyMDE0
MDMwNzA2NDkyMDppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3
NzFmMDQzZGJhNzgvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yNDoyMDE0MDMwNzA3MTAxNTpp
Mzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6
NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvZDQ3OGE5NjBlZGYxZWE2
MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy1xdWFudGFsLWlubi00MDoyMDE0MDMw
NzA2NDkyNjppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4xLTAzMDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFm
MDQzZGJhNzgvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMDoyMDE0MDMwNzA2NDkyNDppMzg2
LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6NAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvZDQ3OGE5NjBlZGYxZWE2MWNh
MzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy1xdWFudGFsLWlubi00MjoyMDE0MDMwNzA3
MTAxNDppMzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4xLTAzMDcwNjA1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQz
ZGJhNzgvZG1lc2cteW9jdG8td2FpbWVhLTEwOjIwMTQwMzA3MDcxMDIyOmkzODYtcmFuZGNv
bmZpZy1hbjEtMDMwNzA2MDU6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5Njo0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0
OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWlubi04OjIwMTQwMzA3MDcxMDE2OmkzODYt
cmFuZGNvbmZpZy1hbjEtMDMwNzA2MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEt
MDMwNzA2MDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVz
Zy15b2N0by1pbm4tNDM6MjAxNDAzMDcwNzEwMTQ6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3
MDYwNTo6CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93
IGF0IGQ0NzhhOTYgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwMzA2
MTgnCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIGQ0NzhhOTYuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIw
MTQwMzA2MTgnCkhFQUQgaXMgbm93IGF0IGMzYmViYzcuLi4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMzA3MDYwNS9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODpjM2JlYmM3MWM0YmNkYWZhMjRi
NTA2YWRmMGMxZGUzYzFmNzdlMmUwOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDg6Mzc6
MjIgYzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMCBjb21waWxpbmcK
CjIwMTQtMDMtMDctMDg6Mzk6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0w
MDE4NS1nYzNiZWJjNy4uLi4uLi4uCTEJMTAJNDIJNTQuLi4uLi4uLi4JNjAgU1VDQ0VTUwoK
Cj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9kYXZlbS9uZXQKSEVBRCBpcyBub3cgYXQgMGZmYjJmZS4uLiBBZGQg
bGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMDYKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDMwNzA2MDUvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2Ex
N2RhMDE4YmYwNjMyY2YwMzpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA4OjUxOjAzIDBm
ZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMgcmV1c2UgL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAzMDcwNjA1LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdk
YTAxOGJmMDYzMmNmMDMvdm1saW51ei0zLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTIt
ZzBmZmIyZmUKCjIwMTQtMDMtMDctMDg6NTE6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE0
CTYwIFNVQ0NFU1MKCg==

--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-03765-gd478a96"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
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
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
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
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
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
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
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
CONFIG_MGEODEGX1=y
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
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
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

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
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
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
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
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
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
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
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
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
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NF_TABLES=y
# CONFIG_NFT_EXTHDR is not set
# CONFIG_NFT_META is not set
CONFIG_NFT_RBTREE=y
CONFIG_NFT_HASH=y
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=y
# CONFIG_NFT_LIMIT is not set
# CONFIG_NFT_QUEUE is not set
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_SET=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_LOG=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
# CONFIG_NETFILTER_XT_TARGET_TPROXY is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=y
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_L2TP=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPPORT=y
CONFIG_IP_SET_HASH_IPPORTIP=y
CONFIG_IP_SET_HASH_IPPORTNET=y
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
CONFIG_IP_SET_LIST_SET=y
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CHAIN_ROUTE_IPV4=y
# CONFIG_NFT_REJECT_IPV4 is not set
CONFIG_NF_TABLES_ARP=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_RPFILTER=y
CONFIG_IP_NF_MATCH_TTL=y
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_NF_TABLES_BRIDGE=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
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
# CONFIG_ATM is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_OPENVSWITCH_VXLAN=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCMCIA is not set
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=y
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=y
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
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
# CONFIG_MAC80211_MESH_CSA_DEBUG is not set
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
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
# CONFIG_FW_LOADER_USER_HELPER is not set
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
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
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
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
CONFIG_PARIDE_PCD=y
CONFIG_PARIDE_PF=y
CONFIG_PARIDE_PT=y
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
CONFIG_PARIDE_BPCK=y
CONFIG_PARIDE_BPCK6=y
# CONFIG_PARIDE_COMM is not set
# CONFIG_PARIDE_DSTR is not set
CONFIG_PARIDE_FIT2=y
CONFIG_PARIDE_FIT3=y
# CONFIG_PARIDE_EPAT is not set
# CONFIG_PARIDE_EPIA is not set
# CONFIG_PARIDE_FRIQ is not set
CONFIG_PARIDE_FRPW=y
# CONFIG_PARIDE_KBIC is not set
CONFIG_PARIDE_KTTI=y
CONFIG_PARIDE_ON20=y
# CONFIG_PARIDE_ON26 is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
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
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
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
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
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
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_HIGHBANK=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ARCNET_COM20020_CS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
CONFIG_STMMAC_DEBUG_FS=y
# CONFIG_STMMAC_DA is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
CONFIG_GIGASET_DEBUG=y
# CONFIG_MISDN is not set

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
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
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
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
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
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
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
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
# CONFIG_I2C_SH_MOBILE is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_FSL_DSPI is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
# CONFIG_SPI_ORION is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_SUN4I=y
CONFIG_SPI_SUN6I=y
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
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

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

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
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

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
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
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
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
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
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
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
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
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
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_HECUBA=y
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
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
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
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=y
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_SUBSET=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

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
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

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
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
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
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_PALMAS=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_TI_PIPE3 is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
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
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

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
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

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
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
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
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
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
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_EVM_HMAC_ATTRS="fsuuid"
CONFIG_EVM_HMAC_XATTRS="security.selinux security.SMACK64 security.ima security.capability"
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
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
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
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
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
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
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--kbCYTQG2MZjuOjyn--
