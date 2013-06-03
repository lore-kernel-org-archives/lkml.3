Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3FCLW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:22:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:20219 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab3FCLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,792,1363158000"; 
   d="log'?scan'208";a="343978327"
Date: Mon, 3 Jun 2013 19:22:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [virtio_blk] BUG: unable to handle kernel paging request at ff7f5784
Message-ID: <20130603112223.GB6595@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit b70aa55ec9532d5f5d3e367e4cad8997b1135f86
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 24 20:22:33 2013 +0200

    virtio_blk: blk-mq support
    
    Pretend we have 4 issue queues.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

[  277.857736] blk-mq: CPU -> queue map
[  277.871142]   CPU 0 -> Queue 0
[  277.934080] BUG: unable to handle kernel paging request at ff7f5784
[  277.934080] IP: [<812fe4c7>] blk_mq_init_queue+0x5fa/0x6f7
[  277.934080] *pde = 06814067 *pte = 00000000 
[  277.934080] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  277.934080] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #98
[  277.934080] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  277.934080] task: 8d448000 ti: 8d444000 task.ti: 8d444000
[  277.934080] EIP: 0060:[<812fe4c7>] EFLAGS: 00000203 CPU: 0
[  277.934080] EIP is at blk_mq_init_queue+0x5fa/0x6f7
[  277.934080] EAX: 86906000 EBX: ff7f5740 ECX: 868f9088 EDX: 00000001
[  277.934080] ESI: 868c5550 EDI: 00000002 EBP: 8d445e3c ESP: 8d445df0
[  277.934080]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  277.934080] CR0: 8005003b CR2: ff7f5784 CR3: 02941000 CR4: 00000690
[  277.934080] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  277.934080] DR6: 00000000 DR7: 00000000
[  277.934080] Stack:
[  277.934080]  0000000a 86a17980 00000004 868eb780 00000000 00000000 869066bc f3c6a740
[  277.934080]  ffffffff 00000d80 868af420 0000000a 8e5c8280 00000004 82772fec 86a18700
[  277.934080]  868eb780 868ee400 00000c54 8d445e7c 81424cc2 86e6e000 00000000 86e6e000
[  277.934080] Call Trace:
[  277.934080]  [<81424cc2>] virtblk_probe+0x165/0x579
[  277.934080]  [<813979f6>] ? vring_transport_features+0x12/0x22
[  277.934080]  [<813966da>] virtio_dev_probe+0xae/0xe3
[  277.934080]  [<813f8059>] driver_probe_device+0xf2/0x26e
[  277.934080]  [<813f8223>] __driver_attach+0x4e/0x6a
[  277.934080]  [<813f8223>] ? __driver_attach+0x4e/0x6a
[  277.934080]  [<813f6a02>] bus_for_each_dev+0x3e/0x68
[  277.934080]  [<813f7dc6>] driver_attach+0x14/0x16
[  277.934080]  [<813f81d5>] ? driver_probe_device+0x26e/0x26e
[  277.934080]  [<813f7098>] bus_add_driver+0xd9/0x1da
[  277.934080]  [<8130f114>] ? kset_find_obj+0x5d/0x65
[  277.934080]  [<813f8519>] driver_register+0x74/0xef
[  277.934080]  [<813f8519>] ? driver_register+0x74/0xef
[  277.934080]  [<81f88190>] ? mutex_unlock+0x8/0xa
[  277.934080]  [<8139676d>] register_virtio_driver+0x1d/0x1f
[  277.934080]  [<828bb2d1>] init+0x49/0x76
[  277.934080]  [<828bb288>] ? mm_init+0x151/0x151
[  277.934080]  [<8288e9d4>] do_one_initcall+0x95/0x126
[  277.934080]  [<828a85d6>] ? init_nls_iso8859_4+0xf/0xf
[  277.934080]  [<8288eb82>] kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<8288eb82>] ? kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<81f67d2c>] kernel_init+0x8/0xb4
[  277.934080]  [<81f8ac17>] ret_from_kernel_thread+0x1b/0x28
[  277.934080]  [<81f67d24>] ? rest_init+0x118/0x118
[  277.934080] Code: ff 8b 86 c0 00 00 00 8b 3c 98 3b 9e c4 00 00 00 72 b6 e9 e4 00 00 00 8b 8e b0 00 00 00 89 fa 89 f0 47 ff 51 04 8b 90 a8 00 00 00 <89> 53 44 8b 90 a8 00 00 00 8b 88 ac 00 00 00 89 1c 91 42 89 90
[  277.934080] EIP: [<812fe4c7>] blk_mq_init_queue+0x5fa/0x6f7 SS:ESP 0068:8d445df0
[  277.934080] CR2: 00000000ff7f5784
[  277.934080] ---[ end trace c7ec3499622b2c6b ]---

git bisect start 5754ab54c1b28888e9700550585c5729fccbd15f e4aa937ec75df0eea0bee03bffa3303ad36c986b --
git bisect good dc2978537d4353ef173e99b28287effeeb019dba  #   662  2013-06-03 15:20:31  null_blk: multi queue aware block test driver
git bisect  bad a9e8919f71fcbd545812f6bcdc53eaf7747a5281  #   654  2013-06-03 15:21:05  direct-io: only inc/dec inode->i_dio_count for file systems
git bisect  bad b70aa55ec9532d5f5d3e367e4cad8997b1135f86  #   676  2013-06-03 15:21:41  virtio_blk: blk-mq support
git bisect good 00060f37d61cce84b05ab265a1d3532fb83b1002  #  3132  2013-06-03 15:22:15  mtip32xx: basic mq support
git bisect good 00060f37d61cce84b05ab265a1d3532fb83b1002  #  3134  2013-06-03 15:23:02  mtip32xx: basic mq support
git bisect  bad 5754ab54c1b28888e9700550585c5729fccbd15f  #   522  2013-06-03 15:23:46  blk-mq: timeout fixes
git bisect good 202b60e0678542e0a26afe501e83d436904e9ba0  #  1431  2013-06-03 18:14:49  Revert "virtio_blk: blk-mq support"
git bisect good 6318c0ec14d5f7aea22987223e1a99dbda7b1fd0  #  1431  2013-06-03 18:55:32  Add linux-next specific files for 20130603

