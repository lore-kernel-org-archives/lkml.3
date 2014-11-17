Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaKQGM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:12:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:37877 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaKQGM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:12:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,401,1413270000"; 
   d="scan'208";a="623405189"
Date: Mon, 17 Nov 2014 14:13:03 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [x86, PCI, MSI] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000002
Message-ID: <20141117061303.GC3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

https://github.com/jiangliu/linux.git irqdomain/p2v7
commit 515b463a5a4c2bac0593c6d88a475a32d65f4bcc ("x86, PCI, MSI: Use hierarchy irqdomain to manage MSI interrupts")


+------------------------------------------+------------+------------+
|                                          | dadb7cd295 | 515b463a5a |
+------------------------------------------+------------+------------+
| boot_successes                           | 6          | 1          |
| early-boot-hang                          | 1          |            |
| boot_failures                            | 0          | 4          |
| BUG:unable_to_handle_kernel              | 0          | 4          |
| Oops                                     | 0          | 4          |
| RIP:init_irq_alloc_info                  | 0          | 4          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 4          |
| backtrace:init_irq_alloc_info            | 0          | 4          |
| backtrace:vp_find_vqs                    | 0          | 4          |
| backtrace:init_vq                        | 0          | 4          |
| backtrace:init                           | 0          | 4          |
| backtrace:kernel_init_freeable           | 0          | 4          |
+------------------------------------------+------------+------------+


[   20.962013] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
[   20.964023] IP: [<ffffffff81074795>] init_irq_alloc_info+0x13/0x1b
[   20.964023] PGD 0 
[   20.964023] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   20.964023] Modules linked in:
[   20.964023] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g4ae16b6 #1457
[   20.964023] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   20.964023] task: ffff8801289c0010 ti: ffff8801289c4000 task.ti: ffff8801289c4000
[   20.964023] RIP: 0010:[<ffffffff81074795>]  [<ffffffff81074795>] init_irq_alloc_info+0x13/0x1b
[   20.964023] RSP: 0000:ffff8801289c7928  EFLAGS: 00010246
[   20.964023] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 000000000000000a
[   20.964023] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000002
[   20.964023] RBP: ffff8801289c7928 R08: 0000000000000008 R09: 0000000000000000
[   20.964023] R10: ffff8800b8399f80 R11: 0000000000000023 R12: ffff8800db055000
[   20.964023] R13: ffff8800d1ee8f98 R14: ffff880129cc3f80 R15: ffffffff83e36800
[   20.964023] FS:  0000000000000000(0000) GS:ffff88012a200000(0000) knlGS:0000000000000000
[   20.964023] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   20.964023] CR2: 0000000000000002 CR3: 0000000003e1a000 CR4: 00000000000006f0
[   20.964023] Stack:
[   20.964023]  ffff8801289c7958 ffffffff810770be ffff8801289c7980 0000000000000002
[   20.964023]  ffffffff83e36840 ffff8800db055098 ffff8801289c79d8 ffffffff8110fd29
[   20.964023]  0000000000000000 0000000000000000 ffff8800db055000 0000000000000011
[   20.964023] Call Trace:
[   20.964023]  [<ffffffff810770be>] pci_msi_prepare+0x2d/0x54
[   20.964023]  [<ffffffff8110fd29>] msi_domain_alloc_irqs+0x4a/0x162
[   20.964023]  [<ffffffff8285063a>] ? dmar_find_matched_drhd_unit+0xf7/0x10b
[   20.964023]  [<ffffffff8177e2ee>] pci_msi_domain_alloc_irqs+0x15/0x17
[   20.964023]  [<ffffffff8107727c>] native_setup_msi_irqs+0x61/0x6c
[   20.964023]  [<ffffffff8104f786>] arch_setup_msi_irqs+0xf/0x11
[   20.964023]  [<ffffffff8177d3e0>] pci_msi_setup_msi_irqs+0x45/0x4c
[   20.964023]  [<ffffffff8177daf7>] pci_enable_msix+0x1d8/0x2d0
[   20.964023]  [<ffffffff8177dc20>] pci_enable_msix_range+0x31/0x50
[   20.964023]  [<ffffffff8185dfa6>] vp_request_msix_vectors+0xb6/0x1f8
[   20.964023]  [<ffffffff8185e196>] vp_try_to_find_vqs+0xae/0x43e
[   20.964023]  [<ffffffff8172fbc5>] ? vsnprintf+0x374/0x3ad
[   20.964023]  [<ffffffff8185e558>] vp_find_vqs+0x32/0x8d
[   20.964023]  [<ffffffff81b416aa>] init_vq+0x14f/0x1f8
[   20.964023]  [<ffffffff81b41896>] virtblk_probe+0xf3/0x501
[   20.964023]  [<ffffffff81238727>] ? sysfs_do_create_link_sd+0x78/0xa8
[   20.964023]  [<ffffffff8185dba0>] ? vp_set_status+0x25/0x27
[   20.964023]  [<ffffffff8185c2ec>] virtio_dev_probe+0xbd/0x104
[   20.964023]  [<ffffffff81b09a19>] driver_probe_device+0xb0/0x1d7
[   20.964023]  [<ffffffff81b09bdf>] __driver_attach+0x62/0x85
[   20.964023]  [<ffffffff81b09b7d>] ? __device_attach+0x3d/0x3d
[   20.964023]  [<ffffffff81b08009>] bus_for_each_dev+0x6f/0x89
[   20.964023]  [<ffffffff81b0957d>] driver_attach+0x1e/0x20
[   20.964023]  [<ffffffff81b09229>] bus_add_driver+0x110/0x1cf
[   20.964023]  [<ffffffff84452673>] ? nbd_init+0x39c/0x39c
[   20.964023]  [<ffffffff81b0a235>] driver_register+0x8f/0xcc
[   20.964023]  [<ffffffff84452673>] ? nbd_init+0x39c/0x39c
[   20.964023]  [<ffffffff8185c5fd>] register_virtio_driver+0x2b/0x2d
[   20.964023]  [<ffffffff844526d0>] init+0x5d/0x8b
[   20.964023]  [<ffffffff8100216d>] do_one_initcall+0xee/0x17e
[   20.964023]  [<ffffffff843e60ef>] kernel_init_freeable+0x1ec/0x274
[   20.964023]  [<ffffffff82d3c238>] ? rest_init+0xcc/0xcc
[   20.964023]  [<ffffffff82d3c246>] kernel_init+0xe/0xdf
[   20.964023]  [<ffffffff82d719fc>] ret_from_fork+0x7c/0xb0
[   20.964023]  [<ffffffff82d3c238>] ? rest_init+0xcc/0xcc
[   20.964023] Code: eb 05 bb da ff ff ff 48 83 c4 28 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 89 fa b9 0a 00 00 00 31 c0 48 89 e5 <f3> ab 5d 48 89 72 08 c3 0f 1f 44 00 00 55 48 85 f6 b9 0a 00 00 
[   20.964023] RIP  [<ffffffff81074795>] init_irq_alloc_info+0x13/0x1b
[   20.964023]  RSP <ffff8801289c7928>
[   20.964023] CR2: 0000000000000002
[   20.964023] ---[ end trace 21200aca189fb8f5 ]---
[   20.964023] Kernel panic - not syncing: Fatal exception
[   20.964023] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)




	--yliu

