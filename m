Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaKQGFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:05:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:31438 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaKQGFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:05:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,401,1413270000"; 
   d="scan'208";a="638061095"
Date: Mon, 17 Nov 2014 14:05:28 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [x86, mm] BUG: Bad page state in process swapper/0  pfn:02500
Message-ID: <20141117060528.GA3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git x86/pmd-nx
commit 3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 ("x86, mm: set NX across entire PMD at boot")


+------------------------------------------+------------+------------+
|                                          | b23dc5a7cc | 3622dcc2b4 |
+------------------------------------------+------------+------------+
| boot_successes                           | 4          | 0          |
| boot_failures                            | 0          | 19         |
| BUG:Bad_page_state_in_process            | 0          | 19         |
| BUG:Bad_page_map_in_process              | 0          | 14         |
| BUG:Bad_rss-counter_state_mm:#idx:val    | 0          | 2          |
| backtrace:free_reserved_area             | 0          | 19         |
| backtrace:free_init_pages                | 0          | 19         |
| backtrace:mark_rodata_ro                 | 0          | 19         |
| backtrace:vm_munmap                      | 0          | 2          |
| backtrace:SyS_munmap                     | 0          | 2          |
| backtrace:do_execve                      | 0          | 12         |
| backtrace:SyS_execve                     | 0          | 12         |
| backtrace:do_group_exit                  | 0          | 10         |
| backtrace:SyS_exit_group                 | 0          | 10         |
| backtrace:vfs_read                       | 0          | 3          |
| backtrace:SyS_read                       | 0          | 3          |
| general_protection_fault                 | 0          | 3          |
| RIP:release_pages                        | 0          | 3          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 3          |
+------------------------------------------+------------+------------+


