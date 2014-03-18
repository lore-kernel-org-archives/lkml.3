Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaCROJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:09:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:15234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaCROJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,678,1389772800"; 
   d="log'?scan'208";a="494354285"
Date: Tue, 18 Mar 2014 22:07:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: [drbd] Kernel panic - not syncing: Out of memory and no killable
 processes...
Message-ID: <20140318140717.GA21372@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

We get the below OOM errors in our KVM boot tests and they are
bisected to

commit 23361cf32b58efdf09945a64e1d8d41fa6117157
Author:     Lars Ellenberg <lars.ellenberg@linbit.com>
AuthorDate: Thu Mar 31 16:36:43 2011 +0200
Commit:     Philipp Reisner <philipp.reisner@linbit.com>
CommitDate: Thu Nov 8 16:45:02 2012 +0100

    drbd: get rid of bio_split, allow bios of "arbitrary" size
    
    Where "arbitrary" size is currently 1 MiB, which is the BIO_MAX_SIZE
    for architectures with 4k PAGE_CACHE_SIZE (most).
    
    Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
    Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>


[    0.675459] pci 0000:00:02.0: Boot video device
[    0.676167] PCI: CLS 0 bytes, default 64
[    0.677713] Trying to unpack rootfs image as initramfs...
[    2.464631] swapper invoked oom-killer: gfp_mask=0x200d2, order=0, oom_score_adj=0
[    2.465725] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc6-01061-g73305b7 #2
[    2.466746] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.467543]  0000000000000000 ffff88000e3598e8 ffffffff8168b022 ffff88000e359960
[    2.468629]  ffffffff81687e8c ffff88000e356010 0000000000000000 0000000000000000
[    2.469712]  ffffffff81e174a0 ffff88000e359928 ffffffff81266579 ffff88000e359938
[    2.470792] Call Trace:
[    2.471172]  [<ffffffff8168b022>] dump_stack+0x19/0x1b
[    2.471879]  [<ffffffff81687e8c>] dump_header.isra.13+0x6d/0x1b3
[    2.472723]  [<ffffffff81266579>] ? __delay+0xf/0x11
[    2.473416]  [<ffffffff812665a1>] ? __const_udelay+0x26/0x28
[    2.474203]  [<ffffffff810f9b5a>] out_of_memory+0x22f/0x284
[    2.474966]  [<ffffffff810fd64b>] __alloc_pages_nodemask+0x5fb/0x73f
[    2.475843]  [<ffffffff810f74fe>] grab_cache_page_write_begin+0x73/0xc5
[    2.476768]  [<ffffffff81145ef4>] simple_write_begin+0x2b/0x82
[    2.477582]  [<ffffffff810f6d95>] generic_file_buffered_write+0xfd/0x224
[    2.478520]  [<ffffffff810f7cb0>] __generic_file_aio_write+0x1c1/0x1f8
[    2.479434]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.480196]  [<ffffffff810f7d3d>] generic_file_aio_write+0x56/0xc3
[    2.481053]  [<ffffffff81127acf>] do_sync_write+0x61/0x7c
[    2.481784]  [<ffffffff811282b0>] vfs_write+0xa5/0xe1
[    2.482497]  [<ffffffff8112891b>] SyS_write+0x49/0x7f
[    2.483193]  [<ffffffff820e5216>] do_copy+0x73/0x8e
[    2.483864]  [<ffffffff820e4fce>] write_buffer+0x21/0x30
[    2.484599]  [<ffffffff820e5005>] flush_buffer+0x28/0x81
[    2.485320]  [<ffffffff8210f04c>] gunzip+0x264/0x2f3
[    2.485994]  [<ffffffff8210eddf>] ? bunzip2+0x391/0x391
[    2.486734]  [<ffffffff820e4fdd>] ? write_buffer+0x30/0x30
[    2.487446]  [<ffffffff820e537d>] unpack_to_rootfs+0x14c/0x267
[    2.488231]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.488943]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.489722]  [<ffffffff820e5979>] populate_rootfs+0x5d/0xd8
[    2.490489]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.491271]  [<ffffffff810002aa>] do_one_initcall+0x82/0x112
[    2.492054]  [<ffffffff8108017a>] ? parse_args+0x189/0x247
[    2.492803]  [<ffffffff820e3e96>] kernel_init_freeable+0x115/0x19a
[    2.493661]  [<ffffffff820e371d>] ? do_early_param+0x88/0x88
[    2.494451]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1
[    2.495167]  [<ffffffff8167f96b>] kernel_init+0xe/0xda
[    2.495882]  [<ffffffff81694bba>] ret_from_fork+0x7a/0xb0
[    2.496632]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1
[    2.497361] Mem-Info:
[    2.497680] DMA per-cpu:
[    2.498051] CPU    0: hi:    0, btch:   1 usd:   0

git bisect start v3.8 v3.7 --
git bisect  bad 8d91a42e54eebc43f4d8f6064751ccba73528275  # 06:38      0-     10  Merge tag 'omap-late-cleanups' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 770b6cb4d21fb3e3df2a7a51e186a3c14db1ec30  # 07:04     20+     20  ARM: OMAP: Fix drivers to depend on omap for internal devices
git bisect  bad e32795503de02da4e7e74a5e039cc268f6a0ecfb  # 07:17      8-     20  Merge tags 'dt-for-linus', 'gpio-for-linus' and 'spi-for-linus' of git://git.secretlab.ca/git/linux-2.6
git bisect  bad 9a8a5702c5a7298c0edd125464aa178dd8b50440  # 07:46      0-      7  Merge tag 'for-3.8' of git://openrisc.net/~jonas/linux
git bisect good 9360b53661a2c7754517b2925580055bacc8ec38  # 08:14     26+     24  Revert "bdi: add a user-tunable cpu_list for the bdi flusher threads"
git bisect  bad ea88eeac0cb8328014b53d80ca631e8dc0dc18dc  # 08:22      0-      2  Merge tag 'md-3.8' of git://neil.brown.name/md
git bisect  bad ce4a9cc579381bc70b12ebb91c57da31baf8e3b7  # 08:38      0-     10  mm,numa: fix update_mmu_cache_pmd call
git bisect  bad 9228ff90387e276ad67b10c0eb525c9d6a57d5e9  # 08:58      8-     17  Merge branch 'for-3.8/drivers' of git://git.kernel.dk/linux-block
git bisect  bad cd1d9950f69b46d88002b39652ed0cf3608d008b  # 09:17      6-     20  drbd: Inlined drbd_free_mdev(); it got called only from one place
git bisect good 3c13b680ce210313c6f7ad163435b62979958c09  # 09:37     26+      0  drbd: only wakeup if something changed in update_peer_seq
git bisect good 28284ceff043b14defcf8122b765fe0b21bd9344  # 09:53     26+      0  drbd: recv_dless_read(): Return 0 upon success and an error code otherwise
git bisect good 6038178ebe29e6b5e4d519a5ac56653d156c90f9  # 10:47     26+      0  drbd: Change how the "handshake" packets are called
git bisect  bad 52b061a44021ca11ee2fd238040e91341ff8066d  # 11:36     11-      9  drbd: Introduce drbd_header_size()
git bisect  bad da9fbc276e9d42638df68e8515d06750695612ca  # 11:55      0-     10  drbd: Introduced a new type union drbd_dev_state
git bisect  bad 23361cf32b58efdf09945a64e1d8d41fa6117157  # 12:20      0-      4  drbd: get rid of bio_split, allow bios of "arbitrary" size
git bisect good 181286ad22bf9bfb85de625e8501285de5261b35  # 12:39     32+      0  drbd: preparation commit, pass drbd_interval to drbd_al_begin/complete_io
git bisect good 7726547e67a1fda0d12e1de5ec917a2e5d4b8186  # 13:13     32+      0  drbd: prepare to activate two activity log extents at once
# first bad commit: [23361cf32b58efdf09945a64e1d8d41fa6117157] drbd: get rid of bio_split, allow bios of "arbitrary" size
git bisect good 7726547e67a1fda0d12e1de5ec917a2e5d4b8186  # 13:21     96+      0  drbd: prepare to activate two activity log extents at once
git bisect  bad 73305b72fffe2ad01b7a672f991953d0efe21319  # 13:21      0-     19  0day head guard for 'devel-hourly-2014031621'
git bisect  bad dcb99fd9b08cfe1afe426af4d8d3cbc429190f15  # 14:09      0-      8  Linux 3.14-rc7
git bisect  bad ed87ead565a6130174fc27a46af65169cbff7677  # 14:09      0-      9  Add linux-next specific files for 20140314

Thanks,
Fengguang

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-cairo-28:20140317011307:x86_64-randconfig-r2-03170038:3.14.0-rc6-01061-g73305b7:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-01061-g73305b7 (kbuild@roam) (gcc v=
ersion 4.8.2 (Debian 4.8.2-16) ) #2 PREEMPT Mon Mar 17 01:09:01 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03170038/linux-devel:=
devel-hourly-2014031621/.vmlinuz-73305b72fffe2ad01b7a672f991953d0efe21319-2=
0140317011036-1-cairo branch=3Dlinux-devel/devel-hourly-2014031621 BOOT_IMA=
GE=3D/kernel/x86_64-randconfig-r2-03170038/73305b72fffe2ad01b7a672f991953d0=
efe21319/vmlinuz-3.14.0-rc6-01061-g73305b7
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02b4f000, 0x02b4ffff] PGTABLE
[    0.000000] BRK [0x02b50000, 0x02b50fff] PGTABLE
[    0.000000] BRK [0x02b51000, 0x02b51fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x02b52000, 0x02b52fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
[    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
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
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
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
[    0.000000] kvm-stealtime: cpu 0, msr 1e2a400
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r2-03170038/linux=
-devel:devel-hourly-2014031621/.vmlinuz-73305b72fffe2ad01b7a672f991953d0efe=
21319-20140317011036-1-cairo branch=3Dlinux-devel/devel-hourly-2014031621 B=
OOT_IMAGE=3D/kernel/x86_64-randconfig-r2-03170038/73305b72fffe2ad01b7a672f9=
91953d0efe21319/vmlinuz-3.14.0-rc6-01061-g73305b7
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 204688K/261744K available (6752K kernel code, 2948K =
rwdata, 4228K rodata, 1100K init, 9568K bss, 57056K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.990 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D2892990)
[    0.003006] pid_max: default: 32768 minimum: 301
[    0.004144] Mount-cache hash table entries: 256
[    0.005800] Initializing cgroup subsys debug
[    0.006016] Initializing cgroup subsys devices
[    0.006513] Initializing cgroup subsys freezer
[    0.007021] Initializing cgroup subsys net_cls
[    0.008013] Initializing cgroup subsys perf_event
[    0.008681] mce: CPU supports 10 MCE banks
[    0.009009] mce: unknown CPU type - not enabling MCE support
[    0.009632] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009632] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.009632] tlb_flushall_shift: -1
[    0.010007] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.012722] ftrace: allocating 28568 entries in 112 pages
[    0.020522] Performance Events: no PMU driver, software events only.
[    0.023165] ftrace: Allocated trace_printk buffers
[    0.027075] Getting VERSION: 50014
[    0.027468] Getting VERSION: 50014
[    0.027866] Getting ID: 0
[    0.028014] Getting ID: ff000000
[    0.028379] Getting LVT0: 8700
[    0.028734] Getting LVT1: 8400
[    0.029061] enabled ExtINT on CPU#0
[    0.030686] ENABLING IO-APIC IRQs
[    0.031008] init IO_APIC IRQs
[    0.031333]  apic 0 pin 0 not connected
[    0.031762] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.032023] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.033023] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.034021] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.035021] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036022] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.037027] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.038021] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.039021] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041021] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042021] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.043006] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.043862] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.044021] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.045018]  apic 0 pin 16 not connected
[    0.046004]  apic 0 pin 17 not connected
[    0.046419]  apic 0 pin 18 not connected
[    0.047004]  apic 0 pin 19 not connected
[    0.047415]  apic 0 pin 20 not connected
[    0.047828]  apic 0 pin 21 not connected
[    0.048003]  apic 0 pin 22 not connected
[    0.048416]  apic 0 pin 23 not connected
[    0.049145] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.050004] Using local APIC timer interrupts.
[    0.050004] calibrating APIC timer ...
[    0.052000] ... lapic delta =3D 6251039
[    0.052000] ... PM-Timer delta =3D 358114
[    0.052000] ... PM-Timer result ok
[    0.052000] ..... delta 6251039
[    0.052000] ..... mult: 268480080
[    0.052000] ..... calibration result: 1000166
[    0.052000] ..... CPU clock speed is 2894.0452 MHz.
[    0.052000] ..... host bus clock speed is 1000.0166 MHz.
[    0.052969] devtmpfs: initialized
[    0.077721] regulator-dummy: no parameters
[    0.079102] NET: Registered protocol family 16
[    0.081447] cpuidle: using governor ladder
[    0.082004] cpuidle: using governor menu
[    0.082908] ACPI: bus type PCI registered
[    0.084146] PCI: Using configuration type 1 for base access
[    0.130361] bio: create slab <bio-0> at 0
[    0.132229] ACPI: Added _OSI(Module Device)
[    0.132774] ACPI: Added _OSI(Processor Device)
[    0.133006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.133625] ACPI: Added _OSI(Processor Aggregator Device)
[    0.160847] ACPI: Interpreter enabled
[    0.161009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.162288] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.163694] ACPI: (supports S0 S3 S5)
[    0.164003] ACPI: Using IOAPIC for interrupt routing
[    0.165058] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.199051] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.199844] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.200039] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.203229] PCI host bridge to bus 0000:00
[    0.203762] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.204005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.205005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.206004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.206830] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.207060] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.209728] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.211842] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.215624] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.218778] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.219385] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.220015] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.222907] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.224752] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.227033] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.236035] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.238756] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.240603] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.242605] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.249004] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.251400] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.253004] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.255004] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.263299] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.265004] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.267004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.275173] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.277004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.279004] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.287046] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.289004] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.291004] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.298943] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.301004] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.302598] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.310857] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.312599] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.314597] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.322724] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.324005] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.329885] pci_bus 0000:00: on NUMA node 0
[    0.330234] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.334401] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.335773] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.337197] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.338600] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.339460] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.342662] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.345580] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.346008] vgaarb: loaded
[    0.347002] vgaarb: bridge control possible 0000:00:02.0
[    0.350396] SCSI subsystem initialized
[    0.351433] libata version 3.00 loaded.
[    0.352070] ACPI: bus type USB registered
[    0.353197] usbcore: registered new interface driver usbfs
[    0.354174] usbcore: registered new interface driver hub
[    0.355182] usbcore: registered new device driver usb
[    0.356510] Linux video capture interface: v2.00
[    0.357271] pps_core: LinuxPPS API ver. 1 registered
[    0.358026] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.359086] PTP clock support registered
[    0.360556] PCI: Using ACPI for IRQ routing
[    0.361007] PCI: pci_cache_line_size set to 64 bytes
[    0.362040] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.362878] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.367208] nfc: nfc_init: NFC Core ver 0.1
[    0.367926] NET: Registered protocol family 39
[    0.368424] Switched to clocksource kvm-clock
[    0.369000] cfg80211: Calling CRDA to update world regulatory domain
[    0.628840] FS-Cache: Loaded
[    0.629766] CacheFiles: Loaded
[    0.630405] pnp: PnP ACPI init
[    0.631051] ACPI: bus type PNP registered
[    0.632155] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.633190] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.634712] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.635715] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.637234] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.638357] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.639505] pnp 00:03: [dma 2]
[    0.640340] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.641434] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.642937] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.644069] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.645581] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.647924] pnp: PnP ACPI: found 6 devices
[    0.648521] ACPI: bus type PNP unregistered
[    0.658056] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.658815] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.659573] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.660438] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.661637] NET: Registered protocol family 2
[    0.663605] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.664679] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.665769] TCP: Hash tables configured (established 2048 bind 2048)
[    0.669484] TCP: reno registered
[    0.669940] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.670823] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.672269] NET: Registered protocol family 1
[    0.672950] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.673783] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.674589] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.675459] pci 0000:00:02.0: Boot video device
[    0.676167] PCI: CLS 0 bytes, default 64
[    0.677713] Trying to unpack rootfs image as initramfs...
[    2.464631] swapper invoked oom-killer: gfp_mask=3D0x200d2, order=3D0, o=
om_score_adj=3D0
[    2.465725] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc6-01061-g73=
305b7 #2
[    2.466746] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.467543]  0000000000000000 ffff88000e3598e8 ffffffff8168b022 ffff8800=
0e359960
[    2.468629]  ffffffff81687e8c ffff88000e356010 0000000000000000 00000000=
00000000
[    2.469712]  ffffffff81e174a0 ffff88000e359928 ffffffff81266579 ffff8800=
0e359938
[    2.470792] Call Trace:
[    2.471172]  [<ffffffff8168b022>] dump_stack+0x19/0x1b
[    2.471879]  [<ffffffff81687e8c>] dump_header.isra.13+0x6d/0x1b3
[    2.472723]  [<ffffffff81266579>] ? __delay+0xf/0x11
[    2.473416]  [<ffffffff812665a1>] ? __const_udelay+0x26/0x28
[    2.474203]  [<ffffffff810f9b5a>] out_of_memory+0x22f/0x284
[    2.474966]  [<ffffffff810fd64b>] __alloc_pages_nodemask+0x5fb/0x73f
[    2.475843]  [<ffffffff810f74fe>] grab_cache_page_write_begin+0x73/0xc5
[    2.476768]  [<ffffffff81145ef4>] simple_write_begin+0x2b/0x82
[    2.477582]  [<ffffffff810f6d95>] generic_file_buffered_write+0xfd/0x224
[    2.478520]  [<ffffffff810f7cb0>] __generic_file_aio_write+0x1c1/0x1f8
[    2.479434]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.480196]  [<ffffffff810f7d3d>] generic_file_aio_write+0x56/0xc3
[    2.481053]  [<ffffffff81127acf>] do_sync_write+0x61/0x7c
[    2.481784]  [<ffffffff811282b0>] vfs_write+0xa5/0xe1
[    2.482497]  [<ffffffff8112891b>] SyS_write+0x49/0x7f
[    2.483193]  [<ffffffff820e5216>] do_copy+0x73/0x8e
[    2.483864]  [<ffffffff820e4fce>] write_buffer+0x21/0x30
[    2.484599]  [<ffffffff820e5005>] flush_buffer+0x28/0x81
[    2.485320]  [<ffffffff8210f04c>] gunzip+0x264/0x2f3
[    2.485994]  [<ffffffff8210eddf>] ? bunzip2+0x391/0x391
[    2.486734]  [<ffffffff820e4fdd>] ? write_buffer+0x30/0x30
[    2.487446]  [<ffffffff820e537d>] unpack_to_rootfs+0x14c/0x267
[    2.488231]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.488943]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.489722]  [<ffffffff820e5979>] populate_rootfs+0x5d/0xd8
[    2.490489]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.491271]  [<ffffffff810002aa>] do_one_initcall+0x82/0x112
[    2.492054]  [<ffffffff8108017a>] ? parse_args+0x189/0x247
[    2.492803]  [<ffffffff820e3e96>] kernel_init_freeable+0x115/0x19a
[    2.493661]  [<ffffffff820e371d>] ? do_early_param+0x88/0x88
[    2.494451]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1
[    2.495167]  [<ffffffff8167f96b>] kernel_init+0xe/0xda
[    2.495882]  [<ffffffff81694bba>] ret_from_fork+0x7a/0xb0
[    2.496632]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1
[    2.497361] Mem-Info:
[    2.497680] DMA per-cpu:
[    2.498051] CPU    0: hi:    0, btch:   1 usd:   0
[    2.498702] DMA32 per-cpu:
[    2.499086] CPU    0: hi:   90, btch:  15 usd:  20
[    2.499737] active_anon:0 inactive_anon:0 isolated_anon:0
[    2.499737]  active_file:1846 inactive_file:0 isolated_file:0
[    2.499737]  unevictable:16400 dirty:0 writeback:0 unstable:0
[    2.499737]  free:0 slab_reclaimable:24592 slab_unreclaimable:7720
[    2.499737]  mapped:0 shmem:0 pagetables:0 bounce:0
[    2.499737]  free_cma:0
[    2.503765] DMA free:0kB min:0kB low:0kB high:0kB active_anon:0kB inacti=
ve_anon:0kB active_file:1364kB inactive_file:0kB unevictable:10196kB isolat=
ed(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:0kB=
 dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:4280kB slab_=
unreclaimable:68kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB =
free_cma:0kB writeback_tmp:0kB pages_scanned:2549 all_unreclaimable? yes
[    2.508931] lowmem_reserve[]: 0 0 0 0
[    2.509550] DMA32 free:0kB min:0kB low:0kB high:0kB active_anon:0kB inac=
tive_anon:0kB active_file:6020kB inactive_file:0kB unevictable:55404kB isol=
ated(anon):0kB isolated(file):0kB present:245752kB managed:188780kB mlocked=
:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:94088kB =
slab_unreclaimable:30812kB kernel_stack:200kB pagetables:0kB unstable:0kB b=
ounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:13851 all_unreclaima=
ble? yes
[    2.514836] lowmem_reserve[]: 0 0 0 0
[    2.515449] DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512k=
B 0*1024kB 0*2048kB 0*4096kB =3D 0kB
[    2.516973] DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*51=
2kB 0*1024kB 0*2048kB 0*4096kB =3D 0kB
[    2.518506] 18246 total pagecache pages
[    2.519040] 65436 pages RAM
[    2.519435] 0 pages HighMem/MovableOnly
[    2.519952] 14243 pages reserved
[    2.520413] 0 pages hwpoisoned
[    2.520830] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_s=
core_adj name
[    2.521874] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[    2.521874]=20
[    2.522838] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc6-01061-g73=
305b7 #2
[    2.522838] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.522838]  0000000000000000 ffff88000e3598e8 ffffffff8168b022 ffff8800=
0e359960
[    2.522838]  ffffffff81686dfe ffff880000000008 ffff88000e359970 ffff8800=
0e359910
[    2.522838]  ffffffff81e174a0 0000000000000568 0000000000000001 00000000=
965f7796
[    2.522838] Call Trace:
[    2.522838]  [<ffffffff8168b022>] dump_stack+0x19/0x1b
[    2.522838]  [<ffffffff81686dfe>] panic+0xd0/0x1d1
[    2.522838]  [<ffffffff810f9b68>] out_of_memory+0x23d/0x284
[    2.522838]  [<ffffffff810fd64b>] __alloc_pages_nodemask+0x5fb/0x73f
[    2.522838]  [<ffffffff810f74fe>] grab_cache_page_write_begin+0x73/0xc5
[    2.522838]  [<ffffffff81145ef4>] simple_write_begin+0x2b/0x82
[    2.522838]  [<ffffffff810f6d95>] generic_file_buffered_write+0xfd/0x224
[    2.522838]  [<ffffffff810f7cb0>] __generic_file_aio_write+0x1c1/0x1f8
[    2.522838]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.522838]  [<ffffffff810f7d3d>] generic_file_aio_write+0x56/0xc3
[    2.522838]  [<ffffffff81127acf>] do_sync_write+0x61/0x7c
[    2.522838]  [<ffffffff811282b0>] vfs_write+0xa5/0xe1
[    2.522838]  [<ffffffff8112891b>] SyS_write+0x49/0x7f
[    2.522838]  [<ffffffff820e5216>] do_copy+0x73/0x8e
[    2.522838]  [<ffffffff820e4fce>] write_buffer+0x21/0x30
[    2.522838]  [<ffffffff820e5005>] flush_buffer+0x28/0x81
[    2.522838]  [<ffffffff8210f04c>] gunzip+0x264/0x2f3
[    2.522838]  [<ffffffff8210eddf>] ? bunzip2+0x391/0x391
[    2.522838]  [<ffffffff820e4fdd>] ? write_buffer+0x30/0x30
[    2.522838]  [<ffffffff820e537d>] unpack_to_rootfs+0x14c/0x267
[    2.522838]  [<ffffffff820e4f33>] ? initrd_load+0x2c4/0x2c4
[    2.522838]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.522838]  [<ffffffff820e5979>] populate_rootfs+0x5d/0xd8
[    2.522838]  [<ffffffff820e591c>] ? clean_rootfs+0x156/0x156
[    2.522838]  [<ffffffff810002aa>] do_one_initcall+0x82/0x112
[    2.522838]  [<ffffffff8108017a>] ? parse_args+0x189/0x247
[    2.522838]  [<ffffffff820e3e96>] kernel_init_freeable+0x115/0x19a
[    2.522838]  [<ffffffff820e371d>] ? do_early_param+0x88/0x88
[    2.522838]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1
[    2.522838]  [<ffffffff8167f96b>] kernel_init+0xe/0xda
[    2.522838]  [<ffffffff81694bba>] ret_from_fork+0x7a/0xb0
[    2.522838]  [<ffffffff8167f95d>] ? rest_init+0xc1/0xc1

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-r2-03170038/73305b72fffe2ad01b7a672f991953d0efe21319/vmlinuz-3.14.0-rc6-01=
061-g73305b7 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
ernel-tests/run-queue/kvm/x86_64-randconfig-r2-03170038/linux-devel:devel-h=
ourly-2014031621/.vmlinuz-73305b72fffe2ad01b7a672f991953d0efe21319-20140317=
011036-1-cairo branch=3Dlinux-devel/devel-hourly-2014031621 BOOT_IMAGE=3D/k=
ernel/x86_64-randconfig-r2-03170038/73305b72fffe2ad01b7a672f991953d0efe2131=
9/vmlinuz-3.14.0-rc6-01061-g73305b7'  -initrd /kernel-tests/initrd/quantal-=
core-x86_64.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vla=
n=3D1,hostfwd=3Dtcp::9974-:22 -boot order=3Dnc -no-reboot -watchdog i6300es=
b -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-cairo-2=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-cair=
o-28,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-c=
airo-28,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quanta=
l-cairo-28,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-qua=
ntal-cairo-28,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-=
quantal-cairo-28,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quant=
al-cairo-28 -serial file:/dev/shm/kboot/serial-quantal-cairo-28 -daemonize =
-display none -monitor null=20

