Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3IQNvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:51:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:44210 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab3IQNvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:51:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,923,1371106800"; 
   d="log'?scan'208";a="396991006"
Date: Tue, 17 Sep 2013 21:51:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [pps_ktimer_event] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33
 __list_add()
Message-ID: <20130917135122.GA17015@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    
    Implement debugging for kobject release functions.  kobjects are
    reference counted, so the drop of the last reference to them is not
    predictable. However, the common case is for the last reference to be
    the kobject's removal from a subsystem, which results in the release
    function being immediately called.
    
    This can hide subtle bugs, which can occur when another thread holds a
    reference to the kobject at the same time that a kobject is removed.
    This results in the release method being delayed.
    
    In order to make these kinds of problems more visible, the following
    patch implements a delayed release; this has the effect that the
    release function will be out of order with respect to the removal of
    the kobject in the same manner that it would be if a reference was
    being held.
    
    This provides us with an easy way to allow driver writers to debug
    their drivers and fix otherwise hidden problems.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[   85.364667] libceph: loaded (mon/osd proto 15/24)
[   85.381535] ------------[ cut here ]------------
[   85.383996] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x130/0x150()
[   85.383996] list_add corruption. prev->next should be next (c304ac60), but was   (null). (prev=cf835894).
[   85.383996] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-09992-g5a7d8a2 #8
[   85.383996]  c2a1fb20 c0035c78 c246c8a3 c0035ca8 c10cb4e1 c2a1fb4c c0035cd4 00000001
[   85.383996]  c2a1fb20 00000021 c13c9310 c13c9310 00000000 ffff047f ffff05ab c0035cc0
[   85.383996]  c10cb5da 00000009 c0035cb8 c2a1fb4c c0035cd4 c0035cf0 c13c9310 c2a1fb20
[   85.383996] Call Trace:
[   85.383996]  [<c246c8a3>] dump_stack+0x40/0x5e
[   85.383996]  [<c10cb4e1>] warn_slowpath_common+0xb1/0x100
[   85.383996]  [<c13c9310>] ? __list_add+0x130/0x150       
[   85.383996]  [<c13c9310>] ? __list_add+0x130/0x150
[   85.383996]  [<c10cb5da>] warn_slowpath_fmt+0x4a/0x60
[   85.383996]  [<c13c9310>] __list_add+0x130/0x150     
[   85.383996]  [<c10d9b5d>] __internal_add_timer+0x7d/0x110
[   85.383996]  [<c10d9ccc>] internal_add_timer+0x1c/0x70   
[   85.383996]  [<c10da937>] mod_timer+0x127/0x220       
[   85.383996]  [<c1c435f0>] ? pps_kc_event+0xb0/0xb0
[   85.383996]  [<c1c4365a>] pps_ktimer_event+0x6a/0x80
[   85.383996]  [<c10d9df5>] call_timer_fn+0xa5/0x170
[   85.383996]  [<c10d9d50>] ? process_timeout+0x30/0x30
[   85.383996]  [<c10da060>] run_timer_softirq+0x1a0/0x2f0
[   85.383996]  [<c1c435f0>] ? pps_kc_event+0xb0/0xb0
[   85.383996]  [<c10d272f>] __do_softirq+0x11f/0x2b0
[   85.383996]  [<c110fe03>] ? sched_clock_cpu+0x123/0x200
[   85.383996]  [<c10d2bb3>] irq_exit+0xe3/0x100
[   85.383996]  [<c106dc57>] do_IRQ+0x67/0x120  
[   85.383996]  [<c113b437>] ? trace_hardirqs_off+0x27/0x40
[   85.383996]  [<c24a37b1>] common_interrupt+0x31/0x36
[   85.383996]  [<c113f690>] ? lock_acquire+0xd0/0xf0
[   85.383996]  [<c2034bc2>] ? sock_register+0x32/0x100
[   85.383996]  [<c24a0a4c>] _raw_spin_lock+0x6c/0x110 
[   85.383996]  [<c2034bc2>] ? sock_register+0x32/0x100
[   85.383996]  [<c2034bc2>] sock_register+0x32/0x100  
[   85.383996]  [<c2454030>] vsock_core_init+0x160/0x280
[   85.383996]  [<c2fbb9cd>] ? nfc_hci_init+0x26/0x26
[   85.383996]  [<c2fbbb0c>] vmci_transport_init+0x13f/0x1a0
[   85.383996]  [<c2f3b5c1>] do_one_initcall+0xf2/0x21e     


git bisect start 844aa7974395df1f0c7a866007e900e5f979fc7b v3.11 --
git bisect  bad a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2  # 17:13      2-  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect  bad 40031da445fb4d269af9c7c445b2adf674f171e7  # 17:50      3-  Merge tag 'pm+acpi-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 91121c103ae93ef117e58712786864270d7f488e  # 18:33     46+  staging: dwc2: make dwc2_core_params documentation more complete
git bisect good 1d1fdd95df681f0c065d90ffaafa215a0e8825e2  # 19:15     46+  Merge tag 'char-misc-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect  bad d472d9d98b463dd7a04f2bcdeafe4261686ce6ab  # 19:24      1-  lockref: Relax in cmpxchg loop
git bisect good e438ac9ade074932383bb00d51b8ded8a0ee164b  # 20:02     46+  OMAP: serial: Remove incorrect disabling of IER interrupt
git bisect  bad 36c27a655a531f16b5567066600f0ea7fcb973b4  # 20:12      2-  w1: add attribute groups to struct w1_family_ops
git bisect  bad 13e2237f36874a7abef44b98969f399127b1917d  # 20:21      2-  v4l2: convert class code to use dev_groups
git bisect  bad 3499116b915e260b275c167a471e0e05bbe3f1d6  # 20:31      2-  PTP: convert class code to use dev_groups
git bisect  bad 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e  # 20:36      0-  dma: convert dma_devclass to use dev_groups
git bisect good 899826f16a034f1ab6d23cd5b60cd113eaefad19  # 21:36     46+  enclosure: convert class code to use dev_groups
git bisect good ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b  # 22:18     46+  c2port: convert class code to use bin_attrs in groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 22:33      2-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 23:47     46+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 00:23    138+  char: tile-srom: fix build error
git bisect  bad 5a7d8a28080caed7fd4cb1b81d092adac4445e8e  # 00:23      0-  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good 249c01e3c56c17b2905f0a33429d9466c4d4eb59  # 01:14    138+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect  bad d8efd82eece89f8a5790b0febf17522affe9e1f1  # 01:26      3-  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus

Thanks,
Fengguang

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ant-8:20130914124036:3.11.0-09992-g5a7d8a2:8"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-09992-g5a7d8a2 (kbuild@cairo) (gcc vers=
ion 4.8.1 (Debian 4.8.1-8) ) #8 Fri Sep 13 14:13:36 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x03ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x03c73000, 0x03c73fff] PGTABLE
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 1000000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128532(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
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
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] BRK [0x03c74000, 0x03c74fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c2f2fd60, node_mem_map ce=
53f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master/.vmlinu=
z-5a7d8a28080caed7fd4cb1b81d092adac4445e8e-20130913141554-2-ant branch=3Dli=
nus/master noapic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/i386-randconfig-c=
4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/vmlinuz-3.11.0-09992-g5a7d8=
a2
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 163460K/261744K available (21141K kernel code, 4119K=
 rwdata, 6636K rodata, 736K init, 12740K bss, 98284K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8c000 - 0xfffff000   ( 460 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2f3a000 - 0xc2ff2000   ( 736 kB)
[    0.000000]       .data : 0xc24a5887 - 0xc2f35f00   (10817 kB)
[    0.000000]       .text : 0xc1000000 - 0xc24a5887   (21142 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0094000 soft=3Dc0096000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.906 MHz processor
[    0.031612] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.80 BogoMIPS (lpj=3D10639686)
[    0.041369] pid_max: default: 32768 minimum: 301
[    0.054897] Mount-cache hash table entries: 512
[    0.144925] Initializing cgroup subsys memory
[    0.154211] Initializing cgroup subsys freezer
[    0.157251] Initializing cgroup subsys perf_event
[    0.158248] Initializing cgroup subsys net_prio
[    0.175634] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.175634] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.175634] tlb_flushall_shift: -1
[    0.177122] CPU: AMD QEMU Virtual CPU version 1.6.0 (fam: 06, model: 02,=
 stepping: 03)
[    0.260738] ACPI: Core revision 20130725
[    0.527503] ACPI: All ACPI Tables successfully acquired
[    0.529200] ACPI: setting ELCR to 0200 (from 0c00)
[    0.607610] Performance Events:=20
[    0.608772] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.610273] no hardware sampling interrupt available.
[    0.611714] Broken PMU hardware detected, using software events only.
[    0.612615] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.674218] Apic disabled
[    0.682679] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.814826] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.880361] regulator-dummy: no parameters
[    1.072004] NET: Registered protocol family 16
[    1.134162] cpuidle: using governor ladder
[    1.135801] cpuidle: using governor menu
[    1.160560] ACPI: bus type PCI registered
[    1.165721] dca service started, version 1.12.1
[    1.180575] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    1.181858] PCI: Using configuration type 1 for base access
[    2.275910] ACPI: Added _OSI(Module Device)
[    2.277246] ACPI: Added _OSI(Processor Device)
[    2.278018] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.278773] ACPI: Added _OSI(Processor Aggregator Device)
[    2.562014] ACPI: EC: Look up EC in DSDT
[    3.137818] ACPI: Interpreter enabled
[    3.139495] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    3.141635] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    3.148171] ACPI: (supports S0 S3 S5)
[    3.148941] ACPI: Using PIC for interrupt routing
[    3.154658] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    4.285248] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.288967] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    4.290635] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    4.331353] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    4.346011] PCI host bridge to bus 0000:00
[    4.348035] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.350861] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    4.351611] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    4.352545] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    4.353688] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    4.361152] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    4.409765] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    4.448548] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    4.465724] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    4.505382] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    4.514201] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    4.515384] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    4.551416] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    4.557272] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    4.563727] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    4.590517] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    4.629152] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    4.637152] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    4.642621] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    4.669146] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    4.711085] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    4.717187] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    4.723736] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    4.750459] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    4.787569] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    4.793780] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    4.800397] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    4.858938] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    4.865612] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    4.870469] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    4.928819] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    4.933765] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    4.940394] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    4.997647] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    5.003960] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    5.010424] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    5.069177] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    5.077082] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    5.082428] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    5.140902] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    5.147138] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    5.153744] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    5.210894] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    5.215004] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    5.269226] pci_bus 0000:00: on NUMA node 0
[    5.395220] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    5.415560] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    5.432838] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    5.451543] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    5.461848] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    5.529999] ACPI: Enabled 16 GPEs in block 00 to 0F
[    5.535195] ACPI: \_SB_.PCI0: notify handler is installed
[    5.550721] Found 1 acpi root devices
[    5.621123] ACPI: bus type USB registered
[    5.625925] usbcore: registered new interface driver usbfs
[    5.630406] usbcore: registered new interface driver hub
[    5.635221] usbcore: registered new device driver usb
[    5.649335] pps_core: LinuxPPS API ver. 1 registered
[    5.650381] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    5.653693] PTP clock support registered
[    5.667179] wmi: Mapper loaded
[    5.685942] Advanced Linux Sound Architecture Driver Initialized.
[    5.687178] PCI: Using ACPI for IRQ routing
[    5.688483] PCI: pci_cache_line_size set to 64 bytes
[    5.695828] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    5.698127] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.771314] NET: Registered protocol family 23
[    5.778212] Bluetooth: Core ver 2.16
[    5.780995] NET: Registered protocol family 31
[    5.781622] Bluetooth: HCI device and connection manager initialized
[    5.784379] Bluetooth: HCI socket layer initialized
[    5.785705] Bluetooth: L2CAP socket layer initialized
[    5.788889] Bluetooth: SCO socket layer initialized
[    5.790671] NET: Registered protocol family 8
[    5.791430] NET: Registered protocol family 20
[    5.848432] cfg80211: Calling CRDA to update world regulatory domain
[    5.867404] nfc: nfc_init: NFC Core ver 0.1
[    5.872767] NET: Registered protocol family 39
[    5.895317] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    5.906666] Switched to clocksource hpet
[    5.910913] CE: hpet increased min_delta_ns to 5000 nsec
[    5.935046] FS-Cache: Loaded
[    5.938830] pnp: PnP ACPI init
[    5.942542] ACPI: bus type PNP registered
[    5.966833] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.976860] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.986473] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    5.995264] pnp 00:03: [dma 2]
[    6.001294] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.012369] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.024622] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.065279] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.085664] pnp: PnP ACPI: found 7 devices
[    6.086623] ACPI: bus type PNP unregistered
[    6.179727] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    6.181471] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    6.182136] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    6.182850] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    6.188489] NET: Registered protocol family 2
[    6.241785] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    6.246326] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    6.259697] TCP: Hash tables configured (established 2048 bind 2048)
[    6.264726] TCP: reno registered
[    6.266062] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    6.271201] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    6.299446] NET: Registered protocol family 1
[    6.302453] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.304477] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.306570] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.309028] pci 0000:00:02.0: Boot video device
[    6.312215] PCI: CLS 0 bytes, default 64
[    6.361228] Unpacking initramfs...
[   64.522940] Freeing initrd memory: 25284K (ce73f000 - cfff0000)
[   64.546308] kvm: no hardware support
[   64.557652] kvm: Nested Virtualization enabled
[   64.595924] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   64.597694] apm: overridden by ACPI.
[   64.666222] cryptomgr_test (16) used greatest stack depth: 6908 bytes le=
ft
[   64.856321] cryptomgr_test (24) used greatest stack depth: 5928 bytes le=
ft
[   64.878267] PCLMULQDQ-NI instructions are not detected.
[   64.879275] NatSemi SCx200 Driver
[   64.919634] audit: initializing netlink socket (disabled)
[   64.927667] type=3D2000 audit(1379133591.923:1): initialized
[   64.959456] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[   65.162733] DLM installed
[   65.226576] FS-Cache: Netfs 'cifs' registered for caching
[   65.244733] fuse init (API version 7.22)
[   65.255213] 9p: Installing v9fs 9p2000 file system support
[   65.591714] tsc: Refined TSC clocksource calibration: 3191.887 MHz
[   65.779883] alg: No test for crc32 (crc32-table)
[   65.809568] alg: No test for lz4 (lz4-generic)
[   65.815901] alg: No test for stdrng (krng)
[   65.829528] NET: Registered protocol family 38
[   65.832755] Key type asymmetric registered
[   65.837768] Asymmetric key parser 'x509' registered
[   65.838609] test_string_helpers: Running tests...
[   65.882757] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   65.884329] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[   65.899220] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   65.902556] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   65.918611] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   65.921744] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   65.961166] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   65.985485] vmlfb: initializing
[   65.989060] Could not find Carillo Ranch MCH device.
[   65.993285] no IO addresses supplied
[   66.038264] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[   66.075836] ipmi message handler version 39.2
[   66.078941] IPMI System Interface driver.
[   66.085438] ipmi_si: Adding default-specified kcs state machine
[   66.086873] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   66.094140] ipmi_si: Interface detection failed
[   66.098408] ipmi_si: Adding default-specified smic state machine
[   66.099304] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   66.101502] ipmi_si: Interface detection failed
[   66.102275] ipmi_si: Adding default-specified bt state machine
[   66.103009] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   66.105500] ipmi_si: Interface detection failed
[   66.113111] ipmi_si: Unable to find any System Interface(s)
[   66.139861] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   66.144925] ACPI: Power Button [PWRF]
[   66.182704] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   66.616053] Switched to clocksource tsc
[   68.352281] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   68.399856] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   68.463295] lp: driver loaded but no devices found
[   68.466340] DoubleTalk PC - not found
[   68.469280] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   68.505813] scx200_gpio: no SCx200 gpio present
[   68.509521] nsc_gpio initializing
[   68.521766] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   68.524767] Hangcheck: Using getrawmonotonic().
[   68.549974] [drm] Initialized drm 1.1.0 20060810
[   68.602749] [drm] radeon kernel modesetting enabled.
[   68.637982] usbcore: registered new interface driver udl
[   68.673037] parport_pc 00:04: reported by Plug and Play ACPI
[   68.685875] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   68.735602] lp0: using parport0 (interrupt-driven).
[   68.871657] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   68.884818] dummy-irq: no IRQ given.  Use irq=3DN
[   68.935885] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   68.962983] c2port c2port0: C2 port uc added
[   68.964850] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   68.982319] Guest personality initialized and is inactive
[   68.989087] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[   68.990200] Initialized host personality
[   69.032814] usbcore: registered new interface driver viperboard
[   69.036063] usbcore: registered new interface driver pn533
[   69.153286] libphy: Fixed MDIO Bus: probed
[   69.178039] arcnet loaded.
[   69.178696] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[   69.181662] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[   69.182560] E-mail me if you actually test this driver, please!
[   69.183497]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[   69.191536] vcan: Virtual CAN interface driver
[   69.198563] usbcore: registered new interface driver irda-usb
[   69.224253] usbcore: registered new interface driver mcs7780
[   69.226218] usbcore: registered new interface driver kingsun-sir
[   69.232217] usbcore: registered new interface driver ksdazzle-sir
[   69.233062] PPP generic driver version 2.4.2
[   69.249438] PPP BSD Compression module registered
[   69.252033] PPP MPPE Compression module registered
[   69.254929] hdlc: HDLC support module revision 1.22
[   69.261700] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[   69.262557] SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
[   69.321918] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[   69.348582] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[   69.351338] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[   69.356117] usbcore: registered new interface driver kaweth
[   69.357848] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   69.359813] usbcore: registered new interface driver pegasus
[   69.362656] usbcore: registered new interface driver r8152
[   69.365389] usbcore: registered new interface driver cdc_ether
[   69.368024] usbcore: registered new interface driver r815x
[   69.369803] usbcore: registered new interface driver cdc_eem
[   69.372502] usbcore: registered new interface driver dm9601
[   69.375144] usbcore: registered new interface driver sr9700
[   69.377930] usbcore: registered new interface driver smsc75xx
[   69.379745] usbcore: registered new interface driver plusb
[   69.382477] usbcore: registered new interface driver rndis_host
[   69.385103] usbcore: registered new interface driver zaurus
[   69.387681] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   69.390998] usbcore: registered new interface driver int51x1
[   69.392886] usbcore: registered new interface driver kalmia
[   69.395565] usbcore: registered new interface driver ipheth
[   69.398075] usbcore: registered new interface driver sierra_net
[   69.399848] usbcore: registered new interface driver cdc_ncm
[   69.447576] parport0: cannot grant exclusive access for device ks0108
[   69.448789] ks0108: ERROR: parport didn't register new device
[   69.449677] cfag12864b: ERROR: ks0108 is not initialized
[   69.451430] cfag12864bfb: ERROR: cfag12864b is not initialized
[   69.465974] Intel ISA PCIC probe: not found.
[   69.501155] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   69.502310] ehci-pci: EHCI PCI platform driver
[   69.506402] ehci-platform: EHCI generic platform driver
[   69.511545] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   69.514519] ohci-pci: OHCI PCI platform driver
[   69.518506] ohci-platform: OHCI generic platform driver
[   69.521559] uhci_hcd: USB Universal Host Controller Interface driver
[   69.555278] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   69.556114] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   69.559410] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   69.560990]=20
[   69.565190] usbcore: registered new interface driver usblp
[   69.567693] usbcore: registered new interface driver cdc_wdm
[   69.571528] usbcore: registered new interface driver mdc800
[   69.572305] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   69.575094] usbcore: registered new interface driver adutux
[   69.577922] usbcore: registered new interface driver cypress_cy7c63
[   69.578833] driver ftdi-elan
[   69.594391] usbcore: registered new interface driver ftdi-elan
[   69.598504] usbcore: registered new interface driver iowarrior
[   69.601604] usbcore: registered new interface driver isight_firmware
[   69.604346] usbcore: registered new interface driver usblcd
[   69.606235] usbcore: registered new interface driver legousbtower
[   69.608972] usbcore: registered new interface driver rio500
[   69.611642] usbcore: registered new interface driver usbtest
[   69.614388] usbcore: registered new interface driver usb_ehset_test
[   69.616344] usbcore: registered new interface driver trancevibrator
[   69.619090] usbcore: registered new interface driver uss720
[   69.619850] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[   69.621892] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[   69.622758] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[   69.624356] uss720: If you just want to connect to a printer, use usblp =
instead
[   69.626655] usbcore: registered new interface driver usbsevseg
[   69.653520] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   69.687624] serio: i8042 KBD port at 0x60,0x64 irq 1
[   69.692116] serio: i8042 AUX port at 0x60,0x64 irq 12
[   69.701254] parport0: cannot grant exclusive access for device parkbd
[   69.749207] mousedev: PS/2 mouse device common for all mice
[   69.762654] usbcore: registered new interface driver usb_acecad
[   69.765562] usbcore: registered new interface driver aiptek
[   69.782699] usbcore: registered new interface driver kbtab
[   69.826493] mk712: device not present
[   69.855580] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   69.873249] rtc_cmos 00:00: RTC can wake from S4
[   69.903530] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   69.911068] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   69.972707] rtc-test rtc-test.0: rtc core: registered test as rtc1
[   69.986287] rtc-test rtc-test.1: rtc core: registered test as rtc2
[   69.995470] i2c /dev entries driver
[   70.026270] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   70.275218] usbcore: registered new interface driver i2c-diolan-u2c
[   70.276186] i2c-parport-light: adapter type unspecified
[   70.278815] usbcore: registered new interface driver i2c-tiny-usb
[   70.294409] isa i2c-pca-isa.0: Please specify I/O base
[   70.301289] scx200_i2c: no SCx200 gpio pins available
[   70.314937] pps pps0: new PPS source ktimer
[   70.315892] pps pps0: ktimer PPS source registered
[   70.316549] pps_parport: parallel port PPS client
[   70.318500] parport0: cannot grant exclusive access for device pps_parpo=
rt
[   70.319392] pps_parport: couldn't register with parport0
[   70.322677] Driver for 1-wire Dallas network protocol.
[   70.332996] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   70.345703] power_supply test_ac: uevent
[   70.346442] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   70.349448] power_supply test_ac: prop ONLINE=3D1
[   70.352991] power_supply test_ac: power_supply_changed
[   70.359978] power_supply test_ac: power_supply_changed_work
[   70.364777] power_supply test_ac: uevent
[   70.365486] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   70.374601] power_supply test_ac: prop ONLINE=3D1
[   70.379334] power_supply test_battery: uevent
[   70.379985] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   70.382093] power_supply test_battery: prop STATUS=3DDischarging
[   70.383236] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   70.385060] power_supply test_battery: prop HEALTH=3DGood
[   70.386002] power_supply test_battery: prop PRESENT=3D1
[   70.387758] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   70.388638] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   70.389529] power_supply test_battery: prop CHARGE_FULL=3D100
[   70.391355] power_supply test_battery: prop CHARGE_NOW=3D50
[   70.392130] power_supply test_battery: prop CAPACITY=3D50
[   70.393021] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   70.394957] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   70.395894] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   70.397732] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   70.398736] power_supply test_battery: prop MANUFACTURER=3DLinux
[   70.399619] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-09992=
-g5a7d8a2
[   70.401729] power_supply test_battery: prop TEMP=3D26
[   70.402550] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   70.448957] power_supply test_battery: power_supply_changed
[   70.462418] power_supply test_battery: power_supply_changed_work
[   70.464668] power_supply test_battery: uevent
[   70.465332] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   70.466310] power_supply test_battery: prop STATUS=3DDischarging
[   70.468017] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   70.468886] power_supply test_battery: prop HEALTH=3DGood
[   70.469649] power_supply test_battery: prop PRESENT=3D1
[   70.471296] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   70.472205] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   70.473147] power_supply test_battery: prop CHARGE_FULL=3D100
[   70.475118] power_supply test_battery: prop CHARGE_NOW=3D50
[   70.475995] power_supply test_battery: prop CAPACITY=3D50
[   70.477752] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   70.478767] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   70.479746] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   70.481786] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   70.482706] power_supply test_battery: prop MANUFACTURER=3DLinux
[   70.484625] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-09992=
-g5a7d8a2
[   70.485717] power_supply test_battery: prop TEMP=3D26
[   70.502337] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   70.509151] power_supply test_usb: uevent
[   70.509902] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   70.512004] power_supply test_usb: prop ONLINE=3D1
[   70.513221] power_supply test_usb: power_supply_changed
[   70.568063] power_supply test_usb: power_supply_changed_work
[   70.569604] power_supply test_usb: uevent
[   70.571238] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   70.573747] power_supply test_usb: prop ONLINE=3D1
[   71.605608] i2c i2c-0: detect fail: address match, 0x2c
[   71.622143] i2c i2c-0: detect fail: address match, 0x2d
[   71.635039] i2c i2c-0: detect fail: address match, 0x2e
[   71.648014] i2c i2c-0: detect fail: address match, 0x2f
[   71.871936] applesmc: supported laptop not found!
[   71.872657] applesmc: driver init failed (ret=3D-19)!
[   78.756512] intel_powerclamp: Intel powerclamp does not run on family 6 =
model 2
[   78.758497] Bluetooth: Virtual HCI driver ver 1.3
[   78.777757] usbcore: registered new interface driver bcm203x
[   78.779991] usbcore: registered new interface driver bpa10x
[   78.795721] usbcore: registered new interface driver btusb
[   78.796602] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   78.800992] usbcore: registered new interface driver ath3k
[   78.816327] CAPI 2.0 started up with major 68 (no middleware)
[   78.818619] Modular ISDN core version 1.1.29
[   78.829612] NET: Registered protocol family 34
[   78.835960] mISDN: HFC-multi driver 2.03
[   78.842054] AVM Fritz PCI driver Rev. 2.3
[   78.846666] Sedlbauer Speedfax+ Driver Rev. 2.0
[   78.851966] Infineon ISDN Driver Rev. 1.0
[   78.857823] mISDNipac module version 2.0
[   78.858643] mISDN: ISAR driver Rev. 2.1
[   78.861493] sdhci: Secure Digital Host Controller Interface driver
[   78.862392] sdhci: Copyright(c) Pierre Ossman
[   78.863107] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   78.865403] wbsd: Copyright(c) Pierre Ossman
[   78.876341] usbcore: registered new interface driver ushc
[   78.881364] sdhci-pltfm: SDHCI platform and OF driver helper
[   82.345288]  (null): enodev DEV ADDR =3D 0xFF
[   82.438384] rdma_ucm: couldn't register sysctl paths
[   82.507878] cs5535-clockevt: Could not allocate MFGPT timer
[   82.512290] hidraw: raw HID events driver (C) Jiri Kosina
[   82.565726] usbcore: registered new interface driver usbmouse
[   82.708213] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[   82.716640] usbcore: registered new interface driver tranzport
[   82.733233] usbcore: registered new interface driver alphatrack
[   82.737788] usbcore: registered new interface driver line6usb
[   82.738888] vme_user: VME User Space Access Driver
[   82.739671] vme_user: No cards, skipping registration
[   82.811323] Loading crystalhd 0.9.27
[   82.825263] cxt1e1: $Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop S=
ystems$
[   82.828007] cxt1e1: No boards found
[   82.848433] usbcore: registered new interface driver ft1000usb
[   82.906435] logger: created 256K log 'log_main'
[   82.936511] logger: created 256K log 'log_events'
[   82.953291] logger: created 256K log 'log_radio'
[   82.977481] logger: created 256K log 'log_system'
[   83.014693] ozwpan ozwpan: Ozmo Devices WPAN
[   83.036430] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[   83.295631] hub 1-0:1.0: USB hub found
[   83.303006] hub 1-0:1.0: 8 ports detected
[   83.449919] usbcore: registered new interface driver gdm_wimax
[   83.469717] usbcore: registered new interface driver cedusb
[   83.939974] sb: Init: Starting Probe...
[   83.946342] sb: Init: Done
[   84.318682] unable to register OSS PCM device 0:0
[   84.435009] no UART detected at 0x1
[   84.472985] MTVAP port 0x378 is busy
[   84.479937] snd_mtpav: probe of snd_mtpav failed with error -16
[   84.512760] snd_mts64: probe of snd_mts64.0 failed with error -5
[   84.545186] snd_portman2x4: probe of snd_portman2x4.0 failed with error =
-5
[   84.572243] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   84.618522] usbcore: registered new interface driver snd-usb-usx2y
[   84.621822] usbcore: registered new interface driver snd-usb-us122l
[   84.625068] usbcore: registered new interface driver snd-usb-caiaq
[   84.628384] usbcore: registered new interface driver snd-usb-6fire
[   84.662767] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   84.688017] NET: Registered protocol family 26
[   84.692959] ipip: IPv4 over IPv4 tunneling driver
[   84.719568] IPv4 over IPSec tunneling driver
[   84.751228] TCP: cubic registered
[   84.752062] TCP: westwood registered
[   84.752773] TCP: highspeed registered
[   84.754368] TCP: hybla registered
[   84.755049] TCP: htcp registered
[   84.755717] TCP: vegas registered
[   84.756404] TCP: scalable registered
[   84.757979] TCP: lp registered
[   84.758663] TCP: yeah registered
[   84.785839] NET: Registered protocol family 10
[   84.878988] mip6: Mobile IPv6
[   84.881323] sit: IPv6 over IPv4 tunneling driver
[   84.933533] NET: Registered protocol family 15
[   84.951795] NET: Registered protocol family 4
[   84.958710] NET: Registered protocol family 9
[   84.959904] X.25 for Linux Version 0.2
[   84.965798] can: controller area network core (rev 20120528 abi 9)
[   84.972996] NET: Registered protocol family 29
[   84.975215] can: raw protocol (rev 20120528)
[   84.978298] can: broadcast manager protocol (rev 20120528 t)
[   84.979991] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   84.982045] Bluetooth: BNEP filters: protocol multicast
[   84.985318] Bluetooth: BNEP socket layer initialized
[   84.986254] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   84.988615] Bluetooth: CMTP socket layer initialized
[   84.989532] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   84.992193] Bluetooth: HIDP socket layer initialized
[   84.996187] NET: Registered protocol family 33
[   84.998005] Key type rxrpc registered
[   84.998753] Key type rxrpc_s registered
[   85.015464] RxRPC: Registered security type 2 'rxkad'
[   85.029433] lec:lane_module_init: lec.c: initialized
[   85.034429] l2tp_core: L2TP core driver, V2.0
[   85.035262] 8021q: 802.1Q VLAN Support v1.8
[   85.074639] DCCP: Activated CCID 2 (TCP-like)
[   85.076264] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   85.141055] sctp: Hash tables configured (established 1638 bind 1489)
[   85.233514] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   85.244323] rds_rdma_listen_init(): cm cf87c000 listening on port 18634
[   85.246232] rds_rdma_listen_stop(): cm cf87c000
[   85.275592] Registered RDS/tcp transport
[   85.317754] 9pnet: Installing 9P2000 support
[   85.332110] NET: Registered protocol family 37
[   85.334998] NET: Registered protocol family 36
[   85.346920] Key type dns_resolver registered
[   85.351217] Key type ceph registered
[   85.364667] libceph: loaded (mon/osd proto 15/24)
[   85.381535] ------------[ cut here ]------------
[   85.383996] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x1=
30/0x150()
[   85.383996] list_add corruption. prev->next should be next (c304ac60), b=
ut was   (null). (prev=3Dcf835894).
[   85.383996] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-09992-g5a7d8a=
2 #8
[   85.383996]  c2a1fb20 c0035c78 c246c8a3 c0035ca8 c10cb4e1 c2a1fb4c c0035=
cd4 00000001
[   85.383996]  c2a1fb20 00000021 c13c9310 c13c9310 00000000 ffff047f ffff0=
5ab c0035cc0
[   85.383996]  c10cb5da 00000009 c0035cb8 c2a1fb4c c0035cd4 c0035cf0 c13c9=
310 c2a1fb20
[   85.383996] Call Trace:
[   85.383996]  [<c246c8a3>] dump_stack+0x40/0x5e
[   85.383996]  [<c10cb4e1>] warn_slowpath_common+0xb1/0x100
[   85.383996]  [<c13c9310>] ? __list_add+0x130/0x150
[   85.383996]  [<c13c9310>] ? __list_add+0x130/0x150
[   85.383996]  [<c10cb5da>] warn_slowpath_fmt+0x4a/0x60
[   85.383996]  [<c13c9310>] __list_add+0x130/0x150
[   85.383996]  [<c10d9b5d>] __internal_add_timer+0x7d/0x110
[   85.383996]  [<c10d9ccc>] internal_add_timer+0x1c/0x70
[   85.383996]  [<c10da937>] mod_timer+0x127/0x220
[   85.383996]  [<c1c435f0>] ? pps_kc_event+0xb0/0xb0
[   85.383996]  [<c1c4365a>] pps_ktimer_event+0x6a/0x80
[   85.383996]  [<c10d9df5>] call_timer_fn+0xa5/0x170
[   85.383996]  [<c10d9d50>] ? process_timeout+0x30/0x30
[   85.383996]  [<c10da060>] run_timer_softirq+0x1a0/0x2f0
[   85.383996]  [<c1c435f0>] ? pps_kc_event+0xb0/0xb0
[   85.383996]  [<c10d272f>] __do_softirq+0x11f/0x2b0
[   85.383996]  [<c110fe03>] ? sched_clock_cpu+0x123/0x200
[   85.383996]  [<c10d2bb3>] irq_exit+0xe3/0x100
[   85.383996]  [<c106dc57>] do_IRQ+0x67/0x120
[   85.383996]  [<c113b437>] ? trace_hardirqs_off+0x27/0x40
[   85.383996]  [<c24a37b1>] common_interrupt+0x31/0x36
[   85.383996]  [<c113f690>] ? lock_acquire+0xd0/0xf0
[   85.383996]  [<c2034bc2>] ? sock_register+0x32/0x100
[   85.383996]  [<c24a0a4c>] _raw_spin_lock+0x6c/0x110
[   85.383996]  [<c2034bc2>] ? sock_register+0x32/0x100
[   85.383996]  [<c2034bc2>] sock_register+0x32/0x100
[   85.383996]  [<c2454030>] vsock_core_init+0x160/0x280
[   85.383996]  [<c2fbb9cd>] ? nfc_hci_init+0x26/0x26
[   85.383996]  [<c2fbbb0c>] vmci_transport_init+0x13f/0x1a0
[   85.383996]  [<c2f3b5c1>] do_one_initcall+0xf2/0x21e
[   85.383996]  [<c106dc57>] ? do_IRQ+0x67/0x120
[   85.383996]  [<c106dc57>] ? do_IRQ+0x67/0x120
[   85.383996]  [<c139f100>] ? memscan+0x50/0x50
[   85.383996]  [<c24a2c79>] ? restore_all+0xf/0xf
[   85.383996]  [<c2fa6fa7>] ? snd_soc_util_init+0xaf/0xaf
[   85.383996]  [<c2f3b93c>] kernel_init_freeable+0x24f/0x3b1
[   85.383996]  [<c2f3a701>] ? do_early_param+0x131/0x131
[   85.383996]  [<c245abf9>] kernel_init+0x19/0x280
[   85.383996]  [<c24a3237>] ret_from_kernel_thread+0x1b/0x28
[   85.383996]  [<c245abe0>] ? rest_init+0x190/0x190
[   85.383996] ---[ end trace cd329a1e55315814 ]---
[   85.439732] NET: Registered protocol family 40
[   85.441689] mpls_gso: MPLS GSO support
[   85.465419]=20
[   85.465419] printing PIC contents
[   85.466470] ... PIC  IMR: ec78
[   85.467192] ... PIC  IRR: 0011
[   85.468761] ... PIC  ISR: 0000
[   85.469404] ... PIC ELCR: 0200
[   85.471074] Using IPI Shortcut mode
[   85.494871] registered taskstats version 1
[   85.563241] rtc_cmos 00:00: setting system clock to 2013-09-14 04:40:19 =
UTC (1379133619)
[   85.588304] ALSA device list:
[   85.589016]   #0: Dummy 1
[   85.589599]   #1: Virtual MIDI Card 1
[   85.591290]   #2: Internal PC-Speaker at port 0x61
[   85.790996] Freeing unused kernel memory: 736K (c2f3a000 - c2ff2000)
[   85.817398] ------------[ cut here ]------------
[   85.817540] Kernel BUG at c10d9ca0 [verbose debug info unavailable]
[   85.817540] invalid opcode: 0000 [#1]=20
[   85.817540] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-09=
992-g5a7d8a2 #8
[   85.817540] task: c0038000 ti: c0034000 task.ti: c0034000
[   85.817540] EIP: 0060:[<c10d9ca0>] EFLAGS: 00000086 CPU: 0
[   85.817540] EIP is at cascade+0xb0/0xc0
[   85.817540] EAX: 00000000 EBX: c304a400 ECX: c304a758 EDX: c39c7000
[   85.817540] ESI: c0035e54 EDI: cf835894 EBP: c0035e68 ESP: c0035e50
[   85.817540]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   85.817540] CR0: 8005003b CR2: 00000000 CR3: 02ff5000 CR4: 00000690
[   85.817540] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   85.817540] DR6: 00000000 DR7: 00000000
[   85.817540] Stack:
[   85.817540]  00000005 c3ba2240 c39c7000 00000000 c304a400 c304ae38 c0035=
e90 c10da0f6
[   85.817540]  c304ae38 c304ac38 00000100 c0035e90 00000002 00000001 c0034=
000 c30485a4
[   85.817540]  c0035ed0 c10d272f 00000046 00000046 c0035ebc c110fe03 faf23=
297 00000013
[   85.817540] Call Trace:
[   85.817540]  [<c10da0f6>] run_timer_softirq+0x236/0x2f0
[   85.817540]  [<c10d272f>] __do_softirq+0x11f/0x2b0
[   85.817540]  [<c110fe03>] ? sched_clock_cpu+0x123/0x200
[   85.817540]  [<c10d2bb3>] irq_exit+0xe3/0x100
[   85.817540]  [<c106dc57>] do_IRQ+0x67/0x120
[   85.817540]  [<c24a37b1>] common_interrupt+0x31/0x36
[   85.817540]  [<c10c6fea>] ? mm_alloc+0x3a/0xd0
[   85.817540]  [<c1201cb2>] do_execve+0x382/0xc30
[   85.817540]  [<c1201a9f>] ? do_execve+0x16f/0xc30
[   85.817540]  [<c245ac75>] kernel_init+0x95/0x280
[   85.817540]  [<c24a3237>] ret_from_kernel_thread+0x1b/0x28
[   85.817540]  [<c245abe0>] ? rest_init+0x190/0x190
[   85.817540] Code: 83 05 10 b8 04 c3 01 83 15 14 b8 04 c3 00 39 f7 75 b9 =
83 05 20 b8 04 c3 01 8b 45 e8 83 15 24 b8 04 c3 00 83 c4 0c 5b 5e 5f 5d c3 =
<0f> 0b 83 05 08 b8 04 c3 01 83 15 0c b8 04 c3 00 55 89 e5 56 89
[   85.817540] EIP: [<c10d9ca0>] cascade+0xb0/0xc0 SS:ESP 0068:c0035e50
[   85.817540] ---[ end trace cd329a1e55315816 ]---
[   85.817540] Kernel panic - not syncing: Fatal exception in interrupt
[   85.817540] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 130
qemu-system-x86_64 -kernel /tmp//kernel/i386-randconfig-c4-0912/5a7d8a28080=
caed7fd4cb1b81d092adac4445e8e/vmlinuz-3.11.0-09992-g5a7d8a2-27860 -append '=
hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf_len=3D8M ig=
nore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_en=
abled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-r=
andconfig-c4-0912/linus:master/.vmlinuz-5a7d8a28080caed7fd4cb1b81d092adac44=
45e8e-20130913141554-2-ant branch=3Dlinus/master noapic nolapic nohz=3Doff =
BOOT_IMAGE=3D/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092a=
dac4445e8e/vmlinuz-3.11.0-09992-g5a7d8a2'  -initrd /kernel-tests/initrd/qua=
ntal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:0=
0:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::31956-:22 -net nic,vl=
an=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchd=
og i6300esb -drive file=3D/fs/sdc1/disk0-ant-27860,media=3Ddisk,if=3Dvirtio=
 -drive file=3D/fs/sdc1/disk1-ant-27860,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/sdc1/disk2-ant-27860,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc=
