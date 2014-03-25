Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaCYCeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:34:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:37488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaCYCd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:33:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,724,1389772800"; 
   d="log'?scan'208";a="498747577"
Date: Tue, 25 Mar 2014 10:33:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [mnt_hash] BUG: unable to handle kernel paging request at
 ffffffff81176112
Message-ID: <20140325023343.GA20498@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Al,

I got the below dmesg and the first bad commit is

commit 3d54406d3c64c0e7e092f8299c460ebe0aea9795
Author:     Al Viro <viro@zeniv.linux.org.uk>
AuthorDate: Thu Mar 20 21:10:51 2014 -0400
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Thu Mar 20 21:10:51 2014 -0400

    switch mnt_hash to hlist
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+------------------------------------------------------+------------+------------+------------+
|                                                      | 6a92faa1d6 | 3d54406d3c | 77a67cc34b |
+------------------------------------------------------+------------+------------+------------+
| boot_successes                                       | 429        | 41         | 12         |
| boot_failures                                        | 4          | 44         | 17         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference | 4          | 4          |            |
| Oops                                                 | 4          | 44         | 17         |
| RIP:rapl_pmu_init                                    | 4          |            |            |
| Kernel_panic-not_syncing:Fatal_exception             | 4          | 44         | 17         |
| backtrace:rapl_pmu_init                              | 4          |            |            |
| backtrace:kernel_init_freeable                       | 4          |            |            |
| RIP:umount_tree                                      | 0          | 4          |            |
| backtrace:do_group_exit                              | 0          | 3          |            |
| backtrace:SyS_exit_group                             | 0          | 3          |            |
| backtrace:unshare_nsproxy_namespaces                 | 0          | 1          |            |
| backtrace:SyS_unshare                                | 0          | 1          |            |
| BUG:unable_to_handle_kernel_paging_request           | 0          | 40         | 17         |
| RIP:dentry_kill                                      | 0          | 40         | 17         |
| backtrace:namespace_unlock                           | 0          | 40         | 17         |
| backtrace:SyS_umount                                 | 0          | 40         | 17         |
+------------------------------------------------------+------------+------------+------------+

[    4.406852] Freeing unused kernel memory: 1832K (ffff880001a36000 - ffff880001c00000)
[    4.427969] Freeing unused kernel memory: 876K (ffff880001f25000 - ffff880002000000)
Kernel tests: Boot OK!
[  531.406767] BUG: unable to handle kernel paging request at ffffffff81176112
[  531.408103] IP: [<ffffffff811771a2>] dentry_kill.isra.25+0xd0/0x2cb
[  531.408103] PGD 2015067 PUD 2016063 PMD 10001e1 
[  531.408103] Oops: 0003 [#1] 
[  531.408103] Modules linked in:
[  531.408103] CPU: 0 PID: 363 Comm: umount Not tainted 3.14.0-rc7-00038-g3d54406 #39
[  531.408103] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  531.408103] task: ffff88000e3b7320 ti: ffff88000e376000 task.ti: ffff88000e376000
[  531.408103] RIP: 0010:[<ffffffff811771a2>]  [<ffffffff811771a2>] dentry_kill.isra.25+0xd0/0x2cb
[  531.408103] RSP: 0018:ffff88000e377ea0  EFLAGS: 00010202
[  531.408103] RAX: ffffffff81176112 RBX: ffff88000efd1210 RCX: ffff88000e7c9ab8
[  531.408103] RDX: ffff88000e7c9ab8 RSI: ffffffff8117f37f RDI: ffff88000efd1210
[  531.408103] RBP: ffff88000e377eb8 R08: 00000000ffffffff R09: 0000000000000000
[  531.408103] R10: 0000000000737470 R11: ffff88000e3a7025 R12: ffff88000e7c9b90
[  531.408103] R13: ffff88000ec075d0 R14: 0000000000000000 R15: ffff88000e7c9a80
[  531.408103] FS:  00007f86c2759700(0000) GS:ffffffff82030000(0000) knlGS:0000000000000000
[  531.408103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  531.408103] CR2: ffffffff81176112 CR3: 000000000e273000 CR4: 00000000000006f0
[  531.408103] Stack:
[  531.408103]  ffff88000efd1210 ffff88000e7c9b90 ffff88000e7c9a80 ffff88000e377ed0
[  531.408103]  ffffffff811779c8 ffff88000e7c9b90 ffff88000e377ee8 ffffffff81168638
[  531.408103]  ffff88000e7c9a80 ffff88000e377f08 ffffffff8117fda2 ffff88000e7c9aa0
[  531.408103] Call Trace:
[  531.408103]  [<ffffffff811779c8>] dput+0x184/0x1b8
[  531.408103]  [<ffffffff81168638>] path_put+0x18/0x31
[  531.408103]  [<ffffffff8117fda2>] namespace_unlock+0xb8/0xd1
[  531.408103]  [<ffffffff81181f09>] SyS_umount+0x4a4/0x4f2
[  531.408103]  [<ffffffff8113c9db>] ? vm_munmap+0x5d/0x72
[  531.408103]  [<ffffffff81a28bb7>] system_call_fastpath+0x16/0x1b
[  531.408103] Code: ff 05 23 cf 3c 01 e8 dc dd ff ff 48 ff 05 1f cf 3c 01 48 ff 05 00 af 3c 01 48 8b 83 98 00 00 00 48 8b 93 90 00 00 00 48 89 42 08 <48> 89 10 48 b8 00 01 10 00 00 00 ad de 48 89 83 90 00 00 00 81 
[  531.408103] RIP  [<ffffffff811771a2>] dentry_kill.isra.25+0xd0/0x2cb
[  531.408103]  RSP <ffff88000e377ea0>
[  531.408103] CR2: ffffffff81176112
[  531.408103] ---[ end trace 2d4bf249e005ed27 ]---
[  531.408103] Kernel panic - not syncing: Fatal exception

git bisect start 77a67cc34b63c0f868f0bb66e7c23dd2743b2d97 dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
git bisect  bad fca1d772b6e12a5e5e3e5749f8b06650aeecbc6c  # 05:49      0-     13  Merge 'vfs/untested-mnt_hash' into devel-cairo-x86_64-201403211021
git bisect good 92fef99b88a854a6dbfd25fb1c4305662a182452  # 05:49     85+      0  0day base guard for 'devel-cairo-x86_64-201403211021'
git bisect good 8a21d9f63dd47485964b930af41304d88dee0e9b  # 05:53     30+      1  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good ea1cd65a648bd98ff9d028a647462d28313aadfd  # 05:59     30+      1  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 887843961c4b4681ee993c36d4997bf4b4aa8253  # 06:04     30+      2  mm: fix bad rss-counter if remap_file_pages raced migration
git bisect good 8cefb970aa3b94377554d5083611768ff257ce19  # 06:04     85+      0  resizable namespace.c hashes
git bisect  bad 3d54406d3c64c0e7e092f8299c460ebe0aea9795  # 06:04      0-     44  switch mnt_hash to hlist
git bisect good 6a92faa1d647d78ec54506d783c5a7ce503b4843  # 06:11     31+      4  smarter propagate_mnt()
# first bad commit: [3d54406d3c64c0e7e092f8299c460ebe0aea9795] switch mnt_hash to hlist
git bisect good 6a92faa1d647d78ec54506d783c5a7ce503b4843  # 06:16     93+      4  smarter propagate_mnt()
git bisect  bad 77a67cc34b63c0f868f0bb66e7c23dd2743b2d97  # 06:16      0-     17  0day head guard for 'devel-cairo-x86_64-201403211021'
git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 06:32     93+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 098bc161bfc7697f7e2ca15400f13ca1ac60e9dd  # 06:54     93+      0  Add linux-next specific files for 20140324


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

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-jaketown-17:20140321145144:x86_64-randconfig-c4-0321::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00038-g3d54406 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #39 Fri Mar 21 14:33:20 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:deve=
l-cairo-x86_64-201403211021:3d54406d3c64c0e7e092f8299c460ebe0aea9795:bisect=
-mmotm/.vmlinuz-3d54406d3c64c0e7e092f8299c460ebe0aea9795-20140321143441-59-=
jaketown branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0aea9795/=
vmlinuz-3.14.0-rc7-00038-g3d54406 drbd.minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02909000, 0x02909fff] PGTABLE
[    0.000000] BRK [0x0290a000, 0x0290afff] PGTABLE
[    0.000000] BRK [0x0290b000, 0x0290bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0290c000, 0x0290cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2051780
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-dev=
el:devel-cairo-x86_64-201403211021:3d54406d3c64c0e7e092f8299c460ebe0aea9795=
:bisect-mmotm/.vmlinuz-3d54406d3c64c0e7e092f8299c460ebe0aea9795-20140321143=
441-59-jaketown branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0a=
ea9795/vmlinuz-3.14.0-rc7-00038-g3d54406 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 228852K/261744K available (10409K kernel code, 3337K=
 rwdata, 3220K rodata, 1020K init, 4884K bss, 32892K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00038-g3d54406 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #39 Fri Mar 21 14:33:20 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:deve=
l-cairo-x86_64-201403211021:3d54406d3c64c0e7e092f8299c460ebe0aea9795:bisect=
-mmotm/.vmlinuz-3d54406d3c64c0e7e092f8299c460ebe0aea9795-20140321143441-59-=
jaketown branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0aea9795/=
vmlinuz-3.14.0-rc7-00038-g3d54406 drbd.minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02909000, 0x02909fff] PGTABLE
[    0.000000] BRK [0x0290a000, 0x0290afff] PGTABLE
[    0.000000] BRK [0x0290b000, 0x0290bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0290c000, 0x0290cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2051780
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-dev=
el:devel-cairo-x86_64-201403211021:3d54406d3c64c0e7e092f8299c460ebe0aea9795=
:bisect-mmotm/.vmlinuz-3d54406d3c64c0e7e092f8299c460ebe0aea9795-20140321143=
441-59-jaketown branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0a=
ea9795/vmlinuz-3.14.0-rc7-00038-g3d54406 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 228852K/261744K available (10409K kernel code, 3337K=
 rwdata, 3220K rodata, 1020K init, 4884K bss, 32892K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.074 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 3200.14 Bogo=
MIPS (lpj=3D6400296)
[    0.013945] pid_max: default: 32768 minimum: 301
[    0.016052] ACPI: Core revision 20131218
[    0.025192] ACPI: All ACPI Tables successfully acquired
[    0.028641] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.032025] Mountpoint-cache hash table entries: 512 (order: 0, 4096 byt=
es)
[    0.036561] Initializing cgroup subsys net_cls
[    0.040026] Initializing cgroup subsys blkio
[    0.044022] Initializing cgroup subsys hugetlb
[    0.048285] mce: CPU supports 10 MCE banks
[    0.052197] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.052197] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.052197] tlb_flushall_shift: 6
[    0.056023] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.103160] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.108389] Getting VERSION: 50014
[    0.112038] Getting VERSION: 50014
[    0.116040] Getting ID: 0
[    0.120046] Getting ID: ff000000
[    0.124046] Getting LVT0: 8700
[    0.128029] Getting LVT1: 8400
[    0.136162] enabled ExtINT on CPU#0
[    0.144369] ENABLING IO-APIC IRQs
[    0.148030] init IO_APIC IRQs
[    0.152021]  apic 0 pin 0 not connected
[    0.156051] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.160083] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.164086] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.168073] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.172075] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.176078] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.180074] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.184073] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.188079] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.192071] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.196082] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.200070] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.204089] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.208079] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.212079] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.216070]  apic 0 pin 16 not connected
[    0.220011]  apic 0 pin 17 not connected
[    0.224011]  apic 0 pin 18 not connected
[    0.228012]  apic 0 pin 19 not connected
[    0.232011]  apic 0 pin 20 not connected
[    0.236014]  apic 0 pin 21 not connected
[    0.240013]  apic 0 pin 22 not connected
[    0.244012]  apic 0 pin 23 not connected
[    0.248224] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.252012] Using local APIC timer interrupts.
[    0.252012] calibrating APIC timer ...
[    0.260000] ... lapic delta =3D 6323742
[    0.260000] ... PM-Timer delta =3D 362159
[    0.260000] APIC calibration not consistent with PM-Timer: 101ms instead=
 of 100ms
