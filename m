Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3HYAEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 20:04:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:57837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab3HYAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 20:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,949,1367996400"; 
   d="log'?scan'208";a="386019611"
Date: Sun, 25 Aug 2013 08:04:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ben Dooks <ben@simtec.co.uk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [tps_init] BUG: unable to handle kernel paging request at 484970c9
Message-ID: <20130825000421.GC26317@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

It seems the below patch discloses a bug in tps_init().

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


Parent commit not clean. Look out for wrong bisect!

BUG: kernel boot crashed

/kernel/i386-randconfig-j1-08220808/7c42721fe0c58a848849b43ff558cf2fb86aa35a/dmesg-kvm-nhm4-6710-20130824125721-3.11.0-rc2-00007-ge56341a-282

[    0.304827] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:530 sysfs_add_one+0x89/0x9b()
[    0.306316] sysfs: cannot create duplicate filename '/bus/i2c/drivers/tps65010'
[    0.307436] Modules linked in:
[    0.307941] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc6-next-20130821-06842-g2d55880 #1
[    0.308005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.308887]  cc459da0 cc459da0 cc459d60 c12ae633 cc459d90 c102a725 c141580a cc459dbc
[    0.310261]  00000001 c14157a1 00000212 c110e2cc c110e2cc cc41a000 cc657630 cc459ddc
[    0.312898]  cc459da8 c102a76f 00000009 cc459da0 c141580a cc459dbc cc459dd0 c110e2cc
[    0.314269] Call Trace:
[    0.314680]  [<c12ae633>] dump_stack+0x16/0x18
[    0.315386]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.316007]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.316760]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.317513]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.318290]  [<c110e2cc>] sysfs_add_one+0x89/0x9b
[    0.319010]  [<c110e3e3>] create_dir+0x57/0x8d
[    0.319698]  [<c110e769>] sysfs_create_dir+0xe9/0x102
[    0.320008]  [<c113da3b>] kobject_add_internal+0x113/0x220
[    0.320856]  [<c10da635>] ? kfree+0xa9/0x21a
[    0.321521]  [<c1147d30>] ? kvasprintf+0x3e/0x47
[    0.322235]  [<c113dd5c>] kobject_init_and_add+0x43/0x48
[    0.323061]  [<c11ec11f>] bus_add_driver+0xcd/0x26b
[    0.324007]  [<c11ed623>] driver_register+0x96/0xca
[    0.324774]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.325604]  [<c1658167>] tps_init+0xab/0xbf
[    0.326271]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.327143]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.328016]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.328745]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.329553]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.330296]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.331134]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.332006]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.332704]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.333542]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.334317] ---[ end trace c6073849988f8b3e ]---

git bisect start dcb396261fba04df952bfef5d6fc0d5d12438e3a v3.10 --
git bisect good 938d0a840d0f97b627111fd038a735f3924fd987  # 18:41    160+  watchdog: Add Broadcom BCM2835 watchdog timer driver
git bisect good 945a8ce78f4d18e61b1a70c228b51f26c9ca3df2  # 22:27    160+  Merge remote-tracking branch 'wireless-next/master'
git bisect  bad 701f688ca117e94ee9c35bdbf065c2966ee1df91  # 22:27      0-  Merge remote-tracking branch 'driver-core/driver-core-next'
git bisect good 956c3bfbbedd7d549b342d320db0eb9bc702428f  # 05:55    160+  Merge remote-tracking branch 'modules/modules-next'
git bisect good d76759ab20e40abafbfab722feeb21851635a4b5  # 06:12    160+  Merge remote-tracking branch 'spi/for-next'
git bisect good cb1d0c0432c07090815ae9ee5d050d8290018377  # 09:34    160+  Merge branch 'x86/asm'
git bisect good 08fea51b96c8d0c9db06f98a5953d21db9950419  # 09:50    160+  Merge remote-tracking branch 'rcu/rcu/next'
git bisect good ede0e16dd25b2274270e3cfa30d9c9a88dbac0e8  # 13:13    160+  Merge remote-tracking branch 'regmap/for-next'
git bisect  bad a93d6b0a879718a1a08553935744b0d5c58354c0  # 13:29      0-  devfreq: convert devfreq_class to use dev_groups
git bisect  bad 5baa7503a7a0b8d65308ff3b2ab887bf343c65d3  # 13:38      0-  leds: convert class code to use dev_groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 13:50      0-  kobject: delayed kobject release: help find buggy drivers
git bisect good 899826f16a034f1ab6d23cd5b60cd113eaefad19  # 16:44    160+  enclosure: convert class code to use dev_groups
git bisect good e56341ad380114454119ac043e6d710ddbbb7710  # 20:12    160+  staging: comedi: convert class code to use dev_groups
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 20:55    160+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 23:43    480+  char: tile-srom: fix build error
git bisect  bad 2d55880c40a3ac145ed9175d3bbdf11b80eaf861  # 23:44      0-  Add linux-next specific files for 20130821
git bisect good 8daa20e710a4e9e3c893a043f0d455f8ef882859  # 00:56    480+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect good 89b53e50bd2b75c22944d594ada36beee1b23e0f  # 02:35    480+  Merge branch 'for-3.11-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 02:41      0-  Add linux-next specific files for 20130822

Thanks,
Fengguang

--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3971-20130822120507-3.11.0-rc6-next-20130821-06842-g2d55880-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc6-next-20130821-06842-g2d55880 (kbuil=
d@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 Thu Aug 22 09:14:11 CS=
T 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01cdb000, 0x01cdbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01cdc000, 0x01cdcfff] PGTABLE
[    0.000000] BRK [0x01cdd000, 0x01cddfff] PGTABLE
[    0.000000] BRK [0x01cde000, 0x01cdefff] PGTABLE
[    0.000000] BRK [0x01cdf000, 0x01cdffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, lim=
it 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127832(97%)
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c160adc0, node_mem_map ce=
4bf028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1481680
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j1-08220808/next:master:2d55=
880c40a3ac145ed9175d3bbdf11b80eaf861:bisect-usb/.vmlinuz-2d55880c40a3ac145e=
d9175d3bbdf11b80eaf861-20130822120718-17-bens branch=3Dnext/master  BOOT_IM=
AGE=3D/kernel/i386-randconfig-j1-08220808/2d55880c40a3ac145ed9175d3bbdf11b8=
0eaf861/vmlinuz-3.11.0-rc6-next-20130821-06842-g2d55880
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 195604K/261744K available (2774K kernel code, 1814K =
rwdata, 1760K rodata, 428K init, 6344K bss, 66140K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1635000 - 0xc16a0000   ( 428 kB)
[    0.000000]       .data : 0xc12b5f06 - 0xc1634b40   (3579 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12b5f06   (2775 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcc408000 soft=3Dcc40a000
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
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.420 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5332.84 Bogo=
MIPS (lpj=3D10665680)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Mount-cache hash table entries: 512
[    0.008870] Initializing cgroup subsys debug
[    0.009556] Initializing cgroup subsys devices
[    0.010284] Initializing cgroup subsys perf_event
[    0.011130] mce: CPU supports 10 MCE banks
[    0.012009] mce: unknown CPU type - not enabling MCE support
[    0.012925] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012925] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012925] tlb_flushall_shift: -1
[    0.015063] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.022010] ACPI: Core revision 20130725
[    0.025353] ACPI: All ACPI Tables successfully acquired
[    0.026236] ACPI: setting ELCR to 0200 (from 0c00)
[    0.027028] ftrace: allocating 13683 entries in 27 pages
[    0.032420] Performance Events:=20
[    0.033640] ftrace: Allocated trace_printk buffers
[    0.055130] Getting VERSION: 50014
[    0.055692] Getting VERSION: 50014
[    0.056018] Getting ID: 0
[    0.056458] Getting ID: f000000
[    0.056964] Getting LVT0: 8700
[    0.057460] Getting LVT1: 8400
[    0.058178] enabled ExtINT on CPU#0
[    0.058768] Using local APIC timer interrupts.
[    0.058768] calibrating APIC timer ...
[    0.064000] ... lapic delta =3D 6249914
[    0.064000] ... PM-Timer delta =3D 357949
[    0.064000] ... PM-Timer result ok
[    0.064000] ..... delta 6249914
[    0.064000] ..... mult: 268431762
[    0.064000] ..... calibration result: 3999944
[    0.064000] ..... CPU clock speed is 2666.2515 MHz.
[    0.064000] ..... host bus clock speed is 999.3944 MHz.
[    0.064115] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.070188] regulator-dummy: no parameters
[    0.070954] cma: cma_init_reserved_areas()
[    0.071596] cma: cma_create_area(base 0000d000, count 1000)
[    0.075017] cma: cma_create_area: returned cc402a10
[    0.076111] RTC time:  4:04:49, date: 08/22/13
[    0.077042] NET: Registered protocol family 16
[    0.078472] cpuidle: using governor ladder
[    0.079121] cpuidle: using governor menu
[    0.080358] ACPI: bus type PCI registered
[    0.081321] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.082290] PCI: Using configuration type 1 for base access
[    0.086637] ACPI: Added _OSI(Module Device)
[    0.087346] ACPI: Added _OSI(Processor Device)
[    0.088005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.088736] ACPI: Added _OSI(Processor Aggregator Device)
[    0.093324] ACPI: EC: Look up EC in DSDT
[    0.102331] ACPI: Interpreter enabled
[    0.102917] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.104359] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.105842] ACPI: (supports S0 S3 S5)
[    0.106419] ACPI: Using PIC for interrupt routing
[    0.107171] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.123534] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.124423] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.126466] PCI host bridge to bus 0000:00
[    0.127111] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.128006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.128953] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.129900] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.131041] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.132105] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.134117] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.136434] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.140655] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.143419] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.144578] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.145675] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.147417] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.151020] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.153765] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.164088] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.165719] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.168005] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.170050] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.176615] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.178456] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.180626] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.182783] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.189827] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.191434] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.193287] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.196005] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.203697] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.205705] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.208626] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.216888] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.219100] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.220624] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.228825] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.231061] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.233212] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.241284] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.243495] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.245218] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.252746] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.254942] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.257213] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.264699] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.266287] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.272383] pci_bus 0000:00: on NUMA node 0
[    0.273033] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.275931] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.276515] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.277723] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.278921] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.280413] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.282352] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.283149] ACPI: \_SB_.PCI0: notify handler is installed
[    0.284190] Found 1 acpi root devices
[    0.285529] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.286762] vgaarb: loaded
[    0.287188] vgaarb: bridge control possible 0000:00:02.0
[    0.288116] tps65010: version 2 May 2005
[    0.304066] ------------[ cut here ]------------
[    0.304827] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:530 sysfs_add_one+0=
x89/0x9b()
[    0.306316] sysfs: cannot create duplicate filename '/bus/i2c/drivers/tp=
s65010'
[    0.307436] Modules linked in:
[    0.307941] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc6-next-2013=
0821-06842-g2d55880 #1
[    0.308005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.308887]  cc459da0 cc459da0 cc459d60 c12ae633 cc459d90 c102a725 c1415=
80a cc459dbc
[    0.310261]  00000001 c14157a1 00000212 c110e2cc c110e2cc cc41a000 cc657=
630 cc459ddc
[    0.312898]  cc459da8 c102a76f 00000009 cc459da0 c141580a cc459dbc cc459=
dd0 c110e2cc
[    0.314269] Call Trace:
[    0.314680]  [<c12ae633>] dump_stack+0x16/0x18
[    0.315386]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.316007]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.316760]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.317513]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.318290]  [<c110e2cc>] sysfs_add_one+0x89/0x9b
[    0.319010]  [<c110e3e3>] create_dir+0x57/0x8d
[    0.319698]  [<c110e769>] sysfs_create_dir+0xe9/0x102
[    0.320008]  [<c113da3b>] kobject_add_internal+0x113/0x220
[    0.320856]  [<c10da635>] ? kfree+0xa9/0x21a
[    0.321521]  [<c1147d30>] ? kvasprintf+0x3e/0x47
[    0.322235]  [<c113dd5c>] kobject_init_and_add+0x43/0x48
[    0.323061]  [<c11ec11f>] bus_add_driver+0xcd/0x26b
[    0.324007]  [<c11ed623>] driver_register+0x96/0xca
[    0.324774]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.325604]  [<c1658167>] tps_init+0xab/0xbf
[    0.326271]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.327143]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.328016]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.328745]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.329553]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.330296]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.331134]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.332006]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.332704]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.333542]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.334317] ---[ end trace c6073849988f8b3e ]---
[    0.335038] ------------[ cut here ]------------
[    0.336007] WARNING: CPU: 0 PID: 1 at lib/kobject.c:196 kobject_add_inte=
rnal+0x19d/0x220()
[    0.337591] kobject_add_internal failed for tps65010 with -EEXIST, don't=
 try to register things with the same name in the same directory.
[    0.339606] Modules linked in:
[    0.340080] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.341530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.342410]  cc459e14 cc459e14 cc459dd4 c12ae633 cc459e04 c102a725 c1417=
61d cc459e30
[    0.344004]  00000001 c141745b 000000c4 c113dac5 c113dac5 ffffffef cc60b=
900 cc5f09f0
[    0.345372]  cc459e1c c102a76f 00000009 cc459e14 c141761d cc459e30 cc459=
e54 c113dac5
[    0.346734] Call Trace:
[    0.347127]  [<c12ae633>] dump_stack+0x16/0x18
[    0.347817]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.348008]  [<c113dac5>] ? kobject_add_internal+0x19d/0x220
[    0.348878]  [<c113dac5>] ? kobject_add_internal+0x19d/0x220
[    0.349743]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.350513]  [<c113dac5>] kobject_add_internal+0x19d/0x220
[    0.352006]  [<c113dd5c>] kobject_init_and_add+0x43/0x48
[    0.352821]  [<c11ec11f>] bus_add_driver+0xcd/0x26b
[    0.353573]  [<c11ed623>] driver_register+0x96/0xca
[    0.354326]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.355138]  [<c1658167>] tps_init+0xab/0xbf
[    0.355801]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.356006]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.356772]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.357494]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.358300]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.359040]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.360006]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.360770]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.361461]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.362300]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.363023] ---[ end trace c6073849988f8b3f ]---
[    0.364026] ------------[ cut here ]------------
[    0.364737] WARNING: CPU: 0 PID: 1 at drivers/base/driver.c:207 driver_u=
nregister+0x34/0x4b()
[    0.366346] Unexpected driver unregister!
[    0.366967] Modules linked in:
[    0.367468] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.368003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.368877]  cc459e94 cc459e94 cc459e54 c12ae633 cc459e84 c102a725 c142f=
959 cc459eb0
[    0.370255]  00000001 c142f8b5 000000cf c11ed6b5 c11ed6b5 c15f1df0 c15f1=
dcc 00000000
[    0.372889]  cc459e9c c102a76f 00000009 cc459e94 c142f959 cc459eb0 cc459=
eb4 c11ed6b5
[    0.374243] Call Trace:
[    0.374638]  [<c12ae633>] dump_stack+0x16/0x18
[    0.375325]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.376006]  [<c11ed6b5>] ? driver_unregister+0x34/0x4b
[    0.376812]  [<c11ed6b5>] ? driver_unregister+0x34/0x4b
[    0.377618]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.378397]  [<c11ed6b5>] driver_unregister+0x34/0x4b
[    0.379179]  [<c122e48b>] i2c_del_driver+0x24/0x66
[    0.380006]  [<c16580f5>] tps_init+0x39/0xbf
[    0.380666]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.381530]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.382349]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.383172]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.384016]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.384768]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.385612]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.386382]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.387077]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.388007]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.388735] ---[ end trace c6073849988f8b40 ]---
[    0.404048] ------------[ cut here ]------------
[    0.404795] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:530 sysfs_add_one+0=
x89/0x9b()
[    0.406268] sysfs: cannot create duplicate filename '/bus/i2c/drivers/tp=
s65010'
[    0.407386] Modules linked in:
[    0.407889] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.408004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.408881]  cc459da0 cc459da0 cc459d60 c12ae633 cc459d90 c102a725 c1415=
80a cc459dbc
[    0.410245]  00000001 c14157a1 00000212 c110e2cc c110e2cc cc41a000 cc657=
630 cc459ddc
[    0.412892]  cc459da8 c102a76f 00000009 cc459da0 c141580a cc459dbc cc459=
dd0 c110e2cc
[    0.414256] Call Trace:
[    0.414646]  [<c12ae633>] dump_stack+0x16/0x18
[    0.415340]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.416006]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.416775]  [<c110e2cc>] ? sysfs_add_one+0x89/0x9b
[    0.417526]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.418303]  [<c110e2cc>] sysfs_add_one+0x89/0x9b
[    0.419022]  [<c110e3e3>] create_dir+0x57/0x8d
[    0.419709]  [<c110e769>] sysfs_create_dir+0xe9/0x102
[    0.420008]  [<c113da3b>] kobject_add_internal+0x113/0x220
[    0.420849]  [<c10da635>] ? kfree+0xa9/0x21a
[    0.421505]  [<c1147d30>] ? kvasprintf+0x3e/0x47
[    0.422222]  [<c113dd5c>] kobject_init_and_add+0x43/0x48
[    0.423039]  [<c11ec11f>] bus_add_driver+0xcd/0x26b
[    0.424006]  [<c11ed623>] driver_register+0x96/0xca
[    0.424759]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.425569]  [<c1658167>] tps_init+0xab/0xbf
[    0.426231]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.427099]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.428006]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.428727]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.429531]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.430267]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.431109]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.432006]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.432701]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.433542]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.434267] ---[ end trace c6073849988f8b41 ]---
[    0.434986] ------------[ cut here ]------------
[    0.436006] WARNING: CPU: 0 PID: 1 at lib/kobject.c:196 kobject_add_inte=
rnal+0x19d/0x220()
[    0.437767] kobject_add_internal failed for tps65010 with -EEXIST, don't=
 try to register things with the same name in the same directory.
