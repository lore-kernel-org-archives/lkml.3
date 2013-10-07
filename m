Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3JGAda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:33:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:60802 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3JGAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1046,1371106800"; 
   d="log'?scan'208";a="406300517"
Date: Mon, 7 Oct 2013 08:32:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [timer] INFO: trying to register non-static key.
Message-ID: <20131007003256.GA26004@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Russell,

Here is one more bug exposed by your patch. :)

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers

[    4.573351] INFO: trying to register non-static key.
[    4.573767] the code is fine but needs lockdep annotation.
[    4.574208] turning off the locking correctness validator.
[    4.574652] CPU: 1 PID: 345 Comm: trinity Not tainted 3.12.0-rc1 #76
[    4.575155]  00000000 00000000 8d47fc4c 813a8643 8da4bc90 8d47fc88 81090483 814dc094
[    4.575862]  8d47fc80 8106a187 00000006 8da4bc90 0000002a 00000002 8d47fcac 00000000
[    4.576581]  8d47fcd4 8da4bc90 8d47fcd4 00000000 8d47fcb4 81091242 00000000 00000000
[    4.576676] Call Trace:
[    4.576676]  [<813a8643>] dump_stack+0x4b/0x66
[    4.576676]  [<81090483>] __lock_acquire.isra.21+0x183/0x8e0
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<81091242>] lock_acquire+0x72/0x90
[    4.576676]  [<81049380>] ? process_timeout+0x10/0x10
[    4.576676]  [<810493e9>] call_timer_fn+0x69/0xe0
[    4.576676]  [<81049380>] ? process_timeout+0x10/0x10
[    4.576676]  [<810495b1>] run_timer_softirq+0x151/0x180
[    4.576676]  [<810437e5>] __do_softirq+0xa5/0x160
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<8108d754>] ? tick_nohz_handler+0xd4/0xe0
[    4.576676]  [<810439b7>] irq_exit+0x47/0xa0
[    4.576676]  [<810279b5>] smp_apic_timer_interrupt+0x35/0x50
[    4.576676]  [<813af0f1>] apic_timer_interrupt+0x31/0x38
[    4.576676]  [<8110007b>] ? shrink_dentry_list+0x15b/0x420
[    4.576676]  [<8118da90>] ? do_raw_spin_lock+0x120/0x120
[    4.576676]  [<813adfe9>] ? _raw_spin_lock+0x49/0x70
[    4.576676]  [<81101154>] ? __d_lookup+0x94/0x1a0
[    4.576676]  [<81101154>] __d_lookup+0x94/0x1a0
[    4.576676]  [<811010c0>] ? __d_lookup_rcu+0x160/0x160
[    4.576676]  [<810f652d>] ? inode_permission+0x3d/0x50
[    4.576676]  [<810f5da0>] lookup_fast+0x180/0x250
[    4.576676]  [<810f75d3>] path_lookupat+0x573/0x650
[    4.576676]  [<810e4a19>] ? kmem_cache_alloc+0x39/0x130
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<810f63a0>] ? getname_flags+0x20/0xf0
[    4.576676]  [<810f76d1>] filename_lookup.isra.47+0x21/0x60
[    4.576676]  [<810f9fd9>] user_path_at_empty+0x49/0x70
[    4.576676]  [<810f1192>] ? cp_new_stat64+0xf2/0x110
[    4.576676]  [<810fa01a>] user_path_at+0x1a/0x20
[    4.576676]  [<810f0d84>] vfs_fstatat+0x44/0x90
[    4.576676]  [<810f1591>] SyS_lstat64+0x21/0x40
[    4.576676]  [<813aedec>] ? syscall_exit+0x8/0x21
[    4.576676]  [<813aede0>] syscall_call+0x7/0xb
[    4.576676]  [<813a0000>] ? vsock_addr_init+0x20/0x20
[    4.591703] kernel tried to execute NX-protected page - exploit attempt? (uid: 65534)
[    4.592335] BUG: unable to handle kernel paging request at 8da3b054

git bisect start 272b98c6455f00884f0350f775c5342358ebb73f v3.11 --
git bisect  bad 57d730924d5cc2c3e280af16a9306587c3a511db  # 18:27     23-  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad a9238741987386bb549d61572973c7e62b2a4145  # 18:32     21-  Merge tag 'pci-v3.12-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect good 91121c103ae93ef117e58712786864270d7f488e  # 19:11   5000+  staging: dwc2: make dwc2_core_params documentation more complete
git bisect good 1d1fdd95df681f0c065d90ffaafa215a0e8825e2  # 20:37   5000+  Merge tag 'char-misc-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect  bad d472d9d98b463dd7a04f2bcdeafe4261686ce6ab  # 20:43    171-  lockref: Relax in cmpxchg loop
git bisect good e438ac9ade074932383bb00d51b8ded8a0ee164b  # 00:05   5000+  OMAP: serial: Remove incorrect disabling of IER interrupt
git bisect  bad 36c27a655a531f16b5567066600f0ea7fcb973b4  # 00:15    793-  w1: add attribute groups to struct w1_family_ops
git bisect  bad 13e2237f36874a7abef44b98969f399127b1917d  # 00:19     63-  v4l2: convert class code to use dev_groups
git bisect  bad 3499116b915e260b275c167a471e0e05bbe3f1d6  # 00:25    134-  PTP: convert class code to use dev_groups
git bisect  bad 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e  # 00:34    574-  dma: convert dma_devclass to use dev_groups
git bisect good 899826f16a034f1ab6d23cd5b60cd113eaefad19  # 02:10   5000+  enclosure: convert class code to use dev_groups
git bisect good ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b  # 03:03   5000+  c2port: convert class code to use bin_attrs in groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 03:09    118-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 09:40   5000+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 19:35  10000+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 00:00  10000+  char: tile-srom: fix build error
git bisect  bad e62063d69911886a5a92c719d262a2a87e1e5b60  # 00:09    157-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 00:16     63-  Add linux-next specific files for 20130927

Thanks,
Fengguang

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-nhm4-3:20131005010557:i386-randconfig-c1-1003:3.12.0-rc1:76"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.12.0-rc1 (kbuild@cairo) (gcc version 4.8.1 (=
Debian 4.8.1-8) ) #76 SMP Thu Oct 3 20:35:54 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x025fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] BRK [0x01c8d000, 0x01c8dfff] PGTABLE
[    0.000000] BRK [0x01c8e000, 0x01c90fff] PGTABLE
[    0.000000] BRK [0x01c91000, 0x01c91fff] PGTABLE
[    0.000000] BRK [0x01c92000, 0x01c92fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128708(98%)
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
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
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffd000-0x0fffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000] max_low_pfn =3D fffe, highstart_pfn =3D fffe
[    0.000000] Low memory ends at vaddr 8fffe000
[    0.000000] High memory starts at vaddr 8fffe000
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, boot clock
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   1=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: fffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   100 4100 8100 c100=20
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8fffd000, node_mem_map 8f=
2e4020
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
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @8f04c000 s1339168 r0 d20704 =
u1359872
[    0.000000] pcpu-alloc: s1339168 r0 d20704 u1359872 alloc=3D332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f04e7c0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-c1-1003/stericsson:bh1780gli=
/.vmlinuz-272b98c6455f00884f0350f775c5342358ebb73f-20131004225309-94-snb-re=
try-nhm4 branch=3Dstericsson/bh1780gli BOOT_IMAGE=3D/kernel/i386-randconfig=
-c1-1003/272b98c6455f00884f0350f775c5342358ebb73f/vmlinuz-3.12.0-rc1
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 232548K/261744K available (3776K kernel code, 366K r=
wdata, 1708K rodata, 1644K init, 5260K bss, 29196K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff5fe000   (1774 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x815b8000 - 0x81753000   (1644 kB)
[    0.000000]       .data : 0x813b03a9 - 0x815b7bc0   (2078 kB)
[    0.000000]       .text : 0x81000000 - 0x813b03a9   (3776 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3200.220 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6403.12 Bogo=
MIPS (lpj=3D10667400)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] mce: CPU supports 10 MCE banks
[    0.006666] numa_add_cpu cpu 0 node 0: mask now 0
[    0.006678] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006678] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006678] tlb_flushall_shift: 6
[    0.008219] Freeing SMP alternatives memory: 16K (81753000 - 81757000)
[    0.010385] ACPI: Core revision 20130725
[    0.012744] ACPI: All ACPI Tables successfully acquired
[    0.013343] Getting VERSION: 50014
[    0.013632] Getting VERSION: 50014
[    0.013918] Getting ID: 0
[    0.014149] Getting ID: f000000
[    0.014415] Getting LVT0: 8700
[    0.014671] Getting LVT1: 8400
[    0.014931] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.015425] enabled ExtINT on CPU#0
[    0.016485] ENABLING IO-APIC IRQs
[    0.016674] init IO_APIC IRQs
[    0.016928]  apic 0 pin 0 not connected
[    0.017252] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.017925] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.018578] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.019241] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.020019] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.020661] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.021312] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.021962] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.022602] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.023352] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.024013] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.024668] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.025331] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.025993] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.026685] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.027344]  apic 0 pin 16 not connected
[    0.027659]  apic 0 pin 17 not connected
[    0.027986]  apic 0 pin 18 not connected
[    0.028300]  apic 0 pin 19 not connected
[    0.028615]  apic 0 pin 20 not connected
[    0.028936]  apic 0 pin 21 not connected
[    0.029251]  apic 0 pin 22 not connected
[    0.029568]  apic 0 pin 23 not connected
[    0.030140] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.030747] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.031613] Using local APIC timer interrupts.
[    0.031613] calibrating APIC timer ...
[    0.033333] ... lapic delta =3D 6256392
[    0.033333] ... PM-Timer delta =3D 358343
[    0.033333] ... PM-Timer result ok
[    0.033333] ..... delta 6256392
[    0.033333] ..... mult: 268710017
[    0.033333] ..... calibration result: 3336742
[    0.033333] ..... CPU clock speed is 3202.0951 MHz.
[    0.033333] ..... host bus clock speed is 1001.0409 MHz.
[    0.033385] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.034749] SMP alternatives: lockdep: fixing up alternatives
[    0.035398] CPU 1 irqstacks, hard=3D8007e000 soft=3D80110000
[    0.035997] smpboot: Booting Node   0, Processors  #1 OK
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:fffc021, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.006666] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.053384] Brought up 2 CPUs
[    0.053366] KVM setup async PF for cpu 1
[    0.053366] kvm-stealtime: cpu 1, msr f19a7c0
[    0.054347] ----------------
[    0.054579] | NMI testsuite:
[    0.056669] --------------------
[    0.056927]   remote IPI:  ok  |
[    0.066811]    local IPI:  ok  |
[    0.086675] --------------------
[    0.086943] Good, all   2 testcases passed! |
[    0.087317] ---------------------------------
[    0.087698] smpboot: Total of 2 processors activated (12806.25 BogoMIPS)
[    0.088519] CPU0 attaching sched-domain:
[    0.088848]  domain 0: span 0-1 level CPU
[    0.089206]   groups: 0 (cpu_power =3D 969) 1 (cpu_power =3D 1023)
[    0.089763] CPU1 attaching sched-domain:
[    0.090016]  domain 0: span 0-1 level CPU
[    0.090391]   groups: 1 (cpu_power =3D 1023) 0 (cpu_power =3D 969)
[    0.091008] devtmpfs: initialized
[    0.091008] regulator-dummy: no parameters
[    0.091467] NET: Registered protocol family 16
[    0.093579] EISA bus registered
[    0.093844] cpuidle: using governor ladder
[    0.094206] cpuidle: using governor menu
[    0.094630] ACPI: bus type PCI registered
[    0.095148] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.095793] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.096355] PCI: Using configuration type 1 for base access
[    0.097603] ACPI: Added _OSI(Module Device)
[    0.097603] ACPI: Added _OSI(Processor Device)
[    0.097603] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.097961] ACPI: Added _OSI(Processor Aggregator Device)
[    0.101331] ACPI: EC: Look up EC in DSDT
[    0.106454] ACPI: Interpreter enabled
[    0.106671] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.107438] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.108209] ACPI: (supports S0 S3 S5)
[    0.108517] ACPI: Using IOAPIC for interrupt routing
[    0.108930] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.118024] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.118568] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.119559] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.120049] PCI host bridge to bus 0000:00
[    0.120419] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.120889] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.121415] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.121946] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.122525] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.123373] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.124353] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.125460] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.129086] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.130823] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.131697] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.132266] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.133133] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.134469] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.136104] pci 0000:00:02.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.142159] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.143029] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.144275] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.145619] pci 0000:00:03.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.150910] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.151841] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.153337] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.154742] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.159833] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.160303] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.161299] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe3fff]
[    0.165426] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.166671] pci 0000:00:06.0: reg 0x10: [io  0xc040-0xc07f]
[    0.168010] pci 0000:00:06.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.173718] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.175131] pci 0000:00:07.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.176528] pci 0000:00:07.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.181779] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.183337] pci 0000:00:08.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.184674] pci 0000:00:08.0: reg 0x14: [mem 0xfebe8000-0xfebe8fff]
[    0.190306] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.191741] pci 0000:00:09.0: reg 0x10: [io  0xc100-0xc13f]
[    0.193085] pci 0000:00:09.0: reg 0x14: [mem 0xfebe9000-0xfebe9fff]
[    0.198389] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.199861] pci 0000:00:0a.0: reg 0x10: [io  0xc140-0xc17f]
[    0.200892] pci 0000:00:0a.0: reg 0x14: [mem 0xfebea000-0xfebeafff]
[    0.206707] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.208111] pci 0000:00:0b.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.209470] pci 0000:00:0b.0: reg 0x14: [mem 0xfebeb000-0xfebebfff]
[    0.214581] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.215540] pci 0000:00:0c.0: reg 0x10: [mem 0xfebec000-0xfebec00f]
[    0.220494] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.221164] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.221838] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.222518] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.223121] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.224033] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.224458] ACPI: \_SB_.PCI0: notify handler is installed
[    0.224968] Found 1 acpi root devices
[    0.225498] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.225498] vgaarb: loaded
[    0.226669] vgaarb: bridge control possible 0000:00:02.0
[    0.227285] pps_core: LinuxPPS API ver. 1 registered
[    0.227708] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.228461] PTP clock support registered
[    0.228790] PCI: Using ACPI for IRQ routing
[    0.229137] PCI: pci_cache_line_size set to 64 bytes
[    0.229732] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.230006] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.230701] irda_init()
[    0.230939] NET: Registered protocol family 23
[    0.231536] Switched to clocksource kvm-clock
[    0.231990] pnp: PnP ACPI init
[    0.232270] ACPI: bus type PNP registered
[    0.232646] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.233301] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.233301] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.233301] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.233693] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.234368] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.234951] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.235597] pnp 00:03: [dma 2]
[    0.235874] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.236454] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.237148] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.237732] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.238408] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.239261] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.239992] pnp: PnP ACPI: found 7 devices
[    0.240334] ACPI: bus type PNP unregistered
[    0.240681] PnPBIOS: Disabled
[    0.276345] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.276828] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.277273] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.277886] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.278483] NET: Registered protocol family 2
[    0.279080] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.279728] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.280458] TCP: Hash tables configured (established 2048 bind 2048)
[    0.281054] TCP: reno registered
[    0.281378] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.281926] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.282612] NET: Registered protocol family 1
[    0.283033] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.283582] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.284111] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.284684] pci 0000:00:02.0: Boot video device
[    0.285179] PCI: CLS 0 bytes, default 64
[    0.285616] Unpacking initramfs...
[    0.361277] Freeing initrd memory: 3120K (8fce4000 - 8fff0000)
[    0.362045] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.362535] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.363196] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.364072] cryptomgr_test (19) used greatest stack depth: 7332 bytes le=
ft
[    0.365244] kworker/u4:0 (27) used greatest stack depth: 7120 bytes left
[    0.365855] kworker/u4:0 (26) used greatest stack depth: 7108 bytes left
[    0.366725] cryptomgr_probe (30) used greatest stack depth: 6984 bytes l=
eft
[    0.367473] cryptomgr_test (24) used greatest stack depth: 6316 bytes le=
ft
[    0.368332] NatSemi SCx200 Driver
[    0.369376] Initializing RT-Tester: OK
[    0.369717] audit: initializing netlink socket (disabled)
[    0.370213] type=3D2000 audit(1380906346.492:1): initialized
[    0.370881] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.373714] VFS: Disk quotas dquot_6.5.2
[    0.374142] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.375201] msgmni has been set to 460
[    0.379309] alg: No test for stdrng (krng)
[    0.387019] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.387643] NET: Registered protocol family 38
[    0.388024] list_sort_test: start testing list_sort()
[    0.389150] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.389578] crc32: self tests passed, processed 225944 bytes in 156651 n=
sec
[    0.390347] crc32c: CRC_LE_BITS =3D 64
[    0.390645] crc32c: self tests passed, processed 225944 bytes in 93871 n=
sec
[    0.391208] rbtree testing -> 21211 cycles
[    1.085414] augmented rbtree testing -> 30418 cycles
[    2.078811] ipmi message handler version 39.2
[    2.079291] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.079899] ACPI: Power Button [PWRF]
[    2.080578] tsc: Refined TSC clocksource calibration: 3198.504 MHz
[    2.081118] isapnp: Scanning for PnP cards...
[    2.440991] isapnp: No Plug & Play device found
[    2.471471] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.493250] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.494484] Non-volatile memory driver v1.3
[    2.494986] nsc_gpio initializing
[    2.495309] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.495941] vcan: Virtual CAN interface driver
[    2.496297] YAM driver version 0.8 by F1OAT/F6FBB
[    2.497086] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.497086] baycom_par: version 0.9
[    2.498226] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.498694] hdlcdrv: version 0.8
[    2.498955] baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.498955] baycom_epp: version 0.7
[    2.500333] w83977af_init()
[    2.500571] w83977af_open()
[    2.500799] w83977af_probe()
[    2.501081] w83977af_probe(), Wrong chip version
[    2.501435] w83977af_probe()
[    2.501739] w83977af_probe(), Wrong chip version
[    2.502339] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.503631] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.504049] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.504717] parkbd: no such parport
[    2.505136] mousedev: PS/2 mouse device common for all mice
[    2.505966] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.506923] rtc_cmos 00:00: RTC can wake from S4
[    2.507439] rtc (null): alarm rollover: day
[    2.508464] rtc rtc0: rtc_cmos: dev (254:0)
[    2.508804] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.509381] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.510137] i2c /dev entries driver
[    2.510445] i2c-parport-light: adapter type unspecified
[    2.510881] isa i2c-pca-isa.0: Please specify I/O base
[    2.511350] pps_parport: parallel port PPS client
[    2.512065] power_supply test_ac: uevent
[    2.512389] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.512827] power_supply test_ac: prop ONLINE=3D1
[    2.513208] power_supply test_ac: power_supply_changed
[    2.513694] power_supply test_battery: uevent
[    2.514043] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.514561] power_supply test_battery: prop STATUS=3DDischarging
[    2.515023] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.515475] power_supply test_battery: prop HEALTH=3DGood
[    2.515889] power_supply test_battery: prop PRESENT=3D1
[    2.516288] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.516805] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.517292] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.517735] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.518160] power_supply test_battery: prop CAPACITY=3D50
[    2.518576] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.519057] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.519547] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.520059] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.520557] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.521017] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc1
[    2.521520] power_supply test_battery: prop TEMP=3D26
[    2.521907] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.522397] power_supply test_battery: power_supply_changed
[    2.522866] power_supply test_usb: uevent
[    2.523187] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.523707] power_supply test_usb: prop ONLINE=3D1
[    2.524087] power_supply test_usb: power_supply_changed
[    2.524568] platform eisa.0: Probing EISA bus 0
[    2.524982] platform eisa.0: EISA: Detected 0 cards
[    2.525618] power_supply test_ac: power_supply_changed_work
[    2.525639] ledtrig-cpu: registered to indicate activity on CPUs
[    2.525824] NET: Registered protocol family 26
[    2.525943] u32 classifier
[    2.525943]     Performance counters on
[    2.525943]     input device check on
[    2.525980] ipip: IPv4 over IPv4 tunneling driver
[    2.526145] TCP: veno registered
[    2.526146] TCP: illinois registered
[    2.526147] NET: Registered protocol family 3
[    2.526157] can: controller area network core (rev 20120528 abi 9)
[    2.526243] NET: Registered protocol family 29
[    2.526245] can: raw protocol (rev 20120528)
[    2.526251] can: broadcast manager protocol (rev 20120528 t)
[    2.526255] can: netlink gateway (rev 20130117) max_hops=3D1
[    2.526439] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    2.526547] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    2.526557] NET: Registered protocol family 12
[    2.526573] NET: Registered protocol family 35
[    2.526602] 9pnet: Installing 9P2000 support
[    2.526630] NET: Registered protocol family 37
[    2.526697] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility ve=
rsion 14) loaded
[    2.526899]=20
[    2.526899] printing PIC contents
[    2.526906] ... PIC  IMR: ffff
[    2.526910] ... PIC  IRR: 1113
[    2.526917] ... PIC  ISR: 0000
[    2.526921] ... PIC ELCR: 0c00
[    2.526926] printing local APIC contents on CPU#0/0:
[    2.526932] ... APIC ID:      00000000 (0)
[    2.526934] ... APIC VERSION: 00050014
[    2.526937] ... APIC TASKPRI: 00000000 (00)
[    2.526939] ... APIC PROCPRI: 00000000
[    2.526941] ... APIC LDR: 01000000
[    2.526944] ... APIC DFR: ffffffff
[    2.526946] ... APIC SPIV: 000001ff
[    2.526946] ... APIC ISR field:
[    2.526963] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.526963] ... APIC TMR field:
[    2.526980] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.526980] ... APIC IRR field:
[    2.526997] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.527001] ... APIC ESR: 00000000
[    2.527005] ... APIC ICR: 000008fd
[    2.527005] ... APIC ICR2: 02000000
[    2.527008] ... APIC LVTT: 000000ef
[    2.527010] ... APIC LVTPC: 00010000
[    2.527012] ... APIC LVT0: 00010700
[    2.527014] ... APIC LVT1: 00000400
[    2.527016] ... APIC LVTERR: 000000fe
[    2.527019] ... APIC TMICT: 00032b1a
[    2.527021] ... APIC TMCCT: 0002d900
[    2.527023] ... APIC TDCR: 00000003
[    2.527024]=20
[    2.527024] number of MP IRQ sources: 15.
[    2.527025] number of IO-APIC #0 registers: 24.
[    2.527025] testing the IO APIC.......................
[    2.527037] IO APIC #0......
[    2.527038] .... register #00: 00000000
[    2.527038] .......    : physical APIC id: 00
[    2.527038] .......    : Delivery Type: 0
[    2.527039] .......    : LTS          : 0
[    2.527039] .... register #01: 00170011
[    2.527040] .......     : max redirection entries: 17
[    2.527040] .......     : PRQ implemented: 0
[    2.527040] .......     : IO APIC version: 11
[    2.527041] .... register #02: 00000000
[    2.527041] .......     : arbitration: 00
[    2.527041] .... IRQ redirection table:
[    2.527050] 1    0    0   0   0    0    0    00
[    2.527058] 0    0    0   0   0    1    1    31
[    2.527067] 0    0    0   0   0    1    1    30
[    2.527075] 0    0    0   0   0    1    1    33
[    2.527084] 1    0    0   0   0    1    1    34
[    2.527092] 1    1    0   0   0    1    1    35
[    2.527101] 0    0    0   0   0    1    1    36
[    2.527109] 0    0    0   0   0    1    1    37
[    2.527118] 0    0    0   0   0    1    1    38
[    2.527126] 0    1    0   0   0    1    1    39
[    2.527135] 1    1    0   0   0    1    1    3A
[    2.527144] 1    1    0   0   0    1    1    3B
[    2.527152] 0    0    0   0   0    1    1    3C
[    2.527161] 0    0    0   0   0    1    1    3D
[    2.527169] 0    0    0   0   0    1    1    3E
[    2.527178] 0    0    0   0   0    1    1    3F
[    2.527186] 1    0    0   0   0    0    0    00
[    2.527195] 1    0    0   0   0    0    0    00
[    2.527203] 1    0    0   0   0    0    0    00
[    2.527212] 1    0    0   0   0    0    0    00
[    2.527220] 1    0    0   0   0    0    0    00
[    2.527229] 1    0    0   0   0    0    0    00
[    2.527237] 1    0    0   0   0    0    0    00
[    2.527246] 1    0    0   0   0    0    0    00
[    2.527246] IRQ to pin mappings:
[    2.527247] IRQ0 -> 0:2
[    2.527248] IRQ1 -> 0:1
[    2.527249] IRQ3 -> 0:3
[    2.527250] IRQ4 -> 0:4
[    2.527251] IRQ5 -> 0:5
[    2.527252] IRQ6 -> 0:6
[    2.527253] IRQ7 -> 0:7
[    2.527253] IRQ8 -> 0:8
[    2.527254] IRQ9 -> 0:9
[    2.527255] IRQ10 -> 0:10
[    2.527256] IRQ11 -> 0:11
[    2.527257] IRQ12 -> 0:12
[    2.527258] IRQ13 -> 0:13
[    2.527259] IRQ14 -> 0:14
[    2.527259] IRQ15 -> 0:15
[    2.527260] .................................... done.
[    2.527260] Using IPI No-Shortcut mode
[    2.527376] registered taskstats version 1
[    2.527761] Key type encrypted registered
[    2.528665] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.528665] EDD information not available.
[    2.528711] Unregister pv shared memory for cpu 0
[    2.528908] CPU0 attaching NULL sched-domain.
[    2.528912] CPU1 attaching NULL sched-domain.
[    2.528944] CPU1 attaching NULL sched-domain.
[    2.564594] power_supply test_ac: power_supply_update_gen_leds 1
[    2.565079] power_supply test_ac: uevent
[    2.565396] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.565832] power_supply test_ac: prop ONLINE=3D1
[    2.566231] numa_remove_cpu cpu 0 node 0: mask now 1
[    2.568789] CPU 0 is now offline
[    2.570325] Freeing unused kernel memory: 1644K (815b8000 - 81753000)
[    2.571044] Write protecting the kernel text: 3780k
[    2.571594] Write protecting the kernel read-only data: 1708k
[    2.572047] NX-protecting the kernel data: 4412k
[    2.573124] power_supply test_battery: power_supply_changed_work
[    2.573635] power_supply test_battery: power_supply_update_bat_leds 2
[    2.574151] power_supply test_battery: uevent
[    2.574507] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.575019] power_supply test_battery: prop STATUS=3DDischarging
[    2.575491] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.575942] power_supply test_battery: prop HEALTH=3DGood
[    2.576366] power_supply test_battery: prop PRESENT=3D1
[    2.576787] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.577247] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.577744] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.578190] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.578626] power_supply test_battery: prop CAPACITY=3D50
[    2.579045] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.579536] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.580052] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.580548] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.581049] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.581522] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc1
[    2.582028] power_supply test_battery: prop TEMP=3D26
[    2.582425] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.582888] power_supply test_usb: power_supply_changed_work
[    2.583387] power_supply test_usb: power_supply_update_gen_leds 1
[    2.583871] power_supply test_usb: uevent
[    2.584193] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.584656] power_supply test_usb: prop ONLINE=3D1

