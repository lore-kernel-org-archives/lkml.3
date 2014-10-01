Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaJAGAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:00:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:1378 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJAGAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:00:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,630,1406617200"; 
   d="log'?scan'208";a="599148324"
Date: Wed, 1 Oct 2014 14:00:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vfs] BUG: unable to handle kernel NULL pointer dereference at
           (null)
Message-ID: <20141001060005.GA16272@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jan,

0day kernel testing robot got the below dmesg and the first bad commit is

commit 82d9745eb11a03c976778629e15f5a752c09c346
Author:     Jan Kara <jack@suse.cz>
AuthorDate: Mon Sep 29 15:10:26 2014 +0200
Commit:     Jan Kara <jack@suse.cz>
CommitDate: Tue Sep 30 22:44:10 2014 +0200

    vfs: Remove i_dquot field from inode
    
    All filesystems using VFS quotas are now converted to use their private
    i_dquot fields. Remove the i_dquot field from generic inode structure.
    
    Signed-off-by: Jan Kara <jack@suse.cz>

+------------------------------------------+------------+------------+------------------+
|                                          | f1b4496910 | 82d9745eb1 | v3.17-rc7_100105 |
+------------------------------------------+------------+------------+------------------+
| boot_successes                           | 900        | 110        | 21               |
| boot_failures                            | 0          | 7          | 11               |
| BUG:unable_to_handle_kernel              | 0          | 7          | 11               |
| Oops                                     | 0          | 7          | 11               |
| RIP:dquot_drop                           | 0          | 7          | 11               |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 7          | 11               |
| backtrace:do_mount                       | 0          | 7          | 11               |
| backtrace:SyS_mount                      | 0          | 7          | 11               |
+------------------------------------------+------------+------------+------------------+

[    7.565155] UDF-fs: warning (device vde): udf_fill_super: No partition found (2)
[    7.574458] Mount JFS Failure: -22
[    7.588464] UDF-fs: warning (device vdf): udf_fill_super: No partition found (2)
[    7.590200] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    7.591153] IP: [<ffffffff811596d9>] dquot_drop+0x19/0x40
[    7.591153] PGD 10c97067 PUD 11166067 PMD 0 
[    7.591153] Oops: 0000 [#1] 
[    7.591153] CPU: 0 PID: 378 Comm: mount Not tainted 3.17.0-rc5-00035-g82d9745 #2
[    7.591153] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.591153] task: ffff8800110de660 ti: ffff8800113f0000 task.ti: ffff8800113f0000
[    7.591153] RIP: 0010:[<ffffffff811596d9>]  [<ffffffff811596d9>] dquot_drop+0x19/0x40
[    7.591153] RSP: 0018:ffff8800113f3d10  EFLAGS: 00010246
[    7.591153] RAX: 0000000000000000 RBX: ffff880012a20b28 RCX: 00000001c4692862
[    7.591153] RDX: 00000001c46928b4 RSI: ffff8800110de660 RDI: ffff880012a20b28
[    7.591153] RBP: ffff8800113f3d10 R08: 000000000000003c R09: ffff8800111b8cb0
[    7.591153] R10: ffffffff82693280 R11: 0000000000000000 R12: ffffffff81ebdd80
[    7.591153] R13: ffffffff81ebdd80 R14: 0000000000000001 R15: ffff880012803940
[    7.591153] FS:  00007f08c87d9700(0000) GS:ffffffff82421000(0000) knlGS:0000000000000000
[    7.591153] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.591153] CR2: 0000000000000000 CR3: 0000000011070000 CR4: 00000000000006f0
[    7.591153] Stack:
[    7.591153]  ffff8800113f3d28 ffffffff81267174 ffff880012a20b28 ffff8800113f3d48
[    7.591153]  ffffffff81120354 ffff880012a20b28 ffff8800111f9c00 ffff8800113f3d70
[    7.591153]  ffffffff81121054 ffff8800111f9c00 ffff8800114e3200 00000000ffffffea
[    7.591153] Call Trace:
[    7.591153]  [<ffffffff81267174>] jfs_evict_inode+0x44/0xb0
[    7.591153]  [<ffffffff81120354>] evict+0xa4/0x170
[    7.591153]  [<ffffffff81121054>] iput+0xe4/0x180
[    7.591153]  [<ffffffff812662f9>] jfs_fill_super+0x1b9/0x380
[    7.591153]  [<ffffffff8110b5d9>] mount_bdev+0x189/0x1c0
[    7.591153]  [<ffffffff81266140>] ? jfs_remount+0x1b0/0x1b0
[    7.591153]  [<ffffffff81265300>] jfs_do_mount+0x10/0x20
[    7.591153]  [<ffffffff8110b813>] mount_fs+0x33/0x1c0
[    7.591153]  [<ffffffff81124d86>] vfs_kern_mount+0x66/0x110
[    7.591153]  [<ffffffff81126b43>] do_mount+0x243/0xad0
[    7.591153]  [<ffffffff810e4f23>] ? strndup_user+0x43/0x60
[    7.591153]  [<ffffffff81127780>] SyS_mount+0x80/0xc0
[    7.591153]  [<ffffffff81c05f30>] tracesys+0xcf/0xd4
[    7.591153] Code: 00 00 55 be ff ff ff ff 48 89 e5 e8 22 f4 ff ff 5d c3 f6 47 0c 20 55 48 89 e5 75 23 48 8b 47 28 48 63 80 50 02 00 00 85 c0 75 17 <48> 83 3c 25 00 00 00 00 00 75 15 31 c0 48 83 78 08 00 75 0c 5d 
[    7.591153] RIP  [<ffffffff811596d9>] dquot_drop+0x19/0x40
[    7.591153]  RSP <ffff8800113f3d10>
[    7.591153] CR2: 0000000000000000
[    7.701394] ---[ end trace d15805ff3c6dc4f0 ]---
[    7.702424] Kernel panic - not syncing: Fatal exception

git bisect start b7dc959e9806a432742f3b0281ddcb2b815d5ee0 fe82dcec644244676d55a1384c958d5f67979adb --
git bisect  bad 896c409a43c873671d6d4e76e273268d37ed3dc0  # 09:49      0-      9  Merge 'mlankhorst/for-airlied-next' into devel-hourly-2014100105
git bisect  bad 261017646561f0325ec0114cee6436d7d35876a8  # 09:49      0-     39  Merge 'asoc/topic/fsl-ssi' into devel-hourly-2014100105
git bisect  bad 7b2a30edb3fef527829150a866aefcd0b27ef80f  # 09:49      0-     27  Merge 'ext3/for_testing' into devel-hourly-2014100105
git bisect good e86c44f8456590196d1144baa71d80f1c32e953e  # 10:00    117+      0  0day base guard for 'devel-hourly-2014100105'
git bisect good 10ca79a39f393163d05dd628c8d83551e4bbcf8f  # 10:11    117+      0  ocfs2: Convert to private i_dquot field
git bisect good 37993271cfa22b5620304f1fa3bf72eabb5b557b  # 10:32    117+      0  udf: remove redundant sys_tz declaration
git bisect  bad 82d9745eb11a03c976778629e15f5a752c09c346  # 10:42     64-      1  vfs: Remove i_dquot field from inode
git bisect good f1b4496910c730f7938b6777a610576275a3bb31  # 10:58    300+      0  reiserfs: Convert to private i_dquot field
# first bad commit: [82d9745eb11a03c976778629e15f5a752c09c346] vfs: Remove i_dquot field from inode
git bisect good f1b4496910c730f7938b6777a610576275a3bb31  # 11:12    900+      0  reiserfs: Convert to private i_dquot field
git bisect  bad b7dc959e9806a432742f3b0281ddcb2b815d5ee0  # 11:12      0-     11  0day head guard for 'devel-hourly-2014100105'
git bisect good aad7fb916a10f1065ad23de0c80a4a04bcba8437  # 11:50    900+      0  Merge branch 'fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm
git bisect good cb4b16caa8a58ee593c22f0876f9d921f10cd237  # 12:04    900+      0  Add linux-next specific files for 20140930


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
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
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
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

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-55:20141001104247:x86_64-randconfig-s0-10010819:3.17.0-rc5-00035-g82d9745:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.17.0-rc5-00035-g82d9745 (kbuild@snb) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-11) ) #2 Wed Oct 1 10:36:48 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s0-10010819/linux-devel:devel-hourly-2014100105:82d9745eb11a03c9767786=
29e15f5a752c09c346:bisect-linux-2/.vmlinuz-82d9745eb11a03c976778629e15f5a75=
2c09c346-20141001103709-97-vp branch=3Dlinux-devel/devel-hourly-2014100105 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-s0-10010819/82d9745eb11a03c976778629=
e15f5a752c09c346/vmlinuz-3.17.0-rc5-00035-g82d9745 drbd.minor_count=3D8
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02765000, 0x02765fff] PGTABLE
[    0.000000] BRK [0x02766000, 0x02766fff] PGTABLE
[    0.000000] BRK [0x02767000, 0x02767fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02768000, 0x02768fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2431d40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s0-10010819/linux-devel:devel-hourly-2014100105:82d9745eb11a03c=
976778629e15f5a752c09c346:bisect-linux-2/.vmlinuz-82d9745eb11a03c976778629e=
15f5a752c09c346-20141001103709-97-vp branch=3Dlinux-devel/devel-hourly-2014=
100105 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s0-10010819/82d9745eb11a03c97=
6778629e15f5a752c09c346/vmlinuz-3.17.0-rc5-00035-g82d9745 drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 293884K/327280K available (12325K kernel code, 1387K=
 rwdata, 4972K rodata, 1044K init, 1036K bss, 33396K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.17.0-rc5-00035-g82d9745 (kbuild@snb) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-11) ) #2 Wed Oct 1 10:36:48 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s0-10010819/linux-devel:devel-hourly-2014100105:82d9745eb11a03c9767786=
