Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaCPNSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:18:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:62780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaCPNSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:18:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="log'?scan'208";a="493079305"
Date: Sun, 16 Mar 2014 21:17:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKP <fnstml-lkp@cn.fujitsu.com>, Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [logfs] BUG: sleeping function called from invalid context at
 kernel/locking/rwsem.c:20
Message-ID: <20140316131757.GA8972@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joern,

FYI, this BUG is too old to be bisected:

[    4.906444] Freeing unused kernel memory: 1244K (d2892000 - d29c9000)
[    5.631187] LogFS: Start mount 0
[    5.642106] LogFS: Start unmounting
[    5.651816] INFO: trying to register non-static key.
[    5.652023] the code is fine but needs lockdep annotation.
[    5.652023] turning off the locking correctness validator.
[    5.652023] CPU: 0 PID: 381 Comm: mount Not tainted 3.14.0-rc6-next-20140313-08623-gaf911c6 #2
[    5.652023] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.652023]  cd538c44 ccda7d7c d176dee0 ccda7dc0 cf4e458c d2070e6c d179ae00 ccda7e34
[    5.652023]  cf61e805 00000002 0000407c d2b5a830 cce93000 c0027e40 00000000 cd538c44
[    5.652023]  ccd54390 ccd54390 cd538c44 00000000 ccda7dec cf4e5ccc 00000000 00000000
[    5.652023] Call Trace:
[    5.652023]  [<d176dee0>] dump_stack+0x40/0x5e
[    5.652023]  [<cf4e458c>] __lock_acquire.isra.21+0x3ac/0x1a40
[    5.652023]  [<d179ae00>] ? wait_for_completion+0x20/0x40
[    5.652023]  [<cf61e805>] ? writeback_inodes_sb_nr+0x105/0x140
[    5.652023]  [<cf4e5ccc>] lock_acquire+0xac/0x100
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<d179b0cf>] mutex_lock_nested+0xaf/0x6c0
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf77be6d>] logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf776243>] logfs_sync_fs+0x23/0x80
[    5.652023]  [<cf62487c>] __sync_filesystem+0x7c/0xc0
[    5.652023]  [<cf624bb2>] sync_filesystem+0x72/0xc0
[    5.652023]  [<cf78387d>] logfs_kill_sb+0x3d/0x220
[    5.652023]  [<cf5d970e>] deactivate_locked_super+0x8e/0x100
[    5.652023]  [<cf7852cf>] logfs_mount+0xc0f/0xce0
[    5.652023]  [<cf5dc113>] mount_fs+0xd3/0x2e0
[    5.652023]  [<cf58d11b>] ? kstrdup+0x5b/0xa0
[    5.652023]  [<cf60e4d1>] vfs_kern_mount+0x91/0x200
[    5.652023]  [<d17a1f6d>] ? _raw_read_unlock+0x6d/0xc0
[    5.652023]  [<cf6129c3>] do_mount+0x1383/0x1700
[    5.652023]  [<cf58d7ba>] ? strndup_user+0x5a/0xa0
[    5.652023]  [<cf613345>] SyS_mount+0x105/0x1a0
[    5.652023]  [<d17a368d>] syscall_call+0x7/0xb
[    5.688034] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    5.689025] IP: [<d179b2ea>] mutex_lock_nested+0x2ca/0x6c0
[    5.689025] *pdpt = 000000000ce7f001 *pde = 0000000000000000
[    5.689025] Oops: 0002 [#1] PREEMPT
[    5.689025] CPU: 0 PID: 381 Comm: mount Not tainted 3.14.0-rc6-next-20140313-08623-gaf911c6 #2
[    5.689025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.689025] task: ccd54390 ti: ccda6000 task.ti: ccda6000
[    5.689025] EIP: 0060:[<d179b2ea>] EFLAGS: 00010046 CPU: 0
[    5.689025] EIP is at mutex_lock_nested+0x2ca/0x6c0
[    5.689025] EAX: 00000000 EBX: cd538c04 ECX: cd538c30 EDX: ccda7e10
[    5.689025] ESI: 00000246 EDI: ccd54390 EBP: ccda7e2c ESP: ccda7df4
[    5.689025]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[    5.689025] CR0: 8005003b CR2: 00000000 CR3: 0cea5000 CR4: 000006f0
[    5.689025] Stack:
[    5.689025]  00000000 00000001 00000000 cf77be6d cd538c30 cd538c44 cf77be6d cd538c30
[    5.689025]  00000000 11111111 ccda7e10 cce93000 00000000 ffffffea ccda7e3c cf77be6d
[    5.689025]  cce93000 00000000 ccda7e48 cf776243 cce93000 ccda7e58 cf62487c cce93000
[    5.689025] Call Trace:
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf776243>] logfs_sync_fs+0x23/0x80
[    5.689025]  [<cf62487c>] __sync_filesystem+0x7c/0xc0
[    5.689025]  [<cf624bb2>] sync_filesystem+0x72/0xc0
[    5.689025]  [<cf78387d>] logfs_kill_sb+0x3d/0x220
[    5.689025]  [<cf5d970e>] deactivate_locked_super+0x8e/0x100
[    5.689025]  [<cf7852cf>] logfs_mount+0xc0f/0xce0
[    5.689025]  [<cf5dc113>] mount_fs+0xd3/0x2e0
[    5.689025]  [<cf58d11b>] ? kstrdup+0x5b/0xa0
[    5.689025]  [<cf60e4d1>] vfs_kern_mount+0x91/0x200
[    5.689025]  [<d17a1f6d>] ? _raw_read_unlock+0x6d/0xc0
[    5.689025]  [<cf6129c3>] do_mount+0x1383/0x1700
[    5.689025]  [<cf58d7ba>] ? strndup_user+0x5a/0xa0
[    5.689025]  [<cf613345>] SyS_mount+0x105/0x1a0
[    5.689025]  [<d17a368d>] syscall_call+0x7/0xb
[    5.689025] Code: e4 e8 fb 43 d4 fd 83 05 e8 f4 a2 d2 01 8d 43 2c 83 15 ec f4 a2 d2 00 8d 55 e4 89 c1 89 45 d8 8b 43 30 89 4d e4 89 53
30 89 45 e8 <89> 10 8b 55 e0 8b 45 dc 89 7d ec e8 e6 72 d4 fd eb 12 8d 74 26


git bisect  bad af911c69655709defa3daa926d72d5447688754c  # 12:56      0-     14  Add linux-next specific files for 20140313
git bisect  bad 475076b4699531be570fa9b2b6a5ca0b770d0fb7  # 14:50      0-      1  Merge remote-tracking branch 'powernv-cpuidle/powernv-cpuidle'
git bisect  bad d8ec26d7f8287f5788a494f56e8814210f0e64be  # 16:11      1-      1  Linux 3.13
git bisect  bad 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 19:09      0-      1  Linux 3.12
git bisect  bad 6e4664525b1db28f8c4e1130957f70a94c19213e  # 19:53      5-      8  Linux 3.11
git bisect  bad 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376  # 20:25      0-      4  Linux 3.10
git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 21:04      0-      1  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 21:30      0-      1  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 22:42      0-      4  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 23:13      0-      1  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 00:05     20-     15  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 00:30      0-      6  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 00:53      0-      1  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 01:24      0-      1  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 02:07      3-      1  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 02:42      1-      2  Linux 3.0

