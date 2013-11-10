Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab3KJJkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:40:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:18881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3KJJkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,671,1378882800"; 
   d="log'?scan'208";a="425055478"
Date: Sun, 10 Nov 2013 17:40:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Mario <jmario@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: [kallsyms] general protection fault: 0000 [#1] PREEMPT
 DEBUG_PAGEALLOC
Message-ID: <20131110094005.GA21916@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joe,

FYI. Here is another bisect result.

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

+--------------------------------------------------+----+
|                                                  |    |
+--------------------------------------------------+----+
| has_kernel_error_warning                         | 19 |
| general_protection_fault:PREEMPT_DEBUG_PAGEALLOC | 19 |
| Kernel_panic-not_syncing:Fatal_exception         | 19 |
+--------------------------------------------------+----+

[    1.163196] AVX instructions are not detected.
[    1.164640] AVX instructions are not detected.
[    1.168708] Initializing RT-Tester: OK
[    1.202823] general protection fault: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    1.204010] Modules linked in:
[    1.204010] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-02415-g65a52a4e #73
[    1.204010] task: ffff88000ec64040 ti: ffff88000ec66000 task.ti: ffff88000ec66000
[    1.204010] RIP: 0010:[<ffffffff81941e91>]  [<ffffffff81941e91>] kernel_init_freeable+0x140/0x1d3
[    1.204010] RSP: 0000:ffff88000ec67f18  EFLAGS: 00010287
[    1.204010] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000000
[    1.204010] RDX: 0000000000000000 RSI: ffffffff81888590 RDI: ffffffff8188b5d8
[    1.204010] RBP: ffff88000ec67f38 R08: 0000000000000000 R09: 0000000000000000
[    1.204010] R10: 0000000000000000 R11: 0000000000000000 R12: ff00ffff819e2a98
[    1.204010] R13: 000000000000017c R14: 0000000000000000 R15: 0000000000000000
[    1.204010] FS:  0000000000000000(0000) GS:ffffffff8185b000(0000) knlGS:0000000000000000
[    1.204010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.204010] CR2: 0000000000000000 CR3: 000000000184b000 CR4: 00000000000006b0
[    1.204010] Stack:
[    1.204010]  ffffffff819416a3 ffffffff814f1d68 0000000000000000 0000000000000000
[    1.204010]  ffff88000ec67f48 ffffffff814f1d71 0000000000000000 ffffffff81505b8a
[    1.204010]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.204010] Call Trace:
[    1.204010]  [<ffffffff819416a3>] ? do_early_param+0x88/0x88
[    1.204010]  [<ffffffff814f1d68>] ? rest_init+0xbc/0xbc
[    1.204010]  [<ffffffff814f1d71>] kernel_init+0x9/0xcc
[    1.204010]  [<ffffffff81505b8a>] ret_from_fork+0x7a/0xb0
[    1.204010]  [<ffffffff814f1d68>] ? rest_init+0xbc/0xbc
[    1.204010] Code: 81 41 89 d9 41 89 d8 44 89 e9 48 c7 c2 f8 74 83 81 48 89 c6 e8 9f 95 73 ff 4c 8b 24 dd 60 08 9c 81 4c 3b 24 dd 68 08 9c 81 73 0f <49> 8b 3c 24 49 83 c4 08 e8 44 e3 6b ff eb e7 48 ff c3 eb 96 e8 
[    1.204010] RIP  [<ffffffff81941e91>] kernel_init_freeable+0x140/0x1d3
[    1.204010]  RSP <ffff88000ec67f18>
[    1.258402] ---[ end trace 034c5e9620a58ceb ]---
[    1.259754] Kernel panic - not syncing: Fatal exception

git bisect start 65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good ba275241030cfe87b87d6592345c7e7ebd9b6fba  # 11:49     20+      0  virtio-net: coalesce rx frags when possible during rx
git bisect good 24d70dca6f3c9261aa9cf85252b02e4044ea0822  # 11:57     20+      0  Merge remote-tracking branch 'drm-upstream/drm-next' into drm-intel-nightly
git bisect good 1e7d30355d91c70e2557daf3dac633255202d2df  # 12:15     20+      0  rt2x00: rt2800pci: split rt2800pci_enable_radio function
git bisect  bad eed5e6cb394511c3324b88a25da8cef7938b3e30  # 12:28      0-      4  Merge 'bluetooth/master' into devel-xian-x86_64-201311081746
git bisect good 7751ef1b3184ecfaebc5e5a8981407814ce0be0b  # 12:39     20+      0  Bluetooth: Check for flag instead of features in update_scan_rsp_data()
git bisect  bad 37d1c5fc2dd80db8c084e5c3d324cb92dd6e5a94  # 12:44      0-      2  Merge branches 'kbuild/kbuild' and 'kbuild/misc' into kbuild/for-next
git bisect good 32f1b13973cc51c7ee96bf10343391f16a2de761  # 12:52     20+      0  Merge v3.12-rc1 into kbuild/for-next
git bisect good e125096e733e966e055ee6033169f68233f9bf9c  # 12:59     20+      0  Merge branch 'yem/kconfig-for-next' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig
git bisect good 86dd0b57e56d1db84a18761819aab80f2e6734f5  # 13:25     20+      0  Merge branches 'kbuild/kbuild' and 'kbuild/misc' into kbuild/for-next
git bisect  bad 21cf6e584ce35b79374581e6344dd7c74f8b4a2b  # 13:28      0-      1  kbuild, bloat-o-meter: fix static detection
git bisect  bad f3462aa952cfc8f4b095103cb9b3d306dd216558  # 13:30      0-      1  Kbuild: Handle longer symbols in kallsyms.c
git bisect  bad eea0e9cbb9e65cd553d302a4aefd4c7b70d9fd90  # 13:36      0-      1  kbuild: Increase kallsyms max symbol length
git bisect good 80970472179a45609c0b11b80619bc8c32b15f77  # 14:25     60+      0  Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
git bisect  bad 65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8  # 14:25      0-     19  Merge 'drm-intel/drm-intel-nightly' into devel-xian-x86_64-201311081746
git bisect good 4364aab74a616ea2c94951bcff0290db74f49fac  # 14:51     60+      0  Revert "kbuild: Increase kallsyms max symbol length"
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 15:07     60+      0  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good bad570d77024cba808126d68a2072f6f8ce64c27  # 15:30     60+     60  Add linux-next specific files for 20131108

Thanks,
Fengguang

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-tt02-9:20131108090107:x86_64-randconfig-x7-1108:3.12.0-02415-g65a52a4e:73"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-02415-g65a52a4e (kbuild@xian) (gcc vers=
ion 4.8.1 (Debian 4.8.1-8) ) #73 PREEMPT Fri Nov 8 18:06:56 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x7-1108/devel-xian-x86_64-201311=
081746/.vmlinuz-65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8-20131108181028-8-l=
kp-tt02 branch=3Dlinux-devel/devel-xian-x86_64-201311081746 BOOT_IMAGE=3D/k=
ernel/x86_64-randconfig-x7-1108/65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8/vm=
linuz-3.12.0-02415-g65a52a4e
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x022bb000, 0x022bbfff] PGTABLE
[    0.000000] BRK [0x022bc000, 0x022bcfff] PGTABLE
[    0.000000] BRK [0x022bd000, 0x022bdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x022be000, 0x022befff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x022bf000, 0x022bffff] PGTABLE
[    0.000000] BRK [0x022c0000, 0x022c0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128280(97%)
[    0.000000] RAMDISK: [mem 0x0fd0b000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1869100
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x7-1108/devel-xian-x86_64-=
201311081746/.vmlinuz-65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8-201311081810=
28-8-lkp-tt02 branch=3Dlinux-devel/devel-xian-x86_64-201311081746 BOOT_IMAG=
E=3D/kernel/x86_64-randconfig-x7-1108/65a52a4ea1f334e61fe0178fc2a87c3f3e5c6=
2a8/vmlinuz-3.12.0-02415-g65a52a4e
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 226244K/261744K available (5156K kernel code, 1040K =
rwdata, 3260K rodata, 704K init, 8996K bss, 35500K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 5823 kB
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
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.914 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4787.82 Bogo=
MIPS (lpj=3D9575656)
[    0.008618] pid_max: default: 32768 minimum: 301
[    0.012618] Mount-cache hash table entries: 256
[    0.014832] Initializing cgroup subsys memory
[    0.016284] Initializing cgroup subsys freezer
[    0.017341] Initializing cgroup subsys perf_event
[    0.018372] Initializing cgroup subsys hugetlb
[    0.020137] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020137] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020137] tlb_flushall_shift: 6
[    0.024007] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.028223] ACPI: Core revision 20130725
[    0.032203] ACPI: All ACPI Tables successfully acquired
[    0.034351] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.038019] ftrace: Allocated trace_printk buffers
[    0.055238] Getting VERSION: 50014
[    0.056017] Getting VERSION: 50014
[    0.056784] Getting ID: 0
[    0.057396] Getting ID: ff000000
[    0.058122] Getting LVT0: 8700
[    0.058778] Getting LVT1: 8400
[    0.059554] enabled ExtINT on CPU#0
[    0.061449] ENABLING IO-APIC IRQs
[    0.062193] init IO_APIC IRQs
[    0.062868]  apic 0 pin 0 not connected
[    0.064021] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.065738] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.067483] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.068028] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.069739] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.072028] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.073746] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.076029] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.077748] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.080029] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.081786] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.083543] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.084029] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.085782] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.088029] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.089794]  apic 0 pin 16 not connected
[    0.090647]  apic 0 pin 17 not connected
[    0.092005]  apic 0 pin 18 not connected
[    0.092852]  apic 0 pin 19 not connected
[    0.093710]  apic 0 pin 20 not connected
[    0.094538]  apic 0 pin 21 not connected
[    0.095398]  apic 0 pin 22 not connected
[    0.096004]  apic 0 pin 23 not connected
[    0.097039] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.098803] Using local APIC timer interrupts.
[    0.098803] calibrating APIC timer ...
[    0.104000] ... lapic delta =3D 7249761
[    0.104000] ... PM-Timer delta =3D 415214
[    0.104000] APIC calibration not consistent with PM-Timer: 115ms instead=
 of 100ms
