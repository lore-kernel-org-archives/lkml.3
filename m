Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaCWHGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 03:06:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:8765 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaCWHGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 03:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,713,1389772800"; 
   d="log'?scan'208";a="497711809"
Date: Sun, 23 Mar 2014 15:05:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joern Engel <joern@logfs.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [logfs] BUG: unable to handle kernel NULL pointer dereference at
           (null)
Message-ID: <20140323070553.GB14679@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20140316131757.GA8972@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joshi,

FYI, this commit seems to trigger the logfs bug earlier.

commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed Mar 6 20:18:21 2013 -0800
Commit:     H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed Mar 6 20:18:32 2013 -0800

    x86, mm: Make sure to find a 2M free block for the first mapped area
    [snip]
    Reported-by: Henrik Rydberg <rydberg@euromail.se>
    Bisected-by: Henrik Rydberg <rydberg@euromail.se>
    Tested-by: Henrik Rydberg <rydberg@euromail.se>
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Link: http://lkml.kernel.org/r/CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+-----------------------------------------------------------------------------+------------+------------+---------------+
|                                                                             | 015221fefb | 98e7a98997 | next-20140321 |
+-----------------------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                                              | 35         | 6          | 7             |
| boot_failures                                                               | 73         | 21         | 12            |
| BUG:unable_to_handle_kernel_paging_request                                  | 73         |            |               |
| Oops                                                                        | 73         | 21         | 12            |
| RIP:perf_swevent_init                                                       | 9          |            |               |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/rwsem.c         | 9          | 21         |               |
| backtrace:perf_swevent_init                                                 | 9          |            |               |
| backtrace:perf_init_event                                                   | 9          |            |               |
| backtrace:async_page_fault                                                  | 9          |            |               |
| RIP:__alloc_memory_core_early                                               | 64         |            |               |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task                    | 64         |            |               |
| backtrace:__alloc_bootmem                                                   | 64         |            |               |
| backtrace:sparse_init                                                       | 64         |            |               |
| backtrace:paging_init                                                       | 64         |            |               |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 0          | 21         | 12            |
| RIP:__mutex_lock_slowpath                                                   | 0          | 21         | 12            |
| BUG:scheduling_while_atomic                                                 | 0          | 21         |               |
| BUG:sleeping_function_called_from_invalid_context_at_mm/memory.c            | 0          | 6          |               |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 0          | 12            |
| backtrace:do_mount                                                          | 0          | 0          | 12            |
| backtrace:SyS_mount                                                         | 0          | 0          | 12            |
+-----------------------------------------------------------------------------+------------+------------+---------------+

[    0.931658] LogFS: Start unmounting
[    0.932279] LogFS: Start mount 1
[    0.932857] LogFS: Start unmounting
[    0.933482] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.934337] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    0.934337] PGD 11e41067 PUD 1183f067 PMD 0 
[    0.934337] Oops: 0002 [#1] 
[    0.934337] Modules linked in:
[    0.934337] CPU: 0 PID: 498 Comm: mount Not tainted 3.14.0-rc7-next-20140321 #10
[    0.934337] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.934337] task: ffff8800007c3a80 ti: ffff880011fc8000 task.ti: ffff880011fc8000
[    0.934337] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    0.934337] RSP: 0018:ffff880011fc9d10  EFLAGS: 00010286
[    0.934337] RAX: 0000000000000000 RBX: ffff880011fbbcc0 RCX: 0000000000000002
[    0.934337] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011fbbcc0
[    0.934337] RBP: ffff880011fc9d50 R08: ffff880011fc8000 R09: 0000000000000100
[    0.934337] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011fbbcc8
[    0.934337] R13: ffff8800007c3a80 R14: 00000000ffffffff R15: ffff880011fbb000
[    0.934337] FS:  00007f08f76f8700(0000) GS:ffffffff8181c000(0000) knlGS:0000000000000000
[    0.934337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.934337] CR2: 0000000000000000 CR3: 0000000011847000 CR4: 00000000000006b0
[    0.934337] Stack:
[    0.934337]  ffff880011fbbcc8 0000000000000000 ffff880011fc9d18 0000000000000850
[    0.934337]  ffff880011fbbcc0 ffff880011e8e000 ffff880011fbb000 ffff880013365e00
[    0.934337]  ffff880011fc9d68 ffffffff81497a1d ffff880011e8e000 ffff880011fc9d80
[    0.934337] Call Trace:
[    0.934337]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    0.934337]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    0.934337]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    0.934337]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    0.934337]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    0.934337]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    0.934337]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    0.934337]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    0.934337]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    0.934337]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    0.934337]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    0.934337]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    0.934337]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    0.934337] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 <48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44 
[    0.934337] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    0.934337]  RSP <ffff880011fc9d10>
[    0.934337] CR2: 0000000000000000
[    0.934337] ---[ end trace 5506712fb917b42d ]---
[    0.934337] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20

git bisect start v3.9 v3.8 --
git bisect  bad 20f22ab42e9c832bde6e9a7ed04cdc73ec737e5b  # 09:52      2-      3  signals: fix new kernel-doc warnings
git bisect good bbbd27e694ce2c5fde9c8fcedbea618dd9153fe7  # 10:07     27+     27  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect good bc2e4a90d9f75f1664c1587eb09ecd10bb71b022  # 10:19     27+     19  Merge tag 'usb-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect  bad d381f45c890a3fb136afb0dc1cbe025e066cb981  # 10:37      3-     19  Merge branch 'for-3.9/upstream-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good e3b59518c10e08eeb06215abf06f50e8f83b51dc  # 10:46     27+     18  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good d345243629db38a6340bcb69f372329d35b8f650  # 11:01     27+     19  Merge tag 'regulator-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good af2841cdd4cb35248e41f7427d996c8f6b563051  # 11:12     27+     17  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect  bad 7b54c165a0c012edbaeaa73c5c87cb73721eb580  # 11:31      1-     19  vfs: don't BUG_ON() if following a /proc fd pseudo-symlink results in a symlink
git bisect  bad 47b3bc907328db968bc9b43c41f48f8d1e140750  # 11:47      0-      6  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75  # 12:05      0-      3  x86, doc: Be explicit about what the x86 struct boot_params requires
git bisect good 015221fefbc93689dd47508a66326556adf2abcd  # 12:54     27+     15  x86: Fix 32-bit *_cpu_data initializers
git bisect  bad 2e604c0f19dcdd433b3863ffc3da9bc0787ca765  # 13:21      2-      6  x86: Don't clear efi_info even if the sentinel hits
git bisect  bad 98e7a989979b185f49e86ddaed2ad6890299d9f0  # 13:29      0-      4  x86, mm: Make sure to find a 2M free block for the first mapped area
# first bad commit: [98e7a989979b185f49e86ddaed2ad6890299d9f0] x86, mm: Make sure to find a 2M free block for the first mapped area
git bisect good 015221fefbc93689dd47508a66326556adf2abcd  # 13:38     81+     73  x86: Fix 32-bit *_cpu_data initializers
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 13:39      0-     12  Add linux-next specific files for 20140321
git bisect  bad 774868c7094d35b4518be3d0e654de000a5d11fc  # 13:55      0-      3  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 13:56      0-     12  Add linux-next specific files for 20140321

Thanks,
Fengguang

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-sb04-3:20140323050236:x86_64-randconfig-r2-03230447:3.14.0-rc7-next-20140321:10"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@roam) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #10 Sun Mar 23 05:01:07 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03230447/next:master/=
=2Evmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323050216-7-lkp-sb=
04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r2-03230447/=
06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 d=
rbd.minor_count=3D8
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
[    0.000000] BRK [0x019c1000, 0x019c1fff] PGTABLE
[    0.000000] BRK [0x019c2000, 0x019c2fff] PGTABLE
[    0.000000] BRK [0x019c3000, 0x019c3fff] PGTABLE
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
[    0.000000] BRK [0x019c4000, 0x019c4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
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
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 182a2c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03230447/next:=
master/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323050216-7-l=
kp-sb04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r2-0323=
0447/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140=
321 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 307080K/327280K available (4714K kernel code, 503K r=
wdata, 1792K rodata, 772K init, 512K bss, 20200K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@roam) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #10 Sun Mar 23 05:01:07 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03230447/next:master/=
=2Evmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323050216-7-lkp-sb=
04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r2-03230447/=
06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 d=
rbd.minor_count=3D8
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
[    0.000000] BRK [0x019c1000, 0x019c1fff] PGTABLE
[    0.000000] BRK [0x019c2000, 0x019c2fff] PGTABLE
[    0.000000] BRK [0x019c3000, 0x019c3fff] PGTABLE
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
[    0.000000] BRK [0x019c4000, 0x019c4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
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
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 182a2c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03230447/next:=
master/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323050216-7-l=
kp-sb04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r2-0323=
0447/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140=
321 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 307080K/327280K available (4714K kernel code, 503K r=
wdata, 1792K rodata, 772K init, 512K bss, 20200K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3092.508 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6187.72 Bogo=
MIPS (lpj=3D10308360)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] ACPI: Core revision 20140214
[    0.006865] ACPI: All ACPI Tables successfully acquired
[    0.007610] Mount-cache hash table entries: 256
[    0.008252] Initializing cgroup subsys debug
[    0.008749] Initializing cgroup subsys devices
[    0.009372] Initializing cgroup subsys perf_event
[    0.010004] Initializing cgroup subsys hugetlb
[    0.010679] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010679] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.010679] tlb_flushall_shift: 6
[    0.012541] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.018491] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.019918] Getting VERSION: 50014
[    0.020006] Getting VERSION: 50014
[    0.020535] Getting ID: 0
[    0.020975] Getting ID: ff000000
[    0.021484] Getting LVT0: 8700
[    0.021965] Getting LVT1: 8400
[    0.022495] enabled ExtINT on CPU#0
[    0.023926] ENABLING IO-APIC IRQs
[    0.024442] init IO_APIC IRQs
[    0.024910]  apic 0 pin 0 not connected
[    0.025488] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.026680] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.027769] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.028853] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.030012] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.031091] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.032163] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.033236] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.033345] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.034427] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.035541] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.036678] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.037776] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.038864] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.040011] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.041102]  apic 0 pin 16 not connected
[    0.041661]  apic 0 pin 17 not connected
[    0.042217]  apic 0 pin 18 not connected
[    0.043335]  apic 0 pin 19 not connected
[    0.043893]  apic 0 pin 20 not connected
[    0.044453]  apic 0 pin 21 not connected
[    0.045009]  apic 0 pin 22 not connected
[    0.045570]  apic 0 pin 23 not connected
[    0.046262] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.046668] Using local APIC timer interrupts.
[    0.046668] calibrating APIC timer ...
[    0.049999] ... lapic delta =3D 6249981
[    0.049999] ... PM-Timer delta =3D 357971
[    0.049999] ... PM-Timer result ok
[    0.049999] ..... delta 6249981
[    0.049999] ..... mult: 268434666
[    0.049999] ..... calibration result: 3333323
[    0.049999] ..... CPU clock speed is 3093.0101 MHz.
[    0.049999] ..... host bus clock speed is 1000.0323 MHz.
[    0.050105] devtmpfs: initialized
[    0.051015] xor: measuring software checksum speed
[    0.083335]    prefetch64-sse: 15099.600 MB/sec
[    0.116668]    generic_sse: 14127.600 MB/sec
[    0.117395] xor: using function: prefetch64-sse (15099.600 MB/sec)
[    0.118324] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.119368] regulator-dummy: no parameters
[    0.120043] NET: Registered protocol family 16
[    0.120913] cpuidle: using governor ladder
[    0.121587] cpuidle: using governor menu
[    0.122355] ACPI: bus type PCI registered
[    0.123037] PCI: Using configuration type 1 for base access
[    0.180006] raid6: sse2x1    8635 MB/s
[    0.236668] raid6: sse2x2   10815 MB/s
[    0.293339] raid6: sse2x4   12473 MB/s
[    0.293932] raid6: using algorithm sse2x4 (12473 MB/s)
[    0.294655] raid6: using intx1 recovery algorithm
[    0.295410] ACPI: Added _OSI(Module Device)
[    0.296039] ACPI: Added _OSI(Processor Device)
[    0.296668] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.297359] ACPI: Added _OSI(Processor Aggregator Device)
[    0.299375] ACPI: Interpreter enabled
[    0.299968] ACPI: (supports S0 S5)
[    0.300001] ACPI: Using IOAPIC for interrupt routing
[    0.300791] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.304252] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.305179] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.306006] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.306761] PCI host bridge to bus 0000:00
[    0.307416] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.308250] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.309168] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.310002] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.311000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.312024] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.313579] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.314810] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.317586] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.319181] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.320002] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.320941] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.321967] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.322998] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.323593] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.324750] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.326693] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.329749] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.330920] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.336703] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.337997] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.339613] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.340691] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.345725] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.346784] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.348056] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.351504] pci_bus 0000:00: on NUMA node 0
[    0.352430] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.353693] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.354929] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.356153] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.357267] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.358532] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.359609] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.360001] vgaarb: loaded
[    0.360498] vgaarb: bridge control possible 0000:00:02.0
[    0.361355] ACPI: bus type USB registered
[    0.362044] usbcore: registered new interface driver usbfs
[    0.363353] usbcore: registered new interface driver hub
[    0.364216] usbcore: registered new device driver usb
[    0.365029] pps_core: LinuxPPS API ver. 1 registered
[    0.365796] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.366677] PTP clock support registered
[    0.367333] EDAC MC: Ver: 3.0.0
[    0.368060] PCI: Using ACPI for IRQ routing
[    0.368748] PCI: pci_cache_line_size set to 64 bytes
[    0.370086] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.370978] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.372017] NET: Registered protocol family 8
[    0.373339] NET: Registered protocol family 20
[    0.374187] nfc: nfc_init: NFC Core ver 0.1
[    0.374895] NET: Registered protocol family 39
[    0.375753] Switched to clocksource kvm-clock
[    0.376529] FS-Cache: Loaded
[    0.376529] pnp: PnP ACPI init
[    0.376529] ACPI: bus type PNP registered
[    0.376529] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.377219] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.378210] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.379501] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.380462] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.381759] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.382744] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.384001] pnp 00:03: [dma 2]
[    0.384570] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.385560] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.386838] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.387842] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.389115] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.390167] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.391210] pnp: PnP ACPI: found 7 devices
[    0.391880] ACPI: bus type PNP unregistered
[    0.402985] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.403847] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.404694] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.405611] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.406541] NET: Registered protocol family 1
[    0.407252] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.408158] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.409015] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.409943] pci 0000:00:02.0: Boot video device
[    0.410691] PCI: CLS 0 bytes, default 64
[    0.411392] Unpacking initramfs...
[    0.456191] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.457672] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.459106] AVX or AES-NI instructions are not detected.
[    0.459931] AVX instructions are not detected.
[    0.460650] AVX instructions are not detected.
[    0.461349] AVX instructions are not detected.
[    0.462050] AVX2 instructions are not detected.
[    0.462853] futex hash table entries: 256 (order: 0, 4096 bytes)
[    0.463768] Initialise system trusted keyring
[    0.464500] audit: initializing netlink subsys (disabled)
[    0.465359] audit: type=3D2000 audit(1395522149.363:1): initialized
[    0.466407] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.469833] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    0.471864] QNX4 filesystem 0.2.3 registered.
[    0.472584] fuse init (API version 7.22)
[    0.473369] befs: version: 0.9.3
[    0.473993] msgmni has been set to 605
[    0.474946] NET: Registered protocol family 38
[    0.475675] Key type asymmetric registered
[    0.476345] Asymmetric key parser 'x509' registered
[    0.477144] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.478344] io scheduler noop registered (default)
[    0.479174] ipmi message handler version 39.2
[    0.479874] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    0.481177] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.482357] ACPI: Power Button [PWRF]
[    0.483129] r3964: Philips r3964 Driver $Revision: 1.10 $
[    0.483947] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.506460] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.507878] STMicroelectronics ASC driver initialized
[    0.508686] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.509457] smapi::smapi_init, ERROR invalid usSmapiID
[    0.510245] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    0.511662] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    0.512813] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    0.513825] nbd: registered device at major 43
[    0.515347]  nullb0: unknown partition table
[    0.516162]  nullb1: unknown partition table
[    0.516891] null: module loaded
[    0.517467] mic_init not running on X100 ret -19
[    0.518224] usbcore: registered new interface driver rtsx_usb
[    0.519141] SSFDC read-only Flash Translation layer
[    0.519921] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    0.521584] hdlc: HDLC support module revision 1.22
[    0.522364] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    0.523290] usbcore: registered new interface driver catc
[    0.524121] usbcore: registered new interface driver kaweth
[    0.524979] usbcore: registered new interface driver r8152
[    0.525832] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.526759] ehci-pci: EHCI PCI platform driver
[    0.527483] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    0.528384] usbcore: registered new interface driver cdc_acm
[    0.529240] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    0.530496] usbcore: registered new interface driver cdc_wdm
[    0.531362] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    0.532384] usbcore: registered new interface driver iowarrior
[    0.533263] usbcore: registered new interface driver usbled
[    0.534114] usbcore: registered new interface driver usbtest
[    0.534989] usbcore: registered new interface driver usb_ehset_test
[    0.535918] usbcore: registered new interface driver trancevibrator
[    0.536831] usbcore: registered new interface driver uss720
[    0.537666] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    0.539035] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    0.540193] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    0.541346] uss720: If you just want to connect to a printer, use usblp =
instead
[    0.542528] usbcore: registered new interface driver usbsevseg
[    0.543454] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.545269] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.546055] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.546917] cm109: Keymap for Komunikate KIP1000 phone loaded
[    0.547810] usbcore: registered new interface driver cm109
[    0.548648] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    0.549625] usbcore: registered new interface driver ims_pcu
[    0.550483] usbcore: registered new interface driver powermate
[    0.551370] ideapad_slidebar: DMI does not match
[    0.552104] pps_parport: parallel port PPS client
[    0.553061] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    0.554788] Driver for 1-wire Dallas network protocol.
[    0.555615] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    0.556534] power_supply test_ac: uevent
[    0.557183] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.558038] power_supply test_ac: prop ONLINE=3D1
[    0.558760] power_supply test_ac: power_supply_changed
[    0.559568] power_supply test_battery: uevent
[    0.560261] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.561214] power_supply test_battery: prop STATUS=3DDischarging
[    0.562086] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.562948] power_supply test_battery: prop HEALTH=3DGood
[    0.563755] power_supply test_battery: prop PRESENT=3D1
[    0.564540] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.565392] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.566289] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.567124] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.567951] power_supply test_battery: prop CAPACITY=3D50
[    0.568759] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.569674] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.570584] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.571439] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.572356] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.573231] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-n=
ext-20140321
[    0.574426] power_supply test_battery: prop TEMP=3D26
[    0.575186] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.576077] power_supply test_battery: power_supply_changed
[    0.576934] power_supply test_usb: uevent
[    0.577599] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    0.578468] power_supply test_usb: prop ONLINE=3D1
[    0.579198] power_supply test_usb: power_supply_changed
[    0.580011] applesmc: supported laptop not found!
[    0.580758] applesmc: driver init failed (ret=3D-19)!
[    0.581645] ledtrig-cpu: registered to indicate activity on CPUs
[    0.582560] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    0.583767] power_supply test_ac: power_supply_changed_work
[    0.584627] power_supply test_ac: power_supply_update_gen_leds 1
[    0.585526] power_supply test_ac: uevent
[    0.586171] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.587017] power_supply test_ac: prop ONLINE=3D1
[    0.587742] power_supply test_battery: power_supply_changed_work
[    0.588652] power_supply test_battery: power_supply_update_bat_leds 2
[    0.589603] power_supply test_battery: uevent
[    0.590294] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.591251] power_supply test_battery: prop STATUS=3DDischarging
[    0.592134] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.592992] power_supply test_battery: prop HEALTH=3DGood
[    0.593793] power_supply test_battery: prop PRESENT=3D1
[    0.594590] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.595455] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.596376] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.597226] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.598055] power_supply test_battery: prop CAPACITY=3D50
[    0.598868] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.599783] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.600711] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.601625] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.602550] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.603429] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-n=
ext-20140321
[    0.604640] power_supply test_battery: prop TEMP=3D26
[    0.605402] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.606272] power_supply test_usb: power_supply_changed_work
[    0.607139] power_supply test_usb: power_supply_update_gen_leds 1
[    0.608059] power_supply test_usb: uevent
[    0.608726] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    0.609596] power_supply test_usb: prop ONLINE=3D1
[    0.610325] panel: driver version 0.9.5 not yet registered
[    0.611177] usbcore: registered new interface driver tranzport
[    0.612057] usbcore: registered new interface driver alphatrack
[    0.613013] usbcore: registered new interface driver cedusb
[    0.613927] Mirror/redirect action on
[    0.614579] lec:lane_module_init: lec.c: initialized
[    0.615351] mpls_gso: MPLS GSO support
[    0.621029]=20
[    0.621029] printing PIC contents
[    0.621905] ... PIC  IMR: ffff
[    0.622451] ... PIC  IRR: 1013
[    0.622990] ... PIC  ISR: 0000
[    0.623537] ... PIC ELCR: 0c00
[    0.624083] printing local APIC contents on CPU#0/0:
[    0.624232] ... APIC ID:      00000000 (0)
[    0.624232] ... APIC VERSION: 00050014
[    0.624232] ... APIC TASKPRI: 00000000 (00)
[    0.624232] ... APIC PROCPRI: 00000000
[    0.624232] ... APIC LDR: 01000000
[    0.624232] ... APIC DFR: ffffffff
[    0.624232] ... APIC SPIV: 000001ff
[    0.624232] ... APIC ISR field:
[    0.624232] 000000000000000000000000000000000000000000000000000000000000=
0000
[    0.624232] ... APIC TMR field:
[    0.624232] 000000000200000000000000000000000000000000000000000000000000=
0000
[    0.624232] ... APIC IRR field:
[    0.624232] 000000000000000000000000000000000000000000000000000000000000=
8000
[    0.624232] ... APIC ESR: 00000000
[    0.624232] ... APIC ICR: 00000831
[    0.624232] ... APIC ICR2: 01000000
[    0.624232] ... APIC LVTT: 000200ef
[    0.624232] ... APIC LVTPC: 00010000
[    0.624232] ... APIC LVT0: 00010700
[    0.624232] ... APIC LVT1: 00000400
[    0.624232] ... APIC LVTERR: 000000fe
[    0.624232] ... APIC TMICT: 00032dcc
[    0.624232] ... APIC TMCCT: 000310ba
[    0.624232] ... APIC TDCR: 00000003
[    0.624232]=20
[    0.642537] number of MP IRQ sources: 15.
[    0.643192] number of IO-APIC #0 registers: 24.
[    0.643919] testing the IO APIC.......................
[    0.644730] IO APIC #0......
[    0.645251] .... register #00: 00000000
[    0.645890] .......    : physical APIC id: 00
[    0.646592] .......    : Delivery Type: 0
[    0.647240] .......    : LTS          : 0
[    0.647907] .... register #01: 00170011
[    0.648551] .......     : max redirection entries: 17
[    0.649317] .......     : PRQ implemented: 0
[    0.650003] .......     : IO APIC version: 11
[    0.650698] .... register #02: 00000000
[    0.651339] .......     : arbitration: 00
[    0.651985] .... IRQ redirection table:
[    0.652629] 1    0    0   0   0    0    0    00
[    0.653353] 0    0    0   0   0    1    1    31
[    0.654080] 0    0    0   0   0    1    1    30
[    0.654817] 0    0    0   0   0    1    1    33
[    0.655552] 1    0    0   0   0    1    1    34
[    0.656276] 1    1    0   0   0    1    1    35
[    0.657022] 0    0    0   0   0    1    1    36
[    0.657759] 0    0    0   0   0    1    1    37
[    0.658484] 0    0    0   0   0    1    1    38
[    0.659206] 0    1    0   0   0    1    1    39
[    0.659934] 1    1    0   0   0    1    1    3A
[    0.660663] 1    1    0   0   0    1    1    3B
[    0.661394] 0    0    0   0   0    1    1    3C
[    0.662119] 0    0    0   0   0    1    1    3D
[    0.662838] 0    0    0   0   0    1    1    3E
[    0.663568] 0    0    0   0   0    1    1    3F
[    0.664289] 1    0    0   0   0    0    0    00
[    0.665012] 1    0    0   0   0    0    0    00
[    0.665741] 1    0    0   0   0    0    0    00
[    0.666478] 1    0    0   0   0    0    0    00
[    0.667199] 1    0    0   0   0    0    0    00
[    0.667930] 1    0    0   0   0    0    0    00
[    0.668658] 1    0    0   0   0    0    0    00
[    0.669382] 1    0    0   0   0    0    0    00
[    0.670095] IRQ to pin mappings:
[    0.670659] IRQ0 -> 0:2
[    0.671261] IRQ1 -> 0:1
[    0.671864] IRQ3 -> 0:3
[    0.672461] IRQ4 -> 0:4
[    0.673058] IRQ5 -> 0:5
[    0.673655] IRQ6 -> 0:6
[    0.674253] IRQ7 -> 0:7
[    0.674852] IRQ8 -> 0:8
[    0.675453] IRQ9 -> 0:9
[    0.676047] IRQ10 -> 0:10
[    0.676668] IRQ11 -> 0:11
[    0.677279] IRQ12 -> 0:12
[    0.677903] IRQ13 -> 0:13
[    0.678522] IRQ14 -> 0:14
[    0.679133] IRQ15 -> 0:15
[    0.679752] .................................... done.
[    0.680599] Loading compiled-in X.509 certificates
[    0.681998] Loaded X.509 cert 'Magrathea: Glacier signing key: 91278b097=
1f1c3efcc4d2ef88121c0169999fe35'
[    0.684201] Btrfs loaded, debug=3Don
[    0.684894] Key type trusted registered
[    0.685598] Key type encrypted registered
[    0.686428] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    0.688352] Freeing unused kernel memory: 772K (ffffffff8187f000 - fffff=
fff81940000)
[    0.689582] Write protecting the kernel read-only data: 8192k
[    0.693317] Freeing unused kernel memory: 1424K (ffff88000149c000 - ffff=
880001600000)
[    0.695071] Freeing unused kernel memory: 256K (ffff8800017c0000 - ffff8=
80001800000)
[    0.707700] udev[97]: starting version 164
[    0.714248] power_supply test_ac: uevent
[    0.714920] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.715764] power_supply test_ac: prop ONLINE=3D1
[    0.716498] power_supply test_battery: uevent
[    0.717187] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.718137] power_supply test_battery: prop STATUS=3DDischarging
[    0.719004] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.719859] power_supply test_battery: prop HEALTH=3DGood
[    0.720654] power_supply test_battery: prop PRESENT=3D1
[    0.721438] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.722289] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.723193] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.724030] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.724860] power_supply test_battery: prop CAPACITY=3D50
[    0.725656] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.726556] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.727453] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.728355] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.729276] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.730141] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-n=
ext-20140321
[    0.731334] power_supply test_battery: prop TEMP=3D26
[    0.732090] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.754142] power_supply test_usb: uevent
[    0.754807] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    0.755607] power_supply test_usb: prop ONLINE=3D1
[    0.792345] power_supply test_ac: uevent
[    0.793027] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.793890] power_supply test_ac: prop ONLINE=3D1
[    0.808767] power_supply test_ac: uevent
[    0.809455] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.810295] power_supply test_ac: prop ONLINE=3D1
[    0.811221] power_supply test_battery: uevent
[    0.811927] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.812864] power_supply test_battery: prop STATUS=3DDischarging
[    0.813733] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.814592] power_supply test_battery: prop HEALTH=3DGood
[    0.815403] power_supply test_battery: prop PRESENT=3D1
[    0.816170] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.817028] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.817932] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.818767] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.819577] power_supply test_battery: prop CAPACITY=3D50
[    0.820362] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.821260] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.822166] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.823052] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.823957] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.824829] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-n=
ext-20140321
[    0.826019] power_supply test_battery: prop TEMP=3D26
[    0.826756] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.862213] block nbd14: Attempted send on closed socket
[    0.863049] end_request: I/O error, dev nbd14, sector 2
[    0.863856] EXT2-fs (nbd14): error: unable to read superblock
[    0.864828] block nbd0: Attempted send on closed socket
[    0.865645] end_request: I/O error, dev nbd0, sector 2
[    0.866426] EXT2-fs (nbd0): error: unable to read superblock
[    0.867298] block nbd0: Attempted send on closed socket
[    0.868114] end_request: I/O error, dev nbd0, sector 0
[    0.868911] FAT-fs (nbd0): unable to read boot sector
[    0.869713] block nbd1: Attempted send on closed socket
[    0.870518] end_request: I/O error, dev nbd1, sector 2
[    0.871308] EXT2-fs (nbd1): error: unable to read superblock
[    0.872169] block nbd10: Attempted send on closed socket
[    0.872980] end_request: I/O error, dev nbd10, sector 2
[    0.873787] EXT2-fs (nbd10): error: unable to read superblock
[    0.874670] block nbd2: Attempted send on closed socket
[    0.875476] end_request: I/O error, dev nbd2, sector 2
[    0.876253] EXT2-fs (nbd2): error: unable to read superblock
[    0.882018] block nbd13: Attempted send on closed socket
[    0.882840] end_request: I/O error, dev nbd13, sector 2
[    0.883647] EXT2-fs (nbd13): error: unable to read superblock
[    0.884519] block nbd11: Attempted send on closed socket
[    0.885325] end_request: I/O error, dev nbd11, sector 2
[    0.886123] EXT2-fs (nbd11): error: unable to read superblock
[    0.886994] block nbd11: Attempted send on closed socket
[    0.887808] end_request: I/O error, dev nbd11, sector 0
[    0.888618] FAT-fs (nbd11): unable to read boot sector
[    0.889424] block nbd12: Attempted send on closed socket
[    0.890223] end_request: I/O error, dev nbd12, sector 2
[    0.891021] EXT2-fs (nbd12): error: unable to read superblock
[    0.891942] block nbd5: Attempted send on closed socket
[    0.892764] random: nonblocking pool is initialized
[    0.893528] EXT2-fs (nbd5): error: unable to read superblock
[    0.897411] block nbd12: Attempted send on closed socket
[    0.898249] FAT-fs (nbd12): unable to read boot sector
[    0.899180] block nbd4: Attempted send on closed socket
[    0.899977] EXT2-fs (nbd4): error: unable to read superblock
[    0.900845] block nbd4: Attempted send on closed socket
[    0.901672] FAT-fs (nbd4): unable to read boot sector
[    0.902488] block nbd3: Attempted send on closed socket
[    0.903284] EXT2-fs (nbd3): error: unable to read superblock
[    0.904156] block nbd3: Attempted send on closed socket
[    0.904976] FAT-fs (nbd3): unable to read boot sector
[    0.905780] block nbd15: Attempted send on closed socket
[    0.906595] EXT2-fs (nbd15): error: unable to read superblock
[    0.907479] block nbd15: Attempted send on closed socket
[    0.908303] FAT-fs (nbd15): unable to read boot sector
[    0.909130] block nbd6: Attempted send on closed socket
[    0.909944] EXT2-fs (nbd6): error: unable to read superblock
[    0.910823] block nbd6: Attempted send on closed socket
[    0.911648] FAT-fs (nbd6): unable to read boot sector
[    0.912467] block nbd1: Attempted send on closed socket
[    0.913248] FAT-fs (nbd1): unable to read boot sector
[    0.914065] block nbd10: Attempted send on closed socket
[    0.914884] FAT-fs (nbd10): unable to read boot sector
[    0.915768] block nbd8: Attempted send on closed socket
[    0.916579] EXT2-fs (nbd8): error: unable to read superblock
[    0.917449] block nbd8: Attempted send on closed socket
[    0.918250] FAT-fs (nbd8): unable to read boot sector
[    0.919032] block nbd7: Attempted send on closed socket
[    0.919840] EXT2-fs (nbd7): error: unable to read superblock
[    0.920685] block nbd7: Attempted send on closed socket
[    0.921483] FAT-fs (nbd7): unable to read boot sector
[    0.922329] block nbd9: Attempted send on closed socket
[    0.923141] EXT2-fs (nbd9): error: unable to read superblock
[    0.924018] block nbd9: Attempted send on closed socket
[    0.924840] FAT-fs (nbd9): unable to read boot sector
[    0.926133] block nbd13: Attempted send on closed socket
[    0.926961] FAT-fs (nbd13): unable to read boot sector
[    0.927794] block nbd14: Attempted send on closed socket
[    0.928616] FAT-fs (nbd14): unable to read boot sector
[    0.929437] block nbd5: Attempted send on closed socket
[    0.930244] FAT-fs (nbd5): unable to read boot sector
[    0.931060] LogFS: Start mount 0
[    0.931658] LogFS: Start unmounting
[    0.932279] LogFS: Start mount 1
[    0.932857] LogFS: Start unmounting
[    0.933482] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    0.934337] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    0.934337] PGD 11e41067 PUD 1183f067 PMD 0=20
[    0.934337] Oops: 0002 [#1]=20
[    0.934337] Modules linked in:
[    0.934337] CPU: 0 PID: 498 Comm: mount Not tainted 3.14.0-rc7-next-2014=
0321 #10
[    0.934337] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.934337] task: ffff8800007c3a80 ti: ffff880011fc8000 task.ti: ffff880=
011fc8000
[    0.934337] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    0.934337] RSP: 0018:ffff880011fc9d10  EFLAGS: 00010286
[    0.934337] RAX: 0000000000000000 RBX: ffff880011fbbcc0 RCX: 00000000000=
00002
[    0.934337] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
bbcc0
[    0.934337] RBP: ffff880011fc9d50 R08: ffff880011fc8000 R09: 00000000000=
00100
[    0.934337] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011f=
bbcc8
[    0.934337] R13: ffff8800007c3a80 R14: 00000000ffffffff R15: ffff880011f=
bb000
[    0.934337] FS:  00007f08f76f8700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    0.934337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.934337] CR2: 0000000000000000 CR3: 0000000011847000 CR4: 00000000000=
006b0
[    0.934337] Stack:
[    0.934337]  ffff880011fbbcc8 0000000000000000 ffff880011fc9d18 00000000=
00000850
[    0.934337]  ffff880011fbbcc0 ffff880011e8e000 ffff880011fbb000 ffff8800=
13365e00
[    0.934337]  ffff880011fc9d68 ffffffff81497a1d ffff880011e8e000 ffff8800=
11fc9d80
[    0.934337] Call Trace:
[    0.934337]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    0.934337]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    0.934337]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    0.934337]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    0.934337]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    0.934337]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    0.934337]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    0.934337]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    0.934337]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    0.934337]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    0.934337]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    0.934337]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    0.934337]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    0.934337] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    0.934337] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    0.934337]  RSP <ffff880011fc9d10>
[    0.934337] CR2: 0000000000000000
[    0.934337] ---[ end trace 5506712fb917b42d ]---
[    0.934337] BUG: sleeping function called from invalid context at kernel=
/locking/rwsem.c:20
[    0.934337] in_atomic(): 1, irqs_disabled(): 1, pid: 498, name: mount
[    0.934337] CPU: 0 PID: 498 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    0.934337] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.934337]  0000000000000000 ffff880011fc99a0 ffffffff81494994 ffff8800=
11fc99b0
[    0.934337]  ffffffff810744e3 ffff880011fc99c8 ffffffff81497d22 ffff8800=
007c3a80
[    0.934337]  ffff880011fc99e8 ffffffff8106529d 0000000000000000 ffff8800=
007c3a80
[    0.934337] Call Trace:
[    0.934337]  [<ffffffff81494994>] dump_stack+0x19/0x1b
[    0.934337]  [<ffffffff810744e3>] __might_sleep+0xea/0xec
[    0.934337]  [<ffffffff81497d22>] down_read+0x1b/0x2b
[    0.934337]  [<ffffffff8106529d>] exit_signals+0x1c/0xed
[    0.934337]  [<ffffffff8105bd61>] do_exit+0x105/0x799
[    0.934337]  [<ffffffff810043c9>] oops_end+0x86/0x8b
[    0.934337]  [<ffffffff8148fd32>] no_context+0x2a4/0x2b1
[    0.934337]  [<ffffffff8148fee6>] __bad_area_nosemaphore+0x7b/0x1d1
[    0.934337]  [<ffffffff8149004a>] bad_area_nosemaphore+0xe/0x10
[    0.934337]  [<ffffffff81020bd2>] __do_page_fault+0xc8/0x40f
[    0.934337]  [<ffffffff81077908>] ? update_curr+0x65/0xa7
[    0.934337]  [<ffffffff81077c30>] ? check_preempt_wakeup+0x122/0x173
[    0.934337]  [<ffffffff81074967>] ? check_preempt_curr+0x2b/0x67
[    0.934337]  [<ffffffff81020f5a>] do_page_fault+0x22/0x27
[    0.934337]  [<ffffffff8101eac4>] do_async_page_fault+0x2c/0x62
[    0.934337]  [<ffffffff81498c68>] async_page_fault+0x28/0x30
[    0.934337]  [<ffffffff81072933>] ? put_cred_rcu+0x7b/0x8b
[    0.934337]  [<ffffffff8149797f>] ? __mutex_lock_slowpath+0x4b/0xc2
[    0.934337]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    0.934337]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    0.934337]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    0.934337]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    0.934337]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    0.934337]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    0.934337]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    0.934337]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    0.934337]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    0.934337]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    0.934337]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    0.934337]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    0.934337]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    0.934337] note: mount[498] exited with preempt_count 2
[    1.011936] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.013281] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.014246] PGD 1184b067 PUD 11d5f067 PMD 0=20
[    1.015109] Oops: 0002 [#2]=20
[    1.015136] Modules linked in:
[    1.015136] CPU: 0 PID: 499 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.015136] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.015136] task: ffff8800007c1a00 ti: ffff880011e44000 task.ti: ffff880=
011e44000
[    1.015136] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.015136] RSP: 0018:ffff880011e45d10  EFLAGS: 00010286
[    1.015136] RAX: 0000000000000000 RBX: ffff880011fb8cc0 RCX: 00000000000=
00002
[    1.015136] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
b8cc0
[    1.015136] RBP: ffff880011e45d50 R08: ffff880011e44000 R09: 00000000000=
00100
[    1.015136] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011f=
b8cc8
[    1.015136] R13: ffff8800007c1a00 R14: 00000000ffffffff R15: ffff880011f=
b8000
[    1.015136] FS:  00007ff87d56d700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.015136] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.015136] CR2: 0000000000000000 CR3: 0000000011e28000 CR4: 00000000000=
006b0
[    1.015136] Stack:
[    1.015136]  ffff880011fb8cc8 0000000000000000 ffff880011e45d18 00000000=
00000850
[    1.015136]  ffff880011fb8cc0 ffff880011e8f800 ffff880011fb8000 ffff8800=
13359a80
[    1.015136]  ffff880011e45d68 ffffffff81497a1d ffff880011e8f800 ffff8800=
11e45d80
[    1.015136] Call Trace:
[    1.015136]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.015136]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.015136]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.015136]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.015136]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.015136]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.015136]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.015136]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.015136]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.015136]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.015136]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.015136]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.015136]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.015136] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.015136] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.015136]  RSP <ffff880011e45d10>
[    1.015136] CR2: 0000000000000000
[    1.015136] ---[ end trace 5506712fb917b42e ]---
[    1.015136] note: mount[499] exited with preempt_count 2
[    1.060276] power_supply test_battery: uevent
[    1.061003] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.061946] power_supply test_battery: prop STATUS=3DDischarging
[    1.062816] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.063651] power_supply test_battery: prop HEALTH=3DGood
[    1.064446] power_supply test_battery: prop PRESENT=3D1
[    1.065210] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.066078] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.067000] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.067829] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.068620] power_supply test_battery: prop CAPACITY=3D50
[    1.069404] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.070277] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.071174] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.072050] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.072933] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.073791] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-n=
ext-20140321
[    1.074951] power_supply test_battery: prop TEMP=3D26
[    1.075697] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.076836] power_supply test_usb: uevent
[    1.077471] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.078293] power_supply test_usb: prop ONLINE=3D1
[    1.079043] block nbd12: Attempted send on closed socket
[    1.079815] MINIX-fs: unable to read superblock
[    1.080509] block nbd12: Attempted send on closed socket
[    1.081288] EXT2-fs (nbd12): error: unable to read superblock
[    1.082590] block nbd1: Attempted send on closed socket
[    1.083355] MINIX-fs: unable to read superblock
[    1.084049] block nbd1: Attempted send on closed socket
[    1.084875] EXT2-fs (nbd1): error: unable to read superblock
[    1.085842] block nbd4: Attempted send on closed socket
[    1.086629] MINIX-fs: unable to read superblock
[    1.087304] block nbd4: Attempted send on closed socket
[    1.088062] EXT2-fs (nbd4): error: unable to read superblock
[    1.088869] block nbd6: Attempted send on closed socket
[    1.089622] MINIX-fs: unable to read superblock
[    1.090301] block nbd6: Attempted send on closed socket
[    1.091053] EXT2-fs (nbd6): error: unable to read superblock
[    1.091860] block nbd3: Attempted send on closed socket
[    1.092603] MINIX-fs: unable to read superblock
[    1.093274] block nbd3: Attempted send on closed socket
[    1.094015] EXT2-fs (nbd3): error: unable to read superblock
[    1.094840] block nbd8: Attempted send on closed socket
[    1.095587] MINIX-fs: unable to read superblock
[    1.096258] block nbd8: Attempted send on closed socket
[    1.097007] EXT2-fs (nbd8): error: unable to read superblock
[    1.097820] block nbd7: Attempted send on closed socket
[    1.098564] MINIX-fs: unable to read superblock
[    1.099234] block nbd7: Attempted send on closed socket
[    1.099975] EXT2-fs (nbd7): error: unable to read superblock
[    1.100779] block nbd7: Attempted send on closed socket
[    1.101527] MINIX-fs: unable to read superblock
[    1.102250] block nbd15: Attempted send on closed socket
[    1.103023] MINIX-fs: unable to read superblock
[    1.103705] block nbd15: Attempted send on closed socket
[    1.104477] EXT2-fs (nbd15): error: unable to read superblock
[    1.107017] block nbd14: Attempted send on closed socket
[    1.107803] MINIX-fs: unable to read superblock
[    1.108865] power_supply test_usb: uevent
[    1.109541] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.110406] power_supply test_usb: prop ONLINE=3D1
[    1.117972] block nbd10: Attempted send on closed socket
[    1.118809] MINIX-fs: unable to read superblock
[    1.119541] block nbd10: Attempted send on closed socket
[    1.120361] EXT2-fs (nbd10): error: unable to read superblock
[    1.121590] block nbd13: Attempted send on closed socket
[    1.122411] MINIX-fs: unable to read superblock
[    1.123140] block nbd13: Attempted send on closed socket
[    1.123952] EXT2-fs (nbd13): error: unable to read superblock
[    1.125229] block nbd5: Attempted send on closed socket
[    1.126041] MINIX-fs: unable to read superblock
[    1.126783] block nbd5: Attempted send on closed socket
[    1.127596] EXT2-fs (nbd5): error: unable to read superblock
[    1.129339] block nbd14: Attempted send on closed socket
[    1.130162] EXT2-fs (nbd14): error: unable to read superblock
[    1.131064] block nbd12: Attempted send on closed socket
[    1.131896] MINIX-fs: unable to read superblock
[    1.132638] block nbd12: Attempted send on closed socket
[    1.133454] FAT-fs (nbd12): unable to read boot sector
[    1.134300] block nbd9: Attempted send on closed socket
[    1.135113] MINIX-fs: unable to read superblock
[    1.135847] block nbd9: Attempted send on closed socket
[    1.136666] EXT2-fs (nbd9): error: unable to read superblock
[    1.137553] block nbd0: Attempted send on closed socket
[    1.138353] MINIX-fs: unable to read superblock
[    1.139091] block nbd0: Attempted send on closed socket
[    1.139902] EXT2-fs (nbd0): error: unable to read superblock
[    1.140776] block nbd0: Attempted send on closed socket
[    1.141594] MINIX-fs: unable to read superblock
[    1.142324] block nbd11: Attempted send on closed socket
[    1.143140] MINIX-fs: unable to read superblock
[    1.143875] block nbd11: Attempted send on closed socket
[    1.144708] EXT2-fs (nbd11): error: unable to read superblock
[    1.145597] block nbd6: Attempted send on closed socket
[    1.146392] MINIX-fs: unable to read superblock
[    1.147126] block nbd6: Attempted send on closed socket
[    1.147940] FAT-fs (nbd6): unable to read boot sector
[    1.148741] block nbd4: Attempted send on closed socket
[    1.149552] MINIX-fs: unable to read superblock
[    1.150275] block nbd4: Attempted send on closed socket
[    1.151092] FAT-fs (nbd4): unable to read boot sector
[    1.151906] block nbd3: Attempted send on closed socket
[    1.152721] MINIX-fs: unable to read superblock
[    1.153451] block nbd3: Attempted send on closed socket
[    1.154266] FAT-fs (nbd3): unable to read boot sector
[    1.155115] block nbd8: Attempted send on closed socket
[    1.155934] MINIX-fs: unable to read superblock
[    1.156681] block nbd8: Attempted send on closed socket
[    1.157495] FAT-fs (nbd8): unable to read boot sector
[    1.158307] block nbd15: Attempted send on closed socket
[    1.159133] MINIX-fs: unable to read superblock
[    1.159876] block nbd15: Attempted send on closed socket
[    1.160697] FAT-fs (nbd15): unable to read boot sector
[    1.161522] block nbd1: Attempted send on closed socket
[    1.162321] MINIX-fs: unable to read superblock
[    1.163054] block nbd1: Attempted send on closed socket
[    1.163866] FAT-fs (nbd1): unable to read boot sector
[    1.164678] block nbd2: Attempted send on closed socket
[    1.165489] FAT-fs (nbd2): unable to read boot sector
[    1.166297] block nbd10: Attempted send on closed socket
[    1.167114] MINIX-fs: unable to read superblock
[    1.167867] block nbd14: Attempted send on closed socket
[    1.168687] MINIX-fs: unable to read superblock
[    1.169413] block nbd14: Attempted send on closed socket
[    1.170226] FAT-fs (nbd14): unable to read boot sector
[    1.171058] block nbd13: Attempted send on closed socket
[    1.171883] MINIX-fs: unable to read superblock
[    1.172616] block nbd13: Attempted send on closed socket
[    1.173424] FAT-fs (nbd13): unable to read boot sector
[    1.174238] block nbd5: Attempted send on closed socket
[    1.175046] MINIX-fs: unable to read superblock
[    1.175785] block nbd5: Attempted send on closed socket
[    1.176597] FAT-fs (nbd5): unable to read boot sector
[    1.177393] block nbd5: Attempted send on closed socket
[    1.178210] isofs_fill_super: bread failed, dev=3Dnbd5, iso_blknum=3D16,=
 block=3D32