1/disk3-ant-27860,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk4-ant=
-27860,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk5-ant-27860,medi=
a=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-ant-lkp-27860 -serial file=
:/dev/shm/kboot/serial-ant-lkp-27860 -daemonize -display none -monitor null=
=20

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-5a7d8a28080caed7fd4cb1b81d092adac4445e8e-i386-randconfig-c4-0912-WARNING:-CPU:-59419.log"

git checkout 844aa7974395df1f0c7a866007e900e5f979fc7b
Previous HEAD position was 5a7d8a2... Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
HEAD is now at 844aa79... pktcdvd: add struct pktcdvd_device * to pkt_dbg
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:844aa7974395df1f0c7a866007e900e5f979fc7b:bisect-usb
 TEST FAILURE
[   87.523818] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-09334-g844aa79 #59
[   87.523818] task: c0038000 ti: c0034000 task.ti: c0034000
[   87.523818] EIP: 0060:[<c10d9b70>] EFLAGS: 00000086 CPU: 0
[   87.523818] EIP is at cascade+0xb0/0xc0
[   87.523818] EAX: 00000000 EBX: c30433c0 ECX: c3043920 EDX: c0035c28
[   87.523818] ESI: c0035c28 EDI: cf837894 EBP: c0035c3c ESP: c0035c24
[   87.523818]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   87.523818] CR0: 8005003b CR2: 00000000 CR3: 02fee000 CR4: 00000690
[   87.523818] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   87.523818] DR6: 00000000 DR7: 00000000
[   87.523818] Stack:
[   87.523818]  00000007 cf82845c cf837894 00000000 c30433c0 c3043df8 c0035c64 c10d9fc6
[   87.523818]  c3043df8 c3043bf8 00000100 c0035c64 00000002 00000001 c0034000 c3041564
[   87.523818]  c0035ca4 c10d25ff 00000046 00000046 c0035c90 c110fcd3 60a3e038 00000014
[   87.523818] Call Trace:
[   87.523818]  [<c10d9fc6>] run_timer_softirq+0x236/0x2f0
[   87.523818]  [<c10d25ff>] __do_softirq+0x11f/0x2b0
[   87.523818]  [<c110fcd3>] ? sched_clock_cpu+0x123/0x200
[   87.523818]  [<c10d2a83>] irq_exit+0xe3/0x100
[   87.523818]  [<c106dba7>] do_IRQ+0x67/0x120
[   87.523818]  [<c24a05b1>] common_interrupt+0x31/0x36
[   87.523818]  [<c162dc0a>] ? serial8250_startup+0x67a/0xde0
[   87.523818]  [<c1625758>] uart_startup+0x98/0x3c0
[   87.523818]  [<c1626fc3>] uart_open+0x163/0x260
[   87.523818]  [<c1626e60>] ? uart_close+0x3b0/0x3b0
[   87.523818]  [<c161185d>] tty_open+0x29d/0xb10
[   87.523818]  [<c11fc7ab>] chrdev_open+0xdb/0x2f0
[   87.523818]  [<c11fc6d0>] ? exact_lock+0x50/0x50
[   87.523818]  [<c11f29fd>] do_dentry_open.isra.18+0xcd/0x3d0
[   87.523818]  [<c11f4584>] finish_open+0x24/0x70
[   87.523818]  [<c120c941>] do_last+0x7d1/0x11a0
[   87.523818]  [<c12079a6>] ? path_init+0x426/0x860
[   87.523818]  [<c120d420>] path_openat+0x110/0xb60
[   87.523818]  [<c113b307>] ? trace_hardirqs_off+0x27/0x40
[   87.523818]  [<c1110121>] ? local_clock+0xd1/0xf0
[   87.523818]  [<c120deaa>] do_filp_open+0x3a/0xd0
[   87.523818]  [<c11f4e43>] do_sys_open+0x1e3/0x380
[   87.523818]  [<c10f735b>] ? parse_args+0x2eb/0x5f0
[   87.523818]  [<c249fa69>] ? restore_all+0xf/0xf
[   87.523818]  [<c11f500b>] SyS_open+0x2b/0x50
[   87.523818]  [<c2f349b5>] kernel_init_freeable+0x2c8/0x3b1
[   87.523818]  [<c2f33701>] ? do_early_param+0x131/0x131
[   87.523818]  [<c24578b9>] kernel_init+0x19/0x280
[   87.523818]  [<c24a0037>] ret_from_kernel_thread+0x1b/0x28
[   87.523818]  [<c24578a0>] ? rest_init+0x190/0x190
[   87.523818] Code: 83 05 d0 47 04 c3 01 83 15 d4 47 04 c3 00 39 f7 75 b9 83 05 e0 47 04 c3 01 8b 45 e8 83 15 e4 47 04 c3 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 c8 47 04 c3 01 83 15 cc 47 04 c3 00 55 89 e5 56 89
[   87.523818] EIP: [<c10d9b70>] cascade+0xb0/0xc0 SS:ESP 0068:c0035c24
[   87.523818] ---[ end trace 6faa8ab9e82b11ef ]---
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-bens-2:20130915034006:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-bens-3:20130915043107:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-bens-4:20130914213900:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-lkp-st01-8:20130915041237:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-nhm4-5:20130914122347:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-roam-24:20130915142339:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-roam-25:20130915141933:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-roam-2:20130915141126:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-waimea-1:20130915142428:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-xian-14:20130915142034:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-quantal-xps-3:20130914003548:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-yocto-ant-6:20130915052430:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-yocto-lkp-st01-6:20130915050231:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-yocto-xian-27:20130915142518:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-yocto-xps-7:20130914182156:3.11.0-09334-g844aa79:59
/kernel/i386-randconfig-c4-0912/844aa7974395df1f0c7a866007e900e5f979fc7b/dmesg-yocto-xps-8:20130914183305:3.11.0-09334-g844aa79:59