Thanks,
Fengguang

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-24774-2013-06-03-11-27-14-3.10.0-rc3-00011-g5754ab5-98"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00011-g5754ab5 (kbuild@inn) (gcc ve=
rsion 4.7.1 (Debian 4.7.1-6) ) #98 SMP Tue May 28 23:44:37 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[800fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x033fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x02eec000, 0x02eecfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x02eed000, 0x02eedfff] PGTABLE
[    0.000000] BRK [0x02eee000, 0x02eeefff] PGTABLE
[    0.000000] BRK [0x02eef000, 0x02eeffff] PGTABLE
[    0.000000] BRK [0x02ef0000, 0x02ef0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128044(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat 828441e0, node_mem_map 8e=
4bf028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @8e4ab000 s28568 r0 d12392 u40=
960
[    0.000000] pcpu-alloc: s28568 r0 d12392 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64784
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/bisect-linux-drm:i386-randconfig-i004-0527/b=
lock:new-queue/.vmlinuz-2013-06-03-10-43-34-block:new-queue:5754ab54c1b2888=
8e9700550585c5729fccbd15f-5754ab54c1b28888e9700550585c5729fccbd15f-i386-ran=
dconfig-i004-0527-127-ant branch=3Dblock/new-queue noapic nolapic nohz=3Dof=
f BOOT_IMAGE=3D/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e970055058=
5c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 192904k/262136k available (15918k kernel code, 68792=
k reserved, 9224k data, 652k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6b000 - 0xfffff000   (1616 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x8288e000 - 0x82931000   ( 652 kB)
[    0.000000]       .data : 0x81f8ba3b - 0x8288dde0   (9224 kB)
[    0.000000]       .text : 0x81000000 - 0x81f8ba3b   (15918 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8d408000 soft=3D8d40a000
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
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.976 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.043679] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.95 BogoMIPS (lpj=3D10639920)
[    0.048080] pid_max: default: 4096 minimum: 301
[    0.064926] Security Framework initialized
[    0.084435] Mount-cache hash table entries: 512
[    0.194381] Initializing cgroup subsys memory
[    0.202248] Initializing cgroup subsys devices
[    0.207109] Initializing cgroup subsys net_cls
[    0.208333] Initializing cgroup subsys blkio
[    0.210430] Initializing cgroup subsys perf_event
[    0.211535] Initializing cgroup subsys net_prio
[    0.237078] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.237078] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.237078] tlb_flushall_shift: -1
[    0.258900] debug: unmapping init [mem 0x82931000-0x8293dfff]
[    0.358495] ACPI: Core revision 20130328
[    0.623683] ACPI: All ACPI Tables successfully acquired
[    0.625400] ACPI: setting ELCR to 0200 (from 0c00)
[    0.725118] smpboot: SMP disabled
[    0.730866] Performance Events:=20
[    0.732083] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.733696] no hardware sampling interrupt available.
[    0.737224] Broken PMU hardware detected, using software events only.
[    0.740518] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.965168] Brought up 1 CPUs
[    0.967635] ----------------
[    0.968409] | NMI testsuite:
[    0.969055] --------------------
[    0.970289]   remote IPI:  ok  |
[    0.971343]    local IPI:  ok  |
[    3.930403] --------------------
[    3.931108] Good, all   2 testcases passed! |
[    3.931816] ---------------------------------
[    3.933985] smpboot: Total of 1 processors activated (6386.95 BogoMIPS)
[    3.948744] CPU0 attaching NULL sched-domain.
[    4.062321] devtmpfs: initialized
[    4.074456] device: 'platform': device_add
[    4.092038] bus: 'platform': registered
[    4.097560] bus: 'cpu': registered
[    4.098531] device: 'cpu': device_add
[    4.199041] EVM: security.capability
[    4.284570] bus: 'workqueue': registered
[    4.285509] device: 'workqueue': device_add
[    4.297048] xor: measuring software checksum speed
[    4.340490]    pIII_sse  :   163.200 MB/sec
[    4.373803]    prefetch64-sse:   180.000 MB/sec
[    4.374975] xor: using function: prefetch64-sse (180.000 MB/sec)
[    4.384010] atomic64 test passed for i586+ platform with CX8 and with SSE
[    4.388329] bus: 'virtio': registered
[    4.390542] device class 'regulator': registering
[    4.413894] Registering platform device 'reg-dummy'. Parent at platform
[    4.417038] device: 'reg-dummy': device_add
[    4.418237] bus: 'platform': add device reg-dummy
[    4.433754] bus: 'platform': add driver reg-dummy
[    4.437938] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    4.441040] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    4.449036] device: 'regulator.0': device_add
[    4.467209] regulator-dummy: no parameters
[    4.474776] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    4.478032] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    4.510914] NET: Registered protocol family 16
[    4.583826] device class 'bdi': registering
[    4.588136] device class 'pci_bus': registering
[    4.594714] bus: 'pci': registered
[    4.595570] device: 'rapidio': device_add
[    4.602225] bus: 'rapidio': registered
[    4.603797] device class 'lcd': registering
[    4.607709] device class 'backlight': registering
[    4.611002] device class 'video_output': registering
[    4.614439] bus: 'platform': add driver anatop_regulator
[    4.617930] device class 'tty': registering
[    4.623333] bus: 'platform': add driver sram
[    4.626909] bus: 'platform': add driver syscon
[    4.631442] bus: 'hsi': registered
[    4.634790] bus: 'i2c': registered
[    4.637214] bus: 'i2c': add driver dummy
[    4.640339] i2c-core: driver [dummy] registered
[    4.705331] ACPI: bus type PCI registered
[    4.720417] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    4.721796] PCI: Using configuration type 1 for base access
[    4.784524] device: 'cpu0': device_add
[    4.787321] bus: 'cpu': add device cpu0
[    7.720259] device: 'writeback': device_add
[    7.721479] bus: 'workqueue': add device writeback
[    7.728980] device: 'default': device_add
[    7.754415] bio: create slab <bio-0> at 0
[    7.769999] device class 'block': registering
[    7.838205] raid6: mmxx1       18 MB/s
[    7.898638] raid6: mmxx2       23 MB/s
[    7.957463] raid6: sse1x1      19 MB/s
[    8.014820] raid6: sse1x2      19 MB/s
[    8.070335] raid6: sse2x1      48 MB/s
[    8.127537] raid6: sse2x2      45 MB/s
[    8.128470] raid6: using algorithm sse2x1 (48 MB/s)
[    8.130825] raid6: using intx1 recovery algorithm
[    8.134133] bus: 'platform': add driver da9055-gpio
[    8.137564] bus: 'i2c': add driver max7300
[    8.141035] i2c-core: driver [max7300] registered
[    8.142218] bus: 'i2c': add driver pca953x
[    8.144641] i2c-core: driver [pca953x] registered
[    8.147039] bus: 'i2c': add driver pcf857x
[    8.148370] i2c-core: driver [pcf857x] registered
[    8.150631] bus: 'platform': add driver palmas-gpio
[    8.154462] bus: 'platform': add driver wm8350-gpio
[    8.160512] bus: 'platform': add driver aat2870-backlight
[    8.167441] ACPI: Added _OSI(Module Device)
[    8.168540] ACPI: Added _OSI(Processor Device)
[    8.170470] ACPI: Added _OSI(3.0 _SCP Extensions)
[    8.171570] ACPI: Added _OSI(Processor Aggregator Device)
[    8.335125] ACPI: EC: Look up EC in DSDT
[    8.852355] ACPI: Interpreter enabled
[    8.858045] ACPI: (supports S0 S5)
[    8.859109] ACPI: Using PIC for interrupt routing
[    8.864783] bus: 'acpi': registered
[    8.867415] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    8.884236] device: 'LNXSYSTM:00': device_add
[    8.888513] bus: 'acpi': add device LNXSYSTM:00
[    8.918099] device: 'device:00': device_add
[    8.920674] bus: 'acpi': add device device:00
[    8.938674] device: 'PNP0A03:00': device_add
[    8.940722] bus: 'acpi': add device PNP0A03:00
[    9.035250] device: 'device:01': device_add
[    9.037411] bus: 'acpi': add device device:01
[    9.051939] device: 'device:02': device_add
[    9.054085] bus: 'acpi': add device device:02
[    9.068890] device: 'PNP0B00:00': device_add
[    9.070805] bus: 'acpi': add device PNP0B00:00
[    9.090799] device: 'PNP0303:00': device_add
[    9.094020] bus: 'acpi': add device PNP0303:00
[    9.117270] device: 'PNP0F13:00': device_add
[    9.120275] bus: 'acpi': add device PNP0F13:00
[    9.144792] device: 'PNP0700:00': device_add
[    9.147395] bus: 'acpi': add device PNP0700:00
[    9.188445] device: 'PNP0400:00': device_add
[    9.190823] bus: 'acpi': add device PNP0400:00
[    9.221823] device: 'PNP0501:00': device_add
[    9.223987] bus: 'acpi': add device PNP0501:00
[    9.254150] device: 'device:03': device_add
[    9.257286] bus: 'acpi': add device device:03
[    9.274925] device: 'device:04': device_add
[    9.277488] bus: 'acpi': add device device:04
[    9.298829] device: 'device:05': device_add
[    9.300751] bus: 'acpi': add device device:05
[    9.318395] device: 'device:06': device_add
[    9.320899] bus: 'acpi': add device device:06
[    9.340683] device: 'device:07': device_add
[    9.342012] bus: 'acpi': add device device:07
[    9.361410] device: 'device:08': device_add
[    9.363903] bus: 'acpi': add device device:08
[    9.385359] device: 'device:09': device_add
[    9.387488] bus: 'acpi': add device device:09
[    9.406015] device: 'device:0a': device_add
[    9.407518] bus: 'acpi': add device device:0a
[    9.427327] device: 'device:0b': device_add
[    9.428688] bus: 'acpi': add device device:0b
[    9.446666] device: 'device:0c': device_add
[    9.447533] bus: 'acpi': add device device:0c
[    9.468082] device: 'device:0d': device_add
[    9.469496] bus: 'acpi': add device device:0d
[    9.487486] device: 'device:0e': device_add
[    9.490627] bus: 'acpi': add device device:0e
[    9.507818] device: 'device:0f': device_add
[    9.510747] bus: 'acpi': add device device:0f
[    9.530686] device: 'device:10': device_add
[    9.532088] bus: 'acpi': add device device:10
[    9.551119] device: 'device:11': device_add
[    9.554041] bus: 'acpi': add device device:11
[    9.571516] device: 'device:12': device_add
[    9.573792] bus: 'acpi': add device device:12
[    9.593333] device: 'device:13': device_add
[    9.597384] bus: 'acpi': add device device:13
[    9.619050] device: 'device:14': device_add
[    9.620856] bus: 'acpi': add device device:14
[    9.642068] device: 'device:15': device_add
[    9.644071] bus: 'acpi': add device device:15
[    9.664598] device: 'device:16': device_add
[    9.667278] bus: 'acpi': add device device:16
[    9.691349] device: 'device:17': device_add
[    9.694044] bus: 'acpi': add device device:17
[    9.713920] device: 'device:18': device_add
[    9.717317] bus: 'acpi': add device device:18
[    9.734625] device: 'device:19': device_add
[    9.737403] bus: 'acpi': add device device:19
[    9.754651] device: 'device:1a': device_add
[    9.757498] bus: 'acpi': add device device:1a
[    9.774733] device: 'device:1b': device_add
[    9.777202] bus: 'acpi': add device device:1b
[    9.792670] device: 'device:1c': device_add
[    9.794045] bus: 'acpi': add device device:1c
[    9.811792] device: 'device:1d': device_add
[    9.813939] bus: 'acpi': add device device:1d
[    9.831026] device: 'device:1e': device_add
[    9.834180] bus: 'acpi': add device device:1e
[    9.851149] device: 'device:1f': device_add
[    9.852290] bus: 'acpi': add device device:1f
[    9.871034] device: 'device:20': device_add
[    9.872401] bus: 'acpi': add device device:20
[    9.891593] device: 'device:21': device_add
[    9.893983] bus: 'acpi': add device device:21
[    9.916944] device: 'device:22': device_add
[    9.918589] bus: 'acpi': add device device:22
[    9.974517] device: 'PNP0103:00': device_add
[    9.977185] bus: 'acpi': add device PNP0103:00
[   10.009089] device: 'PNP0C0F:00': device_add
[   10.010774] bus: 'acpi': add device PNP0C0F:00
[   10.043961] device: 'PNP0C0F:01': device_add
[   10.045355] bus: 'acpi': add device PNP0C0F:01
[   10.077582] device: 'PNP0C0F:02': device_add
[   10.078741] bus: 'acpi': add device PNP0C0F:02
[   10.107081] device: 'PNP0C0F:03': device_add
[   10.110481] bus: 'acpi': add device PNP0C0F:03
[   10.139999] device: 'PNP0C0F:04': device_add
[   10.140814] bus: 'acpi': add device PNP0C0F:04
[   10.161292] device: 'LNXCPU:00': device_add
[   10.163795] bus: 'acpi': add device LNXCPU:00
[   10.181059] device: 'LNXCPU:01': device_add
[   10.182513] bus: 'acpi': add device LNXCPU:01
[   10.198666] device: 'device:23': device_add
[   10.200864] bus: 'acpi': add device device:23
[   10.231114] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   10.244421] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ign=
ored)
[   10.247262] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ign=
ored)
[   10.250588] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bff=
ff] (ignored)
[   10.253749] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfff=
ff] (ignored)
[   10.260719] PCI: root bus 00: using default resources
[   10.264185] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[   10.270739] device: 'pci0000:00': device_add
[   10.280778] device: '0000:00': device_add
[   10.290436] PCI host bridge to bus 0000:00
[   10.292665] pci_bus 0000:00: root bus resource [bus 00-ff]
[   10.293936] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   10.297221] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[   10.308151] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   10.324800] device: '0000:00:00.0': device_add
[   10.348962] bus: 'pci': add device 0000:00:00.0
[   10.361410] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   10.371872] device: '0000:00:01.0': device_add
[   10.380527] bus: 'pci': add device 0000:00:01.0
[   10.390466] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   10.408502] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   10.418052] device: '0000:00:01.1': device_add
[   10.445047] bus: 'pci': add device 0000:00:01.1
[   10.454567] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   10.462046] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   10.464014] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   10.470525] device: '0000:00:01.3': device_add
[   10.477079] bus: 'pci': add device 0000:00:01.3
[   10.484850] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   10.490572] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   10.497181] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   10.521399] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   10.524259] device: '0000:00:02.0': device_add
[   10.530638] bus: 'pci': add device 0000:00:02.0
[   10.542025] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   10.550293] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   10.553873] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   10.577069] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   10.580981] device: '0000:00:03.0': device_add
[   10.588658] bus: 'pci': add device 0000:00:03.0
[   10.595593] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   10.601664] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   10.608251] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   10.630526] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   10.634068] device: '0000:00:04.0': device_add
[   10.641322] bus: 'pci': add device 0000:00:04.0
[   10.651216] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   10.658247] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   10.664863] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   10.687547] device: '0000:00:05.0': device_add
[   10.694373] bus: 'pci': add device 0000:00:05.0
[   10.702287] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   10.710526] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   10.715916] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   10.741263] device: '0000:00:06.0': device_add
[   10.750464] bus: 'pci': add device 0000:00:06.0
[   10.760493] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   10.767057] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   10.770481] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   10.794960] device: '0000:00:07.0': device_add
[   10.805013] bus: 'pci': add device 0000:00:07.0
[   10.814841] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   10.820514] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   10.827175] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   10.850761] device: '0000:00:08.0': device_add
[   10.864086] bus: 'pci': add device 0000:00:08.0
[   10.872434] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   10.878437] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   10.887185] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   10.910361] device: '0000:00:09.0': device_add
[   10.921622] bus: 'pci': add device 0000:00:09.0
[   10.930834] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   10.937174] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   10.942534] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   10.966666] device: '0000:00:0a.0': device_add
[   10.977805] bus: 'pci': add device 0000:00:0a.0
[   10.986912] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   10.989370] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   11.007783] device: '0000:00:0b.0': device_add
[   11.020810] bus: 'pci': add device 0000:00:0b.0
[   11.034510] pci_bus 0000:00: on NUMA node 0
[   11.037472] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[   11.038910] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[   11.149113] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   11.173975] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   11.197089] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   11.221550] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   11.243956] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   11.268090] device: 'LNXPWRBN:00': device_add
[   11.273796] bus: 'acpi': add device LNXPWRBN:00
[   11.283333] ACPI: Enabled 16 GPEs in block 00 to 0F
[   11.287505] acpi root: \_SB_.PCI0 notify handler is installed
[   11.298306] Found 1 acpi root devices
[   11.300630] bus: 'acpi': add driver ec
[   11.310895] bus: 'pnp': registered
[   11.311912] bus: 'platform': add driver reg-fixed-voltage
[   11.314577] bus: 'platform': add driver aat2870-regulator
[   11.320635] bus: 'i2c': add driver ad5398
[   11.322439] i2c-core: driver [ad5398] registered
[   11.323816] bus: 'platform': add driver da9052-regulator
[   11.327873] bus: 'platform': add driver da9055-regulator
[   11.331153] bus: 'i2c': add driver isl6271a
[   11.334237] i2c-core: driver [isl6271a] registered
[   11.337150] bus: 'i2c': add driver lp3972
[   11.338901] i2c-core: driver [lp3972] registered
[   11.340526] bus: 'i2c': add driver lp8755-regulator
[   11.347346] i2c-core: driver [lp8755-regulator] registered
[   11.348631] bus: 'i2c': add driver max8649
[   11.353941] i2c-core: driver [max8649] registered
[   11.354990] bus: 'i2c': add driver max8660
[   11.357652] i2c-core: driver [max8660] registered
[   11.358921] bus: 'i2c': add driver max8973
[   11.361061] i2c-core: driver [max8973] registered
[   11.364010] bus: 'platform': add driver mc13783-regulator
[   11.367902] bus: 'platform': add driver mc13892-regulator
[   11.371075] bus: 'platform': add driver s5m8767-pmic
[   11.375108] bus: 'platform': add driver tps6507x-pmic
[   11.377736] bus: 'platform': add driver tps65090-pmic
[   11.381236] bus: 'platform': add driver tps65910-pmic
[   11.384632] bus: 'platform': add driver tps80031-pmic
[   11.390589] bus: 'platform': add driver wm8350-regulator
[   11.394973] device class 'misc': registering
[   11.404086] device: 'vga_arbiter': device_add
[   11.444994] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   11.447434] vgaarb: loaded
[   11.448235] vgaarb: bridge control possible 0000:00:02.0
[   11.460732] bus: 'tifm': registered
[   11.461691] device class 'tifm_adapter': registering
[   11.464377] bus: 'i2c': add driver 88PM80X
[   11.467481] i2c-core: driver [88PM80X] registered
[   11.470690] Error: Driver '88PM80X' is already registered, aborting...
[   11.471999] bus: 'i2c': add driver wm8350
[   11.476925] i2c-core: driver [wm8350] registered
[   11.477936] bus: 'i2c': add driver tps6105x
[   11.479286] i2c-core: driver [tps6105x] registered
[   11.480553] tps65010: version 2 May 2005
[   11.483702] bus: 'i2c': add driver tps65010
[   11.487611] i2c-core: driver [tps65010] registered
[   11.495128] bus: 'i2c': remove driver tps65010
[   11.498783] driver: 'tps65010': driver_release
[   11.500724] i2c-core: driver [tps65010] unregistered
[   11.519999] bus: 'i2c': add driver tps65010
[   11.527606] i2c-core: driver [tps65010] registered
[   11.529257] bus: 'i2c': remove driver tps65010
[   11.534138] driver: 'tps65010': driver_release
[   11.542992] i2c-core: driver [tps65010] unregistered
[   11.557245] bus: 'i2c': add driver tps65010
[   11.559037] i2c-core: driver [tps65010] registered
[   11.560748] bus: 'i2c': remove driver tps65010
[   11.562190] driver: 'tps65010': driver_release
[   11.563751] i2c-core: driver [tps65010] unregistered
[   11.566912] tps65010: no chip?
[   11.567764] bus: 'i2c': add driver tps65217
[   11.570712] i2c-core: driver [tps65217] registered
[   11.574001] bus: 'i2c': add driver tps65910
[   11.577518] i2c-core: driver [tps65910] registered
[   11.578506] bus: 'i2c': add driver tps65912
[   11.581013] i2c-core: driver [tps65912] registered
[   11.583876] bus: 'i2c': add driver tps80031
[   11.587053] i2c-core: driver [tps80031] registered
[   11.588105] bus: 'i2c': add driver mc13xxx
[   11.590979] i2c-core: driver [mc13xxx] registered
[   11.593830] bus: 'i2c': add driver da9052
[   11.597112] i2c-core: driver [da9052] registered
[   11.598466] bus: 'i2c': add driver lp8788
[   11.600984] i2c-core: driver [lp8788] registered
[   11.603863] bus: 'i2c': add driver da9055
[   11.607324] i2c-core: driver [da9055] registered
[   11.608408] bus: 'i2c': add driver max77686
[   11.610734] i2c-core: driver [max77686] registered
[   11.611882] bus: 'i2c': add driver max77693
[   11.617002] i2c-core: driver [max77693] registered
[   11.618046] bus: 'i2c': add driver pcf50633
[   11.620572] i2c-core: driver [pcf50633] registered
[   11.621880] bus: 'i2c': add driver tps65090
[   11.624545] i2c-core: driver [tps65090] registered
[   11.627255] bus: 'i2c': add driver aat2870
[   11.631028] i2c-core: driver [aat2870] registered
[   11.632301] bus: 'i2c': add driver palmas
[   11.634203] i2c-core: driver [palmas] registered
[   11.637097] bus: 'i2c': add driver sec_pmic
[   11.639098] i2c-core: driver [sec_pmic] registered
[   11.640603] bus: 'i2c': add driver lm3533
[   11.644302] i2c-core: driver [lm3533] registered
[   11.658139] device class 'scsi_host': registering
[   11.664532] bus: 'scsi': registered
[   11.665446] device class 'scsi_device': registering
[   11.669999] SCSI subsystem initialized
[   11.670740] ACPI: bus type ATA registered
[   11.673680] device class 'ata_link': registering
[   11.676666] device class 'ata_port': registering
[   11.677697] device class 'ata_device': registering
[   11.684672] libata version 3.00 loaded.
[   11.687214] device class 'mdio_bus': registering
[   11.691563] bus: 'mdio_bus': registered
[   11.693802] bus: 'mdio_bus': add driver Generic PHY
[   11.697329] device class 'pcmcia_socket': registering
[   11.701807] ACPI: bus type USB registered
[   11.705050] bus: 'usb': registered
[   11.707622] bus: 'usb': add driver usbfs
[   11.711293] usbcore: registered new interface driver usbfs
[   11.714665] bus: 'usb': add driver hub
[   11.717673] usbcore: registered new interface driver hub
[   11.723811] bus: 'usb': add driver usb
[   11.727538] usbcore: registered new device driver usb
[   11.728867] bus: 'platform': add driver nop_usb_xceiv
[   11.731442] bus: 'platform': add driver omap-control-usb
[   11.734743] device class 'udc': registering
[   11.744212] bus: 'serio': registered
[   11.747870] bus: 'gameport': registered
[   11.748804] device class 'input': registering
[   11.751626] bus: 'i2c': add driver tca6416-keypad
[   11.754559] i2c-core: driver [tca6416-keypad] registered
[   11.755873] bus: 'i2c': add driver tca8418_keypad
[   11.760955] i2c-core: driver [tca8418_keypad] registered
[   11.763721] device class 'rtc': registering
[   11.767097] bus: 'platform': add driver i2c-gpio
[   11.773635] bus: 'platform': add driver viperboard-i2c
[   11.775336] Linux video capture interface: v2.00
[   11.777185] device class 'video4linux': registering
[   11.780921] device class 'dvb': registering
[   11.783987] device class 'rc': registering
[   11.787247] device class 'pps': registering
[   11.791160] pps_core: LinuxPPS API ver. 1 registered
[   11.793747] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   11.797176] device class 'ptp': registering
[   11.800947] PTP clock support registered
[   11.801825] device class 'power_supply': registering
[   11.805010] device class 'hwmon': registering
[   11.807762] device class 'watchdog': registering
[   11.814533] bus: 'mmc': registered
[   11.817059] device class 'mmc_host': registering
[   11.821001] bus: 'sdio': registered
[   11.821862] device class 'leds': registering
[   11.824521] device class 'sound': registering
[   11.836666] Advanced Linux Sound Architecture Driver Initialized.
[   11.840758] bus: 'ac97': registered
[   11.841599] PCI: Using ACPI for IRQ routing
[   11.844167] PCI: pci_cache_line_size set to 64 bytes
[   11.851436] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   11.854616] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[   11.862034] device class 'net': registering
[   11.878430] device: 'lo': device_add
[   11.941662] irda_init()
[   11.954676] NET: Registered protocol family 23
[   11.963855] Bluetooth: Core ver 2.16
[   11.967348] device class 'bluetooth': registering
[   11.969422] NET: Registered protocol family 31
[   11.970416] Bluetooth: HCI device and connection manager initialized
[   11.977630] Bluetooth: HCI socket layer initialized
[   11.980738] Bluetooth: L2CAP socket layer initialized
[   11.984399] Bluetooth: SCO socket layer initialized
[   11.987232] NET: Registered protocol family 8
[   11.988117] NET: Registered protocol family 20
[   11.991609] device class 'atm': registering
[   11.994782] device class 'rfkill': registering
[   11.997675] device: 'rfkill': device_add
[   12.014450] device class 'ieee802154': registering
[   12.020956] nfc: nfc_init: NFC Core ver 0.1
[   12.022008] device class 'nfc': registering
[   12.030406] NET: Registered protocol family 39
[   12.095295] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[   12.127871] Switching to clocksource hpet
[   12.153107] CE: hpet increased min_delta_ns to 5000 nsec
[   12.153107] CE: hpet increased min_delta_ns to 7500 nsec
[   12.153107] CE: hpet increased min_delta_ns to 11250 nsec
[   12.254110] FS-Cache: Loaded
[   12.268171] bus: 'pnp': add driver system
[   12.269714] pnp: PnP ACPI init
[   12.282483] device: 'pnp0': device_add
[   12.292414] ACPI: bus type PNP registered
[   12.326076] device: '00:00': device_add
[   12.339315] bus: 'pnp': add device 00:00
[   12.346868] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   12.381446] device: '00:01': device_add
[   12.384045] bus: 'pnp': add device 00:01
[   12.393186] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   12.415749] device: '00:02': device_add
[   12.424820] bus: 'pnp': add device 00:02
[   12.438879] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   12.461856] pnp 00:03: [dma 2]
[   12.462952] device: '00:03': device_add
[   12.467964] bus: 'pnp': add device 00:03
[   12.481517] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   12.505334] device: '00:04': device_add
[   12.518082] bus: 'pnp': add device 00:04
[   12.524611] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   12.552754] device: '00:05': device_add
[   12.558243] bus: 'pnp': add device 00:05
[   12.575334] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   12.671400] device: '00:06': device_add
[   12.684900] bus: 'pnp': add device 00:06
[   12.698306] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   12.769810] pnp: PnP ACPI: found 7 devices
[   12.774372] ACPI: bus type PNP unregistered
[   12.776202] device class 'mem': registering
[   12.789002] device: 'mem': device_add
[   12.812397] device: 'null': device_add
[   12.835856] device: 'port': device_add
[   12.857510] device: 'zero': device_add
[   12.869636] device: 'full': device_add
[   12.888379] device: 'random': device_add
[   12.914844] device: 'urandom': device_add
[   12.937938] device: 'kmsg': device_add
[   12.955218] device: 'oldmem': device_add
[   12.978177] device: 'tty': device_add
[   13.014522] device: 'console': device_add
[   13.038595] bus: 'pcmcia': registered
[   13.046471] device class 'thermal': registering
[   13.128009] PM-Timer running at invalid rate: 110% of normal - aborting.
[   13.137902] bus: 'ssb': registered
[   13.151636] bus: 'bcma': registered
[   13.152711] bus: 'pci': add driver bcma-pci-bridge
[   13.177426] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   13.181673] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[   13.213907] NET: Registered protocol family 2
[   13.357303] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[   13.378700] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[   13.408432] TCP: Hash tables configured (established 2048 bind 2048)
[   13.424080] TCP: reno registered
[   13.432241] UDP hash table entries: 128 (order: 1, 10240 bytes)
[   13.446094] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[   13.522189] NET: Registered protocol family 1
[   13.539486] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   13.544709] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   13.546366] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   13.559332] pci 0000:00:02.0: Boot video device
[   13.568494] PCI: CLS 0 bytes, default 64
[   13.673923] Trying to unpack rootfs image as initramfs...
[   66.977178] hrtimer: interrupt took 6905331 ns
[  253.506480] debug: unmapping init [mem 0x8e73f000-0x8ffeffff]
[  257.866492] DMA-API: preallocated 65536 debug entries
[  257.876259] DMA-API: debugging enabled by kernel config
[  258.095363] device class 'msr': registering
[  258.106515] device: 'msr0': device_add
[  258.198209] device class 'cpuid': registering
[  258.206581] device: 'cpu0': device_add
[  258.395972] PCLMULQDQ-NI instructions are not detected.
[  258.415711] NatSemi SCx200 Driver
[  258.418645] bus: 'pci': add driver scx200
[  258.481280] bus: 'clocksource': registered
[  258.482467] device: 'clocksource': device_add
[  258.496287] device: 'clocksource0': device_add
[  258.508452] bus: 'clocksource': add device clocksource0
[  258.532645] bus: 'platform': add driver alarmtimer
[  258.548549] Registering platform device 'alarmtimer'. Parent at platform
[  258.549781] device: 'alarmtimer': device_add
[  258.562499] bus: 'platform': add device alarmtimer
[  258.578754] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[  258.589765] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[  258.601221] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[  258.602832] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[  258.633823] bus: 'rttest': registered
[  258.658684] device: 'rttest': device_add
[  258.711982] device: 'rttest0': device_add
[  258.721527] bus: 'rttest': add device rttest0
[  258.768360] device: 'rttest1': device_add
[  258.769675] bus: 'rttest': add device rttest1
[  258.809446] device: 'rttest2': device_add
[  258.816631] bus: 'rttest': add device rttest2
[  258.859319] device: 'rttest3': device_add
[  258.865143] bus: 'rttest': add device rttest3
[  258.892702] device: 'rttest4': device_add
[  258.898462] bus: 'rttest': add device rttest4
[  258.936568] device: 'rttest5': device_add
[  258.942345] bus: 'rttest': add device rttest5
[  258.974814] device: 'rttest6': device_add
[  258.976149] bus: 'rttest': add device rttest6
[  259.012125] device: 'rttest7': device_add
[  259.015964] bus: 'rttest': add device rttest7
[  259.039626] Initializing RT-Tester: OK
[  259.124888] bus: 'event_source': registered
[  259.126426] device: 'breakpoint': device_add
[  259.139294] bus: 'event_source': add device breakpoint
[  259.164820] device: 'software': device_add
[  259.166314] bus: 'event_source': add device software
[  260.708818] VFS: Disk quotas dquot_6.5.2
[  260.746033] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[  260.871752] device: 'dlm-control': device_add
[  260.932673] device: 'dlm-monitor': device_add
[  260.977958] device: 'dlm_plock': device_add
[  261.009537] DLM installed
[  261.215526] FS-Cache: Netfs 'cifs' registered for caching
[  261.305848] Key type cifs.spnego registered
[  261.332848] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[  261.389592] device: 'autofs': device_add
[  261.508318] JFS: nTxBlock =3D 1507, nTxLock =3D 12056
[  261.756447] SGI XFS with ACLs, security attributes, no debug enabled
[  262.070672] NILFS version 2 loaded
[  262.228695] bio: create slab <bio-1> at 1
[  262.399449] device: 'btrfs-control': device_add
[  262.441526] Btrfs loaded
[  264.053108] NET: Registered protocol family 38
[  264.062987] Key type asymmetric registered
[  264.073113] device class 'bsg': registering
[  264.095219] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[  264.136535] io scheduler noop registered
[  264.143292] io scheduler cfq registered (default)
[  264.152394] test_string_helpers: Running tests...
[  264.222698] bus: 'i2c': add driver adp5588-gpio
[  264.232948] i2c-core: driver [adp5588-gpio] registered
[  264.239971] bus: 'pci': add driver bt8xxgpio
[  264.261703] bus: 'platform': add driver cs5535-gpio
[  264.271842] bus: 'platform': add driver grgpio
[  264.286567] bus: 'pci': add driver pch_gpio
[  264.301389] bus: 'platform': add driver rdc321x-gpio
[  264.311510] bus: 'platform': add driver sch_gpio
[  264.326270] bus: 'platform': add driver timb-gpio
[  264.332900] bus: 'platform': add driver twl6040-gpo
[  264.378853] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  264.389208] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[  264.395824] bus: 'pci': add driver compaq_pci_hotplug
[  264.406425] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[  264.445383] bus: 'platform': add driver platform-lcd
[  264.451681] bus: 'i2c': add driver adp8860_bl
[  264.466211] i2c-core: driver [adp8860_bl] registered
[  264.475372] bus: 'i2c': add driver adp8870_bl
[  264.482917] i2c-core: driver [adp8870_bl] registered
[  264.488693] bus: 'platform': add driver da9052-wled
[  264.498716] bus: 'platform': add driver generic-bl
[  264.509919] bus: 'i2c': add driver lp855x
[  264.516207] i2c-core: driver [lp855x] registered
[  264.526596] bus: 'platform': add driver lp8788-backlight
[  264.533261] bus: 'platform': add driver pcf50633-backlight
[  264.541569] bus: 'platform': add driver tps65217-bl
[  264.558215] bus: 'platform': add driver ipmi
[  264.560769] ipmi message handler version 39.2
[  264.569651] bus: 'platform': add driver ipmi_si
[  264.585209] IPMI System Interface driver.
[  264.586415] bus: 'pci': add driver ipmi_si
[  264.605769] bus: 'pnp': add driver ipmi_si
[  264.621492] ipmi_si: Adding default-specified kcs state machine
[  264.623279] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[  264.635167] ipmi_si: Interface detection failed
[  264.655000] ipmi_si: Adding default-specified smic state machine
[  264.656480] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[  264.664572] ipmi_si: Interface detection failed
[  264.665827] ipmi_si: Adding default-specified bt state machine
[  264.681795] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[  264.693273] ipmi_si: Interface detection failed
[  264.708916] bus: 'pci': remove driver ipmi_si
[  264.719696] driver: 'ipmi_si': driver_release
[  264.725984] bus: 'pnp': remove driver ipmi_si
[  264.735662] driver: 'ipmi_si': driver_release
[  264.748350] bus: 'platform': remove driver ipmi_si
[  264.749942] driver: 'ipmi_si': driver_release
[  264.762554] ipmi_si: Unable to find any System Interface(s)
[  264.771722] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[  264.794592] bus: 'acpi': add driver ac
[  264.806495] bus: 'acpi': add driver button
[  264.818498] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[  264.827545] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[  264.842734] device: 'input0': device_add
[  264.895449] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[  264.911807] ACPI: Power Button [PWRF]
[  264.919254] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[  264.933235] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[  264.941463] bus: 'acpi': add driver fan
[  264.955442] bus: 'acpi': add driver processor
[  264.965434] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[  264.976127] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[  265.062617] device: 'cooling_device0': device_add
[  265.104432] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[  265.105972] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[  265.116046] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[  265.119634] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[  265.238140] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2=
/0x1 ignored.
[  265.239834] Unable to map lapic to logical cpu number
[  265.252592] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[  265.258687] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[  266.071136] bus: 'acpi': add driver thermal
[  266.092726] bus: 'platform': add driver virtio-mmio
[  266.105288] bus: 'pci': add driver virtio-pci
[  266.109411] bus: 'pci': driver_probe_device: matched device 0000:00:03.0=
 with driver virtio-pci
