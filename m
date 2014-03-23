Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaCWAKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 20:10:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:57581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaCWAK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 20:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,711,1389772800"; 
   d="log'?scan'208";a="497622838"
Date: Sun, 23 Mar 2014 08:10:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [webcam] WARNING: CPU: 0 PID: 1 at
 drivers/media/v4l2-core/videobuf2-core.c:2207 vb2_queue_init()
Message-ID: <20140323001018.GA11963@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, the below WARNING has existed for 1 year and the first bad commit
is 240c3c3424366c8109babd2a0fe80855de511b35 ("Merge branch 'v4l_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media").
    
[    2.104371] g_webcam gadget: uvc_function_bind
[    2.105567] ------------[ cut here ]------------
[    2.105567] ------------[ cut here ]------------
[    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf2-core.c:2207 vb2_queue_init+0xa3/0x113()

git bisect start v3.10 v3.9 --
git bisect  bad ff89acc563a0bd49965674f56552ad6620415fe2  # 13:02      0-     15  Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu
git bisect  bad 24d0c2542b38963ae4d5171ecc0a2c1326c656bc  # 14:41      0-      1  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect  bad 151173e8ce9b95bbbbd7eedb9035cfaffbdb7cb2  # 15:16      0-      4  Merge tag 'for-v3.10' of git://git.infradead.org/battery-2.6
git bisect good 6c24499f40d96bf07a85b709fb1bee5cea611a1d  # 15:51     20+     20  tracing: Fix small merge bug
git bisect good 5a5a1bf099d6942399ea0b34a62e5f0bc4c5c36e  # 16:13     20+     20  Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad c9ef713993ba168b38d1a97ea0ab00874f1da022  # 16:46      0-      2  Merge tag 'arm64-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64
git bisect  bad 240c3c3424366c8109babd2a0fe80855de511b35  # 17:06      0-     18  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 5d434fcb255dec99189f1c58a06e4f56e12bf77d  # 17:18     20+     20  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good 19b344efa35dbc253e2d10403dafe6aafda73c56  # 17:28     20+     20  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good bae7432060960dd0ffdc4bd67986ac3d1f5733b0  # 19:25     20+     16  [media] go7007: add prio and control event support
git bisect good 82456708389d6d9eb81a4479d54efa0bf7dd8bf3  # 19:53     20+      1  [media] saa7134: v4l2-compliance: don't report invalid audio modes for radio
git bisect good b34f51fad396484e2bc102dcf95807b9990c3265  # 20:27     20+      1  [media] exynos4-is: Fix runtime PM handling on fimc-is probe error path
git bisect good 966a1601877c3d29065ab2dde838cdae16ccc099  # 20:53     20+      1  Merge branch 'topic/si476x' into patchwork
git bisect good 1f1988706d77083040113094a4bee2e9e1bdc34f  # 21:12     20+      3  [media] cx25821: setup output nodes correctly
git bisect good c82056d0b4ac7b805ac4e7d3870c42bb19e3b3d5  # 21:32     20+      0  [media] dib8000: store dtv_property_cache in a temp var
git bisect good a3f17af2d97a2a51af37e7b1dab5de5562c9b66d  # 22:36     20+      3  [media] cx25821-video: declare cx25821_vidioc_s_std as static
git bisect good 02615ed5e1b2283db2495af3cf8f4ee172c77d80  # 22:49     20+      1  [media] cx88: make core less verbose
git bisect good aad797c89903d570c17f6affc770eb98afd74e62  # 23:37     20+      0  Merge tag 'v3.9' into v4l_for_linus
git bisect good df90e2258950fd631cdbf322c1ee1f22068391aa  # 00:39     20+      0  Merge branch 'devel-for-v3.10' into v4l_for_linus
# first bad commit: [240c3c3424366c8109babd2a0fe80855de511b35] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 19b344efa35dbc253e2d10403dafe6aafda73c56  # 00:41     60+     80  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good df90e2258950fd631cdbf322c1ee1f22068391aa  # 00:44     60+      0  Merge branch 'devel-for-v3.10' into v4l_for_linus
git bisect  bad 0f2691c0856f6caa1825f2b307b0d786990c300b  # 00:44      0-     19  0day head guard for 'devel-hourly-2014032001'
git bisect  bad 887843961c4b4681ee993c36d4997bf4b4aa8253  # 01:19      0-     36  mm: fix bad rss-counter if remap_file_pages raced migration
git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 01:30      0-      6  Add linux-next specific files for 20140320

Thanks,
Fengguang

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-cairo-47:20140320033513:x86_64-randconfig-wa1-03200201:3.14.0-rc7-wl-ath-04452-g0f2691c:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.14.0-rc7-wl-ath-04452-g0f2691c (kbuild@waime=
a) (gcc version 4.8.2 (Debian 4.8.2-16) ) #3 Thu Mar 20 03:31:40 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-wa1-03200201/linux-devel=
:devel-hourly-2014032001/.vmlinuz-0f2691c0856f6caa1825f2b307b0d786990c300b-=
20140320033332-6-cairo branch=3Dlinux-devel/devel-hourly-2014032001 BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-wa1-03200201/0f2691c0856f6caa1825f2b307b0d7=
86990c300b/vmlinuz-3.14.0-rc7-wl-ath-04452-g0f2691c drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] NX (Execute Disable) protection: active
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024ea000, 0x024eafff] PGTABLE
[    0.000000] BRK [0x024eb000, 0x024ebfff] PGTABLE
[    0.000000] BRK [0x024ec000, 0x024ecfff] PGTABLE
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
[    0.000000] BRK [0x024ed000, 0x024edfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000000FFFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000000FFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000000FFFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x000000000FFFFF40 000040
[    0.000000] ACPI: SSDT 0x000000000FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000000FFFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000000FFFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
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
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1aa5440
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
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-wa1-03200201/linu=
x-devel:devel-hourly-2014032001/.vmlinuz-0f2691c0856f6caa1825f2b307b0d78699=
0c300b-20140320033332-6-cairo branch=3Dlinux-devel/devel-hourly-2014032001 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-wa1-03200201/0f2691c0856f6caa1825f2b=
307b0d786990c300b/vmlinuz-3.14.0-rc7-wl-ath-04452-g0f2691c drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 233060K/261744K available (7217K kernel code, 1386K =
rwdata, 3504K rodata, 776K init, 8516K bss, 28684K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
[    0.000000] Linux version 3.14.0-rc7-wl-ath-04452-g0f2691c (kbuild@waime=
a) (gcc version 4.8.2 (Debian 4.8.2-16) ) #3 Thu Mar 20 03:31:40 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-wa1-03200201/linux-devel=
:devel-hourly-2014032001/.vmlinuz-0f2691c0856f6caa1825f2b307b0d786990c300b-=
20140320033332-6-cairo branch=3Dlinux-devel/devel-hourly-2014032001 BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-wa1-03200201/0f2691c0856f6caa1825f2b307b0d7=
86990c300b/vmlinuz-3.14.0-rc7-wl-ath-04452-g0f2691c drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] NX (Execute Disable) protection: active
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024ea000, 0x024eafff] PGTABLE
[    0.000000] BRK [0x024eb000, 0x024ebfff] PGTABLE
[    0.000000] BRK [0x024ec000, 0x024ecfff] PGTABLE
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
[    0.000000] BRK [0x024ed000, 0x024edfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000000FFFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000000FFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000000FFFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x000000000FFFFF40 000040
[    0.000000] ACPI: SSDT 0x000000000FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000000FFFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000000FFFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
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
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1aa5440
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
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-wa1-03200201/linu=
x-devel:devel-hourly-2014032001/.vmlinuz-0f2691c0856f6caa1825f2b307b0d78699=
0c300b-20140320033332-6-cairo branch=3Dlinux-devel/devel-hourly-2014032001 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-wa1-03200201/0f2691c0856f6caa1825f2b=
307b0d786990c300b/vmlinuz-3.14.0-rc7-wl-ath-04452-g0f2691c drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 233060K/261744K available (7217K kernel code, 1386K =
rwdata, 3504K rodata, 776K init, 8516K bss, 28684K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
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
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.990 MHz processor
[    0.000000] tsc: Detected 2892.990 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D2892990)
5785.98 BogoMIPS (lpj=3D2892990)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.005054] ACPI: Core revision 20140214
[    0.005054] ACPI: Core revision 20140214
[    0.012155] ACPI:=20
[    0.012155] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.013180] Security Framework initialized
[    0.013180] Security Framework initialized
[    0.015007] Yama: becoming mindful.
[    0.015007] Yama: becoming mindful.
[    0.016042] Mount-cache hash table entries: 256
[    0.016042] Mount-cache hash table entries: 256
[    0.017418] mce: CPU supports 10 MCE banks
[    0.017418] mce: CPU supports 10 MCE banks
[    0.018011] mce: unknown CPU type - not enabling MCE support
[    0.018011] mce: unknown CPU type - not enabling MCE support
[    0.019010] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.019010] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.019010] tlb_flushall_shift: -1
[    0.019010] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.019010] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.019010] tlb_flushall_shift: -1
[    0.020009] CPU:=20
[    0.020009] CPU: GenuineIntel GenuineIntel Common KVM processorCommon KV=
M processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.027127] Performance Events:=20
[    0.027127] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.029588] Getting VERSION: 50014
[    0.029588] Getting VERSION: 50014
[    0.030016] Getting VERSION: 50014
[    0.030016] Getting VERSION: 50014
[    0.031015] Getting ID: 0
[    0.031015] Getting ID: 0
[    0.032021] Getting ID: ff000000
[    0.032021] Getting ID: ff000000
[    0.033019] Getting LVT0: 8700
[    0.033019] Getting LVT0: 8700
[    0.034012] Getting LVT1: 8400
[    0.034012] Getting LVT1: 8400
[    0.035087] enabled ExtINT on CPU#0
[    0.035087] enabled ExtINT on CPU#0
[    0.037610] ENABLING IO-APIC IRQs
[    0.037610] ENABLING IO-APIC IRQs
[    0.038011] init IO_APIC IRQs
[    0.038011] init IO_APIC IRQs
[    0.039021]  apic 0 pin 0 not connected
[    0.039021]  apic 0 pin 0 not connected
[    0.040020] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040020] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.041036] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041036] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.043033] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043033] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044030] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044030] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045032] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045032] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.046043] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.046043] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.047033] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.047033] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.048032] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.048032] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.049033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.049033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.050033] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.050033] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.051033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.051033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.052033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.052033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.053033] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.053033] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.054032] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.054032] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.055026]  apic 0 pin 16 not connected
[    0.055026]  apic 0 pin 16 not connected
[    0.056006]  apic 0 pin 17 not connected
[    0.056006]  apic 0 pin 17 not connected
[    0.057005]  apic 0 pin 18 not connected
[    0.057005]  apic 0 pin 18 not connected
[    0.058006]  apic 0 pin 19 not connected
[    0.058006]  apic 0 pin 19 not connected
[    0.059005]  apic 0 pin 20 not connected
[    0.059005]  apic 0 pin 20 not connected
[    0.060005]  apic 0 pin 21 not connected
[    0.060005]  apic 0 pin 21 not connected
[    0.061005]  apic 0 pin 22 not connected
[    0.061005]  apic 0 pin 22 not connected
[    0.062005]  apic 0 pin 23 not connected
[    0.062005]  apic 0 pin 23 not connected
[    0.063160] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.063160] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.064006] Using local APIC timer interrupts.
[    0.064006] calibrating APIC timer ...
[    0.064006] Using local APIC timer interrupts.
[    0.064006] calibrating APIC timer ...
[    0.066000] ... lapic delta =3D 6249481
[    0.066000] ... lapic delta =3D 6249481
[    0.066000] ... PM-Timer delta =3D 357908
[    0.066000] ... PM-Timer delta =3D 357908
[    0.066000] ... PM-Timer result ok
[    0.066000] ... PM-Timer result ok
[    0.066000] ..... delta 6249481
[    0.066000] ..... delta 6249481
[    0.066000] ..... mult: 268413165
[    0.066000] ..... mult: 268413165
[    0.066000] ..... calibration result: 999916
[    0.066000] ..... calibration result: 999916
[    0.066000] ..... CPU clock speed is 2892.0563 MHz.
[    0.066000] ..... CPU clock speed is 2892.0563 MHz.
[    0.066000] ..... host bus clock speed is 999.0916 MHz.
[    0.066000] ..... host bus clock speed is 999.0916 MHz.
[    0.068702] prandom: seed boundary self test passed
[    0.068702] prandom: seed boundary self test passed
[    0.070146] prandom: 100 self tests passed
[    0.070146] prandom: 100 self tests passed
[    0.072111] regulator-dummy: no parameters
[    0.072111] regulator-dummy: no parameters
[    0.073300] NET: Registered protocol family 16
[    0.073300] NET: Registered protocol family 16
[    0.075854] cpuidle: using governor ladder
[    0.075854] cpuidle: using governor ladder
[    0.076005] cpuidle: using governor menu
[    0.076005] cpuidle: using governor menu
[    0.078138] ACPI: bus type PCI registered
[    0.078138] ACPI: bus type PCI registered
[    0.079106] PCI: Using configuration type 1 for base access
[    0.079106] PCI: Using configuration type 1 for base access
[    0.102315] ACPI: Added _OSI(Module Device)
[    0.102315] ACPI: Added _OSI(Module Device)
[    0.103005] ACPI: Added _OSI(Processor Device)
[    0.103005] ACPI: Added _OSI(Processor Device)
[    0.104004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.104004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.105004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.105004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.118166] ACPI: Interpreter enabled
[    0.118166] ACPI: Interpreter enabled
[    0.119019] ACPI: (supports S0 S5)
[    0.119019] ACPI: (supports S0 S5)
[    0.120004] ACPI: Using IOAPIC for interrupt routing
[    0.120004] ACPI: Using IOAPIC for interrupt routing
[    0.121100] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.121100] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.141021] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.141021] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.142014] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.142014] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.143032] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.143032] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.144772] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.144772] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.147641] PCI host bridge to bus 0000:00
[    0.147641] PCI host bridge to bus 0000:00
[    0.149008] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.149008] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.150007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.150007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.151006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.151006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.152006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.152006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.153006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.153006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.154078] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.154078] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.156617] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.156617] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.158729] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.158729] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.164006] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.164006] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.166486] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.166486] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.167006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.167006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.168005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.168005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.169005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.169005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.171589] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.171589] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.173090] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.173090] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.174019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.174019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.176577] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.176577] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.179050] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.179050] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.183046] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.183046] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.194048] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.194048] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.196536] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.196536] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.199006] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.199006] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.202010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.202010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.212006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.212006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.214315] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.214315] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.217006] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.217006] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.220006] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.220006] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.231021] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.231021] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.233006] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.233006] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.236006] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.236006] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.246698] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.246698] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.249006] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.249006] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.252006] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.252006] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.262375] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.262375] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.265006] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.265006] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.267006] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.267006] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.278039] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.278039] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.280006] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.280006] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.283006] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.283006] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.293740] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.293740] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.296006] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.296006] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.299006] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.299006] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.309402] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.309402] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.311006] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.311006] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.318448] pci_bus 0000:00: on NUMA node 0
[    0.318448] pci_bus 0000:00: on NUMA node 0
[    0.321428] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.321428] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.323792] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.323792] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.325234] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.325234] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.327540] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.327540] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.328666] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.328666] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.330941] ACPI:=20
[    0.330941] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.333616] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.333616] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.334008] vgaarb: loaded
[    0.334008] vgaarb: loaded
[    0.335003] vgaarb: bridge control possible 0000:00:02.0
[    0.335003] vgaarb: bridge control possible 0000:00:02.0
[    0.338331] ACPI: bus type USB registered
[    0.338331] ACPI: bus type USB registered
[    0.339188] usbcore: registered new interface driver usbfs
[    0.339188] usbcore: registered new interface driver usbfs
[    0.340088] usbcore: registered new interface driver hub
[    0.340088] usbcore: registered new interface driver hub
[    0.341132] usbcore: registered new device driver usb
[    0.341132] usbcore: registered new device driver usb
[    0.342312] Linux video capture interface: v2.00
[    0.342312] Linux video capture interface: v2.00
[    0.343082] pps_core: LinuxPPS API ver. 1 registered
[    0.343082] pps_core: LinuxPPS API ver. 1 registered
[    0.344007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.344007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.345038] PTP clock support registered
[    0.345038] PTP clock support registered
[    0.346095] EDAC MC: Ver: 3.0.0
[    0.346095] EDAC MC: Ver: 3.0.0
[    0.348468] wmi: Mapper loaded
[    0.348468] wmi: Mapper loaded
[    0.349238] PCI: Using ACPI for IRQ routing
[    0.349238] PCI: Using ACPI for IRQ routing
[    0.350008] PCI: pci_cache_line_size set to 64 bytes
[    0.350008] PCI: pci_cache_line_size set to 64 bytes
[    0.352098] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.352098] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.353011] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.353011] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.355904] hpet0: at MMIO 0xfed00000, IRQs
[    0.355904] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.356407] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.356407] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.362020] Switched to clocksource kvm-clock
[    0.362020] Switched to clocksource kvm-clock
[    0.380008] pnp: PnP ACPI init
[    0.380008] pnp: PnP ACPI init
[    0.381172] ACPI: bus type PNP registered
[    0.381172] ACPI: bus type PNP registered
[    0.382659] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.382659] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.385628] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.385628] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.387918] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.387918] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.390763] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.390763] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.393051] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.393051] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.395944] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.395944] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.398267] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.398267] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.400903] pnp 00:03: [dma 2]
[    0.400903] pnp 00:03: [dma 2]
[    0.402133] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.402133] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.404442] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.404442] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.407222] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.407222] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.409527] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.409527] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.412342] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.412342] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.415292] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.415292] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.417952] pnp: PnP ACPI: found 7 devices
[    0.417952] pnp: PnP ACPI: found 7 devices
[    0.419315] ACPI: bus type PNP unregistered
[    0.419315] ACPI: bus type PNP unregistered
[    0.427318] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.427318] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.429182] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.429182] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.431025] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.431025] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.433096] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.433096] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.435470] NET: Registered protocol family 1
[    0.435470] NET: Registered protocol family 1
[    0.436982] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.436982] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.439000] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.439000] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.440976] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.440976] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.443089] pci 0000:00:02.0: Boot video device
[    0.443089] pci 0000:00:02.0: Boot video device
[    0.444725] PCI: CLS 0 bytes, default 64
[    0.444725] PCI: CLS 0 bytes, default 64
[    0.446935] Unpacking initramfs...
[    0.446935] Unpacking initramfs...
[    0.579646] Freeing initrd memory: 3112K (ffff88000fce6000 - ffff88000ff=
f0000)
[    0.579646] Freeing initrd memory: 3112K (ffff88000fce6000 - ffff88000ff=
f0000)
[    0.582827] microcode: no support for this CPU vendor
[    0.582827] microcode: no support for this CPU vendor
[    0.585185] cryptomgr_test (14) used greatest stack depth: 6672 bytes le=
ft
[    0.585185] cryptomgr_test (14) used greatest stack depth: 6672 bytes le=
ft
[    0.587936] cryptomgr_test (15) used greatest stack depth: 5792 bytes le=
ft
[    0.587936] cryptomgr_test (15) used greatest stack depth: 5792 bytes le=
ft
[    0.595917] cryptomgr_test (36) used greatest stack depth: 5624 bytes le=
ft
[    0.595917] cryptomgr_test (36) used greatest stack depth: 5624 bytes le=
ft
[    0.598616] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.598616] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.600763] PCLMULQDQ-NI instructions are not detected.
[    0.600763] PCLMULQDQ-NI instructions are not detected.
[    0.602591] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.602591] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.604752] AVX or AES-NI instructions are not detected.
[    0.604752] AVX or AES-NI instructions are not detected.
[    0.606572] AVX instructions are not detected.
[    0.606572] AVX instructions are not detected.
[    0.608089] AVX instructions are not detected.
[    0.608089] AVX instructions are not detected.
[    0.609617] AVX instructions are not detected.
[    0.609617] AVX instructions are not detected.
[    0.611154] AVX2 or AES-NI instructions are not detected.
[    0.611154] AVX2 or AES-NI instructions are not detected.
[    0.613012] AVX2 instructions are not detected.
[    0.613012] AVX2 instructions are not detected.
[    0.616216] Initializing RT-Tester: OK
[    0.616216] Initializing RT-Tester: OK
[    0.618550] futex hash table entries: 256 (order: 2, 18432 bytes)
[    0.618550] futex hash table entries: 256 (order: 2, 18432 bytes)
[    0.623720] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.623720] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.625342] fuse init (API version 7.22)
[    0.625342] fuse init (API version 7.22)
[    0.626900] msgmni has been set to 461
[    0.626900] msgmni has been set to 461
[    0.634413] alg: No test for crc32 (crc32-table)
[    0.634413] alg: No test for crc32 (crc32-table)
[    0.636303] alg: No test for lz4 (lz4-generic)
[    0.636303] alg: No test for lz4 (lz4-generic)
[    0.637933] alg: No test for stdrng (krng)
[    0.637933] alg: No test for stdrng (krng)
[    0.639357] list_sort_test: start testing list_sort()
[    0.639357] list_sort_test: start testing list_sort()
[    0.642278] xz_dec_test: module loaded
[    0.642278] xz_dec_test: module loaded
[    0.643613] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    0.643613] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    0.646875] rbtree testing
[    0.646875] rbtree testing -> 15219 cycles
 -> 15219 cycles