--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g4ae16b6 (kbuild@xian) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #1457 SMP Sat Nov 15 11:36:50 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-4G-5=
/rand_boot-1-debian-x86_64.cgz-x86_64-allyesdebian-4ae16b66d616b62ecd0f2cd1=
fc5d040489bcd874-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-allyesdeb=
ian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/vmlinuz-3.18.0-rc4-g4ae16b6 kc=
onfig=3Dx86_64-allyesdebian commit=3D4ae16b66d616b62ecd0f2cd1fc5d040489bcd8=
74 branch=3Djiangliu/irqdomain/p2v7 root=3D/dev/ram0 max_uptime=3D3600 RESU=
LT_ROOT=3D/result/vm-kbuild-4G/boot/1/debian-x86_64.cgz/x86_64-allyesdebian=
/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/0 ip=3D::::vm-kbuild-4G-5::dhcp e=
arlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.=
rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3D=
panic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal rw
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
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x130000 max_arch_pfn =3D 0x400000000
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
[    0.000000] PAT not supported by CPU.
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdaa0-0x000fdaaf] mapped at =
[ffff8800000fdaa0]
[    0.000000]   mpc: fdab0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0576b000, 0x0576bfff] PGTABLE
[    0.000000] BRK [0x0576c000, 0x0576cfff] PGTABLE
[    0.000000] BRK [0x0576d000, 0x0576dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12fe00000-0x12fffffff]
[    0.000000]  [mem 0x12fe00000-0x12fffffff] page 4k
[    0.000000] BRK [0x0576e000, 0x0576efff] PGTABLE
[    0.000000] BRK [0x0576f000, 0x0576ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12c000000-0x12fdfffff]
[    0.000000]  [mem 0x12c000000-0x12fdfffff] page 4k
[    0.000000] BRK [0x05770000, 0x05770fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12bffffff]
[    0.000000]  [mem 0x100000000-0x12bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x79b9a000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD890 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x12f77b000-0x12f77ffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:2f773001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012aa0000=
0-ffff88012edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1114012
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 3072 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
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
[    0.000000] PERCPU: Embedded 481 pages/cpu @ffff88012a200000 s1929408 r8=
192 d32576 u2097152
[    0.000000] pcpu-alloc: s1929408 r8192 d32576 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12a20e480
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1096583
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-4G-5/rand_boot-1-debian-x86_64.cgz-x86_64-allyesdebian-4ae16b66d616b62ec=
d0f2cd1fc5d040489bcd874-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-al=
lyesdebian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/vmlinuz-3.18.0-rc4-g4ae=
16b6 kconfig=3Dx86_64-allyesdebian commit=3D4ae16b66d616b62ecd0f2cd1fc5d040=
489bcd874 branch=3Djiangliu/irqdomain/p2v7 root=3D/dev/ram0 max_uptime=3D36=
00 RESULT_ROOT=3D/result/vm-kbuild-4G/boot/1/debian-x86_64.cgz/x86_64-allye=
sdebian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/0 ip=3D::::vm-kbuild-4G-5:=
:dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rc=
update.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watc=
hdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3Dtty=
S0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4126844K/4456048K available (30178K kernel code, 414=
3K rwdata, 14896K rodata, 4476K init, 17344K bss, 329204K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:33024 nr_irqs:456 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g4ae16b6 (kbuild@xian) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #1457 SMP Sat Nov 15 11:36:50 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-4G-5=
/rand_boot-1-debian-x86_64.cgz-x86_64-allyesdebian-4ae16b66d616b62ecd0f2cd1=
fc5d040489bcd874-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-allyesdeb=
ian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/vmlinuz-3.18.0-rc4-g4ae16b6 kc=
onfig=3Dx86_64-allyesdebian commit=3D4ae16b66d616b62ecd0f2cd1fc5d040489bcd8=
74 branch=3Djiangliu/irqdomain/p2v7 root=3D/dev/ram0 max_uptime=3D3600 RESU=
LT_ROOT=3D/result/vm-kbuild-4G/boot/1/debian-x86_64.cgz/x86_64-allyesdebian=
/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/0 ip=3D::::vm-kbuild-4G-5::dhcp e=
arlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.=
rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3D=
panic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal rw
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
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x130000 max_arch_pfn =3D 0x400000000
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
[    0.000000] PAT not supported by CPU.
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdaa0-0x000fdaaf] mapped at =
[ffff8800000fdaa0]
[    0.000000]   mpc: fdab0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0576b000, 0x0576bfff] PGTABLE
[    0.000000] BRK [0x0576c000, 0x0576cfff] PGTABLE
[    0.000000] BRK [0x0576d000, 0x0576dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12fe00000-0x12fffffff]
[    0.000000]  [mem 0x12fe00000-0x12fffffff] page 4k
[    0.000000] BRK [0x0576e000, 0x0576efff] PGTABLE
[    0.000000] BRK [0x0576f000, 0x0576ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12c000000-0x12fdfffff]
[    0.000000]  [mem 0x12c000000-0x12fdfffff] page 4k
[    0.000000] BRK [0x05770000, 0x05770fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12bffffff]
[    0.000000]  [mem 0x100000000-0x12bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x79b9a000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD890 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x12f77b000-0x12f77ffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:2f773001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012aa0000=
0-ffff88012edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1114012
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 3072 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
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
[    0.000000] PERCPU: Embedded 481 pages/cpu @ffff88012a200000 s1929408 r8=
192 d32576 u2097152
[    0.000000] pcpu-alloc: s1929408 r8192 d32576 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12a20e480
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1096583
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-4G-5/rand_boot-1-debian-x86_64.cgz-x86_64-allyesdebian-4ae16b66d616b62ec=
d0f2cd1fc5d040489bcd874-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-al=
lyesdebian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/vmlinuz-3.18.0-rc4-g4ae=
16b6 kconfig=3Dx86_64-allyesdebian commit=3D4ae16b66d616b62ecd0f2cd1fc5d040=
489bcd874 branch=3Djiangliu/irqdomain/p2v7 root=3D/dev/ram0 max_uptime=3D36=
00 RESULT_ROOT=3D/result/vm-kbuild-4G/boot/1/debian-x86_64.cgz/x86_64-allye=
sdebian/4ae16b66d616b62ecd0f2cd1fc5d040489bcd874/0 ip=3D::::vm-kbuild-4G-5:=
:dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rc=
update.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watc=
hdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3Dtty=
S0,115200 console=3Dtty0 vga=3Dnormal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4126844K/4456048K available (30178K kernel code, 414=
3K rwdata, 14896K rodata, 4476K init, 17344K bss, 329204K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:33024 nr_irqs:456 16
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
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D10774112)
[    0.008008] pid_max: default: 32768 minimum: 301
[    0.009248] ACPI: Core revision 20140926
[    0.032000] ACPI: All ACPI Tables successfully acquired
[    0.033701] Security Framework initialized
[    0.034689] AppArmor: AppArmor disabled by boot time parameter
[    0.047300] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.063855] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.070915] Mount-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.072167] Mountpoint-cache hash table entries: 16384 (order: 5, 131072=
 bytes)
