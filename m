Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaCGCKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:10:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:22320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaCGCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633445"
Date: Fri, 7 Mar 2014 09:38:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86, vdso]  BUG: unable to handle kernel paging request at d34bd000
Message-ID: <20140307013833.GD8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x4pBfXISqBoDm8sr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stefani,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
commit 4dea8e4824b363c53f320d328040d7c6c5921419
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon Mar 3 22:12:20 2014 +0100
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed Mar 5 14:02:38 2014 -0800

    x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
    
    This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
    
    For 32 bit programs running on a 32 bit kernel, the same mechanism is
    used as for 64 bit programs running on a 64 bit kernel.
    
    Reviewed-by: Andy Lutomirski <luto@amacapital.net>
    Signed-off-by: Stefani Seibold <stefani@seibold.net>
    Link: http://lkml.kernel.org/r/1393881143-3569-10-git-send-email-stefani@seibold.net
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

+--------------------------------------------+------------+
|                                            | 4dea8e4824 |
+--------------------------------------------+------------+
| boot_successes                             | 0          |
| boot_failures                              | 19         |
| BUG:unable_to_handle_kernel_paging_request | 19         |
| Oops:PREEMPT_SMP_DEBUG_PAGEALLOC           | 19         |
| EIP_is_at_sysenter_setup                   | 19         |
| Kernel_panic-not_syncing:Fatal_exception   | 19         |
+--------------------------------------------+------------+