bisect: bad commit 844aa7974395df1f0c7a866007e900e5f979fc7b
git checkout v3.11
Previous HEAD position was 844aa79... pktcdvd: add struct pktcdvd_device * to pkt_dbg
HEAD is now at 6e46645... Linux 3.11
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:6e4664525b1db28f8c4e1130957f70a94c19213e:bisect-usb
 SUCCESS

bisect: good commit v3.11
git bisect start 844aa7974395df1f0c7a866007e900e5f979fc7b v3.11 --
Previous HEAD position was 6e46645... Linux 3.11
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 4524 revisions left to test after this (roughly 12 steps)
[a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2:bisect-usb

2013-09-16-16:57:26 a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2 compiling
863 real  2118 user  171 sys  265.33% cpu 	i386-randconfig-c4-0912

2013-09-16-17:12:48 detecting boot state 3.11.0-04809-ga09e9a7.	2 TEST FAILURE
[   13.282877] CPU: 0 PID: 242 Comm: MAKEDEV Not tainted 3.11.0-04809-ga09e9a7 #400
[   13.283348] task: cf93cec0 ti: cf958000 task.ti: cf958000
[   13.283348] EIP: 0060:[<c10da310>] EFLAGS: 00010086 CPU: 0
[   13.283348] EIP is at cascade+0xb0/0xc0
[   13.283348] EAX: 00000000 EBX: c2ffe5c0 ECX: c2ffeb30 EDX: cf959d14
[   13.283348] ESI: cf959d14 EDI: cf849394 EBP: cf959d28 ESP: cf959d10
[   13.283348]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   13.283348] CR0: 80050033 CR2: 080764c0 CR3: 0f95c000 CR4: 00000690
[   13.283348] Stack:
[   13.283348]  00000030 c3766a40 cf849394 00000000 c2ffe5c0 c2ffeff8 cf959d50 c10da766
[   13.283348]  c2ffeff8 c2ffedf8 00000100 cf959d50 00000002 00000001 cf958000 c2ffc744
[   13.283348]  cf959d90 c10d2d7f 00000046 00000046 cf959d7c c11104f3 178d1b10 00000003
[   13.283348] Call Trace:
[   13.283348]  [<c10da766>] run_timer_softirq+0x236/0x2f0
[   13.283348]  [<c10d2d7f>] __do_softirq+0x11f/0x2b0
[   13.283348]  [<c11104f3>] ? sched_clock_cpu+0x123/0x200
[   13.283348]  [<c10d3203>] irq_exit+0xe3/0x100
[   13.283348]  [<c10a4299>] smp_apic_timer_interrupt+0x69/0x80
[   13.283348]  [<c24848f2>] apic_timer_interrupt+0x32/0x38
[   13.283348]  [<c114037a>] ? lock_release+0x13a/0x400
[   13.283348]  [<c11961f6>] ? find_get_page+0xd6/0x180
[   13.283348]  [<c1196218>] find_get_page+0xf8/0x180
[   13.283348]  [<c1196120>] ? __lock_page_or_retry+0x170/0x170
[   13.283348]  [<c1196671>] filemap_fault+0x81/0x7d0
[   13.283348]  [<c11ba0e1>] __do_fault+0x71/0x930
[   13.283348]  [<c1135418>] ? lock_release_holdtime+0xb8/0x1e0
[   13.283348]  [<c113ebb3>] ? __lock_acquire+0x633/0x1710
[   13.283348]  [<c11bfe75>] handle_pte_fault+0xc5/0x8d0
[   13.283348]  [<c10b9adf>] ? kmap_atomic_prot+0x7f/0x270
[   13.283348]  [<c11c079e>] handle_mm_fault+0x11e/0x1c0
[   13.283348]  [<c10b28a4>] __do_page_fault+0x274/0x910
[   13.283348]  [<c11c1c6d>] ? might_fault+0x7d/0x100
[   13.283348]  [<c139c50c>] ? copy_to_user+0x5c/0x90
[   13.283348]  [<c2484d7b>] ? sysenter_exit+0xf/0x1a
[   13.283348]  [<c113b502>] ? trace_hardirqs_on_caller+0x292/0x3b0
[   13.283348]  [<c10aee90>] ? kvm_read_and_reset_pf_reason+0x40/0x40
[   13.283348]  [<c10b31a6>] do_page_fault+0x16/0x30
[   13.283348]  [<c10aeeb0>] do_async_page_fault+0x20/0xf0
[   13.283348]  [<c2484ab5>] error_code+0x5d/0x64
[   13.283348]  [<c10aee90>] ? kvm_read_and_reset_pf_reason+0x40/0x40
[   13.283348] Code: 83 05 d0 f9 ff c2 01 83 15 d4 f9 ff c2 00 39 f7 75 b9 83 05 e0 f9 ff c2 01 8b 45 e8 83 15 e4 f9 ff c2 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 c8 f9 ff c2 01 83 15 cc f9 ff c2 00 55 89 e5 56 89
[   13.283348] EIP: [<c10da310>] cascade+0xb0/0xc0 SS:ESP 0068:cf959d10
[   13.283348] ---[ end trace a10a7a3e5c4edd49 ]---
/kernel/i386-randconfig-c4-0912/a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2/dmesg-yocto-xian-17:20130916171327:3.11.0-11567-gedcd1c76:47