/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
Starting udev
error initializing inotify
error sending message: Connection refused
[    2.640933] power_supply test_ac: uevent
[    2.641268] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.641722] power_supply test_ac: prop ONLINE=3D1
[    2.642115] power_supply test_battery: uevent
[    2.642477] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.642991] power_supply test_battery: prop STATUS=3DDischarging
[    2.643498] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.643955] power_supply test_battery: prop HEALTH=3DGood
[    2.644380] power_supply test_battery: prop PRESENT=3D1
[    2.644784] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.645244] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.645740] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.646189] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.646625] power_supply test_battery: prop CAPACITY=3D50
[    2.647063] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.647561] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.648058] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.648550] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.649052] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.649521] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc1
[    2.650040] power_supply test_battery: prop TEMP=3D26
[    2.650440] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.650929] power_supply test_usb: uevent
[    2.651258] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.651724] power_supply test_usb: prop ONLINE=3D1
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under /d=
ev
bootlogd.
Configuring network interfaces... done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
/etc/init.d/modutils.sh: line 21: depmod: command not found
[    2.967540] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    3.338224] trinity uses obsolete (PF_INET,SOCK_PACKET)
[    3.389511] can: request_module (can-proto-3) failed.
[    3.445154] can: request_module (can-proto-0) failed.
[    3.488424] can: request_module (can-proto-3) failed.
[    3.499202] can: request_module (can-proto-3) failed.
[    3.516048] can: request_module (can-proto-0) failed.
[    3.565898] can: request_module (can-proto-3) failed.
[    3.574112] can: request_module (can-proto-0) failed.
[    3.588240] can: request_module (can-proto-0) failed.
[    3.611256] can: request_module (can-proto-0) failed.
[    3.635778] can: request_module (can-proto-0) failed.
[    4.573351] INFO: trying to register non-static key.
[    4.573767] the code is fine but needs lockdep annotation.
[    4.574208] turning off the locking correctness validator.
[    4.574652] CPU: 1 PID: 345 Comm: trinity Not tainted 3.12.0-rc1 #76
[    4.575155]  00000000 00000000 8d47fc4c 813a8643 8da4bc90 8d47fc88 81090=
483 814dc094
[    4.575862]  8d47fc80 8106a187 00000006 8da4bc90 0000002a 00000002 8d47f=
cac 00000000
[    4.576581]  8d47fcd4 8da4bc90 8d47fcd4 00000000 8d47fcb4 81091242 00000=
000 00000000
[    4.576676] Call Trace:
[    4.576676]  [<813a8643>] dump_stack+0x4b/0x66
[    4.576676]  [<81090483>] __lock_acquire.isra.21+0x183/0x8e0
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<81091242>] lock_acquire+0x72/0x90
[    4.576676]  [<81049380>] ? process_timeout+0x10/0x10
[    4.576676]  [<810493e9>] call_timer_fn+0x69/0xe0
[    4.576676]  [<81049380>] ? process_timeout+0x10/0x10
[    4.576676]  [<810495b1>] run_timer_softirq+0x151/0x180
[    4.576676]  [<810437e5>] __do_softirq+0xa5/0x160
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<8108d754>] ? tick_nohz_handler+0xd4/0xe0
[    4.576676]  [<810439b7>] irq_exit+0x47/0xa0
[    4.576676]  [<810279b5>] smp_apic_timer_interrupt+0x35/0x50
[    4.576676]  [<813af0f1>] apic_timer_interrupt+0x31/0x38
[    4.576676]  [<8110007b>] ? shrink_dentry_list+0x15b/0x420
[    4.576676]  [<8118da90>] ? do_raw_spin_lock+0x120/0x120
[    4.576676]  [<813adfe9>] ? _raw_spin_lock+0x49/0x70
[    4.576676]  [<81101154>] ? __d_lookup+0x94/0x1a0
[    4.576676]  [<81101154>] __d_lookup+0x94/0x1a0
[    4.576676]  [<811010c0>] ? __d_lookup_rcu+0x160/0x160
[    4.576676]  [<810f652d>] ? inode_permission+0x3d/0x50
[    4.576676]  [<810f5da0>] lookup_fast+0x180/0x250
[    4.576676]  [<810f75d3>] path_lookupat+0x573/0x650
[    4.576676]  [<810e4a19>] ? kmem_cache_alloc+0x39/0x130
[    4.576676]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.576676]  [<810f63a0>] ? getname_flags+0x20/0xf0
[    4.576676]  [<810f76d1>] filename_lookup.isra.47+0x21/0x60
[    4.576676]  [<810f9fd9>] user_path_at_empty+0x49/0x70
[    4.576676]  [<810f1192>] ? cp_new_stat64+0xf2/0x110
[    4.576676]  [<810fa01a>] user_path_at+0x1a/0x20
[    4.576676]  [<810f0d84>] vfs_fstatat+0x44/0x90
[    4.576676]  [<810f1591>] SyS_lstat64+0x21/0x40
[    4.576676]  [<813aedec>] ? syscall_exit+0x8/0x21
[    4.576676]  [<813aede0>] syscall_call+0x7/0xb
[    4.576676]  [<813a0000>] ? vsock_addr_init+0x20/0x20
[    4.591703] kernel tried to execute NX-protected page - exploit attempt?=
 (uid: 65534)
[    4.592335] BUG: unable to handle kernel paging request at 8da3b054
[    4.592861] IP: [<8da3b054>] 0x8da3b053
[    4.593186] *pdpt =3D 0000000001757001 *pde =3D 800000000da001e3=20
[    4.593680] Oops: 0011 [#1] SMP=20
[    4.593969] Modules linked in:
[    4.594234] CPU: 1 PID: 345 Comm: trinity Not tainted 3.12.0-rc1 #76
[    4.594755] task: 8da4bc90 ti: 8d47e000 task.ti: 8d47e000
[    4.595029] EIP: 0060:[<8da3b054>] EFLAGS: 00010282 CPU: 1
[    4.595029] EIP is at 0x8da3b054
[    4.595029] EAX: 00000000 EBX: 00000102 ECX: 8107cadd EDX: 00000000
[    4.595029] ESI: 8da3b054 EDI: 00000000 EBP: 8d47fcf8 ESP: 8d47fcb8
[    4.595029]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    4.595029] CR0: 8005003b CR2: 8da3b054 CR3: 0d4d9000 CR4: 000006f0
[    4.595029] Stack:
[    4.595029]  810493ed 00000000 00000001 00000000 81049380 80108010 80108=
000 8da3b028
[    4.595029]  00000000 00000000 00000000 814ed124 00000001 8da3b048 80108=
000 00000000
[    4.595029]  8d47fd20 810495b1 80108a38 80108838 8da3b054 8159e8a0 8159e=
8a0 00000101
[    4.595029] Call Trace:
[    4.595029]  [<810493ed>] ? call_timer_fn+0x6d/0xe0
[    4.595029]  [<81049380>] ? process_timeout+0x10/0x10
[    4.595029]  [<810495b1>] run_timer_softirq+0x151/0x180
[    4.595029]  [<810437e5>] __do_softirq+0xa5/0x160
[    4.595029]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.595029]  [<8108d754>] ? tick_nohz_handler+0xd4/0xe0
[    4.595029]  [<810439b7>] irq_exit+0x47/0xa0
[    4.595029]  [<810279b5>] smp_apic_timer_interrupt+0x35/0x50
[    4.595029]  [<813af0f1>] apic_timer_interrupt+0x31/0x38
[    4.595029]  [<8110007b>] ? shrink_dentry_list+0x15b/0x420
[    4.595029]  [<8118da90>] ? do_raw_spin_lock+0x120/0x120
[    4.595029]  [<813adfe9>] ? _raw_spin_lock+0x49/0x70
[    4.595029]  [<81101154>] ? __d_lookup+0x94/0x1a0
[    4.595029]  [<81101154>] __d_lookup+0x94/0x1a0
[    4.595029]  [<811010c0>] ? __d_lookup_rcu+0x160/0x160
[    4.595029]  [<810f652d>] ? inode_permission+0x3d/0x50
[    4.595029]  [<810f5da0>] lookup_fast+0x180/0x250
[    4.595029]  [<810f75d3>] path_lookupat+0x573/0x650
[    4.595029]  [<810e4a19>] ? kmem_cache_alloc+0x39/0x130
[    4.595029]  [<8106a187>] ? sched_clock_cpu+0x117/0x130
[    4.595029]  [<810f63a0>] ? getname_flags+0x20/0xf0
[    4.595029]  [<810f76d1>] filename_lookup.isra.47+0x21/0x60
[    4.595029]  [<810f9fd9>] user_path_at_empty+0x49/0x70
[    4.595029]  [<810f1192>] ? cp_new_stat64+0xf2/0x110
[    4.595029]  [<810fa01a>] user_path_at+0x1a/0x20
[    4.595029]  [<810f0d84>] vfs_fstatat+0x44/0x90
[    4.595029]  [<810f1591>] SyS_lstat64+0x21/0x40
[    4.595029]  [<813aedec>] ? syscall_exit+0x8/0x21
[    4.595029]  [<813aede0>] syscall_call+0x7/0xb
[    4.595029]  [<813a0000>] ? vsock_addr_init+0x20/0x20
[    4.595029] Code: 00 00 00 00 00 00 00 ad 4e ad de ff ff ff ff ff ff ff =
ff 9c 8f 76 81 00 00 00 00 00 00 00 00 00 00 00 00 00 02 20 00 00 00 00 00 =
<54> b0 a3 8d 54 b0 a3 8d 00 00 00 00 00 00 00 00 28 b0 a3 8d b4
[    4.595029] EIP: [<8da3b054>] 0x8da3b054 SS:ESP 0068:8d47fcb8
[    4.595029] CR2: 000000008da3b054
[    4.595029] ---[ end trace 19e8bccad31bf8be ]---
[    4.595029] Kernel panic - not syncing: Fatal exception in interrupt
[    4.595029] Rebooting in 10 seconds..
BUG: kernel boot oops
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-1003/272b98c6455f00884f0350f775c5342358ebb73f/vmlinuz-3.12.0-rc1 -append =
'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf_len=3D8M i=
gnore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_e=
nabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0=
 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-=
randconfig-c1-1003/stericsson:bh1780gli/.vmlinuz-272b98c6455f00884f0350f775=
c5342358ebb73f-20131004225309-94-snb-retry-nhm4 branch=3Dstericsson/bh1780g=
li BOOT_IMAGE=3D/kernel/i386-randconfig-c1-1003/272b98c6455f00884f0350f775c=
5342358ebb73f/vmlinuz-3.12.0-rc1'  -initrd /kernel-tests/initrd/yocto-minim=
al-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,mo=
del=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::10643-:22 -net nic,vlan=3D1,=
model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i630=
0esb -soundhw hda -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-nhm4-3,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-nhm4-3,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-nhm4-3,media=3Ddi=
sk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-nhm4-3,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-nhm4-3,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-nhm4-3,media=3Ddisk,=
if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-nhm4-3 -serial file:/dev/shm/=
kboot/serial-yocto-nhm4-3 -daemonize -display none -monitor null=20

