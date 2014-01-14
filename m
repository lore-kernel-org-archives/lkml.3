Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaANNpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:45:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:8350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:45:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="log'?scan'208";a="458555032"
Date: Tue, 14 Jan 2014 21:45:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [drm] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
Message-ID: <20140114134525.GA29558@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

I'm not sure if this is a good bisect because the errors are noisy,
however it's good to inform you of this possibility.

First bad commit may be a3483353c ("drm: check for !kdev in drm_unplug_minor()")

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+------------------------------------------------------------------------------------+--------------+--------------+
|                                                                                    | 0846c728e20a | efb753b8e013 |
+------------------------------------------------------------------------------------+--------------+--------------+
| boot_successes                                                                     | 183          | 18           |
| boot_failures                                                                      | 162          | 11           |
| BUG:kernel_early_hang_without_any_printk_output                                    | 1            |              |
| BUG:unable_to_handle_kernel                                                        | 161          | 3            |
| BUG:unable_to_handle_kernel_NULL_pointer_dereferenceNULL_pointer_dereference_at    | 161          |              |
| Oops                                                                               | 161          | 3            |
| Oops:SMP_SMP_DEBUG_PAGEALLOCDEBUG_PAGEALLOC                                        | 161          | 3            |
| EIP_is_at_drm_unplug_minor                                                         | 161          |              |
| Kernel_panic-not_syncing:Fatal_exception                                           | 161          | 2            |
| BUG:spinlock_lockup_suspected_on_CPU                                               | 0            | 3            |
| INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0            | 1            |
| BUG:unable_to_handle_kernel_paging_requestpaging_request_at                        | 0            | 3            |
| BUG:Bad_page_state_in_process                                                      | 0            | 1            |
| BUG:kernel_test_hang                                                               | 0            | 4            |
| EIP_is_at_default_send_IPI_mask_logical                                            | 0            | 3            |
| EIP_is_at_slob_free                                                                | 0            | 3            |
| EIP_is_at_drm_debugfs_cleanup                                                      | 0            | 1            |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt                              | 0            | 1            |
+------------------------------------------------------------------------------------+--------------+--------------+

[   12.071139] parport0: PC-style at 0x378
[   12.071139] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   12.115335] BUG: spinlock lockup suspected on CPU#0, swapper/0/1

git bisect start 26b265cd29dde56bf0901c421eabc7ae815f38c4 v3.12 --
git bisect good 7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b  # 23:43    115+      1  Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
git bisect  bad 13509c3a9d20a9df93dc9b944e8bd20fe1b454a7  # 23:58      3-      2  Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect  bad 4937e2a6f939a41bf811378e80d71f68aa0950c6  # 00:16      4-      4  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good 049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8  # 01:04    115+     46  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect good 98d38dd2ee30322fc9934d7490be3c5bee80950e  # 01:52    115+     51  Merge tag 'for-3.13' of git://git.openrisc.net/~jonas/linux
git bisect  bad f412f2c60b480fa5140a4b4cb321cd48c64e1812  # 02:06      0-      1  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 6c0514ddd973ff13c3d2b2e7ac1422c982afb8eb  # 02:41    115+     43  Merge tag 'blackfin-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux
git bisect  bad cd1177f25069cb494680eedd718e7c6d8fd85d10  # 02:52      9-      4  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect  bad a3483353ca4e6dbeef2ed62ebed01af109b5b27a  # 03:23      9-      2  drm: check for !kdev in drm_unplug_minor()
# first bad commit: [a3483353ca4e6dbeef2ed62ebed01af109b5b27a] drm: check for !kdev in drm_unplug_minor()
git bisect good 0846c728e20a0cd1e43fb75a3015f3b176a26466  # 06:05    345+    162  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
git bisect  bad efb753b8e0136fe66b507e8e1e42b5a2df7ba44d  # 06:05      0-     11  crypto: ixp4xx - Fix kernel compile error
git bisect good cf0c16eccacc7eaba6e710e553a7b5c0c39c6d70  # 09:20    345+    178  Revert "drm: check for !kdev in drm_unplug_minor()"
git bisect good 228fdc083b017eaf90e578fa86fb1ecfd5ffae87  # 11:23    345+      3  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 12:58    345+      0  Add linux-next specific files for 20140110

Thanks,
Fengguang

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-athens-27:20140105213955:i386-randconfig-r2-0105:3.13.0-rc1-00086-gefb753b:160"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.13.0-rc1-00086-gefb753b (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #160 SMP Sun Jan 5 21:35:48 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
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
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[400fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x02ed9000, 0x02ed9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x02eda000, 0x02edafff] PGTABLE
[    0.000000] BRK [0x02edb000, 0x02edbfff] PGTABLE
[    0.000000] BRK [0x02edc000, 0x02edcfff] PGTABLE
[    0.000000] BRK [0x02edd000, 0x02eddfff] PGTABLE
[    0.000000] BRK [0x02ede000, 0x02edefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 42900280, node_mem_map 4f=
994024
[    0.000000]   Normal zone: 576 pages used for memmap
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
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @4fcce000 s31808 r0 d13248 u45=
056
[    0.000000] pcpu-alloc: s31808 r0 d13248 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fcd0500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master/=
=2Evmlinuz-efb753b8e0136fe66b507e8e1e42b5a2df7ba44d-20140105213611-9-athens=
 branch=3Dcrypto/master BOOT_IMAGE=3D/kernel/i386-randconfig-r2-0105/efb753=
b8e0136fe66b507e8e1e42b5a2df7ba44d/vmlinuz-3.13.0-rc1-00086-gefb753b
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 224136K/261744K available (18339K kernel code, 1457K=
 rwdata, 5884K rodata, 1048K init, 4748K bss, 37608K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff3fe000   (2796 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x42916000 - 0x42a1c000   (1048 kB)
[    0.000000]       .data : 0x421e8fb8 - 0x42915500   (7345 kB)
[    0.000000]       .text : 0x41000000 - 0x421e8fb8   (18339 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D40090000 soft=3D40092000
[    0.000000] Linux version 3.13.0-rc1-00086-gefb753b (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #160 SMP Sun Jan 5 21:35:48 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
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
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[400fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x02ed9000, 0x02ed9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x02eda000, 0x02edafff] PGTABLE
[    0.000000] BRK [0x02edb000, 0x02edbfff] PGTABLE
[    0.000000] BRK [0x02edc000, 0x02edcfff] PGTABLE
[    0.000000] BRK [0x02edd000, 0x02eddfff] PGTABLE
[    0.000000] BRK [0x02ede000, 0x02edefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 42900280, node_mem_map 4f=
994024
[    0.000000]   Normal zone: 576 pages used for memmap
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
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @4fcce000 s31808 r0 d13248 u45=
056
[    0.000000] pcpu-alloc: s31808 r0 d13248 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fcd0500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master/=
=2Evmlinuz-efb753b8e0136fe66b507e8e1e42b5a2df7ba44d-20140105213611-9-athens=
 branch=3Dcrypto/master BOOT_IMAGE=3D/kernel/i386-randconfig-r2-0105/efb753=
b8e0136fe66b507e8e1e42b5a2df7ba44d/vmlinuz-3.13.0-rc1-00086-gefb753b
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 224136K/261744K available (18339K kernel code, 1457K=
 rwdata, 5884K rodata, 1048K init, 4748K bss, 37608K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff3fe000   (2796 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x42916000 - 0x42a1c000   (1048 kB)
[    0.000000]       .data : 0x421e8fb8 - 0x42915500   (7345 kB)
[    0.000000]       .text : 0x41000000 - 0x421e8fb8   (18339 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D40090000 soft=3D40092000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.992 MHz processor
[    0.000000] tsc: Detected 2892.992 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D28929920)
5785.98 BogoMIPS (lpj=3D28929920)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Mount-cache hash table entries: 512
[    0.020519] Initializing cgroup subsys devices
[    0.020519] Initializing cgroup subsys devices
[    0.021994] Initializing cgroup subsys net_cls
[    0.021994] Initializing cgroup subsys net_cls
[    0.023443] Initializing cgroup subsys perf_event
[    0.023443] Initializing cgroup subsys perf_event
[    0.024980] Initializing cgroup subsys net_prio
[    0.024980] Initializing cgroup subsys net_prio
[    0.026534] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026534] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026534] tlb_flushall_shift: -1
[    0.026534] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026534] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026534] tlb_flushall_shift: -1
[    0.031625] debug: unmapping init [mem 0x42a1c000-0x42a26fff]
[    0.031625] debug: unmapping init [mem 0x42a1c000-0x42a26fff]
[    0.041470] ACPI: Core revision 20130927
[    0.041470] ACPI: Core revision 20130927
[    0.046488] ACPI:=20
[    0.046488] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.048310] ftrace: allocating 56108 entries in 110 pages
[    0.048310] ftrace: allocating 56108 entries in 110 pages
[    0.070223] Getting VERSION: 50014
[    0.070223] Getting VERSION: 50014
[    0.071414] Getting VERSION: 50014
[    0.071414] Getting VERSION: 50014
[    0.072560] Getting ID: 0
[    0.072560] Getting ID: 0
[    0.073445] Getting ID: f000000
[    0.073445] Getting ID: f000000
[    0.074529] Getting LVT0: 8700
[    0.074529] Getting LVT0: 8700
[    0.075539] Getting LVT1: 8400
[    0.075539] Getting LVT1: 8400
[    0.076552] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.076552] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.080132] enabled ExtINT on CPU#0
[    0.080132] enabled ExtINT on CPU#0
[    0.082791] ENABLING IO-APIC IRQs
[    0.082791] ENABLING IO-APIC IRQs
[    0.083859] init IO_APIC IRQs
[    0.083859] init IO_APIC IRQs
[    0.084794]  apic 0 pin 0 not connected
[    0.084794]  apic 0 pin 0 not connected
[    0.086015] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.086015] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.088603] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.088603] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.090046] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.090046] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.092720] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.092720] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.095306] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.095306] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.100041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.100041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.102609] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.102609] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.105161] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.105161] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.107725] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.107725] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.110000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.110000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.110043] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.110043] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.112684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.112684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.115321] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.115321] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.120054] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.120054] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.122508] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.122508] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.125165]  apic 0 pin 16 not connected
[    0.125165]  apic 0 pin 16 not connected
[    0.126448]  apic 0 pin 17 not connected
[    0.126448]  apic 0 pin 17 not connected
[    0.127725]  apic 0 pin 18 not connected
[    0.127725]  apic 0 pin 18 not connected
[    0.130010]  apic 0 pin 19 not connected
[    0.130010]  apic 0 pin 19 not connected
[    0.131315]  apic 0 pin 20 not connected
[    0.131315]  apic 0 pin 20 not connected
[    0.132606]  apic 0 pin 21 not connected
[    0.132606]  apic 0 pin 21 not connected
[    0.133863]  apic 0 pin 22 not connected
[    0.133863]  apic 0 pin 22 not connected
[    0.135142]  apic 0 pin 23 not connected
[    0.135142]  apic 0 pin 23 not connected
[    0.136586] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.136586] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.139147] smpboot: CPU0:=20
[    0.139147] smpboot: CPU0: GenuineIntel GenuineIntel Common KVM processo=
rCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.142628] Using local APIC timer interrupts.
[    0.142628] calibrating APIC timer ...
[    0.142628] Using local APIC timer interrupts.
[    0.142628] calibrating APIC timer ...
[    0.150000] ... lapic delta =3D 6250095
[    0.150000] ... lapic delta =3D 6250095
[    0.150000] ... PM-Timer delta =3D 357959
[    0.150000] ... PM-Timer delta =3D 357959
[    0.150000] ... PM-Timer result ok
[    0.150000] ... PM-Timer result ok
[    0.150000] ..... delta 6250095
[    0.150000] ..... delta 6250095
[    0.150000] ..... mult: 268439536
[    0.150000] ..... mult: 268439536
[    0.150000] ..... calibration result: 10000152
[    0.150000] ..... calibration result: 10000152
[    0.150000] ..... CPU clock speed is 2892.9500 MHz.
[    0.150000] ..... CPU clock speed is 2892.9500 MHz.
[    0.150000] ..... host bus clock speed is 1000.0152 MHz.
[    0.150000] ..... host bus clock speed is 1000.0152 MHz.
[    0.150104] Performance Events:=20
[    0.150104] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.152994] ftrace: Allocated trace_printk buffers
[    0.152994] ftrace: Allocated trace_printk buffers
[    0.157774] CPU 1 irqstacks, hard=3D4f426000 soft=3D4f428000
[    0.157774] CPU 1 irqstacks, hard=3D4f426000 soft=3D4f428000
[    0.159776] x86: Booting SMP configuration:
[    0.159776] x86: Booting SMP configuration:
[    0.160008] .... node  #0, CPUs: =20
[    0.160008] .... node  #0, CPUs:         #1 #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffb021, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1