Bisecting: 2353 revisions left to test after this (roughly 11 steps)
[40031da445fb4d269af9c7c445b2adf674f171e7] Merge tag 'pm+acpi-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:40031da445fb4d269af9c7c445b2adf674f171e7:bisect-usb

2013-09-16-17:13:58 40031da445fb4d269af9c7c445b2adf674f171e7 compiling
1772 real  2110 user  173 sys  128.88% cpu 	i386-randconfig-c4-0912

2013-09-16-17:49:28 detecting boot state 3.11.0-02455-g40031da	1	3 TEST FAILURE
[   13.282199] CPU: 0 PID: 201 Comm: MAKEDEV Not tainted 3.11.0-02455-g40031da #401
[   13.283246] task: cf933480 ti: cf94e000 task.ti: cf94e000
[   13.283342] EIP: 0060:[<c10d6410>] EFLAGS: 00010082 CPU: 0
[   13.283342] EIP is at cascade+0xb0/0xc0
[   13.283342] EAX: 00000000 EBX: c2fcf640 ECX: c2fcfd38 EDX: cf94ff18
[   13.283342] ESI: cf94ff18 EDI: cf843394 EBP: cf94ff2c ESP: cf94ff14
[   13.283342]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   13.283342] CR0: 8005003b CR2: 0812c1b8 CR3: 0f963000 CR4: 00000690
[   13.283342] Stack:
[   13.283342]  00000030 c37360c0 cf843394 00000000 c2fcf640 c2fd0078 cf94ff54 c10d6866
[   13.283342]  c2fd0078 c2fcfe78 00000100 cf94ff54 00000002 00000001 cf94e000 c2fcd7c4
[   13.283342]  cf94ff94 c10cee7f 00000046 00000046 cf94ff80 c110c453 178cfab3 00000003
[   13.283342] Call Trace:
[   13.283342]  [<c10d6866>] run_timer_softirq+0x236/0x2f0
[   13.283342]  [<c10cee7f>] __do_softirq+0x11f/0x2b0
[   13.283342]  [<c110c453>] ? sched_clock_cpu+0x123/0x200
[   13.283342]  [<c10cf303>] irq_exit+0xe3/0x100
[   13.283342]  [<c10a04a9>] smp_apic_timer_interrupt+0x69/0x80
[   13.283342]  [<c245f122>] apic_timer_interrupt+0x32/0x38
[   13.283342] Code: 83 05 50 0a fd c2 01 83 15 54 0a fd c2 00 39 f7 75 b9 83 05 60 0a fd c2 01 8b 45 e8 83 15 64 0a fd c2 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 48 0a fd c2 01 83 15 4c 0a fd c2 00 55 89 e5 56 89
[   13.283342] EIP: [<c10d6410>] cascade+0xb0/0xc0 SS:ESP 0068:cf94ff14
[   13.283342] ---[ end trace 6fec5d2df3afce31 ]---
/kernel/i386-randconfig-c4-0912/40031da445fb4d269af9c7c445b2adf674f171e7/dmesg-yocto-ant-7:20130916175011:3.11.0-02455-g40031da:401
/kernel/i386-randconfig-c4-0912/40031da445fb4d269af9c7c445b2adf674f171e7/dmesg-quantal-nhm4-7:20130916095505:3.10.0:144