[    0.078787] Initializing cgroup subsys devices
[    0.080078] Initializing cgroup subsys freezer
[    0.081423] Initializing cgroup subsys net_cls
[    0.082646] Initializing cgroup subsys blkio
[    0.084416] mce: CPU supports 10 MCE banks
[    0.088077] numa_add_cpu cpu 0 node 0: mask now 0
[    0.089343] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.089343] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.092357] debug: unmapping init [mem 0xffffffff8466c000-0xffffffff8467=
8fff]
[    0.098104] ftrace: allocating 119064 entries in 466 pages
[    0.137010] Getting VERSION: 50014
[    0.138032] Getting VERSION: 50014
[    0.140013] Getting ID: 0
[    0.140830] Getting ID: ff000000
[    0.141876] Getting LVT0: 8700
[    0.142860] Getting LVT1: 8400
[    0.144095] enabled ExtINT on CPU#0
[    0.146306] ENABLING IO-APIC IRQs
[    0.148014] init IO_APIC IRQs
[    0.148971]  apic 0 pin 0 not connected
[    0.150076] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.152057] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.154199] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.156033] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.158156] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.160039] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.162110] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.164032] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.166073] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.168038] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.170202] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.172031] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.176035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.180056] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.182160] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.184034] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.186131]  apic 0 pin 16 not connected
[    0.188006]  apic 0 pin 17 not connected
[    0.189093]  apic 0 pin 18 not connected
[    0.190241]  apic 0 pin 19 not connected
[    0.191298]  apic 0 pin 20 not connected
[    0.192005]  apic 0 pin 21 not connected
[    0.193097]  apic 0 pin 22 not connected
[    0.194198]  apic 0 pin 23 not connected
[    0.195437] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.196007] smpboot: CPU0: Intel QEMU Virtual CPU version 1.7.1 (fam: 06=
, model: 06, stepping: 03)
[    0.200006] Using local APIC timer interrupts.
[    0.200006] calibrating APIC timer ...
[    0.204000] ... lapic delta =3D 6250217
[    0.204000] ... PM-Timer delta =3D 357967
[    0.204000] ... PM-Timer result ok
[    0.204000] ..... delta 6250217
[    0.204000] ..... mult: 268444776
[    0.204000] ..... calibration result: 4000138
[    0.204000] ..... CPU clock speed is 2693.2536 MHz.
[    0.204000] ..... host bus clock speed is 1000.0138 MHz.
[    0.204143] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.209607] Failed to access perfctr msr (MSR c1 is 0)
[    0.215464] Testing tracer nop: PASSED
[    0.218650] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.222083] x86: Booting SMP configuration:
[    0.224006] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 1:2f773041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.008000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.240151] KVM setup async PF for cpu 1
[    0.241833] kvm-stealtime: cpu 1, msr 12a40e480
[    0.008000]  #2
[    0.008000] kvm-clock: cpu 2, msr 1:2f773081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.008000] numa_add_cpu cpu 2 node 0: mask now 0-2
[    0.268111] KVM setup async PF for cpu 2
[    0.269398] kvm-stealtime: cpu 2, msr 12a60e480
[    0.008000]  #3
[    0.008000] kvm-clock: cpu 3, msr 1:2f7730c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3
[    0.008000] numa_add_cpu cpu 3 node 0: mask now 0-3
[    0.292092] KVM setup async PF for cpu 3
[    0.292138] x86: Booted up 1 node, 4 CPUs
[    0.292156] ----------------
[    0.292157] | NMI testsuite:
[    0.292157] --------------------
[    0.296000]   remote IPI:
[    0.296000] kvm-stealtime: cpu 3, msr 12a80e480
[    0.308063]   ok  |
[    0.308986]    local IPI:  ok  |
[    0.332029] --------------------
[    0.332990] Good, all   2 testcases passed! |
[    0.334121] ---------------------------------
[    0.335228] smpboot: Total of 4 processors activated (21548.22 BogoMIPS)
[    0.341087] devtmpfs: initialized
[    0.444044] Testing tracer function: PASSED
[    1.535513] Testing dynamic ftrace: PASSED
[    1.892647] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 119985) (2 2 4 0 120837) PASSED
[    3.066429] Testing dynamic ftrace ops #2: (1 0 1 119245 0) (1 1 2 11947=
8 0) (2 1 3 1 2247) (2 2 4 367 2611) PASSED
[    4.285865] Testing ftrace recursion: PASSED
[    4.390751] Testing ftrace recursion safe: PASSED
[    4.516008] Testing ftrace regs: PASSED
[    4.736059] Testing tracer irqsoff: PASSED
[    5.880125] Testing tracer wakeup:=20
[    6.880266] ftrace-test (33) used greatest stack depth: 14544 bytes left
[    6.940059] PASSED
[    7.000071] Testing tracer wakeup_rt: PASSED
[    8.204033] Testing tracer wakeup_dl: PASSED
[    9.420073] Testing tracer function_graph: PASSED
[   10.614605] xor: measuring software checksum speed
[   10.656019]    prefetch64-sse:   162.000 MB/sec
[   10.696037]    generic_sse:   166.000 MB/sec
[   10.697316] xor: using function: generic_sse (166.000 MB/sec)
[   10.698877] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[   10.702679] regulator-dummy: no parameters
[   10.706478] NET: Registered protocol family 16
[   10.724057] cpuidle: using governor ladder
[   10.736067] cpuidle: using governor menu
[   10.741047] ACPI: bus type PCI registered
[   10.742078] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   10.748350] dca service started, version 1.12.1
[   10.750115] PCI: Using configuration type 1 for base access
[   11.288035] raid6: sse2x1    2755 MB/s
[   11.356030] raid6: sse2x2    2838 MB/s
[   11.428017] raid6: sse2x4    2422 MB/s
[   11.431716] raid6: using algorithm sse2x2 (2838 MB/s)
[   11.432014] raid6: using intx1 recovery algorithm
[   11.436897] ACPI: Added _OSI(Module Device)
[   11.438808] ACPI: Added _OSI(Processor Device)
[   11.440019] ACPI: Added _OSI(3.0 _SCP Extensions)
[   11.444081] ACPI: Added _OSI(Processor Aggregator Device)
[   11.454151] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:15)
[   11.496364] ACPI: Interpreter enabled
[   11.498061] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[   11.500805] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[   11.504151] ACPI: (supports S0 S3 S4 S5)
[   11.505285] ACPI: Using IOAPIC for interrupt routing
[   11.507167] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   11.571471] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   11.572039] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[   11.573841] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   11.580173] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[   11.591968] acpiphp: Slot [3] registered
[   11.592399] acpiphp: Slot [4] registered
[   11.593860] acpiphp: Slot [5] registered
[   11.596335] acpiphp: Slot [6] registered
[   11.598137] acpiphp: Slot [7] registered
[   11.599551] acpiphp: Slot [8] registered
[   11.600324] acpiphp: Slot [9] registered
[   11.601698] acpiphp: Slot [10] registered
[   11.603093] acpiphp: Slot [11] registered
[   11.604294] acpiphp: Slot [12] registered
[   11.606019] acpiphp: Slot [13] registered
[   11.608355] acpiphp: Slot [14] registered
[   11.609831] acpiphp: Slot [15] registered
[   11.611851] acpiphp: Slot [24] registered
[   11.612343] acpiphp: Slot [25] registered
[   11.613937] acpiphp: Slot [26] registered
[   11.617497] acpiphp: Slot [27] registered
[   11.620115] acpiphp: Slot [28] registered
[   11.621599] acpiphp: Slot [29] registered
[   11.623085] acpiphp: Slot [30] registered
[   11.624386] acpiphp: Slot [31] registered
[   11.625554] PCI host bridge to bus 0000:00
[   11.626925] pci_bus 0000:00: root bus resource [bus 00-ff]
[   11.628024] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   11.629515] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   11.631141] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   11.632031] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[   11.633777] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   11.640107] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   11.644875] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   11.650614] pci 0000:00:01.1: reg 0x20: [io  0xc180-0xc18f]
[   11.653611] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[   11.655316] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[   11.656026] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[   11.660025] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[   11.665398] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   11.667631] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   11.668047] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   11.674301] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   11.680987] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   11.686344] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[   11.700975] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   11.708672] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   11.711724] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   11.716031] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   11.724722] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   11.730212] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   11.733566] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[   11.736748] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[   11.748571] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   11.751576] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[   11.753469] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[   11.765731] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   11.768740] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   11.771556] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[   11.782400] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   11.785544] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[   11.788021] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   11.799135] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   11.801574] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[   11.805473] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   11.816837] pci 0000:00:09.0: [8086:25ab] type 00 class 0x088000
[   11.819196] pci 0000:00:09.0: reg 0x10: [mem 0xfebf6000-0xfebf600f]
[   11.831787] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   11.833822] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   11.837306] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   11.840862] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   11.845472] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[   11.853181] ACPI: Enabled 16 GPEs in block 00 to 0F
[   11.858277] vgaarb: setting as boot device: PCI:0000:00:02.0
[   11.858521] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   11.860034] vgaarb: loaded
[   11.860034] vgaarb: bridge control possible 0000:00:02.0
[   11.865770] SCSI subsystem initialized
[   11.870184] libata version 3.00 loaded.
[   11.870184] ACPI: bus type USB registered
[   11.872859] usbcore: registered new interface driver usbfs
[   11.874471] usbcore: registered new interface driver hub
[   11.879132] usbcore: registered new device driver usb
[   11.879132] pps_core: LinuxPPS API ver. 1 registered
[   11.879570] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   11.884187] PTP clock support registered
[   11.886919] EDAC MC: Ver: 3.0.0
[   11.889925] wmi: Mapper loaded
[   11.892993] Advanced Linux Sound Architecture Driver Initialized.
[   11.894591] PCI: Using ACPI for IRQ routing
[   11.894591] PCI: pci_cache_line_size set to 64 bytes
[   11.894591] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   11.894679] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[   11.900237] NET: Registered protocol family 23
[   11.901564] Bluetooth: Core ver 2.19
[   11.902850] NET: Registered protocol family 31
[   11.903835] Bluetooth: HCI device and connection manager initialized
[   11.908136] Bluetooth: HCI socket layer initialized
[   11.909577] Bluetooth: L2CAP socket layer initialized
[   11.912245] Bluetooth: SCO socket layer initialized
[   11.913587] NET: Registered protocol family 8
[   11.914737] NET: Registered protocol family 20
[   11.917402] cfg80211: Calling CRDA to update world regulatory domain
[   11.919287] nfc: nfc_init: NFC Core ver 0.1
[   11.919341] NET: Registered protocol family 39
[   11.927123] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[   11.927831] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   11.932883] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   11.940385] Switched to clocksource kvm-clock
[   12.920986] FS-Cache: Loaded
[   12.922887] CacheFiles: Loaded
[   12.924095] pnp: PnP ACPI init
[   12.925639] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[   12.928289] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   12.930216] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[   12.932780] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   12.934475] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[   12.937069] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   12.939042] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[   12.950175] pnp 00:03: [dma 2]
[   12.951905] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   12.954008] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[   12.956788] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   12.958709] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[   12.961420] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   12.964012] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:15)
[   12.967168] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[   12.981886] pnp: PnP ACPI: found 7 devices
[   13.094688] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   13.096193] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   13.097637] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   13.099189] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[   13.111915] NET: Registered protocol family 2
[   13.117333] TCP established hash table entries: 65536 (order: 7, 524288 =
bytes)
[   13.135645] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[   13.170080] TCP: Hash tables configured (established 65536 bind 65536)
[   13.172161] TCP: reno registered
[   13.174058] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[   13.178335] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[   13.183774] NET: Registered protocol family 1
[   13.189757] RPC: Registered named UNIX socket transport module.
[   13.191252] RPC: Registered udp transport module.
[   13.192501] RPC: Registered tcp transport module.
[   13.193737] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.195391] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   13.196962] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   13.198444] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   13.200949] pci 0000:00:02.0: Video device with shadowed ROM
[   13.202534] PCI: CLS 0 bytes, default 64
[   13.204758] Trying to unpack rootfs image as initramfs...
[   19.646049] debug: unmapping init [mem 0xffff880079b9a000-0xffff88007fff=
ffff]
[   19.650392] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   19.651759] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[   19.657165] kvm: no hardware support
[   19.658107] has_svm: not amd
[   19.658885] kvm: no hardware support
[   19.663908] Machine check injector initialized
[   19.665778] microcode: CPU0 sig=3D0x663, pf=3D0x1, revision=3D0x1
[   19.667155] microcode: CPU1 sig=3D0x663, pf=3D0x1, revision=3D0x1
[   19.668537] microcode: CPU2 sig=3D0x663, pf=3D0x1, revision=3D0x1
[   19.670274] microcode: CPU3 sig=3D0x663, pf=3D0x1, revision=3D0x1
[   19.672793] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   19.687504] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[   19.696668] futex hash table entries: 1024 (order: 5, 131072 bytes)
[   19.698673] audit: initializing netlink subsys (disabled)
[   19.700122] audit: type=3D2000 audit(1416023737.931:1): initialized
[   19.701998] Kprobe smoke test: started
[   20.020224] Kprobe smoke test: passed successfully
[   20.025139] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   20.029465] VFS: Disk quotas dquot_6.5.2
[   20.030776] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   20.036712] DLM installed
[   20.041208] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   20.050253] FS-Cache: Netfs 'nfs' registered for caching
[   20.059642] NFS: Registering the id_resolver key type
[   20.062319] Key type id_resolver registered
[   20.063579] Key type id_legacy registered
[   20.064853] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   20.066579] NFS: objlayout_init: Registered OSD pNFS Layout Driver
[   20.068235] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   20.074452] FS-Cache: Netfs 'cifs' registered for caching
[   20.077202] Key type cifs.spnego registered
[   20.078324] Key type cifs.idmap registered
[   20.079969] ntfs: driver 2.1.31 [Flags: R/W].
[   20.081807] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[   20.086971] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[   20.088457] QNX4 filesystem 0.2.3 registered.
[   20.090671] fuse init (API version 7.23)
[   20.094513] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[   20.133313] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[   20.144421] 9p: Installing v9fs 9p2000 file system support
[   20.145940] FS-Cache: Netfs '9p' registered for caching
[   20.148490] NILFS version 2 loaded
[   20.149680] befs: version: 0.9.3
[   20.156948] ocfs2: Registered cluster interface o2cb
[   20.159034] ocfs2: Registered cluster interface user
[   20.161982] OCFS2 User DLM kernel interface loaded
[   20.185589] gfs2: GFS2 installed
[   20.187295] ceph: loaded (mds proto 32)
[   20.188512] msgmni has been set to 8060
[   20.195942] cryptomgr_test (95) used greatest stack depth: 14512 bytes l=
eft
[   20.208465] NET: Registered protocol family 38
[   20.209739] async_tx: api initialized (async)
[   20.211457] bounce: pool size: 64 pages
[   20.212927] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   20.214963] io scheduler noop registered
[   20.216848] io scheduler deadline registered
[   20.218440] io scheduler cfq registered (default)
[   20.219628] start plist test
[   20.223447] end plist test
[   20.228783] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   20.231039] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   20.233581] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   20.235588] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[   20.237603] cpcihp_generic: not configured, disabling.
[   20.239377] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   20.251084] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[   20.260277] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   20.265000] vmlfb: initializing
[   20.266328] Could not find Carillo Ranch MCH device.
[   20.268911] no IO addresses supplied
[   20.271333] hgafb: HGA card not detected.
[   20.272514] hgafb: probe of hgafb.0 failed with error -22
[   20.275426] usbcore: registered new interface driver udlfb
[   20.279956] kworker/u8:0 (136) used greatest stack depth: 13312 bytes le=
ft
[   20.280098] uvesafb: failed to execute /sbin/v86d
[   20.280099] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[   20.280110] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[   20.280120] uvesafb: vbe_init() failed with -22
[   20.280154] uvesafb: probe of uvesafb.0 failed with error -22
[   20.280583] intel_idle: does not run on family 6 model 6
[   20.280733] ipmi message handler version 39.2
[   20.280963] ipmi device interface
[   20.281293] IPMI System Interface driver.
[   20.282189] ipmi_si: Unable to find any System Interface(s)
[   20.282220] IPMI Watchdog: driver initialized
[   20.282224] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   20.285493] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   20.285573] ACPI: Power Button [PWRF]
[   20.292575] GHES: HEST is not enabled!
[   20.292579] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   20.317306] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   20.317340] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[   20.325579] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   20.325603] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[   20.333931] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   20.349150] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   20.363538] xenfs: not registering filesystem on non-xen platform
[   20.367203] HDLC line discipline maxframe=3D4096
[   20.368575] N_HDLC line discipline registered.
[   20.370054] r3964: Philips r3964 Driver $Revision: 1.10 $
[   20.371547] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   20.424583] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[   20.437733] Cyclades driver 2.6
[   20.439545] MOXA Intellio family driver version 6.0k
[   20.441373] MOXA Smartio/Industio family driver version 2.0.5
[   20.443219] Initializing Nozomi driver 2.1d
[   20.444990] RocketPort device driver module, version 2.09, 12-June-2003
[   20.446699] No rocketport ports found; unloading driver
[   20.448084] SyncLink GT
[   20.448981] SyncLink GT, tty major#245
[   20.450443] SyncLink GT no devices found
[   20.451542] SyncLink MultiPort driver $Revision: 4.38 $
[   20.538800] SyncLink MultiPort driver $Revision: 4.38 $, tty major#244
[   20.540716] SyncLink serial driver $Revision: 4.38 $
[   20.628653] SyncLink serial driver $Revision: 4.38 $, tty major#243
[   20.638094] modprobe (139) used greatest stack depth: 13144 bytes left
[   20.638321] lp: driver loaded but no devices found
[   20.638335] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   20.638354] ac.o: No PCI boards found.
[   20.638355] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   20.640824] Non-volatile memory driver v1.3
[   20.647783] ppdev: user-space parallel port driver
[   20.649130] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   20.650611] smapi::smapi_init, ERROR invalid usSmapiID
[   20.651849] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   20.654211] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   20.656320] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   20.656399] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[   20.659285] Linux agpgart interface v0.103
[   20.662403] SyncLink PC Card driver $Revision: 4.34 $, tty major#241
[   20.664768] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   20.667898] [drm] Initialized drm 1.1.0 20060810
[   20.670158] [drm] radeon kernel modesetting enabled.
[   20.674303] parport_pc 00:04: reported by Plug and Play ACPI
[   20.676192] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   20.778286] lp0: using parport0 (interrupt-driven).
[   20.787666] Floppy drive(s): fd0 is 1.44M
[   20.812171] FDC 0 is a S82078B
[   20.859900] brd: module loaded
[   20.888862] loop: module loaded
[   20.890088] HP CISS Driver (v 3.6.26)
[   20.895481] MM: desc_per_page =3D 128
[   20.901608] nbd: registered device at major 43
[   20.962013] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000002
[   20.964023] IP: [<ffffffff81074795>] init_irq_alloc_info+0x13/0x1b
[   20.964023] PGD 0=20
[   20.964023] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   20.964023] Modules linked in:
[   20.964023] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g4ae16b=
6 #1457
[   20.964023] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   20.964023] task: ffff8801289c0010 ti: ffff8801289c4000 task.ti: ffff880=
1289c4000
[   20.964023] RIP: 0010:[<ffffffff81074795>]  [<ffffffff81074795>] init_ir=
q_alloc_info+0x13/0x1b
[   20.964023] RSP: 0000:ffff8801289c7928  EFLAGS: 00010246
[   20.964023] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000000000=
0000a
[   20.964023] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000=
00002
[   20.964023] RBP: ffff8801289c7928 R08: 0000000000000008 R09: 00000000000=
00000
[   20.964023] R10: ffff8800b8399f80 R11: 0000000000000023 R12: ffff8800db0=
55000
[   20.964023] R13: ffff8800d1ee8f98 R14: ffff880129cc3f80 R15: ffffffff83e=
36800
[   20.964023] FS:  0000000000000000(0000) GS:ffff88012a200000(0000) knlGS:=
0000000000000000
[   20.964023] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   20.964023] CR2: 0000000000000002 CR3: 0000000003e1a000 CR4: 00000000000=
006f0
[   20.964023] Stack:
[   20.964023]  ffff8801289c7958 ffffffff810770be ffff8801289c7980 00000000=
00000002
[   20.964023]  ffffffff83e36840 ffff8800db055098 ffff8801289c79d8 ffffffff=
8110fd29
[   20.964023]  0000000000000000 0000000000000000 ffff8800db055000 00000000=
00000011
[   20.964023] Call Trace:
[   20.964023]  [<ffffffff810770be>] pci_msi_prepare+0x2d/0x54
[   20.964023]  [<ffffffff8110fd29>] msi_domain_alloc_irqs+0x4a/0x162
[   20.964023]  [<ffffffff8285063a>] ? dmar_find_matched_drhd_unit+0xf7/0x1=
0b
[   20.964023]  [<ffffffff8177e2ee>] pci_msi_domain_alloc_irqs+0x15/0x17
[   20.964023]  [<ffffffff8107727c>] native_setup_msi_irqs+0x61/0x6c
[   20.964023]  [<ffffffff8104f786>] arch_setup_msi_irqs+0xf/0x11
[   20.964023]  [<ffffffff8177d3e0>] pci_msi_setup_msi_irqs+0x45/0x4c
[   20.964023]  [<ffffffff8177daf7>] pci_enable_msix+0x1d8/0x2d0
[   20.964023]  [<ffffffff8177dc20>] pci_enable_msix_range+0x31/0x50
[   20.964023]  [<ffffffff8185dfa6>] vp_request_msix_vectors+0xb6/0x1f8
[   20.964023]  [<ffffffff8185e196>] vp_try_to_find_vqs+0xae/0x43e
[   20.964023]  [<ffffffff8172fbc5>] ? vsnprintf+0x374/0x3ad
[   20.964023]  [<ffffffff8185e558>] vp_find_vqs+0x32/0x8d
[   20.964023]  [<ffffffff81b416aa>] init_vq+0x14f/0x1f8
[   20.964023]  [<ffffffff81b41896>] virtblk_probe+0xf3/0x501
[   20.964023]  [<ffffffff81238727>] ? sysfs_do_create_link_sd+0x78/0xa8
[   20.964023]  [<ffffffff8185dba0>] ? vp_set_status+0x25/0x27
[   20.964023]  [<ffffffff8185c2ec>] virtio_dev_probe+0xbd/0x104
[   20.964023]  [<ffffffff81b09a19>] driver_probe_device+0xb0/0x1d7
[   20.964023]  [<ffffffff81b09bdf>] __driver_attach+0x62/0x85
[   20.964023]  [<ffffffff81b09b7d>] ? __device_attach+0x3d/0x3d
[   20.964023]  [<ffffffff81b08009>] bus_for_each_dev+0x6f/0x89
[   20.964023]  [<ffffffff81b0957d>] driver_attach+0x1e/0x20
[   20.964023]  [<ffffffff81b09229>] bus_add_driver+0x110/0x1cf
[   20.964023]  [<ffffffff84452673>] ? nbd_init+0x39c/0x39c
[   20.964023]  [<ffffffff81b0a235>] driver_register+0x8f/0xcc
[   20.964023]  [<ffffffff84452673>] ? nbd_init+0x39c/0x39c
[   20.964023]  [<ffffffff8185c5fd>] register_virtio_driver+0x2b/0x2d
[   20.964023]  [<ffffffff844526d0>] init+0x5d/0x8b
[   20.964023]  [<ffffffff8100216d>] do_one_initcall+0xee/0x17e
[   20.964023]  [<ffffffff843e60ef>] kernel_init_freeable+0x1ec/0x274
[   20.964023]  [<ffffffff82d3c238>] ? rest_init+0xcc/0xcc
[   20.964023]  [<ffffffff82d3c246>] kernel_init+0xe/0xdf
[   20.964023]  [<ffffffff82d719fc>] ret_from_fork+0x7c/0xb0
[   20.964023]  [<ffffffff82d3c238>] ? rest_init+0xcc/0xcc
[   20.964023] Code: eb 05 bb da ff ff ff 48 83 c4 28 89 d8 5b 41 5c 41 5d =
41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 89 fa b9 0a 00 00 00 31 c0 48 89 e5 =
<f3> ab 5d 48 89 72 08 c3 0f 1f 44 00 00 55 48 85 f6 b9 0a 00 00=20
[   20.964023] RIP  [<ffffffff81074795>] init_irq_alloc_info+0x13/0x1b
[   20.964023]  RSP <ffff8801289c7928>
[   20.964023] CR2: 0000000000000002
[   20.964023] ---[ end trace 21200aca189fb8f5 ]---
[   20.964023] Kernel panic - not syncing: Fatal exception
[   20.964023] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 45
qemu-system-x86_64 -enable-kvm -kernel /kernel/x86_64-allyesdebian/4ae16b66=
d616b62ecd0f2cd1fc5d040489bcd874/vmlinuz-3.18.0-rc4-g4ae16b6 -append 'user=
=3Dlkp job=3D/lkp/scheduled/vm-kbuild-4G-5/rand_boot-1-debian-x86_64.cgz-x8=
6_64-allyesdebian-4ae16b66d616b62ecd0f2cd1fc5d040489bcd874-1.yaml ARCH=3Dx8=
6_64 BOOT_IMAGE=3D/kernel/x86_64-allyesdebian/4ae16b66d616b62ecd0f2cd1fc5d0=
40489bcd874/vmlinuz-3.18.0-rc4-g4ae16b6 kconfig=3Dx86_64-allyesdebian commi=
t=3D4ae16b66d616b62ecd0f2cd1fc5d040489bcd874 branch=3Djiangliu/irqdomain/p2=
v7 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-4G/bo=
ot/1/debian-x86_64.cgz/x86_64-allyesdebian/4ae16b66d616b62ecd0f2cd1fc5d0404=
89bcd874/0 ip=3D::::vm-kbuild-4G-5::dhcp earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
rw'  -initrd /fs/sdc1/initrd-vm-kbuild-4G-5 -m 4352 -smp 4 -net nic,vlan=3D=
1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6=
300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdc1/disk0-vm-kbuild-4G-5,me=
dia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk1-vm-kbuild-4G-5,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/sdc1/disk2-vm-kbuild-4G-5,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/sdc1/disk3-vm-kbuild-4G-5,media=3Ddisk,if=3Dvi=
rtio -drive file=3D/fs/sdc1/disk4-vm-kbuild-4G-5,media=3Ddisk,if=3Dvirtio -=
pidfile /dev/shm/kboot/pid-vm-kbuild-4G-5 -serial file:/dev/shm/kboot/seria=
l-vm-kbuild-4G-5 -daemonize -display none -monitor null=20

--f0KYrhQ4vYSV2aJu--