[  266.122330] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:03.0
[  266.429024] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  266.436511] PCI: setting IRQ 11 as level-triggered
[  266.452418] virtio-pci 0000:00:03.0: setting latency timer to 64
[  266.477973] device: 'virtio0': device_add
[  266.479474] bus: 'virtio': add device virtio0
[  266.503173] driver: '0000:00:03.0': driver_bound: bound to device 'virti=
o-pci'
[  266.510796] bus: 'pci': really_probe: bound device 0000:00:03.0 to drive=
r virtio-pci
[  266.512577] bus: 'pci': driver_probe_device: matched device 0000:00:05.0=
 with driver virtio-pci
[  266.529619] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:05.0
[  266.783241] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[  266.792472] PCI: setting IRQ 10 as level-triggered
[  266.799829] virtio-pci 0000:00:05.0: setting latency timer to 64
[  266.807844] device: 'virtio1': device_add
[  266.809344] bus: 'virtio': add device virtio1
[  266.832274] driver: '0000:00:05.0': driver_bound: bound to device 'virti=
o-pci'
[  266.844257] bus: 'pci': really_probe: bound device 0000:00:05.0 to drive=
r virtio-pci
[  266.846024] bus: 'pci': driver_probe_device: matched device 0000:00:06.0=
 with driver virtio-pci