Bisecting: 1507 revisions left to test after this (roughly 10 steps)
[91121c103ae93ef117e58712786864270d7f488e] staging: dwc2: make dwc2_core_params documentation more complete
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:91121c103ae93ef117e58712786864270d7f488e:bisect-usb

2013-09-16-17:50:41 91121c103ae93ef117e58712786864270d7f488e compiling
1445 real  2038 user  176 sys  153.21% cpu 	i386-randconfig-c4-0912

2013-09-16-18:19:33 detecting boot state 3.11.0-rc5-00947-g91121c1...	1	3	6	10	13.	15	25	28	29	37	39.	43.	44........	46 SUCCESS

Bisecting: 725 revisions left to test after this (roughly 10 steps)
[1d1fdd95df681f0c065d90ffaafa215a0e8825e2] Merge tag 'char-misc-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:1d1fdd95df681f0c065d90ffaafa215a0e8825e2:bisect-usb

2013-09-16-18:33:40 1d1fdd95df681f0c065d90ffaafa215a0e8825e2 compiling
484 real  2132 user  169 sys  475.32% cpu 	i386-randconfig-c4-0912

2013-09-16-18:43:14 detecting boot state 3.11.0-00782-g1d1fdd9......	4	5	10.	12	14..	18	19	21	23	25.	27..	28	30.	31.	32	33.	36..	37	38........	40..	41	42	43...	44........	45.	46 SUCCESS

Bisecting: 373 revisions left to test after this (roughly 9 steps)
[d472d9d98b463dd7a04f2bcdeafe4261686ce6ab] lockref: Relax in cmpxchg loop
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:d472d9d98b463dd7a04f2bcdeafe4261686ce6ab:bisect-usb

2013-09-16-19:15:49 d472d9d98b463dd7a04f2bcdeafe4261686ce6ab compiling
314 real  2109 user  165 sys  722.73% cpu 	i386-randconfig-c4-0912

2013-09-16-19:21:16 detecting boot state 3.11.0-02081-gd472d9d....	1. TEST FAILURE
[   12.605413]   #2: Internal PC-Speaker at port 0x61
[   12.606771] ------------[ cut here ]------------
[   12.607394] WARNING: CPU: 0 PID: 13 at /c/wfg/usb/lib/list_debug.c:33 __list_add+0x130/0x150()
[   12.608521] list_add corruption. prev->next should be next (c2fd00b8), but was   (null). (prev=cf843394).
[   12.609824] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 3.11.0-02081-gd472d9d #404
/kernel/i386-randconfig-c4-0912/d472d9d98b463dd7a04f2bcdeafe4261686ce6ab/dmesg-quantal-waimea-3:20130916192355:3.11.0-02081-gd472d9d:404

Bisecting: 175 revisions left to test after this (roughly 8 steps)
[e438ac9ade074932383bb00d51b8ded8a0ee164b] OMAP: serial: Remove incorrect disabling of IER interrupt
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:e438ac9ade074932383bb00d51b8ded8a0ee164b:bisect-usb

2013-09-16-19:24:20 e438ac9ade074932383bb00d51b8ded8a0ee164b compiling
328 real  2103 user  170 sys  691.23% cpu 	i386-randconfig-c4-0912

2013-09-16-19:30:00 detecting boot state 3.11.0-rc4-00176-ge438ac9....	1..	2...	3	6	7..	8	10.	11	13	14..	15.	16	17...	18	20.	22..	23	26.	27	30	33	34	36.	37.	39	40.	42.	44.	45........	46 SUCCESS

Bisecting: 87 revisions left to test after this (roughly 7 steps)
[36c27a655a531f16b5567066600f0ea7fcb973b4] w1: add attribute groups to struct w1_family_ops
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:36c27a655a531f16b5567066600f0ea7fcb973b4:bisect-usb

2013-09-16-20:02:32 36c27a655a531f16b5567066600f0ea7fcb973b4 compiling
330 real  2111 user  167 sys  689.53% cpu 	i386-randconfig-c4-0912

2013-09-16-20:08:13 detecting boot state 3.11.0-rc3-00088-g36c27a6.......	2 TEST FAILURE
[   15.843348] CPU: 0 PID: 175 Comm: MAKEDEV Not tainted 3.11.0-rc3-00088-g36c27a6 #406
[   15.843348] task: cf92cec0 ti: cf93a000 task.ti: cf93a000
[   15.843348] EIP: 0060:[<c10dbc00>] EFLAGS: 00010082 CPU: 0
[   15.843348] EIP is at cascade+0xb0/0xc0
[   15.843348] EAX: 00000000 EBX: c2fcdf40 ECX: c2fce1f8 EDX: cf93bf18
[   15.843348] ESI: cf93bf18 EDI: cf83f394 EBP: cf93bf2c ESP: cf93bf14
[   15.843348]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   15.843348] CR0: 80050033 CR2: b770420c CR3: 0f947000 CR4: 00000690
[   15.843348] Stack:
[   15.843348]  00000033 c6a15c50 cf83f394 00000000 c2fcdf40 c2fce978 cf93bf54 c10dc056
[   15.843348]  c2fce978 c2fce778 00000100 cf93bf54 00000002 00000001 cf93a000 c2fcc0e4
[   15.843348]  cf93bf94 c10d465f 00000046 00000046 cf93bf80 c1111bd3 b0239efd 00000003
[   15.843348] Call Trace:
[   15.843348]  [<c10dc056>] run_timer_softirq+0x236/0x2f0
[   15.843348]  [<c10d465f>] __do_softirq+0x11f/0x2b0
[   15.843348]  [<c1111bd3>] ? sched_clock_cpu+0x123/0x200
[   15.843348]  [<c10d4ae3>] irq_exit+0xe3/0x100
[   15.843348]  [<c10a0499>] smp_apic_timer_interrupt+0x69/0x80
[   15.843348]  [<c24457f2>] apic_timer_interrupt+0x32/0x38
[   15.843348] Code: 83 05 50 f3 fc c2 01 83 15 54 f3 fc c2 00 39 f7 75 b9 83 05 60 f3 fc c2 01 8b 45 e8 83 15 64 f3 fc c2 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 48 f3 fc c2 01 83 15 4c f3 fc c2 00 55 89 e5 56 89
[   15.843348] EIP: [<c10dbc00>] cascade+0xb0/0xc0 SS:ESP 0068:cf93bf14
[   15.843348] ---[ end trace 024ae65a9277071c ]---
/kernel/i386-randconfig-c4-0912/36c27a655a531f16b5567066600f0ea7fcb973b4/dmesg-yocto-waimea-8:20130916201155:3.11.0-rc3-00088-g36c27a6:406
/kernel/i386-randconfig-c4-0912/36c27a655a531f16b5567066600f0ea7fcb973b4/dmesg-yocto-xps-7:20130916201152:3.11.0-rc3-00088-g36c27a6:406

Bisecting: 43 revisions left to test after this (roughly 6 steps)
[13e2237f36874a7abef44b98969f399127b1917d] v4l2: convert class code to use dev_groups
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:13e2237f36874a7abef44b98969f399127b1917d:bisect-usb

2013-09-16-20:12:16 13e2237f36874a7abef44b98969f399127b1917d compiling
316 real  2091 user  166 sys  714.30% cpu 	i386-randconfig-c4-0912