[    1.179261] block nbd9: Attempted send on closed socket
[    1.180069] MINIX-fs: unable to read superblock
[    1.180807] block nbd9: Attempted send on closed socket
[    1.181621] FAT-fs (nbd9): unable to read boot sector
[    1.182413] block nbd11: Attempted send on closed socket
[    1.183228] MINIX-fs: unable to read superblock
[    1.183957] block nbd11: Attempted send on closed socket
[    1.184785] FAT-fs (nbd11): unable to read boot sector
[    1.185600] block nbd7: Attempted send on closed socket
[    1.186400] FAT-fs (nbd7): unable to read boot sector
[    1.187194] block nbd7: Attempted send on closed socket
[    1.188005] isofs_fill_super: bread failed, dev=3Dnbd7, iso_blknum=3D16,=
 block=3D32
[    1.189052] block nbd10: Attempted send on closed socket
[    1.189871] FAT-fs (nbd10): unable to read boot sector
[    1.190685] block nbd10: Attempted send on closed socket
[    1.191512] isofs_fill_super: bread failed, dev=3Dnbd10, iso_blknum=3D16=
, block=3D32
[    1.197590] block nbd2: Attempted send on closed socket
[    1.198394] MINIX-fs: unable to read superblock
[    1.199129] block nbd2: Attempted send on closed socket
[    1.199937] EXT2-fs (nbd2): error: unable to read superblock
[    1.200809] block nbd2: Attempted send on closed socket
[    1.201625] MINIX-fs: unable to read superblock
[    1.202364] block nbd3: Attempted send on closed socket
[    1.203174] isofs_fill_super: bread failed, dev=3Dnbd3, iso_blknum=3D16,=
 block=3D32
[    1.204228] block nbd12: Attempted send on closed socket
[    1.205049] isofs_fill_super: bread failed, dev=3Dnbd12, iso_blknum=3D16=
, block=3D32
[    1.206215] block nbd12: Attempted send on closed socket
[    1.207041] block nbd12: Attempted send on closed socket
[    1.207935] block nbd0: Attempted send on closed socket
[    1.208743] FAT-fs (nbd0): unable to read boot sector
[    1.209544] block nbd0: Attempted send on closed socket
[    1.210346] isofs_fill_super: bread failed, dev=3Dnbd0, iso_blknum=3D16,=
 block=3D32
[    1.211400] block nbd6: Attempted send on closed socket
[    1.212208] isofs_fill_super: bread failed, dev=3Dnbd6, iso_blknum=3D16,=
 block=3D32
[    1.213244] block nbd6: Attempted send on closed socket
[    1.214057] block nbd6: Attempted send on closed socket
[    1.214894] block nbd4: Attempted send on closed socket
[    1.215711] isofs_fill_super: bread failed, dev=3Dnbd4, iso_blknum=3D16,=
 block=3D32
[    1.216763] block nbd4: Attempted send on closed socket
[    1.217598] block nbd8: Attempted send on closed socket
[    1.218405] isofs_fill_super: bread failed, dev=3Dnbd8, iso_blknum=3D16,=
 block=3D32
[    1.219448] block nbd8: Attempted send on closed socket
[    1.220262] block nbd8: Attempted send on closed socket
[    1.221093] block nbd15: Attempted send on closed socket
[    1.221916] isofs_fill_super: bread failed, dev=3Dnbd15, iso_blknum=3D16=
, block=3D32
[    1.223091] block nbd15: Attempted send on closed socket
[    1.223920] block nbd15: Attempted send on closed socket
[    1.224771] block nbd1: Attempted send on closed socket
[    1.225584] isofs_fill_super: bread failed, dev=3Dnbd1, iso_blknum=3D16,=
 block=3D32
[    1.226629] block nbd1: Attempted send on closed socket
[    1.227448] block nbd1: Attempted send on closed socket
[    1.228276] block nbd14: Attempted send on closed socket
[    1.229093] isofs_fill_super: bread failed, dev=3Dnbd14, iso_blknum=3D16=
, block=3D32
[    1.230266] block nbd14: Attempted send on closed socket
[    1.231108] block nbd13: Attempted send on closed socket
[    1.231927] isofs_fill_super: bread failed, dev=3Dnbd13, iso_blknum=3D16=
, block=3D32
[    1.233096] block nbd13: Attempted send on closed socket
[    1.233927] block nbd13: Attempted send on closed socket
[    1.234772] block nbd9: Attempted send on closed socket
[    1.235588] isofs_fill_super: bread failed, dev=3Dnbd9, iso_blknum=3D16,=
 block=3D32
[    1.236632] block nbd9: Attempted send on closed socket
[    1.237450] block nbd9: Attempted send on closed socket
[    1.238281] block nbd3: Attempted send on closed socket
[    1.239106] block nbd3: Attempted send on closed socket
[    1.239925] block nbd3: Attempted send on closed socket
[    1.240753] block nbd3: Attempted send on closed socket
[    1.241573] HPFS: hpfs_map_sector: read error
[    1.242285] block nbd11: Attempted send on closed socket
[    1.243102] isofs_fill_super: bread failed, dev=3Dnbd11, iso_blknum=3D16=
, block=3D32
[    1.244279] block nbd7: Attempted send on closed socket
[    1.245102] block nbd7: Attempted send on closed socket
[    1.245919] block nbd7: Attempted send on closed socket
[    1.246740] block nbd7: Attempted send on closed socket
[    1.247549] HPFS: hpfs_map_sector: read error
[    1.248258] block nbd5: Attempted send on closed socket
[    1.249080] block nbd5: Attempted send on closed socket
[    1.249899] block nbd5: Attempted send on closed socket
[    1.250718] block nbd5: Attempted send on closed socket
[    1.251533] HPFS: hpfs_map_sector: read error
[    1.252241] block nbd4: Attempted send on closed socket
[    1.253064] block nbd4: Attempted send on closed socket
[    1.253885] block nbd4: Attempted send on closed socket
[    1.254697] HPFS: hpfs_map_sector: read error
[    1.255409] block nbd12: Attempted send on closed socket
[    1.256241] block nbd12: Attempted send on closed socket
[    1.257054] HPFS: hpfs_map_sector: read error
[    1.257777] block nbd0: Attempted send on closed socket
[    1.258606] block nbd0: Attempted send on closed socket
[    1.259415] block nbd0: Attempted send on closed socket
[    1.260234] block nbd0: Attempted send on closed socket
[    1.261050] HPFS: hpfs_map_sector: read error
[    1.261812] block nbd6: Attempted send on closed socket
[    1.262644] block nbd6: Attempted send on closed socket
[    1.263439] HPFS: hpfs_map_sector: read error
[    1.264165] block nbd11: Attempted send on closed socket
[    1.265013] block nbd14: Attempted send on closed socket
[    1.265849] block nbd14: Attempted send on closed socket
[    1.266677] block nbd14: Attempted send on closed socket
[    1.267494] HPFS: hpfs_map_sector: read error
[    1.268231] block nbd8: Attempted send on closed socket
[    1.269056] block nbd8: Attempted send on closed socket
[    1.269862] HPFS: hpfs_map_sector: read error
[    1.270592] block nbd2: Attempted send on closed socket
[    1.271408] FAT-fs (nbd2): unable to read boot sector
[    1.272213] block nbd1: Attempted send on closed socket
[    1.273037] block nbd1: Attempted send on closed socket
[    1.273847] HPFS: hpfs_map_sector: read error
[    1.274585] block nbd15: Attempted send on closed socket
[    1.275412] block nbd15: Attempted send on closed socket
[    1.276226] HPFS: hpfs_map_sector: read error
[    1.276954] block nbd11: Attempted send on closed socket
[    1.277800] block nbd13: Attempted send on closed socket
[    1.278633] block nbd13: Attempted send on closed socket
[    1.279449] HPFS: hpfs_map_sector: read error
[    1.280176] block nbd9: Attempted send on closed socket
[    1.281023] block nbd11: Attempted send on closed socket
[    1.281857] block nbd11: Attempted send on closed socket
[    1.282676] HPFS: hpfs_map_sector: read error
[    1.283448] block nbd2: Attempted send on closed socket
[    1.284259] isofs_fill_super: bread failed, dev=3Dnbd2, iso_blknum=3D16,=
 block=3D32