[    0.175655] x86: Booted up 1 node, 2 CPUs
[    0.175655] x86: Booted up 1 node, 2 CPUs
[    0.175599] KVM setup async PF for cpu 1
[    0.175599] KVM setup async PF for cpu 1
[    0.175599] kvm-stealtime: cpu 1, msr fcdb500
[    0.175599] kvm-stealtime: cpu 1, msr fcdb500
[    0.179356] smpboot: Total of 2 processors activated (11571.96 BogoMIPS)
[    0.179356] smpboot: Total of 2 processors activated (11571.96 BogoMIPS)
[    0.187126] xor: measuring software checksum speed
[    0.187126] xor: measuring software checksum speed
[    0.280031]    pIII_sse  :   150.800 MB/sec
[    0.280031]    pIII_sse  :   150.800 MB/sec
[    0.380014]    prefetch64-sse:   154.000 MB/sec
[    0.380014]    prefetch64-sse:   154.000 MB/sec
[    0.381381] xor: using function: prefetch64-sse (154.000 MB/sec)
[    0.381381] xor: using function: prefetch64-sse (154.000 MB/sec)
[    0.383274] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.383274] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.385772] regulator-dummy: no parameters
[    0.385772] regulator-dummy: no parameters
[    0.387332] NET: Registered protocol family 16
[    0.387332] NET: Registered protocol family 16
[    0.390182] cpuidle: using governor ladder
[    0.390182] cpuidle: using governor ladder
[    0.392416] ACPI: bus type PCI registered
[    0.392416] ACPI: bus type PCI registered
[    0.393650] dca service started, version 1.12.1
[    0.393650] dca service started, version 1.12.1
[    0.395109] PCI: Using configuration type 1 for base access
[    0.395109] PCI: Using configuration type 1 for base access
[    0.426568] bio: create slab <bio-0> at 0
[    0.426568] bio: create slab <bio-0> at 0
[    0.590034] raid6: mmxx1     2538 MB/s
[    0.590034] raid6: mmxx1     2538 MB/s
[    0.760013] raid6: mmxx2     3215 MB/s
[    0.760013] raid6: mmxx2     3215 MB/s
[    0.930017] raid6: sse1x1    2017 MB/s
[    0.930017] raid6: sse1x1    2017 MB/s
[    1.100031] raid6: sse1x2    2940 MB/s
[    1.100031] raid6: sse1x2    2940 MB/s
[    1.270026] raid6: sse2x1    4454 MB/s
[    1.270026] raid6: sse2x1    4454 MB/s
[    1.440019] raid6: sse2x2    6516 MB/s
[    1.440019] raid6: sse2x2    6516 MB/s
[    1.440742] raid6: using algorithm sse2x2 (6516 MB/s)
[    1.440742] raid6: using algorithm sse2x2 (6516 MB/s)
[    1.441659] raid6: using intx1 recovery algorithm
[    1.441659] raid6: using intx1 recovery algorithm
[    1.442846] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.442846] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.444406] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.444406] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.446293] ACPI: Added _OSI(Module Device)
[    1.446293] ACPI: Added _OSI(Module Device)
[    1.447059] ACPI: Added _OSI(Processor Device)
[    1.447059] ACPI: Added _OSI(Processor Device)
[    1.447868] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.447868] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.448726] ACPI: Added _OSI(Processor Aggregator Device)
[    1.448726] ACPI: Added _OSI(Processor Aggregator Device)
[    1.456180] ACPI: Interpreter enabled
[    1.456180] ACPI: Interpreter enabled
[    1.456873] ACPI: (supports S0 S5)
[    1.456873] ACPI: (supports S0 S5)
[    1.457488] ACPI: Using IOAPIC for interrupt routing
[    1.457488] ACPI: Using IOAPIC for interrupt routing
[    1.458518] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.458518] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.468730] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.468730] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.470013] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    1.470013] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    1.471216] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.471216] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.472714] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.472714] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.474839] PCI host bridge to bus 0000:00
[    1.474839] PCI host bridge to bus 0000:00
[    1.475593] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.475593] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.476582] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.476582] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.477687] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.477687] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.478797] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.478797] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.480007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.480007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.481303] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.481303] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.483091] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.483091] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.484881] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.484881] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.489093] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.489093] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.491462] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.491462] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.492857] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.492857] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.494174] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.494174] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.495820] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.495820] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.500711] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.500711] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.504197] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.504197] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.512954] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.512954] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.514661] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.514661] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.516958] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.516958] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.519243] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.519243] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.527263] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.527263] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.529154] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.529154] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.531257] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.531257] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.533493] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.533493] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.541547] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.541547] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.543886] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.543886] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.546174] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.546174] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.553441] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.553441] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.555747] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.555747] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.557922] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.557922] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.565600] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.565600] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.567884] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.567884] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.570013] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.570013] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.577445] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.577445] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.579736] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.579736] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.581165] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.581165] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.588582] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.588582] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.591225] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.591225] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.593438] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.593438] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.601533] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.601533] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.603281] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.603281] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.608531] pci_bus 0000:00: on NUMA node 0
[    1.608531] pci_bus 0000:00: on NUMA node 0
[    1.610473] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.610473] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.611726] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.611726] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.613000] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.613000] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.614263] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.614263] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.615416] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.615416] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.617019] ACPI:=20
[    1.617019] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.617934] ACPI: \_SB_.PCI0: notify handler is installed
[    1.617934] ACPI: \_SB_.PCI0: notify handler is installed
[    1.619055] Found 1 acpi root devices
[    1.619055] Found 1 acpi root devices
[    1.620702] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.620702] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.622193] vgaarb: loaded
[    1.622193] vgaarb: loaded
[    1.622687] vgaarb: bridge control possible 0000:00:02.0
[    1.622687] vgaarb: bridge control possible 0000:00:02.0
[    1.625037] SCSI subsystem initialized
[    1.625037] SCSI subsystem initialized
[    1.625805] libata version 3.00 loaded.
[    1.625805] libata version 3.00 loaded.
[    1.626772] Linux video capture interface: v2.00
[    1.626772] Linux video capture interface: v2.00
[    1.627714] pps_core: LinuxPPS API ver. 1 registered
[    1.627714] pps_core: LinuxPPS API ver. 1 registered
[    1.628620] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.628620] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.630022] PTP clock support registered
[    1.630022] PTP clock support registered
[    1.630972] wmi: Mapper loaded
[    1.630972] wmi: Mapper loaded
[    1.631541] PCI: Using ACPI for IRQ routing
[    1.631541] PCI: Using ACPI for IRQ routing
[    1.632332] PCI: pci_cache_line_size set to 64 bytes
[    1.632332] PCI: pci_cache_line_size set to 64 bytes
[    1.633431] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.633431] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.634503] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.634503] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.636020] irda_init()
[    1.636020] irda_init()
[    1.636537] NET: Registered protocol family 23
[    1.636537] NET: Registered protocol family 23
[    1.637469] Bluetooth: Core ver 2.17
[    1.637469] Bluetooth: Core ver 2.17
[    1.638156] NET: Registered protocol family 31
[    1.638156] NET: Registered protocol family 31
[    1.638970] Bluetooth: HCI device and connection manager initialized
[    1.638970] Bluetooth: HCI device and connection manager initialized
[    1.640021] Bluetooth: HCI socket layer initialized
[    1.640021] Bluetooth: HCI socket layer initialized
[    1.640929] Bluetooth: L2CAP socket layer initialized
[    1.640929] Bluetooth: L2CAP socket layer initialized
[    1.641885] Bluetooth: SCO socket layer initialized
[    1.641885] Bluetooth: SCO socket layer initialized
[    1.644270] Switched to clocksource kvm-clock
[    1.644270] Switched to clocksource kvm-clock
[    1.724208] FS-Cache: Loaded
[    1.724208] FS-Cache: Loaded
[    1.725158] CacheFiles: Loaded
[    1.725158] CacheFiles: Loaded
[    1.726163] pnp: PnP ACPI init
[    1.726163] pnp: PnP ACPI init
[    1.727115] ACPI: bus type PNP registered
[    1.727115] ACPI: bus type PNP registered
[    1.728482] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.728482] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.730841] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.730841] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.732884] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.732884] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.735417] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.735417] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.737478] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.737478] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.740026] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.740026] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.742138] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.742138] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.744551] pnp 00:03: [dma 2]
[    1.744551] pnp 00:03: [dma 2]
[    1.745584] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.745584] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.747652] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.747652] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.750140] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.750140] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.752177] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.752177] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.754618] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.754618] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.757150] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.757150] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.759904] pnp: PnP ACPI: found 7 devices
[    1.759904] pnp: PnP ACPI: found 7 devices
[    1.761112] ACPI: bus type PNP unregistered
[    1.761112] ACPI: bus type PNP unregistered
[    1.798315] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.798315] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.799976] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.799976] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.801571] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.801571] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.803377] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.803377] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.805268] NET: Registered protocol family 1
[    1.805268] NET: Registered protocol family 1
[    1.806809] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.806809] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.808583] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.808583] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.810288] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.810288] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.812131] pci 0000:00:02.0: Boot video device
[    1.812131] pci 0000:00:02.0: Boot video device
[    1.813590] PCI: CLS 0 bytes, default 64
[    1.813590] PCI: CLS 0 bytes, default 64
[    1.815146] Trying to unpack rootfs image as initramfs...
[    1.815146] Trying to unpack rootfs image as initramfs...
[    1.818779] cfg80211: Calling CRDA to update world regulatory domain
[    1.818779] cfg80211: Calling CRDA to update world regulatory domain
[    1.996112] debug: unmapping init [mem 0x4fce4000-0x4ffeffff]
[    1.996112] debug: unmapping init [mem 0x4fce4000-0x4ffeffff]
[    1.999309] microcode: no support for this CPU vendor
[    1.999309] microcode: no support for this CPU vendor
[    2.002147] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.002147] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.005276] Initialise system trusted keyring
[    2.005276] Initialise system trusted keyring
[    2.013253] VFS: Disk quotas dquot_6.5.2
[    2.013253] VFS: Disk quotas dquot_6.5.2
[    2.014571] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.014571] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.017457] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.017457] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.019227] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.019227] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.020680] jffs2: version 2.2. (NAND)=20
[    2.020680] jffs2: version 2.2. (NAND)=20
[    2.022557] QNX6 filesystem 1.0.0 registered.
[    2.022557] QNX6 filesystem 1.0.0 registered.
[    2.025377] JFS: nTxBlock =3D 1751, nTxLock =3D 14008
[    2.025377] JFS: nTxBlock =3D 1751, nTxLock =3D 14008
[    2.030741] SGI XFS with ACLs, security attributes, no debug enabled
[    2.030741] SGI XFS with ACLs, security attributes, no debug enabled
[    2.033404] NILFS version 2 loaded
[    2.033404] NILFS version 2 loaded
[    2.034406] BeFS version: 0.9.3
[    2.034406] BeFS version: 0.9.3
[    2.035352] OCFS2 1.5.0
[    2.035352] OCFS2 1.5.0
[    2.037753] ocfs2: Registered cluster interface o2cb
[    2.037753] ocfs2: Registered cluster interface o2cb
[    2.039361] OCFS2 DLMFS 1.5.0
[    2.039361] OCFS2 DLMFS 1.5.0
[    2.040458] OCFS2 User DLM kernel interface loaded
[    2.040458] OCFS2 User DLM kernel interface loaded
[    2.041825] OCFS2 Node Manager 1.5.0
[    2.041825] OCFS2 Node Manager 1.5.0
[    2.044382] OCFS2 DLM 1.5.0
[    2.044382] OCFS2 DLM 1.5.0
[    2.045349] bio: create slab <bio-1> at 1
[    2.045349] bio: create slab <bio-1> at 1
[    2.047386] Btrfs loaded, debug=3Don
[    2.047386] Btrfs loaded, debug=3Don
[    2.048543] msgmni has been set to 437
[    2.048543] msgmni has been set to 437
[    2.070086] alg: No test for lz4 (lz4-generic)
[    2.070086] alg: No test for lz4 (lz4-generic)
[    2.071682] alg: No test for lz4hc (lz4hc-generic)
[    2.071682] alg: No test for lz4hc (lz4hc-generic)
[    2.073286] alg: No test for stdrng (krng)
[    2.073286] alg: No test for stdrng (krng)
[    2.082501] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    2.082501] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    2.084465] NET: Registered protocol family 38
[    2.084465] NET: Registered protocol family 38
[    2.085910] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.085910] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.088179] io scheduler noop registered
[    2.088179] io scheduler noop registered
[    2.089347] io scheduler cfq registered (default)
[    2.089347] io scheduler cfq registered (default)
[    2.090507] list_sort_test: start testing list_sort()
[    2.090507] list_sort_test: start testing list_sort()
[    2.093577] test_string_helpers: Running tests...
[    2.093577] test_string_helpers: Running tests...
[    2.095826] xz_dec_test: module loaded
[    2.095826] xz_dec_test: module loaded
[    2.096880] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    2.096880] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    2.101189] rbtree testing
[    2.101189] rbtree testing -> 15926 cycles
 -> 15926 cycles