Thanks,
Fengguang

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivytown2-22:20140315004917:i386-randconfig-st0-03150024:3.14.0-rc6-next-20140313-08623-gaf911c6:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-next-20140313-08623-gaf911c6 (kbuil=
d@lkp-st01) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 PREEMPT Sat Mar 15 00:=
47:58 CST 2014
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x13ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f200000-0x0f3fffff]
[    0.000000]  [mem 0x0f200000-0x0f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f1fffff]
[    0.000000]  [mem 0x0c000000-0x0f1fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0f400000-0x13ffdfff]
[    0.000000]  [mem 0x0f400000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
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
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffe pmd: d29c=
94f8 pmd phys: 129c94f8 pte: d3a40ff0 pte phys: 13a40ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fff pmd: d29c=
94f8 pmd phys: 129c94f8 pte: d3a40ff8 pte phys: 13a40ff8
[    0.000000] BRK [0x13a42000, 0x13a42fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d2889420, node_mem_map cf=
180020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff7000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12347780
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-st0-03150024/next:m=
aster/.vmlinuz-af911c69655709defa3daa926d72d5447688754c-20140315004838-4-iv=
ytown2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-st0-031500=
24/af911c69655709defa3daa926d72d5447688754c/vmlinuz-3.14.0-rc6-next-2014031=
3-08623-gaf911c6
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 248940K/327280K available (36499K kernel code, 5598K=
 rwdata, 11588K rodata, 1244K init, 16224K bss, 78340K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff89000 - 0xfffff000   ( 472 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd2892000 - 0xd29c9000   (1244 kB)
[    0.000000]       .data : 0xd17a519c - 0xd2890b40   (17326 kB)
[    0.000000]       .text : 0xcf400000 - 0xd17a519c   (36500 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dcec0a000 soft=3Dcec0c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-next-20140313-08623-gaf911c6 (kbuil=
d@lkp-st01) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 PREEMPT Sat Mar 15 00:=
47:58 CST 2014
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x13ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f200000-0x0f3fffff]
[    0.000000]  [mem 0x0f200000-0x0f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f1fffff]
[    0.000000]  [mem 0x0c000000-0x0f1fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0f400000-0x13ffdfff]
[    0.000000]  [mem 0x0f400000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
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
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffe pmd: d29c=
94f8 pmd phys: 129c94f8 pte: d3a40ff0 pte phys: 13a40ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fff pmd: d29c=
94f8 pmd phys: 129c94f8 pte: d3a40ff8 pte phys: 13a40ff8
[    0.000000] BRK [0x13a42000, 0x13a42fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d2889420, node_mem_map cf=
180020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff7000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12347780
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-st0-03150024/next:m=
aster/.vmlinuz-af911c69655709defa3daa926d72d5447688754c-20140315004838-4-iv=
ytown2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-st0-031500=
24/af911c69655709defa3daa926d72d5447688754c/vmlinuz-3.14.0-rc6-next-2014031=
3-08623-gaf911c6
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 248940K/327280K available (36499K kernel code, 5598K=
 rwdata, 11588K rodata, 1244K init, 16224K bss, 78340K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff89000 - 0xfffff000   ( 472 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd2892000 - 0xd29c9000   (1244 kB)
[    0.000000]       .data : 0xd17a519c - 0xd2890b40   (17326 kB)
[    0.000000]       .text : 0xcf400000 - 0xd17a519c   (36500 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dcec0a000 soft=3Dcec0c000
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2494.156 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4988.31 Bogo=
MIPS (lpj=3D2494156)
[    0.003680] pid_max: default: 32768 minimum: 301
[    0.004033] ACPI: Core revision 20140214
[    0.008143] ACPI: All ACPI Tables successfully acquired
[    0.009097] Security Framework initialized
[    0.009774] AppArmor: AppArmor initialized
[    0.010007] Yama: becoming mindful.
[    0.011043] Mount-cache hash table entries: 512
[    0.012401] Initializing cgroup subsys debug
[    0.013013] Initializing cgroup subsys devices
[    0.013717] Initializing cgroup subsys net_cls
[    0.014011] Initializing cgroup subsys net_prio
[    0.015082] mce: CPU supports 10 MCE banks
[    0.016071] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016071] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016071] tlb_flushall_shift: 6
[    0.017007] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.024104] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.026506] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.027009] Getting VERSION: 50014
[    0.027596] Getting VERSION: 50014
[    0.028008] Getting ID: 0
[    0.029013] Getting ID: f000000
[    0.029574] Getting LVT0: 8700
[    0.030015] Getting LVT1: 8400
[    0.030591] enabled ExtINT on CPU#0
[    0.032255] ENABLING IO-APIC IRQs
[    0.032833] init IO_APIC IRQs
[    0.033008]  apic 0 pin 0 not connected
[    0.034020] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.035028] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.036027] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.037025] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.038026] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.039026] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.040031] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.041027] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.042026] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.043026] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.044025] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.045026] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.046026] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.047026] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.048026] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.049023]  apic 0 pin 16 not connected
[    0.049658]  apic 0 pin 17 not connected
[    0.050006]  apic 0 pin 18 not connected
[    0.051006]  apic 0 pin 19 not connected
[    0.051646]  apic 0 pin 20 not connected
[    0.052005]  apic 0 pin 21 not connected
[    0.053006]  apic 0 pin 22 not connected
[    0.053649]  apic 0 pin 23 not connected
[    0.054150] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.055005] Using local APIC timer interrupts.
[    0.055005] calibrating APIC timer ...
[    0.057000] ... lapic delta =3D 6249986
[    0.057000] ... PM-Timer delta =3D 357966
[    0.057000] ... PM-Timer result ok
[    0.057000] ..... delta 6249986
[    0.057000] ..... mult: 268434854
[    0.057000] ..... calibration result: 999997
[    0.057000] ..... CPU clock speed is 2494.0054 MHz.
[    0.057000] ..... host bus clock speed is 999.0997 MHz.
[    0.057443] devtmpfs: initialized
[    0.058354] gcov: version magic: 0x3430382a
[    0.064555] xor: measuring software checksum speed
[    0.075005]    pIII_sse  :   140.000 MB/sec
[    0.085029]    prefetch64-sse:   140.000 MB/sec
[    0.085910] xor: using function: prefetch64-sse (140.000 MB/sec)
[    0.086009] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.087333] regulator-dummy: no parameters
[    0.088250] NET: Registered protocol family 16
[    0.090971] cpuidle: using governor ladder
[    0.091007] cpuidle: using governor menu
[    0.093749] ACPI: bus type PCI registered
[    0.094089] dca service started, version 1.12.1
[    0.095423] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.096011] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.097004] PCI: Using configuration type 1 for base access
[    0.161067] raid6: mmxx1      718 MB/s
[    0.178077] raid6: mmxx2      781 MB/s
[    0.195067] raid6: sse1x1     570 MB/s
[    0.212064] raid6: sse1x2     734 MB/s
[    0.229030] raid6: sse2x1    1128 MB/s
[    0.246026] raid6: sse2x2    1460 MB/s
[    0.246798] raid6: using algorithm sse2x2 (1460 MB/s)
[    0.247004] raid6: using intx1 recovery algorithm
[    0.249056] ACPI: Added _OSI(Module Device)
[    0.249903] ACPI: Added _OSI(Processor Device)
[    0.250006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.251006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.262275] ACPI: Interpreter enabled
[    0.263012] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.264546] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.266587] ACPI: (supports S0 S3 S5)
[    0.267005] ACPI: Using IOAPIC for interrupt routing
[    0.268056] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.281924] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.282014] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.283026] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.285028] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.286130] PCI host bridge to bus 0000:00
[    0.287008] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.288006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.289006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.290006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.291006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.292069] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.293689] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.295678] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.299007] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.301447] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.303027] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.304017] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.306287] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.309046] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.311596] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.318085] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.320513] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.322432] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.324438] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.329430] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.331404] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.332462] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.336433] pci_bus 0000:00: on NUMA node 0
[    0.338202] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.339782] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.341466] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.343109] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.344570] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.346728] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.349099] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.350008] vgaarb: loaded
[    0.351004] vgaarb: bridge control possible 0000:00:02.0
[    0.353620] SCSI subsystem initialized
[    0.354080] libata version 3.00 loaded.
[    0.355194] ACPI: bus type USB registered
[    0.356113] usbcore: registered new interface driver usbfs
[    0.357059] usbcore: registered new interface driver hub
[    0.358091] usbcore: registered new device driver usb
[    0.359142] Linux video capture interface: v2.00
[    0.360074] pps_core: LinuxPPS API ver. 1 registered
[    0.361008] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.362052] PTP clock support registered
[    0.363070] EDAC MC: Ver: 3.0.0
[    0.364612] PCI: Using ACPI for IRQ routing
[    0.365013] PCI: pci_cache_line_size set to 64 bytes
[    0.366140] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.367020] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.369519] NET: Registered protocol family 23
[    0.370078] Bluetooth: Core ver 2.19
[    0.371048] NET: Registered protocol family 31
[    0.372007] Bluetooth: HCI device and connection manager initialized
[    0.373026] Bluetooth: HCI socket layer initialized
[    0.374023] Bluetooth: L2CAP socket layer initialized
[    0.375070] Bluetooth: SCO socket layer initialized
[    0.376028] NET: Registered protocol family 8
[    0.377008] NET: Registered protocol family 20
[    0.378558] nfc: nfc_init: NFC Core ver 0.1
[    0.379060] NET: Registered protocol family 39
[    0.381051] cfg80211: Calling CRDA to update world regulatory domain
[    0.383160] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.384075] Switched to clocksource kvm-clock
[    0.385438] AppArmor: AppArmor Filesystem Enabled
[    0.386417] pnp: PnP ACPI init
[    0.387144] ACPI: bus type PNP registered
[    0.388072] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.389727] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.390990] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.392643] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.393887] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.395543] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.396806] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.398372] pnp 00:03: [dma 2]
[    0.399123] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.400398] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.402036] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.403319] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.404967] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.406686] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.408151] pnp: PnP ACPI: found 7 devices
[    0.408989] ACPI: bus type PNP unregistered
[    0.704042] mdacon: MDA with 8K of memory detected.
[    0.704103] Console: switching consoles 13-16 to MDA-2
[    0.741114] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.742201] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.743249] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.744398] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.745601] NET: Registered protocol family 1
[    0.746512] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.747625] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.748713] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.749878] pci 0000:00:02.0: Boot video device
[    0.750804] PCI: CLS 0 bytes, default 64
[    0.751936] Unpacking initramfs...
[    0.874897] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    0.877438] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.878650] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.882601] PCLMULQDQ-NI instructions are not detected.
[    0.883678] NatSemi SCx200 Driver
[    0.886956] futex hash table entries: 256 (order: 1, 12288 bytes)
[    0.888171] Initialise system trusted keyring
[    0.889173] audit: initializing netlink subsys (disabled)
[    0.890312] audit: type=3D2000 audit(1394815747.960:1): initialized
[    1.880432] tsc: Refined TSC clocksource calibration: 2493.969 MHz
[    2.015319] VFS: Disk quotas dquot_6.5.2
[    2.016173] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.017674] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    2.018690] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.021087] QNX6 filesystem 1.0.0 registered.
[    2.022079] fuse init (API version 7.22)
[    2.023169] JFS: nTxBlock =3D 1970, nTxLock =3D 15763
[    2.025691] SGI XFS with ACLs, security attributes, realtime, debug enab=
led
[    2.027337] NILFS version 2 loaded
[    2.028322] OCFS2 User DLM kernel interface loaded
[    2.029958] msgmni has been set to 492
[    2.036231] alg: No test for crc32 (crc32-table)
[    2.037573] alg: No test for lz4 (lz4-generic)
[    2.038592] alg: No test for stdrng (krng)
[    2.048845] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    2.050134] async_tx: api initialized (async)
[    2.051037] Key type asymmetric registered
[    2.051889] Asymmetric key parser 'x509' registered
[    2.052923] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.054477] io scheduler noop registered
[    2.055290] io scheduler deadline registered
[    2.056192] io scheduler cfq registered (default)
[    2.057157] list_sort_test: start testing list_sort()
[    2.058962] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    2.059948] crc32: self tests passed, processed 225944 bytes in 155448 n=
sec
[    2.061363] crc32c: CRC_LE_BITS =3D 64
[    2.062114] crc32c: self tests passed, processed 225944 bytes in 80074 n=
sec
[    2.302844] crc32_combine: 8373 self tests passed
[    2.545543] crc32c_combine: 8373 self tests passed
[    2.546516] rbtree testing -> 10104 cycles
[    3.002867] augmented rbtree testing -> 15446 cycles
[    3.688744] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.689813] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.691226] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.692413] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    3.693671] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.695169] cpcihp_generic: not configured, disabling.
[    3.696185] Console: switching consoles 13-16 to MDA-2
[    3.697942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.699422] ACPI: Power Button [PWRF]
[    3.700626] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.701966] xenfs: not registering filesystem on non-xen platform
[    3.743419] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.744472] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.767492] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.770864] serial: Freescale lpuart driver
[    3.771856] MOXA Smartio/Industio family driver version 2.0.5
[    3.772990] Initializing Nozomi driver 2.1d
[    3.773909] RocketPort device driver module, version 2.09, 12-June-2003
[    3.775128] No rocketport ports found; unloading driver
[    3.776116] SyncLink GT
[    3.776716] SyncLink GT, tty major#241
[    3.777529] SyncLink GT no devices found
[    3.778335] SyncLink MultiPort driver $Revision: 4.38 $
[    3.789675] SyncLink MultiPort driver $Revision: 4.38 $, tty major#240
[    3.791162] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    3.792474] ac.o: No PCI boards found.
[    3.793259] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    3.794524] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    3.795754] Non-volatile memory driver v1.3
[    3.796811] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.797804] smapi::smapi_init, ERROR invalid usSmapiID
[    3.798779] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.800502] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.801924] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.803061] Linux agpgart interface v0.103
[    3.804464] SyncLink PC Card driver $Revision: 4.34 $, tty major#238
[    3.806015] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.807446] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.809054] c2port c2port0: C2 port uc added
[    3.809913] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.811767] Guest personality initialized and is inactive
[    3.812922] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    3.814123] Initialized host personality
[    3.815097] usbcore: registered new interface driver rtsx_usb
[    3.816714] usbcore: registered new interface driver pn533
[    3.818248] usbcore: registered new interface driver port100
[    3.819354] usbcore: registered new interface driver nfcmrvl
[    3.820414] Uniform Multi-Platform E-IDE driver
[    3.822298] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    3.824144] ide-gd driver 1.18
[    3.825235] Loading iSCSI transport class v2.0-870.
[    3.826485] hp_sw: device handler registered
[    3.827359] alua: device handler registered
[    3.828412] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    3.829519] fnic: Successfully Initialized Trace Buffer
[    3.830730] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    3.834004] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    3.835058] Detecting Adaptec I2O RAID controllers...
[    3.836903] Adaptec aacraid driver 1.2-0[30200]-ms
[    3.837946] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.839449] scsi: <fdomain> Detection failed (no card)
[    3.840493] sym53c416.c: Version 1.0.0-ac
[    3.841382] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D options
[    3.843117] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.02-k.
[    3.845084] iscsi: registered transport (qla4xxx)
[    3.846052] QLogic iSCSI HBA Driver
[    3.846797] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    3.930408] DC390: clustering now enabled by default. If you get problem=
s load
[    3.931870]        with "disable_clustering=3D1" and report to maintaine=
rs
[    3.933136] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    3.934677] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    3.935985] mpt2sas version 16.100.00.00 loaded
[    3.937043] mpt3sas version 02.100.00.00 loaded
[    3.938166] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    3.939682] nsp32: loading...
[    3.940397] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    3.941980] RocketRAID 3xxx/4xxx Controller driver v1.8
[    3.943032] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    3.944280] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2=
013)
[    3.945607] iscsi: registered transport (bnx2i)
[    3.946611] iscsi: registered transport (be2iscsi)
[    3.947551] In beiscsi_module_init, tt=3Dd2641b20
[    3.948797] SCSI Media Changer driver v0.25=20
[    3.949783] osd: LOADED open-osd 0.2.1
[    3.957945] scsi_debug: host protection
[    3.958764] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    3.960920] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    3.963203] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.965150] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    3.966475] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    3.968291] sd 2:0:0:0: [sda] Write Protect is off
[    3.969236] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.970746] slram: not enough parameters.
[    3.971587] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    3.973100] pmc551: not detected
[    3.975137] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    3.976975] ftl_cs: FTL header not found.
[    3.981301] HSI/SSI char device loaded
[    3.983262]  sda: unknown partition table
[    3.985073] arcnet loaded.
[    3.985871] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    3.987156] arcnet: raw mode (`r') encapsulation support loaded.
[    3.988315] arcnet: cap mode (`c') encapsulation support loaded.
[    3.989511] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.990427] arcnet: COM90xx chipset support
[    4.291840] S3: No ARCnet cards found.
[    4.292668] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    4.294102] E-mail me if you actually test this driver, please!
[    4.295190]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    4.296873] vcan: Virtual CAN interface driver
[    4.297798] CAN device driver interface
[    4.298647] usbcore: registered new interface driver ems_usb
[    4.299742] usbcore: registered new interface driver kvaser_usb
[    4.300883] usbcore: registered new interface driver usb_8dev
[    4.301965] sja1000 CAN netdevice driver
[    4.302771] sja1000_isa: insufficient parameters supplied
[    4.304275] cc770: CAN netdevice driver
[    4.305064] cc770_isa: insufficient parameters supplied
[    4.306333] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    4.309663] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    4.311693] Brocade 10G Ethernet driver - version: 3.2.23.0
[    4.313412] QLogic/NetXen Network Driver v4.0.82
[    4.314622] Solarflare NET driver v4.0
[    4.315536] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    4.316623] tehuti: Options: hw_csum=20
[    4.317433] tlan: ThunderLAN driver v1.17
[    4.318306] tlan: 0 devices installed, PCI: 0  EISA: 0
[    4.319367] AX.25: Z8530 SCC driver version 3.0.dl1bke
[    4.320690] YAM driver version 0.8 by F1OAT/F6FBB
[    4.322759] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.322759] baycom_ser_fdx: version 0.10
[    4.325790] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    4.326864] hdlcdrv: version 0.8
[    4.327608] usbcore: registered new interface driver irda-usb
[    4.329292] usbcore: registered new interface driver mcs7780
[    4.330522] usbcore: registered new interface driver kingsun-sir
[    4.331683] usbcore: registered new interface driver ksdazzle-sir
[    4.332844] usbcore: registered new interface driver ks959-sir
[    4.333961] PPP generic driver version 2.4.2
[    4.334980] PPP BSD Compression module registered
[    4.335919] PPP MPPE Compression module registered
[    4.336859] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    4.338117] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    4.339349] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    4.340498] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2=
=2E2kq
[    4.341761] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    4.342896] libipw: 802.11 data/management/control stack, git-1.1.13
[    4.344058] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[    4.345623] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[    4.347480] orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <=
disdos@traum404.de>)
[    4.349210] usbcore: registered new interface driver orinoco_usb
[    4.350358] airo(): Probing for PCI adapters
[    4.351258] airo(): Finished probing for PCI adapters
[    4.352316] Atmel at76x USB Wireless LAN Driver 0.17 loading
[    4.353413] usbcore: registered new interface driver at76c50x-usb
[    4.354573] Broadcom 43xx-legacy driver loaded [ Features: PLD ]
[    4.355981] usbcore: registered new interface driver rndis_wlan
[    4.357148] usbcore: registered new interface driver usb8xxx
[    4.358260] libertas_spi: Libertas SPI driver
[    4.359257] usbcore: registered new interface driver lbtf_usb
[    4.360441] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    4.361510] Copyright(c) 2003- 2014 Intel Corporation
[    4.362580] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tr=
ee:
[    4.363827] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[    4.364955] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:s
[    4.366666] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    4.367952] usbcore: registered new interface driver rt2500usb
[    4.369076] usbcore: registered new interface driver rt2800usb
[    4.370418] usbcore: registered new interface driver i2400m_usb
[    4.371571] usbcore: registered new interface driver kaweth
[    4.372624] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    4.374117] usbcore: registered new interface driver pegasus
[    4.375211] usbcore: registered new interface driver r8152
[    4.376286] usbcore: registered new interface driver asix
[    4.377349] usbcore: registered new interface driver ax88179_178a
[    4.378517] usbcore: registered new interface driver cdc_ether
[    4.379644] usbcore: registered new interface driver cdc_eem
[    4.380743] usbcore: registered new interface driver dm9601
[    4.381831] usbcore: registered new interface driver smsc75xx
[    4.382944] usbcore: registered new interface driver smsc95xx
[    4.384045] usbcore: registered new interface driver gl620a
[    4.385130] usbcore: registered new interface driver net1080
[    4.386239] usbcore: registered new interface driver plusb
[    4.387313] usbcore: registered new interface driver rndis_host
[    4.388449] usbcore: registered new interface driver cdc_subset
[    4.389585] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    4.391087] usbcore: registered new interface driver int51x1
[    4.392186] usbcore: registered new interface driver cdc_phonet
[    4.393318] usbcore: registered new interface driver kalmia
[    4.394405] usbcore: registered new interface driver ipheth
[    4.395477] usbcore: registered new interface driver sierra_net
[    4.396617] usbcore: registered new interface driver cdc_ncm
[    4.397713] usbcore: registered new interface driver huawei_cdc_ncm
[    4.398898] usbcore: registered new interface driver lg-vl600
[    4.400007] usbcore: registered new interface driver qmi_wwan
[    4.401110] usbcore: registered new interface driver cdc_mbim
[    4.402250] Madge ATM Ambassador driver version 1.2.4
[    4.403225] amb: debug bitmap is 0
[    4.403996] Madge ATM Horizon [Ultra] driver version 1.2.1
[    4.405030] hrz: debug bitmap is 0
[    4.405898] idt77252_init: at d2926f60
[    4.406735] adummy: version 1.0
[    4.408059] Databook TCIC-2 PCMCIA probe: not found.
[    4.409239] usbcore: registered new interface driver hwa-rc
[    4.410701] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.411891] ehci-pci: EHCI PCI platform driver
[    4.412836] ehci-platform: EHCI generic platform driver
[    4.413933] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.415117] ohci-pci: OHCI PCI platform driver
[    4.416049] ohci-platform: OHCI generic platform driver
[    4.417089] uhci_hcd: USB Universal Host Controller Interface driver
[    4.418471] usbcore: registered new interface driver hwa-hc
[    4.419683] usbcore: registered new interface driver wusb-cbaf
[    4.420844] usbcore: registered new interface driver cdc_acm
[    4.421912] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.423511] usbcore: registered new interface driver usblp
[    4.424605] usbcore: registered new interface driver cdc_wdm
[    4.425709] usbcore: registered new interface driver usbtmc
[    4.426799] usbcore: registered new interface driver mdc800
[    4.427845] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    4.429375] usbcore: registered new interface driver microtekX6
[    4.430597] usbcore: registered new interface driver usbserial
[    4.431719] usbcore: registered new interface driver ark3116
[    4.432838] usbserial: USB Serial support registered for ark3116
[    4.433992] usbcore: registered new interface driver belkin_sa
[    4.435109] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    4.436864] usbcore: registered new interface driver ch341
[    4.437926] usbserial: USB Serial support registered for ch341-uart
[    4.439096] usbcore: registered new interface driver cp210x
[    4.440175] usbserial: USB Serial support registered for cp210x
[    4.441302] usbcore: registered new interface driver cyberjack
[    4.442421] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    4.444089] usbcore: registered new interface driver cypress_m8
[    4.445212] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    4.446678] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    4.448169] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    4.449655] usbcore: registered new interface driver digi_acceleport
[    4.450844] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    4.452334] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    4.453822] usbcore: registered new interface driver io_edgeport
[    4.454973] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    4.456470] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    4.457959] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    4.459451] usbserial: USB Serial support registered for EPiC device
[    4.460642] usbcore: registered new interface driver io_ti
[    4.461707] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    4.463253] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    4.464784] usbcore: registered new interface driver empeg
[    4.465856] usbserial: USB Serial support registered for empeg
[    4.466989] usbcore: registered new interface driver f81232
[    4.468069] usbserial: USB Serial support registered for f81232
[    4.469191] usbcore: registered new interface driver ftdi_sio
[    4.470502] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    4.472364] usbcore: registered new interface driver garmin_gps
[    4.473496] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    4.474776] usbcore: registered new interface driver ipw
[    4.475819] usbserial: USB Serial support registered for IPWireless conv=
erter
[    4.477141] usbcore: registered new interface driver ir_usb
[    4.478238] usbserial: USB Serial support registered for IR Dongle
[    4.479408] usbcore: registered new interface driver keyspan
[    4.480506] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    4.482076] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    4.483558] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    4.485044] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    4.486547] usbcore: registered new interface driver keyspan_pda
[    4.487681] usbserial: USB Serial support registered for Keyspan PDA
[    4.488883] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    4.490473] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    4.492193] usbcore: registered new interface driver kobil_sct
[    4.493316] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    4.496638] usbcore: registered new interface driver metro_usb
[    4.497759] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    4.499261] usbcore: registered new interface driver mos7720
[    4.500353] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    4.501863] usbcore: registered new interface driver mxuport
[    4.502971] usbserial: USB Serial support registered for MOXA UPort
[    4.504156] usbcore: registered new interface driver opticon
[    4.505246] usbserial: USB Serial support registered for opticon
[    4.506389] usbcore: registered new interface driver option
[    4.507473] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    4.508758] usbcore: registered new interface driver pl2303
[    4.509839] usbserial: USB Serial support registered for pl2303
[    4.510965] usbcore: registered new interface driver qcserial
[    4.512067] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    4.513354] usbcore: registered new interface driver safe_serial
[    4.514499] usbserial: USB Serial support registered for safe_serial
[    4.515690] usbcore: registered new interface driver sierra
[    4.516764] usbserial: USB Serial support registered for Sierra USB modem
[    4.518022] usbcore: registered new interface driver spcp8x5
[    4.519110] usbserial: USB Serial support registered for SPCP8x5
[    4.520256] usbcore: registered new interface driver symbolserial
[    4.521413] usbserial: USB Serial support registered for symbol
[    4.522551] usbcore: registered new interface driver visor
[    4.523628] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    4.525172] usbserial: USB Serial support registered for Sony Clie 5.0
[    4.526381] usbserial: USB Serial support registered for Sony Clie 3.5
[    4.527593] usbcore: registered new interface driver whiteheat
[    4.528712] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    4.530459] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    4.531962] usbcore: registered new interface driver xsens_mt
[    4.533068] usbserial: USB Serial support registered for xsens_mt
[    4.534238] usbcore: registered new interface driver adutux
[    4.535383] usbcore: registered new interface driver appledisplay
[    4.536558] usbcore: registered new interface driver cypress_cy7c63
[    4.537740] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    4.539051] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    4.540352] usbcore: registered new interface driver idmouse
[    4.541452] usbcore: registered new interface driver isight_firmware
[    4.542674] usbcore: registered new interface driver ldusb
[    4.543759] usbcore: registered new interface driver usbled
[    4.544847] usbcore: registered new interface driver legousbtower
[    4.546012] usbcore: registered new interface driver rio500
[    4.547096] usbcore: registered new interface driver usbtest
[    4.548196] usbcore: registered new interface driver usb_ehset_test
[    4.549394] usbcore: registered new interface driver trancevibrator
[    4.550592] usbcore: registered new interface driver yurex
[    4.551809] usbcore: registered new interface driver cxacru
[    4.552903] usbcore: registered new interface driver speedtch
[    4.554356] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    4.555842] dummy_hcd dummy_hcd.0: Dummy host controller
[    4.557031] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    4.558736] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.559974] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.561415] usb usb1: Product: Dummy host controller
[    4.562366] usb usb1: Manufacturer: Linux 3.14.0-rc6-next-20140313-08623=
-gaf911c6 dummy_hcd
[    4.563970] usb usb1: SerialNumber: dummy_hcd.0
[    4.565427] hub 1-0:1.0: USB hub found
[    4.566283] hub 1-0:1.0: 1 port detected
[    4.568069] gadgetfs: USB Gadget filesystem, version 24 Aug 2004
[    4.569306] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.571760] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.572893] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.574717] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.577169] usbcore: registered new interface driver usb_acecad
[    4.578322] usbcore: registered new interface driver aiptek
[    4.579403] usbcore: registered new interface driver hanwang
[    4.580509] usbcore: registered new interface driver kbtab
[    4.581598] usbcore: registered new interface driver wacom
[    4.582634] I2O subsystem v1.325
[    4.583336] i2o: max drivers =3D 8
[    4.584276] I2O Configuration OSM v1.323
[    4.585222] I2O Bus Adapter OSM v1.317
[    4.586029] I2O SCSI Peripheral OSM v1.316
[    4.586889] I2O ProcFS OSM v1.316
[    4.587649] i2c /dev entries driver
[    4.588938] usbcore: registered new interface driver i2c-diolan-u2c
[    4.590198] usbcore: registered new interface driver i2c-tiny-usb
[    4.591553] isa i2c-pca-isa.0: Please specify I/O base
[    4.594157] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    4.595869] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    4.597301] vivi-000: V4L2 device registered as video0
[    4.598294] Video Technology Magazine Virtual Video Capture Board ver 0.=
8.1 successfully loaded.
[    4.600237] m2m-testdev m2m-testdev.0: Device registered as /dev/video1
[    4.601592] usbcore: registered new interface driver ttusb-dec
[    4.602740] usbcore: registered new interface driver ttusb
[    4.603820] usbcore: registered new interface driver smsusb
[    4.604913] usbcore: registered new interface driver b2c2_flexcop_usb
[    4.606144] usbcore: registered new interface driver zr364xx
[    4.607248] usbcore: registered new interface driver stkwebcam
[    4.608339] gspca_main: v2.14.0 registered
[    4.609214] usbcore: registered new interface driver conex
[    4.610288] usbcore: registered new interface driver etoms
[    4.611378] usbcore: registered new interface driver jeilinj
[    4.612477] usbcore: registered new interface driver jl2005bcd
[    4.613604] usbcore: registered new interface driver kinect
[    4.614684] usbcore: registered new interface driver konica
[    4.615766] usbcore: registered new interface driver ov519
[    4.616842] usbcore: registered new interface driver ov534_9
[    4.617952] usbcore: registered new interface driver pac207
[    4.619034] usbcore: registered new interface driver pac7311
[    4.620150] usbcore: registered new interface driver gspca_sn9c20x
[    4.621336] usbcore: registered new interface driver sonixb
[    4.622426] usbcore: registered new interface driver spca500
[    4.623539] usbcore: registered new interface driver spca501
[    4.624649] usbcore: registered new interface driver spca508
[    4.625764] usbcore: registered new interface driver spca561
[    4.626874] usbcore: registered new interface driver spca1528
[    4.627980] usbcore: registered new interface driver sq905
[    4.629054] usbcore: registered new interface driver sq930x
[    4.630148] usbcore: registered new interface driver stk014
[    4.631244] usbcore: registered new interface driver stv0680
[    4.632346] usbcore: registered new interface driver vc032x
[    4.633445] usbcore: registered new interface driver vicam
[    4.634533] usbcore: registered new interface driver xirlink-cit
[    4.635689] usbcore: registered new interface driver gspca_zc3xx
[    4.636836] usbcore: registered new interface driver ALi m5602
[    4.637970] usbcore: registered new interface driver STV06xx
[    4.639070] usbcore: registered new interface driver gspca_gl860
[    4.640185] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    4.641379] usbcore: registered new interface driver cpia2
[    4.642427] au0828 driver loaded
[    4.643171] usbcore: registered new interface driver au0828
[    4.644264] usbcore: registered new interface driver usbvision
[    4.645350] USBVision USB Video Device Driver for Linux : 0.9.11
[    4.646488] usbcore: registered new interface driver stk1160
[    4.647589] usbcore: registered new interface driver em28xx
[    4.648679] usbcore: registered new interface driver usbtv
[    4.649713] smssdio: Siano SMS1xxx SDIO driver
[    4.650593] smssdio: Copyright Pierre Ossman
[    4.651569] usbcore: registered new interface driver dsbr100
[    4.652678] usbcore: registered new interface driver radio-mr800
[    4.653828] usbcore: registered new interface driver radio-ma901
[    4.655245] pps_ldisc: PPS line discipline registered
[    4.656300] Driver for 1-wire Dallas network protocol.
[    4.657428] usbcore: registered new interface driver DS9490R
[    4.658497] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.660597] applesmc: supported laptop not found!
[    4.661529] applesmc: driver init failed (ret=3D-19)!
[    4.664213] pc87360: PC8736x not detected, module not inserted
[    4.665345] sch56xx_common: Unsupported device id: 0xff
[    4.666355] sch56xx_common: Unsupported device id: 0xff
[    4.667807] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    4.669758] mixcomwd: No card detected, or port not available
[    4.671460] usbcore: registered new interface driver pcwd_usb
[    4.672750] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    4.674401] acquirewdt: I/O address 0x0043 already in use
[    4.675439] acquirewdt: probe of acquirewdt failed with error -5
[    4.676562] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    4.678363] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    4.679533] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    4.680559] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    4.681734] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    4.683268] wafer5823wdt: I/O address 0x0443 already in use
[    4.684362] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.685621] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    4.686817] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    4.688085] sc1200wdt: build 20020303
[    4.688891] sc1200wdt: io parameter must be specified
[    4.689899] sbc8360: failed to register misc device
[    4.690852] sbc7240_wdt: I/O address 0x0443 already in use
[    4.691879] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    4.694476] smsc37b787_wdt: Unable to register miscdev on minor 130
[    4.697361] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    4.699041] w83697ug_wdt: No W83697UG/UF could be found
[    4.700040] w83977f_wdt: driver v1.00
[    4.700813] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    4.702013] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    4.703123] machzwd: no ZF-Logic found
[    4.704039] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.705608] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.707261] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    4.709465] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    4.711395] device-mapper: multipath: version 1.7.0 loaded
[    4.712478] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.713667] device-mapper: multipath service-time: version 0.2.0 loaded
[    4.714947] device-mapper: cache-policy-mq: version 1.2.0 loaded
[    4.716074] device-mapper: cache cleaner: version 1.0.0 loaded
[    4.717164] Bluetooth: Virtual HCI driver ver 1.4
[    4.718213] usbcore: registered new interface driver bfusb
[    4.719421] usbcore: registered new interface driver btusb
[    4.720462] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    4.721583] usbcore: registered new interface driver ath3k
[    4.723216] lguest: switcher text too large (4384)
[    4.724365] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    4.725643] usbcore: registered new interface driver vub300
[    4.726976] usbcore: registered new interface driver ushc
[    4.728652] leds_ss4200: no LED devices found
[    4.729697] ledtrig-cpu: registered to indicate activity on CPUs
[    4.731553] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    4.734390] usbip_core: usbip_core_init:788: USB/IP Core v1.0.0
[    4.735561] usbcore: registered new device driver usbip-host
[    4.736633] usbip_host: usbip_host_init:306: USB/IP Host Driver v1.0.0
[    4.737882] usbcore: registered new interface driver w35und
[    4.738972] usbcore: registered new interface driver r8712u
[    4.740061] usbcore: registered new interface driver r8188eu
[    4.741122] rts5208: Initializing Realtek PCIE storage driver...
[    4.742312] usbcore: registered new interface driver serqt_usb2
[    4.743448] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[    4.745733] Loading crystalhd 0.9.27
[    4.746726] input: Speakup as /devices/virtual/input/input3
[    4.748029] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    4.749302] speakup 3.1.6: initialized
[    4.750107] synth name on entry is: (null)
[    4.751332] ashmem: initialized
[    4.752210] logger: created 256K log 'log_main'
[    4.753269] logger: created 256K log 'log_events'
[    4.754345] logger: created 256K log 'log_radio'
[    4.755414] logger: created 256K log 'log_system'
[    4.756571] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[    4.757891] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[    4.759850] dgap-1.3-16, Digi International Part Number 40002347_C
[    4.761016] For the tools package please visit http://www.digi.com
[    4.762391] FPGA DOWNLOAD --->
[    4.763070] built at Sat Mar 15 00:24:25 2014 UTC
[    4.764002] FPGA image file name: xlinx_fpga_firmware.bit
[    4.765173] GPIO INIT FAIL!!
[    4.767498]  fake-fmc-carrier: mezzanine 0
[    4.768362]       Manufacturer: fake-vendor
[    4.769240]       Product name: fake-design-for-testing
[    4.770334] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    4.771624] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    4.773565] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    4.774962] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    4.776849] intel_rapl: driver does not support CPU family 15 model 6
[    4.778437] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    4.779963] aedsp16: I/O, IRQ and DMA are mandatory
[    4.780922] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    4.782064] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    4.783587] ad1848: No ISAPnP cards found, trying standard ones...
[    4.784746] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    4.786229] I/O, IRQ, DMA and type are mandatory
[    4.787160] sb: Init: Starting Probe...
[    4.787989] sb: Init: Done
[    4.788648] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[    4.790173] uart6850: irq and io must be set.
[    4.791042] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    4.792711] NET: Registered protocol family 26
[    4.793688] NET: Registered protocol family 17
[    4.794613] NET: Registered protocol family 15
[    4.795591] Ebtables v2.0 registered
[    4.796583] NET: Registered protocol family 4
[    4.797534] NET: Registered protocol family 9
[    4.798430] X25: Linux Version 0.2
[    4.800350] NET: Registered protocol family 6
[    4.801319] NET: Registered protocol family 3
[    4.802238] can: controller area network core (rev 20120528 abi 9)
[    4.803449] NET: Registered protocol family 29
[    4.804353] can: raw protocol (rev 20120528)
[    4.805247] can: netlink gateway (rev 20130117) max_hops=3D1
[    4.806846] NET: Registered protocol family 35
[    4.807801] lib80211: common routines for IEEE802.11 drivers
[    4.808902] lib80211_crypt: registered algorithm 'NULL'
[    4.809914] lib80211_crypt: registered algorithm 'WEP'
[    4.810918] lib80211_crypt: registered algorithm 'CCMP'
[    4.811928] lib80211_crypt: registered algorithm 'TKIP'
[    4.813045] 9pnet: Installing 9P2000 support
[    4.814031] NET: Registered protocol family 37
[    4.814971] Key type dns_resolver registered
[    4.815847] openvswitch: Open vSwitch switching datapath
[    4.817136] NET: Registered protocol family 40
[    4.818025] mpls_gso: MPLS GSO support
[    4.820317]=20
[    4.820317] printing PIC contents
[    4.821423] ... PIC  IMR: ffff
[    4.822108] ... PIC  IRR: 1013
[    4.822807] ... PIC  ISR: 0000
[    4.823509] ... PIC ELCR: 0c00
[    4.824203] printing local APIC contents on CPU#0/0:
[    4.825171] ... APIC ID:      00000000 (0)
[    4.825191] ... APIC VERSION: 00050014
[    4.825191] ... APIC TASKPRI: 00000000 (00)
[    4.825191] ... APIC PROCPRI: 00000000
[    4.825191] ... APIC LDR: 01000000
[    4.825191] ... APIC DFR: ffffffff
[    4.825191] ... APIC SPIV: 000001ff
[    4.825191] ... APIC ISR field:
[    4.825191] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.825191] ... APIC TMR field:
[    4.825191] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.825191] ... APIC IRR field:
[    4.825191] 000000000000000000000000000000000000000000000000000000000000=
8000
[    4.825191] ... APIC ESR: 00000000
[    4.825191] ... APIC ICR: 000408f6
[    4.825191] ... APIC ICR2: 01000000
[    4.825191] ... APIC LVTT: 000200ef
[    4.825191] ... APIC LVTPC: 00010000
[    4.825191] ... APIC LVT0: 00010700
[    4.825191] ... APIC LVT1: 00000400
[    4.825191] ... APIC LVTERR: 000000fe
[    4.825191] ... APIC TMICT: 0000f423
[    4.825191] ... APIC TMCCT: 00000c8a
[    4.825191] ... APIC TDCR: 00000003
[    4.825191]=20
[    4.846969] number of MP IRQ sources: 15.
[    4.847800] number of IO-APIC #0 registers: 24.
[    4.848707] testing the IO APIC.......................
[    4.849718] IO APIC #0......
[    4.850382] .... register #00: 00000000
[    4.851190] .......    : physical APIC id: 00
[    4.852063] .......    : Delivery Type: 0
[    4.852889] .......    : LTS          : 0
[    4.853726] .... register #01: 00170011
[    4.854534] .......     : max redirection entries: 17
[    4.855518] .......     : PRQ implemented: 0
[    4.856380] .......     : IO APIC version: 11
[    4.857261] .... register #02: 00000000
[    4.858047] .......     : arbitration: 00
[    4.858865] .... IRQ redirection table:
[    4.859682] 1    0    0   0   0    0    0    00
[    4.860601] 0    0    0   0   0    1    1    31
[    4.861512] 0    0    0   0   0    1    1    30
[    4.862424] 0    0    0   0   0    1    1    33
[    4.863347] 1    0    0   0   0    1    1    34
[    4.864265] 1    1    0   0   0    1    1    35
[    4.865181] 0    0    0   0   0    1    1    36
[    4.866080] 0    0    0   0   0    1    1    37
[    4.867006] 0    0    0   0   0    1    1    38
[    4.867928] 0    1    0   0   0    1    1    39
[    4.868843] 1    1    0   0   0    1    1    3A
[    4.869810] 1    1    0   0   0    1    1    3B
[    4.871116] 0    0    0   0   0    1    1    3C
[    4.872216] 0    0    0   0   0    1    1    3D
[    4.873139] 0    0    0   0   0    1    1    3E
[    4.874045] 0    0    0   0   0    1    1    3F
[    4.874955] 1    0    0   0   0    0    0    00
[    4.875875] 1    0    0   0   0    0    0    00
[    4.876791] 1    0    0   0   0    0    0    00
[    4.879454] 1    0    0   0   0    0    0    00
[    4.880373] 1    0    0   0   0    0    0    00
[    4.881288] 1    0    0   0   0    0    0    00
[    4.882204] 1    0    0   0   0    0    0    00
[    4.883115] 1    0    0   0   0    0    0    00
[    4.884009] IRQ to pin mappings:
[    4.884715] IRQ0 -> 0:2
[    4.885461] IRQ1 -> 0:1
[    4.886205] IRQ3 -> 0:3
[    4.886938] IRQ4 -> 0:4
[    4.887689] IRQ5 -> 0:5
[    4.888426] IRQ6 -> 0:6
[    4.889172] IRQ7 -> 0:7
[    4.889906] IRQ8 -> 0:8
[    4.890651] IRQ9 -> 0:9
[    4.891395] IRQ10 -> 0:10
[    4.892166] IRQ11 -> 0:11
[    4.892926] IRQ12 -> 0:12
[    4.893699] IRQ13 -> 0:13
[    4.894468] IRQ14 -> 0:14
[    4.895237] IRQ15 -> 0:15
[    4.895996] .................................... done.
[    4.896984] Using IPI Shortcut mode
[    4.898037] Loading compiled-in X.509 certificates
[    4.899790] Btrfs loaded, debug=3Don, integrity-checker=3Don
[    4.901294] Key type trusted registered
[    4.902781] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.903954] EDD information not available.
[    4.906444] Freeing unused kernel memory: 1244K (d2892000 - d29c9000)
[    5.631187] LogFS: Start mount 0
[    5.642106] LogFS: Start unmounting
[    5.651816] INFO: trying to register non-static key.
[    5.652023] the code is fine but needs lockdep annotation.
[    5.652023] turning off the locking correctness validator.
[    5.652023] CPU: 0 PID: 381 Comm: mount Not tainted 3.14.0-rc6-next-2014=
0313-08623-gaf911c6 #2
[    5.652023] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.652023]  cd538c44 ccda7d7c d176dee0 ccda7dc0 cf4e458c d2070e6c d179a=
e00 ccda7e34
[    5.652023]  cf61e805 00000002 0000407c d2b5a830 cce93000 c0027e40 00000=
000 cd538c44
[    5.652023]  ccd54390 ccd54390 cd538c44 00000000 ccda7dec cf4e5ccc 00000=
000 00000000
[    5.652023] Call Trace:
[    5.652023]  [<d176dee0>] dump_stack+0x40/0x5e
[    5.652023]  [<cf4e458c>] __lock_acquire.isra.21+0x3ac/0x1a40
[    5.652023]  [<d179ae00>] ? wait_for_completion+0x20/0x40
[    5.652023]  [<cf61e805>] ? writeback_inodes_sb_nr+0x105/0x140
[    5.652023]  [<cf4e5ccc>] lock_acquire+0xac/0x100
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<d179b0cf>] mutex_lock_nested+0xaf/0x6c0
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf77be6d>] logfs_get_wblocks+0x12d/0x160
[    5.652023]  [<cf776243>] logfs_sync_fs+0x23/0x80
[    5.652023]  [<cf62487c>] __sync_filesystem+0x7c/0xc0
[    5.652023]  [<cf624bb2>] sync_filesystem+0x72/0xc0
[    5.652023]  [<cf78387d>] logfs_kill_sb+0x3d/0x220
[    5.652023]  [<cf5d970e>] deactivate_locked_super+0x8e/0x100
[    5.652023]  [<cf7852cf>] logfs_mount+0xc0f/0xce0
[    5.652023]  [<cf5dc113>] mount_fs+0xd3/0x2e0
[    5.652023]  [<cf58d11b>] ? kstrdup+0x5b/0xa0
[    5.652023]  [<cf60e4d1>] vfs_kern_mount+0x91/0x200
[    5.652023]  [<d17a1f6d>] ? _raw_read_unlock+0x6d/0xc0
[    5.652023]  [<cf6129c3>] do_mount+0x1383/0x1700
[    5.652023]  [<cf58d7ba>] ? strndup_user+0x5a/0xa0
[    5.652023]  [<cf613345>] SyS_mount+0x105/0x1a0
[    5.652023]  [<d17a368d>] syscall_call+0x7/0xb
[    5.688034] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    5.689025] IP: [<d179b2ea>] mutex_lock_nested+0x2ca/0x6c0
[    5.689025] *pdpt =3D 000000000ce7f001 *pde =3D 0000000000000000=20
[    5.689025] Oops: 0002 [#1] PREEMPT=20
[    5.689025] CPU: 0 PID: 381 Comm: mount Not tainted 3.14.0-rc6-next-2014=
0313-08623-gaf911c6 #2
[    5.689025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.689025] task: ccd54390 ti: ccda6000 task.ti: ccda6000
[    5.689025] EIP: 0060:[<d179b2ea>] EFLAGS: 00010046 CPU: 0
[    5.689025] EIP is at mutex_lock_nested+0x2ca/0x6c0
[    5.689025] EAX: 00000000 EBX: cd538c04 ECX: cd538c30 EDX: ccda7e10
[    5.689025] ESI: 00000246 EDI: ccd54390 EBP: ccda7e2c ESP: ccda7df4
[    5.689025]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[    5.689025] CR0: 8005003b CR2: 00000000 CR3: 0cea5000 CR4: 000006f0
[    5.689025] Stack:
[    5.689025]  00000000 00000001 00000000 cf77be6d cd538c30 cd538c44 cf77b=
e6d cd538c30
[    5.689025]  00000000 11111111 ccda7e10 cce93000 00000000 ffffffea ccda7=
e3c cf77be6d
[    5.689025]  cce93000 00000000 ccda7e48 cf776243 cce93000 ccda7e58 cf624=
87c cce93000
[    5.689025] Call Trace:
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf776243>] logfs_sync_fs+0x23/0x80
[    5.689025]  [<cf62487c>] __sync_filesystem+0x7c/0xc0
[    5.689025]  [<cf624bb2>] sync_filesystem+0x72/0xc0
[    5.689025]  [<cf78387d>] logfs_kill_sb+0x3d/0x220
[    5.689025]  [<cf5d970e>] deactivate_locked_super+0x8e/0x100
[    5.689025]  [<cf7852cf>] logfs_mount+0xc0f/0xce0
[    5.689025]  [<cf5dc113>] mount_fs+0xd3/0x2e0
[    5.689025]  [<cf58d11b>] ? kstrdup+0x5b/0xa0
[    5.689025]  [<cf60e4d1>] vfs_kern_mount+0x91/0x200
[    5.689025]  [<d17a1f6d>] ? _raw_read_unlock+0x6d/0xc0
[    5.689025]  [<cf6129c3>] do_mount+0x1383/0x1700
[    5.689025]  [<cf58d7ba>] ? strndup_user+0x5a/0xa0
[    5.689025]  [<cf613345>] SyS_mount+0x105/0x1a0
[    5.689025]  [<d17a368d>] syscall_call+0x7/0xb
[    5.689025] Code: e4 e8 fb 43 d4 fd 83 05 e8 f4 a2 d2 01 8d 43 2c 83 15 =
ec f4 a2 d2 00 8d 55 e4 89 c1 89 45 d8 8b 43 30 89 4d e4 89 53 30 89 45 e8 =
<89> 10 8b 55 e0 8b 45 dc 89 7d ec e8 e6 72 d4 fd eb 12 8d 74 26
[    5.689025] EIP: [<d179b2ea>] mutex_lock_nested+0x2ca/0x6c0 SS:ESP 0068:=
ccda7df4
[    5.689025] CR2: 0000000000000000
[    5.689025] ---[ end trace 29ca2846d34a3d8f ]---
[    5.689025] BUG: sleeping function called from invalid context at kernel=
/locking/rwsem.c:20
[    5.689025] in_atomic(): 1, irqs_disabled(): 1, pid: 381, name: mount
[    5.689025] INFO: lockdep is turned off.
[    5.689025] Preemption disabled at:[<cf77be6d>] logfs_get_wblocks+0x12d/=
0x160
[    5.689025]=20
[    5.689025] CPU: 0 PID: 381 Comm: mount Tainted: G      D       3.14.0-r=
c6-next-20140313-08623-gaf911c6 #2
[    5.689025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.689025]  0000017d ccda7be0 d176dee0 ccda7c0c cf4d1c11 d2159e2d cf77b=
e6d cf77be6d
[    5.689025]  0000017d ccd54600 00000000 ccd2e364 ccd2e398 ccd54390 ccda7=
c2c d179f66f
[    5.689025]  00000000 00000000 d24a08c4 ccd54390 ccd54390 00000009 ccda7=
c40 cf4a4227
[    5.689025] Call Trace:
[    5.689025]  [<d176dee0>] dump_stack+0x40/0x5e
[    5.689025]  [<cf4d1c11>] __might_sleep+0x271/0x2a0
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<d179f66f>] down_read+0x2f/0x140
[    5.689025]  [<cf4a4227>] exit_signals+0x27/0x240
[    5.689025]  [<cf48db6e>] do_exit+0x1ae/0x1160
[    5.689025]  [<cf4f4e60>] ? kmsg_dump+0x180/0x1e0
[    5.689025]  [<cf4f4e95>] ? kmsg_dump+0x1b5/0x1e0
[    5.689025]  [<cf4f4d26>] ? kmsg_dump+0x46/0x1e0
[    5.689025]  [<cf416fe5>] oops_end+0x165/0x180
[    5.689025]  [<d17652e9>] no_context+0x3ce/0x3e4
[    5.689025]  [<d176580f>] __bad_area_nosemaphore+0x226/0x23c
[    5.689025]  [<cf468860>] ? kvm_read_and_reset_pf_reason+0x60/0x60
[    5.689025]  [<d176590a>] bad_area_nosemaphore+0x20/0x30
[    5.689025]  [<cf46c607>] __do_page_fault+0x247/0x9e0
[    5.689025]  [<cf49d9f1>] ? update_process_times+0xd1/0x100
[    5.689025]  [<cf516414>] ? tick_handle_periodic+0x34/0x100
[    5.689025]  [<cf516414>] ? tick_handle_periodic+0x34/0x100
[    5.689025]  [<cf491ca1>] ? irq_exit+0x141/0x160
[    5.689025]  [<cf45a26c>] ? smp_apic_timer_interrupt+0x6c/0xa0
[    5.689025]  [<d17a38cd>] ? apic_timer_interrupt+0x2d/0x40
[    5.689025]  [<cf468860>] ? kvm_read_and_reset_pf_reason+0x60/0x60
[    5.689025]  [<cf46d0f6>] do_page_fault+0x36/0x60
[    5.689025]  [<cf4688ab>] do_async_page_fault+0x4b/0x100
[    5.689025]  [<d17a3b48>] error_code+0x58/0x60
[    5.689025]  [<cf77007b>] ? jffs2_sum_scan_sumnode+0x45b/0x820
[    5.689025]  [<cf468860>] ? kvm_read_and_reset_pf_reason+0x60/0x60
[    5.689025]  [<d179b2ea>] ? mutex_lock_nested+0x2ca/0x6c0
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] ? logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf77be6d>] logfs_get_wblocks+0x12d/0x160
[    5.689025]  [<cf776243>] logfs_sync_fs+0x23/0x80
[    5.689025]  [<cf62487c>] __sync_filesystem+0x7c/0xc0
[    5.689025]  [<cf624bb2>] sync_filesystem+0x72/0xc0
[    5.689025]  [<cf78387d>] logfs_kill_sb+0x3d/0x220
[    5.689025]  [<cf5d970e>] deactivate_locked_super+0x8e/0x100
[    5.689025]  [<cf7852cf>] logfs_mount+0xc0f/0xce0
[    5.689025]  [<cf5dc113>] mount_fs+0xd3/0x2e0
[    5.689025]  [<cf58d11b>] ? kstrdup+0x5b/0xa0
[    5.689025]  [<cf60e4d1>] vfs_kern_mount+0x91/0x200
[    5.689025]  [<d17a1f6d>] ? _raw_read_unlock+0x6d/0xc0
[    5.689025]  [<cf6129c3>] do_mount+0x1383/0x1700
[    5.689025]  [<cf58d7ba>] ? strndup_user+0x5a/0xa0
[    5.689025]  [<cf613345>] SyS_mount+0x105/0x1a0
[    5.689025]  [<d17a368d>] syscall_call+0x7/0xb
[    5.689025] note: mount[381] exited with preempt_count 1
[    5.905516] (stc): gdata/new_proto/recv or reg_complete_cb not ready
[    5.906836] fmdrv: Failed to get ST write func pointer
[    5.908874] (stc):  chnl_id 8 not supported
[    5.909594] fmdrv: st_unregister failed -93
[    5.910722] fmdrv: Unable to prepare FM CORE

Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-s=
t0-03150024/af911c69655709defa3daa926d72d5447688754c/vmlinuz-3.14.0-rc6-nex=
t-20140313-08623-gaf911c6 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeo=
ut=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0=
 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-st0-03150024/next:ma=