[    0.260000] APIC delta adjusted to PM-Timer: 6250317 (6323742)
[    0.260000] TSC delta adjusted to PM-Timer: 159987810 (161867238)
[    0.260000] ..... delta 6250317
[    0.260000] ..... mult: 268449071
[    0.260000] ..... calibration result: 4000202
[    0.260000] ..... CPU clock speed is 1599.3512 MHz.
[    0.260000] ..... host bus clock speed is 1000.0202 MHz.
[    0.260759] gcov: version magic: 0x3430382a
[    0.268515] xor: measuring software checksum speed
[    0.312018]    prefetch64-sse:  3705.000 MB/sec
[    0.356017]    generic_sse:  3462.000 MB/sec
[    0.360013] xor: using function: prefetch64-sse (3705.000 MB/sec)
[    0.364022] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.368293] regulator-dummy: no parameters
[    0.376012] RTC time: 14:42:49, date: 03/21/14
[    0.380185] NET: Registered protocol family 16
[    0.388294] cpuidle: using governor ladder
[    0.392013] cpuidle: using governor menu
[    0.396943] ACPI: bus type PCI registered
[    0.400142] PCI: Using configuration type 1 for base access
[    0.415416] bio: create slab <bio-0> at 0
[    0.484107] raid6: sse2x1     600 MB/s
[    0.556030] raid6: sse2x2     825 MB/s
[    0.624046] raid6: sse2x4    1273 MB/s
[    0.627890] raid6: using algorithm sse2x4 (1273 MB/s)
[    0.628012] raid6: using intx1 recovery algorithm
[    0.632235] ACPI: Added _OSI(Module Device)
[    0.636009] ACPI: Added _OSI(Processor Device)
[    0.640012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.644009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.657417] ACPI: Interpreter enabled
[    0.660024] ACPI: (supports S0 S5)
[    0.663700] ACPI: Using IOAPIC for interrupt routing
[    0.664069] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.683645] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.684029] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.688035] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.692634] PCI host bridge to bus 0000:00
[    0.696017] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.700017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.704013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.708017] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.712013] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.716115] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.721148] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.725912] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.736020] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.744695] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.752368] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.756048] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.760806] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.769865] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.776253] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.801907] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.805904] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.813522] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.818933] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.833513] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.836447] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.844011] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.856846] pci_bus 0000:00: on NUMA node 0
[    0.861010] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.868168] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.874564] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.880308] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.886825] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.891463] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.893355] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.896009] vgaarb: loaded
[    0.900007] vgaarb: bridge control possible 0000:00:02.0
[    0.905225] SCSI subsystem initialized
[    0.908247] ACPI: bus type USB registered
[    0.912240] usbcore: registered new interface driver usbfs
[    0.916076] usbcore: registered new interface driver hub
[    0.924259] usbcore: registered new device driver usb
[    0.928249] pps_core: LinuxPPS API ver. 1 registered
[    0.932010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.936053] PTP clock support registered
[    0.940120] PCI: Using ACPI for IRQ routing
[    0.944036] PCI: pci_cache_line_size set to 64 bytes
[    0.948476] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.952038] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.960570] Switched to clocksource kvm-clock
[    0.965123] pnp: PnP ACPI init
[    0.968980] ACPI: bus type PNP registered
[    0.973719] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.981990] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.987484] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.993043] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.996959] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.005248] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.010845] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.017373] pnp 00:03: [dma 2]
[    1.019835] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.024206] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.031490] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.037189] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.045560] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.051850] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.058101] pnp: PnP ACPI: found 7 devices
[    1.062363] ACPI: bus type PNP unregistered
[    1.075933] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.081152] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.103826] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.107531] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.111338] NET: Registered protocol family 2
[    1.115096] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.119133] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[    1.123177] TCP: Hash tables configured (established 2048 bind 2048)
[    1.127286] TCP: reno registered
[    1.129979] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.133712] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.137792] NET: Registered protocol family 1
[    1.141119] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.144821] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.148361] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.152311] pci 0000:00:02.0: Boot video device
[    1.155508] PCI: CLS 0 bytes, default 64
[    1.158704] Unpacking initramfs...
[    1.330320] Freeing initrd memory: 3112K (ffff88000fce6000 - ffff88000ff=
f0000)
[    1.338773] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.347311] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.355080] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.363376] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.367937] PCLMULQDQ-NI instructions are not detected.
[    1.371279] AVX or AES-NI instructions are not detected.
[    1.375202] AVX instructions are not detected.
[    1.379259] AVX instructions are not detected.
[    1.383159] AVX2 or AES-NI instructions are not detected.
[    1.388008] futex hash table entries: 256 (order: 0, 4096 bytes)
[    1.393131] Initialise system trusted keyring
[    1.397559] audit: initializing netlink subsys (disabled)
[    1.401394] audit: type=3D2000 audit(1395384170.386:1): initialized
[    2.355915] tsc: Refined TSC clocksource calibration: 1599.926 MHz
[    2.540544] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.547523] VFS: Disk quotas dquot_6.5.2
[    2.552240] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.559933] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.565031] QNX4 filesystem 0.2.3 registered.
[    2.570259] QNX6 filesystem 1.0.0 registered.
[    2.574881] fuse init (API version 7.22)
[    2.579011] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    2.588341] OCFS2 User DLM kernel interface loaded
[    2.593250] msgmni has been set to 453
[    2.604196] alg: No test for stdrng (krng)
[    2.609460] Key type asymmetric registered
[    2.614472] Asymmetric key parser 'x509' registered
[    2.619778] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.628413] io scheduler noop registered
[    2.633285] io scheduler deadline registered (default)
[    2.638673] test_string_helpers: Running tests...
[    2.644461] xz_dec_test: module loaded
[    2.649230] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    2.660279] hgafb: HGA card not detected.
[    2.665156] hgafb: probe of hgafb.0 failed with error -22
[    2.670989] usbcore: registered new interface driver smscufx
[    2.677266] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.686145] ACPI: Power Button [PWRF]
[    2.691080] xenfs: not registering filesystem on non-xen platform
[    2.697614] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.736127] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.746918] SyncLink PC Card driver $Revision: 4.34 $, tty major#247
[    2.753547] [drm] Initialized drm 1.1.0 20060810
[    2.758863] usbcore: registered new interface driver udl
[    2.765102] blk-mq: CPU -> queue map
[    2.769640]   CPU 0 -> Queue 0
[    2.774966]  nullb0: unknown partition table
[    2.780437] blk-mq: CPU -> queue map
[    2.784981]   CPU 0 -> Queue 0
[    2.789721]  nullb1: unknown partition table
[    2.795010] null: module loaded
[    2.799739] zram: Created 1 device(s) ...
[    2.805667] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.812805] libphy: Fixed MDIO Bus: probed
[    2.818074] PPP generic driver version 2.4.2
[    2.823491] PPP Deflate Compression module registered
[    2.829120] NET: Registered protocol family 24
[    2.834146] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    2.840885] SLIP linefill/keepalive option.
[    2.846021] usbcore: registered new interface driver i2400m_usb
[    2.851984] usbcore: registered new interface driver catc
[    2.857588] usbcore: registered new interface driver kaweth
[    2.863408] usbcore: registered new interface driver rtl8150
[    2.869289] usbcore: registered new interface driver asix
[    2.874706] usbcore: registered new interface driver cdc_ether
[    2.880739] usbcore: registered new interface driver dm9601
[    2.886608] usbcore: registered new interface driver sr9700
[    2.892237] usbcore: registered new interface driver smsc75xx
[    2.898227] usbcore: registered new interface driver smsc95xx
[    2.904021] usbcore: registered new interface driver gl620a
[    2.909837] usbcore: registered new interface driver rndis_host
[    2.915961] usbcore: registered new interface driver sierra_net
[    2.921780] usbcore: registered new interface driver cdc_ncm
[    2.927701] usbcore: registered new interface driver huawei_cdc_ncm
[    2.934154] driver u132_hcd
[    2.938574] usbcore: registered new interface driver cdc_acm
[    2.944439] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.953630] usbcore: registered new interface driver cdc_wdm
[    2.959729] usbcore: registered new interface driver usbserial
[    2.965695] usbcore: registered new interface driver usbserial_generic
[    2.971962] usbserial: USB Serial support registered for generic
[    2.978025] usbcore: registered new interface driver belkin_sa
[    2.983792] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    2.993854] usbcore: registered new interface driver cp210x
[    2.999466] usbserial: USB Serial support registered for cp210x
[    3.005508] usbcore: registered new interface driver io_edgeport
[    3.011498] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    3.020320] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    3.029039] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    3.038016] usbserial: USB Serial support registered for EPiC device
[    3.044246] usbcore: registered new interface driver io_ti
[    3.050037] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    3.058879] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    3.067985] usbcore: registered new interface driver f81232
[    3.073546] usbserial: USB Serial support registered for f81232
[    3.079644] usbcore: registered new interface driver ftdi_sio
[    3.085600] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    3.094283] usbcore: registered new interface driver garmin_gps
[    3.100151] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    3.106738] usbcore: registered new interface driver ipaq
[    3.112495] usbserial: USB Serial support registered for PocketPC PDA
[    3.118705] usbcore: registered new interface driver ipw
[    3.124416] usbserial: USB Serial support registered for IPWireless conv=
erter
[    3.131209] usbcore: registered new interface driver kl5kusb105
[    3.137030] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    3.146098] usbcore: registered new interface driver metro_usb
[    3.151873] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    3.160753] usbcore: registered new interface driver navman
[    3.166463] usbserial: USB Serial support registered for navman
[    3.172533] usbcore: registered new interface driver omninet
[    3.178209] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[    3.186986] usbcore: registered new interface driver safe_serial
[    3.193184] usbserial: USB Serial support registered for safe_serial
[    3.199558] usbcore: registered new interface driver spcp8x5
[    3.205685] usbserial: USB Serial support registered for SPCP8x5
[    3.211763] usbcore: registered new interface driver ssu100
[    3.217827] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    3.228142] usbcore: registered new interface driver ti_usb_3410_5052
[    3.234593] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    3.244007] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    3.253646] usbcore: registered new interface driver wishbone_serial
[    3.260263] usbserial: USB Serial support registered for wishbone_serial
[    3.267436] usbcore: registered new interface driver appledisplay
[    3.273752] usbcore: registered new interface driver cypress_cy7c63
[    3.280083] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.286889] driver ftdi-elan
[    3.291469] usbcore: registered new interface driver ftdi-elan
[    3.297747] usbcore: registered new interface driver iowarrior
[    3.304014] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.315945] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.321538] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.328985] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.339200] usbcore: registered new interface driver usb_acecad
[    3.345451] usbcore: registered new interface driver gtco
[    3.351163] usbcore: registered new interface driver wacom
[    3.357704] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.364888] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    3.372286] i2c /dev entries driver
[    3.411176] usbcore: registered new interface driver i2c-diolan-u2c
[    3.417707] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    3.427700] Driver for 1-wire Dallas network protocol.
[    3.434026] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.440735] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    3.452753] pc87360: PC8736x not detected, module not inserted
[    3.459723] usbcore: registered new interface driver pcwd_usb
[    3.466282] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.475851] acquirewdt: I/O address 0x0043 already in use
[    3.481729] acquirewdt: probe of acquirewdt failed with error -5
[    3.488446] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    3.496395] sbc8360: failed to register misc device
[    3.501826] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    3.512389] w83697ug_wdt: No W83697UG/UF could be found
[    3.518142] w83877f_wdt: I/O address 0x0443 already in use
[    3.523999] w83977f_wdt: driver v1.00
[    3.528645] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.534941] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    3.544107] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    3.553910] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    3.567921] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    3.575535] Modular ISDN core version 1.1.29
[    3.580905] NET: Registered protocol family 34
[    3.586478] usbcore: registered new interface driver HFC-S_USB
[    3.593249] ledtrig-cpu: registered to indicate activity on CPUs
[    3.599818] usbcore: registered new interface driver rts5139
[    3.606188] usbcore: registered new interface driver tranzport
[    3.612565] usbcore: registered new interface driver alphatrack
[    3.619212] input: Speakup as /devices/virtual/input/input4
[    3.625376] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    3.632471] speakup 3.1.6: initialized
[    3.637371] synth name on entry is: (null)
[    3.642940] usbcore: registered new interface driver gdm_wimax
[    3.649769] GACT probability on
[    3.654518] Simple TC action Loaded
[    3.659964] netem: version 1.3
[    3.664222] Netfilter messages via NETLINK v0.30.
[    3.669683] nf_conntrack version 0.5.0 (1812 buckets, 7248 max)
[    3.676649] xt_time: kernel timezone is -0000
[    3.682260] ipip: IPv4 over IPv4 tunneling driver
[    3.688608] gre: GRE over IPv4 demultiplexor driver
[    3.694702] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.716248] tcp_probe: probe registered (port=3D0/fwmark=3D0) bufsize=3D=
4096
[    3.722821] TCP: cubic registered
[    3.727607] TCP: veno registered
[    3.732377] TCP: scalable registered
[    3.737572] NET: Registered protocol family 5
[    3.743069] NET: Registered protocol family 33
[    3.748549] Key type rxrpc registered
[    3.753600] Key type rxrpc_s registered
[    3.758772] lib80211: common routines for IEEE802.11 drivers
[    3.765205] lib80211_crypt: registered algorithm 'NULL'
[    3.771512] lib80211_crypt: registered algorithm 'WEP'
[    3.777627] lib80211_crypt: registered algorithm 'CCMP'
[    3.783879] lib80211_crypt: registered algorithm 'TKIP'
[    3.790052] 9pnet: Installing 9P2000 support
[    3.795667] Key type dns_resolver registered
[    3.801239] Key type ceph registered
[    3.806369] libceph: loaded (mon/osd proto 15/24)
[    3.813553]=20
[    3.813553] printing PIC contents
[    3.821193] ... PIC  IMR: ffff
[    3.825164] ... PIC  IRR: 1013
[    3.830193] ... PIC  ISR: 0000
[    3.834910] ... PIC ELCR: 0c00
[    3.839646] printing local APIC contents on CPU#0/0:
[    3.843603] ... APIC ID:      00000000 (0)
[    3.843603] ... APIC VERSION: 00050014
[    3.843603] ... APIC TASKPRI: 00000000 (00)
[    3.843603] ... APIC PROCPRI: 00000000
[    3.843603] ... APIC LDR: 01000000
[    3.843603] ... APIC DFR: ffffffff
[    3.843603] ... APIC SPIV: 000001ff
[    3.843603] ... APIC ISR field:
[    3.843603] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.843603] ... APIC TMR field:
[    3.843603] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.843603] ... APIC IRR field:
[    3.843603] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.843603] ... APIC ESR: 00000000
[    3.843603] ... APIC ICR: 00000831
[    3.843603] ... APIC ICR2: 01000000
[    3.843603] ... APIC LVTT: 000200ef
[    3.843603] ... APIC LVTPC: 00010000
[    3.843603] ... APIC LVT0: 00010700
[    3.843603] ... APIC LVT1: 00000400
[    3.843603] ... APIC LVTERR: 000000fe
[    3.843603] ... APIC TMICT: 0003d09c
[    3.843603] ... APIC TMCCT: 00035954
[    3.843603] ... APIC TDCR: 00000003
[    3.843603]=20
[    3.984677] number of MP IRQ sources: 15.
[    3.989666] number of IO-APIC #0 registers: 24.
[    3.995402] testing the IO APIC.......................
[    4.001482] IO APIC #0......
[    4.005608] .... register #00: 00000000
[    4.010791] .......    : physical APIC id: 00
[    4.016401] .......    : Delivery Type: 0
[    4.021796] .......    : LTS          : 0
[    4.027210] .... register #01: 00170011
[    4.032548] .......     : max redirection entries: 17
[    4.038653] .......     : PRQ implemented: 0
[    4.044224] .......     : IO APIC version: 11
[    4.049434] .... register #02: 00000000
[    4.053973] .......     : arbitration: 00
[    4.059063] .... IRQ redirection table:
[    4.064151] 1    0    0   0   0    0    0    00
[    4.069681] 0    0    0   0   0    1    1    31
[    4.075226] 0    0    0   0   0    1    1    30
[    4.080674] 0    0    0   0   0    1    1    33
[    4.086196] 1    0    0   0   0    1    1    34
[    4.091741] 1    1    0   0   0    1    1    35
[    4.097321] 0    0    0   0   0    1    1    36
[    4.102554] 0    0    0   0   0    1    1    37
[    4.108132] 0    0    0   0   0    1    1    38
[    4.113680] 0    1    0   0   0    1    1    39
[    4.119181] 1    1    0   0   0    1    1    3A
[    4.124705] 1    1    0   0   0    1    1    3B
[    4.130206] 0    0    0   0   0    1    1    3C
[    4.135782] 0    0    0   0   0    1    1    3D
[    4.141226] 0    0    0   0   0    1    1    3E
[    4.146498] 0    0    0   0   0    1    1    3F
[    4.152029] 1    0    0   0   0    0    0    00
[    4.157497] 1    0    0   0   0    0    0    00
[    4.163031] 1    0    0   0   0    0    0    00
[    4.168577] 1    0    0   0   0    0    0    00
[    4.174109] 1    0    0   0   0    0    0    00
[    4.179692] 1    0    0   0   0    0    0    00
[    4.185233] 1    0    0   0   0    0    0    00
[    4.190751] 1    0    0   0   0    0    0    00
[    4.196060] IRQ to pin mappings:
[    4.200608] IRQ0 -> 0:2
[    4.205480] IRQ1 -> 0:1
[    4.210365] IRQ3 -> 0:3
[    4.215211] IRQ4 -> 0:4
[    4.219902] IRQ5 -> 0:5
[    4.224786] IRQ6 -> 0:6
[    4.229623] IRQ7 -> 0:7
[    4.234421] IRQ8 -> 0:8
[    4.239254] IRQ9 -> 0:9
[    4.244203] IRQ10 -> 0:10
[    4.248992] IRQ11 -> 0:11
[    4.254060] IRQ12 -> 0:12
[    4.259104] IRQ13 -> 0:13
[    4.263963] IRQ14 -> 0:14
[    4.268627] IRQ15 -> 0:15
[    4.273288] .................................... done.
[    4.279278] Loading compiled-in X.509 certificates
[    4.289462] Loaded X.509 cert 'Magrathea: Glacier signing key: 9f84838f6=
49814d90f22151152fb90e738d60197'
[    4.300282] registered taskstats version 1
[    4.305508] kAFS: Red Hat AFS client v0.1 registering.
[    4.311355] bio: create slab <bio-1> at 1
[    4.316819] Btrfs loaded, debug=3Don, assert=3Don, integrity-checker=3Don
[    4.324972] Key type encrypted registered
[    4.331154] regulator-dummy: disabling
[    4.336294]   Magic number: 6:727:738
[    4.341302] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    4.350917] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.356891] EDD information not available.
[    4.366520] Freeing unused kernel memory: 1020K (ffffffff82344000 - ffff=
ffff82443000)
[    4.376272] Write protecting the kernel read-only data: 16384k
[    4.406852] Freeing unused kernel memory: 1832K (ffff880001a36000 - ffff=
880001c00000)
[    4.427969] Freeing unused kernel memory: 876K (ffff880001f25000 - ffff8=
80002000000)
Kernel tests: Boot OK!
[  531.406767] BUG: unable to handle kernel paging request at ffffffff81176=
112
[  531.408103] IP: [<ffffffff811771a2>] dentry_kill.isra.25+0xd0/0x2cb
[  531.408103] PGD 2015067 PUD 2016063 PMD 10001e1=20
[  531.408103] Oops: 0003 [#1]=20
[  531.408103] Modules linked in:
[  531.408103] CPU: 0 PID: 363 Comm: umount Not tainted 3.14.0-rc7-00038-g3=
d54406 #39
[  531.408103] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  531.408103] task: ffff88000e3b7320 ti: ffff88000e376000 task.ti: ffff880=
00e376000
[  531.408103] RIP: 0010:[<ffffffff811771a2>]  [<ffffffff811771a2>] dentry_=
kill.isra.25+0xd0/0x2cb
[  531.408103] RSP: 0018:ffff88000e377ea0  EFLAGS: 00010202
[  531.408103] RAX: ffffffff81176112 RBX: ffff88000efd1210 RCX: ffff88000e7=
c9ab8
[  531.408103] RDX: ffff88000e7c9ab8 RSI: ffffffff8117f37f RDI: ffff88000ef=
d1210
[  531.408103] RBP: ffff88000e377eb8 R08: 00000000ffffffff R09: 00000000000=
00000
[  531.408103] R10: 0000000000737470 R11: ffff88000e3a7025 R12: ffff88000e7=
c9b90
[  531.408103] R13: ffff88000ec075d0 R14: 0000000000000000 R15: ffff88000e7=
c9a80
[  531.408103] FS:  00007f86c2759700(0000) GS:ffffffff82030000(0000) knlGS:=
0000000000000000
[  531.408103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  531.408103] CR2: ffffffff81176112 CR3: 000000000e273000 CR4: 00000000000=
006f0
[  531.408103] Stack:
[  531.408103]  ffff88000efd1210 ffff88000e7c9b90 ffff88000e7c9a80 ffff8800=
0e377ed0
[  531.408103]  ffffffff811779c8 ffff88000e7c9b90 ffff88000e377ee8 ffffffff=
81168638
[  531.408103]  ffff88000e7c9a80 ffff88000e377f08 ffffffff8117fda2 ffff8800=
0e7c9aa0
[  531.408103] Call Trace:
[  531.408103]  [<ffffffff811779c8>] dput+0x184/0x1b8
[  531.408103]  [<ffffffff81168638>] path_put+0x18/0x31
[  531.408103]  [<ffffffff8117fda2>] namespace_unlock+0xb8/0xd1
[  531.408103]  [<ffffffff81181f09>] SyS_umount+0x4a4/0x4f2
[  531.408103]  [<ffffffff8113c9db>] ? vm_munmap+0x5d/0x72
[  531.408103]  [<ffffffff81a28bb7>] system_call_fastpath+0x16/0x1b
[  531.408103] Code: ff 05 23 cf 3c 01 e8 dc dd ff ff 48 ff 05 1f cf 3c 01 =
48 ff 05 00 af 3c 01 48 8b 83 98 00 00 00 48 8b 93 90 00 00 00 48 89 42 08 =
<48> 89 10 48 b8 00 01 10 00 00 00 ad de 48 89 83 90 00 00 00 81=20
[  531.408103] RIP  [<ffffffff811771a2>] dentry_kill.isra.25+0xd0/0x2cb
[  531.408103]  RSP <ffff88000e377ea0>
[  531.408103] CR2: ffffffff81176112
[  531.408103] ---[ end trace 2d4bf249e005ed27 ]---
[  531.408103] Kernel panic - not syncing: Fatal exception
[  531.408103] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[  531.408103] Rebooting in 10 seconds..
Elapsed time: 530
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0aea9795/vmlinuz-3.14.0-rc7-00038-=
g3d54406 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:devel-cairo-x86=
_64-201403211021:3d54406d3c64c0e7e092f8299c460ebe0aea9795:bisect-mmotm/.vml=
inuz-3d54406d3c64c0e7e092f8299c460ebe0aea9795-20140321143441-59-jaketown br=
anch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-c4-0321/3d54406d3c64c0e7e092f8299c460ebe0aea9795/vmlinuz-3.1=
4.0-rc7-00038-g3d54406 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/=
yocto-minimal-x86_64.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net=
 user,vlan=3D1,hostfwd=3Dtcp::10611-:22 -boot order=3Dnc -no-reboot -watchd=