29e15f5a752c09c346:bisect-linux-2/.vmlinuz-82d9745eb11a03c976778629e15f5a75=
2c09c346-20141001103709-97-vp branch=3Dlinux-devel/devel-hourly-2014100105 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-s0-10010819/82d9745eb11a03c976778629=
e15f5a752c09c346/vmlinuz-3.17.0-rc5-00035-g82d9745 drbd.minor_count=3D8
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02765000, 0x02765fff] PGTABLE
[    0.000000] BRK [0x02766000, 0x02766fff] PGTABLE
[    0.000000] BRK [0x02767000, 0x02767fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02768000, 0x02768fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2431d40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s0-10010819/linux-devel:devel-hourly-2014100105:82d9745eb11a03c=
976778629e15f5a752c09c346:bisect-linux-2/.vmlinuz-82d9745eb11a03c976778629e=
15f5a752c09c346-20141001103709-97-vp branch=3Dlinux-devel/devel-hourly-2014=
100105 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s0-10010819/82d9745eb11a03c97=
6778629e15f5a752c09c346/vmlinuz-3.17.0-rc5-00035-g82d9745 drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 293884K/327280K available (12325K kernel code, 1387K=
 rwdata, 4972K rodata, 1044K init, 1036K bss, 33396K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.530 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.06 Bogo=
MIPS (lpj=3D2693530)
[    0.004005] pid_max: default: 32768 minimum: 301
[    0.005012] ACPI: Core revision 20140724
[    0.006757] ACPI: All ACPI Tables successfully acquired
[    0.007784] Security Framework initialized
[    0.008016] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.009006] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.010159] Initializing cgroup subsys devices
[    0.011008] Initializing cgroup subsys freezer
[    0.012007] Initializing cgroup subsys net_cls
[    0.013007] Initializing cgroup subsys net_prio
[    0.014069] mce: CPU supports 10 MCE banks
[    0.015054] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015054] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016004] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.034255] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.036114] Getting VERSION: 50014
[    0.037012] Getting VERSION: 50014
[    0.038011] Getting ID: 0
[    0.039013] Getting ID: ff000000
[    0.040013] Getting LVT0: 8700
[    0.041008] Getting LVT1: 8400
[    0.042083] enabled ExtINT on CPU#0
[    0.044264] ENABLING IO-APIC IRQs
[    0.045013] init IO_APIC IRQs
[    0.046005]  apic 0 pin 0 not connected
[    0.046937] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.047022] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.048021] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.049020] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.050020] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.051020] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.052020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.053021] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.054021] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.055020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.056020] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.057020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.058020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.059020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060027] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.061020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.062018]  apic 0 pin 16 not connected
[    0.063003]  apic 0 pin 17 not connected
[    0.063924]  apic 0 pin 18 not connected
[    0.064003]  apic 0 pin 19 not connected
[    0.065003]  apic 0 pin 20 not connected
[    0.066003]  apic 0 pin 21 not connected
[    0.067003]  apic 0 pin 22 not connected
[    0.068003]  apic 0 pin 23 not connected
[    0.069148] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070003] Using local APIC timer interrupts.
[    0.070003] calibrating APIC timer ...
[    0.072000] ... lapic delta =3D 6249769
[    0.072000] ... PM-Timer delta =3D 357938
[    0.072000] ... PM-Timer result ok
[    0.072000] ..... delta 6249769
[    0.072000] ..... mult: 268425534
[    0.072000] ..... calibration result: 999963
[    0.072000] ..... CPU clock speed is 2693.0280 MHz.
[    0.072000] ..... host bus clock speed is 999.0963 MHz.
[    0.072155] devtmpfs: initialized
[    0.073895] NET: Registered protocol family 16
[    0.075360] cpuidle: using governor ladder
[    0.076015] cpuidle: using governor menu
[    0.077328] ACPI: bus type PCI registered
[    0.078027] dca service started, version 1.12.1
[    0.079035] PCI: Using configuration type 1 for base access
[    0.085183] Running resizable hashtable tests...
[    0.086005]   Adding 2048 keys
[    0.087590]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.089138]   Table expansion iteration 0...
[    0.090310]   Verifying lookups...
[    0.091148]   Table expansion iteration 1...
[    0.092422]   Verifying lookups...
[    0.093140]   Table expansion iteration 2...
[    0.095362]   Verifying lookups...
[    0.096157]   Table expansion iteration 3...
[    0.098130]   Verifying lookups...
[    0.099137]   Table shrinkage iteration 0...
[    0.100167]   Verifying lookups...
[    0.101149]   Table shrinkage iteration 1...
[    0.102097]   Verifying lookups...
[    0.103138]   Table shrinkage iteration 2...
[    0.104059]   Verifying lookups...
[    0.105144]   Table shrinkage iteration 3...
[    0.106040]   Verifying lookups...
[    0.107157]   Deleting 2048 keys
[    0.108419] ACPI: Added _OSI(Module Device)
[    0.109003] ACPI: Added _OSI(Processor Device)
[    0.110003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.111003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.113147] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.116227] ACPI: Interpreter enabled
[    0.117007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    0.119004] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    0.121011] ACPI: (supports S0 S3 S5)
[    0.122002] ACPI: Using IOAPIC for interrupt routing
[    0.123020] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.126706] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.127008] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.128009] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.129143] PCI host bridge to bus 0000:00
[    0.131004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.132004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.133004] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.135004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.136004] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.138035] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.139430] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.140601] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.144361] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.147034] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.148004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.149004] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.150004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.151180] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.152412] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.153014] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.154245] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.157042] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.160041] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.170047] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.171568] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.173005] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.175009] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.183005] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.184226] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.186004] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.189004] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.197430] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.199697] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.201004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.209374] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.211004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.214005] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.222435] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.224697] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.226004] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.234380] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.236005] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.239005] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.247424] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.249004] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.252004] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.260371] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.262378] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.267764] pci_bus 0000:00: on NUMA node 0
[    0.269487] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.271524] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.273122] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.275105] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.276908] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.278686] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.280296] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.281003] vgaarb: loaded
[    0.281734] vgaarb: bridge control possible 0000:00:02.0
[    0.283444] SCSI subsystem initialized
[    0.284039] libata version 3.00 loaded.
[    0.285099] ACPI: bus type USB registered
[    0.286054] usbcore: registered new interface driver usbfs
[    0.287033] usbcore: registered new interface driver hub
[    0.288045] usbcore: registered new device driver usb
[    0.289115] media: Linux media interface: v0.10
[    0.290027] Linux video capture interface: v2.00
[    0.292031] pps_core: LinuxPPS API ver. 1 registered
[    0.293006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.294016] PTP clock support registered
[    0.295029] EDAC MC: Ver: 3.0.0
[    0.296223] Advanced Linux Sound Architecture Driver Initialized.
[    0.297040] PCI: Using ACPI for IRQ routing
[    0.298008] PCI: pci_cache_line_size set to 64 bytes
[    0.299232] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.300007] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.301281] NET: Registered protocol family 23
[    0.302041] Bluetooth: Core ver 2.19
[    0.303018] NET: Registered protocol family 31
[    0.304007] Bluetooth: HCI device and connection manager initialized
[    0.305011] Bluetooth: HCI socket layer initialized
[    0.306009] Bluetooth: L2CAP socket layer initialized
[    0.307025] Bluetooth: SCO socket layer initialized
[    0.308047] nfc: nfc_init: NFC Core ver 0.1
[    0.309022] NET: Registered protocol family 39
[    0.311160] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.312084] Switched to clocksource kvm-clock
[    0.313233] FS-Cache: Loaded
[    0.314048] CacheFiles: Loaded
[    0.314869] pnp: PnP ACPI init
[    0.315727] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.317559] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.318919] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.320731] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.322103] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.323921] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.325292] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.327085] pnp 00:03: [dma 2]
[    0.327880] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.329270] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.331078] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.332453] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.334242] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.335627] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.337417] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.338946] pnp: PnP ACPI: found 7 devices
[    0.346241] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.347437] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.348627] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.349916] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.351229] NET: Registered protocol family 1
[    0.352250] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.353512] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.354745] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.356048] pci 0000:00:02.0: Boot video device
[    0.357149] PCI: CLS 0 bytes, default 64
[    0.358156] Unpacking initramfs...
[    0.423935] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.426118] Machine check injector initialized
[    0.427338] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.429315] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.431322] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.433406] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    0.434821] PCLMULQDQ-NI instructions are not detected.
[    0.435959] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.437265] AVX or AES-NI instructions are not detected.
[    0.438410] AVX instructions are not detected.
[    0.439418] AVX instructions are not detected.
[    0.440427] AVX2 or AES-NI instructions are not detected.
[    0.441743] futex hash table entries: 256 (order: 0, 6144 bytes)
[    0.443039] Initialise system trusted keyring
[    0.444250] zbud: loaded
[    0.445145] VFS: Disk quotas dquot_6.5.2
[    0.446107] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.447606] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    0.448717] fuse init (API version 7.23)
[    0.449748] JFS: nTxBlock =3D 2320, nTxLock =3D 18562
[    0.452296] SGI XFS with security attributes, no debug enabled
[    0.453685] NILFS version 2 loaded
[    0.454621] ocfs2: Registered cluster interface o2cb
[    0.455750] OCFS2 User DLM kernel interface loaded
[    0.457299] gfs2: GFS2 installed
[    0.458887] NET: Registered protocol family 38
[    0.459916] Key type asymmetric registered
[    0.460885] Asymmetric key parser 'x509' registered
[    0.461986] Key type pkcs7_test registered
[    0.462962] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.464658] io scheduler noop registered
[    0.465587] io scheduler deadline registered (default)
[    0.466780] test_firmware: interface ready
[    0.468150] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    0.469310] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    0.470796] vmlfb: initializing
[    0.471644] Could not find Carillo Ranch MCH device.
[    0.472824] hgafb: HGA card not detected.
[    0.473780] hgafb: probe of hgafb.0 failed with error -22
[    0.474987] usbcore: registered new interface driver udlfb
[    0.476213] ipmi message handler version 39.2
[    0.477213] ipmi device interface
[    0.478075] IPMI System Interface driver.
[    0.479056] ipmi_si: Unable to find any System Interface(s)
[    0.480246] IPMI Watchdog: driver initialized
[    0.481331] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.483030] ACPI: Power Button [PWRF]
[    0.484226] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.485940] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.487175] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.490666] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.491895] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.495599] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.499100] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.508671] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.538040] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.540208] Initializing Nozomi driver 2.1d
[    0.541211] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    0.542621] ac.o: No PCI boards found.
[    0.543516] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    0.544994] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.546102] smapi::smapi_init, ERROR invalid usSmapiID
[    0.547207] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    0.549172] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    0.550814] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    0.552119] Linux agpgart interface v0.103
[    0.553158] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    0.554490] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.556530] parport_pc 00:04: reported by Plug and Play ACPI
[    0.557870] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    0.642531] Floppy drive(s): fd0 is 1.44M
[    0.643874] skd:  v2.2.1-b0260 loaded
[    0.644941] virtio-pci 0000:00:04.0: irq 24 for MSI/MSI-X
[    0.646103] virtio-pci 0000:00:04.0: irq 25 for MSI/MSI-X
[    0.648376]  vda: unknown partition table
[    0.651039] virtio-pci 0000:00:05.0: irq 26 for MSI/MSI-X
[    0.652197] virtio-pci 0000:00:05.0: irq 27 for MSI/MSI-X
[    0.661933] FDC 0 is a S82078B
[    0.663124]  vdb: unknown partition table
[    0.665722] virtio-pci 0000:00:06.0: irq 28 for MSI/MSI-X
[    0.666891] virtio-pci 0000:00:06.0: irq 29 for MSI/MSI-X
[    0.681600]  vdc: unknown partition table
[    0.684202] virtio-pci 0000:00:07.0: irq 30 for MSI/MSI-X
[    0.685362] virtio-pci 0000:00:07.0: irq 31 for MSI/MSI-X
[    0.687556]  vdd: unknown partition table
[    0.690122] virtio-pci 0000:00:08.0: irq 32 for MSI/MSI-X
[    0.691288] virtio-pci 0000:00:08.0: irq 33 for MSI/MSI-X
[    0.693467]  vde: unknown partition table
[    0.709090] virtio-pci 0000:00:09.0: irq 34 for MSI/MSI-X
[    0.710246] virtio-pci 0000:00:09.0: irq 35 for MSI/MSI-X
[    0.712421]  vdf: unknown partition table
[    0.714913] mtip32xx Version 1.3.1
[    0.715800] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    0.717296] mic_init not running on X100 ret -19
[    0.718383] usbcore: registered new interface driver rtsx_usb
[    0.719745] usbcore: registered new interface driver viperboard
[    0.721018] usbcore: registered new interface driver port100
[    0.722286] rdac: device handler registered
[    0.723293] hp_sw: device handler registered
[    0.724266] alua: device handler registered
[    0.725221] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    0.726519] osst :I: Tape driver with OnStream support version 0.99.4
[    0.726519] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    0.742117] SCSI Media Changer driver v0.25=20
[    0.743290] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    0.745677] libphy: Fixed MDIO Bus: probed
[    0.750925] arcnet loaded.
[    0.751676] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    0.753056] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    0.767740] arcnet: raw mode (`r') encapsulation support loaded.
[    0.768991] arcnet: COM90xx chipset support
[    1.288723] S3: No ARCnet cards found.
[    1.289740] usbcore: registered new interface driver stir4200
[    1.291801] usbcore: registered new interface driver mcs7780
[    1.293023] usbcore: registered new interface driver kingsun-sir
[    1.294330] PPP generic driver version 2.4.2
[    1.295404] PPP BSD Compression module registered
[    1.296463] PPP Deflate Compression module registered
[    1.297589] Loaded prism54 driver, version 1.2
[    1.299040] aoe: AoE v85 initialised.
[    1.299995] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.301343] ehci-pci: EHCI PCI platform driver
[    1.302413] ehci-platform: EHCI generic platform driver
[    1.303570] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.304864] ohci-pci: OHCI PCI platform driver
[    1.305941] ohci-platform: OHCI generic platform driver
[    1.307090] uhci_hcd: USB Universal Host Controller Interface driver
[    1.308481] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.311692] usbcore: registered new interface driver usblp
[    1.312919] usbcore: registered new interface driver cdc_wdm
[    1.314129] usbcore: registered new interface driver usbtmc
[    1.315318] usbcore: registered new interface driver uas
[    1.316517] usbcore: registered new interface driver usb-storage
[    1.317792] usbcore: registered new interface driver ums-alauda
[    1.319041] usbcore: registered new interface driver ums-cypress
[    1.320333] usbcore: registered new interface driver ums-datafab
[    1.321602] usbcore: registered new interface driver ums_eneub6250
[    1.322899] usbcore: registered new interface driver ums-isd200
[    1.324182] usbcore: registered new interface driver ums-karma
[    1.325414] usbcore: registered new interface driver ums-onetouch
[    1.326694] usbcore: registered new interface driver ums-realtek
[    1.328024] usbcore: registered new interface driver ums-sddr09
[    1.329266] usbcore: registered new interface driver ums-sddr55
[    1.330486] usbcore: registered new interface driver ums-usbat
[    1.331742] usbcore: registered new interface driver mdc800
[    1.332916] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.334660] usbcore: registered new interface driver microtekX6
[    1.335929] usbcore: registered new interface driver usbserial
[    1.337153] usbcore: registered new interface driver usbserial_generic
[    1.338511] usbserial: USB Serial support registered for generic
[    1.339756] usbcore: registered new interface driver aircable
[    1.340955] usbserial: USB Serial support registered for aircable
[    1.342245] usbcore: registered new interface driver ch341
[    1.343399] usbserial: USB Serial support registered for ch341-uart
[    1.344683] usbcore: registered new interface driver cp210x
[    1.345890] usbserial: USB Serial support registered for cp210x
[    1.347125] usbcore: registered new interface driver cyberjack
[    1.348334] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    1.350218] usbcore: registered new interface driver usb_debug
[    1.351425] usbserial: USB Serial support registered for debug
[    1.352657] usbcore: registered new interface driver digi_acceleport
[    1.353977] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    1.355646] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    1.357329] usbcore: registered new interface driver io_edgeport
[    1.358575] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    1.360217] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    1.361906] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    1.363576] usbserial: USB Serial support registered for EPiC device
[    1.364902] usbcore: registered new interface driver empeg
[    1.366062] usbserial: USB Serial support registered for empeg
[    1.367276] usbcore: registered new interface driver ftdi_sio
[    1.368535] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    1.370177] usbcore: registered new interface driver garmin_gps
[    1.371398] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    1.372832] usbcore: registered new interface driver ipaq
[    1.373976] usbserial: USB Serial support registered for PocketPC PDA
[    1.375306] usbcore: registered new interface driver ipw
[    1.376438] usbserial: USB Serial support registered for IPWireless conv=
erter
[    1.377853] usbcore: registered new interface driver ir_usb
[    1.379053] usbserial: USB Serial support registered for IR Dongle
[    1.380318] usbcore: registered new interface driver keyspan_pda
[    1.381556] usbserial: USB Serial support registered for Keyspan PDA
[    1.382893] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    1.384657] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    1.386609] usbcore: registered new interface driver kl5kusb105
[    1.387837] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    1.389539] usbcore: registered new interface driver mct_u232
[    1.394460] usbserial: USB Serial support registered for MCT U232
[    1.395718] usbcore: registered new interface driver mos7720
[    1.396902] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    1.402277] usbcore: registered new interface driver navman
[    1.403460] usbserial: USB Serial support registered for navman
[    1.404753] usbcore: registered new interface driver opticon
[    1.405936] usbserial: USB Serial support registered for opticon
[    1.407175] usbcore: registered new interface driver oti6858
[    1.408386] usbserial: USB Serial support registered for oti6858
[    1.409635] usbcore: registered new interface driver pl2303
[    1.410806] usbserial: USB Serial support registered for pl2303
[    1.412060] usbcore: registered new interface driver qcaux
[    1.413236] usbserial: USB Serial support registered for qcaux
[    1.414442] usbcore: registered new interface driver quatech2
[    1.415675] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    1.417520] usbcore: registered new interface driver safe_serial
[    1.418749] usbserial: USB Serial support registered for safe_serial
[    1.420067] usbcore: registered new interface driver sierra
[    1.421231] usbserial: USB Serial support registered for Sierra USB modem
[    1.422608] usbcore: registered new interface driver ssu100
[    1.423821] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    1.425660] usbcore: registered new interface driver ti_usb_3410_5052
[    1.426995] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    1.428721] tsc: Refined TSC clocksource calibration: 2693.407 MHz
[    1.429986] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    1.431724] usbcore: registered new interface driver visor
[    1.432893] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    1.434650] usbserial: USB Serial support registered for Sony Clie 5.0
[    1.435970] usbserial: USB Serial support registered for Sony Clie 3.5
[    1.437296] usbcore: registered new interface driver wishbone_serial
[    1.439613] usbserial: USB Serial support registered for wishbone_serial
[    1.440972] usbcore: registered new interface driver xsens_mt
[    1.442234] usbserial: USB Serial support registered for xsens_mt
[    1.443502] usbcore: registered new interface driver zte_ev
[    1.444683] usbserial: USB Serial support registered for zte_ev
[    1.445943] usbcore: registered new interface driver adutux
[    1.447127] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.448534] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    1.450352] usbcore: registered new interface driver idmouse
[    1.451562] usbcore: registered new interface driver isight_firmware
[    1.452912] usbcore: registered new interface driver usbled
[    1.454091] usbcore: registered new interface driver legousbtower
[    1.455340] usbcore: registered new interface driver usb_ehset_test
[    1.456929] usbcore: registered new interface driver trancevibrator
[    1.458217] usbcore: registered new interface driver uss720
[    1.459391] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    1.461389] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    1.463033] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    1.464685] uss720: If you just want to connect to a printer, use usblp =
instead
[    1.466354] usbcore: registered new interface driver yurex
[    1.468132] usbcore: registered new interface driver lvs
[    1.469450] usbip_core: usbip_core_init:761: USB/IP Core v1.0.0
[    1.470722] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    1.471981] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    1.473247] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    1.474694] vhci_hcd: vhci_start:883: enter vhci_start
[    1.476168] hub 1-0:1.0: USB hub found
[    1.477063] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[    1.478500] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[    1.479685] vhci_hcd: vhci_hub_control:396: port -1
[    1.480742] vhci_hcd: vhci_hub_control:403:  bye
[    1.481763] hub 1-0:1.0: 8 ports detected
[    1.482753] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[    1.484117] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[    1.485249] vhci_hcd: vhci_hub_control:396: port -1
[    1.486446] vhci_hcd: vhci_hub_control:403:  bye
[    1.487545] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[    1.488909] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.490240] vhci_hcd: vhci_hub_control:396: port 0
[    1.491280] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.494866] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.496599] vhci_hcd: dump_port_status_diff:119:=20
[    1.497676] vhci_hcd: vhci_hub_control:403:  bye
[    1.498698] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[    1.504302] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.505621] vhci_hcd: vhci_hub_control:396: port 1
[    1.506666] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.508596] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.509717] vhci_hcd: dump_port_status_diff:119:=20
[    1.510743] vhci_hcd: vhci_hub_control:403:  bye
[    1.511804] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[    1.513230] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.514542] vhci_hcd: vhci_hub_control:396: port 2
[    1.515632] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.517402] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.518581] vhci_hcd: dump_port_status_diff:119:=20
[    1.519638] vhci_hcd: vhci_hub_control:403:  bye
[    1.520659] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[    1.522012] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.523361] vhci_hcd: vhci_hub_control:396: port 3
[    1.524398] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.526158] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.527319] vhci_hcd: dump_port_status_diff:119:=20
[    1.528344] vhci_hcd: vhci_hub_control:403:  bye
[    1.529356] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[    1.530745] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.532046] vhci_hcd: vhci_hub_control:396: port 4
[    1.533100] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.534905] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.536025] vhci_hcd: dump_port_status_diff:119:=20
[    1.537045] vhci_hcd: vhci_hub_control:403:  bye
[    1.538098] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[    1.539448] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.540753] vhci_hcd: vhci_hub_control:396: port 5
[    1.541826] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.543615] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.544764] vhci_hcd: dump_port_status_diff:119:=20
[    1.545798] vhci_hcd: vhci_hub_control:403:  bye
[    1.546822] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[    1.548186] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.549545] vhci_hcd: vhci_hub_control:396: port 6
[    1.550581] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.552389] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.553510] vhci_hcd: dump_port_status_diff:119:=20
[    1.554541] vhci_hcd: vhci_hub_control:403:  bye
[    1.555555] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[    1.556970] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.558271] vhci_hcd: vhci_hub_control:396: port 7
[    1.559305] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.561110] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.562231] vhci_hcd: dump_port_status_diff:119:=20
[    1.563280] vhci_hcd: vhci_hub_control:403:  bye
[    1.564343] vhci_hcd: vhci_hcd_probe:1028: bye
[    1.565339] vhci_hcd: vhci_hcd_init:1150: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    1.567269] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.569755] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.570886] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.572233] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.574336] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.576215] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.578425] i2c /dev entries driver
[    1.579408] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    1.611199] usbcore: registered new interface driver i2c-diolan-u2c
[    1.612508] i2c-parport: adapter type unspecified
[    1.613542] i2c-parport-light: adapter type unspecified
[    1.614667] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    1.616533] usbcore: registered new interface driver ati_remote
[    1.617775] usbcore: registered new interface driver imon
[    1.618933] usbcore: registered new interface driver mceusb
[    1.620143] usbcore: registered new interface driver iguanair
[    1.621332] usbcore: registered new interface driver ttusbir
[    1.622556] Colour QuickCam for Video4Linux v0.06
[    2.362849] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 1
[    2.364269] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 1
[    2.365544] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    2.366845] vhci_hcd: vhci_hub_control:396: port 0
[    2.367908] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    2.369731] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.370876] vhci_hcd: dump_port_status_diff:119:=20
[    2.371929] vhci_hcd: vhci_hub_control:403:  bye
[    3.502739] No Quickcam found on port parport0
[    3.503826] Quickcam detection counter: 0
[    3.504838] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 2
[    3.506304] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 2
[    3.507643] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.509016] vhci_hcd: vhci_hub_control:396: port 1
[    3.510132] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.512039] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.513236] vhci_hcd: dump_port_status_diff:119:=20
[    3.524995] vhci_hcd: vhci_hub_control:403:  bye
[    3.526032] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 3
[    3.527400] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 3
[    3.532684] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.533969] vhci_hcd: vhci_hub_control:396: port 2
[    3.535016] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.540826] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.541952] vhci_hcd: dump_port_status_diff:119:=20
[    3.542985] vhci_hcd: vhci_hub_control:403:  bye
[    3.544018] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 4
[    3.545401] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 4
[    3.546649] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.547926] vhci_hcd: vhci_hub_control:396: port 3
[    3.549013] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.550791] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.551914] vhci_hcd: dump_port_status_diff:119:=20
[    3.552974] vhci_hcd: vhci_hub_control:403:  bye
[    3.554001] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 5
[    3.555361] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 5
[    3.556642] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.557919] vhci_hcd: vhci_hub_control:396: port 4
[    3.558967] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.560802] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.561921] vhci_hcd: dump_port_status_diff:119:=20
[    3.562956] vhci_hcd: vhci_hub_control:403:  bye
[    3.563988] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 6
[    3.565389] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 6
[    3.566628] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.567901] vhci_hcd: vhci_hub_control:396: port 5
[    3.568975] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.570763] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.571887] vhci_hcd: dump_port_status_diff:119:=20
[    3.572959] vhci_hcd: vhci_hub_control:403:  bye
[    3.573983] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 7
[    3.575768] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 7
[    3.577049] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.578328] vhci_hcd: vhci_hub_control:396: port 6
[    3.579371] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.581198] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.582320] vhci_hcd: dump_port_status_diff:119:=20
[    3.583346] vhci_hcd: vhci_hub_control:403:  bye
[    3.584844] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 8
[    3.586224] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 8
[    3.587461] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    3.588778] vhci_hcd: vhci_hub_control:396: port 7
[    3.589821] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.591612] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.592758] vhci_hcd: dump_port_status_diff:119:=20
[    3.593785] vhci_hcd: vhci_hub_control:403:  bye
[    3.636054] pps_ldisc: PPS line discipline registered
[    3.637151] pps_parport: parallel port PPS client
[    3.638256] pps pps0: new PPS source pps_parport
[    3.639816] pps_parport: attached to parport0
[    3.676054] w83793: Detection failed at check vendor id
[    3.683055] w83793: Detection failed at check vendor id
[    3.690058] w83793: Detection failed at check vendor id
[    3.697054] w83793: Detection failed at check vendor id
[    3.702058] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    3.707053] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    3.712056] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    3.717055] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    3.722058] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.727053] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.732055] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.737055] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.742057] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.747053] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.752057] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.757052] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.819105] i2c i2c-0: ADM1025 detection failed at 0x2c
[    3.824064] i2c i2c-0: ADM1025 detection failed at 0x2d
[    3.829057] i2c i2c-0: ADM1025 detection failed at 0x2e
[    3.836058] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    3.842448] i2c i2c-0: Autodetecting device at 0,0x2c...
[    3.843578] i2c i2c-0: Autodetection failed
[    3.851068] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    3.852834] i2c i2c-0: Autodetecting device at 0,0x2d...
[    3.853962] i2c i2c-0: Autodetection failed
[    3.860061] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    3.861813] i2c i2c-0: Autodetecting device at 0,0x2e...
[    3.862948] i2c i2c-0: Autodetection failed
[    3.982060]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.987057]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.992136]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.019066] applesmc: supported laptop not found!
[    4.020104] applesmc: driver init failed (ret=3D-19)!
[    4.119058]  (null): Unknown chip type, skipping
[    4.124056]  (null): Unknown chip type, skipping
[    4.139060] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    4.154055] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    4.170061] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    4.265056] i2c i2c-0: LM83 detection failed at 0x18
[    4.270055] i2c i2c-0: LM83 detection failed at 0x19
[    4.275055] i2c i2c-0: LM83 detection failed at 0x1a
[    4.280055] i2c i2c-0: LM83 detection failed at 0x29
[    4.285055] i2c i2c-0: LM83 detection failed at 0x2a
[    4.290056] i2c i2c-0: LM83 detection failed at 0x2b
[    4.295055] i2c i2c-0: LM83 detection failed at 0x4c
[    4.300055] i2c i2c-0: LM83 detection failed at 0x4d
[    4.305880] i2c i2c-0: LM83 detection failed at 0x4e
[    4.313056] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.320851] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.328055] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.403056] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.408056] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.413055] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.422061] i2c i2c-0: MAX1619 detection failed at 0x18
[    4.431055] i2c i2c-0: MAX1619 detection failed at 0x19
[    4.440056] i2c i2c-0: MAX1619 detection failed at 0x1a
[    4.450052] i2c i2c-0: MAX1619 detection failed at 0x29
[    4.459056] i2c i2c-0: MAX1619 detection failed at 0x2a
[    4.468056] i2c i2c-0: MAX1619 detection failed at 0x2b
[    4.477057] i2c i2c-0: MAX1619 detection failed at 0x4c
[    4.486057] i2c i2c-0: MAX1619 detection failed at 0x4d
[    4.495059] i2c i2c-0: MAX1619 detection failed at 0x4e
[    4.546213] pc87360: PC8736x not detected, module not inserted
[    4.583289] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[    4.584539] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[    4.589057] i2c i2c-0: W83L786NG detection failed at 0x2e
[    4.594055] i2c i2c-0: W83L786NG detection failed at 0x2f
[    4.595385] Bluetooth: Virtual HCI driver ver 1.5
[    4.596498] Bluetooth: HCI UART driver ver 2.2
[    4.597541] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    4.598861] usbcore: registered new interface driver bcm203x
[    4.600271] usbcore: registered new interface driver bpa10x
[    4.601587] usbcore: registered new interface driver btusb
[    4.603195] leds_ss4200: no LED devices found
[    7.016068]  (null): enodev DEV ADDR =3D 0xFF
[    7.017161] ledtrig-cpu: registered to indicate activity on CPUs
[    7.019488] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    7.021238] aedsp16: I/O, IRQ and DMA are mandatory
[    7.022325] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    7.023597] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    7.025450] ad1848: No ISAPnP cards found, trying standard ones...
[    7.026809] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    7.028519] I/O, IRQ, DMA and type are mandatory
[    7.029559] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    7.031238] I/O, IRQ, DMA and type are mandatory
[    7.036457] sb: Init: Starting Probe...
[    7.038399] sb: Init: Done
[    7.039147] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    7.045388] MIDI Loopback device driver
[    7.046650] ASIHPI driver 4.10.01
[    7.052536] NET: Registered protocol family 26
[    7.053592] netem: version 1.3
[    7.054409] u32 classifier
[    7.055142]     input device check on
[    7.071252] NET: Registered protocol family 17
[    7.072347] NET: Registered protocol family 5
[    7.080223] Bluetooth: RFCOMM socket layer initialized
[    7.081370] Bluetooth: RFCOMM ver 1.11
[    7.082275] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    7.083429] Bluetooth: BNEP filters: multicast
[    7.087287] Bluetooth: BNEP socket layer initialized
[    7.088435] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    7.089671] Bluetooth: HIDP socket layer initialized
[    7.090768] 8021q: 802.1Q VLAN Support v1.8
[    7.091752] lib80211: common routines for IEEE802.11 drivers
[    7.097033] lib80211_crypt: registered algorithm 'NULL'
[    7.098160] lib80211_crypt: registered algorithm 'WEP'
[    7.099274] lib80211_crypt: registered algorithm 'CCMP'
[    7.104447] lib80211_crypt: registered algorithm 'TKIP'
[    7.105594] NET: Registered protocol family 37
[    7.106616] NET: Registered protocol family 36
[    7.107642] openvswitch: Open vSwitch switching datapath
[    7.112867] mpls_gso: MPLS GSO support
[    7.114240]=20
[    7.114240] printing PIC contents
[    7.115525] ... PIC  IMR: ffff
[    7.116512] ... PIC  IRR: 10d3
[    7.121159] ... PIC  ISR: 0000
[    7.121944] ... PIC ELCR: 0c00
[    7.122748] printing local APIC contents on CPU#0/0:
[    7.123733] ... APIC ID:      00000000 (0)
[    7.123733] ... APIC VERSION: 00050014
[    7.123733] ... APIC TASKPRI: 00000000 (00)
[    7.123733] ... APIC PROCPRI: 00000000
[    7.123733] ... APIC LDR: 01000000
[    7.123733] ... APIC DFR: ffffffff
[    7.123733] ... APIC SPIV: 000001ff
[    7.123733] ... APIC ISR field:
[    7.123733] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.123733] ... APIC TMR field:
[    7.123733] 000000000200000000000000000000000000000000000000000000000000=
0000
[    7.123733] ... APIC IRR field:
[    7.123733] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.123733] ... APIC ESR: 00000000
[    7.123733] ... APIC ICR: 00000831
[    7.123733] ... APIC ICR2: 01000000
[    7.123733] ... APIC LVTT: 000000ef
[    7.123733] ... APIC LVTPC: 00010000
[    7.123733] ... APIC LVT0: 00010700
[    7.123733] ... APIC LVT1: 00000400
[    7.123733] ... APIC LVTERR: 000000fe
[    7.123733] ... APIC TMICT: 000040ca
[    7.123733] ... APIC TMCCT: 00000000
[    7.123733] ... APIC TDCR: 00000003
[    7.123733]=20
[    7.181013] number of MP IRQ sources: 15.
[    7.181982] number of IO-APIC #0 registers: 24.
[    7.183052] testing the IO APIC.......................
[    7.184239] IO APIC #0......
[    7.185042] .... register #00: 00000000
[    7.185983] .......    : physical APIC id: 00
[    7.187035] .......    : Delivery Type: 0
[    7.188000] .......    : LTS          : 0
[    7.188998] .... register #01: 00170011
[    7.189965] .......     : max redirection entries: 17
[    7.191127] .......     : PRQ implemented: 0
[    7.192155] .......     : IO APIC version: 11
[    7.193194] .... register #02: 00000000
[    7.208771] .......     : arbitration: 00
[    7.209718] .... IRQ redirection table:
[    7.210643] 1    0    0   0   0    0    0    00
[    7.211678] 0    0    0   0   0    1    1    31
[    7.216761] 0    0    0   0   0    1    1    30
[    7.217808] 0    0    0   0   0    1    1    33
[    7.218842] 1    0    0   0   0    1    1    34
[    7.219873] 1    1    0   0   0    1    1    35
[    7.224952] 0    0    0   0   0    1    1    36
[    7.225993] 0    0    0   0   0    1    1    37
[    7.227032] 0    0    0   0   0    1    1    38
[    7.228057] 0    1    0   0   0    1    1    39
[    7.233145] 1    1    0   0   0    1    1    3A
[    7.234187] 1    1    0   0   0    1    1    3B
[    7.235218] 0    0    0   0   0    1    1    3C
[    7.240299] 0    0    0   0   0    1    1    3D
[    7.241343] 0    0    0   0   0    1    1    3E
[    7.242379] 0    0    0   0   0    1    1    3F
[    7.243409] 1    0    0   0   0    0    0    00
[    7.248487] 1    0    0   0   0    0    0    00
[    7.249533] 1    0    0   0   0    0    0    00
[    7.250567] 1    0    0   0   0    0    0    00
[    7.251596] 1    0    0   0   0    0    0    00
[    7.257516] 1    0    0   0   0    0    0    00
[    7.258573] 1    0    0   0   0    0    0    00
[    7.259617] 1    0    0   0   0    0    0    00
[    7.260658] IRQ to pin mappings:
[    7.261481] IRQ0 -> 0:2
[    7.262416] IRQ1 -> 0:1
[    7.263344] IRQ3 -> 0:3
[    7.264282] IRQ4 -> 0:4
[    7.282636] IRQ5 -> 0:5
[    7.283537] IRQ6 -> 0:6
[    7.284431] IRQ7 -> 0:7
[    7.285351] IRQ8 -> 0:8
[    7.286256] IRQ9 -> 0:9
[    7.287149] IRQ10 -> 0:10
[    7.288062] IRQ11 -> 0:11
[    7.288978] IRQ12 -> 0:12
[    7.289897] IRQ13 -> 0:13
[    7.290814] IRQ14 -> 0:14
[    7.291728] IRQ15 -> 0:15
[    7.292653] .................................... done.
[    7.293958] Loading compiled-in X.509 certificates
[    7.295203] Key type trusted registered
[    7.309199] ima: No TPM chip found, activating TPM-bypass!
[    7.310923] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    7.312741] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    7.314186] ALSA device list:
[    7.314987]   No soundcards found.
[    7.317306] Freeing unused kernel memory: 1044K (ffffffff8255c000 - ffff=
ffff82661000)
[    7.319113] Write protecting the kernel read-only data: 20480k
[    7.340963] Freeing unused kernel memory: 2000K (ffff880001c0c000 - ffff=
880001e00000)
[    7.347005] Freeing unused kernel memory: 1172K (ffff8800022db000 - ffff=
880002400000)
[    7.396057] udev[130]: starting version 164
[    7.555368] UDF-fs: warning (device vda): udf_fill_super: No partition f=
ound (2)
[    7.559507] UDF-fs: warning (device vdc): udf_fill_super: No partition f=
ound (2)
[    7.561390] UDF-fs: warning (device vdb): udf_fill_super: No partition f=
ound (2)
[    7.563868] Mount JFS Failure: -22
[    7.565155] UDF-fs: warning (device vde): udf_fill_super: No partition f=
ound (2)
[    7.574458] Mount JFS Failure: -22
[    7.588464] UDF-fs: warning (device vdf): udf_fill_super: No partition f=
ound (2)
[    7.590200] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    7.591153] IP: [<ffffffff811596d9>] dquot_drop+0x19/0x40
[    7.591153] PGD 10c97067 PUD 11166067 PMD 0=20
[    7.591153] Oops: 0000 [#1]=20
[    7.591153] CPU: 0 PID: 378 Comm: mount Not tainted 3.17.0-rc5-00035-g82=
d9745 #2
[    7.591153] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.591153] task: ffff8800110de660 ti: ffff8800113f0000 task.ti: ffff880=
0113f0000
[    7.591153] RIP: 0010:[<ffffffff811596d9>]  [<ffffffff811596d9>] dquot_d=
rop+0x19/0x40
[    7.591153] RSP: 0018:ffff8800113f3d10  EFLAGS: 00010246
[    7.591153] RAX: 0000000000000000 RBX: ffff880012a20b28 RCX: 00000001c46=
92862
[    7.591153] RDX: 00000001c46928b4 RSI: ffff8800110de660 RDI: ffff880012a=
20b28
[    7.591153] RBP: ffff8800113f3d10 R08: 000000000000003c R09: ffff8800111=
b8cb0
[    7.591153] R10: ffffffff82693280 R11: 0000000000000000 R12: ffffffff81e=
bdd80
[    7.591153] R13: ffffffff81ebdd80 R14: 0000000000000001 R15: ffff8800128=
03940
[    7.591153] FS:  00007f08c87d9700(0000) GS:ffffffff82421000(0000) knlGS:=
0000000000000000
[    7.591153] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.591153] CR2: 0000000000000000 CR3: 0000000011070000 CR4: 00000000000=
006f0
[    7.591153] Stack:
[    7.591153]  ffff8800113f3d28 ffffffff81267174 ffff880012a20b28 ffff8800=
113f3d48
[    7.591153]  ffffffff81120354 ffff880012a20b28 ffff8800111f9c00 ffff8800=
113f3d70
[    7.591153]  ffffffff81121054 ffff8800111f9c00 ffff8800114e3200 00000000=
ffffffea
[    7.591153] Call Trace:
[    7.591153]  [<ffffffff81267174>] jfs_evict_inode+0x44/0xb0
[    7.591153]  [<ffffffff81120354>] evict+0xa4/0x170
[    7.591153]  [<ffffffff81121054>] iput+0xe4/0x180
[    7.591153]  [<ffffffff812662f9>] jfs_fill_super+0x1b9/0x380
[    7.591153]  [<ffffffff8110b5d9>] mount_bdev+0x189/0x1c0
[    7.591153]  [<ffffffff81266140>] ? jfs_remount+0x1b0/0x1b0
[    7.591153]  [<ffffffff81265300>] jfs_do_mount+0x10/0x20
[    7.591153]  [<ffffffff8110b813>] mount_fs+0x33/0x1c0
[    7.591153]  [<ffffffff81124d86>] vfs_kern_mount+0x66/0x110
[    7.591153]  [<ffffffff81126b43>] do_mount+0x243/0xad0
[    7.591153]  [<ffffffff810e4f23>] ? strndup_user+0x43/0x60
[    7.591153]  [<ffffffff81127780>] SyS_mount+0x80/0xc0
[    7.591153]  [<ffffffff81c05f30>] tracesys+0xcf/0xd4
[    7.591153] Code: 00 00 55 be ff ff ff ff 48 89 e5 e8 22 f4 ff ff 5d c3 =
f6 47 0c 20 55 48 89 e5 75 23 48 8b 47 28 48 63 80 50 02 00 00 85 c0 75 17 =
<48> 83 3c 25 00 00 00 00 00 75 15 31 c0 48 83 78 08 00 75 0c 5d=20
[    7.591153] RIP  [<ffffffff811596d9>] dquot_drop+0x19/0x40
[    7.591153]  RSP <ffff8800113f3d10>
[    7.591153] CR2: 0000000000000000
[    7.701394] ---[ end trace d15805ff3c6dc4f0 ]---
[    7.702424] Kernel panic - not syncing: Fatal exception
[    7.703416] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s0-10010819/82d9745eb11a03c976778629e15f5a752c09c346/vmlinuz-3.17.0-rc5-00=
035-g82d9745 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s=
0-10010819/linux-devel:devel-hourly-2014100105:82d9745eb11a03c976778629e15f=
5a752c09c346:bisect-linux-2/.vmlinuz-82d9745eb11a03c976778629e15f5a752c09c3=
46-20141001103709-97-vp branch=3Dlinux-devel/devel-hourly-2014100105 BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-s0-10010819/82d9745eb11a03c976778629e15f5a=
752c09c346/vmlinuz-3.17.0-rc5-00035-g82d9745 drbd.minor_count=3D8'  -initrd=
 /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-v=
p-55,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-vp-=
55,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-vp-55=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-vp-55,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-vp-55,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-vp-55,media=
=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-vp-55 -serial file:/d=
ev/shm/kboot/serial-yocto-vp-55 -daemonize -display none -monitor null=20

--rwEMma7ioTxnRzrJ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s0-10010819-b7dc959e9806a432742f3b0281ddcb2b815d5ee0-BUG:-unable-to-handle-kernel-35707.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgYjdkYzk1OS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDEwMDEwNScKZ2l0IGNoZWNrb3V0IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEz
ODRjOTU4ZDVmNjc5NzlhZGIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MTAwMTA1OmZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGI6Ymlz
ZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDEgMDg6NTQ6NDEgZmU4MmRjZWM2NDQyNDQ2NzZkNTVh
MTM4NGM5NThkNWY2Nzk3OWFkYiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvdm1s
aW51ei0zLjE3LjAtcmM3CgoyMDE0LTEwLTAxIDA4OjU0OjQxIGRldGVjdGluZyBib290IHN0
YXRlIC4uLgkzOSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGZlODJkY2VjNjQ0MjQ0
Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIKZ2l0IGJpc2VjdCBzdGFydCBiN2RjOTU5ZTk4
MDZhNDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwIGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEz
ODRjOTU4ZDVmNjc5NzlhZGIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsi
LWIiLCAiYjdkYzk1OWU5ODA2YTQzMjc0MmYzYjAyODFkZGNiMmI4MTVkNWVlMCIsICItZyIs
ICJmZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIiwgIi9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3Qv
bGludXgtMi9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNDEwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzg5NmM0MDlhNDNjODczNjcx
ZDZkNGU3NmUyNzMyNjhkMzdlZDNkYzBdIE1lcmdlICdtbGFua2hvcnN0L2Zvci1haXJsaWVk
LW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDUKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQx
MDAxMDU6ODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMDpiaXNlY3Qt
bGludXgtMgoKMjAxNC0xMC0wMSAwODo1NzozNiA4OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZl
MjczMjY4ZDM3ZWQzZGMwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS04
OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS84OTZjNDA5YTQz
Yzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTktODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2Rj
MAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvODk2YzQw
OWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMC92bWxpbnV6LTMuMTcuMC1yYzct
MDA5OTAtZzg5NmM0MDkKCjIwMTQtMTAtMDEgMDg6NTk6MzYgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4JMyBURVNUIEZBSUxVUkUKWyAgICA2LjUxMzMwMF0gTW91bnQgSkZTIEZhaWx1cmU6
IC0yMgpbICAgIDYuNTEzOTQzXSBVREYtZnM6IHdhcm5pbmcgKGRldmljZSB2ZGMpOiB1ZGZf
ZmlsbF9zdXBlcjogTm8gcGFydGl0aW9uIGZvdW5kICgyKQpbICAgIDYuNTE1MTE5XSBNb3Vu
dCBKRlMgRmFpbHVyZTogLTIyClsgICAgNi41MTU2OTddIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkK
WyAgICA2LjUxNjExMV0gSVA6IFs8ZmZmZmZmZmY4MTE1OTY4OT5dIGRxdW90X2Ryb3ArMHgx
OS8weDQwClsgICAgNi41MTYxMTFdIFBHRCAxMGNhNDA2NyBQVUQgMTExY2MwNjcgUE1EIDAg
ClsgICAgNi41MTYxMTFdIE9vcHM6IDAwMDAgWyMxXSAKWyAgICA2LjUxNjExMV0gQ1BVOiAw
IFBJRDogMzg2IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDA5OTAtZzg5
NmM0MDkgIzEKWyAgICA2LjUxNjExMV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNTE2MTExXSB0YXNrOiBmZmZmODgwMDExMzZj
Y2IwIHRpOiBmZmZmODgwMDExMzcwMDAwIHRhc2sudGk6IGZmZmY4ODAwMTEzNzAwMDAKWyAg
ICA2LjUxNjExMV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTE1OTY4OT5dICBbPGZmZmZmZmZm
ODExNTk2ODk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNTE2MTExXSBSU1A6IDAw
MTg6ZmZmZjg4MDAxMTM3M2QxMCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDYuNTE2MTExXSBS
QVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMDEyYTIwYmE4IFJDWDogMDAwMDAw
MDAwMDAwMDAzNwpbICAgIDYuNTE2MTExXSBSRFg6IDAwMDAwMDAwODAwMDAwMDAgUlNJOiAw
MDAwMDAwMDAwMDAwMWYwIFJESTogZmZmZjg4MDAxMmEyMGJhOApbICAgIDYuNTE2MTExXSBS
QlA6IGZmZmY4ODAwMTEzNzNkMTAgUjA4OiAwMDAwMDAwMDU0MmI1MjMyIFIwOTogMDAwMDAw
MDAwMDAwMDNjOQpbICAgIDYuNTE2MTExXSBSMTA6IGZmZmZmZmZmODI2OTMyODAgUjExOiAw
MDAwMDAwMDAwMDAwM2M5IFIxMjogZmZmZmZmZmY4MWViZGJjMApbICAgIDYuNTE2MTExXSBS
MTM6IGZmZmZmZmZmODFlYmRiYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjg4
MDAxMjgwMzM0MApbICAgIDYuNTE2MTExXSBGUzogIDAwMDA3ZjNhZjIwZGU3MDAoMDAwMCkg
R1M6ZmZmZmZmZmY4MjQyMTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAg
Ni41MTYxMTFdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAw
NTAwM2IKWyAgICA2LjUxNjExMV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAw
MDAxMGNhODAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZjAKWyAgICA2LjUxNjExMV0gU3RhY2s6
ClsgICAgNi41MTYxMTFdICBmZmZmODgwMDExMzczZDI4IGZmZmZmZmZmODEyNjczNDQgZmZm
Zjg4MDAxMmEyMGJhOCBmZmZmODgwMDExMzczZDQ4ClsgICAgNi41MTYxMTFdICBmZmZmZmZm
ZjgxMTIwMzA0IGZmZmY4ODAwMTJhMjBiYTggZmZmZjg4MDAxMTBlOGMwMCBmZmZmODgwMDEx
MzczZDcwClsgICAgNi41MTYxMTFdICBmZmZmZmZmZjgxMTIxMDA0IGZmZmY4ODAwMTEwZThj
MDAgZmZmZjg4MDAxMGNkMWUwMCAwMDAwMDAwMGZmZmZmZmVhClsgICAgNi41MTYxMTFdIENh
bGwgVHJhY2U6ClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODEyNjczNDQ+XSBqZnNfZXZp
Y3RfaW5vZGUrMHg0NC8weGIwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODExMjAzMDQ+
XSBldmljdCsweGE0LzB4MTcwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODExMjEwMDQ+
XSBpcHV0KzB4ZTQvMHgxODAKWyAgICA2LjUxNjExMV0gIFs8ZmZmZmZmZmY4MTI2NjRjOT5d
IGpmc19maWxsX3N1cGVyKzB4MWI5LzB4MzgwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZm
ODExMGI2Yzk+XSBtb3VudF9iZGV2KzB4MTg5LzB4MWMwClsgICAgNi41MTYxMTFdICBbPGZm
ZmZmZmZmODEyNjYzMTA+XSA/IGpmc19yZW1vdW50KzB4MWIwLzB4MWIwClsgICAgNi41MTYx
MTFdICBbPGZmZmZmZmZmODE0NGEwZTI+XSA/IGlkYV9nZXRfbmV3X2Fib3ZlKzB4MWUyLzB4
MjIwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODEyNjU0ZDA+XSBqZnNfZG9fbW91bnQr
MHgxMC8weDIwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODExMGI5MDM+XSBtb3VudF9m
cysweDMzLzB4MWMwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODExMjRkMzY+XSB2ZnNf
a2Vybl9tb3VudCsweDY2LzB4MTEwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODExMjZh
ZjM+XSBkb19tb3VudCsweDI0My8weGFkMApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgx
MGU0ZmYzPl0gPyBzdHJuZHVwX3VzZXIrMHg0My8weDYwClsgICAgNi41MTYxMTFdICBbPGZm
ZmZmZmZmODExMjc3MzA+XSBTeVNfbW91bnQrMHg4MC8weGMwClsgICAgNi41MTYxMTFdICBb
PGZmZmZmZmZmODFjMDNhNzA+XSB0cmFjZXN5cysweGNmLzB4ZDQKWyAgICA2LjUxNjExMV0g
Q29kZTogMDAgMDAgNTUgYmUgZmYgZmYgZmYgZmYgNDggODkgZTUgZTggMjIgZjQgZmYgZmYg
NWQgYzMgZjYgNDcgMGMgMjAgNTUgNDggODkgZTUgNzUgMjMgNDggOGIgNDcgMjggNDggNjMg
ODAgNTAgMDIgMDAgMDAgODUgYzAgNzUgMTcgPDQ4PiA4MyAzYyAyNSAwMCAwMCAwMCAwMCAw
MCA3NSAxNSAzMSBjMCA0OCA4MyA3OCAwOCAwMCA3NSAwYyA1ZCAKWyAgICA2LjUxNjExMV0g
UklQICBbPGZmZmZmZmZmODExNTk2ODk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYu
NTE2MTExXSAgUlNQIDxmZmZmODgwMDExMzczZDEwPgpbICAgIDYuNTE2MTExXSBDUjI6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICA2LjU3Njg3Ml0gLS0tWyBlbmQgdHJhY2UgMmM4YWEyYWI2
YTRhM2ZlZiBdLS0tClsgICAgNi41Nzc1ODVdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS84OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwL2RtZXNnLXlvY3Rv
LXZwLTE5OjIwMTQxMDAxMDkwMDM5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMu
MTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5Lzg5NmM0MDlhNDNjODczNjcxZDZkNGU3NmUyNzMyNjhkMzdlZDNkYzAvZG1l
c2cteW9jdG8tdnAtMjQ6MjAxNDEwMDEwOTAwMzg6eDg2XzY0LXJhbmRjb25maWctczAtMTAw
MTA4MTk6My4xNy4wLXJjNy0wMDk5MC1nODk2YzQwOToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTkvODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2Vk
M2RjMC9kbWVzZy15b2N0by12cC0zMToyMDE0MTAwMTA5MDAzNjp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwOTkwLWc4OTZjNDA5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS84OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjcz
MjY4ZDM3ZWQzZGMwL2RtZXNnLXlvY3RvLXZwLTMyOjIwMTQxMDAxMDkwMDM4Ong4Nl82NC1y
YW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5Lzg5NmM0MDlhNDNjODczNjcxZDZk
NGU3NmUyNzMyNjhkMzdlZDNkYzAvZG1lc2cteW9jdG8tdnAtNDc6MjAxNDEwMDEwOTAwMzU6
eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDk5MC1nODk2YzQw
OToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvODk2YzQwOWE0M2M4
NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMC9kbWVzZy15b2N0by12cC01MDoyMDE0MTAw
MTA5MDAzNDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwOTkw
LWc4OTZjNDA5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS84OTZj
NDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwL2RtZXNnLXlvY3RvLXZwLTU1
OjIwMTQxMDAxMDkwMDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1y
YzctMDA5OTAtZzg5NmM0MDk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5Lzg5NmM0MDlhNDNjODczNjcxZDZkNGU3NmUyNzMyNjhkMzdlZDNkYzAvZG1lc2cteW9j
dG8tdnAtNjQ6MjAxNDEwMDEwOTAwMzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6
My4xNy4wLXJjNy0wMDk5MC1nODk2YzQwOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTkvODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMC9k
bWVzZy15b2N0by12cC04OjIwMTQxMDAxMDkwMDM3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5OjMuMTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6MQo4Ojk6OSBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA5OTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRj
ZWU2NDM2ZDdkMzU4NzZhOF0gTWVyZ2UgJ2Fzb2MvdG9waWMvZnNsLXNzaScgaW50byBkZXZl
bC1ob3VybHktMjAxNDEwMDEwNQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNToyNjEwMTc2NDY1
NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4OmJpc2VjdC1saW51eC0yCgoyMDE0LTEw
LTAxIDA5OjAxOjA4IDI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LTI2MTAxNzY0NjU2MWYwMzI1
ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2Vl
NjQzNmQ3ZDM1ODc2YTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS0yNjEwMTc2
NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4ChtbMTszNW0yMDE0LTEwLTAxIDA5
OjAzOjA4IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVk
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LTI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0
Y2VlNjQzNmQ3ZDM1ODc2YTgbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNl
ZTY0MzZkN2QzNTg3NmE4L3ZtbGludXotMy4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NgoKMjAx
NC0xMC0wMSAwOTowNDowOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUK
WyAgICA3LjExMTAxOV0gVURGLWZzOiB3YXJuaW5nIChkZXZpY2UgdmRlKTogdWRmX2ZpbGxf
c3VwZXI6IE5vIHBhcnRpdGlvbiBmb3VuZCAoMikKWyAgICA3LjExMzA3OF0gVURGLWZzOiB3
YXJuaW5nIChkZXZpY2UgdmRmKTogdWRmX2ZpbGxfc3VwZXI6IE5vIHBhcnRpdGlvbiBmb3Vu
ZCAoMikKWyAgICA3LjExNDgxN10gTW91bnQgSkZTIEZhaWx1cmU6IC0yMgpbICAgIDcuMTE1
NzQ5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgNy4xMTY3MTldIElQOiBbPGZmZmZmZmZm
ODExNTk1Yzk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDcuMTE2NzE5XSBQR0QgMTEz
ZWUwNjcgUFVEIDExMDIxMDY3IFBNRCAwIApbICAgIDcuMTE2NzE5XSBPb3BzOiAwMDAwIFsj
MV0gClsgICAgNy4xMTY3MTldIENQVTogMCBQSUQ6IDM3OSBDb21tOiBtb3VudCBOb3QgdGFp
bnRlZCAzLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2ICMxClsgICAgNy4xMTY3MTldIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA3LjEx
NjcxOV0gdGFzazogZmZmZjg4MDAxMTdhOTMwMCB0aTogZmZmZjg4MDAxMTA0YzAwMCB0YXNr
LnRpOiBmZmZmODgwMDExMDRjMDAwClsgICAgNy4xMTY3MTldIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODExNTk1Yzk+XSAgWzxmZmZmZmZmZjgxMTU5NWM5Pl0gZHF1b3RfZHJvcCsweDE5LzB4
NDAKWyAgICA3LjExNjcxOV0gUlNQOiAwMDE4OmZmZmY4ODAwMTEwNGZkMTAgIEVGTEFHUzog
MDAwMTAyNDYKWyAgICA3LjExNjcxOV0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZm
Zjg4MDAxMmExZWIyOCBSQ1g6IDAwMDAwMDAwMDAwMDAwMzcKWyAgICA3LjExNjcxOV0gUkRY
OiAwMDAwMDAwMDgwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDFmMCBSREk6IGZmZmY4ODAw
MTJhMWViMjgKWyAgICA3LjExNjcxOV0gUkJQOiBmZmZmODgwMDExMDRmZDEwIFIwODogMDAw
MDAwMDA1NDJiNTMxYSBSMDk6IDAwMDAwMDAwMDAwMDAzYzUKWyAgICA3LjExNjcxOV0gUjEw
OiBmZmZmODgwMDEzZmZiMjQwIFIxMTogMDAwMDAwMDAwMDAwMDNjNSBSMTI6IGZmZmZmZmZm
ODFlYmRiYzAKWyAgICA3LjExNjcxOV0gUjEzOiBmZmZmZmZmZjgxZWJkYmMwIFIxNDogMDAw
MDAwMDAwMDAwMDAwMSBSMTU6IGZmZmY4ODAwMTI4MDM2NDAKWyAgICA3LjExNjcxOV0gRlM6
ICAwMDAwN2Y0MzlkNjA2NzAwKDAwMDApIEdTOmZmZmZmZmZmODI0MjEwMDAoMDAwMCkga25s
R1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDcuMTE2NzE5XSBDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgNy4xMTY3MTldIENSMjogMDAw
MDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMTE3YjAwMDAgQ1I0OiAwMDAwMDAwMDAwMDAw
NmYwClsgICAgNy4xMTY3MTldIFN0YWNrOgpbICAgIDcuMTE2NzE5XSAgZmZmZjg4MDAxMTA0
ZmQyOCBmZmZmZmZmZjgxMjY3Mjg0IGZmZmY4ODAwMTJhMWViMjggZmZmZjg4MDAxMTA0ZmQ0
OApbICAgIDcuMTE2NzE5XSAgZmZmZmZmZmY4MTEyMDI0NCBmZmZmODgwMDEyYTFlYjI4IGZm
ZmY4ODAwMTEyY2I0MDAgZmZmZjg4MDAxMTA0ZmQ3MApbICAgIDcuMTE2NzE5XSAgZmZmZmZm
ZmY4MTEyMGY0NCBmZmZmODgwMDExMmNiNDAwIGZmZmY4ODAwMTE0ZTExMDAgMDAwMDAwMDBm
ZmZmZmZlYQpbICAgIDcuMTE2NzE5XSBDYWxsIFRyYWNlOgpbICAgIDcuMTE2NzE5XSAgWzxm
ZmZmZmZmZjgxMjY3Mjg0Pl0gamZzX2V2aWN0X2lub2RlKzB4NDQvMHhiMApbICAgIDcuMTE2
NzE5XSAgWzxmZmZmZmZmZjgxMTIwMjQ0Pl0gZXZpY3QrMHhhNC8weDE3MApbICAgIDcuMTE2
NzE5XSAgWzxmZmZmZmZmZjgxMTIwZjQ0Pl0gaXB1dCsweGU0LzB4MTgwClsgICAgNy4xMTY3
MTldICBbPGZmZmZmZmZmODEyNjY0MDk+XSBqZnNfZmlsbF9zdXBlcisweDFiOS8weDM4MApb
ICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxMTBiNjA5Pl0gbW91bnRfYmRldisweDE4OS8w
eDFjMApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxMjY2MjUwPl0gPyBqZnNfcmVtb3Vu
dCsweDFiMC8weDFiMApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxNDRhMDIyPl0gPyBp
ZGFfZ2V0X25ld19hYm92ZSsweDFlMi8weDIyMApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZm
ZjgxMjY1NDEwPl0gamZzX2RvX21vdW50KzB4MTAvMHgyMApbICAgIDcuMTE2NzE5XSAgWzxm
ZmZmZmZmZjgxMTBiODQzPl0gbW91bnRfZnMrMHgzMy8weDFjMApbICAgIDcuMTE2NzE5XSAg
WzxmZmZmZmZmZjgxMTI0Yzc2Pl0gdmZzX2tlcm5fbW91bnQrMHg2Ni8weDExMApbICAgIDcu
MTE2NzE5XSAgWzxmZmZmZmZmZjgxMTI2YTMzPl0gZG9fbW91bnQrMHgyNDMvMHhhZDAKWyAg
ICA3LjExNjcxOV0gIFs8ZmZmZmZmZmY4MTBlNGYzMz5dID8gc3RybmR1cF91c2VyKzB4NDMv
MHg2MApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxMTI3NjcwPl0gU3lTX21vdW50KzB4
ODAvMHhjMApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxYzAzMzcwPl0gdHJhY2VzeXMr
MHhjZi8weGQ0ClsgICAgNy4xMTY3MTldIENvZGU6IDAwIDAwIDU1IGJlIGZmIGZmIGZmIGZm
IDQ4IDg5IGU1IGU4IDIyIGY0IGZmIGZmIDVkIGMzIGY2IDQ3IDBjIDIwIDU1IDQ4IDg5IGU1
IDc1IDIzIDQ4IDhiIDQ3IDI4IDQ4IDYzIDgwIDUwIDAyIDAwIDAwIDg1IGMwIDc1IDE3IDw0
OD4gODMgM2MgMjUgMDAgMDAgMDAgMDAgMDAgNzUgMTUgMzEgYzAgNDggODMgNzggMDggMDAg
NzUgMGMgNWQgClsgICAgNy4xMTY3MTldIFJJUCAgWzxmZmZmZmZmZjgxMTU5NWM5Pl0gZHF1
b3RfZHJvcCsweDE5LzB4NDAKWyAgICA3LjExNjcxOV0gIFJTUCA8ZmZmZjg4MDAxMTA0ZmQx
MD4KWyAgICA3LjExNjcxOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgNy4xODM5MDdd
IC0tLVsgZW5kIHRyYWNlIGU0Y2YwYzU0YzU0N2YwYzEgXS0tLQpbICAgIDcuMTg0OTcyXSBL
ZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2
NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0xMDoyMDE0MTAwMTA5MDQzMTp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVj
MDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTExOjIwMTQxMDAxMDkwNDMy
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAx
NzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2
MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMTI6MjAxNDEw
MDEwOTA0MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2
NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYx
MDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0x
MzoyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlv
Y3RvLXZwLTE0OjIwMTQxMDAxMDkwNDMxOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgv
ZG1lc2cteW9jdG8tdnAtMTU6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdk
MzU4NzZhOC9kbWVzZy15b2N0by12cC0xNzoyMDE0MTAwMTA5MDQzMTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNl
ZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTE4OjIwMTQxMDAxMDkwNDMzOng4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1
ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMTk6MjAxNDEwMDEwOTA0
MzE6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYx
MDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2
NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0yMDoyMDE0
MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAw
NzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8y
NjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZw
LTIzOjIwMTQxMDAxMDkwNDMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcu
MC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2ct
eW9jdG8tdnAtMjc6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZh
OC9kbWVzZy15b2N0by12cC0yOToyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZk
N2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQxMDAxMDkwNDMxOng4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0
Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMzE6MjAxNDEwMDEwOTA0MzE6eDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3Njox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAz
MjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0zMzoyMDE0MTAwMTA5
MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcy
NjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2
NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTM0OjIw
MTQxMDAxMDkwNDMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzct
MDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8t
dnAtMzY6MjAxNDEwMDEwOTA0MzQ6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4x
Ny4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVz
Zy15b2N0by12cC0zNzoyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3
NmE4L2RtZXNnLXlvY3RvLXZwLTM6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2
ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC00MjoyMDE0MTAwMTA5MDQzMTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDEx
NGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTQ0OjIwMTQxMDAxMDkwNDMxOng4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYw
MzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNDU6MjAxNDEwMDEw
OTA0MzA6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1n
MjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3
NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC00OToy
MDE0MTAwMTA5MDQzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3
LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3Rv
LXZwLTUzOjIwMTQxMDAxMDkwNDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMu
MTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1l
c2cteW9jdG8tdnAtNTc6MjAxNDEwMDEwOTA0MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAw
MTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4
NzZhOC9kbWVzZy15b2N0by12cC01OToyMDE0MTAwMTA5MDQzNDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0
MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTU6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAx
MTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC02MToyMDE0MTAwMTA5MDQzMzp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFm
MDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTYyOjIwMTQxMDAx
MDkwNDMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQt
ZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAx
NzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNjM6
MjAxNDEwMDEwOTA0MzE6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJj
Ny0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0
by12cC03OjIwMTQxMDAxMDkwNDM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMu
MTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1l
c2cteW9jdG8tdnAtOToyMDE0MTAwMTA5MDQzNTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3
NmE4L2RtZXNnLXlvY3RvLXZwLTE6MjAxNDEwMDEwOTA0NDA6eDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2
ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC00MDoyMDE0MTAwMTA5MDQzOTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDEx
NGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTQzOjIwMTQxMDAxMDkwNDQwOng4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYw
MzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNDoyMDE0MTAwMTA5
MDQzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcy
NjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2
NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTU0OjIw
MTQxMDAxMDkwNDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzct
MDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8t
dnAtODoyMDE0MTAwMTA5MDQ0MDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3
LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKMDozOTozOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKQmlzZWN0aW5nOiA3NjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEwIHN0ZXBzKQpbN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBi
MjdlZjgwZl0gTWVyZ2UgJ2V4dDMvZm9yX3Rlc3RpbmcnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQxMDAxMDUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDU6N2IyYTMwZWRiM2ZlZjUyNzgyOTE1
MGE4NjZhZWZjZDBiMjdlZjgwZjpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wMSAwOTowNTox
MCA3YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS03YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFl
ZmNkMGIyN2VmODBmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2Vm
ODBmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktN2IyYTMwZWRiM2ZlZjUyNzgy
OTE1MGE4NjZhZWZjZDBiMjdlZjgwZgobWzE7MzVtMjAxNC0xMC0wMSAwOTowODoxMCBObyBi
dWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOS03YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIy
N2VmODBmG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5LTdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNm
ZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvdm1saW51ei0zLjE3LjAtcmM3LTAwMDIw
LWc3YjJhMzBlCgoyMDE0LTEwLTAxIDA5OjEwOjEwIGRldGVjdGluZyBib290IHN0YXRlIC4J
MTgJMjIJMzAJMzkgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3NDQgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbYmRlMWVmYjZlOTM1YzUwNWMw
NTk5ZGFlZTY0MjhhNmY5YWYzMDU0MV0gTWVyZ2UgJ25ldC9tYXN0ZXInIGludG8gZGV2ZWwt
aG91cmx5LTIwMTQxMDAxMDUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMTAw
MTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDU6YmRlMWVmYjZlOTM1
YzUwNWMwNTk5ZGFlZTY0MjhhNmY5YWYzMDU0MTpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0w
MSAwOToxMjo0MSBiZGUxZWZiNmU5MzVjNTA1YzA1OTlkYWVlNjQyOGE2ZjlhZjMwNTQxIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS1iZGUxZWZiNmU5MzVjNTA1YzA1
OTlkYWVlNjQyOGE2ZjlhZjMwNTQxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9iZGUxZWZiNmU5MzVjNTA1YzA1OTlkYWVlNjQy
OGE2ZjlhZjMwNTQxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktYmRl
MWVmYjZlOTM1YzUwNWMwNTk5ZGFlZTY0MjhhNmY5YWYzMDU0MQprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYmRlMWVmYjZlOTM1YzUwNWMwNTk5ZGFl
ZTY0MjhhNmY5YWYzMDU0MS92bWxpbnV6LTMuMTcuMC1yYzctMDAwNTItZ2JkZTFlZmIKCjIw
MTQtMTAtMDEgMDk6MTU6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUK
WyAgICA2LjYzMDg5OF0gTW91bnQgSkZTIEZhaWx1cmU6IC0yMgpbICAgIDYuNjMxNTc0XSBV
REYtZnM6IHdhcm5pbmcgKGRldmljZSB2ZGYpOiB1ZGZfZmlsbF9zdXBlcjogTm8gcGFydGl0
aW9uIGZvdW5kICgyKQpbICAgIDYuNjMyOTIwXSBNb3VudCBKRlMgRmFpbHVyZTogLTIyClsg
ICAgNi42MzM1OTldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICA2LjYzNDU3OV0gSVA6IFs8
ZmZmZmZmZmY4MTE1OTVjOT5dIGRxdW90X2Ryb3ArMHgxOS8weDQwClsgICAgNi42MzQ1Nzld
IFBHRCAxMTI1MjA2NyBQVUQgMTBjMTgwNjcgUE1EIDAgClsgICAgNi42MzQ1NzldIE9vcHM6
IDAwMDAgWyMxXSAKWyAgICA2LjYzNDU3OV0gQ1BVOiAwIFBJRDogMzkxIENvbW06IG1vdW50
IE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDAwNTItZ2JkZTFlZmIgIzEKWyAgICA2LjYzNDU3
OV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDYuNjM0NTc5XSB0YXNrOiBmZmZmODgwMDEwZDM5OTUwIHRpOiBmZmZmODgwMDExM2U0
MDAwIHRhc2sudGk6IGZmZmY4ODAwMTEzZTQwMDAKWyAgICA2LjYzNDU3OV0gUklQOiAwMDEw
Ols8ZmZmZmZmZmY4MTE1OTVjOT5dICBbPGZmZmZmZmZmODExNTk1Yzk+XSBkcXVvdF9kcm9w
KzB4MTkvMHg0MApbICAgIDYuNjM0NTc5XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMTNlN2QxMCAg
RUZMQUdTOiAwMDAxMDI0NgpbICAgIDYuNjM0NTc5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAg
UkJYOiBmZmZmODgwMDEyYTIxYmE4IFJDWDogMDAwMDAwMDAwMDAwMDAzNwpbICAgIDYuNjM0
NTc5XSBSRFg6IDAwMDAwMDAwODAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMWYwIFJESTog
ZmZmZjg4MDAxMmEyMWJhOApbICAgIDYuNjM0NTc5XSBSQlA6IGZmZmY4ODAwMTEzZTdkMTAg
UjA4OiAwMDAwMDAwMDU0MmI1NTk5IFIwOTogMDAwMDAwMDAwMDAwMDNjOApbICAgIDYuNjM0
NTc5XSBSMTA6IGZmZmZmZmZmODI2OTMyODAgUjExOiAwMDAwMDAwMDAwMDAwM2M4IFIxMjog
ZmZmZmZmZmY4MWViZGJjMApbICAgIDYuNjM0NTc5XSBSMTM6IGZmZmZmZmZmODFlYmRiYzAg
UjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjg4MDAxMmExZWM4MApbICAgIDYuNjM0
NTc5XSBGUzogIDAwMDA3ZjQ4MzcxNjc3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MjQyMTAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgNi42MzQ1NzldIENTOiAgMDAxMCBE
UzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICA2LjYzNDU3OV0g
Q1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAxMTE0ZjAwMCBDUjQ6IDAwMDAw
MDAwMDAwMDA2ZjAKWyAgICA2LjYzNDU3OV0gU3RhY2s6ClsgICAgNi42MzQ1NzldICBmZmZm
ODgwMDExM2U3ZDI4IGZmZmZmZmZmODEyNjcyODQgZmZmZjg4MDAxMmEyMWJhOCBmZmZmODgw
MDExM2U3ZDQ4ClsgICAgNi42MzQ1NzldICBmZmZmZmZmZjgxMTIwMjQ0IGZmZmY4ODAwMTJh
MjFiYTggZmZmZjg4MDAxMTM1Y2MwMCBmZmZmODgwMDExM2U3ZDcwClsgICAgNi42MzQ1Nzld
ICBmZmZmZmZmZjgxMTIwZjQ0IGZmZmY4ODAwMTEzNWNjMDAgZmZmZjg4MDAxMTM2NmUwMCAw
MDAwMDAwMGZmZmZmZmVhClsgICAgNi42MzQ1NzldIENhbGwgVHJhY2U6ClsgICAgNi42MzQ1
NzldICBbPGZmZmZmZmZmODEyNjcyODQ+XSBqZnNfZXZpY3RfaW5vZGUrMHg0NC8weGIwClsg
ICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODExMjAyNDQ+XSBldmljdCsweGE0LzB4MTcwClsg
ICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODExMjBmNDQ+XSBpcHV0KzB4ZTQvMHgxODAKWyAg
ICA2LjYzNDU3OV0gIFs8ZmZmZmZmZmY4MTI2NjQwOT5dIGpmc19maWxsX3N1cGVyKzB4MWI5
LzB4MzgwClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODExMGI2MDk+XSBtb3VudF9iZGV2
KzB4MTg5LzB4MWMwClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODEyNjYyNTA+XSA/IGpm
c19yZW1vdW50KzB4MWIwLzB4MWIwClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODE0NGEw
MjI+XSA/IGlkYV9nZXRfbmV3X2Fib3ZlKzB4MWUyLzB4MjIwClsgICAgNi42MzQ1NzldICBb
PGZmZmZmZmZmODEyNjU0MTA+XSBqZnNfZG9fbW91bnQrMHgxMC8weDIwClsgICAgNi42MzQ1
NzldICBbPGZmZmZmZmZmODExMGI4NDM+XSBtb3VudF9mcysweDMzLzB4MWMwClsgICAgNi42
MzQ1NzldICBbPGZmZmZmZmZmODExMjRjNzY+XSB2ZnNfa2Vybl9tb3VudCsweDY2LzB4MTEw
ClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODExMjZhMzM+XSBkb19tb3VudCsweDI0My8w
eGFkMApbICAgIDYuNjM0NTc5XSAgWzxmZmZmZmZmZjgxMGU0ZjMzPl0gPyBzdHJuZHVwX3Vz
ZXIrMHg0My8weDYwClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODExMjc2NzA+XSBTeVNf
bW91bnQrMHg4MC8weGMwClsgICAgNi42MzQ1NzldICBbPGZmZmZmZmZmODFjMDMzYjA+XSB0
cmFjZXN5cysweGNmLzB4ZDQKWyAgICA2LjYzNDU3OV0gQ29kZTogMDAgMDAgNTUgYmUgZmYg
ZmYgZmYgZmYgNDggODkgZTUgZTggMjIgZjQgZmYgZmYgNWQgYzMgZjYgNDcgMGMgMjAgNTUg
NDggODkgZTUgNzUgMjMgNDggOGIgNDcgMjggNDggNjMgODAgNTAgMDIgMDAgMDAgODUgYzAg
NzUgMTcgPDQ4PiA4MyAzYyAyNSAwMCAwMCAwMCAwMCAwMCA3NSAxNSAzMSBjMCA0OCA4MyA3
OCAwOCAwMCA3NSAwYyA1ZCAKWyAgICA2LjYzNDU3OV0gUklQICBbPGZmZmZmZmZmODExNTk1
Yzk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNjM0NTc5XSAgUlNQIDxmZmZmODgw
MDExM2U3ZDEwPgpbICAgIDYuNjM0NTc5XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA2
LjY3OTI0Nl0gLS0tWyBlbmQgdHJhY2UgZDVlNTViNmM3NTJlZjhiMSBdLS0tClsgICAgNi42
Nzk5NzFdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9iZGUxZWZiNmU5MzVjNTA1YzA1
OTlkYWVlNjQyOGE2ZjlhZjMwNTQxL2RtZXNnLXlvY3RvLXZwLTEyOjIwMTQxMDAxMDkxNTA5
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwNTItZ2JkZTFl
ZmI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2JkZTFlZmI2ZTkz
NWM1MDVjMDU5OWRhZWU2NDI4YTZmOWFmMzA1NDEvZG1lc2cteW9jdG8tdnAtMjQ6MjAxNDEw
MDEwOTE1MDk6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDA1
Mi1nYmRlMWVmYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYmRl
MWVmYjZlOTM1YzUwNWMwNTk5ZGFlZTY0MjhhNmY5YWYzMDU0MS9kbWVzZy15b2N0by12cC0z
ODoyMDE0MTAwMTA5MTUxMDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwMDUyLWdiZGUxZWZiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS9iZGUxZWZiNmU5MzVjNTA1YzA1OTlkYWVlNjQyOGE2ZjlhZjMwNTQxL2RtZXNnLXlv
Y3RvLXZwLTQ4OjIwMTQxMDAxMDkxNTA5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDAwNTItZ2JkZTFlZmI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5L2JkZTFlZmI2ZTkzNWM1MDVjMDU5OWRhZWU2NDI4YTZmOWFmMzA1NDEv
ZG1lc2cteW9jdG8tdnAtNTI6MjAxNDEwMDEwOTE1MDk6eDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTk6My4xNy4wLXJjNy0wMDA1Mi1nYmRlMWVmYjoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvYmRlMWVmYjZlOTM1YzUwNWMwNTk5ZGFlZTY0MjhhNmY5
YWYzMDU0MS9kbWVzZy15b2N0by12cC01NzoyMDE0MTAwMTA5MTUwOTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDUyLWdiZGUxZWZiOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9iZGUxZWZiNmU5MzVjNTA1YzA1OTlkYWVl
NjQyOGE2ZjlhZjMwNTQxL2RtZXNnLXlvY3RvLXZwLTYwOjIwMTQxMDAxMDkxNTA5Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwNTItZ2JkZTFlZmI6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2JkZTFlZmI2ZTkzNWM1MDVj
MDU5OWRhZWU2NDI4YTZmOWFmMzA1NDEvZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDEwMDEwOTE1
MDk6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDA1Mi1nYmRl
MWVmYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYmRlMWVmYjZl
OTM1YzUwNWMwNTk5ZGFlZTY0MjhhNmY5YWYzMDU0MS9kbWVzZy15b2N0by12cC05OjIwMTQx
MDAxMDkxNTEwOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAw
NTItZ2JkZTFlZmI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2Jk
ZTFlZmI2ZTkzNWM1MDVjMDU5OWRhZWU2NDI4YTZmOWFmMzA1NDEvZG1lc2cteW9jdG8tdnAt
MjoyMDE0MTAwMTA5MTUxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwMDUyLWdiZGUxZWZiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS9iZGUxZWZiNmU5MzVjNTA1YzA1OTlkYWVlNjQyOGE2ZjlhZjMwNTQxL2RtZXNnLXlv
Y3RvLXZwLTMxOjIwMTQxMDAxMDkxNTE1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDAwNTItZ2JkZTFlZmI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5L2JkZTFlZmI2ZTkzNWM1MDVjMDU5OWRhZWU2NDI4YTZmOWFmMzA1NDEv
ZG1lc2cteW9jdG8tdnAtNTY6MjAxNDEwMDEwOTE1MTQ6eDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTk6My4xNy4wLXJjNy0wMDA1Mi1nYmRlMWVmYjoxCjA6MTI6MTIgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIG5l
dC9tYXN0ZXIKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5l
YXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGJkZTFlZmI2ZTkzNWM1MDVjMDU5OWRhZWU2
NDI4YTZmOWFmMzA1NDEgN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgw
ZiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiZGUxZWZiLi4uIE1lcmdlICduZXQv
bWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MTAwMTA1CkhFQUQgaXMgbm93IGF0IDNm
M2EwMTkuLi4gTWVyZ2UgYnJhbmNoICdha3BtL21hc3RlcicKQmlzZWN0aW5nOiAxNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2VmZmE0
YmM0ZTc1YTI2NTEwNWY0Y2NiNTU4NTcwNTdlNWFkMjMxZWRdIG5ldC9tbHg0X2NvcmU6IEFs
bG93IG5vdCB0byBzcGVjaWZ5IHByb2JlX3ZmIGluIFNSSU9WIElCIG1vZGUKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQxMDAxMDU6ZWZmYTRiYzRlNzVhMjY1MTA1ZjRjY2I1NTg1NzA1N2U1YWQyMzFl
ZDpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wMSAwOToxNjoyNiBlZmZhNGJjNGU3NWEyNjUx
MDVmNGNjYjU1ODU3MDU3ZTVhZDIzMWVkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS1lZmZhNGJjNGU3NWEyNjUxMDVmNGNjYjU1ODU3MDU3ZTVhZDIzMWVkCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9l
ZmZhNGJjNGU3NWEyNjUxMDVmNGNjYjU1ODU3MDU3ZTVhZDIzMWVkCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTktZWZmYTRiYzRlNzVhMjY1MTA1ZjRjY2I1NTg1NzA1
N2U1YWQyMzFlZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTkvZWZmYTRiYzRlNzVhMjY1MTA1ZjRjY2I1NTg1NzA1N2U1YWQyMzFlZC92bWxpbnV6LTMu
MTcuMC1yYzYtMDAyNTEtZ2VmZmE0YmMKCjIwMTQtMTAtMDEgMDk6MTk6MjcgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMjUJMzkgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbMTdjOWM4MjMyNjYz
YTQ3ZjA3NGI3NDUyYjliMDM0ZWZkYTg2OGNhN10gZW1hdGNoOiBGaXggbWF0Y2hpbmcgb2Yg
aW52ZXJ0ZWQgY29udGFpbmVycy4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDU6MTdjOWM4MjMy
NjYzYTQ3ZjA3NGI3NDUyYjliMDM0ZWZkYTg2OGNhNzpiaXNlY3QtbGludXgtMgoKMjAxNC0x
MC0wMSAwOToyMToyNyAxN2M5YzgyMzI2NjNhNDdmMDc0Yjc0NTJiOWIwMzRlZmRhODY4Y2E3
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS0xN2M5YzgyMzI2NjNhNDdm
MDc0Yjc0NTJiOWIwMzRlZmRhODY4Y2E3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8xN2M5YzgyMzI2NjNhNDdmMDc0Yjc0NTJi
OWIwMzRlZmRhODY4Y2E3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkt
MTdjOWM4MjMyNjYzYTQ3ZjA3NGI3NDUyYjliMDM0ZWZkYTg2OGNhNwprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMTdjOWM4MjMyNjYzYTQ3ZjA3NGI3
NDUyYjliMDM0ZWZkYTg2OGNhNy92bWxpbnV6LTMuMTcuMC1yYzYtMDAyNTktZzE3YzljODIK
CjIwMTQtMTAtMDEgMDk6MjQ6MjggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxMwkzOSBTVUND
RVNTCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDIgc3RlcHMpClswZDM2ODgyMDEzZTYxZGM0N2FhODM1YzRlYzk4YjFmZTc3NmM5
ZGI4XSBuZXR4ZW46IEZpeCBCVUcgInNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGlu
dmFsaWQgY29udGV4dCIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDU6MGQzNjg4MjAxM2U2MWRj
NDdhYTgzNWM0ZWM5OGIxZmU3NzZjOWRiODpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wMSAw
OToyNTo1OCAwZDM2ODgyMDEzZTYxZGM0N2FhODM1YzRlYzk4YjFmZTc3NmM5ZGI4IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3Nu
Yi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS0wZDM2ODgyMDEzZTYxZGM0N2FhODM1
YzRlYzk4YjFmZTc3NmM5ZGI4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8wZDM2ODgyMDEzZTYxZGM0N2FhODM1YzRlYzk4YjFm
ZTc3NmM5ZGI4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktMGQzNjg4
MjAxM2U2MWRjNDdhYTgzNWM0ZWM5OGIxZmU3NzZjOWRiOAprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMGQzNjg4MjAxM2U2MWRjNDdhYTgzNWM0ZWM5
OGIxZmU3NzZjOWRiOC92bWxpbnV6LTMuMTcuMC1yYzYtMDAyNjMtZzBkMzY4ODIKCjIwMTQt
MTAtMDEgMDk6Mjg6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxOQkyMy4JMzYJMzkgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDEgc3RlcCkKWzM3YjlhMjY3M2NkMjRlMzg5MjE2NzcwYmUyNGEwNjRiNjIwMGE4
MjJdIE1lcmdlIGJyYW5jaCAnbmV0eGVuJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNTozN2I5
YTI2NzNjZDI0ZTM4OTIxNjc3MGJlMjRhMDY0YjYyMDBhODIyOmJpc2VjdC1saW51eC0yCgoy
MDE0LTEwLTAxIDA5OjMyOjAxIDM3YjlhMjY3M2NkMjRlMzg5MjE2NzcwYmUyNGEwNjRiNjIw
MGE4MjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LTM3YjlhMjY3M2Nk
MjRlMzg5MjE2NzcwYmUyNGEwNjRiNjIwMGE4MjIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzM3YjlhMjY3M2NkMjRlMzg5MjE2
NzcwYmUyNGEwNjRiNjIwMGE4MjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS0zN2I5YTI2NzNjZDI0ZTM4OTIxNjc3MGJlMjRhMDY0YjYyMDBhODIyCmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8zN2I5YTI2NzNjZDI0ZTM4
OTIxNjc3MGJlMjRhMDY0YjYyMDBhODIyL3ZtbGludXotMy4xNy4wLXJjNi0wMDI2NS1nMzdi
OWEyNgoKMjAxNC0xMC0wMSAwOTo0MTowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTM5IFNV
Q0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMCBzdGVwcykKW2Y1NjFkZTMzZDYzYWVmYjk3ZmIwYzM2NTNhMzZmYjMyZDRl
OGM3NGFdIHI4MTUyOiBmaXggc2V0dGluZyBSVEw4MTUyX1VOUExVRwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtMi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDEwMDEwNTpmNTYxZGUzM2Q2M2FlZmI5N2ZiMGMzNjUzYTM2ZmIzMmQ0ZThjNzRhOmJp
c2VjdC1saW51eC0yCgoyMDE0LTEwLTAxIDA5OjQyOjEzIGY1NjFkZTMzZDYzYWVmYjk3ZmIw
YzM2NTNhMzZmYjMyZDRlOGM3NGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5LWY1NjFkZTMzZDYzYWVmYjk3ZmIwYzM2NTNhMzZmYjMyZDRlOGM3NGEKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2Y1NjFk
ZTMzZDYzYWVmYjk3ZmIwYzM2NTNhMzZmYjMyZDRlOGM3NGEKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOS1mNTYxZGUzM2Q2M2FlZmI5N2ZiMGMzNjUzYTM2ZmIzMmQ0ZThjNzRh
ChtbMTszNW0yMDE0LTEwLTAxIDA5OjQ0OjEzIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVp
bGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWY1
NjFkZTMzZDYzYWVmYjk3ZmIwYzM2NTNhMzZmYjMyZDRlOGM3NGEbWzBtClJldHJ5IGJ1aWxk
IC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktZjU2MWRlMzNkNjNh
ZWZiOTdmYjBjMzY1M2EzNmZiMzJkNGU4Yzc0YQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvZjU2MWRlMzNkNjNhZWZiOTdmYjBjMzY1M2EzNmZiMzJk
NGU4Yzc0YS92bWxpbnV6LTMuMTcuMC1yYzYtMDAyNjYtZ2Y1NjFkZTMKCjIwMTQtMTAtMDEg
MDk6NDY6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzOSBTVUNDRVNTCgpiZGUxZWZiNmU5
MzVjNTA1YzA1OTlkYWVlNjQyOGE2ZjlhZjMwNTQxIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0
CmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBmNTYxZGUz
Li4uIHI4MTUyOiBmaXggc2V0dGluZyBSVEw4MTUyX1VOUExVRwpIRUFEIGlzIG5vdyBhdCA3
YjJhMzBlLi4uIE1lcmdlICdleHQzL2Zvcl90ZXN0aW5nJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MTAwMTA1CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEw
NTo3YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmOmJpc2VjdC1saW51
eC0yCgoyMDE0LTEwLTAxIDA5OjQ3OjE1IDdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVm
Y2QwYjI3ZWY4MGYgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL3ZtbGludXotMy4x
Ny4wLXJjNy0wMDAyMC1nN2IyYTMwZQoKMjAxNC0xMC0wMSAwOTo0NzoxNSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDYuNzA3MDM3XSBVREYtZnM6IHdhcm5p
bmcgKGRldmljZSB2ZGEpOiB1ZGZfZmlsbF9zdXBlcjogTm8gcGFydGl0aW9uIGZvdW5kICgy
KQpbICAgIDYuNzA4MzgwXSBVREYtZnM6IHdhcm5pbmcgKGRldmljZSB2ZGYpOiB1ZGZfZmls
bF9zdXBlcjogTm8gcGFydGl0aW9uIGZvdW5kICgyKQpbICAgIDYuNzA5NjMwXSBNb3VudCBK
RlMgRmFpbHVyZTogLTIyClsgICAgNi43MTAyNDddIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAg
ICA2LjcxMTIzM10gSVA6IFs8ZmZmZmZmZmY4MTE1OTVjOT5dIGRxdW90X2Ryb3ArMHgxOS8w
eDQwClsgICAgNi43MTEyMzNdIFBHRCAxMTFkODA2NyBQVUQgMTBjMzcwNjcgUE1EIDAgClsg
ICAgNi43MTEyMzNdIE9vcHM6IDAwMDAgWyMxXSAKWyAgICA2LjcxMTIzM10gQ1BVOiAwIFBJ
RDogMzg5IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDAwMjAtZzdiMmEz
MGUgIzIKWyAgICA2LjcxMTIzM10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNzExMjMzXSB0YXNrOiBmZmZmODgwMDExMzcwNjYw
IHRpOiBmZmZmODgwMDExM2FjMDAwIHRhc2sudGk6IGZmZmY4ODAwMTEzYWMwMDAKWyAgICA2
LjcxMTIzM10gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTE1OTVjOT5dICBbPGZmZmZmZmZmODEx
NTk1Yzk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNzExMjMzXSBSU1A6IDAwMTg6
ZmZmZjg4MDAxMTNhZmQxMCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDYuNzExMjMzXSBSQVg6
IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMDEyYTIwNmM4IFJDWDogMDAwMDAwMDAw
MDAwMDAzNwpbICAgIDYuNzExMjMzXSBSRFg6IDAwMDAwMDAwODAwMDAwMDAgUlNJOiAwMDAw
MDAwMDAwMDAwMWYwIFJESTogZmZmZjg4MDAxMmEyMDZjOApbICAgIDYuNzExMjMzXSBSQlA6
IGZmZmY4ODAwMTEzYWZkMTAgUjA4OiAwMDAwMDAwMDU0MmI1ZDMwIFIwOTogMDAwMDAwMDAw
MDAwMDNjNApbICAgIDYuNzExMjMzXSBSMTA6IGZmZmY4ODAwMTNmZmJhNDAgUjExOiAwMDAw
MDAwMDAwMDAwM2M0IFIxMjogZmZmZmZmZmY4MWViZGJjMApbICAgIDYuNzExMjMzXSBSMTM6
IGZmZmZmZmZmODFlYmRiYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjg4MDAx
MjgwMzA0MApbICAgIDYuNzExMjMzXSBGUzogIDAwMDA3ZjM3M2FiODk3MDAoMDAwMCkgR1M6
ZmZmZmZmZmY4MjQyMTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgNi43
MTEyMzNdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAw
M2IKWyAgICA2LjcxMTIzM10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAx
MTI0NTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZjAKWyAgICA2LjcxMTIzM10gU3RhY2s6Clsg
ICAgNi43MTEyMzNdICBmZmZmODgwMDExM2FmZDI4IGZmZmZmZmZmODEyNjcyODQgZmZmZjg4
MDAxMmEyMDZjOCBmZmZmODgwMDExM2FmZDQ4ClsgICAgNi43MTEyMzNdICBmZmZmZmZmZjgx
MTIwMjQ0IGZmZmY4ODAwMTJhMjA2YzggZmZmZjg4MDAxMGQwNDAwMCBmZmZmODgwMDExM2Fm
ZDcwClsgICAgNi43MTEyMzNdICBmZmZmZmZmZjgxMTIwZjQ0IGZmZmY4ODAwMTBkMDQwMDAg
ZmZmZjg4MDAxMTRlMTAwMCAwMDAwMDAwMGZmZmZmZmVhClsgICAgNi43MTEyMzNdIENhbGwg
VHJhY2U6ClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODEyNjcyODQ+XSBqZnNfZXZpY3Rf
aW5vZGUrMHg0NC8weGIwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODExMjAyNDQ+XSBl
dmljdCsweGE0LzB4MTcwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODExMjBmNDQ+XSBp
cHV0KzB4ZTQvMHgxODAKWyAgICA2LjcxMTIzM10gIFs8ZmZmZmZmZmY4MTI2NjQwOT5dIGpm
c19maWxsX3N1cGVyKzB4MWI5LzB4MzgwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODEx
MGI2MDk+XSBtb3VudF9iZGV2KzB4MTg5LzB4MWMwClsgICAgNi43MTEyMzNdICBbPGZmZmZm
ZmZmODEyNjYyNTA+XSA/IGpmc19yZW1vdW50KzB4MWIwLzB4MWIwClsgICAgNi43MTEyMzNd
ICBbPGZmZmZmZmZmODE0NGEwMjI+XSA/IGlkYV9nZXRfbmV3X2Fib3ZlKzB4MWUyLzB4MjIw
ClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODEyNjU0MTA+XSBqZnNfZG9fbW91bnQrMHgx
MC8weDIwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODExMGI4NDM+XSBtb3VudF9mcysw
eDMzLzB4MWMwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODExMjRjNzY+XSB2ZnNfa2Vy
bl9tb3VudCsweDY2LzB4MTEwClsgICAgNi43MTEyMzNdICBbPGZmZmZmZmZmODExMjZhMzM+
XSBkb19tb3VudCsweDI0My8weGFkMApbICAgIDYuNzExMjMzXSAgWzxmZmZmZmZmZjgxMGU0
ZjMzPl0gPyBzdHJuZHVwX3VzZXIrMHg0My8weDYwClsgICAgNi43MTEyMzNdICBbPGZmZmZm
ZmZmODExMjc2NzA+XSBTeVNfbW91bnQrMHg4MC8weGMwClsgICAgNi43MTEyMzNdICBbPGZm
ZmZmZmZmODFjMDMzNzA+XSB0cmFjZXN5cysweGNmLzB4ZDQKWyAgICA2LjcxMTIzM10gQ29k
ZTogMDAgMDAgNTUgYmUgZmYgZmYgZmYgZmYgNDggODkgZTUgZTggMjIgZjQgZmYgZmYgNWQg
YzMgZjYgNDcgMGMgMjAgNTUgNDggODkgZTUgNzUgMjMgNDggOGIgNDcgMjggNDggNjMgODAg
NTAgMDIgMDAgMDAgODUgYzAgNzUgMTcgPDQ4PiA4MyAzYyAyNSAwMCAwMCAwMCAwMCAwMCA3
NSAxNSAzMSBjMCA0OCA4MyA3OCAwOCAwMCA3NSAwYyA1ZCAKWyAgICA2LjcxMTIzM10gUklQ
ICBbPGZmZmZmZmZmODExNTk1Yzk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNzEx
MjMzXSAgUlNQIDxmZmZmODgwMDExM2FmZDEwPgpbICAgIDYuNzExMjMzXSBDUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICA2Ljc1Mzg0N10gLS0tWyBlbmQgdHJhY2UgMjMyMWI0MmYxMmIz
MDM1NiBdLS0tClsgICAgNi43NTQ1ODVdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBG
YXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83
YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZw
LTM3OjIwMTQxMDAxMDk0NzMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcu
MC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2ct
eW9jdG8tdnAtMTM6MjAxNDEwMDEwOTQ3MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgw
Zi9kbWVzZy15b2N0by12cC0xNDoyMDE0MTAwMTA5NDczNzp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNk
MGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTE1OjIwMTQxMDAxMDk0NzMzOng4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBh
ODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtMToyMDE0MTAwMTA5NDczNDp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3
ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTI5OjIwMTQxMDAxMDk0
NzM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdi
MmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVk
YjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtMzE6MjAx
NDEwMDEwOTQ3MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0w
MDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkv
N2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12
cC0zMzoyMDE0MTAwMTA5NDczMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3
LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNn
LXlvY3RvLXZwLTM0OjIwMTQxMDAxMDk0NzM3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4
MGYvZG1lc2cteW9jdG8tdnAtMzg6MjAxNDEwMDEwOTQ3MzQ6eDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZj
ZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC0zOjIwMTQxMDAxMDk0NzM0Ong4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBh
ODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNDA6MjAxNDEwMDEwOTQ3MzQ6eDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToy
CjM5OjEyOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKChtbMTszNW0yMDE0LTEwLTAx
IDA5OjQ3OjQ2IGJhZCBiaXNlY3QsIHJldHJ5IHdpdGggaW5jcmVhc2VkIHJlcGVhdCBjb3Vu
dCAxMTcbWzBtClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDdiMmEzMGUuLi4gTWVyZ2Ug
J2V4dDMvZm9yX3Rlc3RpbmcnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDUKSEVBRCBp
cyBub3cgYXQgYjdkYzk1OS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHkt
MjAxNDEwMDEwNScKZ2l0IGNoZWNrb3V0IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4
ZDVmNjc5NzlhZGIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTEwMDEwODE5L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MTAw
MTA1OmZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGI6YmlzZWN0LWxp
bnV4LTIKCjIwMTQtMTAtMDEgMDk6NDc6NDcgZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5
NThkNWY2Nzk3OWFkYiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvdm1saW51ei0z
LjE3LjAtcmM3CgoyMDE0LTEwLTAxIDA5OjQ3OjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4u
CTgzCTExNyBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGZlODJkY2VjNjQ0MjQ0Njc2
ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIKZ2l0IGJpc2VjdCBzdGFydCBiN2RjOTU5ZTk4MDZh
NDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwIGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRj
OTU4ZDVmNjc5NzlhZGIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIi
LCAiYjdkYzk1OWU5ODA2YTQzMjc0MmYzYjAyODFkZGNiMmI4MTVkNWVlMCIsICItZyIsICJm
ZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIiwgIi9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGlu
dXgtMi9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNDEwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzg5NmM0MDlhNDNjODczNjcxZDZk
NGU3NmUyNzMyNjhkMzdlZDNkYzBdIE1lcmdlICdtbGFua2hvcnN0L2Zvci1haXJsaWVkLW5l
eHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDUKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAx
MDU6ODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMDpiaXNlY3QtbGlu
dXgtMgogVEVTVCBGQUlMVVJFClsgICAgNi41MTMzMDBdIE1vdW50IEpGUyBGYWlsdXJlOiAt
MjIKWyAgICA2LjUxMzk0M10gVURGLWZzOiB3YXJuaW5nIChkZXZpY2UgdmRjKTogdWRmX2Zp
bGxfc3VwZXI6IE5vIHBhcnRpdGlvbiBmb3VuZCAoMikKWyAgICA2LjUxNTExOV0gTW91bnQg
SkZTIEZhaWx1cmU6IC0yMgpbICAgIDYuNTE1Njk3XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUg
a2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsg
ICAgNi41MTYxMTFdIElQOiBbPGZmZmZmZmZmODExNTk2ODk+XSBkcXVvdF9kcm9wKzB4MTkv
MHg0MApbICAgIDYuNTE2MTExXSBQR0QgMTBjYTQwNjcgUFVEIDExMWNjMDY3IFBNRCAwIApb
ICAgIDYuNTE2MTExXSBPb3BzOiAwMDAwIFsjMV0gClsgICAgNi41MTYxMTFdIENQVTogMCBQ
SUQ6IDM4NiBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjE3LjAtcmM3LTAwOTkwLWc4OTZj
NDA5ICMxClsgICAgNi41MTYxMTFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICA2LjUxNjExMV0gdGFzazogZmZmZjg4MDAxMTM2Y2Ni
MCB0aTogZmZmZjg4MDAxMTM3MDAwMCB0YXNrLnRpOiBmZmZmODgwMDExMzcwMDAwClsgICAg
Ni41MTYxMTFdIFJJUDogMDAxMDpbPGZmZmZmZmZmODExNTk2ODk+XSAgWzxmZmZmZmZmZjgx
MTU5Njg5Pl0gZHF1b3RfZHJvcCsweDE5LzB4NDAKWyAgICA2LjUxNjExMV0gUlNQOiAwMDE4
OmZmZmY4ODAwMTEzNzNkMTAgIEVGTEFHUzogMDAwMTAyNDYKWyAgICA2LjUxNjExMV0gUkFY
OiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAxMmEyMGJhOCBSQ1g6IDAwMDAwMDAw
MDAwMDAwMzcKWyAgICA2LjUxNjExMV0gUkRYOiAwMDAwMDAwMDgwMDAwMDAwIFJTSTogMDAw
MDAwMDAwMDAwMDFmMCBSREk6IGZmZmY4ODAwMTJhMjBiYTgKWyAgICA2LjUxNjExMV0gUkJQ
OiBmZmZmODgwMDExMzczZDEwIFIwODogMDAwMDAwMDA1NDJiNTIzMiBSMDk6IDAwMDAwMDAw
MDAwMDAzYzkKWyAgICA2LjUxNjExMV0gUjEwOiBmZmZmZmZmZjgyNjkzMjgwIFIxMTogMDAw
MDAwMDAwMDAwMDNjOSBSMTI6IGZmZmZmZmZmODFlYmRiYzAKWyAgICA2LjUxNjExMV0gUjEz
OiBmZmZmZmZmZjgxZWJkYmMwIFIxNDogMDAwMDAwMDAwMDAwMDAwMSBSMTU6IGZmZmY4ODAw
MTI4MDMzNDAKWyAgICA2LjUxNjExMV0gRlM6ICAwMDAwN2YzYWYyMGRlNzAwKDAwMDApIEdT
OmZmZmZmZmZmODI0MjEwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDYu
NTE2MTExXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDNiClsgICAgNi41MTYxMTFdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAw
MTBjYTgwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgNi41MTYxMTFdIFN0YWNrOgpb
ICAgIDYuNTE2MTExXSAgZmZmZjg4MDAxMTM3M2QyOCBmZmZmZmZmZjgxMjY3MzQ0IGZmZmY4
ODAwMTJhMjBiYTggZmZmZjg4MDAxMTM3M2Q0OApbICAgIDYuNTE2MTExXSAgZmZmZmZmZmY4
MTEyMDMwNCBmZmZmODgwMDEyYTIwYmE4IGZmZmY4ODAwMTEwZThjMDAgZmZmZjg4MDAxMTM3
M2Q3MApbICAgIDYuNTE2MTExXSAgZmZmZmZmZmY4MTEyMTAwNCBmZmZmODgwMDExMGU4YzAw
IGZmZmY4ODAwMTBjZDFlMDAgMDAwMDAwMDBmZmZmZmZlYQpbICAgIDYuNTE2MTExXSBDYWxs
IFRyYWNlOgpbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMjY3MzQ0Pl0gamZzX2V2aWN0
X2lub2RlKzB4NDQvMHhiMApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMTIwMzA0Pl0g
ZXZpY3QrMHhhNC8weDE3MApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMTIxMDA0Pl0g
aXB1dCsweGU0LzB4MTgwClsgICAgNi41MTYxMTFdICBbPGZmZmZmZmZmODEyNjY0Yzk+XSBq
ZnNfZmlsbF9zdXBlcisweDFiOS8weDM4MApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgx
MTBiNmM5Pl0gbW91bnRfYmRldisweDE4OS8weDFjMApbICAgIDYuNTE2MTExXSAgWzxmZmZm
ZmZmZjgxMjY2MzEwPl0gPyBqZnNfcmVtb3VudCsweDFiMC8weDFiMApbICAgIDYuNTE2MTEx
XSAgWzxmZmZmZmZmZjgxNDRhMGUyPl0gPyBpZGFfZ2V0X25ld19hYm92ZSsweDFlMi8weDIy
MApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMjY1NGQwPl0gamZzX2RvX21vdW50KzB4
MTAvMHgyMApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMTBiOTAzPl0gbW91bnRfZnMr
MHgzMy8weDFjMApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMTI0ZDM2Pl0gdmZzX2tl
cm5fbW91bnQrMHg2Ni8weDExMApbICAgIDYuNTE2MTExXSAgWzxmZmZmZmZmZjgxMTI2YWYz
Pl0gZG9fbW91bnQrMHgyNDMvMHhhZDAKWyAgICA2LjUxNjExMV0gIFs8ZmZmZmZmZmY4MTBl
NGZmMz5dID8gc3RybmR1cF91c2VyKzB4NDMvMHg2MApbICAgIDYuNTE2MTExXSAgWzxmZmZm
ZmZmZjgxMTI3NzMwPl0gU3lTX21vdW50KzB4ODAvMHhjMApbICAgIDYuNTE2MTExXSAgWzxm
ZmZmZmZmZjgxYzAzYTcwPl0gdHJhY2VzeXMrMHhjZi8weGQ0ClsgICAgNi41MTYxMTFdIENv
ZGU6IDAwIDAwIDU1IGJlIGZmIGZmIGZmIGZmIDQ4IDg5IGU1IGU4IDIyIGY0IGZmIGZmIDVk
IGMzIGY2IDQ3IDBjIDIwIDU1IDQ4IDg5IGU1IDc1IDIzIDQ4IDhiIDQ3IDI4IDQ4IDYzIDgw
IDUwIDAyIDAwIDAwIDg1IGMwIDc1IDE3IDw0OD4gODMgM2MgMjUgMDAgMDAgMDAgMDAgMDAg
NzUgMTUgMzEgYzAgNDggODMgNzggMDggMDAgNzUgMGMgNWQgClsgICAgNi41MTYxMTFdIFJJ
UCAgWzxmZmZmZmZmZjgxMTU5Njg5Pl0gZHF1b3RfZHJvcCsweDE5LzB4NDAKWyAgICA2LjUx
NjExMV0gIFJTUCA8ZmZmZjg4MDAxMTM3M2QxMD4KWyAgICA2LjUxNjExMV0gQ1IyOiAwMDAw
MDAwMDAwMDAwMDAwClsgICAgNi41NzY4NzJdIC0tLVsgZW5kIHRyYWNlIDJjOGFhMmFiNmE0
YTNmZWYgXS0tLQpbICAgIDYuNTc3NTg1XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzog
RmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkv
ODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMC9kbWVzZy15b2N0by12
cC00NzoyMDE0MTAwMTA5MDAzNTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3
LjAtcmM3LTAwOTkwLWc4OTZjNDA5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS84OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwL2RtZXNn
LXlvY3RvLXZwLTI0OjIwMTQxMDAxMDkwMDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5OjMuMTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTEwMDEwODE5Lzg5NmM0MDlhNDNjODczNjcxZDZkNGU3NmUyNzMyNjhkMzdlZDNk
YzAvZG1lc2cteW9jdG8tdnAtMzE6MjAxNDEwMDEwOTAwMzY6eDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDk5MC1nODk2YzQwOToxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTkvODk2YzQwOWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2
OGQzN2VkM2RjMC9kbWVzZy15b2N0by12cC0zMjoyMDE0MTAwMTA5MDAzODp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwOTkwLWc4OTZjNDA5OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS84OTZjNDA5YTQzYzg3MzY3MWQ2ZDRl
NzZlMjczMjY4ZDM3ZWQzZGMwL2RtZXNnLXlvY3RvLXZwLTE5OjIwMTQxMDAxMDkwMDM5Ong4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5Lzg5NmM0MDlhNDNjODcz
NjcxZDZkNGU3NmUyNzMyNjhkMzdlZDNkYzAvZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDEwMDEw
OTAwMzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDk5MC1n
ODk2YzQwOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvODk2YzQw
OWE0M2M4NzM2NzFkNmQ0ZTc2ZTI3MzI2OGQzN2VkM2RjMC9kbWVzZy15b2N0by12cC01NToy
MDE0MTAwMTA5MDAzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3
LTAwOTkwLWc4OTZjNDA5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS84OTZjNDA5YTQzYzg3MzY3MWQ2ZDRlNzZlMjczMjY4ZDM3ZWQzZGMwL2RtZXNnLXlvY3Rv
LXZwLTUwOjIwMTQxMDAxMDkwMDM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMu
MTcuMC1yYzctMDA5OTAtZzg5NmM0MDk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5Lzg5NmM0MDlhNDNjODczNjcxZDZkNGU3NmUyNzMyNjhkMzdlZDNkYzAvZG1l
c2cteW9jdG8tdnAtODoyMDE0MTAwMTA5MDAzNzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOTozLjE3LjAtcmM3LTAwOTkwLWc4OTZjNDA5OjEKMzA6OTo5IGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDk5MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClsyNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNl
ZTY0MzZkN2QzNTg3NmE4XSBNZXJnZSAnYXNvYy90b3BpYy9mc2wtc3NpJyBpbnRvIGRldmVs
LWhvdXJseS0yMDE0MTAwMTA1CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MTAwMTA1OjI2MTAxNzY0NjU2
MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTg6YmlzZWN0LWxpbnV4LTIKIFRFU1QgRkFJ
TFVSRQpbICAgIDcuMTExMDE5XSBVREYtZnM6IHdhcm5pbmcgKGRldmljZSB2ZGUpOiB1ZGZf
ZmlsbF9zdXBlcjogTm8gcGFydGl0aW9uIGZvdW5kICgyKQpbICAgIDcuMTEzMDc4XSBVREYt
ZnM6IHdhcm5pbmcgKGRldmljZSB2ZGYpOiB1ZGZfZmlsbF9zdXBlcjogTm8gcGFydGl0aW9u
IGZvdW5kICgyKQpbICAgIDcuMTE0ODE3XSBNb3VudCBKRlMgRmFpbHVyZTogLTIyClsgICAg
Ny4xMTU3NDldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICA3LjExNjcxOV0gSVA6IFs8ZmZm
ZmZmZmY4MTE1OTVjOT5dIGRxdW90X2Ryb3ArMHgxOS8weDQwClsgICAgNy4xMTY3MTldIFBH
RCAxMTNlZTA2NyBQVUQgMTEwMjEwNjcgUE1EIDAgClsgICAgNy4xMTY3MTldIE9vcHM6IDAw
MDAgWyMxXSAKWyAgICA3LjExNjcxOV0gQ1BVOiAwIFBJRDogMzc5IENvbW06IG1vdW50IE5v
dCB0YWludGVkIDMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzYgIzEKWyAgICA3LjExNjcxOV0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDcuMTE2NzE5XSB0YXNrOiBmZmZmODgwMDExN2E5MzAwIHRpOiBmZmZmODgwMDExMDRjMDAw
IHRhc2sudGk6IGZmZmY4ODAwMTEwNGMwMDAKWyAgICA3LjExNjcxOV0gUklQOiAwMDEwOls8
ZmZmZmZmZmY4MTE1OTVjOT5dICBbPGZmZmZmZmZmODExNTk1Yzk+XSBkcXVvdF9kcm9wKzB4
MTkvMHg0MApbICAgIDcuMTE2NzE5XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMTA0ZmQxMCAgRUZM
QUdTOiAwMDAxMDI0NgpbICAgIDcuMTE2NzE5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJY
OiBmZmZmODgwMDEyYTFlYjI4IFJDWDogMDAwMDAwMDAwMDAwMDAzNwpbICAgIDcuMTE2NzE5
XSBSRFg6IDAwMDAwMDAwODAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMWYwIFJESTogZmZm
Zjg4MDAxMmExZWIyOApbICAgIDcuMTE2NzE5XSBSQlA6IGZmZmY4ODAwMTEwNGZkMTAgUjA4
OiAwMDAwMDAwMDU0MmI1MzFhIFIwOTogMDAwMDAwMDAwMDAwMDNjNQpbICAgIDcuMTE2NzE5
XSBSMTA6IGZmZmY4ODAwMTNmZmIyNDAgUjExOiAwMDAwMDAwMDAwMDAwM2M1IFIxMjogZmZm
ZmZmZmY4MWViZGJjMApbICAgIDcuMTE2NzE5XSBSMTM6IGZmZmZmZmZmODFlYmRiYzAgUjE0
OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjg4MDAxMjgwMzY0MApbICAgIDcuMTE2NzE5
XSBGUzogIDAwMDA3ZjQzOWQ2MDY3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MjQyMTAwMCgwMDAw
KSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgNy4xMTY3MTldIENTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICA3LjExNjcxOV0gQ1Iy
OiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAxMTdiMDAwMCBDUjQ6IDAwMDAwMDAw
MDAwMDA2ZjAKWyAgICA3LjExNjcxOV0gU3RhY2s6ClsgICAgNy4xMTY3MTldICBmZmZmODgw
MDExMDRmZDI4IGZmZmZmZmZmODEyNjcyODQgZmZmZjg4MDAxMmExZWIyOCBmZmZmODgwMDEx
MDRmZDQ4ClsgICAgNy4xMTY3MTldICBmZmZmZmZmZjgxMTIwMjQ0IGZmZmY4ODAwMTJhMWVi
MjggZmZmZjg4MDAxMTJjYjQwMCBmZmZmODgwMDExMDRmZDcwClsgICAgNy4xMTY3MTldICBm
ZmZmZmZmZjgxMTIwZjQ0IGZmZmY4ODAwMTEyY2I0MDAgZmZmZjg4MDAxMTRlMTEwMCAwMDAw
MDAwMGZmZmZmZmVhClsgICAgNy4xMTY3MTldIENhbGwgVHJhY2U6ClsgICAgNy4xMTY3MTld
ICBbPGZmZmZmZmZmODEyNjcyODQ+XSBqZnNfZXZpY3RfaW5vZGUrMHg0NC8weGIwClsgICAg
Ny4xMTY3MTldICBbPGZmZmZmZmZmODExMjAyNDQ+XSBldmljdCsweGE0LzB4MTcwClsgICAg
Ny4xMTY3MTldICBbPGZmZmZmZmZmODExMjBmNDQ+XSBpcHV0KzB4ZTQvMHgxODAKWyAgICA3
LjExNjcxOV0gIFs8ZmZmZmZmZmY4MTI2NjQwOT5dIGpmc19maWxsX3N1cGVyKzB4MWI5LzB4
MzgwClsgICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODExMGI2MDk+XSBtb3VudF9iZGV2KzB4
MTg5LzB4MWMwClsgICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODEyNjYyNTA+XSA/IGpmc19y
ZW1vdW50KzB4MWIwLzB4MWIwClsgICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODE0NGEwMjI+
XSA/IGlkYV9nZXRfbmV3X2Fib3ZlKzB4MWUyLzB4MjIwClsgICAgNy4xMTY3MTldICBbPGZm
ZmZmZmZmODEyNjU0MTA+XSBqZnNfZG9fbW91bnQrMHgxMC8weDIwClsgICAgNy4xMTY3MTld
ICBbPGZmZmZmZmZmODExMGI4NDM+XSBtb3VudF9mcysweDMzLzB4MWMwClsgICAgNy4xMTY3
MTldICBbPGZmZmZmZmZmODExMjRjNzY+XSB2ZnNfa2Vybl9tb3VudCsweDY2LzB4MTEwClsg
ICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODExMjZhMzM+XSBkb19tb3VudCsweDI0My8weGFk
MApbICAgIDcuMTE2NzE5XSAgWzxmZmZmZmZmZjgxMGU0ZjMzPl0gPyBzdHJuZHVwX3VzZXIr
MHg0My8weDYwClsgICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODExMjc2NzA+XSBTeVNfbW91
bnQrMHg4MC8weGMwClsgICAgNy4xMTY3MTldICBbPGZmZmZmZmZmODFjMDMzNzA+XSB0cmFj
ZXN5cysweGNmLzB4ZDQKWyAgICA3LjExNjcxOV0gQ29kZTogMDAgMDAgNTUgYmUgZmYgZmYg
ZmYgZmYgNDggODkgZTUgZTggMjIgZjQgZmYgZmYgNWQgYzMgZjYgNDcgMGMgMjAgNTUgNDgg
ODkgZTUgNzUgMjMgNDggOGIgNDcgMjggNDggNjMgODAgNTAgMDIgMDAgMDAgODUgYzAgNzUg
MTcgPDQ4PiA4MyAzYyAyNSAwMCAwMCAwMCAwMCAwMCA3NSAxNSAzMSBjMCA0OCA4MyA3OCAw
OCAwMCA3NSAwYyA1ZCAKWyAgICA3LjExNjcxOV0gUklQICBbPGZmZmZmZmZmODExNTk1Yzk+
XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDcuMTE2NzE5XSAgUlNQIDxmZmZmODgwMDEx
MDRmZDEwPgpbICAgIDcuMTE2NzE5XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA3LjE4
MzkwN10gLS0tWyBlbmQgdHJhY2UgZTRjZjBjNTRjNTQ3ZjBjMSBdLS0tClsgICAgNy4xODQ5
NzJdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDEx
NGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTM3OjIwMTQxMDAxMDkwNDMzOng4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYw
MzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMTg6MjAxNDEwMDEw
OTA0MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1n
MjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3
NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0xOjIw
MTQxMDAxMDkwNDQwOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzct
MDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8t
dnAtMTU6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4x
Ny4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVz
Zy15b2N0by12cC0yNzoyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3
NmE4L2RtZXNnLXlvY3RvLXZwLTQ0OjIwMTQxMDAxMDkwNDMxOng4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQz
NmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNjE6MjAxNDEwMDEwOTA0MzM6eDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAx
MTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC03OjIwMTQxMDAxMDkwNDM0Ong4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYw
MzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMjk6MjAxNDEwMDEw
OTA0MzM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1n
MjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3
NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0xMzoy
MDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3
LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3Rv
LXZwLTQ5OjIwMTQxMDAxMDkwNDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMu
MTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1l
c2cteW9jdG8tdnAtMTc6MjAxNDEwMDEwOTA0MzE6eDg2XzY0LXJhbmRjb25maWctczAtMTAw
MTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4
NzZhOC9kbWVzZy15b2N0by12cC0zMDoyMDE0MTAwMTA5MDQzMTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0
MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTQyOjIwMTQxMDAxMDkwNDMxOng4Nl82NC1y
YW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMw
MTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMjA6MjAxNDEwMDEwOTA0MzM6
eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3
NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYx
ZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC02MjoyMDE0MTAw
MTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0
LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEw
MTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTIz
OjIwMTQxMDAxMDkwNDMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1y
YzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEw
ODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9j
dG8tdnAtMzoyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOToz
LjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2Rt
ZXNnLXlvY3RvLXZwLTMxOjIwMTQxMDAxMDkwNDMxOng4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1
ODc2YTgvZG1lc2cteW9jdG8tdnAtNDA6MjAxNDEwMDEwOTA0Mzk6eDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2
NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC00MzoyMDE0MTAwMTA5MDQ0MDp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVj
MDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTM2OjIwMTQxMDAxMDkwNDM0
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAx
NzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2
MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNTc6MjAxNDEw
MDEwOTA0MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2
NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYx
MDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC0x
OToyMDE0MTAwMTA5MDQzMTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlv
Y3RvLXZwLTEwOjIwMTQxMDAxMDkwNDMxOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgv
ZG1lc2cteW9jdG8tdnAtMTI6MjAxNDEwMDEwOTA0MzU6eDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdk
MzU4NzZhOC9kbWVzZy15b2N0by12cC0zMzoyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNl
ZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTU5OjIwMTQxMDAxMDkwNDM0Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1
ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtNDoyMDE0MTAwMTA5MDQz
ODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEw
MTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1
NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTUzOjIwMTQx
MDAxMDkwNDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3
NjQtZzI2MTAxNzY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2
MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2VlNjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAt
NToyMDE0MTAwMTA5MDQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlv
Y3RvLXZwLTg6MjAxNDEwMDEwOTA0NDA6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6
My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9k
bWVzZy15b2N0by12cC0xMToyMDE0MTAwMTA5MDQzMjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2Qz
NTg3NmE4L2RtZXNnLXlvY3RvLXZwLTQ1OjIwMTQxMDAxMDkwNDMwOng4Nl82NC1yYW5kY29u
ZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzI2MTAxNzY0NjU2MWYwMzI1ZWMwMTE0Y2Vl
NjQzNmQ3ZDM1ODc2YTgvZG1lc2cteW9jdG8tdnAtMTQ6MjAxNDEwMDEwOTA0MzE6eDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2NC1nMjYxMDE3NjoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYxMDE3NjQ2NTYxZjAzMjVl
YzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC01NDoyMDE0MTAwMTA5MDQz
ODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwNzY0LWcyNjEw
MTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8yNjEwMTc2NDY1
NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlvY3RvLXZwLTk6MjAxNDEw
MDEwOTA0MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDc2
NC1nMjYxMDE3NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMjYx
MDE3NjQ2NTYxZjAzMjVlYzAxMTRjZWU2NDM2ZDdkMzU4NzZhOC9kbWVzZy15b2N0by12cC02
MzoyMDE0MTAwMTA5MDQzMTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwNzY0LWcyNjEwMTc2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS8yNjEwMTc2NDY1NjFmMDMyNWVjMDExNGNlZTY0MzZkN2QzNTg3NmE4L2RtZXNnLXlv
Y3RvLXZwLTM0OjIwMTQxMDAxMDkwNDMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDA3NjQtZzI2MTAxNzY6MQowOjM5OjM5IGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDc2NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls3YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFl
ZmNkMGIyN2VmODBmXSBNZXJnZSAnZXh0My9mb3JfdGVzdGluZycgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDEwMDEwNQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNTo3YjJhMzBlZGIzZmVmNTI3
ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmOmJpc2VjdC1saW51eC0yCiBURVNUIEZBSUxVUkUK
WyAgICA2Ljc5NDY4OF0gVURGLWZzOiB3YXJuaW5nIChkZXZpY2UgdmRkKTogdWRmX2ZpbGxf
c3VwZXI6IE5vIHBhcnRpdGlvbiBmb3VuZCAoMikKWyAgICA2Ljc5NTk5MF0gVURGLWZzOiB3
YXJuaW5nIChkZXZpY2UgdmRmKTogdWRmX2ZpbGxfc3VwZXI6IE5vIHBhcnRpdGlvbiBmb3Vu
ZCAoMikKWyAgICA2Ljc5NzI4Nl0gTW91bnQgSkZTIEZhaWx1cmU6IC0yMgpbICAgIDYuNzk3
ODg5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgNi43OTgyNzddIElQOiBbPGZmZmZmZmZm
ODExNTk1Yzk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNzk4Mjc3XSBQR0QgMTEx
YzYwNjcgUFVEIDExMjdlMDY3IFBNRCAwIApbICAgIDYuNzk4Mjc3XSBPb3BzOiAwMDAwIFsj
MV0gClsgICAgNi43OTgyNzddIENQVTogMCBQSUQ6IDM4NSBDb21tOiBtb3VudCBOb3QgdGFp
bnRlZCAzLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlICMyClsgICAgNi43OTgyNzddIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA2Ljc5
ODI3N10gdGFzazogZmZmZjg4MDAxMTNhZDk1MCB0aTogZmZmZjg4MDAxMTJjODAwMCB0YXNr
LnRpOiBmZmZmODgwMDExMmM4MDAwClsgICAgNi43OTgyNzddIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODExNTk1Yzk+XSAgWzxmZmZmZmZmZjgxMTU5NWM5Pl0gZHF1b3RfZHJvcCsweDE5LzB4
NDAKWyAgICA2Ljc5ODI3N10gUlNQOiAwMDE4OmZmZmY4ODAwMTEyY2JkMTAgIEVGTEFHUzog
MDAwMTAyNDYKWyAgICA2Ljc5ODI3N10gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZm
Zjg4MDAxMmExZjZjOCBSQ1g6IDAwMDAwMDAwMDAwMDAwMzcKWyAgICA2Ljc5ODI3N10gUkRY
OiAwMDAwMDAwMDgwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDFmMCBSREk6IGZmZmY4ODAw
MTJhMWY2YzgKWyAgICA2Ljc5ODI3N10gUkJQOiBmZmZmODgwMDExMmNiZDEwIFIwODogMDAw
MDAwMDA1NDJiNWQzMCBSMDk6IDAwMDAwMDAwMDAwMDAzYzYKWyAgICA2Ljc5ODI3N10gUjEw
OiBmZmZmZmZmZjgyNjkzMjgwIFIxMTogMDAwMDAwMDAwMDAwMDNjNiBSMTI6IGZmZmZmZmZm
ODFlYmRiYzAKWyAgICA2Ljc5ODI3N10gUjEzOiBmZmZmZmZmZjgxZWJkYmMwIFIxNDogMDAw
MDAwMDAwMDAwMDAwMSBSMTU6IGZmZmY4ODAwMTI4MDMwNDAKWyAgICA2Ljc5ODI3N10gRlM6
ICAwMDAwN2Y3ZTEzNGM3NzAwKDAwMDApIEdTOmZmZmZmZmZmODI0MjEwMDAoMDAwMCkga25s
R1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDYuNzk4Mjc3XSBDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgNi43OTgyNzddIENSMjogMDAw
MDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMTBjNzcwMDAgQ1I0OiAwMDAwMDAwMDAwMDAw
NmYwClsgICAgNi43OTgyNzddIFN0YWNrOgpbICAgIDYuNzk4Mjc3XSAgZmZmZjg4MDAxMTJj
YmQyOCBmZmZmZmZmZjgxMjY3Mjg0IGZmZmY4ODAwMTJhMWY2YzggZmZmZjg4MDAxMTJjYmQ0
OApbICAgIDYuNzk4Mjc3XSAgZmZmZmZmZmY4MTEyMDI0NCBmZmZmODgwMDEyYTFmNmM4IGZm
ZmY4ODAwMTBjMDkwMDAgZmZmZjg4MDAxMTJjYmQ3MApbICAgIDYuNzk4Mjc3XSAgZmZmZmZm
ZmY4MTEyMGY0NCBmZmZmODgwMDEwYzA5MDAwIGZmZmY4ODAwMTE0ZTIwMDAgMDAwMDAwMDBm
ZmZmZmZlYQpbICAgIDYuNzk4Mjc3XSBDYWxsIFRyYWNlOgpbICAgIDYuNzk4Mjc3XSAgWzxm
ZmZmZmZmZjgxMjY3Mjg0Pl0gamZzX2V2aWN0X2lub2RlKzB4NDQvMHhiMApbICAgIDYuNzk4
Mjc3XSAgWzxmZmZmZmZmZjgxMTIwMjQ0Pl0gZXZpY3QrMHhhNC8weDE3MApbICAgIDYuNzk4
Mjc3XSAgWzxmZmZmZmZmZjgxMTIwZjQ0Pl0gaXB1dCsweGU0LzB4MTgwClsgICAgNi43OTgy
NzddICBbPGZmZmZmZmZmODEyNjY0MDk+XSBqZnNfZmlsbF9zdXBlcisweDFiOS8weDM4MApb
ICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZmZjgxMTBiNjA5Pl0gbW91bnRfYmRldisweDE4OS8w
eDFjMApbICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZmZjgxMjY2MjUwPl0gPyBqZnNfcmVtb3Vu
dCsweDFiMC8weDFiMApbICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZmZjgxNDRhMDIyPl0gPyBp
ZGFfZ2V0X25ld19hYm92ZSsweDFlMi8weDIyMApbICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZm
ZjgxMjY1NDEwPl0gamZzX2RvX21vdW50KzB4MTAvMHgyMApbICAgIDYuNzk4Mjc3XSAgWzxm
ZmZmZmZmZjgxMTBiODQzPl0gbW91bnRfZnMrMHgzMy8weDFjMApbICAgIDYuNzk4Mjc3XSAg
WzxmZmZmZmZmZjgxMTI0Yzc2Pl0gdmZzX2tlcm5fbW91bnQrMHg2Ni8weDExMApbICAgIDYu
Nzk4Mjc3XSAgWzxmZmZmZmZmZjgxMTI2YTMzPl0gZG9fbW91bnQrMHgyNDMvMHhhZDAKWyAg
ICA2Ljc5ODI3N10gIFs8ZmZmZmZmZmY4MTBlNGYzMz5dID8gc3RybmR1cF91c2VyKzB4NDMv
MHg2MApbICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZmZjgxMTI3NjcwPl0gU3lTX21vdW50KzB4
ODAvMHhjMApbICAgIDYuNzk4Mjc3XSAgWzxmZmZmZmZmZjgxYzAzMzcwPl0gdHJhY2VzeXMr
MHhjZi8weGQ0ClsgICAgNi43OTgyNzddIENvZGU6IDAwIDAwIDU1IGJlIGZmIGZmIGZmIGZm
IDQ4IDg5IGU1IGU4IDIyIGY0IGZmIGZmIDVkIGMzIGY2IDQ3IDBjIDIwIDU1IDQ4IDg5IGU1
IDc1IDIzIDQ4IDhiIDQ3IDI4IDQ4IDYzIDgwIDUwIDAyIDAwIDAwIDg1IGMwIDc1IDE3IDw0
OD4gODMgM2MgMjUgMDAgMDAgMDAgMDAgMDAgNzUgMTUgMzEgYzAgNDggODMgNzggMDggMDAg
NzUgMGMgNWQgClsgICAgNi43OTgyNzddIFJJUCAgWzxmZmZmZmZmZjgxMTU5NWM5Pl0gZHF1
b3RfZHJvcCsweDE5LzB4NDAKWyAgICA2Ljc5ODI3N10gIFJTUCA8ZmZmZjg4MDAxMTJjYmQx
MD4KWyAgICA2Ljc5ODI3N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgNi44NDQ0MDRd
IC0tLVsgZW5kIHRyYWNlIDAwNGFkNWIxYmMwODM4OWYgXS0tLQpbICAgIDYuODQ1MTg4XSBL
ZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZh
ZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC0xNDoyMDE0MTAwMTA5NDczNzp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5
MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTU2OjIwMTQxMDAxMDk0NzM1
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEz
MGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNm
ZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNDg6MjAxNDEw
MDEwOTQ3Mzc6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAy
MC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2Iy
YTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC01
MjoyMDE0MTAwMTA5NDczODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlv
Y3RvLXZwLTI5OjIwMTQxMDAxMDk0NzM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYv
ZG1lc2cteW9jdG8tdnAtNDI6MjAxNDEwMDEwOTQ3MzQ6eDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBi
MjdlZjgwZi9kbWVzZy15b2N0by12cC00MzoyMDE0MTAwMTA5NDczNTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2
NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTUxOjIwMTQxMDAxMDk0NzM0Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4
MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNDQ6MjAxNDEwMDEwOTQ3
MzQ6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2Iy
YTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRi
M2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC0xNToyMDE0
MTAwMTA5NDczMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAw
MDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83
YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZw
LTM6MjAxNDEwMDEwOTQ3MzQ6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4w
LXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAw
MTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15
b2N0by12cC0zNDoyMDE0MTAwMTA5NDczNzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBm
L2RtZXNnLXlvY3RvLXZwLTM3OjIwMTQxMDAxMDk0NzMzOng4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2Qw
YjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDEwMDEwOTQ3MzQ6eDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4
NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC02MToyMDE0MTAwMTA5NDczNDp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3
ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTYyOjIwMTQxMDAxMDk0
NzM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdi
MmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVk
YjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNTA6MjAx
NDEwMDEwOTQ3MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0w
MDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkv
N2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12
cC0xOjIwMTQxMDAxMDk0NzM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcu
MC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2ct
eW9jdG8tdnAtNDU6MjAxNDEwMDEwOTQ3MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgw
Zi9kbWVzZy15b2N0by12cC0zMzoyMDE0MTAwMTA5NDczMzp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNk
MGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTM4OjIwMTQxMDAxMDk0NzM0Ong4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBh
ODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8tdnAtNDA6MjAxNDEwMDEwOTQ3MzQ6eDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMDAyMC1nN2IyYTMwZToy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUy
NzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVzZy15b2N0by12cC0xMzoyMDE0MTAwMTA5
NDczMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3
YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS83YjJhMzBl
ZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2VmODBmL2RtZXNnLXlvY3RvLXZwLTYzOjIw
MTQxMDAxMDk0NzMzOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzct
MDAwMjAtZzdiMmEzMGU6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
LzdiMmEzMGVkYjNmZWY1Mjc4MjkxNTBhODY2YWVmY2QwYjI3ZWY4MGYvZG1lc2cteW9jdG8t
dnAtNjQ6MjAxNDEwMDEwOTQ3MzU6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4x
Ny4wLXJjNy0wMDAyMC1nN2IyYTMwZToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MTAwMTA4MTkvN2IyYTMwZWRiM2ZlZjUyNzgyOTE1MGE4NjZhZWZjZDBiMjdlZjgwZi9kbWVz
Zy15b2N0by12cC0zMToyMDE0MTAwMTA5NDczMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOTozLjE3LjAtcmM3LTAwMDIwLWc3YjJhMzBlOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS83YjJhMzBlZGIzZmVmNTI3ODI5MTUwYTg2NmFlZmNkMGIyN2Vm
ODBmL2RtZXNnLXlvY3RvLXZwLTU5OjIwMTQxMDAxMDk0NzM1Ong4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDAwMjAtZzdiMmEzMGU6Mgo5MDoyNzoyNyBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKW2U4NmM0NGY4NDU2NTkwMTk2
ZDExNDRiYWE3MWQ4MGYxYzMyZTk1M2VdIDBkYXkgYmFzZSBndWFyZCBmb3IgJ2RldmVsLWhv
dXJseS0yMDE0MTAwMTA1JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNTplODZjNDRmODQ1NjU5
MDE5NmQxMTQ0YmFhNzFkODBmMWMzMmU5NTNlOmJpc2VjdC1saW51eC0yCgoyMDE0LTEwLTAx
IDA5OjQ5OjU0IGU4NmM0NGY4NDU2NTkwMTk2ZDExNDRiYWE3MWQ4MGYxYzMyZTk1M2UgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
c25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWU4NmM0NGY4NDU2NTkwMTk2ZDEx
NDRiYWE3MWQ4MGYxYzMyZTk1M2UKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2U4NmM0NGY4NDU2NTkwMTk2ZDExNDRiYWE3MWQ4
MGYxYzMyZTk1M2UKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS1lODZjNDRmODQ1
NjU5MDE5NmQxMTQ0YmFhNzFkODBmMWMzMmU5NTNlChtbMTszNW0yMDE0LTEwLTAxIDA5OjUz
OjU0IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWU4NmM0NGY4NDU2NTkwMTk2ZDExNDRiYWE3
MWQ4MGYxYzMyZTk1M2UbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9lODZjNDRmODQ1NjU5MDE5NmQxMTQ0YmFhNzFk
ODBmMWMzMmU5NTNlL3ZtbGludXotMy4xNy4wLXJjNy0wMDAwMS1nZTg2YzQ0ZgoKMjAxNC0x
MC0wMSAwOTo1NDo1NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMQk0OQk1Mgk2MAkxMDEJ
MTA2LgkxMTcgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgZXh0
My9mb3JfdGVzdGluZwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgN2IyYTMwZWRiM2ZlZjUyNzgyOTE1
MGE4NjZhZWZjZDBiMjdlZjgwZiBlODZjNDRmODQ1NjU5MDE5NmQxMTQ0YmFhNzFkODBmMWMz
MmU5NTNlIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGU4NmM0NGYuLi4gMGRheSBi
YXNlIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDUnCkhFQUQgaXMgbm93IGF0
IDNmM2EwMTkuLi4gTWVyZ2UgYnJhbmNoICdha3BtL21hc3RlcicKQmlzZWN0aW5nOiA5IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbMTBj
YTc5YTM5ZjM5MzE2M2QwNWRkNjI4YzhkODM1NTFlNGJiY2Y4Zl0gb2NmczI6IENvbnZlcnQg
dG8gcHJpdmF0ZSBpX2RxdW90IGZpZWxkCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVu
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtMi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MTAwMTA1OjEwY2E3
OWEzOWYzOTMxNjNkMDVkZDYyOGM4ZDgzNTUxZTRiYmNmOGY6YmlzZWN0LWxpbnV4LTIKCjIw
MTQtMTAtMDEgMTA6MDE6MDMgMTBjYTc5YTM5ZjM5MzE2M2QwNWRkNjI4YzhkODM1NTFlNGJi
Y2Y4ZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktMTBjYTc5YTM5ZjM5
MzE2M2QwNWRkNjI4YzhkODM1NTFlNGJiY2Y4ZgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvMTBjYTc5YTM5ZjM5MzE2M2QwNWRk
NjI4YzhkODM1NTFlNGJiY2Y4Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LTEw
Y2E3OWEzOWYzOTMxNjNkMDVkZDYyOGM4ZDgzNTUxZTRiYmNmOGYKG1sxOzM1bTIwMTQtMTAt
MDEgMTA6MDM6MDMgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1z
ZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktMTBjYTc5YTM5ZjM5MzE2M2Qw
NWRkNjI4YzhkODM1NTFlNGJiY2Y4ZhtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS0xMGNhNzlhMzlmMzkzMTYzZDA1ZGQ2MjhjOGQ4
MzU1MWU0YmJjZjhmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS8xMGNhNzlhMzlmMzkzMTYzZDA1ZGQ2MjhjOGQ4MzU1MWU0YmJjZjhmL3ZtbGludXot
My4xNy4wLXJjNS0wMDAzMy1nMTBjYTc5YQoKMjAxNC0xMC0wMSAxMDowNTowMyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLgkzCTgJNTQJNTcJNjYuCTkzCTk5CTEwMgkxMTUJMTE3IFNVQ0NF
U1MKCkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMiBzdGVwcykKWzM3OTkzMjcxY2ZhMjJiNTYyMDMwNGYxZmEzYmY3MmVhYmI1YjU1
N2JdIHVkZjogcmVtb3ZlIHJlZHVuZGFudCBzeXNfdHogZGVjbGFyYXRpb24KcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQxMDAxMDU6Mzc5OTMyNzFjZmEyMmI1NjIwMzA0ZjFmYTNiZjcyZWFiYjViNTU3
YjpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wMSAxMDoxMTozNCAzNzk5MzI3MWNmYTIyYjU2
MjAzMDRmMWZhM2JmNzJlYWJiNWI1NTdiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS0zNzk5MzI3MWNmYTIyYjU2MjAzMDRmMWZhM2JmNzJlYWJiNWI1NTdiCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS8z
Nzk5MzI3MWNmYTIyYjU2MjAzMDRmMWZhM2JmNzJlYWJiNWI1NTdiCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTktMzc5OTMyNzFjZmEyMmI1NjIwMzA0ZjFmYTNiZjcyZWFiYjVi
NTU3YgobWzE7MzVtMjAxNC0xMC0wMSAxMDoyNTozNCBObyBidWlsZCBzZXJ2ZWQgZmlsZSAv
a2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgx
OS0zNzk5MzI3MWNmYTIyYjU2MjAzMDRmMWZhM2JmNzJlYWJiNWI1NTdiG1swbQpSZXRyeSBi
dWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LTM3OTkzMjcx
Y2ZhMjJiNTYyMDMwNGYxZmEzYmY3MmVhYmI1YjU1N2IKa2VybmVsOiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LzM3OTkzMjcxY2ZhMjJiNTYyMDMwNGYxZmEzYmY3
MmVhYmI1YjU1N2Ivdm1saW51ei0zLjE3LjAtcmMzLTAwMDc3LWczNzk5MzI3CgoyMDE0LTEw
LTAxIDEwOjI3OjM0IGRldGVjdGluZyBib290IHN0YXRlIC4JNgk0Mwk0OQk1Nwk4MAk5Ngkx
MDIJMTEzCTExNyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzgyZDk3NDVlYjExYTAzYzk3Njc3ODYy
OWUxNWY1YTc1MmMwOWMzNDZdIHZmczogUmVtb3ZlIGlfZHF1b3QgZmllbGQgZnJvbSBpbm9k
ZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNTo4MmQ5NzQ1ZWIxMWEwM2M5NzY3Nzg2MjllMTVm
NWE3NTJjMDljMzQ2OmJpc2VjdC1saW51eC0yCgoyMDE0LTEwLTAxIDEwOjMzOjQ5IDgyZDk3
NDVlYjExYTAzYzk3Njc3ODYyOWUxNWY1YTc1MmMwOWMzNDYgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5LTgyZDk3NDVlYjExYTAzYzk3Njc3ODYyOWUxNWY1YTc1MmMw
OWMzNDYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTEwMDEwODE5LzgyZDk3NDVlYjExYTAzYzk3Njc3ODYyOWUxNWY1YTc1MmMwOWMzNDYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94
ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS04MmQ5NzQ1ZWIxMWEwM2M5NzY3Nzg2Mjll
MTVmNWE3NTJjMDljMzQ2ChtbMTszNW0yMDE0LTEwLTAxIDEwOjM1OjQ5IE5vIGJ1aWxkIHNl
cnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5LTgyZDk3NDVlYjExYTAzYzk3Njc3ODYyOWUxNWY1YTc1MmMwOWMzNDYb
WzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTktODJkOTc0NWViMTFhMDNjOTc2Nzc4NjI5ZTE1ZjVhNzUyYzA5YzM0NgprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvODJkOTc0NWViMTFhMDNjOTc2
Nzc4NjI5ZTE1ZjVhNzUyYzA5YzM0Ni92bWxpbnV6LTMuMTcuMC1yYzUtMDAwMzUtZzgyZDk3
NDUKCjIwMTQtMTAtMDEgMTA6Mzc6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTQJMjQJ
MjYJNDAJNTkJNjQgVEVTVCBGQUlMVVJFClsgICAgNy40NTMxNzJdIFVERi1mczogd2Fybmlu
ZyAoZGV2aWNlIHZkZCk6IHVkZl9maWxsX3N1cGVyOiBObyBwYXJ0aXRpb24gZm91bmQgKDIp
ClsgICAgNy40NTU0NTJdIFVERi1mczogd2FybmluZyAoZGV2aWNlIHZkYyk6IHVkZl9maWxs
X3N1cGVyOiBObyBwYXJ0aXRpb24gZm91bmQgKDIpClsgICAgNy40NTcyNzNdIE1vdW50IEpG
UyBGYWlsdXJlOiAtMjIKWyAgICA3LjQ1ODE4MF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtl
cm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQpbICAg
IDcuNDU5MTU1XSBJUDogWzxmZmZmZmZmZjgxMTU5NmQ5Pl0gZHF1b3RfZHJvcCsweDE5LzB4
NDAKWyAgICA3LjQ1OTE1NV0gUEdEIDExMDE5MDY3IFBVRCAxMTMzZDA2NyBQTUQgMCAKWyAg
ICA3LjQ1OTE1NV0gT29wczogMDAwMCBbIzFdIApbICAgIDcuNDU5MTU1XSBDUFU6IDAgUElE
OiAzNzYgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xNy4wLXJjNS0wMDAzNS1nODJkOTc0
NSAjMgpbICAgIDcuNDU5MTU1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAgNy40NTkxNTVdIHRhc2s6IGZmZmY4ODAwMTEyZTgwMTAg
dGk6IGZmZmY4ODAwMTEzZDQwMDAgdGFzay50aTogZmZmZjg4MDAxMTNkNDAwMApbICAgIDcu
NDU5MTU1XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMTU5NmQ5Pl0gIFs8ZmZmZmZmZmY4MTE1
OTZkOT5dIGRxdW90X2Ryb3ArMHgxOS8weDQwClsgICAgNy40NTkxNTVdIFJTUDogMDAxODpm
ZmZmODgwMDExM2Q3ZDEwICBFRkxBR1M6IDAwMDEwMjQ2ClsgICAgNy40NTkxNTVdIFJBWDog
MDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTJhMjBiMjggUkNYOiAwMDAwMDAwMDAw
MDAwMDM3ClsgICAgNy40NTkxNTVdIFJEWDogMDAwMDAwMDA4MDAwMDAwMCBSU0k6IDAwMDAw
MDAwMDAwMDAxZjAgUkRJOiBmZmZmODgwMDEyYTIwYjI4ClsgICAgNy40NTkxNTVdIFJCUDog
ZmZmZjg4MDAxMTNkN2QxMCBSMDg6IDAwMDAwMDAwNTQyYjY5ZmQgUjA5OiAwMDAwMDAwMDAw
MDAwM2M0ClsgICAgNy40NTkxNTVdIFIxMDogMDAwMDAwMDAwMDAwMDAwMyBSMTE6IDAwMDAw
MDAwMDAwMDAzYzQgUjEyOiBmZmZmZmZmZjgxZWJkZDgwClsgICAgNy40NTkxNTVdIFIxMzog
ZmZmZmZmZmY4MWViZGQ4MCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDEgUjE1OiBmZmZmODgwMDEy
ODAzMDQwClsgICAgNy40NTkxNTVdIEZTOiAgMDAwMDdmMzc5NjU3YjcwMCgwMDAwKSBHUzpm
ZmZmZmZmZjgyNDIxMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICA3LjQ1
OTE1NV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAz
YgpbICAgIDcuNDU5MTU1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDEw
YzMxMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMApbICAgIDcuNDU5MTU1XSBTdGFjazoKWyAg
ICA3LjQ1OTE1NV0gIGZmZmY4ODAwMTEzZDdkMjggZmZmZmZmZmY4MTI2NzE3NCBmZmZmODgw
MDEyYTIwYjI4IGZmZmY4ODAwMTEzZDdkNDgKWyAgICA3LjQ1OTE1NV0gIGZmZmZmZmZmODEx
MjAzNTQgZmZmZjg4MDAxMmEyMGIyOCBmZmZmODgwMDExMDQyNDAwIGZmZmY4ODAwMTEzZDdk
NzAKWyAgICA3LjQ1OTE1NV0gIGZmZmZmZmZmODExMjEwNTQgZmZmZjg4MDAxMTA0MjQwMCBm
ZmZmODgwMDExNGUzMTAwIDAwMDAwMDAwZmZmZmZmZWEKWyAgICA3LjQ1OTE1NV0gQ2FsbCBU
cmFjZToKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTI2NzE3ND5dIGpmc19ldmljdF9p
bm9kZSsweDQ0LzB4YjAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEyMDM1ND5dIGV2
aWN0KzB4YTQvMHgxNzAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEyMTA1ND5dIGlw
dXQrMHhlNC8weDE4MApbICAgIDcuNDU5MTU1XSAgWzxmZmZmZmZmZjgxMjY2MmY5Pl0gamZz
X2ZpbGxfc3VwZXIrMHgxYjkvMHgzODAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEw
YjVkOT5dIG1vdW50X2JkZXYrMHgxODkvMHgxYzAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZm
ZmY4MTI2NjE0MD5dID8gamZzX3JlbW91bnQrMHgxYjAvMHgxYjAKWyAgICA3LjQ1OTE1NV0g
IFs8ZmZmZmZmZmY4MTQ0OWU5Mj5dID8gaWRhX2dldF9uZXdfYWJvdmUrMHgxZTIvMHgyMjAK
WyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTI2NTMwMD5dIGpmc19kb19tb3VudCsweDEw
LzB4MjAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEwYjgxMz5dIG1vdW50X2ZzKzB4
MzMvMHgxYzAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEyNGQ4Nj5dIHZmc19rZXJu
X21vdW50KzB4NjYvMHgxMTAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZmZmY4MTEyNmI0Mz5d
IGRvX21vdW50KzB4MjQzLzB4YWQwClsgICAgNy40NTkxNTVdICBbPGZmZmZmZmZmODEwZTRm
MjM+XSA/IHN0cm5kdXBfdXNlcisweDQzLzB4NjAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZmZmZm
ZmY4MTEyNzc4MD5dIFN5U19tb3VudCsweDgwLzB4YzAKWyAgICA3LjQ1OTE1NV0gIFs8ZmZm
ZmZmZmY4MWMwNWYzMD5dIHRyYWNlc3lzKzB4Y2YvMHhkNApbICAgIDcuNDU5MTU1XSBDb2Rl
OiAwMCAwMCA1NSBiZSBmZiBmZiBmZiBmZiA0OCA4OSBlNSBlOCAyMiBmNCBmZiBmZiA1ZCBj
MyBmNiA0NyAwYyAyMCA1NSA0OCA4OSBlNSA3NSAyMyA0OCA4YiA0NyAyOCA0OCA2MyA4MCA1
MCAwMiAwMCAwMCA4NSBjMCA3NSAxNyA8NDg+IDgzIDNjIDI1IDAwIDAwIDAwIDAwIDAwIDc1
IDE1IDMxIGMwIDQ4IDgzIDc4IDA4IDAwIDc1IDBjIDVkIApbICAgIDcuNDU5MTU1XSBSSVAg
IFs8ZmZmZmZmZmY4MTE1OTZkOT5dIGRxdW90X2Ryb3ArMHgxOS8weDQwClsgICAgNy40NTkx
NTVdICBSU1AgPGZmZmY4ODAwMTEzZDdkMTA+ClsgICAgNy40NTkxNTVdIENSMjogMDAwMDAw
MDAwMDAwMDAwMApbICAgIDcuNTIwMTE4XSAtLS1bIGVuZCB0cmFjZSAxMzlmMjdkNzZlOWUy
M2Q0IF0tLS0KWyAgICA3LjUyMTE3MF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5Lzgy
ZDk3NDVlYjExYTAzYzk3Njc3ODYyOWUxNWY1YTc1MmMwOWMzNDYvZG1lc2cteW9jdG8tdnAt
MTM6MjAxNDEwMDExMDQyMTM6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4w
LXJjNS0wMDAzNS1nODJkOTc0NToyCjY0OjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0xMC0wMSAxMDo0MjoyNSBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAvYy9i
b290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzog
MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykK
W2YxYjQ0OTY5MTBjNzMwZjc5MzhiNjc3N2E2MTA1NzYyNzVhM2JiMzFdIHJlaXNlcmZzOiBD
b252ZXJ0IHRvIHByaXZhdGUgaV9kcXVvdCBmaWVsZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEw
NTpmMWI0NDk2OTEwYzczMGY3OTM4YjY3NzdhNjEwNTc2Mjc1YTNiYjMxOmJpc2VjdC1saW51
eC0yCgoyMDE0LTEwLTAxIDEwOjQyOjI2IGYxYjQ0OTY5MTBjNzMwZjc5MzhiNjc3N2E2MTA1
NzYyNzVhM2JiMzEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWYxYjQ0
OTY5MTBjNzMwZjc5MzhiNjc3N2E2MTA1NzYyNzVhM2JiMzEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2YxYjQ0OTY5MTBjNzMw
Zjc5MzhiNjc3N2E2MTA1NzYyNzVhM2JiMzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAx
MDgxOS1mMWI0NDk2OTEwYzczMGY3OTM4YjY3NzdhNjEwNTc2Mjc1YTNiYjMxChtbMTszNW0y
MDE0LTEwLTAxIDEwOjQ3OjI2IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMv
YnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWYxYjQ0OTY5MTBj
NzMwZjc5MzhiNjc3N2E2MTA1NzYyNzVhM2JiMzEbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21v
a2UveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktZjFiNDQ5NjkxMGM3MzBmNzkzOGI2
Nzc3YTYxMDU3NjI3NWEzYmIzMQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMTAwMTA4MTkvZjFiNDQ5NjkxMGM3MzBmNzkzOGI2Nzc3YTYxMDU3NjI3NWEzYmIzMS92
bWxpbnV6LTMuMTcuMC1yYzUtMDAwMzQtZ2YxYjQ0OTYKCjIwMTQtMTAtMDEgMTA6NDk6MjYg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTQJMjAJMjcJNTEJNTQJOTgJMTEyCTExMwkxNTAJ
MTg3CTIwMAkyMzcJMjU2CTI4NAkzMDAgU1VDQ0VTUwoKODJkOTc0NWViMTFhMDNjOTc2Nzc4
NjI5ZTE1ZjVhNzUyYzA5YzM0NiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgODJk
OTc0NWViMTFhMDNjOTc2Nzc4NjI5ZTE1ZjVhNzUyYzA5YzM0NgpBdXRob3I6IEphbiBLYXJh
IDxqYWNrQHN1c2UuY3o+CkRhdGU6ICAgTW9uIFNlcCAyOSAxNToxMDoyNiAyMDE0ICswMjAw
CgogICAgdmZzOiBSZW1vdmUgaV9kcXVvdCBmaWVsZCBmcm9tIGlub2RlCiAgICAKICAgIEFs
bCBmaWxlc3lzdGVtcyB1c2luZyBWRlMgcXVvdGFzIGFyZSBub3cgY29udmVydGVkIHRvIHVz
ZSB0aGVpciBwcml2YXRlCiAgICBpX2RxdW90IGZpZWxkcy4gUmVtb3ZlIHRoZSBpX2RxdW90
IGZpZWxkIGZyb20gZ2VuZXJpYyBpbm9kZSBzdHJ1Y3R1cmUuCiAgICAKICAgIFNpZ25lZC1v
ZmYtYnk6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+Cgo6MDQwMDAwIDA0MDAwMCA5ZTgwNDc0
MjMzZTk0ZmUyNWM2NGM3MzNjODljYmZmZTdlNDUxMzU5IDE3NWFlMTA1OTQ4YTUxNTkzYWJk
NjQxNzJjYjc1NTMwNGIzNWU3MDEgTQlmcwo6MDQwMDAwIDA0MDAwMCBhMjJiMzMzZDI5MzZk
N2E2NzQ0MWVkODM4N2M4YTQxODdkZjAwOWY3IDYzNjVmMmZlOTcwMTZjYTEzOGRkMTY2MmU5
ZGE2NjAxN2Y4MDBhNWYgTQlpbmNsdWRlCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5v
dyBhdCBmMWI0NDk2Li4uIHJlaXNlcmZzOiBDb252ZXJ0IHRvIHByaXZhdGUgaV9kcXVvdCBm
aWVsZApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTkvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDU6ZjFi
NDQ5NjkxMGM3MzBmNzkzOGI2Nzc3YTYxMDU3NjI3NWEzYmIzMTpiaXNlY3QtbGludXgtMgoK
MjAxNC0xMC0wMSAxMDo1ODozNiBmMWI0NDk2OTEwYzczMGY3OTM4YjY3NzdhNjEwNTc2Mjc1
YTNiYjMxIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvZjFi
NDQ5NjkxMGM3MzBmNzkzOGI2Nzc3YTYxMDU3NjI3NWEzYmIzMS92bWxpbnV6LTMuMTcuMC1y
YzUtMDAwMzQtZ2YxYjQ0OTYKCjIwMTQtMTAtMDEgMTA6NTg6MzYgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4JMzAzCTM1Ny4JMzk5CTQzMAk0MzIJNDczCTQ4Nwk1MTAJNTU0CTU1OAk1OTUJ
NjMxCTYzOQk2NTYJNzAzCTcyMgk3NDEJNzg0CTgwNwk4MTIJODY3CTg5Mgk4OTMJOTAwIFNV
Q0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGYxYjQ0OTYuLi4gcmVpc2VyZnM6
IENvbnZlcnQgdG8gcHJpdmF0ZSBpX2RxdW90IGZpZWxkCkhFQUQgaXMgbm93IGF0IGI3ZGM5
NTkuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQxMDAxMDUnCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0x
MDAxMDgxOS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDEwNTpiN2RjOTU5ZTk4
MDZhNDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwOmJpc2VjdC1saW51eC0yCiBURVNUIEZB
SUxVUkUKWyAgICA2Ljc2ODM1NV0gVURGLWZzOiB3YXJuaW5nIChkZXZpY2UgdmRlKTogdWRm
X2ZpbGxfc3VwZXI6IE5vIHBhcnRpdGlvbiBmb3VuZCAoMikKWyAgICA2Ljc3MDY0OV0gVURG
LWZzOiB3YXJuaW5nIChkZXZpY2UgdmRiKTogdWRmX2ZpbGxfc3VwZXI6IE5vIHBhcnRpdGlv
biBmb3VuZCAoMikKWyAgICA2Ljc3MjU5OF0gTW91bnQgSkZTIEZhaWx1cmU6IC0yMgpbICAg
IDYuNzczNzA2XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBk
ZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgNi43NzQ2NTVdIElQOiBbPGZm
ZmZmZmZmODExNTk2Zjk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNzc0NjU1XSBQ
R0QgMTExMjcwNjcgUFVEIDEwYzA5MDY3IFBNRCAwIApbICAgIDYuNzc0NjU1XSBPb3BzOiAw
MDAwIFsjMV0gClsgICAgNi43NzQ2NTVdIENQVTogMCBQSUQ6IDM3OSBDb21tOiBtb3VudCBO
b3QgdGFpbnRlZCAzLjE3LjAtcmM3LTAxNDEwLWdiN2RjOTU5ICMyOTAKWyAgICA2Ljc3NDY1
NV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDYuNzc0NjU1XSB0YXNrOiBmZmZmODgwMDExMzVhNjYwIHRpOiBmZmZmODgwMDEwYzZj
MDAwIHRhc2sudGk6IGZmZmY4ODAwMTBjNmMwMDAKWyAgICA2Ljc3NDY1NV0gUklQOiAwMDEw
Ols8ZmZmZmZmZmY4MTE1OTZmOT5dICBbPGZmZmZmZmZmODExNTk2Zjk+XSBkcXVvdF9kcm9w
KzB4MTkvMHg0MApbICAgIDYuNzc0NjU1XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMGM2ZmQxMCAg
RUZMQUdTOiAwMDAxMDI0NgpbICAgIDYuNzc0NjU1XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAg
UkJYOiBmZmZmODgwMDEyYTFlYjI4IFJDWDogMDAwMDAwMDE5M2JlNjc0NwpbICAgIDYuNzc0
NjU1XSBSRFg6IDAwMDAwMDAxOTNiZTY4NGYgUlNJOiBmZmZmODgwMDExMzVhNjYwIFJESTog
ZmZmZjg4MDAxMmExZWIyOApbICAgIDYuNzc0NjU1XSBSQlA6IGZmZmY4ODAwMTBjNmZkMTAg
UjA4OiAwMDAwMDAwMDAwMDAwMWNhIFIwOTogZmZmZjg4MDAxMTA3NDA0OApbICAgIDYuNzc0
NjU1XSBSMTA6IDAwMDAwMDAwMDAwMDAxNjggUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjog
ZmZmZmZmZmY4MWViZGMwMApbICAgIDYuNzc0NjU1XSBSMTM6IGZmZmZmZmZmODFlYmRjMDAg
UjE0OiAwMDAwMDAwMDAwMDAwMDAxIFIxNTogZmZmZjg4MDAxMjgwMzA0MApbICAgIDYuNzc0
NjU1XSBGUzogIDAwMDA3ZmViMDZiZjY3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MjQyMTAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgNi43NzQ2NTVdIENTOiAgMDAxMCBE
UzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICA2Ljc3NDY1NV0g
Q1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAxMTE4NDAwMCBDUjQ6IDAwMDAw
MDAwMDAwMDA2ZjAKWyAgICA2Ljc3NDY1NV0gU3RhY2s6ClsgICAgNi43NzQ2NTVdICBmZmZm
ODgwMDEwYzZmZDI4IGZmZmZmZmZmODEyNjczYjQgZmZmZjg4MDAxMmExZWIyOCBmZmZmODgw
MDEwYzZmZDQ4ClsgICAgNi43NzQ2NTVdICBmZmZmZmZmZjgxMTIwNDA0IGZmZmY4ODAwMTJh
MWViMjggZmZmZjg4MDAxMTNmMTgwMCBmZmZmODgwMDEwYzZmZDcwClsgICAgNi43NzQ2NTVd
ICBmZmZmZmZmZjgxMTIxMTA0IGZmZmY4ODAwMTEzZjE4MDAgZmZmZjg4MDAxMTRlNDEwMCAw
MDAwMDAwMGZmZmZmZmVhClsgICAgNi43NzQ2NTVdIENhbGwgVHJhY2U6ClsgICAgNi43NzQ2
NTVdICBbPGZmZmZmZmZmODEyNjczYjQ+XSBqZnNfZXZpY3RfaW5vZGUrMHg0NC8weGIwClsg
ICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODExMjA0MDQ+XSBldmljdCsweGE0LzB4MTcwClsg
ICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODExMjExMDQ+XSBpcHV0KzB4ZTQvMHgxODAKWyAg
ICA2Ljc3NDY1NV0gIFs8ZmZmZmZmZmY4MTI2NjUzOT5dIGpmc19maWxsX3N1cGVyKzB4MWI5
LzB4MzgwClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODExMGI3Yzk+XSBtb3VudF9iZGV2
KzB4MTg5LzB4MWMwClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODEyNjYzODA+XSA/IGpm
c19yZW1vdW50KzB4MWIwLzB4MWIwClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODE0NGE3
OTI+XSA/IGlkYV9nZXRfbmV3X2Fib3ZlKzB4MWUyLzB4MjIwClsgICAgNi43NzQ2NTVdICBb
PGZmZmZmZmZmODEyNjU1NDA+XSBqZnNfZG9fbW91bnQrMHgxMC8weDIwClsgICAgNi43NzQ2
NTVdICBbPGZmZmZmZmZmODExMGJhMDM+XSBtb3VudF9mcysweDMzLzB4MWMwClsgICAgNi43
NzQ2NTVdICBbPGZmZmZmZmZmODExMjRlMzY+XSB2ZnNfa2Vybl9tb3VudCsweDY2LzB4MTEw
ClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODExMjZiZjM+XSBkb19tb3VudCsweDI0My8w
eGFkMApbICAgIDYuNzc0NjU1XSAgWzxmZmZmZmZmZjgxMGU1MTEzPl0gPyBzdHJuZHVwX3Vz
ZXIrMHg0My8weDYwClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODExMjc4MzA+XSBTeVNf
bW91bnQrMHg4MC8weGMwClsgICAgNi43NzQ2NTVdICBbPGZmZmZmZmZmODFjMDJlMzA+XSB0
cmFjZXN5cysweGNmLzB4ZDQKWyAgICA2Ljc3NDY1NV0gQ29kZTogMDAgMDAgNTUgYmUgZmYg
ZmYgZmYgZmYgNDggODkgZTUgZTggMjIgZjQgZmYgZmYgNWQgYzMgZjYgNDcgMGMgMjAgNTUg
NDggODkgZTUgNzUgMjMgNDggOGIgNDcgMjggNDggNjMgODAgNTAgMDIgMDAgMDAgODUgYzAg
NzUgMTcgPDQ4PiA4MyAzYyAyNSAwMCAwMCAwMCAwMCAwMCA3NSAxNSAzMSBjMCA0OCA4MyA3
OCAwOCAwMCA3NSAwYyA1ZCAKWyAgICA2Ljc3NDY1NV0gUklQICBbPGZmZmZmZmZmODExNTk2
Zjk+XSBkcXVvdF9kcm9wKzB4MTkvMHg0MApbICAgIDYuNzc0NjU1XSAgUlNQIDxmZmZmODgw
MDEwYzZmZDEwPgpbICAgIDYuNzc0NjU1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA2
Ljg0MjUzN10gLS0tWyBlbmQgdHJhY2UgY2Y2NGRkOTYyMGM4MDhhZCBdLS0tClsgICAgNi44
NDM2OThdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9iN2RjOTU5ZTk4MDZhNDMyNzQy
ZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwL2RtZXNnLXlvY3RvLXZwLTYxOjIwMTQxMDAxMDg1MzU5
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDE0MTAtZ2I3ZGM5
NTk6MjkwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYjdkYzk1OWU5
ODA2YTQzMjc0MmYzYjAyODFkZGNiMmI4MTVkNWVlMC9kbWVzZy15b2N0by12cC0yMzoyMDE0
MTAwMTA4NTM1OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAx
NDEwLWdiN2RjOTU5OjI5MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5
L2I3ZGM5NTllOTgwNmE0MzI3NDJmM2IwMjgxZGRjYjJiODE1ZDVlZTAvZG1lc2cteW9jdG8t
dnAtNTg6MjAxNDEwMDEwODU0MDE6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4x
Ny4wLXJjNy0wMTQxMC1nYjdkYzk1OToyOTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0xMDAxMDgxOS9iN2RjOTU5ZTk4MDZhNDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwL2Rt
ZXNnLXlvY3RvLXZwLTMwOjIwMTQxMDAxMDg1NDAxOng4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5OjMuMTcuMC1yYzctMDE0MTAtZ2I3ZGM5NTk6MjkwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMTAwMTA4MTkvYjdkYzk1OWU5ODA2YTQzMjc0MmYzYjAyODFkZGNiMmI4
MTVkNWVlMC9kbWVzZy15b2N0by12cC0yMDoyMDE0MTAwMTA4NTM1OTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAxNDEwLWdiN2RjOTU5OjI5MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5L2I3ZGM5NTllOTgwNmE0MzI3NDJmM2Iw
MjgxZGRjYjJiODE1ZDVlZTAvZG1lc2cteW9jdG8tdnAtMjg6MjAxNDEwMDEwODQzMTQ6eDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTk6My4xNy4wLXJjNy0wMTQxMC1nYjdkYzk1OToy
OTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS9iN2RjOTU5ZTk4MDZh
NDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1ZWUwL2RtZXNnLXlvY3RvLXZwLTQ3OjIwMTQxMDAx
MDg1NDAxOng4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDE0MTAt
Z2I3ZGM5NTk6MjkwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYjdk
Yzk1OWU5ODA2YTQzMjc0MmYzYjAyODFkZGNiMmI4MTVkNWVlMC9kbWVzZy15b2N0by12cC00
NDoyMDE0MTAwMTA4NTQwMTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAt
cmM3LTAxNDEwLWdiN2RjOTU5OjI5MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEw
MDEwODE5L2I3ZGM5NTllOTgwNmE0MzI3NDJmM2IwMjgxZGRjYjJiODE1ZDVlZTAvZG1lc2ct
eW9jdG8tdnAtNTA6MjAxNDEwMDEwODUzNTk6eDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTk6My4xNy4wLXJjNy0wMTQxMC1nYjdkYzk1OToyOTAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0xMDAxMDgxOS9iN2RjOTU5ZTk4MDZhNDMyNzQyZjNiMDI4MWRkY2IyYjgxNWQ1
ZWUwL2RtZXNnLXlvY3RvLXZwLTU3OjIwMTQxMDAxMDg1MzU5Ong4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5OjMuMTcuMC1yYzctMDE0MTAtZ2I3ZGM5NTk6MjkwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYjdkYzk1OWU5ODA2YTQzMjc0MmYzYjAyODFk
ZGNiMmI4MTVkNWVlMC9kbWVzZy15b2N0by12cC0zNDoyMDE0MTAwMTA4NTM1OTp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0xMDAxMDgxOTozLjE3LjAtcmM3LTAxNDEwLWdiN2RjOTU5OjI5MAoy
MToxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgYjdk
Yzk1OSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDEwMDEwNScKCj09
PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL2xp
bnVzCiAgIGZlODJkY2UuLmFhZDdmYjkgIG1hc3RlciAgICAgLT4gbGludXMvbWFzdGVyCk5v
dGU6IGNoZWNraW5nIG91dCAnbGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVk
IEhFQUQnIHN0YXRlLiBZb3UgY2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApj
aGFuZ2VzIGFuZCBjb21taXQgdGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0
cyB5b3UgbWFrZSBpbiB0aGlzCnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hl
cyBieSBwZXJmb3JtaW5nIGFub3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVh
dGUgYSBuZXcgYnJhbmNoIHRvIHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkK
ZG8gc28gKG5vdyBvciBsYXRlcikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29t
bWFuZCBhZ2Fpbi4gRXhhbXBsZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFt
ZQoKSEVBRCBpcyBub3cgYXQgYWFkN2ZiOS4uLiBNZXJnZSBicmFuY2ggJ2ZpeGVzJyBvZiBn
aXQ6Ly9mdHAuYXJtLmxpbnV4Lm9yZy51ay9+cm1rL2xpbnV4LWFybQpscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvbGlu
dXM6bWFzdGVyOmFhZDdmYjkxNmExMGYxMDY1YWQyM2RlMGM4MGE0YTA0YmNiYTg0Mzc6Ymlz
ZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDEgMTE6MTI6MzIgYWFkN2ZiOTE2YTEwZjEwNjVhZDIz
ZGUwYzgwYTRhMDRiY2JhODQzNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4
MTktYWFkN2ZiOTE2YTEwZjEwNjVhZDIzZGUwYzgwYTRhMDRiY2JhODQzNwpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTkvYWFkN2Zi
OTE2YTEwZjEwNjVhZDIzZGUwYzgwYTRhMDRiY2JhODQzNwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmln
LXMwLTEwMDEwODE5LWFhZDdmYjkxNmExMGYxMDY1YWQyM2RlMGM4MGE0YTA0YmNiYTg0MzcK
G1sxOzM1bTIwMTQtMTAtMDEgMTE6MjI6MzIgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWls
ZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctczAtMTAwMTA4MTktYWFk
N2ZiOTE2YTEwZjEwNjVhZDIzZGUwYzgwYTRhMDRiY2JhODQzNxtbMG0KUmV0cnkgYnVpbGQg
Li4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0xMDAxMDgxOS1hYWQ3ZmI5MTZhMTBm
MTA2NWFkMjNkZTBjODBhNGEwNGJjYmE4NDM3Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0xMDAxMDgxOS9hYWQ3ZmI5MTZhMTBmMTA2NWFkMjNkZTBjODBhNGEwNGJj
YmE4NDM3L3ZtbGludXotMy4xNy4wLXJjNy0wMDAwNi1nYWFkN2ZiOQoKMjAxNC0xMC0wMSAx
MToyNTozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTM5Lgk0Mgk0NQk1MAk3Nwk3OS4JMTA4
CTEyMQkxMjgJMTg1CTE5MQkyMjAJMjQxCTI1NQkyODkJMzAxCTMxNwkzMjQJMzI1CTM4Nwkz
ODgJNDAzCTQ0Mgk0NDcJNDU1CTUwNwk1MTYJNTMwCTU4MC4JNTg4CTYxMAk2NDEuCTY3NAk2
OTEJNjk2CTczNS4JNzUyCTc2MQk3ODgJODMwCTgzOAk4NTkJODg3CTkwMCBTVUNDRVNTCgoK
PT09PT09PT09IG5leHQvbWFzdGVyID09PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9u
ZXh0CiArIDRmMzdhZjEuLi4zN2VhZGUxIGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9y
Y2VkIHVwZGF0ZSkKICsgYTI1YzFkOC4uLjg1YzcwZmYgYWtwbS1iYXNlICAtPiBuZXh0L2Fr
cG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIDRkODQyNmYuLi5jYjRiMTZjIG1hc3RlciAg
ICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQogICBmNGNiNzA3Li5mZTgyZGNl
ICBzdGFibGUgICAgIC0+IG5leHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDkzMCAtPiBuZXh0LTIwMTQwOTMwClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGFhZDdmYjkuLi4gTWVyZ2UgYnJhbmNoICdmaXhl
cycgb2YgZ2l0Oi8vZnRwLmFybS5saW51eC5vcmcudWsvfnJtay9saW51eC1hcm0KSEVBRCBp
cyBub3cgYXQgY2I0YjE2Yy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3Ig
MjAxNDA5MzAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTEwMDEwODE5L25leHQ6bWFzdGVyOmNiNGIxNmNhYThhNThlZTU5M2MyMmYw
ODc2ZjlkOTIxZjEwY2QyMzc6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDEgMTE6NTE6MjYg
Y2I0YjE2Y2FhOGE1OGVlNTkzYzIyZjA4NzZmOWQ5MjFmMTBjZDIzNyBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0
LXJhbmRjb25maWctczAtMTAwMTA4MTktY2I0YjE2Y2FhOGE1OGVlNTkzYzIyZjA4NzZmOWQ5
MjFmMTBjZDIzNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMTAwMTA4MTkvY2I0YjE2Y2FhOGE1OGVlNTkzYzIyZjA4NzZmOWQ5MjFmMTBjZDIz
Nwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
c25iL3g4Nl82NC1yYW5kY29uZmlnLXMwLTEwMDEwODE5LWNiNGIxNmNhYThhNThlZTU5M2My
MmYwODc2ZjlkOTIxZjEwY2QyMzcKG1sxOzM1bTIwMTQtMTAtMDEgMTE6NTM6MjYgTm8gYnVp
bGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRj
b25maWctczAtMTAwMTA4MTktY2I0YjE2Y2FhOGE1OGVlNTkzYzIyZjA4NzZmOWQ5MjFmMTBj
ZDIzNxtbMG0KUmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTEwMDEwODE5L2NiNGIxNmNhYThhNThlZTU5M2MyMmYwODc2ZjlkOTIxZjEwY2Qy
Mzcvdm1saW51ei0zLjE3LjAtcmM3LW5leHQtMjAxNDA5MzAKCjIwMTQtMTAtMDEgMTE6NTQ6
MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgk0Mgk0OQkxMTEJMTM4CTE1OAkyMzkJMjkx
CTMyNgk0NDAJNTI3CTU3Mgk3MDcJNzkyCTg5Mwk5MDAgU1VDQ0VTUwoK

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc5-00035-g82d9745"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc5 Kernel Configuration
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
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
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
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
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
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
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
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
# CONFIG_NFC_TRF7970A is not set
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PORT100=y
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=y
CONFIG_NFC_MICROREAD_I2C=y
CONFIG_NFC_ST21NFCA=y
CONFIG_NFC_ST21NFCA_I2C=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set

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
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_USB_NET_DRIVERS is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_PRISM54=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
# CONFIG_HOSTAP_CS is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_ISDN is not set

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
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

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
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

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

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_CRYSTAL_COVE=y
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

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
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

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
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=y
CONFIG_IR_MCEUSB=y
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
CONFIG_IR_TTUSBIR=y
CONFIG_IR_IMG=y
# CONFIG_IR_IMG_RAW is not set
CONFIG_IR_IMG_HW=y
CONFIG_IR_IMG_NEC=y
CONFIG_IR_IMG_JVC=y
# CONFIG_IR_IMG_SONY is not set
# CONFIG_IR_IMG_SHARP is not set
CONFIG_IR_IMG_SANYO=y
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_GPIO_CIR is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
CONFIG_VIDEO_W9966=y

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AW2=y
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=y
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=y
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=y
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_SPI=y
# CONFIG_SND_USB is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_ATMEL_SOC is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
CONFIG_SND_SOC_FSL_SAI=y
CONFIG_SND_SOC_FSL_SSI=y
# CONFIG_SND_SOC_FSL_SPDIF is not set
CONFIG_SND_SOC_FSL_ESAI=y
CONFIG_SND_SOC_IMX_AUDMUX=y
# CONFIG_SND_SOC_INTEL_SST is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
# CONFIG_SND_SOC_AK4104 is not set
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4642=y
# CONFIG_SND_SOC_AK5386 is not set
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L56=y
# CONFIG_SND_SOC_CS42L73 is not set
CONFIG_SND_SOC_CS4265=y
CONFIG_SND_SOC_CS4270=y
# CONFIG_SND_SOC_CS4271 is not set
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
# CONFIG_SND_SOC_HDMI_CODEC is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1792A is not set
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
# CONFIG_SND_SOC_PCM512x_SPI is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_STA350=y
# CONFIG_SND_SOC_TAS2552 is not set
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_WM8510=y
# CONFIG_SND_SOC_WM8523 is not set
CONFIG_SND_SOC_WM8580=y
# CONFIG_SND_SOC_WM8711 is not set
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
# CONFIG_SOUND_MSS is not set
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
CONFIG_PAS_JOYSTICK=y
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=y
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
# CONFIG_SC6600_JOY is not set
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_AC97_BUS=y

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
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
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
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
# CONFIG_USBIP_HOST is not set
CONFIG_USBIP_DEBUG=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
CONFIG_USB_MUSB_GADGET=y
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_PCI is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_LINK_LAYER_TEST=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_MASS_STORAGE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=y
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
# CONFIG_MEMSTICK_REALTEK_USB is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_IE31200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MIC_X100_DMA is not set
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
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
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
# CONFIG_PWM_LPSS is not set
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
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_ST_SPEAR1310_MIPHY is not set
# CONFIG_PHY_ST_SPEAR1340_MIPHY is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
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
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
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
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
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
# CONFIG_KMEMCHECK is not set
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
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_STACKTRACE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
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
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
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
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
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
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_PKCS7_TEST_KEY=y
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--rwEMma7ioTxnRzrJ--