[    0.439636] Modules linked in:
[    0.440066] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.441516] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.442414]  cc459e14 cc459e14 cc459dd4 c12ae633 cc459e04 c102a725 c1417=
61d cc459e30
[    0.443773]  00000001 c141745b 000000c4 c113dac5 c113dac5 ffffffef cc60b=
900 cc5f09f0
[    0.445031]  cc459e1c c102a76f 00000009 cc459e14 c141761d cc459e30 cc459=
e54 c113dac5
[    0.446394] Call Trace:
[    0.446786]  [<c12ae633>] dump_stack+0x16/0x18
[    0.447475]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.448009]  [<c113dac5>] ? kobject_add_internal+0x19d/0x220
[    0.448876]  [<c113dac5>] ? kobject_add_internal+0x19d/0x220
[    0.449741]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.450513]  [<c113dac5>] kobject_add_internal+0x19d/0x220
[    0.451354]  [<c113dd5c>] kobject_init_and_add+0x43/0x48
[    0.452007]  [<c11ec11f>] bus_add_driver+0xcd/0x26b
[    0.452763]  [<c11ed623>] driver_register+0x96/0xca
[    0.453509]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.454327]  [<c1658167>] tps_init+0xab/0xbf
[    0.454989]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.456006]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.456771]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.457489]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.458293]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.459032]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.460006]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.460766]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.461468]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.462310]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.463036] ---[ end trace c6073849988f8b42 ]---
[    0.464008] ------------[ cut here ]------------
[    0.464725] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[    0.466315] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[    0.467524] Modules linked in:
[    0.468000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.468000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.468000]  cc459d88 cc459d88 cc459d48 c12ae633 cc459d78 c102a725 c1419=
2f2 cc459da4
[    0.468000]  00000001 c141932f 00000104 c115b07a c115b07a cc40d510 c1484=
970 c140837b
[    0.468000]  cc459d90 c102a76f 00000009 cc459d88 c14192f2 cc459da4 cc459=
dc4 c115b07a
[    0.468000] Call Trace:
[    0.468000]  [<c12ae633>] dump_stack+0x16/0x18
[    0.468000]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.468000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.468000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.468000]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.468000]  [<c115b07a>] debug_print_object+0x76/0x84
[    0.468000]  [<c115b330>] __debug_object_init+0x2a8/0x2e6
[    0.468000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.468000]  [<c1033374>] init_timer_key+0x1f/0x10b
[    0.468000]  [<c113d607>] kobject_release+0xa7/0xd2
[    0.468000]  [<c113d6a0>] kobject_put+0x6e/0x75
[    0.468000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.468000]  [<c11ec265>] bus_add_driver+0x213/0x26b
[    0.468000]  [<c11ed623>] driver_register+0x96/0xca
[    0.468000]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.468000]  [<c1658167>] tps_init+0xab/0xbf
[    0.468000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.468000]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.468000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.468000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.468000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.468000]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.468000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.468000]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.468000]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.468000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.468000] ---[ end trace c6073849988f8b43 ]---
[    0.468014] ------------[ cut here ]------------
[    0.468731] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[    0.470329] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[    0.471555] Modules linked in:
[    0.472000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.472000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.472000]  cc459d38 cc459d38 cc459cf8 c12ae633 cc459d28 c102a725 c1419=
2f2 cc459d54
[    0.472000]  00000001 c141932f 00000104 c115b07a c115b07a cc40d510 c1484=
970 c140837b
[    0.472000]  cc459d40 c102a76f 00000009 cc459d38 c14192f2 cc459d54 cc459=
d74 c115b07a
[    0.472000] Call Trace:
[    0.472000]  [<c12ae633>] dump_stack+0x16/0x18
[    0.472000]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.472000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.472000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.472000]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.472000]  [<c115b07a>] debug_print_object+0x76/0x84
[    0.472000]  [<c115b330>] __debug_object_init+0x2a8/0x2e6
[    0.472000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.472000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.472000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.472000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.472000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.472000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.472000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.472000]  [<c1033374>] init_timer_key+0x1f/0x10b
[    0.472000]  [<c113d607>] kobject_release+0xa7/0xd2
[    0.472000]  [<c113d6a0>] kobject_put+0x6e/0x75
[    0.472000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.472000]  [<c11ec265>] bus_add_driver+0x213/0x26b
[    0.472000]  [<c11ed623>] driver_register+0x96/0xca
[    0.472000]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.472000]  [<c1658167>] tps_init+0xab/0xbf
[    0.472000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.472000]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.472000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.472000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.472000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.472000]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.472000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.472000]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.472000]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.472000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.472000] ---[ end trace c6073849988f8b44 ]---
[    0.472013] ------------[ cut here ]------------
[    0.472735] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[    0.474322] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[    0.475533] Modules linked in:
[    0.476000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.476000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.476000]  cc459ce8 cc459ce8 cc459ca8 c12ae633 cc459cd8 c102a725 c1419=
2f2 cc459d04
[    0.476000]  00000001 c141932f 00000104 c115b07a c115b07a cc40d510 c1484=
970 c140837b
[    0.476000]  cc459cf0 c102a76f 00000009 cc459ce8 c14192f2 cc459d04 cc459=
d24 c115b07a
[    0.476000] Call Trace:
[    0.476000]  [<c12ae633>] dump_stack+0x16/0x18
[    0.476000]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.476000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.476000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.476000]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.476000]  [<c115b07a>] debug_print_object+0x76/0x84
[    0.476000]  [<c115b330>] __debug_object_init+0x2a8/0x2e6
[    0.476000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.476000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.476000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.476000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.476000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.476000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.476000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.476000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.476000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.476000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.476000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.476000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.476000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.476000]  [<c1033374>] init_timer_key+0x1f/0x10b
[    0.476000]  [<c113d607>] kobject_release+0xa7/0xd2
[    0.476000]  [<c113d6a0>] kobject_put+0x6e/0x75
[    0.476000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.476000]  [<c11ec265>] bus_add_driver+0x213/0x26b
[    0.476000]  [<c11ed623>] driver_register+0x96/0xca
[    0.476000]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.476000]  [<c1658167>] tps_init+0xab/0xbf
[    0.476000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.476000]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.476000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.476000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.476000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.476000]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.476000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.476000]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.476000]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.476000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.476000] ---[ end trace c6073849988f8b45 ]---
[    0.476014] ------------[ cut here ]------------
[    0.476734] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[    0.478329] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[    0.479541] Modules linked in:
[    0.480000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.480000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.480000]  cc459c98 cc459c98 cc459c58 c12ae633 cc459c88 c102a725 c1419=
2f2 cc459cb4
[    0.480000]  00000001 c141932f 00000104 c115b07a c115b07a cc40d510 c1484=
970 c140837b
[    0.480000]  cc459ca0 c102a76f 00000009 cc459c98 c14192f2 cc459cb4 cc459=
cd4 c115b07a
[    0.480000] Call Trace:
[    0.480000]  [<c12ae633>] dump_stack+0x16/0x18
[    0.480000]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.480000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.480000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.480000]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.480000]  [<c115b07a>] debug_print_object+0x76/0x84
[    0.480000]  [<c115b330>] __debug_object_init+0x2a8/0x2e6
[    0.480000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.480000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.480000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.480000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.480000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.480000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.480000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.480000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.480000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.480000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.480000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.480000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.480000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.480000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.480000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.480000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.480000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.480000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.480000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.480000]  [<c1033374>] init_timer_key+0x1f/0x10b
[    0.480000]  [<c113d607>] kobject_release+0xa7/0xd2
[    0.480000]  [<c113d6a0>] kobject_put+0x6e/0x75
[    0.480000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.480000]  [<c11ec265>] bus_add_driver+0x213/0x26b
[    0.480000]  [<c11ed623>] driver_register+0x96/0xca
[    0.480000]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.480000]  [<c1658167>] tps_init+0xab/0xbf
[    0.480000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.480000]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.480000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.480000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.480000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.480000]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.480000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.480000]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.480000]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.480000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.480000] ---[ end trace c6073849988f8b46 ]---
[    0.480013] ------------[ cut here ]------------
[    0.480733] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[    0.482323] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[    0.483545] Modules linked in:
[    0.484000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.484000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.484000]  cc459c48 cc459c48 cc459c08 c12ae633 cc459c38 c102a725 c1419=
2f2 cc459c64
[    0.484000]  00000001 c141932f 00000104 c115b07a c115b07a cc40d510 c1484=
970 c140837b
[    0.484000]  cc459c50 c102a76f 00000009 cc459c48 c14192f2 cc459c64 cc459=
c84 c115b07a
[    0.484000] Call Trace:
[    0.484000]  [<c12ae633>] dump_stack+0x16/0x18
[    0.484000]  [<c102a725>] warn_slowpath_common+0x7a/0x91
[    0.484000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.484000]  [<c115b07a>] ? debug_print_object+0x76/0x84
[    0.484000]  [<c102a76f>] warn_slowpath_fmt+0x33/0x35
[    0.484000]  [<c115b07a>] debug_print_object+0x76/0x84
[    0.484000]  [<c115b330>] __debug_object_init+0x2a8/0x2e6
[    0.484000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.484000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.484000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.484000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.484000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.484000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.484000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.484000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.484000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.484000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.484000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.484000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.484000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.484000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.484000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.484000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.484000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.484000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.484000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.484000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.484000]  [<c1034576>] timer_fixup_init+0x25/0x2f
[    0.484000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.484000]  [<c115aef5>] debug_object_fixup+0x10/0x1d
[    0.484000]  [<c115b34d>] __debug_object_init+0x2c5/0x2e6
[    0.484000]  [<c115b454>] debug_object_init+0x13/0x15
[    0.484000]  [<c1033374>] init_timer_key+0x1f/0x10b
[    0.484000]  [<c113d607>] kobject_release+0xa7/0xd2
[    0.484000]  [<c113d6a0>] kobject_put+0x6e/0x75
[    0.484000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.484000]  [<c11ec265>] bus_add_driver+0x213/0x26b
[    0.484000]  [<c11ed623>] driver_register+0x96/0xca
[    0.484000]  [<c122e3a8>] i2c_register_driver+0x64/0x123
[    0.484000]  [<c1658167>] tps_init+0xab/0xbf
[    0.484000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.484000]  [<c1000452>] do_one_initcall+0xf4/0x1af
[    0.484000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.484000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.484000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.484000]  [<c1635b03>] kernel_init_freeable+0x116/0x1b0
[    0.484000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.484000]  [<c12a8940>] kernel_init+0x10/0xc8
[    0.484000]  [<c12b50d7>] ret_from_kernel_thread+0x1b/0x28
[    0.484000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.484000] ---[ end trace c6073849988f8b47 ]---
[    0.488009] BUG: unable to handle kernel paging request at 484970c9
[    0.489009] IP: [<c115b345>] __debug_object_init+0x2bd/0x2e6
[    0.489913] *pde =3D 00000000=20
[    0.490392] Thread overran stack, or stack corrupted
[    0.491184] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.491889] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c115b345>] EFLAGS: 00010282 CPU: 0
[    0.492000] EIP is at __debug_object_init+0x2bd/0x2e6
[    0.492000] EAX: 484970c1 EBX: 00000003 ECX: 00000003 EDX: cc60b948
[    0.492000] ESI: cc60b948 EDI: 0003b678 EBP: cc458043 ESP: 63616265
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 484970c9 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  c106a45f 00000000 c1c4a9cc c1484970 00000282 c1c4a9d0 0003b=
678 cc60b948
[    0.492000]  cc60b948 0003b678 cc45804c c115b454 cc458058 c1034576 c1034=
551 cc458064
[    0.492000]  c115aef5 00000003 cc458094 c115b34d c106a45f 00000000 c1c4a=
9cc c1484970
[    0.492000] Call Trace:
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c106a45f>] ? trace_hardirqs_on+0xb/0xd
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1034576>] ? timer_fixup_init+0x25/0x2f
[    0.492000]  [<c1034551>] ? timer_fixup_free+0x2f/0x2f
[    0.492000]  [<c115aef5>] ? debug_object_fixup+0x10/0x1d
[    0.492000]  [<c115b34d>] ? __debug_object_init+0x2c5/0x2e6
[    0.492000]  [<c115b454>] ? debug_object_init+0x13/0x15
[    0.492000]  [<c1033374>] ? init_timer_key+0x1f/0x10b
[    0.492000]  [<c113d607>] ? kobject_release+0xa7/0xd2
[    0.492000]  [<c113d6a0>] ? kobject_put+0x6e/0x75
[    0.492000]  [<c113dd5c>] ? kobject_init_and_add+0x43/0x48
[    0.492000]  [<c11ec265>] ? bus_add_driver+0x213/0x26b
[    0.492000]  [<c11ed623>] ? driver_register+0x96/0xca
[    0.492000]  [<c122e3a8>] ? i2c_register_driver+0x64/0x123
[    0.492000]  [<c1658167>] ? tps_init+0xab/0xbf
[    0.492000]  [<c16580bc>] ? wm8994_i2c_driver_init+0x11/0x11
[    0.492000]  [<c1000452>] ? do_one_initcall+0xf4/0x1af
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c163542a>] ? repair_env_string+0x12/0x51
[    0.492000]  [<c104690e>] ? parse_args+0x284/0x38f
[    0.492000]  [<c1635b03>] ? kernel_init_freeable+0x116/0x1b0
[    0.492000]  [<c1635418>] ? do_early_param+0x7a/0x7a
[    0.492000]  [<c12a8940>] ? kernel_init+0x10/0xc8
[    0.492000]  [<c12b50d7>] ? ret_from_kernel_thread+0x1b/0x28
[    0.492000]  [<c12a8930>] ? rest_init+0x131/0x131
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 0003b678
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#2] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010093 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 0003b678 ECX: cc458043 EDX: 0003b678
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc457e08 ESP: cc457de8
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 0003b678 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 0003bffc 0003a000 cc458043 0003b678 0003a=
000 c12b7304
[    0.492000]  cc457e30 c100385b c12b7304 c13f84cf 00000000 cc457e20 00000=
000 c13f84cf
[    0.492000]  00000000 cc45807f cc457e54 c10043ee 00000000 c12b7304 c13f8=
4cf cc457fe0
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#3] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc457bd4 ESP: cc457bb4
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc457bfc c100385b c12b7304 c13f84cf 00000000 cc457bec 00000=
000 c13f84cf
[    0.492000]  00000000 cc457e4b cc457c20 c10043ee 00000000 c12b7304 c13f8=
4cf cc457dac
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#4] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc4579a0 ESP: cc457980
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc4579c8 c100385b c12b7304 c13f84cf 00000000 cc4579b8 00000=
000 c13f84cf
[    0.492000]  00000000 cc457c17 cc4579ec c10043ee 00000000 c12b7304 c13f8=
4cf cc457b78
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#5] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc45776c ESP: cc45774c
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc457794 c100385b c12b7304 c13f84cf 00000000 cc457784 00000=
000 c13f84cf
[    0.492000]  00000000 cc4579e3 cc4577b8 c10043ee 00000000 c12b7304 c13f8=
4cf cc457944
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#6] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc457538 ESP: cc457518
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc457560 c100385b c12b7304 c13f84cf 00000000 cc457550 00000=
000 c13f84cf
[    0.492000]  00000000 cc4577af cc457584 c10043ee 00000000 c12b7304 c13f8=
4cf cc457710
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#7] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc457304 ESP: cc4572e4
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc45732c c100385b c12b7304 c13f84cf 00000000 cc45731c 00000=
000 c13f84cf
[    0.492000]  00000000 cc45757b cc457350 c10043ee 00000000 c12b7304 c13f8=
4cf cc4574dc
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#8] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc4570d0 ESP: cc4570b0
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc4570f8 c100385b c12b7304 c13f84cf 00000000 cc4570e8 00000=
000 c13f84cf
[    0.492000]  00000000 cc457347 cc45711c c10043ee 00000000 c12b7304 c13f8=
4cf cc4572a8
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#9] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc456e9c ESP: cc456e7c
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc456ec4 c100385b c12b7304 c13f84cf 00000000 cc456eb4 00000=
000 c13f84cf
[    0.492000]  00000000 cc457113 cc456ee8 c10043ee 00000000 c12b7304 c13f8=
4cf cc457074
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#10] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc456c68 ESP: cc456c48
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc456c90 c100385b c12b7304 c13f84cf 00000000 cc456c80 00000=
000 c13f84cf
[    0.492000]  00000000 cc456edf cc456cb4 c10043ee 00000000 c12b7304 c13f8=
4cf cc456e40
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#11] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc456a34 ESP: cc456a14
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc456a5c c100385b c12b7304 c13f84cf 00000000 cc456a4c 00000=
000 c13f84cf
[    0.492000]  00000000 cc456cab cc456a80 c10043ee 00000000 c12b7304 c13f8=
4cf cc456c0c
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#12] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc456800 ESP: cc4567e0
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc456828 c100385b c12b7304 c13f84cf 00000000 cc456818 00000=
000 c13f84cf
[    0.492000]  00000000 cc456a77 cc45684c c10043ee 00000000 c12b7304 c13f8=
4cf cc4569d8
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#13] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.492000] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.492000] ESI: cc458043 EDI: c12b7304 EBP: cc4565cc ESP: cc4565ac
[    0.492000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.492000] Stack:
[    0.492000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.492000]  cc4565f4 c100385b c12b7304 c13f84cf 00000000 cc4565e4 00000=
000 c13f84cf
[    0.492000]  00000000 cc456843 cc456618 c10043ee 00000000 c12b7304 c13f8=
4cf cc4567a4
[    0.492000] Call Trace:
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.492000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.492000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.492000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.492000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.492000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.492000]  [<c1004574>] __die+0x8d/0xf5
[    0.492000]  [<c101c240>] no_context+0x14b/0x177
[    0.492000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.492000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.492000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.492000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.492000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.492000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.492000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.492000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.492000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.492000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.492000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.492000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.492000]  <IRQ>=20
[    0.492000] BUG: unable to handle kernel paging request at 63616265
[    0.492000] IP: [<c100423c>] print_context_stack+0x77/0x96
[    0.492000] *pde =3D 00000000=20
[    0.492000] Thread overran stack, or stack corrupted
[    0.492000] Oops: 0000 [#14] DEBUG_PAGEALLOC
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130821-06842-g2d55880 #1
[    0.492000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.492000] task: cc450000 ti: cc456000 task.ti: cc458000
[    0.492000] EIP: 0060:[<c100423c>] EFLAGS: 00010097 CPU: 0
[    0.492000] EIP is at print_context_stack+0x77/0x96
[    0.496021] EAX: ffffe000 EBX: 63616265 ECX: cc458043 EDX: 63616265
[    0.496978] ESI: cc458043 EDI: c12b7304 EBP: cc456398 ESP: cc456378
[    0.497936]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.498765] CR0: 8005003b CR2: 63616265 CR3: 016a3000 CR4: 00000690
[    0.499745] Stack:
[    0.500000]  00000000 ffffe000 63617ffc 63616000 cc458043 63616265 63616=
000 c12b7304
[    0.500000]  cc4563c0 c100385b c12b7304 c13f84cf 00000000 cc4563b0 00000=
000 c13f84cf
[    0.500000]  00000000 cc45660f cc4563e4 c10043ee 00000000 c12b7304 c13f8=
4cf cc456570
[    0.500000] Call Trace:
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1143038>] ? format_decode+0x16c/0x2bb
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c12b3fa0>] ? _raw_spin_unlock_irqrestore+0x37/0x54
[    0.500000]  [<c1066e29>] ? trace_hardirqs_off+0xb/0xd
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c100423c>] ? print_context_stack+0x77/0x96
[    0.500000]  [<c100385b>] dump_trace+0x96/0xc9
[    0.500000]  [<c10043ee>] show_trace_log_lvl+0x47/0x4e
[    0.500000]  [<c100392b>] show_stack_log_lvl+0x9d/0xa5
[    0.500000]  [<c10039a8>] show_regs+0x75/0x14e
[    0.500000]  [<c1004574>] __die+0x8d/0xf5
[    0.500000]  [<c101c240>] no_context+0x14b/0x177
[    0.500000]  [<c101c3bd>] __bad_area_nosemaphore+0x151/0x159
[    0.500000]  [<c12b4a4e>] ? restore_all+0xf/0xf
[    0.500000]  [<c101c3dc>] bad_area_nosemaphore+0x17/0x19
[    0.500000]  [<c101c61c>] __do_page_fault+0x23e/0x585
[    0.500000]  [<c105515b>] ? local_clock+0x36/0x4e
[    0.500000]  [<c1066d87>] ? trace_hardirqs_off_caller+0x1a/0xb1
[    0.500000]  [<c1055083>] ? sched_clock_cpu+0x120/0x166
[    0.500000]  [<c1146550>] ? trace_hardirqs_off_thunk+0xc/0x10
[    0.500000]  [<c12b4ed1>] ? error_code+0x59/0x64
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c1019fa3>] ? kvm_async_pf_task_wake+0xe7/0xe7
[    0.500000]  [<c101ca83>] do_page_fault+0xd/0xf
[    0.500000]  [<c1019fcb>] do_async_page_fault+0x28/0x50
[    0.500000]  [<c12b4ed5>] error_code+0x5d/0x64
[    0.500000] Code: f0 89 c6 eb 07 31 c9 8b 45 0c ff d7 83 c3 04 83 7d 10 =
00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d ec 76 1a 3b 5d e8 73 15 =
<8b> 13 89 d0 89 55 e0 e8 31 1a 04 00 8b 55 e0 85 c0 75 a3 eb cc
[    0.500000] EIP: [<c100423c>] print_context_stack+0x77/0x96 SS:ESP 0068:=
cc456378
[    0.500000] CR2: 0000000063616265
[    0.500000] ---[ end trace c6073849988f8b48 ]---
[    0.500000] Kernel panic - not syncing: Fatal exception in interrupt
[    0.500000] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/i386-randcon=
fig-j1-08220808/2d55880c40a3ac145ed9175d3bbdf11b80eaf861/vmlinuz-3.11.0-rc6=
-next-20130821-06842-g2d55880-3971 -append 'hung_task_panic=3D1 rcutree.rcu=
_cpu_stall_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug=
 apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdis=