[    5.435374] PM: Hibernation image not present or could not be loaded.
[    5.437869] Freeing unused kernel memory: 1448K (ffffffff8215b000 - ffffffff822c5000)
[    5.439558] Write protecting the kernel read-only data: 16384k
[    5.441103] BUG: Bad page state in process swapper/0  pfn:02500
[    5.442204] page:ffffea0000094000 count:0 mapcount:-127 mapping:          (null) index:0x2
[    5.443939] flags: 0x1ffff8000000000()
[    5.444891] page dumped because: nonzero mapcount
[    5.445861] Modules linked in:
[    5.446711] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-00185-g3622dcc #1
[    5.448369] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.449450]  ffffffff81cf3ba4 ffff880037a33d78 ffffffff819ea6b0 00000000000010ac
[    5.451360]  ffffea0000094000 ffff880037a33da8 ffffffff8119b29c 0000000000000000
[    5.453289]  ffffea0000094000 0000000000000001 0000000000000000 ffff880037a33de8
[    5.455234] Call Trace:
[    5.455942]  [<ffffffff819ea6b0>] dump_stack+0x4e/0x68
[    5.456971]  [<ffffffff8119b29c>] bad_page+0xf5/0x113
[    5.457972]  [<ffffffff8119b379>] free_pages_prepare+0xbf/0x13f
[    5.459067]  [<ffffffff8119d65e>] free_hot_cold_page+0x35/0x1a0
[    5.460178]  [<ffffffff8119d878>] __free_pages+0x1b/0x24
[    5.461219]  [<ffffffff8119d930>] free_reserved_area+0xaf/0x10b
[    5.462339]  [<ffffffff8106c126>] free_init_pages+0x8d/0x99
[    5.463407]  [<ffffffff8106cb1a>] mark_rodata_ro+0xb6/0x11c
[    5.464522]  [<ffffffff819e15b5>] ? rest_init+0x89/0x89
[    5.465533]  [<ffffffff819e15d2>] kernel_init+0x1d/0xdf
[    5.466596]  [<ffffffff819f15bc>] ret_from_fork+0x7c/0xb0
[    5.467633]  [<ffffffff819e15b5>] ? rest_init+0x89/0x89
[    5.468711] Disabling lock debugging due to kernel taint
[    5.470302] Freeing unused kernel memory: 1488K (ffffffff8248c000 - ffffffff82600000)
[    5.472182] Freeing unused kernel memory: 20K (ffff8800019fb000 - ffff880001a00000)
[    5.477823] Freeing unused kernel memory: 1812K (ffff880001e3b000 - ffff880002000000)
[    5.582078] BUG: Bad page state in process udevd  pfn:0248c
[    5.582103] BUG: Bad page state in process udevd  pfn:024a0
[    5.582104] page:ffffea0000092800 count:2 mapcount:0 mapping:ffff88003ec8ea69 index:0x2
[    5.582107] flags: 0x1ffff8000080068(uptodate|lru|active|swapbacked)



	--yliu

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-00185-g3622dcc (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-19) ) #1 SMP Sat Nov 15 17:25:59 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-1G-6/ran=
d_boot-1-debian-x86_64.cgz-x86_64-lkp-3622dcc2b4f4eaf23bae2511a30fc449d0e5f=
0d9-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/3622dcc2b4f4eaf23b=
ae2511a30fc449d0e5f0d9/vmlinuz-3.18.0-rc4-00185-g3622dcc kconfig=3Dx86_64-l=
kp commit=3D3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 branch=3Dkees/x86/pmd-=
nx root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-vp-1G/boot/1=
/debian-x86_64.cgz/x86_64-lkp/3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9/0 ip=
=3D::::vm-vp-1G-6::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq=
_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_=
panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000003fffe000-0x000000003fffffff] reser=
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x3fffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02467000, 0x02467fff] PGTABLE
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] BRK [0x02469000, 0x02469fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x39a00000-0x39bfffff]
[    0.000000]  [mem 0x39a00000-0x39bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x38000000-0x399fffff]
[    0.000000]  [mem 0x38000000-0x399fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x37ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x37ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x39c00000-0x3fffdfff]
[    0.000000]  [mem 0x39c00000-0x3fdfffff] page 2M
[    0.000000]  [mem 0x3fe00000-0x3fffdfff] page 4k
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x39c6d000-0x3ffeffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000003FFFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000003FFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000003FFFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x000000003FFFFF40 000040
[    0.000000] ACPI: SSDT 0x000000003FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000003FFFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000003FFFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003fffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x3fffa000-0x3fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:3fff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003840000=
0-ffff8800393fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x3fffdfff]
[    0.000000] On node 0 totalpages: 262044
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 258046 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x40000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880039a00000 s81920 r8192=
 d28672 u1048576
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 39a0d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 257927
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-1=
G-6/rand_boot-1-debian-x86_64.cgz-x86_64-lkp-3622dcc2b4f4eaf23bae2511a30fc4=
49d0e5f0d9-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/3622dcc2b4f=
4eaf23bae2511a30fc449d0e5f0d9/vmlinuz-3.18.0-rc4-00185-g3622dcc kconfig=3Dx=
86_64-lkp commit=3D3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 branch=3Dkees/x=
86/pmd-nx root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-vp-1G=
/boot/1/debian-x86_64.cgz/x86_64-lkp/3622dcc2b4f4eaf23bae2511a30fc449d0e5f0=
d9/0 ip=3D::::vm-vp-1G-6::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebu=
g sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 soft=
lockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 908360K/1048176K available (10206K kernel code, 1383=
K rwdata, 4332K rodata, 1448K init, 1624K bss, 139816K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:33024 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-00185-g3622dcc (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-19) ) #1 SMP Sat Nov 15 17:25:59 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-1G-6/ran=
d_boot-1-debian-x86_64.cgz-x86_64-lkp-3622dcc2b4f4eaf23bae2511a30fc449d0e5f=
0d9-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/3622dcc2b4f4eaf23b=
ae2511a30fc449d0e5f0d9/vmlinuz-3.18.0-rc4-00185-g3622dcc kconfig=3Dx86_64-l=
kp commit=3D3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 branch=3Dkees/x86/pmd-=
nx root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-vp-1G/boot/1=
/debian-x86_64.cgz/x86_64-lkp/3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9/0 ip=
=3D::::vm-vp-1G-6::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq=
_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_=
panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000003fffe000-0x000000003fffffff] reser=
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x3fffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02467000, 0x02467fff] PGTABLE
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] BRK [0x02469000, 0x02469fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x39a00000-0x39bfffff]
[    0.000000]  [mem 0x39a00000-0x39bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x38000000-0x399fffff]
[    0.000000]  [mem 0x38000000-0x399fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x37ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x37ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x39c00000-0x3fffdfff]
[    0.000000]  [mem 0x39c00000-0x3fdfffff] page 2M
[    0.000000]  [mem 0x3fe00000-0x3fffdfff] page 4k
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x39c6d000-0x3ffeffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000003FFFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000003FFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000003FFFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x000000003FFFFF40 000040
[    0.000000] ACPI: SSDT 0x000000003FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000003FFFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000003FFFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003fffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x3fffa000-0x3fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:3fff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003840000=
0-ffff8800393fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x3fffdfff]
[    0.000000] On node 0 totalpages: 262044
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 258046 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x40000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880039a00000 s81920 r8192=
 d28672 u1048576
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 39a0d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 257927
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-1=
G-6/rand_boot-1-debian-x86_64.cgz-x86_64-lkp-3622dcc2b4f4eaf23bae2511a30fc4=
49d0e5f0d9-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/3622dcc2b4f=
4eaf23bae2511a30fc449d0e5f0d9/vmlinuz-3.18.0-rc4-00185-g3622dcc kconfig=3Dx=
86_64-lkp commit=3D3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 branch=3Dkees/x=
86/pmd-nx root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-vp-1G=
/boot/1/debian-x86_64.cgz/x86_64-lkp/3622dcc2b4f4eaf23bae2511a30fc449d0e5f0=
d9/0 ip=3D::::vm-vp-1G-6::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebu=
g sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 soft=
lockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 908360K/1048176K available (10206K kernel code, 1383=
K rwdata, 4332K rodata, 1448K init, 1624K bss, 139816K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:33024 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.562 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.12 Bogo=
MIPS (lpj=3D10774248)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] ACPI: Core revision 20140926
[    0.008816] ACPI: All ACPI Tables successfully acquired
[    0.010138] Dentry cache hash table entries: 131072 (order: 8, 1048576 b=
ytes)
[    0.012181] Inode-cache hash table entries: 65536 (order: 7, 524288 byte=
s)
[    0.013774] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.014989] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 b=
ytes)
[    0.016302] Initializing cgroup subsys memory
[    0.017251] Initializing cgroup subsys devices
[    0.018200] Initializing cgroup subsys freezer
[    0.019151] Initializing cgroup subsys blkio
[    0.020007] Initializing cgroup subsys perf_event
[    0.020979] Initializing cgroup subsys hugetlb
[    0.021982] mce: CPU supports 10 MCE banks
[    0.022928] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022928] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.024244] Freeing SMP alternatives memory: 40K (ffffffff822c5000 - fff=
fffff822cf000)
[    0.031287] ftrace: allocating 39681 entries in 156 pages
[    0.040133] Getting VERSION: 50014
[    0.040976] Getting VERSION: 50014
[    0.041802] Getting ID: 0
[    0.042534] Getting ID: ff000000
[    0.043355] Getting LVT0: 8700
[    0.044007] Getting LVT1: 8400
[    0.044840] enabled ExtINT on CPU#0
[    0.046386] ENABLING IO-APIC IRQs
[    0.047204] init IO_APIC IRQs
[    0.048005]  apic 0 pin 0 not connected
[    0.048880] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.050599] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.052017] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053716] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056016] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.057705] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.059398] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.060015] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.061691] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.064016] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.065704] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.068016] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.069724] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.071431] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.072015] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.073722] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.076014]  apic 0 pin 16 not connected
[    0.076886]  apic 0 pin 17 not connected
[    0.077756]  apic 0 pin 18 not connected
[    0.078624]  apic 0 pin 19 not connected
[    0.080003]  apic 0 pin 20 not connected
[    0.080877]  apic 0 pin 21 not connected
[    0.081744]  apic 0 pin 22 not connected
[    0.082610]  apic 0 pin 23 not connected
[    0.083622] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.084002] smpboot: CPU0: Intel Core i7 9xx (Nehalem Class Core i7) (fa=
m: 06, model: 1a, stepping: 03)
[    0.086222] Using local APIC timer interrupts.
[    0.086222] calibrating APIC timer ...
[    0.092000] ... lapic delta =3D 6250169
[    0.092000] ... PM-Timer delta =3D 357965
[    0.092000] ... PM-Timer result ok
[    0.092000] ..... delta 6250169
[    0.092000] ..... mult: 268442714
[    0.092000] ..... calibration result: 4000108
[    0.092000] ..... CPU clock speed is 2693.1939 MHz.
[    0.092000] ..... host bus clock speed is 1000.0108 MHz.
[    0.092073] Performance Events: unsupported p6 CPU model 26 no PMU drive=
r, software events only.
[    0.095892] x86: Booting SMP configuration:
[    0.096003] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 0:3fff2041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.112030] x86: Booted up 1 node, 2 CPUs
[    0.112013] KVM setup async PF for cpu 1
[    0.112017] kvm-stealtime: cpu 1, msr 39b0d140
[    0.116003] smpboot: Total of 2 processors activated (10774.24 BogoMIPS)
[    0.117520] devtmpfs: initialized
[    0.124522] xor: measuring software checksum speed
[    0.164019]    prefetch64-sse:   183.000 MB/sec
[    0.204005]    generic_sse:   179.000 MB/sec
[    0.204903] xor: using function: prefetch64-sse (183.000 MB/sec)
[    0.206006] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.207497] NET: Registered protocol family 16
[    0.220010] cpuidle: using governor ladder
[    0.232010] cpuidle: using governor menu
[    0.233333] ACPI: bus type PCI registered
[    0.234218] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.235535] PCI: Using configuration type 1 for base access
[    0.332010] raid6: sse2x1    7911 MB/s
[    0.400010] raid6: sse2x2    9894 MB/s
[    0.468007] raid6: sse2x4   11384 MB/s
[    0.468841] raid6: using algorithm sse2x4 (11384 MB/s)
[    0.469861] raid6: using ssse3x2 recovery algorithm
[    0.470868] ACPI: Added _OSI(Module Device)
[    0.471788] ACPI: Added _OSI(Processor Device)
[    0.472004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.472958] ACPI: Added _OSI(Processor Aggregator Device)
[    0.474398] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.477314] ACPI: Interpreter enabled
[    0.478155] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[    0.480667] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    0.482622] ACPI: (supports S0 S3 S4 S5)
[    0.483487] ACPI: Using IOAPIC for interrupt routing
[    0.484034] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.489638] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.490767] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.491961] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.492103] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.494463] acpiphp: Slot [3] registered
[    0.496037] acpiphp: Slot [4] registered
[    0.496931] acpiphp: Slot [5] registered
[    0.497821] acpiphp: Slot [6] registered
[    0.498716] acpiphp: Slot [7] registered
[    0.500037] acpiphp: Slot [8] registered
[    0.500931] acpiphp: Slot [9] registered
[    0.501826] acpiphp: Slot [10] registered
[    0.502729] acpiphp: Slot [11] registered
[    0.503633] acpiphp: Slot [12] registered
[    0.504035] acpiphp: Slot [13] registered
[    0.504939] acpiphp: Slot [14] registered
[    0.506103] acpiphp: Slot [15] registered
[    0.507113] acpiphp: Slot [24] registered
[    0.508039] acpiphp: Slot [25] registered
[    0.508946] acpiphp: Slot [26] registered
[    0.509848] acpiphp: Slot [27] registered
[    0.510744] acpiphp: Slot [28] registered
[    0.512035] acpiphp: Slot [29] registered
[    0.512936] acpiphp: Slot [30] registered
[    0.513834] acpiphp: Slot [31] registered
[    0.514702] PCI host bridge to bus 0000:00
[    0.515584] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.516004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.517115] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.518233] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.520006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.521231] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.522671] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.524451] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.528258] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.530335] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.531557] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.532004] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.533218] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.534535] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.536319] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.537913] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.539338] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.544035] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.546487] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.553796] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.555458] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.556990] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.560007] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.565893] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.567278] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.569015] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.571041] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.577779] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.579890] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.580990] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.588320] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.596004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.598027] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.604310] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.606651] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.608483] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.614766] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.617016] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.619007] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.625527] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.627751] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.628975] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.636132] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.637718] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.642359] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.643865] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.644904] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.646411] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.648057] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.649601] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.650889] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.650889] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.652006] vgaarb: loaded
[    0.652778] vgaarb: bridge control possible 0000:00:02.0
[    0.656012] SCSI subsystem initialized
[    0.656064] libata version 3.00 loaded.
[    0.656087] ACPI: bus type USB registered
[    0.657064] usbcore: registered new interface driver usbfs
[    0.658166] usbcore: registered new interface driver hub
[    0.660012] usbcore: registered new device driver usb
[    0.660118] pps_core: LinuxPPS API ver. 1 registered
[    0.661156] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.664393] PTP clock support registered
[    0.664393] EDAC MC: Ver: 3.0.0
[    0.665248] PCI: Using ACPI for IRQ routing
[    0.666185] PCI: pci_cache_line_size set to 64 bytes
[    0.668191] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.669337] e820: reserve RAM buffer [mem 0x3fffe000-0x3fffffff]
[    0.672072] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.672072] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.673332] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.680066] Switched to clocksource kvm-clock
[    0.694445] pnp: PnP ACPI init
[    0.695331] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.697146] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.698356] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.700099] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.701286] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.703043] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.704247] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.705958] pnp 00:03: [dma 2]
[    0.706770] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.707980] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.709728] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.710929] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.712665] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.713881] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.715605] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.716955] pnp: PnP ACPI: found 7 devices
[    0.725045] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.726117] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.727179] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.728330] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.729509] NET: Registered protocol family 2
[    0.730664] TCP established hash table entries: 8192 (order: 4, 65536 by=
tes)
[    0.731944] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    0.733198] TCP: Hash tables configured (established 8192 bind 8192)
[    0.734421] TCP: reno registered
[    0.735225] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.736350] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.737595] NET: Registered protocol family 1
[    0.738663] RPC: Registered named UNIX socket transport module.
[    0.739776] RPC: Registered udp transport module.
[    0.740747] RPC: Registered tcp transport module.
[    0.741705] RPC: Registered tcp NFSv4.1 backchannel transport module
--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--SUOF0GtieIMvvwua--