--LQksG6bCIzRHxTLp
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-272b98c6455f00884f0350f775c5342358ebb73f-i386-randconfig-c1-1003-INFO:-trying-to-register-non-static-key--37787.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDI3MmI5OGM2NDU1ZjAwODg0ZjAzNTBmNzc1YzUzNDIzNThlYmI3M2YK
SEVBRCBpcyBub3cgYXQgMjcyYjk4Yy4uLiBMaW51eCAzLjEyLXJjMQpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvc3Rlcmljc3Nv
bjpiaDE3ODBnbGk6MjcyYjk4YzY0NTVmMDA4ODRmMDM1MGY3NzVjNTM0MjM1OGViYjczZjpi
aXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQpbICAgMjMuODcwMTc5XSByYnRyZWUgdGVzdGlu
ZyAtPiAyNzA3NTUgY3ljbGVzClsgICAzMi44MjY3NTJdIGF1Z21lbnRlZCByYnRyZWUgdGVz
dGluZwpbICAgNDQuODMxMzA4XSBJTkZPOiByY3Vfc2NoZWQgZGV0ZWN0ZWQgc3RhbGxzIG9u
IENQVXMvdGFza3M6ClsgICA0NC44MzEzMDhdIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0xMDAzLzI3MmI5OGM2NDU1ZjAwODg0ZjAzNTBmNzc1YzUzNDIzNThlYmI3M2YvZG1lc2ct
eW9jdG8taW5uLTQ1OjIwMTMxMDA1MTc0MTIwOmkzODYtcmFuZGNvbmZpZy1jMS0xMDAzOjMu
MTIuMC1yYzE6NzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMTAwMy8yNzJiOThjNjQ1
NWYwMDg4NGYwMzUwZjc3NWM1MzQyMzU4ZWJiNzNmL2RtZXNnLXlvY3RvLW5obTQtMzoyMDEz
MTAwNTAxMDU1NzppMzg2LXJhbmRjb25maWctYzEtMTAwMzozLjEyLjAtcmMxOjc2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvMjcyYjk4YzY0NTVmMDA4ODRmMDM1MGY3NzVj
NTM0MjM1OGViYjczZi9kbWVzZy15b2N0by13YWltZWEtNToyMDEzMTAwNjAxNDA0NDppMzg2
LXJhbmRjb25maWctYzEtMTAwMzozLjEyLjAtcmMxOjc2CgpiaXNlY3Q6IGJhZCBjb21taXQg
MjcyYjk4YzY0NTVmMDA4ODRmMDM1MGY3NzVjNTM0MjM1OGViYjczZgpnaXQgY2hlY2tvdXQg
djMuMTEKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMjcyYjk4Yy4uLiBMaW51eCAzLjEy
LXJjMQpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL3N0ZXJpY3Nz
b246YmgxNzgwZ2xpOjZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2U6
YmlzZWN0LXNvdW5kCgoyMDEzLTEwLTA1LTE3OjQyOjM4IDZlNDY2NDUyNWIxZGIyOGY4YzRl
MTEzMDk1N2Y3MGE5NGMxOTIxM2UgY29tcGlsaW5nCjI3OCByZWFsICAxMjc2IHVzZXIgIDE0
OSBzeXMgIDUxMS4wNCUgY3B1IAlpMzg2LXJhbmRjb25maWctYzEtMTAwMwoKMjAxMy0xMC0w
NS0xNzo0ODo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAJMTIJMTA2CTExMy4uLi4u
Li4uLi4uLi4uLi4uLgkxNjUJMjQ4CTMzMAk0MTIJNDk0CTU3Ngk2NTkJNzQwCTgyMAk4OTkJ
OTgwCTEwNjEJMTE0MgkxMjI0CTEzMDYJMTM4OAkxNDcwCTE1NTIJMTYzMwkxNzE1CTE3OTcJ
MTg3OQkxOTYwCTIwNDIJMjA5OS4uCTIyODIJMjU2MgkyNzkxCTMwMDYJMzIyMwkzNDIyCTM2
MjMJMzgzNAk0MDE0CTQyMTkJNDQxMQk0NTkwCTQ4MDcJNDk5NQk1MDAwIFNVQ0NFU1MKCmJp
c2VjdDogZ29vZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCAyNzJiOThjNjQ1NWYw
MDg4NGYwMzUwZjc3NWM1MzQyMzU4ZWJiNzNmIHYzLjExIC0tClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDZlNDY2NDUuLi4gTGludXggMy4xMQpIRUFEIGlzIG5vdyBhdCBjMWJlNWE1
Li4uIExpbnV4IDMuOQpCaXNlY3Rpbmc6IDUwOTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbNTdkNzMwOTI0ZDVjYzJjM2UyODBhZjE2
YTkzMDY1ODdjM2E1MTFkYl0gTWVyZ2UgYnJhbmNoICd0aW1lcnMtdXJnZW50LWZvci1saW51
cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Rp
cC90aXAKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1jMS0xMDAzL3N0ZXJpY3Nzb246YmgxNzgwZ2xpOjU3ZDczMDkyNGQ1Y2MyYzNlMjgw
YWYxNmE5MzA2NTg3YzNhNTExZGI6YmlzZWN0LXNvdW5kCgoyMDEzLTEwLTA1LTE4OjIwOjMz
IDU3ZDczMDkyNGQ1Y2MyYzNlMjgwYWYxNmE5MzA2NTg3YzNhNTExZGIgY29tcGlsaW5nCjE3
NyByZWFsICAxMzAyIHVzZXIgIDE1OCBzeXMgIDgyMi4yMiUgY3B1IAlpMzg2LXJhbmRjb25m
aWctYzEtMTAwMwoKMjAxMy0xMC0wNS0xODoyNDoxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtMDUwNTgtZzU3ZDczMDkuCTMJNAkxMAkxOC4JMjMgVEVTVCBGQUlMVVJFCi9ldGMv
aW5pdC5kL21vZHV0aWxzLnNoOiBsaW5lIDIxOiBkZXBtb2Q6IGNvbW1hbmQgbm90IGZvdW5k
ClsgICAgMi4yNDYwMzhdIHRyaW5pdHkgdXNlcyBvYnNvbGV0ZSAoUEZfSU5FVCxTT0NLX1BB
Q0tFVCkKWyAgICAyLjI3NjcxMV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDQKWyAgICAyLjI3NzgwOF0gSVA6IFs8
ODEwNDk1NmY+XSBydW5fdGltZXJfc29mdGlycSsweGZmLzB4MTgwClsgICAgMi4yNzg2MzRd
ICpwZHB0ID0gMDAwMDAwMDAwZDRjNjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAg
ICAyLjI3OTQ1NF0gT29wczogMDAwMiBbIzFdIFNNUCAKWyAgICAyLjI3OTk2M10gTW9kdWxl
cyBsaW5rZWQgaW46ClsgICAgMi4yODAwMjVdIENQVTogMSBQSUQ6IDgzMyBDb21tOiBrd29y
a2VyL3U0OjAgTm90IHRhaW50ZWQgMy4xMS4wLTA1MDU4LWc1N2Q3MzA5ICMzMzQKWyAgICAy
LjI4MDAyNV0gdGFzazogOGRhNGU0ZjAgdGk6IDhkNTg4MDAwIHRhc2sudGk6IDhkNTg4MDAw
ClsgICAgMi4yODAwMjVdIEVJUDogMDA2MDpbPDgxMDQ5NTZmPl0gRUZMQUdTOiAwMDAxMDA0
NiBDUFU6IDEKWyAgICAyLjI4MDAyNV0gRUlQIGlzIGF0IHJ1bl90aW1lcl9zb2Z0aXJxKzB4
ZmYvMHgxODAKWyAgICAyLjI4MDAyNV0gRUFYOiAwMDAwMDAwMCBFQlg6IDgwMTllNDQ4IEVD
WDogMDAwMDAwMDAgRURYOiA4ZDU4OWRlMApbICAgIDIuMjgwMDI1XSBFU0k6IDgwMTA4MDAw
IEVESTogMDAwMDAwMDAgRUJQOiA4ZDU4OWRmNCBFU1A6IDhkNTg5ZGQ0ClsgICAgMi4yODAw
MjVdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAg
IDIuMjgwMDI1XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDQgQ1IzOiAwZDQ0YzAwMCBD
UjQ6IDAwMDAwNmYwClsgICAgMi4yODAwMjVdIFN0YWNrOgpbICAgIDIuMjgwMDI1XSAgODAx
MDhhMzggODAxMDg4MzggMDAwMDAwMDAgODAxOWU0NDggODE1OTQ3YzAgMDAwMDAxMDEgOGQ1
ODgwMDAgODE1NTUwODQKWyAgICAyLjI4MDAyNV0gIDhkNTg5ZTM4IDgxMDQzN2U1IDhkYTRk
MGMwIDhkNTg5ZTI4IDgxMDZhMTc3IDhkNTg5ZTJjIDgxMDg4MmM0IDAwMzJkY2Q1ClsgICAg
Mi4yODAwMjVdICAwNDIwODA0MCAwMDAwMDAwYSBmZmZlYTMxYyAwMDAwMDAwMSAwMDAwMDAw
MSAwMDAwMDEwMSAwMDAwMDAwMCA4ZDU4ODAwMApbICAgIDIuMjgwMDI1XSBDYWxsIFRyYWNl
OgpbICAgIDIuMjgwMDI1XSAgWzw4MTA0MzdlNT5dIF9fZG9fc29mdGlycSsweGE1LzB4MTYw
ClsgICAgMi4yODAwMjVdICBbPDgxMDZhMTc3Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxMTcv
MHgxMzAKWyAgICAyLjI4MDAyNV0gIFs8ODEwODgyYzQ+XSA/IHRpY2tfbm9oel9oYW5kbGVy
KzB4ZDQvMHhlMApbICAgIDIuMjgwMDI1XSAgWzw4MTA0MzliNz5dIGlycV9leGl0KzB4NDcv
MHhhMApbICAgIDIuMjgwMDI1XSAgWzw4MTAyNzk3NT5dIHNtcF9hcGljX3RpbWVyX2ludGVy
cnVwdCsweDM1LzB4NTAKWyAgICAyLjI4MDAyNV0gIFs8ODEzYTk3MDE+XSBhcGljX3RpbWVy
X2ludGVycnVwdCsweDMxLzB4MzgKWyAgICAyLjI4MDAyNV0gIFs8ODEwMzAwN2I+XSA/IGdl
dF9tYXRjaGluZ19zaWcrMHg4Yi8weGEwClsgICAgMi4yODAwMjVdICBbPDgxMDQwMDdiPl0g
PyB3aWxsX2JlY29tZV9vcnBoYW5lZF9wZ3JwKzB4Yi8weGIwClsgICAgMi4yODAwMjVdICBb
PDgxM2E4ZWJmPl0gPyBfcmF3X3dyaXRlX3VubG9ja19pcnErMHgxZi8weDQwClsgICAgMi4y
ODAwMjVdICBbPDgxMDQwNjkyPl0gcmVsZWFzZV90YXNrKzB4MzIyLzB4MzUwClsgICAgMi4y
ODAwMjVdICBbPDgxMDQwMzgzPl0gPyByZWxlYXNlX3Rhc2srMHgxMy8weDM1MApbICAgIDIu
MjgwMDI1XSAgWzw4MTA0MTQzOT5dIHdhaXRfY29uc2lkZXJfdGFzaysweDRlOS8weDlmMApb
ICAgIDIuMjgwMDI1XSAgWzw4MTA0MTAxMj5dID8gd2FpdF9jb25zaWRlcl90YXNrKzB4YzIv
MHg5ZjAKWyAgICAyLjI4MDAyNV0gIFs8ODEwNDFhMDM+XSBkb193YWl0KzB4YzMvMHgxZDAK
WyAgICAyLjI4MDAyNV0gIFs8ODEwNDFlYmI+XSBTeVNfd2FpdDQrMHg5Yi8weGMwClsgICAg
Mi4yODAwMjVdICBbPDgxMDQwMmQwPl0gPyBraWxsX29ycGhhbmVkX3BncnArMHhjMC8weGMw
ClsgICAgMi4yODAwMjVdICBbPDgxMDUxNmRjPl0gd2FpdF9mb3JfaGVscGVyKzB4N2MvMHhh
MApbICAgIDIuMjgwMDI1XSAgWzw4MTNhOWIxNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQr
MHgxYi8weDI4ClsgICAgMi4yODAwMjVdICBbPDgxMDUxNjYwPl0gPyBfX2NhbGxfdXNlcm1v
ZGVoZWxwZXIrMHg4MC8weDgwClsgICAgMi4yODAwMjVdIENvZGU6IDg5IDRkIGVjIDhiIDRh
IDFjIDg5IDRkIGYwIDg5IDM5IDg5IDQyIDE4IDg5IDQwIDA0IGViIDcxIDkwIDhiIDQzIDEw
IDhiIDdiIDE0IDg5IDQ1IGU4IDhiIDQzIDBjIDg5IDVlIDI4IDhiIDBiIDhiIDUzIDA0IDgz
IGUwIDAyIDw4OT4gNTEgMDQgODkgMGEgZjYgNDMgMGMgMDEgYzcgMDMgMDAgMDAgMDAgMDAg
YzcgNDMgMDQgMDAgMDIgMjAKWyAgICAyLjI4MDAyNV0gRUlQOiBbPDgxMDQ5NTZmPl0gcnVu
X3RpbWVyX3NvZnRpcnErMHhmZi8weDE4MCBTUzpFU1AgMDA2ODo4ZDU4OWRkNApbICAgIDIu
MjgwMDI1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDQKWyAgICAyLjI4MDAyNV0gLS0tWyBlbmQg
dHJhY2UgYzNmNWQyNWVkYTgyY2YwNyBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTEwMDMvNTdkNzMwOTI0ZDVjYzJjM2UyODBhZjE2YTkzMDY1ODdjM2E1MTFkYi9kbWVzZy15
b2N0by1pbm4tMjk6MjAxMzEwMDUxODI3MzA6aTM4Ni1yYW5kY29uZmlnLWMxLTEwMDM6My4x
MS4wLTA1MDU4LWc1N2Q3MzA5OjMzNAoKQmlzZWN0aW5nOiAyNTI4IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2E5MjM4NzQxOTg3Mzg2
YmI1NDlkNjE1NzI5NzNjN2U2MmIyYTQxNDVdIE1lcmdlIHRhZyAncGNpLXYzLjEyLWNoYW5n
ZXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9o
ZWxnYWFzL3BjaQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL3N0ZXJpY3Nzb246Ymgx
NzgwZ2xpOmE5MjM4NzQxOTg3Mzg2YmI1NDlkNjE1NzI5NzNjN2U2MmIyYTQxNDU6YmlzZWN0
LXNvdW5kCgoyMDEzLTEwLTA1LTE4OjI3OjQzIGE5MjM4NzQxOTg3Mzg2YmI1NDlkNjE1NzI5
NzNjN2U2MmIyYTQxNDUgY29tcGlsaW5nCjE3MCByZWFsICAxMzA3IHVzZXIgIDE1NyBzeXMg
IDg1OC45NyUgY3B1IAlpMzg2LXJhbmRjb25maWctYzEtMTAwMwoKMjAxMy0xMC0wNS0xODoz
MTowNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDI1MjktZ2E5MjM4NzQJNgkxMwky
MSBURVNUIEZBSUxVUkUKL2V0Yy9pbml0LmQvbW9kdXRpbHMuc2g6IGxpbmUgMjE6IGRlcG1v
ZDogY29tbWFuZCBub3QgZm91bmQKWyAgICAxLjI4NDMyMF0gaW5wdXQ6IEltRXhQUy8yIEdl
bmVyaWMgRXhwbG9yZXIgTW91c2UgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8x
L2lucHV0L2lucHV0MgpbICAgIDEuMzIwMDQ4XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwYwpbICAgIDEuMzIwNzMz
XSBJUDogWzw4MTA0OTk3MD5dIGdldF9uZXh0X3RpbWVyX2ludGVycnVwdCsweDE1MC8weDI2
MApbICAgIDEuMzIxMjkxXSAqcGRwdCA9IDAwMDAwMDAwMGRiOTQwMDEgKnBkZSA9IDAwMDAw
MDAwMDAwMDAwMDAgClsgICAgMS4zMjE4MjVdIE9vcHM6IDAwMDAgWyMxXSBTTVAgClsgICAg
MS4zMjIxNDFdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuMzIyNDQ1XSBDUFU6IDEgUElE
OiAwIENvbW06IHN3YXBwZXIvMSBOb3QgdGFpbnRlZCAzLjExLjAtMDI1MjktZ2E5MjM4NzQg
IzMzNQpbICAgIDEuMzIzMDg5XSB0YXNrOiA4MDA2YmM2MCB0aTogODAwNzQwMDAgdGFzay50
aTogODAwNzQwMDAKWyAgICAxLjMyMzM1OF0gRUlQOiAwMDYwOls8ODEwNDk5NzA+XSBFRkxB
R1M6IDAwMjEwMDE3IENQVTogMQpbICAgIDEuMzIzMzU4XSBFSVAgaXMgYXQgZ2V0X25leHRf
dGltZXJfaW50ZXJydXB0KzB4MTUwLzB4MjYwClsgICAgMS4zMjMzNThdIEVBWDogMDAwMDAw
MDAgRUJYOiBmZmZlYTIwMCBFQ1g6IDAwMDE1ZTAwIEVEWDogODAxMDg5NDgKWyAgICAxLjMy
MzM1OF0gRVNJOiAwMDAwMDAwMSBFREk6IGZmZmVhMjAwIEVCUDogODAwNzVlYjggRVNQOiA4
MDA3NWU3YwpbICAgIDEuMzIzMzU4XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6
IDAwZTAgU1M6IDAwNjgKWyAgICAxLjMyMzM1OF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAw
MDBjIENSMzogMGRhOGMwMDAgQ1I0OiAwMDAwMDZmMApbICAgIDEuMzIzMzU4XSBTdGFjazoK
WyAgICAxLjMyMzM1OF0gIDgwMDc1ZWEwIDAwZmZmZWEyIDNmZmVhMWZjIGZmZmVhMWZkIDgw
MTA4MDAwIDgwMTA4ODM4IDAwMDAwMDIyIDAwMDAwMDIyClsgICAgMS4zMjMzNThdICA4MDEw
ODgzOCA4MDEwOGEzOCA4MDEwOGMzOCA4MDEwOGUzOCA4ZjE5YWY0MCA0ZWFkOTk3YyAwMDAw
MDAwMCA4MDA3NWYwMApbICAgIDEuMzIzMzU4XSAgODEwODdmZTEgODAwNmJjNjAgODAwNzVm
MDggODEwNDMyNzAgZmZmZWEyZDggZmZmZWExZmQgNGVhZTQwZDIgMDAwMDAwMDAKWyAgICAx
LjMyMzM1OF0gQ2FsbCBUcmFjZToKWyAgICAxLjMyMzM1OF0gIFs8ODEwODdmZTE+XSBfX3Rp
Y2tfbm9oel9pZGxlX2VudGVyKzB4MWMxLzB4NDYwClsgICAgMS4zMjMzNThdICBbPDgxMDQz
MjcwPl0gPyBfX2RvX3NvZnRpcnErMHgxNDAvMHgxNjAKWyAgICAxLjMyMzM1OF0gIFs8ODEw
ODgzMWI+XSB0aWNrX25vaHpfaXJxX2V4aXQrMHgxYi8weDIwClsgICAgMS4zMjMzNThdICBb
PDgxMDQzM2U2Pl0gaXJxX2V4aXQrMHg4Ni8weGEwClsgICAgMS4zMjMzNThdICBbPDgxMDI3
NDI1Pl0gc21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MzUvMHg1MApbICAgIDEuMzIzMzU4
XSAgWzw4MTNhODBlMT5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MzEvMHgzOApbICAgIDEu
MzIzMzU4XSAgWzw4MTAyZTQyNT5dID8gbmF0aXZlX3NhZmVfaGFsdCsweDUvMHgxMApbICAg
IDEuMzIzMzU4XSAgWzw4MTAwOWE5OD5dIGRlZmF1bHRfaWRsZSsweDgvMHgxMApbICAgIDEu
MzIzMzU4XSAgWzw4MTAwYTFlMj5dIGFyY2hfY3B1X2lkbGUrMHgxMi8weDMwClsgICAgMS4z
MjMzNThdICBbPDgxMDdkZTM5Pl0gY3B1X3N0YXJ0dXBfZW50cnkrMHgxMTkvMHgxODAKWyAg
ICAxLjMyMzM1OF0gIFs8ODEwMjU4N2Y+XSBzdGFydF9zZWNvbmRhcnkrMHgyOWYvMHgyYjAK
WyAgICAxLjMyMzM1OF0gQ29kZTogZTggODkgNDUgYzQgOGIgNDUgYzggODMgZTAgM2YgODkg
NDUgZGMgODkgNDUgZTAgOGQgNzYgMDAgOGIgNTUgZDggODkgZmIgOGIgNGQgZTAgOGIgMDQg
Y2EgOGQgMTQgY2EgMzkgZDAgNzQgMjYgOGQgYjYgMDAgMDAgMDAgMDAgPGY2PiA0MCAwYyAw
MSA4OSBmYiA3NSAxMiA4YiA1OCAwOCBiZSAwMSAwMCAwMCAwMCA4OSBkOSAyOSBmOSAwZgpb
ICAgIDEuMzIzMzU4XSBFSVA6IFs8ODEwNDk5NzA+XSBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1
cHQrMHgxNTAvMHgyNjAgU1M6RVNQIDAwNjg6ODAwNzVlN2MKWyAgICAxLjMyMzM1OF0gQ1Iy
OiAwMDAwMDAwMDAwMDAwMDBjClsgICAgMS4zMjMzNThdIC0tLVsgZW5kIHRyYWNlIDg1Njcx
NmY0MjU3YzIzNjcgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL2E5MjM4
NzQxOTg3Mzg2YmI1NDlkNjE1NzI5NzNjN2U2MmIyYTQxNDUvZG1lc2cteW9jdG8taW5uLTQ1
OjIwMTMxMDA1MTgzMjI2OmkzODYtcmFuZGNvbmZpZy1jMS0xMDAzOjMuMTEuMC0wMjUyOS1n
YTkyMzg3NDozMzUKCkJpc2VjdGluZzogMTU4MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls5MTEyMWMxMDNhZTkzZWYxMTdlNTg3MTI3
ODY4NjQyNzBkN2Y0ODhlXSBzdGFnaW5nOiBkd2MyOiBtYWtlIGR3YzJfY29yZV9wYXJhbXMg
ZG9jdW1lbnRhdGlvbiBtb3JlIGNvbXBsZXRlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEw
MDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6OTExMjFjMTAzYWU5M2VmMTE3ZTU4NzEyNzg2ODY0
MjcwZDdmNDg4ZTpiaXNlY3Qtc291bmQKCjIwMTMtMTAtMDUtMTg6MzI6MzcgOTExMjFjMTAz
YWU5M2VmMTE3ZTU4NzEyNzg2ODY0MjcwZDdmNDg4ZSBjb21waWxpbmcKMTc4IHJlYWwgIDEy
OTcgdXNlciAgMTYyIHN5cyAgODE4LjU3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMS0xMDAz
CgoyMDEzLTEwLTA1LTE4OjM2OjAxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzUt
MDA5NDctZzkxMTIxYzEJNAk2CTEzCTI1CTI5CTMzCTUzCTk4CTEzMgkyMTkJMjg3CTM4MAk0
NjIJNTQ3CTY1Mgk3NDkJODM4CTkxOQkxMDE3CTEwNjcJMTE4NQkxMjg4CTEzNTcJMTQzOQkx
NTE3CTE2MTMJMTY2OAkxNzYxCTE4NDcJMTg4NwkxOTk3CTIwOTUJMjE5MwkyMjkyCTIzNzMJ
MjQ2NgkyNTMyCTI2MzMJMjcwOQkyNzE3CTI3NzcJMjc3OAkyOTYwCTMwNzgJMzE3OAkzMjY0
CTMzNjMJMzQ0MgkzNTI3CTM2MzQJMzcwOQkzNzc2CTM4NzUJMzk1OQk0MDQ1CTQxNDAJNDE5
Mgk0MzAxCTQzODcJNDQ1Ngk0NTU2CTQ1OTMJNDYwOQk0NjgzCTQ2ODkJNDY5NQk0NzkyCTQ4
ODkJNDk0OAk1MDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogNzk5IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzFkMWZkZDk1ZGY2ODFmMGMw
NjVkOTBmZmFhZmEyMTVhMGU4ODI1ZTJdIE1lcmdlIHRhZyAnY2hhci1taXNjLTMuMTItcmMx
JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3Jl
Z2toL2NoYXItbWlzYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL3N0ZXJpY3Nzb246
YmgxNzgwZ2xpOjFkMWZkZDk1ZGY2ODFmMGMwNjVkOTBmZmFhZmEyMTVhMGU4ODI1ZTI6Ymlz
ZWN0LXNvdW5kCgoyMDEzLTEwLTA1LTE5OjExOjAzIDFkMWZkZDk1ZGY2ODFmMGMwNjVkOTBm
ZmFhZmEyMTVhMGU4ODI1ZTIgY29tcGlsaW5nCjE5NCByZWFsICAxMjgzIHVzZXIgIDE1MSBz
eXMgIDczOS41MiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzEtMTAwMwoKMjAxMy0xMC0wNS0x
OToxNDo0NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDA3ODItZzFkMWZkZDkuLgkx
CTIJMy4uLi4uCTQuLi4uLi4uLi4uLi4uLgk1Li4JNy4uCTgJOS4JMTAuLi4JMTEuLi4uCTEy
LgkxMy4JMzgJNjgJMTE1CTE2NQkyMzcJMzA4CTM5MAk0NTQJNTI5CTYxNAk2NjkJNzMxCTc5
OQk4NzkJOTMzCTEwMTMJMTA4MAkxMTM0CTExOTEJMTI0OQkxMzE1CTEzOTYJMTQ3MgkxNTIy
CTE1ODUJMTY0MAkxNjg4CTE3NTQJMTc4MwkxODQ3CTE4OTgJMTkzMQkxOTkxCTIwMzYJMjEx
MQkyMTMyCTIyMDIJMjI0NgkyMzEzCTIzNTUJMjQxNgkyNDU4CTI0OTkJMjUzMQkyNTY3CTI2
MTUJMjY1OAkyNjg5CTI3MjYJMjc2MgkyODAwCTI4NTEJMjg5OAkyOTM3CTI5NjgJMzAwNgkz
MDQ4CTMwOTEJMzEzOQkzMTg0CTMyMjUJMzI0OQkzMjc5CTMzMjIJMzM0NAkzMzkwCTM0MjgJ
MzQ1NgkzNDg5CTM1MjIJMzU1NQkzNTkwCTM2MjIJMzY2NwkzNzA0CTM3MjcJMzc1NgkzNzkx
CTM4MjEJMzg1NAkzODgxCTM5MDIJMzkyNwkzOTY0CTM5ODcJNDAyNQk0MDc0CTQwOTMJNDEx
OQk0MTU2CTQxOTEJNDIyNgk0MjU0CTQyODEJNDMxMQk0MzM5Lgk0MzgwCTQ0MjgJNDQ2Mgk0
NTA5CTQ1NDEJNDU3Nwk0NjE4CTQ2NTIJNDY3Ngk0NzA2CTQ3MzgJNDc2OQk0ODA2CTQ4MzMJ
NDg2Mgk0ODk5CTQ5MjgJNDk1OAk0OTgxCTQ5ODgJNDk5OAk1MDAwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogNDQ3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5
IHN0ZXBzKQpbZDQ3MmQ5ZDk4YjQ2M2RkN2EwNGYyYmNkZWFmZTQyNjE2ODZjZTZhYl0gbG9j
a3JlZjogUmVsYXggaW4gY21weGNoZyBsb29wCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEw
MDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6ZDQ3MmQ5ZDk4YjQ2M2RkN2EwNGYyYmNkZWFmZTQy
NjE2ODZjZTZhYjpiaXNlY3Qtc291bmQKCjIwMTMtMTAtMDUtMjA6Mzc6NDggZDQ3MmQ5ZDk4
YjQ2M2RkN2EwNGYyYmNkZWFmZTQyNjE2ODZjZTZhYiBjb21waWxpbmcKMTY4IHJlYWwgIDEy
NzcgdXNlciAgMTQ4IHN5cyAgODQ4LjI2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMS0xMDAz
CgoyMDEzLTEwLTA1LTIwOjQwOjU5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wMjA4
MS1nZDQ3MmQ5ZC4JMzEJNzgJMTA4CTE3MSBURVNUIEZBSUxVUkUKd2ZnOiByZWJvb3RpbmcK
WyAgICAyLjEwMDcyN10gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMQpb
ICAgIDIuMTgwMDQyXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRl
ciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwYwpbICAgIDIuMTgxMTgyXSBJUDogWzw4MTA0OTk1
MD5dIGdldF9uZXh0X3RpbWVyX2ludGVycnVwdCsweDE1MC8weDI2MApbICAgIDIuMTgyMTQy
XSAqcGRwdCA9IDAwMDAwMDAwMGY4ZTEwMDEgKnBkZSA9IDAwMDAwMDAwMDAwMDAwMDAgClsg
ICAgMi4xODMwNDddIE9vcHM6IDAwMDAgWyMxXSBTTVAgClsgICAgMi4xODMzNTBdIE1vZHVs
ZXMgbGlua2VkIGluOgpbICAgIDIuMTgzMzUwXSBDUFU6IDEgUElEOiAwIENvbW06IHN3YXBw
ZXIvMSBOb3QgdGFpbnRlZCAzLjExLjAtMDIwODEtZ2Q0NzJkOWQgIzMzOApbICAgIDIuMTgz
MzUwXSB0YXNrOiA4MDA2YmM2MCB0aTogODAwNzQwMDAgdGFzay50aTogODAwNzQwMDAKWyAg
ICAyLjE4MzM1MF0gRUlQOiAwMDYwOls8ODEwNDk5NTA+XSBFRkxBR1M6IDAwMjEwMDAzIENQ
VTogMQpbICAgIDIuMTgzMzUwXSBFSVAgaXMgYXQgZ2V0X25leHRfdGltZXJfaW50ZXJydXB0
KzB4MTUwLzB4MjYwClsgICAgMi4xODMzNTBdIEVBWDogMDAwMDAwMDAgRUJYOiBmZmZlYTMw
MCBFQ1g6IDAwMDE1ZDAwIEVEWDogODAxMDg5NTAKWyAgICAyLjE4MzM1MF0gRVNJOiAwMDAw
MDAwMSBFREk6IGZmZmVhMzAwIEVCUDogODAwNzVlYjggRVNQOiA4MDA3NWU3YwpbICAgIDIu
MTgzMzUwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgK
WyAgICAyLjE4MzM1MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDBjIENSMzogMGY4OTcw
MDAgQ1I0OiAwMDAwMDZmMApbICAgIDIuMTgzMzUwXSBTdGFjazoKWyAgICAyLjE4MzM1MF0g
IDgwMDc1ZWEwIDAwZmZmZWEzIDNmZmVhMmZlIGZmZmVhMmZmIDgwMTA4MDAwIDgwMTA4ODM4
IDAwMDAwMDIzIDAwMDAwMDIzClsgICAgMi4xODMzNTBdICA4MDEwODgzOCA4MDEwOGEzOCA4
MDEwOGMzOCA4MDEwOGUzOCA4ZGJmNWY0MCA4MWYwMjgyNiAwMDAwMDAwMCA4MDA3NWYwMApb
ICAgIDIuMTgzMzUwXSAgODEwODdmYzEgODAwNmJjNjAgODAwNzVmMDggODEwNDMyNTAgZmZm
ZWEyZGYgZmZmZWEyZmYgODFmMDk0MTMgMDAwMDAwMDAKWyAgICAyLjE4MzM1MF0gQ2FsbCBU
cmFjZToKWyAgICAyLjE4MzM1MF0gIFs8ODEwODdmYzE+XSBfX3RpY2tfbm9oel9pZGxlX2Vu
dGVyKzB4MWMxLzB4NDYwClsgICAgMi4xODMzNTBdICBbPDgxMDQzMjUwPl0gPyBfX2RvX3Nv
ZnRpcnErMHgxNDAvMHgxNjAKWyAgICAyLjE4MzM1MF0gIFs8ODEwODgyZmI+XSB0aWNrX25v
aHpfaXJxX2V4aXQrMHgxYi8weDIwClsgICAgMi4xODMzNTBdICBbPDgxMDQzM2M2Pl0gaXJx
X2V4aXQrMHg4Ni8weGEwClsgICAgMi4xODMzNTBdICBbPDgxMDI3NDI1Pl0gc21wX2FwaWNf
dGltZXJfaW50ZXJydXB0KzB4MzUvMHg1MApbICAgIDIuMTgzMzUwXSAgWzw4MTNhN2I2MT5d
IGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MzEvMHgzOApbICAgIDIuMTgzMzUwXSAgWzw4MTAy
ZTQyNT5dID8gbmF0aXZlX3NhZmVfaGFsdCsweDUvMHgxMApbICAgIDIuMTgzMzUwXSAgWzw4
MTAwOWE5OD5dIGRlZmF1bHRfaWRsZSsweDgvMHgxMApbICAgIDIuMTgzMzUwXSAgWzw4MTAw
YTFlMj5dIGFyY2hfY3B1X2lkbGUrMHgxMi8weDMwClsgICAgMi4xODMzNTBdICBbPDgxMDdk
ZTE5Pl0gY3B1X3N0YXJ0dXBfZW50cnkrMHgxMTkvMHgxODAKWyAgICAyLjE4MzM1MF0gIFs8
ODEwMjU4N2Y+XSBzdGFydF9zZWNvbmRhcnkrMHgyOWYvMHgyYjAKWyAgICAyLjE4MzM1MF0g
Q29kZTogZTggODkgNDUgYzQgOGIgNDUgYzggODMgZTAgM2YgODkgNDUgZGMgODkgNDUgZTAg
OGQgNzYgMDAgOGIgNTUgZDggODkgZmIgOGIgNGQgZTAgOGIgMDQgY2EgOGQgMTQgY2EgMzkg
ZDAgNzQgMjYgOGQgYjYgMDAgMDAgMDAgMDAgPGY2PiA0MCAwYyAwMSA4OSBmYiA3NSAxMiA4
YiA1OCAwOCBiZSAwMSAwMCAwMCAwMCA4OSBkOSAyOSBmOSAwZgpbICAgIDIuMTgzMzUwXSBF
SVA6IFs8ODEwNDk5NTA+XSBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQrMHgxNTAvMHgyNjAg
U1M6RVNQIDAwNjg6ODAwNzVlN2MKWyAgICAyLjE4MzM1MF0gQ1IyOiAwMDAwMDAwMDAwMDAw
MDBjClsgICAgMi4xODMzNTBdIC0tLVsgZW5kIHRyYWNlIDA0MTgyMWQ5YTliOThiNGMgXS0t
LQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL2Q0NzJkOWQ5OGI0NjNkZDdhMDRm
MmJjZGVhZmU0MjYxNjg2Y2U2YWIvZG1lc2cteW9jdG8tamFrZXRvd24tMjU6MjAxMzEwMDUy
MDQyNDU6aTM4Ni1yYW5kY29uZmlnLWMxLTEwMDM6My4xMS4wLTAyMDgxLWdkNDcyZDlkOjMz
OAoKQmlzZWN0aW5nOiAxNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDggc3RlcHMpCltlNDM4YWM5YWRlMDc0OTMyMzgzYmIwMGQ1MWI4ZGVkOGEwZWUx
NjRiXSBPTUFQOiBzZXJpYWw6IFJlbW92ZSBpbmNvcnJlY3QgZGlzYWJsaW5nIG9mIElFUiBp
bnRlcnJ1cHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMTAwMy9zdGVyaWNzc29uOmJoMTc4
MGdsaTplNDM4YWM5YWRlMDc0OTMyMzgzYmIwMGQ1MWI4ZGVkOGEwZWUxNjRiOmJpc2VjdC1z
b3VuZAoKMjAxMy0xMC0wNS0yMDo0MzozMSBlNDM4YWM5YWRlMDc0OTMyMzgzYmIwMGQ1MWI4
ZGVkOGEwZWUxNjRiIGNvbXBpbGluZwoxNjYgcmVhbCAgMTI4NSB1c2VyICAxNDkgc3lzICA4
NTkuOTMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMKCjIwMTMtMTAtMDUtMjA6NDY6
NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNC0wMDE3Ni1nZTQzOGFjOQk5CTQ2
CTc3CTEyMQkxNjcJMjE5CTI1OAkzMjkJMzc4CTQzMwk0OTAJNTE5CTU2OAk2MTcJNjY3CTY4
NQk3NDYJNzgzCTg1Mgk5MDQJOTYxCTEwMTEJMTA1MAkxMTE2CTExNzUJMTIyMQkxMjU2Lgkx
MzY3LgkxNDU1CTE1MjAJMTU5NgkxNjQ1CTE2OTEJMTczNQkxNzk4CTE4NTAJMTg4NwkxOTIw
CTE5NDYJMTk2NgkxOTk1CTIwMTUJMjA0MwkyMDY2CTIwODgJMjEyMwkyMTU2CTIyMjMJMjI3
MAkyMjgwCTIzOTUJMjQ0OQkyNTExCTI1NjgJMjYwNwkyNjQ3CTI2ODQJMjcwMQkyNzc4CTI4
MTYJMjg0MQkyODg5CTI5ODIuCTI5ODcJMzEwMi4JMzIzMS4uCTM0MDcuLi4uLgkzNDU0CTM3
MjkJMzgwNi4uCTM4NTYJNDA1OAk0MTE2CTQyODgJNDU4NQk0NjkzCTQ5NDQuLgk0OTk3Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDMb
WzBtCgk0OTk5Lgk1MDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogODcgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClszNmMyN2E2NTVhNTMxZjE2
YjU1NjcwNjY2MDBmMGVhN2ZjYjk3M2I0XSB3MTogYWRkIGF0dHJpYnV0ZSBncm91cHMgdG8g
c3RydWN0IHcxX2ZhbWlseV9vcHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMTAwMy9zdGVy
aWNzc29uOmJoMTc4MGdsaTozNmMyN2E2NTVhNTMxZjE2YjU1NjcwNjY2MDBmMGVhN2ZjYjk3
M2I0OmJpc2VjdC1zb3VuZAoKMjAxMy0xMC0wNi0wMDowNToyOSAzNmMyN2E2NTVhNTMxZjE2
YjU1NjcwNjY2MDBmMGVhN2ZjYjk3M2I0IGNvbXBpbGluZwoxNzMgcmVhbCAgMTI3NyB1c2Vy
ICAxNDggc3lzICA4MjMuNzUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMKCjIwMTMt
MTAtMDYtMDA6MDg6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMy0wMDA4OC1n
MzZjMjdhNgk0MAk5NgkxNjUJMjEwCTI3NAkzMTUJMzYyCTQyNQk0OTUJNTQ1CTYyNQk2NzkJ
NzMxCTc5MyBURVNUIEZBSUxVUkUKbW91bnRhbGw6IHBseS1ldmVudC1sb29wLmM6NDk3OiBw
bHlfZXZlbnRfbG9vcF9uZXc6IEFzc2VydGlvbiBgbG9vcC0+ZXBvbGxfZmQgPj0gMCcgZmFp
bGVkLgpbICAgIDQuNzQ2NzY5XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0t
LS0KWyAgICA0Ljc0ODU3NV0ga2VybmVsIEJVRyBhdCAvYy93Zmcvc291bmQva2VybmVsL3Rp
bWVyLmM6MTA4NCEKWyAgICA0Ljc1MDA1M10gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBT
TVAgClsgICAgNC43NTAwNTNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDQuNzUwMDUzXSBD
UFU6IDEgUElEOiAxMTkgQ29tbTogdW1vdW50IE5vdCB0YWludGVkIDMuMTEuMC1yYzMtMDAw
ODgtZzM2YzI3YTYgIzM0MApbICAgIDQuNzUwMDUzXSB0YXNrOiA4Nzc3MTQyMCB0aTogOGY4
YjAwMDAgdGFzay50aTogOGY4YjAwMDAKWyAgICA0Ljc1MDA1M10gRUlQOiAwMDYwOls8ODEw
NGJmMjA+XSBFRkxBR1M6IDAwMDEwMDg2IENQVTogMQpbICAgIDQuNzUwMDUzXSBFSVAgaXMg
YXQgY2FzY2FkZSsweDUwLzB4ODAKWyAgICA0Ljc1MDA1M10gRUFYOiAwMDAwMDAwMCBFQlg6
IDgwMTA4MDAwIEVDWDogODAxMDg2YzggRURYOiAwMDAwMDAwMApbICAgIDQuNzUwMDUzXSBF
U0k6IDhmOGIxZGIwIEVESTogODAwOTFlNDggRUJQOiA4ZjhiMWRjNCBFU1A6IDhmOGIxZGFj
ClsgICAgNC43NTAwNTNdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBT
UzogMDA2OApbICAgIDQuNzUwMDUzXSBDUjA6IDgwMDUwMDMzIENSMjogNzc1ZGRmYjggQ1Iz
OiAwNzdiMjAwMCBDUjQ6IDAwMDAwNmYwClsgICAgNC43NTAwNTNdIFN0YWNrOgpbICAgIDQu
NzUwMDUzXSAgMDAwMDAwMjYgODc3ODllOTQgODc3YjljNTAgMDAwMDAwMDAgODAxMDgwMDAg
ODAxMDhhMzggOGY4YjFkZWMgODEwNGMxMjcKWyAgICA0Ljc1MDA1M10gIDgwMTA4YTM4IDgw
MTA4ODM4IDg3NzcxNDIwIDhmOGMyMGY4IDhmOGIxZGVjIDAwMDAwMTAxIDhmOGIwMDAwIDgx
NTUzMDg0ClsgICAgNC43NTAwNTNdICA4ZjhiMWUzMCA4MTA0NjQzNSA4ZjhjMjBmOCA4Zjhi
MWUyMCA4MTA2Y2Q5NyA4ZjhiMWUyNCA4MTA4N2IzNCAwMDMyZGNkNQpbICAgIDQuNzUwMDUz
XSBDYWxsIFRyYWNlOgpbICAgIDQuNzUwMDUzXSAgWzw4MTA0YzEyNz5dIHJ1bl90aW1lcl9z
b2Z0aXJxKzB4NzcvMHgxODAKWyAgICA0Ljc1MDA1M10gIFs8ODEwNDY0MzU+XSBfX2RvX3Nv
ZnRpcnErMHhhNS8weDE2MApbICAgIDQuNzUwMDUzXSAgWzw4MTA2Y2Q5Nz5dID8gc2NoZWRf
Y2xvY2tfY3B1KzB4MTE3LzB4MTMwClsgICAgNC43NTAwNTNdICBbPDgxMDg3YjM0Pl0gPyB0
aWNrX25vaHpfaGFuZGxlcisweGQ0LzB4ZTAKWyAgICA0Ljc1MDA1M10gIFs8ODEwNDY2MDc+
XSBpcnFfZXhpdCsweDQ3LzB4YTAKWyAgICA0Ljc1MDA1M10gIFs8ODEwMjc0NTU+XSBzbXBf
YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzNS8weDUwClsgICAgNC43NTAwNTNdICBbPDgxM2E3
OTQxPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzMS8weDM4ClsgICAgNC43NTAwNTNdICBb
PDgxMGQwMDdiPl0gPyBtb3ZlX3BhZ2VfdGFibGVzKzB4MmFiLzB4M2YwClsgICAgNC43NTAw
NTNdICBbPDgxMDYxYWI2Pl0gPyB1cF93cml0ZSsweDE2LzB4MzAKWyAgICA0Ljc1MDA1M10g
IFs8ODEwZDFiMWE+XSB1bmxpbmtfYW5vbl92bWFzKzB4ZGEvMHgxNjAKWyAgICA0Ljc1MDA1
M10gIFs8ODEzYTMzYjg+XSA/IG11dGV4X3VubG9jaysweDgvMHgxMApbICAgIDQuNzUwMDUz
XSAgWzw4MTBjNzIzYT5dIGZyZWVfcGd0YWJsZXMrMHg5YS8weDEwMApbICAgIDQuNzUwMDUz
XSAgWzw4MTBjZWU2Yz5dIGV4aXRfbW1hcCsweDhjLzB4MTAwClsgICAgNC43NTAwNTNdICBb
PDgxMDNjZDE4Pl0gbW1wdXQrMHg0OC8weGQwClsgICAgNC43NTAwNTNdICBbPDgxMDQzNWRj
Pl0gZG9fZXhpdCsweDJjYy8weDg3MApbICAgIDQuNzUwMDUzXSAgWzw4MTBlYjU0MT5dID8g
dmZzX3dyaXRlKzB4YjEvMHgxMjAKWyAgICA0Ljc1MDA1M10gIFs8ODEwNDQ4NmM+XSBkb19n
cm91cF9leGl0KzB4NmMvMHhiMApbICAgIDQuNzUwMDUzXSAgWzw4MTAyZGQwMD5dID8ga3Zt
X2FzeW5jX3BmX3Rhc2tfd2FrZSsweGQwLzB4ZDAKWyAgICA0Ljc1MDA1M10gIFs8ODEwNDQ4
YzE+XSBTeVNfZXhpdF9ncm91cCsweDExLzB4MjAKWyAgICA0Ljc1MDA1M10gIFs8ODEzYTdk
ZWI+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgIDQuNzUwMDUzXSBDb2RlOiAw
MCA4OSA0MCAwNCA4YiA0NSBlYyAzOSBmMCA4YiAzOCA3NCAzNSA4YiA1MCAwYyA4MyBlMiBm
YyAzOSBkMyA3NCAxYyBlYiAxMiA2NiA5MCA4YiA0NyAwYyA4MyBlMCBmYyAzOSBjMyA3NSAw
NiA4OSBmOCA4OSBkNyBlYiAwOCA8MGY+IDBiIDhkIGI2IDAwIDAwIDAwIDAwIDg5IGMyIDg5
IGQ4IGU4IGRmIGZkIGZmIGZmIDM5IGY3IDhiIDE3ClsgICAgNC43NTAwNTNdIEVJUDogWzw4
MTA0YmYyMD5dIGNhc2NhZGUrMHg1MC8weDgwIFNTOkVTUCAwMDY4OjhmOGIxZGFjClsgICAg
NC43NTAwNTNdIC0tLVsgZW5kIHRyYWNlIDgzNGFmZDg1NzhiNzljNzIgXS0tLQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzLzM2YzI3YTY1NWE1MzFmMTZiNTU2NzA2NjYwMGYw
ZWE3ZmNiOTczYjQvZG1lc2cteW9jdG8taW5uLTI5OjIwMTMxMDA2MDAxNTQ1OmkzODYtcmFu
ZGNvbmZpZy1jMS0xMDAzOjMuMTEuMC1yYzMtMDAwODgtZzM2YzI3YTY6MzQwCgpCaXNlY3Rp
bmc6IDQzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0
ZXBzKQpbMTNlMjIzN2YzNjg3NGE3YWJlZjQ0Yjk4OTY5ZjM5OTEyN2IxOTE3ZF0gdjRsMjog
Y29udmVydCBjbGFzcyBjb2RlIHRvIHVzZSBkZXZfZ3JvdXBzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWMxLTEwMDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6MTNlMjIzN2YzNjg3NGE3YWJlZjQ0
Yjk4OTY5ZjM5OTEyN2IxOTE3ZDpiaXNlY3Qtc291bmQKCjIwMTMtMTAtMDYtMDA6MTU6NTUg
MTNlMjIzN2YzNjg3NGE3YWJlZjQ0Yjk4OTY5ZjM5OTEyN2IxOTE3ZCBjb21waWxpbmcKMTYy
IHJlYWwgIDEyNDggdXNlciAgMTUzIHN5cyAgODYxLjYyJSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1jMS0xMDAzCgoyMDEzLTEwLTA2LTAwOjE4OjU3IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTEuMC1yYzMtMDAwNDQtZzEzZTIyMzcJMjYJNjMgVEVTVCBGQUlMVVJFCi9ldGMvaW5pdC5k
L21vZHV0aWxzLnNoOiBsaW5lIDIxOiBkZXBtb2Q6IGNvbW1hbmQgbm90IGZvdW5kClsgICAg
MS4zMzAwNDVdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEu
MzMwNTE2XSBrZXJuZWwgQlVHIGF0IC9jL3dmZy9zb3VuZC9rZXJuZWwvdGltZXIuYzoxMDg0
IQpbICAgIDEuMzMxMDYzXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUCAKWyAgICAx
LjMzMTQ3NF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS4zMzE3ODFdIENQVTogMSBQSUQ6
IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTEuMC1yYzMtMDAwNDQtZzEzZTIy
MzcgIzM0MQpbICAgIDEuMzMyNDk1XSB0YXNrOiA4MDA2YmM2MCB0aTogODAwNzQwMDAgdGFz
ay50aTogODAwNzQwMDAKWyAgICAxLjMzMjk5N10gRUlQOiAwMDYwOls8ODEwNGJmMjA+XSBF
RkxBR1M6IDAwMjEwMDg2IENQVTogMQpbICAgIDEuMzMzMzU4XSBFSVAgaXMgYXQgY2FzY2Fk
ZSsweDUwLzB4ODAKWyAgICAxLjMzMzM1OF0gRUFYOiAwMDAwMDAwMCBFQlg6IDgwMTA4MDAw
IEVDWDogODAxMDg1NzAgRURYOiAwMDAwMDAwMApbICAgIDEuMzMzMzU4XSBFU0k6IDgwMDc1
ZTg4IEVESTogODAxOWU0NDggRUJQOiA4MDA3NWU5YyBFU1A6IDgwMDc1ZTg0ClsgICAgMS4z
MzMzNThdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApb
ICAgIDEuMzMzMzU4XSBDUjA6IDgwMDUwMDNiIENSMjogNDdmNDA0NTAgQ1IzOiAwZGE3NjAw
MCBDUjQ6IDAwMDAwNmYwClsgICAgMS4zMzMzNThdIFN0YWNrOgpbICAgIDEuMzMzMzU4XSAg
MDAwMDAwMjIgODE1NWJmYTggOGQ0MzljNTAgMDAwMDAwMDAgODAxMDgwMDAgODAxMDhhMzgg
ODAwNzVlYzQgODEwNGMxMjcKWyAgICAxLjMzMzM1OF0gIDgwMTA4YTM4IDgwMTA4ODM4IDgw
MDZiYzYwIGZmZmVhMmQ4IDgwMDc1ZWM0IDAwMDAwMTAxIDgwMDc0MDAwIDgxNTUzMDg0Clsg
ICAgMS4zMzMzNThdICA4MDA3NWYwOCA4MTA0NjQzNSBmZmZlYTJkOCA4MDA3NWVmOCA4MTA2
Y2Q5NyA4MDA3NWVmYyA4MTA4N2IzNCAwMDMyZGNkNQpbICAgIDEuMzMzMzU4XSBDYWxsIFRy
YWNlOgpbICAgIDEuMzMzMzU4XSAgWzw4MTA0YzEyNz5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4
NzcvMHgxODAKWyAgICAxLjMzMzM1OF0gIFs8ODEwNDY0MzU+XSBfX2RvX3NvZnRpcnErMHhh
NS8weDE2MApbICAgIDEuMzMzMzU4XSAgWzw4MTA2Y2Q5Nz5dID8gc2NoZWRfY2xvY2tfY3B1
KzB4MTE3LzB4MTMwClsgICAgMS4zMzMzNThdICBbPDgxMDg3YjM0Pl0gPyB0aWNrX25vaHpf
aGFuZGxlcisweGQ0LzB4ZTAKWyAgICAxLjMzMzM1OF0gIFs8ODEwNDY2MDc+XSBpcnFfZXhp
dCsweDQ3LzB4YTAKWyAgICAxLjMzMzM1OF0gIFs8ODEwMjc0NTU+XSBzbXBfYXBpY190aW1l
cl9pbnRlcnJ1cHQrMHgzNS8weDUwClsgICAgMS4zMzMzNThdICBbPDgxM2E3YTQxPl0gYXBp
Y190aW1lcl9pbnRlcnJ1cHQrMHgzMS8weDM4ClsgICAgMS4zMzMzNThdICBbPDgxMDJlNDU1
Pl0gPyBuYXRpdmVfc2FmZV9oYWx0KzB4NS8weDEwClsgICAgMS4zMzMzNThdICBbPDgxMDA5
YTk4Pl0gZGVmYXVsdF9pZGxlKzB4OC8weDEwClsgICAgMS4zMzMzNThdICBbPDgxMDBhMWUy
Pl0gYXJjaF9jcHVfaWRsZSsweDEyLzB4MzAKWyAgICAxLjMzMzM1OF0gIFs8ODEwN2RjZTk+
XSBjcHVfc3RhcnR1cF9lbnRyeSsweDExOS8weDE4MApbICAgIDEuMzMzMzU4XSAgWzw4MTAy
NThhZj5dIHN0YXJ0X3NlY29uZGFyeSsweDI5Zi8weDJiMApbICAgIDEuMzMzMzU4XSBDb2Rl
OiAwMCA4OSA0MCAwNCA4YiA0NSBlYyAzOSBmMCA4YiAzOCA3NCAzNSA4YiA1MCAwYyA4MyBl
MiBmYyAzOSBkMyA3NCAxYyBlYiAxMiA2NiA5MCA4YiA0NyAwYyA4MyBlMCBmYyAzOSBjMyA3
NSAwNiA4OSBmOCA4OSBkNyBlYiAwOCA8MGY+IDBiIDhkIGI2IDAwIDAwIDAwIDAwIDg5IGMy
IDg5IGQ4IGU4IGRmIGZkIGZmIGZmIDM5IGY3IDhiIDE3ClsgICAgMS4zMzMzNThdIEVJUDog
Wzw4MTA0YmYyMD5dIGNhc2NhZGUrMHg1MC8weDgwIFNTOkVTUCAwMDY4OjgwMDc1ZTg0Clsg
ICAgMS4zMzMzNThdIC0tLVsgZW5kIHRyYWNlIDE2OTZjZTZkYjlhNTk3NGUgXS0tLQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzLzEzZTIyMzdmMzY4NzRhN2FiZWY0NGI5ODk2
OWYzOTkxMjdiMTkxN2QvZG1lc2cteW9jdG8taW5uLTI0OjIwMTMxMDA2MDAxOTM5OmkzODYt
cmFuZGNvbmZpZy1jMS0xMDAzOjMuMTEuMC1yYzMtMDAwNDQtZzEzZTIyMzc6MzQxCgpCaXNl
Y3Rpbmc6IDIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1
IHN0ZXBzKQpbMzQ5OTExNmI5MTVlMjYwYjI3NWMxNjdhNDcxZTBlMDViYmUzZjFkNl0gUFRQ
OiBjb252ZXJ0IGNsYXNzIGNvZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYzEtMTAwMy9zdGVyaWNzc29uOmJoMTc4MGdsaTozNDk5MTE2YjkxNWUyNjBiMjc1
YzE2N2E0NzFlMGUwNWJiZTNmMWQ2OmJpc2VjdC1zb3VuZAoKMjAxMy0xMC0wNi0wMDoxOTo1
OSAzNDk5MTE2YjkxNWUyNjBiMjc1YzE2N2E0NzFlMGUwNWJiZTNmMWQ2IGNvbXBpbGluZwox
NjMgcmVhbCAgMTI3NSB1c2VyICAxNTIgc3lzICA4NzIuMDclIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWMxLTEwMDMKCjIwMTMtMTAtMDYtMDA6MjM6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLXJjMi0wMDAyMi1nMzQ5OTExNgkzMAk0Ngk5OQkxMzQgVEVTVCBGQUlMVVJFCndm
ZzogcmVib290aW5nClsgICAgMi4xMDY1NjJdIFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9y
eSBmb3IgY3B1IDEKWyAgICAyLjE4MzM3MF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMGMKWyAgICAyLjE4NDUxMF0g
SVA6IFs8ODEwNGNiYzA+XSBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQrMHgxNTAvMHgyNjAK
WyAgICAyLjE4NTQ4MF0gKnBkcHQgPSAwMDAwMDAwMDBmOGJhMDAxICpwZGUgPSAwMDAwMDAw
MDAwMDAwMDAwIApbICAgIDIuMTg2NDA3XSBPb3BzOiAwMDAwIFsjMV0gU01QIApbICAgIDIu
MTg2NjgxXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAyLjE4NjY4MV0gQ1BVOiAxIFBJRDog
MCBDb21tOiBzd2FwcGVyLzEgTm90IHRhaW50ZWQgMy4xMS4wLXJjMi0wMDAyMi1nMzQ5OTEx
NiAjMzQyClsgICAgMi4xODY2ODFdIHRhc2s6IDgwMDZiYzYwIHRpOiA4MDA3NDAwMCB0YXNr
LnRpOiA4MDA3NDAwMApbICAgIDIuMTg2NjgxXSBFSVA6IDAwNjA6Wzw4MTA0Y2JjMD5dIEVG
TEFHUzogMDAyMTAwMDMgQ1BVOiAxClsgICAgMi4xODY2ODFdIEVJUCBpcyBhdCBnZXRfbmV4
dF90aW1lcl9pbnRlcnJ1cHQrMHgxNTAvMHgyNjAKWyAgICAyLjE4NjY4MV0gRUFYOiAwMDAw
MDAwMCBFQlg6IGZmZmVhMzAyIEVDWDogMDAwMTVjZmUgRURYOiA4MDEwODk1MApbICAgIDIu
MTg2NjgxXSBFU0k6IDAwMDAwMDAxIEVESTogZmZmZWEzMDIgRUJQOiA4MDA3NWViNCBFU1A6
IDgwMDc1ZTc4ClsgICAgMi4xODY2ODFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBH
UzogMDBlMCBTUzogMDA2OApbICAgIDIuMTg2NjgxXSBDUjA6IDgwMDUwMDNiIENSMjogMDAw
MDAwMGMgQ1IzOiAwZjhiODAwMCBDUjQ6IDAwMDAwNmYwClsgICAgMi4xODY2ODFdIFN0YWNr
OgpbICAgIDIuMTg2NjgxXSAgODAwNzVlOWMgMDBmZmZlYTMgM2ZmZWEyZmUgZmZmZWEyZmYg
ODAxMDgwMDAgODAxMDg4MzggMDAwMDAwMjMgMDAwMDAwMjMKWyAgICAyLjE4NjY4MV0gIDgw
MTA4ODM4IDgwMTA4YTM4IDgwMTA4YzM4IDgwMTA4ZTM4IDhkYmY0ZjQwIDgyMjMwNGZiIDAw
MDAwMDAwIDgwMDc1ZWZjClsgICAgMi4xODY2ODFdICA4MTA4N2U3MSAwMDIwMDA0NiA4MDA2
YmM2MCA4MDA3NWYwOCA4MTA0NjRkMCBmZmZlYTJmZiA4MjIzNmEyOSAwMDAwMDAwMApbICAg
IDIuMTg2NjgxXSBDYWxsIFRyYWNlOgpbICAgIDIuMTg2NjgxXSAgWzw4MTA4N2U3MT5dIF9f
dGlja19ub2h6X2lkbGVfZW50ZXIrMHgxYzEvMHg0NjAKWyAgICAyLjE4NjY4MV0gIFs8ODEw
NDY0ZDA+XSA/IF9fZG9fc29mdGlycSsweDE0MC8weDE2MApbICAgIDIuMTg2NjgxXSAgWzw4
MTA4ODFiMz5dIHRpY2tfbm9oel9pcnFfZXhpdCsweDIzLzB4MzAKWyAgICAyLjE4NjY4MV0g
IFs8ODEwNDY2NDY+XSBpcnFfZXhpdCsweDg2LzB4YTAKWyAgICAyLjE4NjY4MV0gIFs8ODEw
Mjc0NTU+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzNS8weDUwClsgICAgMi4xODY2
ODFdICBbPDgxM2E3OGMxPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzMS8weDM4ClsgICAg
Mi4xODY2ODFdICBbPDgxMDJlNDU1Pl0gPyBuYXRpdmVfc2FmZV9oYWx0KzB4NS8weDEwClsg
ICAgMi4xODY2ODFdICBbPDgxMDA5YTk4Pl0gZGVmYXVsdF9pZGxlKzB4OC8weDEwClsgICAg
Mi4xODY2ODFdICBbPDgxMDBhMWUyPl0gYXJjaF9jcHVfaWRsZSsweDEyLzB4MzAKWyAgICAy
LjE4NjY4MV0gIFs8ODEwN2RjZTk+XSBjcHVfc3RhcnR1cF9lbnRyeSsweDExOS8weDE4MApb
ICAgIDIuMTg2NjgxXSAgWzw4MTAyNThhZj5dIHN0YXJ0X3NlY29uZGFyeSsweDI5Zi8weDJi
MApbICAgIDIuMTg2NjgxXSBDb2RlOiBlOCA4OSA0NSBjNCA4YiA0NSBjOCA4MyBlMCAzZiA4
OSA0NSBkYyA4OSA0NSBlMCA4ZCA3NiAwMCA4YiA1NSBkOCA4OSBmYiA4YiA0ZCBlMCA4YiAw
NCBjYSA4ZCAxNCBjYSAzOSBkMCA3NCAyNiA4ZCBiNiAwMCAwMCAwMCAwMCA8ZjY+IDQwIDBj
IDAxIDg5IGZiIDc1IDEyIDhiIDU4IDA4IGJlIDAxIDAwIDAwIDAwIDg5IGQ5IDI5IGY5IDBm
ClsgICAgMi4xODY2ODFdIEVJUDogWzw4MTA0Y2JjMD5dIGdldF9uZXh0X3RpbWVyX2ludGVy
cnVwdCsweDE1MC8weDI2MCBTUzpFU1AgMDA2ODo4MDA3NWU3OApbICAgIDIuMTg2NjgxXSBD
UjI6IDAwMDAwMDAwMDAwMDAwMGMKWyAgICAyLjE4NjY4MV0gLS0tWyBlbmQgdHJhY2UgMjdl
MTQxYzYyOTVlYmY5MSBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvMzQ5
OTExNmI5MTVlMjYwYjI3NWMxNjdhNDcxZTBlMDViYmUzZjFkNi9kbWVzZy15b2N0by1pbm4t
MTk6MjAxMzEwMDYwMDI0Mjk6aTM4Ni1yYW5kY29uZmlnLWMxLTEwMDM6My4xMS4wLXJjMi0w
MDAyMi1nMzQ5OTExNjozNDIKCkJpc2VjdGluZzogMTAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls1OGIyNjdkM2UzZjNjZTg3YzNlNTU5
ZTRjMzMwYzhjMDNlOTA1ZjVlXSBkbWE6IGNvbnZlcnQgZG1hX2RldmNsYXNzIHRvIHVzZSBk
ZXZfZ3JvdXBzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvc3Rlcmljc3NvbjpiaDE3
ODBnbGk6NThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0YzMzMGM4YzAzZTkwNWY1ZTpiaXNlY3Qt
c291bmQKCjIwMTMtMTAtMDYtMDA6MjU6MDYgNThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0YzMz
MGM4YzAzZTkwNWY1ZSBjb21waWxpbmcKMzkgcmVhbCAgMTI2IHVzZXIgIDU1IHN5cyAgNDU1
LjkwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMS0xMDAzCgoyMDEzLTEwLTA2LTAwOjI2OjA2
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMTEtZzU4YjI2N2QJMjkJNTkJ
OTQJMTI0CTE0OAkxODUJMjE2CTI1MgkyNzkJMzExCTM1MAkzOTEJNDI5CTQ1OQk0OTkJNTQ0
CTU3NCBURVNUIEZBSUxVUkUKWyAgICAyLjExNjI5NF0gVW5yZWdpc3RlciBwdiBzaGFyZWQg
bWVtb3J5IGZvciBjcHUgMQpbICAgIDIuMTYwMDkxXSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nr
c291cmNlIGNhbGlicmF0aW9uOiAyOTkyLjQ5OCBNSHoKWyAgICAyLjE4MDA1NV0gQlVHOiB1
bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAw
MDAwMGMKWyAgICAyLjE4MTA1OF0gSVA6IFs8ODEwNGNiYzA+XSBnZXRfbmV4dF90aW1lcl9p
bnRlcnJ1cHQrMHgxNTAvMHgyNjAKWyAgICAyLjE4MTkyM10gKnBkcHQgPSAwMDAwMDAwMDBm
OGZjMDAxICpwZGUgPSAwMDAwMDAwMDAwMDAwMDAwIApbICAgIDIuMTgyNzE3XSBPb3BzOiAw
MDAwIFsjMV0gU01QIApbICAgIDIuMTgzMTg1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAy
LjE4MzM2M10gQ1BVOiAxIFBJRDogMCBDb21tOiBzd2FwcGVyLzEgTm90IHRhaW50ZWQgMy4x
MS4wLXJjMi0wMDAxMS1nNThiMjY3ZCAjMzQzClsgICAgMi4xODMzNjNdIHRhc2s6IDgwMDZi
YzYwIHRpOiA4MDA3NDAwMCB0YXNrLnRpOiA4MDA3NDAwMApbICAgIDIuMTgzMzYzXSBFSVA6
IDAwNjA6Wzw4MTA0Y2JjMD5dIEVGTEFHUzogMDAyMTAwMDMgQ1BVOiAxClsgICAgMi4xODMz
NjNdIEVJUCBpcyBhdCBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQrMHgxNTAvMHgyNjAKWyAg
ICAyLjE4MzM2M10gRUFYOiAwMDAwMDAwMCBFQlg6IGZmZmVhMzAxIEVDWDogMDAwMTVjZmYg
RURYOiA4MDEwODk1MApbICAgIDIuMTgzMzYzXSBFU0k6IDAwMDAwMDAxIEVESTogZmZmZWEz
MDEgRUJQOiA4MDA3NWViNCBFU1A6IDgwMDc1ZTc4ClsgICAgMi4xODMzNjNdICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgIDIuMTgzMzYzXSBD
UjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMGMgQ1IzOiAwZjhkZjAwMCBDUjQ6IDAwMDAwNmYw
ClsgICAgMi4xODMzNjNdIFN0YWNrOgpbICAgIDIuMTgzMzYzXSAgODAwNzVlOWMgMDBmZmZl
YTMgM2ZmZWEyZmQgZmZmZWEyZmUgODAxMDgwMDAgODAxMDg4MzggMDAwMDAwMjMgMDAwMDAw
MjMKWyAgICAyLjE4MzM2M10gIDgwMTA4ODM4IDgwMTA4YTM4IDgwMTA4YzM4IDgwMTA4ZTM4
IDhkYmY0ZjQwIDgxZjAyODI2IDAwMDAwMDAwIDgwMDc1ZWZjClsgICAgMi4xODMzNjNdICA4
MTA4N2U3MSAwMDIwMDA0NiA4MDA2YmM2MCA4MDA3NWYwOCA4MTA0NjRkMCBmZmZlYTJmZSA4
MWYwZGUxYSAwMDAwMDAwMApbICAgIDIuMTgzMzYzXSBDYWxsIFRyYWNlOgpbICAgIDIuMTgz
MzYzXSAgWzw4MTA4N2U3MT5dIF9fdGlja19ub2h6X2lkbGVfZW50ZXIrMHgxYzEvMHg0NjAK
WyAgICAyLjE4MzM2M10gIFs8ODEwNDY0ZDA+XSA/IF9fZG9fc29mdGlycSsweDE0MC8weDE2
MApbICAgIDIuMTgzMzYzXSAgWzw4MTA4ODFiMz5dIHRpY2tfbm9oel9pcnFfZXhpdCsweDIz
LzB4MzAKWyAgICAyLjE4MzM2M10gIFs8ODEwNDY2NDY+XSBpcnFfZXhpdCsweDg2LzB4YTAK
WyAgICAyLjE4MzM2M10gIFs8ODEwMjc0NTU+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQr
MHgzNS8weDUwClsgICAgMi4xODMzNjNdICBbPDgxM2E3OGMxPl0gYXBpY190aW1lcl9pbnRl
cnJ1cHQrMHgzMS8weDM4ClsgICAgMi4xODMzNjNdICBbPDgxMDJlNDU1Pl0gPyBuYXRpdmVf
c2FmZV9oYWx0KzB4NS8weDEwClsgICAgMi4xODMzNjNdICBbPDgxMDA5YTk4Pl0gZGVmYXVs
dF9pZGxlKzB4OC8weDEwClsgICAgMi4xODMzNjNdICBbPDgxMDBhMWUyPl0gYXJjaF9jcHVf
aWRsZSsweDEyLzB4MzAKWyAgICAyLjE4MzM2M10gIFs8ODEwN2RjZTk+XSBjcHVfc3RhcnR1
cF9lbnRyeSsweDExOS8weDE4MApbICAgIDIuMTgzMzYzXSAgWzw4MTAyNThhZj5dIHN0YXJ0
X3NlY29uZGFyeSsweDI5Zi8weDJiMApbICAgIDIuMTgzMzYzXSBDb2RlOiBlOCA4OSA0NSBj
NCA4YiA0NSBjOCA4MyBlMCAzZiA4OSA0NSBkYyA4OSA0NSBlMCA4ZCA3NiAwMCA4YiA1NSBk
OCA4OSBmYiA4YiA0ZCBlMCA4YiAwNCBjYSA4ZCAxNCBjYSAzOSBkMCA3NCAyNiA4ZCBiNiAw
MCAwMCAwMCAwMCA8ZjY+IDQwIDBjIDAxIDg5IGZiIDc1IDEyIDhiIDU4IDA4IGJlIDAxIDAw
IDAwIDAwIDg5IGQ5IDI5IGY5IDBmClsgICAgMi4xODMzNjNdIEVJUDogWzw4MTA0Y2JjMD5d
IGdldF9uZXh0X3RpbWVyX2ludGVycnVwdCsweDE1MC8weDI2MCBTUzpFU1AgMDA2ODo4MDA3
NWU3OApbICAgIDIuMTgzMzYzXSBDUjI6IDAwMDAwMDAwMDAwMDAwMGMKWyAgICAyLjE4MzM2
M10gLS0tWyBlbmQgdHJhY2UgNWYxYzNhYTk1YmMxNDAwMCBdLS0tCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTEwMDMvNThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0YzMzMGM4YzAzZTkw
NWY1ZS9kbWVzZy15b2N0by13YWltZWEtMTU6MjAxMzEwMDYwODMyNDI6aTM4Ni1yYW5kY29u
ZmlnLWMxLTEwMDM6My4xMS4wLXJjMi0wMDAxMS1nNThiMjY3ZDozNDMKCkJpc2VjdGluZzog
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykK
Wzg5OTgyNmYxNmEwMzRmMWFiNmQyM2NkNWI2MGNkMTEzZWFlZmFkMTldIGVuY2xvc3VyZTog
Y29udmVydCBjbGFzcyBjb2RlIHRvIHVzZSBkZXZfZ3JvdXBzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWMxLTEwMDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6ODk5ODI2ZjE2YTAzNGYxYWI2ZDIz
Y2Q1YjYwY2QxMTNlYWVmYWQxOTpiaXNlY3Qtc291bmQKCjIwMTMtMTAtMDYtMDA6MzQ6Mzgg
ODk5ODI2ZjE2YTAzNGYxYWI2ZDIzY2Q1YjYwY2QxMTNlYWVmYWQxOSBjb21waWxpbmcKMTYz
IHJlYWwgIDEyMzYgdXNlciAgMTQ0IHN5cyAgODQ1LjA5JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1jMS0xMDAzCgoyMDEzLTEwLTA2LTAwOjM3OjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTEuMC1yYzItMDAwMDUtZzg5OTgyNmYJMjYJNDQJNzcJMTA2CTE0NwkxNzAJMjA2CTIzNgky
NTkJMjk3CTMzMwkzNjEJMzg4CTQyMgk0NTcJNTAwCTUyOAk1NTkJNTc5CTYwMwk2MTkJNjM4
CTY0OQk2NTgJNjY2CTY3OQk2ODQJNjk2CTcwNQk3MTUJNzIyCTczMQk3NDMJNzUyCTc1OAk3
NjcJNzcyCTc3Nwk3ODEJNzg4CTc5Mwk3OTgJODAxCTgwNQk4MDgJODE0CTgyMAk4MjgJODQ3
CTg1OAk4NzMJODkzCTkxNAk5MjcJOTM5CTk0OQk5NjIJOTY3CTk2OQk5NzEJOTc2CTk4MAk5
ODYJOTkwCTk5Mwk5OTgJMTAwMAkxMDA2CTEwMTEJMTAxOAkxMDIxCTEwMjQJMTAyNwkxMDMw
CTEwMzUJMTAzOQkxMDQ1CTEwNTAJMTA1OAkxMDcxCTEwODIJMTA5OQkxMTI0CTExNDIJMTE2
MQkxMTg0CTEyMDQJMTIyNgkxMjM5CTEyNTcJMTI3MgkxMjg4CTEzMDcJMTMzMgkxMzY0CTEz
OTAJMTQxMQkxNDQ4CTE0NzAJMTQ5MAkxNTE1CTE1NDIJMTU2NwkxNTg2CTE2MjAJMTY1MQkx
Njg2CTE3MDkJMTczOQkxNzY3CTE3OTgJMTgzNgkxODYzCTE5MDUJMTk0MgkxOTc2CTIwMDkJ
MjAzNQkyMDY3CTIwOTAJMjEyOAkyMTYxCTIxOTAJMjIzMwkyMjY5CTIyOTUJMjMyMQkyMzQx
CTIzODAJMjQxMwkyNDU0CTI0OTUJMjUzMAkyNTY4CTI2MDEJMjYzOAkyNjc1CTI3MTgJMjc3
MwkyODE4CTI4NjUJMjkwNgkyOTQwCTI5NzMJMzAxOQkzMDYzCTMxMDgJMzE0NwkzMTc4CTMy
MTgJMzI2OQkzMzExCTMzNTQJMzM5MgkzNDM5CTM0NjkJMzUxNQkzNTU3CTM1ODkJMzYyOQkz
NjYxCTM2NjQuCTM3NzQuLgkzNzk0CTM5NzcuLgk0MTIwCTQyMjYJNDI2NAk0NDIzCTQ1MjMJ
NDYwNQk0NzE3CTQ4MTAJNDg5NQk0OTQxCTQ5NzcJNDk5OS4uLgk1MDAwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MiBzdGVwcykKW2FjMzc4NWQ1YzE1OTIyYzhhNGM2YjllMDUwYTViYzU5ODk1YTZiOWJdIGMy
cG9ydDogY29udmVydCBjbGFzcyBjb2RlIHRvIHVzZSBiaW5fYXR0cnMgaW4gZ3JvdXBzCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6YWMzNzg1
ZDVjMTU5MjJjOGE0YzZiOWUwNTBhNWJjNTk4OTVhNmI5YjpiaXNlY3Qtc291bmQKCjIwMTMt
MTAtMDYtMDI6MTA6NDggYWMzNzg1ZDVjMTU5MjJjOGE0YzZiOWUwNTBhNWJjNTk4OTVhNmI5
YiBjb21waWxpbmcKNDggcmVhbCAgMTE5IHVzZXIgIDQ5IHN5cyAgMzQ2LjQzJSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1jMS0xMDAzCgoyMDEzLTEwLTA2LTAyOjExOjU3IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTEuMC1yYzItMDAwMDgtZ2FjMzc4NWQJMTQJNzUJMTU3CTI4OAk0MDYJ
NTY4CTYzOQk3NTQJODY3CTk0OAkxMDk3CTExNzYJMTI5NAkxMzkyCTE0NDYJMTQ4MwkxNTMx
CTE1NzIJMTYwMwkxNjM4CTE2NTAJMTY3MwkxNjkxCTE3MDkJMTc0MQkxNzc1CTE4MTAJMTg0
MwkxODg4CTE5MzYJMTk3NwkyMDUwCTIxMzAJMjE5MwkyMjUyCTIyODYJMjM0NwkyNDEyCTI0
ODUJMjUyOQkyNTkxCTI2NTcJMjcyMwkyODE5CTI4NzkJMjk0OQkzMDM3CTMxMjIJMzIyMQkz
MzEyCTMzODkJMzQzMwkzNDgxCTM1MzIJMzU3MAkzNTk4CTM2MzMJMzY2NQkzNjk5CTM3NDAJ
Mzc4MgkzODI5CTM4NzQJMzkyOAkzOTk2CTQwMzIJNDA2Mgk0MTAzCTQxMzMJNDE2OAk0MjA0
CTQyMzQJNDI0OAk0Mjc3CTQzMDQJNDMyMgk0MzI5CTQzNTYJNDM2MQk0MzY3CTQzODMJNDQx
Nwk0NDUzCTQ0OTEJNDU1OQk0NTkyCTQ2MzYJNDY4Mwk0NzExCTQ3MzgJNDc3Mwk0ODExCTQ4
MzIJNDg3OQk0ODk4CTQ5MzkJNDk1Ngk0OTYxCTQ5NjYJNDk3Mwk0OTgyCTQ5OTMJNDk5NAk1
MDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYx
NjBhZjYwOTIwZF0ga29iamVjdDogZGVsYXllZCBrb2JqZWN0IHJlbGVhc2U6IGhlbHAgZmlu
ZCBidWdneSBkcml2ZXJzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvc3Rlcmljc3Nv
bjpiaDE3ODBnbGk6YzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZDpi
aXNlY3Qtc291bmQKCjIwMTMtMTAtMDYtMDM6MDQ6MDAgYzgxN2E2N2VjYmE3YzNjMmFhYTEw
NDc5NmQ3OGYxNjBhZjYwOTIwZCBjb21waWxpbmcKMTU4IHJlYWwgIDEyNDUgdXNlciAgMTUw
IHN5cyAgODgxLjQ3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMS0xMDAzCgoyMDEzLTEwLTA2
LTAzOjA3OjAzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdh
NjcJMjAJMzYJNTcJMTE4IFRFU1QgRkFJTFVSRQp3Zmc6IHJlYm9vdGluZwpbICAgIDIuOTAz
NzY3XSBVbnJlZ2lzdGVyIHB2IHNoYXJlZCBtZW1vcnkgZm9yIGNwdSAxClsgICAgMy4wMzMz
ODJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGF0IDAwMDAwMDBjClsgICAgMy4wMzQzODldIElQOiBbPDgxMDRjYmMwPl0gZ2V0X25l
eHRfdGltZXJfaW50ZXJydXB0KzB4MTUwLzB4MjYwClsgICAgMy4wMzUyNTldICpwZHB0ID0g
MDAwMDAwMDAwZjhhODAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgICAzLjAzNjA3
MF0gT29wczogMDAwMCBbIzFdIFNNUCAKWyAgICAzLjAzNjU0N10gTW9kdWxlcyBsaW5rZWQg
aW46ClsgICAgMy4wMzY2OTddIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0
YWludGVkIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcgIzM0NgpbICAgIDMuMDM2Njk3XSB0
YXNrOiA4MDA2YmM2MCB0aTogODAwNzQwMDAgdGFzay50aTogODAwNzQwMDAKWyAgICAzLjAz
NjY5N10gRUlQOiAwMDYwOls8ODEwNGNiYzA+XSBFRkxBR1M6IDAwMjEwMDEzIENQVTogMQpb
ICAgIDMuMDM2Njk3XSBFSVAgaXMgYXQgZ2V0X25leHRfdGltZXJfaW50ZXJydXB0KzB4MTUw
LzB4MjYwClsgICAgMy4wMzY2OTddIEVBWDogMDAwMDAwMDAgRUJYOiBmZmZlYTQwMiBFQ1g6
IDAwMDE1YmZlIEVEWDogODAxMDg5NTgKWyAgICAzLjAzNjY5N10gRVNJOiAwMDAwMDAwMSBF
REk6IGZmZmVhNDAyIEVCUDogODAwNzVlYjQgRVNQOiA4MDA3NWU3OApbICAgIDMuMDM2Njk3
XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgICAz
LjAzNjY5N10gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDBjIENSMzogMGY4ZDYwMDAgQ1I0
OiAwMDAwMDZmMApbICAgIDMuMDM2Njk3XSBTdGFjazoKWyAgICAzLjAzNjY5N10gIDgwMDc1
ZTljIDAwZmZmZWE0IDNmZmVhM2ZlIGZmZmVhM2ZmIDgwMTA4MDAwIDgwMTA4ODM4IDAwMDAw
MDI0IDAwMDAwMDI0ClsgICAgMy4wMzY2OTddICA4MDEwODgzOCA4MDEwOGEzOCA4MDEwOGMz
OCA4MDEwOGUzOCA4ZGJmNGY0MCBiNGNjZmQyNiAwMDAwMDAwMCA4MDA3NWVmYwpbICAgIDMu
MDM2Njk3XSAgODEwODdlNzEgMDAyMDAwNDYgODAwNmJjNjAgODAwNzVmMDggODEwNDY0ZDAg
ZmZmZWEzZmYgYjRjZDlkYzAgMDAwMDAwMDAKWyAgICAzLjAzNjY5N10gQ2FsbCBUcmFjZToK
WyAgICAzLjAzNjY5N10gIFs8ODEwODdlNzE+XSBfX3RpY2tfbm9oel9pZGxlX2VudGVyKzB4
MWMxLzB4NDYwClsgICAgMy4wMzY2OTddICBbPDgxMDQ2NGQwPl0gPyBfX2RvX3NvZnRpcnEr
MHgxNDAvMHgxNjAKWyAgICAzLjAzNjY5N10gIFs8ODEwODgxYjM+XSB0aWNrX25vaHpfaXJx
X2V4aXQrMHgyMy8weDMwClsgICAgMy4wMzY2OTddICBbPDgxMDQ2NjQ2Pl0gaXJxX2V4aXQr
MHg4Ni8weGEwClsgICAgMy4wMzY2OTddICBbPDgxMDI3NDU1Pl0gc21wX2FwaWNfdGltZXJf
aW50ZXJydXB0KzB4MzUvMHg1MApbICAgIDMuMDM2Njk3XSAgWzw4MTNhNzhjMT5dIGFwaWNf
dGltZXJfaW50ZXJydXB0KzB4MzEvMHgzOApbICAgIDMuMDM2Njk3XSAgWzw4MTAyZTQ1NT5d
ID8gbmF0aXZlX3NhZmVfaGFsdCsweDUvMHgxMApbICAgIDMuMDM2Njk3XSAgWzw4MTAwOWE5
OD5dIGRlZmF1bHRfaWRsZSsweDgvMHgxMApbICAgIDMuMDM2Njk3XSAgWzw4MTAwYTFlMj5d
IGFyY2hfY3B1X2lkbGUrMHgxMi8weDMwClsgICAgMy4wMzY2OTddICBbPDgxMDdkY2U5Pl0g
Y3B1X3N0YXJ0dXBfZW50cnkrMHgxMTkvMHgxODAKWyAgICAzLjAzNjY5N10gIFs8ODEwMjU4
YWY+XSBzdGFydF9zZWNvbmRhcnkrMHgyOWYvMHgyYjAKWyAgICAzLjAzNjY5N10gQ29kZTog
ZTggODkgNDUgYzQgOGIgNDUgYzggODMgZTAgM2YgODkgNDUgZGMgODkgNDUgZTAgOGQgNzYg
MDAgOGIgNTUgZDggODkgZmIgOGIgNGQgZTAgOGIgMDQgY2EgOGQgMTQgY2EgMzkgZDAgNzQg
MjYgOGQgYjYgMDAgMDAgMDAgMDAgPGY2PiA0MCAwYyAwMSA4OSBmYiA3NSAxMiA4YiA1OCAw
OCBiZSAwMSAwMCAwMCAwMCA4OSBkOSAyOSBmOSAwZgpbICAgIDMuMDM2Njk3XSBFSVA6IFs8
ODEwNGNiYzA+XSBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQrMHgxNTAvMHgyNjAgU1M6RVNQ
IDAwNjg6ODAwNzVlNzgKWyAgICAzLjAzNjY5N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDBjClsg
ICAgMy4wMzY2OTddIC0tLVsgZW5kIHRyYWNlIGZkNjE0OTAwZjJkZjUzZWQgXS0tLQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZk
NzhmMTYwYWY2MDkyMGQvZG1lc2cteW9jdG8td2FpbWVhLTY6MjAxMzEwMDYxMTA3MTg6aTM4
Ni1yYW5kY29uZmlnLWMxLTEwMDM6My4xMS4wLXJjMi0wMDAxMC1nYzgxN2E2NzozNDYKCkJp
c2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MCBzdGVwcykKWzdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWFdIGNo
YXI6IHRpbGUtc3JvbTogZml4IGJ1aWxkIGVycm9yCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMx
LTEwMDMvc3Rlcmljc3NvbjpiaDE3ODBnbGk6N2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1
OGNmMmZiODZhYTM1YTpiaXNlY3Qtc291bmQKCjIwMTMtMTAtMDYtMDM6MDk6MDUgN2M0Mjcy
MWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YSBjb21waWxpbmcKMTU3IHJlYWwg
IDEyNDIgdXNlciAgMTQ3IHN5cyAgODgyLjQzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMS0x
MDAzCgoyMDEzLTEwLTA2LTAzOjEyOjAyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1y
YzItMDAwMDktZzdjNDI3MjEJMTAJMTcJMjcJNDcJNzYJMTA4CTE0MQkxNTQJMTcyCTE4OQkx
OTkJMjI2CTI0MQkyNjEJMjczCTI5MQkzMDcJMzMwCTM0MAkzNTgJMzc1CTM4MgkzOTEJMzk2
CTQxNAk0MzAJNDQ1CTQ2OAk0OTAJNTA4CTUyOQk1NDQJNTYwCTU3Nwk1OTcJNjE0CTYzMgk2
NTIJNjgyCTY5NAk3MTcJNzMyCTc0MQk3NDgJNzU2CTc1OQk3NjcJNzcxCTc4MAk3ODkJODAx
CTgwNAk4MjEJODM0CTg0OQk4NjIJODgxCTg5Mgk5MTcJOTM4CTk2NQk5ODAJOTg4CTEwMDgJ
MTAxNwkxMDI4CTEwNTUJMTA3MgkxMDkyCTExMDUJMTExNQkxMTE3CTExMjMuCTExMjUJMTE1
OAkxMTY1LgkxMTgwCTEyMTUJMTIyNAkxMjMyCTEyMzcJMTIzOAkxMjQwCTEyNDMJMTI0Ngkx
MjUwCTEyNTQJMTI2MQkxMjYzCTEyNjgJMTI3MgkxMjc2CTEyODMJMTI4OQkxMjkxCTEzMDYJ
MTMxNAkxMzE3CTEzMzEJMTMzMwkxMzQyCTEzNDYJMTM1MAkxMzUxLgkxMzYwCTEzNjQuCTEz
NjkJMTM3MQkxMzc2CTEzODMJMTM5MAkxNDA1CTE0MTEJMTQyMQkxNDM4CTE0NDguCTE0NjAJ
MTQ4Ni4JMTUyMgkxNTM2LgkxNTU2CTE1ODAJMTU5Mi4JMTYzMQkxNjQ4CTE2NjgJMTY3OS4J
MTY4NwkxNzEzCTE3NTkJMTc4OS4uCTE4MTIJMTkwNi4uLi4uLgkxOTI1CTE5NTAJMTk4OQkx
OTk1CTIwMzkJMjA1NwkyMDc1CTIwODgJMjA5NAkyMTA5CTIxMTIJMjExNQkyMTI0CTIxMzkJ
MjE0Ni4JMjE2NwkyMTg3CTIxOTUJMjIxNAkyMjI5CTIyMzkJMjI0MwkyMjQ3CTIyNjQJMjI3
NQkyMjk3CTIzMDYJMjMyMQkyMzM3LgkyMzU2CTIzNTgJMjM4MgkyMzg3CTI0MDMuCTI0NTEJ
MjQ2MgkyNDY4CTI0NzUJMjQ4MAkyNDg3LgkyNDk5CTI1MTEJMjUyNwkyNTMxCTI1NDQJMjU1
MwkyNTU4CTI1NTkuCTI1NzUJMjU4MwkyNTg5CTI2MDIJMjYxMwkyNjE3CTI2MjEuCTI2MzQJ
MjY1OAkyNjcwCTI2ODgJMjY5NwkyNzA3CTI3MDgJMjcxNgkyNzIzCTI3NTMJMjc2NQkyNzc0
CTI3OTIJMjgwMAkyODAzCTI4MTMuCTI4MjIJMjgyNgkyODMxCTI4NDIJMjg1MwkyODU2CTI4
NjcuLgkyODgxCTI4ODMJMjg4OAkyODkwCTI5MDAuCTI5MDcuCTI5MTgJMjkzMQkyOTM2Lgky
OTUwLi4uCTI5OTgJMzAxMwkzMDQ4CTMwNTgJMzA3MwkzMDc2CTMwODIuCTMwOTgJMzEwNgkz
MTE1CTMxMjYJMzEzMgkzMTMzCTMxMzcuCTMxNDgJMzE1MQkzMTU3CTMxNjIJMzE2MwkzMTY2
CTMxNjguCTMxODYJMzE5NwkzMjA5CTMyMTYJMzIyMwkzMjI4CTMyMjkJMzIzNC4JMzI2Mwkz
MjY4CTMyODMJMzI5MgkzMzAxCTMzMDYuCTMzMTcuCTMzMzMJMzMzNwkzMzQ0CTMzNDkuCTMz
NTAJMzM1MQkzMzU1CTMzNjAJMzM2NwkzMzcxCTMzNzQJMzM3OAkzMzc5CTMzODIuCTMzOTYJ
MzQwNQkzNDEzCTM0MjEJMzQyNgkzNDM0CTM0MzcuCTM0MzgJMzQ2NgkzNDcyCTM0NzgJMzQ4
NgkzNDk1CTM0OTYJMzUwNS4JMzUxNAkzNTIwCTM1MzAJMzUzNAkzNTQzCTM1NDguCTM1NTUu
LgkzNTg0CTM2MDUJMzYxOAkzNjQyCTM2NTcJMzY2NC4JMzY3NAkzNjg3CTM3MTEJMzcyNQkz
NzQyCTM3NjQJMzc3MAkzNzc3CTM3ODUJMzgwMgkzODE5CTM4MjMJMzg1MAkzODY1CTM4NzcJ
Mzg4NC4JMzkwMS4JMzkzMgkzOTQ2CTM5NjQJMzk3NgkzOTgyCTM5ODkuLgk0MDI5CTQwNDUJ
NDA1MQk0MDY2CTQwODMuCTQwOTAJNDA5OAk0MTA5CTQxMjUJNDEzNgk0MTQ5CTQxNjAJNDE2
Ngk0MTY3CTQxODQuCTQyMTUJNDIzMAk0MjQ4CTQyNjUJNDI3OAk0Mjc5CTQyODYJNDI5OAk0
MzE3CTQzMjUJNDM0Ngk0MzYyCTQzNjcJNDM3MQk0Mzc2Li4JNDQxNAk0NDI5CTQ0NDYJNDQ1
Ngk0NDY3CTQ0NjgJNDQ3OC4JNDUxMgk0NTI0CTQ1MzcJNDU1NAk0NTcyCTQ1NzgJNDU3OQk0
NTkzLgk0NjE5CTQ2MzAJNDY0Mgk0NjUzCTQ2NzAJNDY3NQk0Njg5Lgk0NzA5CTQ3MTQJNDcx
OAk0NzMyCTQ3MzcJNDczOS4JNDc1Ngk0NzYyCTQ3ODIJNDc4OQk0ODA5CTQ4MTkJNDgyMAk0
ODIzCTQ4MzIuCTQ4NTAJNDg2OQk0ODgyCTQ4OTMJNDkwNwk0OTE2Lgk0OTMyCTQ5NDIJNDk1
NAk0OTcyCTQ5OTEJNDk5OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVt
YWRkX3RvX3J1bl9xdWV1ZSAyG1swbQouLi4uLi4uLi4uLgk1MDAwIFNVQ0NFU1MKCmM4MTdh
NjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQgaXMgdGhlIGZpcnN0IGJhZCBj
b21taXQKY29tbWl0IGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQK
QXV0aG9yOiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtLmxpbnV4Lm9yZy51az4KRGF0
ZTogICBUaHUgSnVuIDI3IDE1OjA2OjE0IDIwMTMgKzAxMDAKCiAgICBrb2JqZWN0OiBkZWxh
eWVkIGtvYmplY3QgcmVsZWFzZTogaGVscCBmaW5kIGJ1Z2d5IGRyaXZlcnMKICAgIAogICAg
SW1wbGVtZW50IGRlYnVnZ2luZyBmb3Iga29iamVjdCByZWxlYXNlIGZ1bmN0aW9ucy4gIGtv
YmplY3RzIGFyZQogICAgcmVmZXJlbmNlIGNvdW50ZWQsIHNvIHRoZSBkcm9wIG9mIHRoZSBs
YXN0IHJlZmVyZW5jZSB0byB0aGVtIGlzIG5vdAogICAgcHJlZGljdGFibGUuIEhvd2V2ZXIs
IHRoZSBjb21tb24gY2FzZSBpcyBmb3IgdGhlIGxhc3QgcmVmZXJlbmNlIHRvIGJlCiAgICB0
aGUga29iamVjdCdzIHJlbW92YWwgZnJvbSBhIHN1YnN5c3RlbSwgd2hpY2ggcmVzdWx0cyBp
biB0aGUgcmVsZWFzZQogICAgZnVuY3Rpb24gYmVpbmcgaW1tZWRpYXRlbHkgY2FsbGVkLgog
ICAgCiAgICBUaGlzIGNhbiBoaWRlIHN1YnRsZSBidWdzLCB3aGljaCBjYW4gb2NjdXIgd2hl
biBhbm90aGVyIHRocmVhZCBob2xkcyBhCiAgICByZWZlcmVuY2UgdG8gdGhlIGtvYmplY3Qg
YXQgdGhlIHNhbWUgdGltZSB0aGF0IGEga29iamVjdCBpcyByZW1vdmVkLgogICAgVGhpcyBy
ZXN1bHRzIGluIHRoZSByZWxlYXNlIG1ldGhvZCBiZWluZyBkZWxheWVkLgogICAgCiAgICBJ
biBvcmRlciB0byBtYWtlIHRoZXNlIGtpbmRzIG9mIHByb2JsZW1zIG1vcmUgdmlzaWJsZSwg
dGhlIGZvbGxvd2luZwogICAgcGF0Y2ggaW1wbGVtZW50cyBhIGRlbGF5ZWQgcmVsZWFzZTsg
dGhpcyBoYXMgdGhlIGVmZmVjdCB0aGF0IHRoZQogICAgcmVsZWFzZSBmdW5jdGlvbiB3aWxs
IGJlIG91dCBvZiBvcmRlciB3aXRoIHJlc3BlY3QgdG8gdGhlIHJlbW92YWwgb2YKICAgIHRo
ZSBrb2JqZWN0IGluIHRoZSBzYW1lIG1hbm5lciB0aGF0IGl0IHdvdWxkIGJlIGlmIGEgcmVm
ZXJlbmNlIHdhcwogICAgYmVpbmcgaGVsZC4KICAgIAogICAgVGhpcyBwcm92aWRlcyB1cyB3
aXRoIGFuIGVhc3kgd2F5IHRvIGFsbG93IGRyaXZlciB3cml0ZXJzIHRvIGRlYnVnCiAgICB0
aGVpciBkcml2ZXJzIGFuZCBmaXggb3RoZXJ3aXNlIGhpZGRlbiBwcm9ibGVtcy4KICAgIAog
ICAgU2lnbmVkLW9mZi1ieTogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybS5saW51eC5v
cmcudWs+CiAgICBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBs
aW51eGZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgZjZjMjNlZmExMDJmYzJjMmVh
ZDVjODZiZGI2NWFhNzA3MTliMWFiOSAwNDk4NTlmYTdhM2E5NTM4OTIxMjc0NjdiYWJiZjAy
ZjY2YTY5Yjc2IE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCBhNDFkMjA2NjlmMGY2MjRkMmNl
OWNhN2U2YTVmOTZlNGY5MTQzMmUwIGJmMjE2ODE5NGY4MjkxMWNmMmUxODkyZDgyZjBjMTNk
MDBjNzcyYWUgTQlsaWIKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMTAwMy9zdGVyaWNzc29uOmJoMTc4
MGdsaTo3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhOmJpc2VjdC1z
b3VuZAoKMjAxMy0xMC0wNi0wOTo0MDozNCA3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4
Y2YyZmI4NmFhMzVhIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvN2M0
MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YS92bWxpbnV6LTMuMTEuMC1y
YzItMDAwMDktZzdjNDI3MjEKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAx
MDAwMCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMtMTAtMDYtMDk6NDE6NTYgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzMQk4NQkxNDAJMTk5CTI2
MAkzMzUJMzk4CTQ1OAk1MTcJNTgxCTY0OAk3MTcJNzc5CTg0Mgk5MDUJOTcxCTEwMzQJMTEw
MAkxMTY3CTEyMzQJMTMwMAkxMzY4CTE0MzYJMTUwMwkxNTY5CTE2MjgJMTY5MQkxNzU3CTE4
MTQJMTg3MAkxOTI1CTE5ODMJMjA0NAkyMTA2CTIxNjkJMjIzMQkyMjkzCTIzNTcJMjQyMAky
NDc4CTI1MzcJMjU5NwkyNjYwCTI3MjIJMjc4MwkyODQ2CTI5MDkJMjk3MwkzMDI5CTMwODcJ
MzE0NwkzMjA5CTMyNzMJMzMzMAkzMzgzCTM0NDAJMzUwMAkzNTY0CTM2MjgJMzY5NAkzNzI2
CTM3NzkJMzgyNAkzODY2CTM5MTMJMzk1NC4uLi4uLi4uLi4uLi4uLi4JMzk5Mwk0MDgxCTQy
OTkJNDQxMgk0NDM0CTQ1MjEJNDU5OQk0NjE4CTQ2NzMJNDcyOQk0Nzg4CTQ4NDYJNDkwNAk0
OTYzCTUwMDAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19y
dW5fcXVldWUgNTAwMBtbMG0KCTUxMDMJNTIwMAk1MjY1CTUzMDkJNTM4MQk1NDU0CTU1MjkJ
NTYwMAk1NjU4CTU3MjAJNTc4MQk1ODQyCTU5MDgJNTk3NQk2MDQ5CTYxMTMJNjE3Ngk2MjUw
CTYzMjMJNjM5NQk2NDQ1CTY1MTIJNjU3Ngk2NjQ5CTY3MTMJNjc3OAk2ODQ4CTY5MTcJNjk3
Ngk3MDM0CTcwOTEJNzE0Nwk3MjA0CTcyNjUJNzMyNgk3MzkxCTc0NTcJNzUyNAk3NTkzCTc2
NTcJNzcwMwk3NzY3CTc4MzIJNzkwNgk3OTUzCTgwMzUJODE5Mwk4MzMwCTgzNTYJODQwMgk4
NDU5CTg1MTIJODU2NAk4NjE5CTg2NzQJODczMQk4NzkxCTg4NTcJODg4MS4uLgk4ODkxCTg5
MjEJODk1Mgk5MDEzCTkwNjUJOTExNwk5MTcwCTkyMTgJOTI2OQk5MzIxCTkzNzYJOTQzNQk5
NDkwCTk1NTYJOTYxOAk5NjcwCTk3MjgJOTg0Nwk5ODgxLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOTg4Mi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTk4ODMuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMTE3G1swbQoJOTkwMgk5OTIz
CTk5NDMJOTk3Mwk5OTc4CTEwMDAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMTAwMy9zdGVyaWNzc29uOmJoMTc4MGds
aTo3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhOmJpc2VjdC1zb3Vu
ZAoKMjAxMy0xMC0wNi0xOTozNToyMyA3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2Yy
ZmI4NmFhMzVhIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTEwMDMvN2M0Mjcy
MWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YS92bWxpbnV6LTMuMTEuMC1yYzIt
MDAwMDktZzdjNDI3MjEKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAxMDAw
MCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMtMTAtMDYtMTk6MzY6MjAgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgCTEwNQkxNjcJMjMyCTI5NgkzNTcJNDIwCTQ4Ngk1NDgJNjEzCTY3NQk3MzgJ
ODAwCTg2Mwk5MjgJOTkxCTEwNTMJMTExOAkxMTgyCTEyNDYJMTMxMgkxMzc4CTE0NDQJMTUx
MgkxNTgxCTE2NTEJMTcxOQkxNzg2CTE4NTQJMTkyMwkxOTg5CTIwNTcJMjEyNQkyMTkzCTIy
NjEJMjMyOQkyMzk2CTI0NjEJMjUyOQkyNTkzCTI2NTcJMjcyNwkyNzk4CTI4NjgJMjkzOAkz
MDA4CTMwNzgJMzE0OAkzMjE3CTMyODcJMzM1NwkzNDI2CTM0OTYJMzU2NwkzNjM4CTM2OTMJ
Mzc1OQkzODMyCTM4NzUJMzkyMAkzOTcxCTQwMTgJNDA5NAk0MTM0CTQxNjcJNDIxNgk0Mjcz
CTQzMzUJNDQwNAk0NDc0CTQ1NDMJNDYxMgk0NjgzCTQ3NDMJNDc5Nwk0ODM4CTQ5MDcJNDk3
OQk1MDAwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVu
X3F1ZXVlIDUwMDAbWzBtCi4JNTAwNAk1MDE3CTUwMjgJNTAzMwk1MDM1CTUwNjUJNTEwMwk1
MTM5CTUxNzEJNTIyMwk1MjU2CTUyNzQJNTMwMAk1MzY1CTU0MjEJNTUwMwk1NTM1CTU1ODMJ
NTY0Ngk1Njk3CTU3NTMJNTgxNAk1ODc0CTU5MjQJNTk3Nwk2MTM5CTYzODEJNjQ0NQk2NDk1
CTY1NTEJNjU4NQk2NjAxCTY2NDMJNjcwMQk2Nzc3CTY4NzUJNjk3OQk3MDE4CTcwOTkJNzEx
NAk3MTM1CTcxNzIJNzIxMAk3Mjg2CTczODYJNzQ1MQk3NDgyCTc1MTkuCTc1NDYJNzU5Ngk3
NjYzCTc3NzgJNzkyNgk3OTYwCTc5OTgJODA4MQk4MTQyCTgxNjgJODIyNwk4MjQ0CTgzNjkJ
ODQ2Nwk4NTQwCTg1NzkJODYxOAk4NjMyCTg2NDAJODY1Mwk4Njc4CTg2OTYJODc0OQk4Nzc2
CTg4MzMJODg3NQk4OTAxCTg5MjQJOTAyOAk5MTAxCTkxNzMJOTE5NQk5MjI5CTkyODMJOTMx
MAk5Mzc3CTk0MzkJOTQ5MQk5NDk5CTk2MjcJOTg0NAk5ODgzCTk5NTcJOTk4Mwk5OTg3CTk5
ODkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTEwMDAwIFNVQ0NFU1MKCiMgSEVBRCBkZXRhY2hlZCBhdCA3YzQyNzIxCiMgWW91IGFyZSBj
dXJyZW50bHkgYmlzZWN0aW5nLCBzdGFydGVkIGZyb20gYnJhbmNoICdjMWJlNWE1Jy4KIyAg
ICh1c2UgImdpdCBiaXNlY3QgcmVzZXQiIHRvIGdldCBiYWNrIHRvIHRoZSBvcmlnaW5hbCBi
cmFuY2gpCiMKIyBVbnRyYWNrZWQgZmlsZXM6CiMgICAodXNlICJnaXQgYWRkIDxmaWxlPi4u
LiIgdG8gaW5jbHVkZSBpbiB3aGF0IHdpbGwgYmUgY29tbWl0dGVkKQojCiMJb2JqLWJpc2Vj
dAojCW9iai1jb21waWxldGVzdAojCW9iai1pMzg2CiMJb2JqLXg4Nl82NApub3RoaW5nIGFk
ZGVkIHRvIGNvbW1pdCBidXQgdW50cmFja2VkIGZpbGVzIHByZXNlbnQgKHVzZSAiZ2l0IGFk
ZCIgdG8gdHJhY2spCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxp
bnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YzEtMTAwMy9zdGVyaWNzc29uOmJoMTc4MGdsaTplNjIwNjNkNjk5MTE4ODZhNWE5MmM3MTlk
MjYyYTJhODdlMWU1YjYwOmJpc2VjdC1zb3VuZAoKMjAxMy0xMC0wNy0wMDowMToxMiBlNjIw
NjNkNjk5MTE4ODZhNWE5MmM3MTlkMjYyYTJhODdlMWU1YjYwIGNvbXBpbGluZwobWzE7MzVt
YWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoK
MjAxMy0xMC0wNy0wMDowODo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMzLTEw
NjU2LWdlNjIwNjNkCTg2CTE1NyBURVNUIEZBSUxVUkUKWyAgIDI2Ljk0NjgzMV0gcmJ0cmVl
IHRlc3RpbmcgLT4gMzY5MTg3IGN5Y2xlcwpbICAgMzkuMjMxMzQwXSBhdWdtZW50ZWQgcmJ0
cmVlIHRlc3RpbmcKWyAgIDQ3LjkxMTI0Ml0gSU5GTzogcmN1X3NjaGVkIGRldGVjdGVkIHN0
YWxscyBvbiBDUFVzL3Rhc2tzOgpbICAgNDcuOTExMjQyXSAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMTAwMy9lNjIwNjNkNjk5MTE4ODZhNWE5MmM3MTlkMjYyYTJhODdlMWU1YjYw
L2RtZXNnLXlvY3RvLW5obTQtMjoyMDEzMTAwNjE2MTMxMDppMzg2LXJhbmRjb25maWctYzEt
MTAwMzozLjEyLjAtcmMzLTEwNjU2LWdlNjIwNjNkOjM0OAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0xMDAzL2U2MjA2M2Q2OTkxMTg4NmE1YTkyYzcxOWQyNjJhMmE4N2UxZTViNjAv
ZG1lc2cteW9jdG8tbmhtNC0yOjIwMTMxMDA2MTYxMzI1OmkzODYtcmFuZGNvbmZpZy1jMS0x
MDAzOjMuMTIuMC1yYzMtMTA2NTYtZ2U2MjA2M2Q6MzQ4CgoKPT09PT09PT09IGxpbnV4LW5l
eHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL3N0ZXJpY3Nzb246YmgxNzgwZ2xpOmEw
Y2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Y6YmlzZWN0LXNvdW5kCgoy
MDEzLTEwLTA3LTAwOjEwOjAzIGEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YgY29tcGlsaW5nChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgMTAw
MDAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTEwLTA3LTAwOjE1OjQ0IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0xMzE1OS1nYTBjZjFhYgkyMAk2
MyBURVNUIEZBSUxVUkUKbW91bnRhbGw6IHBseS1ldmVudC1sb29wLmM6NDk3OiBwbHlfZXZl
bnRfbG9vcF9uZXc6IEFzc2VydGlvbiBgbG9vcC0+ZXBvbGxfZmQgPj0gMCcgZmFpbGVkLgpb
ICAgIDYuNDU0OTU2XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICA2LjQ1NTY2NF0ga2VybmVsIEJVRyBhdCAvYy93Zmcvc291bmQva2VybmVsL3RpbWVyLmM6
MTA4NCEKWyAgICA2LjQ1NjUwM10gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAgClsg
ICAgNi40NTcxODFdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDYuNDU3Njg2XSBDUFU6IDEg
UElEOiAxMjMgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMTMxNTktZ2EwY2YxYWIgIzM0OQpbICAgIDYuNDU4MjYxXSB0YXNrOiA4NzdhYTg2MCB0
aTogOGY4ZTIwMDAgdGFzay50aTogOGY4ZTIwMDAKWyAgICA2LjQ1ODI2MV0gRUlQOiAwMDYw
Ols8ODEwNDkwYzA+XSBFRkxBR1M6IDAwMDEwMDg2IENQVTogMQpbICAgIDYuNDU4MjYxXSBF
SVAgaXMgYXQgY2FzY2FkZSsweDUwLzB4ODAKWyAgICA2LjQ1ODI2MV0gRUFYOiAwMDAwMDAw
MCBFQlg6IDgwMTA4MDAwIEVDWDogODAxMDg3NzAgRURYOiAwMDAwMDAwMApbICAgIDYuNDU4
MjYxXSBFU0k6IDhmOGUzY2FjIEVESTogOGQwMDQwNDggRUJQOiA4ZjhlM2NjMCBFU1A6IDhm
OGUzY2E4ClsgICAgNi40NTgyNjFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzog
MDBlMCBTUzogMDA2OApbICAgIDYuNDU4MjYxXSBDUjA6IDgwMDUwMDNiIENSMjogNzc3YmM2
NjEgQ1IzOiAwZjhkZTAwMCBDUjQ6IDAwMDAwNmYwClsgICAgNi40NTgyNjFdIFN0YWNrOgpb
ICAgIDYuNDU4MjYxXSAgMDAwMDAwMjggODk4ZmRiNDggODFjNjgyNjAgMDAwMDAwMDAgODAx
MDgwMDAgODAxMDhhMzggOGY4ZTNjZTggODEwNDkyYzcKWyAgICA2LjQ1ODI2MV0gIDgwMTA4
YTM4IDgwMTA4ODM4IDg3N2FhODYwIDAwMDAwMDEwIDhmOGUzY2U4IDAwMDAwMTAxIDgxNTYz
MDg0IDAwMDAwMTAwClsgICAgNi40NTgyNjFdICA4ZjhlM2QyOCA4MTA0MzVmYyA4ZjhlM2Qx
OCA4MTA2OWZjNyA4ZjhlM2QxYyA4MTA4ZDdmNCAwMDMyZGNkNSAwMDAwMDAwMApbICAgIDYu
NDU4MjYxXSBDYWxsIFRyYWNlOgpbICAgIDYuNDU4MjYxXSAgWzw4MTA0OTJjNz5dIHJ1bl90
aW1lcl9zb2Z0aXJxKzB4NzcvMHgxODAKWyAgICA2LjQ1ODI2MV0gIFs8ODEwNDM1ZmM+XSBf
X2RvX3NvZnRpcnErMHg5Yy8weDE2MApbICAgIDYuNDU4MjYxXSAgWzw4MTA2OWZjNz5dID8g
c2NoZWRfY2xvY2tfY3B1KzB4MTE3LzB4MTMwClsgICAgNi40NTgyNjFdICBbPDgxMDhkN2Y0
Pl0gPyB0aWNrX25vaHpfaGFuZGxlcisweGQ0LzB4ZTAKWyAgICA2LjQ1ODI2MV0gIFs8ODEw
NDM3ZDQ+XSBpcnFfZXhpdCsweDQ0LzB4OTAKWyAgICA2LjQ1ODI2MV0gIFs8ODEwMjdhMTU+
XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzNS8weDUwClsgICAgNi40NTgyNjFdICBb
PDgxM2IxNGExPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzMS8weDM4ClsgICAgNi40NTgy
NjFdICBbPDgxMWZmOWNkPl0gPyBpb19zZXJpYWxfaW4rMHhkLzB4MjAKWyAgICA2LjQ1ODI2
MV0gIFs8ODEyMDIzOTQ+XSBzZXJpYWw4MjUwX3N0YXJ0dXArMHgxNDQvMHg2YTAKWyAgICA2
LjQ1ODI2MV0gIFs8ODExZmQyNWI+XSB1YXJ0X3N0YXJ0dXArMHg3Yi8weDE5MApbICAgIDYu
NDU4MjYxXSAgWzw4MTFmZDY5Mz5dIHVhcnRfb3BlbisweDEwMy8weDE1MApbICAgIDYuNDU4
MjYxXSAgWzw4MTFmZDU5MD5dID8gdWFydF93YWl0X21vZGVtX3N0YXR1cysweDIyMC8weDIy
MApbICAgIDYuNDU4MjYxXSAgWzw4MTFmMmYzNz5dIHR0eV9vcGVuKzB4MzI3LzB4NTgwClsg
ICAgNi40NTgyNjFdICBbPDgxMGYxNjY2Pl0gY2hyZGV2X29wZW4rMHgxMDYvMHgxYTAKWyAg
ICA2LjQ1ODI2MV0gIFs8ODExODgzZDY+XSA/IGxvY2tyZWZfZ2V0KzB4MTYvMHgyMApbICAg
IDYuNDU4MjYxXSAgWzw4MTBmMTU2MD5dID8gY2Rldl9wdXQrMHgyMC8weDIwClsgICAgNi40
NTgyNjFdICBbPDgxMGViZDQxPl0gZG9fZGVudHJ5X29wZW4uaXNyYS4yMSsweDE3MS8weDIy
MApbICAgIDYuNDU4MjYxXSAgWzw4MTBmMTU2MD5dID8gY2Rldl9wdXQrMHgyMC8weDIwClsg
ICAgNi40NTgyNjFdICBbPDgxMGViZTBhPl0gZmluaXNoX29wZW4rMHgxYS8weDMwClsgICAg
Ni40NTgyNjFdICBbPDgxMGZhMWIyPl0gZG9fbGFzdC5pc3JhLjUyKzB4YTEyLzB4YzcwClsg
ICAgNi40NTgyNjFdICBbPDgxMGY3NjMyPl0gPyBsaW5rX3BhdGhfd2FsaysweDUyLzB4NmYw
ClsgICAgNi40NTgyNjFdICBbPDgxMGZhNjBlPl0gcGF0aF9vcGVuYXQrMHgxZmUvMHg1MDAK
WyAgICA2LjQ1ODI2MV0gIFs8ODEwZmFkOGM+XSBkb19maWxwX29wZW4rMHgyYy8weDcwClsg
ICAgNi40NTgyNjFdICBbPDgxMGVkMzA2Pl0gZG9fc3lzX29wZW4rMHgxMzYvMHgxODAKWyAg
ICA2LjQ1ODI2MV0gIFs8ODEwZWQzNmQ+XSBTeVNfb3BlbisweDFkLzB4MjAKWyAgICA2LjQ1
ODI2MV0gIFs8ODEzYjE5NGI+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgIDYu
NDU4MjYxXSBDb2RlOiAwMCA4OSA0MCAwNCA4YiA0NSBlYyAzOSBmMCA4YiAzOCA3NCAzNSA4
YiA1MCAwYyA4MyBlMiBmYyAzOSBkMyA3NCAxYyBlYiAxMiA2NiA5MCA4YiA0NyAwYyA4MyBl
MCBmYyAzOSBjMyA3NSAwNiA4OSBmOCA4OSBkNyBlYiAwOCA8MGY+IDBiIDhkIGI2IDAwIDAw
IDAwIDAwIDg5IGMyIDg5IGQ4IGU4IGRmIGZkIGZmIGZmIDM5IGY3IDhiIDE3ClsgICAgNi40
NTgyNjFdIEVJUDogWzw4MTA0OTBjMD5dIGNhc2NhZGUrMHg1MC8weDgwIFNTOkVTUCAwMDY4
OjhmOGUzY2E4ClsgICAgNi40NTgyNjFdIC0tLVsgZW5kIHRyYWNlIDNjZjQ3MTE3MGQzZmMy
ZmMgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0xMDAzL2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8td2FpbWVhLTM6MjAxMzEw
MDcwODE0MDA6aTM4Ni1yYW5kY29uZmlnLWMxLTEwMDM6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTEzMTU5LWdhMGNmMWFiOjM0OQoK

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc1 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y

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
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
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
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_SECCOMP_FILTER=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
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
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=3
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
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
# CONFIG_ACPI_NUMA is not set
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
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
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
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
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
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=m
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_VENO=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="veno"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=y
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_SCC=m
CONFIG_SCC_DELAY=y
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=m
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=y
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_BT is not set
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_AD525X_DPOT_SPI is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=m
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
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
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_STMPE=m
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=m
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
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
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
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_FSL_DSPI=m
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=m
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
# CONFIG_PPS_CLIENT_LDISC is not set
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9052 is not set
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=m
# CONFIG_GPIO_ADP5588 is not set

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
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

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
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
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
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
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
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_CROS_EC_SPI=m
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=m
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=m
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=m
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65910=m
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=m
# CONFIG_MEDIA_SUPPORT is not set

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
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI922X=m
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT1605=m
CONFIG_SND_AZT2316=m
CONFIG_SND_AZT2320=m
# CONFIG_SND_CMI8328 is not set
CONFIG_SND_CMI8330=m
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4236 is not set
CONFIG_SND_ES1688=m
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=m
# CONFIG_SND_GUSMAX is not set
CONFIG_SND_INTERWAVE=m
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=m
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=m
# CONFIG_SND_MIRO is not set
CONFIG_SND_SB8=m
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
# CONFIG_SND_SB16_CSP is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set
CONFIG_SND_MSND_PINNACLE=m
CONFIG_SND_MSND_CLASSIC=m
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
CONFIG_SND_SPI=y
# CONFIG_SND_AT73C213 is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_WM8350=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
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
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=m
# CONFIG_RTC_DRV_WM8350 is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
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
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
# CONFIG_EXTCON_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_PSTORE is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
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
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

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
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
CONFIG_DDR=y

--LQksG6bCIzRHxTLp--
