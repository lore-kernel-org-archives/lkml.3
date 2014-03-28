Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaC1H70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:59:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:24844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaC1H7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,749,1389772800"; 
   d="log'?scan'208";a="501527522"
Date: Fri, 28 Mar 2014 15:58:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Rob Herring <robh@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [pci] BUG: unable to handle kernel NULL pointer dereference at
 00000000000000c8
Message-ID: <20140328075851.GA18800@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux versatile

commit 003b5e6f33242288b3da627ac8a9fffdc61067a0
Author:     Liviu Dudau <Liviu.Dudau@arm.com>
AuthorDate: Fri Mar 14 15:34:29 2014 +0000
Commit:     Rob Herring <robh@kernel.org>
CommitDate: Thu Mar 27 17:00:57 2014 -0500

    pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
    
    Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
    As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
    the creation order has been changed for no good reason. Revert the order of
    creation as we are going to depend on the pci_host_bridge structure to retrieve the
    domain number of the root bus.
    
    Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
    Acked-by: Grant Likely <grant.likely@linaro.org>
    Tested-by: Tanmay Inamdar <tinamdar@apm.com>

+-----------------------------------------------------------+------------+------------+
|                                                           | 003b5e6f33 | eef38aacf6 |
+-----------------------------------------------------------+------------+------------+
| boot_successes                                            | 0          | 0          |
| boot_failures                                             | 20         | 19         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 20         | 19         |
| Oops:SMP                                                  | 20         | 19         |
| RIP:pcibios_root_bridge_prepare                           | 20         | 19         |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 20         | 19         |
| backtrace:acpi_bus_scan                                   | 20         | 19         |
| backtrace:acpi_scan_init                                  | 20         | 19         |
| backtrace:acpi_init                                       | 20         | 19         |
| backtrace:kernel_init_freeable                            | 20         | 19         |
+-----------------------------------------------------------+------------+------------+