ster/.vmlinuz-af911c69655709defa3daa926d72d5447688754c-20140315004838-4-ivy=
town2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-st0-0315002=
4/af911c69655709defa3daa926d72d5447688754c/vmlinuz-3.14.0-rc6-next-20140313=
-08623-gaf911c6'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 32=
0 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::=
21259-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocalt=
ime -pidfile /dev/shm/kboot/pid-yocto-ivytown2-22 -serial file:/dev/shm/kbo=
ot/serial-yocto-ivytown2-22 -daemonize -display none -monitor null=20

--uAKRQypu60I7Lcqm
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-st0-03150024-af911c69655709defa3daa926d72d5447688754c-Oops:----PREEMPT-79113.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDQ3NTA3NmI0Njk5NTMxYmU1NzBmYTliMmI2YTVjYTBiNzcwZDBmYjcK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQvbmV4dDptYXN0ZXI6NDc1MDc2YjQ2OTk1MzFiZTU3MGZhOWIyYjZhNWNhMGI3
NzBkMGZiNzpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE1LTEyOjU2OjExIDQ3NTA3NmI0Njk5
NTMxYmU1NzBmYTliMmI2YTVjYTBiNzcwZDBmYjcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC00NzUwNzZiNDY5OTUzMWJlNTcwZmE5YjJiNmE1Y2EwYjc3MGQwZmI3CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzQ3
NTA3NmI0Njk5NTMxYmU1NzBmYTliMmI2YTVjYTBiNzcwZDBmYjcKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQtNDc1MDc2YjQ2OTk1MzFiZTU3MGZhOWIyYjZhNWNhMGI3NzBkMGZiNwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtNDc1MDc2YjQ2OTk1MzFiZTU3MGZhOWIyYjZh
NWNhMGI3NzBkMGZiNwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC80NzUwNzZiNDY5OTUzMWJlNTcwZmE5YjJiNmE1Y2EwYjc3MGQwZmI3L3ZtbGludXot
My4xNC4wLXJjNi0wNzg2My1nNDc1MDc2YgoKMjAxNC0wMy0xNS0xNDo1MDoxMSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDUuMjg5NDc4XSBGcmVlaW5nIHVu
dXNlZCBrZXJuZWwgbWVtb3J5OiAxMjQ0SyAoY2EwOTAwMDAgLSBjYTFjNzAwMCkKWyAgICA2
LjE2NTEwN10gTG9nRlM6IFN0YXJ0IG1vdW50IDAKWyAgICA2LjE3NzU4Ml0gTG9nRlM6IFN0
YXJ0IHVubW91bnRpbmcKWyAgICA2LjE4NjIzNV0gSU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVy
IG5vbi1zdGF0aWMga2V5LgpbICAgIDYuMTg2OTQ3XSB0aGUgY29kZSBpcyBmaW5lIGJ1dCBu
ZWVkcyBsb2NrZGVwIGFubm90YXRpb24uClsgICAgNi4xODY5NDddIHR1cm5pbmcgb2ZmIHRo
ZSBsb2NraW5nIGNvcnJlY3RuZXNzIHZhbGlkYXRvci4KWyAgICA2LjE4Njk0N10gQ1BVOiAw
IFBJRDogMzk1IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTQuMC1yYzYtMDc4NjMtZzQ3
NTA3NmIgIzEKWyAgICA2LjE4Njk0N10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuMTg2OTQ3XSAgY2RkODJjNDQgY2Q1MTdkN2Mg
YzhmNjkxMWUgY2Q1MTdkYzAgYzZjZTQ4Y2QgYzk4NmJmOGMgYzhmOTYwNDAgY2Q1MTdlMzQK
WyAgICA2LjE4Njk0N10gIGM2ZTFjZDg1IDAwMDAwMDAyIDAwMDA0MTc4IDAwMDA0MTc4IGNh
MzUzOWQ4IDAwMDAwMDAwIDAwMDAwMDAwIGNkZDgyYzQ0ClsgICAgNi4xODY5NDddICBjZDRl
YzQxMCBjZDRlYzQxMCBjZGQ4MmM0NCAwMDAwMDAwMCBjZDUxN2RlYyBjNmNlNjA0YyAwMDAw
MDAwMCAwMDAwMDAwMApbICAgIDYuMTg2OTQ3XSBDYWxsIFRyYWNlOgpbICAgIDYuMTg2OTQ3
XSAgWzxjOGY2OTExZT5dIGR1bXBfc3RhY2srMHg0MC8weDVlClsgICAgNi4xODY5NDddICBb
PGM2Y2U0OGNkPl0gX19sb2NrX2FjcXVpcmUuaXNyYS4yMSsweDNjZC8weDFhYTAKWyAgICA2
LjE4Njk0N10gIFs8YzhmOTYwNDA+XSA/IHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyMC8weDQw
ClsgICAgNi4xODY5NDddICBbPGM2ZTFjZDg1Pl0gPyB3cml0ZWJhY2tfaW5vZGVzX3NiX25y
KzB4MTA1LzB4MTQwClsgICAgNi4xODY5NDddICBbPGM2Y2U2MDRjPl0gbG9ja19hY3F1aXJl
KzB4YWMvMHgxMDAKWyAgICA2LjE4Njk0N10gIFs8YzZmN2ExYWQ+XSA/IGxvZ2ZzX2dldF93
YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgNi4xODY5NDddICBbPGM4Zjk2MzBmPl0gbXV0ZXhf
bG9ja19uZXN0ZWQrMHhhZi8weDZjMApbICAgIDYuMTg2OTQ3XSAgWzxjNmY3YTFhZD5dID8g
bG9nZnNfZ2V0X3dibG9ja3MrMHgxMmQvMHgxNjAKWyAgICA2LjE4Njk0N10gIFs8YzZmN2Ex
YWQ+XSA/IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgNi4xODY5NDddICBb
PGM2ZjdhMWFkPl0gbG9nZnNfZ2V0X3dibG9ja3MrMHgxMmQvMHgxNjAKWyAgICA2LjE4Njk0
N10gIFs8YzZmNzQ1ODM+XSBsb2dmc19zeW5jX2ZzKzB4MjMvMHg4MApbICAgIDYuMTg2OTQ3
XSAgWzxjNmUyMmRmYz5dIF9fc3luY19maWxlc3lzdGVtKzB4N2MvMHhjMApbICAgIDYuMTg2
OTQ3XSAgWzxjNmUyMzEzMj5dIHN5bmNfZmlsZXN5c3RlbSsweDcyLzB4YzAKWyAgICA2LjE4
Njk0N10gIFs8YzZmODFiZGQ+XSBsb2dmc19raWxsX3NiKzB4M2QvMHgyMjAKWyAgICA2LjE4
Njk0N10gIFs8YzZkZDdjZWU+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDhlLzB4MTAw
ClsgICAgNi4xODY5NDddICBbPGM2ZjgzNjJmPl0gbG9nZnNfbW91bnQrMHhjMGYvMHhjZTAK
WyAgICA2LjE4Njk0N10gIFs8YzZkZGE2ZjM+XSBtb3VudF9mcysweGQzLzB4MmUwClsgICAg
Ni4xODY5NDddICBbPGM2ZDhjNjdiPl0gPyBrc3RyZHVwKzB4NWIvMHhhMApbICAgIDYuMTg2
OTQ3XSAgWzxjNmUwY2E3MT5dIHZmc19rZXJuX21vdW50KzB4OTEvMHgyMDAKWyAgICA2LjE4
Njk0N10gIFs8YzhmOWQxYWQ+XSA/IF9yYXdfcmVhZF91bmxvY2srMHg2ZC8weGMwClsgICAg
Ni4xODY5NDddICBbPGM2ZTEwZjYzPl0gZG9fbW91bnQrMHgxMzgzLzB4MTcwMApbICAgIDYu
MTg2OTQ3XSAgWzxjNmQ4Y2JiYT5dID8gc3RybmR1cF91c2VyKzB4NWEvMHhhMApbICAgIDYu
MTg2OTQ3XSAgWzxjNmUxMThlNT5dIFN5U19tb3VudCsweDEwNS8weDFhMApbICAgIDYuMTg2
OTQ3XSAgWzxjOGY5ZThjZD5dIHN5c2NhbGxfY2FsbCsweDcvMHhiCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzE1MDAyNC80NzUwNzZiNDY5OTUzMWJlNTcwZmE5YjJiNmE1Y2Ew
Yjc3MGQwZmI3L2RtZXNnLXlvY3RvLWNhaXJvLTQ2OjIwMTQwMzE1MTQ1MDI3OmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4xNC4wLXJjNi0wNzg2My1nNDc1MDc2YjoxCjA6MTox
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgNDc1MDc2
YjQ2OTk1MzFiZTU3MGZhOWIyYjZhNWNhMGI3NzBkMGZiNwpnaXQgY2hlY2tvdXQgdjMuMTMK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQvbmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEw
ZjBlNjRiZTpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE1LTE0OjUwOjQ1IGQ4ZWMyNmQ3Zjgy
ODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2Q4
ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL3ZtbGludXot
My4xMy4wCgoyMDE0LTAzLTE1LTE1OjQxOjQ1IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
MSBURVNUIEZBSUxVUkUKWyAgICA3LjAwMDQxNF0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1l
bW9yeTogMTIyMEsgKGMzNTAwMDAwIC0gYzM2MzEwMDApClsgICAgOC4zOTQyMDZdIExvZ0ZT
OiBTdGFydCBtb3VudCAwClsgICAgOC40MTQxNjBdIExvZ0ZTOiBTdGFydCB1bm1vdW50aW5n
ClsgICAgOC40MzYwNDldIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtl
eS4KWyAgICA4LjQzNjk2M10gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBh
bm5vdGF0aW9uLgpbICAgIDguNDM2OTYzXSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3Jy
ZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgOC40MzY5NjNdIENQVTogMCBQSUQ6IDM4NSBDb21t
OiBtb3VudCBOb3QgdGFpbnRlZCAzLjEzLjAgIzEKWyAgICA4LjQzNjk2M10gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDguNDM2OTYz
XSAgY2NhYjRjNDQgY2NhZjVkNzggYzI0MjdlYjUgY2NhZjVkYmMgYzAyZGI4NmMgYzJjZjEw
MzAgYzI0NTQ3YTAgY2NhZjVlMzAKWyAgICA4LjQzNjk2M10gIGMwNDEzNTY1IDAwMDAwMDAy
IDAwMDAwMDAwIGMzN2I5NGEwIDAwMDEwYjBjIDAwMDAwMDAwIDAwMDAwMDAwIGNjYWI0YzQ0
ClsgICAgOC40MzY5NjNdICBjY2FlMTI1MCBjY2FlMTI1MCBjY2FiNGM0NCAwMDAwMDAwMCBj
Y2FmNWRlOCBjMDJkY2ZjYyAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDguNDM2OTYzXSBDYWxs
IFRyYWNlOgpbICAgIDguNDM2OTYzXSAgWzxjMjQyN2ViNT5dIGR1bXBfc3RhY2srMHg0MC8w
eDVlClsgICAgOC40MzY5NjNdICBbPGMwMmRiODZjPl0gX19sb2NrX2FjcXVpcmUuaXNyYS4y
MSsweDNhYy8weDFhNjAKWyAgICA4LjQzNjk2M10gIFs8YzI0NTQ3YTA+XSA/IHdhaXRfZm9y
X2NvbXBsZXRpb24rMHgyMC8weDQwClsgICAgOC40MzY5NjNdICBbPGMwNDEzNTY1Pl0gPyB3
cml0ZWJhY2tfaW5vZGVzX3NiX25yKzB4MTA1LzB4MTQwClsgICAgOC40MzY5NjNdICBbPGMw
MmRjZmNjPl0gbG9ja19hY3F1aXJlKzB4YWMvMHgxMDAKWyAgICA4LjQzNjk2M10gIFs8YzA1
NzBlY2Q+XSA/IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgOC40MzY5NjNd
ICBbPGMyNDU0YTZmPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHhhZi8weDZjMApbICAgIDguNDM2
OTYzXSAgWzxjMDU3MGVjZD5dID8gbG9nZnNfZ2V0X3dibG9ja3MrMHgxMmQvMHgxNjAKWyAg
ICA4LjQzNjk2M10gIFs8YzA1NzBlY2Q+XSA/IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4
MTYwClsgICAgOC40MzY5NjNdICBbPGMwNTcwZWNkPl0gbG9nZnNfZ2V0X3dibG9ja3MrMHgx
MmQvMHgxNjAKWyAgICA4LjQzNjk2M10gIFs8YzA1NmIyYTM+XSBsb2dmc19zeW5jX2ZzKzB4
MjMvMHg4MApbICAgIDguNDM2OTYzXSAgWzxjMDQxOTRkYz5dIF9fc3luY19maWxlc3lzdGVt
KzB4N2MvMHhjMApbICAgIDguNDM2OTYzXSAgWzxjMDQxOTgxYz5dIHN5bmNfZmlsZXN5c3Rl
bSsweDdjLzB4YzAKWyAgICA4LjQzNjk2M10gIFs8YzA1Nzg4YmQ+XSBsb2dmc19raWxsX3Ni
KzB4M2QvMHgyMjAKWyAgICA4LjQzNjk2M10gIFs8YzAzY2RjZGM+XSBkZWFjdGl2YXRlX2xv
Y2tlZF9zdXBlcisweDVjLzB4ZTAKWyAgICA4LjQzNjk2M10gIFs8YzA1N2EzMGY+XSBsb2dm
c19tb3VudCsweGMwZi8weGNlMApbICAgIDguNDM2OTYzXSAgWzxjMDNkMDZmMz5dIG1vdW50
X2ZzKzB4ZDMvMHgyZTAKWyAgICA4LjQzNjk2M10gIFs8YzAzODMxM2I+XSA/IGtzdHJkdXAr
MHg1Yi8weGEwClsgICAgOC40MzY5NjNdICBbPGMwNDAzMWIxPl0gdmZzX2tlcm5fbW91bnQr
MHg5MS8weDIwMApbICAgIDguNDM2OTYzXSAgWzxjMjQ1Yjk0ZD5dID8gX3Jhd19yZWFkX3Vu
bG9jaysweDZkLzB4YzAKWyAgICA4LjQzNjk2M10gIFs8YzA0MDc2ZTM+XSBkb19tb3VudCsw
eDEzODMvMHgxNzAwClsgICAgOC40MzY5NjNdICBbPGMwMzgzNjdhPl0gPyBzdHJuZHVwX3Vz
ZXIrMHg1YS8weGEwClsgICAgOC40MzY5NjNdICBbPGMwNDA4MDY1Pl0gU3lTX21vdW50KzB4
MTA1LzB4MWEwClsgICAgOC40MzY5NjNdICBbPGMyNDVkMGE4Pl0gc3lzY2FsbF9jYWxsKzB4
Ny8weGIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2Q4ZWMyNmQ3Zjgy
ODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8taW5uLTE2OjIwMTQw
MzE1MTYxMDU5OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6OgoxOjE6MSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0xNSAxNjoxMToxNyBSRVBFQVQg
Q09VTlQ6IDMwICAjIC9rZXJuZWwtdGVzdHMvbGludXg4L29iai1iaXNlY3QvLnJlcGVhdBtb
MG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMwpnaXQgY2hlY2tvdXQgdjMuMTIKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQvbmV4dDptYXN0ZXI6NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1
MjpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE1LTE2OjExOjIwIDVlMDFkYzdiMjZkOWYyNGYz
OWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC01ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzVlMDFkYzdi
MjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQtNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMxNTAwMjQtNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2
YTVjZWI1MgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC81
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL3ZtbGludXotMy4xMi4w
CgoyMDE0LTAzLTE1LTE4OjU5OjIwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4u
Li4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICA1LjM1NzE2N10gRnJlZWluZyB1bnVzZWQg
a2VybmVsIG1lbW9yeTogMTE4MEsgKGMzNDgzMDAwIC0gYzM1YWEwMDApClsgICAgNi43NDUz
NDNdIExvZ0ZTOiBTdGFydCBtb3VudCAwClsgICAgNi43ODUyOTJdIExvZ0ZTOiBTdGFydCB1
bm1vdW50aW5nClsgICAgNi44MDEzMzVdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24t
c3RhdGljIGtleS4KWyAgICA2LjgwMjAyOF0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMg
bG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDYuODAyMDI4XSB0dXJuaW5nIG9mZiB0aGUgbG9j
a2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgNi44MDIwMjhdIENQVTogMCBQSUQ6
IDM5MiBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjEyLjAgIzEKWyAgICA2LjgwMjAyOF0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDYuODAyMDI4XSAgY2QxMThjNDQgY2QzNDVkOGMgYzIzY2VkYWYgY2QzNDVkZDAgYzAzMDBk
NmMgYzJjODA0ZTQgY2QzNDVkYTAgYzIzZjk1ODAKWyAgICA2LjgwMjAyOF0gIGNkMzQ1ZTQ4
IGMwNDBiMTg1IDAwMDAwMDAyIGMzNzcyYmQwIDAwMDAxYzcwIGNkMTgwYzAwIDAwMDAwMDAw
IGNkMTE4YzQ0ClsgICAgNi44MDIwMjhdICBjZDM2YWJlMCBjZDM2YWJlMCBjZDExOGM0NCAw
MDAwMDAwMCBjZDM0NWRmYyBjMDMwMjRjYyAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDYuODAy
MDI4XSBDYWxsIFRyYWNlOgpbICAgIDYuODAyMDI4XSAgWzxjMjNjZWRhZj5dIGR1bXBfc3Rh
Y2srMHg0MC8weDVlClsgICAgNi44MDIwMjhdICBbPGMwMzAwZDZjPl0gX19sb2NrX2FjcXVp
cmUuaXNyYS4yMSsweDNhYy8weDFhNjAKWyAgICA2LjgwMjAyOF0gIFs8YzIzZjk1ODA+XSA/
IHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyMC8weDQwClsgICAgNi44MDIwMjhdICBbPGMwNDBi
MTg1Pl0gPyB3cml0ZWJhY2tfaW5vZGVzX3NiX25yKzB4MTA1LzB4MTQwClsgICAgNi44MDIw
MjhdICBbPGMwMzAyNGNjPl0gbG9ja19hY3F1aXJlKzB4YWMvMHgxMDAKWyAgICA2LjgwMjAy
OF0gIFs8YzA1NjZjZWQ+XSA/IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4MTYwClsgICAg
Ni44MDIwMjhdICBbPGMwNTY2Y2VkPl0gPyBsb2dmc19nZXRfd2Jsb2NrcysweDEyZC8weDE2
MApbICAgIDYuODAyMDI4XSAgWzxjMjNmMmYwZT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4YWUv
MHg3MDAKWyAgICA2LjgwMjAyOF0gIFs8YzA1NjZjZWQ+XSA/IGxvZ2ZzX2dldF93YmxvY2tz
KzB4MTJkLzB4MTYwClsgICAgNi44MDIwMjhdICBbPGMwNTY2Y2VkPl0gPyBsb2dmc19nZXRf
d2Jsb2NrcysweDEyZC8weDE2MApbICAgIDYuODAyMDI4XSAgWzxjMDU2NmNlZD5dIGxvZ2Zz
X2dldF93YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgNi44MDIwMjhdICBbPGMwNTYxMDYzPl0g
bG9nZnNfc3luY19mcysweDIzLzB4ODAKWyAgICA2LjgwMjAyOF0gIFs8YzA0MTEwMWM+XSBf
X3N5bmNfZmlsZXN5c3RlbSsweDdjLzB4YzAKWyAgICA2LjgwMjAyOF0gIFs8YzA0MTEyNTI+
XSBzeW5jX2ZpbGVzeXN0ZW0rMHg3Mi8weGMwClsgICAgNi44MDIwMjhdICBbPGMwNTZlNzVk
Pl0gbG9nZnNfa2lsbF9zYisweDNkLzB4MjIwClsgICAgNi44MDIwMjhdICBbPGMwM2M4ZGNi
Pl0gZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHg0Yi8weGUwClsgICAgNi44MDIwMjhdICBb
PGMwNTcwMWFmPl0gbG9nZnNfbW91bnQrMHhjMGYvMHhjZTAKWyAgICA2LjgwMjAyOF0gIFs8
YzAzY2I5ZDM+XSBtb3VudF9mcysweGQzLzB4MmUwClsgICAgNi44MDIwMjhdICBbPGMwMzdl
N2RiPl0gPyBrc3RyZHVwKzB4NWIvMHhhMApbICAgIDYuODAyMDI4XSAgWzxjMDNmYmU5MT5d
IHZmc19rZXJuX21vdW50KzB4OTEvMHgxNjAKWyAgICA2LjgwMjAyOF0gIFs8YzAzZmY2MGI+
XSBkb19tb3VudCsweDEwYWIvMHgxNDIwClsgICAgNi44MDIwMjhdICBbPGMwMzdlY2ZhPl0g
PyBzdHJuZHVwX3VzZXIrMHg1YS8weGEwClsgICAgNi44MDIwMjhdICBbPGMwM2ZmYTg1Pl0g
U3lTX21vdW50KzB4MTA1LzB4MWEwClsgICAgNi44MDIwMjhdICBbPGMyM2ZkNjg4Pl0gc3lz
Y2FsbF9jYWxsKzB4Ny8weGIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8t
Y2Fpcm8tMzQ6MjAxNDAzMTUxOTA5MzY6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNDoz
LjEyLjA6MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjEyCmdpdCBjaGVja291dCB2My4xMQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9uZXh0Om1hc3Rlcjo2
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlOmJpc2VjdC1saW51eDgK
CjIwMTQtMDMtMTUtMTk6MDk6NTUgNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0
YzE5MjEzZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMw
OTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC02ZTQ2NjQ1MjVi
MWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC02ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzZlNDY2NDUyNWIxZGIyOGY4
YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uvdm1saW51ei0zLjExLjAKCjIwMTQtMDMtMTUtMTk6
NTI6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk1IFRFU1QgRkFJTFVSRQpbICAgIDUuMjEw
MTkzXSBmbWMgZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJ
RDogbWF0Y2hlcyBhbGwKWyAgICA1LjIxMTg5OV0gZm1jX3dyaXRlX2VlcHJvbSBmYWtlLWRl
c2lnbi1mb3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBubyBidXNpZCBwYXNz
ZWQsIHJlZnVzaW5nIGFsbCBjYXJkcwpbICAgIDUuMjE0NDI3XSBmbWMgZmFrZS1kZXNpZ24t
Zm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hlcyBhbGwKWyAgICA1
LjIxNjE4Ml0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8xLzB4MDAw
MDAwMDIKWyAgICA1LjIxNzU5Ml0gNCBsb2NrcyBoZWxkIGJ5IHN3YXBwZXIvMToKWyAgICA1
LjIxODY1M10gICMwOiAgKCZfX2xvY2tkZXBfbm9fdmFsaWRhdGVfXyl7Li4uLi4ufSwgYXQ6
IFs8YzBjZGQ4ZGY+XSBfX2RyaXZlcl9hdHRhY2grMHg3Zi8weDE0MApbICAgIDUuMjIxNzk2
XSAgIzE6ICAoJl9fbG9ja2RlcF9ub192YWxpZGF0ZV9fKXsuLi4uLi59LCBhdDogWzxjMGNk
ZDhmYz5dIF9fZHJpdmVyX2F0dGFjaCsweDljLzB4MTQwClsgICAgNS4yMjQ3NTVdICAjMjog
IChmY19sb2NrKXsuLi4uLi59LCBhdDogWzxjMWY1NWJhZD5dIGZjX3Byb2JlKzB4ZWQvMHgx
ZTAKWyAgICA1LjIyNzAwMl0gICMzOiAgKG1pc2NfbXR4KXsuLi4uLi59LCBhdDogWzxjMGM5
MDBkNz5dIG1pc2NfcmVnaXN0ZXIrMHgzNy8weDJhMApbICAgIDUuMjI5NzMwXSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMS4wICMxClsgICAgNS4yMzEx
NTRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICA1LjIzMjY0NF0gIGNlMDQ3ZDFjIGNlMDQ3YmI4IGMyMjI1NDlmIGNlMDQ3YmQ0IGMy
MjFkNjk1IGMyYTc4Y2JjIGNlMDQ0ZGE4IDAwMDAwMDAxClsgICAgNS4yMzU4MjhdICAwMDAw
MDAwMiAwMDAwMDAwMCBjZTA0N2M0OCBjMjI0YzY3YiBjZTA0N2MwMCBiZTdhZDQzNCAwMDAw
ODJjOCBjZTA0NGJlMApbICAgIDUuMjM4ODcwXSAgY2UwNDdkMmMgY2UwNDYwMDAgY2UwNDRi
ZTAgYzAyNTNjMGMgNWMxYzAxMTUgMDAwMDgyY2UgY2UwNDdjMGMgYzAyMWI5NTYKWyAgICA1
LjI0MjE5M10gQ2FsbCBUcmFjZToKWyAgICA1LjI0MzA1NV0gIFs8YzIyMjU0OWY+XSBkdW1w
X3N0YWNrKzB4NDAvMHg1ZQpbICAgIDUuMjQ0MTk0XSAgWzxjMjIxZDY5NT5dIF9fc2NoZWR1
bGVfYnVnKzB4OWQvMHhjYgpbICAgIDUuMjQ1NDM4XSAgWzxjMjI0YzY3Yj5dIF9fc2NoZWR1
bGUrMHhiYi8weDk2MApbICAgIDUuMjQ2NjQ0XSAgWzxjMDI1M2MwYz5dID8ga3ZtX2Nsb2Nr
X3JlYWQrMHhhYy8weGUwClsgICAgNS4yNDc5ODldICBbPGMwMjFiOTU2Pl0gPyBzY2hlZF9j
bG9jaysweDE2LzB4NDAKWyAgICA1LjI0OTMwNV0gIFs8YzAyYmYyYmQ+XSA/IHNjaGVkX2Ns
b2NrX2xvY2FsLmNvbnN0cHJvcC4yKzB4MWQvMHgxYzAKWyAgICA1LjI1MDg5Ml0gIFs8YzAy
YmY2YjM+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDFkMy8weDIyMApbICAgIDUuMjUyMjM4XSAg
WzxjMjI0Y2ZiNT5dIHNjaGVkdWxlKzB4OTUvMHhlMApbICAgIDUuMjUzMzkzXSAgWzxjMjI0
NmNlMz5dIHNjaGVkdWxlX3RpbWVvdXQrMHgyMy8weDJhMApbICAgIDUuMjU0NjgzXSAgWzxj
MjI0ZDllNT5dID8gd2FpdF9mb3JfY29tbW9uKzB4MWM1LzB4MjQwClsgICAgNS4yNTk5NjVd
ICBbPGMyMjRkOWZhPl0gd2FpdF9mb3JfY29tbW9uKzB4MWRhLzB4MjQwClsgICAgNS4yNjEy
NDhdICBbPGMwMmI5OTAwPl0gPyB0cnlfdG9fd2FrZV91cCsweDJlMC8weDJlMApbICAgIDUu
MjYyNTUxXSAgWzxjMjI0ZGMwMD5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyMC8weDQwClsg
ICAgNS4yNjk4MzddICBbPGMwY2U1NmMwPl0gZGV2dG1wZnNfY3JlYXRlX25vZGUrMHgxNjAv
MHgxYzAKWyAgICA1LjI3MTIxOF0gIFs8YzIyNGQ4NmE+XSA/IHdhaXRfZm9yX2NvbW1vbisw
eDRhLzB4MjQwClsgICAgNS4yNzI1MTldICBbPGMwY2Q2NmJhPl0gZGV2aWNlX2FkZCsweDNi
YS8weGVjMApbICAgIDUuMjczNzM5XSAgWzxjMGNkNzJjYT5dIGRldmljZV9jcmVhdGVfZ3Jv
dXBzX3ZhcmdzKzB4MTBhLzB4MTgwClsgICAgNS4yNzUxNzhdICBbPGMwY2Q4NjdlPl0gZGV2
aWNlX2NyZWF0ZSsweDNlLzB4NjAKWyAgICA1LjI3OTQ0OF0gIFs8YzBjOTAyN2M+XSBtaXNj
X3JlZ2lzdGVyKzB4MWRjLzB4MmEwClsgICAgNS4yODA4NDRdICBbPGMxZjU1YmMzPl0gZmNf
cHJvYmUrMHgxMDMvMHgxZTAKWyAgICA1LjI5MDAxOF0gIFs8YzA0NjU5NTI+XSA/IHN5c2Zz
X2NyZWF0ZV9saW5rKzB4NTIvMHg4MApbICAgIDUuMjkxMzU3XSAgWzxjMWY1MWZiZD5dIGZt
Y19wcm9iZSsweDFkLzB4NDAKWyAgICA1LjI5MjU1Ml0gIFs8YzBjZGQ1ZGY+XSByZWFsbHlf
cHJvYmUrMHgxM2YvMHgzYzAKWyAgICA1LjI5MzgwN10gIFs8YzBjZGQ5M2Y+XSBfX2RyaXZl
cl9hdHRhY2grMHhkZi8weDE0MApbICAgIDUuMjk1MDk5XSAgWzxjMGNkZDg2MD5dID8gcmVh
bGx5X3Byb2JlKzB4M2MwLzB4M2MwClsgICAgNS4yOTY0MDVdICBbPGMwY2RhMGFhPl0gYnVz
X2Zvcl9lYWNoX2RldisweGFhLzB4MTQwClsgICAgNS4yOTk2MjZdICBbPGMwY2RkMDQ4Pl0g
ZHJpdmVyX2F0dGFjaCsweDI4LzB4NDAKWyAgICA1LjMwMDg1N10gIFs8YzBjZGQ4NjA+XSA/
IHJlYWxseV9wcm9iZSsweDNjMC8weDNjMApbICAgIDUuMzEwMTE0XSAgWzxjMGNkYjFlNz5d
IGJ1c19hZGRfZHJpdmVyKzB4MTI3LzB4NGUwClsgICAgNS4zMTE0OTZdICBbPGMxZjUxZmUw
Pl0gPyBmbWNfcHJvYmUrMHg0MC8weDQwClsgICAgNS4zMTI3NzRdICBbPGMxZjUxZmUwPl0g
PyBmbWNfcHJvYmUrMHg0MC8weDQwClsgICAgNS4zMTM5OTVdICBbPGMwY2RlNmRkPl0gZHJp
dmVyX3JlZ2lzdGVyKzB4MTVkLzB4MmMwClsgICAgNS4zMTUyNjRdICBbPGMxZjU0YmViPl0g
PyBmZl9pbml0KzB4YWIvMHgyNjAKWyAgICA1LjMxOTM3Nl0gIFs8YzBjZGJhY2M+XSA/IGJ1
c19yZWdpc3RlcisweDI2Yy8weDRjMApbICAgIDUuMzIwNjcyXSAgWzxjMWY1NWNhMD5dID8g
ZmNfcHJvYmUrMHgxZTAvMHgxZTAKWyAgICA1LjMyMTg3MF0gIFs8YzFmNTIzMmQ+XSBmbWNf
ZHJpdmVyX3JlZ2lzdGVyKzB4NGQvMHg4MApbICAgIDUuMzMwMTQ3XSAgWzxjMWY1NWNiYj5d
IGZjX2luaXQrMHgxYi8weDQwClsgICAgNS4zMzEzODJdICBbPGMzMjM4NWNiPl0gZG9fb25l
X2luaXRjYWxsKzB4ZjIvMHgyMGIKWyAgICA1LjMzMjY5OV0gIFs8YzAyYTU1YTA+XSA/IHBh
cmFtZXErMHgyMC8weGUwClsgICAgNS4zMzM4NjBdICBbPGMzMjM3NzZjPl0gPyByZXBhaXJf
ZW52X3N0cmluZysweDMyLzB4ZDMKWyAgICA1LjMzNTE1OV0gIFs8YzAyYTVhNjk+XSA/IHBh
cnNlX2FyZ3MrMHg0MDkvMHg1ZTAKWyAgICA1LjMzNjQwOV0gIFs8YzIyNGZjOTQ+XSA/IF9y
YXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweGI0LzB4MTIwClsgICAgNS4zMzc4NTldICBb
PGMwMjk4MTQ2Pl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4NjYv
MHg4MApbICAgIDUuMzM5NDI5XSAgWzxjMzIzODk4Nj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MmEyLzB4NDI1ClsgICAgNS4zNDA5NThdICBbPGMzMjM3NzNhPl0gPyBkb19lYXJseV9w
YXJhbSsweDEyYi8weDEyYgpbICAgIDUuMzQyMzQ4XSAgWzxjMjIxNDNkOT5dIGtlcm5lbF9p
bml0KzB4MTkvMHgyODAKWyAgICA1LjM0MzY5N10gIFs8YzIyNTFmOWI+XSByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbICAgIDUuMzQ1MTQ4XSAgWzxjMjIxNDNjMD5dID8g
cmVzdF9pbml0KzB4MTgwLzB4MTgwClsgICAgNS4zNDY2OTVdIGZtY19jaGFyZGV2IGZha2Ut
ZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IENyZWF0ZWQgbWlzYyBkZXZpY2UgImZha2UtZGVz
aWduLWZvci10ZXN0aW5nLWYwMDEiClsgICAgNS4zNDk3OTVdIEF1ZGlvIEV4Y2VsIERTUCAx
NiBpbml0IGRyaXZlciBDb3B5cmlnaHQgKEMpIFJpY2NhcmRvIEZhY2NoZXR0aSAxOTk1LTk4
ClsgICAgNS4zNTE3NDVdIGFlZHNwMTY6IEkvTywgSVJRIGFuZCBETUEgYXJlIG1hbmRhdG9y
eQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNmU0NjY0NTI1YjFkYjI4
ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by14cHMtNjoyMDE0MDMxNTE5
NTMyMjppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuMTEuMDoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdm
NzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLXhwcy03OjIwMTQwMzE1MTk1MzIxOmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4xMS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uv
ZG1lc2cteW9jdG8tY2Fpcm8tNDoyMDE0MDMxNTE5NTMzNzppMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0OjMuMTEuMDoxCjA6Mzo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTAzLTE1IDE5OjUzOjU2IFJFUEVBVCBDT1VOVDogMzYgICMgL2tlcm5lbC10
ZXN0cy9saW51eDgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0
IHYzLjExCmdpdCBjaGVja291dCB2My4xMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9uZXh0Om1hc3Rlcjo4YmI0OTVl
M2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2OmJpc2VjdC1saW51eDgKCjIwMTQt
MDMtMTUtMTk6NTM6NTkgOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3
NiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LThiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNh
YzlmMDc5ZTM3Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC04YmI0OTVlM2YwMjQwMWVl
NmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC04
YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2Cmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFi
MWQ3N2YzYWM5ZjA3OWUzNzYvdm1saW51ei0zLjEwLjAKCjIwMTQtMDMtMTUtMjA6MTk6NTkg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMy4y
MTE2OTRdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6IDExNDRrIGZyZWVkClsgICAg
NC44MjgzNDhdIExvZ0ZTOiBTdGFydCBtb3VudCAwClsgICAgNC44NTg2NTJdIExvZ0ZTOiBT
dGFydCB1bm1vdW50aW5nClsgICAgNC44NjM5NjBdIElORk86IHRyeWluZyB0byByZWdpc3Rl
ciBub24tc3RhdGljIGtleS4KWyAgICA0Ljg2NDA2Nl0gdGhlIGNvZGUgaXMgZmluZSBidXQg
bmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDQuODY0MDY2XSB0dXJuaW5nIG9mZiB0
aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgNC44NjQwNjZdIENQVTog
MCBQSUQ6IDM4MSBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjEwLjAgIzIKWyAgICA0Ljg2
NDA2Nl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgIDQuODY0MDY2XSAgY2Q2N2ZjNDQgY2QzYTVkOGMgYzIxYzZmMzUgY2QzYTVkZDAg
YzAyZDlhOGMgYzJhMDMxZTQgY2QzYTVkYTAgYzIxZWQ4NjAKWyAgICA0Ljg2NDA2Nl0gIGNk
M2E1ZTQ4IGMwM2U2YWM1IDAwMDAwMDAyIGMzNDdjOGMwIDAwMDAxYzk3IGNkMjJmMDAwIDAw
MDAwMDAwIGNkNjdmYzQ0ClsgICAgNC44NjQwNjZdICBjZDEzZTRiMCBjZDEzZTRiMCBjZDY3
ZmM0NCAwMDAwMDAwMCBjZDNhNWRmYyBjMDJkYjFlYyAwMDAwMDAwMCAwMDAwMDAwMApbICAg
IDQuODY0MDY2XSBDYWxsIFRyYWNlOgpbICAgIDQuODY0MDY2XSAgWzxjMjFjNmYzNT5dIGR1
bXBfc3RhY2srMHgzMi8weDQyClsgICAgNC44NjQwNjZdICBbPGMwMmQ5YThjPl0gX19sb2Nr
X2FjcXVpcmUuaXNyYS4yMSsweDNhYy8weDFhNjAKWyAgICA0Ljg2NDA2Nl0gIFs8YzIxZWQ4
NjA+XSA/IHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyMC8weDQwClsgICAgNC44NjQwNjZdICBb
PGMwM2U2YWM1Pl0gPyB3cml0ZWJhY2tfaW5vZGVzX3NiX25yKzB4MTA1LzB4MTQwClsgICAg
NC44NjQwNjZdICBbPGMwMmRiMWVjPl0gbG9ja19hY3F1aXJlKzB4YWMvMHgxMDAKWyAgICA0
Ljg2NDA2Nl0gIFs8YzA1M2UzNGQ+XSA/IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4MTYw
ClsgICAgNC44NjQwNjZdICBbPGMwNTNlMzRkPl0gPyBsb2dmc19nZXRfd2Jsb2NrcysweDEy
ZC8weDE2MApbICAgIDQuODY0MDY2XSAgWzxjMjFlOTEwZT5dIG11dGV4X2xvY2tfbmVzdGVk
KzB4YWUvMHg3MDAKWyAgICA0Ljg2NDA2Nl0gIFs8YzA1M2UzNGQ+XSA/IGxvZ2ZzX2dldF93
YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgNC44NjQwNjZdICBbPGMwNTNlMzRkPl0gPyBsb2dm
c19nZXRfd2Jsb2NrcysweDEyZC8weDE2MApbICAgIDQuODY0MDY2XSAgWzxjMDUzZTM0ZD5d
IGxvZ2ZzX2dldF93YmxvY2tzKzB4MTJkLzB4MTYwClsgICAgNC44NjQwNjZdICBbPGMwNTM4
NmUzPl0gbG9nZnNfc3luY19mcysweDIzLzB4ODAKWyAgICA0Ljg2NDA2Nl0gIFs8YzAzZWM5
MWM+XSBfX3N5bmNfZmlsZXN5c3RlbSsweDdjLzB4YzAKWyAgICA0Ljg2NDA2Nl0gIFs8YzAz
ZWNiNTI+XSBzeW5jX2ZpbGVzeXN0ZW0rMHg3Mi8weGMwClsgICAgNC44NjQwNjZdICBbPGMw
NTQ1ZGJkPl0gbG9nZnNfa2lsbF9zYisweDNkLzB4MjIwClsgICAgNC44NjQwNjZdICBbPGMw
M2E2MTBiPl0gZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHg0Yi8weGUwClsgICAgNC44NjQw
NjZdICBbPGMwNTQ3ODBmPl0gbG9nZnNfbW91bnQrMHhjMGYvMHhkNDAKWyAgICA0Ljg2NDA2
Nl0gIFs8YzAzYThiZDM+XSBtb3VudF9mcysweGQzLzB4MmUwClsgICAgNC44NjQwNjZdICBb
PGMwMzVjMDNiPl0gPyBrc3RyZHVwKzB4NWIvMHhhMApbICAgIDQuODY0MDY2XSAgWzxjMDNk
N2M1MT5dIHZmc19rZXJuX21vdW50KzB4OTEvMHgxNjAKWyAgICA0Ljg2NDA2Nl0gIFs8YzAz
ZGIyYWI+XSBkb19tb3VudCsweDEwMGIvMHgxMzQwClsgICAgNC44NjQwNjZdICBbPGMwMzVj
NTVhPl0gPyBzdHJuZHVwX3VzZXIrMHg1YS8weGEwClsgICAgNC44NjQwNjZdICBbPGMwM2Ri
NmU1Pl0gU3lTX21vdW50KzB4MTA1LzB4MWEwClsgICAgNC44NjQwNjZdICBbPGMyMWYwZDA4
Pl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ct
eW9jdG8tcm9hbS0xMjoyMDE0MDMxNTIwMjUxNTppMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0OjMuMTAuMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC84YmI0
OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0t
MzA6MjAxNDAzMTUyMDI1MTQ6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNDozLjEwLjA6
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvOGJiNDk1ZTNmMDI0MDFl
ZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTQ1OjIwMTQwMzE1
MjAyNTE0OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4xMC4wOjIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS02OjIwMTQwMzE1MjAyNTE1OmkzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4xMC4wOjIKMDo0OjQgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMApnaXQgY2hlY2tvdXQgdjMu
OQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC9uZXh0Om1hc3RlcjpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2
ZGFmYTI0YWQxOmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTUtMjA6MjU6MzQgYzFiZTVhNWIx
YjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQv
YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC1jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQx
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC1jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5
NzllYjY2ZGFmYTI0YWQxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvdm1saW51
ei0zLjkuMAoKMjAxNC0wMy0xNS0yMTowMzozNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRF
U1QgRkFJTFVSRQpbICAgIDIuOTg4MzE1XSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5
OiAxMTM2ayBmcmVlZApbICAgIDQuMzA0Mjc1XSBMb2dGUzogU3RhcnQgbW91bnQgMApbICAg
IDQuMzE2NjYxXSBMb2dGUzogU3RhcnQgdW5tb3VudGluZwpbICAgIDQuMzI5MTQ3XSBJTkZP
OiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAgNC4zMzAwNDhdIHRo
ZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlvbi4KWyAgICA0LjMz
MDA0OF0gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLgpb
ICAgIDQuMzMwMDQ4XSBQaWQ6IDM3NywgY29tbTogbW91bnQgTm90IHRhaW50ZWQgMy45LjAg
IzEKWyAgICA0LjMzMDA0OF0gQ2FsbCBUcmFjZToKWyAgICA0LjMzMDA0OF0gIFs8YzAyZDJl
OTQ+XSBfX2xvY2tfYWNxdWlyZS5pc3JhLjIxKzB4Mzk0LzB4MTk2MApbICAgIDQuMzMwMDQ4
XSAgWzxjMjBmZDQ4MD5dID8gd2FpdF9mb3JfY29tcGxldGlvbisweDIwLzB4NDAKWyAgICA0
LjMzMDA0OF0gIFs8YzAzZGY0NDU+XSA/IHdyaXRlYmFja19pbm9kZXNfc2JfbnIrMHgxMDUv
MHgxNDAKWyAgICA0LjMzMDA0OF0gIFs8YzAyZDQ1MGM+XSBsb2NrX2FjcXVpcmUrMHhhYy8w
eDEwMApbICAgIDQuMzMwMDQ4XSAgWzxjMDUzNjA4ZD5dID8gbG9nZnNfZ2V0X3dibG9ja3Mr
MHgxMmQvMHgxNjAKWyAgICA0LjMzMDA0OF0gIFs8YzIwZjhmMGY+XSBtdXRleF9sb2NrX25l
c3RlZCsweGFmLzB4NmEwClsgICAgNC4zMzAwNDhdICBbPGMwNTM2MDhkPl0gPyBsb2dmc19n
ZXRfd2Jsb2NrcysweDEyZC8weDE2MApbICAgIDQuMzMwMDQ4XSAgWzxjMDUzNjA4ZD5dID8g
bG9nZnNfZ2V0X3dibG9ja3MrMHgxMmQvMHgxNjAKWyAgICA0LjMzMDA0OF0gIFs8YzA1MzYw
OGQ+XSBsb2dmc19nZXRfd2Jsb2NrcysweDEyZC8weDE2MApbICAgIDQuMzMwMDQ4XSAgWzxj
MDUzMDQwMz5dIGxvZ2ZzX3N5bmNfZnMrMHgyMy8weDgwClsgICAgNC4zMzAwNDhdICBbPGMw
M2U1M2JjPl0gX19zeW5jX2ZpbGVzeXN0ZW0rMHg3Yy8weGMwClsgICAgNC4zMzAwNDhdICBb
PGMwM2U1NWYyPl0gc3luY19maWxlc3lzdGVtKzB4NzIvMHhjMApbICAgIDQuMzMwMDQ4XSAg
WzxjMDUzZGFmZD5dIGxvZ2ZzX2tpbGxfc2IrMHgzZC8weDIyMApbICAgIDQuMzMwMDQ4XSAg
WzxjMDM5ZWYyOD5dIGRlYWN0aXZhdGVfbG9ja2VkX3N1cGVyKzB4NjgvMHgxMDAKWyAgICA0
LjMzMDA0OF0gIFs8YzA1M2Y1NGY+XSBsb2dmc19tb3VudCsweGMwZi8weGQ0MApbICAgIDQu
MzMwMDQ4XSAgWzxjMDNhMTlkMz5dIG1vdW50X2ZzKzB4ZDMvMHgyZTAKWyAgICA0LjMzMDA0
OF0gIFs8YzAzNTU1ZmI+XSA/IGtzdHJkdXArMHg1Yi8weGEwClsgICAgNC4zMzAwNDhdICBb
PGMwM2QwZGYxPl0gdmZzX2tlcm5fbW91bnQrMHg5MS8weDE2MApbICAgIDQuMzMwMDQ4XSAg
WzxjMDNkM2U5Nj5dIGRvX21vdW50KzB4MTAxNi8weDEzNDAKWyAgICA0LjMzMDA0OF0gIFs8
YzAzNTViM2E+XSA/IHN0cm5kdXBfdXNlcisweDVhLzB4YTAKWyAgICA0LjMzMDA0OF0gIFs8
YzAzZDQyYjY+XSBzeXNfbW91bnQrMHhmNi8weDE4MApbICAgIDQuMzMwMDQ4XSAgWzxjMjEw
MDk0OD5dIHN5c2NhbGxfY2FsbCsweDcvMHhiCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2Rt
ZXNnLXlvY3RvLXJvYW0tMjc6MjAxNDAzMTUyMTAzMzk6aTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNDozLjkuMDoxCjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNl
Y3Q6IGJhZCBjb21taXQgdjMuOQpnaXQgY2hlY2tvdXQgdjMuOApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9uZXh0Om1h
c3RlcjoxOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwOmJpc2VjdC1s
aW51eDgKCjIwMTQtMDMtMTUtMjE6MDQ6MDggMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2Fj
NmJlMTRiZmNiMTIwMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTE5Zjk0OWY1
MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMTlmOTQ5ZjUyNTk5YmE3YzNm
NjdhNTg5N2FjNmJlMTRiZmNiMTIwMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC0xOWY5
NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC0xOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzE5Zjk0OWY1MjU5
OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvdm1saW51ei0zLjguMAoKMjAxNC0wMy0x
NS0yMToyNzowOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4gVEVTVCBGQUlMVVJFClsg
ICAgNi4xNTgzNjFdIChzdGMpOiAgY2hubF9pZCA4IG5vdCBzdXBwb3J0ZWQKWyAgICA2LjE1
ODkxN10gZm1kcnY6IHN0X3VucmVnaXN0ZXIgZmFpbGVkIC05MwpbICAgIDYuMTU5ODk3XSBm
bWRydjogVW5hYmxlIHRvIHByZXBhcmUgRk0gQ09SRQpbICAgMTUuODU1MDIwXSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGU1MjQ1M2EwClsgICAx
NS44NTUwMzldIElQOiBbPGMwMzFiMDQ2Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHgxNjYvMHgx
YzAKWyAgIDE1Ljg1NTAzOV0gKnBkcHQgPSAwMDAwMDAwMDAyZDdjMDAxICpwZGUgPSAwMDAw
MDAwMDAwMDAwMDAwIApbICAgMTUuODU1MDM5XSBPb3BzOiAwMDAyIFsjMV0gUFJFRU1QVCAK
WyAgIDE1Ljg1NTAzOV0gUGlkOiA0MDIsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRl
ZCAzLjguMCAjMSBCb2NocyBCb2NocwpbICAgMTUuODU1MDM5XSBFSVA6IDAwNjA6WzxjMDMx
YjA0Nj5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAxNS44NTUwMzldIEVJUCBpcyBh
dCBwZXJmX3N3ZXZlbnRfaW5pdCsweDE2Ni8weDFjMApbICAgMTUuODU1MDM5XSBFQVg6IDAw
MDAwMDAwIEVCWDogYzg5ZWNjMDAgRUNYOiAwMDAwMDAwMSBFRFg6IDAwMDAwMDAwClsgICAx
NS44NTUwMzldIEVTSTogODg4MDJkZTggRURJOiAwMDAwMDAwMCBFQlA6IGNlYTkxZWJjIEVT
UDogY2VhOTFlYjQKWyAgIDE1Ljg1NTAzOV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAw
IEdTOiAwMDMzIFNTOiAwMDY4ClsgICAxNS44NTUwMzldIENSMDogODAwNTAwM2IgQ1IyOiBl
NTI0NTNhMCBDUjM6IDBlYTE2MDAwIENSNDogMDAwMDA2ZjAKWyAgIDE1Ljg1NTAzOV0gRFIw
OiAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwIERSMjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApb
ICAgMTUuODU1MDM5XSBEUjY6IGZmZmYwZmYwIERSNzogMDAwMDA2MDAKWyAgIDE1Ljg1NTAz
OV0gUHJvY2VzcyB0cmluaXR5LW1haW4gKHBpZDogNDAyLCB0aT1jZWE5MDAwMCB0YXNrPWNl
YmVjZmQwIHRhc2sudGk9Y2VhOTAwMDApClsgICAxNS44NTUwMzldIFN0YWNrOgpbICAgMTUu
ODU1MDM5XSAgYzI5MjQzNDAgYzg5ZWNjMDAgY2VhOTFlZTQgYzAzMjM3MGUgMDAwMDAwMDIg
MDAwMDAwMDEgMDAwMDAwMDAgYzAzMjM1ODAKWyAgIDE1Ljg1NTAzOV0gIGMyOTI0MzQwIDAw
MDAwMDAwIGM4OWVjZDQ4IGM4OWVjYzAwIGNlYTkxZjAwIGMwMzIzYjhmIGNlYTkxZjQwIGM4
OWVjYzAwClsgICAxNS44NTUwMzldICAwMDAwMDAwMCBjZWJlY2ZkMCAwMDAwMDAwMCBjZWE5
MWZhYyBjMDMyNGJmNSBjODllY2MwMCAwMDAwMDAwMCAwMDAwMDAwMApbICAgMTUuODU1MDM5
XSBDYWxsIFRyYWNlOgpbICAgMTUuODU1MDM5XSAgWzxjMDMyMzcwZT5dIHBlcmZfaW5pdF9l
dmVudCsweDE4ZS8weDI0MApbICAgMTUuODU1MDM5XSAgWzxjMDMyMzU4MD5dID8gcGVyZl9w
bXVfdW5yZWdpc3RlcisweDI2MC8weDI2MApbICAgMTUuODU1MDM5XSAgWzxjMDMyM2I4Zj5d
IHBlcmZfZXZlbnRfYWxsb2MrMHgzY2YvMHg2ODAKWyAgIDE1Ljg1NTAzOV0gIFs8YzAzMjRi
ZjU+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4ODk1LzB4MTFhMApbICAgMTUuODU1MDM5XSAg
WzxjMDJhNWE1Mj5dID8gdXBfcmVhZCsweDMyLzB4ODAKWyAgIDE1Ljg1NTAzOV0gIFs8YzFl
MTdlOTI+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzMwpbICAgMTUuODU1MDM5XSBDb2Rl
OiAxNSA4NCBjZSAyMyBjMyAwMCA4MyAwNSAxMCBjZiAyMyBjMyAwMSA4MyAxNSAxNCBjZiAy
MyBjMyAwMCBlYiA0ZiA4ZCBiNCAyNiAwMCAwMCAwMCAwMCA4MyAwNSAxOCBjZiAyMyBjMyAw
MSA4MyAxNSAxYyBjZiAyMyBjMyAwMCA8ZmY+IDA0IGI1IDAwIDljIDIzIGMzIDgzIDA1IDIw
IGNmIDIzIGMzIDAxIGM3IDgzIGMwIDAyIDAwIDAwIDIwClsgICAxNS44NTUwMzldIEVJUDog
WzxjMDMxYjA0Nj5dIHBlcmZfc3dldmVudF9pbml0KzB4MTY2LzB4MWMwIFNTOkVTUCAwMDY4
OmNlYTkxZWI0ClsgICAxNS44NTUwMzldIENSMjogMDAwMDAwMDBlNTI0NTNhMApbICAgMTUu
ODU1MDM5XSAtLS1bIGVuZCB0cmFjZSBhMDE2OWI4MDU0MDEzYzUzIF0tLS0KWyAgIDE1Ljg1
NTAzOV0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRl
eHQgYXQga2VybmVsL3J3c2VtLmM6MjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvZG1lc2ct
cXVhbnRhbC1jYWlyby0yMjoyMDE0MDMxNTIxMzAwNTppMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0OjMuOC4wOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2Vj
dDogYmFkIGNvbW1pdCB2My44CmdpdCBjaGVja291dCB2My43CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L25leHQ6bWFz
dGVyOjI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGU6YmlzZWN0LWxp
bnV4OAoKMjAxNC0wMy0xNS0yMTozMDoxMiAyOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQz
ZGNjNTM5NzBjNjBlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtMjk1OTQ0MDRk
N2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8yOTU5NDQwNGQ3ZmU3M2NkODBl
YWE0ZWU4YzQzZGNjNTM5NzBjNjBlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTI5NTk0
NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMjk1OTQ0MDRkN2Zl
NzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS92bWxpbnV6LTMuNy4wCgoyMDE0LTAzLTE1
LTIyOjA0OjEyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
IFRFU1QgRkFJTFVSRQpbICAgIDguNDA2MTc4XSAoc3RjKTogIGNobmxfaWQgOCBub3Qgc3Vw
cG9ydGVkClsgICAgOC40MDY4OTldIGZtZHJ2OiBzdF91bnJlZ2lzdGVyIGZhaWxlZCAtOTMK
WyAgICA4LjQwODIyMF0gZm1kcnY6IFVuYWJsZSB0byBwcmVwYXJlIEZNIENPUkUKWyAgIDE3
Ljk5MjQ3NV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBh
dCBlOTZiZTcyOApbICAgMTcuOTkzMDYyXSBJUDogWzxjMDMxOWE2Nj5dIHBlcmZfc3dldmVu
dF9pbml0KzB4MTY2LzB4MWMwClsgICAxNy45OTMwNjJdICpwZHB0ID0gMDAwMDAwMDAwMmMz
MDAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE3Ljk5MzA2Ml0gT29wczogMDAw
MiBbIzFdIFBSRUVNUFQgClsgICAxNy45OTMwNjJdIFBpZDogMzk5LCBjb21tOiB0cmluaXR5
LW1haW4gTm90IHRhaW50ZWQgMy43LjAgIzEgQm9jaHMgQm9jaHMKWyAgIDE3Ljk5MzA2Ml0g
RUlQOiAwMDYwOls8YzAzMTlhNjY+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgMTcu
OTkzMDYyXSBFSVAgaXMgYXQgcGVyZl9zd2V2ZW50X2luaXQrMHgxNjYvMHgxYzAKWyAgIDE3
Ljk5MzA2Ml0gRUFYOiAwMDAwMDAwMCBFQlg6IGM4ODk4ODAwIEVDWDogMDAwMDAwMDEgRURY
OiAwMDAwMDAwMApbICAgMTcuOTkzMDYyXSBFU0k6IDg5OTc0NDlhIEVESTogMDAwMDAwMDAg
RUJQOiBjZWIxYmViYyBFU1A6IGNlYjFiZWI0ClsgICAxNy45OTMwNjJdICBEUzogMDA3YiBF
UzogMDA3YiBGUzogMDAwMCBHUzogMDAzMyBTUzogMDA2OApbICAgMTcuOTkzMDYyXSBDUjA6
IDgwMDUwMDNiIENSMjogZTk2YmU3MjggQ1IzOiAwZWE0MjAwMCBDUjQ6IDAwMDAwNmYwClsg
ICAxNy45OTMwNjJdIERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAw
IERSMzogMDAwMDAwMDAKWyAgIDE3Ljk5MzA2Ml0gRFI2OiBmZmZmMGZmMCBEUjc6IDAwMDAw
NjAwClsgICAxNy45OTMwNjJdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDM5OSwgdGk9
Y2ViMWEwMDAgdGFzaz1jODkwZjNkMCB0YXNrLnRpPWNlYjFhMDAwKQpbICAgMTcuOTkzMDYy
XSBTdGFjazoKWyAgIDE3Ljk5MzA2Ml0gIGMyN2Y3ZTAwIGM4ODk4ODAwIGNlYjFiZWU0IGMw
MzIyMTJlIDAwMDAwMDAyIDAwMDAwMDAxIDAwMDAwMDAwIGMwMzIxZmEwClsgICAxNy45OTMw
NjJdICBjMjdmN2UwMCAwMDAwMDAwMCBjODg5ODk0OCBjODg5ODgwMCBjZWIxYmYwMCBjMDMy
MjU5NyBjZWIxYmY0MCBjODg5ODgwMApbICAgMTcuOTkzMDYyXSAgMDAwMDAwMDAgYzg5MGYz
ZDAgY2ViMWJmYTAgY2ViMWJmYWMgYzAzMjM1ZjggYzg4OTg4MDAgMDAwMDAwMDAgMDAwMDAw
MDAKWyAgIDE3Ljk5MzA2Ml0gQ2FsbCBUcmFjZToKWyAgIDE3Ljk5MzA2Ml0gIFs8YzAzMjIx
MmU+XSBwZXJmX2luaXRfZXZlbnQrMHgxOGUvMHgyNDAKWyAgIDE3Ljk5MzA2Ml0gIFs8YzAz
MjFmYTA+XSA/IHBlcmZfcG11X3VucmVnaXN0ZXIrMHgyNjAvMHgyNjAKWyAgIDE3Ljk5MzA2
Ml0gIFs8YzAzMjI1OTc+XSBwZXJmX2V2ZW50X2FsbG9jKzB4M2I3LzB4NjYwClsgICAxNy45
OTMwNjJdICBbPGMwMzIzNWY4Pl0gc3lzX3BlcmZfZXZlbnRfb3BlbisweDg5OC8weDExNjAK
WyAgIDE3Ljk5MzA2Ml0gIFs8YzAyYTRkNzI+XSA/IHVwX3JlYWQrMHgzMi8weDgwClsgICAx
Ny45OTMwNjJdICBbPGMxZDMzNWIyPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzMKWyAg
IDE3Ljk5MzA2Ml0gQ29kZTogMTUgNDQgMDcgMGYgYzMgMDAgODMgMDUgZDAgMDcgMGYgYzMg
MDEgODMgMTUgZDQgMDcgMGYgYzMgMDAgZWIgNGYgOGQgYjQgMjYgMDAgMDAgMDAgMDAgODMg
MDUgZDggMDcgMGYgYzMgMDEgODMgMTUgZGMgMDcgMGYgYzMgMDAgPGZmPiAwNCBiNSBjMCBk
NCAwZSBjMyA4MyAwNSBlMCAwNyAwZiBjMyAwMSBjNyA4MyBjMCAwMiAwMCAwMCA0MApbICAg
MTcuOTkzMDYyXSBFSVA6IFs8YzAzMTlhNjY+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDE2Ni8w
eDFjMCBTUzpFU1AgMDA2ODpjZWIxYmViNApbICAgMTcuOTkzMDYyXSBDUjI6IDAwMDAwMDAw
ZTk2YmU3MjgKWyAgIDE3Ljk5MzA2Ml0gLS0tWyBlbmQgdHJhY2UgOTdkZDhjZTFlNmQ0YTUw
OSBdLS0tClsgICAxNy45OTMwNjJdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZy
b20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzE1MDAyNC8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNj
NTM5NzBjNjBlL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDM6MjAxNDAzMTUyMjQxNTM6aTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzE1MDAyNDozLjcuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBl
L2RtZXNnLXF1YW50YWwtc25iLTI6MjAxNDAzMTUyMjQyMTY6aTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8yOTU5
NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlL2RtZXNnLXlvY3RvLWNhaXJv
LTExOjIwMTQwMzE1MjI0MTQ0OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My43LjA6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMjk1OTQ0MDRkN2ZlNzNj
ZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy1xdWFudGFsLWF0aGVucy0xOToyMDE0
MDMxNTIyNDIzNDppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNy4wOjEKMDo0OjQg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My43Cmdp
dCBjaGVja291dCB2My42CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L25leHQ6bWFzdGVyOmEwZDI3MWNiZmVkMWRkNTAy
NzhjNmIwNmJlYWQzZDAwYmEwYTg4Zjk6YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNS0yMjo0
Mjo0NiBhMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNk
MDBiYTBhODhmOQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC9hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LWEwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJl
YWQzZDAwYmEwYTg4ZjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LWEwZDI3MWNiZmVk
MWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkKa2VybmVsOiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zdDAtMDMxNTAwMjQvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBi
YTBhODhmOS92bWxpbnV6LTMuNi4wCgoyMDE0LTAzLTE1LTIzOjEyOjQ2IGRldGVjdGluZyBi
b290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAxMy42NDcxMDZdIHNvY2s6IHByb2Nlc3Mg
YHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01Q
QVQKWyAgIDEzLjY4MjMyNl0gaXJkYV9zZXRzb2Nrb3B0OiBub3QgYWxsb3dlZCB0byBzZXQg
TUFYU0RVU0laRSBmb3IgdGhpcyBzb2NrZXQgdHlwZSEKWyAgIDEzLjgzMzQzNl0gaXJkYV9z
ZXRzb2Nrb3B0OiBub3QgYWxsb3dlZCB0byBzZXQgTUFYU0RVU0laRSBmb3IgdGhpcyBzb2Nr
ZXQgdHlwZSEKWyAgIDE0LjI4OTIxMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBw
YWdpbmcgcmVxdWVzdCBhdCBlZWU0NWVmYwpbICAgMTQuMjkwMDMzXSBJUDogWzxjMDMxMzcw
Nj5dIHBlcmZfc3dldmVudF9pbml0KzB4MTY2LzB4MWMwClsgICAxNC4yOTAwMzNdICpwZHB0
ID0gMDAwMDAwMDAwMjk4YjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE0LjI5
MDAzM10gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgClsgICAxNC4yOTAwMzNdIFBpZDogNTc2
LCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy42LjAgIzEgQm9jaHMgQm9jaHMK
WyAgIDE0LjI5MDAzM10gRUlQOiAwMDYwOls8YzAzMTM3MDY+XSBFRkxBR1M6IDAwMDEwMjQ2
IENQVTogMApbICAgMTQuMjkwMDMzXSBFSVAgaXMgYXQgcGVyZl9zd2V2ZW50X2luaXQrMHgx
NjYvMHgxYzAKWyAgIDE0LjI5MDAzM10gRUFYOiAwMDAwMDAwMCBFQlg6IGNkMjg4ODAwIEVD
WDogMDAwMDAwMDEgRURYOiAwMDAwMDAwMApbICAgMTQuMjkwMDMzXSBFU0k6IDhhZmZmZmZm
IEVESTogMDAwMDAwMDAgRUJQOiBjZDZmYmVjYyBFU1A6IGNkNmZiZWM0ClsgICAxNC4yOTAw
MzNdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAzMyBTUzogMDA2OApbICAg
MTQuMjkwMDMzXSBDUjA6IDgwMDUwMDNiIENSMjogZWVlNDVlZmMgQ1IzOiAwZDdkMjAwMCBD
UjQ6IDAwMDAwNmYwClsgICAxNC4yOTAwMzNdIERSMDogMDgwZDMwMDAgRFIxOiAwODBjZTAw
MCBEUjI6IDAwMDAwMDAwIERSMzogMDAwMDAwMDAKWyAgIDE0LjI5MDAzM10gRFI2OiBmZmZm
MGZmMCBEUjc6IDAwMDAwNjAwClsgICAxNC4yOTAwMzNdIFByb2Nlc3MgdHJpbml0eS1tYWlu
IChwaWQ6IDU3NiwgdGk9Y2Q2ZmEwMDAgdGFzaz1jZDAxZWJkMCB0YXNrLnRpPWNkNmZhMDAw
KQpbICAgMTQuMjkwMDMzXSBTdGFjazoKWyAgIDE0LjI5MDAzM10gIGMyNWEwYWMwIGNkMjg4
ODAwIGNkNmZiZWY0IGMwMzFiN2NlIDAwMDAwMDAyIDAwMDAwMDAxIDAwMDAwMDAwIGMwMzFi
NjQwClsgICAxNC4yOTAwMzNdICBjMjVhMGFjMCAwMDAwMDAwMCBjZDI4ODkzOCBjZDI4ODgw
MCBjZDZmYmYxMCBjMDMxYmMzNyBjZDZmYmY1MCBjZDI4ODgwMApbICAgMTQuMjkwMDMzXSAg
MDAwMDAwMDAgY2QwMWViZDAgMDAwMDAwMDAgY2Q2ZmJmYWMgYzAzMWNjMzUgY2QyODg4MDAg
MDAwMDAwMDAgMDAwMDAwMDAKWyAgIDE0LjI5MDAzM10gQ2FsbCBUcmFjZToKWyAgIDE0LjI5
MDAzM10gIFs8YzAzMWI3Y2U+XSBwZXJmX2luaXRfZXZlbnQrMHgxOGUvMHgyNDAKWyAgIDE0
LjI5MDAzM10gIFs8YzAzMWI2NDA+XSA/IHBlcmZfcG11X3VucmVnaXN0ZXIrMHgyNjAvMHgy
NjAKWyAgIDE0LjI5MDAzM10gIFs8YzAzMWJjMzc+XSBwZXJmX2V2ZW50X2FsbG9jKzB4M2I3
LzB4NmEwClsgICAxNC4yOTAwMzNdICBbPGMwMzFjYzM1Pl0gc3lzX3BlcmZfZXZlbnRfb3Bl
bisweDdmNS8weDEwMDAKWyAgIDE0LjI5MDAzM10gIFs8YzFiNTYwMDU+XSBzeXNjYWxsX2Nh
bGwrMHg3LzB4YgpbICAgMTQuMjkwMDMzXSAgWzxjMWI1MDAwMD5dID8gbXV0ZXhfbG9ja19r
aWxsYWJsZV9uZXN0ZWQrMHg1YTAvMHg4MjAKWyAgIDE0LjI5MDAzM10gQ29kZTogMTUgMjQg
OTAgZTQgYzIgMDAgODMgMDUgYjAgOTAgZTQgYzIgMDEgODMgMTUgYjQgOTAgZTQgYzIgMDAg
ZWIgNGYgOGQgYjQgMjYgMDAgMDAgMDAgMDAgODMgMDUgYjggOTAgZTQgYzIgMDEgODMgMTUg
YmMgOTAgZTQgYzIgMDAgPGZmPiAwNCBiNSAwMCA1ZiBlNCBjMiA4MyAwNSBjMCA5MCBlNCBj
MiAwMSBjNyA4MyBiMCAwMiAwMCAwMCBlMApbICAgMTQuMjkwMDMzXSBFSVA6IFs8YzAzMTM3
MDY+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDE2Ni8weDFjMCBTUzpFU1AgMDA2ODpjZDZmYmVj
NApbICAgMTQuMjkwMDMzXSBDUjI6IDAwMDAwMDAwZWVlNDVlZmMKWyAgIDE0LjI5MDAzM10g
LS0tWyBlbmQgdHJhY2UgNDI2ZDk2MGExY2NiYzFkZCBdLS0tClsgICAxNC4yOTAwMzNdIEJV
Rzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtl
cm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9h
MGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5L2RtZXNnLXlvY3RvLWNh
aXJvLTQyOjIwMTQwMzE1MjMxMzA1OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My42
LjA6MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjYKZ2l0IGNoZWNrb3V0IHYzLjUKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvbmV4dDptYXN0ZXI6MjhhMzNj
YmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MjpiaXNlY3QtbGludXg4CgoyMDE0
LTAzLTE1LTIzOjEzOjE5IDI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlm
OTIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC0yOGEzM2NiYzI0ZTQyNTZjMTQz
ZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkz
YmY0MjMyMjlmOTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtMjhhMzNjYmMyNGU0MjU2
YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQt
MjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MgprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8yOGEzM2NiYzI0ZTQyNTZjMTQzZGNl
OTZjN2Q5M2JmNDIzMjI5ZjkyL3ZtbGludXotMy41LjAKCjIwMTQtMDMtMTUtMjM6NTQ6MjAg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIwIFRFU1QgRkFJ
TFVSRQpbICAgIDUuMjc5NzU0XSAoc3RjKTogIGNobmxfaWQgOCBub3Qgc3VwcG9ydGVkClsg
ICAgNS4yODAzODldIGZtZHJ2OiBzdF91bnJlZ2lzdGVyIGZhaWxlZCAtOTMKWyAgICA1LjI4
MTQyOF0gZm1kcnY6IFVuYWJsZSB0byBwcmVwYXJlIEZNIENPUkUKWyAgIDEzLjE5MzcxN10g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA5MjYxOGI4
OApbICAgMTMuMTk0MDY1XSBJUDogWzxjMDMwYmQ2Nj5dIHBlcmZfc3dldmVudF9pbml0KzB4
MTY2LzB4MWMwClsgICAxMy4xOTQwNjVdICpwZHB0ID0gMDAwMDAwMDAwODkxNTAwMSAqcGRl
ID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDEzLjE5NDA2NV0gT29wczogMDAwMiBbIzFdIFBS
RUVNUFQgClsgICAxMy4xOTQwNjVdIApbICAgMTMuMTk0MDY1XSBQaWQ6IDM5OCwgY29tbTog
dHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuNS4wICMxIEJvY2hzIEJvY2hzClsgICAxMy4x
OTQwNjVdIEVJUDogMDA2MDpbPGMwMzBiZDY2Pl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAK
WyAgIDEzLjE5NDA2NV0gRUlQIGlzIGF0IHBlcmZfc3dldmVudF9pbml0KzB4MTY2LzB4MWMw
ClsgICAxMy4xOTQwNjVdIEVBWDogMDAwMDAwMDAgRUJYOiBjZGEyMzQwMCBFQ1g6IDAwMDAw
MDAxIEVEWDogMDAwMDAwMDAKWyAgIDEzLjE5NDA2NV0gRVNJOiBiM2RmZGNmYSBFREk6IDAw
MDAwMDAwIEVCUDogYzg4YmRlY2MgRVNQOiBjODhiZGVjNApbICAgMTMuMTk0MDY1XSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAwNjgKWyAgIDEzLjE5NDA2
NV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDkyNjE4Yjg4IENSMzogMDg5ZjkwMDAgQ1I0OiAwMDAw
MDZmMApbICAgMTMuMTk0MDY1XSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAw
MDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICAxMy4xOTQwNjVdIERSNjogZmZmZjBmZjAgRFI3
OiAwMDAwMDQwMApbICAgMTMuMTk0MDY1XSBQcm9jZXNzIHRyaW5pdHktbWFpbiAocGlkOiAz
OTgsIHRpPWM4OGJjMDAwIHRhc2s9Yzg4ZTczZDAgdGFzay50aT1jODhiYzAwMCkKWyAgIDEz
LjE5NDA2NV0gU3RhY2s6ClsgICAxMy4xOTQwNjVdICBjMjU3OGYwMCBjZGEyMzQwMCBjODhi
ZGVmNCBjMDMxM2QyZSAwMDAwMDAwMiAwMDAwMDAwMSAwMDAwMDAwMCBjMDMxM2JhMApbICAg
MTMuMTk0MDY1XSAgYzI1NzhmMDAgMDAwMDAwMDAgY2RhMjM1MzggY2RhMjM0MDAgYzg4YmRm
MTAgYzAzMTQxOGYgYzg4YmRmNTAgY2RhMjM0MDAKWyAgIDEzLjE5NDA2NV0gIDAwMDAwMDAw
IGM4OGU3M2QwIDAwMDAwMDAwIGM4OGJkZmFjIGMwMzE1MGY1IGNkYTIzNDAwIDAwMDAwMDAw
IDAwMDAwMDAwClsgICAxMy4xOTQwNjVdIENhbGwgVHJhY2U6ClsgICAxMy4xOTQwNjVdICBb
PGMwMzEzZDJlPl0gcGVyZl9pbml0X2V2ZW50KzB4MThlLzB4MjQwClsgICAxMy4xOTQwNjVd
ICBbPGMwMzEzYmEwPl0gPyBwZXJmX3BtdV91bnJlZ2lzdGVyKzB4MjYwLzB4MjYwClsgICAx
My4xOTQwNjVdICBbPGMwMzE0MThmPl0gcGVyZl9ldmVudF9hbGxvYysweDNhZi8weDZhMApb
ICAgMTMuMTk0MDY1XSAgWzxjMDMxNTBmNT5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg3ZjUv
MHhmZTAKWyAgIDEzLjE5NDA2NV0gIFs8YzAyNDRmNTI+XSA/IGRvX3BhZ2VfZmF1bHQrMHg3
OTIvMHg4ODAKWyAgIDEzLjE5NDA2NV0gIFs8YzFiM2IyNWM+XSBzeXNlbnRlcl9kb19jYWxs
KzB4MTIvMHgzMwpbICAgMTMuMTk0MDY1XSBDb2RlOiAxNSBhNCA0OCBlMiBjMiAwMCA4MyAw
NSAzMCA0OSBlMiBjMiAwMSA4MyAxNSAzNCA0OSBlMiBjMiAwMCBlYiA0ZiA4ZCBiNCAyNiAw
MCAwMCAwMCAwMCA4MyAwNSAzOCA0OSBlMiBjMiAwMSA4MyAxNSAzYyA0OSBlMiBjMiAwMCA8
ZmY+IDA0IGI1IGEwIDE3IGUyIGMyIDgzIDA1IDQwIDQ5IGUyIGMyIDAxIGM3IDgzIGIwIDAy
IDAwIDAwIGMwIApbICAgMTMuMTk0MDY1XSBFSVA6IFs8YzAzMGJkNjY+XSBwZXJmX3N3ZXZl
bnRfaW5pdCsweDE2Ni8weDFjMCBTUzpFU1AgMDA2ODpjODhiZGVjNApbICAgMTMuMTk0MDY1
XSBDUjI6IDAwMDAwMDAwOTI2MThiODgKWyAgIDEzLjIyNzY3MF0gLS0tWyBlbmQgdHJhY2Ug
NzUxNTEwMzIxOGIyMmM0MiBdLS0tClsgICAxMy4yMjg4OTRdIGNhaWY6Y2FpZl9kaXNjb25u
ZWN0X2NsaWVudCgpOiBub3RoaW5nIHRvIGRpc2Nvbm5lY3QKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMy
MjlmOTIvZG1lc2ctcXVhbnRhbC1jYWlyby0xMDoyMDE0MDMxNjAwMDAxMDppMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvZG1l
c2ctcXVhbnRhbC1jYWlyby0xNjoyMDE0MDMxNjAwMDAxMDppMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvZG1lc2ctcXVhbnRh
bC1jYWlyby0yMDoyMDE0MDMxNjAwMDAxMDppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2Jj
MjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvZG1lc2ctcXVhbnRhbC1jYWlyby0y
NDoyMDE0MDMxNjAwMDAxMDppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNS4wOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMx
NDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvZG1lc2ctcXVhbnRhbC1jYWlyby0yNzoyMDE0MDMx
NjAwMDAxMDppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3
ZDkzYmY0MjMyMjlmOTIvZG1lc2ctcXVhbnRhbC1jYWlyby00NDoyMDE0MDMxNjAwMDAxMDpp
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMy
MjlmOTIvZG1lc2ctcXVhbnRhbC1jYWlyby00OjIwMTQwMzE2MDAwMDEwOmkzODYtcmFuZGNv
bmZpZy1zdDAtMDMxNTAwMjQ6My41LjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQvMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5Mi9kbWVz
Zy1xdWFudGFsLXhpYW4tMToyMDE0MDMxNjAwMDQyNjppMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzI4
YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvZG1lc2ctcXVhbnRhbC14
aWFuLTc6MjAxNDAzMTYwMDA0MjY6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNDozLjUu
MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8yOGEzM2NiYzI0ZTQy
NTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyL2RtZXNnLXlvY3RvLWNhaXJvLTEwOjIwMTQw
MzE2MDAwMDEwOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My41LjA6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2
YzdkOTNiZjQyMzIyOWY5Mi9kbWVzZy15b2N0by1jYWlyby0yMDoyMDE0MDMxNjAwMDAxMDpp
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNS4wOjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMy
MjlmOTIvZG1lc2cteW9jdG8tY2Fpcm8tMjE6MjAxNDAzMTYwMDAwMTA6aTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzE1MDAyNDozLjUuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC8yOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyL2RtZXNn
LXlvY3RvLWNhaXJvLTMzOjIwMTQwMzE2MDAwMDEwOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQ6My41LjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMjhh
MzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5Mi9kbWVzZy15b2N0by1jYWly
by0zNzoyMDE0MDMxNjAwMDAxMDppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNS4w
OjEKMTk6MTQ6MTUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNv
bW1pdCB2My41CmdpdCBjaGVja291dCB2My40CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L25leHQ6bWFzdGVyOjc2ZTEw
ZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmM6YmlzZWN0LWxpbnV4OAoKMjAx
NC0wMy0xNi0wMDowNToyNSA3NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkw
MGJjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtNzZlMTBkMTU4ZWZiNmQ0NTE2
MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBj
MmFiNTUwMTkwMGJjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTc2ZTEwZDE1OGVmYjZk
NDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LTc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmMKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4
ODQ2ZjYwYzJhYjU1MDE5MDBiYy92bWxpbnV6LTMuNC4wCgoyMDE0LTAzLTE2LTAwOjI2OjI1
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDYuNjU2
NjM1XSAoc3RjKTogIGNobmxfaWQgOCBub3Qgc3VwcG9ydGVkClsgICAgNi42NTc1MTldIGZt
ZHJ2OiBzdF91bnJlZ2lzdGVyIGZhaWxlZCAtOTMKWyAgICA2LjY1OTA1M10gZm1kcnY6IFVu
YWJsZSB0byBwcmVwYXJlIEZNIENPUkUKWyAgIDE2LjQyMDgzNV0gQlVHOiB1bmFibGUgdG8g
aGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBkMmQ1YjNkOApbICAgMTYuNDIxMDYy
XSBJUDogWzxjMDMwOGE4ZD5dIHBlcmZfc3dldmVudF9pbml0KzB4MTBkLzB4MWMwClsgICAx
Ni40MjEwNjJdICpwZHB0ID0gMDAwMDAwMDAwMjhhNDAwMSAqcGRlID0gMDAwMDAwMDAwMDAw
MDAwMCAKWyAgIDE2LjQyMTA2Ml0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgClsgICAxNi40
MjEwNjJdIApbICAgMTYuNDIxMDYyXSBQaWQ6IDQwMiwgY29tbTogdHJpbml0eS1tYWluIE5v
dCB0YWludGVkIDMuNC4wICMxIEJvY2hzIEJvY2hzClsgICAxNi40MjEwNjJdIEVJUDogMDA2
MDpbPGMwMzA4YThkPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgIDE2LjQyMTA2Ml0g
RUlQIGlzIGF0IHBlcmZfc3dldmVudF9pbml0KzB4MTBkLzB4MWMwClsgICAxNi40MjEwNjJd
IEVBWDogMDAwMDAwMDAgRUJYOiBjZWI4NDAwMCBFQ1g6IDAwMDAwMDAxIEVEWDogMDAwMDAw
MDAKWyAgIDE2LjQyMTA2Ml0gRVNJOiA4NDAwMDBmZSBFREk6IDAwMDAwMDAwIEVCUDogY2U5
ZTFlY2MgRVNQOiBjZTllMWVjNApbICAgMTYuNDIxMDYyXSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAwNjgKWyAgIDE2LjQyMTA2Ml0gQ1IwOiA4MDA1MDAz
YiBDUjI6IGQyZDViM2Q4IENSMzogMGUxNzkwMDAgQ1I0OiAwMDAwMDZmMApbICAgMTYuNDIx
MDYyXSBEUjA6IDA4MGNlMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAw
MDAwMDAwClsgICAxNi40MjEwNjJdIERSNjogZmZmZjBmZjAgRFI3OiAwMDAwMDYwMApbICAg
MTYuNDIxMDYyXSBQcm9jZXNzIHRyaW5pdHktbWFpbiAocGlkOiA0MDIsIHRpPWNlOWUwMDAw
IHRhc2s9Y2ViNzg2YjAgdGFzay50aT1jZTllMDAwMCkKWyAgIDE2LjQyMTA2Ml0gU3RhY2s6
ClsgICAxNi40MjEwNjJdICBjMjRjZTVjMCBjZWI4NDAwMCBjZTllMWVmNCBjMDMxMGQxOSAw
MDAwMDAwMiAwMDAwMDAwMSAwMDAwMDAwMCBjMDMxMGIyMApbICAgMTYuNDIxMDYyXSAgYzI0
Y2U1YzAgMDAwMDAwMDAgY2ViODQxMzggY2ViODQwMDAgY2U5ZTFmMTAgYzAzMTExMDggY2U5
ZTFmNTAgY2ViODQwMDAKWyAgIDE2LjQyMTA2Ml0gIDAwMDAwMDAwIGNlYjc4NmIwIDAwMDAw
MDAwIGNlOWUxZmFjIGMwMzExZTAxIGNlYjg0MDAwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAx
Ni40MjEwNjJdIENhbGwgVHJhY2U6ClsgICAxNi40MjEwNjJdICBbPGMwMzEwZDE5Pl0gcGVy
Zl9pbml0X2V2ZW50KzB4MWY5LzB4MjQwClsgICAxNi40MjEwNjJdICBbPGMwMzEwYjIwPl0g
PyBwZXJmX3BtdV91bnJlZ2lzdGVyKzB4MjQwLzB4MjQwClsgICAxNi40MjEwNjJdICBbPGMw
MzExMTA4Pl0gcGVyZl9ldmVudF9hbGxvYysweDNhOC8weDZjMApbICAgMTYuNDIxMDYyXSAg
WzxjMDMxMWUwMT5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg1NjEvMHgxMDQwClsgICAxNi40
MjEwNjJdICBbPGMwMjQ1NzI3Pl0gPyBkb19wYWdlX2ZhdWx0KzB4MmM3LzB4ODgwClsgICAx
Ni40MjEwNjJdICBbPGMxYWQxMmRjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzMKWyAg
IDE2LjQyMTA2Ml0gQ29kZTogMDAgODMgMDUgYzAgZTAgZDUgYzIgMDEgODMgMTUgYzQgZTAg
ZDUgYzIgMDAgODMgMDUgNzAgZTEgZDUgYzIgMDEgODMgMTUgNzQgZTEgZDUgYzIgMDAgODMg
MDUgNzggZTEgZDUgYzIgMDEgODMgMTUgN2MgZTEgZDUgYzIgMDAgPGZmPiAwNCBiNSBlMCBh
ZiBkNSBjMiA4MyAwNSA4MCBlMSBkNSBjMiAwMSBjNyA4MyBiMCAwMiAwMCAwMCBjMCAKWyAg
IDE2LjQyMTA2Ml0gRUlQOiBbPGMwMzA4YThkPl0gcGVyZl9zd2V2ZW50X2luaXQrMHgxMGQv
MHgxYzAgU1M6RVNQIDAwNjg6Y2U5ZTFlYzQKWyAgIDE2LjQyMTA2Ml0gQ1IyOiAwMDAwMDAw
MGQyZDViM2Q4ClsgICAxNi40MjEwNjJdIC0tLVsgZW5kIHRyYWNlIDQxY2UxMTFmMDdkYjk4
NzkgXS0tLQpbICAgMTYuNDIxMDYyXSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBm
cm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwvcndzZW0uYzoyMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJh
YjU1MDE5MDBiYy9kbWVzZy1xdWFudGFsLWNhaXJvLTIzOjIwMTQwMzE2MDAyOTUwOmkzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My40LjA6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zdDAtMDMxNTAwMjQvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBi
Yy9kbWVzZy1xdWFudGFsLWNhaXJvLTg6MjAxNDAzMTYwMDI5NTQ6aTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNDozLjQuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1
YW50YWwtY2Fpcm8tNDA6MjAxNDAzMTYwMDMwMDY6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNDozLjQuMDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC83NmUx
MGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXlvY3RvLWNhaXJv
LTEwOjIwMTQwMzE2MDAzMDA2OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My40LjA6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNzZlMTBkMTU4ZWZiNmQ0
NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy15b2N0by1jYWlyby0xNToyMDE0MDMx
NjAwMzAwNjppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuNC4wOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0Lzc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2
MGMyYWI1NTAxOTAwYmMvZG1lc2cteW9jdG8tY2Fpcm8tMzM6MjAxNDAzMTYwMDMwMTE6aTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNDozLjQuMDoxCjA6Njo2IGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuNApnaXQgY2hlY2tvdXQgdjMu
MwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC9uZXh0Om1hc3RlcjpjMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTEx
Nzg0MzhjN2U3OmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDA6MzA6MzAgYzE2ZmE0ZjJh
ZDE5OTA4YTQ3YzYzZDhmYTQzNmExMTc4NDM4YzdlNyBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LWMxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQv
YzE2ZmE0ZjJhZDE5OTA4YTQ3YzYzZDhmYTQzNmExMTc4NDM4YzdlNwp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC1jMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTExNzg0MzhjN2U3
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC1jMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZh
NDM2YTExNzg0MzhjN2U3Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0L2MxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcvdm1saW51
ei0zLjMuMAoKMjAxNC0wMy0xNi0wMDo1MDozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
Li4gVEVTVCBGQUlMVVJFClsgICAgNy42NDM4NjFdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUg
cHR5IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDcuNjYwOTU0XSBpbml0OiBG
YWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA3
LjY3NDEyMl0gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2lu
ZyBmb3Igam9iClsgICAxNC41NDIxMzVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
cGFnaW5nIHJlcXVlc3QgYXQgMTY0MTg1MDgKWyAgIDE0LjU0MzA3MF0gSVA6IFs8YzAzMDkx
Yzk+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweGU5LzB4MWEwClsgICAxNC41NDMwNzBdICpwZHB0
ID0gMDAwMDAwMDAwZWFiYjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE0LjU0
MzA3MF0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgClsgICAxNC41NDMwNzBdIApbICAgMTQu
NTQzMDcwXSBQaWQ6IDM5NiwgY29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuMy4w
ICMxIEJvY2hzIEJvY2hzClsgICAxNC41NDMwNzBdIEVJUDogMDA2MDpbPGMwMzA5MWM5Pl0g
RUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgIDE0LjU0MzA3MF0gRUlQIGlzIGF0IHBlcmZf
c3dldmVudF9pbml0KzB4ZTkvMHgxYTAKWyAgIDE0LjU0MzA3MF0gRUFYOiAwMDAwMDAwMCBF
Qlg6IGNlOWZiYzAwIEVDWDogMDAwMDAwMDEgRURYOiAwMDAwMDAwMApbICAgMTQuNTQzMDcw
XSBFU0k6IDk0ZGQwNzNhIEVESTogMDAwMDAwMDAgRUJQOiBjZTkyZmVkNCBFU1A6IGNlOTJm
ZWNjClsgICAxNC41NDMwNzBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAz
MyBTUzogMDA2OApbICAgMTQuNTQzMDcwXSBQcm9jZXNzIHRyaW5pdHktbWFpbiAocGlkOiAz
OTYsIHRpPWNlOTJlMDAwIHRhc2s9Yzg4MTg4MzAgdGFzay50aT1jZTkyZTAwMCkKWyAgIDE0
LjU0MzA3MF0gU3RhY2s6ClsgICAxNC41NDMwNzBdICBjMjQ1NTllMCBjZTlmYmMwMCBjZTky
ZmVmYyBjMDMxMGFmOSAwMDAwMDAwMiAwMDAwMDAwMSAwMDAwMDAwMCBjMDMxMDkwMApbICAg
MTQuNTQzMDcwXSAgYzI0NTU5ZTAgMDAwMDAwMDAgY2U5ZmJkMjggY2U5ZmJjMDAgY2U5MmZm
MTggYzAzMTBlZTggY2U5MmZmNTggY2U5ZmJjMDAKWyAgIDE0LjU0MzA3MF0gIDAwMDAwMDAw
IGM4ODE4ODMwIDAwMDAwMDAwIGNlOTJmZmFjIGMwMzExYTVkIGNlOWZiYzAwIDAwMDAwMDAw
IDAwMDAwMDAwClsgICAxNC41NDMwNzBdIENhbGwgVHJhY2U6ClsgICAxNC41NDMwNzBdICBb
PGMwMzEwYWY5Pl0gcGVyZl9pbml0X2V2ZW50KzB4MWY5LzB4MjQwClsgICAxNC41NDMwNzBd
ICBbPGMwMzEwOTAwPl0gPyBwZXJmX3BtdV91bnJlZ2lzdGVyKzB4MjQwLzB4MjQwClsgICAx
NC41NDMwNzBdICBbPGMwMzEwZWU4Pl0gcGVyZl9ldmVudF9hbGxvYysweDNhOC8weDY2MApb
ICAgMTQuNTQzMDcwXSAgWzxjMDMxMWE1ZD5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg0M2Qv
MHhmMDAKWyAgIDE0LjU0MzA3MF0gIFs8YzAyYTJhZDk+XSA/IGdldF9wYXJlbnRfaXArMHgx
OS8weGEwClsgICAxNC41NDMwNzBdICBbPGMxYTc4ZjVjPl0gc3lzZW50ZXJfZG9fY2FsbCsw
eDEyLzB4MzMKWyAgIDE0LjU0MzA3MF0gQ29kZTogNTMgODMgMDUgODAgOTcgY2QgYzIgMDEg
ODMgMTUgODQgOTcgY2QgYzIgMDAgODMgMDUgMjggOTggY2QgYzIgMDEgODMgMTUgMmMgOTgg
Y2QgYzIgMDAgODMgMDUgMzAgOTggY2QgYzIgMDEgODMgMTUgMzQgOTggY2QgYzIgMDAgPGZm
PiAwNCBiNSAyMCA2OCBjZCBjMiA4MyAwNSAzOCA5OCBjZCBjMiAwMSBjNyA4MyBhMCAwMiAw
MCAwMCAyMCAKWyAgIDE0LjU0MzA3MF0gRUlQOiBbPGMwMzA5MWM5Pl0gcGVyZl9zd2V2ZW50
X2luaXQrMHhlOS8weDFhMCBTUzpFU1AgMDA2ODpjZTkyZmVjYwpbICAgMTQuNTQzMDcwXSBD
UjI6IDAwMDAwMDAwMTY0MTg1MDgKWyAgIDE0LjU5MDAxM10gLS0tWyBlbmQgdHJhY2UgN2U2
NDZkZGRhMmQ5OGU5OCBdLS0tClsgICAxNC41OTE3MzRdIGNhaWY6Y2FpZl9kaXNjb25uZWN0
X2NsaWVudCgpOiBub3RoaW5nIHRvIGRpc2Nvbm5lY3QKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctc3QwLTAzMTUwMDI0L2MxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3
ZTcvZG1lc2ctcXVhbnRhbC1jYWlyby00MjoyMDE0MDMxNjAwNTMxNzppMzg2LXJhbmRjb25m
aWctc3QwLTAzMTUwMDI0OjMuMy4wOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4zCmdpdCBjaGVja291dCB2My4yCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
L25leHQ6bWFzdGVyOjgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTA6
YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0wMDo1MzozNSA4MDVhNmFmOGRiYTVkZmRkMzVl
YzM1ZGM1MmVjMDEyMjQwMGIyNjEwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQt
ODA1YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMApDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC84MDVhNmFmOGRi
YTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0LTgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0LTgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAw
YjI2MTAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvODA1
YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMC92bWxpbnV6LTMuMi4wCgoy
MDE0LTAzLTE2LTAxOjE3OjM1IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4g
VEVTVCBGQUlMVVJFClsgICAgOS4wODQzNDRdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5
IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgMTUuMjg2MjM4XSBsaWJmY29lX2Rl
dmljZV9ub3RpZmljYXRpb246IE5FVERFVl9VTlJFR0lTVEVSIGdwcnMwClsgICAxNS4zMDE0
ODFdIGxpYmZjb2VfZGV2aWNlX25vdGlmaWNhdGlvbjogTkVUREVWX1VOUkVHSVNURVIgZ3By
czAKWyAgIDE4LjQ0NTg3OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcg
cmVxdWVzdCBhdCA4MmI2Y2JhMApbICAgMTguNDQ2MDQ2XSBJUDogWzxjMDJmYzc2OT5dIHBl
cmZfc3dldmVudF9pbml0KzB4ZTkvMHgxYTAKWyAgIDE4LjQ0NjA0Nl0gKnBkcHQgPSAwMDAw
MDAwMDBlOGZkMDAxICpwZGUgPSAwMDAwMDAwMDAwMDAwMDAwIApbICAgMTguNDQ2MDQ2XSBP
b3BzOiAwMDAyIFsjMV0gUFJFRU1QVCAKWyAgIDE4LjQ0NjA0Nl0gClsgICAxOC40NDYwNDZd
IFBpZDogMzg2LCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy4yLjAgIzEgQm9j
aHMgQm9jaHMKWyAgIDE4LjQ0NjA0Nl0gRUlQOiAwMDYwOls8YzAyZmM3Njk+XSBFRkxBR1M6
IDAwMDEwMjQ2IENQVTogMApbICAgMTguNDQ2MDQ2XSBFSVAgaXMgYXQgcGVyZl9zd2V2ZW50
X2luaXQrMHhlOS8weDFhMApbICAgMTguNDQ2MDQ2XSBFQVg6IDAwMDAwMDAwIEVCWDogYzg5
ZTE4MDAgRUNYOiAwMDAwMDAwMSBFRFg6IDAwMDAwMDAwClsgICAxOC40NDYwNDZdIEVTSTog
YjAwMDAwMDAgRURJOiAwMDAwMDAwMCBFQlA6IGNlOWZmZWQ0IEVTUDogY2U5ZmZlY2MKWyAg
IDE4LjQ0NjA0Nl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDMzIFNTOiAw
MDY4ClsgICAxOC40NDYwNDZdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDM4NiwgdGk9
Y2U5ZmUwMDAgdGFzaz1jZWEzMDFiMCB0YXNrLnRpPWNlOWZlMDAwKQpbICAgMTguNDQ2MDQ2
XSBTdGFjazoKWyAgIDE4LjQ0NjA0Nl0gIGMyMzE0NmUwIGM4OWUxODAwIGNlOWZmZWZjIGMw
MzAzZjk5IDAwMDAwMDAyIDAwMDAwMDAxIDAwMDAwMDAwIGMwMzAzZGEwClsgICAxOC40NDYw
NDZdICBjMjMxNDZlMCAwMDAwMDAwMCBjODllMTkyOCBjODllMTgwMCBjZTlmZmYxOCBjMDMw
NDM1OCBjZTlmZmY1OCBjODllMTgwMApbICAgMTguNDQ2MDQ2XSAgMDAwMDAwMDAgY2VhMzAx
YjAgMDAwMDAwMDAgY2U5ZmZmYWMgYzAzMDUwZmQgYzg5ZTE4MDAgMDAwMDAwMDAgMDAwMDAw
MDAKWyAgIDE4LjQ0NjA0Nl0gQ2FsbCBUcmFjZToKWyAgIDE4LjQ0NjA0Nl0gIFs8YzAzMDNm
OTk+XSBwZXJmX2luaXRfZXZlbnQrMHgxZjkvMHgyNDAKWyAgIDE4LjQ0NjA0Nl0gIFs8YzAz
MDNkYTA+XSA/IHBlcmZfcG11X3VucmVnaXN0ZXIrMHgyNDAvMHgyNDAKWyAgIDE4LjQ0NjA0
Nl0gIFs8YzAzMDQzNTg+XSBwZXJmX2V2ZW50X2FsbG9jKzB4Mzc4LzB4ODYwClsgICAxOC40
NDYwNDZdICBbPGMwMzA1MGZkPl0gc3lzX3BlcmZfZXZlbnRfb3BlbisweDQzZC8weGYwMApb
ICAgMTguNDQ2MDQ2XSAgWzxjMTk4YjViYz5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDMz
ClsgICAxOC40NDYwNDZdIENvZGU6IDUzIDgzIDA1IDQwIGZjIGI2IGMyIDAxIDgzIDE1IDQ0
IGZjIGI2IGMyIDAwIDgzIDA1IGU4IGZjIGI2IGMyIDAxIDgzIDE1IGVjIGZjIGI2IGMyIDAw
IDgzIDA1IGYwIGZjIGI2IGMyIDAxIDgzIDE1IGY0IGZjIGI2IGMyIDAwIDxmZj4gMDQgYjUg
YTAgY2IgYjYgYzIgODMgMDUgZjggZmMgYjYgYzIgMDEgYzcgODMgOTggMDIgMDAgMDAgYzAg
ClsgICAxOC40NDYwNDZdIEVJUDogWzxjMDJmYzc2OT5dIHBlcmZfc3dldmVudF9pbml0KzB4
ZTkvMHgxYTAgU1M6RVNQIDAwNjg6Y2U5ZmZlY2MKWyAgIDE4LjQ0NjA0Nl0gQ1IyOiAwMDAw
MDAwMDgyYjZjYmEwClsgICAxOC40ODMyODNdIC0tLVsgZW5kIHRyYWNlIGQwM2NhZGJiNTA3
MjUwZmYgXS0tLQpbICAgMTguNDg0OTg2XSBjYWlmOmNhaWZfZGlzY29ubmVjdF9jbGllbnQo
KTogbm90aGluZyB0byBkaXNjb25uZWN0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC84MDVhNmFmOGRiYTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwL2RtZXNn
LXF1YW50YWwtaW5uLTk6MjAxNDAzMTYwMTIzNDM6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNDo6CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBj
b21taXQgdjMuMgpnaXQgY2hlY2tvdXQgdjMuMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9uZXh0Om1hc3RlcjpjM2I5
MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2OmJpc2VjdC1saW51eDgKCjIw
MTQtMDMtMTYtMDE6MjU6MTUgYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1
Y2M5NiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LWMzYjkyYzg3ODczNjdhOGJi
NTNkNTdkOTc4OWI1NThmMTI5NWNjOTYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5
YjU1OGYxMjk1Y2M5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC1jM2I5MmM4Nzg3MzY3
YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC1jM2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2MzYjkyYzg3ODczNjdhOGJiNTNk
NTdkOTc4OWI1NThmMTI5NWNjOTYvdm1saW51ei0zLjEuMAoKMjAxNC0wMy0xNi0wMjowMjox
NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkxLi4JMgkzIFRFU1QgRkFJTFVSRQpbICAg
IDcuNzMzNTA1XSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dn
aW5nIGZvciBqb2IKWyAgICA3Ljc1MDM2M10gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkg
LSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iClsgICAgNy43NTU4MjhdIGluaXQ6IEZhaWxl
ZCB0byBjcmVhdGUgcHR5IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgMTQuOTQz
NTY2XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDYy
YjU0ZWZjClsgICAxNC45NDQwNTFdIElQOiBbPGMwMmZjZmM5Pl0gcGVyZl9zd2V2ZW50X2lu
aXQrMHhlOS8weDFhMApbICAgMTQuOTQ0MDUxXSAqcGRwdCA9IDAwMDAwMDAwMGU5YTQwMDEg
KnBkZSA9IDAwMDAwMDAwMDAwMDAwMDAgClsgICAxNC45NDQwNTFdIE9vcHM6IDAwMDIgWyMx
XSBQUkVFTVBUIApbICAgMTQuOTQ0MDUxXSAKWyAgIDE0Ljk0NDA1MV0gUGlkOiAzODMsIGNv
bW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjEuMCAjMSBCb2NocyBCb2NocwpbICAg
MTQuOTQ0MDUxXSBFSVA6IDAwNjA6WzxjMDJmY2ZjOT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BV
OiAwClsgICAxNC45NDQwNTFdIEVJUCBpcyBhdCBwZXJmX3N3ZXZlbnRfaW5pdCsweGU5LzB4
MWEwClsgICAxNC45NDQwNTFdIEVBWDogMDAwMDAwMDAgRUJYOiBjZTliYjgwMCBFQ1g6IDAw
MDAwMDAxIEVEWDogMDAwMDAwMDAKWyAgIDE0Ljk0NDA1MV0gRVNJOiBlODAwMWZmZiBFREk6
IDAwMDAwMDAwIEVCUDogY2Q5YzdlZDQgRVNQOiBjZDljN2VjYwpbICAgMTQuOTQ0MDUxXSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAwNjgKWyAgIDE0Ljk0
NDA1MV0gUHJvY2VzcyB0cmluaXR5LW1haW4gKHBpZDogMzgzLCB0aT1jZDljNjAwMCB0YXNr
PWNlYjhjMTMwIHRhc2sudGk9Y2Q5YzYwMDApClsgICAxNC45NDQwNTFdIFN0YWNrOgpbICAg
MTQuOTQ0MDUxXSAgYzIyZGRjZTAgY2U5YmI4MDAgY2Q5YzdlZmMgYzAzMDQ2YWUgMDAwMDAw
MDIgMDAwMDAwMDEgMDAwMDAwMDAgYzAzMDQ0YzAKWyAgIDE0Ljk0NDA1MV0gIGMyMmRkY2Uw
IDAwMDAwMDAwIGNlOWJiOTI4IGNlOWJiODAwIGNkOWM3ZjE4IGMwMzA0YTY4IGNkOWM3ZjU4
IGNlOWJiODAwClsgICAxNC45NDQwNTFdICAwMDAwMDAwMCBjZWI4YzEzMCAwMDAwMDAwMCBj
ZDljN2ZhYyBjMDMwNTdmZCBjZTliYjgwMCAwMDAwMDAwMCAwMDAwMDAwMApbICAgMTQuOTQ0
MDUxXSBDYWxsIFRyYWNlOgpbICAgMTQuOTQ0MDUxXSAgWzxjMDMwNDZhZT5dIHBlcmZfaW5p
dF9ldmVudCsweDFlZS8weDI0MApbICAgMTQuOTQ0MDUxXSAgWzxjMDMwNDRjMD5dID8gcGVy
Zl9wbXVfdW5yZWdpc3RlcisweDI0MC8weDI0MApbICAgMTQuOTQ0MDUxXSAgWzxjMDMwNGE2
OD5dIHBlcmZfZXZlbnRfYWxsb2MrMHgzNjgvMHg4NDAKWyAgIDE0Ljk0NDA1MV0gIFs8YzAz
MDU3ZmQ+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4NDNkLzB4ZjAwClsgICAxNC45NDQwNTFd
ICBbPGMxOTVjZWRjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzMKWyAgIDE0Ljk0NDA1
MV0gQ29kZTogNTMgODMgMDUgODAgZmUgYjQgYzIgMDEgODMgMTUgODQgZmUgYjQgYzIgMDAg
ODMgMDUgMjggZmYgYjQgYzIgMDEgODMgMTUgMmMgZmYgYjQgYzIgMDAgODMgMDUgMzAgZmYg
YjQgYzIgMDEgODMgMTUgMzQgZmYgYjQgYzIgMDAgPGZmPiAwNCBiNSAwMCBjZiBiNCBjMiA4
MyAwNSAzOCBmZiBiNCBjMiAwMSBjNyA4MyA4YyAwMiAwMCAwMCAyMCAKWyAgIDE0Ljk0NDA1
MV0gRUlQOiBbPGMwMmZjZmM5Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHhlOS8weDFhMCBTUzpF
U1AgMDA2ODpjZDljN2VjYwpbICAgMTQuOTQ0MDUxXSBDUjI6IDAwMDAwMDAwNjJiNTRlZmMK
WyAgIDE0Ljk3ODE1OV0gLS0tWyBlbmQgdHJhY2UgNWQwMDZlNjkyZWIxZTAwOSBdLS0tClsg
ICAxNC45ODMxNzVdIGNhaWY6Y2FpZl9kaXNjb25uZWN0X2NsaWVudCgpOiBub3RoaW5nIHRv
IGRpc2Nvbm5lY3QKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2MzYjky
Yzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5NWNjOTYvZG1lc2ctcXVhbnRhbC1jYWly
by0zNDoyMDE0MDMxNjAyMDUxMTppMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0OjMuMS4w
OjEKMzoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMTYg
MDI6MDc6MTkgUkVQRUFUIENPVU5UOiA1MCAgIyAva2VybmVsLXRlc3RzL2xpbnV4OC9vYmot
YmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMQpnaXQgY2hlY2tv
dXQgdjMuMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzE1MDAyNC9uZXh0Om1hc3RlcjowMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0
ZjJkMDIwMzA2MDM1ZGJlOmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDI6MDc6MzEgMDJm
OGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctc3QwLTAzMTUwMDI0LTAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVk
YmUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLXN0MC0wMzE1MDAyNC0wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2
MDM1ZGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC0wMmY4YzZhZWU4ZGYzY2RjOTM1
ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LzAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmUv
dm1saW51ei0zLjAuMAoKMjAxNC0wMy0xNi0wMjozNDozMiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uLi4uLi4uLi4uLgkxIFRFU1QgRkFJTFVSRQpbICAgIDUuNDA1Nzk1XSBpbml0OiBG
YWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA1
LjQxMTIzNl0gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2lu
ZyBmb3Igam9iClsgICAgNS40MTc0NzldIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0g
ZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgMTUuMTA4MjgyXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDRhYTVlNTVjClsgICAxNS4xMDkw
NjldIElQOiBbPGMwMmZhOGU5Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHhlOS8weDFhMApbICAg
MTUuMTA5MDY5XSAqcGRwdCA9IDAwMDAwMDAwMDhhMjQwMDEgKnBkZSA9IDAwMDAwMDAwMDAw
MDAwMDAgClsgICAxNS4xMDkwNjldIE9vcHM6IDAwMDIgWyMxXSBQUkVFTVBUIApbICAgMTUu
MTA5MDY5XSAKWyAgIDE1LjEwOTA2OV0gUGlkOiAzNzcsIGNvbW06IHRyaW5pdHktbWFpbiBO
b3QgdGFpbnRlZCAzLjAuMCAjMSBCb2NocyBCb2NocwpbICAgMTUuMTA5MDY5XSBFSVA6IDAw
NjA6WzxjMDJmYThlOT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAxNS4xMDkwNjld
IEVJUCBpcyBhdCBwZXJmX3N3ZXZlbnRfaW5pdCsweGU5LzB4MWEwClsgICAxNS4xMDkwNjld
IEVBWDogMDAwMDAwMDAgRUJYOiBjZWEyNTAwMCBFQ1g6IDAwMDAwMDAxIEVEWDogMDAwMDAw
MDAKWyAgIDE1LjEwOTA2OV0gRVNJOiBhMjAwZmZmZiBFREk6IDAwMDAwMDAwIEVCUDogYzg4
NDVlZDQgRVNQOiBjODg0NWVjYwpbICAgMTUuMTA5MDY5XSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAwNjgKWyAgIDE1LjEwOTA2OV0gUHJvY2VzcyB0cmlu
aXR5LW1haW4gKHBpZDogMzc3LCB0aT1jODg0NDAwMCB0YXNrPWNlYjc1MzgwIHRhc2sudGk9
Yzg4NDQwMDApClsgICAxNS4xMDkwNjldIFN0YWNrOgpbICAgMTUuMTA5MDY5XSAgYzIxY2Q1
NDAgY2VhMjUwMDAgYzg4NDVlZmMgYzAzMDJiOGUgMDAwMDAwMDIgMDAwMDAwMDEgMDAwMDAw
MDAgYzAzMDI5YTAKWyAgIDE1LjEwOTA2OV0gIGMyMWNkNTQwIDAwMDAwMDAwIGNlYTI1MTI4
IGNlYTI1MDAwIGM4ODQ1ZjE4IGMwMzAyZjQwIGM4ODQ1ZjU4IGNlYTI1MDAwClsgICAxNS4x
MDkwNjldICAwMDAwMDAwMCBjZWI3NTM4MCAwMDAwMDAwMCBjODg0NWZhYyBjMDMwM2NhZCBj
ZWEyNTAwMCAwMDAwMDAwMCAwMDAwMDAwMApbICAgMTUuMTA5MDY5XSBDYWxsIFRyYWNlOgpb
ICAgMTUuMTA5MDY5XSAgWzxjMDMwMmI4ZT5dIHBlcmZfaW5pdF9ldmVudCsweDFlZS8weDI0
MApbICAgMTUuMTA5MDY5XSAgWzxjMDMwMjlhMD5dID8gcGVyZl9wbXVfdW5yZWdpc3Rlcisw
eDI0MC8weDI0MApbICAgMTUuMTA5MDY5XSAgWzxjMDMwMmY0MD5dIHBlcmZfZXZlbnRfYWxs
b2MrMHgzNjAvMHg4MjAKWyAgIDE1LjEwOTA2OV0gIFs8YzAzMDNjYWQ+XSBzeXNfcGVyZl9l
dmVudF9vcGVuKzB4NDRkLzB4ZjAwClsgICAxNS4xMDkwNjldICBbPGMwMzAzZWQ4Pl0gPyBz
eXNfcGVyZl9ldmVudF9vcGVuKzB4Njc4LzB4ZjAwClsgICAxNS4xMDkwNjldICBbPGMxODhh
NGRjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzMKWyAgIDE1LjEwOTA2OV0gQ29kZTog
NTMgODMgMDUgMDAgMTggYTIgYzIgMDEgODMgMTUgMDQgMTggYTIgYzIgMDAgODMgMDUgYTgg
MTggYTIgYzIgMDEgODMgMTUgYWMgMTggYTIgYzIgMDAgODMgMDUgYjAgMTggYTIgYzIgMDEg
ODMgMTUgYjQgMTggYTIgYzIgMDAgPGZmPiAwNCBiNSA2MCBlNSBhMSBjMiA4MyAwNSBiOCAx
OCBhMiBjMiAwMSBjNyA4MyA4YyAwMiAwMCAwMCA0MCAKWyAgIDE1LjEwOTA2OV0gRUlQOiBb
PGMwMmZhOGU5Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHhlOS8weDFhMCBTUzpFU1AgMDA2ODpj
ODg0NWVjYwpbICAgMTUuMTA5MDY5XSBDUjI6IDAwMDAwMDAwNGFhNWU1NWMKWyAgIDE1LjE0
NjE0Ml0gLS0tWyBlbmQgdHJhY2UgMGRhMTE0MDI5ODc2M2I1OSBdLS0tClsgICAxNS4xNTIy
MThdIGNhaWY6Y2FpZl9kaXNjb25uZWN0X2NsaWVudCgpOiBub3RoaW5nIHRvIGRpc2Nvbm5l
Y3QKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzAyZjhjNmFlZThkZjNj
ZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmUvZG1lc2ctcXVhbnRhbC14aWFuLTEwOjIwMTQw
MzE2MDI0MTM3OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4wLjA6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRk
NGYyZDAyMDMwNjAzNWRiZS9kbWVzZy15b2N0by14aWFuLTIyOjIwMTQwMzE2MDI0MTM3Omkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQ6My4wLjA6MQoxOjI6MiBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjAKZ2l0IGNoZWNrb3V0IHYy
LjYuMzkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1zdDAtMDMxNTAwMjQvbmV4dDptYXN0ZXI6NjFjNGYyYzgxYzYxZjczNTQ5OTI4ZGZkOWYz
ZThmMjZhYTM2YThjZjpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTAyOjQyOjEwIDYxYzRm
MmM4MWM2MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC02MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNm
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0LzYxYzRmMmM4MWM2MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1zdDAtMDMxNTAwMjQtNjFjNGYyYzgxYzYxZjczNTQ5OTI4ZGZkOWYzZThmMjZhYTM2
YThjZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtNjFjNGYyYzgxYzYxZjczNTQ5OTI4
ZGZkOWYzZThmMjZhYTM2YThjZgpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMt
MTYtMDI6NTc6MTEgNjFjNGYyYzgxYzYxZjczNTQ5OTI4ZGZkOWYzZThmMjZhYTM2YThjZiBT
S0lQIEJST0tFTiBCVUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LzYxYzRmMmM4MWM2MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YK
YmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zOQpnaXQgY2hlY2tvdXQgdjIu
Ni4zOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC9uZXh0Om1hc3Rlcjo1MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1
NzU4MTNkNTlhNDNkOmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDI6NTc6MTUgNTIxY2I0
MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZCBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LTUyMWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2QK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQvNTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzE1MDAyNC01MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlh
NDNkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8uaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC01MjFjYjQwYjBjNDQ0MThhNGZkMzZk
YzYzM2Y1NzU4MTNkNTlhNDNkCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0x
Ni0wMzoxMToxNiA1MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkIFNL
SVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQvNTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZApi
aXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM4CmdpdCBjaGVja291dCB2Mi42
LjM3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0L25leHQ6bWFzdGVyOjNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdj
OTA0YWE2NGY2ZDU6YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0wMzoxMToxOSAzYzBlZWUz
ZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1IGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQtM2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3YzdlN2M5MDRhYTY0ZjZkNQpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC8zYzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctc3QwLTAzMTUwMDI0LTNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2
ZDUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0
N2M3ZTdjOTA0YWE2NGY2ZDUKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2
LTAzOjI5OjE5IDNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2ZDUgU0tJ
UCBCUk9LRU4gQlVJTEQKTm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC8zYzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1CmJp
c2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzcKZ2l0IGNoZWNrb3V0IHYyLjYu
MzYKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQvbmV4dDptYXN0ZXI6ZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4
NWE2MGQ4MTU3ZjpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTAzOjI5OjI0IGY2Zjk0ZTJh
YjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC1mNmY5NGUyYWIxYjMzZjAwODJhYzIyZDcxZjY2Mzg1YTYwZDgxNTdmCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
L2Y2Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1zdDAtMDMxNTAwMjQtZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4NWE2MGQ4MTU3
Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
LmkzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3
MWY2NjM4NWE2MGQ4MTU3ZgpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYt
MDQ6MDg6MjQgZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4NWE2MGQ4MTU3ZiBTS0lQ
IEJST0tFTiBCVUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0L2Y2Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YKYmlz
ZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zNgpnaXQgY2hlY2tvdXQgdjIuNi4z
NQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC9uZXh0Om1hc3Rlcjo5ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkx
ZDUzMGU4ZDUxOmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDQ6MDg6MjcgOWZlNjIwNmY0
MDA2NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LTlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTEKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQv
OWZlNjIwNmY0MDA2NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC05ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkxZDUzMGU4ZDUx
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC05ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2
YzU5ODkxZDUzMGU4ZDUxCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0w
NToxMjoyNyA5ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkxZDUzMGU4ZDUxIFNLSVAg
QlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQvOWZlNjIwNmY0MDA2NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MQpiaXNl
Y3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM1CmdpdCBjaGVja291dCB2Mi42LjM0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0L25leHQ6bWFzdGVyOmU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUz
ZmFhMzdhODY6YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0wNToxMjozMSBlNDAxNTJlZTFl
MWM3YTYzZjQ3Nzc3OTE4NjMyMTVlM2ZhYTM3YTg2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQtZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4NgpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9l
NDAxNTJlZTFlMWM3YTYzZjQ3Nzc3OTE4NjMyMTVlM2ZhYTM3YTg2CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LWU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5p
Mzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LWU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2
MzIxNWUzZmFhMzdhODYKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTA3
OjM1OjM2IGU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYgU0tJUCBC
Uk9LRU4gQlVJTEQKTm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC9lNDAxNTJlZTFlMWM3YTYzZjQ3Nzc3OTE4NjMyMTVlM2ZhYTM3YTg2CmJpc2Vj
dDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzQKZ2l0IGNoZWNrb3V0IHYyLjYuMzMK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQvbmV4dDptYXN0ZXI6NjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFi
M2M2YTRhZDpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTA3OjM1OjM5IDYwYjM0MWI3Nzhj
YzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC02MGIzNDFiNzc4Y2MyOTI5ZGYxNmMwYTUwNGM5MTYyMWIzYzZhNGFkCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzYw
YjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMxNTAwMjQtNjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFiM2M2YTRhZAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtNjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRj
OTE2MjFiM2M2YTRhZApzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYtMDg6
MjI6MzkgNjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFiM2M2YTRhZCBTS0lQIEJS
T0tFTiBCVUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0LzYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQKYmlzZWN0
OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMwpnaXQgY2hlY2tvdXQgdjIuNi4zMgps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC9uZXh0Om1hc3RlcjoyMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQzNGQ5MzUz
MDhjOGQ3OmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDg6MjI6NDMgMjI3NjNjNWNmMzY5
MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0LTIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDcKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvMjI3
NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNwp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzE1MDAyNC0yMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQzNGQ5MzUzMDhjOGQ3Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC0yMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQz
NGQ5MzUzMDhjOGQ3CnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0wODo1
Mjo0MyAyMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQzNGQ5MzUzMDhjOGQ3IFNLSVAgQlJP
S0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQvMjI3NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNwpiaXNlY3Q6
IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjMyCmdpdCBjaGVja291dCB2Mi42LjMxCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0L25leHQ6bWFzdGVyOjc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1
MGY2NTc6YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0wODo1Mjo0OSA3NGZjYTZhNDI4NjNm
ZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQtNzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2YTlmMjI4OTUwZjY1NwpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC83NGZj
YTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3Qw
LTAzMTUwMDI0LTc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTcKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2
LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5
ZjIyODk1MGY2NTcKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTA5OjE4
OjQ5IDc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTcgU0tJUCBCUk9L
RU4gQlVJTEQKTm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC83NGZjYTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3CmJpc2VjdDog
c2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzEKZ2l0IGNoZWNrb3V0IHYyLjYuMzAKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQvbmV4dDptYXN0ZXI6MDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVkZTVjMDI2
NDhjNjpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTA5OjE4OjUyIDA3YTIwMzliOGViMGFm
NGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC0wN2EyMDM5YjhlYjBhZjRmZjQ2NGVmZDNkZmQ5NWRlNWMwMjY0OGM2CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzA3YTIw
MzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMxNTAwMjQtMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVkZTVjMDI2NDhjNgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVk
ZTVjMDI2NDhjNgpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYtMDk6MzE6
NTIgMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVkZTVjMDI2NDhjNiBTS0lQIEJST0tF
TiBCVUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0LzA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMApnaXQgY2hlY2tvdXQgdjIuNi4yOQpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC9uZXh0Om1hc3Rlcjo4ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVj
ZDg0OmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMDk6MzE6NTUgOGUwZWU0M2JjMmMzZTE5
ZGI1NmE0YWRhYTlhOWIwNGNlODg1Y2Q4NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0LThlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvOGUwZWU0
M2JjMmMzZTE5ZGI1NmE0YWRhYTlhOWIwNGNlODg1Y2Q4NAp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzE1MDAyNC04ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzE1MDAyNC04ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0
Y2U4ODVjZDg0CnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0xMToxNDo1
NiA4ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0IFNLSVAgQlJPS0VO
IEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQvOGUwZWU0M2JjMmMzZTE5ZGI1NmE0YWRhYTlhOWIwNGNlODg1Y2Q4NApiaXNlY3Q6IHNr
aXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjI5CmdpdCBjaGVja291dCB2Mi42LjI4CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0L25leHQ6bWFzdGVyOjRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFk
OTE6YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0xMToxNTowMCA0YTY5MDhhM2EwNTBhYWNj
OWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQtNGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3NmI0NmMwNjI5YWQ5MQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC80YTY5MDhh
M2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAz
MTUwMDI0LTRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJh
bmRjb25maWctc3QwLTAzMTUwMDI0LTRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZj
MDYyOWFkOTEKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTEzOjA3OjAx
IDRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEgU0tJUCBCUk9LRU4g
QlVJTEQKTm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC80YTY5MDhhM2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxCmJpc2VjdDogc2tp
cCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjgKZ2l0IGNoZWNrb3V0IHYyLjYuMjcKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQvbmV4dDptYXN0ZXI6M2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJhYzFl
NTpiaXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTEzOjA3OjA0IDNmYTg3NDllNTg0YjU1ZjEx
ODA0MTFhYjFiNTExMTcxOTBiYWMxZTUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC0zZmE4NzQ5ZTU4NGI1NWYxMTgwNDExYWIxYjUxMTE3MTkwYmFjMWU1CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzNmYTg3NDll
NTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMx
NTAwMjQtM2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJhYzFlNQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMxNTAwMjQtM2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5
MGJhYzFlNQpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYtMTM6MzQ6MDUg
M2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJhYzFlNSBTS0lQIEJST0tFTiBC
VUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LzNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUKYmlzZWN0OiBza2lw
IGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNwpnaXQgY2hlY2tvdXQgdjIuNi4yNgpscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC9uZXh0Om1hc3RlcjpiY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1
OmJpc2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMTM6MzQ6MDggYmNlN2Y3OTNkYWVjM2U2NWVj
NWM1NzA1ZDI0NTdiODFmZTdiNTcyNSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LWJjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3YjgxZmU3YjU3MjUKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvYmNlN2Y3OTNk
YWVjM2U2NWVjNWM1NzA1ZDI0NTdiODFmZTdiNTcyNQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1
MDAyNC1iY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5k
Y29uZmlnLXN0MC0wMzE1MDAyNC1iY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZl
N2I1NzI1CnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0xNDowMjowOSBi
Y2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1IFNLSVAgQlJPS0VOIEJV
SUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQv
YmNlN2Y3OTNkYWVjM2U2NWVjNWM1NzA1ZDI0NTdiODFmZTdiNTcyNQpiaXNlY3Q6IHNraXAg
YnJva2VuIGJ1aWxkIGZvciB2Mi42LjI2CmdpdCBjaGVja291dCB2Mi42LjI1CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
L25leHQ6bWFzdGVyOjRiMTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGY6
YmlzZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0xNDowMjoxMyA0YjExOWUyMWQwYzY2YzIyZThj
YTAzZGYwNWQ5ZGU2MjNkMGViNTBmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQt
NGIxMTllMjFkMGM2NmMyMmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZgpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC80YjExOWUyMWQw
YzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGViNTBmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUw
MDI0LTRiMTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGYKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRj
b25maWctc3QwLTAzMTUwMDI0LTRiMTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2Qw
ZWI1MGYKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTE0OjQ4OjE0IDRi
MTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGYgU0tJUCBCUk9LRU4gQlVJ
TEQKTm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC80
YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGViNTBmCmJpc2VjdDogc2tpcCBi
cm9rZW4gYnVpbGQgZm9yIHYyLjYuMjUKZ2l0IGNoZWNrb3V0IHYyLjYuMjQKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQv
bmV4dDptYXN0ZXI6NDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhODpi
aXNlY3QtbGludXg4CgoyMDE0LTAzLTE2LTE0OjQ4OjE3IDQ5OTE0MDg0ZTc5NzUzMGQ5YmFh
ZjUxZGY5ZWRhNzdiYWJjOThmYTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC00
OTkxNDA4NGU3OTc1MzBkOWJhYWY1MWRmOWVkYTc3YmFiYzk4ZmE4CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzQ5OTE0MDg0ZTc5
NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAw
MjQtNDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNv
bmZpZy1zdDAtMDMxNTAwMjQtNDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5
OGZhOApzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYtMTU6Mjc6MTggNDk5
MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOCBTS0lQIEJST0tFTiBCVUlM
RApObyBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LzQ5
OTE0MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTgKYmlzZWN0OiBza2lwIGJy
b2tlbiBidWlsZCBmb3IgdjIuNi4yNApnaXQgY2hlY2tvdXQgdjIuNi4yMwpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9u
ZXh0Om1hc3RlcjpiYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxOmJp
c2VjdC1saW51eDgKCjIwMTQtMDMtMTYtMTU6Mjc6MjEgYmJmMjUwMTBmMWE2Yjc2MTkxNDQz
MGY1ZmNhMDgxZWM4YzdhY2NkMSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LWJi
ZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZjYTA4MWVjOGM3YWNjZDEKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvYmJmMjUwMTBmMWE2
Yjc2MTkxNDQzMGY1ZmNhMDgxZWM4YzdhY2NkMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAy
NC1iYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzE1MDAyNC1iYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2Fj
Y2QxCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0xNzoxMjoyMSBiYmYy
NTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxIFNLSVAgQlJPS0VOIEJVSUxE
Ck5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvYmJm
MjUwMTBmMWE2Yjc2MTkxNDQzMGY1ZmNhMDgxZWM4YzdhY2NkMQpiaXNlY3Q6IHNraXAgYnJv
a2VuIGJ1aWxkIGZvciB2Mi42LjIzCmdpdCBjaGVja291dCB2Mi42LjIyCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L25l
eHQ6bWFzdGVyOjdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWM6Ymlz
ZWN0LWxpbnV4OAoKMjAxNC0wMy0xNi0xNzoxMjoyNSA3ZGNjYTMwYTMyYWFkYjA1MjA0MTc1
MjFiMGM0NGY0MmQwOWZlMDVjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtN2Rj
Y2EzMGEzMmFhZGIwNTIwNDE3NTIxYjBjNDRmNDJkMDlmZTA1YwpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC83ZGNjYTMwYTMyYWFk
YjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0
LTdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25m
aWctc3QwLTAzMTUwMDI0LTdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUw
NWMKc3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTE3OjM5OjI1IDdkY2Nh
MzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWMgU0tJUCBCUk9LRU4gQlVJTEQK
Tm8ga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC83ZGNj
YTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjCmJpc2VjdDogc2tpcCBicm9r
ZW4gYnVpbGQgZm9yIHYyLjYuMjIKZ2l0IGNoZWNrb3V0IHYyLjYuMjEKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvbmV4
dDptYXN0ZXI6ZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMTpiaXNl
Y3QtbGludXg4CgoyMDE0LTAzLTE2LTE3OjM5OjI4IGRlNDZjMzM3NDVmNWUyYWQ1OTRjNzJm
MmNmNWY0OTA4NjFiMTZjZTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC1kZTQ2
YzMzNzQ1ZjVlMmFkNTk0YzcyZjJjZjVmNDkwODYxYjE2Y2UxCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2RlNDZjMzM3NDVmNWUy
YWQ1OTRjNzJmMmNmNWY0OTA4NjFiMTZjZTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQt
ZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZp
Zy1zdDAtMDMxNTAwMjQtZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNl
MQpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMTYtMTg6MTk6MjggZGU0NmMz
Mzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMSBTS0lQIEJST0tFTiBCVUlMRApO
byBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L2RlNDZj
MzM3NDVmNWUyYWQ1OTRjNzJmMmNmNWY0OTA4NjFiMTZjZTEKYmlzZWN0OiBza2lwIGJyb2tl
biBidWlsZCBmb3IgdjIuNi4yMQpnaXQgY2hlY2tvdXQgdjIuNi4yMApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC9uZXh0
Om1hc3Rlcjo2MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2NkOmJpc2Vj
dC1saW51eDgKCjIwMTQtMDMtMTYtMTg6MTk6MzIgNjJkMGNmY2IyN2NmNzU1Y2ViZGM5M2Nh
OTVkYWJjODM2MDgwMDdjZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTYyZDBj
ZmNiMjdjZjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3Y2QKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNjJkMGNmY2IyN2NmNzU1
Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC02
MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2NkCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzE1MDAyNC02MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2Nk
CnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0xNi0xODo0OTozMiA2MmQwY2Zj
YjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2NkIFNLSVAgQlJPS0VOIEJVSUxECk5v
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQvNjJkMGNm
Y2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZApiaXNlY3Q6IHNraXAgYnJva2Vu
IGJ1aWxkIGZvciB2Mi42LjIwCmdpdCBjaGVja291dCB2Mi42LjE5CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0L25leHQ6
bWFzdGVyOjAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQ6YmlzZWN0
LWxpbnV4OAoKMjAxNC0wMy0xNi0xODo0OTozNSAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0
YTk5NDk5YTRkMDZlNzA0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMxNTAwMjQtMDIxNWZm
YjA4Y2U5OWUyYmI1OWVjYTExNGE5OTQ5OWE0ZDA2ZTcwNApDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8wMjE1ZmZiMDhjZTk5ZTJi
YjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctc3QwLTAzMTUwMDI0LTAy
MTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWct
c3QwLTAzMTUwMDI0LTAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQK
c3RhdHVzOiBGQUlMOiBidWlsZCBlcnJvcgoyMDE0LTAzLTE2LTE5OjA4OjM1IDAyMTVmZmIw
OGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQgU0tJUCBCUk9LRU4gQlVJTEQKTm8g
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzE1MDAyNC8wMjE1ZmZi
MDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0CmJpc2VjdDogc2tpcCBicm9rZW4g
YnVpbGQgZm9yIHYyLjYuMTkKG1sxOzM1bTIwMTQtMDMtMTYgMTk6MDg6MzUgQ2Fubm90IGZp
bmQgdGhlIGZpcnN0IGdvb2QgY29tbWl0LhtbMG0KG1sxOzM1bTIwMTQtMDMtMTYgMTk6MDg6
MzUgYmlzZWN0IGZhaWxlZBtbMG0K

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc6-next-20140313-08623-gaf911c6"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc6 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
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
# CONFIG_EMBEDDED is not set
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
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
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
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
CONFIG_MK6=y
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
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
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
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
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
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
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
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

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
CONFIG_INTEL_IDLE=y

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
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
CONFIG_I82092=y
# CONFIG_I82365 is not set
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
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
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_DNAT=y
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
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
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_DMASCC is not set
CONFIG_SCC=y
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_CAN_MCP251X is not set
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCMCIA is not set
CONFIG_CAN_EMS_PCI=y
# CONFIG_CAN_PEAK_PCMCIA is not set
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_TSCAN1=y
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_KVASER_USB=y
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=y
# CONFIG_TEKRAM_DONGLE is not set
CONFIG_TOIM3232_DONGLE=y
# CONFIG_LITELINK_DONGLE is not set
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
# CONFIG_ACT200L_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=y
CONFIG_BT_WILINK=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_WILINK is not set
CONFIG_NFC_MEI_PHY=y
CONFIG_NFC_SIM=y
CONFIG_NFC_PORT100=y
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_MEI=y
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=y
CONFIG_NFC_MRVL_USB=y

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
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
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_ERA=y
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_ALX=y
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0 is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
# CONFIG_QLCNIC is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
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
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=y
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PCMCIA_ATMEL=y
CONFIG_AT76C50X_USB=y
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_ADM8211=y
# CONFIG_MAC80211_HWSIM is not set
CONFIG_MWL8K=y
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
CONFIG_B43LEGACY_DMA_MODE=y
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
# CONFIG_BRCMFMAC is not set
CONFIG_BRCM_TRACING=y
CONFIG_BRCMDBG=y
# CONFIG_HOSTAP is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=y
CONFIG_IWLDVM=y
# CONFIG_IWLMVM is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEBUGFS is not set
CONFIG_IWLEGACY=y
CONFIG_IWL4965=y
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_IWLEGACY_DEBUGFS is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_CS=y
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_SPI=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=y
CONFIG_HERMES_PRISM=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
CONFIG_NORTEL_HERMES=y
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_ORINOCO_USB=y
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
CONFIG_RT2500PCI=y
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
# CONFIG_RT2800PCI_RT3290 is not set
CONFIG_RT2500USB=y
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=y
CONFIG_RT2800USB_RT33XX=y
# CONFIG_RT2800USB_RT35XX is not set
CONFIG_RT2800USB_RT3573=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_RT55XX=y
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=y
CONFIG_RT2800_LIB_MMIO=y
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
CONFIG_RTL_CARDS=y
CONFIG_RTL8192CE=y
CONFIG_RTL8192SE=y
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
CONFIG_RTL8723BE=y
CONFIG_RTL8188EE=y
# CONFIG_RTL8192CU is not set
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_PCI=y
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=y
CONFIG_RTL8723_COMMON=y
CONFIG_RTLBTCOEXIST=y
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
CONFIG_WL12XX=y
# CONFIG_WL18XX is not set
CONFIG_WLCORE=y
# CONFIG_WLCORE_SPI is not set
CONFIG_WLCORE_SDIO=y
CONFIG_WILINK_PLATFORM_DATA=y
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set
CONFIG_CW1200=y
# CONFIG_CW1200_WLAN_SDIO is not set
# CONFIG_CW1200_WLAN_SPI is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_ISDN is not set

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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
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
CONFIG_SERIO_PCIPS2=y
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
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TCG_XEN=y
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
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

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
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

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
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

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
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
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
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y
CONFIG_XEN_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

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
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
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
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PCAP is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
CONFIG_USB_STV06XX=y
CONFIG_USB_GL860=y
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=y
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=y
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=y
CONFIG_USB_GSPCA_JL2005BCD=y
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_NW80X is not set
CONFIG_USB_GSPCA_OV519=y
# CONFIG_USB_GSPCA_OV534 is not set
CONFIG_USB_GSPCA_OV534_9=y
CONFIG_USB_GSPCA_PAC207=y
# CONFIG_USB_GSPCA_PAC7302 is not set
CONFIG_USB_GSPCA_PAC7311=y
# CONFIG_USB_GSPCA_SE401 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=y
CONFIG_USB_GSPCA_SONIXB=y
# CONFIG_USB_GSPCA_SONIXJ is not set
CONFIG_USB_GSPCA_SPCA500=y
CONFIG_USB_GSPCA_SPCA501=y
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
CONFIG_USB_GSPCA_SPCA508=y
CONFIG_USB_GSPCA_SPCA561=y
CONFIG_USB_GSPCA_SPCA1528=y
CONFIG_USB_GSPCA_SQ905=y
# CONFIG_USB_GSPCA_SQ905C is not set
CONFIG_USB_GSPCA_SQ930X=y
CONFIG_USB_GSPCA_STK014=y
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=y
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TOPRO is not set
# CONFIG_USB_GSPCA_TV8532 is not set
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_VICAM=y
CONFIG_USB_GSPCA_XIRLINK_CIT=y
CONFIG_USB_GSPCA_ZC3XX=y
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=y
CONFIG_USB_STKWEBCAM=y
# CONFIG_USB_S2255 is not set
CONFIG_VIDEO_USBTV=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_USBVISION=y
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_AU0828_V4L2=y