og i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-jaketow=
n-17 -serial file:/dev/shm/kboot/serial-yocto-jaketown-17 -daemonize -displ=
ay none -monitor null=20

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-waimea-11:20140321154318:x86_64-randconfig-c4-0321:3.14.0-rc7-00037-g6a92faa:41"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00037-g6a92faa (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #41 Fri Mar 21 15:01:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:deve=
l-cairo-x86_64-201403211021:6a92faa1d647d78ec54506d783c5a7ce503b4843:bisect=
-mmotm/.vmlinuz-6a92faa1d647d78ec54506d783c5a7ce503b4843-20140321152542-143=
-waimea branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503b4843/v=
mlinuz-3.14.0-rc7-00037-g6a92faa drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02909000, 0x02909fff] PGTABLE
[    0.000000] BRK [0x0290a000, 0x0290afff] PGTABLE
[    0.000000] BRK [0x0290b000, 0x0290bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0290c000, 0x0290cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-dev=
el:devel-cairo-x86_64-201403211021:6a92faa1d647d78ec54506d783c5a7ce503b4843=
:bisect-mmotm/.vmlinuz-6a92faa1d647d78ec54506d783c5a7ce503b4843-20140321152=
542-143-waimea branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503=
b4843/vmlinuz-3.14.0-rc7-00037-g6a92faa drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 272072K/327280K available (10409K kernel code, 3337K=
 rwdata, 3220K rodata, 1020K init, 4884K bss, 55208K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00037-g6a92faa (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #41 Fri Mar 21 15:01:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:deve=
l-cairo-x86_64-201403211021:6a92faa1d647d78ec54506d783c5a7ce503b4843:bisect=
-mmotm/.vmlinuz-6a92faa1d647d78ec54506d783c5a7ce503b4843-20140321152542-143=
-waimea branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503b4843/v=
mlinuz-3.14.0-rc7-00037-g6a92faa drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02909000, 0x02909fff] PGTABLE
[    0.000000] BRK [0x0290a000, 0x0290afff] PGTABLE
[    0.000000] BRK [0x0290b000, 0x0290bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0290c000, 0x0290cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-dev=
el:devel-cairo-x86_64-201403211021:6a92faa1d647d78ec54506d783c5a7ce503b4843=
:bisect-mmotm/.vmlinuz-6a92faa1d647d78ec54506d783c5a7ce503b4843-20140321152=
542-143-waimea branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503=
b4843/vmlinuz-3.14.0-rc7-00037-g6a92faa drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 272072K/327280K available (10409K kernel code, 3337K=
 rwdata, 3220K rodata, 1020K init, 4884K bss, 55208K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3300.171 MHz processor
[    0.008314] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.34 BogoMIPS (lpj=3D13200684)
[    0.009215] pid_max: default: 32768 minimum: 301
[    0.009709] ACPI: Core revision 20131218
[    0.040409] ACPI: All ACPI Tables successfully acquired
[    0.042998] Mount-cache hash table entries: 1024 (order: 2, 16384 bytes)
[    0.043614] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.052548] Initializing cgroup subsys net_cls
[    0.053206] Initializing cgroup subsys blkio
[    0.053515] Initializing cgroup subsys hugetlb
[    0.057187] mce: CPU supports 10 MCE banks
[    0.062335] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.062335] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.062335] tlb_flushall_shift: 6
[    0.064126] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, ste=
pping: 01)
[    0.088615] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.096969] Getting VERSION: 50011
[    0.097212] Getting VERSION: 50011
[    0.097394] Getting ID: 0
[    0.097573] Getting ID: ff000000
[    0.097739] Getting LVT0: 8700
[    0.097884] Getting LVT1: 8400
[    0.098365] enabled ExtINT on CPU#0
[    0.099211] ENABLING IO-APIC IRQs
[    0.099426] Synchronizing Arb IDs.
[    0.099617] init IO_APIC IRQs
[    0.099838]  apic 0 pin 0 not connected
[    0.100715] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.101533] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.101831] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.102122] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.102445] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.102770] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.103061] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.103344] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.103659] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.104000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.104000]  apic 0 pin 16 not connected
[    0.104000]  apic 0 pin 17 not connected
[    0.104000]  apic 0 pin 18 not connected
[    0.104000]  apic 0 pin 19 not connected
[    0.104000]  apic 0 pin 20 not connected
[    0.104000]  apic 0 pin 21 not connected
[    0.104000]  apic 0 pin 22 not connected
[    0.104000]  apic 0 pin 23 not connected
[    0.104000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.144150] Using local APIC timer interrupts.
[    0.144150] calibrating APIC timer ...
[    0.148000] ... lapic delta =3D 6247153
[    0.148000] ... PM-Timer delta =3D 357791
[    0.148000] ... PM-Timer result ok
[    0.148000] ..... delta 6247153
[    0.148000] ..... mult: 268313178
[    0.148000] ..... calibration result: 3998177
[    0.148000] ..... CPU clock speed is 3298.2367 MHz.
[    0.148000] ..... host bus clock speed is 999.2177 MHz.
[    0.153438] gcov: version magic: 0x3430382a
[    0.180049] xor: measuring software checksum speed
[    0.220077]    prefetch64-sse:  1062.000 MB/sec
[    0.260035]    generic_sse:  1055.000 MB/sec
[    0.260289] xor: using function: prefetch64-sse (1062.000 MB/sec)
[    0.261526] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.267438] regulator-dummy: no parameters
[    0.268867] RTC time: 15:43:06, date: 03/21/14
[    0.272114] NET: Registered protocol family 16
[    0.277727] cpuidle: using governor ladder
[    0.278021] cpuidle: using governor menu
[    0.279814] ACPI: bus type PCI registered
[    0.281207] PCI: Using configuration type 1 for base access
[    0.327903] bio: create slab <bio-0> at 0
[    0.396358] raid6: sse2x1     148 MB/s
[    0.464218] raid6: sse2x2     179 MB/s
[    0.532070] raid6: sse2x4     191 MB/s
[    0.532341] raid6: using algorithm sse2x4 (191 MB/s)
[    0.532803] raid6: using ssse3x2 recovery algorithm
[    0.535088] ACPI: Added _OSI(Module Device)
[    0.535296] ACPI: Added _OSI(Processor Device)
[    0.535462] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.535632] ACPI: Added _OSI(Processor Aggregator Device)
[    0.585804] ACPI: Interpreter enabled
[    0.586403] ACPI: (supports S0 S5)
[    0.586595] ACPI: Using IOAPIC for interrupt routing
[    0.587317] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.668000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.668631] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.669089] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.674750] PCI host bridge to bus 0000:00
[    0.675099] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.675560] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.676057] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.676484] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.676886] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.678065] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.682954] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.687018] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.690824] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.695631] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.696880] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.697455] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.700149] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.701363] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.702482] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.707552] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.709837] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.711151] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.712628] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.717602] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.720502] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.721573] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.722622] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.729323] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.730743] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.731753] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.737783] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.738839] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.740051] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.746955] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.748050] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.749053] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.758065] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.759619] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.761154] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.769937] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.771494] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.772598] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.780481] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.781168] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.785884] pci_bus 0000:00: on NUMA node 0
[    0.791205] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.793169] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.794558] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.795819] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.796634] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.801789] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.806678] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.807020] vgaarb: loaded
[    0.807168] vgaarb: bridge control possible 0000:00:02.0
[    0.812463] SCSI subsystem initialized
[    0.813539] ACPI: bus type USB registered
[    0.814815] usbcore: registered new interface driver usbfs
[    0.815438] usbcore: registered new interface driver hub
[    0.816192] usbcore: registered new device driver usb
[    0.817488] pps_core: LinuxPPS API ver. 1 registered
[    0.817684] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.818114] PTP clock support registered
[    0.819038] PCI: Using ACPI for IRQ routing
[    0.819508] PCI: pci_cache_line_size set to 64 bytes
[    0.820266] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.820650] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.833712] Switched to clocksource hpet
[    0.836405] pnp: PnP ACPI init
[    0.836726] ACPI: bus type PNP registered
[    0.838389] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.839866] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.840480] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.841095] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.841538] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.843001] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.844113] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.844791] pnp 00:03: [dma 2]
[    0.845546] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.846372] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.847097] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.847711] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.848316] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.850670] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.852818] pnp: PnP ACPI: found 7 devices
[    0.853171] ACPI: bus type PNP unregistered
[    0.883886] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.884228] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.884563] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.884915] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.885792] NET: Registered protocol family 2
[    0.894109] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.894594] TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
[    0.895038] TCP: Hash tables configured (established 4096 bind 4096)
[    0.896668] TCP: reno registered
[    0.896921] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.897266] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.900140] NET: Registered protocol family 1
[    0.900738] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.901038] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.901420] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.901785] pci 0000:00:02.0: Boot video device
[    0.902309] PCI: CLS 0 bytes, default 64
[    0.911820] Unpacking initramfs...
[    7.664919] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    7.669033] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000020
[    7.669408] IP: [<ffffffff82354270>] rapl_pmu_init+0x1a5/0x1f5
[    7.670167] PGD 0=20
[    7.670368] Oops: 0000 [#1]=20
[    7.670574] Modules linked in:
[    7.670941] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-00037-g6a=
92faa #41
[    7.671249] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.671496] task: ffff88001246b920 ti: ffff88001246c000 task.ti: ffff880=
01246c000
[    7.671496] RIP: 0010:[<ffffffff82354270>]  [<ffffffff82354270>] rapl_pm=
u_init+0x1a5/0x1f5
[    7.671496] RSP: 0000:ffff88001246de90  EFLAGS: 00000202
[    7.671496] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00000
[    7.671496] RDX: 0000000000000003 RSI: 0000000000000001 RDI: ffffffff820=
97c10
[    7.671496] RBP: ffff88001246de98 R08: ffff880013ff25a0 R09: 00000000000=
00001
[    7.671496] R10: 0000000000000100 R11: 0000000000000001 R12: 00000000000=
00000
[    7.671496] R13: 0000000000000180 R14: 0000000000000000 R15: 00000000000=
00000
[    7.671496] FS:  0000000000000000(0000) GS:ffffffff82030000(0000) knlGS:=
0000000000000000
[    7.671496] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.671496] CR2: 0000000000000020 CR3: 0000000002012000 CR4: 00000000003=
006f0
[    7.671496] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    7.671496] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[    7.671496] Stack:
[    7.671496]  ffffffff823540cb ffff88001246df08 ffffffff81002146 ffffffff=
810b4400
[    7.671496]  ffff88001246df08 ffffffff810b46a1 0000018000060006 ffffffff=
81f215b8
[    7.671496]  ffff880013ffa5db 0000000000000200 0000000000000006 00000000=
00000006
[    7.671496] Call Trace:
[    7.671496]  [<ffffffff823540cb>] ? uncore_cpu_setup+0x1bd/0x1bd
[    7.671496]  [<ffffffff81002146>] do_one_initcall+0xb9/0x18b
[    7.671496]  [<ffffffff810b4400>] ? parameqn+0x51/0x5b
[    7.671496]  [<ffffffff810b46a1>] ? parse_args+0x26a/0x3a9
[    7.671496]  [<ffffffff8234568e>] kernel_init_freeable+0x261/0x361
[    7.671496]  [<ffffffff8234499e>] ? do_early_param+0xd7/0xd7
[    7.671496]  [<ffffffff81a0f939>] ? rest_init+0xbd/0xbd
[    7.671496]  [<ffffffff81a0f949>] kernel_init+0x10/0x175
[    7.671496]  [<ffffffff81a289ca>] ret_from_fork+0x7a/0xb0
[    7.671496]  [<ffffffff81a0f939>] ? rest_init+0xbd/0xbd
[    7.671496] Code: fb df 81 31 c0 48 ff 05 1f 2b 11 00 e8 ca 13 6c ff 48 =
ff 05 23 2b 11 00 83 c8 ff eb 5b 48 8b 1d ff f7 ce ff 48 ff 05 08 2b 11 00 =
<48> 8b 7b 20 e8 c5 5d d4 fe 48 69 c8 e8 03 00 00 48 89 d0 be e8=20
[    7.671496] RIP  [<ffffffff82354270>] rapl_pmu_init+0x1a5/0x1f5
[    7.671496]  RSP <ffff88001246de90>
[    7.671496] CR2: 0000000000000020
[    7.671496] ---[ end trace c9c27250507db7e7 ]---
[    7.671496] Kernel panic - not syncing: Fatal exception
[    7.671496] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[    7.671496] Rebooting in 10 seconds..
Elapsed time: 20
qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconf=
ig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503b4843/vmlinuz-3.14.0-rc7-0003=
7-g6a92faa -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c4-0321/linux-devel:devel-cairo-=
x86_64-201403211021:6a92faa1d647d78ec54506d783c5a7ce503b4843:bisect-mmotm/.=
vmlinuz-6a92faa1d647d78ec54506d783c5a7ce503b4843-20140321152542-143-waimea =
branch=3Dlinux-devel/devel-cairo-x86_64-201403211021 BOOT_IMAGE=3D/kernel/x=
86_64-randconfig-c4-0321/6a92faa1d647d78ec54506d783c5a7ce503b4843/vmlinuz-3=
=2E14.0-rc7-00037-g6a92faa drbd.minor_count=3D8'  -initrd /kernel-tests/ini=
trd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::9702-:22 -boot order=3Dnc -no-reboot -watc=
hdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-qua=
ntal-waimea-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1=
-quantal-waimea-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/d=
isk2-quantal-waimea-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DK=
VM/disk3-quantal-waimea-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk4-quantal-waimea-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/L=
ABEL=3DKVM/disk5-quantal-waimea-11,media=3Ddisk,if=3Dvirtio -pidfile /dev/s=
hm/kboot/pid-quantal-waimea-11 -serial file:/dev/shm/kboot/serial-quantal-w=
aimea-11 -daemonize -display none -monitor null=20