[  266.858914] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:06.0
[  267.109167] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[  267.124508] virtio-pci 0000:00:06.0: setting latency timer to 64
[  267.126302] device: 'virtio2': device_add
[  267.133174] bus: 'virtio': add device virtio2
[  267.149833] driver: '0000:00:06.0': driver_bound: bound to device 'virti=
o-pci'
[  267.159363] bus: 'pci': really_probe: bound device 0000:00:06.0 to drive=
r virtio-pci
[  267.178006] bus: 'pci': driver_probe_device: matched device 0000:00:07.0=
 with driver virtio-pci
[  267.179849] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:07.0
[  267.396589] virtio-pci 0000:00:07.0: setting latency timer to 64
[  267.402664] device: 'virtio3': device_add
[  267.409606] bus: 'virtio': add device virtio3
[  267.435679] driver: '0000:00:07.0': driver_bound: bound to device 'virti=
o-pci'
[  267.441713] bus: 'pci': really_probe: bound device 0000:00:07.0 to drive=
r virtio-pci
[  267.449350] bus: 'pci': driver_probe_device: matched device 0000:00:08.0=
 with driver virtio-pci
[  267.459720] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:08.0
[  267.709730] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  267.715918] virtio-pci 0000:00:08.0: setting latency timer to 64
[  267.732682] device: 'virtio4': device_add
[  267.738824] bus: 'virtio': add device virtio4
[  267.755915] driver: '0000:00:08.0': driver_bound: bound to device 'virti=
o-pci'
[  267.765449] bus: 'pci': really_probe: bound device 0000:00:08.0 to drive=
r virtio-pci
[  267.773064] bus: 'pci': driver_probe_device: matched device 0000:00:09.0=
 with driver virtio-pci