[    2.684265] augmented rbtree testing
[    2.684265] augmented rbtree testing -> 20742 cycles
 -> 20742 cycles
[    3.446889] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.446889] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.448605] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.448605] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.452101] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.452101] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.453782] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.453782] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.457278] vmlfb: initializing
[    3.457278] vmlfb: initializing
[    3.458224] Could not find Carillo Ranch MCH device.
[    3.458224] Could not find Carillo Ranch MCH device.
[    3.926396] uvesafb:=20
[    3.926396] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 VGABIOS Cirrus extension, VGABIOS Cirrus extension, 1.0, 1.0, OEM: VGABIOS=
 Cirrus extension, OEM: VGABIOS Cirrus extension, VBE v2.0
VBE v2.0
[    3.932237] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    3.932237] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    3.934851] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    3.934851] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    3.937328] uvesafb: scrolling: redraw
[    3.937328] uvesafb: scrolling: redraw
[    3.939146] uvesafb: framebuffer at 0xfc000000, mapped to 0x50b00000, us=
ing 4096k, total 4096k
[    3.939146] uvesafb: framebuffer at 0xfc000000, mapped to 0x50b00000, us=
ing 4096k, total 4096k
[    3.941812] fb0: VESA VGA frame buffer device
[    3.941812] fb0: VESA VGA frame buffer device
[    3.944446] ipmi message handler version 39.2
[    3.944446] ipmi message handler version 39.2
[    3.945868] ipmi device interface
[    3.945868] ipmi device interface
[    3.947035] IPMI System Interface driver.
[    3.947035] IPMI System Interface driver.
[    3.948381] ipmi_si: Adding default-specified kcs state machine
[    3.948381] ipmi_si: Adding default-specified kcs state machine