#
# Digital TV USB devices
#
# CONFIG_DVB_USB_V2 is not set
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_USB_DRV=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
# CONFIG_VIDEO_EM28XX_V4L2 is not set
# CONFIG_VIDEO_EM28XX_DVB is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
# CONFIG_VIDEO_TIMBERDALE is not set
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_PLATFORM=y
# CONFIG_VIDEO_RCAR_VIN is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_MR800=y
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
CONFIG_USB_MA901=y
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_TIMBERDALE=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
# CONFIG_SOC_CAMERA_IMX074 is not set
CONFIG_SOC_CAMERA_MT9M001=y
CONFIG_SOC_CAMERA_MT9M111=y
CONFIG_SOC_CAMERA_MT9T031=y
# CONFIG_SOC_CAMERA_MT9T112 is not set
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_OV2640=y
CONFIG_SOC_CAMERA_OV5642=y
CONFIG_SOC_CAMERA_OV6650=y
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=y
# CONFIG_SOC_CAMERA_OV9740 is not set
# CONFIG_SOC_CAMERA_RJ54N1 is not set
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STB6000 is not set
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
# CONFIG_DVB_STV0900 is not set
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24117=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=y
# CONFIG_DVB_DIB9000 is not set
# CONFIG_DVB_TDA10048 is not set
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522_DTV is not set
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
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
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=y

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
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
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
CONFIG_I2C_HID=y
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
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_RENESAS_USBHS_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

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
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
# CONFIG_USB_DWC3_PCI is not set
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
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
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
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
CONFIG_USB_S3C_HSOTG=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=y
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
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

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
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82875P is not set
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
# CONFIG_XEN_COMPAT_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_W35UND=y
CONFIG_R8712U=y
CONFIG_R8188EU=y
CONFIG_88EU_AP_MODE=y
# CONFIG_88EU_P2P is not set
# CONFIG_RTS5139 is not set
CONFIG_RTS5208=y
# CONFIG_RTS5208_DEBUG is not set
# CONFIG_TRANZPORT is not set
CONFIG_USB_SERIAL_QUATECH2=y
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=y
CONFIG_ADIS16203=y
CONFIG_ADIS16204=y
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD799X is not set
CONFIG_AD7780=y
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
CONFIG_AD9834=y
CONFIG_AD9850=y
CONFIG_AD9852=y
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_WLAGS49_H2=y
CONFIG_WLAGS49_H25=y
CONFIG_CRYSTALHD=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_DTLK is not set
CONFIG_SPEAKUP_SYNTH_KEYPC=y
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
CONFIG_SPEAKUP_SYNTH_DUMMY=y
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_IPC_32BIT=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
# CONFIG_ION is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=y
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

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
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX14577 is not set
# CONFIG_EXTCON_PALMAS is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7887=y
CONFIG_AD7923=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=y
CONFIG_MPL3115=y
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
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
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
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
# CONFIG_FSCACHE is not set

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
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
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
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
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
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
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
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

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
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

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
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
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
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_CRC64_ECMA=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
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
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--uAKRQypu60I7Lcqm--