[  267.779344] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:09.0
[  267.976260] virtio-pci 0000:00:09.0: setting latency timer to 64
[  267.988125] device: 'virtio5': device_add
[  267.989474] bus: 'virtio': add device virtio5
[  268.009510] driver: '0000:00:09.0': driver_bound: bound to device 'virti=
o-pci'
[  268.021140] bus: 'pci': really_probe: bound device 0000:00:09.0 to drive=
r virtio-pci
[  268.022906] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0=
 with driver virtio-pci
[  268.032556] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:0a.0
[  268.226617] virtio-pci 0000:00:0a.0: setting latency timer to 64
[  268.236255] device: 'virtio6': device_add
[  268.245565] bus: 'virtio': add device virtio6
[  268.262763] driver: '0000:00:0a.0': driver_bound: bound to device 'virti=
o-pci'
[  268.272449] bus: 'pci': really_probe: bound device 0000:00:0a.0 to drive=
r virtio-pci
[  268.292684] bus: 'virtio': add driver virtio_balloon
[  268.305404] bus: 'platform': add driver reg-virt-consumer
[  268.315282] bus: 'i2c': add driver fan53555-regulator
[  268.321319] i2c-core: driver [fan53555-regulator] registered
[  268.322702] bus: 'i2c': add driver lp872x
[  268.342625] i2c-core: driver [lp872x] registered
[  268.351748] HDLC line discipline maxframe=3D4096
[  268.352800] N_HDLC line discipline registered.
[  268.372532] r3964: Philips r3964 Driver $Revision: 1.10 $
[  268.381814] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  268.398523] bus: 'pnp': add driver serial
[  268.408868] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river serial
[  268.418353] bus: 'pnp': really_probe: probing driver serial with device =
00:05
[  268.543258] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  268.559873] device: 'ttyS0': device_add
[  268.629209] bus: 'acpi': add driver battery
[  268.679377] driver: '00:05': driver_bound: bound to device 'serial'
[  268.689946] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[  268.703123] Registering platform device 'serial8250'. Parent at platform
[  268.710751] device: 'serial8250': device_add
[  268.712216] bus: 'platform': add device serial8250
[  268.743291] device: 'ttyS1': device_add
[  268.809001] device: 'ttyS2': device_add
[  268.858752] device: 'ttyS3': device_add
[  268.909248] bus: 'platform': add driver serial8250
[  268.919949] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[  268.933130] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[  268.945575] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[  268.959556] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[  268.982872] bus: 'pci': add driver serial
[  269.005364] bus: 'pcmcia': add driver serial_cs
[  269.011798] bus: 'platform': add driver uart-sccnxp
[  269.035870] bus: 'pci': add driver jsm
[  269.056572] bus: 'platform': add driver uartlite
[  269.068792] bus: 'platform': add driver of_serial
[  269.079447] bus: 'platform': add driver altera_uart
[  269.095833] bus: 'platform': add driver timb-uart
[  269.143205] bus: 'pci': add driver HSU serial
[  269.162532] bus: 'platform': add driver xuartps
[  269.179282] bus: 'platform': add driver arc-uart
[  269.189860] Cyclades driver 2.6
[  269.199519] bus: 'pci': add driver cyclades
[  269.216515] bus: 'pci': add driver isicom
[  269.232863] MOXA Smartio/Industio family driver version 2.0.5
[  269.253298] bus: 'pci': add driver mxser
[  269.269221] RocketPort device driver module, version 2.09, 12-June-2003
[  269.279784] No rocketport ports found; unloading driver
[  269.295875] SyncLink GT
[  269.305478] SyncLink GT, tty major#246
[  269.306506] bus: 'pci': add driver synclink_gt
[  269.322513] SyncLink GT no devices found
[  269.331509] SyncLink MultiPort driver $Revision: 4.38 $
[  269.332738] bus: 'pci': add driver synclinkmp
[  269.355933] device: 'ttySLM0': device_add
[  269.396327] device: 'ttySLM1': device_add
[  269.448933] device: 'ttySLM2': device_add
[  269.489835] device: 'ttySLM3': device_add
[  269.533139] device: 'ttySLM4': device_add
[  269.558853] device: 'ttySLM5': device_add
[  269.585967] device: 'ttySLM6': device_add
[  269.622457] device: 'ttySLM7': device_add
[  269.654883] device: 'ttySLM8': device_add
[  269.679542] device: 'ttySLM9': device_add
[  269.706143] device: 'ttySLM10': device_add
[  269.735820] device: 'ttySLM11': device_add
[  269.769126] device: 'ttySLM12': device_add
[  269.801717] device: 'ttySLM13': device_add
[  269.828782] device: 'ttySLM14': device_add
[  269.858283] device: 'ttySLM15': device_add
[  269.877286] device: 'ttySLM16': device_add
[  269.909535] device: 'ttySLM17': device_add
[  269.936419] device: 'ttySLM18': device_add
[  269.971261] device: 'ttySLM19': device_add
[  269.995126] device: 'ttySLM20': device_add
[  270.019887] device: 'ttySLM21': device_add
[  270.052860] device: 'ttySLM22': device_add
[  270.076491] device: 'ttySLM23': device_add
[  270.109334] device: 'ttySLM24': device_add
[  270.148158] device: 'ttySLM25': device_add
[  270.178442] device: 'ttySLM26': device_add
[  270.201686] device: 'ttySLM27': device_add
[  270.229637] device: 'ttySLM28': device_add
[  270.266163] device: 'ttySLM29': device_add
[  270.296484] device: 'ttySLM30': device_add
[  270.328669] device: 'ttySLM31': device_add
[  270.352723] device: 'ttySLM32': device_add
[  270.379752] device: 'ttySLM33': device_add
[  270.416481] device: 'ttySLM34': device_add
[  270.449287] device: 'ttySLM35': device_add
[  270.475743] device: 'ttySLM36': device_add
[  270.504740] device: 'ttySLM37': device_add
[  270.532640] device: 'ttySLM38': device_add
[  270.572717] device: 'ttySLM39': device_add
[  270.596018] device: 'ttySLM40': device_add
[  270.634682] device: 'ttySLM41': device_add
[  270.661942] device: 'ttySLM42': device_add
[  270.689239] device: 'ttySLM43': device_add
[  270.716097] device: 'ttySLM44': device_add
[  270.752790] device: 'ttySLM45': device_add
[  270.781360] device: 'ttySLM46': device_add
[  270.808404] device: 'ttySLM47': device_add
[  270.836191] device: 'ttySLM48': device_add
[  270.869385] device: 'ttySLM49': device_add
[  270.895967] device: 'ttySLM50': device_add
[  270.932284] device: 'ttySLM51': device_add
[  270.959280] device: 'ttySLM52': device_add
[  270.986591] device: 'ttySLM53': device_add
[  271.019897] device: 'ttySLM54': device_add
[  271.058881] device: 'ttySLM55': device_add
[  271.094529] device: 'ttySLM56': device_add
[  271.121506] device: 'ttySLM57': device_add
[  271.146643] device: 'ttySLM58': device_add
[  271.179336] device: 'ttySLM59': device_add
[  271.212020] device: 'ttySLM60': device_add
[  271.239956] device: 'ttySLM61': device_add
[  271.275321] device: 'ttySLM62': device_add
[  271.300666] device: 'ttySLM63': device_add
[  271.339642] device: 'ttySLM64': device_add
[  271.376266] device: 'ttySLM65': device_add
[  271.405523] device: 'ttySLM66': device_add
[  271.435603] device: 'ttySLM67': device_add
[  271.459337] device: 'ttySLM68': device_add
[  271.492013] device: 'ttySLM69': device_add
[  271.525051] device: 'ttySLM70': device_add
[  271.549946] device: 'ttySLM71': device_add
[  271.579623] device: 'ttySLM72': device_add
[  271.606613] device: 'ttySLM73': device_add
[  271.645265] device: 'ttySLM74': device_add
[  271.679845] device: 'ttySLM75': device_add
[  271.711491] device: 'ttySLM76': device_add
[  271.739475] device: 'ttySLM77': device_add
[  271.776314] device: 'ttySLM78': device_add
[  271.806268] device: 'ttySLM79': device_add
[  271.835613] device: 'ttySLM80': device_add
[  271.865509] device: 'ttySLM81': device_add
[  271.902829] device: 'ttySLM82': device_add
[  271.939202] device: 'ttySLM83': device_add
[  271.968182] device: 'ttySLM84': device_add
[  271.996357] device: 'ttySLM85': device_add
[  272.048368] device: 'ttySLM86': device_add
[  272.073319] device: 'ttySLM87': device_add
[  272.105822] device: 'ttySLM88': device_add
[  272.129545] device: 'ttySLM89': device_add
[  272.166648] device: 'ttySLM90': device_add
[  272.195975] device: 'ttySLM91': device_add
[  272.222838] device: 'ttySLM92': device_add
[  272.249764] device: 'ttySLM93': device_add
[  272.288548] device: 'ttySLM94': device_add
[  272.315146] device: 'ttySLM95': device_add
[  272.347809] device: 'ttySLM96': device_add
[  272.372380] device: 'ttySLM97': device_add
[  272.402991] device: 'ttySLM98': device_add
[  272.441611] device: 'ttySLM99': device_add
[  272.471805] device: 'ttySLM100': device_add
[  272.495186] device: 'ttySLM101': device_add
[  272.522833] device: 'ttySLM102': device_add
[  272.575827] device: 'ttySLM103': device_add
[  272.609411] device: 'ttySLM104': device_add
[  272.646506] device: 'ttySLM105': device_add
[  272.680648] device: 'ttySLM106': device_add
[  272.718293] device: 'ttySLM107': device_add
[  272.739434] device: 'ttySLM108': device_add
[  272.769956] device: 'ttySLM109': device_add
[  272.801625] device: 'ttySLM110': device_add
[  272.829509] device: 'ttySLM111': device_add
[  272.859839] device: 'ttySLM112': device_add
[  272.891966] device: 'ttySLM113': device_add
[  272.918844] device: 'ttySLM114': device_add
[  272.945547] device: 'ttySLM115': device_add
[  272.969871] device: 'ttySLM116': device_add
[  273.005941] device: 'ttySLM117': device_add
[  273.029671] device: 'ttySLM118': device_add
[  273.062524] device: 'ttySLM119': device_add
[  273.095417] device: 'ttySLM120': device_add
[  273.122668] device: 'ttySLM121': device_add
[  273.149446] device: 'ttySLM122': device_add
[  273.183311] device: 'ttySLM123': device_add
[  273.205822] device: 'ttySLM124': device_add
[  273.238166] device: 'ttySLM125': device_add
[  273.269198] device: 'ttySLM126': device_add
[  273.296204] device: 'ttySLM127': device_add
[  273.329750] SyncLink MultiPort driver $Revision: 4.38 $, tty major#245
[  273.345596] device class 'virtio-ports': registering
[  273.361631] bus: 'virtio': add driver virtio_console
[  273.371814] bus: 'virtio': add driver virtio_rproc_serial
[  273.388540] device class 'printer': registering
[  273.404574] lp: driver loaded but no devices found
[  273.405810] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[  273.422793] ac.o: No PCI boards found.
[  273.428180] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[  273.429703] sonypi: Sony Programmable I/O Controller Driver v1.26.
[  273.439441] device: 'nvram': device_add
[  273.478374] Non-volatile memory driver v1.3
[  273.479592] toshiba: not a supported Toshiba laptop
[  273.528880] device class 'ppdev': registering
[  273.541736] ppdev: user-space parallel port driver
[  273.543194] Registering platform device 'pc8736x_gpio.0'. Parent at plat=
form
[  273.550875] device: 'pc8736x_gpio.0': device_add
[  273.552328] bus: 'platform': add device pc8736x_gpio.0
[  273.578853] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[  273.586575] platform pc8736x_gpio.0: no device found
[  273.656632] bus: 'platform': remove device pc8736x_gpio.0
[  273.666429] nsc_gpio initializing
[  273.682675] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[  273.699374] Linux agpgart interface v0.103
[  273.706391] bus: 'pci': add driver agpgart-ali
[  273.719339] bus: 'pci': add driver agpgart-ati
[  273.729900] bus: 'pci': add driver agpgart-amdk7
[  273.745929] bus: 'pci': add driver agpgart-nvidia
[  273.759991] bus: 'pci': add driver agpgart-sis
[  273.776451] bus: 'pci': add driver agpgart-serverworks
[  273.792838] bus: 'pci': add driver agpgart-via
[  273.805713] device class 'cardman_4000': registering
[  273.815920] bus: 'pcmcia': add driver cm4000_cs
[  273.831795] device class 'cardman_4040': registering
[  273.841956] bus: 'pcmcia': add driver cm4040_cs
[  273.858298] bus: 'platform': add driver parport_pc
[  273.889513] bus: 'pnp': add driver parport_pc
[  273.898899] bus: 'pnp': driver_probe_device: matched device 00:04 with d=
river parport_pc
[  273.906369] bus: 'pnp': really_probe: probing driver parport_pc with dev=
ice 00:04
[  273.924487] parport_pc 00:04: reported by Plug and Play ACPI
[  273.941719] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[  273.982421] device: 'parport0': device_add
[  274.061783] device: 'lp0': device_add
[  274.102996] lp0: using parport0 (interrupt-driven).
[  274.108605] lp0: console ready
[  274.109723] driver: '00:04': driver_bound: bound to device 'parport_pc'
[  274.122378] bus: 'pnp': really_probe: bound device 00:04 to driver parpo=
rt_pc
[  274.129558] Registering platform device 'parport_pc.956'. Parent at plat=
form
[  274.142418] device: 'parport_pc.956': device_add
[  274.151662] bus: 'platform': add device parport_pc.956
[  274.159797] bus: 'platform': driver_probe_device: matched device parport=
_pc.956 with driver parport_pc
[  274.172928] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.956
[  274.184479] driver: 'parport_pc.956': driver_bound: bound to device 'par=
port_pc'
[  274.186118] bus: 'platform': really_probe: bound device parport_pc.956 t=
o driver parport_pc
[  274.219167] bus: 'platform': remove device parport_pc.956
[  274.251920] Registering platform device 'parport_pc.888'. Parent at plat=
form
[  274.261451] device: 'parport_pc.888': device_add
[  274.262858] bus: 'platform': add device parport_pc.888
[  274.291987] bus: 'platform': driver_probe_device: matched device parport=
_pc.888 with driver parport_pc
[  274.300867] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.888
[  274.302925] driver: 'parport_pc.888': driver_bound: bound to device 'par=
port_pc'
[  274.315640] bus: 'platform': really_probe: bound device parport_pc.888 t=
o driver parport_pc
[  274.339216] bus: 'platform': remove device parport_pc.888
[  274.357945] Registering platform device 'parport_pc.632'. Parent at plat=
form
[  274.359476] device: 'parport_pc.632': device_add
[  274.368777] bus: 'platform': add device parport_pc.632
[  274.385938] bus: 'platform': driver_probe_device: matched device parport=
_pc.632 with driver parport_pc
[  274.395839] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.632
[  274.412656] driver: 'parport_pc.632': driver_bound: bound to device 'par=
port_pc'
[  274.418931] bus: 'platform': really_probe: bound device parport_pc.632 t=
o driver parport_pc
[  274.444873] bus: 'platform': remove device parport_pc.632
[  274.456589] bus: 'pci': add driver parport_pc
[  274.478899] bus: 'pci': add driver parport_serial
[  274.498491] bus: 'platform': add driver ax88796-pp
[  274.751714] device: '1:0': device_add
[  274.774973] device: 'ram0': device_add
[  274.928948] bus: 'platform': add driver floppy
[  274.954324] Floppy drive(s): fd0 is 1.44M
[  275.076279] device: '1:1': device_add
[  275.099307] device: 'ram1': device_add
[  275.156397] device: '1:2': device_add
[  275.172956] device: 'ram2': device_add
[  275.246234] device: '1:3': device_add
[  275.269983] device: 'ram3': device_add
[  275.332283] device: '1:4': device_add
[  275.358393] device: 'ram4': device_add
[  275.446043] FDC 0 is a S82078B
[  275.505071] device: '1:5': device_add
[  275.531654] device: 'ram5': device_add
[  275.559031] Registering platform device 'floppy.0'. Parent at platform
[  275.569564] device: 'floppy.0': device_add
[  275.575526] bus: 'platform': add device floppy.0
[  275.595676] bus: 'platform': driver_probe_device: matched device floppy.=
0 with driver floppy
[  275.606057] bus: 'platform': really_probe: probing driver floppy with de=
vice floppy.0
[  275.614686] driver: 'floppy.0': driver_bound: bound to device 'floppy'
[  275.616126] bus: 'platform': really_probe: bound device floppy.0 to driv=
er floppy
[  275.641451] device: '2:0': device_add
[  275.668354] device: 'fd0': device_add
[  275.799685] device: '1:6': device_add
[  275.831437] device: 'ram6': device_add
[  275.882134] device: '1:7': device_add
[  275.903146] device: 'ram7': device_add
[  275.959192] device: '1:8': device_add
[  275.977381] device: 'ram8': device_add
[  276.032767] device: '1:9': device_add
[  276.055741] device: 'ram9': device_add
[  276.112681] device: '1:10': device_add
[  276.138703] device: 'ram10': device_add
[  276.191938] device: '1:11': device_add
[  276.218476] device: 'ram11': device_add
[  276.265459] device: '1:12': device_add
[  276.297906] device: 'ram12': device_add
[  276.339593] device: '1:13': device_add
[  276.365294] device: 'ram13': device_add
[  276.416551] device: '1:14': device_add
[  276.435588] device: 'ram14': device_add
[  276.492652] device: '1:15': device_add
[  276.521242] device: 'ram15': device_add
[  276.566144] brd: module loaded
[  276.575419] device: 'loop-control': device_add
[  276.632186] device: '7:0': device_add
[  276.669321] device: 'loop0': device_add
[  276.742198] device: '7:1': device_add
[  276.768748] device: 'loop1': device_add
[  276.833043] device: '7:2': device_add
[  276.858841] device: 'loop2': device_add
[  276.924719] device: '7:3': device_add
[  276.956136] device: 'loop3': device_add
[  277.031335] device: '7:4': device_add
[  277.052956] device: 'loop4': device_add
[  277.125351] device: '7:5': device_add
[  277.158499] device: 'loop5': device_add
[  277.248550] device: '7:6': device_add
[  277.289339] device: 'loop6': device_add
[  277.369532] device: '7:7': device_add
[  277.395779] device: 'loop7': device_add
[  277.466331] loop: module loaded
[  277.475901] Compaq SMART2 Driver (v 2.6.0)
[  277.486224] bus: 'pci': add driver cpqarray
[  277.499724] bus: 'pci': remove driver cpqarray
[  277.505731] driver: 'cpqarray': driver_release
[  277.518126] HP CISS Driver (v 3.6.26)
[  277.525765] bus: 'cciss': registered
[  277.552607] bus: 'pci': add driver cciss
[  277.569626] bus: 'pci': add driver DAC960
[  277.584908] device: 'dac960_gam': device_add
[  277.639186] bus: 'pci': add driver nvme
[  277.656621] bus: 'pci': add driver umem
[  277.681439] MM: desc_per_page =3D 128
[  277.694876] bus: 'virtio': add driver virtio_blk
[  277.696392] bus: 'virtio': driver_probe_device: matched device virtio1 w=
ith driver virtio_blk
[  277.704009] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio1
[  277.857736] blk-mq: CPU -> queue map
[  277.871142]   CPU 0 -> Queue 0
[  277.934080] BUG: unable to handle kernel paging request at ff7f5784
[  277.934080] IP: [<812fe4c7>] blk_mq_init_queue+0x5fa/0x6f7
[  277.934080] *pde =3D 06814067 *pte =3D 00000000=20
[  277.934080] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  277.934080] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g=
5754ab5 #98
[  277.934080] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  277.934080] task: 8d448000 ti: 8d444000 task.ti: 8d444000
[  277.934080] EIP: 0060:[<812fe4c7>] EFLAGS: 00000203 CPU: 0
[  277.934080] EIP is at blk_mq_init_queue+0x5fa/0x6f7
[  277.934080] EAX: 86906000 EBX: ff7f5740 ECX: 868f9088 EDX: 00000001
[  277.934080] ESI: 868c5550 EDI: 00000002 EBP: 8d445e3c ESP: 8d445df0
[  277.934080]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  277.934080] CR0: 8005003b CR2: ff7f5784 CR3: 02941000 CR4: 00000690
[  277.934080] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  277.934080] DR6: 00000000 DR7: 00000000
[  277.934080] Stack:
[  277.934080]  0000000a 86a17980 00000004 868eb780 00000000 00000000 86906=
6bc f3c6a740
[  277.934080]  ffffffff 00000d80 868af420 0000000a 8e5c8280 00000004 82772=
fec 86a18700
[  277.934080]  868eb780 868ee400 00000c54 8d445e7c 81424cc2 86e6e000 00000=
000 86e6e000
[  277.934080] Call Trace:
[  277.934080]  [<81424cc2>] virtblk_probe+0x165/0x579
[  277.934080]  [<813979f6>] ? vring_transport_features+0x12/0x22
[  277.934080]  [<813966da>] virtio_dev_probe+0xae/0xe3
[  277.934080]  [<813f8059>] driver_probe_device+0xf2/0x26e
[  277.934080]  [<813f8223>] __driver_attach+0x4e/0x6a
[  277.934080]  [<813f8223>] ? __driver_attach+0x4e/0x6a
[  277.934080]  [<813f6a02>] bus_for_each_dev+0x3e/0x68
[  277.934080]  [<813f7dc6>] driver_attach+0x14/0x16
[  277.934080]  [<813f81d5>] ? driver_probe_device+0x26e/0x26e
[  277.934080]  [<813f7098>] bus_add_driver+0xd9/0x1da
[  277.934080]  [<8130f114>] ? kset_find_obj+0x5d/0x65
[  277.934080]  [<813f8519>] driver_register+0x74/0xef
[  277.934080]  [<813f8519>] ? driver_register+0x74/0xef
[  277.934080]  [<81f88190>] ? mutex_unlock+0x8/0xa
[  277.934080]  [<8139676d>] register_virtio_driver+0x1d/0x1f
[  277.934080]  [<828bb2d1>] init+0x49/0x76
[  277.934080]  [<828bb288>] ? mm_init+0x151/0x151
[  277.934080]  [<8288e9d4>] do_one_initcall+0x95/0x126
[  277.934080]  [<828a85d6>] ? init_nls_iso8859_4+0xf/0xf
[  277.934080]  [<8288eb82>] kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<8288eb82>] ? kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<81f67d2c>] kernel_init+0x8/0xb4
[  277.934080]  [<81f8ac17>] ret_from_kernel_thread+0x1b/0x28
[  277.934080]  [<81f67d24>] ? rest_init+0x118/0x118
[  277.934080] Code: ff 8b 86 c0 00 00 00 8b 3c 98 3b 9e c4 00 00 00 72 b6 =
e9 e4 00 00 00 8b 8e b0 00 00 00 89 fa 89 f0 47 ff 51 04 8b 90 a8 00 00 00 =
<89> 53 44 8b 90 a8 00 00 00 8b 88 ac 00 00 00 89 1c 91 42 89 90
[  277.934080] EIP: [<812fe4c7>] blk_mq_init_queue+0x5fa/0x6f7 SS:ESP 0068:=
8d445df0
[  277.934080] CR2: 00000000ff7f5784
[  277.934080] ---[ end trace c7ec3499622b2c6b ]---
[  277.934080] ------------[ cut here ]------------
[  277.934080] WARNING: at /c/kernel-tests/src/linux/kernel/smp.c:248 smp_c=
all_function_single+0x64/0x121()
[  277.934080] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D      3.10.0-=
rc3-00011-g5754ab5 #98
[  277.934080] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  277.934080]  00000000 00000000 8d445bd4 81f79947 8d445bec 8102599a 8106b=
45e 00000000
[  277.934080]  8107fd56 00000000 8d445bfc 81025a2e 00000009 00000000 8d445=
c28 8106b45e
[  277.934080]  8d445c34 00000000 00000000 00000000 00000000 00000000 8d448=
000 00000006
[  277.934080] Call Trace:
[  277.934080]  [<81f79947>] dump_stack+0x16/0x18
[  277.934080]  [<8102599a>] warn_slowpath_common+0x43/0x5a
[  277.934080]  [<8106b45e>] ? smp_call_function_single+0x64/0x121
[  277.934080]  [<8107fd56>] ? perf_event_idx_default+0xc/0xc
[  277.934080]  [<81025a2e>] warn_slowpath_null+0xf/0x15
[  277.934080]  [<8106b45e>] smp_call_function_single+0x64/0x121
[  277.934080]  [<8107fdc6>] task_function_call+0x37/0x40
[  277.934080]  [<81084fb4>] ? __perf_event_task_sched_out+0x541/0x541
[  277.934080]  [<8107fde4>] perf_cgroup_exit+0x15/0x17
[  277.934080]  [<81070b76>] cgroup_exit+0x181/0x198
[  277.934080]  [<8102a149>] do_exit+0x29f/0x7b6
[  277.934080]  [<81027c9f>] ? kmsg_dump+0x1a/0x1a3
[  277.934080]  [<81027e17>] ? kmsg_dump+0x192/0x1a3
[  277.934080]  [<8100380e>] oops_end+0x7e/0x85
[  277.934080]  [<81f7417f>] no_context+0x156/0x160
[  277.934080]  [<81f74283>] __bad_area_nosemaphore+0xfa/0x104
[  277.934080]  [<8101f04b>] ? vmalloc_sync_all+0xfb/0xfb
[  277.934080]  [<81f7429a>] bad_area_nosemaphore+0xd/0x10
[  277.934080]  [<8101eee8>] __do_page_fault+0x35c/0x3c4
[  277.934080]  [<81063150>] ? __lock_is_held+0x24/0x3f
[  277.934080]  [<81063150>] ? __lock_is_held+0x24/0x3f
[  277.934080]  [<8101f04b>] ? vmalloc_sync_all+0xfb/0xfb
[  277.934080]  [<8101f053>] do_page_fault+0x8/0xd
[  277.934080]  [<81f8aa07>] error_code+0x5f/0x64
[  277.934080]  [<8101f04b>] ? vmalloc_sync_all+0xfb/0xfb
[  277.934080]  [<812fe4c7>] ? blk_mq_init_queue+0x5fa/0x6f7
[  277.934080]  [<81424cc2>] virtblk_probe+0x165/0x579
[  277.934080]  [<813979f6>] ? vring_transport_features+0x12/0x22
[  277.934080]  [<813966da>] virtio_dev_probe+0xae/0xe3
[  277.934080]  [<813f8059>] driver_probe_device+0xf2/0x26e
[  277.934080]  [<813f8223>] __driver_attach+0x4e/0x6a
[  277.934080]  [<813f8223>] ? __driver_attach+0x4e/0x6a
[  277.934080]  [<813f6a02>] bus_for_each_dev+0x3e/0x68
[  277.934080]  [<813f7dc6>] driver_attach+0x14/0x16
[  277.934080]  [<813f81d5>] ? driver_probe_device+0x26e/0x26e
[  277.934080]  [<813f7098>] bus_add_driver+0xd9/0x1da
[  277.934080]  [<8130f114>] ? kset_find_obj+0x5d/0x65
[  277.934080]  [<813f8519>] driver_register+0x74/0xef
[  277.934080]  [<813f8519>] ? driver_register+0x74/0xef
[  277.934080]  [<81f88190>] ? mutex_unlock+0x8/0xa
[  277.934080]  [<8139676d>] register_virtio_driver+0x1d/0x1f
[  277.934080]  [<828bb2d1>] init+0x49/0x76
[  277.934080]  [<828bb288>] ? mm_init+0x151/0x151
[  277.934080]  [<8288e9d4>] do_one_initcall+0x95/0x126
[  277.934080]  [<828a85d6>] ? init_nls_iso8859_4+0xf/0xf
[  277.934080]  [<8288eb82>] kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<8288eb82>] ? kernel_init_freeable+0x11d/0x1a2
[  277.934080]  [<81f67d2c>] kernel_init+0x8/0xb4
[  277.934080]  [<81f8ac17>] ret_from_kernel_thread+0x1b/0x28
[  277.934080]  [<81f67d24>] ? rest_init+0x118/0x118
[  277.934080] ---[ end trace c7ec3499622b2c6c ]---
[  278.531529] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[  278.531529]=20
[  278.533994] Rebooting in 10 seconds..
--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="5754ab54c1b28888e9700550585c5729fccbd15f-bisect.log"
Content-Transfer-Encoding: quoted-printable