[    3.950258] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.950258] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.953383] ipmi_si: Interface detection failed
[    3.953383] ipmi_si: Interface detection failed
[   11.865501] ipmi_si: Adding default-specified smic state machine
[   11.865501] ipmi_si: Adding default-specified smic state machine

[   11.867317] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   11.867317] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   11.870283] ipmi_si: Interface detection failed
[   11.870283] ipmi_si: Interface detection failed
[   11.895406] ipmi_si: Adding default-specified bt state machine
[   11.895406] ipmi_si: Adding default-specified bt state machine

[   11.897186] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.897186] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.900086] ipmi_si: Interface detection failed
[   11.900086] ipmi_si: Interface detection failed
[   11.905505] ipmi_si: Unable to find any System Interface(s)
[   11.905505] ipmi_si: Unable to find any System Interface(s)
[   11.907363] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.907363] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.909511] ACPI: Power Button [PWRF]
[   11.909511] ACPI: Power Button [PWRF]
[   11.911843] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   11.911843] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   11.915623] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   11.915623] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   11.917359] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   11.917359] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   11.923635] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   11.923635] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   11.925374] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[   11.925374] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[   11.932608] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   11.932608] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   11.950021] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   11.950021] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   12.020128] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   12.020128] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   12.044608] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   12.044608] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   12.048797] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   12.048797] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   12.050413] Non-volatile memory driver v1.3
[   12.050413] Non-volatile memory driver v1.3
[   12.051610] toshiba: not a supported Toshiba laptop
[   12.051610] toshiba: not a supported Toshiba laptop
[   12.052958] nsc_gpio initializing
[   12.052958] nsc_gpio initializing
[   12.053961] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   12.053961] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   12.056256] Hangcheck: Using getrawmonotonic().
[   12.056256] Hangcheck: Using getrawmonotonic().
[   12.058502] [drm] Initialized drm 1.1.0 20060810
[   12.058502] [drm] Initialized drm 1.1.0 20060810
[   12.059918] [drm] radeon kernel modesetting enabled.
[   12.059918] [drm] radeon kernel modesetting enabled.
[   12.061791] [drm:cirrus_vram_init] *ERROR* can't reserve VRAM
[   12.061791] [drm:cirrus_vram_init] *ERROR* can't reserve VRAM
[   12.063409] cirrus 0000:00:02.0: Fatal error during GPU init: -6
[   12.063409] cirrus 0000:00:02.0: Fatal error during GPU init: -6
[   12.064914] Trying to free nonexistent resource <00000000febf0000-000000=
00febf0fff>
[   12.064914] Trying to free nonexistent resource <00000000febf0000-000000=
00febf0fff>
[   12.069497] parport_pc 00:04: reported by Plug and Play ACPI
[   12.069497] parport_pc 00:04: reported by Plug and Play ACPI
[   12.071139] parport0: PC-style at 0x378
[   12.071139] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[   12.115335] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
[   12.115335] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
[   12.115335]  lock: slob_lock+0x0/0x20, .magic: dead4ead, .owner: rcuos/0=
/8, .owner_cpu: 1
[   12.115335]  lock: slob_lock+0x0/0x20, .magic: dead4ead, .owner: rcuos/0=
/8, .owner_cpu: 1
[   12.115335] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-00086-g=
efb753b #160
[   12.115335] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-00086-g=
efb753b #160
[   12.115335] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.115335] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.115335]  00000000
[   12.115335]  00000000 00000000 00000000 40109be8 40109be8 421d2d1c 421d2=
d1c 40115560 40115560 40109c14 40109c14 421cca9b 421cca9b 425a931c 425a931c

[   12.115335]  427cba60
[   12.115335]  427cba60 dead4ead dead4ead 4011575c 4011575c 00000008 00000=
008 00000001 00000001 427cba60 427cba60 ac6f8e00 ac6f8e00 00000000 00000000

[   12.115335]  40109c30
[   12.115335]  40109c30 41071419 41071419 ac6f8e00 ac6f8e00 00000000 00000=
000 427cba60 427cba60 00000212 00000212 000000de 000000de 40109c50 40109c50

[   12.115335] Call Trace:
[   12.115335] Call Trace:
[   12.115335]  [<421d2d1c>] dump_stack+0x48/0x60
[   12.115335]  [<421d2d1c>] dump_stack+0x48/0x60
[   12.115335]  [<421cca9b>] spin_dump+0x9a/0xa2
[   12.115335]  [<421cca9b>] spin_dump+0x9a/0xa2
[   12.115335]  [<41071419>] do_raw_spin_lock+0xb9/0x150
[   12.115335]  [<41071419>] do_raw_spin_lock+0xb9/0x150
[   12.115335]  [<421e6a08>] _raw_spin_lock_irqsave+0x58/0x70
[   12.115335]  [<421e6a08>] _raw_spin_lock_irqsave+0x58/0x70
[   12.115335]  [<410f955e>] ? slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] ? slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] slob_free+0x4e/0x3b0
[   12.115335]  [<410f9ef0>] kfree+0x70/0xb0
[   12.115335]  [<410f9ef0>] kfree+0x70/0xb0
[   12.115335]  [<418d1ee5>] ? parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] ? parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418cf795>] parport_unregister_device+0x35/0x140
[   12.115335]  [<418cf795>] parport_unregister_device+0x35/0x140
[   12.115335]  [<418cf688>] ? parport_release+0xa8/0x180
[   12.115335]  [<418cf688>] ? parport_release+0xa8/0x180
[   12.115335]  [<418cfe99>] ? parport_negotiate+0x169/0x340
[   12.115335]  [<418cfe99>] ? parport_negotiate+0x169/0x340
[   12.115335]  [<418d26ed>] parport_close+0xd/0x10
[   12.115335]  [<418d26ed>] parport_close+0xd/0x10
[   12.115335]  [<418d2e4e>] parport_device_id+0x6ae/0x700
[   12.115335]  [<418d2e4e>] parport_device_id+0x6ae/0x700
[   12.115335]  [<410f9b3d>] ? slob_alloc.isra.8+0x1cd/0x210
[   12.115335]  [<410f9b3d>] ? slob_alloc.isra.8+0x1cd/0x210
[   12.115335]  [<410f9bd8>] ? __kmalloc+0x58/0x180
[   12.115335]  [<410f9bd8>] ? __kmalloc+0x58/0x180
[   12.115335]  [<421e6af2>] ? _raw_spin_unlock+0x22/0x30
[   12.115335]  [<421e6af2>] ? _raw_spin_unlock+0x22/0x30
[   12.115335]  [<418d2519>] ? parport_daisy_init+0x319/0x400
[   12.115335]  [<418d2519>] ? parport_daisy_init+0x319/0x400
[   12.115335]  [<418d2531>] parport_daisy_init+0x331/0x400
[   12.115335]  [<418d2531>] parport_daisy_init+0x331/0x400
[   12.115335]  [<418cedd5>] parport_announce_port+0x15/0x150
[   12.115335]  [<418cedd5>] parport_announce_port+0x15/0x150
[   12.115335]  [<418d429d>] parport_pc_probe_port+0x82d/0x970
[   12.115335]  [<418d429d>] parport_pc_probe_port+0x82d/0x970
[   12.115335]  [<418d763d>] ? _dev_info+0x2d/0x30
[   12.115335]  [<418d763d>] ? _dev_info+0x2d/0x30
[   12.115335]  [<418d452d>] parport_pc_pnp_probe+0x14d/0x260
[   12.115335]  [<418d452d>] parport_pc_pnp_probe+0x14d/0x260
[   12.115335]  [<41690d81>] pnp_device_probe+0x91/0xd0
[   12.115335]  [<41690d81>] pnp_device_probe+0x91/0xd0
[   12.115335]  [<418d93ce>] really_probe+0xae/0x1c0
[   12.115335]  [<418d93ce>] really_probe+0xae/0x1c0
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<41690ba9>] ? match_device.isra.0+0x39/0x60
[   12.115335]  [<41690ba9>] ? match_device.isra.0+0x39/0x60
[   12.115335]  [<418d95ef>] __driver_attach+0x6f/0xa0
[   12.115335]  [<418d95ef>] __driver_attach+0x6f/0xa0
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d7bcc>] bus_for_each_dev+0x5c/0xb0
[   12.115335]  [<418d7bcc>] bus_for_each_dev+0x5c/0xb0
[   12.115335]  [<418d929e>] driver_attach+0x1e/0x20
[   12.115335]  [<418d929e>] driver_attach+0x1e/0x20
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d8467>] bus_add_driver+0xc7/0x200
[   12.115335]  [<418d8467>] bus_add_driver+0xc7/0x200
[   12.115335]  [<416908c0>] ? pnp_unregister_card_driver+0x40/0x40
[   12.115335]  [<416908c0>] ? pnp_unregister_card_driver+0x40/0x40
[   12.115335]  [<418d9bbf>] driver_register+0x8f/0xd0
[   12.115335]  [<418d9bbf>] driver_register+0x8f/0xd0
[   12.115335]  [<41690ddb>] pnp_register_driver+0x1b/0x20
[   12.115335]  [<41690ddb>] pnp_register_driver+0x1b/0x20
[   12.115335]  [<4295bff6>] parport_pc_init+0x27b/0x32f
[   12.115335]  [<4295bff6>] parport_pc_init+0x27b/0x32f
[   12.115335]  [<4295bd7b>] ? parport_setup+0x138/0x138
[   12.115335]  [<4295bd7b>] ? parport_setup+0x138/0x138
[   12.115335]  [<42916ad6>] do_one_initcall+0x82/0x10b
[   12.115335]  [<42916ad6>] do_one_initcall+0x82/0x10b
[   12.115335]  [<4291650e>] ? repair_env_string+0x12/0x51
[   12.115335]  [<4291650e>] ? repair_env_string+0x12/0x51
[   12.115335]  [<41051b4c>] ? parse_args+0x1ec/0x330
[   12.115335]  [<41051b4c>] ? parse_args+0x1ec/0x330
[   12.115335]  [<42916c42>] kernel_init_freeable+0xe3/0x187
[   12.115335]  [<42916c42>] kernel_init_freeable+0xe3/0x187
[   12.115335]  [<429164fc>] ? do_early_param+0x7a/0x7a
[   12.115335]  [<429164fc>] ? do_early_param+0x7a/0x7a
[   12.115335]  [<421c8c90>] kernel_init+0x10/0x100
[   12.115335]  [<421c8c90>] kernel_init+0x10/0x100
[   12.115335]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.115335]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.115335]  [<421c8c80>] ? rest_init+0xc0/0xc0
[   12.115335]  [<421c8c80>] ? rest_init+0xc0/0xc0
[   12.115335] sending NMI to all CPUs:
[   12.115335] sending NMI to all CPUs:
[   12.115335] NMI backtrace for cpu 0
[   12.115335] NMI backtrace for cpu 0
[   12.115335] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-00086-g=
efb753b #160
[   12.115335] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-00086-g=
efb753b #160
[   12.115335] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.115335] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.115335] task: 40017000 ti: 40108000 task.ti: 40108000
[   12.115335] task: 40017000 ti: 40108000 task.ti: 40108000
[   12.115335] EIP: 0060:[<41020480>] EFLAGS: 00010046 CPU: 0
[   12.115335] EIP: 0060:[<41020480>] EFLAGS: 00010046 CPU: 0
[   12.115335] EIP is at default_send_IPI_mask_logical+0xb0/0xc0
[   12.115335] EIP is at default_send_IPI_mask_logical+0xb0/0xc0
[   12.115335] EAX: 00000c00 EBX: 03000000 ECX: fffff000 EDX: fffff000
[   12.115335] EAX: 00000c00 EBX: 03000000 ECX: fffff000 EDX: fffff000
[   12.115335] ESI: 00000002 EDI: 00000006 EBP: 40109bf8 ESP: 40109be8
[   12.115335] ESI: 00000002 EDI: 00000006 EBP: 40109bf8 ESP: 40109be8
[   12.115335]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.115335]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.115335] CR0: 8005003b CR2: 08052680 CR3: 02a2a000 CR4: 00000690
[   12.115335] CR0: 8005003b CR2: 08052680 CR3: 02a2a000 CR4: 00000690
[   12.115335] Stack:
[   12.115335] Stack:
[   12.115335]  00000800
[   12.115335]  00000800 00002710 00002710 ac6f8e00 ac6f8e00 00000000 00000=
000 40109c04 40109c04 41020538 41020538 00002710 00002710 40109c14 40109c14