[    1.285315] block nbd9: Attempted send on closed socket
[    1.286102] HPFS: hpfs_map_sector: read error
[    1.286774] LogFS: Start mount 2
[    1.287317] block nbd6: Attempted send on closed socket
[    1.288139] LogFS: Start mount 3
[    1.288702] block nbd3: Attempted send on closed socket
[    1.289478] LogFS: Start unmounting
[    1.290098] LogFS: Start mount 4
[    1.290675] block nbd12: Attempted send on closed socket
[    1.291518] LogFS: Start mount 5
[    1.292083] block nbd8: Attempted send on closed socket
[    1.292905] LogFS: Start unmounting
[    1.293531] LogFS: Start mount 6
[    1.294088] block nbd15: Attempted send on closed socket
[    1.294966] LogFS: Start mount 7
[    1.295541] block nbd4: Attempted send on closed socket
[    1.296323] LogFS: Start unmounting
[    1.296934] LogFS: Start mount 8
[    1.297487] block nbd7: Attempted send on closed socket
[    1.298294] LogFS: Start mount 9
[    1.298862] block nbd1: Attempted send on closed socket
[    1.299623] LogFS: Start unmounting
[    1.300241] LogFS: Start mount a
[    1.300804] block nbd13: Attempted send on closed socket
[    1.301618] LogFS: Start unmounting
[    1.302212] LogFS: Start mount b
[    1.302786] block nbd9: Attempted send on closed socket
[    1.303592] LogFS: Start unmounting
[    1.304240] LogFS: Start mount c
[    1.304809] block nbd0: Attempted send on closed socket
[    1.305596] LogFS: Start unmounting
[    1.306202] LogFS: Start mount d
[    1.306777] block nbd5: Attempted send on closed socket
[    1.307603] LogFS: Start mount e
[    1.308174] block nbd14: Attempted send on closed socket
[    1.308981] LogFS: Start unmounting
[    1.309575] LogFS: Start unmounting
[    1.310175] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.310919] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.310919] PGD 11f11067 PUD 11c78067 PMD 0=20
[    1.310919] Oops: 0002 [#3]=20
[    1.310919] Modules linked in:
[    1.310919] CPU: 0 PID: 438 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.310919] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.310919] task: ffff880011dd7500 ti: ffff880011efa000 task.ti: ffff880=
011efa000
[    1.310919] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.310919] RSP: 0018:ffff880011efbd10  EFLAGS: 00010286
[    1.310919] RAX: 0000000000000000 RBX: ffff8800138afcc0 RCX: 00000000000=
00002
[    1.310919] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff8800138=
afcc0
[    1.310919] RBP: ffff880011efbd50 R08: ffff880011efa000 R09: 00000000000=
1140e
[    1.310919] R10: 0000000000000064 R11: ffffffff81189062 R12: ffff8800138=
afcc8
[    1.310919] R13: ffff880011dd7500 R14: 00000000ffffffff R15: ffff8800138=
af000
[    1.310919] FS:  00007fe30eae5700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.310919] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.310919] CR2: 0000000000000000 CR3: 000000001180d000 CR4: 00000000000=
006b0
[    1.310919] Stack:
[    1.310919]  ffff8800138afcc8 0000000000000000 ffff880011efbd18 00000000=
0000096d
[    1.310919]  ffff8800138afcc0 ffff8800123ffc00 ffff8800138af000 ffffffff=
fffffffb
[    1.310919]  ffff880011efbd68 ffffffff81497a1d ffff8800123ffc00 ffff8800=
11efbd80
[    1.310919] Call Trace:
[    1.310919]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.310919]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.310919]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.310919]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.310919]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.310919]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.310919]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.310919]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.310919]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.310919]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.310919]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.310919]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.310919]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.310919] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.310919] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.310919]  RSP <ffff880011efbd10>
[    1.310919] CR2: 0000000000000000
[    1.310919] ---[ end trace 5506712fb917b42f ]---
[    1.310919] note: mount[438] exited with preempt_count 2
[    1.359545] LogFS: Start unmounting
[    1.360151] block nbd2: Attempted send on closed socket
[    1.360956] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.362302] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.363264] PGD 11e32067 PUD 11e57067 PMD 0=20
[    1.364117] Oops: 0002 [#4]=20
[    1.364279] Modules linked in:
[    1.364279] CPU: 0 PID: 433 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.364279] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.364279] task: ffff880011dd0680 ti: ffff880011fd4000 task.ti: ffff880=
011fd4000
[    1.364279] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.364279] RSP: 0018:ffff880011fd5d10  EFLAGS: 00010286
[    1.364279] RAX: 0000000000000000 RBX: ffff880011f85cc0 RCX: 00000000000=
00002
[    1.364279] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
85cc0
[    1.364279] RBP: ffff880011fd5d50 R08: ffff880011fd4000 R09: 00000000000=
00100
[    1.364279] R10: 000000000000000d R11: ffffffff81084920 R12: ffff880011f=
85cc8
[    1.364279] R13: ffff880011dd0680 R14: 00000000ffffffff R15: ffff880011f=
85000
[    1.364279] FS:  00007f0c66963700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.364279] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.364279] CR2: 0000000000000000 CR3: 0000000011ca0000 CR4: 00000000000=
006b0
[    1.364279] Stack:
[    1.364279]  ffff880011f85cc8 0000000000000000 ffff880011fd5d18 00000000=
00000970
[    1.364279]  ffff880011f85cc0 ffff8800123ff000 ffff880011f85000 ffffffff=
fffffffb
[    1.364279]  ffff880011fd5d68 ffffffff81497a1d ffff8800123ff000 ffff8800=
11fd5d80
[    1.364279] Call Trace:
[    1.364279]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.364279]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.364279]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.364279]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.364279]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.364279]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.364279]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.364279]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.364279]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.364279]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.364279]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.364279]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.364279]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.364279] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.364279] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.364279]  RSP <ffff880011fd5d10>
[    1.364279] CR2: 0000000000000000
[    1.364279] ---[ end trace 5506712fb917b430 ]---
[    1.364279] note: mount[433] exited with preempt_count 2
[    1.404929] LogFS: Start mount f
[    1.405502] block nbd11: Attempted send on closed socket
[    1.406280] LogFS: Start unmounting
[    1.406895] block nbd10: Attempted send on closed socket
[    1.407720] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.409047] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.410028] PGD 11dcc067 PUD 11ece067 PMD 0=20
[    1.410885] Oops: 0002 [#5]=20
[    1.411043] Modules linked in:
[    1.411043] CPU: 0 PID: 437 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.411043] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.411043] task: ffff880011dd0000 ti: ffff880011eb4000 task.ti: ffff880=
011eb4000
[    1.411043] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.411043] RSP: 0018:ffff880011eb5d10  EFLAGS: 00010286
[    1.411043] RAX: 0000000000000000 RBX: ffff8800001dccc0 RCX: 00000000000=
00002
[    1.411043] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff8800001=
dccc0
[    1.411043] RBP: ffff880011eb5d50 R08: ffff880011eb4000 R09: 00000000000=
00100
[    1.411043] R10: 000000000000001d R11: ffffffff81084920 R12: ffff8800001=
dccc8
[    1.411043] R13: ffff880011dd0000 R14: 00000000ffffffff R15: ffff8800001=
dc000
[    1.411043] FS:  00007f53b4a91700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.411043] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.411043] CR2: 0000000000000000 CR3: 0000000011eaf000 CR4: 00000000000=
006b0
[    1.411043] Stack:
[    1.411043]  ffff8800001dccc8 0000000000000000 ffff880011eb5d18 00000000=
00000970
[    1.411043]  ffff8800001dccc0 ffff8800123ff400 ffff8800001dc000 ffffffff=
fffffffb
[    1.411043]  ffff880011eb5d68 ffffffff81497a1d ffff8800123ff400 ffff8800=
11eb5d80
[    1.411043] Call Trace:
[    1.411043]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.411043]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.411043]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.411043]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.411043]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.411043]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.411043]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.411043]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.411043]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.411043]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.411043]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.411043]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.411043]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.411043] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.411043] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.411043]  RSP <ffff880011eb5d10>
[    1.411043] CR2: 0000000000000000
[    1.411043] ---[ end trace 5506712fb917b431 ]---
[    1.411043] note: mount[437] exited with preempt_count 2
[    1.452017] LogFS: Start unmounting
[    1.452617] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.453933] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.454925] PGD 11ec3067 PUD 11e80067 PMD 0=20
[    1.455197] Oops: 0002 [#6]=20
[    1.455197] Modules linked in:
[    1.455197] CPU: 0 PID: 436 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.455197] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.455197] task: ffff880011dd0d00 ti: ffff880011eb0000 task.ti: ffff880=
011eb0000
[    1.455197] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.455197] RSP: 0018:ffff880011eb1d10  EFLAGS: 00010286
[    1.455197] RAX: 0000000000000000 RBX: ffff880011f91cc0 RCX: 00000000000=
00002
[    1.455197] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
91cc0
[    1.455197] RBP: ffff880011eb1d50 R08: ffff880011eb0000 R09: 00000000000=
11457
[    1.455197] R10: 0000000000000064 R11: ffffffff81189062 R12: ffff880011f=
91cc8
[    1.455197] R13: ffff880011dd0d00 R14: 00000000ffffffff R15: ffff880011f=
91000
[    1.455197] FS:  00007f297be83700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.455197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.455197] CR2: 0000000000000000 CR3: 0000000011c6d000 CR4: 00000000000=
006b0
[    1.455197] Stack:
[    1.455197]  ffff880011f91cc8 0000000000000000 ffff880011eb1d18 00000000=
0000096f
[    1.455197]  ffff880011f91cc0 ffff880011e8fc00 ffff880011f91000 ffffffff=
fffffffb
[    1.455197]  ffff880011eb1d68 ffffffff81497a1d ffff880011e8fc00 ffff8800=
11eb1d80
[    1.455197] Call Trace:
[    1.455197]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.455197]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.455197]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.455197]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.455197]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.455197]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.455197]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.455197]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.455197]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.455197]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.455197]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.455197]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.455197]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.455197] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.455197] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.455197]  RSP <ffff880011eb1d10>
[    1.455197] CR2: 0000000000000000
[    1.455197] ---[ end trace 5506712fb917b432 ]---
[    1.455197] note: mount[436] exited with preempt_count 2
[    1.501565] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.502918] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.503912] PGD 11e31067 PUD 11e81067 PMD 0=20
[    1.504783] Oops: 0002 [#7]=20
[    1.504786] Modules linked in:
[    1.504786] CPU: 0 PID: 486 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.504786] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.504786] task: ffff8800007c1380 ti: ffff880011ed8000 task.ti: ffff880=
011ed8000
[    1.504786] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.504786] RSP: 0018:ffff880011ed9d10  EFLAGS: 00010286
[    1.504786] RAX: 0000000000000000 RBX: ffff880011f93cc0 RCX: 00000000000=
00002
[    1.504786] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
93cc0
[    1.504786] RBP: ffff880011ed9d50 R08: ffff880011ed8000 R09: 00000000000=
00100
[    1.504786] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011f=
93cc8
[    1.504786] R13: ffff8800007c1380 R14: 00000000ffffffff R15: ffff880011f=
93000
[    1.504786] FS:  00007fc85c88e700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.504786] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.504786] CR2: 0000000000000000 CR3: 0000000011e7d000 CR4: 00000000000=
006b0
[    1.504786] Stack:
[    1.504786]  ffff880011f93cc8 0000000000000000 ffff880011ed9d18 00000000=
00000970
[    1.504786]  ffff880011f93cc0 ffff880011e8f400 ffff880011f93000 ffffffff=
fffffffb
[    1.504786]  ffff880011ed9d68 ffffffff81497a1d ffff880011e8f400 ffff8800=
11ed9d80
[    1.504786] Call Trace:
[    1.504786]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.504786]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.504786]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.504786]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.504786]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.504786]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.504786]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.504786]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.504786]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.504786]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.504786]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.504786]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.504786]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.504786] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.504786] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.504786]  RSP <ffff880011ed9d10>
[    1.504786] CR2: 0000000000000000
[    1.504786] ---[ end trace 5506712fb917b433 ]---
[    1.504786] note: mount[486] exited with preempt_count 2
[    1.545081] LogFS: Start unmounting
[    1.545935] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.547244] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.548104] PGD 11833067 PUD 11e3d067 PMD 0=20
[    1.548104] Oops: 0002 [#8]=20
[    1.548104] Modules linked in:
[    1.548104] CPU: 0 PID: 477 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.548104] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.548104] task: ffff880011fb6180 ti: ffff880011fdc000 task.ti: ffff880=
011fdc000
[    1.548104] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.548104] RSP: 0018:ffff880011fddd10  EFLAGS: 00010286
[    1.548104] RAX: 0000000000000000 RBX: ffff880011fb9cc0 RCX: 00000000000=
00002
[    1.548104] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
b9cc0
[    1.548104] RBP: ffff880011fddd50 R08: ffff880011fdc000 R09: 00000000000=
00100
[    1.548104] R10: 0000000000000000 R11: ffffffff810f0d1b R12: ffff880011f=
b9cc8
[    1.548104] R13: ffff880011fb6180 R14: 00000000ffffffff R15: ffff880011f=
b9000
[    1.548104] FS:  00007f272ca21700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.548104] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.548104] CR2: 0000000000000000 CR3: 0000000011cfe000 CR4: 00000000000=
006b0
[    1.548104] Stack:
[    1.548104]  ffff880011fb9cc8 0000000000000000 ffff880011fddd18 00000000=
0000096e
[    1.548104]  ffff880011fb9cc0 ffff880011e8e400 ffff880011fb9000 ffffffff=
fffffffb
[    1.548104]  ffff880011fddd68 ffffffff81497a1d ffff880011e8e400 ffff8800=
11fddd80
[    1.548104] Call Trace:
[    1.548104]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.548104]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.548104]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.548104]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.548104]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.548104]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.548104]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.548104]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.548104]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.548104]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.548104]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.548104]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.548104]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.548104] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.548104] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.548104]  RSP <ffff880011fddd10>
[    1.548104] CR2: 0000000000000000
[    1.548104] ---[ end trace 5506712fb917b434 ]---
[    1.548104] note: mount[477] exited with preempt_count 2
[    1.589044] LogFS: Start unmounting
[    1.589698] block nbd2: Attempted send on closed socket
[    1.590493] block nbd2: Attempted send on closed socket
[    1.591267] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.592569] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.593521] PGD 11feb067 PUD 11def067 PMD 0=20
[    1.594362] Oops: 0002 [#9]=20
[    1.594588] Modules linked in:
[    1.594588] CPU: 0 PID: 429 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.594588] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.594588] task: ffff880011c10d00 ti: ffff880011f2a000 task.ti: ffff880=
011f2a000
[    1.594588] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.594588] RSP: 0018:ffff880011f2bd10  EFLAGS: 00010286
[    1.594588] RAX: 0000000000000000 RBX: ffff880011f95cc0 RCX: 00000000000=
00002
[    1.594588] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
95cc0
[    1.594588] RBP: ffff880011f2bd50 R08: ffff880011f2a000 R09: 00000000000=
00100
[    1.594588] R10: 0000000000000000 R11: ffffffff81084920 R12: ffff880011f=
95cc8
[    1.594588] R13: ffff880011c10d00 R14: 00000000ffffffff R15: ffff880011f=
95000
[    1.594588] FS:  00007f7169c9f700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.594588] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.594588] CR2: 0000000000000000 CR3: 0000000011f73000 CR4: 00000000000=
006b0
[    1.594588] Stack:
[    1.594588]  ffff880011f95cc8 0000000000000000 ffff880011f2bd18 00000000=
00000970
[    1.594588]  ffff880011f95cc0 ffff880011e8e800 ffff880011f95000 ffffffff=
fffffffb
[    1.594588]  ffff880011f2bd68 ffffffff81497a1d ffff880011e8e800 ffff8800=
11f2bd80
[    1.594588] Call Trace:
[    1.594588]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.594588]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.594588]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.594588]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.594588]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.594588]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.594588]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.594588]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.594588]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.594588]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.594588]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.594588]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.594588]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.594588] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.594588] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.594588]  RSP <ffff880011f2bd10>
[    1.594588] CR2: 0000000000000000
[    1.594588] ---[ end trace 5506712fb917b435 ]---
[    1.594588] note: mount[429] exited with preempt_count 2
[    1.634524] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.635823] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.636768] PGD 11800067 PUD 11801067 PMD 0=20
[    1.637529] Oops: 0002 [#10]=20
[    1.637529] Modules linked in:
[    1.637529] CPU: 0 PID: 439 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.637529] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.637529] task: ffff880011dd6e80 ti: ffff880011826000 task.ti: ffff880=
011826000
[    1.637529] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.637529] RSP: 0018:ffff880011827d10  EFLAGS: 00010286
[    1.637529] RAX: 0000000000000000 RBX: ffff880011f81cc0 RCX: 00000000000=
00002
[    1.637529] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
81cc0
[    1.637529] RBP: ffff880011827d50 R08: ffff880011826000 R09: 00000000000=
00100
[    1.637529] R10: 0000000000000000 R11: ffffffff810f0d1b R12: ffff880011f=
81cc8
[    1.637529] R13: ffff880011dd6e80 R14: 00000000ffffffff R15: ffff880011f=
81000
[    1.637529] FS:  00007eff350ae700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.637529] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.637529] CR2: 0000000000000000 CR3: 0000000011cb7000 CR4: 00000000000=
006b0
[    1.637529] Stack:
[    1.637529]  ffff880011f81cc8 0000000000000000 ffff880011827d18 00000000=
00000971
[    1.637529]  ffff880011f81cc0 ffff880011e8ec00 ffff880011f81000 ffffffff=
fffffffb
[    1.637529]  ffff880011827d68 ffffffff81497a1d ffff880011e8ec00 ffff8800=
11827d80
[    1.637529] Call Trace:
[    1.637529]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.637529]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.637529]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.637529]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.637529]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.637529]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.637529]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.637529]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.637529]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.637529]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.637529]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.637529]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.637529]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.637529] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.637529] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.637529]  RSP <ffff880011827d10>
[    1.637529] CR2: 0000000000000000
[    1.637529] ---[ end trace 5506712fb917b436 ]---
[    1.637529] note: mount[439] exited with preempt_count 2
[    1.682510] block nbd10: Attempted send on closed socket
[    1.683303] block nbd10: Attempted send on closed socket
[    1.684088] block nbd10: Attempted send on closed socket
[    1.684878] HPFS: hpfs_map_sector: read error
[    1.685553] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.686857] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.687810] PGD 11ff7067 PUD 11e05067 PMD 0=20
[    1.688207] Oops: 0002 [#11]=20
[    1.688207] Modules linked in:
[    1.688207] CPU: 0 PID: 428 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.688207] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.688207] task: ffff880011c16800 ti: ffff880011db6000 task.ti: ffff880=
011db6000
[    1.688207] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.688207] RSP: 0018:ffff880011db7d10  EFLAGS: 00010286
[    1.688207] RAX: 0000000000000000 RBX: ffff8800001dacc0 RCX: 00000000000=
00002
[    1.688207] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff8800001=
dacc0
[    1.688207] RBP: ffff880011db7d50 R08: ffff880011db6000 R09: 00000000000=
00100
[    1.688207] R10: 0000000000000000 R11: ffffffff81084920 R12: ffff8800001=
dacc8
[    1.688207] R13: ffff880011c16800 R14: 00000000ffffffff R15: ffff8800001=
da000
[    1.688207] FS:  00007fd65c40a700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.688207] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.688207] CR2: 0000000000000000 CR3: 0000000011e54000 CR4: 00000000000=
006b0
[    1.688207] Stack:
[    1.688207]  ffff8800001dacc8 0000000000000000 ffff880011db7d18 00000000=
00000970
[    1.688207]  ffff8800001dacc0 ffff880011f3cc00 ffff8800001da000 ffffffff=
fffffffb
[    1.688207]  ffff880011db7d68 ffffffff81497a1d ffff880011f3cc00 ffff8800=
11db7d80
[    1.688207] Call Trace:
[    1.688207]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.688207]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.688207]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.688207]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.688207]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.688207]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.688207]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.688207]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.688207]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.688207]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.688207]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.688207]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.688207]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.688207] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.688207] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.688207]  RSP <ffff880011db7d10>
[    1.688207] CR2: 0000000000000000
[    1.688207] ---[ end trace 5506712fb917b437 ]---
[    1.688207] note: mount[428] exited with preempt_count 2
[    1.729272] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.730581] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.731529] PGD 11ff4067 PUD 11831067 PMD 0=20
[    1.731750] Oops: 0002 [#12]=20
[    1.731750] Modules linked in:
[    1.731750] CPU: 0 PID: 434 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.731750] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.731750] task: ffff880011dd1a00 ti: ffff880011d68000 task.ti: ffff880=
011d68000
[    1.731750] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.731750] RSP: 0018:ffff880011d69d10  EFLAGS: 00010286
[    1.731750] RAX: 0000000000000000 RBX: ffff880011f97cc0 RCX: 00000000000=
00002
[    1.731750] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
97cc0
[    1.731750] RBP: ffff880011d69d50 R08: ffff880011d68000 R09: 00000000000=
00100
[    1.731750] R10: 0000000000000000 R11: ffffffff810f0d1b R12: ffff880011f=
97cc8
[    1.731750] R13: ffff880011dd1a00 R14: 00000000ffffffff R15: ffff880011f=
97000
[    1.731750] FS:  00007fec17188700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.731750] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.731750] CR2: 0000000000000000 CR3: 0000000011eb7000 CR4: 00000000000=
006b0
[    1.731750] Stack:
[    1.731750]  ffff880011f97cc8 0000000000000000 ffff880011d69d18 00000000=
00000972
[    1.731750]  ffff880011f97cc0 ffff880011f3c800 ffff880011f97000 ffffffff=
fffffffb
[    1.731750]  ffff880011d69d68 ffffffff81497a1d ffff880011f3c800 ffff8800=
11d69d80
[    1.731750] Call Trace:
[    1.731750]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.731750]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.731750]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.731750]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.731750]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.731750]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.731750]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.731750]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.731750]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.731750]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.731750]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.731750]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.731750]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.731750] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.731750] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.731750]  RSP <ffff880011d69d10>
[    1.731750] CR2: 0000000000000000
[    1.731750] ---[ end trace 5506712fb917b438 ]---
[    1.731750] note: mount[434] exited with preempt_count 2
[    1.772287] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.773590] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.774539] PGD 11ff9067 PUD 11de5067 PMD 0=20
[    1.775382] Oops: 0002 [#13]=20
[    1.775435] Modules linked in:
[    1.775435] CPU: 0 PID: 427 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.775435] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.775435] task: ffff880000fd8000 ti: ffff880011cf4000 task.ti: ffff880=
011cf4000
[    1.775435] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.775435] RSP: 0018:ffff880011cf5d10  EFLAGS: 00010286
[    1.775435] RAX: 0000000000000000 RBX: ffff880011859cc0 RCX: 00000000000=
00002
[    1.775435] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff8800118=
59cc0
[    1.775435] RBP: ffff880011cf5d50 R08: ffff880011cf4000 R09: 00000000000=
00100
[    1.775435] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff8800118=
59cc8
[    1.775435] R13: ffff880000fd8000 R14: 00000000ffffffff R15: ffff8800118=
59000
[    1.775435] FS:  00007f1713a91700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.775435] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.775435] CR2: 0000000000000000 CR3: 0000000011830000 CR4: 00000000000=
006b0
[    1.775435] Stack:
[    1.775435]  ffff880011859cc8 0000000000000000 ffff880011cf5d18 00000000=
00000971
[    1.775435]  ffff880011859cc0 ffff880011f3d800 ffff880011859000 ffffffff=
fffffffb
[    1.775435]  ffff880011cf5d68 ffffffff81497a1d ffff880011f3d800 ffff8800=
11cf5d80
[    1.775435] Call Trace:
[    1.775435]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.775435]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.775435]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.775435]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.775435]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.775435]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.775435]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.775435]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.775435]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.775435]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.775435]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.775435]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.775435]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.775435] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.775435] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.775435]  RSP <ffff880011cf5d10>
[    1.775435] CR2: 0000000000000000
[    1.775435] ---[ end trace 5506712fb917b439 ]---
[    1.775435] note: mount[427] exited with preempt_count 2
[    1.820328] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.821645] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.822598] PGD 11fea067 PUD 11824067 PMD 0=20
[    1.823411] Oops: 0002 [#14]=20
[    1.823411] Modules linked in:
[    1.823411] CPU: 0 PID: 430 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.823411] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.823411] task: ffff880011c16e80 ti: ffff880011f62000 task.ti: ffff880=
011f62000
[    1.823411] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.823411] RSP: 0018:ffff880011f63d10  EFLAGS: 00010286
[    1.823411] RAX: 0000000000000000 RBX: ffff880011f84cc0 RCX: 00000000000=
00002
[    1.823411] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
84cc0
[    1.823411] RBP: ffff880011f63d50 R08: ffff880011f62000 R09: 00000000000=
00100
[    1.823411] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011f=
84cc8
[    1.823411] R13: ffff880011c16e80 R14: 00000000ffffffff R15: ffff880011f=
84000
[    1.823411] FS:  00007f63e1d6c700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.823411] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.823411] CR2: 0000000000000000 CR3: 0000000011e38000 CR4: 00000000000=
006b0
[    1.823411] Stack:
[    1.823411]  ffff880011f84cc8 0000000000000000 ffff880011f63d18 00000000=
00000974
[    1.823411]  ffff880011f84cc0 ffff880011f3d400 ffff880011f84000 ffffffff=
fffffffb
[    1.823411]  ffff880011f63d68 ffffffff81497a1d ffff880011f3d400 ffff8800=
11f63d80
[    1.823411] Call Trace:
[    1.823411]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.823411]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.823411]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.823411]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.823411]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.823411]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.823411]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.823411]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.823411]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.823411]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.823411]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.823411]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.823411]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.823411] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.823411] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.823411]  RSP <ffff880011f63d10>
[    1.823411] CR2: 0000000000000000
[    1.823411] ---[ end trace 5506712fb917b43a ]---
[    1.823411] note: mount[430] exited with preempt_count 2
[    1.865107] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.866428] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.867378] PGD 11cf6067 PUD 11e5a067 PMD 0=20
[    1.867532] Oops: 0002 [#15]=20
[    1.867532] Modules linked in:
[    1.867532] CPU: 0 PID: 489 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.867532] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.867532] task: ffff8800007c4e00 ti: ffff880011d92000 task.ti: ffff880=
011d92000
[    1.867532] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.867532] RSP: 0018:ffff880011d93d10  EFLAGS: 00010286
[    1.867532] RAX: 0000000000000000 RBX: ffff880011f86cc0 RCX: 00000000000=
00002
[    1.867532] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
86cc0
[    1.867532] RBP: ffff880011d93d50 R08: ffff880011d92000 R09: 00000000000=
00100
[    1.867532] R10: 0000000000000000 R11: ffffffff810f0d1b R12: ffff880011f=
86cc8
[    1.867532] R13: ffff8800007c4e00 R14: 00000000ffffffff R15: ffff880011f=
86000
[    1.867532] FS:  00007f15fdde6700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.867532] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.867532] CR2: 0000000000000000 CR3: 0000000011e33000 CR4: 00000000000=
006b0
[    1.867532] Stack:
[    1.867532]  ffff880011f86cc8 0000000000000000 ffff880011d93d18 00000000=
00000970
[    1.867532]  ffff880011f86cc0 ffff880011f3dc00 ffff880011f86000 ffffffff=
fffffffb
[    1.867532]  ffff880011d93d68 ffffffff81497a1d ffff880011f3dc00 ffff8800=
11d93d80
[    1.867532] Call Trace:
[    1.867532]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.867532]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.867532]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.867532]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.867532]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.867532]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.867532]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.867532]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.867532]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.867532]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.867532]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.867532]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.867532]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.867532] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.867532] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.867532]  RSP <ffff880011d93d10>
[    1.867532] CR2: 0000000000000000
[    1.867532] ---[ end trace 5506712fb917b43b ]---
[    1.867532] note: mount[489] exited with preempt_count 2
[    1.912315] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.913641] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.914198] PGD 11835067 PUD 1180b067 PMD 0=20
[    1.914198] Oops: 0002 [#16]=20
[    1.914198] Modules linked in:
[    1.914198] CPU: 0 PID: 432 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.914198] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.914198] task: ffff880011dd3a80 ti: ffff88001183c000 task.ti: ffff880=
01183c000
[    1.914198] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.914198] RSP: 0018:ffff88001183dd10  EFLAGS: 00010286
[    1.914198] RAX: 0000000000000000 RBX: ffff88001185dcc0 RCX: 00000000000=
00002
[    1.914198] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff8800118=
5dcc0
[    1.914198] RBP: ffff88001183dd50 R08: ffff88001183c000 R09: 00000000000=
00100
[    1.914198] R10: 0000000000000000 R11: ffffffff810f0d1b R12: ffff8800118=
5dcc8
[    1.914198] R13: ffff880011dd3a80 R14: 00000000ffffffff R15: ffff8800118=
5d000
[    1.914198] FS:  00007ffad7fa9700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.914198] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.914198] CR2: 0000000000000000 CR3: 0000000011c90000 CR4: 00000000000=
006b0
[    1.914198] Stack:
[    1.914198]  ffff88001185dcc8 0000000000000000 ffff88001183dd18 00000000=
00000971
[    1.914198]  ffff88001185dcc0 ffff880011eb3c00 ffff88001185d000 ffffffff=
fffffffb
[    1.914198]  ffff88001183dd68 ffffffff81497a1d ffff880011eb3c00 ffff8800=
1183dd80
[    1.914198] Call Trace:
[    1.914198]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.914198]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.914198]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.914198]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.914198]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.914198]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.914198]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.914198]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.914198]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.914198]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.914198]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.914198]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.914198]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.914198] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.914198] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.914198]  RSP <ffff88001183dd10>
[    1.914198] CR2: 0000000000000000
[    1.914198] ---[ end trace 5506712fb917b43c ]---
[    1.914198] note: mount[432] exited with preempt_count 2
[    1.958501] block nbd2: Attempted send on closed socket
[    1.959280] HPFS: hpfs_map_sector: read error
[    1.972563] LogFS: Start mount 10
[    1.973157] block nbd2: Attempted send on closed socket
[    1.973935] LogFS: Start unmounting
[    1.975473] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    1.976785] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.977738] PGD 11fcb067 PUD 11d19067 PMD 0=20
[    1.977843] Oops: 0002 [#17]=20
[    1.977843] Modules linked in:
[    1.977843] CPU: 0 PID: 431 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    1.977843] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.977843] task: ffff880011c17500 ti: ffff880011e02000 task.ti: ffff880=
011e02000
[    1.977843] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    1.977843] RSP: 0018:ffff880011e03d10  EFLAGS: 00010286
[    1.977843] RAX: 0000000000000000 RBX: ffff880011fa0cc0 RCX: 00000000000=
00002
[    1.977843] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
a0cc0
[    1.977843] RBP: ffff880011e03d50 R08: ffff880011e02000 R09: ffff8800001=
b8f00
[    1.977843] R10: ffff8800001b8f00 R11: 0000000000000246 R12: ffff880011f=
a0cc8
[    1.977843] R13: ffff880011c17500 R14: 00000000ffffffff R15: ffff880011f=
a0000
[    1.977843] FS:  00007f9f0092d700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    1.977843] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.977843] CR2: 0000000000000000 CR3: 0000000011fd6000 CR4: 00000000000=
006b0
[    1.977843] Stack:
[    1.977843]  ffff880011fa0cc8 0000000000000000 ffff880011e03d18 00000000=
0000096e
[    1.977843]  ffff880011fa0cc0 ffff88001186d000 ffff880011fa0000 ffffffff=
fffffffb
[    1.977843]  ffff880011e03d68 ffffffff81497a1d ffff88001186d000 ffff8800=
11e03d80
[    1.977843] Call Trace:
[    1.977843]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    1.977843]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    1.977843]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    1.977843]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    1.977843]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    1.977843]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    1.977843]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    1.977843]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    1.977843]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    1.977843]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    1.977843]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    1.977843]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    1.977843]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    1.977843] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    1.977843] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    1.977843]  RSP <ffff880011e03d10>
[    1.977843] CR2: 0000000000000000
[    1.977843] ---[ end trace 5506712fb917b43d ]---
[    1.977843] note: mount[431] exited with preempt_count 2
[    2.024529] LogFS: Start mount 11
[    2.025101] block nbd10: Attempted send on closed socket
[    2.025885] LogFS: Start unmounting
[    2.026468] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    2.027531] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    2.027531] PGD 1182d067 PUD 11ddd067 PMD 0=20
[    2.027531] Oops: 0002 [#18]=20
[    2.027531] Modules linked in:
[    2.027531] CPU: 0 PID: 426 Comm: mount Tainted: G      D       3.14.0-r=
c7-next-20140321 #10
[    2.027531] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.027531] task: ffff88001237b400 ti: ffff880011eea000 task.ti: ffff880=
011eea000
[    2.027531] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex=
_lock_slowpath+0x4b/0xc2
[    2.027531] RSP: 0018:ffff880011eebd10  EFLAGS: 00010286
[    2.027531] RAX: 0000000000000000 RBX: ffff880011fa7cc0 RCX: 00000000000=
00002
[    2.027531] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011f=
a7cc0
[    2.027531] RBP: ffff880011eebd50 R08: ffff880011eea000 R09: 00000000000=
00100
[    2.027531] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011f=
a7cc8
[    2.027531] R13: ffff88001237b400 R14: 00000000ffffffff R15: ffff880011f=
a7000
[    2.027531] FS:  00007fb1e9db6700(0000) GS:ffffffff8181c000(0000) knlGS:=
0000000000000000
[    2.027531] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.027531] CR2: 0000000000000000 CR3: 0000000011d09000 CR4: 00000000000=
006b0
[    2.027531] Stack:
[    2.027531]  ffff880011fa7cc8 0000000000000000 ffff880011eebd18 00000000=
0000096f
[    2.027531]  ffff880011fa7cc0 ffff88001186c800 ffff880011fa7000 ffffffff=
fffffffb
[    2.027531]  ffff880011eebd68 ffffffff81497a1d ffff88001186c800 ffff8800=
11eebd80
[    2.027531] Call Trace:
[    2.027531]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
[    2.027531]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
[    2.027531]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
[    2.027531]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
[    2.027531]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
[    2.027531]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
[    2.027531]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
[    2.027531]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
[    2.027531]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
[    2.027531]  [<ffffffff810f938f>] do_mount+0x72f/0x826
[    2.027531]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
[    2.027531]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
[    2.027531]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
[    2.027531] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 =
48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 =
<48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44=20
[    2.027531] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
[    2.027531]  RSP <ffff880011eebd10>
[    2.027531] CR2: 0000000000000000
[    2.027531] ---[ end trace 5506712fb917b43e ]---
[    2.027531] note: mount[426] exited with preempt_count 2
[    2.284258] tsc: Refined TSC clocksource calibration: 3092.548 MHz

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-r2-03230447/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-ne=
xt-20140321 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-r2-03230447/next:master/.vmlinuz=
-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323050216-7-lkp-sb04 branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r2-03230447/06ed26d1d=
e59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 drbd.minor=
_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -=
smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::304=
29-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime=
 -pidfile /dev/shm/kboot/pid-yocto-lkp-sb04-3 -serial file:/dev/shm/kboot/s=
erial-yocto-lkp-sb04-3 -daemonize -display none -monitor null=20