2013-09-16-20:17:43 detecting boot state 3.11.0-rc3-00044-g13e2237.....	1	2 TEST FAILURE
[   14.136409] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.11.0-rc3-00044-g13e2237 #407
[   14.136683] task: c0039a40 ti: c0042000 task.ti: c0042000
[   14.136683] EIP: 0060:[<c10dbc00>] EFLAGS: 00010082 CPU: 0
[   14.136683] EIP is at cascade+0xb0/0xc0
[   14.136683] EAX: 00000000 EBX: c2fcdf40 ECX: c2fce480 EDX: c0043e84
[   14.136683] ESI: c0043e84 EDI: cf81f394 EBP: c0043e98 ESP: c0043e80
[   14.136683]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   14.136683] CR0: 8005003b CR2: b76dcc50 CR3: 0f8f6000 CR4: 00000690
[   14.136683] Stack:
[   14.136683]  00000031 c39153c0 cf81f394 00000000 c2fcdf40 c2fce978 c0043ec0 c10dc056
[   14.136683]  c2fce978 c2fce778 00000100 c0043ec0 00000202 00000101 c0042000 c2fcc0e4
[   14.136683]  c0043f00 c10d465f c0043ed0 c0039a40 c10d489b c2acc3a0 c0043ef8 00000246
[   14.136683] Call Trace:
[   14.136683]  [<c10dc056>] run_timer_softirq+0x236/0x2f0
[   14.136683]  [<c10d465f>] __do_softirq+0x11f/0x2b0
[   14.136683]  [<c10d489b>] ? run_ksoftirqd+0xab/0x110
[   14.136683]  [<c10d4873>] run_ksoftirqd+0x83/0x110
[   14.136683]  [<c110a094>] smpboot_thread_fn+0x224/0x3c0
[   14.136683]  [<c1109e70>] ? lg_global_unlock+0x90/0x90
[   14.136683]  [<c10fc090>] kthread+0xf0/0x100
[   14.136683]  [<c2441c9d>] ? wait_for_common+0x18d/0x250
[   14.136683]  [<c2445e37>] ret_from_kernel_thread+0x1b/0x28
[   14.136683]  [<c10fbfa0>] ? __kthread_unpark+0x80/0x80
[   14.136683] Code: 83 05 50 f3 fc c2 01 83 15 54 f3 fc c2 00 39 f7 75 b9 83 05 60 f3 fc c2 01 8b 45 e8 83 15 64 f3 fc c2 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 48 f3 fc c2 01 83 15 4c f3 fc c2 00 55 89 e5 56 89
[   14.136683] EIP: [<c10dbc00>] cascade+0xb0/0xc0 SS:ESP 0068:c0043e80
[   14.136683] ---[ end trace 831e40c79790e94c ]---
/kernel/i386-randconfig-c4-0912/13e2237f36874a7abef44b98969f399127b1917d/dmesg-quantal-lkp-st01-6:20130916202102:3.11.0-10218-gf76d099:162

Bisecting: 21 revisions left to test after this (roughly 5 steps)
[3499116b915e260b275c167a471e0e05bbe3f1d6] PTP: convert class code to use dev_groups
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:3499116b915e260b275c167a471e0e05bbe3f1d6:bisect-usb

2013-09-16-20:21:15 3499116b915e260b275c167a471e0e05bbe3f1d6 compiling
308 real  2117 user  165 sys  739.66% cpu 	i386-randconfig-c4-0912

2013-09-16-20:26:33 detecting boot state 3.11.0-rc2-00022-g3499116.......	1.	2 TEST FAILURE
[   14.317794] Freeing unused kernel memory: 736K (c2e9c000 - c2f54000)
[   14.428606] ------------[ cut here ]------------
[   14.429449] WARNING: CPU: 0 PID: 101 at /c/wfg/usb/lib/list_debug.c:33 __list_add+0x130/0x150()
[   14.430889] list_add corruption. prev->next should be next (c2fce908), but was   (null). (prev=cf81f394).
[   14.431901] CPU: 0 PID: 101 Comm: hwclock Not tainted 3.11.0-rc2-00022-g3499116 #408
/kernel/i386-randconfig-c4-0912/3499116b915e260b275c167a471e0e05bbe3f1d6/dmesg-quantal-lkp-st01-1:20130916203100:3.11.0-rc2-00022-g3499116:408

Bisecting: 10 revisions left to test after this (roughly 4 steps)
[58b267d3e3f3ce87c3e559e4c330c8c03e905f5e] dma: convert dma_devclass to use dev_groups
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:58b267d3e3f3ce87c3e559e4c330c8c03e905f5e:bisect-usb

2013-09-16-20:31:36 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e compiling
55 real  81 user  15 sys  173.09% cpu 	i386-randconfig-c4-0912

2013-09-16-20:32:40 detecting boot state 3.11.0-rc2-00011-g58b267d........ TEST FAILURE
mountall: Event failed
[   13.123366] ------------[ cut here ]------------
[   13.124259] WARNING: CPU: 0 PID: 350 at /c/wfg/usb/lib/list_debug.c:33 __list_add+0x130/0x150()
[   13.125851] list_add corruption. prev->next should be next (c2fce8f8), but was   (null). (prev=cf842394).
[   13.126682] CPU: 0 PID: 350 Comm: MAKEDEV Not tainted 3.11.0-rc2-00011-g58b267d #409
/kernel/i386-randconfig-c4-0912/58b267d3e3f3ce87c3e559e4c330c8c03e905f5e/dmesg-quantal-waimea-6:20130916203618:3.11.0-rc2-00011-g58b267d:409

Bisecting: 5 revisions left to test after this (roughly 3 steps)
[899826f16a034f1ab6d23cd5b60cd113eaefad19] enclosure: convert class code to use dev_groups
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:899826f16a034f1ab6d23cd5b60cd113eaefad19:bisect-usb

2013-09-16-20:36:44 899826f16a034f1ab6d23cd5b60cd113eaefad19 compiling
311 real  2088 user  164 sys  723.50% cpu 	i386-randconfig-c4-0912

2013-09-16-20:42:02 detecting boot state 3.11.0-rc2-00005-g899826f...	1....	2......	3	4........	5	6...	7	8.	10..	11..	13......	15	16.....	17	18.	19.....	21..	23	24...	26	27..	28..	29	30.	31.	33	34.	35...	37..	38.	39	40.	41.	42.	43..	45...	46 SUCCESS

Bisecting: 2 revisions left to test after this (roughly 2 steps)
[ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b] c2port: convert class code to use bin_attrs in groups
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b:bisect-usb

2013-09-16-21:36:34 ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b compiling
49 real  75 user  15 sys  184.17% cpu 	i386-randconfig-c4-0912

2013-09-16-21:37:32 detecting boot state 3.11.0-rc2-00008-gac3785d....	1	2.....	3...	4.....	6	8.	9	11	14	16	17	20	21....	24..	28	29	30.	32	33	34	36	38	41	42	44..........	45...................	46 SUCCESS

Bisecting: 0 revisions left to test after this (roughly 1 step)
[c817a67ecba7c3c2aaa104796d78f160af60920d] kobject: delayed kobject release: help find buggy drivers
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:c817a67ecba7c3c2aaa104796d78f160af60920d:bisect-usb

2013-09-16-22:18:06 c817a67ecba7c3c2aaa104796d78f160af60920d compiling
544 real  2122 user  185 sys  424.29% cpu 	i386-randconfig-c4-0912

2013-09-16-22:27:20 detecting boot state 3.11.0-rc2-00010-gc817a67.	1........	2. TEST FAILURE
mountall: Event failed
[   13.623384] ------------[ cut here ]------------
[   13.624381] WARNING: CPU: 0 PID: 159 at /c/wfg/usb/lib/list_debug.c:33 __list_add+0x130/0x150()
[   13.626131] list_add corruption. prev->next should be next (c2fce900), but was   (null). (prev=cf81f394).
[   13.626683] CPU: 0 PID: 159 Comm: sed Not tainted 3.11.0-rc2-00010-gc817a67 #412
/kernel/i386-randconfig-c4-0912/c817a67ecba7c3c2aaa104796d78f160af60920d/dmesg-quantal-bens-4:20130916223245:3.11.0-rc2-00010-gc817a67:412

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[7c42721fe0c58a848849b43ff558cf2fb86aa35a] char: tile-srom: fix build error
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:7c42721fe0c58a848849b43ff558cf2fb86aa35a:bisect-usb

2013-09-16-22:33:22 7c42721fe0c58a848849b43ff558cf2fb86aa35a compiling
314 real  2118 user  182 sys  731.40% cpu 	i386-randconfig-c4-0912

2013-09-16-22:38:46 detecting boot state 3.11.0-rc2-00009-g7c42721...	1	2.	4	6.	8..	9	10.	11.......	13......	14..	17.	18.	19......	21...	22.	23.........	24..................	25...........	26.....	27.	28.	30.	31............	32.	33	34.	35.	36..	37	39..	41...	42	44	45	46 SUCCESS

c817a67ecba7c3c2aaa104796d78f160af60920d is the first bad commit
commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    
    Implement debugging for kobject release functions.  kobjects are
    reference counted, so the drop of the last reference to them is not
    predictable. However, the common case is for the last reference to be
    the kobject's removal from a subsystem, which results in the release
    function being immediately called.
    
    This can hide subtle bugs, which can occur when another thread holds a
    reference to the kobject at the same time that a kobject is removed.
    This results in the release method being delayed.
    
    In order to make these kinds of problems more visible, the following
    patch implements a delayed release; this has the effect that the
    release function will be out of order with respect to the removal of
    the kobject in the same manner that it would be if a reference was
    being held.
    
    This provides us with an easy way to allow driver writers to debug
    their drivers and fix otherwise hidden problems.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 f6c23efa102fc2c2ead5c86bdb65aa70719b1ab9 049859fa7a3a953892127467babbf02f66a69b76 M	include
:040000 040000 a41d20669f0f624d2ce9ca7e6a5f96e4f91432e0 bf2168194f82911cf2e1892d82f0c13d00c772ae M	lib
bisect run success
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:7c42721fe0c58a848849b43ff558cf2fb86aa35a:bisect-usb

2013-09-16-23:47:49 7c42721fe0c58a848849b43ff558cf2fb86aa35a reuse /kernel/i386-randconfig-c4-0912/7c42721fe0c58a848849b43ff558cf2fb86aa35a/vmlinuz-3.11.0-rc2-00009-g7c42721