[   12.115335]  410207e2
[   12.115335]  410207e2 42597b00 42597b00 427cba60 427cba60 40109c30 40109=
c30 4107141e 4107141e ac6f8e00 ac6f8e00 00000000 00000000 427cba60 427cba60

[   12.115335]  00000212
[   12.115335]  00000212 000000de 000000de 40109c50 40109c50 421e6a08 421e6=
a08 00000000 00000000 00000001 00000001 00000000 00000000 410f955e 410f955e

[   12.115335] Call Trace:
[   12.115335] Call Trace:
[   12.115335]  [<41020538>] default_send_IPI_all+0x28/0x70
[   12.115335]  [<41020538>] default_send_IPI_all+0x28/0x70
[   12.115335]  [<410207e2>] arch_trigger_all_cpu_backtrace+0x42/0x80
[   12.115335]  [<410207e2>] arch_trigger_all_cpu_backtrace+0x42/0x80
[   12.115335]  [<4107141e>] do_raw_spin_lock+0xbe/0x150
[   12.115335]  [<4107141e>] do_raw_spin_lock+0xbe/0x150
[   12.115335]  [<421e6a08>] _raw_spin_lock_irqsave+0x58/0x70
[   12.115335]  [<421e6a08>] _raw_spin_lock_irqsave+0x58/0x70
[   12.115335]  [<410f955e>] ? slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] ? slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] slob_free+0x4e/0x3b0
[   12.115335]  [<410f955e>] slob_free+0x4e/0x3b0
[   12.115335]  [<410f9ef0>] kfree+0x70/0xb0
[   12.115335]  [<410f9ef0>] kfree+0x70/0xb0
[   12.115335]  [<418d1ee5>] ? parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] ? parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418d1ee5>] parport_device_proc_unregister+0x25/0x30
[   12.115335]  [<418cf795>] parport_unregister_device+0x35/0x140
[   12.115335]  [<418cf795>] parport_unregister_device+0x35/0x140
[   12.115335]  [<418cf688>] ? parport_release+0xa8/0x180
[   12.115335]  [<418cf688>] ? parport_release+0xa8/0x180
[   12.115335]  [<418cfe99>] ? parport_negotiate+0x169/0x340
[   12.115335]  [<418cfe99>] ? parport_negotiate+0x169/0x340
[   12.115335]  [<418d26ed>] parport_close+0xd/0x10
[   12.115335]  [<418d26ed>] parport_close+0xd/0x10
[   12.115335]  [<418d2e4e>] parport_device_id+0x6ae/0x700
[   12.115335]  [<418d2e4e>] parport_device_id+0x6ae/0x700
[   12.115335]  [<410f9b3d>] ? slob_alloc.isra.8+0x1cd/0x210
[   12.115335]  [<410f9b3d>] ? slob_alloc.isra.8+0x1cd/0x210
[   12.115335]  [<410f9bd8>] ? __kmalloc+0x58/0x180
[   12.115335]  [<410f9bd8>] ? __kmalloc+0x58/0x180
[   12.115335]  [<421e6af2>] ? _raw_spin_unlock+0x22/0x30
[   12.115335]  [<421e6af2>] ? _raw_spin_unlock+0x22/0x30
[   12.115335]  [<418d2519>] ? parport_daisy_init+0x319/0x400
[   12.115335]  [<418d2519>] ? parport_daisy_init+0x319/0x400
[   12.115335]  [<418d2531>] parport_daisy_init+0x331/0x400
[   12.115335]  [<418d2531>] parport_daisy_init+0x331/0x400
[   12.115335]  [<418cedd5>] parport_announce_port+0x15/0x150
[   12.115335]  [<418cedd5>] parport_announce_port+0x15/0x150
[   12.115335]  [<418d429d>] parport_pc_probe_port+0x82d/0x970
[   12.115335]  [<418d429d>] parport_pc_probe_port+0x82d/0x970
[   12.115335]  [<418d763d>] ? _dev_info+0x2d/0x30
[   12.115335]  [<418d763d>] ? _dev_info+0x2d/0x30
[   12.115335]  [<418d452d>] parport_pc_pnp_probe+0x14d/0x260
[   12.115335]  [<418d452d>] parport_pc_pnp_probe+0x14d/0x260
[   12.115335]  [<41690d81>] pnp_device_probe+0x91/0xd0
[   12.115335]  [<41690d81>] pnp_device_probe+0x91/0xd0
[   12.115335]  [<418d93ce>] really_probe+0xae/0x1c0
[   12.115335]  [<418d93ce>] really_probe+0xae/0x1c0
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<41690ba9>] ? match_device.isra.0+0x39/0x60
[   12.115335]  [<41690ba9>] ? match_device.isra.0+0x39/0x60
[   12.115335]  [<418d95ef>] __driver_attach+0x6f/0xa0
[   12.115335]  [<418d95ef>] __driver_attach+0x6f/0xa0
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d7bcc>] bus_for_each_dev+0x5c/0xb0
[   12.115335]  [<418d7bcc>] bus_for_each_dev+0x5c/0xb0
[   12.115335]  [<418d929e>] driver_attach+0x1e/0x20
[   12.115335]  [<418d929e>] driver_attach+0x1e/0x20
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d9580>] ? __device_attach+0x60/0x60
[   12.115335]  [<418d8467>] bus_add_driver+0xc7/0x200
[   12.115335]  [<418d8467>] bus_add_driver+0xc7/0x200
[   12.115335]  [<416908c0>] ? pnp_unregister_card_driver+0x40/0x40
[   12.115335]  [<416908c0>] ? pnp_unregister_card_driver+0x40/0x40
[   12.115335]  [<418d9bbf>] driver_register+0x8f/0xd0
[   12.115335]  [<418d9bbf>] driver_register+0x8f/0xd0
[   12.115335]  [<41690ddb>] pnp_register_driver+0x1b/0x20
[   12.115335]  [<41690ddb>] pnp_register_driver+0x1b/0x20
[   12.115335]  [<4295bff6>] parport_pc_init+0x27b/0x32f
[   12.115335]  [<4295bff6>] parport_pc_init+0x27b/0x32f
[   12.115335]  [<4295bd7b>] ? parport_setup+0x138/0x138
[   12.115335]  [<4295bd7b>] ? parport_setup+0x138/0x138
[   12.115335]  [<42916ad6>] do_one_initcall+0x82/0x10b
[   12.115335]  [<42916ad6>] do_one_initcall+0x82/0x10b
[   12.115335]  [<4291650e>] ? repair_env_string+0x12/0x51
[   12.115335]  [<4291650e>] ? repair_env_string+0x12/0x51
[   12.115335]  [<41051b4c>] ? parse_args+0x1ec/0x330
[   12.115335]  [<41051b4c>] ? parse_args+0x1ec/0x330
[   12.115335]  [<42916c42>] kernel_init_freeable+0xe3/0x187
[   12.115335]  [<42916c42>] kernel_init_freeable+0xe3/0x187
[   12.115335]  [<429164fc>] ? do_early_param+0x7a/0x7a
[   12.115335]  [<429164fc>] ? do_early_param+0x7a/0x7a
[   12.115335]  [<421c8c90>] kernel_init+0x10/0x100
[   12.115335]  [<421c8c90>] kernel_init+0x10/0x100
[   12.115335]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.115335]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.115335]  [<421c8c80>] ? rest_init+0xc0/0xc0
[   12.115335]  [<421c8c80>] ? rest_init+0xc0/0xc0
[   12.115335] Code:
[   12.115335] Code: ff ff f6 f6 c4 c4 10 10 75 75 ed ed c1 c1 e3 e3 18 18 =
89 89 99 99 10 10 c3 c3 ff ff ff ff 89 89 f0 f0 09 09 d0 d0 81 81 ca ca 00 =
00 04 04 00 00 00 00 83 83 fe fe 02 02 0f 0f 44 44 c2 c2 8b 8b 15 15 84 84 =
8c 8c 7b 7b 42 42 89 89 82 82 00 00 c3 c3 ff ff ff ff <89> <89> f8 f8 50 50=
 9d 9d 8d 8d 74 74 26 26 00 00 5b 5b 5b 5b 5e 5e 5f 5f 5d 5d c3 c3 66 66 90=
 90 55 55 89 89 e5 e5 53 53 3e 3e