[    1.220377] augmented rbtree testing
[    1.220377] augmented rbtree testing -> 17878 cycles
 -> 17878 cycles
[    1.885876] nvidiafb_setup START
[    1.885876] nvidiafb_setup START
[    1.886998] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.886998] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.889607] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.889607] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.892269] usbcore: registered new interface driver udlfb
[    1.892269] usbcore: registered new interface driver udlfb
[    1.893732] usbcore: registered new interface driver smscufx
[    1.893732] usbcore: registered new interface driver smscufx
[    1.895537] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.895537] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.897469] ACPI: Power Button [PWRF]
[    1.897469] ACPI: Power Button [PWRF]
[    1.900027] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.900027] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.901546] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.901546] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.905999] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.905999] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.907428] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.907428] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.912076] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.912076] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.916501] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.916501] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.975294] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.975294] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.999543] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.999543] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.002581] Non-volatile memory driver v1.3
[    2.002581] Non-volatile memory driver v1.3
[    2.004316] Linux agpgart interface v0.103
[    2.004316] Linux agpgart interface v0.103
[    2.006188] [drm] Initialized drm 1.1.0 20060810
[    2.006188] [drm] Initialized drm 1.1.0 20060810
[    2.007773] usbcore: registered new interface driver udl
[    2.007773] usbcore: registered new interface driver udl
[    2.009690] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    2.009690] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    2.013638] intelfb: Version 0.9.6
[    2.013638] intelfb: Version 0.9.6
[    2.015263] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.015263] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.017975] dummy-irq: no IRQ given.  Use irq=3DN
[    2.017975] dummy-irq: no IRQ given.  Use irq=3DN
[    2.020057] Phantom Linux Driver, version n0.9.8, init OK
[    2.020057] Phantom Linux Driver, version n0.9.8, init OK
[    2.022701] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.022701] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.026064] mic_init not running on X100 ret -19
[    2.026064] mic_init not running on X100 ret -19
[    2.027984] usbcore: registered new interface driver rtsx_usb
[    2.027984] usbcore: registered new interface driver rtsx_usb
[    2.030037] usbcore: registered new interface driver viperboard
[    2.030037] usbcore: registered new interface driver viperboard
[    2.031842] device id =3D 2440
[    2.031842] device id =3D 2440
[    2.032600] device id =3D 2480
[    2.032600] device id =3D 2480
[    2.033267] device id =3D 24c0
[    2.033267] device id =3D 24c0
[    2.033911] device id =3D 24d0
[    2.033911] device id =3D 24d0
[    2.034582] device id =3D 25a1
[    2.034582] device id =3D 25a1
[    2.035247] device id =3D 2670
[    2.035247] device id =3D 2670
[    2.035972] platform physmap-flash.0: failed to claim resource 0
[    2.035972] platform physmap-flash.0: failed to claim resource 0
[    2.037617] slram: not enough parameters.
[    2.037617] slram: not enough parameters.
[    2.038595] tsc: Refined TSC clocksource calibration: 2892.981 MHz
[    2.038595] tsc: Refined TSC clocksource calibration: 2892.981 MHz
[    2.040760] usbcore: registered new interface driver hwa-rc
[    2.040760] usbcore: registered new interface driver hwa-rc
[    2.042085] usbcore: registered new interface driver i1480-dfu-usb
[    2.042085] usbcore: registered new interface driver i1480-dfu-usb
[    2.043758] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.043758] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.045310] ohci-pci: OHCI PCI platform driver
[    2.045310] ohci-pci: OHCI PCI platform driver
[    2.046404] uhci_hcd: USB Universal Host Controller Interface driver
[    2.046404] uhci_hcd: USB Universal Host Controller Interface driver
[    2.047955] driver u132_hcd
[    2.047955] driver u132_hcd
[    2.048817] usbcore: registered new interface driver hwa-hc
[    2.048817] usbcore: registered new interface driver hwa-hc
[    2.050262] usbcore: registered new interface driver wusb-cbaf
[    2.050262] usbcore: registered new interface driver wusb-cbaf
[    2.051826] usbcore: registered new interface driver cdc_wdm
[    2.051826] usbcore: registered new interface driver cdc_wdm
[    2.053252] usbcore: registered new interface driver mdc800
[    2.053252] usbcore: registered new interface driver mdc800
[    2.054604] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.054604] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.056554] usbcore: registered new interface driver appledisplay
[    2.056554] usbcore: registered new interface driver appledisplay
[    2.058116] usbcore: registered new interface driver cypress_cy7c63
[    2.058116] usbcore: registered new interface driver cypress_cy7c63
[    2.059713] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    2.059713] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    2.061487] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    2.061487] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    2.063172] driver ftdi-elan
[    2.063172] driver ftdi-elan
[    2.064142] usbcore: registered new interface driver ftdi-elan
[    2.064142] usbcore: registered new interface driver ftdi-elan
[    2.065712] usbcore: registered new interface driver iowarrior
[    2.065712] usbcore: registered new interface driver iowarrior
[    2.067260] usbcore: registered new interface driver isight_firmware
[    2.067260] usbcore: registered new interface driver isight_firmware
[    2.068947] usbcore: registered new interface driver usblcd
[    2.068947] usbcore: registered new interface driver usblcd
[    2.070453] usbcore: registered new interface driver usbled
[    2.070453] usbcore: registered new interface driver usbled
[    2.071946] usbcore: registered new interface driver legousbtower
[    2.071946] usbcore: registered new interface driver legousbtower
[    2.073578] usbcore: registered new interface driver rio500
[    2.073578] usbcore: registered new interface driver rio500
[    2.075069] usbcore: registered new interface driver usbtest
[    2.075069] usbcore: registered new interface driver usbtest
[    2.076580] usbcore: registered new interface driver usb_ehset_test
[    2.076580] usbcore: registered new interface driver usb_ehset_test
[    2.078235] usbcore: registered new interface driver usbsevseg
[    2.078235] usbcore: registered new interface driver usbsevseg
[    2.079807] usbcore: registered new interface driver yurex
[    2.079807] usbcore: registered new interface driver yurex
[    2.081332] usbcore: registered new interface driver sisusb
[    2.081332] usbcore: registered new interface driver sisusb
[    2.083303] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    2.083303] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    2.085104] dummy_hcd dummy_hcd.0: Dummy host controller
[    2.085104] dummy_hcd dummy_hcd.0: Dummy host controller
[    2.086347] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    2.086347] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    2.088199] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.088199] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.089876] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.089876] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.091601] usb usb1: Product: Dummy host controller
[    2.091601] usb usb1: Product: Dummy host controller
[    2.092831] usb usb1: Manufacturer: Linux 3.14.0-rc7-wl-ath-04452-g0f269=
1c dummy_hcd
[    2.092831] usb usb1: Manufacturer: Linux 3.14.0-rc7-wl-ath-04452-g0f269=
1c dummy_hcd
[    2.094685] usb usb1: SerialNumber: dummy_hcd.0
[    2.094685] usb usb1: SerialNumber: dummy_hcd.0
[    2.096261] hub 1-0:1.0: USB hub found
[    2.096261] hub 1-0:1.0: USB hub found
[    2.097249] hub 1-0:1.0: 1 port detected
[    2.097249] hub 1-0:1.0: 1 port detected
[    2.099248] udc dummy_udc.0: registering UDC driver [g_webcam]
[    2.099248] udc dummy_udc.0: registering UDC driver [g_webcam]
[    2.100648] g_webcam gadget: adding config #1 'Video'/ffffffff81b5be70
[    2.100648] g_webcam gadget: adding config #1 'Video'/ffffffff81b5be70
[    2.102309] g_webcam gadget: adding 'uvc'/ffff88000e2b5140 to config 'Vi=
deo'/ffffffff81b5be70
[    2.102309] g_webcam gadget: adding 'uvc'/ffff88000e2b5140 to config 'Vi=
deo'/ffffffff81b5be70
[    2.104371] g_webcam gadget: uvc_function_bind
[    2.104371] g_webcam gadget: uvc_function_bind
[    2.105567] ------------[ cut here ]------------
[    2.105567] ------------[ cut here ]------------
[    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf2-=
core.c:2207 vb2_queue_init+0xa3/0x113()
[    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf2-=
core.c:2207 vb2_queue_init+0xa3/0x113()
[    2.109891] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-wl-ath-04=
452-g0f2691c #3
[    2.109891] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-wl-ath-04=
452-g0f2691c #3
[    2.111879]  0000000000000000
[    2.111879]  0000000000000000 ffff88000f857c58 ffff88000f857c58 ffffffff=
816ff5b7 ffffffff816ff5b7 ffff88000f857c90 ffff88000f857c90

[    2.113819]  ffffffff81078769
[    2.113819]  ffffffff81078769 ffffffff815c294f ffffffff815c294f ffff8800=
0e2b52a8 ffff88000e2b52a8 ffff88000e297780 ffff88000e297780

[    2.115757]  ffff88000e2b5000
[    2.115757]  ffff88000e2b5000 0000000000000000 0000000000000000 ffff8800=
0f857ca0 ffff88000f857ca0 ffffffff81078858 ffffffff81078858

[    2.117660] Call Trace:
[    2.117660] Call Trace:
[    2.118313]  [<ffffffff816ff5b7>] dump_stack+0x19/0x1b
[    2.118313]  [<ffffffff816ff5b7>] dump_stack+0x19/0x1b
[    2.119629]  [<ffffffff81078769>] warn_slowpath_common+0x73/0x8c
[    2.119629]  [<ffffffff81078769>] warn_slowpath_common+0x73/0x8c
[    2.121150]  [<ffffffff815c294f>] ? vb2_queue_init+0xa3/0x113
[    2.121150]  [<ffffffff815c294f>] ? vb2_queue_init+0xa3/0x113
[    2.122606]  [<ffffffff81078858>] warn_slowpath_null+0x1a/0x1c
[    2.122606]  [<ffffffff81078858>] warn_slowpath_null+0x1a/0x1c
[    2.124074]  [<ffffffff815c294f>] vb2_queue_init+0xa3/0x113
[    2.124074]  [<ffffffff815c294f>] vb2_queue_init+0xa3/0x113
[    2.125666]  [<ffffffff81c0c223>] uvc_function_bind+0x3cc/0x54b
[    2.125666]  [<ffffffff81c0c223>] uvc_function_bind+0x3cc/0x54b
[    2.127176]  [<ffffffff81512924>] usb_add_function+0x94/0x169
[    2.127176]  [<ffffffff81512924>] usb_add_function+0x94/0x169
[    2.128584]  [<ffffffff81c0c581>] uvc_bind_config+0x1df/0x221
[    2.128584]  [<ffffffff81c0c581>] uvc_bind_config+0x1df/0x221
[    2.130046]  [<ffffffff81c0c5c3>] ? uvc_bind_config+0x221/0x221
[    2.130046]  [<ffffffff81c0c5c3>] ? uvc_bind_config+0x221/0x221
[    2.131544]  [<ffffffff81c0c5ef>] webcam_config_bind+0x2c/0x2e
[    2.131544]  [<ffffffff81c0c5ef>] webcam_config_bind+0x2c/0x2e
[    2.133042]  [<ffffffff81512c71>] usb_add_config+0x6a/0x22f
[    2.133042]  [<ffffffff81512c71>] usb_add_config+0x6a/0x22f
[    2.134451]  [<ffffffff8114400c>] ? sysfs_create_file_ns+0x2c/0x2e
[    2.134451]  [<ffffffff8114400c>] ? sysfs_create_file_ns+0x2c/0x2e
[    2.136029]  [<ffffffff8140deac>] ? device_create_file+0x42/0x8b
[    2.136029]  [<ffffffff8140deac>] ? device_create_file+0x42/0x8b
[    2.137537]  [<ffffffff81c0be2a>] webcam_bind+0x52/0x7f
[    2.137537]  [<ffffffff81c0be2a>] webcam_bind+0x52/0x7f
[    2.138881]  [<ffffffff8151337b>] composite_bind+0x96/0x167
[    2.138881]  [<ffffffff8151337b>] composite_bind+0x96/0x167
[    2.140282]  [<ffffffff81510580>] udc_bind_to_driver+0x5b/0xf5
[    2.140282]  [<ffffffff81510580>] udc_bind_to_driver+0x5b/0xf5
[    2.141750]  [<ffffffff81510dbc>] usb_gadget_probe_driver+0x92/0xac
[    2.141750]  [<ffffffff81510dbc>] usb_gadget_probe_driver+0x92/0xac
[    2.143342]  [<ffffffff81c0bdc6>] ? uvc_copy_descriptors+0x2d3/0x2d3
[    2.143342]  [<ffffffff81c0bdc6>] ? uvc_copy_descriptors+0x2d3/0x2d3
[    2.144914]  [<ffffffff815134d5>] usb_composite_probe+0x89/0x91
[    2.144914]  [<ffffffff815134d5>] usb_composite_probe+0x89/0x91
[    2.146414]  [<ffffffff81c0bdd6>] webcam_init+0x10/0x12
[    2.146414]  [<ffffffff81c0bdd6>] webcam_init+0x10/0x12
[    2.147758]  [<ffffffff81bd7eca>] do_one_initcall+0x7d/0x111
[    2.147758]  [<ffffffff81bd7eca>] do_one_initcall+0x7d/0x111
[    2.149172]  [<ffffffff81090e91>] ? parse_args+0x189/0x249
[    2.149172]  [<ffffffff81090e91>] ? parse_args+0x189/0x249
[    2.150536]  [<ffffffff81bd8056>] kernel_init_freeable+0xf8/0x178
[    2.150536]  [<ffffffff81bd8056>] kernel_init_freeable+0xf8/0x178
[    2.152028]  [<ffffffff81bd7763>] ? do_early_param+0x88/0x88
[    2.152028]  [<ffffffff81bd7763>] ? do_early_param+0x88/0x88
[    2.153412]  [<ffffffff816fa741>] ? rest_init+0xc5/0xc5
[    2.153412]  [<ffffffff816fa741>] ? rest_init+0xc5/0xc5
[    2.154714]  [<ffffffff816fa74f>] kernel_init+0xe/0xd5
[    2.154714]  [<ffffffff816fa74f>] kernel_init+0xe/0xd5
[    2.155996]  [<ffffffff81708c4a>] ret_from_fork+0x7a/0xb0
[    2.155996]  [<ffffffff81708c4a>] ret_from_fork+0x7a/0xb0
[    2.157342]  [<ffffffff816fa741>] ? rest_init+0xc5/0xc5
[    2.157342]  [<ffffffff816fa741>] ? rest_init+0xc5/0xc5
[    2.158635] ---[ end trace 9ef58d8930b0e80a ]---
[    2.158635] ---[ end trace 9ef58d8930b0e80a ]---
[    2.159932] g_webcam gadget: cfg 1/ffffffff81b5be70 speeds: super high f=
ull
[    2.159932] g_webcam gadget: cfg 1/ffffffff81b5be70 speeds: super high f=
ull
[    2.161639] g_webcam gadget:   interface 0 =3D uvc/ffff88000e2b5140
[    2.161639] g_webcam gadget:   interface 0 =3D uvc/ffff88000e2b5140
[    2.163125] g_webcam gadget:   interface 1 =3D uvc/ffff88000e2b5140
[    2.163125] g_webcam gadget:   interface 1 =3D uvc/ffff88000e2b5140
[    2.164648] g_webcam gadget: Webcam Video Gadget
[    2.164648] g_webcam gadget: Webcam Video Gadget
[    2.165752] g_webcam gadget: g_webcam ready
[    2.165752] g_webcam gadget: g_webcam ready
[    2.166783] dummy_udc dummy_udc.0: binding gadget driver 'g_webcam'
[    2.166783] dummy_udc dummy_udc.0: binding gadget driver 'g_webcam'
[    2.168305] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    2.168305] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    2.170704] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    2.170704] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    2.172403] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.172403] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.175169] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.175169] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.176444] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.176444] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.178077] mousedev: PS/2 mouse device common for all mice
[    2.178077] mousedev: PS/2 mouse device common for all mice
[    2.179603] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.179603] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.181598] usbcore: registered new interface driver appletouch
[    2.181598] usbcore: registered new interface driver appletouch
[    2.183106] usbcore: registered new interface driver bcm5974
[    2.183106] usbcore: registered new interface driver bcm5974
[    2.184664] usbcore: registered new interface driver usb_acecad
[    2.184664] usbcore: registered new interface driver usb_acecad
[    2.186120] usbcore: registered new interface driver gtco
[    2.186120] usbcore: registered new interface driver gtco
[    2.187476] usbcore: registered new interface driver hanwang
[    2.187476] usbcore: registered new interface driver hanwang
[    2.188946] usbcore: registered new interface driver wacom
[    2.188946] usbcore: registered new interface driver wacom
[    2.190912] mk712: device not present
[    2.190912] mk712: device not present
[    2.191889] usbcore: registered new interface driver usbtouchscreen
[    2.191889] usbcore: registered new interface driver usbtouchscreen
[    2.193580] usbcore: registered new interface driver sur40
[    2.193580] usbcore: registered new interface driver sur40
[    2.195395] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.195395] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.196995] usbcore: registered new interface driver ati_remote2
[    2.196995] usbcore: registered new interface driver ati_remote2
[    2.198705] usbcore: registered new interface driver keyspan_remote
[    2.198705] usbcore: registered new interface driver keyspan_remote
[    2.200384] usbcore: registered new interface driver powermate
[    2.200384] usbcore: registered new interface driver powermate
[    2.202113] usbcore: registered new interface driver yealink
[    2.202113] usbcore: registered new interface driver yealink
[    2.203505] I2O subsystem v1.325
[    2.203505] I2O subsystem v1.325
[    2.204314] i2o: max drivers =3D 8
[    2.204314] i2o: max drivers =3D 8
[    2.205904] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.205904] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.208162] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.208162] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.211106] I2O Configuration OSM v1.323
[    2.211106] I2O Configuration OSM v1.323
[    2.212130] I2O Bus Adapter OSM v1.317
[    2.212130] I2O Bus Adapter OSM v1.317
[    2.213127] I2O ProcFS OSM v1.316
[    2.213127] I2O ProcFS OSM v1.316
[    2.215246] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.215246] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.217062] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.217062] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.218790] i2c /dev entries driver
[    2.218790] i2c /dev entries driver
[    2.220069] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.220069] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.222294] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    2.222294] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    2.250583] usbcore: registered new interface driver i2c-diolan-u2c
[    2.250583] usbcore: registered new interface driver i2c-diolan-u2c
[    2.252533] usbcore: registered new interface driver i2c-tiny-usb
[    2.252533] usbcore: registered new interface driver i2c-tiny-usb
[    2.255833] usbcore: registered new interface driver radioshark
[    2.255833] usbcore: registered new interface driver radioshark
[    2.257678] usbcore: registered new interface driver dsbr100
[    2.257678] usbcore: registered new interface driver dsbr100
[    2.259464] usbcore: registered new interface driver radio-mr800
[    2.259464] usbcore: registered new interface driver radio-mr800
[    2.261295] usbcore: registered new interface driver radio-keene
[    2.261295] usbcore: registered new interface driver radio-keene
[    2.262782] usbcore: registered new interface driver radio-ma901
[    2.262782] usbcore: registered new interface driver radio-ma901
[    2.264396] usbcore: registered new interface driver radio-raremono
[    2.264396] usbcore: registered new interface driver radio-raremono
[    2.266050] pps pps0: new PPS source ktimer
[    2.266050] pps pps0: new PPS source ktimer
[    2.267050] pps pps0: ktimer PPS source registered
[    2.267050] pps pps0: ktimer PPS source registered
[    2.268336] Driver for 1-wire Dallas network protocol.
[    2.268336] Driver for 1-wire Dallas network protocol.
[    2.269721] usbcore: registered new interface driver DS9490R
[    2.269721] usbcore: registered new interface driver DS9490R
[    2.374044] g_webcam gadget: resume
[    2.374044] g_webcam gadget: resume
[    2.375000] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    2.375000] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    2.427041] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    2.427041] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    2.481050] g_webcam gadget: resume
[    2.481050] g_webcam gadget: resume
[    2.481949] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    2.481949] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    2.535026] dummy_udc dummy_udc.0: set_address =3D 2
[    2.535026] dummy_udc dummy_udc.0: set_address =3D 2
[    2.555053] usb 1-1: device v1d6b p0102 is not supported
[    2.555053] usb 1-1: device v1d6b p0102 is not supported
[    2.556471] g_webcam gadget: suspend
[    2.556471] g_webcam gadget: suspend
[    2.557445] hub 1-0:1.0: unable to enumerate USB device on port 1
[    2.557445] hub 1-0:1.0: unable to enumerate USB device on port 1
[    2.559153] usb usb1: dummy_bus_suspend
[    2.559153] usb usb1: dummy_bus_suspend
[    2.573046] i2c i2c-0: detect fail: address match, 0x2c
[    2.573046] i2c i2c-0: detect fail: address match, 0x2c
[    2.578066] i2c i2c-0: detect fail: address match, 0x2d
[    2.578066] i2c i2c-0: detect fail: address match, 0x2d
[    2.583066] i2c i2c-0: detect fail: address match, 0x2e
[    2.583066] i2c i2c-0: detect fail: address match, 0x2e
[    2.588066] i2c i2c-0: detect fail: address match, 0x2f
[    2.588066] i2c i2c-0: detect fail: address match, 0x2f
[    2.609056] applesmc: supported laptop not found!
[    2.609056] applesmc: supported laptop not found!
[    2.610150] applesmc: driver init failed (ret=3D-19)!
[    2.610150] applesmc: driver init failed (ret=3D-19)!
[    3.207188] pc87360: PC8736x not detected, module not inserted
[    3.207188] pc87360: PC8736x not detected, module not inserted
[    3.296369] sdhci: Secure Digital Host Controller Interface driver
[    3.296369] sdhci: Secure Digital Host Controller Interface driver
[    3.298461] sdhci: Copyright(c) Pierre Ossman
[    3.298461] sdhci: Copyright(c) Pierre Ossman
[    3.300259] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    3.300259] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400

