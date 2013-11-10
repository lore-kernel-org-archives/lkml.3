Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3KJJq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:46:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:17848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3KJJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,671,1378882800"; 
   d="log'?scan'208";a="425056587"
Date: Sun, 10 Nov 2013 17:46:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Mario <jmario@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: [kallsyms] BUG: unable to handle kernel NULL pointer dereference at
 00000008
Message-ID: <20131110094608.GB21916@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joe,

Here is one more bisect result for your reference.

commit eea0e9cbb9e65cd553d302a4aefd4c7b70d9fd90
Author: Joe Mario <jmario@redhat.com>
Date:   Wed Oct 23 15:06:53 2013 +0200

    kbuild: Increase kallsyms max symbol length
    
    [AK: This seems like a ticking time bomb even without LTO,
    so should be merged now. It causes very weird problems.
    Thanks to Joe for tracking them down.]
    
    With the added postfixes that LTO adds for local
    symbols, the longest name in the kernel overflows
    the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
    __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802
    
    Double the max symbol name length.
    
    v2: Use 255  (Joe Perches)
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Michal Marek <mmarek@suse.cz>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+-----------------------------------------------------------+--------------+--------------+
|                                                           | 80970472179a | 9aab69def5d7 |
+-----------------------------------------------------------+--------------+--------------+
| good_boots                                                | 58           |              |
| has_kernel_error_warning                                  | 2            | 19           |
| BUG:kernel_boot_hang                                      | 1            |              |
| BUG:Bad_page_map_in_process_killall5_pte:pmd              | 1            |              |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at   | 0            | 19           |
| Oops:PREEMPT_SMP                                          | 0            | 19           |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0            | 19           |
+-----------------------------------------------------------+--------------+--------------+