[   12.080810] NMI backtrace for cpu 1
[   12.080810] NMI backtrace for cpu 1
[   12.115335] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 72.533 msecs
[   12.115335] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 72.533 msecs
[   12.080810] CPU: 1 PID: 8 Comm: rcuos/0 Not tainted 3.13.0-rc1-00086-gef=
b753b #160
[   12.080810] CPU: 1 PID: 8 Comm: rcuos/0 Not tainted 3.13.0-rc1-00086-gef=
b753b #160
[   12.080810] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.080810] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.080810] task: 40115560 ti: 40124000 task.ti: 40124000
[   12.080810] task: 40115560 ti: 40124000 task.ti: 40124000
[   12.080810] EIP: 0060:[<410f96d3>] EFLAGS: 00000002 CPU: 1
[   12.080810] EIP: 0060:[<410f96d3>] EFLAGS: 00000002 CPU: 1
[   12.080810] EIP is at slob_free+0x1c3/0x3b0
[   12.080810] EIP is at slob_free+0x1c3/0x3b0
[   12.080810] EAX: 4dac7000 EBX: 4dac7ca8 ECX: 00000001 EDX: 4dac7000
[   12.080810] EAX: 4dac7000 EBX: 4dac7ca8 ECX: 00000001 EDX: 4dac7000
[   12.080810] ESI: 4dac7000 EDI: 00000056 EBP: 40125eb0 ESP: 40125e94
[   12.080810] ESI: 4dac7000 EDI: 00000056 EBP: 40125eb0 ESP: 40125e94
[   12.080810]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.080810]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.080810] CR0: 8005003b CR2: 00000000 CR3: 02a2a000 CR4: 00000690
[   12.080810] CR0: 8005003b CR2: 00000000 CR3: 02a2a000 CR4: 00000690
[   12.080810] Stack:
[   12.080810] Stack:
[   12.080810]  40125eb8
[   12.080810]  40125eb8 000000ac 000000ac 00000206 00000206 00000056 00000=
056 4dac7cdc 4dac7cdc 4dac7ca8 4dac7ca8 4dac7ca8 4dac7ca8 40125ebc 40125ebc

[   12.080810]  410f98d6
[   12.080810]  410f98d6 4dac7cdc 4dac7cdc 40125ed4 40125ed4 410fa187 410fa=
187 40125edc 40125edc 4dac7cdc 4dac7cdc 4dac7ca8 4dac7ca8 4dac6c40 4dac6c40

[   12.080810]  40125ee4
[   12.080810]  40125ee4 4111535b 4111535b 4dac7d3c 4dac7d3c 0000000f 00000=
00f 40125f34 40125f34 4107ece2 4107ece2 40115560 40115560 40115560 40115560

[   12.080810] Call Trace:
[   12.080810] Call Trace:
[   12.080810]  [<410f98d6>] __kmem_cache_free+0x16/0x40
[   12.080810]  [<410f98d6>] __kmem_cache_free+0x16/0x40
[   12.080810]  [<410fa187>] kmem_cache_free+0x37/0x90
[   12.080810]  [<410fa187>] kmem_cache_free+0x37/0x90
[   12.080810]  [<4111535b>] __d_free+0x4b/0x60
[   12.080810]  [<4111535b>] __d_free+0x4b/0x60
[   12.080810]  [<4107ece2>] rcu_nocb_kthread+0x1e2/0x260
[   12.080810]  [<4107ece2>] rcu_nocb_kthread+0x1e2/0x260
[   12.080810]  [<4106a8c0>] ? __wake_up_common+0x80/0x80
[   12.080810]  [<4106a8c0>] ? __wake_up_common+0x80/0x80
[   12.080810]  [<4107eb00>] ? rcu_gp_kthread+0x630/0x630
[   12.080810]  [<4107eb00>] ? rcu_gp_kthread+0x630/0x630
[   12.080810]  [<410534c3>] kthread+0xb3/0xc0
[   12.080810]  [<410534c3>] kthread+0xb3/0xc0
[   12.080810]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.080810]  [<421e7eb7>] ret_from_kernel_thread+0x1b/0x28
[   12.080810]  [<41053410>] ? __kthread_unpark+0x50/0x50
[   12.080810]  [<41053410>] ? __kthread_unpark+0x50/0x50
[   12.080810] Code:
[   12.080810] Code: f0 f0 ff ff ff ff 85 85 d2 d2 79 79 11 11 89 89 d0 d0 =
f7 f7 d8 d8 98 98 eb eb 0e 0e 8d 8d 76 76 00 00 8d 8d bc bc 27 27 00 00 00 =
00 00 00 00 00 0f 0f bf bf 41 41 02 02 8d 8d 04 04 46 46 39 39 c3 c3 76 76 =
34 34 90 90 8d 8d 74 74 26 26 00 00 0f 0f bf bf 08 08 <89> <89> c6 c6 81 81=
 e6 e6 00 00 f0 f0 ff ff ff ff 85 85 c9 c9 79 79 11 11 89 89 ca ca f7 f7 da=
 da 0f 0f bf bf d2 d2 eb eb 0c 0c

[   12.080810] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 119.390 msecs
[   12.080810] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 119.390 msecs

Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
2-0105/efb753b8e0136fe66b507e8e1e42b5a2df7ba44d/vmlinuz-3.13.0-rc1-00086-ge=
fb753b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-te=
sts/run-queue/kvm/i386-randconfig-r2-0105/crypto:master/.vmlinuz-efb753b8e0=
136fe66b507e8e1e42b5a2df7ba44d-20140105213611-9-athens branch=3Dcrypto/mast=
er BOOT_IMAGE=3D/kernel/i386-randconfig-r2-0105/efb753b8e0136fe66b507e8e1e4=
2b5a2df7ba44d/vmlinuz-3.13.0-rc1-00086-gefb753b'  -initrd /kernel-tests/ini=
trd/yocto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::30870-:22 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yo=
cto-athens-27,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-=
yocto-athens-27,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
2-yocto-athens-27,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/di=
sk3-yocto-athens-27,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/=
disk4-yocto-athens-27,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKV=
M/disk5-yocto-athens-27,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pi=
d-yocto-athens-27 -serial file:/dev/shm/kboot/serial-yocto-athens-27 -daemo=
nize -display none -monitor null=20

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="i386-randconfig-r2-0105-efb753b8e0136fe66b507e8e1e42b5a2df7ba44d-BUG:-spinlock-lockup-suspected-on-CPU-8120.log"

git checkout 26b265cd29dde56bf0901c421eabc7ae815f38c4
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:26b265cd29dde56bf0901c421eabc7ae815f38c4:bisect-stable
 TEST FAILURE
[   12.526912] parport0: PC-style at 0x378
[   12.526912] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   14.045561] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/26b265cd29dde56bf0901c421eabc7ae815f38c4/dmesg-yocto-inn-39:20140105211220:i386-randconfig-r2-0105:3.13.0-rc1-00075-g26b265c:158
2:1:1 all_good:bad:all_bad boots

bisect: bad commit 26b265cd29dde56bf0901c421eabc7ae815f38c4
git checkout v3.12
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:bisect-stable

2014-01-11-21:06:02 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 compiling
630 real  2818 user  720 sys  561.35% cpu 	i386-randconfig-r2-0105