git checkout e4aa937ec75df0eea0bee03bffa3303ad36c986b
Previous HEAD position was 5754ab5... blk-mq: timeout fixes
HEAD is now at e4aa937... Linux 3.10-rc3

2013-06-03-14:17:51 e4aa937ec75df0eea0bee03bffa3303ad36c986b reuse /kernel/=
i386-randconfig-i004-0527/e4aa937ec75df0eea0bee03bffa3303ad36c986b/vmlinuz-=
3.10.0-rc3

2013-06-03-14:17:59 detecting boot state 	987......	988.........	989...	991=
=2E	992...	993...	994..............	995.......	996.	997.	999.......	1000	10=
01..	1002......	1009	1013	1023	1037	1049	1057	1069	1082	1087	1099	1116	1124=
	1137	1158	1180	1191	1204	1220	1245	1259	1267	1284	1296	1305	1316	1334	1348=
	1355	1384 SUCCESS
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:e4aa937ec75df0eea0bee03bffa3303ad36c986b:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:e4aa937ec75df0eea0bee03bffa=
3303ad36c986b:bisect-mm-dmesg
bisect: good commit e4aa937ec75df0eea0bee03bffa3303ad36c986b
git bisect start 5754ab54c1b28888e9700550585c5729fccbd15f e4aa937ec75df0eea=
0bee03bffa3303ad36c986b --
Previous HEAD position was e4aa937... Linux 3.10-rc3
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[dc2978537d4353ef173e99b28287effeeb019dba] null_blk: multi queue aware bloc=
k test driver
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-03-15:11:48 dc2978537d4353ef173e99b28287effeeb019dba reuse /kernel/=
i386-randconfig-i004-0527/dc2978537d4353ef173e99b28287effeeb019dba/vmlinuz-=
3.10.0-rc3-00005-gdc29785