[    3.302151] usbcore: registered new interface driver vub300
[    3.302151] usbcore: registered new interface driver vub300
[    3.303663] usbcore: registered new interface driver ushc
[    3.303663] usbcore: registered new interface driver ushc
[    3.305124] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.305124] sdhci-pltfm: SDHCI platform and OF driver helper
[    5.719065]  (null): enodev DEV ADDR =3D 0xFF
[    5.719065]  (null): enodev DEV ADDR =3D 0xFF
[    5.720306] cs5535-clockevt: Could not allocate MFGPT timer
[    5.720306] cs5535-clockevt: Could not allocate MFGPT timer
[    5.723183] usbcore: registered new interface driver usbkbd
[    5.723183] usbcore: registered new interface driver usbkbd
[    5.724633] usbcore: registered new interface driver usbmouse
[    5.724633] usbcore: registered new interface driver usbmouse
[    5.726073] vme_pio2: No cards, skipping registration
[    5.726073] vme_pio2: No cards, skipping registration
[    5.727942] Loading crystalhd 0.9.27
[    5.727942] Loading crystalhd 0.9.27
[    5.729066] usbcore: registered new interface driver cedusb
[    5.729066] usbcore: registered new interface driver cedusb
[    5.730624] dell_wmi_aio: No known WMI GUID found
[    5.730624] dell_wmi_aio: No known WMI GUID found
[    5.731974] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    5.731974] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    5.735778] oprofile: using timer interrupt.
[    5.735778] oprofile: using timer interrupt.
[    5.737431]=20
[    5.737431] printing PIC contents
[    5.737431]=20
[    5.737431] printing PIC contents
[    5.738651] ... PIC  IMR: ffff
[    5.738651] ... PIC  IMR: ffff
[    5.739415] ... PIC  IRR: 1013
[    5.739415] ... PIC  IRR: 1013
[    5.740196] ... PIC  ISR: 0000
[    5.740196] ... PIC  ISR: 0000
[    5.740965] ... PIC ELCR: 0c00
[    5.740965] ... PIC ELCR: 0c00
[    5.741731] printing local APIC contents on CPU#0/0:
[    5.741731] printing local APIC contents on CPU#0/0:
[    5.742716] ... APIC ID:      00000000 (0)
[    5.742716] ... APIC ID:      00000000 (0)
[    5.742716] ... APIC VERSION: 00050014
[    5.742716] ... APIC VERSION: 00050014
[    5.742716] ... APIC TASKPRI: 00000000 (00)
[    5.742716] ... APIC TASKPRI: 00000000 (00)
[    5.742716] ... APIC PROCPRI: 00000000
[    5.742716] ... APIC PROCPRI: 00000000
[    5.742716] ... APIC LDR: 01000000
[    5.742716] ... APIC LDR: 01000000
[    5.742716] ... APIC DFR: ffffffff
[    5.742716] ... APIC DFR: ffffffff
[    5.742716] ... APIC SPIV: 000001ff
[    5.742716] ... APIC SPIV: 000001ff
[    5.742716] ... APIC ISR field:
[    5.742716] ... APIC ISR field:
[    5.742716] 00000000
[    5.742716] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    5.742716] ... APIC TMR field:
[    5.742716] ... APIC TMR field:
[    5.742716] 00000000
[    5.742716] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    5.742716] ... APIC IRR field:
[    5.742716] ... APIC IRR field:
[    5.742716] 00000000
[    5.742716] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    5.742716] ... APIC ESR: 00000000
[    5.742716] ... APIC ESR: 00000000
[    5.742716] ... APIC ICR: 00000831
[    5.742716] ... APIC ICR: 00000831
[    5.742716] ... APIC ICR2: 01000000
[    5.742716] ... APIC ICR2: 01000000
[    5.742716] ... APIC LVTT: 000000ef
[    5.742716] ... APIC LVTT: 000000ef
[    5.742716] ... APIC LVTPC: 00010000
[    5.742716] ... APIC LVTPC: 00010000
[    5.742716] ... APIC LVT0: 00010700
[    5.742716] ... APIC LVT0: 00010700
[    5.742716] ... APIC LVT1: 00000400
[    5.742716] ... APIC LVT1: 00000400
[    5.742716] ... APIC LVTERR: 000000fe
[    5.742716] ... APIC LVTERR: 000000fe
[    5.742716] ... APIC TMICT: 000044d8
[    5.742716] ... APIC TMICT: 000044d8
[    5.742716] ... APIC TMCCT: 00000000
[    5.742716] ... APIC TMCCT: 00000000
[    5.742716] ... APIC TDCR: 00000003
[    5.742716] ... APIC TDCR: 00000003
[    5.742716]=20
[    5.742716]=20
[    5.767850] number of MP IRQ sources: 15.
[    5.767850] number of MP IRQ sources: 15.
[    5.768876] number of IO-APIC #0 registers: 24.
[    5.768876] number of IO-APIC #0 registers: 24.
[    5.770034] testing the IO APIC.......................
[    5.770034] testing the IO APIC.......................
[    5.771356] IO APIC #0......
[    5.771356] IO APIC #0......
[    5.772105] .... register #00: 00000000
[    5.772105] .... register #00: 00000000
[    5.773089] .......    : physical APIC id: 00
[    5.773089] .......    : physical APIC id: 00
[    5.774189] .......    : Delivery Type: 0
[    5.774189] .......    : Delivery Type: 0
[    5.775182] .......    : LTS          : 0
[    5.775182] .......    : LTS          : 0
[    5.776253] .... register #01: 00170011
[    5.776253] .... register #01: 00170011
[    5.777229] .......     : max redirection entries: 17
[    5.777229] .......     : max redirection entries: 17
[    5.778499] .......     : PRQ implemented: 0
[    5.778499] .......     : PRQ implemented: 0
[    5.779580] .......     : IO APIC version: 11
[    5.779580] .......     : IO APIC version: 11
[    5.780675] .... register #02: 00000000
[    5.780675] .... register #02: 00000000
[    5.781655] .......     : arbitration: 00
[    5.781655] .......     : arbitration: 00
[    5.782672] .... IRQ redirection table:
[    5.782672] .... IRQ redirection table:
[    5.783658] 1    0    0   0   0    0    0    00
[    5.783658] 1    0    0   0   0    0    0    00
[    5.784809] 0    0    0   0   0    1    1    31
[    5.784809] 0    0    0   0   0    1    1    31
[    5.785970] 0    0    0   0   0    1    1    30
[    5.785970] 0    0    0   0   0    1    1    30
[    5.787159] 0    0    0   0   0    1    1    33
[    5.787159] 0    0    0   0   0    1    1    33
[    5.788301] 1    0    0   0   0    1    1    34
[    5.788301] 1    0    0   0   0    1    1    34
[    5.789418] 1    1    0   0   0    1    1    35
[    5.789418] 1    1    0   0   0    1    1    35
[    5.790581] 0    0    0   0   0    1    1    36
[    5.790581] 0    0    0   0   0    1    1    36
[    5.791744] 0    0    0   0   0    1    1    37
[    5.791744] 0    0    0   0   0    1    1    37
[    5.792888] 0    0    0   0   0    1    1    38
[    5.792888] 0    0    0   0   0    1    1    38
[    5.794021] 0    1    0   0   0    1    1    39
[    5.794021] 0    1    0   0   0    1    1    39
[    5.795161] 1    1    0   0   0    1    1    3A
[    5.795161] 1    1    0   0   0    1    1    3A
[    5.796349] 1    1    0   0   0    1    1    3B
[    5.796349] 1    1    0   0   0    1    1    3B
[    5.797470] 0    0    0   0   0    1    1    3C
[    5.797470] 0    0    0   0   0    1    1    3C
[    5.798623] 0    0    0   0   0    1    1    3D
[    5.798623] 0    0    0   0   0    1    1    3D
[    5.799771] 0    0    0   0   0    1    1    3E
[    5.799771] 0    0    0   0   0    1    1    3E
[    5.800931] 0    0    0   0   0    1    1    3F
[    5.800931] 0    0    0   0   0    1    1    3F
[    5.802099] 1    0    0   0   0    0    0    00
[    5.802099] 1    0    0   0   0    0    0    00
[    5.803266] 1    0    0   0   0    0    0    00
[    5.803266] 1    0    0   0   0    0    0    00
[    5.804416] 1    0    0   0   0    0    0    00
[    5.804416] 1    0    0   0   0    0    0    00
[    5.805587] 1    0    0   0   0    0    0    00
[    5.805587] 1    0    0   0   0    0    0    00
[    5.806809] 1    0    0   0   0    0    0    00
[    5.806809] 1    0    0   0   0    0    0    00
[    5.807959] 1    0    0   0   0    0    0    00
[    5.807959] 1    0    0   0   0    0    0    00
[    5.809105] 1    0    0   0   0    0    0    00
[    5.809105] 1    0    0   0   0    0    0    00
[    5.810224] 1    0    0   0   0    0    0    00
[    5.810224] 1    0    0   0   0    0    0    00
[    5.811342] IRQ to pin mappings:
[    5.811342] IRQ to pin mappings:
[    5.812160] IRQ0=20
[    5.812160] IRQ0 -> 0:2-> 0:2

[    5.812816] IRQ1=20
[    5.812816] IRQ1 -> 0:1-> 0:1

[    5.813484] IRQ3=20
[    5.813484] IRQ3 -> 0:3-> 0:3

[    5.814143] IRQ4=20
[    5.814143] IRQ4 -> 0:4-> 0:4

[    5.814803] IRQ5=20
[    5.814803] IRQ5 -> 0:5-> 0:5

[    5.815480] IRQ6=20
[    5.815480] IRQ6 -> 0:6-> 0:6

[    5.816204] IRQ7=20
[    5.816204] IRQ7 -> 0:7-> 0:7

[    5.816875] IRQ8=20
[    5.816875] IRQ8 -> 0:8-> 0:8

[    5.817549] IRQ9=20
[    5.817549] IRQ9 -> 0:9-> 0:9

[    5.818209] IRQ10=20
[    5.818209] IRQ10 -> 0:10-> 0:10

[    5.818912] IRQ11=20
[    5.818912] IRQ11 -> 0:11-> 0:11

[    5.819622] IRQ12=20
[    5.819622] IRQ12 -> 0:12-> 0:12

[    5.820335] IRQ13=20
[    5.820335] IRQ13 -> 0:13-> 0:13

[    5.821043] IRQ14=20
[    5.821043] IRQ14 -> 0:14-> 0:14

[    5.821745] IRQ15=20
[    5.821745] IRQ15 -> 0:15-> 0:15

[    5.822460] .................................... done.
[    5.822460] .................................... done.
[    5.823963] bootconsole [earlyser0] disabled
[    5.823963] bootconsole [earlyser0] disabled
[    5.825744] RIO: rio_register_scan for mport_id=3D-1
[    5.826741] rtc-test rtc-test.0: setting system clock to 2014-03-19 19:3=
4:05 UTC (1395257645)
[    5.827913] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.828710] EDD information not available.
[    5.831517] Freeing unused kernel memory: 776K (ffffffff81bd7000 - fffff=
fff81c99000)
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /p=
roc/cmdline: no such file
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: can't create /proc/189/oom_score_adj: non=
existent directory
sed: /lib/modules/3.14.0-rc7-wl-ath-04452-g0f2691c/modules.dep: No such fil=
e or directory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[   72.990437] Unregister pv shared memory for cpu 0
[   72.992391] reboot: Restarting system
[   72.993141] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-wa1-03200201/0f2691c0856f6caa1825f2b307b0d786990c300b/vmlinuz-3.14.0-rc7-w=
l-ath-04452-g0f2691c -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,11520=
0 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw l=
ink=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-wa1-03200201/linux-deve=
l:devel-hourly-2014032001/.vmlinuz-0f2691c0856f6caa1825f2b307b0d786990c300b=
-20140320033332-6-cairo branch=3Dlinux-devel/devel-hourly-2014032001 BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-wa1-03200201/0f2691c0856f6caa1825f2b307b0d=
786990c300b/vmlinuz-3.14.0-rc7-wl-ath-04452-g0f2691c drbd.minor_count=3D8' =
 -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 256 -smp 2 -net n=
ic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::13552-:22 -boot=
 order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=
=3D/fs/LABEL=3DKVM/disk0-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk1-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -drive fi=
le=3D/fs/LABEL=3DKVM/disk2-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -drive f=
ile=3D/fs/LABEL=3DKVM/disk3-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk4-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -drive=
 file=3D/fs/LABEL=3DKVM/disk5-yocto-cairo-47,media=3Ddisk,if=3Dvirtio -pidf=
ile /dev/shm/kboot/pid-yocto-cairo-47 -serial file:/dev/shm/kboot/serial-yo=
cto-cairo-47 -daemonize -display none -monitor null=20