2014-01-11-21:19:36 detecting boot state 3.12.0....	1	2.	3	5...	7.	8.	11..	12	16	17	23..	25	29	31	34	39.	44.	48	49	51	52	53	54	55.	59	61	62	65	66....	71..	72..	86	88	92	95	96	100.	105	111	114.................................................................................................................	115 SUCCESS

bisect: good commit v3.12
git bisect start 26b265cd29dde56bf0901c421eabc7ae815f38c4 v3.12 --
/c/kernel-tests/linear-bisect: ["-b", "26b265cd29dde56bf0901c421eabc7ae815f38c4", "-g", "v3.12", "/c/kernel-tests/bisect-test-boot-failure.sh", "/home/wfg/stable/obj-bisect"]
Bisecting: 11431 revisions left to test after this (roughly 14 steps)
[7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b] Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b:bisect-stable

2014-01-11-22:49:51 7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b compiling
1256 real  2866 user  686 sys  282.82% cpu 	i386-randconfig-r2-0105

2014-01-11-23:14:18 detecting boot state 3.12.0-08317-g7e1a1e9....	4..	5.	6.	7	14	18	20	22.	23.	24	25	33	36	38..	39.	43	48	55	57	58	59..	65	73	75	79..	80	81.	82.	85	88	95	98	109	113....	114	115 SUCCESS

Bisecting: 3114 revisions left to test after this (roughly 12 steps)
[13509c3a9d20a9df93dc9b944e8bd20fe1b454a7] Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:13509c3a9d20a9df93dc9b944e8bd20fe1b454a7:bisect-stable

2014-01-11-23:43:54 13509c3a9d20a9df93dc9b944e8bd20fe1b454a7 compiling
612 real  2888 user  707 sys  586.74% cpu 	i386-randconfig-r2-0105

2014-01-11-23:54:39 detecting boot state 3.12.0-10526-g13509c3.....	2	3 TEST FAILURE
[   13.010427] parport0: PC-style at 0x378
[   13.010427] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   13.059447] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/13509c3a9d20a9df93dc9b944e8bd20fe1b454a7/dmesg-yocto-jaketown-13:20140111235744:i386-randconfig-r2-0105:3.12.0-10526-g13509c3:189
2:1:2 all_good:bad:all_bad boots

Bisecting: 2209 revisions left to test after this (roughly 12 steps)
[4937e2a6f939a41bf811378e80d71f68aa0950c6] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:4937e2a6f939a41bf811378e80d71f68aa0950c6:bisect-stable

2014-01-11-23:58:12 4937e2a6f939a41bf811378e80d71f68aa0950c6 compiling
846 real  2911 user  667 sys  422.99% cpu 	i386-randconfig-r2-0105

2014-01-12-00:13:33 detecting boot state 3.12.0-09827-g4937e2a.	2	3.	4 TEST FAILURE
[   12.298842] parport0: PC-style at 0x378
[   12.298842] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   12.346095] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/4937e2a6f939a41bf811378e80d71f68aa0950c6/dmesg-yocto-athens-17:20140112001527:i386-randconfig-r2-0105:3.12.0-09827-g4937e2a:190
1:1:4 all_good:bad:all_bad boots

Bisecting: 1510 revisions left to test after this (roughly 11 steps)
[049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8:bisect-stable

2014-01-12-00:16:07 049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8 compiling
721 real  2872 user  682 sys  492.60% cpu 	i386-randconfig-r2-0105

2014-01-12-00:30:38 detecting boot state 3.12.0-09579-g049ffa8a....	1.	5	6.	7	8	9	10..	12.	16	17	19	22	24....	27....	30.	33	38	39	45	49	50	53..	54.	55	56	58.	66	67	71	75.	80	82	83.	85	92	97	101	103	107	113..	115 SUCCESS

Bisecting: 248 revisions left to test after this (roughly 8 steps)
[98d38dd2ee30322fc9934d7490be3c5bee80950e] Merge tag 'for-3.13' of git://git.openrisc.net/~jonas/linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:98d38dd2ee30322fc9934d7490be3c5bee80950e:bisect-stable

2014-01-12-01:04:49 98d38dd2ee30322fc9934d7490be3c5bee80950e compiling
693 real  2876 user  718 sys  518.62% cpu 	i386-randconfig-r2-0105

2014-01-12-01:18:32 detecting boot state 3.12.0-09630-g98d38dd...	1	2.	3	4.	6	7	9	11.	22	31	33	39	44..	46.......	47	48	56	58.	61	63	66	67	69	71.	74	77...	78...	79...	83	87.	89	97	99	100	103	107.	111	112	115 SUCCESS

Bisecting: 197 revisions left to test after this (roughly 8 steps)
[f412f2c60b480fa5140a4b4cb321cd48c64e1812] Merge branch 'for-linus' of git://git.kernel.dk/linux-block
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:f412f2c60b480fa5140a4b4cb321cd48c64e1812:bisect-stable

2014-01-12-01:52:29 f412f2c60b480fa5140a4b4cb321cd48c64e1812 compiling
445 real  508 user  526 sys  232.28% cpu 	i386-randconfig-r2-0105

2014-01-12-02:04:32 detecting boot state 3.12.0-09699-gf412f2c.... TEST FAILURE
[   12.133837] parport0: PC-style at 0x378
[   12.133837] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   13.040156] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/f412f2c60b480fa5140a4b4cb321cd48c64e1812/dmesg-yocto-xian-34:20140112020612:i386-randconfig-r2-0105:3.12.0-09699-gf412f2c:193
0:1:1 all_good:bad:all_bad boots

Bisecting: 69 revisions left to test after this (roughly 7 steps)
[6c0514ddd973ff13c3d2b2e7ac1422c982afb8eb] Merge tag 'blackfin-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:6c0514ddd973ff13c3d2b2e7ac1422c982afb8eb:bisect-stable

2014-01-12-02:06:35 6c0514ddd973ff13c3d2b2e7ac1422c982afb8eb compiling
697 real  480 user  444 sys  132.62% cpu 	i386-randconfig-r2-0105

2014-01-12-02:20:18 detecting boot state 3.12.0-09639-g6c0514d.	1...	3.	6	8	12	14..	17	20	24	26	29	37	39	41	45	48	53	60	62	70	75	79	83	90.	93	96	97	101	104	106	112	113	114	115 SUCCESS

Bisecting: 60 revisions left to test after this (roughly 6 steps)
[cd1177f25069cb494680eedd718e7c6d8fd85d10] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:cd1177f25069cb494680eedd718e7c6d8fd85d10:bisect-stable

2014-01-12-02:41:31 cd1177f25069cb494680eedd718e7c6d8fd85d10 compiling
379 real  472 user  544 sys  268.01% cpu 	i386-randconfig-r2-0105

2014-01-12-02:49:25 detecting boot state 3.12.0-09641-gcd1177f2..	2	3	9 TEST FAILURE
[   13.134950] nbd: registered device at major 43
[   13.135202] FDC 0 is a S82078B
[   13.135202] FDC 0 is a S82078B
[   13.140445] BUG: unable to handle kernel 
/kernel/i386-randconfig-r2-0105/cd1177f25069cb494680eedd718e7c6d8fd85d10/dmesg-yocto-stoakley-2:20140112025137:i386-randconfig-r2-0105:3.12.0-09641-gcd1177f2:195
6:1:4 all_good:bad:all_bad boots

linear-bisect: bad branch may be branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
linear-bisect: handle over to git bisect
linear-bisect: git bisect start cd1177f25069cb494680eedd718e7c6d8fd85d10 6c0514ddd973ff13c3d2b2e7ac1422c982afb8eb --
Previous HEAD position was cd1177f2... Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
HEAD is now at 521cb40... Linux 2.6.38
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[a3483353ca4e6dbeef2ed62ebed01af109b5b27a] drm: check for !kdev in drm_unplug_minor()
linear-bisect: git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/stable/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:a3483353ca4e6dbeef2ed62ebed01af109b5b27a:bisect-stable

2014-01-12-02:52:38 a3483353ca4e6dbeef2ed62ebed01af109b5b27a compiling
1156 real  2866 user  716 sys  309.85% cpu 	i386-randconfig-r2-0105

2014-01-12-03:17:55 detecting boot state 3.12.0-00814-ga348335......	2	5.	8	9 TEST FAILURE
[   12.357795] parport0: PC-style at 0x378
[   12.357795] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   12.402864] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/a3483353ca4e6dbeef2ed62ebed01af109b5b27a/dmesg-yocto-athens-15:20140112032243:i386-randconfig-r2-0105:3.12.0-00814-ga348335:196
8:1:2 all_good:bad:all_bad boots