[    2.754985] NatSemi SCx200 Driver
[    2.755083] cryptomgr_test (23) used greatest stack depth: 7100 bytes left
[    2.760079] Initializing RT-Tester: OK
[    2.790487] BUG: unable to handle kernel NULL pointer dereference at 00000008
[    2.791013] IP: [<b100288e>] restore_sigcontext+0x12e/0x370
[    2.791013] *pde = 00000000 
[    2.791013] Oops: 0002 [#1] PREEMPT SMP 
[    2.791013] Modules linked in:
[    2.791013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-01287-g9aab69d #1176
[    2.791013] task: b0048000 ti: b0044000 task.ti: b0044000
[    2.791013] EIP: 0060:[<b100288e>] EFLAGS: 00010286 CPU: 0
[    2.791013] EIP is at restore_sigcontext+0x12e/0x370
[    2.791013] EAX: 00000000 EBX: b1d04f90 ECX: 0000000d EDX: 00000001
[    2.791013] ESI: 00000006 EDI: 000000c4 EBP: b0045f9c ESP: b0045f80
[    2.791013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    2.791013] CR0: 8005003b CR2: 00000008 CR3: 01e62000 CR4: 00000690
[    2.791013] Stack:
[    2.791013]  000000c4 00000006 00000006 b1c91706 00000000 bdbbb940 b1bb1e20 b0045fac
[    2.791013]  b18491b9 bdbbb940 b0047f88 b0044000 b1876fbb b18491a0 00000000 00000000
[    2.791013]  00000000 00000000 00000000 00000000 0000007b 0000007b 000000d8 00000000
[    2.791013] Call Trace:
[    2.791013]  [<b1c91706>] ? do_early_param+0x12b/0x12b
[    2.791013]  [<b18491b9>] kernel_init+0x19/0x280
[    2.791013]  [<b1876fbb>] ret_from_kernel_thread+0x1b/0x30
[    2.791013]  [<b18491a0>] ? rest_init+0x280/0x280
[    2.791013] Code: 6e e6 b1 00 89 58 3c 8b 5a 20 83 05 60 6e e6 b1 01 83 15 64 6e e6 b1 00 89 18 8b 5a 24 83 05 68 6e e6 b1 01 83 15 6c 6e e6 b1 00 <89> 58 08 8b 5a 28 83 05 70 6e e6 b1 01 83 15 74 6e e6 b1 00 89
[    2.791013] EIP: [<b100288e>] restore_sigcontext+0x12e/0x370 SS:ESP 0068:b0045f80
[    2.791013] CR2: 0000000000000008
[    2.815207] ---[ end trace 7a5fb510918bc4ea ]---
[    2.815952] swapper/0 (1) used greatest stack depth: 5712 bytes left

git bisect start 9aab69def5d79c04a6dbf6d5646043193e673bc5 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good a89b2a0fcc3c857c5b8b6b54798aaba5d1aac28c  # 11:49     20+      0  Merge tag 'usb-for-v3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into connectivity-ti-linux-3.12.y
git bisect good 8ffb929098a56939ac71509302eeab5b207bf262  # 12:14     20+      3  Bluetooth: Remove parent socket usage from l2cap_core.c
git bisect good 90570c54a58ad4543e9ba418ff20424659d5f4e3  # 12:43     20+      0  phy: kconfig: add depends on "USB_SUPPORT" to OMAP_USB2 and TWL4030_USB
git bisect good 4074afe30e0228d9dc299df1d73a511335bb4c5b  # 13:18     20+      2  ARM: OMAP2+: hwmod_7xx: Add data structures for McASP3
git bisect good 9fbe8e5b9724e0034618bd512df9eda4694e77d5  # 13:36     20+      1  Merge branch 'kbuild/kconfig' into kbuild/for-next
git bisect good 7def68012f470495d1aaad9bd51fcd87c6111645  # 14:24     20+      3  Bluetooth: ath3k: Add support for a new AR3012 device
git bisect  bad 3657319957a9e1500bea4694968f97dd596f7b53  # 14:30      0-      1  Merge branch 'kbuild/kbuild' into kbuild/for-next
git bisect  bad 37d1c5fc2dd80db8c084e5c3d324cb92dd6e5a94  # 14:34      0-      1  Merge branches 'kbuild/kbuild' and 'kbuild/misc' into kbuild/for-next
git bisect  bad 21cf6e584ce35b79374581e6344dd7c74f8b4a2b  # 14:36      0-      1  kbuild, bloat-o-meter: fix static detection
git bisect  bad f3462aa952cfc8f4b095103cb9b3d306dd216558  # 14:39      0-      1  Kbuild: Handle longer symbols in kallsyms.c
git bisect  bad eea0e9cbb9e65cd553d302a4aefd4c7b70d9fd90  # 14:40      0-      1  kbuild: Increase kallsyms max symbol length
git bisect good 80970472179a45609c0b11b80619bc8c32b15f77  # 15:08     60+      2  Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
git bisect  bad 9aab69def5d79c04a6dbf6d5646043193e673bc5  # 15:08      0-     19  Merge 'omap-audio/peter/ti/ti-linux-3.12.y-o5_dra7_mcasp' into devel-inn-i386-201311081714
git bisect good 9388496f314901ac8ca155e8558d5dc5dbe39d0d  # 15:33     60+      0  Revert "kbuild: Increase kallsyms max symbol length"
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 15:41     60+      0  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace

Thanks,
Fengguang

--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-st01-12:20131109012457:i386-randconfig-i005-1108:3.12.0-01287-g9aab69d:1176"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-01287-g9aab69d (kbuild@inn) (gcc versio=
n 4.8.1 (Debian 4.8.1-8) ) #1176 SMP PREEMPT Fri Nov 8 17:22:24 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[b00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02762000, 0x02762fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128488(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x02763000, 0x02763fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @bda75000 s1339776 r0 d24192 =
u1363968
[    0.000000] pcpu-alloc: s1339776 r0 d24192 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da77640
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-i005-1108/devel-inn-i386-201=
311081714/.vmlinuz-9aab69def5d79c04a6dbf6d5646043193e673bc5-20131108172357-=
8-lkp-st01 branch=3Dlinux-devel/devel-inn-i386-201311081714 BOOT_IMAGE=3D/k=
ernel/i386-randconfig-i005-1108/9aab69def5d79c04a6dbf6d5646043193e673bc5/vm=
linuz-3.12.0-01287-g9aab69d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 199112K/261744K available (8670K kernel code, 1199K =
rwdata, 2960K rodata, 1832K init, 9184K bss, 62632K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc07fe000 - 0xff7fe000   (1008 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xbfffe000   ( 255 MB)
[    0.000000]       .init : 0xb1c91000 - 0xb1e5b000   (1832 kB)
[    0.000000]       .data : 0xb1877e4f - 0xb1c8ee40   (4187 kB)
[    0.000000]       .text : 0xb1000000 - 0xb1877e4f   (8671 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Db0096000 soft=3Db0080000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2660.102 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5320.20 Bogo=
MIPS (lpj=3D2660102)
[    0.003457] pid_max: default: 4096 minimum: 301
[    0.004134] Security Framework initialized
[    0.005065] Mount-cache hash table entries: 512
[    0.007616] Initializing cgroup subsys devices
[    0.008046] Initializing cgroup subsys freezer
[    0.009034] Initializing cgroup subsys perf_event
[    0.009771] Initializing cgroup subsys net_prio
[    0.010184] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010184] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010184] tlb_flushall_shift: 6
[    0.012389] Freeing SMP alternatives memory: 16K (b1e5b000 - b1e5f000)
[    0.017598] ACPI: Core revision 20130725
[    0.021657] ACPI: All ACPI Tables successfully acquired
[    0.023189] Getting VERSION: 50014
[    0.023737] Getting VERSION: 50014
[    0.024017] Getting ID: 0
[    0.024453] Getting ID: f000000
[    0.025022] Getting LVT0: 8700
[    0.025522] Getting LVT1: 8400
[    0.026010] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.027130] enabled ExtINT on CPU#0
[    0.029536] ENABLING IO-APIC IRQs
[    0.030014] init IO_APIC IRQs
[    0.030495]  apic 0 pin 0 not connected
[    0.031043] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.032041] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.033039] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.034036] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.035036] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036035] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.037035] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.038035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.039036] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040036] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041035] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.043035] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044035] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045035] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046031]  apic 0 pin 16 not connected
[    0.046639]  apic 0 pin 17 not connected
[    0.047006]  apic 0 pin 18 not connected
[    0.048006]  apic 0 pin 19 not connected
[    0.048611]  apic 0 pin 20 not connected
[    0.049006]  apic 0 pin 21 not connected
[    0.050006]  apic 0 pin 22 not connected
[    0.050613]  apic 0 pin 23 not connected
[    0.051185] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.052005] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.054752] Using local APIC timer interrupts.
[    0.054752] calibrating APIC timer ...
[    0.056000] ... lapic delta =3D 6250109
[    0.056000] ... PM-Timer delta =3D 357995
[    0.056000] ... PM-Timer result ok
[    0.056000] ..... delta 6250109
[    0.056000] ..... mult: 268440137
[    0.056000] ..... calibration result: 1000017
[    0.056000] ..... CPU clock speed is 2661.0634 MHz.
[    0.056000] ..... host bus clock speed is 1000.0017 MHz.
[    0.056200] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.068708] SMP alternatives: lockdep: fixing up alternatives
[    0.070016] CPU 1 irqstacks, hard=3Db0108000 soft=3Db010a000
[    0.071008] smpboot: Booting Node   0, Processors  #   1 OK
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.087456] KVM setup async PF for cpu 1
[    0.087691] Brought up 2 CPUs
[    0.087712] ----------------
[    0.087713] | NMI testsuite:
[    0.087714] --------------------
[    0.087456] kvm-stealtime: cpu 1, msr dbc4640
[    0.087716]   remote IPI:  ok  |
[    0.092668]    local IPI:  ok  |
[    0.099039] --------------------
[    0.099562] Good, all   2 testcases passed! |
[    0.100008] ---------------------------------
[    0.100736] smpboot: Total of 2 processors activated (10640.40 BogoMIPS)
[    0.102481] CPU0 attaching sched-domain:
[    0.103059]  domain 0: span 0-1 level CPU
[    0.103710]   groups: 0 (cpu_power =3D 1023) 1
[    0.104486] CPU1 attaching sched-domain:
[    0.105009]  domain 0: span 0-1 level CPU
[    0.106031]   groups: 1 0 (cpu_power =3D 1023)
[    0.109785] EVM: security.capability
[    0.111756] regulator-dummy: no parameters
[    0.113063] NET: Registered protocol family 16
[    0.114526] cpuidle: using governor ladder
[    0.115028] cpuidle: using governor menu
[    0.116643] ACPI: bus type PCI registered
[    0.117291] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.118009] PCI: Using configuration type 1 for base access
[    0.125433] ACPI: Added _OSI(Module Device)
[    0.126012] ACPI: Added _OSI(Processor Device)
[    0.126702] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.127010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.133155] ACPI: EC: Look up EC in DSDT
[    0.143765] ACPI: Interpreter enabled
[    0.144013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.145854] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.147439] ACPI: (supports S0 S3 S5)
[    0.148009] ACPI: Using IOAPIC for interrupt routing
[    0.148874] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.168958] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.169026] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.171482] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.174020] PCI host bridge to bus 0000:00
[    0.174672] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.175010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.176010] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.177010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.178010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.179150] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.182071] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.184347] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.188673] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.191561] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.193193] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.194025] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.196196] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.199036] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.202033] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.211019] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.212878] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.215007] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.217010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.223590] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.225660] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.227587] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.229579] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.237499] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.239585] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.241586] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.249382] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.251010] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.253572] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.261105] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.263010] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.265011] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.272832] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.274570] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.277006] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.284612] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.286590] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.288608] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.296809] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.298339] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.303927] pci_bus 0000:00: on NUMA node 0
[    0.306973] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.308385] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.309596] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.310578] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.312169] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.314533] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.315045] ACPI: \_SB_.PCI0: notify handler is installed
[    0.316324] Found 1 acpi root devices
[    0.317653] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.319019] vgaarb: loaded
[    0.319457] vgaarb: bridge control possible 0000:00:02.0
[    0.321513] PCI: Using ACPI for IRQ routing
[    0.322014] PCI: pci_cache_line_size set to 64 bytes
[    0.323327] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.324022] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.326306] Bluetooth: Core ver 2.17
[    0.326934] NET: Registered protocol family 31
[    0.327008] Bluetooth: HCI device and connection manager initialized
[    0.328041] Bluetooth: HCI socket layer initialized
[    0.329018] Bluetooth: L2CAP socket layer initialized
[    0.330062] Bluetooth: SCO socket layer initialized
[    0.331034] NetLabel: Initializing
[    0.331568] NetLabel:  domain hash size =3D 128
[    0.332008] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.333160] NetLabel:  unlabeled traffic allowed by default
[    0.334105] nfc: nfc_init: NFC Core ver 0.1
[    0.335098] NET: Registered protocol family 39
[    0.336375] Switched to clocksource kvm-clock
[    0.337503] FS-Cache: Loaded
[    0.338003] pnp: PnP ACPI init
[    0.338576] ACPI: bus type PNP registered
[    0.339344] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.340764] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.341864] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.343219] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.344345] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.345701] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.346814] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.348126] pnp 00:03: [dma 2]
[    0.348684] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.349820] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.351204] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.352368] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.353702] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.355470] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.356903] pnp: PnP ACPI: found 7 devices
[    0.357582] ACPI: bus type PNP unregistered
[    0.393922] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.394822] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.395716] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.396749] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.397864] NET: Registered protocol family 2
[    0.402963] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.404231] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.405529] TCP: Hash tables configured (established 2048 bind 2048)
[    0.406650] TCP: reno registered
[    0.407228] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.408270] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.409767] NET: Registered protocol family 1
[    0.410529] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.411507] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.412500] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.413543] pci 0000:00:02.0: Boot video device
[    0.414431] PCI: CLS 0 bytes, default 64
[    0.415722] Unpacking initramfs...
[    2.733807] Freeing initrd memory: 25284K (be73f000 - bfff0000)
[    2.747727] DMA-API: preallocated 65536 debug entries
[    2.748555] DMA-API: debugging enabled by kernel config
[    2.750127] apm: BIOS not found.
[    2.750822] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.751738] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.752682] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.754985] NatSemi SCx200 Driver
[    2.755083] cryptomgr_test (23) used greatest stack depth: 7100 bytes le=
ft
[    2.760079] Initializing RT-Tester: OK
[    2.790487] BUG: unable to handle kernel NULL pointer dereference at 000=
00008
[    2.791013] IP: [<b100288e>] restore_sigcontext+0x12e/0x370
[    2.791013] *pde =3D 00000000=20
[    2.791013] Oops: 0002 [#1] PREEMPT SMP=20
[    2.791013] Modules linked in:
[    2.791013] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-01287-g9aab=
69d #1176
[    2.791013] task: b0048000 ti: b0044000 task.ti: b0044000
[    2.791013] EIP: 0060:[<b100288e>] EFLAGS: 00010286 CPU: 0
[    2.791013] EIP is at restore_sigcontext+0x12e/0x370
[    2.791013] EAX: 00000000 EBX: b1d04f90 ECX: 0000000d EDX: 00000001
[    2.791013] ESI: 00000006 EDI: 000000c4 EBP: b0045f9c ESP: b0045f80
[    2.791013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    2.791013] CR0: 8005003b CR2: 00000008 CR3: 01e62000 CR4: 00000690
[    2.791013] Stack:
[    2.791013]  000000c4 00000006 00000006 b1c91706 00000000 bdbbb940 b1bb1=
e20 b0045fac
[    2.791013]  b18491b9 bdbbb940 b0047f88 b0044000 b1876fbb b18491a0 00000=
000 00000000
[    2.791013]  00000000 00000000 00000000 00000000 0000007b 0000007b 00000=
0d8 00000000
[    2.791013] Call Trace:
[    2.791013]  [<b1c91706>] ? do_early_param+0x12b/0x12b
[    2.791013]  [<b18491b9>] kernel_init+0x19/0x280
[    2.791013]  [<b1876fbb>] ret_from_kernel_thread+0x1b/0x30
[    2.791013]  [<b18491a0>] ? rest_init+0x280/0x280
[    2.791013] Code: 6e e6 b1 00 89 58 3c 8b 5a 20 83 05 60 6e e6 b1 01 83 =
15 64 6e e6 b1 00 89 18 8b 5a 24 83 05 68 6e e6 b1 01 83 15 6c 6e e6 b1 00 =
<89> 58 08 8b 5a 28 83 05 70 6e e6 b1 01 83 15 74 6e e6 b1 00 89
[    2.791013] EIP: [<b100288e>] restore_sigcontext+0x12e/0x370 SS:ESP 0068=
:b0045f80
[    2.791013] CR2: 0000000000000008
[    2.815207] ---[ end trace 7a5fb510918bc4ea ]---
[    2.815952] swapper/0 (1) used greatest stack depth: 5712 bytes left
[    2.816951] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    2.816951]=20
[    2.817913] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
005-1108/9aab69def5d79c04a6dbf6d5646043193e673bc5/vmlinuz-3.12.0-01287-g9aa=
b69d -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_b=
uf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk s=
ysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-qu=
eue/kvm/i386-randconfig-i005-1108/devel-inn-i386-201311081714/.vmlinuz-9aab=
69def5d79c04a6dbf6d5646043193e673bc5-20131108172357-8-lkp-st01 branch=3Dlin=
ux-devel/devel-inn-i386-201311081714 BOOT_IMAGE=3D/kernel/i386-randconfig-i=
005-1108/9aab69def5d79c04a6dbf6d5646043193e673bc5/vmlinuz-3.12.0-01287-g9aa=
b69d'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -n=
et nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboo=
t -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-lkp-st01-1=
2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-lkp-=
st01-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quanta=
l-lkp-st01-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-=
quantal-lkp-st01-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/=
disk4-quantal-lkp-st01-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk5-quantal-lkp-st01-12,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm=
/kboot/pid-quantal-lkp-st01-12 -serial file:/dev/shm/kboot/serial-quantal-l=
kp-st01-12 -daemonize -display none -monitor null=20