--3MwIy2ne0vdjdPXF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-wa1-03200201-0f2691c0856f6caa1825f2b307b0d786990c300b-WARNING:---at----vb-_queue_init+-x-123735.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwMTpkY2I5OWZk
OWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1OmJpc2VjdC1saW51eDQKCjIwMTQt
MDMtMjAtMDM6NDk6MzYgZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYx
NSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtZGNiOTlmZDliMDhjZmUxYWZl
NDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2RjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4
ZDNjYmM0MjkxOTBmMTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1kY2I5OWZkOWIw
OGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLWRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9kY2I5OWZkOWIwOGNm
ZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L3ZtbGludXotMy4xNC4wLXJjNwoKMjAxNC0w
My0yMC0wNjoxNjozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUKWyAg
ICA0LjA4MDY5OV0gZ193ZWJjYW0gZ2FkZ2V0OiB1dmNfZnVuY3Rpb25fYmluZApbICAgIDQu
MDgyNDQzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA0LjA4
MjQ0M10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNC4wODQ0
NzBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgZHJpdmVycy9tZWRpYS92NGwyLWNvcmUv
dmlkZW9idWYyLWNvcmUuYzoyMjA3IHZiMl9xdWV1ZV9pbml0KzB4YTMvMHgxMTMoKQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9kY2I5OWZkOWIwOGNmZTFhZmU0
MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMzE6MjAxNDAz
MjAwNjE3MTQ6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzc6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9kY2I5OWZkOWIwOGNmZTFh
ZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXlvY3RvLWNhaXJvLTg6MjAxNDAzMjAw
NjE3MTI6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzc6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9kY2I5OWZkOWIwOGNmZTFhZmU0
MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI3OjIwMTQwMzIw
MDYxNzEyOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZGNiOTlmZDliMDhjZmUxYWZl
NDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTMwOjIwMTQw
MzIwMDYxNzE2Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZGNiOTlmZDliMDhjZmUx
YWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy15b2N0by1pdnl0b3duMi0xMDoyMDE0
MDMyMDA2MTcxNzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2RjYjk5ZmQ5YjA4Y2Zl
MWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUvZG1lc2ctcXVhbnRhbC1jYWlyby0xOjIwMTQw
MzIwMDYxNzIxOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZGNiOTlmZDliMDhjZmUx
YWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWNhaXJvLTQ0OjIwMTQw
MzIwMDYxNzI0Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZGNiOTlmZDliMDhjZmUx
YWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTIyOjIw
MTQwMzIwMDYxNzIzOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZGNiOTlmZDliMDhj
ZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy15b2N0by1jYWlyby0yNDoyMDE0
MDMyMDA2MTcxOTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNzox
CjA6OTo5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTIwIDA2
OjE3OjM5IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IGRjYjk5ZmQ5YjA4Y2ZlMWFm
ZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKZ2l0IGNoZWNrb3V0IHYzLjEzCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDE6ZDhlYzI2ZDdmODI4N2Y1Nzg4
YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTIwLTA2OjE3
OjQyIGQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgx
NDIxMGYwZTY0YmUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2
NGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1kOGVj
MjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1
NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMuMTMuMAoKMjAxNC0wMy0yMC0wNzo0Mjo0MyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDIuNTI0OTEzXSBnX3dl
YmNhbSBnYWRnZXQ6IHV2Y19mdW5jdGlvbl9iaW5kClsgICAgMi41MjcwMjddIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDIuNTI3MDI3XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjUyOTExMV0gV0FSTklORzogQ1BV
OiAwIFBJRDogMSBhdCBkcml2ZXJzL21lZGlhL3Y0bDItY29yZS92aWRlb2J1ZjItY29yZS5j
OjIxMjQgdmIyX3F1ZXVlX2luaXQrMHhhMy8weDExMygpCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxL2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYw
ZTY0YmUvZG1lc2cteW9jdG8taXZ5dG93bjItMTk6MjAxNDAzMjAwNzQzMDk6eDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTMuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxL2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0
YmUvZG1lc2cteW9jdG8tY2Fpcm8tMTM6MjAxNDAzMjAwNzQzMDk6eDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxOjMuMTMuMDoxCjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW0yMDE0LTAzLTIwIDA3OjQzOjE0IFJFUEVBVCBDT1VOVDogMjAgICMgL2tl
cm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjEzCmdpdCBjaGVja291dCB2My4xMgpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThj
Y2JkNmE1Y2ViNTI6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0wNzo0MzoxNyA1ZTAxZGM3
YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMS01ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUy
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLTVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2Jk
NmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtNWUwMWRjN2IyNmQ5ZjI0
ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1
Y2ViNTIvdm1saW51ei0zLjEyLjAKCjIwMTQtMDMtMjAtMDk6NDc6MTcgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVS
RQpbICAgIDkuMTAyNzk0XSBnX3dlYmNhbSBnYWRnZXQ6IHV2Y19mdW5jdGlvbl9iaW5kClsg
ICAgOS4xMTE4OTRdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAg
IDkuMTExODk0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA5
LjExOTgyOV0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBkcml2ZXJzL21lZGlhL3Y0bDIt
Y29yZS92aWRlb2J1ZjItY29yZS5jOjIwOTcgdmIyX3F1ZXVlX2luaXQrMHhhMy8weDExMygp
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzVlMDFkYzdiMjZkOWYy
NGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2ctcXVhbnRhbC1pbm4tMzA6MjAxNDAz
MjAxMDU3MjE6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5
OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1zdG9ha2xleS0zOjIwMTQwMzIwMTA1NzE1Ong4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjEyLjA6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2Ni
ZDZhNWNlYjUyL2RtZXNnLXlvY3RvLWlubi0xOToyMDE0MDMyMDEwNTcyMjp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNn
LXlvY3RvLXN0b2FrbGV5LTU6MjAxNDAzMjAxMDU3MjU6eDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxOjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxLzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9j
dG8tc3RvYWtsZXktNjoyMDE0MDMyMDEwNTcyNjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEv
NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFs
LXN0b2FrbGV5LTQ6MjAxNDAzMjAxMDU3Mjg6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxOjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzVl
MDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2ctcXVhbnRhbC1p
bm4tMjE6MjAxNDAzMjAxMDU3MjY6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvNWUwMWRjN2IyNmQ5ZjI0
ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLWlubi0zMToyMDE0MDMy
MDEwNTcyNjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4
Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtaW5uLTQ1OjIwMTQwMzIwMTA1NzI3Ong4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxLzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIv
ZG1lc2ctcXVhbnRhbC1pbm4tODoyMDE0MDMyMDEwNTcyNjp4ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS81
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwt
cm9hbS00MzoyMDE0MDMyMDEwNTczMTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6
My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvNWUwMWRj
N2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLXN0b2Fr
bGV5LTU6MjAxNDAzMjAxMDU3MzY6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMu
MTIuMDoxCjA6MTI6MTIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDMtMjAgMTA6NTc6NDkgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4
NC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTIKZ2l0
IGNoZWNrb3V0IHYzLjExCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwMzIwMDE6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNl
Y3QtbGludXg0CgoyMDE0LTAzLTIwLTEwOjU3OjUyIDZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1MjVi
MWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEtNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS02ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBh
OTRjMTkyMTNlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS92bWxpbnV6LTMu
MTEuMAoKMjAxNC0wMy0yMC0xMTozNTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNU
IEZBSUxVUkUKWyAgICAxLjcxNzUzN10gZ193ZWJjYW0gZ2FkZ2V0OiB1dmNfZnVuY3Rpb25f
YmluZApbICAgIDEuNzE5MDU4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0t
LS0KWyAgICAxLjcxOTA1OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICAgMS43MjA1ODRdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgZHJpdmVycy9tZWRp
YS92NGwyLWNvcmUvdmlkZW9idWYyLWNvcmUuYzoyMDY2IHZiMl9xdWV1ZV9pbml0KzB4YTMv
MHgxMTMoKQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1
MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtaXZ5dG93
bjItMTI6MjAxNDAzMjAxMTM2NDM6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMu
MTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1pdnl0b3du
Mi03OjIwMTQwMzIwMTEzNjQzOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjEx
LjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1MjVi
MWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWNhaXJvLTE2OjIw
MTQwMzIwMTEzNjQwOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjExLjA6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1MjViMWRiMjhm
OGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWNhaXJvLTM1OjIwMTQwMzIw
MTEzNjQwOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjExLjA6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWNhaXJvLTQwOjIwMTQwMzIwMTEzNjQx
Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjExLjA6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdm
NzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWl2eXRvd24yLTE6MjAxNDAzMjAxMTM2Mzg6eDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItMjA6MjAxNDAzMjAxMTM2Mzk6eDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMx
OTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItMjE6MjAxNDAzMjAxMTM2NDE6eDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIx
M2UvZG1lc2cteW9jdG8taXZ5dG93bjItMjM6MjAxNDAzMjAxMTM2NDI6eDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uv
ZG1lc2cteW9jdG8taXZ5dG93bjItMjg6MjAxNDAzMjAxMTM2NDQ6eDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1l
c2cteW9jdG8taXZ5dG93bjItMzoyMDE0MDMyMDExMzYzNzp4ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDE6My4xMS4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1x
dWFudGFsLWNhaXJvLTI3OjIwMTQwMzIwMTEzNjQ0Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMTozLjExLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50
YWwtaXZ5dG93bjItMzoyMDE0MDMyMDExMzY0NTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xMS4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEv
NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1i
ZW5zLTU6MjAxNDAzMjAxMTM2NDM6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMu
MTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tY2Fpcm8tMzc6
MjAxNDAzMjAxMTM2NDU6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8taXZ5dG93bjItMTQ6MjAx
NDAzMjAxMTM2NDU6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTEuMDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzZlNDY2NDUyNWIxZGIyOGY4
YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tbmhtNC01OjIwMTQwMzIwMTEz
NjQ0Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjExLjA6MQowOjE3OjE3IGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTIwIDExOjM2OjU0IFJF
UEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjExCmdpdCBjaGVja291dCB2My4xMAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOjhiYjQ5NWUz
ZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LWxpbnV4NAoKMjAxNC0w
My0yMC0xMTozNjo1NyA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS04YmI0OTVlM2YwMjQwMWVlNmY3
NmQxYjFkNzdmM2FjOWYwNzllMzc2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3
ZjNhYzlmMDc5ZTM3Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLThiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEtOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3NgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvdm1saW51ei0zLjEwLjAKCjIwMTQtMDMtMjAt
MTI6MTM6NTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVTVCBGQUlMVVJFClsgICAgMS4y
MzI1ODNdIGdfd2ViY2FtIGdhZGdldDogdXZjX2Z1bmN0aW9uX2JpbmQKWyAgICAxLjIzMzc2
OV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS4yMzM3Njld
IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuMjM0OTk4XSBX
QVJOSU5HOiBhdCBkcml2ZXJzL21lZGlhL3Y0bDItY29yZS92aWRlb2J1ZjItY29yZS5jOjIw
NjYgdmIyX3F1ZXVlX2luaXQrMHhhMy8weDExMygpCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxLzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUz
NzYvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xMjoyMDE0MDMyMDEyMTQ0Mzp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3
Ni9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE5OjIwMTQwMzIwMTIxNDQ1Ong4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMTozLjEwLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMS84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2
L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjk6MjAxNDAzMjAxMjE0NDY6eDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxOjMuMTAuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxLzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi02OjIwMTQwMzIwMTIxNDQyOng4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMTozLjEwLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2Rt
ZXNnLXF1YW50YWwtaXZ5dG93bjItODoyMDE0MDMyMDEyMTQ0Mjp4ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDE6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVz
Zy15b2N0by1pdnl0b3duMi0xMjoyMDE0MDMyMDEyMTQ0Njp4ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDE6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15
b2N0by1pdnl0b3duMi0xNToyMDE0MDMyMDEyMTQ0Nzp4ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDE6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0
by14Ym0tMzoyMDE0MDMyMDEyMTQ0Nzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6
My4xMC4wOjEKMDo4OjggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDMtMjAgMTI6MTQ6NTggUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4
NC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTAKZ2l0
IGNoZWNrb3V0IHYzLjkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDAzMjAwMTpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxOmJpc2Vj
dC1saW51eDQKCjIwMTQtMDMtMjAtMTI6MTU6MDEgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNj
OTc5ZWI2NmRhZmEyNGFkMSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYzFi
ZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMQpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2MxYmU1YTViMWIz
NTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS1jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZk
YWZhMjRhZDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL3ZtbGludXotMy45
LjAKCjIwMTQtMDMtMjAtMTI6MjU6MDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxNAkyMCBT
VUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYzLjkKZ2l0IGJpc2VjdCBzdGFydCB2My4x
MCB2My45IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgInYzLjEw
IiwgIi1nIiwgInYzLjkiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCIsICIva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0Il0KQmlzZWN0aW5n
OiAxNDczNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQg
c3RlcHMpCltmZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyXSBNZXJn
ZSBicmFuY2ggJ3JjdS91cmdlbnQnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9wYXVsbWNrL2xpbnV4LXJjdQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMy
MDAxOmZmODlhY2M1NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTI6YmlzZWN0LWxp
bnV4NAoKMjAxNC0wMy0yMC0xMjoyNjozNSBmZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUy
YWQ2NjIwNDE1ZmUyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1mZjg5YWNj
NTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZmY4OWFjYzU2M2EwYmQ0
OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZlMgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAx
LWZmODlhY2M1NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTIKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDEtZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQx
NWZlMgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2Zm
ODlhY2M1NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTIvdm1saW51ei0zLjEwLjAt
cmMxLTAwMjAyLWdmZjg5YWNjCgoyMDE0LTAzLTIwLTEzOjAxOjM1IGRldGVjdGluZyBib290
IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAgIDIuNTkyNTQwXSBpbnRlbGZiOiBWZXJzaW9u
IDAuOS42ClsgICAgMi41OTYxMzRdIGlibWFzbTogSUJNIEFTTSBTZXJ2aWNlIFByb2Nlc3Nv
ciBEcml2ZXIgdmVyc2lvbiAxLjAgbG9hZGVkClsgICAgMi41OTYxMzRdIGlibWFzbTogSUJN
IEFTTSBTZXJ2aWNlIFByb2Nlc3NvciBEcml2ZXIgdmVyc2lvbiAxLjAgbG9hZGVkClsgICAg
Mi42MDMwMTldIGdlbmlycTogRmxhZ3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwIChkdW1t
eV9pcnEpIHZzLiAwMDAxNWEyMCAodGltZXIpClsgICAgMi42MDMwMTldIGdlbmlycTogRmxh
Z3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwIChkdW1teV9pcnEpIHZzLiAwMDAxNWEyMCAo
dGltZXIpClsgICAgMi42MDQwMDVdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjEwLjAtcmMxLTAwMjAyLWdmZjg5YWNjICMxClsgICAgMi42MDQwMDVdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEwLjAtcmMxLTAwMjAy
LWdmZjg5YWNjICMxClsgICAgMi42MDQwMDVdICAwMDAwMDAwMDAwMDAwMDAwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1NjNhMGJkNDk5NjU2NzRm
NTY1NTJhZDY2MjA0MTVmZTIvZG1lc2cteW9jdG8taXZ5dG93bjItMzoyMDE0MDMyMDEzMDIx
Mjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4
OWFjYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1
NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTIvZG1lc2cteW9jdG8teGJtLTI6MjAx
NDAzMjAxMzAyMTA6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTAuMC1yYzEt
MDAyMDItZ2ZmODlhY2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS9mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyL2RtZXNnLXF1YW50
YWwtYmVucy02OjIwMTQwMzIwMTMwMjE3Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MTozLjEwLjAtcmMxLTAwMjAyLWdmZjg5YWNjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEvZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZl
Mi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE5OjIwMTQwMzIwMTMwMjE3Ong4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMTozLjEwLjAtcmMxLTAwMjAyLWdmZjg5YWNjOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvZmY4OWFjYzU2M2EwYmQ0OTk2NTY3
NGY1NjU1MmFkNjYyMDQxNWZlMi9kbWVzZy1xdWFudGFsLWJlbnMtMzoyMDE0MDMyMDEzMDIy
Njp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4
OWFjYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1
NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTIvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6
MjAxNDAzMjAxMzAyMjQ6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTAuMC1y
YzEtMDAyMDItZ2ZmODlhY2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS9mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyL2RtZXNnLXF1
YW50YWwtaXZ5dG93bjItMTg6MjAxNDAzMjAxMzAyMjA6eDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxOjMuMTAuMC1yYzEtMDAyMDItZ2ZmODlhY2M6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS9mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2
NjIwNDE1ZmUyL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjE6MjAxNDAzMjAxMzAyMjE6eDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTAuMC1yYzEtMDAyMDItZ2ZmODlhY2M6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9mZjg5YWNjNTYzYTBi
ZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjc6
MjAxNDAzMjAxMzAyMjE6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTAuMC1y
YzEtMDAyMDItZ2ZmODlhY2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS9mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyL2RtZXNnLXlv
Y3RvLWJlbnMtMToyMDE0MDMyMDEzMDIyNTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4OWFjYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVm
ZTIvZG1lc2cteW9jdG8taXZ5dG93bjItNDoyMDE0MDMyMDEzMDIyNzp4ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4OWFjYzoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1NjNhMGJkNDk5NjU2NzRm
NTY1NTJhZDY2MjA0MTVmZTIvZG1lc2cteW9jdG8taXZ5dG93bjItNToyMDE0MDMyMDEzMDIy
ODp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4
OWFjYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2ZmODlhY2M1
NjNhMGJkNDk5NjU2NzRmNTY1NTJhZDY2MjA0MTVmZTIvZG1lc2ctcXVhbnRhbC1iZW5zLTE6
MjAxNDAzMjAxMzAyMjk6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTAuMC1y
YzEtMDAyMDItZ2ZmODlhY2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS9mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyL2RtZXNnLXF1
YW50YWwtYmVucy01OjIwMTQwMzIwMTMwMjI5Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMTozLjEwLjAtcmMxLTAwMjAyLWdmZjg5YWNjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDEvZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQx
NWZlMi9kbWVzZy15b2N0by1pdnl0b3duMi0yNDoyMDE0MDMyMDEzMDIzMDp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xMC4wLXJjMS0wMDIwMi1nZmY4OWFjYzoxCjA6MTU6
MTUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMjAgMTM6MDI6
MzcgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEyOTE3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzI0ZDBjMjU0MmIzODk2M2FlNGQ1MTcx
ZWNjMGEyYzEzMjZjNjU2YmNdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdmlyby92ZnMKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMjAwMToyNGQwYzI1NDJiMzg5NjNhZTRkNTE3MWVjYzBhMmMxMzI2YzY1
NmJjOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMjAtMTM6MDI6MzkgMjRkMGMyNTQyYjM4OTYz
YWU0ZDUxNzFlY2MwYTJjMTMyNmM2NTZiYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEtMjRkMGMyNTQyYjM4OTYzYWU0ZDUxNzFlY2MwYTJjMTMyNmM2NTZiYwpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0
ZDBjMjU0MmIzODk2M2FlNGQ1MTcxZWNjMGEyYzEzMjZjNjU2YmMKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMS0yNGQwYzI1NDJiMzg5NjNhZTRkNTE3MWVjYzBhMmMxMzI2YzY1NmJj
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTI0ZDBjMjU0MmIzODk2M2FlNGQ1MTcx
ZWNjMGEyYzEzMjZjNjU2YmMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS8yNGQwYzI1NDJiMzg5NjNhZTRkNTE3MWVjYzBhMmMxMzI2YzY1NmJjL3Zt
bGludXotMy45LjAtMTAxMjgtZzI0ZDBjMjUKCjIwMTQtMDMtMjAtMTM6NTc6MzkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1Qg
RkFJTFVSRQpbICAgIDAuODU3NTUxXSBpbnRlbGZiOiBWZXJzaW9uIDAuOS42ClsgICAgMC44
NTk0NDBdIGlibWFzbTogSUJNIEFTTSBTZXJ2aWNlIFByb2Nlc3NvciBEcml2ZXIgdmVyc2lv
biAxLjAgbG9hZGVkClsgICAgMC44NTk0NDBdIGlibWFzbTogSUJNIEFTTSBTZXJ2aWNlIFBy
b2Nlc3NvciBEcml2ZXIgdmVyc2lvbiAxLjAgbG9hZGVkClsgICAgMC44NjIzMDJdIGdlbmly
cTogRmxhZ3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwIChkdW1teV9pcnEpIHZzLiAwMDAx
NWEyMCAodGltZXIpClsgICAgMC44NjIzMDJdIGdlbmlycTogRmxhZ3MgbWlzbWF0Y2ggaXJx
IDAuIDAwMDAwMDgwIChkdW1teV9pcnEpIHZzLiAwMDAxNWEyMCAodGltZXIpClsgICAgMC44
NjMyODBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjkuMC0x
MDEyOC1nMjRkMGMyNSAjMQpbICAgIDAuODYzMjgwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy45LjAtMTAxMjgtZzI0ZDBjMjUgIzEKWyAgICAwLjg2MzI4
MF0gIDAwMDAwMDAwMDAwMDAwMDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvMjRkMGMyNTQyYjM4OTYzYWU0ZDUxNzFlY2MwYTJjMTMyNmM2NTZiYy9kbWVzZy15
b2N0by14cHMtNDoyMDE0MDMyMDE0NDEyMjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDE6My45LjAtMTAxMjgtZzI0ZDBjMjU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS8yNGQwYzI1NDJiMzg5NjNhZTRkNTE3MWVjYzBhMmMxMzI2YzY1NmJjL2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTEzOjIwMTQwMzIwMTQ0MTIzOng4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMTozLjkuMC0xMDEyOC1nMjRkMGMyNToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLzI0ZDBjMjU0MmIzODk2M2FlNGQ1MTcxZWNjMGEyYzEz
MjZjNjU2YmMvZG1lc2cteW9jdG8taXZ5dG93bjItMjY6MjAxNDAzMjAxNDQxMjM6eDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuOS4wLTEwMTI4LWcyNGQwYzI1OjEKMDozOjEg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTAxMjggcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbMTUxMTczZThj
ZTliOTViYmJiZDdlZWRiOTAzNWNmYWZmYmRiN2NiMl0gTWVyZ2UgdGFnICdmb3ItdjMuMTAn
IG9mIGdpdDovL2dpdC5pbmZyYWRlYWQub3JnL2JhdHRlcnktMi42CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwMzIwMDE6MTUxMTczZThjZTliOTViYmJiZDdlZWRiOTAzNWNmYWZmYmRiN2NiMjpiaXNl
Y3QtbGludXg0CgoyMDE0LTAzLTIwLTE0OjQxOjM3IDE1MTE3M2U4Y2U5Yjk1YmJiYmQ3ZWVk
YjkwMzVjZmFmZmJkYjdjYjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTE1
MTE3M2U4Y2U5Yjk1YmJiYmQ3ZWVkYjkwMzVjZmFmZmJkYjdjYjIKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8xNTExNzNlOGNl
OWI5NWJiYmJkN2VlZGI5MDM1Y2ZhZmZiZGI3Y2IyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEtMTUxMTczZThjZTliOTViYmJiZDdlZWRiOTAzNWNmYWZmYmRiN2NiMgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS0xNTExNzNlOGNlOWI5NWJiYmJkN2VlZGI5MDM1Y2Zh
ZmZiZGI3Y2IyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvMTUxMTczZThjZTliOTViYmJiZDdlZWRiOTAzNWNmYWZmYmRiN2NiMi92bWxpbnV6LTMu
OS4wLTA0Nzg5LWcxNTExNzNlCgoyMDE0LTAzLTIwLTE1OjE1OjM3IGRldGVjdGluZyBib290
IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAgIDEuMTQ1MzE1XSBpbnRlbGZiOiBWZXJzaW9u
IDAuOS42ClsgICAgMS4xNDYzMTZdIGlibWFzbTogSUJNIEFTTSBTZXJ2aWNlIFByb2Nlc3Nv
ciBEcml2ZXIgdmVyc2lvbiAxLjAgbG9hZGVkClsgICAgMS4xNDYzMTZdIGlibWFzbTogSUJN
IEFTTSBTZXJ2aWNlIFByb2Nlc3NvciBEcml2ZXIgdmVyc2lvbiAxLjAgbG9hZGVkClsgICAg
MS4xNDgxMjNdIGdlbmlycTogRmxhZ3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwIChkdW1t
eV9pcnEpIHZzLiAwMDAxNWEyMCAodGltZXIpClsgICAgMS4xNDgxMjNdIGdlbmlycTogRmxh
Z3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwIChkdW1teV9pcnEpIHZzLiAwMDAxNWEyMCAo
dGltZXIpClsgICAgMS4xNDkxMTBdIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRl
ZCAzLjkuMC0wNDc4OS1nMTUxMTczZSAjMQpbICAgIDEuMTQ5MTEwXSBQaWQ6IDEsIGNvbW06
IHN3YXBwZXIgTm90IHRhaW50ZWQgMy45LjAtMDQ3ODktZzE1MTE3M2UgIzEKWyAgICAxLjE0
OTExMF0gQ2FsbCBUcmFjZToKWyAgICAxLjE0OTExMF0gQ2FsbCBUcmFjZToKWyAgICAxLjE0
OTExMF0gIFs8ZmZmZmZmZmY4MTA5OGVjYj5dIF9fc2V0dXBfaXJxKzB4MzIzLzB4Mzg3Clsg
ICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODEwOThlY2I+XSBfX3NldHVwX2lycSsweDMyMy8w
eDM4NwpbICAgIDEuMTQ5MTEwXSAgWzxmZmZmZmZmZjgxM2U4Y2ZlPl0gPyBhZF9kcG90X3Jl
bW92ZSsweGJjLzB4YmMKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MTNlOGNmZT5dID8g
YWRfZHBvdF9yZW1vdmUrMHhiYy8weGJjClsgICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODEw
OTkxNGQ+XSByZXF1ZXN0X3RocmVhZGVkX2lycSsweGU3LzB4MTI0ClsgICAgMS4xNDkxMTBd
ICBbPGZmZmZmZmZmODEwOTkxNGQ+XSByZXF1ZXN0X3RocmVhZGVkX2lycSsweGU3LzB4MTI0
ClsgICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODFiMDQ1NzE+XSA/IGlibWFzbV9pbml0KzB4
NzUvMHg3NQpbICAgIDEuMTQ5MTEwXSAgWzxmZmZmZmZmZjgxYjA0NTcxPl0gPyBpYm1hc21f
aW5pdCsweDc1LzB4NzUKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MWIwNDU5ZD5dIGR1
bW15X2lycV9pbml0KzB4MmMvMHg2MApbICAgIDEuMTQ5MTEwXSAgWzxmZmZmZmZmZjgxYjA0
NTlkPl0gZHVtbXlfaXJxX2luaXQrMHgyYy8weDYwClsgICAgMS4xNDkxMTBdICBbPGZmZmZm
ZmZmODFhZDllMzA+XSBkb19vbmVfaW5pdGNhbGwrMHg3OC8weDE0MgpbICAgIDEuMTQ5MTEw
XSAgWzxmZmZmZmZmZjgxYWQ5ZTMwPl0gZG9fb25lX2luaXRjYWxsKzB4NzgvMHgxNDIKWyAg
ICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MWFkOWZmMj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4ZjgvMHgxNzMKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MWFkOWZmMj5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4ZjgvMHgxNzMKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4
MWFkOTcwZD5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMS4xNDkxMTBdICBb
PGZmZmZmZmZmODFhZDk3MGQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDEu
MTQ5MTEwXSAgWzxmZmZmZmZmZjgxNjgzOGFmPl0gPyByZXN0X2luaXQrMHhkMy8weGQzClsg
ICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODE2ODM4YWY+XSA/IHJlc3RfaW5pdCsweGQzLzB4
ZDMKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MTY4MzhiZD5dIGtlcm5lbF9pbml0KzB4
ZS8weGQxClsgICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODE2ODM4YmQ+XSBrZXJuZWxfaW5p
dCsweGUvMHhkMQpbICAgIDEuMTQ5MTEwXSAgWzxmZmZmZmZmZjgxNjkwY2JhPl0gcmV0X2Zy
b21fZm9yaysweDdhLzB4YjAKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZmZmY4MTY5MGNiYT5d
IHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMS4xNDkxMTBdICBbPGZmZmZmZmZmODE2
ODM4YWY+XSA/IHJlc3RfaW5pdCsweGQzLzB4ZDMKWyAgICAxLjE0OTExMF0gIFs8ZmZmZmZm
ZmY4MTY4MzhhZj5dID8gcmVzdF9pbml0KzB4ZDMvMHhkMwpbICAgIDEuMTcwNDExXSBkdW1t
eS1pcnE6IGNhbm5vdCByZWdpc3RlciBJUlEgMApbICAgIDEuMTcwNDExXSBkdW1teS1pcnE6
IGNhbm5vdCByZWdpc3RlciBJUlEgMApbICAgIDEuMTcxNjE2XSBQaGFudG9tIExpbnV4IERy
aXZlciwgdmVyc2lvbiBuMC45LjgsIGluaXQgT0sKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEvMTUxMTczZThjZTliOTViYmJiZDdlZWRiOTAzNWNmYWZmYmRiN2Ni
Mi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTIzOjIwMTQwMzIwMTUxNjMzOng4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDc4OS1nMTUxMTczZToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzE1MTE3M2U4Y2U5Yjk1YmJiYmQ3ZWVkYjkw
MzVjZmFmZmJkYjdjYjIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi03OjIwMTQwMzIwMTUxNjMy
Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDc4OS1nMTUxMTczZTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzE1MTE3M2U4Y2U5Yjk1
YmJiYmQ3ZWVkYjkwMzVjZmFmZmJkYjdjYjIvZG1lc2cteW9jdG8taXZ5dG93bjItMzoyMDE0
MDMyMDE1MTYzMjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My45LjAtMDQ3ODkt
ZzE1MTE3M2U6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8xNTEx
NzNlOGNlOWI5NWJiYmJkN2VlZGI5MDM1Y2ZhZmZiZGI3Y2IyL2RtZXNnLXF1YW50YWwtaXZ5
dG93bjItMzoyMDE0MDMyMDE1MTYzNDp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6
My45LjAtMDQ3ODktZzE1MTE3M2U6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMS8xNTExNzNlOGNlOWI5NWJiYmJkN2VlZGI5MDM1Y2ZhZmZiZGI3Y2IyL2RtZXNn
LXlvY3RvLWl2eXRvd24yLTI1OjIwMTQwMzIwMTUxNjM0Ong4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMTozLjkuMC0wNDc4OS1nMTUxMTczZToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzE1MTE3M2U4Y2U5Yjk1YmJiYmQ3ZWVkYjkwMzVjZmFmZmJk
YjdjYjIvZG1lc2cteW9jdG8taXZ5dG93bjItNzoyMDE0MDMyMDE1MTYzNDp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6My45LjAtMDQ3ODktZzE1MTE3M2U6MQowOjY6NCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA0Nzg5IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKWzZjMjQ0OTlmNDBkOTZi
ZjA3YTg1YjcwOWZiMWJlZTVjZWE2MTFhMWRdIHRyYWNpbmc6IEZpeCBzbWFsbCBtZXJnZSBi
dWcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDAzMjAwMTo2YzI0NDk5ZjQwZDk2YmYwN2E4NWI3MDlmYjFi
ZWU1Y2VhNjExYTFkOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMjAtMTU6MTY6NDEgNmMyNDQ5
OWY0MGQ5NmJmMDdhODViNzA5ZmIxYmVlNWNlYTYxMWExZCBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEtNmMyNDQ5OWY0MGQ5NmJmMDdhODViNzA5ZmIxYmVlNWNlYTYxMWEx
ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLzZjMjQ0OTlmNDBkOTZiZjA3YTg1YjcwOWZiMWJlZTVjZWE2MTFhMWQKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS02YzI0NDk5ZjQwZDk2YmYwN2E4NWI3MDlmYjFiZWU1
Y2VhNjExYTFkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTZjMjQ0OTlmNDBkOTZi
ZjA3YTg1YjcwOWZiMWJlZTVjZWE2MTFhMWQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMS82YzI0NDk5ZjQwZDk2YmYwN2E4NWI3MDlmYjFiZWU1Y2Vh
NjExYTFkL3ZtbGludXotMy45LjAtMDI5OTYtZzZjMjQ0OTkKCjIwMTQtMDMtMjAtMTU6NTA6
NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE2NDIg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpb
NWE1YTFiZjA5OWQ2OTQyMzk5ZWEwYjM0YTYyZTVmMGJjNGM1YzM2ZV0gTWVyZ2UgYnJhbmNo
ICd4ODYtcmFzLWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwMTo1YTVhMWJm
MDk5ZDY5NDIzOTllYTBiMzRhNjJlNWYwYmM0YzVjMzZlOmJpc2VjdC1saW51eDQKCjIwMTQt
MDMtMjAtMTU6NTE6NDIgNWE1YTFiZjA5OWQ2OTQyMzk5ZWEwYjM0YTYyZTVmMGJjNGM1YzM2
ZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtNWE1YTFiZjA5OWQ2OTQyMzk5
ZWEwYjM0YTYyZTVmMGJjNGM1YzM2ZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzVhNWExYmYwOTlkNjk0MjM5OWVhMGIzNGE2
MmU1ZjBiYzRjNWMzNmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS01YTVhMWJmMDk5
ZDY5NDIzOTllYTBiMzRhNjJlNWYwYmM0YzVjMzZlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLTVhNWExYmYwOTlkNjk0MjM5OWVhMGIzNGE2MmU1ZjBiYzRjNWMzNmUKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS81YTVhMWJmMDk5ZDY5
NDIzOTllYTBiMzRhNjJlNWYwYmM0YzVjMzZlL3ZtbGludXotMy45LjAtMDM1MjAtZzVhNWEx
YmYKCjIwMTQtMDMtMjAtMTY6MTE6NDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTMJMjAg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAxMjY5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2M5ZWY3MTM5OTNiYTE2OGIzOGQxYTk3ZWEwYWIw
MDg3NGYxZGEwMjJdIE1lcmdlIHRhZyAnYXJtNjQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvY21hcmluYXMvbGludXgtYWFy
Y2g2NApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOmM5ZWY3MTM5OTNiYTE2OGIzOGQxYTk3ZWEw
YWIwMDg3NGYxZGEwMjI6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0xNjoxMzo0NCBjOWVm
NzEzOTkzYmExNjhiMzhkMWE5N2VhMGFiMDA4NzRmMWRhMDIyIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMS1jOWVmNzEzOTkzYmExNjhiMzhkMWE5N2VhMGFiMDA4NzRmMWRh
MDIyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvYzllZjcxMzk5M2JhMTY4YjM4ZDFhOTdlYTBhYjAwODc0ZjFkYTAyMgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWM5ZWY3MTM5OTNiYTE2OGIzOGQxYTk3ZWEwYWIw
MDg3NGYxZGEwMjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYzllZjcxMzk5M2Jh
MTY4YjM4ZDFhOTdlYTBhYjAwODc0ZjFkYTAyMgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxL2M5ZWY3MTM5OTNiYTE2OGIzOGQxYTk3ZWEwYWIwMDg3
NGYxZGEwMjIvdm1saW51ei0zLjkuMC0wNDM2NS1nYzllZjcxMwoKMjAxNC0wMy0yMC0xNjo0
NTo0NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUKWyAgICAxLjEwMzM2
MF0gaW50ZWxmYjogVmVyc2lvbiAwLjkuNgpbICAgIDEuMTA0MzU4XSBpYm1hc206IElCTSBB
U00gU2VydmljZSBQcm9jZXNzb3IgRHJpdmVyIHZlcnNpb24gMS4wIGxvYWRlZApbICAgIDEu
MTA0MzU4XSBpYm1hc206IElCTSBBU00gU2VydmljZSBQcm9jZXNzb3IgRHJpdmVyIHZlcnNp
b24gMS4wIGxvYWRlZApbICAgIDEuMTA2MjYxXSBnZW5pcnE6IEZsYWdzIG1pc21hdGNoIGly
cSAwLiAwMDAwMDA4MCAoZHVtbXlfaXJxKSB2cy4gMDAwMTVhMjAgKHRpbWVyKQpbICAgIDEu
MTA2MjYxXSBnZW5pcnE6IEZsYWdzIG1pc21hdGNoIGlycSAwLiAwMDAwMDA4MCAoZHVtbXlf
aXJxKSB2cy4gMDAwMTVhMjAgKHRpbWVyKQpbICAgIDEuMTA3MjQ5XSBQaWQ6IDEsIGNvbW06
IHN3YXBwZXIgTm90IHRhaW50ZWQgMy45LjAtMDQzNjUtZ2M5ZWY3MTMgIzEKWyAgICAxLjEw
NzI0OV0gUGlkOiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuOS4wLTA0MzY1LWdj
OWVmNzEzICMxClsgICAgMS4xMDcyNDldIENhbGwgVHJhY2U6ClsgICAgMS4xMDcyNDldIENh
bGwgVHJhY2U6ClsgICAgMS4xMDcyNDldICBbPGZmZmZmZmZmODEwOThlY2I+XSBfX3NldHVw
X2lycSsweDMyMy8weDM4NwpbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxMDk4ZWNiPl0g
X19zZXR1cF9pcnErMHgzMjMvMHgzODcKWyAgICAxLjEwNzI0OV0gIFs8ZmZmZmZmZmY4MTNl
OGNmZT5dID8gYWRfZHBvdF9yZW1vdmUrMHhiYy8weGJjClsgICAgMS4xMDcyNDldICBbPGZm
ZmZmZmZmODEzZThjZmU+XSA/IGFkX2Rwb3RfcmVtb3ZlKzB4YmMvMHhiYwpbICAgIDEuMTA3
MjQ5XSAgWzxmZmZmZmZmZjgxMDk5MTRkPl0gcmVxdWVzdF90aHJlYWRlZF9pcnErMHhlNy8w
eDEyNApbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxMDk5MTRkPl0gcmVxdWVzdF90aHJl
YWRlZF9pcnErMHhlNy8weDEyNApbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxYjA0NTcx
Pl0gPyBpYm1hc21faW5pdCsweDc1LzB4NzUKWyAgICAxLjEwNzI0OV0gIFs8ZmZmZmZmZmY4
MWIwNDU3MT5dID8gaWJtYXNtX2luaXQrMHg3NS8weDc1ClsgICAgMS4xMDcyNDldICBbPGZm
ZmZmZmZmODFiMDQ1OWQ+XSBkdW1teV9pcnFfaW5pdCsweDJjLzB4NjAKWyAgICAxLjEwNzI0
OV0gIFs8ZmZmZmZmZmY4MWIwNDU5ZD5dIGR1bW15X2lycV9pbml0KzB4MmMvMHg2MApbICAg
IDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxYWQ5ZTMwPl0gZG9fb25lX2luaXRjYWxsKzB4Nzgv
MHgxNDIKWyAgICAxLjEwNzI0OV0gIFs8ZmZmZmZmZmY4MWFkOWUzMD5dIGRvX29uZV9pbml0
Y2FsbCsweDc4LzB4MTQyClsgICAgMS4xMDcyNDldICBbPGZmZmZmZmZmODFhZDlmZjI+XSBr
ZXJuZWxfaW5pdF9mcmVlYWJsZSsweGY4LzB4MTczClsgICAgMS4xMDcyNDldICBbPGZmZmZm
ZmZmODFhZDlmZjI+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGY4LzB4MTczClsgICAgMS4x
MDcyNDldICBbPGZmZmZmZmZmODFhZDk3MGQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4
OApbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxYWQ5NzBkPl0gPyBkb19lYXJseV9wYXJh
bSsweDg4LzB4ODgKWyAgICAxLjEwNzI0OV0gIFs8ZmZmZmZmZmY4MTY4Mzk0Zj5dID8gcmVz
dF9pbml0KzB4ZDMvMHhkMwpbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgxNjgzOTRmPl0g
PyByZXN0X2luaXQrMHhkMy8weGQzClsgICAgMS4xMDcyNDldICBbPGZmZmZmZmZmODE2ODM5
NWQ+XSBrZXJuZWxfaW5pdCsweGUvMHhkMQpbICAgIDEuMTA3MjQ5XSAgWzxmZmZmZmZmZjgx
NjgzOTVkPl0ga2VybmVsX2luaXQrMHhlLzB4ZDEKWyAgICAxLjEwNzI0OV0gIFs8ZmZmZmZm
ZmY4MTY5MGQ3YT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMS4xMDcyNDldICBb
PGZmZmZmZmZmODE2OTBkN2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDEuMTA3
MjQ5XSAgWzxmZmZmZmZmZjgxNjgzOTRmPl0gPyByZXN0X2luaXQrMHhkMy8weGQzClsgICAg
MS4xMDcyNDldICBbPGZmZmZmZmZmODE2ODM5NGY+XSA/IHJlc3RfaW5pdCsweGQzLzB4ZDMK
WyAgICAxLjEyNzk5Ml0gZHVtbXktaXJxOiBjYW5ub3QgcmVnaXN0ZXIgSVJRIDAKWyAgICAx
LjEyNzk5Ml0gZHVtbXktaXJxOiBjYW5ub3QgcmVnaXN0ZXIgSVJRIDAKWyAgICAxLjEyOTE1
MF0gUGhhbnRvbSBMaW51eCBEcml2ZXIsIHZlcnNpb24gbjAuOS44LCBpbml0IE9LCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2M5ZWY3MTM5OTNiYTE2OGIzOGQx
YTk3ZWEwYWIwMDg3NGYxZGEwMjIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xODoyMDE0MDMy
MDE2NDYzMTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My45LjAtMDQzNjUtZ2M5
ZWY3MTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9jOWVmNzEz
OTkzYmExNjhiMzhkMWE5N2VhMGFiMDA4NzRmMWRhMDIyL2RtZXNnLXlvY3RvLWl2eXRvd24y
LTI4OjIwMTQwMzIwMTY0NjM2Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjku
MC0wNDM2NS1nYzllZjcxMzoxCjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTAzLTIwIDE2OjQ2OjQ1IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA5OTYgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbMjQw
YzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUxMWIzNV0gTWVyZ2UgYnJhbmNoICd2
NGxfZm9yX2xpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbWNoZWhhYi9saW51eC1tZWRpYQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOjI0
MGMzYzM0MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzU6YmlzZWN0LWxpbnV4NAoK
MjAxNC0wMy0yMC0xNjo0Njo0NiAyNDBjM2MzNDI0MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRl
NTExYjM1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS0yNDBjM2MzNDI0MzY2
YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMjQwYzNjMzQyNDM2NmM4MTA5YmFi
ZDJhMGZlODA4NTVkZTUxMWIzNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTI0MGMz
YzM0MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDEtMjQwYzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUxMWIzNQpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0
MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUvdm1saW51ei0zLjkuMC0wNDQ1Ni1n
MjQwYzNjMwoKMjAxNC0wMy0yMC0xNzowNDo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4g
VEVTVCBGQUlMVVJFClsgICAgMS40OTc2NDJdIGludGVsZmI6IFZlcnNpb24gMC45LjYKWyAg
ICAxLjQ5OTAyNV0gaWJtYXNtOiBJQk0gQVNNIFNlcnZpY2UgUHJvY2Vzc29yIERyaXZlciB2
ZXJzaW9uIDEuMCBsb2FkZWQKWyAgICAxLjQ5OTAyNV0gaWJtYXNtOiBJQk0gQVNNIFNlcnZp
Y2UgUHJvY2Vzc29yIERyaXZlciB2ZXJzaW9uIDEuMCBsb2FkZWQKWyAgICAxLjUwMTQ3NV0g
Z2VuaXJxOiBGbGFncyBtaXNtYXRjaCBpcnEgMC4gMDAwMDAwODAgKGR1bW15X2lycSkgdnMu
IDAwMDE1YTIwICh0aW1lcikKWyAgICAxLjUwMTQ3NV0gZ2VuaXJxOiBGbGFncyBtaXNtYXRj
aCBpcnEgMC4gMDAwMDAwODAgKGR1bW15X2lycSkgdnMuIDAwMDE1YTIwICh0aW1lcikKWyAg
ICAxLjUwMjQ1OV0gUGlkOiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuOS4wLTA0
NDU2LWcyNDBjM2MzICMxClsgICAgMS41MDI0NTldIFBpZDogMSwgY29tbTogc3dhcHBlciBO
b3QgdGFpbnRlZCAzLjkuMC0wNDQ1Ni1nMjQwYzNjMyAjMQpbICAgIDEuNTAyNDU5XSBDYWxs
IFRyYWNlOgpbICAgIDEuNTAyNDU5XSBDYWxsIFRyYWNlOgpbICAgIDEuNTAyNDU5XSAgWzxm
ZmZmZmZmZjgxMDk4ZWNiPl0gX19zZXR1cF9pcnErMHgzMjMvMHgzODcKWyAgICAxLjUwMjQ1
OV0gIFs8ZmZmZmZmZmY4MTA5OGVjYj5dIF9fc2V0dXBfaXJxKzB4MzIzLzB4Mzg3ClsgICAg
MS41MDI0NTldICBbPGZmZmZmZmZmODEzZThjZmU+XSA/IGFkX2Rwb3RfcmVtb3ZlKzB4YmMv
MHhiYwpbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxM2U4Y2ZlPl0gPyBhZF9kcG90X3Jl
bW92ZSsweGJjLzB4YmMKWyAgICAxLjUwMjQ1OV0gIFs8ZmZmZmZmZmY4MTA5OTE0ZD5dIHJl
cXVlc3RfdGhyZWFkZWRfaXJxKzB4ZTcvMHgxMjQKWyAgICAxLjUwMjQ1OV0gIFs8ZmZmZmZm
ZmY4MTA5OTE0ZD5dIHJlcXVlc3RfdGhyZWFkZWRfaXJxKzB4ZTcvMHgxMjQKWyAgICAxLjUw
MjQ1OV0gIFs8ZmZmZmZmZmY4MWIwNDU3MT5dID8gaWJtYXNtX2luaXQrMHg3NS8weDc1Clsg
ICAgMS41MDI0NTldICBbPGZmZmZmZmZmODFiMDQ1NzE+XSA/IGlibWFzbV9pbml0KzB4NzUv
MHg3NQpbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxYjA0NTlkPl0gZHVtbXlfaXJxX2lu
aXQrMHgyYy8weDYwClsgICAgMS41MDI0NTldICBbPGZmZmZmZmZmODFiMDQ1OWQ+XSBkdW1t
eV9pcnFfaW5pdCsweDJjLzB4NjAKWyAgICAxLjUwMjQ1OV0gIFs8ZmZmZmZmZmY4MWFkOWUz
MD5dIGRvX29uZV9pbml0Y2FsbCsweDc4LzB4MTQyClsgICAgMS41MDI0NTldICBbPGZmZmZm
ZmZmODFhZDllMzA+XSBkb19vbmVfaW5pdGNhbGwrMHg3OC8weDE0MgpbICAgIDEuNTAyNDU5
XSAgWzxmZmZmZmZmZjgxYWQ5ZmYyPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhmOC8weDE3
MwpbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxYWQ5ZmYyPl0ga2VybmVsX2luaXRfZnJl
ZWFibGUrMHhmOC8weDE3MwpbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxYWQ5NzBkPl0g
PyBkb19lYXJseV9wYXJhbSsweDg4LzB4ODgKWyAgICAxLjUwMjQ1OV0gIFs8ZmZmZmZmZmY4
MWFkOTcwZD5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMS41MDI0NTldICBb
PGZmZmZmZmZmODE2ODM5MWY+XSA/IHJlc3RfaW5pdCsweGQzLzB4ZDMKWyAgICAxLjUwMjQ1
OV0gIFs8ZmZmZmZmZmY4MTY4MzkxZj5dID8gcmVzdF9pbml0KzB4ZDMvMHhkMwpbICAgIDEu
NTAyNDU5XSAgWzxmZmZmZmZmZjgxNjgzOTJkPl0ga2VybmVsX2luaXQrMHhlLzB4ZDEKWyAg
ICAxLjUwMjQ1OV0gIFs8ZmZmZmZmZmY4MTY4MzkyZD5dIGtlcm5lbF9pbml0KzB4ZS8weGQx
ClsgICAgMS41MDI0NTldICBbPGZmZmZmZmZmODE2OTBkM2E+XSByZXRfZnJvbV9mb3JrKzB4
N2EvMHhiMApbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxNjkwZDNhPl0gcmV0X2Zyb21f
Zm9yaysweDdhLzB4YjAKWyAgICAxLjUwMjQ1OV0gIFs8ZmZmZmZmZmY4MTY4MzkxZj5dID8g
cmVzdF9pbml0KzB4ZDMvMHhkMwpbICAgIDEuNTAyNDU5XSAgWzxmZmZmZmZmZjgxNjgzOTFm
Pl0gPyByZXN0X2luaXQrMHhkMy8weGQzClsgICAgMS41MzE1NjNdIGR1bW15LWlycTogY2Fu
bm90IHJlZ2lzdGVyIElSUSAwClsgICAgMS41MzE1NjNdIGR1bW15LWlycTogY2Fubm90IHJl
Z2lzdGVyIElSUSAwClsgICAgMS41MzMyMDNdIFBoYW50b20gTGludXggRHJpdmVyLCB2ZXJz
aW9uIG4wLjkuOCwgaW5pdCBPSwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS8yNDBjM2MzNDI0MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1L2RtZXNnLXF1
YW50YWwtaXZ5dG93bjItMTM6MjAxNDAzMjAxNzA1NTY6eDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxOjMuOS4wLTA0NDU2LWcyNDBjM2MzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDEvMjQwYzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUx
MWIzNS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTI0OjIwMTQwMzIwMTcwNTU5Ong4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQwYzNjMzoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0MjQzNjZjODEwOWJhYmQy
YTBmZTgwODU1ZGU1MTFiMzUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yODoyMDE0MDMyMDE3
MDU1Mzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My45LjAtMDQ0NTYtZzI0MGMz
YzM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8yNDBjM2MzNDI0
MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTE6
MjAxNDAzMjAxNzA2MDA6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuOS4wLTA0
NDU2LWcyNDBjM2MzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEv
MjQwYzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUxMWIzNS9kbWVzZy15b2N0by1p
dnl0b3duMi0zMToyMDE0MDMyMDE3MDU1Mzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDE6My45LjAtMDQ0NTYtZzI0MGMzYzM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS8yNDBjM2MzNDI0MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1L2Rt
ZXNnLXF1YW50YWwtaXZ5dG93bjItNDoyMDE0MDMyMDE3MDYwMTp4ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDE6My45LjAtMDQ0NTYtZzI0MGMzYzM6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS8yNDBjM2MzNDI0MzY2YzgxMDliYWJkMmEwZmU4MDg1
NWRlNTExYjM1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI5OjIwMTQwMzIwMTcwNjAyOng4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQwYzNjMzoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0MjQzNjZjODEwOWJh
YmQyYTBmZTgwODU1ZGU1MTFiMzUvZG1lc2cteW9jdG8taXZ5dG93bjItNzoyMDE0MDMyMDE3
MDYwMTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My45LjAtMDQ0NTYtZzI0MGMz
YzM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8yNDBjM2MzNDI0
MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1L2RtZXNnLXF1YW50YWwtaXZ5dG93bjIt
MTU6MjAxNDAzMjAxNzA2MDY6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuOS4w
LTA0NDU2LWcyNDBjM2MzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvMjQwYzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUxMWIzNS9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTE2OjIwMTQwMzIwMTcwNjA2Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQwYzNjMzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFi
MzUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zOjIwMTQwMzIwMTcwNjAzOng4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQwYzNjMzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0MjQzNjZjODEwOWJhYmQyYTBm
ZTgwODU1ZGU1MTFiMzUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi01OjIwMTQwMzIwMTcwNjA4
Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQwYzNjMzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0MjQzNjZj
ODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIw
MTQwMzIwMTcwNjA3Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1
Ni1nMjQwYzNjMzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0
MGMzYzM0MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUvZG1lc2cteW9jdG8taXZ5
dG93bjItMjE6MjAxNDAzMjAxNzA2MTE6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAx
OjMuOS4wLTA0NDU2LWcyNDBjM2MzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvMjQwYzNjMzQyNDM2NmM4MTA5YmFiZDJhMGZlODA4NTVkZTUxMWIzNS9kbWVz
Zy15b2N0by1pdnl0b3duMi0yNzoyMDE0MDMyMDE3MDYwNjp4ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDE6My45LjAtMDQ0NTYtZzI0MGMzYzM6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXdhMS0wMzIwMDIwMS8yNDBjM2MzNDI0MzY2YzgxMDliYWJkMmEwZmU4MDg1NWRl
NTExYjM1L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTA6MjAxNDAzMjAxNzA2MTM6eDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuOS4wLTA0NDU2LWcyNDBjM2MzOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMjQwYzNjMzQyNDM2NmM4MTA5YmFi
ZDJhMGZlODA4NTVkZTUxMWIzNS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTI1OjIwMTQwMzIw
MTcwNjEzOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjkuMC0wNDQ1Ni1nMjQw
YzNjMzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzI0MGMzYzM0
MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUvZG1lc2ctcXVhbnRhbC1pdnl0b3du
Mi0yOToyMDE0MDMyMDE3MDYxMzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My45
LjAtMDQ0NTYtZzI0MGMzYzM6MQowOjE4OjE4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTAzLTIwIDE3OjA2OjE4IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA5MzYg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpb
NWQ0MzRmY2IyNTVkZWM5OTE4OWYxYzU4YTA2ZTRmNTZlMTJiZjc3ZF0gTWVyZ2UgYnJhbmNo
ICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9qaWtvcy90cml2aWFsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDE6NWQ0MzRmY2Iy
NTVkZWM5OTE4OWYxYzU4YTA2ZTRmNTZlMTJiZjc3ZDpiaXNlY3QtbGludXg0CgoyMDE0LTAz
LTIwLTE3OjA2OjE4IDVkNDM0ZmNiMjU1ZGVjOTkxODlmMWM1OGEwNmU0ZjU2ZTEyYmY3N2Qg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTVkNDM0ZmNiMjU1ZGVjOTkxODlm
MWM1OGEwNmU0ZjU2ZTEyYmY3N2QKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS81ZDQzNGZjYjI1NWRlYzk5MTg5ZjFjNThhMDZl
NGY1NmUxMmJmNzdkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtNWQ0MzRmY2IyNTVk
ZWM5OTE4OWYxYzU4YTA2ZTRmNTZlMTJiZjc3ZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLzVkNDM0ZmNiMjU1ZGVjOTkxODlmMWM1OGEwNmU0ZjU2
ZTEyYmY3N2Qvdm1saW51ei0zLjkuMC0wMzQxNi1nNWQ0MzRmYwoKMjAxNC0wMy0yMC0xNzox
NjoxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEJMTQJMjAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiA4ODkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0
ZXBzKQpbMTliMzQ0ZWZhMzVkYmMyNTNlMmQxMDQwM2RhZmU2YWFmZGE3M2M1Nl0gTWVyZ2Ug
YnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9qaWtvcy9oaWQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwMToxOWIzNDRl
ZmEzNWRiYzI1M2UyZDEwNDAzZGFmZTZhYWZkYTczYzU2OmJpc2VjdC1saW51eDQKCjIwMTQt
MDMtMjAtMTc6MTg6MjAgMTliMzQ0ZWZhMzVkYmMyNTNlMmQxMDQwM2RhZmU2YWFmZGE3M2M1
NiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtMTliMzQ0ZWZhMzVkYmMyNTNl
MmQxMDQwM2RhZmU2YWFmZGE3M2M1NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzE5YjM0NGVmYTM1ZGJjMjUzZTJkMTA0MDNk
YWZlNmFhZmRhNzNjNTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS0xOWIzNDRlZmEz
NWRiYzI1M2UyZDEwNDAzZGFmZTZhYWZkYTczYzU2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLTE5YjM0NGVmYTM1ZGJjMjUzZTJkMTA0MDNkYWZlNmFhZmRhNzNjNTYKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8xOWIzNDRlZmEzNWRi
YzI1M2UyZDEwNDAzZGFmZTZhYWZkYTczYzU2L3ZtbGludXotMy45LjAtMDM0NjYtZzE5YjM0
NGUKCjIwMTQtMDMtMjAtMTc6Mjc6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUND
RVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBicmFuY2ggJ3Y0bF9mb3Jf
bGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9tY2hlaGFiL2xpbnV4LW1lZGlhCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdp
dCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAyNDBjM2MzNDI0MzY2
YzgxMDliYWJkMmEwZmU4MDg1NWRlNTExYjM1IDE5YjM0NGVmYTM1ZGJjMjUzZTJkMTA0MDNk
YWZlNmFhZmRhNzNjNTYgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTliMzQ0ZS4u
LiBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2ppa29zL2hpZApIRUFEIGlzIG5vdyBhdCA4ZTZhNWYx
Li4uIE1lcmdlIGJyYW5jaCAnYWtwbS1jdXJyZW50L2N1cnJlbnQnCkJpc2VjdGluZzogNDE5
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpb
ZDNiMmNjZDllMzA3ZWFlODBiNGI0ZWViMGVkZTQ2Y2IwMjIxMmRmMl0gW21lZGlhXSBzMjI1
MDogY29udmVydCB0byB0aGUgY29udHJvbCBmcmFtZXdvcmsKbGluZWFyLWJpc2VjdDogZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIw
MDE6ZDNiMmNjZDllMzA3ZWFlODBiNGI0ZWViMGVkZTQ2Y2IwMjIxMmRmMjpiaXNlY3QtbGlu
dXg0CgoyMDE0LTAzLTIwLTE3OjMwOjQyIGQzYjJjY2Q5ZTMwN2VhZTgwYjRiNGVlYjBlZGU0
NmNiMDIyMTJkZjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWQzYjJjY2Q5
ZTMwN2VhZTgwYjRiNGVlYjBlZGU0NmNiMDIyMTJkZjIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9kM2IyY2NkOWUzMDdlYWU4
MGI0YjRlZWIwZWRlNDZjYjAyMjEyZGYyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEt
ZDNiMmNjZDllMzA3ZWFlODBiNGI0ZWViMGVkZTQ2Y2IwMjIxMmRmMgp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMS1kM2IyY2NkOWUzMDdlYWU4MGI0YjRlZWIwZWRlNDZjYjAyMjEy
ZGYyCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0yMC0xODowMTo0MiBkM2Iy
Y2NkOWUzMDdlYWU4MGI0YjRlZWIwZWRlNDZjYjAyMjEyZGYyIFNLSVAgQlJPS0VOIEJVSUxE
Ck5vIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9k
M2IyY2NkOWUzMDdlYWU4MGI0YjRlZWIwZWRlNDZjYjAyMjEyZGYyCkJpc2VjdGluZzogNDE4
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpb
YmFlNzQzMjA2MDk2MGRkMGZmZGM0YmQ2Nzk4NmFjM2QxZjU3MzNiMF0gW21lZGlhXSBnbzcw
MDc6IGFkZCBwcmlvIGFuZCBjb250cm9sIGV2ZW50IHN1cHBvcnQKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGlu
dXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDAzMjAwMTpiYWU3NDMyMDYwOTYwZGQwZmZkYzRiZDY3OTg2YWMzZDFmNTczM2IwOmJpc2Vj
dC1saW51eDQKCjIwMTQtMDMtMjAtMTg6MDE6NDQgYmFlNzQzMjA2MDk2MGRkMGZmZGM0YmQ2
Nzk4NmFjM2QxZjU3MzNiMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYmFl
NzQzMjA2MDk2MGRkMGZmZGM0YmQ2Nzk4NmFjM2QxZjU3MzNiMApDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2JhZTc0MzIwNjA5
NjBkZDBmZmRjNGJkNjc5ODZhYzNkMWY1NzMzYjAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS1iYWU3NDMyMDYwOTYwZGQwZmZkYzRiZDY3OTg2YWMzZDFmNTczM2IwCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLWJhZTc0MzIwNjA5NjBkZDBmZmRjNGJkNjc5ODZhYzNk
MWY1NzMzYjAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS9iYWU3NDMyMDYwOTYwZGQwZmZkYzRiZDY3OTg2YWMzZDFmNTczM2IwL3ZtbGludXotMy45
LjAtcmMxLTAwNDIwLWdiYWU3NDMyCgoyMDE0LTAzLTIwLTE5OjIzOjQ0IGRldGVjdGluZyBi
b290IHN0YXRlIAkzCTExCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjA4IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbODI0NTY3MDgz
ODlkNmQ5ZWI4MWE0NDc5ZDU0ZWZhMGJmN2RkOGJmM10gW21lZGlhXSBzYWE3MTM0OiB2NGwy
LWNvbXBsaWFuY2U6IGRvbid0IHJlcG9ydCBpbnZhbGlkIGF1ZGlvIG1vZGVzIGZvciByYWRp
bwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOjgyNDU2NzA4Mzg5ZDZkOWViODFhNDQ3OWQ1NGVm
YTBiZjdkZDhiZjM6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0xOToyNTo0NSA4MjQ1Njcw
ODM4OWQ2ZDllYjgxYTQ0NzlkNTRlZmEwYmY3ZGQ4YmYzIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMS04MjQ1NjcwODM4OWQ2ZDllYjgxYTQ0NzlkNTRlZmEwYmY3ZGQ4YmYz
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvODI0NTY3MDgzODlkNmQ5ZWI4MWE0NDc5ZDU0ZWZhMGJmN2RkOGJmMwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxLTgyNDU2NzA4Mzg5ZDZkOWViODFhNDQ3OWQ1NGVmYTBi
ZjdkZDhiZjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtODI0NTY3MDgzODlkNmQ5
ZWI4MWE0NDc5ZDU0ZWZhMGJmN2RkOGJmMwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzgyNDU2NzA4Mzg5ZDZkOWViODFhNDQ3OWQ1NGVmYTBiZjdk
ZDhiZjMvdm1saW51ei0zLjkuMC1yYzUtMDA2MzAtZzgyNDU2NzAKCjIwMTQtMDMtMjAtMTk6
NTE6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJMTYJMjAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiAxMDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3Rl
cHMpCltiMzRmNTFmYWQzOTY0ODRlMmJjMTAyZGNmOTU4MDdiOTk5MGMzMjY1XSBbbWVkaWFd
IGV4eW5vczQtaXM6IEZpeCBydW50aW1lIFBNIGhhbmRsaW5nIG9uIGZpbWMtaXMgcHJvYmUg
ZXJyb3IgcGF0aApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOmIzNGY1MWZhZDM5NjQ4NGUyYmMx
MDJkY2Y5NTgwN2I5OTkwYzMyNjU6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0xOTo1Mzox
NyBiMzRmNTFmYWQzOTY0ODRlMmJjMTAyZGNmOTU4MDdiOTk5MGMzMjY1IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS1iMzRmNTFmYWQzOTY0ODRlMmJjMTAyZGNmOTU4MDdi
OTk5MGMzMjY1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEvYjM0ZjUxZmFkMzk2NDg0ZTJiYzEwMmRjZjk1ODA3Yjk5OTBjMzI2
NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWIzNGY1MWZhZDM5NjQ4NGUyYmMxMDJk
Y2Y5NTgwN2I5OTkwYzMyNjUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYjM0ZjUx
ZmFkMzk2NDg0ZTJiYzEwMmRjZjk1ODA3Yjk5OTBjMzI2NQprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2IzNGY1MWZhZDM5NjQ4NGUyYmMxMDJkY2Y5
NTgwN2I5OTkwYzMyNjUvdm1saW51ei0zLjkuMC1yYzUtMDA3MzQtZ2IzNGY1MWYKCjIwMTQt
MDMtMjAtMjA6MjU6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxCTgJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA1MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNiBzdGVwcykKWzk2NmExNjAxODc3YzNkMjkwNjVhYjJkZGU4MzhjZGFlMTZjY2MwOTld
IE1lcmdlIGJyYW5jaCAndG9waWMvc2k0NzZ4JyBpbnRvIHBhdGNod29yawpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDMyMDAxOjk2NmExNjAxODc3YzNkMjkwNjVhYjJkZGU4MzhjZGFlMTZjY2MwOTk6
YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0yMDoyNzoxOCA5NjZhMTYwMTg3N2MzZDI5MDY1
YWIyZGRlODM4Y2RhZTE2Y2NjMDk5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS05NjZhMTYwMTg3N2MzZDI5MDY1YWIyZGRlODM4Y2RhZTE2Y2NjMDk5CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvOTY2YTE2
MDE4NzdjM2QyOTA2NWFiMmRkZTgzOGNkYWUxNmNjYzA5OQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxLTk2NmExNjAxODc3YzNkMjkwNjVhYjJkZGU4MzhjZGFlMTZjY2MwOTkKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtOTY2YTE2MDE4NzdjM2QyOTA2NWFiMmRkZTgz
OGNkYWUxNmNjYzA5OQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLzk2NmExNjAxODc3YzNkMjkwNjVhYjJkZGU4MzhjZGFlMTZjY2MwOTkvdm1saW51
ei0zLjkuMC1yYzUtMDA3ODgtZzk2NmExNjAKCjIwMTQtMDMtMjAtMjA6NTI6MTggZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTEJMwkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI1IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbMWYxOTg4NzA2
ZDc3MDgzMDQwMTEzMDk0YTRiZWUyZTllMWJkYzM0Zl0gW21lZGlhXSBjeDI1ODIxOiBzZXR1
cCBvdXRwdXQgbm9kZXMgY29ycmVjdGx5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDE6MWYxOTg4
NzA2ZDc3MDgzMDQwMTEzMDk0YTRiZWUyZTllMWJkYzM0ZjpiaXNlY3QtbGludXg0CgoyMDE0
LTAzLTIwLTIwOjUzOjQ5IDFmMTk4ODcwNmQ3NzA4MzA0MDExMzA5NGE0YmVlMmU5ZTFiZGMz
NGYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTFmMTk4ODcwNmQ3NzA4MzA0
MDExMzA5NGE0YmVlMmU5ZTFiZGMzNGYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8xZjE5ODg3MDZkNzcwODMwNDAxMTMwOTRh
NGJlZTJlOWUxYmRjMzRmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtMWYxOTg4NzA2
ZDc3MDgzMDQwMTEzMDk0YTRiZWUyZTllMWJkYzM0Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMS0xZjE5ODg3MDZkNzcwODMwNDAxMTMwOTRhNGJlZTJlOWUxYmRjMzRmCmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMWYxOTg4NzA2ZDc3
MDgzMDQwMTEzMDk0YTRiZWUyZTllMWJkYzM0Zi92bWxpbnV6LTMuOS4wLXJjNS0wMDcyMC1n
MWYxOTg4NwoKMjAxNC0wMy0yMC0yMToxMDo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMy4J
MjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2M4MjA1NmQwYjRhYzdiODA1YWM0ZTdkMzg3MGM0
MmJiMTllM2IzZDVdIFttZWRpYV0gZGliODAwMDogc3RvcmUgZHR2X3Byb3BlcnR5X2NhY2hl
IGluIGEgdGVtcCB2YXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwMTpjODIwNTZkMGI0YWM3Yjgw
NWFjNGU3ZDM4NzBjNDJiYjE5ZTNiM2Q1OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMjAtMjE6
MTI6MjAgYzgyMDU2ZDBiNGFjN2I4MDVhYzRlN2QzODcwYzQyYmIxOWUzYjNkNSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYzgyMDU2ZDBiNGFjN2I4MDVhYzRlN2QzODcw
YzQyYmIxOWUzYjNkNQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxL2M4MjA1NmQwYjRhYzdiODA1YWM0ZTdkMzg3MGM0MmJiMTll
M2IzZDUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1jODIwNTZkMGI0YWM3YjgwNWFj
NGU3ZDM4NzBjNDJiYjE5ZTNiM2Q1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWM4
MjA1NmQwYjRhYzdiODA1YWM0ZTdkMzg3MGM0MmJiMTllM2IzZDUKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9jODIwNTZkMGI0YWM3YjgwNWFjNGU3
ZDM4NzBjNDJiYjE5ZTNiM2Q1L3ZtbGludXotMy45LjAtcmM1LTAwODI2LWdjODIwNTZkCgoy
MDE0LTAzLTIwLTIxOjMxOjIwIGRldGVjdGluZyBib290IHN0YXRlIC4JMTEJMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAzIHN0ZXBzKQpbYTNmMTdhZjJkOTdhMmE1MWFmMzdlN2IxZGFiNWRlNTU2MmM5YjY2
ZF0gW21lZGlhXSBjeDI1ODIxLXZpZGVvOiBkZWNsYXJlIGN4MjU4MjFfdmlkaW9jX3Nfc3Rk
IGFzIHN0YXRpYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOmEzZjE3YWYyZDk3YTJhNTFhZjM3
ZTdiMWRhYjVkZTU1NjJjOWI2NmQ6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0yMTozMjo1
MSBhM2YxN2FmMmQ5N2EyYTUxYWYzN2U3YjFkYWI1ZGU1NTYyYzliNjZkIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS1hM2YxN2FmMmQ5N2EyYTUxYWYzN2U3YjFkYWI1ZGU1
NTYyYzliNjZkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDEvYTNmMTdhZjJkOTdhMmE1MWFmMzdlN2IxZGFiNWRlNTU2MmM5YjY2
ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWEzZjE3YWYyZDk3YTJhNTFhZjM3ZTdi
MWRhYjVkZTU1NjJjOWI2NmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYTNmMTdh
ZjJkOTdhMmE1MWFmMzdlN2IxZGFiNWRlNTU2MmM5YjY2ZAprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2EzZjE3YWYyZDk3YTJhNTFhZjM3ZTdiMWRh
YjVkZTU1NjJjOWI2NmQvdm1saW51ei0zLjkuMC1yYzUtMDA4MzItZ2EzZjE3YWYKCjIwMTQt
MDMtMjAtMjE6NDk6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTMuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMiByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzAyNjE1ZWQ1
ZTFiMjI4M2RiMjQ5NWFmM2NmOGY0ZWUxNzJjNzdkODBdIFttZWRpYV0gY3g4ODogbWFrZSBj
b3JlIGxlc3MgdmVyYm9zZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOjAyNjE1ZWQ1ZTFiMjI4
M2RiMjQ5NWFmM2NmOGY0ZWUxNzJjNzdkODA6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0y
MjozNjoyMiAwMjYxNWVkNWUxYjIyODNkYjI0OTVhZjNjZjhmNGVlMTcyYzc3ZDgwIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS0wMjYxNWVkNWUxYjIyODNkYjI0OTVhZjNj
ZjhmNGVlMTcyYzc3ZDgwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvMDI2MTVlZDVlMWIyMjgzZGIyNDk1YWYzY2Y4ZjRlZTE3
MmM3N2Q4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTAyNjE1ZWQ1ZTFiMjI4M2Ri
MjQ5NWFmM2NmOGY0ZWUxNzJjNzdkODAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEt
MDI2MTVlZDVlMWIyMjgzZGIyNDk1YWYzY2Y4ZjRlZTE3MmM3N2Q4MAprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzAyNjE1ZWQ1ZTFiMjI4M2RiMjQ5
NWFmM2NmOGY0ZWUxNzJjNzdkODAvdm1saW51ei0zLjkuMC1yYzUtMDA4MzYtZzAyNjE1ZWQ1
CgoyMDE0LTAzLTIwLTIyOjQ4OjIyIGRldGVjdGluZyBib290IHN0YXRlIAkxCTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxIHN0ZXApClthYWQ3OTdjODk5MDNkNTcwYzE3ZjZhZmZjNzcwZWI5OGFmZDc0ZTYy
XSBNZXJnZSB0YWcgJ3YzLjknIGludG8gdjRsX2Zvcl9saW51cwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDMyMDAxOmFhZDc5N2M4OTkwM2Q1NzBjMTdmNmFmZmM3NzBlYjk4YWZkNzRlNjI6YmlzZWN0
LWxpbnV4NAoKMjAxNC0wMy0yMC0yMjo0OToyMyBhYWQ3OTdjODk5MDNkNTcwYzE3ZjZhZmZj
NzcwZWI5OGFmZDc0ZTYyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1hYWQ3
OTdjODk5MDNkNTcwYzE3ZjZhZmZjNzcwZWI5OGFmZDc0ZTYyCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvYWFkNzk3Yzg5OTAz
ZDU3MGMxN2Y2YWZmYzc3MGViOThhZmQ3NGU2Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxLWFhZDc5N2M4OTkwM2Q1NzBjMTdmNmFmZmM3NzBlYjk4YWZkNzRlNjIKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEtYWFkNzk3Yzg5OTAzZDU3MGMxN2Y2YWZmYzc3MGViOThh
ZmQ3NGU2MgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAx
L2FhZDc5N2M4OTkwM2Q1NzBjMTdmNmFmZmM3NzBlYjk4YWZkNzRlNjIvdm1saW51ei0zLjku
MC0wMDAwMS1nYWFkNzk3YwoKMjAxNC0wMy0yMC0yMzozNjoyNCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTgJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZGY5MGUyMjU4OTUwZmQ2MzFjZGJm
MzIyYzFlZTFmMjIwNjgzOTFhYV0gTWVyZ2UgYnJhbmNoICdkZXZlbC1mb3ItdjMuMTAnIGlu
dG8gdjRsX2Zvcl9saW51cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOmRmOTBlMjI1ODk1MGZk
NjMxY2RiZjMyMmMxZWUxZjIyMDY4MzkxYWE6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMC0y
MzozNzo1NSBkZjkwZTIyNTg5NTBmZDYzMWNkYmYzMjJjMWVlMWYyMjA2ODM5MWFhIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS1kZjkwZTIyNTg5NTBmZDYzMWNkYmYzMjJj
MWVlMWYyMjA2ODM5MWFhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvZGY5MGUyMjU4OTUwZmQ2MzFjZGJmMzIyYzFlZTFmMjIw
NjgzOTFhYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLWRmOTBlMjI1ODk1MGZkNjMx
Y2RiZjMyMmMxZWUxZjIyMDY4MzkxYWEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEt
ZGY5MGUyMjU4OTUwZmQ2MzFjZGJmMzIyYzFlZTFmMjIwNjgzOTFhYQprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2RmOTBlMjI1ODk1MGZkNjMxY2Ri
ZjMyMmMxZWUxZjIyMDY4MzkxYWEvdm1saW51ei0zLjkuMC0wMDgzOC1nZGY5MGUyMgoKMjAx
NC0wMy0yMS0wMDozNzo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEwCTIwIFNVQ0NFU1MK
CjI0MGMzYzM0MjQzNjZjODEwOWJhYmQyYTBmZTgwODU1ZGU1MTFiMzUgaXMgdGhlIGZpcnN0
IGJhZCBjb21taXQKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDE6MTliMzQ0ZWZhMzVkYmMyNTNlMmQxMDQwM2RhZmU2
YWFmZGE3M2M1NjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTIxLTAwOjM5OjI3IDE5YjM0NGVm
YTM1ZGJjMjUzZTJkMTA0MDNkYWZlNmFhZmRhNzNjNTYgcmV1c2UgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMTliMzQ0ZWZhMzVkYmMyNTNlMmQxMDQwM2RhZmU2
YWFmZGE3M2M1Ni92bWxpbnV6LTMuOS4wLTAzNDY2LWcxOWIzNDRlCgoyMDE0LTAzLTIxLTAw
OjM5OjI3IGRldGVjdGluZyBib290IHN0YXRlIC4JNAkxMAkzMQk2MCBTVUNDRVNTCgpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDAxOmRmOTBlMjI1ODk1
MGZkNjMxY2RiZjMyMmMxZWUxZjIyMDY4MzkxYWE6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0y
MS0wMDo0MjowMCBkZjkwZTIyNTg5NTBmZDYzMWNkYmYzMjJjMWVlMWYyMjA2ODM5MWFhIHJl
dXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2RmOTBlMjI1ODk1
MGZkNjMxY2RiZjMyMmMxZWUxZjIyMDY4MzkxYWEvdm1saW51ei0zLjkuMC0wMDgzOC1nZGY5
MGUyMgoKMjAxNC0wMy0yMS0wMDo0MjowMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyNgk0
OAk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDMyMDAxOjBmMjY5MWMwODU2ZjZjYWExODI1ZjJiMzA3YjBkNzg2OTkwYzMwMGI6YmlzZWN0
LWxpbnV4NAogVEVTVCBGQUlMVVJFClsgICAgMy4xNzMxMzBdIGdfd2ViY2FtIGdhZGdldDog
dXZjX2Z1bmN0aW9uX2JpbmQKWyAgICAzLjE3NDcwNl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tClsgICAgMy4xNzQ3MDZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDMuMTc2MzQyXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0
IGRyaXZlcnMvbWVkaWEvdjRsMi1jb3JlL3ZpZGVvYnVmMi1jb3JlLmM6MjIwNyB2YjJfcXVl
dWVfaW5pdCsweGEzLzB4MTEzKCkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDEvMGYyNjkxYzA4NTZmNmNhYTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy15
b2N0by1jYWlyby00NzoyMDE0MDMyMDAzMzUxMzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xNC4wLXJjNy13bC1hdGgtMDQ0NTItZzBmMjY5MWM6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8wZjI2OTFjMDg1NmY2Y2FhMTgyNWYyYjMwN2Iw
ZDc4Njk5MGMzMDBiL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDQ6MjAxNDAzMjAwMzQ5MzY6eDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcw
ZjI2OTFjOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkx
YzA4NTZmNmNhYTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy1xdWFudGFsLWNhaXJv
LTQ1OjIwMTQwMzIwMDMzNTA3Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0
LjAtcmM3LXdsLWF0aC0wNDQ1Mi1nMGYyNjkxYzozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxLzBmMjY5MWMwODU2ZjZjYWExODI1ZjJiMzA3YjBkNzg2OTkwYzMw
MGIvZG1lc2cteW9jdG8tY2Fpcm8tMTE6MjAxNDAzMjAwMzM1MDU6eDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcwZjI2OTFjOjMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkxYzA4NTZmNmNhYTE4
MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy15b2N0by1pdnl0b3duMi0zMToyMDE0MDMy
MDAzNDk0Mzp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNy13bC1h
dGgtMDQ0NTItZzBmMjY5MWM6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIw
MDIwMS8wZjI2OTFjMDg1NmY2Y2FhMTgyNWYyYjMwN2IwZDc4Njk5MGMzMDBiL2RtZXNnLXF1
YW50YWwtaXZ5dG93bjItMTc6MjAxNDAzMjAwMzM1MTQ6eDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcwZjI2OTFjOjMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkxYzA4NTZmNmNhYTE4MjVmMmIz
MDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy15b2N0by1pdnl0b3duMi0yOToyMDE0MDMyMDAzMzUx
NTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNy13bC1hdGgtMDQ0
NTItZzBmMjY5MWM6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8w
ZjI2OTFjMDg1NmY2Y2FhMTgyNWYyYjMwN2IwZDc4Njk5MGMzMDBiL2RtZXNnLXF1YW50YWwt
Y2Fpcm8tMzc6MjAxNDAzMjAwMzQ5NDI6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAx
OjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcwZjI2OTFjOjMKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkxYzA4NTZmNmNhYTE4MjVmMmIzMDdiMGQ3ODY5
OTBjMzAwYi9kbWVzZy1xdWFudGFsLWNhaXJvLTE6MjAxNDAzMjAwMzQ5NDI6eDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcwZjI2OTFj
OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkxYzA4NTZm
NmNhYTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy1xdWFudGFsLWNhaXJvLTMxOjIw
MTQwMzIwMDM0OTQ5Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3
LXdsLWF0aC0wNDQ1Mi1nMGYyNjkxYzozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxLzBmMjY5MWMwODU2ZjZjYWExODI1ZjJiMzA3YjBkNzg2OTkwYzMwMGIvZG1l
c2ctcXVhbnRhbC1pdnl0b3duMi0yMDoyMDE0MDMyMDAzMzUxMzp4ODZfNjQtcmFuZGNvbmZp
Zy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNy13bC1hdGgtMDQ0NTItZzBmMjY5MWM6Mwova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8wZjI2OTFjMDg1NmY2Y2FhMTgy
NWYyYjMwN2IwZDc4Njk5MGMzMDBiL2RtZXNnLXF1YW50YWwtY2Fpcm8tMTM6MjAxNDAzMjAw
MzM1MTE6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRo
LTA0NDUyLWcwZjI2OTFjOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvMGYyNjkxYzA4NTZmNmNhYTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy15b2N0
by1pdnl0b3duMi0xOToyMDE0MDMyMDAzNDkxODp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xNC4wLXJjNy13bC1hdGgtMDQ0NTItZzBmMjY5MWM6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8wZjI2OTFjMDg1NmY2Y2FhMTgyNWYyYjMwN2Iw
ZDc4Njk5MGMzMDBiL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzA6MjAxNDAzMjAwMzQ5MzU6eDg2
XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcw
ZjI2OTFjOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkx
YzA4NTZmNmNhYTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy1xdWFudGFsLWl2eXRv
d24yLTIyOjIwMTQwMzIwMDMzNTEyOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMToz
LjE0LjAtcmM3LXdsLWF0aC0wNDQ1Mi1nMGYyNjkxYzozCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzBmMjY5MWMwODU2ZjZjYWExODI1ZjJiMzA3YjBkNzg2OTkw
YzMwMGIvZG1lc2cteW9jdG8tY2Fpcm8tMjI6MjAxNDAzMjAwMzQ5NTA6eDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctd2wtYXRoLTA0NDUyLWcwZjI2OTFjOjMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvMGYyNjkxYzA4NTZmNmNh
YTE4MjVmMmIzMDdiMGQ3ODY5OTBjMzAwYi9kbWVzZy15b2N0by1yb2FtLTM3OjIwMTQwMzIw
MDM0OTUzOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LXdsLWF0
aC0wNDQ1Mi1nMGYyNjkxYzozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAw
MjAxLzBmMjY5MWMwODU2ZjZjYWExODI1ZjJiMzA3YjBkNzg2OTkwYzMwMGIvZG1lc2ctcXVh
bnRhbC1jYWlyby0zNToyMDE0MDMyMDAzNDk0MDp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xNC4wLXJjNy13bC1hdGgtMDQ0NTItZzBmMjY5MWM6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS8wZjI2OTFjMDg1NmY2Y2FhMTgyNWYyYjMwN2Iw
ZDc4Njk5MGMzMDBiL2RtZXNnLXlvY3RvLWl2eXRvd24yLTIzOjIwMTQwMzIwMDMzNTIyOng4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LXdsLWF0aC0wNDQ1Mi1n
MGYyNjkxYzozCjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMg
bm93IGF0IDBmMjY5MWMgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQw
MzIwMDEnCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCkZy
b20gZ2l0Oi8vZ2l0bWlycm9yL2xpbnVzCiAgIGVhMWNkNjUuLjg4Nzg0MzkgIG1hc3RlciAg
ICAgLT4gbGludXMvbWFzdGVyClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDBmMjY5MWMu
Li4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDEnCkhFQUQg
aXMgbm93IGF0IDg4Nzg0MzkuLi4gbW06IGZpeCBiYWQgcnNzLWNvdW50ZXIgaWYgcmVtYXBf
ZmlsZV9wYWdlcyByYWNlZCBtaWdyYXRpb24KbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDAzMjAwMTo4ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0
YWE4MjUzOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMjEtMDA6NDQ6NDQgODg3ODQzOTYxYzRi
NDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEtODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1MwpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAx
Lzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMS04ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4
MjUzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLTg4Nzg0Mzk2MWM0YjQ2ODFlZTk5
M2MzNmQ0OTk3YmY0YjRhYTgyNTMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUz
L3ZtbGludXotMy4xNC4wLXJjNy0wMDAzMy1nODg3ODQzOQoKMjAxNC0wMy0yMS0wMToxODo0
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUKWyAgICAyLjkxMDk4M10g
Z193ZWJjYW0gZ2FkZ2V0OiB1dmNfZnVuY3Rpb25fYmluZApbICAgIDIuOTEyMTg2XSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjkxMjE4Nl0gLS0tLS0t
LS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi45MTM0MDhdIFdBUk5JTkc6
IENQVTogMCBQSUQ6IDEgYXQgZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdmlkZW9idWYyLWNv
cmUuYzoyMjA3IHZiMl9xdWV1ZV9pbml0KzB4YTMvMHgxMTMoKQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2Jm
NGI0YWE4MjUzL2RtZXNnLXlvY3RvLXJvYW0tMTU6MjAxNDAzMjEwMTE5MjY6eDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5
OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtYXRoZW5zLTEyOjIwMTQwMzIx
MDExOTM1Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMz
LWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3
ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLWF0
aGVucy0zMDoyMDE0MDMyMTAxMTkzMjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6
My4xNC4wLXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMv
ZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzk6MjAxNDAzMjEwMTE5MjY6eDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZk
NDk5N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtYXRoZW5zLTQ4OjIwMTQwMzIxMDExOTI3
Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4
NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYx
YzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLWl2eXRvd24y
LTIzOjIwMTQwMzIxMDExOTMyOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0
LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVz
Zy1xdWFudGFsLXJvYW0tNDM6MjAxNDAzMjEwMTE5MzQ6eDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2Jm
NGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtcm9hbS03OjIwMTQwMzIxMDExOTI2Ong4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVl
OTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLXhpYW4tMjU6MjAxNDAzMjEw
MTE5MzM6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMt
Zzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4
NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwteGlh
bi0zODoyMDE0MDMyMTAxMTkzMDp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4x
NC4wLXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2Ex
LTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMvZG1l
c2cteW9jdG8taW5uLTMyOjIwMTQwMzIxMDExOTMyOng4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzg4Nzg0
Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMvZG1lc2cteW9jdG8tcm9hbS00
MjoyMDE0MDMyMTAxMTkzNDp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4w
LXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMvZG1lc2ct
eW9jdG8tcm9hbS00NzoyMDE0MDMyMTAxMTkyNjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMy
MDAyMDE6My4xNC4wLXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRh
YTgyNTMvZG1lc2cteW9jdG8teGlhbi0xMToyMDE0MDMyMTAxMTkzMjp4ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2Mz
NmQ0OTk3YmY0YjRhYTgyNTMvZG1lc2cteW9jdG8teGlhbi0zOjIwMTQwMzIxMDExOTM0Ong4
Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRi
NDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy15b2N0by14aWFuLTQxOjIwMTQw
MzIxMDExOTMzOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAw
MDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEv
ODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy15b2N0by14
aWFuLTc6MjAxNDAzMjEwMTE5MzE6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMu
MTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tMTM6MjAxNDAzMjEwMTE5Mzc6eDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5
N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtaW5uLTEwOjIwMTQwMzIxMDExOTM5Ong4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zOjIwMTQwMzIxMDExOTM2Ong4Nl82NC1yYW5kY29u
ZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2
ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTU6MjAxNDAzMjEwMTE5
Mzg6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4
Nzg0Mzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5
NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtcm9hbS0z
NDoyMDE0MDMyMTAxMTkzODp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4w
LXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAz
MjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMvZG1lc2ct
cXVhbnRhbC14aWFuLTMyOjIwMTQwMzIxMDExOTM5Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRi
NGFhODI1My9kbWVzZy15b2N0by1hdGhlbnMtOToyMDE0MDMyMTAxMTkzOTp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6My4xNC4wLXJjNy0wMDAzMy1nODg3ODQzOToxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5
M2MzNmQ0OTk3YmY0YjRhYTgyNTMvZG1lc2cteW9jdG8taW5uLTQ1OjIwMTQwMzIxMDExOTM5
Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLzg4Nzg0Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRh
YTgyNTMvZG1lc2cteW9jdG8tamFrZXRvd24tMzQ6MjAxNDAzMjEwMTE5Mzc6eDg2XzY0LXJh
bmRjb25maWctd2ExLTAzMjAwMjAxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEt
MDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVz
Zy15b2N0by1yb2FtLTMzOjIwMTQwMzIxMDExOTM4Ong4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRi
NGFhODI1My9kbWVzZy15b2N0by1zdG9ha2xleS0xOjIwMTQwMzIxMDExOTM3Ong4Nl82NC1y
YW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVl
OTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLWF0aGVucy00OjIwMTQwMzIx
MDExOTQwOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMTozLjE0LjAtcmM3LTAwMDMz
LWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvODg3
ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9kbWVzZy1xdWFudGFsLWNh
aXJvLTEwOjIwMTQwMzIxMDExOTQwOng4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMToz
LjE0LjAtcmM3LTAwMDMzLWc4ODc4NDM5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13
YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFhODI1My9k
bWVzZy1xdWFudGFsLXJvYW0tMjg6MjAxNDAzMjEwMTE5NDE6eDg2XzY0LXJhbmRjb25maWct
d2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5
N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwtamFrZXRvd24tMTU6MjAxNDAzMjEwMTE5NDA6
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy13YTEtMDMyMDAyMDEvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5OTdiZjRiNGFh
ODI1My9kbWVzZy1xdWFudGFsLXhpYW4tMzA6MjAxNDAzMjEwMTE5NDI6eDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0Mzk6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFjNGI0NjgxZWU5OTNj
MzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXlvY3RvLXJvYW0tMjk6MjAxNDAzMjEwMTE5NDE6
eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0
Mzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS84ODc4NDM5NjFj
NGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXF1YW50YWwteGJtLTE6MjAx
NDAzMjEwMTE5NDI6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzct
MDAwMzMtZzg4Nzg0Mzk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIw
MS84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzL2RtZXNnLXlvY3Rv
LXNuYi0xMToyMDE0MDMyMTAxMTk0Mjp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6
OgowOjM2OjM2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgoKPT09PT09PT09IGxpbnV4
LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4
dAogKyA1NmRkMzViLi4uNzU2NzgyNCBha3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNl
ZCB1cGRhdGUpCiArIDZjMDNlOTIuLi4wMTYzMTlkIGFrcG0tYmFzZSAgLT4gbmV4dC9ha3Bt
LWJhc2UgIChmb3JjZWQgdXBkYXRlKQogKyA4NmM5OTBjLi4uYTY1NGRjNyBtYXN0ZXIgICAg
IC0+IG5leHQvbWFzdGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgNDkwN2NkYy4uODg3ODQzOSAg
c3RhYmxlICAgICAtPiBuZXh0L3N0YWJsZQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwMzIwIC0+IG5leHQtMjAxNDAzMjAKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODg3
ODQzOS4uLiBtbTogZml4IGJhZCByc3MtY291bnRlciBpZiByZW1hcF9maWxlX3BhZ2VzIHJh
Y2VkIG1pZ3JhdGlvbgpIRUFEIGlzIG5vdyBhdCBhNjU0ZGM3Li4uIEFkZCBsaW51eC1uZXh0
IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMyMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDMyMDAxOmE2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1
N2ZkZGIyZDg6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0yMS0wMToyMTowMiBhNjU0ZGM3OTdm
M2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMS1hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4CkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAy
MDEvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxLWE2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2Zk
ZGIyZDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDEtYTY1NGRjNzk3ZjNlYTFjYjU3
MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxL2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIy
ZDgvdm1saW51ei0zLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzcKCjIw
MTQtMDMtMjEtMDE6Mjk6MDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uIFRFU1QgRkFJTFVS
RQpbICAgIDIuMjMwMzMwXSBnX3dlYmNhbSBnYWRnZXQ6IHV2Y19mdW5jdGlvbl9iaW5kClsg
ICAgMi4yMzE2OTddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAg
IDIuMjMxNjk3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAy
LjIzMzAyN10gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBkcml2ZXJzL21lZGlhL3Y0bDIt
Y29yZS92aWRlb2J1ZjItY29yZS5jOjI1MDcgdmIyX3F1ZXVlX2luaXQrMHhhNC8weDExNCgp
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2E2NTRkYzc5N2YzZWEx
Y2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2cteW9jdG8taXZ5dG93bjItMTg6MjAx
NDAzMjEwMTMwMTM6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzct
bmV4dC0yMDE0MDMyMC0xMDc1My1nYTY1NGRjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctd2ExLTAzMjAwMjAxL2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIy
ZDgvZG1lc2cteW9jdG8taXZ5dG93bjItMzE6MjAxNDAzMjEwMTMwMTQ6eDg2XzY0LXJhbmRj
b25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMC0xMDc1My1nYTY1
NGRjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxL2E2NTRkYzc5
N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2ctcXVhbnRhbC1pdnl0b3du
Mi0xNToyMDE0MDMyMTAxMzAxOTp4ODZfNjQtcmFuZGNvbmZpZy13YTEtMDMyMDAyMDE6My4x
NC4wLXJjNy1uZXh0LTIwMTQwMzIwLTEwNzUzLWdhNjU0ZGM3OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy13YTEtMDMyMDAyMDEvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1
ZjU3ZmRkYjJkOC9kbWVzZy15b2N0by1pbm4tNDoyMDE0MDMyMTAxMzAxNjp4ODZfNjQtcmFu
ZGNvbmZpZy13YTEtMDMyMDAyMDE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0w
MzIwMDIwMS9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4L2RtZXNn
LXlvY3RvLWl2eXRvd24yLTExOjIwMTQwMzIxMDEzMDI3Ong4Nl82NC1yYW5kY29uZmlnLXdh
MS0wMzIwMDIwMTozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXdhMS0wMzIwMDIwMS9hNjU0ZGM3OTdmM2VhMWNi
NTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTU6MjAxNDAz
MjEwMTMwMjc6eDg2XzY0LXJhbmRjb25maWctd2ExLTAzMjAwMjAxOjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyMC0xMDc1My1nYTY1NGRjNzoxCjA6Njo2IGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgo=

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-wl-ath-04452-g0f2691c"

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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
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
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

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
# CONFIG_XEN is not set
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
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
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
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
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
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
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
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

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

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
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

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

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=y
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
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_RING=y

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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
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
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
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
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
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
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
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
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

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
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_TPS65910=y

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
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_CHARGER_88PM860X is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_ACPI_INT3403_THERMAL=y

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
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
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
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_S2MPA01 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
CONFIG_RADIO_SI470X=y
# CONFIG_USB_SI470X is not set
# CONFIG_I2C_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_MR800=y
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_SHARK=y
# CONFIG_RADIO_SHARK2 is not set
CONFIG_USB_KEENE=y
CONFIG_USB_RAREMONO=y
CONFIG_USB_MA901=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_TIMBERDALE=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set

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
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

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
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
# CONFIG_DRM_PTN3460 is not set
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
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_OT200=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y

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
# CONFIG_HID_BELKIN is not set
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
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
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
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_UX500=y
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=y
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=y
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
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
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
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
# CONFIG_TRANZPORT is not set
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
CONFIG_AD7291=y
# CONFIG_AD7606 is not set
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
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
# CONFIG_AD5933 is not set

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

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
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
CONFIG_ACPI_QUICKSTART=y
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_HP_ACCEL=y
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
# CONFIG_EXTCON_ADC_JACK is not set
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
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL4030_MADC=y
# CONFIG_TWL6030_GPADC is not set
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
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
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_VME_PIO2=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
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
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_X86_PTDUMP=y
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
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
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
CONFIG_CRYPTO_PCOMP=y
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
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--3MwIy2ne0vdjdPXF--