k=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 =
rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-j1-08220808/next:mast=
er:2d55880c40a3ac145ed9175d3bbdf11b80eaf861:bisect-usb/.vmlinuz-2d55880c40a=
3ac145ed9175d3bbdf11b80eaf861-20130822120718-17-bens branch=3Dnext/master  =
BOOT_IMAGE=3D/kernel/i386-randconfig-j1-08220808/2d55880c40a3ac145ed9175d3b=
bdf11b80eaf861/vmlinuz-3.11.0-rc6-next-20130821-06842-g2d55880'  -initrd /k=
ernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,m=
acaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp:=
:8067-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3D=
nc -no-reboot -watchdog i6300esb -drive file=3D/fs/sda7/disk0-bens-3971,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk1-bens-3971,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/sda7/disk2-bens-3971,media=3Ddisk,if=3Dvirtio =
-drive file=3D/fs/sda7/disk3-bens-3971,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/sda7/disk4-bens-3971,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7=
/disk5-bens-3971,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-bens-=
lkp-3971 -serial file:/dev/shm/kboot/serial-bens-lkp-3971 -daemonize -displ=
ay none -monitor null=20

--aM3YZ0Iwxop3KEKx
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-2d55880c40a3ac145ed9175d3bbdf11b80eaf861-i386-randconfig-j1-08220808-BUG:-unable-to-handle-kernel-paging-request-at-118691.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMmQ1NTg4MC4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA4MjEKSEVBRCBpcyBub3cgYXQgZGNiMzk2Mi4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6
bWFzdGVyOmRjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2E6YmlzZWN0
LXVzYgogVEVTVCBGQUlMVVJFClsgICAgNC4zOTQ4MzRdIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDEgYXQgL2Mvd2ZnL3VzYi9mcy9zeXNmcy9kaXIuYzo1MzAgc3lzZnNfYWRkX29uZSsweDg5
LzB4OWIoKQpbICAgIDQuMzk2MzM1XSBzeXNmczogY2Fubm90IGNyZWF0ZSBkdXBsaWNhdGUg
ZmlsZW5hbWUgJy9idXMvaTJjL2RyaXZlcnMvdHBzNjUwMTAnClsgICAgNC4zOTcyNzZdIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDQuMzk4NjQ4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xMS4wLXJjNi0wNzIzNi1nZGNiMzk2MiAjMzM5ClsgICAg
NC40MDAyOTNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICA0LjQwMTQ5NV0gIGNjNDU5ZDkwIGNjNDU5ZDkwIGNjNDU5ZDUwIGMxMmFm
Y2E1IGNjNDU5ZDgwIGMxMDJhODY5IGMxNDE1NmVkIGNjNDU5ZGFjClsgICAgNC40MDI5MDZd
ICAwMDAwMDAwMSBjMTQxNTY5MiAwMDAwMDIxMiBjMTEwZmI0MSBjMTEwZmI0MSBjYzQxYTAw
MCBjYzY1NzYzMCBjYzQ1OWRkYwpbICAgIDQuNDA0NzQ4XSAgY2M0NTlkOTggYzEwMmE4YjMg
MDAwMDAwMDkgY2M0NTlkOTAgYzE0MTU2ZWQgY2M0NTlkYWMgY2M0NTlkYzAgYzExMGZiNDEK
WyAgICA0LjQwNjE3Ml0gQ2FsbCBUcmFjZToKWyAgICA0LjQwNjk0OV0gIFs8YzEyYWZjYTU+
XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDQuNDA4MzkxXSAgWzxjMTAyYTg2OT5dIHdh
cm5fc2xvd3BhdGhfY29tbW9uKzB4N2EvMHg5MQpbICAgIDQuNDA5MTE3XSAgWzxjMTEwZmI0
MT5dID8gc3lzZnNfYWRkX29uZSsweDg5LzB4OWIKWyAgICA0LjQwOTc5MF0gIFs8YzExMGZi
NDE+XSA/IHN5c2ZzX2FkZF9vbmUrMHg4OS8weDliClsgICAgNC40MTA0MzNdICBbPGMxMDJh
OGIzPl0gd2Fybl9zbG93cGF0aF9mbXQrMHgzMy8weDM1ClsgICAgNC40MTExMTNdICBbPGMx
MTBmYjQxPl0gc3lzZnNfYWRkX29uZSsweDg5LzB4OWIKWyAgICA0LjQxMjMzOV0gIFs8YzEx
MGZjNmE+XSBjcmVhdGVfZGlyKzB4NWMvMHg5MgpbICAgIDQuNDEyOTkxXSAgWzxjMTExMDAw
OD5dIHN5c2ZzX2NyZWF0ZV9kaXIrMHhmMS8weDEwYQpbICAgIDQuNDEzNjc2XSAgWzxjMTEz
ZjQyZT5dIGtvYmplY3RfYWRkX2ludGVybmFsKzB4MTEzLzB4MjIwClsgICAgNC40MTQzNzdd
ICBbPGMxMGRiOWVkPl0gPyBrZnJlZSsweGE5LzB4MjFhClsgICAgNC40MTUwNDFdICBbPGMx
MTQ5NjQyPl0gPyBrdmFzcHJpbnRmKzB4M2UvMHg0NwpbICAgIDQuNDE2MzUwXSAgWzxjMTEz
Zjc0Zj5dIGtvYmplY3RfaW5pdF9hbmRfYWRkKzB4NDMvMHg0OApbICAgIDQuNDE3MDgwXSAg
WzxjMTFlZGMzOD5dIGJ1c19hZGRfZHJpdmVyKzB4Y2QvMHgyNmIKWyAgICA0LjQxNzc1NV0g
IFs8YzExZWYxM2M+XSBkcml2ZXJfcmVnaXN0ZXIrMHg5Ni8weGNhClsgICAgNC40MTg0MDNd
ICBbPGMxMjJmZWM0Pl0gaTJjX3JlZ2lzdGVyX2RyaXZlcisweDY0LzB4MTIzClsgICAgNC40
MTkxMzJdICBbPGMxNjU1ZWZkPl0gdHBzX2luaXQrMHhhYi8weGJmClsgICAgNC40MjAzNDZd
ICBbPGMxNjU1ZTUyPl0gPyB3bTg5OTRfaTJjX2RyaXZlcl9pbml0KzB4MTEvMHgxMQpbICAg
IDQuNDIxMDkxXSAgWzxjMTAwMDQ1Mj5dIGRvX29uZV9pbml0Y2FsbCsweGY0LzB4MWFmClsg
ICAgNC40MjE3NjRdICBbPGMxNjMzNDJhPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4
NTEKWyAgICA0LjQyMjQ0Ml0gIFs8YzEwNDZhNTc+XSA/IHBhcnNlX2FyZ3MrMHgyODQvMHgz
OGYKWyAgICA0LjQyMzE0M10gIFs8YzEwNmE2YjY+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4
Yi8weGQKWyAgICA0LjQyNDMzNV0gIFs8YzE2MzNiMDM+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweDExNi8weDFiMApbICAgIDQuNDI1MDczXSAgWzxjMTYzMzQxOD5dID8gZG9fZWFybHlf
cGFyYW0rMHg3YS8weDdhClsgICAgNC40MjU3MzldICBbPGMxMmFhNjgwPl0ga2VybmVsX2lu
aXQrMHgxMC8weGM4ClsgICAgNC40MjYzNzRdICBbPGMxMmI2NzM3Pl0gcmV0X2Zyb21fa2Vy
bmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICA0LjQyNzA5MV0gIFs8YzEyYWE2NzA+XSA/IHJl
c3RfaW5pdCsweDEzMS8weDEzMQpbICAgIDQuNDMwMDIzXSAtLS1bIGVuZCB0cmFjZSBiZDU4
NDk5ODgzZTdmMzgxIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgv
ZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tYW50
LTIyNTQ0LTIwMTMwODIyMTIyMTA3LTMuMTEuMC1yYzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJi
ZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWFudC0yMjU4My0yMDEzMDgyMjEyMTgy
MC0zLjExLjAtcmM2LTA3MjM2LWdkY2IzOTYyLTMzOQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNh
L2RtZXNnLWt2bS1iZW5zLTM2MDctMjAxMzA4MjIxMjI3MzUtMy4xMS4wLXJjNi0wNzIzNi1n
ZGNiMzk2Mi0zMzkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2
MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24t
MTE1MzYtMjAxMzA4MjIxMjIyMTUtMy4xMS4wLXJjNi0wMDA2MS1nZTc1ZGM2Ny0yMTUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJm
ZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tMTE1MzYtMjAxMzA4MjIx
MjIyNTMtMy4xMS4wLXJjNi0wMDA2MS1nZTc1ZGM2Ny0yMTUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQz
OGUzYS9kbWVzZy1rdm0tamFrZXRvd24tMTIxNTAtMjAxMzA4MjIxMjIyMTMtLQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVk
NmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1qYWtldG93bi0xMjE1MC0yMDEzMDgyMjEyMjI1
My0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0
ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0b3duLTEyMjcwLTIw
MTMwODIyMTIyMjE1LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNi
Mzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRv
d24tMTIzOTQtMjAxMzA4MjIxMjIyMjMtMy4xMS4wLXJjMS0wMDA5Mi1nZWQ1NmYzNC0yOTIK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1
MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tMTI1MTYtMjAxMzA4
MjIxMjIxNDgtMy4xMS4wLXJjNi0wNzIzNi1nZGNiMzk2Mi0zMzkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQx
MjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tMTM4ODktMjAxMzA4MjIxMjIyNTItMy4xMS4w
LXJjNi0wMDAwNi1nNjNjMDYwNC0xNTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgy
MjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1r
dm0tamFrZXRvd24tMTY1NDMtMjAxMzA4MjIxMjIyMjgtMy4xMS4wLXJjMi0wMDQyNC1nNGM5
YmQwNC0yODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYx
ZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tMjA4
MzktMjAxMzA4MjIxMjIyMTctMy4xMC4wLTM0MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2Rt
ZXNnLWt2bS1qYWtldG93bi0yMDgzOS0yMDEzMDgyMjEyMjI1Ny0zLjEwLjAtMzQwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVm
NWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0b3duLTIxMTE0LTIwMTMwODIyMTIy
MjEzLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMS0wNjg0Mi1nMmQ1NTg4MC0xCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2
ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0b3duLTIxMjI1LTIwMTMwODIyMTIyMjUz
LTMuMTEuMC1yYzYtMDAwNjEtZ2U3NWRjNjctMzI0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2Ev
ZG1lc2cta3ZtLWpha2V0b3duLTIyMDE4LTIwMTMwODIyMTIxOTU5LTMuMTEuMC1yYzYtMDcy
MzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2Rj
YjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0
b3duLTIyNTA3LTIwMTMwODIyMTIyMjE4LTMuMTEuMC1yYzUtMDA3ODYtZ2Q5NGEwMTQtMzE5
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5
NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0b3duLTIyNTcwLTIwMTMw
ODIyMTIyMjIwLTMuMTEuMC1yYzYtMDAwNjEtZ2U3NWRjNjctMzIxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVk
MTI0MzhlM2EvZG1lc2cta3ZtLWpha2V0b3duLTI1NTQ3LTIwMTMwODIyMTIyMjI4LTMuMTEu
MC1yYzEtMDAwOTItZ2VkNTZmMzQtMTAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4
MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2ct
a3ZtLWpha2V0b3duLTUzOTgtMjAxMzA4MjIxMjIyMjYtMy4xMS4wLXJjMi0wMDI5MC1nZWZl
YTZlOC0zMTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYx
ZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tNTgz
Ny0yMDEzMDgyMjEyMTkwOC0zLjExLjAtcmM2LTA3MjM2LWdkY2IzOTYyLTMzOQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVk
NmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1qYWtldG93bi02ODk5LTIwMTMwODIyMTIxNjMz
LTMuMTEuMC1yYzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2Ev
ZG1lc2cta3ZtLWpha2V0b3duLTc0MzMtMjAxMzA4MjIxMjIyMjMtMy4xMS4wLXJjNi0wMDA2
MS1nZTc1ZGM2Ny0zMzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNi
Mzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRv
d24tNzYwMS0yMDEzMDgyMjEyMjI1MC0zLjExLjAtcmMyLTAwMjg4LWc2OTQzOGU2LTMwOQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUy
YmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1qYWtldG93bi03NzYzLTIwMTMwODIy
MTIyMDQwLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYx
ZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tamFrZXRvd24tODI4
MC0yMDEzMDgyMjEyMTcxMS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4
L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLW5o
bTQtMjA5MjgtMjAxMzA4MjIwNDIyMDktMy4xMS4wLXJjNS0wMDc4Ni1nZDk0YTAxNC0zMjIK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1
MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tbmhtNC00NDg3LTIwMTMwODIyMDQy
MDQ1LTMuMTEuMC1yYzItMDA0NDktZ2ZjMjljMzctMjkzCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0Mzhl
M2EvZG1lc2cta3ZtLW5obTQtNTM1NC0yMDEzMDgyMjA0MjEyOS0zLjExLjAtcmM1LTAwNzg2
LWdkOTRhMDE0LTYzNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2Iz
OTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1uaG00LTY0
MDctMjAxMzA4MjIwNDE4MDAtMy4xMS4wLXJjNi0wNzIzNi1nZGNiMzk2Mi0zMzkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1
ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tbmhtNC02NDA3LTIwMTMwODIyMDQxOTUzLTMu
MTEuMC1yYzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWox
LTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1l
c2cta3ZtLXJvYW0tMTAwMjktMjAxMzA4MjIxMjIyNDUtMy4xMS4wLXJjMS0wMDA2MS1nN2Fh
YjFiMi0yODMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYx
ZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tcm9hbS0xMDc4NS0y
MDEzMDgyMjEyMjIyOS0zLjExLjAtcmMxLTAwMDc5LWdhOTdmNGRmLTI5OQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZj
MGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1yb2FtLTExMDM3LTIwMTMwODIyMTIyMTA1LTMuMTEu
MC1yYzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4
MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2ct
a3ZtLXJvYW0tMTEyMjYtMjAxMzA4MjIxMjIyMTctMy4xMS4wLXJjNi0wMDA2MS1nZTc1ZGM2
Ny0xNTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJh
MDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0tcm9hbS01OTYzLTIwMTMw
ODIyMTIyMjUyLTMuMTEuMC1yYzItMzExCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4
MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2ct
a3ZtLXJvYW0tNzUwNi0yMDEzMDgyMjEyMjEyNS0zLjExLjAtcmMyLTAwMDA1LWc0OWFkOWU4
LTMzMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEw
NGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1yb2FtLTc1MDYtMjAxMzA4
MjIxMjIyNDctMy4xMS4wLXJjMi0wMDAwNS1nNDlhZDllOC0zMzIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQx
MjQzOGUzYS9kbWVzZy1rdm0tcm9hbS04MDc2LTIwMTMwODIyMTIyMjI5LTMuMTEuMC1yYzIt
MDAwMDQtZzMxZTVjNmMtMzIwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4
L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3ZtLXJv
YW0tODMyOC0yMDEzMDgyMjEyMjIzMy0zLjExLjAtcmMyLTAwMDAyLWc0M2E4NDdmLTMyNQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUy
YmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS1yb2FtLTk3NzUtMjAxMzA4MjIxMjIy
MjctLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEw
NGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtMjEyNTMtMjAx
MzA4MjIxMjIyMDMtMy4xMC4wLTM0MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2
bS13YWltZWEtMjEyNTMtMjAxMzA4MjIxMjIyMzYtMy4xMC4wLTM0MAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1
ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtMzY0Ny0yMDEzMDgyMjEyMjA1Ny0zLjExLjAt
cmM2LTA3MjM2LWdkY2IzOTYyLTMzOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2
bS13YWltZWEtODc4OS0yMDEzMDgyMjEyMjE1MS0zLjExLjAtcmM2LTA3MjM2LWdkY2IzOTYy
LTMzOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEw
NGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtODkwMS0yMDEz
MDgyMjEyMTYxOC0zLjExLjAtcmM2LTA3MjM2LWdkY2IzOTYyLTMzOQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1
ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtOTMzMC0yMDEzMDgyMjEyMjIyMS0zLjExLjAt
cmMyLTAwMjg4LWc2OTQzOGU2LTMwNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2
bS13YWltZWEtOTMzMC0yMDEzMDgyMjEyMjI1NC0zLjExLjAtcmMyLTAwMjg4LWc2OTQzOGU2
LTMwNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEw
NGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtOTMzMS0yMDEz
MDgyMjEyMjExNi0zLjExLjAtcmM2LTAwMDY4LWc2YmI1ZTIwLTI5NAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1
ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtOTk2OC0yMDEzMDgyMjEyMjIzOC0zLjExLjAt
cmMyLTAwMzcyLWdhOTc4NmExLTI4MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2
bS13YWltZWEtOTk3My0yMDEzMDgyMjEyMjIyNC0zLjExLjAtcmM2LTAwMDYxLWdlNzVkYzY3
LTMzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEw
NGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS13YWltZWEtOTk3My0yMDEz
MDgyMjEyMjI1OC0zLjExLjAtcmM2LTAwMDYxLWdlNzVkYzY3LTMzMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1
ZDEyNDM4ZTNhL2RtZXNnLWt2bS14Z3dvLTEyMDg0LTIwMTMwODIyMTIxNzUyLTMuMTEuMC1y
YzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIw
ODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EvZG1lc2cta3Zt
LXhnd28tMzI4NC0yMDEzMDgyMjEyMTc1Ni0zLjExLjAtcmM2LTAwMDYxLWdlNzVkYzY3LTE5
Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYyNjFmYmEwNGRm
OTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS14cHMtMTAyMTgtMjAxMzA4MjIx
MjE0MDAtMy4xMS4wLXJjNi0wNzIzNi1nZGNiMzk2Mi0zMzkKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJmZWY1ZDZmYzBkNWQxMjQz
OGUzYS9kbWVzZy1rdm0teHBzLTEwMjE4LTIwMTMwODIyMTIxODM4LTMuMTAuMC0zNDAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvZGNiMzk2MjYxZmJhMDRkZjk1MmJm
ZWY1ZDZmYzBkNWQxMjQzOGUzYS9kbWVzZy1rdm0teHBzLTEwNjM3LTIwMTMwODIyMTIxNzQw
LTMuMTEuMC1yYzYtMDcyMzYtZ2RjYjM5NjItMzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4L2RjYjM5NjI2MWZiYTA0ZGY5NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2Ev
ZG1lc2cta3ZtLXhwcy0xMDYzNy0yMDEzMDgyMjEyMTgzNS0zLjExLjAtcmM2LTA3MjM2LWdk
Y2IzOTYyLTMzOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9kY2IzOTYy
NjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhL2RtZXNnLWt2bS14cHMtMTQyMTYt
MjAxMzA4MjIxMjE4MzktMy4xMS4wLXJjNi0wMDA2MS1nZTc1ZGM2Ny0zMTgKCmJpc2VjdDog
YmFkIGNvbW1pdCBkY2IzOTYyNjFmYmEwNGRmOTUyYmZlZjVkNmZjMGQ1ZDEyNDM4ZTNhCmdp
dCBjaGVja291dCB2My4xMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBkY2IzOTYyLi4u
IE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Fpby9tYXN0ZXInCkhFQUQgaXMgbm93
IGF0IDhiYjQ5NWUuLi4gTGludXggMy4xMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOjhiYjQ5NWUz
ZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LXVzYgoKMjAxMy0wOC0y
My0xNzowNjo0MCA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IHJl
dXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvdm1saW51ei0zLjEwLjAKCjIwMTMtMDgtMjMt
MTc6MDY6NDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uCTYxLi4uCTYzLi4uCTY0
CTY2CTY3Li4JNjgJNzAuLgk3MS4uCTcyLgk3NAk3NQk3Ni4JNzguCTc5CTgwLgk4MQk4Mi4J
ODMJODQJODYJODcJODkJOTEJOTIJOTMuCTk0Li4JOTYJOTguLgk5OQkxMDMuCTEwNAkxMDUJ
MTA5CTExMAkxMTUJMTE4CTEyNQkxMzAJMTQ0CTE0NgkxNDguCTE0OQkxNTAuLgkxNTEuLi4u
Li4uLi4uLi4uCTE1MwkxNTQJMTU1Li4uLgkxNTcJMTU5LgkxNjAgU1VDQ0VTUwoKYmlzZWN0
OiBnb29kIGNvbW1pdCB2My4xMApnaXQgYmlzZWN0IHN0YXJ0IGRjYjM5NjI2MWZiYTA0ZGY5
NTJiZmVmNWQ2ZmMwZDVkMTI0MzhlM2EgdjMuMTAgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgOGJiNDk1ZS4uLiBMaW51eCAzLjEwCkhFQUQgaXMgbm93IGF0IGMxYmU1YTUuLi4g
TGludXggMy45CkJpc2VjdGluZzogOTAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls5MzhkMGE4NDBkMGY5N2I2MjcxMTFmZDAzOGE3
MzVmMzkyNGZkOTg3XSB3YXRjaGRvZzogQWRkIEJyb2FkY29tIEJDTTI4MzUgd2F0Y2hkb2cg
dGltZXIgZHJpdmVyCmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qMS0wODIyMDgwOC9uZXh0Om1hc3Rlcjo5MzhkMGE4NDBkMGY5N2I2MjcxMTFm
ZDAzOGE3MzVmMzkyNGZkOTg3OmJpc2VjdC11c2IKCjIwMTMtMDgtMjMtMTc6NTg6MzggOTM4
ZDBhODQwZDBmOTdiNjI3MTExZmQwMzhhNzM1ZjM5MjRmZDk4NyByZXVzZSAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC85MzhkMGE4NDBkMGY5N2I2MjcxMTFmZDAzOGE3
MzVmMzkyNGZkOTg3L3ZtbGludXotMy4xMC4wLTA5MDE1LWc5MzhkMGE4CgoyMDEzLTA4LTIz
LTE3OjU4OjM4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JNjQJNjcJNzMJNzQJNzUuLgk3
Ngk3Ny4JOTYJMTE0CTEyMgkxNDAJMTQxLi4JMTQyCTE0MwkxNDUJMTQ4Li4uLi4uLi4uCTE0
OS4uCTE1MC4uLi4uLi4JMTUyLi4uLi4uLi4uLgkxNTUuLi4uLi4uLi4JMTU3Li4uLi4uLi4u
Li4uLi4uLi4JMTYwIFNVQ0NFU1MKCkJpc2VjdGluZzogNDQ2NSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls5NDVhOGNlNzhmNGQxOGU2
MWIxYTcwYzIyOGI1MWYyNmM5Y2EzZGYyXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICd3aXJlbGVzcy1uZXh0L21hc3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4
L25leHQ6bWFzdGVyOjk0NWE4Y2U3OGY0ZDE4ZTYxYjFhNzBjMjI4YjUxZjI2YzljYTNkZjI6
YmlzZWN0LXVzYgoKMjAxMy0wOC0yMy0xODo0MToxNiA5NDVhOGNlNzhmNGQxOGU2MWIxYTcw
YzIyOGI1MWYyNmM5Y2EzZGYyIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4
MjIwODA4Lzk0NWE4Y2U3OGY0ZDE4ZTYxYjFhNzBjMjI4YjUxZjI2YzljYTNkZjIvdm1saW51
ei0zLjExLjAtcmM2LTAyNzcwLWc5NDVhOGNlCgoyMDEzLTA4LTIzLTE4OjQxOjE2IGRldGVj
dGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uCTYxLi4uLi4uCTYyLi4uLi4uLi4uLi4JNjMu
Li4uLi4uCTY0Li4uLi4uLi4uLi4uLgk2NQk2Ni4uLi4uLi4uLi4uLi4uCTY3Li4uLi4uLi4u
Lgk2OC4uCTY5Li4uCTcwCTcxLi4uLi4uLi4JNzIuLgk3My4JNzQuLi4JNzUuLi4JNzYuCTc3
Li4uLi4uLi4uCTc4Li4uLi4uLi4uLi4JODAuLgk4MS4uLi4JODIuCTgzCTg0Li4JODUJODcu
Li4JODkJOTAJOTEJOTQuLi4uLi4JOTUJOTYuLi4JOTcuLi4uLi4JOTguCTEwMC4uLi4JMTAx
CTEwMi4uLi4uLi4JMTAzCTEwNC4uLgkxMDUuLi4uLi4JMTA2CTEwNwkxMDguCTEwOS4uLi4J
MTExLi4uLi4uLgkxMTIuLgkxMTMJMTE0CTExNS4uCTExNwkxMTgJMTE5CTEyMAkxMjEuCTEy
MgkxMjMuCTEyNAkxMjYuLi4uLgkxMjcuCTEyOC4JMTMxLgkxMzMJMTU1CTE1NgkxNTcuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNTguLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgkxNTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE2MCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDIyNzMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDExIHN0ZXBzKQpbNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5
MV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZHJpdmVyLWNvcmUvZHJpdmVyLWNv
cmUtbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOjcw
MWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTE6YmlzZWN0LXVzYgogVEVT
VCBGQUlMVVJFClsgICAgNC4xNTg4ODRdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mv
d2ZnL3VzYi9mcy9zeXNmcy9kaXIuYzo1MzAgc3lzZnNfYWRkX29uZSsweDg5LzB4OWIoKQpb
ICAgIDQuMTYwMzQzXSBzeXNmczogY2Fubm90IGNyZWF0ZSBkdXBsaWNhdGUgZmlsZW5hbWUg
Jy9idXMvaTJjL2RyaXZlcnMvdHBzNjUwMTAnClsgICAgNC4xNjEzMzNdIE1vZHVsZXMgbGlu
a2VkIGluOgpbICAgIDQuMTYyNzUxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90
IHRhaW50ZWQgMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OCAjMzQzClsgICAgNC4xNjQyOTNd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
ICA0LjE2NTQ2MV0gIGNjNDU5ZDkwIGNjNDU5ZDkwIGNjNDU5ZDUwIGMxMmFmYmZmIGNjNDU5
ZDgwIGMxMDJhODY5IGMxNDE1MmUyIGNjNDU5ZGFjClsgICAgNC4xNjY5MTJdICAwMDAwMDAw
MSBjMTQxNTI4NyAwMDAwMDIxMiBjMTEwZjk3YyBjMTEwZjk3YyBjYzQxYTAwMCBjYzY1NzYz
MCBjYzQ1OWRkYwpbICAgIDQuMTY5MDE4XSAgY2M0NTlkOTggYzEwMmE4YjMgMDAwMDAwMDkg
Y2M0NTlkOTAgYzE0MTUyZTIgY2M0NTlkYWMgY2M0NTlkYzAgYzExMGY5N2MKWyAgICA0LjE3
MDQyN10gQ2FsbCBUcmFjZToKWyAgICA0LjE3MTE4M10gIFs8YzEyYWZiZmY+XSBkdW1wX3N0
YWNrKzB4MTYvMHgxOApbICAgIDQuMTcyNDAwXSAgWzxjMTAyYTg2OT5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4N2EvMHg5MQpbICAgIDQuMTczMTM0XSAgWzxjMTEwZjk3Yz5dID8gc3lz
ZnNfYWRkX29uZSsweDg5LzB4OWIKWyAgICA0LjE3MzgyOV0gIFs8YzExMGY5N2M+XSA/IHN5
c2ZzX2FkZF9vbmUrMHg4OS8weDliClsgICAgNC4xNzQ0MjddICBbPGMxMDJhOGIzPl0gd2Fy
bl9zbG93cGF0aF9mbXQrMHgzMy8weDM1ClsgICAgNC4xNzUxMzZdICBbPGMxMTBmOTdjPl0g
c3lzZnNfYWRkX29uZSsweDg5LzB4OWIKWyAgICA0LjE3NjMzN10gIFs8YzExMGZhYTU+XSBj
cmVhdGVfZGlyKzB4NWMvMHg5MgpbICAgIDQuMTc2OTkyXSAgWzxjMTEwZmU0Mz5dIHN5c2Zz
X2NyZWF0ZV9kaXIrMHhmMS8weDEwYQpbICAgIDQuMTc3NjQyXSAgWzxjMTEzZWRiMD5dIGtv
YmplY3RfYWRkX2ludGVybmFsKzB4MTEzLzB4MjIwClsgICAgNC4xNzgzMzRdICBbPGMxMGRi
OTZkPl0gPyBrZnJlZSsweGE5LzB4MjFhClsgICAgNC4xNzg5NDldICBbPGMxMTQ4ZmMyPl0g
PyBrdmFzcHJpbnRmKzB4M2UvMHg0NwpbICAgIDQuMTgwMzM3XSAgWzxjMTEzZjBkMT5dIGtv
YmplY3RfaW5pdF9hbmRfYWRkKzB4NDMvMHg0OApbICAgIDQuMTgxMDkwXSAgWzxjMTFlZGEy
Yj5dIGJ1c19hZGRfZHJpdmVyKzB4Y2QvMHgyNmIKWyAgICA0LjE4MTcyNl0gIFs8YzExZWVm
MmY+XSBkcml2ZXJfcmVnaXN0ZXIrMHg5Ni8weGNhClsgICAgNC4xODIzNDNdICBbPGMxMjJm
ZDM3Pl0gaTJjX3JlZ2lzdGVyX2RyaXZlcisweDY0LzB4MTIzClsgICAgNC4xODMwNDldICBb
PGMxNjU1ZWZkPl0gdHBzX2luaXQrMHhhYi8weGJmClsgICAgNC4xODQzMzBdICBbPGMxNjU1
ZTUyPl0gPyB3bTg5OTRfaTJjX2RyaXZlcl9pbml0KzB4MTEvMHgxMQpbICAgIDQuMTg1MDk4
XSAgWzxjMTAwMDQ1Mj5dIGRvX29uZV9pbml0Y2FsbCsweGY0LzB4MWFmClsgICAgNC4xODU3
NTBdICBbPGMxNjMzNDJhPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAgICA0
LjE4NjQyMl0gIFs8YzEwNDZhNTc+XSA/IHBhcnNlX2FyZ3MrMHgyODQvMHgzOGYKWyAgICA0
LjE4NzA0NV0gIFs8YzEwNmE2MmY+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weGQKWyAg
ICA0LjE4ODMyNl0gIFs8YzE2MzNiMDM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDExNi8w
eDFiMApbICAgIDQuMTg5MDI5XSAgWzxjMTYzMzQxOD5dID8gZG9fZWFybHlfcGFyYW0rMHg3
YS8weDdhClsgICAgNC4xODk2MzRdICBbPGMxMmFhNWU0Pl0ga2VybmVsX2luaXQrMHgxMC8w
eGM4ClsgICAgNC4xOTAzMTNdICBbPGMxMmI2NTM3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVh
ZCsweDFiLzB4MjgKWyAgICA0LjE5MTAxMF0gIFs8YzEyYWE1ZDQ+XSA/IHJlc3RfaW5pdCsw
eDEzMS8weDEzMQpbICAgIDQuMTk0MDE1XSAtLS1bIGVuZCB0cmFjZSBhM2M0NTllNTM3ZmEw
Y2NjIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNh
MTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tYW50LTIyNTQ0LTIw
MTMwODIyMTMxNTE1LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVj
Mjk2NmVlMWRmOTEvZG1lc2cta3ZtLWFudC01OTU2LTIwMTMwODIyMTMxOTUxLTMuMTEuMC1y
YzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIw
ODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3Zt
LWFudC02MDQ1LTIwMTMwODIyMTMyNDM5LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVl
OWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWJlbnMtMzI3OC0yMDEzMDgyMjEz
MTM0NS0zLjExLjAtcmMyLTAwNDQ4LWc5NDBjNjA4LTM0Nwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFk
ZjkxL2RtZXNnLWt2bS1iZW5zLTMyNzgtMjAxMzA4MjIxMzE1NDctMy4xMS4wLXJjNi0wNDk2
Mi1nNzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAx
ZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tYmVucy0z
Mjc4LTIwMTMwODIyMTMxODA0LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJk
YmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWJlbnMtMzcwNi0yMDEzMDgyMjEzMTg0OS0z
LjExLjAtcmM2LTA0OTYyLWc3MDFmNjg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2Rt
ZXNnLWt2bS1iZW5zLTM4OTYtMjAxMzA4MjIxMzEyNTQtMy4xMS4wLXJjNi0wNDk2Mi1nNzAx
ZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNh
MTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tYmVucy0zODk2LTIw
MTMwODIyMTMxMzI0LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVj
Mjk2NmVlMWRmOTEvZG1lc2cta3ZtLWJlbnMtMzg5Ni0yMDEzMDgyMjEzMjEzMy0zLjExLjAt
cmM2LTAzODY4LWc5NTZjM2JmLTM0NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2
bS1iZW5zLTQxMTctMjAxMzA4MjIxMzIyNDQtMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0z
NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0
ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tYmVucy00MTk4LTIwMTMwODIy
MTMyMTA1LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVl
MWRmOTEvZG1lc2cta3ZtLWlubi0xMDExNS0yMDEzMDgyMjEzMjEzMi0zLjExLjAtcmM2LTA0
OTYyLWc3MDFmNjg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83
MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS1pbm4t
MTAxMTUtMjAxMzA4MjIxMzI1MjUtMy4xMS4wLXJjNi0wMDMwMC1nNWY3MTg1MC0zMzcKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1
YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0taW5uLTEwMjQxLTIwMTMwODIyMTMyNzU3
LTMuMTEuMC1yYzYtMDAzMzEtZ2ZjNTFmMjUtMzM0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEv
ZG1lc2cta3ZtLWlubi0xMDY4Mi0yMDEzMDgyMjEzMTgyNy0zLjExLjAtcmM2LTA0OTYyLWc3
MDFmNjg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4
Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS1pbm4tMTE1NjQt
MjAxMzA4MjIxMzIzMTEtMy4xMS4wLXJjNi0wMDI4Ny1nMDg2Mjg4ZjgtMzQyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYw
NjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi0xMTg3OS0yMDEzMDgyMjEzMjE0MC0zLjEx
LjAtcmM2LTAwMjE5LWdlNTM0ZGRlLTI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNn
LWt2bS1pbm4tMTE4NzktMjAxMzA4MjIxMzIzMzEtMy4xMS4wLXJjNi0wMDIxOS1nZTUzNGRk
ZS0yOTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3
ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0taW5uLTExOTQyLTIwMTMw
ODIyMTMzNDU4LTMuMTEuMC1yYzYtMDAzMDAtZzVmNzE4NTAtMzUwCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2
NmVlMWRmOTEvZG1lc2cta3ZtLWlubi02MzI1LTIwMTMwODIyMTMyMTQxLTMuMTEuMC1yYzIt
MDA0NDQtZzhlODQ4YjctMzQ2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4
LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlu
bi02MzI1LTIwMTMwODIyMTMyMzMzLTMuMTEuMC1yYzItMDA0NDQtZzhlODQ4YjctMzQ2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMz
NWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi02NDU1LTIwMTMwODIyMTMyNTEw
LTMuMTEuMC1yYzYtMDAzMjYtZzllOGExNWYtMzQwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEv
ZG1lc2cta3ZtLWlubi02NTgxLTIwMTMwODIyMTMyNzU0LTMuMTEuMC1yYzYtMDAyMTktZ2U1
MzRkZGUtMzA0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhj
YTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi03NTI2LTIw
MTMwODIyMTMyNjQ1LTMuMTEuMC1yYzYtMDAyOTEtZ2IzOWEwMzQtMzQzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVj
Mjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi03Nzc4LTIwMTMwODIyMTMyNzM1LTMuMTEuMC1y
YzYtMDAyMDEtZzdlMDMzMWUtMTYyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIw
ODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3Zt
LWlubi03OTY3LTIwMTMwODIyMTMyODA1LTMuMTEuMC1yYzYtMDA0MDMtZzQyY2E3YzEtMzQw
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVl
OWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi04ODQ5LTIwMTMwODIyMTMy
NjQyLTMuMTEuMC1yYzYtMDAzMjctZzI2Njg5MGYtMzMwCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRm
OTEvZG1lc2cta3ZtLWlubi05MDM4LTIwMTMwODIyMTMyODE2LTMuMTEuMC1yYzYtMDAzMDMt
ZzNjMTJhZWEtMzUzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2
ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi05MTAx
LTIwMTMwODIyMTMyMzI0LTMuMTEuMC1yYzYtMDAyMTgtZ2QyYWU5MDMtMjk3Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYw
NjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLWlubi05MzUzLTIwMTMwODIyMTMyNzE2LS0KL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1
YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tbmhtNC0xNTI2NS0yMDEzMDgyMjA1MjQy
OS0zLjExLjAtcmM2LTAwMzAyLWcyOWI5ZDNhLTMzNwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkx
L2RtZXNnLWt2bS1uaG00LTQ0ODctMjAxMzA4MjIwNTI0MjgtMy4xMS4wLXJjNi0wMDIyNi1n
NTA2NGM2NS0zMDYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4
OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tbmhtNC01MzU0
LTIwMTMwODIyMDUyMzQ1LTMuMTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYw
NjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLW5obTQtNTM1NC0yMDEzMDgyMjA1MjQwNy0zLjEx
LjAtcmM2LTA0OTYyLWc3MDFmNjg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNn
LWt2bS1uaG00LTY0MDctMjAxMzA4MjIwNTI0MjctMy4xMS4wLXJjNi0wMDIyMi1nZTFmMDAx
Yi0zMDEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3
ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0tbmhtNC02NzQ5LTIwMTMw
ODIyMDUxOTE3LTMuMTEuMC1yYzYtMDAyOTgtZzQxYjI4NmYtMzM3Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2
NmVlMWRmOTEvZG1lc2cta3ZtLW5obTQtODgwNi0yMDEzMDgyMjA1MTg1My0zLjExLjAtcmM2
LTA0OTYyLWc3MDFmNjg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgw
OC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS1z
dG9ha2xleS0yMDA0Ni0yMDEzMDgyMjEzMjQzOS0zLjExLjAtcmM2LTA0OTYyLWc3MDFmNjg4
LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdl
OTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS1zdG9ha2xleS0yMDIxNi0y
MDEzMDgyMjEzMTcwOS0zLjExLjAtcmMyLTAwNDI0LWc0YzliZDA0LTMzOQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJmMDY1
YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS13YWltZWEtMjEyNTItMjAxMzA4MjIxMzI1NDktMy4x
MS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEt
MDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVz
Zy1rdm0td2FpbWVhLTIxMjUyLTIwMTMwODIyMTMyNjEzLTMuMTEuMC1yYzYtMDQ5NjItZzcw
MWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzcwMWY2ODhj
YTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLXdhaW1lYS0yMTI1
Mi0yMDEzMDgyMjEzMjgxMC0zLjExLjAtcmM2LTA0OTYyLWc3MDFmNjg4LTM0Mwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRlZTljMzViZGJm
MDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS13YWltZWEtMjEyOTItMjAxMzA4MjIxMzIwNTUt
My4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9k
bWVzZy1rdm0td2FpbWVhLTg3ODktMjAxMzA4MjIxMzIxMjQtMy4xMS4wLXJjNi0wNDk2Mi1n
NzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4
OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0td2FpbWVhLTkz
MzMtMjAxMzA4MjIxMzE1NDUtMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRi
ZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0td2FpbWVhLTkzMzMtMjAxMzA4MjIxMzIxMjgt
My4xMS4wLXJjNi0wMDIxOC1nZDJhZTkwMy0yOTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9k
bWVzZy1rdm0td2FpbWVhLTkzNDMtMjAxMzA4MjIxMzE5MTktMy4xMS4wLXJjNi0wNDk2Mi1n
NzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4
OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0td2FpbWVhLTkz
NDMtMjAxMzA4MjIxMzIyNDMtMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRi
ZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0td2FpbWVhLTkzNTMtMjAxMzA4MjIxMzIzNDEt
My4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9k
bWVzZy1rdm0td2FpbWVhLTk5NjgtMjAxMzA4MjIxMzE2MzAtMy4xMS4wLXJjNi0wNDk2Mi1n
NzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4
OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0td2FpbWVhLTk5
NjgtMjAxMzA4MjIxMzE4MDAtMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRi
ZjA2NWMyOTY2ZWUxZGY5MS9kbWVzZy1rdm0teGd3by00MTA0LTIwMTMwODIyMTMxMzAxLTMu
MTEuMC1yYzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWox
LTA4MjIwODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1l
c2cta3ZtLXhnd28tNDEwNC0yMDEzMDgyMjEzMTk0NC0zLjExLjAtcmM2LTA0OTYyLWc3MDFm
Njg4LTM0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2Ex
MTdlOTRlZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS14Z3dvLTc3ODktMjAx
MzA4MjIxMzIzMjAtMy4xMS4wLXJjNi0wNDk2Mi1nNzAxZjY4OC0zNDMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMy
OTY2ZWUxZGY5MS9kbWVzZy1rdm0teHBzLTEwMjE4LTIwMTMwODIyMTMxMjU1LTMuMTEuMC1y
YzYtMDQ5NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIw
ODA4LzcwMWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3Zt
LXhwcy0xMDIxOC0yMDEzMDgyMjEzMjEyMS0zLjExLjAtcmM2LTA0OTYyLWc3MDFmNjg4LTM0
Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83MDFmNjg4Y2ExMTdlOTRl
ZTljMzViZGJmMDY1YzI5NjZlZTFkZjkxL2RtZXNnLWt2bS14cHMtMTQ3NTQtMjAxMzA4MjIx
MzI0MDgtMy4xMS4wLXJjNi0wMDQwMy1nNDJjYTdjMS0zNDcKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMDgyMjA4MDgvNzAxZjY4OGNhMTE3ZTk0ZWU5YzM1YmRiZjA2NWMyOTY2ZWUx
ZGY5MS9kbWVzZy1rdm0teHBzLTE0NzU1LTIwMTMwODIyMTMyMzU0LTMuMTEuMC1yYzYtMDQ5
NjItZzcwMWY2ODgtMzQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4Lzcw
MWY2ODhjYTExN2U5NGVlOWMzNWJkYmYwNjVjMjk2NmVlMWRmOTEvZG1lc2cta3ZtLXhwcy0x
Njc1MC0yMDEzMDgyMjEzMjMyNS0zLjExLjAtcmM2LTA0OTYyLWc3MDFmNjg4LTM0MwoKQmlz
ZWN0aW5nOiAxMDkzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxMCBzdGVwcykKWzk1NmMzYmZiYmVkZDdkNTQ5YjM0MmQzMjBkYjBlYjliYzcwMjQyOGZd
IE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ21vZHVsZXMvbW9kdWxlcy1uZXh0Jwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvbmV4dDptYXN0ZXI6OTU2YzNiZmJiZWRk
N2Q1NDliMzQyZDMyMGRiMGViOWJjNzAyNDI4ZjpiaXNlY3QtdXNiCgoyMDEzLTA4LTIzLTIy
OjI4OjAxIDk1NmMzYmZiYmVkZDdkNTQ5YjM0MmQzMjBkYjBlYjliYzcwMjQyOGYgcmV1c2Ug
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvOTU2YzNiZmJiZWRkN2Q1NDli
MzQyZDMyMGRiMGViOWJjNzAyNDI4Zi92bWxpbnV6LTMuMTEuMC1yYzYtMDM4NjgtZzk1NmMz
YmYKCjIwMTMtMDgtMjMtMjI6Mjg6MDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JNjMu
CTY4CTY5Lgk3MC4uLgk3MS4uLi4uLi4uCTcyCTczLi4uCTc0CTc2CTgwCTgxCTgzCTg2CTg5
Lgk5Mwk5NC4JOTUJOTYuLgk5OC4JOTkuLi4uLgkxMDAuLi4uLi4JMTAxLi4uCTEwMgkxMDMu
Li4uLi4uCTEwNC4JMTA1Li4JMTA2CTEwNwkxMDguCTEwOS4JMTEwLgkxMTEuLgkxMTQJMTE1
LgkxMTYuLi4uLi4uLi4uCTExOAkxMjAuLi4uLgkxMjEJMTIyLgkxMjMuCTEyNQkxMjYuCTEy
OC4JMTI5CTEzMC4uLi4uCTEzMS4JMTMyCTEzMwkxMzQuLi4JMTM1LgkxMzYJMTM3CTEzOC4u
Li4JMTM5CTE0MC4JMTQxLi4uCTE0Mi4uCTE0My4uLi4uLi4JMTQ0LgkxNDYuLi4uLgkxNDcJ
MTQ5CTE1MC4JMTUxLi4uLgkxNTIuLi4uCTE1MwkxNTQuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNTUJMTU2Li4uLi4uLi4uLi4u
Li4JMTU3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVu
X3F1ZXVlIDMbWzBtCi4uLi4uLi4uLi4JMTU4Li4uLi4uLi4uLi4uLgkxNTkuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4u
Li4uLi4uCTE2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDUyNyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2Q3Njc1OWFiMjBlNDBhYmFmYmZh
YjcyMmZlZWIyMTg1MTYzNWE0YjVdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3Nw
aS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVy
OmQ3Njc1OWFiMjBlNDBhYmFmYmZhYjcyMmZlZWIyMTg1MTYzNWE0YjU6YmlzZWN0LXVzYgoK
MjAxMy0wOC0yNC0wNTo1NToxNyBkNzY3NTlhYjIwZTQwYWJhZmJmYWI3MjJmZWViMjE4NTE2
MzVhNGI1IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2Q3Njc1
OWFiMjBlNDBhYmFmYmZhYjcyMmZlZWIyMTg1MTYzNWE0YjUvdm1saW51ei0zLjExLjAtcmM2
LTA0NDM0LWdkNzY3NTlhCgoyMDEzLTA4LTI0LTA1OjU1OjE3IGRldGVjdGluZyBib290IHN0
YXRlIC4uLgk2Mgk2NC4uCTY2Li4uLgk2Ny4uCTY4CTY5CTcwLgk3Mgk3OAk4NAkxMjEJMTM0
CTE1NC4uLi4JMTU2CTE1OS4uCTE2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI2NCByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2NiMWQwYzA0
MzJjMDcwOTA4MTVhZTllZTVkMDUwZDgyOTAwMTgzNzddIE1lcmdlIGJyYW5jaCAneDg2L2Fz
bScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOmNiMWQwYzA0
MzJjMDcwOTA4MTVhZTllZTVkMDUwZDgyOTAwMTgzNzc6YmlzZWN0LXVzYgoKMjAxMy0wOC0y
NC0wNjoxMjoxOSBjYjFkMGMwNDMyYzA3MDkwODE1YWU5ZWU1ZDA1MGQ4MjkwMDE4Mzc3IHJl
dXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2NiMWQwYzA0MzJjMDcw
OTA4MTVhZTllZTVkMDUwZDgyOTAwMTgzNzcvdm1saW51ei0zLjExLjAtcmM2LTAxMDU1LWdj
YjFkMGMwCgoyMDEzLTA4LTI0LTA2OjEyOjE5IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4J
NjEJNjIuLi4uLi4uLi4JNjMuLi4uLi4uLgk2NAk2NS4JNjYuCTY3Li4uCTY4Li4uLi4JNjku
Li4uLi4uLi4uCTcwCTcxLi4uLgk3Mi4JNzMJNzYuCTc3CTc5CTgwCTgxCTgyCTgzLgk4NAk4
NS4JODYJODcJODgJOTAJOTMJOTQuLgk5NQk5NgkxMDIJMTA4CTEwOQkxMTAJMTExCTExMgkx
MTMuLgkxMTQJMTE3CTEyMAkxMzIJMTQyLgkxNDYJMTUxCTE1Ny4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAzG1swbQouLi4JMTU5CTE2
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE0MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzA4ZmVhNTFiOTZjOGQwYzlkYjA2Zjk4YTU5NTNk
MjFkYjk5NTA0MTldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3JjdS9yY3UvbmV4
dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOjA4ZmVhNTFi
OTZjOGQwYzlkYjA2Zjk4YTU5NTNkMjFkYjk5NTA0MTk6YmlzZWN0LXVzYgoKMjAxMy0wOC0y
NC0wOTozNDo1NCAwOGZlYTUxYjk2YzhkMGM5ZGIwNmY5OGE1OTUzZDIxZGI5OTUwNDE5IGNv
bXBpbGluZwoxODcgcmVhbCAgNzE1IHVzZXIgIDc5IHN5cyAgNDIzLjE4JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOAoKMjAxMy0wOC0yNC0wOTozODo0MSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjExLjAtcmM2LTA0ODE5LWcwOGZlYTUxLi4uCTEuLi4JMi4JMwk1CTkJ
MTQJMTcJMjEJNDcJNzUJMTA1CTEzMQkxNTMJMTU0CTE1NwkxNjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiA4NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBz
dGVwcykKW2VkZTBlMTZkZDI1YjIyNzQyNzBlM2NmYTMwZDljOWE4OGRiYWMwZThdIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3JlZ21hcC9mb3ItbmV4dCcKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOmVkZTBlMTZkZDI1YjIyNzQyNzBlM2Nm
YTMwZDljOWE4OGRiYWMwZTg6YmlzZWN0LXVzYgoKMjAxMy0wOC0yNC0wOTo1MDoxMiBlZGUw
ZTE2ZGQyNWIyMjc0MjcwZTNjZmEzMGQ5YzlhODhkYmFjMGU4IGNvbXBpbGluZwoxMTMgcmVh
bCAgNzg5IHVzZXIgIDgwIHN5cyAgNzYzLjg2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOAoKMjAxMy0wOC0yNC0wOTo1MjoyNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEx
LjAtcmM2LTA0ODc3LWdlZGUwZTE2LgkxCTUJNy4JOAk5Li4uCTEwLi4uLi4uLi4uLgkxMS4u
LgkxMi4JMTMJMTQuLgkxNS4uLi4uLgkxNi4uLgkxOS4JMjMJMjUuCTI3CTI4CTMxCTQwCTY3
CTg3CTExOAkxMzUJMTUwCTE1MwkxNTYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
G1sxOzM1bWFkZF90b19ydW5fcXVldWUgNBtbMG0KLi4uLi4uCTE1NwkxNTguLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uCTE1OS4uLgkxNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0
MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykK
W2E5M2Q2YjBhODc5NzE4YTFhMDg1NTM5MzU3NDRiMGQ1YzU4MzU0YzBdIGRldmZyZXE6IGNv
bnZlcnQgZGV2ZnJlcV9jbGFzcyB0byB1c2UgZGV2X2dyb3VwcwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctajEtMDgyMjA4MDgvbmV4dDptYXN0ZXI6YTkzZDZiMGE4Nzk3MThhMWEwODU1MzkzNTc0
NGIwZDVjNTgzNTRjMDpiaXNlY3QtdXNiCgoyMDEzLTA4LTI0LTEzOjEzOjU5IGE5M2Q2YjBh
ODc5NzE4YTFhMDg1NTM5MzU3NDRiMGQ1YzU4MzU0YzAgY29tcGlsaW5nCjEzNyByZWFsICA3
NTkgdXNlciAgODEgc3lzICA2MTEuNTQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIw
ODA4CgoyMDEzLTA4LTI0LTEzOjE2OjMyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1y
YzMtMDAwNDItZ2E5M2Q2YjAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVS
RQpbICAgIDAuMzAwNzY3XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dmZy91c2Iv
ZnMvc3lzZnMvZGlyLmM6NTMwIHN5c2ZzX2FkZF9vbmUrMHg4OS8weDliKCkKWyAgICAwLjMw
MjAzNF0gc3lzZnM6IGNhbm5vdCBjcmVhdGUgZHVwbGljYXRlIGZpbGVuYW1lICcvYnVzL2ky
Yy9kcml2ZXJzL3RwczY1MDEwJwpbICAgIDAuMzAzMDc5XSBNb2R1bGVzIGxpbmtlZCBpbjoK
WyAgICAwLjMwMzU0M10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVk
IDMuMTEuMC1yYzMtMDAwNDItZ2E5M2Q2YjAgIzM0OQpbICAgIDAuMzA0MDA2XSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4zMDQ4
MzZdICBjYzQ1OWQ5MCBjYzQ1OWQ5MCBjYzQ1OWQ1MCBjMTJhYzZlNyBjYzQ1OWQ4MCBjMTAy
YTU4NyBjMTQwZjFlYSBjYzQ1OWRhYwpbICAgIDAuMzA2MTMzXSAgMDAwMDAwMDEgYzE0MGYx
OGYgMDAwMDAyMTIgYzExMGRkYWQgYzExMGRkYWQgY2M0MWEwMDAgY2M2NTkwYjAgY2M0NTlk
ZGMKWyAgICAwLjMwODE3Nl0gIGNjNDU5ZDk4IGMxMDJhNWQxIDAwMDAwMDA5IGNjNDU5ZDkw
IGMxNDBmMWVhIGNjNDU5ZGFjIGNjNDU5ZGMwIGMxMTBkZGFkClsgICAgMC4zMDk1MzhdIENh
bGwgVHJhY2U6ClsgICAgMC4zMDk5NDZdICBbPGMxMmFjNmU3Pl0gZHVtcF9zdGFjaysweDE2
LzB4MTgKWyAgICAwLjMxMDYwNV0gIFs8YzEwMmE1ODc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1v
bisweDdhLzB4OTEKWyAgICAwLjMxMTM3OF0gIFs8YzExMGRkYWQ+XSA/IHN5c2ZzX2FkZF9v
bmUrMHg4OS8weDliClsgICAgMC4zMTIwMDddICBbPGMxMTBkZGFkPl0gPyBzeXNmc19hZGRf
b25lKzB4ODkvMHg5YgpbICAgIDAuMzEyODEzXSAgWzxjMTAyYTVkMT5dIHdhcm5fc2xvd3Bh
dGhfZm10KzB4MzMvMHgzNQpbICAgIDAuMzEzNTUzXSAgWzxjMTEwZGRhZD5dIHN5c2ZzX2Fk
ZF9vbmUrMHg4OS8weDliClsgICAgMC4zMTQyNDFdICBbPGMxMTBkZWQ2Pl0gY3JlYXRlX2Rp
cisweDVjLzB4OTIKWyAgICAwLjMxNDkyNl0gIFs8YzExMGUyNzQ+XSBzeXNmc19jcmVhdGVf
ZGlyKzB4ZjEvMHgxMGEKWyAgICAwLjMxNTY5OF0gIFs8YzExM2QxMDk+XSBrb2JqZWN0X2Fk
ZF9pbnRlcm5hbCsweDExMy8weDIyMApbICAgIDAuMzE2MDA5XSAgWzxjMTBkYjBjMT5dID8g
a2ZyZWUrMHhhOS8weDIxYQpbICAgIDAuMzE2NjQzXSAgWzxjMTE0NzFkOD5dID8ga3Zhc3By
aW50ZisweDNlLzB4NDcKWyAgICAwLjMxNzM2MF0gIFs8YzExM2Q0MmE+XSBrb2JqZWN0X2lu
aXRfYW5kX2FkZCsweDQzLzB4NDgKWyAgICAwLjMxODEzN10gIFs8YzExZWIyMjY+XSBidXNf
YWRkX2RyaXZlcisweGNkLzB4MjZiClsgICAgMC4zMTg4NzBdICBbPGMxMWVjNzJhPl0gZHJp
dmVyX3JlZ2lzdGVyKzB4OTYvMHhjYQpbICAgIDAuMzIwMDA5XSAgWzxjMTIyZDdlMj5dIGky
Y19yZWdpc3Rlcl9kcml2ZXIrMHg2NC8weDEyMwpbICAgIDAuMzIwODE0XSAgWzxjMTY1MGE4
Mj5dIHRwc19pbml0KzB4YWIvMHhiZgpbICAgIDAuMzIxNDUwXSAgWzxjMTY1MDlkNz5dID8g
d204OTk0X2kyY19kcml2ZXJfaW5pdCsweDExLzB4MTEKWyAgICAwLjMyMjMwN10gIFs8YzEw
MDA0NTI+XSBkb19vbmVfaW5pdGNhbGwrMHhmNC8weDFhZgpbICAgIDAuMzIzMDM4XSAgWzxj
MTA2MDAwMD5dID8gdXBkYXRlX3dhbGxfdGltZSsweDE5Ny8weDkyMQpbICAgIDAuMzI0MDA3
XSAgWzxjMTE0NWE4NT5dID8gc3RybGVuKzB4MTAvMHgxYwpbICAgIDAuMzI0NjQ2XSAgWzxj
MTYyZTQyYT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMC4zMjU0MjNd
ICBbPGMxMDQ5NTRlPl0gPyBwYXJzZV9hcmdzKzB4MjhkLzB4Mzk4ClsgICAgMC4zMjYxNDRd
ICBbPGMxMDZhMTBjPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHhkClsgICAgMC4zMjY5
MDRdICBbPGMxNjJlYjAzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTYvMHgxYjAKWyAg
ICAwLjMyNzcwNV0gIFs8YzE2MmU0MTg+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4N2EvMHg3YQpb
ICAgIDAuMzI4MDA5XSAgWzxjMTJhNmZmOT5dIGtlcm5lbF9pbml0KzB4MTAvMHhjOApbICAg
IDAuMzI4NjgwXSAgWzxjMTJiMmZmNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8w
eDI4ClsgICAgMC4zMjk1MjRdICBbPGMxMmE2ZmU5Pl0gPyByZXN0X2luaXQrMHgxMzEvMHgx
MzEKWyAgICAwLjMzMDI3OF0gLS0tWyBlbmQgdHJhY2UgZDE4ZTgxNjlhNDZhMzlhMSBdLS0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L2E5M2Q2YjBhODc5NzE4YTFh
MDg1NTM5MzU3NDRiMGQ1YzU4MzU0YzAvZG1lc2cta3ZtLXdhaW1lYS04Nzg5LTIwMTMwODI0
MTMyNzMyLTMuMTEuMC1yYzMtMDAwNDItZ2E5M2Q2YjAtMzQ5CgpCaXNlY3Rpbmc6IDIwIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNWJh
YTc1MDNhN2EwYjhkNjUzMDhmZjNiMmFiODg3YmYzNDNjNjVkM10gbGVkczogY29udmVydCBj
bGFzcyBjb2RlIHRvIHVzZSBkZXZfZ3JvdXBzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC9uZXh0Om1hc3Rlcjo1YmFhNzUwM2E3YTBiOGQ2NTMwOGZmM2IyYWI4ODdiZjM0M2M2
NWQzOmJpc2VjdC11c2IKCjIwMTMtMDgtMjQtMTM6Mjk6MDQgNWJhYTc1MDNhN2EwYjhkNjUz
MDhmZjNiMmFiODg3YmYzNDNjNjVkMyBjb21waWxpbmcKMTM0IHJlYWwgIDc1NiB1c2VyICA3
OSBzeXMgIDYxOS4zNiUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgKCjIwMTMt
MDgtMjQtMTM6MzE6MzIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0wMDAyMS1n
NWJhYTc1MC4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMjYwNTMwXSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dmZy91c2IvZnMvc3lzZnMvZGlyLmM6NTMwIHN5
c2ZzX2FkZF9vbmUrMHg4OS8weDliKCkKWyAgICAwLjI2MTc3NV0gc3lzZnM6IGNhbm5vdCBj
cmVhdGUgZHVwbGljYXRlIGZpbGVuYW1lICcvYnVzL2kyYy9kcml2ZXJzL3RwczY1MDEwJwpb
ICAgIDAuMjYyODk5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjI2MzQwNl0gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMjEtZzVi
YWE3NTAgIzM1MApbICAgIDAuMjY0MDA1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4yNjQ5MDddICBjYzQ1OWQ4OCBjYzQ1OWQ4
OCBjYzQ1OWQ0OCBjMTJhZDdhNyBjYzQ1OWQ3OCBjMTAyYTU4NyBjMTQxMDlhOCBjYzQ1OWRh
NApbICAgIDAuMjY2MzI2XSAgMDAwMDAwMDEgYzE0MTA5NGQgMDAwMDAyMTIgYzExMGU4M2Yg
YzExMGU4M2YgY2M0MWEwMDAgY2M2NTkwYjAgY2M0NTlkZDQKWyAgICAwLjI2ODMzOF0gIGNj
NDU5ZDkwIGMxMDJhNWQxIDAwMDAwMDA5IGNjNDU5ZDg4IGMxNDEwOWE4IGNjNDU5ZGE0IGNj
NDU5ZGI4IGMxMTBlODNmClsgICAgMC4yNjk3NjRdIENhbGwgVHJhY2U6ClsgICAgMC4yNzAx
NDddICBbPGMxMmFkN2E3Pl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAwLjI3MDg3NF0g
IFs8YzEwMmE1ODc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdhLzB4OTEKWyAgICAwLjI3
MTcxOV0gIFs8YzExMGU4M2Y+XSA/IHN5c2ZzX2FkZF9vbmUrMHg4OS8weDliClsgICAgMC4y
NzIwMDddICBbPGMxMTBlODNmPl0gPyBzeXNmc19hZGRfb25lKzB4ODkvMHg5YgpbICAgIDAu
MjcyNzg5XSAgWzxjMTAyYTVkMT5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MzMvMHgzNQpbICAg
IDAuMjczNjE2XSAgWzxjMTEwZTgzZj5dIHN5c2ZzX2FkZF9vbmUrMHg4OS8weDliClsgICAg
MC4yNzQzNzhdICBbPGMxMTBlOTY4Pl0gY3JlYXRlX2RpcisweDVjLzB4OTIKWyAgICAwLjI3
NTA2NV0gIFs8YzExMGVkMDY+XSBzeXNmc19jcmVhdGVfZGlyKzB4ZjEvMHgxMGEKWyAgICAw
LjI3NjAwOF0gIFs8YzExM2RiMDU+XSBrb2JqZWN0X2FkZF9pbnRlcm5hbCsweDExMy8weDIy
MApbICAgIDAuMjc2NzQ1XSAgWzxjMTBkYmI1Mz5dID8ga2ZyZWUrMHhhOS8weDIxYQpbICAg
IDAuMjc3Mjc4XSAgWzxjMTE0N2JjOD5dID8ga3Zhc3ByaW50ZisweDNlLzB4NDcKWyAgICAw
LjI3Nzg5Nl0gIFs8YzExM2RlMjY+XSBrb2JqZWN0X2luaXRfYW5kX2FkZCsweDQzLzB4NDgK
WyAgICAwLjI3ODU2M10gIFs8YzExZWJkNGI+XSBidXNfYWRkX2RyaXZlcisweGNkLzB4MjQz
ClsgICAgMC4yNzkxNzZdICBbPGMxMWVkMTU5Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4OTYvMHhm
MwpbICAgIDAuMjgwMDA3XSAgWzxjMTIyZTZhYT5dIGkyY19yZWdpc3Rlcl9kcml2ZXIrMHg2
NC8weDEyMwpbICAgIDAuMjgwNjk1XSAgWzxjMTY1M2E5Mz5dIHRwc19pbml0KzB4YWIvMHhi
ZgpbICAgIDAuMjgxMjI2XSAgWzxjMTY1MzllOD5dID8gd204OTk0X2kyY19kcml2ZXJfaW5p
dCsweDExLzB4MTEKWyAgICAwLjI4MTk0NF0gIFs8YzEwMDA0NTI+XSBkb19vbmVfaW5pdGNh
bGwrMHhmNC8weDFhZgpbICAgIDAuMjgyNTgyXSAgWzxjMTA2NmRlMD5dID8gbG9ja19yZWxl
YXNlX2hvbGR0aW1lKzB4YzMvMHhjOQpbICAgIDAuMjgzMjczXSAgWzxjMTJiMzBkZj5dID8g
X3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2UvMHg1NApbICAgIDAuMjg0MDA4XSAg
WzxjMTYzMTQyYT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMC4yODQ2
ODFdICBbPGMxMDQ5NmEyPl0gPyBwYXJzZV9hcmdzKzB4MjhkLzB4Mzk4ClsgICAgMC4yODUy
NzJdICBbPGMxMDZhMzhlPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHhkClsgICAgMC4y
ODU5MjJdICBbPGMxNjMxYjAzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTYvMHgxYjAK
WyAgICAwLjI4NjYzNl0gIFs8YzE2MzE0MTg+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4N2EvMHg3
YQpbICAgIDAuMjg3MjUxXSAgWzxjMTJhODBiOT5dIGtlcm5lbF9pbml0KzB4MTAvMHhjOApb
ICAgIDAuMjg4MDA3XSAgWzxjMTJiNDBiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgx
Yi8weDI4ClsgICAgMC4yODg3MTZdICBbPGMxMmE4MGE5Pl0gPyByZXN0X2luaXQrMHgxMzEv
MHgxMzEKWyAgICAwLjI4OTMyMV0gLS0tWyBlbmQgdHJhY2UgOWQxMGNhYjY0MmI2NjQzYiBd
LS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzViYWE3NTAzYTdhMGI4
ZDY1MzA4ZmYzYjJhYjg4N2JmMzQzYzY1ZDMvZG1lc2cta3ZtLXdhaW1lYS0xNjgwNi0yMDEz
MDgyNDEzMzUyOC0zLjExLjAtcmMyLTAwMDIxLWc1YmFhNzUwLTM1MAoKQmlzZWN0aW5nOiAx
MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykK
W2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGRdIGtvYmplY3Q6IGRl
bGF5ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVnZ3kgZHJpdmVycwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajEtMDgyMjA4MDgvbmV4dDptYXN0ZXI6YzgxN2E2N2VjYmE3YzNjMmFh
YTEwNDc5NmQ3OGYxNjBhZjYwOTIwZDpiaXNlY3QtdXNiCgoyMDEzLTA4LTI0LTEzOjM4OjM4
IGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQgY29tcGlsaW5nCjMw
IHJlYWwgIDEwNCB1c2VyICAyMyBzeXMgIDQxNC4yNSUgY3B1IAlpMzg2LXJhbmRjb25maWct
ajEtMDgyMjA4MDgKCjIwMTMtMDgtMjQtMTM6Mzk6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLXJjMi0wMDAxMC1nYzgxN2E2Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1Qg
RkFJTFVSRQpbICAgIDAuMTk2NDI2XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dm
Zy91c2IvZnMvc3lzZnMvZGlyLmM6NTMwIHN5c2ZzX2FkZF9vbmUrMHg4OS8weDliKCkKWyAg
ICAwLjE5NzA3N10gc3lzZnM6IGNhbm5vdCBjcmVhdGUgZHVwbGljYXRlIGZpbGVuYW1lICcv
YnVzL2kyYy9kcml2ZXJzL3RwczY1MDEwJwpbICAgIDAuMTk3NjQxXSBNb2R1bGVzIGxpbmtl
ZCBpbjoKWyAgICAwLjE5NzkwN10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0
YWludGVkIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcgIzM1MQpbICAgIDAuMTk4NDg3XSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAg
MC4xOTg5MzldICBjYzQ1OWQ4OCBjYzQ1OWQ4OCBjYzQ1OWQ0OCBjMTJhZDdhNyBjYzQ1OWQ3
OCBjMTAyYTU4NyBjMTQxMDk1YyBjYzQ1OWRhNApbICAgIDAuMTk5NjI3XSAgMDAwMDAwMDEg
YzE0MTA5MDEgMDAwMDAyMTIgYzExMGU4M2YgYzExMGU4M2YgY2M0MWEwMDAgY2M2NTkwYjAg
Y2M0NTlkZDQKWyAgICAwLjIwMDMyMV0gIGNjNDU5ZDkwIGMxMDJhNWQxIDAwMDAwMDA5IGNj
NDU5ZDg4IGMxNDEwOTVjIGNjNDU5ZGE0IGNjNDU5ZGI4IGMxMTBlODNmClsgICAgMC4yMDEw
MDldIENhbGwgVHJhY2U6ClsgICAgMC4yMDEyMDFdICBbPGMxMmFkN2E3Pl0gZHVtcF9zdGFj
aysweDE2LzB4MTgKWyAgICAwLjIwMTU1OV0gIFs8YzEwMmE1ODc+XSB3YXJuX3Nsb3dwYXRo
X2NvbW1vbisweDdhLzB4OTEKWyAgICAwLjIwMTk3OV0gIFs8YzExMGU4M2Y+XSA/IHN5c2Zz
X2FkZF9vbmUrMHg4OS8weDliClsgICAgMC4yMDIzNjBdICBbPGMxMTBlODNmPl0gPyBzeXNm
c19hZGRfb25lKzB4ODkvMHg5YgpbICAgIDAuMjAyNzMyXSAgWzxjMTAyYTVkMT5dIHdhcm5f
c2xvd3BhdGhfZm10KzB4MzMvMHgzNQpbICAgIDAuMjAzMTMwXSAgWzxjMTEwZTgzZj5dIHN5
c2ZzX2FkZF9vbmUrMHg4OS8weDliClsgICAgMC4yMDM1MDRdICBbPGMxMTBlOTY4Pl0gY3Jl
YXRlX2RpcisweDVjLzB4OTIKWyAgICAwLjIwMzg2Nl0gIFs8YzExMGVkMDY+XSBzeXNmc19j
cmVhdGVfZGlyKzB4ZjEvMHgxMGEKWyAgICAwLjIwNDAwNl0gIFs8YzExM2RiMDU+XSBrb2Jq
ZWN0X2FkZF9pbnRlcm5hbCsweDExMy8weDIyMApbICAgIDAuMjA0NDM0XSAgWzxjMTBkYmI1
Mz5dID8ga2ZyZWUrMHhhOS8weDIxYQpbICAgIDAuMjA0NzgzXSAgWzxjMTE0N2JjOD5dID8g
a3Zhc3ByaW50ZisweDNlLzB4NDcKWyAgICAwLjIwNTE1Ml0gIFs8YzExM2RlMjY+XSBrb2Jq
ZWN0X2luaXRfYW5kX2FkZCsweDQzLzB4NDgKWyAgICAwLjIwNTU3Nl0gIFs8YzExZWJkNGI+
XSBidXNfYWRkX2RyaXZlcisweGNkLzB4MjQzClsgICAgMC4yMDU5NDJdICBbPGMxMWVkMTU5
Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4OTYvMHhmMwpbICAgIDAuMjA2MzM1XSAgWzxjMTIyZTZh
YT5dIGkyY19yZWdpc3Rlcl9kcml2ZXIrMHg2NC8weDEyMwpbICAgIDAuMjA2NzU2XSAgWzxj
MTY1M2E5Mz5dIHRwc19pbml0KzB4YWIvMHhiZgpbICAgIDAuMjA3MDk5XSAgWzxjMTY1Mzll
OD5dID8gd204OTk0X2kyY19kcml2ZXJfaW5pdCsweDExLzB4MTEKWyAgICAwLjIwNzU0OV0g
IFs8YzEwMDA0NTI+XSBkb19vbmVfaW5pdGNhbGwrMHhmNC8weDFhZgpbICAgIDAuMjA4MDA1
XSAgWzxjMTA2NmRlMD5dID8gbG9ja19yZWxlYXNlX2hvbGR0aW1lKzB4YzMvMHhjOQpbICAg
IDAuMjA4NDQ2XSAgWzxjMTJiMzBkZj5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3Jl
KzB4M2UvMHg1NApbICAgIDAuMjA4OTIzXSAgWzxjMTYzMTQyYT5dID8gcmVwYWlyX2Vudl9z
dHJpbmcrMHgxMi8weDUxClsgICAgMC4yMDkzMzRdICBbPGMxMDQ5NmEyPl0gPyBwYXJzZV9h
cmdzKzB4MjhkLzB4Mzk4ClsgICAgMC4yMDk3MjBdICBbPGMxMDZhMzhlPl0gPyB0cmFjZV9o
YXJkaXJxc19vbisweGIvMHhkClsgICAgMC4yMTAxMTldICBbPGMxNjMxYjAzPl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHgxMTYvMHgxYjAKWyAgICAwLjIxMDUzOF0gIFs8YzE2MzE0MTg+
XSA/IGRvX2Vhcmx5X3BhcmFtKzB4N2EvMHg3YQpbICAgIDAuMjEwOTIyXSAgWzxjMTJhODBi
OT5dIGtlcm5lbF9pbml0KzB4MTAvMHhjOApbICAgIDAuMjExMjgzXSAgWzxjMTJiNDBiNz5d
IHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMC4yMTE3MTZdICBbPGMx
MmE4MGE5Pl0gPyByZXN0X2luaXQrMHgxMzEvMHgxMzEKWyAgICAwLjIxMjAzMV0gLS0tWyBl
bmQgdHJhY2UgMWNjNmNmNDkzODEzMTM2NSBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4L2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQv
ZG1lc2cta3ZtLW5obTQtNTMyMi0yMDEzMDgyNDA1NDUxMy0zLjExLjAtcmMyLTAwMDEwLWdj
ODE3YTY3LTM1MQoKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbODk5ODI2ZjE2YTAzNGYxYWI2ZDIzY2Q1YjYwY2Qx
MTNlYWVmYWQxOV0gZW5jbG9zdXJlOiBjb252ZXJ0IGNsYXNzIGNvZGUgdG8gdXNlIGRldl9n
cm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOjg5OTgy
NmYxNmEwMzRmMWFiNmQyM2NkNWI2MGNkMTEzZWFlZmFkMTk6YmlzZWN0LXVzYgoKMjAxMy0w
OC0yNC0xMzo1MDo1NSA4OTk4MjZmMTZhMDM0ZjFhYjZkMjNjZDViNjBjZDExM2VhZWZhZDE5
IGNvbXBpbGluZwoxMjUgcmVhbCAgNzU1IHVzZXIgIDgwIHN5cyAgNjY2LjcyJSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOAoKMjAxMy0wOC0yNC0xMzo1MzoxNCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDA1LWc4OTk4MjZmLi4uLi4uLi4uLi4JMS4u
Li4uLi4uLi4uLi4uLi4uLi4uCTIuCTMuLi4uLi4uLgk0Li4uCTUuLi4uCTYuLi4uLi4uLi4u
CTcJOC4uCTkuLi4uCTEwLi4uLi4uLi4uLi4JMTEuLi4uLi4uLi4uLi4JMTIuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMTMuLi4uLi4uLi4uLgkxNC4uLi4uLi4uLgkxNS4uLi4uLi4uLi4u
Li4uLi4uCTE2Li4uLi4uLi4uLgkxNy4uLi4uLi4uLi4uLi4JMTguLgkxOS4uLgkyMC4JMjEu
Li4uLi4uLgkyMi4uLi4uCTIzCTI0CTI1Li4JMjYuLi4uCTI5CTMwLi4JMzEuCTMzCTM1Lgkz
Ni4JMzcJMzgJMzkJNDEuLi4JNDIuLgk0My4JNDQuLgk0NQk0OC4JNDkJNTAJNTIJNTMJNTUu
Li4uCTU3Lgk1OC4uLi4uLi4uCTU5Li4uLi4JNjAuLi4uCTYxLgk2NQk2Ni4JNjcuCTY4CTcw
Lgk3MQk3Mgk3My4uCTc0Lgk3OAk4MQk4Ni4uCTg5Li4JOTQJOTUJOTkJMTAxCTEwNwkxMTAu
LgkxMTMJMTE3LgkxMjAJMTIyLgkxMjMJMTI2CTEyNwkxMjguLgkxMjkJMTMxCTEzMy4JMTM4
CTE0MAkxNDIJMTQ1CTE0OQkxNTAJMTUzCTE1NS4uCTE1OAkxNjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCltlNTYzNDFhZDM4MDExNDQ1NDExOWFjMDQzZTZkNzEwZGRiYmI3NzEwXSBzdGFnaW5n
OiBjb21lZGk6IGNvbnZlcnQgY2xhc3MgY29kZSB0byB1c2UgZGV2X2dyb3VwcwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajEtMDgyMjA4MDgvbmV4dDptYXN0ZXI6ZTU2MzQxYWQzODAxMTQ0NTQx
MTlhYzA0M2U2ZDcxMGRkYmJiNzcxMDpiaXNlY3QtdXNiCgoyMDEzLTA4LTI0LTE2OjQ0OjIy
IGU1NjM0MWFkMzgwMTE0NDU0MTE5YWMwNDNlNmQ3MTBkZGJiYjc3MTAgY29tcGlsaW5nCjM1
IHJlYWwgIDk4IHVzZXIgIDE5IHN5cyAgMzM0LjYwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1q
MS0wODIyMDgwOAoKMjAxMy0wOC0yNC0xNjo0NToxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtcmMyLTAwMDA3LWdlNTYzNDFhLi4JMQkyLgkzLi4JNAk1CTYuCTguLi4uLi4uCTku
Li4uCTEwLi4uCTExLi4uLi4uLi4uLi4uLi4uLi4uCTE0Li4uCTE3CTE4LgkxOQkzMwkzNwk1
MAk1NQk2NQk3Ngk4MAk4Mwk4OQk5OAkxMTcJMTI3CTE0MQkxNDIuLgkxNDYJMTUyCTE1My4u
LgkxNTQuLi4uLi4uLi4uLgkxNTUuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bWFkZF90b19ydW5fcXVldWUgNRtbMG0KLi4uLgkxNTYuLi4JMTU3CTE1OS4uLi4uLi4u
Li4uCTE2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1
NThjZjJmYjg2YWEzNWFdIGNoYXI6IHRpbGUtc3JvbTogZml4IGJ1aWxkIGVycm9yCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9uZXh0Om1hc3Rlcjo3YzQyNzIxZmUwYzU4YTg0
ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhOmJpc2VjdC11c2IKCjIwMTMtMDgtMjQtMjA6MTI6
MjIgN2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YSBjb21waWxpbmcK
MzEgcmVhbCAgOTUgdXNlciAgMTkgc3lzICAzNjIuNTclIGNwdSAJaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4CgoyMDEzLTA4LTI0LTIwOjEzOjA4IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTEuMC1yYzItMDAwMDktZzdjNDI3MjEuLi4JMS4uCTIuCTMJNC4uLgkxOQkyOQkzOQk0
MS4JODgJMTIwCTE0NgkxNDkJMTU2CTE1Ny4uLi4uLi4uCTE1OS4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNjAgU1VDQ0VTUwoKYzgxN2E2
N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZCBpcyB0aGUgZmlyc3QgYmFkIGNv
bW1pdApjb21taXQgYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZApB
dXRob3I6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm0ubGludXgub3JnLnVrPgpEYXRl
OiAgIFRodSBKdW4gMjcgMTU6MDY6MTQgMjAxMyArMDEwMAoKICAgIGtvYmplY3Q6IGRlbGF5
ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVnZ3kgZHJpdmVycwogICAgCiAgICBJ
bXBsZW1lbnQgZGVidWdnaW5nIGZvciBrb2JqZWN0IHJlbGVhc2UgZnVuY3Rpb25zLiAga29i
amVjdHMgYXJlCiAgICByZWZlcmVuY2UgY291bnRlZCwgc28gdGhlIGRyb3Agb2YgdGhlIGxh
c3QgcmVmZXJlbmNlIHRvIHRoZW0gaXMgbm90CiAgICBwcmVkaWN0YWJsZS4gSG93ZXZlciwg
dGhlIGNvbW1vbiBjYXNlIGlzIGZvciB0aGUgbGFzdCByZWZlcmVuY2UgdG8gYmUKICAgIHRo
ZSBrb2JqZWN0J3MgcmVtb3ZhbCBmcm9tIGEgc3Vic3lzdGVtLCB3aGljaCByZXN1bHRzIGlu
IHRoZSByZWxlYXNlCiAgICBmdW5jdGlvbiBiZWluZyBpbW1lZGlhdGVseSBjYWxsZWQuCiAg
ICAKICAgIFRoaXMgY2FuIGhpZGUgc3VidGxlIGJ1Z3MsIHdoaWNoIGNhbiBvY2N1ciB3aGVu
IGFub3RoZXIgdGhyZWFkIGhvbGRzIGEKICAgIHJlZmVyZW5jZSB0byB0aGUga29iamVjdCBh
dCB0aGUgc2FtZSB0aW1lIHRoYXQgYSBrb2JqZWN0IGlzIHJlbW92ZWQuCiAgICBUaGlzIHJl
c3VsdHMgaW4gdGhlIHJlbGVhc2UgbWV0aG9kIGJlaW5nIGRlbGF5ZWQuCiAgICAKICAgIElu
IG9yZGVyIHRvIG1ha2UgdGhlc2Uga2luZHMgb2YgcHJvYmxlbXMgbW9yZSB2aXNpYmxlLCB0
aGUgZm9sbG93aW5nCiAgICBwYXRjaCBpbXBsZW1lbnRzIGEgZGVsYXllZCByZWxlYXNlOyB0
aGlzIGhhcyB0aGUgZWZmZWN0IHRoYXQgdGhlCiAgICByZWxlYXNlIGZ1bmN0aW9uIHdpbGwg
YmUgb3V0IG9mIG9yZGVyIHdpdGggcmVzcGVjdCB0byB0aGUgcmVtb3ZhbCBvZgogICAgdGhl
IGtvYmplY3QgaW4gdGhlIHNhbWUgbWFubmVyIHRoYXQgaXQgd291bGQgYmUgaWYgYSByZWZl
cmVuY2Ugd2FzCiAgICBiZWluZyBoZWxkLgogICAgCiAgICBUaGlzIHByb3ZpZGVzIHVzIHdp
dGggYW4gZWFzeSB3YXkgdG8gYWxsb3cgZHJpdmVyIHdyaXRlcnMgdG8gZGVidWcKICAgIHRo
ZWlyIGRyaXZlcnMgYW5kIGZpeCBvdGhlcndpc2UgaGlkZGVuIHByb2JsZW1zLgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtLmxpbnV4Lm9y
Zy51az4KICAgIFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBmNmMyM2VmYTEwMmZjMmMyZWFk
NWM4NmJkYjY1YWE3MDcxOWIxYWI5IDA0OTg1OWZhN2EzYTk1Mzg5MjEyNzQ2N2JhYmJmMDJm
NjZhNjliNzYgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIGE0MWQyMDY2OWYwZjYyNGQyY2U5
Y2E3ZTZhNWY5NmU0ZjkxNDMyZTAgYmYyMTY4MTk0ZjgyOTExY2YyZTE4OTJkODJmMGMxM2Qw
MGM3NzJhZSBNCWxpYgpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9uZXh0Om1hc3Rlcjo3
YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhOmJpc2VjdC11c2IKCjIw
MTMtMDgtMjQtMjA6NTU6NDIgN2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZh
YTM1YSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC83YzQyNzIx
ZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhL3ZtbGludXotMy4xMS4wLXJjMi0w
MDAwOS1nN2M0MjcyMQoKMjAxMy0wOC0yNC0yMDo1NTo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4JMTYyLgkxNjQuLgkyMTkJMjQyCTI0MwkzMTUJMzY2CTM4MgkzODkJNDE0CTQ1Ngk0
NjQuCTQ3MQk0NzIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90
b19ydW5fcXVldWUgOBtbMG0KLi4uLi4uCTQ3NAk0NzUuLgk0NzYJNDc3Lgk0ODAgU1VDQ0VT
UwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1q
MS0wODIyMDgwOC9uZXh0Om1hc3RlcjoyZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjEx
YjgwZWFmODYxOmJpc2VjdC11c2IKIFRFU1QgRkFJTFVSRQpbICAgIDQuNzA2Njc2XSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAxIGF0IGZzL3N5c2ZzL2Rpci5jOjUzMCBzeXNmc19hZGRfb25l
KzB4ODkvMHg5YigpClsgICAgNC43MDgzMzhdIHN5c2ZzOiBjYW5ub3QgY3JlYXRlIGR1cGxp
Y2F0ZSBmaWxlbmFtZSAnL2J1cy9pMmMvZHJpdmVycy90cHM2NTAxMCcKWyAgICA0LjcwOTI4
Nl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNC43MTA2MzhdIENQVTogMCBQSUQ6IDEgQ29t
bTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDIt
ZzJkNTU4ODAgIzEKWyAgICA0LjcxMjI4NF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDQuNzEzNDg3XSAgY2M0NTlkYTAgY2M0NTlk
YTAgY2M0NTlkNjAgYzEyYWU2MzMgY2M0NTlkOTAgYzEwMmE3MjUgYzE0MTU4MGEgY2M0NTlk
YmMKWyAgICA0LjcxNDkyMV0gIDAwMDAwMDAxIGMxNDE1N2ExIDAwMDAwMjEyIGMxMTBlMmNj
IGMxMTBlMmNjIGNjNDFhMDAwIGNjNjU3NjMwIGNjNDU5ZGRjClsgICAgNC43MTY4ODFdICBj
YzQ1OWRhOCBjMTAyYTc2ZiAwMDAwMDAwOSBjYzQ1OWRhMCBjMTQxNTgwYSBjYzQ1OWRiYyBj
YzQ1OWRkMCBjMTEwZTJjYwpbICAgIDQuNzE4MzgzXSBDYWxsIFRyYWNlOgpbICAgIDQuNzE5
MTUzXSAgWzxjMTJhZTYzMz5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgNC43MjQ0MTJd
ICBbPGMxMDJhNzI1Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3YS8weDkxClsgICAgNC43
MjUxMzFdICBbPGMxMTBlMmNjPl0gPyBzeXNmc19hZGRfb25lKzB4ODkvMHg5YgpbICAgIDQu
NzI1NzYyXSAgWzxjMTEwZTJjYz5dID8gc3lzZnNfYWRkX29uZSsweDg5LzB4OWIKWyAgICA0
LjcyNjQzNl0gIFs8YzEwMmE3NmY+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDMzLzB4MzUKWyAg
ICA0LjcyNzExMV0gIFs8YzExMGUyY2M+XSBzeXNmc19hZGRfb25lKzB4ODkvMHg5YgpbICAg
IDQuNzI4MzI3XSAgWzxjMTEwZTNlMz5dIGNyZWF0ZV9kaXIrMHg1Ny8weDhkClsgICAgNC43
Mjg5MzRdICBbPGMxMTBlNzY5Pl0gc3lzZnNfY3JlYXRlX2RpcisweGU5LzB4MTAyClsgICAg
NC43Mjk1OThdICBbPGMxMTNkYTNiPl0ga29iamVjdF9hZGRfaW50ZXJuYWwrMHgxMTMvMHgy
MjAKWyAgICA0LjczMDMwMV0gIFs8YzEwZGE2MzU+XSA/IGtmcmVlKzB4YTkvMHgyMWEKWyAg
ICA0LjczMDg4NF0gIFs8YzExNDdkMzA+XSA/IGt2YXNwcmludGYrMHgzZS8weDQ3ClsgICAg
NC43MzE0OTVdICBbPGMxMTNkZDVjPl0ga29iamVjdF9pbml0X2FuZF9hZGQrMHg0My8weDQ4
ClsgICAgNC43MzIzMTBdICBbPGMxMWVjMTFmPl0gYnVzX2FkZF9kcml2ZXIrMHhjZC8weDI2
YgpbICAgIDQuNzMyOTg0XSAgWzxjMTFlZDYyMz5dIGRyaXZlcl9yZWdpc3RlcisweDk2LzB4
Y2EKWyAgICA0LjczMzY1NV0gIFs8YzEyMmUzYTg+XSBpMmNfcmVnaXN0ZXJfZHJpdmVyKzB4
NjQvMHgxMjMKWyAgICA0LjczNDMyOF0gIFs8YzE2NTgxNjc+XSB0cHNfaW5pdCsweGFiLzB4
YmYKWyAgICA0LjczNDk0Nl0gIFs8YzE2NTgwYmM+XSA/IHdtODk5NF9pMmNfZHJpdmVyX2lu
aXQrMHgxMS8weDExClsgICAgNC43NDA1MTJdICBbPGMxMDAwNDUyPl0gZG9fb25lX2luaXRj
YWxsKzB4ZjQvMHgxYWYKWyAgICA0Ljc0MTIyN10gIFs8YzExNDY0OTc+XSA/IHN0cmxlbisw
eDEyLzB4MWMKWyAgICA0Ljc0MTg1MF0gIFs8YzE2MzU0MmE+XSA/IHJlcGFpcl9lbnZfc3Ry
aW5nKzB4MTIvMHg1MQpbICAgIDQuNzQyNTM4XSAgWzxjMTA0NjkwZT5dID8gcGFyc2VfYXJn
cysweDI4NC8weDM4ZgpbICAgIDQuNzQzMjEwXSAgWzxjMTYzNWIwMz5dIGtlcm5lbF9pbml0
X2ZyZWVhYmxlKzB4MTE2LzB4MWIwClsgICAgNC43NDQzNDVdICBbPGMxNjM1NDE4Pl0gPyBk
b19lYXJseV9wYXJhbSsweDdhLzB4N2EKWyAgICA0Ljc0NTAwN10gIFs8YzEyYTg5NDA+XSBr
ZXJuZWxfaW5pdCsweDEwLzB4YzgKWyAgICA0Ljc0NTY0OV0gIFs8YzEyYjUwZDc+XSByZXRf
ZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDQuNzQ2MzMwXSAgWzxjMTJhODkz
MD5dID8gcmVzdF9pbml0KzB4MTMxLzB4MTMxClsgICAgNC43NDk3NjhdIC0tLVsgZW5kIHRy
YWNlIDM5M2MzYmU0MzE0NmIzNjggXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNn
LWt2bS1hbnQtMjI1NzgtMjAxMzA4MjMxNzA5MzUtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIx
LTA2ODQyLWcyZDU1ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgv
MmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tYW50
LTIyNjY0LTIwMTMwODIzMTcxOTM1LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMS0wNjg0Mi1n
MmQ1NTg4MC0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBj
NDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEvZG1lc2cta3ZtLWJlbnMtMzYwNy0y
MDEzMDgyMzE3MDk0OS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAt
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0
NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1iZW5zLTM5NzEtMjAxMzA4MjIx
MjA1MDctMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIxLTA2ODQyLWcyZDU1ODgwLTEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVk
M2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tYmVucy0zOTcxLTIwMTMwODIzMTcxNjM4LTMu
MTEuMC1yYzYtbmV4dC0yMDEzMDgyMS0wNjg0Mi1nMmQ1NTg4MC0xCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFi
ODBlYWY4NjEvZG1lc2cta3ZtLWJlbnMtNDA0MC0yMDEzMDgyMzE3MjAyMy0zLjExLjAtcmM2
LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYx
L2RtZXNnLWt2bS1iZW5zLTQwNDAtMjAxMzA4MjMxNzIxMjYtMy4xMS4wLXJjNi1uZXh0LTIw
MTMwODIxLTA2ODQyLWcyZDU1ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgy
MjA4MDgvMmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1r
dm0tYmVucy00MTE3LTIwMTMwODIyMDkyMTAyLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMS0w
Njg0Mi1nMmQ1NTg4MC0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzJk
NTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEvZG1lc2cta3ZtLWJlbnMt
NDE5OC0yMDEzMDgyMzE3MTQwMC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJk
NTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQw
YTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1pbm4tNjg5Ni0yMDEz
MDgyMjA5MjQ0OS0zLjExLjAtcmMyLTAwMTM3LWdlYzU2Y2FhLTIzMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjEx
YjgwZWFmODYxL2RtZXNnLWt2bS1pbm4tNzY1Mi0yMDEzMDgyMjA5MjQ1MC0zLjExLjAtcmMy
LTAwMTcwLWc0MDNhYjljLTI5OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgw
OC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1p
bm4tODAzMC0yMDEzMDgyMjA5MjQzMS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDIt
ZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgw
YzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1qYWtldG93bi0x
NDk3Mi0yMDEzMDgyMjEyMTk0OC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJk
NTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQw
YTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1qYWtldG93bi0yMTEx
NC0yMDEzMDgyMjEyMTc1MC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4
ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNh
YzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1qYWtldG93bi0yNDUwNy0y
MDEzMDgyMjEyMTgzMS0zLjExLjAtcmMyLTAwNDQ5LWdmYzI5YzM3LTI4NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJk
ZjExYjgwZWFmODYxL2RtZXNnLWt2bS1uaG00LTM1MTEtMjAxMzA4MjMwOTAyMjktMy4xMS4w
LXJjNi1uZXh0LTIwMTMwODIxLTA2ODQyLWcyZDU1ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMDgyMjA4MDgvMmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVh
Zjg2MS9kbWVzZy1rdm0tbmhtNC00NjQwLTIwMTMwODIzMDkxMjQ0LTMuMTAuMC0zNDAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1NTg4MGM0MGEzYWMxNDVlZDkx
NzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tbmhtNC02MDMxLTIwMTMwODIzMDkxMjE5
LTMuMTEuMC1yYzYtMDA2OTItZ2ZhN2Q0OTgtNDIxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEv
ZG1lc2cta3ZtLXJvYW0tMTAxNTUtMjAxMzA4MjIwOTI0NDMtMy4xMS4wLXJjMi0wMDEyMS1n
Y2M3OTM2Zi0yMjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1NTg4
MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tcm9hbS0xMTYw
NC0yMDEzMDgyMjEyMjI0NS0zLjExLjAtcmMyLTAwMDA1LWc0OWFkOWU4LTMzMgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQz
YmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1yb2FtLTExNzkzLTIwMTMwODIyMDkyNDA0LTMu
MTEuMC1yYzItMDAxNzAtZzQwM2FiOWMtMjkwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWox
LTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEvZG1l
c2cta3ZtLXJvYW0tNTk2My0yMDEzMDgyMjA5MjQwNi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4
NjEvZG1lc2cta3ZtLXJvYW0tNjA3Ny0yMDEzMDgyMjEyMjI0Ni0zLjExLjAtcmMyLTAwMDAy
LWc0M2E4NDdmLTMxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1
ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS1yb2FtLTY0
NTEtMjAxMzA4MjIwOTI4MTUtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIxLTA2ODQyLWcyZDU1
ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1NTg4MGM0MGEz
YWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tcm9hbS03Mzg2LTIwMTMw
ODIyMTIyNjUyLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1NTg4
MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tcm9hbS05MDIx
LTIwMTMwODIyMTIyNzEzLTMuMTEuMC1yYzItMDAwMDEtZzQ5NjE5ZGUtMzEzCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNi
YmRmMTFiODBlYWY4NjEvZG1lc2cta3ZtLXJvYW0tOTA4NC0yMDEzMDgyMjEyMjcxNS0zLjEx
LjAtcmMxLTAwMDU1LWdmNWJhYWMzLTIxOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNn
LWt2bS1yb2FtLTkyMTAtMjAxMzA4MjIxMjIwNDktMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIx
LTA2ODQyLWcyZDU1ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgv
MmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0tcm9h
bS05NDYyLTIwMTMwODIyMDkyODE1LTMuMTEuMC1yYzItMDAxMzAtZ2Y4NDA3MjktMzA0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5
MTc1ZDNiYmRmMTFiODBlYWY4NjEvZG1lc2cta3ZtLXNuYi0xNjk2OS0yMDEzMDgyMzE3NTkz
NC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJk
ZjExYjgwZWFmODYxL2RtZXNnLWt2bS1zbmItMjYwNjItMjAxMzA4MjMxNzM2MTItMy4xMS4w
LXJjMS0wMDEwMS1nNTI5MzAxYy02NDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgy
MjA4MDgvMmQ1NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1r
dm0td2FpbWVhLTIxMjkyLTIwMTMwODIzMTcxODI0LTMuMTEuMC1yYzEtMDAzMTAtZzg0OTE1
YzYtNjY5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4LzJkNTU4ODBjNDBh
M2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEvZG1lc2cta3ZtLXdhaW1lYS0yNzIxMi0y
MDEzMDgyMzE3MjIzOS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAt
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0
NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtMzY0Ny0yMDEzMDgy
MzE3MDg0NC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3
NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtMzY0Ny0yMDEzMDgyMzE3MDkx
NC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJk
ZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtNDQ4Ny0yMDEzMDgyMjEyMDk0OS0zLjEx
LjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgw
ZWFmODYxL2RtZXNnLWt2bS13YWltZWEtODc4OS0yMDEzMDgyMjEyMTA0Ni0zLjExLjAtcmM2
LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYx
L2RtZXNnLWt2bS13YWltZWEtODc4OS0yMDEzMDgyMzE3MTIzMS0zLjExLjAtcmM2LW5leHQt
MjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0w
ODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNn
LWt2bS13YWltZWEtODg1MC0yMDEzMDgyMzE3MDUwOC0zLjExLjAtcmM2LW5leHQtMjAxMzA4
MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgw
OC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13
YWltZWEtODg1MC0yMDEzMDgyMzE3MTUzOC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4
NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1
ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEt
ODg2Ny0yMDEzMDgyMjEyMTkyMi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJk
NTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQw
YTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtODg3Mi0y
MDEzMDgyMjEyMTIxMS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAt
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0
NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtODkwMS0yMDEzMDgy
MjEyMTMyMi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3
NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtOTM0My0yMDEzMDgyMjEyMTI1
Mi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJk
ZjExYjgwZWFmODYxL2RtZXNnLWt2bS13YWltZWEtOTM0My0yMDEzMDgyMzE3MTA0My0zLjEx
LjAtcmM2LW5leHQtMjAxMzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qMS0wODIyMDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgw
ZWFmODYxL2RtZXNnLWt2bS14Z3dvLTEyNzUzLTIwMTMwODIyMTIwNzE5LTMuMTEuMC1yYzYt
bmV4dC0yMDEzMDgyMS0wNjg0Mi1nMmQ1NTg4MC0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTA4MjIwODA4LzJkNTU4ODBjNDBhM2FjMTQ1ZWQ5MTc1ZDNiYmRmMTFiODBlYWY4NjEv
ZG1lc2cta3ZtLXhnd28tOTQ2Mi0yMDEzMDgyMjEyMTMzNC0zLjExLjAtcmM2LW5leHQtMjAx
MzA4MjEtMDY4NDItZzJkNTU4ODAtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIy
MDgwOC8yZDU1ODgwYzQwYTNhYzE0NWVkOTE3NWQzYmJkZjExYjgwZWFmODYxL2RtZXNnLWt2
bS14cHMtMTAyMTgtMjAxMzA4MjIxMjE3MzYtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIxLTA2
ODQyLWcyZDU1ODgwLTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMDgyMjA4MDgvMmQ1
NTg4MGM0MGEzYWMxNDVlZDkxNzVkM2JiZGYxMWI4MGVhZjg2MS9kbWVzZy1rdm0teHBzLTE0
MjE2LTIwMTMwODIyMTIwODUwLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMS0wNjg0Mi1nMmQ1
NTg4MC0xCgpbZGV0YWNoZWQgSEVBRCA4ZGFhMjBlXSBSZXZlcnQgImtvYmplY3Q6IGRlbGF5
ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVnZ3kgZHJpdmVycyIKIDMgZmlsZXMg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA0MiBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC9uZXh0
Om1hc3Rlcjo4ZGFhMjBlNzEwYTRlOWUzYzg5M2EwNDNmMGQ0NTVmOGVmODgyODU5OmJpc2Vj
dC11c2IKCjIwMTMtMDgtMjQtMjM6NDQ6MDcgOGRhYTIwZTcxMGE0ZTllM2M4OTNhMDQzZjBk
NDU1ZjhlZjg4Mjg1OSBjb21waWxpbmcKCjIwMTMtMDgtMjQtMjM6NDc6MzAgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIxLTA3NjMwLWc4ZGFhMjBlLgky
Li4uLgkzLgk0Li4uLi4uCTUuLi4uLi4JNgk3Li4uLi4uLi4uLi4uLi4uLgk4Li4JOS4uLgkx
MC4JMTEuCTEyLi4JMTMuLi4uLi4uLi4uLgkxNC4uCTE1CTE2CTE3LgkxOC4JMTkJMjAJMjIJ
MjUJMjcJNjYJODUJMTU2CTIwMQkyMzcJMjQzCTI3MQkzMDMJMzI3CTM1NwkzNzQJMzg0CTQy
NQk0NjMuCTQ2Ny4uCTQ2OS4uLi4JNDcwLi4JNDcxLi4uLi4uCTQ3Mwk0NzUJNDc2Li4uLgk0
NzcuCTQ3OC4uLi4uLi4uLi4uLi4uCTQ4MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFt
ID09PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoxLTA4MjIwODA4L25leHQ6bWFzdGVyOjg5YjUzZTUw
YmQyYjc1YzIyOTQ0ZDU5NGFkYTM2YmVlZTFiMjNlMGY6YmlzZWN0LXVzYgoKMjAxMy0wOC0y
NS0wMDo1NjozOCA4OWI1M2U1MGJkMmI3NWMyMjk0NGQ1OTRhZGEzNmJlZWUxYjIzZTBmIGNv
bXBpbGluZwoKMjAxMy0wOC0yNS0wMTowNToxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEx
LjAtcmM2LTAwOTI2LWc4OWI1M2U1Li4uCTEJMgkzCTQuCTUJNi4uCTguCTEzCTE3LgkyMAky
MwkyNQkyOQkzMAkzMgkzNAkzNS4JMzYJMzgJNDEJNDUJNDcJNTMJNTcJNjIJNjYJMTExCTEz
MQkxNTYJMTYyCTE4MQkyMjgJMjUzCTQzMy4JNDQzCTQ0NAk0NTQJNDYxCTQ2NAk0NjYuLi4u
Li4uLi4uLi4uCTQ2Ny4uLi4uLi4uLi4uLi4uLi4uLi4JNDY4Li4JNDcwLi4uLi4uLi4uLi4J
NDcxLi4uLi4uCTQ3Mwk0NzQJNDc1Li4uCTQ3Ni4uLi4uLi4uLi4uLi4uLgk0NzcuLi4uLi4u
CTQ3OC4uLgk0NzkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQ4
MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5l
eHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1q
MS0wODIyMDgwOC9uZXh0Om1hc3RlcjoyNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5
ZWJmMmYwNjcwOmJpc2VjdC11c2IKCjIwMTMtMDgtMjUtMDI6MzU6NTkgMjQ1ZjA4Njk5ZDUz
MjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MCBjb21waWxpbmcKCjIwMTMtMDgtMjUtMDI6
Mzg6MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3
ODU3LWcyNDVmMDg2Li4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC4yODQ2NjFdIFdBUk5JTkc6
IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL3VzYi9mcy9zeXNmcy9kaXIuYzo1MzAgc3lzZnNf
YWRkX29uZSsweDg5LzB4OWIoKQpbICAgIDAuMjg1NzUwXSBzeXNmczogY2Fubm90IGNyZWF0
ZSBkdXBsaWNhdGUgZmlsZW5hbWUgJy9idXMvaTJjL2RyaXZlcnMvdHBzNjUwMTAnClsgICAg
MC4yODY3NDZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMjg3MjIyXSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIy
LTA3ODU3LWcyNDVmMDg2ICMzNTcKWyAgICAwLjI4ODAwM10gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMjg4NjcwXSAgY2M0NTlk
OTAgY2M0NTlkOTAgY2M0NTlkNTAgYzEyYWYzNGIgY2M0NTlkODAgYzEwMmE3NjUgYzE0MTU2
OGUgY2M0NTlkYWMKWyAgICAwLjI4OTc5N10gIDAwMDAwMDAxIGMxNDE1NjMzIDAwMDAwMjEy
IGMxMTBlODA1IGMxMTBlODA1IGNjNDFhMDAwIGNjNjU4MGIwIGNjNDU5ZGRjClsgICAgMC4y
OTA1NzRdICBjYzQ1OWQ5OCBjMTAyYTdhZiAwMDAwMDAwOSBjYzQ1OWQ5MCBjMTQxNTY4ZSBj
YzQ1OWRhYyBjYzQ1OWRjMCBjMTEwZTgwNQpbICAgIDAuMjkyMDAzXSBDYWxsIFRyYWNlOgpb
ICAgIDAuMjkyMjA1XSAgWzxjMTJhZjM0Yj5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAg
MC4yOTI2MDJdICBbPGMxMDJhNzY1Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3YS8weDkx
ClsgICAgMC4yOTMyMzJdICBbPGMxMTBlODA1Pl0gPyBzeXNmc19hZGRfb25lKzB4ODkvMHg5
YgpbICAgIDAuMjkzODA3XSAgWzxjMTEwZTgwNT5dID8gc3lzZnNfYWRkX29uZSsweDg5LzB4
OWIKWyAgICAwLjI5NDQwN10gIFs8YzEwMmE3YWY+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDMz
LzB4MzUKWyAgICAwLjI5NTAyM10gIFs8YzExMGU4MDU+XSBzeXNmc19hZGRfb25lKzB4ODkv
MHg5YgpbICAgIDAuMjk1NTkxXSAgWzxjMTEwZTkyZT5dIGNyZWF0ZV9kaXIrMHg1Yy8weDky
ClsgICAgMC4yOTYwMDldICBbPGMxMTBlY2NjPl0gc3lzZnNfY3JlYXRlX2RpcisweGYxLzB4
MTBhClsgICAgMC4yOTY2MThdICBbPGMxMTNlMTM4Pl0ga29iamVjdF9hZGRfaW50ZXJuYWwr
MHgxMTMvMHgyMjAKWyAgICAwLjI5NzI3NF0gIFs8YzEwZGE4ZGQ+XSA/IGtmcmVlKzB4YTkv
MHgyMWEKWyAgICAwLjI5Nzc4MV0gIFs8YzExNDg0NDI+XSA/IGt2YXNwcmludGYrMHgzZS8w
eDQ3ClsgICAgMC4yOTgzMzRdICBbPGMxMTNlNDU5Pl0ga29iamVjdF9pbml0X2FuZF9hZGQr
MHg0My8weDQ4ClsgICAgMC4yOTg5NjNdICBbPGMxMWVjYzA5Pl0gYnVzX2FkZF9kcml2ZXIr
MHhjZC8weDI2YgpbICAgIDAuMjk5NTQyXSAgWzxjMTFlZTEwZD5dIGRyaXZlcl9yZWdpc3Rl
cisweDk2LzB4Y2EKWyAgICAwLjMwMDAwOV0gIFs8YzEyMmVlZjA+XSBpMmNfcmVnaXN0ZXJf
ZHJpdmVyKzB4NjQvMHgxMjMKWyAgICAwLjMwMDU5NV0gIFs8YzE2NTYxNmU+XSB0cHNfaW5p
dCsweGFiLzB4YmYKWyAgICAwLjMwMDkyN10gIFs8YzE2NTYwYzM+XSA/IHdtODk5NF9pMmNf
ZHJpdmVyX2luaXQrMHgxMS8weDExClsgICAgMC4zMDEzNjZdICBbPGMxMDAwNDUyPl0gZG9f
b25lX2luaXRjYWxsKzB4ZjQvMHgxYWYKWyAgICAwLjMwMTk2M10gIFs8YzEwNjcwMTI+XSA/
IGxvY2tfcmVsZWFzZV9ob2xkdGltZSsweGMzLzB4YzkKWyAgICAwLjMwMjYxOV0gIFs8YzEy
YjRjYmY+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDNlLzB4NTQKWyAgICAw
LjMwMzM1NV0gIFs8YzE2MzM0MmE+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpb
ICAgIDAuMzA0MDExXSAgWzxjMTA0Njk1Yj5dID8gcGFyc2VfYXJncysweDI4NC8weDM4Zgpb
ICAgIDAuMzA0NTgzXSAgWzxjMTA2YTVjMD5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhiLzB4
ZApbICAgIDAuMzA1MTk5XSAgWzxjMTYzM2IwMz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
MTE2LzB4MWIwClsgICAgMC4zMDU4NzVdICBbPGMxNjMzNDE4Pl0gPyBkb19lYXJseV9wYXJh
bSsweDdhLzB4N2EKWyAgICAwLjMwNjQ3N10gIFs8YzEyYTk2NDM+XSBrZXJuZWxfaW5pdCsw
eDEwLzB4YzgKWyAgICAwLjMwNzAzMF0gIFs8YzEyYjVkZjc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgIDAuMzA4MDA4XSAgWzxjMTJhOTYzMz5dID8gcmVzdF9p
bml0KzB4MTMxLzB4MTMxClsgICAgMC4zMDg2NDFdIC0tLVsgZW5kIHRyYWNlIGQ2ZDFmMzc4
ZDljYzY4OWEgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0wODIyMDgwOC8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00LTQw
ODItMjAxMzA4MjQxODM2MTMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3ODU3LWcyNDVm
MDg2LTM1NwoK

--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc6-next-20130821-06842-g2d55880"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc6 Kernel Configuration
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
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
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
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
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
# CONFIG_BLOCK is not set
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
CONFIG_X86_32_IRIS=y
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
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
CONFIG_MPENTIUMII=y
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
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
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
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

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
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
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
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=m
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

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
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
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
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
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
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
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
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
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
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=m
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
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

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
CONFIG_GPIO_MCP23S08=m

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
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=m
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=m
CONFIG_BATTERY_RX51=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
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
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM800=m
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MAX77693=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS80031=m
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=m
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_RC5_SZ_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_TIMBERDALE=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_DEINTERLACE is not set
# CONFIG_VIDEO_SH_VEU is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m

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
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

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
CONFIG_DRM=y
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
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
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
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
# CONFIG_HID is not set

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
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
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
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

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
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=m
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=m
CONFIG_RTC_DRV_MAX8925=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS65910=m
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=m
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
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
CONFIG_DW_DMAC_CORE=m
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
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
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
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
# CONFIG_SAMSUNG_Q10 is not set
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
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_TWL=m
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
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
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
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
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
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
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
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
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_CRC64_ECMA=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--aM3YZ0Iwxop3KEKx--