2013-09-16-23:47:49 detecting boot state ...	49.	55.	57	59	61	65	66	72	74.	75.	78	79	80.	82	84	85...........	92	93...	94	95....	97	98.	99	102	107	113	117	120	123	124	125.	126	128	130	131	134	135.	137...	138 SUCCESS

ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:5a7d8a28080caed7fd4cb1b81d092adac4445e8e:bisect-usb
 TEST FAILURE
[   85.364667] libceph: loaded (mon/osd proto 15/24)
[   85.381535] ------------[ cut here ]------------
[   85.383996] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x130/0x150()
[   85.383996] list_add corruption. prev->next should be next (c304ac60), but was   (null). (prev=cf835894).
[   85.383996] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-09992-g5a7d8a2 #8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-ant-8:20130914124036:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-bens-1:20130913200943:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-st01-2:20130916165004:3.11.0-next-20130916-11225-gade7b66:1
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-st01-3:20130916165513:3.11.0-next-20130916-11295-g6746f77:105
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-st01-4:20130916165510:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-11:20130916070858:3.11.0-10144-g9e31373:109
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-14:20130916071403:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-15:20130916070911:3.11.0-10144-g852dab8:102
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-3:20130916071407:3.11.0-next-20130916-11287-gbef3c26:111
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-4:20130916070904:3.11.0-next-20130916-11287-gd123688:152
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-4:20130916071404:3.11.0-next-20130916-11287-gd123688:152
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-7:20130916070853:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-lkp-tt02-7:20130916070939:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-nhm4-1:20130916085536:3.11.0-next-20130916-11285-g79b8c9a:72
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-nhm4-2:20130916085502:3.11.0-next-20130916-11287-gd123688:152
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-11:20130916165511:3.11.0-00022-g4b2c8c4:98
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-13:20130916165036:3.11.0-10137-gc897570:113
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-16:20130916165513:3.11.0-10155-g3fd27a2:68
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-23:20130916165021:3.11.0-00022-g4b2c8c4:66
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-24:20130916165515:3.11.0-10151-gfd07251:151
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-26:20130916165039:3.11.0-next-20130916-11308-g6b0e9dc:57
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-30:20130916165507:3.11.0-02599-g4d9a87c:122
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-3:20130916165549:3.11.0-10137-gc897570:112
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-4:20130916165005:3.11.0-10155-g3fd27a2:68
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-7:20130916165036:3.11.0-02592-g8877e4d:107
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-roam-8:20130916165504:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-waimea-10:20130916165023:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-waimea-10:20130916165514:3.11.0-rc5:141
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-waimea-6:20130916165510:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-waimea-9:20130916165512:3.11.0-next-20130916-11287-gbef3c26:99
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-quantal-xps-8:20130916165013:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-bay-1:20130916165049:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-lkp-st01-1:20130916165516:3.11.0-next-20130916-11287-gbef3c26:113
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-lkp-tt02-14:20130916070910:3.11.0-next-20130916-11287-gd123688:152
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-lkp-tt02-4:20130916070928:3.11.0-next-20130916-11287-gbef3c26:99
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-lkp-tt02-7:20130916070910:3.11.0-10222-g8b8f72b:110
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-nhm4-1:20130916085456:3.11.0-09992-g5a7d8a2:8
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-12:20130916165023:3.11.0-00022-g4b2c8c4:109
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-23:20130916165038:3.11.0-next-20130916-11225-gade7b66:1
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-27:20130916165020:3.11.0-10138-g013a325:112
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-28:20130916165039:3.11.0-00022-g4b2c8c4:98
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-30:20130916165019:3.11.0-next-20130916-11295-g6746f77:112
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-roam-4:20130916165022:3.11.0-10155-g3fd27a2:68
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-waimea-7:20130916165046:3.11.0-next-20130916-11287-gbef3c26:113
/kernel/i386-randconfig-c4-0912/5a7d8a28080caed7fd4cb1b81d092adac4445e8e/dmesg-yocto-xps-3:20130916165526:3.11.0-next-20130916-11287-gd123688:152

[detached HEAD 249c01e] Revert "kobject: delayed kobject release: help find buggy drivers"
 3 files changed, 3 insertions(+), 42 deletions(-)
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:249c01e3c56c17b2905f0a33429d9466c4d4eb59:bisect-usb

2013-09-17-00:23:30 249c01e3c56c17b2905f0a33429d9466c4d4eb59 compiling

2013-09-17-00:29:13 detecting boot state 3.11.0-09993-g249c01e....	1	2	3	4..	7.	8	9..	11	14.	16.	17	19..	20.	22..	26	27..	28	30.	32	37.	38.	39	40.	47	49.	50	53	54	55	59	62	65	68.	70	71	74	79	82	83	91	94	96	98	99.	102.	103	104	107	111	112	116	117..	120	123.	128	131	134.	136.	137	138 SUCCESS


========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:d8efd82eece89f8a5790b0febf17522affe9e1f1:bisect-usb

2013-09-17-01:14:45 d8efd82eece89f8a5790b0febf17522affe9e1f1 compiling

2013-09-17-01:21:38 detecting boot state 3.11.0-10130-gd8efd82...	2.....	3 TEST FAILURE
[   14.136686] CPU: 0 PID: 101 Comm: plymouthd Not tainted 3.11.0-10130-gd8efd82 #415
[   14.136686] task: cf8141f0 ti: cf8f6000 task.ti: cf8f6000
[   14.136686] EIP: 0060:[<c10d9d90>] EFLAGS: 00010086 CPU: 0
[   14.136686] EIP is at cascade+0xb0/0xc0
[   14.136686] EAX: 00000000 EBX: c302e1c0 ECX: c302e838 EDX: cf8f7e2c
[   14.136686] ESI: cf8f7e2c EDI: cf847394 EBP: cf8f7e40 ESP: cf8f7e28
[   14.136686]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   14.136686] CR0: 8005003b CR2: b75f5560 CR3: 0f8f0000 CR4: 00000690
[   14.136686] Stack:
[   14.136686]  00000031 c3797b00 cf847394 00000000 c302e1c0 c302ebf8 cf8f7e68 c10da1e6
[   14.136686]  c302ebf8 c302e9f8 00000100 cf8f7e68 00000002 00000001 cf8f6000 c302c364
[   14.136686]  cf8f7ea8 c10d281f 00000046 00000046 cf8f7e94 c110ff03 4a6a08d6 00000003
[   14.136686] Call Trace:
[   14.136686]  [<c10da1e6>] run_timer_softirq+0x236/0x2f0
[   14.136686]  [<c10d281f>] __do_softirq+0x11f/0x2b0
[   14.136686]  [<c110ff03>] ? sched_clock_cpu+0x123/0x200
[   14.136686]  [<c10d2ca3>] irq_exit+0xe3/0x100
[   14.136686]  [<c10a3fd9>] smp_apic_timer_interrupt+0x69/0x80
[   14.136686]  [<c24a29f2>] apic_timer_interrupt+0x32/0x38
[   14.136686]  [<c11499f0>] ? lock_acquire+0xd0/0xf0
[   14.136686]  [<c1225ada>] ? __alloc_fd+0x2a/0x200
[   14.136686]  [<c24a05dc>] _raw_spin_lock+0x6c/0x110
[   14.136686]  [<c1225ada>] ? __alloc_fd+0x2a/0x200
[   14.136686]  [<c1225ada>] __alloc_fd+0x2a/0x200
[   14.136686]  [<c13c8c68>] ? __raw_spin_lock_init+0x48/0x80
[   14.136686]  [<c1225ce9>] get_unused_fd_flags+0x39/0x50
[   14.136686]  [<c124bbcc>] SyS_epoll_create1+0x17c/0x280
[   14.136686]  [<c124bd0a>] SyS_epoll_create+0x3a/0x60
[   14.136686]  [<c24a2e46>] sysenter_do_call+0x12/0x38
[   14.136686] Code: 83 05 d0 f5 02 c3 01 83 15 d4 f5 02 c3 00 39 f7 75 b9 83 05 e0 f5 02 c3 01 8b 45 e8 83 15 e4 f5 02 c3 00 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 83 05 c8 f5 02 c3 01 83 15 cc f5 02 c3 00 55 89 e5 56 89
[   14.136686] EIP: [<c10d9d90>] cascade+0xb0/0xc0 SS:ESP 0068:cf8f7e28
[   14.136686] ---[ end trace a628659eb544f08d ]---
/kernel/i386-randconfig-c4-0912/d8efd82eece89f8a5790b0febf17522affe9e1f1/dmesg-quantal-roam-18:20130917012610:3.11.0-rc7-00734-g1041a02:207


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-c4-0912/linus:master:ade7b661ae9a2efac4cd2ed36d8053bfcb13bc31:bisect-usb

2013-09-17-01:26:53 ade7b661ae9a2efac4cd2ed36d8053bfcb13bc31 compiling
2013-09-17-01:32:07 ade7b661ae9a2efac4cd2ed36d8053bfcb13bc31 SKIP BROKEN BUILD
Check erros in /cc/wfg/usb-bisect and /tmp/kernel/i386-randconfig-c4-0912/ade7b661ae9a2efac4cd2ed36d8053bfcb13bc31

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-09992-g5a7d8a2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0 Kernel Configuration
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
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
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
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
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
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
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_INTEL_USERCOPY=y
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
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

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
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
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
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_I82365=y
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_HYBLA=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="hybla"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
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
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
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
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

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
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
# CONFIG_MAC80211_MHWMP_DEBUG is not set
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_SIM=y
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
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
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
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
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SMSC75XX=y
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_N2=y
CONFIG_C101=y
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_VMXNET3=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
# CONFIG_MISDN_HFCUSB is not set
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
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
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
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
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
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
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
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
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

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
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS6586X=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
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
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
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
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
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
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
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
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
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
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
# CONFIG_SND_ISA is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
CONFIG_SND_USB_6FIRE=y
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=y
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_SOUND_KAHLUA is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
CONFIG_USB_MOUSE=y

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
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
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
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_TPS80031 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
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
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_ECHO is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_TRANZPORT=y
CONFIG_LINE6_USB=y
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
CONFIG_DX_SEP=y

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
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7854=y
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_ZSMALLOC=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_CXT1E1=y
# CONFIG_SBE_PMCC4_NCOMM is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_SBE_2T3E3=y
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_USB_DWC2 is not set
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
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
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

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
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
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
CONFIG_BMA180=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
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
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

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
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
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
CONFIG_DEBUG_KOBJECT_RELEASE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
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
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
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
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
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
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
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
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_LGUEST is not set
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
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--qDbXVdCdHGoSgWSk--