2013-06-03-15:11:56 detecting boot state 	644.	647	648	652	658	662.........=
=2E SUCCESS
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:dc2978537d4353ef173e99b28287effeeb019dba:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:dc2978537d4353ef173e99b2828=
7effeeb019dba:bisect-mm-dmesg
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[a9e8919f71fcbd545812f6bcdc53eaf7747a5281] direct-io: only inc/dec inode->i=
_dio_count for file systems
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-03-15:20:32 a9e8919f71fcbd545812f6bcdc53eaf7747a5281 reuse /kernel/=
i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/vmlinuz-=
3.10.0-rc3-00008-ga9e8919

2013-06-03-15:20:33 detecting boot state 	654 TEST FAILURE
Increasing repeat count from 62 to 477
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-24774-2013-06-03-11-58-23-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-24857-2013-06-03-11-58-40-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-24940-2013-06-03-11-58-00-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25021-2013-06-03-11-56-58-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25143-2013-06-03-11-58-04-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25240-2013-06-03-11-58-48-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25322-2013-06-03-11-58-37-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25454-2013-06-03-11-56-09-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25454-2013-06-03-12-01-56-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25539-2013-06-03-11-58-40-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25658-2013-06-03-11-58-40-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25772-2013-06-03-11-58-06-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25882-2013-06-03-11-56-14-3.10.0-rc3-00008-ga9e8919-2
/kernel/i386-randconfig-i004-0527/a9e8919f71fcbd545812f6bcdc53eaf7747a5281/=
dmesg-kvm-ant-25882-2013-06-03-12-01-45-3.10.0-rc3-00008-ga9e8919-2
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:a9e8919f71fcbd545812f6bcdc53eaf7747a5281:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:a9e8919f71fcbd545812f6bcdc5=
3eaf7747a5281:bisect-mm-dmesg
Bisecting: 0 revisions left to test after this (roughly 1 step)
[b70aa55ec9532d5f5d3e367e4cad8997b1135f86] virtio_blk: blk-mq support
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-03-15:21:06 b70aa55ec9532d5f5d3e367e4cad8997b1135f86 reuse /kernel/=
i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/vmlinuz-=
3.10.0-rc3-00007-gb70aa55