[    0.104000] APIC delta adjusted to PM-Timer: 6249984 (7249761)
[    0.104000] TSC delta adjusted to PM-Timer: 239390673 (277684728)
[    0.104000] ..... delta 6249984
[    0.104000] ..... mult: 268434768
[    0.104000] ..... calibration result: 3999989
[    0.104000] ..... CPU clock speed is 2393.3626 MHz.
[    0.104000] ..... host bus clock speed is 999.3989 MHz.
[    0.105153] devtmpfs: initialized
[    0.111412] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.112016] pinctrl core: initialized pinctrl subsystem
[    0.116211] NET: Registered protocol family 16
[    0.118539] cpuidle: using governor ladder
[    0.119756] cpuidle: using governor menu
[    0.120528] ACPI: bus type PCI registered
[    0.124155] PCI: Using configuration type 1 for base access
[    0.138962] bio: create slab <bio-0> at 0
[    0.142140] ACPI: Added _OSI(Module Device)
[    0.144010] ACPI: Added _OSI(Processor Device)
[    0.145313] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146709] ACPI: Added _OSI(Processor Aggregator Device)
[    0.149842] ACPI: EC: Look up EC in DSDT
[    0.159323] ACPI: Interpreter enabled
[    0.160009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.165464] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.168039] ACPI: (supports S0 S3 S4 S5)
[    0.169101] ACPI: Using IOAPIC for interrupt routing
[    0.170478] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.191874] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.192017] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.196005] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.198730] PCI host bridge to bus 0000:00
[    0.200070] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.201688] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.204006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.205824] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.208007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.212159] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.216903] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.221143] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.225638] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.229055] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.236728] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.238885] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.240671] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.244676] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.248637] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.257326] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.260148] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.262938] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.265008] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.272539] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.275011] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.276602] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.283439] pci_bus 0000:00: on NUMA node 0
[    0.285141] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.288128] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.290260] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.292376] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.294376] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.297212] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.298777] ACPI: \_SB_.PCI0: notify handler is installed
[    0.300090] Found 1 acpi root devices
[    0.301692] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.304006] vgaarb: loaded
[    0.304835] vgaarb: bridge control possible 0000:00:02.0
[    0.308690] pps_core: LinuxPPS API ver. 1 registered
[    0.310227] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.312035] PTP clock support registered
[    0.313423] wmi: Mapper loaded
[    0.314473] Advanced Linux Sound Architecture Driver Initialized.
[    0.316064] PCI: Using ACPI for IRQ routing
[    0.317311] PCI: pci_cache_line_size set to 64 bytes
[    0.320229] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.321986] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.324751] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.327140] Switched to clocksource kvm-clock
[    0.438811] pnp: PnP ACPI init
[    0.439819] ACPI: bus type PNP registered
[    0.441170] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.443573] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.445629] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.448058] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.449982] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.452479] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.454478] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.456851] pnp 00:03: [dma 2]
[    0.457835] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.459866] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.462300] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.464353] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.466730] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.469162] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.471383] pnp: PnP ACPI: found 7 devices
[    0.472626] ACPI: bus type PNP unregistered
[    0.479645] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.481408] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.483053] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.484902] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.486796] NET: Registered protocol family 1
[    0.488167] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.489906] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.491649] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.493540] pci 0000:00:02.0: Boot video device
[    0.494937] PCI: CLS 0 bytes, default 64
[    0.496609] Unpacking initramfs...
[    0.987555] debug: unmapping init [mem 0xffff88000fd0b000-0xffff88000ffe=
ffff]
[    1.147593] DMA-API: preallocated 65536 debug entries
[    1.149213] DMA-API: debugging enabled by kernel config
[    1.152193] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.155205] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.158104] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.159938] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.161834] AVX instructions are not detected.
[    1.163196] AVX instructions are not detected.
[    1.164640] AVX instructions are not detected.
[    1.168708] Initializing RT-Tester: OK
[    1.202823] general protection fault: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    1.204010] Modules linked in:
[    1.204010] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-02415-g65a52a=
4e #73
[    1.204010] task: ffff88000ec64040 ti: ffff88000ec66000 task.ti: ffff880=
00ec66000
[    1.204010] RIP: 0010:[<ffffffff81941e91>]  [<ffffffff81941e91>] kernel_=
init_freeable+0x140/0x1d3
[    1.204010] RSP: 0000:ffff88000ec67f18  EFLAGS: 00010287
[    1.204010] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 00000000000=
00000
[    1.204010] RDX: 0000000000000000 RSI: ffffffff81888590 RDI: ffffffff818=
8b5d8
[    1.204010] RBP: ffff88000ec67f38 R08: 0000000000000000 R09: 00000000000=
00000
[    1.204010] R10: 0000000000000000 R11: 0000000000000000 R12: ff00ffff819=
e2a98
[    1.204010] R13: 000000000000017c R14: 0000000000000000 R15: 00000000000=
00000
[    1.204010] FS:  0000000000000000(0000) GS:ffffffff8185b000(0000) knlGS:=
0000000000000000
[    1.204010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.204010] CR2: 0000000000000000 CR3: 000000000184b000 CR4: 00000000000=
006b0
[    1.204010] Stack:
[    1.204010]  ffffffff819416a3 ffffffff814f1d68 0000000000000000 00000000=
00000000
[    1.204010]  ffff88000ec67f48 ffffffff814f1d71 0000000000000000 ffffffff=
81505b8a
[    1.204010]  0000000000000000 0000000000000000 0000000000000000 00000000=
00000000
[    1.204010] Call Trace:
[    1.204010]  [<ffffffff819416a3>] ? do_early_param+0x88/0x88
[    1.204010]  [<ffffffff814f1d68>] ? rest_init+0xbc/0xbc
[    1.204010]  [<ffffffff814f1d71>] kernel_init+0x9/0xcc
[    1.204010]  [<ffffffff81505b8a>] ret_from_fork+0x7a/0xb0
[    1.204010]  [<ffffffff814f1d68>] ? rest_init+0xbc/0xbc
[    1.204010] Code: 81 41 89 d9 41 89 d8 44 89 e9 48 c7 c2 f8 74 83 81 48 =
89 c6 e8 9f 95 73 ff 4c 8b 24 dd 60 08 9c 81 4c 3b 24 dd 68 08 9c 81 73 0f =
<49> 8b 3c 24 49 83 c4 08 e8 44 e3 6b ff eb e7 48 ff c3 eb 96 e8=20
[    1.204010] RIP  [<ffffffff81941e91>] kernel_init_freeable+0x140/0x1d3
[    1.204010]  RSP <ffff88000ec67f18>
[    1.258402] ---[ end trace 034c5e9620a58ceb ]---
[    1.259754] Kernel panic - not syncing: Fatal exception
[    1.261319] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x7-1108/65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8/vmlinuz-3.12.0-02415-g65a=
52a4e -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_=
buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk =
sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 =
console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-q=
ueue/kvm/x86_64-randconfig-x7-1108/devel-xian-x86_64-201311081746/.vmlinuz-=
65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8-20131108181028-8-lkp-tt02 branch=
=3Dlinux-devel/devel-xian-x86_64-201311081746 BOOT_IMAGE=3D/kernel/x86_64-r=
andconfig-x7-1108/65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8/vmlinuz-3.12.0-0=
2415-g65a52a4e'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 2=
56M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -pidfile /dev/shm/kboot/pid-yocto-lkp-t=
t02-9 -serial file:/dev/shm/kboot/serial-yocto-lkp-tt02-9 -daemonize -displ=
ay none -monitor null=20