a3483353ca4e6dbeef2ed62ebed01af109b5b27a is the first bad commit
commit a3483353ca4e6dbeef2ed62ebed01af109b5b27a
Author: David Herrmann <dh.herrmann@gmail.com>
Date:   Wed Nov 13 11:42:26 2013 +0100

    drm: check for !kdev in drm_unplug_minor()
    
    We moved minor deallocation to drm_dev_free() in:
      commit 8f6599da8e772fa8de54cdf98e9e03cbaf3946da
      Author: David Herrmann <dh.herrmann@gmail.com>
      Date:   Sun Oct 20 18:55:45 2013 +0200
    
          drm: delay minor destruction to drm_dev_free()
    
    However, this causes a call to drm_unplug_minor(), which should just do
    nothing as drm_dev_unregister() already called this.
    
    But a separate patch caused kdev lifetime changes:
      commit 5bdebb183c9702a8c57a01dff09337be3de337a6
      Author: Dave Airlie <airlied@redhat.com>
      Date:   Fri Oct 11 14:07:25 2013 +1000
    
          drm/sysfs: sort out minor and connector device object lifetimes.
    
    Thus making our dev_is_registered() call useles (and even segfault if it
    is NULL). Replace it with a simple !kdev test and we're fine.
    
    Reported-by: Huax Lu <huax.lu@intel.com>
    Reported-by: Daniel Vetter <daniel@ffwll.ch>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71208
    Tested-by: lu hua <huax.lu@intel.com>
    Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
    Signed-off-by: Dave Airlie <airlied@gmail.com>

:040000 040000 320c08067884b101de3cb6185f1f0272fd58d72b c1dd8ca36c83b96bd8f97baddd52f64d433e36ca M	drivers
bisect run success
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:0846c728e20a0cd1e43fb75a3015f3b176a26466:bisect-stable

2014-01-12-03:23:32 0846c728e20a0cd1e43fb75a3015f3b176a26466 compiling

2014-01-12-03:33:59 detecting boot state 3.12.0-00813-g0846c72..	1...	3	7	9	10	16.....	18.	20	21	22	23	24..	27	29	31	32..	33.	35	37	40.	41	46.	48	49.	50..	52..	53	55	58	59	60	63	64.	65...	66.	68...	71..	72	73	75.	79	88	89	91	92	93	96.	97	99	112	113	117	119	120..	122	128	134	138..	141.	142....	143.	144.	146	147.	153	154.	155	156	163	165.	170	171	172..	173....	177.	179	181	183...........	184	185	187	189	196	202	206	210	212	214	216.	217	218..................	221	223.	226..	228...	229.	236	239	240	242	247	250	251.	252	253.	254.	260..	264................	265	266........	267..	268	269	270	273	274	277	283	285	286.	294	295	298	299...........	301	302	303	306	309	311.	314	317.....	318..	319.	320	321	323..	326	329..	333..	335	339..	340	342.	343..	344	345 SUCCESS

ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:efb753b8e0136fe66b507e8e1e42b5a2df7ba44d:bisect-stable
 TEST FAILURE
[   12.071139] parport0: PC-style at 0x378
[   12.071139] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRISTATE,TRISTATE]
]
[   12.115335] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
/kernel/i386-randconfig-r2-0105/efb753b8e0136fe66b507e8e1e42b5a2df7ba44d/dmesg-yocto-inn-41:20140111210431:i386-randconfig-r2-0105:3.13.0-rc1-00086-gefb753b:160
/kernel/i386-randconfig-r2-0105/efb753b8e0136fe66b507e8e1e42b5a2df7ba44d/dmesg-yocto-athens-27:20140105213955:i386-randconfig-r2-0105:3.13.0-rc1-00086-gefb753b:160
/kernel/i386-randconfig-r2-0105/efb753b8e0136fe66b507e8e1e42b5a2df7ba44d/dmesg-yocto-inn-20:20140111210539:i386-randconfig-r2-0105:3.13.0-rc1-00086-gefb753b:160
18:3:11 all_good:bad:all_bad boots

[detached HEAD cf0c16e] Revert "drm: check for !kdev in drm_unplug_minor()"
 1 file changed, 1 insertion(+), 1 deletion(-)
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:cf0c16eccacc7eaba6e710e553a7b5c0c39c6d70:bisect-stable

2014-01-12-06:05:52 cf0c16eccacc7eaba6e710e553a7b5c0c39c6d70 compiling

2014-01-12-06:16:21 detecting boot state 3.13.0-rc1-00087-gcf0c16e	3	7	8	9	14	15...	16	18	19	20	24	25.	26	28	29	31....	32...................................................................	33	37	38	41	44	45	48	50	55	57.	60..	61................	62	64.	66...	67.	68	69	70.	72	74	80	81	83	86.	90	92	96	99	103	104.	108	111	112..	114..........	115.	116.	120	121..	123....	124	125	129	135	136	137	138	141	144	145	147	149	151	153	154..	155	156...........	159..	162..	167	168	170	172	174	175	176.	177	180..........	181.	183	185.	186	187.	188	189	190	192	193	194	196.	200.	201	203	204	205	206...	208..	209..	211.	212...	213	214	215	216	221	223	225	228	229	230	232	234	235..	239..	240	241.....	243	246	249..	250	251	253	256	258...	263	264.	266	275	278	281	282	287	289	291	294	299	303	306.	307.	308	309	310....	311	312..	315....	316.	318	323.	325	327..	328...	329.	331.	333	335	338	342	344.	345 SUCCESS


========= upstream =========
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:228fdc083b017eaf90e578fa86fb1ecfd5ffae87:bisect-stable

2014-01-12-09:20:57 228fdc083b017eaf90e578fa86fb1ecfd5ffae87 compiling

2014-01-12-09:28:22 detecting boot state 3.13.0-rc7-00126-g228fdc0......	2.	4	6.	9.	12	14....	16	22	24	25	26...	36	40	43	52	54	58	59	67	72	76	80..........	84	90	91...	92.....	95	97	100	101...	102	105..........	110	111	115	117	120..........	121.	122	126	131	142	147.	148...	149	150.......	152.	153.	155	157	160	161	164	168	170	178	181......	182.	186	190	191	192	197.	198...	199	204	210	211	212......	213.	214..	215...	217	222	225	234..	237.	240	245	247	249	251	257	258	263	267	275	276	278...	285	286	288.	290	292	301	302...	303......	307	308.	309..	311	313	323..	328	333	336....	337	338.	342	345 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r2-0105/crypto:master:1955a14a5ba6e3c3b11117812d11dc550ccc37ae:bisect-stable

2014-01-12-11:24:29 1955a14a5ba6e3c3b11117812d11dc550ccc37ae compiling

2014-01-12-11:34:17 detecting boot state 3.13.0-rc7-next-20140110...	1	2	4	5..	7	8.	17	26	29	30	32..........	33	34	36	37..	38	41	42	46	48	49	52	60	65	67	73	78	82	84	89	90...	91	92	94	96	100	101	105.	106	109	110	115	117	118	119.	122	127	128..	130	131.	134	135	136	137...	142	151	154	155	158	161	163.	164	165	167	168....	170	171....	175	176	178	179.	180	184	188	189	198	205	210	216	228	237.	239	240.	245	256	258	260	268	269..	271.	276	277	278..	281	284.	286	291.	292	294	295	302	315	316	318	319.	324	328.	330..	331.	332	335	336.	337	340	345 SUCCESS


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-rc1-00086-gefb753b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.13.0-rc1 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
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
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
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
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
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
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
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
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
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
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
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
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
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
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
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
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
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
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
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
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
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
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

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
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
# CONFIG_SCSI_BFA_FC is not set
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
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
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
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_NTB_NETDEV is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
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
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_MLX5_CORE=y
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
CONFIG_SFC_MCDI_MON=y
# CONFIG_SFC_SRIOV is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
# CONFIG_STMMAC_PCI is not set
CONFIG_STMMAC_DEBUG_FS=y
# CONFIG_STMMAC_DA is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
CONFIG_PCMCIA_WL3501=y
CONFIG_PRISM54=y
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_TX99=y
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
# CONFIG_ATH6KL_DEBUG is not set
CONFIG_ATH6KL_TRACING=y
CONFIG_ATH6KL_REGDOMAIN=y
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCM_TRACING is not set
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=y
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_LIBERTAS=y
# CONFIG_LIBERTAS_CS is not set
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_SPI=y
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=y
CONFIG_HERMES_PRISM=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_WL_TI=y
CONFIG_MWIFIEX=y
# CONFIG_MWIFIEX_SDIO is not set
# CONFIG_MWIFIEX_PCIE is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

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
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

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
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

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
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
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
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
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
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
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
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCAP is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_DVB_CORE=y
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
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=y
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=y
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_BT848=y
# CONFIG_DVB_BT8XX is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
CONFIG_DVB_BUDGET_CI=y
# CONFIG_DVB_BUDGET_AV is not set
# CONFIG_DVB_BUDGET_PATCH is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_DM1105=y
CONFIG_DVB_PT1=y
CONFIG_MANTIS_CORE=y
# CONFIG_DVB_MANTIS is not set
# CONFIG_DVB_HOPPER is not set
# CONFIG_DVB_NGENE is not set
CONFIG_DVB_DDBRIDGE=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_MAXIRADIO=y
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_TIMBERDALE is not set
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_WM8775=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

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
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6421=y

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
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
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
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

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
CONFIG_NET_DMA=y
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
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_PANEL is not set
CONFIG_DX_SEP=y
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
CONFIG_WLAGS49_H2=y
# CONFIG_WLAGS49_H25 is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_CXD2099=y
CONFIG_VIDEO_DT3155=y
CONFIG_DT3155_CCIR=y
# CONFIG_DT3155_STREAMING is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_MTD_SPINAND_MT29F is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
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
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

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
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
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
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
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
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
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
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

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
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y

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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

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
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
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
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
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
CONFIG_CRC8=y
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
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--TB36FDmn/VVEgNH/--