2013-06-03-15:21:11 detecting boot state 	676 TEST FAILURE
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24774-2013-06-03-12-10-07-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24774-2013-06-03-12-21-25-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24857-2013-06-03-12-10-36-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24857-2013-06-03-12-21-43-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24940-2013-06-03-12-09-21-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-24940-2013-06-03-12-19-53-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25021-2013-06-03-12-09-32-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25021-2013-06-03-12-20-30-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25143-2013-06-03-12-09-44-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25143-2013-06-03-12-20-30-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25143-2013-06-03-12-31-53-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25240-2013-06-03-12-10-40-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25240-2013-06-03-12-21-40-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25240-2013-06-03-12-33-40-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25322-2013-06-03-12-10-22-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25322-2013-06-03-12-21-32-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25454-2013-06-03-12-11-56-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25454-2013-06-03-12-22-41-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25539-2013-06-03-12-10-35-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25539-2013-06-03-12-22-02-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25658-2013-06-03-12-10-46-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25658-2013-06-03-12-22-07-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25658-2013-06-03-12-33-24-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25772-2013-06-03-12-09-24-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25772-2013-06-03-12-20-12-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25882-2013-06-03-12-12-04-3.10.0-rc3-00007-gb70aa55-3
/kernel/i386-randconfig-i004-0527/b70aa55ec9532d5f5d3e367e4cad8997b1135f86/=
dmesg-kvm-ant-25882-2013-06-03-12-22-47-3.10.0-rc3-00007-gb70aa55-3
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:b70aa55ec9532d5f5d3e367e4cad8997b1135f86:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:b70aa55ec9532d5f5d3e367e4ca=
d8997b1135f86:bisect-mm-dmesg
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[00060f37d61cce84b05ab265a1d3532fb83b1002] mtip32xx: basic mq support
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-03-15:21:41 00060f37d61cce84b05ab265a1d3532fb83b1002 reuse /kernel/=
i386-randconfig-i004-0527/00060f37d61cce84b05ab265a1d3532fb83b1002/vmlinuz-=
3.10.0-rc3-00006-g00060f3

2013-06-03-15:21:45 detecting boot state 	3132 SUCCESS
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:00060f37d61cce84b05ab265a1d3532fb83b1002:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:00060f37d61cce84b05ab265a1d=
3532fb83b1002:bisect-mm-dmesg
b70aa55ec9532d5f5d3e367e4cad8997b1135f86 is the first bad commit
commit b70aa55ec9532d5f5d3e367e4cad8997b1135f86
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 24 20:22:33 2013 +0200

    virtio_blk: blk-mq support
   =20
    Pretend we have 4 issue queues.
   =20
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

:040000 040000 7d966fca54bd32b533e050b1509097e5c051a2e6 26f2e93071d0ebaa562=
5554a35b1b3cf8cd90a94 M	drivers
bisect run success

2013-06-03-15:22:19 00060f37d61cce84b05ab265a1d3532fb83b1002 reuse /kernel/=
i386-randconfig-i004-0527/00060f37d61cce84b05ab265a1d3532fb83b1002/vmlinuz-=
3.10.0-rc3-00006-g00060f3

2013-06-03-15:22:32 detecting boot state 	3134 SUCCESS
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:00060f37d61cce84b05ab265a1d3532fb83b1002:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:00060f37d61cce84b05ab265a1d=
3532fb83b1002:bisect-mm-dmesg

2013-06-03-15:23:04 5754ab54c1b28888e9700550585c5729fccbd15f reuse /kernel/=
i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-=
3.10.0-rc3-00011-g5754ab5

2013-06-03-15:23:15 detecting boot state 	522 TEST FAILURE
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-24774-2013-06-03-11-27-14-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-24857-2013-06-03-10-58-17-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-24857-2013-06-03-11-10-00-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-24940-2013-06-03-10-58-08-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-24940-2013-06-03-11-10-00-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25021-2013-06-03-10-57-52-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25021-2013-06-03-11-09-38-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25143-2013-06-03-10-58-07-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25143-2013-06-03-11-09-43-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25240-2013-06-03-10-57-52-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25240-2013-06-03-11-09-23-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25240-2013-06-03-15-07-01-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25322-2013-06-03-10-58-18-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25322-2013-06-03-11-10-06-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25322-2013-06-03-15-08-07-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25454-2013-06-03-10-57-20-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25454-2013-06-03-11-08-33-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25539-2013-06-03-10-57-02-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25658-2013-05-28-15-53-50-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25658-2013-06-03-10-58-18-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25658-2013-06-03-11-10-10-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25658-2013-06-03-14-55-49-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25772-2013-06-03-10-58-18-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25772-2013-06-03-11-10-15-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25882-2013-06-03-10-57-31-3.10.0-rc3-00011-g5754ab5-98
/kernel/i386-randconfig-i004-0527/5754ab54c1b28888e9700550585c5729fccbd15f/=
dmesg-kvm-ant-25882-2013-06-03-11-08-56-3.10.0-rc3-00011-g5754ab5-98
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:5754ab54c1b28888e9700550585=
c5729fccbd15f:bisect-mm-dmesg
[detached HEAD 202b60e] Revert "virtio_blk: blk-mq support"
 1 file changed, 55 insertions(+), 73 deletions(-)

2013-06-03-15:23:47 202b60e0678542e0a26afe501e83d436904e9ba0 compiling

2013-06-03-15:27:36 detecting boot state 3.10.0-rc3-00012-g202b60e	0.	2	3	9=
	14	22	27	28	36	39	42	45	53	61.	65	78	82	86	95	101	108	112	116	120	124	132	=
142	147	150	152	156	157	158	161	163	169	175	177	181	184	188	193	195	198	203=
	204	212	221	222	223	231	235	239	244	249	258	261	265	269	272	279	282	286	29=
1	297	302	305	309	316	320	326	332	338	340	344	351	358	364	368	373	376	382	3=
89	394	402	404	412	421	427	439	442	446	452	459	464	469	476	479	482	489	498	=
506	512	514	522	526	529	534	547	554	564	578	585	597	611	622	629	642	652	661=
	669	683	696	716	733	741	754	770	781	791	799	812	824	833	842	864	868	881	89=
4	906	915	923	935	943	949	955	965	974	977	978.	979....	981...	982..	983	984=
=2E......	985	986...	987..	988	989	990............	991..	992	993.........	9=
94..	996......	997...	999................................................	1=
003	1013	1016..	1020	1026	1029	1035	1040	1046	1057	1062	1079	1090	1098	1106=
	1121	1132	1137.	1139	1142	1148	1159	1170	1175	1184	1199	1206	1211	1222	123=
4	1239	1249	1257	1269	1279	1285	1295	1306	1311	1321	1337	1352	1372	1407	142=
2	1428...	1429..	1430...	1431 SUCCESS
rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-i004-0527/block:new-queu=
e:202b60e0678542e0a26afe501e83d436904e9ba0:bisect-mm /kernel-tests/run-queu=
e/kvm/i386-randconfig-i004-0527/block:new-queue:202b60e0678542e0a26afe501e8=
3d436904e9ba0:bisect-mm-dmesg

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D
Fetching next

2013-06-03-18:14:56 6318c0ec14d5f7aea22987223e1a99dbda7b1fd0 compiling

2013-06-03-18:18:59 detecting boot state 3.10.0-rc4-next-20130603	0.	9	30	5=
7	76	109	125	158	173	192	236	264	291	320	356	402	420	452	485	518	540	574	60=
5	638	674	707	747	777	796	830	843	869	905	926	954	996	1012	1043	1065	1082	1=
131	1153	1166	1195	1219	1246	1263	1285	1313	1341	1352	1397	1417..	1420	1421=
	1423	1424..	1428......	1430..	1431 SUCCESS

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc3 Kernel Configuration
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
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
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
# CONFIG_STA2X11 is not set
CONFIG_X86_SUMMIT=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y

#
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
#
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
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
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
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
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_VEGAS is not set
CONFIG_DEFAULT_WESTWOOD=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="westwood"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPPORT=y
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=y
# CONFIG_IP_SET_HASH_NET is not set
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
CONFIG_IP_SET_LIST_SET=y
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_6LOWPAN is not set
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_GRCAN is not set
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_SJA1000_OF_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=y
CONFIG_CAN_PEAK_PCI=y
# CONFIG_CAN_PEAK_PCIEC is not set
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
# CONFIG_DONGLE is not set
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
CONFIG_TOSHIBA_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_ATH3K=y
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
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
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
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
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=y
CONFIG_PARIDE_PCD=y
CONFIG_PARIDE_PF=y
CONFIG_PARIDE_PT=y
CONFIG_PARIDE_PG=y

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=y
# CONFIG_PARIDE_BPCK6 is not set
CONFIG_PARIDE_COMM=y
# CONFIG_PARIDE_DSTR is not set
CONFIG_PARIDE_FIT2=y
# CONFIG_PARIDE_FIT3 is not set
CONFIG_PARIDE_EPAT=y
# CONFIG_PARIDE_EPATC8 is not set
# CONFIG_PARIDE_EPIA is not set
# CONFIG_PARIDE_FRIQ is not set
CONFIG_PARIDE_FRPW=y
# CONFIG_PARIDE_KBIC is not set
CONFIG_PARIDE_KTTI=y
CONFIG_PARIDE_ON20=y
CONFIG_PARIDE_ON26=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_OSD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
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
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
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
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
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
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBEVF=y
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
CONFIG_QLCNIC=y
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MDIO_BUS_MUX_MMIOREG=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
# CONFIG_HOSTAP_CS is not set
CONFIG_WL_TI=y

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=y
# CONFIG_X25_ASY is not set
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

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
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
# CONFIG_GIGASET_M101 is not set
CONFIG_GIGASET_DEBUG=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_HFCUSB=y
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_ISDN_HDLC=y

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
CONFIG_INPUT_JOYDEV=y
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
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

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
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

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
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_CPU_THERMAL=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_UCB1400_CORE is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
# CONFIG_VIDEO_IVTV is not set
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
# CONFIG_VIDEO_ZORAN_DC10 is not set
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX18_ALSA=y
CONFIG_VIDEO_CX23885=y
CONFIG_MEDIA_ALTERA_CI=y
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_RC=y
# CONFIG_VIDEO_SAA7134_DVB is not set
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
# CONFIG_DVB_AV7110_OSD is not set
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
CONFIG_DVB_BUDGET_AV=y
CONFIG_DVB_BUDGET_PATCH=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_PT1 is not set
# CONFIG_MANTIS_CORE is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=y
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
CONFIG_MEDIA_PARPORT_SUPPORT=y
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=y
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
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
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_TCM825X=y
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
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

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

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
# CONFIG_DVB_TDA10086 is not set
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
CONFIG_DVB_SP887X=y
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
CONFIG_DVB_DIB3000MC=y
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=y
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
# CONFIG_DVB_LG2160 is not set
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
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
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=y
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
# CONFIG_DVB_LGS8GXX is not set
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
# CONFIG_DVB_IT913X_FE is not set
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
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
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_TEA575X=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=y
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=y
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=y
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=y
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
CONFIG_SND_HDA_CODEC_CIRRUS=y
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_INPUT is not set
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
CONFIG_SND_VIA82XX_MODEM=y
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
# CONFIG_SND_USB is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SND_SIMPLE_CARD is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_WIIMOTE_EXT=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=y
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_ZIO=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
CONFIG_USB_R8A66597=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_GADGET_MUSB_HDRC=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
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
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=y
CONFIG_INFINIBAND_CXGB3_DEBUG=y
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
# CONFIG_INFINIBAND_SRP is not set
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_TPS80031 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_SNVS=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
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
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_ASUS_OLED=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_R8712U is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
CONFIG_TRANZPORT=y
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
CONFIG_DX_SEP=y
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
CONFIG_CRYSTALHD=y
CONFIG_CXT1E1=y
CONFIG_SBE_PMCC4_NCOMM=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
# CONFIG_WIMAX_GDM72XX_USB_PM is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=y
# CONFIG_USB_DWC2 is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
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
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
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
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
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
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
# CONFIG_XZ_DEC_BCJ is not set
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--CdrF4e02JqNVZeln--