--gKMricLos+KVdGMg
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-c4-0321-77a67cc34b63c0f868f0bb66e7c23dd2743b2d97-BUG:-unable-to-handle-kernel-paging-request-50438.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM0
LTAzMjEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTQwMzIxMTAyMTpkY2I5
OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1OmJpc2VjdC1saW51eDIKCjIw
MTQtMDMtMjUtMDU6NDI6NDUgZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5
MGYxNSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvZGNiOTlmZDli
MDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS92bWxpbnV6LTMuMTQuMC1yYzcKCjIw
MTQtMDMtMjUtMDU6NDI6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMQk1CTEwCTE3CTE4
CTIwCTIxLgkyMgkyMwkyNgkyNyBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGRjYjk5
ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKZ2l0IGJpc2VjdCBzdGFydCA3
N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZlN2MyM2RkMjc0M2IyZDk3IGRjYjk5ZmQ5YjA4Y2Zl
MWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1i
aXNlY3Q6IFsiLWIiLCAiNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNiMmQ5
NyIsICItZyIsICJkY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1Iiwg
Ii9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5l
bC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogOTYgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltmY2ExZDc3MmI2ZTEy
YTVlNWUzZTU3NDlmOGIwNjY1MGFlZWNiYzZjXSBNZXJnZSAndmZzL3VudGVzdGVkLW1udF9o
YXNoJyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0yMDE0MDMyMTEwMjEKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMv
bGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTQwMzIxMTAyMTpmY2ExZDc3MmI2ZTEyYTVlNWUzZTU3NDlmOGIwNjY1MGFlZWNiYzZj
OmJpc2VjdC1saW51eDIKIFRFU1QgRkFJTFVSRQpbICAgIDIuMDk4MjY4XSBGcmVlaW5nIHVu
dXNlZCBrZXJuZWwgbWVtb3J5OiA4NzZLIChmZmZmODgwMDAxZjI1MDAwIC0gZmZmZjg4MDAw
MjAwMDAwMCkKWyAgICAyLjEwNzE2OF0gcmFuZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3aXRo
IDIgYml0cyBvZiBlbnRyb3B5IGF2YWlsYWJsZQpbICAgIDIuMTg2NTI0XSB0c2M6IFJlZmlu
ZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyNDkzLjk2NSBNSHoKWyAgIDEyLjQx
NjA5NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgYXQgICAgICAgICAgIChudWxsKQpbICAgMTIuNDE3OTc1XSBJUDogWzxmZmZmZmZm
ZjgxMTgxMjliPl0gdW1vdW50X3RyZWUrMHgzZC8weDI5MApbICAgMTIuNDE3OTc1XSBQR0Qg
MTM4ODMwNjcgUFVEIDEzODk3MDY3IFBNRCAwIApbICAgMTIuNDE3OTc1XSBPb3BzOiAwMDAy
IFsjMV0gClsgICAxMi40MTc5NzVdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMTIuNDE3OTc1
XSBDUFU6IDAgUElEOiA3MzAwIENvbW06IHRyaW5pdHktYzAgTm90IHRhaW50ZWQgMy4xNC4w
LXJjNy0wMDA0MC1nZmNhMWQ3NyAjMzEKWyAgIDEyLjQxNzk3NV0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTIuNDE3OTc1XSB0YXNr
OiBmZmZmODgwMDAwYWE1MzIwIHRpOiBmZmZmODgwMDEzOGE2MDAwIHRhc2sudGk6IGZmZmY4
ODAwMTM4YTYwMDAKWyAgIDEyLjQxNzk3NV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTE4MTI5
Yj5dICBbPGZmZmZmZmZmODExODEyOWI+XSB1bW91bnRfdHJlZSsweDNkLzB4MjkwClsgICAx
Mi40MTc5NzVdIFJTUDogMDAxODpmZmZmODgwMDEzOGE3ZTg4ICBFRkxBR1M6IDAwMDEwMjQ2
ClsgICAxMi40MTc5NzVdIFJBWDogZmZmZjg4MDAxMzg3YTA4MCBSQlg6IGZmZmY4ODAwMTM4
N2EwODAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICAxMi40MTc5NzVdIFJEWDogMDAwMDAw
MDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiBmZmZmODgwMDEzODdhMDgw
ClsgICAxMi40MTc5NzVdIFJCUDogZmZmZjg4MDAxMzhhN2VhOCBSMDg6IGZmZmY4ODAwMTM4
ZDBkNDAgUjA5OiBmZWZlZmVmZWZlZmVmZWZmClsgICAxMi40MTc5NzVdIFIxMDogMDAwMDAw
MDAxMzhkMGQ5MSBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAw
ClsgICAxMi40MTc5NzVdIFIxMzogZmZmZjg4MDAxMzhhN2U4OCBSMTQ6IDAwMDAwMDAwZmZm
ZmZmZWMgUjE1OiBmZmZmODgwMDEzODdhZDAwClsgICAxMi40MTc5NzVdIEZTOiAgMDAwMDdm
ZjNmMDUwNTcwMCgwMDAwKSBHUzpmZmZmZmZmZjgyMDMwMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgIDEyLjQxNzk3NV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgMTIuNDE3OTc1XSBDUjI6IDAwMDAwMDAwMDAw
MDAwMDAgQ1IzOiAwMDAwMDAwMDEzOGEyMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMApbICAg
MTIuNDE3OTc1XSBTdGFjazoKWyAgIDEyLjQxNzk3NV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZm
Zjg4MDAxMzg3YTA4MCBmZmZmODgwMDAwYjQ3MzkwIGZmZmY4ODAwMTM4ZDBkMjAKWyAgIDEy
LjQxNzk3NV0gIGZmZmY4ODAwMTM4YTdmMjggZmZmZmZmZmY4MTE4MmQ0YSBmZmZmODgwMDEz
OGQwZDYwIDAwMDAwMDAwMDBiMDcwMDAKWyAgIDEyLjQxNzk3NV0gIGZmZmY4ODAwMTM4N2Fk
NTAgZmZmZjg4MDAxMzg3YWJlMCBmZmZmODgwMDEzMGNiYTEwIGZmZmZmZmZmZmZmZmZmZmYK
WyAgIDEyLjQxNzk3NV0gQ2FsbCBUcmFjZToKWyAgIDEyLjQxNzk3NV0gIFs8ZmZmZmZmZmY4
MTE4MmQ0YT5dIGRvX21vdW50KzB4NmFjLzB4ZDQ0ClsgICAxMi40MTc5NzVdICBbPGZmZmZm
ZmZmODExODI1YmE+XSA/IGNvcHlfbW91bnRfb3B0aW9ucysweGZkLzB4MTkzClsgICAxMi40
MTc5NzVdICBbPGZmZmZmZmZmODExODM3MTA+XSBTeVNfbW91bnQrMHhjOC8weDEyNApbICAg
MTIuNDE3OTc1XSAgWzxmZmZmZmZmZjgxYTI4YmI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgr
MHgxNi8weDFiClsgICAxMi40MTc5NzVdIENvZGU6IDUzIDQ4IDg5IGZiIDQxIDUyIDQ4IGZm
IDA1IGMzIDY2IDNjIDAxIDQ4IGM3IDQ1IGUwIDAwIDAwIDAwIDAwIDQ4IDg1IGMwIDc0IDVi
IDQ4IGZmIDA1IGM3IDY2IDNjIDAxIDQ4IDhiIDEwIDQ4IDhiIDQ4IDA4IDQ4IDg1IGQyIDw0
OD4gODkgMTEgNzQgMGIgNDggODkgNGEgMDggNDggZmYgMDUgOWQgNjYgM2MgMDEgNDggOGIg
NTUgZTAgNDggClsgICAxMi40MTc5NzVdIFJJUCAgWzxmZmZmZmZmZjgxMTgxMjliPl0gdW1v
dW50X3RyZWUrMHgzZC8weDI5MApbICAgMTIuNDE3OTc1XSAgUlNQIDxmZmZmODgwMDEzOGE3
ZTg4PgpbICAgMTIuNDE3OTc1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEyLjQxNzk3
NV0gLS0tWyBlbmQgdHJhY2UgYThiZGY0MTQ0ZWNhNjg1NyBdLS0tClsgICAxMi40MTc5NzVd
IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxL2ZjYTFkNzcyYjZlMTJhNWU1ZTNlNTc0OWY4YjA2
NjUwYWVlY2JjNmMvZG1lc2cteW9jdG8taXZ5dG93bjItMTA6MjAxNDAzMjExMjA2NTU6eDg2
XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDQwLWdmY2ExZDc3OjMxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9mY2ExZDc3MmI2ZTEyYTVlNWUzZTU3
NDlmOGIwNjY1MGFlZWNiYzZjL2RtZXNnLXlvY3RvLWl2eXRvd24yLTEyOjIwMTQwMzIxMTIw
NjAxOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDA0MC1nZmNhMWQ3
NzozMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvZmNhMWQ3NzJiNmUxMmE1
ZTVlM2U1NzQ5ZjhiMDY2NTBhZWVjYmM2Yy9kbWVzZy15b2N0by1pdnl0b3duMi0yNDoyMDE0
MDMyMTEyMDUwNDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwNDAt
Z2ZjYTFkNzc6MzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxL2ZjYTFkNzcy
YjZlMTJhNWU1ZTNlNTc0OWY4YjA2NjUwYWVlY2JjNmMvZG1lc2cteW9jdG8tYXRoZW5zLTE0
OjIwMTQwMzIxMTIwNTUwOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0w
MDA0MC1nZmNhMWQ3NzozMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvZmNh
MWQ3NzJiNmUxMmE1ZTVlM2U1NzQ5ZjhiMDY2NTBhZWVjYmM2Yy9kbWVzZy15b2N0by1sa3At
c3QwMS0zOjIwMTQwMzIxMTIwNTQ3Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4w
LXJjNy0wMDA0MC1nZmNhMWQ3NzozMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAz
MjEvZmNhMWQ3NzJiNmUxMmE1ZTVlM2U1NzQ5ZjhiMDY2NTBhZWVjYmM2Yy9kbWVzZy15b2N0
by1pbm4tMTE6MjAxNDAzMjExMjA1NDE6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9mY2ExZDc3MmI2ZTEyYTVlNWUzZTU3
NDlmOGIwNjY1MGFlZWNiYzZjL2RtZXNnLXlvY3RvLWl2eXRvd24yLTI4OjIwMTQwMzIxMTIw
NjM1Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDA0MC1nZmNhMWQ3
NzozMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvZmNhMWQ3NzJiNmUxMmE1
ZTVlM2U1NzQ5ZjhiMDY2NTBhZWVjYmM2Yy9kbWVzZy15b2N0by1pdnl0b3duMi0yNzoyMDE0
MDMyMTEyMDY1NDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwNDAt
Z2ZjYTFkNzc6MzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxL2ZjYTFkNzcy
YjZlMTJhNWU1ZTNlNTc0OWY4YjA2NjUwYWVlY2JjNmMvZG1lc2cteW9jdG8taXZ5dG93bjIt
MjU6MjAxNDAzMjExMjA2NDI6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3
LTAwMDQwLWdmY2ExZDc3OjMxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9m
Y2ExZDc3MmI2ZTEyYTVlNWUzZTU3NDlmOGIwNjY1MGFlZWNiYzZjL2RtZXNnLXlvY3RvLWJl
bnMtNjoyMDE0MDMyMTEyMDYyNTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1y
YzctMDAwNDAtZ2ZjYTFkNzc6MzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIx
L2ZjYTFkNzcyYjZlMTJhNWU1ZTNlNTc0OWY4YjA2NjUwYWVlY2JjNmMvZG1lc2cteW9jdG8t
aXZ5dG93bjItMjM6MjAxNDAzMjExMjA2NTY6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMToz
LjE0LjAtcmM3LTAwMDQwLWdmY2ExZDc3OjMxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzQtMDMyMS9mY2ExZDc3MmI2ZTEyYTVlNWUzZTU3NDlmOGIwNjY1MGFlZWNiYzZjL2RtZXNn
LXlvY3RvLXNuYi00NjoyMDE0MDMyMTEyMDYwNjp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIx
OjoKMTI6MTI6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMt
MjUgMDU6NDk6NDcgUkVQRUFUIENPVU5UOiAzMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Mi9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDQwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbOTJmZWY5OWI4OGE4NTRhNmRi
ZmQyNWZiMWM0MzA1NjYyYTE4MjQ1Ml0gMGRheSBiYXNlIGd1YXJkIGZvciAnZGV2ZWwtY2Fp
cm8teDg2XzY0LTIwMTQwMzIxMTAyMScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM0
LTAzMjEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTQwMzIxMTAyMTo5MmZl
Zjk5Yjg4YTg1NGE2ZGJmZDI1ZmIxYzQzMDU2NjJhMTgyNDUyOmJpc2VjdC1saW51eDIKIFNV
Q0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIHZmcy91bnRlc3RlZC1t
bnRfaGFzaApsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVh
ci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgZmNhMWQ3NzJiNmUxMmE1ZTVlM2U1NzQ5Zjhi
MDY2NTBhZWVjYmM2YyA5MmZlZjk5Yjg4YTg1NGE2ZGJmZDI1ZmIxYzQzMDU2NjJhMTgyNDUy
IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDkyZmVmOTkuLi4gMGRheSBiYXNlIGd1
YXJkIGZvciAnZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTQwMzIxMTAyMScKSEVBRCBpcyBub3cg
YXQgZDE5NjlhOC4uLiBwZXJjcHVfY291bnRlcjogdW5icmVhayBfX3BlcmNwdV9jb3VudGVy
X2FkZCgpCkJpc2VjdGluZzogMTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDQgc3RlcHMpCls4YTIxZDlmNjNkZDQ3NDg1OTY0YjkzMGFmNDEzMDRkODhk
ZWUwZTliXSBNZXJnZSBicmFuY2ggJ3Vwc3RyZWFtJyBvZiBnaXQ6Ly9naXQubGludXgtbWlw
cy5vcmcvcHViL3NjbS9yYWxmL3Vwc3RyZWFtLWxpbnVzCmxpbmVhci1iaXNlY3Q6IGdpdCBi
aXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzQtMDMyMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjEx
MDIxOjhhMjFkOWY2M2RkNDc0ODU5NjRiOTMwYWY0MTMwNGQ4OGRlZTBlOWI6YmlzZWN0LWxp
bnV4MgoKMjAxNC0wMy0yNS0wNTo0OTo1NiA4YTIxZDlmNjNkZDQ3NDg1OTY0YjkzMGFmNDEz
MDRkODhkZWUwZTliIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS84
YTIxZDlmNjNkZDQ3NDg1OTY0YjkzMGFmNDEzMDRkODhkZWUwZTliL3ZtbGludXotMy4xNC4w
LXJjNy0wMDAxOS1nOGEyMWQ5ZgoKMjAxNC0wMy0yNS0wNTo0OTo1NiBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLgkzCTEwCTE0CTIxCTI5CTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTAgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltlYTFj
ZDY1YTY0OGJkOThmZjlkMDI4YTY0NzQ2MmQyODMxM2FhZGZkXSBNZXJnZSBicmFuY2ggJ3Rp
bWVycy11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
YzQtMDMyMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjExMDIxOmVh
MWNkNjVhNjQ4YmQ5OGZmOWQwMjhhNjQ3NDYyZDI4MzEzYWFkZmQ6YmlzZWN0LWxpbnV4MgoK
MjAxNC0wMy0yNS0wNTo1Mzo1NyBlYTFjZDY1YTY0OGJkOThmZjlkMDI4YTY0NzQ2MmQyODMx
M2FhZGZkIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9lYTFjZDY1
YTY0OGJkOThmZjlkMDI4YTY0NzQ2MmQyODMxM2FhZGZkL3ZtbGludXotMy4xNC4wLXJjNy0w
MDAyOC1nZWExY2Q2NQoKMjAxNC0wMy0yNS0wNTo1Mzo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4JNgk3Li4uCTEyCTE5CTI1CTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzg4Nzg0Mzk2
MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTNdIG1tOiBmaXggYmFkIHJzcy1jb3Vu
dGVyIGlmIHJlbWFwX2ZpbGVfcGFnZXMgcmFjZWQgbWlncmF0aW9uCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1jNC0wMzIxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0y
MDE0MDMyMTEwMjE6ODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1Mzpi
aXNlY3QtbGludXgyCgoyMDE0LTAzLTI1LTA1OjU5OjU4IDg4Nzg0Mzk2MWM0YjQ2ODFlZTk5
M2MzNmQ0OTk3YmY0YjRhYTgyNTMgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMvdm1saW51
ei0zLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5CgoyMDE0LTAzLTI1LTA1OjU5OjU5IGRldGVj
dGluZyBib290IHN0YXRlIC4uCTMJNgk3CTEzCTI3CTI5CTMwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKWzhjZWZiOTcwYWEzYjk0Mzc3NTU0ZDUwODM2MTE3NjhmZjI1N2NlMTldIHJlc2l6YWJs
ZSBuYW1lc3BhY2UuYyBoYXNoZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAz
MjEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTQwMzIxMTAyMTo4Y2VmYjk3
MGFhM2I5NDM3NzU1NGQ1MDgzNjExNzY4ZmYyNTdjZTE5OmJpc2VjdC1saW51eDIKIFNVQ0NF
U1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMSBzdGVwKQpbM2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5
NV0gc3dpdGNoIG1udF9oYXNoIHRvIGhsaXN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jNC0wMzIxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDE0MDMyMTEwMjE6
M2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NTpiaXNlY3QtbGludXgy
CiBURVNUIEZBSUxVUkUKWyAgICAyLjgzNzUxNV0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1l
bW9yeTogMTgzMksgKGZmZmY4ODAwMDFhMzYwMDAgLSBmZmZmODgwMDAxYzAwMDAwKQpbICAg
IDIuODQ1NTg0XSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA4NzZLIChmZmZmODgw
MDAxZjI1MDAwIC0gZmZmZjg4MDAwMjAwMDAwMCkKWyAgICAyLjg1NTA0MF0gcmFuZG9tOiBp
bml0IHVyYW5kb20gcmVhZCB3aXRoIDMgYml0cyBvZiBlbnRyb3B5IGF2YWlsYWJsZQpbICAg
MTMuMjM5MTk1XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBk
ZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAxMy4yMzk4MDNdIElQOiBbPGZm
ZmZmZmZmODExODEyOWI+XSB1bW91bnRfdHJlZSsweDNkLzB4MjkwClsgICAxMy4yMzk4MDNd
IFBHRCAwIApbICAgMTMuMjM5ODAzXSBPb3BzOiAwMDAyIFsjMV0gClsgICAxMy4yMzk4MDNd
IE1vZHVsZXMgbGlua2VkIGluOgpbICAgMTMuMjM5ODAzXSBDUFU6IDAgUElEOiA3MTAzIENv
bW06IHRyaW5pdHktYzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0wMDAzOC1nM2Q1NDQwNiAj
MzkKWyAgIDEzLjIzOTgwM10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgMTMuMjM5ODAzXSB0YXNrOiBmZmZmODgwMDAwMThjNjYwIHRp
OiBmZmZmODgwMDBmYWVhMDAwIHRhc2sudGk6IGZmZmY4ODAwMGZhZWEwMDAKWyAgIDEzLjIz
OTgwM10gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTE4MTI5Yj5dICBbPGZmZmZmZmZmODExODEy
OWI+XSB1bW91bnRfdHJlZSsweDNkLzB4MjkwClsgICAxMy4yMzk4MDNdIFJTUDogMDAxODpm
ZmZmODgwMDBmYWViZTQ4ICBFRkxBR1M6IDAwMDEwMjQ2ClsgICAxMy4yMzk4MDNdIFJBWDog
ZmZmZjg4MDAwZjg3NjA4MCBSQlg6IGZmZmY4ODAwMGY4NzYwODAgUkNYOiAwMDAwMDAwMDAw
MDAwMDAwClsgICAxMy4yMzk4MDNdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAw
MDAwMDAwMDAwMDAgUkRJOiBmZmZmODgwMDBmODc2MDgwClsgICAxMy4yMzk4MDNdIFJCUDog
ZmZmZjg4MDAwZmFlYmU2OCBSMDg6IGZmZmY4ODAwMGZmZmJmYzAgUjA5OiAwMDAwMDAwMDAw
MDAwMDAwClsgICAxMy4yMzk4MDNdIFIxMDogMDAwMDAwMDAwMDAwMDAwMiBSMTE6IDAwMDAw
MDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAxMy4yMzk4MDNdIFIxMzog
ZmZmZjg4MDAwZmFlYmU0OCBSMTQ6IGZmZmY4ODAwMDAwNzQzZTAgUjE1OiAwMDAwMDAwMDAw
MDAwMDAwClsgICAxMy4yMzk4MDNdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpm
ZmZmZmZmZjgyMDMwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDEzLjIz
OTgwM10gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAz
YgpbICAgMTMuMjM5ODAzXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDBm
YWFiMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMApbICAgMTMuMjM5ODAzXSBEUjA6IDAwMDAw
MDAwMDA2OGUwMDAgRFIxOiAwMDAwMDAwMDAwNjhlMDAwIERSMjogMDAwMDAwMDAwMDAwMDAw
MApbICAgMTMuMjM5ODAzXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZm
ZmYwZmYwIERSNzogMDAwMDAwMDAwMDA1MDYwMgpbICAgMTMuMjM5ODAzXSBTdGFjazoKWyAg
IDEzLjIzOTgwM10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZjg3NjBhMCBmZmZmODgw
MDAwMThjNjYwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEzLjIzOTgwM10gIGZmZmY4ODAwMGZh
ZWJlODAgZmZmZmZmZmY4MTE4MjMwZiBmZmZmODgwMDBmYWI4YjgwIGZmZmY4ODAwMGZhZWJl
OTgKWyAgIDEzLjIzOTgwM10gIGZmZmZmZmZmODExODNjN2UgZmZmZjg4MDAwZDY4MzQwOCBm
ZmZmODgwMDBmYWViZWIwIGZmZmZmZmZmODEwYmE2ZmUKWyAgIDEzLjIzOTgwM10gQ2FsbCBU
cmFjZToKWyAgIDEzLjIzOTgwM10gIFs8ZmZmZmZmZmY4MTE4MjMwZj5dIGRyb3BfY29sbGVj
dGVkX21vdW50cysweDQ4LzB4NzkKWyAgIDEzLjIzOTgwM10gIFs8ZmZmZmZmZmY4MTE4M2M3
ZT5dIHB1dF9tbnRfbnMrMHgzZS8weDU3ClsgICAxMy4yMzk4MDNdICBbPGZmZmZmZmZmODEw
YmE2ZmU+XSBmcmVlX25zcHJveHkrMHgyNC8weGIxClsgICAxMy4yMzk4MDNdICBbPGZmZmZm
ZmZmODEwYmE4ZTU+XSBzd2l0Y2hfdGFza19uYW1lc3BhY2VzKzB4OTUvMHhhMwpbICAgMTMu
MjM5ODAzXSAgWzxmZmZmZmZmZjgxMGJhOTA1Pl0gZXhpdF90YXNrX25hbWVzcGFjZXMrMHgx
Mi8weDFiClsgICAxMy4yMzk4MDNdICBbPGZmZmZmZmZmODEwOTg2YWY+XSBkb19leGl0KzB4
NTEyLzB4Y2FjClsgICAxMy4yMzk4MDNdICBbPGZmZmZmZmZmODEwOTkwMjA+XSBkb19ncm91
cF9leGl0KzB4ZTYvMHhmZQpbICAgMTMuMjM5ODAzXSAgWzxmZmZmZmZmZjgxMDk5MDRlPl0g
U3lTX2V4aXRfZ3JvdXArMHgxNi8weDE2ClsgICAxMy4yMzk4MDNdICBbPGZmZmZmZmZmODFh
MjhiYjc+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKWyAgIDEzLjIzOTgwM10g
Q29kZTogNTMgNDggODkgZmIgNDEgNTIgNDggZmYgMDUgYzMgNjYgM2MgMDEgNDggYzcgNDUg
ZTAgMDAgMDAgMDAgMDAgNDggODUgYzAgNzQgNWIgNDggZmYgMDUgYzcgNjYgM2MgMDEgNDgg
OGIgMTAgNDggOGIgNDggMDggNDggODUgZDIgPDQ4PiA4OSAxMSA3NCAwYiA0OCA4OSA0YSAw
OCA0OCBmZiAwNSA5ZCA2NiAzYyAwMSA0OCA4YiA1NSBlMCA0OCAKWyAgIDEzLjIzOTgwM10g
UklQICBbPGZmZmZmZmZmODExODEyOWI+XSB1bW91bnRfdHJlZSsweDNkLzB4MjkwClsgICAx
My4yMzk4MDNdICBSU1AgPGZmZmY4ODAwMGZhZWJlNDg+ClsgICAxMy4yMzk4MDNdIENSMjog
MDAwMDAwMDAwMDAwMDAwMApbICAgMTMuMjM5ODAzXSAtLS1bIGVuZCB0cmFjZSBkMGM2YjJi
YjVkYjUyYWJmIF0tLS0KWyAgIDEzLjIzOTgwM10gS2VybmVsIHBhbmljIC0gbm90IHN5bmNp
bmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEv
M2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1q
YWtldG93bi0xNzoyMDE0MDMyMTE0NTE0NDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDky
ZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItMzA6MjAxNDAzMjEx
NDQxMTI6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDM4LWczZDU0
NDA2OjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRj
MGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTIwOjIw
MTQwMzIxMTQ0MjMwOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDAz
OC1nM2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQw
NmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1pdnl0b3du
Mi04OjIwMTQwMzIxMTQ0NzA2Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJj
Ny0wMDAzOC1nM2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEv
M2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1p
dnl0b3duMi0yODoyMDE0MDMyMTE0NDYzNjp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMu
MTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2ct
eW9jdG8taXZ5dG93bjItMToyMDE0MDMyMTE0NDcwODp4ODZfNjQtcmFuZGNvbmZpZy1jNC0w
MzIxOjMuMTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUv
ZG1lc2cteW9jdG8taXZ5dG93bjItMjQ6MjAxNDAzMjExNDQyNTg6eDg2XzY0LXJhbmRjb25m
aWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBh
ZWE5Nzk1L2RtZXNnLXlvY3RvLWpha2V0b3duLTQ1OjIwMTQwMzIxMTQ1MzAxOng4Nl82NC1y
YW5kY29uZmlnLWM0LTAzMjE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEv
M2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1p
dnl0b3duMi0xMzoyMDE0MDMyMTE0NDcwOTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMu
MTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2ct
eW9jdG8tamFrZXRvd24tODoyMDE0MDMyMTE0NTE0NDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0w
MzIxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMw
ZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItMzA6MjAx
NDAzMjExNDQ2MzM6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDM4
LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2
ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWpha2V0b3du
LTE0OjIwMTQwMzIxMTQ1MjI5Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0
NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1qYWtldG93bi0zMzoyMDE0MDMyMTE0NTI1NDp4
ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2ct
eW9jdG8taXZ5dG93bjItMTg6MjAxNDAzMjExNDQ0MzY6eDg2XzY0LXJhbmRjb25maWctYzQt
MDMyMTozLjE0LjAtcmM3LTAwMDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTk6MjAxNDAzMjExNDQ2Mzg6eDg2XzY0LXJhbmRjb25m
aWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBh
ZWE5Nzk1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTU6MjAxNDAzMjExNDQ3MDI6eDg2XzY0LXJh
bmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2
MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTIyOjIwMTQwMzIxMTQ0MTIxOng4
Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDAzOC1nM2Q1NDQwNjozOQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQzYzY0YzBlN2UwOTJm
ODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1qYWtldG93bi01OjIwMTQwMzIxMTQ1
MjA3Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM0LTAzMjEvM2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9k
bWVzZy15b2N0by1qYWtldG93bi02OjIwMTQwMzIxMTQ1NDE4Ong4Nl82NC1yYW5kY29uZmln
LWM0LTAzMjE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQz
YzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1pdnl0b3duMi0x
OToyMDE0MDMyMTE0NDEyMTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzct
MDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNk
NTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8tamFr
ZXRvd24tMTM6MjAxNDAzMjExNDUyNDA6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4
Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTE5OjIwMTQwMzIxMTQ0
NjMzOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDAzOC1nM2Q1NDQw
NjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQzYzY0YzBl
N2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1pdnl0b3duMi0xOjIwMTQw
MzIxMTQ0MzI0Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDAzOC1n
M2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQz
YzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1pdnl0b3duMi04
OjIwMTQwMzIxMTQ0MzIyOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0w
MDAzOC1nM2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1
NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1pdnl0
b3duMi0yMToyMDE0MDMyMTE0NDYzMzp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQu
MC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0w
MzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9j
dG8tamFrZXRvd24tMzA6MjAxNDAzMjExNDUzNTA6eDg2XzY0LXJhbmRjb25maWctYzQtMDMy
MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3
ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWF0aGVucy0zODoyMDE0MDMy
MTE0NDQzMDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwMzgtZzNk
NTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2
NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItMTE6
MjAxNDAzMjExNDQ0NTk6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAw
MDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0
NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWpha2V0
b3duLTQwOjIwMTQwMzIxMTQ1MjEzOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvM2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5
OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by14cHMtNDoyMDE0MDMyMTE0NDM0Njp4ODZf
NjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgy
OTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItOToyMDE0MDMyMTE0NDEz
Nzp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6
MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdl
MDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8tamFrZXRvd24tMTk6MjAxNDAz
MjExNDUxMzM6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzQtMDMyMS8zZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5
Nzk1L2RtZXNnLXlvY3RvLWpha2V0b3duLTc6MjAxNDAzMjExNDUxNTk6eDg2XzY0LXJhbmRj
b25maWctYzQtMDMyMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0
NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWl2eXRv
d24yLTIxOjIwMTQwMzIxMTQ0MjQ4Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4w
LXJjNy0wMDAzOC1nM2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAz
MjEvM2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0
by1qYWtldG93bi0yNjoyMDE0MDMyMTE0NTI1NTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIx
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdl
MDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItNToyMDE0MDMy
MTE0NDMxODp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwMzgtZzNk
NTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzNkNTQ0MDZkM2M2
NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2cteW9jdG8taXZ5dG93bjItMTI6
MjAxNDAzMjExNDQyMzQ6eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAw
MDM4LWczZDU0NDA2OjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS8zZDU0
NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1L2RtZXNnLXlvY3RvLWNhaXJv
LTEzOjIwMTQwMzIxMTQ0MjA4Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJj
Ny0wMDAzOC1nM2Q1NDQwNjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEv
M2Q1NDQwNmQzYzY0YzBlN2UwOTJmODI5OWM0NjBlYmUwYWVhOTc5NS9kbWVzZy15b2N0by1p
dnl0b3duMi0yODoyMDE0MDMyMTE0NDI1MTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMu
MTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxLzNkNTQ0MDZkM2M2NGMwZTdlMDkyZjgyOTljNDYwZWJlMGFlYTk3OTUvZG1lc2ct
eW9jdG8taXZ5dG93bjItNDoyMDE0MDMyMTE0NDUwMTp4ODZfNjQtcmFuZGNvbmZpZy1jNC0w
MzIxOjMuMTQuMC1yYzctMDAwMzgtZzNkNTQ0MDY6MzkKNDE6NDA6NDQgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMjUgMDY6MDQ6MzEgUkVQRUFUIENPVU5U
OiAzMSAgIyAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpC
aXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDAgc3RlcHMpCls2YTkyZmFhMWQ2NDdkNzhlYzU0NTA2ZDc4M2M1YTdjZTUwM2I0ODQzXSBz
bWFydGVyIHByb3BhZ2F0ZV9tbnQoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzQt
MDMyMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjExMDIxOjZhOTJm
YWExZDY0N2Q3OGVjNTQ1MDZkNzgzYzVhN2NlNTAzYjQ4NDM6YmlzZWN0LWxpbnV4MgoKMjAx
NC0wMy0yNS0wNjowNDozMiA2YTkyZmFhMWQ2NDdkNzhlYzU0NTA2ZDc4M2M1YTdjZTUwM2I0
ODQzIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS82YTkyZmFhMWQ2
NDdkNzhlYzU0NTA2ZDc4M2M1YTdjZTUwM2I0ODQzL3ZtbGludXotMy4xNC4wLXJjNy0wMDAz
Ny1nNmE5MmZhYQoKMjAxNC0wMy0yNS0wNjowNDozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
Li4JMQk0CTUJOAkxMwkyMQkyNQkyNwkzMAkzMSBTVUNDRVNTCgozZDU0NDA2ZDNjNjRjMGU3
ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1p
dCAzZDU0NDA2ZDNjNjRjMGU3ZTA5MmY4Mjk5YzQ2MGViZTBhZWE5Nzk1CkF1dGhvcjogQWwg
VmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+CkRhdGU6ICAgVGh1IE1hciAyMCAyMTox
MDo1MSAyMDE0IC0wNDAwCgogICAgc3dpdGNoIG1udF9oYXNoIHRvIGhsaXN0CiAgICAKICAg
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCiAgICBTaWduZWQtb2ZmLWJ5OiBBbCBWaXJv
IDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az4KCjowNDAwMDAgMDQwMDAwIDI2ZWUxMDNjYWFm
MTllZjMzZmVlNmMzMmUwYTZmZjUwZTcxNmQ4OGEgMzRiOTNlNmIzNGFkNDE5ZWRjOTBjNWM2
MWZmOGU0N2RhODJhYWNlOCBNCWZzCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9saW51eC1k
ZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjExMDIxOjZhOTJmYWExZDY0N2Q3OGVj
NTQ1MDZkNzgzYzVhN2NlNTAzYjQ4NDM6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0yNS0wNjox
MTowMyA2YTkyZmFhMWQ2NDdkNzhlYzU0NTA2ZDc4M2M1YTdjZTUwM2I0ODQzIHJldXNlIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS82YTkyZmFhMWQ2NDdkNzhlYzU0NTA2
ZDc4M2M1YTdjZTUwM2I0ODQzL3ZtbGludXotMy4xNC4wLXJjNy0wMDAzNy1nNmE5MmZhYQoK
MjAxNC0wMy0yNS0wNjoxMTowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk3CTEzCTI0CTM0
CTU1CTY1CTc0CTkzIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4
Nl82NC0yMDE0MDMyMTEwMjE6NzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNi
MmQ5NzpiaXNlY3QtbGludXgyCiBURVNUIEZBSUxVUkUKWyAgICAyLjA2MDk1NV0gRnJlZWlu
ZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMTgzMksgKGZmZmY4ODAwMDFhMzYwMDAgLSBmZmZm
ODgwMDAxYzAwMDAwKQpbICAgIDIuMDY5MDc1XSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVt
b3J5OiA4NzZLIChmZmZmODgwMDAxZjI1MDAwIC0gZmZmZjg4MDAwMjAwMDAwMCkKS2VybmVs
IHRlc3RzOiBCb290IE9LIQpbICAyMjAuNDQ4NzIzXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUg
a2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGZmZmZmZmZmODExNzYxMTIKWyAgMjIwLjQ0OTU5
OF0gSVA6IFs8ZmZmZmZmZmY4MTE3NzFhMj5dIGRlbnRyeV9raWxsLmlzcmEuMjUrMHhkMC8w
eDJjYgpbICAyMjAuNDQ5NTk4XSBQR0QgMjAxNTA2NyBQVUQgMjAxNjA2MyBQTUQgMTAwMDFl
MSAKWyAgMjIwLjQ0OTU5OF0gT29wczogMDAwMyBbIzFdIApbICAyMjAuNDQ5NTk4XSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgMjIwLjQ0OTU5OF0gQ1BVOiAwIFBJRDogMzYwIENvbW06IHVt
b3VudCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LTAwMDk2LWc3N2E2N2NjICMyNwpbICAyMjAu
NDQ5NTk4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgIDIyMC40NDk1OThdIHRhc2s6IGZmZmY4ODAwMGUzYzE5NjAgdGk6IGZmZmY4ODAw
MGUzMTAwMDAgdGFzay50aTogZmZmZjg4MDAwZTMxMDAwMApbICAyMjAuNDQ5NTk4XSBSSVA6
IDAwMTA6WzxmZmZmZmZmZjgxMTc3MWEyPl0gIFs8ZmZmZmZmZmY4MTE3NzFhMj5dIGRlbnRy
eV9raWxsLmlzcmEuMjUrMHhkMC8weDJjYgpbICAyMjAuNDQ5NTk4XSBSU1A6IDAwMTg6ZmZm
Zjg4MDAwZTMxMWVhMCAgRUZMQUdTOiAwMDAxMDIwMgpbICAyMjAuNDQ5NTk4XSBSQVg6IGZm
ZmZmZmZmODExNzYxMTIgUkJYOiBmZmZmODgwMDBlZmQxODEwIFJDWDogZmZmZjg4MDAwZTdk
ZWFiOApbICAyMjAuNDQ5NTk4XSBSRFg6IGZmZmY4ODAwMGU3ZGVhYjggUlNJOiBmZmZmZmZm
ZjgxMTdmMzdmIFJESTogZmZmZjg4MDAwZWZkMTgxMApbICAyMjAuNDQ5NTk4XSBSQlA6IGZm
ZmY4ODAwMGUzMTFlYjggUjA4OiAwMDAwMDAwMGZmZmZmZmZmIFIwOTogMDAwMDAwMDAwMDAw
MDAwMApbICAyMjAuNDQ5NTk4XSBSMTA6IDAwMDAwMDAwMDA3Mzc0NzAgUjExOiBmZmZmODgw
MDBmOThjMDI1IFIxMjogZmZmZjg4MDAwZTdkZWI5MApbICAyMjAuNDQ5NTk4XSBSMTM6IGZm
ZmY4ODAwMGVjMDc1ZDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogZmZmZjg4MDAwZTdk
ZWE4MApbICAyMjAuNDQ5NTk4XSBGUzogIDAwMDA3ZWZmZWUwMTc3MDAoMDAwMCkgR1M6ZmZm
ZmZmZmY4MjAzMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgIDIyMC40NDk1
OThdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMK
WyAgMjIwLjQ0OTU5OF0gQ1IyOiBmZmZmZmZmZjgxMTc2MTEyIENSMzogMDAwMDAwMDAwZTM5
NTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZjAKWyAgMjIwLjQ0OTU5OF0gU3RhY2s6ClsgIDIy
MC40NDk1OThdICBmZmZmODgwMDBlZmQxODEwIGZmZmY4ODAwMGU3ZGViOTAgZmZmZjg4MDAw
ZTdkZWE4MCBmZmZmODgwMDBlMzExZWQwClsgIDIyMC40NDk1OThdICBmZmZmZmZmZjgxMTc3
OWM4IGZmZmY4ODAwMGU3ZGViOTAgZmZmZjg4MDAwZTMxMWVlOCBmZmZmZmZmZjgxMTY4NjM4
ClsgIDIyMC40NDk1OThdICBmZmZmODgwMDBlN2RlYTgwIGZmZmY4ODAwMGUzMTFmMDggZmZm
ZmZmZmY4MTE3ZmRhMiBmZmZmODgwMDBlN2RlYWEwClsgIDIyMC40NDk1OThdIENhbGwgVHJh
Y2U6ClsgIDIyMC40NDk1OThdICBbPGZmZmZmZmZmODExNzc5Yzg+XSBkcHV0KzB4MTg0LzB4
MWI4ClsgIDIyMC40NDk1OThdICBbPGZmZmZmZmZmODExNjg2Mzg+XSBwYXRoX3B1dCsweDE4
LzB4MzEKWyAgMjIwLjQ0OTU5OF0gIFs8ZmZmZmZmZmY4MTE3ZmRhMj5dIG5hbWVzcGFjZV91
bmxvY2srMHhiOC8weGQxClsgIDIyMC40NDk1OThdICBbPGZmZmZmZmZmODExODFmMDk+XSBT
eVNfdW1vdW50KzB4NGE0LzB4NGYyClsgIDIyMC40NDk1OThdICBbPGZmZmZmZmZmODExM2M5
ZGI+XSA/IHZtX211bm1hcCsweDVkLzB4NzIKWyAgMjIwLjQ0OTU5OF0gIFs8ZmZmZmZmZmY4
MWEyOGJiNz5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAyMjAuNDQ5NTk4
XSBDb2RlOiBmZiAwNSAyMyBjZiAzYyAwMSBlOCBkYyBkZCBmZiBmZiA0OCBmZiAwNSAxZiBj
ZiAzYyAwMSA0OCBmZiAwNSAwMCBhZiAzYyAwMSA0OCA4YiA4MyA5OCAwMCAwMCAwMCA0OCA4
YiA5MyA5MCAwMCAwMCAwMCA0OCA4OSA0MiAwOCA8NDg+IDg5IDEwIDQ4IGI4IDAwIDAxIDEw
IDAwIDAwIDAwIGFkIGRlIDQ4IDg5IDgzIDkwIDAwIDAwIDAwIDgxIApbICAyMjAuNDQ5NTk4
XSBSSVAgIFs8ZmZmZmZmZmY4MTE3NzFhMj5dIGRlbnRyeV9raWxsLmlzcmEuMjUrMHhkMC8w
eDJjYgpbICAyMjAuNDQ5NTk4XSAgUlNQIDxmZmZmODgwMDBlMzExZWEwPgpbICAyMjAuNDQ5
NTk4XSBDUjI6IGZmZmZmZmZmODExNzYxMTIKWyAgMjIwLjQ0OTU5OF0gLS0tWyBlbmQgdHJh
Y2UgNTdhMTQwZGUwZGQ5MzM1OSBdLS0tClsgIDIyMC40NDk1OThdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jNC0wMzIxLzc3YTY3Y2MzNGI2M2MwZjg2OGYwYmI2NmU3YzIzZGQyNzQzYjJkOTcvZG1l
c2cteW9jdG8tbGtwLXNiMDQtNTE6MjAxNDAzMjUwNTQyMjg6eDg2XzY0LXJhbmRjb25maWct
YzQtMDMyMTozLjE0LjAtcmM3LTAwMDk2LWc3N2E2N2NjOjI3Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzQtMDMyMS83N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZlN2MyM2RkMjc0M2Iy
ZDk3L2RtZXNnLXlvY3RvLWl2eXRvd24yLTExOjIwMTQwMzIxMTEwODM2Ong4Nl82NC1yYW5k
Y29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDA5Ni1nNzdhNjdjYzoyNwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNk
ZDI3NDNiMmQ5Ny9kbWVzZy15b2N0by1pbm4tMTM6MjAxNDAzMjExMTA3MjY6eDg2XzY0LXJh
bmRjb25maWctYzQtMDMyMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS83
N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZlN2MyM2RkMjc0M2IyZDk3L2RtZXNnLXlvY3RvLWl2
eXRvd24yLTIyOjIwMTQwMzIxMTEwNTU4Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4x
NC4wLXJjNy0wMDA5Ni1nNzdhNjdjYzoyNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0
LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNiMmQ5Ny9kbWVzZy15
b2N0by1sa3Atc2IwNC02OjIwMTQwMzI1MDU0MjUxOng4Nl82NC1yYW5kY29uZmlnLWM0LTAz
MjE6My4xNC4wLXJjNy0wMDA5Ni1nNzdhNjdjYzoyNwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM0LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNiMmQ5Ny9k
bWVzZy15b2N0by14aWFuLTc6MjAxNDAzMjExMDQ1MTQ6eDg2XzY0LXJhbmRjb25maWctYzQt
MDMyMTozLjE0LjAtcmM3LTAwMDk2LWc3N2E2N2NjOjI3Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzQtMDMyMS83N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZlN2MyM2RkMjc0M2IyZDk3
L2RtZXNnLXlvY3RvLXNuYi0xMzoyMDE0MDMyMTEwNDYzNzp4ODZfNjQtcmFuZGNvbmZpZy1j
NC0wMzIxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzc3YTY3Y2MzNGI2
M2MwZjg2OGYwYmI2NmU3YzIzZGQyNzQzYjJkOTcvZG1lc2cteW9jdG8tc25iLTQyOjIwMTQw
MzIxMTA0NjQyOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWM0LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNi
MmQ5Ny9kbWVzZy15b2N0by1pdnl0b3duMi00OjIwMTQwMzIxMTEwODA5Ong4Nl82NC1yYW5k
Y29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0wMDA5Ni1nNzdhNjdjYzoyNwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNk
ZDI3NDNiMmQ5Ny9kbWVzZy15b2N0by1yb2FtLTM6MjAxNDAzMjExMDQ0NDQ6eDg2XzY0LXJh
bmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDk2LWc3N2E2N2NjOjI3Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS83N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZlN2My
M2RkMjc0M2IyZDk3L2RtZXNnLXlvY3RvLXJvYW0tMzc6MjAxNDAzMjExMTA3MzY6eDg2XzY0
LXJhbmRjb25maWctYzQtMDMyMTozLjE0LjAtcmM3LTAwMDk2LWc3N2E2N2NjOjI3Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS83N2E2N2NjMzRiNjNjMGY4NjhmMGJiNjZl
N2MyM2RkMjc0M2IyZDk3L2RtZXNnLXlvY3RvLWlubi0zMzoyMDE0MDMyMTEwNDUwNTp4ODZf
NjQtcmFuZGNvbmZpZy1jNC0wMzIxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0w
MzIxLzc3YTY3Y2MzNGI2M2MwZjg2OGYwYmI2NmU3YzIzZGQyNzQzYjJkOTcvZG1lc2cteW9j
dG8taW5uLTQ0OjIwMTQwMzIxMTEwNzMyOng4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvNzdhNjdjYzM0YjYzYzBmODY4ZjBi
YjY2ZTdjMjNkZDI3NDNiMmQ5Ny9kbWVzZy15b2N0by1pdnl0b3duMi0yNjoyMDE0MDMyMTEx
MDc1MDp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwOTYtZzc3YTY3
Y2M6MjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzc3YTY3Y2MzNGI2M2Mw
Zjg2OGYwYmI2NmU3YzIzZGQyNzQzYjJkOTcvZG1lc2cteW9jdG8taXZ5dG93bjItOToyMDE0
MDMyMTEwNDUxODp4ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxOjMuMTQuMC1yYzctMDAwOTYt
Zzc3YTY3Y2M6MjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLzc3YTY3Y2Mz
NGI2M2MwZjg2OGYwYmI2NmU3YzIzZGQyNzQzYjJkOTcvZG1lc2cteW9jdG8tYXRoZW5zLTIw
OjIwMTQwMzIxMTEwNzU1Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4wLXJjNy0w
MDA5Ni1nNzdhNjdjYzoyNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvNzdh
NjdjYzM0YjYzYzBmODY4ZjBiYjY2ZTdjMjNkZDI3NDNiMmQ5Ny9kbWVzZy15b2N0by1pdnl0
b3duMi0yOjIwMTQwMzIxMTA0NTE0Ong4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjE6My4xNC4w
LXJjNy0wMDA5Ni1nNzdhNjdjYzoyNwoxMjoxNzoxNyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKW2RldGFjaGVkIEhFQUQgOTM1OGU2OF0gUmV2ZXJ0ICJzd2l0Y2ggbW50X2hhc2gg
dG8gaGxpc3QiCiA0IGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDUwIGRlbGV0
aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzQtMDMyMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjEx
MDIxOjkzNThlNjgyOGFmNDJkZmUyNWI0OGNlNjYwNzMyZDkxN2VkZDNkZTY6YmlzZWN0LWxp
bnV4MgoKMjAxNC0wMy0yNS0wNjoxNjowNiA5MzU4ZTY4MjhhZjQyZGZlMjViNDhjZTY2MDcz
MmQ5MTdlZGQzZGU2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEtOTM1OGU2ODI4YWY0
MmRmZTI1YjQ4Y2U2NjA3MzJkOTE3ZWRkM2RlNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS85MzU4ZTY4MjhhZjQyZGZlMjViNDhjZTY2
MDczMmQ5MTdlZGQzZGU2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLTkzNThlNjgyOGFmNDJk
ZmUyNWI0OGNlNjYwNzMyZDkxN2VkZDNkZTYKc3RhdHVzOiBGQUlMOiBubyBjb21taXQgOTM1
OGU2ODI4YWY0MmRmZTI1YjQ4Y2U2NjA3MzJkOTE3ZWRkM2RlNiBmb3IgYnVpbGQgdGFzayB4
ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLTkzNThlNjgyOGFmNDJkZmUyNWI0OGNlNjYwNzMy
ZDkxN2VkZDNkZTYKMjAxNC0wMy0yNS0wNjoxNzowNiA5MzU4ZTY4MjhhZjQyZGZlMjViNDhj
ZTY2MDczMmQ5MTdlZGQzZGU2IFNLSVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvOTM1OGU2ODI4YWY0MmRmZTI1YjQ4Y2U2
NjA3MzJkOTE3ZWRkM2RlNgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpXYXJuaW5n
OiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFu
eSBvZiB5b3VyIGJyYW5jaGVzOgoKICA5MzU4ZTY4IFJldmVydCAic3dpdGNoIG1udF9oYXNo
IHRvIGhsaXN0IgoKSWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3
IGJyYW5jaCwgdGhpcyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQg
YnJhbmNoIG5ld19icmFuY2hfbmFtZSA5MzU4ZTY4CgpIRUFEIGlzIG5vdyBhdCA3NzQ4Njhj
Li4uIE1lcmdlIGJyYW5jaCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS9saW51
eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxNDAzMjExMDIxOjc3NDg2OGM3MDk0ZDM1
YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmM6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0yNS0w
NjoxNzowNyA3NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0ZGUwMDBhNWQxMWZjIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEtNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRl
MDAwYTVkMTFmYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzQtMDMyMS83NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0ZGUwMDBhNWQxMWZjCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1jNC0wMzIxLTc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAw
MGE1ZDExZmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLTc3NDg2OGM3MDk0ZDM1YjQ1MThi
ZTNkMGU2NTRkZTAwMGE1ZDExZmMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWM0LTAzMjEvNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYy92bWxp
bnV6LTMuMTQuMC1yYzctMDAwNjUtZzc3NDg2OGMKCjIwMTQtMDMtMjUtMDY6MjM6MDcgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxCTEwCTEyCTI1CTI5CTMxCTM2CTQ0CTUzCTYxCTY3CTcx
CTczCTc3CTgwCTg1CTg5CTkzIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09
PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNzc0ODY4Yy4uLiBNZXJnZSBicmFu
Y2ggJ3BlcmYtdXJnZW50LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKSEVBRCBpcyBub3cgYXQgMDk4YmMxNi4u
LiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMjQKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM0LTAzMjEvbGlu
dXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTQwMzIxMTAyMTowOThiYzE2MWJmYzc2
OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBlOWRkOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMjUt
MDY6MzI6NDEgMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZCBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1jNC0wMzIxLTA5OGJjMTYxYmZjNzY5N2Y3ZTJjYTE1NDAwZjEz
Y2ExYWM2MGU5ZGQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM0LTAzMjEvMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctYzQtMDMyMS0wOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2Nh
MWFjNjBlOWRkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYzQtMDMyMS0wOThiYzE2MWJmYzc2OTdmN2Uy
Y2ExNTQwMGYxM2NhMWFjNjBlOWRkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jNC0wMzIxLzA5OGJjMTYxYmZjNzY5N2Y3ZTJjYTE1NDAwZjEzY2ExYWM2MGU5ZGQvdm1s
aW51ei0zLjE0LjAtcmM3LW5leHQtMjAxNDAzMjQKCjIwMTQtMDMtMjUtMDY6Mzk6NDEgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzCTE4CTI2CTM4CTU3CTcxCTkxLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTkzIFNVQ0NFU1MKCg==

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-00038-g3d54406"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc7 Kernel Configuration
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
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
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
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
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

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
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
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
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
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=m
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=m
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=y
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CONNTRACK_LABELS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=y
# CONFIG_NF_CT_PROTO_SCTP is not set
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=y
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=y
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_MARK=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
CONFIG_NETFILTER_XT_MATCH_CGROUP=y
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_L2TP=y
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=y
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=m
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=y
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_6LOWPAN is not set
CONFIG_6LOWPAN_IPHC=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=m
CONFIG_CGROUP_NET_PRIO=m
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCMCIA=m
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_SOFTING=m
CONFIG_CAN_SOFTING_CS=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=m
# CONFIG_OLD_BELKIN_DONGLE is not set
# CONFIG_ACT200L_DONGLE is not set
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_CMTP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
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
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
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
CONFIG_CONNECTOR=m
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
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
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
CONFIG_INTEL_MIC_CARD=m
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
CONFIG_VHOST_NET=m
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=m
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=m
# CONFIG_NET_VENDOR_BROADCOM is not set
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
CONFIG_DNET=m
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
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
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
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
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
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
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
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=m
# CONFIG_WIZNET_W5300 is not set
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=y
# CONFIG_PPTP is not set
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH_CARDS=m
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_WOW=y
# CONFIG_ATH9K_LEGACY_RATE_CONTROL is not set
CONFIG_ATH9K_RFKILL=y
CONFIG_ATH9K_HTC=m
CONFIG_ATH9K_HTC_DEBUGFS=y
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
CONFIG_AR5523=m
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
CONFIG_WCN36XX=m
# CONFIG_WCN36XX_DEBUGFS is not set
CONFIG_B43=m
CONFIG_B43_BCMA=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
# CONFIG_BRCMFMAC is not set
CONFIG_BRCM_TRACING=y
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=m
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=m
# CONFIG_RT2800USB_RT33XX is not set
# CONFIG_RT2800USB_RT35XX is not set
CONFIG_RT2800USB_RT3573=y
# CONFIG_RT2800USB_RT53XX is not set
# CONFIG_RT2800USB_RT55XX is not set
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RTL_CARDS is not set
CONFIG_WL_TI=y
CONFIG_WL1251=m
CONFIG_WL12XX=m
# CONFIG_WL18XX is not set
CONFIG_WLCORE=m
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y
# CONFIG_MWIFIEX is not set
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DRV_LOOP=m
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_DIEHLDIVA is not set
CONFIG_HISAX_SEDLBAUER=y
# CONFIG_HISAX_NETJET is not set
# CONFIG_HISAX_NETJET_U is not set
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
# CONFIG_HISAX_W6692 is not set
CONFIG_HISAX_HFC_SX=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
# CONFIG_HISAX_FRITZ_PCIPNP is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_HYSDN is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=y
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set
CONFIG_ISDN_HDLC=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
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
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_SUR40 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_TWL6040_VIBRA=m
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

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
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
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
CONFIG_SERIAL_8250_CS=y
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
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_XEN=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
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
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=m

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
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=m
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
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
CONFIG_DA9055_WATCHDOG=m
CONFIG_DW_WATCHDOG=y
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AB3100=m
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9055=m
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MAX77693 is not set
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=m
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS80031=m
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
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
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
CONFIG_FB_UVESA=m
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=m
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
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
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=m
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=m
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
# CONFIG_TAHVO_USB is not set
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
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_PCF50633 is not set
CONFIG_RTC_DRV_AB3100=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
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
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
# CONFIG_XEN_COMPAT_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=y
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
CONFIG_PRISM2_USB=m
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
# CONFIG_COMEDI_BOND is not set
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_PCMCIA_DRIVERS=y
CONFIG_COMEDI_CB_DAS16_CS=m
# CONFIG_COMEDI_DAS08_CS is not set
# CONFIG_COMEDI_NI_DAQ_700_CS is not set
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
# CONFIG_COMEDI_NI_LABPC_CS is not set
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
# CONFIG_COMEDI_USBDUX is not set
CONFIG_COMEDI_USBDUXFAST=m
# CONFIG_COMEDI_USBDUXSIGMA is not set
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
CONFIG_R8188EU=m
CONFIG_88EU_AP_MODE=y
CONFIG_88EU_P2P=y
# CONFIG_R8821AE is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_RTS5208 is not set
CONFIG_TRANZPORT=y
CONFIG_USB_SERIAL_QUATECH2=m
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_WLAGS49_H2=m
CONFIG_WLAGS49_H25=m
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
CONFIG_SPEAKUP_SYNTH_APOLLO=m
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
CONFIG_SPEAKUP_SYNTH_BNS=y
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
CONFIG_SPEAKUP_SYNTH_DECEXT=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=y
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
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
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

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
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_MAX77693=m
CONFIG_EXTCON_MAX8997=m
# CONFIG_EXTCON_PALMAS is not set
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
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
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
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_SENSORS_LM3533=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_MAG3110=m
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
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
# CONFIG_EXT4_FS is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
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
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
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
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
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
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

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
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
CONFIG_FONT_10x18=y

--gKMricLos+KVdGMg--