--CE+1k2dSO48ffgeK
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-r2-03170038-73305b72fffe2ad01b7a672f991953d0efe21319-Kernel-panic---not-syncing:-Out-of-memory-and-no-killable-processes----91118.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGZhMzg5ZTIyMDI1NGM2OWZmYWUwZDQwM2VhYzQxNDYxNzEwNjJkMDgK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOmZhMzg5ZTIy
MDI1NGM2OWZmYWUwZDQwM2VhYzQxNDYxNzEwNjJkMDg6YmlzZWN0LWxpbnV4OQoKMjAxNC0w
My0xNy0wMjowMjo0MiBmYTM4OWUyMjAyNTRjNjlmZmFlMGQ0MDNlYWM0MTQ2MTcxMDYyZDA4
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWZhMzg5ZTIyMDI1NGM2OWZmYWUw
ZDQwM2VhYzQxNDYxNzEwNjJkMDgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2ZhMzg5ZTIyMDI1NGM2OWZmYWUwZDQwM2VhYzQx
NDYxNzEwNjJkMDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWZhMzg5ZTIyMDI1NGM2
OWZmYWUwZDQwM2VhYzQxNDYxNzEwNjJkMDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC1mYTM4OWUyMjAyNTRjNjlmZmFlMGQ0MDNlYWM0MTQ2MTcxMDYyZDA4Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9mYTM4OWUyMjAyNTRjNjlmZmFl
MGQ0MDNlYWM0MTQ2MTcxMDYyZDA4L3ZtbGludXotMy4xNC4wLXJjNgoKMjAxNC0wMy0xNy0w
Mjo1Njo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAg
ICAxLjA1NTQ3OF0gcGNpIDAwMDA6MDA6MDIuMDogQm9vdCB2aWRlbyBkZXZpY2UKWyAgICAx
LjA1NjczMF0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDEuMDU4OTgzXSBU
cnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFnZSBhcyBpbml0cmFtZnMuLi4KWyAgICAzLjU3
MTg5M10gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAwZDIsIG9y
ZGVyPTAsIG9vbV9zY29yZV9hZGo9MApbICAgIDMuNTczNTQzXSBDUFU6IDAgUElEOiAxIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLXJjNiAjMQpbICAgIDMuNTc0OTE2XSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAg
My41NzYyMzZdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGUzNTk4ZTggZmZmZmZmZmY4
MTY4OWQxMyBmZmZmODgwMDBlMzU5OTYwClsgICAgMy41Nzc5ODZdICBmZmZmZmZmZjgxNjg2
YjdkIGZmZmY4ODAwMGUzNTYwMTAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAw
ClsgICAgMy41Nzk3NThdICBmZmZmZmZmZjgxZTE3NGEwIGZmZmY4ODAwMGUzNTk5MjggZmZm
ZmZmZmY4MTI2NWY3OSBmZmZmODgwMDBlMzU5OTM4ClsgICAgMy41ODE1MjBdIENhbGwgVHJh
Y2U6ClsgICAgMy41ODIxMjldICBbPGZmZmZmZmZmODE2ODlkMTM+XSBkdW1wX3N0YWNrKzB4
MTkvMHgxYgpbICAgIDMuNTgzMjc5XSAgWzxmZmZmZmZmZjgxNjg2YjdkPl0gZHVtcF9oZWFk
ZXIuaXNyYS4xMysweDZkLzB4MWIzClsgICAgMy41ODQ1OTVdICBbPGZmZmZmZmZmODEyNjVm
Nzk+XSA/IF9fZGVsYXkrMHhmLzB4MTEKWyAgICAzLjU4NTY4Nl0gIFs8ZmZmZmZmZmY4MTI2
NWZhMT5dID8gX19jb25zdF91ZGVsYXkrMHgyNi8weDI4ClsgICAgMy41ODY5NjhdICBbPGZm
ZmZmZmZmODEwZjk1OTI+XSBvdXRfb2ZfbWVtb3J5KzB4MjJmLzB4Mjg0ClsgICAgMy41ODgx
NzFdICBbPGZmZmZmZmZmODEwZmQwODk+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4NWZi
LzB4NzNmClsgICAgMy41ODk1MTFdICBbPGZmZmZmZmZmODEwZjZmMzY+XSBncmFiX2NhY2hl
X3BhZ2Vfd3JpdGVfYmVnaW4rMHg3My8weGM1ClsgICAgMy41OTA5NDddICBbPGZmZmZmZmZm
ODExNDU4YTE+XSBzaW1wbGVfd3JpdGVfYmVnaW4rMHgyYi8weDgyClsgICAgMy41OTIyMDNd
ICBbPGZmZmZmZmZmODEwZjY3Y2Q+XSBnZW5lcmljX2ZpbGVfYnVmZmVyZWRfd3JpdGUrMHhm
ZC8weDIyNApbICAgIDMuNTkzNjIzXSAgWzxmZmZmZmZmZjgxMGY3NmU4Pl0gX19nZW5lcmlj
X2ZpbGVfYWlvX3dyaXRlKzB4MWMxLzB4MWY4ClsgICAgMy41OTUxMDhdICBbPGZmZmZmZmZm
ODIwZTRmMzM+XSA/IGluaXRyZF9sb2FkKzB4MmM0LzB4MmM0ClsgICAgMy41OTYzOTZdICBb
PGZmZmZmZmZmODEwZjc3NzU+XSBnZW5lcmljX2ZpbGVfYWlvX3dyaXRlKzB4NTYvMHhjMwpb
ICAgIDMuNTk3NzgxXSAgWzxmZmZmZmZmZjgxMTI3NTAzPl0gZG9fc3luY193cml0ZSsweDYx
LzB4N2MKWyAgICAzLjU5ODk5Nl0gIFs8ZmZmZmZmZmY4MTEyN2NhMD5dIHZmc193cml0ZSsw
eGE1LzB4ZTEKWyAgICAzLjYwMDEzNl0gIFs8ZmZmZmZmZmY4MTEyODMwYj5dIFN5U193cml0
ZSsweDQ5LzB4N2YKWyAgICAzLjYwMTI3MV0gIFs8ZmZmZmZmZmY4MjBlNTIxNj5dIGRvX2Nv
cHkrMHg3My8weDhlClsgICAgMy42MDIzNjRdICBbPGZmZmZmZmZmODIwZTRmY2U+XSB3cml0
ZV9idWZmZXIrMHgyMS8weDMwClsgICAgMy42MDM1NDZdICBbPGZmZmZmZmZmODIwZTUwMDU+
XSBmbHVzaF9idWZmZXIrMHgyOC8weDgxClsgICAgMy42MDQ3MjVdICBbPGZmZmZmZmZmODIx
MGYwNTA+XSBndW56aXArMHgyNjQvMHgyZjMKWyAgICAzLjYwNTc5N10gIFs8ZmZmZmZmZmY4
MjEwZWRlMz5dID8gYnVuemlwMisweDM5MS8weDM5MQpbICAgIDMuNjA2OTY5XSAgWzxmZmZm
ZmZmZjgyMGU0ZmRkPl0gPyB3cml0ZV9idWZmZXIrMHgzMC8weDMwClsgICAgMy42MDgxNThd
ICBbPGZmZmZmZmZmODIwZTUzN2Q+XSB1bnBhY2tfdG9fcm9vdGZzKzB4MTRjLzB4MjY3Clsg
ICAgMy42MDk0MThdICBbPGZmZmZmZmZmODIwZTRmMzM+XSA/IGluaXRyZF9sb2FkKzB4MmM0
LzB4MmM0ClsgICAgMy42MTA2MThdICBbPGZmZmZmZmZmODIwZTU5MWM+XSA/IGNsZWFuX3Jv
b3RmcysweDE1Ni8weDE1NgpbICAgIDMuNjExODQxXSAgWzxmZmZmZmZmZjgyMGU1OTc5Pl0g
cG9wdWxhdGVfcm9vdGZzKzB4NWQvMHhkOApbICAgIDMuNjEzMDQzXSAgWzxmZmZmZmZmZjgy
MGU1OTFjPl0gPyBjbGVhbl9yb290ZnMrMHgxNTYvMHgxNTYKWyAgICAzLjYxNDI4OV0gIFs8
ZmZmZmZmZmY4MTAwMDJhYT5dIGRvX29uZV9pbml0Y2FsbCsweDgyLzB4MTEyClsgICAgMy42
MTczNTldICBbPGZmZmZmZmZmODEwN2ZlNDM+XSA/IHBhcnNlX2FyZ3MrMHgxODkvMHgyNDcK
WyAgICAzLjYxODU4OV0gIFs8ZmZmZmZmZmY4MjBlM2U5Nj5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MTE1LzB4MTlhClsgICAgMy42MTk5ODBdICBbPGZmZmZmZmZmODIwZTM3MWQ+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDMuNjIxMjQ3XSAgWzxmZmZmZmZmZjgx
NjdlNjhkPl0gPyByZXN0X2luaXQrMHhjMS8weGMxClsgICAgMy42MjI0MTddICBbPGZmZmZm
ZmZmODE2N2U2OWI+XSBrZXJuZWxfaW5pdCsweGUvMHhkYQpbICAgIDMuNjIzNTY1XSAgWzxm
ZmZmZmZmZjgxNjkzODdhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAzLjYyNDgz
NF0gIFs8ZmZmZmZmZmY4MTY3ZTY4ZD5dID8gcmVzdF9pbml0KzB4YzEvMHhjMQpbICAgIDMu
NjI2MDE5XSBNZW0tSW5mbzoKWyAgICAzLjYyNjUxM10gRE1BIHBlci1jcHU6ClsgICAgMy42
MjcwOTFdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDogICAxIHVzZDogICAwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZmEzODllMjIwMjU0YzY5ZmZhZTBkNDAz
ZWFjNDE0NjE3MTA2MmQwOC9kbWVzZy1xdWFudGFsLXJvYW0tMToyMDE0MDMxNzAyNTkzMDp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM2OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9mYTM4OWUyMjAyNTRjNjlmZmFlMGQ0MDNlYWM0
MTQ2MTcxMDYyZDA4L2RtZXNnLXlvY3RvLXJvYW0tMjM6MjAxNDAzMTcwMjU5MzA6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNjoxCjA6MjoyIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTE3IDAzOjAwOjQzIFJFUEVBVCBDT1VO
VDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoK
YmlzZWN0OiBiYWQgY29tbWl0IGZhMzg5ZTIyMDI1NGM2OWZmYWUwZDQwM2VhYzQxNDYxNzEw
NjJkMDgKZ2l0IGNoZWNrb3V0IHYzLjEzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMTYyMTpkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2
NGJlOmJpc2VjdC1saW51eDkKCjIwMTQtMDMtMTctMDM6MDA6NDYgZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVj
MjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMx
NzAwMzgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6
LTMuMTMuMAoKMjAxNC0wMy0xNy0wMzozMzo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
Li4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDQuMDExNjgwXSB1dmVzYWZiOiBwcm9iZSBvZiB1
dmVzYWZiLjAgZmFpbGVkIHdpdGggZXJyb3IgLTIyClsgICAgNC4wMTQxNzBdIGlucHV0OiBQ
b3dlciBCdXR0b24gYXMgL2RldmljZXMvTE5YU1lTVE06MDAvTE5YUFdSQk46MDAvaW5wdXQv
aW5wdXQwClsgICAgNC4wMTYwNThdIEFDUEk6IFBvd2VyIEJ1dHRvbiBbUFdSRl0KWyAgICA0
LjA0MjI0NV0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjA0MGQw
LCBvcmRlcj0wLCBvb21fc2NvcmVfYWRqPTAKWyAgICA0LjA0NDMzOF0gQ1BVOiAwIFBJRDog
MSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTMuMCAjMQpbICAgIDQuMDQ1NzczXSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAg
NC4wNDgwMzZdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGUzYzc5ZTAgZmZmZmZmZmY4
MTY1NGYxOSBmZmZmODgwMDBlM2M3YTU4ClsgICAgNC4wNTAwMzddICBmZmZmZmZmZjgxNjUx
ZGIzIGZmZmY4ODAwMGUzYzQwMTAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAwNWU4YmQw
ClsgICAgNC4wNTE5ODVdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGUzYzdhMjAgZmZm
ZmZmZmY4MTI0ODcyOSBmZmZmODgwMDBlM2M3YTMwClsgICAgNC4wNTQxMjFdIENhbGwgVHJh
Y2U6ClsgICAgNC4wNTQ3NzZdICBbPGZmZmZmZmZmODE2NTRmMTk+XSBkdW1wX3N0YWNrKzB4
MTkvMHgxYgpbICAgIDQuMDU2MDU5XSAgWzxmZmZmZmZmZjgxNjUxZGIzPl0gZHVtcF9oZWFk
ZXIuaXNyYS4xMysweDZkLzB4MWIzClsgICAgNC4wNTc1NThdICBbPGZmZmZmZmZmODEyNDg3
Mjk+XSA/IF9fZGVsYXkrMHhmLzB4MTEKWyAgICA0LjA1ODgwMV0gIFs8ZmZmZmZmZmY4MTI0
ODc1MT5dID8gX19jb25zdF91ZGVsYXkrMHgyNi8weDI4ClsgICAgNC4wNjAyMzVdICBbPGZm
ZmZmZmZmODEwZGVmOWY+XSBvdXRfb2ZfbWVtb3J5KzB4MWRjLzB4MjMwClsgICAgNC4wNjE2
MjRdICBbPGZmZmZmZmZmODEwZTI4ZWM+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4NWNj
LzB4NzEwClsgICAgNC4wNjMyMDddICBbPGZmZmZmZmZmODExMDVkN2Y+XSBfX19fY2FjaGVf
YWxsb2MrMHgzMTcvMHg2YzkKWyAgICA0LjA2NDc5N10gIFs8ZmZmZmZmZmY4MTE1OGM0Mz5d
ID8gc3lzZnNfbmV3X2RpcmVudCsweDUzLzB4MTEwClsgICAgNC4wNjYyODNdICBbPGZmZmZm
ZmZmODExMDU5YTA+XSBrbWVtX2NhY2hlX2FsbG9jKzB4NmEvMHgxMzIKWyAgICA0LjA2Nzcy
M10gIFs8ZmZmZmZmZmY4MTE1OGM0Mz5dIHN5c2ZzX25ld19kaXJlbnQrMHg1My8weDExMApb
ICAgIDQuMDY5MTQ5XSAgWzxmZmZmZmZmZjgxMTU4MDM3Pl0gc3lzZnNfYWRkX2ZpbGVfbW9k
ZV9ucysweDMwLzB4YWMKWyAgICA0LjA3MDY5NF0gIFs8ZmZmZmZmZmY4MTE1ODE1ZT5dIHN5
c2ZzX2FkZF9maWxlKzB4MTUvMHgxNwpbICAgIDQuMDcyMDY0XSAgWzxmZmZmZmZmZjgxMTU5
ZjY1Pl0gc3lzZnNfbWVyZ2VfZ3JvdXArMHg1MC8weDk0ClsgICAgNC4wNzM1MTddICBbPGZm
ZmZmZmZmODEzMTgzYWE+XSBkcG1fc3lzZnNfYWRkKzB4NGYvMHhhNQpbICAgIDQuMDc0ODYz
XSAgWzxmZmZmZmZmZjgxMzExNTJlPl0gZGV2aWNlX2FkZCsweDNjOC8weDRlOApbICAgIDQu
MDc2MTk3XSAgWzxmZmZmZmZmZjgxMzExNjY4Pl0gZGV2aWNlX3JlZ2lzdGVyKzB4MWEvMHgx
ZApbICAgIDQuMDc3NjAyXSAgWzxmZmZmZmZmZjgxMmNiN2JkPl0gdHR5X3JlZ2lzdGVyX2Rl
dmljZV9hdHRyKzB4MTc1LzB4MWMzClsgICAgNC4wNzkyMTldICBbPGZmZmZmZmZmODEwNzll
ZTE+XSA/IGxvY2tfcmVsZWFzZSsweDE3Ny8weDFjMQpbICAgIDQuMDgwNjM2XSAgWzxmZmZm
ZmZmZjgxMmNiODFlPl0gdHR5X3JlZ2lzdGVyX2RldmljZSsweDEzLzB4MTUKWyAgICA0LjA4
MjA5NV0gIFs8ZmZmZmZmZmY4MTJjYjk0Mz5dIHR0eV9yZWdpc3Rlcl9kcml2ZXIrMHgxMjMv
MHgxYWIKWyAgICA0LjA4MzYyOF0gIFs8ZmZmZmZmZmY4MWYxMmQ1MD5dIHB0eV9pbml0KzB4
MTU2LzB4Mzg3ClsgICAgNC4wODQ5MTZdICBbPGZmZmZmZmZmODFmMTJiZmE+XSA/IHR0eV9p
bml0KzB4MTI5LzB4MTI5ClsgICAgNC4wODYyOTBdICBbPGZmZmZmZmZmODEwMDAyOTI+XSBk
b19vbmVfaW5pdGNhbGwrMHg4Mi8weDExMgpbICAgIDQuMDg3NzAzXSAgWzxmZmZmZmZmZjgx
MDY4YTA2Pl0gPyBwYXJzZV9hcmdzKzB4MTg5LzB4MjQ3ClsgICAgNC4wODkwNzddICBbPGZm
ZmZmZmZmODFlZTJlN2E+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDExNS8weDE5YQpbICAg
IDQuMDkwNTg5XSAgWzxmZmZmZmZmZjgxZWUyNzE3Pl0gPyBkb19lYXJseV9wYXJhbSsweDg4
LzB4ODgKWyAgICA0LjA5MTk5N10gIFs8ZmZmZmZmZmY4MTY0OWEzZD5dID8gcmVzdF9pbml0
KzB4YzEvMHhjMQpbICAgIDQuMDkzMzEwXSAgWzxmZmZmZmZmZjgxNjQ5YTRiPl0ga2VybmVs
X2luaXQrMHhlLzB4MTA0ClsgICAgNC4wOTQ2MjBdICBbPGZmZmZmZmZmODE2NWVjZmE+XSBy
ZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDQuMDk2MDMxXSAgWzxmZmZmZmZmZjgxNjQ5
YTNkPl0gPyByZXN0X2luaXQrMHhjMS8weGMxClsgICAgNC4wOTgwMjldIE1lbS1JbmZvOgpb
ICAgIDQuMDk4NjA3XSBETUEgcGVyLWNwdToKWyAgICA0LjA5OTI3Nl0gQ1BVICAgIDA6IGhp
OiAgICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tMTU6MjAxNDAzMTcwMzMzMzM6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1
YW50YWwtY2Fpcm8tMTg6MjAxNDAzMTcwMzMzMzM6eDg2XzY0LXJhbmRjb25maWctcjItMDMx
NzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9k
OGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwt
Y2Fpcm8tMjI6MjAxNDAzMTcwMzMzMzQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6
My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZk
N2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8t
MjM6MjAxNDAzMTcwMzMzMzE6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4w
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3
ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzA6MjAx
NDAzMTcwMzMzMzQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzI6MjAxNDAzMTcw
MzMzMzQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzM6MjAxNDAzMTcwMzMzNDA6
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQy
MTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzQ6MjAxNDAzMTcwMzMzNDA6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2
NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzc6MjAxNDAzMTcwMzMzMzI6eDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tMzg6MjAxNDAzMTcwMzMzMzg6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1
YW50YWwtY2Fpcm8tNDA6MjAxNDAzMTcwMzMzMzk6eDg2XzY0LXJhbmRjb25maWctcjItMDMx
NzAwMzg6My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9k
OGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwt
Y2Fpcm8tNDI6MjAxNDAzMTcwMzMzMzk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6
My4xMy4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZk
N2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8t
NDg6MjAxNDAzMTcwMzMzMzk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4w
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kOGVjMjZkN2Y4Mjg3
ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDoyMDE0
MDMxNzAzMzM0MDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjEzLjA6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0
OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ctcXVhbnRhbC1jYWlyby03OjIwMTQwMzE3MDMz
MzM5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTMuMDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZS9kbWVzZy1xdWFudGFsLWNhaXJvLTg6MjAxNDAzMTcwMzMzNDA6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMy4wOjEKMDoxNjoxNiBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0xNyAwMzozODo0OCBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QvLnJlcGVhdBtbMG0K
CmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMwpnaXQgY2hlY2tvdXQgdjMuMTIKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOjVlMDFkYzdiMjZkOWYyNGYz
OWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LWxpbnV4OQoKMjAxNC0wMy0xNy0wMzoz
ODo1MSA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThj
Y2JkNmE1Y2ViNTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2Vi
NTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTVlMDFkYzdiMjZkOWYyNGYzOWFiYWNl
NWRhOThjY2JkNmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC01ZTAxZGM3
YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4
Y2NiZDZhNWNlYjUyL3ZtbGludXotMy4xMi4wCgoyMDE0LTAzLTE3LTA0OjI2OjUxIGRldGVj
dGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMi4xOTI4ODFdIHV2ZXNhZmI6
IHByb2JlIG9mIHV2ZXNhZmIuMCBmYWlsZWQgd2l0aCBlcnJvciAtMjIKWyAgICAyLjE5NDQ4
Ml0gaW5wdXQ6IFBvd2VyIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhQV1JC
TjowMC9pbnB1dC9pbnB1dDAKWyAgICAyLjE5NTQyMl0gQUNQSTogUG93ZXIgQnV0dG9uIFtQ
V1JGXQpbICAgIDIuMjI5Mzc5XSBzd2FwcGVyIGludm9rZWQgb29tLWtpbGxlcjogZ2ZwX21h
c2s9MHgyMDAwZDAsIG9yZGVyPTAsIG9vbV9zY29yZV9hZGo9MApbICAgIDIuMjMwMzIzXSBD
UFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wICMxClsgICAg
Mi4yMzEwMTldIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICAyLjIzMTcwNl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZTNjNzkz
OCBmZmZmZmZmZjgxNjJkZTlkIGZmZmY4ODAwMGUzYzc5YjAKWyAgICAyLjIzMjY2M10gIGZm
ZmZmZmZmODE2MmFkOTggMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAwYWVlYjQwIDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAyLjIzMzYxMl0gIGZmZmZmZmZmODFjMTc0YTAgZmZmZjg4MDAw
ZTNjNzk3OCBmZmZmZmZmZjgxMjNiNDk5IGZmZmY4ODAwMGUzYzc5ODgKWyAgICAyLjIzNDU2
MF0gQ2FsbCBUcmFjZToKWyAgICAyLjIzNDg4M10gIFs8ZmZmZmZmZmY4MTYyZGU5ZD5dIGR1
bXBfc3RhY2srMHgxOS8weDFiClsgICAgMi4yMzU1MTVdICBbPGZmZmZmZmZmODE2MmFkOTg+
XSBkdW1wX2hlYWRlci5pc3JhLjEzKzB4NmQvMHgxYjYKWyAgICAyLjIzNjI1Ml0gIFs8ZmZm
ZmZmZmY4MTIzYjQ5OT5dID8gX19kZWxheSsweGYvMHgxMQpbICAgIDIuMjM2ODI4XSAgWzxm
ZmZmZmZmZjgxMjNiNGMxPl0gPyBfX2NvbnN0X3VkZWxheSsweDI2LzB4MjgKWyAgICAyLjIz
NzUyNF0gIFs8ZmZmZmZmZmY4MTBkNWIyYT5dIG91dF9vZl9tZW1vcnkrMHgxZGMvMHgyMzAK
WyAgICAyLjIzODIwNV0gIFs8ZmZmZmZmZmY4MTBkOTQxZj5dIF9fYWxsb2NfcGFnZXNfbm9k
ZW1hc2srMHg1Y2MvMHg3MGUKWyAgICAyLjIzODk1M10gIFs8ZmZmZmZmZmY4MTBmY2I3NT5d
IF9fX19jYWNoZV9hbGxvYysweDM4MC8weDdhZgpbICAgIDIuMjM5NjU5XSAgWzxmZmZmZmZm
ZjgxMTRlZjdlPl0gPyBzeXNmc19uZXdfZGlyZW50KzB4NTMvMHgxMTAKWyAgICAyLjI0MDM3
MV0gIFs8ZmZmZmZmZmY4MTBmYzcyZD5dIGttZW1fY2FjaGVfYWxsb2MrMHg2YS8weDEzMgpb
ICAgIDIuMjQxMDYwXSAgWzxmZmZmZmZmZjgxMTRlZjdlPl0gc3lzZnNfbmV3X2RpcmVudCsw
eDUzLzB4MTEwClsgICAgMi4yNDE3MzBdICBbPGZmZmZmZmZmODExNGYyYzY+XSBjcmVhdGVf
ZGlyKzB4MzgvMHhhOQpbICAgIDIuMjQyMzU2XSAgWzxmZmZmZmZmZjgxMTRmNWZkPl0gc3lz
ZnNfY3JlYXRlX2RpcisweDlhLzB4YjUKWyAgICAyLjI0MzA0M10gIFs8ZmZmZmZmZmY4MTIz
MzA4MT5dIGtvYmplY3RfYWRkX2ludGVybmFsKzB4YzcvMHgxYmIKWyAgICAyLjI0Mzc1N10g
IFs8ZmZmZmZmZmY4MTIzMzYyMD5dIGtvYmplY3RfYWRkKzB4OTMvMHhhNQpbICAgIDIuMjQ0
MzkzXSAgWzxmZmZmZmZmZjgxMmZmODAzPl0gZGV2aWNlX2FkZCsweGVjLzB4NWViClsgICAg
Mi4yNDUwMjddICBbPGZmZmZmZmZmODEwNjQ3YWM+XSA/IF9faW5pdF93YWl0cXVldWVfaGVh
ZCsweDNiLzB4NGUKWyAgICAyLjI0NTc1N10gIFs8ZmZmZmZmZmY4MTJmZmQxYz5dIGRldmlj
ZV9yZWdpc3RlcisweDFhLzB4MWQKWyAgICAyLjI0NjQ0M10gIFs8ZmZmZmZmZmY4MTJiYmEx
OT5dIHR0eV9yZWdpc3Rlcl9kZXZpY2VfYXR0cisweDE3NS8weDFjMwpbICAgIDIuMjQ3MjIy
XSAgWzxmZmZmZmZmZjgxMDg2YThjPl0gPyBsb2NrX3JlbGVhc2UrMHgxNzcvMHgxYmYKWyAg
ICAyLjI0Nzg3Nl0gIFs8ZmZmZmZmZmY4MTJiYmE3YT5dIHR0eV9yZWdpc3Rlcl9kZXZpY2Ur
MHgxMy8weDE1ClsgICAgMi4yNDg1OTBdICBbPGZmZmZmZmZmODEyYmJiOWY+XSB0dHlfcmVn
aXN0ZXJfZHJpdmVyKzB4MTIzLzB4MWFiClsgICAgMi4yNDkzNDFdICBbPGZmZmZmZmZmODFm
MGUxOGE+XSBwdHlfaW5pdCsweDE1Ni8weDM4NwpbICAgIDIuMjQ5OTQxXSAgWzxmZmZmZmZm
ZjgxZjBlMDM0Pl0gPyB0dHlfaW5pdCsweDEyOS8weDEyOQpbICAgIDIuMjUwNTkwXSAgWzxm
ZmZmZmZmZjgxMDAwMjY5Pl0gZG9fb25lX2luaXRjYWxsKzB4ODIvMHgxMTEKWyAgICAyLjI1
MTI3MV0gIFs8ZmZmZmZmZmY4MTA2MjczZD5dID8gcGFyc2VfYXJncysweDE4OS8weDI0Nwpb
ICAgIDIuMjUxOTE3XSAgWzxmZmZmZmZmZjgxZWRlZTEzPl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxMTUvMHgxOWEKWyAgICAyLjI1MjY2M10gIFs8ZmZmZmZmZmY4MWVkZTZkND5dID8g
ZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMi4yNTMzNDhdICBbPGZmZmZmZmZmODE2
MjJhZmQ+XSA/IHJlc3RfaW5pdCsweGMxLzB4YzEKWyAgICAyLjI1Mzk2MF0gIFs8ZmZmZmZm
ZmY4MTYyMmIwYj5dIGtlcm5lbF9pbml0KzB4ZS8weGQ2ClsgICAgMi4yNTQ1OTldICBbPGZm
ZmZmZmZmODE2MzdmN2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDIuMjU1MjQ1
XSAgWzxmZmZmZmZmZjgxNjIyYWZkPl0gPyByZXN0X2luaXQrMHhjMS8weGMxClsgICAgMi4y
NTcwMTZdIE1lbS1JbmZvOgpbICAgIDIuMjU3MzAzXSBETUEgcGVyLWNwdToKWyAgICAyLjI1
NzYwNl0gQ1BVICAgIDA6IGhpOiAgICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVk
YTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtY2Fpcm8tMTE6MjAxNDAzMTcwNDI2NTc6
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2Ni
ZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtY2Fpcm8tMTk6MjAxNDAzMTcwNDI2NTM6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNl
YjUyL2RtZXNnLXF1YW50YWwtcm9hbS0yMDoyMDE0MDMxNzA0MjY1NDp4ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzODozLjEyLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1l
c2cteW9jdG8tY2Fpcm8tMjE6MjAxNDAzMTcwNDI2NTM6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3Rv
LWNhaXJvLTMwOjIwMTQwMzE3MDQyNjUzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4
OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNWUwMWRj
N2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1jYWlyby00
OjIwMTQwMzE3MDQyNjUzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTIuMDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNWUwMWRjN2IyNmQ5ZjI0
ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1yb2FtLTE3OjIwMTQwMzE3
MDQyNjU0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTIuMDoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1
ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLWNhaXJvLTExOjIwMTQwMzE3MDQyNzEw
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNj
YmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLXJvYW0tMTA6MjAxNDAzMTcwNDI3MTA6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNl
YjUyL2RtZXNnLXlvY3RvLWNhaXJvLTIxOjIwMTQwMzE3MDQyNzEwOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVz
Zy15b2N0by1jYWlyby0zOjIwMTQwMzE3MDQyNzA1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1j
YWlyby00NDoyMDE0MDMxNzA0MjcxMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODoz
LjEyLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzVlMDFkYzdi
MjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8tY2Fpcm8tNDoy
MDE0MDMxNzA0MjcxMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjEyLjA6MQow
OjEzOjEzIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTE3IDA0
OjI3OjIzIFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjEyCmdpdCBjaGVja291
dCB2My4xMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6
NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNlY3QtbGludXg5
CgoyMDE0LTAzLTE3LTA0OjI3OjI2IDZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2UgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtNmU0NjY0NTI1YjFk
YjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNmU0NjY0NTI1YjFkYjI4ZjhjNGUx
MTMwOTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtNmU0NjY0
NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LTZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uvdm1saW51ei0zLjExLjAKCjIwMTQtMDMt
MTctMDQ6NTM6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uIFRFU1QgRkFJTFVSRQpb
ICAgIDIuMzA0NTg1XSB1dmVzYWZiOiBwcm9iZSBvZiB1dmVzYWZiLjAgZmFpbGVkIHdpdGgg
ZXJyb3IgLTIyClsgICAgMi4zMDY3MDRdIGlucHV0OiBQb3dlciBCdXR0b24gYXMgL2Rldmlj
ZXMvTE5YU1lTVE06MDAvTE5YUFdSQk46MDAvaW5wdXQvaW5wdXQwClsgICAgMi4zMDc3NjJd
IEFDUEk6IFBvd2VyIEJ1dHRvbiBbUFdSRl0KWyAgICAyLjQ0MjE1N10gc3dhcHBlciBpbnZv
a2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAwMGQwLCBvcmRlcj0wLCBvb21fc2NvcmVf
YWRqPTAKWyAgICAyLjQ0MzE4MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0
YWludGVkIDMuMTEuMCAjMQpbICAgIDIuNDQzOTE4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi40NDQ3MzRdICAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMGUzNWJiMTAgZmZmZmZmZmY4MTYxYWM0OSBmZmZmODgwMDBlMzVi
Yjg4ClsgICAgMi40NDU3NTNdICBmZmZmZmZmZjgxNjE4NzNkIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAwMGE1ODljMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMi40NDY3OTNdICBmZmZm
ZmZmZjgxYzE3NDIwIGZmZmY4ODAwMGUzNWJiNTAgZmZmZmZmZmY4MTIzNTYyOSBmZmZmODgw
MDBlMzViYjYwClsgICAgMi40NDc4NzBdIENhbGwgVHJhY2U6ClsgICAgMi40NDgyNDFdICBb
PGZmZmZmZmZmODE2MWFjNDk+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDIuNDQ4OTAy
XSAgWzxmZmZmZmZmZjgxNjE4NzNkPl0gZHVtcF9oZWFkZXIuaXNyYS4xMysweDZkLzB4MWE4
ClsgICAgMi40NDk3MzNdICBbPGZmZmZmZmZmODEyMzU2Mjk+XSA/IF9fZGVsYXkrMHhmLzB4
MTEKWyAgICAyLjQ1MDM5M10gIFs8ZmZmZmZmZmY4MTIzNTY1MT5dID8gX19jb25zdF91ZGVs
YXkrMHgyNi8weDI4ClsgICAgMi40NTExODRdICBbPGZmZmZmZmZmODEwZDM2NjQ+XSBvdXRf
b2ZfbWVtb3J5KzB4MWRjLzB4MjMwClsgICAgMi40NTE4OTFdICBbPGZmZmZmZmZmODEwZDZl
ZWY+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4NTk0LzB4NmQ2ClsgICAgMi40NTI3NDdd
ICBbPGZmZmZmZmZmODEwZjlhNzQ+XSBfX19fY2FjaGVfYWxsb2MrMHgzODAvMHg3YWYKWyAg
ICAyLjQ1MzUxMF0gIFs8ZmZmZmZmZmY4MTBmYTAzNj5dIF9fa21hbGxvYysweDgxLzB4MTE2
ClsgICAgMi40NTQyMDddICBbPGZmZmZmZmZmODEyYjQ1NjY+XSA/IGt6YWxsb2MuY29uc3Rw
cm9wLjE4KzB4ZS8weDEwClsgICAgMi40NTUwNDddICBbPGZmZmZmZmZmODEyYjQ1NjY+XSBr
emFsbG9jLmNvbnN0cHJvcC4xOCsweGUvMHgxMApbICAgIDIuNDU1Nzg4XSAgWzxmZmZmZmZm
ZjgxMmI0OGIyPl0gdHR5X3JlZ2lzdGVyX2RldmljZV9hdHRyKzB4MTAzLzB4MWI0ClsgICAg
Mi40NTY2ODFdICBbPGZmZmZmZmZmODEwODE5ZDI+XSA/IGxvY2tfcmVsZWFzZSsweDE3Ny8w
eDFiZgpbICAgIDIuNDU3NDQwXSAgWzxmZmZmZmZmZjgxMmI0OTc2Pl0gdHR5X3JlZ2lzdGVy
X2RldmljZSsweDEzLzB4MTUKWyAgICAyLjQ1ODI1Nl0gIFs8ZmZmZmZmZmY4MTJiNGE5Yj5d
IHR0eV9yZWdpc3Rlcl9kcml2ZXIrMHgxMjMvMHgxYWIKWyAgICAyLjQ1OTA2MF0gIFs8ZmZm
ZmZmZmY4MWYwOWI4Mz5dIHB0eV9pbml0KzB4MTU2LzB4Mzg3ClsgICAgMi40NTk3NDhdICBb
PGZmZmZmZmZmODFmMDlhMmQ+XSA/IHR0eV9pbml0KzB4MTI5LzB4MTI5ClsgICAgMi40NjA0
NjFdICBbPGZmZmZmZmZmODEwMDAyNjk+XSBkb19vbmVfaW5pdGNhbGwrMHg4Mi8weDExMQpb
ICAgIDIuNDYxMjYxXSAgWzxmZmZmZmZmZjgxMDYxZDAwPl0gPyBwYXJhbV9hcnJheV9zZXQr
MHhjMS8weGY5ClsgICAgMi40NjIwMjJdICBbPGZmZmZmZmZmODEwNjFmMmQ+XSA/IHBhcnNl
X2FyZ3MrMHgxOTYvMHgyNGMKWyAgICAyLjQ2Mjc2MV0gIFs8ZmZmZmZmZmY4MWVkYWUxMz5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE1LzB4MTk1ClsgICAgMi40NjM1NzRdICBbPGZm
ZmZmZmZmODFlZGE2ZDQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDIuNDY0
MzUxXSAgWzxmZmZmZmZmZjgxNjEwNjdkPl0gPyByZXN0X2luaXQrMHhjMS8weGMxClsgICAg
Mi40NjUwNjhdICBbPGZmZmZmZmZmODE2MTA2OGI+XSBrZXJuZWxfaW5pdCsweGUvMHhkNgpb
ICAgIDIuNDY1NzMzXSAgWzxmZmZmZmZmZjgxNjI0YzZhPl0gcmV0X2Zyb21fZm9yaysweDdh
LzB4YjAKWyAgICAyLjQ2NjQ3NV0gIFs8ZmZmZmZmZmY4MTYxMDY3ZD5dID8gcmVzdF9pbml0
KzB4YzEvMHhjMQpbICAgIDIuNDY3MTcwXSBNZW0tSW5mbzoKWyAgICAyLjQ2NzQ3M10gRE1B
IHBlci1jcHU6ClsgICAgMi40Njc4NDhdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDogICAx
IHVzZDogICAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNmU0NjY0
NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLWNhaXJv
LTI4OjIwMTQwMzE3MDQ1NTU0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTEu
MDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNmU0NjY0NTI1YjFk
YjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLWNhaXJvLTQ0OjIw
MTQwMzE3MDQ1NTUzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTEuMDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNmU0NjY0NTI1YjFkYjI4Zjhj
NGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1jYWlyby0xMDoyMDE0MDMxNzA0
NTU1Mzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjExLjA6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1
N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tY2Fpcm8tMTQ6MjAxNDAzMTcwNDU1NTY6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xMS4wOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlL2RtZXNnLXlvY3RvLWNhaXJvLTE6MjAxNDAzMTcwNDU1NDc6eDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzg6My4xMS4wOjEKMDo1OjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMQpnaXQgY2hlY2tvdXQgdjMuMTAKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOjhiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LWxpbnV4OQoKMjAxNC0wMy0x
Ny0wNDo1NjozMiA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFi
MWQ3N2YzYWM5ZjA3OWUzNzYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5
ZjA3OWUzNzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LThiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC04
YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC84YmI0OTVlM2YwMjQwMWVlNmY3NmQx
YjFkNzdmM2FjOWYwNzllMzc2L3ZtbGludXotMy4xMC4wCgoyMDE0LTAzLTE3LTA1OjIyOjMy
IGRldGVjdGluZyBib290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAyLjgxODQyN10g
dXZlc2FmYjogcHJvYmUgb2YgdXZlc2FmYi4wIGZhaWxlZCB3aXRoIGVycm9yIC0yMgpbICAg
IDIuODIwNjQ4XSBpbnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RNOjAw
L0xOWFBXUkJOOjAwL2lucHV0L2lucHV0MApbICAgIDIuODIyMDg1XSBBQ1BJOiBQb3dlciBC
dXR0b24gW1BXUkZdClsgICAgMi44OTAxNDhdIGtkZXZ0bXBmcyBpbnZva2VkIG9vbS1raWxs
ZXI6IGdmcF9tYXNrPTB4MjgwMGQwLCBvcmRlcj0wLCBvb21fc2NvcmVfYWRqPTAKWyAgICAy
Ljg5MTczOF0gQ1BVOiAwIFBJRDogMTMgQ29tbToga2RldnRtcGZzIE5vdCB0YWludGVkIDMu
MTAuMCAjMQpbICAgIDIuODkyOTg2XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMi44OTQxMDZdICAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAwMGQxYzU5NTggZmZmZmZmZmY4MTYwZTNlZSBmZmZmODgwMDBkMWM1OWQwClsgICAg
Mi44OTU4MTldICBmZmZmZmZmZjgxNjBiZWE2IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAw
MDhiNGE0MCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMi44OTc0MzRdICBmZmZmZmZmZjgxYzE3
NDIwIGZmZmY4ODAwMGQxYzU5OTggZmZmZmZmZmY4MTIzNjhhOSBmZmZmODgwMDBkMWM1OWE4
ClsgICAgMi44OTkxMzddIENhbGwgVHJhY2U6ClsgICAgMi44OTk3MzJdICBbPGZmZmZmZmZm
ODE2MGUzZWU+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDIuOTAwNzIxXSAgWzxmZmZm
ZmZmZjgxNjBiZWE2Pl0gZHVtcF9oZWFkZXIuaXNyYS4xMysweDZkLzB4MWE4ClsgICAgMi45
MDIwMjZdICBbPGZmZmZmZmZmODEyMzY4YTk+XSA/IF9fZGVsYXkrMHhmLzB4MTEKWyAgICAy
LjkwMzAwMl0gIFs8ZmZmZmZmZmY4MTIzNjhkMT5dID8gX19jb25zdF91ZGVsYXkrMHgyNi8w
eDI4ClsgICAgMi45MDQyMTldICBbPGZmZmZmZmZmODEwZDZiYjQ+XSBvdXRfb2ZfbWVtb3J5
KzB4MWRjLzB4MjMwClsgICAgMi45MDU0MDldICBbPGZmZmZmZmZmODEwZGEzZmQ+XSBfX2Fs
bG9jX3BhZ2VzX25vZGVtYXNrKzB4NTk0LzB4NmQ2ClsgICAgMi45MDY2NTJdICBbPGZmZmZm
ZmZmODEwZmM4ODA+XSBfX19fY2FjaGVfYWxsb2MrMHgzODAvMHg3YWYKWyAgICAyLjkwNzg3
Nl0gIFs8ZmZmZmZmZmY4MTExNDQ5Mj5dID8gX19kX2FsbG9jKzB4MjUvMHgxNzAKWyAgICAy
LjkwODk2OF0gIFs8ZmZmZmZmZmY4MTBmYzQzOD5dIGttZW1fY2FjaGVfYWxsb2MrMHg2NS8w
eDEyZApbICAgIDIuOTEwMTYzXSAgWzxmZmZmZmZmZjgxMTE0NDkyPl0gX19kX2FsbG9jKzB4
MjUvMHgxNzAKWyAgICAyLjkxMTI2MV0gIFs8ZmZmZmZmZmY4MTExNDVmYT5dIGRfYWxsb2Mr
MHgxZC8weDdjClsgICAgMi45MTIxNzZdICBbPGZmZmZmZmZmODExMGIwMDI+XSBsb29rdXBf
ZGNhY2hlKzB4N2UvMHg5YgpbICAgIDIuOTEzMzQwXSAgWzxmZmZmZmZmZjgxMTBiMDNhPl0g
X19sb29rdXBfaGFzaCsweDFiLzB4MzYKWyAgICAyLjkxNDQ5OF0gIFs8ZmZmZmZmZmY4MTEw
YjA2ZT5dIGxvb2t1cF9oYXNoKzB4MTkvMHgxYgpbICAgIDIuOTE1NDY3XSAgWzxmZmZmZmZm
ZjgxMTBjZjY1Pl0ga2Vybl9wYXRoX2NyZWF0ZSsweDg1LzB4MTI3ClsgICAgMi45MTY3NTld
ICBbPGZmZmZmZmZmODEwMDg1YWM+XSA/IHBhcmF2aXJ0X3NjaGVkX2Nsb2NrKzB4OS8weGQK
WyAgICAyLjkxNzk4Ml0gIFs8ZmZmZmZmZmY4MTA3NzBiMT5dID8gc2NoZWRfY2xvY2tfbG9j
YWwuY29uc3Rwcm9wLjIrMHhjLzB4NzYKWyAgICAyLjkxOTQ0OF0gIFs8ZmZmZmZmZmY4MTA3
NzFjMD5dID8gc2NoZWRfY2xvY2tfY3B1KzB4NzcvMHg3ZQpbICAgIDIuOTIwNzQyXSAgWzxm
ZmZmZmZmZjgxMDFjNThkPl0gPyBrdm1fY2xvY2tfcmVhZCsweDJiLzB4NWMKWyAgICAyLjky
MTgwMF0gIFs8ZmZmZmZmZmY4MTAwODVhYz5dID8gcGFyYXZpcnRfc2NoZWRfY2xvY2srMHg5
LzB4ZApbICAgIDIuOTIzMTMwXSAgWzxmZmZmZmZmZjgxMmZhMmU4Pl0gaGFuZGxlX2NyZWF0
ZSsweDQxLzB4MWRhClsgICAgMi45MjQxNzRdICBbPGZmZmZmZmZmODEwODQzM2I+XSA/IHB1
dF9sb2NrX3N0YXRzLmlzcmEuMjIrMHhlLzB4MjgKWyAgICAyLjkyNTUzNl0gIFs8ZmZmZmZm
ZmY4MTA4NDYyYT5dID8gbG9ja19yZWxlYXNlX2hvbGR0aW1lLnBhcnQuMjMrMHg3NS8weDdi
ClsgICAgMi45MjY5NjFdICBbPGZmZmZmZmZmODEwODYzMWI+XSA/IGxvY2tfcmVsZWFzZSsw
eDE3Ny8weDFiZgpbICAgIDIuOTI4MTA0XSAgWzxmZmZmZmZmZjgxMmZhNDgxPl0gPyBoYW5k
bGVfY3JlYXRlKzB4MWRhLzB4MWRhClsgICAgMi45MjkzNDBdICBbPGZmZmZmZmZmODEyZmE1
Njc+XSBkZXZ0bXBmc2QrMHhlNi8weDEzYgpbICAgIDIuOTMwMzA0XSAgWzxmZmZmZmZmZjgx
MDZiYzRhPl0ga3RocmVhZCsweGExLzB4YTkKWyAgICAyLjkzMTM4MF0gIFs8ZmZmZmZmZmY4
MTBiOWM4Zj5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4OS8weDIwClsgICAgMi45MzI2NzJd
ICBbPGZmZmZmZmZmODEwODYzMWI+XSA/IGxvY2tfcmVsZWFzZSsweDE3Ny8weDFiZgpbICAg
IDIuOTMzNzI1XSAgWzxmZmZmZmZmZjgxMDZiYmE5Pl0gPyBpbml0X2NvbXBsZXRpb24rMHgy
NC8weDI0ClsgICAgMi45MzQ5MzFdICBbPGZmZmZmZmZmODE2MTY5ZWE+XSByZXRfZnJvbV9m
b3JrKzB4N2EvMHhiMApbICAgIDIuOTM2MDIwXSAgWzxmZmZmZmZmZjgxMDZiYmE5Pl0gPyBp
bml0X2NvbXBsZXRpb24rMHgyNC8weDI0ClsgICAgMi45MzkwMzBdIE1lbS1JbmZvOgpbICAg
IDIuOTM5NTYzXSBETUEgcGVyLWNwdToKWyAgICAyLjk0MDExMV0gQ1BVICAgIDA6IGhpOiAg
ICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNn
LXF1YW50YWwtY2Fpcm8tMjE6MjAxNDAzMTcwNTIyNTI6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzg6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50
YWwtY2Fpcm8tMzM6MjAxNDAzMTcwNTIyNTI6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
Mzg6My4xMC4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC84YmI0
OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtaW5u
LTQzOjIwMTQwMzE3MDUyMjU5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC84YmI0OTVlM2YwMjQwMWVlNmY3
NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtaW5uLTQ2OjIwMTQwMzE3MDUy
MjUzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYw
NzllMzc2L2RtZXNnLXF1YW50YWwtamFrZXRvd24tMTI6MjAxNDAzMTcwNTIyNTY6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1l
c2ctcXVhbnRhbC1qYWtldG93bi0yMToyMDE0MDMxNzA1MjI1Njp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFs
LWpha2V0b3duLTM2OjIwMTQwMzE3MDUyMjU2Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjoKMDo3OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNv
bW1pdCB2My4xMApnaXQgY2hlY2tvdXQgdjMuOQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzE2MjE6YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRh
ZmEyNGFkMTpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTA1OjI0OjA3IGMxYmU1YTViMWIz
NTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgtYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMQpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgtYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFk
MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWMxYmU1YTViMWIzNTVkNDBlNmNmNzlj
Yzk3OWViNjZkYWZhMjRhZDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvdm1s
aW51ei0zLjkuMAoKMjAxNC0wMy0xNy0wNTo0MDowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
Li4uLiBURVNUIEZBSUxVUkUKWyAgICAyLjcyOTM3OF0gYnJkOiBtb2R1bGUgbG9hZGVkClsg
ICAgMi43MzY0NjFdIGxvb3A6IG1vZHVsZSBsb2FkZWQKWyAgICAyLjczODA3OV0gZXZlbnRz
OiBtY2cgZHJiZDogMTAKWyAgICAyLjc5MDU2OV0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxs
ZXI6IGdmcF9tYXNrPTB4MjAwZDIsIG9yZGVyPTAsIG9vbV9zY29yZV9hZGo9MApbICAgIDIu
NzkyMzgxXSBQaWQ6IDEsIGNvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy45LjAgIzEKWyAg
ICAyLjc5MzU5OF0gQ2FsbCBUcmFjZToKWyAgICAyLjc5NDIzNV0gIFs8ZmZmZmZmZmY4MTVm
YjhkNT5dIGR1bXBfaGVhZGVyLmlzcmEuMTMrMHg2ZC8weDFhOApbICAgIDIuNzk1NjUzXSAg
WzxmZmZmZmZmZjgxMjJmNzA5Pl0gPyBfX2RlbGF5KzB4Zi8weDExClsgICAgMi43OTY4Mzdd
ICBbPGZmZmZmZmZmODEyMmY3MzE+XSA/IF9fY29uc3RfdWRlbGF5KzB4MjYvMHgyOApbICAg
IDIuNzk4MjA5XSAgWzxmZmZmZmZmZjgxMGM4ZjRhPl0gb3V0X29mX21lbW9yeSsweDFkYy8w
eDIzMApbICAgIDIuNzk5NTQ5XSAgWzxmZmZmZmZmZjgxMGNjNjgzPl0gX19hbGxvY19wYWdl
c19ub2RlbWFzaysweDU5NC8weDZkNgpbICAgIDIuODAwNzI2XSAgWzxmZmZmZmZmZjgxZWY0
MTA5Pl0gZHJiZF9pbml0KzB4MjhiLzB4NDYyClsgICAgMi44MDE2OTFdICBbPGZmZmZmZmZm
ODFlZjNlN2U+XSA/IHBrdF9pbml0KzB4MTkwLzB4MTkwClsgICAgMi44MDI2NzNdICBbPGZm
ZmZmZmZmODEwMDAyNWM+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZC8weDEzNwpbICAgIDIuODAz
NzIxXSAgWzxmZmZmZmZmZjgxZWQwZTE5Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTUv
MHgxOTUKWyAgICAyLjgwNDg0OV0gIFs8ZmZmZmZmZmY4MWVkMDZmMj5dID8gZG9fZWFybHlf
cGFyYW0rMHg4OC8weDg4ClsgICAgMi44MDU4OTBdICBbPGZmZmZmZmZmODE1ZjM4MTg+XSA/
IHJlc3RfaW5pdCsweGJjLzB4YmMKWyAgICAyLjgwNjg1M10gIFs8ZmZmZmZmZmY4MTVmMzgy
Nj5dIGtlcm5lbF9pbml0KzB4ZS8weGQ2ClsgICAgMi44MDc4MTldICBbPGZmZmZmZmZmODE2
MDYxNmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDIuODA4ODEwXSAgWzxmZmZm
ZmZmZjgxNWYzODE4Pl0gPyByZXN0X2luaXQrMHhiYy8weGJjClsgICAgMi44MDk3NjhdIE1l
bS1JbmZvOgpbICAgIDIuODEwMjE0XSBETUEgcGVyLWNwdToKWyAgICAyLjgxMDY4MV0gQ1BV
ICAgIDA6IGhpOiAgICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFm
YTI0YWQxL2RtZXNnLXF1YW50YWwtYXRoZW5zLTMzOjIwMTQwMzE3MDU0MDI4Ong4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuOS4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQx
L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjE6MjAxNDAzMTcwNTQwMzE6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzg6My45LjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1lc2ct
cXVhbnRhbC1jYWlyby0zMzoyMDE0MDMxNzA1NDAyOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzODozLjkuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMS9kbWVzZy1xdWFudGFs
LWNhaXJvLTQyOjIwMTQwMzE3MDU0MDI4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4
OjMuOS4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9jMWJlNWE1
YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXF1YW50YWwteGlhbi0x
MjoyMDE0MDMxNzA1NDAxNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjkuMDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvYzFiZTVhNWIxYjM1NWQ0
MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMS9kbWVzZy1xdWFudGFsLWlubi0yNToyMDE0MDMx
NzA1NDAyMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzgvYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2
NmRhZmEyNGFkMS9kbWVzZy1xdWFudGFsLWpha2V0b3duLTI3OjIwMTQwMzE3MDU0MDI2Ong4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQx
L2RtZXNnLXF1YW50YWwtamFrZXRvd24tMzQ6MjAxNDAzMTcwNTQwMzA6eDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1lc2ctcXVh
bnRhbC1zbmItMTA6MjAxNDAzMTcwNTQwMjY6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
Mzg6OgowOjk6OSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0x
NyAwNTo0MjozOSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg5L29i
ai1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My45CmdpdCBjaGVj
a291dCB2My44CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMTYy
MToxOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwOmJpc2VjdC1saW51
eDkKCjIwMTQtMDMtMTctMDU6NDI6NDQgMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJl
MTRiZmNiMTIwMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC0xOWY5NDlmNTI1
OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8xOWY5NDlmNTI1OTliYTdjM2Y2
N2E1ODk3YWM2YmUxNGJmY2IxMjAwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC0xOWY5
NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgtMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMApr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvMTlmOTQ5ZjUy
NTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMC92bWxpbnV6LTMuOC4wCgoyMDE0LTAz
LTE3LTA1OjU1OjQ0IGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAg
IDAuMDAwMDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjkwMDAgKGZlYzAwMDAw
KQpbICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0t
LS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6
IGF0IGFyY2gveDg2L2tlcm5lbC9wdmNsb2NrLmM6MTgyIHB2Y2xvY2tfaW5pdF92c3lzY2Fs
bCsweDIxLzB4NTkoKQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocwpbICAg
IDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBj
b21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuOC4wICMxClsgICAgMC4wMDAwMDBdIENhbGwg
VHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNDA1MDA+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDgxLzB4OTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA0MDVj
Nj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWNkNTM5OT5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNTMwMD5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1l
aW5mbysweDVjLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNTBhNj5dIGt2
bV9ndWVzdF9pbml0KzB4ZTQvMHhlYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Ni
YjllPl0gc2V0dXBfYXJjaCsweGE5NS8weGFlMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxY2M4N2M1Pl0gc3RhcnRfa2VybmVsKzB4OWMvMHgzY2UKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNjODEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYzgyMjg+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2
YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MzJiPl0g
eDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEwZApbICAgIDAuMDAwMDAwXSAtLS1bIGVu
ZCB0cmFjZSAwNjNkYWUwMTA0MjM0YmU4IF0tLS0KWyAgICAwLjAwMDAwMF0gS1ZNIHNldHVw
IGFzeW5jIFBGIGZvciBjcHUgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvZG1lc2ctcXVh
bnRhbC1jYWlyby0zOjIwMTQwMzE3MDU1NTI0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuOC4wOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIw
MTQtMDMtMTcgMDU6NTY6NDUgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xp
bnV4OS9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuOApn
aXQgY2hlY2tvdXQgdjMuNwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwMzE2MjE6Mjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZTpiaXNl
Y3QtbGludXg5CgoyMDE0LTAzLTE3LTA1OjU2OjUyIDI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRl
ZThjNDNkY2M1Mzk3MGM2MGUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtMjk1
OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvMjk1OTQ0MDRkN2Zl
NzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgtMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4LTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3
MGM2MGUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzI5
NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUvdm1saW51ei0zLjcuMAoK
MjAxNC0wMy0xNy0wNjoxNTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTQJMTAJMTMJ
MTYJMTkJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My43CmdpdCBiaXNlY3Qg
c3RhcnQgdjMuOCB2My43IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1i
IiwgInYzLjgiLCAiLWciLCAidjMuNyIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QiXQpC
aXNlY3Rpbmc6IDEzNTI2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxNCBzdGVwcykKWzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1Mjgy
NzVdIE1lcmdlIHRhZyAnb21hcC1sYXRlLWNsZWFudXBzJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXJtL2FybS1zb2MKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMv
bGludXg5L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDMxNjIxOjhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzU6Ymlz
ZWN0LWxpbnV4OQoKMjAxNC0wMy0xNy0wNjoyMDo1OSA4ZDkxYTQyZTU0ZWViYzQzZjRkOGY2
MDY0NzUxY2NiYTczNTI4Mjc1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LThk
OTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJlNTRl
ZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LThkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC04ZDkxYTQyZTU0ZWViYzQzZjRkOGY2MDY0NzUxY2NiYTcz
NTI4Mjc1Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC84
ZDkxYTQyZTU0ZWViYzQzZjRkOGY2MDY0NzUxY2NiYTczNTI4Mjc1L3ZtbGludXotMy44LjAt
cmMxLTAwMDUzLWc4ZDkxYTQyCgoyMDE0LTAzLTE3LTA2OjM2OjU5IGRldGVjdGluZyBib290
IHN0YXRlIC4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIG1hcHBlZCBJT0FQSUMg
dG8gZmZmZmZmZmZmZjVmOTAwMCAoZmVjMDAwMDApClsgICAgMC4wMDAwMDBdIG5yX2lycXNf
Z3NpOiA0MApbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzogYXQgYXJjaC94ODYva2VybmVsL3B2Y2xv
Y2suYzoxODIgcHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OSgpClsgICAgMC4wMDAw
MDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAgMC4wMDAwMDBdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgIDAuMDAwMDAwXSBQaWQ6IDAsIGNvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My44LjAtcmMxLTAwMDUzLWc4ZDkxYTQyICMxClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNDA0ZTA+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDgxLzB4OTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA0MDVhNj5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNkNTE2Mj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MWNkNTBjOT5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysw
eDVjLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNGU2Zj5dIGt2bV9ndWVz
dF9pbml0KzB4ZTQvMHhlYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2NiOTY3Pl0g
c2V0dXBfYXJjaCsweDllZS8weGEzOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4
N2M1Pl0gc3RhcnRfa2VybmVsKzB4OWMvMHgzY2UKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNjODEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFjYzgyMjg+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MzJiPl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEwZApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSA5ZmYyMWI0ZjM5YjYxYmI3IF0tLS0KWyAgICAwLjAwMDAwMF0gS1ZNIHNldHVwIGFzeW5j
IFBGIGZvciBjcHUgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4Lzhk
OTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUvZG1lc2ctcXVhbnRhbC1j
YWlyby0xMDoyMDE0MDMxNzA2MzcyNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODoz
LjguMC1yYzEtMDAwNTMtZzhkOTFhNDI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUvZG1l
c2ctcXVhbnRhbC1jYWlyby0xNzoyMDE0MDMxNzA2MzcyNDp4ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzODozLjguMC1yYzEtMDAwNTMtZzhkOTFhNDI6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2Jh
NzM1MjgyNzUvZG1lc2ctcXVhbnRhbC1jYWlyby0yMzoyMDE0MDMxNzA2MzcyMzp4ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjguMC1yYzEtMDAwNTMtZzhkOTFhNDI6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4
ZjYwNjQ3NTFjY2JhNzM1MjgyNzUvZG1lc2ctcXVhbnRhbC1jYWlyby0yNToyMDE0MDMxNzA2
MzcyNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjguMC1yYzEtMDAwNTMtZzhk
OTFhNDI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJl
NTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUvZG1lc2ctcXVhbnRhbC1jYWlyby0y
OToyMDE0MDMxNzA2MzcyMDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjguMC1y
YzEtMDAwNTMtZzhkOTFhNDI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1MjgyNzUvZG1lc2ctcXVh
bnRhbC1jYWlyby0zNjoyMDE0MDMxNzA2MzcyMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzODozLjguMC1yYzEtMDAwNTMtZzhkOTFhNDI6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3NTFjY2JhNzM1Mjgy
NzUvZG1lc2ctcXVhbnRhbC1jYWlyby0zNzoyMDE0MDMxNzA2MzczMTp4ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzODozLjguMC1yYzEtMDAwNTMtZzhkOTFhNDI6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzhkOTFhNDJlNTRlZWJjNDNmNGQ4ZjYwNjQ3
NTFjY2JhNzM1MjgyNzUvZG1lc2ctcXVhbnRhbC1jYWlyby0zOjIwMTQwMzE3MDYzNzIwOng4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuOC4wLXJjMS0wMDA1My1nOGQ5MWE0Mjox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvOGQ5MWE0MmU1NGVlYmM0
M2Y0ZDhmNjA2NDc1MWNjYmE3MzUyODI3NS9kbWVzZy1xdWFudGFsLWNhaXJvLTQ6MjAxNDAz
MTcwNjM3MTg6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My44LjAtcmMxLTAwMDUz
LWc4ZDkxYTQyOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC84ZDkx
YTQyZTU0ZWViYzQzZjRkOGY2MDY0NzUxY2NiYTczNTI4Mjc1L2RtZXNnLXF1YW50YWwtY2Fp
cm8tNDoyMDE0MDMxNzA2Mzc0Mjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjgu
MC1yYzEtMDAwNTMtZzhkOTFhNDI6MQowOjEwOjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW0yMDE0LTAzLTE3IDA2OjM5OjAwIFJFUEVBVCBDT1VOVDogMjAgICMgL2tl
cm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAx
MTc5MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3Rl
cHMpCls3NzBiNmNiNGQyMWZiM2UzZGYyYTdhNTFlMTg2YTNjMTRkYjFlYzMwXSBBUk06IE9N
QVA6IEZpeCBkcml2ZXJzIHRvIGRlcGVuZCBvbiBvbWFwIGZvciBpbnRlcm5hbCBkZXZpY2Vz
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDAzMTYyMTo3NzBiNmNiNGQyMWZiM2UzZGYyYTdhNTFlMTg2YTNj
MTRkYjFlYzMwOmJpc2VjdC1saW51eDkKCjIwMTQtMDMtMTctMDY6Mzk6MDYgNzcwYjZjYjRk
MjFmYjNlM2RmMmE3YTUxZTE4NmEzYzE0ZGIxZWMzMCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC03NzBiNmNiNGQyMWZiM2UzZGYyYTdhNTFlMTg2YTNjMTRkYjFlYzMwCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC83NzBiNmNiNGQyMWZiM2UzZGYyYTdhNTFlMTg2YTNjMTRkYjFlYzMwCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC03NzBiNmNiNGQyMWZiM2UzZGYyYTdhNTFlMTg2YTNjMTRkYjFl
YzMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtNzcwYjZjYjRkMjFmYjNlM2RmMmE3
YTUxZTE4NmEzYzE0ZGIxZWMzMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgvNzcwYjZjYjRkMjFmYjNlM2RmMmE3YTUxZTE4NmEzYzE0ZGIxZWMzMC92
bWxpbnV6LTMuNy4wLTA4NTY5LWc3NzBiNmNiCgoyMDE0LTAzLTE3LTA3OjAyOjA2IGRldGVj
dGluZyBib290IHN0YXRlIAkxLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzIzNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCltlMzI3
OTU1MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiXSBNZXJnZSB0YWdzICdkdC1m
b3ItbGludXMnLCAnZ3Bpby1mb3ItbGludXMnIGFuZCAnc3BpLWZvci1saW51cycgb2YgZ2l0
Oi8vZ2l0LnNlY3JldGxhYi5jYS9naXQvbGludXgtMi42CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4OS9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMTYy
MTplMzI3OTU1MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiOmJpc2VjdC1saW51
eDkKCjIwMTQtMDMtMTctMDc6MDQ6NDAgZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVlMDM5Y2My
NjhmNmEwZWNmYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC1lMzI3OTU1MDNk
ZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lMzI3OTU1MDNkZTAyZGE0ZTdl
NzRhNWUwMzljYzI2OGY2YTBlY2ZiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC1lMzI3
OTU1MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgtZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZTMyNzk1NTAz
ZGUwMmRhNGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYi92bWxpbnV6LTMuNy4wLTExMDM1LWdl
MzI3OTU1CgoyMDE0LTAzLTE3LTA3OjE0OjQwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
CTggVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIG1hcHBlZCBJT0FQSUMgdG8gZmZmZmZm
ZmZmZjVmOTAwMCAoZmVjMDAwMDApClsgICAgMC4wMDAwMDBdIG5yX2lycXNfZ3NpOiA0MApb
ICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICAwLjAwMDAwMF0gV0FSTklORzogYXQgYXJjaC94ODYva2VybmVsL3B2Y2xvY2suYzoxODIg
cHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OSgpClsgICAgMC4wMDAwMDBdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzClsgICAgMC4wMDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAg
IDAuMDAwMDAwXSBQaWQ6IDAsIGNvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy43LjAtMTEw
MzUtZ2UzMjc5NTUgIzEKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTA0MDY4Yj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4ODEvMHg5
OQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDQwNzUxPl0gd2Fybl9zbG93cGF0aF9u
dWxsKzB4MWEvMHgxYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Q1MTYyPl0gcHZj
bG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxY2Q1MGM5Pl0ga3ZtX3NldHVwX3ZzeXNjYWxsX3RpbWVpbmZvKzB4NWMvMHhiOQpbICAg
IDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Q0ZTZmPl0ga3ZtX2d1ZXN0X2luaXQrMHhlNC8w
eGVjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjY2I5Njc+XSBzZXR1cF9hcmNoKzB4
OWVlLzB4YTM5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYzg3YzU+XSBzdGFydF9r
ZXJuZWwrMHg5Yy8weDNjZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MTIwPl0g
PyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWNjODIyOD5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHhiMC8weGIzClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYzgzMmI+XSB4ODZfNjRfc3RhcnRfa2VybmVs
KzB4MTAwLzB4MTBkClsgICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDY4YzQxZGVkYzc2
MWVlYjUgXS0tLQpbICAgIDAuMDAwMDAwXSBLVk0gc2V0dXAgYXN5bmMgUEYgZm9yIGNwdSAw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZTMyNzk1NTAzZGUwMmRh
NGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWNhaXJvLTEyOjIwMTQw
MzE3MDcxNDIyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTExMDM1LWdl
MzI3OTU1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lMzI3OTU1
MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiL2RtZXNnLXF1YW50YWwtY2Fpcm8t
MTM6MjAxNDAzMTcwNzE0MDk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43LjAt
MTEwMzUtZ2UzMjc5NTU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4
L2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRh
bC1jYWlyby0xMzoyMDE0MDMxNzA3MTQzODp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
ODozLjcuMC0xMTAzNS1nZTMyNzk1NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYi9kbWVz
Zy1xdWFudGFsLWNhaXJvLTI2OjIwMTQwMzE3MDcxNDA0Ong4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4OjMuNy4wLTExMDM1LWdlMzI3OTU1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC9lMzI3OTU1MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBl
Y2ZiL2RtZXNnLXF1YW50YWwtY2Fpcm8tMjg6MjAxNDAzMTcwNzE0MDM6eDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzg6My43LjAtMTEwMzUtZ2UzMjc5NTU6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNj
MjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1jYWlyby0zMzoyMDE0MDMxNzA3MTQzOTp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMTAzNS1nZTMyNzk1NToxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0
YTVlMDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWNhaXJvLTM0OjIwMTQwMzE3MDcx
NDIwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTExMDM1LWdlMzI3OTU1
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lMzI3OTU1MDNkZTAy
ZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzc6MjAx
NDAzMTcwNzE0MzU6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43LjAtMTEwMzUt
Z2UzMjc5NTU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2UzMjc5
NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1jYWly
by0zOToyMDE0MDMxNzA3MTQxNjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjcu
MC0xMTAzNS1nZTMyNzk1NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFu
dGFsLWNhaXJvLTQ0OjIwMTQwMzE3MDcxNDM5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuNy4wLTExMDM1LWdlMzI3OTU1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC9lMzI3OTU1MDNkZTAyZGE0ZTdlNzRhNWUwMzljYzI2OGY2YTBlY2ZiL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tNDU6MjAxNDAzMTcwNzE0MzQ6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6My43LjAtMTEwMzUtZ2UzMjc5NTU6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4L2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZh
MGVjZmIvZG1lc2ctcXVhbnRhbC1jYWlyby04OjIwMTQwMzE3MDcxNDM4Ong4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTExMDM1LWdlMzI3OTU1OjEKMDoxMjoyMCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0xNyAwNzoxNzo0MSBSRVBF
QVQgQ09VTlQ6IDI2ICAjIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCkJpc2VjdGluZzogMjQ2NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTIgc3RlcHMpCls5YThhNTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4
ZGQ4YjUwNDQwXSBNZXJnZSB0YWcgJ2Zvci0zLjgnIG9mIGdpdDovL29wZW5yaXNjLm5ldC9+
am9uYXMvbGludXgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOjlhOGE1NzAyYzVhNzI5OGMwZWRk
MTI1NDY0YWExNzhkZDhiNTA0NDA6YmlzZWN0LWxpbnV4OQoKMjAxNC0wMy0xNy0wNzoxNzo0
NCA5YThhNTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LTlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0YWExNzhk
ZDhiNTA0NDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMTcwMDM4LzlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0YWExNzhkZDhiNTA0NDAK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0
YWExNzhkZDhiNTA0NDAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC05YThhNTcwMmM1
YTcyOThjMGVkZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85YThhNTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4
ZGQ4YjUwNDQwL3ZtbGludXotMy43LjAtMTA1OTItZzlhOGE1NzAKCjIwMTQtMDMtMTctMDc6
NDU6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAw
MF0gbWFwcGVkIElPQVBJQyB0byBmZmZmZmZmZmZmNWY5MDAwIChmZWMwMDAwMCkKWyAgICAw
LjAwMDAwMF0gbnJfaXJxc19nc2k6IDQwClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBhdCBhcmNo
L3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4MiBwdmNsb2NrX2luaXRfdnN5c2NhbGwrMHgyMS8w
eDU5KCkKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAwLjAwMDAw
MF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4wMDAwMDBdIFBpZDogMCwgY29tbTogc3dh
cHBlciBOb3QgdGFpbnRlZCAzLjcuMC0xMDU5Mi1nOWE4YTU3MCAjMQpbICAgIDAuMDAwMDAw
XSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDQwNjhiPl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg4MS8weDk5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODEwNDA3NTE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxYS8weDFjClsgICAgMC4wMDAwMDBd
ICBbPGZmZmZmZmZmODFjZDUxNjI+XSBwdmNsb2NrX2luaXRfdnN5c2NhbGwrMHgyMS8weDU5
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDUwYzk+XSBrdm1fc2V0dXBfdnN5c2Nh
bGxfdGltZWluZm8rMHg1Yy8weGI5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDRl
NmY+XSBrdm1fZ3Vlc3RfaW5pdCsweGU0LzB4ZWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNjYjk2Nz5dIHNldHVwX2FyY2grMHg5ZWUvMHhhMzkKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNjODdjNT5dIHN0YXJ0X2tlcm5lbCsweDljLzB4M2NlClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFjYzgxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8w
eDEyMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MjI4Pl0geDg2XzY0X3N0YXJ0
X3Jlc2VydmF0aW9ucysweGIwLzB4YjMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNj
ODMyYj5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHgxMDAvMHgxMGQKWyAgICAwLjAwMDAwMF0g
LS0tWyBlbmQgdHJhY2UgNTJiNWIzZjNkMWNiN2U1YiBdLS0tClsgICAgMC4wMDAwMDBdIEtW
TSBzZXR1cCBhc3luYyBQRiBmb3IgY3B1IDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC85YThhNTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tMTI6MjAxNDAzMTcwNzQ1MzQ6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6My43LjAtMTA1OTItZzlhOGE1NzA6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4LzlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0YWExNzhkZDhi
NTA0NDAvZG1lc2ctcXVhbnRhbC1jYWlyby0xNToyMDE0MDMxNzA3NDUzMzp4ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMDU5Mi1nOWE4YTU3MDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvOWE4YTU3MDJjNWE3Mjk4YzBlZGQxMjU0NjRh
YTE3OGRkOGI1MDQ0MC9kbWVzZy1xdWFudGFsLWNhaXJvLTE2OjIwMTQwMzE3MDc0NTI4Ong4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwNTkyLWc5YThhNTcwOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85YThhNTcwMmM1YTcyOThjMGVk
ZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwL2RtZXNnLXF1YW50YWwtY2Fpcm8tMTc6MjAxNDAzMTcw
NzQ1MjI6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43LjAtMTA1OTItZzlhOGE1
NzA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzlhOGE1NzAyYzVh
NzI5OGMwZWRkMTI1NDY0YWExNzhkZDhiNTA0NDAvZG1lc2ctcXVhbnRhbC1jYWlyby0xOjIw
MTQwMzE3MDc0NTIzOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwNTky
LWc5YThhNTcwOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85YThh
NTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwL2RtZXNnLXF1YW50YWwtY2Fp
cm8tMjc6MjAxNDAzMTcwNzQ1Mjg6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43
LjAtMTA1OTItZzlhOGE1NzA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LzlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0YWExNzhkZDhiNTA0NDAvZG1lc2ctcXVh
bnRhbC1jYWlyby0yOjIwMTQwMzE3MDc0NTI0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuNy4wLTEwNTkyLWc5YThhNTcwOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC85YThhNTcwMmM1YTcyOThjMGVkZDEyNTQ2NGFhMTc4ZGQ4YjUwNDQwL2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tMzA6MjAxNDAzMTcwNzQ1MjM6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6My43LjAtMTA1OTItZzlhOGE1NzA6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4LzlhOGE1NzAyYzVhNzI5OGMwZWRkMTI1NDY0YWExNzhkZDhi
NTA0NDAvZG1lc2ctcXVhbnRhbC1jYWlyby0zNzoyMDE0MDMxNzA3NDUzMzp4ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMDU5Mi1nOWE4YTU3MDoxCjA6OTo3IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDIwMjMgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbOTM2MGI1MzY2MWEyYzc3
NTQ1MTdiMjkyNTU4MDA1NWJhY2M4ZWMzOF0gUmV2ZXJ0ICJiZGk6IGFkZCBhIHVzZXItdHVu
YWJsZSBjcHVfbGlzdCBmb3IgdGhlIGJkaSBmbHVzaGVyIHRocmVhZHMiCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDAzMTYyMTo5MzYwYjUzNjYxYTJjNzc1NDUxN2IyOTI1NTgwMDU1YmFjYzhlYzM4OmJp
c2VjdC1saW51eDkKCjIwMTQtMDMtMTctMDc6NDY6MTkgOTM2MGI1MzY2MWEyYzc3NTQ1MTdi
MjkyNTU4MDA1NWJhY2M4ZWMzOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC05
MzYwYjUzNjYxYTJjNzc1NDUxN2IyOTI1NTgwMDU1YmFjYzhlYzM4CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85MzYwYjUzNjYx
YTJjNzc1NDUxN2IyOTI1NTgwMDU1YmFjYzhlYzM4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC05MzYwYjUzNjYxYTJjNzc1NDUxN2IyOTI1NTgwMDU1YmFjYzhlYzM4CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgtOTM2MGI1MzY2MWEyYzc3NTQ1MTdiMjkyNTU4MDA1NWJh
Y2M4ZWMzOAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
OTM2MGI1MzY2MWEyYzc3NTQ1MTdiMjkyNTU4MDA1NWJhY2M4ZWMzOC92bWxpbnV6LTMuNy4w
LTA5NDMyLWc5MzYwYjUzCgoyMDE0LTAzLTE3LTA4OjA4OjE5IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4JMTMJMjUuLi4uLgkyNiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExNjAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbZWE4OGVl
YWMwY2I4MzI4MDE0YjUzZDgwY2E2MzFlOGRjMGRjMThkY10gTWVyZ2UgdGFnICdtZC0zLjgn
IG9mIGdpdDovL25laWwuYnJvd24ubmFtZS9tZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6ZWE4
OGVlYWMwY2I4MzI4MDE0YjUzZDgwY2E2MzFlOGRjMGRjMThkYzpiaXNlY3QtbGludXg5Cgoy
MDE0LTAzLTE3LTA4OjE0OjIyIGVhODhlZWFjMGNiODMyODAxNGI1M2Q4MGNhNjMxZThkYzBk
YzE4ZGMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtZWE4OGVlYWMwY2I4MzI4
MDE0YjUzZDgwY2E2MzFlOGRjMGRjMThkYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZWE4OGVlYWMwY2I4MzI4MDE0YjUzZDgw
Y2E2MzFlOGRjMGRjMThkYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtZWE4OGVlYWMw
Y2I4MzI4MDE0YjUzZDgwY2E2MzFlOGRjMGRjMThkYwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4LWVhODhlZWFjMGNiODMyODAxNGI1M2Q4MGNhNjMxZThkYzBkYzE4ZGMKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2VhODhlZWFjMGNiODMy
ODAxNGI1M2Q4MGNhNjMxZThkYzBkYzE4ZGMvdm1saW51ei0zLjcuMC0xMDI3OS1nZWE4OGVl
YQoKMjAxNC0wMy0xNy0wODoyMjoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMDAwMDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjkwMDAg
KGZlYzAwMDAwKQpbICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAw
MF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBd
IFdBUk5JTkc6IGF0IGFyY2gveDg2L2tlcm5lbC9wdmNsb2NrLmM6MTgyIHB2Y2xvY2tfaW5p
dF92c3lzY2FsbCsweDIxLzB4NTkoKQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBC
b2NocwpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0g
UGlkOiAwLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuNy4wLTEwMjc5LWdlYTg4ZWVh
ICMxClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODEwNDA2OGI+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDgxLzB4OTkKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MTA0MDc1MT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4
MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNTE2Mj5dIHB2Y2xvY2tfaW5pdF92
c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNTBjOT5d
IGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysweDVjLzB4YjkKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNkNGU2Zj5dIGt2bV9ndWVzdF9pbml0KzB4ZTQvMHhlYwpbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgxY2NiOTY3Pl0gc2V0dXBfYXJjaCsweDllZS8weGEzOQpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4N2M1Pl0gc3RhcnRfa2VybmVsKzB4OWMv
MHgzY2UKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNjODEyMD5dID8gZWFybHlfaWR0
X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYzgy
Mjg+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxY2M4MzJiPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEw
ZApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBkMGM2YjA1NWYxYTY0Y2JjIF0tLS0K
WyAgICAwLjAwMDAwMF0gS1ZNIHNldHVwIGFzeW5jIFBGIGZvciBjcHUgMAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2VhODhlZWFjMGNiODMyODAxNGI1M2Q4MGNh
NjMxZThkYzBkYzE4ZGMvZG1lc2ctcXVhbnRhbC1jYWlyby0zODoyMDE0MDMxNzA4MjIxODp4
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMDI3OS1nZWE4OGVlYToxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZWE4OGVlYWMwY2I4MzI4MDE0
YjUzZDgwY2E2MzFlOGRjMGRjMThkYy9kbWVzZy1xdWFudGFsLWlubi0zNToyMDE0MDMxNzA4
MjIyMzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6CjA6MjoyIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDg0NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCltjZTRhOWNjNTc5MzgxYmM3MGIxMmVi
YjkxYzU3ZGEzMWJhZjhlM2I3XSBtbSxudW1hOiBmaXggdXBkYXRlX21tdV9jYWNoZV9wbWQg
Y2FsbApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6Y2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1
N2RhMzFiYWY4ZTNiNzpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTA4OjIyOjU2IGNlNGE5
Y2M1NzkzODFiYzcwYjEyZWJiOTFjNTdkYTMxYmFmOGUzYjcgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgtY2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1N2RhMzFiYWY4ZTNi
NwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMx
NzAwMzgvY2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1N2RhMzFiYWY4ZTNiNwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgtY2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1N2RhMzFi
YWY4ZTNiNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWNlNGE5Y2M1NzkzODFiYzcw
YjEyZWJiOTFjNTdkYTMxYmFmOGUzYjcKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4L2NlNGE5Y2M1NzkzODFiYzcwYjEyZWJiOTFjNTdkYTMxYmFmOGUz
Yjcvdm1saW51ei0zLjcuMC0xMDA4NS1nY2U0YTljYwoKMjAxNC0wMy0xNy0wODozNjo1NiBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBt
YXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjkwMDAgKGZlYzAwMDAwKQpbICAgIDAuMDAw
MDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IGF0IGFyY2gveDg2
L2tlcm5lbC9wdmNsb2NrLmM6MTgyIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTko
KQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocwpbICAgIDAuMDAwMDAwXSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVy
IE5vdCB0YWludGVkIDMuNy4wLTEwMDg1LWdjZTRhOWNjICMxClsgICAgMC4wMDAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNDA2OGI+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDgxLzB4OTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA0
MDc1MT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNkNTE2Mj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNTBjOT5dIGt2bV9zZXR1cF92c3lzY2FsbF90
aW1laW5mbysweDVjLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNGU2Zj5d
IGt2bV9ndWVzdF9pbml0KzB4ZTQvMHhlYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
Y2NiOTY3Pl0gc2V0dXBfYXJjaCsweDllZS8weGEzOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxY2M4N2M1Pl0gc3RhcnRfa2VybmVsKzB4OWMvMHgzY2UKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNjODEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIw
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYzgyMjg+XSB4ODZfNjRfc3RhcnRfcmVz
ZXJ2YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MzJi
Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEwZApbICAgIDAuMDAwMDAwXSAtLS1b
IGVuZCB0cmFjZSBiYmZmNmNlMTZhMzM3ZmNkIF0tLS0KWyAgICAwLjAwMDAwMF0gS1ZNIHNl
dHVwIGFzeW5jIFBGIGZvciBjcHUgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4L2NlNGE5Y2M1NzkzODFiYzcwYjEyZWJiOTFjNTdkYTMxYmFmOGUzYjcvZG1lc2ct
cXVhbnRhbC1jYWlyby0xMjoyMDE0MDMxNzA4MzcxNDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzODozLjcuMC0xMDA4NS1nY2U0YTljYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvY2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1N2RhMzFiYWY4ZTNi
Ny9kbWVzZy1xdWFudGFsLWNhaXJvLTEyOjIwMTQwMzE3MDgzNzMzOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwMDg1LWdjZTRhOWNjOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9jZTRhOWNjNTc5MzgxYmM3MGIxMmViYjkxYzU3ZGEz
MWJhZjhlM2I3L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjE6MjAxNDAzMTcwODM3NDA6eDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43LjAtMTAwODUtZ2NlNGE5Y2M6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2NlNGE5Y2M1NzkzODFiYzcwYjEyZWJi
OTFjNTdkYTMxYmFmOGUzYjcvZG1lc2ctcXVhbnRhbC1jYWlyby0zNzoyMDE0MDMxNzA4Mzcx
Njp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMDA4NS1nY2U0YTljYzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2U0YTljYzU3OTM4MWJj
NzBiMTJlYmI5MWM1N2RhMzFiYWY4ZTNiNy9kbWVzZy1xdWFudGFsLWNhaXJvLTM3OjIwMTQw
MzE3MDgzNzQwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwMDg1LWdj
ZTRhOWNjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9jZTRhOWNj
NTc5MzgxYmM3MGIxMmViYjkxYzU3ZGEzMWJhZjhlM2I3L2RtZXNnLXF1YW50YWwtY2Fpcm8t
NDQ6MjAxNDAzMTcwODM3Mzg6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My43LjAt
MTAwODUtZ2NlNGE5Y2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4
L2NlNGE5Y2M1NzkzODFiYzcwYjEyZWJiOTFjNTdkYTMxYmFmOGUzYjcvZG1lc2ctcXVhbnRh
bC1jYWlyby00ODoyMDE0MDMxNzA4MzcyOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
ODozLjcuMC0xMDA4NS1nY2U0YTljYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvY2U0YTljYzU3OTM4MWJjNzBiMTJlYmI5MWM1N2RhMzFiYWY4ZTNiNy9kbWVz
Zy1xdWFudGFsLWNhaXJvLTQ6MjAxNDAzMTcwODM3MTE6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzg6My43LjAtMTAwODUtZ2NlNGE5Y2M6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4L2NlNGE5Y2M1NzkzODFiYzcwYjEyZWJiOTFjNTdkYTMxYmFmOGUz
YjcvZG1lc2ctcXVhbnRhbC1jYWlyby00OjIwMTQwMzE3MDgzNzI5Ong4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwMDg1LWdjZTRhOWNjOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9jZTRhOWNjNTc5MzgxYmM3MGIxMmViYjkxYzU3ZGEz
MWJhZjhlM2I3L2RtZXNnLXF1YW50YWwtY2Fpcm8tNjoyMDE0MDMxNzA4MzcyNjp4ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjcuMC0xMDA4NS1nY2U0YTljYzoxCjA6MTA6MTAg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNjUzIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzkyMjhmZjkwMzg3
ZTI3NmFkNjdiMTBjMGViNTI1YzlkNmE1N2Q1ZTldIE1lcmdlIGJyYW5jaCAnZm9yLTMuOC9k
cml2ZXJzJyBvZiBnaXQ6Ly9naXQua2VybmVsLmRrL2xpbnV4LWJsb2NrCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDAzMTYyMTo5MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5OmJp
c2VjdC1saW51eDkKCjIwMTQtMDMtMTctMDg6Mzk6MDEgOTIyOGZmOTAzODdlMjc2YWQ2N2Ix
MGMwZWI1MjVjOWQ2YTU3ZDVlOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC05
MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85MjI4ZmY5MDM4
N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC05MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgtOTIyOGZmOTAzODdlMjc2YWQ2N2IxMGMwZWI1MjVjOWQ2
YTU3ZDVlOQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
OTIyOGZmOTAzODdlMjc2YWQ2N2IxMGMwZWI1MjVjOWQ2YTU3ZDVlOS92bWxpbnV6LTMuNy4w
LTEwMDQ1LWc5MjI4ZmY5CgoyMDE0LTAzLTE3LTA4OjUzOjAxIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uLgk4IFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBtYXBwZWQgSU9B
UElDIHRvIGZmZmZmZmZmZmY1ZjkwMDAgKGZlYzAwMDAwKQpbICAgIDAuMDAwMDAwXSBucl9p
cnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IGF0IGFyY2gveDg2L2tlcm5lbC9w
dmNsb2NrLmM6MTgyIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkoKQpbICAgIDAu
MDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocwpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxp
bmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuNy4wLTEwMDQ1LWc5MjI4ZmY5ICMxClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNDA2OTE+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDgxLzB4OTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA0MDc1Nz5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNkNTE2Mj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MWNkNTBjOT5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysw
eDVjLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkNGU2Zj5dIGt2bV9ndWVz
dF9pbml0KzB4ZTQvMHhlYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2NiOTY3Pl0g
c2V0dXBfYXJjaCsweDllZS8weGEzOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4
N2M1Pl0gc3RhcnRfa2VybmVsKzB4OWMvMHgzY2UKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNjODEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFjYzgyMjg+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2M4MzJiPl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEwZApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSAzOWUwMTczNzYxNzNiMDA5IF0tLS0KWyAgICAwLjAwMDAwMF0gS1ZNIHNldHVwIGFzeW5j
IFBGIGZvciBjcHUgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4Lzky
MjhmZjkwMzg3ZTI3NmFkNjdiMTBjMGViNTI1YzlkNmE1N2Q1ZTkvZG1lc2ctcXVhbnRhbC1h
dGhlbnMtNDE6MjAxNDAzMTcwODUzMjM6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6
My43LjAtMTAwNDUtZzkyMjhmZjk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4LzkyMjhmZjkwMzg3ZTI3NmFkNjdiMTBjMGViNTI1YzlkNmE1N2Q1ZTkvZG1lc2ct
cXVhbnRhbC1jYWlyby0xODoyMDE0MDMxNzA4NTQyMjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzODozLjcuMC0xMDA0NS1nOTIyOGZmOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvOTIyOGZmOTAzODdlMjc2YWQ2N2IxMGMwZWI1MjVjOWQ2YTU3ZDVl
OS9kbWVzZy1xdWFudGFsLWNhaXJvLTM4OjIwMTQwMzE3MDg1NDQxOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuNy4wLTEwMDQ1LWc5MjI4ZmY5OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5
ZDZhNTdkNWU5L2RtZXNnLXF1YW50YWwtaW5uLTMyOjIwMTQwMzE3MDg1MzMxOng4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC85MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5L2RtZXNn
LXF1YW50YWwtamFrZXRvd24tMTg6MjAxNDAzMTcwODU0NTk6eDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4Lzky
MjhmZjkwMzg3ZTI3NmFkNjdiMTBjMGViNTI1YzlkNmE1N2Q1ZTkvZG1lc2ctcXVhbnRhbC1q
YWtldG93bi0yMToyMDE0MDMxNzA4NTQ0MDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvOTIyOGZmOTAzODdl
Mjc2YWQ2N2IxMGMwZWI1MjVjOWQ2YTU3ZDVlOS9kbWVzZy1xdWFudGFsLWpha2V0b3duLTI1
OjIwMTQwMzE3MDg1NDM4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC85MjI4ZmY5MDM4N2UyNzZhZDY3YjEw
YzBlYjUyNWM5ZDZhNTdkNWU5L2RtZXNnLXF1YW50YWwtamFrZXRvd24tMjg6MjAxNDAzMTcw
ODU0Mjk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LzkyMjhmZjkwMzg3ZTI3NmFkNjdiMTBjMGViNTI1Yzlk
NmE1N2Q1ZTkvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zMToyMDE0MDMxNzA4NTQzMjp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgvOTIyOGZmOTAzODdlMjc2YWQ2N2IxMGMwZWI1MjVjOWQ2YTU3ZDVlOS9k
bWVzZy1xdWFudGFsLWpha2V0b3duLTM0OjIwMTQwMzE3MDg1NTMyOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC85MjI4ZmY5MDM4N2UyNzZhZDY3YjEwYzBlYjUyNWM5ZDZhNTdkNWU5L2RtZXNnLXF1YW50
YWwtamFrZXRvd24tOToyMDE0MDMxNzA4NTQ0NDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzODo6CjE6MTE6MTcgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDMtMTcgMDg6NTg6MDMgUkVQRUFUIENPVU5UOiAyNiAgIyAva2VybmVsLXRlc3RzL2xpbnV4
OS9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1h
eSBiZSBicmFuY2ggJ2Zvci0zLjgvZHJpdmVycycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5kay9s
aW51eC1ibG9jawpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0Cmxp
bmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgOTIyOGZmOTAzODdlMjc2YWQ2N2IxMGMw
ZWI1MjVjOWQ2YTU3ZDVlOSA5MzYwYjUzNjYxYTJjNzc1NDUxN2IyOTI1NTgwMDU1YmFjYzhl
YzM4IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDkyMjhmZjkuLi4gTWVyZ2UgYnJh
bmNoICdmb3ItMy44L2RyaXZlcnMnIG9mIGdpdDovL2dpdC5rZXJuZWwuZGsvbGludXgtYmxv
Y2sKSEVBRCBpcyBub3cgYXQgMTliMzQ0ZS4uLiBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2ppa29z
L2hpZApCaXNlY3Rpbmc6IDMwNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOCBzdGVwcykKW2NkMWQ5OTUwZjY5YjQ2ZDg4MDAyYjM5NjUyZWQwY2YzNjA4
ZDAwOGJdIGRyYmQ6IElubGluZWQgZHJiZF9mcmVlX21kZXYoKTsgaXQgZ290IGNhbGxlZCBv
bmx5IGZyb20gb25lIHBsYWNlCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDkvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6Y2QxZDk5NTBmNjliNDZk
ODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4YjpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTA5
OjAwOjIyIGNkMWQ5OTUwZjY5YjQ2ZDg4MDAyYjM5NjUyZWQwY2YzNjA4ZDAwOGIgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJl
ZDBjZjM2MDhkMDA4YgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhk
MDA4Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtY2QxZDk5NTBmNjliNDZkODgwMDJi
Mzk2NTJlZDBjZjM2MDhkMDA4Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWNkMWQ5
OTUwZjY5YjQ2ZDg4MDAyYjM5NjUyZWQwY2YzNjA4ZDAwOGIKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2NkMWQ5OTUwZjY5YjQ2ZDg4MDAyYjM5NjUy
ZWQwY2YzNjA4ZDAwOGIvdm1saW51ei0zLjEuMC1yYzEtMDAzMTgtZ2NkMWQ5OTUKCjIwMTQt
MDMtMTctMDk6MTU6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTYgVEVTVCBGQUlMVVJF
ClsgICAgMS45MDE1ODddIGJyZDogbW9kdWxlIGxvYWRlZApbICAgIDEuOTA3MTU1XSBsb29w
OiBtb2R1bGUgbG9hZGVkClsgICAgMS45MDgzNzddIGV2ZW50czogbWNnIGRyYmQ6IDcKWyAg
ICAyLjA1MDQwNF0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAw
ZDIsIG9yZGVyPTAsIG9vbV9hZGo9MCwgb29tX3Njb3JlX2Fkaj0wClsgICAgMi4wNTE5Njld
IFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEuMC1yYzEtMDAzMTgtZ2Nk
MWQ5OTUgIzEKWyAgICAyLjA1MzI0MV0gQ2FsbCBUcmFjZToKWyAgICAyLjA1MzcyNV0gIFs8
ZmZmZmZmZmY4MTRhMmVmYz5dID8gX3Jhd19zcGluX3VubG9jaysweDRmLzB4NTMKWyAgICAy
LjA1NDgzNV0gIFs8ZmZmZmZmZmY4MTBhMzA1NT5dIGR1bXBfaGVhZGVyLmlzcmEuOSsweDcw
LzB4MWRjClsgICAgMi4wNTU5MzJdICBbPGZmZmZmZmZmODEwYTM0Y2I+XSA/IG91dF9vZl9t
ZW1vcnkrMHhlMS8weDMxMwpbICAgIDIuMDU2OTkwXSAgWzxmZmZmZmZmZjgxMGEzNjQ1Pl0g
b3V0X29mX21lbW9yeSsweDI1Yi8weDMxMwpbICAgIDIuMDU4MDQzXSAgWzxmZmZmZmZmZjgx
MGE2Y2MwPl0gX19hbGxvY19wYWdlc19ub2RlbWFzaysweDYxYS8weDc2MQpbICAgIDIuMDU5
MjU0XSAgWzxmZmZmZmZmZjgxY2MwMGYxPl0gZHJiZF9pbml0KzB4Mjg1LzB4Mzk3ClsgICAg
Mi4wNjAyMzRdICBbPGZmZmZmZmZmODFjYmZlNmM+XSA/IHBrdF9pbml0KzB4MTkyLzB4MTky
ClsgICAgMi4wNjEyMzVdICBbPGZmZmZmZmZmODEwMDAyMjc+XSBkb19vbmVfaW5pdGNhbGwr
MHg3ZC8weDEzNwpbICAgIDIuMDYyMjk0XSAgWzxmZmZmZmZmZjgxYzllYTQ4Pl0ga2VybmVs
X2luaXQrMHhhMi8weDExNQpbICAgIDIuMDYzMjg4XSAgWzxmZmZmZmZmZjgxNGE0YTY0Pl0g
a2VybmVsX3RocmVhZF9oZWxwZXIrMHg0LzB4MTAKWyAgICAyLjA2NDM5N10gIFs8ZmZmZmZm
ZmY4MTAwMTY2Zj5dID8gX19zd2l0Y2hfdG8rMHhiNy8weDIwYgpbICAgIDIuMDY1NDI4XSAg
WzxmZmZmZmZmZjgxNGEzMWY0Pl0gPyByZXRpbnRfcmVzdG9yZV9hcmdzKzB4MTMvMHgxMwpb
ICAgIDIuMDY2NTUwXSAgWzxmZmZmZmZmZjgxYzllOWE2Pl0gPyBzdGFydF9rZXJuZWwrMHgz
ZjAvMHgzZjAKWyAgICAyLjA2NzU5Ml0gIFs8ZmZmZmZmZmY4MTRhNGE2MD5dID8gZ3NfY2hh
bmdlKzB4MTMvMHgxMwpbICAgIDIuMDY4NTY0XSBNZW0tSW5mbzoKWyAgICAyLjA2ODk2N10g
RE1BIHBlci1jcHU6ClsgICAgMi4wNjk0ODRdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDog
ICAxIHVzZDogICAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2Qx
ZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNh
aXJvLTEzOjIwMTQwMzE3MDkxNTI4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMu
MS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVz
Zy1xdWFudGFsLWNhaXJvLTEzOjIwMTQwMzE3MDkxNTM5Ong4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2
MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTE0OjIwMTQwMzE3MDkxNTMyOng4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJi
Mzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTE4OjIwMTQwMzE3MDkx
NTI5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2Qx
ZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBm
NjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTE4
OjIwMTQwMzE3MDkxNTQwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJj
MS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFu
dGFsLWNhaXJvLTIwOjIwMTQwMzE3MDkxNTI5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4
Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTIwOjIwMTQwMzE3MDkxNTQwOng4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJl
ZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTI4OjIwMTQwMzE3MDkxNTM0Ong4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZk
ODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTM1OjIwMTQw
MzE3MDkxNTI4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMx
OC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2Qx
ZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNh
aXJvLTM1OjIwMTQwMzE3MDkxNTM5Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMu
MS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVz
Zy1xdWFudGFsLWNhaXJvLTQzOjIwMTQwMzE3MDkxNTQxOng4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2
MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTQ2OjIwMTQwMzE3MDkxNTM2Ong4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2QxZDk5NToxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJi
Mzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTQ4OjIwMTQwMzE3MDkx
NTMyOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDMxOC1nY2Qx
ZDk5NToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBm
NjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWNhaXJvLTc6
MjAxNDAzMTcwOTE1Mjc6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xLjAtcmMx
LTAwMzE4LWdjZDFkOTk1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC9jZDFkOTk1MGY2OWI0NmQ4ODAwMmIzOTY1MmVkMGNmMzYwOGQwMDhiL2RtZXNnLXF1YW50
YWwtY2Fpcm8tNzoyMDE0MDMxNzA5MTUzNzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
ODozLjEuMC1yYzEtMDAzMTgtZ2NkMWQ5OTU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMTcwMDM4L2NkMWQ5OTUwZjY5YjQ2ZDg4MDAyYjM5NjUyZWQwY2YzNjA4ZDAwOGIv
ZG1lc2ctcXVhbnRhbC1qYWtldG93bi0xMToyMDE0MDMxNzA5MTU0OTp4ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJlZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFu
dGFsLWpha2V0b3duLTE0OjIwMTQwMzE3MDkxNTQ0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9jZDFkOTk1
MGY2OWI0NmQ4ODAwMmIzOTY1MmVkMGNmMzYwOGQwMDhiL2RtZXNnLXF1YW50YWwtamFrZXRv
d24tMzQ6MjAxNDAzMTcwOTE1NTI6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2NkMWQ5OTUwZjY5YjQ2ZDg4
MDAyYjM5NjUyZWQwY2YzNjA4ZDAwOGIvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zNToyMDE0
MDMxNzA5MTU0OTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvY2QxZDk5NTBmNjliNDZkODgwMDJiMzk2NTJl
ZDBjZjM2MDhkMDA4Yi9kbWVzZy1xdWFudGFsLWpha2V0b3duLTQ2OjIwMTQwMzE3MDkxNTUy
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjoKNjoyMDoyMCBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAxNTIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClszYzEzYjY4MGNlMjEwMzEzYzZmN2FkMTYz
NDM1YjYyOTc5OTU4YzA5XSBkcmJkOiBvbmx5IHdha2V1cCBpZiBzb21ldGhpbmcgY2hhbmdl
ZCBpbiB1cGRhdGVfcGVlcl9zZXEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAz
MTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOjNjMTNiNjgwY2Uy
MTAzMTNjNmY3YWQxNjM0MzViNjI5Nzk5NThjMDk6YmlzZWN0LWxpbnV4OQoKMjAxNC0wMy0x
Ny0wOToxNzoyNyAzYzEzYjY4MGNlMjEwMzEzYzZmN2FkMTYzNDM1YjYyOTc5OTU4YzA5IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTNjMTNiNjgwY2UyMTAzMTNjNmY3YWQx
NjM0MzViNjI5Nzk5NThjMDkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LzNjMTNiNjgwY2UyMTAzMTNjNmY3YWQxNjM0MzViNjI5
Nzk5NThjMDkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTNjMTNiNjgwY2UyMTAzMTNj
NmY3YWQxNjM0MzViNjI5Nzk5NThjMDkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC0z
YzEzYjY4MGNlMjEwMzEzYzZmN2FkMTYzNDM1YjYyOTc5OTU4YzA5Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8zYzEzYjY4MGNlMjEwMzEzYzZmN2Fk
MTYzNDM1YjYyOTc5OTU4YzA5L3ZtbGludXotMy4xLjAtcmMxLTAwMTY1LWczYzEzYjY4Cgoy
MDE0LTAzLTE3LTA5OjM0OjI3IGRldGVjdGluZyBib290IHN0YXRlIC4JNwkyMS4uLgkyNiBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDc2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA2IHN0ZXBzKQpbMjgyODRjZWZmMDQzYjE0ZGVmY2Y4MTIyYjc2NWZlMGIy
MWJkOTM0NF0gZHJiZDogcmVjdl9kbGVzc19yZWFkKCk6IFJldHVybiAwIHVwb24gc3VjY2Vz
cyBhbmQgYW4gZXJyb3IgY29kZSBvdGhlcndpc2UKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIxOjI4
Mjg0Y2VmZjA0M2IxNGRlZmNmODEyMmI3NjVmZTBiMjFiZDkzNDQ6YmlzZWN0LWxpbnV4OQoK
MjAxNC0wMy0xNy0wOTozNzo1OSAyODI4NGNlZmYwNDNiMTRkZWZjZjgxMjJiNzY1ZmUwYjIx
YmQ5MzQ0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTI4Mjg0Y2VmZjA0M2Ix
NGRlZmNmODEyMmI3NjVmZTBiMjFiZDkzNDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzI4Mjg0Y2VmZjA0M2IxNGRlZmNmODEy
MmI3NjVmZTBiMjFiZDkzNDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTI4Mjg0Y2Vm
ZjA0M2IxNGRlZmNmODEyMmI3NjVmZTBiMjFiZDkzNDQKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC0yODI4NGNlZmYwNDNiMTRkZWZjZjgxMjJiNzY1ZmUwYjIxYmQ5MzQ0Cmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8yODI4NGNlZmYwNDNi
MTRkZWZjZjgxMjJiNzY1ZmUwYjIxYmQ5MzQ0L3ZtbGludXotMy4xLjAtcmMxLTAwMjQxLWcy
ODI4NGNlCgoyMDE0LTAzLTE3LTA5OjQ4OjAwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
CTMJOAkxMQkxNwkyNiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM4IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbNjAzODE3OGViZTI5ZTZiNWU0
ZDUxOWE1YWM1NjY1M2QxNTZjOTBmOV0gZHJiZDogQ2hhbmdlIGhvdyB0aGUgImhhbmRzaGFr
ZSIgcGFja2V0cyBhcmUgY2FsbGVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4OS9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMTYyMTo2MDM4MTc4ZWJl
MjllNmI1ZTRkNTE5YTVhYzU2NjUzZDE1NmM5MGY5OmJpc2VjdC1saW51eDkKCjIwMTQtMDMt
MTctMDk6NTM6MDEgNjAzODE3OGViZTI5ZTZiNWU0ZDUxOWE1YWM1NjY1M2QxNTZjOTBmOSBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC02MDM4MTc4ZWJlMjllNmI1ZTRkNTE5
YTVhYzU2NjUzZDE1NmM5MGY5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC82MDM4MTc4ZWJlMjllNmI1ZTRkNTE5YTVhYzU2NjUz
ZDE1NmM5MGY5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC02MDM4MTc4ZWJlMjllNmI1
ZTRkNTE5YTVhYzU2NjUzZDE1NmM5MGY5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgt
NjAzODE3OGViZTI5ZTZiNWU0ZDUxOWE1YWM1NjY1M2QxNTZjOTBmOQprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNjAzODE3OGViZTI5ZTZiNWU0ZDUx
OWE1YWM1NjY1M2QxNTZjOTBmOS92bWxpbnV6LTMuMS4wLXJjMS0wMDI3OS1nNjAzODE3OAoK
MjAxNC0wMy0xNy0xMDo0MjowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTYJMTYJMjIuLgky
NS4uLgkyNiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4
MDQwZTkxMzQxZmY4MDY2ZF0gZHJiZDogSW50cm9kdWNlIGRyYmRfaGVhZGVyX3NpemUoKQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tl
cm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzE2MjE6NTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQx
ZmY4MDY2ZDpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTEwOjQ3OjMyIDUyYjA2MWE0NDAy
MWNhMTFlZTJmZDIzODA0MGU5MTM0MWZmODA2NmQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgtNTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2ZApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
NTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2ZAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgtNTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2
ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTUyYjA2MWE0NDAyMWNhMTFlZTJmZDIz
ODA0MGU5MTM0MWZmODA2NmQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LzUyYjA2MWE0NDAyMWNhMTFlZTJmZDIzODA0MGU5MTM0MWZmODA2NmQvdm1s
aW51ei0zLjEuMC1yYzEtMDAyOTgtZzUyYjA2MWEKCjIwMTQtMDMtMTctMTE6Mjc6MzMgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JOS4JMTEuLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsg
ICAgMS41ODkxMTFdIGJyZDogbW9kdWxlIGxvYWRlZApbICAgIDEuNTkyNDIwXSBsb29wOiBt
b2R1bGUgbG9hZGVkClsgICAgMS41OTMyNDJdIGV2ZW50czogbWNnIGRyYmQ6IDcKWyAgICAx
LjcxODE3NF0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAwZDIs
IG9yZGVyPTAsIG9vbV9hZGo9MCwgb29tX3Njb3JlX2Fkaj0wClsgICAgMS43MTkyNjhdIFBp
ZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEuMC1yYzEtMDAyOTgtZzUyYjA2
MWEgIzEKWyAgICAxLjcyMDE0Nl0gQ2FsbCBUcmFjZToKWyAgICAxLjcyMDQ5M10gIFs8ZmZm
ZmZmZmY4MTRhMzAzYz5dID8gX3Jhd19zcGluX3VubG9jaysweDRmLzB4NTMKWyAgICAxLjcy
MTI1M10gIFs8ZmZmZmZmZmY4MTBhMzA1NT5dIGR1bXBfaGVhZGVyLmlzcmEuOSsweDcwLzB4
MWRjClsgICAgMS43MjE5OTZdICBbPGZmZmZmZmZmODEwYTM0Y2I+XSA/IG91dF9vZl9tZW1v
cnkrMHhlMS8weDMxMwpbICAgIDEuNzIyNzE5XSAgWzxmZmZmZmZmZjgxMGEzNjQ1Pl0gb3V0
X29mX21lbW9yeSsweDI1Yi8weDMxMwpbICAgIDEuNzIzNDUzXSAgWzxmZmZmZmZmZjgxMGE2
Y2MwPl0gX19hbGxvY19wYWdlc19ub2RlbWFzaysweDYxYS8weDc2MQpbICAgIDEuNzI0Mjcw
XSAgWzxmZmZmZmZmZjgxY2MwMGYxPl0gZHJiZF9pbml0KzB4Mjg1LzB4Mzk3ClsgICAgMS43
MjQ5MjVdICBbPGZmZmZmZmZmODFjYmZlNmM+XSA/IHBrdF9pbml0KzB4MTkyLzB4MTkyClsg
ICAgMS43MjU2MzJdICBbPGZmZmZmZmZmODEwMDAyMjc+XSBkb19vbmVfaW5pdGNhbGwrMHg3
ZC8weDEzNwpbICAgIDEuNzI2MzQ4XSAgWzxmZmZmZmZmZjgxYzllYTQ4Pl0ga2VybmVsX2lu
aXQrMHhhMi8weDExNQpbICAgIDEuNzI3MDQxXSAgWzxmZmZmZmZmZjgxNGE0YmE0Pl0ga2Vy
bmVsX3RocmVhZF9oZWxwZXIrMHg0LzB4MTAKWyAgICAxLjcyNzc2OF0gIFs8ZmZmZmZmZmY4
MTAwMTY2Zj5dID8gX19zd2l0Y2hfdG8rMHhiNy8weDIwYgpbICAgIDEuNzI4NDUzXSAgWzxm
ZmZmZmZmZjgxNGEzMzM0Pl0gPyByZXRpbnRfcmVzdG9yZV9hcmdzKzB4MTMvMHgxMwpbICAg
IDEuNzI5MjQ0XSAgWzxmZmZmZmZmZjgxYzllOWE2Pl0gPyBzdGFydF9rZXJuZWwrMHgzZjAv
MHgzZjAKWyAgICAxLjcyOTk2MV0gIFs8ZmZmZmZmZmY4MTRhNGJhMD5dID8gZ3NfY2hhbmdl
KzB4MTMvMHgxMwpbICAgIDEuNzMwNjY0XSBNZW0tSW5mbzoKWyAgICAxLjczMDk2MF0gRE1B
IHBlci1jcHU6ClsgICAgMS43MzEyOTNdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDogICAx
IHVzZDogICAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNTJiMDYx
YTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2ZC9kbWVzZy1xdWFudGFsLXJvYW0t
MToyMDE0MDMxNzExMzQwMTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjEuMC1y
YzEtMDAyOTgtZzUyYjA2MWE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LzUyYjA2MWE0NDAyMWNhMTFlZTJmZDIzODA0MGU5MTM0MWZmODA2NmQvZG1lc2ctcXVh
bnRhbC1yb2FtLTI0OjIwMTQwMzE3MTEzNDAxOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuMS4wLXJjMS0wMDI5OC1nNTJiMDYxYToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvNTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2
ZC9kbWVzZy1xdWFudGFsLXJvYW0tMjc6MjAxNDAzMTcxMTM0MDE6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzg6My4xLjAtcmMxLTAwMjk4LWc1MmIwNjFhOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC81MmIwNjFhNDQwMjFjYTExZWUyZmQyMzgwNDBl
OTEzNDFmZjgwNjZkL2RtZXNnLXF1YW50YWwtcm9hbS0zNToyMDE0MDMxNzExMzQwMTp4ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjEuMC1yYzEtMDAyOTgtZzUyYjA2MWE6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzUyYjA2MWE0NDAyMWNhMTFl
ZTJmZDIzODA0MGU5MTM0MWZmODA2NmQvZG1lc2ctcXVhbnRhbC1yb2FtLTQwOjIwMTQwMzE3
MTEzNDAxOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI5OC1n
NTJiMDYxYToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNTJiMDYx
YTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2ZC9kbWVzZy1xdWFudGFsLXJvYW0t
NDE6MjAxNDAzMTcxMTM0MDE6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xLjAt
cmMxLTAwMjk4LWc1MmIwNjFhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzOC81MmIwNjFhNDQwMjFjYTExZWUyZmQyMzgwNDBlOTEzNDFmZjgwNjZkL2RtZXNnLXF1
YW50YWwteGlhbi0xNjoyMDE0MDMxNzExMzM0Mzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzODozLjEuMC1yYzEtMDAyOTgtZzUyYjA2MWE6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4LzUyYjA2MWE0NDAyMWNhMTFlZTJmZDIzODA0MGU5MTM0MWZmODA2
NmQvZG1lc2ctcXVhbnRhbC1pbm4tMToyMDE0MDMxNzExMzQwNTp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
NTJiMDYxYTQ0MDIxY2ExMWVlMmZkMjM4MDQwZTkxMzQxZmY4MDY2ZC9kbWVzZy1xdWFudGFs
LWlubi0zMzoyMDE0MDMxNzExMzQwNTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6
CjExOjk6OSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0xNyAx
MTozNjowNCBSRVBFQVQgQ09VTlQ6IDMyICAjIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1i
aXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKW2RhOWZiYzI3NmU5ZDQyNjM4ZGY2OGU4
NTE1ZDA2NzUwNjk1NjEyY2FdIGRyYmQ6IEludHJvZHVjZWQgYSBuZXcgdHlwZSB1bmlvbiBk
cmJkX2Rldl9zdGF0ZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6ZGE5ZmJjMjc2ZTlkNDI2Mzhk
ZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYTpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTExOjM2
OjA1IGRhOWZiYzI3NmU5ZDQyNjM4ZGY2OGU4NTE1ZDA2NzUwNjk1NjEyY2EgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzgtZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3
NTA2OTU2MTJjYQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJj
YQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1
MTVkMDY3NTA2OTU2MTJjYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWRhOWZiYzI3
NmU5ZDQyNjM4ZGY2OGU4NTE1ZDA2NzUwNjk1NjEyY2EKa2VybmVsOiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2RhOWZiYzI3NmU5ZDQyNjM4ZGY2OGU4NTE1ZDA2
NzUwNjk1NjEyY2Evdm1saW51ei0zLjEuMC1yYzEtMDAyODgtZ2RhOWZiYzIKCjIwMTQtMDMt
MTctMTE6NTE6MDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4gVEVTVCBGQUlMVVJF
ClsgICAgMi4xMzU5OThdIGJyZDogbW9kdWxlIGxvYWRlZApbICAgIDIuMTM5NzYxXSBsb29w
OiBtb2R1bGUgbG9hZGVkClsgICAgMi4xNDA2NjhdIGV2ZW50czogbWNnIGRyYmQ6IDcKWyAg
ICAyLjI3MjE2Nl0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAw
ZDIsIG9yZGVyPTAsIG9vbV9hZGo9MCwgb29tX3Njb3JlX2Fkaj0wClsgICAgMi4yNzMyNTRd
IFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEuMC1yYzEtMDAyODgtZ2Rh
OWZiYzIgIzEKWyAgICAyLjI3NDA5N10gQ2FsbCBUcmFjZToKWyAgICAyLjI3NDQ0NF0gIFs8
ZmZmZmZmZmY4MTRhMmMyYz5dID8gX3Jhd19zcGluX3VubG9jaysweDRmLzB4NTMKWyAgICAy
LjI3NTE5Nl0gIFs8ZmZmZmZmZmY4MTBhMzA1NT5dIGR1bXBfaGVhZGVyLmlzcmEuOSsweDcw
LzB4MWRjClsgICAgMi4yNzU5MjRdICBbPGZmZmZmZmZmODEwYTM0Y2I+XSA/IG91dF9vZl9t
ZW1vcnkrMHhlMS8weDMxMwpbICAgIDIuMjc2NjQ1XSAgWzxmZmZmZmZmZjgxMGEzNjQ1Pl0g
b3V0X29mX21lbW9yeSsweDI1Yi8weDMxMwpbICAgIDIuMjc3MzQ2XSAgWzxmZmZmZmZmZjgx
MGE2Y2MwPl0gX19hbGxvY19wYWdlc19ub2RlbWFzaysweDYxYS8weDc2MQpbICAgIDIuMjc4
MTU3XSAgWzxmZmZmZmZmZjgxY2MwMGYxPl0gZHJiZF9pbml0KzB4Mjg1LzB4Mzk3ClsgICAg
Mi4yNzg4MDVdICBbPGZmZmZmZmZmODFjYmZlNmM+XSA/IHBrdF9pbml0KzB4MTkyLzB4MTky
ClsgICAgMi4yNzk0ODJdICBbPGZmZmZmZmZmODEwMDAyMjc+XSBkb19vbmVfaW5pdGNhbGwr
MHg3ZC8weDEzNwpbICAgIDIuMjgwMjA0XSAgWzxmZmZmZmZmZjgxYzllYTQ4Pl0ga2VybmVs
X2luaXQrMHhhMi8weDExNQpbICAgIDIuMjgwODY0XSAgWzxmZmZmZmZmZjgxNGE0NzY0Pl0g
a2VybmVsX3RocmVhZF9oZWxwZXIrMHg0LzB4MTAKWyAgICAyLjI4MTYwNF0gIFs8ZmZmZmZm
ZmY4MTAwMTY2Zj5dID8gX19zd2l0Y2hfdG8rMHhiNy8weDIwYgpbICAgIDIuMjgyMjk1XSAg
WzxmZmZmZmZmZjgxNGEyZWY0Pl0gPyByZXRpbnRfcmVzdG9yZV9hcmdzKzB4MTMvMHgxMwpb
ICAgIDIuMjgzMDY0XSAgWzxmZmZmZmZmZjgxYzllOWE2Pl0gPyBzdGFydF9rZXJuZWwrMHgz
ZjAvMHgzZjAKWyAgICAyLjI4Mzc2NF0gIFs8ZmZmZmZmZmY4MTRhNDc2MD5dID8gZ3NfY2hh
bmdlKzB4MTMvMHgxMwpbICAgIDIuMjg0NDIxXSBNZW0tSW5mbzoKWyAgICAyLjI4NDcyMV0g
RE1BIHBlci1jcHU6ClsgICAgMi4yODUwNThdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDog
ICAxIHVzZDogICAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5
ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNh
aXJvLTE1OjIwMTQwMzE3MTE1MjE4Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMu
MS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVz
Zy1xdWFudGFsLWNhaXJvLTIxOjIwMTQwMzE3MTE1MTMyOng4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2
OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNhaXJvLTIxOjIwMTQwMzE3MTE1MTU2Ong4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4
ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNhaXJvLTI1OjIwMTQwMzE3MTE1
MTEwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5
ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2
ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNhaXJvLTI1
OjIwMTQwMzE3MTE1MTIxOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJj
MS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFu
dGFsLWNhaXJvLTI1OjIwMTQwMzE3MTE1MTM1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJj
YS9kbWVzZy1xdWFudGFsLWNhaXJvLTI1OjIwMTQwMzE3MTE1MTU2Ong4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVk
MDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNhaXJvLTI2OjIwMTQwMzE3MTE1MTIwOng4
Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4OC1nZGE5ZmJjMjox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5ZmJjMjc2ZTlkNDI2
MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNhaXJvLTI2OjIwMTQw
MzE3MTE1MTM1Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMS4wLXJjMS0wMDI4
OC1nZGE5ZmJjMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGE5
ZmJjMjc2ZTlkNDI2MzhkZjY4ZTg1MTVkMDY3NTA2OTU2MTJjYS9kbWVzZy1xdWFudGFsLWNh
aXJvLTI6MjAxNDAzMTcxMTUzMDI6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4x
LjAtcmMxLTAwMjg4LWdkYTlmYmMyOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC9kYTlmYmMyNzZlOWQ0MjYzOGRmNjhlODUxNWQwNjc1MDY5NTYxMmNhL2RtZXNn
LXF1YW50YWwtY2Fpcm8tMzE6MjAxNDAzMTcxMTUxMjA6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzg6My4xLjAtcmMxLTAwMjg4LWdkYTlmYmMyOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzOC9kYTlmYmMyNzZlOWQ0MjYzOGRmNjhlODUxNWQwNjc1MDY5
NTYxMmNhL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzE6MjAxNDAzMTcxMTUxMzU6eDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzg6My4xLjAtcmMxLTAwMjg4LWdkYTlmYmMyOjEKMDoxMjox
MCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMjMzNjFjZjMyYjU4
ZWZkZjA5OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1N10gZHJiZDogZ2V0IHJpZCBvZiBiaW9fc3Bs
aXQsIGFsbG93IGJpb3Mgb2YgImFyYml0cmFyeSIgc2l6ZQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDkv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2
MjE6MjMzNjFjZjMyYjU4ZWZkZjA5OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1NzpiaXNlY3QtbGlu
dXg5CgoyMDE0LTAzLTE3LTExOjU1OjA4IDIzMzYxY2YzMmI1OGVmZGYwOTk0NWE2NGUxZDhk
NDFmYTYxMTcxNTcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtMjMzNjFjZjMy
YjU4ZWZkZjA5OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1NwpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvMjMzNjFjZjMyYjU4ZWZkZjA5
OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1Nwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtMjMz
NjFjZjMyYjU4ZWZkZjA5OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1Nwp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmln
LXIyLTAzMTcwMDM4LTIzMzYxY2YzMmI1OGVmZGYwOTk0NWE2NGUxZDhkNDFmYTYxMTcxNTcK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzIzMzYxY2Yz
MmI1OGVmZGYwOTk0NWE2NGUxZDhkNDFmYTYxMTcxNTcvdm1saW51ei0zLjEuMC1yYzEtMDAy
ODMtZzIzMzYxY2YKCjIwMTQtMDMtMTctMTI6MTg6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLiBURVNUIEZBSUxVUkUKWyAgICA0LjgxMTE0Ml0gYnJkOiBtb2R1bGUgbG9hZGVkClsg
ICAgNC44MjM3NzZdIGxvb3A6IG1vZHVsZSBsb2FkZWQKWyAgICA0LjgyNTIzNl0gZXZlbnRz
OiBtY2cgZHJiZDogNwpbICAgIDUuMDEyNDA4XSBzd2FwcGVyIGludm9rZWQgb29tLWtpbGxl
cjogZ2ZwX21hc2s9MHgyMDBkMiwgb3JkZXI9MCwgb29tX2Fkaj0wLCBvb21fc2NvcmVfYWRq
PTAKWyAgICA1LjAxOTI4NV0gUGlkOiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MS4wLXJjMS0wMDI4My1nMjMzNjFjZiAjMQpbICAgIDUuMDIwODUxXSBDYWxsIFRyYWNlOgpb
ICAgIDUuMDIxNDk4XSAgWzxmZmZmZmZmZjgxNGEyYWZjPl0gPyBfcmF3X3NwaW5fdW5sb2Nr
KzB4NGYvMHg1MwpbICAgIDUuMDIyODgyXSAgWzxmZmZmZmZmZjgxMGEzMDU1Pl0gZHVtcF9o
ZWFkZXIuaXNyYS45KzB4NzAvMHgxZGMKWyAgICA1LjAyODQ5Nl0gIFs8ZmZmZmZmZmY4MTBh
MzRjYj5dID8gb3V0X29mX21lbW9yeSsweGUxLzB4MzEzClsgICAgNS4wMjk4NzldICBbPGZm
ZmZmZmZmODEwYTM2NDU+XSBvdXRfb2ZfbWVtb3J5KzB4MjViLzB4MzEzClsgICAgNS4wMzEy
NTNdICBbPGZmZmZmZmZmODEwYTZjYzA+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4NjFh
LzB4NzYxClsgICAgNS4wMzI3ODVdICBbPGZmZmZmZmZmODFjYzAwZjE+XSBkcmJkX2luaXQr
MHgyODUvMHgzOTcKWyAgICA1LjAzODk3NF0gIFs8ZmZmZmZmZmY4MWNiZmU2Yz5dID8gcGt0
X2luaXQrMHgxOTIvMHgxOTIKWyAgICA1LjA0MDIzNl0gIFs8ZmZmZmZmZmY4MTAwMDIyNz5d
IGRvX29uZV9pbml0Y2FsbCsweDdkLzB4MTM3ClsgICAgNS4wNDE1NjddICBbPGZmZmZmZmZm
ODFjOWVhNDg+XSBrZXJuZWxfaW5pdCsweGEyLzB4MTE1ClsgICAgNS4wNDI4MTddICBbPGZm
ZmZmZmZmODE0YTQ2NjQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBlcisweDQvMHgxMApbICAgIDUu
MDQ4MjY4XSAgWzxmZmZmZmZmZjgxMDAxNjZmPl0gPyBfX3N3aXRjaF90bysweGI3LzB4MjBi
ClsgICAgNS4wNDk1ODNdICBbPGZmZmZmZmZmODE0YTJkZjQ+XSA/IHJldGludF9yZXN0b3Jl
X2FyZ3MrMHgxMy8weDEzClsgICAgNS4wNTk1NzBdICBbPGZmZmZmZmZmODFjOWU5YTY+XSA/
IHN0YXJ0X2tlcm5lbCsweDNmMC8weDNmMApbICAgIDUuMDYwODkzXSAgWzxmZmZmZmZmZjgx
NGE0NjYwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzClsgICAgNS4wNjg3NTldIE1lbS1JbmZv
OgpbICAgIDUuMDY5MzQ2XSBETUEgcGVyLWNwdToKWyAgICA1LjA2OTk1Ml0gQ1BVICAgIDA6
IGhpOiAgICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzOC8yMzM2MWNmMzJiNThlZmRmMDk5NDVhNjRlMWQ4ZDQxZmE2MTE3MTU3
L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjk6MjAxNDAzMTcxMjE4MTM6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzg6My4xLjAtcmMxLTAwMjgzLWcyMzM2MWNmOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8yMzM2MWNmMzJiNThlZmRmMDk5NDVhNjRlMWQ4
ZDQxZmE2MTE3MTU3L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjk6MjAxNDAzMTcxMjE5MzU6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xLjAtcmMxLTAwMjgzLWcyMzM2MWNmOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8yMzM2MWNmMzJiNThlZmRm
MDk5NDVhNjRlMWQ4ZDQxZmE2MTE3MTU3L2RtZXNnLXF1YW50YWwtY2Fpcm8tMzQ6MjAxNDAz
MTcxMjE5MzU6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xLjAtcmMxLTAwMjgz
LWcyMzM2MWNmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8yMzM2
MWNmMzJiNThlZmRmMDk5NDVhNjRlMWQ4ZDQxZmE2MTE3MTU3L2RtZXNnLXF1YW50YWwtY2Fp
cm8tMzY6MjAxNDAzMTcxMjE5MDQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4x
LjAtcmMxLTAwMjgzLWcyMzM2MWNmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzOC8yMzM2MWNmMzJiNThlZmRmMDk5NDVhNjRlMWQ4ZDQxZmE2MTE3MTU3L2RtZXNn
LXF1YW50YWwtY2Fpcm8tODoyMDE0MDMxNzEyMTkwNDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0w
MzE3MDAzODozLjEuMC1yYzEtMDAyODMtZzIzMzYxY2Y6MQowOjU6NCBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzE4MTI4NmFkMjJiZjliZmI4NWRlNjI1ZTg1MDEy
ODVkZTUyNjFiMzVdIGRyYmQ6IHByZXBhcmF0aW9uIGNvbW1pdCwgcGFzcyBkcmJkX2ludGVy
dmFsIHRvIGRyYmRfYWxfYmVnaW4vY29tcGxldGVfaW8KcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXIyLTAzMTcwMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMxNjIx
OjE4MTI4NmFkMjJiZjliZmI4NWRlNjI1ZTg1MDEyODVkZTUyNjFiMzU6YmlzZWN0LWxpbnV4
OQoKMjAxNC0wMy0xNy0xMjoyMDoxMCAxODEyODZhZDIyYmY5YmZiODVkZTYyNWU4NTAxMjg1
ZGU1MjYxYjM1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTE4MTI4NmFkMjJi
ZjliZmI4NWRlNjI1ZTg1MDEyODVkZTUyNjFiMzUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzE4MTI4NmFkMjJiZjliZmI4NWRl
NjI1ZTg1MDEyODVkZTUyNjFiMzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LTE4MTI4
NmFkMjJiZjliZmI4NWRlNjI1ZTg1MDEyODVkZTUyNjFiMzUKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1y
Mi0wMzE3MDAzOC0xODEyODZhZDIyYmY5YmZiODVkZTYyNWU4NTAxMjg1ZGU1MjYxYjM1Cmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC8xODEyODZhZDIy
YmY5YmZiODVkZTYyNWU4NTAxMjg1ZGU1MjYxYjM1L3ZtbGludXotMy4xLjAtcmMxLTAwMjgx
LWcxODEyODZhCgoyMDE0LTAzLTE3LTEyOjM1OjEwIGRldGVjdGluZyBib290IHN0YXRlIC4u
Li4uLgkxNC4JMzIgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbNzcyNjU0N2U2N2ExZmRhMGQxMmUx
ZGU1ZWM5MTdhMmU1ZDRiODE4Nl0gZHJiZDogcHJlcGFyZSB0byBhY3RpdmF0ZSB0d28gYWN0
aXZpdHkgbG9nIGV4dGVudHMgYXQgb25jZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6NzcyNjU0
N2U2N2ExZmRhMGQxMmUxZGU1ZWM5MTdhMmU1ZDRiODE4NjpiaXNlY3QtbGludXg5CgoyMDE0
LTAzLTE3LTEyOjM5OjQxIDc3MjY1NDdlNjdhMWZkYTBkMTJlMWRlNWVjOTE3YTJlNWQ0Yjgx
ODYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtNzcyNjU0N2U2N2ExZmRhMGQx
MmUxZGU1ZWM5MTdhMmU1ZDRiODE4NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNzcyNjU0N2U2N2ExZmRhMGQxMmUxZGU1ZWM5
MTdhMmU1ZDRiODE4Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgtNzcyNjU0N2U2N2Ex
ZmRhMGQxMmUxZGU1ZWM5MTdhMmU1ZDRiODE4Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LTc3MjY1NDdlNjdhMWZkYTBkMTJlMWRlNWVjOTE3YTJlNWQ0YjgxODYKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4Lzc3MjY1NDdlNjdhMWZkYTBk
MTJlMWRlNWVjOTE3YTJlNWQ0YjgxODYvdm1saW51ei0zLjEuMC1yYzEtMDAyODItZzc3MjY1
NDcKCjIwMTQtMDMtMTctMTM6MDg6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTIJMjEu
Li4JMzAJMzIgU1VDQ0VTUwoKMjMzNjFjZjMyYjU4ZWZkZjA5OTQ1YTY0ZTFkOGQ0MWZhNjEx
NzE1NyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgMjMzNjFjZjMyYjU4ZWZkZjA5
OTQ1YTY0ZTFkOGQ0MWZhNjExNzE1NwpBdXRob3I6IExhcnMgRWxsZW5iZXJnIDxsYXJzLmVs
bGVuYmVyZ0BsaW5iaXQuY29tPgpEYXRlOiAgIFRodSBNYXIgMzEgMTY6MzY6NDMgMjAxMSAr
MDIwMAoKICAgIGRyYmQ6IGdldCByaWQgb2YgYmlvX3NwbGl0LCBhbGxvdyBiaW9zIG9mICJh
cmJpdHJhcnkiIHNpemUKICAgIAogICAgV2hlcmUgImFyYml0cmFyeSIgc2l6ZSBpcyBjdXJy
ZW50bHkgMSBNaUIsIHdoaWNoIGlzIHRoZSBCSU9fTUFYX1NJWkUKICAgIGZvciBhcmNoaXRl
Y3R1cmVzIHdpdGggNGsgUEFHRV9DQUNIRV9TSVpFIChtb3N0KS4KICAgIAogICAgU2lnbmVk
LW9mZi1ieTogUGhpbGlwcCBSZWlzbmVyIDxwaGlsaXBwLnJlaXNuZXJAbGluYml0LmNvbT4K
ICAgIFNpZ25lZC1vZmYtYnk6IExhcnMgRWxsZW5iZXJnIDxsYXJzLmVsbGVuYmVyZ0BsaW5i
aXQuY29tPgoKOjA0MDAwMCAwNDAwMDAgN2I0MTBiZWI4MTgyMzRhMmYyODE2ZGQ1NGJhNWNl
NTA5ZGNlYjZjNyAxNTUzOGI2YmM5MTMyMTVlMzU1MThkZjAxM2Q2MDY3OWRkMzg3YTQ5IE0J
ZHJpdmVycwpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDMxNjIxOjc3MjY1NDdlNjdhMWZkYTBkMTJlMWRlNWVjOTE3YTJlNWQ0
YjgxODY6YmlzZWN0LWxpbnV4OQoKMjAxNC0wMy0xNy0xMzoxMzo0MyA3NzI2NTQ3ZTY3YTFm
ZGEwZDEyZTFkZTVlYzkxN2EyZTVkNGI4MTg2IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzgvNzcyNjU0N2U2N2ExZmRhMGQxMmUxZGU1ZWM5MTdhMmU1ZDRi
ODE4Ni92bWxpbnV6LTMuMS4wLXJjMS0wMDI4Mi1nNzcyNjU0NwoKMjAxNC0wMy0xNy0xMzox
Mzo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTM2Li4uLgkzOQk2NQk4Ny4uLgk5NiBT
VUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6
NzMzMDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOTpiaXNlY3QtbGludXg5
CiBURVNUIEZBSUxVUkUKWyAgICAwLjY2MzgyOV0gcGNpIDAwMDA6MDA6MDIuMDogQm9vdCB2
aWRlbyBkZXZpY2UKWyAgICAwLjY2NDQ4NV0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2
NApbICAgIDAuNjY1OTQyXSBUcnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFnZSBhcyBpbml0
cmFtZnMuLi4KWyAgICAyLjQ1MDgzNV0gc3dhcHBlciBpbnZva2VkIG9vbS1raWxsZXI6IGdm
cF9tYXNrPTB4MjAwZDIsIG9yZGVyPTAsIG9vbV9zY29yZV9hZGo9MApbICAgIDIuNDUxODA4
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLXJjNi0w
MTA2MS1nNzMzMDViNyAjMgpbICAgIDIuNDUyNzMyXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi40NTM0NDddICAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMGUzNTk4ZTggZmZmZmZmZmY4MTY4YjAyMiBmZmZmODgwMDBlMzU5
OTYwClsgICAgMi40NTQ0NDVdICBmZmZmZmZmZjgxNjg3ZThjIGZmZmY4ODAwMGUzNTYwMTAg
MDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMi40NTU0MzVdICBmZmZm
ZmZmZjgxZTE3NGEwIGZmZmY4ODAwMGUzNTk5MjggZmZmZmZmZmY4MTI2NjU3OSBmZmZmODgw
MDBlMzU5OTM4ClsgICAgMi40NTY0MjVdIENhbGwgVHJhY2U6ClsgICAgMi40NTY3NjRdICBb
PGZmZmZmZmZmODE2OGIwMjI+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDIuNDU3NDA4
XSAgWzxmZmZmZmZmZjgxNjg3ZThjPl0gZHVtcF9oZWFkZXIuaXNyYS4xMysweDZkLzB4MWIz
ClsgICAgMi40NTgyMDRdICBbPGZmZmZmZmZmODEyNjY1Nzk+XSA/IF9fZGVsYXkrMHhmLzB4
MTEKWyAgICAyLjQ1ODgyMl0gIFs8ZmZmZmZmZmY4MTI2NjVhMT5dID8gX19jb25zdF91ZGVs
YXkrMHgyNi8weDI4ClsgICAgMi40NTk1NDFdICBbPGZmZmZmZmZmODEwZjliNWE+XSBvdXRf
b2ZfbWVtb3J5KzB4MjJmLzB4Mjg0ClsgICAgMi40NjAyNDhdICBbPGZmZmZmZmZmODEwZmQ2
NGI+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4NWZiLzB4NzNmClsgICAgMi40NjEwNDNd
ICBbPGZmZmZmZmZmODEwZjc0ZmU+XSBncmFiX2NhY2hlX3BhZ2Vfd3JpdGVfYmVnaW4rMHg3
My8weGM1ClsgICAgMi40NjE4NThdICBbPGZmZmZmZmZmODExNDVlZjQ+XSBzaW1wbGVfd3Jp
dGVfYmVnaW4rMHgyYi8weDgyClsgICAgMi40NjI1OTBdICBbPGZmZmZmZmZmODEwZjZkOTU+
XSBnZW5lcmljX2ZpbGVfYnVmZmVyZWRfd3JpdGUrMHhmZC8weDIyNApbICAgIDIuNDYzNDIx
XSAgWzxmZmZmZmZmZjgxMGY3Y2IwPl0gX19nZW5lcmljX2ZpbGVfYWlvX3dyaXRlKzB4MWMx
LzB4MWY4ClsgICAgMi40NjQyNTddICBbPGZmZmZmZmZmODIwZTRmMzM+XSA/IGluaXRyZF9s
b2FkKzB4MmM0LzB4MmM0ClsgICAgMi40NjQ5NDddICBbPGZmZmZmZmZmODEwZjdkM2Q+XSBn
ZW5lcmljX2ZpbGVfYWlvX3dyaXRlKzB4NTYvMHhjMwpbICAgIDIuNDY1NzI4XSAgWzxmZmZm
ZmZmZjgxMTI3YWNmPl0gZG9fc3luY193cml0ZSsweDYxLzB4N2MKWyAgICAyLjQ2NjQwMl0g
IFs8ZmZmZmZmZmY4MTEyODJiMD5dIHZmc193cml0ZSsweGE1LzB4ZTEKWyAgICAyLjQ2NzA0
M10gIFs8ZmZmZmZmZmY4MTEyODkxYj5dIFN5U193cml0ZSsweDQ5LzB4N2YKWyAgICAyLjQ2
NzY2N10gIFs8ZmZmZmZmZmY4MjBlNTIxNj5dIGRvX2NvcHkrMHg3My8weDhlClsgICAgMi40
NjgzMTFdICBbPGZmZmZmZmZmODIwZTRmY2U+XSB3cml0ZV9idWZmZXIrMHgyMS8weDMwClsg
ICAgMi40Njg5NzVdICBbPGZmZmZmZmZmODIwZTUwMDU+XSBmbHVzaF9idWZmZXIrMHgyOC8w
eDgxClsgICAgMi40Njk2NTddICBbPGZmZmZmZmZmODIxMGYwNGM+XSBndW56aXArMHgyNjQv
MHgyZjMKWyAgICAyLjQ3MDI4NV0gIFs8ZmZmZmZmZmY4MjEwZWRkZj5dID8gYnVuemlwMisw
eDM5MS8weDM5MQpbICAgIDIuNDcwOTMwXSAgWzxmZmZmZmZmZjgyMGU0ZmRkPl0gPyB3cml0
ZV9idWZmZXIrMHgzMC8weDMwClsgICAgMi40NzE2MjRdICBbPGZmZmZmZmZmODIwZTUzN2Q+
XSB1bnBhY2tfdG9fcm9vdGZzKzB4MTRjLzB4MjY3ClsgICAgMi40NzIzNTBdICBbPGZmZmZm
ZmZmODIwZTRmMzM+XSA/IGluaXRyZF9sb2FkKzB4MmM0LzB4MmM0ClsgICAgMi40NzMwNTRd
ICBbPGZmZmZmZmZmODIwZTU5MWM+XSA/IGNsZWFuX3Jvb3RmcysweDE1Ni8weDE1NgpbICAg
IDIuNDczNzYyXSAgWzxmZmZmZmZmZjgyMGU1OTc5Pl0gcG9wdWxhdGVfcm9vdGZzKzB4NWQv
MHhkOApbICAgIDIuNDc0NDU4XSAgWzxmZmZmZmZmZjgyMGU1OTFjPl0gPyBjbGVhbl9yb290
ZnMrMHgxNTYvMHgxNTYKWyAgICAyLjQ3NTE3Nl0gIFs8ZmZmZmZmZmY4MTAwMDJhYT5dIGRv
X29uZV9pbml0Y2FsbCsweDgyLzB4MTEyClsgICAgMi40NzU4ODJdICBbPGZmZmZmZmZmODEw
ODAxN2E+XSA/IHBhcnNlX2FyZ3MrMHgxODkvMHgyNDcKWyAgICAyLjQ3NjU3Ml0gIFs8ZmZm
ZmZmZmY4MjBlM2U5Nj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE1LzB4MTlhClsgICAg
Mi40NzczMzldICBbPGZmZmZmZmZmODIwZTM3MWQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgv
MHg4OApbICAgIDIuNDc4MDQ4XSAgWzxmZmZmZmZmZjgxNjdmOTVkPl0gPyByZXN0X2luaXQr
MHhjMS8weGMxClsgICAgMi40Nzg3MTVdICBbPGZmZmZmZmZmODE2N2Y5NmI+XSBrZXJuZWxf
aW5pdCsweGUvMHhkYQpbICAgIDIuNDc5MzY4XSAgWzxmZmZmZmZmZjgxNjk0YmJhPl0gcmV0
X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAyLjQ4MDA1NV0gIFs8ZmZmZmZmZmY4MTY3Zjk1
ZD5dID8gcmVzdF9pbml0KzB4YzEvMHhjMQpbICAgIDIuNDgwNjk3XSBNZW0tSW5mbzoKWyAg
ICAyLjQ4MDk4Nl0gRE1BIHBlci1jcHU6ClsgICAgMi40ODEzMjFdIENQVSAgICAwOiBoaTog
ICAgMCwgYnRjaDogICAxIHVzZDogICAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzgvNzMzMDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOS9kbWVz
Zy1xdWFudGFsLWNhaXJvLTEzOjIwMTQwMzE3MDIwMTMzOng4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4OjMuMTQuMC1yYzYtMDEwNjEtZzczMzA1Yjc6Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4LzczMzA1YjcyZmZmZTJhZDAxYjdhNjcyZjk5MTk1M2Qw
ZWZlMjEzMTkvZG1lc2ctcXVhbnRhbC1jYWlyby0yNzoyMDE0MDMxNzAyMDEyODp4ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM2LTAxMDYxLWc3MzMwNWI3OjIKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC83MzMwNWI3MmZmZmUyYWQwMWI3
YTY3MmY5OTE5NTNkMGVmZTIxMzE5L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjg6MjAxNDAzMTcw
MTEzMDc6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi0wMTA2MS1n
NzMzMDViNzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNzMzMDVi
NzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOS9kbWVzZy1xdWFudGFsLXhwcy0x
OjIwMTQwMzE3MDIwMTMwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1y
YzYtMDEwNjEtZzczMzA1Yjc6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcw
MDM4LzczMzA1YjcyZmZmZTJhZDAxYjdhNjcyZjk5MTk1M2QwZWZlMjEzMTkvZG1lc2ctcXVh
bnRhbC1jYWlyby0zOToyMDE0MDMxNzAyMDEyOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3
MDAzODozLjE0LjAtcmM2LTAxMDYxLWc3MzMwNWI3OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMi0wMzE3MDAzOC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3MmY5OTE5NTNkMGVmZTIx
MzE5L2RtZXNnLXF1YW50YWwtc25iLTI0OjIwMTQwMzE3MDIwMTI4Ong4Nl82NC1yYW5kY29u
ZmlnLXIyLTAzMTcwMDM4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3MmY5OTE5NTNkMGVmZTIxMzE5L2RtZXNnLXF1YW50
YWwtY2Fpcm8tMzE6MjAxNDAzMTcwMjAxMzQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
Mzg6My4xNC4wLXJjNi0wMTA2MS1nNzMzMDViNzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvNzMzMDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMx
OS9kbWVzZy15b2N0by1jYWlyby0zNDoyMDE0MDMxNzAxMTMxMTp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzODozLjE0LjAtcmM2LTAxMDYxLWc3MzMwNWI3OjIKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3MmY5OTE5
NTNkMGVmZTIxMzE5L2RtZXNnLXF1YW50YWwtY2Fpcm8tMzk6MjAxNDAzMTcwMTEzMTI6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi0wMTA2MS1nNzMzMDViNzoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNzMzMDViNzJmZmZlMmFk
MDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOS9kbWVzZy1xdWFudGFsLWNhaXJvLTI6MjAxNDAz
MTcwMjAxMjk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi0wMTA2
MS1nNzMzMDViNzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNzMz
MDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOS9kbWVzZy1xdWFudGFsLWNh
aXJvLTEwOjIwMTQwMzE3MDExMzE0Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMu
MTQuMC1yYzYtMDEwNjEtZzczMzA1Yjc6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIy
LTAzMTcwMDM4LzczMzA1YjcyZmZmZTJhZDAxYjdhNjcyZjk5MTk1M2QwZWZlMjEzMTkvZG1l
c2cteW9jdG8tY2Fpcm8tMzA6MjAxNDAzMTcwMjAxMzA6eDg2XzY0LXJhbmRjb25maWctcjIt
MDMxNzAwMzg6My4xNC4wLXJjNi0wMTA2MS1nNzMzMDViNzoyCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjItMDMxNzAwMzgvNzMzMDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBl
ZmUyMTMxOS9kbWVzZy15b2N0by1jYWlyby0zMzoyMDE0MDMxNzAxMTMyMTp4ODZfNjQtcmFu
ZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM2LTAxMDYxLWc3MzMwNWI3OjIKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3
MmY5OTE5NTNkMGVmZTIxMzE5L2RtZXNnLXlvY3RvLWNhaXJvLTM0OjIwMTQwMzE3MDExMzIy
Ong4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1yYzYtMDEwNjEtZzczMzA1
Yjc6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LzczMzA1YjcyZmZm
ZTJhZDAxYjdhNjcyZjk5MTk1M2QwZWZlMjEzMTkvZG1lc2ctcXVhbnRhbC1jYWlyby0yODoy
MDE0MDMxNzAxMTMxODp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM2
LTAxMDYxLWc3MzMwNWI3OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3MmY5OTE5NTNkMGVmZTIxMzE5L2RtZXNnLXF1YW50
YWwtY2Fpcm8tMjY6MjAxNDAzMTcwMjAxMjk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
Mzg6My4xNC4wLXJjNi0wMTA2MS1nNzMzMDViNzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzgvNzMzMDViNzJmZmZlMmFkMDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMx
OS9kbWVzZy15b2N0by1jYWlyby0xMzoyMDE0MDMxNzAxMTMyMTp4ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzODozLjE0LjAtcmM2LTAxMDYxLWc3MzMwNWI3OjIKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC83MzMwNWI3MmZmZmUyYWQwMWI3YTY3MmY5OTE5
NTNkMGVmZTIxMzE5L2RtZXNnLXF1YW50YWwtY2Fpcm8tMzk6MjAxNDAzMTcwMTEzMjI6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi0wMTA2MS1nNzMzMDViNzoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvNzMzMDViNzJmZmZlMmFk
MDFiN2E2NzJmOTkxOTUzZDBlZmUyMTMxOS9kbWVzZy1xdWFudGFsLXdhaW1lYS0xMToyMDE0
MDMxNzAyMDIyOTp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM2LTAx
MDYxLWc3MzMwNWI3OjIKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVB
RCBpcyBub3cgYXQgNzMzMDViNyAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHkt
MjAxNDAzMTYyMScKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGlu
dXMKRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbGludXMKICAgYTRlY2RmOC4uZGNiOTlmZCAgbWFz
dGVyICAgICAtPiBsaW51cy9tYXN0ZXIKICogW25ldyB0YWddICAgICAgICAgdjMuMTQtcmM3
ICAtPiB2My4xNC1yYzcKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNzMzMDViNy4uLiAw
ZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDAzMTYyMScKSEVBRCBpcyBu
b3cgYXQgZGNiOTlmZC4uLiBMaW51eCAzLjE0LXJjNwpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzE2MjE6ZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2Ni
YzQyOTE5MGYxNTpiaXNlY3QtbGludXg5CgoyMDE0LTAzLTE3LTEzOjIyOjAwIGRjYjk5ZmQ5
YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjItMDMxNzAwMzgtZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
MzgvZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctcjItMDMxNzAwMzgtZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5
MGYxNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4LWRjYjk5ZmQ5YjA4Y2ZlMWFmZTQy
NmFmNGQ4ZDNjYmM0MjkxOTBmMTUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIyLTAzMTcwMDM4L2RjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUv
dm1saW51ei0zLjE0LjAtcmM3CgoyMDE0LTAzLTE3LTE0OjA4OjAwIGRldGVjdGluZyBib290
IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjY3MzA1M10gcGNpIDAwMDA6MDA6MDIu
MDogQm9vdCB2aWRlbyBkZXZpY2UKWyAgICAwLjY3MzY3NF0gUENJOiBDTFMgMCBieXRlcywg
ZGVmYXVsdCA2NApbICAgIDAuNjc1MTQwXSBUcnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFn
ZSBhcyBpbml0cmFtZnMuLi4KWyAgICAyLjQ1MjMwNl0gc3dhcHBlciBpbnZva2VkIG9vbS1r
aWxsZXI6IGdmcF9tYXNrPTB4Mjg0MGQwLCBvcmRlcj0wLCBvb21fc2NvcmVfYWRqPTAKWyAg
ICAyLjQ1MzI3OF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTQuMC1yYzcgIzEKWyAgICAyLjQ1Mzk5NV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNDU0Njg4XSAgMDAwMDAwMDAwMDAwMDAw
MCBmZmZmODgwMDBlMzU5N2QwIGZmZmZmZmZmODE2ODllNzMgZmZmZjg4MDAwZTM1OTg0OApb
ICAgIDIuNDU1NjUwXSAgZmZmZmZmZmY4MTY4NmNkZCBmZmZmODgwMDBlMzU2MDEwIDAwMDAw
MDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDIuNDU2NjAyXSAgZmZmZmZmZmY4
MWUxNzRhMCBmZmZmODgwMDBlMzU5ODEwIGZmZmZmZmZmODEyNjVmNzkgZmZmZjg4MDAwZTM1
OTgyMApbICAgIDIuNDU3NTUyXSBDYWxsIFRyYWNlOgpbICAgIDIuNDU3ODcwXSAgWzxmZmZm
ZmZmZjgxNjg5ZTczPl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICAyLjQ1ODQ5M10gIFs8
ZmZmZmZmZmY4MTY4NmNkZD5dIGR1bXBfaGVhZGVyLmlzcmEuMTMrMHg2ZC8weDFiMwpbICAg
IDIuNDU5MjIxXSAgWzxmZmZmZmZmZjgxMjY1Zjc5Pl0gPyBfX2RlbGF5KzB4Zi8weDExClsg
ICAgMi40NTk4MDldICBbPGZmZmZmZmZmODEyNjVmYTE+XSA/IF9fY29uc3RfdWRlbGF5KzB4
MjYvMHgyOApbICAgIDIuNDYwNDk5XSAgWzxmZmZmZmZmZjgxMGY5NTViPl0gb3V0X29mX21l
bW9yeSsweDIyZi8weDI4NApbICAgIDIuNDYxMTcxXSAgWzxmZmZmZmZmZjgxMGZkMDRjPl0g
X19hbGxvY19wYWdlc19ub2RlbWFzaysweDVmYi8weDczZgpbICAgIDIuNDYxOTE2XSAgWzxm
ZmZmZmZmZjgxMTIwYTk1Pl0gX19fX2NhY2hlX2FsbG9jKzB4MzE3LzB4NmQzClsgICAgMi40
NjI2MTVdICBbPGZmZmZmZmZmODEyNWZmZmE+XSA/IF9fcmFkaXhfdHJlZV9wcmVsb2FkKzB4
NDYvMHg5NgpbICAgIDIuNDYzMzQ5XSAgWzxmZmZmZmZmZjgxMTIwNmI2Pl0ga21lbV9jYWNo
ZV9hbGxvYysweDZhLzB4MTMyClsgICAgMi40NjQwMzhdICBbPGZmZmZmZmZmODEyNWZmZmE+
XSBfX3JhZGl4X3RyZWVfcHJlbG9hZCsweDQ2LzB4OTYKWyAgICAyLjQ2NDc0MV0gIFs8ZmZm
ZmZmZmY4MTI2MDA5MT5dIHJhZGl4X3RyZWVfbWF5YmVfcHJlbG9hZCsweGYvMHgxZgpbICAg
IDIuNDY1NDk2XSAgWzxmZmZmZmZmZjgxMGY2YWQ0Pl0gYWRkX3RvX3BhZ2VfY2FjaGVfbG9j
a2VkKzB4NDYvMHgxMjAKWyAgICAyLjQ2NjI1OV0gIFs8ZmZmZmZmZmY4MTBmNmJjNj5dIGFk
ZF90b19wYWdlX2NhY2hlX2xydSsweDE4LzB4MzcKWyAgICAyLjQ2Njk3M10gIFs8ZmZmZmZm
ZmY4MTBmNmYyMT5dIGdyYWJfY2FjaGVfcGFnZV93cml0ZV9iZWdpbisweDk1LzB4YzUKWyAg
ICAyLjQ2Nzc3Nl0gIFs8ZmZmZmZmZmY4MTE0NThmNT5dIHNpbXBsZV93cml0ZV9iZWdpbisw
eDJiLzB4ODIKWyAgICAyLjQ2ODQ4MV0gIFs8ZmZmZmZmZmY4MTBmNjc5Nj5dIGdlbmVyaWNf
ZmlsZV9idWZmZXJlZF93cml0ZSsweGZkLzB4MjI0ClsgICAgMi40NjkyNzZdICBbPGZmZmZm
ZmZmODEwZjc2YjE+XSBfX2dlbmVyaWNfZmlsZV9haW9fd3JpdGUrMHgxYzEvMHgxZjgKWyAg
ICAyLjQ3MDA2N10gIFs8ZmZmZmZmZmY4MjBlNGYzMz5dID8gaW5pdHJkX2xvYWQrMHgyYzQv
MHgyYzQKWyAgICAyLjQ3MDcyMF0gIFs8ZmZmZmZmZmY4MTBmNzczZT5dIGdlbmVyaWNfZmls
ZV9haW9fd3JpdGUrMHg1Ni8weGMzClsgICAgMi40NzE0NTRdICBbPGZmZmZmZmZmODExMjc0
ZDA+XSBkb19zeW5jX3dyaXRlKzB4NjEvMHg3YwpbICAgIDIuNDcyMTAxXSAgWzxmZmZmZmZm
ZjgxMTI3Y2IxPl0gdmZzX3dyaXRlKzB4YTUvMHhlMQpbICAgIDIuNDcyNjk0XSAgWzxmZmZm
ZmZmZjgxMTI4MzFjPl0gU3lTX3dyaXRlKzB4NDkvMHg3ZgpbICAgIDIuNDczMjk2XSAgWzxm
ZmZmZmZmZjgyMGU1MjE2Pl0gZG9fY29weSsweDczLzB4OGUKWyAgICAyLjQ3Mzg3MF0gIFs8
ZmZmZmZmZmY4MjBlNGZjZT5dIHdyaXRlX2J1ZmZlcisweDIxLzB4MzAKWyAgICAyLjQ3NDUw
OV0gIFs8ZmZmZmZmZmY4MjBlNTAwNT5dIGZsdXNoX2J1ZmZlcisweDI4LzB4ODEKWyAgICAy
LjQ3NTE1MF0gIFs8ZmZmZmZmZmY4MjEwZjA1MD5dIGd1bnppcCsweDI2NC8weDJmMwpbICAg
IDIuNDc1NzQ0XSAgWzxmZmZmZmZmZjgyMTBlZGUzPl0gPyBidW56aXAyKzB4MzkxLzB4Mzkx
ClsgICAgMi40NzYzNjVdICBbPGZmZmZmZmZmODIwZTRmZGQ+XSA/IHdyaXRlX2J1ZmZlcisw
eDMwLzB4MzAKWyAgICAyLjQ3NzAyNV0gIFs8ZmZmZmZmZmY4MjBlNTM3ZD5dIHVucGFja190
b19yb290ZnMrMHgxNGMvMHgyNjcKWyAgICAyLjQ3NzcxMl0gIFs8ZmZmZmZmZmY4MjBlNGYz
Mz5dID8gaW5pdHJkX2xvYWQrMHgyYzQvMHgyYzQKWyAgICAyLjQ3ODM3MV0gIFs8ZmZmZmZm
ZmY4MjBlNTkxYz5dID8gY2xlYW5fcm9vdGZzKzB4MTU2LzB4MTU2ClsgICAgMi40NzkwNDhd
ICBbPGZmZmZmZmZmODIwZTU5Nzk+XSBwb3B1bGF0ZV9yb290ZnMrMHg1ZC8weGQ4ClsgICAg
Mi40Nzk3MDRdICBbPGZmZmZmZmZmODIwZTU5MWM+XSA/IGNsZWFuX3Jvb3RmcysweDE1Ni8w
eDE1NgpbICAgIDIuNDgwMzgzXSAgWzxmZmZmZmZmZjgxMDAwMmFhPl0gZG9fb25lX2luaXRj
YWxsKzB4ODIvMHgxMTIKWyAgICAyLjQ4MTA3MF0gIFs8ZmZmZmZmZmY4MTA3ZmUzYj5dID8g
cGFyc2VfYXJncysweDE4OS8weDI0NwpbICAgIDIuNDgxNzE2XSAgWzxmZmZmZmZmZjgyMGUz
ZTk2Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTUvMHgxOWEKWyAgICAyLjQ4MjQ1Nl0g
IFs8ZmZmZmZmZmY4MjBlMzcxZD5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAg
Mi40ODMxMjhdICBbPGZmZmZmZmZmODE2N2U3ZWQ+XSA/IHJlc3RfaW5pdCsweGMxLzB4YzEK
WyAgICAyLjQ4Mzc0M10gIFs8ZmZmZmZmZmY4MTY3ZTdmYj5dIGtlcm5lbF9pbml0KzB4ZS8w
eGRhClsgICAgMi40ODQzNjNdICBbPGZmZmZmZmZmODE2OTM5N2E+XSByZXRfZnJvbV9mb3Jr
KzB4N2EvMHhiMApbICAgIDIuNDg0OTk4XSAgWzxmZmZmZmZmZjgxNjdlN2VkPl0gPyByZXN0
X2luaXQrMHhjMS8weGMxClsgICAgMi40ODU2MzFdIE1lbS1JbmZvOgpbICAgIDIuNDg1OTA3
XSBETUEgcGVyLWNwdToKWyAgICAyLjQ4NjIyNl0gQ1BVICAgIDA6IGhpOiAgICAwLCBidGNo
OiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9k
Y2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXF1YW50YWwt
Y2Fpcm8tMTA6MjAxNDAzMTcxNDA4MTk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6
My4xNC4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGNi
OTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWNh
aXJvLTEwOjIwMTQwMzE3MTQwODMwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMu
MTQuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2RjYjk5
ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUvZG1lc2ctcXVhbnRhbC1jYWly
by0xMDoyMDE0MDMxNzE0MDg0MDp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0
LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kY2I5OWZk
OWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXF1YW50YWwtY2Fpcm8t
MTA6MjAxNDAzMTcxNDA4NTA6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4w
LXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGNiOTlmZDli
MDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWNhaXJvLTEw
OjIwMTQwMzE3MTQwOTAwOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1y
Yzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2RjYjk5ZmQ5YjA4
Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUvZG1lc2ctcXVhbnRhbC1jYWlyby0xMDoy
MDE0MDMxNzE0MDkxNjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM3
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9kY2I5OWZkOWIwOGNm
ZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L2RtZXNnLXF1YW50YWwtY2Fpcm8tMzk6MjAx
NDAzMTcxNDA4NTA6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZGNiOTlmZDliMDhjZmUx
YWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS9kbWVzZy1xdWFudGFsLWNhaXJvLTM5OjIwMTQw
MzE3MTQwOTAxOng4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1yYzc6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4L2RjYjk5ZmQ5YjA4Y2ZlMWFm
ZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUvZG1lc2ctcXVhbnRhbC1jYWlyby0zOToyMDE0MDMx
NzE0MDkxNjp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODozLjE0LjAtcmM3OjEKMDo5
OjggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCgo9PT09PT09PT0gbGludXgtbmV4dCA9
PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZGNiOTlmZC4uLiBMaW51eCAz
LjE0LXJjNwpIRUFEIGlzIG5vdyBhdCBlZDg3ZWFkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNp
ZmljIGZpbGVzIGZvciAyMDE0MDMxNApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwMzE2MjE6ZWQ4N2VhZDU2NWE2MTMwMTc0ZmMyN2E0NmFmNjUxNjljYmZmNzY3
NzpiaXNlY3QtbGludXg5CiBURVNUIEZBSUxVUkUKWyAgICAwLjkzNjE1NV0gcGNpIDAwMDA6
MDA6MDIuMDogQm9vdCB2aWRlbyBkZXZpY2UKWyAgICAwLjkzNjgxMl0gUENJOiBDTFMgMCBi
eXRlcywgZGVmYXVsdCA2NApbICAgIDAuOTM4NDE2XSBUcnlpbmcgdG8gdW5wYWNrIHJvb3Rm
cyBpbWFnZSBhcyBpbml0cmFtZnMuLi4KWyAgICAzLjI4ODg5NV0gc3dhcHBlciBpbnZva2Vk
IG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjAwZDIsIG9yZGVyPTAsIG9vbV9zY29yZV9hZGo9
MApbICAgIDMuMjkwNzUzXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xNC4wLXJjNi1uZXh0LTIwMTQwMzE0ICMxClsgICAgMy4yOTIyMjRdIEhhcmR3YXJl
IG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAzLjI5MzQ0
OV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZTM1OThlOCBmZmZmZmZmZjgxNjliNzI5
IGZmZmY4ODAwMGUzNTk5NjAKWyAgICAzLjI5NTI0M10gIGZmZmZmZmZmODE2OTg0Y2QgZmZm
Zjg4MDAwZTM1NjAxMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAz
LjI5Njk3Nl0gIGZmZmZmZmZmODFlMTc0YTAgZmZmZjg4MDAwZTM1OTkyOCBmZmZmZmZmZjgx
MjYzM2Y5IGZmZmY4ODAwMGUzNTk5MzgKWyAgICAzLjI5ODY1OF0gQ2FsbCBUcmFjZToKWyAg
ICAzLjI5OTI0MF0gIFs8ZmZmZmZmZmY4MTY5YjcyOT5dIGR1bXBfc3RhY2srMHgxOS8weDFi
ClsgICAgMy4zMDAzNDZdICBbPGZmZmZmZmZmODE2OTg0Y2Q+XSBkdW1wX2hlYWRlci5pc3Jh
LjEzKzB4NmQvMHgxYjMKWyAgICAzLjMwMTY4NF0gIFs8ZmZmZmZmZmY4MTI2MzNmOT5dID8g
X19kZWxheSsweGYvMHgxMQpbICAgIDMuMzAyNzQ3XSAgWzxmZmZmZmZmZjgxMjYzNDIxPl0g
PyBfX2NvbnN0X3VkZWxheSsweDI2LzB4MjgKWyAgICAzLjMwNDAwMF0gIFs8ZmZmZmZmZmY4
MTBmODJlMj5dIG91dF9vZl9tZW1vcnkrMHgyMmYvMHgyODQKWyAgICAzLjMwNTIwM10gIFs8
ZmZmZmZmZmY4MTBmYmRkMz5dIF9fYWxsb2NfcGFnZXNfbm9kZW1hc2srMHg1ZmIvMHg3M2YK
WyAgICAzLjMwNjUyMl0gIFs8ZmZmZmZmZmY4MTBmNWIzZj5dIGdyYWJfY2FjaGVfcGFnZV93
cml0ZV9iZWdpbisweDczLzB4YzUKWyAgICAzLjMwNzkyNl0gIFs8ZmZmZmZmZmY4MTE0NDc5
Yz5dIHNpbXBsZV93cml0ZV9iZWdpbisweDJiLzB4ODIKWyAgICAzLjMwOTI3N10gIFs8ZmZm
ZmZmZmY4MTBmNTE0Mz5dIGdlbmVyaWNfZmlsZV9idWZmZXJlZF93cml0ZSsweGZkLzB4MjI0
ClsgICAgMy4zMTA3ODBdICBbPGZmZmZmZmZmODEwZjYzZjA+XSBfX2dlbmVyaWNfZmlsZV9h
aW9fd3JpdGUrMHgxYzEvMHgxZjgKWyAgICAzLjMxMjI1M10gIFs8ZmZmZmZmZmY4MjBlYWYz
Mz5dID8gaW5pdHJkX2xvYWQrMHgyYzQvMHgyYzQKWyAgICAzLjMxMzQyMF0gIFs8ZmZmZmZm
ZmY4MTBmNjQ3ZD5dIGdlbmVyaWNfZmlsZV9haW9fd3JpdGUrMHg1Ni8weGMzClsgICAgMy4z
MTQ2OThdICBbPGZmZmZmZmZmODExMjY0OGI+XSBkb19zeW5jX3dyaXRlKzB4NjEvMHg3Ywpb
ICAgIDMuMzE1ODc3XSAgWzxmZmZmZmZmZjgxMTI2YzZjPl0gdmZzX3dyaXRlKzB4YTUvMHhl
MQpbICAgIDMuMzE3MDMxXSAgWzxmZmZmZmZmZjgxMTI3MmUxPl0gU3lTX3dyaXRlKzB4NDkv
MHg3ZgpbICAgIDMuMzE4MjUwXSAgWzxmZmZmZmZmZjgyMGViMjE2Pl0gZG9fY29weSsweDcz
LzB4OGUKWyAgICAzLjMxOTQzNF0gIFs8ZmZmZmZmZmY4MjBlYWZjZT5dIHdyaXRlX2J1ZmZl
cisweDIxLzB4MzAKWyAgICAzLjMyMDY4M10gIFs8ZmZmZmZmZmY4MjBlYjAwNT5dIGZsdXNo
X2J1ZmZlcisweDI4LzB4ODEKWyAgICAzLjMyMTgxOV0gIFs8ZmZmZmZmZmY4MjExNGJhMT5d
IGd1bnppcCsweDI2NC8weDJmMwpbICAgIDMuMzIzMDEyXSAgWzxmZmZmZmZmZjgyMTE0OTM0
Pl0gPyBidW56aXAyKzB4MzkxLzB4MzkxClsgICAgMy4zMjQyNTRdICBbPGZmZmZmZmZmODIw
ZWFmZGQ+XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAKWyAgICAzLjMyNTU1Ml0gIFs8ZmZm
ZmZmZmY4MjBlYjM3ZD5dIHVucGFja190b19yb290ZnMrMHgxNGMvMHgyNjcKWyAgICAzLjMy
NjgxMV0gIFs8ZmZmZmZmZmY4MjBlYWYzMz5dID8gaW5pdHJkX2xvYWQrMHgyYzQvMHgyYzQK
WyAgICAzLjMyNzkyMF0gIFs8ZmZmZmZmZmY4MjBlYjkxYz5dID8gY2xlYW5fcm9vdGZzKzB4
MTU2LzB4MTU2ClsgICAgMy4zMjkyMDFdICBbPGZmZmZmZmZmODIwZWI5Nzk+XSBwb3B1bGF0
ZV9yb290ZnMrMHg1ZC8weGQ4ClsgICAgMy4zMzA0NjZdICBbPGZmZmZmZmZmODIwZWI5MWM+
XSA/IGNsZWFuX3Jvb3RmcysweDE1Ni8weDE1NgpbICAgIDMuMzMxODExXSAgWzxmZmZmZmZm
ZjgxMDAwMmFhPl0gZG9fb25lX2luaXRjYWxsKzB4ODIvMHgxMTIKWyAgICAzLjMzMzA3NV0g
IFs8ZmZmZmZmZmY4MTA3ZWQwNT5dID8gcGFyc2VfYXJncysweDE4OS8weDI0NwpbICAgIDMu
MzM0MzE3XSAgWzxmZmZmZmZmZjgyMGU5ZTk2Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgx
MTUvMHgxOWEKWyAgICAzLjMzNTcxM10gIFs8ZmZmZmZmZmY4MjBlOTcxZD5dID8gZG9fZWFy
bHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMy4zMzY5OTVdICBbPGZmZmZmZmZmODE2OGZmMmE+
XSA/IHJlc3RfaW5pdCsweGJlLzB4YmUKWyAgICAzLjMzODE3Ml0gIFs8ZmZmZmZmZmY4MTY4
ZmYzOD5dIGtlcm5lbF9pbml0KzB4ZS8weGRhClsgICAgMy4zMzkzMTBdICBbPGZmZmZmZmZm
ODE2YTU0ZmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDMuMzQwNDcwXSAgWzxm
ZmZmZmZmZjgxNjhmZjJhPl0gPyByZXN0X2luaXQrMHhiZS8weGJlClsgICAgMy4zNDE2NjNd
IE1lbS1JbmZvOgpbICAgIDMuMzQyMjIxXSBETUEgcGVyLWNwdToKWyAgICAzLjM0MjgyOF0g
Q1BVICAgIDA6IGhpOiAgICAwLCBidGNoOiAgIDEgdXNkOiAgIDAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lZDg3ZWFkNTY1YTYxMzAxNzRmYzI3YTQ2YWY2NTE2
OWNiZmY3Njc3L2RtZXNnLXF1YW50YWwtYXRoZW5zLTMyOjIwMTQwMzE3MDA1NTQ2Ong4Nl82
NC1yYW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1yYzYtbmV4dC0yMDE0MDMxNDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZWQ4N2VhZDU2NWE2MTMwMTc0
ZmMyN2E0NmFmNjUxNjljYmZmNzY3Ny9kbWVzZy15b2N0by1qYWtldG93bi0yMjoyMDE0MDMx
NzAwNTU0Nzp4ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzODo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjItMDMxNzAwMzgvZWQ4N2VhZDU2NWE2MTMwMTc0ZmMyN2E0NmFmNjUx
NjljYmZmNzY3Ny9kbWVzZy15b2N0by1yb2FtLTI3OjIwMTQwMzE3MDA1NTI4Ong4Nl82NC1y
YW5kY29uZmlnLXIyLTAzMTcwMDM4OjMuMTQuMC1yYzYtbmV4dC0yMDE0MDMxNDoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzgvZWQ4N2VhZDU2NWE2MTMwMTc0ZmMy
N2E0NmFmNjUxNjljYmZmNzY3Ny9kbWVzZy15b2N0by1hdGhlbnMtMzA6MjAxNDAzMTcwMDU5
MjQ6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi1uZXh0LTIwMTQw
MzE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lZDg3ZWFkNTY1
YTYxMzAxNzRmYzI3YTQ2YWY2NTE2OWNiZmY3Njc3L2RtZXNnLXF1YW50YWwtY2Fpcm8tNDc6
MjAxNDAzMTcwMDU4Mzc6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJj
Ni1uZXh0LTIwMTQwMzE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAz
OC9lZDg3ZWFkNTY1YTYxMzAxNzRmYzI3YTQ2YWY2NTE2OWNiZmY3Njc3L2RtZXNnLXF1YW50
YWwtd2FpbWVhLTc6MjAxNDAzMTcwMDU5NTc6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAw
Mzg6My4xNC4wLXJjNi1uZXh0LTIwMTQwMzE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMi0wMzE3MDAzOC9lZDg3ZWFkNTY1YTYxMzAxNzRmYzI3YTQ2YWY2NTE2OWNiZmY3Njc3
L2RtZXNnLXF1YW50YWwtY2Fpcm8tNDE6MjAxNDAzMTcwMDU5MDM6eDg2XzY0LXJhbmRjb25m
aWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi1uZXh0LTIwMTQwMzE0OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lZDg3ZWFkNTY1YTYxMzAxNzRmYzI3YTQ2YWY2
NTE2OWNiZmY3Njc3L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjU6MjAxNDAzMTcwMDU5MDI6eDg2
XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6My4xNC4wLXJjNi1uZXh0LTIwMTQwMzE0OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMi0wMzE3MDAzOC9lZDg3ZWFkNTY1YTYxMzAx
NzRmYzI3YTQ2YWY2NTE2OWNiZmY3Njc3L2RtZXNnLXF1YW50YWwtaW5uLTY6MjAxNDAzMTcw
MDU1NTk6eDg2XzY0LXJhbmRjb25maWctcjItMDMxNzAwMzg6OgowOjk6OSBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoK

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc6-01061-g73305b7"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc6 Kernel Configuration
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
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

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
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
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
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
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
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
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
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

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
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
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
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
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
CONFIG_HWPOISON_INJECT=m
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

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
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
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
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_TABLES=y
# CONFIG_NF_TABLES_INET is not set
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
# CONFIG_NFT_HASH is not set
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPPORT=m
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=y
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=m
# CONFIG_IP_SET_HASH_NETIFACE is not set
CONFIG_IP_SET_LIST_SET=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
# CONFIG_NF_TABLES_ARP is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
# CONFIG_NFT_CHAIN_ROUTE_IPV6 is not set
CONFIG_NFT_REJECT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
# CONFIG_NF_TABLES_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_6LOWPAN is not set
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
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
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=y
CONFIG_NFC_PN544=y
# CONFIG_NFC_PN544_I2C is not set
CONFIG_NFC_MICROREAD=m
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_NFC_MRVL=m
# CONFIG_NFC_MRVL_USB is not set
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
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
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
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
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
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
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
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
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
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
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
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_AHCI_IMX is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_HIGHBANK=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=m
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
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
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
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
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
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
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
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
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TWL4030=m
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
# CONFIG_VIDEO_PVRUSB2_SYSFS is not set
# CONFIG_VIDEO_PVRUSB2_DVB is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
# CONFIG_DVB_USB_ANYSEE is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_AZ6007 is not set
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_IT913X is not set
# CONFIG_DVB_USB_MXL111SF is not set
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=m
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=m
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
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=m
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=m
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=y
# CONFIG_DVB_STV090x is not set
CONFIG_DVB_STV6110x=y
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=m
# CONFIG_DVB_ZL10036 is not set
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
CONFIG_DVB_SP887X=y
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=y
# CONFIG_DVB_DRXD is not set
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=m
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=y
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
CONFIG_DVB_TUNER_DIB0070=m
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

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
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
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
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_HECUBA=y
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
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

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
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
# CONFIG_USB_MUSB_TUSB6010 is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
CONFIG_USB_DWC3_EXYNOS=m
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

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
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=m
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=m
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=m
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_FS=m
# CONFIG_USB_CONFIGFS is not set
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_GADGET_TARGET=m
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=m
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_ECHO=y
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
# CONFIG_COMEDI_BOND is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_RTS5139=y
CONFIG_RTS5139_DEBUG=y
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_DX_SEP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=m
# CONFIG_FT1000_USB is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_USB_MSI3101 is not set
CONFIG_USB_SN9C102=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_WIMAX_GDM72XX_USB_PM=y
# CONFIG_LTE_GDM724X is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX8997=m
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=m
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=m
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
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
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
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
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
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
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

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
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
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
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
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
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
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
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_CCP is not set
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
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
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
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--CE+1k2dSO48ffgeK--