--zhXaljGHf11kAtnf
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-r2-03230447-06ed26d1de59ce7cbbe68378b7e470be169750e5-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-103446.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3L25leHQ6bWFzdGVyOjNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3
MTdmNTNjY2I6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0wNzozNDozMSAzYjU1YzNjMGVj
MmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3LTNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
LzNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3LTNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNj
Y2IKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny0zYjU1YzNjMGVjMmViM2YxNjNmMTU1
NTlmMzk2MmRmNzE3ZjUzY2NiCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0Ny8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL3Zt
bGludXotMy4xNC4wLXJjNy0xMDcxMy1nM2I1NWMzYwoKMjAxNC0wMy0yMy0wNzo0ODozMSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDEuNTk4NTYyXSBMb2dG
UzogU3RhcnQgdW5tb3VudGluZwpbICAgIDEuNTk5NTc2XSBMb2dGUzogU3RhcnQgbW91bnQg
MQpbICAgIDEuNjAwNTA2XSBMb2dGUzogU3RhcnQgdW5tb3VudGluZwpbICAgIDEuNjAxNTA5
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5j
ZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgMS42MDM3MDJdIElQOiBbPGZmZmZmZmZmODE0
OTY1ODc+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg0Yi8weGMyClsgICAgMS42MDQ4MTRd
IFBHRCBkY2Y1MDY3IFBVRCBkZGQyMDY3IFBNRCAwIApbICAgIDEuNjA0ODE0XSBPb3BzOiAw
MDAyIFsjMV0gClsgICAgMS42MDQ4MTRdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuNjA0
ODE0XSBDUFU6IDAgUElEOiA0NjYgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xNC4wLXJj
Ny0xMDcxMy1nM2I1NWMzYyAjMQpbICAgIDEuNjA0ODE0XSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS42MDQ4MTRdIHRhc2s6IGZm
ZmY4ODAwMGQ4YWI5NjAgdGk6IGZmZmY4ODAwMGRjZDQwMDAgdGFzay50aTogZmZmZjg4MDAw
ZGNkNDAwMApbICAgIDEuNjA0ODE0XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxNDk2NTg3Pl0g
IFs8ZmZmZmZmZmY4MTQ5NjU4Nz5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDRiLzB4YzIK
WyAgICAxLjYwNDgxNF0gUlNQOiAwMDE4OmZmZmY4ODAwMGRjZDVkMTAgIEVGTEFHUzogMDAw
MTAyODYKWyAgICAxLjYwNDgxNF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4
MDAwZDk2NmNjMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDIKWyAgICAxLjYwNDgxNF0gUkRYOiAw
MDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDA2NyBSREk6IGZmZmY4ODAwMGQ5
NjZjYzAKWyAgICAxLjYwNDgxNF0gUkJQOiBmZmZmODgwMDBkY2Q1ZDUwIFIwODogZmZmZjg4
MDAwZGNkNDAwMCBSMDk6IDAwMDAwMDAwMDAwMGQ5NDYKWyAgICAxLjYwNDgxNF0gUjEwOiAw
MDAwMDAwMDAwMDAwMDY0IFIxMTogZmZmZmZmZmY4MTE4ODRkMiBSMTI6IGZmZmY4ODAwMGQ5
NjZjYzgKWyAgICAxLjYwNDgxNF0gUjEzOiBmZmZmODgwMDBkOGFiOTYwIFIxNDogMDAwMDAw
MDBmZmZmZmZmZiBSMTU6IGZmZmY4ODAwMGQ5NjYwMDAKWyAgICAxLjYwNDgxNF0gRlM6ICAw
MDAwN2ZlYmI4YjI1NzAwKDAwMDApIEdTOmZmZmZmZmZmODE4MWMwMDAoMDAwMCkga25sR1M6
MDAwMDAwMDAwMDAwMDAwMApbICAgIDEuNjA0ODE0XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6
IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMS42MDQ4MTRdIENSMjogMDAwMDAw
MDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMGRlNDQwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIw
ClsgICAgMS42MDQ4MTRdIFN0YWNrOgpbICAgIDEuNjA0ODE0XSAgZmZmZjg4MDAwZDk2NmNj
OCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRjZDVkMTggMDAwMDAwMDAwMDAwMDk1OApb
ICAgIDEuNjA0ODE0XSAgZmZmZjg4MDAwZDk2NmNjMCBmZmZmODgwMDBkZjZiNDAwIGZmZmY4
ODAwMGQ5NjYwMDAgZmZmZjg4MDAwZjQ0NmYwMApbICAgIDEuNjA0ODE0XSAgZmZmZjg4MDAw
ZGNkNWQ2OCBmZmZmZmZmZjgxNDk2NjI1IGZmZmY4ODAwMGRmNmI0MDAgZmZmZjg4MDAwZGNk
NWQ4MApbICAgIDEuNjA0ODE0XSBDYWxsIFRyYWNlOgpbICAgIDEuNjA0ODE0XSAgWzxmZmZm
ZmZmZjgxNDk2NjI1Pl0gbXV0ZXhfbG9jaysweDI3LzB4MmEKWyAgICAxLjYwNDgxNF0gIFs8
ZmZmZmZmZmY4MTE4YWViOD5dIGxvZ2ZzX2dldF93YmxvY2tzKzB4NTUvMHg2MApbICAgIDEu
NjA0ODE0XSAgWzxmZmZmZmZmZjgxMTg4NGU4Pl0gbG9nZnNfc3luY19mcysweDE0LzB4MzAK
WyAgICAxLjYwNDgxNF0gIFs8ZmZmZmZmZmY4MTEwMDU3OD5dIHN5bmNfZmlsZXN5c3RlbSsw
eDQ5LzB4OGUKWyAgICAxLjYwNDgxNF0gIFs8ZmZmZmZmZmY4MTE4ZTY1ZT5dIGxvZ2ZzX2tp
bGxfc2IrMHgyNy8weGRjClsgICAgMS42MDQ4MTRdICBbPGZmZmZmZmZmODEwZTE1ZjY+XSBk
ZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDJlLzB4NGYKWyAgICAxLjYwNDgxNF0gIFs8ZmZm
ZmZmZmY4MTE4ZjNjZj5dIGxvZ2ZzX21vdW50KzB4NmJkLzB4NmQ1ClsgICAgMS42MDQ4MTRd
ICBbPGZmZmZmZmZmODEwZTI3ZWU+XSBtb3VudF9mcysweDEwLzB4YTkKWyAgICAxLjYwNDgx
NF0gIFs8ZmZmZmZmZmY4MTBmNjMwNT5dIHZmc19rZXJuX21vdW50KzB4NWYvMHhlMwpbICAg
IDEuNjA0ODE0XSAgWzxmZmZmZmZmZjgxMGY4NjgzPl0gZG9fbW91bnQrMHg3MmYvMHg4MjYK
WyAgICAxLjYwNDgxNF0gIFs8ZmZmZmZmZmY4MTBiYjM2ZD5dID8gc3RybmR1cF91c2VyKzB4
MzUvMHhjYgpbICAgIDEuNjA0ODE0XSAgWzxmZmZmZmZmZjgxMGY4OTljPl0gU3lTX21vdW50
KzB4ODAvMHhiOQpbICAgIDEuNjA0ODE0XSAgWzxmZmZmZmZmZjgxNDk3ZDM3Pl0gc3lzdGVt
X2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAgMS42MDQ4MTRdIENvZGU6IDI1IDUwIGIw
IDgxIDgxIGZmIDA0IDI1IDUwIGIwIDgxIDgxIDhiIDA3IDg1IGMwIDc5IDIzIDQ4IDhiIDQz
IDEwIDRjIDhkIDYzIDA4IDQ4IDg5IDYzIDEwIDQxIDgzIGNlIGZmIDRjIDg5IDI0IDI0IDQ4
IDg5IDQ0IDI0IDA4IDw0OD4gODkgMjAgNGMgODkgNmMgMjQgMTAgZWIgMmUgMzEgYzAgODcg
MDcgZmYgYzggNzUgZDUgZWIgNDggNDQgClsgICAgMS42MDQ4MTRdIFJJUCAgWzxmZmZmZmZm
ZjgxNDk2NTg3Pl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NGIvMHhjMgpbICAgIDEuNjA0
ODE0XSAgUlNQIDxmZmZmODgwMDBkY2Q1ZDEwPgpbICAgIDEuNjA0ODE0XSBDUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjYwNDgxNF0gLS0tWyBlbmQgdHJhY2UgN2VhZTI1YzE0Njlh
ODQ3NiBdLS0tClsgICAgMS42MDQ4MTRdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVk
IGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9sb2NraW5nL3J3c2VtLmM6MjAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYjU1YzNjMGVjMmViM2YxNjNm
MTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXlvY3RvLWl2eXRvd24yLTQyOjIwMTQwMzIz
MDc0ODEzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctMTA3MTMt
ZzNiNTVjM2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzNiNTVj
M2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IvZG1lc2cteW9jdG8taXZ5dG93
bjItNDE6MjAxNDAzMjMwNzQ4MTU6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4x
NC4wLXJjNy0xMDcxMy1nM2I1NWMzYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMyMzA0NDcvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVz
Zy15b2N0by1pdnl0b3duMi01MToyMDE0MDMyMzA3NDgxNjp4ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0NzozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRm
NzE3ZjUzY2NiL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTE6MjAxNDAzMjMxNTQ4MTg6eDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy0xMDcxMy1nM2I1NWMzYzoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvM2I1NWMzYzBlYzJlYjNmMTYz
ZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVzZy15b2N0by1sa3Atc2IwNC0yMDoyMDE0MDMy
MzE1NDgyMTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3LTEwNzEz
LWczYjU1YzNjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYjU1
YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXlvY3RvLWxrcC1z
YjA0LTIzOjIwMTQwMzIzMTU0ODI5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMu
MTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3LzNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IvZG1l
c2cteW9jdG8tbGtwLXNiMDQtNjoyMDE0MDMyMzE1NDgyODp4ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0NzozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRm
NzE3ZjUzY2NiL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTE2OjIwMTQwMzIzMTU0ODMwOng4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzNiNTVjM2MwZWMyZWIzZjE2
M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IvZG1lc2cteW9jdG8tY2Fpcm8tMjA6MjAxNDAzMjMw
NzQ4MzA6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy0xMDcxMy1n
M2I1NWMzYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvM2I1NWMz
YzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVzZy15b2N0by1sa3Atc2Iw
NC00MzoyMDE0MDMyMzE1NDgzMTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0
LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0Ny8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNn
LXlvY3RvLWxrcC1zYjA0LTU1OjIwMTQwMzIzMTU0ODMyOng4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3OjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQowOjExOjEwIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgM2I1NWMzYzBlYzJlYjNm
MTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYgpnaXQgY2hlY2tvdXQgdjMuMTMKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
L25leHQ6bWFzdGVyOmQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmU6
YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0wNzo0OToxNSBkOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
LWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2Q4ZWMyNmQ3
ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3LWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQy
MTBmMGU2NGJlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Ny9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL3ZtbGludXotMy4x
My4wCgoyMDE0LTAzLTIzLTA4OjAwOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBG
QUlMVVJFClsgICAgMi4xNTk5NTldIEZBVC1mcyAobmJkNCk6IHVuYWJsZSB0byByZWFkIGJv
b3Qgc2VjdG9yClsgICAgMi4xNjI2MDVdIGJsb2NrIG5iZDk6IEF0dGVtcHRlZCBzZW5kIG9u
IGNsb3NlZCBzb2NrZXQKWyAgICAyLjE2NDg2NV0gRkFULWZzIChuYmQ5KTogdW5hYmxlIHRv
IHJlYWQgYm9vdCBzZWN0b3IKWyAgICAyLjE2NzEyMV0gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQpb
ICAgIDIuMTcwNDI1XSBJUDogWzxmZmZmZmZmZjgxNDgzODcxPl0gX19tdXRleF9sb2NrX3Ns
b3dwYXRoKzB4NGIvMHhjMgpbICAgIDIuMTcwNDI1XSBQR0QgMTFkYjEwNjcgUFVEIDExZGIy
MDY3IFBNRCAwIApbICAgIDIuMTcwNDI1XSBPb3BzOiAwMDAyIFsjMV0gClsgICAgMi4xNzA0
MjVdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDIuMTcwNDI1XSBDUFU6IDAgUElEOiA0MTAg
Q29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xMy4wICMxClsgICAgMi4xNzA0MjVdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjE3
MDQyNV0gdGFzazogZmZmZjg4MDAwMDYwYjJhMCB0aTogZmZmZjg4MDAxMWNiNjAwMCB0YXNr
LnRpOiBmZmZmODgwMDExY2I2MDAwClsgICAgMi4xNzA0MjVdIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODE0ODM4NzE+XSAgWzxmZmZmZmZmZjgxNDgzODcxPl0gX19tdXRleF9sb2NrX3Nsb3dw
YXRoKzB4NGIvMHhjMgpbICAgIDIuMTcwNDI1XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMWNiN2Qw
MCAgRUZMQUdTOiAwMDAxMDI4NgpbICAgIDIuMTcwNDI1XSBSQVg6IDAwMDAwMDAwMDAwMDAw
MDAgUkJYOiBmZmZmODgwMDExZGJlY2MwIFJDWDogMDAwMDAwMDAwMDAwMDAwMgpbICAgIDIu
MTcwNDI1XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDYwIFJE
STogZmZmZjg4MDAxMWRiZWNjMApbICAgIDIuMTcwNDI1XSBSQlA6IGZmZmY4ODAwMTFjYjdk
NDggUjA4OiBmZmZmODgwMDExY2I2MDAwIFIwOTogMDAwMDAwMDAwMDAwMDEwMApbICAgIDIu
MTcwNDI1XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiBmZmZmZmZmZjgxMDgxNWQ2IFIx
MjogZmZmZjg4MDAxMWRiZWNjOApbICAgIDIuMTcwNDI1XSBSMTM6IGZmZmY4ODAwMDA2MGIy
YTAgUjE0OiAwMDAwMDAwMGZmZmZmZmZmIFIxNTogZmZmZjg4MDAxMWRiZTAwMApbICAgIDIu
MTcwNDI1XSBGUzogIDAwMDA3Zjc4NTkyOWI3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTgxYzAw
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMi4xNzA0MjVdIENTOiAgMDAx
MCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAyLjE3MDQy
NV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAxMWNiMDAwMCBDUjQ6IDAw
MDAwMDAwMDAwMDA2YjAKWyAgICAyLjE3MDQyNV0gU3RhY2s6ClsgICAgMi4xNzA0MjVdICBm
ZmZmODgwMDExZGJlY2M4IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWNiN2QxMCBmZmZm
ODgwMDExY2I3ZDEwClsgICAgMi4xNzA0MjVdICAwMDAwMDAwMDAwMDAwODE3IGZmZmY4ODAw
MTFkYmVjYzAgMDAwMDAwMDBmZmZlYTJjYyBmZmZmODgwMDExZGJlMDAwClsgICAgMi4xNzA0
MjVdICBmZmZmODgwMDEzMzVkMzQwIGZmZmY4ODAwMTFjYjdkNjAgZmZmZmZmZmY4MTQ4Mzkw
ZiBmZmZmODgwMDExYzM1NDAwClsgICAgMi4xNzA0MjVdIENhbGwgVHJhY2U6ClsgICAgMi4x
NzA0MjVdICBbPGZmZmZmZmZmODE0ODM5MGY+XSBtdXRleF9sb2NrKzB4MjcvMHgyYQpbICAg
IDIuMTcwNDI1XSAgWzxmZmZmZmZmZjgxMTg3Njk1Pl0gbG9nZnNfZ2V0X3dibG9ja3MrMHg1
NS8weDYwClsgICAgMi4xNzA0MjVdICBbPGZmZmZmZmZmODExODRjYzU+XSBsb2dmc19zeW5j
X2ZzKzB4MTQvMHgzMApbICAgIDIuMTcwNDI1XSAgWzxmZmZmZmZmZjgxMGZkOGNhPl0gc3lu
Y19maWxlc3lzdGVtKzB4NTIvMHg5YwpbICAgIDIuMTcwNDI1XSAgWzxmZmZmZmZmZjgxMThh
ZTM1Pl0gbG9nZnNfa2lsbF9zYisweDI3LzB4ZGMKWyAgICAyLjE3MDQyNV0gIFs8ZmZmZmZm
ZmY4MTBkZTc4MT5dIGRlYWN0aXZhdGVfbG9ja2VkX3N1cGVyKzB4MmUvMHg0ZgpbICAgIDIu
MTcwNDI1XSAgWzxmZmZmZmZmZjgxMThiYmE2Pl0gbG9nZnNfbW91bnQrMHg2YmQvMHg2ZDUK
WyAgICAyLjE3MDQyNV0gIFs8ZmZmZmZmZmY4MTBkZjk4MT5dIG1vdW50X2ZzKzB4MTAvMHhh
OQpbICAgIDIuMTcwNDI1XSAgWzxmZmZmZmZmZjgxMGYzNWMwPl0gdmZzX2tlcm5fbW91bnQr
MHg1Zi8weGUzClsgICAgMi4xNzA0MjVdICBbPGZmZmZmZmZmODEwZjU5NDM+XSBkb19tb3Vu
dCsweDcyZi8weDgyNgpbICAgIDIuMTcwNDI1XSAgWzxmZmZmZmZmZjgxMGI4NjU5Pl0gPyBz
dHJuZHVwX3VzZXIrMHgzNS8weGNiClsgICAgMi4xNzA0MjVdICBbPGZmZmZmZmZmODEwZjVj
NWM+XSBTeVNfbW91bnQrMHg4MC8weGI5ClsgICAgMi4xNzA0MjVdICBbPGZmZmZmZmZmODE0
ODUwMzc+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKWyAgICAyLjE3MDQyNV0g
Q29kZTogMjUgNTAgYjAgODEgODEgZmYgMDQgMjUgNTAgYjAgODEgODEgOGIgMDcgODUgYzAg
NzkgMjMgNDggOGIgNDMgMTAgNGMgOGQgNjMgMDggNDggODkgNjMgMTAgNDEgODMgY2UgZmYg
NGMgODkgMjQgMjQgNDggODkgNDQgMjQgMDggPDQ4PiA4OSAyMCA0YyA4OSA2YyAyNCAxMCBl
YiAyZSAzMSBjMCA4NyAwNyBmZiBjOCA3NSBkNSBlYiA0OCA0NCAKWyAgICAyLjE3MDQyNV0g
UklQICBbPGZmZmZmZmZmODE0ODM4NzE+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg0Yi8w
eGMyClsgICAgMi4xNzA0MjVdICBSU1AgPGZmZmY4ODAwMTFjYjdkMDA+ClsgICAgMi4xNzA0
MjVdIENSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuMTcwNDI1XSAtLS1bIGVuZCB0cmFj
ZSAxMDgyY2QzOGE3ODIyNjVmIF0tLS0KWyAgICAyLjE3MDQyNV0gQlVHOiBzbGVlcGluZyBm
dW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVsL2xvY2tpbmcv
cndzZW0uYzoyMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2Q4ZWMy
NmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8taXZ5dG93
bjItMjg6MjAxNDAzMjMwODAwMDI6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4x
My4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9kOGVjMjZkN2Y4
Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTQ3
OjIwMTQwMzIzMTYwMDAxOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTMuMDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1sa3Atc2IwNC01MToyMDE0
MDMyMzE2MDAwMTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEzLjA6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0
OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8taXZ5dG93bjItMzk6MjAxNDAzMjMw
ODAwMDQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMy4wOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWl2eXRvd24yLTg5OjIwMTQwMzIzMDgwMDA1
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTMuMDoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDcvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0
MjEwZjBlNjRiZS9kbWVzZy15b2N0by1sa3Atc2IwNC0xNToyMDE0MDMyMzE2MDAxMTp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYw
ZTY0YmUvZG1lc2cteW9jdG8tbGtwLXNiMDQtNjoyMDE0MDMyMzE2MDAwNTp4ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUv
ZG1lc2cteW9jdG8taXZ5dG93bjItMzQ6MjAxNDAzMjMwODAwMTQ6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDc6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0Ny9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNn
LXlvY3RvLWl2eXRvd24yLTM2OjIwMTQwMzIzMDgwMDE2Ong4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3OjMuMTMuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDcvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0
by1pdnl0b3duMi02NjoyMDE0MDMyMzA4MDAxNzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIz
MDQ0NzozLjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2Q4
ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8taXZ5
dG93bjItODoyMDE0MDMyMzA4MDAxNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Nzoz
LjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2Q4ZWMyNmQ3
ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tbGtwLXNiMDQt
NDc6MjAxNDAzMjMxNjAwMTc6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMy4w
OjEKMDoxMjo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21t
aXQgdjMuMTMKZ2l0IGNoZWNrb3V0IHYzLjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9uZXh0Om1hc3Rlcjo1ZTAx
ZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1saW51eDcKCjIw
MTQtMDMtMjMtMDg6MDE6MjIgNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVj
ZWI1MiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny01ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVk
YTk4Y2NiZDZhNWNlYjUyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny01ZTAxZGM3YjI2
ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDctNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNWUwMWRjN2IyNmQ5ZjI0
ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi92bWxpbnV6LTMuMTIuMAoKMjAxNC0wMy0yMy0w
ODoxNToyNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDEuNjMx
NDYzXSBibG9jayBuYmQwOiBBdHRlbXB0ZWQgc2VuZCBvbiBjbG9zZWQgc29ja2V0ClsgICAg
MS42MzI4NDhdIExvZ0ZTOiBTdGFydCB1bm1vdW50aW5nClsgICAgMS42MzM4OTddIExvZ0ZT
OiBTdGFydCB1bm1vdW50aW5nClsgICAgMS42MzUwMzNdIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkK
WyAgICAxLjYzNzIxNV0gSVA6IFs8ZmZmZmZmZmY4MTQ3ZDc5ZD5dIF9fbXV0ZXhfbG9ja19z
bG93cGF0aCsweDYyLzB4ZTkKWyAgICAxLjYzNzIxNV0gUEdEIDExYzk1MDY3IFBVRCAxMWQy
YTA2NyBQTUQgMCAKWyAgICAxLjYzNzIxNV0gT29wczogMDAwMiBbIzFdIApbICAgIDEuNjM3
MjE1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjYzNzIxNV0gQ1BVOiAwIFBJRDogMzkw
IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTIuMCAjMQpbICAgIDEuNjM3MjE1XSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS42
MzcyMTVdIHRhc2s6IGZmZmY4ODAwMDBmZTUxMTAgdGk6IGZmZmY4ODAwMTFkNzgwMDAgdGFz
ay50aTogZmZmZjg4MDAxMWQ3ODAwMApbICAgIDEuNjM3MjE1XSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxNDdkNzlkPl0gIFs8ZmZmZmZmZmY4MTQ3ZDc5ZD5dIF9fbXV0ZXhfbG9ja19zbG93
cGF0aCsweDYyLzB4ZTkKWyAgICAxLjYzNzIxNV0gUlNQOiAwMDE4OmZmZmY4ODAwMTFkNzlk
MDAgIEVGTEFHUzogMDAwMTAyODYKWyAgICAxLjYzNzIxNV0gUkFYOiAwMDAwMDAwMDAwMDAw
MDAwIFJCWDogZmZmZjg4MDAxMWQ5MWNjMCBSQ1g6IGZmZmY4ODAwMDBmZTUxMTAKWyAgICAx
LjYzNzIxNV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDA2MCBS
REk6IGZmZmY4ODAwMTFkOTFjYzAKWyAgICAxLjYzNzIxNV0gUkJQOiBmZmZmODgwMDExZDc5
ZDUwIFIwODogZmZmZjg4MDAxMWQ3ODAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAx
LjYzNzIxNV0gUjEwOiBmZmZmODgwMDAwMDg3ZmQ4IFIxMTogZmZmZjg4MDAwMDA4N2ZkOCBS
MTI6IGZmZmY4ODAwMTFkNzlmZDgKWyAgICAxLjYzNzIxNV0gUjEzOiBmZmZmODgwMDExZDkx
Y2M4IFIxNDogZmZmZjg4MDAwMGZlNTExMCBSMTU6IGZmZmY4ODAwMTFkNzlmZDgKWyAgICAx
LjYzNzIxNV0gRlM6ICAwMDAwN2YyYjQ4MDQxNzAwKDAwMDApIEdTOmZmZmZmZmZmODE4MWMw
MDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDEuNjM3MjE1XSBDUzogIDAw
MTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMS42Mzcy
MTVdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMTFjMDEwMDAgQ1I0OiAw
MDAwMDAwMDAwMDAwNmIwClsgICAgMS42MzcyMTVdIFN0YWNrOgpbICAgIDEuNjM3MjE1XSAg
ZmZmZjg4MDAxMWQ5MWNjOCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
Zjg4MDAxMWQ3OWQxOApbICAgIDEuNjM3MjE1XSAgZmZmZjg4MDAxMWQ3OWQxOCBmZmZmODgw
MDExZDkxY2MwIGZmZmY4ODAwMTFkNTc4MDAgZmZmZjg4MDAxMWQ5MTAwMApbICAgIDEuNjM3
MjE1XSAgZmZmZmZmZmZmZmZmZmZmYiBmZmZmODgwMDExZDkxMDAwIGZmZmY4ODAwMTFkNzlk
NjggZmZmZmZmZmY4MTQ3ZDg0YgpbICAgIDEuNjM3MjE1XSBDYWxsIFRyYWNlOgpbICAgIDEu
NjM3MjE1XSAgWzxmZmZmZmZmZjgxNDdkODRiPl0gbXV0ZXhfbG9jaysweDI3LzB4MmEKWyAg
ICAxLjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTE4ODE3Yz5dIGxvZ2ZzX2dldF93YmxvY2tzKzB4
NTUvMHg2MApbICAgIDEuNjM3MjE1XSAgWzxmZmZmZmZmZjgxMTg1NzIxPl0gbG9nZnNfc3lu
Y19mcysweDE0LzB4MzAKWyAgICAxLjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTBmYmQ3MT5dIHN5
bmNfZmlsZXN5c3RlbSsweDQ5LzB4OGUKWyAgICAxLjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTE4
Yjk4Nj5dIGxvZ2ZzX2tpbGxfc2IrMHgyNy8weGRjClsgICAgMS42MzcyMTVdICBbPGZmZmZm
ZmZmODEwZGJjMDA+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDI4LzB4NTQKWyAgICAx
LjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTE4YzZmNz5dIGxvZ2ZzX21vdW50KzB4NmJkLzB4NmQ1
ClsgICAgMS42MzcyMTVdICBbPGZmZmZmZmZmODEwZGQwMGI+XSBtb3VudF9mcysweDEwLzB4
YTkKWyAgICAxLjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTBmMTg4ZD5dIHZmc19rZXJuX21vdW50
KzB4NWYvMHhlMQpbICAgIDEuNjM3MjE1XSAgWzxmZmZmZmZmZjgxMGYzYjg0Pl0gZG9fbW91
bnQrMHg3M2QvMHg4MzQKWyAgICAxLjYzNzIxNV0gIFs8ZmZmZmZmZmY4MTBiNGFkNz5dID8g
c3RybmR1cF91c2VyKzB4MzUvMHhjYgpbICAgIDEuNjM3MjE1XSAgWzxmZmZmZmZmZjgxMGYz
Y2ZiPl0gU3lTX21vdW50KzB4ODAvMHhiOQpbICAgIDEuNjM3MjE1XSAgWzxmZmZmZmZmZjgx
NDdmZGY3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAgMS42MzcyMTVd
IENvZGU6IDgwIDQ0IGUwIGZmIGZmIDhiIDA3IDg1IGMwIDc5IDJhIDQ4IDhiIDQzIDEwIDRj
IDhkIDZiIDA4IDQ4IDg5IDYzIDEwIDRjIDhiIDI0IDI1IDYwIGIwIDgxIDgxIDRjIDg5IDJj
IDI0IDRkIDg5IGU3IDQ4IDg5IDQ0IDI0IDA4IDw0OD4gODkgMjAgNGMgODkgNzQgMjQgMTAg
ZWIgMmUgMzEgYzAgODcgMDcgZmYgYzggNzUgY2UgZWIgNDggODMgClsgICAgMS42MzcyMTVd
IFJJUCAgWzxmZmZmZmZmZjgxNDdkNzlkPl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NjIv
MHhlOQpbICAgIDEuNjM3MjE1XSAgUlNQIDxmZmZmODgwMDExZDc5ZDAwPgpbICAgIDEuNjM3
MjE1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjcxOTYyMV0gLS0tWyBlbmQgdHJh
Y2UgYzM1NDI4NTU3ODg4ODQ4MyBdLS0tClsgICAgMS43MjA4ODJdIEJVRzogc2xlZXBpbmcg
ZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9yd3NlbS5j
OjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNWUwMWRjN2IyNmQ5
ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1sa3Atc2IwNC05OjIw
MTQwMzIzMTYxNTIzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTIuMDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNWUwMWRjN2IyNmQ5ZjI0ZjM5
YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1pdnl0b3duMi0zNDoyMDE0MDMy
MzA4MTUyOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEyLjA6MQowOjI6MSBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjEyCmdp
dCBjaGVja291dCB2My4xMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4
ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIzLTA4
OjE2OjMzIDZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3
ZjcwYTk0YzE5MjEzZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjItMDMyMzA0NDcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5
MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctNmU0NjY0NTI1YjFkYjI4ZjhjNGUx
MTMwOTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTZlNDY2
NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1
N2Y3MGE5NGMxOTIxM2Uvdm1saW51ei0zLjExLjAKCjIwMTQtMDMtMjMtMDg6Mzk6MzQgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTcgVEVTVCBGQUlMVVJFClsgICAgMS40MTk1NzddIGJsb2Nr
IG5iZDE6IEF0dGVtcHRlZCBzZW5kIG9uIGNsb3NlZCBzb2NrZXQKWyAgICAxLjQyMDYwMV0g
YmxvY2sgbmJkOTogQXR0ZW1wdGVkIHNlbmQgb24gY2xvc2VkIHNvY2tldApbICAgIDEuNDIx
NTc0XSBIUEZTOiBocGZzX21hcF9zZWN0b3I6IHJlYWQgZXJyb3IKWyAgICAxLjQyMjQ3Nl0g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YXQgICAgICAgICAgIChudWxsKQpbICAgIDEuNDIzODEzXSBJUDogWzxmZmZmZmZmZjgxNDZj
ZWY1Pl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NTEvMHhlYQpbICAgIDEuNDIzODEzXSBQ
R0QgZDgwMzA2NyBQVUQgZGZkZDA2NyBQTUQgMCAKWyAgICAxLjQyMzgxM10gT29wczogMDAw
MiBbIzFdIApbICAgIDEuNDIzODEzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjQyMzgx
M10gQ1BVOiAwIFBJRDogNDE4IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTEuMCAjMQpb
ICAgIDEuNDIzODEzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMS40MjM4MTNdIHRhc2s6IGZmZmY4ODAwMGQ4NThiNjAgdGk6IGZm
ZmY4ODAwMGQ4MmEwMDAgdGFzay50aTogZmZmZjg4MDAwZDgyYTAwMApbICAgIDEuNDIzODEz
XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxNDZjZWY1Pl0gIFs8ZmZmZmZmZmY4MTQ2Y2VmNT5d
IF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUxLzB4ZWEKWyAgICAxLjQyMzgxM10gUlNQOiAw
MDE4OmZmZmY4ODAwMGQ4MmJkMDAgIEVGTEFHUzogMDAwMTAyMDIKWyAgICAxLjQyMzgxM10g
UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAwZjg5N2NjMCBSQ1g6IGZmZmY4
ODAwMGQ4NThiNjAKWyAgICAxLjQyMzgxM10gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTog
MDAwMDAwMDAwMDAwMDA2MCBSREk6IGZmZmY4ODAwMGY4OTdjYzAKWyAgICAxLjQyMzgxM10g
UkJQOiBmZmZmODgwMDBkODJiZDUwIFIwODogZmZmZjg4MDAwZDgyYTAwMCBSMDk6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjQyMzgxM10gUjEwOiBmZmZmODgwMDBlNzkzZmQ4IFIxMTog
ZmZmZjg4MDAwZTc5M2ZkOCBSMTI6IGZmZmY4ODAwMGQ4OWQ4MDAKWyAgICAxLjQyMzgxM10g
UjEzOiBmZmZmODgwMDBmODk3Y2M4IFIxNDogZmZmZjg4MDAwZDg1OGI2MCBSMTU6IGZmZmY4
ODAwMGY4OTcwMDAKWyAgICAxLjQyMzgxM10gRlM6ICAwMDAwN2Y5NDM4ZWJiNzAwKDAwMDAp
IEdTOmZmZmZmZmZmODE4MWMwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAg
IDEuNDIzODEzXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDNiClsgICAgMS40MjM4MTNdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAw
MDAwMGRlY2YwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAgMS40MjM4MTNdIFN0YWNr
OgpbICAgIDEuNDIzODEzXSAgZmZmZjg4MDAwZjg5N2NjOCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZDgyYmQxOApbICAgIDEuNDIzODEzXSAgZmZmZjg4
MDAwZDgyYmQxOCBmZmZmODgwMDBmODk3Y2MwIGZmZmY4ODAwMGQ4OWQ4MDAgZmZmZjg4MDAw
Zjg5NzAwMApbICAgIDEuNDIzODEzXSAgZmZmZmZmZmZmZmZmZmZmYiBmZmZmODgwMDBmODk3
MDAwIGZmZmY4ODAwMGQ4MmJkNjggZmZmZmZmZmY4MTQ2Yzc0MgpbICAgIDEuNDIzODEzXSBD
YWxsIFRyYWNlOgpbICAgIDEuNDIzODEzXSAgWzxmZmZmZmZmZjgxNDZjNzQyPl0gbXV0ZXhf
bG9jaysweDI3LzB4MmEKWyAgICAxLjQyMzgxM10gIFs8ZmZmZmZmZmY4MTE4NDY1Mj5dIGxv
Z2ZzX2dldF93YmxvY2tzKzB4NTUvMHg2MApbICAgIDEuNDIzODEzXSAgWzxmZmZmZmZmZjgx
MTgxYmY5Pl0gbG9nZnNfc3luY19mcysweDE0LzB4MzAKWyAgICAxLjQyMzgxM10gIFs8ZmZm
ZmZmZmY4MTBmOGVmMD5dIHN5bmNfZmlsZXN5c3RlbSsweDQ5LzB4OGUKWyAgICAxLjQyMzgx
M10gIFs8ZmZmZmZmZmY4MTE4N2U1Yz5dIGxvZ2ZzX2tpbGxfc2IrMHgyNy8weGRjClsgICAg
MS40MjM4MTNdICBbPGZmZmZmZmZmODEwZDkzY2Q+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBl
cisweDI4LzB4NTQKWyAgICAxLjQyMzgxM10gIFs8ZmZmZmZmZmY4MTE4OGJlZj5dIGxvZ2Zz
X21vdW50KzB4NmRmLzB4NmYyClsgICAgMS40MjM4MTNdICBbPGZmZmZmZmZmODEwZGE3MDk+
XSBtb3VudF9mcysweDEwLzB4YTkKWyAgICAxLjQyMzgxM10gIFs8ZmZmZmZmZmY4MTBlZWIz
OD5dIHZmc19rZXJuX21vdW50KzB4NWYvMHhlMQpbICAgIDEuNDIzODEzXSAgWzxmZmZmZmZm
ZjgxMGYwZGFmPl0gZG9fbW91bnQrMHg2ZjMvMHg3ZDcKWyAgICAxLjQyMzgxM10gIFs8ZmZm
ZmZmZmY4MTBiMzBhMj5dID8gc3RybmR1cF91c2VyKzB4MzUvMHhjYgpbICAgIDEuNDIzODEz
XSAgWzxmZmZmZmZmZjgxMGYwZjEzPl0gU3lTX21vdW50KzB4ODAvMHhiOQpbICAgIDEuNDIz
ODEzXSAgWzxmZmZmZmZmZjgxNDZmNGE3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8w
eDFiClsgICAgMS40MjM4MTNdIENvZGU6IGVjIDIwIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhi
IDA0IDI1IDYwIGIwIDgxIDgxIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDQ3IDEwIDRjIDhk
IDZmIDA4IDQ4IDg5IDY3IDEwIDRjIDg5IDJjIDI0IDQ4IDg5IDQ0IDI0IDA4IDw0OD4gODkg
MjAgOGIgMDcgNGMgODkgNzQgMjQgMTAgODUgYzAgNzkgMGQgNGMgOGIgMjQgMjUgNjAgYjAg
ODEgClsgICAgMS40MjM4MTNdIFJJUCAgWzxmZmZmZmZmZjgxNDZjZWY1Pl0gX19tdXRleF9s
b2NrX3Nsb3dwYXRoKzB4NTEvMHhlYQpbICAgIDEuNDIzODEzXSAgUlNQIDxmZmZmODgwMDBk
ODJiZDAwPgpbICAgIDEuNDIzODEzXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjQ3
OTEzMV0gLS0tWyBlbmQgdHJhY2UgOWFjMmMxODViY2E3MTAyNCBdLS0tClsgICAgMS40Nzk5
NzBdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0
IGF0IGtlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15
b2N0by1pbm4tMzA6MjAxNDAzMjMwODM4MjM6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItNzg6
MjAxNDAzMjMwODM4MjQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMS4wOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny82ZTQ2NjQ1MjViMWRiMjhm
OGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWl2eXRvd24yLTc6MjAxNDAz
MjMwODM4MjQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMS4wOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWl2eXRvd24yLTkwOjIwMTQwMzIzMDgz
ODI2Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTEuMDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3
ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1sa3Atc2IwNC0xMToyMDE0MDMyMzE2MzgyODp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjExLjA6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2UvZG1lc2cteW9jdG8tbGtwLXNiMDQtMTQ6MjAxNDAzMjMxNjM4MjU6eDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMS4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0Ny82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTky
MTNlL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTUxOjIwMTQwMzIzMTYzODI1Ong4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3OjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9k
bWVzZy15b2N0by1yb2FtLTEwOjIwMTQwMzIzMDgzODI4Ong4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3OjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0
by1yb2FtLTI5OjIwMTQwMzIzMDgzODI4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
OjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNmU0NjY0
NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by14Ym0tMzoy
MDE0MDMyMzA4MzgyMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjExLjA6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzZlNDY2NDUyNWIxZGIyOGY4
YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItNzoyMDE0MDMy
MzA4MzgzMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjExLjA6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItODI6MjAxNDAzMjMwODM4
MzI6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMS4wOjEKOToxMjoxMiBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0yMyAwODo0MDoyNCBSRVBF
QVQgQ09VTlQ6IDI3ICAjIC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMQpnaXQgY2hlY2tvdXQgdjMuMTAKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3L25leHQ6bWFzdGVyOjhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3
OWUzNzY6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0wODo0MDo1NiA4YmI0OTVlM2YwMjQw
MWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3Lzhi
YjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny04YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0Ny84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L3ZtbGlu
dXotMy4xMC4wCgoyMDE0LTAzLTIzLTA4OjU0OjU3IGRldGVjdGluZyBib290IHN0YXRlIAkx
IFRFU1QgRkFJTFVSRQpbICAgIDEuODE1MzI0XSBMb2dGUzogU3RhcnQgbW91bnQgNQpbICAg
IDEuODE2NDkzXSBibG9jayBuYmQxMjogQXR0ZW1wdGVkIHNlbmQgb24gY2xvc2VkIHNvY2tl
dApbICAgIDEuODE4MTkwXSBibG9jayBuYmQyOiBBdHRlbXB0ZWQgc2VuZCBvbiBjbG9zZWQg
c29ja2V0ClsgICAgMS44MTk4OTJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICAxLjgyMjY0
M10gSVA6IFs8ZmZmZmZmZmY4MTQ2YWEyNT5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUx
LzB4ZWEKWyAgICAxLjgyMzE0OV0gUEdEIDExOTI5MDY3IFBVRCAxMWIxNzA2NyBQTUQgMCAK
WyAgICAxLjgyMzE0OV0gT29wczogMDAwMiBbIzFdIApbICAgIDEuODIzMTQ5XSBNb2R1bGVz
IGxpbmtlZCBpbjoKWyAgICAxLjgyMzE0OV0gQ1BVOiAwIFBJRDogMzc3IENvbW06IG1vdW50
IE5vdCB0YWludGVkIDMuMTAuMCAjMQpbICAgIDEuODIzMTQ5XSBIYXJkd2FyZSBuYW1lOiBC
b2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS44MjMxNDldIHRhc2s6
IGZmZmY4ODAwMTFhZTk2YzAgdGk6IGZmZmY4ODAwMTFiOGUwMDAgdGFzay50aTogZmZmZjg4
MDAxMWI4ZTAwMApbICAgIDEuODIzMTQ5XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxNDZhYTI1
Pl0gIFs8ZmZmZmZmZmY4MTQ2YWEyNT5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUxLzB4
ZWEKWyAgICAxLjgyMzE0OV0gUlNQOiAwMDE4OmZmZmY4ODAwMTFiOGZkMDAgIEVGTEFHUzog
MDAwMTAyMDIKWyAgICAxLjgyMzE0OV0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZm
Zjg4MDAxMTQwZmNjMCBSQ1g6IGZmZmY4ODAwMTFhZTk2YzAKWyAgICAxLjgyMzE0OV0gUkRY
OiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDA1ZiBSREk6IGZmZmY4ODAw
MTE0MGZjYzAKWyAgICAxLjgyMzE0OV0gUkJQOiBmZmZmODgwMDExYjhmZDUwIFIwODogZmZm
Zjg4MDAxMWI4ZTAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjgyMzE0OV0gUjEw
OiBmZmZmODgwMDEyMzg5ZmQ4IFIxMTogZmZmZjg4MDAxMjM4OWZkOCBSMTI6IGZmZmY4ODAw
MTFhOWIwMDAKWyAgICAxLjgyMzE0OV0gUjEzOiBmZmZmODgwMDExNDBmY2M4IFIxNDogZmZm
Zjg4MDAxMWFlOTZjMCBSMTU6IGZmZmY4ODAwMTE0MGYwMDAKWyAgICAxLjgyMzE0OV0gRlM6
ICAwMDAwN2ZlMjk4OGU2NzAwKDAwMDApIEdTOmZmZmZmZmZmODE4MWMwMDAoMDAwMCkga25s
R1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDEuODIzMTQ5XSBDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMS44MjMxNDldIENSMjogMDAw
MDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMTFiMGIwMDAgQ1I0OiAwMDAwMDAwMDAwMDAw
NmIwClsgICAgMS44MjMxNDldIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAw
MDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS44MjMxNDldIERSMzogMDAw
MDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAw
NDAwClsgICAgMS44MjMxNDldIFN0YWNrOgpbICAgIDEuODIzMTQ5XSAgZmZmZjg4MDAxMTQw
ZmNjOCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWI4ZmQx
OApbICAgIDEuODIzMTQ5XSAgZmZmZjg4MDAxMWI4ZmQxOCBmZmZmODgwMDExNDBmY2MwIGZm
ZmY4ODAwMTFhOWIwMDAgZmZmZjg4MDAxMTQwZjAwMApbICAgIDEuODIzMTQ5XSAgZmZmZmZm
ZmZmZmZmZmZmYiBmZmZmODgwMDExNDBmMDAwIGZmZmY4ODAwMTFiOGZkNjggZmZmZmZmZmY4
MTQ2YTZiNgpbICAgIDEuODIzMTQ5XSBDYWxsIFRyYWNlOgpbICAgIDEuODIzMTQ5XSAgWzxm
ZmZmZmZmZjgxNDZhNmI2Pl0gbXV0ZXhfbG9jaysweDI3LzB4MmEKWyAgICAxLjgyMzE0OV0g
IFs8ZmZmZmZmZmY4MTE4ODE0Zj5dIGxvZ2ZzX2dldF93YmxvY2tzKzB4NTUvMHg2MApbICAg
IDEuODIzMTQ5XSAgWzxmZmZmZmZmZjgxMTg1NmY2Pl0gbG9nZnNfc3luY19mcysweDE0LzB4
MzAKWyAgICAxLjgyMzE0OV0gIFs8ZmZmZmZmZmY4MTBmY2U5Nj5dIHN5bmNfZmlsZXN5c3Rl
bSsweDQ5LzB4OGUKWyAgICAxLjgyMzE0OV0gIFs8ZmZmZmZmZmY4MTE4Yjk1OT5dIGxvZ2Zz
X2tpbGxfc2IrMHgyNy8weGRjClsgICAgMS44MjMxNDldICBbPGZmZmZmZmZmODEwZGQ0NDg+
XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDI4LzB4NTQKWyAgICAxLjgyMzE0OV0gIFs8
ZmZmZmZmZmY4MTE4YzZlYz5dIGxvZ2ZzX21vdW50KzB4NmRmLzB4NmYyClsgICAgMS44MjMx
NDldICBbPGZmZmZmZmZmODEwZGU3OTU+XSBtb3VudF9mcysweDEwLzB4YTkKWyAgICAxLjgy
MzE0OV0gIFs8ZmZmZmZmZmY4MTBmMmE2OT5dIHZmc19rZXJuX21vdW50KzB4NWYvMHhlMQpb
ICAgIDEuODIzMTQ5XSAgWzxmZmZmZmZmZjgxMGY0Y2UyPl0gZG9fbW91bnQrMHg2ZjMvMHg3
ZDcKWyAgICAxLjgyMzE0OV0gIFs8ZmZmZmZmZmY4MTBiNzg5Mj5dID8gc3RybmR1cF91c2Vy
KzB4MzUvMHhjYgpbICAgIDEuODIzMTQ5XSAgWzxmZmZmZmZmZjgxMGY0ZTQ2Pl0gU3lTX21v
dW50KzB4ODAvMHhiOQpbICAgIDEuODIzMTQ5XSAgWzxmZmZmZmZmZjgxNDZjYzI3Pl0gc3lz
dGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAgMS44MjMxNDldIENvZGU6IGVjIDIw
IGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDA0IDI1IDYwIGIwIDgxIDgxIGZmIDgwIDQ0IGUw
IGZmIGZmIDQ4IDhiIDQ3IDEwIDRjIDhkIDZmIDA4IDQ4IDg5IDY3IDEwIDRjIDg5IDJjIDI0
IDQ4IDg5IDQ0IDI0IDA4IDw0OD4gODkgMjAgOGIgMDcgNGMgODkgNzQgMjQgMTAgODUgYzAg
NzkgMGQgNGMgOGIgMjQgMjUgNjAgYjAgODEgClsgICAgMS44MjMxNDldIFJJUCAgWzxmZmZm
ZmZmZjgxNDZhYTI1Pl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NTEvMHhlYQpbICAgIDEu
ODIzMTQ5XSAgUlNQIDxmZmZmODgwMDExYjhmZDAwPgpbICAgIDEuODIzMTQ5XSBDUjI6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICAxLjkxODcyMV0gLS0tWyBlbmQgdHJhY2UgMThmNDRjMWE5
YTc3N2NmYSBdLS0tClsgICAgMS45MjAyMzRdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2Fs
bGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIx
ZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1sa3Atc2IwNC0zODoyMDE0MDMyMzE2NTM1
MDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEwLjA6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2Yz
YWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8teGlhbi0xMDoyMDE0MDMyMzA4NTM1Mjp4ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEwLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUz
NzYvZG1lc2cteW9jdG8taXZ5dG93bjItMTk6MjAxNDAzMjMwODU0MjE6eDg2XzY0LXJhbmRj
b25maWctcjItMDMyMzA0NDc6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0Ny84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTI5OjIwMTQwMzIzMDg1NDI5Ong4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3OjMuMTAuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDcvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15
b2N0by1pdnl0b3duMi0zMToyMDE0MDMyMzA4NTQyMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0NzozLjEwLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8t
aXZ5dG93bjItMzM6MjAxNDAzMjMwODU0Mjg6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDc6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny84YmI0
OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLWl2eXRv
d24yLTczOjIwMTQwMzIzMDg1NDIwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMu
MTAuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvOGJiNDk1ZTNm
MDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1pdnl0b3duMi03
MzoyMDE0MDMyMzA4NTQzMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEwLjA6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tbGtwLXNiMDQtMzoyMDE0
MDMyMzE2NTQyMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEwLjA6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tbGtwLXNiMDQtNjI6MjAxNDAzMjMx
NjU0Mjc6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xMC4wOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLWl2eXRvd24yLTMxOjIwMTQwMzIzMDg1NDI5
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTAuMDoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDcvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNh
YzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1pdnl0b3duMi02MjoyMDE0MDMyMzA4NTQzMDp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjEwLjA6MQoxOjEyOjEyIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTAKZ2l0IGNoZWNrb3V0
IHYzLjkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFzdGVyOmMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3
OWViNjZkYWZhMjRhZDE6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0wODo1NTo1OSBjMWJl
NWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3LWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRh
ZDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZk
YWZhMjRhZDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny1jMWJlNWE1YjFiMzU1ZDQw
ZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0Ny9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0
YWQxL3ZtbGludXotMy45LjAKCjIwMTQtMDMtMjMtMDk6MDk6MDAgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAxLjQ1Nzg5OV0gYmxvY2sgbmJkNDogQXR0ZW1w
dGVkIHNlbmQgb24gY2xvc2VkIHNvY2tldApbICAgIDEuNDU4OTYzXSBMb2dGUzogU3RhcnQg
dW5tb3VudGluZwpbICAgIDEuNDU5ODc4XSBMb2dGUzogU3RhcnQgdW5tb3VudGluZwpbICAg
IDEuNDYwNjk4XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBk
ZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgMS40NjI1MDBdIElQOiBbPGZm
ZmZmZmZmODE0NDM4OTk+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg1MS8weGRhClsgICAg
MS40NjM4NDRdIFBHRCAxMWExMzA2NyBQVUQgMTE1N2YwNjcgUE1EIDAgClsgICAgMS40NjQw
MTVdIE9vcHM6IDAwMDIgWyMxXSAKWyAgICAxLjQ2NDAxNV0gTW9kdWxlcyBsaW5rZWQgaW46
ClsgICAgMS40NjQwMTVdIENQVSAwIApbICAgIDEuNDY0MDE1XSBQaWQ6IDQyOCwgY29tbTog
bW91bnQgTm90IHRhaW50ZWQgMy45LjAgIzEgQm9jaHMgQm9jaHMKWyAgICAxLjQ2NDAxNV0g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MTQ0Mzg5OT5dICBbPGZmZmZmZmZmODE0NDM4OTk+XSBf
X211dGV4X2xvY2tfc2xvd3BhdGgrMHg1MS8weGRhClsgICAgMS40NjQwMTVdIFJTUDogMDAx
ODpmZmZmODgwMDExYmM5ZDAwICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMS40NjQwMTVdIFJB
WDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTE1MGNjYzAgUkNYOiBmZmZmODgw
MDExNGM4YjYwClsgICAgMS40NjQwMTVdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAw
MDAwMDAwMDAwMDAwNTYgUkRJOiBmZmZmODgwMDExNTBjY2MwClsgICAgMS40NjQwMTVdIFJC
UDogZmZmZjg4MDAxMWJjOWQ1MCBSMDg6IGZmZmY4ODAwMTFiYzgwMDAgUjA5OiBmZmZmODgw
MDEzMzhjZjAwClsgICAgMS40NjQwMTVdIFIxMDogZmZmZmZmZmY4MTY1ZjdhMCBSMTE6IGZm
ZmZmZmZmODExN2ExNDcgUjEyOiBmZmZmODgwMDExNDJhYzAwClsgICAgMS40NjQwMTVdIFIx
MzogZmZmZjg4MDAxMTUwY2NjOCBSMTQ6IGZmZmY4ODAwMTE0YzhiNjAgUjE1OiBmZmZmODgw
MDExNTBjMDAwClsgICAgMS40NjQwMTVdIEZTOiAgMDAwMDdmNGI1YTE2NzcwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxODFjMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAx
LjQ2NDAxNV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgIDEuNDY0MDE1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAw
MDExOGFhMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDEuNDY0MDE1XSBEUjA6IDAw
MDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAw
MDAwMApbICAgIDEuNDY0MDE1XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAw
MGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMApbICAgIDEuNDY0MDE1XSBQcm9jZXNz
IG1vdW50IChwaWQ6IDQyOCwgdGhyZWFkaW5mbyBmZmZmODgwMDExYmM4MDAwLCB0YXNrIGZm
ZmY4ODAwMTE0YzhiNjApClsgICAgMS40NjQwMTVdIFN0YWNrOgpbICAgIDEuNDY0MDE1XSAg
ZmZmZjg4MDAxMTUwY2NjOCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
Zjg4MDAxMWJjOWQxOApbICAgIDEuNDY0MDE1XSAgZmZmZjg4MDAxMWJjOWQxOCBmZmZmODgw
MDExNTBjY2MwIGZmZmY4ODAwMTE0MmFjMDAgZmZmZjg4MDAxMTUwYzAwMApbICAgIDEuNDY0
MDE1XSAgZmZmZmZmZmZmZmZmZmZmYiBmZmZmODgwMDExNTBjMDAwIGZmZmY4ODAwMTFiYzlk
NjggZmZmZmZmZmY4MTQ0MzUzZQpbICAgIDEuNDY0MDE1XSBDYWxsIFRyYWNlOgpbICAgIDEu
NDY0MDE1XSAgWzxmZmZmZmZmZjgxNDQzNTNlPl0gbXV0ZXhfbG9jaysweDI3LzB4MmEKWyAg
ICAxLjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTE3Y2JiNj5dIGxvZ2ZzX2dldF93YmxvY2tzKzB4
NTUvMHg2MApbICAgIDEuNDY0MDE1XSAgWzxmZmZmZmZmZjgxMTdhMTVkPl0gbG9nZnNfc3lu
Y19mcysweDE0LzB4MzAKWyAgICAxLjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTBmMTg3Mz5dIHN5
bmNfZmlsZXN5c3RlbSsweDQ5LzB4OGUKWyAgICAxLjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTE4
MDNkMj5dIGxvZ2ZzX2tpbGxfc2IrMHgyNy8weGRjClsgICAgMS40NjQwMTVdICBbPGZmZmZm
ZmZmODEwZDFiYjg+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDMxLzB4NWQKWyAgICAx
LjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTE4MTE3MT5dIGxvZ2ZzX21vdW50KzB4NmViLzB4NmZl
ClsgICAgMS40NjQwMTVdICBbPGZmZmZmZmZmODEwZDJmMTE+XSBtb3VudF9mcysweDEwLzB4
YTkKWyAgICAxLjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTBlNzUzND5dIHZmc19rZXJuX21vdW50
KzB4NWYvMHhlMQpbICAgIDEuNDY0MDE1XSAgWzxmZmZmZmZmZjgxMGU5NTM0Pl0gZG9fbW91
bnQrMHg2NDEvMHg3ZmEKWyAgICAxLjQ2NDAxNV0gIFs8ZmZmZmZmZmY4MTBhYzAxOT5dID8g
c3RybmR1cF91c2VyKzB4MzUvMHhjYgpbICAgIDEuNDY0MDE1XSAgWzxmZmZmZmZmZjgxMGU5
NzZkPl0gc3lzX21vdW50KzB4ODAvMHhiOQpbICAgIDEuNDY0MDE1XSAgWzxmZmZmZmZmZjgx
NDQ1YTI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAgMS40NjQwMTVd
IENvZGU6IGVjIDIwIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDA0IDI1IDYwIGIwIDgxIDgx
IGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDQ3IDEwIDRjIDhkIDZmIDA4IDQ4IDg5IDY3IDEw
IDRjIDg5IDJjIDI0IDQ4IDg5IDQ0IDI0IDA4IDw0OD4gODkgMjAgODMgYzggZmYgNGMgODkg
NzQgMjQgMTAgODcgMDcgZmYgYzggNzQgMzEgNGMgOGIgMjQgMjUgClsgICAgMS40NjQwMTVd
IFJJUCAgWzxmZmZmZmZmZjgxNDQzODk5Pl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NTEv
MHhkYQpbICAgIDEuNDY0MDE1XSAgUlNQIDxmZmZmODgwMDExYmM5ZDAwPgpbICAgIDEuNDY0
MDE1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjUyNzI1MV0gLS0tWyBlbmQgdHJh
Y2UgOWEwNjJhNTI3YmMwMmY0YiBdLS0tClsgICAgMS41MjgyMTFdIEJVRzogc2xlZXBpbmcg
ZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9yd3NlbS5j
OjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvYzFiZTVhNWIxYjM1
NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMS9kbWVzZy15b2N0by1pdnl0b3duMi02MDoy
MDE0MDMyMzA5MDkwMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvYzFiZTVhNWIxYjM1NWQ0MGU2
Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMS9kbWVzZy15b2N0by1sa3Atc2IwNC00OjIwMTQwMzIz
MTcwOTAyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5
NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXlvY3RvLWF0aGVucy0yNDoyMDE0MDMyMzA5MDkwNjp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMDoxCjA6MzoyIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuOQpnaXQgY2hlY2tvdXQg
djMuOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6MTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2Fj
NmJlMTRiZmNiMTIwMDpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIzLTA5OjEwOjE0IDE5Zjk0
OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDctMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIw
MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDcvMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMAp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDctMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRi
ZmNiMTIwMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTE5Zjk0OWY1MjU5OWJhN2Mz
ZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEy
MDAvdm1saW51ei0zLjguMAoKMjAxNC0wMy0yMy0wOToyNzoxNSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTMJMTEJMjAJMjQJMjcgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My44
CmdpdCBiaXNlY3Qgc3RhcnQgdjMuOSB2My44IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXIt
YmlzZWN0OiBbIi1iIiwgInYzLjkiLCAiLWciLCAidjMuOCIsICIvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXg3L29i
ai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDEyOTU2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzIwZjIyYWI0MmU5YzgzMmJkZTZlOWE3ZWQw
NGNkYzczZWM3MzdlNWJdIHNpZ25hbHM6IGZpeCBuZXcga2VybmVsLWRvYyB3YXJuaW5ncwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tl
cm5lbC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6MjBm
MjJhYjQyZTljODMyYmRlNmU5YTdlZDA0Y2RjNzNlYzczN2U1YjpiaXNlY3QtbGludXg3Cgoy
MDE0LTAzLTIzLTA5OjMwOjQ2IDIwZjIyYWI0MmU5YzgzMmJkZTZlOWE3ZWQwNGNkYzczZWM3
MzdlNWIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctMjBmMjJhYjQyZTljODMy
YmRlNmU5YTdlZDA0Y2RjNzNlYzczN2U1YgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMjBmMjJhYjQyZTljODMyYmRlNmU5YTdl
ZDA0Y2RjNzNlYzczN2U1Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctMjBmMjJhYjQy
ZTljODMyYmRlNmU5YTdlZDA0Y2RjNzNlYzczN2U1Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3LTIwZjIyYWI0MmU5YzgzMmJkZTZlOWE3ZWQwNGNkYzczZWM3MzdlNWIKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzIwZjIyYWI0MmU5Yzgz
MmJkZTZlOWE3ZWQwNGNkYzczZWM3MzdlNWIvdm1saW51ei0zLjkuMC1yYzItMDAxODctZzIw
ZjIyYWIKCjIwMTQtMDMtMjMtMDk6NTE6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIgVEVT
VCBGQUlMVVJFClsgICAgMS4xOTQ3MTldIGluaXQ6IFRlbXBvcmFyeSBwcm9jZXNzIHNwYXdu
IGVycm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQpbICAgIDEuMjA1NjUxXSBpbml0OiBt
b3VudGVkLXRtcCBtYWluIHByb2Nlc3MgKDEwNSkgdGVybWluYXRlZCB3aXRoIHN0YXR1cyAz
MgpbICAgIDEuMjE3NTc2XSB1ZGV2ZFsxMjFdOiBzdGFydGluZyB2ZXJzaW9uIDE3NQpbICAg
MTEuNDA2OTU5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0
IGF0IGZmZmZmZmZmNjA0ZTE3NWMKWyAgIDExLjQwODI5NV0gSVA6IFs8ZmZmZmZmZmY4MTA5
NmM3Mz5dIHBlcmZfc3dldmVudF9pbml0KzB4NTQvMHg3YQpbICAgMTEuNDA4Mjk1XSBQR0Qg
MTgxMDA2NyBQVUQgMCAKWyAgIDExLjQwODI5NV0gT29wczogMDAwMiBbIzFdIApbICAgMTEu
NDA4Mjk1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDExLjQwODI5NV0gQ1BVIDAgClsgICAx
MS40MDgyOTVdIFBpZDogMTMwLCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy45
LjAtcmMyLTAwMTg3LWcyMGYyMmFiICMxIEJvY2hzIEJvY2hzClsgICAxMS40MDgyOTVdIFJJ
UDogMDAxMDpbPGZmZmZmZmZmODEwOTZjNzM+XSAgWzxmZmZmZmZmZjgxMDk2YzczPl0gcGVy
Zl9zd2V2ZW50X2luaXQrMHg1NC8weDdhClsgICAxMS40MDgyOTVdIFJTUDogMDAxODpmZmZm
ODgwMDEzOThkZTE4ICBFRkxBR1M6IDAwMDEwMjQ2ClsgICAxMS40MDgyOTVdIFJBWDogMDAw
MDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTNhODVjMDAgUkNYOiAwMDAwMDAwMDAwMDAw
MDUzClsgICAxMS40MDgyOTVdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAw
MDAwMDAwNTYgUkRJOiBmZmZmZmZmZjgxODMyYjM4ClsgICAxMS40MDgyOTVdIFJCUDogZmZm
Zjg4MDAxMzk4ZGUyOCBSMDg6IGZmZmY4ODAwMTNhODVjMDAgUjA5OiBmZmZmODgwMDEyOTM1
NjMwClsgICAxMS40MDgyOTVdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IGZmZmY4ODAw
MTNhODVjMDAgUjEyOiBmZmZmZmZmZmY3YWQ2NzA3ClsgICAxMS40MDgyOTVdIFIxMzogMDAw
MDAwMDAwMDAwMDAwMCBSMTQ6IGZmZmY4ODAwMTNhMWQxMTAgUjE1OiAwMDAwMDAwMDAwMDAw
MDAwClsgICAxMS40MDgyOTVdIEZTOiAgMDAwMDdmNjQwODUxZTcwMCgwMDAwKSBHUzpmZmZm
ZmZmZjgxODFjMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDExLjQwODI5
NV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpb
ICAgMTEuNDA4Mjk1XSBDUjI6IGZmZmZmZmZmNjA0ZTE3NWMgQ1IzOiAwMDAwMDAwMDEzOWI2
MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgMTEuNDA4Mjk1XSBEUjA6IDAwMDAwMDAw
MDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgMTEuNDA4Mjk1XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYw
ZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMApbICAgMTEuNDA4Mjk1XSBQcm9jZXNzIHRyaW5p
dHktbWFpbiAocGlkOiAxMzAsIHRocmVhZGluZm8gZmZmZjg4MDAxMzk4YzAwMCwgdGFzayBm
ZmZmODgwMDEzYTFkMTEwKQpbICAgMTEuNDA4Mjk1XSBTdGFjazoKWyAgIDExLjQwODI5NV0g
IGZmZmZmZmZmODE4MzJhODAgZmZmZjg4MDAxM2E4NWMwMCBmZmZmODgwMDEzOThkZTU4IGZm
ZmZmZmZmODEwOWFlNzUKWyAgIDExLjQwODI5NV0gIGZmZmZmZmZmODE4MzJhODAgZmZmZjg4
MDAxM2E4NWMwMCBmZmZmODgwMDEzOThkZWYwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDExLjQw
ODI5NV0gIGZmZmY4ODAwMTM5OGRlYTAgZmZmZmZmZmY4MTA5YjBmOSBmZmZmODgwMDEzYTg1
YzAwIGZmZmZmZmZmMDAwMDAwMDAKWyAgIDExLjQwODI5NV0gQ2FsbCBUcmFjZToKWyAgIDEx
LjQwODI5NV0gIFs8ZmZmZmZmZmY4MTA5YWU3NT5dIHBlcmZfaW5pdF9ldmVudCsweGIwLzB4
ZTQKWyAgIDExLjQwODI5NV0gIFs8ZmZmZmZmZmY4MTA5YjBmOT5dIHBlcmZfZXZlbnRfYWxs
b2MrMHgyNTAvMHgzMTgKWyAgIDExLjQwODI5NV0gIFs8ZmZmZmZmZmY4MTA5YjkxZj5dIHN5
c19wZXJmX2V2ZW50X29wZW4rMHg0MGEvMHg4YjcKWyAgIDExLjQwODI5NV0gIFs8ZmZmZmZm
ZmY4MTQ0NGJlNz5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAgMTEuNDA4
Mjk1XSBDb2RlOiA0MSA4MyBmYyAwOCA3ZiA0MSAzMSBjMCA0OCA4MyBiZiBmOCAwMSAwMCAw
MCAwMCA3NSAzYSA4YiBiZiAwNCAwMiAwMCAwMCA4MyBmZiBmZiA3NSAwMiAzMSBmZiBlOCBl
NiBmMiBmZiBmZiA4NSBjMCA3NSAyNCA0ZCA2MyBlNCA8NDI+IGZmIDA0IGE1IDQwIDdiIDk4
IDgxIDQ4IGM3IDgzIGE4IDAyIDAwIDAwIGU5IDZiIDA5IDgxIGViIDBjIApbICAgMTEuNDA4
Mjk1XSBSSVAgIFs8ZmZmZmZmZmY4MTA5NmM3Mz5dIHBlcmZfc3dldmVudF9pbml0KzB4NTQv
MHg3YQpbICAgMTEuNDA4Mjk1XSAgUlNQIDxmZmZmODgwMDEzOThkZTE4PgpbICAgMTEuNDA4
Mjk1XSBDUjI6IGZmZmZmZmZmNjA0ZTE3NWMKWyAgIDExLjQwODI5NV0gLS0tWyBlbmQgdHJh
Y2UgYjQ0ZDViOWQ2MWFkYzI0MSBdLS0tClsgICAxMS40MDgyOTVdIEJVRzogc2xlZXBpbmcg
ZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9yd3NlbS5j
OjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMjBmMjJhYjQyZTlj
ODMyYmRlNmU5YTdlZDA0Y2RjNzNlYzczN2U1Yi9kbWVzZy15b2N0by1pbm4tMzg6MjAxNDAz
MjMwOTUxMDI6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzIwZjIyYWI0MmU5YzgzMmJkZTZlOWE3ZWQwNGNk
YzczZWM3MzdlNWIvZG1lc2cteW9jdG8tbGtwLXNiMDQtNToyMDE0MDMyMzE3NTE0OTp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzItMDAxODctZzIwZjIyYWI6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzIwZjIyYWI0MmU5YzgzMmJk
ZTZlOWE3ZWQwNGNkYzczZWM3MzdlNWIvZG1lc2cteW9jdG8tc25iLTI5OjIwMTQwMzIzMDk1
MTU1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjoKMjozOjMgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTE0MTMgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbYmJiZDI3ZTY5NGNlMmM1ZmRlOWM4
ZmNlZGJlYTYxOGRkOTE1M2ZlN10gTWVyZ2UgYnJhbmNoICdmb3JfbGludXMnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qYWNrL2xpbnV4LWZz
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9uZXh0Om1hc3Rlcjpi
YmJkMjdlNjk0Y2UyYzVmZGU5YzhmY2VkYmVhNjE4ZGQ5MTUzZmU3OmJpc2VjdC1saW51eDcK
CjIwMTQtMDMtMjMtMDk6NTI6MzEgYmJiZDI3ZTY5NGNlMmM1ZmRlOWM4ZmNlZGJlYTYxOGRk
OTE1M2ZlNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny1iYmJkMjdlNjk0Y2Uy
YzVmZGU5YzhmY2VkYmVhNjE4ZGQ5MTUzZmU3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9iYmJkMjdlNjk0Y2UyYzVmZGU5Yzhm
Y2VkYmVhNjE4ZGQ5MTUzZmU3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny1iYmJkMjdl
Njk0Y2UyYzVmZGU5YzhmY2VkYmVhNjE4ZGQ5MTUzZmU3CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctcjIt
MDMyMzA0NDctYmJiZDI3ZTY5NGNlMmM1ZmRlOWM4ZmNlZGJlYTYxOGRkOTE1M2ZlNwprZXJu
ZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvYmJiZDI3ZTY5NGNl
MmM1ZmRlOWM4ZmNlZGJlYTYxOGRkOTE1M2ZlNy92bWxpbnV6LTMuOC4wLTA5MTUwLWdiYmJk
MjdlCgoyMDE0LTAzLTIzLTEwOjA2OjMyIGRldGVjdGluZyBib290IHN0YXRlIAkyNyBTVUND
RVNTCgpCaXNlY3Rpbmc6IDIxNzggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEyIHN0ZXBzKQpbYmMyZTRhOTBkOWY3NWYxNjY0YzE1ODdlYjA5ZWNkMTBi
YjcxYjAyMl0gTWVyZ2UgdGFnICd1c2ItMy45LXJjMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC91c2IKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGlu
dXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFzdGVyOmJjMmU0YTkwZDlmNzVmMTY2
NGMxNTg3ZWIwOWVjZDEwYmI3MWIwMjI6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0xMDow
NzoyMCBiYzJlNGE5MGQ5Zjc1ZjE2NjRjMTU4N2ViMDllY2QxMGJiNzFiMDIyIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LWJjMmU0YTkwZDlmNzVmMTY2NGMxNTg3ZWIwOWVj
ZDEwYmI3MWIwMjIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3L2JjMmU0YTkwZDlmNzVmMTY2NGMxNTg3ZWIwOWVjZDEwYmI3MWIw
MjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LWJjMmU0YTkwZDlmNzVmMTY2NGMxNTg3
ZWIwOWVjZDEwYmI3MWIwMjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny1iYzJlNGE5
MGQ5Zjc1ZjE2NjRjMTU4N2ViMDllY2QxMGJiNzFiMDIyCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9iYzJlNGE5MGQ5Zjc1ZjE2NjRjMTU4N2ViMDll
Y2QxMGJiNzFiMDIyL3ZtbGludXotMy44LjAtMTA4MjAtZ2JjMmU0YTkKCjIwMTQtMDMtMjMt
MTA6MTc6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTExCTE4CTIzCTI3IFNVQ0NFU1MKCkJp
c2VjdGluZzogNTkzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxMCBzdGVwcykKW2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODFd
IE1lcmdlIGJyYW5jaCAnZm9yLTMuOS91cHN0cmVhbS1maXhlcycgb2YgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2ppa29zL2hpZApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6ZDM4MWY0NWM4OTBh
M2ZiMTM2YWZiMGRjMWNiZTAyNWUwNjZjYjk4MTpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIz
LTEwOjE5OjMzIGQzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRj
MWNiZTAyNWUwNjZjYjk4MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDcvZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRjMWNiZTAyNWUw
NjZjYjk4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctZDM4MWY0NWM4OTBhM2ZiMTM2
YWZiMGRjMWNiZTAyNWUwNjZjYjk4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LWQz
ODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2QzODFmNDVjODkwYTNmYjEzNmFmYjBk
YzFjYmUwMjVlMDY2Y2I5ODEvdm1saW51ei0zLjkuMC1yYzEtMDAyMDUtZ2QzODFmNDUKCjIw
MTQtMDMtMjMtMTA6MzY6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTMgVEVTVCBGQUlMVVJF
ClsgICAgMS4yNjU4NDBdIGluaXQ6IFRlbXBvcmFyeSBwcm9jZXNzIHNwYXduIGVycm9yOiBO
byBzcGFjZSBsZWZ0IG9uIGRldmljZQpbICAgIDEuMjc3MzAwXSBpbml0OiBtb3VudGVkLXRt
cCBtYWluIHByb2Nlc3MgKDEwNSkgdGVybWluYXRlZCB3aXRoIHN0YXR1cyAzMgpbICAgIDEu
MjkwOTYxXSB1ZGV2ZFsxMjFdOiBzdGFydGluZyB2ZXJzaW9uIDE3NQpbICAgMTEuNDM1ODAy
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGZmZmZm
ZmZkODE5ODdiNDAKWyAgIDExLjQzNjUyN10gSVA6IFs8ZmZmZmZmZmY4MTA5NmM2Yz5dIHBl
cmZfc3dldmVudF9pbml0KzB4NTQvMHg3YQpbICAgMTEuNDM2NTI3XSBQR0QgMTgxMDA2NyBQ
VUQgMCAKWyAgIDExLjQzNjUyN10gT29wczogMDAwMiBbIzFdIApbICAgMTEuNDM2NTI3XSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgIDExLjQzNjUyN10gQ1BVIDAgClsgICAxMS40MzY1Mjdd
IFBpZDogMTMwLCBjb21tOiB0cmluaXR5LW1haW4gVGFpbnRlZDogRyAgICAgICAgVyAgICAz
LjkuMC1yYzEtMDAyMDUtZ2QzODFmNDUgIzEgQm9jaHMgQm9jaHMKWyAgIDExLjQzNjUyN10g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MTA5NmM2Yz5dICBbPGZmZmZmZmZmODEwOTZjNmM+XSBw
ZXJmX3N3ZXZlbnRfaW5pdCsweDU0LzB4N2EKWyAgIDExLjQzNjUyN10gUlNQOiAwMDE4OmZm
ZmY4ODAwMTM5ZDVlMTggIEVGTEFHUzogMDAwMTAyNDYKWyAgIDExLjQzNjUyN10gUkFYOiAw
MDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAxM2E4NjQwMCBSQ1g6IDAwMDAwMDAwMDAw
MDAwMjcKWyAgIDExLjQzNjUyN10gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAw
MDAwMDAwMDA1NiBSREk6IGZmZmZmZmZmODE4MzJiMzgKWyAgIDExLjQzNjUyN10gUkJQOiBm
ZmZmODgwMDEzOWQ1ZTI4IFIwODogZmZmZjg4MDAxM2E4NjQwMCBSMDk6IGZmZmY4ODAwMTI5
MzU2MzAKWyAgIDExLjQzNjUyN10gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogZmZmZjg4
MDAxM2E4NjQwMCBSMTI6IGZmZmZmZmZmODAwMDAwMDAKWyAgIDExLjQzNjUyN10gUjEzOiAw
MDAwMDAwMDAwMDAwMDAwIFIxNDogZmZmZjg4MDAxM2EyOTExMCBSMTU6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgIDExLjQzNjUyN10gRlM6ICAwMDAwN2ZlOTUzZDljNzAwKDAwMDApIEdTOmZm
ZmZmZmZmODE4MWMwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgMTEuNDM2
NTI3XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMz
ClsgICAxMS40MzY1MjddIENSMjogZmZmZmZmZmQ4MTk4N2I0MCBDUjM6IDAwMDAwMDAwMTM5
NTgwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAxMS40MzY1MjddIERSMDogMDAwMDAw
MDAwMjBlMjAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAw
ClsgICAxMS40MzY1MjddIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZm
ZjBmZjAgRFI3OiAwMDAwMDAwMDAwMGQwNjAyClsgICAxMS40MzY1MjddIFByb2Nlc3MgdHJp
bml0eS1tYWluIChwaWQ6IDEzMCwgdGhyZWFkaW5mbyBmZmZmODgwMDEzOWQ0MDAwLCB0YXNr
IGZmZmY4ODAwMTNhMjkxMTApClsgICAxMS40MzY1MjddIFN0YWNrOgpbICAgMTEuNDM2NTI3
XSAgZmZmZmZmZmY4MTgzMmE4MCBmZmZmODgwMDEzYTg2NDAwIGZmZmY4ODAwMTM5ZDVlNTgg
ZmZmZmZmZmY4MTA5YWU2ZQpbICAgMTEuNDM2NTI3XSAgZmZmZmZmZmY4MTgzMmE4MCBmZmZm
ODgwMDEzYTg2NDAwIGZmZmY4ODAwMTM5ZDVlZjAgMDAwMDAwMDAwMDAwMDAwMApbICAgMTEu
NDM2NTI3XSAgZmZmZjg4MDAxMzlkNWVhMCBmZmZmZmZmZjgxMDliMGYyIGZmZmY4ODAwMTNh
ODY0MDAgZmZmZmZmZmYwMDAwMDAwMApbICAgMTEuNDM2NTI3XSBDYWxsIFRyYWNlOgpbICAg
MTEuNDM2NTI3XSAgWzxmZmZmZmZmZjgxMDlhZTZlPl0gcGVyZl9pbml0X2V2ZW50KzB4YjAv
MHhlNApbICAgMTEuNDM2NTI3XSAgWzxmZmZmZmZmZjgxMDliMGYyPl0gcGVyZl9ldmVudF9h
bGxvYysweDI1MC8weDMxOApbICAgMTEuNDM2NTI3XSAgWzxmZmZmZmZmZjgxMDliOTE4Pl0g
c3lzX3BlcmZfZXZlbnRfb3BlbisweDQwYS8weDhiNwpbICAgMTEuNDM2NTI3XSAgWzxmZmZm
ZmZmZjgxNDQ0YTI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAxMS40
MzY1MjddIENvZGU6IDQxIDgzIGZjIDA4IDdmIDQxIDMxIGMwIDQ4IDgzIGJmIGY4IDAxIDAw
IDAwIDAwIDc1IDNhIDhiIGJmIDA0IDAyIDAwIDAwIDgzIGZmIGZmIDc1IDAyIDMxIGZmIGU4
IGU2IGYyIGZmIGZmIDg1IGMwIDc1IDI0IDRkIDYzIGU0IDw0Mj4gZmYgMDQgYTUgNDAgN2Ig
OTggODEgNDggYzcgODMgYTggMDIgMDAgMDAgZTIgNmIgMDkgODEgZWIgMGMgClsgICAxMS40
MzY1MjddIFJJUCAgWzxmZmZmZmZmZjgxMDk2YzZjPl0gcGVyZl9zd2V2ZW50X2luaXQrMHg1
NC8weDdhClsgICAxMS40MzY1MjddICBSU1AgPGZmZmY4ODAwMTM5ZDVlMTg+ClsgICAxMS40
MzY1MjddIENSMjogZmZmZmZmZmQ4MTk4N2I0MApbICAgMTEuNDM2NTI3XSAtLS1bIGVuZCB0
cmFjZSA2NmZkYjJjN2NjYjczNjhmIF0tLS0KWyAgIDExLjQzNjUyN10gQlVHOiBzbGVlcGlu
ZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVsL3J3c2Vt
LmM6MjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9kMzgxZjQ1Yzg5
MGEzZmIxMzZhZmIwZGMxY2JlMDI1ZTA2NmNiOTgxL2RtZXNnLXlvY3RvLWl2eXRvd24yLTEw
OjIwMTQwMzIzMTAzNTQyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJj
MS0wMDIwNS1nZDM4MWY0NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDcvZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRjMWNiZTAyNWUwNjZjYjk4MS9kbWVzZy15b2N0
by1pdnl0b3duMi0zNzoyMDE0MDMyMzEwMzU0Mzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIz
MDQ0NzozLjkuMC1yYzEtMDAyMDUtZ2QzODFmNDU6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3L2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5
ODEvZG1lc2cteW9jdG8taXZ5dG93bjItMzg6MjAxNDAzMjMxMDM1NDE6eDg2XzY0LXJhbmRj
b25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMjA1LWdkMzgxZjQ1OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9kMzgxZjQ1Yzg5MGEzZmIxMzZhZmIwZGMx
Y2JlMDI1ZTA2NmNiOTgxL2RtZXNnLXlvY3RvLWl2eXRvd24yLTU1OjIwMTQwMzIzMTAzNTQy
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIwNS1nZDM4MWY0
NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvZDM4MWY0NWM4OTBh
M2ZiMTM2YWZiMGRjMWNiZTAyNWUwNjZjYjk4MS9kbWVzZy15b2N0by1pdnl0b3duMi04ODoy
MDE0MDMyMzEwMzU0Nzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEt
MDAyMDUtZ2QzODFmNDU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
L2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEvZG1lc2cteW9jdG8t
bGtwLXNiMDQtMTE6MjAxNDAzMjMxODM1NDQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDc6My45LjAtcmMxLTAwMjA1LWdkMzgxZjQ1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0Ny9kMzgxZjQ1Yzg5MGEzZmIxMzZhZmIwZGMxY2JlMDI1ZTA2NmNiOTgx
L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTI5OjIwMTQwMzIzMTgzNTUwOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIwNS1nZDM4MWY0NToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRjMWNi
ZTAyNWUwNjZjYjk4MS9kbWVzZy15b2N0by1sa3Atc2IwNC0zODoyMDE0MDMyMzE4MzU0NTp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDUtZ2QzODFmNDU6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2QzODFmNDVjODkwYTNm
YjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEvZG1lc2cteW9jdG8taXZ5dG93bjItNTU6MjAx
NDAzMjMxMDM1NTI6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAw
MjA1LWdkMzgxZjQ1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9k
MzgxZjQ1Yzg5MGEzZmIxMzZhZmIwZGMxY2JlMDI1ZTA2NmNiOTgxL2RtZXNnLXlvY3RvLWl2
eXRvd24yLTcyOjIwMTQwMzIzMTAzNjAwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
OjMuOS4wLXJjMS0wMDIwNS1nZDM4MWY0NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRjMWNiZTAyNWUwNjZjYjk4MS9k
bWVzZy15b2N0by1pdnl0b3duMi03MjoyMDE0MDMyMzEwMzYxMTp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDUtZ2QzODFmNDU6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUw
MjVlMDY2Y2I5ODEvZG1lc2cteW9jdG8tamFrZXRvd24tMTM6MjAxNDAzMjMxMDM2MTU6eDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3L2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEv
ZG1lc2cteW9jdG8tamFrZXRvd24tMzY6MjAxNDAzMjMxMDM2MTg6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
L2QzODFmNDVjODkwYTNmYjEzNmFmYjBkYzFjYmUwMjVlMDY2Y2I5ODEvZG1lc2cteW9jdG8t
bGtwLXNiMDQtMTE6MjAxNDAzMjMxODM1NTY6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDc6My45LjAtcmMxLTAwMjA1LWdkMzgxZjQ1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0Ny9kMzgxZjQ1Yzg5MGEzZmIxMzZhZmIwZGMxY2JlMDI1ZTA2NmNiOTgx
L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTExOjIwMTQwMzIzMTgzNjA4Ong4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIwNS1nZDM4MWY0NToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvZDM4MWY0NWM4OTBhM2ZiMTM2YWZiMGRjMWNi
ZTAyNWUwNjZjYjk4MS9kbWVzZy15b2N0by1sa3Atc2IwNC0zODoyMDE0MDMyMzE4MzU1Nzp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDUtZ2QzODFmNDU6
MQoyOjE2OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDMzOCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2Uz
YjU5NTE4YzEwZTA4ZWViMDYyMTVhYmYwNmY1MGU4ZjgzYjUxZGNdIE1lcmdlIGJyYW5jaCAn
aXJxLXVyZ2VudC1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0Ny9uZXh0Om1hc3RlcjplM2I1OTUxOGMxMGUwOGVlYjA2MjE1YWJmMDZmNTBl
OGY4M2I1MWRjOmJpc2VjdC1saW51eDcKCjIwMTQtMDMtMjMtMTA6Mzc6MjIgZTNiNTk1MThj
MTBlMDhlZWIwNjIxNWFiZjA2ZjUwZThmODNiNTFkYyBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0Ny1lM2I1OTUxOGMxMGUwOGVlYjA2MjE1YWJmMDZmNTBlOGY4M2I1MWRjCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Ny9lM2I1OTUxOGMxMGUwOGVlYjA2MjE1YWJmMDZmNTBlOGY4M2I1MWRjCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0Ny1lM2I1OTUxOGMxMGUwOGVlYjA2MjE1YWJmMDZmNTBlOGY4M2I1
MWRjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctZTNiNTk1MThjMTBlMDhlZWIwNjIx
NWFiZjA2ZjUwZThmODNiNTFkYwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvZTNiNTk1MThjMTBlMDhlZWIwNjIxNWFiZjA2ZjUwZThmODNiNTFkYy92
bWxpbnV6LTMuOS4wLXJjMS0wMDAyNy1nZTNiNTk1MQoKMjAxNC0wMy0yMy0xMDo0MzoyNCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTAJMTUuCTIzLgkyNyBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDE4OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVw
cykKW2QzNDUyNDM2MjlkYjM4YTYzNDBiY2I2OWYzNzIzMjlkMzViOGY2NTBdIE1lcmdlIHRh
ZyAncmVndWxhdG9yLTMuOS1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9icm9vbmllL3JlZ3VsYXRvcgpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6ZDM0NTI0MzYyOWRiMzhhNjM0MGJj
YjY5ZjM3MjMyOWQzNWI4ZjY1MDpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIzLTEwOjQ2OjI4
IGQzNDUyNDM2MjlkYjM4YTYzNDBiY2I2OWYzNzIzMjlkMzViOGY2NTAgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDctZDM0NTI0MzYyOWRiMzhhNjM0MGJjYjY5ZjM3MjMyOWQz
NWI4ZjY1MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvZDM0NTI0MzYyOWRiMzhhNjM0MGJjYjY5ZjM3MjMyOWQzNWI4ZjY1MAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctZDM0NTI0MzYyOWRiMzhhNjM0MGJjYjY5ZjM3
MjMyOWQzNWI4ZjY1MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LWQzNDUyNDM2Mjlk
YjM4YTYzNDBiY2I2OWYzNzIzMjlkMzViOGY2NTAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3L2QzNDUyNDM2MjlkYjM4YTYzNDBiY2I2OWYzNzIzMjlk
MzViOGY2NTAvdm1saW51ei0zLjkuMC1yYzEtMDAxMjctZ2QzNDUyNDMKCjIwMTQtMDMtMjMt
MTA6NTk6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTUJMTkJMjEJMjcgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA3OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NyBzdGVwcykKW2FmMjg0MWNkZDRjYjM1MjQ4ZTQxZjc0MjdkOTk2YzhmNmI1NjMwNTFdIE1l
cmdlIGJyYW5jaCAnZHJtLWZpeGVzJyBvZiBnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0b3Aub3Jn
L35haXJsaWVkL2xpbnV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Ny9uZXh0Om1hc3RlcjphZjI4NDFjZGQ0Y2IzNTI0OGU0MWY3NDI3ZDk5NmM4ZjZiNTYzMDUx
OmJpc2VjdC1saW51eDcKCjIwMTQtMDMtMjMtMTE6MDE6MzAgYWYyODQxY2RkNGNiMzUyNDhl
NDFmNzQyN2Q5OTZjOGY2YjU2MzA1MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Ny1hZjI4NDFjZGQ0Y2IzNTI0OGU0MWY3NDI3ZDk5NmM4ZjZiNTYzMDUxCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny9hZjI4NDFj
ZGQ0Y2IzNTI0OGU0MWY3NDI3ZDk5NmM4ZjZiNTYzMDUxCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0Ny1hZjI4NDFjZGQ0Y2IzNTI0OGU0MWY3NDI3ZDk5NmM4ZjZiNTYzMDUxCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDctYWYyODQxY2RkNGNiMzUyNDhlNDFmNzQyN2Q5OTZj
OGY2YjU2MzA1MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDcvYWYyODQxY2RkNGNiMzUyNDhlNDFmNzQyN2Q5OTZjOGY2YjU2MzA1MS92bWxpbnV6LTMu
OS4wLXJjMS0wMDE5OS1nYWYyODQxYwoKMjAxNC0wMy0yMy0xMToxMDozMSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAJMTIJMjMJMjQJMjcgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzdiNTRjMTY1
YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODBdIHZmczogZG9uJ3QgQlVHX09OKCkg
aWYgZm9sbG93aW5nIGEgL3Byb2MgZmQgcHNldWRvLXN5bWxpbmsgcmVzdWx0cyBpbiBhIHN5
bWxpbmsKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFz
dGVyOjdiNTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODA6YmlzZWN0LWxp
bnV4NwoKMjAxNC0wMy0yMy0xMToxMjozOCA3YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3
Y2I3MzcyMWViNTgwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTdiNTRjMTY1
YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzdiNTRjMTY1YTBjMDEyZWRi
YWVhYTczYzVjODdjYjczNzIxZWI1ODAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTdi
NTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0Ny03YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgw
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83YjU0YzE2
NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgwL3ZtbGludXotMy45LjAtcmMxLTAw
MjAxLWc3YjU0YzE2CgoyMDE0LTAzLTIzLTExOjMwOjQxIGRldGVjdGluZyBib290IHN0YXRl
IC4JMSBURVNUIEZBSUxVUkUKWyAgICAxLjI5Mzg3OF0gaW5pdDogVGVtcG9yYXJ5IHByb2Nl
c3Mgc3Bhd24gZXJyb3I6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlClsgICAgMS4zMDc4Mzdd
IGluaXQ6IG1vdW50ZWQtdG1wIG1haW4gcHJvY2VzcyAoMTA1KSB0ZXJtaW5hdGVkIHdpdGgg
c3RhdHVzIDMyClsgICAgMS4zMjI0NzJdIHVkZXZkWzEyMV06IHN0YXJ0aW5nIHZlcnNpb24g
MTc1ClsgICAxMS40MDU2MjRdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5n
IHJlcXVlc3QgYXQgZmZmZmZmZmY3ZDk4YmI0MApbICAgMTEuNDA2NTM5XSBJUDogWzxmZmZm
ZmZmZjgxMDk2YzZjPl0gcGVyZl9zd2V2ZW50X2luaXQrMHg1NC8weDdhClsgICAxMS40MDY1
MzldIFBHRCAxODEwMDY3IFBVRCAwIApbICAgMTEuNDA2NTM5XSBPb3BzOiAwMDAyIFsjMV0g
ClsgICAxMS40MDY1MzldIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMTEuNDA2NTM5XSBDUFUg
MCAKWyAgIDExLjQwNjUzOV0gUGlkOiAxMzAsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFp
bnRlZCAzLjkuMC1yYzEtMDAyMDEtZzdiNTRjMTYgIzEgQm9jaHMgQm9jaHMKWyAgIDExLjQw
NjUzOV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTA5NmM2Yz5dICBbPGZmZmZmZmZmODEwOTZj
NmM+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDU0LzB4N2EKWyAgIDExLjQwNjUzOV0gUlNQOiAw
MDE4OmZmZmY4ODAwMTM5ZGZlMTggIEVGTEFHUzogMDAwMTAyNDYKWyAgIDExLjQwNjUzOV0g
UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAxM2E3NjgwMCBSQ1g6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgIDExLjQwNjUzOV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTog
MDAwMDAwMDAwMDAwMDM5ZCBSREk6IGZmZmZmZmZmODE4MzJiMzgKWyAgIDExLjQwNjUzOV0g
UkJQOiBmZmZmODgwMDEzOWRmZTI4IFIwODogZmZmZjg4MDAxMzlmMTAwMCBSMDk6IGZmZmY4
ODAwMTI5MzU3NTAKWyAgIDExLjQwNjUzOV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTog
ZmZmZjg4MDAxM2E3NjgwMCBSMTI6IGZmZmZmZmZmZmYwMDEwMDAKWyAgIDExLjQwNjUzOV0g
UjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogZmZmZjg4MDAxM2EyOGI2MCBSMTU6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgIDExLjQwNjUzOV0gRlM6ICAwMDAwN2ZlODE0YzkxNzAwKDAwMDAp
IEdTOmZmZmZmZmZmODE4MWMwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAg
MTEuNDA2NTM5XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDMzClsgICAxMS40MDY1MzldIENSMjogZmZmZmZmZmY3ZDk4YmI0MCBDUjM6IDAwMDAw
MDAwMTM5ZWMwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAxMS40MDY1MzldIERSMDog
MDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAw
MDAwMDAwClsgICAxMS40MDY1MzldIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAw
MDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwClsgICAxMS40MDY1MzldIFByb2Nl
c3MgdHJpbml0eS1tYWluIChwaWQ6IDEzMCwgdGhyZWFkaW5mbyBmZmZmODgwMDEzOWRlMDAw
LCB0YXNrIGZmZmY4ODAwMTNhMjhiNjApClsgICAxMS40MDY1MzldIFN0YWNrOgpbICAgMTEu
NDA2NTM5XSAgZmZmZmZmZmY4MTgzMmE4MCBmZmZmODgwMDEzYTc2ODAwIGZmZmY4ODAwMTM5
ZGZlNTggZmZmZmZmZmY4MTA5YWU2ZQpbICAgMTEuNDA2NTM5XSAgZmZmZmZmZmY4MTgzMmE4
MCBmZmZmODgwMDEzYTc2ODAwIGZmZmY4ODAwMTM5ZGZlZjAgMDAwMDAwMDAwMDAwMDAwMApb
ICAgMTEuNDA2NTM5XSAgZmZmZjg4MDAxMzlkZmVhMCBmZmZmZmZmZjgxMDliMGYyIGZmZmY4
ODAwMTNhNzY4MDAgZmZmZmZmZmYwMDAwMDAwMQpbICAgMTEuNDA2NTM5XSBDYWxsIFRyYWNl
OgpbICAgMTEuNDA2NTM5XSAgWzxmZmZmZmZmZjgxMDlhZTZlPl0gcGVyZl9pbml0X2V2ZW50
KzB4YjAvMHhlNApbICAgMTEuNDA2NTM5XSAgWzxmZmZmZmZmZjgxMDliMGYyPl0gcGVyZl9l
dmVudF9hbGxvYysweDI1MC8weDMxOApbICAgMTEuNDA2NTM5XSAgWzxmZmZmZmZmZjgxMDli
OTE4Pl0gc3lzX3BlcmZfZXZlbnRfb3BlbisweDQwYS8weDhiNwpbICAgMTEuNDA2NTM5XSAg
WzxmZmZmZmZmZjgxNDQ0YTI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsg
ICAxMS40MDY1MzldIENvZGU6IDQxIDgzIGZjIDA4IDdmIDQxIDMxIGMwIDQ4IDgzIGJmIGY4
IDAxIDAwIDAwIDAwIDc1IDNhIDhiIGJmIDA0IDAyIDAwIDAwIDgzIGZmIGZmIDc1IDAyIDMx
IGZmIGU4IGU2IGYyIGZmIGZmIDg1IGMwIDc1IDI0IDRkIDYzIGU0IDw0Mj4gZmYgMDQgYTUg
NDAgN2IgOTggODEgNDggYzcgODMgYTggMDIgMDAgMDAgZTIgNmIgMDkgODEgZWIgMGMgClsg
ICAxMS40MDY1MzldIFJJUCAgWzxmZmZmZmZmZjgxMDk2YzZjPl0gcGVyZl9zd2V2ZW50X2lu
aXQrMHg1NC8weDdhClsgICAxMS40MDY1MzldICBSU1AgPGZmZmY4ODAwMTM5ZGZlMTg+Clsg
ICAxMS40MDY1MzldIENSMjogZmZmZmZmZmY3ZDk4YmI0MApbICAgMTEuNDA2NTM5XSAtLS1b
IGVuZCB0cmFjZSAzNTc1ZmQ1ZmRlODg4ZmNmIF0tLS0KWyAgIDExLjQwNjUzOV0gQlVHOiBz
bGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVs
L3J3c2VtLmM6MjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83YjU0
YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgwL2RtZXNnLXlvY3RvLWl2eXRv
d24yLTcwOjIwMTQwMzIzMTEzMDU1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMu
OS4wLXJjMS0wMDIwMS1nN2I1NGMxNjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMyMzA0NDcvN2I1NGMxNjVhMGMwMTJlZGJhZWFhNzNjNWM4N2NiNzM3MjFlYjU4MC9kbWVz
Zy15b2N0by1sa3Atc2IwNC0xMDoyMDE0MDMyMzE5MzA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDEtZzdiNTRjMTY6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LzdiNTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjcz
NzIxZWI1ODAvZG1lc2cteW9jdG8tc25iLTM0OjIwMTQwMzIzMTEzMDU2Ong4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIz
MDQ0Ny83YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgwL2RtZXNnLXlv
Y3RvLWlubi00NDoyMDE0MDMyMzExMzA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Nzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvN2I1NGMxNjVhMGMw
MTJlZGJhZWFhNzNjNWM4N2NiNzM3MjFlYjU4MC9kbWVzZy15b2N0by1pdnl0b3duMi05NDoy
MDE0MDMyMzExMzA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEt
MDAyMDEtZzdiNTRjMTY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
LzdiNTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAvZG1lc2cteW9jdG8t
bGtwLXNiMDQtMTk6MjAxNDAzMjMxOTMwNTk6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDc6My45LjAtcmMxLTAwMjAxLWc3YjU0YzE2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0Ny83YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgw
L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTI5OjIwMTQwMzIzMTkzMDU4Ong4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIwMS1nN2I1NGMxNjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvN2I1NGMxNjVhMGMwMTJlZGJhZWFhNzNjNWM4
N2NiNzM3MjFlYjU4MC9kbWVzZy15b2N0by1sa3Atc2IwNC01ODoyMDE0MDMyMzE5MzEwMTp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDEtZzdiNTRjMTY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzdiNTRjMTY1YTBjMDEy
ZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAvZG1lc2cteW9jdG8tcm9hbS00MToyMDE0MDMy
MzExMzEwMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDEt
ZzdiNTRjMTY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzdiNTRj
MTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAvZG1lc2cteW9jdG8taW5uLTQy
OjIwMTQwMzIzMTEzMTAzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83YjU0YzE2NWEwYzAxMmVkYmFlYWE3
M2M1Yzg3Y2I3MzcyMWViNTgwL2RtZXNnLXlvY3RvLWl2eXRvd24yLTU3OjIwMTQwMzIzMTEz
MTAyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIwMS1nN2I1
NGMxNjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvN2I1NGMxNjVh
MGMwMTJlZGJhZWFhNzNjNWM4N2NiNzM3MjFlYjU4MC9kbWVzZy15b2N0by1pdnl0b3duMi03
MDoyMDE0MDMyMzExMzEwNDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1y
YzEtMDAyMDEtZzdiNTRjMTY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMw
NDQ3LzdiNTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdjYjczNzIxZWI1ODAvZG1lc2cteW9j
dG8taXZ5dG93bjItODI6MjAxNDAzMjMxMTMxMDI6eDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDc6My45LjAtcmMxLTAwMjAxLWc3YjU0YzE2OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0Ny83YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWVi
NTgwL2RtZXNnLXlvY3RvLXNuYi0zOjIwMTQwMzIzMTEzMTAzOng4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83
YjU0YzE2NWEwYzAxMmVkYmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgwL2RtZXNnLXlvY3RvLWl2
eXRvd24yLTI5OjIwMTQwMzIzMTEzMTA1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
OjMuOS4wLXJjMS0wMDIwMS1nN2I1NGMxNjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvN2I1NGMxNjVhMGMwMTJlZGJhZWFhNzNjNWM4N2NiNzM3MjFlYjU4MC9k
bWVzZy15b2N0by1sa3Atc2IwNC0xMDoyMDE0MDMyMzE5MzEwNjp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMDEtZzdiNTRjMTY6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzdiNTRjMTY1YTBjMDEyZWRiYWVhYTczYzVjODdj
YjczNzIxZWI1ODAvZG1lc2cteW9jdG8taXZ5dG93bjItOTQ6MjAxNDAzMjMxMTMxMDc6eDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMjAxLWc3YjU0YzE2OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83YjU0YzE2NWEwYzAxMmVk
YmFlYWE3M2M1Yzg3Y2I3MzcyMWViNTgwL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTI5OjIwMTQw
MzIzMTkzMTA3Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIw
MS1nN2I1NGMxNjoxCjA6MTg6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2Vj
dGluZzogMTMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQg
c3RlcHMpCls0N2IzYmM5MDczMjhkYjk2OGJjOWI0M2M0MWY0OGY4ZDFlMTQwNzUwXSBNZXJn
ZSBicmFuY2ggJ3g4Ni11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6NDdiM2JjOTA3MzI4ZGI5NjhiYzli
NDNjNDFmNDhmOGQxZTE0MDc1MDpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIzLTExOjMxOjQ0
IDQ3YjNiYzkwNzMyOGRiOTY4YmM5YjQzYzQxZjQ4ZjhkMWUxNDA3NTAgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDctNDdiM2JjOTA3MzI4ZGI5NjhiYzliNDNjNDFmNDhmOGQx
ZTE0MDc1MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvNDdiM2JjOTA3MzI4ZGI5NjhiYzliNDNjNDFmNDhmOGQxZTE0MDc1MAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctNDdiM2JjOTA3MzI4ZGI5NjhiYzliNDNjNDFm
NDhmOGQxZTE0MDc1MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTQ3YjNiYzkwNzMy
OGRiOTY4YmM5YjQzYzQxZjQ4ZjhkMWUxNDA3NTAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LzQ3YjNiYzkwNzMyOGRiOTY4YmM5YjQzYzQxZjQ4Zjhk
MWUxNDA3NTAvdm1saW51ei0zLjkuMC1yYzEtMDAyMTEtZzQ3YjNiYzkKCjIwMTQtMDMtMjMt
MTE6NDY6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAxLjY2
MjI2N10gTG9nRlM6IFN0YXJ0IG1vdW50IDgKWyAgICAxLjY2MzI3N10gYmxvY2sgbmJkMTog
QXR0ZW1wdGVkIHNlbmQgb24gY2xvc2VkIHNvY2tldApbICAgIDEuNjY0MzU2XSBMb2dGUzog
U3RhcnQgdW5tb3VudGluZwpbICAgIDEuNjY1MjMzXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUg
a2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsg
ICAgMS42NjcwNjRdIElQOiBbPGZmZmZmZmZmODE0NDI4YTk+XSBfX211dGV4X2xvY2tfc2xv
d3BhdGgrMHg1MS8weGRhClsgICAgMS42Njc2NzhdIFBHRCAxMWJjZTA2NyBQVUQgMTE0Y2Yw
NjcgUE1EIDAgClsgICAgMS42Njc2NzhdIE9vcHM6IDAwMDIgWyMxXSAKWyAgICAxLjY2NzY3
OF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS42Njc2NzhdIENQVSAwIApbICAgIDEuNjY3
Njc4XSBQaWQ6IDQ0MiwgY29tbTogbW91bnQgTm90IHRhaW50ZWQgMy45LjAtcmMxLTAwMjEx
LWc0N2IzYmM5ICMxIEJvY2hzIEJvY2hzClsgICAgMS42Njc2NzhdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODE0NDI4YTk+XSAgWzxmZmZmZmZmZjgxNDQyOGE5Pl0gX19tdXRleF9sb2NrX3Ns
b3dwYXRoKzB4NTEvMHhkYQpbICAgIDEuNjY3Njc4XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMTUw
M2QwMCAgRUZMQUdTOiAwMDAxMDIwMgpbICAgIDEuNjY3Njc4XSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDAgUkJYOiBmZmZmODgwMDExNGYxY2MwIFJDWDogZmZmZjg4MDAxMWJlZDZjMApbICAg
IDEuNjY3Njc4XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDU2
IFJESTogZmZmZjg4MDAxMTRmMWNjMApbICAgIDEuNjY3Njc4XSBSQlA6IGZmZmY4ODAwMTE1
MDNkNTAgUjA4OiBmZmZmODgwMDExNTAyMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDEuNjY3Njc4XSBSMTA6IGZmZmY4ODAwMTNjZGYyNDggUjExOiBmZmZmODgwMDEzMzNjMzIw
IFIxMjogZmZmZjg4MDAxMWI2ODQwMApbICAgIDEuNjY3Njc4XSBSMTM6IGZmZmY4ODAwMTE0
ZjFjYzggUjE0OiBmZmZmODgwMDExYmVkNmMwIFIxNTogZmZmZjg4MDAxMTRmMTAwMApbICAg
IDEuNjY3Njc4XSBGUzogIDAwMDA3ZmNkYzQyOTk3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTgx
YzAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMS42Njc2NzhdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAxLjY2
NzY3OF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAxMWJkMDAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAxLjY2NzY3OF0gRFIwOiAwMDAwMDAwMDAwMDAwMDAw
IERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjY2
NzY3OF0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6
IDAwMDAwMDAwMDAwMDA0MDAKWyAgICAxLjY2NzY3OF0gUHJvY2VzcyBtb3VudCAocGlkOiA0
NDIsIHRocmVhZGluZm8gZmZmZjg4MDAxMTUwMjAwMCwgdGFzayBmZmZmODgwMDExYmVkNmMw
KQpbICAgIDEuNjY3Njc4XSBTdGFjazoKWyAgICAxLjY2NzY3OF0gIGZmZmY4ODAwMTE0ZjFj
YzggMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTE1MDNkMTgK
WyAgICAxLjY2NzY3OF0gIGZmZmY4ODAwMTE1MDNkMTggZmZmZjg4MDAxMTRmMWNjMCBmZmZm
ODgwMDExYjY4NDAwIGZmZmY4ODAwMTE0ZjEwMDAKWyAgICAxLjY2NzY3OF0gIGZmZmZmZmZm
ZmZmZmZmZmIgZmZmZjg4MDAxMTRmMTAwMCBmZmZmODgwMDExNTAzZDY4IGZmZmZmZmZmODE0
NDI1NGUKWyAgICAxLjY2NzY3OF0gQ2FsbCBUcmFjZToKWyAgICAxLjY2NzY3OF0gIFs8ZmZm
ZmZmZmY4MTQ0MjU0ZT5dIG11dGV4X2xvY2srMHgyNy8weDJhClsgICAgMS42Njc2NzhdICBb
PGZmZmZmZmZmODExN2M1YmM+XSBsb2dmc19nZXRfd2Jsb2NrcysweDU1LzB4NjAKWyAgICAx
LjY2NzY3OF0gIFs8ZmZmZmZmZmY4MTE3OWI2Mz5dIGxvZ2ZzX3N5bmNfZnMrMHgxNC8weDMw
ClsgICAgMS42Njc2NzhdICBbPGZmZmZmZmZmODEwZjE0NTk+XSBzeW5jX2ZpbGVzeXN0ZW0r
MHg0OS8weDhlClsgICAgMS42Njc2NzhdICBbPGZmZmZmZmZmODExN2ZkZDg+XSBsb2dmc19r
aWxsX3NiKzB4MjcvMHhkYwpbICAgIDEuNjY3Njc4XSAgWzxmZmZmZmZmZjgxMGQxOTk5Pl0g
ZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHgzMS8weDVkClsgICAgMS42Njc2NzhdICBbPGZm
ZmZmZmZmODExODBiNzc+XSBsb2dmc19tb3VudCsweDZlYi8weDZmZQpbICAgIDEuNjY3Njc4
XSAgWzxmZmZmZmZmZjgxMGQyY2YyPl0gbW91bnRfZnMrMHgxMC8weGE5ClsgICAgMS42Njc2
NzhdICBbPGZmZmZmZmZmODEwZTcyZGE+XSB2ZnNfa2Vybl9tb3VudCsweDVmLzB4ZTEKWyAg
ICAxLjY2NzY3OF0gIFs8ZmZmZmZmZmY4MTBlOTJjMz5dIGRvX21vdW50KzB4NjNjLzB4N2Y1
ClsgICAgMS42Njc2NzhdICBbPGZmZmZmZmZmODEwYWJmM2Q+XSA/IHN0cm5kdXBfdXNlcisw
eDM1LzB4Y2IKWyAgICAxLjY2NzY3OF0gIFs8ZmZmZmZmZmY4MTBlOTRmYz5dIHN5c19tb3Vu
dCsweDgwLzB4YjkKWyAgICAxLjY2NzY3OF0gIFs8ZmZmZmZmZmY4MTQ0NGEyNz5dIHN5c3Rl
bV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAgIDEuNjY3Njc4XSBDb2RlOiBlYyAyMCBm
ZiA4MCA0NCBlMCBmZiBmZiA0OCA4YiAwNCAyNSA2MCBiMCA4MSA4MSBmZiA4MCA0NCBlMCBm
ZiBmZiA0OCA4YiA0NyAxMCA0YyA4ZCA2ZiAwOCA0OCA4OSA2NyAxMCA0YyA4OSAyYyAyNCA0
OCA4OSA0NCAyNCAwOCA8NDg+IDg5IDIwIDgzIGM4IGZmIDRjIDg5IDc0IDI0IDEwIDg3IDA3
IGZmIGM4IDc0IDMxIDRjIDhiIDI0IDI1IApbICAgIDEuNjY3Njc4XSBSSVAgIFs8ZmZmZmZm
ZmY4MTQ0MjhhOT5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUxLzB4ZGEKWyAgICAxLjY2
NzY3OF0gIFJTUCA8ZmZmZjg4MDAxMTUwM2QwMD4KWyAgICAxLjY2NzY3OF0gQ1IyOiAwMDAw
MDAwMDAwMDAwMDAwClsgICAgMS43MzQ2MjBdIC0tLVsgZW5kIHRyYWNlIGY1ZmIxNjFlMzFm
NGU1OGUgXS0tLQpbICAgIDEuNzM1NTk0XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxl
ZCBmcm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwvcndzZW0uYzoyMAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzQ3YjNiYzkwNzMyOGRiOTY4YmM5YjQzYzQx
ZjQ4ZjhkMWUxNDA3NTAvZG1lc2cteW9jdG8taXZ5dG93bjItMjc6MjAxNDAzMjMxMTQ2MDE6
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMjExLWc0N2IzYmM5
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny80N2IzYmM5MDczMjhk
Yjk2OGJjOWI0M2M0MWY0OGY4ZDFlMTQwNzUwL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTExOjIw
MTQwMzIzMTk0NjEyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0w
MDIxMS1nNDdiM2JjOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcv
NDdiM2JjOTA3MzI4ZGI5NjhiYzliNDNjNDFmNDhmOGQxZTE0MDc1MC9kbWVzZy15b2N0by1p
dnl0b3duMi05MToyMDE0MDMyMzExNDYxODp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
NzozLjkuMC1yYzEtMDAyMTEtZzQ3YjNiYzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3LzQ3YjNiYzkwNzMyOGRiOTY4YmM5YjQzYzQxZjQ4ZjhkMWUxNDA3NTAv
ZG1lc2cteW9jdG8tbGtwLXNiMDQtMjY6MjAxNDAzMjMxOTQ2MTg6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMjExLWc0N2IzYmM5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny80N2IzYmM5MDczMjhkYjk2OGJjOWI0M2M0MWY0
OGY4ZDFlMTQwNzUwL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTQwOjIwMTQwMzIzMTk0NjE0Ong4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDIxMS1nNDdiM2JjOTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNDdiM2JjOTA3MzI4ZGI5
NjhiYzliNDNjNDFmNDhmOGQxZTE0MDc1MC9kbWVzZy15b2N0by14cHMtMjoyMDE0MDMyMzEx
NDYxMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAyMTEtZzQ3
YjNiYzk6MQowOjY6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2Vj
dDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICd4ODYtdXJnZW50LWZvci1saW51cycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAK
bGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHN0YXJ0IDQ3YjNiYzkwNzMyOGRiOTY4YmM5YjQzYzQxZjQ4ZjhkMWUx
NDA3NTAgYWYyODQxY2RkNGNiMzUyNDhlNDFmNzQyN2Q5OTZjOGY2YjU2MzA1MSAtLQpCaXNl
Y3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMg
c3RlcHMpClszYzRhZmY2YjlhMTgzYjRmMjRlYjdiOGRkNmM4YTkyY2RiYTNiYzc1XSB4ODYs
IGRvYzogQmUgZXhwbGljaXQgYWJvdXQgd2hhdCB0aGUgeDg2IHN0cnVjdCBib290X3BhcmFt
cyByZXF1aXJlcwpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg3L29i
ai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6
bWFzdGVyOjNjNGFmZjZiOWExODNiNGYyNGViN2I4ZGQ2YzhhOTJjZGJhM2JjNzU6YmlzZWN0
LWxpbnV4NwoKMjAxNC0wMy0yMy0xMTo0NzoxOSAzYzRhZmY2YjlhMTgzYjRmMjRlYjdiOGRk
NmM4YTkyY2RiYTNiYzc1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTNjNGFm
ZjZiOWExODNiNGYyNGViN2I4ZGQ2YzhhOTJjZGJhM2JjNzUKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzNjNGFmZjZiOWExODNi
NGYyNGViN2I4ZGQ2YzhhOTJjZGJhM2JjNzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
LTNjNGFmZjZiOWExODNiNGYyNGViN2I4ZGQ2YzhhOTJjZGJhM2JjNzUKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0Ny0zYzRhZmY2YjlhMTgzYjRmMjRlYjdiOGRkNmM4YTkyY2RiYTNi
Yzc1Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYzRh
ZmY2YjlhMTgzYjRmMjRlYjdiOGRkNmM4YTkyY2RiYTNiYzc1L3ZtbGludXotMy45LjAtcmMx
LTAwMDA2LWczYzRhZmY2CgoyMDE0LTAzLTIzLTEyOjAzOjE5IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4gVEVTVCBGQUlMVVJFClsgICAgMS40Njc4OTddIExvZ0ZTOiBTdGFydCBtb3Vu
dCBkClsgICAgMS40Njg2OTFdIGJsb2NrIG5iZDEzOiBBdHRlbXB0ZWQgc2VuZCBvbiBjbG9z
ZWQgc29ja2V0ClsgICAgMS40Njk4MjVdIExvZ0ZTOiBTdGFydCB1bm1vdW50aW5nClsgICAg
MS40NzA2NzZdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICAxLjQ3MTIwMl0gSVA6IFs8ZmZm
ZmZmZmY4MTQ0MjdkOT5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUxLzB4ZGEKWyAgICAx
LjQ3MTIwMl0gUEdEIDExYjZkMDY3IFBVRCAxMTRhYjA2NyBQTUQgMCAKWyAgICAxLjQ3MTIw
Ml0gT29wczogMDAwMiBbIzFdIApbICAgIDEuNDcxMjAyXSBNb2R1bGVzIGxpbmtlZCBpbjoK
WyAgICAxLjQ3MTIwMl0gQ1BVIDAgClsgICAgMS40NzEyMDJdIFBpZDogMzk5LCBjb21tOiBt
b3VudCBOb3QgdGFpbnRlZCAzLjkuMC1yYzEtMDAwMDYtZzNjNGFmZjYgIzEgQm9jaHMgQm9j
aHMKWyAgICAxLjQ3MTIwMl0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTQ0MjdkOT5dICBbPGZm
ZmZmZmZmODE0NDI3ZDk+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg1MS8weGRhClsgICAg
MS40NzEyMDJdIFJTUDogMDAxODpmZmZmODgwMDExYmQzZDAwICBFRkxBR1M6IDAwMDEwMjAy
ClsgICAgMS40NzEyMDJdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTE1
MGNjYzAgUkNYOiBmZmZmODgwMDExNDE4YjYwClsgICAgMS40NzEyMDJdIFJEWDogMDAwMDAw
MDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwNTYgUkRJOiBmZmZmODgwMDExNTBjY2Mw
ClsgICAgMS40NzEyMDJdIFJCUDogZmZmZjg4MDAxMWJkM2Q1MCBSMDg6IGZmZmY4ODAwMTFi
ZDIwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40NzEyMDJdIFIxMDogZmZmZmZm
ZmY4MTA2NDBkOSBSMTE6IGZmZmY4ODAwMTM4NTdmZDggUjEyOiBmZmZmODgwMDExNDE1NDAw
ClsgICAgMS40NzEyMDJdIFIxMzogZmZmZjg4MDAxMTUwY2NjOCBSMTQ6IGZmZmY4ODAwMTE0
MThiNjAgUjE1OiBmZmZmODgwMDExNTBjMDAwClsgICAgMS40NzEyMDJdIEZTOiAgMDAwMDdm
ZGQ0MTE0ODcwMCgwMDAwKSBHUzpmZmZmZmZmZjgxODFkMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjQ3MTIwMl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuNDcxMjAyXSBDUjI6IDAwMDAwMDAwMDAw
MDAwMDAgQ1IzOiAwMDAwMDAwMDExYjljMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAg
IDEuNDcxMjAyXSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAw
IERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuNDcxMjAyXSBEUjM6IDAwMDAwMDAwMDAw
MDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMApbICAg
IDEuNDcxMjAyXSBQcm9jZXNzIG1vdW50IChwaWQ6IDM5OSwgdGhyZWFkaW5mbyBmZmZmODgw
MDExYmQyMDAwLCB0YXNrIGZmZmY4ODAwMTE0MThiNjApClsgICAgMS40NzEyMDJdIFN0YWNr
OgpbICAgIDEuNDcxMjAyXSAgZmZmZjg4MDAxMTUwY2NjOCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWJkM2QxOApbICAgIDEuNDcxMjAyXSAgZmZmZjg4
MDAxMWJkM2QxOCBmZmZmODgwMDExNTBjY2MwIGZmZmY4ODAwMTE0MTU0MDAgZmZmZjg4MDAx
MTUwYzAwMApbICAgIDEuNDcxMjAyXSAgZmZmZmZmZmZmZmZmZmZmYiBmZmZmODgwMDExNTBj
MDAwIGZmZmY4ODAwMTFiZDNkNjggZmZmZmZmZmY4MTQ0MjQ3ZQpbICAgIDEuNDcxMjAyXSBD
YWxsIFRyYWNlOgpbICAgIDEuNDcxMjAyXSAgWzxmZmZmZmZmZjgxNDQyNDdlPl0gbXV0ZXhf
bG9jaysweDI3LzB4MmEKWyAgICAxLjQ3MTIwMl0gIFs8ZmZmZmZmZmY4MTE3YzU3Yz5dIGxv
Z2ZzX2dldF93YmxvY2tzKzB4NTUvMHg2MApbICAgIDEuNDcxMjAyXSAgWzxmZmZmZmZmZjgx
MTc5YjIzPl0gbG9nZnNfc3luY19mcysweDE0LzB4MzAKWyAgICAxLjQ3MTIwMl0gIFs8ZmZm
ZmZmZmY4MTBmMTQxOT5dIHN5bmNfZmlsZXN5c3RlbSsweDQ5LzB4OGUKWyAgICAxLjQ3MTIw
Ml0gIFs8ZmZmZmZmZmY4MTE3ZmQ5OD5dIGxvZ2ZzX2tpbGxfc2IrMHgyNy8weGRjClsgICAg
MS40NzEyMDJdICBbPGZmZmZmZmZmODEwZDE5NTk+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBl
cisweDMxLzB4NWQKWyAgICAxLjQ3MTIwMl0gIFs8ZmZmZmZmZmY4MTE4MGIzNz5dIGxvZ2Zz
X21vdW50KzB4NmViLzB4NmZlClsgICAgMS40NzEyMDJdICBbPGZmZmZmZmZmODEwZDJjYjI+
XSBtb3VudF9mcysweDEwLzB4YTkKWyAgICAxLjQ3MTIwMl0gIFs8ZmZmZmZmZmY4MTBlNzI5
YT5dIHZmc19rZXJuX21vdW50KzB4NWYvMHhlMQpbICAgIDEuNDcxMjAyXSAgWzxmZmZmZmZm
ZjgxMGU5MjgzPl0gZG9fbW91bnQrMHg2M2MvMHg3ZjUKWyAgICAxLjQ3MTIwMl0gIFs8ZmZm
ZmZmZmY4MTBhYmVmZD5dID8gc3RybmR1cF91c2VyKzB4MzUvMHhjYgpbICAgIDEuNDcxMjAy
XSAgWzxmZmZmZmZmZjgxMGU5NGJjPl0gc3lzX21vdW50KzB4ODAvMHhiOQpbICAgIDEuNDcx
MjAyXSAgWzxmZmZmZmZmZjgxNDQ0OTI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8w
eDFiClsgICAgMS40NzEyMDJdIENvZGU6IGVjIDIwIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhi
IDA0IDI1IDYwIGMwIDgxIDgxIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDQ3IDEwIDRjIDhk
IDZmIDA4IDQ4IDg5IDY3IDEwIDRjIDg5IDJjIDI0IDQ4IDg5IDQ0IDI0IDA4IDw0OD4gODkg
MjAgODMgYzggZmYgNGMgODkgNzQgMjQgMTAgODcgMDcgZmYgYzggNzQgMzEgNGMgOGIgMjQg
MjUgClsgICAgMS40NzEyMDJdIFJJUCAgWzxmZmZmZmZmZjgxNDQyN2Q5Pl0gX19tdXRleF9s
b2NrX3Nsb3dwYXRoKzB4NTEvMHhkYQpbICAgIDEuNDcxMjAyXSAgUlNQIDxmZmZmODgwMDEx
YmQzZDAwPgpbICAgIDEuNDcxMjAyXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjUz
NTg1NV0gLS0tWyBlbmQgdHJhY2UgN2M2MTk0ZGRmZWQ1ODk0YiBdLS0tClsgICAgMS41MzY3
OTFdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0
IGF0IGtlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMy
MzA0NDcvM2M0YWZmNmI5YTE4M2I0ZjI0ZWI3YjhkZDZjOGE5MmNkYmEzYmM3NS9kbWVzZy15
b2N0by1sa3Atc2IwNC0zMDoyMDE0MDMyMzIwMDQzMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0NzozLjkuMC1yYzEtMDAwMDYtZzNjNGFmZjY6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3LzNjNGFmZjZiOWExODNiNGYyNGViN2I4ZGQ2YzhhOTJjZGJh
M2JjNzUvZG1lc2cteW9jdG8taXZ5dG93bjItNDg6MjAxNDAzMjMxMjA0Mzg6eDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMDA2LWczYzRhZmY2OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8zYzRhZmY2YjlhMTgzYjRmMjRlYjdi
OGRkNmM4YTkyY2RiYTNiYzc1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTk0OjIwMTQwMzIzMTIw
NDM4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDAwNi1nM2M0
YWZmNjoxCjA6MzozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDIg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpClsw
MTUyMjFmZWZiYzkzNjg5ZGQ0NzUwOGE2NjMyNjU1NmFkZjJhYmNkXSB4ODY6IEZpeCAzMi1i
aXQgKl9jcHVfZGF0YSBpbml0aWFsaXplcnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3L25leHQ6bWFzdGVyOjAxNTIyMWZlZmJjOTM2ODlkZDQ3NTA4YTY2MzI2
NTU2YWRmMmFiY2Q6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMy0xMjowNTozMCAwMTUyMjFm
ZWZiYzkzNjg5ZGQ0NzUwOGE2NjMyNjU1NmFkZjJhYmNkIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3LTAxNTIyMWZlZmJjOTM2ODlkZDQ3NTA4YTY2MzI2NTU2YWRmMmFiY2QK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMw
NDQ3LzAxNTIyMWZlZmJjOTM2ODlkZDQ3NTA4YTY2MzI2NTU2YWRmMmFiY2QKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3LTAxNTIyMWZlZmJjOTM2ODlkZDQ3NTA4YTY2MzI2NTU2YWRm
MmFiY2QKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny0wMTUyMjFmZWZiYzkzNjg5ZGQ0
NzUwOGE2NjMyNjU1NmFkZjJhYmNkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0Ny8wMTUyMjFmZWZiYzkzNjg5ZGQ0NzUwOGE2NjMyNjU1NmFkZjJhYmNk
L3ZtbGludXotMy45LjAtcmMxLTAwMDAzLWcwMTUyMjFmCgoyMDE0LTAzLTIzLTEyOjUxOjMy
IGRldGVjdGluZyBib290IHN0YXRlIAkzCTkJMTYJMTkJMjIJMjcgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApClsyZTYwNGMwZjE5ZGNkZDQzM2IzODYzZmZjM2RhOWJjMDc4N2NhNzY1XSB4ODY6IERv
bid0IGNsZWFyIGVmaV9pbmZvIGV2ZW4gaWYgdGhlIHNlbnRpbmVsIGhpdHMKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFzdGVyOjJlNjA0YzBmMTlk
Y2RkNDMzYjM4NjNmZmMzZGE5YmMwNzg3Y2E3NjU6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0y
My0xMjo1NDozOCAyZTYwNGMwZjE5ZGNkZDQzM2IzODYzZmZjM2RhOWJjMDc4N2NhNzY1IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTJlNjA0YzBmMTlkY2RkNDMzYjM4NjNm
ZmMzZGE5YmMwNzg3Y2E3NjUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LzJlNjA0YzBmMTlkY2RkNDMzYjM4NjNmZmMzZGE5YmMw
Nzg3Y2E3NjUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LTJlNjA0YzBmMTlkY2RkNDMz
YjM4NjNmZmMzZGE5YmMwNzg3Y2E3NjUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny0y
ZTYwNGMwZjE5ZGNkZDQzM2IzODYzZmZjM2RhOWJjMDc4N2NhNzY1Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8yZTYwNGMwZjE5ZGNkZDQzM2IzODYz
ZmZjM2RhOWJjMDc4N2NhNzY1L3ZtbGludXotMy45LjAtcmMxLTAwMDA1LWcyZTYwNGMwCgoy
MDE0LTAzLTIzLTEzOjIwOjQwIGRldGVjdGluZyBib290IHN0YXRlIAkyIFRFU1QgRkFJTFVS
RQpbICAgIDEuMzk4NDY1XSBpbml0OiBUZW1wb3JhcnkgcHJvY2VzcyBzcGF3biBlcnJvcjog
Tm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKWyAgICAxLjQxMDczNV0gaW5pdDogbW91bnRlZC10
bXAgbWFpbiBwcm9jZXNzICgxMDUpIHRlcm1pbmF0ZWQgd2l0aCBzdGF0dXMgMzIKWyAgICAx
LjQyNDI2MF0gdWRldmRbMTIxXTogc3RhcnRpbmcgdmVyc2lvbiAxNzUKWyAgIDExLjU1MjU1
OF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZm
ZmZmZjdlZDE3NmJjClsgICAxMS41NTMwMDhdIElQOiBbPGZmZmZmZmZmODEwOTZjMmM+XSBw
ZXJmX3N3ZXZlbnRfaW5pdCsweDU0LzB4N2EKWyAgIDExLjU1MzAwOF0gUEdEIDE4MTEwNjcg
UFVEIDAgClsgICAxMS41NTMwMDhdIE9vcHM6IDAwMDIgWyMxXSAKWyAgIDExLjU1MzAwOF0g
TW9kdWxlcyBsaW5rZWQgaW46ClsgICAxMS41NTMwMDhdIENQVSAwIApbICAgMTEuNTUzMDA4
XSBQaWQ6IDEzMCwgY29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuOS4wLXJjMS0w
MDAwNS1nMmU2MDRjMCAjMSBCb2NocyBCb2NocwpbICAgMTEuNTUzMDA4XSBSSVA6IDAwMTA6
WzxmZmZmZmZmZjgxMDk2YzJjPl0gIFs8ZmZmZmZmZmY4MTA5NmMyYz5dIHBlcmZfc3dldmVu
dF9pbml0KzB4NTQvMHg3YQpbICAgMTEuNTUzMDA4XSBSU1A6IDAwMTg6ZmZmZjg4MDAwZjlk
N2UxOCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgMTEuNTUzMDA4XSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDAgUkJYOiBmZmZmODgwMDBmYTgyMDAwIFJDWDogMDAwMDAwMDAwMDAwMDAyZApbICAg
MTEuNTUzMDA4XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDU2
IFJESTogZmZmZmZmZmY4MTgzM2FmOApbICAgMTEuNTUzMDA4XSBSQlA6IGZmZmY4ODAwMGY5
ZDdlMjggUjA4OiBmZmZmODgwMDBmYTgyMDAwIFIwOTogZmZmZjg4MDAwZmZmMDYzMApbICAg
MTEuNTUzMDA4XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiBmZmZmODgwMDBmYTgyMDAw
IFIxMjogZmZmZmZmZmZmZjRlM2FkZgpbICAgMTEuNTUzMDA4XSBSMTM6IDAwMDAwMDAwMDAw
MDAwMDAgUjE0OiBmZmZmODgwMDBmYTFkMTEwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAg
MTEuNTUzMDA4XSBGUzogIDAwMDA3ZjlhNGI3Y2E3MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTgx
ZDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAxMS41NTMwMDhdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgIDExLjU1
MzAwOF0gQ1IyOiBmZmZmZmZmZjdlZDE3NmJjIENSMzogMDAwMDAwMDAwZmEzNTAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgIDExLjU1MzAwOF0gRFIwOiAwMDAwMDAwMDAwYmMyMDAw
IERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDExLjU1
MzAwOF0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6
IDAwMDAwMDAwMDAwZjA2MDIKWyAgIDExLjU1MzAwOF0gUHJvY2VzcyB0cmluaXR5LW1haW4g
KHBpZDogMTMwLCB0aHJlYWRpbmZvIGZmZmY4ODAwMGY5ZDYwMDAsIHRhc2sgZmZmZjg4MDAw
ZmExZDExMCkKWyAgIDExLjU1MzAwOF0gU3RhY2s6ClsgICAxMS41NTMwMDhdICBmZmZmZmZm
ZjgxODMzYTQwIGZmZmY4ODAwMGZhODIwMDAgZmZmZjg4MDAwZjlkN2U1OCBmZmZmZmZmZjgx
MDlhZTJlClsgICAxMS41NTMwMDhdICBmZmZmZmZmZjgxODMzYTQwIGZmZmY4ODAwMGZhODIw
MDAgZmZmZjg4MDAwZjlkN2VmMCAwMDAwMDAwMDAwMDAwMDAwClsgICAxMS41NTMwMDhdICBm
ZmZmODgwMDBmOWQ3ZWEwIGZmZmZmZmZmODEwOWIwYjIgZmZmZjg4MDAwZmE4MjAwMCBmZmZm
ZmZmZjAwMDAwMDAzClsgICAxMS41NTMwMDhdIENhbGwgVHJhY2U6ClsgICAxMS41NTMwMDhd
ICBbPGZmZmZmZmZmODEwOWFlMmU+XSBwZXJmX2luaXRfZXZlbnQrMHhiMC8weGU0ClsgICAx
MS41NTMwMDhdICBbPGZmZmZmZmZmODEwOWIwYjI+XSBwZXJmX2V2ZW50X2FsbG9jKzB4MjUw
LzB4MzE4ClsgICAxMS41NTMwMDhdICBbPGZmZmZmZmZmODEwOWI4ZDg+XSBzeXNfcGVyZl9l
dmVudF9vcGVuKzB4NDBhLzB4OGI3ClsgICAxMS41NTMwMDhdICBbPGZmZmZmZmZmODE0NDQ5
Mjc+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKWyAgIDExLjU1MzAwOF0gQ29k
ZTogNDEgODMgZmMgMDggN2YgNDEgMzEgYzAgNDggODMgYmYgZjggMDEgMDAgMDAgMDAgNzUg
M2EgOGIgYmYgMDQgMDIgMDAgMDAgODMgZmYgZmYgNzUgMDIgMzEgZmYgZTggZTYgZjIgZmYg
ZmYgODUgYzAgNzUgMjQgNGQgNjMgZTQgPDQyPiBmZiAwNCBhNSA0MCA4YiA5OCA4MSA0OCBj
NyA4MyBhOCAwMiAwMCAwMCBhMiA2YiAwOSA4MSBlYiAwYyAKWyAgIDExLjU1MzAwOF0gUklQ
ICBbPGZmZmZmZmZmODEwOTZjMmM+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDU0LzB4N2EKWyAg
IDExLjU1MzAwOF0gIFJTUCA8ZmZmZjg4MDAwZjlkN2UxOD4KWyAgIDExLjU1MzAwOF0gQ1Iy
OiBmZmZmZmZmZjdlZDE3NmJjClsgICAxMS41NTMwMDhdIC0tLVsgZW5kIHRyYWNlIGNkZDE4
YjQ3YjhkM2IwYjQgXS0tLQpbICAgMTEuNTUzMDA4XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9u
IGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwvcndzZW0uYzoyMAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzJlNjA0YzBmMTlkY2RkNDMzYjM4
NjNmZmMzZGE5YmMwNzg3Y2E3NjUvZG1lc2cteW9jdG8tbGtwLXNiMDQtNDc6MjAxNDAzMjMy
MTIwMzA6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMDA1LWcy
ZTYwNGMwOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8yZTYwNGMw
ZjE5ZGNkZDQzM2IzODYzZmZjM2RhOWJjMDc4N2NhNzY1L2RtZXNnLXlvY3RvLXNuYi0yMzoy
MDE0MDMyMzEzMjAzMTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Nzo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMmU2MDRjMGYxOWRjZGQ0MzNiMzg2M2Zm
YzNkYTliYzA3ODdjYTc2NS9kbWVzZy15b2N0by1sa3Atc2IwNC00NzoyMDE0MDMyMzIxMjAz
OTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAwMDUtZzJlNjA0
YzA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzJlNjA0YzBmMTlk
Y2RkNDMzYjM4NjNmZmMzZGE5YmMwNzg3Y2E3NjUvZG1lc2cteW9jdG8tc25iLTQ0OjIwMTQw
MzIzMTMyMDQwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8yZTYwNGMwZjE5ZGNkZDQzM2IzODYzZmZjM2Rh
OWJjMDc4N2NhNzY1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTM0OjIwMTQwMzIzMTMyMDQ4Ong4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDAwNS1nMmU2MDRjMDox
CjA6NTo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls5OGU3YTk4
OTk3OWIxODVmNDllODZkZGFlZDJhZDY4OTAyOTlkOWYwXSB4ODYsIG1tOiBNYWtlIHN1cmUg
dG8gZmluZCBhIDJNIGZyZWUgYmxvY2sgZm9yIHRoZSBmaXJzdCBtYXBwZWQgYXJlYQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6OThlN2E5
ODk5NzliMTg1ZjQ5ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMDpiaXNlY3QtbGludXg3CgoyMDE0
LTAzLTIzLTEzOjIxOjIyIDk4ZTdhOTg5OTc5YjE4NWY0OWU4NmRkYWVkMmFkNjg5MDI5OWQ5
ZjAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctOThlN2E5ODk5NzliMTg1ZjQ5
ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvOThlN2E5ODk5NzliMTg1ZjQ5ZTg2ZGRhZWQy
YWQ2ODkwMjk5ZDlmMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctOThlN2E5ODk5Nzli
MTg1ZjQ5ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMw
NDQ3LTk4ZTdhOTg5OTc5YjE4NWY0OWU4NmRkYWVkMmFkNjg5MDI5OWQ5ZjAKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3Lzk4ZTdhOTg5OTc5YjE4NWY0
OWU4NmRkYWVkMmFkNjg5MDI5OWQ5ZjAvdm1saW51ei0zLjkuMC1yYzEtMDAwMDQtZzk4ZTdh
OTgKCjIwMTQtMDMtMjMtMTM6Mjk6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZB
SUxVUkUKWyAgICAxLjQyODQzNl0gYmxvY2sgbmJkNzogQXR0ZW1wdGVkIHNlbmQgb24gY2xv
c2VkIHNvY2tldApbICAgIDEuNDI5NTY2XSBMb2dGUzogU3RhcnQgbW91bnQgOApbICAgIDEu
NDMwMzYzXSBibG9jayBuYmQ2OiBBdHRlbXB0ZWQgc2VuZCBvbiBjbG9zZWQgc29ja2V0Clsg
ICAgMS40MzE1NDZdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICAxLjQzMzQyMV0gSVA6IFs8
ZmZmZmZmZmY4MTQ0MjdkOT5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDUxLzB4ZGEKWyAg
ICAxLjQzNDgwNV0gUEdEIDExYjkzMDY3IFBVRCAxMWI5NzA2NyBQTUQgMCAKWyAgICAxLjQz
NDgwNV0gT29wczogMDAwMiBbIzFdIApbICAgIDEuNDM0ODA1XSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgICAxLjQzNDgwNV0gQ1BVIDAgClsgICAgMS40MzQ4MDVdIFBpZDogMzg3LCBjb21t
OiBtb3VudCBOb3QgdGFpbnRlZCAzLjkuMC1yYzEtMDAwMDQtZzk4ZTdhOTggIzEgQm9jaHMg
Qm9jaHMKWyAgICAxLjQzNDgwNV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTQ0MjdkOT5dICBb
PGZmZmZmZmZmODE0NDI3ZDk+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg1MS8weGRhClsg
ICAgMS40MzQ4MDVdIFJTUDogMDAxODpmZmZmODgwMDExY2FiZDAwICBFRkxBR1M6IDAwMDEw
MjAyClsgICAgMS40MzQ4MDVdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAw
MTE0ZDRjYzAgUkNYOiBmZmZmODgwMDExNGJiOGUwClsgICAgMS40MzQ4MDVdIFJEWDogMDAw
MDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwNTYgUkRJOiBmZmZmODgwMDExNGQ0
Y2MwClsgICAgMS40MzQ4MDVdIFJCUDogZmZmZjg4MDAxMWNhYmQ1MCBSMDg6IGZmZmY4ODAw
MTFjYWEwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40MzQ4MDVdIFIxMDogZmZm
ZmZmZmY4MTA1ZTQ0NyBSMTE6IGZmZmY4ODAwMTIzOTVmZDggUjEyOiBmZmZmODgwMDExNDEx
YzAwClsgICAgMS40MzQ4MDVdIFIxMzogZmZmZjg4MDAxMTRkNGNjOCBSMTQ6IGZmZmY4ODAw
MTE0YmI4ZTAgUjE1OiBmZmZmODgwMDExNGQ0MDAwClsgICAgMS40MzQ4MDVdIEZTOiAgMDAw
MDdmMDg4MDAzNDcwMCgwMDAwKSBHUzpmZmZmZmZmZjgxODFkMDAwKDAwMDApIGtubEdTOjAw
MDAwMDAwMDAwMDAwMDAKWyAgICAxLjQzNDgwNV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAw
MDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuNDM0ODA1XSBDUjI6IDAwMDAwMDAw
MDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDExNGExMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApb
ICAgIDEuNDM0ODA1XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAw
MDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuNDM0ODA1XSBEUjM6IDAwMDAwMDAw
MDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMApb
ICAgIDEuNDM0ODA1XSBQcm9jZXNzIG1vdW50IChwaWQ6IDM4NywgdGhyZWFkaW5mbyBmZmZm
ODgwMDExY2FhMDAwLCB0YXNrIGZmZmY4ODAwMTE0YmI4ZTApClsgICAgMS40MzQ4MDVdIFN0
YWNrOgpbICAgIDEuNDM0ODA1XSAgZmZmZjg4MDAxMTRkNGNjOCAwMDAwMDAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWNhYmQxOApbICAgIDEuNDM0ODA1XSAgZmZm
Zjg4MDAxMWNhYmQxOCBmZmZmODgwMDExNGQ0Y2MwIGZmZmY4ODAwMTE0MTFjMDAgZmZmZjg4
MDAxMTRkNDAwMApbICAgIDEuNDM0ODA1XSAgZmZmZmZmZmZmZmZmZmZmYiBmZmZmODgwMDEx
NGQ0MDAwIGZmZmY4ODAwMTFjYWJkNjggZmZmZmZmZmY4MTQ0MjQ3ZQpbICAgIDEuNDM0ODA1
XSBDYWxsIFRyYWNlOgpbICAgIDEuNDM0ODA1XSAgWzxmZmZmZmZmZjgxNDQyNDdlPl0gbXV0
ZXhfbG9jaysweDI3LzB4MmEKWyAgICAxLjQzNDgwNV0gIFs8ZmZmZmZmZmY4MTE3YzU3Yz5d
IGxvZ2ZzX2dldF93YmxvY2tzKzB4NTUvMHg2MApbICAgIDEuNDM0ODA1XSAgWzxmZmZmZmZm
ZjgxMTc5YjIzPl0gbG9nZnNfc3luY19mcysweDE0LzB4MzAKWyAgICAxLjQzNDgwNV0gIFs8
ZmZmZmZmZmY4MTBmMTQxOT5dIHN5bmNfZmlsZXN5c3RlbSsweDQ5LzB4OGUKWyAgICAxLjQz
NDgwNV0gIFs8ZmZmZmZmZmY4MTE3ZmQ5OD5dIGxvZ2ZzX2tpbGxfc2IrMHgyNy8weGRjClsg
ICAgMS40MzQ4MDVdICBbPGZmZmZmZmZmODEwZDE5NTk+XSBkZWFjdGl2YXRlX2xvY2tlZF9z
dXBlcisweDMxLzB4NWQKWyAgICAxLjQzNDgwNV0gIFs8ZmZmZmZmZmY4MTE4MGIzNz5dIGxv
Z2ZzX21vdW50KzB4NmViLzB4NmZlClsgICAgMS40MzQ4MDVdICBbPGZmZmZmZmZmODEwZDJj
YjI+XSBtb3VudF9mcysweDEwLzB4YTkKWyAgICAxLjQzNDgwNV0gIFs8ZmZmZmZmZmY4MTBl
NzI5YT5dIHZmc19rZXJuX21vdW50KzB4NWYvMHhlMQpbICAgIDEuNDM0ODA1XSAgWzxmZmZm
ZmZmZjgxMGU5MjgzPl0gZG9fbW91bnQrMHg2M2MvMHg3ZjUKWyAgICAxLjQzNDgwNV0gIFs8
ZmZmZmZmZmY4MTBhYmVmZD5dID8gc3RybmR1cF91c2VyKzB4MzUvMHhjYgpbICAgIDEuNDM0
ODA1XSAgWzxmZmZmZmZmZjgxMGU5NGJjPl0gc3lzX21vdW50KzB4ODAvMHhiOQpbICAgIDEu
NDM0ODA1XSAgWzxmZmZmZmZmZjgxNDQ0OTI3Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgx
Ni8weDFiClsgICAgMS40MzQ4MDVdIENvZGU6IGVjIDIwIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4
IDhiIDA0IDI1IDYwIGMwIDgxIDgxIGZmIDgwIDQ0IGUwIGZmIGZmIDQ4IDhiIDQ3IDEwIDRj
IDhkIDZmIDA4IDQ4IDg5IDY3IDEwIDRjIDg5IDJjIDI0IDQ4IDg5IDQ0IDI0IDA4IDw0OD4g
ODkgMjAgODMgYzggZmYgNGMgODkgNzQgMjQgMTAgODcgMDcgZmYgYzggNzQgMzEgNGMgOGIg
MjQgMjUgClsgICAgMS40MzQ4MDVdIFJJUCAgWzxmZmZmZmZmZjgxNDQyN2Q5Pl0gX19tdXRl
eF9sb2NrX3Nsb3dwYXRoKzB4NTEvMHhkYQpbICAgIDEuNDM0ODA1XSAgUlNQIDxmZmZmODgw
MDExY2FiZDAwPgpbICAgIDEuNDM0ODA1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAx
LjQ5NzE0NF0gLS0tWyBlbmQgdHJhY2UgZTNhZjBjZWEzZWIwNTJhMiBdLS0tClsgICAgMS40
OTgwNjldIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250
ZXh0IGF0IGtlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMyMzA0NDcvOThlN2E5ODk5NzliMTg1ZjQ5ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMC9kbWVz
Zy15b2N0by1sa3Atc2IwNC0yNzoyMDE0MDMyMzIxMjg1Nzp4ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0NzozLjkuMC1yYzEtMDAwMDQtZzk4ZTdhOTg6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3Lzk4ZTdhOTg5OTc5YjE4NWY0OWU4NmRkYWVkMmFkNjg5
MDI5OWQ5ZjAvZG1lc2cteW9jdG8taXZ5dG93bjItNDI6MjAxNDAzMjMxMzI5MDY6eDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDc6My45LjAtcmMxLTAwMDA0LWc5OGU3YTk4OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny85OGU3YTk4OTk3OWIxODVmNDll
ODZkZGFlZDJhZDY4OTAyOTlkOWYwL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTIxOjIwMTQwMzIz
MjEyOTA4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuOS4wLXJjMS0wMDAwNC1n
OThlN2E5ODoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvOThlN2E5
ODk5NzliMTg1ZjQ5ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMC9kbWVzZy15b2N0by1zbmItMTE6
MjAxNDAzMjMxMzI5MDg6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6OgowOjQ6NCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKOThlN2E5ODk5NzliMTg1ZjQ5ZTg2ZGRhZWQy
YWQ2ODkwMjk5ZDlmMCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgOThlN2E5ODk5
NzliMTg1ZjQ5ZTg2ZGRhZWQyYWQ2ODkwMjk5ZDlmMApBdXRob3I6IFlpbmdoYWkgTHUgPHlp
bmdoYWlAa2VybmVsLm9yZz4KRGF0ZTogICBXZWQgTWFyIDYgMjA6MTg6MjEgMjAxMyAtMDgw
MAoKICAgIHg4NiwgbW06IE1ha2Ugc3VyZSB0byBmaW5kIGEgMk0gZnJlZSBibG9jayBmb3Ig
dGhlIGZpcnN0IG1hcHBlZCBhcmVhCiAgICAKICAgIEhlbnJpayByZXBvcnRlZCB0aGF0IGhp
cyBNYWNBaXIgMy4xIHdvdWxkIG5vdCBib290IHdpdGgKICAgIAogICAgfCBjb21taXQgOGQ1
NzQ3MGQ4Zjg1OTYzNWRlZmZlMzkxOWQ3ZDQ4NjdiNDg4Yjg1YQogICAgfCBEYXRlOiAgIEZy
aSBOb3YgMTYgMTk6Mzg6NTggMjAxMiAtMDgwMAogICAgfAogICAgfCAgICB4ODYsIG1tOiBz
ZXR1cCBwYWdlIHRhYmxlIGluIHRvcC1kb3duCiAgICAKICAgIEl0IHR1cm5zIG91dCB0aGF0
IHdlIGRvIG5vdCBjYWxjdWxhdGUgdGhlIHJlYWxfZW5kIHByb3Blcmx5OgogICAgV2UgdHJ5
IHRvIGdldCAyTSBzaXplIHdpdGggNEsgYWxpZ25tZW50LCBhbmQgbGF0ZXIgd2lsbCByb3Vu
ZCBkb3duCiAgICB0byAyTSwgc28gd2Ugd2lsbCBnZXQgbGVzcyB0aGVuIDJNIGZvciBmaXJz
dCBtYXBwaW5nLCBpbiBleHRyZW1lCiAgICBjYXNlIGNvdWxkIGJlIG9ubHkgNEsgb25seS4g
SW4gSGVucmlrJ3Mgc3lzdGVtIGl0IGhhcyAoMU0tMzJLKSBhcwogICAgbGFzdCB1c2FibGUg
cmFnZSBpcyBbbWVtIDB4N2Y5ZGIwMDAtMHg3ZmVmOGZmZl0uCiAgICAKICAgIFRoZSBwcm9i
bGVtIGlzIGV4cG9zZWQgd2hlbiBFRkkgYm9vdGluZyBoYXZlIHNldmVyYWwgaG9sZXMgYW5k
IGl0CiAgICB3aWxsIGZvcmNlIG1hcHBpbmcgdG8gdXNlIFBURSBpbnN0ZWFkIGFzIHdlIG9u
bHkgbWFwIHVzYWJsZSBhcmVhcy4KICAgIAogICAgVG8gZml4IGl0LCBqdXN0IG1ha2UgaXQg
YmUgMk0gYWxpZ25lZCwgc28gd2UgY2FuIGJlIGd1YXJhbnRlZWQgdG8gYmUKICAgIGFibGUg
dG8gdXNlIGxhcmdlIHBhZ2VzIHRvIG1hcCBpdC4KICAgIAogICAgUmVwb3J0ZWQtYnk6IEhl
bnJpayBSeWRiZXJnIDxyeWRiZXJnQGV1cm9tYWlsLnNlPgogICAgQmlzZWN0ZWQtYnk6IEhl
bnJpayBSeWRiZXJnIDxyeWRiZXJnQGV1cm9tYWlsLnNlPgogICAgVGVzdGVkLWJ5OiBIZW5y
aWsgUnlkYmVyZyA8cnlkYmVyZ0BldXJvbWFpbC5zZT4KICAgIFNpZ25lZC1vZmYtYnk6IFlp
bmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KICAgIExpbms6IGh0dHA6Ly9sa21sLmtl
cm5lbC5vcmcvci9DQUU5RmlRWDRuUTdfMWtnNVJMX3ZoNTZybWNTSFhVaTFFeHJaWDdDd0VE
NE5HTW5IZmdAbWFpbC5nbWFpbC5jb20KICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFu
dmluIDxocGFAenl0b3IuY29tPgoKOjA0MDAwMCAwNDAwMDAgMzg1NmJlZWJiNmI0ODJkN2E1
NWI4OTViYzJhNDVkMDIxMjU3OGM2MiBkNzIwYmFlNDgwMWQ4NGQ5YzNiODc4MzNlNmJjNjMw
Y2ViMjA5YmUzIE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFz
dGVyOjAxNTIyMWZlZmJjOTM2ODlkZDQ3NTA4YTY2MzI2NTU2YWRmMmFiY2Q6YmlzZWN0LWxp
bnV4NwoKMjAxNC0wMy0yMy0xMzoyOTo1NSAwMTUyMjFmZWZiYzkzNjg5ZGQ0NzUwOGE2NjMy
NjU1NmFkZjJhYmNkIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0
NDcvMDE1MjIxZmVmYmM5MzY4OWRkNDc1MDhhNjYzMjY1NTZhZGYyYWJjZC92bWxpbnV6LTMu
OS4wLXJjMS0wMDAwMy1nMDE1MjIxZgoKMjAxNC0wMy0yMy0xMzoyOTo1NiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAJMgkzCTgJMTMJMTgJMjAJMjMJMjcJMzAJMzcJNDkJNTMJNTYJNjIJNzEJ
NzQJNzYJODEgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3L25leHQ6bWFzdGVyOjA2ZWQyNmQxZGU1OWNl
N2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTU6YmlzZWN0LWxpbnV4NwogVEVTVCBGQUlMVVJF
ClsgICAgMS42NDAwNjFdIEZBVC1mcyAobmJkMCk6IHVuYWJsZSB0byByZWFkIGJvb3Qgc2Vj
dG9yClsgICAgMS42NDE3ODVdIExvZ0ZTOiBTdGFydCBtb3VudCAxClsgICAgMS42NDMwMjJd
IExvZ0ZTOiBTdGFydCB1bm1vdW50aW5nClsgICAgMS42NDQyNDldIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAo
bnVsbCkKWyAgICAxLjY0NjMyMV0gSVA6IFs8ZmZmZmZmZmY4MTQ5Nzk3Zj5dIF9fbXV0ZXhf
bG9ja19zbG93cGF0aCsweDRiLzB4YzIKWyAgICAxLjY0NjMyMV0gUEdEIGRmNTYwNjcgUFVE
IGQ4OTkwNjcgUE1EIDAgClsgICAgMS42NDYzMjFdIE9vcHM6IDAwMDIgWyMxXSAKWyAgICAx
LjY0NjMyMV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS42NDYzMjFdIENQVTogMCBQSUQ6
IDQ4MCBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LW5leHQtMjAxNDAzMjEg
IzEwClsgICAgMS42NDYzMjFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICAxLjY0NjMyMV0gdGFzazogZmZmZjg4MDAwZGNmMjcwMCB0
aTogZmZmZjg4MDAwZTBlNDAwMCB0YXNrLnRpOiBmZmZmODgwMDBlMGU0MDAwClsgICAgMS42
NDYzMjFdIFJJUDogMDAxMDpbPGZmZmZmZmZmODE0OTc5N2Y+XSAgWzxmZmZmZmZmZjgxNDk3
OTdmPl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NGIvMHhjMgpbICAgIDEuNjQ2MzIxXSBS
U1A6IDAwMTg6ZmZmZjg4MDAwZTBlNWQxMCAgRUZMQUdTOiAwMDAxMDI4NgpbICAgIDEuNjQ2
MzIxXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMDBkOGUwY2MwIFJDWDog
MDAwMDAwMDAwMDAwMDAwMgpbICAgIDEuNjQ2MzIxXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAg
UlNJOiAwMDAwMDAwMDAwMDAwMDY3IFJESTogZmZmZjg4MDAwZDhlMGNjMApbICAgIDEuNjQ2
MzIxXSBSQlA6IGZmZmY4ODAwMGUwZTVkNTAgUjA4OiBmZmZmODgwMDBlMGU0MDAwIFIwOTog
MDAwMDAwMDAwMDAwZGFlNApbICAgIDEuNjQ2MzIxXSBSMTA6IDAwMDAwMDAwMDAwMDAwNjQg
UjExOiBmZmZmZmZmZjgxMTg5MDYyIFIxMjogZmZmZjg4MDAwZDhlMGNjOApbICAgIDEuNjQ2
MzIxXSBSMTM6IGZmZmY4ODAwMGRjZjI3MDAgUjE0OiAwMDAwMDAwMGZmZmZmZmZmIFIxNTog
ZmZmZjg4MDAwZDhlMDAwMApbICAgIDEuNjQ2MzIxXSBGUzogIDAwMDA3ZjM4YTNmMmQ3MDAo
MDAwMCkgR1M6ZmZmZmZmZmY4MTgxYzAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAgMS42NDYzMjFdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2IKWyAgICAxLjY0NjMyMV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzog
MDAwMDAwMDAwZDhhNTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAxLjY0NjMyMV0g
U3RhY2s6ClsgICAgMS42NDYzMjFdICBmZmZmODgwMDBkOGUwY2M4IDAwMDAwMDAwMDAwMDAw
MDAgZmZmZjg4MDAwZTBlNWQxOCAwMDAwMDAwMDAwMDAwODRmClsgICAgMS42NDYzMjFdICBm
ZmZmODgwMDBkOGUwY2MwIGZmZmY4ODAwMGRkOGZjMDAgZmZmZjg4MDAwZDhlMDAwMCBmZmZm
ODgwMDBmNDVhYTAwClsgICAgMS42NDYzMjFdICBmZmZmODgwMDBlMGU1ZDY4IGZmZmZmZmZm
ODE0OTdhMWQgZmZmZjg4MDAwZGQ4ZmMwMCBmZmZmODgwMDBlMGU1ZDgwClsgICAgMS42NDYz
MjFdIENhbGwgVHJhY2U6ClsgICAgMS42NDYzMjFdICBbPGZmZmZmZmZmODE0OTdhMWQ+XSBt
dXRleF9sb2NrKzB4MjcvMHgyYQpbICAgIDEuNjQ2MzIxXSAgWzxmZmZmZmZmZjgxMThiYTQ4
Pl0gbG9nZnNfZ2V0X3dibG9ja3MrMHg1NS8weDYwClsgICAgMS42NDYzMjFdICBbPGZmZmZm
ZmZmODExODkwNzg+XSBsb2dmc19zeW5jX2ZzKzB4MTQvMHgzMApbICAgIDEuNjQ2MzIxXSAg
WzxmZmZmZmZmZjgxMTAxMmI0Pl0gc3luY19maWxlc3lzdGVtKzB4NDkvMHg4ZQpbICAgIDEu
NjQ2MzIxXSAgWzxmZmZmZmZmZjgxMThmMWVjPl0gbG9nZnNfa2lsbF9zYisweDI3LzB4ZGMK
WyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTBlMjNjYj5dIGRlYWN0aXZhdGVfbG9ja2Vk
X3N1cGVyKzB4MmUvMHg0ZgpbICAgIDEuNjQ2MzIxXSAgWzxmZmZmZmZmZjgxMThmZjVkPl0g
bG9nZnNfbW91bnQrMHg2YmQvMHg2ZDUKWyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTBl
MzVjNz5dIG1vdW50X2ZzKzB4MTAvMHhhOQpbICAgIDEuNjQ2MzIxXSAgWzxmZmZmZmZmZjgx
MGY3MDAzPl0gdmZzX2tlcm5fbW91bnQrMHg1Zi8weGUzClsgICAgMS42NDYzMjFdICBbPGZm
ZmZmZmZmODEwZjkzOGY+XSBkb19tb3VudCsweDcyZi8weDgyNgpbICAgIDEuNjQ2MzIxXSAg
WzxmZmZmZmZmZjgxMGJiOTk3Pl0gPyBzdHJuZHVwX3VzZXIrMHgzNS8weGNiClsgICAgMS42
NDYzMjFdICBbPGZmZmZmZmZmODEwZjk2YTg+XSBTeVNfbW91bnQrMHg4MC8weGI5ClsgICAg
MS42NDYzMjFdICBbPGZmZmZmZmZmODE0OTkxMzc+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsw
eDE2LzB4MWIKWyAgICAxLjY0NjMyMV0gQ29kZTogMjUgNTAgYjAgODEgODEgZmYgMDQgMjUg
NTAgYjAgODEgODEgOGIgMDcgODUgYzAgNzkgMjMgNDggOGIgNDMgMTAgNGMgOGQgNjMgMDgg
NDggODkgNjMgMTAgNDEgODMgY2UgZmYgNGMgODkgMjQgMjQgNDggODkgNDQgMjQgMDggPDQ4
PiA4OSAyMCA0YyA4OSA2YyAyNCAxMCBlYiAyZSAzMSBjMCA4NyAwNyBmZiBjOCA3NSBkNSBl
YiA0OCA0NCAKWyAgICAxLjY0NjMyMV0gUklQICBbPGZmZmZmZmZmODE0OTc5N2Y+XSBfX211
dGV4X2xvY2tfc2xvd3BhdGgrMHg0Yi8weGMyClsgICAgMS42NDYzMjFdICBSU1AgPGZmZmY4
ODAwMGUwZTVkMTA+ClsgICAgMS42NDYzMjFdIENSMjogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDEuNjQ2MzIxXSAtLS1bIGVuZCB0cmFjZSAyNjU5OWY3Yjk1Nzg2NjhhIF0tLS0KWyAgICAx
LjY0NjMyMV0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNv
bnRleHQgYXQga2VybmVsL2xvY2tpbmcvcndzZW0uYzoyMAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5
NzUwZTUvZG1lc2cteW9jdG8tcm9hbS0xNjoyMDE0MDMyMzA3MzMwNDp4ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhi
N2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTM6MjAxNDAzMjMwNTAyMzY6
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIx
OjEwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5
Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by14aWFuLTQ1OjIwMTQw
MzIzMDczMzA5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyMToxMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzA2
ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8teGlh
bi0xODoyMDE0MDMyMzA3MzMwOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0
LjAtcmM3LW5leHQtMjAxNDAzMjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzIzMDQ0Ny8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNn
LXlvY3RvLWxrcC1zYjA0LTE2OjIwMTQwMzIzMDUwMjI3Ong4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMjMwNDQ3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxMAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJl
MTY5NzUwZTUvZG1lc2cteW9jdG8taXZ5dG93bjItNzE6MjAxNDAzMjMwNTAyMzI6eDg2XzY0
LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjEwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5Y2U3Y2Ji
ZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1pbm4tMzY6MjAxNDAzMjMwNzMz
MTQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5
NzUwZTUvZG1lc2cteW9jdG8taXZ5dG93bjItNjU6MjAxNDAzMjMwNTAyMjU6eDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjEwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4
Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1pdnl0b3duMi0yNDoyMDE0MDMyMzA1
MDIzMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3LW5leHQtMjAx
NDAzMjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8wNmVkMjZk
MWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3RvLWlubi0yMToy
MDE0MDMyMzA3MzMxODp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Nzo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4
YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1pdnl0b3duMi02NToyMDE0MDMyMzA1MDIz
Njp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3LW5leHQtMjAxNDAz
MjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8wNmVkMjZkMWRl
NTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTQz
OjIwMTQwMzIzMDUwMjM3Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1y
YzctbmV4dC0yMDE0MDMyMToxMAo3OjEyOjEyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
CgpIRUFEIGlzIG5vdyBhdCAwNmVkMjZkIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVz
IGZvciAyMDE0MDMyMQoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyAwNmVkMjZkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZp
bGVzIGZvciAyMDE0MDMyMQpIRUFEIGlzIG5vdyBhdCA3NzQ4NjhjLi4uIE1lcmdlIGJyYW5j
aCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4dDptYXN0ZXI6Nzc0
ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYzpiaXNlY3QtbGludXg3Cgoy
MDE0LTAzLTIzLTEzOjM5OjIzIDc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1
ZDExZmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctNzc0ODY4YzcwOTRkMzVi
NDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvNzc0ODY4YzcwOTRkMzViNDUxOGJlM2Qw
ZTY1NGRlMDAwYTVkMTFmYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDctNzc0ODY4Yzcw
OTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MjMwNDQ3LTc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3Lzc3NDg2OGM3MDk0ZDM1
YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMvdm1saW51ei0zLjE0LjAtcmM3LTAwMDY2LWc3
NzQ4NjhjCgoyMDE0LTAzLTIzLTEzOjU1OjI0IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVT
VCBGQUlMVVJFClsgICAgMS4xOTM4NjZdIExvZ0ZTOiBTdGFydCBtb3VudCAxClsgICAgMS4x
OTQ2MjBdIExvZ0ZTOiBTdGFydCB1bm1vdW50aW5nClsgICAgMS4xOTUzOTddIExvZ0ZTOiBT
dGFydCB1bm1vdW50aW5nClsgICAgMS4xOTYyMzddIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAg
ICAxLjE5NzEzMV0gSVA6IFs8ZmZmZmZmZmY4MTQ4ZWYzYT5dIF9fbXV0ZXhfbG9ja19zbG93
cGF0aCsweDRiLzB4YzIKWyAgICAxLjE5NzEzMV0gUEdEIDExY2UzMDY3IFBVRCAxMWNlMjA2
NyBQTUQgMCAKWyAgICAxLjE5NzEzMV0gT29wczogMDAwMiBbIzFdIApbICAgIDEuMTk3MTMx
XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjE5NzEzMV0gQ1BVOiAwIFBJRDogNDU5IENv
bW06IG1vdW50IE5vdCB0YWludGVkIDMuMTQuMC1yYzctMDAwNjYtZzc3NDg2OGMgIzEKWyAg
ICAxLjE5NzEzMV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgIDEuMTk3MTMxXSB0YXNrOiBmZmZmODgwMDExYWY5OTQwIHRpOiBmZmZm
ODgwMDExOTg4MDAwIHRhc2sudGk6IGZmZmY4ODAwMTE5ODgwMDAKWyAgICAxLjE5NzEzMV0g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MTQ4ZWYzYT5dICBbPGZmZmZmZmZmODE0OGVmM2E+XSBf
X211dGV4X2xvY2tfc2xvd3BhdGgrMHg0Yi8weGMyClsgICAgMS4xOTcxMzFdIFJTUDogMDAx
ODpmZmZmODgwMDExOTg5ZDEwICBFRkxBR1M6IDAwMDEwMjg2ClsgICAgMS4xOTcxMzFdIFJB
WDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTE0ZWRjYzAgUkNYOiAwMDAwMDAw
MDAwMDAwMDAyClsgICAgMS4xOTcxMzFdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAw
MDAwMDAwMDAwMDAwNjAgUkRJOiBmZmZmODgwMDExNGVkY2MwClsgICAgMS4xOTcxMzFdIFJC
UDogZmZmZjg4MDAxMTk4OWQ1MCBSMDg6IGZmZmY4ODAwMTE5ODgwMDAgUjA5OiAwMDAwMDAw
MDAwMDAwMTAwClsgICAgMS4xOTcxMzFdIFIxMDogMDAwMDAwMDAwMDAwMDAwMSBSMTE6IGZm
ZmZmZmZmODEwNzIyZTAgUjEyOiBmZmZmODgwMDExNGVkY2M4ClsgICAgMS4xOTcxMzFdIFIx
MzogZmZmZjg4MDAxMWFmOTk0MCBSMTQ6IDAwMDAwMDAwZmZmZmZmZmYgUjE1OiBmZmZmODgw
MDExNGVkMDAwClsgICAgMS4xOTcxMzFdIEZTOiAgMDAwMDdmM2ZkZjk2ZjcwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxODFjMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAx
LjE5NzEzMV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgIDEuMTk3MTMxXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAw
MDExNDQyMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDEuMTk3MTMxXSBTdGFjazoK
WyAgICAxLjE5NzEzMV0gIGZmZmY4ODAwMTE0ZWRjYzggMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ODgwMDExOTg5ZDE4IDAwMDAwMDAwMDAwMDA5MzIKWyAgICAxLjE5NzEzMV0gIGZmZmY4ODAw
MTE0ZWRjYzAgZmZmZjg4MDAxMTQyZTQwMCBmZmZmODgwMDExNGVkMDAwIGZmZmY4ODAwMTMz
NTAyMDAKWyAgICAxLjE5NzEzMV0gIGZmZmY4ODAwMTE5ODlkNjggZmZmZmZmZmY4MTQ4ZWZk
OCBmZmZmODgwMDExNDJlNDAwIGZmZmY4ODAwMTE5ODlkODAKWyAgICAxLjE5NzEzMV0gQ2Fs
bCBUcmFjZToKWyAgICAxLjE5NzEzMV0gIFs8ZmZmZmZmZmY4MTQ4ZWZkOD5dIG11dGV4X2xv
Y2srMHgyNy8weDJhClsgICAgMS4xOTcxMzFdICBbPGZmZmZmZmZmODExOGEwMTc+XSBsb2dm
c19nZXRfd2Jsb2NrcysweDU1LzB4NjAKWyAgICAxLjE5NzEzMV0gIFs8ZmZmZmZmZmY4MTE4
NzY0Nz5dIGxvZ2ZzX3N5bmNfZnMrMHgxNC8weDMwClsgICAgMS4xOTcxMzFdICBbPGZmZmZm
ZmZmODEwZmZmZTU+XSBzeW5jX2ZpbGVzeXN0ZW0rMHg0OS8weDhlClsgICAgMS4xOTcxMzFd
ICBbPGZmZmZmZmZmODExOGQ3YmQ+XSBsb2dmc19raWxsX3NiKzB4MjcvMHhkYwpbICAgIDEu
MTk3MTMxXSAgWzxmZmZmZmZmZjgxMGUxMDgyPl0gZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIr
MHgyZS8weDRmClsgICAgMS4xOTcxMzFdICBbPGZmZmZmZmZmODExOGU1MmU+XSBsb2dmc19t
b3VudCsweDZiZC8weDZkNQpbICAgIDEuMTk3MTMxXSAgWzxmZmZmZmZmZjgxMGUyMjgyPl0g
bW91bnRfZnMrMHgxMC8weGE5ClsgICAgMS4xOTcxMzFdICBbPGZmZmZmZmZmODEwZjVkNzI+
XSB2ZnNfa2Vybl9tb3VudCsweDVmLzB4ZTMKWyAgICAxLjE5NzEzMV0gIFs8ZmZmZmZmZmY4
MTBmODBmMD5dIGRvX21vdW50KzB4NzJmLzB4ODI2ClsgICAgMS4xOTcxMzFdICBbPGZmZmZm
ZmZmODEwYmFlM2M+XSA/IHN0cm5kdXBfdXNlcisweDM1LzB4Y2IKWyAgICAxLjE5NzEzMV0g
IFs8ZmZmZmZmZmY4MTBmODQwOT5dIFN5U19tb3VudCsweDgwLzB4YjkKWyAgICAxLjE5NzEz
MV0gIFs8ZmZmZmZmZmY4MTQ5MDZmNz5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgx
YgpbICAgIDEuMTk3MTMxXSBDb2RlOiAyNSA1MCBiMCA4MSA4MSBmZiAwNCAyNSA1MCBiMCA4
MSA4MSA4YiAwNyA4NSBjMCA3OSAyMyA0OCA4YiA0MyAxMCA0YyA4ZCA2MyAwOCA0OCA4OSA2
MyAxMCA0MSA4MyBjZSBmZiA0YyA4OSAyNCAyNCA0OCA4OSA0NCAyNCAwOCA8NDg+IDg5IDIw
IDRjIDg5IDZjIDI0IDEwIGViIDJlIDMxIGMwIDg3IDA3IGZmIGM4IDc1IGQ1IGViIDQ4IDQ0
IApbICAgIDEuMTk3MTMxXSBSSVAgIFs8ZmZmZmZmZmY4MTQ4ZWYzYT5dIF9fbXV0ZXhfbG9j
a19zbG93cGF0aCsweDRiLzB4YzIKWyAgICAxLjE5NzEzMV0gIFJTUCA8ZmZmZjg4MDAxMTk4
OWQxMD4KWyAgICAxLjE5NzEzMV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS4xOTcx
MzFdIC0tLVsgZW5kIHRyYWNlIDA0YmQxMDIxMjhmZmY1ZGEgXS0tLQpbICAgIDEuMTk3MTMx
XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBh
dCBrZXJuZWwvbG9ja2luZy9yd3NlbS5jOjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMyMzA0NDcvNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYy9k
bWVzZy15b2N0by1pdnl0b3duMi04NzoyMDE0MDMyMzEzNTUxMzp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3LTAwMDY2LWc3NzQ4NjhjOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny83NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0
ZGUwMDBhNWQxMWZjL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTQ1OjIwMTQwMzIzMjE1NTIyOng4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctMDAwNjYtZzc3NDg2OGM6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3Lzc3NDg2OGM3MDk0ZDM1
YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMvZG1lc2cteW9jdG8tamFrZXRvd24tMzI6MjAx
NDAzMjMxMzU1MjQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6OgowOjM6MyBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09
PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3NzQ4NjhjLi4uIE1lcmdlIGJyYW5jaCAn
cGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlzIG5vdyBhdCAwNmVkMjZkLi4uIEFk
ZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMyMQpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvbmV4
dDptYXN0ZXI6MDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNTpiaXNl
Y3QtbGludXg3CiBURVNUIEZBSUxVUkUKWyAgICAxLjY0MDA2MV0gRkFULWZzIChuYmQwKTog
dW5hYmxlIHRvIHJlYWQgYm9vdCBzZWN0b3IKWyAgICAxLjY0MTc4NV0gTG9nRlM6IFN0YXJ0
IG1vdW50IDEKWyAgICAxLjY0MzAyMl0gTG9nRlM6IFN0YXJ0IHVubW91bnRpbmcKWyAgICAx
LjY0NDI0OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQpbICAgIDEuNjQ2MzIxXSBJUDogWzxmZmZm
ZmZmZjgxNDk3OTdmPl0gX19tdXRleF9sb2NrX3Nsb3dwYXRoKzB4NGIvMHhjMgpbICAgIDEu
NjQ2MzIxXSBQR0QgZGY1NjA2NyBQVUQgZDg5OTA2NyBQTUQgMCAKWyAgICAxLjY0NjMyMV0g
T29wczogMDAwMiBbIzFdIApbICAgIDEuNjQ2MzIxXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICAxLjY0NjMyMV0gQ1BVOiAwIFBJRDogNDgwIENvbW06IG1vdW50IE5vdCB0YWludGVkIDMu
MTQuMC1yYzctbmV4dC0yMDE0MDMyMSAjMTAKWyAgICAxLjY0NjMyMV0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNjQ2MzIxXSB0
YXNrOiBmZmZmODgwMDBkY2YyNzAwIHRpOiBmZmZmODgwMDBlMGU0MDAwIHRhc2sudGk6IGZm
ZmY4ODAwMGUwZTQwMDAKWyAgICAxLjY0NjMyMV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTQ5
Nzk3Zj5dICBbPGZmZmZmZmZmODE0OTc5N2Y+XSBfX211dGV4X2xvY2tfc2xvd3BhdGgrMHg0
Yi8weGMyClsgICAgMS42NDYzMjFdIFJTUDogMDAxODpmZmZmODgwMDBlMGU1ZDEwICBFRkxB
R1M6IDAwMDEwMjg2ClsgICAgMS42NDYzMjFdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6
IGZmZmY4ODAwMGQ4ZTBjYzAgUkNYOiAwMDAwMDAwMDAwMDAwMDAyClsgICAgMS42NDYzMjFd
IFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwNjcgUkRJOiBmZmZm
ODgwMDBkOGUwY2MwClsgICAgMS42NDYzMjFdIFJCUDogZmZmZjg4MDAwZTBlNWQ1MCBSMDg6
IGZmZmY4ODAwMGUwZTQwMDAgUjA5OiAwMDAwMDAwMDAwMDBkYWU0ClsgICAgMS42NDYzMjFd
IFIxMDogMDAwMDAwMDAwMDAwMDA2NCBSMTE6IGZmZmZmZmZmODExODkwNjIgUjEyOiBmZmZm
ODgwMDBkOGUwY2M4ClsgICAgMS42NDYzMjFdIFIxMzogZmZmZjg4MDAwZGNmMjcwMCBSMTQ6
IDAwMDAwMDAwZmZmZmZmZmYgUjE1OiBmZmZmODgwMDBkOGUwMDAwClsgICAgMS42NDYzMjFd
IEZTOiAgMDAwMDdmMzhhM2YyZDcwMCgwMDAwKSBHUzpmZmZmZmZmZjgxODFjMDAwKDAwMDAp
IGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjY0NjMyMV0gQ1M6ICAwMDEwIERTOiAw
MDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuNjQ2MzIxXSBDUjI6
IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDBkOGE1MDAwIENSNDogMDAwMDAwMDAw
MDAwMDZiMApbICAgIDEuNjQ2MzIxXSBTdGFjazoKWyAgICAxLjY0NjMyMV0gIGZmZmY4ODAw
MGQ4ZTBjYzggMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBlMGU1ZDE4IDAwMDAwMDAwMDAw
MDA4NGYKWyAgICAxLjY0NjMyMV0gIGZmZmY4ODAwMGQ4ZTBjYzAgZmZmZjg4MDAwZGQ4ZmMw
MCBmZmZmODgwMDBkOGUwMDAwIGZmZmY4ODAwMGY0NWFhMDAKWyAgICAxLjY0NjMyMV0gIGZm
ZmY4ODAwMGUwZTVkNjggZmZmZmZmZmY4MTQ5N2ExZCBmZmZmODgwMDBkZDhmYzAwIGZmZmY4
ODAwMGUwZTVkODAKWyAgICAxLjY0NjMyMV0gQ2FsbCBUcmFjZToKWyAgICAxLjY0NjMyMV0g
IFs8ZmZmZmZmZmY4MTQ5N2ExZD5dIG11dGV4X2xvY2srMHgyNy8weDJhClsgICAgMS42NDYz
MjFdICBbPGZmZmZmZmZmODExOGJhNDg+XSBsb2dmc19nZXRfd2Jsb2NrcysweDU1LzB4NjAK
WyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTE4OTA3OD5dIGxvZ2ZzX3N5bmNfZnMrMHgx
NC8weDMwClsgICAgMS42NDYzMjFdICBbPGZmZmZmZmZmODExMDEyYjQ+XSBzeW5jX2ZpbGVz
eXN0ZW0rMHg0OS8weDhlClsgICAgMS42NDYzMjFdICBbPGZmZmZmZmZmODExOGYxZWM+XSBs
b2dmc19raWxsX3NiKzB4MjcvMHhkYwpbICAgIDEuNjQ2MzIxXSAgWzxmZmZmZmZmZjgxMGUy
M2NiPl0gZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHgyZS8weDRmClsgICAgMS42NDYzMjFd
ICBbPGZmZmZmZmZmODExOGZmNWQ+XSBsb2dmc19tb3VudCsweDZiZC8weDZkNQpbICAgIDEu
NjQ2MzIxXSAgWzxmZmZmZmZmZjgxMGUzNWM3Pl0gbW91bnRfZnMrMHgxMC8weGE5ClsgICAg
MS42NDYzMjFdICBbPGZmZmZmZmZmODEwZjcwMDM+XSB2ZnNfa2Vybl9tb3VudCsweDVmLzB4
ZTMKWyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTBmOTM4Zj5dIGRvX21vdW50KzB4NzJm
LzB4ODI2ClsgICAgMS42NDYzMjFdICBbPGZmZmZmZmZmODEwYmI5OTc+XSA/IHN0cm5kdXBf
dXNlcisweDM1LzB4Y2IKWyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTBmOTZhOD5dIFN5
U19tb3VudCsweDgwLzB4YjkKWyAgICAxLjY0NjMyMV0gIFs8ZmZmZmZmZmY4MTQ5OTEzNz5d
IHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAgIDEuNjQ2MzIxXSBDb2RlOiAy
NSA1MCBiMCA4MSA4MSBmZiAwNCAyNSA1MCBiMCA4MSA4MSA4YiAwNyA4NSBjMCA3OSAyMyA0
OCA4YiA0MyAxMCA0YyA4ZCA2MyAwOCA0OCA4OSA2MyAxMCA0MSA4MyBjZSBmZiA0YyA4OSAy
NCAyNCA0OCA4OSA0NCAyNCAwOCA8NDg+IDg5IDIwIDRjIDg5IDZjIDI0IDEwIGViIDJlIDMx
IGMwIDg3IDA3IGZmIGM4IDc1IGQ1IGViIDQ4IDQ0IApbICAgIDEuNjQ2MzIxXSBSSVAgIFs8
ZmZmZmZmZmY4MTQ5Nzk3Zj5dIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDRiLzB4YzIKWyAg
ICAxLjY0NjMyMV0gIFJTUCA8ZmZmZjg4MDAwZTBlNWQxMD4KWyAgICAxLjY0NjMyMV0gQ1Iy
OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS42NDYzMjFdIC0tLVsgZW5kIHRyYWNlIDI2NTk5
ZjdiOTU3ODY2OGEgXS0tLQpbICAgIDEuNjQ2MzIxXSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9u
IGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwvbG9ja2luZy9yd3NlbS5j
OjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5
Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1yb2FtLTE2OjIwMTQw
MzIzMDczMzA0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyMToxMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzA2
ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtw
LXNiMDQtMzoyMDE0MDMyMzA1MDIzNjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Nzoz
LjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzIzMDQ0Ny8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2Rt
ZXNnLXlvY3RvLXhpYW4tNDU6MjAxNDAzMjMwNzMzMDk6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjEwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUx
Njk3NTBlNS9kbWVzZy15b2N0by14aWFuLTE4OjIwMTQwMzIzMDczMzA5Ong4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMjMwNDQ3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxMAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3
OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtwLXNiMDQtMTY6MjAxNDAzMjMwNTAy
Mjc6eDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQw
MzIxOjEwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFk
ZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1pdnl0b3duMi03
MToyMDE0MDMyMzA1MDIzMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAt
cmM3LW5leHQtMjAxNDAzMjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIz
MDQ0Ny8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlv
Y3RvLWlubi0zNjoyMDE0MDMyMzA3MzMxNDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Nzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMyMzA0NDcvMDZlZDI2ZDFkZTU5
Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1pdnl0b3duMi02NToy
MDE0MDMyMzA1MDIyNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0NzozLjE0LjAtcmM3
LW5leHQtMjAxNDAzMjE6MTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0
Ny8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTI0OjIwMTQwMzIzMDUwMjMyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMw
NDQ3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxMAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUw
ZTUvZG1lc2cteW9jdG8taW5uLTIxOjIwMTQwMzIzMDczMzE4Ong4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzIzMDQ0Ny8w
NmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3RvLWl2
eXRvd24yLTY1OjIwMTQwMzIzMDUwMjM2Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMjMwNDQ3
OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMjMwNDQ3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUv
ZG1lc2cteW9jdG8taXZ5dG93bjItNDM6MjAxNDAzMjMwNTAyMzc6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMyMzA0NDc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjEwCjc6MTI6MTIgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-next-20140321"

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
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
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
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
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
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
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
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
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
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
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
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
# CONFIG_OLD_BELKIN_DONGLE is not set
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=m
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_WILINK=m
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_I2C=m
# CONFIG_NFC_MRVL is not set
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_NAND_SH_FLCTL=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
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
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_ECHO=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
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
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=m
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

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
CONFIG_DUMMY=m
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=y
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SR9700=m
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_ATH_CARDS is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
# CONFIG_BRCMFMAC_SDIO is not set
# CONFIG_BRCMFMAC_USB is not set
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=m
# CONFIG_MWIFIEX_SDIO is not set
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_MWIFIEX_USB=m

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=m
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_SH_KEYSC=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
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
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
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
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

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

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_MXC is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
# CONFIG_CHARGER_SMB347 is not set
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
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=m
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=m
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_CROS_EC is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_BCM590XX=m
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PBIAS=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_SH_VOU=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_SCALE_CROP=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_VIDEO_RCAR_VIN=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
# CONFIG_VIDEO_W9966 is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

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
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=m
CONFIG_VIDEO_TVP514X=m
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_VS6624=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_AS3645A is not set
CONFIG_VIDEO_LM3560=m
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
# CONFIG_SOC_CAMERA_IMX074 is not set
# CONFIG_SOC_CAMERA_MT9M001 is not set
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
# CONFIG_SOC_CAMERA_OV6650 is not set
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_SOC_CAMERA_RJ54N1=m
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=m
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
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
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=m
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_UX500=m
# CONFIG_USB_UX500_DMA is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=m
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_KEYSTONE_USB_PHY=m
CONFIG_NOP_USB_XCEIV=m
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_RCAR_GEN2_PHY=m
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_SH_MMCIF=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
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
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_PRISM2_USB=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
# CONFIG_COMEDI_PCM3724 is not set
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
# CONFIG_COMEDI_AMPLC_PC263_ISA is not set
# CONFIG_COMEDI_RTI800 is not set
CONFIG_COMEDI_RTI802=m
# CONFIG_COMEDI_DAC02 is not set
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
# CONFIG_COMEDI_DAS16 is not set
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
# CONFIG_COMEDI_DT2811 is not set
CONFIG_COMEDI_DT2814=m
# CONFIG_COMEDI_DT2815 is not set
CONFIG_COMEDI_DT2817=m
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
# CONFIG_COMEDI_UNIOXX5 is not set
CONFIG_COMEDI_FL512=m
CONFIG_COMEDI_AIO_AIO12_8=m
# CONFIG_COMEDI_AIO_IIRO_16 is not set
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
# CONFIG_COMEDI_NI_AT_AO is not set
# CONFIG_COMEDI_NI_ATMIO is not set
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_NI_LABPC_ISA=m
# CONFIG_COMEDI_PCMAD is not set
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
# CONFIG_COMEDI_MULTIQ3 is not set
CONFIG_COMEDI_S526=m
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_LABPC_ISADMA=m
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
CONFIG_RTS5139=m
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
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_LPC32XX_ADC=y
CONFIG_MXS_LRADC=m
# CONFIG_SPEAR_ADC is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
CONFIG_USB_ENESTORAGE=m
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=m

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_VIDEO_TCM825X is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=m
# CONFIG_UNISYSSPAR is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
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
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
CONFIG_SH_TIMER_MTU2=y
CONFIG_SH_TIMER_TMU=y
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
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
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m
CONFIG_XILINX_XADC=y

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
CONFIG_AD5380=m
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
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=m
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
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
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
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
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
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

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
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
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
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
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
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
# CONFIG_LOCK_TORTURE_TEST is not set
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
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_STMP_DEVICE=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
# CONFIG_CRC64_ECMA is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
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
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--zhXaljGHf11kAtnf--