[    0.886041] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.888121] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.895383] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.896026] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
[    0.897000] IP: [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
[    0.897000] PGD 0 
[    0.897000] Oops: 0000 [#1] SMP 
[    0.897000] Modules linked in:
[    0.897000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc2-00030-g003b5e6 #712
[    0.897000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.897000] task: ffff88001e6c8000 ti: ffff88001e6c4000 task.ti: ffff88001e6c4000
[    0.897000] RIP: 0010:[<ffffffff819a9387>]  [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
[    0.897000] RSP: 0000:ffff88001e6c5c00  EFLAGS: 00010282
[    0.897000] RAX: 0000000000000000 RBX: ffff88001de68ee8 RCX: 0000000000000000
[    0.897000] RDX: 0000000000000498 RSI: ffff88001e6c87f0 RDI: ffff88001dfe5cd0
[    0.897000] RBP: ffff88001e6c5c90 R08: 00000000b0fa9e28 R09: 0000000000000001
[    0.897000] R10: 000000000000a1e0 R11: 0000000000000000 R12: ffff88001dfe5cd0
[    0.897000] R13: ffff88001de68f18 R14: 0000000000000000 R15: ffffffff821b1270
[    0.897000] FS:  0000000000000000(0000) GS:ffff88001ea00000(0000) knlGS:0000000000000000
[    0.897000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.897000] CR2: 00000000000000c8 CR3: 00000000020ae000 CR4: 00000000000006f0
[    0.897000] Stack:
[    0.897000]  ffffffff814b15dc ffff88001dfe6148 ffff88001e428000 ffff88001e6c5cc8
[    0.897000]  0000000000000000 ffff88001e6c5c90 ffffffff815f10ea ffffffff82026a3d
[    0.897000]  ffff88001e6c5c48 ffff880000000010 ffff88001e6c5ca0 ffff88001e6c5c60
[    0.897000] Call Trace:
[    0.897000]  [<ffffffff814b15dc>] ? pci_create_root_bus+0x7e/0x31e
[    0.897000]  [<ffffffff815f10ea>] ? dev_warn+0x5c/0x5e
[    0.897000]  [<ffffffff819a82be>] ? pci_mmconfig_insert+0xb2/0x1d0
[    0.897000]  [<ffffffff819a92d8>] pci_acpi_scan_root+0x30c/0x3aa
[    0.897000]  [<ffffffff814e0db9>] acpi_pci_root_add+0x25b/0x32f
[    0.897000]  [<ffffffff814dd3c9>] acpi_bus_attach+0x85/0xf4
[    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
[    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
[    0.897000]  [<ffffffff814dd493>] acpi_bus_scan+0x5b/0x6b
[    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
[    0.897000]  [<ffffffff82412ff2>] acpi_scan_init+0x60/0x18e
[    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
[    0.897000]  [<ffffffff82412e41>] acpi_init+0x23f/0x257
[    0.897000]  [<ffffffff810002b2>] do_one_initcall+0x84/0x11a
[    0.897000]  [<ffffffff81094152>] ? parse_args+0x189/0x249
[    0.897000]  [<ffffffff823cdf75>] kernel_init_freeable+0x1d8/0x25d
[    0.897000]  [<ffffffff823cd759>] ? do_early_param+0x88/0x88
[    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
[    0.897000]  [<ffffffff81ae8477>] kernel_init+0xe/0xda
[    0.897000]  [<ffffffff81b0f83c>] ret_from_fork+0x7c/0xb0
[    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
[    0.897000] Code: 71 b0 ff 48 8b 1b eb ee 48 83 c4 38 4c 89 e8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 48 8b 87 70 04 00 00 55 48 89 e5 5d <48> 8b 80 c8 00 00 00 48 8b 40 08 48 89 87 c0 03 00 00 31 c0 c3 
[    0.897000] RIP  [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
[    0.897000]  RSP <ffff88001e6c5c00>
[    0.897000] CR2: 00000000000000c8
[    0.897000] ---[ end trace 6110a1dd1810ff29 ]---
[    0.897033] swapper/0 (1) used greatest stack depth: 3816 bytes left

git bisect start eef38aacf67aae8b10c07c8b55b3f0fee627c8fa a79528e9d849803457b6235ddb1a1cfd4e11c6cd --
git bisect good f22b3e5788b29311219620adeb3edac565881241  # 09:02     20+      0  dts: versatile: add pci controller binding
git bisect  bad 36623599ba01b3aba32c615a210ce50e195204fa  # 09:04      0-     20  pci: Export find_pci_host_bridge() function.
git bisect good d5bb25094600d096be062f823109753c6b218400  # 09:12     20+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
git bisect  bad 003b5e6f33242288b3da627ac8a9fffdc61067a0  # 09:19      0-      7  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
# first bad commit: [003b5e6f33242288b3da627ac8a9fffdc61067a0] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
git bisect good d5bb25094600d096be062f823109753c6b218400  # 09:26     60+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
git bisect  bad eef38aacf67aae8b10c07c8b55b3f0fee627c8fa  # 09:26      0-     19  ARM: versatile: register sched_clock directly
git bisect good f217c44ebd41ce7369d2df07622b2839479183b0  # 09:33     60+      0  Merge tag 'trace-fixes-v3.14-rc7-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good 9eee0105595d9d1f3702d0e8d8cf4950e400ed0b  # 09:41     60+      0  Add linux-next specific files for 20140327

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
Fengguang

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-nfsroot-athens-23:20140328091949:x86_64-nfsroot:3.14.0-rc2-00030-g003b5e6:712"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-00030-g003b5e6 (kbuild@xian) (gcc v=
ersion 4.8.2 (Debian 4.8.2-16) ) #712 SMP Fri Mar 28 09:17:04 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::=
::nfsroot-athens-23::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,a=
ctimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/r=
un-queue/kvm/x86_64-nfsroot/robh:versatile:003b5e6f33242288b3da627ac8a9fffd=
c61067a0:bisect-linux6/.vmlinuz-003b5e6f33242288b3da627ac8a9fffdc61067a0-20=
140328091815-13-athens branch=3Drobh/versatile BOOT_IMAGE=3D/kernel/x86_64-=
nfsroot/003b5e6f33242288b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-00030-g=
003b5e6 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reser=
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
[    0.000000] e820: last_pfn =3D 0x1fffe max_arch_pfn =3D 0x400000000
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
[    0.000000] BRK [0x0305e000, 0x0305efff] PGTABLE
[    0.000000] BRK [0x0305f000, 0x0305ffff] PGTABLE
[    0.000000] BRK [0x03060000, 0x03060fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x03061000, 0x03061fff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 000040
[    0.000000] ACPI: SSDT 000000001ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1fff9000-0x1fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001ee0000=
0-ffff88001f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130972
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001ea00000 s1920896 r8=
192 d20608 u2097152
[    0.000000] pcpu-alloc: s1920896 r8192 d20608 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:1fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1ea0d200
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 128903
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
ip=3D::::nfsroot-athens-23::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,=
nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-=
tests/run-queue/kvm/x86_64-nfsroot/robh:versatile:003b5e6f33242288b3da627ac=
8a9fffdc61067a0:bisect-linux6/.vmlinuz-003b5e6f33242288b3da627ac8a9fffdc610=
67a0-20140328091815-13-athens branch=3Drobh/versatile BOOT_IMAGE=3D/kernel/=
x86_64-nfsroot/003b5e6f33242288b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-=
00030-g003b5e6 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 477860K/523888K available (11349K kernel code, 1360K=
 rwdata, 5668K rodata, 3340K init, 11356K bss, 46028K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-00030-g003b5e6 (kbuild@xian) (gcc v=
ersion 4.8.2 (Debian 4.8.2-16) ) #712 SMP Fri Mar 28 09:17:04 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::=
::nfsroot-athens-23::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,a=
ctimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/r=
un-queue/kvm/x86_64-nfsroot/robh:versatile:003b5e6f33242288b3da627ac8a9fffd=
c61067a0:bisect-linux6/.vmlinuz-003b5e6f33242288b3da627ac8a9fffdc61067a0-20=
140328091815-13-athens branch=3Drobh/versatile BOOT_IMAGE=3D/kernel/x86_64-=
nfsroot/003b5e6f33242288b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-00030-g=
003b5e6 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reser=
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
[    0.000000] e820: last_pfn =3D 0x1fffe max_arch_pfn =3D 0x400000000
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
[    0.000000] BRK [0x0305e000, 0x0305efff] PGTABLE
[    0.000000] BRK [0x0305f000, 0x0305ffff] PGTABLE
[    0.000000] BRK [0x03060000, 0x03060fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x03061000, 0x03061fff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 000040
[    0.000000] ACPI: SSDT 000000001ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1fff9000-0x1fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001ee0000=
0-ffff88001f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130972
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001ea00000 s1920896 r8=
192 d20608 u2097152
[    0.000000] pcpu-alloc: s1920896 r8192 d20608 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:1fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1ea0d200
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 128903
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
ip=3D::::nfsroot-athens-23::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,=
nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-=
tests/run-queue/kvm/x86_64-nfsroot/robh:versatile:003b5e6f33242288b3da627ac=
8a9fffdc61067a0:bisect-linux6/.vmlinuz-003b5e6f33242288b3da627ac8a9fffdc610=
67a0-20140328091815-13-athens branch=3Drobh/versatile BOOT_IMAGE=3D/kernel/=
x86_64-nfsroot/003b5e6f33242288b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-=
00030-g003b5e6 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 477860K/523888K available (11349K kernel code, 1360K=
 rwdata, 5668K rodata, 3340K init, 11356K bss, 46028K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.998 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5785.99 Bogo=
MIPS (lpj=3D2892998)
[    0.005013] pid_max: default: 32768 minimum: 301
[    0.008108] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.010810] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.011407] Mount-cache hash table entries: 256
[    0.016497] Initializing cgroup subsys debug
[    0.017034] Initializing cgroup subsys devices
[    0.019064] Initializing cgroup subsys freezer
[    0.020045] Initializing cgroup subsys blkio
[    0.022352] mce: CPU supports 10 MCE banks
[    0.023081] numa_add_cpu cpu 0 node 0: mask now 0
[    0.024017] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.024017] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.024017] tlb_flushall_shift: 6
[    0.026327] Freeing SMP alternatives memory: 40K (ffffffff8253b000 - fff=
fffff82545000)
[    0.038432] ftrace: allocating 44963 entries in 176 pages
[    0.055377] Getting VERSION: 50014
[    0.056019] Getting VERSION: 50014
[    0.057018] Getting ID: 0
[    0.058023] Getting ID: ff000000
[    0.059020] Getting LVT0: 8700
[    0.060014] Getting LVT1: 8400
[    0.061095] enabled ExtINT on CPU#0
[    0.063447] ENABLING IO-APIC IRQs
[    0.064016] init IO_APIC IRQs
[    0.065010]  apic 0 pin 0 not connected
[    0.066064] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.067049] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.068047] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.069043] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.070044] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.071043] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.072043] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.073041] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.074060] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.075044] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.076047] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.077049] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.078044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.079068] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.081083] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.082031]  apic 0 pin 16 not connected
[    0.083007]  apic 0 pin 17 not connected
[    0.084008]  apic 0 pin 18 not connected
[    0.085008]  apic 0 pin 19 not connected
[    0.086008]  apic 0 pin 20 not connected
[    0.087007]  apic 0 pin 21 not connected
[    0.088009]  apic 0 pin 22 not connected
[    0.089007]  apic 0 pin 23 not connected
[    0.090173] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.091006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.094007] Using local APIC timer interrupts.
[    0.094007] calibrating APIC timer ...
[    0.096000] ... lapic delta =3D 6248581
[    0.096000] ... PM-Timer delta =3D 357862
[    0.096000] ... PM-Timer result ok
[    0.096000] ..... delta 6248581
[    0.096000] ..... mult: 268374510
[    0.096000] ..... calibration result: 999772
[    0.096000] ..... CPU clock speed is 2892.0125 MHz.
[    0.096000] ..... host bus clock speed is 999.0772 MHz.
[    0.096133] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.103470] x86: Booting SMP configuration:
[    0.104008] .... node  #0, CPUs:      #1
[    0.004000] kvm-clock: cpu 1, msr 0:1fff8041, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.119207] x86: Booted up 1 node, 2 CPUs
[    0.119159] KVM setup async PF for cpu 1
[    0.119159] kvm-stealtime: cpu 1, msr 1ec0d200
[    0.121019] ----------------
[    0.122006] | NMI testsuite:
[    0.124005] --------------------
[    0.125005]   remote IPI:  ok  |
[    0.129006]    local IPI:  ok  |
[    0.136015] --------------------
[    0.137007] Good, all   2 testcases passed! |
[    0.138006] ---------------------------------
[    0.139009] smpboot: Total of 2 processors activated (11571.99 BogoMIPS)
[    0.142527] devtmpfs: initialized
[    0.157005] kworker/u4:0 (17) used greatest stack depth: 5456 bytes left
[    0.173713] xor: measuring software checksum speed
[    0.184028]    prefetch64-sse:   160.000 MB/sec
[    0.195028]    generic_sse:   156.000 MB/sec
[    0.196007] xor: using function: prefetch64-sse (160.000 MB/sec)
[    0.197016] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.199297] RTC time:  9:19:43, date: 03/28/14
[    0.201919] NET: Registered protocol family 16
[    0.205681] kworker/u4:0 (22) used greatest stack depth: 5232 bytes left
[    0.210858] cpuidle: using governor ladder
[    0.211011] cpuidle: using governor menu
[    0.213818] ACPI: bus type PCI registered
[    0.217057] dca service started, version 1.12.1
[    0.219200] PCI: Using configuration type 1 for base access
[    0.528077] bio: create slab <bio-0> at 0
[    0.547011] raid6: sse2x1    3843 MB/s
[    0.566018] raid6: sse2x2    6261 MB/s
[    0.584011] raid6: sse2x4    7074 MB/s
[    0.585009] raid6: using algorithm sse2x4 (7074 MB/s)
[    0.586006] raid6: using intx1 recovery algorithm
[    0.588667] ACPI: Added _OSI(Module Device)
[    0.589007] ACPI: Added _OSI(Processor Device)
[    0.590005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.591005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.661977] ACPI: Interpreter enabled
[    0.662038] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.665041] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.668222] ACPI: (supports S0 S3 S4 S5)
[    0.669008] ACPI: Using IOAPIC for interrupt routing
[    0.671255] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.695462] ACPI: No dock devices found.
[    0.885828] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.886041] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.888121] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.895383] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.896026] BUG: unable to handle kernel NULL pointer dereference at 000=
00000000000c8
[    0.897000] IP: [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x=
26
[    0.897000] PGD 0=20
[    0.897000] Oops: 0000 [#1] SMP=20
[    0.897000] Modules linked in:
[    0.897000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc2-00030-g=
003b5e6 #712
[    0.897000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.897000] task: ffff88001e6c8000 ti: ffff88001e6c4000 task.ti: ffff880=
01e6c4000
[    0.897000] RIP: 0010:[<ffffffff819a9387>]  [<ffffffff819a9387>] pcibios=
_root_bridge_prepare+0x11/0x26
[    0.897000] RSP: 0000:ffff88001e6c5c00  EFLAGS: 00010282
[    0.897000] RAX: 0000000000000000 RBX: ffff88001de68ee8 RCX: 00000000000=
00000
[    0.897000] RDX: 0000000000000498 RSI: ffff88001e6c87f0 RDI: ffff88001df=
e5cd0
[    0.897000] RBP: ffff88001e6c5c90 R08: 00000000b0fa9e28 R09: 00000000000=
00001
[    0.897000] R10: 000000000000a1e0 R11: 0000000000000000 R12: ffff88001df=
e5cd0
[    0.897000] R13: ffff88001de68f18 R14: 0000000000000000 R15: ffffffff821=
b1270
[    0.897000] FS:  0000000000000000(0000) GS:ffff88001ea00000(0000) knlGS:=
0000000000000000
[    0.897000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.897000] CR2: 00000000000000c8 CR3: 00000000020ae000 CR4: 00000000000=
006f0
[    0.897000] Stack:
[    0.897000]  ffffffff814b15dc ffff88001dfe6148 ffff88001e428000 ffff8800=
1e6c5cc8
[    0.897000]  0000000000000000 ffff88001e6c5c90 ffffffff815f10ea ffffffff=
82026a3d
[    0.897000]  ffff88001e6c5c48 ffff880000000010 ffff88001e6c5ca0 ffff8800=
1e6c5c60
[    0.897000] Call Trace:
[    0.897000]  [<ffffffff814b15dc>] ? pci_create_root_bus+0x7e/0x31e
[    0.897000]  [<ffffffff815f10ea>] ? dev_warn+0x5c/0x5e
[    0.897000]  [<ffffffff819a82be>] ? pci_mmconfig_insert+0xb2/0x1d0
[    0.897000]  [<ffffffff819a92d8>] pci_acpi_scan_root+0x30c/0x3aa
[    0.897000]  [<ffffffff814e0db9>] acpi_pci_root_add+0x25b/0x32f
[    0.897000]  [<ffffffff814dd3c9>] acpi_bus_attach+0x85/0xf4
[    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
[    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
[    0.897000]  [<ffffffff814dd493>] acpi_bus_scan+0x5b/0x6b
[    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
[    0.897000]  [<ffffffff82412ff2>] acpi_scan_init+0x60/0x18e
[    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
[    0.897000]  [<ffffffff82412e41>] acpi_init+0x23f/0x257
[    0.897000]  [<ffffffff810002b2>] do_one_initcall+0x84/0x11a
[    0.897000]  [<ffffffff81094152>] ? parse_args+0x189/0x249
[    0.897000]  [<ffffffff823cdf75>] kernel_init_freeable+0x1d8/0x25d
[    0.897000]  [<ffffffff823cd759>] ? do_early_param+0x88/0x88
[    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
[    0.897000]  [<ffffffff81ae8477>] kernel_init+0xe/0xda
[    0.897000]  [<ffffffff81b0f83c>] ret_from_fork+0x7c/0xb0
[    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
[    0.897000] Code: 71 b0 ff 48 8b 1b eb ee 48 83 c4 38 4c 89 e8 5b 41 5c =
41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 48 8b 87 70 04 00 00 55 48 89 e5 5d =
<48> 8b 80 c8 00 00 00 48 8b 40 08 48 89 87 c0 03 00 00 31 c0 c3=20
[    0.897000] RIP  [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0=
x26
[    0.897000]  RSP <ffff88001e6c5c00>
[    0.897000] CR2: 00000000000000c8
[    0.897000] ---[ end trace 6110a1dd1810ff29 ]---
[    0.897033] swapper/0 (1) used greatest stack depth: 3816 bytes left
[    0.898013] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    0.898013]=20
[    0.899000] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-nfsroot/00=
3b5e6f33242288b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-00030-g003b5e6 -a=
ppend 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Ddebug sy=
srq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlock=
up_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::nfsroot-athens-23::d=
hcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D600,nolock,rs=
ize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-queue/kvm/x86_64-nf=
sroot/robh:versatile:003b5e6f33242288b3da627ac8a9fffdc61067a0:bisect-linux6=
/.vmlinuz-003b5e6f33242288b3da627ac8a9fffdc61067a0-20140328091815-13-athens=
 branch=3Drobh/versatile BOOT_IMAGE=3D/kernel/x86_64-nfsroot/003b5e6f332422=
88b3da627ac8a9fffdc61067a0/vmlinuz-3.14.0-rc2-00030-g003b5e6 drbd.minor_cou=
nt=3D8'  -m 512 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,h=
ostfwd=3Dtcp::59209-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc=
 base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-nfsroot-athens-23,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-nfsroot-athens-23=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-nfsroot-athen=
s-23,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-nfsroot-a=
thens-23,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-nfsro=
ot-athens-23,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-n=
fsroot-athens-23,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-nfsro=
ot-athens-23 -serial file:/dev/shm/kboot/serial-nfsroot-athens-23 -daemoniz=
e -display none -monitor null=20

--EeQfGwPcQSOJBaQU
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-nfsroot-eef38aacf67aae8b10c07c8b55b3f0fee627c8fa-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-50590.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZWVmMzhhYS4uLiBBUk06IHZlcnNhdGlsZTogcmVnaXN0ZXIgc2No
ZWRfY2xvY2sgZGlyZWN0bHkKZ2l0IGNoZWNrb3V0IGE3OTUyOGU5ZDg0OTgwMzQ1N2I2MjM1
ZGRiMWExY2ZkNGUxMWM2Y2QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1uZnNyb290L3JvYmg6dmVyc2F0aWxlOmE3OTUyOGU5ZDg0OTgwMzQ1N2I2MjM1ZGRi
MWExY2ZkNGUxMWM2Y2Q6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0yOC0wNzo1NDo1MyBhNzk1
MjhlOWQ4NDk4MDM0NTdiNjIzNWRkYjFhMWNmZDRlMTFjNmNkIHJldXNlIC9rZXJuZWwveDg2
XzY0LW5mc3Jvb3QvYTc5NTI4ZTlkODQ5ODAzNDU3YjYyMzVkZGIxYTFjZmQ0ZTExYzZjZC92
bWxpbnV6LTMuMTQuMC1yYzItMDAwMTUtZ2E3OTUyOGUKCjIwMTQtMDMtMjgtMDc6NTQ6NTMg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4JMTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGE3
OTUyOGU5ZDg0OTgwMzQ1N2I2MjM1ZGRiMWExY2ZkNGUxMWM2Y2QKZ2l0IGJpc2VjdCBzdGFy
dCBlZWYzOGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZhIGE3OTUyOGU5ZDg0
OTgwMzQ1N2I2MjM1ZGRiMWExY2ZkNGUxMWM2Y2QgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVh
ci1iaXNlY3Q6IFsiLWIiLCAiZWVmMzhhYWNmNjdhYWU4YjEwYzA3YzhiNTViM2YwZmVlNjI3
YzhmYSIsICItZyIsICJhNzk1MjhlOWQ4NDk4MDM0NTdiNjIzNWRkYjFhMWNmZDRlMTFjNmNk
IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2tl
cm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMjMgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCltmMjJiM2U1Nzg4
YjI5MzExMjE5NjIwYWRlYjNlZGFjNTY1ODgxMjQxXSBkdHM6IHZlcnNhdGlsZTogYWRkIHBj
aSBjb250cm9sbGVyIGJpbmRpbmcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1uZnNyb290L3JvYmg6dmVy
c2F0aWxlOmYyMmIzZTU3ODhiMjkzMTEyMTk2MjBhZGViM2VkYWM1NjU4ODEyNDE6YmlzZWN0
LWxpbnV4NgoKMjAxNC0wMy0yOC0wODo0NzoyNSBmMjJiM2U1Nzg4YjI5MzExMjE5NjIwYWRl
YjNlZGFjNTY1ODgxMjQxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1uZnNyb290LWYyMmIzZTU3ODhiMjkzMTEyMTk2
MjBhZGViM2VkYWM1NjU4ODEyNDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1uZnNyb290L2YyMmIzZTU3ODhiMjkzMTEyMTk2MjBhZGViM2VkYWM1NjU4ODEyNDEKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1uZnNyb290LWYyMmIzZTU3ODhiMjkzMTEyMTk2MjBhZGViM2VkYWM1NjU4ODEyNDEKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZf
NjQtbmZzcm9vdC1mMjJiM2U1Nzg4YjI5MzExMjE5NjIwYWRlYjNlZGFjNTY1ODgxMjQxCmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9mMjJiM2U1Nzg4YjI5MzExMjE5NjIwYWRl
YjNlZGFjNTY1ODgxMjQxL3ZtbGludXotMy4xNC4wLXJjMi0wMDAyNi1nZjIyYjNlNQoKMjAx
NC0wMy0yOC0wODo1NjoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgk0CTE0CTE4Lgkx
OS4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzM2NjIzNTk5YmEwMWIzYWJhMzJjNjE1YTIx
MGNlNTBlMTk1MjA0ZmFdIHBjaTogRXhwb3J0IGZpbmRfcGNpX2hvc3RfYnJpZGdlKCkgZnVu
Y3Rpb24uCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbmZzcm9vdC9yb2JoOnZlcnNhdGlsZTozNjYyMzU5
OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhOmJpc2VjdC1saW51eDYKCjIwMTQt
MDMtMjgtMDk6MDI6MjUgMzY2MjM1OTliYTAxYjNhYmEzMmM2MTVhMjEwY2U1MGUxOTUyMDRm
YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtbmZzcm9vdC0zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5
NTIwNGZhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8zNjYy
MzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtbmZzcm9vdC0zNjYy
MzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LW5mc3Jvb3QtMzY2
MjM1OTliYTAxYjNhYmEzMmM2MTVhMjEwY2U1MGUxOTUyMDRmYQprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTliYTAxYjNhYmEzMmM2MTVhMjEwY2U1MGUxOTUyMDRm
YS92bWxpbnV6LTMuMTQuMC1yYzItMDAwMzItZzM2NjIzNTkKCjIwMTQtMDMtMjgtMDk6MDQ6
MjUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAxLjA0NzA0OF0g
YWNwaSBQTlAwQTAzOjAwOiBfT1NDOiBPUyBzdXBwb3J0cyBbU2VnbWVudHMgTVNJXQpbICAg
IDEuMDQ5MTIwXSBhY3BpIFBOUDBBMDM6MDA6IF9PU0MgZmFpbGVkIChBRV9OT1RfRk9VTkQp
OyBkaXNhYmxpbmcgQVNQTQpbICAgIDEuMDU4NjE3XSBhY3BpIFBOUDBBMDM6MDA6IGZhaWwg
dG8gYWRkIE1NQ09ORklHIGluZm9ybWF0aW9uLCBjYW4ndCBhY2Nlc3MgZXh0ZW5kZWQgUENJ
IGNvbmZpZ3VyYXRpb24gc3BhY2UgdW5kZXIgdGhpcyBicmlkZ2UuClsgICAgMS4wNTkwNDBd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNl
IGF0IDAwMDAwMDAwMDAwMDAwYzgKWyAgICAxLjA2MDAwMF0gSVA6IFs8ZmZmZmZmZmY4MTlh
OTQ0OD5dIHBjaWJpb3Nfcm9vdF9icmlkZ2VfcHJlcGFyZSsweDExLzB4MjYKWyAgICAxLjA2
MDAwMF0gUEdEIDAgClsgICAgMS4wNjAwMDBdIE9vcHM6IDAwMDAgWyMxXSBTTVAgClsgICAg
MS4wNjAwMDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuMDYwMDAwXSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmMyLTAwMDMyLWczNjYy
MzU5ICM3MTAKWyAgICAxLjA2MDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuMDYwMDAwXSB0YXNrOiBmZmZmODgwMDFlNmM4
MDAwIHRpOiBmZmZmODgwMDFlNmM0MDAwIHRhc2sudGk6IGZmZmY4ODAwMWU2YzQwMDAKWyAg
ICAxLjA2MDAwMF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTlhOTQ0OD5dICBbPGZmZmZmZmZm
ODE5YTk0NDg+XSBwY2liaW9zX3Jvb3RfYnJpZGdlX3ByZXBhcmUrMHgxMS8weDI2ClsgICAg
MS4wNjAwMDBdIFJTUDogMDAwMDpmZmZmODgwMDFlNmM1YmMwICBFRkxBR1M6IDAwMDEwMjgy
ClsgICAgMS4wNjAwMDBdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IDAwMDAwMDAwMDAw
MDAwMDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS4wNjAwMDBdIFJEWDogMDAwMDAw
MDAwMDAwMDRhMCBSU0k6IGZmZmY4ODAwMWU2Yzg3ZjAgUkRJOiBmZmZmODgwMDFkZmQ1Y2Qw
ClsgICAgMS4wNjAwMDBdIFJCUDogZmZmZjg4MDAxZTZjNWM1MCBSMDg6IDAwMDAwMDAwY2Q0
N2JhYTAgUjA5OiAwMDAwMDAwMDAwMDAwMDAxClsgICAgMS4wNjAwMDBdIFIxMDogMDAwMDAw
MDAwMDAwYTUwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgwMDFkZmQ1Y2Qw
ClsgICAgMS4wNjAwMDBdIFIxMzogZmZmZmZmZmY4MjFiMTI3MCBSMTQ6IDAwMDAwMDAwMDAw
MDAwMDAgUjE1OiBmZmZmODgwMDFkZmQ2MTUwClsgICAgMS4wNjAwMDBdIEZTOiAgMDAwMDAw
MDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDFlYTAwMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjA2MDAwMF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuMDYwMDAwXSBDUjI6IDAwMDAwMDAwMDAw
MDAwYzggQ1IzOiAwMDAwMDAwMDAyMGFlMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMApbICAg
IDEuMDYwMDAwXSBTdGFjazoKWyAgICAxLjA2MDAwMF0gIGZmZmZmZmZmODE0YjE1ZGEgMDAw
MDAwMDEwMDBkMDAwNSBmZmZmODgwMDFlNmM1Y2M4IGZmZmY4ODAwMWRlNzhmMTgKWyAgICAx
LjA2MDAwMF0gIDAwMDAwMDAwMDAwMDAyODIgZmZmZjg4MDAxZTZjNWMwOCBmZmZmODgwMDFk
ZmQ1Y2QwIGZmZmY4ODAwMWU0MDJkODAKWyAgICAxLjA2MDAwMF0gIGZmZmZmZmZmODE0YjE4
ZmEgZmZmZmVhMDAwMDc3ZjQwMCAwMDAwMDAwMDAwMDAwMjgyIGZmZmY4ODAwMWU2YzVjNTAK
WyAgICAxLjA2MDAwMF0gQ2FsbCBUcmFjZToKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4
MTRiMTVkYT5dID8gcGNpX2NyZWF0ZV9yb290X2J1c19pbl9kb21haW4rMHg3Yy8weDM1Nwpb
ICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZmZjgxNGIxOGZhPl0gPyBwY2lfY3JlYXRlX3Jvb3Rf
YnVzKzB4NDUvMHg3MApbICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZmZjgxMTc4MTMyPl0gPyBr
ZnJlZSsweDE1Ny8weDE5NgpbICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZmZjgxNGIxOTExPl0g
cGNpX2NyZWF0ZV9yb290X2J1cysweDVjLzB4NzAKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZm
ZmY4MTlhOTM5OT5dIHBjaV9hY3BpX3NjYW5fcm9vdCsweDMwYy8weDNhYQpbICAgIDEuMDYw
MDAwXSAgWzxmZmZmZmZmZjgxNGUwZTdhPl0gYWNwaV9wY2lfcm9vdF9hZGQrMHgyNWIvMHgz
MmYKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MTRkZDQ4YT5dIGFjcGlfYnVzX2F0dGFj
aCsweDg1LzB4ZjQKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MTRkZDRlNj5dIGFjcGlf
YnVzX2F0dGFjaCsweGUxLzB4ZjQKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MTRkZDRl
Nj5dIGFjcGlfYnVzX2F0dGFjaCsweGUxLzB4ZjQKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZm
ZmY4MTRkZDU1ND5dIGFjcGlfYnVzX3NjYW4rMHg1Yi8weDZiClsgICAgMS4wNjAwMDBdICBb
PGZmZmZmZmZmODI0MTJjMDI+XSA/IGFjcGlfc2xlZXBfcHJvY19pbml0KzB4MmEvMHgyYQpb
ICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZmZjgyNDEyZmYyPl0gYWNwaV9zY2FuX2luaXQrMHg2
MC8weDE4ZQpbICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZmZjgyNDEyYzAyPl0gPyBhY3BpX3Ns
ZWVwX3Byb2NfaW5pdCsweDJhLzB4MmEKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MjQx
MmU0MT5dIGFjcGlfaW5pdCsweDIzZi8weDI1NwpbICAgIDEuMDYwMDAwXSAgWzxmZmZmZmZm
ZjgxMDAwMmIyPl0gZG9fb25lX2luaXRjYWxsKzB4ODQvMHgxMWEKWyAgICAxLjA2MDAwMF0g
IFs8ZmZmZmZmZmY4MTA5NDE1Mj5dID8gcGFyc2VfYXJncysweDE4OS8weDI0OQpbICAgIDEu
MDYwMDAwXSAgWzxmZmZmZmZmZjgyM2NkZjc1Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgx
ZDgvMHgyNWQKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MjNjZDc1OT5dID8gZG9fZWFy
bHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMS4wNjAwMDBdICBbPGZmZmZmZmZmODFhZTg1Mjk+
XSA/IHJlc3RfaW5pdCsweGNkLzB4Y2QKWyAgICAxLjA2MDAwMF0gIFs8ZmZmZmZmZmY4MWFl
ODUzNz5dIGtlcm5lbF9pbml0KzB4ZS8weGRhClsgICAgMS4wNjAwMDBdICBbPGZmZmZmZmZm
ODFiMGY4ZmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuMDYwMDAwXSAgWzxm
ZmZmZmZmZjgxYWU4NTI5Pl0gPyByZXN0X2luaXQrMHhjZC8weGNkClsgICAgMS4wNjAwMDBd
IENvZGU6IDcwIGIwIGZmIDQ4IDhiIDFiIGViIGVlIDQ4IDgzIGM0IDM4IDRjIDg5IGU4IDVi
IDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIDVkIGMzIDBmIDFmIDQ0IDAwIDAwIDQ4IDhiIDg3
IDcwIDA0IDAwIDAwIDU1IDQ4IDg5IGU1IDVkIDw0OD4gOGIgODAgYzggMDAgMDAgMDAgNDgg
OGIgNDAgMDggNDggODkgODcgYzAgMDMgMDAgMDAgMzEgYzAgYzMgClsgICAgMS4wNjAwMDBd
IFJJUCAgWzxmZmZmZmZmZjgxOWE5NDQ4Pl0gcGNpYmlvc19yb290X2JyaWRnZV9wcmVwYXJl
KzB4MTEvMHgyNgpbICAgIDEuMDYwMDAwXSAgUlNQIDxmZmZmODgwMDFlNmM1YmMwPgpbICAg
IDEuMDYwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwYzgKWyAgICAxLjA2MDAwMF0gLS0tWyBl
bmQgdHJhY2UgMzJhNzlkYzA4NTI3M2U1ZiBdLS0tClsgICAgMS4wNjAwMjZdIHN3YXBwZXIv
MCAoMSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogMzgxNiBieXRlcyBsZWZ0Ci9rZXJu
ZWwveDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTliYTAxYjNhYmEzMmM2MTVhMjEwY2U1MGUxOTUy
MDRmYS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTE6MjAxNDAzMjgwOTA0MTY6eDg2XzY0LW5m
c3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZz
cm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXF1
YW50YWwtbGtwLXNiMDQtMzA6MjAxNDAzMjgwOTA0MTc6eDg2XzY0LW5mc3Jvb3Q6My4xNC4w
LXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5
OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXlvY3RvLWxrcC1zYjA0
LTE1OjIwMTQwMzI4MDkwNDE2Ong4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzItZzM2
NjIzNTk6NzEwCi9rZXJuZWwveDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTliYTAxYjNhYmEzMmM2
MTVhMjEwY2U1MGUxOTUyMDRmYS9kbWVzZy15b2N0by1sa3Atc2IwNC0xMzoyMDE0MDMyODA5
MDQxOTp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDMyLWczNjYyMzU5OjcxMAova2Vy
bmVsL3g4Nl82NC1uZnNyb290LzM2NjIzNTk5YmEwMWIzYWJhMzJjNjE1YTIxMGNlNTBlMTk1
MjA0ZmEvZG1lc2cteW9jdG8tbGtwLXNiMDQtMTc6MjAxNDAzMjgwOTA0MTg6eDg2XzY0LW5m
c3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZz
cm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXlv
Y3RvLWxrcC1zYjA0LTU6MjAxNDAzMjgwOTA0MTk6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJj
Mi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5OWJh
MDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLW5mc3Jvb3QtbGtwLWliMDQt
NDQ6MjAxNDAzMjgwOTA0MjQ6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2
MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYx
NWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMTQ6MjAxNDAzMjgw
OTA0MjY6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tl
cm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5
NTIwNGZhL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktMToyMDE0MDMyODA5MDQyNTp4ODZfNjQt
bmZzcm9vdDozLjE0LjAtcmMyLTAwMDMyLWczNjYyMzU5OjcxMAova2VybmVsL3g4Nl82NC1u
ZnNyb290LzM2NjIzNTk5YmEwMWIzYWJhMzJjNjE1YTIxMGNlNTBlMTk1MjA0ZmEvZG1lc2ct
eW9jdG8tbGtwLWliMDQtMTU6MjAxNDAzMjgwOTA0MjU6eDg2XzY0LW5mc3Jvb3Q6My4xNC4w
LXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5
OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXlvY3RvLWxrcC1pYjA0
LTQ1OjIwMTQwMzI4MDkwNDI1Ong4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzItZzM2
NjIzNTk6NzEwCi9rZXJuZWwveDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTliYTAxYjNhYmEzMmM2
MTVhMjEwY2U1MGUxOTUyMDRmYS9kbWVzZy15b2N0by1sa3AtaWIwNC03OToyMDE0MDMyODA5
MDQyNjp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDMyLWczNjYyMzU5OjcxMAova2Vy
bmVsL3g4Nl82NC1uZnNyb290LzM2NjIzNTk5YmEwMWIzYWJhMzJjNjE1YTIxMGNlNTBlMTk1
MjA0ZmEvZG1lc2cteW9jdG8tbGtwLWliMDQtODM6MjAxNDAzMjgwOTA0MjY6eDg2XzY0LW5m
c3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQtbmZz
cm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNnLXlv
Y3RvLWxrcC1pYjA0LTg1OjIwMTQwMzI4MDkwNDI3Ong4Nl82NC1uZnNyb290OjMuMTQuMC1y
YzItMDAwMzItZzM2NjIzNTk6NzEwCi9rZXJuZWwveDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTli
YTAxYjNhYmEzMmM2MTVhMjEwY2U1MGUxOTUyMDRmYS9kbWVzZy1xdWFudGFsLWxrcC1pYjA0
LTEwOjIwMTQwMzI4MDkwNDI5Ong4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzItZzM2
NjIzNTk6NzEwCi9rZXJuZWwveDg2XzY0LW5mc3Jvb3QvMzY2MjM1OTliYTAxYjNhYmEzMmM2
MTVhMjEwY2U1MGUxOTUyMDRmYS9kbWVzZy1xdWFudGFsLWxrcC1pYjA0LTI6MjAxNDAzMjgw
OTA0MzA6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tl
cm5lbC94ODZfNjQtbmZzcm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5
NTIwNGZhL2RtZXNnLXF1YW50YWwtbGtwLWliMDQtNDQ6MjAxNDAzMjgwOTA0Mjk6eDg2XzY0
LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMi1nMzY2MjM1OTo3MTAKL2tlcm5lbC94ODZfNjQt
bmZzcm9vdC8zNjYyMzU5OWJhMDFiM2FiYTMyYzYxNWEyMTBjZTUwZTE5NTIwNGZhL2RtZXNn
LXF1YW50YWwtbGtwLWliMDQtMzoyMDE0MDMyODA5MDQzMDp4ODZfNjQtbmZzcm9vdDozLjE0
LjAtcmMyLTAwMDMyLWczNjYyMzU5OjcxMAova2VybmVsL3g4Nl82NC1uZnNyb290LzM2NjIz
NTk5YmEwMWIzYWJhMzJjNjE1YTIxMGNlNTBlMTk1MjA0ZmEvZG1lc2ctcXVhbnRhbC1sa3At
aWIwNC03MToyMDE0MDMyODA5MDQzMDp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDMy
LWczNjYyMzU5OjcxMAova2VybmVsL3g4Nl82NC1uZnNyb290LzM2NjIzNTk5YmEwMWIzYWJh
MzJjNjE1YTIxMGNlNTBlMTk1MjA0ZmEvZG1lc2ctcXVhbnRhbC1sb3NsdW5hcy0xMToyMDE0
MDMyODA5MDQzODp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDMyLWczNjYyMzU5Ojcx
MAowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTI4
IDA5OjA0OjU2IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDYvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbZDViYjI1MDk0NjAwZDA5NmJlMDYy
ZjgyMzEwOTc1M2M2YjIxODQwMF0gcGNpOiBPRjogRml4IHRoZSBjb252ZXJzaW9uIG9mIElP
IHJhbmdlcyBpbnRvIElPIHJlc291cmNlcy4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1uZnNyb290L3Jv
Ymg6dmVyc2F0aWxlOmQ1YmIyNTA5NDYwMGQwOTZiZTA2MmY4MjMxMDk3NTNjNmIyMTg0MDA6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0yOC0wOTowNDo1NyBkNWJiMjUwOTQ2MDBkMDk2YmUw
NjJmODIzMTA5NzUzYzZiMjE4NDAwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1uZnNyb290LWQ1YmIyNTA5NDYwMGQw
OTZiZTA2MmY4MjMxMDk3NTNjNmIyMTg0MDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1uZnNyb290L2Q1YmIyNTA5NDYwMGQwOTZiZTA2MmY4MjMxMDk3NTNjNmIyMTg0
MDAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1uZnNyb290LWQ1YmIyNTA5NDYwMGQwOTZiZTA2MmY4MjMxMDk3NTNjNmIyMTg0
MDAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1uZnNyb290L2Q1YmIyNTA5NDYwMGQwOTZiZTA2
MmY4MjMxMDk3NTNjNmIyMTg0MDAvdm1saW51ei0zLjE0LjAtcmMyLTAwMDI5LWdkNWJiMjUw
CgoyMDE0LTAzLTI4LTA5OjA1OjU3IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uCTEJ
NQk5CTEyCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzAwM2I1ZTZmMzMyNDIyODhiM2Rh
NjI3YWM4YTlmZmZkYzYxMDY3YTBdIHBjaTogQ3JlYXRlIHBjaV9ob3N0X2JyaWRnZSBiZWZv
cmUgaXRzIGFzc29jaWF0ZWQgYnVzIGluIHBjaV9jcmVhdGVfcm9vdF9idXMuCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtbmZzcm9vdC9yb2JoOnZlcnNhdGlsZTowMDNiNWU2ZjMzMjQyMjg4YjNkYTYy
N2FjOGE5ZmZmZGM2MTA2N2EwOmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMjgtMDk6MTI6NTgg
MDAzYjVlNmYzMzI0MjI4OGIzZGE2MjdhYzhhOWZmZmRjNjEwNjdhMCBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtbmZz
cm9vdC0wMDNiNWU2ZjMzMjQyMjg4YjNkYTYyN2FjOGE5ZmZmZGM2MTA2N2EwCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8wMDNiNWU2ZjMzMjQyMjg4YjNk
YTYyN2FjOGE5ZmZmZGM2MTA2N2EwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtbmZzcm9vdC0wMDNiNWU2ZjMzMjQyMjg4YjNk
YTYyN2FjOGE5ZmZmZGM2MTA2N2EwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LW5mc3Jvb3QtMDAzYjVlNmYzMzI0MjI4OGIz
ZGE2MjdhYzhhOWZmZmRjNjEwNjdhMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LW5mc3Jvb3Qv
MDAzYjVlNmYzMzI0MjI4OGIzZGE2MjdhYzhhOWZmZmRjNjEwNjdhMC92bWxpbnV6LTMuMTQu
MC1yYzItMDAwMzAtZzAwM2I1ZTYKCjIwMTQtMDMtMjgtMDk6MTg6NTggZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4gVEVTVCBGQUlMVVJFClsgICAgMC45MDcwNjldIGFjcGkgUE5QMEEwMzow
MDogX09TQzogT1Mgc3VwcG9ydHMgW1NlZ21lbnRzIE1TSV0KWyAgICAwLjkwOTIxMF0gYWNw
aSBQTlAwQTAzOjAwOiBfT1NDIGZhaWxlZCAoQUVfTk9UX0ZPVU5EKTsgZGlzYWJsaW5nIEFT
UE0KWyAgICAwLjkxODYxOV0gYWNwaSBQTlAwQTAzOjAwOiBmYWlsIHRvIGFkZCBNTUNPTkZJ
RyBpbmZvcm1hdGlvbiwgY2FuJ3QgYWNjZXNzIGV4dGVuZGVkIFBDSSBjb25maWd1cmF0aW9u
IHNwYWNlIHVuZGVyIHRoaXMgYnJpZGdlLgpbICAgIDAuOTIyMDMxXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAw
MDAwMGM4ClsgICAgMC45MjMwMDBdIElQOiBbPGZmZmZmZmZmODE5YTkzODc+XSBwY2liaW9z
X3Jvb3RfYnJpZGdlX3ByZXBhcmUrMHgxMS8weDI2ClsgICAgMC45MjMwMDBdIFBHRCAwIApb
ICAgIDAuOTIzMDAwXSBPb3BzOiAwMDAwIFsjMV0gU01QIApbICAgIDAuOTIzMDAwXSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICAwLjkyMzAwMF0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2Fw
cGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjMi0wMDAzMC1nMDAzYjVlNiAjNzEyClsgICAg
MC45MjMwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICAwLjkyMzAwMF0gdGFzazogZmZmZjg4MDAxZTZjODAwMCB0aTogZmZmZjg4
MDAxZTZjNDAwMCB0YXNrLnRpOiBmZmZmODgwMDFlNmM0MDAwClsgICAgMC45MjMwMDBdIFJJ
UDogMDAxMDpbPGZmZmZmZmZmODE5YTkzODc+XSAgWzxmZmZmZmZmZjgxOWE5Mzg3Pl0gcGNp
Ymlvc19yb290X2JyaWRnZV9wcmVwYXJlKzB4MTEvMHgyNgpbICAgIDAuOTIzMDAwXSBSU1A6
IDAwMDA6ZmZmZjg4MDAxZTZjNWMwMCAgRUZMQUdTOiAwMDAxMDI4MgpbICAgIDAuOTIzMDAw
XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMDFkZTg0ZWU4IFJDWDogMDAw
MDAwMDAwMDAwMDAwMApbICAgIDAuOTIzMDAwXSBSRFg6IDAwMDAwMDAwMDAwMDA0OTggUlNJ
OiBmZmZmODgwMDFlNmM4N2YwIFJESTogZmZmZjg4MDAxZGZjZGNkMApbICAgIDAuOTIzMDAw
XSBSQlA6IGZmZmY4ODAwMWU2YzVjOTAgUjA4OiAwMDAwMDAwMGIwZmE5ZTI4IFIwOTogMDAw
MDAwMDAwMDAwMDAwMQpbICAgIDAuOTIzMDAwXSBSMTA6IDAwMDAwMDAwMDAwMGEzYzAgUjEx
OiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAxZGZjZGNkMApbICAgIDAuOTIzMDAw
XSBSMTM6IGZmZmY4ODAwMWRlODRmMTggUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogZmZm
ZmZmZmY4MjFiMTI3MApbICAgIDAuOTIzMDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAw
MCkgR1M6ZmZmZjg4MDAxZWMwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsg
ICAgMC45MjMwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAw
ODAwNTAwM2IKWyAgICAwLjkyMzAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMGM4IENSMzogMDAw
MDAwMDAwMjBhZTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZTAKWyAgICAwLjkyMzAwMF0gU3Rh
Y2s6ClsgICAgMC45MjMwMDBdICBmZmZmZmZmZjgxNGIxNWRjIGZmZmY4ODAwMWRmY2UxNDgg
ZmZmZjg4MDAxZTQyYTAwMCBmZmZmODgwMDFlNmM1Y2M4ClsgICAgMC45MjMwMDBdICAwMDAw
MDAwMDAwMDAwMDAwIGZmZmY4ODAwMWU2YzVjOTAgZmZmZmZmZmY4MTVmMTBlYSBmZmZmZmZm
ZjgyMDI2YTNkClsgICAgMC45MjMwMDBdICBmZmZmODgwMDFlNmM1YzQ4IGZmZmY4ODAwMDAw
MDAwMTAgZmZmZjg4MDAxZTZjNWNhMCBmZmZmODgwMDFlNmM1YzYwClsgICAgMC45MjMwMDBd
IENhbGwgVHJhY2U6ClsgICAgMC45MjMwMDBdICBbPGZmZmZmZmZmODE0YjE1ZGM+XSA/IHBj
aV9jcmVhdGVfcm9vdF9idXMrMHg3ZS8weDMxZQpbICAgIDAuOTIzMDAwXSAgWzxmZmZmZmZm
ZjgxNWYxMGVhPl0gPyBkZXZfd2FybisweDVjLzB4NWUKWyAgICAwLjkyMzAwMF0gIFs8ZmZm
ZmZmZmY4MTlhODJiZT5dID8gcGNpX21tY29uZmlnX2luc2VydCsweGIyLzB4MWQwClsgICAg
MC45MjMwMDBdICBbPGZmZmZmZmZmODE5YTkyZDg+XSBwY2lfYWNwaV9zY2FuX3Jvb3QrMHgz
MGMvMHgzYWEKWyAgICAwLjkyMzAwMF0gIFs8ZmZmZmZmZmY4MTRlMGRiOT5dIGFjcGlfcGNp
X3Jvb3RfYWRkKzB4MjViLzB4MzJmClsgICAgMC45MjMwMDBdICBbPGZmZmZmZmZmODE0ZGQz
Yzk+XSBhY3BpX2J1c19hdHRhY2grMHg4NS8weGY0ClsgICAgMC45MjMwMDBdICBbPGZmZmZm
ZmZmODE0ZGQ0MjU+XSBhY3BpX2J1c19hdHRhY2grMHhlMS8weGY0ClsgICAgMC45MjMwMDBd
ICBbPGZmZmZmZmZmODE0ZGQ0MjU+XSBhY3BpX2J1c19hdHRhY2grMHhlMS8weGY0ClsgICAg
MC45MjMwMDBdICBbPGZmZmZmZmZmODE0ZGQ0OTM+XSBhY3BpX2J1c19zY2FuKzB4NWIvMHg2
YgpbICAgIDAuOTIzMDAwXSAgWzxmZmZmZmZmZjgyNDEyYzAyPl0gPyBhY3BpX3NsZWVwX3By
b2NfaW5pdCsweDJhLzB4MmEKWyAgICAwLjkyMzAwMF0gIFs8ZmZmZmZmZmY4MjQxMmZmMj5d
IGFjcGlfc2Nhbl9pbml0KzB4NjAvMHgxOGUKWyAgICAwLjkyMzAwMF0gIFs8ZmZmZmZmZmY4
MjQxMmMwMj5dID8gYWNwaV9zbGVlcF9wcm9jX2luaXQrMHgyYS8weDJhClsgICAgMC45MjMw
MDBdICBbPGZmZmZmZmZmODI0MTJlNDE+XSBhY3BpX2luaXQrMHgyM2YvMHgyNTcKWyAgICAw
LjkyMzAwMF0gIFs8ZmZmZmZmZmY4MTAwMDJiMj5dIGRvX29uZV9pbml0Y2FsbCsweDg0LzB4
MTFhClsgICAgMC45MjMwMDBdICBbPGZmZmZmZmZmODEwOTQxNTI+XSA/IHBhcnNlX2FyZ3Mr
MHgxODkvMHgyNDkKWyAgICAwLjkyMzAwMF0gIFs8ZmZmZmZmZmY4MjNjZGY3NT5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MWQ4LzB4MjVkClsgICAgMC45MjMwMDBdICBbPGZmZmZmZmZm
ODIzY2Q3NTk+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAuOTIzMDAwXSAg
WzxmZmZmZmZmZjgxYWU4NDY5Pl0gPyByZXN0X2luaXQrMHhjZC8weGNkClsgICAgMC45MjMw
MDBdICBbPGZmZmZmZmZmODFhZTg0Nzc+XSBrZXJuZWxfaW5pdCsweGUvMHhkYQpbICAgIDAu
OTIzMDAwXSAgWzxmZmZmZmZmZjgxYjBmODNjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAK
WyAgICAwLjkyMzAwMF0gIFs8ZmZmZmZmZmY4MWFlODQ2OT5dID8gcmVzdF9pbml0KzB4Y2Qv
MHhjZApbICAgIDAuOTIzMDAwXSBDb2RlOiA3MSBiMCBmZiA0OCA4YiAxYiBlYiBlZSA0OCA4
MyBjNCAzOCA0YyA4OSBlOCA1YiA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyAwZiAx
ZiA0NCAwMCAwMCA0OCA4YiA4NyA3MCAwNCAwMCAwMCA1NSA0OCA4OSBlNSA1ZCA8NDg+IDhi
IDgwIGM4IDAwIDAwIDAwIDQ4IDhiIDQwIDA4IDQ4IDg5IDg3IGMwIDAzIDAwIDAwIDMxIGMw
IGMzIApbICAgIDAuOTIzMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MTlhOTM4Nz5dIHBjaWJpb3Nf
cm9vdF9icmlkZ2VfcHJlcGFyZSsweDExLzB4MjYKWyAgICAwLjkyMzAwMF0gIFJTUCA8ZmZm
Zjg4MDAxZTZjNWMwMD4KWyAgICAwLjkyMzAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMGM4Clsg
ICAgMC45MjMwMDBdIC0tLVsgZW5kIHRyYWNlIDRkNDk4YTY3ODg3MmI4MjEgXS0tLQpbICAg
IDEuMDE1MDI4XSBzd2FwcGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDM4
MTYgYnl0ZXMgbGVmdAova2VybmVsL3g4Nl82NC1uZnNyb290LzAwM2I1ZTZmMzMyNDIyODhi
M2RhNjI3YWM4YTlmZmZkYzYxMDY3YTAvZG1lc2ctbmZzcm9vdC1hdGhlbnMtMzI6MjAxNDAz
MjgwOTE5Mzk6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMC1nMDAzYjVlNjo3MTIK
L2tlcm5lbC94ODZfNjQtbmZzcm9vdC8wMDNiNWU2ZjMzMjQyMjg4YjNkYTYyN2FjOGE5ZmZm
ZGM2MTA2N2EwL2RtZXNnLXF1YW50YWwtYXRoZW5zLTIyOjIwMTQwMzI4MDkxOTM4Ong4Nl82
NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzAtZzAwM2I1ZTY6NzEyCi9rZXJuZWwveDg2XzY0
LW5mc3Jvb3QvMDAzYjVlNmYzMzI0MjI4OGIzZGE2MjdhYzhhOWZmZmRjNjEwNjdhMC9kbWVz
Zy1uZnNyb290LWF0aGVucy0xNDoyMDE0MDMyODA5MTk0Nzp4ODZfNjQtbmZzcm9vdDozLjE0
LjAtcmMyLTAwMDMwLWcwMDNiNWU2OjcxMgova2VybmVsL3g4Nl82NC1uZnNyb290LzAwM2I1
ZTZmMzMyNDIyODhiM2RhNjI3YWM4YTlmZmZkYzYxMDY3YTAvZG1lc2ctbmZzcm9vdC1hdGhl
bnMtMjM6MjAxNDAzMjgwOTE5NDk6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzMC1n
MDAzYjVlNjo3MTIKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC8wMDNiNWU2ZjMzMjQyMjg4YjNk
YTYyN2FjOGE5ZmZmZGM2MTA2N2EwL2RtZXNnLW5mc3Jvb3QtYXRoZW5zLTMyOjIwMTQwMzI4
MDkxOTUxOng4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzAtZzAwM2I1ZTY6NzEyCi9r
ZXJuZWwveDg2XzY0LW5mc3Jvb3QvMDAzYjVlNmYzMzI0MjI4OGIzZGE2MjdhYzhhOWZmZmRj
NjEwNjdhMC9kbWVzZy1uZnNyb290LXhpYW4tMTE6MjAxNDAzMjgwOTE5NDE6eDg2XzY0LW5m
c3Jvb3Q6My4xNC4wLXJjMi0wMDAzMC1nMDAzYjVlNjo3MTIKL2tlcm5lbC94ODZfNjQtbmZz
cm9vdC8wMDNiNWU2ZjMzMjQyMjg4YjNkYTYyN2FjOGE5ZmZmZGM2MTA2N2EwL2RtZXNnLXF1
YW50YWwtYXRoZW5zLTIyOjIwMTQwMzI4MDkxOTUwOng4Nl82NC1uZnNyb290OjMuMTQuMC1y
YzItMDAwMzAtZzAwM2I1ZTY6NzEyCjA6Nzo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTAzLTI4IDA5OjIwOjAwIFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5l
bC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKMDAzYjVlNmYzMzI0MjI4
OGIzZGE2MjdhYzhhOWZmZmRjNjEwNjdhMCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21t
aXQgMDAzYjVlNmYzMzI0MjI4OGIzZGE2MjdhYzhhOWZmZmRjNjEwNjdhMApBdXRob3I6ICAg
ICBMaXZpdSBEdWRhdSA8TGl2aXUuRHVkYXVAYXJtLmNvbT4KQXV0aG9yRGF0ZTogRnJpIE1h
ciAxNCAxNTozNDoyOSAyMDE0ICswMDAwCkNvbW1pdDogICAgIFJvYiBIZXJyaW5nIDxyb2Jo
QGtlcm5lbC5vcmc+CkNvbW1pdERhdGU6IFRodSBNYXIgMjcgMTc6MDA6NTcgMjAxNCAtMDUw
MAoKICAgIHBjaTogQ3JlYXRlIHBjaV9ob3N0X2JyaWRnZSBiZWZvcmUgaXRzIGFzc29jaWF0
ZWQgYnVzIGluIHBjaV9jcmVhdGVfcm9vdF9idXMuCiAgICAKICAgIEJlZm9yZSBjb21taXQg
N2I1NDM2NjM1ODAwIHRoZSBwY2lfaG9zdF9icmlkZ2Ugd2FzIGNyZWF0ZWQgYmVmb3JlIHRo
ZSByb290IGJ1cy4KICAgIEFzIHRoYXQgY29tbWl0IGhhcyBhZGRlZCBhIG5lZWRsZXNzIGRl
cGVuZGVuY3kgb24gdGhlIGJ1cyBmb3IgcGNpX2FsbG9jX2hvc3RfYnJpZGdlKCkKICAgIHRo
ZSBjcmVhdGlvbiBvcmRlciBoYXMgYmVlbiBjaGFuZ2VkIGZvciBubyBnb29kIHJlYXNvbi4g
UmV2ZXJ0IHRoZSBvcmRlciBvZgogICAgY3JlYXRpb24gYXMgd2UgYXJlIGdvaW5nIHRvIGRl
cGVuZCBvbiB0aGUgcGNpX2hvc3RfYnJpZGdlIHN0cnVjdHVyZSB0byByZXRyaWV2ZSB0aGUK
ICAgIGRvbWFpbiBudW1iZXIgb2YgdGhlIHJvb3QgYnVzLgogICAgCiAgICBTaWduZWQtb2Zm
LWJ5OiBMaXZpdSBEdWRhdSA8TGl2aXUuRHVkYXVAYXJtLmNvbT4KICAgIEFja2VkLWJ5OiBH
cmFudCBMaWtlbHkgPGdyYW50Lmxpa2VseUBsaW5hcm8ub3JnPgogICAgVGVzdGVkLWJ5OiBU
YW5tYXkgSW5hbWRhciA8dGluYW1kYXJAYXBtLmNvbT4KCiBkcml2ZXJzL3BjaS9wcm9iZS5j
IHwgMzYgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDAwM2I1ZTYuLi4gcGNpOiBDcmVhdGUgcGNpX2hvc3RfYnJpZGdlIGJl
Zm9yZSBpdHMgYXNzb2NpYXRlZCBidXMgaW4gcGNpX2NyZWF0ZV9yb290X2J1cy4KSEVBRCBp
cyBub3cgYXQgZDViYjI1MC4uLiBwY2k6IE9GOiBGaXggdGhlIGNvbnZlcnNpb24gb2YgSU8g
cmFuZ2VzIGludG8gSU8gcmVzb3VyY2VzLgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LW5mc3Jvb3Qvcm9iaDp2ZXJzYXRpbGU6ZDViYjI1MDk0NjAwZDA5NmJl
MDYyZjgyMzEwOTc1M2M2YjIxODQwMDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTI4LTA5OjIw
OjAxIGQ1YmIyNTA5NDYwMGQwOTZiZTA2MmY4MjMxMDk3NTNjNmIyMTg0MDAgcmV1c2UgL2tl
cm5lbC94ODZfNjQtbmZzcm9vdC9kNWJiMjUwOTQ2MDBkMDk2YmUwNjJmODIzMTA5NzUzYzZi
MjE4NDAwL3ZtbGludXotMy4xNC4wLXJjMi0wMDAyOS1nZDViYjI1MAoKMjAxNC0wMy0yOC0w
OToyMDowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTIxCTI5CTMxCTQ3CTQ4CTQ5CTUz
CTYwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGQ1YmIyNTAuLi4gcGNp
OiBPRjogRml4IHRoZSBjb252ZXJzaW9uIG9mIElPIHJhbmdlcyBpbnRvIElPIHJlc291cmNl
cy4KSEVBRCBpcyBub3cgYXQgZWVmMzhhYS4uLiBBUk06IHZlcnNhdGlsZTogcmVnaXN0ZXIg
c2NoZWRfY2xvY2sgZGlyZWN0bHkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1uZnNyb290L3JvYmg6dmVyc2F0aWxlOmVlZjM4YWFjZjY3YWFlOGIxMGMwN2M4
YjU1YjNmMGZlZTYyN2M4ZmE6YmlzZWN0LWxpbnV4NgogVEVTVCBGQUlMVVJFClsgICAgMS4x
NDgwNDhdIGFjcGkgUE5QMEEwMzowMDogX09TQzogT1Mgc3VwcG9ydHMgW1NlZ21lbnRzIE1T
SV0KWyAgICAxLjE0OTIyOF0gYWNwaSBQTlAwQTAzOjAwOiBfT1NDIGZhaWxlZCAoQUVfTk9U
X0ZPVU5EKTsgZGlzYWJsaW5nIEFTUE0KWyAgICAxLjE1ODczOF0gYWNwaSBQTlAwQTAzOjAw
OiBmYWlsIHRvIGFkZCBNTUNPTkZJRyBpbmZvcm1hdGlvbiwgY2FuJ3QgYWNjZXNzIGV4dGVu
ZGVkIFBDSSBjb25maWd1cmF0aW9uIHNwYWNlIHVuZGVyIHRoaXMgYnJpZGdlLgpbICAgIDEu
MTU5MDM5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJl
ZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwMGM4ClsgICAgMS4xNjAwMDBdIElQOiBbPGZmZmZm
ZmZmODE5YTk0NDg+XSBwY2liaW9zX3Jvb3RfYnJpZGdlX3ByZXBhcmUrMHgxMS8weDI2Clsg
ICAgMS4xNjAwMDBdIFBHRCAwIApbICAgIDEuMTYwMDAwXSBPb3BzOiAwMDAwIFsjMV0gU01Q
IApbICAgIDEuMTYwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjE2MDAwMF0gQ1BV
OiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjMi0wMDAz
OC1nZWVmMzhhYSAjNzA2ClsgICAgMS4xNjAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjE2MDAwMF0gdGFzazogZmZmZjg4
MDAxZTZjODAwMCB0aTogZmZmZjg4MDAxZTZjNDAwMCB0YXNrLnRpOiBmZmZmODgwMDFlNmM0
MDAwClsgICAgMS4xNjAwMDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODE5YTk0NDg+XSAgWzxm
ZmZmZmZmZjgxOWE5NDQ4Pl0gcGNpYmlvc19yb290X2JyaWRnZV9wcmVwYXJlKzB4MTEvMHgy
NgpbICAgIDEuMTYwMDAwXSBSU1A6IDAwMDA6ZmZmZjg4MDAxZTZjNWJjMCAgRUZMQUdTOiAw
MDAxMDI4MgpbICAgIDEuMTYwMDAwXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAw
MDAwMDAwMDAwMDAwIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuMTYwMDAwXSBSRFg6
IDAwMDAwMDAwMDAwMDA0YTggUlNJOiBmZmZmODgwMDFlNmM4N2YwIFJESTogZmZmZjg4MDAx
ZGZlNWNkMApbICAgIDEuMTYwMDAwXSBSQlA6IGZmZmY4ODAwMWU2YzVjNTAgUjA4OiAwMDAw
MDAwMGIwZmE5ZTI4IFIwOTogMDAwMDAwMDAwMDAwMDAwMQpbICAgIDEuMTYwMDAwXSBSMTA6
IDAwMDAwMDAwMDAwMGEzYzAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAx
ZGZlNWNkMApbICAgIDEuMTYwMDAwXSBSMTM6IGZmZmZmZmZmODIxYjEyNzAgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogZmZmZjg4MDAxZGZlNjE1OApbICAgIDEuMTYwMDAwXSBGUzog
IDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxZWEwMDAwMCgwMDAwKSBrbmxH
UzowMDAwMDAwMDAwMDAwMDAwClsgICAgMS4xNjAwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAxLjE2MDAwMF0gQ1IyOiAwMDAw
MDAwMDAwMDAwMGM4IENSMzogMDAwMDAwMDAwMjBhZTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2
ZjAKWyAgICAxLjE2MDAwMF0gU3RhY2s6ClsgICAgMS4xNjAwMDBdICBmZmZmZmZmZjgxNGIx
NWRhIDAwMDAwMDAxMDAwZDAwMDUgZmZmZjg4MDAxZTZjNWNjOCBmZmZmODgwMDFkZTg0ZjE4
ClsgICAgMS4xNjAwMDBdICAwMDAwMDAwMDAwMDAwMjgyIGZmZmY4ODAwMWU2YzVjMDggZmZm
Zjg4MDAxZGZlNWNkMCBmZmZmODgwMDFlNDAyZDgwClsgICAgMS4xNjAwMDBdICBmZmZmZmZm
ZjgxNGIxOGZhIGZmZmZlYTAwMDA3N2Y4MDAgMDAwMDAwMDAwMDAwMDI4MiBmZmZmODgwMDFl
NmM1YzUwClsgICAgMS4xNjAwMDBdIENhbGwgVHJhY2U6ClsgICAgMS4xNjAwMDBdICBbPGZm
ZmZmZmZmODE0YjE1ZGE+XSA/IHBjaV9jcmVhdGVfcm9vdF9idXNfaW5fZG9tYWluKzB4N2Mv
MHgzNTcKWyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MTRiMThmYT5dID8gcGNpX2NyZWF0
ZV9yb290X2J1cysweDQ1LzB4NzAKWyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MTE3ODEz
Mj5dID8ga2ZyZWUrMHgxNTcvMHgxOTYKWyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MTRi
MTkxMT5dIHBjaV9jcmVhdGVfcm9vdF9idXMrMHg1Yy8weDcwClsgICAgMS4xNjAwMDBdICBb
PGZmZmZmZmZmODE5YTkzOTk+XSBwY2lfYWNwaV9zY2FuX3Jvb3QrMHgzMGMvMHgzYWEKWyAg
ICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MTRlMGU3YT5dIGFjcGlfcGNpX3Jvb3RfYWRkKzB4
MjViLzB4MzJmClsgICAgMS4xNjAwMDBdICBbPGZmZmZmZmZmODE0ZGQ0OGE+XSBhY3BpX2J1
c19hdHRhY2grMHg4NS8weGY0ClsgICAgMS4xNjAwMDBdICBbPGZmZmZmZmZmODE0ZGQ0ZTY+
XSBhY3BpX2J1c19hdHRhY2grMHhlMS8weGY0ClsgICAgMS4xNjAwMDBdICBbPGZmZmZmZmZm
ODE0ZGQ0ZTY+XSBhY3BpX2J1c19hdHRhY2grMHhlMS8weGY0ClsgICAgMS4xNjAwMDBdICBb
PGZmZmZmZmZmODE0ZGQ1NTQ+XSBhY3BpX2J1c19zY2FuKzB4NWIvMHg2YgpbICAgIDEuMTYw
MDAwXSAgWzxmZmZmZmZmZjgyNDEyYzAyPl0gPyBhY3BpX3NsZWVwX3Byb2NfaW5pdCsweDJh
LzB4MmEKWyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MjQxMmZmMj5dIGFjcGlfc2Nhbl9p
bml0KzB4NjAvMHgxOGUKWyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MjQxMmMwMj5dID8g
YWNwaV9zbGVlcF9wcm9jX2luaXQrMHgyYS8weDJhClsgICAgMS4xNjAwMDBdICBbPGZmZmZm
ZmZmODI0MTJlNDE+XSBhY3BpX2luaXQrMHgyM2YvMHgyNTcKWyAgICAxLjE2MDAwMF0gIFs8
ZmZmZmZmZmY4MTAwMDJiMj5dIGRvX29uZV9pbml0Y2FsbCsweDg0LzB4MTFhClsgICAgMS4x
NjAwMDBdICBbPGZmZmZmZmZmODEwOTQxNTI+XSA/IHBhcnNlX2FyZ3MrMHgxODkvMHgyNDkK
WyAgICAxLjE2MDAwMF0gIFs8ZmZmZmZmZmY4MjNjZGY3NT5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MWQ4LzB4MjVkClsgICAgMS4xNjAwMDBdICBbPGZmZmZmZmZmODIzY2Q3NTk+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDEuMTYwMDAwXSAgWzxmZmZmZmZmZjgx
YWU4NTI5Pl0gPyByZXN0X2luaXQrMHhjZC8weGNkClsgICAgMS4xNjAwMDBdICBbPGZmZmZm
ZmZmODFhZTg1Mzc+XSBrZXJuZWxfaW5pdCsweGUvMHhkYQpbICAgIDEuMTYwMDAwXSAgWzxm
ZmZmZmZmZjgxYjBmOGZjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAxLjE2MDAw
MF0gIFs8ZmZmZmZmZmY4MWFlODUyOT5dID8gcmVzdF9pbml0KzB4Y2QvMHhjZApbICAgIDEu
MTYwMDAwXSBDb2RlOiA3MCBiMCBmZiA0OCA4YiAxYiBlYiBlZSA0OCA4MyBjNCAzOCA0YyA4
OSBlOCA1YiA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyAwZiAxZiA0NCAwMCAwMCA0
OCA4YiA4NyA3MCAwNCAwMCAwMCA1NSA0OCA4OSBlNSA1ZCA8NDg+IDhiIDgwIGM4IDAwIDAw
IDAwIDQ4IDhiIDQwIDA4IDQ4IDg5IDg3IGMwIDAzIDAwIDAwIDMxIGMwIGMzIApbICAgIDEu
MTYwMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MTlhOTQ0OD5dIHBjaWJpb3Nfcm9vdF9icmlkZ2Vf
cHJlcGFyZSsweDExLzB4MjYKWyAgICAxLjE2MDAwMF0gIFJTUCA8ZmZmZjg4MDAxZTZjNWJj
MD4KWyAgICAxLjE2MDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMGM4ClsgICAgMS4xNjAwMDBd
IC0tLVsgZW5kIHRyYWNlIDJlNzA0Njk5ZDFkMmI4MWMgXS0tLQpbICAgIDEuMTYwMDMxXSBz
d2FwcGVyLzAgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDM4MTYgYnl0ZXMgbGVm
dAova2VybmVsL3g4Nl82NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIxMGMwN2M4YjU1YjNm
MGZlZTYyN2M4ZmEvZG1lc2ctbmZzcm9vdC14aWFuLTE5OjIwMTQwMzI4MDc1NDUzOng4Nl82
NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzgtZ2VlZjM4YWE6NzA2Ci9rZXJuZWwveDg2XzY0
LW5mc3Jvb3QvZWVmMzhhYWNmNjdhYWU4YjEwYzA3YzhiNTViM2YwZmVlNjI3YzhmYS9kbWVz
Zy15b2N0by1sa3AtaWIwNC0yNToyMDE0MDMyODA3NDcyMzp4ODZfNjQtbmZzcm9vdDozLjE0
LjAtcmMyLTAwMDM4LWdlZWYzOGFhOjcwNgova2VybmVsL3g4Nl82NC1uZnNyb290L2VlZjM4
YWFjZjY3YWFlOGIxMGMwN2M4YjU1YjNmMGZlZTYyN2M4ZmEvZG1lc2ctcXVhbnRhbC1sa3At
aWIwNC00NjoyMDE0MDMyODA3NDcxNTp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDM4
LWdlZWYzOGFhOjcwNgova2VybmVsL3g4Nl82NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIx
MGMwN2M4YjU1YjNmMGZlZTYyN2M4ZmEvZG1lc2ctbmZzcm9vdC1yb2FtLTI3OjIwMTQwMzI4
MDc1NDQxOng4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzgtZ2VlZjM4YWE6NzA2Ci9r
ZXJuZWwveDg2XzY0LW5mc3Jvb3QvZWVmMzhhYWNmNjdhYWU4YjEwYzA3YzhiNTViM2YwZmVl
NjI3YzhmYS9kbWVzZy1xdWFudGFsLWxrcC1pYjA0LTU2OjIwMTQwMzI4MDc0NzMxOng4Nl82
NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzgtZ2VlZjM4YWE6NzA2Ci9rZXJuZWwveDg2XzY0
LW5mc3Jvb3QvZWVmMzhhYWNmNjdhYWU4YjEwYzA3YzhiNTViM2YwZmVlNjI3YzhmYS9kbWVz
Zy1uZnNyb290LXJvYW0tMTY6MjAxNDAzMjgwNzU0NTA6eDg2XzY0LW5mc3Jvb3Q6My4xNC4w
LXJjMi0wMDAzOC1nZWVmMzhhYTo3MDYKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9lZWYzOGFh
Y2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZhL2RtZXNnLW5mc3Jvb3QtaXZ5dG93
bjItNDoyMDE0MDMyODA3NTQ1NDp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDM4LWdl
ZWYzOGFhOjcwNgova2VybmVsL3g4Nl82NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIxMGMw
N2M4YjU1YjNmMGZlZTYyN2M4ZmEvZG1lc2ctbmZzcm9vdC1hdGhlbnMtODoyMDE0MDMyODA3
NTQ1NTp4ODZfNjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDM4LWdlZWYzOGFhOjcwNgova2Vy
bmVsL3g4Nl82NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIxMGMwN2M4YjU1YjNmMGZlZTYy
N2M4ZmEvZG1lc2ctbmZzcm9vdC1pbm4tMTQ6MjAxNDAzMjgwNzU0Mzk6eDg2XzY0LW5mc3Jv
b3Q6Ogova2VybmVsL3g4Nl82NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIxMGMwN2M4YjU1
YjNmMGZlZTYyN2M4ZmEvZG1lc2cteW9jdG8tbGtwLWliMDQtNDY6MjAxNDAzMjgwNzQ3MjY6
eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzOC1nZWVmMzhhYTo3MDYKL2tlcm5lbC94
ODZfNjQtbmZzcm9vdC9lZWYzOGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZh
L2RtZXNnLW5mc3Jvb3QtY2Fpcm8tOToyMDE0MDMyODA3NTQ1NTp4ODZfNjQtbmZzcm9vdDoz
LjE0LjAtcmMyLTAwMDM4LWdlZWYzOGFhOjcwNgova2VybmVsL3g4Nl82NC1uZnNyb290L2Vl
ZjM4YWFjZjY3YWFlOGIxMGMwN2M4YjU1YjNmMGZlZTYyN2M4ZmEvZG1lc2cteW9jdG8tbGtw
LWliMDQtNzE6MjAxNDAzMjgwNzQ3MjQ6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAz
OC1nZWVmMzhhYTo3MDYKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9lZWYzOGFhY2Y2N2FhZThi
MTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZhL2RtZXNnLW5mc3Jvb3QtbGtwLWliMDQtMzM6MjAx
NDAzMjgwNzU0NTA6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzOC1nZWVmMzhhYTo3
MDYKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9lZWYzOGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIz
ZjBmZWU2MjdjOGZhL2RtZXNnLW5mc3Jvb3Qtcm9hbS0xMzoyMDE0MDMyODA3NTQ1NTp4ODZf
NjQtbmZzcm9vdDozLjE0LjAtcmMyLTAwMDM4LWdlZWYzOGFhOjcwNgova2VybmVsL3g4Nl82
NC1uZnNyb290L2VlZjM4YWFjZjY3YWFlOGIxMGMwN2M4YjU1YjNmMGZlZTYyN2M4ZmEvZG1l
c2cteW9jdG8tbGtwLWliMDQtNjM6MjAxNDAzMjgwNzQ3MjQ6eDg2XzY0LW5mc3Jvb3Q6My4x
NC4wLXJjMi0wMDAzOC1nZWVmMzhhYTo3MDYKL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9lZWYz
OGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZhL2RtZXNnLXlvY3RvLWxrcC1p
YjA0LTYyOjIwMTQwMzI4MDc0NzIzOng4Nl82NC1uZnNyb290OjMuMTQuMC1yYzItMDAwMzgt
Z2VlZjM4YWE6NzA2Ci9rZXJuZWwveDg2XzY0LW5mc3Jvb3QvZWVmMzhhYWNmNjdhYWU4YjEw
YzA3YzhiNTViM2YwZmVlNjI3YzhmYS9kbWVzZy1uZnNyb290LXJvYW0tMTY6MjAxNDAzMjgw
NzU0MzE6eDg2XzY0LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzOC1nZWVmMzhhYTo3MDYKL2tl
cm5lbC94ODZfNjQtbmZzcm9vdC9lZWYzOGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2
MjdjOGZhL2RtZXNnLXF1YW50YWwtbGtwLWliMDQtODI6MjAxNDAzMjgwNzQ3MzE6eDg2XzY0
LW5mc3Jvb3Q6My4xNC4wLXJjMi0wMDAzOC1nZWVmMzhhYTo3MDYKL2tlcm5lbC94ODZfNjQt
bmZzcm9vdC9lZWYzOGFhY2Y2N2FhZThiMTBjMDdjOGI1NWIzZjBmZWU2MjdjOGZhL2RtZXNn
LXlvY3RvLWxrcC1pYjA0LTUwOjIwMTQwMzI4MDc0NzEwOng4Nl82NC1uZnNyb290OjMuMTQu
MC1yYzItMDAwMzgtZ2VlZjM4YWE6NzA2CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkhFQUQgaXMgbm93IGF0IGVlZjM4YWEgQVJNOiB2ZXJzYXRpbGU6IHJlZ2lzdGVy
IHNjaGVkX2Nsb2NrIGRpcmVjdGx5Cgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CmFs
cmVhZHlfdXB0b2RhdGU6IG5vIGNvbW1pdHMgZmlsZSAva2VybmVsLXRlc3RzL2NvbW1pdC1s
aXN0L2xpbnVzOm1hc3RlcjogZm9yIGxpbnVzL21hc3RlcgpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyBlZWYzOGFhLi4uIEFSTTogdmVyc2F0aWxlOiByZWdpc3RlciBzY2hlZF9jbG9j
ayBkaXJlY3RseQpIRUFEIGlzIG5vdyBhdCBmMjE3YzQ0Li4uIE1lcmdlIHRhZyAndHJhY2Ut
Zml4ZXMtdjMuMTQtcmM3LXYyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC10cmFjZQpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LW5mc3Jvb3Qvcm9iaDp2ZXJzYXRpbGU6ZjIxN2M0NGVi
ZDQxY2U3MzY5ZDJkZjA3NjIyYjI4Mzk0NzkxODNiMDpiaXNlY3QtbGludXg2CgoyMDE0LTAz
LTI4LTA5OjI2OjA1IGYyMTdjNDRlYmQ0MWNlNzM2OWQyZGYwNzYyMmIyODM5NDc5MTgzYjAg
cmV1c2UgL2tlcm5lbC94ODZfNjQtbmZzcm9vdC9mMjE3YzQ0ZWJkNDFjZTczNjlkMmRmMDc2
MjJiMjgzOTQ3OTE4M2IwL3ZtbGludXotMy4xNC4wLXJjOC0wMDAxMS1nZjIxN2M0NAoKMjAx
NC0wMy0yOC0wOToyNjowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxMQkxNAkxNy4uCTIx
CTMzCTQwCTQ5CTU0CTU5CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09
PT09PT0KYWxyZWFkeV91cHRvZGF0ZTogbm8gY29tbWl0cyBmaWxlIC9rZXJuZWwtdGVzdHMv
Y29tbWl0LWxpc3QvbmV4dDptYXN0ZXI6IGZvciBuZXh0L21hc3RlcgpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBmMjE3YzQ0Li4uIE1lcmdlIHRhZyAndHJhY2UtZml4ZXMtdjMuMTQt
cmM3LXYyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvcm9zdGVkdC9saW51eC10cmFjZQpIRUFEIGlzIG5vdyBhdCA5ZWVlMDEwLi4uIEFkZCBs
aW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMyNwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LW5mc3Jvb3Qvcm9iaDp2ZXJzYXRpbGU6OWVlZTAx
MDU1OTVkOWQxZjM3MDJkMGU4ZDhjZjQ5NTBlNDAwZWQwYjpiaXNlY3QtbGludXg2CgoyMDE0
LTAzLTI4LTA5OjMzOjE3IDllZWUwMTA1NTk1ZDlkMWYzNzAyZDBlOGQ4Y2Y0OTUwZTQwMGVk
MGIgcmV1c2UgL2tlcm5lbC94ODZfNjQtbmZzcm9vdC85ZWVlMDEwNTU5NWQ5ZDFmMzcwMmQw
ZThkOGNmNDk1MGU0MDBlZDBiL3ZtbGludXotMy4xNC4wLXJjOC1uZXh0LTIwMTQwMzI3Cgoy
MDE0LTAzLTI4LTA5OjMzOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4JMTgJNDEJ
NDYJNTIJNTQJNTcuLgk1OAk2MCBTVUNDRVNTCgo=

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc2-00030-g003b5e6"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc2 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
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
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

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
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

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
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
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
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
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
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=128
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
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
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
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
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
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
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
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
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
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
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
# CONFIG_I40EVF is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=y
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
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
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
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
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

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
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

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
# CONFIG_DW_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
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
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_I915_UMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=1024
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
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
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_OTG_FSM is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
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
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

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
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
CONFIG_EFI_RUNTIME_MAP=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
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
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
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
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
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
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
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
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
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
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
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
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
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
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_EFI is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--EeQfGwPcQSOJBaQU--