--K8nIJk4ghYZn606h
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-9aab69def5d79c04a6dbf6d5646043193e673bc5-i386-randconfig-i005-1108-Oops:-78770.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOWFhYjY5ZC4uLiBNZXJnZSAnb21hcC1hdWRp
by9wZXRlci90aS90aS1saW51eC0zLjEyLnktbzVfZHJhN19tY2FzcCcgaW50byBkZXZlbC1p
bm4taTM4Ni0yMDEzMTEwODE3MTQKSEVBRCBpcyBub3cgYXQgNWUwMWRjNy4uLiBMaW51eCAz
LjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aTAwNS0xMTA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMTA4MTcxNDo1ZTAx
ZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1tbW90bQogU1VD
Q0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4
Y2NiZDZhNWNlYjUyCmdpdCBiaXNlY3Qgc3RhcnQgOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1
NjQ2MDQzMTkzZTY3M2JjNSA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNl
YjUyIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDVlMDFkYzcuLi4gTGludXggMy4x
MgpIRUFEIGlzIG5vdyBhdCA4MDVhNmFmLi4uIExpbnV4IDMuMgpCaXNlY3Rpbmc6IDYyNiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2E4
OWIyYTBmY2MzYzg1N2M1YjhiNmI1NDc5OGFhYmE1ZDFhYWMyOGNdIE1lcmdlIHRhZyAndXNi
LWZvci12My4xMycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2JhbGJpL3VzYiBpbnRvIGNvbm5lY3Rpdml0eS10aS1saW51eC0zLjEyLnkKZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA1
LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwtaW5uLWkzODYtMjAxMzExMDgxNzE0OmE4OWIyYTBm
Y2MzYzg1N2M1YjhiNmI1NDc5OGFhYmE1ZDFhYWMyOGM6YmlzZWN0LW1tb3RtCgoyMDEzLTEx
LTA5LTExOjA4OjM0IGE4OWIyYTBmY2MzYzg1N2M1YjhiNmI1NDc5OGFhYmE1ZDFhYWMyOGMg
Y29tcGlsaW5nCjExMDYgcmVhbCAgMTQzOCB1c2VyICAxMjkgc3lzICAxNDEuNzAlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOAoKMjAxMy0xMS0wOS0xMTozNDo1OSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM2LTAwNjYzLWdhODliMmEwLi4uCTEuLi4uCTIJMwk0
CTUJNi4uCTcuCTkJMTAuLgkxMQkxMi4uCTE1CTE2LgkxOQkyMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDMxMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBz
dGVwcykKWzhmZmI5MjkwOThhNTY5MzlhYzcxNTA5MzAyZWVhYjViMjA3YmYyNjJdIEJsdWV0
b290aDogUmVtb3ZlIHBhcmVudCBzb2NrZXQgdXNhZ2UgZnJvbSBsMmNhcF9jb3JlLmMKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1pMzg2
LTIwMTMxMTA4MTcxNDo4ZmZiOTI5MDk4YTU2OTM5YWM3MTUwOTMwMmVlYWI1YjIwN2JmMjYy
OmJpc2VjdC1tbW90bQoKMjAxMy0xMS0wOS0xMTo1MDowNCA4ZmZiOTI5MDk4YTU2OTM5YWM3
MTUwOTMwMmVlYWI1YjIwN2JmMjYyIGNvbXBpbGluZwo0NzAgcmVhbCAgMTUwNSB1c2VyICAx
MzEgc3lzICAzNDcuNDIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOAoKMjAxMy0x
MS0wOS0xMjowMTo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDgwNzctZzhmZmI5
MjkuCTMJNgkxMAkxMgkxNAkxNy4uLi4uLi4uLi4uLi4uLgkxOC4JMTkJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAxNTggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDcgc3RlcHMpCls5MDU3MGM1NGE1OGFkNDU0M2U5YmE0MThmZjIwNDI0NjU5ZDVmNGUz
XSBwaHk6IGtjb25maWc6IGFkZCBkZXBlbmRzIG9uICJVU0JfU1VQUE9SVCIgdG8gT01BUF9V
U0IyIGFuZCBUV0w0MDMwX1VTQgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaW5uLWkzODYtMjAxMzExMDgxNzE0OjkwNTcwYzU0YTU4YWQ0NTQz
ZTliYTQxOGZmMjA0MjQ2NTlkNWY0ZTM6YmlzZWN0LW1tb3RtCgoyMDEzLTExLTA5LTEyOjE0
OjU2IDkwNTcwYzU0YTU4YWQ0NTQzZTliYTQxOGZmMjA0MjQ2NTlkNWY0ZTMgY29tcGlsaW5n
CjQ5NiByZWFsICAxNTQ4IHVzZXIgIDEyNiBzeXMgIDMzNy40MCUgY3B1IAlpMzg2LXJhbmRj
b25maWctaTAwNS0xMTA4CgoyMDEzLTExLTA5LTEyOjIzOjUzIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTIuMC1yYzctMDA4NjMtZzkwNTcwYzUJMgk3CTEwCTE5Li4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDc5IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNDA3NGFmZTMw
ZTAyMjhkOWRjMjk5ZGYxZDczYTUxMTMzNWJiNGM1Yl0gQVJNOiBPTUFQMis6IGh3bW9kXzd4
eDogQWRkIGRhdGEgc3RydWN0dXJlcyBmb3IgTWNBU1AzCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWkwMDUtMTEwOC9saW51eC1kZXZlbDpkZXZlbC1pbm4taTM4Ni0yMDEzMTEwODE3MTQ6NDA3
NGFmZTMwZTAyMjhkOWRjMjk5ZGYxZDczYTUxMTMzNWJiNGM1YjpiaXNlY3QtbW1vdG0KCjIw
MTMtMTEtMDktMTI6NDM6MzQgNDA3NGFmZTMwZTAyMjhkOWRjMjk5ZGYxZDczYTUxMTMzNWJi
NGM1YiBjb21waWxpbmcKMTY3IHJlYWwgIDI0OSB1c2VyICAyOSBzeXMgIDE2Ni4xMiUgY3B1
IAlpMzg2LXJhbmRjb25maWctaTAwNS0xMTA4CgoyMDEzLTExLTA5LTEyOjQ3OjE1IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTIuMC0wMDg5NC1nNDA3NGFmZQk2CTkJMTEJMTUuLi4uLi4u
Li4uLi4uLi4uLi4uCTE2CTE3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxOC4uLi4uLi4JMTku
Li4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbOWZiZThlNWI5NzI0ZTAwMzQ2MThiZDUx
MmRmOWVkYTQ2OTRlNzdkNV0gTWVyZ2UgYnJhbmNoICdrYnVpbGQva2NvbmZpZycgaW50byBr
YnVpbGQvZm9yLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4L2xpbnV4LWRl
dmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMTA4MTcxNDo5ZmJlOGU1Yjk3MjRlMDAzNDYxOGJk
NTEyZGY5ZWRhNDY5NGU3N2Q1OmJpc2VjdC1tbW90bQoKMjAxMy0xMS0wOS0xMzoxODoyNSA5
ZmJlOGU1Yjk3MjRlMDAzNDYxOGJkNTEyZGY5ZWRhNDY5NGU3N2Q1IGNvbXBpbGluZwoyMDYg
cmVhbCAgMTUyMiB1c2VyICAxMjkgc3lzICA3OTguNDUlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LWkwMDUtMTEwOAoKMjAxMy0xMS0wOS0xMzoyMjoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmMxLTAwMDM5LWc5ZmJlOGU1CTEJNAk5CTE1CTE4Li4uLi4uLi4uLi4uLi4uLi4J
MTkuLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbN2RlZjY4MDEyZjQ3MDQ5NWQxYWFh
ZDliZDUxZmNkODdjNjExMTY0NV0gQmx1ZXRvb3RoOiBhdGgzazogQWRkIHN1cHBvcnQgZm9y
IGEgbmV3IEFSMzAxMiBkZXZpY2UKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4L2xp
bnV4LWRldmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMTA4MTcxNDo3ZGVmNjgwMTJmNDcwNDk1
ZDFhYWFkOWJkNTFmY2Q4N2M2MTExNjQ1OmJpc2VjdC1tbW90bQoKMjAxMy0xMS0wOS0xMzoz
Njo1NCA3ZGVmNjgwMTJmNDcwNDk1ZDFhYWFkOWJkNTFmY2Q4N2M2MTExNjQ1IGNvbXBpbGlu
ZwoyMjUgcmVhbCAgMTUyNSB1c2VyICAxNDEgc3lzICA3MzkuMTYlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLWkwMDUtMTEwOAoKMjAxMy0xMS0wOS0xMzo0MTozMyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjExLjAtMDgwOTgtZzdkZWY2ODAuLi4uLi4uCTEuLi4uLi4uLi4uLgkyLi4uCTMu
Li4JNC4JNi4uLgk3Li4uLi4JOQkxMC4uCTExCTEyCTEzLi4JMTQJMTUJMTYuLi4uLi4JMTcJ
MTguLi4JMTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpb
MzY1NzMxOTk1N2E5ZTE1MDBiZWE0Njk0OTY4Zjk3ZGQ1OTZmN2I1M10gTWVyZ2UgYnJhbmNo
ICdrYnVpbGQva2J1aWxkJyBpbnRvIGtidWlsZC9mb3ItbmV4dApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1pMDA1LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwtaW5uLWkzODYtMjAxMzExMDgxNzE0
OjM2NTczMTk5NTdhOWUxNTAwYmVhNDY5NDk2OGY5N2RkNTk2ZjdiNTM6YmlzZWN0LW1tb3Rt
CgoyMDEzLTExLTA5LTE0OjI0OjA2IDM2NTczMTk5NTdhOWUxNTAwYmVhNDY5NDk2OGY5N2Rk
NTk2ZjdiNTMgY29tcGlsaW5nCjI0NiByZWFsICAxNTE3IHVzZXIgIDEzMSBzeXMgIDY3MC4z
MyUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwNS0xMTA4CgoyMDEzLTExLTA5LTE0OjI4OjQy
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNTAtZzM2NTczMTkuLi4gVEVT
VCBGQUlMVVJFClsgICAgNi4zNzY3MzVdIE5hdFNlbWkgU0N4MjAwIERyaXZlcgpbICAgIDYu
MzgwNTcxXSBjcnlwdG9tZ3JfdGVzdCAoMjMpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6
IDcxMjggYnl0ZXMgbGVmdApbICAgIDYuMzkwMzEyXSBJbml0aWFsaXppbmcgUlQtVGVzdGVy
OiBPSwpbICAgIDYuNTA4MTg0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDYuNTA5MDQyXSBJUDogWzxi
MTAwZDg4ZT5dIG5vbW11X21hcF9wYWdlKzB4NWUvMHhlMApbICAgIDYuNTA5MDQyXSAqcGRl
ID0gMDAwMDAwMDAgClsgICAgNi41MDkwNDJdIE9vcHM6IDAwMDIgWyMxXSBQUkVFTVBUIFNN
UCAKWyAgICA2LjUwOTA0Ml0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNi41MDkwNDJdIENQ
VTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzEtMDAw
NTAtZzM2NTczMTkgIzI5NQpbICAgIDYuNTA5MDQyXSB0YXNrOiBiMDA0ODAwMCB0aTogYjAw
NDQwMDAgdGFzay50aTogYjAwNDQwMDAKWyAgICA2LjUwOTA0Ml0gRUlQOiAwMDYwOls8YjEw
MGQ4OGU+XSBFRkxBR1M6IDAwMDEwMjg2IENQVTogMQpbICAgIDYuNTA5MDQyXSBFSVAgaXMg
YXQgbm9tbXVfbWFwX3BhZ2UrMHg1ZS8weGUwClsgICAgNi41MDkwNDJdIEVBWDogMDAwMDAw
MDAgRUJYOiBiMWNlZmY5MCBFQ1g6IDAwMDAwMDBkIEVEWDogMDAwMDAwMDEKWyAgICA2LjUw
OTA0Ml0gRVNJOiAwMDAwMDAwNiBFREk6IDAwMDAwMGM0IEVCUDogYjAwNDVmOWMgRVNQOiBi
MDA0NWY4MApbICAgIDYuNTA5MDQyXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6
IDAwMDAgU1M6IDAwNjgKWyAgICA2LjUwOTA0Ml0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAw
MDAwIENSMzogMDFlNGQwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDYuNTA5MDQyXSBTdGFjazoK
WyAgICA2LjUwOTA0Ml0gIDAwMDAwMGM0IDAwMDAwMDA2IDAwMDAwMDA2IGIxYzdjNzA2IDAw
MDAwMDAwIGJkYmJiOTQwIGIxYjlkZGEwIGIwMDQ1ZmFjClsgICAgNi41MDkwNDJdICBiMTg0
NDA4OSBiZGJiYjk0MCBiMDA0N2Y4OCBiMDA0NDAwMCBiMTg3MGZmYiBiMTg0NDA3MCAwMDAw
MDAwMCAwMDAwMDAwMApbICAgIDYuNTA5MDQyXSAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwN2IgMDAwMDAwN2IgMDAwMDAwZDggMDAwMDAwMDAKWyAgICA2
LjUwOTA0Ml0gQ2FsbCBUcmFjZToKWyAgICA2LjUwOTA0Ml0gIFs8YjFjN2M3MDY+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJiClsgICAgNi41MDkwNDJdICBbPGIxODQ0MDg5Pl0g
a2VybmVsX2luaXQrMHgxOS8weDI4MApbICAgIDYuNTA5MDQyXSAgWzxiMTg3MGZmYj5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgNi41MDkwNDJdICBbPGIxODQ0
MDcwPl0gPyByZXN0X2luaXQrMHgyODAvMHgyODAKWyAgICA2LjUwOTA0Ml0gQ29kZTogYTIg
ZTUgYjEgMDAgOGIgMDQgZjUgYzAgYTggNDQgYjIgODkgZDMgOGIgNTUgMDggODMgZTAgZmMg
MjkgYzMgYzEgZmIgMDUgYzEgZTMgMGMgMDEgY2IgODUgZDIgNzUgMmMgODMgMDUgNTAgYTIg
ZTUgYjEgMDEgYmEgMjMgMDAgPDAwPiAwMCBiOCA0YyBhOCBhYSBiMSA4MyAxNSA1NCBhMiBl
NSBiMSAwMCBlOCAxZiAxNiAwNSAwMCA4MyAwNQpbICAgIDYuNTA5MDQyXSBFSVA6IFs8YjEw
MGQ4OGU+XSBub21tdV9tYXBfcGFnZSsweDVlLzB4ZTAgU1M6RVNQIDAwNjg6YjAwNDVmODAK
WyAgICA2LjUwOTA0Ml0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgNi41NzIzNjldIC0t
LVsgZW5kIHRyYWNlIDhmZmFmYmZiNjc5MWQxNjIgXS0tLQpbICAgIDYuNTc0MjkyXSBzd2Fw
cGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU3MTIgYnl0ZXMgbGVmdAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvMzY1NzMxOTk1N2E5ZTE1MDBiZWE0
Njk0OTY4Zjk3ZGQ1OTZmN2I1My9kbWVzZy1xdWFudGFsLWpha2V0b3duLTM6MjAxMzExMDkx
NDI5NDg6aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtcmMxLTAwMDUwLWczNjU3
MzE5OjI5NQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFU
IENPVU5UOiAyMCAgIyAvY2Mvd2ZnL21tb3RtLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0
ZXBzKQpbMzdkMWM1ZmMyZGQ4MGRiOGMwODRlNWMzZDMyNGNiOTJkZDZlNWE5NF0gTWVyZ2Ug
YnJhbmNoZXMgJ2tidWlsZC9rYnVpbGQnIGFuZCAna2J1aWxkL21pc2MnIGludG8ga2J1aWxk
L2Zvci1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC9saW51eC1kZXZlbDpk
ZXZlbC1pbm4taTM4Ni0yMDEzMTEwODE3MTQ6MzdkMWM1ZmMyZGQ4MGRiOGMwODRlNWMzZDMy
NGNiOTJkZDZlNWE5NDpiaXNlY3QtbW1vdG0KCjIwMTMtMTEtMDktMTQ6MzA6MTYgMzdkMWM1
ZmMyZGQ4MGRiOGMwODRlNWMzZDMyNGNiOTJkZDZlNWE5NCBjb21waWxpbmcKNjMgcmVhbCAg
MTQ0IHVzZXIgIDIyIHN5cyAgMjYyLjA0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA1LTEx
MDgKCjIwMTMtMTEtMDktMTQ6MzI6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJj
MS0wMDA0NS1nMzdkMWM1Zi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMS4yMzQ1NTFdIE5hdFNl
bWkgU0N4MjAwIERyaXZlcgpbICAgIDEuMjM0Njc4XSBjcnlwdG9tZ3JfdGVzdCAoMjMpIHVz
ZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDY5NDQgYnl0ZXMgbGVmdApbICAgIDEuMjU0MTM4
XSBJbml0aWFsaXppbmcgUlQtVGVzdGVyOiBPSwpbICAgIDEuMzA2NjI4XSBCVUc6IHVuYWJs
ZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxs
KQpbICAgIDEuMzA3MDU2XSBJUDogWzxiMTAwZDg4ZT5dIG5vbW11X21hcF9wYWdlKzB4NWUv
MHhlMApbICAgIDEuMzA3MDU2XSAqcGRlID0gMDAwMDAwMDAgClsgICAgMS4zMDcwNTZdIE9v
cHM6IDAwMDIgWyMxXSBQUkVFTVBUIFNNUCAKWyAgICAxLjMwNzA1Nl0gTW9kdWxlcyBsaW5r
ZWQgaW46ClsgICAgMS4zMDcwNTZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5v
dCB0YWludGVkIDMuMTIuMC1yYzEtMDAwNDUtZzM3ZDFjNWYgIzI5NgpbICAgIDEuMzA3MDU2
XSB0YXNrOiBiMDA0ODAwMCB0aTogYjAwNDQwMDAgdGFzay50aTogYjAwNDQwMDAKWyAgICAx
LjMwNzA1Nl0gRUlQOiAwMDYwOls8YjEwMGQ4OGU+XSBFRkxBR1M6IDAwMDEwMjg2IENQVTog
MApbICAgIDEuMzA3MDU2XSBFSVAgaXMgYXQgbm9tbXVfbWFwX3BhZ2UrMHg1ZS8weGUwClsg
ICAgMS4zMDcwNTZdIEVBWDogMDAwMDAwMDAgRUJYOiBiMWNlZmY5MCBFQ1g6IDAwMDAwMDBk
IEVEWDogMDAwMDAwMDEKWyAgICAxLjMwNzA1Nl0gRVNJOiAwMDAwMDAwNiBFREk6IDAwMDAw
MGM0IEVCUDogYjAwNDVmOWMgRVNQOiBiMDA0NWY4MApbICAgIDEuMzA3MDU2XSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAxLjMwNzA1Nl0g
Q1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDFlNGQwMDAgQ1I0OiAwMDAwMDY5
MApbICAgIDEuMzA3MDU2XSBTdGFjazoKWyAgICAxLjMwNzA1Nl0gIDAwMDAwMGM0IDAwMDAw
MDA2IDAwMDAwMDA2IGIxYzdjNzA2IDAwMDAwMDAwIGJmMTYwOTQwIGIxYjlkZGEwIGIwMDQ1
ZmFjClsgICAgMS4zMDcwNTZdICBiMTg0NDA4OSBiZjE2MDk0MCBiMDA0N2Y4OCBiMDA0NDAw
MCBiMTg3MGZmYiBiMTg0NDA3MCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDEuMzA3MDU2XSAg
MDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwN2IgMDAwMDAwN2Ig
MDAwMDAwZDggMDAwMDAwMDAKWyAgICAxLjMwNzA1Nl0gQ2FsbCBUcmFjZToKWyAgICAxLjMw
NzA1Nl0gIFs8YjFjN2M3MDY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJiClsgICAg
MS4zMDcwNTZdICBbPGIxODQ0MDg5Pl0ga2VybmVsX2luaXQrMHgxOS8weDI4MApbICAgIDEu
MzA3MDU2XSAgWzxiMTg3MGZmYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMw
ClsgICAgMS4zMDcwNTZdICBbPGIxODQ0MDcwPl0gPyByZXN0X2luaXQrMHgyODAvMHgyODAK
WyAgICAxLjMwNzA1Nl0gQ29kZTogYTIgZTUgYjEgMDAgOGIgMDQgZjUgYzAgYTggNDQgYjIg
ODkgZDMgOGIgNTUgMDggODMgZTAgZmMgMjkgYzMgYzEgZmIgMDUgYzEgZTMgMGMgMDEgY2Ig
ODUgZDIgNzUgMmMgODMgMDUgNTAgYTIgZTUgYjEgMDEgYmEgMjMgMDAgPDAwPiAwMCBiOCA0
YyBhOCBhYSBiMSA4MyAxNSA1NCBhMiBlNSBiMSAwMCBlOCAxZiAxNiAwNSAwMCA4MyAwNQpb
ICAgIDEuMzA3MDU2XSBFSVA6IFs8YjEwMGQ4OGU+XSBub21tdV9tYXBfcGFnZSsweDVlLzB4
ZTAgU1M6RVNQIDAwNjg6YjAwNDVmODAKWyAgICAxLjMwNzA1Nl0gQ1IyOiAwMDAwMDAwMDAw
MDAwMDAwClsgICAgMS4zNjU1ODNdIC0tLVsgZW5kIHRyYWNlIGUzOWM0Y2FmNDg2MTE4YmUg
XS0tLQpbICAgIDEuMzY2NjEzXSBzd2FwcGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sg
ZGVwdGg6IDU2OTIgYnl0ZXMgbGVmdAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTEx
MDgvMzdkMWM1ZmMyZGQ4MGRiOGMwODRlNWMzZDMyNGNiOTJkZDZlNWE5NC9kbWVzZy15b2N0
by1sa3AtdHQwMi02OjIwMTMxMTA5MDUyNDU1OmkzODYtcmFuZGNvbmZpZy1pMDA1LTExMDg6
My4xMi4wLXJjMS0wMDA0NS1nMzdkMWM1ZjoyOTYKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9tbW90bS1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzIxY2Y2ZTU4NGNlMzViNzkzNzQ1ODFlNjM0
NGRkN2M3NGY4YjRhMmJdIGtidWlsZCwgYmxvYXQtby1tZXRlcjogZml4IHN0YXRpYyBkZXRl
Y3Rpb24KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4L2xpbnV4LWRldmVsOmRldmVs
LWlubi1pMzg2LTIwMTMxMTA4MTcxNDoyMWNmNmU1ODRjZTM1Yjc5Mzc0NTgxZTYzNDRkZDdj
NzRmOGI0YTJiOmJpc2VjdC1tbW90bQoKMjAxMy0xMS0wOS0xNDozNDo1MSAyMWNmNmU1ODRj
ZTM1Yjc5Mzc0NTgxZTYzNDRkZDdjNzRmOGI0YTJiIGNvbXBpbGluZwozMyByZWFsICAxNDIg
dXNlciAgMjIgc3lzICA0ODYuMzglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOAoK
MjAxMy0xMS0wOS0xNDozNTo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAw
MDA0LWcyMWNmNmU1LiBURVNUIEZBSUxVUkUKWyAgICAyLjg0MzE5Nl0gTmF0U2VtaSBTQ3gy
MDAgRHJpdmVyClsgICAgMi44NDQ1MDZdIGNyeXB0b21ncl90ZXN0ICgyMikgdXNlZCBncmVh
dGVzdCBzdGFjayBkZXB0aDogNjk2NCBieXRlcyBsZWZ0ClsgICAgMi44NDczMzNdIEluaXRp
YWxpemluZyBSVC1UZXN0ZXI6IE9LClsgICAgMi44NzgxMjVdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAg
Mi44NzkwMTVdIElQOiBbPGIxMDBkODhlPl0gbm9tbXVfbWFwX3BhZ2UrMHg1ZS8weGUwClsg
ICAgMi44NzkwMTVdICpwZGUgPSAwMDAwMDAwMCAKWyAgICAyLjg3OTAxNV0gT29wczogMDAw
MiBbIzFdIFBSRUVNUFQgU01QIApbICAgIDIuODc5MDE1XSBNb2R1bGVzIGxpbmtlZCBpbjoK
WyAgICAyLjg3OTAxNV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50
ZWQgMy4xMi4wLXJjMS0wMDAwNC1nMjFjZjZlNSAjMjk3ClsgICAgMi44NzkwMTVdIHRhc2s6
IGIwMDQ4MDAwIHRpOiBiMDA0NDAwMCB0YXNrLnRpOiBiMDA0NDAwMApbICAgIDIuODc5MDE1
XSBFSVA6IDAwNjA6WzxiMTAwZDg4ZT5dIEVGTEFHUzogMDAwMTAyODYgQ1BVOiAwClsgICAg
Mi44NzkwMTVdIEVJUCBpcyBhdCBub21tdV9tYXBfcGFnZSsweDVlLzB4ZTAKWyAgICAyLjg3
OTAxNV0gRUFYOiAwMDAwMDAwMCBFQlg6IGIxY2VmZjkwIEVDWDogMDAwMDAwMGQgRURYOiAw
MDAwMDAwMQpbICAgIDIuODc5MDE1XSBFU0k6IDAwMDAwMDA2IEVESTogMDAwMDAwYzQgRUJQ
OiBiMDA0NWY5YyBFU1A6IGIwMDQ1ZjgwClsgICAgMi44NzkwMTVdICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDIuODc5MDE1XSBDUjA6IDgw
MDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMWU0ZDAwMCBDUjQ6IDAwMDAwNjkwClsgICAg
Mi44NzkwMTVdIFN0YWNrOgpbICAgIDIuODc5MDE1XSAgMDAwMDAwYzQgMDAwMDAwMDYgMDAw
MDAwMDYgYjFjN2M3MDYgMDAwMDAwMDAgYmRiYmI5NDAgYjFiOWRkYTAgYjAwNDVmYWMKWyAg
ICAyLjg3OTAxNV0gIGIxODQ0MDg5IGJkYmJiOTQwIGIwMDQ3Zjg4IGIwMDQ0MDAwIGIxODcw
ZmZiIGIxODQ0MDcwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAgMi44NzkwMTVdICAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDA3YiAwMDAwMDA3YiAwMDAwMDBk
OCAwMDAwMDAwMApbICAgIDIuODc5MDE1XSBDYWxsIFRyYWNlOgpbICAgIDIuODc5MDE1XSAg
WzxiMWM3YzcwNj5dID8gZG9fZWFybHlfcGFyYW0rMHgxMmIvMHgxMmIKWyAgICAyLjg3OTAx
NV0gIFs8YjE4NDQwODk+XSBrZXJuZWxfaW5pdCsweDE5LzB4MjgwClsgICAgMi44NzkwMTVd
ICBbPGIxODcwZmZiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAy
Ljg3OTAxNV0gIFs8YjE4NDQwNzA+XSA/IHJlc3RfaW5pdCsweDI4MC8weDI4MApbICAgIDIu
ODc5MDE1XSBDb2RlOiBhMiBlNSBiMSAwMCA4YiAwNCBmNSBjMCBhOCA0NCBiMiA4OSBkMyA4
YiA1NSAwOCA4MyBlMCBmYyAyOSBjMyBjMSBmYiAwNSBjMSBlMyAwYyAwMSBjYiA4NSBkMiA3
NSAyYyA4MyAwNSA1MCBhMiBlNSBiMSAwMSBiYSAyMyAwMCA8MDA+IDAwIGI4IDRjIGE4IGFh
IGIxIDgzIDE1IDU0IGEyIGU1IGIxIDAwIGU4IDFmIDE2IDA1IDAwIDgzIDA1ClsgICAgMi44
NzkwMTVdIEVJUDogWzxiMTAwZDg4ZT5dIG5vbW11X21hcF9wYWdlKzB4NWUvMHhlMCBTUzpF
U1AgMDA2ODpiMDA0NWY4MApbICAgIDIuODc5MDE1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAK
WyAgICAyLjkwMzAyNV0gLS0tWyBlbmQgdHJhY2UgZjE3MTMyYTQxNWM0YWRhNCBdLS0tClsg
ICAgMi45MDM3MzBdIHN3YXBwZXIvMCAoMSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDog
NTcxMiBieXRlcyBsZWZ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC8yMWNm
NmU1ODRjZTM1Yjc5Mzc0NTgxZTYzNDRkZDdjNzRmOGI0YTJiL2RtZXNnLXF1YW50YWwtc3Rv
YWtsZXktNjoyMDEzMTEwOTE0MzU1NzppMzg2LXJhbmRjb25maWctaTAwNS0xMTA4OjMuMTIu
MC1yYzEtMDAwMDQtZzIxY2Y2ZTU6Mjk3CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbW1vdG0tYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEgc3RlcCkKW2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5YjNkMzA2
ZGQyMTY1NThdIEtidWlsZDogSGFuZGxlIGxvbmdlciBzeW1ib2xzIGluIGthbGxzeW1zLmMK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1p
Mzg2LTIwMTMxMTA4MTcxNDpmMzQ2MmFhOTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2
NTU4OmJpc2VjdC1tbW90bQoKMjAxMy0xMS0wOS0xNDozNjoxNiBmMzQ2MmFhOTUyY2ZjOGY0
YjA5NTEwM2NiOWIzZDMwNmRkMjE2NTU4IGNvbXBpbGluZwozMyByZWFsICAxNDUgdXNlciAg
MjIgc3lzICA0OTkuNzMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOAoKMjAxMy0x
MS0wOS0xNDozNzowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDAzLWdm
MzQ2MmFhLi4uLiBURVNUIEZBSUxVUkUKWyAgICA0LjE2MjQ4Ml0gTmF0U2VtaSBTQ3gyMDAg
RHJpdmVyClsgICAgNC4xNjI1NjRdIGNyeXB0b21ncl90ZXN0ICgyMykgdXNlZCBncmVhdGVz
dCBzdGFjayBkZXB0aDogNzA1NiBieXRlcyBsZWZ0ClsgICAgNC4xNjcxMTJdIEluaXRpYWxp
emluZyBSVC1UZXN0ZXI6IE9LClsgICAgNC4xOTU5NzFdIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAgNC4x
OTYwMTFdIElQOiBbPGIxMDBkODhlPl0gbm9tbXVfbWFwX3BhZ2UrMHg1ZS8weGUwClsgICAg
NC4xOTYwMTFdICpwZGUgPSAwMDAwMDAwMCAKWyAgICA0LjE5NjAxMV0gT29wczogMDAwMiBb
IzFdIFBSRUVNUFQgU01QIApbICAgIDQuMTk2MDExXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICA0LjE5NjAxMV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQg
My4xMi4wLXJjMS0wMDAwMy1nZjM0NjJhYSAjMjk4ClsgICAgNC4xOTYwMTFdIHRhc2s6IGIw
MDQ4MDAwIHRpOiBiMDA0NDAwMCB0YXNrLnRpOiBiMDA0NDAwMApbICAgIDQuMTk2MDExXSBF
SVA6IDAwNjA6WzxiMTAwZDg4ZT5dIEVGTEFHUzogMDAwMTAyODYgQ1BVOiAwClsgICAgNC4x
OTYwMTFdIEVJUCBpcyBhdCBub21tdV9tYXBfcGFnZSsweDVlLzB4ZTAKWyAgICA0LjE5NjAx
MV0gRUFYOiAwMDAwMDAwMCBFQlg6IGIxY2VmZjkwIEVDWDogMDAwMDAwMGQgRURYOiAwMDAw
MDAwMQpbICAgIDQuMTk2MDExXSBFU0k6IDAwMDAwMDA2IEVESTogMDAwMDAwYzQgRUJQOiBi
MDA0NWY5YyBFU1A6IGIwMDQ1ZjgwClsgICAgNC4xOTYwMTFdICBEUzogMDA3YiBFUzogMDA3
YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDQuMTk2MDExXSBDUjA6IDgwMDUw
MDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMWU0ZDAwMCBDUjQ6IDAwMDAwNjkwClsgICAgNC4x
OTYwMTFdIFN0YWNrOgpbICAgIDQuMTk2MDExXSAgMDAwMDAwYzQgMDAwMDAwMDYgMDAwMDAw
MDYgYjFjN2M3MDYgMDAwMDAwMDAgYmRiYmI5NDAgYjFiOWRkYTAgYjAwNDVmYWMKWyAgICA0
LjE5NjAxMV0gIGIxODQ0MDg5IGJkYmJiOTQwIGIwMDQ3Zjg4IGIwMDQ0MDAwIGIxODcwZmZi
IGIxODQ0MDcwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAgNC4xOTYwMTFdICAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDA3YiAwMDAwMDA3YiAwMDAwMDBkOCAw
MDAwMDAwMApbICAgIDQuMTk2MDExXSBDYWxsIFRyYWNlOgpbICAgIDQuMTk2MDExXSAgWzxi
MWM3YzcwNj5dID8gZG9fZWFybHlfcGFyYW0rMHgxMmIvMHgxMmIKWyAgICA0LjE5NjAxMV0g
IFs8YjE4NDQwODk+XSBrZXJuZWxfaW5pdCsweDE5LzB4MjgwClsgICAgNC4xOTYwMTFdICBb
PGIxODcwZmZiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICA0LjE5
NjAxMV0gIFs8YjE4NDQwNzA+XSA/IHJlc3RfaW5pdCsweDI4MC8weDI4MApbICAgIDQuMTk2
MDExXSBDb2RlOiBhMiBlNSBiMSAwMCA4YiAwNCBmNSBjMCBhOCA0NCBiMiA4OSBkMyA4YiA1
NSAwOCA4MyBlMCBmYyAyOSBjMyBjMSBmYiAwNSBjMSBlMyAwYyAwMSBjYiA4NSBkMiA3NSAy
YyA4MyAwNSA1MCBhMiBlNSBiMSAwMSBiYSAyMyAwMCA8MDA+IDAwIGI4IDRjIGE4IGFhIGIx
IDgzIDE1IDU0IGEyIGU1IGIxIDAwIGU4IDFmIDE2IDA1IDAwIDgzIDA1ClsgICAgNC4xOTYw
MTFdIEVJUDogWzxiMTAwZDg4ZT5dIG5vbW11X21hcF9wYWdlKzB4NWUvMHhlMCBTUzpFU1Ag
MDA2ODpiMDA0NWY4MApbICAgIDQuMTk2MDExXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICA0LjIxOTkzM10gLS0tWyBlbmQgdHJhY2UgZmEwZmM0MDJjMTk4OTRmOSBdLS0tClsgICAg
NC4yMjA2MzZdIHN3YXBwZXIvMCAoMSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNTc0
NCBieXRlcyBsZWZ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC9mMzQ2MmFh
OTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2NTU4L2RtZXNnLXF1YW50YWwtc3RvYWts
ZXktNjoyMDEzMTEwOTE0Mzg0ODppMzg2LXJhbmRjb25maWctaTAwNS0xMTA4OjMuMTIuMC1y
YzEtMDAwMDMtZ2YzNDYyYWE6Mjk4CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbW1vdG0tYmlzZWN0Ly5yZXBl
YXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDAgc3RlcHMpCltlZWEwZTljYmI5ZTY1Y2Q1NTNkMzAyYTRhZWZkNGM3Yjcw
ZDlmZDkwXSBrYnVpbGQ6IEluY3JlYXNlIGthbGxzeW1zIG1heCBzeW1ib2wgbGVuZ3RoCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC9saW51eC1kZXZlbDpkZXZlbC1pbm4taTM4
Ni0yMDEzMTEwODE3MTQ6ZWVhMGU5Y2JiOWU2NWNkNTUzZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5
MDpiaXNlY3QtbW1vdG0KCjIwMTMtMTEtMDktMTQ6Mzk6MTAgZWVhMGU5Y2JiOWU2NWNkNTUz
ZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5MCBjb21waWxpbmcKMzYgcmVhbCAgMTQ0IHVzZXIgIDI0
IHN5cyAgNDYzLjg4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgKCjIwMTMtMTEt
MDktMTQ6NDA6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDAwMi1nZWVh
MGU5Yy4gVEVTVCBGQUlMVVJFClsgICAgMS4yNTA5MzFdIE5hdFNlbWkgU0N4MjAwIERyaXZl
cgpbICAgIDEuMjUyNjk5XSBjcnlwdG9tZ3JfdGVzdCAoMjIpIHVzZWQgZ3JlYXRlc3Qgc3Rh
Y2sgZGVwdGg6IDcwMzYgYnl0ZXMgbGVmdApbICAgIDEuMjU2NjE1XSBJbml0aWFsaXppbmcg
UlQtVGVzdGVyOiBPSwpbICAgIDEuMjk3OTI5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDEuMjk4MDM5
XSBJUDogWzxiMTAwZDg4ZT5dIG5vbW11X21hcF9wYWdlKzB4NWUvMHhlMApbICAgIDEuMjk4
MDM5XSAqcGRlID0gMDAwMDAwMDAgClsgICAgMS4yOTgwMzldIE9vcHM6IDAwMDIgWyMxXSBQ
UkVFTVBUIFNNUCAKWyAgICAxLjI5ODAzOV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS4y
OTgwMzldIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIu
MC1yYzEtMDAwMDItZ2VlYTBlOWMgIzI5OQpbICAgIDEuMjk4MDM5XSB0YXNrOiBiMDA0ODAw
MCB0aTogYjAwNDQwMDAgdGFzay50aTogYjAwNDQwMDAKWyAgICAxLjI5ODAzOV0gRUlQOiAw
MDYwOls8YjEwMGQ4OGU+XSBFRkxBR1M6IDAwMDEwMjg2IENQVTogMQpbICAgIDEuMjk4MDM5
XSBFSVAgaXMgYXQgbm9tbXVfbWFwX3BhZ2UrMHg1ZS8weGUwClsgICAgMS4yOTgwMzldIEVB
WDogMDAwMDAwMDAgRUJYOiBiMWNlZmY5MCBFQ1g6IDAwMDAwMDBkIEVEWDogMDAwMDAwMDEK
WyAgICAxLjI5ODAzOV0gRVNJOiAwMDAwMDAwNiBFREk6IDAwMDAwMGM0IEVCUDogYjAwNDVm
OWMgRVNQOiBiMDA0NWY4MApbICAgIDEuMjk4MDM5XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6
IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAxLjI5ODAzOV0gQ1IwOiA4MDA1MDAzYiBD
UjI6IDAwMDAwMDAwIENSMzogMDFlNGQwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDEuMjk4MDM5
XSBTdGFjazoKWyAgICAxLjI5ODAzOV0gIDAwMDAwMGM0IDAwMDAwMDA2IDAwMDAwMDA2IGIx
YzdjNzA2IDAwMDAwMDAwIGJmMTYwOTQwIGIxYjlkZGEwIGIwMDQ1ZmFjClsgICAgMS4yOTgw
MzldICBiMTg0NDA4OSBiZjE2MDk0MCBiMDA0N2Y4OCBiMDA0NDAwMCBiMTg3MGZmYiBiMTg0
NDA3MCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDEuMjk4MDM5XSAgMDAwMDAwMDAgMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwN2IgMDAwMDAwN2IgMDAwMDAwZDggMDAwMDAw
MDAKWyAgICAxLjI5ODAzOV0gQ2FsbCBUcmFjZToKWyAgICAxLjI5ODAzOV0gIFs8YjFjN2M3
MDY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJiClsgICAgMS4yOTgwMzldICBbPGIx
ODQ0MDg5Pl0ga2VybmVsX2luaXQrMHgxOS8weDI4MApbICAgIDEuMjk4MDM5XSAgWzxiMTg3
MGZmYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMS4yOTgwMzld
ICBbPGIxODQ0MDcwPl0gPyByZXN0X2luaXQrMHgyODAvMHgyODAKWyAgICAxLjI5ODAzOV0g
Q29kZTogYTIgZTUgYjEgMDAgOGIgMDQgZjUgYzAgYTggNDQgYjIgODkgZDMgOGIgNTUgMDgg
ODMgZTAgZmMgMjkgYzMgYzEgZmIgMDUgYzEgZTMgMGMgMDEgY2IgODUgZDIgNzUgMmMgODMg
MDUgNTAgYTIgZTUgYjEgMDEgYmEgMjMgMDAgPDAwPiAwMCBiOCA0YyBhOCBhYSBiMSA4MyAx
NSA1NCBhMiBlNSBiMSAwMCBlOCAxZiAxNiAwNSAwMCA4MyAwNQpbICAgIDEuMjk4MDM5XSBF
SVA6IFs8YjEwMGQ4OGU+XSBub21tdV9tYXBfcGFnZSsweDVlLzB4ZTAgU1M6RVNQIDAwNjg6
YjAwNDVmODAKWyAgICAxLjI5ODAzOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS4z
MjM5OTBdIC0tLVsgZW5kIHRyYWNlIGZhODQ1YzY3MGIxNjdlMmMgXS0tLQpbICAgIDEuMzI0
Nzk1XSBzd2FwcGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU3MTYgYnl0
ZXMgbGVmdAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvZWVhMGU5Y2JiOWU2
NWNkNTUzZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5MC9kbWVzZy15b2N0by1iZW5zLTI6MjAxMzEx
MDkxNDQwMjI6aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtcmMxLTAwMDAyLWdl
ZWEwZTljOjI5OQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQ
RUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL21tb3RtLWJpc2VjdC8ucmVwZWF0G1swbQoKZWVh
MGU5Y2JiOWU2NWNkNTUzZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5MCBpcyB0aGUgZmlyc3QgYmFk
IGNvbW1pdApjb21taXQgZWVhMGU5Y2JiOWU2NWNkNTUzZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5
MApBdXRob3I6IEpvZSBNYXJpbyA8am1hcmlvQHJlZGhhdC5jb20+CkRhdGU6ICAgV2VkIE9j
dCAyMyAxNTowNjo1MyAyMDEzICswMjAwCgogICAga2J1aWxkOiBJbmNyZWFzZSBrYWxsc3lt
cyBtYXggc3ltYm9sIGxlbmd0aAogICAgCiAgICBbQUs6IFRoaXMgc2VlbXMgbGlrZSBhIHRp
Y2tpbmcgdGltZSBib21iIGV2ZW4gd2l0aG91dCBMVE8sCiAgICBzbyBzaG91bGQgYmUgbWVy
Z2VkIG5vdy4gSXQgY2F1c2VzIHZlcnkgd2VpcmQgcHJvYmxlbXMuCiAgICBUaGFua3MgdG8g
Sm9lIGZvciB0cmFja2luZyB0aGVtIGRvd24uXQogICAgCiAgICBXaXRoIHRoZSBhZGRlZCBw
b3N0Zml4ZXMgdGhhdCBMVE8gYWRkcyBmb3IgbG9jYWwKICAgIHN5bWJvbHMsIHRoZSBsb25n
ZXN0IG5hbWUgaW4gdGhlIGtlcm5lbCBvdmVyZmxvd3MKICAgIHRoZSBuYW1lYnVmW0tTWU1f
TkFNRV9MRU5dIGFycmF5IGJ5IHR3byBieXRlcy4gIFRoYXQgbmFtZSBpczoKICAgIF9fcGNp
X2ZpeHVwX3Jlc3VtZVBDSV9WRU5ET1JfSURfU0VSVkVSV09SS1NQQ0lfREVWSUNFX0lEX1NF
UlZFUldPUktTX0hUMTAwMFNCcXVpcmtfZGlzYWJsZV9icm9hZGNvbV9ib290X2ludGVycnVw
dC4xNDg4MDA0LjY3MjgwMgogICAgCiAgICBEb3VibGUgdGhlIG1heCBzeW1ib2wgbmFtZSBs
ZW5ndGguCiAgICAKICAgIHYyOiBVc2UgMjU1ICAoSm9lIFBlcmNoZXMpCiAgICBTaWduZWQt
b2ZmLWJ5OiBBbmRpIEtsZWVuIDxha0BsaW51eC5pbnRlbC5jb20+CiAgICBTaWduZWQtb2Zm
LWJ5OiBNaWNoYWwgTWFyZWsgPG1tYXJla0BzdXNlLmN6PgoKOjA0MDAwMCAwNDAwMDAgN2Vi
N2I4ZjA5NjllOGYwMmU2NzllNTEzZmVlZDBiMzFjYWEyNzczYiAyNTZjZWFhOGUzNzQwOTdm
YTFmM2MyYzEyYmQyYzFjYzE3MGUxN2IxIE0JaW5jbHVkZQpiaXNlY3QgcnVuIHN1Y2Nlc3MK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA1
LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwtaW5uLWkzODYtMjAxMzExMDgxNzE0OjgwOTcwNDcy
MTc5YTQ1NjA5YzBiMTFiODA2MTliYzhjMzJiMTVmNzc6YmlzZWN0LW1tb3RtCgoyMDEzLTEx
LTA5LTE0OjQwOjQwIDgwOTcwNDcyMTc5YTQ1NjA5YzBiMTFiODA2MTliYzhjMzJiMTVmNzcg
Y29tcGlsaW5nCgoyMDEzLTExLTA5LTE0OjQxOjQxIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC1yYzEtMDAwMDEtZzgwOTcwNDcuLi4JMS4JMwk0Lgk1CTkJMTAJMTIJMTYJMTcJMjEJ
MjYJMjkJNDMJNTIJNTcuLi4uLi4uLi4uLi4uLi4JNTguLi4uLi4uLi4uLgk1OS4uLi4uCTYw
IFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaTAwNS0xMTA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMTA4MTcx
NDo5YWFiNjlkZWY1ZDc5YzA0YTZkYmY2ZDU2NDYwNDMxOTNlNjczYmM1OmJpc2VjdC1tbW90
bQogVEVTVCBGQUlMVVJFClsgICAgMi43OTE3NDddIGNyeXB0b21ncl90ZXN0ICgyMykgdXNl
ZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNzIwMCBieXRlcyBsZWZ0ClsgICAgMi43OTMxNzhd
IE5hdFNlbWkgU0N4MjAwIERyaXZlcgpbICAgIDIuODI3NzE4XSBJbml0aWFsaXppbmcgUlQt
VGVzdGVyOiBPSwpbICAgIDIuODczMTU1XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVs
IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwOApbICAgIDIuODc0MDI2XSBJ
UDogWzxiMTAwMjg4ZT5dIHJlc3RvcmVfc2lnY29udGV4dCsweDEyZS8weDM3MApbICAgIDIu
ODc0MDI2XSAqcGRlID0gMDAwMDAwMDAgClsgICAgMi44NzQwMjZdIE9vcHM6IDAwMDIgWyMx
XSBQUkVFTVBUIFNNUCAKWyAgICAyLjg3NDAyNl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
Mi44NzQwMjZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMu
MTIuMC0wMTI4Ny1nOWFhYjY5ZCAjMTE3NgpbICAgIDIuODc0MDI2XSB0YXNrOiBiMDA0ODAw
MCB0aTogYjAwNDQwMDAgdGFzay50aTogYjAwNDQwMDAKWyAgICAyLjg3NDAyNl0gRUlQOiAw
MDYwOls8YjEwMDI4OGU+XSBFRkxBR1M6IDAwMDEwMjg2IENQVTogMApbICAgIDIuODc0MDI2
XSBFSVAgaXMgYXQgcmVzdG9yZV9zaWdjb250ZXh0KzB4MTJlLzB4MzcwClsgICAgMi44NzQw
MjZdIEVBWDogMDAwMDAwMDAgRUJYOiBiMWQwNGY5MCBFQ1g6IDAwMDAwMDBkIEVEWDogMDAw
MDAwMDEKWyAgICAyLjg3NDAyNl0gRVNJOiAwMDAwMDAwNiBFREk6IDAwMDAwMGM0IEVCUDog
YjAwNDVmOWMgRVNQOiBiMDA0NWY4MApbICAgIDIuODc0MDI2XSAgRFM6IDAwN2IgRVM6IDAw
N2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAyLjg3NDAyNl0gQ1IwOiA4MDA1
MDAzYiBDUjI6IDAwMDAwMDA4IENSMzogMDFlNjIwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDIu
ODc0MDI2XSBTdGFjazoKWyAgICAyLjg3NDAyNl0gIDAwMDAwMGM0IDAwMDAwMDA2IDAwMDAw
MDA2IGIxYzkxNzA2IDAwMDAwMDAwIGJkYmJiOTQwIGIxYmIxZTIwIGIwMDQ1ZmFjClsgICAg
Mi44NzQwMjZdICBiMTg0OTFiOSBiZGJiYjk0MCBiMDA0N2Y4OCBiMDA0NDAwMCBiMTg3NmZi
YiBiMTg0OTFhMCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDIuODc0MDI2XSAgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwN2IgMDAwMDAwN2IgMDAwMDAwZDgg
MDAwMDAwMDAKWyAgICAyLjg3NDAyNl0gQ2FsbCBUcmFjZToKWyAgICAyLjg3NDAyNl0gIFs8
YjFjOTE3MDY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJiClsgICAgMi44NzQwMjZd
ICBbPGIxODQ5MWI5Pl0ga2VybmVsX2luaXQrMHgxOS8weDI4MApbICAgIDIuODc0MDI2XSAg
WzxiMTg3NmZiYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMi44
NzQwMjZdICBbPGIxODQ5MWEwPl0gPyByZXN0X2luaXQrMHgyODAvMHgyODAKWyAgICAyLjg3
NDAyNl0gQ29kZTogNmUgZTYgYjEgMDAgODkgNTggM2MgOGIgNWEgMjAgODMgMDUgNjAgNmUg
ZTYgYjEgMDEgODMgMTUgNjQgNmUgZTYgYjEgMDAgODkgMTggOGIgNWEgMjQgODMgMDUgNjgg
NmUgZTYgYjEgMDEgODMgMTUgNmMgNmUgZTYgYjEgMDAgPDg5PiA1OCAwOCA4YiA1YSAyOCA4
MyAwNSA3MCA2ZSBlNiBiMSAwMSA4MyAxNSA3NCA2ZSBlNiBiMSAwMCA4OQpbICAgIDIuODc0
MDI2XSBFSVA6IFs8YjEwMDI4OGU+XSByZXN0b3JlX3NpZ2NvbnRleHQrMHgxMmUvMHgzNzAg
U1M6RVNQIDAwNjg6YjAwNDVmODAKWyAgICAyLjg3NDAyNl0gQ1IyOiAwMDAwMDAwMDAwMDAw
MDA4ClsgICAgMi44OTQ1NjhdIC0tLVsgZW5kIHRyYWNlIDhhNDBmYjk2OWI4NmI0Y2QgXS0t
LQpbICAgIDIuODk1MjQ4XSBzd2FwcGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVw
dGg6IDU3NDQgYnl0ZXMgbGVmdAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgv
OWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1NjQ2MDQzMTkzZTY3M2JjNS9kbWVzZy1xdWFudGFs
LWxrcC1zdDAxLTEyOjIwMTMxMTA5MDEyNDU3OmkzODYtcmFuZGNvbmZpZy1pMDA1LTExMDg6
My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
NS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZkNTY0NjA0MzE5M2U2NzNiYzUvZG1lc2ct
cXVhbnRhbC1yb2FtLTM5OjIwMTMxMTA5MTEwNzQ5OmkzODYtcmFuZGNvbmZpZy1pMDA1LTEx
MDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZkNTY0NjA0MzE5M2U2NzNiYzUvZG1l
c2ctcXVhbnRhbC1yb2FtLTI2OjIwMTMxMTA5MTEwNjE0OmkzODYtcmFuZGNvbmZpZy1pMDA1
LTExMDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZkNTY0NjA0MzE5M2U2NzNiYzUv
ZG1lc2cteW9jdG8tc25iLTQ4OjIwMTMxMTA4MTcyNzI5OmkzODYtcmFuZGNvbmZpZy1pMDA1
LTExMDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZkNTY0NjA0MzE5M2U2NzNiYzUv
ZG1lc2ctcXVhbnRhbC14cHMtNzoyMDEzMTEwOTE5MDYyMzppMzg2LXJhbmRjb25maWctaTAw
NS0xMTA4OjMuMTIuMC0wMTI4Ny1nOWFhYjY5ZDoxMTc2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDUtMTEwOC85YWFiNjlkZWY1ZDc5YzA0YTZkYmY2ZDU2NDYwNDMxOTNlNjczYmM1
L2RtZXNnLXlvY3RvLWlubi0yODoyMDEzMTEwODE3MjkzMzppMzg2LXJhbmRjb25maWctaTAw
NS0xMTA4OjMuMTIuMC0wMTI4Ny1nOWFhYjY5ZDoxMTc2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDUtMTEwOC85YWFiNjlkZWY1ZDc5YzA0YTZkYmY2ZDU2NDYwNDMxOTNlNjczYmM1
L2RtZXNnLXF1YW50YWwteHBzLTc6MjAxMzExMDkxOTA0NTQ6aTM4Ni1yYW5kY29uZmlnLWkw
MDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3Ngova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1NjQ2MDQzMTkzZTY3M2Jj
NS9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTU6MjAxMzExMDkxOTAzMDk6aTM4Ni1yYW5kY29u
ZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3Ngova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1NjQ2MDQzMTkz
ZTY3M2JjNS9kbWVzZy1xdWFudGFsLXJvYW0tNDg6MjAxMzExMDkxMTA2NTM6aTM4Ni1yYW5k
Y29uZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3Ngova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1NjQ2MDQz
MTkzZTY3M2JjNS9kbWVzZy15b2N0by1pbm4tMjoyMDEzMTEwODE3MjYwODppMzg2LXJhbmRj
b25maWctaTAwNS0xMTA4OjMuMTIuMC0wMTI4Ny1nOWFhYjY5ZDoxMTc2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC85YWFiNjlkZWY1ZDc5YzA0YTZkYmY2ZDU2NDYwNDMx
OTNlNjczYmM1L2RtZXNnLXlvY3RvLWxrcC10dDAyLTIwOjIwMTMxMTA5MDE1NjM0OmkzODYt
cmFuZGNvbmZpZy1pMDA1LTExMDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZkNTY0
NjA0MzE5M2U2NzNiYzUvZG1lc2cteW9jdG8td2FpbWVhLTQ6MjAxMzExMDkwMTIyMDc6aTM4
Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3Ngova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJmNmQ1
NjQ2MDQzMTkzZTY3M2JjNS9kbWVzZy1xdWFudGFsLXNuYi04OjIwMTMxMTA4MTcyNjE3Omkz
ODYtcmFuZGNvbmZpZy1pMDA1LTExMDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjExNzYKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRhNmRiZjZk
NTY0NjA0MzE5M2U2NzNiYzUvZG1lc2ctcXVhbnRhbC1pbm4tMjk6MjAxMzExMDgxNzI5MzY6
aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3Ngov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2ZGJm
NmQ1NjQ2MDQzMTkzZTY3M2JjNS9kbWVzZy1xdWFudGFsLXhpYW4tMjU6MjAxMzExMDkxMTA4
MDg6aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2OWQ6MTE3
Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3OWMwNGE2
ZGJmNmQ1NjQ2MDQzMTkzZTY3M2JjNS9kbWVzZy15b2N0by1yb2FtLTIwOjIwMTMxMTA5MTEw
NjM0OmkzODYtcmFuZGNvbmZpZy1pMDA1LTExMDg6My4xMi4wLTAxMjg3LWc5YWFiNjlkOjEx
NzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwNS0xMTA4LzlhYWI2OWRlZjVkNzljMDRh
NmRiZjZkNTY0NjA0MzE5M2U2NzNiYzUvZG1lc2cteW9jdG8tbGtwLXR0MDItMjQ6MjAxMzEx
MDkwMTU4MzM6aTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwODozLjEyLjAtMDEyODctZzlhYWI2
OWQ6MTE3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvOWFhYjY5ZGVmNWQ3
OWMwNGE2ZGJmNmQ1NjQ2MDQzMTkzZTY3M2JjNS9kbWVzZy1xdWFudGFsLXNuYi0yOToyMDEz
MTEwODE3MjYzMjppMzg2LXJhbmRjb25maWctaTAwNS0xMTA4OjMuMTIuMC0wMTI4Ny1nOWFh
YjY5ZDoxMTc2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC85YWFiNjlkZWY1
ZDc5YzA0YTZkYmY2ZDU2NDYwNDMxOTNlNjczYmM1L2RtZXNnLXlvY3RvLXhnd28tMjoyMDEz
MTEwOTAxMjYzMDppMzg2LXJhbmRjb25maWctaTAwNS0xMTA4OjMuMTIuMC0wMTI4Ny1nOWFh
YjY5ZDoxMTc2CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hl
ZCBIRUFEIDkzODg0OTZdIFJldmVydCAia2J1aWxkOiBJbmNyZWFzZSBrYWxsc3ltcyBtYXgg
c3ltYm9sIGxlbmd0aCIKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWkwMDUtMTEwOC9saW51eC1kZXZlbDpkZXZlbC1pbm4taTM4Ni0yMDEzMTEwODE3MTQ6
OTM4ODQ5NmYzMTQ5MDFhYzhjYTE1NWU4NTU4ZDVkYzVkYmUzOWQwZDpiaXNlY3QtbW1vdG0K
CjIwMTMtMTEtMDktMTU6MDg6NDggOTM4ODQ5NmYzMTQ5MDFhYzhjYTE1NWU4NTU4ZDVkYzVk
YmUzOWQwZCBjb21waWxpbmcKCjIwMTMtMTEtMDktMTU6MTU6MjAgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMi4wLTAxMjg4LWc5Mzg4NDk2Li4JMS4uLgkyLgkzCTQJNQk3CTguLi4uCTkJ
MTAJMTEJMTIJMTMJMTUJMTcuCTE4CTIyCTIzCTI1CTMxCTM0CTQ1CTUwCTU0CTU4CTYwIFNV
Q0NFU1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwNS0x
MTA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMTA4MTcxNDo2Yzg2YWUyOTI4
ZjllNGNiZjBkNTg0NGY1ZmNmZDU0OWUzNDUwYjhjOmJpc2VjdC1tbW90bQoKMjAxMy0xMS0w
OS0xNTozMzozOSA2Yzg2YWUyOTI4ZjllNGNiZjBkNTg0NGY1ZmNmZDU0OWUzNDUwYjhjIHJl
dXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC82Yzg2YWUyOTI4ZjllNGNi
ZjBkNTg0NGY1ZmNmZDU0OWUzNDUwYjhjL3ZtbGludXotMy4xMi4wLTAxOTE1LWc2Yzg2YWUy
CgoyMDEzLTExLTA5LTE1OjMzOjM5IGRldGVjdGluZyBib290IHN0YXRlIAkxMAkxMwkxNgky
MAkyMwkyNQkyNwkyOQkzMwkzNwk0NAk0OAk1Mwk1NQk2MCBTVUNDRVNTCgoKPT09PT09PT09
IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA1LTExMDgvbGludXgtZGV2ZWw6
ZGV2ZWwtaW5uLWkzODYtMjAxMzExMDgxNzE0OmJhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEy
MDcyZjZmOGNlNjRjMjc6YmlzZWN0LW1tb3RtCgoyMDEzLTExLTA5LTE1OjQxOjE3IGJhZDU3
MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcgY29tcGlsaW5nCjIwMTMtMTEt
MDktMTU6NDQ6NDIgYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNyBT
S0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tb3RtLWJpc2VjdCBh
bmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDUtMTEwOC9iYWQ1NzBkNzcwMjRj
YmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3Cg==