[    0.004009] pid_max: default: 4096 minimum: 301
[    0.009099] Mount-cache hash table entries: 512
[    0.014838] mce: CPU supports 10 MCE banks
[    0.015243] BUG: unable to handle kernel paging request at d34bd000
[    0.016000] IP: [<c182dbca>] sysenter_setup+0x9a/0x2d4
[    0.016000] *pdpt = 00000000018a4001 *pde = 0000000013bea067 *pte = 80000000134bd060 
[    0.016000] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.016000] Modules linked in:
[    0.016000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-gd478a96 #2
[    0.016000] task: c17997c0 ti: c178e000 task.ti: c178e000
[    0.016000] EIP: 0060:[<c182dbca>] EFLAGS: 00210212 CPU: 0
[    0.016000] EIP is at sysenter_setup+0x9a/0x2d4
[    0.016000] EAX: 078bfbfd EBX: d34bc000 ECX: 00000004 EDX: 00001004
[    0.016000] ESI: c186740c EDI: d34bd000 EBP: c178ff98 ESP: c178ff74
[    0.016000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.016000] CR0: 8005003b CR2: d34bd000 CR3: 018a7000 CR4: 000006f0
[    0.016000] Stack:
[    0.016000]  00200202 c1dbb0f0 00000f61 00000800 80002001 078bfbfd 00000000 00000000
[    0.016000]  c18a8800 c178ffa0 c1821144 c178ffbc c182117d 00000000 c178ffbc 00000000
[    0.016000]  00000000 c18a8800 c178ffec c181ab11 00000101 ffffffff ffffffff c181a549
[    0.016000] Call Trace:
[    0.016000]  [<c1821144>] identify_boot_cpu+0x17/0x28
[    0.016000]  [<c182117d>] check_bugs+0xe/0x160
[    0.016000]  [<c181ab11>] start_kernel+0x401/0x470
[    0.016000]  [<c181a549>] ? repair_env_string+0x51/0x51
[    0.016000]  [<c181a364>] i386_start_kernel+0x12e/0x131
[    0.016000] Code: f6 c4 08 74 12 ba 10 74 86 c1 81 ea 0c 64 86 c1 be 0c 64 86 c1 eb 10 ba 0c 64 86 c1 81 ea 1c 54 86 c1 be 1c 54 86 c1 89 df 89 d1 <f3> a4 89 d8 e8 8b fe ff ff b9 04 00 00 00 ba d6 c2 6e c1 89 d8
[    0.016000] EIP: [<c182dbca>] sysenter_setup+0x9a/0x2d4 SS:ESP 0068:c178ff74
[    0.016000] CR2: 00000000d34bd000
[    0.016000] ---[ end trace db4b7fde7786bb07 ]---
[    0.016000] Kernel panic - not syncing: Fatal exception

git bisect start d478a960edf1ea61ca31a07a48a8771f043dba78 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect  bad 6c2191ad9b6225860eef70a77d300c3d5ad39182  # 05:55      0-     15  Merge 'digsig/for-mimi' into devel-hourly-2014030618
git bisect good 61ca01b5aa63605e033f1826dcceb41421aa72cd  # 06:03     20+      0  Merge 'ubifs/master' into devel-hourly-2014030618
git bisect  bad 53dca0b5f0e257f00b91fc3be98fb47c07d20cfc  # 06:11      0-     16  Merge 'tip/x86/vdso' into devel-hourly-2014030618
git bisect good f25ed0ebc194a51042a5392ca821de2ff6661275  # 06:20     20+      0  Merge 'slave-dma/next' into devel-hourly-2014030618
git bisect good e0099b8165e2525541d7844e29e8838824b3601e  # 06:23     20+      0  Merge 'pcmoore-selinux/next' into devel-hourly-2014030618
git bisect good c24bf54683dd0098e878a0cf40e2667e46a39a0a  # 06:29     20+      0  Merge 'renesas/next' into devel-hourly-2014030618
git bisect good 6543ca6fee7d3b314bda69b83fd429ed3e336645  # 06:35     20+      0  x86, vdso: Cleanup __vdso_gettimeofday()
git bisect  bad 4dea8e4824b363c53f320d328040d7c6c5921419  # 06:37      0-     15  x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 06:41     20+      0  x86, vdso: Patch alternatives in the 32-bit VDSO
# first bad commit: [4dea8e4824b363c53f320d328040d7c6c5921419] x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 06:43     60+      0  x86, vdso: Patch alternatives in the 32-bit VDSO
git bisect  bad d478a960edf1ea61ca31a07a48a8771f043dba78  # 06:43      0-     19  0day head guard for 'devel-hourly-2014030618'
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 06:56     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 06:59     60+     69  Add linux-next specific files for 20140306

Thanks,
Fengguang

--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xgwo-7:20140307033447:i386-randconfig-nh0-03070222:3.14.0-rc5-03765-gd478a96:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@nhm4) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Fri Mar 7 03:16:44 CST 2014
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x01e02000, 0x01e02fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x01e03000, 0x01e03fff] PGTABLE
[    0.000000] BRK [0x01e04000, 0x01e04fff] PGTABLE
[    0.000000] BRK [0x01e05000, 0x01e05fff] PGTABLE
[    0.000000] BRK [0x01e06000, 0x01e06fff] PGTABLE
[    0.000000] BRK [0x01e07000, 0x01e07fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
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
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c17e5120, node_mem_map d3=
8a8024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
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
[    0.000000] PERCPU: Embedded 17 pages/cpu @d3c9b000 s48368 r0 d21264 u69=
632
[    0.000000] pcpu-alloc: s48368 r0 d21264 u69632 alloc=3D17*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13c9d980
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-nh0-03070222/linux-devel:devel-hourly-2014030618/.vmlinu=
z-d478a960edf1ea61ca31a07a48a8771f043dba78-20140307033412-4-xgwo branch=3Dl=
inux-devel/devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-nh0=
-03070222/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765=
-gd478a96
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 305576K/327280K available (5504K kernel code, 558K r=
wdata, 2224K rodata, 536K init, 5424K bss, 21704K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffd32000   ( 693 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc181a000 - 0xc18a0000   ( 536 kB)
[    0.000000]       .data : 0xc15603c2 - 0xc18189a0   (2785 kB)
[    0.000000]       .text : 0xc1000000 - 0xc15603c2   (5504 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd341c000 soft=3Dd341e000
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.696 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5333.39 Bogo=
MIPS (lpj=3D2666696)
[    0.004009] pid_max: default: 4096 minimum: 301
[    0.009099] Mount-cache hash table entries: 512
[    0.014838] mce: CPU supports 10 MCE banks
[    0.015243] BUG: unable to handle kernel paging request at d34bd000
[    0.016000] IP: [<c182dbca>] sysenter_setup+0x9a/0x2d4
[    0.016000] *pdpt =3D 00000000018a4001 *pde =3D 0000000013bea067 *pte =
=3D 80000000134bd060=20
[    0.016000] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.016000] Modules linked in:
[    0.016000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-g=
d478a96 #2
[    0.016000] task: c17997c0 ti: c178e000 task.ti: c178e000
[    0.016000] EIP: 0060:[<c182dbca>] EFLAGS: 00210212 CPU: 0
[    0.016000] EIP is at sysenter_setup+0x9a/0x2d4
[    0.016000] EAX: 078bfbfd EBX: d34bc000 ECX: 00000004 EDX: 00001004
[    0.016000] ESI: c186740c EDI: d34bd000 EBP: c178ff98 ESP: c178ff74
[    0.016000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.016000] CR0: 8005003b CR2: d34bd000 CR3: 018a7000 CR4: 000006f0
[    0.016000] Stack:
[    0.016000]  00200202 c1dbb0f0 00000f61 00000800 80002001 078bfbfd 00000=
000 00000000
[    0.016000]  c18a8800 c178ffa0 c1821144 c178ffbc c182117d 00000000 c178f=
fbc 00000000
[    0.016000]  00000000 c18a8800 c178ffec c181ab11 00000101 ffffffff fffff=
fff c181a549
[    0.016000] Call Trace:
[    0.016000]  [<c1821144>] identify_boot_cpu+0x17/0x28
[    0.016000]  [<c182117d>] check_bugs+0xe/0x160
[    0.016000]  [<c181ab11>] start_kernel+0x401/0x470
[    0.016000]  [<c181a549>] ? repair_env_string+0x51/0x51
[    0.016000]  [<c181a364>] i386_start_kernel+0x12e/0x131
[    0.016000] Code: f6 c4 08 74 12 ba 10 74 86 c1 81 ea 0c 64 86 c1 be 0c =
64 86 c1 eb 10 ba 0c 64 86 c1 81 ea 1c 54 86 c1 be 1c 54 86 c1 89 df 89 d1 =
<f3> a4 89 d8 e8 8b fe ff ff b9 04 00 00 00 ba d6 c2 6e c1 89 d8
[    0.016000] EIP: [<c182dbca>] sysenter_setup+0x9a/0x2d4 SS:ESP 0068:c178=
ff74
[    0.016000] CR2: 00000000d34bd000
[    0.016000] ---[ end trace db4b7fde7786bb07 ]---
[    0.016000] Kernel panic - not syncing: Fatal exception
[    0.016000] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-n=
h0-03070222/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-037=
65-gd478a96 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-nh0-03070222/linux-devel:devel-hourly-2014030618/.vmlinuz-d478a960edf1e=
a61ca31a07a48a8771f043dba78-20140307033412-4-xgwo branch=3Dlinux-devel/deve=
l-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-nh0-03070222/d478a=
960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-gd478a96'  -in=
itrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vla=
n=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::11513-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/=
LABEL=3DKVM/disk1-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/L=
ABEL=3DKVM/disk2-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk3-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LAB=
EL=3DKVM/disk4-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABE=
L=3DKVM/disk5-yocto-xgwo-7,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-yocto-xgwo-7 -serial file:/dev/shm/kboot/serial-yocto-xgwo-7 -daemoniz=
e -display none -monitor null=20

--x4pBfXISqBoDm8sr
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-nh0-03070222-d478a960edf1ea61ca31a07a48a8771f043dba78-EIP-is-at-sysenter_setup+-x-16618.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMwNzAyMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg0CgoyMDE0LTAz
LTA3LTA1OjQ4OjM2IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjExMCByZWFsICAyMDEwIHVzZXIgIDE3OSBzeXMgIDE5ODMuOTglIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMgoKMjAxNC0wMy0wNy0wNTo1MDo1MyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LgkxCTgJMjAgU1VDQ0VTUwoKYmlzZWN0OiBn
b29kIGNvbW1pdCAwNDE0ODU1ZmRjNGE0MGRhMDUyMjFmYzYwNjJjY2NiYzBjMzBmMTY5Cmdp
dCBiaXNlY3Qgc3RhcnQgZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3
OCAwNDE0ODU1ZmRjNGE0MGRhMDUyMjFmYzYwNjJjY2NiYzBjMzBmMTY5IC0tCi9jL2tlcm5l
bC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImQ0NzhhOTYwZWRmMWVhNjFjYTMxYTA3
YTQ4YTg3NzFmMDQzZGJhNzgiLCAiLWciLCAiMDQxNDg1NWZkYzRhNDBkYTA1MjIxZmM2MDYy
Y2NjYmMwYzMwZjE2OSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6
IDM3NjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0
ZXBzKQpbNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Ml0gTWVyZ2Ug
J2RpZ3NpZy9mb3ItbWltaScgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDAzMDYxODo2YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgy
OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDU6NTI6NTQgNmMyMTkxYWQ5YjYyMjU4NjBl
ZWY3MGE3N2QzMDBjM2Q1YWQzOTE4MiBjb21waWxpbmcKMTEyIHJlYWwgIDE5ODQgdXNlciAg
MTcxIHN5cyAgMTkyNC4zMyUgY3B1IAlpMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyCgoy
MDE0LTAzLTA3LTA1OjU1OjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDE0
MDAtZzZjMjE5MWEuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAzNDMzXSBwaWRfbWF4OiBkZWZh
dWx0OiA0MDk2IG1pbmltdW06IDMwMQpbICAgIDAuMDA1NDA0XSBNb3VudC1jYWNoZSBoYXNo
IHRhYmxlIGVudHJpZXM6IDUxMgpbICAgIDAuMDA3NzU3XSBtY2U6IENQVSBzdXBwb3J0cyAx
MCBNQ0UgYmFua3MKWyAgICAwLjAwODA5NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBwYWdpbmcgcmVxdWVzdCBhdCBkMWNiZDAwMApbICAgIDAuMDA5MDAwXSBJUDogWzxjMTgx
ZmMzNz5dIHN5c2VudGVyX3NldHVwKzB4OWEvMHgyZDQKWyAgICAwLjAwOTAwMF0gKnBkcHQg
PSAwMDAwMDAwMDAxODk1MDAxICpwZGUgPSAwMDAwMDAwMDEyNWY2MDY3ICpwdGUgPSA4MDAw
MDAwMDExY2JkMDYwIApbICAgIDAuMDA5MDAwXSBPb3BzOiAwMDAyIFsjMV0gUFJFRU1QVCBT
TVAgREVCVUdfUEFHRUFMTE9DClsgICAgMC4wMDkwMDBdIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAgIDAuMDA5MDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhICM0MgpbICAgIDAuMDA5MDAwXSB0YXNrOiBj
MTc4YjdjMCB0aTogYzE3ODAwMDAgdGFzay50aTogYzE3ODAwMDAKWyAgICAwLjAwOTAwMF0g
RUlQOiAwMDYwOls8YzE4MWZjMzc+XSBFRkxBR1M6IDAwMjEwMjEyIENQVTogMApbICAgIDAu
MDA5MDAwXSBFSVAgaXMgYXQgc3lzZW50ZXJfc2V0dXArMHg5YS8weDJkNApbICAgIDAuMDA5
MDAwXSBFQVg6IDA3OGJmYmZkIEVCWDogZDFjYmMwMDAgRUNYOiAwMDAwMDAwNCBFRFg6IDAw
MDAxMDA0ClsgICAgMC4wMDkwMDBdIEVTSTogYzE4NTk0MGMgRURJOiBkMWNiZDAwMCBFQlA6
IGMxNzgxZjk4IEVTUDogYzE3ODFmNzQKWyAgICAwLjAwOTAwMF0gIERTOiAwMDdiIEVTOiAw
MDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC4wMDkwMDBdIENSMDogODAw
NTAwM2IgQ1IyOiBkMWNiZDAwMCBDUjM6IDAxODk4MDAwIENSNDogMDAwMDA2ZjAKWyAgICAw
LjAwOTAwMF0gU3RhY2s6ClsgICAgMC4wMDkwMDBdICAwMDIwMDIwMiBjMWRhYzBkMCAwMDAw
MGY2MSAwMDAwMDgwMCA4MDAwMjAwMSAwNzhiZmJmZCAwMDAwMDAwMCAwMDAwMDAwMApbICAg
IDAuMDA5MDAwXSAgYzE4OTk4MDAgYzE3ODFmYTAgYzE4MTMxNTIgYzE3ODFmYmMgYzE4MTMx
OGIgMDAwMDAwMDAgYzE3ODFmYmMgMDAwMDAwMDAKWyAgICAwLjAwOTAwMF0gIDAwMDAwMDAw
IGMxODk5ODAwIGMxNzgxZmVjIGMxODBjYjExIDAwMDAwMGY4IGZmZmZmZmZmIGZmZmZmZmZm
IGMxODBjNTQ5ClsgICAgMC4wMDkwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDkwMDBdICBb
PGMxODEzMTUyPl0gaWRlbnRpZnlfYm9vdF9jcHUrMHgxNy8weDI4ClsgICAgMC4wMDkwMDBd
ICBbPGMxODEzMThiPl0gY2hlY2tfYnVncysweGUvMHgxNjAKWyAgICAwLjAwOTAwMF0gIFs8
YzE4MGNiMTE+XSBzdGFydF9rZXJuZWwrMHg0MDEvMHg0NzAKWyAgICAwLjAwOTAwMF0gIFs8
YzE4MGM1NDk+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4NTEvMHg1MQpbICAgIDAuMDA5MDAw
XSAgWzxjMTgwYzM2ND5dIGkzODZfc3RhcnRfa2VybmVsKzB4MTJlLzB4MTMxClsgICAgMC4w
MDkwMDBdIENvZGU6IGY2IGM0IDA4IDc0IDEyIGJhIDEwIDk0IDg1IGMxIDgxIGVhIDBjIDg0
IDg1IGMxIGJlIDBjIDg0IDg1IGMxIGViIDEwIGJhIDBjIDg0IDg1IGMxIDgxIGVhIDFjIDc0
IDg1IGMxIGJlIDFjIDc0IDg1IGMxIDg5IGRmIDg5IGQxIDxmMz4gYTQgODkgZDggZTggOGIg
ZmUgZmYgZmYgYjkgMDQgMDAgMDAgMDAgYmEgMjUgZmYgNmQgYzEgODkgZDgKWyAgICAwLjAw
OTAwMF0gRUlQOiBbPGMxODFmYzM3Pl0gc3lzZW50ZXJfc2V0dXArMHg5YS8weDJkNCBTUzpF
U1AgMDA2ODpjMTc4MWY3NApbICAgIDAuMDA5MDAwXSBDUjI6IDAwMDAwMDAwZDFjYmQwMDAK
WyAgICAwLjAwOTAwMF0gLS0tWyBlbmQgdHJhY2UgZGI0YjdmZGU3Nzg2YmIwNyBdLS0tClsg
ICAgMC4wMDkwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRp
b24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzZjMjE5MWFkOWI2MjI1
ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIw
MTQwMzA3MDU1NTE2OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0w
MTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIv
NmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy1xdWFudGFs
LXJvYW0tMzE6MjAxNDAzMDcwNTU1MTY6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjoz
LjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhOjQyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5o
MC0wMzA3MDIyMi82YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyL2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTI1OjIwMTQwMzA3MDU1NTE4OmkzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBj
M2Q1YWQzOTE4Mi9kbWVzZy15b2N0by1yb2FtLTIwOjIwMTQwMzA3MDU1NTE2OmkzODYtcmFu
ZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3
MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy15b2N0by1yb2FtLTIxOjIwMTQwMzA3MDU1NTE2
OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkx
YTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYy
MjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy15b2N0by1yb2FtLTM0OjIwMTQw
MzA3MDU1NTE5OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQw
MC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMy
MTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy15b2N0by1yb2Ft
LTM1OjIwMTQwMzA3MDU1NTE2OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4w
LXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMw
NzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy15
b2N0by1yb2FtLTM2OjIwMTQwMzA3MDU1NTE5OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAy
MjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4
Mi9kbWVzZy15b2N0by1yb2FtLTQyOjIwMTQwMzA3MDU1NTE5OmkzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBj
M2Q1YWQzOTE4Mi9kbWVzZy15b2N0by1yb2FtLTQ6MjAxNDAzMDcwNTU1MTk6aTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhOjQyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi82YzIxOTFhZDliNjIyNTg2MGVlZjcw
YTc3ZDMwMGMzZDVhZDM5MTgyL2RtZXNnLXlvY3RvLXJvYW0tNzoyMDE0MDMwNzA1NTUxNjpp
Mzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDE0MDAtZzZjMjE5MWE6
NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzZjMjE5MWFkOWI2MjI1
ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2cteW9jdG8teGlhbi0yMzoyMDE0MDMw
NzA1NTUyMzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDE0MDAt
ZzZjMjE5MWE6NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzZjMjE5
MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2cteW9jdG8teGlhbi0y
NjoyMDE0MDMwNzA1NTUxNjppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1y
YzUtMDE0MDAtZzZjMjE5MWE6NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcw
MjIyLzZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2cteW9j
dG8teGlhbi0zMzoyMDE0MDMwNzA1NTUyMzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
OjMuMTQuMC1yYzUtMDE0MDAtZzZjMjE5MWE6NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
bmgwLTAzMDcwMjIyLzZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQwMzA3MDU1NTI1OmkzODYtcmFuZGNvbmZp
Zy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2Qz
MDBjM2Q1YWQzOTE4Mi9kbWVzZy1xdWFudGFsLXJvYW0tMTE6MjAxNDAzMDcwNTU1MjY6aTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhOjQy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi82YzIxOTFhZDliNjIyNTg2
MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyL2RtZXNnLXF1YW50YWwtcm9hbS0yMzoyMDE0MDMw
NzA1NTUyNjppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDE0MDAt
ZzZjMjE5MWE6NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzZjMjE5
MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFkMzkxODIvZG1lc2ctcXVhbnRhbC1yb2Ft
LTQ1OjIwMTQwMzA3MDU1NTI2OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4w
LXJjNS0wMTQwMC1nNmMyMTkxYTo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMw
NzAyMjIvNmMyMTkxYWQ5YjYyMjU4NjBlZWY3MGE3N2QzMDBjM2Q1YWQzOTE4Mi9kbWVzZy1x
dWFudGFsLXhpYW4tMTU6MjAxNDAzMDcwNTU1Mjk6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3
MDIyMjozLjE0LjAtcmM1LTAxNDAwLWc2YzIxOTFhOjQyCjA6MTk6MTUgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTQwMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCls2MWNhMDFiNWFhNjM2MDVlMDMzZjE4
MjZkY2NlYjQxNDIxYWE3MmNkXSBNZXJnZSAndWJpZnMvbWFzdGVyJyBpbnRvIGRldmVsLWhv
dXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjYxY2EwMWI1YWE2MzYwNWUw
MzNmMTgyNmRjY2ViNDE0MjFhYTcyY2Q6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNy0wNTo1
NTozOSA2MWNhMDFiNWFhNjM2MDVlMDMzZjE4MjZkY2NlYjQxNDIxYWE3MmNkIGNvbXBpbGlu
ZwoyMTcgcmVhbCAgMTk3OCB1c2VyICAxNzIgc3lzICA5ODcuMzYlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzA3MDIyMgoKMjAxNC0wMy0wNy0wNTo1OTozOCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjE0LjAtcmM1LTAwNzg0LWc2MWNhMDFiLi4JMgk2CTExCTE1CTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogNjE2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxMCBzdGVwcykKWzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdk
MjBjZmNdIE1lcmdlICd0aXAveDg2L3Zkc28nIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2
MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6NTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0
N2MwN2QyMGNmYzpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA2OjAzOjE0IDUzZGNhMGI1
ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMgY29tcGlsaW5nCjI2NSByZWFsICAy
MDAzIHVzZXIgIDE3MSBzeXMgIDgyMC4yOCUgY3B1IAlpMzg2LXJhbmRjb25maWctbmgwLTAz
MDcwMjIyCgoyMDE0LTAzLTA3LTA2OjA5OjM4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzUtMDExOTItZzUzZGNhMGIuLi4gVEVTVCBGQUlMVVJFClsgICAgMC4wMDQwMTNdIHBp
ZF9tYXg6IGRlZmF1bHQ6IDQwOTYgbWluaW11bTogMzAxClsgICAgMC4wMDYyMzFdIE1vdW50
LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTEyClsgICAgMC4wMDkxNTNdIG1jZTogQ1BV
IHN1cHBvcnRzIDEwIE1DRSBiYW5rcwpbICAgIDAuMDEwMDU5XSBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGNkY2JkMDAwClsgICAgMC4wMTEwMDBd
IElQOiBbPGMxODFjYmRiPl0gc3lzZW50ZXJfc2V0dXArMHg5YS8weDJkNApbICAgIDAuMDEx
MDAwXSAqcGRwdCA9IDAwMDAwMDAwMDE4OGUwMDEgKnBkZSA9IDAwMDAwMDAwMGU1ZjYwNjcg
KnB0ZSA9IDgwMDAwMDAwMGRjYmQwNjAgClsgICAgMC4wMTEwMDBdIE9vcHM6IDAwMDIgWyMx
XSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjAxMTAwMF0gTW9kdWxlcyBs
aW5rZWQgaW46ClsgICAgMC4wMTEwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGIgIzQ0ClsgICAgMC4wMTEw
MDBdIHRhc2s6IGMxNzg5N2MwIHRpOiBjMTc3ZTAwMCB0YXNrLnRpOiBjMTc3ZTAwMApbICAg
IDAuMDExMDAwXSBFSVA6IDAwNjA6WzxjMTgxY2JkYj5dIEVGTEFHUzogMDAyMTAyMTIgQ1BV
OiAwClsgICAgMC4wMTEwMDBdIEVJUCBpcyBhdCBzeXNlbnRlcl9zZXR1cCsweDlhLzB4MmQ0
ClsgICAgMC4wMTEwMDBdIEVBWDogMDc4YmZiZmQgRUJYOiBjZGNiYzAwMCBFQ1g6IDAwMDAw
MDA0IEVEWDogMDAwMDEwMDQKWyAgICAwLjAxMTAwMF0gRVNJOiBjMTg1NjQwYyBFREk6IGNk
Y2JkMDAwIEVCUDogYzE3N2ZmOTggRVNQOiBjMTc3ZmY3NApbICAgIDAuMDExMDAwXSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAwLjAxMTAw
MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGNkY2JkMDAwIENSMzogMDE4OTEwMDAgQ1I0OiAwMDAw
MDZmMApbICAgIDAuMDExMDAwXSBTdGFjazoKWyAgICAwLjAxMTAwMF0gIDAwMjAwMjAyIGMx
ZDkxMGYwIDAwMDAwZjYxIDAwMDAwODAwIDgwMDAyMDAxIDA3OGJmYmZkIDAwMDAwMDAwIDAw
MDAwMDAwClsgICAgMC4wMTEwMDBdICBjMTg5MjgwMCBjMTc3ZmZhMCBjMTgxMDE1MiBjMTc3
ZmZiYyBjMTgxMDE4YiAwMDAwMDAwMCBjMTc3ZmZiYyAwMDAwMDAwMApbICAgIDAuMDExMDAw
XSAgMDAwMDAwMDAgYzE4OTI4MDAgYzE3N2ZmZWMgYzE4MDliMTEgMDAwMDAwZjggZmZmZmZm
ZmYgZmZmZmZmZmYgYzE4MDk1NDkKWyAgICAwLjAxMTAwMF0gQ2FsbCBUcmFjZToKWyAgICAw
LjAxMTAwMF0gIFs8YzE4MTAxNTI+XSBpZGVudGlmeV9ib290X2NwdSsweDE3LzB4MjgKWyAg
ICAwLjAxMTAwMF0gIFs8YzE4MTAxOGI+XSBjaGVja19idWdzKzB4ZS8weDE2MApbICAgIDAu
MDExMDAwXSAgWzxjMTgwOWIxMT5dIHN0YXJ0X2tlcm5lbCsweDQwMS8weDQ3MApbICAgIDAu
MDExMDAwXSAgWzxjMTgwOTU0OT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1MS8weDUxClsg
ICAgMC4wMTEwMDBdICBbPGMxODA5MzY0Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHgxMmUvMHgx
MzEKWyAgICAwLjAxMTAwMF0gQ29kZTogZjYgYzQgMDggNzQgMTIgYmEgMTAgNjQgODUgYzEg
ODEgZWEgMGMgNTQgODUgYzEgYmUgMGMgNTQgODUgYzEgZWIgMTAgYmEgMGMgNTQgODUgYzEg
ODEgZWEgMWMgNDQgODUgYzEgYmUgMWMgNDQgODUgYzEgODkgZGYgODkgZDEgPGYzPiBhNCA4
OSBkOCBlOCA4YiBmZSBmZiBmZiBiOSAwNCAwMCAwMCAwMCBiYSA4OSBlYSA2ZCBjMSA4OSBk
OApbICAgIDAuMDExMDAwXSBFSVA6IFs8YzE4MWNiZGI+XSBzeXNlbnRlcl9zZXR1cCsweDlh
LzB4MmQ0IFNTOkVTUCAwMDY4OmMxNzdmZjc0ClsgICAgMC4wMTEwMDBdIENSMjogMDAwMDAw
MDBjZGNiZDAwMApbICAgIDAuMDExMDAwXSAtLS1bIGVuZCB0cmFjZSBkYjRiN2ZkZTc3ODZi
YjA3IF0tLS0KWyAgICAwLjAxMTAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNTNk
Y2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy1xdWFudGFsLWl2
eXRvd24yLTU6MjAxNDAzMDcwNjEwMzY6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjoz
LjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBiOjQ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5o
MC0wMzA3MDIyMi81M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTIzOjIwMTQwMzA3MDYxMDM2OmkzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTE5Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0
N2MwN2QyMGNmYy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTU6MjAxNDAzMDcwNjEwNDU6aTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBiOjQ0
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi81M2RjYTBiNWYwZTI1N2Yw
MGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXlvY3RvLWl2eXRvd24yLTIzOjIwMTQw
MzA3MDYxMDQ1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMTE5
Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNTNk
Y2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy1xdWFudGFsLWF0
aGVucy00OjIwMTQwMzA3MDYxMDUyOmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4x
NC4wLXJjNS0wMTE5Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMwNzAyMjIvNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVz
Zy1xdWFudGFsLWF0aGVucy05OjIwMTQwMzA3MDYxMDU5OmkzODYtcmFuZGNvbmZpZy1uaDAt
MDMwNzAyMjI6My4xNC4wLXJjNS0wMTE5Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1uaDAtMDMwNzAyMjIvNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2Mw
N2QyMGNmYy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTU6MjAxNDAzMDcwNjEwNTk6aTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBiOjQ0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi81M2RjYTBiNWYwZTI1N2YwMGI5
MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXF1YW50YWwtcm9hbS0zNzoyMDE0MDMwNzA2
MTA1OTppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDExOTItZzUz
ZGNhMGI6NDQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzUzZGNhMGI1
ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMvZG1lc2cteW9jdG8tYmVucy02OjIw
MTQwMzA3MDYxMDU4OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0w
MTE5Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIv
NTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy15b2N0by1p
dnl0b3duMi0yMzoyMDE0MDMwNzA2MTA1NDppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
OjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NDQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
bmgwLTAzMDcwMjIyLzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMv
ZG1lc2cteW9jdG8tcm9hbS0yMDoyMDE0MDMwNzA2MTA1OTppMzg2LXJhbmRjb25maWctbmgw
LTAzMDcwMjIyOjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NDQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctbmgwLTAzMDcwMjIyLzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMzYmU5OGZiNDdj
MDdkMjBjZmMvZG1lc2cteW9jdG8tcm9hbS0yMToyMDE0MDMwNzA2MTA1OTppMzg2LXJhbmRj
b25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6NDQKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzUzZGNhMGI1ZjBlMjU3ZjAwYjkxZmMz
YmU5OGZiNDdjMDdkMjBjZmMvZG1lc2cteW9jdG8tcm9hbS0zNjoyMDE0MDMwNzA2MTA1OTpp
Mzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDExOTItZzUzZGNhMGI6
NDQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzUzZGNhMGI1ZjBlMjU3
ZjAwYjkxZmMzYmU5OGZiNDdjMDdkMjBjZmMvZG1lc2ctcXVhbnRhbC1iZW5zLTE6MjAxNDAz
MDcwNjExMDE6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAxMTky
LWc1M2RjYTBiOjQ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi81M2Rj
YTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIwY2ZjL2RtZXNnLXF1YW50YWwtYmVu
cy00OjIwMTQwMzA3MDYxMTAzOmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4w
LXJjNS0wMTE5Mi1nNTNkY2EwYjo0NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMw
NzAyMjIvNTNkY2EwYjVmMGUyNTdmMDBiOTFmYzNiZTk4ZmI0N2MwN2QyMGNmYy9kbWVzZy15
b2N0by1iZW5zLTE6MjAxNDAzMDcwNjExMDE6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIy
MjozLjE0LjAtcmM1LTAxMTkyLWc1M2RjYTBiOjQ0CjA6MTY6MTYgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDcgMDY6MTE6MDkgUkVQRUFUIENPVU5UOiAy
MCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNl
Y3Rpbmc6IDQwOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
OSBzdGVwcykKW2YyNWVkMGViYzE5NGE1MTA0MmE1MzkyY2E4MjFkZTJmZjY2NjEyNzVdIE1l
cmdlICdzbGF2ZS1kbWEvbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODpmMjVlZDBlYmMxOTRhNTEwNDJhNTM5MmNhODIxZGUyZmY2NjYx
Mjc1OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDY6MTE6MTAgZjI1ZWQwZWJjMTk0YTUx
MDQyYTUzOTJjYTgyMWRlMmZmNjY2MTI3NSBjb21waWxpbmcKMTA2IHJlYWwgIDE5NzEgdXNl
ciAgMTY2IHN5cyAgMTk5OS44NSUgY3B1IAlpMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
CgoyMDE0LTAzLTA3LTA2OjEzOjE3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUt
MDA3OTktZ2YyNWVkMGUuLi4uLi4uLi4uLi4JMwkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM5
MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykK
W2UwMDk5YjgxNjVlMjUyNTU0MWQ3ODQ0ZTI5ZTg4Mzg4MjRiMzYwMWVdIE1lcmdlICdwY21v
b3JlLXNlbGludXgvbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDAzMDYxODplMDA5OWI4MTY1ZTI1MjU1NDFkNzg0NGUyOWU4ODM4ODI0YjM2MDFl
OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDY6MjA6MTggZTAwOTliODE2NWUyNTI1NTQx
ZDc4NDRlMjllODgzODgyNGIzNjAxZSBjb21waWxpbmcKMjkgcmVhbCAgMTgzIHVzZXIgIDI1
IHN5cyAgNzA2LjU0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIKCjIwMTQt
MDMtMDctMDY6MjE6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMTA1NC1n
ZTAwOTliOC4uCTkJMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzggcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltjMjRiZjU0NjgzZGQw
MDk4ZTg3OGEwY2Y0MGUyNjY3ZTQ2YTM5YTBhXSBNZXJnZSAncmVuZXNhcy9uZXh0JyBpbnRv
IGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgw
LTAzMDcwMjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OmMyNGJmNTQ2
ODNkZDAwOThlODc4YTBjZjQwZTI2NjdlNDZhMzlhMGE6YmlzZWN0LWxpbnV4NAoKMjAxNC0w
My0wNy0wNjoyMzo0NCBjMjRiZjU0NjgzZGQwMDk4ZTg3OGEwY2Y0MGUyNjY3ZTQ2YTM5YTBh
IGNvbXBpbGluZwo1NCByZWFsICAxODYgdXNlciAgMjYgc3lzICAzOTAuMTAlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMgoKMjAxNC0wMy0wNy0wNjoyNjoyMSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAxMTc5LWdjMjRiZjU0Li4uLi4JMTkJMjAgU1VD
Q0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgdGlwL3g4Ni92ZHNvCmxp
bmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDog
Z2l0IGJpc2VjdCBzdGFydCA1M2RjYTBiNWYwZTI1N2YwMGI5MWZjM2JlOThmYjQ3YzA3ZDIw
Y2ZjIGMyNGJmNTQ2ODNkZDAwOThlODc4YTBjZjQwZTI2NjdlNDZhMzlhMGEgLS0KUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgYzI0YmY1NC4uLiBNZXJnZSAncmVuZXNhcy9uZXh0JyBp
bnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CkhFQUQgaXMgbm93IGF0IGZiZTkzOGUuLi4g
TWVyZ2UgJ2FybS1zb2MvbmV4dC9kcml2ZXJzJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMw
NjE4CkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMyBzdGVwcykKWzY1NDNjYTZmZWU3ZDNiMzE0YmRhNjliODNmZDQyOWVkM2UzMzY2
NDVdIHg4NiwgdmRzbzogQ2xlYW51cCBfX3Zkc29fZ2V0dGltZW9mZGF5KCkKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDMwNjE4OjY1NDNjYTZmZWU3ZDNiMzE0YmRhNjliODNmZDQyOWVkM2UzMzY2NDU6Ymlz
ZWN0LWxpbnV4NAoKMjAxNC0wMy0wNy0wNjoyOTo1NSA2NTQzY2E2ZmVlN2QzYjMxNGJkYTY5
YjgzZmQ0MjllZDNlMzM2NjQ1IGNvbXBpbGluZwoxMTMgcmVhbCAgMTk3NSB1c2VyICAxODYg
c3lzICAxOTAxLjM2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIKCjIwMTQt
MDMtMDctMDY6MzI6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMDAwNi1n
NjU0M2NhNi4uLi4JMTAJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbNGRlYThlNDgyNGIzNjNj
NTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOV0geDg2LCB2ZHNvOiBBZGQgMzIgYml0IFZEU08g
dGltZSBzdXBwb3J0IGZvciAzMiBiaXQga2VybmVsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctbmgwLTAzMDcwMjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjRk
ZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTk6YmlzZWN0LWxpbnV4NAoK
MjAxNC0wMy0wNy0wNjozNTowOCA0ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1
OTIxNDE5IGNvbXBpbGluZwo4OSByZWFsICAxMzgxIHVzZXIgIDEzMyBzeXMgIDE2OTIuOTkl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMgoKMjAxNC0wMy0wNy0wNjozNjo1
OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0LiBURVNU
IEZBSUxVUkUKWyAgICAwLjAwMzAwMF0gcGlkX21heDogZGVmYXVsdDogNDA5NiBtaW5pbXVt
OiAzMDEKWyAgICAwLjAwMzUzOF0gTW91bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1
MTIKWyAgICAwLjAwNTQ3Ml0gbWNlOiBDUFUgc3VwcG9ydHMgMTAgTUNFIGJhbmtzClsgICAg
MC4wMDU5MjZdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3Qg
YXQgZDFjYmQwMDAKWyAgICAwLjAwNjAwMF0gSVA6IFs8YzE4MTlhYmE+XSBzeXNlbnRlcl9z
ZXR1cCsweDlhLzB4MmQ0ClsgICAgMC4wMDYwMDBdICpwZHB0ID0gMDAwMDAwMDAwMTg4YTAw
MSAqcGRlID0gMDAwMDAwMDAxMjVmNjA2NyAqcHRlID0gODAwMDAwMDAxMWNiZDA2MCAKWyAg
ICAwLjAwNjAwMF0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExP
QwpbICAgIDAuMDA2MDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwNjAwMF0gQ1BV
OiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wMDAw
OS1nNGRlYThlNCAjNDkKWyAgICAwLjAwNjAwMF0gdGFzazogYzE3ODc3YzAgdGk6IGMxNzdj
MDAwIHRhc2sudGk6IGMxNzdjMDAwClsgICAgMC4wMDYwMDBdIEVJUDogMDA2MDpbPGMxODE5
YWJhPl0gRUZMQUdTOiAwMDIxMDIxMiBDUFU6IDAKWyAgICAwLjAwNjAwMF0gRUlQIGlzIGF0
IHN5c2VudGVyX3NldHVwKzB4OWEvMHgyZDQKWyAgICAwLjAwNjAwMF0gRUFYOiAwNzhiZmJm
ZCBFQlg6IGQxY2JjMDAwIEVDWDogMDAwMDAwNTQgRURYOiAwMDAwMTA1NApbICAgIDAuMDA2
MDAwXSBFU0k6IGMxODUyNDVjIEVESTogZDFjYmQwMDAgRUJQOiBjMTc3ZGY5OCBFU1A6IGMx
NzdkZjc0ClsgICAgMC4wMDYwMDBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzog
MDAwMCBTUzogMDA2OApbICAgIDAuMDA2MDAwXSBDUjA6IDgwMDUwMDNiIENSMjogZDFjYmQw
MDAgQ1IzOiAwMTg4ZDAwMCBDUjQ6IDAwMDAwNmYwClsgICAgMC4wMDYwMDBdIFN0YWNrOgpb
ICAgIDAuMDA2MDAwXSAgMDAyMDAyMDIgYzFkOGQwZjAgMDAwMDBmNjEgMDAwMDA4MDAgODAw
MDIwMDEgMDc4YmZiZmQgMDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjAwNjAwMF0gIGMxODhl
ODAwIGMxNzdkZmEwIGMxODBkMTQ5IGMxNzdkZmJjIGMxODBkMTgyIDAwMDAwMDAwIGMxNzdk
ZmJjIDAwMDAwMDAwClsgICAgMC4wMDYwMDBdICAwMDAwMDAwMCBjMTg4ZTgwMCBjMTc3ZGZl
YyBjMTgwNmIxMSAwMDAwMDBmOCBmZmZmZmZmZiBmZmZmZmZmZiBjMTgwNjU0OQpbICAgIDAu
MDA2MDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDA2MDAwXSAgWzxjMTgwZDE0OT5dIGlkZW50
aWZ5X2Jvb3RfY3B1KzB4MTcvMHgyOApbICAgIDAuMDA2MDAwXSAgWzxjMTgwZDE4Mj5dIGNo
ZWNrX2J1Z3MrMHhlLzB4MTYwClsgICAgMC4wMDYwMDBdICBbPGMxODA2YjExPl0gc3RhcnRf
a2VybmVsKzB4NDAxLzB4NDcwClsgICAgMC4wMDYwMDBdICBbPGMxODA2NTQ5Pl0gPyByZXBh
aXJfZW52X3N0cmluZysweDUxLzB4NTEKWyAgICAwLjAwNjAwMF0gIFs8YzE4MDYzNjQ+XSBp
Mzg2X3N0YXJ0X2tlcm5lbCsweDEyZS8weDEzMQpbICAgIDAuMDA2MDAwXSBDb2RlOiBmNiBj
NCAwOCA3NCAxMiBiYSBiMCAyNCA4NSBjMSA4MSBlYSA1YyAxNCA4NSBjMSBiZSA1YyAxNCA4
NSBjMSBlYiAxMCBiYSA1YyAxNCA4NSBjMSA4MSBlYSAxYyAwNCA4NSBjMSBiZSAxYyAwNCA4
NSBjMSA4OSBkZiA4OSBkMSA8ZjM+IGE0IDg5IGQ4IGU4IDhiIGZlIGZmIGZmIGI5IDA0IDAw
IDAwIDAwIGJhIDMyIGMyIDZkIGMxIDg5IGQ4ClsgICAgMC4wMDYwMDBdIEVJUDogWzxjMTgx
OWFiYT5dIHN5c2VudGVyX3NldHVwKzB4OWEvMHgyZDQgU1M6RVNQIDAwNjg6YzE3N2RmNzQK
WyAgICAwLjAwNjAwMF0gQ1IyOiAwMDAwMDAwMGQxY2JkMDAwClsgICAgMC4wMDYwMDBdIC0t
LVsgZW5kIHRyYWNlIGRiNGI3ZmRlNzc4NmJiMDcgXS0tLQpbICAgIDAuMDA2MDAwXSBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzA3MDIyMi80ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdj
NmM1OTIxNDE5L2RtZXNnLXlvY3RvLWl2eXRvd24yLTE2OjIwMTQwMzA3MDYzNzA1OmkzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThlNDo0OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRlYThlNDgyNGIzNjNjNTNm
MzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTI4OjIwMTQw
MzA3MDYzNzExOmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAw
OS1nNGRlYThlNDo0OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRl
YThlNDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy15b2N0by1sa3At
c3QwMS0xMzoyMDE0MDMwNzA2MzcwOTppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMu
MTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgw
LTAzMDcwMjIyLzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1l
c2cteW9jdG8teGJtLTE6MjAxNDAzMDcwNjM3MTM6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3
MDIyMjozLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0OjQ5Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzA3MDIyMi80ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1OTIx
NDE5L2RtZXNnLXlvY3RvLXhwcy0zOjIwMTQwMzA3MDYzNzEzOmkzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThlNDo0OQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRlYThlNDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3
YzZjNTkyMTQxOS9kbWVzZy15b2N0by1pdnl0b3duMi0xNjoyMDE0MDMwNzA2MzcxNDppMzg2
LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6NDkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzRkZWE4ZTQ4MjRiMzYzYzUz
ZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMToyMDE0
MDMwNzA2MzcxNzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDAw
MDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzRk
ZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1lc2ctcXVhbnRhbC1p
dnl0b3duMi0yNDoyMDE0MDMwNzA2MzcxNjppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
OjMuMTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
bmgwLTAzMDcwMjIyLzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yODoyMDE0MDMwNzA2MzcyMDppMzg2LXJhbmRjb25m
aWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgw
NDBkN2M2YzU5MjE0MTkvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi01OjIwMTQwMzA3MDYzNzE3
OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThl
NDo0OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRlYThlNDgyNGIz
NjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTg6
MjAxNDAzMDcwNjM3MjA6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1
LTAwMDA5LWc0ZGVhOGU0OjQ5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIy
Mi80ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1OTIxNDE5L2RtZXNnLXF1YW50
YWwteGlhbi0zNDoyMDE0MDMwNzA2MzcyMzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
OjMuMTQuMC1yYzUtMDAwMDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
bmgwLTAzMDcwMjIyLzRkZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkv
ZG1lc2cteW9jdG8taXZ5dG93bjItMTQ6MjAxNDAzMDcwNjM3MjQ6aTM4Ni1yYW5kY29uZmln
LW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0OjQ5Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi80ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQw
ZDdjNmM1OTIxNDE5L2RtZXNnLXlvY3RvLWl2eXRvd24yLTE2OjIwMTQwMzA3MDYzNzIzOmkz
ODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThlNDo0
OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRlYThlNDgyNGIzNjNj
NTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOS9kbWVzZy15b2N0by1pdnl0b3duMi0yMToyMDE0
MDMwNzA2MzcxNzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDAw
MDktZzRkZWE4ZTQ6NDkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzRk
ZWE4ZTQ4MjRiMzYzYzUzZjMyMGQzMjgwNDBkN2M2YzU5MjE0MTkvZG1lc2cteW9jdG8tbGtw
LXN0MDEtMTM6MjAxNDAzMDcwNjM3MjE6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjoz
LjE0LjAtcmM1LTAwMDA5LWc0ZGVhOGU0OjQ5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5o
MC0wMzA3MDIyMi80ZGVhOGU0ODI0YjM2M2M1M2YzMjBkMzI4MDQwZDdjNmM1OTIxNDE5L2Rt
ZXNnLXlvY3RvLWxrcC1zdDAxLTE0OjIwMTQwMzA3MDYzNzIzOmkzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThlNDo0OQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvNGRlYThlNDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3
YzZjNTkyMTQxOS9kbWVzZy15b2N0by1sa3Atc3QwMS00OjIwMTQwMzA3MDYzNzIxOmkzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMDAwOS1nNGRlYThlNDo0OQow
OjE4OjE1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzgyNzI0MTY5
NjhhOWJkODI0NDUxNTE3OTYyNWNkZWZmZDdjMmM5MGFdIHg4NiwgdmRzbzogUGF0Y2ggYWx0
ZXJuYXRpdmVzIGluIHRoZSAzMi1iaXQgVkRTTwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LW5oMC0wMzA3MDIyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo4Mjcy
NDE2OTY4YTliZDgyNDQ1MTUxNzk2MjVjZGVmZmQ3YzJjOTBhOmJpc2VjdC1saW51eDQKCjIw
MTQtMDMtMDctMDY6Mzc6MzAgODI3MjQxNjk2OGE5YmQ4MjQ0NTE1MTc5NjI1Y2RlZmZkN2My
YzkwYSBjb21waWxpbmcKODkgcmVhbCAgMTM4OSB1c2VyICAxMzEgc3lzICAxNjk5LjQ5JSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIKCjIwMTQtMDMtMDctMDY6Mzk6MTUg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMDAwOC1nODI3MjQxNi4uCTcJMjAg
U1VDQ0VTUwoKNGRlYThlNDgyNGIzNjNjNTNmMzIwZDMyODA0MGQ3YzZjNTkyMTQxOSBpcyB0
aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgNGRlYThlNDgyNGIzNjNjNTNmMzIwZDMyODA0
MGQ3YzZjNTkyMTQxOQpBdXRob3I6IFN0ZWZhbmkgU2VpYm9sZCA8c3RlZmFuaUBzZWlib2xk
Lm5ldD4KRGF0ZTogICBNb24gTWFyIDMgMjI6MTI6MjAgMjAxNCArMDEwMAoKICAgIHg4Niwg
dmRzbzogQWRkIDMyIGJpdCBWRFNPIHRpbWUgc3VwcG9ydCBmb3IgMzIgYml0IGtlcm5lbAog
ICAgCiAgICBUaGlzIHBhdGNoIGFkZCB0aGUgdGltZSBzdXBwb3J0IGZvciAzMiBiaXQgYSBW
RFNPIHRvIGEgMzIgYml0IGtlcm5lbC4KICAgIAogICAgRm9yIDMyIGJpdCBwcm9ncmFtcyBy
dW5uaW5nIG9uIGEgMzIgYml0IGtlcm5lbCwgdGhlIHNhbWUgbWVjaGFuaXNtIGlzCiAgICB1
c2VkIGFzIGZvciA2NCBiaXQgcHJvZ3JhbXMgcnVubmluZyBvbiBhIDY0IGJpdCBrZXJuZWwu
CiAgICAKICAgIFJldmlld2VkLWJ5OiBBbmR5IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRh
bC5uZXQ+CiAgICBTaWduZWQtb2ZmLWJ5OiBTdGVmYW5pIFNlaWJvbGQgPHN0ZWZhbmlAc2Vp
Ym9sZC5uZXQ+CiAgICBMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL3IvMTM5Mzg4MTE0
My0zNTY5LTEwLWdpdC1zZW5kLWVtYWlsLXN0ZWZhbmlAc2VpYm9sZC5uZXQKICAgIFNpZ25l
ZC1vZmYtYnk6IEguIFBldGVyIEFudmluIDxocGFAbGludXguaW50ZWwuY29tPgoKOjA0MDAw
MCAwNDAwMDAgMzBmYjMyMzc0MjY2M2JlMWIwMDc5ODAyN2VlN2IzMDk0MTM1YzRkOSAxZDI4
NjRmNWNiZjIzZmU4NTJlODU1MWQ2MTE0MWRkODlhMGRkOTYyIE0JYXJjaApiaXNlY3QgcnVu
IHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1uaDAtMDMwNzAyMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6
ODI3MjQxNjk2OGE5YmQ4MjQ0NTE1MTc5NjI1Y2RlZmZkN2MyYzkwYTpiaXNlY3QtbGludXg0
CgoyMDE0LTAzLTA3LTA2OjQxOjIxIDgyNzI0MTY5NjhhOWJkODI0NDUxNTE3OTYyNWNkZWZm
ZDdjMmM5MGEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyLzgy
NzI0MTY5NjhhOWJkODI0NDUxNTE3OTYyNWNkZWZmZDdjMmM5MGEvdm1saW51ei0zLjE0LjAt
cmM1LTAwMDA4LWc4MjcyNDE2CgoyMDE0LTAzLTA3LTA2OjQxOjIyIGRldGVjdGluZyBib290
IHN0YXRlIC4JMjEJMjkJNTQJNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYw
NDNkYmE3ODpiaXNlY3QtbGludXg0CiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMzAwMF0gcGlk
X21heDogZGVmYXVsdDogNDA5NiBtaW5pbXVtOiAzMDEKWyAgICAwLjAwMzU1NF0gTW91bnQt
Y2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MTIKWyAgICAwLjAwNTQwM10gbWNlOiBDUFUg
c3VwcG9ydHMgMTAgTUNFIGJhbmtzClsgICAgMC4wMDU4NTVdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZDFjYmQwMDAKWyAgICAwLjAwNjAwMF0g
SVA6IFs8YzE4MmRiY2E+XSBzeXNlbnRlcl9zZXR1cCsweDlhLzB4MmQ0ClsgICAgMC4wMDYw
MDBdICpwZHB0ID0gMDAwMDAwMDAwMThhNDAwMSAqcGRlID0gMDAwMDAwMDAxMjVmNjA2NyAq
cHRlID0gODAwMDAwMDAxMWNiZDA2MCAKWyAgICAwLjAwNjAwMF0gT29wczogMDAwMiBbIzFd
IFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMDA2MDAwXSBNb2R1bGVzIGxp
bmtlZCBpbjoKWyAgICAwLjAwNjAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAg
Tm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NiAjMgpbICAgIDAuMDA2MDAw
XSB0YXNrOiBjMTc5OTdjMCB0aTogYzE3OGUwMDAgdGFzay50aTogYzE3OGUwMDAKWyAgICAw
LjAwNjAwMF0gRUlQOiAwMDYwOls8YzE4MmRiY2E+XSBFRkxBR1M6IDAwMjEwMjEyIENQVTog
MApbICAgIDAuMDA2MDAwXSBFSVAgaXMgYXQgc3lzZW50ZXJfc2V0dXArMHg5YS8weDJkNApb
ICAgIDAuMDA2MDAwXSBFQVg6IDA3OGJmYmZkIEVCWDogZDFjYmMwMDAgRUNYOiAwMDAwMDAw
NCBFRFg6IDAwMDAxMDA0ClsgICAgMC4wMDYwMDBdIEVTSTogYzE4Njc0MGMgRURJOiBkMWNi
ZDAwMCBFQlA6IGMxNzhmZjk4IEVTUDogYzE3OGZmNzQKWyAgICAwLjAwNjAwMF0gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC4wMDYwMDBd
IENSMDogODAwNTAwM2IgQ1IyOiBkMWNiZDAwMCBDUjM6IDAxOGE3MDAwIENSNDogMDAwMDA2
ZjAKWyAgICAwLjAwNjAwMF0gU3RhY2s6ClsgICAgMC4wMDYwMDBdICAwMDIwMDIwMiBjMWRi
YjBmMCAwMDAwMGY2MSAwMDAwMDgwMCA4MDAwMjAwMSAwNzhiZmJmZCAwMDAwMDAwMCAwMDAw
MDAwMApbICAgIDAuMDA2MDAwXSAgYzE4YTg4MDAgYzE3OGZmYTAgYzE4MjExNDQgYzE3OGZm
YmMgYzE4MjExN2QgMDAwMDAwMDAgYzE3OGZmYmMgMDAwMDAwMDAKWyAgICAwLjAwNjAwMF0g
IDAwMDAwMDAwIGMxOGE4ODAwIGMxNzhmZmVjIGMxODFhYjExIDAwMDAwMTAxIGZmZmZmZmZm
IGZmZmZmZmZmIGMxODFhNTQ5ClsgICAgMC4wMDYwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4w
MDYwMDBdICBbPGMxODIxMTQ0Pl0gaWRlbnRpZnlfYm9vdF9jcHUrMHgxNy8weDI4ClsgICAg
MC4wMDYwMDBdICBbPGMxODIxMTdkPl0gY2hlY2tfYnVncysweGUvMHgxNjAKWyAgICAwLjAw
NjAwMF0gIFs8YzE4MWFiMTE+XSBzdGFydF9rZXJuZWwrMHg0MDEvMHg0NzAKWyAgICAwLjAw
NjAwMF0gIFs8YzE4MWE1NDk+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4NTEvMHg1MQpbICAg
IDAuMDA2MDAwXSAgWzxjMTgxYTM2ND5dIGkzODZfc3RhcnRfa2VybmVsKzB4MTJlLzB4MTMx
ClsgICAgMC4wMDYwMDBdIENvZGU6IGY2IGM0IDA4IDc0IDEyIGJhIDEwIDc0IDg2IGMxIDgx
IGVhIDBjIDY0IDg2IGMxIGJlIDBjIDY0IDg2IGMxIGViIDEwIGJhIDBjIDY0IDg2IGMxIDgx
IGVhIDFjIDU0IDg2IGMxIGJlIDFjIDU0IDg2IGMxIDg5IGRmIDg5IGQxIDxmMz4gYTQgODkg
ZDggZTggOGIgZmUgZmYgZmYgYjkgMDQgMDAgMDAgMDAgYmEgZDYgYzIgNmUgYzEgODkgZDgK
WyAgICAwLjAwNjAwMF0gRUlQOiBbPGMxODJkYmNhPl0gc3lzZW50ZXJfc2V0dXArMHg5YS8w
eDJkNCBTUzpFU1AgMDA2ODpjMTc4ZmY3NApbICAgIDAuMDA2MDAwXSBDUjI6IDAwMDAwMDAw
ZDFjYmQwMDAKWyAgICAwLjAwNjAwMF0gLS0tWyBlbmQgdHJhY2UgZGI0YjdmZGU3Nzg2YmIw
NyBdLS0tClsgICAgMC4wMDYwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRh
bCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyL2Q0Nzhh
OTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8teGd3by03
OjIwMTQwMzA3MDMzNDQ3OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJj
NS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIy
Mi9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTE2OjIwMTQwMzA3MDMzNDQ1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAy
MjI6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LW5oMC0wMzA3MDIyMi9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4
L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItODoyMDE0MDMwNzAzMzQzNjppMzg2LXJhbmRjb25m
aWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhh
ODc3MWYwNDNkYmE3OC9kbWVzZy1xdWFudGFsLXhnd28tNzoyMDE0MDMwNzAzMzQ0ODppMzg2
LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNh
MzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pdnl0b3duMi0yNjoyMDE0MDMw
NzA1NDgxNDppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUt
Z2Q0NzhhOTY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5
NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pdnl0b3du
Mi02OjIwMTQwMzA3MDU0ODE1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4w
LXJjNS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3
MDIyMi9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXF1
YW50YWwtaXZ5dG93bjItODoyMDE0MDMwNzAzMzQ0NTppMzg2LXJhbmRjb25maWctbmgwLTAz
MDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNk
YmE3OC9kbWVzZy15b2N0by14aWFuLTI1OjIwMTQwMzA3MDU0ODIyOmkzODYtcmFuZGNvbmZp
Zy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4
NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLXhpYW4tMzoyMDE0MDMwNzA1NDgyMjppMzg2LXJh
bmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNhMzFh
MDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by14aWFuLTU6MjAxNDAzMDcwNTQ4MjM6
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyL2Q0NzhhOTYwZWRmMWVh
NjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8taXZ5dG93bjItMTk6MjAx
NDAzMDcwNTQ4MTc6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAz
NzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyL2Q0
NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2ctcXVhbnRhbC1p
dnl0b3duMi0yNzoyMDE0MDMwNzAzMzQ0MzppMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIy
OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1u
aDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9k
bWVzZy15b2N0by14aWFuLTY6MjAxNDAzMDcwNTQ4MjM6aTM4Ni1yYW5kY29uZmlnLW5oMC0w
MzA3MDIyMjozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctbmgwLTAzMDcwMjIyL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQz
ZGJhNzgvZG1lc2cteW9jdG8taXZ5dG93bjItMjU6MjAxNDAzMDcwMzM0NDQ6aTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzA3MDIyMjozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctbmgwLTAzMDcwMjIyL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3
YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2ctcXVhbnRhbC14aWFuLTMyOjIwMTQwMzA3MDU0ODIy
OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5
NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9kNDc4YTk2MGVkZjFl
YTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI1OjIw
MTQwMzA3MDMzNDM1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjI6My4xNC4wLXJjNS0w
Mzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9k
NDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWl2
eXRvd24yLTU6MjAxNDAzMDcwNTQ4MTI6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMjoz
LjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgw
LTAzMDcwMjIyL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1l
c2ctcXVhbnRhbC1pdnl0b3duMi0xNDoyMDE0MDMwNzAzMzQ1MjppMzg2LXJhbmRjb25maWct
bmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3
MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pdnl0b3duMi0yNzoyMDE0MDMwNzA1NDgxODppMzg2
LXJhbmRjb25maWctbmgwLTAzMDcwMjIyOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgow
OjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCBkNDc4
YTk2IDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDMwNjE4JwoKPT09
PT09PT09IHVwc3RyZWFtID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBk
NDc4YTk2Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDMwNjE4
JwpIRUFEIGlzIG5vdyBhdCBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMwNzAyMjIvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6YzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBj
MWRlM2MxZjc3ZTJlMDpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA2OjQzOjU4IGMzYmVi
YzcxYzRiY2RhZmEyNGI1MDZhZGYwYzFkZTNjMWY3N2UyZTAgY29tcGlsaW5nCgoyMDE0LTAz
LTA3LTA2OjQ2OjI3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDAxODUtZ2Mz
YmViYzcuLi4uLi4uLi4uLi4uLi4uLi4JMQk0OAk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxp
bnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGMzYmViYzcu
Li4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L2RhdmVtL25ldApIRUFEIGlzIG5vdyBhdCAwZmZiMmZlLi4uIEFkZCBsaW51eC1uZXh0IHNw
ZWNpZmljIGZpbGVzIGZvciAyMDE0MDMwNgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzA3MDIyMi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODowZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMDY6NTc6MDEgMGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMyByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1uaDAtMDMwNzAyMjIvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2Yw
My92bWxpbnV6LTMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZQoKMjAx
NC0wMy0wNy0wNjo1NzowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTUJNDAJNjAgU1VDQ0VT
UwoK

--x4pBfXISqBoDm8sr
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
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
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
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
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
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_KPROBES_ON_FTRACE=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
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
# CONFIG_MEMTEST is not set
CONFIG_M486=y
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
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_INVD_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=12
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
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
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=m
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
CONFIG_ACTISYS_DONGLE=m
# CONFIG_TEKRAM_DONGLE is not set
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_CMTP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_MEI_PHY=m
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_MEI=m
# CONFIG_NFC_MICROREAD is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

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
CONFIG_MTD_TS5500=m
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
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
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_NAND_SH_FLCTL=m
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=m
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_WLAN=y
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_RTL8180=m
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH_CARDS=m
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
# CONFIG_ATH9K is not set
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
CONFIG_ATH6KL_DEBUG=y
# CONFIG_ATH6KL_TRACING is not set
CONFIG_WIL6210=m
CONFIG_WIL6210_ISR_COR=y
CONFIG_WIL6210_TRACING=y
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
# CONFIG_BRCMSMAC is not set
CONFIG_BRCMFMAC=m
# CONFIG_BRCMFMAC_SDIO is not set
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=m
# CONFIG_IPW2100 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
# CONFIG_IWLMVM is not set
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
# CONFIG_LIBERTAS is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
# CONFIG_RT2800PCI_RT53XX is not set
# CONFIG_RT2800PCI_RT3290 is not set
CONFIG_RT2800_LIB=m
CONFIG_RT2800_LIB_MMIO=m
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
# CONFIG_RTL_CARDS is not set
CONFIG_WL_TI=y
CONFIG_WL1251=m
CONFIG_WL1251_SPI=m
CONFIG_WL1251_SDIO=m
CONFIG_WL12XX=m
CONFIG_WL18XX=m
CONFIG_WLCORE=m
# CONFIG_WLCORE_SPI is not set
# CONFIG_WLCORE_SDIO is not set
CONFIG_WILINK_PLATFORM_DATA=y
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m
CONFIG_CW1200=m
# CONFIG_CW1200_WLAN_SDIO is not set
CONFIG_CW1200_WLAN_SPI=m

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=m
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
# CONFIG_DSCC4_PCISYNC is not set
# CONFIG_DSCC4_PCI_RST is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set

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
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
# CONFIG_HISAX_ELSA is not set
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_NETJET is not set
CONFIG_HISAX_NETJET_U=y
# CONFIG_HISAX_NICCY is not set
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
# CONFIG_HISAX_W6692 is not set
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=y
CONFIG_HISAX_FRITZ_PCIPNP=y

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=m
# CONFIG_MISDN_DSP is not set
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_STMPE=m
CONFIG_TOUCHSCREEN_TPS6507X=m
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=m
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=m
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_SONYPI=m
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_ATMEL=y
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BCM63XX_HSSPI=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_EP93XX=m
CONFIG_SPI_GPIO=y
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_TI_QSPI is not set
CONFIG_SPI_OMAP_100K=m
CONFIG_SPI_ORION=m
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=m
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_SUN4I=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MID_DMA=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

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

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
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
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DW_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=m
CONFIG_NV_TCO=m
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=m
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=m
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_WHCI=m
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_OMAP_HS=y
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_REALTEK_PCI is not set
# CONFIG_MEMSTICK is not set
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
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
# CONFIG_COMEDI_PCL724 is not set
CONFIG_COMEDI_PCL726=m
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
# CONFIG_COMEDI_PCL818 is not set
CONFIG_COMEDI_PCM3724=m
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
CONFIG_COMEDI_AMPLC_PC236_ISA=m
# CONFIG_COMEDI_AMPLC_PC263_ISA is not set
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
# CONFIG_COMEDI_DAS1800 is not set
CONFIG_COMEDI_DAS6402=m
# CONFIG_COMEDI_DT2801 is not set
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
# CONFIG_COMEDI_DT2817 is not set
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_UNIOXX5=m
CONFIG_COMEDI_FL512=m
# CONFIG_COMEDI_AIO_AIO12_8 is not set
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_II_PCI20KC=m
# CONFIG_COMEDI_C6XDIGIO is not set
# CONFIG_COMEDI_MPC624 is not set
CONFIG_COMEDI_ADQ12B=m
# CONFIG_COMEDI_NI_AT_A2150 is not set
CONFIG_COMEDI_NI_AT_AO=m
# CONFIG_COMEDI_NI_ATMIO is not set
CONFIG_COMEDI_NI_ATMIO16D=m
# CONFIG_COMEDI_NI_LABPC_ISA is not set
# CONFIG_COMEDI_PCMAD is not set
CONFIG_COMEDI_PCMDA12=m
# CONFIG_COMEDI_PCMMIO is not set
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
# CONFIG_COMEDI_POC is not set
CONFIG_COMEDI_S526=m
CONFIG_COMEDI_PCI_DRIVERS=y
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
# CONFIG_COMEDI_ADDI_APCI_1500 is not set
# CONFIG_COMEDI_ADDI_APCI_1516 is not set
# CONFIG_COMEDI_ADDI_APCI_1564 is not set
# CONFIG_COMEDI_ADDI_APCI_16XX is not set
# CONFIG_COMEDI_ADDI_APCI_2032 is not set
CONFIG_COMEDI_ADDI_APCI_2200=m
# CONFIG_COMEDI_ADDI_APCI_3120 is not set
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
CONFIG_COMEDI_ADL_PCI7X3X=m
# CONFIG_COMEDI_ADL_PCI8164 is not set
# CONFIG_COMEDI_ADL_PCI9111 is not set
CONFIG_COMEDI_ADL_PCI9118=m
# CONFIG_COMEDI_ADV_PCI1710 is not set
CONFIG_COMEDI_ADV_PCI1723=m
# CONFIG_COMEDI_ADV_PCI1724 is not set
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
# CONFIG_COMEDI_AMPLC_PC236_PCI is not set
CONFIG_COMEDI_AMPLC_PC263_PCI=m
# CONFIG_COMEDI_AMPLC_PCI224 is not set
# CONFIG_COMEDI_AMPLC_PCI230 is not set
# CONFIG_COMEDI_CONTEC_PCI_DIO is not set
# CONFIG_COMEDI_DAS08_PCI is not set
# CONFIG_COMEDI_DT3000 is not set
# CONFIG_COMEDI_DYNA_PCI10XX is not set
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_MF6X4=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_DAQBOARD2000=m
# CONFIG_COMEDI_JR3_PCI is not set
# CONFIG_COMEDI_KE_COUNTER is not set
CONFIG_COMEDI_CB_PCIDAS64=m
# CONFIG_COMEDI_CB_PCIDAS is not set
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
CONFIG_COMEDI_NI_660X=m
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_LABPC_PCI=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
# CONFIG_COMEDI_S626 is not set
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_R8187SE=m
CONFIG_RTLLIB=m
# CONFIG_RTLLIB_CRYPTO_CCMP is not set
CONFIG_RTLLIB_CRYPTO_TKIP=m
# CONFIG_RTLLIB_CRYPTO_WEP is not set
CONFIG_RTL8192E=m
# CONFIG_R8821AE is not set
# CONFIG_VT6655 is not set
CONFIG_DX_SEP=y
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=m
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_SBE_2T3E3=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=m
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
# CONFIG_SW_SYNC_USER is not set
# CONFIG_ION is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_MTD_SPINAND_MT29F=m
CONFIG_MTD_SPINAND_ONDIEECC=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=m
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_RENESAS_TPU=m
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_TI_PIPE3 is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
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
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

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
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_KPROBE_EVENT is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
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
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_EVM_HMAC_ATTRS="fsuuid"
CONFIG_EVM_HMAC_XATTRS="security.selinux security.SMACK64 security.ima security.capability"
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

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
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--x4pBfXISqBoDm8sr--