--17pEHd4RhPHOinZp
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-65a52a4ea1f334e61fe0178fc2a87c3f3e5c62a8-x86_64-randconfig-x7-1108-general-protection-fault:-55124.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjVhNTJhNGUuLi4gTWVyZ2UgJ2RybS1pbnRl
bC9kcm0taW50ZWwtbmlnaHRseScgaW50byBkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwODE3
NDYKSEVBRCBpcyBub3cgYXQgNWUwMWRjNy4uLiBMaW51eCAzLjEyCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4L2xpbnV4LWRl
dmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA4MTc0Njo1ZTAxZGM3YjI2ZDlmMjRmMzlh
YmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1tbQogU1VDQ0VTUwoKYmlzZWN0OiBnb29k
IGNvbW1pdCA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCmdpdCBi
aXNlY3Qgc3RhcnQgNjVhNTJhNGVhMWYzMzRlNjFmZTAxNzhmYzJhODdjM2YzZTVjNjJhOCA1
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyIC0tClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDVlMDFkYzcuLi4gTGludXggMy4xMgpIRUFEIGlzIG5vdyBhdCAz
YzBlZWUzLi4uIExpbnV4IDIuNi4zNwpCaXNlY3Rpbmc6IDEyNDEgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbYmEyNzUyNDEwMzBjZmU4
N2I4N2Q2NTkyMzQ1YzdlN2ViZDliNmZiYV0gdmlydGlvLW5ldDogY29hbGVzY2UgcnggZnJh
Z3Mgd2hlbiBwb3NzaWJsZSBkdXJpbmcgcngKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2Vj
dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14
ODZfNjQtMjAxMzExMDgxNzQ2OmJhMjc1MjQxMDMwY2ZlODdiODdkNjU5MjM0NWM3ZTdlYmQ5
YjZmYmE6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTExOjA3OjE5IGJhMjc1MjQxMDMwY2ZlODdi
ODdkNjU5MjM0NWM3ZTdlYmQ5YjZmYmEgY29tcGlsaW5nCjExMTMgcmVhbCAgMTQxOSB1c2Vy
ICAxMzYgc3lzICAxMzkuNjclIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDctMTEwOAoKMjAx
My0xMS0wOS0xMTozMzozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDExNzMtZ2Jh
Mjc1MjQuLi4JMS4uLi4JMgkzLgk0CTUuCTYJNy4JOC4JMTEJMTIJMTMuCTE1LgkxNwkxOAkx
OS4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNjQyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMjRkNzBkY2E2ZjNjOTI2MWFhOWNmODUy
NTJiMDJlNDA0NGVhMDgyMl0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZHJtLXVw
c3RyZWFtL2RybS1uZXh0JyBpbnRvIGRybS1pbnRlbC1uaWdodGx5CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWcteDctMTEwOC9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwODE3
NDY6MjRkNzBkY2E2ZjNjOTI2MWFhOWNmODUyNTJiMDJlNDA0NGVhMDgyMjpiaXNlY3QtbW0K
CjIwMTMtMTEtMDktMTE6NDk6MTAgMjRkNzBkY2E2ZjNjOTI2MWFhOWNmODUyNTJiMDJlNDA0
NGVhMDgyMiBjb21waWxpbmcKMzI3IHJlYWwgIDEzMzAgdXNlciAgMTMyIHN5cyAgNDQ3LjQx
JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgKCjIwMTMtMTEtMDktMTE6NTU6MTIg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAwNTk5LWcyNGQ3MGRjLi4uCTE2CTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMzIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA4IHN0ZXBzKQpbMWU3ZDMwMzU1ZDkxYzcwZTI1NTdkYWYzZGFjNjMzMjU1
MjAyZDJkZl0gcnQyeDAwOiBydDI4MDBwY2k6IHNwbGl0IHJ0MjgwMHBjaV9lbmFibGVfcmFk
aW8gZnVuY3Rpb24KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4L2xpbnV4LWRldmVsOmRl
dmVsLXhpYW4teDg2XzY0LTIwMTMxMTA4MTc0NjoxZTdkMzAzNTVkOTFjNzBlMjU1N2RhZjNk
YWM2MzMyNTUyMDJkMmRmOmJpc2VjdC1tbQoKMjAxMy0xMS0wOS0xMTo1Nzo0OCAxZTdkMzAz
NTVkOTFjNzBlMjU1N2RhZjNkYWM2MzMyNTUyMDJkMmRmIGNvbXBpbGluZwoyNjkgcmVhbCAg
MTQ1NCB1c2VyICAxMzkgc3lzICA1OTAuNDAlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDct
MTEwOAoKMjAxMy0xMS0wOS0xMjowOTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAt
cmMxLTAwODQzLWcxZTdkMzAzLi4uCTUJOQkxMgkxMy4JMTYJMTgJMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxNDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDcgc3RlcHMpCltlZWQ1ZTZjYjM5NDUxMWMzMzI0Yjg4YTI1ZGE4Y2VmNzkzOGIzZTMwXSBN
ZXJnZSAnYmx1ZXRvb3RoL21hc3RlcicgaW50byBkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEw
ODE3NDYKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4L2xpbnV4LWRldmVsOmRldmVsLXhp
YW4teDg2XzY0LTIwMTMxMTA4MTc0NjplZWQ1ZTZjYjM5NDUxMWMzMzI0Yjg4YTI1ZGE4Y2Vm
NzkzOGIzZTMwOmJpc2VjdC1tbQoKMjAxMy0xMS0wOS0xMjoxNToyOCBlZWQ1ZTZjYjM5NDUx
MWMzMzI0Yjg4YTI1ZGE4Y2VmNzkzOGIzZTMwIGNvbXBpbGluZwo1MzQgcmVhbCAgMTQ2NSB1
c2VyICAxMzcgc3lzICAzMDAuMDMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDctMTEwOAoK
MjAxMy0xMS0wOS0xMjoyNzozNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAzODct
Z2VlZDVlNmMuIFRFU1QgRkFJTFVSRQpbICAgIDEuOTkzNDYxXSBBVlggaW5zdHJ1Y3Rpb25z
IGFyZSBub3QgZGV0ZWN0ZWQuClsgICAgMS45OTQ0NzVdIEFWWCBpbnN0cnVjdGlvbnMgYXJl
IG5vdCBkZXRlY3RlZC4KWyAgICAxLjk5OTA3NF0gSW5pdGlhbGl6aW5nIFJULVRlc3Rlcjog
T0sKWyAgICAyLjA2NzY0N10gZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAwMDAwIFsjMV0g
UFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAyLjA2ODAxMV0gTW9kdWxlcyBsaW5rZWQg
aW46ClsgICAgMi4wNjgwMTFdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFp
bnRlZCAzLjEyLjAtMDAzODctZ2VlZDVlNmMgIzQ4NQpbICAgIDIuMDY4MDExXSB0YXNrOiBm
ZmZmODgwMDBlYzY0MDQwIHRpOiBmZmZmODgwMDBlYzY2MDAwIHRhc2sudGk6IGZmZmY4ODAw
MGVjNjYwMDAKWyAgICAyLjA2ODAxMV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTkzYmU5MT5d
ICBbPGZmZmZmZmZmODE5M2JlOTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0MC8weDFk
MwpbICAgIDIuMDY4MDExXSBSU1A6IDAwMDA6ZmZmZjg4MDAwZWM2N2YxOCAgRUZMQUdTOiAw
MDAxMDI4NwpbICAgIDIuMDY4MDExXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAw
MDAwMDAwMDAwMDA2IFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDExXSBSRFg6
IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiBmZmZmZmZmZjgxODgyNTkwIFJESTogZmZmZmZmZmY4
MTg4NTVkOApbICAgIDIuMDY4MDExXSBSQlA6IGZmZmY4ODAwMGVjNjdmMzggUjA4OiAwMDAw
MDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDExXSBSMTA6
IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmYwMGZmZmY4
MTlkYjg1OApbICAgIDIuMDY4MDExXSBSMTM6IDAwMDAwMDAwMDAwMDAxN2MgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDExXSBGUzog
IDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTg1NTAwMCgwMDAwKSBrbmxH
UzowMDAwMDAwMDAwMDAwMDAwClsgICAgMi4wNjgwMTFdIENTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAyLjA2ODAxMV0gQ1IyOiAwMDAw
MDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMTg0NTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2
YjAKWyAgICAyLjA2ODAxMV0gU3RhY2s6ClsgICAgMi4wNjgwMTFdICBmZmZmZmZmZjgxOTNi
NmEzIGZmZmZmZmZmODE0ZjFhMTggMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAw
ClsgICAgMi4wNjgwMTFdICBmZmZmODgwMDBlYzY3ZjQ4IGZmZmZmZmZmODE0ZjFhMjEgMDAw
MDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxNTA1ODRhClsgICAgMi4wNjgwMTFdICAwMDAwMDAw
MDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAw
MDAwMDAwClsgICAgMi4wNjgwMTFdIENhbGwgVHJhY2U6ClsgICAgMi4wNjgwMTFdICBbPGZm
ZmZmZmZmODE5M2I2YTM+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDIuMDY4
MDExXSAgWzxmZmZmZmZmZjgxNGYxYTE4Pl0gPyByZXN0X2luaXQrMHhiYy8weGJjClsgICAg
Mi4wNjgwMTFdICBbPGZmZmZmZmZmODE0ZjFhMjE+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpb
ICAgIDIuMDY4MDExXSAgWzxmZmZmZmZmZjgxNTA1ODRhPl0gcmV0X2Zyb21fZm9yaysweDdh
LzB4YjAKWyAgICAyLjA2ODAxMV0gIFs8ZmZmZmZmZmY4MTRmMWExOD5dID8gcmVzdF9pbml0
KzB4YmMvMHhiYwpbICAgIDIuMDY4MDExXSBDb2RlOiA4MSA0MSA4OSBkOSA0MSA4OSBkOCA0
NCA4OSBlOSA0OCBjNyBjMiAxOCAyZiA4MyA4MSA0OCA4OSBjNiBlOCA5ZiBmNSA3MyBmZiA0
YyA4YiAyNCBkZCA2MCA5OCA5YiA4MSA0YyAzYiAyNCBkZCA2OCA5OCA5YiA4MSA3MyAwZiA8
NDk+IDhiIDNjIDI0IDQ5IDgzIGM0IDA4IGU4IDQ0IDQzIDZjIGZmIGViIGU3IDQ4IGZmIGMz
IGViIDk2IGU4IApbICAgIDIuMDY4MDExXSBSSVAgIFs8ZmZmZmZmZmY4MTkzYmU5MT5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4MTQwLzB4MWQzClsgICAgMi4wNjgwMTFdICBSU1AgPGZm
ZmY4ODAwMGVjNjdmMTg+ClsgICAgMi4xNTgyNzZdIC0tLVsgZW5kIHRyYWNlIDczMWI3YmE2
OTNkOTkzOTcgXS0tLQpbICAgIDIuMTU5MzM2XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2lu
ZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC9l
ZWQ1ZTZjYjM5NDUxMWMzMzI0Yjg4YTI1ZGE4Y2VmNzkzOGIzZTMwL2RtZXNnLXlvY3RvLWxr
cC10dDAyLTc6MjAxMzExMDkwMzE4MzI6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEy
LjAtMDAzODctZ2VlZDVlNmM6NDg1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEw
OC9lZWQ1ZTZjYjM5NDUxMWMzMzI0Yjg4YTI1ZGE4Y2VmNzkzOGIzZTMwL2RtZXNnLXlvY3Rv
LWxrcC1zdDAxLTY6MjAxMzExMDkyMDIzMzE6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODoz
LjEyLjAtMDAzODctZ2VlZDVlNmM6NDg1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDct
MTEwOC9lZWQ1ZTZjYjM5NDUxMWMzMzI0Yjg4YTI1ZGE4Y2VmNzkzOGIzZTMwL2RtZXNnLXlv
Y3RvLXhnd28tMToyMDEzMTEwOTIwMjUxNTp4ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4OjMu
MTIuMC0wMDM4Ny1nZWVkNWU2Yzo0ODUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14Ny0x
MTA4L2VlZDVlNmNiMzk0NTExYzMzMjRiODhhMjVkYThjZWY3OTM4YjNlMzAvZG1lc2cteW9j
dG8tcm9hbS0yNjoyMDEzMTEwOTEyMjgwNDp4ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4OjMu
MTIuMC0wMDM4Ny1nZWVkNWU2Yzo0ODUKMDo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9tbS1iaXNlY3QvLnJlcGVh
dBtbMG0KCkJpc2VjdGluZzogODcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDcgc3RlcHMpCls3NzUxZWYxYjMxODRlY2ZhZWJjNWU1YTg5ODE0MDc4MTRj
ZTBiZTBiXSBCbHVldG9vdGg6IENoZWNrIGZvciBmbGFnIGluc3RlYWQgb2YgZmVhdHVyZXMg
aW4gdXBkYXRlX3NjYW5fcnNwX2RhdGEoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgv
bGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2Ojc3NTFlZjFiMzE4
NGVjZmFlYmM1ZTVhODk4MTQwNzgxNGNlMGJlMGI6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTEy
OjI4OjEyIDc3NTFlZjFiMzE4NGVjZmFlYmM1ZTVhODk4MTQwNzgxNGNlMGJlMGIgY29tcGls
aW5nCjI4MiByZWFsICAxNDM2IHVzZXIgIDEzOCBzeXMgIDU1Ny43NyUgY3B1IAl4ODZfNjQt
cmFuZGNvbmZpZy14Ny0xMTA4CgoyMDEzLTExLTA5LTEyOjM2OjAzIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTEuMC0wNzY5OS1nNzc1MWVmMS4uCTExCTE5Li4JMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA0MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NiBzdGVwcykKWzM3ZDFjNWZjMmRkODBkYjhjMDg0ZTVjM2QzMjRjYjkyZGQ2ZTVhOTRdIE1l
cmdlIGJyYW5jaGVzICdrYnVpbGQva2J1aWxkJyBhbmQgJ2tidWlsZC9taXNjJyBpbnRvIGti
dWlsZC9mb3ItbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvbGludXgtZGV2ZWw6
ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2OjM3ZDFjNWZjMmRkODBkYjhjMDg0ZTVj
M2QzMjRjYjkyZGQ2ZTVhOTQ6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTEyOjM5OjM3IDM3ZDFj
NWZjMmRkODBkYjhjMDg0ZTVjM2QzMjRjYjkyZGQ2ZTVhOTQgY29tcGlsaW5nCjIxNyByZWFs
ICAxNDQyIHVzZXIgIDE0MSBzeXMgIDcyOS4xMCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14
Ny0xMTA4CgoyMDEzLTExLTA5LTEyOjQzOjQ5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC1yYzEtMDAwNDUtZzM3ZDFjNWYuIFRFU1QgRkFJTFVSRQpbICAgIDIuMDM2NDUyXSBBVlgg
aW5zdHJ1Y3Rpb25zIGFyZSBub3QgZGV0ZWN0ZWQuClsgICAgMi4wMzc2NzZdIEFWWCBpbnN0
cnVjdGlvbnMgYXJlIG5vdCBkZXRlY3RlZC4KWyAgICAyLjA0MDU1NF0gSW5pdGlhbGl6aW5n
IFJULVRlc3RlcjogT0sKWyAgICAyLjA2NjI2Ml0gZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0
OiAwMDAwIFsjMV0gUFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAyLjA2ODAyMV0gTW9k
dWxlcyBsaW5rZWQgaW46ClsgICAgMi4wNjgwMjFdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dh
cHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDQ1LWczN2QxYzVmICM0ODcKWyAgICAy
LjA2ODAyMV0gdGFzazogZmZmZjg4MDAwZDg2NDA0MCB0aTogZmZmZjg4MDAwZDg2NjAwMCB0
YXNrLnRpOiBmZmZmODgwMDBkODY2MDAwClsgICAgMi4wNjgwMjFdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODE5MzRlOTE+XSAgWzxmZmZmZmZmZjgxOTM0ZTkxPl0ga2VybmVsX2luaXRfZnJl
ZWFibGUrMHgxNDAvMHgxY2UKWyAgICAyLjA2ODAyMV0gUlNQOiAwMDAwOmZmZmY4ODAwMGQ4
NjdmMTggIEVGTEFHUzogMDAwMTAyODcKWyAgICAyLjA2ODAyMV0gUkFYOiAwMDAwMDAwMDAw
MDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwNiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAyLjA2ODAyMV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZmZmZmY4MTg3YzUx
MCBSREk6IGZmZmZmZmZmODE4N2Y1NTgKWyAgICAyLjA2ODAyMV0gUkJQOiBmZmZmODgwMDBk
ODY3ZjM4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAyLjA2ODAyMV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAw
MCBSMTI6IGZmMDBmZmZmODE5ZDQ4NDgKWyAgICAyLjA2ODAyMV0gUjEzOiAwMDAwMDAwMDAw
MDAwMTdjIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAyLjA2ODAyMV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE4
NGYwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDIxXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMi4w
NjgwMjFdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDE4M2YwMDAgQ1I0
OiAwMDAwMDAwMDAwMDAwNmIwClsgICAgMi4wNjgwMjFdIFN0YWNrOgpbICAgIDIuMDY4MDIx
XSAgZmZmZmZmZmY4MTkzNDZhMyBmZmZmZmZmZjgxNGVkOWU4IDAwMDAwMDAwMDAwMDAwMDAg
MDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDIxXSAgZmZmZjg4MDAwZDg2N2Y0OCBmZmZm
ZmZmZjgxNGVkOWYxIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MTUwMTg3YQpbICAgIDIu
MDY4MDIxXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMDY4MDIxXSBDYWxsIFRyYWNlOgpbICAg
IDIuMDY4MDIxXSAgWzxmZmZmZmZmZjgxOTM0NmEzPl0gPyBkb19lYXJseV9wYXJhbSsweDg4
LzB4ODgKWyAgICAyLjA2ODAyMV0gIFs8ZmZmZmZmZmY4MTRlZDllOD5dID8gcmVzdF9pbml0
KzB4YmMvMHhiYwpbICAgIDIuMDY4MDIxXSAgWzxmZmZmZmZmZjgxNGVkOWYxPl0ga2VybmVs
X2luaXQrMHg5LzB4Y2MKWyAgICAyLjA2ODAyMV0gIFs8ZmZmZmZmZmY4MTUwMTg3YT5dIHJl
dF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMi4wNjgwMjFdICBbPGZmZmZmZmZmODE0ZWQ5
ZTg+XSA/IHJlc3RfaW5pdCsweGJjLzB4YmMKWyAgICAyLjA2ODAyMV0gQ29kZTogODEgNDEg
ODkgZDkgNDEgODkgZDggNDQgODkgZTkgNDggYzcgYzIgZjggYjggODIgODEgNDggODkgYzYg
ZTggNTEgNjUgNzQgZmYgNGMgOGIgMjQgZGQgNjAgMjggOWIgODEgNGMgM2IgMjQgZGQgNjgg
MjggOWIgODEgNzMgMGYgPDQ5PiA4YiAzYyAyNCA0OSA4MyBjNCAwOCBlOCA0NCBiMyA2YyBm
ZiBlYiBlNyA0OCBmZiBjMyBlYiA5NiAzMSAKWyAgICAyLjA2ODAyMV0gUklQICBbPGZmZmZm
ZmZmODE5MzRlOTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0MC8weDFjZQpbICAgIDIu
MDY4MDIxXSAgUlNQIDxmZmZmODgwMDBkODY3ZjE4PgpbICAgIDIuMTE2MzI4XSAtLS1bIGVu
ZCB0cmFjZSA5ZWZkZTk2MjY4OGM5YjFjIF0tLS0KWyAgICAyLjExNzU0N10gS2VybmVsIHBh
bmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXg3LTExMDgvMzdkMWM1ZmMyZGQ4MGRiOGMwODRlNWMzZDMyNGNiOTJkZDZlNWE5
NC9kbWVzZy1xdWFudGFsLWF0aGVucy0xNjoyMDEzMTEwOTEyNDQwMzp4ODZfNjQtcmFuZGNv
bmZpZy14Ny0xMTA4OjMuMTIuMC1yYzEtMDAwNDUtZzM3ZDFjNWY6NDg3Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDctMTEwOC8zN2QxYzVmYzJkZDgwZGI4YzA4NGU1YzNkMzI0Y2I5
MmRkNmU1YTk0L2RtZXNnLXF1YW50YWwtcm9hbS0zNzoyMDEzMTEwOTEyNDQwMjp4ODZfNjQt
cmFuZGNvbmZpZy14Ny0xMTA4OjMuMTIuMC1yYzEtMDAwNDUtZzM3ZDFjNWY6NDg3CjA6Mjoy
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAj
IC9jYy93ZmcvbW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIxIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbMzJmMWIxMzk3
M2NjNTFjN2VlOTZiZjEwMzQzMzkxZjE2YTJkZTc2MV0gTWVyZ2UgdjMuMTItcmMxIGludG8g
a2J1aWxkL2Zvci1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDctMTEwOC9saW51eC1kZXZl
bDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwODE3NDY6MzJmMWIxMzk3M2NjNTFjN2VlOTZi
ZjEwMzQzMzkxZjE2YTJkZTc2MTpiaXNlY3QtbW0KCjIwMTMtMTEtMDktMTI6NDQ6MjQgMzJm
MWIxMzk3M2NjNTFjN2VlOTZiZjEwMzQzMzkxZjE2YTJkZTc2MSBjb21waWxpbmcKMjk2IHJl
YWwgIDE0NjcgdXNlciAgMTQyIHN5cyAgNTQzLjk0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LXg3LTExMDgKCjIwMTMtMTEtMDktMTI6NTA6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
Mi4wLXJjMS0wMDAyMi1nMzJmMWIxMy4uCTMJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2Ux
MjUwOTZlNzMzZTk2NmUwNTVlZTYwMzMxNjlmNjgyMzNmOWJmOWNdIE1lcmdlIGJyYW5jaCAn
eWVtL2tjb25maWctZm9yLW5leHQnIG9mIGdpdDovL2dpdG9yaW91cy5vcmcvbGludXgta2Nv
bmZpZy9saW51eC1rY29uZmlnIGludG8ga2J1aWxkL2tjb25maWcKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy14Ny0xMTA4L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA4MTc0
NjplMTI1MDk2ZTczM2U5NjZlMDU1ZWU2MDMzMTY5ZjY4MjMzZjliZjljOmJpc2VjdC1tbQoK
MjAxMy0xMS0wOS0xMjo1MjowNSBlMTI1MDk2ZTczM2U5NjZlMDU1ZWU2MDMzMTY5ZjY4MjMz
ZjliZjljIGNvbXBpbGluZwoxODAgcmVhbCAgMTAzIHVzZXIgIDE4IHN5cyAgNjcuNDYlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWcteDctMTEwOAoKMjAxMy0xMS0wOS0xMjo1NzowMCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDA5LWdlMTI1MDk2Li4uCTE3CTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMyBzdGVwcykKWzg2ZGQwYjU3ZTU2ZDFkYjg0YTE4NzYxODE5YWFiODBmMmU2
NzM0ZjVdIE1lcmdlIGJyYW5jaGVzICdrYnVpbGQva2J1aWxkJyBhbmQgJ2tidWlsZC9taXNj
JyBpbnRvIGtidWlsZC9mb3ItbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvbGlu
dXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2Ojg2ZGQwYjU3ZTU2ZDFk
Yjg0YTE4NzYxODE5YWFiODBmMmU2NzM0ZjU6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTEyOjU5
OjM0IDg2ZGQwYjU3ZTU2ZDFkYjg0YTE4NzYxODE5YWFiODBmMmU2NzM0ZjUgY29tcGlsaW5n
CjU3MCByZWFsICAxNDcwIHVzZXIgIDEzNyBzeXMgIDI4MS43MyUgY3B1IAl4ODZfNjQtcmFu
ZGNvbmZpZy14Ny0xMTA4CgoyMDEzLTExLTA5LTEzOjEzOjMyIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTIuMC1yYzEtMDAwMjktZzg2ZGQwYjUuLgkxCTMuCTUJNi4JNwkxMC4JMTMJMTUu
CTE3CTE5Li4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpClsyMWNmNmU1ODRjZTM1Yjc5
Mzc0NTgxZTYzNDRkZDdjNzRmOGI0YTJiXSBrYnVpbGQsIGJsb2F0LW8tbWV0ZXI6IGZpeCBz
dGF0aWMgZGV0ZWN0aW9uCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDctMTEwOC9saW51eC1kZXZl
bDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwODE3NDY6MjFjZjZlNTg0Y2UzNWI3OTM3NDU4
MWU2MzQ0ZGQ3Yzc0ZjhiNGEyYjpiaXNlY3QtbW0KCjIwMTMtMTEtMDktMTM6MjU6MzcgMjFj
ZjZlNTg0Y2UzNWI3OTM3NDU4MWU2MzQ0ZGQ3Yzc0ZjhiNGEyYiBjb21waWxpbmcKNTggcmVh
bCAgMjYxIHVzZXIgIDI5IHN5cyAgNDk4LjM0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXg3
LTExMDgKCjIwMTMtMTEtMDktMTM6Mjc6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LXJjMS0wMDAwNC1nMjFjZjZlNS4gVEVTVCBGQUlMVVJFClsgICAgMi4wMjU2NTJdIEFWWCBp
bnN0cnVjdGlvbnMgYXJlIG5vdCBkZXRlY3RlZC4KWyAgICAyLjAyNjczN10gQVZYIGluc3Ry
dWN0aW9ucyBhcmUgbm90IGRldGVjdGVkLgpbICAgIDIuMDI5NDc1XSBJbml0aWFsaXppbmcg
UlQtVGVzdGVyOiBPSwpbICAgIDIuMDU1MDA3XSBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQ6
IDAwMDAgWyMxXSBQUkVFTVBUIERFQlVHX1BBR0VBTExPQwpbICAgIDIuMDU2MDIzXSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICAyLjA1NjAyM10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyIE5vdCB0YWludGVkIDMuMTIuMC1yYzEtMDAwMDQtZzIxY2Y2ZTUgIzQ5MQpbICAgIDIu
MDU2MDIzXSB0YXNrOiBmZmZmODgwMDBkODY0MDQwIHRpOiBmZmZmODgwMDBkODY2MDAwIHRh
c2sudGk6IGZmZmY4ODAwMGQ4NjYwMDAKWyAgICAyLjA1NjAyM10gUklQOiAwMDEwOls8ZmZm
ZmZmZmY4MTkzNGU5MT5dICBbPGZmZmZmZmZmODE5MzRlOTE+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDE0MC8weDFjZQpbICAgIDIuMDU2MDIzXSBSU1A6IDAwMDA6ZmZmZjg4MDAwZDg2
N2YxOCAgRUZMQUdTOiAwMDAxMDI4NwpbICAgIDIuMDU2MDIzXSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDA2IFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDIuMDU2MDIzXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiBmZmZmZmZmZjgxODdjNTEw
IFJESTogZmZmZmZmZmY4MTg3ZjU1OApbICAgIDIuMDU2MDIzXSBSQlA6IGZmZmY4ODAwMGQ4
NjdmMzggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDIuMDU2MDIzXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAw
IFIxMjogZmYwMGZmZmY4MTlkNDg0OApbICAgIDIuMDU2MDIzXSBSMTM6IDAwMDAwMDAwMDAw
MDAxN2MgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDIuMDU2MDIzXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTg0
ZjAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMi4wNTYwMjNdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAyLjA1
NjAyM10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMTgzZjAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAyLjA1NjAyM10gU3RhY2s6ClsgICAgMi4wNTYwMjNd
ICBmZmZmZmZmZjgxOTM0NmEzIGZmZmZmZmZmODE0ZWQ5ZTggMDAwMDAwMDAwMDAwMDAwMCAw
MDAwMDAwMDAwMDAwMDAwClsgICAgMi4wNTYwMjNdICBmZmZmODgwMDBkODY3ZjQ4IGZmZmZm
ZmZmODE0ZWQ5ZjEgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxNTAxODdhClsgICAgMi4w
NTYwMjNdICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMi4wNTYwMjNdIENhbGwgVHJhY2U6ClsgICAg
Mi4wNTYwMjNdICBbPGZmZmZmZmZmODE5MzQ2YTM+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgv
MHg4OApbICAgIDIuMDU2MDIzXSAgWzxmZmZmZmZmZjgxNGVkOWU4Pl0gPyByZXN0X2luaXQr
MHhiYy8weGJjClsgICAgMi4wNTYwMjNdICBbPGZmZmZmZmZmODE0ZWQ5ZjE+XSBrZXJuZWxf
aW5pdCsweDkvMHhjYwpbICAgIDIuMDU2MDIzXSAgWzxmZmZmZmZmZjgxNTAxODdhPl0gcmV0
X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAyLjA1NjAyM10gIFs8ZmZmZmZmZmY4MTRlZDll
OD5dID8gcmVzdF9pbml0KzB4YmMvMHhiYwpbICAgIDIuMDU2MDIzXSBDb2RlOiA4MSA0MSA4
OSBkOSA0MSA4OSBkOCA0NCA4OSBlOSA0OCBjNyBjMiBmOCBiOCA4MiA4MSA0OCA4OSBjNiBl
OCA1MSA2NSA3NCBmZiA0YyA4YiAyNCBkZCA2MCAyOCA5YiA4MSA0YyAzYiAyNCBkZCA2OCAy
OCA5YiA4MSA3MyAwZiA8NDk+IDhiIDNjIDI0IDQ5IDgzIGM0IDA4IGU4IDQ0IGIzIDZjIGZm
IGViIGU3IDQ4IGZmIGMzIGViIDk2IDMxIApbICAgIDIuMDU2MDIzXSBSSVAgIFs8ZmZmZmZm
ZmY4MTkzNGU5MT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTQwLzB4MWNlClsgICAgMi4w
NTYwMjNdICBSU1AgPGZmZmY4ODAwMGQ4NjdmMTg+ClsgICAgMi4xMDM2NDBdIC0tLVsgZW5k
IHRyYWNlIGNmZmE1YzY3OGM0MzA3MGMgXS0tLQpbICAgIDIuMTA0ODI0XSBLZXJuZWwgcGFu
aWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDctMTEwOC8yMWNmNmU1ODRjZTM1Yjc5Mzc0NTgxZTYzNDRkZDdjNzRmOGI0YTJi
L2RtZXNnLXF1YW50YWwteGlhbi00MjoyMDEzMTEwOTEzMjc1ODp4ODZfNjQtcmFuZGNvbmZp
Zy14Ny0xMTA4OjMuMTIuMC1yYzEtMDAwMDQtZzIxY2Y2ZTU6NDkxCjA6MToxIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93Zmcv
bW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2YzNDYyYWE5NTJjZmM4ZjRiMDk1
MTAzY2I5YjNkMzA2ZGQyMTY1NThdIEtidWlsZDogSGFuZGxlIGxvbmdlciBzeW1ib2xzIGlu
IGthbGxzeW1zLmMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4L2xpbnV4LWRldmVsOmRl
dmVsLXhpYW4teDg2XzY0LTIwMTMxMTA4MTc0NjpmMzQ2MmFhOTUyY2ZjOGY0YjA5NTEwM2Ni
OWIzZDMwNmRkMjE2NTU4OmJpc2VjdC1tbQoKMjAxMy0xMS0wOS0xMzoyODoxMyBmMzQ2MmFh
OTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2NTU4IGNvbXBpbGluZwo0MiByZWFsICAx
MDEgdXNlciAgMTggc3lzICAyODQuNDMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDctMTEw
OAoKMjAxMy0xMS0wOS0xMzoyOToxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMx
LTAwMDAzLWdmMzQ2MmFhLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuNDg4MzI4XSBBVlggaW5z
dHJ1Y3Rpb25zIGFyZSBub3QgZGV0ZWN0ZWQuClsgICAgMC40ODg4ODVdIEFWWCBpbnN0cnVj
dGlvbnMgYXJlIG5vdCBkZXRlY3RlZC4KWyAgICAwLjQ5MDU1NF0gSW5pdGlhbGl6aW5nIFJU
LVRlc3RlcjogT0sKWyAgICAwLjUwOTI5MV0gZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAw
MDAwIFsjMV0gUFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjUxMDE4Nl0gTW9kdWxl
cyBsaW5rZWQgaW46ClsgICAgMC41MTA1ODZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBl
ciBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhICM0OTIKWyAgICAwLjUx
MTUxM10gdGFzazogZmZmZjg4MDAwZWM2NDA0MCB0aTogZmZmZjg4MDAwZWM2NjAwMCB0YXNr
LnRpOiBmZmZmODgwMDBlYzY2MDAwClsgICAgMC41MTIwMDldIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODE5MzRlOTE+XSAgWzxmZmZmZmZmZjgxOTM0ZTkxPl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxNDAvMHgxY2UKWyAgICAwLjUxMjAwOV0gUlNQOiAwMDAwOmZmZmY4ODAwMGVjNjdm
MTggIEVGTEFHUzogMDAwMTAyODcKWyAgICAwLjUxMjAwOV0gUkFYOiAwMDAwMDAwMDAwMDAw
MDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwNiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAw
LjUxMjAwOV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZmZmZmY4MTg3YzUxMCBS
REk6IGZmZmZmZmZmODE4N2Y1NTgKWyAgICAwLjUxMjAwOV0gUkJQOiBmZmZmODgwMDBlYzY3
ZjM4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAw
LjUxMjAwOV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBS
MTI6IGZmMDBmZmZmODE5ZDQ4NDgKWyAgICAwLjUxMjAwOV0gUjEzOiAwMDAwMDAwMDAwMDAw
MTdjIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAw
LjUxMjAwOV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE4NGYw
MDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNTEyMDA5XSBDUzogIDAw
MTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC41MTIw
MDldIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDE4M2YwMDAgQ1I0OiAw
MDAwMDAwMDAwMDAwNmIwClsgICAgMC41MTIwMDldIFN0YWNrOgpbICAgIDAuNTEyMDA5XSAg
ZmZmZmZmZmY4MTkzNDZhMyBmZmZmZmZmZjgxNGVkOWU4IDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMApbICAgIDAuNTEyMDA5XSAgZmZmZjg4MDAwZWM2N2Y0OCBmZmZmZmZm
ZjgxNGVkOWYxIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MTUwMTg3YQpbICAgIDAuNTEy
MDA5XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAw
MDAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNTEyMDA5XSBDYWxsIFRyYWNlOgpbICAgIDAu
NTEyMDA5XSAgWzxmZmZmZmZmZjgxOTM0NmEzPl0gPyBkb19lYXJseV9wYXJhbSsweDg4LzB4
ODgKWyAgICAwLjUxMjAwOV0gIFs8ZmZmZmZmZmY4MTRlZDllOD5dID8gcmVzdF9pbml0KzB4
YmMvMHhiYwpbICAgIDAuNTEyMDA5XSAgWzxmZmZmZmZmZjgxNGVkOWYxPl0ga2VybmVsX2lu
aXQrMHg5LzB4Y2MKWyAgICAwLjUxMjAwOV0gIFs8ZmZmZmZmZmY4MTUwMTg3YT5dIHJldF9m
cm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMC41MTIwMDldICBbPGZmZmZmZmZmODE0ZWQ5ZTg+
XSA/IHJlc3RfaW5pdCsweGJjLzB4YmMKWyAgICAwLjUxMjAwOV0gQ29kZTogODEgNDEgODkg
ZDkgNDEgODkgZDggNDQgODkgZTkgNDggYzcgYzIgZjggYjggODIgODEgNDggODkgYzYgZTgg
NTEgNjUgNzQgZmYgNGMgOGIgMjQgZGQgNjAgMjggOWIgODEgNGMgM2IgMjQgZGQgNjggMjgg
OWIgODEgNzMgMGYgPDQ5PiA4YiAzYyAyNCA0OSA4MyBjNCAwOCBlOCA0NCBiMyA2YyBmZiBl
YiBlNyA0OCBmZiBjMyBlYiA5NiAzMSAKWyAgICAwLjUxMjAwOV0gUklQICBbPGZmZmZmZmZm
ODE5MzRlOTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0MC8weDFjZQpbICAgIDAuNTEy
MDA5XSAgUlNQIDxmZmZmODgwMDBlYzY3ZjE4PgpbICAgIDAuNTMyNzM3XSAtLS1bIGVuZCB0
cmFjZSA0YWNhYjk2NmJlNmMyNTIwIF0tLS0KWyAgICAwLjUzMzMyN10gS2VybmVsIHBhbmlj
IC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXg3LTExMDgvZjM0NjJhYTk1MmNmYzhmNGIwOTUxMDNjYjliM2QzMDZkZDIxNjU1OC9k
bWVzZy15b2N0by14aWFuLTU6MjAxMzExMDkxMzMwMzI6eDg2XzY0LXJhbmRjb25maWcteDct
MTEwODozLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhOjQ5MgowOjE6MSBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL21tLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZWVhMGU5Y2JiOWU2NWNkNTUzZDMwMmE0
YWVmZDRjN2I3MGQ5ZmQ5MF0ga2J1aWxkOiBJbmNyZWFzZSBrYWxsc3ltcyBtYXggc3ltYm9s
IGxlbmd0aApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwt
eGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2OmVlYTBlOWNiYjllNjVjZDU1M2QzMDJhNGFlZmQ0
YzdiNzBkOWZkOTA6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTEzOjMwOjQ3IGVlYTBlOWNiYjll
NjVjZDU1M2QzMDJhNGFlZmQ0YzdiNzBkOWZkOTAgY29tcGlsaW5nCjY3IHJlYWwgIDEwNCB1
c2VyICAyMCBzeXMgIDE4NC45NyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4Cgoy
MDEzLTExLTA5LTEzOjM0OjMyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAw
MDItZ2VlYTBlOWMuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuNzU1NTAzXSBBVlggaW5zdHJ1
Y3Rpb25zIGFyZSBub3QgZGV0ZWN0ZWQuClsgICAgMC43NTY4OTNdIEFWWCBpbnN0cnVjdGlv
bnMgYXJlIG5vdCBkZXRlY3RlZC4KWyAgICAwLjc1OTc5NV0gSW5pdGlhbGl6aW5nIFJULVRl
c3RlcjogT0sKWyAgICAwLjc4NjEyOF0gZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAwMDAw
IFsjMV0gUFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjc4ODAyMl0gTW9kdWxlcyBs
aW5rZWQgaW46ClsgICAgMC43ODgwMjJdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBO
b3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDAyLWdlZWEwZTljICM0OTMKWyAgICAwLjc4ODAy
Ml0gdGFzazogZmZmZjg4MDAwZWM2NDA0MCB0aTogZmZmZjg4MDAwZWM2NjAwMCB0YXNrLnRp
OiBmZmZmODgwMDBlYzY2MDAwClsgICAgMC43ODgwMjJdIFJJUDogMDAxMDpbPGZmZmZmZmZm
ODE5MzRlOTE+XSAgWzxmZmZmZmZmZjgxOTM0ZTkxPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHgxNDAvMHgxY2UKWyAgICAwLjc4ODAyMl0gUlNQOiAwMDAwOmZmZmY4ODAwMGVjNjdmMTgg
IEVGTEFHUzogMDAwMTAyODcKWyAgICAwLjc4ODAyMl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAw
IFJCWDogMDAwMDAwMDAwMDAwMDAwNiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjc4
ODAyMl0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZmZmZmY4MTg3YzUxMCBSREk6
IGZmZmZmZmZmODE4N2Y1NTgKWyAgICAwLjc4ODAyMl0gUkJQOiBmZmZmODgwMDBlYzY3ZjM4
IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjc4
ODAyMl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6
IGZmMDBmZmZmODE5ZDQ4NDgKWyAgICAwLjc4ODAyMl0gUjEzOiAwMDAwMDAwMDAwMDAwMTdj
IFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjc4
ODAyMl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE4NGYwMDAo
MDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNzg4MDIyXSBDUzogIDAwMTAg
RFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC43ODgwMjJd
IENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDE4M2YwMDAgQ1I0OiAwMDAw
MDAwMDAwMDAwNmIwClsgICAgMC43ODgwMjJdIFN0YWNrOgpbICAgIDAuNzg4MDIyXSAgZmZm
ZmZmZmY4MTkzNDZhMyBmZmZmZmZmZjgxNGVkOWU4IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMApbICAgIDAuNzg4MDIyXSAgZmZmZjg4MDAwZWM2N2Y0OCBmZmZmZmZmZjgx
NGVkOWYxIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MTUwMTg3YQpbICAgIDAuNzg4MDIy
XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAg
MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNzg4MDIyXSBDYWxsIFRyYWNlOgpbICAgIDAuNzg4
MDIyXSAgWzxmZmZmZmZmZjgxOTM0NmEzPl0gPyBkb19lYXJseV9wYXJhbSsweDg4LzB4ODgK
WyAgICAwLjc4ODAyMl0gIFs8ZmZmZmZmZmY4MTRlZDllOD5dID8gcmVzdF9pbml0KzB4YmMv
MHhiYwpbICAgIDAuNzg4MDIyXSAgWzxmZmZmZmZmZjgxNGVkOWYxPl0ga2VybmVsX2luaXQr
MHg5LzB4Y2MKWyAgICAwLjc4ODAyMl0gIFs8ZmZmZmZmZmY4MTUwMTg3YT5dIHJldF9mcm9t
X2ZvcmsrMHg3YS8weGIwClsgICAgMC43ODgwMjJdICBbPGZmZmZmZmZmODE0ZWQ5ZTg+XSA/
IHJlc3RfaW5pdCsweGJjLzB4YmMKWyAgICAwLjc4ODAyMl0gQ29kZTogODEgNDEgODkgZDkg
NDEgODkgZDggNDQgODkgZTkgNDggYzcgYzIgZjggYjggODIgODEgNDggODkgYzYgZTggNTEg
NjUgNzQgZmYgNGMgOGIgMjQgZGQgNjAgMjggOWIgODEgNGMgM2IgMjQgZGQgNjggMjggOWIg
ODEgNzMgMGYgPDQ5PiA4YiAzYyAyNCA0OSA4MyBjNCAwOCBlOCA0NCBiMyA2YyBmZiBlYiBl
NyA0OCBmZiBjMyBlYiA5NiAzMSAKWyAgICAwLjc4ODAyMl0gUklQICBbPGZmZmZmZmZmODE5
MzRlOTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0MC8weDFjZQpbICAgIDAuNzg4MDIy
XSAgUlNQIDxmZmZmODgwMDBlYzY3ZjE4PgpbICAgIDAuODQwNzY3XSAtLS1bIGVuZCB0cmFj
ZSA4NTJiODE5NTY1NmE4ZThmIF0tLS0KWyAgICAwLjg0MjE1N10gS2VybmVsIHBhbmljIC0g
bm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXg3LTExMDgvZWVhMGU5Y2JiOWU2NWNkNTUzZDMwMmE0YWVmZDRjN2I3MGQ5ZmQ5MC9kbWVz
Zy15b2N0by1jYWlyby0zOToyMDEzMTEwOTEzMzYwNTp4ODZfNjQtcmFuZGNvbmZpZy14Ny0x
MTA4OjMuMTIuMC1yYzEtMDAwMDItZ2VlYTBlOWM6NDkzCjA6MToxIGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbW0tYmlz
ZWN0Ly5yZXBlYXQbWzBtCgplZWEwZTljYmI5ZTY1Y2Q1NTNkMzAyYTRhZWZkNGM3YjcwZDlm
ZDkwIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCBlZWEwZTljYmI5ZTY1Y2Q1NTNk
MzAyYTRhZWZkNGM3YjcwZDlmZDkwCkF1dGhvcjogSm9lIE1hcmlvIDxqbWFyaW9AcmVkaGF0
LmNvbT4KRGF0ZTogICBXZWQgT2N0IDIzIDE1OjA2OjUzIDIwMTMgKzAyMDAKCiAgICBrYnVp
bGQ6IEluY3JlYXNlIGthbGxzeW1zIG1heCBzeW1ib2wgbGVuZ3RoCiAgICAKICAgIFtBSzog
VGhpcyBzZWVtcyBsaWtlIGEgdGlja2luZyB0aW1lIGJvbWIgZXZlbiB3aXRob3V0IExUTywK
ICAgIHNvIHNob3VsZCBiZSBtZXJnZWQgbm93LiBJdCBjYXVzZXMgdmVyeSB3ZWlyZCBwcm9i
bGVtcy4KICAgIFRoYW5rcyB0byBKb2UgZm9yIHRyYWNraW5nIHRoZW0gZG93bi5dCiAgICAK
ICAgIFdpdGggdGhlIGFkZGVkIHBvc3RmaXhlcyB0aGF0IExUTyBhZGRzIGZvciBsb2NhbAog
ICAgc3ltYm9scywgdGhlIGxvbmdlc3QgbmFtZSBpbiB0aGUga2VybmVsIG92ZXJmbG93cwog
ICAgdGhlIG5hbWVidWZbS1NZTV9OQU1FX0xFTl0gYXJyYXkgYnkgdHdvIGJ5dGVzLiAgVGhh
dCBuYW1lIGlzOgogICAgX19wY2lfZml4dXBfcmVzdW1lUENJX1ZFTkRPUl9JRF9TRVJWRVJX
T1JLU1BDSV9ERVZJQ0VfSURfU0VSVkVSV09SS1NfSFQxMDAwU0JxdWlya19kaXNhYmxlX2Jy
b2FkY29tX2Jvb3RfaW50ZXJydXB0LjE0ODgwMDQuNjcyODAyCiAgICAKICAgIERvdWJsZSB0
aGUgbWF4IHN5bWJvbCBuYW1lIGxlbmd0aC4KICAgIAogICAgdjI6IFVzZSAyNTUgIChKb2Ug
UGVyY2hlcykKICAgIFNpZ25lZC1vZmYtYnk6IEFuZGkgS2xlZW4gPGFrQGxpbnV4LmludGVs
LmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IE1pY2hhbCBNYXJlayA8bW1hcmVrQHN1c2UuY3o+
Cgo6MDQwMDAwIDA0MDAwMCA3ZWI3YjhmMDk2OWU4ZjAyZTY3OWU1MTNmZWVkMGIzMWNhYTI3
NzNiIDI1NmNlYWE4ZTM3NDA5N2ZhMWYzYzJjMTJiZDJjMWNjMTcwZTE3YjEgTQlpbmNsdWRl
CmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWcteDctMTEwOC9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82
NC0yMDEzMTEwODE3NDY6ODA5NzA0NzIxNzlhNDU2MDljMGIxMWI4MDYxOWJjOGMzMmIxNWY3
NzpiaXNlY3QtbW0KCjIwMTMtMTEtMDktMTM6MzY6MzQgODA5NzA0NzIxNzlhNDU2MDljMGIx
MWI4MDYxOWJjOGMzMmIxNWY3NyBjb21waWxpbmcKCjIwMTMtMTEtMDktMTM6Mzc6NDEgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDAwMS1nODA5NzA0Ny4uLi4JMS4uLgky
Li4uLi4JMy4uLgk0Li4uLgk1CTYuCTcuLgk4Li4uCTkuCTEwCTEyLi4uLi4uLgkxMy4uCTE0
LgkxNi4JMTguLi4uCTE5CTIxCTI1CTI4CTI5CTMwCTM0CTM2CTM4CTM5CTQwCTQxCTQzCTQ0
Li4JNDYuCTQ3CTQ5Li4uLi4uCTUxCTU1Li4uCTU2Li4uCTU3Lgk1OQk2MCBTVUNDRVNTCgps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDct
MTEwOC9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwODE3NDY6NjVhNTJh
NGVhMWYzMzRlNjFmZTAxNzhmYzJhODdjM2YzZTVjNjJhODpiaXNlY3QtbW0KIFRFU1QgRkFJ
TFVSRQpbICAgIDQuMzU3MjU5XSBBVlggaW5zdHJ1Y3Rpb25zIGFyZSBub3QgZGV0ZWN0ZWQu
ClsgICAgNC4zNTgzMzJdIEFWWCBpbnN0cnVjdGlvbnMgYXJlIG5vdCBkZXRlY3RlZC4KWyAg
ICA0LjM3MjQxOV0gSW5pdGlhbGl6aW5nIFJULVRlc3RlcjogT0sKWyAgICA0LjQzMzE4OV0g
Z2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAwMDAwIFsjMV0gUFJFRU1QVCBERUJVR19QQUdF
QUxMT0MKWyAgICA0LjQzNDk0OV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNC40MzU3Mjhd
IENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtMDI0MTUt
ZzY1YTUyYTRlICM3MwpbICAgIDQuNDM2ODc5XSB0YXNrOiBmZmZmODgwMDBkODY0MDQwIHRp
OiBmZmZmODgwMDBkODY2MDAwIHRhc2sudGk6IGZmZmY4ODAwMGQ4NjYwMDAKWyAgICA0LjQz
Njg3OV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTk0MWU5MT5dICBbPGZmZmZmZmZmODE5NDFl
OTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0MC8weDFkMwpbICAgIDQuNDM2ODc5XSBS
U1A6IDAwMDA6ZmZmZjg4MDAwZDg2N2YxOCAgRUZMQUdTOiAwMDAxMDI4NwpbICAgIDQuNDM2
ODc5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDA2IFJDWDog
MDAwMDAwMDAwMDAwMDAwMApbICAgIDQuNDM2ODc5XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAg
UlNJOiBmZmZmZmZmZjgxODg4NTkwIFJESTogZmZmZmZmZmY4MTg4YjVkOApbICAgIDQuNDM2
ODc5XSBSQlA6IGZmZmY4ODAwMGQ4NjdmMzggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTog
MDAwMDAwMDAwMDAwMDAwMApbICAgIDQuNDM2ODc5XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAg
UjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmYwMGZmZmY4MTllMmE5OApbICAgIDQuNDM2
ODc5XSBSMTM6IDAwMDAwMDAwMDAwMDAxN2MgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTog
MDAwMDAwMDAwMDAwMDAwMApbICAgIDQuNDM2ODc5XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZmZmZmY4MTg1YjAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAgNC40MzY4NzldIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2IKWyAgICA0LjQzNjg3OV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzog
MDAwMDAwMDAwMTg0YjAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgICA0LjQzNjg3OV0g
U3RhY2s6ClsgICAgNC40MzY4NzldICBmZmZmZmZmZjgxOTQxNmEzIGZmZmZmZmZmODE0ZjFk
NjggMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgNC40MzY4NzldICBm
ZmZmODgwMDBkODY3ZjQ4IGZmZmZmZmZmODE0ZjFkNzEgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ZmZmZjgxNTA1YjhhClsgICAgNC40MzY4NzldICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAw
MDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgNC40MzY4
NzldIENhbGwgVHJhY2U6ClsgICAgNC40MzY4NzldICBbPGZmZmZmZmZmODE5NDE2YTM+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDQuNDM2ODc5XSAgWzxmZmZmZmZmZjgx
NGYxZDY4Pl0gPyByZXN0X2luaXQrMHhiYy8weGJjClsgICAgNC40MzY4NzldICBbPGZmZmZm
ZmZmODE0ZjFkNzE+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpbICAgIDQuNDM2ODc5XSAgWzxm
ZmZmZmZmZjgxNTA1YjhhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICA0LjQzNjg3
OV0gIFs8ZmZmZmZmZmY4MTRmMWQ2OD5dID8gcmVzdF9pbml0KzB4YmMvMHhiYwpbICAgIDQu
NDM2ODc5XSBDb2RlOiA4MSA0MSA4OSBkOSA0MSA4OSBkOCA0NCA4OSBlOSA0OCBjNyBjMiBm
OCA3NCA4MyA4MSA0OCA4OSBjNiBlOCA5ZiA5NSA3MyBmZiA0YyA4YiAyNCBkZCA2MCAwOCA5
YyA4MSA0YyAzYiAyNCBkZCA2OCAwOCA5YyA4MSA3MyAwZiA8NDk+IDhiIDNjIDI0IDQ5IDgz
IGM0IDA4IGU4IDQ0IGUzIDZiIGZmIGViIGU3IDQ4IGZmIGMzIGViIDk2IGU4IApbICAgIDQu
NDM2ODc5XSBSSVAgIFs8ZmZmZmZmZmY4MTk0MWU5MT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MTQwLzB4MWQzClsgICAgNC40MzY4NzldICBSU1AgPGZmZmY4ODAwMGQ4NjdmMTg+Clsg
ICAgNC41MTcyMzFdIC0tLVsgZW5kIHRyYWNlIGViY2NiNDFmMTIzMTc1ZTMgXS0tLQpbICAg
IDQuNTE4MzE0XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9u
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZl
MDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLWxrcC10dDAyLTk6MjAxMzExMDgw
OTAxMDc6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRl
OjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2
MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXF1YW50YWwtcm9hbS0zOjIwMTMxMTA5
MTEwODA2Ong4Nl82NC1yYW5kY29uZmlnLXg3LTExMDg6My4xMi4wLTAyNDE1LWc2NWE1MmE0
ZTo3Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvNjVhNTJhNGVhMWYzMzRl
NjFmZTAxNzhmYzJhODdjM2YzZTVjNjJhOC9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTExOjIw
MTMxMTA4MDkwMTM4Ong4Nl82NC1yYW5kY29uZmlnLXg3LTExMDg6My4xMi4wLTAyNDE1LWc2
NWE1MmE0ZTo3Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvNjVhNTJhNGVh
MWYzMzRlNjFmZTAxNzhmYzJhODdjM2YzZTVjNjJhOC9kbWVzZy1xdWFudGFsLWxrcC10dDAy
LTE6MjAxMzExMDkwMTU2NTQ6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0
MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1
MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLWF0aGVu
cy0xMToyMDEzMTEwOTExMDYxMTp4ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4OjMuMTIuMC0w
MjQxNS1nNjVhNTJhNGU6NzMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4LzY1
YTUyYTRlYTFmMzM0ZTYxZmUwMTc4ZmMyYTg3YzNmM2U1YzYyYTgvZG1lc2ctcXVhbnRhbC1i
ZW5zLTI6MjAxMzExMDkxMTA3Mjk6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAt
MDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82
NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLXN0
b2FrbGV5LTU6MjAxMzExMDgxODExMjc6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEy
LjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEw
OC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXF1YW50
YWwtbGtwLXN0MDEtMTI6MjAxMzExMDkxOTAyMzk6eDg2XzY0LXJhbmRjb25maWcteDctMTEw
ODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
eDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNn
LXlvY3RvLWxrcC10dDAyLTc6MjAxMzExMDkwMTU4MjI6eDg2XzY0LXJhbmRjb25maWcteDct
MTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2MmE4L2Rt
ZXNnLXF1YW50YWwtbGtwLXR0MDItMjM6MjAxMzExMDgwOTAxMDc6eDg2XzY0LXJhbmRjb25m
aWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNlNWM2
MmE4L2RtZXNnLXlvY3RvLWxrcC10dDAyLTc6MjAxMzExMDgwOTAxMzA6eDg2XzY0LXJhbmRj
b25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4N2MzZjNl
NWM2MmE4L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTk6MjAxMzExMDkwMTU3MjU6eDg2XzY0
LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4
N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLXJvYW0tMzM6MjAxMzExMDkxMTA3MDk6eDg2XzY0
LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZjMmE4
N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTY6MjAxMzExMDkwMjA3Mjc6eDg2
XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjczCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZlMDE3OGZj
MmE4N2MzZjNlNWM2MmE4L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTI6MjAxMzExMDgwOTAx
Mzc6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjcz
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZl
MDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXF1YW50YWwteGd3by0zOjIwMTMxMTA5MDIw
ODM2Ong4Nl82NC1yYW5kY29uZmlnLXg3LTExMDg6My4xMi4wLTAyNDE1LWc2NWE1MmE0ZTo3
Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvNjVhNTJhNGVhMWYzMzRlNjFm
ZTAxNzhmYzJhODdjM2YzZTVjNjJhOC9kbWVzZy15b2N0by1iZW5zLTM6MjAxMzExMDkxMTA1
MzA6eDg2XzY0LXJhbmRjb25maWcteDctMTEwODozLjEyLjAtMDI0MTUtZzY1YTUyYTRlOjcz
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDctMTEwOC82NWE1MmE0ZWExZjMzNGU2MWZl
MDE3OGZjMmE4N2MzZjNlNWM2MmE4L2RtZXNnLXlvY3RvLXNuYi00NDoyMDEzMTEwOTExMDUx
Nzp4ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4OjMuMTIuMC0wMjQxNS1nNjVhNTJhNGU6NzMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14Ny0xMTA4LzY1YTUyYTRlYTFmMzM0ZTYxZmUw
MTc4ZmMyYTg3YzNmM2U1YzYyYTgvZG1lc2cteW9jdG8teGd3by01OjIwMTMxMTA5MDIwOTAw
Ong4Nl82NC1yYW5kY29uZmlnLXg3LTExMDg6My4xMi4wLTAyNDE1LWc2NWE1MmE0ZTo3Mwow
OjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVBRCA0MzY0
YWFiXSBSZXZlcnQgImtidWlsZDogSW5jcmVhc2Uga2FsbHN5bXMgbWF4IHN5bWJvbCBsZW5n
dGgiCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTEx
MDgvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2OjQzNjRhYWI3
NGE2MTZlYTJjOTQ5NTFiY2ZmMDI5MGRiNzRmNDlmYWM6YmlzZWN0LW1tCgoyMDEzLTExLTA5
LTE0OjI1OjIzIDQzNjRhYWI3NGE2MTZlYTJjOTQ5NTFiY2ZmMDI5MGRiNzRmNDlmYWMgY29t
cGlsaW5nCgoyMDEzLTExLTA5LTE0OjMxOjU4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC0wMjQxNi1nNDM2NGFhYi4uLi4uCTEJMwk0Lgk3CTguLgkxMQkxMi4JMTMuCTE1Li4JMTYJ
MTcJMTguLi4JMTkJMjAJMjMJMjYJMzAJMzIJMzQJMzUJMzkJNDQJNTAJNjAgU1VDQ0VTUwoK
Cj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg3LTExMDgvbGlu
dXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDgxNzQ2OjZjODZhZTI5MjhmOWU0
Y2JmMGQ1ODQ0ZjVmY2ZkNTQ5ZTM0NTBiOGM6YmlzZWN0LW1tCgoyMDEzLTExLTA5LTE0OjUx
OjM2IDZjODZhZTI5MjhmOWU0Y2JmMGQ1ODQ0ZjVmY2ZkNTQ5ZTM0NTBiOGMgY29tcGlsaW5n
CgoyMDEzLTExLTA5LTE0OjU1OjQxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0wMTkx
NS1nNmM4NmFlMi4uLgkxMwkxOAkyNwkzMgkzNgk0Mgk0Nwk0OQk1MQk1Mgk1NAk1NQk1Ngk1
Ny4uCTU4CTU5Lgk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09
CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXg3LTExMDgvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAx
MzExMDgxNzQ2OmJhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjc6Ymlz
ZWN0LW1tCgoyMDEzLTExLTA5LTE1OjA3OjQxIGJhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEy
MDcyZjZmOGNlNjRjMjcgY29tcGlsaW5nCgoyMDEzLTExLTA5LTE1OjExOjUwIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTIuMC1uZXh0LTIwMTMxMTA4Li4uLgkyCTMuLgk0CTUJNi4JOAkx
MC4JMTIJMTMJMTUJMTcuCTIwCTIxLgkyMgkyMwkyNC4JMjYJMzcJMzkJNDAJNDQJNDcJNTAJ
NTIJNTQJNTYJNjAgU1VDQ0VTUwoK

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-02415-g65a52a4e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
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
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
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
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
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
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

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
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=m
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=m
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_HSR is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

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
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

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
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
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
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_DA=m
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
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
CONFIG_ALTERA_STAPL=m
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_PROC=m
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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=m
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_ATMEL=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_EXYNOS=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
# CONFIG_PINCONF is not set
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

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
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_MAX8925_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=m
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
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=m
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
# CONFIG_FB_GEODE_GX is not set
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_ATMEL_PWM is not set
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=m
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=y
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=m
# CONFIG_SND_GINA20 is not set
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=m
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=m
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_FM801=y
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=m
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=m
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=m
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_DESIGNWARE_I2S=m
# CONFIG_SND_IMX_SOC is not set
CONFIG_SND_KIRKWOOD_SOC=m
CONFIG_SND_KIRKWOOD_SOC_OPENRD=m
CONFIG_SND_KIRKWOOD_SOC_T5325=m
# CONFIG_SND_MXS_SOC is not set
# CONFIG_SND_SOC_TEGRA is not set
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_CS42L51=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_OSS is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

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
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ATMEL_PWM=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=m
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=m
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_MAX8997=m
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_RC5T583=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM8350=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y
CONFIG_COMMON_CLK_SI5351=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
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
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_ARIZONA=m
CONFIG_EXTCON_PALMAS=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
# CONFIG_MAX1363 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_SENSORS_LM3533=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=m
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_EFIVAR_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--17pEHd4RhPHOinZp--