--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-01287-g9aab69d"

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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
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
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
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
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
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
CONFIG_M586=y
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
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

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
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_PCCARD is not set
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
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=m
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=y
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_TCPPROBE=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
# CONFIG_YAM is not set
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=m
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
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
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_SCx200_DOCFLASH=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
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

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
# CONFIG_CROSSBAR is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
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
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_TPS6507X=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
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
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
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
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_ADP5588=m

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
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

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
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

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
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=m

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
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_ARIZONA=m
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_ADV7183=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=m
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
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
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
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
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=m
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
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
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
CONFIG_SND_SOC=m
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_FSL_SPDIF=m
CONFIG_SND_IMX_SOC=m
CONFIG_SND_SOC_IMX_PCM_DMA=m
CONFIG_SND_SOC_IMX_SPDIF=m
CONFIG_SND_KIRKWOOD_SOC=m
# CONFIG_SND_KIRKWOOD_SOC_OPENRD is not set
# CONFIG_SND_KIRKWOOD_SOC_T5325 is not set
CONFIG_SND_SOC_TEGRA=m
# CONFIG_SND_SOC_TEGRA_RT5640 is not set
# CONFIG_SND_SOC_TEGRA_WM8753 is not set
CONFIG_SND_SOC_TEGRA_WM8903=m
CONFIG_SND_SOC_TEGRA_TRIMSLICE=m
# CONFIG_SND_SOC_TEGRA_ALC5632 is not set
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SIMPLE_CARD=m
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_OSS is not set

#
# HID support
#
# CONFIG_HID is not set

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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_OMAP_HS is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_SSV_DNP=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_COMEDI_FC=m
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_DX_SEP is not set
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_DGRP is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_SONY_LAPTOP is not set
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
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=m
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_EXTCON_GPIO_USBVID is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_TI is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_OMAP_CONTROL_PHY is not set
# CONFIG_OMAP_PIPE3 is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=m
# CONFIG_9P_FSCACHE is not set
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
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
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
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
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
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
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
CONFIG_X509_CERTIFICATE_PARSER=m
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=m

--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--K8nIJk4ghYZn606h--
